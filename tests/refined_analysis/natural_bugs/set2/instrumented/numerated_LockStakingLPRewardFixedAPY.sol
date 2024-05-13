1 pragma solidity =0.8.0;
2 
3 interface IBEP20 {
4     function totalSupply() external view returns (uint256);
5     function decimals() external pure returns (uint8);
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
17 interface INimbusPair is IBEP20 {
18     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
19 }
20 
21 interface INimbusRouter {
22     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
23 }
24 
25 contract Ownable {
26     address public owner;
27     address public newOwner;
28 
29     event OwnershipTransferred(address indexed from, address indexed to);
30 
31     constructor() {
32         owner = msg.sender;
33         emit OwnershipTransferred(address(0), owner);
34     }
35 
36     modifier onlyOwner {
37         require(msg.sender == owner, "Ownable: Caller is not the owner");
38         _;
39     }
40 
41     function getOwner() external view returns (address) {
42         return owner;
43     }
44 
45     function transferOwnership(address transferOwner) external onlyOwner {
46         require(transferOwner != newOwner);
47         newOwner = transferOwner;
48     }
49 
50     function acceptOwnership() virtual external {
51         require(msg.sender == newOwner);
52         emit OwnershipTransferred(owner, newOwner);
53         owner = newOwner;
54         newOwner = address(0);
55     }
56 }
57 
58 library Math {
59     // babylonian method (https://en.wikipedia.org/wiki/Methods_of_computing_square_roots#Babylonian_method)
60     function sqrt(uint y) internal pure returns (uint z) {
61         if (y > 3) {
62             z = y;
63             uint x = y / 2 + 1;
64             while (x < z) {
65                 z = x;
66                 x = (y / x + x) / 2;
67             }
68         } else if (y != 0) {
69             z = 1;
70         }
71     }
72 }
73 
74 library Address {
75     function isContract(address account) internal view returns (bool) {
76         // This method relies in extcodesize, which returns 0 for contracts in construction, 
77         // since the code is only stored at the end of the constructor execution.
78 
79         uint256 size;
80         // solhint-disable-next-line no-inline-assembly
81         assembly { size := extcodesize(account) }
82         return size > 0;
83     }
84 }
85 
86 library SafeBEP20 {
87     using Address for address;
88 
89     function safeTransfer(IBEP20 token, address to, uint256 value) internal {
90         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
91     }
92 
93     function safeTransferFrom(IBEP20 token, address from, address to, uint256 value) internal {
94         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
95     }
96 
97     function safeApprove(IBEP20 token, address spender, uint256 value) internal {
98         require((value == 0) || (token.allowance(address(this), spender) == 0),
99             "SafeBEP20: approve from non-zero to non-zero allowance"
100         );
101         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
102     }
103 
104     function safeIncreaseAllowance(IBEP20 token, address spender, uint256 value) internal {
105         uint256 newAllowance = token.allowance(address(this), spender) + value;
106         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
107     }
108 
109     function safeDecreaseAllowance(IBEP20 token, address spender, uint256 value) internal {
110         uint256 newAllowance = token.allowance(address(this), spender) - value;
111         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
112     }
113 
114     function callOptionalReturn(IBEP20 token, bytes memory data) private {
115         require(address(token).isContract(), "SafeBEP20: call to non-contract");
116 
117         (bool success, bytes memory returndata) = address(token).call(data);
118         require(success, "SafeBEP20: low-level call failed");
119 
120         if (returndata.length > 0) { 
121             require(abi.decode(returndata, (bool)), "SafeBEP20: BEP20 operation did not succeed");
122         }
123     }
124 }
125 
126 contract ReentrancyGuard {
127     /// @dev counter to allow mutex lock with only one SSTORE operation
128     uint256 private _guardCounter;
129 
130     constructor () {
131         // The counter starts at one to prevent changing it from zero to a non-zero
132         // value, which is a more expensive operation.
133         _guardCounter = 1;
134     }
135 
136     modifier nonReentrant() {
137         _guardCounter += 1;
138         uint256 localCounter = _guardCounter;
139         _;
140         require(localCounter == _guardCounter, "ReentrancyGuard: reentrant call");
141     }
142 }
143 
144 interface ILockStakingRewards {
145     function earned(address account) external view returns (uint256);
146     function totalSupply() external view returns (uint256);
147     function balanceOf(address account) external view returns (uint256);
148     function stake(uint256 amount) external;
149     function stakeFor(uint256 amount, address user) external;
150     function getReward() external;
151     function withdraw(uint256 nonce) external;
152     function withdrawAndGetReward(uint256 nonce) external;
153 }
154 
155 interface IBEP20Permit {
156     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
157 }
158 
159 contract LockStakingLPRewardFixedAPY is ILockStakingRewards, ReentrancyGuard, Ownable {
160     using SafeBEP20 for IBEP20;
161 
162     IBEP20 public immutable rewardsToken;
163     INimbusPair public immutable stakingLPToken;
164     INimbusRouter public swapRouter;
165     address public immutable lPPairTokenA;
166     address public immutable lPPairTokenB;
167     uint256 public rewardRate; 
168     uint256 public immutable lockDuration; 
169     uint256 public constant rewardDuration = 365 days; 
170 
171     mapping(address => uint256) public weightedStakeDate;
172     mapping(address => mapping(uint256 => uint256)) public stakeLocks;
173     mapping(address => mapping(uint256 => uint256)) public stakeAmounts;
174     mapping(address => mapping(uint256 => uint256)) public stakeAmountsRewardEquivalent;
175     mapping(address => uint256) public stakeNonces;
176 
177     uint256 private _totalSupply;
178     uint256 private _totalSupplyRewardEquivalent;
179     uint256 private immutable _tokenADecimalCompensate;
180     uint256 private immutable _tokenBDecimalCompensate;
181     mapping(address => uint256) private _balances;
182     mapping(address => uint256) private _balancesRewardEquivalent;
183 
184     event RewardUpdated(uint256 reward);
185     event Staked(address indexed user, uint256 amount);
186     event Withdrawn(address indexed user, uint256 amount);
187     event RewardPaid(address indexed user, uint256 reward);
188     event Rescue(address indexed to, uint amount);
189     event RescueToken(address indexed to, address indexed token, uint amount);
190 
191     constructor(
192         address _rewardsToken,
193         address _stakingLPToken,
194         address _lPPairTokenA,
195         address _lPPairTokenB,
196         address _swapRouter,
197         uint _rewardRate,
198         uint _lockDuration
199     ) {
200         require(_rewardsToken != address(0) && _stakingLPToken != address(0) && _lPPairTokenA != address(0) && _lPPairTokenB != address(0) && _swapRouter != address(0), "LockStakingLPRewardFixedAPY: Zero address(es)");
201         rewardsToken = IBEP20(_rewardsToken);
202         stakingLPToken = INimbusPair(_stakingLPToken);
203         swapRouter = INimbusRouter(_swapRouter);
204         rewardRate = _rewardRate;
205         lockDuration = _lockDuration;
206         lPPairTokenA = _lPPairTokenA;
207         lPPairTokenB = _lPPairTokenB;
208         uint tokenADecimals = IBEP20(_lPPairTokenA).decimals();
209         require(tokenADecimals >= 6, "LockStakingLPRewardFixedAPY: small amount of decimals");
210         _tokenADecimalCompensate = tokenADecimals - 6;
211         uint tokenBDecimals = IBEP20(_lPPairTokenB).decimals();
212         require(tokenBDecimals >= 6, "LockStakingLPRewardFixedAPY: small amount of decimals");
213         _tokenBDecimalCompensate = tokenBDecimals - 6;
214     }
215 
216     function totalSupply() external view override returns (uint256) {
217         return _totalSupply;
218     }
219 
220     function totalSupplyRewardEquivalent() external view returns (uint256) {
221         return _totalSupplyRewardEquivalent;
222     }
223 
224     function getDecimalPriceCalculationCompensate() external view returns (uint tokenADecimalCompensate, uint tokenBDecimalCompensate) { 
225         tokenADecimalCompensate = _tokenADecimalCompensate;
226         tokenBDecimalCompensate = _tokenBDecimalCompensate;
227     }
228 
229     function balanceOf(address account) external view override returns (uint256) {
230         return _balances[account];
231     }
232     
233     function balanceOfRewardEquivalent(address account) external view returns (uint256) {
234         return _balancesRewardEquivalent[account];
235     }
236 
237     function earned(address account) public view override returns (uint256) {
238         return (_balancesRewardEquivalent[account] * (block.timestamp - weightedStakeDate[account]) * rewardRate) / (100 * rewardDuration);
239     }
240 
241     function stakeWithPermit(uint256 amount, uint deadline, uint8 v, bytes32 r, bytes32 s) external nonReentrant {
242         require(amount > 0, "LockStakingLPRewardFixedAPY: Cannot stake 0");
243         // permit
244         IBEP20Permit(address(stakingLPToken)).permit(msg.sender, address(this), amount, deadline, v, r, s);
245         _stake(amount, msg.sender);
246     }
247 
248     function stake(uint256 amount) external override nonReentrant {
249         require(amount > 0, "LockStakingLPRewardFixedAPY: Cannot stake 0");
250         _stake(amount, msg.sender);
251     }
252 
253     function stakeFor(uint256 amount, address user) external override nonReentrant {
254         require(amount > 0, "LockStakingLPRewardFixedAPY: Cannot stake 0");
255         require(user != address(0), "LockStakingLPRewardFixedAPY: Cannot stake for zero address");
256         _stake(amount, user);
257     }
258 
259     function _stake(uint256 amount, address user) private {
260         IBEP20(stakingLPToken).safeTransferFrom(msg.sender, address(this), amount);
261         uint amountRewardEquivalent = getCurrentLPPrice() * amount / 1e18;
262 
263         _totalSupply += amount;
264         _totalSupplyRewardEquivalent += amountRewardEquivalent;
265         uint previousAmount = _balances[user];
266         uint newAmount = previousAmount + amount;
267         weightedStakeDate[user] = (weightedStakeDate[user] * previousAmount / newAmount) + (block.timestamp * amount / newAmount);
268         _balances[user] = newAmount;
269 
270         uint stakeNonce = stakeNonces[user]++;
271         stakeLocks[user][stakeNonce] = block.timestamp + lockDuration;
272         stakeAmounts[user][stakeNonce] = amount;
273         
274         stakeAmountsRewardEquivalent[user][stakeNonce] = amountRewardEquivalent;
275         _balancesRewardEquivalent[user] += amountRewardEquivalent;
276         emit Staked(user, amount);
277     }
278 
279 
280     //A user can withdraw its staking tokens even if there is no rewards tokens on the contract account
281     function withdraw(uint256 nonce) public override nonReentrant {
282         require(stakeAmounts[msg.sender][nonce] > 0, "LockStakingLPRewardFixedAPY: This stake nonce was withdrawn");
283         require(stakeLocks[msg.sender][nonce] < block.timestamp, "LockStakingLPRewardFixedAPY: Locked");
284         uint amount = stakeAmounts[msg.sender][nonce];
285         uint amountRewardEquivalent = stakeAmountsRewardEquivalent[msg.sender][nonce];
286         _totalSupply -= amount;
287         _totalSupplyRewardEquivalent -= amountRewardEquivalent;
288         _balances[msg.sender] -= amount;
289         _balancesRewardEquivalent[msg.sender] -= amountRewardEquivalent;
290         IBEP20(stakingLPToken).safeTransfer(msg.sender, amount);
291         stakeAmounts[msg.sender][nonce] = 0;
292         stakeAmountsRewardEquivalent[msg.sender][nonce] = 0;
293         emit Withdrawn(msg.sender, amount);
294     }
295 
296     function getReward() public override nonReentrant {
297         uint256 reward = earned(msg.sender);
298         if (reward > 0) {
299             weightedStakeDate[msg.sender] = block.timestamp;
300             rewardsToken.safeTransfer(msg.sender, reward);
301             emit RewardPaid(msg.sender, reward);
302         }
303     }
304 
305     function withdrawAndGetReward(uint256 nonce) external override {
306         getReward();
307         withdraw(nonce);
308     }
309 
310     function getCurrentLPPrice() public view returns (uint) {
311         // LP PRICE = 2 * SQRT(reserveA * reaserveB ) * SQRT(token1/RewardTokenPrice * token2/RewardTokenPrice) / LPTotalSupply
312         uint tokenAToRewardPrice;
313         uint tokenBToRewardPrice;
314         address rewardToken = address(rewardsToken);    
315         address[] memory path = new address[](2);
316         path[1] = address(rewardToken);
317 
318         if (lPPairTokenA != rewardToken) {
319             path[0] = lPPairTokenA;
320             tokenAToRewardPrice = swapRouter.getAmountsOut(10 ** 6, path)[1];
321             if (_tokenADecimalCompensate > 0) 
322                 tokenAToRewardPrice = tokenAToRewardPrice * (10 ** _tokenADecimalCompensate);
323         } else {
324             tokenAToRewardPrice = 1e18;
325         }
326         
327         if (lPPairTokenB != rewardToken) {
328             path[0] = lPPairTokenB;  
329             tokenBToRewardPrice = swapRouter.getAmountsOut(10 ** 6, path)[1];
330             if (_tokenBDecimalCompensate > 0)
331                 tokenBToRewardPrice = tokenBToRewardPrice * (10 ** _tokenBDecimalCompensate);
332         } else {
333             tokenBToRewardPrice = 1e18;
334         }
335 
336         uint totalLpSupply = IBEP20(stakingLPToken).totalSupply();
337         require(totalLpSupply > 0, "LockStakingLPRewardFixedAPY: No liquidity for pair");
338         (uint reserveA, uint reaserveB,) = stakingLPToken.getReserves();
339         uint price = 
340             uint(2) * Math.sqrt(reserveA * reaserveB) * Math.sqrt(tokenAToRewardPrice * tokenBToRewardPrice) / totalLpSupply;
341         
342         return price;
343     }
344 
345 
346     function updateRewardAmount(uint256 reward) external onlyOwner {
347         rewardRate = reward;
348         emit RewardUpdated(reward);
349     }
350 
351     function updateSwapRouter(address newSwapRouter) external onlyOwner {
352         require(newSwapRouter != address(0), "LockStakingLPRewardFixedAPY: Address is zero");
353         swapRouter = INimbusRouter(newSwapRouter);
354     }
355 
356     function rescue(address to, IBEP20 token, uint256 amount) external onlyOwner {
357         require(to != address(0), "LockStakingLPRewardFixedAPY: Cannot rescue to the zero address");
358         require(amount > 0, "LockStakingLPRewardFixedAPY: Cannot rescue 0");
359         require(token != stakingLPToken, "LockStakingLPRewardFixedAPY: Cannot rescue staking token");
360         //owner can rescue rewardsToken if there is spare unused tokens on staking contract balance
361 
362         token.safeTransfer(to, amount);
363         emit RescueToken(to, address(token), amount);
364     }
365 
366     function rescue(address payable to, uint256 amount) external onlyOwner {
367         require(to != address(0), "LockStakingLPRewardFixedAPY: Cannot rescue to the zero address");
368         require(amount > 0, "LockStakingLPRewardFixedAPY: Cannot rescue 0");
369 
370         to.transfer(amount);
371         emit Rescue(to, amount);
372     }
373 }