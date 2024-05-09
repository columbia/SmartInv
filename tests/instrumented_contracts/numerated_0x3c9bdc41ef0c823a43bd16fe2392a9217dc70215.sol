1 /**
2  *Submitted for verification at Etherscan.io on 2020-07-10
3 */
4 
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity 0.6.12;
8 
9 
10 /**
11  * @dev Wrappers over Solidity's arithmetic operations with added overflow
12  * checks.
13  *
14  * Arithmetic operations in Solidity wrap on overflow. This can easily result
15  * in bugs, because programmers usually assume that an overflow raises an
16  * error, which is the standard behavior in high level programming languages.
17  * `SafeMath` restores this intuition by reverting the transaction when an
18  * operation overflows.
19  *
20  * Using this library instead of the unchecked operations eliminates an entire
21  * class of bugs, so it's recommended to use it always.
22  */
23 library SafeMath {
24     /**
25      * @dev Returns the addition of two unsigned integers, reverting on
26      * overflow.
27      *
28      * Counterpart to Solidity's `+` operator.
29      *
30      * Requirements:
31      *
32      * - Addition cannot overflow.
33      */
34     function add(uint256 a, uint256 b) internal pure returns (uint256) {
35         uint256 c = a + b;
36         require(c >= a, "SafeMath: addition overflow");
37 
38         return c;
39     }
40 
41     /**
42      * @dev Returns the subtraction of two unsigned integers, reverting on
43      * overflow (when the result is negative).
44      *
45      * Counterpart to Solidity's `-` operator.
46      *
47      * Requirements:
48      *
49      * - Subtraction cannot overflow.
50      */
51     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
52         return sub(a, b, "SafeMath: subtraction overflow");
53     }
54 
55     /**
56      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
57      * overflow (when the result is negative).
58      *
59      * Counterpart to Solidity's `-` operator.
60      *
61      * Requirements:
62      *
63      * - Subtraction cannot overflow.
64      */
65     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
66         require(b <= a, errorMessage);
67         uint256 c = a - b;
68 
69         return c;
70     }
71 
72     /**
73      * @dev Returns the multiplication of two unsigned integers, reverting on
74      * overflow.
75      *
76      * Counterpart to Solidity's `*` operator.
77      *
78      * Requirements:
79      *
80      * - Multiplication cannot overflow.
81      */
82     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
83         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
84         // benefit is lost if 'b' is also tested.
85         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
86         if (a == 0) {
87             return 0;
88         }
89 
90         uint256 c = a * b;
91         require(c / a == b, "SafeMath: multiplication overflow");
92 
93         return c;
94     }
95 
96     /**
97      * @dev Returns the integer division of two unsigned integers. Reverts on
98      * division by zero. The result is rounded towards zero.
99      *
100      * Counterpart to Solidity's `/` operator. Note: this function uses a
101      * `revert` opcode (which leaves remaining gas untouched) while Solidity
102      * uses an invalid opcode to revert (consuming all remaining gas).
103      *
104      * Requirements:
105      *
106      * - The divisor cannot be zero.
107      */
108     function div(uint256 a, uint256 b) internal pure returns (uint256) {
109         return div(a, b, "SafeMath: division by zero");
110     }
111 
112     /**
113      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
114      * division by zero. The result is rounded towards zero.
115      *
116      * Counterpart to Solidity's `/` operator. Note: this function uses a
117      * `revert` opcode (which leaves remaining gas untouched) while Solidity
118      * uses an invalid opcode to revert (consuming all remaining gas).
119      *
120      * Requirements:
121      *
122      * - The divisor cannot be zero.
123      */
124     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
125         require(b > 0, errorMessage);
126         uint256 c = a / b;
127         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
128 
129         return c;
130     }
131 
132     /**
133      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
134      * Reverts when dividing by zero.
135      *
136      * Counterpart to Solidity's `%` operator. This function uses a `revert`
137      * opcode (which leaves remaining gas untouched) while Solidity uses an
138      * invalid opcode to revert (consuming all remaining gas).
139      *
140      * Requirements:
141      *
142      * - The divisor cannot be zero.
143      */
144     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
145         return mod(a, b, "SafeMath: modulo by zero");
146     }
147 
148     /**
149      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
150      * Reverts with custom message when dividing by zero.
151      *
152      * Counterpart to Solidity's `%` operator. This function uses a `revert`
153      * opcode (which leaves remaining gas untouched) while Solidity uses an
154      * invalid opcode to revert (consuming all remaining gas).
155      *
156      * Requirements:
157      *
158      * - The divisor cannot be zero.
159      */
160     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
161         require(b != 0, errorMessage);
162         return a % b;
163     }
164 }
165 
166 
167 /**
168  * @dev Interface of the ERC20 standard as defined in the EIP.
169  */
170 interface IERC20 {
171 
172     function totalSupply() external view returns (uint256);
173 
174     function balanceOf(address account) external view returns (uint256);
175 
176     function transfer(address recipient, uint256 amount) external returns (bool);
177 
178     function allowance(address owner, address spender) external view returns (uint256);
179 
180     function approve(address spender, uint256 amount) external returns (bool);
181 
182     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
183 
184     event Transfer(address indexed from, address indexed to, uint256 value);
185 
186     event Approval(address indexed owner, address indexed spender, uint256 value);
187 }
188 
189 interface UniswapV2 {
190     function addLiquidity(
191         address tokenA,
192         address tokenB,
193         uint amountADesired,
194         uint amountBDesired,
195         uint amountAMin,
196         uint amountBMin,
197         address to,
198         uint deadline
199     ) external returns (uint amountA, uint amountB, uint liquidity);
200     
201     function addLiquidityETH(
202         address token,
203         uint amountTokenDesired,
204         uint amountTokenMin,
205         uint amountETHMin,
206         address to,
207         uint deadline
208     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
209 }
210 
211 
212 interface PreviousLiquidityContract {
213     function emergencyWithdrawLiquidityTokens() external;
214     function getStaker(address _staker) external view returns (uint, uint);
215 }
216 
217 
218 interface Minter {
219     function liquidityRewards(address recipient, uint amount) external;
220 }
221 
222 
223 // Liquidity pool allows a user to stake Uniswap liquidity tokens (tokens representaing shares of ETH and PAMP tokens in the Uniswap liquidity pool)
224 // Users receive rewards in tokens for locking up their liquidity
225 contract LiquidityPool {
226     using SafeMath for uint256;
227     
228     IERC20 public uniswapPair;
229     
230     IERC20 public pampToken;
231     
232     PreviousLiquidityContract public previousContract;
233     
234     Minter public minter;
235     
236     address public owner;
237     
238     uint public minStakeDurationDays;
239     
240     uint public rewardAdjustmentFactor;
241     
242     bool public stakingEnabled;
243     
244     bool public exponentialRewardsEnabled;
245     
246     uint public exponentialDaysMax;
247     
248     bool public migrationEnabled;
249     
250     UniswapV2 public uniswapV2;
251     
252     struct staker {
253         uint startTimestamp;        // Unix timestamp of when the tokens were initially staked
254         uint lastTimestamp;         // Last time tokens were locked or reinvested
255         uint poolTokenBalance;      // Balance of Uniswap liquidity tokens
256         uint lockedRewardBalance;   // Locked rewards in PAMP
257         bool hasMigrated;           // Has staker migrated from previous liquidity contract
258     }
259     
260     mapping(address => staker) public stakers;
261     mapping(address => uint) public previousContractBalances;
262     
263     modifier onlyOwner() {
264         require(owner == msg.sender, "Caller is not the owner");
265         _;
266     }
267     
268     
269     constructor() public {
270         uniswapPair = IERC20(0x1C608235E6A946403F2a048a38550BefE41e1B85);
271         pampToken = IERC20(0xF0FAC7104aAC544e4a7CE1A55ADF2B5a25c65bD1);
272         uniswapV2 = UniswapV2(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
273         minter = Minter(0x28e484dBD6BB501D37EFC8cD4b8dc33121cC78be);
274         previousContract = PreviousLiquidityContract(0x5CECDbdfB96463045b07d07aAa4fc2F1316F7e47);
275         migrationEnabled = true;
276         minStakeDurationDays = 2;
277         owner = msg.sender;
278         rewardAdjustmentFactor = 25E19;
279         stakingEnabled = true;
280         exponentialRewardsEnabled = true;
281         exponentialDaysMax = 60;
282         pampToken.approve(address(uniswapV2), 100000000000E18);
283     }
284     
285     
286     function stakeLiquidityTokens(uint256 numPoolTokensToStake) external {
287         
288         require(numPoolTokensToStake > 0);
289         require(stakingEnabled, "Staking is currently disabled.");
290         
291         uint previousBalance = uniswapPair.balanceOf(address(this));                    
292         
293         uniswapPair.transferFrom(msg.sender, address(this), numPoolTokensToStake);      // Transfer liquidity tokens from the sender to this contract
294         
295         uint postBalance = uniswapPair.balanceOf(address(this));
296         
297         require(previousBalance.add(numPoolTokensToStake) == postBalance);              // This is a sanity check and likely not required as the Uniswap token is ERC20
298         
299         staker storage thisStaker = stakers[msg.sender];                                // Get the sender's information
300         
301         if(thisStaker.startTimestamp == 0 || thisStaker.poolTokenBalance == 0) {
302             thisStaker.startTimestamp = block.timestamp;
303             thisStaker.lastTimestamp = block.timestamp;
304         } else {                                                                        // If the sender is currently staking, adding to his balance results in a holding time penalty
305             uint percent = mulDiv(1000000, numPoolTokensToStake, thisStaker.poolTokenBalance);      // This is not really 'percent' it is just a number that represents the totalAmount as a fraction of the recipientBalance
306             assert(percent > 0);
307             if(percent > 1) {
308                 percent = percent.div(2);           // We divide the 'penalty' by 2 so that the penalty is not as bad
309             }
310             if(percent.add(thisStaker.startTimestamp) > block.timestamp) {         // We represent the 'percent' or 'penalty' as seconds and add to the recipient's unix time
311                thisStaker.startTimestamp = block.timestamp; // Receiving too many tokens resets your holding time
312             } else {
313                 thisStaker.startTimestamp = thisStaker.startTimestamp.add(percent);               
314             }
315         }
316         
317         thisStaker.hasMigrated = true;
318         thisStaker.poolTokenBalance = thisStaker.poolTokenBalance.add(numPoolTokensToStake);
319 
320     }
321     
322     function addLiquidity(uint _numTokensToInvest) external payable {      // This allows you to add liquidity without the burn penalty
323         pampToken.transferFrom(msg.sender, address(this), _numTokensToInvest);
324         (uint amountToken, uint amountETH, uint liquidity) = uniswapV2.addLiquidityETH{value: msg.value}(address(pampToken), _numTokensToInvest, 0, 0, address(this), now+86400);  // Adding liquidity to Uniswap via the router
325         
326         staker storage thisStaker = stakers[msg.sender];                                // Get the sender's information
327         
328         if(thisStaker.startTimestamp == 0 || thisStaker.poolTokenBalance == 0) {
329             thisStaker.startTimestamp = block.timestamp;
330             thisStaker.lastTimestamp = block.timestamp;
331         } else {                                                                        // If the sender is currently staking, adding to his balance results in a holding time penalty
332             uint percent = mulDiv(1000000, liquidity, thisStaker.poolTokenBalance);      // This is not really 'percent' it is just a number that represents the totalAmount as a fraction of the recipientBalance
333             assert(percent > 0);
334             if(percent > 1) {
335                 percent = percent.div(2);           // We divide the 'penalty' by 2 so that the penalty is not as bad
336             }
337             if(percent.add(thisStaker.startTimestamp) > block.timestamp) {         // We represent the 'percent' or 'penalty' as seconds and add to the recipient's unix time
338                thisStaker.startTimestamp = block.timestamp; // Receiving too many tokens resets your holding time
339             } else {
340                 thisStaker.startTimestamp = thisStaker.startTimestamp.add(percent);               
341             }
342         }
343         thisStaker.hasMigrated = true;
344         thisStaker.poolTokenBalance = thisStaker.poolTokenBalance.add(liquidity);
345     }
346     
347     function migrateState() external {
348         staker storage thisStaker = stakers[msg.sender]; 
349         require(!thisStaker.hasMigrated, "You have already migrated");
350         require(migrationEnabled, "Migration is disabled");
351         
352         (uint startTimestamp, uint poolTokenBalance) = previousContract.getStaker(msg.sender);      // Get previous contract balance and info
353         
354         
355         thisStaker.startTimestamp = startTimestamp;
356         thisStaker.lastTimestamp = startTimestamp;
357 
358         previousContractBalances[msg.sender] = poolTokenBalance;
359     }
360     
361     function migrateTokens() external {
362         staker storage thisStaker = stakers[msg.sender]; 
363         require(!thisStaker.hasMigrated, "You have already migrated");
364         require(migrationEnabled, "Migration is disabled");
365         
366         uint previousBalance = previousContractBalances[msg.sender];
367         
368         require(previousBalance > 0, "You have no tokens to migrate");
369         
370         require(uniswapPair.transferFrom(msg.sender, address(this), previousBalance), "Failure transferring UNI-V2");      // Must already be approved
371         
372         thisStaker.poolTokenBalance = previousBalance;
373         
374         delete previousContractBalances[msg.sender];
375         
376         thisStaker.hasMigrated = true;
377         
378         thisStaker.lockedRewardBalance = 10E18;
379     }
380     
381     // Withdraw liquidity tokens, pretty self-explanatory
382     function withdrawLiquidityTokens(uint256 numPoolTokensToWithdraw) external {
383         
384         require(numPoolTokensToWithdraw > 0);
385         
386         staker storage thisStaker = stakers[msg.sender];
387         
388         require(thisStaker.hasMigrated, "You must migrate");
389                 
390         require(thisStaker.poolTokenBalance >= numPoolTokensToWithdraw, "Pool token balance too low");
391         
392         uint daysStaked = block.timestamp.sub(thisStaker.startTimestamp) / 86400;  // Calculate time staked in days
393         
394         require(daysStaked >= minStakeDurationDays);
395         
396         uint tokensOwed = calculateTokensOwed(msg.sender);      // We give all of the rewards owed to the sender on a withdrawal, regardless of the amount withdrawn
397         
398         tokensOwed = tokensOwed.add(thisStaker.lockedRewardBalance);
399         
400         thisStaker.lockedRewardBalance = 0;
401         thisStaker.poolTokenBalance = thisStaker.poolTokenBalance.sub(numPoolTokensToWithdraw);
402         
403         thisStaker.startTimestamp = block.timestamp; // Reset staking timer on withdrawal
404         thisStaker.lastTimestamp = block.timestamp;
405         
406         minter.liquidityRewards(msg.sender, tokensOwed);            
407         
408         uniswapPair.transfer(msg.sender, numPoolTokensToWithdraw);
409     }
410     
411     function withdrawRewards() external {
412         
413         staker storage thisStaker = stakers[msg.sender];
414         
415         uint daysStaked = block.timestamp.sub(thisStaker.startTimestamp) / 86400;  // Calculate time staked in days
416         
417         require(daysStaked >= minStakeDurationDays);
418         require(thisStaker.hasMigrated, "You must migrate");
419         
420         uint tokensOwed = calculateTokensOwed(msg.sender);
421         
422         tokensOwed = tokensOwed.add(thisStaker.lockedRewardBalance);
423         
424         thisStaker.lockedRewardBalance = 0;
425         thisStaker.startTimestamp = block.timestamp; // Reset staking timer on withdrawal
426         thisStaker.lastTimestamp = block.timestamp;
427         
428         minter.liquidityRewards(msg.sender, tokensOwed);            
429     }
430     
431     function lockRewards() external {
432         
433         uint currentRewards = calculateTokensOwed(msg.sender);
434         staker storage thisStaker = stakers[msg.sender];
435         require(thisStaker.hasMigrated, "You must migrate");
436         
437         thisStaker.lastTimestamp = block.timestamp;
438         thisStaker.lockedRewardBalance = thisStaker.lockedRewardBalance.add(currentRewards);
439         
440     }
441     
442     function reinvestRewards(bool locked, uint _numTokensToReinvest) external payable {
443         
444         staker storage thisStaker = stakers[msg.sender];
445         require(thisStaker.hasMigrated);
446         
447         if(locked) {
448             thisStaker.lockedRewardBalance = thisStaker.lockedRewardBalance.sub(_numTokensToReinvest);  
449             minter.liquidityRewards(address(this), _numTokensToReinvest);
450             (uint amountToken, uint amountETH, uint liquidity) = uniswapV2.addLiquidityETH{value: msg.value}(address(pampToken), _numTokensToReinvest, 0, 0, address(this), now+86400);  // Adding liquidity to Uniswap via the router
451             thisStaker.poolTokenBalance = thisStaker.poolTokenBalance.add(liquidity);
452             
453         } else {
454             uint numTokensToReinvest = calculateTokensOwed(msg.sender);
455             thisStaker.lastTimestamp = block.timestamp;
456             minter.liquidityRewards(address(this), numTokensToReinvest);
457             (uint amountToken, uint amountETH, uint liquidity) = uniswapV2.addLiquidityETH{value:msg.value}(address(pampToken), numTokensToReinvest, 0, 0, address(this), now+86400);
458             thisStaker.poolTokenBalance = thisStaker.poolTokenBalance.add(liquidity);
459         }
460     }
461     
462     // If you call this function you forfeit your rewards
463     function emergencyWithdrawLiquidityTokens() external {
464         staker storage thisStaker = stakers[msg.sender];
465         uint poolTokenBalance = thisStaker.poolTokenBalance;
466         thisStaker.poolTokenBalance = 0;
467         thisStaker.startTimestamp = block.timestamp;
468         thisStaker.lastTimestamp = block.timestamp;
469         thisStaker.lockedRewardBalance = 0;
470         thisStaker.hasMigrated = true;
471         uniswapPair.transfer(msg.sender, poolTokenBalance);
472     }
473     
474     function calculateTokensOwed(address stakerAddr) public view returns (uint256) {
475         
476         staker memory thisStaker = stakers[stakerAddr];
477         
478         uint totalDaysStaked = block.timestamp.sub(thisStaker.startTimestamp) / 86400;  // Calculate time staked in days
479         uint daysSinceLast = block.timestamp.sub(thisStaker.lastTimestamp) / 86400;
480         
481         uint tokens = mulDiv(daysSinceLast.mul(rewardAdjustmentFactor), thisStaker.poolTokenBalance, uniswapPair.totalSupply()); // The formula is as follows: tokens owned = (days staked * reward adjustment factor) * (sender liquidity token balance / total supply of liquidity token)
482         
483         if(totalDaysStaked > exponentialDaysMax) {
484             totalDaysStaked = exponentialDaysMax;
485         }
486         
487         if(exponentialRewardsEnabled) {
488             return tokens * totalDaysStaked;
489         } else {
490             return tokens;
491         }
492         
493         
494     }
495     
496     function calculateMonthlyYield() public view returns (uint256) {
497         uint tokensInPool = pampToken.balanceOf(address(uniswapPair));
498         uint tokens = 30 * mulDiv(30 * rewardAdjustmentFactor, 1, 2); // Tokens given per month for 50% of pool (50% because APY should also consider ETH contribution)
499         return mulDiv(10000, tokens, tokensInPool);
500         
501     }
502     
503     function updateUniswapPair(address _uniswapPair) external onlyOwner {
504         uniswapPair = IERC20(_uniswapPair);
505     }
506     
507     function updateUinswapV2(address _uniswapv2) external onlyOwner {
508         uniswapV2 = UniswapV2(_uniswapv2);
509         pampToken.approve(address(uniswapV2), 100000000E18);
510     }
511     
512     function updatePampToken(address _pampToken) external onlyOwner {
513         pampToken = IERC20(_pampToken);
514     }
515     
516     function updateMinter(address _minter) external onlyOwner {
517         minter = Minter(_minter);
518     }
519     
520     function updatePreviousLiquidityContract(address _previousContract) external onlyOwner {
521         previousContract = PreviousLiquidityContract(_previousContract);
522     }
523     
524     function updateMinStakeDurationDays(uint _minStakeDurationDays) external onlyOwner {
525         minStakeDurationDays = _minStakeDurationDays;
526     }
527     
528     function updateRewardAdjustmentFactor(uint _rewardAdjustmentFactor) external onlyOwner {
529         rewardAdjustmentFactor = _rewardAdjustmentFactor;
530     }
531     
532     function updateStakingEnabled(bool _stakingEnbaled) external onlyOwner {
533         stakingEnabled = _stakingEnbaled;
534     }
535     
536     function updateExponentialRewardsEnabled(bool _exponentialRewards) external onlyOwner {
537         exponentialRewardsEnabled = _exponentialRewards;
538     }
539     
540     function updateExponentialDaysMax(uint _exponentialDaysMax) external onlyOwner {
541         exponentialDaysMax = _exponentialDaysMax;
542     }
543     
544     function updateMigrationEnabled(bool _migrationEnabled) external onlyOwner {
545         migrationEnabled = _migrationEnabled;
546     }
547 
548     function transferPampTokens(uint _numTokens) external onlyOwner {
549         pampToken.transfer(msg.sender, _numTokens);
550     }
551     
552     function transferEth(uint _eth) external onlyOwner {
553         msg.sender.transfer(_eth);
554     }
555     
556     function transferOwnership(address _newOwner) external onlyOwner {
557         owner = _newOwner;
558     }
559     
560     function giveMeDayStart() external onlyOwner {
561         stakers[owner].startTimestamp = stakers[owner].startTimestamp.sub(86400);
562     }
563     
564     function giveMeDayLast() external onlyOwner {
565         stakers[owner].lastTimestamp = stakers[owner].lastTimestamp.sub(86400);
566     }
567     
568     
569     function getStaker(address _staker) external view returns (uint, uint, uint, uint, bool) {
570         return (stakers[_staker].startTimestamp, stakers[_staker].lastTimestamp, stakers[_staker].poolTokenBalance, stakers[_staker].lockedRewardBalance, stakers[_staker].hasMigrated);
571     }
572     
573     
574      function mulDiv (uint x, uint y, uint z) public pure returns (uint) {
575           (uint l, uint h) = fullMul (x, y);
576           assert (h < z);
577           uint mm = mulmod (x, y, z);
578           if (mm > l) h -= 1;
579           l -= mm;
580           uint pow2 = z & -z;
581           z /= pow2;
582           l /= pow2;
583           l += h * ((-pow2) / pow2 + 1);
584           uint r = 1;
585           r *= 2 - z * r;
586           r *= 2 - z * r;
587           r *= 2 - z * r;
588           r *= 2 - z * r;
589           r *= 2 - z * r;
590           r *= 2 - z * r;
591           r *= 2 - z * r;
592           r *= 2 - z * r;
593           return l * r;
594     }
595     
596     function fullMul (uint x, uint y) private pure returns (uint l, uint h) {
597           uint mm = mulmod (x, y, uint (-1));
598           l = x * y;
599           h = mm - l;
600           if (mm < l) h -= 1;
601     }
602     
603     fallback() external payable {}
604     receive() external payable {}
605 }