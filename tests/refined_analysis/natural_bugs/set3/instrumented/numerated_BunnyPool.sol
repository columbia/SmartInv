1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.6.12;
3 pragma experimental ABIEncoderV2;
4 
5 import "@openzeppelin/contracts/math/Math.sol";
6 import "@pancakeswap/pancake-swap-lib/contracts/math/SafeMath.sol";
7 import "@pancakeswap/pancake-swap-lib/contracts/token/BEP20/SafeBEP20.sol";
8 import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
9 
10 import "../library/legacy/RewardsDistributionRecipient.sol";
11 import "../library/legacy/Pausable.sol";
12 import "../interfaces/legacy/IStrategyHelper.sol";
13 import "../interfaces/IPancakeRouter02.sol";
14 import "../interfaces/legacy/IStrategyLegacy.sol";
15 
16 interface IPresale {
17     function totalBalance() view external returns(uint);
18     function flipToken() view external returns(address);
19 }
20 
21 contract BunnyPool is IStrategyLegacy, RewardsDistributionRecipient, ReentrancyGuard, Pausable {
22     using SafeMath for uint256;
23     using SafeBEP20 for IBEP20;
24 
25     /* ========== STATE VARIABLES ========== */
26 
27     IBEP20 public rewardsToken; // bunny/bnb flip
28     IBEP20 public constant stakingToken = IBEP20(0xC9849E6fdB743d08fAeE3E34dd2D1bc69EA11a51);   // bunny
29     uint256 public periodFinish = 0;
30     uint256 public rewardRate = 0;
31     uint256 public rewardsDuration = 90 days;
32     uint256 public lastUpdateTime;
33     uint256 public rewardPerTokenStored;
34 
35     mapping(address => uint256) public userRewardPerTokenPaid;
36     mapping(address => uint256) public rewards;
37 
38     uint256 private _totalSupply;
39     mapping(address => uint256) private _balances;
40 
41     mapping(address => bool) private _stakePermission;
42 
43     /* ========== PRESALE ============== */
44     address private constant presaleContract = 0x641414e2a04c8f8EbBf49eD47cc87dccbA42BF07;
45     address private constant deadAddress = 0x000000000000000000000000000000000000dEaD;
46     mapping(address => uint256) private _presaleBalance;
47     uint private constant timestamp2HoursAfterPresaleEnds = 1605585600 + (2 hours);
48     uint private constant timestamp90DaysAfterPresaleEnds = 1605585600 + (90 days);
49 
50     /* ========== BUNNY HELPER ========= */
51 
52     IStrategyHelper public helper = IStrategyHelper(0xA84c09C1a2cF4918CaEf625682B429398b97A1a0);
53     IPancakeRouter02 private constant ROUTER_V1_DEPRECATED = IPancakeRouter02(0x05fF2B0DB69458A0750badebc4f9e13aDd608C7F);
54 
55     /* ========== CONSTRUCTOR ========== */
56 
57     constructor() public {
58         rewardsDistribution = msg.sender;
59 
60         _stakePermission[msg.sender] = true;
61         _stakePermission[presaleContract] = true;
62 
63         stakingToken.safeApprove(address(ROUTER_V1_DEPRECATED), uint(- 1));
64     }
65 
66     /* ========== VIEWS ========== */
67 
68     function totalSupply() external view returns (uint256) {
69         return _totalSupply;
70     }
71 
72     function balance() override external view returns (uint) {
73         return _totalSupply;
74     }
75 
76     function balanceOf(address account) override external view returns (uint256) {
77         return _balances[account];
78     }
79 
80     function presaleBalanceOf(address account) external view returns(uint256) {
81         return _presaleBalance[account];
82     }
83 
84     function principalOf(address account) override external view returns (uint256) {
85         return _balances[account];
86     }
87 
88     function withdrawableBalanceOf(address account) override public view returns (uint) {
89         if (block.timestamp > timestamp90DaysAfterPresaleEnds) {
90             // unlock all presale bunny after 90 days of presale
91             return _balances[account];
92         } else if (block.timestamp < timestamp2HoursAfterPresaleEnds) {
93             return _balances[account].sub(_presaleBalance[account]);
94         } else {
95             uint soldInPresale = IPresale(presaleContract).totalBalance().div(2).mul(3); // mint 150% of presale for making flip token
96             uint bunnySupply = stakingToken.totalSupply().sub(stakingToken.balanceOf(deadAddress));
97             if (soldInPresale >= bunnySupply) {
98                 return _balances[account].sub(_presaleBalance[account]);
99             }
100             uint bunnyNewMint = bunnySupply.sub(soldInPresale);
101             if (bunnyNewMint >= soldInPresale) {
102                 return _balances[account];
103             }
104 
105             uint lockedRatio = (soldInPresale.sub(bunnyNewMint)).mul(1e18).div(soldInPresale);
106             uint lockedBalance = _presaleBalance[account].mul(lockedRatio).div(1e18);
107             return _balances[account].sub(lockedBalance);
108         }
109     }
110 
111     function profitOf(address account) override public view returns (uint _usd, uint _bunny, uint _bnb) {
112         _usd = 0;
113         _bunny = 0;
114         _bnb = helper.tvlInBNB(address(rewardsToken), earned(account));
115     }
116 
117     function tvl() override public view returns (uint) {
118         uint price = helper.tokenPriceInBNB(address(stakingToken));
119         return _totalSupply.mul(price).div(1e18);
120     }
121 
122     function apy() override public view returns(uint _usd, uint _bunny, uint _bnb) {
123         uint tokenDecimals = 1e18;
124         uint __totalSupply = _totalSupply;
125         if (__totalSupply == 0) {
126             __totalSupply = tokenDecimals;
127         }
128 
129         uint rewardPerTokenPerSecond = rewardRate.mul(tokenDecimals).div(__totalSupply);
130         uint bunnyPrice = helper.tokenPriceInBNB(address(stakingToken));
131         uint flipPrice = helper.tvlInBNB(address(rewardsToken), 1e18);
132 
133         _usd = 0;
134         _bunny = 0;
135         _bnb = rewardPerTokenPerSecond.mul(365 days).mul(flipPrice).div(bunnyPrice);
136     }
137 
138     function lastTimeRewardApplicable() public view returns (uint256) {
139         return Math.min(block.timestamp, periodFinish);
140     }
141 
142     function rewardPerToken() public view returns (uint256) {
143         if (_totalSupply == 0) {
144             return rewardPerTokenStored;
145         }
146         return
147         rewardPerTokenStored.add(
148             lastTimeRewardApplicable().sub(lastUpdateTime).mul(rewardRate).mul(1e18).div(_totalSupply)
149         );
150     }
151 
152     function earned(address account) public view returns (uint256) {
153         return _balances[account].mul(rewardPerToken().sub(userRewardPerTokenPaid[account])).div(1e18).add(rewards[account]);
154     }
155 
156     function getRewardForDuration() external view returns (uint256) {
157         return rewardRate.mul(rewardsDuration);
158     }
159 
160     /* ========== MUTATIVE FUNCTIONS ========== */
161     function _deposit(uint256 amount, address _to) private nonReentrant notPaused updateReward(_to) {
162         require(amount > 0, "amount");
163         _totalSupply = _totalSupply.add(amount);
164         _balances[_to] = _balances[_to].add(amount);
165         stakingToken.safeTransferFrom(msg.sender, address(this), amount);
166         emit Staked(_to, amount);
167     }
168 
169     function deposit(uint256 amount) override public {
170         _deposit(amount, msg.sender);
171     }
172 
173     function depositAll() override external {
174         deposit(stakingToken.balanceOf(msg.sender));
175     }
176 
177     function withdraw(uint256 amount) override public nonReentrant updateReward(msg.sender) {
178         require(amount > 0, "amount");
179         require(amount <= withdrawableBalanceOf(msg.sender), "locked");
180         _totalSupply = _totalSupply.sub(amount);
181         _balances[msg.sender] = _balances[msg.sender].sub(amount);
182         stakingToken.safeTransfer(msg.sender, amount);
183         emit Withdrawn(msg.sender, amount);
184     }
185 
186     function withdrawAll() override external {
187         uint _withdraw = withdrawableBalanceOf(msg.sender);
188         if (_withdraw > 0) {
189             withdraw(_withdraw);
190         }
191         getReward();
192     }
193 
194     function getReward() override public nonReentrant updateReward(msg.sender) {
195         uint256 reward = rewards[msg.sender];
196         if (reward > 0) {
197             rewards[msg.sender] = 0;
198             reward = _flipToWBNB(reward);
199             IBEP20(ROUTER_V1_DEPRECATED.WETH()).safeTransfer(msg.sender, reward);
200             emit RewardPaid(msg.sender, reward);
201         }
202     }
203 
204     function _flipToWBNB(uint amount) private returns(uint reward) {
205         address wbnb = ROUTER_V1_DEPRECATED.WETH();
206         (uint rewardBunny,) = ROUTER_V1_DEPRECATED.removeLiquidity(
207             address(stakingToken), wbnb,
208             amount, 0, 0, address(this), block.timestamp);
209         address[] memory path = new address[](2);
210         path[0] = address(stakingToken);
211         path[1] = wbnb;
212         ROUTER_V1_DEPRECATED.swapExactTokensForTokens(rewardBunny, 0, path, address(this), block.timestamp);
213 
214         reward = IBEP20(wbnb).balanceOf(address(this));
215     }
216 
217     function harvest() override external {}
218 
219     function info(address account) override external view returns(UserInfo memory) {
220         UserInfo memory userInfo;
221 
222         userInfo.balance = _balances[account];
223         userInfo.principal = _balances[account];
224         userInfo.available = withdrawableBalanceOf(account);
225 
226         Profit memory profit;
227         (uint usd, uint bunny, uint bnb) = profitOf(account);
228         profit.usd = usd;
229         profit.bunny = bunny;
230         profit.bnb = bnb;
231         userInfo.profit = profit;
232 
233         userInfo.poolTVL = tvl();
234 
235         APY memory poolAPY;
236         (usd, bunny, bnb) = apy();
237         poolAPY.usd = usd;
238         poolAPY.bunny = bunny;
239         poolAPY.bnb = bnb;
240         userInfo.poolAPY = poolAPY;
241 
242         return userInfo;
243     }
244 
245     /* ========== RESTRICTED FUNCTIONS ========== */
246     function setRewardsToken(address _rewardsToken) external onlyOwner {
247         require(address(rewardsToken) == address(0), "set rewards token already");
248 
249         rewardsToken = IBEP20(_rewardsToken);
250         IBEP20(_rewardsToken).safeApprove(address(ROUTER_V1_DEPRECATED), uint(- 1));
251     }
252 
253     function setHelper(IStrategyHelper _helper) external onlyOwner {
254         require(address(_helper) != address(0), "zero address");
255         helper = _helper;
256     }
257 
258     function setStakePermission(address _address, bool permission) external onlyOwner {
259         _stakePermission[_address] = permission;
260     }
261 
262     function stakeTo(uint256 amount, address _to) external canStakeTo {
263         _deposit(amount, _to);
264         if (msg.sender == presaleContract) {
265             _presaleBalance[_to] = _presaleBalance[_to].add(amount);
266         }
267     }
268 
269     function notifyRewardAmount(uint256 reward) override external onlyRewardsDistribution updateReward(address(0)) {
270         if (block.timestamp >= periodFinish) {
271             rewardRate = reward.div(rewardsDuration);
272         } else {
273             uint256 remaining = periodFinish.sub(block.timestamp);
274             uint256 leftover = remaining.mul(rewardRate);
275             rewardRate = reward.add(leftover).div(rewardsDuration);
276         }
277 
278         // Ensure the provided reward amount is not more than the balance in the contract.
279         // This keeps the reward rate in the right range, preventing overflows due to
280         // very high values of rewardRate in the earned and rewardsPerToken functions;
281         // Reward + leftover must be less than 2^256 / 10^18 to avoid overflow.
282         uint _balance = rewardsToken.balanceOf(address(this));
283         require(rewardRate <= _balance.div(rewardsDuration), "reward");
284 
285         lastUpdateTime = block.timestamp;
286         periodFinish = block.timestamp.add(rewardsDuration);
287         emit RewardAdded(reward);
288     }
289 
290     function recoverBEP20(address tokenAddress, uint256 tokenAmount) external onlyOwner {
291         require(tokenAddress != address(stakingToken) && tokenAddress != address(rewardsToken), "tokenAddress");
292         IBEP20(tokenAddress).safeTransfer(owner(), tokenAmount);
293         emit Recovered(tokenAddress, tokenAmount);
294     }
295 
296     function setRewardsDuration(uint256 _rewardsDuration) external onlyOwner {
297         require(periodFinish == 0 || block.timestamp > periodFinish, "period");
298         rewardsDuration = _rewardsDuration;
299         emit RewardsDurationUpdated(rewardsDuration);
300     }
301 
302     /* ========== MODIFIERS ========== */
303 
304     modifier updateReward(address account) {
305         rewardPerTokenStored = rewardPerToken();
306         lastUpdateTime = lastTimeRewardApplicable();
307         if (account != address(0)) {
308             rewards[account] = earned(account);
309             userRewardPerTokenPaid[account] = rewardPerTokenStored;
310         }
311         _;
312     }
313 
314     modifier canStakeTo() {
315         require(_stakePermission[msg.sender], 'auth');
316         _;
317     }
318 
319     /* ========== EVENTS ========== */
320 
321     event RewardAdded(uint256 reward);
322     event Staked(address indexed user, uint256 amount);
323     event Withdrawn(address indexed user, uint256 amount);
324     event RewardPaid(address indexed user, uint256 reward);
325     event RewardsDurationUpdated(uint256 newDuration);
326     event Recovered(address token, uint256 amount);
327 }
