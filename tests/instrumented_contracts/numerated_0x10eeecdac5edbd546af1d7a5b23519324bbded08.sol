1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.6.0;
3 
4 /**
5  * @dev Wrappers over Solidity's arithmetic operations with added overflow
6  * checks.
7  *
8  * Arithmetic operations in Solidity wrap on overflow. This can easily result
9  * in bugs, because programmers usually assume that an overflow raises an
10  * error, which is the standard behavior in high level programming languages.
11  * `SafeMath` restores this intuition by reverting the transaction when an
12  * operation overflows.
13  *
14  * Using this library instead of the unchecked operations eliminates an entire
15  * class of bugs, so it's recommended to use it always.
16  */
17 library SafeMath {
18     /**
19      * @dev Returns the addition of two unsigned integers, reverting on
20      * overflow.
21      *
22      * Counterpart to Solidity's `+` operator.
23      *
24      * Requirements:
25      *
26      * - Addition cannot overflow.
27      */
28     function add(uint256 a, uint256 b) internal pure returns (uint256) {
29         uint256 c = a + b;
30         require(c >= a, "SafeMath: addition overflow");
31 
32         return c;
33     }
34 
35     /**
36      * @dev Returns the subtraction of two unsigned integers, reverting on
37      * overflow (when the result is negative).
38      *
39      * Counterpart to Solidity's `-` operator.
40      *
41      * Requirements:
42      *
43      * - Subtraction cannot overflow.
44      */
45     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
46         return sub(a, b, "SafeMath: subtraction overflow");
47     }
48 
49     /**
50      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
51      * overflow (when the result is negative).
52      *
53      * Counterpart to Solidity's `-` operator.
54      *
55      * Requirements:
56      *
57      * - Subtraction cannot overflow.
58      */
59     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
60         require(b <= a, errorMessage);
61         uint256 c = a - b;
62 
63         return c;
64     }
65 
66     /**
67      * @dev Returns the multiplication of two unsigned integers, reverting on
68      * overflow.
69      *
70      * Counterpart to Solidity's `*` operator.
71      *
72      * Requirements:
73      *
74      * - Multiplication cannot overflow.
75      */
76     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
77         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
78         // benefit is lost if 'b' is also tested.
79         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
80         if (a == 0) {
81             return 0;
82         }
83 
84         uint256 c = a * b;
85         require(c / a == b, "SafeMath: multiplication overflow");
86 
87         return c;
88     }
89 
90     /**
91      * @dev Returns the integer division of two unsigned integers. Reverts on
92      * division by zero. The result is rounded towards zero.
93      *
94      * Counterpart to Solidity's `/` operator. Note: this function uses a
95      * `revert` opcode (which leaves remaining gas untouched) while Solidity
96      * uses an invalid opcode to revert (consuming all remaining gas).
97      *
98      * Requirements:
99      *
100      * - The divisor cannot be zero.
101      */
102     function div(uint256 a, uint256 b) internal pure returns (uint256) {
103         return div(a, b, "SafeMath: division by zero");
104     }
105 
106     /**
107      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
108      * division by zero. The result is rounded towards zero.
109      *
110      * Counterpart to Solidity's `/` operator. Note: this function uses a
111      * `revert` opcode (which leaves remaining gas untouched) while Solidity
112      * uses an invalid opcode to revert (consuming all remaining gas).
113      *
114      * Requirements:
115      *
116      * - The divisor cannot be zero.
117      */
118     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
119         require(b > 0, errorMessage);
120         uint256 c = a / b;
121         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
122 
123         return c;
124     }
125 
126     /**
127      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
128      * Reverts when dividing by zero.
129      *
130      * Counterpart to Solidity's `%` operator. This function uses a `revert`
131      * opcode (which leaves remaining gas untouched) while Solidity uses an
132      * invalid opcode to revert (consuming all remaining gas).
133      *
134      * Requirements:
135      *
136      * - The divisor cannot be zero.
137      */
138     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
139         return mod(a, b, "SafeMath: modulo by zero");
140     }
141 
142     /**
143      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
144      * Reverts with custom message when dividing by zero.
145      *
146      * Counterpart to Solidity's `%` operator. This function uses a `revert`
147      * opcode (which leaves remaining gas untouched) while Solidity uses an
148      * invalid opcode to revert (consuming all remaining gas).
149      *
150      * Requirements:
151      *
152      * - The divisor cannot be zero.
153      */
154     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
155         require(b != 0, errorMessage);
156         return a % b;
157     }
158 }
159 
160 /*
161  * @dev Provides information about the current execution context, including the
162  * sender of the transaction and its data. While these are generally available
163  * via msg.sender and msg.data, they should not be accessed in such a direct
164  * manner, since when dealing with GSN meta-transactions the account sending and
165  * paying for execution may not be the actual sender (as far as an application
166  * is concerned).
167  *
168  * This contract is only required for intermediate, library-like contracts.
169  */
170 abstract contract Context {
171     function _msgSender() internal view virtual returns (address payable) {
172         return msg.sender;
173     }
174 
175     function _msgData() internal view virtual returns (bytes memory) {
176         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
177         return msg.data;
178     }
179 }
180 
181 /**
182  * @dev Contract module which provides a basic access control mechanism, where
183  * there is an account (an owner) that can be granted exclusive access to
184  * specific functions.
185  *
186  * By default, the owner account will be the one that deploys the contract. This
187  * can later be changed with {transferOwnership}.
188  *
189  * This module is used through inheritance. It will make available the modifier
190  * `onlyOwner`, which can be applied to your functions to restrict their use to
191  * the owner.
192  */
193 contract Ownable is Context {
194     address private _owner;
195 
196     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
197 
198     /**
199      * @dev Initializes the contract setting the deployer as the initial owner.
200      */
201     constructor () internal {
202         address msgSender = _msgSender();
203         _owner = msgSender;
204         emit OwnershipTransferred(address(0), msgSender);
205     }
206 
207     /**
208      * @dev Returns the address of the current owner.
209      */
210     function owner() public view returns (address) {
211         return _owner;
212     }
213 
214     /**
215      * @dev Throws if called by any account other than the owner.
216      */
217     modifier onlyOwner() {
218         require(_owner == _msgSender(), "Ownable: caller is not the owner");
219         _;
220     }
221 
222     /**
223      * @dev Leaves the contract without owner. It will not be possible to call
224      * `onlyOwner` functions anymore. Can only be called by the current owner.
225      *
226      * NOTE: Renouncing ownership will leave the contract without an owner,
227      * thereby removing any functionality that is only available to the owner.
228      */
229     function renounceOwnership() public virtual onlyOwner {
230         emit OwnershipTransferred(_owner, address(0));
231         _owner = address(0);
232     }
233 
234     /**
235      * @dev Transfers ownership of the contract to a new account (`newOwner`).
236      * Can only be called by the current owner.
237      */
238     function transferOwnership(address newOwner) public virtual onlyOwner {
239         require(newOwner != address(0), "Ownable: new owner is the zero address");
240         emit OwnershipTransferred(_owner, newOwner);
241         _owner = newOwner;
242     }
243 }
244 
245 /**
246  * @dev Interface of the ERC20 standard as defined in the EIP.
247  */
248 interface IERC20 {
249     /**
250      * @dev Returns the amount of tokens in existence.
251      */
252     function totalSupply() external view returns (uint256);
253 
254     /**
255      * @dev Returns the amount of tokens owned by `account`.
256      */
257     function balanceOf(address account) external view returns (uint256);
258 
259     /**
260      * @dev Moves `amount` tokens from the caller's account to `recipient`.
261      *
262      * Returns a boolean value indicating whether the operation succeeded.
263      *
264      * Emits a {Transfer} event.
265      */
266     function transfer(address recipient, uint256 amount) external returns (bool);
267 
268     /**
269      * @dev Returns the remaining number of tokens that `spender` will be
270      * allowed to spend on behalf of `owner` through {transferFrom}. This is
271      * zero by default.
272      *
273      * This value changes when {approve} or {transferFrom} are called.
274      */
275     function allowance(address owner, address spender) external view returns (uint256);
276 
277     /**
278      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
279      *
280      * Returns a boolean value indicating whether the operation succeeded.
281      *
282      * IMPORTANT: Beware that changing an allowance with this method brings the risk
283      * that someone may use both the old and the new allowance by unfortunate
284      * transaction ordering. One possible solution to mitigate this race
285      * condition is to first reduce the spender's allowance to 0 and set the
286      * desired value afterwards:
287      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
288      *
289      * Emits an {Approval} event.
290      */
291     function approve(address spender, uint256 amount) external returns (bool);
292 
293     /**
294      * @dev Moves `amount` tokens from `sender` to `recipient` using the
295      * allowance mechanism. `amount` is then deducted from the caller's
296      * allowance.
297      *
298      * Returns a boolean value indicating whether the operation succeeded.
299      *
300      * Emits a {Transfer} event.
301      */
302     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
303 
304     /**
305      * @dev Emitted when `value` tokens are moved from one account (`from`) to
306      * another (`to`).
307      *
308      * Note that `value` may be zero.
309      */
310     event Transfer(address indexed from, address indexed to, uint256 value);
311 
312     /**
313      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
314      * a call to {approve}. `value` is the new allowance.
315      */
316     event Approval(address indexed owner, address indexed spender, uint256 value);
317 }
318 
319 interface IERC20Capped {
320     function cap() external view returns (uint256);
321 }
322 
323 interface IMintable {
324     function mint(address account, uint256 amount) external returns (bool);
325 }
326 
327 interface IUniswapV2Factory {
328     function getPair(address tokenA, address tokenB) external view returns (address pair);
329 }
330 
331 interface IUniswapV2Router02 {
332     function addLiquidityETH(
333         address token,
334         uint amountTokenDesired,
335         uint amountTokenMin,
336         uint amountETHMin,
337         address to,
338         uint deadline
339     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
340 }
341 
342 contract Airpool is Ownable {
343     using SafeMath for uint256;
344     
345     event Staked(
346         address lpToken,
347         address user,
348         uint256 amountToken,
349         uint256 amountETH,
350         uint256 liquidity
351     );
352     
353     event Unstaked(
354         address user,
355         address lpToken,
356         uint256 amountToken
357     );
358     
359     event RewardWithdrawn(
360         address user,
361         uint256 amount
362     );
363     
364     uint256 private constant rewardMultiplier = 1e17;
365     
366     struct Stake {
367         uint256 stakeAmount; // lp token address to token amount
368         uint256 totalStakedAmountByUser; // sum of all lp tokens
369         uint256 lastInteractionBlockNumber; // block number at last withdraw
370         uint256 stakingPeriodEndTime;
371     }
372     
373     mapping(address => Stake) public userToStakes; // user to stake
374     uint256 public totalStakedAmount; // sum of stakes by all of the users across all lp
375     
376     address internal uniswapFactoryAddress = 0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f;
377     address internal uniswapRouterAddress = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
378      
379     IUniswapV2Factory public uniswapFactory = IUniswapV2Factory(uniswapFactoryAddress);
380     IUniswapV2Router02 public uniswapRouter = IUniswapV2Router02(uniswapRouterAddress);
381 
382     address public token;
383     address public lpToken;
384     
385     uint256 public blockMiningTime = 15;
386     uint256 public blockReward = 100000000000000000;
387     uint256 public stakingDuration = 120;
388     uint256 public minimumAmount = 1000000000000000;
389     uint256 public maximumAmount = 100000000000000000000; 
390 
391     constructor(address airdropToken, address pairToken) public {
392         token = airdropToken;
393         lpToken = pairToken;
394         
395         IERC20(token).approve(uniswapRouterAddress, 1e52); // approve uniswap router
396     }
397     
398     function setMinimumAmount(uint256 amount) external onlyOwner {
399         require(
400             amount != 0,
401             "minimum amount cannot be zero"
402         );
403         minimumAmount = amount;
404     }
405     
406     function setMaximumAmount(uint256 amount) external onlyOwner {
407         require(
408             amount != 0,
409             "maximum amount cannot be zero"
410         );
411         maximumAmount = amount;
412     }
413     
414     function setBlockReward(uint256 rewardAmount) external onlyOwner {
415         require(
416             rewardAmount != 0,
417             "new reward cannot be zero"
418         );
419         blockReward = rewardAmount;
420     }
421     
422     function setStakingDuration(uint256 duration) external onlyOwner {
423         require(
424             duration != 0,
425             "new reward cannot be zero"
426         );
427         stakingDuration = duration;
428     }
429 
430     function changeBlockMiningTime(uint256 newTime) external onlyOwner {
431         require(
432             newTime != 0,
433             "new time cannot be zero"
434         );
435         blockMiningTime = newTime;
436     }
437 
438     function supplyAirpool(
439         uint256 amountTokenDesired,
440         uint256 amountTokenMin,
441         uint256 amountETHMin
442     ) external payable {
443         require(
444             msg.value != 0, // must send ether
445             "amount should be greater than 0"
446         );
447         
448         require(
449             msg.value >= minimumAmount,
450             "amount too low"
451         );
452         
453         require(
454             msg.value <= maximumAmount,
455             "amount too high"
456         );
457 
458         uint deadline = block.timestamp.add(2 hours); // set deadline to 2 hours from now
459 
460         (uint amountToken, uint amountETH, uint liquidity) = uniswapRouter.addLiquidityETH.value(msg.value)(
461             token,
462             amountTokenDesired,
463             amountTokenMin,
464             amountETHMin,
465             address(this),
466             deadline 
467         );
468         
469         if (msg.value > amountETH) {
470             _msgSender().transfer(msg.value - amountETH); // transfer dust eth back to sender
471         }
472         
473         _withdrawReward(_msgSender()); // withdraw any existing rewards
474 
475         totalStakedAmount = totalStakedAmount.add(liquidity); // add stake amount to sum of all stakes across al lps
476         
477         Stake storage currentStake = userToStakes[_msgSender()];
478         currentStake.stakingPeriodEndTime = block.timestamp.add(
479             stakingDuration
480         ); // set the staking period end time
481 
482         currentStake.stakeAmount =  currentStake.stakeAmount // add stake amount by lp
483             .add(liquidity);
484         
485         currentStake.totalStakedAmountByUser = currentStake.totalStakedAmountByUser // add stake amount to sum of all stakes by user
486             .add(liquidity);
487 
488         emit Staked(
489             lpToken,
490             _msgSender(),
491             amountToken,
492             amountETH,
493             liquidity
494         ); // broadcast event
495     }
496     
497     function unstake() external {
498         _withdrawReward(_msgSender());
499         Stake storage currentStake = userToStakes[_msgSender()];
500         uint256 stakeAmountToDeduct;
501         bool executeUnstaking;
502         uint256 stakeAmount = currentStake.stakeAmount;
503             
504         if (currentStake.stakeAmount == 0) {
505             revert("no stake");
506         }
507 
508         if (currentStake.stakingPeriodEndTime <= block.timestamp) {
509             executeUnstaking = true;
510         }
511 
512         require(
513             executeUnstaking,
514             "cannot unstake"
515         );
516         
517         currentStake.stakeAmount = 0;
518         
519         currentStake.totalStakedAmountByUser = currentStake.totalStakedAmountByUser
520             .sub(stakeAmount);
521         
522         stakeAmountToDeduct = stakeAmountToDeduct.add(stakeAmount);
523         
524         require(
525             IERC20(lpToken).transfer(_msgSender(), stakeAmount), // transfer staked tokens back to the user
526             "#transferFrom failed"
527         );
528         
529         emit Unstaked(lpToken, _msgSender(), stakeAmount);
530         
531         totalStakedAmount = totalStakedAmount.sub(stakeAmountToDeduct); // subtract unstaked amount from total staked amount
532     }
533     
534     function withdrawReward() external {
535         _withdrawReward(_msgSender());
536     }
537     
538     function getBlockCountSinceLastIntreraction(address user) public view returns(uint256) {
539         uint256 lastInteractionBlockNum = userToStakes[user].lastInteractionBlockNumber;
540         if (lastInteractionBlockNum == 0) {
541             return 0;
542         }
543         
544         return block.number.sub(lastInteractionBlockNum);
545     }
546     
547     function getTotalStakeAmountByUser(address user) public view returns(uint256) {
548         return userToStakes[user].totalStakedAmountByUser;
549     }
550     
551     function getStakeAmountByUser(
552         address user
553     ) public view returns(uint256) {
554         return userToStakes[user].stakeAmount;
555     }
556     
557     function getRewardByAddress(
558         address user
559     ) public view returns(uint256) {
560         if (totalStakedAmount == 0) {
561             return 0;
562         }
563         
564         Stake storage currentStake = userToStakes[user];
565         
566         uint256 blockCount = block.number
567             .sub(currentStake.lastInteractionBlockNumber);
568         
569         uint256 totalReward = blockCount.mul(blockReward);
570         
571         return totalReward
572             .mul(currentStake.totalStakedAmountByUser)
573             .div(totalStakedAmount);
574     }
575     
576     function _withdrawReward(address user) internal {
577         uint256 rewardAmount = getRewardByAddress(user);
578         
579         uint256 totalSupply = IERC20(token).totalSupply();
580         uint256 cap = IERC20Capped(token).cap();
581         
582         if (rewardAmount != 0) {
583             if (totalSupply.add(rewardAmount) <= cap) {
584                 require(
585                     IMintable(token).mint(user, rewardAmount), // reward user with newly minted tokens
586                     "#mint failed"
587                 );
588                 emit RewardWithdrawn(user, rewardAmount);
589             }
590         }
591         
592         userToStakes[user].lastInteractionBlockNumber = block.number;
593     }
594 }