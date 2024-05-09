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
843 
844 
845 
846 /**
847  * @dev Interface of the ERC165 standard, as defined in the
848  * https://eips.ethereum.org/EIPS/eip-165[EIP].
849  *
850  * Implementers can declare support of contract interfaces, which can then be
851  * queried by others ({ERC165Checker}).
852  *
853  * For an implementation, see {ERC165}.
854  */
855 interface IERC165 {
856     /**
857      * @dev Returns true if this contract implements the interface defined by
858      * `interfaceId`. See the corresponding
859      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
860      * to learn more about how these ids are created.
861      *
862      * This function call must use less than 30 000 gas.
863      */
864     function supportsInterface(bytes4 interfaceId) external view returns (bool);
865 }
866 
867 /**
868  * @dev Required interface of an ERC721 compliant contract.
869  */
870 contract IERC721 is IERC165 {
871     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
872     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
873     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
874 
875     /**
876      * @dev Returns the number of NFTs in `owner`'s account.
877      */
878     function balanceOf(address owner) public view returns (uint256 balance);
879 
880     /**
881      * @dev Returns the owner of the NFT specified by `tokenId`.
882      */
883     function ownerOf(uint256 tokenId) public view returns (address owner);
884 
885     /**
886      * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to
887      * another (`to`).
888      *
889      *
890      *
891      * Requirements:
892      * - `from`, `to` cannot be zero.
893      * - `tokenId` must be owned by `from`.
894      * - If the caller is not `from`, it must be have been allowed to move this
895      * NFT by either {approve} or {setApprovalForAll}.
896      */
897     function safeTransferFrom(address from, address to, uint256 tokenId) public;
898     /**
899      * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to
900      * another (`to`).
901      *
902      * Requirements:
903      * - If the caller is not `from`, it must be approved to move this NFT by
904      * either {approve} or {setApprovalForAll}.
905      */
906     function transferFrom(address from, address to, uint256 tokenId) public;
907     function approve(address to, uint256 tokenId) public;
908     function getApproved(uint256 tokenId) public view returns (address operator);
909 
910     function setApprovalForAll(address operator, bool _approved) public;
911     function isApprovedForAll(address owner, address operator) public view returns (bool);
912 
913 
914     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public;
915 }
916 
917 /**
918  * @title ERC721 token receiver interface
919  * @dev Interface for any contract that wants to support safeTransfers
920  * from ERC721 asset contracts.
921  */
922 contract IERC721Receiver {
923     /**
924      * @notice Handle the receipt of an NFT
925      * @dev The ERC721 smart contract calls this function on the recipient
926      * after a {IERC721-safeTransferFrom}. This function MUST return the function selector,
927      * otherwise the caller will revert the transaction. The selector to be
928      * returned can be obtained as `this.onERC721Received.selector`. This
929      * function MAY throw to revert and reject the transfer.
930      * Note: the ERC721 contract address is always the message sender.
931      * @param operator The address which called `safeTransferFrom` function
932      * @param from The address which previously owned the token
933      * @param tokenId The NFT identifier which is being transferred
934      * @param data Additional data with no specified format
935      * @return bytes4 `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
936      */
937     function onERC721Received(address operator, address from, uint256 tokenId, bytes memory data)
938     public returns (bytes4);
939 }
940 /* solhint-disable no-mix-tabs-and-spaces */
941 /* solhint-disable indent */
942 
943 
944 
945 /**
946 	* @title Contract managing Shard Offering lifecycle, similar to a crowdsale.
947 	* @author Joel Hubert (Metalith.io)
948 	* @dev OpenZeppelin contracts are not ready for 0.6.0 yet, using 0.5.16.
949 	* @dev Acts as a wallet containing subscriber Ether.
950 	*/
951 
952 contract ShardOffering {
953 
954 	using SafeMath for uint256;
955 
956 	ShardGovernor private _shardGovernor;
957 	uint private _offeringDeadline;
958 	uint private _pricePerShardInWei;
959 	uint private _contributionTargetInWei;
960 	uint private _liqProviderCutInShards;
961 	uint private _artistCutInShards;
962 	uint private _offererShardAmount;
963 
964 	address[] private _contributors;
965 	mapping(address => uint) private _contributionsinWei;
966 	mapping(address => uint) private _contributionsInShards;
967 	mapping(address => bool) private _hasClaimedShards;
968 	uint private _totalWeiContributed;
969 	uint private _totalShardsClaimed;
970 	bool private _offeringCompleted;
971 
972 	event Contribution(address indexed contributor, uint indexed weiAmount);
973 	event OfferingWrappedUp();
974 
975 	constructor(
976 		uint pricePerShardInWei,
977 		uint shardAmountOffered,
978 		uint liqProviderCutInShards,
979 		uint artistCutInShards,
980 		uint offeringDeadline,
981 		uint cap
982 	) public {
983 		_pricePerShardInWei = pricePerShardInWei;
984 		_liqProviderCutInShards = liqProviderCutInShards;
985 		_artistCutInShards = artistCutInShards;
986 		_offeringDeadline = offeringDeadline;
987 		_shardGovernor = ShardGovernor(msg.sender);
988 		_contributionTargetInWei = (pricePerShardInWei.mul(shardAmountOffered)).div(10**18);
989 		_offererShardAmount = cap.sub(shardAmountOffered).sub(liqProviderCutInShards).sub(artistCutInShards);
990 	}
991 
992 	/**
993 		* @notice Contribute Ether to offering.
994 		* @dev Blocks Offerer from contributing. May be exaggerated.
995 		* @dev if target Ether amount is raised, automatically transfers Ether to Offerer.
996 		*/
997 	function contribute() external payable {
998 		require(
999 			!_offeringCompleted,
1000 			"[contribute] Offering is complete"
1001 		);
1002 		require(
1003 			msg.value > 0,
1004 			"[contribute] Contribution requires ether"
1005 		);
1006 		require(
1007 			msg.value <= _contributionTargetInWei - _totalWeiContributed,
1008 			"[contribute] Ether value exceeds remaining quota"
1009 		);
1010 		require(
1011 			msg.sender != _shardGovernor.offererAddress(),
1012 			"[contribute] Offerer cannot contribute"
1013 		);
1014 		require(
1015 			now < _offeringDeadline,
1016 			"[contribute] Deadline for offering expired"
1017 		);
1018 		require(
1019 			_shardGovernor.checkLock(),
1020 			"[contribute] NFT not locked yet"
1021 		);
1022 		if (_contributionsinWei[msg.sender] == 0) {
1023 			_contributors.push(msg.sender);
1024 		}
1025 		_contributionsinWei[msg.sender] = _contributionsinWei[msg.sender].add(msg.value);
1026 		uint shardAmount = (msg.value.mul(10**18)).div(_pricePerShardInWei);
1027 		_contributionsInShards[msg.sender] = _contributionsInShards[msg.sender].add(shardAmount);
1028 		_totalWeiContributed = _totalWeiContributed.add(msg.value);
1029 		_totalShardsClaimed = _totalShardsClaimed.add(shardAmount);
1030 		if (_totalWeiContributed == _contributionTargetInWei) {
1031 			_offeringCompleted = true;
1032 			(bool success, ) = _shardGovernor.offererAddress().call.value(address(this).balance)("");
1033 			require(success, "[contribute] Transfer failed.");
1034 		}
1035 		emit Contribution(msg.sender, msg.value);
1036 	}
1037 
1038 	/**
1039 		* @notice Prematurely end Offering.
1040 		* @dev Called by Governor contract when Offering deadline expires and has not
1041 		* raised the target amount of Ether.
1042 		* @dev reentrancy is guarded in _shardGovernor.checkOfferingAndIssue() by
1043 		`hasClaimedShards`.
1044 		*/
1045 	function wrapUpOffering() external {
1046 		require(
1047 			msg.sender == address(_shardGovernor),
1048 			"[wrapUpOffering] Unauthorized caller"
1049 		);
1050 		_offeringCompleted = true;
1051 		(bool success, ) = _shardGovernor.offererAddress().call.value(address(this).balance)("");
1052 		require(success, "[wrapUpOffering] Transfer failed.");
1053 		emit OfferingWrappedUp();
1054 	}
1055 
1056 	/**
1057 		* @notice Records Shard claim for subcriber.
1058 		* @dev Can only be called by Governor contract on Offering close.
1059 		* @param claimant wallet address of the person claiming the Shards they
1060 		subscribed to.
1061 		*/
1062 	function claimShards(address claimant) external {
1063 		require(
1064 			msg.sender == address(_shardGovernor),
1065 			"[claimShards] Unauthorized caller"
1066 		);
1067 		_hasClaimedShards[claimant] = true;
1068 	}
1069 
1070 	function offeringDeadline() external view returns (uint) {
1071 		return _offeringDeadline;
1072 	}
1073 
1074 	function getSubEther(address sub) external view returns (uint) {
1075 		return _contributionsinWei[sub];
1076 	}
1077 
1078 	function getSubShards(address sub) external view returns (uint) {
1079 		return _contributionsInShards[sub];
1080 	}
1081 
1082 	function hasClaimedShards(address claimant) external view returns (bool) {
1083 		return _hasClaimedShards[claimant];
1084 	}
1085 
1086 	function pricePerShardInWei() external view returns (uint) {
1087 		return _pricePerShardInWei;
1088 	}
1089 
1090 	function offererShardAmount() external view returns (uint) {
1091 		return _offererShardAmount;
1092 	}
1093 
1094 	function liqProviderCutInShards() external view returns (uint) {
1095 		return _liqProviderCutInShards;
1096 	}
1097 
1098 	function artistCutInShards() external view returns (uint) {
1099 		return _artistCutInShards;
1100 	}
1101 
1102 	function offeringCompleted() external view returns (bool) {
1103 		return _offeringCompleted;
1104 	}
1105 
1106 	function totalShardsClaimed() external view returns (uint) {
1107 		return _totalShardsClaimed;
1108 	}
1109 
1110 	function totalWeiContributed() external view returns (uint) {
1111 		return _totalWeiContributed;
1112 	}
1113 
1114 	function contributionTargetInWei() external view returns (uint) {
1115 		return _contributionTargetInWei;
1116 	}
1117 
1118 	function getContractBalance() external view returns (uint) {
1119 		return address(this).balance;
1120 	}
1121 
1122 	function contributors() external view returns (address[] memory) {
1123 		return _contributors;
1124 	}
1125 }
1126 /* solhint-disable no-mix-tabs-and-spaces */
1127 /* solhint-disable indent */
1128 
1129 
1130 
1131 /**
1132 	* @title Contract managing Shotgun Clause lifecycle
1133 	* @author Joel Hubert (Metalith.io)
1134 	* @dev OpenZeppelin contracts are not ready for 0.6.0 yet, using 0.5.16.
1135 	* @dev This contract is deployed once a Shotgun is initiated by calling the Registry.
1136 	*/
1137 
1138 contract ShotgunClause {
1139 
1140 	using SafeMath for uint256;
1141 
1142 	ShardGovernor private _shardGovernor;
1143 	ShardRegistry private _shardRegistry;
1144 
1145 	enum ClaimWinner { None, Claimant, Counterclaimant }
1146 	ClaimWinner private _claimWinner = ClaimWinner.None;
1147 
1148 	uint private _deadlineTimestamp;
1149 	uint private _initialOfferInWei;
1150 	uint private _pricePerShardInWei;
1151 	address payable private _initialClaimantAddress;
1152 	uint private _initialClaimantBalance;
1153 	bool private _shotgunEnacted = false;
1154 	uint private _counterWeiContributed;
1155 	address[] private _counterclaimants;
1156 	mapping(address => uint) private _counterclaimContribs;
1157 
1158 	event Countercommit(address indexed committer, uint indexed weiAmount);
1159 	event EtherCollected(address indexed collector, uint indexed weiAmount);
1160 
1161 	constructor(
1162 		address payable initialClaimantAddress,
1163 		uint initialClaimantBalance,
1164 		address shardRegistryAddress
1165 	) public payable {
1166 		_shardGovernor = ShardGovernor(msg.sender);
1167 		_shardRegistry = ShardRegistry(shardRegistryAddress);
1168 		_deadlineTimestamp = now.add(1 * 14 days);
1169 		_initialClaimantAddress = initialClaimantAddress;
1170 		_initialClaimantBalance = initialClaimantBalance;
1171 		_initialOfferInWei = msg.value;
1172 		_pricePerShardInWei = (_initialOfferInWei.mul(10**18)).div(_shardRegistry.cap().sub(_initialClaimantBalance));
1173 		_claimWinner = ClaimWinner.Claimant;
1174 	}
1175 
1176 	/**
1177 		* @notice Contribute Ether to the counterclaim for this Shotgun.
1178 		* @dev Automatically enacts Shotgun once enough Ether is raised and
1179 		returns initial claimant's Ether offer.
1180 		*/
1181 	function counterCommitEther() external payable {
1182 		require(
1183 			_shardRegistry.balanceOf(msg.sender) > 0,
1184 			"[counterCommitEther] Account does not own Shards"
1185 		);
1186 		require(
1187 			msg.value > 0,
1188 			"[counterCommitEther] Ether is required"
1189 		);
1190 		require(
1191 			_initialClaimantAddress != address(0),
1192 			"[counterCommitEther] Initial claimant does not exist"
1193 		);
1194 		require(
1195 			msg.sender != _initialClaimantAddress,
1196 			"[counterCommitEther] Initial claimant cannot countercommit"
1197 		);
1198 		require(
1199 			!_shotgunEnacted,
1200 			"[counterCommitEther] Shotgun already enacted"
1201 		);
1202 		require(
1203 			now < _deadlineTimestamp,
1204 			"[counterCommitEther] Deadline has expired"
1205 		);
1206 		require(
1207 			msg.value + _counterWeiContributed <= getRequiredWeiForCounterclaim(),
1208 			"[counterCommitEther] Ether exceeds goal"
1209 		);
1210 		if (_counterclaimContribs[msg.sender] == 0) {
1211 			_counterclaimants.push(msg.sender);
1212 		}
1213 		_counterclaimContribs[msg.sender] = _counterclaimContribs[msg.sender].add(msg.value);
1214 		_counterWeiContributed = _counterWeiContributed.add(msg.value);
1215 		emit Countercommit(msg.sender, msg.value);
1216 		if (_counterWeiContributed == getRequiredWeiForCounterclaim()) {
1217 			_claimWinner = ClaimWinner.Counterclaimant;
1218 			enactShotgun();
1219 		}
1220 	}
1221 
1222 	/**
1223 		* @notice Collect ether from completed Shotgun.
1224 		* @dev Called by Shard Registry after burning caller's Shards.
1225 		* @dev For counterclaimants, returns both the proportional worth of their
1226 		Shards in Ether AND any counterclaim contributions they have made.
1227 		* @dev alternative: OpenZeppelin PaymentSplitter
1228 		*/
1229 	function collectEtherProceeds(uint balance, address payable caller) external {
1230 		require(
1231 			msg.sender == address(_shardRegistry),
1232 			"[collectEtherProceeds] Caller not authorized"
1233 		);
1234 		if (_claimWinner == ClaimWinner.Claimant && caller != _initialClaimantAddress) {
1235 			uint weiProceeds = (_pricePerShardInWei.mul(balance)).div(10**18);
1236 			weiProceeds = weiProceeds.add(_counterclaimContribs[caller]);
1237 			_counterclaimContribs[caller] = 0;
1238 			(bool success, ) = address(caller).call.value(weiProceeds)("");
1239 			require(success, "[collectEtherProceeds] Transfer failed.");
1240 			emit EtherCollected(caller, weiProceeds);
1241 		} else if (_claimWinner == ClaimWinner.Counterclaimant && caller == _initialClaimantAddress) {
1242 			uint amount = (_pricePerShardInWei.mul(_initialClaimantBalance)).div(10**18);
1243 			amount = amount.add(_initialOfferInWei);
1244 			_initialClaimantBalance = 0;
1245 			(bool success, ) = address(caller).call.value(amount)("");
1246 			require(success, "[collectEtherProceeds] Transfer failed.");
1247 			emit EtherCollected(caller, amount);
1248 		}
1249 	}
1250 
1251 	/**
1252 		* @notice Use by successful counterclaimants to collect Shards from initial claimant.
1253 		*/
1254 	function collectShardProceeds() external {
1255 		require(
1256 			_shotgunEnacted && _claimWinner == ClaimWinner.Counterclaimant,
1257 			"[collectShardProceeds] Shotgun has not been enacted or invalid winner"
1258 		);
1259 		require(
1260 			_counterclaimContribs[msg.sender] != 0,
1261 			"[collectShardProceeds] Account has not participated in counterclaim"
1262 		);
1263 		uint proportionContributed = (_counterclaimContribs[msg.sender].mul(10**18)).div(_counterWeiContributed);
1264 		_counterclaimContribs[msg.sender] = 0;
1265 		uint shardsToReceive = (proportionContributed.mul(_initialClaimantBalance)).div(10**18);
1266 		_shardGovernor.transferShards(msg.sender, shardsToReceive);
1267 	}
1268 
1269 	function deadlineTimestamp() external view returns (uint256) {
1270 		return _deadlineTimestamp;
1271 	}
1272 
1273 	function shotgunEnacted() external view returns (bool) {
1274 		return _shotgunEnacted;
1275 	}
1276 
1277 	function initialClaimantAddress() external view returns (address) {
1278 		return _initialClaimantAddress;
1279 	}
1280 
1281 	function initialClaimantBalance() external view returns (uint) {
1282 		return _initialClaimantBalance;
1283 	}
1284 
1285 	function initialOfferInWei() external view returns (uint256) {
1286 		return _initialOfferInWei;
1287 	}
1288 
1289 	function pricePerShardInWei() external view returns (uint256) {
1290 		return _pricePerShardInWei;
1291 	}
1292 
1293 	function claimWinner() external view returns (ClaimWinner) {
1294 		return _claimWinner;
1295 	}
1296 
1297 	function counterclaimants() external view returns (address[] memory) {
1298 		return _counterclaimants;
1299 	}
1300 
1301 	function getCounterclaimantContribution(address counterclaimant) external view returns (uint) {
1302 		return _counterclaimContribs[counterclaimant];
1303 	}
1304 
1305 	function counterWeiContributed() external view returns (uint) {
1306 		return _counterWeiContributed;
1307 	}
1308 
1309 	function getContractBalance() external view returns (uint) {
1310 		return address(this).balance;
1311 	}
1312 
1313 	function shardGovernor() external view returns (address) {
1314 		return address(_shardGovernor);
1315 	}
1316 
1317 	function getRequiredWeiForCounterclaim() public view returns (uint) {
1318 		return (_pricePerShardInWei.mul(_initialClaimantBalance)).div(10**18);
1319 	}
1320 
1321 	/**
1322 		* @notice Initiate Shotgun enactment.
1323 		* @dev Automatically called if enough Ether is raised by counterclaimants,
1324 		or manually called if deadline expires without successful counterclaim.
1325 		*/
1326 	function enactShotgun() public {
1327 		require(
1328 			!_shotgunEnacted,
1329 			"[enactShotgun] Shotgun already enacted"
1330 		);
1331 		require(
1332 			_claimWinner == ClaimWinner.Counterclaimant ||
1333 			(_claimWinner == ClaimWinner.Claimant && now > _deadlineTimestamp),
1334 			"[enactShotgun] Conditions not met to enact Shotgun Clause"
1335 		);
1336 		_shotgunEnacted = true;
1337 		_shardGovernor.enactShotgun();
1338 	}
1339 }
1340 /* solhint-disable no-mix-tabs-and-spaces */
1341 /* solhint-disable indent */
1342 
1343 
1344 interface IUniswapExchange {
1345 	function removeLiquidity(
1346 		uint256 uniTokenAmount,
1347 		uint256 minEth,
1348 		uint256 minTokens,
1349 		uint256 deadline
1350 	) external returns(
1351 		uint256, uint256
1352 	);
1353 
1354 	function transferFrom(
1355 		address from,
1356 		address to,
1357 		uint256 value
1358 	) external returns (bool);
1359 }
1360 
1361 /**
1362 	* @title Contract managing Shard lifecycle (NFT custody + Shard issuance and redemption)
1363 	* @author Joel Hubert (Metalith.io)
1364 	* @dev OpenZeppelin contracts are not ready for 0.6.0 yet, using 0.5.15.
1365 	* @dev This contract owns the Registry, Offering and any Shotgun contracts,
1366 	* making it the gateway for core state changes.
1367 	*/
1368 
1369 contract ShardGovernor is IERC721Receiver {
1370 
1371   using SafeMath for uint256;
1372 
1373 	// Equals `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
1374 	bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
1375 
1376 	ShardRegistry private _shardRegistry;
1377 	ShardOffering private _shardOffering;
1378 	ShotgunClause private _currentShotgunClause;
1379 	address payable private _offererAddress;
1380 	address private _nftRegistryAddress;
1381 	address payable private _niftexWalletAddress;
1382 	address payable private _artistWalletAddress;
1383 	uint256 private _tokenId;
1384 
1385 	enum ClaimWinner { None, Claimant, Counterclaimant }
1386 	address[] private _shotgunAddressArray;
1387 	mapping(address => uint) private _shotgunMapping;
1388 	uint private _shotgunCounter;
1389 
1390 	event NewShotgun(address indexed shotgun);
1391 	event ShardsClaimed(address indexed claimant, uint indexed shardAmount);
1392 	event NftRedeemed(address indexed redeemer);
1393 	event ShotgunEnacted(address indexed enactor);
1394 	event ShardsCollected(address indexed collector, uint indexed shardAmount, address indexed shotgun);
1395 
1396 	/**
1397 		* @dev Checks whether offerer indeed owns the relevant NFT.
1398 		* @dev Offering deadline starts ticking on deployment, but offerer needs to transfer
1399 		* NFT to this contract before anyone can contribute.
1400 		*/
1401   constructor(
1402 		address nftRegistryAddress,
1403 		address payable offererAddress,
1404 		uint256 tokenId,
1405 		address payable niftexWalletAddress,
1406 		address payable artistWalletAddress,
1407 		uint liqProviderCutInShards,
1408 		uint artistCutInShards,
1409 		uint pricePerShardInWei,
1410 		uint shardAmountOffered,
1411 		uint offeringDeadline,
1412 		uint256 cap,
1413 		string memory name,
1414 		string memory symbol
1415 	) public {
1416 		require(
1417 			IERC721(nftRegistryAddress).ownerOf(tokenId) == offererAddress,
1418 			"Offerer is not owner of tokenId"
1419 		);
1420 		_nftRegistryAddress = nftRegistryAddress;
1421 		_niftexWalletAddress = niftexWalletAddress;
1422 		_artistWalletAddress = artistWalletAddress;
1423 		_tokenId = tokenId;
1424 		_offererAddress = offererAddress;
1425 		_shardRegistry = new ShardRegistry(cap, name, symbol);
1426 		_shardOffering = new ShardOffering(
1427 			pricePerShardInWei,
1428 			shardAmountOffered,
1429 			liqProviderCutInShards,
1430 			artistCutInShards,
1431 			offeringDeadline,
1432 			cap
1433 		);
1434   }
1435 
1436 	/**
1437 		* @dev Used to receive ether from the pullLiquidity function.
1438 		*/
1439 	function() external payable { }
1440 
1441 	/**
1442 		* @notice Issues Shards upon completion of Offering.
1443 		* @dev Cap should equal totalSupply when all Shards have been claimed.
1444 		* @dev The Offerer may close an undersubscribed Offering once the deadline has
1445 		* passed and claim the remaining Shards.
1446 		*/
1447 	function checkOfferingAndIssue() external {
1448 		require(
1449 			_shardRegistry.totalSupply() != _shardRegistry.cap(),
1450 			"[checkOfferingAndIssue] Shards have already been issued"
1451 		);
1452 		require(
1453 			!_shardOffering.hasClaimedShards(msg.sender),
1454 			"[checkOfferingAndIssue] You have already claimed your Shards"
1455 		);
1456 		require(
1457 			_shardOffering.offeringCompleted() ||
1458 			(now > _shardOffering.offeringDeadline() && !_shardOffering.offeringCompleted()),
1459 			"Offering not completed or deadline not expired"
1460 		);
1461 		if (_shardOffering.offeringCompleted()) {
1462 			if (_shardOffering.getSubEther(msg.sender) != 0) {
1463 				_shardOffering.claimShards(msg.sender);
1464 				uint subShards = _shardOffering.getSubShards(msg.sender);
1465 				bool success = _shardRegistry.mint(msg.sender, subShards);
1466 				require(success, "[checkOfferingAndIssue] Mint failed");
1467 				emit ShardsClaimed(msg.sender, subShards);
1468 			} else if (msg.sender == _offererAddress) {
1469 				_shardOffering.claimShards(msg.sender);
1470 				uint offShards = _shardOffering.offererShardAmount();
1471 				bool success = _shardRegistry.mint(msg.sender, offShards);
1472 				require(success, "[checkOfferingAndIssue] Mint failed");
1473 				emit ShardsClaimed(msg.sender, offShards);
1474 			}
1475 		} else {
1476 			_shardOffering.wrapUpOffering();
1477 			uint remainingShards = _shardRegistry.cap().sub(_shardOffering.totalShardsClaimed());
1478 			remainingShards = remainingShards
1479 				.sub(_shardOffering.liqProviderCutInShards())
1480 				.sub(_shardOffering.artistCutInShards());
1481 			bool success = _shardRegistry.mint(_offererAddress, remainingShards);
1482 			require(success, "[checkOfferingAndIssue] Mint failed");
1483 			emit ShardsClaimed(msg.sender, remainingShards);
1484 		}
1485 	}
1486 
1487 	/**
1488 		* @notice Used by NIFTEX to claim predetermined amount of shards in offering in order
1489 		* to bootstrap liquidity on Uniswap-type exchange.
1490 		*/
1491 	/* function claimLiqProviderShards() external {
1492 		require(
1493 			msg.sender == _niftexWalletAddress,
1494 			"[claimLiqProviderShards] Unauthorized caller"
1495 		);
1496 		require(
1497 			!_shardOffering.hasClaimedShards(msg.sender),
1498 			"[claimLiqProviderShards] You have already claimed your Shards"
1499 		);
1500 		require(
1501 			_shardOffering.offeringCompleted(),
1502 			"[claimLiqProviderShards] Offering not completed"
1503 		);
1504 		_shardOffering.claimShards(_niftexWalletAddress);
1505 		uint cut = _shardOffering.liqProviderCutInShards();
1506 		bool success = _shardRegistry.mint(_niftexWalletAddress, cut);
1507 		require(success, "[claimLiqProviderShards] Mint failed");
1508 		emit ShardsClaimed(msg.sender, cut);
1509 	} */
1510 
1511 	function mintReservedShards(address _beneficiary) external {
1512 		bool niftex;
1513 		if (_beneficiary == _niftexWalletAddress) niftex = true;
1514 		require(
1515 			niftex ||
1516 			_beneficiary == _artistWalletAddress,
1517 			"[mintReservedShards] Unauthorized beneficiary"
1518 		);
1519 		require(
1520 			!_shardOffering.hasClaimedShards(_beneficiary),
1521 			"[mintReservedShards] Shards already claimed"
1522 		);
1523 		_shardOffering.claimShards(_beneficiary);
1524 		uint cut;
1525 		if (niftex) {
1526 			cut = _shardOffering.liqProviderCutInShards();
1527 		} else {
1528 			cut = _shardOffering.artistCutInShards();
1529 		}
1530 		bool success = _shardRegistry.mint(_beneficiary, cut);
1531 		require(success, "[mintReservedShards] Mint failed");
1532 		emit ShardsClaimed(_beneficiary, cut);
1533 	}
1534 
1535 	/**
1536 		* @notice In the unlikely case that one account accumulates all Shards,
1537 		* they can be redeemed directly for the underlying NFT.
1538 		*/
1539 	function redeem() external {
1540 		require(
1541 			_shardRegistry.balanceOf(msg.sender) == _shardRegistry.cap(),
1542 			"[redeem] Account does not own total amount of Shards outstanding"
1543 		);
1544 		IERC721(_nftRegistryAddress).safeTransferFrom(address(this), msg.sender, _tokenId);
1545 		emit NftRedeemed(msg.sender);
1546 	}
1547 
1548 	/**
1549 		* @notice Creates a new Shotgun claim.
1550 		* @dev This Function is called from the Shard Registry because the claimant's
1551 		* Shards must be frozen until the Shotgun is resolved: if they lose the claim,
1552 		* their Shards are automatically distributed to the counterclaimants.
1553 		* @dev The Registry is paused while an active Shotgun claim exists to
1554 		* let the process work in an orderly manner.
1555 		* @param initialClaimantAddress wallet address of the person who initiated Shotgun.
1556 		* @param initialClaimantBalance Shard balance of the person who initiated Shotgun.
1557 		*/
1558 	function claimInitialShotgun(
1559 		address payable initialClaimantAddress,
1560 		uint initialClaimantBalance
1561 	) external payable returns (bool) {
1562 		require(
1563 			msg.sender == address(_shardRegistry),
1564 			"[claimInitialShotgun] Caller not authorized"
1565 		);
1566 		_currentShotgunClause = (new ShotgunClause).value(msg.value)(
1567 			initialClaimantAddress,
1568 			initialClaimantBalance,
1569 			address(_shardRegistry)
1570 		);
1571 		emit NewShotgun(address(_currentShotgunClause));
1572 		_shardRegistry.pause();
1573 		_shotgunAddressArray.push(address(_currentShotgunClause));
1574 		_shotgunCounter++;
1575 		_shotgunMapping[address(_currentShotgunClause)] = _shotgunCounter;
1576 		return true;
1577 	}
1578 
1579 	/**
1580 		* @notice Effects the results of a (un)successful Shotgun claim.
1581 		* @dev This Function can only be called by a Shotgun contract in two scenarios:
1582 		* - Counterclaimants raise enough ether to buy claimant out
1583 		* - Shotgun deadline passes without successful counter-raise, claimant wins
1584 		*/
1585 	function enactShotgun() external {
1586 		require(
1587 			_shotgunMapping[msg.sender] != 0,
1588 			"[enactShotgun] Invalid Shotgun Clause"
1589 		);
1590 		ShotgunClause _shotgunClause = ShotgunClause(msg.sender);
1591 		address initialClaimantAddress = _shotgunClause.initialClaimantAddress();
1592 		if (uint(_shotgunClause.claimWinner()) == uint(ClaimWinner.Claimant)) {
1593 			_shardRegistry.burn(_shardRegistry.balanceOf(initialClaimantAddress));
1594 			IERC721(_nftRegistryAddress).safeTransferFrom(address(this), initialClaimantAddress, _tokenId);
1595 			_shardRegistry.unpause();
1596 			emit ShotgunEnacted(address(_shotgunClause));
1597 		} else if (uint(_shotgunClause.claimWinner()) == uint(ClaimWinner.Counterclaimant)) {
1598 			_shardRegistry.unpause();
1599 			emit ShotgunEnacted(address(_shotgunClause));
1600 		}
1601 	}
1602 
1603 	/**
1604 		* @notice Transfer Shards to counterclaimants after unsuccessful Shotgun claim.
1605 		* @dev This contract custodies the claimant's Shards when they claim Shotgun -
1606 		* if they lose the claim these Shards must be transferred to counterclaimants.
1607 		* This process is initiated by the relevant Shotgun contract.
1608 		* @param recipient wallet address of the person receiving the Shards.
1609 		* @param amount the amount of Shards to receive.
1610 		*/
1611 	function transferShards(address recipient, uint amount) external {
1612 		require(
1613 			_shotgunMapping[msg.sender] != 0,
1614 			"[transferShards] Unauthorized caller"
1615 		);
1616 		bool success = _shardRegistry.transfer(recipient, amount);
1617 		require(success, "[transferShards] Transfer failed");
1618 		emit ShardsCollected(recipient, amount, msg.sender);
1619 	}
1620 
1621 	/**
1622 		* @notice Allows liquidity providers to pull funds during shotgun.
1623 		* @dev Requires Unitokens to be sent to the contract so the contract can
1624 		* remove liquidity.
1625 		* @param exchangeAddress address of the Uniswap pool.
1626 		* @param liqProvAddress address of the liquidity provider.
1627 		* @param uniTokenAmount liquidity tokens to redeem.
1628 		* @param minEth minimum ether to withdraw.
1629 		* @param minTokens minimum tokens to withdraw.
1630 		* @param deadline deadline for the withdrawal.
1631 		*/
1632 	function pullLiquidity(
1633 		address exchangeAddress,
1634 		address liqProvAddress,
1635 		uint256 uniTokenAmount,
1636 		uint256 minEth,
1637 		uint256 minTokens,
1638 		uint256 deadline
1639 	) public {
1640 		require(msg.sender == _niftexWalletAddress, "[pullLiquidity] Unauthorized call");
1641 		IUniswapExchange uniExchange = IUniswapExchange(exchangeAddress);
1642 		uniExchange.transferFrom(liqProvAddress, address(this), uniTokenAmount);
1643 		_shardRegistry.unpause();
1644 		(uint ethAmount, uint tokenAmount) = uniExchange.removeLiquidity(uniTokenAmount, minEth, minTokens, deadline);
1645 		(bool ethSuccess, ) = liqProvAddress.call.value(ethAmount)("");
1646 		require(ethSuccess, "[pullLiquidity] ETH transfer failed.");
1647 		bool tokenSuccess = _shardRegistry.transfer(liqProvAddress, tokenAmount);
1648 		require(tokenSuccess, "[pullLiquidity] Token transfer failed");
1649 		_shardRegistry.pause();
1650 	}
1651 
1652 	/**
1653 		* @dev Utility function to check if a Shotgun is in progress.
1654 		*/
1655 	function checkShotgunState() external view returns (bool) {
1656 		if (_shotgunCounter == 0) {
1657 			return true;
1658 		} else {
1659 			ShotgunClause _shotgunClause = ShotgunClause(_shotgunAddressArray[_shotgunCounter - 1]);
1660 			if (_shotgunClause.shotgunEnacted()) {
1661 				return true;
1662 			} else {
1663 				return false;
1664 			}
1665 		}
1666 	}
1667 
1668 	function currentShotgunClause() external view returns (address) {
1669 		return address(_currentShotgunClause);
1670 	}
1671 
1672 	function shardRegistryAddress() external view returns (address) {
1673 		return address(_shardRegistry);
1674 	}
1675 
1676 	function shardOfferingAddress() external view returns (address) {
1677 		return address(_shardOffering);
1678 	}
1679 
1680 	function getContractBalance() external view returns (uint) {
1681 		return address(this).balance;
1682 	}
1683 
1684 	function offererAddress() external view returns (address payable) {
1685 		return _offererAddress;
1686 	}
1687 
1688 	function shotgunCounter() external view returns (uint) {
1689 		return _shotgunCounter;
1690 	}
1691 
1692 	function shotgunAddressArray() external view returns (address[] memory) {
1693 		return _shotgunAddressArray;
1694 	}
1695 
1696 	/**
1697 		* @dev Utility function to check whether this contract owns the Sharded NFT.
1698 		*/
1699 	function checkLock() external view returns (bool) {
1700 		address owner = IERC721(_nftRegistryAddress).ownerOf(_tokenId);
1701 		return owner == address(this);
1702 	}
1703 
1704 	/**
1705 		* @notice Handle the receipt of an NFT.
1706 		* @dev The ERC721 smart contract calls this function on the recipient
1707 		* after a `safetransfer`. This function MAY throw to revert and reject the
1708 		* transfer. Return of other than the magic value MUST result in the
1709 		* transaction being reverted.
1710 		* Note: the contract address is always the message sender.
1711 		* @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
1712 		*/
1713 	function onERC721Received(address, address, uint256, bytes memory) public returns(bytes4) {
1714 		return _ERC721_RECEIVED;
1715 	}
1716 }
1717 
1718 /**
1719 	* @title ERC20 base for Shards with additional methods related to governance
1720 	* @author Joel Hubert (Metalith.io)
1721 	* @dev OpenZeppelin contracts are not ready for 0.6.0 yet, using 0.5.16.
1722 	*/
1723 
1724 contract ShardRegistry is ERC20Detailed, ERC20Capped, ERC20Burnable, ERC20Pausable {
1725 
1726 	ShardGovernor private _shardGovernor;
1727 	enum ClaimWinner { None, Claimant, Counterclaimant }
1728 
1729 	constructor (
1730 		uint256 cap,
1731 		string memory name,
1732 		string memory symbol
1733 	) ERC20Detailed(name, symbol, 18) ERC20Capped(cap) public {
1734 		_shardGovernor = ShardGovernor(msg.sender);
1735 	}
1736 
1737 	/**
1738 		* @notice Called to initiate Shotgun claim. Requires Ether.
1739 		* @dev Transfers claimant's Shards into Governor contract's custody until
1740 		claim is resolved.
1741 		* @dev Forwards Ether to Shotgun contract through Governor contract.
1742 		*/
1743 	function lockShardsAndClaim() external payable {
1744 		require(
1745 			_shardGovernor.checkLock(),
1746 			"[lockShardsAndClaim] NFT not locked, Shotgun cannot be triggered"
1747 		);
1748 		require(
1749 			_shardGovernor.checkShotgunState(),
1750 			"[lockShardsAndClaim] Shotgun already in progress"
1751 		);
1752 		require(
1753 			msg.value > 0,
1754 			"[lockShardsAndClaim] Transaction must send ether to activate Shotgun Clause"
1755 		);
1756 		uint initialClaimantBalance = balanceOf(msg.sender);
1757 		require(
1758 			initialClaimantBalance > 0,
1759 			"[lockShardsAndClaim] Account does not own Shards"
1760 		);
1761 		require(
1762 			initialClaimantBalance < cap(),
1763 			"[lockShardsAndClaim] Account owns all Shards"
1764 		);
1765 		transfer(address(_shardGovernor), balanceOf(msg.sender));
1766 		(bool success) = _shardGovernor.claimInitialShotgun.value(msg.value)(
1767 			msg.sender, initialClaimantBalance
1768 		);
1769 		require(
1770 			success,
1771 			"[lockShards] Ether forwarding unsuccessful"
1772 		);
1773 	}
1774 
1775 	/**
1776 		* @notice Called to collect Ether from Shotgun proceeds. Burns Shard holdings.
1777 		* @dev can be called in both Shotgun outcome scenarios by:
1778 		- Initial claimant, if they lose the claim to counterclaimants and their
1779 		Shards are bought out
1780 		- Counterclaimants, bought out if initial claimant is successful.
1781 		* @dev initial claimant does not own Shards at this point because they have
1782 		been custodied in Governor contract at start of Shotgun.
1783 		* @param shotgunClause address of the relevant Shotgun contract.
1784 		*/
1785 	function burnAndCollectEther(address shotgunClause) external {
1786 		ShotgunClause _shotgunClause = ShotgunClause(shotgunClause);
1787 		bool enacted = _shotgunClause.shotgunEnacted();
1788 		if (!enacted) {
1789 			_shotgunClause.enactShotgun();
1790 		}
1791 		require(
1792 			enacted || _shotgunClause.shotgunEnacted(),
1793 			"[burnAndCollectEther] Shotgun Clause not enacted"
1794 		);
1795 		uint balance = balanceOf(msg.sender);
1796 		require(
1797 			balance > 0 || msg.sender == _shotgunClause.initialClaimantAddress(),
1798 			"[burnAndCollectEther] Account does not own Shards"
1799 		);
1800 		require(
1801 			uint(_shotgunClause.claimWinner()) == uint(ClaimWinner.Claimant) &&
1802 			msg.sender != _shotgunClause.initialClaimantAddress() ||
1803 			uint(_shotgunClause.claimWinner()) == uint(ClaimWinner.Counterclaimant) &&
1804 			msg.sender == _shotgunClause.initialClaimantAddress(),
1805 			"[burnAndCollectEther] Account does not have right to collect ether"
1806 		);
1807 		burn(balance);
1808 		_shotgunClause.collectEtherProceeds(balance, msg.sender);
1809 	}
1810 }