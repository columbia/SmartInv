1 pragma solidity ^0.5.0;
2 
3 
4 
5 /**
6  * @title Roles
7  * @dev Library for managing addresses assigned to a Role.
8  */
9 library Roles {
10     struct Role {
11         mapping(address => bool) bearer;
12     }
13 
14     /**
15      * @dev Give an account access to this role.
16      */
17     function add(Role storage role, address account) internal {
18         require(!has(role, account), "Roles: account already has role");
19         role.bearer[account] = true;
20     }
21 
22     /**
23      * @dev Remove an account's access to this role.
24      */
25     function remove(Role storage role, address account) internal {
26         require(has(role, account), "Roles: account does not have role");
27         role.bearer[account] = false;
28     }
29 
30     /**
31      * @dev Check if an account has this role.
32      * @return bool
33      */
34     function has(Role storage role, address account) internal view returns (bool) {
35         require(account != address(0), "Roles: account is the zero address");
36         return role.bearer[account];
37     }
38 }
39 
40 
41 contract MinterRole {
42     using Roles for Roles.Role;
43 
44     event MinterAdded(address indexed account);
45     event MinterRemoved(address indexed account);
46 
47     Roles.Role private _minters;
48 
49     constructor () internal {
50         _addMinter(msg.sender);
51     }
52 
53     modifier onlyMinter() {
54         require(isMinter(msg.sender), "MinterRole: caller does not have the Minter role");
55         _;
56     }
57 
58     function isMinter(address account) public view returns (bool) {
59         return _minters.has(account);
60     }
61 
62     function addMinter(address account) public onlyMinter {
63         _addMinter(account);
64     }
65 
66     function renounceMinter() public {
67         _removeMinter(msg.sender);
68     }
69 
70     function _addMinter(address account) internal {
71         _minters.add(account);
72         emit MinterAdded(account);
73     }
74 
75     function _removeMinter(address account) internal {
76         _minters.remove(account);
77         emit MinterRemoved(account);
78     }
79 }
80 
81 
82 contract PauserRole {
83     using Roles for Roles.Role;
84 
85     event PauserAdded(address indexed account);
86     event PauserRemoved(address indexed account);
87 
88     Roles.Role private _pausers;
89 
90     constructor () internal {
91         _addPauser(msg.sender);
92     }
93 
94     modifier onlyPauser() {
95         require(isPauser(msg.sender), "PauserRole: caller does not have the Pauser role");
96         _;
97     }
98 
99     function isPauser(address account) public view returns (bool) {
100         return _pausers.has(account);
101     }
102 
103     function addPauser(address account) public onlyPauser {
104         _addPauser(account);
105     }
106 
107     function renouncePauser() public {
108         _removePauser(msg.sender);
109     }
110 
111     function _addPauser(address account) internal {
112         _pausers.add(account);
113         emit PauserAdded(account);
114     }
115 
116     function _removePauser(address account) internal {
117         _pausers.remove(account);
118         emit PauserRemoved(account);
119     }
120 }
121 
122 
123 
124 
125 
126 
127 
128 
129 /**
130  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
131  * the optional functions; to access them see `ERC20Detailed`.
132  */
133 interface IERC20 {
134     /**
135      * @dev Returns the amount of tokens in existence.
136      */
137     function totalSupply() external view returns (uint256);
138 
139     /**
140      * @dev Returns the amount of tokens owned by `account`.
141      */
142     function balanceOf(address account) external view returns (uint256);
143 
144     /**
145      * @dev Moves `amount` tokens from the caller's account to `recipient`.
146      *
147      * Returns a boolean value indicating whether the operation succeeded.
148      *
149      * Emits a `Transfer` event.
150      */
151     function transfer(address recipient, uint256 amount) external returns (bool);
152 
153     /**
154      * @dev Returns the remaining number of tokens that `spender` will be
155      * allowed to spend on behalf of `owner` through `transferFrom`. This is
156      * zero by default.
157      *
158      * This value changes when `approve` or `transferFrom` are called.
159      */
160     function allowance(address owner, address spender) external view returns (uint256);
161 
162     /**
163      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
164      *
165      * Returns a boolean value indicating whether the operation succeeded.
166      *
167      * > Beware that changing an allowance with this method brings the risk
168      * that someone may use both the old and the new allowance by unfortunate
169      * transaction ordering. One possible solution to mitigate this race
170      * condition is to first reduce the spender's allowance to 0 and set the
171      * desired value afterwards:
172      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
173      *
174      * Emits an `Approval` event.
175      */
176     function approve(address spender, uint256 amount) external returns (bool);
177 
178     /**
179      * @dev Moves `amount` tokens from `sender` to `recipient` using the
180      * allowance mechanism. `amount` is then deducted from the caller's
181      * allowance.
182      *
183      * Returns a boolean value indicating whether the operation succeeded.
184      *
185      * Emits a `Transfer` event.
186      */
187     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
188 
189     /**
190      * @dev Emitted when `value` tokens are moved from one account (`from`) to
191      * another (`to`).
192      *
193      * Note that `value` may be zero.
194      */
195     event Transfer(address indexed from, address indexed to, uint256 value);
196 
197     /**
198      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
199      * a call to `approve`. `value` is the new allowance.
200      */
201     event Approval(address indexed owner, address indexed spender, uint256 value);
202 }
203 
204 
205 
206 /**
207  * @dev Wrappers over Solidity's arithmetic operations with added overflow
208  * checks.
209  *
210  * Arithmetic operations in Solidity wrap on overflow. This can easily result
211  * in bugs, because programmers usually assume that an overflow raises an
212  * error, which is the standard behavior in high level programming languages.
213  * `SafeMath` restores this intuition by reverting the transaction when an
214  * operation overflows.
215  *
216  * Using this library instead of the unchecked operations eliminates an entire
217  * class of bugs, so it's recommended to use it always.
218  */
219 library SafeMath {
220     /**
221      * @dev Returns the addition of two unsigned integers, reverting on
222      * overflow.
223      *
224      * Counterpart to Solidity's `+` operator.
225      *
226      * Requirements:
227      * - Addition cannot overflow.
228      */
229     function add(uint256 a, uint256 b) internal pure returns (uint256) {
230         uint256 c = a + b;
231         require(c >= a, "SafeMath: addition overflow");
232 
233         return c;
234     }
235 
236     /**
237      * @dev Returns the subtraction of two unsigned integers, reverting on
238      * overflow (when the result is negative).
239      *
240      * Counterpart to Solidity's `-` operator.
241      *
242      * Requirements:
243      * - Subtraction cannot overflow.
244      */
245     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
246         require(b <= a, "SafeMath: subtraction overflow");
247         uint256 c = a - b;
248 
249         return c;
250     }
251 
252     /**
253      * @dev Returns the multiplication of two unsigned integers, reverting on
254      * overflow.
255      *
256      * Counterpart to Solidity's `*` operator.
257      *
258      * Requirements:
259      * - Multiplication cannot overflow.
260      */
261     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
262         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
263         // benefit is lost if 'b' is also tested.
264         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
265         if (a == 0) {
266             return 0;
267         }
268 
269         uint256 c = a * b;
270         require(c / a == b, "SafeMath: multiplication overflow");
271 
272         return c;
273     }
274 
275     /**
276      * @dev Returns the integer division of two unsigned integers. Reverts on
277      * division by zero. The result is rounded towards zero.
278      *
279      * Counterpart to Solidity's `/` operator. Note: this function uses a
280      * `revert` opcode (which leaves remaining gas untouched) while Solidity
281      * uses an invalid opcode to revert (consuming all remaining gas).
282      *
283      * Requirements:
284      * - The divisor cannot be zero.
285      */
286     function div(uint256 a, uint256 b) internal pure returns (uint256) {
287         // Solidity only automatically asserts when dividing by 0
288         require(b > 0, "SafeMath: division by zero");
289         uint256 c = a / b;
290         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
291 
292         return c;
293     }
294 
295     /**
296      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
297      * Reverts when dividing by zero.
298      *
299      * Counterpart to Solidity's `%` operator. This function uses a `revert`
300      * opcode (which leaves remaining gas untouched) while Solidity uses an
301      * invalid opcode to revert (consuming all remaining gas).
302      *
303      * Requirements:
304      * - The divisor cannot be zero.
305      */
306     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
307         require(b != 0, "SafeMath: modulo by zero");
308         return a % b;
309     }
310 }
311 
312 
313 /**
314  * @dev Implementation of the `IERC20` interface.
315  *
316  * This implementation is agnostic to the way tokens are created. This means
317  * that a supply mechanism has to be added in a derived contract using `_mint`.
318  * For a generic mechanism see `ERC20Mintable`.
319  *
320  * *For a detailed writeup see our guide [How to implement supply
321  * mechanisms](https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226).*
322  *
323  * We have followed general OpenZeppelin guidelines: functions revert instead
324  * of returning `false` on failure. This behavior is nonetheless conventional
325  * and does not conflict with the expectations of ERC20 applications.
326  *
327  * Additionally, an `Approval` event is emitted on calls to `transferFrom`.
328  * This allows applications to reconstruct the allowance for all accounts just
329  * by listening to said events. Other implementations of the EIP may not emit
330  * these events, as it isn't required by the specification.
331  *
332  * Finally, the non-standard `decreaseAllowance` and `increaseAllowance`
333  * functions have been added to mitigate the well-known issues around setting
334  * allowances. See `IERC20.approve`.
335  */
336 contract ERC20 is IERC20 {
337     using SafeMath for uint256;
338 
339     mapping(address => uint256) private _balances;
340 
341     mapping(address => mapping(address => uint256)) private _allowances;
342 
343     uint256 private _totalSupply;
344 
345     /**
346      * @dev See `IERC20.totalSupply`.
347      */
348     function totalSupply() public view returns (uint256) {
349         return _totalSupply;
350     }
351 
352     /**
353      * @dev See `IERC20.balanceOf`.
354      */
355     function balanceOf(address account) public view returns (uint256) {
356         return _balances[account];
357     }
358 
359     /**
360      * @dev See `IERC20.transfer`.
361      *
362      * Requirements:
363      *
364      * - `recipient` cannot be the zero address.
365      * - the caller must have a balance of at least `amount`.
366      */
367     function transfer(address recipient, uint256 amount) public returns (bool) {
368         _transfer(msg.sender, recipient, amount);
369         return true;
370     }
371 
372     /**
373      * @dev See `IERC20.allowance`.
374      */
375     function allowance(address owner, address spender) public view returns (uint256) {
376         return _allowances[owner][spender];
377     }
378 
379     /**
380      * @dev See `IERC20.approve`.
381      *
382      * Requirements:
383      *
384      * - `spender` cannot be the zero address.
385      */
386     function approve(address spender, uint256 value) public returns (bool) {
387         _approve(msg.sender, spender, value);
388         return true;
389     }
390 
391     /**
392      * @dev See `IERC20.transferFrom`.
393      *
394      * Emits an `Approval` event indicating the updated allowance. This is not
395      * required by the EIP. See the note at the beginning of `ERC20`;
396      *
397      * Requirements:
398      * - `sender` and `recipient` cannot be the zero address.
399      * - `sender` must have a balance of at least `value`.
400      * - the caller must have allowance for `sender`'s tokens of at least
401      * `amount`.
402      */
403     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
404         _transfer(sender, recipient, amount);
405         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
406         return true;
407     }
408 
409     /**
410      * @dev Atomically increases the allowance granted to `spender` by the caller.
411      *
412      * This is an alternative to `approve` that can be used as a mitigation for
413      * problems described in `IERC20.approve`.
414      *
415      * Emits an `Approval` event indicating the updated allowance.
416      *
417      * Requirements:
418      *
419      * - `spender` cannot be the zero address.
420      */
421     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
422         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
423         return true;
424     }
425 
426     /**
427      * @dev Atomically decreases the allowance granted to `spender` by the caller.
428      *
429      * This is an alternative to `approve` that can be used as a mitigation for
430      * problems described in `IERC20.approve`.
431      *
432      * Emits an `Approval` event indicating the updated allowance.
433      *
434      * Requirements:
435      *
436      * - `spender` cannot be the zero address.
437      * - `spender` must have allowance for the caller of at least
438      * `subtractedValue`.
439      */
440     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
441         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
442         return true;
443     }
444 
445     /**
446      * @dev Moves tokens `amount` from `sender` to `recipient`.
447      *
448      * This is internal function is equivalent to `transfer`, and can be used to
449      * e.g. implement automatic token fees, slashing mechanisms, etc.
450      *
451      * Emits a `Transfer` event.
452      *
453      * Requirements:
454      *
455      * - `sender` cannot be the zero address.
456      * - `recipient` cannot be the zero address.
457      * - `sender` must have a balance of at least `amount`.
458      */
459     function _transfer(address sender, address recipient, uint256 amount) internal {
460         require(sender != address(0), "ERC20: transfer from the zero address");
461         require(recipient != address(0), "ERC20: transfer to the zero address");
462 
463         _balances[sender] = _balances[sender].sub(amount);
464         _balances[recipient] = _balances[recipient].add(amount);
465         emit Transfer(sender, recipient, amount);
466     }
467 
468     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
469      * the total supply.
470      *
471      * Emits a `Transfer` event with `from` set to the zero address.
472      *
473      * Requirements
474      *
475      * - `to` cannot be the zero address.
476      */
477     function _mint(address account, uint256 amount) internal {
478         require(account != address(0), "ERC20: mint to the zero address");
479 
480         _totalSupply = _totalSupply.add(amount);
481         _balances[account] = _balances[account].add(amount);
482         emit Transfer(address(0), account, amount);
483     }
484 
485     /**
486     * @dev Destoys `amount` tokens from `account`, reducing the
487     * total supply.
488     *
489     * Emits a `Transfer` event with `to` set to the zero address.
490     *
491     * Requirements
492     *
493     * - `account` cannot be the zero address.
494     * - `account` must have at least `amount` tokens.
495     */
496     function _burn(address account, uint256 value) internal {
497         require(account != address(0), "ERC20: burn from the zero address");
498 
499         _totalSupply = _totalSupply.sub(value);
500         _balances[account] = _balances[account].sub(value);
501         emit Transfer(account, address(0), value);
502     }
503 
504     /**
505      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
506      *
507      * This is internal function is equivalent to `approve`, and can be used to
508      * e.g. set automatic allowances for certain subsystems, etc.
509      *
510      * Emits an `Approval` event.
511      *
512      * Requirements:
513      *
514      * - `owner` cannot be the zero address.
515      * - `spender` cannot be the zero address.
516      */
517     function _approve(address owner, address spender, uint256 value) internal {
518         require(owner != address(0), "ERC20: approve from the zero address");
519         require(spender != address(0), "ERC20: approve to the zero address");
520 
521         _allowances[owner][spender] = value;
522         emit Approval(owner, spender, value);
523     }
524 
525     /**
526      * @dev Destoys `amount` tokens from `account`.`amount` is then deducted
527      * from the caller's allowance.
528      *
529      * See `_burn` and `_approve`.
530      */
531     function _burnFrom(address account, uint256 amount) internal {
532         _burn(account, amount);
533         _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount));
534     }
535 }
536 
537 
538 
539 
540 
541 /**
542  * @dev Contract module which allows children to implement an emergency stop
543  * mechanism that can be triggered by an authorized account.
544  *
545  * This module is used through inheritance. It will make available the
546  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
547  * the functions of your contract. Note that they will not be pausable by
548  * simply including this module, only once the modifiers are put in place.
549  */
550 contract Pausable is PauserRole {
551     /**
552      * @dev Emitted when the pause is triggered by a pauser (`account`).
553      */
554     event Paused(address account);
555 
556     /**
557      * @dev Emitted when the pause is lifted by a pauser (`account`).
558      */
559     event Unpaused(address account);
560 
561     bool private _paused;
562 
563     /**
564      * @dev Initializes the contract in unpaused state. Assigns the Pauser role
565      * to the deployer.
566      */
567     constructor () internal {
568         _paused = false;
569     }
570 
571     /**
572      * @dev Returns true if the contract is paused, and false otherwise.
573      */
574     function paused() public view returns (bool) {
575         return _paused;
576     }
577 
578     /**
579      * @dev Modifier to make a function callable only when the contract is not paused.
580      */
581     modifier whenNotPaused() {
582         require(!_paused, "Pausable: paused");
583         _;
584     }
585 
586     /**
587      * @dev Modifier to make a function callable only when the contract is paused.
588      */
589     modifier whenPaused() {
590         require(_paused, "Pausable: not paused");
591         _;
592     }
593 
594     /**
595      * @dev Called by a pauser to pause, triggers stopped state.
596      */
597     function pause() public onlyPauser whenNotPaused {
598         _paused = true;
599         emit Paused(msg.sender);
600     }
601 
602     /**
603      * @dev Called by a pauser to unpause, returns to normal state.
604      */
605     function unpause() public onlyPauser whenPaused {
606         _paused = false;
607         emit Unpaused(msg.sender);
608     }
609 }
610 
611 
612 /**
613  * @title Pausable token
614  * @dev ERC20 modified with pausable transfers.
615  */
616 contract ERC20Pausable is ERC20, Pausable {
617     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
618         return super.transfer(to, value);
619     }
620 
621     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
622         return super.transferFrom(from, to, value);
623     }
624 
625     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
626         return super.approve(spender, value);
627     }
628 
629     function increaseAllowance(address spender, uint addedValue) public whenNotPaused returns (bool) {
630         return super.increaseAllowance(spender, addedValue);
631     }
632 
633     function decreaseAllowance(address spender, uint subtractedValue) public whenNotPaused returns (bool) {
634         return super.decreaseAllowance(spender, subtractedValue);
635     }
636 }
637 
638 
639 
640 
641 
642 
643 
644 
645 /**
646  * @dev Extension of `ERC20` that adds a set of accounts with the `MinterRole`,
647  * which have permission to mint (create) new tokens as they see fit.
648  *
649  * At construction, the deployer of the contract is the only minter.
650  */
651 contract ERC20Mintable is ERC20, MinterRole {
652     /**
653      * @dev See `ERC20._mint`.
654      *
655      * Requirements:
656      *
657      * - the caller must have the `MinterRole`.
658      */
659     function mint(address account, uint256 amount) public onlyMinter returns (bool) {
660         _mint(account, amount);
661         return true;
662     }
663 }
664 
665 
666 /**
667  * @dev Extension of `ERC20Mintable` that adds a cap to the supply of tokens.
668  */
669 contract ERC20Capped is ERC20Mintable {
670     uint256 private _cap;
671 
672     /**
673      * @dev Sets the value of the `cap`. This value is immutable, it can only be
674      * set once during construction.
675      */
676     constructor (uint256 cap) public {
677         require(cap > 0, "ERC20Capped: cap is 0");
678         _cap = cap;
679     }
680 
681     /**
682      * @dev Returns the cap on the token's total supply.
683      */
684     function cap() public view returns (uint256) {
685         return _cap;
686     }
687 
688     /**
689      * @dev See `ERC20Mintable.mint`.
690      *
691      * Requirements:
692      *
693      * - `value` must not cause the total supply to go over the cap.
694      */
695     function _mint(address account, uint256 value) internal {
696         require(totalSupply().add(value) <= _cap, "ERC20Capped: cap exceeded");
697         super._mint(account, value);
698     }
699 }
700 
701 
702 contract SuperOneToken is ERC20Capped, Pausable {
703     string public name;
704     string public symbol;
705     uint8 public decimals;
706 
707     constructor (string memory _name, string memory _symbol,
708         uint256 _cap, uint8 _decimals) public ERC20Capped(_cap * (10 ** uint256(_decimals))) {
709         name = _name;
710         symbol = _symbol;
711         decimals = _decimals;
712         pause();
713     }
714     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
715         return super.transfer(_to, _value);
716     }
717 
718     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
719         return super.transferFrom(_from, _to, _value);
720     }
721 
722     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
723         return super.approve(_spender, _value);
724     }
725 
726     function increaseAllowance(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
727         return super.increaseAllowance(_spender, _addedValue);
728     }
729 
730     function decreaseAllowance(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
731         return super.decreaseAllowance(_spender, _subtractedValue);
732     }
733 }