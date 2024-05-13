1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.0;
3 
4 import "../../refs/CoreRef.sol";
5 import "../../core/TribeRoles.sol";
6 import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
7 
8 interface ILiquidityGauge {
9     function deposit(uint256 value) external;
10 
11     function withdraw(uint256 value, bool claim_rewards) external;
12 
13     function claim_rewards() external;
14 
15     function balanceOf(address) external view returns (uint256);
16 
17     // curve & balancer use lp_token()
18     function lp_token() external view returns (address);
19 
20     // angle use staking_token()
21     function staking_token() external view returns (address);
22 
23     function reward_tokens(uint256 i) external view returns (address token);
24 
25     function reward_count() external view returns (uint256 nTokens);
26 }
27 
28 interface ILiquidityGaugeController {
29     function vote_for_gauge_weights(address gauge_addr, uint256 user_weight) external;
30 
31     function last_user_vote(address user, address gauge) external view returns (uint256);
32 
33     function vote_user_power(address user) external view returns (uint256);
34 
35     function gauge_types(address gauge) external view returns (int128);
36 
37     function vote_user_slopes(address user, address gauge)
38         external
39         view
40         returns (
41             uint256 slope,
42             uint256 power,
43             uint256 end
44         );
45 }
46 
47 /// @title Liquidity gauge manager, used to stake tokens in liquidity gauges.
48 /// @author Fei Protocol
49 abstract contract LiquidityGaugeManager is CoreRef {
50     // Events
51     event GaugeControllerChanged(address indexed oldController, address indexed newController);
52     event GaugeSetForToken(address indexed token, address indexed gauge);
53     event GaugeVote(address indexed gauge, uint256 amount);
54     event GaugeStake(address indexed gauge, uint256 amount);
55     event GaugeUnstake(address indexed gauge, uint256 amount);
56     event GaugeRewardsClaimed(address indexed gauge, address indexed token, uint256 amount);
57 
58     /// @notice address of the gauge controller used for voting
59     address public gaugeController;
60 
61     /// @notice mapping of token staked to gauge address
62     mapping(address => address) public tokenToGauge;
63 
64     constructor(address _gaugeController) {
65         gaugeController = _gaugeController;
66     }
67 
68     /// @notice Set the gauge controller used for gauge weight voting
69     /// @param _gaugeController the gauge controller address
70     function setGaugeController(address _gaugeController) public onlyTribeRole(TribeRoles.METAGOVERNANCE_GAUGE_ADMIN) {
71         require(gaugeController != _gaugeController, "LiquidityGaugeManager: same controller");
72 
73         address oldController = gaugeController;
74         gaugeController = _gaugeController;
75 
76         emit GaugeControllerChanged(oldController, gaugeController);
77     }
78 
79     /// @notice returns the token address to be staked in the given gauge
80     function _tokenStakedInGauge(address gaugeAddress) internal view virtual returns (address) {
81         return ILiquidityGauge(gaugeAddress).lp_token();
82     }
83 
84     /// @notice Set gauge for a given token.
85     /// @param token the token address to stake in gauge
86     /// @param gaugeAddress the address of the gauge where to stake token
87     function setTokenToGauge(address token, address gaugeAddress)
88         public
89         onlyTribeRole(TribeRoles.METAGOVERNANCE_GAUGE_ADMIN)
90     {
91         require(_tokenStakedInGauge(gaugeAddress) == token, "LiquidityGaugeManager: wrong gauge for token");
92         require(
93             ILiquidityGaugeController(gaugeController).gauge_types(gaugeAddress) >= 0,
94             "LiquidityGaugeManager: wrong gauge address"
95         );
96         tokenToGauge[token] = gaugeAddress;
97 
98         emit GaugeSetForToken(token, gaugeAddress);
99     }
100 
101     /// @notice Vote for a gauge's weight
102     /// @param token the address of the token to vote for
103     /// @param gaugeWeight the weight of gaugeAddress in basis points [0, 10_000]
104     function voteForGaugeWeight(address token, uint256 gaugeWeight)
105         public
106         whenNotPaused
107         onlyTribeRole(TribeRoles.METAGOVERNANCE_VOTE_ADMIN)
108     {
109         address gaugeAddress = tokenToGauge[token];
110         require(gaugeAddress != address(0), "LiquidityGaugeManager: token has no gauge configured");
111         ILiquidityGaugeController(gaugeController).vote_for_gauge_weights(gaugeAddress, gaugeWeight);
112 
113         emit GaugeVote(gaugeAddress, gaugeWeight);
114     }
115 
116     /// @notice Stake tokens in a gauge
117     /// @param token the address of the token to stake in the gauge
118     /// @param amount the amount of tokens to stake in the gauge
119     function stakeInGauge(address token, uint256 amount)
120         public
121         whenNotPaused
122         onlyTribeRole(TribeRoles.METAGOVERNANCE_GAUGE_ADMIN)
123     {
124         address gaugeAddress = tokenToGauge[token];
125         require(gaugeAddress != address(0), "LiquidityGaugeManager: token has no gauge configured");
126         IERC20(token).approve(gaugeAddress, amount);
127         ILiquidityGauge(gaugeAddress).deposit(amount);
128 
129         emit GaugeStake(gaugeAddress, amount);
130     }
131 
132     /// @notice Stake all tokens held in a gauge
133     /// @param token the address of the token to stake in the gauge
134     function stakeAllInGauge(address token) public whenNotPaused onlyTribeRole(TribeRoles.METAGOVERNANCE_GAUGE_ADMIN) {
135         address gaugeAddress = tokenToGauge[token];
136         require(gaugeAddress != address(0), "LiquidityGaugeManager: token has no gauge configured");
137         uint256 amount = IERC20(token).balanceOf(address(this));
138         IERC20(token).approve(gaugeAddress, amount);
139         ILiquidityGauge(gaugeAddress).deposit(amount);
140 
141         emit GaugeStake(gaugeAddress, amount);
142     }
143 
144     /// @notice Unstake tokens from a gauge
145     /// @param token the address of the token to unstake from the gauge
146     /// @param amount the amount of tokens to unstake from the gauge
147     function unstakeFromGauge(address token, uint256 amount)
148         public
149         whenNotPaused
150         onlyTribeRole(TribeRoles.METAGOVERNANCE_GAUGE_ADMIN)
151     {
152         address gaugeAddress = tokenToGauge[token];
153         require(gaugeAddress != address(0), "LiquidityGaugeManager: token has no gauge configured");
154         ILiquidityGauge(gaugeAddress).withdraw(amount, false);
155 
156         emit GaugeUnstake(gaugeAddress, amount);
157     }
158 
159     /// @notice Claim rewards associated to a gauge where this contract stakes
160     /// tokens.
161     function claimGaugeRewards(address token) public whenNotPaused {
162         address gaugeAddress = tokenToGauge[token];
163         require(gaugeAddress != address(0), "LiquidityGaugeManager: token has no gauge configured");
164 
165         uint256 nTokens = ILiquidityGauge(gaugeAddress).reward_count();
166         address[] memory tokens = new address[](nTokens);
167         uint256[] memory amounts = new uint256[](nTokens);
168 
169         for (uint256 i = 0; i < nTokens; i++) {
170             tokens[i] = ILiquidityGauge(gaugeAddress).reward_tokens(i);
171             amounts[i] = IERC20(tokens[i]).balanceOf(address(this));
172         }
173 
174         ILiquidityGauge(gaugeAddress).claim_rewards();
175 
176         for (uint256 i = 0; i < nTokens; i++) {
177             amounts[i] = IERC20(tokens[i]).balanceOf(address(this)) - amounts[i];
178 
179             emit GaugeRewardsClaimed(gaugeAddress, tokens[i], amounts[i]);
180         }
181     }
182 }
