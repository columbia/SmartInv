1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.4;
3 pragma experimental ABIEncoderV2;
4 
5 import "../PCVDeposit.sol";
6 import "../../Constants.sol";
7 import "../../refs/CoreRef.sol";
8 import "../../refs/OracleRef.sol";
9 import "../../core/TribeRoles.sol";
10 import "../../external/Decimal.sol";
11 import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
12 import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
13 import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
14 
15 // stETH Token contract specific functions
16 interface ILido {
17     function getTotalShares() external view returns (uint256);
18 
19     function getTotalPooledEther() external view returns (uint256);
20 
21     function sharesOf(address _account) external view returns (uint256);
22 
23     function getSharesByPooledEth(uint256 _ethAmount) external view returns (uint256);
24 
25     function getPooledEthByShares(uint256 _sharesAmount) external view returns (uint256);
26 
27     function getFee() external view returns (uint256);
28 
29     function increaseAllowance(address _spender, uint256 _addedValue) external returns (bool);
30 
31     function decreaseAllowance(address _spender, uint256 _subtractedValue) external returns (bool);
32 
33     function submit(address referral) external payable returns (uint256);
34 }
35 
36 // Curve stETH-ETH pool
37 interface IStableSwapSTETH {
38     function exchange(
39         int128 i,
40         int128 j,
41         uint256 dx,
42         uint256 min_dy
43     ) external payable returns (uint256);
44 
45     function get_dy(
46         int128 i,
47         int128 j,
48         uint256 dx
49     ) external view returns (uint256);
50 
51     function coins(uint256 arg0) external view returns (address);
52 }
53 
54 /// @title implementation for PCV Deposit that can take ETH and get stETH either
55 /// by staking on Lido or swapping on Curve, and sell back stETH for ETH on Curve.
56 /// @author eswak, realisation
57 contract EthLidoPCVDeposit is PCVDeposit, OracleRef {
58     using SafeERC20 for ERC20;
59     using Decimal for Decimal.D256;
60 
61     // ----------- Events ---------------
62     event UpdateMaximumSlippage(uint256 maximumSlippageBasisPoints);
63 
64     // ----------- Properties -----------
65     // References to external contracts
66     address public immutable steth;
67     address public immutable stableswap;
68 
69     // Maximum tolerated slippage
70     uint256 public maximumSlippageBasisPoints;
71 
72     struct OracleData {
73         address _oracle;
74         address _backupOracle;
75         bool _invertOraclePrice;
76         int256 _decimalsNormalizer;
77     }
78 
79     constructor(
80         address _core,
81         OracleData memory oracleData,
82         address _steth,
83         address _stableswap,
84         uint256 _maximumSlippageBasisPoints
85     )
86         OracleRef(
87             _core,
88             oracleData._oracle,
89             oracleData._backupOracle,
90             oracleData._decimalsNormalizer,
91             oracleData._invertOraclePrice
92         )
93     {
94         steth = _steth;
95         stableswap = _stableswap;
96         maximumSlippageBasisPoints = _maximumSlippageBasisPoints;
97     }
98 
99     // Empty callback on ETH reception
100     receive() external payable {}
101 
102     // =======================================================================
103     // IPCVDeposit interface override
104     // =======================================================================
105     /// @notice deposit ETH held by the contract to get stETH.
106     /// @dev everyone can call deposit(), it is not protected by PCVController
107     /// rights, because all ETH held by the contract is destined to be
108     /// changed to stETH anyway.
109     function deposit() external override whenNotPaused {
110         uint256 amountIn = address(this).balance;
111         require(amountIn > 0, "EthLidoPCVDeposit: cannot deposit 0.");
112 
113         // Get the expected amount of stETH out of a Curve trade
114         // (single trade with all the held ETH)
115         address _tokenOne = IStableSwapSTETH(stableswap).coins(0);
116         uint256 expectedAmountOut = IStableSwapSTETH(stableswap).get_dy(
117             _tokenOne == steth ? int128(1) : int128(0),
118             _tokenOne == steth ? int128(0) : int128(1),
119             amountIn
120         );
121 
122         // If we get more stETH out than ETH in by swapping on Curve,
123         // get the stETH by doing a Curve swap.
124         uint256 actualAmountOut;
125         uint256 balanceBefore = IERC20(steth).balanceOf(address(this));
126         if (expectedAmountOut > amountIn) {
127             uint256 minimumAmountOut = amountIn;
128 
129             // Allowance to trade stETH on the Curve pool
130             IERC20(steth).approve(stableswap, amountIn);
131 
132             // Perform swap
133             actualAmountOut = IStableSwapSTETH(stableswap).exchange{value: amountIn}(
134                 _tokenOne == steth ? int128(1) : int128(0),
135                 _tokenOne == steth ? int128(0) : int128(1),
136                 amountIn,
137                 minimumAmountOut
138             );
139         }
140         // Otherwise, stake ETH for stETH directly on the Lido contract
141         // to get a 1:1 trade.
142         else {
143             ILido(steth).submit{value: amountIn}(address(0));
144             actualAmountOut = amountIn;
145         }
146 
147         // Check the received amount
148         uint256 balanceAfter = IERC20(steth).balanceOf(address(this));
149         uint256 amountReceived = balanceAfter - balanceBefore;
150         // @dev: check is not made on "actualAmountOut" directly, because sometimes
151         // there are float rounding error, and we get a few wei less. Additionally,
152         // the stableswap could return the uint256 amountOut but never transfer tokens.
153         Decimal.D256 memory maxSlippage = Decimal.ratio(
154             Constants.BASIS_POINTS_GRANULARITY - maximumSlippageBasisPoints,
155             Constants.BASIS_POINTS_GRANULARITY
156         );
157         uint256 minimumAcceptedAmountOut = maxSlippage.mul(amountIn).asUint256();
158         require(amountReceived >= minimumAcceptedAmountOut, "EthLidoPCVDeposit: not enough stETH received.");
159 
160         emit Deposit(msg.sender, actualAmountOut);
161     }
162 
163     /// @notice withdraw stETH held by the contract to get ETH.
164     /// This function with swap stETH held by the contract to ETH, and transfer
165     /// it to the target address. Note: the withdraw could
166     /// revert if the Curve pool is imbalanced with too many stETH and the amount
167     /// of ETH out of the trade is less than the tolerated slippage.
168     /// @param to the destination of the withdrawn ETH
169     /// @param amountIn the number of stETH to withdraw.
170     function withdraw(address to, uint256 amountIn) external override onlyPCVController whenNotPaused {
171         require(balance() >= amountIn, "EthLidoPCVDeposit: not enough stETH.");
172 
173         // Compute the minimum accepted amount of ETH out of the trade, based
174         // on the slippage settings.
175         uint256 minimumAcceptedAmountOut = readOracle()
176             .mul(Constants.BASIS_POINTS_GRANULARITY - maximumSlippageBasisPoints)
177             .div(Constants.BASIS_POINTS_GRANULARITY)
178             .mul(amountIn)
179             .asUint256();
180 
181         // Swap stETH for ETH on the Curve pool
182         uint256 balanceBefore = address(this).balance;
183         address _tokenOne = IStableSwapSTETH(stableswap).coins(0);
184         IERC20(steth).approve(stableswap, amountIn);
185         uint256 actualAmountOut = IStableSwapSTETH(stableswap).exchange(
186             _tokenOne == steth ? int128(0) : int128(1),
187             _tokenOne == steth ? int128(1) : int128(0),
188             amountIn,
189             minimumAcceptedAmountOut
190         );
191 
192         // Check the received amount
193         uint256 balanceAfter = address(this).balance;
194         uint256 amountReceived = balanceAfter - balanceBefore;
195         require(amountReceived >= minimumAcceptedAmountOut, "EthLidoPCVDeposit: not enough ETH received.");
196 
197         // Transfer ETH to destination.
198         Address.sendValue(payable(to), actualAmountOut);
199 
200         emit Withdrawal(msg.sender, to, actualAmountOut);
201     }
202 
203     /// @notice Returns the current balance of stETH held by the contract
204     function balance() public view override returns (uint256 amount) {
205         return IERC20(steth).balanceOf(address(this));
206     }
207 
208     // =======================================================================
209     // Functions specific to EthLidoPCVDeposit
210     // =======================================================================
211     /// @notice Sets the maximum slippage vs 1:1 price accepted during withdraw.
212     /// @param _maximumSlippageBasisPoints the maximum slippage expressed in basis points (1/10_000)
213     function setMaximumSlippage(uint256 _maximumSlippageBasisPoints)
214         external
215         onlyTribeRole(TribeRoles.PCV_MINOR_PARAM_ROLE)
216     {
217         require(
218             _maximumSlippageBasisPoints <= Constants.BASIS_POINTS_GRANULARITY,
219             "EthLidoPCVDeposit: Exceeds bp granularity."
220         );
221         maximumSlippageBasisPoints = _maximumSlippageBasisPoints;
222         emit UpdateMaximumSlippage(_maximumSlippageBasisPoints);
223     }
224 
225     /// @notice display the related token of the balance reported
226     function balanceReportedIn() public pure override returns (address) {
227         return address(Constants.WETH);
228     }
229 }
