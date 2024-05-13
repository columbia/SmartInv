1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.6.12;
3 
4 /*
5   ___                      _   _
6  | _ )_  _ _ _  _ _ _  _  | | | |
7  | _ \ || | ' \| ' \ || | |_| |_|
8  |___/\_,_|_||_|_||_\_, | (_) (_)
9                     |__/
10 
11 *
12 * MIT License
13 * ===========
14 *
15 * Copyright (c) 2020 BunnyFinance
16 *
17 * Permission is hereby granted, free of charge, to any person obtaining a copy
18 * of this software and associated documentation files (the "Software"), to deal
19 * in the Software without restriction, including without limitation the rights
20 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
21 * copies of the Software, and to permit persons to whom the Software is
22 * furnished to do so, subject to the following conditions:
23 *
24 * The above copyright notice and this permission notice shall be included in all
25 * copies or substantial portions of the Software.
26 *
27 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
28 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
29 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
30 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
31 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
32 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
33 * SOFTWARE.
34 */
35 
36 import "@pancakeswap/pancake-swap-lib/contracts/token/BEP20/BEP20.sol";
37 import "@pancakeswap/pancake-swap-lib/contracts/token/BEP20/SafeBEP20.sol";
38 import "@pancakeswap/pancake-swap-lib/contracts/math/SafeMath.sol";
39 
40 import "../interfaces/IBunnyMinterV2.sol";
41 import "../interfaces/IBunnyPool.sol";
42 import "../interfaces/IPriceCalculator.sol";
43 
44 import "../zap/ZapBSC.sol";
45 import "../library/SafeToken.sol";
46 
47 contract BunnyMinterV2 is IBunnyMinterV2, OwnableUpgradeable {
48     using SafeMath for uint;
49     using SafeBEP20 for IBEP20;
50 
51     /* ========== CONSTANTS ============= */
52 
53     address public constant WBNB = 0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c;
54     address public constant BUNNY = 0xC9849E6fdB743d08fAeE3E34dd2D1bc69EA11a51;
55     address public constant BUNNY_POOL_V1 = 0xCADc8CB26c8C7cB46500E61171b5F27e9bd7889D;
56 
57     address public constant FEE_BOX = 0x3749f69B2D99E5586D95d95B6F9B5252C71894bb;
58     address private constant TIMELOCK = 0x85c9162A51E03078bdCd08D4232Bab13ed414cC3;
59     address private constant DEAD = 0x000000000000000000000000000000000000dEaD;
60     address private constant DEPLOYER = 0xe87f02606911223C2Cf200398FFAF353f60801F7;
61 
62     uint public constant FEE_MAX = 10000;
63 
64     IPriceCalculator public constant priceCalculator = IPriceCalculator(0xF5BF8A9249e3cc4cB684E3f23db9669323d4FB7d);
65     ZapBSC private constant zap = ZapBSC(0xdC2bBB0D33E0e7Dea9F5b98F46EDBaC823586a0C);
66     IPancakeRouter02 private constant router = IPancakeRouter02(0x10ED43C718714eb63d5aA57B78B54704E256024E);
67 
68     /* ========== STATE VARIABLES ========== */
69 
70     address public bunnyChef;
71     mapping(address => bool) private _minters;
72     address public _deprecated_helper; // deprecated
73 
74     uint public PERFORMANCE_FEE;
75     uint public override WITHDRAWAL_FEE_FREE_PERIOD;
76     uint public override WITHDRAWAL_FEE;
77 
78     uint public _deprecated_bunnyPerProfitBNB; // deprecated
79     uint public _deprecated_bunnyPerBunnyBNBFlip;   // deprecated
80 
81     uint private _floatingRateEmission;
82     uint private _freThreshold;
83 
84     address public bunnyPool;
85 
86     /* ========== MODIFIERS ========== */
87 
88     modifier onlyMinter {
89         require(isMinter(msg.sender) == true, "BunnyMinterV2: caller is not the minter");
90         _;
91     }
92 
93     modifier onlyBunnyChef {
94         require(msg.sender == bunnyChef, "BunnyMinterV2: caller not the bunny chef");
95         _;
96     }
97 
98     /* ========== EVENTS ========== */
99 
100     event PerformanceFee(address indexed asset, uint amount, uint value);
101 
102     receive() external payable {}
103 
104     /* ========== INITIALIZER ========== */
105 
106     function initialize() external initializer {
107         WITHDRAWAL_FEE_FREE_PERIOD = 3 days;
108         WITHDRAWAL_FEE = 50;
109         PERFORMANCE_FEE = 3000;
110 
111         _deprecated_bunnyPerProfitBNB = 5e18;
112         _deprecated_bunnyPerBunnyBNBFlip = 6e18;
113 
114         IBEP20(BUNNY).approve(BUNNY_POOL_V1, uint(- 1));
115     }
116 
117     /* ========== RESTRICTED FUNCTIONS ========== */
118 
119     function transferBunnyOwner(address _owner) external onlyOwner {
120         Ownable(BUNNY).transferOwnership(_owner);
121     }
122 
123     function setWithdrawalFee(uint _fee) external onlyOwner {
124         require(_fee < 500, "wrong fee");
125         // less 5%
126         WITHDRAWAL_FEE = _fee;
127     }
128 
129     function setPerformanceFee(uint _fee) external onlyOwner {
130         require(_fee < 5000, "wrong fee");
131         PERFORMANCE_FEE = _fee;
132     }
133 
134     function setWithdrawalFeeFreePeriod(uint _period) external onlyOwner {
135         WITHDRAWAL_FEE_FREE_PERIOD = _period;
136     }
137 
138     function setMinter(address minter, bool canMint) external override onlyOwner {
139         if (canMint) {
140             _minters[minter] = canMint;
141         } else {
142             delete _minters[minter];
143         }
144     }
145 
146     function setBunnyChef(address _bunnyChef) external onlyOwner {
147         require(bunnyChef == address(0), "BunnyMinterV2: setBunnyChef only once");
148         bunnyChef = _bunnyChef;
149     }
150 
151     function setFloatingRateEmission(uint floatingRateEmission) external onlyOwner {
152         require(floatingRateEmission > 1e18 && floatingRateEmission < 10e18, "BunnyMinterV2: floatingRateEmission wrong range");
153         _floatingRateEmission = floatingRateEmission;
154     }
155 
156     function setFREThreshold(uint threshold) external onlyOwner {
157         _freThreshold = threshold;
158     }
159 
160     function setBunnyPool(address _bunnyPool) external onlyOwner {
161         IBEP20(BUNNY).approve(BUNNY_POOL_V1, 0);
162         bunnyPool = _bunnyPool;
163         IBEP20(BUNNY).approve(_bunnyPool, uint(-1));
164     }
165 
166     /* ========== VIEWS ========== */
167 
168     function isMinter(address account) public view override returns (bool) {
169         if (IBEP20(BUNNY).getOwner() != address(this)) {
170             return false;
171         }
172         return _minters[account];
173     }
174 
175     function amountBunnyToMint(uint bnbProfit) public view override returns (uint) {
176         return bnbProfit.mul(priceCalculator.priceOfBNB()).div(priceCalculator.priceOfBunny()).mul(floatingRateEmission()).div(1e18);
177     }
178 
179     function amountBunnyToMintForBunnyBNB(uint amount, uint duration) public view override returns (uint) {
180         return amount.mul(_deprecated_bunnyPerBunnyBNBFlip).mul(duration).div(365 days).div(1e18);
181     }
182 
183     function withdrawalFee(uint amount, uint depositedAt) external view override returns (uint) {
184         if (depositedAt.add(WITHDRAWAL_FEE_FREE_PERIOD) > block.timestamp) {
185             return amount.mul(WITHDRAWAL_FEE).div(FEE_MAX);
186         }
187         return 0;
188     }
189 
190     function performanceFee(uint profit) public view override returns (uint) {
191         return profit.mul(PERFORMANCE_FEE).div(FEE_MAX);
192     }
193 
194     function floatingRateEmission() public view returns(uint) {
195         return _floatingRateEmission == 0 ? 120e16 : _floatingRateEmission;
196     }
197 
198     function freThreshold() public view returns(uint) {
199         return _freThreshold == 0 ? 18e18 : _freThreshold;
200     }
201 
202     function shouldMarketBuy() public view returns(bool) {
203         return priceCalculator.priceOfBunny().mul(freThreshold()).div(priceCalculator.priceOfBNB()) < 1e18;
204     }
205 
206     /* ========== V1 FUNCTIONS ========== */
207 
208     function mintFor(address asset, uint _withdrawalFee, uint _performanceFee, address to, uint) public payable override onlyMinter {
209         uint feeSum = _performanceFee.add(_withdrawalFee);
210         _transferAsset(asset, feeSum);
211 
212         if (asset == BUNNY) {
213             IBEP20(BUNNY).safeTransfer(DEAD, feeSum);
214             return;
215         }
216 
217         bool marketBuy = shouldMarketBuy();
218         if (marketBuy == false) {
219             if (asset == address(0)) { // means BNB
220                 SafeToken.safeTransferETH(FEE_BOX, feeSum);
221             } else {
222                 IBEP20(asset).safeTransfer(FEE_BOX, feeSum);
223             }
224         } else {
225             if (_withdrawalFee > 0) {
226                 if (asset == address(0)) { // means BNB
227                     SafeToken.safeTransferETH(FEE_BOX, _withdrawalFee);
228                 } else {
229                     IBEP20(asset).safeTransfer(FEE_BOX, _withdrawalFee);
230                 }
231             }
232 
233             if (_performanceFee == 0) return;
234 
235             _marketBuy(asset, _performanceFee, to);
236             _performanceFee = _performanceFee.mul(floatingRateEmission().sub(1e18)).div(floatingRateEmission());
237         }
238 
239         (uint contributionInBNB, uint contributionInUSD) = priceCalculator.valueOfAsset(asset, _performanceFee);
240         uint mintBunny = amountBunnyToMint(contributionInBNB);
241         if (mintBunny == 0) return;
242         _mint(mintBunny, to);
243 
244         if (marketBuy) {
245             uint usd = contributionInUSD.mul(floatingRateEmission()).div(floatingRateEmission().sub(1e18));
246             emit PerformanceFee(asset, _performanceFee, usd);
247         } else {
248             emit PerformanceFee(asset, _performanceFee, contributionInUSD);
249         }
250     }
251 
252     /* ========== PancakeSwap V2 FUNCTIONS ========== */
253 
254     function mintForV2(address asset, uint _withdrawalFee, uint _performanceFee, address to, uint timestamp) external payable override onlyMinter {
255         mintFor(asset, _withdrawalFee, _performanceFee, to, timestamp);
256     }
257 
258     /* ========== BunnyChef FUNCTIONS ========== */
259 
260     function mint(uint amount) external override onlyBunnyChef {
261         if (amount == 0) return;
262         _mint(amount, address(this));
263     }
264 
265     function safeBunnyTransfer(address _to, uint _amount) external override onlyBunnyChef {
266         if (_amount == 0) return;
267 
268         uint bal = IBEP20(BUNNY).balanceOf(address(this));
269         if (_amount <= bal) {
270             IBEP20(BUNNY).safeTransfer(_to, _amount);
271         } else {
272             IBEP20(BUNNY).safeTransfer(_to, bal);
273         }
274     }
275 
276     // @dev should be called when determining mint in governance. Bunny is transferred to the timelock contract.
277     function mintGov(uint amount) external override onlyOwner {
278         if (amount == 0) return;
279         _mint(amount, TIMELOCK);
280     }
281 
282     /* ========== PRIVATE FUNCTIONS ========== */
283 
284     function _marketBuy(address asset, uint amount, address to) private {
285         uint _initBunnyAmount = IBEP20(BUNNY).balanceOf(address(this));
286 
287         if (asset == address(0)) {
288             zap.zapIn{ value : amount }(BUNNY);
289         }
290         else if (keccak256(abi.encodePacked(IPancakePair(asset).symbol())) == keccak256("Cake-LP")) {
291             if (IBEP20(asset).allowance(address(this), address(router)) == 0) {
292                 IBEP20(asset).safeApprove(address(router), uint(- 1));
293             }
294 
295             IPancakePair pair = IPancakePair(asset);
296             address token0 = pair.token0();
297             address token1 = pair.token1();
298 
299             // burn
300             if (IPancakePair(asset).balanceOf(asset) > 0) {
301                 IPancakePair(asset).burn(address(zap));
302             }
303 
304             (uint amountToken0, uint amountToken1) = router.removeLiquidity(token0, token1, amount, 0, 0, address(this), block.timestamp);
305 
306             if (IBEP20(token0).allowance(address(this), address(zap)) == 0) {
307                 IBEP20(token0).safeApprove(address(zap), uint(- 1));
308             }
309             if (IBEP20(token1).allowance(address(this), address(zap)) == 0) {
310                 IBEP20(token1).safeApprove(address(zap), uint(- 1));
311             }
312 
313             if (token0 != BUNNY) {
314                 zap.zapInToken(token0, amountToken0, BUNNY);
315             }
316 
317             if (token1 != BUNNY) {
318                 zap.zapInToken(token1, amountToken1, BUNNY);
319             }
320         }
321         else {
322             if (IBEP20(asset).allowance(address(this), address(zap)) == 0) {
323                 IBEP20(asset).safeApprove(address(zap), uint(- 1));
324             }
325 
326             zap.zapInToken(asset, amount, BUNNY);
327         }
328 
329         uint bunnyAmount = IBEP20(BUNNY).balanceOf(address(this)).sub(_initBunnyAmount);
330         IBEP20(BUNNY).safeTransfer(to, bunnyAmount);
331     }
332 
333     function _transferAsset(address asset, uint amount) private {
334         if (asset == address(0)) {
335             // case) transferred BNB
336             require(msg.value >= amount);
337         } else {
338             IBEP20(asset).safeTransferFrom(msg.sender, address(this), amount);
339         }
340     }
341 
342     function _mint(uint amount, address to) private {
343         BEP20 tokenBUNNY = BEP20(BUNNY);
344 
345         tokenBUNNY.mint(amount);
346         if (to != address(this)) {
347             tokenBUNNY.transfer(to, amount);
348         }
349 
350         uint bunnyForDev = amount.mul(15).div(100);
351         tokenBUNNY.mint(bunnyForDev);
352         if (bunnyPool == address(0)) {
353             tokenBUNNY.transfer(DEPLOYER, bunnyForDev);
354         } else {
355             IBunnyPool(bunnyPool).depositOnBehalf(bunnyForDev, DEPLOYER);
356         }
357     }
358 }
