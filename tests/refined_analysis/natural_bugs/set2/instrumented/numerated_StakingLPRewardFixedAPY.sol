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
59     function max(uint256 a, uint256 b) internal pure returns (uint256) {
60         return a >= b ? a : b;
61     }
62 
63     function min(uint256 a, uint256 b) internal pure returns (uint256) {
64         return a < b ? a : b;
65     }
66 
67     function average(uint256 a, uint256 b) internal pure returns (uint256) {
68         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
69     }
70 
71     // babylonian method (https://en.wikipedia.org/wiki/Methods_of_computing_square_roots#Babylonian_method)
72     function sqrt(uint y) internal pure returns (uint z) {
73         if (y > 3) {
74             z = y;
75             uint x = y / 2 + 1;
76             while (x < z) {
77                 z = x;
78                 x = (y / x + x) / 2;
79             }
80         } else if (y != 0) {
81             z = 1;
82         }
83     }
84 }
85 
86 library Address {
87     function isContract(address account) internal view returns (bool) {
88         // This method relies in extcodesize, which returns 0 for contracts in construction, 
89         // since the code is only stored at the end of the constructor execution.
90 
91         uint256 size;
92         // solhint-disable-next-line no-inline-assembly
93         assembly { size := extcodesize(account) }
94         return size > 0;
95     }
96 }
97 
98 library SafeBEP20 {
99     using Address for address;
100 
101     function safeTransfer(IBEP20 token, address to, uint256 value) internal {
102         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
103     }
104 
105     function safeTransferFrom(IBEP20 token, address from, address to, uint256 value) internal {
106         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
107     }
108 
109     function safeApprove(IBEP20 token, address spender, uint256 value) internal {
110         require((value == 0) || (token.allowance(address(this), spender) == 0),
111             "SafeBEP20: approve from non-zero to non-zero allowance"
112         );
113         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
114     }
115 
116     function safeIncreaseAllowance(IBEP20 token, address spender, uint256 value) internal {
117         uint256 newAllowance = token.allowance(address(this), spender) + value;
118         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
119     }
120 
121     function safeDecreaseAllowance(IBEP20 token, address spender, uint256 value) internal {
122         uint256 newAllowance = token.allowance(address(this), spender) - value;
123         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
124     }
125 
126     function callOptionalReturn(IBEP20 token, bytes memory data) private {
127         require(address(token).isContract(), "SafeBEP20: call to non-contract");
128 
129         (bool success, bytes memory returndata) = address(token).call(data);
130         require(success, "SafeBEP20: low-level call failed");
131 
132         if (returndata.length > 0) { 
133             require(abi.decode(returndata, (bool)), "SafeBEP20: BEP20 operation did not succeed");
134         }
135     }
136 }
137 
138 contract ReentrancyGuard {
139     /// @dev counter to allow mutex lock with only one SSTORE operation
140     uint256 private _guardCounter;
141 
142     constructor () {
143         // The counter starts at one to prevent changing it from zero to a non-zero
144         // value, which is a more expensive operation.
145         _guardCounter = 1;
146     }
147 
148     modifier nonReentrant() {
149         _guardCounter += 1;
150         uint256 localCounter = _guardCounter;
151         _;
152         require(localCounter == _guardCounter, "ReentrancyGuard: reentrant call");
153     }
154 }
155 
156 interface IStakingRewards {
157     function earned(address account) external view returns (uint256);
158     function totalSupply() external view returns (uint256);
159     function balanceOf(address account) external view returns (uint256);
160     function stake(uint256 amount) external;
161     function stakeFor(uint256 amount, address user) external;
162     function getReward() external;
163     function withdraw(uint256 nonce) external;
164     function withdrawAndGetReward(uint256 nonce) external;
165 }
166 
167 interface IBEP20Permit {
168     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
169 }
170 
171 contract StakingLPRewardFixedAPY is IStakingRewards, ReentrancyGuard, Ownable {
172     using SafeBEP20 for IBEP20;
173 
174     IBEP20 public immutable rewardsToken;
175     INimbusPair public immutable stakingLPToken;
176     INimbusRouter public swapRouter;
177     address public immutable lPPairTokenA;
178     address public immutable lPPairTokenB;
179     uint256 public rewardRate; 
180     uint256 public constant rewardDuration = 365 days; 
181 
182     mapping(address => uint256) public weightedStakeDate;
183     mapping(address => mapping(uint256 => uint256)) public stakeAmounts;
184     mapping(address => mapping(uint256 => uint256)) public stakeAmountsRewardEquivalent;
185     mapping(address => uint256) public stakeNonces;
186 
187     uint256 private _totalSupply;
188     uint256 private _totalSupplyRewardEquivalent;
189     uint256 private immutable _tokenADecimalCompensate;
190     uint256 private immutable _tokenBDecimalCompensate;
191     mapping(address => uint256) private _balances;
192     mapping(address => uint256) private _balancesRewardEquivalent;
193 
194     event RewardUpdated(uint256 reward);
195     event Staked(address indexed user, uint256 amount);
196     event Withdrawn(address indexed user, uint256 amount);
197     event RewardPaid(address indexed user, uint256 reward);
198     event Rescue(address indexed to, uint256 amount);
199     event RescueToken(address indexed to, address indexed token, uint256 amount);
200 
201     constructor(
202         address _rewardsToken,
203         address _stakingLPToken,
204         address _lPPairTokenA,
205         address _lPPairTokenB,
206         address _swapRouter,
207         uint _rewardRate
208     ) {
209         require(_rewardsToken != address(0) && _stakingLPToken != address(0) && _lPPairTokenA != address(0) && _lPPairTokenB != address(0) && _swapRouter != address(0), "StakingLPRewardFixedAPY: Zero address(es)");
210         rewardsToken = IBEP20(_rewardsToken);
211         stakingLPToken = INimbusPair(_stakingLPToken);
212         swapRouter = INimbusRouter(_swapRouter);
213         rewardRate = _rewardRate;
214         lPPairTokenA = _lPPairTokenA;
215         lPPairTokenB = _lPPairTokenB;
216         uint tokenADecimals = IBEP20(_lPPairTokenA).decimals();
217         require(tokenADecimals >= 6, "StakingLPRewardFixedAPY: small amount of decimals");
218         _tokenADecimalCompensate = tokenADecimals - 6;
219         uint tokenBDecimals = IBEP20(_lPPairTokenB).decimals();
220         require(tokenBDecimals >= 6, "StakingLPRewardFixedAPY: small amount of decimals");
221         _tokenBDecimalCompensate = tokenBDecimals - 6;
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
232     function getDecimalPriceCalculationCompensate() external view returns (uint tokenADecimalCompensate, uint tokenBDecimalCompensate) { 
233         tokenADecimalCompensate = _tokenADecimalCompensate;
234         tokenBDecimalCompensate = _tokenBDecimalCompensate;
235     }
236 
237     function balanceOf(address account) external view override returns (uint256) {
238         return _balances[account];
239     }
240     
241     function balanceOfRewardEquivalent(address account) external view returns (uint256) {
242         return _balancesRewardEquivalent[account];
243     }
244 
245     function earned(address account) public view override returns (uint256) {
246         return (_balancesRewardEquivalent[account] * ((block.timestamp - weightedStakeDate[account]) * rewardRate)) / (100 * rewardDuration);
247     }
248 
249     function stakeWithPermit(uint256 amount, uint deadline, uint8 v, bytes32 r, bytes32 s) external nonReentrant {
250         require(amount > 0, "StakingLPRewardFixedAPY: Cannot stake 0");
251         // permit
252         IBEP20Permit(address(stakingLPToken)).permit(msg.sender, address(this), amount, deadline, v, r, s);
253         _stake(amount, msg.sender);
254     }
255 
256     function stake(uint256 amount) external override nonReentrant {
257         require(amount > 0, "StakingLPRewardFixedAPY: Cannot stake 0");
258         _stake(amount, msg.sender);
259     }
260 
261     function stakeFor(uint256 amount, address user) external override nonReentrant {
262         require(amount > 0, "StakingLPRewardFixedAPY: Cannot stake 0");
263         require(user != address(0), "StakingLPRewardFixedAPY: Cannot stake for zero address");
264         _stake(amount, user);
265     }
266 
267     function _stake(uint256 amount, address user) private {
268         IBEP20(stakingLPToken).safeTransferFrom(msg.sender, address(this), amount);
269         uint amountRewardEquivalent = getCurrentLPPrice() * amount / 1e18;
270 
271         _totalSupply += amount;
272         _totalSupplyRewardEquivalent += amountRewardEquivalent;
273         uint previousAmount = _balances[user];
274         uint newAmount = previousAmount + amount;
275         weightedStakeDate[user] = (weightedStakeDate[user] * previousAmount / newAmount) + (block.timestamp * amount / newAmount);
276         _balances[user] = newAmount;
277 
278         uint stakeNonce = stakeNonces[user]++;
279         stakeAmounts[user][stakeNonce] = amount;
280         
281         stakeAmountsRewardEquivalent[user][stakeNonce] = amountRewardEquivalent;
282         _balancesRewardEquivalent[user] += amountRewardEquivalent;
283         emit Staked(user, amount);
284     }
285 
286 
287     //A user can withdraw its staking tokens even if there is no rewards tokens on the contract account
288     function withdraw(uint256 nonce) public override nonReentrant {
289         require(stakeAmounts[msg.sender][nonce] > 0, "StakingLPRewardFixedAPY: This stake nonce was withdrawn");
290         uint amount = stakeAmounts[msg.sender][nonce];
291         uint amountRewardEquivalent = stakeAmountsRewardEquivalent[msg.sender][nonce];
292         _totalSupply -= amount;
293         _totalSupplyRewardEquivalent -= amountRewardEquivalent;
294         _balances[msg.sender] -= amount;
295         _balancesRewardEquivalent[msg.sender] -= amountRewardEquivalent;
296         IBEP20(stakingLPToken).safeTransfer(msg.sender, amount);
297         stakeAmounts[msg.sender][nonce] = 0;
298         stakeAmountsRewardEquivalent[msg.sender][nonce] = 0;
299         emit Withdrawn(msg.sender, amount);
300     }
301 
302     function getReward() public override nonReentrant {
303         uint256 reward = earned(msg.sender);
304         if (reward > 0) {
305             weightedStakeDate[msg.sender] = block.timestamp;
306             rewardsToken.safeTransfer(msg.sender, reward);
307             emit RewardPaid(msg.sender, reward);
308         }
309     }
310 
311     function withdrawAndGetReward(uint256 nonce) external override {
312         getReward();
313         withdraw(nonce);
314     }
315 
316     function getCurrentLPPrice() public view returns (uint) {
317         // LP PRICE = 2 * SQRT(reserveA * reaserveB ) * SQRT(token1/RewardTokenPrice * token2/RewardTokenPrice) / LPTotalSupply
318         uint tokenAToRewardPrice;
319         uint tokenBToRewardPrice;
320         address rewardToken = address(rewardsToken);    
321         address[] memory path = new address[](2);
322         path[1] = address(rewardToken);
323 
324         if (lPPairTokenA != rewardToken) {
325             path[0] = lPPairTokenA;
326             tokenAToRewardPrice = swapRouter.getAmountsOut(10 ** 6, path)[1];
327             if (_tokenADecimalCompensate > 0) 
328                 tokenAToRewardPrice = tokenAToRewardPrice * (10 ** _tokenADecimalCompensate);
329         } else {
330             tokenAToRewardPrice = 1e18;
331         }
332         
333         if (lPPairTokenB != rewardToken) {
334             path[0] = lPPairTokenB;
335             tokenBToRewardPrice = swapRouter.getAmountsOut(10 ** 6, path)[1];
336             if (_tokenBDecimalCompensate > 0)
337                 tokenBToRewardPrice = tokenBToRewardPrice * (10 ** _tokenBDecimalCompensate);
338         } else {
339             tokenBToRewardPrice = 1e18;
340         }
341 
342         uint totalLpSupply = IBEP20(stakingLPToken).totalSupply();
343         require(totalLpSupply > 0, "StakingLPRewardFixedAPY: No liquidity for pair");
344         (uint reserveA, uint reaserveB,) = stakingLPToken.getReserves();
345         uint price = 
346             uint(2) * Math.sqrt(reserveA * reaserveB)
347             * Math.sqrt(tokenAToRewardPrice * tokenBToRewardPrice) / totalLpSupply;
348         
349         return price;
350     }
351 
352 
353     function updateRewardAmount(uint256 reward) external onlyOwner {
354         rewardRate = reward;
355         emit RewardUpdated(reward);
356     }
357 
358     function updateSwapRouter(address newSwapRouter) external onlyOwner {
359         require(newSwapRouter != address(0), "StakingLPRewardFixedAPY: Address is zero");
360         swapRouter = INimbusRouter(newSwapRouter);
361     }
362 
363     function rescue(address to, IBEP20 token, uint256 amount) external onlyOwner {
364         require(to != address(0), "StakingLPRewardFixedAPY: Cannot rescue to the zero address");
365         require(amount > 0, "StakingLPRewardFixedAPY: Cannot rescue 0");
366         require(token != stakingLPToken, "StakingLPRewardFixedAPY: Cannot rescue staking token");
367         //owner can rescue rewardsToken if there is spare unused tokens on staking contract balance
368 
369         token.safeTransfer(to, amount);
370         emit RescueToken(to, address(token), amount);
371     }
372 
373     function rescue(address payable to, uint256 amount) external onlyOwner {
374         require(to != address(0), "StakingLPRewardFixedAPY: Cannot rescue to the zero address");
375         require(amount > 0, "StakingLPRewardFixedAPY: Cannot rescue 0");
376 
377         to.transfer(amount);
378         emit Rescue(to, amount);
379     }
380 }