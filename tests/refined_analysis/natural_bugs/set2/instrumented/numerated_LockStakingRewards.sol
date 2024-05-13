1 pragma solidity =0.8.0;
2 
3 interface IBEP20 {
4     function totalSupply() external view returns (uint256);
5     function decimals() external pure returns (uint);
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
29         require(msg.sender == owner, "Ownable: Caller is not the owner");
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
66         // This method relies in extcodesize, which returns 0 for contracts in construction,
67         // since the code is only stored at the end of the constructor execution.
68 
69         uint256 size;
70         // solhint-disable-next-line no-inline-assembly
71         assembly { size := extcodesize(account) }
72         return size > 0;
73     }
74 }
75 
76 library SafeBEP20 {
77     using Address for address;
78 
79     function safeTransfer(IBEP20 token, address to, uint256 value) internal {
80         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
81     }
82 
83     function safeTransferFrom(IBEP20 token, address from, address to, uint256 value) internal {
84         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
85     }
86 
87     function safeApprove(IBEP20 token, address spender, uint256 value) internal {
88         require((value == 0) || (token.allowance(address(this), spender) == 0),
89             "SafeBEP20: approve from non-zero to non-zero allowance"
90         );
91         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
92     }
93 
94     function safeIncreaseAllowance(IBEP20 token, address spender, uint256 value) internal {
95         uint256 newAllowance = token.allowance(address(this), spender) + value;
96         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
97     }
98 
99     function safeDecreaseAllowance(IBEP20 token, address spender, uint256 value) internal {
100         uint256 newAllowance = token.allowance(address(this), spender) - value;
101         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
102     }
103 
104     function callOptionalReturn(IBEP20 token, bytes memory data) private {
105         require(address(token).isContract(), "SafeBEP20: call to non-contract");
106 
107         (bool success, bytes memory returndata) = address(token).call(data);
108         require(success, "SafeBEP20: low-level call failed");
109 
110         if (returndata.length > 0) { 
111             require(abi.decode(returndata, (bool)), "SafeBEP20: BEP20 operation did not succeed");
112         }
113     }
114 }
115 
116 contract ReentrancyGuard {
117     /// @dev counter to allow mutex lock with only one SSTORE operation
118     uint256 private _guardCounter;
119 
120     constructor () {
121         // The counter starts at one to prevent changing it from zero to a non-zero
122         // value, which is a more expensive operation.
123         _guardCounter = 1;
124     }
125 
126     modifier nonReentrant() {
127         _guardCounter += 1;
128         uint256 localCounter = _guardCounter;
129         _;
130         require(localCounter == _guardCounter, "ReentrancyGuard: reentrant call");
131     }
132 }
133 
134 interface ILockStakingRewards {
135     function lastTimeRewardApplicable() external view returns (uint256);
136     function rewardPerToken() external view returns (uint256);
137     function earned(address account) external view returns (uint256);
138     function getRewardForDuration() external view returns (uint256);
139     function totalSupply() external view returns (uint256);
140     function balanceOf(address account) external view returns (uint256);
141     function stake(uint256 amount) external;
142     function stakeFor(uint256 amount, address user) external;
143     function getReward() external;
144     function withdraw(uint256 nonce) external;
145     function withdrawAndGetReward(uint256 nonce) external;
146 }
147 
148 interface IBEP20Permit {
149     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
150 }
151 
152 contract LockStakingRewards is ILockStakingRewards, ReentrancyGuard, Ownable {
153     using SafeBEP20 for IBEP20;
154 
155     IBEP20 public immutable rewardsToken;
156     IBEP20 public immutable stakingToken;
157     uint256 public periodFinish = 0;
158     uint256 public rewardRate = 0;
159     uint256 public constant rewardsDuration = 60 days; 
160     uint256 public immutable lockDuration; 
161     uint256 public lastUpdateTime;
162     uint256 public rewardPerTokenStored;
163 
164     mapping(address => uint256) public userRewardPerTokenPaid;
165     mapping(address => uint256) public rewards;
166     
167     mapping(address => mapping(uint256 => uint256)) public stakeLocks;
168     mapping(address => mapping(uint256 => uint256)) public stakeAmounts;
169     mapping(address => uint256) public stakeNonces;
170 
171     uint256 private _totalSupply;
172     mapping(address => uint256) private _balances;
173 
174     event RewardAdded(uint256 reward);
175     event Staked(address indexed user, uint256 amount);
176     event Withdrawn(address indexed user, uint256 amount);
177     event RewardPaid(address indexed user, uint256 reward);
178     event Rescue(address to, uint amount);
179     event RescueToken(address indexed to, address indexed token, uint amount);
180 
181     constructor(
182         address _rewardsToken,
183         address _stakingToken,
184         uint _lockDuration
185     ) {
186         require(_rewardsToken != address(0) && _stakingToken != address(0), "LockStakingRewards: Zero address(es)");
187         rewardsToken = IBEP20(_rewardsToken);
188         stakingToken = IBEP20(_stakingToken);
189         require(IBEP20(_rewardsToken).decimals() == 18 && IBEP20(_stakingToken).decimals() == 18, "LockStakingRewards: Unsopported decimals");
190         lockDuration = _lockDuration;
191     }
192 
193     modifier updateReward(address account) {
194         rewardPerTokenStored = rewardPerToken();
195         lastUpdateTime = lastTimeRewardApplicable();
196         if (account != address(0)) {
197             rewards[account] = earned(account);
198             userRewardPerTokenPaid[account] = rewardPerTokenStored;
199         }
200         _;
201     }
202 
203     function totalSupply() external view override returns (uint256) {
204         return _totalSupply;
205     }
206 
207     function balanceOf(address account) external view override returns (uint256) {
208         return _balances[account];
209     }
210 
211     function lastTimeRewardApplicable() public view override returns (uint256) {
212         return Math.min(block.timestamp, periodFinish);
213     }
214 
215     function rewardPerToken() public view override returns (uint256) {
216         if (_totalSupply == 0) {
217             return rewardPerTokenStored;
218         }
219         return
220             rewardPerTokenStored + ((lastTimeRewardApplicable() - lastUpdateTime) * rewardRate * 1e18 / _totalSupply);
221     }
222 
223     function earned(address account) public view override returns (uint256) {
224         return (_balances[account] * (rewardPerToken() - userRewardPerTokenPaid[account]) / 1e18) + rewards[account];
225     }
226 
227     function getRewardForDuration() external view override returns (uint256) {
228         return rewardRate * rewardsDuration;
229     }
230 
231     function stakeWithPermit(uint256 amount, uint deadline, uint8 v, bytes32 r, bytes32 s) external nonReentrant updateReward(msg.sender) {
232         require(amount > 0, "LockStakingRewards: Cannot stake 0");
233         _totalSupply += amount;
234         _balances[msg.sender] += amount;
235 
236         // permit
237         IBEP20Permit(address(stakingToken)).permit(msg.sender, address(this), amount, deadline, v, r, s);
238 
239         stakingToken.safeTransferFrom(msg.sender, address(this), amount);
240         uint stakeNonce = stakeNonces[msg.sender]++;
241         stakeLocks[msg.sender][stakeNonce] = block.timestamp + lockDuration;
242         stakeAmounts[msg.sender][stakeNonce] = amount;
243         emit Staked(msg.sender, amount);
244     }
245 
246     function stake(uint256 amount) external override nonReentrant updateReward(msg.sender) {
247         require(amount > 0, "LockStakingRewards: Cannot stake 0");
248         _totalSupply += amount;
249         _balances[msg.sender] += amount;
250         stakingToken.safeTransferFrom(msg.sender, address(this), amount);
251         uint stakeNonce = stakeNonces[msg.sender]++;
252         stakeLocks[msg.sender][stakeNonce] = block.timestamp + lockDuration;
253         stakeAmounts[msg.sender][stakeNonce] = amount;
254         emit Staked(msg.sender, amount);
255     }
256 
257     function stakeFor(uint256 amount, address user) external override nonReentrant updateReward(user) {
258         require(amount > 0, "LockStakingRewards: Cannot stake 0");
259         require(user != address(0), "LockStakingRewards: Cannot stake for zero address");
260         _totalSupply += amount;
261         _balances[user] += amount;
262         stakingToken.safeTransferFrom(msg.sender, address(this), amount);
263         uint stakeNonce = stakeNonces[user]++;
264         stakeLocks[user][stakeNonce] = block.timestamp + lockDuration;
265         stakeAmounts[user][stakeNonce] = amount;
266         emit Staked(user, amount);
267     }
268 
269     function withdraw(uint256 nonce) public override nonReentrant updateReward(msg.sender) {
270         uint amount = stakeAmounts[msg.sender][nonce];
271         require(stakeAmounts[msg.sender][nonce] > 0, "LockStakingRewards: This stake nonce was withdrawn");
272         require(stakeLocks[msg.sender][nonce] < block.timestamp, "LockStakingRewards: Locked");
273         _totalSupply -= amount;
274         _balances[msg.sender] -= amount;
275         stakingToken.safeTransfer(msg.sender, amount);
276         stakeAmounts[msg.sender][nonce] = 0;
277         emit Withdrawn(msg.sender, amount);
278     }
279 
280     function getReward() public override nonReentrant updateReward(msg.sender) {
281         uint256 reward = rewards[msg.sender];
282         if (reward > 0) {
283             rewards[msg.sender] = 0;
284             rewardsToken.safeTransfer(msg.sender, reward);
285             emit RewardPaid(msg.sender, reward);
286         }
287     }
288 
289     function withdrawAndGetReward(uint256 nonce) external override {
290         withdraw(nonce);
291         getReward();
292     }
293 
294     function notifyRewardAmount(uint256 reward) external onlyOwner updateReward(address(0)) {
295         if (block.timestamp >= periodFinish) {
296             rewardRate = reward / rewardsDuration;
297         } else {
298             uint256 remaining = periodFinish - block.timestamp;
299             uint256 leftover = remaining * rewardRate;
300             rewardRate = (reward + leftover) / rewardsDuration;
301         }
302 
303         // Ensure the provided reward amount is not more than the balance in the contract.
304         // This keeps the reward rate in the right range, preventing overflows due to
305         // very high values of rewardRate in the earned and rewardsPerToken functions;
306         // Reward + leftover must be less than 2^256 / 10^18 to avoid overflow.
307         uint balance = rewardsToken.balanceOf(address(this));
308         require(rewardRate <= balance / rewardsDuration, "LockStakingRewards: Provided reward too high");
309 
310         lastUpdateTime = block.timestamp;
311         periodFinish = block.timestamp + rewardsDuration;
312         emit RewardAdded(reward);
313     }
314 
315     function rescue(address to, IBEP20 token, uint256 amount) external onlyOwner {
316         require(to != address(0), "LockStakingRewards: Cannot rescue to the zero address");
317         require(amount > 0, "LockStakingRewards: Cannot rescue 0");
318         require(token != rewardsToken, "LockStakingRewards: Cannot rescue rewards token");
319         require(token != stakingToken, "LockStakingRewards: Cannot rescue staking token");
320 
321         token.safeTransfer(to, amount);
322         emit RescueToken(to, address(token), amount);
323     }
324 
325     function rescue(address payable to, uint256 amount) external onlyOwner {
326         require(to != address(0), "LockStakingRewards: Cannot rescue to the zero address");
327         require(amount > 0, "LockStakingRewards: Cannot rescue 0");
328 
329         to.transfer(amount);
330         emit Rescue(to, amount);
331     }
332 }