1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.6.12;
3 pragma experimental ABIEncoderV2;
4 
5 import "@openzeppelin/contracts/math/Math.sol";
6 import "@pancakeswap/pancake-swap-lib/contracts/math/SafeMath.sol";
7 import "@pancakeswap/pancake-swap-lib/contracts/token/BEP20/SafeBEP20.sol";
8 
9 import "@openzeppelin/contracts-upgradeable/utils/ReentrancyGuardUpgradeable.sol";
10 import "../library/RewardsDistributionRecipientUpgradeable.sol";
11 import "../library/PausableUpgradeable.sol";
12 
13 import "../interfaces/IPriceCalculator.sol";
14 import "../interfaces/IPresaleLocker.sol";
15 
16 
17 contract VaultQBTBNB is IPresaleLocker, RewardsDistributionRecipientUpgradeable, ReentrancyGuardUpgradeable, PausableUpgradeable {
18     using SafeMath for uint256;
19     using SafeBEP20 for IBEP20;
20 
21     /* ========== CONSTANTS ========== */
22 
23     address public constant QBT = 0x17B7163cf1Dbd286E262ddc68b553D899B93f526; // QBT
24     IBEP20 public constant stakingToken = IBEP20(0x67EFeF66A55c4562144B9AcfCFbc62F9E4269b3e); // QBT-BNB
25     IPriceCalculator public constant priceCalculator = IPriceCalculator(0xF5BF8A9249e3cc4cB684E3f23db9669323d4FB7d);
26 
27     /* ========== STATE VARIABLES ========== */
28 
29     IBEP20 public rewardsToken;
30     uint256 public periodFinish;
31     uint256 public rewardRate;
32     uint256 public rewardsDuration;
33     uint256 public lastUpdateTime;
34     uint256 public rewardPerTokenStored;
35 
36     mapping(address => uint256) public userRewardPerTokenPaid;
37     mapping(address => uint256) public rewards;
38 
39     uint256 private _totalSupply;
40     mapping(address => uint256) private _balances;
41 
42     /* ========== PRESALE ========== */
43 
44     mapping(address => uint256) private _presaleBalances;
45     uint256 public presaleEndTime; //1626652800 2021-07-19 00:00:00 UTC
46     address public presaleContract;
47 
48     /* ========== MODIFIERS ========== */
49 
50     modifier onlyPresale {
51         require(msg.sender == presaleContract, "VaultQBTBNB: no presale contract");
52         _;
53     }
54 
55     modifier updateReward(address account) {
56         rewardPerTokenStored = rewardPerToken();
57         lastUpdateTime = lastTimeRewardApplicable();
58         if (account != address(0)) {
59             rewards[account] = earned(account);
60             userRewardPerTokenPaid[account] = rewardPerTokenStored;
61         }
62         _;
63     }
64 
65     /* ========== INITIALIZER ========== */
66 
67     function initialize() external initializer {
68         __RewardsDistributionRecipient_init();
69         __ReentrancyGuard_init();
70         __PausableUpgradeable_init();
71 
72         periodFinish = 0;
73         rewardRate = 0;
74         rewardsDuration = 30 days;
75 
76         rewardsDistribution = msg.sender;
77     }
78 
79     /* ========== VIEWS ========== */
80 
81     function totalSupply() external view returns (uint256) {
82         return _totalSupply;
83     }
84 
85     function balance() external view returns (uint) {
86         return _totalSupply;
87     }
88 
89     function balanceOf(address account) override external view returns (uint256) {
90         return _balances[account];
91     }
92 
93     function principalOf(address account) external view returns (uint256) {
94         return _balances[account];
95     }
96 
97     function presaleBalanceOf(address account) external view returns (uint256) {
98         return _presaleBalances[account];
99     }
100 
101     function withdrawableBalanceOf(address account) public view override returns (uint) {
102         if (block.timestamp <= presaleEndTime) {
103             return 0;
104         }
105 
106         if (block.timestamp > presaleEndTime + 3 days) {
107             return _balances[account];
108         } else {
109             uint withdrawablePresaleBalance = _presaleBalances[account].mul((block.timestamp).sub(presaleEndTime)).div(rewardsDuration);
110             return (_balances[account].add(withdrawablePresaleBalance)).sub(_presaleBalances[account]);
111         }
112     }
113 
114     function lastTimeRewardApplicable() public view returns (uint256) {
115         return Math.min(block.timestamp, periodFinish);
116     }
117 
118     function rewardPerToken() public view returns (uint256) {
119         if (_totalSupply == 0) {
120             return rewardPerTokenStored;
121         }
122 
123         return
124         rewardPerTokenStored.add(
125             lastTimeRewardApplicable().sub(lastUpdateTime).mul(rewardRate).mul(1e18).div(_totalSupply)
126         );
127     }
128 
129     function earned(address account) public view returns (uint256) {
130         return _balances[account].mul(rewardPerToken().sub(userRewardPerTokenPaid[account])).div(1e18).add(rewards[account]);
131     }
132 
133     function getRewardForDuration() external view returns (uint256) {
134         return rewardRate.mul(rewardsDuration);
135     }
136 
137     /* ========== MUTATIVE FUNCTIONS ========== */
138 
139     function deposit(uint256 amount) public {
140         _deposit(amount, msg.sender);
141     }
142 
143     function depositAll() external {
144         deposit(stakingToken.balanceOf(msg.sender));
145     }
146 
147     function withdraw(uint256 amount) override public nonReentrant updateReward(msg.sender) {
148         require(amount > 0, "VaultQBTBNB: invalid withdraw amount");
149         require(amount <= withdrawableBalanceOf(msg.sender), "VaultQBTBNB: exceed withdrawable balance");
150         _totalSupply = _totalSupply.sub(amount);
151         _balances[msg.sender] = _balances[msg.sender].sub(amount);
152         stakingToken.safeTransfer(msg.sender, amount);
153         emit Withdrawn(msg.sender, amount);
154     }
155 
156     function withdrawAll() override external {
157         uint _withdraw = withdrawableBalanceOf(msg.sender);
158         if (_withdraw > 0) {
159             withdraw(_withdraw);
160         }
161         getReward();
162     }
163 
164     function getReward() public nonReentrant updateReward(msg.sender) {
165         uint256 reward = rewards[msg.sender];
166         if (reward > 0) {
167             rewards[msg.sender] = 0;
168 
169             IBEP20(rewardsToken).safeTransfer(msg.sender, reward);
170             emit RewardPaid(msg.sender, reward);
171         }
172     }
173 
174     function harvest() external {}
175 
176     /* ========== RESTRICTED FUNCTIONS ========== */
177 
178     function setRewardsToken(address _rewardsToken) external onlyOwner {
179         require(address(rewardsToken) == address(0), "VaultQBTBNB: rewards token is already set");
180 
181         rewardsToken = IBEP20(_rewardsToken);
182     }
183 
184     function notifyRewardAmount(uint256 reward) override external onlyRewardsDistribution updateReward(address(0)) {
185         if (block.timestamp >= periodFinish) {
186             rewardRate = reward.div(rewardsDuration);
187         } else {
188             uint256 remaining = periodFinish.sub(block.timestamp);
189             uint256 leftover = remaining.mul(rewardRate);
190             rewardRate = reward.add(leftover).div(rewardsDuration);
191         }
192 
193         // Ensure the provided reward amount is not more than the balance in the contract.
194         // This keeps the reward rate in the right range, preventing overflows due to
195         // very high values of rewardRate in the earned and rewardsPerToken functions;
196         // Reward + leftover must be less than 2^256 / 10^18 to avoid overflow.
197         uint _balance = rewardsToken.balanceOf(address(this));
198         require(rewardRate <= _balance.div(rewardsDuration), "VaultQBTBNB: reward");
199 
200         lastUpdateTime = block.timestamp;
201         periodFinish = block.timestamp.add(rewardsDuration);
202 
203         emit RewardAdded(reward);
204     }
205 
206     function setPresale(address _presaleContract) external override onlyOwner {
207         presaleContract = _presaleContract;
208     }
209 
210     function setRewardsDuration(uint256 _rewardsDuration) external onlyOwner {
211         require(periodFinish == 0 || block.timestamp > periodFinish, "VaultQBTBNB: period");
212         rewardsDuration = _rewardsDuration;
213         emit RewardsDurationUpdated(rewardsDuration);
214     }
215 
216     function setPresaleEndTime(uint _endTime) external override onlyPresale {
217         presaleEndTime = _endTime;
218     }
219 
220     //presale --> pool
221     function depositBehalf(address account, uint amount) external override onlyPresale {
222         require(_balances[account] == 0, "VaultQBTBNB: already set");
223         require(amount > 0, "VaultQBTBNB: invalid stake amount");
224 
225         _deposit(amount, account);
226         _presaleBalances[account] = _presaleBalances[account].add(amount);
227     }
228 
229     /* ========== PRIVATE FUNCTIONS ========== */
230 
231     function _deposit(uint256 amount, address _to) private nonReentrant notPaused updateReward(_to) {
232         require(amount > 0, "VaultQBTBNB: invalid deposit amount");
233         _totalSupply = _totalSupply.add(amount);
234         _balances[_to] = _balances[_to].add(amount);
235         stakingToken.safeTransferFrom(msg.sender, address(this), amount);
236         emit Staked(_to, amount);
237     }
238 
239     /* ========== SALVAGE PURPOSE ONLY ========== */
240 
241     function recoverToken(address tokenAddress, uint tokenAmount) external override onlyOwner {
242         require(tokenAddress != address(stakingToken), "VaultQBTBNB: invalid address");
243 
244         IBEP20(tokenAddress).safeTransfer(owner(), tokenAmount);
245         emit Recovered(tokenAddress, tokenAmount);
246     }
247 
248     /* ========== EVENTS ========== */
249 
250     event RewardAdded(uint256 reward);
251     event Staked(address indexed user, uint256 amount);
252     event Withdrawn(address indexed user, uint256 amount);
253     event RewardPaid(address indexed user, uint256 reward);
254     event RewardsDurationUpdated(uint256 newDuration);
255     event Recovered(address token, uint256 amount);
256 }
