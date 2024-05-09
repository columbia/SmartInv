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
269 // File: @openzeppelin\contracts\token\ERC20\ERC20.sol
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
501 // File: @openzeppelin\contracts\access\Roles.sol
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
540 // File: @openzeppelin\contracts\ownership\Ownable.sol
541 
542 pragma solidity ^0.5.0;
543 
544 /**
545  * @dev Contract module which provides a basic access control mechanism, where
546  * there is an account (an owner) that can be granted exclusive access to
547  * specific functions.
548  *
549  * This module is used through inheritance. It will make available the modifier
550  * `onlyOwner`, which can be applied to your functions to restrict their use to
551  * the owner.
552  */
553 contract Ownable is Context {
554     address private _owner;
555 
556     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
557 
558     /**
559      * @dev Initializes the contract setting the deployer as the initial owner.
560      */
561     constructor () internal {
562         address msgSender = _msgSender();
563         _owner = msgSender;
564         emit OwnershipTransferred(address(0), msgSender);
565     }
566 
567     /**
568      * @dev Returns the address of the current owner.
569      */
570     function owner() public view returns (address) {
571         return _owner;
572     }
573 
574     /**
575      * @dev Throws if called by any account other than the owner.
576      */
577     modifier onlyOwner() {
578         require(isOwner(), "Ownable: caller is not the owner");
579         _;
580     }
581 
582     /**
583      * @dev Returns true if the caller is the current owner.
584      */
585     function isOwner() public view returns (bool) {
586         return _msgSender() == _owner;
587     }
588 
589     /**
590      * @dev Leaves the contract without owner. It will not be possible to call
591      * `onlyOwner` functions anymore. Can only be called by the current owner.
592      *
593      * NOTE: Renouncing ownership will leave the contract without an owner,
594      * thereby removing any functionality that is only available to the owner.
595      */
596     function renounceOwnership() public onlyOwner {
597         emit OwnershipTransferred(_owner, address(0));
598         _owner = address(0);
599     }
600 
601     /**
602      * @dev Transfers ownership of the contract to a new account (`newOwner`).
603      * Can only be called by the current owner.
604      */
605     function transferOwnership(address newOwner) public onlyOwner {
606         _transferOwnership(newOwner);
607     }
608 
609     /**
610      * @dev Transfers ownership of the contract to a new account (`newOwner`).
611      */
612     function _transferOwnership(address newOwner) internal {
613         require(newOwner != address(0), "Ownable: new owner is the zero address");
614         emit OwnershipTransferred(_owner, newOwner);
615         _owner = newOwner;
616     }
617 }
618 
619 // File: contracts\ControlledPauserRole.sol
620 
621 pragma solidity ^0.5.0;
622 
623 
624 
625 contract ControlledPauserRole is Ownable {
626     using Roles for Roles.Role;
627 
628     event PauserAdded(address indexed account);
629     event PauserRemoved(address indexed account);
630 
631     Roles.Role private _pausers;
632 
633     constructor () internal {
634         _addPauser(_msgSender());
635     }
636 
637     modifier onlyPauser() {
638         require(isPauser(_msgSender()), "ControlledPauserRole: caller does not have the Pauser role");
639         _;
640     }
641 
642     function isPauser(address account) public view returns (bool) {
643         return _pausers.has(account);
644     }
645 
646     // onlyPauser -> onlyOwner
647     function addPauser(address account) public onlyOwner {
648         _addPauser(account);
649     }
650 
651     // Add require()
652     function renouncePauser() public {
653         require(!isOwner(), "ControlledPauserRole: owner cannot renounce PauserRole");
654         _removePauser(_msgSender());
655     }
656 
657     // new function
658     function revokePauser(address account) public onlyOwner {
659         require(account != owner(), "ControlledPauserRole: owner cannot renounce PauserRole");
660         _removePauser(account);
661     }
662 
663     function _addPauser(address account) internal {
664         _pausers.add(account);
665         emit PauserAdded(account);
666     }
667 
668     function _removePauser(address account) internal {
669         _pausers.remove(account);
670         emit PauserRemoved(account);
671     }
672 }
673 
674 // File: contracts\ControlledPausable.sol
675 
676 pragma solidity ^0.5.0;
677 
678 
679 /**
680  * @dev Contract module which allows children to implement an emergency stop
681  * mechanism that can be triggered by an authorized account.
682  *
683  * This module is used through inheritance. It will make available the
684  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
685  * the functions of your contract. Note that they will not be pausable by
686  * simply including this module, only once the modifiers are put in place.
687  */
688 contract ControlledPausable is ControlledPauserRole {
689     /**
690      * @dev Emitted when the pause is triggered by a pauser (`account`).
691      */
692     event Paused(address account);
693 
694     /**
695      * @dev Emitted when the pause is lifted by a pauser (`account`).
696      */
697     event Unpaused(address account);
698 
699     bool private _paused;
700 
701     /**
702      * @dev Initializes the contract in unpaused state. Assigns the Pauser role
703      * to the deployer.
704      */
705     constructor () internal {
706         _paused = false;
707     }
708 
709     /**
710      * @dev Returns true if the contract is paused, and false otherwise.
711      */
712     function paused() public view returns (bool) {
713         return _paused;
714     }
715 
716     /**
717      * @dev Modifier to make a function callable only when the contract is not paused.
718      */
719     modifier whenNotPaused() {
720         require(!_paused, "Pausable: paused");
721         _;
722     }
723 
724     /**
725      * @dev Modifier to make a function callable only when the contract is paused.
726      */
727     modifier whenPaused() {
728         require(_paused, "Pausable: not paused");
729         _;
730     }
731 
732     /**
733      * @dev Called by a pauser to pause, triggers stopped state.
734      */
735     function pause() public onlyPauser whenNotPaused {
736         _paused = true;
737         emit Paused(_msgSender());
738     }
739 
740     /**
741      * @dev Called by a pauser to unpause, returns to normal state.
742      */
743     function unpause() public onlyPauser whenPaused {
744         _paused = false;
745         emit Unpaused(_msgSender());
746     }
747 }
748 
749 // File: contracts\ControlledERC20Pausable.sol
750 
751 pragma solidity ^0.5.0;
752 
753 
754 
755 /**
756  * @title Pausable token
757  * @dev ERC20 with pausable transfers and allowances.
758  *
759  * Useful if you want to stop trades until the end of a crowdsale, or have
760  * an emergency switch for freezing all token transfers in the event of a large
761  * bug.
762  */
763 contract ControlledERC20Pausable is ERC20, ControlledPausable {
764     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
765         return super.transfer(to, value);
766     }
767 
768     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
769         return super.transferFrom(from, to, value);
770     }
771 
772     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
773         return super.approve(spender, value);
774     }
775 
776     function increaseAllowance(address spender, uint256 addedValue) public whenNotPaused returns (bool) {
777         return super.increaseAllowance(spender, addedValue);
778     }
779 
780     function decreaseAllowance(address spender, uint256 subtractedValue) public whenNotPaused returns (bool) {
781         return super.decreaseAllowance(spender, subtractedValue);
782     }
783 }
784 
785 // File: contracts\ControlledWhitelistAdminRole.sol
786 
787 pragma solidity ^0.5.0;
788 
789 
790 
791 contract ControlledWhitelistAdminRole is Ownable {
792     using Roles for Roles.Role;
793 
794     event WhitelistAdminAdded(address indexed account);
795     event WhitelistAdminRemoved(address indexed account);
796 
797     Roles.Role private _whitelistAdmins;
798 
799     constructor () internal {
800         _addWhitelistAdmin(_msgSender());
801     }
802 
803     modifier onlyWhitelistAdmin() {
804         require(isWhitelistAdmin(_msgSender()), "ControlledWhitelistAdminRole: caller does not have the WhitelistAdmin role");
805         _;
806     }
807 
808     function isWhitelistAdmin(address account) public view returns (bool) {
809         return _whitelistAdmins.has(account);
810     }
811 
812     // onlyWhitelistAdmin -> onlyOwner
813     function addWhitelistAdmin(address account) public onlyOwner {
814         _addWhitelistAdmin(account);
815     }
816 
817     // Add require()
818     function renounceWhitelistAdmin() public {
819         require(!isOwner(), "ControlledWhitelistAdminRole: owner cannot renounce WhitelistAdminRole");
820         _removeWhitelistAdmin(_msgSender());
821     }
822 
823     // new function
824     function revokeWhitelistAdmin(address account) public onlyOwner {
825         require(account != owner(), "ControlledWhitelistAdminRole: owner cannot renounce WhitelistAdminRole");
826         _removeWhitelistAdmin(account);
827     }
828 
829     function _addWhitelistAdmin(address account) internal {
830         _whitelistAdmins.add(account);
831         emit WhitelistAdminAdded(account);
832     }
833 
834     function _removeWhitelistAdmin(address account) internal {
835         _whitelistAdmins.remove(account);
836         emit WhitelistAdminRemoved(account);
837     }
838 }
839 
840 // File: contracts\IndividualLockableToken.sol
841 
842 pragma solidity ^0.5.0;
843 
844 
845 
846 contract IndividualLockableToken is ControlledERC20Pausable, ControlledWhitelistAdminRole{
847   using SafeMath for uint256;
848 
849   event LockTimeSetted(address indexed holder, uint256 old_release_time, uint256 new_release_time);
850   event Locked(address indexed holder, uint256 locked_balance_change, uint256 total_locked_balance, uint256 release_time);
851 
852   struct lockState {
853     uint256 locked_balance;
854     uint256 release_time;
855   }
856 
857   // default lock period
858   uint256 public lock_period = 4 weeks;
859 
860   mapping(address => lockState) internal userLock;
861 
862   // Specify the time that a particular person's lock will be released
863   function setReleaseTime(address _holder, uint256 _release_time)
864     public
865     onlyWhitelistAdmin
866     returns (bool)
867   {
868     require(_holder != address(0));
869     require(_release_time >= block.timestamp);
870 
871     uint256 old_release_time = userLock[_holder].release_time;
872 
873     userLock[_holder].release_time = _release_time;
874     emit LockTimeSetted(_holder, old_release_time, userLock[_holder].release_time);
875     return true;
876   }
877 
878   // Returns the point at which token holder's lock is released
879   function getReleaseTime(address _holder)
880     public
881     view
882     returns (uint256)
883   {
884     require(_holder != address(0));
885 
886     return userLock[_holder].release_time;
887   }
888 
889   // Unlock a specific person. Free trading even with a lock balance
890   function clearReleaseTime(address _holder)
891     public
892     onlyWhitelistAdmin
893     returns (bool)
894   {
895     require(_holder != address(0));
896     require(userLock[_holder].release_time > 0);
897 
898     uint256 old_release_time = userLock[_holder].release_time;
899 
900     userLock[_holder].release_time = 0;
901     emit LockTimeSetted(_holder, old_release_time, userLock[_holder].release_time);
902     return true;
903   }
904 
905   // Increase the lock balance of a specific person.
906   // If you only want to increase the balance, the release_time must be specified in advance.
907   function increaseLockBalance(address _holder, uint256 _value)
908     public
909     onlyWhitelistAdmin
910     returns (bool)
911   {
912     require(_holder != address(0));
913     require(_value > 0);
914     require(getFreeBalance(_holder) >= _value);
915 
916     if (userLock[_holder].release_time <= block.timestamp) {
917         userLock[_holder].release_time  = block.timestamp + lock_period;
918     }
919 
920     userLock[_holder].locked_balance = (userLock[_holder].locked_balance).add(_value);
921     emit Locked(_holder, _value, userLock[_holder].locked_balance, userLock[_holder].release_time);
922     return true;
923   }
924 
925   // Increase the lock balance and release time of a specific person.
926   // If you only want to increase the balance, See increaseLockBalance function.
927   function increaseLockBalanceWithReleaseTime(address _holder, uint256 _value, uint256 _release_time)
928     public
929     onlyWhitelistAdmin
930     returns (bool)
931   {
932     require(_holder != address(0));
933     require(_value > 0);
934     require(getFreeBalance(_holder) >= _value);
935     require(_release_time >= block.timestamp);
936 
937     uint256 old_release_time = userLock[_holder].release_time;
938 
939     userLock[_holder].release_time = _release_time;
940     emit LockTimeSetted(_holder, old_release_time, userLock[_holder].release_time);
941 
942     userLock[_holder].locked_balance = (userLock[_holder].locked_balance).add(_value);
943     emit Locked(_holder, _value, userLock[_holder].locked_balance, userLock[_holder].release_time);
944     return true;
945   }
946 
947   // Decrease the lock balance of a specific person.
948   function decreaseLockBalance(address _holder, uint256 _value)
949     public
950     onlyWhitelistAdmin
951     returns (bool)
952   {
953     require(_holder != address(0));
954     require(_value > 0);
955     require(userLock[_holder].locked_balance >= _value);
956 
957     userLock[_holder].locked_balance = (userLock[_holder].locked_balance).sub(_value);
958     emit Locked(_holder, _value, userLock[_holder].locked_balance, userLock[_holder].release_time);
959     return true;
960   }
961 
962   // Clear the lock.
963   function clearLock(address _holder)
964     public
965     onlyWhitelistAdmin
966     returns (bool)
967   {
968     require(_holder != address(0));
969     
970     userLock[_holder].locked_balance = 0;
971     userLock[_holder].release_time = 0;
972     emit Locked(_holder, 0, userLock[_holder].locked_balance, userLock[_holder].release_time);
973     return true;
974   }
975 
976   // Check the amount of the lock
977   function getLockedBalance(address _holder)
978     public
979     view
980     returns (uint256)
981   {
982     if(block.timestamp >= userLock[_holder].release_time) return uint256(0);
983     return userLock[_holder].locked_balance;
984   }
985 
986   // Check your remaining balance
987   function getFreeBalance(address _holder)
988     public
989     view
990     returns (uint256)
991   {
992     if(block.timestamp    >= userLock[_holder].release_time  ) return balanceOf(_holder);
993     if(balanceOf(_holder) <= userLock[_holder].locked_balance) return uint256(0);
994     return balanceOf(_holder).sub(userLock[_holder].locked_balance);
995   }
996 
997   // transfer overrride
998   function transfer(
999     address _to,
1000     uint256 _value
1001   )
1002     public
1003     returns (bool)
1004   {
1005     require(getFreeBalance(_msgSender()) >= _value);
1006     return super.transfer(_to, _value);
1007   }
1008 
1009   // transferFrom overrride
1010   function transferFrom(
1011     address _from,
1012     address _to,
1013     uint256 _value
1014   )
1015     public
1016     returns (bool)
1017   {
1018     require(getFreeBalance(_from) >= _value);
1019     return super.transferFrom(_from, _to, _value);
1020   }
1021 
1022   // approve overrride
1023   function approve(
1024     address _spender,
1025     uint256 _value
1026   )
1027     public
1028     returns (bool)
1029   {
1030     require(getFreeBalance(_msgSender()) >= _value);
1031     return super.approve(_spender, _value);
1032   }
1033 
1034   // increaseAllowance overrride
1035   function increaseAllowance(
1036     address _spender,
1037     uint _addedValue
1038   )
1039     public
1040     returns (bool success)
1041   {
1042     require(getFreeBalance(_msgSender()) >= allowance(_msgSender(), _spender).add(_addedValue));
1043     return super.increaseAllowance(_spender, _addedValue);
1044   }
1045 
1046   // decreaseAllowance overrride
1047   function decreaseAllowance(
1048     address _spender,
1049     uint _subtractedValue
1050   )
1051     public
1052     returns (bool success)
1053   {
1054     uint256 oldValue = allowance(_msgSender(), _spender);
1055 
1056     if (_subtractedValue < oldValue) {
1057       require(getFreeBalance(_msgSender()) >= oldValue.sub(_subtractedValue));
1058     }
1059     return super.decreaseAllowance(_spender, _subtractedValue);
1060   }
1061 }
1062 
1063 // File: contracts\EcoCarbonCoin.sol
1064 
1065 pragma solidity ^0.5.0;
1066 
1067 
1068 contract EcoCarbonCoin is IndividualLockableToken {
1069 	using SafeMath for uint256;
1070 
1071 	string public constant name     = "Eco Carbon Coin";
1072 	string public constant symbol   = "ECC";
1073 	uint8  public constant decimals = 18;
1074 
1075 	uint256 public constant INITIAL_SUPPLY  = 1000000000 * (10 ** uint256(decimals));
1076 	
1077 	constructor()
1078 		public
1079 	{
1080 		_mint(_msgSender(), INITIAL_SUPPLY);
1081 	}
1082 
1083 	function renounceOwnership()
1084 		public
1085 		onlyOwner
1086 	{
1087 		revert("The owner cannot release ownership.");
1088 	}
1089 	
1090 	function transferOwnership(address newOwner)
1091 		public
1092 		onlyOwner
1093 	{
1094 		require(newOwner != address(0));
1095 		require(newOwner != owner());
1096 
1097 		addPauser(newOwner);
1098 		addWhitelistAdmin(newOwner);
1099 		super.transferOwnership(newOwner);
1100 		renouncePauser();
1101 		renounceWhitelistAdmin();
1102 	}
1103 }