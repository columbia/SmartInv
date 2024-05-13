1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity 0.8.9;
3 
4 import "./ConvexStrategyBase.sol";
5 
6 /**
7  * This is the BkdEthCvx strategy, which is designed to be used by a Backd ETH Vault.
8  * The strategy holds ETH as it's underlying and allocates liquidity to Convex via given Curve Pool with 2 underlying tokens.
9  * Rewards received on Convex (CVX, CRV), are sold in part for the underlying.
10  * A share of earned CVX & CRV are retained on behalf of the Backd community to participate in governance.
11  */
12 contract BkdEthCvx is ConvexStrategyBase {
13     using ScaledMath for uint256;
14     using SafeERC20 for IERC20;
15     using EnumerableSet for EnumerableSet.AddressSet;
16     using AddressProviderHelpers for IAddressProvider;
17 
18     constructor(
19         address vault_,
20         address strategist_,
21         uint256 convexPid_,
22         address curvePool_,
23         uint256 curveIndex_,
24         IAddressProvider addressProvider_,
25         address strategySwapper_
26     )
27         ConvexStrategyBase(
28             vault_,
29             strategist_,
30             convexPid_,
31             curvePool_,
32             curveIndex_,
33             addressProvider_,
34             strategySwapper_
35         )
36     {
37         // Setting default values
38         imbalanceToleranceIn = 0.0007e18;
39         imbalanceToleranceOut = 0.0104e18;
40 
41         // Approvals
42         (address lp_, , , , , ) = _BOOSTER.poolInfo(convexPid_);
43         IERC20(lp_).safeApprove(address(_BOOSTER), type(uint256).max);
44     }
45 
46     receive() external payable {}
47 
48     function name() external pure override returns (string memory) {
49         return "BkdEthCvx";
50     }
51 
52     function balance() public view override returns (uint256) {
53         return _underlyingBalance() + _lpToUnderlying(_stakedBalance() + _lpBalance());
54     }
55 
56     function _deposit() internal override returns (bool) {
57         // Depositing into Curve Pool
58         uint256 underlyingBalance = _underlyingBalance();
59         if (underlyingBalance == 0) return false;
60         uint256[2] memory amounts;
61         amounts[curveIndex] = underlyingBalance;
62         curvePool.add_liquidity{value: underlyingBalance}(
63             amounts,
64             _minLpAccepted(underlyingBalance)
65         );
66 
67         // Depositing into Convex and Staking
68         if (!_BOOSTER.depositAll(convexPid, true)) return false;
69         return true;
70     }
71 
72     function _withdraw(uint256 amount) internal override returns (bool) {
73         uint256 underlyingBalance = _underlyingBalance();
74 
75         // Transferring from idle balance if enough
76         if (underlyingBalance >= amount) {
77             payable(vault).transfer(amount);
78             emit Withdraw(amount);
79             return true;
80         }
81 
82         // Unstaking needed LP Tokens from Convex
83         uint256 requiredUnderlyingAmount = amount - underlyingBalance;
84         uint256 maxLpBurned = _maxLpBurned(requiredUnderlyingAmount);
85         uint256 requiredLpAmount = maxLpBurned - _lpBalance();
86         if (!rewards.withdrawAndUnwrap(requiredLpAmount, false)) return false;
87 
88         // Removing needed liquidity from Curve
89         uint256[2] memory amounts;
90         // solhint-disable-next-line reentrancy
91         amounts[curveIndex] = requiredUnderlyingAmount;
92         curvePool.remove_liquidity_imbalance(amounts, maxLpBurned);
93         payable(vault).transfer(amount);
94         return true;
95     }
96 
97     function _withdrawAll() internal override returns (uint256) {
98         // Unstaking and withdrawing from Convex pool
99         uint256 stakedBalance = _stakedBalance();
100         if (stakedBalance > 0) {
101             if (!rewards.withdrawAndUnwrap(stakedBalance, false)) return 0;
102         }
103 
104         // Removing liquidity from Curve
105         uint256 lpBalance = _lpBalance();
106         if (lpBalance > 0) {
107             curvePool.remove_liquidity_one_coin(
108                 lpBalance,
109                 int128(uint128(curveIndex)),
110                 _minUnderlyingAccepted(lpBalance)
111             );
112         }
113 
114         // Transferring underlying to vault
115         uint256 underlyingBalance = _underlyingBalance();
116         if (underlyingBalance == 0) return 0;
117         payable(vault).transfer(underlyingBalance);
118         return underlyingBalance;
119     }
120 
121     function _underlyingBalance() internal view override returns (uint256) {
122         return address(this).balance;
123     }
124 
125     /**
126      * @notice Calculates the minimum LP to accept when depositing underlying into Curve Pool.
127      * @param _underlyingAmount Amount of underlying that is being deposited into Curve Pool.
128      * @return The minimum LP balance to accept.
129      */
130     function _minLpAccepted(uint256 _underlyingAmount) internal view returns (uint256) {
131         return _underlyingToLp(_underlyingAmount).scaledMul(ScaledMath.ONE - imbalanceToleranceIn);
132     }
133 
134     /**
135      * @notice Calculates the maximum LP to accept burning when withdrawing amount from Curve Pool.
136      * @param _underlyingAmount Amount of underlying that is being widthdrawn from Curve Pool.
137      * @return The maximum LP balance to accept burning.
138      */
139     function _maxLpBurned(uint256 _underlyingAmount) internal view returns (uint256) {
140         return _underlyingToLp(_underlyingAmount).scaledMul(ScaledMath.ONE + imbalanceToleranceOut);
141     }
142 
143     /**
144      * @notice Calculates the minimum underlying to accept when burning LP tokens to withdraw from Curve Pool.
145      * @param _lpAmount Amount of LP tokens being burned to withdraw from Curve Pool.
146      * @return The minimum underlying balance to accept.
147      */
148     function _minUnderlyingAccepted(uint256 _lpAmount) internal view returns (uint256) {
149         return _lpToUnderlying(_lpAmount).scaledMul(ScaledMath.ONE - imbalanceToleranceOut);
150     }
151 
152     /**
153      * @notice Converts an amount of underlying into their estimated LP value.
154      * @dev Uses get_virtual_price which is less suceptible to manipulation.
155      *  But is also less accurate to how much could be withdrawn.
156      * @param _underlyingAmount Amount of underlying to convert.
157      * @return The estimated value in the LP.
158      */
159     function _underlyingToLp(uint256 _underlyingAmount) internal view returns (uint256) {
160         return _underlyingAmount.scaledDiv(curvePool.get_virtual_price());
161     }
162 
163     /**
164      * @notice Converts an amount of LP into their estimated underlying value.
165      * @dev Uses get_virtual_price which is less suceptible to manipulation.
166      *  But is also less accurate to how much could be withdrawn.
167      * @param _lpAmount Amount of LP to convert.
168      * @return The estimated value in the underlying.
169      */
170     function _lpToUnderlying(uint256 _lpAmount) internal view returns (uint256) {
171         return _lpAmount.scaledMul(curvePool.get_virtual_price());
172     }
173 }
