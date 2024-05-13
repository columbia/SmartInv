1 pragma solidity =0.8.0;
2 
3 interface IBEP20 {
4     function totalSupply() external view returns (uint256);
5     function decimals() external view returns (uint8);
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
50 library Address {
51     function isContract(address account) internal view returns (bool) {
52         // This method relies in extcodesize, which returns 0 for contracts in construction, 
53         // since the code is only stored at the end of the constructor execution.
54 
55         uint256 size;
56         // solhint-disable-next-line no-inline-assembly
57         assembly { size := extcodesize(account) }
58         return size > 0;
59     }
60 }
61 
62 library SafeBEP20 {
63     using Address for address;
64 
65     function safeTransfer(IBEP20 token, address to, uint256 value) internal {
66         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
67     }
68 
69     function safeTransferFrom(IBEP20 token, address from, address to, uint256 value) internal {
70         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
71     }
72 
73     function safeApprove(IBEP20 token, address spender, uint256 value) internal {
74         require((value == 0) || (token.allowance(address(this), spender) == 0),
75             "SafeBEP20: approve from non-zero to non-zero allowance"
76         );
77         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
78     }
79 
80     function safeIncreaseAllowance(IBEP20 token, address spender, uint256 value) internal {
81         uint256 newAllowance = token.allowance(address(this), spender) + value;
82         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
83     }
84 
85     function safeDecreaseAllowance(IBEP20 token, address spender, uint256 value) internal {
86         uint256 newAllowance = token.allowance(address(this), spender) - value;
87         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
88     }
89 
90     function callOptionalReturn(IBEP20 token, bytes memory data) private {
91         require(address(token).isContract(), "SafeBEP20: call to non-contract");
92 
93         (bool success, bytes memory returndata) = address(token).call(data);
94         require(success, "SafeBEP20: low-level call failed");
95 
96         if (returndata.length > 0) { 
97             require(abi.decode(returndata, (bool)), "SafeBEP20: BEP20 operation did not succeed");
98         }
99     }
100 }
101 
102 contract ReentrancyGuard {
103     /// @dev counter to allow mutex lock with only one SSTORE operation
104     uint256 private _guardCounter;
105 
106     constructor () {
107         // The counter starts at one to prevent changing it from zero to a non-zero
108         // value, which is a more expensive operation.
109         _guardCounter = 1;
110     }
111 
112     modifier nonReentrant() {
113         _guardCounter += 1;
114         uint256 localCounter = _guardCounter;
115         _;
116         require(localCounter == _guardCounter, "ReentrancyGuard: reentrant call");
117     }
118 }
119 
120 interface ILockStakingRewards {
121     function earned(address account) external view returns (uint256);
122     function totalSupply() external view returns (uint256);
123     function balanceOf(address account) external view returns (uint256);
124     function stake(uint256 amount) external;
125     function stakeFor(uint256 amount, address user) external;
126     function getReward() external;
127     function withdraw(uint256 nonce) external;
128     function withdrawAndGetReward(uint256 nonce) external;
129 }
130 
131 interface IBEP20Permit {
132     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
133 }
134 
135 contract LockStakingRewardSameTokenFixedAPY is ILockStakingRewards, ReentrancyGuard, Ownable {
136     using SafeBEP20 for IBEP20;
137 
138     IBEP20 public immutable token;
139     IBEP20 public immutable stakingToken; //read only variable for compatibility with other contracts
140     uint256 public rewardRate; 
141     uint256 public immutable lockDuration; 
142     uint256 public constant rewardDuration = 365 days; 
143 
144     mapping(address => uint256) public weightedStakeDate;
145     mapping(address => mapping(uint256 => uint256)) public stakeLocks;
146     mapping(address => mapping(uint256 => uint256)) public stakeAmounts;
147     mapping(address => uint256) public stakeNonces;
148 
149     uint256 private _totalSupply;
150     mapping(address => uint256) private _balances;
151 
152     event RewardUpdated(uint256 reward);
153     event Staked(address indexed user, uint256 amount);
154     event Withdrawn(address indexed user, uint256 amount);
155     event RewardPaid(address indexed user, uint256 reward);
156     event Rescue(address indexed to, uint amount);
157     event RescueToken(address indexed to, address indexed token, uint amount);
158 
159     constructor(
160         address _token,
161         uint _rewardRate,
162         uint _lockDuration
163     ) {
164         require(_token != address(0), "LockStakingRewardSameTokenFixedAPY: Zero address");
165         token = IBEP20(_token);
166         stakingToken = IBEP20(_token);
167         rewardRate = _rewardRate;
168         lockDuration = _lockDuration;
169     }
170 
171     function totalSupply() external view override returns (uint256) {
172         return _totalSupply;
173     }
174 
175     function balanceOf(address account) external view override returns (uint256) {
176         return _balances[account];
177     }
178 
179     function earned(address account) public view override returns (uint256) {
180         return (_balances[account] * (block.timestamp - weightedStakeDate[account]) * rewardRate) / (100 * rewardDuration);
181     }
182 
183     function stakeWithPermit(uint256 amount, uint deadline, uint8 v, bytes32 r, bytes32 s) external nonReentrant {
184         require(amount > 0, "LockStakingRewardSameTokenFixedAPY: Cannot stake 0");
185         _totalSupply += amount;
186         uint previousAmount = _balances[msg.sender];
187         uint newAmount = previousAmount + amount;
188         weightedStakeDate[msg.sender] = (weightedStakeDate[msg.sender] * previousAmount / newAmount) + (block.timestamp * amount / newAmount);
189         _balances[msg.sender] = newAmount;
190 
191         // permit
192         IBEP20Permit(address(token)).permit(msg.sender, address(this), amount, deadline, v, r, s);
193         
194         token.safeTransferFrom(msg.sender, address(this), amount);
195         uint stakeNonce = stakeNonces[msg.sender]++;
196         stakeLocks[msg.sender][stakeNonce] = block.timestamp + lockDuration;
197         stakeAmounts[msg.sender][stakeNonce] = amount;
198         emit Staked(msg.sender, amount);
199     }
200 
201     function stake(uint256 amount) external override nonReentrant {
202         require(amount > 0, "LockStakingRewardSameTokenFixedAPY: Cannot stake 0");
203         _totalSupply += amount;
204         uint previousAmount = _balances[msg.sender];
205         uint newAmount = previousAmount + amount;
206         weightedStakeDate[msg.sender] = (weightedStakeDate[msg.sender] * previousAmount / newAmount) + (block.timestamp * amount / newAmount);
207         _balances[msg.sender] = newAmount;
208         token.safeTransferFrom(msg.sender, address(this), amount);
209         uint stakeNonce = stakeNonces[msg.sender]++;
210         stakeLocks[msg.sender][stakeNonce] = block.timestamp + lockDuration;
211         stakeAmounts[msg.sender][stakeNonce] = amount;
212         emit Staked(msg.sender, amount);
213     }
214 
215     function stakeFor(uint256 amount, address user) external override nonReentrant {
216         require(amount > 0, "LockStakingRewardSameTokenFixedAPY: Cannot stake 0");
217         require(user != address(0), "LockStakingRewardSameTokenFixedAPY: Cannot stake for zero address");
218         _totalSupply += amount;
219         uint previousAmount = _balances[user];
220         uint newAmount = previousAmount + amount;
221         weightedStakeDate[user] = (weightedStakeDate[user] * previousAmount / newAmount) + (block.timestamp * amount / newAmount);
222         _balances[user] = newAmount;
223         token.safeTransferFrom(msg.sender, address(this), amount);
224         uint stakeNonce = stakeNonces[user]++;
225         stakeLocks[user][stakeNonce] = block.timestamp + lockDuration;
226         stakeAmounts[user][stakeNonce] = amount;
227         emit Staked(user, amount);
228     }
229 
230     //A user can withdraw its staking tokens even if there is no rewards tokens on the contract account
231     function withdraw(uint256 nonce) public override nonReentrant {
232         uint amount = stakeAmounts[msg.sender][nonce];
233         require(stakeAmounts[msg.sender][nonce] > 0, "LockStakingRewardSameTokenFixedAPY: This stake nonce was withdrawn");
234         require(stakeLocks[msg.sender][nonce] < block.timestamp, "LockStakingRewardSameTokenFixedAPY: Locked");
235         _totalSupply -= amount;
236         _balances[msg.sender] -= amount;
237         token.safeTransfer(msg.sender, amount);
238         stakeAmounts[msg.sender][nonce] = 0;
239         emit Withdrawn(msg.sender, amount);
240     }
241 
242     function getReward() public override nonReentrant {
243         uint256 reward = earned(msg.sender);
244         if (reward > 0) {
245             weightedStakeDate[msg.sender] = block.timestamp;
246             token.safeTransfer(msg.sender, reward);
247             emit RewardPaid(msg.sender, reward);
248         }
249     }
250 
251     function withdrawAndGetReward(uint256 nonce) external override {
252         getReward();
253         withdraw(nonce);
254     }
255 
256     function updateRewardAmount(uint256 reward) external onlyOwner {
257         rewardRate = reward;
258         emit RewardUpdated(reward);
259     }
260 
261     function rescue(address to, address tokenAddress, uint256 amount) external onlyOwner {
262         require(to != address(0), "LockStakingRewardSameTokenFixedAPY: Cannot rescue to the zero address");
263         require(amount > 0, "LockStakingRewardSameTokenFixedAPY: Cannot rescue 0");
264         require(tokenAddress != address(token), "LockStakingRewardSameTokenFixedAPY: Cannot rescue staking/reward token");
265 
266         IBEP20(tokenAddress).safeTransfer(to, amount);
267         emit RescueToken(to, address(tokenAddress), amount);
268     }
269 
270     function rescue(address payable to, uint256 amount) external onlyOwner {
271         require(to != address(0), "LockStakingRewardSameTokenFixedAPY: Cannot rescue to the zero address");
272         require(amount > 0, "LockStakingRewardSameTokenFixedAPY: Cannot rescue 0");
273 
274         to.transfer(amount);
275         emit Rescue(to, amount);
276     }
277 }