1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.4;
3 
4 import "../../Constants.sol";
5 import "./IConvexBooster.sol";
6 import "./IConvexBaseRewardPool.sol";
7 import "../curve/ICurvePool.sol";
8 import "../PCVDeposit.sol";
9 
10 /// @title ConvexPCVDeposit: implementation for a PCVDeposit that stake/unstake
11 /// the Curve LP tokens on Convex, and can claim rewards.
12 /// @author Fei Protocol
13 contract ConvexPCVDeposit is PCVDeposit {
14     // ------------------ Properties -------------------------------------------
15 
16     /// @notice The Curve pool to deposit in
17     ICurvePool public curvePool;
18     /// @notice The Convex Booster contract (for deposit/withdraw)
19     IConvexBooster public convexBooster;
20     /// @notice The Convex Rewards contract (for claiming rewards)
21     IConvexBaseRewardPool public convexRewards;
22 
23     /// @notice number of coins in the Curve pool
24     uint256 private constant N_COINS = 3;
25     /// @notice boolean to know if FEI is in the pool
26     bool private immutable feiInPool;
27     /// @notice FEI index in the pool. If FEI is not present, value = 0.
28     uint256 private immutable feiIndexInPool;
29 
30     // ------------------ Constructor ------------------------------------------
31 
32     /// @notice ConvexPCVDeposit constructor
33     /// @param _core Fei Core for reference
34     /// @param _curvePool The Curve pool whose LP tokens are staked
35     /// @param _convexBooster The Convex Booster contract (for deposit/withdraw)
36     /// @param _convexRewards The Convex Rewards contract (for claiming rewards)
37     constructor(
38         address _core,
39         address _curvePool,
40         address _convexBooster,
41         address _convexRewards
42     ) CoreRef(_core) {
43         convexBooster = IConvexBooster(_convexBooster);
44         convexRewards = IConvexBaseRewardPool(_convexRewards);
45         curvePool = ICurvePool(_curvePool);
46 
47         // cache some values for later gas optimizations
48         address feiAddress = address(fei());
49         bool foundFeiInPool = false;
50         uint256 feiFoundAtIndex = 0;
51         for (uint256 i = 0; i < N_COINS; i++) {
52             address tokenAddress = curvePool.coins(i);
53             if (tokenAddress == feiAddress) {
54                 foundFeiInPool = true;
55                 feiFoundAtIndex = i;
56             }
57         }
58         feiInPool = foundFeiInPool;
59         feiIndexInPool = feiFoundAtIndex;
60     }
61 
62     /// @notice Curve/Convex deposits report their balance in USD
63     function balanceReportedIn() public pure override returns (address) {
64         return Constants.USD;
65     }
66 
67     /// @notice deposit Curve LP tokens on Convex and stake deposit tokens in the
68     /// Convex rewards contract.
69     /// Note : this call is permissionless, and can be used if LP tokens are
70     /// transferred to this contract directly.
71     function deposit() public override whenNotPaused {
72         uint256 lpTokenBalance = curvePool.balanceOf(address(this));
73         uint256 poolId = convexRewards.pid();
74         curvePool.approve(address(convexBooster), lpTokenBalance);
75         convexBooster.deposit(poolId, lpTokenBalance, true);
76     }
77 
78     /// @notice unstake LP tokens from Convex Rewards, and withdraw Curve
79     /// LP tokens from Convex
80     function withdraw(address to, uint256 amountLpTokens) public override onlyPCVController whenNotPaused {
81         convexRewards.withdrawAndUnwrap(amountLpTokens, false);
82         curvePool.transfer(to, amountLpTokens);
83     }
84 
85     /// @notice claim CRV & CVX rewards earned by the LP tokens staked on this contract.
86     function claimRewards() public whenNotPaused {
87         convexRewards.getReward(address(this), true);
88     }
89 
90     /// @notice returns the balance in USD
91     function balance() public view override returns (uint256) {
92         uint256 lpTokensStaked = convexRewards.balanceOf(address(this));
93         uint256 virtualPrice = curvePool.get_virtual_price();
94         uint256 usdBalance = (lpTokensStaked * virtualPrice) / 1e18;
95 
96         // if FEI is in the pool, remove the FEI part of the liquidity, e.g. if
97         // FEI is filling 40% of the pool, reduce the balance by 40%.
98         if (feiInPool) {
99             uint256[N_COINS] memory balances;
100             uint256 totalBalances = 0;
101             for (uint256 i = 0; i < N_COINS; i++) {
102                 IERC20 poolToken = IERC20(curvePool.coins(i));
103                 balances[i] = poolToken.balanceOf(address(curvePool));
104                 totalBalances += balances[i];
105             }
106             usdBalance -= (usdBalance * balances[feiIndexInPool]) / totalBalances;
107         }
108 
109         return usdBalance;
110     }
111 
112     /// @notice returns the resistant balance in USD and FEI held by the contract
113     function resistantBalanceAndFei() public view override returns (uint256 resistantBalance, uint256 resistantFei) {
114         uint256 lpTokensStaked = convexRewards.balanceOf(address(this));
115         uint256 virtualPrice = curvePool.get_virtual_price();
116         resistantBalance = (lpTokensStaked * virtualPrice) / 1e18;
117 
118         // to have a resistant balance, we assume the pool is balanced, e.g. if
119         // the pool holds 3 tokens, we assume FEI is 33.3% of the pool.
120         if (feiInPool) {
121             resistantFei = resistantBalance / N_COINS;
122             resistantBalance -= resistantFei;
123         }
124 
125         return (resistantBalance, resistantFei);
126     }
127 }
