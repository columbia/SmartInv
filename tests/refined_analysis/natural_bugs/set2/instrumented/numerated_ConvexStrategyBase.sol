1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity 0.8.9;
3 
4 // TODO Add validation of curve pools
5 // TODO Test validation
6 
7 import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
8 import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";
9 import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
10 
11 import "./IStrategySwapper.sol";
12 
13 import "../utils/CvxMintAmount.sol";
14 
15 import "../access/Authorization.sol";
16 
17 import "../../libraries/ScaledMath.sol";
18 import "../../libraries/AddressProviderHelpers.sol";
19 import "../../libraries/EnumerableExtensions.sol";
20 
21 import "../../interfaces/IStrategy.sol";
22 import "../../interfaces/vendor/IBooster.sol";
23 import "../../interfaces/vendor/IRewardStaking.sol";
24 import "../../interfaces/vendor/ICurveSwapEth.sol";
25 import "../../interfaces/vendor/ICurveRegistry.sol";
26 
27 abstract contract ConvexStrategyBase is IStrategy, Authorization, CvxMintAmount {
28     using ScaledMath for uint256;
29     using SafeERC20 for IERC20;
30     using EnumerableSet for EnumerableSet.AddressSet;
31     using EnumerableExtensions for EnumerableSet.AddressSet;
32     using AddressProviderHelpers for IAddressProvider;
33 
34     IBooster internal constant _BOOSTER = IBooster(0xF403C135812408BFbE8713b5A23a04b3D48AAE31); // Convex Booster Contract
35     IERC20 internal constant _CRV = IERC20(0xD533a949740bb3306d119CC777fa900bA034cd52); // CRV
36     IERC20 internal constant _CVX = IERC20(0x4e3FBD56CD56c3e72c1403e103b45Db9da5B9D2B); // CVX
37     IERC20 internal constant _WETH = IERC20(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2); // WETH
38     ICurveRegistry internal constant _CURVE_REGISTRY =
39         ICurveRegistry(0x90E00ACe148ca3b23Ac1bC8C240C2a7Dd9c2d7f5); // Curve Registry Contract
40     address internal constant _CURVE_ETH_ADDRESS =
41         address(0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE); // Null Address used for Curve ETH pools
42 
43     IStrategySwapper internal immutable _strategySwapper;
44 
45     address internal _strategist; // The strategist for the strategy
46     EnumerableSet.AddressSet internal _rewardTokens; // List of additional reward tokens when claiming rewards on Convex
47     IERC20 public underlying; // Strategy Underlying
48     bool public isShutdown; // If the strategy is shutdown, stops all deposits
49     address public communityReserve; // Address for sending CVX & CRV Community Reserve share
50     address public immutable vault; // Backd Vault
51     uint256 public crvCommunityReserveShare; // Share of CRV sent to Community Reserve
52     uint256 public cvxCommunityReserveShare; // Share of CVX sent to Community Reserve
53     uint256 public imbalanceToleranceIn; // Maximum allowed slippage from Curve Pool Imbalance for depositing
54     uint256 public imbalanceToleranceOut; // Maximum allowed slippage from Curve Pool Imbalance for withdrawing
55     IRewardStaking public rewards; // Rewards Contract for claiming Convex Rewards
56     IERC20 public lp; // Curve Pool LP Token
57     ICurveSwapEth public curvePool; // Curve Pool
58     uint256 public convexPid; // Index of Convex Pool in Booster Contract
59     uint256 public curveIndex; // Underlying index in Curve Pool
60 
61     event Deposit(); // Emitted after a successfull deposit
62     event Withdraw(uint256 amount); // Emitted after a successful withdrawal
63     event WithdrawAll(uint256 amount); // Emitted after successfully withdrwaing all
64     event Shutdown(); // Emitted after a successful shutdown
65     event SetCommunityReserve(address reserve); // Emitted after a succuessful setting of reserve
66     event SetCrvCommunityReserveShare(uint256 value); // Emitted after a succuessful setting of CRV Community Reserve Share
67     event SetCvxCommunityReserveShare(uint256 value); // Emitted after a succuessful setting of CVX Community Reserve Share
68     event SetImbalanceToleranceIn(uint256 value); // Emitted after a succuessful setting of imbalance tolerance in
69     event SetImbalanceToleranceOut(uint256 value); // Emitted after a succuessful setting of imbalance tolerance out
70     event SetStrategist(address strategist); // Emitted after a succuessful setting of strategist
71     event AddRewardToken(address token); // Emitted after successfully adding a new reward token
72     event RemoveRewardToken(address token); // Emitted after successfully removing a reward token
73     event Harvest(uint256 amount); // Emitted after a successful harvest
74 
75     modifier onlyVault() {
76         require(msg.sender == vault, Error.UNAUTHORIZED_ACCESS);
77         _;
78     }
79 
80     constructor(
81         address vault_,
82         address strategist_,
83         uint256 convexPid_,
84         address curvePool_,
85         uint256 curveIndex_,
86         IAddressProvider addressProvider_,
87         address strategySwapper_
88     ) Authorization(addressProvider_.getRoleManager()) {
89         // Getting data from supporting contracts
90         _validateCurvePool(curvePool_);
91         (address lp_, , , address rewards_, , ) = _BOOSTER.poolInfo(convexPid_);
92         lp = IERC20(lp_);
93         rewards = IRewardStaking(rewards_);
94         curvePool = ICurveSwapEth(curvePool_);
95         address underlying_ = ICurveSwapEth(curvePool_).coins(curveIndex_);
96         if (underlying_ == _CURVE_ETH_ADDRESS) underlying_ = address(0);
97         underlying = IERC20(underlying_);
98 
99         // Setting inputs
100         vault = vault_;
101         _strategist = strategist_;
102         convexPid = convexPid_;
103         curveIndex = curveIndex_;
104         _strategySwapper = IStrategySwapper(strategySwapper_);
105 
106         // Approvals
107         _CRV.safeApprove(address(_strategySwapper), type(uint256).max);
108         _CVX.safeApprove(address(_strategySwapper), type(uint256).max);
109         _WETH.safeApprove(address(_strategySwapper), type(uint256).max);
110     }
111 
112     /**
113      * @notice Deposit all available underlying into Convex pool.
114      * @return True if successful deposit.
115      */
116     function deposit() external payable override onlyVault returns (bool) {
117         require(!isShutdown, Error.STRATEGY_SHUT_DOWN);
118         if (!_deposit()) return false;
119         emit Deposit();
120         return true;
121     }
122 
123     /**
124      * @notice Withdraw an amount of underlying to the vault.
125      * @dev This can only be called by the vault.
126      *      If the amount is not available, it will be made liquid.
127      * @param amount_ Amount of underlying to withdraw.
128      * @return True if successful withdrawal.
129      */
130     function withdraw(uint256 amount_) external override onlyVault returns (bool) {
131         if (amount_ == 0) return false;
132         if (!_withdraw(amount_)) return false;
133         emit Withdraw(amount_);
134         return true;
135     }
136 
137     /**
138      * @notice Withdraw all underlying.
139      * @dev This does not liquidate reward tokens and only considers
140      *      idle underlying, idle lp tokens and staked lp tokens.
141      * @return Amount of underlying withdrawn
142      */
143     function withdrawAll() external override returns (uint256) {
144         require(
145             msg.sender == vault || _roleManager().hasRole(Roles.GOVERNANCE, msg.sender),
146             Error.UNAUTHORIZED_ACCESS
147         );
148         uint256 amountWithdrawn_ = _withdrawAll();
149         if (amountWithdrawn_ == 0) return 0;
150         emit WithdrawAll(amountWithdrawn_);
151         return amountWithdrawn_;
152     }
153 
154     /**
155      * @notice Harvests reward tokens and sells these for the underlying.
156      * @dev Any underlying harvested is not redeposited by this method.
157      * @return Amount of underlying harvested.
158      */
159     function harvest() external override onlyVault returns (uint256) {
160         return _harvest();
161     }
162 
163     /**
164      * @notice Shuts down the strategy, disabling deposits.
165      * @return True if reserve was successfully set.
166      */
167     function shutdown() external override onlyVault returns (bool) {
168         if (isShutdown) return false;
169         isShutdown = true;
170         emit Shutdown();
171         return true;
172     }
173 
174     /**
175      * @notice Set the address of the communit reserve.
176      * @dev CRV & CVX will be taxed and allocated to the reserve,
177      *      such that Backd can participate in governance.
178      * @param _communityReserve Address of the community reserve.
179      * @return True if successfully set.
180      */
181     function setCommunityReserve(address _communityReserve) external onlyGovernance returns (bool) {
182         communityReserve = _communityReserve;
183         emit SetCommunityReserve(_communityReserve);
184         return true;
185     }
186 
187     /**
188      * @notice Set the share of CRV to send to the Community Reserve.
189      * @param crvCommunityReserveShare_ New fee charged on CRV rewards for governance.
190      * @return True if successfully set.
191      */
192     function setCrvCommunityReserveShare(uint256 crvCommunityReserveShare_)
193         external
194         onlyGovernance
195         returns (bool)
196     {
197         require(crvCommunityReserveShare_ <= ScaledMath.ONE, Error.INVALID_AMOUNT);
198         require(communityReserve != address(0), "Community reserve must be set");
199         crvCommunityReserveShare = crvCommunityReserveShare_;
200         emit SetCrvCommunityReserveShare(crvCommunityReserveShare_);
201         return true;
202     }
203 
204     /**
205      * @notice Set the share of CVX to send to the Community Reserve.
206      * @param cvxCommunityReserveShare_ New fee charged on CVX rewards for governance.
207      * @return True if successfully set.
208      */
209     function setCvxCommunityReserveShare(uint256 cvxCommunityReserveShare_)
210         external
211         onlyGovernance
212         returns (bool)
213     {
214         require(cvxCommunityReserveShare_ <= ScaledMath.ONE, Error.INVALID_AMOUNT);
215         require(communityReserve != address(0), "Community reserve must be set");
216         cvxCommunityReserveShare = cvxCommunityReserveShare_;
217         emit SetCvxCommunityReserveShare(cvxCommunityReserveShare_);
218         return true;
219     }
220 
221     /**
222      * @notice Set imbalance tolerance for Curve Pool deposits.
223      * @dev Stored as a percent, e.g. 1% would be set as 0.01
224      * @param imbalanceToleranceIn_ New imbalance tolarance in.
225      * @return True if successfully set.
226      */
227     function setImbalanceToleranceIn(uint256 imbalanceToleranceIn_)
228         external
229         onlyGovernance
230         returns (bool)
231     {
232         imbalanceToleranceIn = imbalanceToleranceIn_;
233         emit SetImbalanceToleranceIn(imbalanceToleranceIn_);
234         return true;
235     }
236 
237     /**
238      * @notice Set imbalance tolerance for Curve Pool withdrawals.
239      * @dev Stored as a percent, e.g. 1% would be set as 0.01
240      * @param imbalanceToleranceOut_ New imbalance tolarance out.
241      * @return True if successfully set.
242      */
243     function setImbalanceToleranceOut(uint256 imbalanceToleranceOut_)
244         external
245         onlyGovernance
246         returns (bool)
247     {
248         imbalanceToleranceOut = imbalanceToleranceOut_;
249         emit SetImbalanceToleranceOut(imbalanceToleranceOut_);
250         return true;
251     }
252 
253     /**
254      * @notice Set strategist.
255      * @dev Can only be set by current strategist.
256      * @param strategist_ Address of new strategist.
257      * @return True if successfully set.
258      */
259     function setStrategist(address strategist_) external returns (bool) {
260         require(msg.sender == _strategist, Error.UNAUTHORIZED_ACCESS);
261         _strategist = strategist_;
262         emit SetStrategist(strategist_);
263         return true;
264     }
265 
266     /**
267      * @notice Add a reward token to list of extra reward tokens.
268      * @dev These are tokens that are not the main assets of the strategy. For instance, temporary incentives.
269      * @param token_ Address of token to add to reward token list.
270      * @return True if successfully added.
271      */
272     function addRewardToken(address token_) external onlyGovernance returns (bool) {
273         require(
274             token_ != address(_CVX) && token_ != address(underlying) && token_ != address(_CRV),
275             Error.INVALID_TOKEN_TO_ADD
276         );
277         if (_rewardTokens.contains(token_)) return false;
278         _rewardTokens.add(token_);
279         IERC20(token_).safeApprove(address(_strategySwapper), 0);
280         IERC20(token_).safeApprove(address(_strategySwapper), type(uint256).max);
281         emit AddRewardToken(token_);
282         return true;
283     }
284 
285     /**
286      * @notice Remove a reward token.
287      * @param token_ Address of token to remove from reward token list.
288      * @return True if successfully removed.
289      */
290     function removeRewardToken(address token_) external onlyGovernance returns (bool) {
291         if (!_rewardTokens.remove(token_)) return false;
292         emit RemoveRewardToken(token_);
293         return true;
294     }
295 
296     /**
297      * @notice Amount of rewards that can be harvested in the underlying.
298      * @dev Includes rewards for CRV, CVX & Extra Rewards.
299      * @return Estimated amount of underlying available to harvest.
300      */
301     function harvestable() external view override returns (uint256) {
302         IRewardStaking rewards_ = rewards;
303         uint256 crvAmount_ = rewards_.earned(address(this));
304         if (crvAmount_ == 0) return 0;
305         uint256 harvestable_ = _underlyingAmountOut(
306             address(_CRV),
307             crvAmount_.scaledMul(ScaledMath.ONE - crvCommunityReserveShare)
308         ) +
309             _underlyingAmountOut(
310                 address(_CVX),
311                 getCvxMintAmount(crvAmount_).scaledMul(ScaledMath.ONE - cvxCommunityReserveShare)
312             );
313         for (uint256 i = 0; i < _rewardTokens.length(); i++) {
314             IRewardStaking extraRewards_ = IRewardStaking(rewards_.extraRewards(i));
315             address rewardToken_ = extraRewards_.rewardToken();
316             if (!_rewardTokens.contains(rewardToken_)) continue;
317             harvestable_ += _underlyingAmountOut(rewardToken_, extraRewards_.earned(address(this)));
318         }
319         return harvestable_;
320     }
321 
322     /**
323      * @notice Returns the address of the strategist.
324      * @return The the address of the strategist.
325      */
326     function strategist() external view override returns (address) {
327         return _strategist;
328     }
329 
330     /**
331      * @notice Returns the list of reward tokens supported by the strategy.
332      * @return The list of reward tokens supported by the strategy.
333      */
334     function rewardTokens() external view returns (address[] memory) {
335         return _rewardTokens.toArray();
336     }
337 
338     /**
339      * @notice Get the total underlying balance of the strategy.
340      * @return Underlying balance of strategy.
341      */
342     function balance() external view virtual override returns (uint256);
343 
344     /**
345      * @notice Returns the name of the strategy.
346      * @return The name of the strategy.
347      */
348     function name() external view virtual override returns (string memory);
349 
350     /**
351      * @dev Contract does not stash tokens.
352      */
353     function hasPendingFunds() external pure override returns (bool) {
354         return false;
355     }
356 
357     function _deposit() internal virtual returns (bool);
358 
359     function _withdraw(uint256 amount_) internal virtual returns (bool);
360 
361     function _withdrawAll() internal virtual returns (uint256);
362 
363     function _harvest() internal returns (uint256) {
364         uint256 initialBalance_ = _underlyingBalance();
365 
366         // Claim Convex rewards
367         rewards.getReward();
368 
369         // Sending share to Community Reserve
370         _sendCommunityReserveShare();
371 
372         // Swap CVX for WETH
373         IStrategySwapper strategySwapper_ = _strategySwapper;
374         strategySwapper_.swapAllForWeth(address(_CVX));
375 
376         // Swap CRV for WETH
377         strategySwapper_.swapAllForWeth(address(_CRV));
378 
379         // Swap Extra Rewards for WETH
380         for (uint256 i = 0; i < _rewardTokens.length(); i++) {
381             strategySwapper_.swapAllForWeth(_rewardTokens.at(i));
382         }
383 
384         // Swap WETH for underlying
385         strategySwapper_.swapAllWethForToken(address(underlying));
386 
387         uint256 harvested_ = _underlyingBalance() - initialBalance_;
388         emit Harvest(harvested_);
389         return harvested_;
390     }
391 
392     /**
393      * @notice Sends a share of the current balance of CRV and CVX to the Community Reserve.
394      */
395     function _sendCommunityReserveShare() internal {
396         address communityReserve_ = communityReserve;
397         if (communityReserve_ == address(0)) return;
398         uint256 cvxCommunityReserveShare_ = cvxCommunityReserveShare;
399         if (cvxCommunityReserveShare_ > 0) {
400             IERC20 cvx_ = _CVX;
401             uint256 cvxBalance_ = cvx_.balanceOf(address(this));
402             if (cvxBalance_ > 0) {
403                 cvx_.safeTransfer(
404                     communityReserve_,
405                     cvxBalance_.scaledMul(cvxCommunityReserveShare_)
406                 );
407             }
408         }
409         uint256 crvCommunityReserveShare_ = crvCommunityReserveShare;
410         if (crvCommunityReserveShare_ > 0) {
411             IERC20 crv_ = _CRV;
412             uint256 crvBalance_ = crv_.balanceOf(address(this));
413             if (crvBalance_ > 0) {
414                 crv_.safeTransfer(
415                     communityReserve_,
416                     crvBalance_.scaledMul(crvCommunityReserveShare_)
417                 );
418             }
419         }
420     }
421 
422     /**
423      * @dev Get the balance of the underlying.
424      */
425     function _underlyingBalance() internal view virtual returns (uint256);
426 
427     /**
428      * @dev Get the balance of the lp.
429      */
430     function _lpBalance() internal view returns (uint256) {
431         return lp.balanceOf(address(this));
432     }
433 
434     /**
435      * @dev Get the balance of the underlying staked in the Curve pool.
436      */
437     function _stakedBalance() internal view returns (uint256) {
438         return rewards.balanceOf(address(this));
439     }
440 
441     function _underlyingAmountOut(address token_, uint256 amount_) internal view returns (uint256) {
442         return _strategySwapper.amountOut(token_, address(underlying), amount_);
443     }
444 
445     /**
446      * @dev Reverts if it is not a valid Curve Pool.
447      */
448     function _validateCurvePool(address curvePool_) internal view {
449         _CURVE_REGISTRY.get_A(curvePool_);
450     }
451 }
