1 // File: contracts/libs/math/SafeMath.sol
2 
3 pragma solidity 0.5.15;
4 
5 /**
6  * @dev Wrappers over Solidity's arithmetic operations with added overflow
7  * checks.
8  *
9  * Arithmetic operations in Solidity wrap on overflow. This can easily result
10  * in bugs, because programmers usually assume that an overflow raises an
11  * error, which is the standard behavior in high level programming languages.
12  * `SafeMath` restores this intuition by reverting the transaction when an
13  * operation overflows.
14  *
15  * Using this library instead of the unchecked operations eliminates an entire
16  * class of bugs, so it's recommended to use it always.
17  */
18 library SafeMath {
19     uint constant TEN18 = 10**18;
20 
21     /**
22      * @dev Returns the addition of two unsigned integers, reverting on
23      * overflow.
24      *
25      * Counterpart to Solidity's `+` operator.
26      *
27      * Requirements:
28      * - Addition cannot overflow.
29      */
30     function add(uint256 a, uint256 b) internal pure returns (uint256) {
31         uint256 c = a + b;
32         require(c >= a, "SafeMath: addition overflow");
33 
34         return c;
35     }
36 
37     /**
38      * @dev Returns the subtraction of two unsigned integers, reverting on
39      * overflow (when the result is negative).
40      *
41      * Counterpart to Solidity's `-` operator.
42      *
43      * Requirements:
44      * - Subtraction cannot overflow.
45      */
46     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
47         return sub(a, b, "SafeMath: subtraction overflow");
48     }
49 
50     /**
51      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
52      * overflow (when the result is negative).
53      *
54      * Counterpart to Solidity's `-` operator.
55      *
56      * Requirements:
57      * - Subtraction cannot overflow.
58      *
59      * _Available since v2.4.0._
60      */
61     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
62         require(b <= a, errorMessage);
63         uint256 c = a - b;
64 
65         return c;
66     }
67 
68     /**
69      * @dev Returns the multiplication of two unsigned integers, reverting on
70      * overflow.
71      *
72      * Counterpart to Solidity's `*` operator.
73      *
74      * Requirements:
75      * - Multiplication cannot overflow.
76      */
77     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
78         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
79         // benefit is lost if 'b' is also tested.
80         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
81         if (a == 0) {
82             return 0;
83         }
84 
85         uint256 c = a * b;
86         require(c / a == b, "SafeMath: multiplication overflow");
87 
88         return c;
89     }
90 
91     /**
92      * @dev Returns the integer division of two unsigned integers. Reverts on
93      * division by zero. The result is rounded towards zero.
94      *
95      * Counterpart to Solidity's `/` operator. Note: this function uses a
96      * `revert` opcode (which leaves remaining gas untouched) while Solidity
97      * uses an invalid opcode to revert (consuming all remaining gas).
98      *
99      * Requirements:
100      * - The divisor cannot be zero.
101      */
102     function div(uint256 a, uint256 b) internal pure returns (uint256) {
103         return div(a, b, "SafeMath: division by zero");
104     }
105 
106     /**
107      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
108      * division by zero. The result is rounded towards zero.
109      *
110      * Counterpart to Solidity's `/` operator. Note: this function uses a
111      * `revert` opcode (which leaves remaining gas untouched) while Solidity
112      * uses an invalid opcode to revert (consuming all remaining gas).
113      *
114      * Requirements:
115      * - The divisor cannot be zero.
116      *
117      * _Available since v2.4.0._
118      */
119     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
120         // Solidity only automatically asserts when dividing by 0
121         require(b > 0, errorMessage);
122         uint256 c = a / b;
123         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
124 
125         return c;
126     }
127 
128     /**
129      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
130      * Reverts when dividing by zero.
131      *
132      * Counterpart to Solidity's `%` operator. This function uses a `revert`
133      * opcode (which leaves remaining gas untouched) while Solidity uses an
134      * invalid opcode to revert (consuming all remaining gas).
135      *
136      * Requirements:
137      * - The divisor cannot be zero.
138      */
139     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
140         return mod(a, b, "SafeMath: modulo by zero");
141     }
142 
143     /**
144      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
145      * Reverts with custom message when dividing by zero.
146      *
147      * Counterpart to Solidity's `%` operator. This function uses a `revert`
148      * opcode (which leaves remaining gas untouched) while Solidity uses an
149      * invalid opcode to revert (consuming all remaining gas).
150      *
151      * Requirements:
152      * - The divisor cannot be zero.
153      *
154      * _Available since v2.4.0._
155      */
156     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
157         require(b != 0, errorMessage);
158         return a % b;
159     }
160 }
161 
162 // File: contracts/libs/math/Math.sol
163 
164 pragma solidity 0.5.15;
165 
166 /**
167  * @dev Standard math utilities missing in the Solidity language.
168  */
169 library Math {
170     /**
171      * @dev Returns the largest of two numbers.
172      */
173     function max(uint256 a, uint256 b) internal pure returns (uint256) {
174         return a >= b ? a : b;
175     }
176 
177     /**
178      * @dev Returns the smallest of two numbers.
179      */
180     function min(uint256 a, uint256 b) internal pure returns (uint256) {
181         return a < b ? a : b;
182     }
183 
184     /**
185      * @dev Returns the average of two numbers. The result is rounded towards
186      * zero.
187      */
188     function average(uint256 a, uint256 b) internal pure returns (uint256) {
189         // (a + b) / 2 can overflow, so we distribute
190         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
191     }
192 }
193 
194 // File: contracts/libs/utils/Address.sol
195 
196 pragma solidity 0.5.15;
197 
198 /**
199  * @dev Collection of functions related to the address type
200  */
201 library Address {
202     /**
203      * @dev Returns true if `account` is a contract.
204      *
205      * This test is non-exhaustive, and there may be false-negatives: during the
206      * execution of a contract's constructor, its address will be reported as
207      * not containing a contract.
208      *
209      * IMPORTANT: It is unsafe to assume that an address for which this
210      * function returns false is an externally-owned account (EOA) and not a
211      * contract.
212      */
213     function isContract(address account) internal view returns (bool) {
214         // This method relies in extcodesize, which returns 0 for contracts in
215         // construction, since the code is only stored at the end of the
216         // constructor execution.
217 
218         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
219         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
220         // for accounts without code, i.e. `keccak256('')`
221         bytes32 codehash;
222         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
223         // solhint-disable-next-line no-inline-assembly
224         assembly { codehash := extcodehash(account) }
225         return (codehash != 0x0 && codehash != accountHash);
226     }
227 
228     /**
229      * @dev Converts an `address` into `address payable`. Note that this is
230      * simply a type cast: the actual underlying value is not changed.
231      *
232      * _Available since v2.4.0._
233      */
234     function toPayable(address account) internal pure returns (address payable) {
235         return address(uint160(account));
236     }
237 
238     /**
239      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
240      * `recipient`, forwarding all available gas and reverting on errors.
241      *
242      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
243      * of certain opcodes, possibly making contracts go over the 2300 gas limit
244      * imposed by `transfer`, making them unable to receive funds via
245      * `transfer`. {sendValue} removes this limitation.
246      *
247      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
248      *
249      * IMPORTANT: because control is transferred to `recipient`, care must be
250      * taken to not create reentrancy vulnerabilities. Consider using
251      * {ReentrancyGuard} or the
252      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
253      *
254      * _Available since v2.4.0._
255      */
256     function sendValue(address payable recipient, uint256 amount) internal {
257         require(address(this).balance >= amount, "Address: insufficient balance");
258 
259         // solhint-disable-next-line avoid-call-value
260         (bool success, ) = recipient.call.value(amount)("");
261         require(success, "Address: unable to send value, recipient may have reverted");
262     }
263 }
264 
265 // File: contracts/libs/utils/Arrays.sol
266 
267 pragma solidity 0.5.15;
268 
269 
270 /**
271  * @dev Collection of functions related to array types.
272  */
273 library Arrays {
274    /**
275      * @dev Searches a sorted `array` and returns the first index that contains
276      * a value greater or equal to `element`. If no such index exists (i.e. all
277      * values in the array are strictly less than `element`), the array length is
278      * returned. Time complexity O(log n).
279      *
280      * `array` is expected to be sorted in ascending order, and to contain no
281      * repeated elements.
282      */
283     function findUpperBound(uint256[] storage array, uint256 element) internal view returns (uint256) {
284         if (array.length == 0) {
285             return 0;
286         }
287 
288         uint256 low = 0;
289         uint256 high = array.length;
290 
291         while (low < high) {
292             uint256 mid = Math.average(low, high);
293 
294             // Note that mid will always be strictly less than high (i.e. it will be a valid array index)
295             // because Math.average rounds down (it does integer division with truncation).
296             if (array[mid] > element) {
297                 high = mid;
298             } else {
299                 low = mid + 1;
300             }
301         }
302 
303         // At this point `low` is the exclusive upper bound. We will return the inclusive upper bound.
304         if (low > 0 && array[low - 1] == element) {
305             return low - 1;
306         } else {
307             return low;
308         }
309     }
310 }
311 
312 // File: contracts/libs/utils/ReentrancyGuard.sol
313 
314 pragma solidity 0.5.15;
315 
316 /**
317  * @dev Contract module that helps prevent reentrant calls to a function.
318  *
319  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
320  * available, which can be applied to functions to make sure there are no nested
321  * (reentrant) calls to them.
322  *
323  * Note that because there is a single `nonReentrant` guard, functions marked as
324  * `nonReentrant` may not call one another. This can be worked around by making
325  * those functions `private`, and then adding `external` `nonReentrant` entry
326  * points to them.
327  */
328 contract ReentrancyGuard {
329     // counter to allow mutex lock with only one SSTORE operation
330     uint256 private _guardCounter;
331 
332     constructor () internal {
333         // The counter starts at one to prevent changing it from zero to a non-zero
334         // value, which is a more expensive operation.
335         _guardCounter = 1;
336     }
337 
338     /**
339      * @dev Prevents a contract from calling itself, directly or indirectly.
340      * Calling a `nonReentrant` function from another `nonReentrant`
341      * function is not supported. It is possible to prevent this from happening
342      * by making the `nonReentrant` function external, and make it call a
343      * `private` function that does the actual work.
344      */
345     modifier nonReentrant() {
346         _guardCounter += 1;
347         uint256 localCounter = _guardCounter;
348         _;
349         require(localCounter == _guardCounter, "ReentrancyGuard: reentrant call");
350     }
351 }
352 
353 // File: contracts/libs/ownership/Ownable.sol
354 
355 pragma solidity 0.5.15;
356 
357 /**
358  * @dev Contract module which provides a basic access control mechanism, where
359  * there is an account (an owner) that can be granted exclusive access to
360  * specific functions.
361  *
362  * This module is used through inheritance. It will make available the modifier
363  * `onlyOwner`, which can be applied to your functions to restrict their use to
364  * the owner.
365  */
366 contract Ownable {
367     address private _owner;
368 
369     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
370 
371     /**
372      * @dev Initializes the contract setting the deployer as the initial owner.
373      */
374     constructor () internal {
375         _owner = msg.sender;
376         emit OwnershipTransferred(address(0), _owner);
377     }
378 
379     /**
380      * @dev Returns the address of the current owner.
381      */
382     function owner() public view returns (address) {
383         return _owner;
384     }
385 
386     /**
387      * @dev Throws if called by any account other than the owner.
388      */
389     modifier onlyOwner() {
390         require(isOwner(), "Ownable: caller is not the owner");
391         _;
392     }
393 
394     /**
395      * @dev Returns true if the caller is the current owner.
396      */
397     function isOwner() public view returns (bool) {
398         return msg.sender == _owner;
399     }
400 
401     /**
402      * @dev Leaves the contract without owner. It will not be possible to call
403      * `onlyOwner` functions anymore. Can only be called by the current owner.
404      *
405      * NOTE: Renouncing ownership will leave the contract without an owner,
406      * thereby removing any functionality that is only available to the owner.
407      */
408     function renounceOwnership() public onlyOwner {
409         emit OwnershipTransferred(_owner, address(0));
410         _owner = address(0);
411     }
412 
413     /**
414      * @dev Transfers ownership of the contract to a new account (`newOwner`).
415      * Can only be called by the current owner.
416      */
417     function transferOwnership(address newOwner) public onlyOwner {
418         _transferOwnership(newOwner);
419     }
420 
421     /**
422      * @dev Transfers ownership of the contract to a new account (`newOwner`).
423      */
424     function _transferOwnership(address newOwner) internal {
425         require(newOwner != address(0), "Ownable: new owner is the zero address");
426         emit OwnershipTransferred(_owner, newOwner);
427         _owner = newOwner;
428     }
429 }
430 
431 // File: contracts/libs/lifecycle/Pausable.sol
432 
433 pragma solidity 0.5.15;
434 
435 
436 /**
437  * @dev Contract module which allows children to implement an emergency stop
438  * mechanism that can be triggered by an authorized account.
439  *
440  * This module is used through inheritance. It will make available the
441  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
442  * the functions of your contract. Note that they will not be pausable by
443  * simply including this module, only once the modifiers are put in place.
444  */
445 contract Pausable is Ownable {
446     /**
447      * @dev Emitted when the pause is triggered by a pauser (`account`).
448      */
449     event Paused(address account);
450 
451     /**
452      * @dev Emitted when the pause is lifted by a pauser (`account`).
453      */
454     event Unpaused(address account);
455 
456     bool private _paused;
457 
458     /**
459      * @dev Initializes the contract in unpaused state. Assigns the Pauser role
460      * to the deployer.
461      */
462     constructor () internal {
463         _paused = true;
464     }
465 
466     /**
467      * @dev Returns true if the contract is paused, and false otherwise.
468      */
469     function paused() public view returns (bool) {
470         return _paused;
471     }
472 
473     /**
474      * @dev Modifier to make a function callable only when the contract is not paused.
475      */
476     modifier whenNotPaused() {
477         require(!_paused, "Pausable: paused");
478         _;
479     }
480 
481     /**
482      * @dev Modifier to make a function callable only when the contract is paused.
483      */
484     modifier whenPaused() {
485         require(_paused, "Pausable: not paused");
486         _;
487     }
488 
489     /**
490      * @dev Called by a owner to pause, triggers stopped state.
491      */
492     function pause() public onlyOwner whenNotPaused {
493         _paused = true;
494         emit Paused(msg.sender);
495     }
496 
497     /**
498      * @dev Called by a owner to unpause, returns to normal state.
499      */
500     function unpause() public onlyOwner whenPaused {
501         _paused = false;
502         emit Unpaused(msg.sender);
503     }
504 }
505 
506 // File: contracts/token/ERC20/IERC20.sol
507 
508 pragma solidity ^0.5.0;
509 
510 /**
511  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
512  * the optional functions; to access them see {ERC20Detailed}.
513  */
514 interface IERC20 {
515     /**
516      * @dev Returns the amount of tokens in existence.
517      */
518     function totalSupply() external view returns (uint256);
519 
520     /**
521      * @dev Returns the amount of tokens owned by `account`.
522      */
523     function balanceOf(address account) external view returns (uint256);
524 
525     /**
526      * @dev Moves `amount` tokens from the caller's account to `recipient`.
527      *
528      * Returns a boolean value indicating whether the operation succeeded.
529      *
530      * Emits a {Transfer} event.
531      */
532     function transfer(address recipient, uint256 amount) external returns (bool);
533 
534     /**
535      * @dev Returns the remaining number of tokens that `spender` will be
536      * allowed to spend on behalf of `owner` through {transferFrom}. This is
537      * zero by default.
538      *
539      * This value changes when {approve} or {transferFrom} are called.
540      */
541     function allowance(address owner, address spender) external view returns (uint256);
542 
543     /**
544      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
545      *
546      * Returns a boolean value indicating whether the operation succeeded.
547      *
548      * IMPORTANT: Beware that changing an allowance with this method brings the risk
549      * that someone may use both the old and the new allowance by unfortunate
550      * transaction ordering. One possible solution to mitigate this race
551      * condition is to first reduce the spender's allowance to 0 and set the
552      * desired value afterwards:
553      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
554      *
555      * Emits an {Approval} event.
556      */
557     function approve(address spender, uint256 amount) external returns (bool);
558 
559     /**
560      * @dev Moves `amount` tokens from `sender` to `recipient` using the
561      * allowance mechanism. `amount` is then deducted from the caller's
562      * allowance.
563      *
564      * Returns a boolean value indicating whether the operation succeeded.
565      *
566      * Emits a {Transfer} event.
567      */
568     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
569 
570     /**
571      * @dev Emitted when `value` tokens are moved from one account (`from`) to
572      * another (`to`).
573      *
574      * Note that `value` may be zero.
575      */
576     event Transfer(address indexed from, address indexed to, uint256 value);
577 
578     /**
579      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
580      * a call to {approve}. `value` is the new allowance.
581      */
582     event Approval(address indexed owner, address indexed spender, uint256 value);
583 }
584 
585 // File: contracts/StakingContract.sol
586 
587 pragma solidity 0.5.15;
588 
589 
590 
591 
592 
593 
594 
595 
596 contract StakingContract is Pausable, ReentrancyGuard {
597 
598     using SafeMath for uint256;
599     using Math for uint256;
600     using Address for address;
601     using Arrays for uint256[];
602 
603     enum Status {Setup, Running, RewardsDisabled}
604 
605     // EVENTS
606     event StakeDeposited(address indexed account, uint256 amount);
607     event WithdrawInitiated(address indexed account, uint256 amount);
608     event WithdrawExecuted(address indexed account, uint256 amount, uint256 reward);
609 
610     // STRUCT DECLARATIONS
611     struct StakeDeposit {
612         uint256 amount;
613         uint256 startDate;
614         uint256 endDate;
615         uint256 startCheckpointIndex;
616         uint256 endCheckpointIndex;
617         bool exists;
618     }
619 
620     struct SetupState {
621         bool staking;
622         bool rewards;
623     }
624 
625     struct StakingLimitConfig {
626         uint256 maxAmount;
627         uint256 initialAmount;
628         uint256 daysInterval;
629         uint256 maxIntervals;
630         uint256 unstakingPeriod;
631     }
632 
633     struct BaseRewardCheckpoint {
634         uint256 baseRewardIndex;
635         uint256 startTimestamp;
636         uint256 endTimestamp;
637         uint256 fromBlock;
638     }
639 
640     struct BaseReward {
641         uint256 anualRewardRate;
642         uint256 lowerBound;
643         uint256 upperBound;
644     }
645 
646     struct RewardConfig {
647         BaseReward[] baseRewards;
648         uint256[] upperBounds;
649         uint256 multiplier; // percent of the base reward applicable
650     }
651 
652     // CONTRACT STATE VARIABLES
653     IERC20 public token;
654     Status public currentStatus;
655 
656     SetupState public setupState;
657     StakingLimitConfig public stakingLimitConfig;
658     RewardConfig public rewardConfig;
659 
660     address public rewardsAddress;
661     uint256 public launchTimestamp;
662     uint256 public currentTotalStake;
663 
664     mapping(address => StakeDeposit) private _stakeDeposits;
665     BaseRewardCheckpoint[] private _baseRewardHistory;
666 
667     // MODIFIERS
668     modifier guardMaxStakingLimit(uint256 amount)
669     {
670         uint256 resultedStakedAmount = currentTotalStake.add(amount);
671         uint256 currentStakingLimit = _computeCurrentStakingLimit();
672         require(resultedStakedAmount <= currentStakingLimit, "[Deposit] Your deposit would exceed the current staking limit");
673         _;
674     }
675 
676     modifier guardForPrematureWithdrawal()
677     {
678         uint256 intervalsPassed = _getIntervalsPassed();
679         require(intervalsPassed >= stakingLimitConfig.maxIntervals, "[Withdraw] Not enough days passed");
680         _;
681     }
682 
683     modifier onlyContract(address account)
684     {
685         require(account.isContract(), "[Validation] The address does not contain a contract");
686         _;
687     }
688 
689     modifier onlyDuringSetup()
690     {
691         require(currentStatus == Status.Setup, "[Lifecycle] Setup is already done");
692         _;
693     }
694 
695     modifier onlyAfterSetup()
696     {
697         require(currentStatus != Status.Setup, "[Lifecycle] Setup is not done");
698         _;
699     }
700 
701     // PUBLIC FUNCTIONS
702     constructor(address _token, address _rewardsAddress)
703     onlyContract(_token)
704     public
705     {
706         require(_rewardsAddress != address(0), "[Validation] _rewardsAddress is the zero address");
707 
708         token = IERC20(_token);
709         rewardsAddress = _rewardsAddress;
710         launchTimestamp = now;
711         currentStatus = Status.Setup;
712     }
713 
714     function deposit(uint256 amount)
715     public
716     nonReentrant
717     onlyAfterSetup
718     whenNotPaused
719     guardMaxStakingLimit(amount)
720     {
721         require(amount > 0, "[Validation] The stake deposit has to be larger than 0");
722         require(!_stakeDeposits[msg.sender].exists, "[Deposit] You already have a stake");
723 
724         StakeDeposit storage stakeDeposit = _stakeDeposits[msg.sender];
725         stakeDeposit.amount = stakeDeposit.amount.add(amount);
726         stakeDeposit.startDate = now;
727         stakeDeposit.startCheckpointIndex = _baseRewardHistory.length - 1;
728         stakeDeposit.exists = true;
729 
730         currentTotalStake = currentTotalStake.add(amount);
731         _updateBaseRewardHistory();
732 
733         // Transfer the Tokens to this contract
734         require(token.transferFrom(msg.sender, address(this), amount), "[Deposit] Something went wrong during the token transfer");
735         emit StakeDeposited(msg.sender, amount);
736     }
737 
738     function initiateWithdrawal()
739     external
740     whenNotPaused
741     onlyAfterSetup
742     guardForPrematureWithdrawal
743     {
744         StakeDeposit storage stakeDeposit = _stakeDeposits[msg.sender];
745         require(stakeDeposit.exists && stakeDeposit.amount != 0, "[Initiate Withdrawal] There is no stake deposit for this account");
746         require(stakeDeposit.endDate == 0, "[Initiate Withdrawal] You already initiated the withdrawal");
747 
748         stakeDeposit.endDate = now;
749         stakeDeposit.endCheckpointIndex = _baseRewardHistory.length - 1;
750         emit WithdrawInitiated(msg.sender, stakeDeposit.amount);
751     }
752 
753     function executeWithdrawal()
754     external
755     nonReentrant
756     whenNotPaused
757     onlyAfterSetup
758     {
759         StakeDeposit storage stakeDeposit = _stakeDeposits[msg.sender];
760         require(stakeDeposit.exists && stakeDeposit.amount != 0, "[Withdraw] There is no stake deposit for this account");
761         require(stakeDeposit.endDate != 0, "[Withdraw] Withdraw is not initialized");
762         // validate enough days have passed from initiating the withdrawal
763         uint256 daysPassed = (now - stakeDeposit.endDate) / 1 days;
764         require(stakingLimitConfig.unstakingPeriod <= daysPassed, "[Withdraw] The unstaking period did not pass");
765 
766         uint256 amount = stakeDeposit.amount;
767         uint256 reward = _computeReward(stakeDeposit);
768 
769         stakeDeposit.amount = 0;
770 
771         currentTotalStake = currentTotalStake.sub(amount);
772         _updateBaseRewardHistory();
773 
774         require(token.transfer(msg.sender, amount), "[Withdraw] Something went wrong while transferring your initial deposit");
775         require(token.transferFrom(rewardsAddress, msg.sender, reward), "[Withdraw] Something went wrong while transferring your reward");
776 
777         emit WithdrawExecuted(msg.sender, amount, reward);
778     }
779 
780     function toggleRewards(bool enabled)
781     external
782     onlyOwner
783     onlyAfterSetup
784     {
785         Status newStatus = enabled ? Status.Running : Status.RewardsDisabled;
786         require(currentStatus != newStatus, "[ToggleRewards] This status is already set");
787 
788         uint256 index;
789 
790         if (newStatus == Status.RewardsDisabled) {
791             index = rewardConfig.baseRewards.length - 1;
792         }
793 
794         if (newStatus == Status.Running) {
795             index = _computeCurrentBaseReward();
796         }
797 
798         _insertNewCheckpoint(index);
799 
800         currentStatus = newStatus;
801     }
802 
803     // VIEW FUNCTIONS FOR HELPING THE USER AND CLIENT INTERFACE
804     function currentStakingLimit()
805     public
806     onlyAfterSetup
807     view
808     returns (uint256)
809     {
810         return _computeCurrentStakingLimit();
811     }
812 
813     function currentReward(address account)
814     external
815     onlyAfterSetup
816     view
817     returns (uint256 initialDeposit, uint256 reward)
818     {
819         require(_stakeDeposits[account].exists && _stakeDeposits[account].amount != 0, "[Validation] This account doesn't have a stake deposit");
820 
821         StakeDeposit memory stakeDeposit = _stakeDeposits[account];
822         stakeDeposit.endDate = now;
823 
824         return (stakeDeposit.amount, _computeReward(stakeDeposit));
825     }
826 
827     function getStakeDeposit()
828     external
829     onlyAfterSetup
830     view
831     returns (uint256 amount, uint256 startDate, uint256 endDate, uint256 startCheckpointIndex, uint256 endCheckpointIndex)
832     {
833         require(_stakeDeposits[msg.sender].exists, "[Validation] This account doesn't have a stake deposit");
834         StakeDeposit memory s = _stakeDeposits[msg.sender];
835 
836         return (s.amount, s.startDate, s.endDate, s.startCheckpointIndex, s.endCheckpointIndex);
837     }
838 
839     function baseRewardsLength()
840     external
841     onlyAfterSetup
842     view
843     returns (uint256)
844     {
845         return rewardConfig.baseRewards.length;
846     }
847 
848     function baseReward(uint256 index)
849     external
850     onlyAfterSetup
851     view
852     returns (uint256, uint256, uint256)
853     {
854         BaseReward memory br = rewardConfig.baseRewards[index];
855 
856         return (br.anualRewardRate, br.lowerBound, br.upperBound);
857     }
858 
859     function baseRewardHistoryLength()
860     external
861     view
862     returns (uint256)
863     {
864         return _baseRewardHistory.length;
865     }
866 
867     function baseRewardHistory(uint256 index)
868     external
869     onlyAfterSetup
870     view
871     returns (uint256, uint256, uint256, uint256)
872     {
873         BaseRewardCheckpoint memory c = _baseRewardHistory[index];
874 
875         return (c.baseRewardIndex, c.startTimestamp, c.endTimestamp, c.fromBlock);
876     }
877 
878     // OWNER SETUP
879     function setupStakingLimit(uint256 maxAmount, uint256 initialAmount, uint256 daysInterval, uint256 unstakingPeriod)
880     external
881     onlyOwner
882     whenPaused
883     onlyDuringSetup
884     {
885         require(maxAmount > 0 && initialAmount > 0 && daysInterval > 0 && unstakingPeriod >= 0, "[Validation] Some parameters are 0");
886         require(maxAmount.mod(initialAmount) == 0, "[Validation] maxAmount should be a multiple of initialAmount");
887 
888         uint256 maxIntervals = maxAmount.div(initialAmount);
889         // set the staking limits
890         stakingLimitConfig.maxAmount = maxAmount;
891         stakingLimitConfig.initialAmount = initialAmount;
892         stakingLimitConfig.daysInterval = daysInterval;
893         stakingLimitConfig.unstakingPeriod = unstakingPeriod;
894         stakingLimitConfig.maxIntervals = maxIntervals;
895 
896         setupState.staking = true;
897         _updateSetupState();
898     }
899 
900     function setupRewards(
901         uint256 multiplier,
902         uint256[] calldata anualRewardRates,
903         uint256[] calldata lowerBounds,
904         uint256[] calldata upperBounds
905     )
906     external
907     onlyOwner
908     whenPaused
909     onlyDuringSetup
910     {
911         _validateSetupRewardsParameters(multiplier, anualRewardRates, lowerBounds, upperBounds);
912 
913         // Setup rewards
914         rewardConfig.multiplier = multiplier;
915 
916         for (uint256 i = 0; i < anualRewardRates.length; i++) {
917             _addBaseReward(anualRewardRates[i], lowerBounds[i], upperBounds[i]);
918         }
919 
920         uint256 highestUpperBound = upperBounds[upperBounds.length - 1];
921 
922         // Add the zero annual reward rate
923         _addBaseReward(0, highestUpperBound, highestUpperBound + 10);
924 
925         // initiate baseRewardHistory with the first one which should start from 0
926         _initBaseRewardHistory();
927 
928         setupState.rewards = true;
929         _updateSetupState();
930     }
931 
932     // INTERNAL
933     function _updateSetupState()
934     private
935     {
936         if (!setupState.rewards || !setupState.staking) {
937             return;
938         }
939 
940         currentStatus = Status.Running;
941     }
942 
943     function _computeCurrentStakingLimit()
944     private
945     view
946     returns (uint256)
947     {
948         uint256 intervalsPassed = _getIntervalsPassed();
949         uint256 baseStakingLimit = stakingLimitConfig.initialAmount;
950 
951         uint256 intervals = intervalsPassed.min(stakingLimitConfig.maxIntervals - 1);
952 
953         // initialLimit * ((now - launchMoment) / interval)
954         return baseStakingLimit.add(baseStakingLimit.mul(intervals));
955     }
956 
957     function _getIntervalsPassed()
958     private
959     view
960     returns (uint256)
961     {
962         uint256 daysPassed = (now - launchTimestamp) / 1 days;
963         return daysPassed / stakingLimitConfig.daysInterval;
964     }
965 
966     function _computeReward(StakeDeposit memory stakeDeposit)
967     private
968     view
969     returns (uint256)
970     {
971         uint256 scale = 10 ** 18;
972         (uint256 weightedSum, uint256 stakingPeriod) = _computeRewardRatesWeightedSum(stakeDeposit);
973 
974         if (stakingPeriod == 0) {
975             return 0;
976         }
977 
978         // scaling weightedSum and stakingPeriod because the weightedSum is in the thousands magnitude
979         // and we risk losing detail while rounding
980         weightedSum = weightedSum.mul(scale);
981 
982         uint256 weightedAverage = weightedSum.div(stakingPeriod);
983 
984         // rewardConfig.multiplier is a percentage expressed in 1/10 (a tenth) of a percent hence we divide by 1000
985         uint256 accumulator = rewardConfig.multiplier.mul(weightedSum).div(1000);
986         uint256 effectiveRate = weightedAverage.add(accumulator);
987         uint256 denominator = scale.mul(36500);
988 
989         return stakeDeposit.amount.mul(effectiveRate).mul(stakingPeriod).div(denominator);
990     }
991 
992     function _computeRewardRatesWeightedSum(StakeDeposit memory stakeDeposit)
993     private
994     view
995     returns (uint256, uint256)
996     {
997         uint256 stakingPeriod = (stakeDeposit.endDate - stakeDeposit.startDate) / 1 days;
998         uint256 weight;
999         uint256 rate;
1000 
1001         // The contract never left the first checkpoint
1002         if (stakeDeposit.startCheckpointIndex == stakeDeposit.endCheckpointIndex) {
1003             rate = _baseRewardFromHistoryIndex(stakeDeposit.startCheckpointIndex).anualRewardRate;
1004 
1005             return (rate.mul(stakingPeriod), stakingPeriod);
1006         }
1007 
1008         // Computing the first segment base reward
1009         // User could deposit in the middle of the segment so we need to get the segment from which the user deposited
1010         // to the moment the base reward changes
1011         weight = (_baseRewardHistory[stakeDeposit.startCheckpointIndex].endTimestamp - stakeDeposit.startDate) / 1 days;
1012         rate = _baseRewardFromHistoryIndex(stakeDeposit.startCheckpointIndex).anualRewardRate;
1013         uint256 weightedSum = rate.mul(weight);
1014 
1015         // Starting from the second checkpoint because the first one is already computed
1016         for (uint256 i = stakeDeposit.startCheckpointIndex + 1; i < stakeDeposit.endCheckpointIndex; i++) {
1017             weight = (_baseRewardHistory[i].endTimestamp - _baseRewardHistory[i].startTimestamp) / 1 days;
1018             rate = _baseRewardFromHistoryIndex(i).anualRewardRate;
1019             weightedSum = weightedSum.add(rate.mul(weight));
1020         }
1021 
1022         // Computing the base reward for the last segment
1023         // days between start timestamp of the last checkpoint to the moment he initialized the withdrawal
1024         weight = (stakeDeposit.endDate - _baseRewardHistory[stakeDeposit.endCheckpointIndex].startTimestamp) / 1 days;
1025         rate = _baseRewardFromHistoryIndex(stakeDeposit.endCheckpointIndex).anualRewardRate;
1026         weightedSum = weightedSum.add(weight.mul(rate));
1027 
1028         return (weightedSum, stakingPeriod);
1029     }
1030 
1031     function _addBaseReward(uint256 anualRewardRate, uint256 lowerBound, uint256 upperBound)
1032     private
1033     {
1034         rewardConfig.baseRewards.push(BaseReward(anualRewardRate, lowerBound, upperBound));
1035         rewardConfig.upperBounds.push(upperBound);
1036     }
1037 
1038     function _initBaseRewardHistory()
1039     private
1040     {
1041         require(_baseRewardHistory.length == 0, "[Logical] Base reward history has already been initialized");
1042 
1043         _baseRewardHistory.push(BaseRewardCheckpoint(0, now, 0, block.number));
1044     }
1045 
1046     function _updateBaseRewardHistory()
1047     private
1048     {
1049         if (currentStatus == Status.RewardsDisabled) {
1050             return;
1051         }
1052 
1053         BaseReward memory currentBaseReward = _currentBaseReward();
1054 
1055         // Do nothing if currentTotalStake is in the current base reward bounds
1056         if (currentBaseReward.lowerBound <= currentTotalStake && currentTotalStake <= currentBaseReward.upperBound) {
1057             return;
1058         }
1059 
1060         uint256 newIndex = _computeCurrentBaseReward();
1061         _insertNewCheckpoint(newIndex);
1062     }
1063 
1064     function _insertNewCheckpoint(uint256 newIndex)
1065     private
1066     {
1067         BaseRewardCheckpoint storage oldCheckPoint = _lastBaseRewardCheckpoint();
1068 
1069         if (oldCheckPoint.fromBlock < block.number) {
1070             oldCheckPoint.endTimestamp = now;
1071             _baseRewardHistory.push(BaseRewardCheckpoint(newIndex, now, 0, block.number));
1072         } else {
1073             oldCheckPoint.baseRewardIndex = newIndex;
1074         }
1075     }
1076 
1077     function _currentBaseReward()
1078     private
1079     view
1080     returns (BaseReward memory)
1081     {
1082         // search for the current base reward from current total staked amount
1083         uint256 currentBaseRewardIndex = _lastBaseRewardCheckpoint().baseRewardIndex;
1084 
1085         return rewardConfig.baseRewards[currentBaseRewardIndex];
1086     }
1087 
1088     function _baseRewardFromHistoryIndex(uint256 index)
1089     private
1090     view
1091     returns (BaseReward memory)
1092     {
1093         return rewardConfig.baseRewards[_baseRewardHistory[index].baseRewardIndex];
1094     }
1095 
1096     function _lastBaseRewardCheckpoint()
1097     private
1098     view
1099     returns (BaseRewardCheckpoint storage)
1100     {
1101         return _baseRewardHistory[_baseRewardHistory.length - 1];
1102     }
1103 
1104     function _computeCurrentBaseReward()
1105     private
1106     view
1107     returns (uint256)
1108     {
1109         uint256 index = rewardConfig.upperBounds.findUpperBound(currentTotalStake);
1110 
1111         require(index < rewardConfig.upperBounds.length, "[NotFound] The current total staked is out of bounds");
1112 
1113         return index;
1114     }
1115 
1116     function _validateSetupRewardsParameters
1117     (
1118         uint256 multiplier,
1119         uint256[] memory anualRewardRates,
1120         uint256[] memory lowerBounds,
1121         uint256[] memory upperBounds
1122     )
1123     private
1124     pure
1125     {
1126         require(
1127             anualRewardRates.length > 0 && lowerBounds.length > 0 && upperBounds.length > 0,
1128             "[Validation] All parameters must have at least one element"
1129         );
1130         require(
1131             anualRewardRates.length == lowerBounds.length && lowerBounds.length == upperBounds.length,
1132             "[Validation] All parameters must have the same number of elements"
1133         );
1134         require(lowerBounds[0] == 0, "[Validation] First lower bound should be 0");
1135         require(
1136             (multiplier < 100) && (uint256(100).mod(multiplier) == 0),
1137             "[Validation] Multiplier should be smaller than 100 and divide it equally"
1138         );
1139     }
1140 }