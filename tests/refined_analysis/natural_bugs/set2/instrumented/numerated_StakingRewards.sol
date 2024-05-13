1 //SPDX-License-Identifier: MIT
2 pragma solidity 0.7.5;
3 
4 import "@openzeppelin/contracts/math/Math.sol";
5 import "@openzeppelin/contracts/math/SafeMath.sol";
6 import "@openzeppelin/contracts/token/ERC20/SafeERC20.sol";
7 import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
8 
9 // Inheritance
10 import "./interfaces/IStakingRewards.sol";
11 import "./interfaces/Pausable.sol";
12 import "./interfaces/IBurnableToken.sol";
13 import "./interfaces/RewardsDistributionRecipient.sol";
14 
15 // based on synthetix
16 contract StakingRewards is IStakingRewards, RewardsDistributionRecipient, ReentrancyGuard, Pausable {
17     using SafeMath for uint256;
18     using SafeERC20 for IERC20;
19 
20     // ========== STATE VARIABLES ========== //
21 
22     IERC20 public rewardsToken;
23     IERC20 public stakingToken;
24     uint256 public periodFinish = 0;
25     uint256 public rewardRate = 0;
26     uint256 public rewardsDuration = 365 days;
27     uint256 public lastUpdateTime;
28     uint256 public rewardPerTokenStored;
29 
30     mapping(address => uint256) public userRewardPerTokenPaid;
31     mapping(address => uint256) public rewards;
32 
33     bool public stopped;
34 
35     uint256 private _totalSupply;
36     mapping(address => uint256) private _balances;
37 
38     // ========== CONSTRUCTOR ========== //
39 
40     constructor(
41         address _owner,
42         address _rewardsDistribution,
43         address _stakingToken,
44         address _rewardsToken
45     ) Owned(_owner) {
46         stakingToken = IERC20(_stakingToken);
47         rewardsToken = IERC20(_rewardsToken);
48         rewardsDistribution = _rewardsDistribution;
49     }
50 
51     // ========== VIEWS ========== //
52 
53     function totalSupply() override public view returns (uint256) {
54         return _totalSupply;
55     }
56 
57     function balanceOf(address account) override external view returns (uint256) {
58         return _balances[account];
59     }
60 
61     function lastTimeRewardApplicable() override public view returns (uint256) {
62         return Math.min(block.timestamp, periodFinish);
63     }
64 
65     function rewardPerToken() override public view returns (uint256) {
66         if (_totalSupply == 0) {
67             return rewardPerTokenStored;
68         }
69 
70         return rewardPerTokenStored.add(
71             lastTimeRewardApplicable().sub(lastUpdateTime).mul(rewardRate).mul(1e18).div(_totalSupply)
72         );
73     }
74 
75     function earned(address account) override virtual public view returns (uint256) {
76         return _balances[account]
77         .mul(rewardPerToken().sub(userRewardPerTokenPaid[account]))
78         .div(1e18)
79         .add(rewards[account]);
80     }
81 
82     function getRewardForDuration() override external view returns (uint256) {
83         return rewardRate.mul(rewardsDuration);
84     }
85 
86     // ========== MUTATIVE FUNCTIONS ========== //
87 
88     function stake(uint256 amount) override external nonReentrant notPaused updateReward(msg.sender) {
89         require(periodFinish > 0, "Stake period not started yet");
90         require(amount > 0, "Cannot stake 0");
91 
92         _totalSupply = _totalSupply.add(amount);
93         _balances[msg.sender] = _balances[msg.sender].add(amount);
94 
95         stakingToken.safeTransferFrom(msg.sender, address(this), amount);
96 
97         emit Staked(msg.sender, amount);
98     }
99 
100     function withdraw(uint256 amount) override public nonReentrant updateReward(msg.sender) {
101         require(amount > 0, "Cannot withdraw 0");
102         _totalSupply = _totalSupply.sub(amount);
103         _balances[msg.sender] = _balances[msg.sender].sub(amount);
104         stakingToken.safeTransfer(msg.sender, amount);
105 
106         emit Withdrawn(msg.sender, amount);
107     }
108 
109     function getReward() override public nonReentrant updateReward(msg.sender) {
110         uint256 reward = rewards[msg.sender];
111 
112         if (reward > 0) {
113             rewards[msg.sender] = 0;
114             rewardsToken.safeTransfer(msg.sender, reward);
115             emit RewardPaid(msg.sender, reward);
116         }
117     }
118 
119     function exit() override external {
120         withdraw(_balances[msg.sender]);
121         getReward();
122     }
123 
124     // ========== RESTRICTED FUNCTIONS ========== //
125 
126     function notifyRewardAmount(
127         uint256 _reward
128     ) override virtual external whenActive onlyRewardsDistribution updateReward(address(0)) {
129         if (block.timestamp >= periodFinish) {
130             rewardRate = _reward.div(rewardsDuration);
131         } else {
132             uint256 remaining = periodFinish.sub(block.timestamp);
133             uint256 leftover = remaining.mul(rewardRate);
134             rewardRate = _reward.add(leftover).div(rewardsDuration);
135         }
136 
137         // Ensure the provided reward amount is not more than the balance in the contract.
138         // This keeps the reward rate in the right range, preventing overflows due to
139         // very high values of rewardRate in the earned and rewardsPerToken functions;
140         // Reward + leftover must be less than 2^256 / 10^18 to avoid overflow.
141         uint256 balance = rewardsToken.balanceOf(address(this));
142 
143         require(rewardRate <= balance.div(rewardsDuration), "Provided reward too high");
144 
145         lastUpdateTime = block.timestamp;
146         periodFinish = block.timestamp.add(rewardsDuration);
147         emit RewardAdded(_reward);
148     }
149 
150     function setRewardsDuration(uint256 _rewardsDuration) virtual external whenActive onlyOwner {
151         require(_rewardsDuration > 0, "empty _rewardsDuration");
152 
153         require(
154             block.timestamp > periodFinish,
155             "Previous rewards period must be complete before changing the duration for the new period"
156         );
157 
158         rewardsDuration = _rewardsDuration;
159         emit RewardsDurationUpdated(rewardsDuration);
160     }
161 
162     // when farming was started with 1y and 12tokens
163     // and we want to finish after 4 months, we need to end up with situation
164     // like we were starting with 4mo and 4 tokens.
165     function finishFarming() external whenActive onlyOwner {
166         require(block.timestamp < periodFinish, "can't stop if not started or already finished");
167 
168         stopped = true;
169         uint256 tokensToBurn;
170 
171         if (_totalSupply == 0) {
172             tokensToBurn = rewardsToken.balanceOf(address(this));
173         } else {
174             uint256 remaining = periodFinish.sub(block.timestamp);
175             tokensToBurn = rewardRate.mul(remaining);
176             rewardsDuration = rewardsDuration - remaining;
177         }
178 
179         periodFinish = block.timestamp;
180         IBurnableToken(address(rewardsToken)).burn(tokensToBurn);
181 
182         emit FarmingFinished(tokensToBurn);
183     }
184 
185     // ========== MODIFIERS ========== //
186 
187     modifier whenActive() {
188         require(!stopped, "farming is stopped");
189         _;
190     }
191 
192     modifier updateReward(address account) virtual {
193         rewardPerTokenStored = rewardPerToken();
194         lastUpdateTime = lastTimeRewardApplicable();
195         if (account != address(0)) {
196             rewards[account] = earned(account);
197             userRewardPerTokenPaid[account] = rewardPerTokenStored;
198         }
199         _;
200     }
201 
202     // ========== EVENTS ========== //
203 
204     event RewardAdded(uint256 reward);
205     event Staked(address indexed user, uint256 amount);
206     event Withdrawn(address indexed user, uint256 amount);
207     event RewardPaid(address indexed user, uint256 reward);
208     event RewardsDurationUpdated(uint256 newDuration);
209     event FarmingFinished(uint256 burnedTokens);
210 }
