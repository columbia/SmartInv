1 /**
2 
3  * Orbs Staking Smart Contract
4  
5  *************************************************************************
6  *
7  * CAUTION:
8  *   Staking must be done only using the contract interface functions.
9  *   Do NOT transfer tokens directly to the contract address.
10  *   Tokens transferred directly to the contract address are NOT staked 
11  *   and CANNOT be recovered.
12  *
13  *************************************************************************
14 
15 
16 
17 
18 
19 
20 
21 
22 **/
23 
24 
25 // File: @openzeppelin/contracts/math/SafeMath.sol
26 
27 pragma solidity ^0.5.0;
28 
29 /**
30  * @dev Wrappers over Solidity's arithmetic operations with added overflow
31  * checks.
32  *
33  * Arithmetic operations in Solidity wrap on overflow. This can easily result
34  * in bugs, because programmers usually assume that an overflow raises an
35  * error, which is the standard behavior in high level programming languages.
36  * `SafeMath` restores this intuition by reverting the transaction when an
37  * operation overflows.
38  *
39  * Using this library instead of the unchecked operations eliminates an entire
40  * class of bugs, so it's recommended to use it always.
41  */
42 library SafeMath {
43     /**
44      * @dev Returns the addition of two unsigned integers, reverting on
45      * overflow.
46      *
47      * Counterpart to Solidity's `+` operator.
48      *
49      * Requirements:
50      * - Addition cannot overflow.
51      */
52     function add(uint256 a, uint256 b) internal pure returns (uint256) {
53         uint256 c = a + b;
54         require(c >= a, "SafeMath: addition overflow");
55 
56         return c;
57     }
58 
59     /**
60      * @dev Returns the subtraction of two unsigned integers, reverting on
61      * overflow (when the result is negative).
62      *
63      * Counterpart to Solidity's `-` operator.
64      *
65      * Requirements:
66      * - Subtraction cannot overflow.
67      */
68     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
69         require(b <= a, "SafeMath: subtraction overflow");
70         uint256 c = a - b;
71 
72         return c;
73     }
74 
75     /**
76      * @dev Returns the multiplication of two unsigned integers, reverting on
77      * overflow.
78      *
79      * Counterpart to Solidity's `*` operator.
80      *
81      * Requirements:
82      * - Multiplication cannot overflow.
83      */
84     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
85         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
86         // benefit is lost if 'b' is also tested.
87         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
88         if (a == 0) {
89             return 0;
90         }
91 
92         uint256 c = a * b;
93         require(c / a == b, "SafeMath: multiplication overflow");
94 
95         return c;
96     }
97 
98     /**
99      * @dev Returns the integer division of two unsigned integers. Reverts on
100      * division by zero. The result is rounded towards zero.
101      *
102      * Counterpart to Solidity's `/` operator. Note: this function uses a
103      * `revert` opcode (which leaves remaining gas untouched) while Solidity
104      * uses an invalid opcode to revert (consuming all remaining gas).
105      *
106      * Requirements:
107      * - The divisor cannot be zero.
108      */
109     function div(uint256 a, uint256 b) internal pure returns (uint256) {
110         // Solidity only automatically asserts when dividing by 0
111         require(b > 0, "SafeMath: division by zero");
112         uint256 c = a / b;
113         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
114 
115         return c;
116     }
117 
118     /**
119      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
120      * Reverts when dividing by zero.
121      *
122      * Counterpart to Solidity's `%` operator. This function uses a `revert`
123      * opcode (which leaves remaining gas untouched) while Solidity uses an
124      * invalid opcode to revert (consuming all remaining gas).
125      *
126      * Requirements:
127      * - The divisor cannot be zero.
128      */
129     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
130         require(b != 0, "SafeMath: modulo by zero");
131         return a % b;
132     }
133 }
134 
135 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
136 
137 pragma solidity ^0.5.0;
138 
139 /**
140  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
141  * the optional functions; to access them see `ERC20Detailed`.
142  */
143 interface IERC20 {
144     /**
145      * @dev Returns the amount of tokens in existence.
146      */
147     function totalSupply() external view returns (uint256);
148 
149     /**
150      * @dev Returns the amount of tokens owned by `account`.
151      */
152     function balanceOf(address account) external view returns (uint256);
153 
154     /**
155      * @dev Moves `amount` tokens from the caller's account to `recipient`.
156      *
157      * Returns a boolean value indicating whether the operation succeeded.
158      *
159      * Emits a `Transfer` event.
160      */
161     function transfer(address recipient, uint256 amount) external returns (bool);
162 
163     /**
164      * @dev Returns the remaining number of tokens that `spender` will be
165      * allowed to spend on behalf of `owner` through `transferFrom`. This is
166      * zero by default.
167      *
168      * This value changes when `approve` or `transferFrom` are called.
169      */
170     function allowance(address owner, address spender) external view returns (uint256);
171 
172     /**
173      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
174      *
175      * Returns a boolean value indicating whether the operation succeeded.
176      *
177      * > Beware that changing an allowance with this method brings the risk
178      * that someone may use both the old and the new allowance by unfortunate
179      * transaction ordering. One possible solution to mitigate this race
180      * condition is to first reduce the spender's allowance to 0 and set the
181      * desired value afterwards:
182      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
183      *
184      * Emits an `Approval` event.
185      */
186     function approve(address spender, uint256 amount) external returns (bool);
187 
188     /**
189      * @dev Moves `amount` tokens from `sender` to `recipient` using the
190      * allowance mechanism. `amount` is then deducted from the caller's
191      * allowance.
192      *
193      * Returns a boolean value indicating whether the operation succeeded.
194      *
195      * Emits a `Transfer` event.
196      */
197     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
198 
199     /**
200      * @dev Emitted when `value` tokens are moved from one account (`from`) to
201      * another (`to`).
202      *
203      * Note that `value` may be zero.
204      */
205     event Transfer(address indexed from, address indexed to, uint256 value);
206 
207     /**
208      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
209      * a call to `approve`. `value` is the new allowance.
210      */
211     event Approval(address indexed owner, address indexed spender, uint256 value);
212 }
213 
214 // File: contracts/IMigratableStakingContract.sol
215 
216 pragma solidity 0.5.16;
217 
218 
219 /// @title An interface for staking contracts which support stake migration.
220 interface IMigratableStakingContract {
221     /// @dev Returns the address of the underlying staked token.
222     /// @return IERC20 The address of the token.
223     function getToken() external view returns (IERC20);
224 
225     /// @dev Stakes ORBS tokens on behalf of msg.sender. This method assumes that the user has already approved at least
226     /// the required amount using ERC20 approve.
227     /// @param _stakeOwner address The specified stake owner.
228     /// @param _amount uint256 The number of tokens to stake.
229     function acceptMigration(address _stakeOwner, uint256 _amount) external;
230 
231     event AcceptedMigration(address indexed stakeOwner, uint256 amount, uint256 totalStakedAmount);
232 }
233 
234 // File: contracts/IStakingContract.sol
235 
236 pragma solidity 0.5.16;
237 
238 
239 /// @title An interface for staking contracts.
240 interface IStakingContract {
241     /// @dev Stakes ORBS tokens on behalf of msg.sender. This method assumes that the user has already approved at least
242     /// the required amount using ERC20 approve.
243     /// @param _amount uint256 The amount of tokens to stake.
244     function stake(uint256 _amount) external;
245 
246     /// @dev Unstakes ORBS tokens from msg.sender. If successful, this will start the cooldown period, after which
247     /// msg.sender would be able to withdraw all of his tokens.
248     /// @param _amount uint256 The amount of tokens to unstake.
249     function unstake(uint256 _amount) external;
250 
251     /// @dev Requests to withdraw all of staked ORBS tokens back to msg.sender. Stake owners can withdraw their ORBS
252     /// tokens only after previously unstaking them and after the cooldown period has passed (unless the contract was
253     /// requested to release all stakes).
254     function withdraw() external;
255 
256     /// @dev Restakes unstaked ORBS tokens (in or after cooldown) for msg.sender.
257     function restake() external;
258 
259     /// @dev Distributes staking rewards to a list of addresses by directly adding rewards to their stakes. This method
260     /// assumes that the user has already approved at least the required amount using ERC20 approve. Since this is a
261     /// convenience method, we aren't concerned about reaching block gas limit by using large lists. We assume that
262     /// callers will be able to properly batch/paginate their requests.
263     /// @param _totalAmount uint256 The total amount of rewards to distributes.
264     /// @param _stakeOwners address[] The addresses of the stake owners.
265     /// @param _amounts uint256[] The amounts of the rewards.
266     function distributeRewards(uint256 _totalAmount, address[] calldata _stakeOwners, uint256[] calldata _amounts) external;
267 
268     /// @dev Returns the stake of the specified stake owner (excluding unstaked tokens).
269     /// @param _stakeOwner address The address to check.
270     /// @return uint256 The total stake.
271     function getStakeBalanceOf(address _stakeOwner) external view returns (uint256);
272 
273     /// @dev Returns the total amount staked tokens (excluding unstaked tokens).
274     /// @return uint256 The total staked tokens of all stake owners.
275     function getTotalStakedTokens() external view returns (uint256);
276 
277     /// @dev Returns the time that the cooldown period ends (or ended) and the amount of tokens to be released.
278     /// @param _stakeOwner address The address to check.
279     /// @return cooldownAmount uint256 The total tokens in cooldown.
280     /// @return cooldownEndTime uint256 The time when the cooldown period ends (in seconds).
281     function getUnstakeStatus(address _stakeOwner) external view returns (uint256 cooldownAmount,
282         uint256 cooldownEndTime);
283 
284     /// @dev Migrates the stake of msg.sender from this staking contract to a new approved staking contract.
285     /// @param _newStakingContract IMigratableStakingContract The new staking contract which supports stake migration.
286     /// @param _amount uint256 The amount of tokens to migrate.
287     function migrateStakedTokens(IMigratableStakingContract _newStakingContract, uint256 _amount) external;
288 
289     event Staked(address indexed stakeOwner, uint256 amount, uint256 totalStakedAmount);
290     event Unstaked(address indexed stakeOwner, uint256 amount, uint256 totalStakedAmount);
291     event Withdrew(address indexed stakeOwner, uint256 amount, uint256 totalStakedAmount);
292     event Restaked(address indexed stakeOwner, uint256 amount, uint256 totalStakedAmount);
293     event MigratedStake(address indexed stakeOwner, uint256 amount, uint256 totalStakedAmount);
294 }
295 
296 // File: contracts/IStakeChangeNotifier.sol
297 
298 pragma solidity 0.5.16;
299 
300 /// @title An interface for notifying of stake change events (e.g., stake, unstake, partial unstake, restate, etc.).
301 interface IStakeChangeNotifier {
302     /// @dev Notifies of stake change event.
303     /// @param _stakeOwner address The address of the subject stake owner.
304     /// @param _amount uint256 The difference in the total staked amount.
305     /// @param _sign bool The sign of the added (true) or subtracted (false) amount.
306     /// @param _updatedStake uint256 The updated total staked amount.
307     function stakeChange(address _stakeOwner, uint256 _amount, bool _sign, uint256 _updatedStake) external;
308 
309     /// @dev Notifies of multiple stake change events.
310     /// @param _stakeOwners address[] The addresses of subject stake owners.
311     /// @param _amounts uint256[] The differences in total staked amounts.
312     /// @param _signs bool[] The signs of the added (true) or subtracted (false) amounts.
313     /// @param _updatedStakes uint256[] The updated total staked amounts.
314     function stakeChangeBatch(address[] calldata _stakeOwners, uint256[] calldata _amounts, bool[] calldata _signs,
315         uint256[] calldata _updatedStakes) external;
316 
317     /// @dev Notifies of stake migration event.
318     /// @param _stakeOwner address The address of the subject stake owner.
319     /// @param _amount uint256 The migrated amount.
320     function stakeMigration(address _stakeOwner, uint256 _amount) external;
321 }
322 
323 // File: contracts/StakingContract.sol
324 
325 pragma solidity 0.5.16;
326 
327 
328 
329 
330 /// @title Orbs staking smart contract.
331 contract StakingContract is IStakingContract, IMigratableStakingContract {
332     using SafeMath for uint256;
333 
334     struct Stake {
335         uint256 amount;
336         uint256 cooldownAmount;
337         uint256 cooldownEndTime;
338     }
339 
340     struct WithdrawResult {
341         uint256 withdrawnAmount;
342         uint256 stakedAmount;
343         uint256 stakedAmountDiff;
344     }
345 
346     // The version of the smart contract.
347     uint public constant VERSION = 1;
348 
349     // The maximum number of approved staking contracts as migration destinations.
350     uint public constant MAX_APPROVED_STAKING_CONTRACTS = 10;
351 
352     // The mapping between stake owners and their data.
353     mapping(address => Stake) internal stakes;
354 
355     // Total amount of staked tokens (not including unstaked tokes in cooldown or pending withdrawal).
356     uint256 internal totalStakedTokens;
357 
358     // The period (in seconds) between a stake owner's request to stop staking and being able to withdraw them.
359     uint256 public cooldownPeriodInSec;
360 
361     // The address responsible for managing migration to a new staking contract.
362     address public migrationManager;
363 
364     // The address responsible for emergency operations and graceful return of staked tokens back to their owners.
365     address public emergencyManager;
366 
367     // The list of staking contracts that are approved by this contract. It would be only allowed to migrate a stake to
368     // one of these contracts.
369     IMigratableStakingContract[] public approvedStakingContracts;
370 
371     // The address of the contract responsible for publishing stake change notifications.
372     IStakeChangeNotifier public notifier;
373 
374     // The address of the ORBS token.
375     IERC20 internal token;
376 
377     // Represents whether the contract accepts new staking requests. Please note, that even when it's turned off,
378     // it'd be still possible to unstake or withdraw tokens.
379     //
380     // Note: This can be turned off only once by the emergency manager of the contract.
381     bool public acceptingNewStakes = true;
382 
383     // Represents whether this staking contract allows releasing all unstaked tokens unconditionally. When it's turned
384     // on, stake owners could release their staked tokens, without explicitly requesting to unstake them, and their
385     // previously unstaked tokens, regardless of the cooldown period. This also stops the contract from accepting new
386     // stakes.
387     //
388     // Note: This can be turned off only once by the emergency manager of the contract.
389     bool public releasingAllStakes = false;
390 
391     event MigrationManagerUpdated(address indexed migrationManager);
392     event MigrationDestinationAdded(IMigratableStakingContract indexed stakingContract);
393     event MigrationDestinationRemoved(IMigratableStakingContract indexed stakingContract);
394     event EmergencyManagerUpdated(address indexed emergencyManager);
395     event StakeChangeNotifierUpdated(IStakeChangeNotifier indexed notifier);
396     event StoppedAcceptingNewStake();
397     event ReleasedAllStakes();
398 
399     modifier onlyMigrationManager() {
400         require(msg.sender == migrationManager, "StakingContract: caller is not the migration manager");
401 
402         _;
403     }
404 
405     modifier onlyEmergencyManager() {
406         require(msg.sender == emergencyManager, "StakingContract: caller is not the emergency manager");
407 
408         _;
409     }
410 
411     modifier onlyWhenAcceptingNewStakes() {
412         require(acceptingNewStakes && !releasingAllStakes, "StakingContract: not accepting new stakes");
413 
414         _;
415     }
416 
417     modifier onlyWhenStakesReleased() {
418         require(releasingAllStakes, "StakingContract: not releasing all stakes");
419 
420         _;
421     }
422 
423     modifier onlyWhenStakesNotReleased() {
424         require(!releasingAllStakes, "StakingContract: releasing all stakes");
425 
426         _;
427     }
428 
429     /// @dev Initializes the staking contract.
430     /// @param _cooldownPeriodInSec uint256 The period (in seconds) between a stake owner's request to stop staking and being
431     /// able to withdraw them.
432     /// @param _migrationManager address The address responsible for managing migration to a new staking contract.
433     /// @param _emergencyManager address The address responsible for emergency operations and graceful return of staked
434     /// tokens back to their owners.
435     /// @param _token IERC20 The address of the ORBS token.
436     constructor(uint256 _cooldownPeriodInSec, address _migrationManager, address _emergencyManager, IERC20 _token) public {
437         require(_cooldownPeriodInSec > 0, "StakingContract::ctor - cooldown period must be greater than 0");
438         require(_migrationManager != address(0), "StakingContract::ctor - migration manager must not be 0");
439         require(_emergencyManager != address(0), "StakingContract::ctor - emergency manager must not be 0");
440         require(address(_token) != address(0), "StakingContract::ctor - ORBS token must not be 0");
441 
442         cooldownPeriodInSec = _cooldownPeriodInSec;
443         migrationManager = _migrationManager;
444         emergencyManager = _emergencyManager;
445         token = _token;
446     }
447 
448     /// @dev Sets the address of the migration manager.
449     /// @param _newMigrationManager address The address of the new migration manager.
450     function setMigrationManager(address _newMigrationManager) external onlyMigrationManager {
451         require(_newMigrationManager != address(0), "StakingContract::setMigrationManager - address must not be 0");
452         require(migrationManager != _newMigrationManager,
453             "StakingContract::setMigrationManager - address must be different than the current address");
454 
455         migrationManager = _newMigrationManager;
456 
457         emit MigrationManagerUpdated(_newMigrationManager);
458     }
459 
460     /// @dev Sets the address of the emergency manager.
461     /// @param _newEmergencyManager address The address of the new emergency manager.
462     function setEmergencyManager(address _newEmergencyManager) external onlyEmergencyManager {
463         require(_newEmergencyManager != address(0), "StakingContract::setEmergencyManager - address must not be 0");
464         require(emergencyManager != _newEmergencyManager,
465             "StakingContract::setEmergencyManager - address must be different than the current address");
466 
467         emergencyManager = _newEmergencyManager;
468 
469         emit EmergencyManagerUpdated(_newEmergencyManager);
470     }
471 
472     /// @dev Sets the address of the stake change notifier contract.
473     /// @param _newNotifier IStakeChangeNotifier The address of the new stake change notifier contract.
474     ///
475     /// Note: it's allowed to reset the notifier to a zero address.
476     function setStakeChangeNotifier(IStakeChangeNotifier _newNotifier) external onlyMigrationManager {
477         require(notifier != _newNotifier,
478             "StakingContract::setStakeChangeNotifier - address must be different than the current address");
479 
480         notifier = _newNotifier;
481 
482         emit StakeChangeNotifierUpdated(notifier);
483     }
484 
485     /// @dev Adds a new contract to the list of approved staking contracts migration destinations.
486     /// @param _newStakingContract IMigratableStakingContract The new contract to add.
487     function addMigrationDestination(IMigratableStakingContract _newStakingContract) external onlyMigrationManager {
488         require(address(_newStakingContract) != address(0),
489             "StakingContract::addMigrationDestination - address must not be 0");
490 
491         uint length = approvedStakingContracts.length;
492         require(length + 1 <= MAX_APPROVED_STAKING_CONTRACTS,
493             "StakingContract::addMigrationDestination - can't add more staking contracts");
494 
495         // Check for duplicates.
496         for (uint i = 0; i < length; ++i) {
497             require(approvedStakingContracts[i] != _newStakingContract,
498                 "StakingContract::addMigrationDestination - can't add a duplicate staking contract");
499         }
500 
501         approvedStakingContracts.push(_newStakingContract);
502 
503         emit MigrationDestinationAdded(_newStakingContract);
504     }
505 
506     /// @dev Removes a contract from the list of approved staking contracts migration destinations.
507     /// @param _stakingContract IMigratableStakingContract The contract to remove.
508     function removeMigrationDestination(IMigratableStakingContract _stakingContract) external onlyMigrationManager {
509         require(address(_stakingContract) != address(0),
510             "StakingContract::removeMigrationDestination - address must not be 0");
511 
512         // Check for existence.
513         (uint i, bool exists) = findApprovedStakingContractIndex(_stakingContract);
514         require(exists, "StakingContract::removeMigrationDestination - staking contract doesn't exist");
515 
516         // Swap the requested element with the last element and then delete it using pop/
517         approvedStakingContracts[i] = approvedStakingContracts[approvedStakingContracts.length - 1];
518         approvedStakingContracts.pop();
519 
520         emit MigrationDestinationRemoved(_stakingContract);
521     }
522 
523     /// @dev Stakes ORBS tokens on behalf of msg.sender. This method assumes that the user has already approved at least
524     /// the required amount using ERC20 approve.
525     /// @param _amount uint256 The amount of tokens to stake.
526     function stake(uint256 _amount) external onlyWhenAcceptingNewStakes {
527         address stakeOwner = msg.sender;
528 
529         uint256 totalStakedAmount = stake(stakeOwner, _amount);
530 
531         emit Staked(stakeOwner, _amount, totalStakedAmount);
532 
533         // Note: we aren't concerned with reentrancy since:
534         //   1. At this point, due to the CEI pattern, a reentrant notifier can't affect the effects of this method.
535         //   2. The notifier is set and managed by the migration manager.
536         stakeChange(stakeOwner, _amount, true, totalStakedAmount);
537     }
538 
539     /// @dev Unstakes ORBS tokens from msg.sender. If successful, this will start the cooldown period, after which
540     /// msg.sender would be able to withdraw all of his tokens.
541     /// @param _amount uint256 The amount of tokens to unstake.
542     function unstake(uint256 _amount) external {
543         require(_amount > 0, "StakingContract::unstake - amount must be greater than 0");
544 
545         address stakeOwner = msg.sender;
546         Stake storage stakeData = stakes[stakeOwner];
547         uint256 stakedAmount = stakeData.amount;
548         uint256 cooldownAmount = stakeData.cooldownAmount;
549         uint256 cooldownEndTime = stakeData.cooldownEndTime;
550 
551         require(_amount <= stakedAmount, "StakingContract::unstake - can't unstake more than the current stake");
552 
553         // If any tokens in cooldown are ready for withdrawal - revert. Stake owner should withdraw their unstaked
554         // tokens first.
555         require(cooldownAmount == 0 || cooldownEndTime > now,
556             "StakingContract::unstake - unable to unstake when there are tokens pending withdrawal");
557 
558         // Update the amount of tokens in cooldown. Please note that this will also restart the cooldown period of all
559         // tokens in cooldown.
560         stakeData.amount = stakedAmount.sub(_amount);
561         stakeData.cooldownAmount = cooldownAmount.add(_amount);
562         stakeData.cooldownEndTime = now.add(cooldownPeriodInSec);
563 
564         totalStakedTokens = totalStakedTokens.sub(_amount);
565 
566         uint256 totalStakedAmount = stakeData.amount;
567 
568         emit Unstaked(stakeOwner, _amount, totalStakedAmount);
569 
570         // Note: we aren't concerned with reentrancy since:
571         //   1. At this point, due to the CEI pattern, a reentrant notifier can't affect the effects of this method.
572         //   2. The notifier is set and managed by the migration manager.
573         stakeChange(stakeOwner, _amount, false, totalStakedAmount);
574     }
575 
576     /// @dev Requests to withdraw all of staked ORBS tokens back to msg.sender. Stake owners can withdraw their ORBS
577     /// tokens only after previously unstaking them and after the cooldown period has passed (unless the contract was
578     /// requested to release all stakes).
579     function withdraw() external {
580         address stakeOwner = msg.sender;
581 
582         WithdrawResult memory res = withdraw(stakeOwner);
583 
584         emit Withdrew(stakeOwner, res.withdrawnAmount, res.stakedAmount);
585 
586         // Trigger staking state change notifications only if the staking amount was changed.
587         if (res.stakedAmountDiff == 0) {
588             return;
589         }
590 
591         // Note: we aren't concerned with reentrancy since:
592         //   1. At this point, due to the CEI pattern, a reentrant notifier can't affect the effects of this method.
593         //   2. The notifier is set and managed by the migration manager.
594         stakeChange(stakeOwner, res.stakedAmountDiff, false, res.stakedAmount);
595     }
596 
597     /// @dev Restakes unstaked ORBS tokens (in or after cooldown) for msg.sender.
598     function restake() external onlyWhenAcceptingNewStakes {
599         address stakeOwner = msg.sender;
600         Stake storage stakeData = stakes[stakeOwner];
601         uint256 cooldownAmount = stakeData.cooldownAmount;
602 
603         require(cooldownAmount > 0, "StakingContract::restake - no unstaked tokens");
604 
605         stakeData.amount = stakeData.amount.add(cooldownAmount);
606         stakeData.cooldownAmount = 0;
607         stakeData.cooldownEndTime = 0;
608 
609         totalStakedTokens = totalStakedTokens.add(cooldownAmount);
610 
611         uint256 totalStakedAmount = stakeData.amount;
612 
613         emit Restaked(stakeOwner, cooldownAmount, totalStakedAmount);
614 
615         // Note: we aren't concerned with reentrancy since:
616         //   1. At this point, due to the CEI pattern, a reentrant notifier can't affect the effects of this method.
617         //   2. The notifier is set and managed by the migration manager.
618         stakeChange(stakeOwner, cooldownAmount, true, totalStakedAmount);
619     }
620 
621     /// @dev Stakes ORBS tokens on behalf of msg.sender. This method assumes that the user has already approved at least
622     /// the required amount using ERC20 approve.
623     /// @param _stakeOwner address The specified stake owner.
624     /// @param _amount uint256 The amount of tokens to stake.
625     function acceptMigration(address _stakeOwner, uint256 _amount) external onlyWhenAcceptingNewStakes {
626         uint256 totalStakedAmount = stake(_stakeOwner, _amount);
627 
628         emit AcceptedMigration(_stakeOwner, _amount, totalStakedAmount);
629 
630         // Note: we aren't concerned with reentrancy since:
631         //   1. At this point, due to the CEI pattern, a reentrant notifier can't affect the effects of this method.
632         //   2. The notifier is set and managed by the migration manager.
633         stakeChange(_stakeOwner, _amount, true, totalStakedAmount);
634     }
635 
636     /// @dev Migrates the stake of msg.sender from this staking contract to a new approved staking contract.
637     /// @param _newStakingContract IMigratableStakingContract The new staking contract which supports stake migration.
638     /// @param _amount uint256 The amount of tokens to migrate.
639     function migrateStakedTokens(IMigratableStakingContract _newStakingContract, uint256 _amount) external
640         onlyWhenStakesNotReleased {
641         require(isApprovedStakingContract(_newStakingContract),
642             "StakingContract::migrateStakedTokens - migration destination wasn't approved");
643         require(_amount > 0, "StakingContract::migrateStakedTokens - amount must be greater than 0");
644 
645         address stakeOwner = msg.sender;
646         Stake storage stakeData = stakes[stakeOwner];
647         uint256 stakedAmount = stakeData.amount;
648 
649         require(stakedAmount > 0, "StakingContract::migrateStakedTokens - no staked tokens");
650         require(_amount <= stakedAmount, "StakingContract::migrateStakedTokens - amount exceeds staked token balance");
651 
652         stakeData.amount = stakedAmount.sub(_amount);
653 
654         totalStakedTokens = totalStakedTokens.sub(_amount);
655 
656         require(_newStakingContract.getToken() == token,
657             "StakingContract::migrateStakedTokens - staked tokens must be the same");
658         require(token.approve(address(_newStakingContract), _amount),
659             "StakingContract::migrateStakedTokens - couldn't approve transfer");
660 
661         emit MigratedStake(stakeOwner, _amount, stakeData.amount);
662 
663         _newStakingContract.acceptMigration(stakeOwner, _amount);
664 
665         // Note: we aren't concerned with reentrancy since:
666         //   1. At this point, due to the CEI pattern, a reentrant notifier can't affect the effects of this method.
667         //   2. The notifier is set and managed by the migration manager.
668         stakeMigration(stakeOwner, _amount);
669     }
670 
671     /// @dev Distributes staking rewards to a list of addresses by directly adding rewards to their stakes. This method
672     /// assumes that the user has already approved at least the required amount using ERC20 approve. Since this is a
673     /// convenience method, we aren't concerned about reaching block gas limit by using large lists. We assume that
674     /// callers will be able to batch/paginate their requests properly.
675     /// @param _totalAmount uint256 The total amount of rewards to distributes.
676     /// @param _stakeOwners address[] The addresses of the stake owners.
677     /// @param _amounts uint256[] The amounts of the rewards.
678     function distributeRewards(uint256 _totalAmount, address[] calldata _stakeOwners, uint256[] calldata _amounts) external
679         onlyWhenAcceptingNewStakes {
680         require(_totalAmount > 0, "StakingContract::distributeRewards - total amount must be greater than 0");
681 
682         uint256 stakeOwnersLength = _stakeOwners.length;
683         uint256 amountsLength = _amounts.length;
684 
685         require(stakeOwnersLength > 0 && amountsLength > 0,
686             "StakingContract::distributeRewards - lists can't be empty");
687         require(stakeOwnersLength == amountsLength,
688             "StakingContract::distributeRewards - lists must be of the same size");
689 
690         // Transfer all the tokens to the smart contract and update the stake owners list accordingly.
691         require(token.transferFrom(msg.sender, address(this), _totalAmount),
692             "StakingContract::distributeRewards - insufficient allowance");
693 
694         bool[] memory signs = new bool[](amountsLength);
695         uint256[] memory totalStakedAmounts = new uint256[](amountsLength);
696 
697         uint256 expectedTotalAmount = 0;
698         for (uint i = 0; i < stakeOwnersLength; ++i) {
699             address stakeOwner = _stakeOwners[i];
700             uint256 amount = _amounts[i];
701 
702             require(stakeOwner != address(0), "StakingContract::distributeRewards - stake owner can't be 0");
703             require(amount > 0, "StakingContract::distributeRewards - amount must be greater than 0");
704 
705             Stake storage stakeData = stakes[stakeOwner];
706             stakeData.amount = stakeData.amount.add(amount);
707 
708             expectedTotalAmount = expectedTotalAmount.add(amount);
709 
710             uint256 totalStakedAmount = stakeData.amount;
711             signs[i] = true;
712             totalStakedAmounts[i] = totalStakedAmount;
713 
714             emit Staked(stakeOwner, amount, totalStakedAmount);
715         }
716 
717         require(_totalAmount == expectedTotalAmount, "StakingContract::distributeRewards - incorrect total amount");
718 
719         totalStakedTokens = totalStakedTokens.add(_totalAmount);
720 
721         // Note: we aren't concerned with reentrancy since:
722         //   1. At this point, due to the CEI pattern, a reentrant notifier can't affect the effects of this method.
723         //   2. The notifier is set and managed by the migration manager.
724         stakeChangeBatch(_stakeOwners, _amounts, signs, totalStakedAmounts);
725     }
726 
727     /// @dev Returns the stake of the specified stake owner (excluding unstaked tokens).
728     /// @param _stakeOwner address The address to check.
729     /// @return uint256 The stake of the stake owner.
730     function getStakeBalanceOf(address _stakeOwner) external view returns (uint256) {
731         return stakes[_stakeOwner].amount;
732     }
733 
734     /// @dev Returns the total amount staked tokens (excluding unstaked tokens).
735     /// @return uint256 The total staked tokens of all stake owners.
736     function getTotalStakedTokens() external view returns (uint256) {
737         return totalStakedTokens;
738     }
739 
740     /// @dev Returns the time that the cooldown period ends (or ended) and the amount of tokens to be released.
741     /// @param _stakeOwner address The address to check.
742     /// @return cooldownAmount uint256 The total tokens in cooldown.
743     /// @return cooldownEndTime uint256 The time when the cooldown period ends (in seconds).
744     function getUnstakeStatus(address _stakeOwner) external view returns (uint256 cooldownAmount,
745         uint256 cooldownEndTime) {
746         Stake memory stakeData = stakes[_stakeOwner];
747         cooldownAmount = stakeData.cooldownAmount;
748         cooldownEndTime = stakeData.cooldownEndTime;
749     }
750 
751     /// @dev Returns the address of the underlying staked token.
752     /// @return IERC20 The address of the token.
753     function getToken() external view returns (IERC20) {
754         return token;
755     }
756 
757     /// @dev Requests the contract to stop accepting new staking requests.
758     function stopAcceptingNewStakes() external onlyEmergencyManager onlyWhenAcceptingNewStakes {
759         acceptingNewStakes = false;
760 
761         emit StoppedAcceptingNewStake();
762     }
763 
764     /// @dev Requests the contract to release all stakes.
765     function releaseAllStakes() external onlyEmergencyManager onlyWhenStakesNotReleased {
766         releasingAllStakes = true;
767 
768         emit ReleasedAllStakes();
769     }
770 
771     /// @dev Requests withdraw of released tokens for a list of addresses.
772     /// @param _stakeOwners address[] The addresses of the stake owners.
773     function withdrawReleasedStakes(address[] calldata _stakeOwners) external onlyWhenStakesReleased {
774         uint256 stakeOwnersLength = _stakeOwners.length;
775         uint256[] memory stakedAmountDiffs = new uint256[](stakeOwnersLength);
776         bool[] memory signs = new bool[](stakeOwnersLength);
777         uint256[] memory totalStakedAmounts = new uint256[](stakeOwnersLength);
778 
779         for (uint i = 0; i < stakeOwnersLength; ++i) {
780             address stakeOwner = _stakeOwners[i];
781 
782             WithdrawResult memory res = withdraw(stakeOwner);
783             stakedAmountDiffs[i] = res.stakedAmountDiff;
784             signs[i] = false;
785             totalStakedAmounts[i] = res.stakedAmount;
786 
787             emit Withdrew(stakeOwner, res.withdrawnAmount, res.stakedAmount);
788         }
789 
790         // Note: we aren't concerned with reentrancy since:
791         //   1. At this point, due to the CEI pattern, a reentrant notifier can't affect the effects of this method.
792         //   2. The notifier is set and managed by the migration manager.
793         stakeChangeBatch(_stakeOwners, stakedAmountDiffs, signs, totalStakedAmounts);
794     }
795 
796     /// @dev Returns whether a specific staking contract was approved as a migration destination.
797     /// @param _stakingContract IMigratableStakingContract The staking contract to look for.
798     /// @return exists bool The approval status.
799     function isApprovedStakingContract(IMigratableStakingContract _stakingContract) public view returns (bool exists) {
800         (, exists) = findApprovedStakingContractIndex(_stakingContract);
801     }
802 
803     /// @dev Returns whether stake change notification is enabled.
804     function shouldNotifyStakeChange() view internal returns (bool) {
805         return address(notifier) != address(0);
806     }
807 
808     /// @dev Notifies of stake change events.
809     /// @param _stakeOwner address The address of the subject stake owner.
810     /// @param _amount int256 The difference in the total staked amount.
811     /// @param _sign bool The sign of the added (true) or subtracted (false) amount.
812     /// @param _updatedStake uint256 The updated total staked amount.
813     function stakeChange(address _stakeOwner, uint256 _amount, bool _sign, uint256 _updatedStake) internal {
814         if (!shouldNotifyStakeChange()) {
815             return;
816         }
817 
818         notifier.stakeChange(_stakeOwner, _amount, _sign, _updatedStake);
819     }
820 
821     /// @dev Notifies of multiple stake change events.
822     /// @param _stakeOwners address[] The addresses of subject stake owners.
823     /// @param _amounts uint256[] The differences in total staked amounts.
824     /// @param _signs bool[] The signs of the added (true) or subtracted (false) amounts.
825     /// @param _updatedStakes uint256[] The updated total staked amounts.
826     function stakeChangeBatch(address[] memory _stakeOwners, uint256[] memory _amounts, bool[] memory _signs,
827         uint256[] memory _updatedStakes) internal {
828         if (!shouldNotifyStakeChange()) {
829             return;
830         }
831 
832         notifier.stakeChangeBatch(_stakeOwners, _amounts, _signs, _updatedStakes);
833     }
834 
835     /// @dev Notifies of stake migration event.
836     /// @param _stakeOwner address The address of the subject stake owner.
837     /// @param _amount uint256 The migrated amount.
838     function stakeMigration(address _stakeOwner, uint256 _amount) internal {
839         if (!shouldNotifyStakeChange()) {
840             return;
841         }
842 
843         notifier.stakeMigration(_stakeOwner, _amount);
844     }
845 
846     /// @dev Stakes amount of ORBS tokens on behalf of the specified stake owner.
847     /// @param _stakeOwner address The specified stake owner.
848     /// @param _amount uint256 The amount of tokens to stake.
849     /// @return totalStakedAmount uint256 The total stake of the stake owner.
850     function stake(address _stakeOwner, uint256 _amount) private returns (uint256 totalStakedAmount) {
851         require(_stakeOwner != address(0), "StakingContract::stake - stake owner can't be 0");
852         require(_amount > 0, "StakingContract::stake - amount must be greater than 0");
853 
854         Stake storage stakeData = stakes[_stakeOwner];
855         stakeData.amount = stakeData.amount.add(_amount);
856 
857         totalStakedTokens = totalStakedTokens.add(_amount);
858 
859         totalStakedAmount = stakeData.amount;
860 
861         // Transfer the tokens to the smart contract and update the stake owners list accordingly.
862         require(token.transferFrom(msg.sender, address(this), _amount),
863             "StakingContract::stake - insufficient allowance");
864     }
865 
866     /// @dev Requests to withdraw all of staked ORBS tokens back to the specified stake owner. Stake owners can withdraw
867     /// their ORBS tokens only after previously unstaking them and after the cooldown period has passed (unless the
868     /// contract was requested to release all stakes).
869     /// @return res WithdrawResult The result of the withdraw operation.
870     function withdraw(address _stakeOwner) private returns (WithdrawResult memory res) {
871         require(_stakeOwner != address(0), "StakingContract::withdraw - stake owner can't be 0");
872 
873         Stake storage stakeData = stakes[_stakeOwner];
874         res.stakedAmount = stakeData.amount;
875         res.withdrawnAmount = stakeData.cooldownAmount;
876         res.stakedAmountDiff = 0;
877 
878         if (!releasingAllStakes) {
879             require(res.withdrawnAmount > 0, "StakingContract::withdraw - no unstaked tokens");
880             require(stakeData.cooldownEndTime <= now, "StakingContract::withdraw - tokens are still in cooldown");
881         } else {
882             // If the contract was requested to release all stakes - allow to withdraw all staked and unstaked tokens.
883             res.withdrawnAmount = res.withdrawnAmount.add(res.stakedAmount);
884             res.stakedAmountDiff = res.stakedAmount;
885 
886             require(res.withdrawnAmount > 0, "StakingContract::withdraw - no staked or unstaked tokens");
887 
888             stakeData.amount = 0;
889 
890             totalStakedTokens = totalStakedTokens.sub(res.stakedAmount);
891 
892             res.stakedAmount = 0;
893         }
894 
895         stakeData.cooldownAmount = 0;
896         stakeData.cooldownEndTime = 0;
897 
898         require(token.transfer(_stakeOwner, res.withdrawnAmount),
899             "StakingContract::withdraw - couldn't transfer stake");
900     }
901 
902     /// @dev Returns an index of an existing approved staking contract.
903     /// @param _stakingContract IMigratableStakingContract The staking contract to look for.
904     /// @return index uint The index of the located staking contract (in the case that it was found).
905     /// @return exists bool The search result.
906     function findApprovedStakingContractIndex(IMigratableStakingContract _stakingContract) private view returns
907         (uint index, bool exists) {
908         uint length = approvedStakingContracts.length;
909         for (index = 0; index < length; ++index) {
910             if (approvedStakingContracts[index] == _stakingContract) {
911                 exists = true;
912                 return (index, exists);
913             }
914         }
915 
916         exists = false;
917     }
918 }