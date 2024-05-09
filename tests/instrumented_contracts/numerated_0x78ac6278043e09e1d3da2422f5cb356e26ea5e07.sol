1 // File: @openzeppelin/contracts/math/SafeMath.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity ^0.6.0;
6 
7 /**
8  * @dev Wrappers over Solidity's arithmetic operations with added overflow
9  * checks.
10  *
11  * Arithmetic operations in Solidity wrap on overflow. This can easily result
12  * in bugs, because programmers usually assume that an overflow raises an
13  * error, which is the standard behavior in high level programming languages.
14  * `SafeMath` restores this intuition by reverting the transaction when an
15  * operation overflows.
16  *
17  * Using this library instead of the unchecked operations eliminates an entire
18  * class of bugs, so it's recommended to use it always.
19  */
20 library SafeMath {
21     /**
22      * @dev Returns the addition of two unsigned integers, reverting on
23      * overflow.
24      *
25      * Counterpart to Solidity's `+` operator.
26      *
27      * Requirements:
28      *
29      * - Addition cannot overflow.
30      */
31     function add(uint256 a, uint256 b) internal pure returns (uint256) {
32         uint256 c = a + b;
33         require(c >= a, "SafeMath: addition overflow");
34 
35         return c;
36     }
37 
38     /**
39      * @dev Returns the subtraction of two unsigned integers, reverting on
40      * overflow (when the result is negative).
41      *
42      * Counterpart to Solidity's `-` operator.
43      *
44      * Requirements:
45      *
46      * - Subtraction cannot overflow.
47      */
48     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
49         return sub(a, b, "SafeMath: subtraction overflow");
50     }
51 
52     /**
53      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
54      * overflow (when the result is negative).
55      *
56      * Counterpart to Solidity's `-` operator.
57      *
58      * Requirements:
59      *
60      * - Subtraction cannot overflow.
61      */
62     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
63         require(b <= a, errorMessage);
64         uint256 c = a - b;
65 
66         return c;
67     }
68 
69     /**
70      * @dev Returns the multiplication of two unsigned integers, reverting on
71      * overflow.
72      *
73      * Counterpart to Solidity's `*` operator.
74      *
75      * Requirements:
76      *
77      * - Multiplication cannot overflow.
78      */
79     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
80         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
81         // benefit is lost if 'b' is also tested.
82         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
83         if (a == 0) {
84             return 0;
85         }
86 
87         uint256 c = a * b;
88         require(c / a == b, "SafeMath: multiplication overflow");
89 
90         return c;
91     }
92 
93     /**
94      * @dev Returns the integer division of two unsigned integers. Reverts on
95      * division by zero. The result is rounded towards zero.
96      *
97      * Counterpart to Solidity's `/` operator. Note: this function uses a
98      * `revert` opcode (which leaves remaining gas untouched) while Solidity
99      * uses an invalid opcode to revert (consuming all remaining gas).
100      *
101      * Requirements:
102      *
103      * - The divisor cannot be zero.
104      */
105     function div(uint256 a, uint256 b) internal pure returns (uint256) {
106         return div(a, b, "SafeMath: division by zero");
107     }
108 
109     /**
110      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
111      * division by zero. The result is rounded towards zero.
112      *
113      * Counterpart to Solidity's `/` operator. Note: this function uses a
114      * `revert` opcode (which leaves remaining gas untouched) while Solidity
115      * uses an invalid opcode to revert (consuming all remaining gas).
116      *
117      * Requirements:
118      *
119      * - The divisor cannot be zero.
120      */
121     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
122         require(b > 0, errorMessage);
123         uint256 c = a / b;
124         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
125 
126         return c;
127     }
128 
129     /**
130      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
131      * Reverts when dividing by zero.
132      *
133      * Counterpart to Solidity's `%` operator. This function uses a `revert`
134      * opcode (which leaves remaining gas untouched) while Solidity uses an
135      * invalid opcode to revert (consuming all remaining gas).
136      *
137      * Requirements:
138      *
139      * - The divisor cannot be zero.
140      */
141     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
142         return mod(a, b, "SafeMath: modulo by zero");
143     }
144 
145     /**
146      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
147      * Reverts with custom message when dividing by zero.
148      *
149      * Counterpart to Solidity's `%` operator. This function uses a `revert`
150      * opcode (which leaves remaining gas untouched) while Solidity uses an
151      * invalid opcode to revert (consuming all remaining gas).
152      *
153      * Requirements:
154      *
155      * - The divisor cannot be zero.
156      */
157     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
158         require(b != 0, errorMessage);
159         return a % b;
160     }
161 }
162 
163 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
164 
165 pragma solidity ^0.6.0;
166 
167 /**
168  * @dev Interface of the ERC20 standard as defined in the EIP.
169  */
170 interface IERC20 {
171     /**
172      * @dev Returns the amount of tokens in existence.
173      */
174     function totalSupply() external view returns (uint256);
175 
176     /**
177      * @dev Returns the amount of tokens owned by `account`.
178      */
179     function balanceOf(address account) external view returns (uint256);
180 
181     /**
182      * @dev Moves `amount` tokens from the caller's account to `recipient`.
183      *
184      * Returns a boolean value indicating whether the operation succeeded.
185      *
186      * Emits a {Transfer} event.
187      */
188     function transfer(address recipient, uint256 amount) external returns (bool);
189 
190     /**
191      * @dev Returns the remaining number of tokens that `spender` will be
192      * allowed to spend on behalf of `owner` through {transferFrom}. This is
193      * zero by default.
194      *
195      * This value changes when {approve} or {transferFrom} are called.
196      */
197     function allowance(address owner, address spender) external view returns (uint256);
198 
199     /**
200      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
201      *
202      * Returns a boolean value indicating whether the operation succeeded.
203      *
204      * IMPORTANT: Beware that changing an allowance with this method brings the risk
205      * that someone may use both the old and the new allowance by unfortunate
206      * transaction ordering. One possible solution to mitigate this race
207      * condition is to first reduce the spender's allowance to 0 and set the
208      * desired value afterwards:
209      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
210      *
211      * Emits an {Approval} event.
212      */
213     function approve(address spender, uint256 amount) external returns (bool);
214 
215     /**
216      * @dev Moves `amount` tokens from `sender` to `recipient` using the
217      * allowance mechanism. `amount` is then deducted from the caller's
218      * allowance.
219      *
220      * Returns a boolean value indicating whether the operation succeeded.
221      *
222      * Emits a {Transfer} event.
223      */
224     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
225 
226     /**
227      * @dev Emitted when `value` tokens are moved from one account (`from`) to
228      * another (`to`).
229      *
230      * Note that `value` may be zero.
231      */
232     event Transfer(address indexed from, address indexed to, uint256 value);
233 
234     /**
235      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
236      * a call to {approve}. `value` is the new allowance.
237      */
238     event Approval(address indexed owner, address indexed spender, uint256 value);
239 }
240 
241 // File: @openzeppelin/contracts/utils/Address.sol
242 
243 pragma solidity ^0.6.2;
244 
245 /**
246  * @dev Collection of functions related to the address type
247  */
248 library Address {
249     /**
250      * @dev Returns true if `account` is a contract.
251      *
252      * [IMPORTANT]
253      * ====
254      * It is unsafe to assume that an address for which this function returns
255      * false is an externally-owned account (EOA) and not a contract.
256      *
257      * Among others, `isContract` will return false for the following
258      * types of addresses:
259      *
260      *  - an externally-owned account
261      *  - a contract in construction
262      *  - an address where a contract will be created
263      *  - an address where a contract lived, but was destroyed
264      * ====
265      */
266     function isContract(address account) internal view returns (bool) {
267         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
268         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
269         // for accounts without code, i.e. `keccak256('')`
270         bytes32 codehash;
271         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
272         // solhint-disable-next-line no-inline-assembly
273         assembly { codehash := extcodehash(account) }
274         return (codehash != accountHash && codehash != 0x0);
275     }
276 
277     /**
278      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
279      * `recipient`, forwarding all available gas and reverting on errors.
280      *
281      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
282      * of certain opcodes, possibly making contracts go over the 2300 gas limit
283      * imposed by `transfer`, making them unable to receive funds via
284      * `transfer`. {sendValue} removes this limitation.
285      *
286      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
287      *
288      * IMPORTANT: because control is transferred to `recipient`, care must be
289      * taken to not create reentrancy vulnerabilities. Consider using
290      * {ReentrancyGuard} or the
291      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
292      */
293     function sendValue(address payable recipient, uint256 amount) internal {
294         require(address(this).balance >= amount, "Address: insufficient balance");
295 
296         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
297         (bool success, ) = recipient.call{ value: amount }("");
298         require(success, "Address: unable to send value, recipient may have reverted");
299     }
300 
301     /**
302      * @dev Performs a Solidity function call using a low level `call`. A
303      * plain`call` is an unsafe replacement for a function call: use this
304      * function instead.
305      *
306      * If `target` reverts with a revert reason, it is bubbled up by this
307      * function (like regular Solidity function calls).
308      *
309      * Returns the raw returned data. To convert to the expected return value,
310      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
311      *
312      * Requirements:
313      *
314      * - `target` must be a contract.
315      * - calling `target` with `data` must not revert.
316      *
317      * _Available since v3.1._
318      */
319     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
320       return functionCall(target, data, "Address: low-level call failed");
321     }
322 
323     /**
324      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
325      * `errorMessage` as a fallback revert reason when `target` reverts.
326      *
327      * _Available since v3.1._
328      */
329     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
330         return _functionCallWithValue(target, data, 0, errorMessage);
331     }
332 
333     /**
334      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
335      * but also transferring `value` wei to `target`.
336      *
337      * Requirements:
338      *
339      * - the calling contract must have an ETH balance of at least `value`.
340      * - the called Solidity function must be `payable`.
341      *
342      * _Available since v3.1._
343      */
344     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
345         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
346     }
347 
348     /**
349      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
350      * with `errorMessage` as a fallback revert reason when `target` reverts.
351      *
352      * _Available since v3.1._
353      */
354     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
355         require(address(this).balance >= value, "Address: insufficient balance for call");
356         return _functionCallWithValue(target, data, value, errorMessage);
357     }
358 
359     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
360         require(isContract(target), "Address: call to non-contract");
361 
362         // solhint-disable-next-line avoid-low-level-calls
363         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
364         if (success) {
365             return returndata;
366         } else {
367             // Look for revert reason and bubble it up if present
368             if (returndata.length > 0) {
369                 // The easiest way to bubble the revert reason is using memory via assembly
370 
371                 // solhint-disable-next-line no-inline-assembly
372                 assembly {
373                     let returndata_size := mload(returndata)
374                     revert(add(32, returndata), returndata_size)
375                 }
376             } else {
377                 revert(errorMessage);
378             }
379         }
380     }
381 }
382 
383 // File: contracts/Ownable.sol
384 
385 pragma solidity 0.6.10;
386 
387 /**
388  * @title Ownable
389  * @dev The Ownable contract has an owner address, and provides basic authorization control
390  * functions, this simplifies the implementation of "user permissions".
391  */
392 contract Ownable {
393     address private _owner;
394 
395     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
396 
397     /**
398      * @dev The Ownable constructor sets the original `owner` of the contract to the a
399      * specified account.
400      * @param initalOwner The address of the inital owner.
401      */
402     constructor(address initalOwner) internal {
403         _owner = initalOwner;
404         emit OwnershipTransferred(address(0), _owner);
405     }
406 
407     /**
408      * @return the address of the owner.
409      */
410     function owner() public view returns (address) {
411         return _owner;
412     }
413 
414     /**
415      * @dev Throws if called by any account other than the owner.
416      */
417     modifier onlyOwner() {
418         require(isOwner(), "Only owner can call");
419         _;
420     }
421 
422     /**
423      * @return true if `msg.sender` is the owner of the contract.
424      */
425     function isOwner() public view returns (bool) {
426         return msg.sender == _owner;
427     }
428 
429     /**
430      * @dev Allows the current owner to relinquish control of the contract.
431      * It will not be possible to call the functions with the `onlyOwner`
432      * modifier anymore.
433      * @notice Renouncing ownership will leave the contract without an owner,
434      * thereby removing any functionality that is only available to the owner.
435      */
436     function renounceOwnership() public onlyOwner {
437         emit OwnershipTransferred(_owner, address(0));
438         _owner = address(0);
439     }
440 
441     /**
442      * @dev Allows the current owner to transfer control of the contract to a newOwner.
443      * @param newOwner The address to transfer ownership to.
444      */
445     function transferOwnership(address newOwner) public onlyOwner {
446         _transferOwnership(newOwner);
447     }
448 
449     /**
450      * @dev Transfers control of the contract to a newOwner.
451      * @param newOwner The address to transfer ownership to.
452      */
453     function _transferOwnership(address newOwner) internal {
454         require(newOwner != address(0), "Owner should not be 0 address");
455         emit OwnershipTransferred(_owner, newOwner);
456         _owner = newOwner;
457     }
458 }
459 
460 // File: contracts/TokenPool.sol
461 
462 pragma solidity 0.6.10;
463 
464 
465 
466 /**
467  * @title A simple holder of tokens.
468  * This is a simple contract to hold tokens. It's useful in the case where a separate contract
469  * needs to hold multiple distinct pools of the same token.
470  */
471 contract TokenPool is Ownable {
472     IERC20 public token;
473 
474     constructor(IERC20 _token) Ownable(msg.sender) public {
475         token = _token;
476     }
477 
478     function balance() public view returns (uint256) {
479         return token.balanceOf(address(this));
480     }
481 
482     function transfer(address to, uint256 value) external onlyOwner returns (bool) {
483         return token.transfer(to, value);
484     }
485 }
486 
487 // File: contracts/AbstractStaking.sol
488 
489 pragma solidity 0.6.10;
490 
491 
492 
493 
494 
495 
496 /**
497  * @title Abstract Staking
498  * @dev Skeleton of the staking pool for user to stake Balancer BPT token and get bella as reward.
499  */
500 abstract contract AbstractStaking is Ownable {
501     using SafeMath for uint256;
502 
503     event Staked(address indexed user, uint256 amount);
504     event Unstaked(address indexed user, uint256 amount);
505     event Claimed(address indexed user, uint256 amount);
506 
507     TokenPool public stakingPool;
508     TokenPool public lockedPool;
509     TokenPool public unlockedPool;
510 
511     uint256 public startTime;
512 
513     //
514     // Global state
515     //
516     uint256 public totalStakingAmount;
517     uint256 public totalStakingAmountTime; // total time * amount staked
518     uint256 public lastUpdatedTimestamp;
519 
520     //
521     // Addional bella locking related
522     //
523     uint256 public currentUnlockCycle; // linear count down to release bella token
524     uint256 public lastUnlockTime;
525 
526     /**
527      * @param stakingBPT The BPT token users deposit as stake.
528      * @param bellaToken The bonus token is bella.
529      * @param admin The admin address
530      * @param _startTime Timestamp that user can stake
531      */
532     constructor(
533         IERC20 stakingBPT,
534         IERC20 bellaToken,
535         address admin,
536         uint256 _startTime
537         ) Ownable(admin) 
538         internal {
539         stakingPool = new TokenPool(stakingBPT);
540         lockedPool = new TokenPool(bellaToken);
541         unlockedPool = new TokenPool(bellaToken);
542         startTime = _startTime;
543     }
544 
545     /**
546      * @return The user's total staking BPT amount
547      */
548     function totalStakedFor(address user) public view virtual returns (uint256);
549 
550     function totalStaked() public view returns (uint256) {
551         return totalStakingAmount;
552     }
553 
554     /**
555      * @dev Stake for the user self
556      * @param amount The amount of BPT tokens that the user wishes to stake
557      */
558     function stake(uint256 amount) external {
559         require(!Address.isContract(msg.sender), "No harvest thanks");
560         require(now >= startTime, "not started yet");
561         _stake(msg.sender, msg.sender, amount);
562     }
563 
564     /**
565      * @return User's total rewards when clamining
566      */
567     function totalRewards() external view returns (uint256) {
568         return _totalRewardsFor(msg.sender);
569     }
570 
571     /**
572      * @return A specific user's total rewards when clamining
573      */
574     function totalRewardsFor(address user) external view returns (uint256) {
575         return _totalRewardsFor(user);
576     }
577 
578     /**
579      * @dev Claim=withdraw all the bella rewards
580      */
581     function claim() external {
582         require(!Address.isContract(msg.sender), "No harvest thanks");
583         // cumulate user and global time*amount
584         _updateTotalStaking(0);
585         _updateUserStaking(0, msg.sender);
586 
587         _poolUnlock();
588 
589         uint256 reward = _calculateRewardAndBurnAll(msg.sender);
590 
591         unlockedPool.transfer(msg.sender, reward);
592 
593         emit Claimed(msg.sender, reward);
594     }
595 
596     /**
597      * @dev Claim=withdraw all the bella rewards and the staking BPT token,
598      * which stops the user's staking
599      */
600     function claimAndUnstake() external {
601         require(!Address.isContract(msg.sender), "No harvest thanks");
602         // cumulate user and global time*amount
603         _updateTotalStaking(0);
604         _updateUserStaking(0, msg.sender);
605 
606         _poolUnlock();
607 
608         (uint256 staking, uint256 reward) = _calculateRewardAndCleanUser(msg.sender);
609 
610         unlockedPool.transfer(msg.sender, reward);
611         stakingPool.transfer(msg.sender, staking);
612 
613         emit Claimed(msg.sender, reward);
614         emit Unstaked(msg.sender, staking);
615     }
616 
617     /**
618      * @dev we will lock more bella tokens on the begining of the next releasing cycle
619      * @param amount the amount of bella token to lock
620      * @param nextUnlockCycle next reward releasing cycle, unit=day
621      */
622     function lock(uint256 amount, uint256 nextUnlockCycle) external onlyOwner {
623         currentUnlockCycle = nextUnlockCycle * 1 days;
624         if (now >= startTime) {
625             lastUnlockTime = now;
626         } else {
627             lastUnlockTime = startTime;
628         }
629             
630         require(
631             lockedPool.token().transferFrom(msg.sender, address(lockedPool), amount),
632             "Additional bella transfer failed"
633         );
634     }
635 
636     /**
637      * @dev Actual logic to handle user staking
638      * @param from The user who pays the staking BPT
639      * @param beneficiary The user who actually controls the staking BPT
640      * @param amount The amount of BPT tokens to stake
641      */
642     function _stake(address from, address beneficiary, uint256 amount) private {
643         require(amount > 0, "can not stake 0 token");
644         require(
645             stakingPool.token().transferFrom(from, address(stakingPool), amount),
646             "Staking BPT transfer failed"
647         );
648 
649         _updateUserStaking(amount, beneficiary);
650 
651         _updateTotalStaking(amount);
652 
653         emit Staked(beneficiary, amount);
654     }
655 
656     /**
657      * @dev Update the global state due to more time cumulated and/or new BPT staking token
658      * @param amount New BPT staking deposited (can be 0)
659      */
660     function _updateTotalStaking(uint256 amount) private {
661         uint256 additionalAmountTime = totalStakingAmount.mul(now.sub(lastUpdatedTimestamp));
662         totalStakingAmount = totalStakingAmount.add(amount);
663         totalStakingAmountTime = totalStakingAmountTime.add(additionalAmountTime);
664         lastUpdatedTimestamp = now;
665     }
666 
667     /**
668      * @dev Update a specific user's state due to more time cumulated and/or new BPT staking token
669      * @param amount New BPT staking deposited (can be 0)
670      * @param user The account to be updated
671      */
672     function _updateUserStaking(uint256 amount, address user) internal virtual;
673 
674     /**
675      * @dev linear count down from 30 days to release bella token,
676      * from the locked pool to the unlocked pool
677      */
678     function _poolUnlock() private {
679         if (currentUnlockCycle == 0)
680             return; // release ended
681         uint256 timeDelta = now.sub(lastUnlockTime);
682         if (currentUnlockCycle < timeDelta)
683             currentUnlockCycle = timeDelta; // release all
684 
685         uint256 amount = lockedPool.balance().mul(timeDelta).div(currentUnlockCycle);
686 
687         currentUnlockCycle = currentUnlockCycle.sub(timeDelta);
688         lastUnlockTime = now;
689 
690         lockedPool.transfer(address(unlockedPool), amount);
691     }
692 
693     /**
694      * @dev Calculate user's total cumulated reward and burn his/her all staking amount*time
695      * @return User cumulated reward bella during the staking process
696      */
697     function _calculateRewardAndBurnAll(address user) internal virtual returns (uint256);
698 
699     /**
700      * @dev Calculate user's total cumulated reward and staking,
701      * and remove him/her from the staking process
702      * @return [1] User cumulated staking BPT
703      * @return [2] User cumulated reward bella during the staking process
704      */
705     function _calculateRewardAndCleanUser(address user) internal virtual returns (uint256, uint256);
706 
707     /**
708      * @dev Internal function to calculate user's total rewards
709      * @return A specific user's total rewards when clamining
710      */
711     function _totalRewardsFor(address user) internal view virtual returns (uint256);
712     
713 }
714 
715 // File: contracts/LinearStaking.sol
716 
717 pragma solidity 0.6.10;
718 
719 
720 
721 /**
722  * @title Linear Staking
723  * @dev A staking pool for user to stake Balancer BPT token and get bella as reward.
724  * The reward is always proportional to the amount*time of the staking.
725  * The reward is added by the admin at the 0th, 30th and 60th day, respectively.
726  */
727 contract LinearStaking is AbstractStaking {
728     using SafeMath for uint256;
729 
730     mapping(address=>Staking) public stakingInfo;
731 
732     struct Staking {
733         uint256 amount;
734         uint256 totalAmountTime; // staking amount*time
735         uint256 lastUpdatedTimestamp;
736     }
737 
738     /**
739      * @param stakingBPT The BPT token users deposit as stake.
740      * @param bellaToken The bonus token is bella.
741      * @param admin The admin address
742      * @param _startTime Timestamp that user can stake
743      */
744     constructor(
745         IERC20 stakingBPT,
746         IERC20 bellaToken,
747         address admin,
748         uint256 _startTime
749         ) AbstractStaking(
750             stakingBPT,
751             bellaToken,
752             admin,
753             _startTime
754         ) public {}
755 
756     /**
757      * @return The user's total staking BPT amount
758      */
759     function totalStakedFor(address user) public view override returns (uint256) {
760         return stakingInfo[user].amount;
761     }
762 
763     /**
764      * @dev Update a specific user's state due to more time cumulated and/or new BPT staking token
765      * @param amount New BPT staking deposited (can be 0)
766      * @param user The account to be updated
767      */
768     function _updateUserStaking(uint256 amount, address user) internal override {
769         Staking memory userInfo = stakingInfo[user];
770         uint256 additionalAmountTime = userInfo.amount.mul(now.sub(userInfo.lastUpdatedTimestamp));
771         userInfo.totalAmountTime = userInfo.totalAmountTime.add(additionalAmountTime);
772         userInfo.amount = userInfo.amount.add(amount);
773         userInfo.lastUpdatedTimestamp = now;
774         stakingInfo[user] = userInfo;
775     }
776 
777     /**
778      * @dev Calculate user's total cumulated reward and burn his/her all staking amount*time
779      * @return User cumulated reward bella during the staking process
780      */
781     function _calculateRewardAndBurnAll(address user) internal override returns (uint256) {
782         Staking memory userInfo = stakingInfo[user];
783         uint256 reward = unlockedPool.balance().mul(userInfo.totalAmountTime).div(totalStakingAmountTime);
784 
785         totalStakingAmountTime = totalStakingAmountTime.sub(userInfo.totalAmountTime);
786 
787         stakingInfo[user].totalAmountTime = 0;
788 
789         return reward;
790     }
791 
792     /**
793      * @dev Calculate user's total cumulated reward and staking,
794      * and remove him/her from the staking process
795      * @return [1] User cumulated staking BPT
796      * @return [2] User cumulated reward bella during the staking process
797      */
798     function _calculateRewardAndCleanUser(address user) internal override returns (uint256, uint256) {
799         Staking memory userInfo = stakingInfo[user];
800         uint256 reward = unlockedPool.balance().mul(userInfo.totalAmountTime).div(totalStakingAmountTime);
801         uint256 staking = userInfo.amount;
802 
803         totalStakingAmountTime = totalStakingAmountTime.sub(userInfo.totalAmountTime);
804         totalStakingAmount = totalStakingAmount.sub(userInfo.amount);
805 
806         delete stakingInfo[user];
807 
808         return (staking, reward);
809     }
810 
811     /**
812      * @dev Internal function to calculate user's total rewards
813      * @return A specific user's total rewards when clamining
814      */
815     function _totalRewardsFor(address user) internal view override returns (uint256) {
816 
817         // calculate new total staking amount*time
818         uint256 additionalAmountTime = totalStakingAmount.mul(now.sub(lastUpdatedTimestamp));
819         uint256 newTotalStakingAmountTime = totalStakingAmountTime.add(additionalAmountTime);
820 
821         // calculate new user staking
822         Staking memory userInfo = stakingInfo[user];
823         uint256 additionalUserAmountTime = userInfo.amount.mul(now.sub(userInfo.lastUpdatedTimestamp));
824         uint256 newUserTotalAmountTime = userInfo.totalAmountTime.add(additionalUserAmountTime);
825 
826         // calculate total unlocked pool
827         uint256 unlockedAmount = unlockedPool.balance();
828         if (currentUnlockCycle != 0) {
829             uint256 timeDelta = now.sub(lastUnlockTime);
830             if (currentUnlockCycle < timeDelta) {
831                 unlockedAmount = unlockedAmount.add(lockedPool.balance());
832             } else {
833                 uint256 additionalAmount = lockedPool.balance().mul(timeDelta).div(currentUnlockCycle);
834                 unlockedAmount = unlockedAmount.add(additionalAmount);
835             }
836         }
837 
838         uint256 reward = unlockedAmount.mul(newUserTotalAmountTime).div(newTotalStakingAmountTime); 
839         return reward;       
840     }
841 }