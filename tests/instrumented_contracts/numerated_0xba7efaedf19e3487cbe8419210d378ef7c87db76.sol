1 pragma solidity =0.8.0;
2 
3 interface IERC20 {
4     function totalSupply() external view returns (uint256);
5     function balanceOf(address account) external view returns (uint256);
6     function decimals() external pure returns (uint);
7     function transfer(address recipient, uint256 amount) external returns (bool);
8     function allowance(address owner, address spender) external view returns (uint256);
9     function approve(address spender, uint256 amount) external returns (bool);
10     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
11     event Transfer(address indexed from, address indexed to, uint256 value);
12     event Approval(address indexed owner, address indexed spender, uint256 value);
13 }
14 
15 interface INimbusPair is IERC20 {
16     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
17 }
18 
19 interface INimbusRouter {
20     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
21 }
22 
23 contract Ownable {
24     address public owner;
25     address public newOwner;
26 
27     event OwnershipTransferred(address indexed from, address indexed to);
28 
29     constructor() {
30         owner = msg.sender;
31         emit OwnershipTransferred(address(0), owner);
32     }
33 
34     modifier onlyOwner {
35         require(msg.sender == owner, "Ownable: Caller is not the owner");
36         _;
37     }
38 
39     function transferOwnership(address transferOwner) public onlyOwner {
40         require(transferOwner != newOwner);
41         newOwner = transferOwner;
42     }
43 
44     function acceptOwnership() virtual public {
45         require(msg.sender == newOwner);
46         emit OwnershipTransferred(owner, newOwner);
47         owner = newOwner;
48         newOwner = address(0);
49     }
50 }
51 
52 library SafeMath {
53     function add(uint256 a, uint256 b) internal pure returns (uint256) {
54         uint256 c = a + b;
55         require(c >= a, "SafeMath: addition overflow");
56 
57         return c;
58     }
59 
60     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
61         require(b <= a, "SafeMath: subtraction overflow");
62         uint256 c = a - b;
63 
64         return c;
65     }
66 
67     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
68       if (a == 0) {
69             return 0;
70         }
71 
72         uint256 c = a * b;
73         require(c / a == b, "SafeMath: multiplication overflow");
74 
75         return c;
76     }
77 
78     function div(uint256 a, uint256 b) internal pure returns (uint256) {
79         // Solidity only automatically asserts when dividing by 0
80         require(b > 0, "SafeMath: division by zero");
81         uint256 c = a / b;
82         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
83 
84         return c;
85     }
86 
87     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
88         require(b != 0, "SafeMath: modulo by zero");
89         return a % b;
90     }
91 }
92 
93 library Math {
94     function max(uint256 a, uint256 b) internal pure returns (uint256) {
95         return a >= b ? a : b;
96     }
97 
98     function min(uint256 a, uint256 b) internal pure returns (uint256) {
99         return a < b ? a : b;
100     }
101 
102     function average(uint256 a, uint256 b) internal pure returns (uint256) {
103         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
104     }
105 
106     // babylonian method (https://en.wikipedia.org/wiki/Methods_of_computing_square_roots#Babylonian_method)
107     function sqrt(uint y) internal pure returns (uint z) {
108         if (y > 3) {
109             z = y;
110             uint x = y / 2 + 1;
111             while (x < z) {
112                 z = x;
113                 x = (y / x + x) / 2;
114             }
115         } else if (y != 0) {
116             z = 1;
117         }
118     }
119 }
120 
121 library Address {
122     function isContract(address account) internal view returns (bool) {
123         // This method relies in extcodesize, which returns 0 for contracts in construction, 
124         // since the code is only stored at the end of the constructor execution.
125 
126         uint256 size;
127         // solhint-disable-next-line no-inline-assembly
128         assembly { size := extcodesize(account) }
129         return size > 0;
130     }
131 }
132 
133 library SafeERC20 {
134     using SafeMath for uint256;
135     using Address for address;
136 
137     function safeTransfer(IERC20 token, address to, uint256 value) internal {
138         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
139     }
140 
141     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
142         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
143     }
144 
145     function safeApprove(IERC20 token, address spender, uint256 value) internal {
146         require((value == 0) || (token.allowance(address(this), spender) == 0),
147             "SafeERC20: approve from non-zero to non-zero allowance"
148         );
149         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
150     }
151 
152     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
153         uint256 newAllowance = token.allowance(address(this), spender).add(value);
154         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
155     }
156 
157     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
158         uint256 newAllowance = token.allowance(address(this), spender).sub(value);
159         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
160     }
161 
162     function callOptionalReturn(IERC20 token, bytes memory data) private {
163         require(address(token).isContract(), "SafeERC20: call to non-contract");
164 
165         (bool success, bytes memory returndata) = address(token).call(data);
166         require(success, "SafeERC20: low-level call failed");
167 
168         if (returndata.length > 0) { 
169             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
170         }
171     }
172 }
173 
174 contract ReentrancyGuard {
175     /// @dev counter to allow mutex lock with only one SSTORE operation
176     uint256 private _guardCounter;
177 
178     constructor () {
179         // The counter starts at one to prevent changing it from zero to a non-zero
180         // value, which is a more expensive operation.
181         _guardCounter = 1;
182     }
183 
184     modifier nonReentrant() {
185         _guardCounter += 1;
186         uint256 localCounter = _guardCounter;
187         _;
188         require(localCounter == _guardCounter, "ReentrancyGuard: reentrant call");
189     }
190 }
191 
192 interface IStakingRewards {
193     function earned(address account) external view returns (uint256);
194     function totalSupply() external view returns (uint256);
195     function balanceOf(address account) external view returns (uint256);
196     function stake(uint256 amount) external;
197     function stakeFor(uint256 amount, address user) external;
198     function getReward() external;
199     function withdraw(uint256 nonce) external;
200     function withdrawAndGetReward(uint256 nonce) external;
201 }
202 
203 interface IERC20Permit {
204     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
205 }
206 
207 contract StakingLPRewardFixedAPY is IStakingRewards, ReentrancyGuard, Ownable {
208     using SafeMath for uint256;
209     using SafeERC20 for IERC20;
210 
211     IERC20 public immutable rewardsToken;
212     INimbusPair public immutable stakingLPToken;
213     INimbusRouter public swapRouter;
214     address public immutable lPPairTokenA;
215     address public immutable lPPairTokenB;
216     uint256 public rewardRate; 
217     uint256 public constant rewardDuration = 365 days; 
218 
219     mapping(address => uint256) public weightedStakeDate;
220     mapping(address => mapping(uint256 => uint256)) public stakeAmounts;
221     mapping(address => mapping(uint256 => uint256)) public stakeAmountsRewardEquivalent;
222     mapping(address => uint256) public stakeNonces;
223 
224     uint256 private _totalSupply;
225     uint256 private _totalSupplyRewardEquivalent;
226     uint256 private immutable _tokenADecimalCompensate;
227     uint256 private immutable _tokenBDecimalCompensate;
228     mapping(address => uint256) private _balances;
229     mapping(address => uint256) private _balancesRewardEquivalent;
230 
231     event RewardUpdated(uint256 reward);
232     event Staked(address indexed user, uint256 amount);
233     event Withdrawn(address indexed user, uint256 amount);
234     event RewardPaid(address indexed user, uint256 reward);
235     event Rescue(address to, uint256 amount);
236     event RescueToken(address to, address token, uint256 amount);
237 
238     constructor(
239         address _rewardsToken,
240         address _stakingLPToken,
241         address _lPPairTokenA,
242         address _lPPairTokenB,
243         address _swapRouter,
244         uint _rewardRate
245     ) {
246         rewardsToken = IERC20(_rewardsToken);
247         stakingLPToken = INimbusPair(_stakingLPToken);
248         swapRouter = INimbusRouter(_swapRouter);
249         rewardRate = _rewardRate;
250         lPPairTokenA = _lPPairTokenA;
251         lPPairTokenB = _lPPairTokenB;
252         uint tokenADecimals = IERC20(_lPPairTokenA).decimals();
253         require(tokenADecimals >= 6, "StakingLPRewardFixedAPY: small amount of decimals");
254         _tokenADecimalCompensate = tokenADecimals.sub(6);
255         uint tokenBDecimals = IERC20(_lPPairTokenB).decimals();
256         require(tokenBDecimals >= 6, "StakingLPRewardFixedAPY: small amount of decimals");
257         _tokenBDecimalCompensate = tokenBDecimals.sub(6);
258     }
259 
260     function totalSupply() external view override returns (uint256) {
261         return _totalSupply;
262     }
263 
264     function totalSupplyRewardEquivalent() external view returns (uint256) {
265         return _totalSupplyRewardEquivalent;
266     }
267 
268     function getDecimalPriceCalculationCompensate() external view returns (uint tokenADecimalCompensate, uint tokenBDecimalCompensate) { 
269         tokenADecimalCompensate = _tokenADecimalCompensate;
270         tokenBDecimalCompensate = _tokenBDecimalCompensate;
271     }
272 
273     function balanceOf(address account) external view override returns (uint256) {
274         return _balances[account];
275     }
276     
277     function balanceOfRewardEquivalent(address account) external view returns (uint256) {
278         return _balancesRewardEquivalent[account];
279     }
280 
281     function earned(address account) public view override returns (uint256) {
282         return (_balancesRewardEquivalent[account].mul(block.timestamp.sub(weightedStakeDate[account])).mul(rewardRate)) / (100 * rewardDuration);
283     }
284 
285     function stakeWithPermit(uint256 amount, uint deadline, uint8 v, bytes32 r, bytes32 s) external nonReentrant {
286         require(amount > 0, "StakingLPRewardFixedAPY: Cannot stake 0");
287         // permit
288         IERC20Permit(address(stakingLPToken)).permit(msg.sender, address(this), amount, deadline, v, r, s);
289         _stake(amount, msg.sender);
290     }
291 
292     function stake(uint256 amount) external override nonReentrant {
293         require(amount > 0, "StakingLPRewardFixedAPY: Cannot stake 0");
294         _stake(amount, msg.sender);
295     }
296 
297     function stakeFor(uint256 amount, address user) external override nonReentrant {
298         require(amount > 0, "StakingLPRewardFixedAPY: Cannot stake 0");
299         _stake(amount, user);
300     }
301 
302     function _stake(uint256 amount, address user) private {
303         IERC20(stakingLPToken).safeTransferFrom(msg.sender, address(this), amount);
304         uint amountRewardEquivalent = getCurrentLPPrice().mul(amount) / 10 ** 18;
305 
306         _totalSupply = _totalSupply.add(amount);
307         _totalSupplyRewardEquivalent = _totalSupplyRewardEquivalent.add(amountRewardEquivalent);
308         uint previousAmount = _balances[user];
309         uint newAmount = previousAmount.add(amount);
310         weightedStakeDate[user] = (weightedStakeDate[user].mul(previousAmount) / newAmount).add(block.timestamp.mul(amount) / newAmount);
311         _balances[user] = newAmount;
312 
313         uint stakeNonce = stakeNonces[user]++;
314         stakeAmounts[user][stakeNonce] = amount;
315         
316         stakeAmountsRewardEquivalent[user][stakeNonce] = amountRewardEquivalent;
317         _balancesRewardEquivalent[user] = _balancesRewardEquivalent[user].add(amountRewardEquivalent);
318         emit Staked(user, amount);
319     }
320 
321 
322     //A user can withdraw its staking tokens even if there is no rewards tokens on the contract account
323     function withdraw(uint256 nonce) public override nonReentrant {
324         require(stakeAmounts[msg.sender][nonce] > 0, "StakingLPRewardFixedAPY: This stake nonce was withdrawn");
325         uint amount = stakeAmounts[msg.sender][nonce];
326         uint amountRewardEquivalent = stakeAmountsRewardEquivalent[msg.sender][nonce];
327         _totalSupply = _totalSupply.sub(amount);
328         _totalSupplyRewardEquivalent = _totalSupplyRewardEquivalent.sub(amountRewardEquivalent);
329         _balances[msg.sender] = _balances[msg.sender].sub(amount);
330         _balancesRewardEquivalent[msg.sender] = _balancesRewardEquivalent[msg.sender].sub(amountRewardEquivalent);
331         IERC20(stakingLPToken).safeTransfer(msg.sender, amount);
332         stakeAmounts[msg.sender][nonce] = 0;
333         stakeAmountsRewardEquivalent[msg.sender][nonce] = 0;
334         emit Withdrawn(msg.sender, amount);
335     }
336 
337     function getReward() public override nonReentrant {
338         uint256 reward = earned(msg.sender);
339         if (reward > 0) {
340             weightedStakeDate[msg.sender] = block.timestamp;
341             rewardsToken.safeTransfer(msg.sender, reward);
342             emit RewardPaid(msg.sender, reward);
343         }
344     }
345 
346     function withdrawAndGetReward(uint256 nonce) external override {
347         getReward();
348         withdraw(nonce);
349     }
350 
351     function getCurrentLPPrice() public view returns (uint) {
352         // LP PRICE = 2 * SQRT(reserveA * reaserveB ) * SQRT(token1/RewardTokenPrice * token2/RewardTokenPrice) / LPTotalSupply
353         uint tokenAToRewardPrice;
354         uint tokenBToRewardPrice;
355         address rewardToken = address(rewardsToken);    
356         address[] memory path = new address[](2);
357         path[1] = address(rewardToken);
358 
359         if (lPPairTokenA != rewardToken) {
360             path[0] = lPPairTokenA;
361             tokenAToRewardPrice = swapRouter.getAmountsOut(10 ** 6, path)[1];
362             if (_tokenADecimalCompensate > 0) 
363                 tokenAToRewardPrice = tokenAToRewardPrice.mul(10 ** _tokenADecimalCompensate);
364         } else {
365             tokenAToRewardPrice = 10 ** 18;
366         }
367         
368         if (lPPairTokenB != rewardToken) {
369             path[0] = lPPairTokenB;
370             tokenBToRewardPrice = swapRouter.getAmountsOut(10 ** 6, path)[1];
371             if (_tokenBDecimalCompensate > 0)
372                 tokenBToRewardPrice = tokenBToRewardPrice.mul(10 ** _tokenBDecimalCompensate);
373         } else {
374             tokenBToRewardPrice = 10 ** 18;
375         }
376 
377         uint totalLpSupply = IERC20(stakingLPToken).totalSupply();
378         require(totalLpSupply > 0, "StakingLPRewardFixedAPY: No liquidity for pair");
379         (uint reserveA, uint reaserveB,) = stakingLPToken.getReserves();
380         uint price = 
381             uint(2).mul(Math.sqrt(reserveA.mul(reaserveB))
382             .mul(Math.sqrt(tokenAToRewardPrice.mul(tokenBToRewardPrice)))) / totalLpSupply;
383         
384         return price;
385     }
386 
387 
388     function updateRewardAmount(uint256 reward) external onlyOwner {
389         rewardRate = reward;
390         emit RewardUpdated(reward);
391     }
392 
393     function updateSwapRouter(address newSwapRouter) external onlyOwner {
394         require(newSwapRouter != address(0), "StakingLPRewardFixedAPY: Address is zero");
395         swapRouter = INimbusRouter(newSwapRouter);
396     }
397 
398     function rescue(address to, IERC20 token, uint256 amount) external onlyOwner {
399         require(to != address(0), "StakingLPRewardFixedAPY: Cannot rescue to the zero address");
400         require(amount > 0, "StakingLPRewardFixedAPY: Cannot rescue 0");
401         require(token != stakingLPToken, "StakingLPRewardFixedAPY: Cannot rescue staking token");
402         //owner can rescue rewardsToken if there is spare unused tokens on staking contract balance
403 
404         token.safeTransfer(to, amount);
405         emit RescueToken(to, address(token), amount);
406     }
407 
408     function rescue(address payable to, uint256 amount) external onlyOwner {
409         require(to != address(0), "StakingLPRewardFixedAPY: Cannot rescue to the zero address");
410         require(amount > 0, "StakingLPRewardFixedAPY: Cannot rescue 0");
411 
412         to.transfer(amount);
413         emit Rescue(to, amount);
414     }
415 }