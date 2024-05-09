1 // File: openzeppelin-solidity/contracts/access/Roles.sol
2 pragma solidity 0.5.4;
3 
4 /**
5  * @title Roles
6  * @dev Library for managing addresses assigned to a Role.
7  */
8 library Roles {
9     struct Role {
10         mapping (address => bool) bearer;
11     }
12 
13     /**
14      * @dev Give an account access to this role.
15      */
16     function add(Role storage role, address account) internal {
17         require(!has(role, account), "Roles: account already has role");
18         role.bearer[account] = true;
19     }
20 
21     /**
22      * @dev Remove an account's access to this role.
23      */
24     function remove(Role storage role, address account) internal {
25         require(has(role, account), "Roles: account does not have role");
26         role.bearer[account] = false;
27     }
28 
29     /**
30      * @dev Check if an account has this role.
31      * @return bool
32      */
33     function has(Role storage role, address account) internal view returns (bool) {
34         require(account != address(0), "Roles: account is the zero address");
35         return role.bearer[account];
36     }
37 }
38 
39 // File: contracts/roles/BurnerRole.sol
40 /**
41  * @title Burner Role
42  * @dev Follows the openzeppelin's guidelines of working with roles.
43  * @dev Derived contracts must implement the `addBurner` and the `removeBurner` functions.
44  */
45 contract BurnerRole {
46 
47     using Roles for Roles.Role;
48 
49     Roles.Role private _burners;
50 
51     /**
52      * @notice Fired when a new role is added.
53      */
54     event BurnerAdded(address indexed account);
55 
56     /**
57      * @notice Fired when a new role is added.
58      */
59     event BurnerRemoved(address indexed account);
60 
61     /**
62      * @dev The role is granted to the deployer.
63      */
64     constructor () internal {
65         _addBurner(msg.sender);
66     }
67 
68     /**
69      * @dev Callers must have the role.
70      */
71     modifier onlyBurner() {
72         require(isBurner(msg.sender), "BurnerRole: caller does not have the Burner role");
73         _;
74     }
75 
76     /**
77      * @dev The role is removed for the caller.    
78      */
79     function renounceBurner() public {
80         _removeBurner(msg.sender);
81     }
82 
83     /**
84      * @dev Checks if @param account has the role.
85      */
86     function isBurner(address account) public view returns (bool) {
87         return _burners.has(account);
88     }
89 
90     /**
91      * @dev Assigns the role to @param account.
92      */
93     function _addBurner(address account) internal {
94         _burners.add(account);
95         emit BurnerAdded(account);
96     }
97 
98     /**
99      * @dev Removes the role from @param account.
100      */
101     function _removeBurner(address account) internal {
102         _burners.remove(account);
103         emit BurnerRemoved(account);
104     }
105 
106 }
107 
108 // File: contracts/roles/MinterRole.sol
109 /**
110  * @title Minter Role
111  * @dev Follows the openzeppelin's guidelines of working with roles.
112  * @dev Derived contracts must implement the `addMinter` and the `removeMinter` functions.
113  */
114 contract MinterRole {
115     
116     using Roles for Roles.Role;
117 
118     Roles.Role private _minters;
119 
120     /**
121      * @notice Fired when a new role is added.
122      */
123     event MinterAdded(address indexed account);
124 
125     /**
126      * @notice Fired when a new role is added.
127      */
128     event MinterRemoved(address indexed account);
129 
130     /**
131      * @dev The role is granted to the deployer.
132      */
133     constructor () internal {
134         _addMinter(msg.sender);
135     }
136 
137     /**
138      * @dev Callers must have the role.
139      */
140     modifier onlyMinter() {
141         require(isMinter(msg.sender), "MinterRole: caller does not have the Minter role");
142         _;
143     }
144 
145     /**
146      * @dev The role is removed for the caller.    
147      */
148     function renounceMinter() public {
149         _removeMinter(msg.sender);
150     }
151 
152     /**
153      * @dev Checks if @param account has the role.
154      */
155     function isMinter(address account) public view returns (bool) {
156         return _minters.has(account);
157     }
158 
159     /**
160      * @dev Assigns the role to @param account.
161      */
162     function _addMinter(address account) internal {
163         _minters.add(account);
164         emit MinterAdded(account);
165     }
166 
167     /**
168      * @dev Removes the role from @param account.
169      */
170     function _removeMinter(address account) internal {
171         _minters.remove(account);
172         emit MinterRemoved(account);
173     }
174 
175 }
176 
177 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
178 
179 /**
180  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
181  * the optional functions; to access them see `ERC20Detailed`.
182  */
183 interface IERC20 {
184     /**
185      * @dev Returns the amount of tokens in existence.
186      */
187     function totalSupply() external view returns (uint256);
188 
189     /**
190      * @dev Returns the amount of tokens owned by `account`.
191      */
192     function balanceOf(address account) external view returns (uint256);
193 
194     /**
195      * @dev Moves `amount` tokens from the caller's account to `recipient`.
196      *
197      * Returns a boolean value indicating whether the operation succeeded.
198      *
199      * Emits a `Transfer` event.
200      */
201     function transfer(address recipient, uint256 amount) external returns (bool);
202 
203     /**
204      * @dev Returns the remaining number of tokens that `spender` will be
205      * allowed to spend on behalf of `owner` through `transferFrom`. This is
206      * zero by default.
207      *
208      * This value changes when `approve` or `transferFrom` are called.
209      */
210     function allowance(address owner, address spender) external view returns (uint256);
211 
212     /**
213      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
214      *
215      * Returns a boolean value indicating whether the operation succeeded.
216      *
217      * > Beware that changing an allowance with this method brings the risk
218      * that someone may use both the old and the new allowance by unfortunate
219      * transaction ordering. One possible solution to mitigate this race
220      * condition is to first reduce the spender's allowance to 0 and set the
221      * desired value afterwards:
222      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
223      *
224      * Emits an `Approval` event.
225      */
226     function approve(address spender, uint256 amount) external returns (bool);
227 
228     /**
229      * @dev Moves `amount` tokens from `sender` to `recipient` using the
230      * allowance mechanism. `amount` is then deducted from the caller's
231      * allowance.
232      *
233      * Returns a boolean value indicating whether the operation succeeded.
234      *
235      * Emits a `Transfer` event.
236      */
237     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
238 
239     /**
240      * @dev Emitted when `value` tokens are moved from one account (`from`) to
241      * another (`to`).
242      *
243      * Note that `value` may be zero.
244      */
245     event Transfer(address indexed from, address indexed to, uint256 value);
246 
247     /**
248      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
249      * a call to `approve`. `value` is the new allowance.
250      */
251     event Approval(address indexed owner, address indexed spender, uint256 value);
252 
253     /**
254      * @dev Emitted when the `owner` initiates a force transfer
255      *
256      * Note that `value` may be zero.
257      * Note that `details` may be zero.
258      */
259     event ForceTransfer(address indexed from, address indexed to, uint256 value, bytes32 details);
260 }
261 
262 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
263 /**
264  * @dev Wrappers over Solidity's arithmetic operations with added overflow
265  * checks.
266  *
267  * Arithmetic operations in Solidity wrap on overflow. This can easily result
268  * in bugs, because programmers usually assume that an overflow raises an
269  * error, which is the standard behavior in high level programming languages.
270  * `SafeMath` restores this intuition by reverting the transaction when an
271  * operation overflows.
272  *
273  * Using this library instead of the unchecked operations eliminates an entire
274  * class of bugs, so it's recommended to use it always.
275  */
276 library SafeMath {
277     /**
278      * @dev Returns the addition of two unsigned integers, reverting on
279      * overflow.
280      *
281      * Counterpart to Solidity's `+` operator.
282      *
283      * Requirements:
284      * - Addition cannot overflow.
285      */
286     function add(uint256 a, uint256 b) internal pure returns (uint256) {
287         uint256 c = a + b;
288         require(c >= a, "SafeMath: addition overflow");
289 
290         return c;
291     }
292 
293     /**
294      * @dev Returns the subtraction of two unsigned integers, reverting on
295      * overflow (when the result is negative).
296      *
297      * Counterpart to Solidity's `-` operator.
298      *
299      * Requirements:
300      * - Subtraction cannot overflow.
301      */
302     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
303         require(b <= a, "SafeMath: subtraction overflow");
304         uint256 c = a - b;
305 
306         return c;
307     }
308 
309     /**
310      * @dev Returns the multiplication of two unsigned integers, reverting on
311      * overflow.
312      *
313      * Counterpart to Solidity's `*` operator.
314      *
315      * Requirements:
316      * - Multiplication cannot overflow.
317      */
318     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
319         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
320         // benefit is lost if 'b' is also tested.
321         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
322         if (a == 0) {
323             return 0;
324         }
325 
326         uint256 c = a * b;
327         require(c / a == b, "SafeMath: multiplication overflow");
328 
329         return c;
330     }
331 
332     /**
333      * @dev Returns the integer division of two unsigned integers. Reverts on
334      * division by zero. The result is rounded towards zero.
335      *
336      * Counterpart to Solidity's `/` operator. Note: this function uses a
337      * `revert` opcode (which leaves remaining gas untouched) while Solidity
338      * uses an invalid opcode to revert (consuming all remaining gas).
339      *
340      * Requirements:
341      * - The divisor cannot be zero.
342      */
343     function div(uint256 a, uint256 b) internal pure returns (uint256) {
344         // Solidity only automatically asserts when dividing by 0
345         require(b > 0, "SafeMath: division by zero");
346         uint256 c = a / b;
347         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
348 
349         return c;
350     }
351 
352     /**
353      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
354      * Reverts when dividing by zero.
355      *
356      * Counterpart to Solidity's `%` operator. This function uses a `revert`
357      * opcode (which leaves remaining gas untouched) while Solidity uses an
358      * invalid opcode to revert (consuming all remaining gas).
359      *
360      * Requirements:
361      * - The divisor cannot be zero.
362      */
363     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
364         require(b != 0, "SafeMath: modulo by zero");
365         return a % b;
366     }
367 }
368 
369 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Fee.sol
370 /**
371  * @dev Implementation of the `IERC20` interface.
372  *
373  * This implementation is agnostic to the way tokens are created. This means
374  * that a supply mechanism has to be added in a derived contract using `_mint`.
375  * For a generic mechanism see `ERC20Mintable`.
376  *
377  * *For a detailed writeup see our guide [How to implement supply
378  * mechanisms](https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226).*
379  *
380  * We have followed general OpenZeppelin guidelines: functions revert instead
381  * of returning `false` on failure. This behavior is nonetheless conventional
382  * and does not conflict with the expectations of ERC20 applications.
383  *
384  * Additionally, an `Approval` event is emitted on calls to `transferFrom`.
385  * This allows applications to reconstruct the allowance for all accounts just
386  * by listening to said events. Other implementations of the EIP may not emit
387  * these events, as it isn't required by the specification.
388  *
389  * Finally, the non-standard `decreaseAllowance` and `increaseAllowance`
390  * functions have been added to mitigate the well-known issues around setting
391  * allowances. See `IERC20.approve`.
392  */
393 contract ERC20Fee is IERC20 {
394     using SafeMath for uint256;
395 
396 
397     mapping (address => uint256) private _balances;
398 
399     /**
400      * @dev List of whitelisted accounts.
401      * 0 = default (initial value for all accounts)
402      * 1 = verified account
403      * 2 = partner account
404      * 3 = blacklisted account (cannot send or receive tokens)
405      */
406     mapping (address => uint8) public whitelist;
407 
408     /**
409      * @dev The timestamp when the fee starts.
410      */
411     uint256 public feeStartTimestamp;
412 
413     /**
414      * @dev List of daily storage fees in order of account level (0 to 2). Value is in mpip (milipip or 1/1000 of a PIP) per day (24 hours) per amount.
415      */
416     uint[] public dailyStorageFee = [uint32(0), uint32(0), uint32(0)];
417 
418     /**
419      * @dev List of fixed transfer fees in order of account level (0 to 2). Value is in wei.
420      */
421     uint[] public fixedTransferFee = [uint32(0), uint32(0), uint32(0)];
422 
423     /**
424      * @dev List of dynamic transfer fees in order of account level (0 to 2). Value is in mpip (milipip or 1/1000 of a PIP) per amount transferred.
425      */
426     uint[] public dynamicTransferFee = [uint32(0), uint32(0), uint32(0)];
427 
428     /**
429      * @dev Minting fee in mpip (milipip or 1/1000 of a PIP) per amount.
430      */
431     uint256 public mintingFee = 0;
432 
433     /**
434      * @dev Constant mpip divider
435      */
436     uint256 private constant mpipDivider = 10000000;
437 
438     /**
439      * @dev Account mapping for last day of paid storage fees.
440      */
441     mapping (address => uint256) public storageFees;
442 
443     /**
444      * @dev The account that receives the fees (minting, storage and transfer).
445      */
446     address public feeManager;
447 
448     mapping (address => mapping (address => uint256)) private _allowances;
449 
450     uint256 private _totalSupply;
451 
452     /**
453      * @dev Old AWG contract for migration
454      */
455     address public oldAWGContract = 0x32310F5Cf83BA8Ebb45cAe9454e072A08850e057;
456 
457     /**
458      * @dev Returns the current storage day.
459      */
460     function getStorageDay() public view returns (uint256) {
461         return (block.timestamp - feeStartTimestamp).div(86400);
462     }
463 
464     /**
465      * @dev Migrate the balances for an account. Update the total supply and issue Transfer event. The balance is taken from old contract.
466      */
467     function _migrateBalance(address account) internal {
468         uint256 amount = ERC20Fee(oldAWGContract).balanceOf(account);
469         emit Transfer(address(0), account, amount);
470         _balances[account] = amount;
471         _totalSupply = _totalSupply.add(amount);
472     }
473 
474     /**
475      * @dev Forced transfer from one account to another. Will contain details about AML procedure.
476      */
477     function _forceTransfer(address sender, address recipient, uint256 amount, bytes32 details) internal {
478         _balances[sender] = _balances[sender].sub(amount);
479         _balances[recipient] = _balances[recipient].add(amount);
480         emit Transfer(sender, recipient, amount);
481         emit ForceTransfer(sender, recipient, amount, details);
482     }
483 
484     /**
485      * @dev Calculate the storage fees for an account.
486      */
487     function calculateStorageFees(address account) public view returns (uint256) {
488         return (((getStorageDay().sub(storageFees[account])).mul(_balances[account])).mul(dailyStorageFee[whitelist[account]])).div(mpipDivider);
489     }
490 
491     /**
492      * @dev Retrieve the storage fees for an account.
493      */
494     function _retrieveStorageFee(address account) internal {
495         uint256 storageFee = calculateStorageFees(account);
496         storageFees[account] = getStorageDay();
497         if (storageFee > 0) {
498             _transfer(account,feeManager,storageFee);
499         }
500     }
501 
502     /**
503      * @dev Retrieve the storage fees for an account.
504      */
505     function _resetStorageFee(address account) internal {
506         storageFees[account] = getStorageDay();
507     }
508 
509     /**
510      * @dev See `IERC20.totalSupply`.
511      */
512     function totalSupply() public view returns (uint256) {
513         return _totalSupply;
514     }
515 
516     /**
517      * @dev See `IERC20.balanceOf`.
518      */
519     function balanceOf(address account) public view returns (uint256) {
520         return _balances[account];
521     }
522 
523     /**
524      * @dev See `IERC20.transfer`.
525      *
526      * Requirements:
527      *
528      * - `recipient` cannot be the zero address.
529      * - the caller must have a balance of at least `amount`.
530      */
531     function transfer(address recipient, uint256 amount) public returns (bool) {
532         _transfer(msg.sender, recipient, amount);
533         return true;
534     }
535 
536     /**
537      * @dev See `IERC20.allowance`.
538      */
539     function allowance(address owner, address spender) public view returns (uint256) {
540         return _allowances[owner][spender];
541     }
542 
543     /**
544      * @dev See `IERC20.approve`.
545      *
546      * Requirements:
547      *
548      * - `spender` cannot be the zero address.
549      */
550     function approve(address spender, uint256 value) public returns (bool) {
551         _approve(msg.sender, spender, value);
552         return true;
553     }
554 
555     /**
556      * @dev See `IERC20.transferFrom`.
557      *
558      * Emits an `Approval` event indicating the updated allowance. This is not
559      * required by the EIP. See the note at the beginning of `ERC20`;
560      *
561      * Requirements:
562      * - `sender` and `recipient` cannot be the zero address.
563      * - `sender` must have a balance of at least `value`.
564      * - the caller must have allowance for `sender`'s tokens of at least
565      * `amount`.
566      */
567     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
568         _transfer(sender, recipient, amount);
569         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
570         return true;
571     }
572 
573     /**
574      * @dev Atomically increases the allowance granted to `spender` by the caller.
575      *
576      * This is an alternative to `approve` that can be used as a mitigation for
577      * problems described in `IERC20.approve`.
578      *
579      * Emits an `Approval` event indicating the updated allowance.
580      *
581      * Requirements:
582      *
583      * - `spender` cannot be the zero address.
584      */
585     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
586         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
587         return true;
588     }
589 
590     /**
591      * @dev Atomically decreases the allowance granted to `spender` by the caller.
592      *
593      * This is an alternative to `approve` that can be used as a mitigation for
594      * problems described in `IERC20.approve`.
595      *
596      * Emits an `Approval` event indicating the updated allowance.
597      *
598      * Requirements:
599      *
600      * - `spender` cannot be the zero address.
601      * - `spender` must have allowance for the caller of at least
602      * `subtractedValue`.
603      */
604     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
605         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
606         return true;
607     }
608 
609     /**
610      * @dev Moves tokens `amount` from `sender` to `recipient`.
611      *
612      * This is internal function is equivalent to `transfer`, and can be used to
613      * e.g. implement automatic token fees, slashing mechanisms, etc.
614      *
615      * Emits a `Transfer` event.
616      *
617      * Requirements:
618      *
619      * - `sender` cannot be the zero address.
620      * - `recipient` cannot be the zero address.
621      * - `sender` must have a balance of at least `amount`.
622      */
623     function _transfer(address sender, address recipient, uint256 amount) internal {
624         require(sender != address(0), "ERC20: transfer from the zero address");
625         require(recipient != address(0), "ERC20: transfer to the zero address");
626 
627 
628         uint8 level = whitelist[sender];
629         require(level != 3, "Sender is blacklisted");
630 
631         uint256 senderFee = calculateStorageFees(sender) + fixedTransferFee[level] + ((dynamicTransferFee[level].mul(amount)).div(mpipDivider));
632         uint256 receiverStorageFee = calculateStorageFees(recipient);
633         uint256 totalFee = senderFee.add(receiverStorageFee);
634 
635         _balances[sender] = (_balances[sender].sub(amount)).sub(senderFee);
636         _balances[recipient] = (_balances[recipient].add(amount)).sub(receiverStorageFee);
637 
638         storageFees[sender] = getStorageDay();
639         storageFees[recipient] = getStorageDay();
640         emit Transfer(sender, recipient, amount);
641 
642         if (totalFee > 0) {
643             _balances[feeManager] = _balances[feeManager].add(totalFee);
644             emit Transfer(sender, feeManager, senderFee);
645             emit Transfer(recipient, feeManager, receiverStorageFee);
646             (bool success, ) = feeManager.call(abi.encodeWithSignature("processFee(uint256)",totalFee));
647             require(success, "Fee Manager is not responding.");
648         }
649     }
650 
651     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
652      * the total supply.
653      *
654      * Emits a `Transfer` event with `from` set to the zero address.
655      *
656      * Requirements
657      *
658      * - `to` cannot be the zero address.
659      */
660     function _mint(address account, uint256 amount) internal {
661         require(account != address(0), "ERC20: mint to the zero address");
662 
663         uint256 mintingFeeAmount = amount.mul(mintingFee).div(mpipDivider);
664 
665         _totalSupply = _totalSupply.add(amount);
666         _balances[account] = _balances[account].add(amount).sub(mintingFeeAmount);
667         emit Transfer(address(0), account, (amount.sub(mintingFeeAmount)));
668 
669         if (mintingFeeAmount > 0) {
670             _balances[feeManager] = _balances[feeManager].add(mintingFeeAmount);
671             emit Transfer(address(0), feeManager, mintingFeeAmount);
672             (bool success, ) = feeManager.call(abi.encodeWithSignature("processFee(uint256)",mintingFeeAmount));
673             require(success, "Fee Manager is not responding.");
674         }
675     }
676 
677      /**
678      * @dev Destoys `amount` tokens from `account`, reducing the
679      * total supply.
680      *
681      * Emits a `Transfer` event with `to` set to the zero address.
682      *
683      * Requirements
684      *
685      * - `account` cannot be the zero address.
686      * - `account` must have at least `amount` tokens.
687      */
688     function _burn(address account, uint256 value) internal {
689         require(account != address(0), "ERC20: burn from the zero address");
690 
691         _totalSupply = _totalSupply.sub(value);
692         _balances[account] = _balances[account].sub(value);
693         emit Transfer(account, address(0), value);
694     }
695 
696     /**
697      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
698      *
699      * This is internal function is equivalent to `approve`, and can be used to
700      * e.g. set automatic allowances for certain subsystems, etc.
701      *
702      * Emits an `Approval` event.
703      *
704      * Requirements:
705      *
706      * - `owner` cannot be the zero address.
707      * - `spender` cannot be the zero address.
708      */
709     function _approve(address owner, address spender, uint256 value) internal {
710         require(owner != address(0), "ERC20: approve from the zero address");
711         require(spender != address(0), "ERC20: approve to the zero address");
712 
713         _allowances[owner][spender] = value;
714         emit Approval(owner, spender, value);
715     }
716 
717     /**
718      * @dev Destoys `amount` tokens from `account`.`amount` is then deducted
719      * from the caller's allowance.
720      *
721      * See `_burn` and `_approve`.
722      */
723     function _burnFrom(address account, uint256 amount) internal {
724         _burn(account, amount);
725         _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount));
726     }
727 
728 }
729 
730 // File: openzeppelin-solidity/contracts/access/roles/PauserRole.sol
731 contract PauserRole {
732     using Roles for Roles.Role;
733 
734     event PauserAdded(address indexed account);
735     event PauserRemoved(address indexed account);
736 
737     Roles.Role private _pausers;
738 
739     constructor () internal {
740         _addPauser(msg.sender);
741     }
742 
743     modifier onlyPauser() {
744         require(isPauser(msg.sender), "PauserRole: caller does not have the Pauser role");
745         _;
746     }
747 
748     function isPauser(address account) public view returns (bool) {
749         return _pausers.has(account);
750     }
751 
752     function addPauser(address account) public onlyPauser {
753         _addPauser(account);
754     }
755 
756     function renouncePauser() public {
757         _removePauser(msg.sender);
758     }
759 
760     function _addPauser(address account) internal {
761         _pausers.add(account);
762         emit PauserAdded(account);
763     }
764 
765     function _removePauser(address account) internal {
766         _pausers.remove(account);
767         emit PauserRemoved(account);
768     }
769 }
770 
771 // File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol
772 /**
773  * @dev Contract module which allows children to implement an emergency stop
774  * mechanism that can be triggered by an authorized account.
775  *
776  * This module is used through inheritance. It will make available the
777  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
778  * the functions of your contract. Note that they will not be pausable by
779  * simply including this module, only once the modifiers are put in place.
780  */
781 contract Pausable is PauserRole {
782     /**
783      * @dev Emitted when the pause is triggered by a pauser (`account`).
784      */
785     event Paused(address account);
786 
787     /**
788      * @dev Emitted when the pause is lifted by a pauser (`account`).
789      */
790     event Unpaused(address account);
791 
792     bool private _paused;
793 
794     /**
795      * @dev Initializes the contract in unpaused state. Assigns the Pauser role
796      * to the deployer.
797      */
798     constructor () internal {
799         _paused = false;
800     }
801 
802     /**
803      * @dev Returns true if the contract is paused, and false otherwise.
804      */
805     function paused() public view returns (bool) {
806         return _paused;
807     }
808 
809     /**
810      * @dev Modifier to make a function callable only when the contract is not paused.
811      */
812     modifier whenNotPaused() {
813         require(!_paused, "Pausable: paused");
814         _;
815     }
816 
817     /**
818      * @dev Modifier to make a function callable only when the contract is paused.
819      */
820     modifier whenPaused() {
821         require(_paused, "Pausable: not paused");
822         _;
823     }
824 
825     /**
826      * @dev Called by a pauser to pause, triggers stopped state.
827      */
828     function pause() public onlyPauser whenNotPaused {
829         _paused = true;
830         emit Paused(msg.sender);
831     }
832 
833     /**
834      * @dev Called by a pauser to unpause, returns to normal state.
835      */
836     function unpause() public onlyPauser whenPaused {
837         _paused = false;
838         emit Unpaused(msg.sender);
839     }
840 }
841 
842 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20StorageFee.sol
843 /**
844  * @title Pausable token
845  * @dev ERC20 modified with pausable transfers.
846  */
847 contract ERC20StorageFee is ERC20Fee, Pausable {
848     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
849         return super.transfer(to, value);
850     }
851 
852     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
853         return super.transferFrom(from, to, value);
854     }
855 
856     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
857         return super.approve(spender, value);
858     }
859 
860     function increaseAllowance(address spender, uint addedValue) public whenNotPaused returns (bool) {
861         return super.increaseAllowance(spender, addedValue);
862     }
863 
864     function decreaseAllowance(address spender, uint subtractedValue) public whenNotPaused returns (bool) {
865         return super.decreaseAllowance(spender, subtractedValue);
866     }
867 }
868 
869 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
870 /**
871  * @dev Contract module which provides a basic access control mechanism, where
872  * there is an account (an owner) that can be granted exclusive access to
873  * specific functions.
874  *
875  * This module is used through inheritance. It will make available the modifier
876  * `onlyOwner`, which can be aplied to your functions to restrict their use to
877  * the owner.
878  */
879 contract Ownable {
880     address private _owner;
881 
882     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
883 
884     /**
885      * @dev Initializes the contract setting the deployer as the initial owner.
886      */
887     constructor () internal {
888         _owner = msg.sender;
889         emit OwnershipTransferred(address(0), _owner);
890     }
891 
892     /**
893      * @dev Returns the address of the current owner.
894      */
895     function owner() public view returns (address) {
896         return _owner;
897     }
898 
899     /**
900      * @dev Throws if called by any account other than the owner.
901      */
902     modifier onlyOwner() {
903         require(isOwner(), "Ownable: caller is not the owner");
904         _;
905     }
906 
907     /**
908      * @dev Returns true if the caller is the current owner.
909      */
910     function isOwner() public view returns (bool) {
911         return msg.sender == _owner;
912     }
913 
914     /**
915      * @dev Leaves the contract without owner. It will not be possible to call
916      * `onlyOwner` functions anymore. Can only be called by the current owner.
917      *
918      * > Note: Renouncing ownership will leave the contract without an owner,
919      * thereby removing any functionality that is only available to the owner.
920      */
921     function renounceOwnership() public onlyOwner {
922         emit OwnershipTransferred(_owner, address(0));
923         _owner = address(0);
924     }
925 
926     /**
927      * @dev Transfers ownership of the contract to a new account (`newOwner`).
928      * Can only be called by the current owner.
929      */
930     function transferOwnership(address newOwner) public onlyOwner {
931         _transferOwnership(newOwner);
932     }
933 
934     /**
935      * @dev Transfers ownership of the contract to a new account (`newOwner`).
936      */
937     function _transferOwnership(address newOwner) internal {
938         require(newOwner != address(0), "Ownable: new owner is the zero address");
939         emit OwnershipTransferred(_owner, newOwner);
940         _owner = newOwner;
941     }
942 }
943 
944 // File: contracts/interfaces/IToken.sol
945 /**
946  * @title Token Interface
947  * @dev Exposes token functionality
948  */
949 interface IToken {
950 
951     function burn(uint256 amount) external ;
952 
953     function mint(address account, uint256 amount) external ;
954 
955 }
956 
957 // File: contracts/token/ECRecovery.sol
958 /**
959  * @title Eliptic curve signature operations
960  * @dev Based on https://gist.github.com/axic/5b33912c6f61ae6fd96d6c4a47afde6d
961  * TODO Remove this library once solidity supports passing a signature to ecrecover.
962  * See https://github.com/ethereum/solidity/issues/864
963  */
964 library ECRecovery {
965 
966     /**
967      * @dev Recover signer address from a message by using their signature
968      * @param hash bytes32 message, the hash is the signed message. What is recovered is the signer address.
969      * @param sig bytes signature, the signature is generated using web3.eth.sign()
970      */
971     function recover(bytes32 hash, bytes memory sig)
972         internal
973         pure
974         returns (address)
975     {
976         bytes32 r;
977         bytes32 s;
978         uint8 v;
979 
980         // Check the signature length
981         if (sig.length != 65) {
982             return (address(0));
983         }
984 
985         // Divide the signature in r, s and v variables
986         // ecrecover takes the signature parameters, and the only way to get them
987         // currently is to use assembly.
988         // solium-disable-next-line security/no-inline-assembly
989         assembly {
990             r := mload(add(sig, 32))
991             s := mload(add(sig, 64))
992             v := byte(0, mload(add(sig, 96)))
993         }
994 
995         // Version of signature should be 27 or 28, but 0 and 1 are also possible versions
996         if (v < 27) {
997             v += 27;
998         }
999 
1000         // If the version is correct return the signer address
1001         if (v != 27 && v != 28) {
1002             return (address(0));
1003         } else {
1004             // solium-disable-next-line arg-overflow
1005             return ecrecover(hash, v, r, s);
1006         }
1007     }
1008 
1009     /**
1010      * toEthSignedMessageHash
1011      * @dev prefix a bytes32 value with "\x19Ethereum Signed Message:"
1012      * and hash the result
1013      */
1014     function toEthSignedMessageHash(bytes32 hash)
1015         internal
1016         pure
1017         returns (bytes32)
1018     {
1019         // 32 is the length in bytes of hash,
1020         // enforced by the type signature above
1021         return keccak256(
1022             abi.encodePacked("\x19Ethereum Signed Message:\n32", hash)
1023         );
1024     }
1025 }
1026 
1027 // File: contracts/token/Feeless.sol
1028 /**
1029  * @title Feeless
1030  * @dev Usage: Used as an extension in contracts that want to execute feeless functions.
1031  * @dev Usage: Apply the feeless modifier.
1032  * @dev Based on https://github.com/bitclave/Feeless
1033  */
1034 contract Feeless {
1035 
1036     /**
1037      * @dev The replacement for msg.sender on functions that use the feeless modifier.
1038      */ 
1039     address internal msgSender;
1040 
1041     /**
1042      * @dev Mimics the blockchain nonce relative to this contract (or contract that extents). 
1043      */ 
1044     mapping(address => uint256) public nonces;
1045 
1046     /**
1047      * @dev Holds reference to the initial signer of the transaction in the msgSender variable.
1048      * @dev After execution the variable is reset.
1049      */
1050     modifier feeless() {
1051         if (msgSender == address(0)) {
1052             msgSender = msg.sender;
1053             _;
1054             msgSender = address(0);
1055         } else {
1056             _;
1057         }
1058     }
1059 
1060     struct CallResult {
1061         bool success;
1062         bytes payload;
1063     }
1064 
1065     /// @notice Only the certSign owner can call this function.
1066     /// @dev Signed transactions are passed to this function.
1067     function performFeelessTransaction(
1068         address sender, 
1069         address target, 
1070         bytes memory data, 
1071         uint256 nonce, 
1072         bytes memory sig) public payable {
1073         require(address(this) == target, "Feeless: Target should be the extended contract");
1074     
1075         bytes memory prefix = "\x19Ethereum Signed Message:\n32";
1076         bytes32 hash = keccak256(abi.encodePacked(prefix, keccak256(abi.encodePacked(target, data, nonce))));
1077         msgSender = ECRecovery.recover(hash, sig);
1078         require(msgSender == sender, "Feeless: Unexpected sender");
1079         require(nonces[msgSender]++ == nonce, "Feeless: nonce does not comply");
1080         (bool _success, bytes memory _payload) = target.call.value(msg.value)(data);
1081         CallResult memory callResult = CallResult(_success, _payload);
1082         require(callResult.success, "Feeless: Call failed");
1083         msgSender = address(0);
1084     }
1085     
1086 }
1087 
1088 // File: contracts/token/AWG.sol
1089 /**
1090  * @title AWG Token
1091  * @notice ERC20 token implementation.
1092  * @dev Implements mintable, burnable and pausable token interfaces.
1093  */
1094 contract AWG is ERC20StorageFee, MinterRole, BurnerRole, Ownable, Feeless, IToken {
1095 
1096     /**
1097      * @dev Fired when a feeless transfer has been executed.
1098      */
1099     event TransferFeeless(address indexed account, uint256 indexed value);
1100 
1101     /**
1102      * @dev Fired when a feeless approve has been executed.
1103      */
1104     event ApproveFeeless(address indexed spender, uint256 indexed value);
1105 
1106     /**
1107      * @notice ERC20 convention.
1108      */
1109     uint8 public constant decimals = 18;
1110 
1111     /**
1112      * @notice ERC20 convention.
1113      */
1114     string public constant name = "AurusGOLD";
1115     
1116     /**
1117      * @notice ERC20 convention.
1118      */
1119     string public constant symbol = "AWG";
1120 
1121     /**
1122      * @dev Flag to indicate that the migration from old token has stopped.
1123      */
1124     bool private _migrationOpen = true;
1125 
1126     constructor() public {
1127         feeStartTimestamp = block.timestamp;
1128     }
1129 
1130     /**
1131      * @dev Stop migration by setting flag.
1132      */
1133     function stopMigration() public onlyOwner {
1134         _migrationOpen = false;
1135     }
1136 
1137     /**
1138      * @dev Check if migration is open.
1139      */
1140     modifier whenMigration() {
1141         require(_migrationOpen, "Migration: stopped");
1142         _;
1143     }
1144 
1145     /**
1146      * @dev Migrate balance from old token when migration is open, and both the old and the new token are paused.
1147      */
1148     function migrateBalances(address[] calldata _accounts) external whenPaused whenMigration onlyOwner {
1149         require(AWG(oldAWGContract).paused(), "Pausable: not paused");
1150         for (uint i=0; i<_accounts.length; i++) {
1151             _migrateBalance(_accounts[i]);
1152         }
1153     }
1154 
1155     /**
1156      * @dev Force a transfer between 2 accounts. AML logs on https://aurus.io/aml
1157      */
1158     function forceTransfer(address sender, address recipient, uint256 amount, bytes32 details) external onlyOwner {
1159         _forceTransfer(sender,recipient,amount,details);
1160     }
1161 
1162     /**
1163      * @dev Set the whitelisting level for an account.
1164      */
1165     function whitelistAddress(address account, uint8 level) external onlyOwner {
1166         require(level<=3, "Level: Please use level 0 to 3.");
1167         whitelist[account] = level;
1168     }
1169 
1170     /**
1171      * @dev Set the fees in the system. All the fees are in mpip, except fixedTransferFee that is in wei. Level is between 0 and 2
1172      */
1173     function setFees(uint256 _dailyStorageFee, uint256 _fixedTransferFee, uint256 _dynamicTransferFee, uint256 _mintingFee, uint8 level) external onlyOwner {
1174         require(level<=2, "Level: Please use level 0 to 2.");
1175         dailyStorageFee[level] = _dailyStorageFee;
1176         fixedTransferFee[level] = _fixedTransferFee;
1177         dynamicTransferFee[level] = _dynamicTransferFee;
1178         mintingFee = _mintingFee;
1179     }
1180 
1181     /**
1182      * @dev Set the address where the fees are forwarded.
1183      */
1184     function setFeeManager(address account) external onlyOwner {
1185         (bool success, ) = feeManager.call(abi.encodeWithSignature("processFee(uint256)",0));
1186         require(success);
1187         feeManager = account;
1188     }
1189 
1190     /**
1191      * @dev Function called by the owner to force an account to pay storage fee to date.
1192      */
1193     function retrieveStorageFee(address account) external onlyOwner {
1194         _retrieveStorageFee(account);
1195     }
1196 
1197     /**
1198      * @dev Function called by the owner to reset storage fees for selected accounts.
1199      */
1200     function resetStorageFees(address[] calldata _accounts) external onlyOwner {
1201         for (uint i=0; i<_accounts.length; i++) {
1202             _resetStorageFee(_accounts[i]);
1203         }
1204     }
1205 
1206     /**
1207      * @dev See `MinterRole._addMinter`.
1208      */
1209     function addMinter(address account) external onlyOwner {
1210         _addMinter(account);
1211     }
1212 
1213     /**
1214      * @dev See `MinterRole._removeMinter`.
1215      */
1216     function removeMinter(address account) external onlyOwner {
1217         _removeMinter(account);
1218     }
1219 
1220     /**
1221      * @dev See `BurnerRole._addBurner`.
1222      */
1223     function addBurner(address account) external onlyOwner {
1224         _addBurner(account);
1225     }
1226 
1227     /**
1228      * @dev See `BurnerRole._removeBurner`.
1229      */
1230     function removeBurner(address account) external onlyOwner {
1231         _removeBurner(account);
1232     }
1233 
1234     /**
1235      * @notice The caller must have the `BurnerRole`.
1236      * @dev See `ERC20._burn`.
1237      */
1238     function burn(uint256 amount) external onlyBurner {
1239         _burn(msg.sender, amount);
1240     }
1241 
1242     /**
1243      * @notice The caller must have the `MinterRole`.
1244      * @dev See `ERC20._mint`.
1245      */
1246     function mint(address account, uint256 amount) external onlyMinter {
1247         _mint(account, amount);
1248     }
1249 
1250     /**
1251      * @notice Feeless ERC20 transfer.
1252      */
1253     function transferFeeless(address account, uint256 value) feeless whenNotPaused external {
1254         _transfer(msgSender, account, value);
1255         emit TransferFeeless(account, value);
1256     }
1257 
1258     /**
1259      * @notice Feeless ERC20 transfer.
1260      */
1261     function approveFeeless(address spender, uint256 value) feeless whenNotPaused external {
1262         _approve(msgSender, spender, value);
1263         emit ApproveFeeless(spender, value);
1264     }
1265 }