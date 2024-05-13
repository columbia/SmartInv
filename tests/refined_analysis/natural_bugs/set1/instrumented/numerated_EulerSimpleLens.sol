1 // SPDX-License-Identifier: GPL-2.0-or-later
2 
3 pragma solidity ^0.8.0;
4 
5 import "../Euler.sol";
6 import "../modules/EToken.sol";
7 import "../modules/Markets.sol";
8 import "../modules/Exec.sol";
9 import "../BaseIRMLinearKink.sol";
10 import "../IRiskManager.sol";
11 import "../Storage.sol";
12 
13 interface IExec {
14     function getPriceFull(address underlying) external view returns (uint twap, uint twapPeriod, uint currPrice);
15     function liquidity(address account) external view returns (IRiskManager.LiquidityStatus memory status);
16 }
17 
18 contract EulerSimpleLens is Constants {
19 
20     bytes32 immutable public moduleGitCommit;
21     Euler immutable public euler;
22     Markets immutable public markets;
23     Exec immutable public exec;
24 
25     struct ResponseIRM {
26         uint kink;
27 
28         uint baseAPY;
29         uint kinkAPY;
30         uint maxAPY;
31 
32         uint baseSupplyAPY;
33         uint kinkSupplyAPY;
34         uint maxSupplyAPY;
35     }
36     
37     constructor(bytes32 moduleGitCommit_, address euler_) {
38         moduleGitCommit = moduleGitCommit_;
39 
40         euler = Euler(euler_);
41         markets = Markets(euler.moduleIdToProxy(MODULEID__MARKETS));
42         exec = Exec(euler.moduleIdToProxy(MODULEID__EXEC));
43     }
44 
45     // underlying -> etoken
46     function underlyingToEToken(address underlying) public view returns (address eToken) {
47         eToken = markets.underlyingToEToken(underlying);
48     }
49 
50     // underlying -> dtoken
51     function underlyingToDToken(address underlying) public view returns (address dToken) {
52         dToken = markets.underlyingToDToken(underlying);
53     }
54 
55     // underlying -> ptoken
56     function underlyingToPToken(address underlying) public view returns (address pToken) {
57         pToken = markets.underlyingToPToken(underlying);
58     }
59 
60     // underlying -> etoken, dtoken and ptoken
61     function underlyingToInternalTokens(address underlying) public view returns (address eToken, address dToken, address pToken) {
62         eToken = underlyingToEToken(underlying);
63         dToken = underlyingToDToken(underlying);
64         pToken = underlyingToPToken(underlying);
65     }
66 
67     // underlying -> asset configs
68     function underlyingToAssetConfig(address underlying) external view returns (Storage.AssetConfig memory config) {
69         config = markets.underlyingToAssetConfig(underlying);
70     }
71 
72     // underlying -> interest rate model
73     function interestRateModel(address underlying) external view returns (uint) {
74         return markets.interestRateModel(underlying);
75     }
76 
77     // underlying -> interest rate
78     function interestRates(address underlying) external view returns (uint borrowSPY, uint borrowAPY, uint supplyAPY) {
79         borrowSPY = uint(int(markets.interestRate(underlying)));
80         ( , uint totalBalances, uint totalBorrows, ) = getTotalSupplyAndDebts(underlying);
81         (borrowAPY, supplyAPY) = computeAPYs(borrowSPY, totalBorrows, totalBalances, reserveFee(underlying));
82     }
83 
84     // underlying -> interest accumulator
85     function interestAccumulator(address underlying) external view returns (uint) {
86         return markets.interestAccumulator(underlying);
87     }
88 
89     // underlying -> reserve fee
90     function reserveFee(address underlying) public view returns (uint32) {
91         return markets.reserveFee(underlying);
92     }
93 
94     // underlying -> pricing configs
95     function getPricingConfig(address underlying) external view returns (uint16 pricingType, uint32 pricingParameters, address pricingForwarded) {
96         (pricingType, pricingParameters, pricingForwarded) = markets.getPricingConfig(underlying);
97     }
98 
99     // entered markets
100     function getEnteredMarkets(address account) external view returns (address[] memory) {
101         return markets.getEnteredMarkets(account);
102     }
103 
104     // liability, collateral, health score
105     function getAccountStatus(address account) external view returns (uint collateralValue, uint liabilityValue, uint healthScore) {
106         IExec _exec = IExec(address(exec));
107         IRiskManager.LiquidityStatus memory status = _exec.liquidity(account);
108 
109         collateralValue = status.collateralValue;
110         liabilityValue = status.liabilityValue;
111 
112         healthScore = liabilityValue == 0? type(uint256).max : collateralValue * 1e18 / liabilityValue;
113     } 
114 
115     // prices
116     function getPriceFull(address underlying) external view returns (uint twap, uint twapPeriod, uint currPrice) {
117         IExec _exec = IExec(address(exec));
118         (twap, twapPeriod, currPrice) = _exec.getPriceFull(underlying);
119     }
120 
121     // Balance of an account's wrapped tokens
122     function getPTokenBalance(address underlying, address account) external view returns (uint256) {
123         address pTokenAddr = underlyingToPToken(underlying); 
124         return IERC20(pTokenAddr).balanceOf(account);
125     }
126 
127     // Debt owed by a particular account, in underlying units
128     function getDTokenBalance(address underlying, address account) external view returns (uint256) {
129         address dTokenAddr = underlyingToDToken(underlying);
130         return IERC20(dTokenAddr).balanceOf(account);
131     }
132 
133     // Balance of a particular account, in underlying units (increases as interest is earned)
134     function getETokenBalance(address underlying, address account) external view returns (uint256) {
135         address eTokenAddr = underlyingToEToken(underlying);
136         return EToken(eTokenAddr).balanceOfUnderlying(account);
137     }
138 
139     // approvals
140     function getEulerAccountAllowance(address underlying, address account) external view returns (uint256) {
141         return IERC20(underlying).allowance(account, address(euler));
142     }
143 
144     // total supply, total debts
145     function getTotalSupplyAndDebts(address underlying) public view returns (uint poolSize, uint totalBalances, uint totalBorrows, uint reserveBalance) {
146         poolSize = IERC20(underlying).balanceOf(address(euler));
147         (address eTokenAddr, address dTokenAddr, ) = underlyingToInternalTokens(underlying);
148         totalBalances = EToken(eTokenAddr).totalSupplyUnderlying();
149         totalBorrows = IERC20(dTokenAddr).totalSupply();
150         reserveBalance = EToken(eTokenAddr).reserveBalanceUnderlying();
151     }
152 
153     // token name and symbol
154     function getTokenInfo(address underlying) external view returns (string memory name, string memory symbol) {
155         name = getStringOrBytes32(underlying, IERC20.name.selector);
156         symbol = getStringOrBytes32(underlying, IERC20.symbol.selector);
157     }
158 
159     // For tokens like MKR which return bytes32 on name() or symbol()
160     function getStringOrBytes32(address contractAddress, bytes4 selector) private view returns (string memory) {
161         (bool success, bytes memory result) = contractAddress.staticcall(abi.encodeWithSelector(selector));
162         if (!success || result.length < 32) return "";
163 
164         return result.length == 32 ? string(abi.encodePacked(result)) : abi.decode(result, (string));
165     }
166 
167     // interest rates as APYs
168     function irmSettings(address underlying) external view returns (ResponseIRM memory r) {
169         uint moduleId = markets.interestRateModel(underlying);
170         address moduleImpl = euler.moduleIdToImplementation(moduleId);
171 
172         BaseIRMLinearKink irm = BaseIRMLinearKink(moduleImpl);
173 
174         uint kink = r.kink = irm.kink();
175         uint32 _reserveFee = reserveFee(underlying);
176 
177         uint baseSPY = irm.baseRate();
178         uint kinkSPY = baseSPY + (kink * irm.slope1());
179         uint maxSPY = kinkSPY + ((type(uint32).max - kink) * irm.slope2());
180 
181         (r.baseAPY, r.baseSupplyAPY) = computeAPYs(baseSPY, 0, type(uint32).max, _reserveFee);
182         (r.kinkAPY, r.kinkSupplyAPY) = computeAPYs(kinkSPY, kink, type(uint32).max, _reserveFee);
183         (r.maxAPY, r.maxSupplyAPY) = computeAPYs(maxSPY, type(uint32).max, type(uint32).max, _reserveFee);
184     }
185 
186     // compute APYs
187     function computeAPYs(uint borrowSPY, uint totalBorrows, uint totalBalancesUnderlying, uint32 _reserveFee) private pure returns (uint borrowAPY, uint supplyAPY) {
188         borrowAPY = RPow.rpow(borrowSPY + 1e27, SECONDS_PER_YEAR, 10**27) - 1e27;
189 
190         uint supplySPY = totalBalancesUnderlying == 0 ? 0 : borrowSPY * totalBorrows / totalBalancesUnderlying;
191         supplySPY = supplySPY * (RESERVE_FEE_SCALE - _reserveFee) / RESERVE_FEE_SCALE;
192         supplyAPY = RPow.rpow(supplySPY + 1e27, SECONDS_PER_YEAR, 10**27) - 1e27;
193     }
194 
195 }
196 
