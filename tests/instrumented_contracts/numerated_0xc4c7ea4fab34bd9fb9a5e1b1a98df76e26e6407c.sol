1 // File: @openzeppelin/contracts/GSN/Context.sol
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
31 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
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
110 // File: @openzeppelin/contracts/math/SafeMath.sol
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
269 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
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
501 // File: @openzeppelin/contracts/token/ERC20/ERC20Detailed.sol
502 
503 pragma solidity ^0.5.0;
504 
505 
506 /**
507  * @dev Optional functions from the ERC20 standard.
508  */
509 contract ERC20Detailed is IERC20 {
510     string private _name;
511     string private _symbol;
512     uint8 private _decimals;
513 
514     /**
515      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
516      * these values are immutable: they can only be set once during
517      * construction.
518      */
519     constructor (string memory name, string memory symbol, uint8 decimals) public {
520         _name = name;
521         _symbol = symbol;
522         _decimals = decimals;
523     }
524 
525     /**
526      * @dev Returns the name of the token.
527      */
528     function name() public view returns (string memory) {
529         return _name;
530     }
531 
532     /**
533      * @dev Returns the symbol of the token, usually a shorter version of the
534      * name.
535      */
536     function symbol() public view returns (string memory) {
537         return _symbol;
538     }
539 
540     /**
541      * @dev Returns the number of decimals used to get its user representation.
542      * For example, if `decimals` equals `2`, a balance of `505` tokens should
543      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
544      *
545      * Tokens usually opt for a value of 18, imitating the relationship between
546      * Ether and Wei.
547      *
548      * NOTE: This information is only used for _display_ purposes: it in
549      * no way affects any of the arithmetic of the contract, including
550      * {IERC20-balanceOf} and {IERC20-transfer}.
551      */
552     function decimals() public view returns (uint8) {
553         return _decimals;
554     }
555 }
556 
557 // File: @openzeppelin/contracts/access/Roles.sol
558 
559 pragma solidity ^0.5.0;
560 
561 /**
562  * @title Roles
563  * @dev Library for managing addresses assigned to a Role.
564  */
565 library Roles {
566     struct Role {
567         mapping (address => bool) bearer;
568     }
569 
570     /**
571      * @dev Give an account access to this role.
572      */
573     function add(Role storage role, address account) internal {
574         require(!has(role, account), "Roles: account already has role");
575         role.bearer[account] = true;
576     }
577 
578     /**
579      * @dev Remove an account's access to this role.
580      */
581     function remove(Role storage role, address account) internal {
582         require(has(role, account), "Roles: account does not have role");
583         role.bearer[account] = false;
584     }
585 
586     /**
587      * @dev Check if an account has this role.
588      * @return bool
589      */
590     function has(Role storage role, address account) internal view returns (bool) {
591         require(account != address(0), "Roles: account is the zero address");
592         return role.bearer[account];
593     }
594 }
595 
596 // File: @openzeppelin/contracts/access/roles/PauserRole.sol
597 
598 pragma solidity ^0.5.0;
599 
600 
601 
602 contract PauserRole is Context {
603     using Roles for Roles.Role;
604 
605     event PauserAdded(address indexed account);
606     event PauserRemoved(address indexed account);
607 
608     Roles.Role private _pausers;
609 
610     constructor () internal {
611         _addPauser(_msgSender());
612     }
613 
614     modifier onlyPauser() {
615         require(isPauser(_msgSender()), "PauserRole: caller does not have the Pauser role");
616         _;
617     }
618 
619     function isPauser(address account) public view returns (bool) {
620         return _pausers.has(account);
621     }
622 
623     function addPauser(address account) public onlyPauser {
624         _addPauser(account);
625     }
626 
627     function renouncePauser() public {
628         _removePauser(_msgSender());
629     }
630 
631     function _addPauser(address account) internal {
632         _pausers.add(account);
633         emit PauserAdded(account);
634     }
635 
636     function _removePauser(address account) internal {
637         _pausers.remove(account);
638         emit PauserRemoved(account);
639     }
640 }
641 
642 // File: @openzeppelin/contracts/lifecycle/Pausable.sol
643 
644 pragma solidity ^0.5.0;
645 
646 
647 
648 /**
649  * @dev Contract module which allows children to implement an emergency stop
650  * mechanism that can be triggered by an authorized account.
651  *
652  * This module is used through inheritance. It will make available the
653  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
654  * the functions of your contract. Note that they will not be pausable by
655  * simply including this module, only once the modifiers are put in place.
656  */
657 contract Pausable is Context, PauserRole {
658     /**
659      * @dev Emitted when the pause is triggered by a pauser (`account`).
660      */
661     event Paused(address account);
662 
663     /**
664      * @dev Emitted when the pause is lifted by a pauser (`account`).
665      */
666     event Unpaused(address account);
667 
668     bool private _paused;
669 
670     /**
671      * @dev Initializes the contract in unpaused state. Assigns the Pauser role
672      * to the deployer.
673      */
674     constructor () internal {
675         _paused = false;
676     }
677 
678     /**
679      * @dev Returns true if the contract is paused, and false otherwise.
680      */
681     function paused() public view returns (bool) {
682         return _paused;
683     }
684 
685     /**
686      * @dev Modifier to make a function callable only when the contract is not paused.
687      */
688     modifier whenNotPaused() {
689         require(!_paused, "Pausable: paused");
690         _;
691     }
692 
693     /**
694      * @dev Modifier to make a function callable only when the contract is paused.
695      */
696     modifier whenPaused() {
697         require(_paused, "Pausable: not paused");
698         _;
699     }
700 
701     /**
702      * @dev Called by a pauser to pause, triggers stopped state.
703      */
704     function pause() public onlyPauser whenNotPaused {
705         _paused = true;
706         emit Paused(_msgSender());
707     }
708 
709     /**
710      * @dev Called by a pauser to unpause, returns to normal state.
711      */
712     function unpause() public onlyPauser whenPaused {
713         _paused = false;
714         emit Unpaused(_msgSender());
715     }
716 }
717 
718 // File: @openzeppelin/contracts/ownership/Ownable.sol
719 
720 pragma solidity ^0.5.0;
721 
722 /**
723  * @dev Contract module which provides a basic access control mechanism, where
724  * there is an account (an owner) that can be granted exclusive access to
725  * specific functions.
726  *
727  * This module is used through inheritance. It will make available the modifier
728  * `onlyOwner`, which can be applied to your functions to restrict their use to
729  * the owner.
730  */
731 contract Ownable is Context {
732     address private _owner;
733 
734     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
735 
736     /**
737      * @dev Initializes the contract setting the deployer as the initial owner.
738      */
739     constructor () internal {
740         address msgSender = _msgSender();
741         _owner = msgSender;
742         emit OwnershipTransferred(address(0), msgSender);
743     }
744 
745     /**
746      * @dev Returns the address of the current owner.
747      */
748     function owner() public view returns (address) {
749         return _owner;
750     }
751 
752     /**
753      * @dev Throws if called by any account other than the owner.
754      */
755     modifier onlyOwner() {
756         require(isOwner(), "Ownable: caller is not the owner");
757         _;
758     }
759 
760     /**
761      * @dev Returns true if the caller is the current owner.
762      */
763     function isOwner() public view returns (bool) {
764         return _msgSender() == _owner;
765     }
766 
767     /**
768      * @dev Leaves the contract without owner. It will not be possible to call
769      * `onlyOwner` functions anymore. Can only be called by the current owner.
770      *
771      * NOTE: Renouncing ownership will leave the contract without an owner,
772      * thereby removing any functionality that is only available to the owner.
773      */
774     function renounceOwnership() public onlyOwner {
775         emit OwnershipTransferred(_owner, address(0));
776         _owner = address(0);
777     }
778 
779     /**
780      * @dev Transfers ownership of the contract to a new account (`newOwner`).
781      * Can only be called by the current owner.
782      */
783     function transferOwnership(address newOwner) public onlyOwner {
784         _transferOwnership(newOwner);
785     }
786 
787     /**
788      * @dev Transfers ownership of the contract to a new account (`newOwner`).
789      */
790     function _transferOwnership(address newOwner) internal {
791         require(newOwner != address(0), "Ownable: new owner is the zero address");
792         emit OwnershipTransferred(_owner, newOwner);
793         _owner = newOwner;
794     }
795 }
796 
797 // File: contracts/token/CocosToken.sol
798 
799 pragma solidity ^0.5.0;
800 
801 
802 
803 
804 
805 /// @title CocosToken Contract
806 /// For more information about this token please visit https://cocosbcx.io
807 
808 contract CocosToken is ERC20, ERC20Detailed, Pausable, Ownable  {
809     using SafeMath for uint;
810 
811     /// Constant token specific fields
812     uint8 public constant DECIMALS = 18;
813     uint256 public constant INITIAL_SUPPLY = 100000000 * (10 ** uint256(DECIMALS));
814 
815 
816     // black list
817     mapping(address => uint) blackAccountMap;
818     address[] public blackAccounts;
819 
820     // white list
821     mapping(address => uint) whiteAccountMap;
822     address[] public whiteAccounts;
823 
824     event TransferMuti(uint256 len, uint256 amount);
825 
826     event AddWhiteAccount(address indexed operator, address indexed whiteAccount);
827     event AddBlackAccount(address indexed operator, address indexed blackAccount);
828 
829     event DelWhiteAccount(address indexed operator, address indexed whiteAccount);
830     event DelBlackAccount(address indexed operator, address indexed blackAccount);
831 
832     modifier validAddress( address addr ) {
833         require(addr != address(0x0), "address is not 0x0");
834         require(addr != address(this), "address is not contract");
835         _;
836     }
837 
838 
839     /**
840      * CONSTRUCTOR
841      *
842      * @dev Initialize the Cocos Token
843      */
844 
845     constructor () public ERC20Detailed("CocosTokenV2", "COCOS", DECIMALS) {
846         pause();
847         _mint(msg.sender, INITIAL_SUPPLY);
848     }
849 
850     function() external payable {
851         revert();
852     }
853 
854    function transfer(address _to, uint256 _value) public returns (bool)  {
855         if (paused() == true) {
856             // , only white list pass
857             require(whiteAccountMap[msg.sender] != 0, "contract is in paused, only in white list can transfer");
858         }
859         else {
860             // check black list
861             require(blackAccountMap[msg.sender] == 0,"address in black list, can't transfer");
862         }
863         return super.transfer(_to, _value);
864     }
865 
866     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
867         if (paused() == true) {
868             // frozen contract , only white list pass
869             require(whiteAccountMap[msg.sender] != 0, "contract is in  paused, can't transfer");
870             if (msg.sender != _from) {
871                 require(whiteAccountMap[_from] != 0, "contract is in  paused, can't transfer");
872             }
873         }
874         else {
875             // check black list
876             require(blackAccountMap[msg.sender] == 0, "address in black list, can't transfer");
877             if (msg.sender != _from) {
878                 require(blackAccountMap[_from] == 0,"address in black list, can't transfer");
879             }
880         }
881 
882         return super.transferFrom(_from, _to, _value);
883     }
884 
885     // people will transfer cocos to contract, fix it
886     function withdrawFromContract(address _to) public onlyOwner validAddress(_to) returns (bool)  {
887         uint256 contractBalance = balanceOf(address(this));
888         require(contractBalance > 0, "not enough balance");
889 
890         _transfer(address(this), _to, contractBalance);
891         return true;
892     }
893 
894 
895     function addWhiteAccount(address _whiteAccount) public
896         onlyOwner
897         validAddress(_whiteAccount){
898         require(whiteAccountMap[_whiteAccount]==0, "has in white list");
899 
900         uint256 index = whiteAccounts.length;
901         require(index < 4294967296, "white list is too long");
902 
903         whiteAccounts.length += 1;
904         whiteAccounts[index] = _whiteAccount;
905         
906         whiteAccountMap[_whiteAccount] = index + 1;
907         emit AddWhiteAccount(msg.sender,_whiteAccount);
908     }
909 
910     function delWhiteAccount(address _whiteAccount) public
911         onlyOwner
912         validAddress(_whiteAccount){
913         require(whiteAccountMap[_whiteAccount]!=0,"not in white list");
914 
915         uint256 index = whiteAccountMap[_whiteAccount];
916         if (index == whiteAccounts.length)
917         {
918             whiteAccounts.length -= 1;
919         }else{
920             address lastaddress = whiteAccounts[whiteAccounts.length-1];
921             whiteAccounts[index-1] = lastaddress;
922             whiteAccounts.length -= 1;
923             whiteAccountMap[lastaddress] = index;
924         }
925         delete whiteAccountMap[_whiteAccount];
926         emit DelWhiteAccount(msg.sender,_whiteAccount);
927     }
928 
929     function addBlackAccount(address _blackAccount) public
930         onlyOwner
931         validAddress(_blackAccount){
932         require(blackAccountMap[_blackAccount]==0,  "has in black list");
933 
934         uint256 index = blackAccounts.length;
935         require(index < 4294967296, "black list is too long");
936 
937         blackAccounts.length += 1;
938         blackAccounts[index] = _blackAccount;
939         blackAccountMap[_blackAccount] = index + 1;
940 
941         emit AddBlackAccount(msg.sender, _blackAccount);
942     }
943 
944     function delBlackAccount(address _blackAccount) public
945         onlyOwner
946         validAddress(_blackAccount){
947         require(blackAccountMap[_blackAccount]!=0,"not in black list");
948 
949         uint256 index = blackAccountMap[_blackAccount];
950         if (index == blackAccounts.length)
951         {
952             blackAccounts.length -= 1;
953         }else{
954             address lastaddress = blackAccounts[blackAccounts.length-1];
955             blackAccounts[index-1] = lastaddress;
956             blackAccounts.length -= 1;
957             blackAccountMap[lastaddress] = index;
958         }
959 
960         delete blackAccountMap[_blackAccount];
961         emit DelBlackAccount(msg.sender, _blackAccount);
962     }
963 
964 }