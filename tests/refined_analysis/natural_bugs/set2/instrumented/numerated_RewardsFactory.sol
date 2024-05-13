1 pragma solidity =0.8.0;
2 
3 interface IBEP20 {
4     function totalSupply() external view returns (uint256);
5     function decimals() external pure returns (uint8);
6     function balanceOf(address account) external view returns (uint256);
7     function transfer(address recipient, uint256 amount) external returns (bool);
8     function allowance(address owner, address spender) external view returns (uint256);
9     function approve(address spender, uint256 amount) external returns (bool);
10     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
11     function getOwner() external view returns (address);
12     
13     event Transfer(address indexed from, address indexed to, uint256 value);
14     event Approval(address indexed owner, address indexed spender, uint256 value);
15 }
16 
17 contract Ownable {
18     address public owner;
19     address public newOwner;
20 
21     event OwnershipTransferred(address indexed from, address indexed to);
22 
23     constructor() {
24         owner = msg.sender;
25         emit OwnershipTransferred(address(0), owner);
26     }
27 
28     modifier onlyOwner {
29         require(msg.sender == owner);
30         _;
31     }
32 
33     function getOwner() external view returns (address) {
34         return owner;
35     }
36 
37     function transferOwnership(address transferOwner) external onlyOwner {
38         require(transferOwner != newOwner);
39         newOwner = transferOwner;
40     }
41 
42     function acceptOwnership() virtual external {
43         require(msg.sender == newOwner);
44         emit OwnershipTransferred(owner, newOwner);
45         owner = newOwner;
46         newOwner = address(0);
47     }
48 }
49 
50 library Math {
51     function max(uint256 a, uint256 b) internal pure returns (uint256) {
52         return a >= b ? a : b;
53     }
54 
55     function min(uint256 a, uint256 b) internal pure returns (uint256) {
56         return a < b ? a : b;
57     }
58 
59     function average(uint256 a, uint256 b) internal pure returns (uint256) {
60         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
61     }
62 }
63 
64 library Address {
65     function isContract(address account) internal view returns (bool) {
66         // This method relies in extcodesize, which returns 0 for contracts in
67         // construction, since the code is only stored at the end of the
68         // constructor execution.
69 
70         uint256 size;
71         // solhint-disable-next-line no-inline-assembly
72         assembly { size := extcodesize(account) }
73         return size > 0;
74     }
75 }
76 
77 library SafeBEP20 {
78     using Address for address;
79 
80     function safeTransfer(IBEP20 token, address to, uint256 value) internal {
81         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
82     }
83 
84     function safeTransferFrom(IBEP20 token, address from, address to, uint256 value) internal {
85         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
86     }
87 
88     function safeApprove(IBEP20 token, address spender, uint256 value) internal {
89         require((value == 0) || (token.allowance(address(this), spender) == 0),
90             "SafeBEP20: approve from non-zero to non-zero allowance"
91         );
92         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
93     }
94 
95     function safeIncreaseAllowance(IBEP20 token, address spender, uint256 value) internal {
96         uint256 newAllowance = token.allowance(address(this), spender) + value;
97         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
98     }
99 
100     function safeDecreaseAllowance(IBEP20 token, address spender, uint256 value) internal {
101         uint256 newAllowance = token.allowance(address(this), spender) - value;
102         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
103     }
104 
105     function callOptionalReturn(IBEP20 token, bytes memory data) private {
106         require(address(token).isContract(), "SafeBEP20: call to non-contract");
107 
108         (bool success, bytes memory returndata) = address(token).call(data);
109         require(success, "SafeBEP20: low-level call failed");
110 
111         if (returndata.length > 0) { 
112             require(abi.decode(returndata, (bool)), "SafeBEP20: BEP20 operation did not succeed");
113         }
114     }
115 }
116 
117 contract ReentrancyGuard {
118     /// @dev counter to allow mutex lock with only one SSTORE operation
119     uint256 private _guardCounter;
120 
121     constructor () {
122         // The counter starts at one to prevent changing it from zero to a non-zero
123         // value, which is a more expensive operation.
124         _guardCounter = 1;
125     }
126 
127     modifier nonReentrant() {
128         _guardCounter += 1;
129         uint256 localCounter = _guardCounter;
130         _;
131         require(localCounter == _guardCounter, "ReentrancyGuard: reentrant call");
132     }
133 }
134 
135 // Inheritance
136 interface IStakingRewards {
137     // Views
138     function lastTimeRewardApplicable() external view returns (uint256);
139     function rewardPerToken() external view returns (uint256);
140     function earned(address account) external view returns (uint256);
141     function getRewardForDuration() external view returns (uint256);
142     function totalSupply() external view returns (uint256);
143     function balanceOf(address account) external view returns (uint256);
144 
145     // Mutative
146     function stake(uint256 amount) external;
147     function withdraw(uint256 amount) external;
148     function getReward() external;
149     function exit() external;
150 }
151 
152 abstract contract RewardsDistributionRecipient {
153     address public rewardsDistribution;
154 
155     function notifyRewardAmount(uint256 reward) external virtual;
156 
157     modifier onlyRewardsDistribution() {
158         require(msg.sender == rewardsDistribution, "Caller is not RewardsDistribution contract");
159         _;
160     }
161 }
162 
163 contract StakingRewards is IStakingRewards, RewardsDistributionRecipient, ReentrancyGuard {
164     using SafeBEP20 for IBEP20;
165 
166     IBEP20 public immutable rewardsToken;
167     IBEP20 public immutable stakingToken;
168     uint256 public periodFinish = 0;
169     uint256 public rewardRate = 0;
170     uint256 public rewardsDuration = 60 days;
171     uint256 public lastUpdateTime;
172     uint256 public rewardPerTokenStored;
173 
174     mapping(address => uint256) public userRewardPerTokenPaid;
175     mapping(address => uint256) public rewards;
176 
177     uint256 private _totalSupply;
178     mapping(address => uint256) private _balances;
179 
180     constructor(
181         address _rewardsDistribution,
182         address _rewardsToken,
183         address _stakingToken
184     ) {
185         require(_rewardsDistribution != address(0) && _rewardsToken != address(0) && _stakingToken != address(0), "StakingRewards: Zero address(es)");
186         rewardsToken = IBEP20(_rewardsToken);
187         stakingToken = IBEP20(_stakingToken);
188         require(IBEP20(_rewardsToken).decimals() == 18 && IBEP20(_stakingToken).decimals() == 18, "StakingRewards: Unsopported decimals");
189         rewardsDistribution = _rewardsDistribution;
190     }
191 
192     function totalSupply() external override view returns (uint256) {
193         return _totalSupply;
194     }
195 
196     function balanceOf(address account) external override view returns (uint256) {
197         return _balances[account];
198     }
199 
200     function lastTimeRewardApplicable() public override view returns (uint256) {
201         return Math.min(block.timestamp, periodFinish);
202     }
203 
204     function rewardPerToken() public override view returns (uint256) {
205         if (_totalSupply == 0) {
206             return rewardPerTokenStored;
207         }
208         return
209             rewardPerTokenStored + ((lastTimeRewardApplicable() - lastUpdateTime) * rewardRate * 1e18 / _totalSupply);
210     }
211 
212     function earned(address account) public override view returns (uint256) {
213         return _balances[account] * (rewardPerToken() - userRewardPerTokenPaid[account]) / 1e18 + rewards[account];
214     }
215 
216     function getRewardForDuration() external override view returns (uint256) {
217         return rewardRate * rewardsDuration;
218     }
219 
220     function stakeWithPermit(uint256 amount, uint deadline, uint8 v, bytes32 r, bytes32 s) external nonReentrant updateReward(msg.sender) {
221         require(amount > 0, "Cannot stake 0");
222         _totalSupply += amount;
223         _balances[msg.sender] += amount;
224 
225         // permit
226         IBEP20Permit(address(stakingToken)).permit(msg.sender, address(this), amount, deadline, v, r, s);
227 
228         stakingToken.safeTransferFrom(msg.sender, address(this), amount);
229         emit Staked(msg.sender, amount);
230     }
231 
232     function stake(uint256 amount) external override nonReentrant updateReward(msg.sender) {
233         require(amount > 0, "Cannot stake 0");
234         _totalSupply += amount;
235         _balances[msg.sender] += amount;
236         stakingToken.safeTransferFrom(msg.sender, address(this), amount);
237         emit Staked(msg.sender, amount);
238     }
239 
240     function withdraw(uint256 amount) public override nonReentrant updateReward(msg.sender) {
241         require(amount > 0, "Cannot withdraw 0");
242         _totalSupply -= amount;
243         _balances[msg.sender] -= amount;
244         stakingToken.safeTransfer(msg.sender, amount);
245         emit Withdrawn(msg.sender, amount);
246     }
247 
248     function getReward() public override nonReentrant updateReward(msg.sender) {
249         uint256 reward = rewards[msg.sender];
250         if (reward > 0) {
251             rewards[msg.sender] = 0;
252             rewardsToken.safeTransfer(msg.sender, reward);
253             emit RewardPaid(msg.sender, reward);
254         }
255     }
256 
257     function exit() external override {
258         withdraw(_balances[msg.sender]);
259         getReward();
260     }
261 
262     function notifyRewardAmount(uint256 reward) external override onlyRewardsDistribution updateReward(address(0)) {
263         if (block.timestamp >= periodFinish) {
264             rewardRate = reward / rewardsDuration;
265         } else {
266             uint256 remaining = periodFinish - block.timestamp;
267             uint256 leftover = remaining * rewardRate;
268             rewardRate = (reward + leftover) / rewardsDuration;
269         }
270 
271         // Ensure the provided reward amount is not more than the balance in the contract.
272         // This keeps the reward rate in the right range, preventing overflows due to
273         // very high values of rewardRate in the earned and rewardsPerToken functions;
274         // Reward + leftover must be less than 2^256 / 10^18 to avoid overflow.
275         uint balance = rewardsToken.balanceOf(address(this));
276         require(rewardRate <= balance / rewardsDuration, "Provided reward too high");
277 
278         lastUpdateTime = block.timestamp;
279         periodFinish = block.timestamp + rewardsDuration;
280         emit RewardAdded(reward);
281     }
282 
283     modifier updateReward(address account) {
284         rewardPerTokenStored = rewardPerToken();
285         lastUpdateTime = lastTimeRewardApplicable();
286         if (account != address(0)) {
287             rewards[account] = earned(account);
288             userRewardPerTokenPaid[account] = rewardPerTokenStored;
289         }
290         _;
291     }
292 
293     event RewardAdded(uint256 reward);
294     event Staked(address indexed user, uint256 amount);
295     event Withdrawn(address indexed user, uint256 amount);
296     event RewardPaid(address indexed user, uint256 reward);
297 }
298 
299 interface IBEP20Permit {
300     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
301 }
302 
303 contract StakingRewardsFactory is Ownable {
304     address public immutable rewardsToken;
305     uint public immutable stakingRewardsGenesis;
306 
307     // the staking tokens for which the rewards contract has been deployed
308     address[] public stakingTokens;
309 
310     // info about rewards for a particular staking token
311     struct StakingRewardsInfo {
312         address stakingRewards;
313         uint rewardAmount;
314     }
315 
316     // rewards info by staking token
317     mapping(address => StakingRewardsInfo) public stakingRewardsInfoByStakingToken;
318 
319     constructor(
320         address _rewardsToken,
321         uint _stakingRewardsGenesis
322     ) Ownable() {
323         require(_stakingRewardsGenesis >= block.timestamp, 'StakingRewardsFactory::constructor: genesis too soon');
324 
325         rewardsToken = _rewardsToken;
326         stakingRewardsGenesis = _stakingRewardsGenesis;
327     }
328 
329     ///// permissioned functions
330 
331     // deploy a staking reward contract for the staking token, and store the reward amount
332     // the reward will be distributed to the staking reward contract no sooner than the genesis
333     function deploy(address stakingToken, uint rewardAmount) external onlyOwner {
334         StakingRewardsInfo storage info = stakingRewardsInfoByStakingToken[stakingToken];
335         require(info.stakingRewards == address(0), 'StakingRewardsFactory::deploy: already deployed');
336 
337         info.stakingRewards = address(new StakingRewards(/*_rewardsDistribution=*/ address(this), rewardsToken, stakingToken));
338         info.rewardAmount = rewardAmount;
339         stakingTokens.push(stakingToken);
340     }
341 
342     ///// permissionless functions
343 
344     // call notifyRewardAmount for all staking tokens.
345     function notifyRewardAmounts() external {
346         require(stakingTokens.length > 0, 'StakingRewardsFactory::notifyRewardAmounts: called before any deploys');
347         for (uint i = 0; i < stakingTokens.length; i++) {
348             notifyRewardAmount(stakingTokens[i]);
349         }
350     }
351 
352     // notify reward amount for an individual staking token.
353     // this is a fallback in case the notifyRewardAmounts costs too much gas to call for all contracts
354     function notifyRewardAmount(address stakingToken) public {
355         require(block.timestamp >= stakingRewardsGenesis, 'StakingRewardsFactory::notifyRewardAmount: not ready');
356 
357         StakingRewardsInfo storage info = stakingRewardsInfoByStakingToken[stakingToken];
358         require(info.stakingRewards != address(0), 'StakingRewardsFactory::notifyRewardAmount: not deployed');
359 
360         if (info.rewardAmount > 0) {
361             uint rewardAmount = info.rewardAmount;
362             info.rewardAmount = 0;
363 
364             require(
365                 IBEP20(rewardsToken).transfer(info.stakingRewards, rewardAmount),
366                 'StakingRewardsFactory::notifyRewardAmount: transfer failed'
367             );
368             StakingRewards(info.stakingRewards).notifyRewardAmount(rewardAmount);
369         }
370     }
371 }