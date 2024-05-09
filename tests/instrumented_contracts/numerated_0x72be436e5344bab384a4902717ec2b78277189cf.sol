1 pragma solidity 0.5.17;
2 
3 
4 library Address {
5     /**
6      * @dev Returns true if `account` is a contract.
7      *
8      * This test is non-exhaustive, and there may be false-negatives: during the
9      * execution of a contract's constructor, its address will be reported as
10      * not containing a contract.
11      *
12      * > It is unsafe to assume that an address for which this function returns
13      * false is an externally-owned account (EOA) and not a contract.
14      */
15     function isContract(address account) internal view returns (bool) {
16         // This method relies in extcodesize, which returns 0 for contracts in
17         // construction, since the code is only stored at the end of the
18         // constructor execution.
19 
20         uint256 size;
21         // solhint-disable-next-line no-inline-assembly
22         assembly { size := extcodesize(account) }
23         return size > 0;
24     }
25 }
26 
27 interface IERC20 {
28     /**
29      * @dev Returns the amount of tokens in existence.
30      */
31     function totalSupply() external view returns (uint256);
32 
33     /**
34      * @dev Returns the amount of tokens owned by `account`.
35      */
36     function balanceOf(address account) external view returns (uint256);
37 
38     /**
39      * @dev Moves `amount` tokens from the caller's account to `recipient`.
40      *
41      * Returns a boolean value indicating whether the operation succeeded.
42      *
43      * Emits a `Transfer` event.
44      */
45     function transfer(address recipient, uint256 amount) external returns (bool);
46 
47     /**
48      * @dev Returns the remaining number of tokens that `spender` will be
49      * allowed to spend on behalf of `owner` through `transferFrom`. This is
50      * zero by default.
51      *
52      * This value changes when `approve` or `transferFrom` are called.
53      */
54     function allowance(address owner, address spender) external view returns (uint256);
55 
56     /**
57      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
58      *
59      * Returns a boolean value indicating whether the operation succeeded.
60      *
61      * > Beware that changing an allowance with this method brings the risk
62      * that someone may use both the old and the new allowance by unfortunate
63      * transaction ordering. One possible solution to mitigate this race
64      * condition is to first reduce the spender's allowance to 0 and set the
65      * desired value afterwards:
66      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
67      *
68      * Emits an `Approval` event.
69      */
70     function approve(address spender, uint256 amount) external returns (bool);
71 
72     /**
73      * @dev Moves `amount` tokens from `sender` to `recipient` using the
74      * allowance mechanism. `amount` is then deducted from the caller's
75      * allowance.
76      *
77      * Returns a boolean value indicating whether the operation succeeded.
78      *
79      * Emits a `Transfer` event.
80      */
81     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
82 
83     /**
84      * @dev Emitted when `value` tokens are moved from one account (`from`) to
85      * another (`to`).
86      *
87      * Note that `value` may be zero.
88      */
89     event Transfer(address indexed from, address indexed to, uint256 value);
90 
91     /**
92      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
93      * a call to `approve`. `value` is the new allowance.
94      */
95     event Approval(address indexed owner, address indexed spender, uint256 value);
96 }
97 
98 
99 library Math {
100     /**
101      * @dev Returns the largest of two numbers.
102      */
103     function max(uint256 a, uint256 b) internal pure returns (uint256) {
104         return a >= b ? a : b;
105     }
106 
107     /**
108      * @dev Returns the smallest of two numbers.
109      */
110     function min(uint256 a, uint256 b) internal pure returns (uint256) {
111         return a < b ? a : b;
112     }
113 
114     /**
115      * @dev Returns the average of two numbers. The result is rounded towards
116      * zero.
117      */
118     function average(uint256 a, uint256 b) internal pure returns (uint256) {
119         // (a + b) / 2 can overflow, so we distribute
120         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
121     }
122 }
123 
124 contract Owned {
125     address public owner;
126     address public nominatedOwner;
127 
128     constructor(address _owner) public {
129         require(_owner != address(0), "Owner address cannot be 0");
130         owner = _owner;
131         emit OwnerChanged(address(0), _owner);
132     }
133 
134     function nominateNewOwner(address _owner) external onlyOwner {
135         nominatedOwner = _owner;
136         emit OwnerNominated(_owner);
137     }
138 
139     function acceptOwnership() external {
140         require(msg.sender == nominatedOwner, "You must be nominated before you can accept ownership");
141         emit OwnerChanged(owner, nominatedOwner);
142         owner = nominatedOwner;
143         nominatedOwner = address(0);
144     }
145 
146     modifier onlyOwner {
147         _onlyOwner();
148         _;
149     }
150 
151     function _onlyOwner() private view {
152         require(msg.sender == owner, "Only the contract owner may perform this action");
153     }
154 
155     event OwnerNominated(address newOwner);
156     event OwnerChanged(address oldOwner, address newOwner);
157 }
158 
159 contract Pausable is Owned {
160     uint public lastPauseTime;
161     bool public paused;
162 
163     constructor() internal {
164         // This contract is abstract, and thus cannot be instantiated directly
165         require(owner != address(0), "Owner must be set");
166         // Paused will be false, and lastPauseTime will be 0 upon initialisation
167     }
168 
169     /**
170      * @notice Change the paused state of the contract
171      * @dev Only the contract owner may call this.
172      */
173     function setPaused(bool _paused) external onlyOwner {
174         // Ensure we're actually changing the state before we do anything
175         if (_paused == paused) {
176             return;
177         }
178 
179         // Set our paused state.
180         paused = _paused;
181 
182         // If applicable, set the last pause time.
183         if (paused) {
184             lastPauseTime = now;
185         }
186 
187         // Let everyone know that our pause state has changed.
188         emit PauseChanged(paused);
189     }
190 
191     event PauseChanged(bool isPaused);
192 
193     modifier notPaused {
194         require(!paused, "This action cannot be performed while the contract is paused");
195         _;
196     }
197 }
198 
199 contract ReentrancyGuard {
200     /// @dev counter to allow mutex lock with only one SSTORE operation
201     uint256 private _guardCounter;
202 
203     constructor () internal {
204         // The counter starts at one to prevent changing it from zero to a non-zero
205         // value, which is a more expensive operation.
206         _guardCounter = 1;
207     }
208 
209     /**
210      * @dev Prevents a contract from calling itself, directly or indirectly.
211      * Calling a `nonReentrant` function from another `nonReentrant`
212      * function is not supported. It is possible to prevent this from happening
213      * by making the `nonReentrant` function external, and make it call a
214      * `private` function that does the actual work.
215      */
216     modifier nonReentrant() {
217         _guardCounter += 1;
218         uint256 localCounter = _guardCounter;
219         _;
220         require(localCounter == _guardCounter, "ReentrancyGuard: reentrant call");
221     }
222 }
223 
224 
225 library SafeERC20 {
226     using SafeMath for uint256;
227     using Address for address;
228 
229     function safeTransfer(IERC20 token, address to, uint256 value) internal {
230         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
231     }
232 
233     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
234         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
235     }
236 
237     function safeApprove(IERC20 token, address spender, uint256 value) internal {
238         // safeApprove should only be called when setting an initial allowance,
239         // or when resetting it to zero. To increase and decrease it, use
240         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
241         // solhint-disable-next-line max-line-length
242         require((value == 0) || (token.allowance(address(this), spender) == 0),
243             "SafeERC20: approve from non-zero to non-zero allowance"
244         );
245         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
246     }
247 
248     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
249         uint256 newAllowance = token.allowance(address(this), spender).add(value);
250         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
251     }
252 
253     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
254         uint256 newAllowance = token.allowance(address(this), spender).sub(value);
255         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
256     }
257 
258     /**
259      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
260      * on the return value: the return value is optional (but if data is returned, it must not be false).
261      * @param token The token targeted by the call.
262      * @param data The call data (encoded using abi.encode or one of its variants).
263      */
264     function callOptionalReturn(IERC20 token, bytes memory data) private {
265         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
266         // we're implementing it ourselves.
267 
268         // A Solidity high level call has three parts:
269         //  1. The target address is checked to verify it contains contract code
270         //  2. The call itself is made, and success asserted
271         //  3. The return value is decoded, which in turn checks the size of the returned data.
272         // solhint-disable-next-line max-line-length
273         require(address(token).isContract(), "SafeERC20: call to non-contract");
274 
275         // solhint-disable-next-line avoid-low-level-calls
276         (bool success, bytes memory returndata) = address(token).call(data);
277         require(success, "SafeERC20: low-level call failed");
278 
279         if (returndata.length > 0) { // Return data is optional
280             // solhint-disable-next-line max-line-length
281             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
282         }
283     }
284 }
285 
286 library SafeMath {
287     /**
288      * @dev Returns the addition of two unsigned integers, reverting on
289      * overflow.
290      *
291      * Counterpart to Solidity's `+` operator.
292      *
293      * Requirements:
294      * - Addition cannot overflow.
295      */
296     function add(uint256 a, uint256 b) internal pure returns (uint256) {
297         uint256 c = a + b;
298         require(c >= a, "SafeMath: addition overflow");
299 
300         return c;
301     }
302 
303     /**
304      * @dev Returns the subtraction of two unsigned integers, reverting on
305      * overflow (when the result is negative).
306      *
307      * Counterpart to Solidity's `-` operator.
308      *
309      * Requirements:
310      * - Subtraction cannot overflow.
311      */
312     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
313         require(b <= a, "SafeMath: subtraction overflow");
314         uint256 c = a - b;
315 
316         return c;
317     }
318 
319     /**
320      * @dev Returns the multiplication of two unsigned integers, reverting on
321      * overflow.
322      *
323      * Counterpart to Solidity's `*` operator.
324      *
325      * Requirements:
326      * - Multiplication cannot overflow.
327      */
328     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
329         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
330         // benefit is lost if 'b' is also tested.
331         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
332         if (a == 0) {
333             return 0;
334         }
335 
336         uint256 c = a * b;
337         require(c / a == b, "SafeMath: multiplication overflow");
338 
339         return c;
340     }
341 
342     /**
343      * @dev Returns the integer division of two unsigned integers. Reverts on
344      * division by zero. The result is rounded towards zero.
345      *
346      * Counterpart to Solidity's `/` operator. Note: this function uses a
347      * `revert` opcode (which leaves remaining gas untouched) while Solidity
348      * uses an invalid opcode to revert (consuming all remaining gas).
349      *
350      * Requirements:
351      * - The divisor cannot be zero.
352      */
353     function div(uint256 a, uint256 b) internal pure returns (uint256) {
354         // Solidity only automatically asserts when dividing by 0
355         require(b > 0, "SafeMath: division by zero");
356         uint256 c = a / b;
357         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
358 
359         return c;
360     }
361 
362     /**
363      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
364      * Reverts when dividing by zero.
365      *
366      * Counterpart to Solidity's `%` operator. This function uses a `revert`
367      * opcode (which leaves remaining gas untouched) while Solidity uses an
368      * invalid opcode to revert (consuming all remaining gas).
369      *
370      * Requirements:
371      * - The divisor cannot be zero.
372      */
373     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
374         require(b != 0, "SafeMath: modulo by zero");
375         return a % b;
376     }
377 }
378 
379 contract MultiRewards is ReentrancyGuard, Pausable {
380     using SafeMath for uint256;
381     using SafeERC20 for IERC20;
382 
383     /* ========== STATE VARIABLES ========== */
384 
385     struct Reward {
386         address rewardsDistributor;
387         uint256 rewardsDuration;
388         uint256 periodFinish;
389         uint256 rewardRate;
390         uint256 lastUpdateTime;
391         uint256 rewardPerTokenStored;
392     }
393     IERC20 public stakingToken;
394     mapping(address => Reward) public rewardData;
395     address[] public rewardTokens;
396 
397     struct RewardRate {
398         uint256 startingTime;      // inclusive of this time
399 	    uint256 ratePerToken;	   // reward per second for each token from startingTime to next (exclusive).  last one applicable to lastTimeRewardApplicable
400     }
401     // reward token -> RewardRate[]
402     mapping(address => RewardRate[]) public rewardRatePerToken;
403 
404     // user -> reward token -> amount
405     mapping(address => mapping(address => uint256)) public userRewardPerTokenPaid;
406     mapping(address => mapping(address => uint256)) public rewards;
407 
408     uint256 private _totalSupply;
409     mapping(address => uint256) private _balances;
410 
411     // handling lockup for individual stake
412     uint256 public lockDuration;
413     // user -> reward token -> amount
414     mapping(address => mapping(address => uint256)) public claimedRewards;
415 
416     struct Stake {
417         uint256 stakingMaturity;
418 	    uint256 remainingBalance;	
419     }    
420     // user -> stakes [stake index]
421     mapping(address => Stake[]) public userStakes;
422 
423     struct StakeBalance {
424         uint256 startingTime;    // inclusive of this time
425 	    uint256 sBalance;	     // balance from startingTime to next (exclusive of next)    
426     }
427     // user -> StakeBalance[]
428     mapping(address => StakeBalance[]) public userStakeBalance;
429 
430     /* ========== CONSTRUCTOR ========== */
431 
432     constructor(
433         address _owner,
434         address _stakingToken,
435         uint256 _lockDuration
436     ) public Owned(_owner) {
437         stakingToken = IERC20(_stakingToken);
438         lockDuration = _lockDuration;
439     }
440 
441     function addReward(
442         address _rewardsToken,
443         address _rewardsDistributor,
444         uint256 _rewardsDuration
445     )
446         public
447         onlyOwner
448     {
449         require(rewardData[_rewardsToken].rewardsDuration == 0, "reward data of token has been added");
450         require(_rewardsToken != address(0) && _rewardsDistributor != address(0), "Zero address not allowed");
451         require(_rewardsDuration > 0, "Reward duration must be non-zero");
452         rewardTokens.push(_rewardsToken);
453         rewardData[_rewardsToken].rewardsDistributor = _rewardsDistributor;
454         rewardData[_rewardsToken].rewardsDuration = _rewardsDuration;
455         emit RewardsDistributorUpdated(_rewardsToken, _rewardsDistributor);
456         emit RewardsDurationUpdated(_rewardsToken, _rewardsDuration);
457     }
458 
459     /* ========== VIEWS ========== */
460 
461     function totalSupply() external view returns (uint256) {
462         return _totalSupply;
463     }
464 
465     function balanceOf(address account) external view returns (uint256) {
466         return _balances[account];
467     }
468 
469     function lastTimeRewardApplicable(address _rewardsToken) public view returns (uint256) {
470         return Math.min(block.timestamp, rewardData[_rewardsToken].periodFinish);
471     }
472 
473     function rewardPerToken(address _rewardsToken) public view returns (uint256) {
474         if (_totalSupply == 0) {
475             return rewardData[_rewardsToken].rewardPerTokenStored;
476         }
477         return
478             rewardData[_rewardsToken].rewardPerTokenStored.add(
479                 lastTimeRewardApplicable(_rewardsToken).sub(rewardData[_rewardsToken].lastUpdateTime).mul(rewardData[_rewardsToken].rewardRate).mul(1e18).div(_totalSupply)
480             );
481     }
482 
483     function earned(address account, address _rewardsToken) public view returns (uint256) {
484         return _balances[account].mul(rewardPerToken(_rewardsToken).sub(userRewardPerTokenPaid[account][_rewardsToken])).div(1e18).add(rewards[account][_rewardsToken]);
485     }
486     
487     function earnedLifetime(address account, address _rewardsToken) public view returns (uint256) {
488         uint256 notClaimed = earned(account, _rewardsToken);
489         return notClaimed.add(claimedRewards[account][_rewardsToken]);
490     }    
491 
492     function getRewardForDuration(address _rewardsToken) external view returns (uint256) {
493         return rewardData[_rewardsToken].rewardRate.mul(rewardData[_rewardsToken].rewardsDuration);
494     }
495     
496     function unlockedStakeAtTime(address account, uint256 thisTime, uint256 stakeI) public view returns (uint256) {
497 	    if (userStakes[account][stakeI].remainingBalance > 0 && 
498 	            (block.timestamp >= rewardData[rewardTokens[0]].periodFinish || userStakes[account][stakeI].stakingMaturity <= thisTime ) )		
499 	        return userStakes[account][stakeI].remainingBalance;
500         else
501             return 0;
502     }
503 
504     function unlockedStake(address account) public view returns (uint256) {
505 	    uint256 actualAmount = 0;
506 	    uint256 thisTest = lastTimeRewardApplicable(rewardTokens[0]);
507         for (uint i; i < userStakes[account].length; i++) {
508 		    actualAmount = actualAmount.add(unlockedStakeAtTime(account, thisTest, i));
509 	    }
510 	    require(actualAmount <= _balances[account], "internal 0");
511         return actualAmount;
512     }
513 
514     // returns the index in rewardRatePerToken s.t. time[index]<= timeT and time[sss+1]>timeT.
515     // corner cases:
516     //      if timeT >= time[length-1], return length-1
517     //      if timeT <= time[0], return 0
518     function indexForRate(address _rewardsToken, uint256 timeT) public view returns (uint256) {
519         uint256 length = rewardRatePerToken[_rewardsToken].length;
520         uint256 sss = length-1;
521 
522         if (length > 1) {    
523             for (uint256 j=1; j < length; j++) {
524                 if (timeT < rewardRatePerToken[_rewardsToken][j].startingTime) {  // rewardRatePerToken[account][j].startingTime is the ending time for j-1 period
525                     sss = j.sub(1);
526                     break;
527                 }          
528             }
529         } else if (length == 1)
530             sss = 0;
531         else
532             sss = 1;   // length == 0, return length+1, invalid
533 
534         return sss;
535     }
536 
537     // returns the index in userStakeBalance s.t. time[index]<= timeT and time[sss+1]>timeT.
538     // corner cases:
539     //      if timeT >= time[length-1], return length-1
540     //      if timeT <= time[0], return 0
541     function indexForBalance(address account, uint256 timeT) public view returns (uint256) {
542         uint256 length = userStakeBalance[account].length;
543         uint256 sss = length-1;
544 
545         if (length > 1) {    
546             for (uint256 j=1; j < length; j++) {
547                 if (timeT < userStakeBalance[account][j].startingTime) {  // userStakeBalance[account][j].startingTime is the ending time for j-1 period
548                     sss = j.sub(1);
549                     break;
550                 }          
551             }
552         } else if (length == 1)
553             sss = 0;
554         else
555             sss = 1;   // length == 0, return length+1, invalid
556 
557         return sss;
558     }
559 
560     function rewardForNotionalPeriod(uint256 notional, uint256 rewardRate, uint256 start, uint256 end) public pure returns (uint256) {
561         require(start <= end, "time 1");
562         uint256 reward = notional.mul(rewardRate).div(1e18).mul(end.sub(start));
563         return reward;
564     }   
565 
566     // returns accumulated rewards from time start to end for account on _rewardsToken
567     // start is restricted to on or after the first starting time at the earliest for the account
568     // end is restricted to be the earliest time of 1) end  2) maturity 3) the current block time
569     // so no reward is generated after maturity
570     // the ratePerToken across the maturity has to be handled carefully
571     function rewardForTimePeriod(address account, address _rewardsToken, uint256 start, uint256 end) public view returns (uint256) {
572         if (userStakeBalance[account].length==0)
573             return 0;
574         if (start >= lastTimeRewardApplicable(_rewardsToken))
575             return 0;  // no reward after the applicable time
576         start = Math.max(start, userStakeBalance[account][0].startingTime);
577         if (end > lastTimeRewardApplicable(_rewardsToken))
578             end = lastTimeRewardApplicable(_rewardsToken);
579         require(start < end, "time 0");      
580 
581         uint256 balIndex = indexForBalance(account, start); 
582         require(balIndex < userStakeBalance[account].length, "balance idx 0");  
583 
584         uint256 timeIndex = indexForRate(_rewardsToken, start);
585         require(timeIndex < rewardRatePerToken[_rewardsToken].length, "rate idx 0");       
586 
587         uint256 accReward = 0;    
588         if (timeIndex == rewardRatePerToken[_rewardsToken].length -1) {
589             accReward = rewardForNotionalPeriod(userStakeBalance[account][balIndex].sBalance, rewardRatePerToken[_rewardsToken][timeIndex].ratePerToken, start, end );
590         } else {
591             // case for timeIndex < length-1, so myStart < time[length-1]
592 
593             // solving the stack too deep problem: separating the first period here  
594             {
595                 uint256 endT = Math.min(end, rewardRatePerToken[_rewardsToken][timeIndex+1].startingTime);
596                 accReward = rewardForNotionalPeriod(userStakeBalance[account][balIndex].sBalance, rewardRatePerToken[_rewardsToken][timeIndex].ratePerToken, start, endT);
597                 timeIndex = timeIndex.add(1);  // done the current time period, moving to the next one
598             }
599 
600             // integrating intermediate steps.  
601             // each step integrating from rewardRatePerToken[_rewardsToken][iii].startingTime to rewardRatePerToken[_rewardsToken][iii+1].startingTime
602             // so the loop can only end at length-1
603             for ( uint256 iii = timeIndex; iii< rewardRatePerToken[_rewardsToken].length.sub(1); iii++ ) {
604                 if (end <= rewardRatePerToken[_rewardsToken][iii].startingTime)
605                     break;
606                 // going to the right balIndex if necessary.  the very last one does not have restriction of time
607                 if (balIndex < userStakeBalance[account].length.sub(1)) {
608                     // userStakeBalance[account][balIndex.add(1)].startingTime is the end time for balIndex
609                     // rewardRatePerToken[_rewardsToken][iii].startingTime is the starting time for iii
610                     if (userStakeBalance[account][balIndex.add(1)].startingTime <= rewardRatePerToken[_rewardsToken][iii].startingTime)
611                         balIndex = balIndex.add(1);
612                 }
613                 if (end <= rewardRatePerToken[_rewardsToken][iii+1].startingTime) {
614                     accReward = accReward.add( rewardForNotionalPeriod(userStakeBalance[account][balIndex].sBalance, rewardRatePerToken[_rewardsToken][iii].ratePerToken, rewardRatePerToken[_rewardsToken][iii].startingTime, end ));
615                     break;
616                 } else
617                     accReward = accReward.add( rewardForNotionalPeriod(userStakeBalance[account][balIndex].sBalance, rewardRatePerToken[_rewardsToken][iii].ratePerToken, rewardRatePerToken[_rewardsToken][iii].startingTime, rewardRatePerToken[_rewardsToken][iii+1].startingTime )); 
618             }
619 
620             // handling the last time period, timeIndex == length-1.  the rate of the last one applies for [lastPeriodTime, maturity)
621             // note for current case, myStart < time[length-1]
622             {
623                 uint256 lastIdx = rewardRatePerToken[_rewardsToken].length.sub(1);
624                 uint256 lastPeriodTime = rewardRatePerToken[_rewardsToken][lastIdx].startingTime;
625                 if (end > lastPeriodTime) {
626                     // userStakeBalance[account][balIndex.add(1)].startingTime is the end time for balIndex
627                     // lastPeriodTime is the starting time for the period beyond the end of time index
628                     if (balIndex < userStakeBalance[account].length.sub(1)) {
629                         if (userStakeBalance[account][balIndex.add(1)].startingTime <= lastPeriodTime)
630                             balIndex = balIndex.add(1);
631                     }    
632                     accReward = accReward.add( rewardForNotionalPeriod(userStakeBalance[account][balIndex].sBalance, rewardRatePerToken[_rewardsToken][lastIdx].ratePerToken, lastPeriodTime, end ));                       
633                 }  
634             }                       
635         }
636 
637         return accReward;
638     }      
639 
640     function checkRewardForTimePeriod(address account, address _rewardsToken) public view returns (uint256) {
641         if (userStakeBalance[account].length == 0)
642             return 0;
643         uint256 totalReward = earnedLifetime(account,  _rewardsToken);
644         uint256 rewardFromIntegration = rewardForTimePeriod( account,  _rewardsToken, userStakeBalance[account][0].startingTime, block.timestamp);
645         require(totalReward >= rewardFromIntegration, "check 0");
646         return totalReward.sub(rewardFromIntegration);
647     }  
648 
649     function rewardUnlockCutoffTime(address _rewardsToken) public view returns (uint256) {
650         return Math.min(block.timestamp.sub(lockDuration), rewardData[_rewardsToken].periodFinish);
651     }
652 
653     function unlockedReward(address account, address _rewardsToken) public view returns (uint256) {
654         uint256 sss = userStakeBalance[account].length;
655         if (sss==0)
656             return 0;
657         uint256 startT = userStakeBalance[account][0].startingTime;
658         uint256 endT = rewardUnlockCutoffTime(_rewardsToken);
659         if (endT <= startT)
660             return 0;
661         uint256 rewardUnLocked = rewardForTimePeriod( account, _rewardsToken, startT, endT);
662         rewardUnLocked = rewardUnLocked.sub(claimedRewards[account][_rewardsToken]);
663         uint256 earnedAmount = earned( account, _rewardsToken);
664         rewardUnLocked = Math.min(rewardUnLocked, earnedAmount);    // to eusure no possibility of overpaying
665         return rewardUnLocked;
666     }      
667     
668     function distributorRemainingReward(address _rewardsToken) public view returns (uint256) {
669         return rewards[rewardData[_rewardsToken].rewardsDistributor][_rewardsToken];
670     }
671     
672     function userInfoByIndexRange(address account, uint256 _start, uint256 _stop) external view returns (uint256[2][] memory)  {
673         uint256 _allStakeLength = userStakes[account].length;
674         if (_stop > _allStakeLength) {
675             _stop = _allStakeLength;
676         }
677         require(_stop >= _start, "start cannot be higher than stop");
678         uint256 _qty = _stop - _start;
679         uint256[2][] memory result = new uint256[2][](_qty);
680         for (uint i = 0; i < _qty; i++) {
681             result[i][0] = userStakes[account][_start + i].stakingMaturity;
682             result[i][1] = userStakes[account][_start + i].remainingBalance;         
683         }
684         return result;
685     }    
686 
687     /* ========== MUTATIVE FUNCTIONS ========== */
688 
689     function setRewardsDistributor(address _rewardsToken, address _rewardsDistributor) external onlyOwner {
690         require(_rewardsToken != address(0) && _rewardsDistributor != address(0), "Zero address not allowed");
691         rewardData[_rewardsToken].rewardsDistributor = _rewardsDistributor;
692         emit RewardsDistributorUpdated(_rewardsToken, _rewardsDistributor);
693     }
694 
695     function stake(uint256 amount) external nonReentrant notPaused updateReward(msg.sender) {
696         require(amount > 0, "Cannot stake 0");
697         uint256 previousBalance = IERC20(stakingToken).balanceOf(address(this));
698         stakingToken.safeTransferFrom(msg.sender, address(this), amount);
699         uint256 actualAmount = IERC20(stakingToken).balanceOf(address(this)).sub(previousBalance);
700         actualAmount = Math.min(actualAmount, amount);
701         _totalSupply = _totalSupply.add(actualAmount);
702         _balances[msg.sender] = _balances[msg.sender].add(actualAmount);
703 
704         if (actualAmount > 0) {
705             userStakes[msg.sender].push(Stake(block.timestamp.add(lockDuration), actualAmount));
706 
707             {  
708                 uint256 prev = userStakeBalance[msg.sender].length;
709                 if (prev > 0 && block.timestamp == userStakeBalance[msg.sender][prev-1].startingTime)
710                     // in case the user can stake more than once within the same block.  no reward is generated within this block yet
711                     userStakeBalance[msg.sender][prev-1].sBalance = _balances[msg.sender];  
712                 else
713                     userStakeBalance[msg.sender].push(StakeBalance(block.timestamp, _balances[msg.sender]));
714             } 
715             for (uint i = 0; i < rewardTokens.length; i++) {
716                 require(block.timestamp < rewardData[rewardTokens[i]].periodFinish, "maturity 0");
717                 uint256 prev = rewardRatePerToken[rewardTokens[i]].length;
718                 uint256 reward_rate = 0;
719                 if (_totalSupply > 0 )
720                     reward_rate = rewardData[rewardTokens[i]].rewardRate.mul(1e18).div(_totalSupply);
721                 if (prev > 0 && block.timestamp == rewardRatePerToken[rewardTokens[i]][prev-1].startingTime)  // in case same block stake or withdraw
722                     rewardRatePerToken[rewardTokens[i]][prev-1].ratePerToken = reward_rate; 
723                 else          
724                     rewardRatePerToken[rewardTokens[i]].push(RewardRate(block.timestamp, reward_rate ) );   
725             }  
726         }
727 
728         emit Staked(msg.sender, actualAmount);
729     }
730 
731     function withdraw(uint256 amount) public nonReentrant notPaused updateReward(msg.sender) {
732         require(amount > 0, "Cannot withdraw 0");
733 	    uint256 askedAmount = Math.min(amount, _balances[msg.sender]);
734 	    uint256 actualAmount = 0;
735 	    uint256 thisTest = lastTimeRewardApplicable(rewardTokens[0]);
736         for (uint i; i < userStakes[msg.sender].length; i++) {
737             uint256 outAmount = unlockedStakeAtTime(msg.sender, thisTest, i);
738             if (outAmount > 0) {
739                 outAmount = Math.min(outAmount, askedAmount);
740 	   	        userStakes[msg.sender][i].remainingBalance = userStakes[msg.sender][i].remainingBalance.sub(outAmount);	   
741  	   	        askedAmount = askedAmount.sub(outAmount);
742 		        actualAmount = actualAmount.add(outAmount);
743             }
744             if (askedAmount == 0)
745         	    break;
746 	    }
747         require(actualAmount > 0 && actualAmount <= amount && actualAmount <= _balances[msg.sender], "No unlocked stake");    
748         _totalSupply = _totalSupply.sub(actualAmount);
749         _balances[msg.sender] = _balances[msg.sender].sub(actualAmount);
750 
751         {  
752             uint256 prev = userStakeBalance[msg.sender].length;
753             if (prev > 0 && block.timestamp == userStakeBalance[msg.sender][prev-1].startingTime)
754                 userStakeBalance[msg.sender][prev-1].sBalance = _balances[msg.sender];  // in case the user can withdraw more than once within the same block
755             else
756                 userStakeBalance[msg.sender].push(StakeBalance(block.timestamp, _balances[msg.sender]));
757         }
758         for (uint i = 0; i < rewardTokens.length; i++) {
759             uint256 prev = rewardRatePerToken[rewardTokens[i]].length;
760             uint256 reward_rate = 0;
761             if (_totalSupply > 0 && block.timestamp < rewardData[rewardTokens[i]].periodFinish)
762                 reward_rate = rewardData[rewardTokens[i]].rewardRate.mul(1e18).div(_totalSupply);
763             if (prev > 0 && block.timestamp == rewardRatePerToken[rewardTokens[i]][prev-1].startingTime)  // in case same block stake or withdraw
764                 rewardRatePerToken[rewardTokens[i]][prev-1].ratePerToken = reward_rate; 
765             else          
766                 rewardRatePerToken[rewardTokens[i]].push(RewardRate(block.timestamp, reward_rate ) );   
767         } 
768 
769         stakingToken.safeTransfer(msg.sender, actualAmount);
770         emit Withdrawn(msg.sender, actualAmount);
771     }
772 
773     function getReward() public nonReentrant notPaused updateReward(msg.sender) {
774         for (uint i; i < rewardTokens.length; i++) {
775             address _rewardsToken = rewardTokens[i];
776             uint256 reward = rewards[msg.sender][_rewardsToken];
777             uint256 actualAmount = unlockedReward(msg.sender, _rewardsToken);
778             actualAmount = Math.min(actualAmount, reward);
779             if (actualAmount > 0) {  // let 0 case pass so that exit and other i's work
780                 rewards[msg.sender][_rewardsToken] = rewards[msg.sender][_rewardsToken].sub(actualAmount);
781                 claimedRewards[msg.sender][_rewardsToken] = actualAmount.add(claimedRewards[msg.sender][_rewardsToken]);
782                 IERC20(_rewardsToken).safeTransfer(msg.sender, actualAmount);
783                 emit RewardPaid(msg.sender, _rewardsToken, actualAmount);
784             }
785         }
786     }
787 
788     function exit() external {
789         withdraw(_balances[msg.sender]);
790         getReward();
791     }
792 
793     /* ========== RESTRICTED FUNCTIONS ========== */
794 
795     function notifyRewardAmount(address _rewardsToken, uint256 reward) external updateReward(address(0)) {
796         require(rewardData[_rewardsToken].rewardsDistributor == msg.sender);
797         // handle the transfer of reward tokens via `transferFrom` to reduce the number
798         // of transactions required and ensure correctness of the reward amount
799         IERC20(_rewardsToken).safeTransferFrom(msg.sender, address(this), reward);
800 
801         if (block.timestamp >= rewardData[_rewardsToken].periodFinish) {
802             rewardData[_rewardsToken].rewardRate = reward.div(rewardData[_rewardsToken].rewardsDuration);
803         } else {
804             uint256 remaining = rewardData[_rewardsToken].periodFinish.sub(block.timestamp);
805             uint256 leftover = remaining.mul(rewardData[_rewardsToken].rewardRate);
806             rewardData[_rewardsToken].rewardRate = reward.add(leftover).div(rewardData[_rewardsToken].rewardsDuration);
807         }
808         rewardData[_rewardsToken].lastUpdateTime = block.timestamp;
809         rewardData[_rewardsToken].periodFinish = block.timestamp.add(rewardData[_rewardsToken].rewardsDuration);
810         emit RewardAdded(reward);
811     }
812 
813     function collectRemainingReward(address _rewardsToken) external nonReentrant updateReward(address(0)) {
814         require(rewardData[_rewardsToken].rewardsDistributor == msg.sender);
815         require(block.timestamp >= rewardData[_rewardsToken].periodFinish);
816         uint256 amount = rewards[msg.sender][_rewardsToken];
817         if (amount > 0) {
818             rewards[msg.sender][_rewardsToken] = 0;
819             IERC20(_rewardsToken).safeTransfer(msg.sender, amount);
820         }
821     }
822 
823     // Added to support recovering LP Rewards from other systems such as BAL to be distributed to holders
824     function recoverERC20(address tokenAddress, uint256 tokenAmount) external onlyOwner {
825         require(tokenAddress != address(stakingToken), "Cannot withdraw staking token");
826         require(rewardData[tokenAddress].lastUpdateTime == 0, "Cannot withdraw reward token");
827         IERC20(tokenAddress).safeTransfer(owner, tokenAmount);
828         emit Recovered(tokenAddress, tokenAmount);
829     }
830 
831     /* ========== MODIFIERS ========== */
832 
833     modifier updateReward(address account) {
834         for (uint i; i < rewardTokens.length; i++) {
835             address token = rewardTokens[i];
836             
837             if (_totalSupply == 0)
838                 rewards[rewardData[token].rewardsDistributor][token] = lastTimeRewardApplicable(token).sub(rewardData[token].lastUpdateTime).mul(rewardData[token].rewardRate).add(rewards[rewardData[token].rewardsDistributor][token]);
839             
840             rewardData[token].rewardPerTokenStored = rewardPerToken(token);
841             rewardData[token].lastUpdateTime = lastTimeRewardApplicable(token);
842             if (account != address(0)) {
843                 rewards[account][token] = earned(account, token);
844                 userRewardPerTokenPaid[account][token] = rewardData[token].rewardPerTokenStored;
845             }
846         }
847         _;
848     }
849 
850     /* ========== EVENTS ========== */
851 
852     event RewardAdded(uint256 reward);
853     event Staked(address indexed user, uint256 amount);
854     event Withdrawn(address indexed user, uint256 amount);
855     event RewardPaid(address indexed user, address indexed rewardsToken, uint256 reward);
856     event RewardsDistributorUpdated(address indexed token, address indexed newDistributor);
857     event RewardsDurationUpdated(address indexed token, uint256 newDuration);
858     event Recovered(address token, uint256 amount);
859 }