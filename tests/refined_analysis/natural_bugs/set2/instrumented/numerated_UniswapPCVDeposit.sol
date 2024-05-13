1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.4;
3 
4 import "./IUniswapPCVDeposit.sol";
5 import "../../Constants.sol";
6 import "../PCVDeposit.sol";
7 import "../../refs/UniRef.sol";
8 import "@uniswap/v2-periphery/contracts/interfaces/IWETH.sol";
9 import "@uniswap/lib/contracts/libraries/Babylonian.sol";
10 import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
11 
12 /// @title implementation for Uniswap LP PCV Deposit.
13 /// Note: the FEI counterpart of tokens deposited have to be pre-minted on
14 /// this contract before deposit(), if it doesn't have the MINTER_ROLE role.
15 /// @author Fei Protocol
16 contract UniswapPCVDeposit is IUniswapPCVDeposit, PCVDeposit, UniRef {
17     using Decimal for Decimal.D256;
18     using Babylonian for uint256;
19 
20     /// @notice a slippage protection parameter, deposits revert when spot price is > this % from oracle
21     uint256 public override maxBasisPointsFromPegLP;
22 
23     /// @notice the Uniswap router contract
24     IUniswapV2Router02 public override router;
25 
26     /// @notice Uniswap PCV Deposit constructor
27     /// @param _core Fei Core for reference
28     /// @param _pair Uniswap Pair to deposit to
29     /// @param _router Uniswap Router
30     /// @param _oracle oracle for reference
31     /// @param _backupOracle the backup oracle to reference
32     /// @param _maxBasisPointsFromPegLP the max basis points of slippage from peg allowed on LP deposit
33     constructor(
34         address _core,
35         address _pair,
36         address _router,
37         address _oracle,
38         address _backupOracle,
39         uint256 _maxBasisPointsFromPegLP
40     ) UniRef(_core, _pair, _oracle, _backupOracle) {
41         router = IUniswapV2Router02(_router);
42 
43         _approveToken(address(fei()));
44         _approveToken(token);
45         _approveToken(_pair);
46 
47         maxBasisPointsFromPegLP = _maxBasisPointsFromPegLP;
48         emit MaxBasisPointsFromPegLPUpdate(0, _maxBasisPointsFromPegLP);
49     }
50 
51     receive() external payable {
52         _wrap();
53     }
54 
55     /// @notice deposit tokens into the PCV allocation
56     function deposit() external override whenNotPaused {
57         updateOracle();
58 
59         // Calculate amounts to provide liquidity
60         uint256 tokenAmount = IERC20(token).balanceOf(address(this));
61         uint256 feiAmount = readOracle().mul(tokenAmount).asUint256();
62 
63         _addLiquidity(tokenAmount, feiAmount);
64 
65         _burnFeiHeld(); // burn any FEI dust from LP
66 
67         emit Deposit(msg.sender, tokenAmount);
68     }
69 
70     /// @notice withdraw tokens from the PCV allocation
71     /// @param amountUnderlying of tokens withdrawn
72     /// @param to the address to send PCV to
73     /// @dev has rounding errors on amount to withdraw, can differ from the input "amountUnderlying"
74     function withdraw(address to, uint256 amountUnderlying) external override onlyPCVController whenNotPaused {
75         uint256 totalUnderlying = balance();
76         require(amountUnderlying <= totalUnderlying, "UniswapPCVDeposit: Insufficient underlying");
77 
78         uint256 totalLiquidity = liquidityOwned();
79 
80         // ratio of LP tokens needed to get out the desired amount
81         Decimal.D256 memory ratioToWithdraw = Decimal.ratio(amountUnderlying, totalUnderlying);
82 
83         // amount of LP tokens to withdraw factoring in ratio
84         uint256 liquidityToWithdraw = ratioToWithdraw.mul(totalLiquidity).asUint256();
85 
86         // Withdraw liquidity from the pair and send to target
87         uint256 amountWithdrawn = _removeLiquidity(liquidityToWithdraw);
88         SafeERC20.safeTransfer(IERC20(token), to, amountWithdrawn);
89 
90         _burnFeiHeld(); // burn remaining FEI
91 
92         emit Withdrawal(msg.sender, to, amountWithdrawn);
93     }
94 
95     /// @notice sets the new slippage parameter for depositing liquidity
96     /// @param _maxBasisPointsFromPegLP the new distance in basis points (1/10000) from peg beyond which a liquidity provision will fail
97     function setMaxBasisPointsFromPegLP(uint256 _maxBasisPointsFromPegLP) public override onlyGovernorOrAdmin {
98         require(
99             _maxBasisPointsFromPegLP <= Constants.BASIS_POINTS_GRANULARITY,
100             "UniswapPCVDeposit: basis points from peg too high"
101         );
102 
103         uint256 oldMaxBasisPointsFromPegLP = maxBasisPointsFromPegLP;
104         maxBasisPointsFromPegLP = _maxBasisPointsFromPegLP;
105 
106         emit MaxBasisPointsFromPegLPUpdate(oldMaxBasisPointsFromPegLP, _maxBasisPointsFromPegLP);
107     }
108 
109     /// @notice set the new pair contract
110     /// @param _pair the new pair
111     /// @dev also approves the router for the new pair token and underlying token
112     function setPair(address _pair) public virtual override onlyGovernor {
113         _setupPair(_pair);
114 
115         _approveToken(token);
116         _approveToken(_pair);
117     }
118 
119     /// @notice returns total balance of PCV in the Deposit excluding the FEI
120     function balance() public view override returns (uint256) {
121         (, uint256 tokenReserves) = getReserves();
122         return _ratioOwned().mul(tokenReserves).asUint256();
123     }
124 
125     /// @notice display the related token of the balance reported
126     function balanceReportedIn() public view override returns (address) {
127         return token;
128     }
129 
130     /**
131         @notice get the manipulation resistant Other(example ETH) and FEI in the Uniswap pool
132         @return number of other token in pool
133         @return number of FEI in pool
134 
135         Derivation rETH, rFEI = resistant (ideal) ETH and FEI reserves, P = price of ETH in FEI:
136         1. rETH * rFEI = k
137         2. rETH = k / rFEI
138         3. rETH = (k * rETH) / (rFEI * rETH)
139         4. rETH ^ 2 = k / P
140         5. rETH = sqrt(k / P)
141 
142         and rFEI = k / rETH by 1.
143 
144         Finally scale the resistant reserves by the ratio owned by the contract
145      */
146     function resistantBalanceAndFei() public view override returns (uint256, uint256) {
147         (uint256 feiInPool, uint256 otherInPool) = getReserves();
148 
149         Decimal.D256 memory priceOfToken = readOracle();
150 
151         uint256 k = feiInPool * otherInPool;
152 
153         // resistant other/fei in pool
154         uint256 resistantOtherInPool = Decimal.one().div(priceOfToken).mul(k).asUint256().sqrt();
155 
156         uint256 resistantFeiInPool = Decimal.ratio(k, resistantOtherInPool).asUint256();
157 
158         Decimal.D256 memory ratioOwned = _ratioOwned();
159         return (ratioOwned.mul(resistantOtherInPool).asUint256(), ratioOwned.mul(resistantFeiInPool).asUint256());
160     }
161 
162     /// @notice amount of pair liquidity owned by this contract
163     /// @return amount of LP tokens
164     function liquidityOwned() public view virtual override returns (uint256) {
165         return pair.balanceOf(address(this));
166     }
167 
168     function _removeLiquidity(uint256 liquidity) internal virtual returns (uint256) {
169         uint256 endOfTime = type(uint256).max;
170         // No restrictions on withdrawal price
171         (, uint256 amountWithdrawn) = router.removeLiquidity(
172             address(fei()),
173             token,
174             liquidity,
175             0,
176             0,
177             address(this),
178             endOfTime
179         );
180         return amountWithdrawn;
181     }
182 
183     function _addLiquidity(uint256 tokenAmount, uint256 feiAmount) internal virtual {
184         if (core().isMinter(address(this))) {
185             _mintFei(address(this), feiAmount);
186         }
187 
188         uint256 endOfTime = type(uint256).max;
189         // Deposit price gated by slippage parameter
190         router.addLiquidity(
191             address(fei()),
192             token,
193             feiAmount,
194             tokenAmount,
195             _getMinLiquidity(feiAmount),
196             _getMinLiquidity(tokenAmount),
197             address(this),
198             endOfTime
199         );
200     }
201 
202     /// @notice used as slippage protection when adding liquidity to the pool
203     function _getMinLiquidity(uint256 amount) internal view returns (uint256) {
204         return
205             (amount * (Constants.BASIS_POINTS_GRANULARITY - maxBasisPointsFromPegLP)) /
206             Constants.BASIS_POINTS_GRANULARITY;
207     }
208 
209     /// @notice ratio of all pair liquidity owned by this contract
210     function _ratioOwned() internal view returns (Decimal.D256 memory) {
211         uint256 liquidity = liquidityOwned();
212         uint256 total = pair.totalSupply();
213         return Decimal.ratio(liquidity, total);
214     }
215 
216     /// @notice approves a token for the router
217     function _approveToken(address _token) internal {
218         uint256 maxTokens = type(uint256).max;
219         IERC20(_token).approve(address(router), maxTokens);
220     }
221 
222     // Wrap all held ETH
223     function _wrap() internal {
224         uint256 amount = address(this).balance;
225         IWETH(router.WETH()).deposit{value: amount}();
226     }
227 }
