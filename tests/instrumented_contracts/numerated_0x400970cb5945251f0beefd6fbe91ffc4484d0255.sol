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
88 library Math {
89     function max(uint256 a, uint256 b) internal pure returns (uint256) {
90         return a >= b ? a : b;
91     }
92 
93     function min(uint256 a, uint256 b) internal pure returns (uint256) {
94         return a < b ? a : b;
95     }
96 
97     function average(uint256 a, uint256 b) internal pure returns (uint256) {
98         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
99     }
100 
101     // babylonian method (https://en.wikipedia.org/wiki/Methods_of_computing_square_roots#Babylonian_method)
102     function sqrt(uint y) internal pure returns (uint z) {
103         if (y > 3) {
104             z = y;
105             uint x = y / 2 + 1;
106             while (x < z) {
107                 z = x;
108                 x = (y / x + x) / 2;
109             }
110         } else if (y != 0) {
111             z = 1;
112         }
113     }
114 }
115 
116 library Address {
117     function isContract(address account) internal view returns (bool) {
118         // This method relies in extcodesize, which returns 0 for contracts in construction, 
119         // since the code is only stored at the end of the constructor execution.
120 
121         uint256 size;
122         // solhint-disable-next-line no-inline-assembly
123         assembly { size := extcodesize(account) }
124         return size > 0;
125     }
126 }
127 
128 library SafeERC20 {
129     using SafeMath for uint256;
130     using Address for address;
131 
132     function safeTransfer(IERC20 token, address to, uint256 value) internal {
133         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
134     }
135 
136     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
137         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
138     }
139 
140     function safeApprove(IERC20 token, address spender, uint256 value) internal {
141         require((value == 0) || (token.allowance(address(this), spender) == 0),
142             "SafeERC20: approve from non-zero to non-zero allowance"
143         );
144         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
145     }
146 
147     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
148         uint256 newAllowance = token.allowance(address(this), spender).add(value);
149         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
150     }
151 
152     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
153         uint256 newAllowance = token.allowance(address(this), spender).sub(value);
154         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
155     }
156 
157     function callOptionalReturn(IERC20 token, bytes memory data) private {
158         require(address(token).isContract(), "SafeERC20: call to non-contract");
159 
160         (bool success, bytes memory returndata) = address(token).call(data);
161         require(success, "SafeERC20: low-level call failed");
162 
163         if (returndata.length > 0) { 
164             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
165         }
166     }
167 }
168 
169 contract ReentrancyGuard {
170     /// @dev counter to allow mutex lock with only one SSTORE operation
171     uint256 private _guardCounter;
172 
173     constructor () {
174         // The counter starts at one to prevent changing it from zero to a non-zero
175         // value, which is a more expensive operation.
176         _guardCounter = 1;
177     }
178 
179     modifier nonReentrant() {
180         _guardCounter += 1;
181         uint256 localCounter = _guardCounter;
182         _;
183         require(localCounter == _guardCounter, "ReentrancyGuard: reentrant call");
184     }
185 }
186 
187 interface IStakingRewards {
188     function earned(address account) external view returns (uint256);
189     function totalSupply() external view returns (uint256);
190     function balanceOf(address account) external view returns (uint256);
191     function stake(uint256 amount) external;
192     function stakeFor(uint256 amount, address user) external;
193     function getReward() external;
194     function withdraw(uint256 nonce) external;
195     function withdrawAndGetReward(uint256 nonce) external;
196 }
197 
198 interface IERC20Permit {
199     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
200 }
201 
202 contract StakingRewardFixedAPY is IStakingRewards, ReentrancyGuard, Ownable {
203     using SafeMath for uint256;
204     using SafeERC20 for IERC20;
205 
206     IERC20 public immutable rewardsToken;
207     IERC20 public immutable stakingToken;
208     INimbusRouter public swapRouter;
209     uint256 public rewardRate; 
210     uint256 public constant rewardDuration = 365 days; 
211 
212     mapping(address => uint256) public weightedStakeDate;
213     mapping(address => mapping(uint256 => uint256)) public stakeAmounts;
214     mapping(address => mapping(uint256 => uint256)) public stakeAmountsRewardEquivalent;
215     mapping(address => uint256) public stakeNonces;
216 
217     uint256 private _totalSupply;
218     uint256 private _totalSupplyRewardEquivalent;
219     mapping(address => uint256) private _balances;
220     mapping(address => uint256) private _balancesRewardEquivalent;
221 
222     event RewardUpdated(uint256 reward);
223     event Staked(address indexed user, uint256 amount);
224     event Withdrawn(address indexed user, uint256 amount);
225     event RewardPaid(address indexed user, uint256 reward);
226     event Rescue(address to, uint amount);
227     event RescueToken(address to, address token, uint amount);
228 
229     constructor(
230         address _rewardsToken,
231         address _stakingToken,
232         address _swapRouter,
233         uint _rewardRate
234     ) {
235         rewardsToken = IERC20(_rewardsToken);
236         stakingToken = IERC20(_stakingToken);
237         swapRouter = INimbusRouter(_swapRouter);
238         rewardRate = _rewardRate;
239     }
240 
241     function totalSupply() external view override returns (uint256) {
242         return _totalSupply;
243     }
244 
245     function totalSupplyRewardEquivalent() external view returns (uint256) {
246         return _totalSupplyRewardEquivalent;
247     }
248 
249     function balanceOf(address account) external view override returns (uint256) {
250         return _balances[account];
251     }
252     
253     function balanceOfRewardEquivalent(address account) external view returns (uint256) {
254         return _balancesRewardEquivalent[account];
255     }
256 
257     function earned(address account) public view override returns (uint256) {
258         return (_balancesRewardEquivalent[account].mul(block.timestamp.sub(weightedStakeDate[account])).mul(rewardRate)) / (100 * rewardDuration);
259     }
260 
261     function stakeWithPermit(uint256 amount, uint deadline, uint8 v, bytes32 r, bytes32 s) external nonReentrant {
262         require(amount > 0, "Cannot stake 0");
263         // permit
264         IERC20Permit(address(stakingToken)).permit(msg.sender, address(this), amount, deadline, v, r, s);
265         _stake(amount, msg.sender);
266     }
267 
268     function stake(uint256 amount) external override nonReentrant {
269         require(amount > 0, "StakingRewardFixedAPY: Cannot stake 0");
270         _stake(amount, msg.sender);
271     }
272 
273     function stakeFor(uint256 amount, address user) external override nonReentrant {
274         require(amount > 0, "StakingRewardFixedAPY: Cannot stake 0");
275         _stake(amount, user);
276     }
277 
278     function _stake(uint256 amount, address user) private {
279         stakingToken.safeTransferFrom(msg.sender, address(this), amount);
280         uint amountRewardEquivalent = getEquivalentAmount(amount);
281 
282         _totalSupply = _totalSupply.add(amount);
283         _totalSupplyRewardEquivalent = _totalSupplyRewardEquivalent.add(amountRewardEquivalent);
284         uint previousAmount = _balances[user];
285         uint newAmount = previousAmount.add(amount);
286         weightedStakeDate[user] = (weightedStakeDate[user].mul(previousAmount) / newAmount).add(block.timestamp.mul(amount) / newAmount);
287         _balances[user] = newAmount;
288 
289         uint stakeNonce = stakeNonces[user]++;
290         stakeAmounts[user][stakeNonce] = amount;
291         
292         stakeAmountsRewardEquivalent[user][stakeNonce] = amountRewardEquivalent;
293         _balancesRewardEquivalent[user] = _balancesRewardEquivalent[user].add(amountRewardEquivalent);
294         emit Staked(user, amount);
295     }
296 
297 
298     //A user can withdraw its staking tokens even if there is no rewards tokens on the contract account
299     function withdraw(uint256 nonce) public override nonReentrant {
300         require(stakeAmounts[msg.sender][nonce] > 0, "StakingRewardFixedAPY: This stake nonce was withdrawn");
301         uint amount = stakeAmounts[msg.sender][nonce];
302         uint amountRewardEquivalent = stakeAmountsRewardEquivalent[msg.sender][nonce];
303         _totalSupply = _totalSupply.sub(amount);
304         _totalSupplyRewardEquivalent = _totalSupplyRewardEquivalent.sub(amountRewardEquivalent);
305         _balances[msg.sender] = _balances[msg.sender].sub(amount);
306         _balancesRewardEquivalent[msg.sender] = _balancesRewardEquivalent[msg.sender].sub(amountRewardEquivalent);
307         stakingToken.safeTransfer(msg.sender, amount);
308         stakeAmounts[msg.sender][nonce] = 0;
309         stakeAmountsRewardEquivalent[msg.sender][nonce] = 0;
310         emit Withdrawn(msg.sender, amount);
311     }
312 
313     function getReward() public override nonReentrant {
314         uint256 reward = earned(msg.sender);
315         if (reward > 0) {
316             weightedStakeDate[msg.sender] = block.timestamp;
317             rewardsToken.safeTransfer(msg.sender, reward);
318             emit RewardPaid(msg.sender, reward);
319         }
320     }
321 
322     function withdrawAndGetReward(uint256 nonce) external override {
323         getReward();
324         withdraw(nonce);
325     }
326 
327     function getEquivalentAmount(uint amount) public view returns (uint) {
328         address[] memory path = new address[](2);
329 
330         uint equivalent;
331         if (stakingToken != rewardsToken) {
332             path[0] = address(stakingToken);            
333             path[1] = address(rewardsToken);
334             equivalent = swapRouter.getAmountsOut(amount, path)[1];
335         } else {
336             equivalent = amount;   
337         }
338         
339         return equivalent;
340     }
341 
342 
343     function updateRewardAmount(uint256 reward) external onlyOwner {
344         rewardRate = reward;
345         emit RewardUpdated(reward);
346     }
347 
348     function updateSwapRouter(address newSwapRouter) external onlyOwner {
349         require(newSwapRouter != address(0), "StakingRewardFixedAPY: Address is zero");
350         swapRouter = INimbusRouter(newSwapRouter);
351     }
352 
353     function rescue(address to, address token, uint256 amount) external onlyOwner {
354         require(to != address(0), "StakingRewardFixedAPY: Cannot rescue to the zero address");
355         require(amount > 0, "StakingRewardFixedAPY: Cannot rescue 0");
356         require(token != address(stakingToken), "StakingRewardFixedAPY: Cannot rescue staking token");
357         //owner can rescue rewardsToken if there is spare unused tokens on staking contract balance
358 
359         IERC20(token).safeTransfer(to, amount);
360         emit RescueToken(to, address(token), amount);
361     }
362 
363     function rescue(address payable to, uint256 amount) external onlyOwner {
364         require(to != address(0), "StakingRewardFixedAPY: Cannot rescue to the zero address");
365         require(amount > 0, "StakingRewardFixedAPY: Cannot rescue 0");
366 
367         to.transfer(amount);
368         emit Rescue(to, amount);
369     }
370 }