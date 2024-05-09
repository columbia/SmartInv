1 pragma solidity ^0.5.0;
2 
3 interface ICourtStake{
4 
5     function lockedStake(uint256 amount, address beneficiar,  uint256 StartReleasingTime, uint256 batchCount, uint256 batchPeriod) external;
6 
7 }
8 
9 interface IMERC20 {
10     function mint(address account, uint amount) external;
11 }
12 
13 
14 /**
15  * @dev Wrappers over Solidity's arithmetic operations with added overflow
16  * checks.
17  *
18  * Arithmetic operations in Solidity wrap on overflow. This can easily result
19  * in bugs, because programmers usually assume that an overflow raises an
20  * error, which is the standard behavior in high level programming languages.
21  * `SafeMath` restores this intuition by reverting the transaction when an
22  * operation overflows.
23  *
24  * Using this library instead of the unchecked operations eliminates an entire
25  * class of bugs, so it's recommended to use it always.
26  */
27 library SafeMath {
28     /**
29      * @dev Returns the addition of two unsigned integers, reverting on
30      * overflow.
31      *
32      * Counterpart to Solidity's `+` operator.
33      *
34      * Requirements:
35      * - Addition cannot overflow.
36      */
37     function add(uint256 a, uint256 b) internal pure returns (uint256) {
38         uint256 c = a + b;
39         require(c >= a, "SafeMath: addition overflow");
40 
41         return c;
42     }
43 
44     /**
45      * @dev Returns the subtraction of two unsigned integers, reverting on
46      * overflow (when the result is negative).
47      *
48      * Counterpart to Solidity's `-` operator.
49      *
50      * Requirements:
51      * - Subtraction cannot overflow.
52      */
53     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
54         return sub(a, b, "SafeMath: subtraction overflow");
55     }
56 
57     /**
58      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
59      * overflow (when the result is negative).
60      *
61      * Counterpart to Solidity's `-` operator.
62      *
63      * Requirements:
64      * - Subtraction cannot overflow.
65      *
66      * _Available since v2.4.0._
67      */
68     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
69         require(b <= a, errorMessage);
70         uint256 c = a - b;
71 
72         return c;
73     }
74 
75     /**
76      * @dev Returns the multiplication of two unsigned integers, reverting on
77      * overflow.
78      *
79      * Counterpart to Solidity's `*` operator.
80      *
81      * Requirements:
82      * - Multiplication cannot overflow.
83      */
84     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
85         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
86         // benefit is lost if 'b' is also tested.
87         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
88         if (a == 0) {
89             return 0;
90         }
91 
92         uint256 c = a * b;
93         require(c / a == b, "SafeMath: multiplication overflow");
94 
95         return c;
96     }
97 
98     /**
99      * @dev Returns the integer division of two unsigned integers. Reverts on
100      * division by zero. The result is rounded towards zero.
101      *
102      * Counterpart to Solidity's `/` operator. Note: this function uses a
103      * `revert` opcode (which leaves remaining gas untouched) while Solidity
104      * uses an invalid opcode to revert (consuming all remaining gas).
105      *
106      * Requirements:
107      * - The divisor cannot be zero.
108      */
109     function div(uint256 a, uint256 b) internal pure returns (uint256) {
110         return div(a, b, "SafeMath: division by zero");
111     }
112 
113     /**
114      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
115      * division by zero. The result is rounded towards zero.
116      *
117      * Counterpart to Solidity's `/` operator. Note: this function uses a
118      * `revert` opcode (which leaves remaining gas untouched) while Solidity
119      * uses an invalid opcode to revert (consuming all remaining gas).
120      *
121      * Requirements:
122      * - The divisor cannot be zero.
123      *
124      * _Available since v2.4.0._
125      */
126     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
127         // Solidity only automatically asserts when dividing by 0
128         require(b > 0, errorMessage);
129         uint256 c = a / b;
130         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
131 
132         return c;
133     }
134 
135     /**
136      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
137      * Reverts when dividing by zero.
138      *
139      * Counterpart to Solidity's `%` operator. This function uses a `revert`
140      * opcode (which leaves remaining gas untouched) while Solidity uses an
141      * invalid opcode to revert (consuming all remaining gas).
142      *
143      * Requirements:
144      * - The divisor cannot be zero.
145      */
146     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
147         return mod(a, b, "SafeMath: modulo by zero");
148     }
149 
150     /**
151      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
152      * Reverts with custom message when dividing by zero.
153      *
154      * Counterpart to Solidity's `%` operator. This function uses a `revert`
155      * opcode (which leaves remaining gas untouched) while Solidity uses an
156      * invalid opcode to revert (consuming all remaining gas).
157      *
158      * Requirements:
159      * - The divisor cannot be zero.
160      *
161      * _Available since v2.4.0._
162      */
163     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
164         require(b != 0, errorMessage);
165         return a % b;
166     }
167 }
168 
169 /**
170  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
171  * the optional functions; to access them see {ERC20Detailed}.
172  */
173 interface IERC20 {
174     /**
175      * @dev Returns the amount of tokens in existence.
176      */
177     function totalSupply() external view returns (uint256);
178 
179     /**
180      * @dev Returns the amount of tokens owned by `account`.
181      */
182     function balanceOf(address account) external view returns (uint256);
183 
184     /**
185      * @dev Moves `amount` tokens from the caller's account to `recipient`.
186      *
187      * Returns a boolean value indicating whether the operation succeeded.
188      *
189      * Emits a {Transfer} event.
190      */
191     function transfer(address recipient, uint256 amount) external returns (bool);
192 
193 
194     /**
195      * @dev Returns the remaining number of tokens that `spender` will be
196      * allowed to spend on behalf of `owner` through {transferFrom}. This is
197      * zero by default.
198      *
199      * This value changes when {approve} or {transferFrom} are called.
200      */
201     function allowance(address owner, address spender) external view returns (uint256);
202 
203     /**
204      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
205      *
206      * Returns a boolean value indicating whether the operation succeeded.
207      *
208      * IMPORTANT: Beware that changing an allowance with this method brings the risk
209      * that someone may use both the old and the new allowance by unfortunate
210      * transaction ordering. One possible solution to mitigate this race
211      * condition is to first reduce the spender's allowance to 0 and set the
212      * desired value afterwards:
213      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
214      *
215      * Emits an {Approval} event.
216      */
217     function approve(address spender, uint256 amount) external returns (bool);
218 
219     /**
220      * @dev Moves `amount` tokens from `sender` to `recipient` using the
221      * allowance mechanism. `amount` is then deducted from the caller's
222      * allowance.
223      *
224      * Returns a boolean value indicating whether the operation succeeded.
225      *
226      * Emits a {Transfer} event.
227      */
228     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
229 
230     /**
231      * @dev Emitted when `value` tokens are moved from one account (`from`) to
232      * another (`to`).
233      *
234      * Note that `value` may be zero.
235      */
236     event Transfer(address indexed from, address indexed to, uint256 value);
237 
238     /**
239      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
240      * a call to {approve}. `value` is the new allowance.
241      */
242     event Approval(address indexed owner, address indexed spender, uint256 value);
243 }
244 
245 /**
246  * @dev Collection of functions related to the address type
247  */
248 library Address {
249     /**
250      * @dev Returns true if `account` is a contract.
251      *
252      * This test is non-exhaustive, and there may be false-negatives: during the
253      * execution of a contract's constructor, its address will be reported as
254      * not containing a contract.
255      *
256      * IMPORTANT: It is unsafe to assume that an address for which this
257      * function returns false is an externally-owned account (EOA) and not a
258      * contract.
259      */
260     function isContract(address account) internal view returns (bool) {
261         // This method relies in extcodesize, which returns 0 for contracts in
262         // construction, since the code is only stored at the end of the
263         // constructor execution.
264 
265         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
266         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
267         // for accounts without code, i.e. `keccak256('')`
268         bytes32 codehash;
269         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
270         // solhint-disable-next-line no-inline-assembly
271         assembly { codehash := extcodehash(account) }
272         return (codehash != 0x0 && codehash != accountHash);
273     }
274 
275     /**
276      * @dev Converts an `address` into `address payable`. Note that this is
277      * simply a type cast: the actual underlying value is not changed.
278      *
279      * _Available since v2.4.0._
280      */
281     function toPayable(address account) internal pure returns (address payable) {
282         return address(uint160(account));
283     }
284 
285     /**
286      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
287      * `recipient`, forwarding all available gas and reverting on errors.
288      *
289      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
290      * of certain opcodes, possibly making contracts go over the 2300 gas limit
291      * imposed by `transfer`, making them unable to receive funds via
292      * `transfer`. {sendValue} removes this limitation.
293      *
294      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
295      *
296      * IMPORTANT: because control is transferred to `recipient`, care must be
297      * taken to not create reentrancy vulnerabilities. Consider using
298      * {ReentrancyGuard} or the
299      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
300      *
301      * _Available since v2.4.0._
302      */
303     function sendValue(address payable recipient, uint256 amount) internal {
304         require(address(this).balance >= amount, "Address: insufficient balance");
305 
306         // solhint-disable-next-line avoid-call-value
307         (bool success, ) = recipient.call.value(amount)("");
308         require(success, "Address: unable to send value, recipient may have reverted");
309     }
310 }
311 
312 
313 /**
314  * @title SafeERC20
315  * @dev Wrappers around ERC20 operations that throw on failure (when the token
316  * contract returns false). Tokens that return no value (and instead revert or
317  * throw on failure) are also supported, non-reverting calls are assumed to be
318  * successful.
319  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
320  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
321  */
322 library SafeERC20 {
323     using SafeMath for uint256;
324     using Address for address;
325 
326     function safeTransfer(IERC20 token, address to, uint256 value) internal {
327         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
328     }
329 
330     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
331         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
332     }
333 
334     function safeApprove(IERC20 token, address spender, uint256 value) internal {
335         // safeApprove should only be called when setting an initial allowance,
336         // or when resetting it to zero. To increase and decrease it, use
337         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
338         // solhint-disable-next-line max-line-length
339         require((value == 0) || (token.allowance(address(this), spender) == 0),
340             "SafeERC20: approve from non-zero to non-zero allowance"
341         );
342         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
343     }
344 
345     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
346         uint256 newAllowance = token.allowance(address(this), spender).add(value);
347         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
348     }
349 
350     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
351         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
352         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
353     }
354 
355     /**
356      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
357      * on the return value: the return value is optional (but if data is returned, it must not be false).
358      * @param token The token targeted by the call.
359      * @param data The call data (encoded using abi.encode or one of its variants).
360      */
361     function callOptionalReturn(IERC20 token, bytes memory data) private {
362         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
363         // we're implementing it ourselves.
364 
365         // A Solidity high level call has three parts:
366         //  1. The target address is checked to verify it contains contract code
367         //  2. The call itself is made, and success asserted
368         //  3. The return value is decoded, which in turn checks the size of the returned data.
369         // solhint-disable-next-line max-line-length
370         require(address(token).isContract(), "SafeERC20: call to non-contract");
371 
372         // solhint-disable-next-line avoid-low-level-calls
373         (bool success, bytes memory returndata) = address(token).call(data);
374         require(success, "SafeERC20: low-level call failed");
375 
376         if (returndata.length > 0) { // Return data is optional
377             // solhint-disable-next-line max-line-length
378             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
379         }
380     }
381 }
382 
383 contract CourtFarming_RoomLPStake {
384     using SafeMath for uint256;
385     using SafeERC20 for IERC20;
386 
387 
388     IERC20 public constant stakedToken = IERC20(0xBE55c87dFf2a9f5c95cB5C07572C51fd91fe0732);
389 
390 
391     IMERC20 public constant courtToken = IMERC20(0x0538A9b4f4dcB0CB01A7fA34e17C0AC947c22553);
392 
393     uint256 private _totalStaked;
394     mapping(address => uint256) private _balances;
395 
396     // last updated block number
397     uint256 private _lastUpdateBlock;
398 
399     // incentive rewards
400     uint256 public incvFinishBlock; //  finish incentive rewarding block number
401     uint256 private _incvRewardPerBlock; // incentive reward per block
402     uint256 private _incvAccRewardPerToken; // accumulative reward per token
403     mapping(address => uint256) private _incvRewards; // reward balances
404     mapping(address => uint256) private _incvPrevAccRewardPerToken;// previous accumulative reward per token (for a user)
405 
406     uint256 public incvStartReleasingTime;  // incentive releasing time
407     uint256 public incvBatchPeriod; // incentive batch period
408     uint256 public incvBatchCount; // incentive batch count
409     mapping(address => uint256) public  incvWithdrawn;
410 
411     address public owner;
412 
413     enum TransferRewardState {
414         Succeeded,
415         RewardsStillLocked
416     }
417 
418 
419     address public courtStakeAddress;
420 
421     event Staked(address indexed user, uint256 amount);
422     event Unstaked(address indexed user, uint256 amount);
423     event ClaimReward(address indexed user, uint256 reward);
424     event ClaimIncentiveReward(address indexed user, uint256 reward);
425     event StakeRewards(address indexed user, uint256 amount, uint256 lockTime);
426     event CourtStakeChanged(address oldAddress, address newAddress);
427     event StakeParametersChanged(uint256 incvRewardPerBlock, uint256 incvRewardFinsishBlock, uint256 incvLockTime);
428 
429     constructor () public {
430 
431         owner = msg.sender;
432 
433         uint256 incvRewardsPerBlock = 57870370370370369;
434         uint256 incvRewardsPeriodInDays = 90;
435         
436         incvStartReleasingTime = 1620914400; // 13/05/2021 // check https://www.epochconverter.com/ for timestamp
437         incvBatchPeriod = 1 days;
438         incvBatchCount = 1;
439 
440          _stakeParametrsCalculation(incvRewardsPerBlock, incvRewardsPeriodInDays, incvStartReleasingTime);
441 
442         _lastUpdateBlock = blockNumber();
443     }
444 
445     function _stakeParametrsCalculation(uint256 incvRewardsPerBlock, uint256 incvRewardsPeriodInDays, uint256 iLockTime) internal{
446 
447 
448         uint256 incvRewardBlockCount = incvRewardsPeriodInDays * 5760;
449         uint256 incvRewardPerBlock = incvRewardsPerBlock;
450 
451         _incvRewardPerBlock = incvRewardPerBlock * (1e18);
452         incvFinishBlock = blockNumber().add(incvRewardBlockCount);
453 
454         incvStartReleasingTime = iLockTime;
455     }
456 
457     function changeStakeParameters( uint256 incvRewardsPerBlock, uint256 incvRewardsPeriodInDays, uint256 iLockTime) public {
458 
459         require(msg.sender == owner, "can be called by owner only");
460         updateReward(address(0));
461 
462         _stakeParametrsCalculation(incvRewardsPerBlock, incvRewardsPeriodInDays, iLockTime);
463 
464         emit StakeParametersChanged( _incvRewardPerBlock, incvFinishBlock, incvStartReleasingTime);
465     }
466 
467     function updateReward(address account) public {
468         // reward algorithm
469         // in general: rewards = (reward per token ber block) user balances
470         uint256 cnBlock = blockNumber();
471 
472         // update accRewardPerToken, in case totalSupply is zero; do not increment accRewardPerToken
473         if (_totalStaked > 0) {
474             uint256 incvlastRewardBlock = cnBlock < incvFinishBlock ? cnBlock : incvFinishBlock;
475             if (incvlastRewardBlock > _lastUpdateBlock) {
476                 _incvAccRewardPerToken = incvlastRewardBlock.sub(_lastUpdateBlock)
477                 .mul(_incvRewardPerBlock).div(_totalStaked)
478                 .add(_incvAccRewardPerToken);
479             }
480         }
481 
482         _lastUpdateBlock = cnBlock;
483 
484         if (account != address(0)) {
485 
486             uint256 incAccRewardPerTokenForUser = _incvAccRewardPerToken.sub(_incvPrevAccRewardPerToken[account]);
487 
488             if (incAccRewardPerTokenForUser > 0) {
489                 _incvRewards[account] =
490                 _balances[account]
491                 .mul(incAccRewardPerTokenForUser)
492                 .div(1e18)
493                 .add(_incvRewards[account]);
494 
495                 _incvPrevAccRewardPerToken[account] = _incvAccRewardPerToken;
496             }
497         }
498     }
499 
500     function stake(uint256 amount) public {
501         updateReward(msg.sender);
502 
503         if (amount > 0) {
504             _totalStaked = _totalStaked.add(amount);
505             _balances[msg.sender] = _balances[msg.sender].add(amount);
506             stakedToken.safeTransferFrom(msg.sender, address(this), amount);
507             emit Staked(msg.sender, amount);
508         }
509     }
510 
511     function unstake(uint256 amount, bool claim) public {
512         updateReward(msg.sender);
513 
514         if (amount > 0) {
515             _totalStaked = _totalStaked.sub(amount);
516             _balances[msg.sender] = _balances[msg.sender].sub(amount);
517             stakedToken.safeTransfer(msg.sender, amount);
518             emit Unstaked(msg.sender, amount);
519         }
520         claim = false;
521     }
522 
523 
524     function stakeIncvRewards(uint256 amount) public returns (bool) {
525         updateReward(msg.sender);
526         uint256 incvReward = _incvRewards[msg.sender];
527 
528 
529         if (amount > incvReward || courtStakeAddress == address(0)) {
530             return false;
531         }
532 
533         _incvRewards[msg.sender] -= amount;  // no need to use safe math sub, since there is check for amount > reward
534 
535         courtToken.mint(address(this), amount);
536 
537         ICourtStake courtStake = ICourtStake(courtStakeAddress);
538         courtStake.lockedStake(amount,  msg.sender, incvStartReleasingTime, incvBatchCount, incvBatchPeriod);
539         emit StakeRewards(msg.sender, amount, incvStartReleasingTime);
540     }
541 
542     function setCourtStake(address courtStakeAdd) public {
543         require(msg.sender == owner, "only contract owner can change");
544 
545         address oldAddress = courtStakeAddress;
546         courtStakeAddress = courtStakeAdd;
547 
548         IERC20 courtTokenERC20 = IERC20(address(courtToken));
549 
550         courtTokenERC20.approve(courtStakeAdd, 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
551 
552         emit CourtStakeChanged(oldAddress, courtStakeAdd);
553     }
554 
555     function rewards(address account) public view returns (uint256 reward, uint256 incvReward) {
556         // read version of update
557         uint256 cnBlock = blockNumber();
558         
559         uint256 incvAccRewardPerToken = _incvAccRewardPerToken;
560 
561         // update accRewardPerToken, in case totalSupply is zero; do not increment accRewardPerToken
562         if (_totalStaked > 0) {
563             
564             uint256 incvLastRewardBlock = cnBlock < incvFinishBlock ? cnBlock : incvFinishBlock;
565             if (incvLastRewardBlock > _lastUpdateBlock) {
566                 incvAccRewardPerToken = incvLastRewardBlock.sub(_lastUpdateBlock)
567                 .mul(_incvRewardPerBlock).div(_totalStaked)
568                 .add(incvAccRewardPerToken);
569             }
570         }
571 
572         incvReward = _balances[account]
573         .mul(incvAccRewardPerToken.sub(_incvPrevAccRewardPerToken[account]))
574         .div(1e18)
575         .add(_incvRewards[account])
576         .sub(incvWithdrawn[account]);
577         
578         reward = 0;
579     }
580 
581     function incvRewardInfo() external view returns (uint256 cBlockNumber, uint256 incvRewardPerBlock, uint256 incvRewardFinishBlock, uint256 incvRewardFinishTime, uint256 incvRewardLockTime) {
582         cBlockNumber = blockNumber();
583         incvRewardFinishBlock = incvFinishBlock;
584         incvRewardPerBlock = _incvRewardPerBlock.div(1e18);
585         if( cBlockNumber < incvFinishBlock){
586             incvRewardFinishTime = block.timestamp.add(incvFinishBlock.sub(cBlockNumber).mul(15));
587         }else{
588             incvRewardFinishTime = block.timestamp.sub(cBlockNumber.sub(incvFinishBlock).mul(15));
589         }
590         incvRewardLockTime=incvStartReleasingTime;
591     }
592 
593 
594     // expected reward,
595     // please note this is only expectation, because total balance may changed during the day
596     function expectedRewardsToday(uint256 amount) external view returns (uint256 reward, uint256 incvReward) {
597         reward = 0;
598         uint256 totalIncvRewardPerDay = _incvRewardPerBlock * 5760;
599         incvReward =  totalIncvRewardPerDay.div(_totalStaked.add(amount)).mul(amount).div(1e18);
600     }
601 
602     function lastUpdateBlock() external view returns(uint256) {
603         return _lastUpdateBlock;
604     }
605 
606     function balanceOf(address account) external view returns (uint256) {
607         return _balances[account];
608     }
609 
610     function totalStaked() external view returns (uint256) {
611         return _totalStaked;
612     }
613 
614     function blockNumber() public view returns (uint256) {
615        return block.number;
616     }
617     
618     function getCurrentTime() public view returns(uint256){
619         return block.timestamp;
620     }
621     
622     function getVestedAmount(uint256 lockedAmount, uint256 time) internal  view returns(uint256){
623         
624         // if time < StartReleasingTime: then return 0
625         if(time < incvStartReleasingTime){
626             return 0;
627         }
628 
629         // if locked amount 0 return 0
630         if (lockedAmount == 0){
631             return 0;
632         }
633 
634         // elapsedBatchCount = ((time - startReleasingTime) / batchPeriod) + 1
635         uint256 elapsedBatchCount =
636         time.sub(incvStartReleasingTime)
637         .div(incvBatchPeriod)
638         .add(1);
639 
640         // vestedAmount = lockedAmount  * elapsedBatchCount / batchCount
641         uint256  vestedAmount =
642         lockedAmount
643         .mul(elapsedBatchCount)
644         .div(incvBatchCount);
645 
646         if(vestedAmount > lockedAmount){
647             vestedAmount = lockedAmount;
648         }
649 
650         return vestedAmount;
651     }
652     
653     
654     function incvRewardClaim() public returns(uint256 amount){
655         updateReward(msg.sender);
656         amount = getVestedAmount(_incvRewards[msg.sender], getCurrentTime()).sub(incvWithdrawn[msg.sender]);
657         
658         if(amount > 0){
659             incvWithdrawn[msg.sender] = incvWithdrawn[msg.sender].add(amount);
660 
661             courtToken.mint(msg.sender, amount);
662 
663             emit ClaimIncentiveReward(msg.sender, amount);
664         }
665     }
666     
667     function getBeneficiaryInfo(address ibeneficiary) external view
668     returns(address beneficiary,
669         uint256 totalLocked,
670         uint256 withdrawn,
671         uint256 releasableAmount,
672         uint256 nextBatchTime,
673         uint256 currentTime){
674 
675         beneficiary = ibeneficiary;
676         currentTime = getCurrentTime();
677         
678         totalLocked = _incvRewards[ibeneficiary];
679         withdrawn = incvWithdrawn[ibeneficiary];
680         ( , uint256 incvReward) = rewards(ibeneficiary);
681         releasableAmount = getVestedAmount(incvReward, getCurrentTime()).sub(incvWithdrawn[beneficiary]);
682         nextBatchTime = getIncNextBatchTime(incvReward, ibeneficiary, currentTime);
683         
684     }
685     
686     function getIncNextBatchTime(uint256 lockedAmount, address beneficiary, uint256 time) internal view returns(uint256){
687 
688         // if total vested equal to total locked then return 0
689         if(getVestedAmount(lockedAmount, time) == _incvRewards[beneficiary]){
690             return 0;
691         }
692 
693         // if time less than startReleasingTime: then return sartReleasingTime
694         if(time <= incvStartReleasingTime){
695             return incvStartReleasingTime;
696         }
697 
698         // find the next batch time
699         uint256 elapsedBatchCount =
700         time.sub(incvStartReleasingTime)
701         .div(incvBatchPeriod)
702         .add(1);
703 
704         uint256 nextBatchTime =
705         elapsedBatchCount
706         .mul(incvBatchPeriod)
707         .add(incvStartReleasingTime);
708 
709         return nextBatchTime;
710 
711     }
712 }