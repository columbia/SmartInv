1 pragma solidity ^0.5.0;
2 
3 // openzeppelin-solidity@2.3.0 from NPM
4 
5 /**
6  * @title Roles
7  * @dev Library for managing addresses assigned to a Role.
8  */
9 library Roles {
10     struct Role {
11         mapping (address => bool) bearer;
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
40 contract OperatorRole {
41     using Roles for Roles.Role;
42 
43     event OperatorAdded(address indexed account);
44     event OperatorRemoved(address indexed account);
45 
46     Roles.Role private _operators;
47 
48     constructor () internal {
49         _addOperator(msg.sender);
50     }
51 
52     modifier onlyOperator() {
53         require(isOperator(msg.sender), "OperatorRole: caller does not have the Operator role");
54         _;
55     }
56 
57     function isOperator(address account) public view returns (bool) {
58         return _operators.has(account);
59     }
60 
61     function addOperator(address account) public onlyOperator {
62         _addOperator(account);
63     }
64 
65     function renounceOperator() public onlyOperator {
66         _removeOperator(msg.sender);
67     }
68 
69     function _addOperator(address account) internal {
70         _operators.add(account);
71         emit OperatorAdded(account);
72     }
73 
74     function _removeOperator(address account) internal {
75         _operators.remove(account);
76         emit OperatorRemoved(account);
77     }
78 }
79 
80 contract MinterRole {
81     using Roles for Roles.Role;
82 
83     event MinterAdded(address indexed account);
84     event MinterRemoved(address indexed account);
85 
86     Roles.Role private _minters;
87 
88     constructor () internal {
89         _addMinter(msg.sender);
90     }
91 
92     modifier onlyMinter() {
93         require(isMinter(msg.sender), "MinterRole: caller does not have the Minter role");
94         _;
95     }
96 
97     function isMinter(address account) public view returns (bool) {
98         return _minters.has(account);
99     }
100 
101     function addMinter(address account) public onlyMinter {
102         _addMinter(account);
103     }
104 
105     function renounceMinter() public {
106         _removeMinter(msg.sender);
107     }
108 
109     function _addMinter(address account) internal {
110         _minters.add(account);
111         emit MinterAdded(account);
112     }
113 
114     function _removeMinter(address account) internal {
115         _minters.remove(account);
116         emit MinterRemoved(account);
117     }
118 }
119 
120 contract CreatorRole {
121     using Roles for Roles.Role;
122 
123     event CreatorAdded(address indexed account);
124     event CreatorRemoved(address indexed account);
125 
126     Roles.Role private _creators;
127 
128     constructor () internal {
129         _addCreator(msg.sender);
130     }
131 
132     modifier onlyCreator() {
133         require(isCreator(msg.sender), "CreatorRole: caller does not have the Creator role");
134         _;
135     }
136 
137     function isCreator(address account) public view returns (bool) {
138         return _creators.has(account);
139     }
140 
141     function _addCreator(address account) internal {
142         _creators.add(account);
143         emit CreatorAdded(account);
144     }
145 
146     function _removeCreator(address account) internal {
147         _creators.remove(account);
148         emit CreatorRemoved(account);
149     }
150 }
151 
152 contract PauserRole {
153     using Roles for Roles.Role;
154 
155     event PauserAdded(address indexed account);
156     event PauserRemoved(address indexed account);
157 
158     Roles.Role private _pausers;
159 
160     constructor () internal {
161         _addPauser(msg.sender);
162     }
163 
164     modifier onlyPauser() {
165         require(isPauser(msg.sender), "PauserRole: caller does not have the Pauser role");
166         _;
167     }
168 
169     function isPauser(address account) public view returns (bool) {
170         return _pausers.has(account);
171     }
172 
173     function addPauser(address account) public onlyPauser {
174         _addPauser(account);
175     }
176 
177     function renouncePauser() public {
178         _removePauser(msg.sender);
179     }
180 
181     function _addPauser(address account) internal {
182         _pausers.add(account);
183         emit PauserAdded(account);
184     }
185 
186     function _removePauser(address account) internal {
187         _pausers.remove(account);
188         emit PauserRemoved(account);
189     }
190 }
191 
192 /**
193  * @dev Contract module which allows children to implement an emergency stop
194  * mechanism that can be triggered by an authorized account.
195  *
196  * This module is used through inheritance. It will make available the
197  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
198  * the functions of your contract. Note that they will not be pausable by
199  * simply including this module, only once the modifiers are put in place.
200  */
201 contract Pausable is PauserRole {
202     /**
203      * @dev Emitted when the pause is triggered by a pauser (`account`).
204      */
205     event Paused(address account);
206 
207     /**
208      * @dev Emitted when the pause is lifted by a pauser (`account`).
209      */
210     event Unpaused(address account);
211 
212     bool private _paused;
213 
214     /**
215      * @dev Initializes the contract in unpaused state. Assigns the Pauser role
216      * to the deployer.
217      */
218     constructor () internal {
219         _paused = false;
220     }
221 
222     /**
223      * @dev Returns true if the contract is paused, and false otherwise.
224      */
225     function paused() public view returns (bool) {
226         return _paused;
227     }
228 
229     /**
230      * @dev Modifier to make a function callable only when the contract is not paused.
231      */
232     modifier whenNotPaused() {
233         require(!_paused, "Pausable: paused");
234         _;
235     }
236 
237     /**
238      * @dev Modifier to make a function callable only when the contract is paused.
239      */
240     modifier whenPaused() {
241         require(_paused, "Pausable: not paused");
242         _;
243     }
244 
245     /**
246      * @dev Called by a pauser to pause, triggers stopped state.
247      */
248     function pause() public onlyPauser whenNotPaused {
249         _paused = true;
250         emit Paused(msg.sender);
251     }
252 
253     /**
254      * @dev Called by a pauser to unpause, returns to normal state.
255      */
256     function unpause() public onlyPauser whenPaused {
257         _paused = false;
258         emit Unpaused(msg.sender);
259     }
260 }
261 
262 contract BurnerRole {
263     using Roles for Roles.Role;
264 
265     event BurnerAdded(address indexed account);
266     event BurnerRemoved(address indexed account);
267 
268     Roles.Role private _burners;
269 
270     constructor () internal {
271         _addBurner(msg.sender);
272     }
273 
274     modifier onlyBurner() {
275         require(isBurner(msg.sender), "BurnerRole: caller does not have the Burner role");
276         _;
277     }
278 
279     function isBurner(address account) public view returns (bool) {
280         return _burners.has(account);
281     }
282 
283     function addBurner(address account) public onlyBurner {
284         _addBurner(account);
285     }
286 
287     function renounceBurner() public onlyBurner {
288         _removeBurner(msg.sender);
289     }
290 
291     function _addBurner(address account) internal {
292         _burners.add(account);
293         emit BurnerAdded(account);
294     }
295 
296     function _removeBurner(address account) internal {
297         _burners.remove(account);
298         emit BurnerRemoved(account);
299     }
300 }
301 
302 /**
303  * @dev Wrappers over Solidity's arithmetic operations with added overflow
304  * checks.
305  *
306  * Arithmetic operations in Solidity wrap on overflow. This can easily result
307  * in bugs, because programmers usually assume that an overflow raises an
308  * error, which is the standard behavior in high level programming languages.
309  * `SafeMath` restores this intuition by reverting the transaction when an
310  * operation overflows.
311  *
312  * Using this library instead of the unchecked operations eliminates an entire
313  * class of bugs, so it's recommended to use it always.
314  */
315 library SafeMath {
316     /**
317      * @dev Returns the addition of two unsigned integers, reverting on
318      * overflow.
319      *
320      * Counterpart to Solidity's `+` operator.
321      *
322      * Requirements:
323      * - Addition cannot overflow.
324      */
325     function add(uint256 a, uint256 b) internal pure returns (uint256) {
326         uint256 c = a + b;
327         require(c >= a, "SafeMath: addition overflow");
328 
329         return c;
330     }
331 
332     /**
333      * @dev Returns the subtraction of two unsigned integers, reverting on
334      * overflow (when the result is negative).
335      *
336      * Counterpart to Solidity's `-` operator.
337      *
338      * Requirements:
339      * - Subtraction cannot overflow.
340      */
341     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
342         require(b <= a, "SafeMath: subtraction overflow");
343         uint256 c = a - b;
344 
345         return c;
346     }
347 
348     /**
349      * @dev Returns the multiplication of two unsigned integers, reverting on
350      * overflow.
351      *
352      * Counterpart to Solidity's `*` operator.
353      *
354      * Requirements:
355      * - Multiplication cannot overflow.
356      */
357     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
358         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
359         // benefit is lost if 'b' is also tested.
360         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
361         if (a == 0) {
362             return 0;
363         }
364 
365         uint256 c = a * b;
366         require(c / a == b, "SafeMath: multiplication overflow");
367 
368         return c;
369     }
370 
371     /**
372      * @dev Returns the integer division of two unsigned integers. Reverts on
373      * division by zero. The result is rounded towards zero.
374      *
375      * Counterpart to Solidity's `/` operator. Note: this function uses a
376      * `revert` opcode (which leaves remaining gas untouched) while Solidity
377      * uses an invalid opcode to revert (consuming all remaining gas).
378      *
379      * Requirements:
380      * - The divisor cannot be zero.
381      */
382     function div(uint256 a, uint256 b) internal pure returns (uint256) {
383         // Solidity only automatically asserts when dividing by 0
384         require(b > 0, "SafeMath: division by zero");
385         uint256 c = a / b;
386         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
387 
388         return c;
389     }
390 
391     /**
392      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
393      * Reverts when dividing by zero.
394      *
395      * Counterpart to Solidity's `%` operator. This function uses a `revert`
396      * opcode (which leaves remaining gas untouched) while Solidity uses an
397      * invalid opcode to revert (consuming all remaining gas).
398      *
399      * Requirements:
400      * - The divisor cannot be zero.
401      */
402     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
403         require(b != 0, "SafeMath: modulo by zero");
404         return a % b;
405     }
406 }
407 
408 /**
409  * @dev Contract module which provides a basic access control mechanism, where
410  * there is an account (an owner) that can be granted exclusive access to
411  * specific functions.
412  *
413  * This module is used through inheritance. It will make available the modifier
414  * `onlyOwner`, which can be aplied to your functions to restrict their use to
415  * the owner.
416  */
417 contract Ownable {
418     address private _owner;
419 
420     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
421 
422     /**
423      * @dev Initializes the contract setting the deployer as the initial owner.
424      */
425     constructor () internal {
426         _owner = msg.sender;
427         emit OwnershipTransferred(address(0), _owner);
428     }
429 
430     /**
431      * @dev Returns the address of the current owner.
432      */
433     function owner() public view returns (address) {
434         return _owner;
435     }
436 
437     /**
438      * @dev Throws if called by any account other than the owner.
439      */
440     modifier onlyOwner() {
441         require(isOwner(), "Ownable: caller is not the owner");
442         _;
443     }
444 
445     /**
446      * @dev Returns true if the caller is the current owner.
447      */
448     function isOwner() public view returns (bool) {
449         return msg.sender == _owner;
450     }
451 
452     /**
453      * @dev Leaves the contract without owner. It will not be possible to call
454      * `onlyOwner` functions anymore. Can only be called by the current owner.
455      *
456      * > Note: Renouncing ownership will leave the contract without an owner,
457      * thereby removing any functionality that is only available to the owner.
458      */
459     function renounceOwnership() public onlyOwner {
460         emit OwnershipTransferred(_owner, address(0));
461         _owner = address(0);
462     }
463 
464     /**
465      * @dev Transfers ownership of the contract to a new account (`newOwner`).
466      * Can only be called by the current owner.
467      */
468     function transferOwnership(address newOwner) public onlyOwner {
469         _transferOwnership(newOwner);
470     }
471 
472     /**
473      * @dev Transfers ownership of the contract to a new account (`newOwner`).
474      */
475     function _transferOwnership(address newOwner) internal {
476         require(newOwner != address(0), "Ownable: new owner is the zero address");
477         emit OwnershipTransferred(_owner, newOwner);
478         _owner = newOwner;
479     }
480 }
481 
482 contract TokenAccessList is Ownable {
483 
484     string public identifier;
485     mapping(address => bool) private accessList;
486 
487     event WalletEnabled(address indexed wallet);
488     event WalletDisabled(address indexed wallet);
489 
490     constructor(string memory _identifier) public {
491         identifier = _identifier;
492     }
493 
494     function enableWallet(address _wallet)
495         public
496         onlyOwner
497         {
498             require(_wallet != address(0), "Invalid wallet");
499             accessList[_wallet] = true;
500             emit WalletEnabled(_wallet);
501     }
502 
503     function disableWallet(address _wallet)
504         public
505         onlyOwner
506         {
507             accessList[_wallet] = false;
508             emit WalletDisabled(_wallet);
509     }
510 
511     function enableWalletList(address[] calldata _walletList)
512         external
513         onlyOwner {
514             for(uint i = 0; i < _walletList.length; i++) {
515                 enableWallet(_walletList[i]);
516             }
517     }
518 
519     function disableWalletList(address[] calldata _walletList)
520         external
521         onlyOwner {
522             for(uint i = 0; i < _walletList.length; i++) {
523                 disableWallet(_walletList[i]);
524             }
525     }
526 
527     function checkEnabled(address _wallet)
528         public
529         view
530         returns (bool) {
531             return _wallet == address(0) || accessList[_wallet];
532     }
533 
534     function checkEnabledList(address _w1, address _w2, address _w3)
535         external
536         view
537         returns (bool) {
538             return checkEnabled(_w1)
539                 && checkEnabled(_w2)
540                 && checkEnabled(_w3);
541     }
542 
543 }
544 
545 /**
546  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
547  * the optional functions; to access them see `ERC20Detailed`.
548  */
549 interface IERC20 {
550     /**
551      * @dev Returns the amount of tokens in existence.
552      */
553     function totalSupply() external view returns (uint256);
554 
555     /**
556      * @dev Returns the amount of tokens owned by `account`.
557      */
558     function balanceOf(address account) external view returns (uint256);
559 
560     /**
561      * @dev Moves `amount` tokens from the caller's account to `recipient`.
562      *
563      * Returns a boolean value indicating whether the operation succeeded.
564      *
565      * Emits a `Transfer` event.
566      */
567     function transfer(address recipient, uint256 amount) external returns (bool);
568 
569     /**
570      * @dev Returns the remaining number of tokens that `spender` will be
571      * allowed to spend on behalf of `owner` through `transferFrom`. This is
572      * zero by default.
573      *
574      * This value changes when `approve` or `transferFrom` are called.
575      */
576     function allowance(address owner, address spender) external view returns (uint256);
577 
578     /**
579      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
580      *
581      * Returns a boolean value indicating whether the operation succeeded.
582      *
583      * > Beware that changing an allowance with this method brings the risk
584      * that someone may use both the old and the new allowance by unfortunate
585      * transaction ordering. One possible solution to mitigate this race
586      * condition is to first reduce the spender's allowance to 0 and set the
587      * desired value afterwards:
588      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
589      *
590      * Emits an `Approval` event.
591      */
592     function approve(address spender, uint256 amount) external returns (bool);
593 
594     /**
595      * @dev Moves `amount` tokens from `sender` to `recipient` using the
596      * allowance mechanism. `amount` is then deducted from the caller's
597      * allowance.
598      *
599      * Returns a boolean value indicating whether the operation succeeded.
600      *
601      * Emits a `Transfer` event.
602      */
603     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
604 
605     /**
606      * @dev Emitted when `value` tokens are moved from one account (`from`) to
607      * another (`to`).
608      *
609      * Note that `value` may be zero.
610      */
611     event Transfer(address indexed from, address indexed to, uint256 value);
612 
613     /**
614      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
615      * a call to `approve`. `value` is the new allowance.
616      */
617     event Approval(address indexed owner, address indexed spender, uint256 value);
618 }
619 
620 /**
621  * @dev Implementation of the `IERC20` interface.
622  *
623  * This implementation is agnostic to the way tokens are created. This means
624  * that a supply mechanism has to be added in a derived contract using `_mint`.
625  * For a generic mechanism see `ERC20Mintable`.
626  *
627  * *For a detailed writeup see our guide [How to implement supply
628  * mechanisms](https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226).*
629  *
630  * We have followed general OpenZeppelin guidelines: functions revert instead
631  * of returning `false` on failure. This behavior is nonetheless conventional
632  * and does not conflict with the expectations of ERC20 applications.
633  *
634  * Additionally, an `Approval` event is emitted on calls to `transferFrom`.
635  * This allows applications to reconstruct the allowance for all accounts just
636  * by listening to said events. Other implementations of the EIP may not emit
637  * these events, as it isn't required by the specification.
638  *
639  * Finally, the non-standard `decreaseAllowance` and `increaseAllowance`
640  * functions have been added to mitigate the well-known issues around setting
641  * allowances. See `IERC20.approve`.
642  */
643 contract ERC20 is IERC20 {
644     using SafeMath for uint256;
645 
646     mapping (address => uint256) private _balances;
647 
648     mapping (address => mapping (address => uint256)) private _allowances;
649 
650     uint256 private _totalSupply;
651 
652     /**
653      * @dev See `IERC20.totalSupply`.
654      */
655     function totalSupply() public view returns (uint256) {
656         return _totalSupply;
657     }
658 
659     /**
660      * @dev See `IERC20.balanceOf`.
661      */
662     function balanceOf(address account) public view returns (uint256) {
663         return _balances[account];
664     }
665 
666     /**
667      * @dev See `IERC20.transfer`.
668      *
669      * Requirements:
670      *
671      * - `recipient` cannot be the zero address.
672      * - the caller must have a balance of at least `amount`.
673      */
674     function transfer(address recipient, uint256 amount) public returns (bool) {
675         _transfer(msg.sender, recipient, amount);
676         return true;
677     }
678 
679     /**
680      * @dev See `IERC20.allowance`.
681      */
682     function allowance(address owner, address spender) public view returns (uint256) {
683         return _allowances[owner][spender];
684     }
685 
686     /**
687      * @dev See `IERC20.approve`.
688      *
689      * Requirements:
690      *
691      * - `spender` cannot be the zero address.
692      */
693     function approve(address spender, uint256 value) public returns (bool) {
694         _approve(msg.sender, spender, value);
695         return true;
696     }
697 
698     /**
699      * @dev See `IERC20.transferFrom`.
700      *
701      * Emits an `Approval` event indicating the updated allowance. This is not
702      * required by the EIP. See the note at the beginning of `ERC20`;
703      *
704      * Requirements:
705      * - `sender` and `recipient` cannot be the zero address.
706      * - `sender` must have a balance of at least `value`.
707      * - the caller must have allowance for `sender`'s tokens of at least
708      * `amount`.
709      */
710     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
711         _transfer(sender, recipient, amount);
712         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
713         return true;
714     }
715 
716     /**
717      * @dev Atomically increases the allowance granted to `spender` by the caller.
718      *
719      * This is an alternative to `approve` that can be used as a mitigation for
720      * problems described in `IERC20.approve`.
721      *
722      * Emits an `Approval` event indicating the updated allowance.
723      *
724      * Requirements:
725      *
726      * - `spender` cannot be the zero address.
727      */
728     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
729         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
730         return true;
731     }
732 
733     /**
734      * @dev Atomically decreases the allowance granted to `spender` by the caller.
735      *
736      * This is an alternative to `approve` that can be used as a mitigation for
737      * problems described in `IERC20.approve`.
738      *
739      * Emits an `Approval` event indicating the updated allowance.
740      *
741      * Requirements:
742      *
743      * - `spender` cannot be the zero address.
744      * - `spender` must have allowance for the caller of at least
745      * `subtractedValue`.
746      */
747     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
748         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
749         return true;
750     }
751 
752     /**
753      * @dev Moves tokens `amount` from `sender` to `recipient`.
754      *
755      * This is internal function is equivalent to `transfer`, and can be used to
756      * e.g. implement automatic token fees, slashing mechanisms, etc.
757      *
758      * Emits a `Transfer` event.
759      *
760      * Requirements:
761      *
762      * - `sender` cannot be the zero address.
763      * - `recipient` cannot be the zero address.
764      * - `sender` must have a balance of at least `amount`.
765      */
766     function _transfer(address sender, address recipient, uint256 amount) internal {
767         require(sender != address(0), "ERC20: transfer from the zero address");
768         require(recipient != address(0), "ERC20: transfer to the zero address");
769 
770         _balances[sender] = _balances[sender].sub(amount);
771         _balances[recipient] = _balances[recipient].add(amount);
772         emit Transfer(sender, recipient, amount);
773     }
774 
775     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
776      * the total supply.
777      *
778      * Emits a `Transfer` event with `from` set to the zero address.
779      *
780      * Requirements
781      *
782      * - `to` cannot be the zero address.
783      */
784     function _mint(address account, uint256 amount) internal {
785         require(account != address(0), "ERC20: mint to the zero address");
786 
787         _totalSupply = _totalSupply.add(amount);
788         _balances[account] = _balances[account].add(amount);
789         emit Transfer(address(0), account, amount);
790     }
791 
792      /**
793      * @dev Destoys `amount` tokens from `account`, reducing the
794      * total supply.
795      *
796      * Emits a `Transfer` event with `to` set to the zero address.
797      *
798      * Requirements
799      *
800      * - `account` cannot be the zero address.
801      * - `account` must have at least `amount` tokens.
802      */
803     function _burn(address account, uint256 value) internal {
804         require(account != address(0), "ERC20: burn from the zero address");
805 
806         _totalSupply = _totalSupply.sub(value);
807         _balances[account] = _balances[account].sub(value);
808         emit Transfer(account, address(0), value);
809     }
810 
811     /**
812      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
813      *
814      * This is internal function is equivalent to `approve`, and can be used to
815      * e.g. set automatic allowances for certain subsystems, etc.
816      *
817      * Emits an `Approval` event.
818      *
819      * Requirements:
820      *
821      * - `owner` cannot be the zero address.
822      * - `spender` cannot be the zero address.
823      */
824     function _approve(address owner, address spender, uint256 value) internal {
825         require(owner != address(0), "ERC20: approve from the zero address");
826         require(spender != address(0), "ERC20: approve to the zero address");
827 
828         _allowances[owner][spender] = value;
829         emit Approval(owner, spender, value);
830     }
831 
832     /**
833      * @dev Destoys `amount` tokens from `account`.`amount` is then deducted
834      * from the caller's allowance.
835      *
836      * See `_burn` and `_approve`.
837      */
838     function _burnFrom(address account, uint256 amount) internal {
839         _burn(account, amount);
840         _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount));
841     }
842 }
843 
844 /**
845  * @dev Extension of `ERC20` allows a centralized owner to burn users' tokens
846  *
847  * At construction time, the deployer of the contract is the only burner.
848  */
849 contract ERC20Operator is ERC20, OperatorRole {
850 
851     event ForcedTransfer(address requester, address from, address to, uint256 value);
852 
853     /**
854      * @dev new function to burn tokens from a centralized owner
855      * @param _from address The address which the operator wants to send tokens from
856      * @param _to address The address which the operator wants to transfer to
857      * @param _value uint256 the amount of tokens to be transferred
858      * @return A boolean that indicates if the operation was successful.
859      */
860     function forcedTransfer(address _from, address _to, uint256 _value)
861         public
862         onlyOperator
863         returns (bool) {
864             _transfer(_from, _to, _value);
865             emit ForcedTransfer(msg.sender, _from, _to, _value);
866             return true;
867     }
868 }
869 
870 /**
871  * @dev Extension of `ERC20` that adds a set of accounts with the `MinterRole`,
872  * which have permission to mint (create) new tokens as they see fit.
873  *
874  * At construction, the deployer of the contract is the only minter.
875  */
876 contract ERC20Mintable is ERC20, MinterRole {
877     /**
878      * @dev See `ERC20._mint`.
879      *
880      * Requirements:
881      *
882      * - the caller must have the `MinterRole`.
883      */
884     function mint(address account, uint256 amount) public onlyMinter returns (bool) {
885         _mint(account, amount);
886         return true;
887     }
888 }
889 
890 /**
891  * @dev Modification of OpenZeppelin's ERC20Capped. Implements a mechanism
892  * to enable and disable cap control, as well as cap modification.
893  */
894 contract ERC20CapEnabler is ERC20Mintable, CreatorRole {
895 
896     uint256 public cap;
897     bool public capEnabled;
898 
899     event CapEnabled(address sender);
900     event CapDisabled(address sender);
901     event CapSet(address sender, uint256 amount);
902 
903     /**
904      * @dev Enable cap control on minting.
905      */
906     function enableCap()
907         external
908         onlyCreator {
909             capEnabled = true;
910             emit CapEnabled(msg.sender);
911     }
912 
913     /**
914      * @dev Disable cap control on minting and set cap back to 0.
915      */
916     function disableCap()
917         external
918         onlyCreator {
919             capEnabled = false;
920             // set cap to 0
921             cap = 0;
922             emit CapDisabled(msg.sender);
923     }
924 
925     /**
926      * @dev Set a new cap.
927      */
928     function setCap(uint256 _newCap)
929         external
930         onlyCreator {
931             cap = _newCap;
932             emit CapSet(msg.sender, _newCap);
933     }
934 
935     /**
936      * @dev Overrides mint by checking whether cap control is enabled and
937      * reverting if the token addition to supply will exceed the cap.
938      */
939     function mint(address account, uint256 value)
940         public
941         onlyMinter
942         returns (bool) {
943             if (capEnabled) require(totalSupply().add(value) <= cap, "ERC20CapEnabler: cap exceeded");
944             return super.mint(account, value);
945     }
946 
947 }
948 
949 /**
950  * @title Pausable token
951  * @dev ERC20 modified with pausable transfers.
952  */
953 contract ERC20Pausable is ERC20, Pausable {
954     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
955         return super.transfer(to, value);
956     }
957 
958     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
959         return super.transferFrom(from, to, value);
960     }
961 
962     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
963         return super.approve(spender, value);
964     }
965 
966     function increaseAllowance(address spender, uint addedValue) public whenNotPaused returns (bool) {
967         return super.increaseAllowance(spender, addedValue);
968     }
969 
970     function decreaseAllowance(address spender, uint subtractedValue) public whenNotPaused returns (bool) {
971         return super.decreaseAllowance(spender, subtractedValue);
972     }
973 }
974 
975 /**
976  * ERC20 implementation that optionally allows the setup of a access list,
977  * which may or may not be required by regulators. If a access list is
978  * configured, then the contract starts validating parties.
979  * Only the token creator, represented by the CreatorRole, is allowed
980  * to add and remove the access list
981  */
982 contract ERC20AccessList is ERC20Pausable, ERC20CapEnabler, ERC20Operator {
983 
984     TokenAccessList public accessList;
985     bool public checkingAccessList;
986     address constant private EMPTY_ADDRESS = address(0);
987 
988     /**
989      * Admin events
990      */
991 
992     event AccessListSet(address accessList);
993     event AccessListUnset();
994 
995     modifier hasAccess(address _w1, address _w2, address _w3) {
996         if (checkingAccessList) {
997             require(accessList.checkEnabledList(_w1, _w2, _w3), "AccessList: address not authorized");
998         }
999         _;
1000     }
1001 
1002     /**
1003     * Admin functions
1004     */
1005 
1006     /**
1007     * @dev Sets up the centralized accessList contract
1008     * @param _accessList the address of accessList contract.
1009     * @return A boolean that indicates if the operation was successful.
1010     */
1011     function setupAccessList(address _accessList)
1012         public
1013         onlyCreator {
1014             require(_accessList != address(0), "Invalid access list address");
1015             accessList = TokenAccessList(_accessList);
1016             checkingAccessList = true;
1017             emit AccessListSet(_accessList);
1018     }
1019 
1020     /**
1021     * @dev Removes the accessList
1022     * @return A boolean that indicates if the operation was successful.
1023     */
1024     function removeAccessList()
1025         public
1026         onlyCreator {
1027             checkingAccessList = false;
1028             accessList = TokenAccessList(0x0);
1029             emit AccessListUnset();
1030     }
1031 
1032     /**
1033     * @dev Overrides MintableToken mint() adding the accessList validation
1034     * @param _to The address that will receive the minted tokens.
1035     * @param _amount The amount of tokens to mint.
1036     * @return A boolean that indicates if the operation was successful.
1037     */
1038     function mint(address _to, uint256 _amount)
1039         public
1040         onlyMinter
1041         hasAccess(_to, EMPTY_ADDRESS, EMPTY_ADDRESS)
1042         returns (bool) {
1043             return super.mint(_to, _amount);
1044     }
1045 
1046     /**
1047     * User functions
1048     */
1049 
1050     /**
1051     * @dev Overrides BasicToken transfer() adding the accessList validation
1052     * @param _to The address to transfer to.
1053     * @param _value The amount to be transferred.
1054     * @return A boolean that indicates if the operation was successful.
1055     */
1056     function transfer(address _to, uint256 _value)
1057         public
1058         whenNotPaused
1059         hasAccess(msg.sender, _to, EMPTY_ADDRESS)
1060         returns (bool) {
1061             return super.transfer(_to, _value);
1062     }
1063 
1064     /**
1065     * @dev Overrides BasicToken transfer() adding the accessList validation
1066     * @param _to The address to transfer from.
1067     * @param _to The address to transfer to.
1068     * @param _value The amount to be transferred.
1069     * @return A boolean that indicates if the operation was successful.
1070     */
1071     function forcedTransfer(address _from, address _to, uint256 _value)
1072         public
1073         whenNotPaused
1074         hasAccess(_from, _to, EMPTY_ADDRESS)
1075         returns (bool) {
1076             return super.forcedTransfer(_from, _to, _value);
1077     }
1078 
1079     /**
1080      * @dev Overrides StandardToken transferFrom() adding the accessList validation
1081      * @param _from address The address which you want to send tokens from
1082      * @param _to address The address which you want to transfer to
1083      * @param _value uint256 the amount of tokens to be transferred
1084      */
1085     function transferFrom(address _from, address _to, uint256 _value)
1086         public
1087         whenNotPaused
1088         hasAccess(msg.sender, _from, _to)
1089         returns (bool) {
1090             return super.transferFrom(_from, _to, _value);
1091     }
1092 
1093     /**
1094      * @dev Overrides StandardToken approve() adding the accessList validation
1095      * @param _spender The address which will spend the funds.
1096      * @param _value The amount of tokens to be spent.
1097      * @return A boolean that indicates if the operation was successful.
1098      */
1099     function approve(address _spender, uint256 _value)
1100         public
1101         whenNotPaused
1102         hasAccess(msg.sender, _spender, EMPTY_ADDRESS)
1103         returns (bool) {
1104             return super.approve(_spender, _value);
1105     }
1106 
1107     /**
1108      * @dev Overrides StandardToken increaseApproval() adding the accessList validation
1109      * @param _spender The address which will spend the funds.
1110      * @param _addedValue The amount of tokens to increase the allowance by.
1111      * @return A boolean that indicates if the operation was successful.
1112      */
1113     function increaseAllowance(address _spender, uint _addedValue)
1114         public
1115         whenNotPaused
1116         hasAccess(msg.sender, _spender, EMPTY_ADDRESS)
1117         returns (bool) {
1118             return super.increaseAllowance(_spender, _addedValue);
1119     }
1120 
1121     /**
1122      * @dev Overrides StandardToken decreaseApproval() adding the accessList validation
1123      * @param _spender The address which will spend the funds.
1124      * @param _subtractedValue The amount of tokens to decrease the allowance by.
1125      * @return A boolean that indicates if the operation was successful.
1126      */
1127     function decreaseAllowance(address _spender, uint _subtractedValue)
1128         public
1129         whenNotPaused
1130         hasAccess(msg.sender, _spender, EMPTY_ADDRESS)
1131         returns (bool) {
1132             return super.decreaseAllowance(_spender, _subtractedValue);
1133     }
1134 
1135 }
1136 
1137 /**
1138  * @dev Extension of `ERC20` allows a centralized owner to burn users' tokens
1139  *
1140  * At construction time, the deployer of the contract is the only burner.
1141  */
1142 contract ERC20BurnableAdmin is ERC20, BurnerRole {
1143 
1144     event ForcedBurn(address requester, address wallet, uint256 value);
1145 
1146     /**
1147      * @dev new function to burn tokens from a centralized owner
1148      * @param _who The address which will be burned.
1149      * @param _value The amount of tokens to burn.
1150      * @return A boolean that indicates if the operation was successful.
1151      */
1152     function forcedBurn(address _who, uint256 _value)
1153         public
1154         onlyBurner
1155         returns (bool) {
1156             _burn(_who, _value);
1157             emit ForcedBurn(msg.sender, _who, _value);
1158             return true;
1159     }
1160 }
1161 
1162 /**
1163  * @dev Optional functions from the ERC20 standard.
1164  */
1165 contract ERC20Detailed is IERC20 {
1166     string private _name;
1167     string private _symbol;
1168     uint8 private _decimals;
1169 
1170     /**
1171      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
1172      * these values are immutable: they can only be set once during
1173      * construction.
1174      */
1175     constructor (string memory name, string memory symbol, uint8 decimals) public {
1176         _name = name;
1177         _symbol = symbol;
1178         _decimals = decimals;
1179     }
1180 
1181     /**
1182      * @dev Returns the name of the token.
1183      */
1184     function name() public view returns (string memory) {
1185         return _name;
1186     }
1187 
1188     /**
1189      * @dev Returns the symbol of the token, usually a shorter version of the
1190      * name.
1191      */
1192     function symbol() public view returns (string memory) {
1193         return _symbol;
1194     }
1195 
1196     /**
1197      * @dev Returns the number of decimals used to get its user representation.
1198      * For example, if `decimals` equals `2`, a balance of `505` tokens should
1199      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
1200      *
1201      * Tokens usually opt for a value of 18, imitating the relationship between
1202      * Ether and Wei.
1203      *
1204      * > Note that this information is only used for _display_ purposes: it in
1205      * no way affects any of the arithmetic of the contract, including
1206      * `IERC20.balanceOf` and `IERC20.transfer`.
1207      */
1208     function decimals() public view returns (uint8) {
1209         return _decimals;
1210     }
1211 }
1212 
1213 /**
1214  * This implementation adds a control layer over the ERC20. There are four roles
1215  * (creator, pauser, minter and burner) and the token ownership. Token creator
1216  * has powers to add and remove pausers, minters and burners. Creator role is assigned
1217  * in the constructor and can only be reassigned by the owner.
1218  * The owner has the power to claim roles, as an emergency stop mechanism.
1219  */
1220 
1221 contract ControlledToken is Ownable, ERC20Detailed, ERC20BurnableAdmin, ERC20AccessList {
1222 
1223     string public info;
1224 
1225     constructor(string memory _name, string memory _symbol, uint8 _decimals, string memory _info, address _creator)
1226         public
1227         ERC20Detailed(_name, _symbol, _decimals) {
1228             info = _info;
1229             // adds all roles to creator
1230             _addCreator(_creator);
1231             _addPauser(_creator);
1232             _addMinter(_creator);
1233             _addBurner(_creator);
1234             _addOperator(_creator);
1235             // remove all roles from token factory
1236             _removeCreator(msg.sender);
1237             _removePauser(msg.sender);
1238             _removeMinter(msg.sender);
1239             _removeBurner(msg.sender);
1240             _removeOperator(msg.sender);
1241         }
1242 
1243     /**
1244     * Platform owner functions
1245     */
1246 
1247     /**
1248      * @dev claims creator role from an address.
1249      * @param _address The address will be removed.
1250      */
1251     function claimCreator(address _address)
1252         public
1253         onlyOwner {
1254             _removeCreator(_address);
1255             _addCreator(msg.sender);
1256     }
1257 
1258     /**
1259      * @dev claims operator role from an address.
1260      * @param _address The address will be removed.
1261      */
1262     function claimOperator(address _address)
1263         public
1264         onlyOwner {
1265             _removeOperator(_address);
1266             _addOperator(msg.sender);
1267     }
1268 
1269     /**
1270      * @dev claims minter role from an address.
1271      * @param _address The address will be removed.
1272      */
1273     function claimMinter(address _address)
1274         public
1275         onlyOwner {
1276             _removeMinter(_address);
1277             _addMinter(msg.sender);
1278     }
1279 
1280     /**
1281      * @dev claims burner role from an address.
1282      * @param _address The address will be removed.
1283      */
1284     function claimBurner(address _address)
1285         public
1286         onlyOwner {
1287             _removeBurner(_address);
1288             _addBurner(msg.sender);
1289     }
1290 
1291     /**
1292      * @dev claims pauser role from an address.
1293      * @param _address The address will be removed.
1294      */
1295     function claimPauser(address _address)
1296         public
1297         onlyOwner {
1298             _removePauser(_address);
1299             _addPauser(msg.sender);
1300     }
1301 
1302     /**
1303      * @dev adds new creator.
1304      * @param _address The address will be removed.
1305      */
1306     function addCreator(address _address)
1307         public
1308         onlyOwner {
1309             _addCreator(_address);
1310     }
1311 
1312     /**
1313      * @dev renounces to creator role
1314      */
1315     function renounceCreator()
1316         public
1317         onlyOwner {
1318             _removeCreator(msg.sender);
1319     }
1320 
1321     /**
1322     * Creator functions
1323     */
1324 
1325     /**
1326      * @dev adds minter role to and address.
1327      * @param _address The address will be added.
1328      * Needed in case the last minter renounces the role
1329      */
1330     function adminAddMinter(address _address)
1331         public
1332         onlyCreator {
1333             _addMinter(_address);
1334     }
1335 
1336     /**
1337      * @dev removes minter role from an address.
1338      * @param _address The address will be removed.
1339      */
1340     function removeMinter(address _address)
1341         public
1342         onlyCreator {
1343             _removeMinter(_address);
1344     }
1345 
1346     /**
1347      * @dev adds pauser role to and address.
1348      * @param _address The address will be added.
1349      * Needed in case the last pauser renounces the role
1350      */
1351     function adminAddPauser(address _address)
1352         public
1353         onlyCreator {
1354             _addPauser(_address);
1355     }
1356 
1357     /**
1358      * @dev removes pauser role from an address.
1359      * @param _address The address will be removed.
1360      */
1361     function removePauser(address _address)
1362         public
1363         onlyCreator {
1364             _removePauser(_address);
1365     }
1366 
1367     /**
1368      * @dev adds pauser role to and address.
1369      * @param _address The address will be added.
1370      * Needed in case the last pauser renounces the role
1371      */
1372     function adminAddOperator(address _address)
1373         public
1374         onlyCreator {
1375             _addOperator(_address);
1376     }
1377 
1378     /**
1379      * @dev removes operator role from an address.
1380      * @param _address The address will be removed.
1381      */
1382     function removeOperator(address _address)
1383         public
1384         onlyCreator {
1385             _removeOperator(_address);
1386     }
1387 
1388     /**
1389      * @dev adds burner role to and address.
1390      * @param _address The address will be added.
1391      * Needed in case the last burner renounces the role
1392      */
1393     function adminAddBurner(address _address)
1394         public
1395         onlyCreator {
1396             _addBurner(_address);
1397     }
1398 
1399     /**
1400      * @dev removes burner role fom an address.
1401      * @param _address The address will be removed.
1402      */
1403     function removeBurner(address _address)
1404         public
1405         onlyCreator {
1406             _removeBurner(_address);
1407     }
1408 
1409 }