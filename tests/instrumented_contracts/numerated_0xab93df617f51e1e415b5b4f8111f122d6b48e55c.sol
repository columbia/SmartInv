1 // File: @openzeppelin/contracts/math/SafeMath.sol
2 
3 pragma solidity ^0.5.0;
4 
5 /**
6  * @dev Wrappers over Solidity's arithmetic operations with added overflow
7  * checks.
8  *
9  * Arithmetic operations in Solidity wrap on overflow. This can easily result
10  * in bugs, because programmers usually assume that an overflow raises an
11  * error, which is the standard behavior in high level programming languages.
12  * `SafeMath` restores this intuition by reverting the transaction when an
13  * operation overflows.
14  *
15  * Using this library instead of the unchecked operations eliminates an entire
16  * class of bugs, so it's recommended to use it always.
17  */
18 library SafeMath {
19     /**
20      * @dev Returns the addition of two unsigned integers, reverting on
21      * overflow.
22      *
23      * Counterpart to Solidity's `+` operator.
24      *
25      * Requirements:
26      * - Addition cannot overflow.
27      */
28     function add(uint256 a, uint256 b) internal pure returns (uint256) {
29         uint256 c = a + b;
30         require(c >= a, "SafeMath: addition overflow");
31 
32         return c;
33     }
34 
35     /**
36      * @dev Returns the subtraction of two unsigned integers, reverting on
37      * overflow (when the result is negative).
38      *
39      * Counterpart to Solidity's `-` operator.
40      *
41      * Requirements:
42      * - Subtraction cannot overflow.
43      */
44     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
45         return sub(a, b, "SafeMath: subtraction overflow");
46     }
47 
48     /**
49      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
50      * overflow (when the result is negative).
51      *
52      * Counterpart to Solidity's `-` operator.
53      *
54      * Requirements:
55      * - Subtraction cannot overflow.
56      *
57      * _Available since v2.4.0._
58      */
59     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
60         require(b <= a, errorMessage);
61         uint256 c = a - b;
62 
63         return c;
64     }
65 
66     /**
67      * @dev Returns the multiplication of two unsigned integers, reverting on
68      * overflow.
69      *
70      * Counterpart to Solidity's `*` operator.
71      *
72      * Requirements:
73      * - Multiplication cannot overflow.
74      */
75     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
76         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
77         // benefit is lost if 'b' is also tested.
78         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
79         if (a == 0) {
80             return 0;
81         }
82 
83         uint256 c = a * b;
84         require(c / a == b, "SafeMath: multiplication overflow");
85 
86         return c;
87     }
88 
89     /**
90      * @dev Returns the integer division of two unsigned integers. Reverts on
91      * division by zero. The result is rounded towards zero.
92      *
93      * Counterpart to Solidity's `/` operator. Note: this function uses a
94      * `revert` opcode (which leaves remaining gas untouched) while Solidity
95      * uses an invalid opcode to revert (consuming all remaining gas).
96      *
97      * Requirements:
98      * - The divisor cannot be zero.
99      */
100     function div(uint256 a, uint256 b) internal pure returns (uint256) {
101         return div(a, b, "SafeMath: division by zero");
102     }
103 
104     /**
105      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
106      * division by zero. The result is rounded towards zero.
107      *
108      * Counterpart to Solidity's `/` operator. Note: this function uses a
109      * `revert` opcode (which leaves remaining gas untouched) while Solidity
110      * uses an invalid opcode to revert (consuming all remaining gas).
111      *
112      * Requirements:
113      * - The divisor cannot be zero.
114      *
115      * _Available since v2.4.0._
116      */
117     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
118         // Solidity only automatically asserts when dividing by 0
119         require(b > 0, errorMessage);
120         uint256 c = a / b;
121         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
122 
123         return c;
124     }
125 
126     /**
127      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
128      * Reverts when dividing by zero.
129      *
130      * Counterpart to Solidity's `%` operator. This function uses a `revert`
131      * opcode (which leaves remaining gas untouched) while Solidity uses an
132      * invalid opcode to revert (consuming all remaining gas).
133      *
134      * Requirements:
135      * - The divisor cannot be zero.
136      */
137     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
138         return mod(a, b, "SafeMath: modulo by zero");
139     }
140 
141     /**
142      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
143      * Reverts with custom message when dividing by zero.
144      *
145      * Counterpart to Solidity's `%` operator. This function uses a `revert`
146      * opcode (which leaves remaining gas untouched) while Solidity uses an
147      * invalid opcode to revert (consuming all remaining gas).
148      *
149      * Requirements:
150      * - The divisor cannot be zero.
151      *
152      * _Available since v2.4.0._
153      */
154     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
155         require(b != 0, errorMessage);
156         return a % b;
157     }
158 }
159 
160 // File: @openzeppelin/contracts/GSN/Context.sol
161 
162 pragma solidity ^0.5.0;
163 
164 /*
165  * @dev Provides information about the current execution context, including the
166  * sender of the transaction and its data. While these are generally available
167  * via msg.sender and msg.data, they should not be accessed in such a direct
168  * manner, since when dealing with GSN meta-transactions the account sending and
169  * paying for execution may not be the actual sender (as far as an application
170  * is concerned).
171  *
172  * This contract is only required for intermediate, library-like contracts.
173  */
174 contract Context {
175     // Empty internal constructor, to prevent people from mistakenly deploying
176     // an instance of this contract, which should be used via inheritance.
177     constructor () internal { }
178     // solhint-disable-previous-line no-empty-blocks
179 
180     function _msgSender() internal view returns (address payable) {
181         return msg.sender;
182     }
183 
184     function _msgData() internal view returns (bytes memory) {
185         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
186         return msg.data;
187     }
188 }
189 
190 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
191 
192 pragma solidity ^0.5.0;
193 
194 /**
195  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
196  * the optional functions; to access them see {ERC20Detailed}.
197  */
198 interface IERC20 {
199     /**
200      * @dev Returns the amount of tokens in existence.
201      */
202     function totalSupply() external view returns (uint256);
203 
204     /**
205      * @dev Returns the amount of tokens owned by `account`.
206      */
207     function balanceOf(address account) external view returns (uint256);
208 
209     /**
210      * @dev Moves `amount` tokens from the caller's account to `recipient`.
211      *
212      * Returns a boolean value indicating whether the operation succeeded.
213      *
214      * Emits a {Transfer} event.
215      */
216     function transfer(address recipient, uint256 amount) external returns (bool);
217 
218     /**
219      * @dev Returns the remaining number of tokens that `spender` will be
220      * allowed to spend on behalf of `owner` through {transferFrom}. This is
221      * zero by default.
222      *
223      * This value changes when {approve} or {transferFrom} are called.
224      */
225     function allowance(address owner, address spender) external view returns (uint256);
226 
227     /**
228      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
229      *
230      * Returns a boolean value indicating whether the operation succeeded.
231      *
232      * IMPORTANT: Beware that changing an allowance with this method brings the risk
233      * that someone may use both the old and the new allowance by unfortunate
234      * transaction ordering. One possible solution to mitigate this race
235      * condition is to first reduce the spender's allowance to 0 and set the
236      * desired value afterwards:
237      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
238      *
239      * Emits an {Approval} event.
240      */
241     function approve(address spender, uint256 amount) external returns (bool);
242 
243     /**
244      * @dev Moves `amount` tokens from `sender` to `recipient` using the
245      * allowance mechanism. `amount` is then deducted from the caller's
246      * allowance.
247      *
248      * Returns a boolean value indicating whether the operation succeeded.
249      *
250      * Emits a {Transfer} event.
251      */
252     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
253 
254     /**
255      * @dev Emitted when `value` tokens are moved from one account (`from`) to
256      * another (`to`).
257      *
258      * Note that `value` may be zero.
259      */
260     event Transfer(address indexed from, address indexed to, uint256 value);
261 
262     /**
263      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
264      * a call to {approve}. `value` is the new allowance.
265      */
266     event Approval(address indexed owner, address indexed spender, uint256 value);
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
557 // File: @openzeppelin/contracts/token/ERC20/ERC20Burnable.sol
558 
559 pragma solidity ^0.5.0;
560 
561 
562 
563 /**
564  * @dev Extension of {ERC20} that allows token holders to destroy both their own
565  * tokens and those that they have an allowance for, in a way that can be
566  * recognized off-chain (via event analysis).
567  */
568 contract ERC20Burnable is Context, ERC20 {
569     /**
570      * @dev Destroys `amount` tokens from the caller.
571      *
572      * See {ERC20-_burn}.
573      */
574     function burn(uint256 amount) public {
575         _burn(_msgSender(), amount);
576     }
577 
578     /**
579      * @dev See {ERC20-_burnFrom}.
580      */
581     function burnFrom(address account, uint256 amount) public {
582         _burnFrom(account, amount);
583     }
584 }
585 
586 // File: @openzeppelin/contracts/access/Roles.sol
587 
588 pragma solidity ^0.5.0;
589 
590 /**
591  * @title Roles
592  * @dev Library for managing addresses assigned to a Role.
593  */
594 library Roles {
595     struct Role {
596         mapping (address => bool) bearer;
597     }
598 
599     /**
600      * @dev Give an account access to this role.
601      */
602     function add(Role storage role, address account) internal {
603         require(!has(role, account), "Roles: account already has role");
604         role.bearer[account] = true;
605     }
606 
607     /**
608      * @dev Remove an account's access to this role.
609      */
610     function remove(Role storage role, address account) internal {
611         require(has(role, account), "Roles: account does not have role");
612         role.bearer[account] = false;
613     }
614 
615     /**
616      * @dev Check if an account has this role.
617      * @return bool
618      */
619     function has(Role storage role, address account) internal view returns (bool) {
620         require(account != address(0), "Roles: account is the zero address");
621         return role.bearer[account];
622     }
623 }
624 
625 // File: @openzeppelin/contracts/access/roles/MinterRole.sol
626 
627 pragma solidity ^0.5.0;
628 
629 
630 
631 contract MinterRole is Context {
632     using Roles for Roles.Role;
633 
634     event MinterAdded(address indexed account);
635     event MinterRemoved(address indexed account);
636 
637     Roles.Role private _minters;
638 
639     constructor () internal {
640         _addMinter(_msgSender());
641     }
642 
643     modifier onlyMinter() {
644         require(isMinter(_msgSender()), "MinterRole: caller does not have the Minter role");
645         _;
646     }
647 
648     function isMinter(address account) public view returns (bool) {
649         return _minters.has(account);
650     }
651 
652     function addMinter(address account) public onlyMinter {
653         _addMinter(account);
654     }
655 
656     function renounceMinter() public {
657         _removeMinter(_msgSender());
658     }
659 
660     function _addMinter(address account) internal {
661         _minters.add(account);
662         emit MinterAdded(account);
663     }
664 
665     function _removeMinter(address account) internal {
666         _minters.remove(account);
667         emit MinterRemoved(account);
668     }
669 }
670 
671 // File: @openzeppelin/contracts/token/ERC20/ERC20Mintable.sol
672 
673 pragma solidity ^0.5.0;
674 
675 
676 
677 /**
678  * @dev Extension of {ERC20} that adds a set of accounts with the {MinterRole},
679  * which have permission to mint (create) new tokens as they see fit.
680  *
681  * At construction, the deployer of the contract is the only minter.
682  */
683 contract ERC20Mintable is ERC20, MinterRole {
684     /**
685      * @dev See {ERC20-_mint}.
686      *
687      * Requirements:
688      *
689      * - the caller must have the {MinterRole}.
690      */
691     function mint(address account, uint256 amount) public onlyMinter returns (bool) {
692         _mint(account, amount);
693         return true;
694     }
695 }
696 
697 // File: @openzeppelin/contracts/access/roles/PauserRole.sol
698 
699 pragma solidity ^0.5.0;
700 
701 
702 
703 contract PauserRole is Context {
704     using Roles for Roles.Role;
705 
706     event PauserAdded(address indexed account);
707     event PauserRemoved(address indexed account);
708 
709     Roles.Role private _pausers;
710 
711     constructor () internal {
712         _addPauser(_msgSender());
713     }
714 
715     modifier onlyPauser() {
716         require(isPauser(_msgSender()), "PauserRole: caller does not have the Pauser role");
717         _;
718     }
719 
720     function isPauser(address account) public view returns (bool) {
721         return _pausers.has(account);
722     }
723 
724     function addPauser(address account) public onlyPauser {
725         _addPauser(account);
726     }
727 
728     function renouncePauser() public {
729         _removePauser(_msgSender());
730     }
731 
732     function _addPauser(address account) internal {
733         _pausers.add(account);
734         emit PauserAdded(account);
735     }
736 
737     function _removePauser(address account) internal {
738         _pausers.remove(account);
739         emit PauserRemoved(account);
740     }
741 }
742 
743 // File: @openzeppelin/contracts/lifecycle/Pausable.sol
744 
745 pragma solidity ^0.5.0;
746 
747 
748 
749 /**
750  * @dev Contract module which allows children to implement an emergency stop
751  * mechanism that can be triggered by an authorized account.
752  *
753  * This module is used through inheritance. It will make available the
754  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
755  * the functions of your contract. Note that they will not be pausable by
756  * simply including this module, only once the modifiers are put in place.
757  */
758 contract Pausable is Context, PauserRole {
759     /**
760      * @dev Emitted when the pause is triggered by a pauser (`account`).
761      */
762     event Paused(address account);
763 
764     /**
765      * @dev Emitted when the pause is lifted by a pauser (`account`).
766      */
767     event Unpaused(address account);
768 
769     bool private _paused;
770 
771     /**
772      * @dev Initializes the contract in unpaused state. Assigns the Pauser role
773      * to the deployer.
774      */
775     constructor () internal {
776         _paused = false;
777     }
778 
779     /**
780      * @dev Returns true if the contract is paused, and false otherwise.
781      */
782     function paused() public view returns (bool) {
783         return _paused;
784     }
785 
786     /**
787      * @dev Modifier to make a function callable only when the contract is not paused.
788      */
789     modifier whenNotPaused() {
790         require(!_paused, "Pausable: paused");
791         _;
792     }
793 
794     /**
795      * @dev Modifier to make a function callable only when the contract is paused.
796      */
797     modifier whenPaused() {
798         require(_paused, "Pausable: not paused");
799         _;
800     }
801 
802     /**
803      * @dev Called by a pauser to pause, triggers stopped state.
804      */
805     function pause() public onlyPauser whenNotPaused {
806         _paused = true;
807         emit Paused(_msgSender());
808     }
809 
810     /**
811      * @dev Called by a pauser to unpause, returns to normal state.
812      */
813     function unpause() public onlyPauser whenPaused {
814         _paused = false;
815         emit Unpaused(_msgSender());
816     }
817 }
818 
819 // File: @openzeppelin/contracts/token/ERC20/ERC20Pausable.sol
820 
821 pragma solidity ^0.5.0;
822 
823 
824 
825 /**
826  * @title Pausable token
827  * @dev ERC20 with pausable transfers and allowances.
828  *
829  * Useful if you want to stop trades until the end of a crowdsale, or have
830  * an emergency switch for freezing all token transfers in the event of a large
831  * bug.
832  */
833 contract ERC20Pausable is ERC20, Pausable {
834     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
835         return super.transfer(to, value);
836     }
837 
838     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
839         return super.transferFrom(from, to, value);
840     }
841 
842     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
843         return super.approve(spender, value);
844     }
845 
846     function increaseAllowance(address spender, uint256 addedValue) public whenNotPaused returns (bool) {
847         return super.increaseAllowance(spender, addedValue);
848     }
849 
850     function decreaseAllowance(address spender, uint256 subtractedValue) public whenNotPaused returns (bool) {
851         return super.decreaseAllowance(spender, subtractedValue);
852     }
853 }
854 
855 // File: @openzeppelin/contracts/token/ERC20/ERC20Capped.sol
856 
857 pragma solidity ^0.5.0;
858 
859 
860 /**
861  * @dev Extension of {ERC20Mintable} that adds a cap to the supply of tokens.
862  */
863 contract ERC20Capped is ERC20Mintable {
864     uint256 private _cap;
865 
866     /**
867      * @dev Sets the value of the `cap`. This value is immutable, it can only be
868      * set once during construction.
869      */
870     constructor (uint256 cap) public {
871         require(cap > 0, "ERC20Capped: cap is 0");
872         _cap = cap;
873     }
874 
875     /**
876      * @dev Returns the cap on the token's total supply.
877      */
878     function cap() public view returns (uint256) {
879         return _cap;
880     }
881 
882     /**
883      * @dev See {ERC20Mintable-mint}.
884      *
885      * Requirements:
886      *
887      * - `value` must not cause the total supply to go over the cap.
888      */
889     function _mint(address account, uint256 value) internal {
890         require(totalSupply().add(value) <= _cap, "ERC20Capped: cap exceeded");
891         super._mint(account, value);
892     }
893 }
894 
895 // File: contracts/Token.sol
896 
897 pragma solidity 0.5.0;
898 
899 
900 
901 
902 
903 
904 
905 
906 contract Token is ERC20, ERC20Detailed, ERC20Burnable, ERC20Mintable, ERC20Pausable, ERC20Capped {
907   uint256 public _startTime;
908   uint256 public _mintCliff;
909 
910   uint256 public _tokensMintedInQuarter;
911   uint256 public _maxMintPerQuarter;
912   uint256 public _lastMintTime;
913 
914   uint256 public _tokensMintedTotal;
915   uint256 public _tokensMintCap;
916 
917   constructor(
918     uint256 initialSupply,
919     uint256 startTime,
920     uint256 mintCliff,
921     uint256 maxMintPerQuarter,
922     uint256 tokensMintCap
923   ) 
924     public
925     ERC20Detailed(
926       "Delta Exchange Token",
927       "DETO",
928       18
929     )
930     ERC20Capped(750*(10**6)*(10**18))
931   {
932     _startTime = startTime;
933     _mintCliff = mintCliff;
934     _maxMintPerQuarter = maxMintPerQuarter;
935     _tokensMintCap = tokensMintCap;
936     _tokensMintedTotal = initialSupply;
937     _mint(msg.sender, initialSupply);
938   }
939 
940   function mint(address account, uint256 amount) public onlyMinter returns (bool) {
941     require(block.timestamp >= _startTime.add(_mintCliff), "No minting allowed before mint cliff");
942     require(_tokensMintedTotal.add(amount) <= _tokensMintCap, "Mint cap reached");
943 
944     uint256 quarterStartTime = getQuarterStartTime();
945     uint256 maxMintable = getMaxMintable(quarterStartTime);
946     require(amount <= maxMintable, "Limit exceeded for minting this quarter");
947 
948     if( _lastMintTime < quarterStartTime ){
949         _tokensMintedInQuarter = amount;
950     } else{
951         _tokensMintedInQuarter = _tokensMintedInQuarter.add(amount);
952     }
953     _lastMintTime = block.timestamp;
954 
955     _tokensMintedTotal = _tokensMintedTotal.add(amount);
956     _mint(account, amount);
957 
958     return true;
959   }
960 
961   function getQuarterStartTime() public view returns (uint256){
962     uint256 cliffEndTime = _startTime.add(_mintCliff);
963     if( block.timestamp < cliffEndTime ){
964       return cliffEndTime;
965     } else{
966       uint256 quarter = 0.25*(365 days);
967       return cliffEndTime + ((block.timestamp - cliffEndTime)/(quarter))*(quarter);
968     }
969   }
970 
971   function getMaxMintable(uint256 quarterStartTime) public view returns (uint256){
972     if( _lastMintTime < quarterStartTime ){
973         return _maxMintPerQuarter;
974     } else{
975         return _maxMintPerQuarter - _tokensMintedInQuarter;
976     }
977   }
978 }