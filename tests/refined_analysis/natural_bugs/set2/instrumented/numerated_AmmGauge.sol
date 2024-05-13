1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity 0.8.9;
3 
4 import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
5 
6 import "../../interfaces/IController.sol";
7 import "../../interfaces/tokenomics/IAmmGauge.sol";
8 
9 import "../../libraries/ScaledMath.sol";
10 import "../../libraries/Errors.sol";
11 import "../../libraries/AddressProviderHelpers.sol";
12 
13 import "../access/Authorization.sol";
14 
15 contract AmmGauge is Authorization, IAmmGauge {
16     using AddressProviderHelpers for IAddressProvider;
17     using ScaledMath for uint256;
18     using SafeERC20 for IERC20;
19 
20     IController public immutable controller;
21 
22     mapping(address => uint256) public balances;
23 
24     // All the data fields required for the staking tracking
25     uint256 public ammStakedIntegral;
26     uint256 public totalStaked;
27     mapping(address => uint256) public perUserStakedIntegral;
28     mapping(address => uint256) public perUserShare;
29 
30     address public immutable ammToken;
31     bool public killed;
32     uint48 public ammLastUpdated;
33 
34     event RewardClaimed(address indexed account, uint256 amount);
35 
36     constructor(IController _controller, address _ammToken)
37         Authorization(_controller.addressProvider().getRoleManager())
38     {
39         ammToken = _ammToken;
40         controller = _controller;
41         ammLastUpdated = uint48(block.timestamp);
42     }
43 
44     /**
45      * @notice Shut down the gauge.
46      * @dev Accrued inflation can still be claimed from the gauge after shutdown.
47      * @return `true` if successful.
48      */
49     function kill() external override returns (bool) {
50         require(msg.sender == address(controller.inflationManager()), Error.UNAUTHORIZED_ACCESS);
51         poolCheckpoint();
52         killed = true;
53         return true;
54     }
55 
56     function claimRewards(address beneficiary) external virtual override returns (uint256) {
57         require(
58             msg.sender == beneficiary || _roleManager().hasRole(Roles.GAUGE_ZAP, msg.sender),
59             Error.UNAUTHORIZED_ACCESS
60         );
61         _userCheckpoint(beneficiary);
62         uint256 amount = perUserShare[beneficiary];
63         if (amount <= 0) return 0;
64         perUserShare[beneficiary] = 0;
65         controller.inflationManager().mintRewards(beneficiary, amount);
66         emit RewardClaimed(beneficiary, amount);
67         return amount;
68     }
69 
70     function stake(uint256 amount) external virtual override returns (bool) {
71         return stakeFor(msg.sender, amount);
72     }
73 
74     function unstake(uint256 amount) external virtual override returns (bool) {
75         return unstakeFor(msg.sender, amount);
76     }
77 
78     function getAmmToken() external view override returns (address) {
79         return ammToken;
80     }
81 
82     function isAmmToken(address token) external view override returns (bool) {
83         return token == ammToken;
84     }
85 
86     function claimableRewards(address user) external view virtual override returns (uint256) {
87         uint256 ammStakedIntegral_ = ammStakedIntegral;
88         if (!killed && totalStaked > 0) {
89             ammStakedIntegral_ += (controller.inflationManager().getAmmRateForToken(ammToken) *
90                 (block.timestamp - uint256(ammLastUpdated))).scaledDiv(totalStaked);
91         }
92         return
93             perUserShare[user] +
94             balances[user].scaledMul(ammStakedIntegral_ - perUserStakedIntegral[user]);
95     }
96 
97     /**
98      * @notice Stake amount of AMM token on behalf of another account.
99      * @param account Account for which tokens will be staked.
100      * @param amount Amount of token to stake.
101      * @return `true` if success.
102      */
103     function stakeFor(address account, uint256 amount) public virtual returns (bool) {
104         require(amount > 0, Error.INVALID_AMOUNT);
105 
106         _userCheckpoint(account);
107 
108         uint256 oldBal = IERC20(ammToken).balanceOf(address(this));
109         IERC20(ammToken).safeTransferFrom(msg.sender, address(this), amount);
110         uint256 newBal = IERC20(ammToken).balanceOf(address(this));
111         uint256 staked = newBal - oldBal;
112         balances[account] += staked;
113         totalStaked += staked;
114         emit AmmStaked(account, ammToken, amount);
115         return true;
116     }
117 
118     /**
119      * @notice Unstake amount of AMM token and send to another account.
120      * @param dst Account to which unstaked AMM tokens will be sent.
121      * @param amount Amount of token to unstake.
122      * @return `true` if success.
123      */
124     function unstakeFor(address dst, uint256 amount) public virtual returns (bool) {
125         require(amount > 0, Error.INVALID_AMOUNT);
126         require(balances[msg.sender] >= amount, Error.INSUFFICIENT_BALANCE);
127 
128         _userCheckpoint(msg.sender);
129 
130         uint256 oldBal = IERC20(ammToken).balanceOf(address(this));
131         IERC20(ammToken).safeTransfer(dst, amount);
132         uint256 newBal = IERC20(ammToken).balanceOf(address(this));
133         uint256 unstaked = oldBal - newBal;
134         balances[msg.sender] -= unstaked;
135         totalStaked -= unstaked;
136         emit AmmUnstaked(msg.sender, ammToken, amount);
137         return true;
138     }
139 
140     function poolCheckpoint() public virtual override returns (bool) {
141         if (killed) {
142             return false;
143         }
144         uint256 currentRate = controller.inflationManager().getAmmRateForToken(ammToken);
145         // Update the integral of total token supply for the pool
146         uint256 timeElapsed = block.timestamp - uint256(ammLastUpdated);
147         if (totalStaked > 0) {
148             ammStakedIntegral += (currentRate * timeElapsed).scaledDiv(totalStaked);
149         }
150         ammLastUpdated = uint48(block.timestamp);
151         return true;
152     }
153 
154     function _userCheckpoint(address user) internal virtual returns (bool) {
155         poolCheckpoint();
156         perUserShare[user] += balances[user].scaledMul(
157             ammStakedIntegral - perUserStakedIntegral[user]
158         );
159         perUserStakedIntegral[user] = ammStakedIntegral;
160         return true;
161     }
162 }
