1 /* solhint-disable no-mix-tabs-and-spaces */
2 /* solhint-disable indent */
3 
4 pragma solidity 0.5.15;
5 
6 
7 
8 /**
9  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
10  * the optional functions; to access them see {ERC20Detailed}.
11  */
12 interface IERC20 {
13     /**
14      * @dev Returns the amount of tokens in existence.
15      */
16     function totalSupply() external view returns (uint256);
17 
18     /**
19      * @dev Returns the amount of tokens owned by `account`.
20      */
21     function balanceOf(address account) external view returns (uint256);
22 
23     /**
24      * @dev Moves `amount` tokens from the caller's account to `recipient`.
25      *
26      * Returns a boolean value indicating whether the operation succeeded.
27      *
28      * Emits a {Transfer} event.
29      */
30     function transfer(address recipient, uint256 amount) external returns (bool);
31 
32     /**
33      * @dev Returns the remaining number of tokens that `spender` will be
34      * allowed to spend on behalf of `owner` through {transferFrom}. This is
35      * zero by default.
36      *
37      * This value changes when {approve} or {transferFrom} are called.
38      */
39     function allowance(address owner, address spender) external view returns (uint256);
40 
41     /**
42      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
43      *
44      * Returns a boolean value indicating whether the operation succeeded.
45      *
46      * IMPORTANT: Beware that changing an allowance with this method brings the risk
47      * that someone may use both the old and the new allowance by unfortunate
48      * transaction ordering. One possible solution to mitigate this race
49      * condition is to first reduce the spender's allowance to 0 and set the
50      * desired value afterwards:
51      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
52      *
53      * Emits an {Approval} event.
54      */
55     function approve(address spender, uint256 amount) external returns (bool);
56 
57     /**
58      * @dev Moves `amount` tokens from `sender` to `recipient` using the
59      * allowance mechanism. `amount` is then deducted from the caller's
60      * allowance.
61      *
62      * Returns a boolean value indicating whether the operation succeeded.
63      *
64      * Emits a {Transfer} event.
65      */
66     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
67 
68     /**
69      * @dev Emitted when `value` tokens are moved from one account (`from`) to
70      * another (`to`).
71      *
72      * Note that `value` may be zero.
73      */
74     event Transfer(address indexed from, address indexed to, uint256 value);
75 
76     /**
77      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
78      * a call to {approve}. `value` is the new allowance.
79      */
80     event Approval(address indexed owner, address indexed spender, uint256 value);
81 }
82 
83 /**
84  * @dev Optional functions from the ERC20 standard.
85  */
86 contract ERC20Detailed is IERC20 {
87     string private _name;
88     string private _symbol;
89     uint8 private _decimals;
90 
91     /**
92      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
93      * these values are immutable: they can only be set once during
94      * construction.
95      */
96     constructor (string memory name, string memory symbol, uint8 decimals) public {
97         _name = name;
98         _symbol = symbol;
99         _decimals = decimals;
100     }
101 
102     /**
103      * @dev Returns the name of the token.
104      */
105     function name() public view returns (string memory) {
106         return _name;
107     }
108 
109     /**
110      * @dev Returns the symbol of the token, usually a shorter version of the
111      * name.
112      */
113     function symbol() public view returns (string memory) {
114         return _symbol;
115     }
116 
117     /**
118      * @dev Returns the number of decimals used to get its user representation.
119      * For example, if `decimals` equals `2`, a balance of `505` tokens should
120      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
121      *
122      * Tokens usually opt for a value of 18, imitating the relationship between
123      * Ether and Wei.
124      *
125      * NOTE: This information is only used for _display_ purposes: it in
126      * no way affects any of the arithmetic of the contract, including
127      * {IERC20-balanceOf} and {IERC20-transfer}.
128      */
129     function decimals() public view returns (uint8) {
130         return _decimals;
131     }
132 }
133 
134 
135 
136 
137 /*
138  * @dev Provides information about the current execution context, including the
139  * sender of the transaction and its data. While these are generally available
140  * via msg.sender and msg.data, they should not be accessed in such a direct
141  * manner, since when dealing with GSN meta-transactions the account sending and
142  * paying for execution may not be the actual sender (as far as an application
143  * is concerned).
144  *
145  * This contract is only required for intermediate, library-like contracts.
146  */
147 contract Context {
148     // Empty internal constructor, to prevent people from mistakenly deploying
149     // an instance of this contract, which should be used via inheritance.
150     constructor () internal { }
151     // solhint-disable-previous-line no-empty-blocks
152 
153     function _msgSender() internal view returns (address payable) {
154         return msg.sender;
155     }
156 
157     function _msgData() internal view returns (bytes memory) {
158         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
159         return msg.data;
160     }
161 }
162 
163 /**
164  * @dev Wrappers over Solidity's arithmetic operations with added overflow
165  * checks.
166  *
167  * Arithmetic operations in Solidity wrap on overflow. This can easily result
168  * in bugs, because programmers usually assume that an overflow raises an
169  * error, which is the standard behavior in high level programming languages.
170  * `SafeMath` restores this intuition by reverting the transaction when an
171  * operation overflows.
172  *
173  * Using this library instead of the unchecked operations eliminates an entire
174  * class of bugs, so it's recommended to use it always.
175  */
176 library SafeMath {
177     /**
178      * @dev Returns the addition of two unsigned integers, reverting on
179      * overflow.
180      *
181      * Counterpart to Solidity's `+` operator.
182      *
183      * Requirements:
184      * - Addition cannot overflow.
185      */
186     function add(uint256 a, uint256 b) internal pure returns (uint256) {
187         uint256 c = a + b;
188         require(c >= a, "SafeMath: addition overflow");
189 
190         return c;
191     }
192 
193     /**
194      * @dev Returns the subtraction of two unsigned integers, reverting on
195      * overflow (when the result is negative).
196      *
197      * Counterpart to Solidity's `-` operator.
198      *
199      * Requirements:
200      * - Subtraction cannot overflow.
201      */
202     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
203         return sub(a, b, "SafeMath: subtraction overflow");
204     }
205 
206     /**
207      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
208      * overflow (when the result is negative).
209      *
210      * Counterpart to Solidity's `-` operator.
211      *
212      * Requirements:
213      * - Subtraction cannot overflow.
214      *
215      * _Available since v2.4.0._
216      */
217     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
218         require(b <= a, errorMessage);
219         uint256 c = a - b;
220 
221         return c;
222     }
223 
224     /**
225      * @dev Returns the multiplication of two unsigned integers, reverting on
226      * overflow.
227      *
228      * Counterpart to Solidity's `*` operator.
229      *
230      * Requirements:
231      * - Multiplication cannot overflow.
232      */
233     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
234         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
235         // benefit is lost if 'b' is also tested.
236         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
237         if (a == 0) {
238             return 0;
239         }
240 
241         uint256 c = a * b;
242         require(c / a == b, "SafeMath: multiplication overflow");
243 
244         return c;
245     }
246 
247     /**
248      * @dev Returns the integer division of two unsigned integers. Reverts on
249      * division by zero. The result is rounded towards zero.
250      *
251      * Counterpart to Solidity's `/` operator. Note: this function uses a
252      * `revert` opcode (which leaves remaining gas untouched) while Solidity
253      * uses an invalid opcode to revert (consuming all remaining gas).
254      *
255      * Requirements:
256      * - The divisor cannot be zero.
257      */
258     function div(uint256 a, uint256 b) internal pure returns (uint256) {
259         return div(a, b, "SafeMath: division by zero");
260     }
261 
262     /**
263      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
264      * division by zero. The result is rounded towards zero.
265      *
266      * Counterpart to Solidity's `/` operator. Note: this function uses a
267      * `revert` opcode (which leaves remaining gas untouched) while Solidity
268      * uses an invalid opcode to revert (consuming all remaining gas).
269      *
270      * Requirements:
271      * - The divisor cannot be zero.
272      *
273      * _Available since v2.4.0._
274      */
275     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
276         // Solidity only automatically asserts when dividing by 0
277         require(b > 0, errorMessage);
278         uint256 c = a / b;
279         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
280 
281         return c;
282     }
283 
284     /**
285      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
286      * Reverts when dividing by zero.
287      *
288      * Counterpart to Solidity's `%` operator. This function uses a `revert`
289      * opcode (which leaves remaining gas untouched) while Solidity uses an
290      * invalid opcode to revert (consuming all remaining gas).
291      *
292      * Requirements:
293      * - The divisor cannot be zero.
294      */
295     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
296         return mod(a, b, "SafeMath: modulo by zero");
297     }
298 
299     /**
300      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
301      * Reverts with custom message when dividing by zero.
302      *
303      * Counterpart to Solidity's `%` operator. This function uses a `revert`
304      * opcode (which leaves remaining gas untouched) while Solidity uses an
305      * invalid opcode to revert (consuming all remaining gas).
306      *
307      * Requirements:
308      * - The divisor cannot be zero.
309      *
310      * _Available since v2.4.0._
311      */
312     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
313         require(b != 0, errorMessage);
314         return a % b;
315     }
316 }
317 
318 /**
319  * @dev Implementation of the {IERC20} interface.
320  *
321  * This implementation is agnostic to the way tokens are created. This means
322  * that a supply mechanism has to be added in a derived contract using {_mint}.
323  * For a generic mechanism see {ERC20Mintable}.
324  *
325  * TIP: For a detailed writeup see our guide
326  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
327  * to implement supply mechanisms].
328  *
329  * We have followed general OpenZeppelin guidelines: functions revert instead
330  * of returning `false` on failure. This behavior is nonetheless conventional
331  * and does not conflict with the expectations of ERC20 applications.
332  *
333  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
334  * This allows applications to reconstruct the allowance for all accounts just
335  * by listening to said events. Other implementations of the EIP may not emit
336  * these events, as it isn't required by the specification.
337  *
338  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
339  * functions have been added to mitigate the well-known issues around setting
340  * allowances. See {IERC20-approve}.
341  */
342 contract ERC20 is Context, IERC20 {
343     using SafeMath for uint256;
344 
345     mapping (address => uint256) private _balances;
346 
347     mapping (address => mapping (address => uint256)) private _allowances;
348 
349     uint256 private _totalSupply;
350 
351     /**
352      * @dev See {IERC20-totalSupply}.
353      */
354     function totalSupply() public view returns (uint256) {
355         return _totalSupply;
356     }
357 
358     /**
359      * @dev See {IERC20-balanceOf}.
360      */
361     function balanceOf(address account) public view returns (uint256) {
362         return _balances[account];
363     }
364 
365     /**
366      * @dev See {IERC20-transfer}.
367      *
368      * Requirements:
369      *
370      * - `recipient` cannot be the zero address.
371      * - the caller must have a balance of at least `amount`.
372      */
373     function transfer(address recipient, uint256 amount) public returns (bool) {
374         _transfer(_msgSender(), recipient, amount);
375         return true;
376     }
377 
378     /**
379      * @dev See {IERC20-allowance}.
380      */
381     function allowance(address owner, address spender) public view returns (uint256) {
382         return _allowances[owner][spender];
383     }
384 
385     /**
386      * @dev See {IERC20-approve}.
387      *
388      * Requirements:
389      *
390      * - `spender` cannot be the zero address.
391      */
392     function approve(address spender, uint256 amount) public returns (bool) {
393         _approve(_msgSender(), spender, amount);
394         return true;
395     }
396 
397     /**
398      * @dev See {IERC20-transferFrom}.
399      *
400      * Emits an {Approval} event indicating the updated allowance. This is not
401      * required by the EIP. See the note at the beginning of {ERC20};
402      *
403      * Requirements:
404      * - `sender` and `recipient` cannot be the zero address.
405      * - `sender` must have a balance of at least `amount`.
406      * - the caller must have allowance for `sender`'s tokens of at least
407      * `amount`.
408      */
409     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
410         _transfer(sender, recipient, amount);
411         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
412         return true;
413     }
414 
415     /**
416      * @dev Atomically increases the allowance granted to `spender` by the caller.
417      *
418      * This is an alternative to {approve} that can be used as a mitigation for
419      * problems described in {IERC20-approve}.
420      *
421      * Emits an {Approval} event indicating the updated allowance.
422      *
423      * Requirements:
424      *
425      * - `spender` cannot be the zero address.
426      */
427     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
428         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
429         return true;
430     }
431 
432     /**
433      * @dev Atomically decreases the allowance granted to `spender` by the caller.
434      *
435      * This is an alternative to {approve} that can be used as a mitigation for
436      * problems described in {IERC20-approve}.
437      *
438      * Emits an {Approval} event indicating the updated allowance.
439      *
440      * Requirements:
441      *
442      * - `spender` cannot be the zero address.
443      * - `spender` must have allowance for the caller of at least
444      * `subtractedValue`.
445      */
446     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
447         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
448         return true;
449     }
450 
451     /**
452      * @dev Moves tokens `amount` from `sender` to `recipient`.
453      *
454      * This is internal function is equivalent to {transfer}, and can be used to
455      * e.g. implement automatic token fees, slashing mechanisms, etc.
456      *
457      * Emits a {Transfer} event.
458      *
459      * Requirements:
460      *
461      * - `sender` cannot be the zero address.
462      * - `recipient` cannot be the zero address.
463      * - `sender` must have a balance of at least `amount`.
464      */
465     function _transfer(address sender, address recipient, uint256 amount) internal {
466         require(sender != address(0), "ERC20: transfer from the zero address");
467         require(recipient != address(0), "ERC20: transfer to the zero address");
468 
469         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
470         _balances[recipient] = _balances[recipient].add(amount);
471         emit Transfer(sender, recipient, amount);
472     }
473 
474     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
475      * the total supply.
476      *
477      * Emits a {Transfer} event with `from` set to the zero address.
478      *
479      * Requirements
480      *
481      * - `to` cannot be the zero address.
482      */
483     function _mint(address account, uint256 amount) internal {
484         require(account != address(0), "ERC20: mint to the zero address");
485 
486         _totalSupply = _totalSupply.add(amount);
487         _balances[account] = _balances[account].add(amount);
488         emit Transfer(address(0), account, amount);
489     }
490 
491     /**
492      * @dev Destroys `amount` tokens from `account`, reducing the
493      * total supply.
494      *
495      * Emits a {Transfer} event with `to` set to the zero address.
496      *
497      * Requirements
498      *
499      * - `account` cannot be the zero address.
500      * - `account` must have at least `amount` tokens.
501      */
502     function _burn(address account, uint256 amount) internal {
503         require(account != address(0), "ERC20: burn from the zero address");
504 
505         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
506         _totalSupply = _totalSupply.sub(amount);
507         emit Transfer(account, address(0), amount);
508     }
509 
510     /**
511      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
512      *
513      * This is internal function is equivalent to `approve`, and can be used to
514      * e.g. set automatic allowances for certain subsystems, etc.
515      *
516      * Emits an {Approval} event.
517      *
518      * Requirements:
519      *
520      * - `owner` cannot be the zero address.
521      * - `spender` cannot be the zero address.
522      */
523     function _approve(address owner, address spender, uint256 amount) internal {
524         require(owner != address(0), "ERC20: approve from the zero address");
525         require(spender != address(0), "ERC20: approve to the zero address");
526 
527         _allowances[owner][spender] = amount;
528         emit Approval(owner, spender, amount);
529     }
530 
531     /**
532      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
533      * from the caller's allowance.
534      *
535      * See {_burn} and {_approve}.
536      */
537     function _burnFrom(address account, uint256 amount) internal {
538         _burn(account, amount);
539         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
540     }
541 }
542 
543 
544 /**
545  * @title Roles
546  * @dev Library for managing addresses assigned to a Role.
547  */
548 library Roles {
549     struct Role {
550         mapping (address => bool) bearer;
551     }
552 
553     /**
554      * @dev Give an account access to this role.
555      */
556     function add(Role storage role, address account) internal {
557         require(!has(role, account), "Roles: account already has role");
558         role.bearer[account] = true;
559     }
560 
561     /**
562      * @dev Remove an account's access to this role.
563      */
564     function remove(Role storage role, address account) internal {
565         require(has(role, account), "Roles: account does not have role");
566         role.bearer[account] = false;
567     }
568 
569     /**
570      * @dev Check if an account has this role.
571      * @return bool
572      */
573     function has(Role storage role, address account) internal view returns (bool) {
574         require(account != address(0), "Roles: account is the zero address");
575         return role.bearer[account];
576     }
577 }
578 
579 contract MinterRole is Context {
580     using Roles for Roles.Role;
581 
582     event MinterAdded(address indexed account);
583     event MinterRemoved(address indexed account);
584 
585     Roles.Role private _minters;
586 
587     constructor () internal {
588         _addMinter(_msgSender());
589     }
590 
591     modifier onlyMinter() {
592         require(isMinter(_msgSender()), "MinterRole: caller does not have the Minter role");
593         _;
594     }
595 
596     function isMinter(address account) public view returns (bool) {
597         return _minters.has(account);
598     }
599 
600     function addMinter(address account) public onlyMinter {
601         _addMinter(account);
602     }
603 
604     function renounceMinter() public {
605         _removeMinter(_msgSender());
606     }
607 
608     function _addMinter(address account) internal {
609         _minters.add(account);
610         emit MinterAdded(account);
611     }
612 
613     function _removeMinter(address account) internal {
614         _minters.remove(account);
615         emit MinterRemoved(account);
616     }
617 }
618 
619 /**
620  * @dev Extension of {ERC20} that adds a set of accounts with the {MinterRole},
621  * which have permission to mint (create) new tokens as they see fit.
622  *
623  * At construction, the deployer of the contract is the only minter.
624  */
625 contract ERC20Mintable is ERC20, MinterRole {
626     /**
627      * @dev See {ERC20-_mint}.
628      *
629      * Requirements:
630      *
631      * - the caller must have the {MinterRole}.
632      */
633     function mint(address account, uint256 amount) public onlyMinter returns (bool) {
634         _mint(account, amount);
635         return true;
636     }
637 }
638 
639 /**
640  * @dev Extension of {ERC20Mintable} that adds a cap to the supply of tokens.
641  */
642 contract ERC20Capped is ERC20Mintable {
643     uint256 private _cap;
644 
645     /**
646      * @dev Sets the value of the `cap`. This value is immutable, it can only be
647      * set once during construction.
648      */
649     constructor (uint256 cap) public {
650         require(cap > 0, "ERC20Capped: cap is 0");
651         _cap = cap;
652     }
653 
654     /**
655      * @dev Returns the cap on the token's total supply.
656      */
657     function cap() public view returns (uint256) {
658         return _cap;
659     }
660 
661     /**
662      * @dev See {ERC20Mintable-mint}.
663      *
664      * Requirements:
665      *
666      * - `value` must not cause the total supply to go over the cap.
667      */
668     function _mint(address account, uint256 value) internal {
669         require(totalSupply().add(value) <= _cap, "ERC20Capped: cap exceeded");
670         super._mint(account, value);
671     }
672 }
673 
674 
675 /**
676  * @dev Extension of {ERC20} that allows token holders to destroy both their own
677  * tokens and those that they have an allowance for, in a way that can be
678  * recognized off-chain (via event analysis).
679  */
680 contract ERC20Burnable is Context, ERC20 {
681     /**
682      * @dev Destroys `amount` tokens from the caller.
683      *
684      * See {ERC20-_burn}.
685      */
686     function burn(uint256 amount) public {
687         _burn(_msgSender(), amount);
688     }
689 
690     /**
691      * @dev See {ERC20-_burnFrom}.
692      */
693     function burnFrom(address account, uint256 amount) public {
694         _burnFrom(account, amount);
695     }
696 }
697 
698 
699 
700 
701 contract PauserRole is Context {
702     using Roles for Roles.Role;
703 
704     event PauserAdded(address indexed account);
705     event PauserRemoved(address indexed account);
706 
707     Roles.Role private _pausers;
708 
709     constructor () internal {
710         _addPauser(_msgSender());
711     }
712 
713     modifier onlyPauser() {
714         require(isPauser(_msgSender()), "PauserRole: caller does not have the Pauser role");
715         _;
716     }
717 
718     function isPauser(address account) public view returns (bool) {
719         return _pausers.has(account);
720     }
721 
722     function addPauser(address account) public onlyPauser {
723         _addPauser(account);
724     }
725 
726     function renouncePauser() public {
727         _removePauser(_msgSender());
728     }
729 
730     function _addPauser(address account) internal {
731         _pausers.add(account);
732         emit PauserAdded(account);
733     }
734 
735     function _removePauser(address account) internal {
736         _pausers.remove(account);
737         emit PauserRemoved(account);
738     }
739 }
740 
741 /**
742  * @dev Contract module which allows children to implement an emergency stop
743  * mechanism that can be triggered by an authorized account.
744  *
745  * This module is used through inheritance. It will make available the
746  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
747  * the functions of your contract. Note that they will not be pausable by
748  * simply including this module, only once the modifiers are put in place.
749  */
750 contract Pausable is Context, PauserRole {
751     /**
752      * @dev Emitted when the pause is triggered by a pauser (`account`).
753      */
754     event Paused(address account);
755 
756     /**
757      * @dev Emitted when the pause is lifted by a pauser (`account`).
758      */
759     event Unpaused(address account);
760 
761     bool private _paused;
762 
763     /**
764      * @dev Initializes the contract in unpaused state. Assigns the Pauser role
765      * to the deployer.
766      */
767     constructor () internal {
768         _paused = false;
769     }
770 
771     /**
772      * @dev Returns true if the contract is paused, and false otherwise.
773      */
774     function paused() public view returns (bool) {
775         return _paused;
776     }
777 
778     /**
779      * @dev Modifier to make a function callable only when the contract is not paused.
780      */
781     modifier whenNotPaused() {
782         require(!_paused, "Pausable: paused");
783         _;
784     }
785 
786     /**
787      * @dev Modifier to make a function callable only when the contract is paused.
788      */
789     modifier whenPaused() {
790         require(_paused, "Pausable: not paused");
791         _;
792     }
793 
794     /**
795      * @dev Called by a pauser to pause, triggers stopped state.
796      */
797     function pause() public onlyPauser whenNotPaused {
798         _paused = true;
799         emit Paused(_msgSender());
800     }
801 
802     /**
803      * @dev Called by a pauser to unpause, returns to normal state.
804      */
805     function unpause() public onlyPauser whenPaused {
806         _paused = false;
807         emit Unpaused(_msgSender());
808     }
809 }
810 
811 /**
812  * @title Pausable token
813  * @dev ERC20 with pausable transfers and allowances.
814  *
815  * Useful if you want to stop trades until the end of a crowdsale, or have
816  * an emergency switch for freezing all token transfers in the event of a large
817  * bug.
818  */
819 contract ERC20Pausable is ERC20, Pausable {
820     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
821         return super.transfer(to, value);
822     }
823 
824     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
825         return super.transferFrom(from, to, value);
826     }
827 
828     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
829         return super.approve(spender, value);
830     }
831 
832     function increaseAllowance(address spender, uint256 addedValue) public whenNotPaused returns (bool) {
833         return super.increaseAllowance(spender, addedValue);
834     }
835 
836     function decreaseAllowance(address spender, uint256 subtractedValue) public whenNotPaused returns (bool) {
837         return super.decreaseAllowance(spender, subtractedValue);
838     }
839 }
840 /* solhint-disable no-mix-tabs-and-spaces */
841 /* solhint-disable indent */
842 
843 interface IShardGovernor {
844 	function claimInitialShotgun(
845 		address payable initialClaimantAddress,
846 		uint initialClaimantBalance
847 	) external payable returns (bool);
848 
849 	function transferShards(
850 		address recipient,
851 		uint amount
852 	) external;
853 
854 	function enactShotgun() external;
855 	function offererAddress() external view returns (address);
856 	function checkLock() external view returns (bool);
857 	function checkShotgunState() external view returns (bool);
858 	function getNftRegistryAddress() external view returns (address);
859 	function getNftTokenIds() external view returns (uint256[] memory);
860 	function getOwner() external view returns (address);
861 }
862 /* solhint-disable no-mix-tabs-and-spaces */
863 /* solhint-disable indent */
864 
865 
866 
867 interface IShotgunClause {
868 	enum ClaimWinner { None, Claimant, Counterclaimant }
869 
870 	function counterCommitEther() external payable;
871 
872 	function collectEtherProceeds(
873 		uint balance,
874 		address payable caller
875 	) external;
876 
877 	function collectShardProceeds() external;
878 	function enactShotgun() external;
879 
880 	function deadlineTimestamp() external view returns (uint256);
881 	function shotgunEnacted() external view returns (bool);
882 	function initialClaimantAddress() external view returns (address);
883 	function initialClaimantBalance() external view returns (uint);
884 	function initialOfferInWei() external view returns (uint256);
885 	function pricePerShardInWei() external view returns (uint256);
886 	function claimWinner() external view returns (ClaimWinner);
887 	function counterclaimants() external view returns (address[] memory);
888 
889 	function getCounterclaimantContribution(
890 		address counterclaimant
891 	) external view returns (uint);
892 
893 	function counterWeiContributed() external view returns (uint);
894 	function getContractBalance() external view returns (uint);
895 	function shardGovernor() external view returns (address);
896 	function getRequiredWeiForCounterclaim() external view returns (uint);
897 }
898 
899 /**
900 	* @title ERC20 base for Shards with additional methods related to governance
901 	* @author Joel Hubert (Metalith.io)
902 	* @dev OpenZeppelin contracts are not ready for 0.6.0 yet, using 0.5.16.
903 	*/
904 
905 contract ShardRegistry is ERC20Detailed, ERC20Capped, ERC20Burnable, ERC20Pausable {
906 
907 	IShardGovernor private _shardGovernor;
908 	enum ClaimWinner { None, Claimant, Counterclaimant }
909 	bool private _shotgunDisabled;
910 
911 	constructor (
912 		uint256 cap,
913 		string memory name,
914 		string memory symbol,
915 		bool shotgunDisabled,
916 		address shardGovernorAddress
917 	) ERC20Detailed(name, symbol, 18) ERC20Capped(cap) public {
918 		_shardGovernor = IShardGovernor(shardGovernorAddress);
919 		_shotgunDisabled = shotgunDisabled;
920 	}
921 
922 	/**
923 		* @notice Called to initiate Shotgun claim. Requires Ether.
924 		* @dev Transfers claimant's Shards into Governor contract's custody until
925 		claim is resolved.
926 		* @dev Forwards Ether to Shotgun contract through Governor contract.
927 		*/
928 	function lockShardsAndClaim() external payable {
929 		require(
930 				!_shotgunDisabled,
931 				"[lockShardsAndClaim] Shotgun disabled"
932 		);
933 		require(
934 			_shardGovernor.checkLock(),
935 			"[lockShardsAndClaim] NFT not locked, Shotgun cannot be triggered"
936 		);
937 		require(
938 			_shardGovernor.checkShotgunState(),
939 			"[lockShardsAndClaim] Shotgun already in progress"
940 		);
941 		require(
942 			msg.value > 0,
943 			"[lockShardsAndClaim] Transaction must send ether to activate Shotgun Clause"
944 		);
945 		uint initialClaimantBalance = balanceOf(msg.sender);
946 		require(
947 			initialClaimantBalance > 0,
948 			"[lockShardsAndClaim] Account does not own Shards"
949 		);
950 		require(
951 			initialClaimantBalance < cap(),
952 			"[lockShardsAndClaim] Account owns all Shards"
953 		);
954 		transfer(address(_shardGovernor), balanceOf(msg.sender));
955 		(bool success) = _shardGovernor.claimInitialShotgun.value(msg.value)(
956 			msg.sender, initialClaimantBalance
957 		);
958 		require(
959 			success,
960 			"[lockShards] Ether forwarding unsuccessful"
961 		);
962 	}
963 
964 	/**
965 		* @notice Called to collect Ether from Shotgun proceeds. Burns Shard holdings.
966 		* @dev can be called in both Shotgun outcome scenarios by:
967 		- Initial claimant, if they lose the claim to counterclaimants and their
968 		Shards are bought out
969 		- Counterclaimants, bought out if initial claimant is successful.
970 		* @dev initial claimant does not own Shards at this point because they have
971 		been custodied in Governor contract at start of Shotgun.
972 		* @param shotgunClause address of the relevant Shotgun contract.
973 		*/
974 	function burnAndCollectEther(address shotgunClause) external {
975 		IShotgunClause _shotgunClause = IShotgunClause(shotgunClause);
976 		bool enacted = _shotgunClause.shotgunEnacted();
977 		if (!enacted) {
978 			_shotgunClause.enactShotgun();
979 		}
980 		require(
981 			enacted || _shotgunClause.shotgunEnacted(),
982 			"[burnAndCollectEther] Shotgun Clause not enacted"
983 		);
984 		uint balance = balanceOf(msg.sender);
985 		require(
986 			balance > 0 || msg.sender == _shotgunClause.initialClaimantAddress(),
987 			"[burnAndCollectEther] Account does not own Shards"
988 		);
989 		require(
990 			uint(_shotgunClause.claimWinner()) == uint(ClaimWinner.Claimant) &&
991 			msg.sender != _shotgunClause.initialClaimantAddress() ||
992 			uint(_shotgunClause.claimWinner()) == uint(ClaimWinner.Counterclaimant) &&
993 			msg.sender == _shotgunClause.initialClaimantAddress(),
994 			"[burnAndCollectEther] Account does not have right to collect ether"
995 		);
996 		burn(balance);
997 		_shotgunClause.collectEtherProceeds(balance, msg.sender);
998 	}
999 
1000 	function shotgunDisabled() external view returns (bool) {
1001 		return _shotgunDisabled;
1002 	}
1003 }