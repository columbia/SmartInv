1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.6.10;
4 
5 
6 /**
7  * @dev Wrappers over Solidity's arithmetic operations with added overflow
8  * checks.
9  *
10  * Arithmetic operations in Solidity wrap on overflow. This can easily result
11  * in bugs, because programmers usually assume that an overflow raises an
12  * error, which is the standard behavior in high level programming languages.
13  * `SafeMath` restores this intuition by reverting the transaction when an
14  * operation overflows.
15  *
16  * Using this library instead of the unchecked operations eliminates an entire
17  * class of bugs, so it's recommended to use it always.
18  */
19 library SafeMath {
20     /**
21      * @dev Returns the addition of two unsigned integers, reverting on
22      * overflow.
23      *
24      * Counterpart to Solidity's `+` operator.
25      *
26      * Requirements:
27      *
28      * - Addition cannot overflow.
29      */
30     function add(uint256 a, uint256 b) internal pure returns (uint256) {
31         uint256 c = a + b;
32         require(c >= a, "SafeMath: addition overflow");
33 
34         return c;
35     }
36 
37     /**
38      * @dev Returns the subtraction of two unsigned integers, reverting on
39      * overflow (when the result is negative).
40      *
41      * Counterpart to Solidity's `-` operator.
42      *
43      * Requirements:
44      *
45      * - Subtraction cannot overflow.
46      */
47     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
48         return sub(a, b, "SafeMath: subtraction overflow");
49     }
50 
51     /**
52      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
53      * overflow (when the result is negative).
54      *
55      * Counterpart to Solidity's `-` operator.
56      *
57      * Requirements:
58      *
59      * - Subtraction cannot overflow.
60      */
61     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
62         require(b <= a, errorMessage);
63         uint256 c = a - b;
64 
65         return c;
66     }
67 
68     /**
69      * @dev Returns the multiplication of two unsigned integers, reverting on
70      * overflow.
71      *
72      * Counterpart to Solidity's `*` operator.
73      *
74      * Requirements:
75      *
76      * - Multiplication cannot overflow.
77      */
78     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
79         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
80         // benefit is lost if 'b' is also tested.
81         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
82         if (a == 0) {
83             return 0;
84         }
85 
86         uint256 c = a * b;
87         require(c / a == b, "SafeMath: multiplication overflow");
88 
89         return c;
90     }
91 
92     /**
93      * @dev Returns the integer division of two unsigned integers. Reverts on
94      * division by zero. The result is rounded towards zero.
95      *
96      * Counterpart to Solidity's `/` operator. Note: this function uses a
97      * `revert` opcode (which leaves remaining gas untouched) while Solidity
98      * uses an invalid opcode to revert (consuming all remaining gas).
99      *
100      * Requirements:
101      *
102      * - The divisor cannot be zero.
103      */
104     function div(uint256 a, uint256 b) internal pure returns (uint256) {
105         return div(a, b, "SafeMath: division by zero");
106     }
107 
108     /**
109      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
110      * division by zero. The result is rounded towards zero.
111      *
112      * Counterpart to Solidity's `/` operator. Note: this function uses a
113      * `revert` opcode (which leaves remaining gas untouched) while Solidity
114      * uses an invalid opcode to revert (consuming all remaining gas).
115      *
116      * Requirements:
117      *
118      * - The divisor cannot be zero.
119      */
120     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
121         require(b > 0, errorMessage);
122         uint256 c = a / b;
123         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
124 
125         return c;
126     }
127 
128     /**
129      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
130      * Reverts when dividing by zero.
131      *
132      * Counterpart to Solidity's `%` operator. This function uses a `revert`
133      * opcode (which leaves remaining gas untouched) while Solidity uses an
134      * invalid opcode to revert (consuming all remaining gas).
135      *
136      * Requirements:
137      *
138      * - The divisor cannot be zero.
139      */
140     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
141         return mod(a, b, "SafeMath: modulo by zero");
142     }
143 
144     /**
145      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
146      * Reverts with custom message when dividing by zero.
147      *
148      * Counterpart to Solidity's `%` operator. This function uses a `revert`
149      * opcode (which leaves remaining gas untouched) while Solidity uses an
150      * invalid opcode to revert (consuming all remaining gas).
151      *
152      * Requirements:
153      *
154      * - The divisor cannot be zero.
155      */
156     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
157         require(b != 0, errorMessage);
158         return a % b;
159     }
160 }
161 
162 
163 /**
164  * @dev Interface of the ERC20 standard as defined in the EIP.
165  */
166 interface IERC20 {
167 
168     function totalSupply() external view returns (uint256);
169 
170     function balanceOf(address account) external view returns (uint256);
171 
172     function transfer(address recipient, uint256 amount) external returns (bool);
173 
174     function allowance(address owner, address spender) external view returns (uint256);
175 
176     function approve(address spender, uint256 amount) external returns (bool);
177 
178     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
179 
180     event Transfer(address indexed from, address indexed to, uint256 value);
181 
182     event Approval(address indexed owner, address indexed spender, uint256 value);
183 }
184 
185 // Liquidity pool allows a user to stake Uniswap liquidity tokens (tokens representaing shares of ETH and PAMP tokens in the Uniswap liquidity pool)
186 // Users receive rewards in tokens for locking up their liquidity
187 contract LiquidityPool {
188     using SafeMath for uint256;
189     
190     
191     IERC20 public uniswapPair;
192     
193     IERC20 public pampToken;
194     
195     address public owner;
196     
197     uint public minStakeDurationDays;
198     
199     uint public rewardAdjustmentFactor;
200     
201     bool public stakingEnabled;
202     
203     bool public exponentialRewardsEnabled;
204     
205     uint public exponentialDaysMax;
206     
207     struct staker {
208         uint startTimestamp;        // Unix timestamp of when the tokens were initially staked
209         uint poolTokenBalance;      // Balance of Uniswap liquidity tokens
210     }
211     
212     mapping(address => staker) public stakers;
213 
214     
215     modifier onlyOwner() {
216         require(owner == msg.sender, "Caller is not the owner");
217         _;
218     }
219     
220     
221     constructor(address _uniswapPair, address _pampToken) public {
222         uniswapPair = IERC20(_uniswapPair);
223         pampToken = IERC20(_pampToken);
224         minStakeDurationDays = 1;
225         owner = msg.sender;
226         rewardAdjustmentFactor = 4E21;
227         stakingEnabled = true;
228         exponentialRewardsEnabled = false;
229         exponentialDaysMax = 10;
230     }
231     
232     
233     function stakeLiquidityTokens(uint256 numPoolTokensToStake) external {
234         
235         require(numPoolTokensToStake > 0);
236         require(stakingEnabled, "Staking is currently disabled.");
237         
238         uint previousBalance = uniswapPair.balanceOf(address(this));                    
239         
240         uniswapPair.transferFrom(msg.sender, address(this), numPoolTokensToStake);      // Transfer liquidity tokens from the sender to this contract
241         
242         uint postBalance = uniswapPair.balanceOf(address(this));
243         
244         require(previousBalance.add(numPoolTokensToStake) == postBalance);              // This is a sanity check and likely not required as the Uniswap token is ERC20
245         
246         staker storage thisStaker = stakers[msg.sender];                                // Get the sender's information
247         
248         if(thisStaker.startTimestamp == 0 || thisStaker.poolTokenBalance == 0) {
249             thisStaker.startTimestamp = block.timestamp;
250         } else {                                                                        // If the sender is currently staking, adding to his balance results in a holding time penalty
251             uint percent = mulDiv(1000000, numPoolTokensToStake, thisStaker.poolTokenBalance);      // This is not really 'percent' it is just a number that represents the totalAmount as a fraction of the recipientBalance
252             assert(percent > 0);
253             if(percent > 1) {
254                 percent = percent.div(2);           // We divide the 'penalty' by 2 so that the penalty is not as bad
255             }
256             if(percent.add(thisStaker.startTimestamp) > block.timestamp) {         // We represent the 'percent' or 'penalty' as seconds and add to the recipient's unix time
257                thisStaker.startTimestamp = block.timestamp; // Receiving too many tokens resets your holding time
258             } else {
259                 thisStaker.startTimestamp = thisStaker.startTimestamp.add(percent);               
260             }
261         }
262         
263          
264         thisStaker.poolTokenBalance = thisStaker.poolTokenBalance.add(numPoolTokensToStake);
265 
266         
267     }
268     // Withdraw liquidity tokens, pretty self-explanatory
269     function withdrawLiquidityTokens(uint256 numPoolTokensToWithdraw) external {
270         
271         require(numPoolTokensToWithdraw > 0);
272         
273         staker storage thisStaker = stakers[msg.sender];
274         
275         require(thisStaker.poolTokenBalance >= numPoolTokensToWithdraw, "Pool token balance too low");
276         
277         uint daysStaked = block.timestamp.sub(thisStaker.startTimestamp) / 86400;  // Calculate time staked in days
278         
279         require(daysStaked >= minStakeDurationDays);
280         
281         uint tokensOwed = calculateTokensOwed(msg.sender);      // We give all of the rewards owed to the sender on a withdrawal, regardless of the amount withdrawn
282         
283         thisStaker.poolTokenBalance = thisStaker.poolTokenBalance.sub(numPoolTokensToWithdraw);
284         
285         thisStaker.startTimestamp = block.timestamp; // Reset staking timer on withdrawal
286         
287         pampToken.transfer(msg.sender, tokensOwed);             
288         
289         uniswapPair.transfer(msg.sender, numPoolTokensToWithdraw);
290     }
291     
292     // If you call this function you forfeit your rewards
293     function emergencyWithdrawLiquidityTokens() external {
294         staker storage thisStaker = stakers[msg.sender];
295         uint poolTokenBalance = thisStaker.poolTokenBalance;
296         thisStaker.poolTokenBalance = 0;
297         thisStaker.startTimestamp = block.timestamp;
298         uniswapPair.transfer(msg.sender, poolTokenBalance);
299     }
300     
301     function calculateTokensOwed(address stakerAddr) public view returns (uint256) {
302         
303         staker memory thisStaker = stakers[stakerAddr];
304         
305         uint daysStaked = block.timestamp.sub(thisStaker.startTimestamp) / 86400;  // Calculate time staked in days
306         
307         
308         uint tokens = mulDiv(daysStaked.mul(rewardAdjustmentFactor), thisStaker.poolTokenBalance, uniswapPair.totalSupply()); // The formula is as follows: tokens owned = (days staked * reward adjustment factor) * (sender liquidity token balance / total supply of liquidity token)
309         
310         if(daysStaked > exponentialDaysMax) {
311             daysStaked = exponentialDaysMax;
312         }
313         
314         if(exponentialRewardsEnabled) {
315             return tokens * daysStaked;
316         } else {
317             return tokens;
318         }
319         
320         
321     }
322     
323     function pampTokenBalance() external view returns (uint256) {
324         return pampToken.balanceOf(address(this));
325     }
326     
327     function uniTokenBalance() external view returns (uint256) {
328         return uniswapPair.balanceOf(address(this));
329     }
330     
331     function updateUniswapPair(address _uniswapPair) external onlyOwner {
332         uniswapPair = IERC20(_uniswapPair);
333     }
334     
335     function updatePampToken(address _pampToken) external onlyOwner {
336         pampToken = IERC20(_pampToken);
337     }
338     
339     function updateMinStakeDurationDays(uint _minStakeDurationDays) external onlyOwner {
340         minStakeDurationDays = _minStakeDurationDays;
341     }
342     
343     function updateRewardAdjustmentFactor(uint _rewardAdjustmentFactor) external onlyOwner {
344         rewardAdjustmentFactor = _rewardAdjustmentFactor;
345     }
346     
347     function updateStakingEnabled(bool _stakingEnbaled) external onlyOwner {
348         stakingEnabled = _stakingEnbaled;
349     }
350     
351     function updateExponentialRewardsEnabled(bool _exponentialRewards) external onlyOwner {
352         exponentialRewardsEnabled = _exponentialRewards;
353     }
354     
355     function updateExponentialDaysMax(uint _exponentialDaysMax) external onlyOwner {
356         exponentialDaysMax = _exponentialDaysMax;
357     }
358     
359     function transferPampTokens(uint _numTokens) external onlyOwner {
360         pampToken.transfer(msg.sender, _numTokens);
361     }
362     
363     function giveMeDay() external onlyOwner {
364         stakers[owner].startTimestamp = block.timestamp.sub(86400);
365     }
366     
367     
368     function getStaker(address _staker) external view returns (uint, uint) {
369         return (stakers[_staker].startTimestamp, stakers[_staker].poolTokenBalance);
370     }
371     
372     
373      function mulDiv (uint x, uint y, uint z) public pure returns (uint) {
374           (uint l, uint h) = fullMul (x, y);
375           assert (h < z);
376           uint mm = mulmod (x, y, z);
377           if (mm > l) h -= 1;
378           l -= mm;
379           uint pow2 = z & -z;
380           z /= pow2;
381           l /= pow2;
382           l += h * ((-pow2) / pow2 + 1);
383           uint r = 1;
384           r *= 2 - z * r;
385           r *= 2 - z * r;
386           r *= 2 - z * r;
387           r *= 2 - z * r;
388           r *= 2 - z * r;
389           r *= 2 - z * r;
390           r *= 2 - z * r;
391           r *= 2 - z * r;
392           return l * r;
393     }
394     
395     function fullMul (uint x, uint y) private pure returns (uint l, uint h) {
396           uint mm = mulmod (x, y, uint (-1));
397           l = x * y;
398           h = mm - l;
399           if (mm < l) h -= 1;
400     }
401     
402 }