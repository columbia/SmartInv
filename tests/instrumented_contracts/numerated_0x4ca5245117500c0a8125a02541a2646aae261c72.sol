1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 /**
6  * @dev Interface of the ERC20 standard as defined in the EIP.
7  */
8 interface IERC20 {
9     /**
10      * @dev Returns the amount of tokens in existence.
11      */
12     function totalSupply() external view returns (uint256);
13 
14     /**
15      * @dev Returns the amount of tokens owned by `account`.
16      */
17     function balanceOf(address account) external view returns (uint256);
18 
19     /**
20      * @dev Moves `amount` tokens from the caller's account to `recipient`.
21      *
22      * Returns a boolean value indicating whether the operation succeeded.
23      *
24      * Emits a {Transfer} event.
25      */
26     function transfer(address recipient, uint256 amount) external returns (bool);
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
62     function transferFrom(
63         address sender,
64         address recipient,
65         uint256 amount
66     ) external returns (bool);
67 
68     /**
69      * @dev Emitted when `value` tokens are moved from one account (`from`) to
70      * another (`to`).
71      *
72      * Note that `value` may be zero.
73      */
74     event Transfer(address indexed from, address indexed to, uint256 value);
75 
76     /**
77      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
78      * a call to {approve}. `value` is the new allowance.
79      */
80     event Approval(address indexed owner, address indexed spender, uint256 value);
81 }
82 
83 
84 
85 // MIT License
86 // Copyright (c) 2021 Bolt Global Media UK LTD
87 
88 /// @title BOLT Token 2021 Staking Contract
89 /// @author Bolt Global Media UK LTD
90 /// @notice Implementation of BOLT 2021 Fixed + Dynamic Staking
91 
92 
93 
94 
95 
96 
97 
98 
99 
100 
101 /**
102  * @dev Provides information about the current execution context, including the
103  * sender of the transaction and its data. While these are generally available
104  * via msg.sender and msg.data, they should not be accessed in such a direct
105  * manner, since when dealing with meta-transactions the account sending and
106  * paying for execution may not be the actual sender (as far as an application
107  * is concerned).
108  *
109  * This contract is only required for intermediate, library-like contracts.
110  */
111 abstract contract Context {
112     function _msgSender() internal view virtual returns (address) {
113         return msg.sender;
114     }
115 
116     function _msgData() internal view virtual returns (bytes calldata) {
117         return msg.data;
118     }
119 }
120 
121 
122 /**
123  * @dev Contract module which provides a basic access control mechanism, where
124  * there is an account (an owner) that can be granted exclusive access to
125  * specific functions.
126  *
127  * By default, the owner account will be the one that deploys the contract. This
128  * can later be changed with {transferOwnership}.
129  *
130  * This module is used through inheritance. It will make available the modifier
131  * `onlyOwner`, which can be applied to your functions to restrict their use to
132  * the owner.
133  */
134 abstract contract Ownable is Context {
135     address private _owner;
136 
137     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
138 
139     /**
140      * @dev Initializes the contract setting the deployer as the initial owner.
141      */
142     constructor() {
143         _setOwner(_msgSender());
144     }
145 
146     /**
147      * @dev Returns the address of the current owner.
148      */
149     function owner() public view virtual returns (address) {
150         return _owner;
151     }
152 
153     /**
154      * @dev Throws if called by any account other than the owner.
155      */
156     modifier onlyOwner() {
157         require(owner() == _msgSender(), "Ownable: caller is not the owner");
158         _;
159     }
160 
161     /**
162      * @dev Leaves the contract without owner. It will not be possible to call
163      * `onlyOwner` functions anymore. Can only be called by the current owner.
164      *
165      * NOTE: Renouncing ownership will leave the contract without an owner,
166      * thereby removing any functionality that is only available to the owner.
167      */
168     function renounceOwnership() public virtual onlyOwner {
169         _setOwner(address(0));
170     }
171 
172     /**
173      * @dev Transfers ownership of the contract to a new account (`newOwner`).
174      * Can only be called by the current owner.
175      */
176     function transferOwnership(address newOwner) public virtual onlyOwner {
177         require(newOwner != address(0), "Ownable: new owner is the zero address");
178         _setOwner(newOwner);
179     }
180 
181     function _setOwner(address newOwner) private {
182         address oldOwner = _owner;
183         _owner = newOwner;
184         emit OwnershipTransferred(oldOwner, newOwner);
185     }
186 }
187 
188 
189 
190 
191 
192 
193 
194 
195 
196 
197 /**
198  * @dev Collection of functions related to the address type
199  */
200 library Address {
201     /**
202      * @dev Returns true if `account` is a contract.
203      *
204      * [IMPORTANT]
205      * ====
206      * It is unsafe to assume that an address for which this function returns
207      * false is an externally-owned account (EOA) and not a contract.
208      *
209      * Among others, `isContract` will return false for the following
210      * types of addresses:
211      *
212      *  - an externally-owned account
213      *  - a contract in construction
214      *  - an address where a contract will be created
215      *  - an address where a contract lived, but was destroyed
216      * ====
217      */
218     function isContract(address account) internal view returns (bool) {
219         // This method relies on extcodesize, which returns 0 for contracts in
220         // construction, since the code is only stored at the end of the
221         // constructor execution.
222 
223         uint256 size;
224         assembly {
225             size := extcodesize(account)
226         }
227         return size > 0;
228     }
229 
230     /**
231      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
232      * `recipient`, forwarding all available gas and reverting on errors.
233      *
234      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
235      * of certain opcodes, possibly making contracts go over the 2300 gas limit
236      * imposed by `transfer`, making them unable to receive funds via
237      * `transfer`. {sendValue} removes this limitation.
238      *
239      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
240      *
241      * IMPORTANT: because control is transferred to `recipient`, care must be
242      * taken to not create reentrancy vulnerabilities. Consider using
243      * {ReentrancyGuard} or the
244      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
245      */
246     function sendValue(address payable recipient, uint256 amount) internal {
247         require(address(this).balance >= amount, "Address: insufficient balance");
248 
249         (bool success, ) = recipient.call{value: amount}("");
250         require(success, "Address: unable to send value, recipient may have reverted");
251     }
252 
253     /**
254      * @dev Performs a Solidity function call using a low level `call`. A
255      * plain `call` is an unsafe replacement for a function call: use this
256      * function instead.
257      *
258      * If `target` reverts with a revert reason, it is bubbled up by this
259      * function (like regular Solidity function calls).
260      *
261      * Returns the raw returned data. To convert to the expected return value,
262      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
263      *
264      * Requirements:
265      *
266      * - `target` must be a contract.
267      * - calling `target` with `data` must not revert.
268      *
269      * _Available since v3.1._
270      */
271     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
272         return functionCall(target, data, "Address: low-level call failed");
273     }
274 
275     /**
276      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
277      * `errorMessage` as a fallback revert reason when `target` reverts.
278      *
279      * _Available since v3.1._
280      */
281     function functionCall(
282         address target,
283         bytes memory data,
284         string memory errorMessage
285     ) internal returns (bytes memory) {
286         return functionCallWithValue(target, data, 0, errorMessage);
287     }
288 
289     /**
290      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
291      * but also transferring `value` wei to `target`.
292      *
293      * Requirements:
294      *
295      * - the calling contract must have an ETH balance of at least `value`.
296      * - the called Solidity function must be `payable`.
297      *
298      * _Available since v3.1._
299      */
300     function functionCallWithValue(
301         address target,
302         bytes memory data,
303         uint256 value
304     ) internal returns (bytes memory) {
305         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
306     }
307 
308     /**
309      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
310      * with `errorMessage` as a fallback revert reason when `target` reverts.
311      *
312      * _Available since v3.1._
313      */
314     function functionCallWithValue(
315         address target,
316         bytes memory data,
317         uint256 value,
318         string memory errorMessage
319     ) internal returns (bytes memory) {
320         require(address(this).balance >= value, "Address: insufficient balance for call");
321         require(isContract(target), "Address: call to non-contract");
322 
323         (bool success, bytes memory returndata) = target.call{value: value}(data);
324         return verifyCallResult(success, returndata, errorMessage);
325     }
326 
327     /**
328      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
329      * but performing a static call.
330      *
331      * _Available since v3.3._
332      */
333     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
334         return functionStaticCall(target, data, "Address: low-level static call failed");
335     }
336 
337     /**
338      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
339      * but performing a static call.
340      *
341      * _Available since v3.3._
342      */
343     function functionStaticCall(
344         address target,
345         bytes memory data,
346         string memory errorMessage
347     ) internal view returns (bytes memory) {
348         require(isContract(target), "Address: static call to non-contract");
349 
350         (bool success, bytes memory returndata) = target.staticcall(data);
351         return verifyCallResult(success, returndata, errorMessage);
352     }
353 
354     /**
355      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
356      * but performing a delegate call.
357      *
358      * _Available since v3.4._
359      */
360     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
361         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
362     }
363 
364     /**
365      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
366      * but performing a delegate call.
367      *
368      * _Available since v3.4._
369      */
370     function functionDelegateCall(
371         address target,
372         bytes memory data,
373         string memory errorMessage
374     ) internal returns (bytes memory) {
375         require(isContract(target), "Address: delegate call to non-contract");
376 
377         (bool success, bytes memory returndata) = target.delegatecall(data);
378         return verifyCallResult(success, returndata, errorMessage);
379     }
380 
381     /**
382      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
383      * revert reason using the provided one.
384      *
385      * _Available since v4.3._
386      */
387     function verifyCallResult(
388         bool success,
389         bytes memory returndata,
390         string memory errorMessage
391     ) internal pure returns (bytes memory) {
392         if (success) {
393             return returndata;
394         } else {
395             // Look for revert reason and bubble it up if present
396             if (returndata.length > 0) {
397                 // The easiest way to bubble the revert reason is using memory via assembly
398 
399                 assembly {
400                     let returndata_size := mload(returndata)
401                     revert(add(32, returndata), returndata_size)
402                 }
403             } else {
404                 revert(errorMessage);
405             }
406         }
407     }
408 }
409 
410 
411 /**
412  * @title SafeERC20
413  * @dev Wrappers around ERC20 operations that throw on failure (when the token
414  * contract returns false). Tokens that return no value (and instead revert or
415  * throw on failure) are also supported, non-reverting calls are assumed to be
416  * successful.
417  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
418  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
419  */
420 library SafeERC20 {
421     using Address for address;
422 
423     function safeTransfer(
424         IERC20 token,
425         address to,
426         uint256 value
427     ) internal {
428         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
429     }
430 
431     function safeTransferFrom(
432         IERC20 token,
433         address from,
434         address to,
435         uint256 value
436     ) internal {
437         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
438     }
439 
440     /**
441      * @dev Deprecated. This function has issues similar to the ones found in
442      * {IERC20-approve}, and its usage is discouraged.
443      *
444      * Whenever possible, use {safeIncreaseAllowance} and
445      * {safeDecreaseAllowance} instead.
446      */
447     function safeApprove(
448         IERC20 token,
449         address spender,
450         uint256 value
451     ) internal {
452         // safeApprove should only be called when setting an initial allowance,
453         // or when resetting it to zero. To increase and decrease it, use
454         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
455         require(
456             (value == 0) || (token.allowance(address(this), spender) == 0),
457             "SafeERC20: approve from non-zero to non-zero allowance"
458         );
459         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
460     }
461 
462     function safeIncreaseAllowance(
463         IERC20 token,
464         address spender,
465         uint256 value
466     ) internal {
467         uint256 newAllowance = token.allowance(address(this), spender) + value;
468         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
469     }
470 
471     function safeDecreaseAllowance(
472         IERC20 token,
473         address spender,
474         uint256 value
475     ) internal {
476         unchecked {
477             uint256 oldAllowance = token.allowance(address(this), spender);
478             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
479             uint256 newAllowance = oldAllowance - value;
480             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
481         }
482     }
483 
484     /**
485      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
486      * on the return value: the return value is optional (but if data is returned, it must not be false).
487      * @param token The token targeted by the call.
488      * @param data The call data (encoded using abi.encode or one of its variants).
489      */
490     function _callOptionalReturn(IERC20 token, bytes memory data) private {
491         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
492         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
493         // the target address contains contract code and also asserts for success in the low-level call.
494 
495         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
496         if (returndata.length > 0) {
497             // Return data is optional
498             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
499         }
500     }
501 }
502 
503 
504 contract StakeBoltToken is Ownable {
505     using SafeERC20 for IERC20;
506 
507     // Per Account staking data structure
508     struct stakingInfo {
509         uint128 amount; // Amount of tokens staked by the account
510         uint128 unclaimedDynReward; // Allocated but Unclaimed dynamic reward
511         uint128 maxObligation; // The fixed reward obligation, assuming user holds until contract expiry.
512         uint32 lastClaimTime; // used for delta time for claims
513     }
514 
515     mapping(address => stakingInfo) userStakes;
516 
517     // **** Constants set in Constructor ****
518     // ERC-20 Token we are staking
519     IERC20 immutable token;
520 
521     // Timestamp of when staking rewards start, contract expires "rewardLifetime" after this.
522     uint32 rewardStartTime;
523 
524     // Reward period of the contract
525     uint32 immutable rewardLifetime;
526 
527     // Fixed APR, expressed in Basis Points (BPS - 0.01%)
528     uint32 immutable fixedAPR;
529 
530     // max allowable number of tokens that can be Staked to the contract by all users
531     // if exceeded - abort the txn
532     uint128 immutable maxTokensStakable;
533 
534     //total number of tokens that has been staked by all the users.
535     uint128 totalTokensStaked;
536 
537     //tokens remaining to be distributed among stake holders - initially deposited by the contract owner
538     uint128 public fixedRewardsAvailable;
539 
540     // Total dynamic tokens deposited, but not yet allocated
541     uint128 public dynamicTokensToAllocate;
542 
543     // Total of the fixed staking obligation (unclaimed tokens) to stakers, assuming they stake until the contract expires.
544     // This amount is adjusted with each stake/unstake.
545     uint128 fixedObligation;
546 
547     // Total Dynamic Tokens across all wallets
548     uint128 public dynamicTokensAllocated;
549 
550     /// @notice Persist initial state on construction
551     /// @param _tokenAddr contract address of the token being staked
552     /// @param _maxStakable Maximum number of tokens stakable by the contract in basic units
553     constructor(address _tokenAddr, uint128 _maxStakable) {
554         token = IERC20(_tokenAddr);
555         maxTokensStakable = _maxStakable;
556         rewardLifetime = 365 days;
557         fixedAPR = 500; // 5% in Basis Points
558         rewardStartTime = 0; // Rewards are not started immediately
559     }
560 
561     /// @notice Initiates the reward generation period
562     /// @dev contract & rewards finish "rewardLifetime" after this.
563     /// @return Starting Timestamp
564     function setRewardStartTime() external onlyOwner returns (uint256) {
565         require(rewardStartTime == 0, "Rewards already started");
566 
567         rewardStartTime = uint32(block.timestamp);
568         return rewardStartTime;
569     }
570 
571     /// @notice User function for staking tokens
572     /// @param _amount Number of tokens to stake in basic units (n * 10**decimals)
573     function stake(uint128 _amount) external {
574         require(
575             (rewardStartTime == 0) ||
576                 (block.timestamp <= rewardStartTime + rewardLifetime),
577             "Staking period is over"
578         );
579 
580         require(
581             totalTokensStaked + _amount <= maxTokensStakable,
582             "Max staking limit exceeded"
583         );
584 
585         // Use .lastClaimTime == 0 as test for Account existence - initialise if a new address
586         if (userStakes[msg.sender].lastClaimTime == 0) {
587             userStakes[msg.sender].lastClaimTime = uint32(block.timestamp);
588         }
589 
590         _claim(); //must claim before updating amount
591         userStakes[msg.sender].amount += _amount;
592         totalTokensStaked += _amount;
593 
594         _updateFixedObligation(msg.sender);
595 
596         token.safeTransferFrom(msg.sender, address(this), _amount);
597         emit StakeTokens(msg.sender, _amount);
598     }
599 
600     /// @notice Unstake tokens from the contract. Unstaking will also trigger a claim of all allocated rewards.
601     /// @dev remaining tokens after unstake will accrue rewards based on the new balance.
602     /// @param _amount Number of tokens to stake in basic units (n * 10**decimals)
603     function unstake(uint128 _amount) external {
604         require(userStakes[msg.sender].amount > 0, "Nothing to unstake");
605         require(
606             _amount <= userStakes[msg.sender].amount,
607             "Unstake Amount greater than Stake"
608         );
609         _claim();
610         userStakes[msg.sender].amount -= _amount;
611         totalTokensStaked -= _amount;
612         _updateFixedObligation(msg.sender);
613 
614         token.safeTransfer(msg.sender, _amount);
615         emit UnstakeTokens(msg.sender, _amount);
616     }
617 
618     /// @notice Claim all outstanding rewards from the contract
619     function claim() external {
620         require(
621             rewardStartTime != 0,
622             "Nothing to claim, Rewards have not yet started"
623         );
624         _claim();
625         _updateFixedObligation(msg.sender);
626     }
627 
628     /// @notice Update the end of contract obligation (user and Total)
629     /// @dev This obligation determines the number of tokens claimable by owner at end of contract
630     /// @param _address The address to update
631     function _updateFixedObligation(address _address) private {
632         // Use the entire rewardlifetime if rewards have not yet started
633         uint128 newMaxObligation;
634         uint128 effectiveTime;
635 
636         if (rewardStartTime == 0) {
637             effectiveTime = 0;
638         } else if (
639             uint128(block.timestamp) > rewardStartTime + rewardLifetime
640         ) {
641             effectiveTime = rewardStartTime + rewardLifetime;
642         } else {
643             effectiveTime = uint128(block.timestamp);
644         }
645 
646         newMaxObligation =
647             (((userStakes[_address].amount * fixedAPR) / 10000) *
648                 (rewardStartTime + rewardLifetime - effectiveTime)) /
649             rewardLifetime;
650 
651         // Adjust the total obligation
652         fixedObligation =
653             fixedObligation -
654             userStakes[_address].maxObligation +
655             newMaxObligation;
656         userStakes[_address].maxObligation = newMaxObligation;
657     }
658 
659     /// @notice private claim all accumulated outstanding tokens back to the callers wallet
660     function _claim() private {
661         // Return with no action if the staking period has not commenced yet.
662         if (rewardStartTime == 0) {
663             return;
664         }
665 
666         uint32 lastClaimTime = userStakes[msg.sender].lastClaimTime;
667 
668         // If the user staked before the start time was set, update the stake time to be the now known start Time
669         if (lastClaimTime < rewardStartTime) {
670             lastClaimTime = rewardStartTime;
671         }
672 
673         // Calculation includes Fixed 5% APR + Dynamic
674 
675         // Adjust claim time to never exceed the reward end date
676         uint32 claimTime = (block.timestamp < rewardStartTime + rewardLifetime)
677             ? uint32(block.timestamp)
678             : rewardStartTime + rewardLifetime;
679 
680         uint128 fixedClaimAmount = (((userStakes[msg.sender].amount *
681             fixedAPR) / 10000) * (claimTime - lastClaimTime)) / rewardLifetime;
682 
683         uint128 dynamicClaimAmount = userStakes[msg.sender].unclaimedDynReward;
684         dynamicTokensAllocated -= dynamicClaimAmount;
685 
686         uint128 totalClaim = fixedClaimAmount + dynamicClaimAmount;
687 
688         require(
689             fixedRewardsAvailable >= fixedClaimAmount,
690             "Insufficient Fixed Rewards available"
691         );
692 
693         if (totalClaim > 0) {
694             token.safeTransfer(msg.sender, totalClaim);
695         }
696 
697         if (fixedClaimAmount > 0) {
698             fixedRewardsAvailable -= uint128(fixedClaimAmount); // decrease the tokens remaining to reward
699         }
700         userStakes[msg.sender].lastClaimTime = uint32(claimTime);
701 
702         if (dynamicClaimAmount > 0) {
703             userStakes[msg.sender].unclaimedDynReward = 0;
704         }
705         // _updateFixedObligation(msg.sender); - refactored into stake, claim, unstake
706 
707         emit ClaimReward(msg.sender, fixedClaimAmount, dynamicClaimAmount);
708     }
709 
710     /// Deposit tokens for the current epoch's dynamic reward, then Allocate at end of epoch
711     /// Step 1 depositDynamicReward
712     /// Step 2 allocatDynamicReward
713 
714     /// @notice owner Deposit deposit of dynamic reward for later Allocation
715     /// @param _amount Number of tokens to deposit in basic units (n * 10**decimals)
716     function depositDynamicReward(uint128 _amount) external onlyOwner {
717         token.safeTransferFrom(msg.sender, address(this), _amount);
718 
719         dynamicTokensToAllocate += _amount;
720 
721         emit DepositDynamicReward(msg.sender, _amount);
722     }
723 
724     /// Step 2 - each week, an off-chain process will call this function to allocate the rewards to the staked wallets
725     /// A robust mechanism is required to be sure all addresses are allocated funds and that the allocation matches the tokens
726     ///  previously deposited (in step 1)
727     /// Multiple calls may be made per round if necessary (e.g. if the arrays grow too big)
728     /// @param _addresses[] Array of addresses to receive
729     /// @param _amounts[] Number of tokens to deposit in basic units (n * 10**decimals)
730     /// @param _totalAmount total number of tokens to Allocate in this call
731     function allocateDynamicReward(
732         address[] memory _addresses,
733         uint128[] memory _amounts,
734         uint128 _totalAmount
735     ) external onlyOwner {
736         uint256 _calcdTotal = 0;
737 
738         require(
739             _addresses.length == _amounts.length,
740             "_addresses[] and _amounts[] must be the same length"
741         );
742         require(
743             dynamicTokensToAllocate >= _totalAmount,
744             "Not enough tokens available to allocate"
745         );
746 
747         for (uint256 i = 0; i < _addresses.length; i++) {
748             userStakes[_addresses[i]].unclaimedDynReward += _amounts[i];
749             _calcdTotal += _amounts[i];
750         }
751         require(
752             _calcdTotal == _totalAmount,
753             "Sum of amounts does not equal total"
754         );
755 
756         dynamicTokensToAllocate -= _totalAmount; // adjust remaining balance to allocate
757 
758         // ToDo - Remove after testing
759         dynamicTokensAllocated += _totalAmount;
760     }
761 
762     /// @notice Team deposit of the Fixed staking reward for later distribution
763     /// @notice This transfer is intended be done once, in full, before the commencement of the staking period
764     /// @param _amount Number of tokens to deposit in basic units (n * 10**decimals)
765     function depositFixedReward(uint128 _amount)
766         external
767         onlyOwner
768         returns (uint128)
769     {
770         fixedRewardsAvailable += _amount;
771 
772         token.safeTransferFrom(msg.sender, address(this), _amount);
773 
774         emit DepositFixedReward(msg.sender, _amount);
775 
776         return fixedRewardsAvailable;
777     }
778 
779     /// @notice Withdraw unused Fixed reward tokens, deposited at the beginning of the contract period.
780     /// @notice Withdrawal is allowed only after the contract period has elapsed and then only allow withdrawal of unallocated tokens.
781     function withdrawFixedReward() external onlyOwner returns (uint256) {
782         require(
783             block.timestamp > rewardStartTime + rewardLifetime,
784             "Staking period is not yet over"
785         );
786         require(
787             fixedRewardsAvailable >= fixedObligation,
788             "Insufficient Fixed Rewards available"
789         );
790         uint128 tokensToWithdraw = fixedRewardsAvailable - fixedObligation;
791 
792         fixedRewardsAvailable -= tokensToWithdraw;
793 
794         token.safeTransfer(msg.sender, tokensToWithdraw);
795 
796         emit WithdrawFixedReward(msg.sender, tokensToWithdraw);
797 
798         return tokensToWithdraw;
799     }
800 
801     //Inspection methods
802 
803     // Contract Inspection methods
804     function getRewardStartTime() external view returns (uint256) {
805         return rewardStartTime;
806     }
807 
808     function getMaxStakingLimit() public view returns (uint256) {
809         return maxTokensStakable;
810     }
811 
812     function getRewardLifetime() public view returns (uint256) {
813         return rewardLifetime;
814     }
815 
816     function getTotalStaked() external view  returns (uint256) {
817         return totalTokensStaked;
818     }
819 
820     function getFixedObligation() public view returns (uint256) {
821         return fixedObligation;
822     }
823 
824     // Account Inspection Methods
825     function getTokensStaked(address _addr) public view returns (uint256) {
826         return userStakes[_addr].amount;
827     }
828 
829     function getStakedPercentage(address _addr)
830         public
831         view
832         returns (uint256, uint256)
833     {
834         return (totalTokensStaked, userStakes[_addr].amount);
835     }
836 
837     function getStakeInfo(address _addr)
838         public
839         view
840         returns (
841             uint128 amount, // Amount of tokens staked by the account
842             uint128 unclaimedFixedReward, // Allocated but Unclaimed fixed reward
843             uint128 unclaimedDynReward, // Allocated but Unclaimed dynamic reward
844             uint128 maxObligation, // The fixed reward obligation, assuming user holds until contract expiry.
845             uint32 lastClaimTime, // used for delta time for claims
846             uint32 claimtime // show the effective claim time
847         )
848     {
849         //added to view the dynamic obligation asso. with addr.
850         uint128 fixedClaimAmount;
851         uint32 claimTime;
852         stakingInfo memory s = userStakes[_addr];
853         if (rewardStartTime > 0) {
854             claimTime = (block.timestamp < rewardStartTime + rewardLifetime)
855                 ? uint32(block.timestamp)
856                 : rewardStartTime + rewardLifetime;
857 
858             fixedClaimAmount =
859                 (((s.amount * fixedAPR) / 10000) *
860                     (claimTime - s.lastClaimTime)) /
861                 rewardLifetime;
862         } else {
863             // rewards have not started
864             fixedClaimAmount = 0;
865         }
866 
867         return (
868             s.amount,
869             fixedClaimAmount,
870             s.unclaimedDynReward,
871             s.maxObligation,
872             s.lastClaimTime,
873             claimTime
874         );
875     }
876 
877     function getStakeTokenAddress() public view returns (IERC20) {
878         return token;
879     }
880 
881     // Events
882     event DepositFixedReward(address indexed from, uint256 amount);
883     event DepositDynamicReward(address indexed from, uint256 amount);
884     event WithdrawFixedReward(address indexed to, uint256 amount);
885 
886     event StakeTokens(address indexed from, uint256 amount);
887     event UnstakeTokens(address indexed to, uint256 amount);
888     event ClaimReward(
889         address indexed to,
890         uint256 fixedAmount,
891         uint256 dynamicAmount
892     );
893 }