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
34 * SOFTWARE.
35 */
36 
37 import "@openzeppelin/contracts/math/Math.sol";
38 import "@pancakeswap/pancake-swap-lib/contracts/math/SafeMath.sol";
39 import "@pancakeswap/pancake-swap-lib/contracts/token/BEP20/SafeBEP20.sol";
40 import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
41 import "@openzeppelin/contracts-upgradeable/utils/ReentrancyGuardUpgradeable.sol";
42 
43 import {PoolConstant} from "../library/PoolConstant.sol";
44 
45 import "../interfaces/IStrategy.sol";
46 import "../interfaces/IBunnyMinter.sol";
47 import "../interfaces/IBunnyChef.sol";
48 import "../interfaces/IBunnyPool.sol";
49 import "../interfaces/IZap.sol";
50 
51 import "./VaultController.sol";
52 
53 contract VaultBunnyMaximizer is VaultController, IStrategy, ReentrancyGuardUpgradeable {
54     using SafeMath for uint;
55     using SafeBEP20 for IBEP20;
56 
57     /* ========== CONSTANTS ============= */
58 
59     address private constant BUNNY = 0xC9849E6fdB743d08fAeE3E34dd2D1bc69EA11a51;
60     address private constant WBNB = 0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c;
61     address private constant CAKE = 0x0E09FaBB73Bd3Ade0a17ECC321fD13a19e81cE82;
62 
63     PoolConstant.PoolTypes public constant override poolType = PoolConstant.PoolTypes.BunnyToBunny;
64     IZap public constant zap = IZap(0xdC2bBB0D33E0e7Dea9F5b98F46EDBaC823586a0C);
65 
66     address public constant FEE_BOX = 0x3749f69B2D99E5586D95d95B6F9B5252C71894bb;
67     address private constant BUNNY_POOL_V1 = 0xCADc8CB26c8C7cB46500E61171b5F27e9bd7889D;
68 
69     uint private constant DUST = 1000;
70 
71     uint public constant override pid = 9999;
72 
73     /* ========== STATE VARIABLES ========== */
74 
75     uint private totalShares;
76     mapping (address => uint) private _shares;
77     mapping (address => uint) private _principal;
78     mapping (address => uint) private _depositedAt;
79 
80     address private _bunnyPool;
81 
82     /* ========== INITIALIZER ========== */
83 
84     receive() external payable {}
85 
86     function initialize() external initializer {
87         __VaultController_init(IBEP20(BUNNY));
88         __ReentrancyGuard_init();
89 
90         setMinter(0x8cB88701790F650F273c8BB2Cc4c5f439cd65219);
91     }
92 
93     /* ========== VIEWS ========== */
94 
95     function totalSupply() external view override returns (uint) {
96         return totalShares;
97     }
98 
99     function balance() public view override returns (uint) {
100         if (_bunnyPool == address(0)) {
101             return IBunnyPool(BUNNY_POOL_V1).balanceOf(address(this));
102         }
103         return IBunnyPool(_bunnyPool).balanceOf(address(this));
104     }
105 
106     function balanceOf(address account) public view override returns (uint) {
107         if (totalShares == 0) return 0;
108         return balance().mul(sharesOf(account)).div(totalShares);
109     }
110 
111     function withdrawableBalanceOf(address account) public view override returns (uint) {
112         return balanceOf(account);
113     }
114 
115     function sharesOf(address account) public view override returns (uint) {
116         return _shares[account];
117     }
118 
119     function principalOf(address account) public view override returns (uint) {
120         return _principal[account];
121     }
122 
123     function earned(address account) public view override returns (uint) {
124         if (balanceOf(account) >= principalOf(account) + DUST) {
125             return balanceOf(account).sub(principalOf(account));
126         } else {
127             return 0;
128         }
129     }
130 
131     function depositedAt(address account) external view override returns (uint) {
132         return _depositedAt[account];
133     }
134 
135     function rewardsToken() external view override returns (address) {
136         return BUNNY;
137     }
138 
139     function priceShare() external view override returns (uint) {
140         if (totalShares == 0) return 1e18;
141         return balance().mul(1e18).div(totalShares);
142     }
143 
144     /* ========== MUTATIVE FUNCTIONS ========== */
145 
146     function deposit(uint amount) public override {
147         _deposit(amount, msg.sender);
148     }
149 
150     function depositAll() external override {
151         deposit(_stakingToken.balanceOf(msg.sender));
152     }
153 
154     function withdrawAll() external override {
155         require(_bunnyPool != address(0), "VaultBunnyMaximizer: BunnyPool must set");
156         uint amount = balanceOf(msg.sender);
157         uint principal = principalOf(msg.sender);
158         uint depositTimestamp = _depositedAt[msg.sender];
159 
160         totalShares = totalShares.sub(_shares[msg.sender]);
161         delete _shares[msg.sender];
162         delete _principal[msg.sender];
163         delete _depositedAt[msg.sender];
164 
165         IBunnyPool(_bunnyPool).withdraw(amount);
166 
167         uint withdrawalFee = _minter.withdrawalFee(principal, depositTimestamp);
168         if (withdrawalFee > 0) {
169             _stakingToken.safeTransfer(FEE_BOX, withdrawalFee);
170             amount = amount.sub(withdrawalFee);
171         }
172 
173         _stakingToken.safeTransfer(msg.sender, amount);
174         emit Withdrawn(msg.sender, amount, withdrawalFee);
175     }
176 
177     function harvest() public override onlyKeeper {
178         require(_bunnyPool != address(0), "VaultBunnyMaximizer: BunnyPool must set");
179         uint before = IBEP20(BUNNY).balanceOf(address(this));
180         uint beforeBNB = address(this).balance;
181         uint beforeCAKE = IBEP20(CAKE).balanceOf(address(this));
182 
183         IBunnyPool(_bunnyPool).getReward(); // BNB, CAKE, BUNNY
184 
185         if (address(this).balance.sub(beforeBNB) > 0) {
186             zap.zapIn{ value: address(this).balance.sub(beforeBNB) }(BUNNY);
187         }
188 
189         if (IBEP20(CAKE).balanceOf(address(this)).sub(beforeCAKE) > 0) {
190             zap.zapInToken(CAKE, IBEP20(CAKE).balanceOf(address(this)).sub(beforeCAKE), BUNNY);
191         }
192 
193         uint harvested = IBEP20(BUNNY).balanceOf(address(this)).sub(before);
194         emit Harvested(harvested);
195 
196         IBunnyPool(_bunnyPool).deposit(harvested);
197     }
198 
199     function withdraw(uint) external override onlyWhitelisted {
200         // we don't use withdraw function.
201         revert("N/A");
202     }
203 
204     // @dev underlying only + withdrawal fee + no perf fee
205     function withdrawUnderlying(uint _amount) external {
206         require(_bunnyPool != address(0), "VaultBunnyMaximizer: BunnyPool must set");
207         uint amount = Math.min(_amount, _principal[msg.sender]);
208         uint shares = Math.min(amount.mul(totalShares).div(balance()), _shares[msg.sender]);
209         totalShares = totalShares.sub(shares);
210         _shares[msg.sender] = _shares[msg.sender].sub(shares);
211         _principal[msg.sender] = _principal[msg.sender].sub(amount);
212 
213         IBunnyPool(_bunnyPool).withdraw(amount);
214 
215         uint depositTimestamp = _depositedAt[msg.sender];
216         uint withdrawalFee = _minter.withdrawalFee(amount, depositTimestamp);
217         if (withdrawalFee > 0) {
218             _stakingToken.safeTransfer(FEE_BOX, withdrawalFee);
219             amount = amount.sub(withdrawalFee);
220         }
221 
222         _stakingToken.safeTransfer(msg.sender, amount);
223         emit Withdrawn(msg.sender, amount, withdrawalFee);
224     }
225 
226     function getReward() public override nonReentrant {
227         require(_bunnyPool != address(0), "VaultBunnyMaximizer: BunnyPool must set");
228         uint amount = earned(msg.sender);
229         uint shares = Math.min(amount.mul(totalShares).div(balance()), _shares[msg.sender]);
230         totalShares = totalShares.sub(shares);
231         _shares[msg.sender] = _shares[msg.sender].sub(shares);
232         _cleanupIfDustShares();
233 
234         IBunnyPool(_bunnyPool).withdraw(amount);
235 
236         _stakingToken.safeTransfer(msg.sender, amount);
237         emit ProfitPaid(msg.sender, amount, 0);
238     }
239 
240     function _cleanupIfDustShares() private {
241         uint shares = _shares[msg.sender];
242         if (shares > 0 && shares < DUST) {
243             totalShares = totalShares.sub(shares);
244             delete _shares[msg.sender];
245         }
246     }
247 
248     /* ========== RESTRICTED FUNCTIONS ========== */
249 
250     function setBunnyPool(address bunnyPool) external onlyOwner {
251         if (_bunnyPool != address(0)) {
252             _stakingToken.approve(_bunnyPool, 0);
253         }
254 
255         _bunnyPool = bunnyPool;
256 
257         _stakingToken.approve(_bunnyPool, uint(-1));
258         if (IBEP20(CAKE).allowance(address(this), address(zap)) == 0) {
259             IBEP20(CAKE).approve(address(zap), uint(-1));
260         }
261     }
262 
263     /* ========== PRIVATE FUNCTIONS ========== */
264 
265     function _deposit(uint _amount, address _to) private nonReentrant notPaused {
266         require(_bunnyPool != address(0), "VaultBunnyMaximizer: BunnyPool must set");
267         uint _pool = balance();
268         _stakingToken.safeTransferFrom(msg.sender, address(this), _amount);
269         uint shares = totalShares == 0 ? _amount : (_amount.mul(totalShares)).div(_pool);
270 
271         totalShares = totalShares.add(shares);
272         _shares[_to] = _shares[_to].add(shares);
273         _principal[_to] = _principal[_to].add(_amount);
274         _depositedAt[_to] = block.timestamp;
275 
276         IBunnyPool(_bunnyPool).deposit(_amount);
277         emit Deposited(_to, _amount);
278     }
279 
280     /* ========== SALVAGE PURPOSE ONLY ========== */
281 
282     function recoverToken(address tokenAddress, uint tokenAmount) external override onlyOwner {
283         IBEP20(tokenAddress).safeTransfer(owner(), tokenAmount);
284         emit Recovered(tokenAddress, tokenAmount);
285     }
286 
287     /* ========== MIGRATION ========== */
288 
289     function migrate() external onlyOwner {
290         require(_bunnyPool != address(0), "VaultBunnyMaximizer: must set BunnyPool");
291         uint before = IBEP20(BUNNY).balanceOf(address(this));
292         IBunnyPool(BUNNY_POOL_V1).withdrawAll();   // get BUNNY, WBNB
293 
294         zap.zapInToken(WBNB, IBEP20(WBNB).balanceOf(address(this)), BUNNY);
295         IBunnyPool(_bunnyPool).deposit(IBEP20(BUNNY).balanceOf(address(this)).sub(before));
296     }
297 
298 }