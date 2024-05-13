1 // SPDX-License-Identifier: MIT
2 // Original contract: https://github.com/convex-eth/platform/blob/main/contracts/contracts/wrappers/ConvexStakingWrapper.sol
3 pragma solidity 0.8.6;
4 
5 import "@yield-protocol/utils-v2/contracts/token/IERC20.sol";
6 import "@yield-protocol/utils-v2/contracts/token/ERC20.sol";
7 import "@yield-protocol/utils-v2/contracts/access/AccessControl.sol";
8 import "@yield-protocol/utils-v2/contracts/token/TransferHelper.sol";
9 import "./interfaces/IRewardStaking.sol";
10 import "./interfaces/IConvexDeposits.sol";
11 import "./interfaces/ICvx.sol";
12 import "./CvxMining.sol";
13 
14 /// @notice Wrapper used to manage staking of Convex tokens
15 contract ConvexStakingWrapper is ERC20, AccessControl {
16     using TransferHelper for IERC20;
17 
18     struct EarnedData {
19         address token;
20         uint256 amount;
21     }
22 
23     struct RewardType {
24         address reward_token;
25         address reward_pool;
26         uint128 reward_integral;
27         uint128 reward_remaining;
28         mapping(address => uint256) reward_integral_for;
29         mapping(address => uint256) claimable_reward;
30     }
31 
32     uint256 public cvx_reward_integral;
33     uint256 public cvx_reward_remaining;
34     mapping(address => uint256) public cvx_reward_integral_for;
35     mapping(address => uint256) public cvx_claimable_reward;
36 
37     //constants/immutables
38     address public constant convexBooster = address(0xF403C135812408BFbE8713b5A23a04b3D48AAE31);
39     address public constant crv = address(0xD533a949740bb3306d119CC777fa900bA034cd52);
40     address public constant cvx = address(0x4e3FBD56CD56c3e72c1403e103b45Db9da5B9D2B);
41     address public curveToken;
42     address public convexToken;
43     address public convexPool;
44     address public collateralVault;
45     uint256 public convexPoolId;
46 
47     //rewards
48     RewardType[] public rewards;
49 
50     //management
51     bool public isShutdown;
52     bool private _status;
53 
54     bool private constant _NOT_ENTERED = false;
55     bool private constant _ENTERED = true;
56 
57     event Deposited(address indexed _user, address indexed _account, uint256 _amount, bool _wrapped);
58     event Withdrawn(address indexed _user, uint256 _amount, bool _unwrapped);
59 
60     constructor(
61         address _curveToken,
62         address _convexToken,
63         address _convexPool,
64         uint256 _poolId,
65         address _vault,
66         string memory name,
67         string memory symbol,
68         uint8 decimals
69     ) ERC20(name, symbol, decimals) {
70         curveToken = _curveToken;
71         convexToken = _convexToken;
72         convexPool = _convexPool;
73         convexPoolId = _poolId;
74         collateralVault = _vault;
75 
76         //add rewards
77         addRewards();
78         setApprovals();
79     }
80 
81     modifier nonReentrant() {
82         // On the first call to nonReentrant, _notEntered will be true
83         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
84         // Any calls to nonReentrant after this point will fail
85         _status = _ENTERED;
86         _;
87         // By storing the original value once again, a refund is triggered (see
88         // https://eips.ethereum.org/EIPS/eip-2200)
89         _status = _NOT_ENTERED;
90     }
91 
92     /// @notice Give maximum approval to the pool & convex booster contract to transfer funds from wrapper
93     function setApprovals() public {
94         IERC20(curveToken).approve(convexBooster, 0);
95         IERC20(curveToken).approve(convexBooster, type(uint256).max);
96         IERC20(convexToken).approve(convexPool, type(uint256).max);
97     }
98 
99     /// @notice Adds reward tokens by reading the available rewards from the RewardStaking pool
100     /// @dev CRV token is added as a reward by default
101     function addRewards() public {
102         address mainPool = convexPool;
103 
104         uint256 rewardsLength = rewards.length;
105 
106         if (rewardsLength == 0) {
107             RewardType storage reward = rewards.push();
108             reward.reward_token = crv;
109             reward.reward_pool = mainPool;
110             rewardsLength += 1;
111         }
112 
113         uint256 extraCount = IRewardStaking(mainPool).extraRewardsLength();
114         uint256 startIndex = rewardsLength - 1;
115         for (uint256 i = startIndex; i < extraCount; i++) {
116             address extraPool = IRewardStaking(mainPool).extraRewards(i);
117             RewardType storage reward = rewards.push();
118             reward.reward_token = IRewardStaking(extraPool).rewardToken();
119             reward.reward_pool = extraPool;
120         }
121     }
122 
123     /// @notice Returns the length of the reward tokens added
124     /// @return The count of reward tokens
125     function rewardLength() external view returns (uint256) {
126         return rewards.length;
127     }
128 
129     /// @notice Get user's balance
130     /// @param _account User's address for which balance is requested
131     /// @return User's balance of collateral
132     /// @dev Included here to allow inheriting contracts to override.
133     function _getDepositedBalance(address _account) internal view virtual returns (uint256) {
134         if (_account == address(0) || _account == collateralVault) {
135             return 0;
136         }
137         //get balance from collateralVault
138 
139         return _balanceOf[_account];
140     }
141 
142     /// @notice TotalSupply of wrapped token
143     /// @return The total supply of wrapped token
144     /// @dev This function is provided and marked virtual as convenience to future development
145     function _getTotalSupply() internal view virtual returns (uint256) {
146         return _totalSupply;
147     }
148 
149     /// @notice Calculates & upgrades the integral for distributing the CVX rewards
150     /// @param _accounts Accounts for which the CvxIntegral has to be calculated
151     /// @param _balances Balances of the accounts
152     /// @param _supply Total supply of the wrapped token
153     /// @param _isClaim Whether to claim the calculated rewards
154     function _calcCvxIntegral(
155         address[2] memory _accounts,
156         uint256[2] memory _balances,
157         uint256 _supply,
158         bool _isClaim
159     ) internal {
160         uint256 bal = IERC20(cvx).balanceOf(address(this));
161         uint256 cvxRewardRemaining = cvx_reward_remaining;
162         uint256 d_cvxreward = bal - cvxRewardRemaining;
163         uint256 cvxRewardIntegral = cvx_reward_integral;
164 
165         if (_supply > 0 && d_cvxreward > 0) {
166             cvxRewardIntegral = cvxRewardIntegral + (d_cvxreward * 1e20) / (_supply);
167             cvx_reward_integral = cvxRewardIntegral;
168         }
169 
170         //update user integrals for cvx
171         uint256 accountsLength = _accounts.length;
172         for (uint256 u = 0; u < accountsLength; u++) {
173             //do not give rewards to address 0
174             if (_accounts[u] == address(0)) continue;
175             if (_accounts[u] == collateralVault) continue;
176 
177             uint256 userI = cvx_reward_integral_for[_accounts[u]];
178             if (_isClaim || userI < cvxRewardIntegral) {
179                 uint256 receiveable = cvx_claimable_reward[_accounts[u]] +
180                     ((_balances[u] * (cvxRewardIntegral - userI)) / 1e20);
181                 if (_isClaim) {
182                     if (receiveable > 0) {
183                         cvx_claimable_reward[_accounts[u]] = 0;
184                         IERC20(cvx).safeTransfer(_accounts[u], receiveable);
185                         bal = bal - (receiveable);
186                     }
187                 } else {
188                     cvx_claimable_reward[_accounts[u]] = receiveable;
189                 }
190                 cvx_reward_integral_for[_accounts[u]] = cvxRewardIntegral;
191             }
192         }
193 
194         //update reward total
195         if (bal != cvxRewardRemaining) {
196             cvx_reward_remaining = bal;
197         }
198     }
199 
200     /// @notice Calculates & upgrades the integral for distributing the reward token
201     /// @param _index The index of the reward token for which the calculations are to be done
202     /// @param _accounts Accounts for which the CvxIntegral has to be calculated
203     /// @param _balances Balances of the accounts
204     /// @param _supply Total supply of the wrapped token
205     /// @param _isClaim Whether to claim the calculated rewards
206     function _calcRewardIntegral(
207         uint256 _index,
208         address[2] memory _accounts,
209         uint256[2] memory _balances,
210         uint256 _supply,
211         bool _isClaim
212     ) internal {
213         RewardType storage reward = rewards[_index];
214 
215         uint256 rewardIntegral = reward.reward_integral;
216         uint256 rewardRemaining = reward.reward_remaining;
217 
218         //get difference in balance and remaining rewards
219         //getReward is unguarded so we use reward_remaining to keep track of how much was actually claimed
220         uint256 bal = IERC20(reward.reward_token).balanceOf(address(this));
221         if (_supply > 0 && (bal - rewardRemaining) > 0) {
222             rewardIntegral = uint128(rewardIntegral) + uint128(((bal - rewardRemaining) * 1e20) / _supply);
223             reward.reward_integral = uint128(rewardIntegral);
224         }
225         //update user integrals
226         uint256 accountsLength = _accounts.length;
227         for (uint256 u = 0; u < accountsLength; u++) {
228             //do not give rewards to address 0
229             if (_accounts[u] == address(0)) continue;
230             if (_accounts[u] == collateralVault) continue;
231 
232             uint256 userI = reward.reward_integral_for[_accounts[u]];
233             if (_isClaim || userI < rewardIntegral) {
234                 if (_isClaim) {
235                     uint256 receiveable = reward.claimable_reward[_accounts[u]] +
236                         ((_balances[u] * (uint256(rewardIntegral) - userI)) / 1e20);
237                     if (receiveable > 0) {
238                         reward.claimable_reward[_accounts[u]] = 0;
239                         IERC20(reward.reward_token).safeTransfer(_accounts[u], receiveable);
240                         bal = bal - receiveable;
241                     }
242                 } else {
243                     reward.claimable_reward[_accounts[u]] =
244                         reward.claimable_reward[_accounts[u]] +
245                         ((_balances[u] * (uint256(rewardIntegral) - userI)) / 1e20);
246                 }
247                 reward.reward_integral_for[_accounts[u]] = rewardIntegral;
248             }
249         }
250 
251         //update remaining reward here since balance could have changed if claiming
252         if (bal != rewardRemaining) {
253             reward.reward_remaining = uint128(bal);
254         }
255     }
256 
257     /// @notice Create a checkpoint for the supplied addresses by updating the reward integrals & claimable reward for them
258     /// @param _accounts The accounts for which checkpoints have to be calculated
259     function _checkpoint(address[2] memory _accounts) internal {
260         //if shutdown, no longer checkpoint in case there are problems
261         if (isShutdown) return;
262 
263         uint256 supply = _getTotalSupply();
264         uint256[2] memory depositedBalance;
265         depositedBalance[0] = _getDepositedBalance(_accounts[0]);
266         depositedBalance[1] = _getDepositedBalance(_accounts[1]);
267 
268         IRewardStaking(convexPool).getReward(address(this), true);
269 
270         uint256 rewardCount = rewards.length;
271         for (uint256 i = 0; i < rewardCount; i++) {
272             _calcRewardIntegral(i, _accounts, depositedBalance, supply, false);
273         }
274         _calcCvxIntegral(_accounts, depositedBalance, supply, false);
275     }
276 
277     /// @notice Create a checkpoint for the supplied addresses by updating the reward integrals & claimable reward for them & claims the rewards
278     /// @param _accounts The accounts for which checkpoints have to be calculated
279     function _checkpointAndClaim(address[2] memory _accounts) internal {
280         uint256 supply = _getTotalSupply();
281         uint256[2] memory depositedBalance;
282         depositedBalance[0] = _getDepositedBalance(_accounts[0]); //only do first slot
283 
284         IRewardStaking(convexPool).getReward(address(this), true);
285 
286         uint256 rewardCount = rewards.length;
287         for (uint256 i = 0; i < rewardCount; i++) {
288             _calcRewardIntegral(i, _accounts, depositedBalance, supply, true);
289         }
290         _calcCvxIntegral(_accounts, depositedBalance, supply, true);
291     }
292 
293     /// @notice Create a checkpoint for the supplied addresses by updating the reward integrals & claimable reward for them
294     /// @param _accounts The accounts for which checkpoints have to be calculated
295     function user_checkpoint(address[2] calldata _accounts) external returns (bool) {
296         _checkpoint([_accounts[0], _accounts[1]]);
297         return true;
298     }
299 
300     /// @notice Get the balance of the user
301     /// @param _account Address whose balance is to be checked
302     /// @return The balance of the supplied address
303     function totalBalanceOf(address _account) external view returns (uint256) {
304         return _getDepositedBalance(_account);
305     }
306 
307     /// @notice Get the amount of tokens the user has earned
308     /// @param _account Address whose balance is to be checked
309     /// @return claimable Array of earned tokens and their amount
310     function earned(address _account) external view returns (EarnedData[] memory claimable) {
311         uint256 supply = _getTotalSupply();
312         uint256 rewardCount = rewards.length;
313         claimable = new EarnedData[](rewardCount + 1);
314 
315         for (uint256 i = 0; i < rewardCount; i++) {
316             RewardType storage reward = rewards[i];
317             address rewardToken = reward.reward_token;
318 
319             //change in reward is current balance - remaining reward + earned
320             uint256 bal = IERC20(rewardToken).balanceOf(address(this));
321             uint256 d_reward = bal - reward.reward_remaining;
322             d_reward = d_reward + IRewardStaking(reward.reward_pool).earned(address(this));
323 
324             uint256 I = reward.reward_integral;
325             if (supply > 0) {
326                 I = I + (d_reward * 1e20) / supply;
327             }
328 
329             uint256 newlyClaimable = (_getDepositedBalance(_account) * (I - reward.reward_integral_for[_account])) /
330                 1e20;
331             claimable[i].amount = reward.claimable_reward[_account] + newlyClaimable;
332             claimable[i].token = rewardToken;
333 
334             //calc cvx here
335             if (rewardToken == crv) {
336                 claimable[rewardCount].amount =
337                     cvx_claimable_reward[_account] +
338                     CvxMining.ConvertCrvToCvx(newlyClaimable);
339                 claimable[rewardCount].token = cvx;
340             }
341         }
342         return claimable;
343     }
344 
345     /// @notice Claim reward for the supplied account
346     /// @param _account Address whose reward is to be claimed
347     function getReward(address _account) external {
348         //claim directly in checkpoint logic to save a bit of gas
349         _checkpointAndClaim([_account, address(0)]);
350     }
351 }
