1 pragma solidity =0.8.0;
2 
3 interface IBEP20 {
4     function totalSupply() external view returns (uint256);
5     function balanceOf(address account) external view returns (uint256);
6     function transfer(address recipient, uint256 amount) external returns (bool);
7     function allowance(address owner, address spender) external view returns (uint256);
8     function approve(address spender, uint256 amount) external returns (bool);
9     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
10     function getOwner() external view returns (address);
11     
12     event Transfer(address indexed from, address indexed to, uint256 value);
13     event Approval(address indexed owner, address indexed spender, uint256 value);
14 }
15 
16 interface INimbusRouter {
17     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
18 }
19 
20 contract Ownable {
21     address public owner;
22     address public newOwner;
23 
24     event OwnershipTransferred(address indexed from, address indexed to);
25 
26     constructor() {
27         owner = msg.sender;
28         emit OwnershipTransferred(address(0), owner);
29     }
30 
31     modifier onlyOwner {
32         require(msg.sender == owner, "Ownable: Caller is not the owner");
33         _;
34     }
35 
36     function getOwner() external view returns (address) {
37         return owner;
38     }
39 
40     function transferOwnership(address transferOwner) external onlyOwner {
41         require(transferOwner != newOwner);
42         newOwner = transferOwner;
43     }
44 
45     function acceptOwnership() virtual external {
46         require(msg.sender == newOwner);
47         emit OwnershipTransferred(owner, newOwner);
48         owner = newOwner;
49         newOwner = address(0);
50     }
51 }
52 
53 library Address {
54     function isContract(address account) internal view returns (bool) {
55         // This method relies in extcodesize, which returns 0 for contracts in construction, 
56         // since the code is only stored at the end of the constructor execution.
57 
58         uint256 size;
59         // solhint-disable-next-line no-inline-assembly
60         assembly { size := extcodesize(account) }
61         return size > 0;
62     }
63 }
64 
65 library SafeBEP20 {
66     using Address for address;
67 
68     function safeTransfer(IBEP20 token, address to, uint256 value) internal {
69         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
70     }
71 
72     function safeTransferFrom(IBEP20 token, address from, address to, uint256 value) internal {
73         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
74     }
75 
76     function safeApprove(IBEP20 token, address spender, uint256 value) internal {
77         require((value == 0) || (token.allowance(address(this), spender) == 0),
78             "SafeBEP20: approve from non-zero to non-zero allowance"
79         );
80         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
81     }
82 
83     function safeIncreaseAllowance(IBEP20 token, address spender, uint256 value) internal {
84         uint256 newAllowance = token.allowance(address(this), spender) + value;
85         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
86     }
87 
88     function safeDecreaseAllowance(IBEP20 token, address spender, uint256 value) internal {
89         uint256 newAllowance = token.allowance(address(this), spender) - value;
90         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
91     }
92 
93     function callOptionalReturn(IBEP20 token, bytes memory data) private {
94         require(address(token).isContract(), "SafeBEP20: call to non-contract");
95 
96         (bool success, bytes memory returndata) = address(token).call(data);
97         require(success, "SafeBEP20: low-level call failed");
98 
99         if (returndata.length > 0) { 
100             require(abi.decode(returndata, (bool)), "SafeBEP20: BEP20 operation did not succeed");
101         }
102     }
103 }
104 
105 contract ReentrancyGuard {
106     /// @dev counter to allow mutex lock with only one SSTORE operation
107     uint256 private _guardCounter;
108 
109     constructor () {
110         // The counter starts at one to prevent changing it from zero to a non-zero
111         // value, which is a more expensive operation.
112         _guardCounter = 1;
113     }
114 
115     modifier nonReentrant() {
116         _guardCounter += 1;
117         uint256 localCounter = _guardCounter;
118         _;
119         require(localCounter == _guardCounter, "ReentrancyGuard: reentrant call");
120     }
121 }
122 
123 interface ILockStakingRewards {
124     function earned(address account) external view returns (uint256);
125     function totalSupply() external view returns (uint256);
126     function balanceOf(address account) external view returns (uint256);
127     function stake(uint256 amount) external;
128     function stakeFor(uint256 amount, address user) external;
129     function getReward() external;
130     function withdraw(uint256 nonce) external;
131     function withdrawAndGetReward(uint256 nonce) external;
132 }
133 
134 interface IBEP20Permit {
135     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
136 }
137 
138 contract LockStakingRewardMinAmountFixedAPY is ILockStakingRewards, ReentrancyGuard, Ownable {
139     using SafeBEP20 for IBEP20;
140 
141     IBEP20 public immutable rewardsToken;
142     IBEP20 public immutable stakingToken;
143     uint256 public rewardRate; 
144     uint256 public immutable lockDuration; 
145     uint256 public constant rewardDuration = 365 days; 
146     
147     INimbusRouter public swapRouter;
148     address public swapToken;                       
149     uint public swapTokenAmountThresholdForStaking;
150 
151     mapping(address => uint256) public weightedStakeDate;
152     mapping(address => mapping(uint256 => uint256)) public stakeLocks;
153     mapping(address => mapping(uint256 => uint256)) public stakeAmounts;
154     mapping(address => mapping(uint256 => uint256)) public stakeAmountsRewardEquivalent;
155     mapping(address => uint256) public stakeNonces;
156 
157     uint256 private _totalSupply;
158     uint256 private _totalSupplyRewardEquivalent;
159     mapping(address => uint256) private _balances;
160     mapping(address => uint256) private _balancesRewardEquivalent;
161 
162     event RewardUpdated(uint256 reward);
163     event Staked(address indexed user, uint256 amount);
164     event Withdrawn(address indexed user, uint256 amount);
165     event RewardPaid(address indexed user, uint256 reward);
166     event Rescue(address indexed to, uint amount);
167     event RescueToken(address indexed to, address indexed token, uint amount);
168 
169     constructor(
170         address _rewardsToken,
171         address _stakingToken,
172         uint _rewardRate,
173         uint _lockDuration,
174         address _swapRouter,
175         address _swapToken,
176         uint _swapTokenAmount
177     ) {
178         require(_rewardsToken != address(0) && _stakingToken != address(0) && _swapRouter != address(0) && _swapToken != address(0), "LockStakingRewardMinAmountFixedAPY: Zero address(es)");
179         rewardsToken = IBEP20(_rewardsToken);
180         stakingToken = IBEP20(_stakingToken);
181         rewardRate = _rewardRate;
182         lockDuration = _lockDuration;
183         swapRouter = INimbusRouter(_swapRouter);
184         swapToken = _swapToken;
185         swapTokenAmountThresholdForStaking = _swapTokenAmount;
186     }
187 
188     function totalSupply() external view override returns (uint256) {
189         return _totalSupply;
190     }
191 
192     function totalSupplyRewardEquivalent() external view returns (uint256) {
193         return _totalSupplyRewardEquivalent;
194     }
195 
196     function balanceOf(address account) external view override returns (uint256) {
197         return _balances[account];
198     }
199     
200     function balanceOfRewardEquivalent(address account) external view returns (uint256) {
201         return _balancesRewardEquivalent[account];
202     }
203 
204     function earned(address account) public view override returns (uint256) {
205         return (_balancesRewardEquivalent[account] * (block.timestamp - weightedStakeDate[account]) * rewardRate) / (100 * rewardDuration);
206     }
207 
208     function isAmountMeetsMinThreshold(uint amount) public view returns (bool) {
209         address[] memory path = new address[](2);
210         path[0] = address(stakingToken);
211         path[1] = swapToken;
212         uint tokenAmount = swapRouter.getAmountsOut(amount, path)[1];
213         return tokenAmount >= swapTokenAmountThresholdForStaking;
214     }
215 
216     function stakeWithPermit(uint256 amount, uint deadline, uint8 v, bytes32 r, bytes32 s) external nonReentrant {
217         require(amount > 0, "LockStakingRewardMinAmountFixedAPY: Cannot stake 0");
218         // permit
219         IBEP20Permit(address(stakingToken)).permit(msg.sender, address(this), amount, deadline, v, r, s);
220         _stake(amount, msg.sender);
221     }
222 
223     function stake(uint256 amount) external override nonReentrant {
224         require(amount > 0, "LockStakingRewardMinAmountFixedAPY: Cannot stake 0");
225         _stake(amount, msg.sender);
226     }
227 
228     function stakeFor(uint256 amount, address user) external override nonReentrant {
229         require(amount > 0, "LockStakingRewardMinAmountFixedAPY: Cannot stake 0");
230         require(user != address(0), "LockStakingRewardMinAmountFixedAPY: Cannot stake for zero address");
231         _stake(amount, user);
232     }
233 
234     function _stake(uint256 amount, address user) private {
235         require(isAmountMeetsMinThreshold(amount), "LockStakingRewardMinAmountFixedAPY: Amount is less than min stake");
236         stakingToken.safeTransferFrom(msg.sender, address(this), amount);
237         uint amountRewardEquivalent = getEquivalentAmount(amount);
238 
239         _totalSupply += amount;
240         _totalSupplyRewardEquivalent += amountRewardEquivalent;
241         uint previousAmount = _balances[user];
242         uint newAmount = previousAmount + amount;
243         weightedStakeDate[user] = (weightedStakeDate[user] * previousAmount / newAmount) + (block.timestamp * amount / newAmount);
244         _balances[user] = newAmount;
245 
246         uint stakeNonce = stakeNonces[user]++;
247         stakeAmounts[user][stakeNonce] = amount;
248         stakeLocks[user][stakeNonce] = block.timestamp + lockDuration;
249         
250         stakeAmountsRewardEquivalent[user][stakeNonce] = amountRewardEquivalent;
251         _balancesRewardEquivalent[user] += amountRewardEquivalent;
252         emit Staked(user, amount);
253     }
254 
255 
256     //A user can withdraw its staking tokens even if there is no rewards tokens on the contract account
257     function withdraw(uint256 nonce) public override nonReentrant {
258         require(stakeAmounts[msg.sender][nonce] > 0, "LockStakingRewardMinAmountFixedAPY: This stake nonce was withdrawn");
259         require(stakeLocks[msg.sender][nonce] < block.timestamp, "LockStakingRewardMinAmountFixedAPY: Locked");
260         uint amount = stakeAmounts[msg.sender][nonce];
261         uint amountRewardEquivalent = stakeAmountsRewardEquivalent[msg.sender][nonce];
262         _totalSupply -= amount;
263         _totalSupplyRewardEquivalent -= amountRewardEquivalent;
264         _balances[msg.sender] -= amount;
265         _balancesRewardEquivalent[msg.sender] -= amountRewardEquivalent;
266         stakingToken.safeTransfer(msg.sender, amount);
267         stakeAmounts[msg.sender][nonce] = 0;
268         stakeAmountsRewardEquivalent[msg.sender][nonce] = 0;
269         emit Withdrawn(msg.sender, amount);
270     }
271 
272     function getReward() public override nonReentrant {
273         uint256 reward = earned(msg.sender);
274         if (reward > 0) {
275             weightedStakeDate[msg.sender] = block.timestamp;
276             rewardsToken.safeTransfer(msg.sender, reward);
277             emit RewardPaid(msg.sender, reward);
278         }
279     }
280 
281     function withdrawAndGetReward(uint256 nonce) external override {
282         getReward();
283         withdraw(nonce);
284     }
285 
286     function getEquivalentAmount(uint amount) public view returns (uint) {
287         address[] memory path = new address[](2);
288 
289         uint equivalent;
290         if (stakingToken != rewardsToken) {
291             path[0] = address(stakingToken);            
292             path[1] = address(rewardsToken);
293             equivalent = swapRouter.getAmountsOut(amount, path)[1];
294         } else {
295             equivalent = amount;   
296         }
297         
298         return equivalent;
299     }
300 
301 
302     function updateRewardAmount(uint256 reward) external onlyOwner {
303         rewardRate = reward;
304         emit RewardUpdated(reward);
305     }
306 
307     function updateSwapRouter(address newSwapRouter) external onlyOwner {
308         require(newSwapRouter != address(0), "LockStakingRewardMinAmountFixedAPY: Address is zero");
309         swapRouter = INimbusRouter(newSwapRouter);
310     }
311 
312     function updateSwapToken(address newSwapToken) external onlyOwner {
313         require(newSwapToken != address(0), "LockStakingRewardMinAmountFixedAPY: Address is zero");
314         swapToken = newSwapToken;
315     }
316 
317     function updateStakeSwapTokenAmountThreshold(uint threshold) external onlyOwner {
318         swapTokenAmountThresholdForStaking = threshold;
319     }
320 
321     function rescue(address to, address token, uint256 amount) external onlyOwner {
322         require(to != address(0), "LockStakingRewardMinAmountFixedAPY: Cannot rescue to the zero address");
323         require(amount > 0, "LockStakingRewardMinAmountFixedAPY: Cannot rescue 0");
324         require(token != address(stakingToken), "LockStakingRewardMinAmountFixedAPY: Cannot rescue staking token");
325         //owner can rescue rewardsToken if there is spare unused tokens on staking contract balance
326 
327         IBEP20(token).safeTransfer(to, amount);
328         emit RescueToken(to, address(token), amount);
329     }
330 
331     function rescue(address payable to, uint256 amount) external onlyOwner {
332         require(to != address(0), "LockStakingRewardMinAmountFixedAPY: Cannot rescue to the zero address");
333         require(amount > 0, "LockStakingRewardMinAmountFixedAPY: Cannot rescue 0");
334 
335         to.transfer(amount);
336         emit Rescue(to, amount);
337     }
338 }