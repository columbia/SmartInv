1 // SPDX-License-Identifier: MIT
2 
3 // File @openzeppelin/contracts/utils/Context.sol@v3.4.1
4 
5 pragma solidity >=0.6.0 <0.8.0;
6 
7 /*
8  * @dev Provides information about the current execution context, including the
9  * sender of the transaction and its data. While these are generally available
10  * via msg.sender and msg.data, they should not be accessed in such a direct
11  * manner, since when dealing with GSN meta-transactions the account sending and
12  * paying for execution may not be the actual sender (as far as an application
13  * is concerned).
14  *
15  * This contract is only required for intermediate, library-like contracts.
16  */
17 abstract contract Context {
18     function _msgSender() internal view virtual returns (address payable) {
19         return msg.sender;
20     }
21 
22     function _msgData() internal view virtual returns (bytes memory) {
23         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
24         return msg.data;
25     }
26 }
27 
28 // File @openzeppelin/contracts/access/Ownable.sol@v3.4.1
29 
30 pragma solidity >=0.6.0 <0.8.0;
31 
32 /**
33  * @dev Contract module which provides a basic access control mechanism, where
34  * there is an account (an owner) that can be granted exclusive access to
35  * specific functions.
36  *
37  * By default, the owner account will be the one that deploys the contract. This
38  * can later be changed with {transferOwnership}.
39  *
40  * This module is used through inheritance. It will make available the modifier
41  * `onlyOwner`, which can be applied to your functions to restrict their use to
42  * the owner.
43  */
44 abstract contract Ownable is Context {
45     address private _owner;
46 
47     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
48 
49     /**
50      * @dev Initializes the contract setting the deployer as the initial owner.
51      */
52     constructor() internal {
53         address msgSender = _msgSender();
54         _owner = msgSender;
55         emit OwnershipTransferred(address(0), msgSender);
56     }
57 
58     /**
59      * @dev Returns the address of the current owner.
60      */
61     function owner() public view virtual returns (address) {
62         return _owner;
63     }
64 
65     /**
66      * @dev Throws if called by any account other than the owner.
67      */
68     modifier onlyOwner() {
69         require(owner() == _msgSender(), "Ownable: caller is not the owner");
70         _;
71     }
72 
73     /**
74      * @dev Leaves the contract without owner. It will not be possible to call
75      * `onlyOwner` functions anymore. Can only be called by the current owner.
76      *
77      * NOTE: Renouncing ownership will leave the contract without an owner,
78      * thereby removing any functionality that is only available to the owner.
79      */
80     function renounceOwnership() public virtual onlyOwner {
81         emit OwnershipTransferred(_owner, address(0));
82         _owner = address(0);
83     }
84 
85     /**
86      * @dev Transfers ownership of the contract to a new account (`newOwner`).
87      * Can only be called by the current owner.
88      */
89     function transferOwnership(address newOwner) public virtual onlyOwner {
90         require(newOwner != address(0), "Ownable: new owner is the zero address");
91         emit OwnershipTransferred(_owner, newOwner);
92         _owner = newOwner;
93     }
94 }
95 
96 // File @openzeppelin/contracts/math/Math.sol@v3.4.1
97 
98 pragma solidity >=0.6.0 <0.8.0;
99 
100 /**
101  * @dev Standard math utilities missing in the Solidity language.
102  */
103 library Math {
104     /**
105      * @dev Returns the largest of two numbers.
106      */
107     function max(uint256 a, uint256 b) internal pure returns (uint256) {
108         return a >= b ? a : b;
109     }
110 
111     /**
112      * @dev Returns the smallest of two numbers.
113      */
114     function min(uint256 a, uint256 b) internal pure returns (uint256) {
115         return a < b ? a : b;
116     }
117 
118     /**
119      * @dev Returns the average of two numbers. The result is rounded towards
120      * zero.
121      */
122     function average(uint256 a, uint256 b) internal pure returns (uint256) {
123         // (a + b) / 2 can overflow, so we distribute
124         return (a / 2) + (b / 2) + (((a % 2) + (b % 2)) / 2);
125     }
126 }
127 
128 // File @openzeppelin/contracts/math/SafeMath.sol@v3.4.1
129 
130 pragma solidity >=0.6.0 <0.8.0;
131 
132 /**
133  * @dev Wrappers over Solidity's arithmetic operations with added overflow
134  * checks.
135  *
136  * Arithmetic operations in Solidity wrap on overflow. This can easily result
137  * in bugs, because programmers usually assume that an overflow raises an
138  * error, which is the standard behavior in high level programming languages.
139  * `SafeMath` restores this intuition by reverting the transaction when an
140  * operation overflows.
141  *
142  * Using this library instead of the unchecked operations eliminates an entire
143  * class of bugs, so it's recommended to use it always.
144  */
145 library SafeMath {
146     /**
147      * @dev Returns the addition of two unsigned integers, with an overflow flag.
148      *
149      * _Available since v3.4._
150      */
151     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
152         uint256 c = a + b;
153         if (c < a) return (false, 0);
154         return (true, c);
155     }
156 
157     /**
158      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
159      *
160      * _Available since v3.4._
161      */
162     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
163         if (b > a) return (false, 0);
164         return (true, a - b);
165     }
166 
167     /**
168      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
169      *
170      * _Available since v3.4._
171      */
172     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
173         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
174         // benefit is lost if 'b' is also tested.
175         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
176         if (a == 0) return (true, 0);
177         uint256 c = a * b;
178         if (c / a != b) return (false, 0);
179         return (true, c);
180     }
181 
182     /**
183      * @dev Returns the division of two unsigned integers, with a division by zero flag.
184      *
185      * _Available since v3.4._
186      */
187     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
188         if (b == 0) return (false, 0);
189         return (true, a / b);
190     }
191 
192     /**
193      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
194      *
195      * _Available since v3.4._
196      */
197     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
198         if (b == 0) return (false, 0);
199         return (true, a % b);
200     }
201 
202     /**
203      * @dev Returns the addition of two unsigned integers, reverting on
204      * overflow.
205      *
206      * Counterpart to Solidity's `+` operator.
207      *
208      * Requirements:
209      *
210      * - Addition cannot overflow.
211      */
212     function add(uint256 a, uint256 b) internal pure returns (uint256) {
213         uint256 c = a + b;
214         require(c >= a, "SafeMath: addition overflow");
215         return c;
216     }
217 
218     /**
219      * @dev Returns the subtraction of two unsigned integers, reverting on
220      * overflow (when the result is negative).
221      *
222      * Counterpart to Solidity's `-` operator.
223      *
224      * Requirements:
225      *
226      * - Subtraction cannot overflow.
227      */
228     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
229         require(b <= a, "SafeMath: subtraction overflow");
230         return a - b;
231     }
232 
233     /**
234      * @dev Returns the multiplication of two unsigned integers, reverting on
235      * overflow.
236      *
237      * Counterpart to Solidity's `*` operator.
238      *
239      * Requirements:
240      *
241      * - Multiplication cannot overflow.
242      */
243     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
244         if (a == 0) return 0;
245         uint256 c = a * b;
246         require(c / a == b, "SafeMath: multiplication overflow");
247         return c;
248     }
249 
250     /**
251      * @dev Returns the integer division of two unsigned integers, reverting on
252      * division by zero. The result is rounded towards zero.
253      *
254      * Counterpart to Solidity's `/` operator. Note: this function uses a
255      * `revert` opcode (which leaves remaining gas untouched) while Solidity
256      * uses an invalid opcode to revert (consuming all remaining gas).
257      *
258      * Requirements:
259      *
260      * - The divisor cannot be zero.
261      */
262     function div(uint256 a, uint256 b) internal pure returns (uint256) {
263         require(b > 0, "SafeMath: division by zero");
264         return a / b;
265     }
266 
267     /**
268      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
269      * reverting when dividing by zero.
270      *
271      * Counterpart to Solidity's `%` operator. This function uses a `revert`
272      * opcode (which leaves remaining gas untouched) while Solidity uses an
273      * invalid opcode to revert (consuming all remaining gas).
274      *
275      * Requirements:
276      *
277      * - The divisor cannot be zero.
278      */
279     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
280         require(b > 0, "SafeMath: modulo by zero");
281         return a % b;
282     }
283 
284     /**
285      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
286      * overflow (when the result is negative).
287      *
288      * CAUTION: This function is deprecated because it requires allocating memory for the error
289      * message unnecessarily. For custom revert reasons use {trySub}.
290      *
291      * Counterpart to Solidity's `-` operator.
292      *
293      * Requirements:
294      *
295      * - Subtraction cannot overflow.
296      */
297     function sub(
298         uint256 a,
299         uint256 b,
300         string memory errorMessage
301     ) internal pure returns (uint256) {
302         require(b <= a, errorMessage);
303         return a - b;
304     }
305 
306     /**
307      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
308      * division by zero. The result is rounded towards zero.
309      *
310      * CAUTION: This function is deprecated because it requires allocating memory for the error
311      * message unnecessarily. For custom revert reasons use {tryDiv}.
312      *
313      * Counterpart to Solidity's `/` operator. Note: this function uses a
314      * `revert` opcode (which leaves remaining gas untouched) while Solidity
315      * uses an invalid opcode to revert (consuming all remaining gas).
316      *
317      * Requirements:
318      *
319      * - The divisor cannot be zero.
320      */
321     function div(
322         uint256 a,
323         uint256 b,
324         string memory errorMessage
325     ) internal pure returns (uint256) {
326         require(b > 0, errorMessage);
327         return a / b;
328     }
329 
330     /**
331      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
332      * reverting with custom message when dividing by zero.
333      *
334      * CAUTION: This function is deprecated because it requires allocating memory for the error
335      * message unnecessarily. For custom revert reasons use {tryMod}.
336      *
337      * Counterpart to Solidity's `%` operator. This function uses a `revert`
338      * opcode (which leaves remaining gas untouched) while Solidity uses an
339      * invalid opcode to revert (consuming all remaining gas).
340      *
341      * Requirements:
342      *
343      * - The divisor cannot be zero.
344      */
345     function mod(
346         uint256 a,
347         uint256 b,
348         string memory errorMessage
349     ) internal pure returns (uint256) {
350         require(b > 0, errorMessage);
351         return a % b;
352     }
353 }
354 
355 // File contracts/interfaces/IStakingPoolMigrator.sol
356 
357 pragma solidity ^0.7.6;
358 
359 interface IStakingPoolMigrator {
360     function migrate(
361         uint256 poolId,
362         address oldToken,
363         uint256 amount
364     ) external returns (address);
365 }
366 
367 // File contracts/interfaces/IStakingPoolRewarder.sol
368 
369 pragma solidity ^0.7.6;
370 
371 interface IStakingPoolRewarder {
372     function onReward(
373         uint256 poolId,
374         address user,
375         uint256 amount
376     ) external;
377 }
378 
379 // File contracts/StakingPools.sol
380 
381 pragma solidity ^0.7.6;
382 
383 /**
384  * @title StakingPools
385  *
386  * @dev A contract for staking Uniswap LP tokens in exchange for locked CONV rewards.
387  * No actual CONV tokens will be held or distributed by this contract. Only the amounts
388  * are accumulated.
389  *
390  * @dev The `migrator` in this contract has access to users' staked tokens. Any changes
391  * to the migrator address will only take effect after a delay period specified at contract
392  * creation.
393  *
394  * @dev This contract interacts with token contracts via `safeApprove`, `safeTransfer`,
395  * and `safeTransferFrom` instead of the standard Solidity interface so that some non-ERC20-
396  * compatible tokens (e.g. Tether) can also be staked.
397  */
398 contract StakingPools is Ownable {
399     using SafeMath for uint256;
400 
401     event PoolCreated(
402         uint256 indexed poolId,
403         address indexed token,
404         uint256 startBlock,
405         uint256 endBlock,
406         uint256 migrationBlock,
407         uint256 rewardPerBlock
408     );
409     event PoolEndBlockExtended(uint256 indexed poolId, uint256 oldEndBlock, uint256 newEndBlock);
410     event PoolMigrationBlockExtended(uint256 indexed poolId, uint256 oldMigrationBlock, uint256 newMigrationBlock);
411     event PoolRewardRateChanged(uint256 indexed poolId, uint256 oldRewardPerBlock, uint256 newRewardPerBlock);
412     event MigratorChangeProposed(address newMigrator);
413     event MigratorChanged(address oldMigrator, address newMigrator);
414     event RewarderChanged(address oldRewarder, address newRewarder);
415     event PoolMigrated(uint256 indexed poolId, address oldToken, address newToken);
416     event Staked(uint256 indexed poolId, address indexed staker, address token, uint256 amount);
417     event Unstaked(uint256 indexed poolId, address indexed staker, address token, uint256 amount);
418     event RewardRedeemed(uint256 indexed poolId, address indexed staker, address rewarder, uint256 amount);
419 
420     /**
421      * @param startBlock the block from which reward accumulation starts
422      * @param endBlock the block from which reward accumulation stops
423      * @param migrationBlock the block since which LP token migration can be triggered
424      * @param rewardPerBlock total amount of token to be rewarded in a block
425      * @param poolToken token to be staked
426      */
427     struct PoolInfo {
428         uint256 startBlock;
429         uint256 endBlock;
430         uint256 migrationBlock;
431         uint256 rewardPerBlock;
432         address poolToken;
433     }
434     /**
435      * @param totalStakeAmount total amount of staked tokens
436      * @param accuRewardPerShare accumulated rewards for a single unit of token staked, multiplied by `ACCU_REWARD_MULTIPLIER`
437      * @param accuRewardLastUpdateBlock the block number at which the `accuRewardPerShare` field was last updated
438      */
439     struct PoolData {
440         uint256 totalStakeAmount;
441         uint256 accuRewardPerShare;
442         uint256 accuRewardLastUpdateBlock;
443     }
444     /**
445      * @param stakeAmount amount of token the user stakes
446      * @param pendingReward amount of reward to be redeemed by the user up to the user's last action
447      * @param entryAccuRewardPerShare the `accuRewardPerShare` value at the user's last stake/unstake action
448      */
449     struct UserData {
450         uint256 stakeAmount;
451         uint256 pendingReward;
452         uint256 entryAccuRewardPerShare;
453     }
454     /**
455      * @param proposeTime timestamp when the change is proposed
456      * @param newMigrator new migrator address
457      */
458     struct PendingMigratorChange {
459         uint64 proposeTime;
460         address newMigrator;
461     }
462 
463     uint256 public lastPoolId; // The first pool has ID of 1
464 
465     IStakingPoolMigrator public migrator;
466     uint256 public migratorSetterDelay;
467     PendingMigratorChange public pendingMigrator;
468 
469     IStakingPoolRewarder public rewarder;
470 
471     mapping(uint256 => PoolInfo) public poolInfos;
472     mapping(uint256 => PoolData) public poolData;
473     mapping(uint256 => mapping(address => UserData)) public userData;
474 
475     uint256 private constant ACCU_REWARD_MULTIPLIER = 10**20; // Precision loss prevention
476 
477     bytes4 private constant TRANSFER_SELECTOR = bytes4(keccak256(bytes("transfer(address,uint256)")));
478     bytes4 private constant APPROVE_SELECTOR = bytes4(keccak256(bytes("approve(address,uint256)")));
479     bytes4 private constant TRANSFERFROM_SELECTOR = bytes4(keccak256(bytes("transferFrom(address,address,uint256)")));
480 
481     modifier onlyPoolExists(uint256 poolId) {
482         require(poolInfos[poolId].endBlock > 0, "StakingPools: pool not found");
483         _;
484     }
485 
486     modifier onlyPoolActive(uint256 poolId) {
487         require(
488             block.number >= poolInfos[poolId].startBlock && block.number < poolInfos[poolId].endBlock,
489             "StakingPools: pool not active"
490         );
491         _;
492     }
493 
494     modifier onlyPoolNotEnded(uint256 poolId) {
495         require(block.number < poolInfos[poolId].endBlock, "StakingPools: pool ended");
496         _;
497     }
498 
499     function getReward(uint256 poolId, address staker) external view returns (uint256) {
500         UserData memory currentUserData = userData[poolId][staker];
501         PoolInfo memory currentPoolInfo = poolInfos[poolId];
502         PoolData memory currentPoolData = poolData[poolId];
503 
504         uint256 latestAccuRewardPerShare =
505             currentPoolData.totalStakeAmount > 0
506                 ? currentPoolData.accuRewardPerShare.add(
507                     Math
508                         .min(block.number, currentPoolInfo.endBlock)
509                         .sub(currentPoolData.accuRewardLastUpdateBlock)
510                         .mul(currentPoolInfo.rewardPerBlock)
511                         .mul(ACCU_REWARD_MULTIPLIER)
512                         .div(currentPoolData.totalStakeAmount)
513                 )
514                 : currentPoolData.accuRewardPerShare;
515 
516         return
517             currentUserData.pendingReward.add(
518                 currentUserData.stakeAmount.mul(latestAccuRewardPerShare.sub(currentUserData.entryAccuRewardPerShare)).div(
519                     ACCU_REWARD_MULTIPLIER
520                 )
521             );
522     }
523 
524     constructor(uint256 _migratorSetterDelay) {
525         require(_migratorSetterDelay > 0, "StakingPools: zero setter delay");
526 
527         migratorSetterDelay = _migratorSetterDelay;
528     }
529 
530     function createPool(
531         address token,
532         uint256 startBlock,
533         uint256 endBlock,
534         uint256 migrationBlock,
535         uint256 rewardPerBlock
536     ) external onlyOwner {
537         require(token != address(0), "StakingPools: zero address");
538         require(
539             startBlock > block.number && endBlock > startBlock && migrationBlock > startBlock,
540             "StakingPools: invalid block range"
541         );
542         require(rewardPerBlock > 0, "StakingPools: reward must be positive");
543 
544         uint256 newPoolId = ++lastPoolId;
545 
546         poolInfos[newPoolId] = PoolInfo({
547             startBlock: startBlock,
548             endBlock: endBlock,
549             migrationBlock: migrationBlock,
550             rewardPerBlock: rewardPerBlock,
551             poolToken: token
552         });
553         poolData[newPoolId] = PoolData({totalStakeAmount: 0, accuRewardPerShare: 0, accuRewardLastUpdateBlock: startBlock});
554 
555         emit PoolCreated(newPoolId, token, startBlock, endBlock, migrationBlock, rewardPerBlock);
556     }
557 
558     function extendEndBlock(uint256 poolId, uint256 newEndBlock)
559         external
560         onlyOwner
561         onlyPoolExists(poolId)
562         onlyPoolNotEnded(poolId)
563     {
564         uint256 currentEndBlock = poolInfos[poolId].endBlock;
565         require(newEndBlock > currentEndBlock, "StakingPools: end block not extended");
566 
567         poolInfos[poolId].endBlock = newEndBlock;
568 
569         emit PoolEndBlockExtended(poolId, currentEndBlock, newEndBlock);
570     }
571 
572     function extendMigrationBlock(uint256 poolId, uint256 newMigrationBlock)
573         external
574         onlyOwner
575         onlyPoolExists(poolId)
576         onlyPoolNotEnded(poolId)
577     {
578         uint256 currentMigrationBlock = poolInfos[poolId].migrationBlock;
579         require(newMigrationBlock > currentMigrationBlock, "StakingPools: migration block not extended");
580 
581         poolInfos[poolId].migrationBlock = newMigrationBlock;
582 
583         emit PoolMigrationBlockExtended(poolId, currentMigrationBlock, newMigrationBlock);
584     }
585 
586     function setPoolReward(uint256 poolId, uint256 newRewardPerBlock)
587         external
588         onlyOwner
589         onlyPoolExists(poolId)
590         onlyPoolNotEnded(poolId)
591     {
592         // "Settle" rewards up to this block
593         _updatePoolAccuReward(poolId);
594 
595         // We're deliberately allowing setting the reward rate to 0 here. If it turns
596         // out this, or even changing rates at all, is undesirable after deployment, the
597         // ownership of this contract can be transferred to a contract incapable of making
598         // calls to this function.
599         uint256 currentRewardPerBlock = poolInfos[poolId].rewardPerBlock;
600         poolInfos[poolId].rewardPerBlock = newRewardPerBlock;
601 
602         emit PoolRewardRateChanged(poolId, currentRewardPerBlock, newRewardPerBlock);
603     }
604 
605     function proposeMigratorChange(address newMigrator) external onlyOwner {
606         pendingMigrator = PendingMigratorChange({proposeTime: uint64(block.timestamp), newMigrator: newMigrator});
607 
608         emit MigratorChangeProposed(newMigrator);
609     }
610 
611     function executeMigratorChange() external {
612         require(pendingMigrator.proposeTime > 0, "StakingPools: migrator change proposal not found");
613         require(
614             block.timestamp >= uint256(pendingMigrator.proposeTime).add(migratorSetterDelay),
615             "StakingPools: migrator setter delay not passed"
616         );
617 
618         address oldMigrator = address(migrator);
619         migrator = IStakingPoolMigrator(pendingMigrator.newMigrator);
620 
621         // Clear storage
622         pendingMigrator = PendingMigratorChange({proposeTime: 0, newMigrator: address(0)});
623 
624         emit MigratorChanged(oldMigrator, address(migrator));
625     }
626 
627     function setRewarder(address newRewarder) external onlyOwner {
628         address oldRewarder = address(rewarder);
629         rewarder = IStakingPoolRewarder(newRewarder);
630 
631         emit RewarderChanged(oldRewarder, newRewarder);
632     }
633 
634     function migratePool(uint256 poolId) external onlyPoolExists(poolId) {
635         require(address(migrator) != address(0), "StakingPools: migrator not set");
636 
637         PoolInfo memory currentPoolInfo = poolInfos[poolId];
638         PoolData memory currentPoolData = poolData[poolId];
639         require(block.number >= currentPoolInfo.migrationBlock, "StakingPools: migration block not reached");
640 
641         safeApprove(currentPoolInfo.poolToken, address(migrator), currentPoolData.totalStakeAmount);
642 
643         // New token balance is not validated here since the migrator can do whatever
644         // it wants anyways (including providing a fake token address with fake balance).
645         // It's the migrator contract's responsibility to ensure tokens are properly migrated.
646         address newToken =
647             migrator.migrate(poolId, address(currentPoolInfo.poolToken), uint256(currentPoolData.totalStakeAmount));
648         require(newToken != address(0), "StakingPools: zero new token address");
649 
650         poolInfos[poolId].poolToken = newToken;
651 
652         emit PoolMigrated(poolId, currentPoolInfo.poolToken, newToken);
653     }
654 
655     function stake(uint256 poolId, uint256 amount) external onlyPoolExists(poolId) onlyPoolActive(poolId) {
656         _updatePoolAccuReward(poolId);
657         _updateStakerReward(poolId, msg.sender);
658 
659         _stake(poolId, msg.sender, amount);
660     }
661 
662     function unstake(uint256 poolId, uint256 amount) external onlyPoolExists(poolId) {
663         _updatePoolAccuReward(poolId);
664         _updateStakerReward(poolId, msg.sender);
665 
666         _unstake(poolId, msg.sender, amount);
667     }
668 
669     function emergencyUnstake(uint256 poolId) external onlyPoolExists(poolId) {
670         _unstake(poolId, msg.sender, userData[poolId][msg.sender].stakeAmount);
671 
672         // Forfeit user rewards to avoid abuse
673         userData[poolId][msg.sender].pendingReward = 0;
674     }
675 
676     function redeemRewards(uint256 poolId) external onlyPoolExists(poolId) {
677         _updatePoolAccuReward(poolId);
678         _updateStakerReward(poolId, msg.sender);
679 
680         require(address(rewarder) != address(0), "StakingPools: rewarder not set");
681 
682         uint256 rewardToRedeem = userData[poolId][msg.sender].pendingReward;
683         require(rewardToRedeem > 0, "StakingPools: no reward to redeem");
684 
685         userData[poolId][msg.sender].pendingReward = 0;
686 
687         rewarder.onReward(poolId, msg.sender, rewardToRedeem);
688 
689         emit RewardRedeemed(poolId, msg.sender, address(rewarder), rewardToRedeem);
690     }
691 
692     function _stake(
693         uint256 poolId,
694         address user,
695         uint256 amount
696     ) private {
697         require(amount > 0, "StakingPools: cannot stake zero amount");
698 
699         userData[poolId][user].stakeAmount = userData[poolId][user].stakeAmount.add(amount);
700         poolData[poolId].totalStakeAmount = poolData[poolId].totalStakeAmount.add(amount);
701 
702         safeTransferFrom(poolInfos[poolId].poolToken, user, address(this), amount);
703 
704         emit Staked(poolId, user, poolInfos[poolId].poolToken, amount);
705     }
706 
707     function _unstake(
708         uint256 poolId,
709         address user,
710         uint256 amount
711     ) private {
712         require(amount > 0, "StakingPools: cannot unstake zero amount");
713 
714         // No sufficiency check required as sub() will throw anyways
715         userData[poolId][user].stakeAmount = userData[poolId][user].stakeAmount.sub(amount);
716         poolData[poolId].totalStakeAmount = poolData[poolId].totalStakeAmount.sub(amount);
717 
718         safeTransfer(poolInfos[poolId].poolToken, user, amount);
719 
720         emit Unstaked(poolId, user, poolInfos[poolId].poolToken, amount);
721     }
722 
723     function _updatePoolAccuReward(uint256 poolId) private {
724         PoolInfo storage currentPoolInfo = poolInfos[poolId];
725         PoolData storage currentPoolData = poolData[poolId];
726 
727         uint256 appliedUpdateBlock = Math.min(block.number, currentPoolInfo.endBlock);
728         uint256 durationInBlocks = appliedUpdateBlock.sub(currentPoolData.accuRewardLastUpdateBlock);
729 
730         // This saves tx cost when being called multiple times in the same block
731         if (durationInBlocks > 0) {
732             // No need to update the rate if no one staked at all
733             if (currentPoolData.totalStakeAmount > 0) {
734                 currentPoolData.accuRewardPerShare = currentPoolData.accuRewardPerShare.add(
735                     durationInBlocks.mul(currentPoolInfo.rewardPerBlock).mul(ACCU_REWARD_MULTIPLIER).div(
736                         currentPoolData.totalStakeAmount
737                     )
738                 );
739             }
740             currentPoolData.accuRewardLastUpdateBlock = appliedUpdateBlock;
741         }
742     }
743 
744     function _updateStakerReward(uint256 poolId, address staker) private {
745         UserData storage currentUserData = userData[poolId][staker];
746         PoolData storage currentPoolData = poolData[poolId];
747 
748         uint256 stakeAmount = currentUserData.stakeAmount;
749         uint256 stakerEntryRate = currentUserData.entryAccuRewardPerShare;
750         uint256 accuDifference = currentPoolData.accuRewardPerShare.sub(stakerEntryRate);
751 
752         if (accuDifference > 0) {
753             currentUserData.pendingReward = currentUserData.pendingReward.add(
754                 stakeAmount.mul(accuDifference).div(ACCU_REWARD_MULTIPLIER)
755             );
756             currentUserData.entryAccuRewardPerShare = currentPoolData.accuRewardPerShare;
757         }
758     }
759 
760     function safeApprove(
761         address token,
762         address spender,
763         uint256 amount
764     ) internal {
765         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(APPROVE_SELECTOR, spender, amount));
766         require(success && (data.length == 0 || abi.decode(data, (bool))), "StakingPools: approve failed");
767     }
768 
769     function safeTransfer(
770         address token,
771         address recipient,
772         uint256 amount
773     ) private {
774         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(TRANSFER_SELECTOR, recipient, amount));
775         require(success && (data.length == 0 || abi.decode(data, (bool))), "StakingPools: transfer failed");
776     }
777 
778     function safeTransferFrom(
779         address token,
780         address sender,
781         address recipient,
782         uint256 amount
783     ) private {
784         (bool success, bytes memory data) =
785             token.call(abi.encodeWithSelector(TRANSFERFROM_SELECTOR, sender, recipient, amount));
786         require(success && (data.length == 0 || abi.decode(data, (bool))), "StakingPools: transferFrom failed");
787     }
788 }