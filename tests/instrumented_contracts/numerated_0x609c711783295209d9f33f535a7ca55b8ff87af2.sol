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
31 // File: @openzeppelin/contracts/access/roles/PauserRole.sol
32 
33 pragma solidity ^0.5.0;
34 
35 
36 
37 contract PauserRole is Context {
38     using Roles for Roles.Role;
39 
40     event PauserAdded(address indexed account);
41     event PauserRemoved(address indexed account);
42 
43     Roles.Role private _pausers;
44 
45     constructor () internal {
46         _addPauser(_msgSender());
47     }
48 
49     modifier onlyPauser() {
50         require(isPauser(_msgSender()), "PauserRole: caller does not have the Pauser role");
51         _;
52     }
53 
54     function isPauser(address account) public view returns (bool) {
55         return _pausers.has(account);
56     }
57 
58     function addPauser(address account) public onlyPauser {
59         _addPauser(account);
60     }
61 
62     function renouncePauser() public {
63         _removePauser(_msgSender());
64     }
65 
66     function _addPauser(address account) internal {
67         _pausers.add(account);
68         emit PauserAdded(account);
69     }
70 
71     function _removePauser(address account) internal {
72         _pausers.remove(account);
73         emit PauserRemoved(account);
74     }
75 }
76 
77 // File: @openzeppelin/contracts/lifecycle/Pausable.sol
78 
79 pragma solidity ^0.5.0;
80 
81 
82 
83 /**
84  * @dev Contract module which allows children to implement an emergency stop
85  * mechanism that can be triggered by an authorized account.
86  *
87  * This module is used through inheritance. It will make available the
88  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
89  * the functions of your contract. Note that they will not be pausable by
90  * simply including this module, only once the modifiers are put in place.
91  */
92 contract Pausable is Context, PauserRole {
93     /**
94      * @dev Emitted when the pause is triggered by a pauser (`account`).
95      */
96     event Paused(address account);
97 
98     /**
99      * @dev Emitted when the pause is lifted by a pauser (`account`).
100      */
101     event Unpaused(address account);
102 
103     bool private _paused;
104 
105     /**
106      * @dev Initializes the contract in unpaused state. Assigns the Pauser role
107      * to the deployer.
108      */
109     constructor () internal {
110         _paused = false;
111     }
112 
113     /**
114      * @dev Returns true if the contract is paused, and false otherwise.
115      */
116     function paused() public view returns (bool) {
117         return _paused;
118     }
119 
120     /**
121      * @dev Modifier to make a function callable only when the contract is not paused.
122      */
123     modifier whenNotPaused() {
124         require(!_paused, "Pausable: paused");
125         _;
126     }
127 
128     /**
129      * @dev Modifier to make a function callable only when the contract is paused.
130      */
131     modifier whenPaused() {
132         require(_paused, "Pausable: not paused");
133         _;
134     }
135 
136     /**
137      * @dev Called by a pauser to pause, triggers stopped state.
138      */
139     function pause() public onlyPauser whenNotPaused {
140         _paused = true;
141         emit Paused(_msgSender());
142     }
143 
144     /**
145      * @dev Called by a pauser to unpause, returns to normal state.
146      */
147     function unpause() public onlyPauser whenPaused {
148         _paused = false;
149         emit Unpaused(_msgSender());
150     }
151 }
152 
153 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
154 
155 pragma solidity ^0.5.0;
156 
157 /**
158  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
159  * the optional functions; to access them see {ERC20Detailed}.
160  */
161 interface IERC20 {
162     /**
163      * @dev Returns the amount of tokens in existence.
164      */
165     function totalSupply() external view returns (uint256);
166 
167     /**
168      * @dev Returns the amount of tokens owned by `account`.
169      */
170     function balanceOf(address account) external view returns (uint256);
171 
172     /**
173      * @dev Moves `amount` tokens from the caller's account to `recipient`.
174      *
175      * Returns a boolean value indicating whether the operation succeeded.
176      *
177      * Emits a {Transfer} event.
178      */
179     function transfer(address recipient, uint256 amount) external returns (bool);
180 
181     /**
182      * @dev Returns the remaining number of tokens that `spender` will be
183      * allowed to spend on behalf of `owner` through {transferFrom}. This is
184      * zero by default.
185      *
186      * This value changes when {approve} or {transferFrom} are called.
187      */
188     function allowance(address owner, address spender) external view returns (uint256);
189 
190     /**
191      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
192      *
193      * Returns a boolean value indicating whether the operation succeeded.
194      *
195      * IMPORTANT: Beware that changing an allowance with this method brings the risk
196      * that someone may use both the old and the new allowance by unfortunate
197      * transaction ordering. One possible solution to mitigate this race
198      * condition is to first reduce the spender's allowance to 0 and set the
199      * desired value afterwards:
200      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
201      *
202      * Emits an {Approval} event.
203      */
204     function approve(address spender, uint256 amount) external returns (bool);
205 
206     /**
207      * @dev Moves `amount` tokens from `sender` to `recipient` using the
208      * allowance mechanism. `amount` is then deducted from the caller's
209      * allowance.
210      *
211      * Returns a boolean value indicating whether the operation succeeded.
212      *
213      * Emits a {Transfer} event.
214      */
215     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
216 
217     /**
218      * @dev Emitted when `value` tokens are moved from one account (`from`) to
219      * another (`to`).
220      *
221      * Note that `value` may be zero.
222      */
223     event Transfer(address indexed from, address indexed to, uint256 value);
224 
225     /**
226      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
227      * a call to {approve}. `value` is the new allowance.
228      */
229     event Approval(address indexed owner, address indexed spender, uint256 value);
230 }
231 
232 
233 
234 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
235 
236 pragma solidity ^0.5.0;
237 
238 
239 
240 
241 /**
242  * @dev Implementation of the {IERC20} interface.
243  *
244  * This implementation is agnostic to the way tokens are created. This means
245  * that a supply mechanism has to be added in a derived contract using {_mint}.
246  * For a generic mechanism see {ERC20Mintable}.
247  *
248  * TIP: For a detailed writeup see our guide
249  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
250  * to implement supply mechanisms].
251  *
252  * We have followed general OpenZeppelin guidelines: functions revert instead
253  * of returning `false` on failure. This behavior is nonetheless conventional
254  * and does not conflict with the expectations of ERC20 applications.
255  *
256  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
257  * This allows applications to reconstruct the allowance for all accounts just
258  * by listening to said events. Other implementations of the EIP may not emit
259  * these events, as it isn't required by the specification.
260  *
261  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
262  * functions have been added to mitigate the well-known issues around setting
263  * allowances. See {IERC20-approve}.
264  */
265 contract ERC20 is Context, IERC20 {
266     using SafeMath for uint256;
267 
268     mapping (address => uint256) private _balances;
269 
270     mapping (address => mapping (address => uint256)) private _allowances;
271 
272     uint256 private _totalSupply;
273 
274     /**
275      * @dev See {IERC20-totalSupply}.
276      */
277     function totalSupply() public view returns (uint256) {
278         return _totalSupply;
279     }
280 
281     /**
282      * @dev See {IERC20-balanceOf}.
283      */
284     function balanceOf(address account) public view returns (uint256) {
285         return _balances[account];
286     }
287 
288     /**
289      * @dev See {IERC20-transfer}.
290      *
291      * Requirements:
292      *
293      * - `recipient` cannot be the zero address.
294      * - the caller must have a balance of at least `amount`.
295      */
296     function transfer(address recipient, uint256 amount) public returns (bool) {
297         _transfer(_msgSender(), recipient, amount);
298         return true;
299     }
300 
301     /**
302      * @dev See {IERC20-allowance}.
303      */
304     function allowance(address owner, address spender) public view returns (uint256) {
305         return _allowances[owner][spender];
306     }
307 
308     /**
309      * @dev See {IERC20-approve}.
310      *
311      * Requirements:
312      *
313      * - `spender` cannot be the zero address.
314      */
315     function approve(address spender, uint256 amount) public returns (bool) {
316         _approve(_msgSender(), spender, amount);
317         return true;
318     }
319 
320     /**
321      * @dev See {IERC20-transferFrom}.
322      *
323      * Emits an {Approval} event indicating the updated allowance. This is not
324      * required by the EIP. See the note at the beginning of {ERC20};
325      *
326      * Requirements:
327      * - `sender` and `recipient` cannot be the zero address.
328      * - `sender` must have a balance of at least `amount`.
329      * - the caller must have allowance for `sender`'s tokens of at least
330      * `amount`.
331      */
332     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
333         _transfer(sender, recipient, amount);
334         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
335         return true;
336     }
337 
338     /**
339      * @dev Atomically increases the allowance granted to `spender` by the caller.
340      *
341      * This is an alternative to {approve} that can be used as a mitigation for
342      * problems described in {IERC20-approve}.
343      *
344      * Emits an {Approval} event indicating the updated allowance.
345      *
346      * Requirements:
347      *
348      * - `spender` cannot be the zero address.
349      */
350     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
351         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
352         return true;
353     }
354 
355     /**
356      * @dev Atomically decreases the allowance granted to `spender` by the caller.
357      *
358      * This is an alternative to {approve} that can be used as a mitigation for
359      * problems described in {IERC20-approve}.
360      *
361      * Emits an {Approval} event indicating the updated allowance.
362      *
363      * Requirements:
364      *
365      * - `spender` cannot be the zero address.
366      * - `spender` must have allowance for the caller of at least
367      * `subtractedValue`.
368      */
369     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
370         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
371         return true;
372     }
373 
374     /**
375      * @dev Moves tokens `amount` from `sender` to `recipient`.
376      *
377      * This is internal function is equivalent to {transfer}, and can be used to
378      * e.g. implement automatic token fees, slashing mechanisms, etc.
379      *
380      * Emits a {Transfer} event.
381      *
382      * Requirements:
383      *
384      * - `sender` cannot be the zero address.
385      * - `recipient` cannot be the zero address.
386      * - `sender` must have a balance of at least `amount`.
387      */
388     function _transfer(address sender, address recipient, uint256 amount) internal {
389         require(sender != address(0), "ERC20: transfer from the zero address");
390         require(recipient != address(0), "ERC20: transfer to the zero address");
391 
392         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
393         _balances[recipient] = _balances[recipient].add(amount);
394         emit Transfer(sender, recipient, amount);
395     }
396 
397     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
398      * the total supply.
399      *
400      * Emits a {Transfer} event with `from` set to the zero address.
401      *
402      * Requirements
403      *
404      * - `to` cannot be the zero address.
405      */
406     function _mint(address account, uint256 amount) internal {
407         require(account != address(0), "ERC20: mint to the zero address");
408 
409         _totalSupply = _totalSupply.add(amount);
410         _balances[account] = _balances[account].add(amount);
411         emit Transfer(address(0), account, amount);
412     }
413 
414     /**
415      * @dev Destroys `amount` tokens from `account`, reducing the
416      * total supply.
417      *
418      * Emits a {Transfer} event with `to` set to the zero address.
419      *
420      * Requirements
421      *
422      * - `account` cannot be the zero address.
423      * - `account` must have at least `amount` tokens.
424      */
425     function _burn(address account, uint256 amount) internal {
426         require(account != address(0), "ERC20: burn from the zero address");
427 
428         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
429         _totalSupply = _totalSupply.sub(amount);
430         emit Transfer(account, address(0), amount);
431     }
432 
433     /**
434      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
435      *
436      * This is internal function is equivalent to `approve`, and can be used to
437      * e.g. set automatic allowances for certain subsystems, etc.
438      *
439      * Emits an {Approval} event.
440      *
441      * Requirements:
442      *
443      * - `owner` cannot be the zero address.
444      * - `spender` cannot be the zero address.
445      */
446     function _approve(address owner, address spender, uint256 amount) internal {
447         require(owner != address(0), "ERC20: approve from the zero address");
448         require(spender != address(0), "ERC20: approve to the zero address");
449 
450         _allowances[owner][spender] = amount;
451         emit Approval(owner, spender, amount);
452     }
453 
454     /**
455      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
456      * from the caller's allowance.
457      *
458      * See {_burn} and {_approve}.
459      */
460     function _burnFrom(address account, uint256 amount) internal {
461         _burn(account, amount);
462         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
463     }
464 }
465 
466 // File: @openzeppelin/contracts/token/ERC20/ERC20Burnable.sol
467 
468 pragma solidity ^0.5.0;
469 
470 
471 
472 /**
473  * @dev Extension of {ERC20} that allows token holders to destroy both their own
474  * tokens and those that they have an allowance for, in a way that can be
475  * recognized off-chain (via event analysis).
476  */
477 contract ERC20Burnable is Context, ERC20 {
478     /**
479      * @dev Destroys `amount` tokens from the caller.
480      *
481      * See {ERC20-_burn}.
482      */
483     function burn(uint256 amount) public {
484         _burn(_msgSender(), amount);
485     }
486 
487     /**
488      * @dev See {ERC20-_burnFrom}.
489      */
490     function burnFrom(address account, uint256 amount) public {
491         _burnFrom(account, amount);
492     }
493 }
494 
495 
496 // File: @openzeppelin/contracts/token/ERC20/ERC20Pausable.sol
497 
498 pragma solidity ^0.5.0;
499 
500 
501 
502 /**
503  * @title Pausable token
504  * @dev ERC20 with pausable transfers and allowances.
505  *
506  * Useful if you want to stop trades until the end of a crowdsale, or have
507  * an emergency switch for freezing all token transfers in the event of a large
508  * bug.
509  */
510 contract ERC20Pausable is ERC20, Pausable {
511     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
512         return super.transfer(to, value);
513     }
514 
515     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
516         return super.transferFrom(from, to, value);
517     }
518 
519     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
520         return super.approve(spender, value);
521     }
522 
523     function increaseAllowance(address spender, uint256 addedValue) public whenNotPaused returns (bool) {
524         return super.increaseAllowance(spender, addedValue);
525     }
526 
527     function decreaseAllowance(address spender, uint256 subtractedValue) public whenNotPaused returns (bool) {
528         return super.decreaseAllowance(spender, subtractedValue);
529     }
530 }
531 
532 // File: @openzeppelin/contracts/access/Roles.sol
533 
534 pragma solidity ^0.5.0;
535 
536 /**
537  * @title Roles
538  * @dev Library for managing addresses assigned to a Role.
539  */
540 library Roles {
541     struct Role {
542         mapping (address => bool) bearer;
543     }
544 
545     /**
546      * @dev Give an account access to this role.
547      */
548     function add(Role storage role, address account) internal {
549         require(!has(role, account), "Roles: account already has role");
550         role.bearer[account] = true;
551     }
552 
553     /**
554      * @dev Remove an account's access to this role.
555      */
556     function remove(Role storage role, address account) internal {
557         require(has(role, account), "Roles: account does not have role");
558         role.bearer[account] = false;
559     }
560 
561     /**
562      * @dev Check if an account has this role.
563      * @return bool
564      */
565     function has(Role storage role, address account) internal view returns (bool) {
566         require(account != address(0), "Roles: account is the zero address");
567         return role.bearer[account];
568     }
569 }
570 
571 // File: @openzeppelin/contracts/access/roles/MinterRole.sol
572 
573 pragma solidity ^0.5.0;
574 
575 
576 
577 contract MinterRole is Context {
578     using Roles for Roles.Role;
579 
580     event MinterAdded(address indexed account);
581     event MinterRemoved(address indexed account);
582 
583     Roles.Role private _minters;
584 
585     constructor () internal {
586         _addMinter(_msgSender());
587     }
588 
589     modifier onlyMinter() {
590         require(isMinter(_msgSender()), "MinterRole: caller does not have the Minter role");
591         _;
592     }
593 
594     function isMinter(address account) public view returns (bool) {
595         return _minters.has(account);
596     }
597 
598     function addMinter(address account) public onlyMinter {
599         _addMinter(account);
600     }
601 
602     function renounceMinter() public {
603         _removeMinter(_msgSender());
604     }
605 
606     function _addMinter(address account) internal {
607         _minters.add(account);
608         emit MinterAdded(account);
609     }
610 
611     function _removeMinter(address account) internal {
612         _minters.remove(account);
613         emit MinterRemoved(account);
614     }
615 }
616 
617 // File: @openzeppelin/contracts/math/SafeMath.sol
618 
619 pragma solidity ^0.5.0;
620 
621 /**
622  * @dev Wrappers over Solidity's arithmetic operations with added overflow
623  * checks.
624  *
625  * Arithmetic operations in Solidity wrap on overflow. This can easily result
626  * in bugs, because programmers usually assume that an overflow raises an
627  * error, which is the standard behavior in high level programming languages.
628  * `SafeMath` restores this intuition by reverting the transaction when an
629  * operation overflows.
630  *
631  * Using this library instead of the unchecked operations eliminates an entire
632  * class of bugs, so it's recommended to use it always.
633  */
634 library SafeMath {
635     /**
636      * @dev Returns the addition of two unsigned integers, reverting on
637      * overflow.
638      *
639      * Counterpart to Solidity's `+` operator.
640      *
641      * Requirements:
642      * - Addition cannot overflow.
643      */
644     function add(uint256 a, uint256 b) internal pure returns (uint256) {
645         uint256 c = a + b;
646         require(c >= a, "SafeMath: addition overflow");
647 
648         return c;
649     }
650 
651     /**
652      * @dev Returns the subtraction of two unsigned integers, reverting on
653      * overflow (when the result is negative).
654      *
655      * Counterpart to Solidity's `-` operator.
656      *
657      * Requirements:
658      * - Subtraction cannot overflow.
659      */
660     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
661         return sub(a, b, "SafeMath: subtraction overflow");
662     }
663 
664     /**
665      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
666      * overflow (when the result is negative).
667      *
668      * Counterpart to Solidity's `-` operator.
669      *
670      * Requirements:
671      * - Subtraction cannot overflow.
672      *
673      * _Available since v2.4.0._
674      */
675     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
676         require(b <= a, errorMessage);
677         uint256 c = a - b;
678 
679         return c;
680     }
681 
682     /**
683      * @dev Returns the multiplication of two unsigned integers, reverting on
684      * overflow.
685      *
686      * Counterpart to Solidity's `*` operator.
687      *
688      * Requirements:
689      * - Multiplication cannot overflow.
690      */
691     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
692         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
693         // benefit is lost if 'b' is also tested.
694         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
695         if (a == 0) {
696             return 0;
697         }
698 
699         uint256 c = a * b;
700         require(c / a == b, "SafeMath: multiplication overflow");
701 
702         return c;
703     }
704 
705     /**
706      * @dev Returns the integer division of two unsigned integers. Reverts on
707      * division by zero. The result is rounded towards zero.
708      *
709      * Counterpart to Solidity's `/` operator. Note: this function uses a
710      * `revert` opcode (which leaves remaining gas untouched) while Solidity
711      * uses an invalid opcode to revert (consuming all remaining gas).
712      *
713      * Requirements:
714      * - The divisor cannot be zero.
715      */
716     function div(uint256 a, uint256 b) internal pure returns (uint256) {
717         return div(a, b, "SafeMath: division by zero");
718     }
719 
720     /**
721      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
722      * division by zero. The result is rounded towards zero.
723      *
724      * Counterpart to Solidity's `/` operator. Note: this function uses a
725      * `revert` opcode (which leaves remaining gas untouched) while Solidity
726      * uses an invalid opcode to revert (consuming all remaining gas).
727      *
728      * Requirements:
729      * - The divisor cannot be zero.
730      *
731      * _Available since v2.4.0._
732      */
733     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
734         // Solidity only automatically asserts when dividing by 0
735         require(b > 0, errorMessage);
736         uint256 c = a / b;
737         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
738 
739         return c;
740     }
741 
742     /**
743      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
744      * Reverts when dividing by zero.
745      *
746      * Counterpart to Solidity's `%` operator. This function uses a `revert`
747      * opcode (which leaves remaining gas untouched) while Solidity uses an
748      * invalid opcode to revert (consuming all remaining gas).
749      *
750      * Requirements:
751      * - The divisor cannot be zero.
752      */
753     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
754         return mod(a, b, "SafeMath: modulo by zero");
755     }
756 
757     /**
758      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
759      * Reverts with custom message when dividing by zero.
760      *
761      * Counterpart to Solidity's `%` operator. This function uses a `revert`
762      * opcode (which leaves remaining gas untouched) while Solidity uses an
763      * invalid opcode to revert (consuming all remaining gas).
764      *
765      * Requirements:
766      * - The divisor cannot be zero.
767      *
768      * _Available since v2.4.0._
769      */
770     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
771         require(b != 0, errorMessage);
772         return a % b;
773     }
774 }
775 
776 
777 
778 
779 // File: @openzeppelin/contracts/token/ERC20/ERC20Mintable.sol
780 
781 pragma solidity ^0.5.0;
782 
783 
784 
785 /**
786  * @dev Extension of {ERC20} that adds a set of accounts with the {MinterRole},
787  * which have permission to mint (create) new tokens as they see fit.
788  *
789  * At construction, the deployer of the contract is the only minter.
790  */
791 contract ERC20Mintable is ERC20, MinterRole {
792     /**
793      * @dev See {ERC20-_mint}.
794      *
795      * Requirements:
796      *
797      * - the caller must have the {MinterRole}.
798      */
799     function mint(address account, uint256 amount) public onlyMinter returns (bool) {
800         _mint(account, amount);
801         return true;
802     }
803 }
804 
805 
806 // File: @openzeppelin/contracts/token/ERC20/ERC20Detailed.sol
807 
808 pragma solidity ^0.5.0;
809 
810 
811 /**
812  * @dev Optional functions from the ERC20 standard.
813  */
814 contract ERC20Detailed is IERC20 {
815     string private _name;
816     string private _symbol;
817     uint8 private _decimals;
818 
819     /**
820      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
821      * these values are immutable: they can only be set once during
822      * construction.
823      */
824     constructor (string memory name, string memory symbol, uint8 decimals) public {
825         _name = name;
826         _symbol = symbol;
827         _decimals = decimals;
828     }
829 
830     /**
831      * @dev Returns the name of the token.
832      */
833     function name() public view returns (string memory) {
834         return _name;
835     }
836 
837     /**
838      * @dev Returns the symbol of the token, usually a shorter version of the
839      * name.
840      */
841     function symbol() public view returns (string memory) {
842         return _symbol;
843     }
844 
845     /**
846      * @dev Returns the number of decimals used to get its user representation.
847      * For example, if `decimals` equals `2`, a balance of `505` tokens should
848      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
849      *
850      * Tokens usually opt for a value of 18, imitating the relationship between
851      * Ether and Wei.
852      *
853      * NOTE: This information is only used for _display_ purposes: it in
854      * no way affects any of the arithmetic of the contract, including
855      * {IERC20-balanceOf} and {IERC20-transfer}.
856      */
857     function decimals() public view returns (uint8) {
858         return _decimals;
859     }
860 }
861 
862 // File: src/TOLL.sol
863 
864 // SPDX-License-Identifier: MIT
865 pragma solidity ^0.5.0;
866 
867 
868 
869 
870 
871 contract TollERC20 is ERC20Burnable, ERC20Pausable, ERC20Mintable, ERC20Detailed {
872     constructor () public ERC20Detailed("Toll Free Swap", "TOLL", 18) {
873         // solhint-disable-previous-line no-empty-blocks
874     }
875 }