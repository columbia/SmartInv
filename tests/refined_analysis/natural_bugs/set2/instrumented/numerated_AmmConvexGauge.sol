1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity 0.8.9;
3 
4 import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
5 import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
6 
7 import "../../libraries/ScaledMath.sol";
8 import "../../libraries/Errors.sol";
9 
10 import "../../interfaces/vendor/IBooster.sol";
11 import "../../interfaces/vendor/IRewardStaking.sol";
12 import "../../interfaces/tokenomics/IAmmConvexGauge.sol";
13 import "./AmmGauge.sol";
14 import "../utils/CvxMintAmount.sol";
15 
16 contract AmmConvexGauge is IAmmConvexGauge, AmmGauge, CvxMintAmount {
17     using ScaledMath for uint256;
18     using SafeERC20 for IERC20;
19     address public immutable cvx;
20     address public immutable crv;
21     address public immutable booster;
22     address public inflationRecipient;
23 
24     uint256 public immutable bkdPoolPID; // bkd pool id on Convex
25     IRewardStaking public immutable crvRewardsContract; // Staking contract for bkd convex deposit token
26 
27     // Additional integrals etc. for crv and cvx rewards
28     uint256 public crvStakedIntegral;
29     uint256 public cvxStakedIntegral;
30     mapping(address => uint256) public perUserCrvStakedIntegral;
31     mapping(address => uint256) public perUserCvxStakedIntegral;
32     mapping(address => uint256) public perUserShareCrv;
33     mapping(address => uint256) public perUserShareCvx;
34 
35     uint256 private _crvLastEarned;
36     uint256 private _cvxLastEarned;
37     uint256 private _preClaimRewardsCrvEarned;
38 
39     event RewardClaimed(
40         address indexed beneficiary,
41         uint256 bkdAmount,
42         uint256 crvAmount,
43         uint256 cvxAmount
44     );
45 
46     constructor(
47         IController _controller,
48         address _ammToken,
49         uint256 _bkdPoolPID,
50         address _crv,
51         address _cvx,
52         address _booster
53     ) AmmGauge(_controller, _ammToken) {
54         cvx = _cvx;
55         crv = _crv;
56         booster = _booster;
57         bkdPoolPID = _bkdPoolPID;
58         (, , , address _crvRewards, , ) = IBooster(booster).poolInfo(_bkdPoolPID);
59         crvRewardsContract = IRewardStaking(_crvRewards);
60 
61         // approve for Convex deposit
62         IERC20(ammToken).safeApprove(booster, type(uint256).max);
63     }
64 
65     function claimRewards(address beneficiary) external virtual override returns (uint256) {
66         require(
67             msg.sender == beneficiary || _roleManager().hasRole(Roles.GAUGE_ZAP, msg.sender),
68             Error.UNAUTHORIZED_ACCESS
69         );
70         _userCheckpoint(beneficiary);
71         uint256 amount = perUserShare[beneficiary];
72         uint256 crvAmount = perUserShareCrv[beneficiary];
73         uint256 cvxAmount = perUserShareCvx[beneficiary];
74         if (amount <= 0 && crvAmount <= 0 && cvxAmount <= 0) return 0;
75         crvRewardsContract.getReward();
76         _crvLastEarned = 0;
77         _cvxLastEarned = 0;
78         perUserShare[beneficiary] = 0;
79         perUserShareCrv[beneficiary] = 0;
80         perUserShareCvx[beneficiary] = 0;
81         IController(controller).inflationManager().mintRewards(beneficiary, amount);
82         IERC20(crv).safeTransfer(beneficiary, crvAmount);
83         IERC20(cvx).safeTransfer(beneficiary, cvxAmount);
84         _preClaimRewardsCrvEarned = IERC20(crv).balanceOf(address(this));
85         emit RewardClaimed(beneficiary, amount, crvAmount, cvxAmount);
86         return amount;
87     }
88 
89     function setInflationRecipient(address recipient) external override onlyGovernance {
90         require(inflationRecipient == address(0), Error.ADDRESS_ALREADY_SET);
91         poolCheckpoint();
92         inflationRecipient = recipient;
93     }
94 
95     function deactivateInflationRecipient() external override onlyGovernance {
96         require(inflationRecipient != address(0), Error.ADDRESS_NOT_FOUND);
97         poolCheckpoint();
98         inflationRecipient = address(0);
99     }
100 
101     function claimableRewards(address user) external view virtual override returns (uint256) {
102         uint256 ammStakedIntegral_ = ammStakedIntegral;
103         uint256 timeElapsed = block.timestamp - uint256(ammLastUpdated);
104         if (user == inflationRecipient) {
105             return
106                 perUserShare[inflationRecipient] +
107                 IController(controller).inflationManager().getAmmRateForToken(ammToken) *
108                 timeElapsed;
109         }
110         if (!killed && totalStaked > 0) {
111             ammStakedIntegral_ +=
112                 IController(controller).inflationManager().getAmmRateForToken(ammToken) *
113                 timeElapsed.scaledDiv(totalStaked);
114         }
115         return
116             perUserShare[user] +
117             balances[user].scaledMul(ammStakedIntegral_ - perUserStakedIntegral[user]);
118     }
119 
120     function allClaimableRewards(address user) external view override returns (uint256[3] memory) {
121         uint256 ammStakedIntegral_ = ammStakedIntegral;
122         uint256 crvStakedIntegral_ = crvStakedIntegral;
123         uint256 cvxStakedIntegral_ = cvxStakedIntegral;
124         uint256 timeElapsed = block.timestamp - uint256(ammLastUpdated);
125         uint256 crvEarned = IERC20(crv).balanceOf(address(this)) -
126             _preClaimRewardsCrvEarned +
127             crvRewardsContract.earned(address(this));
128         uint256 cvxEarned = getCvxMintAmount(crvEarned);
129 
130         if (!killed && totalStaked > 0) {
131             if (inflationRecipient == address(0)) {
132                 ammStakedIntegral_ +=
133                     (IController(controller).inflationManager().getAmmRateForToken(ammToken)) *
134                     (timeElapsed).scaledDiv(totalStaked);
135             }
136             crvStakedIntegral_ += (crvEarned - _crvLastEarned).scaledDiv(totalStaked);
137             cvxStakedIntegral_ += (cvxEarned - _cvxLastEarned).scaledDiv(totalStaked);
138         }
139         uint256 bkdRewards;
140         if (user == inflationRecipient) {
141             bkdRewards =
142                 perUserShare[user] +
143                 IController(controller).inflationManager().getAmmRateForToken(ammToken) *
144                 timeElapsed;
145         } else {
146             bkdRewards =
147                 perUserShare[user] +
148                 balances[user].scaledMul(ammStakedIntegral_ - perUserStakedIntegral[user]);
149         }
150         uint256 crvRewards = perUserShareCrv[user] +
151             balances[user].scaledMul(crvStakedIntegral_ - perUserCrvStakedIntegral[user]);
152         uint256 cvxRewards = perUserShareCvx[user] +
153             balances[user].scaledMul(cvxStakedIntegral_ - perUserCvxStakedIntegral[user]);
154         uint256[3] memory allRewards = [bkdRewards, crvRewards, cvxRewards];
155         return allRewards;
156     }
157 
158     function stakeFor(address account, uint256 amount) public virtual override returns (bool) {
159         require(amount > 0, Error.INVALID_AMOUNT);
160 
161         _userCheckpoint(account);
162 
163         IERC20(ammToken).safeTransferFrom(msg.sender, address(this), amount);
164         IBooster(booster).deposit(bkdPoolPID, amount, true);
165         balances[account] += amount;
166         totalStaked += amount;
167         emit AmmStaked(account, ammToken, amount);
168         return true;
169     }
170 
171     function unstakeFor(address dst, uint256 amount) public virtual override returns (bool) {
172         require(amount > 0, Error.INVALID_AMOUNT);
173         require(balances[msg.sender] >= amount, Error.INSUFFICIENT_BALANCE);
174 
175         _userCheckpoint(msg.sender);
176 
177         crvRewardsContract.withdrawAndUnwrap(amount, false);
178         IERC20(ammToken).safeTransfer(dst, amount);
179         balances[msg.sender] -= amount;
180         totalStaked -= amount;
181         emit AmmUnstaked(msg.sender, ammToken, amount);
182         return true;
183     }
184 
185     function poolCheckpoint() public virtual override returns (bool) {
186         if (killed) {
187             return false;
188         }
189         uint256 timeElapsed = block.timestamp - uint256(ammLastUpdated);
190         uint256 currentRate = IController(controller).inflationManager().getAmmRateForToken(
191             ammToken
192         );
193         uint256 crvEarned = IERC20(crv).balanceOf(address(this)) -
194             _preClaimRewardsCrvEarned +
195             crvRewardsContract.earned(address(this));
196         uint256 cvxEarned = getCvxMintAmount(crvEarned);
197 
198         // Update the integral of total token supply for the pool
199         if (totalStaked > 0) {
200             if (inflationRecipient == address(0)) {
201                 ammStakedIntegral += (currentRate * timeElapsed).scaledDiv(totalStaked);
202             } else {
203                 perUserShare[inflationRecipient] += currentRate * timeElapsed;
204             }
205             crvStakedIntegral += (crvEarned - _crvLastEarned).scaledDiv(totalStaked);
206             cvxStakedIntegral += (cvxEarned - _cvxLastEarned).scaledDiv(totalStaked);
207         }
208         _crvLastEarned = crvEarned;
209         _cvxLastEarned = cvxEarned;
210         ammLastUpdated = uint48(block.timestamp);
211         return true;
212     }
213 
214     function _userCheckpoint(address user) internal virtual override returns (bool) {
215         poolCheckpoint();
216         perUserShare[user] += balances[user].scaledMul(
217             ammStakedIntegral - perUserStakedIntegral[user]
218         );
219         perUserShareCrv[user] += balances[user].scaledMul(
220             crvStakedIntegral - perUserCrvStakedIntegral[user]
221         );
222         perUserShareCvx[user] += balances[user].scaledMul(
223             cvxStakedIntegral - perUserCvxStakedIntegral[user]
224         );
225         perUserStakedIntegral[user] = ammStakedIntegral;
226         perUserCrvStakedIntegral[user] = crvStakedIntegral;
227         perUserCvxStakedIntegral[user] = cvxStakedIntegral;
228         return true;
229     }
230 }
