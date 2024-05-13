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
124 interface ILockStakingRewards {
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
139 contract LockStakingRewardFixedAPY is ILockStakingRewards, ReentrancyGuard, Ownable {
140     using SafeBEP20 for IBEP20;
141 
142     IBEP20 public immutable rewardsToken;
143     IBEP20 public immutable stakingToken;
144     INimbusRouter public swapRouter;
145     uint256 public rewardRate; 
146     uint256 public immutable lockDuration; 
147     uint256 public constant rewardDuration = 365 days; 
148 
149     mapping(address => uint256) public weightedStakeDate;
150     mapping(address => mapping(uint256 => uint256)) public stakeLocks;
151     mapping(address => mapping(uint256 => uint256)) public stakeAmounts;
152     mapping(address => mapping(uint256 => uint256)) public stakeAmountsRewardEquivalent;
153     mapping(address => uint256) public stakeNonces;
154 
155     uint256 private _totalSupply;
156     uint256 private _totalSupplyRewardEquivalent;
157     mapping(address => uint256) private _balances;
158     mapping(address => uint256) private _balancesRewardEquivalent;
159 
160     event RewardUpdated(uint256 reward);
161     event Staked(address indexed user, uint256 amount);
162     event Withdrawn(address indexed user, uint256 amount);
163     event RewardPaid(address indexed user, uint256 reward);
164     event Rescue(address indexed to, uint amount);
165     event RescueToken(address indexed to, address indexed token, uint amount);
166 
167     constructor(
168         address _rewardsToken,
169         address _stakingToken,
170         address _swapRouter,
171         uint _rewardRate,
172         uint _lockDuration
173     ) {
174         require(_rewardsToken != address(0) && _swapRouter != address(0), "LockStakingRewardFixedAPY: Zero address(es)");
175         rewardsToken = IBEP20(_rewardsToken);
176         stakingToken = IBEP20(_stakingToken);
177         swapRouter = INimbusRouter(_swapRouter);
178         rewardRate = _rewardRate;
179         lockDuration = _lockDuration;
180     }
181 
182     function totalSupply() external view override returns (uint256) {
183         return _totalSupply;
184     }
185 
186     function totalSupplyRewardEquivalent() external view returns (uint256) {
187         return _totalSupplyRewardEquivalent;
188     }
189 
190     function balanceOf(address account) external view override returns (uint256) {
191         return _balances[account];
192     }
193     
194     function balanceOfRewardEquivalent(address account) external view returns (uint256) {
195         return _balancesRewardEquivalent[account];
196     }
197 
198     function earned(address account) public view override returns (uint256) {
199         return (_balancesRewardEquivalent[account] * (block.timestamp - weightedStakeDate[account]) * rewardRate) / (100 * rewardDuration);
200     }
201 
202     function stakeWithPermit(uint256 amount, uint deadline, uint8 v, bytes32 r, bytes32 s) external nonReentrant {
203         require(amount > 0, "LockStakingRewardFixedAPY: Cannot stake 0");
204         // permit
205         IBEP20Permit(address(stakingToken)).permit(msg.sender, address(this), amount, deadline, v, r, s);
206         _stake(amount, msg.sender);
207     }
208 
209     function stake(uint256 amount) external override nonReentrant {
210         require(amount > 0, "LockStakingRewardFixedAPY: Cannot stake 0");
211         _stake(amount, msg.sender);
212     }
213 
214     function stakeFor(uint256 amount, address user) external override nonReentrant {
215         require(amount > 0, "LockStakingRewardFixedAPY: Cannot stake 0");
216         require(user != address(0), "LockStakingRewardFixedAPY: Cannot stake for zero address");
217         _stake(amount, user);
218     }
219 
220     function _stake(uint256 amount, address user) private {
221         stakingToken.safeTransferFrom(msg.sender, address(this), amount);
222         uint amountRewardEquivalent = getEquivalentAmount(amount);
223 
224         _totalSupply += amount;
225         _totalSupplyRewardEquivalent += amountRewardEquivalent;
226         uint previousAmount = _balances[user];
227         uint newAmount = previousAmount + amount;
228         weightedStakeDate[user] = (weightedStakeDate[user] * (previousAmount) / newAmount) + (block.timestamp * amount / newAmount);
229         _balances[user] = newAmount;
230 
231         uint stakeNonce = stakeNonces[user]++;
232         stakeAmounts[user][stakeNonce] = amount;
233         stakeLocks[user][stakeNonce] = block.timestamp + lockDuration;
234         
235         stakeAmountsRewardEquivalent[user][stakeNonce] = amountRewardEquivalent;
236         _balancesRewardEquivalent[user] += amountRewardEquivalent;
237         emit Staked(user, amount);
238     }
239 
240 
241     //A user can withdraw its staking tokens even if there is no rewards tokens on the contract account
242     function withdraw(uint256 nonce) public override nonReentrant {
243         require(stakeAmounts[msg.sender][nonce] > 0, "LockStakingRewardFixedAPY: This stake nonce was withdrawn");
244         require(stakeLocks[msg.sender][nonce] < block.timestamp, "LockStakingRewardFixedAPY: Locked");
245         uint amount = stakeAmounts[msg.sender][nonce];
246         uint amountRewardEquivalent = stakeAmountsRewardEquivalent[msg.sender][nonce];
247         _totalSupply -= amount;
248         _totalSupplyRewardEquivalent -= amountRewardEquivalent;
249         _balances[msg.sender] -= amount;
250         _balancesRewardEquivalent[msg.sender] -= amountRewardEquivalent;
251         stakingToken.safeTransfer(msg.sender, amount);
252         stakeAmounts[msg.sender][nonce] = 0;
253         stakeAmountsRewardEquivalent[msg.sender][nonce] = 0;
254         emit Withdrawn(msg.sender, amount);
255     }
256 
257     function getReward() public override nonReentrant {
258         uint256 reward = earned(msg.sender);
259         if (reward > 0) {
260             weightedStakeDate[msg.sender] = block.timestamp;
261             rewardsToken.safeTransfer(msg.sender, reward);
262             emit RewardPaid(msg.sender, reward);
263         }
264     }
265 
266     function withdrawAndGetReward(uint256 nonce) external override {
267         getReward();
268         withdraw(nonce);
269     }
270 
271     function getEquivalentAmount(uint amount) public view returns (uint) {
272         address[] memory path = new address[](2);
273 
274         uint equivalent;
275         if (stakingToken != rewardsToken) {
276             path[0] = address(stakingToken);            
277             path[1] = address(rewardsToken);
278             equivalent = swapRouter.getAmountsOut(amount, path)[1];
279         } else {
280             equivalent = amount;   
281         }
282         
283         return equivalent;
284     }
285 
286 
287     function updateRewardAmount(uint256 reward) external onlyOwner {
288         rewardRate = reward;
289         emit RewardUpdated(reward);
290     }
291 
292     function updateSwapRouter(address newSwapRouter) external onlyOwner {
293         require(newSwapRouter != address(0), "LockStakingRewardFixedAPY: Address is zero");
294         swapRouter = INimbusRouter(newSwapRouter);
295     }
296 
297     function rescue(address to, address token, uint256 amount) external onlyOwner {
298         require(to != address(0), "LockStakingRewardFixedAPY: Cannot rescue to the zero address");
299         require(amount > 0, "LockStakingRewardFixedAPY: Cannot rescue 0");
300         require(token != address(stakingToken), "LockStakingRewardFixedAPY: Cannot rescue staking token");
301         //owner can rescue rewardsToken if there is spare unused tokens on staking contract balance
302 
303         IBEP20(token).safeTransfer(to, amount);
304         emit RescueToken(to, address(token), amount);
305     }
306 
307     function rescue(address payable to, uint256 amount) external onlyOwner {
308         require(to != address(0), "LockStakingRewardFixedAPY: Cannot rescue to the zero address");
309         require(amount > 0, "LockStakingRewardFixedAPY: Cannot rescue 0");
310 
311         to.transfer(amount);
312         emit Rescue(to, amount);
313     }
314 }