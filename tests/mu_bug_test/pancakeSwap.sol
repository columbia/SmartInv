1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.6.12;
3 pragma experimental ABIEncoderV2;
4 
5 import "./Math.sol";
6 import "./SafeMath.sol";
7 import "./SafeBEP20.sol";
8 import "./ReentrancyGuard.sol";
9 
10 import "./RewardsDistributionRecipient.sol";
11 import "./Pausable.sol";
12 import "./IStakingRewards.sol";
13 import "./IStrategy.sol";
14 import "./IStrategyHelper.sol";
15 import "./IMasterChef.sol";
16 import "./ICakeVault.sol";
17 import "./IBunnyMinter.sol";
18 
19 contract CakeFlipVault is IStrategy, RewardsDistributionRecipient, ReentrancyGuard, Pausable {
20     using SafeMath for uint256;
21     using SafeBEP20 for IBEP20;
22 
23  
24     ICakeVault public rewardsToken;
25     IBEP20 public stakingToken;
26     uint256 public periodFinish = 0;
27     uint256 public rewardRate = 0;
28     uint256 public rewardsDuration = 2 hours;
29     uint256 public lastUpdateTime;
30     uint256 public rewardPerTokenStored;
31 
32     mapping(address => uint256) public userRewardPerTokenPaid;
33     mapping(address => uint256) public rewards;
34 
35     uint256 private _totalSupply;
36     mapping(address => uint256) private _balances;
37 
38     address private constant CAKE = 0x0E09FaBB73Bd3Ade0a17ECC321fD13a19e81cE82;
39     IMasterChef private constant CAKE_MASTER_CHEF = IMasterChef(0x73feaa1eE314F8c655E354234017bE2193C9E24E);
40     uint public poolId;
41     address public keeper = 0x793074D9799DC3c6039F8056F1Ba884a73462051;
42     mapping (address => uint) public depositedAt;
43 
44     /* ========== BUNNY HELPER / MINTER ========= */
45     IStrategyHelper public helper = IStrategyHelper(0x154d803C328fFd70ef5df52cb027d82821520ECE);
46     IBunnyMinter public minter;
47 
48 
49     /* ========== CONSTRUCTOR ========== */
50 
51     constructor(uint _pid) public {
52         (address _token,,,) = CAKE_MASTER_CHEF.poolInfo(_pid);
53         stakingToken = IBEP20(_token);
54         stakingToken.safeApprove(address(CAKE_MASTER_CHEF), uint(~0));
55         poolId = _pid;
56 
57         rewardsDistribution = msg.sender;
58         setMinter(IBunnyMinter(0x0B4A714AAf59E46cb1900E3C031017Fd72667EfE));
59         setRewardsToken(0x9a8235aDA127F6B5532387A029235640D1419e8D);
60     }
61 
62     function totalSupply() external view returns (uint256) {
63         return _totalSupply;
64     }
65 
66     function balance() override external view returns (uint) {
67         return _totalSupply;
68     }
69 
70     function balanceOf(address account) override external view returns (uint256) {
71         return _balances[account];
72     }
73 
74     function principalOf(address account) override external view returns (uint256) {
75         return _balances[account];
76     }
77 
78     function withdrawableBalanceOf(address account) override public view returns (uint) {
79         return _balances[account];
80     }
81 
82     function profitOf(address account) override public view returns (uint _usd, uint _bunny, uint _bnb) {
83         uint cakeVaultPrice = rewardsToken.priceShare();
84         uint _earned = earned(account);
85         uint amount = _earned.mul(cakeVaultPrice).div(1e18);
86 
87         if (address(minter) != address(0) && minter.isMinter(address(this))) {
88             uint performanceFee = minter.performanceFee(amount);
89             // cake amount
90             _usd = amount.sub(performanceFee);
91 
92             uint bnbValue = helper.tvlInBNB(CAKE, performanceFee);
93             // bunny amount
94             _bunny = minter.amountBunnyToMint(bnbValue);
95         } else {
96             _usd = amount;
97             _bunny = 0;
98         }
99 
100         _bnb = 0;
101     }
102 
103     function tvl() override public view returns (uint) {
104         uint stakingTVL = helper.tvl(address(stakingToken), _totalSupply);
105 
106         uint price = rewardsToken.priceShare();
107         uint earned = rewardsToken.balanceOf(address(this)).mul(price).div(1e18);
108         uint rewardTVL = helper.tvl(CAKE, earned);
109 
110         return stakingTVL.add(rewardTVL);
111     }
112 
113     function tvlStaking() external view returns (uint) {
114         return helper.tvl(address(stakingToken), _totalSupply);
115     }
116 
117     function tvlReward() external view returns (uint) {
118         uint price = rewardsToken.priceShare();
119         uint earned = rewardsToken.balanceOf(address(this)).mul(price).div(1e18);
120         return helper.tvl(CAKE, earned);
121     }
122 
123     function apy() override public view returns(uint _usd, uint _bunny, uint _bnb) {
124         uint dailyAPY = helper.compoundingAPY(poolId, 365 days).div(365);
125 
126         uint cakeAPY = helper.compoundingAPY(0, 1 days);
127         uint cakeDailyAPY = helper.compoundingAPY(0, 365 days).div(365);
128 
129     
130 
131         _usd = dailyAPY.mul(cakeAPY).div(cakeDailyAPY);
132         _bunny = 0;
133         _bnb = 0;
134     }
135 
136     function lastTimeRewardApplicable() public view returns (uint256) {
137         return Math.min(block.timestamp, periodFinish);
138     }
139 
140     function rewardPerToken() public view returns (uint256) {
141         if (_totalSupply == 0) {
142             return rewardPerTokenStored;
143         }
144         return
145         rewardPerTokenStored.add(
146             lastTimeRewardApplicable().sub(lastUpdateTime).mul(rewardRate).mul(1e18).div(_totalSupply)
147         );
148     }
149 
150     function earned(address account) public view returns (uint256) {
151         return _balances[account].mul(rewardPerToken().sub(userRewardPerTokenPaid[account])).div(1e18).add(rewards[account]);
152     }
153 
154     function getRewardForDuration() external view returns (uint256) {
155         return rewardRate.mul(rewardsDuration);
156     }
157 
158     function _deposit(uint256 amount, address _to) private nonReentrant notPaused updateReward(_to) {
159         require(amount > 0, "amount");
160         _totalSupply = _totalSupply.add(amount);
161         _balances[_to] = _balances[_to].add(amount);
162         depositedAt[_to] = block.timestamp;
163         stakingToken.safeTransferFrom(msg.sender, address(this), amount);
164         CAKE_MASTER_CHEF.deposit(poolId, amount);
165         emit Staked(_to, amount);
166 
167         _harvest();
168     }
169 
170     function deposit(uint256 amount) override public {
171         _deposit(amount, msg.sender);
172     }
173 
174     function depositAll() override external {
175         deposit(stakingToken.balanceOf(msg.sender));
176     }
177 
178     function withdraw(uint256 amount) override public nonReentrant updateReward(msg.sender) {
179         require(amount > 0, "amount");
180         _totalSupply = _totalSupply.sub(amount);
181         _balances[msg.sender] = _balances[msg.sender].sub(amount);
182         CAKE_MASTER_CHEF.withdraw(poolId, amount);
183 
184         if (address(minter) != address(0) && minter.isMinter(address(this))) {
185             uint _depositedAt = depositedAt[msg.sender];
186             uint withdrawalFee = minter.withdrawalFee(amount, _depositedAt);
187             if (withdrawalFee > 0) {
188                 uint performanceFee = withdrawalFee.div(100);
189                 minter.mintFor(address(stakingToken), withdrawalFee.sub(performanceFee), performanceFee, msg.sender, _depositedAt);
190                 amount = amount.sub(withdrawalFee);
191             }
192         }
193 
194         stakingToken.safeTransfer(msg.sender, amount);
195         emit Withdrawn(msg.sender, amount);
196 
197         _harvest();
198     }
199 
200     function withdrawAll() override external {
201         uint _withdraw = withdrawableBalanceOf(msg.sender);
202         if (_withdraw > 0) {
203             withdraw(_withdraw);
204         }
205         getReward();
206     }
207 
208     function getReward() override public nonReentrant updateReward(msg.sender) {
209         uint256 reward = rewards[msg.sender];
210         if (reward > 0) {
211             rewards[msg.sender] = 0;
212             rewardsToken.withdraw(reward);
213             uint cakeBalance = IBEP20(CAKE).balanceOf(address(this));
214 
215             if (address(minter) != address(0) && minter.isMinter(address(this))) {
216                 uint performanceFee = minter.performanceFee(cakeBalance);
217                 minter.mintFor(CAKE, 0, performanceFee, msg.sender, depositedAt[msg.sender]);
218                 cakeBalance = cakeBalance.sub(performanceFee);
219             }
220 
221             IBEP20(CAKE).safeTransfer(msg.sender, cakeBalance);
222             emit RewardPaid(msg.sender, cakeBalance);
223         }
224     }
225 
226     function harvest() override public {
227         CAKE_MASTER_CHEF.withdraw(poolId, 0);
228         _harvest();
229     }
230 
231     function _harvest() private {
232         uint cakeAmount = IBEP20(CAKE).balanceOf(address(this));
233         uint _before = rewardsToken.sharesOf(address(this));
234         rewardsToken.deposit(cakeAmount);
235         uint amount = rewardsToken.sharesOf(address(this)).sub(_before);
236         if (amount > 0) {
237             _notifyRewardAmount(amount);
238         }
239     }
240 
241     function info(address account) override external view returns(UserInfo memory) {
242         UserInfo memory userInfo;
243 
244         userInfo.balance = _balances[account];
245         userInfo.principal = _balances[account];
246         userInfo.available = withdrawableBalanceOf(account);
247 
248         Profit memory profit;
249         (uint usd, uint bunny, uint bnb) = profitOf(account);
250         profit.usd = usd;
251         profit.bunny = bunny;
252         profit.bnb = bnb;
253         userInfo.profit = profit;
254 
255         userInfo.poolTVL = tvl();
256 
257         APY memory poolAPY;
258         (usd, bunny, bnb) = apy();
259         poolAPY.usd = usd;
260         poolAPY.bunny = bunny;
261         poolAPY.bnb = bnb;
262         userInfo.poolAPY = poolAPY;
263 
264         return userInfo;
265     }
266 
267     /* ========== RESTRICTED FUNCTIONS ========== */
268     function setKeeper(address _keeper) external {
269         require(msg.sender == _keeper || msg.sender == owner(), 'auth');
270         require(_keeper != address(0), 'zero address');
271         keeper = _keeper;
272     }
273 
274     function setMinter(IBunnyMinter _minter) public onlyOwner {
275         // can zero
276         minter = _minter;
277         if (address(_minter) != address(0)) {
278             IBEP20(CAKE).safeApprove(address(_minter), 0);
279             IBEP20(CAKE).safeApprove(address(_minter), uint(~0));
280 
281             stakingToken.safeApprove(address(_minter), 0);
282             stakingToken.safeApprove(address(_minter), uint(~0));
283         }
284     }
285 
286     function setRewardsToken(address _rewardsToken) private onlyOwner {
287         require(address(rewardsToken) == address(0), "set rewards token already");
288 
289         rewardsToken = ICakeVault(_rewardsToken);
290 
291         IBEP20(CAKE).safeApprove(_rewardsToken, 0);
292         IBEP20(CAKE).safeApprove(_rewardsToken, uint(~0));
293     }
294 
295     function setHelper(IStrategyHelper _helper) external onlyOwner {
296         require(address(_helper) != address(0), "zero address");
297         helper = _helper;
298     }
299 
300     function notifyRewardAmount(uint256 reward) override public onlyRewardsDistribution {
301         _notifyRewardAmount(reward);
302     }
303 
304     function _notifyRewardAmount(uint256 reward) private updateReward(address(0)) {
305         if (block.timestamp >= periodFinish) {
306             rewardRate = reward.div(rewardsDuration);
307         } else {
308             uint256 remaining = periodFinish.sub(block.timestamp);
309             uint256 leftover = remaining.mul(rewardRate);
310             rewardRate = reward.add(leftover).div(rewardsDuration);
311         }
312 
313         // Ensure the provided reward amount is not more than the balance in the contract.
314         // This keeps the reward rate in the right range, preventing overflows due to
315         // very high values of rewardRate in the earned and rewardsPerToken functions;
316         // Reward + leftover must be less than 2^256 / 10^18 to avoid overflow.
317         uint _balance = rewardsToken.sharesOf(address(this));
318         require(rewardRate <= _balance.div(rewardsDuration), "reward");
319 
320         lastUpdateTime = block.timestamp;
321         periodFinish = block.timestamp.add(rewardsDuration);
322         emit RewardAdded(reward);
323     }
324 
325     function recoverBEP20(address tokenAddress, uint256 tokenAmount) external onlyOwner {
326         require(tokenAddress != address(stakingToken) && tokenAddress != address(rewardsToken), "tokenAddress");
327         IBEP20(tokenAddress).safeTransfer(owner(), tokenAmount);
328         emit Recovered(tokenAddress, tokenAmount);
329     }
330 
331     function setRewardsDuration(uint256 _rewardsDuration) external onlyOwner {
332         require(periodFinish == 0 || block.timestamp > periodFinish, "period");
333         rewardsDuration = _rewardsDuration;
334         emit RewardsDurationUpdated(rewardsDuration);
335     }
336 
337 
338     modifier updateReward(address account) {
339         rewardPerTokenStored = rewardPerToken();
340         lastUpdateTime = lastTimeRewardApplicable();
341         if (account != address(0)) {
342             rewards[account] = earned(account);
343             userRewardPerTokenPaid[account] = rewardPerTokenStored;
344         }
345         _;
346     }
347 
348 
349     event RewardAdded(uint256 reward);
350     event Staked(address indexed user, uint256 amount);
351     event Withdrawn(address indexed user, uint256 amount);
352     event RewardPaid(address indexed user, uint256 reward);
353     event RewardsDurationUpdated(uint256 newDuration);
354     event Recovered(address token, uint256 amount);
355 }