1 pragma solidity ^0.5.0;
2 
3 /**
4  * @title -Security PO8 Token
5  * PO8 contract records the core attributes of SPO8 Token
6  * 
7  * ██████╗  ██████╗  █████╗     ████████╗ ██████╗ ██╗  ██╗███████╗███╗   ██╗
8  * ██╔══██╗██╔═══██╗██╔══██╗    ╚══██╔══╝██╔═══██╗██║ ██╔╝██╔════╝████╗  ██║
9  * ██████╔╝██║   ██║╚█████╔╝       ██║   ██║   ██║█████╔╝ █████╗  ██╔██╗ ██║
10  * ██╔═══╝ ██║   ██║██╔══██╗       ██║   ██║   ██║██╔═██╗ ██╔══╝  ██║╚██╗██║
11  * ██║     ╚██████╔╝╚█████╔╝       ██║   ╚██████╔╝██║  ██╗███████╗██║ ╚████║
12  * ╚═╝      ╚═════╝  ╚════╝        ╚═╝    ╚═════╝ ╚═╝  ╚═╝╚══════╝╚═╝  ╚═══╝
13  * ---
14  * POWERED BY
15  *  __    ___   _     ___  _____  ___     _     ___
16  * / /`  | |_) \ \_/ | |_)  | |  / / \   | |\ |  ) )
17  * \_\_, |_| \  |_|  |_|    |_|  \_\_/   |_| \| _)_)
18  * Company Info at https://po8.io
19  * code at https://github.com/crypn3
20  */
21 
22 /**
23  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
24  * the optional functions; to access them see `ERC20Detailed`.
25  */
26 interface IERC20 {
27     /**
28      * @dev Returns the amount of tokens in existence.
29      */
30     function totalSupply() external view returns (uint256);
31 
32     /**
33      * @dev Returns the amount of tokens owned by `account`.
34      */
35     function balanceOf(address account) external view returns (uint256);
36 
37     /**
38      * @dev Moves `amount` tokens from the caller's account to `recipient`.
39      *
40      * Returns a boolean value indicating whether the operation succeeded.
41      *
42      * Emits a `Transfer` event.
43      */
44     function transfer(address recipient, uint256 amount) external returns (bool);
45 
46     /**
47      * @dev Returns the remaining number of tokens that `spender` will be
48      * allowed to spend on behalf of `owner` through `transferFrom`. This is
49      * zero by default.
50      *
51      * This value changes when `approve` or `transferFrom` are called.
52      */
53     function allowance(address owner, address spender) external view returns (uint256);
54 
55     /**
56      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
57      *
58      * Returns a boolean value indicating whether the operation succeeded.
59      *
60      * > Beware that changing an allowance with this method brings the risk
61      * that someone may use both the old and the new allowance by unfortunate
62      * transaction ordering. One possible solution to mitigate this race
63      * condition is to first reduce the spender's allowance to 0 and set the
64      * desired value afterwards:
65      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
66      *
67      * Emits an `Approval` event.
68      */
69     function approve(address spender, uint256 amount) external returns (bool);
70 
71     /**
72      * @dev Moves `amount` tokens from `sender` to `recipient` using the
73      * allowance mechanism. `amount` is then deducted from the caller's
74      * allowance.
75      *
76      * Returns a boolean value indicating whether the operation succeeded.
77      *
78      * Emits a `Transfer` event.
79      */
80     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
81 
82     /**
83      * @dev Emitted when `value` tokens are moved from one account (`from`) to
84      * another (`to`).
85      *
86      * Note that `value` may be zero.
87      */
88     event Transfer(address indexed from, address indexed to, uint256 value);
89 
90     /**
91      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
92      * a call to `approve`. `value` is the new allowance.
93      */
94     event Approval(address indexed owner, address indexed spender, uint256 value);
95 }
96 
97 /**
98  * @title Roles
99  * @dev Library for managing addresses assigned to a Role.
100  */
101 library Roles {
102     struct Role {
103         mapping (address => bool) bearer;
104     }
105 
106     /**
107      * @dev Give an account access to this role.
108      */
109     function add(Role storage role, address account) internal {
110         require(!has(role, account), "Roles: account already has role");
111         role.bearer[account] = true;
112     }
113 
114     /**
115      * @dev Remove an account's access to this role.
116      */
117     function remove(Role storage role, address account) internal {
118         require(has(role, account), "Roles: account does not have role");
119         role.bearer[account] = false;
120     }
121 
122     /**
123      * @dev Check if an account has this role.
124      * @return bool
125      */
126     function has(Role storage role, address account) internal view returns (bool) {
127         require(account != address(0), "Roles: account is the zero address");
128         return role.bearer[account];
129     }
130 }
131 
132 contract MinterRole {
133     using Roles for Roles.Role;
134 
135     event MinterAdded(address indexed account);
136     event MinterRemoved(address indexed account);
137 
138     Roles.Role private _minters;
139 
140     constructor () internal {
141         _addMinter(msg.sender);
142     }
143 
144     modifier onlyMinter() {
145         require(isMinter(msg.sender), "MinterRole: caller does not have the Minter role");
146         _;
147     }
148 
149     function isMinter(address account) public view returns (bool) {
150         return _minters.has(account);
151     }
152 
153     function addMinter(address account) public onlyMinter {
154         _addMinter(account);
155     }
156 
157     function renounceMinter() public {
158         _removeMinter(msg.sender);
159     }
160 
161     function _addMinter(address account) internal {
162         _minters.add(account);
163         emit MinterAdded(account);
164     }
165 
166     function _removeMinter(address account) internal {
167         _minters.remove(account);
168         emit MinterRemoved(account);
169     }
170 }
171 
172 contract PauserRole {
173     using Roles for Roles.Role;
174 
175     event PauserAdded(address indexed account);
176     event PauserRemoved(address indexed account);
177 
178     Roles.Role private _pausers;
179 
180     constructor () internal {
181         _addPauser(msg.sender);
182     }
183 
184     modifier onlyPauser() {
185         require(isPauser(msg.sender), "PauserRole: caller does not have the Pauser role");
186         _;
187     }
188 
189     function isPauser(address account) public view returns (bool) {
190         return _pausers.has(account);
191     }
192 
193     function addPauser(address account) public onlyPauser {
194         _addPauser(account);
195     }
196 
197     function renouncePauser() public {
198         _removePauser(msg.sender);
199     }
200 
201     function _addPauser(address account) internal {
202         _pausers.add(account);
203         emit PauserAdded(account);
204     }
205 
206     function _removePauser(address account) internal {
207         _pausers.remove(account);
208         emit PauserRemoved(account);
209     }
210 }
211 
212 /**
213  * @dev Contract module which allows children to implement an emergency stop
214  * mechanism that can be triggered by an authorized account.
215  *
216  * This module is used through inheritance. It will make available the
217  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
218  * the functions of your contract. Note that they will not be pausable by
219  * simply including this module, only once the modifiers are put in place.
220  */
221 contract Pausable is PauserRole {
222     /**
223      * @dev Emitted when the pause is triggered by a pauser (`account`).
224      */
225     event Paused(address account);
226 
227     /**
228      * @dev Emitted when the pause is lifted by a pauser (`account`).
229      */
230     event Unpaused(address account);
231 
232     bool private _paused;
233 
234     /**
235      * @dev Initializes the contract in unpaused state. Assigns the Pauser role
236      * to the deployer.
237      */
238     constructor () internal {
239         _paused = false;
240     }
241 
242     /**
243      * @dev Returns true if the contract is paused, and false otherwise.
244      */
245     function paused() public view returns (bool) {
246         return _paused;
247     }
248 
249     /**
250      * @dev Modifier to make a function callable only when the contract is not paused.
251      */
252     modifier whenNotPaused() {
253         require(!_paused, "Pausable: paused");
254         _;
255     }
256 
257     /**
258      * @dev Modifier to make a function callable only when the contract is paused.
259      */
260     modifier whenPaused() {
261         require(_paused, "Pausable: not paused");
262         _;
263     }
264 
265     /**
266      * @dev Called by a pauser to pause, triggers stopped state.
267      */
268     function pause() public onlyPauser whenNotPaused {
269         _paused = true;
270         emit Paused(msg.sender);
271     }
272 
273     /**
274      * @dev Called by a pauser to unpause, returns to normal state.
275      */
276     function unpause() public onlyPauser whenPaused {
277         _paused = false;
278         emit Unpaused(msg.sender);
279     }
280 }
281 
282 /**
283  * @dev Wrappers over Solidity's arithmetic operations with added overflow
284  * checks.
285  *
286  * Arithmetic operations in Solidity wrap on overflow. This can easily result
287  * in bugs, because programmers usually assume that an overflow raises an
288  * error, which is the standard behavior in high level programming languages.
289  * `SafeMath` restores this intuition by reverting the transaction when an
290  * operation overflows.
291  *
292  * Using this library instead of the unchecked operations eliminates an entire
293  * class of bugs, so it's recommended to use it always.
294  */
295 library SafeMath {
296     /**
297      * @dev Returns the addition of two unsigned integers, reverting on
298      * overflow.
299      *
300      * Counterpart to Solidity's `+` operator.
301      *
302      * Requirements:
303      * - Addition cannot overflow.
304      */
305     function add(uint256 a, uint256 b) internal pure returns (uint256) {
306         uint256 c = a + b;
307         require(c >= a, "SafeMath: addition overflow");
308 
309         return c;
310     }
311 
312     /**
313      * @dev Returns the subtraction of two unsigned integers, reverting on
314      * overflow (when the result is negative).
315      *
316      * Counterpart to Solidity's `-` operator.
317      *
318      * Requirements:
319      * - Subtraction cannot overflow.
320      */
321     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
322         require(b <= a, "SafeMath: subtraction overflow");
323         uint256 c = a - b;
324 
325         return c;
326     }
327 
328     /**
329      * @dev Returns the multiplication of two unsigned integers, reverting on
330      * overflow.
331      *
332      * Counterpart to Solidity's `*` operator.
333      *
334      * Requirements:
335      * - Multiplication cannot overflow.
336      */
337     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
338         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
339         // benefit is lost if 'b' is also tested.
340         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
341         if (a == 0) {
342             return 0;
343         }
344 
345         uint256 c = a * b;
346         require(c / a == b, "SafeMath: multiplication overflow");
347 
348         return c;
349     }
350 
351     /**
352      * @dev Returns the integer division of two unsigned integers. Reverts on
353      * division by zero. The result is rounded towards zero.
354      *
355      * Counterpart to Solidity's `/` operator. Note: this function uses a
356      * `revert` opcode (which leaves remaining gas untouched) while Solidity
357      * uses an invalid opcode to revert (consuming all remaining gas).
358      *
359      * Requirements:
360      * - The divisor cannot be zero.
361      */
362     function div(uint256 a, uint256 b) internal pure returns (uint256) {
363         // Solidity only automatically asserts when dividing by 0
364         require(b > 0, "SafeMath: division by zero");
365         uint256 c = a / b;
366         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
367 
368         return c;
369     }
370 
371     /**
372      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
373      * Reverts when dividing by zero.
374      *
375      * Counterpart to Solidity's `%` operator. This function uses a `revert`
376      * opcode (which leaves remaining gas untouched) while Solidity uses an
377      * invalid opcode to revert (consuming all remaining gas).
378      *
379      * Requirements:
380      * - The divisor cannot be zero.
381      */
382     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
383         require(b != 0, "SafeMath: modulo by zero");
384         return a % b;
385     }
386 }
387 
388 /**
389  * @dev Implementation of the `IERC20` interface.
390  *
391  * This implementation is agnostic to the way tokens are created. This means
392  * that a supply mechanism has to be added in a derived contract using `_mint`.
393  * For a generic mechanism see `ERC20Mintable`.
394  *
395  * *For a detailed writeup see our guide [How to implement supply
396  * mechanisms](https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226).*
397  *
398  * We have followed general OpenZeppelin guidelines: functions revert instead
399  * of returning `false` on failure. This behavior is nonetheless conventional
400  * and does not conflict with the expectations of ERC20 applications.
401  *
402  * Additionally, an `Approval` event is emitted on calls to `transferFrom`.
403  * This allows applications to reconstruct the allowance for all accounts just
404  * by listening to said events. Other implementations of the EIP may not emit
405  * these events, as it isn't required by the specification.
406  *
407  * Finally, the non-standard `decreaseAllowance` and `increaseAllowance`
408  * functions have been added to mitigate the well-known issues around setting
409  * allowances. See `IERC20.approve`.
410  */
411 contract PO8Base is IERC20, MinterRole, Pausable {
412     using SafeMath for uint256;
413 
414     mapping (address => uint256) internal _balances;
415 
416     mapping (address => mapping (address => uint256)) internal _allowances;
417 
418     uint256 internal _totalSupply;
419     
420     string private _name;
421     string private _symbol;
422     uint8 private _decimals;
423 
424     /**
425      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
426      * these values are immutable: they can only be set once during
427      * construction.
428      */
429     constructor (string memory name, string memory symbol, uint8 decimals) public {
430         _name = name;
431         _symbol = symbol;
432         _decimals = decimals;
433     }
434 
435     /**
436      * @dev Returns the name of the token.
437      */
438     function name() public view returns (string memory) {
439         return _name;
440     }
441 
442     /**
443      * @dev Returns the symbol of the token, usually a shorter version of the
444      * name.
445      */
446     function symbol() public view returns (string memory) {
447         return _symbol;
448     }
449 
450     /**
451      * @dev Returns the number of decimals used to get its user representation.
452      * For example, if `decimals` equals `2`, a balance of `505` tokens should
453      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
454      *
455      * Tokens usually opt for a value of 18, imitating the relationship between
456      * Ether and Wei.
457      *
458      * > Note that this information is only used for _display_ purposes: it in
459      * no way affects any of the arithmetic of the contract, including
460      * `IERC20.balanceOf` and `IERC20.transfer`.
461      */
462     function decimals() public view returns (uint8) {
463         return _decimals;
464     }
465 
466     /**
467      * @dev See `IERC20.totalSupply`.
468      */
469     function totalSupply() public view returns (uint256) {
470         return _totalSupply;
471     }
472 
473     /**
474      * @dev See `IERC20.balanceOf`.
475      */
476     function balanceOf(address account) public view returns (uint256) {
477         return _balances[account];
478     }
479 
480     /**
481      * @dev See `IERC20.transfer`.
482      *
483      * Requirements:
484      *
485      * - `recipient` cannot be the zero address.
486      * - the caller must have a balance of at least `amount`.
487      */
488     function transfer(address recipient, uint256 amount) public whenNotPaused returns (bool) {
489         _transfer(msg.sender, recipient, amount);
490         return true;
491     }
492 
493     /**
494      * @dev See `IERC20.allowance`.
495      */
496     function allowance(address owner, address spender) public view returns (uint256) {
497         return _allowances[owner][spender];
498     }
499 
500     /**
501      * @dev See `IERC20.approve`.
502      *
503      * Requirements:
504      *
505      * - `spender` cannot be the zero address.
506      */
507     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
508         _approve(msg.sender, spender, value);
509         return true;
510     }
511 
512     /**
513      * @dev See `IERC20.transferFrom`.
514      *
515      * Emits an `Approval` event indicating the updated allowance. This is not
516      * required by the EIP. See the note at the beginning of `ERC20`;
517      *
518      * Requirements:
519      * - `sender` and `recipient` cannot be the zero address.
520      * - `sender` must have a balance of at least `value`.
521      * - the caller must have allowance for `sender`'s tokens of at least
522      * `amount`.
523      */
524     function transferFrom(address sender, address recipient, uint256 amount) public whenNotPaused returns (bool) {
525         _transfer(sender, recipient, amount);
526         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
527         return true;
528     }
529 
530     /**
531      * @dev Atomically increases the allowance granted to `spender` by the caller.
532      *
533      * This is an alternative to `approve` that can be used as a mitigation for
534      * problems described in `IERC20.approve`.
535      *
536      * Emits an `Approval` event indicating the updated allowance.
537      *
538      * Requirements:
539      *
540      * - `spender` cannot be the zero address.
541      */
542     function increaseAllowance(address spender, uint256 addedValue) public whenNotPaused returns (bool) {
543         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
544         return true;
545     }
546 
547     /**
548      * @dev Atomically decreases the allowance granted to `spender` by the caller.
549      *
550      * This is an alternative to `approve` that can be used as a mitigation for
551      * problems described in `IERC20.approve`.
552      *
553      * Emits an `Approval` event indicating the updated allowance.
554      *
555      * Requirements:
556      *
557      * - `spender` cannot be the zero address.
558      * - `spender` must have allowance for the caller of at least
559      * `subtractedValue`.
560      */
561     function decreaseAllowance(address spender, uint256 subtractedValue) public whenNotPaused returns (bool) {
562         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
563         return true;
564     }
565     
566     /**
567      * @dev Destroys `amount` tokens from the caller.
568      *
569      * See `ERC20._burn`.
570      */
571     function burn(uint256 amount) public {
572         _burn(msg.sender, amount);
573     }
574 
575     /**
576      * @dev See `ERC20._burnFrom`.
577      */
578     function burnFrom(address account, uint256 amount) public {
579         _burnFrom(account, amount);
580     }
581     
582     /**
583      * @dev See `ERC20._mint`.
584      *
585      * Requirements:
586      *
587      * - the caller must have the `MinterRole`.
588      */
589     function mint(address account, uint256 amount) public onlyMinter returns (bool) {
590         _mint(account, amount);
591         return true;
592     }
593 
594     /**
595      * @dev Moves tokens `amount` from `sender` to `recipient`.
596      *
597      * This is internal function is equivalent to `transfer`, and can be used to
598      * e.g. implement automatic token fees, slashing mechanisms, etc.
599      *
600      * Emits a `Transfer` event.
601      *
602      * Requirements:
603      *
604      * - `sender` cannot be the zero address.
605      * - `recipient` cannot be the zero address.
606      * - `sender` must have a balance of at least `amount`.
607      */
608     function _transfer(address sender, address recipient, uint256 amount) internal {
609         require(sender != address(0), "ERC20: transfer from the zero address");
610         require(recipient != address(0), "ERC20: transfer to the zero address");
611 
612         _balances[sender] = _balances[sender].sub(amount);
613         _balances[recipient] = _balances[recipient].add(amount);
614         emit Transfer(sender, recipient, amount);
615     }
616 
617     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
618      * the total supply.
619      *
620      * Emits a `Transfer` event with `from` set to the zero address.
621      *
622      * Requirements
623      *
624      * - `to` cannot be the zero address.
625      */
626     function _mint(address account, uint256 amount) internal {
627         require(account != address(0), "ERC20: mint to the zero address");
628 
629         _totalSupply = _totalSupply.add(amount);
630         _balances[account] = _balances[account].add(amount);
631         emit Transfer(address(0), account, amount);
632     }
633 
634      /**
635      * @dev Destoys `amount` tokens from `account`, reducing the
636      * total supply.
637      *
638      * Emits a `Transfer` event with `to` set to the zero address.
639      *
640      * Requirements
641      *
642      * - `account` cannot be the zero address.
643      * - `account` must have at least `amount` tokens.
644      */
645     function _burn(address account, uint256 value) internal {
646         require(account != address(0), "ERC20: burn from the zero address");
647 
648         _totalSupply = _totalSupply.sub(value);
649         _balances[account] = _balances[account].sub(value);
650         emit Transfer(account, address(0), value);
651     }
652 
653     /**
654      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
655      *
656      * This is internal function is equivalent to `approve`, and can be used to
657      * e.g. set automatic allowances for certain subsystems, etc.
658      *
659      * Emits an `Approval` event.
660      *
661      * Requirements:
662      *
663      * - `owner` cannot be the zero address.
664      * - `spender` cannot be the zero address.
665      */
666     function _approve(address owner, address spender, uint256 value) internal {
667         require(owner != address(0), "ERC20: approve from the zero address");
668         require(spender != address(0), "ERC20: approve to the zero address");
669 
670         _allowances[owner][spender] = value;
671         emit Approval(owner, spender, value);
672     }
673 
674     /**
675      * @dev Destoys `amount` tokens from `account`.`amount` is then deducted
676      * from the caller's allowance.
677      *
678      * See `_burn` and `_approve`.
679      */
680     function _burnFrom(address account, uint256 amount) internal {
681         _burn(account, amount);
682         _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount));
683     }
684 }
685 
686 /**
687  * @title WhitelistAdminRole
688  * @dev WhitelistAdmins are responsible for assigning and removing Whitelisted accounts.
689  */
690 contract WhitelistAdminRole {
691     using Roles for Roles.Role;
692 
693     event WhitelistAdminAdded(address indexed account);
694     event WhitelistAdminRemoved(address indexed account);
695 
696     Roles.Role private _whitelistAdmins;
697 
698     constructor () internal {
699         _addWhitelistAdmin(msg.sender);
700     }
701 
702     modifier onlyWhitelistAdmin() {
703         require(isWhitelistAdmin(msg.sender), "WhitelistAdminRole: caller does not have the WhitelistAdmin role");
704         _;
705     }
706 
707     function isWhitelistAdmin(address account) public view returns (bool) {
708         return _whitelistAdmins.has(account);
709     }
710 
711     function addWhitelistAdmin(address account) public onlyWhitelistAdmin {
712         _addWhitelistAdmin(account);
713     }
714 
715     function renounceWhitelistAdmin() public {
716         _removeWhitelistAdmin(msg.sender);
717     }
718 
719     function _addWhitelistAdmin(address account) internal {
720         _whitelistAdmins.add(account);
721         emit WhitelistAdminAdded(account);
722     }
723 
724     function _removeWhitelistAdmin(address account) internal {
725         _whitelistAdmins.remove(account);
726         emit WhitelistAdminRemoved(account);
727     }
728 }
729 
730 /**
731  * @dev Implementation PO8 token.
732  */
733 contract PO8 is PO8Base, WhitelistAdminRole {
734     mapping(address => uint256) private _totalTokenLocked;
735     
736     event Locked(address user, uint256 amount);
737     event Unlocked(address user);
738     
739     constructor (string memory name, string memory symbol, uint8 decimals, uint256 totalSupply) public PO8Base(name, symbol, decimals) {
740         _totalSupply = totalSupply;
741         _balances[msg.sender] = _totalSupply;
742         emit Transfer(address(0), msg.sender, _totalSupply);
743     }
744     
745     function amountLocked(address user) public view returns (uint256) {
746         return _totalTokenLocked[user]; 
747     }
748     
749     /**
750      * @dev set lock user amount.
751      */
752     function setLockAmount(address user, uint256 amount) public onlyWhitelistAdmin {
753         require(amount >= 0 && amount <= _balances[user]); 
754         _totalTokenLocked[user] = amount;
755         emit Locked(user, amount);
756     }
757    
758     /**
759      * @dev unlock user amount.
760      */
761     function unlockUser(address user) public onlyWhitelistAdmin {
762         _totalTokenLocked[user] = 0;
763         emit Unlocked(user);
764     }
765     
766     /**
767      * @dev override _transfer function with PO8 token rules.
768      */
769     function _transfer(address sender, address recipient, uint256 amount) internal {
770         require(_balances[sender] - amount >= _totalTokenLocked[sender]); //address is unlocked a part.
771         super._transfer(sender, recipient, amount);
772     }
773     
774     /**
775      * @dev contract doesn't accept ether.
776      */
777     function () external payable {
778         revert();
779     }
780 }