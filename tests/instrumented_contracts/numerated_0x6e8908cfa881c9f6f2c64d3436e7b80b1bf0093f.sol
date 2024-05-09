1 /*
2 
3    ___  _________________  ____  ____ 
4   / _ )/  _/ __/_  __/ _ \/ __ \/ __ \
5  / _  |/ /_\ \  / / / , _/ /_/ / /_/ /
6 /____/___/___/ /_/ /_/|_|\____/\____/ 
7                                       
8 Bistroo ERC-20 Token Contract
9 Powered by TERRY.COM
10 
11 */
12 
13 // File: @openzeppelin/contracts/GSN/Context.sol
14 
15 pragma solidity ^0.5.0;
16 
17 /*
18  * @dev Provides information about the current execution context, including the
19  * sender of the transaction and its data. While these are generally available
20  * via msg.sender and msg.data, they should not be accessed in such a direct
21  * manner, since when dealing with GSN meta-transactions the account sending and
22  * paying for execution may not be the actual sender (as far as an application
23  * is concerned).
24  *
25  * This contract is only required for intermediate, library-like contracts.
26  */
27 contract Context {
28     // Empty internal constructor, to prevent people from mistakenly deploying
29     // an instance of this contract, which should be used via inheritance.
30     constructor () internal { }
31     // solhint-disable-previous-line no-empty-blocks
32 
33     function _msgSender() internal view returns (address payable) {
34         return msg.sender;
35     }
36 
37     function _msgData() internal view returns (bytes memory) {
38         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
39         return msg.data;
40     }
41 }
42 
43 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
44 
45 pragma solidity ^0.5.0;
46 
47 /**
48  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
49  * the optional functions; to access them see {ERC20Detailed}.
50  */
51 interface IERC20 {
52     /**
53      * @dev Returns the amount of tokens in existence.
54      */
55     function totalSupply() external view returns (uint256);
56 
57     /**
58      * @dev Returns the amount of tokens owned by `account`.
59      */
60     function balanceOf(address account) external view returns (uint256);
61 
62     /**
63      * @dev Moves `amount` tokens from the caller's account to `recipient`.
64      *
65      * Returns a boolean value indicating whether the operation succeeded.
66      *
67      * Emits a {Transfer} event.
68      */
69     function transfer(address recipient, uint256 amount) external returns (bool);
70 
71     /**
72      * @dev Returns the remaining number of tokens that `spender` will be
73      * allowed to spend on behalf of `owner` through {transferFrom}. This is
74      * zero by default.
75      *
76      * This value changes when {approve} or {transferFrom} are called.
77      */
78     function allowance(address owner, address spender) external view returns (uint256);
79 
80     /**
81      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
82      *
83      * Returns a boolean value indicating whether the operation succeeded.
84      *
85      * IMPORTANT: Beware that changing an allowance with this method brings the risk
86      * that someone may use both the old and the new allowance by unfortunate
87      * transaction ordering. One possible solution to mitigate this race
88      * condition is to first reduce the spender's allowance to 0 and set the
89      * desired value afterwards:
90      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
91      *
92      * Emits an {Approval} event.
93      */
94     function approve(address spender, uint256 amount) external returns (bool);
95 
96     /**
97      * @dev Moves `amount` tokens from `sender` to `recipient` using the
98      * allowance mechanism. `amount` is then deducted from the caller's
99      * allowance.
100      *
101      * Returns a boolean value indicating whether the operation succeeded.
102      *
103      * Emits a {Transfer} event.
104      */
105     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
106 
107     /**
108      * @dev Emitted when `value` tokens are moved from one account (`from`) to
109      * another (`to`).
110      *
111      * Note that `value` may be zero.
112      */
113     event Transfer(address indexed from, address indexed to, uint256 value);
114 
115     /**
116      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
117      * a call to {approve}. `value` is the new allowance.
118      */
119     event Approval(address indexed owner, address indexed spender, uint256 value);
120 }
121 
122 // File: @openzeppelin/contracts/math/SafeMath.sol
123 
124 pragma solidity ^0.5.0;
125 
126 /**
127  * @dev Wrappers over Solidity's arithmetic operations with added overflow
128  * checks.
129  *
130  * Arithmetic operations in Solidity wrap on overflow. This can easily result
131  * in bugs, because programmers usually assume that an overflow raises an
132  * error, which is the standard behavior in high level programming languages.
133  * `SafeMath` restores this intuition by reverting the transaction when an
134  * operation overflows.
135  *
136  * Using this library instead of the unchecked operations eliminates an entire
137  * class of bugs, so it's recommended to use it always.
138  */
139 library SafeMath {
140     /**
141      * @dev Returns the addition of two unsigned integers, reverting on
142      * overflow.
143      *
144      * Counterpart to Solidity's `+` operator.
145      *
146      * Requirements:
147      * - Addition cannot overflow.
148      */
149     function add(uint256 a, uint256 b) internal pure returns (uint256) {
150         uint256 c = a + b;
151         require(c >= a, "SafeMath: addition overflow");
152 
153         return c;
154     }
155 
156     /**
157      * @dev Returns the subtraction of two unsigned integers, reverting on
158      * overflow (when the result is negative).
159      *
160      * Counterpart to Solidity's `-` operator.
161      *
162      * Requirements:
163      * - Subtraction cannot overflow.
164      */
165     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
166         return sub(a, b, "SafeMath: subtraction overflow");
167     }
168 
169     /**
170      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
171      * overflow (when the result is negative).
172      *
173      * Counterpart to Solidity's `-` operator.
174      *
175      * Requirements:
176      * - Subtraction cannot overflow.
177      *
178      * _Available since v2.4.0._
179      */
180     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
181         require(b <= a, errorMessage);
182         uint256 c = a - b;
183 
184         return c;
185     }
186 
187     /**
188      * @dev Returns the multiplication of two unsigned integers, reverting on
189      * overflow.
190      *
191      * Counterpart to Solidity's `*` operator.
192      *
193      * Requirements:
194      * - Multiplication cannot overflow.
195      */
196     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
197         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
198         // benefit is lost if 'b' is also tested.
199         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
200         if (a == 0) {
201             return 0;
202         }
203 
204         uint256 c = a * b;
205         require(c / a == b, "SafeMath: multiplication overflow");
206 
207         return c;
208     }
209 
210     /**
211      * @dev Returns the integer division of two unsigned integers. Reverts on
212      * division by zero. The result is rounded towards zero.
213      *
214      * Counterpart to Solidity's `/` operator. Note: this function uses a
215      * `revert` opcode (which leaves remaining gas untouched) while Solidity
216      * uses an invalid opcode to revert (consuming all remaining gas).
217      *
218      * Requirements:
219      * - The divisor cannot be zero.
220      */
221     function div(uint256 a, uint256 b) internal pure returns (uint256) {
222         return div(a, b, "SafeMath: division by zero");
223     }
224 
225     /**
226      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
227      * division by zero. The result is rounded towards zero.
228      *
229      * Counterpart to Solidity's `/` operator. Note: this function uses a
230      * `revert` opcode (which leaves remaining gas untouched) while Solidity
231      * uses an invalid opcode to revert (consuming all remaining gas).
232      *
233      * Requirements:
234      * - The divisor cannot be zero.
235      *
236      * _Available since v2.4.0._
237      */
238     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
239         // Solidity only automatically asserts when dividing by 0
240         require(b > 0, errorMessage);
241         uint256 c = a / b;
242         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
243 
244         return c;
245     }
246 
247     /**
248      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
249      * Reverts when dividing by zero.
250      *
251      * Counterpart to Solidity's `%` operator. This function uses a `revert`
252      * opcode (which leaves remaining gas untouched) while Solidity uses an
253      * invalid opcode to revert (consuming all remaining gas).
254      *
255      * Requirements:
256      * - The divisor cannot be zero.
257      */
258     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
259         return mod(a, b, "SafeMath: modulo by zero");
260     }
261 
262     /**
263      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
264      * Reverts with custom message when dividing by zero.
265      *
266      * Counterpart to Solidity's `%` operator. This function uses a `revert`
267      * opcode (which leaves remaining gas untouched) while Solidity uses an
268      * invalid opcode to revert (consuming all remaining gas).
269      *
270      * Requirements:
271      * - The divisor cannot be zero.
272      *
273      * _Available since v2.4.0._
274      */
275     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
276         require(b != 0, errorMessage);
277         return a % b;
278     }
279 }
280 
281 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
282 
283 pragma solidity ^0.5.0;
284 
285 
286 
287 
288 /**
289  * @dev Implementation of the {IERC20} interface.
290  *
291  * This implementation is agnostic to the way tokens are created. This means
292  * that a supply mechanism has to be added in a derived contract using {_mint}.
293  * For a generic mechanism see {ERC20Mintable}.
294  *
295  * TIP: For a detailed writeup see our guide
296  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
297  * to implement supply mechanisms].
298  *
299  * We have followed general OpenZeppelin guidelines: functions revert instead
300  * of returning `false` on failure. This behavior is nonetheless conventional
301  * and does not conflict with the expectations of ERC20 applications.
302  *
303  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
304  * This allows applications to reconstruct the allowance for all accounts just
305  * by listening to said events. Other implementations of the EIP may not emit
306  * these events, as it isn't required by the specification.
307  *
308  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
309  * functions have been added to mitigate the well-known issues around setting
310  * allowances. See {IERC20-approve}.
311  */
312 contract ERC20 is Context, IERC20 {
313     using SafeMath for uint256;
314 
315     mapping (address => uint256) private _balances;
316 
317     mapping (address => mapping (address => uint256)) private _allowances;
318 
319     uint256 private _totalSupply;
320 
321     /**
322      * @dev See {IERC20-totalSupply}.
323      */
324     function totalSupply() public view returns (uint256) {
325         return _totalSupply;
326     }
327 
328     /**
329      * @dev See {IERC20-balanceOf}.
330      */
331     function balanceOf(address account) public view returns (uint256) {
332         return _balances[account];
333     }
334 
335     /**
336      * @dev See {IERC20-transfer}.
337      *
338      * Requirements:
339      *
340      * - `recipient` cannot be the zero address.
341      * - the caller must have a balance of at least `amount`.
342      */
343     function transfer(address recipient, uint256 amount) public returns (bool) {
344         _transfer(_msgSender(), recipient, amount);
345         return true;
346     }
347 
348     /**
349      * @dev See {IERC20-allowance}.
350      */
351     function allowance(address owner, address spender) public view returns (uint256) {
352         return _allowances[owner][spender];
353     }
354 
355     /**
356      * @dev See {IERC20-approve}.
357      *
358      * Requirements:
359      *
360      * - `spender` cannot be the zero address.
361      */
362     function approve(address spender, uint256 amount) public returns (bool) {
363         _approve(_msgSender(), spender, amount);
364         return true;
365     }
366 
367     /**
368      * @dev See {IERC20-transferFrom}.
369      *
370      * Emits an {Approval} event indicating the updated allowance. This is not
371      * required by the EIP. See the note at the beginning of {ERC20};
372      *
373      * Requirements:
374      * - `sender` and `recipient` cannot be the zero address.
375      * - `sender` must have a balance of at least `amount`.
376      * - the caller must have allowance for `sender`'s tokens of at least
377      * `amount`.
378      */
379     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
380         _transfer(sender, recipient, amount);
381         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
382         return true;
383     }
384 
385     /**
386      * @dev Atomically increases the allowance granted to `spender` by the caller.
387      *
388      * This is an alternative to {approve} that can be used as a mitigation for
389      * problems described in {IERC20-approve}.
390      *
391      * Emits an {Approval} event indicating the updated allowance.
392      *
393      * Requirements:
394      *
395      * - `spender` cannot be the zero address.
396      */
397     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
398         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
399         return true;
400     }
401 
402     /**
403      * @dev Atomically decreases the allowance granted to `spender` by the caller.
404      *
405      * This is an alternative to {approve} that can be used as a mitigation for
406      * problems described in {IERC20-approve}.
407      *
408      * Emits an {Approval} event indicating the updated allowance.
409      *
410      * Requirements:
411      *
412      * - `spender` cannot be the zero address.
413      * - `spender` must have allowance for the caller of at least
414      * `subtractedValue`.
415      */
416     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
417         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
418         return true;
419     }
420 
421     /**
422      * @dev Moves tokens `amount` from `sender` to `recipient`.
423      *
424      * This is internal function is equivalent to {transfer}, and can be used to
425      * e.g. implement automatic token fees, slashing mechanisms, etc.
426      *
427      * Emits a {Transfer} event.
428      *
429      * Requirements:
430      *
431      * - `sender` cannot be the zero address.
432      * - `recipient` cannot be the zero address.
433      * - `sender` must have a balance of at least `amount`.
434      */
435     function _transfer(address sender, address recipient, uint256 amount) internal {
436         require(sender != address(0), "ERC20: transfer from the zero address");
437         require(recipient != address(0), "ERC20: transfer to the zero address");
438 
439         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
440         _balances[recipient] = _balances[recipient].add(amount);
441         emit Transfer(sender, recipient, amount);
442     }
443 
444     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
445      * the total supply.
446      *
447      * Emits a {Transfer} event with `from` set to the zero address.
448      *
449      * Requirements
450      *
451      * - `to` cannot be the zero address.
452      */
453     function _mint(address account, uint256 amount) internal {
454         require(account != address(0), "ERC20: mint to the zero address");
455 
456         _totalSupply = _totalSupply.add(amount);
457         _balances[account] = _balances[account].add(amount);
458         emit Transfer(address(0), account, amount);
459     }
460 
461     /**
462      * @dev Destroys `amount` tokens from `account`, reducing the
463      * total supply.
464      *
465      * Emits a {Transfer} event with `to` set to the zero address.
466      *
467      * Requirements
468      *
469      * - `account` cannot be the zero address.
470      * - `account` must have at least `amount` tokens.
471      */
472     function _burn(address account, uint256 amount) internal {
473         require(account != address(0), "ERC20: burn from the zero address");
474 
475         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
476         _totalSupply = _totalSupply.sub(amount);
477         emit Transfer(account, address(0), amount);
478     }
479 
480     /**
481      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
482      *
483      * This is internal function is equivalent to `approve`, and can be used to
484      * e.g. set automatic allowances for certain subsystems, etc.
485      *
486      * Emits an {Approval} event.
487      *
488      * Requirements:
489      *
490      * - `owner` cannot be the zero address.
491      * - `spender` cannot be the zero address.
492      */
493     function _approve(address owner, address spender, uint256 amount) internal {
494         require(owner != address(0), "ERC20: approve from the zero address");
495         require(spender != address(0), "ERC20: approve to the zero address");
496 
497         _allowances[owner][spender] = amount;
498         emit Approval(owner, spender, amount);
499     }
500 
501     /**
502      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
503      * from the caller's allowance.
504      *
505      * See {_burn} and {_approve}.
506      */
507     function _burnFrom(address account, uint256 amount) internal {
508         _burn(account, amount);
509         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
510     }
511 }
512 
513 // File: @openzeppelin/contracts/token/ERC20/ERC20Burnable.sol
514 
515 pragma solidity ^0.5.0;
516 
517 
518 
519 /**
520  * @dev Extension of {ERC20} that allows token holders to destroy both their own
521  * tokens and those that they have an allowance for, in a way that can be
522  * recognized off-chain (via event analysis).
523  */
524 contract ERC20Burnable is Context, ERC20 {
525     /**
526      * @dev Destroys `amount` tokens from the caller.
527      *
528      * See {ERC20-_burn}.
529      */
530     function burn(uint256 amount) public {
531         _burn(_msgSender(), amount);
532     }
533 
534     /**
535      * @dev See {ERC20-_burnFrom}.
536      */
537     function burnFrom(address account, uint256 amount) public {
538         _burnFrom(account, amount);
539     }
540 }
541 
542 // File: @openzeppelin/contracts/access/Roles.sol
543 
544 pragma solidity ^0.5.0;
545 
546 /**
547  * @title Roles
548  * @dev Library for managing addresses assigned to a Role.
549  */
550 library Roles {
551     struct Role {
552         mapping (address => bool) bearer;
553     }
554 
555     /**
556      * @dev Give an account access to this role.
557      */
558     function add(Role storage role, address account) internal {
559         require(!has(role, account), "Roles: account already has role");
560         role.bearer[account] = true;
561     }
562 
563     /**
564      * @dev Remove an account's access to this role.
565      */
566     function remove(Role storage role, address account) internal {
567         require(has(role, account), "Roles: account does not have role");
568         role.bearer[account] = false;
569     }
570 
571     /**
572      * @dev Check if an account has this role.
573      * @return bool
574      */
575     function has(Role storage role, address account) internal view returns (bool) {
576         require(account != address(0), "Roles: account is the zero address");
577         return role.bearer[account];
578     }
579 }
580 
581 // File: @openzeppelin/contracts/access/roles/MinterRole.sol
582 
583 pragma solidity ^0.5.0;
584 
585 
586 
587 contract MinterRole is Context {
588     using Roles for Roles.Role;
589 
590     event MinterAdded(address indexed account);
591     event MinterRemoved(address indexed account);
592 
593     Roles.Role private _minters;
594 
595     constructor () internal {
596         _addMinter(_msgSender());
597     }
598 
599     modifier onlyMinter() {
600         require(isMinter(_msgSender()), "MinterRole: caller does not have the Minter role");
601         _;
602     }
603 
604     function isMinter(address account) public view returns (bool) {
605         return _minters.has(account);
606     }
607 
608     function addMinter(address account) public onlyMinter {
609         _addMinter(account);
610     }
611 
612     function renounceMinter() public {
613         _removeMinter(_msgSender());
614     }
615 
616     function _addMinter(address account) internal {
617         _minters.add(account);
618         emit MinterAdded(account);
619     }
620 
621     function _removeMinter(address account) internal {
622         _minters.remove(account);
623         emit MinterRemoved(account);
624     }
625 }
626 
627 // File: @openzeppelin/contracts/token/ERC20/ERC20Mintable.sol
628 
629 pragma solidity ^0.5.0;
630 
631 
632 
633 /**
634  * @dev Extension of {ERC20} that adds a set of accounts with the {MinterRole},
635  * which have permission to mint (create) new tokens as they see fit.
636  *
637  * At construction, the deployer of the contract is the only minter.
638  */
639 contract ERC20Mintable is ERC20, MinterRole {
640     /**
641      * @dev See {ERC20-_mint}.
642      *
643      * Requirements:
644      *
645      * - the caller must have the {MinterRole}.
646      */
647     function mint(address account, uint256 amount) public onlyMinter returns (bool) {
648         _mint(account, amount);
649         return true;
650     }
651 }
652 
653 // File: @openzeppelin/contracts/token/ERC20/ERC20Detailed.sol
654 
655 pragma solidity ^0.5.0;
656 
657 
658 /**
659  * @dev Optional functions from the ERC20 standard.
660  */
661 contract ERC20Detailed is IERC20 {
662     string private _name;
663     string private _symbol;
664     uint8 private _decimals;
665 
666     /**
667      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
668      * these values are immutable: they can only be set once during
669      * construction.
670      */
671     constructor (string memory name, string memory symbol, uint8 decimals) public {
672         _name = name;
673         _symbol = symbol;
674         _decimals = decimals;
675     }
676 
677     /**
678      * @dev Returns the name of the token.
679      */
680     function name() public view returns (string memory) {
681         return _name;
682     }
683 
684     /**
685      * @dev Returns the symbol of the token, usually a shorter version of the
686      * name.
687      */
688     function symbol() public view returns (string memory) {
689         return _symbol;
690     }
691 
692     /**
693      * @dev Returns the number of decimals used to get its user representation.
694      * For example, if `decimals` equals `2`, a balance of `505` tokens should
695      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
696      *
697      * Tokens usually opt for a value of 18, imitating the relationship between
698      * Ether and Wei.
699      *
700      * NOTE: This information is only used for _display_ purposes: it in
701      * no way affects any of the arithmetic of the contract, including
702      * {IERC20-balanceOf} and {IERC20-transfer}.
703      */
704     function decimals() public view returns (uint8) {
705         return _decimals;
706     }
707 }
708 
709 // File: @openzeppelin/contracts/access/roles/PauserRole.sol
710 
711 pragma solidity ^0.5.0;
712 
713 
714 
715 contract PauserRole is Context {
716     using Roles for Roles.Role;
717 
718     event PauserAdded(address indexed account);
719     event PauserRemoved(address indexed account);
720 
721     Roles.Role private _pausers;
722 
723     constructor () internal {
724         _addPauser(_msgSender());
725     }
726 
727     modifier onlyPauser() {
728         require(isPauser(_msgSender()), "PauserRole: caller does not have the Pauser role");
729         _;
730     }
731 
732     function isPauser(address account) public view returns (bool) {
733         return _pausers.has(account);
734     }
735 
736     function addPauser(address account) public onlyPauser {
737         _addPauser(account);
738     }
739 
740     function renouncePauser() public {
741         _removePauser(_msgSender());
742     }
743 
744     function _addPauser(address account) internal {
745         _pausers.add(account);
746         emit PauserAdded(account);
747     }
748 
749     function _removePauser(address account) internal {
750         _pausers.remove(account);
751         emit PauserRemoved(account);
752     }
753 }
754 
755 // File: @openzeppelin/contracts/lifecycle/Pausable.sol
756 
757 pragma solidity ^0.5.0;
758 
759 
760 
761 /**
762  * @dev Contract module which allows children to implement an emergency stop
763  * mechanism that can be triggered by an authorized account.
764  *
765  * This module is used through inheritance. It will make available the
766  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
767  * the functions of your contract. Note that they will not be pausable by
768  * simply including this module, only once the modifiers are put in place.
769  */
770 contract Pausable is Context, PauserRole {
771     /**
772      * @dev Emitted when the pause is triggered by a pauser (`account`).
773      */
774     event Paused(address account);
775 
776     /**
777      * @dev Emitted when the pause is lifted by a pauser (`account`).
778      */
779     event Unpaused(address account);
780 
781     bool private _paused;
782 
783     /**
784      * @dev Initializes the contract in unpaused state. Assigns the Pauser role
785      * to the deployer.
786      */
787     constructor () internal {
788         _paused = false;
789     }
790 
791     /**
792      * @dev Returns true if the contract is paused, and false otherwise.
793      */
794     function paused() public view returns (bool) {
795         return _paused;
796     }
797 
798     /**
799      * @dev Modifier to make a function callable only when the contract is not paused.
800      */
801     modifier whenNotPaused() {
802         require(!_paused, "Pausable: paused");
803         _;
804     }
805 
806     /**
807      * @dev Modifier to make a function callable only when the contract is paused.
808      */
809     modifier whenPaused() {
810         require(_paused, "Pausable: not paused");
811         _;
812     }
813 
814     /**
815      * @dev Called by a pauser to pause, triggers stopped state.
816      */
817     function pause() public onlyPauser whenNotPaused {
818         _paused = true;
819         emit Paused(_msgSender());
820     }
821 
822     /**
823      * @dev Called by a pauser to unpause, returns to normal state.
824      */
825     function unpause() public onlyPauser whenPaused {
826         _paused = false;
827         emit Unpaused(_msgSender());
828     }
829 }
830 
831 // File: @openzeppelin/contracts/token/ERC20/ERC20Pausable.sol
832 
833 pragma solidity ^0.5.0;
834 
835 
836 
837 /**
838  * @title Pausable token
839  * @dev ERC20 with pausable transfers and allowances.
840  *
841  * Useful if you want to stop trades until the end of a crowdsale, or have
842  * an emergency switch for freezing all token transfers in the event of a large
843  * bug.
844  */
845 contract ERC20Pausable is ERC20, Pausable {
846     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
847         return super.transfer(to, value);
848     }
849 
850     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
851         return super.transferFrom(from, to, value);
852     }
853 
854     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
855         return super.approve(spender, value);
856     }
857 
858     function increaseAllowance(address spender, uint256 addedValue) public whenNotPaused returns (bool) {
859         return super.increaseAllowance(spender, addedValue);
860     }
861 
862     function decreaseAllowance(address spender, uint256 subtractedValue) public whenNotPaused returns (bool) {
863         return super.decreaseAllowance(spender, subtractedValue);
864     }
865 }
866 
867 // File: @openzeppelin/contracts/access/roles/WhitelistAdminRole.sol
868 
869 pragma solidity ^0.5.0;
870 
871 
872 
873 /**
874  * @title WhitelistAdminRole
875  * @dev WhitelistAdmins are responsible for assigning and removing Whitelisted accounts.
876  */
877 contract WhitelistAdminRole is Context {
878     using Roles for Roles.Role;
879 
880     event WhitelistAdminAdded(address indexed account);
881     event WhitelistAdminRemoved(address indexed account);
882 
883     Roles.Role private _whitelistAdmins;
884 
885     constructor () internal {
886         _addWhitelistAdmin(_msgSender());
887     }
888 
889     modifier onlyWhitelistAdmin() {
890         require(isWhitelistAdmin(_msgSender()), "WhitelistAdminRole: caller does not have the WhitelistAdmin role");
891         _;
892     }
893 
894     function isWhitelistAdmin(address account) public view returns (bool) {
895         return _whitelistAdmins.has(account);
896     }
897 
898     function addWhitelistAdmin(address account) public onlyWhitelistAdmin {
899         _addWhitelistAdmin(account);
900     }
901 
902     function renounceWhitelistAdmin() public {
903         _removeWhitelistAdmin(_msgSender());
904     }
905 
906     function _addWhitelistAdmin(address account) internal {
907         _whitelistAdmins.add(account);
908         emit WhitelistAdminAdded(account);
909     }
910 
911     function _removeWhitelistAdmin(address account) internal {
912         _whitelistAdmins.remove(account);
913         emit WhitelistAdminRemoved(account);
914     }
915 }
916 
917 // File: contracts/BistrooToken.sol
918 
919 pragma solidity ^0.5.17;
920 
921 
922 
923 contract BistrooToken is
924 ERC20,
925 ERC20Detailed("Bistroo Token", "BIST", 18),
926 ERC20Burnable,
927 ERC20Mintable,
928 ERC20Pausable,
929 WhitelistAdminRole
930 {}