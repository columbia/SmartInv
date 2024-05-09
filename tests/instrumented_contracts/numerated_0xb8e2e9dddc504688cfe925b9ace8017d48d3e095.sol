1 // File: node_modules\@openzeppelin\contracts\token\ERC20\IERC20.sol
2 
3 pragma solidity ^0.5.0;
4 
5 /**
6  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
7  * the optional functions; to access them see {ERC20Detailed}.
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
25      * Emits a {Transfer} event.
26      */
27     function transfer(address recipient, uint256 amount) external returns (bool);
28 
29     /**
30      * @dev Returns the remaining number of tokens that `spender` will be
31      * allowed to spend on behalf of `owner` through {transferFrom}. This is
32      * zero by default.
33      *
34      * This value changes when {approve} or {transferFrom} are called.
35      */
36     function allowance(address owner, address spender) external view returns (uint256);
37 
38     /**
39      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
40      *
41      * Returns a boolean value indicating whether the operation succeeded.
42      *
43      * IMPORTANT: Beware that changing an allowance with this method brings the risk
44      * that someone may use both the old and the new allowance by unfortunate
45      * transaction ordering. One possible solution to mitigate this race
46      * condition is to first reduce the spender's allowance to 0 and set the
47      * desired value afterwards:
48      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
49      *
50      * Emits an {Approval} event.
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
61      * Emits a {Transfer} event.
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
75      * a call to {approve}. `value` is the new allowance.
76      */
77     event Approval(address indexed owner, address indexed spender, uint256 value);
78 }
79 
80 // File: @openzeppelin\contracts\token\ERC20\ERC20Detailed.sol
81 
82 pragma solidity ^0.5.0;
83 
84 
85 /**
86  * @dev Optional functions from the ERC20 standard.
87  */
88 contract ERC20Detailed is IERC20 {
89     string private _name;
90     string private _symbol;
91     uint8 private _decimals;
92 
93     /**
94      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
95      * these values are immutable: they can only be set once during
96      * construction.
97      */
98     constructor (string memory name, string memory symbol, uint8 decimals) public {
99         _name = name;
100         _symbol = symbol;
101         _decimals = decimals;
102     }
103 
104     /**
105      * @dev Returns the name of the token.
106      */
107     function name() public view returns (string memory) {
108         return _name;
109     }
110 
111     /**
112      * @dev Returns the symbol of the token, usually a shorter version of the
113      * name.
114      */
115     function symbol() public view returns (string memory) {
116         return _symbol;
117     }
118 
119     /**
120      * @dev Returns the number of decimals used to get its user representation.
121      * For example, if `decimals` equals `2`, a balance of `505` tokens should
122      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
123      *
124      * Tokens usually opt for a value of 18, imitating the relationship between
125      * Ether and Wei.
126      *
127      * NOTE: This information is only used for _display_ purposes: it in
128      * no way affects any of the arithmetic of the contract, including
129      * {IERC20-balanceOf} and {IERC20-transfer}.
130      */
131     function decimals() public view returns (uint8) {
132         return _decimals;
133     }
134 }
135 
136 // File: node_modules\@openzeppelin\contracts\GSN\Context.sol
137 
138 pragma solidity ^0.5.0;
139 
140 /*
141  * @dev Provides information about the current execution context, including the
142  * sender of the transaction and its data. While these are generally available
143  * via msg.sender and msg.data, they should not be accessed in such a direct
144  * manner, since when dealing with GSN meta-transactions the account sending and
145  * paying for execution may not be the actual sender (as far as an application
146  * is concerned).
147  *
148  * This contract is only required for intermediate, library-like contracts.
149  */
150 contract Context {
151     // Empty internal constructor, to prevent people from mistakenly deploying
152     // an instance of this contract, which should be used via inheritance.
153     constructor () internal { }
154     // solhint-disable-previous-line no-empty-blocks
155 
156     function _msgSender() internal view returns (address payable) {
157         return msg.sender;
158     }
159 
160     function _msgData() internal view returns (bytes memory) {
161         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
162         return msg.data;
163     }
164 }
165 
166 // File: node_modules\@openzeppelin\contracts\math\SafeMath.sol
167 
168 pragma solidity ^0.5.0;
169 
170 /**
171  * @dev Wrappers over Solidity's arithmetic operations with added overflow
172  * checks.
173  *
174  * Arithmetic operations in Solidity wrap on overflow. This can easily result
175  * in bugs, because programmers usually assume that an overflow raises an
176  * error, which is the standard behavior in high level programming languages.
177  * `SafeMath` restores this intuition by reverting the transaction when an
178  * operation overflows.
179  *
180  * Using this library instead of the unchecked operations eliminates an entire
181  * class of bugs, so it's recommended to use it always.
182  */
183 library SafeMath {
184     /**
185      * @dev Returns the addition of two unsigned integers, reverting on
186      * overflow.
187      *
188      * Counterpart to Solidity's `+` operator.
189      *
190      * Requirements:
191      * - Addition cannot overflow.
192      */
193     function add(uint256 a, uint256 b) internal pure returns (uint256) {
194         uint256 c = a + b;
195         require(c >= a, "SafeMath: addition overflow");
196 
197         return c;
198     }
199 
200     /**
201      * @dev Returns the subtraction of two unsigned integers, reverting on
202      * overflow (when the result is negative).
203      *
204      * Counterpart to Solidity's `-` operator.
205      *
206      * Requirements:
207      * - Subtraction cannot overflow.
208      */
209     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
210         return sub(a, b, "SafeMath: subtraction overflow");
211     }
212 
213     /**
214      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
215      * overflow (when the result is negative).
216      *
217      * Counterpart to Solidity's `-` operator.
218      *
219      * Requirements:
220      * - Subtraction cannot overflow.
221      *
222      * _Available since v2.4.0._
223      */
224     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
225         require(b <= a, errorMessage);
226         uint256 c = a - b;
227 
228         return c;
229     }
230 
231     /**
232      * @dev Returns the multiplication of two unsigned integers, reverting on
233      * overflow.
234      *
235      * Counterpart to Solidity's `*` operator.
236      *
237      * Requirements:
238      * - Multiplication cannot overflow.
239      */
240     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
241         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
242         // benefit is lost if 'b' is also tested.
243         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
244         if (a == 0) {
245             return 0;
246         }
247 
248         uint256 c = a * b;
249         require(c / a == b, "SafeMath: multiplication overflow");
250 
251         return c;
252     }
253 
254     /**
255      * @dev Returns the integer division of two unsigned integers. Reverts on
256      * division by zero. The result is rounded towards zero.
257      *
258      * Counterpart to Solidity's `/` operator. Note: this function uses a
259      * `revert` opcode (which leaves remaining gas untouched) while Solidity
260      * uses an invalid opcode to revert (consuming all remaining gas).
261      *
262      * Requirements:
263      * - The divisor cannot be zero.
264      */
265     function div(uint256 a, uint256 b) internal pure returns (uint256) {
266         return div(a, b, "SafeMath: division by zero");
267     }
268 
269     /**
270      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
271      * division by zero. The result is rounded towards zero.
272      *
273      * Counterpart to Solidity's `/` operator. Note: this function uses a
274      * `revert` opcode (which leaves remaining gas untouched) while Solidity
275      * uses an invalid opcode to revert (consuming all remaining gas).
276      *
277      * Requirements:
278      * - The divisor cannot be zero.
279      *
280      * _Available since v2.4.0._
281      */
282     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
283         // Solidity only automatically asserts when dividing by 0
284         require(b > 0, errorMessage);
285         uint256 c = a / b;
286         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
287 
288         return c;
289     }
290 
291     /**
292      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
293      * Reverts when dividing by zero.
294      *
295      * Counterpart to Solidity's `%` operator. This function uses a `revert`
296      * opcode (which leaves remaining gas untouched) while Solidity uses an
297      * invalid opcode to revert (consuming all remaining gas).
298      *
299      * Requirements:
300      * - The divisor cannot be zero.
301      */
302     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
303         return mod(a, b, "SafeMath: modulo by zero");
304     }
305 
306     /**
307      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
308      * Reverts with custom message when dividing by zero.
309      *
310      * Counterpart to Solidity's `%` operator. This function uses a `revert`
311      * opcode (which leaves remaining gas untouched) while Solidity uses an
312      * invalid opcode to revert (consuming all remaining gas).
313      *
314      * Requirements:
315      * - The divisor cannot be zero.
316      *
317      * _Available since v2.4.0._
318      */
319     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
320         require(b != 0, errorMessage);
321         return a % b;
322     }
323 }
324 
325 // File: node_modules\@openzeppelin\contracts\token\ERC20\ERC20.sol
326 
327 pragma solidity ^0.5.0;
328 
329 
330 
331 
332 /**
333  * @dev Implementation of the {IERC20} interface.
334  *
335  * This implementation is agnostic to the way tokens are created. This means
336  * that a supply mechanism has to be added in a derived contract using {_mint}.
337  * For a generic mechanism see {ERC20Mintable}.
338  *
339  * TIP: For a detailed writeup see our guide
340  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
341  * to implement supply mechanisms].
342  *
343  * We have followed general OpenZeppelin guidelines: functions revert instead
344  * of returning `false` on failure. This behavior is nonetheless conventional
345  * and does not conflict with the expectations of ERC20 applications.
346  *
347  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
348  * This allows applications to reconstruct the allowance for all accounts just
349  * by listening to said events. Other implementations of the EIP may not emit
350  * these events, as it isn't required by the specification.
351  *
352  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
353  * functions have been added to mitigate the well-known issues around setting
354  * allowances. See {IERC20-approve}.
355  */
356 contract ERC20 is Context, IERC20 {
357     using SafeMath for uint256;
358 
359     mapping (address => uint256) private _balances;
360 
361     mapping (address => mapping (address => uint256)) private _allowances;
362 
363     uint256 private _totalSupply;
364 
365     /**
366      * @dev See {IERC20-totalSupply}.
367      */
368     function totalSupply() public view returns (uint256) {
369         return _totalSupply;
370     }
371 
372     /**
373      * @dev See {IERC20-balanceOf}.
374      */
375     function balanceOf(address account) public view returns (uint256) {
376         return _balances[account];
377     }
378 
379     /**
380      * @dev See {IERC20-transfer}.
381      *
382      * Requirements:
383      *
384      * - `recipient` cannot be the zero address.
385      * - the caller must have a balance of at least `amount`.
386      */
387     function transfer(address recipient, uint256 amount) public returns (bool) {
388         _transfer(_msgSender(), recipient, amount);
389         return true;
390     }
391 
392     /**
393      * @dev See {IERC20-allowance}.
394      */
395     function allowance(address owner, address spender) public view returns (uint256) {
396         return _allowances[owner][spender];
397     }
398 
399     /**
400      * @dev See {IERC20-approve}.
401      *
402      * Requirements:
403      *
404      * - `spender` cannot be the zero address.
405      */
406     function approve(address spender, uint256 amount) public returns (bool) {
407         _approve(_msgSender(), spender, amount);
408         return true;
409     }
410 
411     /**
412      * @dev See {IERC20-transferFrom}.
413      *
414      * Emits an {Approval} event indicating the updated allowance. This is not
415      * required by the EIP. See the note at the beginning of {ERC20};
416      *
417      * Requirements:
418      * - `sender` and `recipient` cannot be the zero address.
419      * - `sender` must have a balance of at least `amount`.
420      * - the caller must have allowance for `sender`'s tokens of at least
421      * `amount`.
422      */
423     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
424         _transfer(sender, recipient, amount);
425         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
426         return true;
427     }
428 
429     /**
430      * @dev Atomically increases the allowance granted to `spender` by the caller.
431      *
432      * This is an alternative to {approve} that can be used as a mitigation for
433      * problems described in {IERC20-approve}.
434      *
435      * Emits an {Approval} event indicating the updated allowance.
436      *
437      * Requirements:
438      *
439      * - `spender` cannot be the zero address.
440      */
441     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
442         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
443         return true;
444     }
445 
446     /**
447      * @dev Atomically decreases the allowance granted to `spender` by the caller.
448      *
449      * This is an alternative to {approve} that can be used as a mitigation for
450      * problems described in {IERC20-approve}.
451      *
452      * Emits an {Approval} event indicating the updated allowance.
453      *
454      * Requirements:
455      *
456      * - `spender` cannot be the zero address.
457      * - `spender` must have allowance for the caller of at least
458      * `subtractedValue`.
459      */
460     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
461         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
462         return true;
463     }
464 
465     /**
466      * @dev Moves tokens `amount` from `sender` to `recipient`.
467      *
468      * This is internal function is equivalent to {transfer}, and can be used to
469      * e.g. implement automatic token fees, slashing mechanisms, etc.
470      *
471      * Emits a {Transfer} event.
472      *
473      * Requirements:
474      *
475      * - `sender` cannot be the zero address.
476      * - `recipient` cannot be the zero address.
477      * - `sender` must have a balance of at least `amount`.
478      */
479     function _transfer(address sender, address recipient, uint256 amount) internal {
480         require(sender != address(0), "ERC20: transfer from the zero address");
481         require(recipient != address(0), "ERC20: transfer to the zero address");
482 
483         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
484         _balances[recipient] = _balances[recipient].add(amount);
485         emit Transfer(sender, recipient, amount);
486     }
487 
488     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
489      * the total supply.
490      *
491      * Emits a {Transfer} event with `from` set to the zero address.
492      *
493      * Requirements
494      *
495      * - `to` cannot be the zero address.
496      */
497     function _mint(address account, uint256 amount) internal {
498         require(account != address(0), "ERC20: mint to the zero address");
499 
500         _totalSupply = _totalSupply.add(amount);
501         _balances[account] = _balances[account].add(amount);
502         emit Transfer(address(0), account, amount);
503     }
504 
505      /**
506      * @dev Destroys `amount` tokens from `account`, reducing the
507      * total supply.
508      *
509      * Emits a {Transfer} event with `to` set to the zero address.
510      *
511      * Requirements
512      *
513      * - `account` cannot be the zero address.
514      * - `account` must have at least `amount` tokens.
515      */
516     function _burn(address account, uint256 amount) internal {
517         require(account != address(0), "ERC20: burn from the zero address");
518 
519         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
520         _totalSupply = _totalSupply.sub(amount);
521         emit Transfer(account, address(0), amount);
522     }
523 
524     /**
525      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
526      *
527      * This is internal function is equivalent to `approve`, and can be used to
528      * e.g. set automatic allowances for certain subsystems, etc.
529      *
530      * Emits an {Approval} event.
531      *
532      * Requirements:
533      *
534      * - `owner` cannot be the zero address.
535      * - `spender` cannot be the zero address.
536      */
537     function _approve(address owner, address spender, uint256 amount) internal {
538         require(owner != address(0), "ERC20: approve from the zero address");
539         require(spender != address(0), "ERC20: approve to the zero address");
540 
541         _allowances[owner][spender] = amount;
542         emit Approval(owner, spender, amount);
543     }
544 
545     /**
546      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
547      * from the caller's allowance.
548      *
549      * See {_burn} and {_approve}.
550      */
551     function _burnFrom(address account, uint256 amount) internal {
552         _burn(account, amount);
553         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
554     }
555 }
556 
557 // File: node_modules\@openzeppelin\contracts\access\Roles.sol
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
596 // File: node_modules\@openzeppelin\contracts\access\roles\MinterRole.sol
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
642 // File: @openzeppelin\contracts\token\ERC20\ERC20Mintable.sol
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
668 // File: node_modules\@openzeppelin\contracts\access\roles\PauserRole.sol
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
714 // File: node_modules\@openzeppelin\contracts\lifecycle\Pausable.sol
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
733     event Paused(address account, address target);
734 
735     /**
736      * @dev Emitted when the pause is lifted by a pauser (`account`).
737      */
738     event Unpaused(address account, address target);
739 
740     // bool private _paused;
741 
742     mapping (address => bool) private _frozenAccount;
743 
744 
745     /**
746      * @dev Initializes the contract in unpaused state. Assigns the Pauser role
747      * to the deployer.
748      */
749     constructor () internal {
750         // _paused = false;
751     }
752 
753     /**
754      * @dev Returns true if the contract is paused, and false otherwise.
755      */
756     function paused(address target) public view returns (bool) {
757         return _frozenAccount[target];
758     }
759 
760     /**
761      * @dev Modifier to make a function callable only when the contract is not paused.
762      */
763     modifier whenNotPaused(address target) {
764         require(!_frozenAccount[target], "Pausable: paused");
765         _;
766     }
767 
768     /**
769      * @dev Modifier to make a function callable only when the contract is paused.
770      */
771     modifier whenPaused(address target) {
772         require(_frozenAccount[target], "Pausable: not paused");
773         _;
774     }
775 
776     /**
777      * @dev Called by a pauser to pause, triggers stopped state.
778      */
779     function pause(address target) public onlyPauser whenNotPaused(target) {
780         // _paused = true;
781         _frozenAccount[target] = true;
782 
783         emit Paused(_msgSender(), target);
784     }
785 
786     /**
787      * @dev Called by a pauser to unpause, returns to normal state.
788      */
789     function unpause(address target) public onlyPauser whenPaused(target) {
790         // _paused = false;
791         _frozenAccount[target] = false;
792         emit Unpaused(_msgSender(), target);
793     }
794 }
795 
796 // File: @openzeppelin\contracts\token\ERC20\ERC20Pausable.sol
797 
798 pragma solidity ^0.5.0;
799 
800 
801 
802 /**
803  * @title Pausable token
804  * @dev ERC20 with pausable transfers and allowances.
805  *
806  * Useful if you want to stop trades until the end of a crowdsale, or have
807  * an emergency switch for freezing all token transfers in the event of a large
808  * bug.
809  */
810 contract ERC20Pausable is ERC20, Pausable {
811     function transfer(address to, uint256 value) public whenNotPaused(_msgSender()) returns (bool) {
812         return super.transfer(to, value);
813     }
814 
815     function transferFrom(address from, address to, uint256 value) public whenNotPaused(from) returns (bool) {
816         return super.transferFrom(from, to, value);
817     }
818 
819     // function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
820     //     return super.approve(spender, value);
821     // }
822 
823     // function increaseAllowance(address spender, uint256 addedValue) public whenNotPaused returns (bool) {
824     //     return super.increaseAllowance(spender, addedValue);
825     // }
826 
827     // function decreaseAllowance(address spender, uint256 subtractedValue) public whenNotPaused returns (bool) {
828     //     return super.decreaseAllowance(spender, subtractedValue);
829     // }
830 }
831 
832 // File: @openzeppelin\contracts\token\ERC20\ERC20Burnable.sol
833 
834 pragma solidity ^0.5.0;
835 
836 
837 
838 /**
839  * @dev Extension of {ERC20} that allows token holders to destroy both their own
840  * tokens and those that they have an allowance for, in a way that can be
841  * recognized off-chain (via event analysis).
842  */
843 contract ERC20Burnable is Context, ERC20 {
844     /**
845      * @dev Destroys `amount` tokens from the caller.
846      *
847      * See {ERC20-_burn}.
848      */
849     function burn(uint256 amount) public {
850         _burn(_msgSender(), amount);
851     }
852 
853     /**
854      * @dev See {ERC20-_burnFrom}.
855      */
856     function burnFrom(address account, uint256 amount) public {
857         _burnFrom(account, amount);
858     }
859 }
860 
861 // File: contracts\WallabeeToken.sol
862 
863 pragma solidity ^0.5.0;
864 
865 
866 
867 
868 
869 contract WallabeeToken is ERC20Detailed, ERC20Mintable, ERC20Pausable, ERC20Burnable {
870     constructor() ERC20Detailed("WALLABEE", "WLB", 18) public { 
871         uint256 supply = 70000000;
872         uint256 initialSupply = supply * uint(10) ** decimals(); 
873         _mint(msg.sender, initialSupply);
874     }
875 }