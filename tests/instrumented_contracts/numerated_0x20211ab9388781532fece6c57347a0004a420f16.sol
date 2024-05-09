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
596 // File: @openzeppelin/contracts/access/roles/MinterRole.sol
597 
598 pragma solidity ^0.5.0;
599 
600 
601 
602 contract MinterRole is Context {
603     using Roles for Roles.Role;
604 
605     event MinterAdded(address indexed account);
606     event MinterRemoved(address indexed account);
607 
608     Roles.Role private _minters;
609 
610     constructor () internal {
611         _addMinter(_msgSender());
612     }
613 
614     modifier onlyMinter() {
615         require(isMinter(_msgSender()), "MinterRole: caller does not have the Minter role");
616         _;
617     }
618 
619     function isMinter(address account) public view returns (bool) {
620         return _minters.has(account);
621     }
622 
623     function addMinter(address account) public onlyMinter {
624         _addMinter(account);
625     }
626 
627     function renounceMinter() public {
628         _removeMinter(_msgSender());
629     }
630 
631     function _addMinter(address account) internal {
632         _minters.add(account);
633         emit MinterAdded(account);
634     }
635 
636     function _removeMinter(address account) internal {
637         _minters.remove(account);
638         emit MinterRemoved(account);
639     }
640 }
641 
642 // File: @openzeppelin/contracts/token/ERC20/ERC20Mintable.sol
643 
644 pragma solidity ^0.5.0;
645 
646 
647 
648 /**
649  * @dev Extension of {ERC20} that adds a set of accounts with the {MinterRole},
650  * which have permission to mint (create) new tokens as they see fit.
651  *
652  * At construction, the deployer of the contract is the only minter.
653  */
654 contract ERC20Mintable is ERC20, MinterRole {
655     /**
656      * @dev See {ERC20-_mint}.
657      *
658      * Requirements:
659      *
660      * - the caller must have the {MinterRole}.
661      */
662     function mint(address account, uint256 amount) public onlyMinter returns (bool) {
663         _mint(account, amount);
664         return true;
665     }
666 }
667 
668 // File: @openzeppelin/contracts/access/roles/PauserRole.sol
669 
670 pragma solidity ^0.5.0;
671 
672 
673 
674 contract PauserRole is Context {
675     using Roles for Roles.Role;
676 
677     event PauserAdded(address indexed account);
678     event PauserRemoved(address indexed account);
679 
680     Roles.Role private _pausers;
681 
682     constructor () internal {
683         _addPauser(_msgSender());
684     }
685 
686     modifier onlyPauser() {
687         require(isPauser(_msgSender()), "PauserRole: caller does not have the Pauser role");
688         _;
689     }
690 
691     function isPauser(address account) public view returns (bool) {
692         return _pausers.has(account);
693     }
694 
695     function addPauser(address account) public onlyPauser {
696         _addPauser(account);
697     }
698 
699     function renouncePauser() public {
700         _removePauser(_msgSender());
701     }
702 
703     function _addPauser(address account) internal {
704         _pausers.add(account);
705         emit PauserAdded(account);
706     }
707 
708     function _removePauser(address account) internal {
709         _pausers.remove(account);
710         emit PauserRemoved(account);
711     }
712 }
713 
714 // File: @openzeppelin/contracts/lifecycle/Pausable.sol
715 
716 pragma solidity ^0.5.0;
717 
718 
719 
720 /**
721  * @dev Contract module which allows children to implement an emergency stop
722  * mechanism that can be triggered by an authorized account.
723  *
724  * This module is used through inheritance. It will make available the
725  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
726  * the functions of your contract. Note that they will not be pausable by
727  * simply including this module, only once the modifiers are put in place.
728  */
729 contract Pausable is Context, PauserRole {
730     /**
731      * @dev Emitted when the pause is triggered by a pauser (`account`).
732      */
733     event Paused(address account);
734 
735     /**
736      * @dev Emitted when the pause is lifted by a pauser (`account`).
737      */
738     event Unpaused(address account);
739 
740     bool private _paused;
741 
742     /**
743      * @dev Initializes the contract in unpaused state. Assigns the Pauser role
744      * to the deployer.
745      */
746     constructor () internal {
747         _paused = false;
748     }
749 
750     /**
751      * @dev Returns true if the contract is paused, and false otherwise.
752      */
753     function paused() public view returns (bool) {
754         return _paused;
755     }
756 
757     /**
758      * @dev Modifier to make a function callable only when the contract is not paused.
759      */
760     modifier whenNotPaused() {
761         require(!_paused, "Pausable: paused");
762         _;
763     }
764 
765     /**
766      * @dev Modifier to make a function callable only when the contract is paused.
767      */
768     modifier whenPaused() {
769         require(_paused, "Pausable: not paused");
770         _;
771     }
772 
773     /**
774      * @dev Called by a pauser to pause, triggers stopped state.
775      */
776     function pause() public onlyPauser whenNotPaused {
777         _paused = true;
778         emit Paused(_msgSender());
779     }
780 
781     /**
782      * @dev Called by a pauser to unpause, returns to normal state.
783      */
784     function unpause() public onlyPauser whenPaused {
785         _paused = false;
786         emit Unpaused(_msgSender());
787     }
788 }
789 
790 // File: @openzeppelin/contracts/token/ERC20/ERC20Pausable.sol
791 
792 pragma solidity ^0.5.0;
793 
794 
795 
796 /**
797  * @title Pausable token
798  * @dev ERC20 with pausable transfers and allowances.
799  *
800  * Useful if you want to stop trades until the end of a crowdsale, or have
801  * an emergency switch for freezing all token transfers in the event of a large
802  * bug.
803  */
804 contract ERC20Pausable is ERC20, Pausable {
805     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
806         return super.transfer(to, value);
807     }
808 
809     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
810         return super.transferFrom(from, to, value);
811     }
812 
813     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
814         return super.approve(spender, value);
815     }
816 
817     function increaseAllowance(address spender, uint256 addedValue) public whenNotPaused returns (bool) {
818         return super.increaseAllowance(spender, addedValue);
819     }
820 
821     function decreaseAllowance(address spender, uint256 subtractedValue) public whenNotPaused returns (bool) {
822         return super.decreaseAllowance(spender, subtractedValue);
823     }
824 }
825 
826 // File: @openzeppelin/contracts/utils/Address.sol
827 
828 pragma solidity ^0.5.5;
829 
830 /**
831  * @dev Collection of functions related to the address type
832  */
833 library Address {
834     /**
835      * @dev Returns true if `account` is a contract.
836      *
837      * [IMPORTANT]
838      * ====
839      * It is unsafe to assume that an address for which this function returns
840      * false is an externally-owned account (EOA) and not a contract.
841      *
842      * Among others, `isContract` will return false for the following 
843      * types of addresses:
844      *
845      *  - an externally-owned account
846      *  - a contract in construction
847      *  - an address where a contract will be created
848      *  - an address where a contract lived, but was destroyed
849      * ====
850      */
851     function isContract(address account) internal view returns (bool) {
852         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
853         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
854         // for accounts without code, i.e. `keccak256('')`
855         bytes32 codehash;
856         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
857         // solhint-disable-next-line no-inline-assembly
858         assembly { codehash := extcodehash(account) }
859         return (codehash != accountHash && codehash != 0x0);
860     }
861 
862     /**
863      * @dev Converts an `address` into `address payable`. Note that this is
864      * simply a type cast: the actual underlying value is not changed.
865      *
866      * _Available since v2.4.0._
867      */
868     function toPayable(address account) internal pure returns (address payable) {
869         return address(uint160(account));
870     }
871 
872     /**
873      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
874      * `recipient`, forwarding all available gas and reverting on errors.
875      *
876      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
877      * of certain opcodes, possibly making contracts go over the 2300 gas limit
878      * imposed by `transfer`, making them unable to receive funds via
879      * `transfer`. {sendValue} removes this limitation.
880      *
881      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
882      *
883      * IMPORTANT: because control is transferred to `recipient`, care must be
884      * taken to not create reentrancy vulnerabilities. Consider using
885      * {ReentrancyGuard} or the
886      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
887      *
888      * _Available since v2.4.0._
889      */
890     function sendValue(address payable recipient, uint256 amount) internal {
891         require(address(this).balance >= amount, "Address: insufficient balance");
892 
893         // solhint-disable-next-line avoid-call-value
894         (bool success, ) = recipient.call.value(amount)("");
895         require(success, "Address: unable to send value, recipient may have reverted");
896     }
897 }
898 
899 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
900 
901 pragma solidity ^0.5.0;
902 
903 
904 
905 
906 /**
907  * @title SafeERC20
908  * @dev Wrappers around ERC20 operations that throw on failure (when the token
909  * contract returns false). Tokens that return no value (and instead revert or
910  * throw on failure) are also supported, non-reverting calls are assumed to be
911  * successful.
912  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
913  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
914  */
915 library SafeERC20 {
916     using SafeMath for uint256;
917     using Address for address;
918 
919     function safeTransfer(IERC20 token, address to, uint256 value) internal {
920         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
921     }
922 
923     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
924         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
925     }
926 
927     function safeApprove(IERC20 token, address spender, uint256 value) internal {
928         // safeApprove should only be called when setting an initial allowance,
929         // or when resetting it to zero. To increase and decrease it, use
930         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
931         // solhint-disable-next-line max-line-length
932         require((value == 0) || (token.allowance(address(this), spender) == 0),
933             "SafeERC20: approve from non-zero to non-zero allowance"
934         );
935         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
936     }
937 
938     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
939         uint256 newAllowance = token.allowance(address(this), spender).add(value);
940         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
941     }
942 
943     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
944         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
945         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
946     }
947 
948     /**
949      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
950      * on the return value: the return value is optional (but if data is returned, it must not be false).
951      * @param token The token targeted by the call.
952      * @param data The call data (encoded using abi.encode or one of its variants).
953      */
954     function callOptionalReturn(IERC20 token, bytes memory data) private {
955         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
956         // we're implementing it ourselves.
957 
958         // A Solidity high level call has three parts:
959         //  1. The target address is checked to verify it contains contract code
960         //  2. The call itself is made, and success asserted
961         //  3. The return value is decoded, which in turn checks the size of the returned data.
962         // solhint-disable-next-line max-line-length
963         require(address(token).isContract(), "SafeERC20: call to non-contract");
964 
965         // solhint-disable-next-line avoid-low-level-calls
966         (bool success, bytes memory returndata) = address(token).call(data);
967         require(success, "SafeERC20: low-level call failed");
968 
969         if (returndata.length > 0) { // Return data is optional
970             // solhint-disable-next-line max-line-length
971             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
972         }
973     }
974 }
975 
976 // File: @openzeppelin/contracts/token/ERC20/TokenTimelock.sol
977 
978 pragma solidity ^0.5.0;
979 
980 
981 /**
982  * @dev A token holder contract that will allow a beneficiary to extract the
983  * tokens after a given release time.
984  *
985  * Useful for simple vesting schedules like "advisors get all of their tokens
986  * after 1 year".
987  *
988  * For a more complete vesting schedule, see {TokenVesting}.
989  */
990 contract TokenTimelock {
991     using SafeERC20 for IERC20;
992 
993     // ERC20 basic token contract being held
994     IERC20 private _token;
995 
996     // beneficiary of tokens after they are released
997     address private _beneficiary;
998 
999     // timestamp when token release is enabled
1000     uint256 private _releaseTime;
1001 
1002     constructor (IERC20 token, address beneficiary, uint256 releaseTime) public {
1003         // solhint-disable-next-line not-rely-on-time
1004         require(releaseTime > block.timestamp, "TokenTimelock: release time is before current time");
1005         _token = token;
1006         _beneficiary = beneficiary;
1007         _releaseTime = releaseTime;
1008     }
1009 
1010     /**
1011      * @return the token being held.
1012      */
1013     function token() public view returns (IERC20) {
1014         return _token;
1015     }
1016 
1017     /**
1018      * @return the beneficiary of the tokens.
1019      */
1020     function beneficiary() public view returns (address) {
1021         return _beneficiary;
1022     }
1023 
1024     /**
1025      * @return the time when the tokens are released.
1026      */
1027     function releaseTime() public view returns (uint256) {
1028         return _releaseTime;
1029     }
1030 
1031     /**
1032      * @notice Transfers tokens held by timelock to beneficiary.
1033      */
1034     function release() public {
1035         // solhint-disable-next-line not-rely-on-time
1036         require(block.timestamp >= _releaseTime, "TokenTimelock: current time is before release time");
1037 
1038         uint256 amount = _token.balanceOf(address(this));
1039         require(amount > 0, "TokenTimelock: no tokens to release");
1040 
1041         _token.safeTransfer(_beneficiary, amount);
1042     }
1043 }
1044 
1045 // File: contracts/ENCXToken.sol
1046 
1047 pragma solidity ^0.5.0;
1048 
1049 
1050 
1051 
1052 
1053 
1054 contract ENCXToken is ERC20, ERC20Detailed, ERC20Mintable, ERC20Pausable {
1055     // Token time lock
1056     TokenTimelock public teamTimelock;
1057     uint256 public teamReleaseTime;
1058     constructor(address wallet, uint256 _teamReleaseTime) ERC20Detailed("Enceladus Network", "ENCX", 18) public {
1059         teamReleaseTime = _teamReleaseTime;
1060         //Liquidity 	64,000,000
1061         _mint(wallet, 64000000 * 10 ** 18);
1062         teamTimelock = new TokenTimelock(this, wallet, teamReleaseTime);
1063         _mint(address(teamTimelock), 20000000 * 10 ** 18);
1064     }
1065     function releaseTeamLock() public {
1066         teamTimelock.release();
1067     }
1068 }