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
14 library SafeMath {
15 
16     function add(uint256 a, uint256 b) internal pure returns (uint256) {
17         uint256 c = a + b;
18         require(c >= a, "SafeMath: addition overflow");
19 
20         return c;
21     }
22 
23     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
24         require(b <= a, "SafeMath: subtraction overflow");
25         uint256 c = a - b;
26 
27         return c;
28     }
29 
30     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
31       if (a == 0) {
32             return 0;
33         }
34 
35         uint256 c = a * b;
36         require(c / a == b, "SafeMath: multiplication overflow");
37 
38         return c;
39     }
40 
41     function div(uint256 a, uint256 b) internal pure returns (uint256) {
42         // Solidity only automatically asserts when dividing by 0
43         require(b > 0, "SafeMath: division by zero");
44         uint256 c = a / b;
45         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
46 
47         return c;
48     }
49 
50     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
51         require(b != 0, "SafeMath: modulo by zero");
52         return a % b;
53     }
54 }
55 
56 library Math {
57 
58     function max(uint256 a, uint256 b) internal pure returns (uint256) {
59         return a >= b ? a : b;
60     }
61 
62     function min(uint256 a, uint256 b) internal pure returns (uint256) {
63         return a < b ? a : b;
64     }
65 
66     function average(uint256 a, uint256 b) internal pure returns (uint256) {
67         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
68     }
69 }
70 
71 library Address {
72     function isContract(address account) internal view returns (bool) {
73         // This method relies in extcodesize, which returns 0 for contracts in construction, 
74         // since the code is only stored at the end of the constructor execution.
75 
76         uint256 size;
77         // solhint-disable-next-line no-inline-assembly
78         assembly { size := extcodesize(account) }
79         return size > 0;
80     }
81 }
82 
83 library SafeERC20 {
84     using SafeMath for uint256;
85     using Address for address;
86 
87     function safeTransfer(IERC20 token, address to, uint256 value) internal {
88         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
89     }
90 
91     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
92         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
93     }
94 
95     function safeApprove(IERC20 token, address spender, uint256 value) internal {
96         require((value == 0) || (token.allowance(address(this), spender) == 0),
97             "SafeERC20: approve from non-zero to non-zero allowance"
98         );
99         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
100     }
101 
102     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
103         uint256 newAllowance = token.allowance(address(this), spender).add(value);
104         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
105     }
106 
107     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
108         uint256 newAllowance = token.allowance(address(this), spender).sub(value);
109         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
110     }
111 
112     function callOptionalReturn(IERC20 token, bytes memory data) private {
113         require(address(token).isContract(), "SafeERC20: call to non-contract");
114 
115         (bool success, bytes memory returndata) = address(token).call(data);
116         require(success, "SafeERC20: low-level call failed");
117 
118         if (returndata.length > 0) { 
119             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
120         }
121     }
122 }
123 
124 contract ReentrancyGuard {
125     /// @dev counter to allow mutex lock with only one SSTORE operation
126     uint256 private _guardCounter;
127 
128     constructor () {
129         // The counter starts at one to prevent changing it from zero to a non-zero
130         // value, which is a more expensive operation.
131         _guardCounter = 1;
132     }
133 
134     modifier nonReentrant() {
135         _guardCounter += 1;
136         uint256 localCounter = _guardCounter;
137         _;
138         require(localCounter == _guardCounter, "ReentrancyGuard: reentrant call");
139     }
140 }
141 
142 interface IStakingRewards {
143     function earned(address account) external view returns (uint256);
144     function totalSupply() external view returns (uint256);
145     function balanceOf(address account) external view returns (uint256);
146     function stake(uint256 amount) external;
147     function stakeFor(uint256 amount, address user) external;
148     function getReward() external;
149     function withdraw(uint256 amount) external;
150     function withdrawAndGetReward(uint256 amount) external;
151     function exit() external;
152 }
153 
154 contract Ownable {
155     address public owner;
156     address public newOwner;
157 
158     event OwnershipTransferred(address indexed from, address indexed to);
159 
160     constructor() {
161         owner = msg.sender;
162         emit OwnershipTransferred(address(0), owner);
163     }
164 
165     modifier onlyOwner {
166         require(msg.sender == owner, "Ownable: Caller is not the owner");
167         _;
168     }
169 
170     function transferOwnership(address transferOwner) public onlyOwner {
171         require(transferOwner != newOwner);
172         newOwner = transferOwner;
173     }
174 
175     function acceptOwnership() virtual public {
176         require(msg.sender == newOwner);
177         emit OwnershipTransferred(owner, newOwner);
178         owner = newOwner;
179         newOwner = address(0);
180     }
181 }
182 
183 interface IERC20Permit {
184     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
185 }
186 
187 contract StakingRewardsSameTokenFixedAPY is IStakingRewards, ReentrancyGuard, Ownable {
188     using SafeMath for uint256;
189     using SafeERC20 for IERC20;
190 
191     IERC20 public token;
192     uint256 public rewardRate; 
193     uint256 public constant rewardDuration = 365 days; 
194 
195     mapping(address => uint256) public weightedStakeDate;
196 
197     uint256 private _totalSupply;
198     mapping(address => uint256) private _balances;
199 
200     event RewardUpdated(uint256 reward);
201     event Staked(address indexed user, uint256 amount);
202     event Withdrawn(address indexed user, uint256 amount);
203     event RewardPaid(address indexed user, uint256 reward);
204     event Rescue(address to, uint amount);
205     event RescueToken(address to, address token, uint amount);
206 
207     constructor(
208         address _token,
209         uint _rewardRate
210     ) {
211         token = IERC20(_token);
212         rewardRate = _rewardRate;
213     }
214 
215     function totalSupply() external view override returns (uint256) {
216         return _totalSupply;
217     }
218 
219     function balanceOf(address account) external view override returns (uint256) {
220         return _balances[account];
221     }
222 
223     function earned(address account) public view override returns (uint256) {
224         return (_balances[account].mul(block.timestamp.sub(weightedStakeDate[account])).mul(rewardRate)) / (100 * rewardDuration);
225     }
226 
227     function stakeWithPermit(uint256 amount, uint deadline, uint8 v, bytes32 r, bytes32 s) external nonReentrant {
228         require(amount > 0, "StakingRewardsSameTokenFixedAPY: Cannot stake 0");
229         _totalSupply = _totalSupply.add(amount);
230         uint previousAmount = _balances[msg.sender];
231         uint newAmount = previousAmount.add(amount);
232         weightedStakeDate[msg.sender] = (weightedStakeDate[msg.sender].mul(previousAmount) / newAmount).add(block.timestamp.mul(amount) / newAmount);
233         _balances[msg.sender] = newAmount;
234 
235         // permit
236         IERC20Permit(address(token)).permit(msg.sender, address(this), amount, deadline, v, r, s);
237         
238         token.safeTransferFrom(msg.sender, address(this), amount);
239         emit Staked(msg.sender, amount);
240     }
241 
242     function stake(uint256 amount) external override nonReentrant {
243         require(amount > 0, "StakingRewardsSameTokenFixedAPY: Cannot stake 0");
244         _totalSupply = _totalSupply.add(amount);
245         uint previousAmount = _balances[msg.sender];
246         uint newAmount = previousAmount.add(amount);
247         weightedStakeDate[msg.sender] = (weightedStakeDate[msg.sender].mul(previousAmount) / newAmount).add(block.timestamp.mul(amount) / newAmount);
248         _balances[msg.sender] = newAmount;
249         token.safeTransferFrom(msg.sender, address(this), amount);
250         emit Staked(msg.sender, amount);
251     }
252 
253     function stakeFor(uint256 amount, address user) external override nonReentrant {
254         require(amount > 0, "StakingRewardsSameTokenFixedAPY: Cannot stake 0");
255         _totalSupply = _totalSupply.add(amount);
256         uint previousAmount = _balances[user];
257         uint newAmount = previousAmount.add(amount);
258         weightedStakeDate[user] = (weightedStakeDate[user].mul(previousAmount) / newAmount).add(block.timestamp.mul(amount) / newAmount);
259         _balances[user] = newAmount;
260         token.safeTransferFrom(msg.sender, address(this), amount);
261         emit Staked(user, amount);
262     }
263 
264     //A user can withdraw its staking tokens even if there is no rewards tokens on the contract account
265     function withdraw(uint256 amount) public override nonReentrant {
266         require(amount > 0, "StakingRewardsSameTokenFixedAPY: Cannot withdraw 0");
267         _totalSupply = _totalSupply.sub(amount);
268         _balances[msg.sender] = _balances[msg.sender].sub(amount);
269         token.safeTransfer(msg.sender, amount);
270         emit Withdrawn(msg.sender, amount);
271     }
272 
273     function getReward() public override nonReentrant {
274         uint256 reward = earned(msg.sender);
275         if (reward > 0) {
276             weightedStakeDate[msg.sender] = block.timestamp;
277             token.safeTransfer(msg.sender, reward);
278             emit RewardPaid(msg.sender, reward);
279         }
280     }
281 
282     function withdrawAndGetReward(uint256 amount) external override {
283         getReward();
284         withdraw(amount);
285     }
286 
287     function exit() external override {
288         getReward();
289         withdraw(_balances[msg.sender]);
290     }
291 
292     function updateRewardAmount(uint256 reward) external onlyOwner {
293         rewardRate = reward;
294         emit RewardUpdated(reward);
295     }
296 
297     function rescue(address to, IERC20 tokenAddress, uint256 amount) external onlyOwner {
298         require(to != address(0), "StakingRewardsSameTokenFixedAPY: Cannot rescue to the zero address");
299         require(amount > 0, "StakingRewardsSameTokenFixedAPY: Cannot rescue 0");
300         require(tokenAddress != token, "StakingRewardsSameTokenFixedAPY: Cannot rescue staking/reward token");
301 
302         tokenAddress.safeTransfer(to, amount);
303         emit RescueToken(to, address(tokenAddress), amount);
304     }
305 
306     function rescue(address payable to, uint256 amount) external onlyOwner {
307         require(to != address(0), "StakingRewardsSameTokenFixedAPY: Cannot rescue to the zero address");
308         require(amount > 0, "StakingRewardsSameTokenFixedAPY: Cannot rescue 0");
309 
310         to.transfer(amount);
311         emit Rescue(to, amount);
312     }
313 }