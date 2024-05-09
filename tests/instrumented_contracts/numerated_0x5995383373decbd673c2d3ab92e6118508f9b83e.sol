1 // Sources flattened with hardhat v2.6.8 https://hardhat.org
2 
3 // File @openzeppelin/contracts/utils/Context.sol@v3.4.2
4 
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity >=0.6.0 <0.8.0;
8 
9 /*
10  * @dev Provides information about the current execution context, including the
11  * sender of the transaction and its data. While these are generally available
12  * via msg.sender and msg.data, they should not be accessed in such a direct
13  * manner, since when dealing with GSN meta-transactions the account sending and
14  * paying for execution may not be the actual sender (as far as an application
15  * is concerned).
16  *
17  * This contract is only required for intermediate, library-like contracts.
18  */
19 abstract contract Context {
20     function _msgSender() internal view virtual returns (address payable) {
21         return msg.sender;
22     }
23 
24     function _msgData() internal view virtual returns (bytes memory) {
25         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
26         return msg.data;
27     }
28 }
29 
30 
31 // File @openzeppelin/contracts/access/Ownable.sol@v3.4.2
32 
33 
34 
35 pragma solidity >=0.6.0 <0.8.0;
36 
37 /**
38  * @dev Contract module which provides a basic access control mechanism, where
39  * there is an account (an owner) that can be granted exclusive access to
40  * specific functions.
41  *
42  * By default, the owner account will be the one that deploys the contract. This
43  * can later be changed with {transferOwnership}.
44  *
45  * This module is used through inheritance. It will make available the modifier
46  * `onlyOwner`, which can be applied to your functions to restrict their use to
47  * the owner.
48  */
49 abstract contract Ownable is Context {
50     address private _owner;
51 
52     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
53 
54     /**
55      * @dev Initializes the contract setting the deployer as the initial owner.
56      */
57     constructor () internal {
58         address msgSender = _msgSender();
59         _owner = msgSender;
60         emit OwnershipTransferred(address(0), msgSender);
61     }
62 
63     /**
64      * @dev Returns the address of the current owner.
65      */
66     function owner() public view virtual returns (address) {
67         return _owner;
68     }
69 
70     /**
71      * @dev Throws if called by any account other than the owner.
72      */
73     modifier onlyOwner() {
74         require(owner() == _msgSender(), "Ownable: caller is not the owner");
75         _;
76     }
77 
78     /**
79      * @dev Leaves the contract without owner. It will not be possible to call
80      * `onlyOwner` functions anymore. Can only be called by the current owner.
81      *
82      * NOTE: Renouncing ownership will leave the contract without an owner,
83      * thereby removing any functionality that is only available to the owner.
84      */
85     function renounceOwnership() public virtual onlyOwner {
86         emit OwnershipTransferred(_owner, address(0));
87         _owner = address(0);
88     }
89 
90     /**
91      * @dev Transfers ownership of the contract to a new account (`newOwner`).
92      * Can only be called by the current owner.
93      */
94     function transferOwnership(address newOwner) public virtual onlyOwner {
95         require(newOwner != address(0), "Ownable: new owner is the zero address");
96         emit OwnershipTransferred(_owner, newOwner);
97         _owner = newOwner;
98     }
99 }
100 
101 
102 // File @openzeppelin/contracts/math/Math.sol@v3.4.2
103 
104 
105 
106 pragma solidity >=0.6.0 <0.8.0;
107 
108 /**
109  * @dev Standard math utilities missing in the Solidity language.
110  */
111 library Math {
112     /**
113      * @dev Returns the largest of two numbers.
114      */
115     function max(uint256 a, uint256 b) internal pure returns (uint256) {
116         return a >= b ? a : b;
117     }
118 
119     /**
120      * @dev Returns the smallest of two numbers.
121      */
122     function min(uint256 a, uint256 b) internal pure returns (uint256) {
123         return a < b ? a : b;
124     }
125 
126     /**
127      * @dev Returns the average of two numbers. The result is rounded towards
128      * zero.
129      */
130     function average(uint256 a, uint256 b) internal pure returns (uint256) {
131         // (a + b) / 2 can overflow, so we distribute
132         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
133     }
134 }
135 
136 
137 // File @openzeppelin/contracts/math/SafeMath.sol@v3.4.2
138 
139 
140 
141 pragma solidity >=0.6.0 <0.8.0;
142 
143 /**
144  * @dev Wrappers over Solidity's arithmetic operations with added overflow
145  * checks.
146  *
147  * Arithmetic operations in Solidity wrap on overflow. This can easily result
148  * in bugs, because programmers usually assume that an overflow raises an
149  * error, which is the standard behavior in high level programming languages.
150  * `SafeMath` restores this intuition by reverting the transaction when an
151  * operation overflows.
152  *
153  * Using this library instead of the unchecked operations eliminates an entire
154  * class of bugs, so it's recommended to use it always.
155  */
156 library SafeMath {
157     /**
158      * @dev Returns the addition of two unsigned integers, with an overflow flag.
159      *
160      * _Available since v3.4._
161      */
162     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
163         uint256 c = a + b;
164         if (c < a) return (false, 0);
165         return (true, c);
166     }
167 
168     /**
169      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
170      *
171      * _Available since v3.4._
172      */
173     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
174         if (b > a) return (false, 0);
175         return (true, a - b);
176     }
177 
178     /**
179      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
180      *
181      * _Available since v3.4._
182      */
183     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
184         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
185         // benefit is lost if 'b' is also tested.
186         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
187         if (a == 0) return (true, 0);
188         uint256 c = a * b;
189         if (c / a != b) return (false, 0);
190         return (true, c);
191     }
192 
193     /**
194      * @dev Returns the division of two unsigned integers, with a division by zero flag.
195      *
196      * _Available since v3.4._
197      */
198     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
199         if (b == 0) return (false, 0);
200         return (true, a / b);
201     }
202 
203     /**
204      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
205      *
206      * _Available since v3.4._
207      */
208     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
209         if (b == 0) return (false, 0);
210         return (true, a % b);
211     }
212 
213     /**
214      * @dev Returns the addition of two unsigned integers, reverting on
215      * overflow.
216      *
217      * Counterpart to Solidity's `+` operator.
218      *
219      * Requirements:
220      *
221      * - Addition cannot overflow.
222      */
223     function add(uint256 a, uint256 b) internal pure returns (uint256) {
224         uint256 c = a + b;
225         require(c >= a, "SafeMath: addition overflow");
226         return c;
227     }
228 
229     /**
230      * @dev Returns the subtraction of two unsigned integers, reverting on
231      * overflow (when the result is negative).
232      *
233      * Counterpart to Solidity's `-` operator.
234      *
235      * Requirements:
236      *
237      * - Subtraction cannot overflow.
238      */
239     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
240         require(b <= a, "SafeMath: subtraction overflow");
241         return a - b;
242     }
243 
244     /**
245      * @dev Returns the multiplication of two unsigned integers, reverting on
246      * overflow.
247      *
248      * Counterpart to Solidity's `*` operator.
249      *
250      * Requirements:
251      *
252      * - Multiplication cannot overflow.
253      */
254     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
255         if (a == 0) return 0;
256         uint256 c = a * b;
257         require(c / a == b, "SafeMath: multiplication overflow");
258         return c;
259     }
260 
261     /**
262      * @dev Returns the integer division of two unsigned integers, reverting on
263      * division by zero. The result is rounded towards zero.
264      *
265      * Counterpart to Solidity's `/` operator. Note: this function uses a
266      * `revert` opcode (which leaves remaining gas untouched) while Solidity
267      * uses an invalid opcode to revert (consuming all remaining gas).
268      *
269      * Requirements:
270      *
271      * - The divisor cannot be zero.
272      */
273     function div(uint256 a, uint256 b) internal pure returns (uint256) {
274         require(b > 0, "SafeMath: division by zero");
275         return a / b;
276     }
277 
278     /**
279      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
280      * reverting when dividing by zero.
281      *
282      * Counterpart to Solidity's `%` operator. This function uses a `revert`
283      * opcode (which leaves remaining gas untouched) while Solidity uses an
284      * invalid opcode to revert (consuming all remaining gas).
285      *
286      * Requirements:
287      *
288      * - The divisor cannot be zero.
289      */
290     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
291         require(b > 0, "SafeMath: modulo by zero");
292         return a % b;
293     }
294 
295     /**
296      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
297      * overflow (when the result is negative).
298      *
299      * CAUTION: This function is deprecated because it requires allocating memory for the error
300      * message unnecessarily. For custom revert reasons use {trySub}.
301      *
302      * Counterpart to Solidity's `-` operator.
303      *
304      * Requirements:
305      *
306      * - Subtraction cannot overflow.
307      */
308     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
309         require(b <= a, errorMessage);
310         return a - b;
311     }
312 
313     /**
314      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
315      * division by zero. The result is rounded towards zero.
316      *
317      * CAUTION: This function is deprecated because it requires allocating memory for the error
318      * message unnecessarily. For custom revert reasons use {tryDiv}.
319      *
320      * Counterpart to Solidity's `/` operator. Note: this function uses a
321      * `revert` opcode (which leaves remaining gas untouched) while Solidity
322      * uses an invalid opcode to revert (consuming all remaining gas).
323      *
324      * Requirements:
325      *
326      * - The divisor cannot be zero.
327      */
328     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
329         require(b > 0, errorMessage);
330         return a / b;
331     }
332 
333     /**
334      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
335      * reverting with custom message when dividing by zero.
336      *
337      * CAUTION: This function is deprecated because it requires allocating memory for the error
338      * message unnecessarily. For custom revert reasons use {tryMod}.
339      *
340      * Counterpart to Solidity's `%` operator. This function uses a `revert`
341      * opcode (which leaves remaining gas untouched) while Solidity uses an
342      * invalid opcode to revert (consuming all remaining gas).
343      *
344      * Requirements:
345      *
346      * - The divisor cannot be zero.
347      */
348     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
349         require(b > 0, errorMessage);
350         return a % b;
351     }
352 }
353 
354 
355 // File contracts/interfaces/IStakingPoolMigrator.sol
356 
357 
358 pragma solidity ^0.7.6;
359 
360 interface IStakingPoolMigrator {
361     function migrate(
362         uint256 poolId,
363         address oldToken,
364         uint256 amount
365     ) external returns (address);
366 }
367 
368 
369 // File contracts/interfaces/IStakingPoolRewarder.sol
370 
371 
372 pragma solidity ^0.7.6;
373 
374 interface IStakingPoolRewarder {
375     function onReward(
376         uint256 poolId,
377         address user,
378         uint256 amount
379     ) external;
380 }
381 
382 
383 // File contracts/StakingPools.sol
384 
385 
386 pragma solidity ^0.7.6;
387 
388 
389 
390 
391 
392 /**
393  * @title StakingPools
394  *
395  * @dev A contract for staking Uniswap LP tokens in exchange for locked CONV rewards.
396  * No actual CONV tokens will be held or distributed by this contract. Only the amounts
397  * are accumulated.
398  *
399  * @dev The `migrator` in this contract has access to users' staked tokens. Any changes
400  * to the migrator address will only take effect after a delay period specified at contract
401  * creation.
402  *
403  * @dev This contract interacts with token contracts via `safeApprove`, `safeTransfer`,
404  * and `safeTransferFrom` instead of the standard Solidity interface so that some non-ERC20-
405  * compatible tokens (e.g. Tether) can also be staked.
406  */
407 contract StakingPools is Ownable {
408     using SafeMath for uint256;
409 
410     event PoolCreated(
411         uint256 indexed poolId,
412         address indexed token,
413         uint256 startBlock,
414         uint256 endBlock,
415         uint256 migrationBlock,
416         uint256 rewardPerBlock
417     );
418     event PoolEndBlockExtended(uint256 indexed poolId, uint256 oldEndBlock, uint256 newEndBlock);
419     event PoolMigrationBlockExtended(uint256 indexed poolId, uint256 oldMigrationBlock, uint256 newMigrationBlock);
420     event PoolRewardRateChanged(uint256 indexed poolId, uint256 oldRewardPerBlock, uint256 newRewardPerBlock);
421     event MigratorChangeProposed(address newMigrator);
422     event MigratorChanged(address oldMigrator, address newMigrator);
423     event RewarderChanged(address oldRewarder, address newRewarder);
424     event PoolMigrated(uint256 indexed poolId, address oldToken, address newToken);
425     event Staked(uint256 indexed poolId, address indexed staker, address token, uint256 amount);
426     event Unstaked(uint256 indexed poolId, address indexed staker, address token, uint256 amount);
427     event RewardRedeemed(uint256 indexed poolId, address indexed staker, address rewarder, uint256 amount);
428 
429     /**
430      * @param startBlock the block from which reward accumulation starts
431      * @param endBlock the block from which reward accumulation stops
432      * @param migrationBlock the block since which LP token migration can be triggered
433      * @param rewardPerBlock total amount of token to be rewarded in a block
434      * @param poolToken token to be staked
435      */
436     struct PoolInfo {
437         uint256 startBlock;
438         uint256 endBlock;
439         uint256 migrationBlock;
440         uint256 rewardPerBlock;
441         address poolToken;
442     }
443     /**
444      * @param totalStakeAmount total amount of staked tokens
445      * @param accuRewardPerShare accumulated rewards for a single unit of token staked, multiplied by `ACCU_REWARD_MULTIPLIER`
446      * @param accuRewardLastUpdateBlock the block number at which the `accuRewardPerShare` field was last updated
447      */
448     struct PoolData {
449         uint256 totalStakeAmount;
450         uint256 accuRewardPerShare;
451         uint256 accuRewardLastUpdateBlock;
452     }
453     /**
454      * @param stakeAmount amount of token the user stakes
455      * @param pendingReward amount of reward to be redeemed by the user up to the user's last action
456      * @param entryAccuRewardPerShare the `accuRewardPerShare` value at the user's last stake/unstake action
457      */
458     struct UserData {
459         uint256 stakeAmount;
460         uint256 pendingReward;
461         uint256 entryAccuRewardPerShare;
462     }
463     /**
464      * @param proposeTime timestamp when the change is proposed
465      * @param newMigrator new migrator address
466      */
467     struct PendingMigratorChange {
468         uint64 proposeTime;
469         address newMigrator;
470     }
471 
472     uint256 public lastPoolId; // The first pool has ID of 1
473 
474     IStakingPoolMigrator public migrator;
475     uint256 public migratorSetterDelay;
476     PendingMigratorChange public pendingMigrator;
477 
478     IStakingPoolRewarder public rewarder;
479 
480     mapping(uint256 => PoolInfo) public poolInfos;
481     mapping(uint256 => PoolData) public poolData;
482     mapping(uint256 => mapping(address => UserData)) public userData;
483 
484     uint256 private constant ACCU_REWARD_MULTIPLIER = 10**20; // Precision loss prevention
485 
486     bytes4 private constant TRANSFER_SELECTOR = bytes4(keccak256(bytes("transfer(address,uint256)")));
487     bytes4 private constant APPROVE_SELECTOR = bytes4(keccak256(bytes("approve(address,uint256)")));
488     bytes4 private constant TRANSFERFROM_SELECTOR = bytes4(keccak256(bytes("transferFrom(address,address,uint256)")));
489 
490     modifier onlyPoolExists(uint256 poolId) {
491         require(poolInfos[poolId].endBlock > 0, "StakingPools: pool not found");
492         _;
493     }
494 
495     modifier onlyPoolActive(uint256 poolId) {
496         require(
497             block.number >= poolInfos[poolId].startBlock && block.number < poolInfos[poolId].endBlock,
498             "StakingPools: pool not active"
499         );
500         _;
501     }
502 
503     modifier onlyPoolNotEnded(uint256 poolId) {
504         require(block.number < poolInfos[poolId].endBlock, "StakingPools: pool ended");
505         _;
506     }
507 
508     function getReward(uint256 poolId, address staker) external view returns (uint256) {
509         UserData memory currentUserData = userData[poolId][staker];
510         PoolInfo memory currentPoolInfo = poolInfos[poolId];
511         PoolData memory currentPoolData = poolData[poolId];
512 
513         uint256 latestAccuRewardPerShare =
514             currentPoolData.totalStakeAmount > 0
515                 ? currentPoolData.accuRewardPerShare.add(
516                     Math
517                         .min(block.number, currentPoolInfo.endBlock)
518                         .sub(currentPoolData.accuRewardLastUpdateBlock)
519                         .mul(currentPoolInfo.rewardPerBlock)
520                         .mul(ACCU_REWARD_MULTIPLIER)
521                         .div(currentPoolData.totalStakeAmount)
522                 )
523                 : currentPoolData.accuRewardPerShare;
524 
525         return
526             currentUserData.pendingReward.add(
527                 currentUserData.stakeAmount.mul(latestAccuRewardPerShare.sub(currentUserData.entryAccuRewardPerShare)).div(
528                     ACCU_REWARD_MULTIPLIER
529                 )
530             );
531     }
532 
533     constructor(uint256 _migratorSetterDelay) {
534         require(_migratorSetterDelay > 0, "StakingPools: zero setter delay");
535 
536         migratorSetterDelay = _migratorSetterDelay;
537     }
538 
539     function createPool(
540         address token,
541         uint256 startBlock,
542         uint256 endBlock,
543         uint256 migrationBlock,
544         uint256 rewardPerBlock
545     ) external onlyOwner {
546         require(token != address(0), "StakingPools: zero address");
547         require(
548             startBlock > block.number && endBlock > startBlock && migrationBlock > startBlock,
549             "StakingPools: invalid block range"
550         );
551         require(rewardPerBlock > 0, "StakingPools: reward must be positive");
552 
553         uint256 newPoolId = ++lastPoolId;
554 
555         poolInfos[newPoolId] = PoolInfo({
556             startBlock: startBlock,
557             endBlock: endBlock,
558             migrationBlock: migrationBlock,
559             rewardPerBlock: rewardPerBlock,
560             poolToken: token
561         });
562         poolData[newPoolId] = PoolData({totalStakeAmount: 0, accuRewardPerShare: 0, accuRewardLastUpdateBlock: startBlock});
563 
564         emit PoolCreated(newPoolId, token, startBlock, endBlock, migrationBlock, rewardPerBlock);
565     }
566 
567     function extendEndBlock(uint256 poolId, uint256 newEndBlock)
568         external
569         onlyOwner
570         onlyPoolExists(poolId)
571         onlyPoolNotEnded(poolId)
572     {
573         uint256 currentEndBlock = poolInfos[poolId].endBlock;
574         require(newEndBlock > currentEndBlock, "StakingPools: end block not extended");
575 
576         poolInfos[poolId].endBlock = newEndBlock;
577 
578         emit PoolEndBlockExtended(poolId, currentEndBlock, newEndBlock);
579     }
580 
581     function extendMigrationBlock(uint256 poolId, uint256 newMigrationBlock)
582         external
583         onlyOwner
584         onlyPoolExists(poolId)
585         onlyPoolNotEnded(poolId)
586     {
587         uint256 currentMigrationBlock = poolInfos[poolId].migrationBlock;
588         require(newMigrationBlock > currentMigrationBlock, "StakingPools: migration block not extended");
589 
590         poolInfos[poolId].migrationBlock = newMigrationBlock;
591 
592         emit PoolMigrationBlockExtended(poolId, currentMigrationBlock, newMigrationBlock);
593     }
594 
595     function setPoolReward(uint256 poolId, uint256 newRewardPerBlock)
596         external
597         onlyOwner
598         onlyPoolExists(poolId)
599         onlyPoolNotEnded(poolId)
600     {
601         if (block.number >= poolInfos[poolId].startBlock) {
602             // "Settle" rewards up to this block
603             _updatePoolAccuReward(poolId);
604         }
605 
606         // We're deliberately allowing setting the reward rate to 0 here. If it turns
607         // out this, or even changing rates at all, is undesirable after deployment, the
608         // ownership of this contract can be transferred to a contract incapable of making
609         // calls to this function.
610         uint256 currentRewardPerBlock = poolInfos[poolId].rewardPerBlock;
611         poolInfos[poolId].rewardPerBlock = newRewardPerBlock;
612 
613         emit PoolRewardRateChanged(poolId, currentRewardPerBlock, newRewardPerBlock);
614     }
615 
616     function proposeMigratorChange(address newMigrator) external onlyOwner {
617         pendingMigrator = PendingMigratorChange({proposeTime: uint64(block.timestamp), newMigrator: newMigrator});
618 
619         emit MigratorChangeProposed(newMigrator);
620     }
621 
622     function executeMigratorChange() external {
623         require(pendingMigrator.proposeTime > 0, "StakingPools: migrator change proposal not found");
624         require(
625             block.timestamp >= uint256(pendingMigrator.proposeTime).add(migratorSetterDelay),
626             "StakingPools: migrator setter delay not passed"
627         );
628 
629         address oldMigrator = address(migrator);
630         migrator = IStakingPoolMigrator(pendingMigrator.newMigrator);
631 
632         // Clear storage
633         pendingMigrator = PendingMigratorChange({proposeTime: 0, newMigrator: address(0)});
634 
635         emit MigratorChanged(oldMigrator, address(migrator));
636     }
637 
638     function setRewarder(address newRewarder) external onlyOwner {
639         address oldRewarder = address(rewarder);
640         rewarder = IStakingPoolRewarder(newRewarder);
641 
642         emit RewarderChanged(oldRewarder, newRewarder);
643     }
644 
645     function migratePool(uint256 poolId) external onlyPoolExists(poolId) {
646         require(address(migrator) != address(0), "StakingPools: migrator not set");
647 
648         PoolInfo memory currentPoolInfo = poolInfos[poolId];
649         PoolData memory currentPoolData = poolData[poolId];
650         require(block.number >= currentPoolInfo.migrationBlock, "StakingPools: migration block not reached");
651 
652         safeApprove(currentPoolInfo.poolToken, address(migrator), currentPoolData.totalStakeAmount);
653 
654         // New token balance is not validated here since the migrator can do whatever
655         // it wants anyways (including providing a fake token address with fake balance).
656         // It's the migrator contract's responsibility to ensure tokens are properly migrated.
657         address newToken =
658             migrator.migrate(poolId, address(currentPoolInfo.poolToken), uint256(currentPoolData.totalStakeAmount));
659         require(newToken != address(0), "StakingPools: zero new token address");
660 
661         poolInfos[poolId].poolToken = newToken;
662 
663         emit PoolMigrated(poolId, currentPoolInfo.poolToken, newToken);
664     }
665 
666     function stake(uint256 poolId, uint256 amount) external onlyPoolExists(poolId) onlyPoolActive(poolId) {
667         _updatePoolAccuReward(poolId);
668         _updateStakerReward(poolId, msg.sender);
669 
670         _stake(poolId, msg.sender, amount);
671     }
672 
673     function unstake(uint256 poolId, uint256 amount) external onlyPoolExists(poolId) {
674         _updatePoolAccuReward(poolId);
675         _updateStakerReward(poolId, msg.sender);
676 
677         _unstake(poolId, msg.sender, amount);
678     }
679 
680     function emergencyUnstake(uint256 poolId) external onlyPoolExists(poolId) {
681         _unstake(poolId, msg.sender, userData[poolId][msg.sender].stakeAmount);
682 
683         // Forfeit user rewards to avoid abuse
684         userData[poolId][msg.sender].pendingReward = 0;
685     }
686 
687     function redeemRewards(uint256 poolId) external onlyPoolExists(poolId) {
688         redeemRewardsByAddress(poolId, msg.sender);
689     }
690 
691     function redeemRewardsByAddress(uint256 poolId, address user) public onlyPoolExists(poolId) {
692         require(user != address(0), "StakingPools: zero address");
693 
694         _updatePoolAccuReward(poolId);
695         _updateStakerReward(poolId, user);
696 
697         require(address(rewarder) != address(0), "StakingPools: rewarder not set");
698 
699         uint256 rewardToRedeem = userData[poolId][user].pendingReward;
700         require(rewardToRedeem > 0, "StakingPools: no reward to redeem");
701 
702         userData[poolId][user].pendingReward = 0;
703 
704         rewarder.onReward(poolId, user, rewardToRedeem);
705 
706         emit RewardRedeemed(poolId, user, address(rewarder), rewardToRedeem);
707     }
708 
709     function _stake(
710         uint256 poolId,
711         address user,
712         uint256 amount
713     ) private {
714         require(amount > 0, "StakingPools: cannot stake zero amount");
715 
716         userData[poolId][user].stakeAmount = userData[poolId][user].stakeAmount.add(amount);
717         poolData[poolId].totalStakeAmount = poolData[poolId].totalStakeAmount.add(amount);
718 
719         safeTransferFrom(poolInfos[poolId].poolToken, user, address(this), amount);
720 
721         emit Staked(poolId, user, poolInfos[poolId].poolToken, amount);
722     }
723 
724     function _unstake(
725         uint256 poolId,
726         address user,
727         uint256 amount
728     ) private {
729         require(amount > 0, "StakingPools: cannot unstake zero amount");
730 
731         // No sufficiency check required as sub() will throw anyways
732         userData[poolId][user].stakeAmount = userData[poolId][user].stakeAmount.sub(amount);
733         poolData[poolId].totalStakeAmount = poolData[poolId].totalStakeAmount.sub(amount);
734 
735         safeTransfer(poolInfos[poolId].poolToken, user, amount);
736 
737         emit Unstaked(poolId, user, poolInfos[poolId].poolToken, amount);
738     }
739 
740     function _updatePoolAccuReward(uint256 poolId) private {
741         PoolInfo storage currentPoolInfo = poolInfos[poolId];
742         PoolData storage currentPoolData = poolData[poolId];
743 
744         uint256 appliedUpdateBlock = Math.min(block.number, currentPoolInfo.endBlock);
745         uint256 durationInBlocks = appliedUpdateBlock.sub(currentPoolData.accuRewardLastUpdateBlock);
746 
747         // This saves tx cost when being called multiple times in the same block
748         if (durationInBlocks > 0) {
749             // No need to update the rate if no one staked at all
750             if (currentPoolData.totalStakeAmount > 0) {
751                 currentPoolData.accuRewardPerShare = currentPoolData.accuRewardPerShare.add(
752                     durationInBlocks.mul(currentPoolInfo.rewardPerBlock).mul(ACCU_REWARD_MULTIPLIER).div(
753                         currentPoolData.totalStakeAmount
754                     )
755                 );
756             }
757             currentPoolData.accuRewardLastUpdateBlock = appliedUpdateBlock;
758         }
759     }
760 
761     function _updateStakerReward(uint256 poolId, address staker) private {
762         UserData storage currentUserData = userData[poolId][staker];
763         PoolData storage currentPoolData = poolData[poolId];
764 
765         uint256 stakeAmount = currentUserData.stakeAmount;
766         uint256 stakerEntryRate = currentUserData.entryAccuRewardPerShare;
767         uint256 accuDifference = currentPoolData.accuRewardPerShare.sub(stakerEntryRate);
768 
769         if (accuDifference > 0) {
770             currentUserData.pendingReward = currentUserData.pendingReward.add(
771                 stakeAmount.mul(accuDifference).div(ACCU_REWARD_MULTIPLIER)
772             );
773             currentUserData.entryAccuRewardPerShare = currentPoolData.accuRewardPerShare;
774         }
775     }
776 
777     function safeApprove(
778         address token,
779         address spender,
780         uint256 amount
781     ) internal {
782         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(APPROVE_SELECTOR, spender, amount));
783         require(success && (data.length == 0 || abi.decode(data, (bool))), "StakingPools: approve failed");
784     }
785 
786     function safeTransfer(
787         address token,
788         address recipient,
789         uint256 amount
790     ) private {
791         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(TRANSFER_SELECTOR, recipient, amount));
792         require(success && (data.length == 0 || abi.decode(data, (bool))), "StakingPools: transfer failed");
793     }
794 
795     function safeTransferFrom(
796         address token,
797         address sender,
798         address recipient,
799         uint256 amount
800     ) private {
801         (bool success, bytes memory data) =
802             token.call(abi.encodeWithSelector(TRANSFERFROM_SELECTOR, sender, recipient, amount));
803         require(success && (data.length == 0 || abi.decode(data, (bool))), "StakingPools: transferFrom failed");
804     }
805 }