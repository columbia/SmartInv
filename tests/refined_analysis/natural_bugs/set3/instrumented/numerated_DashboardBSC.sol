1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.6.12;
3 pragma experimental ABIEncoderV2;
4 
5 /*
6   ___                      _   _
7  | _ )_  _ _ _  _ _ _  _  | | | |
8  | _ \ || | ' \| ' \ || | |_| |_|
9  |___/\_,_|_||_|_||_\_, | (_) (_)
10                     |__/
11 
12 *
13 * MIT License
14 * ===========
15 *
16 * Copyright (c) 2020 BunnyFinance
17 *
18 * Permission is hereby granted, free of charge, to any person obtaining a copy
19 * of this software and associated documentation files (the "Software"), to deal
20 * in the Software without restriction, including without limitation the rights
21 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
22 * copies of the Software, and to permit persons to whom the Software is
23 * furnished to do so, subject to the following conditions:
24 *
25 * The above copyright notice and this permission notice shall be included in all
26 * copies or substantial portions of the Software.
27 *
28 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
29 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
30 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
31 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
32 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
33 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
34 */
35 
36 import "@pancakeswap/pancake-swap-lib/contracts/math/SafeMath.sol";
37 import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
38 
39 import "../interfaces/IStrategy.sol";
40 import "../interfaces/IBunnyMinter.sol";
41 import "../interfaces/IBunnyChef.sol";
42 import "../interfaces/IPriceCalculator.sol";
43 
44 import "../vaults/BunnyPool.sol";
45 import "../vaults/venus/VaultVenus.sol";
46 import "../vaults/relay/VaultRelayer.sol";
47 
48 
49 contract DashboardBSC is OwnableUpgradeable {
50     using SafeMath for uint;
51     using SafeDecimal for uint;
52 
53     IPriceCalculator public constant priceCalculator = IPriceCalculator(0xF5BF8A9249e3cc4cB684E3f23db9669323d4FB7d);
54 
55     address public constant WBNB = 0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c;
56     address public constant BUNNY = 0xC9849E6fdB743d08fAeE3E34dd2D1bc69EA11a51;
57     address public constant CAKE = 0x0E09FaBB73Bd3Ade0a17ECC321fD13a19e81cE82;
58     address public constant VaultCakeToCake = 0xEDfcB78e73f7bA6aD2D829bf5D462a0924da28eD;
59 
60     IBunnyChef private constant bunnyChef = IBunnyChef(0x40e31876c4322bd033BAb028474665B12c4d04CE);
61     BunnyPool private constant bunnyPool = BunnyPool(0xCADc8CB26c8C7cB46500E61171b5F27e9bd7889D);
62     VaultRelayer private constant relayer = VaultRelayer(0x34D3fF7f0476B38f990e9b8571aCAE60f6321C03);
63 
64     /* ========== STATE VARIABLES ========== */
65 
66     mapping(address => PoolConstant.PoolTypes) public poolTypes;
67     mapping(address => uint) public pancakePoolIds;
68     mapping(address => bool) public perfExemptions;
69 
70     /* ========== INITIALIZER ========== */
71 
72     function initialize() external initializer {
73         __Ownable_init();
74     }
75 
76     /* ========== Restricted Operation ========== */
77 
78     function setPoolType(address pool, PoolConstant.PoolTypes poolType) public onlyOwner {
79         poolTypes[pool] = poolType;
80     }
81 
82     function setPancakePoolId(address pool, uint pid) public onlyOwner {
83         pancakePoolIds[pool] = pid;
84     }
85 
86     function setPerfExemption(address pool, bool exemption) public onlyOwner {
87         perfExemptions[pool] = exemption;
88     }
89 
90     /* ========== View Functions ========== */
91 
92     function poolTypeOf(address pool) public view returns (PoolConstant.PoolTypes) {
93         return poolTypes[pool];
94     }
95 
96     /* ========== Utilization Calculation ========== */
97 
98     function utilizationOfPool(address pool) public view returns (uint liquidity, uint utilized) {
99         if (poolTypes[pool] == PoolConstant.PoolTypes.Venus) {
100             return VaultVenus(payable(pool)).getUtilizationInfo();
101         }
102         return (0, 0);
103     }
104 
105     /* ========== Profit Calculation ========== */
106 
107     function calculateProfit(address pool, address account) public view returns (uint profit, uint profitInBNB) {
108         PoolConstant.PoolTypes poolType = poolTypes[pool];
109         profit = 0;
110         profitInBNB = 0;
111 
112         if (poolType == PoolConstant.PoolTypes.BunnyStake_deprecated) {
113             // profit as bnb
114             (profit,) = priceCalculator.valueOfAsset(address(bunnyPool.rewardsToken()), bunnyPool.earned(account));
115             profitInBNB = profit;
116         }
117         else if (poolType == PoolConstant.PoolTypes.Bunny) {
118             // profit as bunny
119             profit = bunnyChef.pendingBunny(pool, account);
120             (profitInBNB,) = priceCalculator.valueOfAsset(BUNNY, profit);
121         }
122         else if (poolType == PoolConstant.PoolTypes.CakeStake || poolType == PoolConstant.PoolTypes.FlipToFlip || poolType == PoolConstant.PoolTypes.Venus || poolType == PoolConstant.PoolTypes.BunnyToBunny) {
123             // profit as underlying
124             IStrategy strategy = IStrategy(pool);
125             profit = strategy.earned(account);
126             (profitInBNB,) = priceCalculator.valueOfAsset(strategy.stakingToken(), profit);
127         }
128         else if (poolType == PoolConstant.PoolTypes.FlipToCake || poolType == PoolConstant.PoolTypes.BunnyBNB) {
129             // profit as cake
130             IStrategy strategy = IStrategy(pool);
131             profit = strategy.earned(account).mul(IStrategy(strategy.rewardsToken()).priceShare()).div(1e18);
132             (profitInBNB,) = priceCalculator.valueOfAsset(CAKE, profit);
133         }
134     }
135 
136     function profitOfPool(address pool, address account) public view returns (uint profit, uint bunny) {
137         (uint profitCalculated, uint profitInBNB) = calculateProfit(pool, account);
138         profit = profitCalculated;
139         bunny = 0;
140 
141         if (!perfExemptions[pool]) {
142             IStrategy strategy = IStrategy(pool);
143             if (strategy.minter() != address(0)) {
144                 profit = profit.mul(70).div(100);
145                 bunny = IBunnyMinter(strategy.minter()).amountBunnyToMint(profitInBNB.mul(30).div(100));
146             }
147 
148             if (strategy.bunnyChef() != address(0)) {
149                 bunny = bunny.add(bunnyChef.pendingBunny(pool, account));
150             }
151         }
152     }
153 
154     /* ========== TVL Calculation ========== */
155 
156     function tvlOfPool(address pool) public view returns (uint tvl) {
157         if (poolTypes[pool] == PoolConstant.PoolTypes.BunnyStake_deprecated) {
158             (, tvl) = priceCalculator.valueOfAsset(address(bunnyPool.stakingToken()), bunnyPool.balance());
159         }
160         else {
161             IStrategy strategy = IStrategy(pool);
162             (, tvl) = priceCalculator.valueOfAsset(strategy.stakingToken(), strategy.balance());
163 
164             if (strategy.rewardsToken() == VaultCakeToCake) {
165                 IStrategy rewardsToken = IStrategy(strategy.rewardsToken());
166                 uint rewardsInCake = rewardsToken.balanceOf(pool).mul(rewardsToken.priceShare()).div(1e18);
167                 (, uint rewardsInUSD) = priceCalculator.valueOfAsset(address(CAKE), rewardsInCake);
168                 tvl = tvl.add(rewardsInUSD);
169             }
170         }
171     }
172 
173     /* ========== Pool Information ========== */
174 
175     function infoOfPool(address pool, address account) public view returns (PoolConstant.PoolInfo memory) {
176         PoolConstant.PoolInfo memory poolInfo;
177 
178         IStrategy strategy = IStrategy(pool);
179         (uint pBASE, uint pBUNNY) = profitOfPool(pool, account);
180         (uint liquidity, uint utilized) = utilizationOfPool(pool);
181 
182         poolInfo.pool = pool;
183         poolInfo.balance = strategy.balanceOf(account);
184         poolInfo.principal = strategy.principalOf(account);
185         poolInfo.available = strategy.withdrawableBalanceOf(account);
186         poolInfo.tvl = tvlOfPool(pool);
187         poolInfo.utilized = utilized;
188         poolInfo.liquidity = liquidity;
189         poolInfo.pBASE = pBASE;
190         poolInfo.pBUNNY = pBUNNY;
191 
192         PoolConstant.PoolTypes poolType = poolTypeOf(pool);
193         if (poolType != PoolConstant.PoolTypes.BunnyStake_deprecated && strategy.minter() != address(0)) {
194             IBunnyMinter minter = IBunnyMinter(strategy.minter());
195             poolInfo.depositedAt = strategy.depositedAt(account);
196             poolInfo.feeDuration = minter.WITHDRAWAL_FEE_FREE_PERIOD();
197             poolInfo.feePercentage = minter.WITHDRAWAL_FEE();
198         }
199 
200         poolInfo.portfolio = portfolioOfPoolInUSD(pool, account);
201         return poolInfo;
202     }
203 
204     function poolsOf(address account, address[] memory pools) public view returns (PoolConstant.PoolInfo[] memory) {
205         PoolConstant.PoolInfo[] memory results = new PoolConstant.PoolInfo[](pools.length);
206         for (uint i = 0; i < pools.length; i++) {
207             results[i] = infoOfPool(pools[i], account);
208         }
209         return results;
210     }
211 
212     /* ========== Relay Information ========== */
213 
214     function infoOfRelay(address pool, address account) public view returns (PoolConstant.RelayInfo memory) {
215         PoolConstant.RelayInfo memory relayInfo;
216         relayInfo.pool = pool;
217         relayInfo.balanceInUSD = relayer.balanceInUSD(pool, account);
218         relayInfo.debtInUSD = relayer.debtInUSD(pool, account);
219         relayInfo.earnedInUSD = relayer.earnedInUSD(pool, account);
220         return relayInfo;
221     }
222 
223     function relaysOf(address account, address[] memory pools) public view returns (PoolConstant.RelayInfo[] memory) {
224         PoolConstant.RelayInfo[] memory results = new PoolConstant.RelayInfo[](pools.length);
225         for (uint i = 0; i < pools.length; i++) {
226             results[i] = infoOfRelay(pools[i], account);
227         }
228         return results;
229     }
230 
231     /* ========== Portfolio Calculation ========== */
232 
233     function stakingTokenValueInUSD(address pool, address account) internal view returns (uint tokenInUSD) {
234         PoolConstant.PoolTypes poolType = poolTypes[pool];
235 
236         address stakingToken;
237         if (poolType == PoolConstant.PoolTypes.BunnyStake_deprecated) {
238             stakingToken = BUNNY;
239         } else {
240             stakingToken = IStrategy(pool).stakingToken();
241         }
242 
243         if (stakingToken == address(0)) return 0;
244         (, tokenInUSD) = priceCalculator.valueOfAsset(stakingToken, IStrategy(pool).principalOf(account));
245     }
246 
247     function portfolioOfPoolInUSD(address pool, address account) internal view returns (uint) {
248         uint tokenInUSD = stakingTokenValueInUSD(pool, account);
249         (, uint profitInBNB) = calculateProfit(pool, account);
250         uint profitInBUNNY = 0;
251 
252         if (!perfExemptions[pool]) {
253             IStrategy strategy = IStrategy(pool);
254             if (strategy.minter() != address(0)) {
255                 profitInBNB = profitInBNB.mul(70).div(100);
256                 profitInBUNNY = IBunnyMinter(strategy.minter()).amountBunnyToMint(profitInBNB.mul(30).div(100));
257             }
258 
259             if ((poolTypes[pool] == PoolConstant.PoolTypes.Bunny || poolTypes[pool] == PoolConstant.PoolTypes.BunnyBNB
260             || poolTypes[pool] == PoolConstant.PoolTypes.FlipToFlip)
261                 && strategy.bunnyChef() != address(0)) {
262                 profitInBUNNY = profitInBUNNY.add(bunnyChef.pendingBunny(pool, account));
263             }
264         }
265 
266         (, uint profitBNBInUSD) = priceCalculator.valueOfAsset(WBNB, profitInBNB);
267         (, uint profitBUNNYInUSD) = priceCalculator.valueOfAsset(BUNNY, profitInBUNNY);
268         return tokenInUSD.add(profitBNBInUSD).add(profitBUNNYInUSD);
269     }
270 
271     function portfolioOf(address account, address[] memory pools) public view returns (uint deposits) {
272         deposits = 0;
273         for (uint i = 0; i < pools.length; i++) {
274             deposits = deposits.add(portfolioOfPoolInUSD(pools[i], account));
275         }
276     }
277 }
