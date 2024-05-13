1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity 0.8.9;
3 
4 import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
5 import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
6 
7 import "./access/Authorization.sol";
8 
9 import "../interfaces/IAddressProvider.sol";
10 import "../interfaces/vendor/IRewardStaking.sol";
11 import "../interfaces/vendor/ICrvDepositor.sol";
12 import "../interfaces/vendor/IDelegation.sol";
13 import "../interfaces/vendor/IvlCvxExtraRewardDistribution.sol";
14 import "../interfaces/vendor/ICurveSwap.sol";
15 import "../interfaces/vendor/ICvxLocker.sol";
16 import "../interfaces/ICvxCrvRewardsLocker.sol";
17 
18 import "../libraries/Errors.sol";
19 import "../libraries/AddressProviderHelpers.sol";
20 
21 contract CvxCrvRewardsLocker is ICvxCrvRewardsLocker, Authorization {
22     using AddressProviderHelpers for IAddressProvider;
23 
24     using SafeERC20 for IERC20;
25 
26     // ERC20 tokens
27     address public constant CVX = address(0x4e3FBD56CD56c3e72c1403e103b45Db9da5B9D2B);
28     address public constant CVX_CRV = address(0x62B9c7356A2Dc64a1969e19C23e4f579F9810Aa7);
29     address public constant CRV = address(0xD533a949740bb3306d119CC777fa900bA034cd52);
30 
31     address public constant CVX_CRV_CRV_CURVE_POOL =
32         address(0x9D0464996170c6B9e75eED71c68B99dDEDf279e8); // cvxCRV/CRV Curve Pool
33     address public constant CRV_DEPOSITOR = address(0x8014595F2AB54cD7c604B00E9fb932176fDc86Ae); // Lock CRV for cvxCRV
34     address public constant CVX_CRV_STAKING = address(0x3Fe65692bfCD0e6CF84cB1E7d24108E434A7587e); // Stake cvxCRV and get rewards
35     address public constant CVX_LOCKER = address(0x72a19342e8F1838460eBFCCEf09F6585e32db86E); // CVX Locker
36     address public constant VL_CVX_EXTRA_REWARD_DISTRIBUTION =
37         address(0xDecc7d761496d30F30b92Bdf764fb8803c79360D);
38 
39     uint256 public spendRatio;
40     bool public prepareWithdrawal;
41     address public treasury;
42 
43     int128 private constant _CRV_INDEX = 0;
44     int128 private constant _CVX_CRV_INDEX = 1;
45 
46     event NewSpendRatio(uint256 newSpendRatio);
47     event NewTreasury(address newTreasury);
48 
49     constructor(IAddressProvider _addressProvider)
50         Authorization(_addressProvider.getRoleManager())
51     {
52         // Approve for locking CRV for cvxCRV
53         IERC20(CRV).safeApprove(CRV_DEPOSITOR, type(uint256).max);
54 
55         // Approve for staking cvxCRV
56         IERC20(CVX_CRV).safeApprove(CVX_CRV_STAKING, type(uint256).max);
57 
58         // Approve for cvxCRV/CRV Curve Pool Swaps
59         IERC20(CRV).safeApprove(CVX_CRV_CRV_CURVE_POOL, type(uint256).max);
60 
61         // Approve CVX Locker
62         IERC20(CVX).safeApprove(CVX_LOCKER, type(uint256).max);
63 
64         treasury = _addressProvider.getTreasury();
65     }
66 
67     function lockCvx() external override {
68         _lockCvx();
69     }
70 
71     function lockCrv() external override {
72         _lockCrv();
73     }
74 
75     /**
76      * @notice Set spend ratio for CVX locking.
77      * @dev Spend ratio is the amount of CVX that should be donated to
78      * the Convex treasury to boost vote power. This needs to be enabled
79      * by Convex.
80      * @param _spendRatio New spend ratio to be used.
81      */
82     function setSpendRatio(uint256 _spendRatio) external onlyGovernance returns (bool) {
83         require(
84             _spendRatio <= ICvxLocker(CVX_LOCKER).maximumBoostPayment(),
85             Error.EXCEEDS_MAX_BOOST
86         );
87         spendRatio = _spendRatio;
88         emit NewSpendRatio(_spendRatio);
89         return true;
90     }
91 
92     /**
93      * @notice Claim rewards from Convex.
94      * @dev Rewards to claim are for staked cvxCRV and locked CVX.
95      * @param lockAndStake If true, claimed reward tokens (CRV) will be locked and staked (CRV for cvxCRV and CVX for vlCVX).
96      */
97     function claimRewards(bool lockAndStake) external override returns (bool) {
98         ICvxLocker(CVX_LOCKER).getReward(address(this), false);
99 
100         IRewardStaking(CVX_CRV_STAKING).getReward();
101 
102         if (lockAndStake) {
103             lockRewards();
104         }
105         return true;
106     }
107 
108     /**
109      * @notice Stakes cvxCRV in the cvxCRV rewards contract on Convex.
110      */
111     function stakeCvxCrv() external override returns (bool) {
112         return _stakeCvxCrv();
113     }
114 
115     /**
116      * @notice Prepares a withdrawal of funds.
117      * @dev If this is set then no idle funds can get locked or staked.
118      */
119     function setWithdrawalFlag() external onlyGovernance {
120         prepareWithdrawal = true;
121     }
122 
123     /**
124      * @notice Resets prepared withdrawal of funds.
125      */
126     function resetWithdrawalFlag() external onlyGovernance {
127         prepareWithdrawal = false;
128     }
129 
130     /**
131      * @notice Processes exipred locks.
132      */
133     function processExpiredLocks(bool relock) external override returns (bool) {
134         if (relock) {
135             require(!prepareWithdrawal, Error.PREPARED_WITHDRAWAL);
136         }
137 
138         if (relock) {
139             ICvxLocker(CVX_LOCKER).processExpiredLocks(relock);
140         } else {
141             ICvxLocker(CVX_LOCKER).withdrawExpiredLocksTo(treasury);
142         }
143 
144         return true;
145     }
146 
147     /**
148      * @notice Set treasury to receive withdrawn funds.
149      */
150     function setTreasury(address _treasury) external onlyGovernance returns (bool) {
151         treasury = _treasury;
152         emit NewTreasury(treasury);
153         return true;
154     }
155 
156     /**
157      * @notice Withdraw full amount of a token to the treasury.
158      * @param token Token to withdraw entire balance of.
159      */
160     function withdraw(address token) external onlyGovernance returns (bool) {
161         uint256 balance = IERC20(token).balanceOf(address(this));
162         IERC20(token).safeTransfer(treasury, balance);
163         return true;
164     }
165 
166     /**
167      * @notice Withdraw cvxCRV to treasury.
168      * @dev Unstakes cvxCRV if it is staked.
169      */
170     function withdrawCvxCrv(uint256 amount) external onlyGovernance {
171         IRewardStaking(CVX_CRV_STAKING).withdraw(amount, true);
172         uint256 cvxcrvBal = IERC20(CVX_CRV).balanceOf(address(this));
173         if (cvxcrvBal > 0) {
174             IERC20(CVX_CRV).safeTransfer(treasury, cvxcrvBal);
175         }
176     }
177 
178     function unstakeCvxCrv() external onlyGovernance {
179         unstakeCvxCrv(false);
180     }
181 
182     function unstakeCvxCrv(uint256 amount, bool withdrawal) external onlyGovernance {
183         _unstakeCvxCrv(amount, withdrawal);
184     }
185 
186     /**
187      * @notice Set delegate to receive vote weight.
188      */
189     function setDelegate(address delegateContract, address delegate) external onlyGovernance {
190         IDelegation(delegateContract).setDelegate("cvx.eth", delegate);
191     }
192 
193     /**
194      * @notice Clears a delegate for the msg.sender and a specific id.
195      */
196     function clearDelegate(address delegateContract) external onlyGovernance {
197         IDelegation(delegateContract).clearDelegate("cvx.eth");
198     }
199 
200     function forfeitRewards(address token, uint256 index) external onlyGovernance {
201         IvlCvxExtraRewardDistribution(VL_CVX_EXTRA_REWARD_DISTRIBUTION).forfeitRewards(
202             token,
203             index
204         );
205     }
206 
207     /**
208      * @notice Lock CRV and CVX tokens.
209      * @dev CRV get locked for cvxCRV and staked on Convex.
210      */
211     function lockRewards() public returns (bool) {
212         _lockCrv();
213         _lockCvx();
214         return true;
215     }
216 
217     /**
218      * @notice Withdraw an amount of a token to the treasury.
219      * @param token Token to withdraw.
220      * @param amount Amount of token to withdraw.
221      */
222     function withdraw(address token, uint256 amount) public onlyGovernance returns (bool) {
223         IERC20(token).safeTransfer(treasury, amount);
224         return true;
225     }
226 
227     /**
228      * @notice Unstake cvxCRV from Convex.
229      */
230     function unstakeCvxCrv(bool withdrawal) public onlyGovernance {
231         uint256 staked = IRewardStaking(CVX_CRV_STAKING).balanceOf(address(this));
232         _unstakeCvxCrv(staked, withdrawal);
233     }
234 
235     function _lockCrv() internal {
236         if (prepareWithdrawal) return;
237 
238         uint256 currentBalance = IERC20(CRV).balanceOf(address(this));
239         if (currentBalance != 0) {
240             // Checks if we can get a better rate on Curve Pool
241             uint256 amountOut = ICurveSwap(CVX_CRV_CRV_CURVE_POOL).get_dy(
242                 _CRV_INDEX,
243                 _CVX_CRV_INDEX,
244                 currentBalance
245             );
246             if (amountOut > currentBalance) {
247                 ICurveSwap(CVX_CRV_CRV_CURVE_POOL).exchange(
248                     _CRV_INDEX,
249                     _CVX_CRV_INDEX,
250                     currentBalance,
251                     0
252                 );
253             } else {
254                 // Swap CRV for cxvCRV and stake
255                 ICrvDepositor(CRV_DEPOSITOR).deposit(currentBalance, false, address(0));
256             }
257             IRewardStaking(CVX_CRV_STAKING).stakeAll();
258             return;
259         }
260 
261         if (IERC20(CVX_CRV).balanceOf(address(this)) > 0)
262             IRewardStaking(CVX_CRV_STAKING).stakeAll();
263     }
264 
265     function _lockCvx() internal {
266         // Locks CVX for vlCVX
267         if (prepareWithdrawal) return;
268         uint256 currentBalance = IERC20(CVX).balanceOf(address(this));
269         if (currentBalance == 0) return;
270         ICvxLocker(CVX_LOCKER).lock(address(this), currentBalance, spendRatio);
271     }
272 
273     function _stakeCvxCrv() internal returns (bool) {
274         if (prepareWithdrawal) return false;
275 
276         if (IERC20(CVX_CRV).balanceOf(address(this)) == 0) return false;
277         IRewardStaking(CVX_CRV_STAKING).stakeAll();
278         return true;
279     }
280 
281     function _unstakeCvxCrv(uint256 amount, bool withdrawal) internal {
282         IRewardStaking(CVX_CRV_STAKING).withdraw(amount, true);
283         if (withdrawal) {
284             IERC20(CVX_CRV).safeTransfer(treasury, amount);
285         }
286     }
287 }
