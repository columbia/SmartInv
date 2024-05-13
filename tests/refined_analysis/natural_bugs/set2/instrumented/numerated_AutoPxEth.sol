1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.19;
3 
4 import {Ownable2Step} from "openzeppelin-contracts/contracts/access/Ownable2Step.sol";
5 import {ERC4626} from "solmate/mixins/ERC4626.sol";
6 import {ERC20} from "solmate/tokens/ERC20.sol";
7 import {FixedPointMathLib} from "solmate/utils/FixedPointMathLib.sol";
8 import {SafeTransferLib} from "solmate/utils/SafeTransferLib.sol";
9 import {Errors} from "./libraries/Errors.sol";
10 import {IPirexEth} from "./interfaces/IPirexEth.sol";
11 
12 /**
13  * @title AutoPxEth
14  * @notice Autocompounding vault for (staked) pxETH, adapted from pxCVX vault system
15  * @dev This contract enables autocompounding for pxETH assets and includes various fee mechanisms.
16  * @author redactedcartel.finance
17  */
18 contract AutoPxEth is Ownable2Step, ERC4626 {
19     /**
20      * @dev Library: SafeTransferLib - Provides safe transfer functions for ERC20 tokens.
21      */
22     using SafeTransferLib for ERC20;
23 
24     /**
25      * @dev Library: FixedPointMathLib - Provides fixed-point arithmetic for uint256.
26      */
27     using FixedPointMathLib for uint256;
28 
29     // Constants
30 
31     /**
32      * @dev Maximum withdrawal penalty percentage.
33      */
34     uint256 private constant MAX_WITHDRAWAL_PENALTY = 50_000;
35     
36 
37     /**
38      * @dev Maximum platform fee percentage.
39      */
40     uint256 private constant MAX_PLATFORM_FEE = 200_000;
41 
42     /**
43      * @dev Fee denominator for precise fee calculations.
44      */
45     uint256 private constant FEE_DENOMINATOR = 1_000_000;
46 
47     /**
48      * @dev Duration of the rewards period.
49      */
50     uint256 private constant REWARDS_DURATION = 7 days;
51 
52     // State variables for tracking rewards and actively staked assets
53 
54     /**
55      * @notice Reference to the PirexEth contract.
56      */
57     IPirexEth public pirexEth;
58     
59     /**
60      * @notice Timestamp when the current rewards period will end.
61      */
62     uint256 public periodFinish;
63     
64     /**
65      * @notice Rate at which rewards are distributed per second.
66      */
67     uint256 public rewardRate;
68     
69     /**
70      * @notice Timestamp of the last update to the reward variables.
71      */
72     uint256 public lastUpdateTime;
73     
74     /**
75      * @notice Accumulated reward per token stored.
76      */
77     uint256 public rewardPerTokenStored;
78     
79     /**
80      * @notice Last calculated reward per token paid to stakers.
81      */
82     uint256 public rewardPerTokenPaid;
83     
84     /**
85      * @notice Total rewards available for distribution.
86      */
87     uint256 public rewards;
88     
89     /**
90      * @notice Total assets actively staked in the vault.
91      */
92     uint256 public totalStaked;
93 
94     // State variables related to fees
95     /**
96      * @notice Withdrawal penalty percentage.
97      */
98     uint256 public withdrawalPenalty = 30_000;
99     
100     /**
101      * @notice Platform fee percentage.
102      */
103     uint256 public platformFee = 100_000;
104     
105     /**
106      * @notice Address of the platform that receives fees.
107      */
108     address public platform;
109 
110     // Events
111 
112     /**
113      * @notice Emitted when rewards are harvested and staked.
114      * @dev This event is emitted when a user triggers the harvest function.
115      * @param caller address indexed Address that triggered the harvest.
116      * @param value  uint256         Amount of rewards harvested.
117      */
118     event Harvest(address indexed caller, uint256 value);
119 
120     /**
121      * @notice Emitted when the withdrawal penalty is updated.
122      * @dev This event is emitted when the withdrawal penalty is modified.
123      * @param penalty uint256 New withdrawal penalty percentage.
124      */
125     event WithdrawalPenaltyUpdated(uint256 penalty);
126 
127     /**
128      * @notice Emitted when the platform fee is updated.
129      * @dev This event is emitted when the platform fee is modified.
130      * @param fee uint256 New platform fee percentage.
131      */
132     event PlatformFeeUpdated(uint256 fee);
133     
134     /**
135      * @notice Emitted when the platform address is updated.
136      * @dev This event is emitted when the platform address is modified.
137      * @param _platform address New platform address.
138      */
139     event PlatformUpdated(address _platform);
140 
141     /**
142      * @notice Emitted when new rewards are added to the vault.
143      * @dev This event is emitted when new rewards are added to the vault.
144      * @param reward uint256 Amount of rewards added.
145      */
146     event RewardAdded(uint256 reward);
147 
148     /**
149      * @notice Emitted when the PirexEth contract address is set.
150      * @dev This event is emitted when the PirexEth contract address is set.
151      * @param _pirexEth address New PirexEth contract address.
152      */
153     event SetPirexEth(address _pirexEth);
154 
155     // Modifiers
156     /**
157      * @dev Update reward states modifier
158      * @param updateEarned bool Whether to update earned amount so far
159      */
160     modifier updateReward(bool updateEarned) {
161         rewardPerTokenStored = rewardPerToken();
162         lastUpdateTime = lastTimeRewardApplicable();
163 
164         if (updateEarned) {
165             rewards = earned();
166             rewardPerTokenPaid = rewardPerTokenStored;
167         }
168         _;
169     }
170 
171     /**
172      * @dev Contract constructor
173      * @param _asset address Asset contract address
174      * @param _platform address Platform address
175      */
176     constructor(
177         address _asset,
178         address _platform
179     ) ERC4626(ERC20(_asset), "Autocompounding Pirex Ether", "apxETH") {
180         if (_platform == address(0)) revert Errors.ZeroAddress();
181 
182         platform = _platform;
183     }
184 
185     /*//////////////////////////////////////////////////////////////
186                         RESTRICTED FUNCTIONS
187     //////////////////////////////////////////////////////////////*/
188 
189     /**
190      * @notice Set the PirexEth contract address
191      * @dev Function access restricted to only owner
192      * @param _pirexEth address PirexEth contract address
193      */
194     function setPirexEth(address _pirexEth) external onlyOwner {
195         if (_pirexEth == address(0)) revert Errors.ZeroAddress();
196 
197         emit SetPirexEth(_pirexEth);
198 
199         pirexEth = IPirexEth(_pirexEth);
200     }
201 
202     /**
203      * @notice Set the withdrawal penalty
204      * @dev Function access restricted to only owner
205      * @param penalty uint256 Withdrawal penalty
206      */
207     function setWithdrawalPenalty(uint256 penalty) external onlyOwner {
208         if (penalty > MAX_WITHDRAWAL_PENALTY) revert Errors.ExceedsMax();
209 
210         withdrawalPenalty = penalty;
211 
212         emit WithdrawalPenaltyUpdated(penalty);
213     }
214 
215     /**
216      * @notice Set the platform fee
217      * @dev Function access restricted to only owner
218      * @param fee uint256 Platform fee
219      */
220     function setPlatformFee(uint256 fee) external onlyOwner {
221         if (fee > MAX_PLATFORM_FEE) revert Errors.ExceedsMax();
222 
223         platformFee = fee;
224 
225         emit PlatformFeeUpdated(fee);
226     }
227 
228     /**
229      * @notice Set the platform
230      * @dev Function access restricted to only owner
231      * @param _platform address Platform
232      */
233     function setPlatform(address _platform) external onlyOwner {
234         if (_platform == address(0)) revert Errors.ZeroAddress();
235 
236         platform = _platform;
237 
238         emit PlatformUpdated(_platform);
239     }
240 
241     /**
242      * @notice Notify and sync the newly added rewards to be streamed over time
243      * @dev Rewards are streamed following the duration set in REWARDS_DURATION
244      */
245     function notifyRewardAmount() external updateReward(false) {
246         if (msg.sender != address(pirexEth)) revert Errors.NotPirexEth();
247 
248         // Rewards transferred directly to this contract are not added to totalStaked
249         // To get the rewards w/o relying on a potentially incorrect passed in arg,
250         // we can use the difference between the asset balance and totalStaked.
251         // Additionally, to avoid re-distributing rewards, deduct the output of `earned`
252         uint256 rewardBalance = asset.balanceOf(address(this)) -
253             totalStaked -
254             earned();
255 
256         rewardRate = rewardBalance / REWARDS_DURATION;
257 
258         if (rewardRate == 0) revert Errors.NoRewards();
259 
260         lastUpdateTime = block.timestamp;
261         periodFinish = block.timestamp + REWARDS_DURATION;
262 
263         emit RewardAdded(rewardBalance);
264     }
265 
266     /*//////////////////////////////////////////////////////////////
267                                 VIEWS
268     //////////////////////////////////////////////////////////////*/
269 
270     /**
271      * @inheritdoc ERC4626
272      * @notice Get the amount of available pxETH in the contract
273      * @dev Rewards are streamed for the duration set in REWARDS_DURATION
274      */
275     function totalAssets() public view override returns (uint256) {
276         // Based on the current totalStaked and available rewards
277         uint256 _totalStaked = totalStaked;
278         uint256 _rewards = ((_totalStaked *
279             (rewardPerToken() - rewardPerTokenPaid)) / 1e18) + rewards;
280 
281         // Deduct the exact reward amount staked (after fees are deducted when calling `harvest`)
282         return
283             _totalStaked +
284             (
285                 _rewards == 0
286                     ? 0
287                     : (_rewards - ((_rewards * platformFee) / FEE_DENOMINATOR))
288             );
289     }
290 
291     /**
292      * @notice Returns the last effective timestamp of the current reward period
293      * @return uint256 Timestamp
294      */
295     function lastTimeRewardApplicable() public view returns (uint256) {
296         return block.timestamp < periodFinish ? block.timestamp : periodFinish;
297     }
298 
299     /**
300      * @notice Returns the amount of rewards per staked token/asset
301      * @return uint256 Rewards amount
302      */
303     function rewardPerToken() public view returns (uint256) {
304         if (totalStaked == 0) {
305             return rewardPerTokenStored;
306         }
307 
308         return
309             rewardPerTokenStored +
310             ((((lastTimeRewardApplicable() - lastUpdateTime) * rewardRate) *
311                 1e18) / totalStaked);
312     }
313 
314     /**
315      * @notice Returns the earned rewards amount so far
316      * @return uint256 Rewards amount
317      */
318     function earned() public view returns (uint256) {
319         return
320             ((totalStaked * (rewardPerToken() - rewardPerTokenPaid)) / 1e18) +
321             rewards;
322     }
323 
324     /**
325      * @notice Return the amount of assets per 1 (1e18) share
326      * @return uint256 Assets
327      */
328     function assetsPerShare() external view returns (uint256) {
329         return previewRedeem(1e18);
330     }
331 
332     /*//////////////////////////////////////////////////////////////
333                             INTERNAL FUNCTIONS
334     //////////////////////////////////////////////////////////////*/
335 
336     /**
337      * @dev Internal method to keep track of the total amount of staked token/asset on deposit/mint
338      */
339     function _stake(uint256 amount) internal updateReward(true) {
340         totalStaked += amount;
341     }
342 
343     /**
344      * @dev Internal method to keep track of the total amount of staked token/asset on withdrawal/redeem
345      */
346     function _withdraw(uint256 amount) internal updateReward(true) {
347         totalStaked -= amount;
348     }
349 
350     /*//////////////////////////////////////////////////////////////
351                             ERC4626 OVERRIDES
352     //////////////////////////////////////////////////////////////*/
353 
354     /**
355      * @inheritdoc ERC4626
356      * @dev Deduct the specified amount of assets from totalStaked to prepare for transfer to the user
357      * @param assets uint256 Assets
358      */
359     function beforeWithdraw(uint256 assets, uint256) internal override {
360         // Perform harvest to make sure that totalStaked is always equal or larger than assets to be withdrawn
361         if (assets > totalStaked) harvest();
362 
363         _withdraw(assets);
364     }
365 
366     /**
367      * @inheritdoc ERC4626
368      * @dev Include the new assets in totalStaked so that rewards can be properly distributed
369      * @param assets uint256 Assets
370      */
371     function afterDeposit(uint256 assets, uint256) internal override {
372         _stake(assets);
373     }
374 
375     /**
376      * @inheritdoc ERC4626
377      * @dev Preview the amount of assets a user would receive from redeeming shares
378      */
379     function previewRedeem(
380         uint256 shares
381     ) public view override returns (uint256) {
382         // Calculate assets based on a user's % ownership of vault shares
383         uint256 assets = convertToAssets(shares);
384 
385         uint256 _totalSupply = totalSupply;
386 
387         // Calculate a penalty - zero if user is the last to withdraw.
388         uint256 penalty = (_totalSupply == 0 || _totalSupply - shares == 0)
389             ? 0
390             : assets.mulDivUp(withdrawalPenalty, FEE_DENOMINATOR); // Round up the penalty in favour of the protocol.
391 
392         // Redeemable amount is the post-penalty amount
393         return assets - penalty;
394     }
395 
396     /**
397      * @inheritdoc ERC4626
398      * @notice Preview the amount of shares a user would need to redeem the specified asset amount
399      * @dev This modified version takes into consideration the withdrawal fee
400      */
401     function previewWithdraw(
402         uint256 assets
403     ) public view override returns (uint256) {
404         // Calculate shares based on the specified assets' proportion of the pool
405         uint256 shares = convertToShares(assets);
406 
407         // Save 1 SLOAD
408         uint256 _totalSupply = totalSupply;
409 
410         // Factor in additional shares to fulfill withdrawal if user is not the last to withdraw
411         return
412             (_totalSupply == 0 || _totalSupply - shares == 0)
413                 ? shares
414                 : (shares * FEE_DENOMINATOR) /
415                     (FEE_DENOMINATOR - withdrawalPenalty);
416     }
417 
418     /*//////////////////////////////////////////////////////////////
419                             MUTATIVE FUNCTIONS
420     //////////////////////////////////////////////////////////////*/
421 
422     /**
423      * @notice Harvest and stake available rewards after distributing fees to the platform
424      * @dev This function claims and stakes the available rewards, deducting a fee for the platform.
425      */
426     function harvest() public updateReward(true) {
427         uint256 _rewards = rewards;
428 
429         if (_rewards != 0) {
430             rewards = 0;
431 
432             // Fee for platform
433             uint256 feeAmount = (_rewards * platformFee) / FEE_DENOMINATOR;
434 
435             // Deduct fee from reward balance
436             _rewards -= feeAmount;
437 
438             // Claimed rewards should be in pxETH
439             asset.safeTransfer(platform, feeAmount);
440 
441             // Stake rewards sans fee
442             _stake(_rewards);
443 
444             emit Harvest(msg.sender, _rewards);
445         }
446     }
447 
448     /**
449      * @notice Override transfer logic to trigger direct `initiateRedemption`.
450      * @dev This function overrides the standard transfer logic to initiate redemption when transferring to the PirexEth contract.
451      * @param to     address Transfer destination
452      * @param amount uint256 Amount
453      * @return       bool
454      */
455     function transfer(
456         address to,
457         uint256 amount
458     ) public override returns (bool) {
459         super.transfer(to, amount);
460 
461         if (to == address(pirexEth)) {
462             pirexEth.initiateRedemption(amount, msg.sender, false);
463         }
464 
465         return true;
466     }
467 
468     /**
469      * @notice Override transferFrom logic to trigger direct `initiateRedemption`.
470      * @dev This function overrides the standard transferFrom logic to initiate redemption when transferring from the PirexEth contract.
471      * @param from   Address of the transfer origin.
472      * @param to     Address of the transfer destination.
473      * @param amount Amount of tokens to transfer.
474      * @return       A boolean indicating the success of the transfer.
475      */
476     function transferFrom(
477         address from,
478         address to,
479         uint256 amount
480     ) public override returns (bool) {
481         super.transferFrom(from, to, amount);
482 
483         if (to == address(pirexEth)) {
484             pirexEth.initiateRedemption(amount, from, false);
485         }
486 
487         return true;
488     }
489 }
