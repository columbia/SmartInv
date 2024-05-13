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
43 import {PoolConstant} from "../library/PoolConstant.sol";
44 
45 import "../interfaces/IStrategy.sol";
46 import "../interfaces/IMasterChef.sol";
47 import "../interfaces/IBunnyMinter.sol";
48 
49 import "./VaultController.sol";
50 
51 
52 contract VaultFlipToCake is VaultController, IStrategy, RewardsDistributionRecipientUpgradeable, ReentrancyGuardUpgradeable {
53     using SafeMath for uint;
54     using SafeBEP20 for IBEP20;
55 
56     /* ========== CONSTANTS ============= */
57 
58     address private constant CAKE = 0x0E09FaBB73Bd3Ade0a17ECC321fD13a19e81cE82;
59     IMasterChef private constant CAKE_MASTER_CHEF = IMasterChef(0x73feaa1eE314F8c655E354234017bE2193C9E24E);
60     PoolConstant.PoolTypes public constant override poolType = PoolConstant.PoolTypes.FlipToCake;
61 
62     /* ========== STATE VARIABLES ========== */
63 
64     IStrategy private _rewardsToken;
65 
66     uint public periodFinish;
67     uint public rewardRate;
68     uint public rewardsDuration;
69     uint public lastUpdateTime;
70     uint public rewardPerTokenStored;
71 
72     mapping(address => uint) public userRewardPerTokenPaid;
73     mapping(address => uint) public rewards;
74 
75     uint private _totalSupply;
76     mapping(address => uint) private _balances;
77 
78     uint public override pid;
79     mapping(address => uint) private _depositedAt;
80 
81     /* ========== MODIFIERS ========== */
82 
83     modifier updateReward(address account) {
84         rewardPerTokenStored = rewardPerToken();
85         lastUpdateTime = lastTimeRewardApplicable();
86         if (account != address(0)) {
87             rewards[account] = earned(account);
88             userRewardPerTokenPaid[account] = rewardPerTokenStored;
89         }
90         _;
91     }
92 
93     /* ========== EVENTS ========== */
94 
95     event RewardAdded(uint reward);
96     event RewardsDurationUpdated(uint newDuration);
97 
98     /* ========== INITIALIZER ========== */
99 
100     function initialize(uint _pid, address _token) external initializer {
101         __VaultController_init(IBEP20(_token));
102         __RewardsDistributionRecipient_init();
103         __ReentrancyGuard_init();
104 
105         _stakingToken.safeApprove(address(CAKE_MASTER_CHEF), uint(- 1));
106         pid = _pid;
107 
108         rewardsDuration = 4 hours;
109 
110         rewardsDistribution = msg.sender;
111         setMinter(0x8cB88701790F650F273c8BB2Cc4c5f439cd65219);
112         setRewardsToken(0xEDfcB78e73f7bA6aD2D829bf5D462a0924da28eD);
113     }
114 
115     /* ========== VIEWS ========== */
116 
117     function totalSupply() external view override returns (uint) {
118         return _totalSupply;
119     }
120 
121     function balance() override external view returns (uint) {
122         return _totalSupply;
123     }
124 
125     function balanceOf(address account) external view override returns (uint) {
126         return _balances[account];
127     }
128 
129     function sharesOf(address account) external view override returns (uint) {
130         return _balances[account];
131     }
132 
133     function principalOf(address account) external view override returns (uint) {
134         return _balances[account];
135     }
136 
137     function depositedAt(address account) external view override returns (uint) {
138         return _depositedAt[account];
139     }
140 
141     function withdrawableBalanceOf(address account) public view override returns (uint) {
142         return _balances[account];
143     }
144 
145     function rewardsToken() external view override returns (address) {
146         return address(_rewardsToken);
147     }
148 
149     function priceShare() external view override returns (uint) {
150         return 1e18;
151     }
152 
153     function lastTimeRewardApplicable() public view returns (uint) {
154         return Math.min(block.timestamp, periodFinish);
155     }
156 
157     function rewardPerToken() public view returns (uint) {
158         if (_totalSupply == 0) {
159             return rewardPerTokenStored;
160         }
161         return
162         rewardPerTokenStored.add(
163             lastTimeRewardApplicable().sub(lastUpdateTime).mul(rewardRate).mul(1e18).div(_totalSupply)
164         );
165     }
166 
167     function earned(address account) override public view returns (uint) {
168         return _balances[account].mul(rewardPerToken().sub(userRewardPerTokenPaid[account])).div(1e18).add(rewards[account]);
169     }
170 
171     function getRewardForDuration() external view returns (uint) {
172         return rewardRate.mul(rewardsDuration);
173     }
174 
175     /* ========== MUTATIVE FUNCTIONS ========== */
176 
177     function deposit(uint amount) override public {
178         _deposit(amount, msg.sender);
179     }
180 
181     function depositAll() override external {
182         deposit(_stakingToken.balanceOf(msg.sender));
183     }
184 
185     function withdraw(uint amount) override public nonReentrant updateReward(msg.sender) {
186         require(amount > 0, "VaultFlipToCake: amount must be greater than zero");
187         _totalSupply = _totalSupply.sub(amount);
188         _balances[msg.sender] = _balances[msg.sender].sub(amount);
189         uint cakeHarvested = _withdrawStakingToken(amount);
190         uint withdrawalFee;
191         if (canMint()) {
192             uint depositTimestamp = _depositedAt[msg.sender];
193             withdrawalFee = _minter.withdrawalFee(amount, depositTimestamp);
194             if (withdrawalFee > 0) {
195                 uint performanceFee = withdrawalFee.div(100);
196                 _minter.mintForV2(address(_stakingToken), withdrawalFee.sub(performanceFee), performanceFee, msg.sender, depositTimestamp);
197                 amount = amount.sub(withdrawalFee);
198             }
199         }
200 
201         _stakingToken.safeTransfer(msg.sender, amount);
202         emit Withdrawn(msg.sender, amount, withdrawalFee);
203 
204         _harvest(cakeHarvested);
205     }
206 
207     function withdrawAll() external override {
208         uint _withdraw = withdrawableBalanceOf(msg.sender);
209         if (_withdraw > 0) {
210             withdraw(_withdraw);
211         }
212         getReward();
213     }
214 
215     function getReward() public override nonReentrant updateReward(msg.sender) {
216         uint reward = rewards[msg.sender];
217         if (reward > 0) {
218             rewards[msg.sender] = 0;
219             uint before = IBEP20(CAKE).balanceOf(address(this));
220             _rewardsToken.withdraw(reward);
221             uint cakeBalance = IBEP20(CAKE).balanceOf(address(this)).sub(before);
222             uint performanceFee;
223 
224             if (canMint()) {
225                 performanceFee = _minter.performanceFee(cakeBalance);
226                 _minter.mintForV2(CAKE, 0, performanceFee, msg.sender, _depositedAt[msg.sender]);
227             }
228 
229             IBEP20(CAKE).safeTransfer(msg.sender, cakeBalance.sub(performanceFee));
230             emit ProfitPaid(msg.sender, cakeBalance, performanceFee);
231         }
232     }
233 
234     function harvest() public override {
235         uint cakeHarvested = _withdrawStakingToken(0);
236         _harvest(cakeHarvested);
237     }
238 
239     /* ========== RESTRICTED FUNCTIONS ========== */
240 
241     function setMinter(address newMinter) override public onlyOwner {
242         VaultController.setMinter(newMinter);
243         if (newMinter != address(0)) {
244             IBEP20(CAKE).safeApprove(newMinter, 0);
245             IBEP20(CAKE).safeApprove(newMinter, uint(- 1));
246         }
247     }
248 
249     function setRewardsToken(address newRewardsToken) public onlyOwner {
250         require(address(_rewardsToken) == address(0), "VaultFlipToCake: rewards token already set");
251 
252         _rewardsToken = IStrategy(newRewardsToken);
253         IBEP20(CAKE).safeApprove(newRewardsToken, 0);
254         IBEP20(CAKE).safeApprove(newRewardsToken, uint(- 1));
255     }
256 
257     function notifyRewardAmount(uint reward) public override onlyRewardsDistribution {
258         _notifyRewardAmount(reward);
259     }
260 
261     function setRewardsDuration(uint _rewardsDuration) external onlyOwner {
262         require(periodFinish == 0 || block.timestamp > periodFinish, "VaultFlipToCake: reward duration can only be updated after the period ends");
263         rewardsDuration = _rewardsDuration;
264         emit RewardsDurationUpdated(rewardsDuration);
265     }
266 
267     /* ========== PRIVATE FUNCTIONS ========== */
268 
269     function _deposit(uint amount, address _to) private nonReentrant notPaused updateReward(_to) {
270         require(amount > 0, "VaultFlipToCake: amount must be greater than zero");
271         _totalSupply = _totalSupply.add(amount);
272         _balances[_to] = _balances[_to].add(amount);
273         _depositedAt[_to] = block.timestamp;
274         _stakingToken.safeTransferFrom(msg.sender, address(this), amount);
275         uint cakeHarvested = _depositStakingToken(amount);
276         emit Deposited(_to, amount);
277 
278         _harvest(cakeHarvested);
279     }
280 
281     function _depositStakingToken(uint amount) private returns (uint cakeHarvested) {
282         uint before = IBEP20(CAKE).balanceOf(address(this));
283         CAKE_MASTER_CHEF.deposit(pid, amount);
284         cakeHarvested = IBEP20(CAKE).balanceOf(address(this)).sub(before);
285     }
286 
287     function _withdrawStakingToken(uint amount) private returns (uint cakeHarvested) {
288         uint before = IBEP20(CAKE).balanceOf(address(this));
289         CAKE_MASTER_CHEF.withdraw(pid, amount);
290         cakeHarvested = IBEP20(CAKE).balanceOf(address(this)).sub(before);
291     }
292 
293     function _harvest(uint cakeAmount) private {
294         uint _before = _rewardsToken.sharesOf(address(this));
295         _rewardsToken.deposit(cakeAmount);
296         uint amount = _rewardsToken.sharesOf(address(this)).sub(_before);
297         if (amount > 0) {
298             _notifyRewardAmount(amount);
299             emit Harvested(amount);
300         }
301     }
302 
303     function _notifyRewardAmount(uint reward) private updateReward(address(0)) {
304         if (block.timestamp >= periodFinish) {
305             rewardRate = reward.div(rewardsDuration);
306         } else {
307             uint remaining = periodFinish.sub(block.timestamp);
308             uint leftover = remaining.mul(rewardRate);
309             rewardRate = reward.add(leftover).div(rewardsDuration);
310         }
311 
312         // Ensure the provided reward amount is not more than the balance in the contract.
313         // This keeps the reward rate in the right range, preventing overflows due to
314         // very high values of rewardRate in the earned and rewardsPerToken functions;
315         // Reward + leftover must be less than 2^256 / 10^18 to avoid overflow.
316         uint _balance = _rewardsToken.sharesOf(address(this));
317         require(rewardRate <= _balance.div(rewardsDuration), "VaultFlipToCake: reward rate must be in the right range");
318 
319         lastUpdateTime = block.timestamp;
320         periodFinish = block.timestamp.add(rewardsDuration);
321         emit RewardAdded(reward);
322     }
323 
324     /* ========== SALVAGE PURPOSE ONLY ========== */
325 
326     // @dev rewardToken(CAKE) must not remain balance in this contract. So dev should be able to salvage reward token transferred by mistake.
327     function recoverToken(address tokenAddress, uint tokenAmount) external override onlyOwner {
328         require(tokenAddress != address(_stakingToken), "VaultFlipToCake: cannot recover underlying token");
329 
330         IBEP20(tokenAddress).safeTransfer(owner(), tokenAmount);
331         emit Recovered(tokenAddress, tokenAmount);
332     }
333 }
