1 // File: openzeppelin-solidity/contracts/GSN/Context.sol
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
31 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
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
110 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
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
269 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
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
501 // File: openzeppelin-solidity/contracts/access/Roles.sol
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
540 // File: openzeppelin-solidity/contracts/access/roles/PauserRole.sol
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
586 // File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol
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
662 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Pausable.sol
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
698 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
699 
700 pragma solidity ^0.5.0;
701 
702 /**
703  * @dev Contract module which provides a basic access control mechanism, where
704  * there is an account (an owner) that can be granted exclusive access to
705  * specific functions.
706  *
707  * This module is used through inheritance. It will make available the modifier
708  * `onlyOwner`, which can be applied to your functions to restrict their use to
709  * the owner.
710  */
711 contract Ownable is Context {
712     address private _owner;
713 
714     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
715 
716     /**
717      * @dev Initializes the contract setting the deployer as the initial owner.
718      */
719     constructor () internal {
720         address msgSender = _msgSender();
721         _owner = msgSender;
722         emit OwnershipTransferred(address(0), msgSender);
723     }
724 
725     /**
726      * @dev Returns the address of the current owner.
727      */
728     function owner() public view returns (address) {
729         return _owner;
730     }
731 
732     /**
733      * @dev Throws if called by any account other than the owner.
734      */
735     modifier onlyOwner() {
736         require(isOwner(), "Ownable: caller is not the owner");
737         _;
738     }
739 
740     /**
741      * @dev Returns true if the caller is the current owner.
742      */
743     function isOwner() public view returns (bool) {
744         return _msgSender() == _owner;
745     }
746 
747     /**
748      * @dev Leaves the contract without owner. It will not be possible to call
749      * `onlyOwner` functions anymore. Can only be called by the current owner.
750      *
751      * NOTE: Renouncing ownership will leave the contract without an owner,
752      * thereby removing any functionality that is only available to the owner.
753      */
754     function renounceOwnership() public onlyOwner {
755         emit OwnershipTransferred(_owner, address(0));
756         _owner = address(0);
757     }
758 
759     /**
760      * @dev Transfers ownership of the contract to a new account (`newOwner`).
761      * Can only be called by the current owner.
762      */
763     function transferOwnership(address newOwner) public onlyOwner {
764         _transferOwnership(newOwner);
765     }
766 
767     /**
768      * @dev Transfers ownership of the contract to a new account (`newOwner`).
769      */
770     function _transferOwnership(address newOwner) internal {
771         require(newOwner != address(0), "Ownable: new owner is the zero address");
772         emit OwnershipTransferred(_owner, newOwner);
773         _owner = newOwner;
774     }
775 }
776 
777 // File: openzeppelin-solidity/contracts/utils/Address.sol
778 
779 pragma solidity ^0.5.0;
780 
781 /**
782  * @dev Collection of functions related to the address type
783  */
784 library Address {
785     /**
786      * @dev Returns true if `account` is a contract.
787      *
788      * [IMPORTANT]
789      * ====
790      * It is unsafe to assume that an address for which this function returns
791      * false is an externally-owned account (EOA) and not a contract.
792      *
793      * Among others, `isContract` will return false for the following 
794      * types of addresses:
795      *
796      *  - an externally-owned account
797      *  - a contract in construction
798      *  - an address where a contract will be created
799      *  - an address where a contract lived, but was destroyed
800      * ====
801      */
802     function isContract(address account) internal view returns (bool) {
803         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
804         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
805         // for accounts without code, i.e. `keccak256('')`
806         bytes32 codehash;
807         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
808         // solhint-disable-next-line no-inline-assembly
809         assembly { codehash := extcodehash(account) }
810         return (codehash != accountHash && codehash != 0x0);
811     }
812 
813     /**
814      * @dev Converts an `address` into `address payable`. Note that this is
815      * simply a type cast: the actual underlying value is not changed.
816      *
817      * _Available since v2.4.0._
818      */
819     function toPayable(address account) internal pure returns (address payable) {
820         return address(uint160(account));
821     }
822 
823     /**
824      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
825      * `recipient`, forwarding all available gas and reverting on errors.
826      *
827      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
828      * of certain opcodes, possibly making contracts go over the 2300 gas limit
829      * imposed by `transfer`, making them unable to receive funds via
830      * `transfer`. {sendValue} removes this limitation.
831      *
832      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
833      *
834      * IMPORTANT: because control is transferred to `recipient`, care must be
835      * taken to not create reentrancy vulnerabilities. Consider using
836      * {ReentrancyGuard} or the
837      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
838      *
839      * _Available since v2.4.0._
840      */
841     function sendValue(address payable recipient, uint256 amount) internal {
842         require(address(this).balance >= amount, "Address: insufficient balance");
843 
844         // solhint-disable-next-line avoid-call-value
845         (bool success, ) = recipient.call.value(amount)("");
846         require(success, "Address: unable to send value, recipient may have reverted");
847     }
848 }
849 
850 // File: openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol
851 
852 pragma solidity ^0.5.0;
853 
854 
855 
856 
857 /**
858  * @title SafeERC20
859  * @dev Wrappers around ERC20 operations that throw on failure (when the token
860  * contract returns false). Tokens that return no value (and instead revert or
861  * throw on failure) are also supported, non-reverting calls are assumed to be
862  * successful.
863  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
864  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
865  */
866 library SafeERC20 {
867     using SafeMath for uint256;
868     using Address for address;
869 
870     function safeTransfer(IERC20 token, address to, uint256 value) internal {
871         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
872     }
873 
874     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
875         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
876     }
877 
878     function safeApprove(IERC20 token, address spender, uint256 value) internal {
879         // safeApprove should only be called when setting an initial allowance,
880         // or when resetting it to zero. To increase and decrease it, use
881         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
882         // solhint-disable-next-line max-line-length
883         require((value == 0) || (token.allowance(address(this), spender) == 0),
884             "SafeERC20: approve from non-zero to non-zero allowance"
885         );
886         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
887     }
888 
889     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
890         uint256 newAllowance = token.allowance(address(this), spender).add(value);
891         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
892     }
893 
894     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
895         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
896         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
897     }
898 
899     /**
900      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
901      * on the return value: the return value is optional (but if data is returned, it must not be false).
902      * @param token The token targeted by the call.
903      * @param data The call data (encoded using abi.encode or one of its variants).
904      */
905     function callOptionalReturn(IERC20 token, bytes memory data) private {
906         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
907         // we're implementing it ourselves.
908 
909         // A Solidity high level call has three parts:
910         //  1. The target address is checked to verify it contains contract code
911         //  2. The call itself is made, and success asserted
912         //  3. The return value is decoded, which in turn checks the size of the returned data.
913         // solhint-disable-next-line max-line-length
914         require(address(token).isContract(), "SafeERC20: call to non-contract");
915 
916         // solhint-disable-next-line avoid-low-level-calls
917         (bool success, bytes memory returndata) = address(token).call(data);
918         require(success, "SafeERC20: low-level call failed");
919 
920         if (returndata.length > 0) { // Return data is optional
921             // solhint-disable-next-line max-line-length
922             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
923         }
924     }
925 }
926 
927 // File: contracts/TokenLock.sol
928 
929 pragma solidity ^0.5.0;
930 
931 
932 contract TokenLock {
933   using SafeERC20 for IERC20;
934 
935   // ERC20 basic token contract being held
936   IERC20 private _token;
937 
938   // beneficiary of tokens after they are released
939   address private _beneficiary;
940 
941   // timestamp when token release is enabled
942   uint256 private _releaseTime;
943 
944   // generator of the tokenLock
945   address private _owner;
946   bool private _ownable;
947 
948   event UnLock(address _receiver, uint256 _amount);
949   event Retrieve(address _receiver, uint256 _amount);
950 
951   modifier onlyOwner() {
952     require(isOwnable());
953     require(msg.sender == _owner);
954     _;
955   }
956 
957   constructor(IERC20 token, address beneficiary, address owner, uint256 releaseTime, bool ownable) public {
958     _owner = owner;
959     _token = token;
960     _beneficiary = beneficiary;
961     _releaseTime = releaseTime;
962     _ownable = ownable;
963   }
964 
965   /**
966    * @return if this contract can be controlled by generator(owner)
967    */
968   function isOwnable() public view returns (bool) {
969     return _ownable;
970   }
971 
972   function owner() public view returns (address) {
973     return _owner;
974   }
975 
976   /**
977    * @return the token being held.
978    */
979   function token() public view returns (IERC20) {
980     return _token;
981   }
982 
983   /**
984    * @return the beneficiary of the tokens.
985    */
986   function beneficiary() public view returns (address) {
987     return _beneficiary;
988   }
989 
990   /**
991    * @return the time when the tokens are released.
992    */
993   function releaseTime() public view returns (uint256) {
994     return _releaseTime;
995   }
996 
997   /**
998    * @notice Transfers tokens held by timelock to beneficiary.
999    */
1000   function release() public {
1001     require(block.timestamp >= _releaseTime);
1002 
1003     uint256 amount = _token.balanceOf(address(this));
1004     require(amount > 0);
1005 
1006     _token.safeTransfer(_beneficiary, amount);
1007     emit UnLock(_beneficiary, amount);
1008   }
1009 
1010   /**
1011    * @notice Retrieve tokens held by timelock to generator(owner).
1012    */
1013   function retrieve() onlyOwner public {
1014     uint256 amount = _token.balanceOf(address(this));
1015     require(amount > 0);
1016 
1017     _token.safeTransfer(_owner, amount);
1018     emit Retrieve(_owner, amount);
1019   }
1020 }
1021 
1022 // File: contracts/AsterCoin.sol
1023 
1024 pragma solidity ^0.5.0; // using solidity 0.5.0 version 
1025 
1026 
1027 
1028 
1029 contract AsterCoin is ERC20Pausable, Ownable { // Contract 이름은 AsterCoin
1030   string public constant name = "ASTER COIN"; // token name
1031   string public constant symbol = "ATC"; // symbol name
1032   uint public constant decimals = 18; // 소수점 18자리까지 사용하겠다.
1033   uint public constant INITIAL_SUPPLY = 1000000000 * 10 ** decimals; // 초기 발행량은 1000000000.000000000000000000 이다.
1034 
1035 
1036   // Lock
1037   mapping (address => address) public lockStatus;
1038   event Lock(address _receiver, uint256 _amount);
1039 
1040   // Airdrop
1041   mapping (address => uint256) public airDropHistory;
1042   event AsterCoinAirDrop(address _receiver, uint256 _amount);
1043 
1044   constructor() public {
1045     _mint(msg.sender, INITIAL_SUPPLY);
1046   }
1047 
1048   function dropToken(address[] memory receivers, uint256[] memory values) public {
1049     require(receivers.length != 0);
1050     require(receivers.length == values.length);
1051 
1052     for (uint256 i = 0; i < receivers.length; i++) {
1053       address receiver = receivers[i];
1054       uint256 amount = values[i];
1055 
1056       transfer(receiver, amount);
1057       airDropHistory[receiver] += amount;
1058 
1059       emit AsterCoinAirDrop(receiver, amount);
1060     }
1061   }
1062 
1063 
1064   function lockToken(address beneficiary, uint256 amount, uint256 releaseTime, bool isOwnable) onlyOwner public {
1065     TokenLock lockContract = new TokenLock(this, beneficiary, msg.sender, releaseTime, isOwnable);
1066 
1067     transfer(address(lockContract), amount);
1068     lockStatus[beneficiary] = address(lockContract);
1069     emit Lock(beneficiary, amount);
1070   }
1071 }