1 // SPDX-License-Identifier: GPL-3.0-only
2 pragma solidity 0.7.6;
3 pragma abicoder v2;
4 
5 import {SafeMath} from "@openzeppelin/contracts/math/SafeMath.sol";
6 import {EnumerableSet} from "@openzeppelin/contracts/utils/EnumerableSet.sol";
7 import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
8 import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
9 import {TransferHelper} from "@uniswap/lib/contracts/libraries/TransferHelper.sol";
10 
11 import {IFactory} from "../factory/IFactory.sol";
12 import {IInstanceRegistry} from "../factory/InstanceRegistry.sol";
13 import {IUniversalVault} from "../visor/Visor.sol";
14 import {IRewardPool} from "./RewardPool.sol";
15 import {Powered} from "./Powered.sol";
16 
17 interface IRageQuit {
18     function rageQuit() external;
19 }
20 
21 interface IHypervisor is IRageQuit {
22     /* admin events */
23 
24     event HypervisorCreated(address rewardPool, address powerSwitch);
25     event HypervisorFunded(uint256 amount, uint256 duration);
26     event BonusTokenRegistered(address token);
27     event VaultFactoryRegistered(address factory);
28     event VaultFactoryRemoved(address factory);
29 
30     /* user events */
31 
32     event Staked(address vault, uint256 amount);
33     event Unstaked(address vault, uint256 amount);
34     event RewardClaimed(address vault, address recipient, address token, uint256 amount);
35 
36     /* data types */
37 
38     struct HypervisorData {
39         address stakingToken;
40         address rewardToken;
41         address rewardPool;
42         RewardScaling rewardScaling;
43         uint256 rewardSharesOutstanding;
44         uint256 totalStake;
45         uint256 totalStakeUnits;
46         uint256 lastUpdate;
47         RewardSchedule[] rewardSchedules;
48     }
49 
50     struct RewardSchedule {
51         uint256 duration;
52         uint256 start;
53         uint256 shares;
54     }
55 
56     struct VaultData {
57         uint256 totalStake;
58         StakeData[] stakes;
59     }
60 
61     struct StakeData {
62         uint256 amount;
63         uint256 timestamp;
64     }
65 
66     struct RewardScaling {
67         uint256 floor;
68         uint256 ceiling;
69         uint256 time;
70     }
71 
72     struct RewardOutput {
73         uint256 lastStakeAmount;
74         uint256 newStakesCount;
75         uint256 reward;
76         uint256 newTotalStakeUnits;
77     }
78 
79     /* user functions */
80 
81     function stake(
82         address vault,
83         uint256 amount,
84         bytes calldata permission
85     ) external;
86 
87     function unstakeAndClaim(
88         address vault,
89         uint256 amount,
90         bytes calldata permission
91     ) external;
92 
93     /* getter functions */
94 
95     function getHypervisorData() external view returns (HypervisorData memory hypervisor);
96 
97     function getBonusTokenSetLength() external view returns (uint256 length);
98 
99     function getBonusTokenAtIndex(uint256 index) external view returns (address bonusToken);
100 
101     function getVaultFactorySetLength() external view returns (uint256 length);
102 
103     function getVaultFactoryAtIndex(uint256 index) external view returns (address factory);
104 
105     function getVaultData(address vault) external view returns (VaultData memory vaultData);
106 
107     function isValidAddress(address target) external view returns (bool validity);
108 
109     function isValidVault(address target) external view returns (bool validity);
110 
111     function getCurrentUnlockedRewards() external view returns (uint256 unlockedRewards);
112 
113     function getFutureUnlockedRewards(uint256 timestamp)
114         external
115         view
116         returns (uint256 unlockedRewards);
117 
118     function getCurrentVaultReward(address vault) external view returns (uint256 reward);
119 
120     function getCurrentStakeReward(address vault, uint256 stakeAmount)
121         external
122         view
123         returns (uint256 reward);
124 
125     function getFutureVaultReward(address vault, uint256 timestamp)
126         external
127         view
128         returns (uint256 reward);
129 
130     function getFutureStakeReward(
131         address vault,
132         uint256 stakeAmount,
133         uint256 timestamp
134     ) external view returns (uint256 reward);
135 
136     function getCurrentVaultStakeUnits(address vault) external view returns (uint256 stakeUnits);
137 
138     function getFutureVaultStakeUnits(address vault, uint256 timestamp)
139         external
140         view
141         returns (uint256 stakeUnits);
142 
143     function getCurrentTotalStakeUnits() external view returns (uint256 totalStakeUnits);
144 
145     function getFutureTotalStakeUnits(uint256 timestamp)
146         external
147         view
148         returns (uint256 totalStakeUnits);
149 
150     /* pure functions */
151 
152     function calculateTotalStakeUnits(StakeData[] memory stakes, uint256 timestamp)
153         external
154         pure
155         returns (uint256 totalStakeUnits);
156 
157     function calculateStakeUnits(
158         uint256 amount,
159         uint256 start,
160         uint256 end
161     ) external pure returns (uint256 stakeUnits);
162 
163     function calculateUnlockedRewards(
164         RewardSchedule[] memory rewardSchedules,
165         uint256 rewardBalance,
166         uint256 sharesOutstanding,
167         uint256 timestamp
168     ) external pure returns (uint256 unlockedRewards);
169 
170     function calculateRewardFromStakes(
171         StakeData[] memory stakes,
172         uint256 unstakeAmount,
173         uint256 unlockedRewards,
174         uint256 totalStakeUnits,
175         uint256 timestamp,
176         RewardScaling memory rewardScaling
177     ) external pure returns (RewardOutput memory out);
178 
179     function calculateReward(
180         uint256 unlockedRewards,
181         uint256 stakeAmount,
182         uint256 stakeDuration,
183         uint256 totalStakeUnits,
184         RewardScaling memory rewardScaling
185     ) external pure returns (uint256 reward);
186 }
187 
188 /// @title Hypervisor
189 /// @notice Reward distribution contract with time multiplier
190 /// Access Control
191 /// - Power controller:
192 ///     Can power off / shutdown the Hypervisor
193 ///     Can withdraw rewards from reward pool once shutdown
194 /// - Proxy owner:
195 ///     Can change arbitrary logic / state by upgrading the Hypervisor
196 ///     Is unable to operate on user funds due to UniversalVault
197 ///     Is unable to operate on reward pool funds when reward pool is offline / shutdown
198 /// - Hypervisor admin:
199 ///     Can add funds to the Hypervisor, register bonus tokens, and whitelist new vault factories
200 ///     Is a subset of proxy owner permissions
201 /// - User:
202 ///     Can deposit / withdraw / ragequit
203 /// Hypervisor State Machine
204 /// - Online:
205 ///     Hypervisor is operating normally, all functions are enabled
206 /// - Offline:
207 ///     Hypervisor is temporarely disabled for maintenance
208 ///     User deposits and withdrawls are disabled, ragequit remains enabled
209 ///     Users can withdraw their stake through rageQuit() but forego their pending reward
210 ///     Should only be used when downtime required for an upgrade
211 /// - Shutdown:
212 ///     Hypervisor is permanently disabled
213 ///     All functions are disabled with the exception of ragequit
214 ///     Users can withdraw their stake through rageQuit()
215 ///     Power controller can withdraw from the reward pool
216 ///     Should only be used if Proxy Owner role is compromized
217 contract Hypervisor is IHypervisor, Powered, Ownable {
218     using SafeMath for uint256;
219     using EnumerableSet for EnumerableSet.AddressSet;
220 
221     /* constants */
222 
223     // An upper bound on the number of active stakes per vault is required to prevent
224     // calls to rageQuit() from reverting.
225     // With 30 stakes in a vault, ragequit costs 432811 gas which is conservatively lower
226     // than the hardcoded limit of 500k gas on the vault.
227     // This limit is configurable and could be increased in a future deployment.
228     // Ultimately, to avoid a need for fixed upper bounds, the EVM would need to provide
229     // an error code that allows for reliably catching out-of-gas errors on remote calls.
230     uint256 public constant MAX_STAKES_PER_VAULT = 30;
231     uint256 public constant MAX_REWARD_TOKENS = 50;
232     uint256 public constant BASE_SHARES_PER_WEI = 1000000;
233     uint256 public stakeLimit = 2500 ether;
234 
235     /* storage */
236 
237     HypervisorData private _hypervisor;
238     mapping(address => VaultData) private _vaults;
239     EnumerableSet.AddressSet private _bonusTokenSet;
240     EnumerableSet.AddressSet private _vaultFactorySet;
241 
242     /* initializer */
243 
244     /// @notice Initizalize Hypervisor
245     /// access control: only proxy constructor
246     /// state machine: can only be called once
247     /// state scope: set initialization variables
248     /// token transfer: none
249     /// @param ownerAddress address The admin address
250     /// @param rewardPoolFactory address The factory to use for deploying the RewardPool
251     /// @param powerSwitchFactory address The factory to use for deploying the PowerSwitch
252     /// @param stakingToken address The address of the staking token for this Hypervisor
253     /// @param rewardToken address The address of the reward token for this Hypervisor
254     /// @param rewardScaling RewardScaling The config for reward scaling floor, ceiling, and time
255     constructor(
256         address ownerAddress,
257         address rewardPoolFactory,
258         address powerSwitchFactory,
259         address stakingToken,
260         address rewardToken,
261         RewardScaling memory rewardScaling,
262         uint256 _stakeLimit
263     ) {
264         // the scaling floor must be smaller than ceiling
265         require(rewardScaling.floor <= rewardScaling.ceiling, "Hypervisor: floor above ceiling");
266 
267         // setting rewardScalingTime to 0 would cause divide by zero error
268         // to disable reward scaling, use rewardScalingFloor == rewardScalingCeiling
269         require(rewardScaling.time != 0, "Hypervisor: scaling time cannot be zero");
270 
271         // deploy power switch
272         address powerSwitch = IFactory(powerSwitchFactory).create(abi.encode(ownerAddress));
273 
274         // deploy reward pool
275         address rewardPool = IFactory(rewardPoolFactory).create(abi.encode(powerSwitch));
276 
277         // set internal configs
278         Ownable.transferOwnership(ownerAddress);
279         Powered._setPowerSwitch(powerSwitch);
280 
281         // commit to storage
282         _hypervisor.stakingToken = stakingToken;
283         _hypervisor.rewardToken = rewardToken;
284         _hypervisor.rewardPool = rewardPool;
285         _hypervisor.rewardScaling = rewardScaling;
286 
287         stakeLimit = _stakeLimit;
288 
289         // emit event
290         emit HypervisorCreated(rewardPool, powerSwitch);
291     }
292 
293     /* getter functions */
294 
295     function getBonusTokenSetLength() external view override returns (uint256 length) {
296         return _bonusTokenSet.length();
297     }
298 
299     function getBonusTokenAtIndex(uint256 index)
300         external
301         view
302         override
303         returns (address bonusToken)
304     {
305         return _bonusTokenSet.at(index);
306     }
307 
308     function getVaultFactorySetLength() external view override returns (uint256 length) {
309         return _vaultFactorySet.length();
310     }
311 
312     function getVaultFactoryAtIndex(uint256 index)
313         external
314         view
315         override
316         returns (address factory)
317     {
318         return _vaultFactorySet.at(index);
319     }
320 
321     function isValidVault(address target) public view override returns (bool validity) {
322         // validate target is created from whitelisted vault factory
323         for (uint256 index = 0; index < _vaultFactorySet.length(); index++) {
324             if (IInstanceRegistry(_vaultFactorySet.at(index)).isInstance(target)) {
325                 return true;
326             }
327         }
328         // explicit return
329         return false;
330     }
331 
332     function isValidAddress(address target) public view override returns (bool validity) {
333         // sanity check target for potential input errors
334         return
335             target != address(this) &&
336             target != address(0) &&
337             target != _hypervisor.stakingToken &&
338             target != _hypervisor.rewardToken &&
339             target != _hypervisor.rewardPool &&
340             !_bonusTokenSet.contains(target);
341     }
342 
343     /* Hypervisor getters */
344 
345     function getHypervisorData() external view override returns (HypervisorData memory hypervisor) {
346         return _hypervisor;
347     }
348 
349     function getCurrentUnlockedRewards() public view override returns (uint256 unlockedRewards) {
350         // calculate reward available based on state
351         return getFutureUnlockedRewards(block.timestamp);
352     }
353 
354     function getFutureUnlockedRewards(uint256 timestamp)
355         public
356         view
357         override
358         returns (uint256 unlockedRewards)
359     {
360         // get reward amount remaining
361         uint256 remainingRewards = IERC20(_hypervisor.rewardToken).balanceOf(_hypervisor.rewardPool);
362         // calculate reward available based on state
363         unlockedRewards = calculateUnlockedRewards(
364             _hypervisor.rewardSchedules,
365             remainingRewards,
366             _hypervisor.rewardSharesOutstanding,
367             timestamp
368         );
369         // explicit return
370         return unlockedRewards;
371     }
372 
373     function getCurrentTotalStakeUnits() public view override returns (uint256 totalStakeUnits) {
374         // calculate new stake units
375         return getFutureTotalStakeUnits(block.timestamp);
376     }
377 
378     function getFutureTotalStakeUnits(uint256 timestamp)
379         public
380         view
381         override
382         returns (uint256 totalStakeUnits)
383     {
384         // return early if no change
385         if (timestamp == _hypervisor.lastUpdate) return _hypervisor.totalStakeUnits;
386         // calculate new stake units
387         uint256 newStakeUnits =
388             calculateStakeUnits(_hypervisor.totalStake, _hypervisor.lastUpdate, timestamp);
389         // add to cached total
390         totalStakeUnits = _hypervisor.totalStakeUnits.add(newStakeUnits);
391         // explicit return
392         return totalStakeUnits;
393     }
394 
395     /* vault getters */
396 
397     function getVaultData(address vault)
398         external
399         view
400         override
401         returns (VaultData memory vaultData)
402     {
403         return _vaults[vault];
404     }
405 
406     function getCurrentVaultReward(address vault) external view override returns (uint256 reward) {
407         // calculate rewards
408         return
409             calculateRewardFromStakes(
410                 _vaults[vault]
411                     .stakes,
412                 _vaults[vault]
413                     .totalStake,
414                 getCurrentUnlockedRewards(),
415                 getCurrentTotalStakeUnits(),
416                 block
417                     .timestamp,
418                 _hypervisor
419                     .rewardScaling
420             )
421                 .reward;
422     }
423 
424     function getFutureVaultReward(address vault, uint256 timestamp)
425         external
426         view
427         override
428         returns (uint256 reward)
429     {
430         // calculate rewards
431         return
432             calculateRewardFromStakes(
433                 _vaults[vault]
434                     .stakes,
435                 _vaults[vault]
436                     .totalStake,
437                 getFutureUnlockedRewards(timestamp),
438                 getFutureTotalStakeUnits(timestamp),
439                 timestamp,
440                 _hypervisor
441                     .rewardScaling
442             )
443                 .reward;
444     }
445 
446     function getCurrentStakeReward(address vault, uint256 stakeAmount)
447         external
448         view
449         override
450         returns (uint256 reward)
451     {
452         // calculate rewards
453         return
454             calculateRewardFromStakes(
455                 _vaults[vault]
456                     .stakes,
457                 stakeAmount,
458                 getCurrentUnlockedRewards(),
459                 getCurrentTotalStakeUnits(),
460                 block
461                     .timestamp,
462                 _hypervisor
463                     .rewardScaling
464             )
465                 .reward;
466     }
467 
468     function getFutureStakeReward(
469         address vault,
470         uint256 stakeAmount,
471         uint256 timestamp
472     ) external view override returns (uint256 reward) {
473         // calculate rewards
474         return
475             calculateRewardFromStakes(
476                 _vaults[vault]
477                     .stakes,
478                 stakeAmount,
479                 getFutureUnlockedRewards(timestamp),
480                 getFutureTotalStakeUnits(timestamp),
481                 timestamp,
482                 _hypervisor
483                     .rewardScaling
484             )
485                 .reward;
486     }
487 
488     function getCurrentVaultStakeUnits(address vault)
489         public
490         view
491         override
492         returns (uint256 stakeUnits)
493     {
494         // calculate stake units
495         return getFutureVaultStakeUnits(vault, block.timestamp);
496     }
497 
498     function getFutureVaultStakeUnits(address vault, uint256 timestamp)
499         public
500         view
501         override
502         returns (uint256 stakeUnits)
503     {
504         // calculate stake units
505         return calculateTotalStakeUnits(_vaults[vault].stakes, timestamp);
506     }
507 
508     /* pure functions */
509 
510     function calculateTotalStakeUnits(StakeData[] memory stakes, uint256 timestamp)
511         public
512         pure
513         override
514         returns (uint256 totalStakeUnits)
515     {
516         for (uint256 index; index < stakes.length; index++) {
517             // reference stake
518             StakeData memory stakeData = stakes[index];
519             // calculate stake units
520             uint256 stakeUnits =
521                 calculateStakeUnits(stakeData.amount, stakeData.timestamp, timestamp);
522             // add to running total
523             totalStakeUnits = totalStakeUnits.add(stakeUnits);
524         }
525     }
526 
527     function calculateStakeUnits(
528         uint256 amount,
529         uint256 start,
530         uint256 end
531     ) public pure override returns (uint256 stakeUnits) {
532         // calculate duration
533         uint256 duration = end.sub(start);
534         // calculate stake units
535         stakeUnits = duration.mul(amount);
536         // explicit return
537         return stakeUnits;
538     }
539 
540     function calculateUnlockedRewards(
541         RewardSchedule[] memory rewardSchedules,
542         uint256 rewardBalance,
543         uint256 sharesOutstanding,
544         uint256 timestamp
545     ) public pure override returns (uint256 unlockedRewards) {
546         // return 0 if no registered schedules
547         if (rewardSchedules.length == 0) {
548             return 0;
549         }
550 
551         // calculate reward shares locked across all reward schedules
552         uint256 sharesLocked;
553         for (uint256 index = 0; index < rewardSchedules.length; index++) {
554             // fetch reward schedule storage reference
555             RewardSchedule memory schedule = rewardSchedules[index];
556 
557             // caculate amount of shares available on this schedule
558             // if (now - start) < duration
559             //   sharesLocked = shares - (shares * (now - start) / duration)
560             // else
561             //   sharesLocked = 0
562             uint256 currentSharesLocked = 0;
563             if (timestamp.sub(schedule.start) < schedule.duration) {
564                 currentSharesLocked = schedule.shares.sub(
565                     schedule.shares.mul(timestamp.sub(schedule.start)).div(schedule.duration)
566                 );
567             }
568 
569             // add to running total
570             sharesLocked = sharesLocked.add(currentSharesLocked);
571         }
572 
573         // convert shares to reward
574         // rewardLocked = sharesLocked * rewardBalance / sharesOutstanding
575         uint256 rewardLocked = sharesLocked.mul(rewardBalance).div(sharesOutstanding);
576 
577         // calculate amount available
578         // unlockedRewards = rewardBalance - rewardLocked
579         unlockedRewards = rewardBalance.sub(rewardLocked);
580 
581         // explicit return
582         return unlockedRewards;
583     }
584 
585     function calculateRewardFromStakes(
586         StakeData[] memory stakes,
587         uint256 unstakeAmount,
588         uint256 unlockedRewards,
589         uint256 totalStakeUnits,
590         uint256 timestamp,
591         RewardScaling memory rewardScaling
592     ) public pure override returns (RewardOutput memory out) {
593         uint256 stakesToDrop = 0;
594         while (unstakeAmount > 0) {
595             // fetch vault stake storage reference
596             StakeData memory lastStake = stakes[stakes.length.sub(stakesToDrop).sub(1)];
597 
598             // calculate stake duration
599             uint256 stakeDuration = timestamp.sub(lastStake.timestamp);
600 
601             uint256 currentAmount;
602             if (lastStake.amount > unstakeAmount) {
603                 // set current amount to remaining unstake amount
604                 currentAmount = unstakeAmount;
605                 // amount of last stake is reduced
606                 out.lastStakeAmount = lastStake.amount.sub(unstakeAmount);
607             } else {
608                 // set current amount to amount of last stake
609                 currentAmount = lastStake.amount;
610                 // add to stakes to drop
611                 stakesToDrop += 1;
612             }
613 
614             // update remaining unstakeAmount
615             unstakeAmount = unstakeAmount.sub(currentAmount);
616 
617             // calculate reward amount
618             uint256 currentReward =
619                 calculateReward(
620                     unlockedRewards,
621                     currentAmount,
622                     stakeDuration,
623                     totalStakeUnits,
624                     rewardScaling
625                 );
626 
627             // update cumulative reward
628             out.reward = out.reward.add(currentReward);
629 
630             // update cached unlockedRewards
631             unlockedRewards = unlockedRewards.sub(currentReward);
632 
633             // calculate time weighted stake
634             uint256 stakeUnits = currentAmount.mul(stakeDuration);
635 
636             // update cached totalStakeUnits
637             totalStakeUnits = totalStakeUnits.sub(stakeUnits);
638         }
639 
640         // explicit return
641         return
642             RewardOutput(
643                 out.lastStakeAmount,
644                 stakes.length.sub(stakesToDrop),
645                 out.reward,
646                 totalStakeUnits
647             );
648     }
649 
650     function calculateReward(
651         uint256 unlockedRewards,
652         uint256 stakeAmount,
653         uint256 stakeDuration,
654         uint256 totalStakeUnits,
655         RewardScaling memory rewardScaling
656     ) public pure override returns (uint256 reward) {
657         // calculate time weighted stake
658         uint256 stakeUnits = stakeAmount.mul(stakeDuration);
659 
660         // calculate base reward
661         // baseReward = unlockedRewards * stakeUnits / totalStakeUnits
662         uint256 baseReward = 0;
663         if (totalStakeUnits != 0) {
664             // scale reward according to proportional weight
665             baseReward = unlockedRewards.mul(stakeUnits).div(totalStakeUnits);
666         }
667 
668         // calculate scaled reward
669         // if no scaling or scaling period completed
670         //   reward = baseReward
671         // else
672         //   minReward = baseReward * scalingFloor / scalingCeiling
673         //   bonusReward = baseReward
674         //                 * (scalingCeiling - scalingFloor) / scalingCeiling
675         //                 * duration / scalingTime
676         //   reward = minReward + bonusReward
677         if (stakeDuration >= rewardScaling.time || rewardScaling.floor == rewardScaling.ceiling) {
678             // no reward scaling applied
679             reward = baseReward;
680         } else {
681             // calculate minimum reward using scaling floor
682             uint256 minReward = baseReward.mul(rewardScaling.floor).div(rewardScaling.ceiling);
683 
684             // calculate bonus reward with vested portion of scaling factor
685             uint256 bonusReward =
686                 baseReward
687                     .mul(stakeDuration)
688                     .mul(rewardScaling.ceiling.sub(rewardScaling.floor))
689                     .div(rewardScaling.ceiling)
690                     .div(rewardScaling.time);
691 
692             // add minimum reward and bonus reward
693             reward = minReward.add(bonusReward);
694         }
695 
696         // explicit return
697         return reward;
698     }
699 
700     /* admin functions */
701 
702     /// @notice Add funds to the Hypervisor
703     /// access control: only admin
704     /// state machine:
705     ///   - can be called multiple times
706     ///   - only online
707     /// state scope:
708     ///   - increase _hypervisor.rewardSharesOutstanding
709     ///   - append to _hypervisor.rewardSchedules
710     /// token transfer: transfer staking tokens from msg.sender to reward pool
711     /// @param amount uint256 Amount of reward tokens to deposit
712     /// @param duration uint256 Duration over which to linearly unlock rewards
713     function fund(uint256 amount, uint256 duration) external onlyOwner onlyOnline {
714         // validate duration
715         require(duration != 0, "Hypervisor: invalid duration");
716 
717         // create new reward shares
718         // if existing rewards on this Hypervisor
719         //   mint new shares proportional to % change in rewards remaining
720         //   newShares = remainingShares * newReward / remainingRewards
721         // else
722         //   mint new shares with BASE_SHARES_PER_WEI initial conversion rate
723         //   store as fixed point number with same  of decimals as reward token
724         uint256 newRewardShares;
725         if (_hypervisor.rewardSharesOutstanding > 0) {
726             uint256 remainingRewards = IERC20(_hypervisor.rewardToken).balanceOf(_hypervisor.rewardPool);
727             newRewardShares = _hypervisor.rewardSharesOutstanding.mul(amount).div(remainingRewards);
728         } else {
729             newRewardShares = amount.mul(BASE_SHARES_PER_WEI);
730         }
731 
732         // add reward shares to total
733         _hypervisor.rewardSharesOutstanding = _hypervisor.rewardSharesOutstanding.add(newRewardShares);
734 
735         // store new reward schedule
736         _hypervisor.rewardSchedules.push(RewardSchedule(duration, block.timestamp, newRewardShares));
737 
738         // transfer reward tokens to reward pool
739         TransferHelper.safeTransferFrom(
740             _hypervisor.rewardToken,
741             msg.sender,
742             _hypervisor.rewardPool,
743             amount
744         );
745 
746         // emit event
747         emit HypervisorFunded(amount, duration);
748     }
749 
750     /// @notice Add vault factory to whitelist
751     /// @dev use this function to enable stakes to vaults coming from the specified
752     ///      factory contract
753     /// access control: only admin
754     /// state machine:
755     ///   - can be called multiple times
756     ///   - not shutdown
757     /// state scope:
758     ///   - append to _vaultFactorySet
759     /// token transfer: none
760     /// @param factory address The address of the vault factory
761     function registerVaultFactory(address factory) external onlyOwner notShutdown {
762         // add factory to set
763         require(_vaultFactorySet.add(factory), "Hypervisor: vault factory already registered");
764 
765         // emit event
766         emit VaultFactoryRegistered(factory);
767     }
768 
769     /// @notice Remove vault factory from whitelist
770     /// @dev use this function to disable new stakes to vaults coming from the specified
771     ///      factory contract.
772     ///      note: vaults with existing stakes from this factory are sill able to unstake
773     /// access control: only admin
774     /// state machine:
775     ///   - can be called multiple times
776     ///   - not shutdown
777     /// state scope:
778     ///   - remove from _vaultFactorySet
779     /// token transfer: none
780     /// @param factory address The address of the vault factory
781     function removeVaultFactory(address factory) external onlyOwner notShutdown {
782         // remove factory from set
783         require(_vaultFactorySet.remove(factory), "Hypervisor: vault factory not registered");
784 
785         // emit event
786         emit VaultFactoryRemoved(factory);
787     }
788 
789     /// @notice Register bonus token for distribution
790     /// @dev use this function to enable distribution of any ERC20 held by the RewardPool contract
791     /// access control: only admin
792     /// state machine:
793     ///   - can be called multiple times
794     ///   - only online
795     /// state scope:
796     ///   - append to _bonusTokenSet
797     /// token transfer: none
798     /// @param bonusToken address The address of the bonus token
799     function registerBonusToken(address bonusToken) external onlyOwner onlyOnline {
800         // verify valid bonus token
801         _validateAddress(bonusToken);
802 
803         // verify bonus token count
804         require(_bonusTokenSet.length() < MAX_REWARD_TOKENS, "Hypervisor: max bonus tokens reached ");
805 
806         // add token to set
807         assert(_bonusTokenSet.add(bonusToken));
808 
809         // emit event
810         emit BonusTokenRegistered(bonusToken);
811     }
812 
813     /// @notice Rescue tokens from RewardPool
814     /// @dev use this function to rescue tokens from RewardPool contract
815     ///      without distributing to stakers or triggering emergency shutdown
816     /// access control: only admin
817     /// state machine:
818     ///   - can be called multiple times
819     ///   - only online
820     /// state scope: none
821     /// token transfer: transfer requested token from RewardPool to recipient
822     /// @param token address The address of the token to rescue
823     /// @param recipient address The address of the recipient
824     /// @param amount uint256 The amount of tokens to rescue
825     function rescueTokensFromRewardPool(
826         address token,
827         address recipient,
828         uint256 amount
829     ) external onlyOwner onlyOnline {
830         // verify recipient
831         _validateAddress(recipient);
832 
833         // check not attempting to unstake reward token
834         require(token != _hypervisor.rewardToken, "Hypervisor: invalid address");
835 
836         // check not attempting to wthdraw bonus token
837         require(!_bonusTokenSet.contains(token), "Hypervisor: invalid address");
838 
839         // transfer tokens to recipient
840         IRewardPool(_hypervisor.rewardPool).sendERC20(token, recipient, amount);
841     }
842 
843     /* user functions */
844 
845     /// @notice Stake tokens
846     /// @dev anyone can stake to any vault if they have valid permission
847     /// access control: anyone
848     /// state machine:
849     ///   - can be called multiple times
850     ///   - only online
851     ///   - when vault exists on this Hypervisor
852     /// state scope:
853     ///   - append to _vaults[vault].stakes
854     ///   - increase _vaults[vault].totalStake
855     ///   - increase _hypervisor.totalStake
856     ///   - increase _hypervisor.totalStakeUnits
857     ///   - increase _hypervisor.lastUpdate
858     /// token transfer: transfer staking tokens from msg.sender to vault
859     /// @param vault address The address of the vault to stake from
860     /// @param amount uint256 The amount of staking tokens to stake
861     function stake(
862         address vault,
863         uint256 amount,
864         bytes calldata permission
865     ) external override onlyOnline {
866         // verify vault is valid
867         require(isValidVault(vault), "Hypervisor: vault is not registered");
868 
869         // verify non-zero amount
870         require(amount != 0, "Hypervisor: no amount staked");
871 
872         // fetch vault storage reference
873         VaultData storage vaultData = _vaults[vault];
874 
875         // verify stakes boundary not reached
876         require(
877             vaultData.stakes.length < MAX_STAKES_PER_VAULT,
878             "Hypervisor: MAX_STAKES_PER_VAULT reached"
879         );
880 
881         // update cached sum of stake units across all vaults
882         _updateTotalStakeUnits();
883 
884         // store amount and timestamp
885         vaultData.stakes.push(StakeData(amount, block.timestamp));
886 
887         // update cached total vault and Hypervisor amounts
888         vaultData.totalStake = vaultData.totalStake.add(amount);
889         // verify stake quantity without bounds
890         require(
891             stakeLimit == 0 || vaultData.totalStake <= stakeLimit,
892             "Hypervisor: Stake limit exceeded"
893         );
894         _hypervisor.totalStake = _hypervisor.totalStake.add(amount);
895 
896         // call lock on vault
897         IUniversalVault(vault).lock(_hypervisor.stakingToken, amount, permission);
898 
899         // emit event
900         emit Staked(vault, amount);
901     }
902 
903     /// @notice Unstake staking tokens and claim reward
904     /// @dev rewards can only be claimed when unstaking
905     /// access control: only owner of vault
906     /// state machine:
907     ///   - when vault exists on this Hypervisor
908     ///   - after stake from vault
909     ///   - can be called multiple times while sufficient stake remains
910     ///   - only online
911     /// state scope:
912     ///   - decrease _hypervisor.rewardSharesOutstanding
913     ///   - decrease _hypervisor.totalStake
914     ///   - increase _hypervisor.lastUpdate
915     ///   - modify _hypervisor.totalStakeUnits
916     ///   - modify _vaults[vault].stakes
917     ///   - decrease _vaults[vault].totalStake
918     /// token transfer:
919     ///   - transfer reward tokens from reward pool to recipient
920     ///   - transfer bonus tokens from reward pool to recipient
921     /// @param vault address The vault to unstake from
922     /// @param amount uint256 The amount of staking tokens to unstake
923     function unstakeAndClaim(
924         address vault,
925         uint256 amount,
926         bytes calldata permission
927     ) external override onlyOnline {
928         // fetch vault storage reference
929         VaultData storage vaultData = _vaults[vault];
930 
931         // verify non-zero amount
932         require(amount != 0, "Hypervisor: no amount unstaked");
933 
934         address recipient = IUniversalVault(vault).owner();
935 
936         // validate recipient
937         _validateAddress(recipient);
938 
939         // check for sufficient vault stake amount
940         require(vaultData.totalStake >= amount, "Hypervisor: insufficient vault stake");
941 
942         // check for sufficient Hypervisor stake amount
943         // if this check fails, there is a bug in stake accounting
944         assert(_hypervisor.totalStake >= amount);
945 
946         // update cached sum of stake units across all vaults
947         _updateTotalStakeUnits();
948 
949         // get reward amount remaining
950         uint256 remainingRewards = IERC20(_hypervisor.rewardToken).balanceOf(_hypervisor.rewardPool);
951 
952         // calculate vested portion of reward pool
953         uint256 unlockedRewards =
954             calculateUnlockedRewards(
955                 _hypervisor.rewardSchedules,
956                 remainingRewards,
957                 _hypervisor.rewardSharesOutstanding,
958                 block.timestamp
959             );
960 
961         // calculate vault time weighted reward with scaling
962         RewardOutput memory out =
963             calculateRewardFromStakes(
964                 vaultData.stakes,
965                 amount,
966                 unlockedRewards,
967                 _hypervisor.totalStakeUnits,
968                 block.timestamp,
969                 _hypervisor.rewardScaling
970             );
971 
972         // update stake data in storage
973         if (out.newStakesCount == 0) {
974             // all stakes have been unstaked
975             delete vaultData.stakes;
976         } else {
977             // some stakes have been completely or partially unstaked
978             // delete fully unstaked stakes
979             while (vaultData.stakes.length > out.newStakesCount) vaultData.stakes.pop();
980             // update partially unstaked stake
981             vaultData.stakes[out.newStakesCount.sub(1)].amount = out.lastStakeAmount;
982         }
983 
984         // update cached stake totals
985         vaultData.totalStake = vaultData.totalStake.sub(amount);
986         _hypervisor.totalStake = _hypervisor.totalStake.sub(amount);
987         _hypervisor.totalStakeUnits = out.newTotalStakeUnits;
988 
989         // unlock staking tokens from vault
990         IUniversalVault(vault).unlock(_hypervisor.stakingToken, amount, permission);
991 
992         // emit event
993         emit Unstaked(vault, amount);
994 
995         // only perform on non-zero reward
996         if (out.reward > 0) {
997             // calculate shares to burn
998             // sharesToBurn = sharesOutstanding * reward / remainingRewards
999             uint256 sharesToBurn =
1000                 _hypervisor.rewardSharesOutstanding.mul(out.reward).div(remainingRewards);
1001 
1002             // burn claimed shares
1003             _hypervisor.rewardSharesOutstanding = _hypervisor.rewardSharesOutstanding.sub(sharesToBurn);
1004 
1005             // transfer bonus tokens from reward pool to recipient
1006             if (_bonusTokenSet.length() > 0) {
1007                 for (uint256 index = 0; index < _bonusTokenSet.length(); index++) {
1008                     // fetch bonus token address reference
1009                     address bonusToken = _bonusTokenSet.at(index);
1010 
1011                     // calculate bonus token amount
1012                     // bonusAmount = bonusRemaining * reward / remainingRewards
1013                     uint256 bonusAmount =
1014                         IERC20(bonusToken).balanceOf(_hypervisor.rewardPool).mul(out.reward).div(
1015                             remainingRewards
1016                         );
1017 
1018                     // transfer bonus token
1019                     IRewardPool(_hypervisor.rewardPool).sendERC20(bonusToken, recipient, bonusAmount);
1020 
1021                     // emit event
1022                     emit RewardClaimed(vault, recipient, bonusToken, bonusAmount);
1023                 }
1024             }
1025 
1026             // transfer reward tokens from reward pool to recipient
1027             IRewardPool(_hypervisor.rewardPool).sendERC20(_hypervisor.rewardToken, recipient, out.reward);
1028 
1029             // emit event
1030             emit RewardClaimed(vault, recipient, _hypervisor.rewardToken, out.reward);
1031         }
1032     }
1033 
1034     /// @notice Exit Hypervisor without claiming reward
1035     /// @dev This function should never revert when correctly called by the vault.
1036     ///      A max number of stakes per vault is set with MAX_STAKES_PER_VAULT to
1037     ///      place an upper bound on the for loop in calculateTotalStakeUnits().
1038     /// access control: only callable by the vault directly
1039     /// state machine:
1040     ///   - when vault exists on this Hypervisor
1041     ///   - when active stake from this vault
1042     ///   - any power state
1043     /// state scope:
1044     ///   - decrease _hypervisor.totalStake
1045     ///   - increase _hypervisor.lastUpdate
1046     ///   - modify _hypervisor.totalStakeUnits
1047     ///   - delete _vaults[vault]
1048     /// token transfer: none
1049     function rageQuit() external override {
1050         // fetch vault storage reference
1051         VaultData storage _vaultData = _vaults[msg.sender];
1052 
1053         // revert if no active stakes
1054         require(_vaultData.stakes.length != 0, "Hypervisor: no stake");
1055 
1056         // update cached sum of stake units across all vaults
1057         _updateTotalStakeUnits();
1058 
1059         // emit event
1060         emit Unstaked(msg.sender, _vaultData.totalStake);
1061 
1062         // update cached totals
1063         _hypervisor.totalStake = _hypervisor.totalStake.sub(_vaultData.totalStake);
1064         _hypervisor.totalStakeUnits = _hypervisor.totalStakeUnits.sub(
1065             calculateTotalStakeUnits(_vaultData.stakes, block.timestamp)
1066         );
1067 
1068         // delete stake data
1069         delete _vaults[msg.sender];
1070     }
1071 
1072     /* convenience functions */
1073 
1074     function _updateTotalStakeUnits() private {
1075         // update cached totalStakeUnits
1076         _hypervisor.totalStakeUnits = getCurrentTotalStakeUnits();
1077         // update cached lastUpdate
1078         _hypervisor.lastUpdate = block.timestamp;
1079     }
1080 
1081     function _validateAddress(address target) private view {
1082         // sanity check target for potential input errors
1083         require(isValidAddress(target), "Hypervisor: invalid address");
1084     }
1085 
1086     function _truncateStakesArray(StakeData[] memory array, uint256 newLength)
1087         private
1088         pure
1089         returns (StakeData[] memory newArray)
1090     {
1091         newArray = new StakeData[](newLength);
1092         for (uint256 index = 0; index < newLength; index++) {
1093             newArray[index] = array[index];
1094         }
1095         return newArray;
1096     }
1097 }
