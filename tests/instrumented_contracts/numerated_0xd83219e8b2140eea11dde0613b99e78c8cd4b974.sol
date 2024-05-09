1 // File: openzeppelin-solidity/contracts/GSN/Context.sol
2 
3 pragma solidity ^0.5.10;
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
31 // File: openzeppelin-solidity/contracts/access/Roles.sol
32 
33 pragma solidity ^0.5.10;
34 
35 /**
36  * @title Roles
37  * @dev Library for managing addresses assigned to a Role.
38  */
39 library Roles {
40     struct Role {
41         mapping (address => bool) bearer;
42     }
43 
44     /**
45      * @dev Give an account access to this role.
46      */
47     function add(Role storage role, address account) internal {
48         require(!has(role, account), "Roles: account already has role");
49         role.bearer[account] = true;
50     }
51 
52     /**
53      * @dev Remove an account's access to this role.
54      */
55     function remove(Role storage role, address account) internal {
56         require(has(role, account), "Roles: account does not have role");
57         role.bearer[account] = false;
58     }
59 
60     /**
61      * @dev Check if an account has this role.
62      * @return bool
63      */
64     function has(Role storage role, address account) internal view returns (bool) {
65         require(account != address(0), "Roles: account is the zero address");
66         return role.bearer[account];
67     }
68 }
69 
70 // File: openzeppelin-solidity/contracts/access/roles/PauserRole.sol
71 
72 pragma solidity ^0.5.10;
73 
74 
75 
76 contract PauserRole is Context {
77     using Roles for Roles.Role;
78 
79     event PauserAdded(address indexed account);
80     event PauserRemoved(address indexed account);
81 
82     Roles.Role private _pausers;
83 
84     constructor () internal {
85         _addPauser(_msgSender());
86     }
87 
88     modifier onlyPauser() {
89         require(isPauser(_msgSender()), "PauserRole: caller does not have the Pauser role");
90         _;
91     }
92 
93     function isPauser(address account) public view returns (bool) {
94         return _pausers.has(account);
95     }
96 
97     function addPauser(address account) public onlyPauser {
98         _addPauser(account);
99     }
100 
101     function renouncePauser() public {
102         _removePauser(_msgSender());
103     }
104 
105     function _addPauser(address account) internal {
106         _pausers.add(account);
107         emit PauserAdded(account);
108     }
109 
110     function _removePauser(address account) internal {
111         _pausers.remove(account);
112         emit PauserRemoved(account);
113     }
114 }
115 
116 // File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol
117 
118 pragma solidity ^0.5.10;
119 
120 
121 
122 /**
123  * @dev Contract module which allows children to implement an emergency stop
124  * mechanism that can be triggered by an authorized account.
125  *
126  * This module is used through inheritance. It will make available the
127  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
128  * the functions of your contract. Note that they will not be pausable by
129  * simply including this module, only once the modifiers are put in place.
130  */
131 contract Pausable is Context, PauserRole {
132     /**
133      * @dev Emitted when the pause is triggered by a pauser (`account`).
134      */
135     event Paused(address account);
136 
137     /**
138      * @dev Emitted when the pause is lifted by a pauser (`account`).
139      */
140     event Unpaused(address account);
141 
142     bool private _paused;
143 
144     /**
145      * @dev Initializes the contract in unpaused state. Assigns the Pauser role
146      * to the deployer.
147      */
148     constructor () internal {
149         _paused = false;
150     }
151 
152     /**
153      * @dev Returns true if the contract is paused, and false otherwise.
154      */
155     function paused() public view returns (bool) {
156         return _paused;
157     }
158 
159     /**
160      * @dev Modifier to make a function callable only when the contract is not paused.
161      */
162     modifier whenNotPaused() {
163         require(!_paused, "Pausable: paused");
164         _;
165     }
166 
167     /**
168      * @dev Modifier to make a function callable only when the contract is paused.
169      */
170     modifier whenPaused() {
171         require(_paused, "Pausable: not paused");
172         _;
173     }
174 
175     /**
176      * @dev Called by a pauser to pause, triggers stopped state.
177      */
178     function pause() public onlyPauser whenNotPaused {
179         _paused = true;
180         emit Paused(_msgSender());
181     }
182 
183     /**
184      * @dev Called by a pauser to unpause, returns to normal state.
185      */
186     function unpause() public onlyPauser whenPaused {
187         _paused = false;
188         emit Unpaused(_msgSender());
189     }
190 }
191 
192 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
193 
194 pragma solidity ^0.5.10;
195 
196 /**
197  * @dev Wrappers over Solidity's arithmetic operations with added overflow
198  * checks.
199  *
200  * Arithmetic operations in Solidity wrap on overflow. This can easily result
201  * in bugs, because programmers usually assume that an overflow raises an
202  * error, which is the standard behavior in high level programming languages.
203  * `SafeMath` restores this intuition by reverting the transaction when an
204  * operation overflows.
205  *
206  * Using this library instead of the unchecked operations eliminates an entire
207  * class of bugs, so it's recommended to use it always.
208  */
209 library SafeMath {
210     /**
211      * @dev Returns the addition of two unsigned integers, reverting on
212      * overflow.
213      *
214      * Counterpart to Solidity's `+` operator.
215      *
216      * Requirements:
217      * - Addition cannot overflow.
218      */
219     function add(uint256 a, uint256 b) internal pure returns (uint256) {
220         uint256 c = a + b;
221         require(c >= a, "SafeMath: addition overflow");
222 
223         return c;
224     }
225 
226     /**
227      * @dev Returns the subtraction of two unsigned integers, reverting on
228      * overflow (when the result is negative).
229      *
230      * Counterpart to Solidity's `-` operator.
231      *
232      * Requirements:
233      * - Subtraction cannot overflow.
234      */
235     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
236         return sub(a, b, "SafeMath: subtraction overflow");
237     }
238 
239     /**
240      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
241      * overflow (when the result is negative).
242      *
243      * Counterpart to Solidity's `-` operator.
244      *
245      * Requirements:
246      * - Subtraction cannot overflow.
247      *
248      * _Available since v2.4.0._
249      */
250     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
251         require(b <= a, errorMessage);
252         uint256 c = a - b;
253 
254         return c;
255     }
256 
257     /**
258      * @dev Returns the multiplication of two unsigned integers, reverting on
259      * overflow.
260      *
261      * Counterpart to Solidity's `*` operator.
262      *
263      * Requirements:
264      * - Multiplication cannot overflow.
265      */
266     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
267         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
268         // benefit is lost if 'b' is also tested.
269         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
270         if (a == 0) {
271             return 0;
272         }
273 
274         uint256 c = a * b;
275         require(c / a == b, "SafeMath: multiplication overflow");
276 
277         return c;
278     }
279 
280     /**
281      * @dev Returns the integer division of two unsigned integers. Reverts on
282      * division by zero. The result is rounded towards zero.
283      *
284      * Counterpart to Solidity's `/` operator. Note: this function uses a
285      * `revert` opcode (which leaves remaining gas untouched) while Solidity
286      * uses an invalid opcode to revert (consuming all remaining gas).
287      *
288      * Requirements:
289      * - The divisor cannot be zero.
290      */
291     function div(uint256 a, uint256 b) internal pure returns (uint256) {
292         return div(a, b, "SafeMath: division by zero");
293     }
294 
295     /**
296      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
297      * division by zero. The result is rounded towards zero.
298      *
299      * Counterpart to Solidity's `/` operator. Note: this function uses a
300      * `revert` opcode (which leaves remaining gas untouched) while Solidity
301      * uses an invalid opcode to revert (consuming all remaining gas).
302      *
303      * Requirements:
304      * - The divisor cannot be zero.
305      *
306      * _Available since v2.4.0._
307      */
308     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
309         // Solidity only automatically asserts when dividing by 0
310         require(b > 0, errorMessage);
311         uint256 c = a / b;
312         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
313 
314         return c;
315     }
316 
317     /**
318      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
319      * Reverts when dividing by zero.
320      *
321      * Counterpart to Solidity's `%` operator. This function uses a `revert`
322      * opcode (which leaves remaining gas untouched) while Solidity uses an
323      * invalid opcode to revert (consuming all remaining gas).
324      *
325      * Requirements:
326      * - The divisor cannot be zero.
327      */
328     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
329         return mod(a, b, "SafeMath: modulo by zero");
330     }
331 
332     /**
333      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
334      * Reverts with custom message when dividing by zero.
335      *
336      * Counterpart to Solidity's `%` operator. This function uses a `revert`
337      * opcode (which leaves remaining gas untouched) while Solidity uses an
338      * invalid opcode to revert (consuming all remaining gas).
339      *
340      * Requirements:
341      * - The divisor cannot be zero.
342      *
343      * _Available since v2.4.0._
344      */
345     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
346         require(b != 0, errorMessage);
347         return a % b;
348     }
349 }
350 
351 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
352 
353 pragma solidity ^0.5.10;
354 
355 /**
356  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
357  * the optional functions; to access them see {ERC20Detailed}.
358  */
359 interface IERC20 {
360     /**
361      * @dev Returns the amount of tokens in existence.
362      */
363     function totalSupply() external view returns (uint256);
364 
365     /**
366      * @dev Returns the amount of tokens owned by `account`.
367      */
368     function balanceOf(address account) external view returns (uint256);
369 
370     /**
371      * @dev Moves `amount` tokens from the caller's account to `recipient`.
372      *
373      * Returns a boolean value indicating whether the operation succeeded.
374      *
375      * Emits a {Transfer} event.
376      */
377     function transfer(address recipient, uint256 amount) external returns (bool);
378 
379     /**
380      * @dev Returns the remaining number of tokens that `spender` will be
381      * allowed to spend on behalf of `owner` through {transferFrom}. This is
382      * zero by default.
383      *
384      * This value changes when {approve} or {transferFrom} are called.
385      */
386     function allowance(address owner, address spender) external view returns (uint256);
387 
388     /**
389      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
390      *
391      * Returns a boolean value indicating whether the operation succeeded.
392      *
393      * IMPORTANT: Beware that changing an allowance with this method brings the risk
394      * that someone may use both the old and the new allowance by unfortunate
395      * transaction ordering. One possible solution to mitigate this race
396      * condition is to first reduce the spender's allowance to 0 and set the
397      * desired value afterwards:
398      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
399      *
400      * Emits an {Approval} event.
401      */
402     function approve(address spender, uint256 amount) external returns (bool);
403 
404     /**
405      * @dev Moves `amount` tokens from `sender` to `recipient` using the
406      * allowance mechanism. `amount` is then deducted from the caller's
407      * allowance.
408      *
409      * Returns a boolean value indicating whether the operation succeeded.
410      *
411      * Emits a {Transfer} event.
412      */
413     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
414 
415     /**
416      * @dev Emitted when `value` tokens are moved from one account (`from`) to
417      * another (`to`).
418      *
419      * Note that `value` may be zero.
420      */
421     event Transfer(address indexed from, address indexed to, uint256 value);
422 
423     /**
424      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
425      * a call to {approve}. `value` is the new allowance.
426      */
427     event Approval(address indexed owner, address indexed spender, uint256 value);
428 }
429 
430 // File: openzeppelin-solidity/contracts/utils/Address.sol
431 
432 pragma solidity ^0.5.5;
433 
434 /**
435  * @dev Collection of functions related to the address type
436  */
437 library Address {
438     /**
439      * @dev Returns true if `account` is a contract.
440      *
441      * This test is non-exhaustive, and there may be false-negatives: during the
442      * execution of a contract's constructor, its address will be reported as
443      * not containing a contract.
444      *
445      * IMPORTANT: It is unsafe to assume that an address for which this
446      * function returns false is an externally-owned account (EOA) and not a
447      * contract.
448      */
449     function isContract(address account) internal view returns (bool) {
450         // This method relies in extcodesize, which returns 0 for contracts in
451         // construction, since the code is only stored at the end of the
452         // constructor execution.
453 
454         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
455         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
456         // for accounts without code, i.e. `keccak256('')`
457         bytes32 codehash;
458         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
459         // solhint-disable-next-line no-inline-assembly
460         assembly { codehash := extcodehash(account) }
461         return (codehash != 0x0 && codehash != accountHash);
462     }
463 
464     /**
465      * @dev Converts an `address` into `address payable`. Note that this is
466      * simply a type cast: the actual underlying value is not changed.
467      *
468      * _Available since v2.4.0._
469      */
470     function toPayable(address account) internal pure returns (address payable) {
471         return address(uint160(account));
472     }
473 
474     /**
475      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
476      * `recipient`, forwarding all available gas and reverting on errors.
477      *
478      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
479      * of certain opcodes, possibly making contracts go over the 2300 gas limit
480      * imposed by `transfer`, making them unable to receive funds via
481      * `transfer`. {sendValue} removes this limitation.
482      *
483      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
484      *
485      * IMPORTANT: because control is transferred to `recipient`, care must be
486      * taken to not create reentrancy vulnerabilities. Consider using
487      * {ReentrancyGuard} or the
488      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
489      *
490      * _Available since v2.4.0._
491      */
492     function sendValue(address payable recipient, uint256 amount) internal {
493         require(address(this).balance >= amount, "Address: insufficient balance");
494 
495         // solhint-disable-next-line avoid-call-value
496         (bool success, ) = recipient.call.value(amount)("");
497         require(success, "Address: unable to send value, recipient may have reverted");
498     }
499 }
500 
501 // File: openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol
502 
503 pragma solidity ^0.5.10;
504 
505 
506 
507 
508 /**
509  * @title SafeERC20
510  * @dev Wrappers around ERC20 operations that throw on failure (when the token
511  * contract returns false). Tokens that return no value (and instead revert or
512  * throw on failure) are also supported, non-reverting calls are assumed to be
513  * successful.
514  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
515  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
516  */
517 library SafeERC20 {
518     using SafeMath for uint256;
519     using Address for address;
520 
521     function safeTransfer(IERC20 token, address to, uint256 value) internal {
522         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
523     }
524 
525     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
526         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
527     }
528 
529     function safeApprove(IERC20 token, address spender, uint256 value) internal {
530         // safeApprove should only be called when setting an initial allowance,
531         // or when resetting it to zero. To increase and decrease it, use
532         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
533         // solhint-disable-next-line max-line-length
534         require((value == 0) || (token.allowance(address(this), spender) == 0),
535             "SafeERC20: approve from non-zero to non-zero allowance"
536         );
537         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
538     }
539 
540     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
541         uint256 newAllowance = token.allowance(address(this), spender).add(value);
542         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
543     }
544 
545     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
546         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
547         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
548     }
549 
550     /**
551      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
552      * on the return value: the return value is optional (but if data is returned, it must not be false).
553      * @param token The token targeted by the call.
554      * @param data The call data (encoded using abi.encode or one of its variants).
555      */
556     function callOptionalReturn(IERC20 token, bytes memory data) private {
557         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
558         // we're implementing it ourselves.
559 
560         // A Solidity high level call has three parts:
561         //  1. The target address is checked to verify it contains contract code
562         //  2. The call itself is made, and success asserted
563         //  3. The return value is decoded, which in turn checks the size of the returned data.
564         // solhint-disable-next-line max-line-length
565         require(address(token).isContract(), "SafeERC20: call to non-contract");
566 
567         // solhint-disable-next-line avoid-low-level-calls
568         (bool success, bytes memory returndata) = address(token).call(data);
569         require(success, "SafeERC20: low-level call failed");
570 
571         if (returndata.length > 0) { // Return data is optional
572             // solhint-disable-next-line max-line-length
573             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
574         }
575     }
576 }
577 
578 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
579 
580 pragma solidity ^0.5.10;
581 
582 /**
583  * @dev Contract module which provides a basic access control mechanism, where
584  * there is an account (an owner) that can be granted exclusive access to
585  * specific functions.
586  *
587  * This module is used through inheritance. It will make available the modifier
588  * `onlyOwner`, which can be applied to your functions to restrict their use to
589  * the owner.
590  */
591 contract Ownable is Context {
592     address private _owner;
593 
594     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
595 
596     /**
597      * @dev Initializes the contract setting the deployer as the initial owner.
598      */
599     constructor () internal {
600         _owner = _msgSender();
601         emit OwnershipTransferred(address(0), _owner);
602     }
603 
604     /**
605      * @dev Returns the address of the current owner.
606      */
607     function owner() public view returns (address) {
608         return _owner;
609     }
610 
611     /**
612      * @dev Throws if called by any account other than the owner.
613      */
614     modifier onlyOwner() {
615         require(isOwner(), "Ownable: caller is not the owner");
616         _;
617     }
618 
619     /**
620      * @dev Returns true if the caller is the current owner.
621      */
622     function isOwner() public view returns (bool) {
623         return _msgSender() == _owner;
624     }
625 
626     /**
627      * @dev Leaves the contract without owner. It will not be possible to call
628      * `onlyOwner` functions anymore. Can only be called by the current owner.
629      *
630      * NOTE: Renouncing ownership will leave the contract without an owner,
631      * thereby removing any functionality that is only available to the owner.
632      */
633     function renounceOwnership() public onlyOwner {
634         emit OwnershipTransferred(_owner, address(0));
635         _owner = address(0);
636     }
637 
638     /**
639      * @dev Transfers ownership of the contract to a new account (`newOwner`).
640      * Can only be called by the current owner.
641      */
642     function transferOwnership(address newOwner) public onlyOwner {
643         _transferOwnership(newOwner);
644     }
645 
646     /**
647      * @dev Transfers ownership of the contract to a new account (`newOwner`).
648      */
649     function _transferOwnership(address newOwner) internal {
650         require(newOwner != address(0), "Ownable: new owner is the zero address");
651         emit OwnershipTransferred(_owner, newOwner);
652         _owner = newOwner;
653     }
654 }
655 
656 // File: contracts/Withdrawable.sol
657 
658 pragma solidity ^0.5.10;
659 
660 
661 
662 
663 contract Withdrawable is Ownable {
664     using SafeERC20 for IERC20;
665 
666     function adminWithdraw(address asset) onlyOwner public {
667         uint amount = adminWitrawAllowed(asset);
668         require(amount > 0, "admin witdraw not allowed");
669         if (asset == address(0)) {
670             msg.sender.transfer(amount);
671         } else {
672             IERC20(asset).safeTransfer(msg.sender, amount);
673         }
674     }
675 
676     // can be overridden to disallow withdraw for some token
677     function adminWitrawAllowed(address asset) internal view returns(uint allowedAmount) {
678         allowedAmount = asset == address(0)
679             ? address(this).balance
680             : IERC20(asset).balanceOf(address(this));
681     }
682 }
683 
684 // File: contracts/SimpleStaking.sol
685 
686 pragma solidity ^0.5.10;
687 
688 
689 
690 
691 
692 
693 contract SimpleStaking is Withdrawable, Pausable {
694   using SafeERC20 for IERC20;
695   using SafeMath for uint;
696 
697   IERC20 public token;
698   uint public stakingStart;
699   uint public stakingEnd;
700   uint public interestRate;
701   uint constant interestRateUnit = 1e6;
702 //  uint public accruingDelta = 15 days;
703 //  uint public stakingStepTimespan;
704   uint constant HUGE_TIME = 99999999999999999;
705   uint public adminStopTime = HUGE_TIME;
706   uint public accruingInterval;
707 
708   mapping (address => uint) public lockedAmount;
709   mapping (address => uint) public alreadyWithdrawn;
710   uint public totalLocked;
711   uint public totalWithdrawn;
712 
713   uint public interestReserveBalance;
714 
715   event StakingUpdated(address indexed user, uint userLocked, uint remainingInterestReserve);
716   event Withdraw(address investor, uint amount);
717 
718   constructor (address token_, uint start_, uint end_, uint accruingInterval_, uint rate_) public {
719     token = IERC20(token_);
720     require(end_ > start_, "end must be greater than start");
721     stakingStart = start_;
722     stakingEnd = end_;
723     require(rate_ > 0 && rate_ < interestRateUnit, "rate must be greater than 0 and lower than unit");
724     interestRate = rate_;
725     require(accruingInterval_ > 0, "accruingInterval_ must be greater than 0");
726     require((end_ - start_) % accruingInterval_ == 0, "end time not alligned");
727     require(end_ - start_ >= accruingInterval_, "end - start must be greater than accruingInterval");
728     accruingInterval = accruingInterval_;
729   }
730 
731   modifier afterStart() {
732     require(stakingStart < now, "Only after start");
733     _;
734   }
735 
736   modifier beforeStart() {
737     require(now < stakingStart, "Only before start");
738     _;
739   }
740 
741   function adminWitrawAllowed(address asset) internal view returns(uint) {
742     if (asset != address(token)) {
743       return super.adminWitrawAllowed(asset);
744     } else {
745       uint balance = token.balanceOf(address(this));
746       uint interest = adminStopTime == HUGE_TIME
747         ? _getTotalInterestAmount(totalLocked)
748         : _getAccruedInterest(totalLocked, adminStopTime);
749       uint reserved = totalLocked.add(interest).sub(totalWithdrawn);
750       return reserved < balance ? balance - reserved : 0;
751     }
752   }
753 
754   function _min(uint a, uint b) private pure returns(uint) {
755     return a < b ? a : b;
756   }
757 
758   function _max(uint a, uint b) private pure returns(uint) {
759     return a > b ? a : b;
760   }
761 
762   function adminStop() public onlyOwner {
763     require(adminStopTime == HUGE_TIME, "already admin stopped");
764     require(now < stakingEnd, "already ended");
765     adminStopTime = _max(now, stakingStart);
766   }
767 
768   function _transferTokensFromSender(uint amount) private {
769     require(amount > 0, "Invalid amount");
770     uint expectedBalance = token.balanceOf(address(this)).add(amount);
771     token.safeTransferFrom(msg.sender, address(this), amount);
772     require(token.balanceOf(address(this)) == expectedBalance, "Invalid balance after transfer");
773   }
774 
775   function addFundsForInterests(uint amount) public {
776     _transferTokensFromSender(amount);
777     interestReserveBalance = interestReserveBalance.add(amount);
778   }
779 
780   function getAvailableStaking() external view returns(uint) {
781     return now > stakingStart
782     ? 0
783     : interestReserveBalance.mul(interestRateUnit).div(interestRate).add(interestRateUnit / interestRate).sub(1);
784   }
785 
786   function _getTotalInterestAmount(uint investmentAmount) private view returns(uint) {
787     return investmentAmount.mul(interestRate).div(interestRateUnit);
788   }
789 
790   function getAccruedInterestNow(address user) public view returns(uint) {
791     return getAccruedInterest(user, now);
792   }
793 
794   function getAccruedInterest(address user, uint time) public view returns(uint) {
795     uint totalInterest = _getTotalInterestAmount(lockedAmount[user]);
796     return _getAccruedInterest(totalInterest, time);
797   }
798 
799   function _getAccruedInterest(uint totalInterest, uint time) private view returns(uint) {
800     if (time < stakingStart + accruingInterval) {
801       return 0;
802     } else if ( stakingEnd <= time && time < adminStopTime) {
803       return totalInterest;
804     } else {
805       uint lockTimespanLength = stakingEnd - stakingStart;
806       uint elapsed = _min(time, adminStopTime).sub(stakingStart).div(accruingInterval).mul(accruingInterval);
807       return totalInterest.mul(elapsed).div(lockTimespanLength);
808     }
809   }
810 
811   function addStaking(uint amount) external
812     whenNotPaused
813     beforeStart
814   {
815     require(token.allowance(msg.sender, address(this)) >= amount, "Insufficient allowance");
816     uint interestAmount = _getTotalInterestAmount(amount);
817     require(interestAmount <= interestReserveBalance, "No tokens available for interest");
818 
819     _transferTokensFromSender(amount);
820     interestReserveBalance = interestReserveBalance.sub(interestAmount);
821 
822     uint newLockedAmount = lockedAmount[msg.sender].add(amount);
823     lockedAmount[msg.sender] = newLockedAmount;
824     totalLocked = totalLocked.add(amount);
825 
826     emit StakingUpdated(msg.sender, newLockedAmount, interestReserveBalance);
827   }
828 
829   function withdraw() external
830     afterStart
831     returns(uint)
832   {
833     uint locked = lockedAmount[msg.sender];
834     uint withdrawn = alreadyWithdrawn[msg.sender];
835     uint accruedInterest = getAccruedInterest(msg.sender, now);
836     uint unlockedAmount = now < _min(stakingEnd, adminStopTime) ? 0 : locked;
837 
838     uint accrued = accruedInterest + unlockedAmount;
839     require(accrued > withdrawn, "nothing to withdraw");
840     uint toTransfer = accrued.sub(withdrawn);
841 
842     alreadyWithdrawn[msg.sender] = withdrawn.add(toTransfer);
843     totalWithdrawn = totalWithdrawn.add(toTransfer);
844     token.safeTransfer(msg.sender, toTransfer);
845     emit Withdraw(msg.sender, toTransfer);
846 
847     return toTransfer;
848   }
849 }