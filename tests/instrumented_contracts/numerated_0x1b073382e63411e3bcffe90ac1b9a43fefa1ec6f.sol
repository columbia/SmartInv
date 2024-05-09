1 // File: contracts/openzeppelin-solidity-2.3.0/contracts/token/ERC20/IERC20.sol
2 
3 pragma solidity ^0.5.0;
4 
5 /**
6  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
7  * the optional functions; to access them see `ERC20Detailed`.
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
25      * Emits a `Transfer` event.
26      */
27     function transfer(address recipient, uint256 amount) external returns (bool);
28 
29     /**
30      * @dev Returns the remaining number of tokens that `spender` will be
31      * allowed to spend on behalf of `owner` through `transferFrom`. This is
32      * zero by default.
33      *
34      * This value changes when `approve` or `transferFrom` are called.
35      */
36     function allowance(address owner, address spender) external view returns (uint256);
37 
38     /**
39      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
40      *
41      * Returns a boolean value indicating whether the operation succeeded.
42      *
43      * > Beware that changing an allowance with this method brings the risk
44      * that someone may use both the old and the new allowance by unfortunate
45      * transaction ordering. One possible solution to mitigate this race
46      * condition is to first reduce the spender's allowance to 0 and set the
47      * desired value afterwards:
48      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
49      *
50      * Emits an `Approval` event.
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
61      * Emits a `Transfer` event.
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
75      * a call to `approve`. `value` is the new allowance.
76      */
77     event Approval(address indexed owner, address indexed spender, uint256 value);
78 }
79 
80 // File: contracts/openzeppelin-solidity-2.3.0/contracts/token/ERC20/ERC20Detailed.sol
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
127      * > Note that this information is only used for _display_ purposes: it in
128      * no way affects any of the arithmetic of the contract, including
129      * `IERC20.balanceOf` and `IERC20.transfer`.
130      */
131     function decimals() public view returns (uint8) {
132         return _decimals;
133     }
134 }
135 
136 // File: contracts/openzeppelin-solidity-2.3.0/contracts/math/SafeMath.sol
137 
138 pragma solidity ^0.5.0;
139 
140 /**
141  * @dev Wrappers over Solidity's arithmetic operations with added overflow
142  * checks.
143  *
144  * Arithmetic operations in Solidity wrap on overflow. This can easily result
145  * in bugs, because programmers usually assume that an overflow raises an
146  * error, which is the standard behavior in high level programming languages.
147  * `SafeMath` restores this intuition by reverting the transaction when an
148  * operation overflows.
149  *
150  * Using this library instead of the unchecked operations eliminates an entire
151  * class of bugs, so it's recommended to use it always.
152  */
153 library SafeMath {
154     /**
155      * @dev Returns the addition of two unsigned integers, reverting on
156      * overflow.
157      *
158      * Counterpart to Solidity's `+` operator.
159      *
160      * Requirements:
161      * - Addition cannot overflow.
162      */
163     function add(uint256 a, uint256 b) internal pure returns (uint256) {
164         uint256 c = a + b;
165         require(c >= a, "SafeMath: addition overflow");
166 
167         return c;
168     }
169 
170     /**
171      * @dev Returns the subtraction of two unsigned integers, reverting on
172      * overflow (when the result is negative).
173      *
174      * Counterpart to Solidity's `-` operator.
175      *
176      * Requirements:
177      * - Subtraction cannot overflow.
178      */
179     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
180         require(b <= a, "SafeMath: subtraction overflow");
181         uint256 c = a - b;
182 
183         return c;
184     }
185 
186     /**
187      * @dev Returns the multiplication of two unsigned integers, reverting on
188      * overflow.
189      *
190      * Counterpart to Solidity's `*` operator.
191      *
192      * Requirements:
193      * - Multiplication cannot overflow.
194      */
195     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
196         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
197         // benefit is lost if 'b' is also tested.
198         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
199         if (a == 0) {
200             return 0;
201         }
202 
203         uint256 c = a * b;
204         require(c / a == b, "SafeMath: multiplication overflow");
205 
206         return c;
207     }
208 
209     /**
210      * @dev Returns the integer division of two unsigned integers. Reverts on
211      * division by zero. The result is rounded towards zero.
212      *
213      * Counterpart to Solidity's `/` operator. Note: this function uses a
214      * `revert` opcode (which leaves remaining gas untouched) while Solidity
215      * uses an invalid opcode to revert (consuming all remaining gas).
216      *
217      * Requirements:
218      * - The divisor cannot be zero.
219      */
220     function div(uint256 a, uint256 b) internal pure returns (uint256) {
221         // Solidity only automatically asserts when dividing by 0
222         require(b > 0, "SafeMath: division by zero");
223         uint256 c = a / b;
224         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
225 
226         return c;
227     }
228 
229     /**
230      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
231      * Reverts when dividing by zero.
232      *
233      * Counterpart to Solidity's `%` operator. This function uses a `revert`
234      * opcode (which leaves remaining gas untouched) while Solidity uses an
235      * invalid opcode to revert (consuming all remaining gas).
236      *
237      * Requirements:
238      * - The divisor cannot be zero.
239      */
240     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
241         require(b != 0, "SafeMath: modulo by zero");
242         return a % b;
243     }
244 }
245 
246 // File: contracts/openzeppelin-solidity-2.3.0/contracts/token/ERC20/ERC20.sol
247 
248 pragma solidity ^0.5.0;
249 
250 
251 
252 /**
253  * @dev Implementation of the `IERC20` interface.
254  *
255  * This implementation is agnostic to the way tokens are created. This means
256  * that a supply mechanism has to be added in a derived contract using `_mint`.
257  * For a generic mechanism see `ERC20Mintable`.
258  *
259  * *For a detailed writeup see our guide [How to implement supply
260  * mechanisms](https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226).*
261  *
262  * We have followed general OpenZeppelin guidelines: functions revert instead
263  * of returning `false` on failure. This behavior is nonetheless conventional
264  * and does not conflict with the expectations of ERC20 applications.
265  *
266  * Additionally, an `Approval` event is emitted on calls to `transferFrom`.
267  * This allows applications to reconstruct the allowance for all accounts just
268  * by listening to said events. Other implementations of the EIP may not emit
269  * these events, as it isn't required by the specification.
270  *
271  * Finally, the non-standard `decreaseAllowance` and `increaseAllowance`
272  * functions have been added to mitigate the well-known issues around setting
273  * allowances. See `IERC20.approve`.
274  */
275 contract ERC20 is IERC20 {
276     using SafeMath for uint256;
277 
278     mapping (address => uint256) private _balances;
279 
280     mapping (address => mapping (address => uint256)) private _allowances;
281 
282     uint256 private _totalSupply;
283 
284     /**
285      * @dev See `IERC20.totalSupply`.
286      */
287     function totalSupply() public view returns (uint256) {
288         return _totalSupply;
289     }
290 
291     /**
292      * @dev See `IERC20.balanceOf`.
293      */
294     function balanceOf(address account) public view returns (uint256) {
295         return _balances[account];
296     }
297 
298     /**
299      * @dev See `IERC20.transfer`.
300      *
301      * Requirements:
302      *
303      * - `recipient` cannot be the zero address.
304      * - the caller must have a balance of at least `amount`.
305      */
306     function transfer(address recipient, uint256 amount) public returns (bool) {
307         _transfer(msg.sender, recipient, amount);
308         return true;
309     }
310 
311     /**
312      * @dev See `IERC20.allowance`.
313      */
314     function allowance(address owner, address spender) public view returns (uint256) {
315         return _allowances[owner][spender];
316     }
317 
318     /**
319      * @dev See `IERC20.approve`.
320      *
321      * Requirements:
322      *
323      * - `spender` cannot be the zero address.
324      */
325     function approve(address spender, uint256 value) public returns (bool) {
326         _approve(msg.sender, spender, value);
327         return true;
328     }
329 
330     /**
331      * @dev See `IERC20.transferFrom`.
332      *
333      * Emits an `Approval` event indicating the updated allowance. This is not
334      * required by the EIP. See the note at the beginning of `ERC20`;
335      *
336      * Requirements:
337      * - `sender` and `recipient` cannot be the zero address.
338      * - `sender` must have a balance of at least `value`.
339      * - the caller must have allowance for `sender`'s tokens of at least
340      * `amount`.
341      */
342     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
343         _transfer(sender, recipient, amount);
344         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
345         return true;
346     }
347 
348     /**
349      * @dev Atomically increases the allowance granted to `spender` by the caller.
350      *
351      * This is an alternative to `approve` that can be used as a mitigation for
352      * problems described in `IERC20.approve`.
353      *
354      * Emits an `Approval` event indicating the updated allowance.
355      *
356      * Requirements:
357      *
358      * - `spender` cannot be the zero address.
359      */
360     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
361         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
362         return true;
363     }
364 
365     /**
366      * @dev Atomically decreases the allowance granted to `spender` by the caller.
367      *
368      * This is an alternative to `approve` that can be used as a mitigation for
369      * problems described in `IERC20.approve`.
370      *
371      * Emits an `Approval` event indicating the updated allowance.
372      *
373      * Requirements:
374      *
375      * - `spender` cannot be the zero address.
376      * - `spender` must have allowance for the caller of at least
377      * `subtractedValue`.
378      */
379     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
380         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
381         return true;
382     }
383 
384     /**
385      * @dev Moves tokens `amount` from `sender` to `recipient`.
386      *
387      * This is internal function is equivalent to `transfer`, and can be used to
388      * e.g. implement automatic token fees, slashing mechanisms, etc.
389      *
390      * Emits a `Transfer` event.
391      *
392      * Requirements:
393      *
394      * - `sender` cannot be the zero address.
395      * - `recipient` cannot be the zero address.
396      * - `sender` must have a balance of at least `amount`.
397      */
398     function _transfer(address sender, address recipient, uint256 amount) internal {
399         require(sender != address(0), "ERC20: transfer from the zero address");
400         require(recipient != address(0), "ERC20: transfer to the zero address");
401 
402         _balances[sender] = _balances[sender].sub(amount);
403         _balances[recipient] = _balances[recipient].add(amount);
404         emit Transfer(sender, recipient, amount);
405     }
406 
407     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
408      * the total supply.
409      *
410      * Emits a `Transfer` event with `from` set to the zero address.
411      *
412      * Requirements
413      *
414      * - `to` cannot be the zero address.
415      */
416     function _mint(address account, uint256 amount) internal {
417         require(account != address(0), "ERC20: mint to the zero address");
418 
419         _totalSupply = _totalSupply.add(amount);
420         _balances[account] = _balances[account].add(amount);
421         emit Transfer(address(0), account, amount);
422     }
423 
424      /**
425      * @dev Destoys `amount` tokens from `account`, reducing the
426      * total supply.
427      *
428      * Emits a `Transfer` event with `to` set to the zero address.
429      *
430      * Requirements
431      *
432      * - `account` cannot be the zero address.
433      * - `account` must have at least `amount` tokens.
434      */
435     function _burn(address account, uint256 value) internal {
436         require(account != address(0), "ERC20: burn from the zero address");
437 
438         _totalSupply = _totalSupply.sub(value);
439         _balances[account] = _balances[account].sub(value);
440         emit Transfer(account, address(0), value);
441     }
442 
443     /**
444      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
445      *
446      * This is internal function is equivalent to `approve`, and can be used to
447      * e.g. set automatic allowances for certain subsystems, etc.
448      *
449      * Emits an `Approval` event.
450      *
451      * Requirements:
452      *
453      * - `owner` cannot be the zero address.
454      * - `spender` cannot be the zero address.
455      */
456     function _approve(address owner, address spender, uint256 value) internal {
457         require(owner != address(0), "ERC20: approve from the zero address");
458         require(spender != address(0), "ERC20: approve to the zero address");
459 
460         _allowances[owner][spender] = value;
461         emit Approval(owner, spender, value);
462     }
463 
464     /**
465      * @dev Destoys `amount` tokens from `account`.`amount` is then deducted
466      * from the caller's allowance.
467      *
468      * See `_burn` and `_approve`.
469      */
470     function _burnFrom(address account, uint256 amount) internal {
471         _burn(account, amount);
472         _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount));
473     }
474 }
475 
476 // File: contracts/openzeppelin-solidity-2.3.0/contracts/access/Roles.sol
477 
478 pragma solidity ^0.5.0;
479 
480 /**
481  * @title Roles
482  * @dev Library for managing addresses assigned to a Role.
483  */
484 library Roles {
485     struct Role {
486         mapping (address => bool) bearer;
487     }
488 
489     /**
490      * @dev Give an account access to this role.
491      */
492     function add(Role storage role, address account) internal {
493         require(!has(role, account), "Roles: account already has role");
494         role.bearer[account] = true;
495     }
496 
497     /**
498      * @dev Remove an account's access to this role.
499      */
500     function remove(Role storage role, address account) internal {
501         require(has(role, account), "Roles: account does not have role");
502         role.bearer[account] = false;
503     }
504 
505     /**
506      * @dev Check if an account has this role.
507      * @return bool
508      */
509     function has(Role storage role, address account) internal view returns (bool) {
510         require(account != address(0), "Roles: account is the zero address");
511         return role.bearer[account];
512     }
513 }
514 
515 // File: contracts/openzeppelin-solidity-2.3.0/contracts/access/roles/PauserRole.sol
516 
517 pragma solidity ^0.5.0;
518 
519 
520 contract PauserRole {
521     using Roles for Roles.Role;
522 
523     event PauserAdded(address indexed account);
524     event PauserRemoved(address indexed account);
525 
526     Roles.Role private _pausers;
527 
528     constructor () internal {
529         _addPauser(msg.sender);
530     }
531 
532     modifier onlyPauser() {
533         require(isPauser(msg.sender), "PauserRole: caller does not have the Pauser role");
534         _;
535     }
536 
537     function isPauser(address account) public view returns (bool) {
538         return _pausers.has(account);
539     }
540 
541     function addPauser(address account) public onlyPauser {
542         _addPauser(account);
543     }
544 
545     function renouncePauser() public {
546         _removePauser(msg.sender);
547     }
548 
549     function _addPauser(address account) internal {
550         _pausers.add(account);
551         emit PauserAdded(account);
552     }
553 
554     function _removePauser(address account) internal {
555         _pausers.remove(account);
556         emit PauserRemoved(account);
557     }
558 }
559 
560 // File: contracts/openzeppelin-solidity-2.3.0/contracts/lifecycle/Pausable.sol
561 
562 pragma solidity ^0.5.0;
563 
564 
565 /**
566  * @dev Contract module which allows children to implement an emergency stop
567  * mechanism that can be triggered by an authorized account.
568  *
569  * This module is used through inheritance. It will make available the
570  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
571  * the functions of your contract. Note that they will not be pausable by
572  * simply including this module, only once the modifiers are put in place.
573  */
574 contract Pausable is PauserRole {
575     /**
576      * @dev Emitted when the pause is triggered by a pauser (`account`).
577      */
578     event Paused(address account);
579 
580     /**
581      * @dev Emitted when the pause is lifted by a pauser (`account`).
582      */
583     event Unpaused(address account);
584 
585     bool private _paused;
586 
587     /**
588      * @dev Initializes the contract in unpaused state. Assigns the Pauser role
589      * to the deployer.
590      */
591     constructor () internal {
592         _paused = false;
593     }
594 
595     /**
596      * @dev Returns true if the contract is paused, and false otherwise.
597      */
598     function paused() public view returns (bool) {
599         return _paused;
600     }
601 
602     /**
603      * @dev Modifier to make a function callable only when the contract is not paused.
604      */
605     modifier whenNotPaused() {
606         require(!_paused, "Pausable: paused");
607         _;
608     }
609 
610     /**
611      * @dev Modifier to make a function callable only when the contract is paused.
612      */
613     modifier whenPaused() {
614         require(_paused, "Pausable: not paused");
615         _;
616     }
617 
618     /**
619      * @dev Called by a pauser to pause, triggers stopped state.
620      */
621     function pause() public onlyPauser whenNotPaused {
622         _paused = true;
623         emit Paused(msg.sender);
624     }
625 
626     /**
627      * @dev Called by a pauser to unpause, returns to normal state.
628      */
629     function unpause() public onlyPauser whenPaused {
630         _paused = false;
631         emit Unpaused(msg.sender);
632     }
633 }
634 
635 // File: contracts/openzeppelin-solidity-2.3.0/contracts/token/ERC20/ERC20Pausable.sol
636 
637 pragma solidity ^0.5.0;
638 
639 
640 
641 /**
642  * @title Pausable token
643  * @dev ERC20 modified with pausable transfers.
644  */
645 contract ERC20Pausable is ERC20, Pausable {
646     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
647         return super.transfer(to, value);
648     }
649 
650     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
651         return super.transferFrom(from, to, value);
652     }
653 
654     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
655         return super.approve(spender, value);
656     }
657 
658     function increaseAllowance(address spender, uint addedValue) public whenNotPaused returns (bool) {
659         return super.increaseAllowance(spender, addedValue);
660     }
661 
662     function decreaseAllowance(address spender, uint subtractedValue) public whenNotPaused returns (bool) {
663         return super.decreaseAllowance(spender, subtractedValue);
664     }
665 }
666 
667 // File: contracts/openzeppelin-solidity-2.3.0/contracts/token/ERC20/ERC20Burnable.sol
668 
669 pragma solidity ^0.5.0;
670 
671 
672 /**
673  * @dev Extension of `ERC20` that allows token holders to destroy both their own
674  * tokens and those that they have an allowance for, in a way that can be
675  * recognized off-chain (via event analysis).
676  */
677 contract ERC20Burnable is ERC20 {
678     /**
679      * @dev Destoys `amount` tokens from the caller.
680      *
681      * See `ERC20._burn`.
682      */
683     function burn(uint256 amount) public {
684         _burn(msg.sender, amount);
685     }
686 
687     /**
688      * @dev See `ERC20._burnFrom`.
689      */
690     function burnFrom(address account, uint256 amount) public {
691         _burnFrom(account, amount);
692     }
693 }
694 
695 // File: contracts/ERC20PausableBurnable.sol
696 
697 pragma solidity ^0.5.0;
698 
699 
700 
701 /**
702  * @title Pausable and burnable token
703  * @dev ERC20 modified with pausable transfers and burns.
704  */
705 contract ERC20PausableBurnable is ERC20Burnable, ERC20Pausable {
706     function burn(uint256 amount) public whenNotPaused {
707         super.burn(amount);
708     }
709 
710     function burnFrom(address account, uint256 amount) public whenNotPaused {
711         super.burnFrom(account, amount);
712     }
713 }
714 
715 // File: contracts/Best.sol
716 
717 pragma solidity ^0.5.0;
718 
719 
720 
721 /**
722  * @title Best
723  * @dev Bitpanda Ecosystem Token. All tokens are pre-assigned to the creator.
724  * Note they can later distribute these tokens as they wish using `transfer`
725  * and other `ERC20` functions.
726  */
727 contract Best is ERC20PausableBurnable, ERC20Detailed {
728     uint8 public constant DECIMALS = 8;
729     uint256 public constant INITIAL_SUPPLY = 1000000000 * (10 ** uint256(DECIMALS));
730 
731     /**
732      * @dev Constructor that gives msg.sender all of existing tokens.
733      */
734     constructor () public ERC20Detailed("Bitpanda Ecosystem Token", "BEST", DECIMALS) {
735         _mint(msg.sender, INITIAL_SUPPLY);
736     }
737 }