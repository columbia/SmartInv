1 pragma solidity 0.6.12;
2 
3 
4 /**
5  * @dev Interface of the ERC20 standard as defined in the EIP.
6  */
7 interface IERC20 {
8     /**
9      * @dev Returns the amount of tokens in existence.
10      */
11     function totalSupply() external view returns (uint256);
12 
13     /**
14      * @dev Returns the amount of tokens owned by `account`.
15      */
16     function balanceOf(address account) external view returns (uint256);
17 
18     /**
19      * @dev Moves `amount` tokens from the caller's account to `recipient`.
20      *
21      * Returns a boolean value indicating whether the operation succeeded.
22      *
23      * Emits a {Transfer} event.
24      */
25     function transfer(address recipient, uint256 amount) external returns (bool);
26 
27     /**
28      * @dev Returns the remaining number of tokens that `spender` will be
29      * allowed to spend on behalf of `owner` through {transferFrom}. This is
30      * zero by default.
31      *
32      * This value changes when {approve} or {transferFrom} are called.
33      */
34     function allowance(address owner, address spender) external view returns (uint256);
35 
36     /**
37      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
38      *
39      * Returns a boolean value indicating whether the operation succeeded.
40      *
41      * IMPORTANT: Beware that changing an allowance with this method brings the risk
42      * that someone may use both the old and the new allowance by unfortunate
43      * transaction ordering. One possible solution to mitigate this race
44      * condition is to first reduce the spender's allowance to 0 and set the
45      * desired value afterwards:
46      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
47      *
48      * Emits an {Approval} event.
49      */
50     function approve(address spender, uint256 amount) external returns (bool);
51 
52     /**
53      * @dev Moves `amount` tokens from `sender` to `recipient` using the
54      * allowance mechanism. `amount` is then deducted from the caller's
55      * allowance.
56      *
57      * Returns a boolean value indicating whether the operation succeeded.
58      *
59      * Emits a {Transfer} event.
60      */
61     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
62 
63     /**
64      * @dev Emitted when `value` tokens are moved from one account (`from`) to
65      * another (`to`).
66      *
67      * Note that `value` may be zero.
68      */
69     event Transfer(address indexed from, address indexed to, uint256 value);
70 
71     /**
72      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
73      * a call to {approve}. `value` is the new allowance.
74      */
75     event Approval(address indexed owner, address indexed spender, uint256 value);
76 }
77 
78 /**
79  * @dev Standard math utilities missing in the Solidity language.
80  */
81 library Math {
82     /**
83      * @dev Returns the largest of two numbers.
84      */
85     function max(uint256 a, uint256 b) internal pure returns (uint256) {
86         return a >= b ? a : b;
87     }
88 
89     /**
90      * @dev Returns the smallest of two numbers.
91      */
92     function min(uint256 a, uint256 b) internal pure returns (uint256) {
93         return a < b ? a : b;
94     }
95 
96     /**
97      * @dev Returns the average of two numbers. The result is rounded towards
98      * zero.
99      */
100     function average(uint256 a, uint256 b) internal pure returns (uint256) {
101         // (a + b) / 2 can overflow, so we distribute
102         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
103     }
104 }
105 
106 /**
107  * @dev Wrappers over Solidity's arithmetic operations with added overflow
108  * checks.
109  *
110  * Arithmetic operations in Solidity wrap on overflow. This can easily result
111  * in bugs, because programmers usually assume that an overflow raises an
112  * error, which is the standard behavior in high level programming languages.
113  * `SafeMath` restores this intuition by reverting the transaction when an
114  * operation overflows.
115  *
116  * Using this library instead of the unchecked operations eliminates an entire
117  * class of bugs, so it's recommended to use it always.
118  */
119 library SafeMath {
120     /**
121      * @dev Returns the addition of two unsigned integers, reverting on
122      * overflow.
123      *
124      * Counterpart to Solidity's `+` operator.
125      *
126      * Requirements:
127      *
128      * - Addition cannot overflow.
129      */
130     function add(uint256 a, uint256 b) internal pure returns (uint256) {
131         uint256 c = a + b;
132         require(c >= a, "SafeMath: addition overflow");
133 
134         return c;
135     }
136 
137     /**
138      * @dev Returns the subtraction of two unsigned integers, reverting on
139      * overflow (when the result is negative).
140      *
141      * Counterpart to Solidity's `-` operator.
142      *
143      * Requirements:
144      *
145      * - Subtraction cannot overflow.
146      */
147     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
148         return sub(a, b, "SafeMath: subtraction overflow");
149     }
150 
151     /**
152      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
153      * overflow (when the result is negative).
154      *
155      * Counterpart to Solidity's `-` operator.
156      *
157      * Requirements:
158      *
159      * - Subtraction cannot overflow.
160      */
161     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
162         require(b <= a, errorMessage);
163         uint256 c = a - b;
164 
165         return c;
166     }
167 
168     /**
169      * @dev Returns the multiplication of two unsigned integers, reverting on
170      * overflow.
171      *
172      * Counterpart to Solidity's `*` operator.
173      *
174      * Requirements:
175      *
176      * - Multiplication cannot overflow.
177      */
178     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
179         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
180         // benefit is lost if 'b' is also tested.
181         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
182         if (a == 0) {
183             return 0;
184         }
185 
186         uint256 c = a * b;
187         require(c / a == b, "SafeMath: multiplication overflow");
188 
189         return c;
190     }
191 
192     /**
193      * @dev Returns the integer division of two unsigned integers. Reverts on
194      * division by zero. The result is rounded towards zero.
195      *
196      * Counterpart to Solidity's `/` operator. Note: this function uses a
197      * `revert` opcode (which leaves remaining gas untouched) while Solidity
198      * uses an invalid opcode to revert (consuming all remaining gas).
199      *
200      * Requirements:
201      *
202      * - The divisor cannot be zero.
203      */
204     function div(uint256 a, uint256 b) internal pure returns (uint256) {
205         return div(a, b, "SafeMath: division by zero");
206     }
207 
208     /**
209      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
210      * division by zero. The result is rounded towards zero.
211      *
212      * Counterpart to Solidity's `/` operator. Note: this function uses a
213      * `revert` opcode (which leaves remaining gas untouched) while Solidity
214      * uses an invalid opcode to revert (consuming all remaining gas).
215      *
216      * Requirements:
217      *
218      * - The divisor cannot be zero.
219      */
220     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
221         require(b > 0, errorMessage);
222         uint256 c = a / b;
223         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
224 
225         return c;
226     }
227 
228     /**
229      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
230      * Reverts when dividing by zero.
231      *
232      * Counterpart to Solidity's `%` operator. This function uses a `revert`
233      * opcode (which leaves remaining gas untouched) while Solidity uses an
234      * invalid opcode to revert (consuming all remaining gas).
235      *
236      * Requirements:
237      *
238      * - The divisor cannot be zero.
239      */
240     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
241         return mod(a, b, "SafeMath: modulo by zero");
242     }
243 
244     /**
245      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
246      * Reverts with custom message when dividing by zero.
247      *
248      * Counterpart to Solidity's `%` operator. This function uses a `revert`
249      * opcode (which leaves remaining gas untouched) while Solidity uses an
250      * invalid opcode to revert (consuming all remaining gas).
251      *
252      * Requirements:
253      *
254      * - The divisor cannot be zero.
255      */
256     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
257         require(b != 0, errorMessage);
258         return a % b;
259     }
260 }
261 
262 /**
263  * @dev Collection of functions related to the address type
264  */
265 library Address {
266     /**
267      * @dev Returns true if `account` is a contract.
268      *
269      * [IMPORTANT]
270      * ====
271      * It is unsafe to assume that an address for which this function returns
272      * false is an externally-owned account (EOA) and not a contract.
273      *
274      * Among others, `isContract` will return false for the following
275      * types of addresses:
276      *
277      *  - an externally-owned account
278      *  - a contract in construction
279      *  - an address where a contract will be created
280      *  - an address where a contract lived, but was destroyed
281      * ====
282      */
283     function isContract(address account) internal view returns (bool) {
284         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
285         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
286         // for accounts without code, i.e. `keccak256('')`
287         bytes32 codehash;
288         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
289         // solhint-disable-next-line no-inline-assembly
290         assembly { codehash := extcodehash(account) }
291         return (codehash != accountHash && codehash != 0x0);
292     }
293 
294     /**
295      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
296      * `recipient`, forwarding all available gas and reverting on errors.
297      *
298      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
299      * of certain opcodes, possibly making contracts go over the 2300 gas limit
300      * imposed by `transfer`, making them unable to receive funds via
301      * `transfer`. {sendValue} removes this limitation.
302      *
303      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
304      *
305      * IMPORTANT: because control is transferred to `recipient`, care must be
306      * taken to not create reentrancy vulnerabilities. Consider using
307      * {ReentrancyGuard} or the
308      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
309      */
310     function sendValue(address payable recipient, uint256 amount) internal {
311         require(address(this).balance >= amount, "Address: insufficient balance");
312 
313         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
314         (bool success, ) = recipient.call{ value: amount }("");
315         require(success, "Address: unable to send value, recipient may have reverted");
316     }
317 
318     /**
319      * @dev Performs a Solidity function call using a low level `call`. A
320      * plain`call` is an unsafe replacement for a function call: use this
321      * function instead.
322      *
323      * If `target` reverts with a revert reason, it is bubbled up by this
324      * function (like regular Solidity function calls).
325      *
326      * Returns the raw returned data. To convert to the expected return value,
327      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
328      *
329      * Requirements:
330      *
331      * - `target` must be a contract.
332      * - calling `target` with `data` must not revert.
333      *
334      * _Available since v3.1._
335      */
336     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
337       return functionCall(target, data, "Address: low-level call failed");
338     }
339 
340     /**
341      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
342      * `errorMessage` as a fallback revert reason when `target` reverts.
343      *
344      * _Available since v3.1._
345      */
346     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
347         return _functionCallWithValue(target, data, 0, errorMessage);
348     }
349 
350     /**
351      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
352      * but also transferring `value` wei to `target`.
353      *
354      * Requirements:
355      *
356      * - the calling contract must have an ETH balance of at least `value`.
357      * - the called Solidity function must be `payable`.
358      *
359      * _Available since v3.1._
360      */
361     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
362         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
363     }
364 
365     /**
366      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
367      * with `errorMessage` as a fallback revert reason when `target` reverts.
368      *
369      * _Available since v3.1._
370      */
371     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
372         require(address(this).balance >= value, "Address: insufficient balance for call");
373         return _functionCallWithValue(target, data, value, errorMessage);
374     }
375 
376     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
377         require(isContract(target), "Address: call to non-contract");
378 
379         // solhint-disable-next-line avoid-low-level-calls
380         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
381         if (success) {
382             return returndata;
383         } else {
384             // Look for revert reason and bubble it up if present
385             if (returndata.length > 0) {
386                 // The easiest way to bubble the revert reason is using memory via assembly
387 
388                 // solhint-disable-next-line no-inline-assembly
389                 assembly {
390                     let returndata_size := mload(returndata)
391                     revert(add(32, returndata), returndata_size)
392                 }
393             } else {
394                 revert(errorMessage);
395             }
396         }
397     }
398 }
399 
400 /**
401  * @title SafeERC20
402  * @dev Wrappers around ERC20 operations that throw on failure (when the token
403  * contract returns false). Tokens that return no value (and instead revert or
404  * throw on failure) are also supported, non-reverting calls are assumed to be
405  * successful.
406  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
407  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
408  */
409 library SafeERC20 {
410     using SafeMath for uint256;
411     using Address for address;
412 
413     function safeTransfer(IERC20 token, address to, uint256 value) internal {
414         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
415     }
416 
417     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
418         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
419     }
420 
421     /**
422      * @dev Deprecated. This function has issues similar to the ones found in
423      * {IERC20-approve}, and its usage is discouraged.
424      *
425      * Whenever possible, use {safeIncreaseAllowance} and
426      * {safeDecreaseAllowance} instead.
427      */
428     function safeApprove(IERC20 token, address spender, uint256 value) internal {
429         // safeApprove should only be called when setting an initial allowance,
430         // or when resetting it to zero. To increase and decrease it, use
431         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
432         // solhint-disable-next-line max-line-length
433         require((value == 0) || (token.allowance(address(this), spender) == 0),
434             "SafeERC20: approve from non-zero to non-zero allowance"
435         );
436         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
437     }
438 
439     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
440         uint256 newAllowance = token.allowance(address(this), spender).add(value);
441         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
442     }
443 
444     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
445         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
446         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
447     }
448 
449     /**
450      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
451      * on the return value: the return value is optional (but if data is returned, it must not be false).
452      * @param token The token targeted by the call.
453      * @param data The call data (encoded using abi.encode or one of its variants).
454      */
455     function _callOptionalReturn(IERC20 token, bytes memory data) private {
456         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
457         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
458         // the target address contains contract code and also asserts for success in the low-level call.
459 
460         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
461         if (returndata.length > 0) { // Return data is optional
462             // solhint-disable-next-line max-line-length
463             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
464         }
465     }
466 }
467 
468 /**
469  * @dev Contract module that helps prevent reentrant calls to a function.
470  *
471  * Inheriting from `ReentrancyGuard` will make the `nonReentrant` modifier
472  * available, which can be aplied to functions to make sure there are no nested
473  * (reentrant) calls to them.
474  *
475  * Note that because there is a single `nonReentrant` guard, functions marked as
476  * `nonReentrant` may not call one another. This can be worked around by making
477  * those functions `private`, and then adding `external` `nonReentrant` entry
478  * points to them.
479  */
480 contract ReentrancyGuard {
481     /// @dev counter to allow mutex lock with only one SSTORE operation
482     uint256 private _guardCounter;
483 
484     constructor () internal {
485         // The counter starts at one to prevent changing it from zero to a non-zero
486         // value, which is a more expensive operation.
487         _guardCounter = 1;
488     }
489 
490     /**
491      * @dev Prevents a contract from calling itself, directly or indirectly.
492      * Calling a `nonReentrant` function from another `nonReentrant`
493      * function is not supported. It is possible to prevent this from happening
494      * by making the `nonReentrant` function external, and make it call a
495      * `private` function that does the actual work.
496      */
497     modifier nonReentrant() {
498         _guardCounter += 1;
499         uint256 localCounter = _guardCounter;
500         _;
501         require(localCounter == _guardCounter, "ReentrancyGuard: reentrant call");
502     }
503 }
504 
505 interface IRewardsDistributionRecipient {
506     function notifyRewardAmount(address _rewardToken, uint256 reward) external;
507 }
508 
509 interface IWrappedERC20 {
510     function wrap(address _to, uint _amount) external;
511     function unwrap(address _to, uint _amount) external;
512 }
513 
514 // A multistakingreward contract that allows stakers to staking a single token and recieve various reward tokens.
515 // Forked from the Uniswap staking reward contract at https://etherscan.io/address/0x7FBa4B8Dc5E7616e59622806932DBea72537A56b#code
516 // with the following changes:
517 // - Expand from single reward token to a list of reward tokens
518 // - allow governance to rescue unclaimed tokens
519 contract MultiStakingRewards is IRewardsDistributionRecipient, ReentrancyGuard {
520     using SafeMath for uint256;
521     using SafeERC20 for IERC20;
522 
523     /* ========== STRUCTS ========== */
524 
525     // Info of each reward pool.
526     struct RewardPool {
527         IERC20 rewardToken;                                 // Address of reward token.
528         uint256 periodFinish;                               // timestamp of when this reward pool finishes distribution
529         uint256 rewardRate;                                 // amount of rewards distributed per unit of time
530         uint256 rewardsDuration;                            // duration of distribution
531         uint256 lastUpdateTime;                             // timestamp of when reward info was last updated
532         uint256 rewardPerTokenStored;                       // current rewards per token based on total rewards and total staked
533         mapping(address => uint256) userRewardPerTokenPaid; // amount of rewards per token already paided out to user
534         mapping(address => uint256) rewards;                // amount of rewards user has earned
535         bool isActive;                                      // mark if the pool is active
536     }
537 
538     /* ========== STATE VARIABLES ========== */
539 
540     address public rewardsDistribution;
541     address public governance;
542 
543     IERC20 public stakingToken;
544     IWrappedERC20 public wStakingToken; // wrapped stakingToken is used to reward stakers with more stakingToken
545 
546     uint256 public totalSupply;
547     mapping(address => uint256) public balances;
548 
549     mapping(address => RewardPool) public rewardPools; // reward token to reward pool mapping
550     address[] public activeRewardPools; // list of reward tokens that are distributing rewards
551 
552     /* ========== CONSTRUCTOR ========== */
553 
554     constructor(address _stakingToken, address _wStakingToken, address _rewardsDistribution) public {
555         stakingToken = IERC20(_stakingToken);
556         wStakingToken = IWrappedERC20(_wStakingToken);
557         rewardsDistribution = _rewardsDistribution;
558         governance = msg.sender;
559     }
560 
561     /* ========== VIEWS ========== */
562 
563     function activeRewardPoolsLength() external view returns (uint256) {
564         return activeRewardPools.length;
565     }
566 
567     function lastTimeRewardApplicable(address _rewardToken) public view returns (uint256) {
568         RewardPool storage pool = rewardPools[_rewardToken];
569         return Math.min(block.timestamp, pool.periodFinish);
570     }
571 
572     function rewardPerToken(address _rewardToken) public view returns (uint256) {
573         RewardPool storage pool = rewardPools[_rewardToken];
574         if (totalSupply == 0) {
575             return pool.rewardPerTokenStored;
576         }
577         return
578             pool.rewardPerTokenStored.add(
579                 lastTimeRewardApplicable(_rewardToken).sub(pool.lastUpdateTime).mul(pool.rewardRate).mul(1e18).div(totalSupply)
580             );
581     }
582 
583     function earned(address _rewardToken, address _account) public view returns (uint256) {
584         RewardPool storage pool = rewardPools[_rewardToken];
585         return balances[_account].mul(rewardPerToken(_rewardToken).sub(pool.userRewardPerTokenPaid[_account])).div(1e18).add(pool.rewards[_account]);
586     }
587 
588     function getRewardForDuration(address _rewardToken) external view returns (uint256) {
589         RewardPool storage pool = rewardPools[_rewardToken];
590         return pool.rewardRate.mul(pool.rewardsDuration);
591     }
592 
593     function periodFinish(address _rewardToken) public view returns (uint256) {
594         RewardPool storage pool = rewardPools[_rewardToken];
595         return pool.periodFinish;
596     }
597 
598     function rewardRate(address _rewardToken) public view returns (uint256) {
599         RewardPool storage pool = rewardPools[_rewardToken];
600         return pool.rewardRate;
601     }
602 
603     function rewardsDuration(address _rewardToken) public view returns (uint256) {
604         RewardPool storage pool = rewardPools[_rewardToken];
605         return pool.rewardsDuration;
606     }
607 
608     function lastUpdateTime(address _rewardToken) public view returns (uint256) {
609         RewardPool storage pool = rewardPools[_rewardToken];
610         return pool.lastUpdateTime;
611     }
612 
613     function rewardPerTokenStored(address _rewardToken) public view returns (uint256) {
614         RewardPool storage pool = rewardPools[_rewardToken];
615         return pool.rewardPerTokenStored;
616     }
617 
618     function userRewardPerTokenPaid(address _rewardToken, address _account) public view returns (uint256) {
619         RewardPool storage pool = rewardPools[_rewardToken];
620         return pool.userRewardPerTokenPaid[_account];
621     }
622 
623     function rewards(address _rewardToken, address _account) public view returns (uint256) {
624         RewardPool storage pool = rewardPools[_rewardToken];
625         return pool.rewards[_account];
626     }
627 
628     /* ========== MUTATIVE FUNCTIONS ========== */
629 
630     function stake(uint256 amount) external nonReentrant updateActiveRewards(msg.sender) {
631         require(amount > 0, "Cannot stake 0");
632         totalSupply = totalSupply.add(amount);
633         balances[msg.sender] = balances[msg.sender].add(amount);
634         stakingToken.safeTransferFrom(msg.sender, address(this), amount);
635         emit Staked(msg.sender, amount);
636     }
637 
638     function withdraw(uint256 amount) public nonReentrant updateActiveRewards(msg.sender) {
639         require(amount > 0, "Cannot withdraw 0");
640         totalSupply = totalSupply.sub(amount);
641         balances[msg.sender] = balances[msg.sender].sub(amount);
642         stakingToken.safeTransfer(msg.sender, amount);
643         emit Withdrawn(msg.sender, amount);
644     }
645 
646     function getReward(address _rewardToken) external nonReentrant updateReward(_rewardToken, msg.sender) {
647         _getReward(_rewardToken);
648     }
649 
650     function getAllActiveRewards() public nonReentrant updateActiveRewards(msg.sender) {
651         for (uint i = 0; i < activeRewardPools.length; i++) {
652             _getReward(activeRewardPools[i]);
653         }
654     }
655 
656     function _getReward(address _rewardToken) internal {
657         RewardPool storage pool = rewardPools[_rewardToken];
658         require(pool.isActive, "pool is inactive");
659 
660         uint256 reward = pool.rewards[msg.sender];
661         if (reward > 0) {
662             pool.rewards[msg.sender] = 0;
663             // If reward token is wrapped version of staking token, auto unwrap into underlying to user
664             if (address(pool.rewardToken) == address(wStakingToken)) {
665                 wStakingToken.unwrap(msg.sender, reward);
666             } else {
667                 pool.rewardToken.safeTransfer(msg.sender, reward);
668             }
669             emit RewardPaid(address(pool.rewardToken), msg.sender, reward);
670         }
671     }
672 
673     function exit() external {
674         withdraw(balances[msg.sender]);
675         getAllActiveRewards();
676     }
677 
678     /* ========== RESTRICTED FUNCTIONS ========== */
679 
680     function notifyRewardAmount(address _rewardToken, uint256 _amount) external override onlyRewardsDistribution updateReward(_rewardToken, address(0)) {
681         RewardPool storage pool = rewardPools[_rewardToken];
682 
683         if (block.timestamp >= pool.periodFinish) {
684             pool.rewardRate = _amount.div(pool.rewardsDuration);
685         } else {
686             uint256 remaining = pool.periodFinish.sub(block.timestamp);
687             uint256 leftover = remaining.mul(pool.rewardRate);
688             pool.rewardRate = _amount.add(leftover).div(pool.rewardsDuration);
689         }
690 
691         // Ensure the provided reward amount is not more than the balance in the contract.
692         // This keeps the reward rate in the right range, preventing overflows due to
693         // very high values of rewardRate in the earned and rewardsPerToken functions;
694         // Reward + leftover must be less than 2^256 / 10^18 to avoid overflow.
695         uint balance = pool.rewardToken.balanceOf(address(this));
696         require(pool.rewardRate <= balance.div(pool.rewardsDuration), "Provided reward too high");
697 
698         pool.lastUpdateTime = block.timestamp;
699         pool.periodFinish = block.timestamp.add(pool.rewardsDuration);
700 
701         emit RewardAdded(_rewardToken, _amount);
702     }
703 
704     // Add new reward pool to list
705     // NOTE: DO NOT add same pool twice while active.
706     function addRewardPool(
707         address _rewardToken,
708         uint256 _rewardsDuration
709     )
710         external
711         onlyGov
712     {
713       rewardPools[_rewardToken] = RewardPool({
714           rewardToken: IERC20(_rewardToken),
715           periodFinish: 0,
716           rewardRate: 0,
717           rewardsDuration: _rewardsDuration,
718           lastUpdateTime: 0,
719           rewardPerTokenStored: 0,
720           isActive: true
721       });
722 
723       activeRewardPools.push(_rewardToken);
724     }
725 
726     // Remove pool from active list
727     function inactivateRewardPool(address _rewardToken) external onlyGov {
728         // find the index
729         uint indexToDelete = 0;
730         bool found = false;
731         for (uint i = 0; i < activeRewardPools.length; i++) {
732             if (activeRewardPools[i] == _rewardToken) {
733                 indexToDelete = i;
734                 found = true;
735                 break;
736             }
737         }
738 
739         require(found, "element not found");
740         _inactivateRewardPool(indexToDelete);
741     }
742 
743     // In case the list gets so large and make iteration impossible
744     function inactivateRewardPoolByIndex(uint256 _index) external onlyGov {
745         _inactivateRewardPool(_index);
746     }
747 
748     function _inactivateRewardPool(uint256 _index) internal {
749         RewardPool storage pool = rewardPools[activeRewardPools[_index]];
750         pool.isActive = false;
751         // we don't care about the ordering of the active reward pool array
752         // so we can just swap the element to delete with the last element
753         activeRewardPools[_index] = activeRewardPools[activeRewardPools.length - 1];
754         activeRewardPools.pop();
755     }
756 
757     // Allow governance to rescue unclaimed inactive rewards
758     function rescue(address _rewardToken) external onlyGov {
759         require(_rewardToken != address(stakingToken), "Cannot withdraw staking token");
760         RewardPool storage pool = rewardPools[_rewardToken];
761         require(pool.isActive == false, "Cannot withdraw active reward token");
762 
763         uint _balance = IERC20(_rewardToken).balanceOf(address(this));
764         IERC20(_rewardToken).safeTransfer(governance, _balance);
765     }
766 
767     /* ========== RESTRICTED FUNCTIONS ========== */
768 
769     function setRewardsDistribution(address _rewardsDistribution) external {
770         require(msg.sender == governance, "!governance");
771         rewardsDistribution = _rewardsDistribution;
772     }
773 
774     function setGov(address _gov) external {
775         require(msg.sender == governance, "!governance");
776         governance = _gov;
777     }
778 
779     /* ========== MODIFIERS ========== */
780 
781     modifier updateActiveRewards(address _account) {
782         for (uint i = 0; i < activeRewardPools.length; i++) {
783             RewardPool storage pool = rewardPools[activeRewardPools[i]];
784 
785             pool.rewardPerTokenStored = rewardPerToken(address(pool.rewardToken));
786             pool.lastUpdateTime = lastTimeRewardApplicable(address(pool.rewardToken));
787             if (_account != address(0)) {
788                 pool.rewards[_account] = earned(address(pool.rewardToken), _account);
789                 pool.userRewardPerTokenPaid[_account] = pool.rewardPerTokenStored;
790             }
791         }
792         _;
793     }
794 
795     modifier updateReward(address _rewardToken, address _account) {
796         RewardPool storage pool = rewardPools[_rewardToken];
797 
798         pool.rewardPerTokenStored = rewardPerToken(address(pool.rewardToken));
799         pool.lastUpdateTime = lastTimeRewardApplicable(address(pool.rewardToken));
800         if (_account != address(0)) {
801             pool.rewards[_account] = earned(address(pool.rewardToken), _account);
802             pool.userRewardPerTokenPaid[_account] = pool.rewardPerTokenStored;
803         }
804         _;
805     }
806 
807     modifier onlyGov() {
808         require(msg.sender == governance, "!governance");
809         _;
810     }
811 
812     modifier onlyRewardsDistribution() {
813         require(msg.sender == rewardsDistribution, "!rewardsDistribution");
814         _;
815     }
816 
817     /* ========== EVENTS ========== */
818 
819     event RewardAdded(address indexed rewardToken, uint256 amount);
820     event Staked(address indexed user, uint256 amount);
821     event Withdrawn(address indexed user, uint256 amount);
822     event RewardPaid(address indexed rewardToken, address indexed user, uint256 reward);
823 }