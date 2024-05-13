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
36 import "@openzeppelin/contracts/math/Math.sol";
37 import "@pancakeswap/pancake-swap-lib/contracts/math/SafeMath.sol";
38 import "@pancakeswap/pancake-swap-lib/contracts/token/BEP20/SafeBEP20.sol";
39 import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
40 import "@openzeppelin/contracts-upgradeable/utils/ReentrancyGuardUpgradeable.sol";
41 
42 import "../library/RewardsDistributionRecipientUpgradeable.sol";
43 import "../interfaces/IStrategy.sol";
44 import "../interfaces/IMasterChef.sol";
45 import "../interfaces/IBunnyMinter.sol";
46 import "../interfaces/IBunnyChef.sol";
47 import "./VaultController.sol";
48 import {PoolConstant} from "../library/PoolConstant.sol";
49 
50 
51 contract VaultBunnyBNB is VaultController, IStrategy, RewardsDistributionRecipientUpgradeable, ReentrancyGuardUpgradeable {
52     using SafeMath for uint;
53     using SafeBEP20 for IBEP20;
54 
55     /* ========== CONSTANTS ============= */
56 
57     address private constant CAKE = 0x0E09FaBB73Bd3Ade0a17ECC321fD13a19e81cE82;
58     address private constant BUNNY_BNB = 0x5aFEf8567414F29f0f927A0F2787b188624c10E2;
59     uint public constant override pid = 323;
60     IMasterChef private constant CAKE_MASTER_CHEF = IMasterChef(0x73feaa1eE314F8c655E354234017bE2193C9E24E);
61     PoolConstant.PoolTypes public constant override poolType = PoolConstant.PoolTypes.BunnyBNB;
62 
63     /* ========== STATE VARIABLES ========== */
64 
65     IStrategy private _rewardsToken;
66 
67     uint public periodFinish;
68     uint public rewardRate;
69     uint public rewardsDuration;
70     uint public lastUpdateTime;
71     uint public rewardPerTokenStored;
72 
73     mapping(address => uint) public userRewardPerTokenPaid;
74     mapping(address => uint) public rewards;
75 
76     uint private _totalSupply;
77     mapping(address => uint) private _balances;
78 
79 
80     mapping(address => uint) private _depositedAt;
81 
82     /* ========== MODIFIERS ========== */
83 
84     modifier updateReward(address account) {
85         rewardPerTokenStored = rewardPerToken();
86         lastUpdateTime = lastTimeRewardApplicable();
87         if (account != address(0)) {
88             rewards[account] = earned(account);
89             userRewardPerTokenPaid[account] = rewardPerTokenStored;
90         }
91         _;
92     }
93 
94     /* ========== EVENTS ========== */
95 
96     event RewardAdded(uint reward);
97     event RewardsDurationUpdated(uint newDuration);
98 
99     /* ========== INITIALIZER ========== */
100 
101     function initialize() external initializer {
102         __VaultController_init(IBEP20(BUNNY_BNB));
103         __RewardsDistributionRecipient_init();
104         __ReentrancyGuard_init();
105 
106         _stakingToken.safeApprove(address(CAKE_MASTER_CHEF), uint(- 1));
107 
108         rewardsDuration = 4 hours;
109         rewardsDistribution = msg.sender;
110         setRewardsToken(0xEDfcB78e73f7bA6aD2D829bf5D462a0924da28eD);
111     }
112 
113     /* ========== VIEWS ========== */
114 
115     function totalSupply() external view override returns (uint) {
116         return _totalSupply;
117     }
118 
119     function balance() external view override returns (uint) {
120         return _totalSupply;
121     }
122 
123     function balanceOf(address account) external view override returns (uint) {
124         return _balances[account];
125     }
126 
127     function sharesOf(address account) external view override returns (uint) {
128         return _balances[account];
129     }
130 
131     function principalOf(address account) external view override returns (uint) {
132         return _balances[account];
133     }
134 
135     function depositedAt(address account) external view override returns (uint) {
136         return _depositedAt[account];
137     }
138 
139     function withdrawableBalanceOf(address account) public view override returns (uint) {
140         return _balances[account];
141     }
142 
143     function rewardsToken() external view override returns (address) {
144         return address(_rewardsToken);
145     }
146 
147     function priceShare() external view override returns (uint) {
148         return 1e18;
149     }
150 
151     function lastTimeRewardApplicable() public view returns (uint) {
152         return Math.min(block.timestamp, periodFinish);
153     }
154 
155     function rewardPerToken() public view returns (uint) {
156         if (_totalSupply == 0) {
157             return rewardPerTokenStored;
158         }
159         return
160         rewardPerTokenStored.add(
161             lastTimeRewardApplicable().sub(lastUpdateTime).mul(rewardRate).mul(1e18).div(_totalSupply)
162         );
163     }
164 
165     function earned(address account) override public view returns (uint) {
166         return _balances[account].mul(rewardPerToken().sub(userRewardPerTokenPaid[account])).div(1e18).add(rewards[account]);
167     }
168 
169     function getRewardForDuration() external view returns (uint) {
170         return rewardRate.mul(rewardsDuration);
171     }
172 
173     function pidAttached() public pure returns (bool) {
174         return pid != 0;
175     }
176 
177     /* ========== MUTATIVE FUNCTIONS ========== */
178 
179     function deposit(uint amount) override public {
180         _deposit(amount, msg.sender);
181     }
182 
183     function depositAll() override external {
184         deposit(_stakingToken.balanceOf(msg.sender));
185     }
186 
187     function withdraw(uint amount) override public nonReentrant updateReward(msg.sender) {
188         require(amount > 0, "VaultBunnyBNB: amount must be greater than zero");
189         _bunnyChef.notifyWithdrawn(msg.sender, amount);
190 
191         _totalSupply = _totalSupply.sub(amount);
192         _balances[msg.sender] = _balances[msg.sender].sub(amount);
193 
194         uint cakeHarvested = _withdrawStakingToken(amount);
195 
196         uint withdrawalFee;
197         if (canMint()) {
198             uint depositTimestamp = _depositedAt[msg.sender];
199             withdrawalFee = _minter.withdrawalFee(amount, depositTimestamp);
200             if (withdrawalFee > 0) {
201                 _minter.mintForV2(address(_stakingToken), withdrawalFee, 0, msg.sender, depositTimestamp);
202                 amount = amount.sub(withdrawalFee);
203             }
204         }
205 
206         _stakingToken.safeTransfer(msg.sender, amount);
207         emit Withdrawn(msg.sender, amount, withdrawalFee);
208 
209         _harvest(cakeHarvested);
210     }
211 
212     function withdrawAll() external override {
213         uint _withdraw = withdrawableBalanceOf(msg.sender);
214         if (_withdraw > 0) {
215             withdraw(_withdraw);
216         }
217         getReward();
218     }
219 
220     function getReward() public override nonReentrant updateReward(msg.sender) {
221         uint reward = rewards[msg.sender];
222         if (reward > 0) {
223             rewards[msg.sender] = 0;
224             uint before = IBEP20(CAKE).balanceOf(address(this));
225             _rewardsToken.withdraw(reward);
226             uint cakeBalance = IBEP20(CAKE).balanceOf(address(this)).sub(before);
227             uint performanceFee;
228 
229             if (canMint()) {
230                 performanceFee = _minter.performanceFee(cakeBalance);
231                 _minter.mintForV2(CAKE, 0, performanceFee, msg.sender, _depositedAt[msg.sender]);
232             }
233 
234             IBEP20(CAKE).safeTransfer(msg.sender, cakeBalance.sub(performanceFee));
235             emit ProfitPaid(msg.sender, cakeBalance, performanceFee);
236         }
237 
238         uint bunnyAmount = _bunnyChef.safeBunnyTransfer(msg.sender);
239         emit BunnyPaid(msg.sender, bunnyAmount, 0);
240     }
241 
242     function harvest() public override {
243         uint cakeHarvested = _withdrawStakingToken(0);
244         _harvest(cakeHarvested);
245     }
246 
247     /* ========== RESTRICTED FUNCTIONS ========== */
248 
249     function setMinter(address newMinter) public override onlyOwner {
250         VaultController.setMinter(newMinter);
251         if (newMinter != address(0)) {
252             IBEP20(CAKE).safeApprove(newMinter, 0);
253             IBEP20(CAKE).safeApprove(newMinter, uint(- 1));
254         }
255     }
256 
257     function setBunnyChef(IBunnyChef _chef) public override onlyOwner {
258         require(address(_bunnyChef) == address(0), "VaultBunnyBNB: setBunnyChef only once");
259         VaultController.setBunnyChef(IBunnyChef(_chef));
260     }
261 
262     function setRewardsToken(address newRewardsToken) public onlyOwner {
263         require(address(_rewardsToken) == address(0), "VaultBunnyBNB: rewards token already set");
264 
265         _rewardsToken = IStrategy(newRewardsToken);
266         IBEP20(CAKE).safeApprove(newRewardsToken, 0);
267         IBEP20(CAKE).safeApprove(newRewardsToken, uint(- 1));
268     }
269 
270     function notifyRewardAmount(uint reward) public override onlyRewardsDistribution {
271         _notifyRewardAmount(reward);
272     }
273 
274     function setRewardsDuration(uint _rewardsDuration) external onlyOwner {
275         require(periodFinish == 0 || block.timestamp > periodFinish, "VaultBunnyBNB: reward duration can only be updated after the period ends");
276         rewardsDuration = _rewardsDuration;
277         emit RewardsDurationUpdated(rewardsDuration);
278     }
279 
280     /* ========== PRIVATE FUNCTIONS ========== */
281     function _withdrawStakingToken(uint amount) private returns(uint cakeHarvested) {
282         uint before = IBEP20(CAKE).balanceOf(address(this));
283         CAKE_MASTER_CHEF.withdraw(pid, amount);
284         cakeHarvested = IBEP20(CAKE).balanceOf(address(this)).sub(before);
285     }
286 
287     function _depositStakingToken(uint amount) private returns(uint cakeHarvested) {
288         uint before = IBEP20(CAKE).balanceOf(address(this));
289         CAKE_MASTER_CHEF.deposit(pid, amount);
290         cakeHarvested = IBEP20(CAKE).balanceOf(address(this)).sub(before);
291     }
292 
293     function _deposit(uint amount, address _to) private nonReentrant notPaused updateReward(_to) {
294         require(amount > 0, "VaultBunnyBNB: amount must be greater than zero");
295         _bunnyChef.updateRewardsOf(address(this));
296 
297         _totalSupply = _totalSupply.add(amount);
298         _balances[_to] = _balances[_to].add(amount);
299         _depositedAt[_to] = block.timestamp;
300         _stakingToken.safeTransferFrom(msg.sender, address(this), amount);
301 
302         _bunnyChef.notifyDeposited(_to, amount);
303         uint cakeHarvested = _depositStakingToken(amount);
304 
305         emit Deposited(_to, amount);
306         _harvest(cakeHarvested);
307     }
308 
309     function _harvest(uint cakeAmount) private {
310         uint _before = _rewardsToken.sharesOf(address(this));
311         _rewardsToken.deposit(cakeAmount);
312         uint amount = _rewardsToken.sharesOf(address(this)).sub(_before);
313         if (amount > 0) {
314             _notifyRewardAmount(amount);
315             emit Harvested(amount);
316         }
317     }
318 
319     function _notifyRewardAmount(uint reward) private updateReward(address(0)) {
320         if (block.timestamp >= periodFinish) {
321             rewardRate = reward.div(rewardsDuration);
322         } else {
323             uint remaining = periodFinish.sub(block.timestamp);
324             uint leftover = remaining.mul(rewardRate);
325             rewardRate = reward.add(leftover).div(rewardsDuration);
326         }
327 
328         // Ensure the provided reward amount is not more than the balance in the contract.
329         // This keeps the reward rate in the right range, preventing overflows due to
330         // very high values of rewardRate in the earned and rewardsPerToken functions;
331         // Reward + leftover must be less than 2^256 / 10^18 to avoid overflow.
332         uint _balance = _rewardsToken.sharesOf(address(this));
333         require(rewardRate <= _balance.div(rewardsDuration), "VaultBunnyBNB: reward rate must be in the right range");
334 
335         lastUpdateTime = block.timestamp;
336         periodFinish = block.timestamp.add(rewardsDuration);
337         emit RewardAdded(reward);
338     }
339 
340     /* ========== SALVAGE PURPOSE ONLY ========== */
341 
342     // @dev rewardToken(CAKE) must not remain balance in this contract. So dev should be able to salvage reward token transferred by mistake.
343     function recoverToken(address tokenAddress, uint tokenAmount) external override onlyOwner {
344         require(tokenAddress != address(_stakingToken), "VaultBunnyBNB: cannot recover underlying token");
345 
346         IBEP20(tokenAddress).safeTransfer(owner(), tokenAmount);
347         emit Recovered(tokenAddress, tokenAmount);
348     }
349 
350     /* ========== MIGRATE PANCAKE V1 to V2 ========== */
351 
352     function migrate(address account, uint amount) public {
353         if (amount == 0) return;
354         _deposit(amount, account);
355     }
356 
357     function setPidToken(uint, address token) external onlyOwner {
358         require(_totalSupply == 0);
359         _stakingToken = IBEP20(token);
360 
361         _stakingToken.safeApprove(address(CAKE_MASTER_CHEF), 0);
362         _stakingToken.safeApprove(address(CAKE_MASTER_CHEF), uint(- 1));
363 
364         _stakingToken.safeApprove(address(_minter), 0);
365         _stakingToken.safeApprove(address(_minter), uint(- 1));
366     }
367 }
