1 pragma solidity 0.5.0;
2 
3 
4 
5 contract PauserRole {
6     using Roles for Roles.Role;
7 
8     event PauserAdded(address indexed account);
9     event PauserRemoved(address indexed account);
10 
11     Roles.Role private _pausers;
12 
13     constructor () internal {
14         _addPauser(msg.sender);
15     }
16 
17     modifier onlyPauser() {
18         require(isPauser(msg.sender), "PauserRole: caller does not have the Pauser role");
19         _;
20     }
21 
22     function isPauser(address account) public view returns (bool) {
23         return _pausers.has(account);
24     }
25 
26     function addPauser(address account) public onlyPauser {
27         _addPauser(account);
28     }
29 
30     function renouncePauser() public {
31         _removePauser(msg.sender);
32     }
33 
34     function _addPauser(address account) internal {
35         _pausers.add(account);
36         emit PauserAdded(account);
37     }
38 
39     function _removePauser(address account) internal {
40         _pausers.remove(account);
41         emit PauserRemoved(account);
42     }
43 }
44 
45 
46 /**
47  * @dev Wrappers over Solidity's arithmetic operations with added overflow
48  * checks.
49  *
50  * Arithmetic operations in Solidity wrap on overflow. This can easily result
51  * in bugs, because programmers usually assume that an overflow raises an
52  * error, which is the standard behavior in high level programming languages.
53  * `SafeMath` restores this intuition by reverting the transaction when an
54  * operation overflows.
55  *
56  * Using this library instead of the unchecked operations eliminates an entire
57  * class of bugs, so it's recommended to use it always.
58  */
59 library SafeMath {
60     /**
61      * @dev Returns the addition of two unsigned integers, reverting on
62      * overflow.
63      *
64      * Counterpart to Solidity's `+` operator.
65      *
66      * Requirements:
67      * - Addition cannot overflow.
68      */
69     function add(uint256 a, uint256 b) internal pure returns (uint256) {
70         uint256 c = a + b;
71         require(c >= a, "SafeMath: addition overflow");
72 
73         return c;
74     }
75 
76     /**
77      * @dev Returns the subtraction of two unsigned integers, reverting on
78      * overflow (when the result is negative).
79      *
80      * Counterpart to Solidity's `-` operator.
81      *
82      * Requirements:
83      * - Subtraction cannot overflow.
84      */
85     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
86         require(b <= a, "SafeMath: subtraction overflow");
87         uint256 c = a - b;
88 
89         return c;
90     }
91 
92     /**
93      * @dev Returns the multiplication of two unsigned integers, reverting on
94      * overflow.
95      *
96      * Counterpart to Solidity's `*` operator.
97      *
98      * Requirements:
99      * - Multiplication cannot overflow.
100      */
101     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
102         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
103         // benefit is lost if 'b' is also tested.
104         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
105         if (a == 0) {
106             return 0;
107         }
108 
109         uint256 c = a * b;
110         require(c / a == b, "SafeMath: multiplication overflow");
111 
112         return c;
113     }
114 
115     /**
116      * @dev Returns the integer division of two unsigned integers. Reverts on
117      * division by zero. The result is rounded towards zero.
118      *
119      * Counterpart to Solidity's `/` operator. Note: this function uses a
120      * `revert` opcode (which leaves remaining gas untouched) while Solidity
121      * uses an invalid opcode to revert (consuming all remaining gas).
122      *
123      * Requirements:
124      * - The divisor cannot be zero.
125      */
126     function div(uint256 a, uint256 b) internal pure returns (uint256) {
127         // Solidity only automatically asserts when dividing by 0
128         require(b > 0, "SafeMath: division by zero");
129         uint256 c = a / b;
130         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
131 
132         return c;
133     }
134 
135     /**
136      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
137      * Reverts when dividing by zero.
138      *
139      * Counterpart to Solidity's `%` operator. This function uses a `revert`
140      * opcode (which leaves remaining gas untouched) while Solidity uses an
141      * invalid opcode to revert (consuming all remaining gas).
142      *
143      * Requirements:
144      * - The divisor cannot be zero.
145      */
146     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
147         require(b != 0, "SafeMath: modulo by zero");
148         return a % b;
149     }
150 }
151 
152 
153 
154 /**
155  * @title Finance interface.
156  * @dev Copied from https://github.com/aragon/aragon-apps/blob/master/apps/finance/contracts/Finance.sol#L198 .
157  */
158 contract Finance {
159 
160     /**
161     * @notice Deposit Some token in the DAO
162     * @dev Deposit for approved ERC20 tokens or ETH
163     * @param _token Address of deposited token
164     * @param _amount Amount of tokens sent
165     * @param _reference Reason for payment
166     */
167     function deposit(address _token, uint256 _amount, string calldata _reference) external payable;
168 }
169 
170 
171 
172 
173 /**
174  * @title Roles
175  * @dev Library for managing addresses assigned to a Role.
176  */
177 library Roles {
178     struct Role {
179         mapping (address => bool) bearer;
180     }
181 
182     /**
183      * @dev Give an account access to this role.
184      */
185     function add(Role storage role, address account) internal {
186         require(!has(role, account), "Roles: account already has role");
187         role.bearer[account] = true;
188     }
189 
190     /**
191      * @dev Remove an account's access to this role.
192      */
193     function remove(Role storage role, address account) internal {
194         require(has(role, account), "Roles: account does not have role");
195         role.bearer[account] = false;
196     }
197 
198     /**
199      * @dev Check if an account has this role.
200      * @return bool
201      */
202     function has(Role storage role, address account) internal view returns (bool) {
203         require(account != address(0), "Roles: account is the zero address");
204         return role.bearer[account];
205     }
206 }
207 
208 
209 contract MinterRole {
210     using Roles for Roles.Role;
211 
212     event MinterAdded(address indexed account);
213     event MinterRemoved(address indexed account);
214 
215     Roles.Role private _minters;
216 
217     constructor () internal {
218         _addMinter(msg.sender);
219     }
220 
221     modifier onlyMinter() {
222         require(isMinter(msg.sender), "MinterRole: caller does not have the Minter role");
223         _;
224     }
225 
226     function isMinter(address account) public view returns (bool) {
227         return _minters.has(account);
228     }
229 
230     function addMinter(address account) public onlyMinter {
231         _addMinter(account);
232     }
233 
234     function renounceMinter() public {
235         _removeMinter(msg.sender);
236     }
237 
238     function _addMinter(address account) internal {
239         _minters.add(account);
240         emit MinterAdded(account);
241     }
242 
243     function _removeMinter(address account) internal {
244         _minters.remove(account);
245         emit MinterRemoved(account);
246     }
247 }
248 
249 
250 
251 
252 
253 
254 
255 
256 /**
257  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
258  * the optional functions; to access them see `ERC20Detailed`.
259  */
260 interface IERC20 {
261     /**
262      * @dev Returns the amount of tokens in existence.
263      */
264     function totalSupply() external view returns (uint256);
265 
266     /**
267      * @dev Returns the amount of tokens owned by `account`.
268      */
269     function balanceOf(address account) external view returns (uint256);
270 
271     /**
272      * @dev Moves `amount` tokens from the caller's account to `recipient`.
273      *
274      * Returns a boolean value indicating whether the operation succeeded.
275      *
276      * Emits a `Transfer` event.
277      */
278     function transfer(address recipient, uint256 amount) external returns (bool);
279 
280     /**
281      * @dev Returns the remaining number of tokens that `spender` will be
282      * allowed to spend on behalf of `owner` through `transferFrom`. This is
283      * zero by default.
284      *
285      * This value changes when `approve` or `transferFrom` are called.
286      */
287     function allowance(address owner, address spender) external view returns (uint256);
288 
289     /**
290      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
291      *
292      * Returns a boolean value indicating whether the operation succeeded.
293      *
294      * > Beware that changing an allowance with this method brings the risk
295      * that someone may use both the old and the new allowance by unfortunate
296      * transaction ordering. One possible solution to mitigate this race
297      * condition is to first reduce the spender's allowance to 0 and set the
298      * desired value afterwards:
299      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
300      *
301      * Emits an `Approval` event.
302      */
303     function approve(address spender, uint256 amount) external returns (bool);
304 
305     /**
306      * @dev Moves `amount` tokens from `sender` to `recipient` using the
307      * allowance mechanism. `amount` is then deducted from the caller's
308      * allowance.
309      *
310      * Returns a boolean value indicating whether the operation succeeded.
311      *
312      * Emits a `Transfer` event.
313      */
314     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
315 
316     /**
317      * @dev Emitted when `value` tokens are moved from one account (`from`) to
318      * another (`to`).
319      *
320      * Note that `value` may be zero.
321      */
322     event Transfer(address indexed from, address indexed to, uint256 value);
323 
324     /**
325      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
326      * a call to `approve`. `value` is the new allowance.
327      */
328     event Approval(address indexed owner, address indexed spender, uint256 value);
329 }
330 
331 
332 
333 /**
334  * @dev Implementation of the `IERC20` interface.
335  *
336  * This implementation is agnostic to the way tokens are created. This means
337  * that a supply mechanism has to be added in a derived contract using `_mint`.
338  * For a generic mechanism see `ERC20Mintable`.
339  *
340  * *For a detailed writeup see our guide [How to implement supply
341  * mechanisms](https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226).*
342  *
343  * We have followed general OpenZeppelin guidelines: functions revert instead
344  * of returning `false` on failure. This behavior is nonetheless conventional
345  * and does not conflict with the expectations of ERC20 applications.
346  *
347  * Additionally, an `Approval` event is emitted on calls to `transferFrom`.
348  * This allows applications to reconstruct the allowance for all accounts just
349  * by listening to said events. Other implementations of the EIP may not emit
350  * these events, as it isn't required by the specification.
351  *
352  * Finally, the non-standard `decreaseAllowance` and `increaseAllowance`
353  * functions have been added to mitigate the well-known issues around setting
354  * allowances. See `IERC20.approve`.
355  */
356 contract ERC20 is IERC20 {
357     using SafeMath for uint256;
358 
359     mapping (address => uint256) private _balances;
360 
361     mapping (address => mapping (address => uint256)) private _allowances;
362 
363     uint256 private _totalSupply;
364 
365     /**
366      * @dev See `IERC20.totalSupply`.
367      */
368     function totalSupply() public view returns (uint256) {
369         return _totalSupply;
370     }
371 
372     /**
373      * @dev See `IERC20.balanceOf`.
374      */
375     function balanceOf(address account) public view returns (uint256) {
376         return _balances[account];
377     }
378 
379     /**
380      * @dev See `IERC20.transfer`.
381      *
382      * Requirements:
383      *
384      * - `recipient` cannot be the zero address.
385      * - the caller must have a balance of at least `amount`.
386      */
387     function transfer(address recipient, uint256 amount) public returns (bool) {
388         _transfer(msg.sender, recipient, amount);
389         return true;
390     }
391 
392     /**
393      * @dev See `IERC20.allowance`.
394      */
395     function allowance(address owner, address spender) public view returns (uint256) {
396         return _allowances[owner][spender];
397     }
398 
399     /**
400      * @dev See `IERC20.approve`.
401      *
402      * Requirements:
403      *
404      * - `spender` cannot be the zero address.
405      */
406     function approve(address spender, uint256 value) public returns (bool) {
407         _approve(msg.sender, spender, value);
408         return true;
409     }
410 
411     /**
412      * @dev See `IERC20.transferFrom`.
413      *
414      * Emits an `Approval` event indicating the updated allowance. This is not
415      * required by the EIP. See the note at the beginning of `ERC20`;
416      *
417      * Requirements:
418      * - `sender` and `recipient` cannot be the zero address.
419      * - `sender` must have a balance of at least `value`.
420      * - the caller must have allowance for `sender`'s tokens of at least
421      * `amount`.
422      */
423     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
424         _transfer(sender, recipient, amount);
425         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
426         return true;
427     }
428 
429     /**
430      * @dev Atomically increases the allowance granted to `spender` by the caller.
431      *
432      * This is an alternative to `approve` that can be used as a mitigation for
433      * problems described in `IERC20.approve`.
434      *
435      * Emits an `Approval` event indicating the updated allowance.
436      *
437      * Requirements:
438      *
439      * - `spender` cannot be the zero address.
440      */
441     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
442         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
443         return true;
444     }
445 
446     /**
447      * @dev Atomically decreases the allowance granted to `spender` by the caller.
448      *
449      * This is an alternative to `approve` that can be used as a mitigation for
450      * problems described in `IERC20.approve`.
451      *
452      * Emits an `Approval` event indicating the updated allowance.
453      *
454      * Requirements:
455      *
456      * - `spender` cannot be the zero address.
457      * - `spender` must have allowance for the caller of at least
458      * `subtractedValue`.
459      */
460     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
461         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
462         return true;
463     }
464 
465     /**
466      * @dev Moves tokens `amount` from `sender` to `recipient`.
467      *
468      * This is internal function is equivalent to `transfer`, and can be used to
469      * e.g. implement automatic token fees, slashing mechanisms, etc.
470      *
471      * Emits a `Transfer` event.
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
483         _balances[sender] = _balances[sender].sub(amount);
484         _balances[recipient] = _balances[recipient].add(amount);
485         emit Transfer(sender, recipient, amount);
486     }
487 
488     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
489      * the total supply.
490      *
491      * Emits a `Transfer` event with `from` set to the zero address.
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
506      * @dev Destoys `amount` tokens from `account`, reducing the
507      * total supply.
508      *
509      * Emits a `Transfer` event with `to` set to the zero address.
510      *
511      * Requirements
512      *
513      * - `account` cannot be the zero address.
514      * - `account` must have at least `amount` tokens.
515      */
516     function _burn(address account, uint256 value) internal {
517         require(account != address(0), "ERC20: burn from the zero address");
518 
519         _totalSupply = _totalSupply.sub(value);
520         _balances[account] = _balances[account].sub(value);
521         emit Transfer(account, address(0), value);
522     }
523 
524     /**
525      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
526      *
527      * This is internal function is equivalent to `approve`, and can be used to
528      * e.g. set automatic allowances for certain subsystems, etc.
529      *
530      * Emits an `Approval` event.
531      *
532      * Requirements:
533      *
534      * - `owner` cannot be the zero address.
535      * - `spender` cannot be the zero address.
536      */
537     function _approve(address owner, address spender, uint256 value) internal {
538         require(owner != address(0), "ERC20: approve from the zero address");
539         require(spender != address(0), "ERC20: approve to the zero address");
540 
541         _allowances[owner][spender] = value;
542         emit Approval(owner, spender, value);
543     }
544 
545     /**
546      * @dev Destoys `amount` tokens from `account`.`amount` is then deducted
547      * from the caller's allowance.
548      *
549      * See `_burn` and `_approve`.
550      */
551     function _burnFrom(address account, uint256 amount) internal {
552         _burn(account, amount);
553         _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount));
554     }
555 }
556 
557 
558 
559 
560 
561 /**
562  * @dev Contract module which allows children to implement an emergency stop
563  * mechanism that can be triggered by an authorized account.
564  *
565  * This module is used through inheritance. It will make available the
566  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
567  * the functions of your contract. Note that they will not be pausable by
568  * simply including this module, only once the modifiers are put in place.
569  */
570 contract Pausable is PauserRole {
571     /**
572      * @dev Emitted when the pause is triggered by a pauser (`account`).
573      */
574     event Paused(address account);
575 
576     /**
577      * @dev Emitted when the pause is lifted by a pauser (`account`).
578      */
579     event Unpaused(address account);
580 
581     bool private _paused;
582 
583     /**
584      * @dev Initializes the contract in unpaused state. Assigns the Pauser role
585      * to the deployer.
586      */
587     constructor () internal {
588         _paused = false;
589     }
590 
591     /**
592      * @dev Returns true if the contract is paused, and false otherwise.
593      */
594     function paused() public view returns (bool) {
595         return _paused;
596     }
597 
598     /**
599      * @dev Modifier to make a function callable only when the contract is not paused.
600      */
601     modifier whenNotPaused() {
602         require(!_paused, "Pausable: paused");
603         _;
604     }
605 
606     /**
607      * @dev Modifier to make a function callable only when the contract is paused.
608      */
609     modifier whenPaused() {
610         require(_paused, "Pausable: not paused");
611         _;
612     }
613 
614     /**
615      * @dev Called by a pauser to pause, triggers stopped state.
616      */
617     function pause() public onlyPauser whenNotPaused {
618         _paused = true;
619         emit Paused(msg.sender);
620     }
621 
622     /**
623      * @dev Called by a pauser to unpause, returns to normal state.
624      */
625     function unpause() public onlyPauser whenPaused {
626         _paused = false;
627         emit Unpaused(msg.sender);
628     }
629 }
630 
631 
632 /**
633  * @title Pausable token
634  * @dev ERC20 modified with pausable transfers.
635  */
636 contract ERC20Pausable is ERC20, Pausable {
637     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
638         return super.transfer(to, value);
639     }
640 
641     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
642         return super.transferFrom(from, to, value);
643     }
644 
645     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
646         return super.approve(spender, value);
647     }
648 
649     function increaseAllowance(address spender, uint addedValue) public whenNotPaused returns (bool) {
650         return super.increaseAllowance(spender, addedValue);
651     }
652 
653     function decreaseAllowance(address spender, uint subtractedValue) public whenNotPaused returns (bool) {
654         return super.decreaseAllowance(spender, subtractedValue);
655     }
656 }
657 
658 
659 
660 
661 
662 
663 /**
664  * @dev Contract module which provides a basic access control mechanism, where
665  * there is an account (an owner) that can be granted exclusive access to
666  * specific functions.
667  *
668  * This module is used through inheritance. It will make available the modifier
669  * `onlyOwner`, which can be aplied to your functions to restrict their use to
670  * the owner.
671  */
672 contract Ownable {
673     address private _owner;
674 
675     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
676 
677     /**
678      * @dev Initializes the contract setting the deployer as the initial owner.
679      */
680     constructor () internal {
681         _owner = msg.sender;
682         emit OwnershipTransferred(address(0), _owner);
683     }
684 
685     /**
686      * @dev Returns the address of the current owner.
687      */
688     function owner() public view returns (address) {
689         return _owner;
690     }
691 
692     /**
693      * @dev Throws if called by any account other than the owner.
694      */
695     modifier onlyOwner() {
696         require(isOwner(), "Ownable: caller is not the owner");
697         _;
698     }
699 
700     /**
701      * @dev Returns true if the caller is the current owner.
702      */
703     function isOwner() public view returns (bool) {
704         return msg.sender == _owner;
705     }
706 
707     /**
708      * @dev Leaves the contract without owner. It will not be possible to call
709      * `onlyOwner` functions anymore. Can only be called by the current owner.
710      *
711      * > Note: Renouncing ownership will leave the contract without an owner,
712      * thereby removing any functionality that is only available to the owner.
713      */
714     function renounceOwnership() public onlyOwner {
715         emit OwnershipTransferred(_owner, address(0));
716         _owner = address(0);
717     }
718 
719     /**
720      * @dev Transfers ownership of the contract to a new account (`newOwner`).
721      * Can only be called by the current owner.
722      */
723     function transferOwnership(address newOwner) public onlyOwner {
724         _transferOwnership(newOwner);
725     }
726 
727     /**
728      * @dev Transfers ownership of the contract to a new account (`newOwner`).
729      */
730     function _transferOwnership(address newOwner) internal {
731         require(newOwner != address(0), "Ownable: new owner is the zero address");
732         emit OwnershipTransferred(_owner, newOwner);
733         _owner = newOwner;
734     }
735 }
736 
737 
738 
739 
740 
741 /**
742  * @dev Collection of functions related to the address type,
743  */
744 library Address {
745     /**
746      * @dev Returns true if `account` is a contract.
747      *
748      * This test is non-exhaustive, and there may be false-negatives: during the
749      * execution of a contract's constructor, its address will be reported as
750      * not containing a contract.
751      *
752      * > It is unsafe to assume that an address for which this function returns
753      * false is an externally-owned account (EOA) and not a contract.
754      */
755     function isContract(address account) internal view returns (bool) {
756         // This method relies in extcodesize, which returns 0 for contracts in
757         // construction, since the code is only stored at the end of the
758         // constructor execution.
759 
760         uint256 size;
761         // solhint-disable-next-line no-inline-assembly
762         assembly { size := extcodesize(account) }
763         return size > 0;
764     }
765 }
766 
767 
768 
769 
770 contract FinanceManager is Ownable {
771     using Address for address;
772     using SafeMath for uint256;
773 
774     Finance public finance;
775 
776     string private constant APPROVE_ERROR = "Approve error.";
777     string private constant RECLAIM_MESSAGE = "Reclaiming tokens sent by mistake.";
778     string private constant IS_NOT_CONTRACT = "Address doesn't belong to a smart contract.";
779     string private constant ZERO_BALANCE = "There are no tokens of this type to be reclaimed.";
780 
781     event ReclaimedTokens(address tokenAddr, uint256 amount);
782     event FinanceSet(address financeAddr);
783 
784     /**
785     * @notice Set the DAO finance app address where deposited or reclaimed tokens will go.
786     * @param _finance The DAO's finance app with a deposit() function.
787     */
788     function setFinance(Finance _finance)
789         external
790         onlyOwner
791     {
792         require(address(_finance).isContract(), IS_NOT_CONTRACT);
793 
794         finance = _finance;
795         emit FinanceSet(address(_finance));
796     }
797 
798     /**
799     * @notice Reclaim tokens of the specified type sent to the smart contract.
800     * @dev Reclaim the specified type of ERC20 tokens sent to the smart contract.
801     * Tokens will be deposited into the finance app set with setFinance().
802     * @param token The token contract.
803     */
804     function reclaimTokens(ERC20 token)
805         external
806         onlyOwner
807     {
808         require(address(token).isContract(), IS_NOT_CONTRACT);
809 
810         uint256 balance = token.balanceOf(address(this));
811         require(0 < balance, ZERO_BALANCE);
812 
813         deposit(token, balance, RECLAIM_MESSAGE);
814         emit ReclaimedTokens(address(token), balance);
815     }
816 
817     /**
818     * @dev Deposit the specified type of ERC20 tokens using the finance app set
819     * with setFinance().
820     * @param token The token contract.
821     * @param amount Number of tokens to deposit.
822     * @param _reference Reason for the deposit.
823     */
824     function deposit(ERC20 token, uint256 amount, string memory _reference)
825         internal
826     {
827         require(token.approve(address(finance), amount), APPROVE_ERROR);
828 
829         finance.deposit(address(token), amount, _reference);
830     }
831 
832 }
833 
834 
835 
836 /**
837 * @title Subscriptions contract
838 */
839 contract Subscriptions is ERC20Pausable, MinterRole, FinanceManager {
840     string public constant name = "Subscriptions";
841     string public constant symbol = "Subs";
842     uint8 public constant decimals = 0;
843 
844     string private constant ALL_SPONSORSHIPS_CLAIMED = "All Sponsorships claimed";
845     string private constant INVALID_AMOUNT = "Amount must be greater than zero";
846 
847     struct Account {
848         uint256 received;
849         // Array to keep track of timestamps for the batches.
850         uint256[] timestamps;
851         // Batches mapped from timestamps to amounts.
852         mapping (uint256 => uint256) batches;
853     }
854 
855     mapping(address => Account) private accounts;
856 
857     event SubscriptionsActivated(address account, uint256 amount);
858 
859     /**
860     * @notice Mint Subscriptions.
861     * @dev Mint Subscriptions.
862     * @param account The receiver's account address.
863     * @param amount The number of Subscriptions.
864     */
865     function mint(address account, uint256 amount)
866         public
867         onlyMinter
868         whenNotPaused
869         onlyPositive(amount)
870         returns (bool)
871     {
872         _mint(account, amount);
873         return true;
874     }
875 
876     /**
877     * @notice Activate Subscriptions.
878     * @dev Activate Subscriptions.
879     * @param amount The number of Subscriptions.
880     */
881     function activate(uint256 amount)
882         public
883         whenNotPaused
884         onlyPositive(amount)
885         returns (bool)
886     {
887         uint256 timestamp = now;
888         accounts[msg.sender].timestamps.push(timestamp);
889         accounts[msg.sender].batches[timestamp] = amount;
890         _burn(msg.sender, amount);
891         emit SubscriptionsActivated(msg.sender, amount);
892         return true;
893     }
894 
895     /**
896     * @notice Tells the minter how many Sponsorships the account holder can claim.
897     * @dev Tells the minter how many Sponsorships the account holder can claim so it can
898     * then mint them. Also increments the account's "received" counter to indicate the
899     * number of Sponsorships that have been claimed.
900     * @param account The claimer's account address.
901     * @return The number of Sponsorships the account holder can claim.
902     */
903     function claim(address account)
904         external
905         onlyMinter
906         whenNotPaused
907         returns (uint256 amount)
908     {
909         uint256 claimableAmount = claimable(account);
910         require(0 < claimableAmount, ALL_SPONSORSHIPS_CLAIMED);
911 
912         accounts[account].received = accounts[account].received.add(claimableAmount);
913         return claimableAmount;
914     }
915 
916     /**
917     * @notice Computes the number of Sponsorships the account holder can claim.
918     * @dev Computes the number of Sponsorships the account holder can claim.
919     * @param account The claimer's account address.
920     * @return The number of Sponsorships the account holder can claim.
921     */
922     function claimable(address account)
923         public
924         view
925         returns (uint256 amount)
926     {
927         // The number of Sponsorships produced by all of this account's batches.
928         uint256 allProduced;
929 
930         // Loop through all the batches.
931         for (uint i = 0; i < accounts[account].timestamps.length; i++) {
932             uint256 timestamp = accounts[account].timestamps[i];
933             // The number of Subscriptions purchased in the batch that matches the timestamp.
934             uint256 subsInBatch = accounts[account].batches[timestamp];
935             // "months" is the number of whole 30-day periods since the batch was purchased (plus one).
936             // We add one because we want each Subscription to start with one claimable sponsorship immediately.
937             uint256 months = ((now - timestamp) / (30*24*3600)) + 1;
938             // Subscriptions end after 71 30-day periods (a little less than 6 years).
939             if (72 < months) {
940                 months = 72;
941             }
942             uint256 _years = months / 12;
943             // One Subscription produces 252 Sponsorships in total.
944             uint256 producedPerSub = 6 * _years * (_years + 1) + (months % 12) * (_years + 1);
945             allProduced += (producedPerSub * subsInBatch);
946         }
947         uint256 claimableAmount = allProduced - accounts[account].received;
948         return claimableAmount;
949     }
950 
951     /**
952     * @dev Throws if the number is not bigger than zero
953     * @param number The number to validate
954     */
955     modifier onlyPositive(uint number) {
956         require(0 < number, INVALID_AMOUNT);
957         _;
958     }
959 
960 }