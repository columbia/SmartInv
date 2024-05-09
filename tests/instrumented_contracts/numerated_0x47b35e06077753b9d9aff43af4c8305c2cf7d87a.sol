1 // File: @openzeppelin/contracts/math/SafeMath.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity ^0.6.0;
6 
7 /**
8  * @dev Wrappers over Solidity's arithmetic operations with added overflow
9  * checks.
10  *
11  * Arithmetic operations in Solidity wrap on overflow. This can easily result
12  * in bugs, because programmers usually assume that an overflow raises an
13  * error, which is the standard behavior in high level programming languages.
14  * `SafeMath` restores this intuition by reverting the transaction when an
15  * operation overflows.
16  *
17  * Using this library instead of the unchecked operations eliminates an entire
18  * class of bugs, so it's recommended to use it always.
19  */
20 library SafeMath {
21     /**
22      * @dev Returns the addition of two unsigned integers, reverting on
23      * overflow.
24      *
25      * Counterpart to Solidity's `+` operator.
26      *
27      * Requirements:
28      *
29      * - Addition cannot overflow.
30      */
31     function add(uint256 a, uint256 b) internal pure returns (uint256) {
32         uint256 c = a + b;
33         require(c >= a, "SafeMath: addition overflow");
34 
35         return c;
36     }
37 
38     /**
39      * @dev Returns the subtraction of two unsigned integers, reverting on
40      * overflow (when the result is negative).
41      *
42      * Counterpart to Solidity's `-` operator.
43      *
44      * Requirements:
45      *
46      * - Subtraction cannot overflow.
47      */
48     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
49         return sub(a, b, "SafeMath: subtraction overflow");
50     }
51 
52     /**
53      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
54      * overflow (when the result is negative).
55      *
56      * Counterpart to Solidity's `-` operator.
57      *
58      * Requirements:
59      *
60      * - Subtraction cannot overflow.
61      */
62     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
63         require(b <= a, errorMessage);
64         uint256 c = a - b;
65 
66         return c;
67     }
68 
69     /**
70      * @dev Returns the multiplication of two unsigned integers, reverting on
71      * overflow.
72      *
73      * Counterpart to Solidity's `*` operator.
74      *
75      * Requirements:
76      *
77      * - Multiplication cannot overflow.
78      */
79     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
80         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
81         // benefit is lost if 'b' is also tested.
82         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
83         if (a == 0) {
84             return 0;
85         }
86 
87         uint256 c = a * b;
88         require(c / a == b, "SafeMath: multiplication overflow");
89 
90         return c;
91     }
92 
93     /**
94      * @dev Returns the integer division of two unsigned integers. Reverts on
95      * division by zero. The result is rounded towards zero.
96      *
97      * Counterpart to Solidity's `/` operator. Note: this function uses a
98      * `revert` opcode (which leaves remaining gas untouched) while Solidity
99      * uses an invalid opcode to revert (consuming all remaining gas).
100      *
101      * Requirements:
102      *
103      * - The divisor cannot be zero.
104      */
105     function div(uint256 a, uint256 b) internal pure returns (uint256) {
106         return div(a, b, "SafeMath: division by zero");
107     }
108 
109     /**
110      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
111      * division by zero. The result is rounded towards zero.
112      *
113      * Counterpart to Solidity's `/` operator. Note: this function uses a
114      * `revert` opcode (which leaves remaining gas untouched) while Solidity
115      * uses an invalid opcode to revert (consuming all remaining gas).
116      *
117      * Requirements:
118      *
119      * - The divisor cannot be zero.
120      */
121     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
122         require(b > 0, errorMessage);
123         uint256 c = a / b;
124         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
125 
126         return c;
127     }
128 
129     /**
130      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
131      * Reverts when dividing by zero.
132      *
133      * Counterpart to Solidity's `%` operator. This function uses a `revert`
134      * opcode (which leaves remaining gas untouched) while Solidity uses an
135      * invalid opcode to revert (consuming all remaining gas).
136      *
137      * Requirements:
138      *
139      * - The divisor cannot be zero.
140      */
141     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
142         return mod(a, b, "SafeMath: modulo by zero");
143     }
144 
145     /**
146      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
147      * Reverts with custom message when dividing by zero.
148      *
149      * Counterpart to Solidity's `%` operator. This function uses a `revert`
150      * opcode (which leaves remaining gas untouched) while Solidity uses an
151      * invalid opcode to revert (consuming all remaining gas).
152      *
153      * Requirements:
154      *
155      * - The divisor cannot be zero.
156      */
157     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
158         require(b != 0, errorMessage);
159         return a % b;
160     }
161 }
162 
163 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
164 
165 
166 pragma solidity ^0.6.0;
167 
168 /**
169  * @dev Interface of the ERC20 standard as defined in the EIP.
170  */
171 interface IERC20 {
172     /**
173      * @dev Returns the amount of tokens in existence.
174      */
175     function totalSupply() external view returns (uint256);
176 
177     /**
178      * @dev Returns the amount of tokens owned by `account`.
179      */
180     function balanceOf(address account) external view returns (uint256);
181 
182     /**
183      * @dev Moves `amount` tokens from the caller's account to `recipient`.
184      *
185      * Returns a boolean value indicating whether the operation succeeded.
186      *
187      * Emits a {Transfer} event.
188      */
189     function transfer(address recipient, uint256 amount) external returns (bool);
190 
191     /**
192      * @dev Returns the remaining number of tokens that `spender` will be
193      * allowed to spend on behalf of `owner` through {transferFrom}. This is
194      * zero by default.
195      *
196      * This value changes when {approve} or {transferFrom} are called.
197      */
198     function allowance(address owner, address spender) external view returns (uint256);
199 
200     /**
201      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
202      *
203      * Returns a boolean value indicating whether the operation succeeded.
204      *
205      * IMPORTANT: Beware that changing an allowance with this method brings the risk
206      * that someone may use both the old and the new allowance by unfortunate
207      * transaction ordering. One possible solution to mitigate this race
208      * condition is to first reduce the spender's allowance to 0 and set the
209      * desired value afterwards:
210      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
211      *
212      * Emits an {Approval} event.
213      */
214     function approve(address spender, uint256 amount) external returns (bool);
215 
216     /**
217      * @dev Moves `amount` tokens from `sender` to `recipient` using the
218      * allowance mechanism. `amount` is then deducted from the caller's
219      * allowance.
220      *
221      * Returns a boolean value indicating whether the operation succeeded.
222      *
223      * Emits a {Transfer} event.
224      */
225     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
226 
227     /**
228      * @dev Emitted when `value` tokens are moved from one account (`from`) to
229      * another (`to`).
230      *
231      * Note that `value` may be zero.
232      */
233     event Transfer(address indexed from, address indexed to, uint256 value);
234 
235     /**
236      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
237      * a call to {approve}. `value` is the new allowance.
238      */
239     event Approval(address indexed owner, address indexed spender, uint256 value);
240 }
241 
242 // File: @openzeppelin/contracts/utils/Address.sol
243 
244 pragma solidity ^0.6.2;
245 
246 /**
247  * @dev Collection of functions related to the address type
248  */
249 library Address {
250     /**
251      * @dev Returns true if `account` is a contract.
252      *
253      * [IMPORTANT]
254      * ====
255      * It is unsafe to assume that an address for which this function returns
256      * false is an externally-owned account (EOA) and not a contract.
257      *
258      * Among others, `isContract` will return false for the following
259      * types of addresses:
260      *
261      *  - an externally-owned account
262      *  - a contract in construction
263      *  - an address where a contract will be created
264      *  - an address where a contract lived, but was destroyed
265      * ====
266      */
267     function isContract(address account) internal view returns (bool) {
268         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
269         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
270         // for accounts without code, i.e. `keccak256('')`
271         bytes32 codehash;
272         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
273         // solhint-disable-next-line no-inline-assembly
274         assembly { codehash := extcodehash(account) }
275         return (codehash != accountHash && codehash != 0x0);
276     }
277 
278     /**
279      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
280      * `recipient`, forwarding all available gas and reverting on errors.
281      *
282      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
283      * of certain opcodes, possibly making contracts go over the 2300 gas limit
284      * imposed by `transfer`, making them unable to receive funds via
285      * `transfer`. {sendValue} removes this limitation.
286      *
287      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
288      *
289      * IMPORTANT: because control is transferred to `recipient`, care must be
290      * taken to not create reentrancy vulnerabilities. Consider using
291      * {ReentrancyGuard} or the
292      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
293      */
294     function sendValue(address payable recipient, uint256 amount) internal {
295         require(address(this).balance >= amount, "Address: insufficient balance");
296 
297         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
298         (bool success, ) = recipient.call{ value: amount }("");
299         require(success, "Address: unable to send value, recipient may have reverted");
300     }
301 
302     /**
303      * @dev Performs a Solidity function call using a low level `call`. A
304      * plain`call` is an unsafe replacement for a function call: use this
305      * function instead.
306      *
307      * If `target` reverts with a revert reason, it is bubbled up by this
308      * function (like regular Solidity function calls).
309      *
310      * Returns the raw returned data. To convert to the expected return value,
311      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
312      *
313      * Requirements:
314      *
315      * - `target` must be a contract.
316      * - calling `target` with `data` must not revert.
317      *
318      * _Available since v3.1._
319      */
320     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
321       return functionCall(target, data, "Address: low-level call failed");
322     }
323 
324     /**
325      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
326      * `errorMessage` as a fallback revert reason when `target` reverts.
327      *
328      * _Available since v3.1._
329      */
330     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
331         return _functionCallWithValue(target, data, 0, errorMessage);
332     }
333 
334     /**
335      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
336      * but also transferring `value` wei to `target`.
337      *
338      * Requirements:
339      *
340      * - the calling contract must have an ETH balance of at least `value`.
341      * - the called Solidity function must be `payable`.
342      *
343      * _Available since v3.1._
344      */
345     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
346         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
347     }
348 
349     /**
350      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
351      * with `errorMessage` as a fallback revert reason when `target` reverts.
352      *
353      * _Available since v3.1._
354      */
355     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
356         require(address(this).balance >= value, "Address: insufficient balance for call");
357         return _functionCallWithValue(target, data, value, errorMessage);
358     }
359 
360     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
361         require(isContract(target), "Address: call to non-contract");
362 
363         // solhint-disable-next-line avoid-low-level-calls
364         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
365         if (success) {
366             return returndata;
367         } else {
368             // Look for revert reason and bubble it up if present
369             if (returndata.length > 0) {
370                 // The easiest way to bubble the revert reason is using memory via assembly
371 
372                 // solhint-disable-next-line no-inline-assembly
373                 assembly {
374                     let returndata_size := mload(returndata)
375                     revert(add(32, returndata), returndata_size)
376                 }
377             } else {
378                 revert(errorMessage);
379             }
380         }
381     }
382 }
383 
384 // File: contracts/Ownable.sol
385 
386 pragma solidity 0.6.10;
387 
388 /**
389  * @title Ownable
390  * @dev The Ownable contract has an owner address, and provides basic authorization control
391  * functions, this simplifies the implementation of "user permissions".
392  */
393 contract Ownable {
394     address private _owner;
395 
396     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
397 
398     /**
399      * @dev The Ownable constructor sets the original `owner` of the contract to the a
400      * specified account.
401      * @param initalOwner The address of the inital owner.
402      */
403     constructor(address initalOwner) internal {
404         _owner = initalOwner;
405         emit OwnershipTransferred(address(0), _owner);
406     }
407 
408     /**
409      * @return the address of the owner.
410      */
411     function owner() public view returns (address) {
412         return _owner;
413     }
414 
415     /**
416      * @dev Throws if called by any account other than the owner.
417      */
418     modifier onlyOwner() {
419         require(isOwner(), "Only owner can call");
420         _;
421     }
422 
423     /**
424      * @return true if `msg.sender` is the owner of the contract.
425      */
426     function isOwner() public view returns (bool) {
427         return msg.sender == _owner;
428     }
429 
430     /**
431      * @dev Allows the current owner to relinquish control of the contract.
432      * It will not be possible to call the functions with the `onlyOwner`
433      * modifier anymore.
434      * @notice Renouncing ownership will leave the contract without an owner,
435      * thereby removing any functionality that is only available to the owner.
436      */
437     function renounceOwnership() public onlyOwner {
438         emit OwnershipTransferred(_owner, address(0));
439         _owner = address(0);
440     }
441 
442     /**
443      * @dev Allows the current owner to transfer control of the contract to a newOwner.
444      * @param newOwner The address to transfer ownership to.
445      */
446     function transferOwnership(address newOwner) public onlyOwner {
447         _transferOwnership(newOwner);
448     }
449 
450     /**
451      * @dev Transfers control of the contract to a newOwner.
452      * @param newOwner The address to transfer ownership to.
453      */
454     function _transferOwnership(address newOwner) internal {
455         require(newOwner != address(0), "Owner should not be 0 address");
456         emit OwnershipTransferred(_owner, newOwner);
457         _owner = newOwner;
458     }
459 }
460 
461 // File: contracts/TokenPool.sol
462 
463 pragma solidity 0.6.10;
464 
465 
466 
467 /**
468  * @title A simple holder of tokens.
469  * This is a simple contract to hold tokens. It's useful in the case where a separate contract
470  * needs to hold multiple distinct pools of the same token.
471  */
472 contract TokenPool is Ownable {
473     IERC20 public token;
474 
475     constructor(IERC20 _token) Ownable(msg.sender) public {
476         token = _token;
477     }
478 
479     function balance() public view returns (uint256) {
480         return token.balanceOf(address(this));
481     }
482 
483     function transfer(address to, uint256 value) external onlyOwner returns (bool) {
484         return token.transfer(to, value);
485     }
486 }
487 
488 // File: contracts/AbstractStaking.sol
489 
490 pragma solidity 0.6.10;
491 
492 
493 
494 
495 
496 
497 /**
498  * @title Abstract Staking
499  * @dev Skeleton of the staking pool for user to stake Balancer BPT token and get bella as reward.
500  */
501 abstract contract AbstractStaking is Ownable {
502     using SafeMath for uint256;
503 
504     event Staked(address indexed user, uint256 amount);
505     event Unstaked(address indexed user, uint256 amount);
506     event Claimed(address indexed user, uint256 amount);
507 
508     TokenPool public stakingPool;
509     TokenPool public lockedPool;
510     TokenPool public unlockedPool;
511 
512     uint256 public startTime;
513 
514     //
515     // Global state
516     //
517     uint256 public totalStakingAmount;
518     uint256 public totalStakingAmountTime; // total time * amount staked
519     uint256 public lastUpdatedTimestamp;
520 
521     //
522     // Addional bella locking related
523     //
524     uint256 public currentUnlockCycle; // linear count down to release bella token
525     uint256 public lastUnlockTime;
526 
527     /**
528      * @param stakingBPT The BPT token users deposit as stake.
529      * @param bellaToken The bonus token is bella.
530      * @param admin The admin address
531      * @param _startTime Timestamp that user can stake
532      */
533     constructor(
534         IERC20 stakingBPT,
535         IERC20 bellaToken,
536         address admin,
537         uint256 _startTime
538         ) Ownable(admin) 
539         internal {
540         stakingPool = new TokenPool(stakingBPT);
541         lockedPool = new TokenPool(bellaToken);
542         unlockedPool = new TokenPool(bellaToken);
543         startTime = _startTime;
544     }
545 
546     /**
547      * @return The user's total staking BPT amount
548      */
549     function totalStakedFor(address user) public view virtual returns (uint256);
550 
551     function totalStaked() public view returns (uint256) {
552         return totalStakingAmount;
553     }
554 
555     /**
556      * @dev Stake for the user self
557      * @param amount The amount of BPT tokens that the user wishes to stake
558      */
559     function stake(uint256 amount) external {
560         require(!Address.isContract(msg.sender), "No harvest thanks");
561         require(now >= startTime, "not started yet");
562         _stake(msg.sender, msg.sender, amount);
563     }
564 
565     /**
566      * @return User's total rewards when clamining
567      */
568     function totalRewards() external view returns (uint256) {
569         return _totalRewardsFor(msg.sender);
570     }
571 
572     /**
573      * @return A specific user's total rewards when clamining
574      */
575     function totalRewardsFor(address user) external view returns (uint256) {
576         return _totalRewardsFor(user);
577     }
578 
579     /**
580      * @dev Claim=withdraw all the bella rewards
581      */
582     function claim() external {
583         require(!Address.isContract(msg.sender), "No harvest thanks");
584         // cumulate user and global time*amount
585         _updateTotalStaking(0);
586         _updateUserStaking(0, msg.sender);
587 
588         _poolUnlock();
589 
590         uint256 reward = _calculateRewardAndBurnAll(msg.sender);
591 
592         unlockedPool.transfer(msg.sender, reward);
593 
594         emit Claimed(msg.sender, reward);
595     }
596 
597     /**
598      * @dev Claim=withdraw all the bella rewards and the staking BPT token,
599      * which stops the user's staking
600      */
601     function claimAndUnstake() external {
602         require(!Address.isContract(msg.sender), "No harvest thanks");
603         // cumulate user and global time*amount
604         _updateTotalStaking(0);
605         _updateUserStaking(0, msg.sender);
606 
607         _poolUnlock();
608 
609         (uint256 staking, uint256 reward) = _calculateRewardAndCleanUser(msg.sender);
610 
611         unlockedPool.transfer(msg.sender, reward);
612         stakingPool.transfer(msg.sender, staking);
613 
614         emit Claimed(msg.sender, reward);
615         emit Unstaked(msg.sender, staking);
616     }
617 
618     /**
619      * @dev we will lock more bella tokens on the begining of the next releasing cycle
620      * @param amount the amount of bella token to lock
621      * @param nextUnlockCycle next reward releasing cycle, unit=day
622      */
623     function lock(uint256 amount, uint256 nextUnlockCycle) external onlyOwner {
624         currentUnlockCycle = nextUnlockCycle * 1 days;
625         if (now >= startTime) {
626             lastUnlockTime = now;
627         } else {
628             lastUnlockTime = startTime;
629         }
630             
631         require(
632             lockedPool.token().transferFrom(msg.sender, address(lockedPool), amount),
633             "Additional bella transfer failed"
634         );
635     }
636 
637     /**
638      * @dev Actual logic to handle user staking
639      * @param from The user who pays the staking BPT
640      * @param beneficiary The user who actually controls the staking BPT
641      * @param amount The amount of BPT tokens to stake
642      */
643     function _stake(address from, address beneficiary, uint256 amount) private {
644         require(amount > 0, "can not stake 0 token");
645         require(
646             stakingPool.token().transferFrom(from, address(stakingPool), amount),
647             "Staking BPT transfer failed"
648         );
649 
650         _updateUserStaking(amount, beneficiary);
651 
652         _updateTotalStaking(amount);
653 
654         emit Staked(beneficiary, amount);
655     }
656 
657     /**
658      * @dev Update the global state due to more time cumulated and/or new BPT staking token
659      * @param amount New BPT staking deposited (can be 0)
660      */
661     function _updateTotalStaking(uint256 amount) private {
662         uint256 additionalAmountTime = totalStakingAmount.mul(now.sub(lastUpdatedTimestamp));
663         totalStakingAmount = totalStakingAmount.add(amount);
664         totalStakingAmountTime = totalStakingAmountTime.add(additionalAmountTime);
665         lastUpdatedTimestamp = now;
666     }
667 
668     /**
669      * @dev Update a specific user's state due to more time cumulated and/or new BPT staking token
670      * @param amount New BPT staking deposited (can be 0)
671      * @param user The account to be updated
672      */
673     function _updateUserStaking(uint256 amount, address user) internal virtual;
674 
675     /**
676      * @dev linear count down from 30 days to release bella token,
677      * from the locked pool to the unlocked pool
678      */
679     function _poolUnlock() private {
680         if (currentUnlockCycle == 0)
681             return; // release ended
682         uint256 timeDelta = now.sub(lastUnlockTime);
683         if (currentUnlockCycle < timeDelta)
684             currentUnlockCycle = timeDelta; // release all
685 
686         uint256 amount = lockedPool.balance().mul(timeDelta).div(currentUnlockCycle);
687 
688         currentUnlockCycle = currentUnlockCycle.sub(timeDelta);
689         lastUnlockTime = now;
690 
691         lockedPool.transfer(address(unlockedPool), amount);
692     }
693 
694     /**
695      * @dev Calculate user's total cumulated reward and burn his/her all staking amount*time
696      * @return User cumulated reward bella during the staking process
697      */
698     function _calculateRewardAndBurnAll(address user) internal virtual returns (uint256);
699 
700     /**
701      * @dev Calculate user's total cumulated reward and staking,
702      * and remove him/her from the staking process
703      * @return [1] User cumulated staking BPT
704      * @return [2] User cumulated reward bella during the staking process
705      */
706     function _calculateRewardAndCleanUser(address user) internal virtual returns (uint256, uint256);
707 
708     /**
709      * @dev Internal function to calculate user's total rewards
710      * @return A specific user's total rewards when clamining
711      */
712     function _totalRewardsFor(address user) internal view virtual returns (uint256);
713     
714 }
715 
716 // File: contracts/IncrementalStaking.sol
717 
718 pragma solidity 0.6.10;
719 
720 
721 
722 /**
723  * @title Incremental Staking
724  * @dev A staking pool for user to stake Balancer BPT token and get bella as reward.
725  * Regarding the staking time, there is a linear bonus amplifier goes from 1.0 (initially)
726  * to 2.0 (at the end of the 60th day). The reward is added by the admin at the 0th, 30th
727  * and 60th day, respectively.
728  * @notice If the user stakes too many times (which is irrational considiering the gas fee),
729  * he will get stuck later
730  */
731 contract IncrementalStaking is AbstractStaking {
732     using SafeMath for uint256;
733 
734     mapping(address=>Staking[]) public stakingInfo;
735 
736     struct Staking {
737         uint256 amount;
738         uint256 time;
739     }
740 
741     //
742     // Reward amplifier related
743     //
744     uint256 constant STARTING_BONUS = 5_000;
745     uint256 constant ENDING_BONUS = 10_000;
746     uint256 constant ONE = 10_000;
747     uint256 constant BONUS_PERIOD = 60 days;
748 
749     /**
750      * @param stakingBPT The BPT token users deposit as stake.
751      * @param bellaToken The bonus token is bella.
752      * @param admin The admin address
753      * @param _startTime Timestamp that user can stake
754      */
755     constructor(
756         IERC20 stakingBPT, 
757         IERC20 bellaToken,
758         address admin,
759         uint256 _startTime     
760         ) AbstractStaking(
761             stakingBPT,
762             bellaToken,
763             admin,
764             _startTime
765         ) public {}
766 
767     /**
768      * @return The user's total staking BPT amount
769      */
770     function totalStakedFor(address user) public view override returns (uint256) {
771         uint amount = 0;
772         Staking[] memory userStaking = stakingInfo[user];
773         for (uint256 i=0; i < userStaking.length; i++) {
774             amount = amount.add(userStaking[i].amount);
775         }
776         return amount;
777     }
778 
779     /**
780      * @dev Update a specific user's state due to more time cumulated and/or new BPT staking token
781      * @param amount New BPT staking deposited (can be 0)
782      * @param user The account to be updated
783      */
784     function _updateUserStaking(uint256 amount, address user) internal override {
785         if (amount == 0)
786             return;
787 
788         Staking memory newStaking = Staking({amount: amount, time: now});
789         stakingInfo[user].push(newStaking);
790     }
791 
792     /**
793      * @dev Calculate user's total cumulated reward and burn his/her all staking amount*time
794      * @return User cumulated reward bella during the staking process
795      */
796     function _calculateRewardAndBurnAll(address user) internal override returns (uint256) {
797         
798         uint256 totalReward = 0;
799         uint256 totalStaking = 0;
800         uint256 totalTimeAmount = 0;
801 
802         Staking[] memory userStakings = stakingInfo[user];
803 
804         // iterate through user's staking
805         for (uint256 i=0; i<userStakings.length; i++) {
806             totalStaking = totalStaking.add(userStakings[i].amount);
807             // get the staking part's reward (amplified) and the time*amount to reduce
808             (uint256 reward, uint256 timeAmount) = _getRewardAndTimeAmountToBurn(userStakings[i]);
809             totalReward = totalReward.add(reward);
810             totalTimeAmount = totalTimeAmount.add(timeAmount);
811         }
812 
813         totalStakingAmountTime = totalStakingAmountTime.sub(totalTimeAmount);
814 
815         // user staking information reset
816         delete stakingInfo[user];
817         stakingInfo[user].push(Staking({amount: totalStaking, time: now}));
818 
819         return totalReward;
820     }
821 
822     /**
823      * @dev Calculate user's total cumulated reward and staking, 
824      * and remove him/her from the staking process
825      * @return [1] User cumulated staking BPT
826      * @return [2] User cumulated reward bella during the staking process
827      */
828     function _calculateRewardAndCleanUser(address user) internal override returns (uint256, uint256) {
829 
830         uint256 totalStaking = 0;
831         uint256 totalReward = 0;
832         uint256 totalTimeAmount = 0;
833 
834         Staking[] memory userStakings = stakingInfo[user];
835 
836         // iterate through user's staking
837         for (uint256 i=0; i<userStakings.length; i++) {
838             totalStaking = totalStaking.add(userStakings[i].amount);
839             // get the staking part's reward (amplified) and the time*amount to reduce
840             (uint256 reward, uint256 timeAmount) = _getRewardAndTimeAmountToBurn(userStakings[i]);
841             totalReward = totalReward.add(reward);
842             totalTimeAmount = totalTimeAmount.add(timeAmount);
843         }
844 
845         totalStakingAmount = totalStakingAmount.sub(totalStaking);
846         totalStakingAmountTime = totalStakingAmountTime.sub(totalTimeAmount);
847 
848         // clear user 
849         delete stakingInfo[user];
850         return (totalStaking, totalReward);
851 
852     }
853 
854     /**
855      * @dev Calculate user's reward of one portion of stake amplified 
856      * @return [1] Reward of this portion of stake
857      * @return [2] Time*amount to burn
858      */
859     function _getRewardAndTimeAmountToBurn(Staking memory staking) private view returns (uint256, uint256) {
860         uint256 timeDelta = now.sub(staking.time);
861         uint256 timeAmount = staking.amount.mul(timeDelta);
862 
863         uint256 rewardFullBonus = unlockedPool.balance().mul(timeAmount).div(totalStakingAmountTime);
864 
865         if (timeDelta >= BONUS_PERIOD)
866             return (rewardFullBonus, timeAmount);
867 
868         uint256 reward = (ENDING_BONUS - STARTING_BONUS).mul(timeDelta).div(BONUS_PERIOD).add(STARTING_BONUS).mul(rewardFullBonus).div(ONE);
869 
870         return (reward, timeAmount);
871 
872     }
873 
874     /**
875      * @dev Internal function to calculate user's total rewards
876      * @return A specific user's total rewards when clamining
877      */
878     function _totalRewardsFor(address user) internal view override returns (uint256) {
879 
880         // calculate new total staking amount*time
881         uint256 additionalAmountTime = totalStakingAmount.mul(now.sub(lastUpdatedTimestamp));
882         uint256 newTotalStakingAmountTime = totalStakingAmountTime.add(additionalAmountTime);
883 
884         // calculate total unlocked pool
885         uint256 unlockedAmount = unlockedPool.balance();
886         if (currentUnlockCycle != 0) {
887             uint256 timeDelta = now.sub(lastUnlockTime);
888             if (currentUnlockCycle <= timeDelta) {
889                 unlockedAmount = unlockedAmount.add(lockedPool.balance());
890             } else {
891                 uint256 additionalAmount = lockedPool.balance().mul(timeDelta).div(currentUnlockCycle);
892                 unlockedAmount = unlockedAmount.add(additionalAmount);
893             }
894         }
895 
896         uint256 totalReward = 0;
897 
898         Staking[] memory userStakings = stakingInfo[user];
899 
900         // iterate through user's staking
901         for (uint256 i=0; i<userStakings.length; i++) {
902             // get the staking part's reward (amplified) and the time*amount to reduce
903             Staking memory staking = userStakings[i];
904             uint256 timeDelta = now.sub(staking.time);
905             uint256 timeAmount = staking.amount.mul(timeDelta);
906 
907             uint256 reward = unlockedAmount.mul(timeAmount).div(newTotalStakingAmountTime);
908 
909             if (timeDelta < BONUS_PERIOD)
910                 reward = (ENDING_BONUS - STARTING_BONUS).mul(timeDelta).div(BONUS_PERIOD).add(
911                     STARTING_BONUS).mul(reward).div(ONE);
912 
913             totalReward = totalReward.add(reward);
914         }
915 
916         return totalReward;
917     }
918 }