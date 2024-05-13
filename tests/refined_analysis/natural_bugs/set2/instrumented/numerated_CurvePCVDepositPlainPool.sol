1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.4;
3 
4 import "../../Constants.sol";
5 import "../PCVDeposit.sol";
6 import "./ICurveStableSwap3.sol";
7 
8 /// @title CurvePCVDepositPlainPool: implementation for a PCVDeposit that deploys
9 /// liquidity on Curve, in a plain pool (3 stable assets).
10 /// @author Fei Protocol
11 contract CurvePCVDepositPlainPool is PCVDeposit {
12     // ------------------ Properties -------------------------------------------
13 
14     /// @notice maximum slippage accepted during deposit / withdraw, expressed
15     /// in basis points (100% = 10_000).
16     uint256 public maxSlippageBasisPoints;
17 
18     /// @notice The Curve pool to deposit in
19     ICurveStableSwap3 public curvePool;
20 
21     /// @notice number of coins in the Curve pool
22     uint256 private constant N_COINS = 3;
23     /// @notice boolean to know if FEI is in the pool
24     bool private immutable feiInPool;
25     /// @notice FEI index in the pool. If FEI is not present, value = 0.
26     uint256 private immutable feiIndexInPool;
27 
28     // ------------------ Constructor ------------------------------------------
29 
30     /// @notice CurvePCVDepositPlainPool constructor
31     /// @param _core Fei Core for reference
32     /// @param _curvePool The Curve pool to deposit in
33     /// @param _maxSlippageBasisPoints max slippage for deposits, in bp
34     constructor(
35         address _core,
36         address _curvePool,
37         uint256 _maxSlippageBasisPoints
38     ) CoreRef(_core) {
39         curvePool = ICurveStableSwap3(_curvePool);
40         maxSlippageBasisPoints = _maxSlippageBasisPoints;
41 
42         // cache some values for later gas optimizations
43         address feiAddress = address(fei());
44         bool foundFeiInPool = false;
45         uint256 feiFoundAtIndex = 0;
46         for (uint256 i = 0; i < N_COINS; i++) {
47             address tokenAddress = ICurvePool(_curvePool).coins(i);
48             if (tokenAddress == feiAddress) {
49                 foundFeiInPool = true;
50                 feiFoundAtIndex = i;
51             }
52         }
53         feiInPool = foundFeiInPool;
54         feiIndexInPool = feiFoundAtIndex;
55     }
56 
57     /// @notice Curve/Convex deposits report their balance in USD
58     function balanceReportedIn() public pure override returns (address) {
59         return Constants.USD;
60     }
61 
62     /// @notice deposit tokens into the Curve pool, then stake the LP tokens
63     /// on Convex to earn rewards.
64     function deposit() public override whenNotPaused {
65         // fetch current balances
66         uint256[N_COINS] memory balances;
67         IERC20[N_COINS] memory tokens;
68         uint256 totalBalances = 0;
69         for (uint256 i = 0; i < N_COINS; i++) {
70             tokens[i] = IERC20(curvePool.coins(i));
71             balances[i] = tokens[i].balanceOf(address(this));
72             totalBalances += balances[i];
73         }
74 
75         // require non-empty deposit
76         require(totalBalances > 0, "CurvePCVDepositPlainPool: cannot deposit 0");
77 
78         // set maximum allowed slippage
79         uint256 virtualPrice = curvePool.get_virtual_price();
80         uint256 minLpOut = (totalBalances * 1e18) / virtualPrice;
81         uint256 lpSlippageAccepted = (minLpOut * maxSlippageBasisPoints) / Constants.BASIS_POINTS_GRANULARITY;
82         minLpOut -= lpSlippageAccepted;
83 
84         // approval
85         for (uint256 i = 0; i < N_COINS; i++) {
86             // approve for deposit
87             if (balances[i] > 0) {
88                 tokens[i].approve(address(curvePool), balances[i]);
89             }
90         }
91 
92         // deposit in the Curve pool
93         curvePool.add_liquidity(balances, minLpOut);
94     }
95 
96     /// @notice Exit the Curve pool by removing liquidity in one token.
97     /// If FEI is in the pool, pull FEI out of the pool. If FEI is not in the pool,
98     /// exit in the first token of the pool. To exit without chosing a specific
99     /// token, and minimize slippage, use exitPool().
100     function withdraw(address to, uint256 amountUnderlying) public override onlyPCVController whenNotPaused {
101         withdrawOneCoin(feiIndexInPool, to, amountUnderlying);
102     }
103 
104     /// @notice Exit the Curve pool by removing liquidity in one token.
105     /// Note that this method can cause slippage. To exit without slippage, use
106     /// the exitPool() method.
107     function withdrawOneCoin(
108         uint256 coinIndexInPool,
109         address to,
110         uint256 amountUnderlying
111     ) public onlyPCVController whenNotPaused {
112         // burn LP tokens to get one token out
113         uint256 virtualPrice = curvePool.get_virtual_price();
114         uint256 maxLpUsed = (amountUnderlying * 1e18) / virtualPrice;
115         uint256 lpSlippageAccepted = (maxLpUsed * maxSlippageBasisPoints) / Constants.BASIS_POINTS_GRANULARITY;
116         maxLpUsed += lpSlippageAccepted;
117         curvePool.remove_liquidity_one_coin(maxLpUsed, int128(int256(coinIndexInPool)), amountUnderlying);
118 
119         // send token to destination
120         IERC20(curvePool.coins(coinIndexInPool)).transfer(to, amountUnderlying);
121     }
122 
123     /// @notice Exit the Curve pool by removing liquidity. The contract
124     /// will hold tokens in proportion to what was in the Curve pool at the time
125     /// of exit, i.e. if the pool is 20% FRAX 60% FEI 20% alUSD, and the contract
126     /// has 10M$ of liquidity, it will exit the pool with 2M FRAX, 6M FEI, 2M alUSD.
127     function exitPool() public onlyPCVController whenNotPaused {
128         // burn all LP tokens to exit pool
129         uint256 lpTokenBalance = curvePool.balanceOf(address(this));
130         uint256[N_COINS] memory minAmountsOuts;
131         curvePool.remove_liquidity(lpTokenBalance, minAmountsOuts);
132     }
133 
134     /// @notice returns the balance in USD
135     function balance() public view override returns (uint256) {
136         uint256 lpTokens = curvePool.balanceOf(address(this));
137         uint256 virtualPrice = curvePool.get_virtual_price();
138         uint256 usdBalance = (lpTokens * virtualPrice) / 1e18;
139 
140         // if FEI is in the pool, remove the FEI part of the liquidity, e.g. if
141         // FEI is filling 40% of the pool, reduce the balance by 40%.
142         if (feiInPool) {
143             uint256[N_COINS] memory balances;
144             uint256 totalBalances = 0;
145             for (uint256 i = 0; i < N_COINS; i++) {
146                 IERC20 poolToken = IERC20(curvePool.coins(i));
147                 balances[i] = poolToken.balanceOf(address(curvePool));
148                 totalBalances += balances[i];
149             }
150             usdBalance -= (usdBalance * balances[feiIndexInPool]) / totalBalances;
151         }
152 
153         return usdBalance;
154     }
155 
156     /// @notice returns the resistant balance in USD and FEI held by the contract
157     function resistantBalanceAndFei() public view override returns (uint256 resistantBalance, uint256 resistantFei) {
158         uint256 lpTokens = curvePool.balanceOf(address(this));
159         uint256 virtualPrice = curvePool.get_virtual_price();
160         resistantBalance = (lpTokens * virtualPrice) / 1e18;
161 
162         // to have a resistant balance, we assume the pool is balanced, e.g. if
163         // the pool holds 3 tokens, we assume FEI is 33.3% of the pool.
164         if (feiInPool) {
165             resistantFei = resistantBalance / N_COINS;
166             resistantBalance -= resistantFei;
167         }
168 
169         return (resistantBalance, resistantFei);
170     }
171 }
