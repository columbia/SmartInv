1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 import "./../refs/CoreRef.sol";
6 import "./IRewarder.sol";
7 import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
8 import "@openzeppelin/contracts/utils/math/SafeCast.sol";
9 import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
10 import "@openzeppelin/contracts/proxy/utils/Initializable.sol";
11 
12 /// @notice migration functionality has been removed as this is only going to be used to distribute staking rewards
13 
14 /// @notice The idea for this TribalChief contract is to be the owner of tribe token
15 /// that is deposited into this contract.
16 /// @notice This contract was forked from sushiswap and has been modified to distribute staking rewards in tribe.
17 /// All legacy code that relied on MasterChef V1 has been removed so that this contract will pay out staking rewards in tribe.
18 /// The assumption this code makes is that this MasterChief contract will be funded before going live and offering staking rewards.
19 /// This contract will not have the ability to mint tribe.
20 contract TribalChief is CoreRef, ReentrancyGuard, Initializable {
21     using SafeERC20 for IERC20;
22     using SafeCast for uint256;
23     using SafeCast for int256;
24 
25     /// @notice Info of each users's reward debt and virtual amount
26     /// stored in a single pool
27     /// `virtualAmount` The virtual amount deposited. Calculated like so (multiplier * amount) / scale_factor
28     /// assumption here is that we will never go over 2^256 -1
29     /// on any user deposits
30     /// 'rewardDebt' tracks the tribe per share when the user entered the pool
31     /// and is used to determine how much Tribe rewards a user is entitled to
32     struct UserInfo {
33         int256 rewardDebt;
34         uint256 virtualAmount;
35     }
36 
37     /// @notice Info for a deposit
38     /// `amount` amount of tokens the user has provided.
39     /// assumption here is that we will never go over 2^256 -1
40     /// on any user deposits
41     /// `unlockBlock` is when a users lockup period ends and they are free to withdraw
42     /// `multiplier` is the multiplier users received on their locked amount.
43     /// This is used to calculate virtual liquidity deltas.
44     struct DepositInfo {
45         uint256 amount;
46         uint128 unlockBlock;
47         uint128 multiplier;
48     }
49 
50     /// @notice Info of each pool.
51     /// `virtualTotalSupply` The total virtual supply in this pool
52     /// `accTribePerShare` The amount of tribe each share is entitled to.
53     /// Users entering a pool have their reward debt start at current tribe per share and
54     /// then they get the delta between where the tribe per share goes to and where they started.
55     /// `lastRewardBlock` The last block where rewards were paid for this pool
56     /// `allocPoint` The amount of allocation points assigned to the pool.
57     /// Also known as the amount of Tribe to distribute per block.
58     /// `unlocked` Whether or not the pool has been unlocked by an admin
59     /// this will allow an admin to unlock the pool if need be.
60     /// This value defaults to false so that users have to respect the lockup period.
61     struct PoolInfo {
62         uint256 virtualTotalSupply;
63         uint256 accTribePerShare;
64         uint128 lastRewardBlock;
65         uint120 allocPoint;
66         bool unlocked;
67     }
68 
69     /// @notice Info of each pool rewards multipliers available.
70     /// map a pool id to a block lock time to a rewards multiplier
71     mapping(uint256 => mapping(uint128 => uint128)) public rewardMultipliers;
72 
73     /// @notice Data needed for governor to create a new lockup period
74     /// and associated reward multiplier
75     struct RewardData {
76         uint128 lockLength;
77         uint128 rewardMultiplier;
78     }
79 
80     /// @notice Address of Tribe contract.
81     /// Cannot be immutable due to limitations of proxies
82     IERC20 public TRIBE;
83     /// @notice Info of each pool.
84     PoolInfo[] public poolInfo;
85     /// @notice Address of the token you can stake in each pool.
86     IERC20[] public stakedToken;
87     /// @notice Address of each `IRewarder` contract.
88     IRewarder[] public rewarder;
89 
90     /// @notice Info of each users reward debt and virtual amount.
91     /// One object is instantiated per user per pool
92     mapping(uint256 => mapping(address => UserInfo)) public userInfo;
93     /// @notice Info of each user that stakes tokens.
94     mapping(uint256 => mapping(address => DepositInfo[])) public depositInfo;
95     /// @dev Total allocation points. Must be the sum of all allocation points in all pools.
96     uint256 public totalAllocPoint;
97 
98     /// @notice these variables cannot be initialized with a constant value
99     /// because of the way that upgradeable contracts work, their initial write
100     // to storage doesn't happen as the logic contract doesn't run the constructor
101 
102     /// the amount of tribe distributed per block
103     uint256 private tribalChiefTribePerBlock;
104     /// variable has been made constant to cut down on gas costs
105     uint256 private ACC_TRIBE_PRECISION;
106     /// decimals for rewards multiplier
107     uint256 public SCALE_FACTOR;
108 
109     event Deposit(address indexed user, uint256 indexed pid, uint256 amount, uint256 indexed depositID);
110     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount, address indexed to);
111     event EmergencyWithdraw(address indexed user, uint256 indexed pid, uint256 amount, address indexed to);
112     event Harvest(address indexed user, uint256 indexed pid, uint256 amount);
113     event LogPoolAddition(
114         uint256 indexed pid,
115         uint256 allocPoint,
116         IERC20 indexed stakedToken,
117         IRewarder indexed rewarder
118     );
119     event LogSetPool(uint256 indexed pid, uint256 allocPoint, IRewarder indexed rewarder, bool overwrite);
120     event LogPoolMultiplier(uint256 indexed pid, uint128 indexed lockLength, uint256 indexed multiplier);
121     event LogUpdatePool(
122         uint256 indexed pid,
123         uint128 indexed lastRewardBlock,
124         uint256 lpSupply,
125         uint256 accTribePerShare
126     );
127     /// @notice tribe withdraw event
128     event TribeWithdraw(uint256 amount);
129     event NewTribePerBlock(uint256 indexed amount);
130     event PoolLocked(bool indexed locked, uint256 indexed pid);
131 
132     /// @notice The way this function is constructed, you will not be able to
133     /// call initialize after this function is constructed, effectively
134     /// only allowing TribalChief to be used through delegate calls.
135     /// @param coreAddress The Core contract address.
136     constructor(address coreAddress) CoreRef(coreAddress) {}
137 
138     /// @param _core The Core contract address.
139     /// @param _tribe The TRIBE token contract address.
140     function initialize(address _core, IERC20 _tribe) external initializer {
141         CoreRef._initialize(_core);
142 
143         TRIBE = _tribe;
144         _setContractAdminRole(keccak256("TRIBAL_CHIEF_ADMIN_ROLE"));
145 
146         // set constant values here as we cannot use constants with proxies
147         tribalChiefTribePerBlock = 75e18;
148         ACC_TRIBE_PRECISION = 1e23;
149         SCALE_FACTOR = 1e4;
150     }
151 
152     /// @notice Allows governor to change the amount of tribe per block
153     /// make sure to call the update pool function before hitting this function
154     /// this will ensure that all of the rewards a user earned previously get paid out
155     /// @param newBlockReward The new amount of tribe per block to distribute
156     function updateBlockReward(uint256 newBlockReward) external onlyGovernorOrAdmin {
157         if (isContractAdmin(msg.sender)) {
158             require(newBlockReward < tribalChiefTribePerBlock, "TribalChief: admin can only lower reward rate");
159         }
160 
161         tribalChiefTribePerBlock = newBlockReward;
162         emit NewTribePerBlock(newBlockReward);
163     }
164 
165     /// @notice Allows governor to lock the pool so the users cannot withdraw
166     /// until their lockup period is over
167     /// @param _pid pool ID
168     function lockPool(uint256 _pid) external onlyGovernorOrAdmin {
169         PoolInfo storage pool = poolInfo[_pid];
170         pool.unlocked = false;
171 
172         emit PoolLocked(true, _pid);
173     }
174 
175     /// @notice Allows governor to unlock the pool so that users can withdraw
176     /// before their tokens have been locked for the entire lockup period
177     /// @param _pid pool ID
178     function unlockPool(uint256 _pid) external onlyGovernorOrAdmin {
179         PoolInfo storage pool = poolInfo[_pid];
180         pool.unlocked = true;
181 
182         emit PoolLocked(false, _pid);
183     }
184 
185     /// @notice Allows governor to change the pool multiplier
186     /// Unlocks the pool if the new multiplier is greater than the old one
187     /// @param _pid pool ID
188     /// @param lockLength lock length to change
189     /// @param newRewardsMultiplier updated rewards multiplier
190     function governorAddPoolMultiplier(
191         uint256 _pid,
192         uint64 lockLength,
193         uint64 newRewardsMultiplier
194     ) external onlyGovernorOrAdmin {
195         PoolInfo storage pool = poolInfo[_pid];
196         uint256 currentMultiplier = rewardMultipliers[_pid][lockLength];
197         // if the new multplier is greater than the current multiplier,
198         // then, you need to unlock the pool to allow users to withdraw
199         // so they can receive this larger reward
200         if (newRewardsMultiplier > currentMultiplier) {
201             pool.unlocked = true;
202             // emit this event if we end up unlocking this pool
203             emit PoolLocked(false, _pid);
204         }
205         rewardMultipliers[_pid][lockLength] = newRewardsMultiplier;
206 
207         emit LogPoolMultiplier(_pid, lockLength, newRewardsMultiplier);
208     }
209 
210     /// @notice sends tokens back to governance treasury. Only callable by governance
211     /// @param amount the amount of tokens to send back to treasury
212     function governorWithdrawTribe(uint256 amount) external onlyGovernor {
213         TRIBE.safeTransfer(address(core()), amount);
214         emit TribeWithdraw(amount);
215     }
216 
217     /// @notice Returns the number of pools.
218     function numPools() public view returns (uint256) {
219         return poolInfo.length;
220     }
221 
222     /// @notice Returns the number of user deposits in a single pool.
223     function openUserDeposits(uint256 pid, address user) public view returns (uint256) {
224         return depositInfo[pid][user].length;
225     }
226 
227     /// @notice Returns the amount a user deposited in a single pool.
228     function getTotalStakedInPool(uint256 pid, address user) public view returns (uint256) {
229         uint256 amount = 0;
230         for (uint256 i = 0; i < depositInfo[pid][user].length; i++) {
231             DepositInfo storage poolDeposit = depositInfo[pid][user][i];
232             amount += poolDeposit.amount;
233         }
234 
235         return amount;
236     }
237 
238     /// @notice Add a new pool. Can only be called by the governor.
239     /// @param allocPoint AP of the new pool.
240     /// @param _stakedToken Address of the ERC-20 token to stake.
241     /// @param _rewarder Address of the rewarder delegate.
242     /// @param rewardData Reward Multiplier data
243     function add(
244         uint120 allocPoint,
245         IERC20 _stakedToken,
246         IRewarder _rewarder,
247         RewardData[] calldata rewardData
248     ) external onlyGovernorOrAdmin {
249         require(allocPoint > 0, "pool must have allocation points to be created");
250         uint128 lastRewardBlock = block.number.toUint128();
251         totalAllocPoint += allocPoint;
252         stakedToken.push(_stakedToken);
253         rewarder.push(_rewarder);
254 
255         uint256 pid = poolInfo.length;
256 
257         require(rewardData.length != 0, "must specify rewards");
258         // loop over all of the arrays of lock data and add them to the rewardMultipliers mapping
259         for (uint256 i = 0; i < rewardData.length; i++) {
260             // if locklength is 0 and multiplier is not equal to scale factor, revert
261             if (rewardData[i].lockLength == 0) {
262                 require(rewardData[i].rewardMultiplier == SCALE_FACTOR, "invalid multiplier for 0 lock length");
263             } else {
264                 // else, assert that multplier is greater than or equal to scale factor
265                 require(
266                     rewardData[i].rewardMultiplier >= SCALE_FACTOR,
267                     "invalid multiplier, must be above scale factor"
268                 );
269             }
270 
271             rewardMultipliers[pid][rewardData[i].lockLength] = rewardData[i].rewardMultiplier;
272             emit LogPoolMultiplier(pid, rewardData[i].lockLength, rewardData[i].rewardMultiplier);
273         }
274 
275         poolInfo.push(
276             PoolInfo({
277                 allocPoint: allocPoint,
278                 virtualTotalSupply: 0, // virtual total supply starts at 0 as there is 0 initial supply
279                 lastRewardBlock: lastRewardBlock,
280                 accTribePerShare: 0,
281                 unlocked: false
282             })
283         );
284         emit LogPoolAddition(pid, allocPoint, _stakedToken, _rewarder);
285     }
286 
287     /// @notice Update the given pool's TRIBE allocation point and `IRewarder` contract.
288     /// Can only be called by the governor.
289     /// @param _pid The index of the pool. See `poolInfo`.
290     /// @param _allocPoint New AP of the pool.
291     /// @param _rewarder Address of the rewarder delegate.
292     /// @param overwrite True if _rewarder should be `set`. Otherwise `_rewarder` is ignored.
293     function set(
294         uint256 _pid,
295         uint120 _allocPoint,
296         IRewarder _rewarder,
297         bool overwrite
298     ) public onlyGovernorOrAdmin {
299         // we must update the pool before applying set so that all previously accrued rewards
300         // are paid out before alloc points change
301         updatePool(_pid);
302         totalAllocPoint = (totalAllocPoint - poolInfo[_pid].allocPoint) + _allocPoint;
303         require(totalAllocPoint > 0, "total allocation points cannot be 0");
304 
305         poolInfo[_pid].allocPoint = _allocPoint;
306         if (overwrite) {
307             rewarder[_pid] = _rewarder;
308         }
309 
310         emit LogSetPool(_pid, _allocPoint, overwrite ? _rewarder : rewarder[_pid], overwrite);
311     }
312 
313     /// @notice Reset the given pool's TRIBE allocation to 0 and unlock the pool.
314     /// Can only be called by the governor or guardian.
315     /// @param _pid The index of the pool. See `poolInfo`.
316     function resetRewards(uint256 _pid) public onlyGuardianOrGovernor {
317         // we must update the pool before resetting rewards so that all previously accrued rewards
318         // are paid out before alloc points go to 0 in this pool
319         updatePool(_pid);
320         PoolInfo storage pool = poolInfo[_pid];
321         // set the pool's allocation points to zero
322         totalAllocPoint = (totalAllocPoint - pool.allocPoint);
323         pool.allocPoint = 0;
324 
325         // unlock all staked tokens in the pool
326         pool.unlocked = true;
327 
328         // erase any IRewarder mapping
329         rewarder[_pid] = IRewarder(address(0));
330 
331         emit PoolLocked(false, _pid);
332         emit LogSetPool(_pid, 0, IRewarder(address(0)), false);
333     }
334 
335     /// @notice View function to see all pending TRIBE on frontend.
336     /// @param _pid The index of the pool. See `poolInfo`.
337     /// @param _user Address of user.
338     /// @return pending TRIBE reward for a given user.
339     function pendingRewards(uint256 _pid, address _user) external view returns (uint256) {
340         PoolInfo storage pool = poolInfo[_pid];
341         UserInfo storage user = userInfo[_pid][_user];
342 
343         uint256 accTribePerShare = pool.accTribePerShare;
344 
345         if (block.number > pool.lastRewardBlock && pool.virtualTotalSupply != 0) {
346             // this is the block delta
347             uint256 blocks = block.number - pool.lastRewardBlock;
348             // this is the amount of tribe this pool is entitled to for the last n blocks
349             uint256 tribeReward = (blocks * tribePerBlock() * pool.allocPoint) / totalAllocPoint;
350             // this is the new tribe per each pool share
351             accTribePerShare = accTribePerShare + ((tribeReward * ACC_TRIBE_PRECISION) / pool.virtualTotalSupply);
352         }
353 
354         // use the virtual amount to calculate the users share of the pool and their pending rewards
355         return
356             (((user.virtualAmount * accTribePerShare) / ACC_TRIBE_PRECISION).toInt256() - user.rewardDebt).toUint256();
357     }
358 
359     /// @notice Update reward variables for all pools. Be careful of gas spending!
360     /// @param pids Pool IDs of all to be updated. Make sure to update all active pools.
361     function massUpdatePools(uint256[] calldata pids) external {
362         uint256 len = pids.length;
363         for (uint256 i = 0; i < len; ++i) {
364             updatePool(pids[i]);
365         }
366     }
367 
368     /// @notice Calculates and returns the `amount` of TRIBE per block.
369     function tribePerBlock() public view returns (uint256) {
370         return tribalChiefTribePerBlock;
371     }
372 
373     /// @notice Update reward variables of the given pool.
374     /// @param pid The index of the pool. See `poolInfo`.
375     function updatePool(uint256 pid) public {
376         PoolInfo storage pool = poolInfo[pid];
377         if (block.number > pool.lastRewardBlock) {
378             uint256 virtualSupply = pool.virtualTotalSupply;
379             if (virtualSupply > 0 && totalAllocPoint != 0) {
380                 uint256 blocks = block.number - pool.lastRewardBlock;
381                 uint256 tribeReward = (blocks * tribePerBlock() * pool.allocPoint) / totalAllocPoint;
382                 pool.accTribePerShare = pool.accTribePerShare + ((tribeReward * ACC_TRIBE_PRECISION) / virtualSupply);
383             }
384             pool.lastRewardBlock = block.number.toUint128();
385             emit LogUpdatePool(pid, pool.lastRewardBlock, virtualSupply, pool.accTribePerShare);
386         }
387     }
388 
389     /// @notice Deposit tokens to earn TRIBE allocation.
390     /// @param pid The index of the pool. See `poolInfo`.
391     /// @param amount The token amount to deposit.
392     /// @param lockLength The length of time you would like to lock tokens
393     function deposit(
394         uint256 pid,
395         uint256 amount,
396         uint64 lockLength
397     ) public nonReentrant whenNotPaused {
398         // we have to update the pool before we allow a user to deposit so that we can correctly calculate their reward debt
399         // if we didn't do this, it would allow users to steal from us by calling deposits and gaining rewards they aren't entitled to
400         updatePool(pid);
401         PoolInfo storage pool = poolInfo[pid];
402         UserInfo storage userPoolData = userInfo[pid][msg.sender];
403         DepositInfo memory poolDeposit;
404 
405         uint128 multiplier = rewardMultipliers[pid][lockLength];
406         require(multiplier >= SCALE_FACTOR, "invalid lock length");
407 
408         // Effects
409         poolDeposit.amount = amount;
410         poolDeposit.unlockBlock = (lockLength + block.number).toUint128();
411         // set the multiplier here so that on withdraw we can easily reset the
412         // multiplier and remove the appropriate amount of virtual liquidity
413         poolDeposit.multiplier = multiplier;
414 
415         // virtual amount is calculated by taking the users total deposited balance and multiplying
416         // it by the multiplier then adding it to the aggregated virtual amount
417         uint256 virtualAmountDelta = (amount * multiplier) / SCALE_FACTOR;
418         userPoolData.virtualAmount += virtualAmountDelta;
419         // update reward debt after virtual amount is set by multiplying virtual amount delta by tribe per share
420         // this tells us when the user deposited and allows us to calculate their rewards later
421         userPoolData.rewardDebt += ((virtualAmountDelta * pool.accTribePerShare) / ACC_TRIBE_PRECISION).toInt256();
422 
423         // pool virtual total supply needs to increase here
424         pool.virtualTotalSupply += virtualAmountDelta;
425 
426         // add the new user struct into storage
427         depositInfo[pid][msg.sender].push(poolDeposit);
428 
429         // Interactions
430         IRewarder _rewarder = rewarder[pid];
431         if (address(_rewarder) != address(0)) {
432             _rewarder.onSushiReward(pid, msg.sender, msg.sender, 0, userPoolData.virtualAmount);
433         }
434 
435         stakedToken[pid].safeTransferFrom(msg.sender, address(this), amount);
436 
437         emit Deposit(msg.sender, pid, amount, depositInfo[pid][msg.sender].length - 1);
438     }
439 
440     /// @notice Withdraw staked tokens from pool.
441     /// @param pid The index of the pool. See `poolInfo`.
442     /// @param to Receiver of the tokens.
443     function withdrawAllAndHarvest(uint256 pid, address to) external nonReentrant {
444         // update the pool, so that accTribePerShare is accurate, then harvest
445         updatePool(pid);
446         _harvest(pid, to);
447 
448         PoolInfo storage pool = poolInfo[pid];
449         UserInfo storage user = userInfo[pid][msg.sender];
450         uint256 unlockedTotalAmount = 0;
451         uint256 virtualLiquidityDelta = 0;
452 
453         // iterate over all deposits this user has and aggregate the deltas
454         uint256 processedDeposits = 0;
455         for (uint256 i = 0; i < depositInfo[pid][msg.sender].length; i++) {
456             DepositInfo storage poolDeposit = depositInfo[pid][msg.sender][i];
457             // if the user has locked the tokens for at least the
458             // lockup period or the pool has been unlocked, allow
459             // user to withdraw their principle from this deposit, otherwise skip this action
460             if (poolDeposit.unlockBlock > block.number && pool.unlocked == false) {
461                 continue;
462             }
463 
464             // if we get past continue, it means that we are going to process this deposit
465             // and send these tokens back to the user
466             processedDeposits++;
467 
468             // gather the virtual and regular amount delta
469             unlockedTotalAmount += poolDeposit.amount;
470             virtualLiquidityDelta += (poolDeposit.amount * poolDeposit.multiplier) / SCALE_FACTOR;
471 
472             // zero out the user object as their amount will be withdrawn and all pending tribe will be paid out
473             poolDeposit.unlockBlock = 0;
474             poolDeposit.multiplier = 0;
475             poolDeposit.amount = 0;
476         }
477 
478         // Effects
479         if (processedDeposits == depositInfo[pid][msg.sender].length) {
480             // Remove the array of deposits and userInfo struct if we were able to withdraw from all deposits.
481             // If we removed all liquidity, then we can just delete all the data we stored on this user
482             // in both depositinfo and userinfo, which means that their reward debt, and virtual liquidity
483             // are all zero'd.
484             delete depositInfo[pid][msg.sender];
485             delete userInfo[pid][msg.sender];
486         } else {
487             // If we didn't end up being able to withdraw all of the liquidity from all of our deposits
488             // then we will just update the userInfo object for the amounts that we did remove.
489             // Batched changes are done at the end of the function so that we don't
490             // write to these storage slots multiple times
491             user.virtualAmount -= virtualLiquidityDelta;
492             // Set the reward debt to the new virtual amount
493             // we don't have to worry about increasing the reward debt here as the harvest function
494             // has already paid out all pending tribe the users deserves.
495             // Here, we just have to make the reward debt equal to:
496             // (current tribe per share * the virtual liquidity) / ACC_TRIBE_PRECISION
497             // of that user so that it is accurate.
498             user.rewardDebt = ((user.virtualAmount * pool.accTribePerShare) / ACC_TRIBE_PRECISION).toInt256();
499         }
500 
501         // regardless of whether or not we removed all of this users liquidity from the pool, we will need to
502         // subtract the virtual liquidity delta from the pool virtual total supply
503         pool.virtualTotalSupply -= virtualLiquidityDelta;
504 
505         // Interactions
506         IRewarder _rewarder = rewarder[pid];
507         if (address(_rewarder) != address(0)) {
508             _rewarder.onSushiReward(pid, msg.sender, to, 0, user.virtualAmount);
509         }
510 
511         if (unlockedTotalAmount != 0) {
512             stakedToken[pid].safeTransfer(to, unlockedTotalAmount);
513         }
514 
515         emit Withdraw(msg.sender, pid, unlockedTotalAmount, to);
516     }
517 
518     /// @notice Withdraw tokens from pool.
519     /// @param pid The index of the pool. See `poolInfo`.
520     /// @param amount Token amount to withdraw.
521     /// @param to Receiver of the tokens.
522     function withdrawFromDeposit(
523         uint256 pid,
524         uint256 amount,
525         address to,
526         uint256 index
527     ) public nonReentrant {
528         require(depositInfo[pid][msg.sender].length > index, "invalid index");
529         updatePool(pid);
530         PoolInfo storage pool = poolInfo[pid];
531         DepositInfo storage poolDeposit = depositInfo[pid][msg.sender][index];
532         UserInfo storage user = userInfo[pid][msg.sender];
533 
534         // if the user has locked the tokens for at least the
535         // lockup period or the pool has been unlocked by the governor,
536         // allow user to withdraw their principle
537         require(poolDeposit.unlockBlock <= block.number || pool.unlocked == true, "tokens locked");
538 
539         uint256 virtualAmountDelta = (amount * poolDeposit.multiplier) / SCALE_FACTOR;
540 
541         // Effects
542         poolDeposit.amount -= amount;
543         user.rewardDebt =
544             user.rewardDebt -
545             ((virtualAmountDelta * pool.accTribePerShare) / ACC_TRIBE_PRECISION).toInt256();
546         user.virtualAmount -= virtualAmountDelta;
547         pool.virtualTotalSupply -= virtualAmountDelta;
548 
549         // Interactions
550         stakedToken[pid].safeTransfer(to, amount);
551 
552         emit Withdraw(msg.sender, pid, amount, to);
553     }
554 
555     /// @notice Helper function to harvest users tribe rewards
556     /// @param pid The index of the pool. See `poolInfo`.
557     /// @param to Receiver of TRIBE rewards.
558     function _harvest(uint256 pid, address to) private {
559         PoolInfo storage pool = poolInfo[pid];
560         UserInfo storage user = userInfo[pid][msg.sender];
561 
562         // assumption here is that we will never go over 2^256 -1
563         int256 accumulatedTribe = ((user.virtualAmount * pool.accTribePerShare) / ACC_TRIBE_PRECISION).toInt256();
564 
565         // this should never happen
566         assert(accumulatedTribe >= 0 && accumulatedTribe - user.rewardDebt >= 0);
567 
568         uint256 pendingTribe = (accumulatedTribe - user.rewardDebt).toUint256();
569 
570         // if pending tribe is ever negative, revert as this can cause an underflow when we turn this number to a uint
571         assert(pendingTribe.toInt256() >= 0);
572 
573         // Effects
574         user.rewardDebt = accumulatedTribe;
575 
576         // Interactions
577         if (pendingTribe != 0) {
578             TRIBE.safeTransfer(to, pendingTribe);
579         }
580 
581         IRewarder _rewarder = rewarder[pid];
582         if (address(_rewarder) != address(0)) {
583             _rewarder.onSushiReward(pid, msg.sender, to, pendingTribe, user.virtualAmount);
584         }
585 
586         emit Harvest(msg.sender, pid, pendingTribe);
587     }
588 
589     /// @notice Harvest proceeds for transaction sender to `to`.
590     /// @param pid The index of the pool. See `poolInfo`.
591     /// @param to Receiver of TRIBE rewards.
592     function harvest(uint256 pid, address to) public nonReentrant {
593         updatePool(pid);
594         _harvest(pid, to);
595     }
596 
597     //////////////////////////////////////////////////////////////////////////////
598     // ----> if you call emergency withdraw, you are forfeiting your rewards <----
599     //////////////////////////////////////////////////////////////////////////////
600 
601     /// @notice Withdraw without caring about rewards. EMERGENCY ONLY.
602     /// @param pid The index of the pool. See `poolInfo`.
603     /// @param to Receiver of the deposited tokens.
604     function emergencyWithdraw(uint256 pid, address to) public nonReentrant {
605         updatePool(pid);
606         PoolInfo storage pool = poolInfo[pid];
607 
608         uint256 totalUnlocked = 0;
609         uint256 virtualLiquidityDelta = 0;
610         for (uint256 i = 0; i < depositInfo[pid][msg.sender].length; i++) {
611             DepositInfo storage poolDeposit = depositInfo[pid][msg.sender][i];
612 
613             // if the user has locked the tokens for at least the
614             // lockup period or the pool has been unlocked, allow
615             // user to withdraw their principle
616             require(poolDeposit.unlockBlock <= block.number || pool.unlocked == true, "tokens locked");
617 
618             totalUnlocked += poolDeposit.amount;
619 
620             // update the aggregated deposit virtual amount
621             // update the virtualTotalSupply
622             virtualLiquidityDelta += (poolDeposit.amount * poolDeposit.multiplier) / SCALE_FACTOR;
623         }
624 
625         // subtract virtualLiquidity Delta from the virtual total supply of this pool
626         pool.virtualTotalSupply -= virtualLiquidityDelta;
627 
628         // remove the array of deposits and userInfo struct
629         delete depositInfo[pid][msg.sender];
630         delete userInfo[pid][msg.sender];
631 
632         IRewarder _rewarder = rewarder[pid];
633         if (address(_rewarder) != address(0)) {
634             _rewarder.onSushiReward(pid, msg.sender, to, 0, 0);
635         }
636 
637         // Note: transfer can fail or succeed if `amount` is zero.
638         stakedToken[pid].safeTransfer(to, totalUnlocked);
639         emit EmergencyWithdraw(msg.sender, pid, totalUnlocked, to);
640     }
641 }
