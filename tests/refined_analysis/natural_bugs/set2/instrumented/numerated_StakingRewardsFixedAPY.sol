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
17 interface INimbusRouter {
18     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
19 }
20 
21 contract Ownable {
22     address public owner;
23     address public newOwner;
24 
25     event OwnershipTransferred(address indexed from, address indexed to);
26 
27     constructor() {
28         owner = msg.sender;
29         emit OwnershipTransferred(address(0), owner);
30     }
31 
32     modifier onlyOwner {
33         require(msg.sender == owner, "Ownable: Caller is not the owner");
34         _;
35     }
36 
37     function getOwner() external view returns (address) {
38         return owner;
39     }
40 
41     function transferOwnership(address transferOwner) external onlyOwner {
42         require(transferOwner != newOwner);
43         newOwner = transferOwner;
44     }
45 
46     function acceptOwnership() virtual external {
47         require(msg.sender == newOwner);
48         emit OwnershipTransferred(owner, newOwner);
49         owner = newOwner;
50         newOwner = address(0);
51     }
52 }
53 
54 library Address {
55     function isContract(address account) internal view returns (bool) {
56         // This method relies in extcodesize, which returns 0 for contracts in construction, 
57         // since the code is only stored at the end of the constructor execution.
58 
59         uint256 size;
60         // solhint-disable-next-line no-inline-assembly
61         assembly { size := extcodesize(account) }
62         return size > 0;
63     }
64 }
65 
66 library SafeBEP20 {
67     using Address for address;
68 
69     function safeTransfer(IBEP20 token, address to, uint256 value) internal {
70         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
71     }
72 
73     function safeTransferFrom(IBEP20 token, address from, address to, uint256 value) internal {
74         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
75     }
76 
77     function safeApprove(IBEP20 token, address spender, uint256 value) internal {
78         require((value == 0) || (token.allowance(address(this), spender) == 0),
79             "SafeBEP20: approve from non-zero to non-zero allowance"
80         );
81         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
82     }
83 
84     function safeIncreaseAllowance(IBEP20 token, address spender, uint256 value) internal {
85         uint256 newAllowance = token.allowance(address(this), spender) + value;
86         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
87     }
88 
89     function safeDecreaseAllowance(IBEP20 token, address spender, uint256 value) internal {
90         uint256 newAllowance = token.allowance(address(this), spender) - value;
91         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
92     }
93 
94     function callOptionalReturn(IBEP20 token, bytes memory data) private {
95         require(address(token).isContract(), "SafeBEP20: call to non-contract");
96 
97         (bool success, bytes memory returndata) = address(token).call(data);
98         require(success, "SafeBEP20: low-level call failed");
99 
100         if (returndata.length > 0) { 
101             require(abi.decode(returndata, (bool)), "SafeBEP20: BEP20 operation did not succeed");
102         }
103     }
104 }
105 
106 contract ReentrancyGuard {
107     /// @dev counter to allow mutex lock with only one SSTORE operation
108     uint256 private _guardCounter;
109 
110     constructor () {
111         // The counter starts at one to prevent changing it from zero to a non-zero
112         // value, which is a more expensive operation.
113         _guardCounter = 1;
114     }
115 
116     modifier nonReentrant() {
117         _guardCounter += 1;
118         uint256 localCounter = _guardCounter;
119         _;
120         require(localCounter == _guardCounter, "ReentrancyGuard: reentrant call");
121     }
122 }
123 
124 interface IStakingRewards {
125     function earned(address account) external view returns (uint256);
126     function totalSupply() external view returns (uint256);
127     function balanceOf(address account) external view returns (uint256);
128     function stake(uint256 amount) external;
129     function stakeFor(uint256 amount, address user) external;
130     function getReward() external;
131     function withdraw(uint256 nonce) external;
132     function withdrawAndGetReward(uint256 nonce) external;
133 }
134 
135 interface IBEP20Permit {
136     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
137 }
138 
139 contract StakingRewardFixedAPY is IStakingRewards, ReentrancyGuard, Ownable {
140     using SafeBEP20 for IBEP20;
141 
142     IBEP20 public immutable rewardsToken;
143     IBEP20 public immutable stakingToken;
144     INimbusRouter public swapRouter;
145     uint256 public rewardRate; 
146     uint256 public constant rewardDuration = 365 days; 
147 
148     mapping(address => uint256) public weightedStakeDate;
149     mapping(address => mapping(uint256 => uint256)) public stakeAmounts;
150     mapping(address => mapping(uint256 => uint256)) public stakeAmountsRewardEquivalent;
151     mapping(address => uint256) public stakeNonces;
152 
153     uint256 private _totalSupply;
154     uint256 private _totalSupplyRewardEquivalent;
155     mapping(address => uint256) private _balances;
156     mapping(address => uint256) private _balancesRewardEquivalent;
157 
158     event RewardUpdated(uint256 reward);
159     event Staked(address indexed user, uint256 amount);
160     event Withdrawn(address indexed user, uint256 amount);
161     event RewardPaid(address indexed user, uint256 reward);
162     event Rescue(address indexed to, uint amount);
163     event RescueToken(address indexed to, address indexed token, uint amount);
164 
165     constructor(
166         address _rewardsToken,
167         address _stakingToken,
168         address _swapRouter,
169         uint _rewardRate
170     ) {
171         require(_rewardsToken != address(0) && _stakingToken != address(0) && _swapRouter != address(0), "StakingRewardFixedAPY: Zero address(es)");
172         rewardsToken = IBEP20(_rewardsToken);
173         stakingToken = IBEP20(_stakingToken);
174         swapRouter = INimbusRouter(_swapRouter);
175         rewardRate = _rewardRate;
176     }
177 
178     function totalSupply() external view override returns (uint256) {
179         return _totalSupply;
180     }
181 
182     function totalSupplyRewardEquivalent() external view returns (uint256) {
183         return _totalSupplyRewardEquivalent;
184     }
185 
186     function balanceOf(address account) external view override returns (uint256) {
187         return _balances[account];
188     }
189     
190     function balanceOfRewardEquivalent(address account) external view returns (uint256) {
191         return _balancesRewardEquivalent[account];
192     }
193 
194     function earned(address account) public view override returns (uint256) {
195         return _balancesRewardEquivalent[account] * (block.timestamp - weightedStakeDate[account]) * rewardRate / (100 * rewardDuration);
196     }
197 
198     function stakeWithPermit(uint256 amount, uint deadline, uint8 v, bytes32 r, bytes32 s) external nonReentrant {
199         require(amount > 0, "Cannot stake 0");
200         // permit
201         IBEP20Permit(address(stakingToken)).permit(msg.sender, address(this), amount, deadline, v, r, s);
202         _stake(amount, msg.sender);
203     }
204 
205     function stake(uint256 amount) external override nonReentrant {
206         require(amount > 0, "StakingRewardFixedAPY: Cannot stake 0");
207         _stake(amount, msg.sender);
208     }
209 
210     function stakeFor(uint256 amount, address user) external override nonReentrant {
211         require(amount > 0, "StakingRewardFixedAPY: Cannot stake 0");
212         require(user != address(0), "StakingRewardFixedAPY: Cannot stake for zero address");
213         _stake(amount, user);
214     }
215 
216     function _stake(uint256 amount, address user) private {
217         stakingToken.safeTransferFrom(msg.sender, address(this), amount);
218         uint amountRewardEquivalent = getEquivalentAmount(amount);
219 
220         _totalSupply += amount;
221         _totalSupplyRewardEquivalent += amountRewardEquivalent;
222         uint previousAmount = _balances[user];
223         uint newAmount = previousAmount + amount;
224         weightedStakeDate[user] = (weightedStakeDate[user] * previousAmount / newAmount) + (block.timestamp * amount / newAmount);
225         _balances[user] = newAmount;
226 
227         uint stakeNonce = stakeNonces[user]++;
228         stakeAmounts[user][stakeNonce] = amount;
229         
230         stakeAmountsRewardEquivalent[user][stakeNonce] = amountRewardEquivalent;
231         _balancesRewardEquivalent[user] += amountRewardEquivalent;
232         emit Staked(user, amount);
233     }
234 
235 
236     //A user can withdraw its staking tokens even if there is no rewards tokens on the contract account
237     function withdraw(uint256 nonce) public override nonReentrant {
238         require(stakeAmounts[msg.sender][nonce] > 0, "StakingRewardFixedAPY: This stake nonce was withdrawn");
239         uint amount = stakeAmounts[msg.sender][nonce];
240         uint amountRewardEquivalent = stakeAmountsRewardEquivalent[msg.sender][nonce];
241         _totalSupply -= amount;
242         _totalSupplyRewardEquivalent -= amountRewardEquivalent;
243         _balances[msg.sender] -= amount;
244         _balancesRewardEquivalent[msg.sender] -= amountRewardEquivalent;
245         stakingToken.safeTransfer(msg.sender, amount);
246         stakeAmounts[msg.sender][nonce] = 0;
247         stakeAmountsRewardEquivalent[msg.sender][nonce] = 0;
248         emit Withdrawn(msg.sender, amount);
249     }
250 
251     function getReward() public override nonReentrant {
252         uint256 reward = earned(msg.sender);
253         if (reward > 0) {
254             weightedStakeDate[msg.sender] = block.timestamp;
255             rewardsToken.safeTransfer(msg.sender, reward);
256             emit RewardPaid(msg.sender, reward);
257         }
258     }
259 
260     function withdrawAndGetReward(uint256 nonce) external override {
261         getReward();
262         withdraw(nonce);
263     }
264 
265     function getEquivalentAmount(uint amount) public view returns (uint) {
266         address[] memory path = new address[](2);
267 
268         uint equivalent;
269         if (stakingToken != rewardsToken) {
270             path[0] = address(stakingToken);            
271             path[1] = address(rewardsToken);
272             equivalent = swapRouter.getAmountsOut(amount, path)[1];
273         } else {
274             equivalent = amount;   
275         }
276         
277         return equivalent;
278     }
279 
280 
281     function updateRewardAmount(uint256 reward) external onlyOwner {
282         rewardRate = reward;
283         emit RewardUpdated(reward);
284     }
285 
286     function updateSwapRouter(address newSwapRouter) external onlyOwner {
287         require(newSwapRouter != address(0), "StakingRewardFixedAPY: Address is zero");
288         swapRouter = INimbusRouter(newSwapRouter);
289     }
290 
291     function rescue(address to, address token, uint256 amount) external onlyOwner {
292         require(to != address(0), "StakingRewardFixedAPY: Cannot rescue to the zero address");
293         require(amount > 0, "StakingRewardFixedAPY: Cannot rescue 0");
294         require(token != address(stakingToken), "StakingRewardFixedAPY: Cannot rescue staking token");
295         //owner can rescue rewardsToken if there is spare unused tokens on staking contract balance
296 
297         IBEP20(token).safeTransfer(to, amount);
298         emit RescueToken(to, address(token), amount);
299     }
300 
301     function rescue(address payable to, uint256 amount) external onlyOwner {
302         require(to != address(0), "StakingRewardFixedAPY: Cannot rescue to the zero address");
303         require(amount > 0, "StakingRewardFixedAPY: Cannot rescue 0");
304 
305         to.transfer(amount);
306         emit Rescue(to, amount);
307     }
308 }