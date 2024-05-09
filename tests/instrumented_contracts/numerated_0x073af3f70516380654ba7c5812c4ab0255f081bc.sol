1 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
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
160 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
161 
162 pragma solidity ^0.5.0;
163 
164 /**
165  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
166  * the optional functions; to access them see {ERC20Detailed}.
167  */
168 interface IERC20 {
169     /**
170      * @dev Returns the amount of tokens in existence.
171      */
172     function totalSupply() external view returns (uint256);
173 
174     /**
175      * @dev Returns the amount of tokens owned by `account`.
176      */
177     function balanceOf(address account) external view returns (uint256);
178 
179     /**
180      * @dev Moves `amount` tokens from the caller's account to `recipient`.
181      *
182      * Returns a boolean value indicating whether the operation succeeded.
183      *
184      * Emits a {Transfer} event.
185      */
186     function transfer(address recipient, uint256 amount) external returns (bool);
187 
188     /**
189      * @dev Returns the remaining number of tokens that `spender` will be
190      * allowed to spend on behalf of `owner` through {transferFrom}. This is
191      * zero by default.
192      *
193      * This value changes when {approve} or {transferFrom} are called.
194      */
195     function allowance(address owner, address spender) external view returns (uint256);
196 
197     /**
198      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
199      *
200      * Returns a boolean value indicating whether the operation succeeded.
201      *
202      * IMPORTANT: Beware that changing an allowance with this method brings the risk
203      * that someone may use both the old and the new allowance by unfortunate
204      * transaction ordering. One possible solution to mitigate this race
205      * condition is to first reduce the spender's allowance to 0 and set the
206      * desired value afterwards:
207      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
208      *
209      * Emits an {Approval} event.
210      */
211     function approve(address spender, uint256 amount) external returns (bool);
212 
213     /**
214      * @dev Moves `amount` tokens from `sender` to `recipient` using the
215      * allowance mechanism. `amount` is then deducted from the caller's
216      * allowance.
217      *
218      * Returns a boolean value indicating whether the operation succeeded.
219      *
220      * Emits a {Transfer} event.
221      */
222     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
223 
224     /**
225      * @dev Emitted when `value` tokens are moved from one account (`from`) to
226      * another (`to`).
227      *
228      * Note that `value` may be zero.
229      */
230     event Transfer(address indexed from, address indexed to, uint256 value);
231 
232     /**
233      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
234      * a call to {approve}. `value` is the new allowance.
235      */
236     event Approval(address indexed owner, address indexed spender, uint256 value);
237 }
238 
239 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Detailed.sol
240 
241 pragma solidity ^0.5.0;
242 
243 
244 /**
245  * @dev Optional functions from the ERC20 standard.
246  */
247 contract ERC20Detailed is IERC20 {
248     string private _name;
249     string private _symbol;
250     uint8 private _decimals;
251 
252     /**
253      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
254      * these values are immutable: they can only be set once during
255      * construction.
256      */
257     constructor (string memory name, string memory symbol, uint8 decimals) public {
258         _name = name;
259         _symbol = symbol;
260         _decimals = decimals;
261     }
262 
263     /**
264      * @dev Returns the name of the token.
265      */
266     function name() public view returns (string memory) {
267         return _name;
268     }
269 
270     /**
271      * @dev Returns the symbol of the token, usually a shorter version of the
272      * name.
273      */
274     function symbol() public view returns (string memory) {
275         return _symbol;
276     }
277 
278     /**
279      * @dev Returns the number of decimals used to get its user representation.
280      * For example, if `decimals` equals `2`, a balance of `505` tokens should
281      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
282      *
283      * Tokens usually opt for a value of 18, imitating the relationship between
284      * Ether and Wei.
285      *
286      * NOTE: This information is only used for _display_ purposes: it in
287      * no way affects any of the arithmetic of the contract, including
288      * {IERC20-balanceOf} and {IERC20-transfer}.
289      */
290     function decimals() public view returns (uint8) {
291         return _decimals;
292     }
293 }
294 
295 // File: openzeppelin-solidity/contracts/GSN/Context.sol
296 
297 pragma solidity ^0.5.0;
298 
299 /*
300  * @dev Provides information about the current execution context, including the
301  * sender of the transaction and its data. While these are generally available
302  * via msg.sender and msg.data, they should not be accessed in such a direct
303  * manner, since when dealing with GSN meta-transactions the account sending and
304  * paying for execution may not be the actual sender (as far as an application
305  * is concerned).
306  *
307  * This contract is only required for intermediate, library-like contracts.
308  */
309 contract Context {
310     // Empty internal constructor, to prevent people from mistakenly deploying
311     // an instance of this contract, which should be used via inheritance.
312     constructor () internal { }
313     // solhint-disable-previous-line no-empty-blocks
314 
315     function _msgSender() internal view returns (address payable) {
316         return msg.sender;
317     }
318 
319     function _msgData() internal view returns (bytes memory) {
320         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
321         return msg.data;
322     }
323 }
324 
325 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
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
505     /**
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
557 // File: openzeppelin-solidity/contracts/access/Roles.sol
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
596 // File: openzeppelin-solidity/contracts/access/roles/PauserRole.sol
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
642 // File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol
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
718 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Pausable.sol
719 
720 pragma solidity ^0.5.0;
721 
722 
723 
724 /**
725  * @title Pausable token
726  * @dev ERC20 with pausable transfers and allowances.
727  *
728  * Useful if you want to stop trades until the end of a crowdsale, or have
729  * an emergency switch for freezing all token transfers in the event of a large
730  * bug.
731  */
732 contract ERC20Pausable is ERC20, Pausable {
733     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
734         return super.transfer(to, value);
735     }
736 
737     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
738         return super.transferFrom(from, to, value);
739     }
740 
741     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
742         return super.approve(spender, value);
743     }
744 
745     function increaseAllowance(address spender, uint256 addedValue) public whenNotPaused returns (bool) {
746         return super.increaseAllowance(spender, addedValue);
747     }
748 
749     function decreaseAllowance(address spender, uint256 subtractedValue) public whenNotPaused returns (bool) {
750         return super.decreaseAllowance(spender, subtractedValue);
751     }
752 }
753 
754 // File: openzeppelin-solidity/contracts/access/roles/MinterRole.sol
755 
756 pragma solidity ^0.5.0;
757 
758 
759 
760 contract MinterRole is Context {
761     using Roles for Roles.Role;
762 
763     event MinterAdded(address indexed account);
764     event MinterRemoved(address indexed account);
765 
766     Roles.Role private _minters;
767 
768     constructor () internal {
769         _addMinter(_msgSender());
770     }
771 
772     modifier onlyMinter() {
773         require(isMinter(_msgSender()), "MinterRole: caller does not have the Minter role");
774         _;
775     }
776 
777     function isMinter(address account) public view returns (bool) {
778         return _minters.has(account);
779     }
780 
781     function addMinter(address account) public onlyMinter {
782         _addMinter(account);
783     }
784 
785     function renounceMinter() public {
786         _removeMinter(_msgSender());
787     }
788 
789     function _addMinter(address account) internal {
790         _minters.add(account);
791         emit MinterAdded(account);
792     }
793 
794     function _removeMinter(address account) internal {
795         _minters.remove(account);
796         emit MinterRemoved(account);
797     }
798 }
799 
800 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Mintable.sol
801 
802 pragma solidity ^0.5.0;
803 
804 
805 
806 /**
807  * @dev Extension of {ERC20} that adds a set of accounts with the {MinterRole},
808  * which have permission to mint (create) new tokens as they see fit.
809  *
810  * At construction, the deployer of the contract is the only minter.
811  */
812 contract ERC20Mintable is ERC20, MinterRole {
813     /**
814      * @dev See {ERC20-_mint}.
815      *
816      * Requirements:
817      *
818      * - the caller must have the {MinterRole}.
819      */
820     function mint(address account, uint256 amount) public onlyMinter returns (bool) {
821         _mint(account, amount);
822         return true;
823     }
824 }
825 
826 // File: contracts/token/BurnerRole.sol
827 
828 pragma solidity ^0.5.0;
829 
830 
831 
832 contract BurnerRole {
833     using Roles for Roles.Role;
834 
835     event BurnerAdded(address indexed account);
836     event BurnerRemoved(address indexed account);
837 
838     Roles.Role private _burners;
839 
840     constructor () internal {
841         _addBurner(msg.sender);
842     }
843 
844     modifier onlyBurner() {
845         require(isBurner(msg.sender));
846         _;
847     }
848 
849     function isBurner(address account) public view returns (bool) {
850         return _burners.has(account);
851     }
852 
853     function addBurner(address account) public onlyBurner {
854         _addBurner(account);
855     }
856 
857     function renounceBurner() public {
858         _removeBurner(msg.sender);
859     }
860 
861     function _addBurner(address account) internal {
862         _burners.add(account);
863         emit BurnerAdded(account);
864     }
865 
866     function _removeBurner(address account) internal {
867         _burners.remove(account);
868         emit BurnerRemoved(account);
869     }
870 }
871 
872 // File: contracts/token/ERC20Burnable.sol
873 
874 pragma solidity ^0.5.0;
875 
876 
877 
878 
879 // Only allow accounts with the burner role to burn tokens.
880 contract ERC20Burnable is ERC20, BurnerRole {
881     function burn(uint256 value) public onlyBurner() {
882         _burn(msg.sender, value);
883     }
884 
885     function burnFrom(address from, uint256 value) public onlyBurner() {
886         _burnFrom(from, value);
887     }
888 }
889 
890 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
891 
892 pragma solidity ^0.5.0;
893 
894 /**
895  * @dev Contract module which provides a basic access control mechanism, where
896  * there is an account (an owner) that can be granted exclusive access to
897  * specific functions.
898  *
899  * This module is used through inheritance. It will make available the modifier
900  * `onlyOwner`, which can be applied to your functions to restrict their use to
901  * the owner.
902  */
903 contract Ownable is Context {
904     address private _owner;
905 
906     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
907 
908     /**
909      * @dev Initializes the contract setting the deployer as the initial owner.
910      */
911     constructor () internal {
912         address msgSender = _msgSender();
913         _owner = msgSender;
914         emit OwnershipTransferred(address(0), msgSender);
915     }
916 
917     /**
918      * @dev Returns the address of the current owner.
919      */
920     function owner() public view returns (address) {
921         return _owner;
922     }
923 
924     /**
925      * @dev Throws if called by any account other than the owner.
926      */
927     modifier onlyOwner() {
928         require(isOwner(), "Ownable: caller is not the owner");
929         _;
930     }
931 
932     /**
933      * @dev Returns true if the caller is the current owner.
934      */
935     function isOwner() public view returns (bool) {
936         return _msgSender() == _owner;
937     }
938 
939     /**
940      * @dev Leaves the contract without owner. It will not be possible to call
941      * `onlyOwner` functions anymore. Can only be called by the current owner.
942      *
943      * NOTE: Renouncing ownership will leave the contract without an owner,
944      * thereby removing any functionality that is only available to the owner.
945      */
946     function renounceOwnership() public onlyOwner {
947         emit OwnershipTransferred(_owner, address(0));
948         _owner = address(0);
949     }
950 
951     /**
952      * @dev Transfers ownership of the contract to a new account (`newOwner`).
953      * Can only be called by the current owner.
954      */
955     function transferOwnership(address newOwner) public onlyOwner {
956         _transferOwnership(newOwner);
957     }
958 
959     /**
960      * @dev Transfers ownership of the contract to a new account (`newOwner`).
961      */
962     function _transferOwnership(address newOwner) internal {
963         require(newOwner != address(0), "Ownable: new owner is the zero address");
964         emit OwnershipTransferred(_owner, newOwner);
965         _owner = newOwner;
966     }
967 }
968 
969 // File: contracts/utils/CanReclaimEther.sol
970 
971 pragma solidity ^0.5.0;
972 
973 
974 
975 // Ether should not be sent to this contract. If any ether is accidentally sent to this
976 // contract, allow the contract owner to recover it.
977 // Copied from https://github.com/OpenZeppelin/openzeppelin-solidity/blob/2441fd7d17bffa1944f6f539b2cddd6d19997a31/contracts/ownership/HasNoEther.sol
978 contract CanReclaimEther is Ownable {
979     function reclaimEther() external onlyOwner {
980         msg.sender.transfer(address(this).balance);
981     }
982 }
983 
984 // File: openzeppelin-solidity/contracts/utils/Address.sol
985 
986 pragma solidity ^0.5.5;
987 
988 /**
989  * @dev Collection of functions related to the address type
990  */
991 library Address {
992     /**
993      * @dev Returns true if `account` is a contract.
994      *
995      * [IMPORTANT]
996      * ====
997      * It is unsafe to assume that an address for which this function returns
998      * false is an externally-owned account (EOA) and not a contract.
999      *
1000      * Among others, `isContract` will return false for the following 
1001      * types of addresses:
1002      *
1003      *  - an externally-owned account
1004      *  - a contract in construction
1005      *  - an address where a contract will be created
1006      *  - an address where a contract lived, but was destroyed
1007      * ====
1008      */
1009     function isContract(address account) internal view returns (bool) {
1010         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
1011         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
1012         // for accounts without code, i.e. `keccak256('')`
1013         bytes32 codehash;
1014         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
1015         // solhint-disable-next-line no-inline-assembly
1016         assembly { codehash := extcodehash(account) }
1017         return (codehash != accountHash && codehash != 0x0);
1018     }
1019 
1020     /**
1021      * @dev Converts an `address` into `address payable`. Note that this is
1022      * simply a type cast: the actual underlying value is not changed.
1023      *
1024      * _Available since v2.4.0._
1025      */
1026     function toPayable(address account) internal pure returns (address payable) {
1027         return address(uint160(account));
1028     }
1029 
1030     /**
1031      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
1032      * `recipient`, forwarding all available gas and reverting on errors.
1033      *
1034      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
1035      * of certain opcodes, possibly making contracts go over the 2300 gas limit
1036      * imposed by `transfer`, making them unable to receive funds via
1037      * `transfer`. {sendValue} removes this limitation.
1038      *
1039      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
1040      *
1041      * IMPORTANT: because control is transferred to `recipient`, care must be
1042      * taken to not create reentrancy vulnerabilities. Consider using
1043      * {ReentrancyGuard} or the
1044      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
1045      *
1046      * _Available since v2.4.0._
1047      */
1048     function sendValue(address payable recipient, uint256 amount) internal {
1049         require(address(this).balance >= amount, "Address: insufficient balance");
1050 
1051         // solhint-disable-next-line avoid-call-value
1052         (bool success, ) = recipient.call.value(amount)("");
1053         require(success, "Address: unable to send value, recipient may have reverted");
1054     }
1055 }
1056 
1057 // File: openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol
1058 
1059 pragma solidity ^0.5.0;
1060 
1061 
1062 
1063 
1064 /**
1065  * @title SafeERC20
1066  * @dev Wrappers around ERC20 operations that throw on failure (when the token
1067  * contract returns false). Tokens that return no value (and instead revert or
1068  * throw on failure) are also supported, non-reverting calls are assumed to be
1069  * successful.
1070  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
1071  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
1072  */
1073 library SafeERC20 {
1074     using SafeMath for uint256;
1075     using Address for address;
1076 
1077     function safeTransfer(IERC20 token, address to, uint256 value) internal {
1078         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
1079     }
1080 
1081     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
1082         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
1083     }
1084 
1085     function safeApprove(IERC20 token, address spender, uint256 value) internal {
1086         // safeApprove should only be called when setting an initial allowance,
1087         // or when resetting it to zero. To increase and decrease it, use
1088         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
1089         // solhint-disable-next-line max-line-length
1090         require((value == 0) || (token.allowance(address(this), spender) == 0),
1091             "SafeERC20: approve from non-zero to non-zero allowance"
1092         );
1093         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
1094     }
1095 
1096     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
1097         uint256 newAllowance = token.allowance(address(this), spender).add(value);
1098         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
1099     }
1100 
1101     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
1102         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
1103         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
1104     }
1105 
1106     /**
1107      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
1108      * on the return value: the return value is optional (but if data is returned, it must not be false).
1109      * @param token The token targeted by the call.
1110      * @param data The call data (encoded using abi.encode or one of its variants).
1111      */
1112     function callOptionalReturn(IERC20 token, bytes memory data) private {
1113         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
1114         // we're implementing it ourselves.
1115 
1116         // A Solidity high level call has three parts:
1117         //  1. The target address is checked to verify it contains contract code
1118         //  2. The call itself is made, and success asserted
1119         //  3. The return value is decoded, which in turn checks the size of the returned data.
1120         // solhint-disable-next-line max-line-length
1121         require(address(token).isContract(), "SafeERC20: call to non-contract");
1122 
1123         // solhint-disable-next-line avoid-low-level-calls
1124         (bool success, bytes memory returndata) = address(token).call(data);
1125         require(success, "SafeERC20: low-level call failed");
1126 
1127         if (returndata.length > 0) { // Return data is optional
1128             // solhint-disable-next-line max-line-length
1129             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
1130         }
1131     }
1132 }
1133 
1134 // File: contracts/utils/CanReclaimToken.sol
1135 
1136 pragma solidity ^0.5.0;
1137 
1138 
1139 
1140 
1141 // Tokens should not be sent to this contract.  If any tokens are accidentally sent to
1142 // this contract, allow the contract owner to recover them.
1143 // Copied from https://github.com/OpenZeppelin/openzeppelin-solidity/blob/6c4c8989b399510a66d8b98ad75a0979482436d2/contracts/ownership/CanReclaimToken.sol
1144 contract CanReclaimToken is Ownable {
1145     using SafeERC20 for IERC20;
1146 
1147     function reclaimToken(IERC20 token) external onlyOwner {
1148         uint256 balance = token.balanceOf(address(this));
1149         token.safeTransfer(owner(), balance);
1150     }
1151 }
1152 
1153 // File: contracts/token/GenericToken.sol
1154 
1155 pragma solidity ^0.5.0;
1156 
1157 
1158 
1159 
1160 
1161 
1162 
1163 
1164 
1165 contract GenericToken is
1166     ERC20Detailed,
1167     ERC20Pausable,
1168     ERC20Mintable,
1169     ERC20Burnable,
1170     CanReclaimEther,
1171     CanReclaimToken
1172 {
1173     constructor(string memory name, string memory symbol)
1174         ERC20Detailed(name, symbol, 18)
1175         public
1176     {
1177     }
1178 }