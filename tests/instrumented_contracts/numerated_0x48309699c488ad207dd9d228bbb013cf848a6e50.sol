1 // File: @openzeppelin/contracts@2.5.1/GSN/Context.sol
2 
3 pragma solidity ^0.5.0;
4 
5 /*
6  * @dev Provides information about the current execution context, including the
7  * sender of the transaction and its data. While these are generally available
8  * via msg.sender and msg.data, they should not be accessed in such a direct
9  * manner, since when dealing with GSN meta-transactions the account sending and
10  * paying for execution may not be the actual sender (as far as an application
11  * is concerned).
12  *
13  * This contract is only required for intermediate, library-like contracts.
14  */
15 contract Context {
16     // Empty internal constructor, to prevent people from mistakenly deploying
17     // an instance of this contract, which should be used via inheritance.
18     constructor () internal { }
19     // solhint-disable-previous-line no-empty-blocks
20 
21     function _msgSender() internal view returns (address payable) {
22         return msg.sender;
23     }
24 
25     function _msgData() internal view returns (bytes memory) {
26         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
27         return msg.data;
28     }
29 }
30 
31 // File: @openzeppelin/contracts@2.5.1/ownership/Ownable.sol
32 
33 pragma solidity ^0.5.0;
34 
35 /**
36  * @dev Contract module which provides a basic access control mechanism, where
37  * there is an account (an owner) that can be granted exclusive access to
38  * specific functions.
39  *
40  * This module is used through inheritance. It will make available the modifier
41  * `onlyOwner`, which can be applied to your functions to restrict their use to
42  * the owner.
43  */
44 contract Ownable is Context {
45     address private _owner;
46 
47     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
48 
49     /**
50      * @dev Initializes the contract setting the deployer as the initial owner.
51      */
52     constructor () internal {
53         address msgSender = _msgSender();
54         _owner = msgSender;
55         emit OwnershipTransferred(address(0), msgSender);
56     }
57 
58     /**
59      * @dev Returns the address of the current owner.
60      */
61     function owner() public view returns (address) {
62         return _owner;
63     }
64 
65     /**
66      * @dev Throws if called by any account other than the owner.
67      */
68     modifier onlyOwner() {
69         require(isOwner(), "Ownable: caller is not the owner");
70         _;
71     }
72 
73     /**
74      * @dev Returns true if the caller is the current owner.
75      */
76     function isOwner() public view returns (bool) {
77         return _msgSender() == _owner;
78     }
79 
80     /**
81      * @dev Leaves the contract without owner. It will not be possible to call
82      * `onlyOwner` functions anymore. Can only be called by the current owner.
83      *
84      * NOTE: Renouncing ownership will leave the contract without an owner,
85      * thereby removing any functionality that is only available to the owner.
86      */
87     function renounceOwnership() public onlyOwner {
88         emit OwnershipTransferred(_owner, address(0));
89         _owner = address(0);
90     }
91 
92     /**
93      * @dev Transfers ownership of the contract to a new account (`newOwner`).
94      * Can only be called by the current owner.
95      */
96     function transferOwnership(address newOwner) public onlyOwner {
97         _transferOwnership(newOwner);
98     }
99 
100     /**
101      * @dev Transfers ownership of the contract to a new account (`newOwner`).
102      */
103     function _transferOwnership(address newOwner) internal {
104         require(newOwner != address(0), "Ownable: new owner is the zero address");
105         emit OwnershipTransferred(_owner, newOwner);
106         _owner = newOwner;
107     }
108 }
109 
110 // File: @openzeppelin/contracts@2.5.1/token/ERC20/IERC20.sol
111 
112 pragma solidity ^0.5.0;
113 
114 /**
115  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
116  * the optional functions; to access them see {ERC20Detailed}.
117  */
118 interface IERC20 {
119     /**
120      * @dev Returns the amount of tokens in existence.
121      */
122     function totalSupply() external view returns (uint256);
123 
124     /**
125      * @dev Returns the amount of tokens owned by `account`.
126      */
127     function balanceOf(address account) external view returns (uint256);
128 
129     /**
130      * @dev Moves `amount` tokens from the caller's account to `recipient`.
131      *
132      * Returns a boolean value indicating whether the operation succeeded.
133      *
134      * Emits a {Transfer} event.
135      */
136     function transfer(address recipient, uint256 amount) external returns (bool);
137 
138     /**
139      * @dev Returns the remaining number of tokens that `spender` will be
140      * allowed to spend on behalf of `owner` through {transferFrom}. This is
141      * zero by default.
142      *
143      * This value changes when {approve} or {transferFrom} are called.
144      */
145     function allowance(address owner, address spender) external view returns (uint256);
146 
147     /**
148      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
149      *
150      * Returns a boolean value indicating whether the operation succeeded.
151      *
152      * IMPORTANT: Beware that changing an allowance with this method brings the risk
153      * that someone may use both the old and the new allowance by unfortunate
154      * transaction ordering. One possible solution to mitigate this race
155      * condition is to first reduce the spender's allowance to 0 and set the
156      * desired value afterwards:
157      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
158      *
159      * Emits an {Approval} event.
160      */
161     function approve(address spender, uint256 amount) external returns (bool);
162 
163     /**
164      * @dev Moves `amount` tokens from `sender` to `recipient` using the
165      * allowance mechanism. `amount` is then deducted from the caller's
166      * allowance.
167      *
168      * Returns a boolean value indicating whether the operation succeeded.
169      *
170      * Emits a {Transfer} event.
171      */
172     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
173 
174     /**
175      * @dev Emitted when `value` tokens are moved from one account (`from`) to
176      * another (`to`).
177      *
178      * Note that `value` may be zero.
179      */
180     event Transfer(address indexed from, address indexed to, uint256 value);
181 
182     /**
183      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
184      * a call to {approve}. `value` is the new allowance.
185      */
186     event Approval(address indexed owner, address indexed spender, uint256 value);
187 }
188 
189 // File: @openzeppelin/contracts@2.5.1/math/SafeMath.sol
190 
191 pragma solidity ^0.5.0;
192 
193 /**
194  * @dev Wrappers over Solidity's arithmetic operations with added overflow
195  * checks.
196  *
197  * Arithmetic operations in Solidity wrap on overflow. This can easily result
198  * in bugs, because programmers usually assume that an overflow raises an
199  * error, which is the standard behavior in high level programming languages.
200  * `SafeMath` restores this intuition by reverting the transaction when an
201  * operation overflows.
202  *
203  * Using this library instead of the unchecked operations eliminates an entire
204  * class of bugs, so it's recommended to use it always.
205  */
206 library SafeMath {
207     /**
208      * @dev Returns the addition of two unsigned integers, reverting on
209      * overflow.
210      *
211      * Counterpart to Solidity's `+` operator.
212      *
213      * Requirements:
214      * - Addition cannot overflow.
215      */
216     function add(uint256 a, uint256 b) internal pure returns (uint256) {
217         uint256 c = a + b;
218         require(c >= a, "SafeMath: addition overflow");
219 
220         return c;
221     }
222 
223     /**
224      * @dev Returns the subtraction of two unsigned integers, reverting on
225      * overflow (when the result is negative).
226      *
227      * Counterpart to Solidity's `-` operator.
228      *
229      * Requirements:
230      * - Subtraction cannot overflow.
231      */
232     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
233         return sub(a, b, "SafeMath: subtraction overflow");
234     }
235 
236     /**
237      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
238      * overflow (when the result is negative).
239      *
240      * Counterpart to Solidity's `-` operator.
241      *
242      * Requirements:
243      * - Subtraction cannot overflow.
244      *
245      * _Available since v2.4.0._
246      */
247     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
248         require(b <= a, errorMessage);
249         uint256 c = a - b;
250 
251         return c;
252     }
253 
254     /**
255      * @dev Returns the multiplication of two unsigned integers, reverting on
256      * overflow.
257      *
258      * Counterpart to Solidity's `*` operator.
259      *
260      * Requirements:
261      * - Multiplication cannot overflow.
262      */
263     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
264         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
265         // benefit is lost if 'b' is also tested.
266         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
267         if (a == 0) {
268             return 0;
269         }
270 
271         uint256 c = a * b;
272         require(c / a == b, "SafeMath: multiplication overflow");
273 
274         return c;
275     }
276 
277     /**
278      * @dev Returns the integer division of two unsigned integers. Reverts on
279      * division by zero. The result is rounded towards zero.
280      *
281      * Counterpart to Solidity's `/` operator. Note: this function uses a
282      * `revert` opcode (which leaves remaining gas untouched) while Solidity
283      * uses an invalid opcode to revert (consuming all remaining gas).
284      *
285      * Requirements:
286      * - The divisor cannot be zero.
287      */
288     function div(uint256 a, uint256 b) internal pure returns (uint256) {
289         return div(a, b, "SafeMath: division by zero");
290     }
291 
292     /**
293      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
294      * division by zero. The result is rounded towards zero.
295      *
296      * Counterpart to Solidity's `/` operator. Note: this function uses a
297      * `revert` opcode (which leaves remaining gas untouched) while Solidity
298      * uses an invalid opcode to revert (consuming all remaining gas).
299      *
300      * Requirements:
301      * - The divisor cannot be zero.
302      *
303      * _Available since v2.4.0._
304      */
305     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
306         // Solidity only automatically asserts when dividing by 0
307         require(b > 0, errorMessage);
308         uint256 c = a / b;
309         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
310 
311         return c;
312     }
313 
314     /**
315      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
316      * Reverts when dividing by zero.
317      *
318      * Counterpart to Solidity's `%` operator. This function uses a `revert`
319      * opcode (which leaves remaining gas untouched) while Solidity uses an
320      * invalid opcode to revert (consuming all remaining gas).
321      *
322      * Requirements:
323      * - The divisor cannot be zero.
324      */
325     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
326         return mod(a, b, "SafeMath: modulo by zero");
327     }
328 
329     /**
330      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
331      * Reverts with custom message when dividing by zero.
332      *
333      * Counterpart to Solidity's `%` operator. This function uses a `revert`
334      * opcode (which leaves remaining gas untouched) while Solidity uses an
335      * invalid opcode to revert (consuming all remaining gas).
336      *
337      * Requirements:
338      * - The divisor cannot be zero.
339      *
340      * _Available since v2.4.0._
341      */
342     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
343         require(b != 0, errorMessage);
344         return a % b;
345     }
346 }
347 
348 // File: contracts/Staking.sol
349 
350 //SPDX-License-Identifier: MIT
351 pragma solidity 0.5.4;
352 
353 
354 
355 
356 contract Staking is Ownable {
357     using SafeMath for uint256;
358 
359     IERC20 public rewardToken;
360     IERC20 public stakingToken;
361 
362     uint256 public lastUpdateTime;
363     uint256 public rewardPerTokenStored;
364     uint256 public rewardPerSecond;
365     uint256 public distributionFinish;
366     uint256 public rewardsDuration;
367 
368     mapping(address => uint256) public rewards;
369     mapping(address => uint256) public balances;
370     mapping(address => uint256) public userRewardPerTokenPaid;
371 
372     uint256 public totalBalance;
373 
374     event RewardAdded(uint256 amount);
375     event RewardsDurationUpdated(uint256 duration);
376     event Stake(address indexed user, uint256 amount);
377     event Unstake(address indexed user, uint256 amount);
378     event RewardPaid(address indexed user, uint256 amount);
379 
380     constructor(
381         address _stakingToken,
382         address _rewardToken,
383         uint256 _rewardsDuration
384     ) public {
385         stakingToken = IERC20(_stakingToken);
386         rewardToken = IERC20(_rewardToken);
387         setRewardsDuration(_rewardsDuration);
388     }
389 
390     function stake(uint256 amount) external updateReward(msg.sender) {
391         address user = msg.sender;
392 
393         _stake(user, amount);
394         stakingToken.transferFrom(user, address(this), amount);
395     }
396 
397     function unstake(uint256 amount) external updateReward(msg.sender) {
398         address user = msg.sender;
399 
400         _unstake(user, amount);
401         stakingToken.transfer(user, amount);
402     }
403 
404     function getReward() external updateReward(msg.sender) {
405         address user = msg.sender;
406 
407         uint256 reward = _getReward(user);
408         rewardToken.transfer(user, reward);
409     }
410 
411     function reinvest() external updateReward(msg.sender) {
412         require(stakingToken == rewardToken, "Reinvest unavailable");
413         address user = msg.sender;
414 
415         uint256 reward = _getReward(user);
416         _stake(user, reward);
417     }
418 
419     function exit() external updateReward(msg.sender) {
420         address user = msg.sender;
421 
422         uint256 userBalance = balances[user];
423         _unstake(user, userBalance);
424         stakingToken.transfer(user, userBalance);
425 
426         uint256 reward = _getReward(user);
427         rewardToken.transfer(user, reward);
428     }
429 
430     function addReward(uint256 amount) external onlyOwner updateReward(address(0)) {
431         if (block.timestamp >= distributionFinish) {
432             rewardPerSecond = amount.div(rewardsDuration);
433         } else {
434             uint256 remaining = distributionFinish.sub(block.timestamp);
435             uint256 leftover = remaining.mul(rewardPerSecond);
436             rewardPerSecond = leftover.add(amount).div(rewardsDuration);
437         }
438 
439         // Ensure the provided reward amount is not more than the balance in the contract.
440         // This keeps the reward rate in the right range, preventing overflows due to
441         // very high values of rewardRate in the earned and rewardsPerToken functions;
442         // Reward + leftover must be less than 2^256 / 10^18 to avoid overflow.
443         uint256 balance;
444         if (rewardToken == stakingToken) {
445             balance = rewardToken.balanceOf(address(this)).sub(totalBalance);
446         } else {
447             balance = rewardToken.balanceOf(address(this));
448         }
449 
450         require(rewardPerSecond <= balance.div(rewardsDuration), "Provided reward too high");
451 
452         lastUpdateTime = block.timestamp;
453         distributionFinish = block.timestamp.add(rewardsDuration);
454 
455         emit RewardAdded(amount);
456     }
457 
458     function setRewardsDuration(uint256 _rewardsDuration) public onlyOwner {
459         require(block.timestamp > distributionFinish, "Previous distribution period NOT finished");
460         require(_rewardsDuration > 0, "Invalid duration");
461         rewardsDuration = _rewardsDuration;
462 
463         emit RewardsDurationUpdated(_rewardsDuration);
464     }
465 
466     function lastTimeDistributionActive() public view returns (uint256) {
467         return block.timestamp < distributionFinish ? block.timestamp : distributionFinish;
468     }
469 
470     /**
471      * In case all stakers are gone, reward per token is 0
472      * Otherwise we add:
473      * last (can be current) period of distribution * reward per second -> reward generated in the last between updates period
474      * divided by total staked balance
475      * to the current value of reward per token stored
476      */
477     function rewardPerToken() public view returns (uint256) {
478         if (totalBalance == 0) {
479             return rewardPerTokenStored;
480         }
481 
482         return
483             rewardPerTokenStored.add(
484                 lastTimeDistributionActive().sub(lastUpdateTime).mul(rewardPerSecond).mul(1e18).div(totalBalance)
485             );
486     }
487 
488     /**
489      * User stake balance is multiplied by
490      * reward per token minus the paid reward per token.
491      * Total reward is added to the value described above.
492      *
493      * This way we can calculate the reward earned by the user from his wast interaction until now.
494      */
495     function earned(address user) public view returns (uint256) {
496         return balances[user].mul(rewardPerToken().sub(userRewardPerTokenPaid[user])).div(1e18).add(rewards[user]);
497     }
498 
499     function _stake(address user, uint256 amount) private {
500         require(amount > 0, "Amount smaller than one");
501 
502         totalBalance = totalBalance.add(amount);
503         balances[user] = balances[user].add(amount);
504 
505         emit Stake(user, amount);
506     }
507 
508     function _unstake(address user, uint256 amount) private {
509         require(amount > 0, "Amount smaller than one");
510 
511         totalBalance = totalBalance.sub(amount);
512         balances[user] = balances[user].sub(amount);
513 
514         emit Unstake(user, amount);
515     }
516 
517     function _getReward(address user) private returns (uint256) {
518         uint256 reward = rewards[user];
519         require(reward > 0, "No reward");
520 
521         rewards[user] = 0;
522 
523         emit RewardPaid(user, reward);
524 
525         return reward;
526     }
527 
528     modifier updateReward(address user) {
529         rewardPerTokenStored = rewardPerToken();
530         lastUpdateTime = lastTimeDistributionActive();
531         if (user != address(0)) {
532             rewards[user] = earned(user);
533             userRewardPerTokenPaid[user] = rewardPerTokenStored;
534         }
535         _;
536     }
537 }
538 
539 // File: contracts/MirrorStaking.sol
540 
541 //SPDX-License-Identifier: MIT
542 pragma solidity 0.5.4;
543 
544 
545 contract MirrorStaking is Staking {
546     address public rewardsDistributor;
547 
548     constructor(
549         address _stakingToken,
550         address _rewardToken,
551         uint256 _rewardsDuration,
552         address _rewardsDistributor
553     ) public Staking(_stakingToken, _rewardToken, _rewardsDuration) {
554         rewardsDistributor = _rewardsDistributor;
555     }
556 
557     function addReward(uint256 amount) external onlyDistributor updateReward(address(0)) {
558         if (block.timestamp >= distributionFinish) {
559             rewardPerSecond = amount.div(rewardsDuration);
560         } else {
561             uint256 remaining = distributionFinish.sub(block.timestamp);
562             uint256 leftover = remaining.mul(rewardPerSecond);
563             rewardPerSecond = leftover.add(amount).div(rewardsDuration);
564         }
565 
566         // Ensure the provided reward amount is not more than the balance in the contract.
567         // This keeps the reward rate in the right range, preventing overflows due to
568         // very high values of rewardRate in the earned and rewardsPerToken functions;
569         // Reward + leftover must be less than 2^256 / 10^18 to avoid overflow.
570         uint256 balance;
571         if (rewardToken == stakingToken) {
572             balance = rewardToken.balanceOf(address(this)).sub(totalBalance);
573         } else {
574             balance = rewardToken.balanceOf(address(this));
575         }
576 
577         require(rewardPerSecond <= balance.div(rewardsDuration), "Provided reward too high");
578 
579         lastUpdateTime = block.timestamp;
580         distributionFinish = block.timestamp.add(rewardsDuration);
581 
582         emit RewardAdded(amount);
583     }
584 
585     function setRewardsDistributor(address _rewardsDistributor) external onlyOwner {
586         rewardsDistributor = _rewardsDistributor;
587     }
588 
589     modifier onlyDistributor() {
590         require(msg.sender == rewardsDistributor, "Not distributor");
591         _;
592     }
593 }