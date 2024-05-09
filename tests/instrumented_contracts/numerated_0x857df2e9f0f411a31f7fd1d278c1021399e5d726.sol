1 pragma solidity =0.8.0;
2 
3 interface IERC20 {
4     function totalSupply() external view returns (uint256);
5     function balanceOf(address account) external view returns (uint256);
6     function transfer(address recipient, uint256 amount) external returns (bool);
7     function allowance(address owner, address spender) external view returns (uint256);
8     function approve(address spender, uint256 amount) external returns (bool);
9     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
10     event Transfer(address indexed from, address indexed to, uint256 value);
11     event Approval(address indexed owner, address indexed spender, uint256 value);
12 }
13 
14 contract Ownable {
15     address public owner;
16     address public newOwner;
17 
18     event OwnershipTransferred(address indexed from, address indexed to);
19 
20     constructor() {
21         owner = msg.sender;
22         emit OwnershipTransferred(address(0), owner);
23     }
24 
25     modifier onlyOwner {
26         require(msg.sender == owner, "Ownable: Caller is not the owner");
27         _;
28     }
29 
30     function transferOwnership(address transferOwner) public onlyOwner {
31         require(transferOwner != newOwner);
32         newOwner = transferOwner;
33     }
34 
35     function acceptOwnership() virtual public {
36         require(msg.sender == newOwner);
37         emit OwnershipTransferred(owner, newOwner);
38         owner = newOwner;
39         newOwner = address(0);
40     }
41 }
42 
43 library SafeMath {
44     function add(uint256 a, uint256 b) internal pure returns (uint256) {
45         uint256 c = a + b;
46         require(c >= a, "SafeMath: addition overflow");
47 
48         return c;
49     }
50 
51     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
52         require(b <= a, "SafeMath: subtraction overflow");
53         uint256 c = a - b;
54 
55         return c;
56     }
57 
58     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
59       if (a == 0) {
60             return 0;
61         }
62 
63         uint256 c = a * b;
64         require(c / a == b, "SafeMath: multiplication overflow");
65 
66         return c;
67     }
68 
69     function div(uint256 a, uint256 b) internal pure returns (uint256) {
70         // Solidity only automatically asserts when dividing by 0
71         require(b > 0, "SafeMath: division by zero");
72         uint256 c = a / b;
73         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
74 
75         return c;
76     }
77 
78     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
79         require(b != 0, "SafeMath: modulo by zero");
80         return a % b;
81     }
82 }
83 
84 library Address {
85     function isContract(address account) internal view returns (bool) {
86         // This method relies in extcodesize, which returns 0 for contracts in construction, 
87         // since the code is only stored at the end of the constructor execution.
88 
89         uint256 size;
90         // solhint-disable-next-line no-inline-assembly
91         assembly { size := extcodesize(account) }
92         return size > 0;
93     }
94 }
95 
96 library SafeERC20 {
97     using SafeMath for uint256;
98     using Address for address;
99 
100     function safeTransfer(IERC20 token, address to, uint256 value) internal {
101         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
102     }
103 
104     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
105         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
106     }
107 
108     function safeApprove(IERC20 token, address spender, uint256 value) internal {
109         require((value == 0) || (token.allowance(address(this), spender) == 0),
110             "SafeERC20: approve from non-zero to non-zero allowance"
111         );
112         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
113     }
114 
115     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
116         uint256 newAllowance = token.allowance(address(this), spender).add(value);
117         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
118     }
119 
120     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
121         uint256 newAllowance = token.allowance(address(this), spender).sub(value);
122         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
123     }
124 
125     function callOptionalReturn(IERC20 token, bytes memory data) private {
126         require(address(token).isContract(), "SafeERC20: call to non-contract");
127 
128         (bool success, bytes memory returndata) = address(token).call(data);
129         require(success, "SafeERC20: low-level call failed");
130 
131         if (returndata.length > 0) { 
132             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
133         }
134     }
135 }
136 
137 contract ReentrancyGuard {
138     /// @dev counter to allow mutex lock with only one SSTORE operation
139     uint256 private _guardCounter;
140 
141     constructor () {
142         // The counter starts at one to prevent changing it from zero to a non-zero
143         // value, which is a more expensive operation.
144         _guardCounter = 1;
145     }
146 
147     modifier nonReentrant() {
148         _guardCounter += 1;
149         uint256 localCounter = _guardCounter;
150         _;
151         require(localCounter == _guardCounter, "ReentrancyGuard: reentrant call");
152     }
153 }
154 
155 interface ILockStakingRewards {
156     function earned(address account) external view returns (uint256);
157     function totalSupply() external view returns (uint256);
158     function balanceOf(address account) external view returns (uint256);
159     function stake(uint256 amount) external;
160     function stakeFor(uint256 amount, address user) external;
161     function getReward() external;
162     function withdraw(uint256 nonce) external;
163     function withdrawAndGetReward(uint256 nonce) external;
164 }
165 
166 interface IERC20Permit {
167     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
168 }
169 
170 contract LockStakingRewardSameTokenFixedAPY is ILockStakingRewards, ReentrancyGuard, Ownable {
171     using SafeMath for uint256;
172     using SafeERC20 for IERC20;
173 
174     IERC20 public token;
175     uint256 public rewardRate; 
176     uint256 public immutable lockDuration; 
177     uint256 public constant rewardDuration = 365 days; 
178 
179     mapping(address => uint256) public weightedStakeDate;
180     mapping(address => mapping(uint256 => uint256)) public stakeLocks;
181     mapping(address => mapping(uint256 => uint256)) public stakeAmounts;
182     mapping(address => uint256) public stakeNonces;
183 
184     uint256 private _totalSupply;
185     mapping(address => uint256) private _balances;
186 
187     event RewardUpdated(uint256 reward);
188     event Staked(address indexed user, uint256 amount);
189     event Withdrawn(address indexed user, uint256 amount);
190     event RewardPaid(address indexed user, uint256 reward);
191     event Rescue(address to, uint amount);
192     event RescueToken(address to, address token, uint amount);
193 
194     constructor(
195         address _token,
196         uint _rewardRate,
197         uint _lockDuration
198     ) {
199         token = IERC20(_token);
200         rewardRate = _rewardRate;
201         lockDuration = _lockDuration;
202     }
203 
204     function totalSupply() external view override returns (uint256) {
205         return _totalSupply;
206     }
207 
208     function balanceOf(address account) external view override returns (uint256) {
209         return _balances[account];
210     }
211 
212     function earned(address account) public view override returns (uint256) {
213         return (_balances[account].mul(block.timestamp.sub(weightedStakeDate[account])).mul(rewardRate)) / (100 * rewardDuration);
214     }
215 
216     function stakeWithPermit(uint256 amount, uint deadline, uint8 v, bytes32 r, bytes32 s) external nonReentrant {
217         require(amount > 0, "LockStakingRewardSameTokenFixedAPY: Cannot stake 0");
218         _totalSupply = _totalSupply.add(amount);
219         uint previousAmount = _balances[msg.sender];
220         uint newAmount = previousAmount.add(amount);
221         weightedStakeDate[msg.sender] = (weightedStakeDate[msg.sender].mul(previousAmount) / newAmount).add(block.timestamp.mul(amount) / newAmount);
222         _balances[msg.sender] = newAmount;
223 
224         // permit
225         IERC20Permit(address(token)).permit(msg.sender, address(this), amount, deadline, v, r, s);
226         
227         token.safeTransferFrom(msg.sender, address(this), amount);
228         uint stakeNonce = stakeNonces[msg.sender]++;
229         stakeLocks[msg.sender][stakeNonce] = block.timestamp + lockDuration;
230         stakeAmounts[msg.sender][stakeNonce] = amount;
231         emit Staked(msg.sender, amount);
232     }
233 
234     function stake(uint256 amount) external override nonReentrant {
235         require(amount > 0, "LockStakingRewardSameTokenFixedAPY: Cannot stake 0");
236         _totalSupply = _totalSupply.add(amount);
237         uint previousAmount = _balances[msg.sender];
238         uint newAmount = previousAmount.add(amount);
239         weightedStakeDate[msg.sender] = (weightedStakeDate[msg.sender].mul(previousAmount) / newAmount).add(block.timestamp.mul(amount) / newAmount);
240         _balances[msg.sender] = newAmount;
241         token.safeTransferFrom(msg.sender, address(this), amount);
242         uint stakeNonce = stakeNonces[msg.sender]++;
243         stakeLocks[msg.sender][stakeNonce] = block.timestamp + lockDuration;
244         stakeAmounts[msg.sender][stakeNonce] = amount;
245         emit Staked(msg.sender, amount);
246     }
247 
248     function stakeFor(uint256 amount, address user) external override nonReentrant {
249         require(amount > 0, "LockStakingRewardSameTokenFixedAPY: Cannot stake 0");
250         _totalSupply = _totalSupply.add(amount);
251         uint previousAmount = _balances[user];
252         uint newAmount = previousAmount.add(amount);
253         weightedStakeDate[user] = (weightedStakeDate[user].mul(previousAmount) / newAmount).add(block.timestamp.mul(amount) / newAmount);
254         _balances[user] = newAmount;
255         token.safeTransferFrom(msg.sender, address(this), amount);
256         uint stakeNonce = stakeNonces[user]++;
257         stakeLocks[user][stakeNonce] = block.timestamp + lockDuration;
258         stakeAmounts[user][stakeNonce] = amount;
259         emit Staked(user, amount);
260     }
261 
262     //A user can withdraw its staking tokens even if there is no rewards tokens on the contract account
263     function withdraw(uint256 nonce) public override nonReentrant {
264         uint amount = stakeAmounts[msg.sender][nonce];
265         require(stakeAmounts[msg.sender][nonce] > 0, "LockStakingRewardSameTokenFixedAPY: This stake nonce was withdrawn");
266         require(stakeLocks[msg.sender][nonce] < block.timestamp, "LockStakingRewardSameTokenFixedAPY: Locked");
267         _totalSupply = _totalSupply.sub(amount);
268         _balances[msg.sender] = _balances[msg.sender].sub(amount);
269         token.safeTransfer(msg.sender, amount);
270         stakeAmounts[msg.sender][nonce] = 0;
271         emit Withdrawn(msg.sender, amount);
272     }
273 
274     function getReward() public override nonReentrant {
275         uint256 reward = earned(msg.sender);
276         if (reward > 0) {
277             weightedStakeDate[msg.sender] = block.timestamp;
278             token.safeTransfer(msg.sender, reward);
279             emit RewardPaid(msg.sender, reward);
280         }
281     }
282 
283     function withdrawAndGetReward(uint256 nonce) external override {
284         getReward();
285         withdraw(nonce);
286     }
287 
288     function updateRewardAmount(uint256 reward) external onlyOwner {
289         rewardRate = reward;
290         emit RewardUpdated(reward);
291     }
292 
293     function rescue(address to, address tokenAddress, uint256 amount) external onlyOwner {
294         require(to != address(0), "LockStakingRewardSameTokenFixedAPY: Cannot rescue to the zero address");
295         require(amount > 0, "LockStakingRewardSameTokenFixedAPY: Cannot rescue 0");
296         require(tokenAddress != address(token), "LockStakingRewardSameTokenFixedAPY: Cannot rescue staking/reward token");
297 
298         IERC20(tokenAddress).safeTransfer(to, amount);
299         emit RescueToken(to, address(tokenAddress), amount);
300     }
301 
302     function rescue(address payable to, uint256 amount) external onlyOwner {
303         require(to != address(0), "LockStakingRewardSameTokenFixedAPY: Cannot rescue to the zero address");
304         require(amount > 0, "LockStakingRewardSameTokenFixedAPY: Cannot rescue 0");
305 
306         to.transfer(amount);
307         emit Rescue(to, amount);
308     }
309 }