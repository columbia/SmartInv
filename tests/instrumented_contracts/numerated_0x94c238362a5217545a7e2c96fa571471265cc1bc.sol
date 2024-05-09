1 pragma solidity ^0.5.0;
2 
3 /**
4  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
5  * the optional functions; to access them see {ERC20Detailed}.
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
27 
28     /**
29      * @dev Returns the remaining number of tokens that `spender` will be
30      * allowed to spend on behalf of `owner` through {transferFrom}. This is
31      * zero by default.
32      *
33      * This value changes when {approve} or {transferFrom} are called.
34      */
35     function allowance(address owner, address spender) external view returns (uint256);
36 
37     /**
38      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
39      *
40      * Returns a boolean value indicating whether the operation succeeded.
41      *
42      * IMPORTANT: Beware that changing an allowance with this method brings the risk
43      * that someone may use both the old and the new allowance by unfortunate
44      * transaction ordering. One possible solution to mitigate this race
45      * condition is to first reduce the spender's allowance to 0 and set the
46      * desired value afterwards:
47      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
48      *
49      * Emits an {Approval} event.
50      */
51     function approve(address spender, uint256 amount) external returns (bool);
52 
53     /**
54      * @dev Moves `amount` tokens from `sender` to `recipient` using the
55      * allowance mechanism. `amount` is then deducted from the caller's
56      * allowance.
57      *
58      * Returns a boolean value indicating whether the operation succeeded.
59      *
60      * Emits a {Transfer} event.
61      */
62     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
63 
64     /**
65      * @dev Emitted when `value` tokens are moved from one account (`from`) to
66      * another (`to`).
67      *
68      * Note that `value` may be zero.
69      */
70     event Transfer(address indexed from, address indexed to, uint256 value);
71 
72     /**
73      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
74      * a call to {approve}. `value` is the new allowance.
75      */
76     event Approval(address indexed owner, address indexed spender, uint256 value);
77 }
78 
79 
80 /**
81  * @dev Wrappers over Solidity's arithmetic operations with added overflow
82  * checks.
83  *
84  * Arithmetic operations in Solidity wrap on overflow. This can easily result
85  * in bugs, because programmers usually assume that an overflow raises an
86  * error, which is the standard behavior in high level programming languages.
87  * `SafeMath` restores this intuition by reverting the transaction when an
88  * operation overflows.
89  *
90  * Using this library instead of the unchecked operations eliminates an entire
91  * class of bugs, so it's recommended to use it always.
92  */
93 library SafeMath {
94     /**
95      * @dev Returns the addition of two unsigned integers, reverting on
96      * overflow.
97      *
98      * Counterpart to Solidity's `+` operator.
99      *
100      * Requirements:
101      * - Addition cannot overflow.
102      */
103     function add(uint256 a, uint256 b) internal pure returns (uint256) {
104         uint256 c = a + b;
105         require(c >= a, "SafeMath: addition overflow");
106 
107         return c;
108     }
109 
110     /**
111      * @dev Returns the subtraction of two unsigned integers, reverting on
112      * overflow (when the result is negative).
113      *
114      * Counterpart to Solidity's `-` operator.
115      *
116      * Requirements:
117      * - Subtraction cannot overflow.
118      */
119     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
120         return sub(a, b, "SafeMath: subtraction overflow");
121     }
122 
123     /**
124      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
125      * overflow (when the result is negative).
126      *
127      * Counterpart to Solidity's `-` operator.
128      *
129      * Requirements:
130      * - Subtraction cannot overflow.
131      *
132      * _Available since v2.4.0._
133      */
134     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
135         require(b <= a, errorMessage);
136         uint256 c = a - b;
137 
138         return c;
139     }
140 
141     /**
142      * @dev Returns the multiplication of two unsigned integers, reverting on
143      * overflow.
144      *
145      * Counterpart to Solidity's `*` operator.
146      *
147      * Requirements:
148      * - Multiplication cannot overflow.
149      */
150     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
151         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
152         // benefit is lost if 'b' is also tested.
153         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
154         if (a == 0) {
155             return 0;
156         }
157 
158         uint256 c = a * b;
159         require(c / a == b, "SafeMath: multiplication overflow");
160 
161         return c;
162     }
163 
164     /**
165      * @dev Returns the integer division of two unsigned integers. Reverts on
166      * division by zero. The result is rounded towards zero.
167      *
168      * Counterpart to Solidity's `/` operator. Note: this function uses a
169      * `revert` opcode (which leaves remaining gas untouched) while Solidity
170      * uses an invalid opcode to revert (consuming all remaining gas).
171      *
172      * Requirements:
173      * - The divisor cannot be zero.
174      */
175     function div(uint256 a, uint256 b) internal pure returns (uint256) {
176         return div(a, b, "SafeMath: division by zero");
177     }
178 
179     /**
180      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
181      * division by zero. The result is rounded towards zero.
182      *
183      * Counterpart to Solidity's `/` operator. Note: this function uses a
184      * `revert` opcode (which leaves remaining gas untouched) while Solidity
185      * uses an invalid opcode to revert (consuming all remaining gas).
186      *
187      * Requirements:
188      * - The divisor cannot be zero.
189      *
190      * _Available since v2.4.0._
191      */
192     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
193         // Solidity only automatically asserts when dividing by 0
194         require(b > 0, errorMessage);
195         uint256 c = a / b;
196         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
197 
198         return c;
199     }
200 
201     /**
202      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
203      * Reverts when dividing by zero.
204      *
205      * Counterpart to Solidity's `%` operator. This function uses a `revert`
206      * opcode (which leaves remaining gas untouched) while Solidity uses an
207      * invalid opcode to revert (consuming all remaining gas).
208      *
209      * Requirements:
210      * - The divisor cannot be zero.
211      */
212     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
213         return mod(a, b, "SafeMath: modulo by zero");
214     }
215 
216     /**
217      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
218      * Reverts with custom message when dividing by zero.
219      *
220      * Counterpart to Solidity's `%` operator. This function uses a `revert`
221      * opcode (which leaves remaining gas untouched) while Solidity uses an
222      * invalid opcode to revert (consuming all remaining gas).
223      *
224      * Requirements:
225      * - The divisor cannot be zero.
226      *
227      * _Available since v2.4.0._
228      */
229     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
230         require(b != 0, errorMessage);
231         return a % b;
232     }
233 }
234 
235 /**
236  * @dev Collection of functions related to the address type
237  */
238 library Address {
239     /**
240      * @dev Returns true if `account` is a contract.
241      *
242      * This test is non-exhaustive, and there may be false-negatives: during the
243      * execution of a contract's constructor, its address will be reported as
244      * not containing a contract.
245      *
246      * IMPORTANT: It is unsafe to assume that an address for which this
247      * function returns false is an externally-owned account (EOA) and not a
248      * contract.
249      */
250     function isContract(address account) internal view returns (bool) {
251         // This method relies in extcodesize, which returns 0 for contracts in
252         // construction, since the code is only stored at the end of the
253         // constructor execution.
254 
255         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
256         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
257         // for accounts without code, i.e. `keccak256('')`
258         bytes32 codehash;
259         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
260         // solhint-disable-next-line no-inline-assembly
261         assembly { codehash := extcodehash(account) }
262         return (codehash != 0x0 && codehash != accountHash);
263     }
264 
265     /**
266      * @dev Converts an `address` into `address payable`. Note that this is
267      * simply a type cast: the actual underlying value is not changed.
268      *
269      * _Available since v2.4.0._
270      */
271     function toPayable(address account) internal pure returns (address payable) {
272         return address(uint160(account));
273     }
274 
275     /**
276      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
277      * `recipient`, forwarding all available gas and reverting on errors.
278      *
279      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
280      * of certain opcodes, possibly making contracts go over the 2300 gas limit
281      * imposed by `transfer`, making them unable to receive funds via
282      * `transfer`. {sendValue} removes this limitation.
283      *
284      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
285      *
286      * IMPORTANT: because control is transferred to `recipient`, care must be
287      * taken to not create reentrancy vulnerabilities. Consider using
288      * {ReentrancyGuard} or the
289      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
290      *
291      * _Available since v2.4.0._
292      */
293     function sendValue(address payable recipient, uint256 amount) internal {
294         require(address(this).balance >= amount, "Address: insufficient balance");
295 
296         // solhint-disable-next-line avoid-call-value
297         (bool success, ) = recipient.call.value(amount)("");
298         require(success, "Address: unable to send value, recipient may have reverted");
299     }
300 }
301 
302 
303 /**
304  * @title SafeERC20
305  * @dev Wrappers around ERC20 operations that throw on failure (when the token
306  * contract returns false). Tokens that return no value (and instead revert or
307  * throw on failure) are also supported, non-reverting calls are assumed to be
308  * successful.
309  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
310  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
311  */
312 library SafeERC20 {
313     using SafeMath for uint256;
314     using Address for address;
315 
316     function safeTransfer(IERC20 token, address to, uint256 value) internal {
317         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
318     }
319 
320     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
321         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
322     }
323 
324     function safeApprove(IERC20 token, address spender, uint256 value) internal {
325         // safeApprove should only be called when setting an initial allowance,
326         // or when resetting it to zero. To increase and decrease it, use
327         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
328         // solhint-disable-next-line max-line-length
329         require((value == 0) || (token.allowance(address(this), spender) == 0),
330             "SafeERC20: approve from non-zero to non-zero allowance"
331         );
332         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
333     }
334 
335     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
336         uint256 newAllowance = token.allowance(address(this), spender).add(value);
337         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
338     }
339 
340     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
341         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
342         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
343     }
344 
345     /**
346      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
347      * on the return value: the return value is optional (but if data is returned, it must not be false).
348      * @param token The token targeted by the call.
349      * @param data The call data (encoded using abi.encode or one of its variants).
350      */
351     function callOptionalReturn(IERC20 token, bytes memory data) private {
352         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
353         // we're implementing it ourselves.
354 
355         // A Solidity high level call has three parts:
356         //  1. The target address is checked to verify it contains contract code
357         //  2. The call itself is made, and success asserted
358         //  3. The return value is decoded, which in turn checks the size of the returned data.
359         // solhint-disable-next-line max-line-length
360         require(address(token).isContract(), "SafeERC20: call to non-contract");
361 
362         // solhint-disable-next-line avoid-low-level-calls
363         (bool success, bytes memory returndata) = address(token).call(data);
364         require(success, "SafeERC20: low-level call failed");
365 
366         if (returndata.length > 0) { // Return data is optional
367             // solhint-disable-next-line max-line-length
368             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
369         }
370     }
371 }
372 
373 
374 
375 contract RoomLPProgram {
376 
377     using SafeMath for uint256;
378     using SafeERC20 for IERC20;
379 
380     
381     // TODO: Please do not forget to call the approve for this contract from the wallet.
382     address public roomTokenRewardsReservoirAddress = 0x86181Ff88BDEC75d5f007cEfEE31087C8327dF77;
383     address public owner;
384     
385     // This is ROOM/ETH LP ERC20 address.
386     IERC20 public constant roomLPToken = IERC20(0xBE55c87dFf2a9f5c95cB5C07572C51fd91fe0732);
387 
388     // This is the correct CRC address of the ROOM token
389     IERC20 public constant roomToken = IERC20(0xAd4f86a25bbc20FfB751f2FAC312A0B4d8F88c64);
390 
391     // total Room LP staked
392     uint256 private _totalStaked;
393 
394     // last updated block number
395     uint256 public lastUpdateBlock;
396 
397     uint256 private  _accRewardPerToken; // accumulative reward per token
398     uint256 private  _rewardPerBlock;   // reward per block
399     uint256 public  finishBlock; // finish rewarding block number
400     uint256 public  endTime;
401 
402     mapping(address => uint256) private _rewards; // rewards balances
403     mapping(address => uint256) private _prevAccRewardPerToken; // previous accumulative reward per token (for a user)
404     mapping(address => uint256) private _balances; // balances per user
405     
406    
407     event Staked(address indexed user, uint256 amount);
408     event Unstaked(address indexed user, uint256 amount);
409     event ClaimReward(address indexed user, uint256 reward);
410     event FarmingParametersChanged(uint256 rewardPerBlock, uint256 rewardBlockCount, address indexed roomTokenRewardsReservoirAdd);
411     event RewardTransferFailed(TransferRewardState failure);
412     
413     enum TransferRewardState {
414         Succeeded,
415         RewardWalletEmpty
416     }
417     
418     constructor () public {
419 
420         owner = msg.sender;
421        
422         uint256 rewardBlockCount = 1036800;  // 5760 * 30 * 6; six months = 1,036,800 blocks
423         uint256 totalRewards = 240000e18;  // total rewards 240,000 Room in six months
424        
425         _rewardPerBlock = totalRewards * (1e18) / rewardBlockCount; // *(1e18) for math precisio
426         
427         finishBlock = blockNumber() + rewardBlockCount;
428         endTime = ((finishBlock-blockNumber()) * 15) + (block.timestamp);
429         lastUpdateBlock = blockNumber();
430     }
431 
432     function changeFarmingParameters(uint256 rewardPerBlock, uint256 rewardBlockCount, address roomTokenRewardsReservoirAdd) external {
433 
434         require(msg.sender == owner, "can be called by owner only");
435         updateReward(address(0));
436         _rewardPerBlock = rewardPerBlock.mul(1e18); // for math precision
437         
438         finishBlock = blockNumber().add(rewardBlockCount);
439         endTime = finishBlock.sub(blockNumber()).mul(15).add(block.timestamp);
440         roomTokenRewardsReservoirAddress = roomTokenRewardsReservoirAdd;
441 
442         emit FarmingParametersChanged(_rewardPerBlock, rewardBlockCount, roomTokenRewardsReservoirAddress);
443     }
444 
445     function updateReward(address account) public {
446         // reward algorithm
447         // in general: rewards = (reward per token ber block) user balances
448         uint256 cnBlock = blockNumber();
449 
450         // update accRewardPerToken, in case totalStaked is zero; do not increment accRewardPerToken
451         if (totalStaked() > 0) {
452             uint256 lastRewardBlock = cnBlock < finishBlock ? cnBlock : finishBlock;
453             if (lastRewardBlock > lastUpdateBlock) {
454                 _accRewardPerToken = lastRewardBlock.sub(lastUpdateBlock)
455                 .mul(_rewardPerBlock)
456                 .div(totalStaked())
457                 .add(_accRewardPerToken);
458             }
459         }
460 
461         lastUpdateBlock = cnBlock;
462 
463         if (account != address(0)) {
464 
465             uint256 accRewardPerTokenForUser = _accRewardPerToken.sub(_prevAccRewardPerToken[account]);
466 
467             if (accRewardPerTokenForUser > 0) {
468                 _rewards[account] =
469                 _balances[account]
470                 .mul(accRewardPerTokenForUser)
471                 .div(1e18)
472                 .add(_rewards[account]);
473 
474                 _prevAccRewardPerToken[account] = _accRewardPerToken;
475             }
476         }
477     }
478 
479     function stake(uint256 amount) external {
480         updateReward(msg.sender);
481 
482         _totalStaked = _totalStaked.add(amount);
483         _balances[msg.sender] = _balances[msg.sender].add(amount);
484 
485         // Transfer from owner of Room Token to this address.
486         roomLPToken.safeTransferFrom(msg.sender, address(this), amount);
487         emit Staked(msg.sender, amount);
488     }
489 
490     function unstake(uint256 amount, bool claim) external returns(uint256 reward, TransferRewardState reason) {
491         updateReward(msg.sender);
492 
493 
494         _totalStaked = _totalStaked.sub(amount);
495         _balances[msg.sender] = _balances[msg.sender].sub(amount);
496         // Send Room token staked to the original owner.
497         roomLPToken.safeTransfer(msg.sender, amount);
498        
499 
500         if (claim) {
501           (reward, reason) = _executeRewardTransfer(msg.sender);
502         }
503         
504          emit Unstaked(msg.sender, amount);
505     }
506     
507     function claimReward() external returns (uint256 reward, TransferRewardState reason) {
508         updateReward(msg.sender);
509 
510         return _executeRewardTransfer(msg.sender);
511     }
512     
513     function _executeRewardTransfer(address account) internal returns(uint256 reward, TransferRewardState reason) {
514         
515         reward = _rewards[account];
516         if (reward > 0) {
517             uint256 walletBalanace = roomToken.balanceOf(roomTokenRewardsReservoirAddress);
518             if (walletBalanace < reward) {
519                 // This fails, and we send reason 1 for the UI
520                 // to display a meaningful message for the user.
521                 // 1 means the wallet is empty.
522                 reason = TransferRewardState.RewardWalletEmpty;
523                 emit RewardTransferFailed(reason);
524                 
525             } else {
526                 
527                 // We will transfer and then empty the rewards
528                 // for the sender.
529                 _rewards[msg.sender] = 0;
530                 roomToken.transferFrom(roomTokenRewardsReservoirAddress, msg.sender, reward);
531                 emit ClaimReward(msg.sender, reward);
532             }
533         }
534     }
535 
536     function rewards(address account) external view returns (uint256 reward) {
537         // read version of update
538         uint256 cnBlock = blockNumber();
539         uint256 accRewardPerToken = _accRewardPerToken;
540 
541         // update accRewardPerToken, in case totalStaked is zero; do not increment accRewardPerToken
542         if (totalStaked() > 0) {
543             uint256 lastRewardBlock = cnBlock < finishBlock ? cnBlock : finishBlock;
544             if (lastRewardBlock > lastUpdateBlock) {
545                 accRewardPerToken = lastRewardBlock.sub(lastUpdateBlock)
546                 .mul(_rewardPerBlock).div(totalStaked())
547                 .add(accRewardPerToken);
548             }
549         }
550 
551         reward = _balances[account]
552         .mul(accRewardPerToken.sub(_prevAccRewardPerToken[account]))
553         .div(1e18)
554         .add(_rewards[account]);
555     }
556 
557     function info() external view returns (
558                                 uint256 cBlockNumber, 
559                                 uint256 rewardPerBlock,
560                                 uint256 rewardFinishBlock,
561                                 uint256 rewardEndTime,
562                                 uint256 walletBalance) {
563         cBlockNumber = blockNumber();
564         rewardFinishBlock = finishBlock;
565         rewardPerBlock = _rewardPerBlock.div(1e18);
566         rewardEndTime = endTime;
567         walletBalance = roomToken.balanceOf(roomTokenRewardsReservoirAddress);
568     }
569 
570     // expected reward,
571     // please note this is only an estimation, because total balance may change during the program
572     function expectedRewardsToday(uint256 amount) external view returns (uint256 reward) {
573 
574         uint256 cnBlock = blockNumber();
575         uint256 prevAccRewardPerToken = _accRewardPerToken;
576 
577         uint256 accRewardPerToken = _accRewardPerToken;
578         // update accRewardPerToken, in case totalStaked is zero do; not increment accRewardPerToken
579 
580         uint256 lastRewardBlock = cnBlock < finishBlock ? cnBlock : finishBlock;
581         if (lastRewardBlock > lastUpdateBlock) {
582             accRewardPerToken = lastRewardBlock.sub(lastUpdateBlock)
583             .mul(_rewardPerBlock).div(totalStaked().add(amount))
584             .add(accRewardPerToken);
585         }
586 
587         uint256 rewardsPerBlock = amount
588         .mul(accRewardPerToken.sub(prevAccRewardPerToken))
589         .div(1e18);
590 
591         
592         reward = rewardsPerBlock.mul(5760); // 5760 blocks per day
593     }
594 
595     function balanceOf(address account) public view returns (uint256) {
596         return _balances[account];
597     }
598 
599     function totalStaked() public view returns (uint256) {
600         return _totalStaked;
601     }
602 
603     function blockNumber() public view returns (uint256) {
604         return block.number;
605     }
606 }