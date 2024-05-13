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
139 contract StakingRewardMinAmountFixedAPY is IStakingRewards, ReentrancyGuard, Ownable {
140     using SafeBEP20 for IBEP20;
141 
142     IBEP20 public immutable rewardsToken;
143     IBEP20 public immutable stakingToken;
144     uint256 public rewardRate; 
145     uint256 public constant rewardDuration = 365 days; 
146     
147     INimbusRouter public swapRouter;
148     address public swapToken;                       
149     uint public swapTokenAmountThresholdForStaking;
150 
151     mapping(address => uint256) public weightedStakeDate;
152     mapping(address => mapping(uint256 => uint256)) public stakeAmounts;
153     mapping(address => mapping(uint256 => uint256)) public stakeAmountsRewardEquivalent;
154     mapping(address => uint256) public stakeNonces;
155 
156     uint256 private _totalSupply;
157     uint256 private _totalSupplyRewardEquivalent;
158     mapping(address => uint256) private _balances;
159     mapping(address => uint256) private _balancesRewardEquivalent;
160 
161     event RewardUpdated(uint256 reward);
162     event Staked(address indexed user, uint256 amount);
163     event Withdrawn(address indexed user, uint256 amount);
164     event RewardPaid(address indexed user, uint256 reward);
165     event Rescue(address indexed to, uint amount);
166     event RescueToken(address indexed to, address indexed token, uint amount);
167 
168     constructor(
169         address _rewardsToken,
170         address _stakingToken,
171         uint _rewardRate,
172         address _swapRouter,
173         address _swapToken,
174         uint _swapTokenAmount
175     ) {
176         require(_rewardsToken != address(0) && _stakingToken != address(0) && _swapRouter != address(0) && _swapToken != address(0), "StakingRewardMinAmountFixedAPY: Zero address(es)");
177         rewardsToken = IBEP20(_rewardsToken);
178         stakingToken = IBEP20(_stakingToken);
179         swapRouter = INimbusRouter(_swapRouter);
180         rewardRate = _rewardRate;
181         swapToken = _swapToken;
182         swapTokenAmountThresholdForStaking = _swapTokenAmount;
183     }
184 
185     function totalSupply() external view override returns (uint256) {
186         return _totalSupply;
187     }
188 
189     function totalSupplyRewardEquivalent() external view returns (uint256) {
190         return _totalSupplyRewardEquivalent;
191     }
192 
193     function balanceOf(address account) external view override returns (uint256) {
194         return _balances[account];
195     }
196     
197     function balanceOfRewardEquivalent(address account) external view returns (uint256) {
198         return _balancesRewardEquivalent[account];
199     }
200 
201     function earned(address account) public view override returns (uint256) {
202         return (_balancesRewardEquivalent[account] * (block.timestamp - weightedStakeDate[account]) * rewardRate) / (100 * rewardDuration);
203     }
204 
205     function isAmountMeetsMinThreshold(uint amount) public view returns (bool) {
206         address[] memory path = new address[](2);
207         path[0] = address(stakingToken);
208         path[1] = swapToken;
209         uint tokenAmount = swapRouter.getAmountsOut(amount, path)[1];
210         return tokenAmount >= swapTokenAmountThresholdForStaking;
211     }
212 
213     function stakeWithPermit(uint256 amount, uint deadline, uint8 v, bytes32 r, bytes32 s) external nonReentrant {
214         require(amount > 0, "StakingRewardMinAmountFixedAPY: Cannot stake 0");
215         // permit
216         IBEP20Permit(address(stakingToken)).permit(msg.sender, address(this), amount, deadline, v, r, s);
217         _stake(amount, msg.sender);
218     }
219 
220     function stake(uint256 amount) external override nonReentrant {
221         require(amount > 0, "StakingRewardMinAmountFixedAPY: Cannot stake 0");
222         _stake(amount, msg.sender);
223     }
224 
225     function stakeFor(uint256 amount, address user) external override nonReentrant {
226         require(amount > 0, "StakingRewardMinAmountFixedAPY: Cannot stake 0");
227         require(user != address(0), "StakingRewardMinAmountFixedAPY: Cannot stake for zero address");
228         _stake(amount, user);
229     }
230 
231     function _stake(uint256 amount, address user) private {
232         require(isAmountMeetsMinThreshold(amount), "StakingRewardMinAmountFixedAPY: Amount is less than min stake");
233         stakingToken.safeTransferFrom(msg.sender, address(this), amount);
234         uint amountRewardEquivalent = getEquivalentAmount(amount);
235 
236         _totalSupply += amount;
237         _totalSupplyRewardEquivalent += amountRewardEquivalent;
238         uint previousAmount = _balances[user];
239         uint newAmount = previousAmount + amount;
240         weightedStakeDate[user] = (weightedStakeDate[user] * previousAmount / newAmount) + (block.timestamp * amount / newAmount);
241         _balances[user] = newAmount;
242 
243         uint stakeNonce = stakeNonces[user]++;
244         stakeAmounts[user][stakeNonce] = amount;
245         
246         stakeAmountsRewardEquivalent[user][stakeNonce] = amountRewardEquivalent;
247         _balancesRewardEquivalent[user] = _balancesRewardEquivalent[user] + amountRewardEquivalent;
248         emit Staked(user, amount);
249     }
250 
251 
252     //A user can withdraw its staking tokens even if there is no rewards tokens on the contract account
253     function withdraw(uint256 nonce) public override nonReentrant {
254         require(stakeAmounts[msg.sender][nonce] > 0, "StakingRewardMinAmountFixedAPY: This stake nonce was withdrawn");
255         uint amount = stakeAmounts[msg.sender][nonce];
256         uint amountRewardEquivalent = stakeAmountsRewardEquivalent[msg.sender][nonce];
257         _totalSupply -= amount;
258         _totalSupplyRewardEquivalent -= amountRewardEquivalent;
259         _balances[msg.sender] -= amount;
260         _balancesRewardEquivalent[msg.sender] -= amountRewardEquivalent;
261         stakingToken.safeTransfer(msg.sender, amount);
262         stakeAmounts[msg.sender][nonce] = 0;
263         stakeAmountsRewardEquivalent[msg.sender][nonce] = 0;
264         emit Withdrawn(msg.sender, amount);
265     }
266 
267     function getReward() public override nonReentrant {
268         uint256 reward = earned(msg.sender);
269         if (reward > 0) {
270             weightedStakeDate[msg.sender] = block.timestamp;
271             rewardsToken.safeTransfer(msg.sender, reward);
272             emit RewardPaid(msg.sender, reward);
273         }
274     }
275 
276     function withdrawAndGetReward(uint256 nonce) external override {
277         getReward();
278         withdraw(nonce);
279     }
280 
281     function getEquivalentAmount(uint amount) public view returns (uint) {
282         address[] memory path = new address[](2);
283 
284         uint equivalent;
285         if (stakingToken != rewardsToken) {
286             path[0] = address(stakingToken);            
287             path[1] = address(rewardsToken);
288             equivalent = swapRouter.getAmountsOut(amount, path)[1];
289         } else {
290             equivalent = amount;   
291         }
292         
293         return equivalent;
294     }
295 
296 
297     function updateRewardAmount(uint256 reward) external onlyOwner {
298         rewardRate = reward;
299         emit RewardUpdated(reward);
300     }
301 
302     function updateSwapRouter(address newSwapRouter) external onlyOwner {
303         require(newSwapRouter != address(0), "StakingRewardMinAmountFixedAPY: Address is zero");
304         swapRouter = INimbusRouter(newSwapRouter);
305     }
306 
307     function updateSwapToken(address newSwapToken) external onlyOwner {
308         require(newSwapToken != address(0), "StakingRewardMinAmountFixedAPY: Address is zero");
309         swapToken = newSwapToken;
310     }
311 
312     function updateStakeSwapTokenAmountThreshold(uint threshold) external onlyOwner {
313         swapTokenAmountThresholdForStaking = threshold;
314     }
315 
316     function rescue(address to, address token, uint256 amount) external onlyOwner {
317         require(to != address(0), "StakingRewardMinAmountFixedAPY: Cannot rescue to the zero address");
318         require(amount > 0, "StakingRewardMinAmountFixedAPY: Cannot rescue 0");
319         require(token != address(stakingToken), "StakingRewardMinAmountFixedAPY: Cannot rescue staking token");
320         //owner can rescue rewardsToken if there is spare unused tokens on staking contract balance
321 
322         IBEP20(token).safeTransfer(to, amount);
323         emit RescueToken(to, address(token), amount);
324     }
325 
326     function rescue(address payable to, uint256 amount) external onlyOwner {
327         require(to != address(0), "StakingRewardMinAmountFixedAPY: Cannot rescue to the zero address");
328         require(amount > 0, "StakingRewardMinAmountFixedAPY: Cannot rescue 0");
329 
330         to.transfer(amount);
331         emit Rescue(to, amount);
332     }
333 }