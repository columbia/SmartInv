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
17 library Address {
18     function isContract(address account) internal view returns (bool) {
19         // This method relies in extcodesize, which returns 0 for contracts in construction, 
20         // since the code is only stored at the end of the constructor execution.
21 
22         uint256 size;
23         // solhint-disable-next-line no-inline-assembly
24         assembly { size := extcodesize(account) }
25         return size > 0;
26     }
27 }
28 
29 library SafeBEP20 {
30     using Address for address;
31 
32     function safeTransfer(IBEP20 token, address to, uint256 value) internal {
33         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
34     }
35 
36     function safeTransferFrom(IBEP20 token, address from, address to, uint256 value) internal {
37         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
38     }
39 
40     function safeApprove(IBEP20 token, address spender, uint256 value) internal {
41         require((value == 0) || (token.allowance(address(this), spender) == 0),
42             "SafeBEP20: approve from non-zero to non-zero allowance"
43         );
44         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
45     }
46 
47     function safeIncreaseAllowance(IBEP20 token, address spender, uint256 value) internal {
48         uint256 newAllowance = token.allowance(address(this), spender) + value;
49         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
50     }
51 
52     function safeDecreaseAllowance(IBEP20 token, address spender, uint256 value) internal {
53         uint256 newAllowance = token.allowance(address(this), spender) - value;
54         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
55     }
56 
57     function callOptionalReturn(IBEP20 token, bytes memory data) private {
58         require(address(token).isContract(), "SafeBEP20: call to non-contract");
59 
60         (bool success, bytes memory returndata) = address(token).call(data);
61         require(success, "SafeBEP20: low-level call failed");
62 
63         if (returndata.length > 0) { 
64             require(abi.decode(returndata, (bool)), "SafeBEP20: BEP20 operation did not succeed");
65         }
66     }
67 }
68 
69 contract ReentrancyGuard {
70     /// @dev counter to allow mutex lock with only one SSTORE operation
71     uint256 private _guardCounter;
72 
73     constructor () {
74         // The counter starts at one to prevent changing it from zero to a non-zero
75         // value, which is a more expensive operation.
76         _guardCounter = 1;
77     }
78 
79     modifier nonReentrant() {
80         _guardCounter += 1;
81         uint256 localCounter = _guardCounter;
82         _;
83         require(localCounter == _guardCounter, "ReentrancyGuard: reentrant call");
84     }
85 }
86 
87 interface IStakingRewards {
88     function earned(address account) external view returns (uint256);
89     function totalSupply() external view returns (uint256);
90     function balanceOf(address account) external view returns (uint256);
91     function stake(uint256 amount) external;
92     function stakeFor(uint256 amount, address user) external;
93     function getReward() external;
94     function withdraw(uint256 amount) external;
95     function withdrawAndGetReward(uint256 amount) external;
96     function exit() external;
97 }
98 
99 contract Ownable {
100     address public owner;
101     address public newOwner;
102 
103     event OwnershipTransferred(address indexed from, address indexed to);
104 
105     constructor() {
106         owner = msg.sender;
107         emit OwnershipTransferred(address(0), owner);
108     }
109 
110     modifier onlyOwner {
111         require(msg.sender == owner, "Ownable: Caller is not the owner");
112         _;
113     }
114 
115     function getOwner() external view returns (address) {
116         return owner;
117     }
118 
119     function transferOwnership(address transferOwner) external onlyOwner {
120         require(transferOwner != newOwner);
121         newOwner = transferOwner;
122     }
123 
124     function acceptOwnership() virtual external {
125         require(msg.sender == newOwner);
126         emit OwnershipTransferred(owner, newOwner);
127         owner = newOwner;
128         newOwner = address(0);
129     }
130 }
131 
132 interface IBEP20Permit {
133     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
134 }
135 
136 contract StakingRewardsSameTokenFixedAPY is IStakingRewards, ReentrancyGuard, Ownable {
137     using SafeBEP20 for IBEP20;
138 
139     IBEP20 public immutable token;
140     IBEP20 public immutable stakingToken; //read only variable for compatibility with other contracts
141     uint256 public rewardRate; 
142     uint256 public constant rewardDuration = 365 days; 
143 
144     mapping(address => uint256) public weightedStakeDate;
145 
146     uint256 private _totalSupply;
147     mapping(address => uint256) private _balances;
148 
149     event RewardUpdated(uint256 reward);
150     event Staked(address indexed user, uint256 amount);
151     event Withdrawn(address indexed user, uint256 amount);
152     event RewardPaid(address indexed user, uint256 reward);
153     event Rescue(address indexed to, uint amount);
154     event RescueToken(address indexed to, address indexed token, uint amount);
155 
156     constructor(
157         address _token,
158         uint _rewardRate
159     ) {
160         require(_token != address(0), "LockStakingRewardSameTokenFixedAPY: Zero address");
161         token = IBEP20(_token);
162         stakingToken = IBEP20(_token);
163         rewardRate = _rewardRate;
164     }
165 
166     function totalSupply() external view override returns (uint256) {
167         return _totalSupply;
168     }
169 
170     function balanceOf(address account) external view override returns (uint256) {
171         return _balances[account];
172     }
173 
174     function earned(address account) public view override returns (uint256) {
175         return _balances[account] * (block.timestamp - weightedStakeDate[account]) * rewardRate / (100 * rewardDuration);
176     }
177 
178     function stakeWithPermit(uint256 amount, uint deadline, uint8 v, bytes32 r, bytes32 s) external nonReentrant {
179         require(amount > 0, "StakingRewardsSameTokenFixedAPY: Cannot stake 0");
180         _totalSupply += amount;
181         uint previousAmount = _balances[msg.sender];
182         uint newAmount = previousAmount + amount;
183         weightedStakeDate[msg.sender] = (weightedStakeDate[msg.sender] * previousAmount / newAmount) + (block.timestamp * amount / newAmount);
184         _balances[msg.sender] = newAmount;
185 
186         // permit
187         IBEP20Permit(address(token)).permit(msg.sender, address(this), amount, deadline, v, r, s);
188         
189         token.safeTransferFrom(msg.sender, address(this), amount);
190         emit Staked(msg.sender, amount);
191     }
192 
193     function stake(uint256 amount) external override nonReentrant {
194         require(amount > 0, "StakingRewardsSameTokenFixedAPY: Cannot stake 0");
195         _totalSupply += amount;
196         uint previousAmount = _balances[msg.sender];
197         uint newAmount = previousAmount + amount;
198         weightedStakeDate[msg.sender] = (weightedStakeDate[msg.sender] * previousAmount / newAmount) + (block.timestamp * amount / newAmount);
199         _balances[msg.sender] = newAmount;
200         token.safeTransferFrom(msg.sender, address(this), amount);
201         emit Staked(msg.sender, amount);
202     }
203 
204     function stakeFor(uint256 amount, address user) external override nonReentrant {
205         require(amount > 0, "StakingRewardsSameTokenFixedAPY: Cannot stake 0");
206         require(user != address(0), "StakingRewardsSameTokenFixedAPY: Cannot stake for zero address");
207         _totalSupply += amount;
208         uint previousAmount = _balances[user];
209         uint newAmount = previousAmount + amount;
210         weightedStakeDate[user] = (weightedStakeDate[user] * previousAmount / newAmount) + (block.timestamp * amount / newAmount);
211         _balances[user] = newAmount;
212         token.safeTransferFrom(msg.sender, address(this), amount);
213         emit Staked(user, amount);
214     }
215 
216     //A user can withdraw its staking tokens even if there is no rewards tokens on the contract account
217     function withdraw(uint256 amount) public override nonReentrant {
218         require(amount > 0, "StakingRewardsSameTokenFixedAPY: Cannot withdraw 0");
219         _totalSupply -= amount;
220         _balances[msg.sender] -= amount;
221         token.safeTransfer(msg.sender, amount);
222         emit Withdrawn(msg.sender, amount);
223     }
224 
225     function getReward() public override nonReentrant {
226         uint256 reward = earned(msg.sender);
227         if (reward > 0) {
228             weightedStakeDate[msg.sender] = block.timestamp;
229             token.safeTransfer(msg.sender, reward);
230             emit RewardPaid(msg.sender, reward);
231         }
232     }
233 
234     function withdrawAndGetReward(uint256 amount) external override {
235         getReward();
236         withdraw(amount);
237     }
238 
239     function exit() external override {
240         getReward();
241         withdraw(_balances[msg.sender]);
242     }
243 
244     function updateRewardAmount(uint256 reward) external onlyOwner {
245         rewardRate = reward;
246         emit RewardUpdated(reward);
247     }
248 
249     function rescue(address to, IBEP20 tokenAddress, uint256 amount) external onlyOwner {
250         require(to != address(0), "StakingRewardsSameTokenFixedAPY: Cannot rescue to the zero address");
251         require(amount > 0, "StakingRewardsSameTokenFixedAPY: Cannot rescue 0");
252         require(tokenAddress != token, "StakingRewardsSameTokenFixedAPY: Cannot rescue staking/reward token");
253 
254         tokenAddress.safeTransfer(to, amount);
255         emit RescueToken(to, address(tokenAddress), amount);
256     }
257 
258     function rescue(address payable to, uint256 amount) external onlyOwner {
259         require(to != address(0), "StakingRewardsSameTokenFixedAPY: Cannot rescue to the zero address");
260         require(amount > 0, "StakingRewardsSameTokenFixedAPY: Cannot rescue 0");
261 
262         to.transfer(amount);
263         emit Rescue(to, amount);
264     }
265 }