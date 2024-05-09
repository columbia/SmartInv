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
14 interface INimbusRouter {
15     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
16 }
17 
18 contract Ownable {
19     address public owner;
20     address public newOwner;
21 
22     event OwnershipTransferred(address indexed from, address indexed to);
23 
24     constructor() {
25         owner = msg.sender;
26         emit OwnershipTransferred(address(0), owner);
27     }
28 
29     modifier onlyOwner {
30         require(msg.sender == owner, "Ownable: Caller is not the owner");
31         _;
32     }
33 
34     function transferOwnership(address transferOwner) public onlyOwner {
35         require(transferOwner != newOwner);
36         newOwner = transferOwner;
37     }
38 
39     function acceptOwnership() virtual public {
40         require(msg.sender == newOwner);
41         emit OwnershipTransferred(owner, newOwner);
42         owner = newOwner;
43         newOwner = address(0);
44     }
45 }
46 
47 library SafeMath {
48     function add(uint256 a, uint256 b) internal pure returns (uint256) {
49         uint256 c = a + b;
50         require(c >= a, "SafeMath: addition overflow");
51 
52         return c;
53     }
54 
55     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
56         require(b <= a, "SafeMath: subtraction overflow");
57         uint256 c = a - b;
58 
59         return c;
60     }
61 
62     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
63       if (a == 0) {
64             return 0;
65         }
66 
67         uint256 c = a * b;
68         require(c / a == b, "SafeMath: multiplication overflow");
69 
70         return c;
71     }
72 
73     function div(uint256 a, uint256 b) internal pure returns (uint256) {
74         // Solidity only automatically asserts when dividing by 0
75         require(b > 0, "SafeMath: division by zero");
76         uint256 c = a / b;
77         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
78 
79         return c;
80     }
81 
82     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
83         require(b != 0, "SafeMath: modulo by zero");
84         return a % b;
85     }
86 }
87 
88 library Address {
89     function isContract(address account) internal view returns (bool) {
90         // This method relies in extcodesize, which returns 0 for contracts in construction, 
91         // since the code is only stored at the end of the constructor execution.
92 
93         uint256 size;
94         // solhint-disable-next-line no-inline-assembly
95         assembly { size := extcodesize(account) }
96         return size > 0;
97     }
98 }
99 
100 library SafeERC20 {
101     using SafeMath for uint256;
102     using Address for address;
103 
104     function safeTransfer(IERC20 token, address to, uint256 value) internal {
105         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
106     }
107 
108     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
109         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
110     }
111 
112     function safeApprove(IERC20 token, address spender, uint256 value) internal {
113         require((value == 0) || (token.allowance(address(this), spender) == 0),
114             "SafeERC20: approve from non-zero to non-zero allowance"
115         );
116         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
117     }
118 
119     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
120         uint256 newAllowance = token.allowance(address(this), spender).add(value);
121         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
122     }
123 
124     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
125         uint256 newAllowance = token.allowance(address(this), spender).sub(value);
126         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
127     }
128 
129     function callOptionalReturn(IERC20 token, bytes memory data) private {
130         require(address(token).isContract(), "SafeERC20: call to non-contract");
131 
132         (bool success, bytes memory returndata) = address(token).call(data);
133         require(success, "SafeERC20: low-level call failed");
134 
135         if (returndata.length > 0) { 
136             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
137         }
138     }
139 }
140 
141 contract ReentrancyGuard {
142     /// @dev counter to allow mutex lock with only one SSTORE operation
143     uint256 private _guardCounter;
144 
145     constructor () {
146         // The counter starts at one to prevent changing it from zero to a non-zero
147         // value, which is a more expensive operation.
148         _guardCounter = 1;
149     }
150 
151     modifier nonReentrant() {
152         _guardCounter += 1;
153         uint256 localCounter = _guardCounter;
154         _;
155         require(localCounter == _guardCounter, "ReentrancyGuard: reentrant call");
156     }
157 }
158 
159 interface ILockStakingRewards {
160     function earned(address account) external view returns (uint256);
161     function totalSupply() external view returns (uint256);
162     function balanceOf(address account) external view returns (uint256);
163     function stake(uint256 amount) external;
164     function stakeFor(uint256 amount, address user) external;
165     function getReward() external;
166     function withdraw(uint256 nonce) external;
167     function withdrawAndGetReward(uint256 nonce) external;
168 }
169 
170 interface IERC20Permit {
171     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
172 }
173 
174 contract LockStakingRewardMinAmountFixedAPY is ILockStakingRewards, ReentrancyGuard, Ownable {
175     using SafeMath for uint256;
176     using SafeERC20 for IERC20;
177 
178     IERC20 public immutable rewardsToken;
179     IERC20 public immutable stakingToken;
180     uint256 public rewardRate; 
181     uint256 public immutable lockDuration; 
182     uint256 public constant rewardDuration = 365 days; 
183     
184     INimbusRouter public swapRouter;
185     address public swapToken;                       
186     uint public swapTokenAmountThresholdForStaking;
187 
188     mapping(address => uint256) public weightedStakeDate;
189     mapping(address => mapping(uint256 => uint256)) public stakeLocks;
190     mapping(address => mapping(uint256 => uint256)) public stakeAmounts;
191     mapping(address => mapping(uint256 => uint256)) public stakeAmountsRewardEquivalent;
192     mapping(address => uint256) public stakeNonces;
193 
194     uint256 private _totalSupply;
195     uint256 private _totalSupplyRewardEquivalent;
196     mapping(address => uint256) private _balances;
197     mapping(address => uint256) private _balancesRewardEquivalent;
198 
199     event RewardUpdated(uint256 reward);
200     event Staked(address indexed user, uint256 amount);
201     event Withdrawn(address indexed user, uint256 amount);
202     event RewardPaid(address indexed user, uint256 reward);
203     event Rescue(address to, uint amount);
204     event RescueToken(address to, address token, uint amount);
205 
206     constructor(
207         address _rewardsToken,
208         address _stakingToken,
209         uint _rewardRate,
210         uint _lockDuration,
211         address _swapRouter,
212         address _swapToken,
213         uint _swapTokenAmount
214     ) {
215         rewardsToken = IERC20(_rewardsToken);
216         stakingToken = IERC20(_stakingToken);
217         rewardRate = _rewardRate;
218         lockDuration = _lockDuration;
219         swapRouter = INimbusRouter(_swapRouter);
220         swapToken = _swapToken;
221         swapTokenAmountThresholdForStaking = _swapTokenAmount;
222     }
223 
224     function totalSupply() external view override returns (uint256) {
225         return _totalSupply;
226     }
227 
228     function totalSupplyRewardEquivalent() external view returns (uint256) {
229         return _totalSupplyRewardEquivalent;
230     }
231 
232     function balanceOf(address account) external view override returns (uint256) {
233         return _balances[account];
234     }
235     
236     function balanceOfRewardEquivalent(address account) external view returns (uint256) {
237         return _balancesRewardEquivalent[account];
238     }
239 
240     function earned(address account) public view override returns (uint256) {
241         return (_balancesRewardEquivalent[account].mul(block.timestamp.sub(weightedStakeDate[account])).mul(rewardRate)) / (100 * rewardDuration);
242     }
243 
244     function isAmountMeetsMinThreshold(uint amount) public view returns (bool) {
245         address[] memory path = new address[](2);
246         path[0] = address(stakingToken);
247         path[1] = swapToken;
248         uint tokenAmount = swapRouter.getAmountsOut(amount, path)[1];
249         return tokenAmount >= swapTokenAmountThresholdForStaking;
250     }
251 
252     function stakeWithPermit(uint256 amount, uint deadline, uint8 v, bytes32 r, bytes32 s) external nonReentrant {
253         require(amount > 0, "LockStakingRewardMinAmountFixedAPY: Cannot stake 0");
254         // permit
255         IERC20Permit(address(stakingToken)).permit(msg.sender, address(this), amount, deadline, v, r, s);
256         _stake(amount, msg.sender);
257     }
258 
259     function stake(uint256 amount) external override nonReentrant {
260         require(amount > 0, "LockStakingRewardMinAmountFixedAPY: Cannot stake 0");
261         _stake(amount, msg.sender);
262     }
263 
264     function stakeFor(uint256 amount, address user) external override nonReentrant {
265         require(amount > 0, "LockStakingRewardMinAmountFixedAPY: Cannot stake 0");
266         _stake(amount, user);
267     }
268 
269     function _stake(uint256 amount, address user) private {
270         require(isAmountMeetsMinThreshold(amount), "LockStakingRewardMinAmountFixedAPY: Amount is less than min stake");
271         stakingToken.safeTransferFrom(msg.sender, address(this), amount);
272         uint amountRewardEquivalent = getEquivalentAmount(amount);
273 
274         _totalSupply = _totalSupply.add(amount);
275         _totalSupplyRewardEquivalent = _totalSupplyRewardEquivalent.add(amountRewardEquivalent);
276         uint previousAmount = _balances[user];
277         uint newAmount = previousAmount.add(amount);
278         weightedStakeDate[user] = (weightedStakeDate[user].mul(previousAmount) / newAmount).add(block.timestamp.mul(amount) / newAmount);
279         _balances[user] = newAmount;
280 
281         uint stakeNonce = stakeNonces[user]++;
282         stakeAmounts[user][stakeNonce] = amount;
283         stakeLocks[user][stakeNonce] = block.timestamp + lockDuration;
284         
285         stakeAmountsRewardEquivalent[user][stakeNonce] = amountRewardEquivalent;
286         _balancesRewardEquivalent[user] = _balancesRewardEquivalent[user].add(amountRewardEquivalent);
287         emit Staked(user, amount);
288     }
289 
290 
291     //A user can withdraw its staking tokens even if there is no rewards tokens on the contract account
292     function withdraw(uint256 nonce) public override nonReentrant {
293         require(stakeAmounts[msg.sender][nonce] > 0, "LockStakingRewardMinAmountFixedAPY: This stake nonce was withdrawn");
294         require(stakeLocks[msg.sender][nonce] < block.timestamp, "LockStakingRewardMinAmountFixedAPY: Locked");
295         uint amount = stakeAmounts[msg.sender][nonce];
296         uint amountRewardEquivalent = stakeAmountsRewardEquivalent[msg.sender][nonce];
297         _totalSupply = _totalSupply.sub(amount);
298         _totalSupplyRewardEquivalent = _totalSupplyRewardEquivalent.sub(amountRewardEquivalent);
299         _balances[msg.sender] = _balances[msg.sender].sub(amount);
300         _balancesRewardEquivalent[msg.sender] = _balancesRewardEquivalent[msg.sender].sub(amountRewardEquivalent);
301         stakingToken.safeTransfer(msg.sender, amount);
302         stakeAmounts[msg.sender][nonce] = 0;
303         stakeAmountsRewardEquivalent[msg.sender][nonce] = 0;
304         emit Withdrawn(msg.sender, amount);
305     }
306 
307     function getReward() public override nonReentrant {
308         uint256 reward = earned(msg.sender);
309         if (reward > 0) {
310             weightedStakeDate[msg.sender] = block.timestamp;
311             rewardsToken.safeTransfer(msg.sender, reward);
312             emit RewardPaid(msg.sender, reward);
313         }
314     }
315 
316     function withdrawAndGetReward(uint256 nonce) external override {
317         getReward();
318         withdraw(nonce);
319     }
320 
321     function getEquivalentAmount(uint amount) public view returns (uint) {
322         address[] memory path = new address[](2);
323 
324         uint equivalent;
325         if (stakingToken != rewardsToken) {
326             path[0] = address(stakingToken);            
327             path[1] = address(rewardsToken);
328             equivalent = swapRouter.getAmountsOut(amount, path)[1];
329         } else {
330             equivalent = amount;   
331         }
332         
333         return equivalent;
334     }
335 
336 
337     function updateRewardAmount(uint256 reward) external onlyOwner {
338         rewardRate = reward;
339         emit RewardUpdated(reward);
340     }
341 
342     function updateSwapRouter(address newSwapRouter) external onlyOwner {
343         require(newSwapRouter != address(0), "LockStakingRewardMinAmountFixedAPY: Address is zero");
344         swapRouter = INimbusRouter(newSwapRouter);
345     }
346 
347     function updateSwapToken(address newSwapToken) external onlyOwner {
348         require(newSwapToken != address(0), "LockStakingRewardMinAmountFixedAPY: Address is zero");
349         swapToken = newSwapToken;
350     }
351 
352     function updateStakeSwapTokenAmountThreshold(uint threshold) external onlyOwner {
353         swapTokenAmountThresholdForStaking = threshold;
354     }
355 
356     function rescue(address to, address token, uint256 amount) external onlyOwner {
357         require(to != address(0), "LockStakingRewardMinAmountFixedAPY: Cannot rescue to the zero address");
358         require(amount > 0, "LockStakingRewardMinAmountFixedAPY: Cannot rescue 0");
359         require(token != address(stakingToken), "LockStakingRewardMinAmountFixedAPY: Cannot rescue staking token");
360         //owner can rescue rewardsToken if there is spare unused tokens on staking contract balance
361 
362         IERC20(token).safeTransfer(to, amount);
363         emit RescueToken(to, address(token), amount);
364     }
365 
366     function rescue(address payable to, uint256 amount) external onlyOwner {
367         require(to != address(0), "LockStakingRewardMinAmountFixedAPY: Cannot rescue to the zero address");
368         require(amount > 0, "LockStakingRewardMinAmountFixedAPY: Cannot rescue 0");
369 
370         to.transfer(amount);
371         emit Rescue(to, amount);
372     }
373 }