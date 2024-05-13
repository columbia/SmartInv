1 // SPDX-License-Identifier: GPL-2.0-or-later
2 
3 pragma solidity ^0.8.0;
4 
5 import "../Euler.sol";
6 import "../Storage.sol";
7 import "../modules/EToken.sol";
8 import "../modules/Markets.sol";
9 import "../BaseIRMLinearKink.sol";
10 import "../vendor/RPow.sol";
11 
12 interface IExec {
13     function getPriceFull(address underlying) external view returns (uint twap, uint twapPeriod, uint currPrice);
14     function getPrice(address underlying) external view returns (uint twap, uint twapPeriod);
15     function detailedLiquidity(address account) external view returns (IRiskManager.AssetLiquidity[] memory assets);
16     function liquidity(address account) external view returns (IRiskManager.LiquidityStatus memory status);
17 }
18 
19 contract EulerGeneralView is Constants {
20     bytes32 immutable public moduleGitCommit;
21 
22     constructor(bytes32 moduleGitCommit_) {
23         moduleGitCommit = moduleGitCommit_;
24     }
25 
26     // Query
27 
28     struct Query {
29         address eulerContract;
30 
31         address account;
32         address[] markets;
33     }
34 
35     // Response
36 
37     struct ResponseMarket {
38         // Universal
39 
40         address underlying;
41         string name;
42         string symbol;
43         uint8 decimals;
44 
45         address eTokenAddr;
46         address dTokenAddr;
47         address pTokenAddr;
48 
49         Storage.AssetConfig config;
50 
51         uint poolSize;
52         uint totalBalances;
53         uint totalBorrows;
54         uint reserveBalance;
55 
56         uint32 reserveFee;
57         uint borrowAPY;
58         uint supplyAPY;
59 
60         // Pricing
61 
62         uint twap;
63         uint twapPeriod;
64         uint currPrice;
65         uint16 pricingType;
66         uint32 pricingParameters;
67         address pricingForwarded;
68 
69         // Account specific
70 
71         uint underlyingBalance;
72         uint eulerAllowance;
73         uint eTokenBalance;
74         uint eTokenBalanceUnderlying;
75         uint dTokenBalance;
76         IRiskManager.LiquidityStatus liquidityStatus;
77     }
78 
79     struct Response {
80         uint timestamp;
81         uint blockNumber;
82 
83         ResponseMarket[] markets;
84         address[] enteredMarkets;
85     }
86 
87 
88 
89     // Implementation
90 
91     function doQueryBatch(Query[] memory qs) external view returns (Response[] memory r) {
92         r = new Response[](qs.length);
93 
94         for (uint i = 0; i < qs.length; ++i) {
95             r[i] = doQuery(qs[i]);
96         }
97     }
98 
99     function doQuery(Query memory q) public view returns (Response memory r) {
100         r.timestamp = block.timestamp;
101         r.blockNumber = block.number;
102 
103         Euler eulerProxy = Euler(q.eulerContract);
104 
105         Markets marketsProxy = Markets(eulerProxy.moduleIdToProxy(MODULEID__MARKETS));
106         IExec execProxy = IExec(eulerProxy.moduleIdToProxy(MODULEID__EXEC));
107 
108         IRiskManager.AssetLiquidity[] memory liqs;
109 
110         if (q.account != address(0)) {
111             liqs = execProxy.detailedLiquidity(q.account);
112         }
113 
114         r.markets = new ResponseMarket[](liqs.length + q.markets.length);
115 
116         for (uint i = 0; i < liqs.length; ++i) {
117             ResponseMarket memory m = r.markets[i];
118 
119             m.underlying = liqs[i].underlying;
120             m.liquidityStatus = liqs[i].status;
121 
122             populateResponseMarket(q, m, marketsProxy, execProxy);
123         }
124 
125         for (uint j = liqs.length; j < liqs.length + q.markets.length; ++j) {
126             uint i = j - liqs.length;
127             ResponseMarket memory m = r.markets[j];
128 
129             m.underlying = q.markets[i];
130 
131             populateResponseMarket(q, m, marketsProxy, execProxy);
132         }
133 
134         if (q.account != address(0)) {
135             r.enteredMarkets = marketsProxy.getEnteredMarkets(q.account);
136         }
137     }
138 
139     function populateResponseMarket(Query memory q, ResponseMarket memory m, Markets marketsProxy, IExec execProxy) private view {
140         m.name = getStringOrBytes32(m.underlying, IERC20.name.selector);
141         m.symbol = getStringOrBytes32(m.underlying, IERC20.symbol.selector);
142 
143         m.decimals = IERC20(m.underlying).decimals();
144 
145         m.eTokenAddr = marketsProxy.underlyingToEToken(m.underlying);
146         if (m.eTokenAddr == address(0)) return; // not activated
147 
148         m.dTokenAddr = marketsProxy.eTokenToDToken(m.eTokenAddr);
149         m.pTokenAddr = marketsProxy.underlyingToPToken(m.underlying);
150 
151         {
152             Storage.AssetConfig memory c = marketsProxy.underlyingToAssetConfig(m.underlying);
153             m.config = c;
154         }
155 
156         m.poolSize = IERC20(m.underlying).balanceOf(q.eulerContract);
157         m.totalBalances = EToken(m.eTokenAddr).totalSupplyUnderlying();
158         m.totalBorrows = IERC20(m.dTokenAddr).totalSupply();
159         m.reserveBalance = EToken(m.eTokenAddr).reserveBalanceUnderlying();
160 
161         m.reserveFee = marketsProxy.reserveFee(m.underlying);
162 
163         {
164             uint borrowSPY = uint(int(marketsProxy.interestRate(m.underlying)));
165             (m.borrowAPY, m.supplyAPY) = computeAPYs(borrowSPY, m.totalBorrows, m.totalBalances, m.reserveFee);
166         }
167 
168         (m.twap, m.twapPeriod, m.currPrice) = execProxy.getPriceFull(m.underlying);
169         (m.pricingType, m.pricingParameters, m.pricingForwarded) = marketsProxy.getPricingConfig(m.underlying);
170 
171         if (q.account == address(0)) return;
172 
173         m.underlyingBalance = IERC20(m.underlying).balanceOf(q.account);
174         m.eTokenBalance = IERC20(m.eTokenAddr).balanceOf(q.account);
175         m.eTokenBalanceUnderlying = EToken(m.eTokenAddr).balanceOfUnderlying(q.account);
176         m.dTokenBalance = IERC20(m.dTokenAddr).balanceOf(q.account);
177         m.eulerAllowance = IERC20(m.underlying).allowance(q.account, q.eulerContract);
178     }
179 
180 
181     function computeAPYs(uint borrowSPY, uint totalBorrows, uint totalBalancesUnderlying, uint32 reserveFee) public pure returns (uint borrowAPY, uint supplyAPY) {
182         borrowAPY = RPow.rpow(borrowSPY + 1e27, SECONDS_PER_YEAR, 10**27) - 1e27;
183 
184         uint supplySPY = totalBalancesUnderlying == 0 ? 0 : borrowSPY * totalBorrows / totalBalancesUnderlying;
185         supplySPY = supplySPY * (RESERVE_FEE_SCALE - reserveFee) / RESERVE_FEE_SCALE;
186         supplyAPY = RPow.rpow(supplySPY + 1e27, SECONDS_PER_YEAR, 10**27) - 1e27;
187     }
188 
189 
190 
191     // Interest rate model queries
192 
193     struct QueryIRM {
194         address eulerContract;
195         address underlying;
196     }
197 
198     struct ResponseIRM {
199         uint kink;
200 
201         uint baseAPY;
202         uint kinkAPY;
203         uint maxAPY;
204 
205         uint baseSupplyAPY;
206         uint kinkSupplyAPY;
207         uint maxSupplyAPY;
208     }
209 
210     function doQueryIRM(QueryIRM memory q) external view returns (ResponseIRM memory r) {
211         Euler eulerProxy = Euler(q.eulerContract);
212         Markets marketsProxy = Markets(eulerProxy.moduleIdToProxy(MODULEID__MARKETS));
213 
214         uint moduleId = marketsProxy.interestRateModel(q.underlying);
215         address moduleImpl = eulerProxy.moduleIdToImplementation(moduleId);
216 
217         BaseIRMLinearKink irm = BaseIRMLinearKink(moduleImpl);
218 
219         uint kink = r.kink = irm.kink();
220         uint32 reserveFee = marketsProxy.reserveFee(q.underlying);
221 
222         uint baseSPY = irm.baseRate();
223         uint kinkSPY = baseSPY + (kink * irm.slope1());
224         uint maxSPY = kinkSPY + ((type(uint32).max - kink) * irm.slope2());
225 
226         (r.baseAPY, r.baseSupplyAPY) = computeAPYs(baseSPY, 0, type(uint32).max, reserveFee);
227         (r.kinkAPY, r.kinkSupplyAPY) = computeAPYs(kinkSPY, kink, type(uint32).max, reserveFee);
228         (r.maxAPY, r.maxSupplyAPY) = computeAPYs(maxSPY, type(uint32).max, type(uint32).max, reserveFee);
229     }
230 
231 
232 
233 
234     // AccountLiquidity queries
235 
236     struct ResponseAccountLiquidity {
237         IRiskManager.AssetLiquidity[] markets;
238     }
239 
240     function doQueryAccountLiquidity(address eulerContract, address[] memory addrs) external view returns (ResponseAccountLiquidity[] memory r) {
241         Euler eulerProxy = Euler(eulerContract);
242         IExec execProxy = IExec(eulerProxy.moduleIdToProxy(MODULEID__EXEC));
243 
244         r = new ResponseAccountLiquidity[](addrs.length);
245 
246         for (uint i = 0; i < addrs.length; ++i) {
247             r[i].markets = execProxy.detailedLiquidity(addrs[i]);
248         }
249     }
250 
251 
252 
253     // For tokens like MKR which return bytes32 on name() or symbol()
254 
255     function getStringOrBytes32(address contractAddress, bytes4 selector) private view returns (string memory) {
256         (bool success, bytes memory result) = contractAddress.staticcall(abi.encodeWithSelector(selector));
257         if (!success) return "";
258 
259         return result.length == 32 ? string(abi.encodePacked(result)) : abi.decode(result, (string));
260     }
261 }
