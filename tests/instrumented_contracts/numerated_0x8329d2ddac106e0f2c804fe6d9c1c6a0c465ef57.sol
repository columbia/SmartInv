1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.6.12;
4 
5 /**
6  * @dev Collection of functions related to the address type
7  */
8 library Address {
9     /**
10      * @dev Returns true if `account` is a contract.
11      *
12      * [IMPORTANT]
13      * ====
14      * It is unsafe to assume that an address for which this function returns
15      * false is an externally-owned account (EOA) and not a contract.
16      *
17      * Among others, `isContract` will return false for the following
18      * types of addresses:
19      *
20      *  - an externally-owned account
21      *  - a contract in construction
22      *  - an address where a contract will be created
23      *  - an address where a contract lived, but was destroyed
24      * ====
25      */
26     function isContract(address account) internal view returns (bool) {
27         // This method relies in extcodesize, which returns 0 for contracts in
28         // construction, since the code is only stored at the end of the
29         // constructor execution.
30 
31         uint256 size;
32         // solhint-disable-next-line no-inline-assembly
33         assembly { size := extcodesize(account) }
34         return size > 0;
35     }
36 
37     /**
38      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
39      * `recipient`, forwarding all available gas and reverting on errors.
40      *
41      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
42      * of certain opcodes, possibly making contracts go over the 2300 gas limit
43      * imposed by `transfer`, making them unable to receive funds via
44      * `transfer`. {sendValue} removes this limitation.
45      *
46      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
47      *
48      * IMPORTANT: because control is transferred to `recipient`, care must be
49      * taken to not create reentrancy vulnerabilities. Consider using
50      * {ReentrancyGuard} or the
51      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
52      */
53     function sendValue(address payable recipient, uint256 amount) internal {
54         require(address(this).balance >= amount, "Address: insufficient balance");
55 
56         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
57         (bool success, ) = recipient.call{ value: amount }("");
58         require(success, "Address: unable to send value, recipient may have reverted");
59     }
60 
61     /**
62      * @dev Performs a Solidity function call using a low level `call`. A
63      * plain`call` is an unsafe replacement for a function call: use this
64      * function instead.
65      *
66      * If `target` reverts with a revert reason, it is bubbled up by this
67      * function (like regular Solidity function calls).
68      *
69      * Returns the raw returned data. To convert to the expected return value,
70      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
71      *
72      * Requirements:
73      *
74      * - `target` must be a contract.
75      * - calling `target` with `data` must not revert.
76      *
77      * _Available since v3.1._
78      */
79     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
80       return functionCall(target, data, "Address: low-level call failed");
81     }
82 
83     /**
84      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
85      * `errorMessage` as a fallback revert reason when `target` reverts.
86      *
87      * _Available since v3.1._
88      */
89     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
90         return _functionCallWithValue(target, data, 0, errorMessage);
91     }
92 
93     /**
94      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
95      * but also transferring `value` wei to `target`.
96      *
97      * Requirements:
98      *
99      * - the calling contract must have an ETH balance of at least `value`.
100      * - the called Solidity function must be `payable`.
101      *
102      * _Available since v3.1._
103      */
104     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
105         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
106     }
107 
108     /**
109      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
110      * with `errorMessage` as a fallback revert reason when `target` reverts.
111      *
112      * _Available since v3.1._
113      */
114     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
115         require(address(this).balance >= value, "Address: insufficient balance for call");
116         return _functionCallWithValue(target, data, value, errorMessage);
117     }
118 
119     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
120         require(isContract(target), "Address: call to non-contract");
121 
122         // solhint-disable-next-line avoid-low-level-calls
123         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
124         if (success) {
125             return returndata;
126         } else {
127             // Look for revert reason and bubble it up if present
128             if (returndata.length > 0) {
129                 // The easiest way to bubble the revert reason is using memory via assembly
130 
131                 // solhint-disable-next-line no-inline-assembly
132                 assembly {
133                     let returndata_size := mload(returndata)
134                     revert(add(32, returndata), returndata_size)
135                 }
136             } else {
137                 revert(errorMessage);
138             }
139         }
140     }
141 }
142 
143 /**
144  * @dev Wrappers over Solidity's arithmetic operations with added overflow
145  * checks.
146  *
147  * Arithmetic operations in Solidity wrap on overflow. This can easily result
148  * in bugs, because programmers usually assume that an overflow raises an
149  * error, which is the standard behavior in high level programming languages.
150  * `SafeMath` restores this intuition by reverting the transaction when an
151  * operation overflows.
152  *
153  * Using this library instead of the unchecked operations eliminates an entire
154  * class of bugs, so it's recommended to use it always.
155  */
156 library SafeMath {
157     /**
158      * @dev Returns the addition of two unsigned integers, reverting on
159      * overflow.
160      *
161      * Counterpart to Solidity's `+` operator.
162      *
163      * Requirements:
164      *
165      * - Addition cannot overflow.
166      */
167     function add(uint256 a, uint256 b) internal pure returns (uint256) {
168         uint256 c = a + b;
169         require(c >= a, "SafeMath: addition overflow");
170 
171         return c;
172     }
173 
174     /**
175      * @dev Returns the subtraction of two unsigned integers, reverting on
176      * overflow (when the result is negative).
177      *
178      * Counterpart to Solidity's `-` operator.
179      *
180      * Requirements:
181      *
182      * - Subtraction cannot overflow.
183      */
184     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
185         return sub(a, b, "SafeMath: subtraction overflow");
186     }
187 
188     /**
189      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
190      * overflow (when the result is negative).
191      *
192      * Counterpart to Solidity's `-` operator.
193      *
194      * Requirements:
195      *
196      * - Subtraction cannot overflow.
197      */
198     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
199         require(b <= a, errorMessage);
200         uint256 c = a - b;
201 
202         return c;
203     }
204 
205     /**
206      * @dev Returns the multiplication of two unsigned integers, reverting on
207      * overflow.
208      *
209      * Counterpart to Solidity's `*` operator.
210      *
211      * Requirements:
212      *
213      * - Multiplication cannot overflow.
214      */
215     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
216         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
217         // benefit is lost if 'b' is also tested.
218         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
219         if (a == 0) {
220             return 0;
221         }
222 
223         uint256 c = a * b;
224         require(c / a == b, "SafeMath: multiplication overflow");
225 
226         return c;
227     }
228 
229     /**
230      * @dev Returns the integer division of two unsigned integers. Reverts on
231      * division by zero. The result is rounded towards zero.
232      *
233      * Counterpart to Solidity's `/` operator. Note: this function uses a
234      * `revert` opcode (which leaves remaining gas untouched) while Solidity
235      * uses an invalid opcode to revert (consuming all remaining gas).
236      *
237      * Requirements:
238      *
239      * - The divisor cannot be zero.
240      */
241     function div(uint256 a, uint256 b) internal pure returns (uint256) {
242         return div(a, b, "SafeMath: division by zero");
243     }
244 
245     /**
246      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
247      * division by zero. The result is rounded towards zero.
248      *
249      * Counterpart to Solidity's `/` operator. Note: this function uses a
250      * `revert` opcode (which leaves remaining gas untouched) while Solidity
251      * uses an invalid opcode to revert (consuming all remaining gas).
252      *
253      * Requirements:
254      *
255      * - The divisor cannot be zero.
256      */
257     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
258         require(b > 0, errorMessage);
259         uint256 c = a / b;
260         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
261 
262         return c;
263     }
264 
265     /**
266      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
267      * Reverts when dividing by zero.
268      *
269      * Counterpart to Solidity's `%` operator. This function uses a `revert`
270      * opcode (which leaves remaining gas untouched) while Solidity uses an
271      * invalid opcode to revert (consuming all remaining gas).
272      *
273      * Requirements:
274      *
275      * - The divisor cannot be zero.
276      */
277     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
278         return mod(a, b, "SafeMath: modulo by zero");
279     }
280 
281     /**
282      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
283      * Reverts with custom message when dividing by zero.
284      *
285      * Counterpart to Solidity's `%` operator. This function uses a `revert`
286      * opcode (which leaves remaining gas untouched) while Solidity uses an
287      * invalid opcode to revert (consuming all remaining gas).
288      *
289      * Requirements:
290      *
291      * - The divisor cannot be zero.
292      */
293     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
294         require(b != 0, errorMessage);
295         return a % b;
296     }
297 }
298 
299 /**
300  * @dev Interface of the ERC20 standard as defined in the EIP.
301  */
302 interface IERC20 {
303     /**
304      * @dev Returns the amount of tokens in existence.
305      */
306     function totalSupply() external view returns (uint256);
307 
308     /**
309      * @dev Returns the amount of tokens owned by `account`.
310      */
311     function balanceOf(address account) external view returns (uint256);
312 
313     /**
314      * @dev Moves `amount` tokens from the caller's account to `recipient`.
315      *
316      * Returns a boolean value indicating whether the operation succeeded.
317      *
318      * Emits a {Transfer} event.
319      */
320     function transfer(address recipient, uint256 amount) external returns (bool);
321 
322     /**
323      * @dev Returns the remaining number of tokens that `spender` will be
324      * allowed to spend on behalf of `owner` through {transferFrom}. This is
325      * zero by default.
326      *
327      * This value changes when {approve} or {transferFrom} are called.
328      */
329     function allowance(address owner, address spender) external view returns (uint256);
330 
331     /**
332      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
333      *
334      * Returns a boolean value indicating whether the operation succeeded.
335      *
336      * IMPORTANT: Beware that changing an allowance with this method brings the risk
337      * that someone may use both the old and the new allowance by unfortunate
338      * transaction ordering. One possible solution to mitigate this race
339      * condition is to first reduce the spender's allowance to 0 and set the
340      * desired value afterwards:
341      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
342      *
343      * Emits an {Approval} event.
344      */
345     function approve(address spender, uint256 amount) external returns (bool);
346 
347     /**
348      * @dev Moves `amount` tokens from `sender` to `recipient` using the
349      * allowance mechanism. `amount` is then deducted from the caller's
350      * allowance.
351      *
352      * Returns a boolean value indicating whether the operation succeeded.
353      *
354      * Emits a {Transfer} event.
355      */
356     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
357 
358     /**
359      * @dev Emitted when `value` tokens are moved from one account (`from`) to
360      * another (`to`).
361      *
362      * Note that `value` may be zero.
363      */
364     event Transfer(address indexed from, address indexed to, uint256 value);
365 
366     /**
367      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
368      * a call to {approve}. `value` is the new allowance.
369      */
370     event Approval(address indexed owner, address indexed spender, uint256 value);
371 }
372 
373 /**
374  * @title SafeERC20
375  * @dev Wrappers around ERC20 operations that throw on failure (when the token
376  * contract returns false). Tokens that return no value (and instead revert or
377  * throw on failure) are also supported, non-reverting calls are assumed to be
378  * successful.
379  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
380  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
381  */
382 library SafeERC20 {
383     using SafeMath for uint256;
384     using Address for address;
385 
386     function safeTransfer(IERC20 token, address to, uint256 value) internal {
387         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
388     }
389 
390     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
391         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
392     }
393 
394     /**
395      * @dev Deprecated. This function has issues similar to the ones found in
396      * {IERC20-approve}, and its usage is discouraged.
397      *
398      * Whenever possible, use {safeIncreaseAllowance} and
399      * {safeDecreaseAllowance} instead.
400      */
401     function safeApprove(IERC20 token, address spender, uint256 value) internal {
402         // safeApprove should only be called when setting an initial allowance,
403         // or when resetting it to zero. To increase and decrease it, use
404         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
405         // solhint-disable-next-line max-line-length
406         require((value == 0) || (token.allowance(address(this), spender) == 0),
407             "SafeERC20: approve from non-zero to non-zero allowance"
408         );
409         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
410     }
411 
412     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
413         uint256 newAllowance = token.allowance(address(this), spender).add(value);
414         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
415     }
416 
417     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
418         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
419         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
420     }
421 
422     /**
423      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
424      * on the return value: the return value is optional (but if data is returned, it must not be false).
425      * @param token The token targeted by the call.
426      * @param data The call data (encoded using abi.encode or one of its variants).
427      */
428     function _callOptionalReturn(IERC20 token, bytes memory data) private {
429         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
430         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
431         // the target address contains contract code and also asserts for success in the low-level call.
432 
433         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
434         if (returndata.length > 0) { // Return data is optional
435             // solhint-disable-next-line max-line-length
436             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
437         }
438     }
439 }
440 
441 /*
442  * @dev Provides information about the current execution context, including the
443  * sender of the transaction and its data. While these are generally available
444  * via msg.sender and msg.data, they should not be accessed in such a direct
445  * manner, since when dealing with GSN meta-transactions the account sending and
446  * paying for execution may not be the actual sender (as far as an application
447  * is concerned).
448  *
449  * This contract is only required for intermediate, library-like contracts.
450  */
451 abstract contract Context {
452     function _msgSender() internal view virtual returns (address payable) {
453         return msg.sender;
454     }
455 
456     function _msgData() internal view virtual returns (bytes memory) {
457         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
458         return msg.data;
459     }
460 }
461 
462 /**
463  * @dev Contract module which provides a basic access control mechanism, where
464  * there is an account (an owner) that can be granted exclusive access to
465  * specific functions.
466  *
467  * By default, the owner account will be the one that deploys the contract. This
468  * can later be changed with {transferOwnership}.
469  *
470  * This module is used through inheritance. It will make available the modifier
471  * `onlyOwner`, which can be applied to your functions to restrict their use to
472  * the owner.
473  */
474 contract Ownable is Context {
475     address private _owner;
476 
477     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
478 
479     /**
480      * @dev Initializes the contract setting the deployer as the initial owner.
481      */
482     constructor () internal {
483         address msgSender = _msgSender();
484         _owner = msgSender;
485         emit OwnershipTransferred(address(0), msgSender);
486     }
487 
488     /**
489      * @dev Returns the address of the current owner.
490      */
491     function owner() public view returns (address) {
492         return _owner;
493     }
494 
495     /**
496      * @dev Throws if called by any account other than the owner.
497      */
498     modifier onlyOwner() {
499         require(_owner == _msgSender(), "Ownable: caller is not the owner");
500         _;
501     }
502 
503     /**
504      * @dev Leaves the contract without owner. It will not be possible to call
505      * `onlyOwner` functions anymore. Can only be called by the current owner.
506      *
507      * NOTE: Renouncing ownership will leave the contract without an owner,
508      * thereby removing any functionality that is only available to the owner.
509      */
510     function renounceOwnership() public virtual onlyOwner {
511         emit OwnershipTransferred(_owner, address(0));
512         _owner = address(0);
513     }
514 
515     /**
516      * @dev Transfers ownership of the contract to a new account (`newOwner`).
517      * Can only be called by the current owner.
518      */
519     function transferOwnership(address newOwner) public virtual onlyOwner {
520         require(newOwner != address(0), "Ownable: new owner is the zero address");
521         emit OwnershipTransferred(_owner, newOwner);
522         _owner = newOwner;
523     }
524 }
525 
526 /**
527  * @title The DUSK Provisioner Prestaking Contract.
528  * @author Jules de Smit
529  * @notice This contract will facilitate staking for the DUSK ERC-20 token.
530  */
531 contract PrestakingProvisioner is Ownable {
532     using SafeERC20 for IERC20;
533     using SafeMath for uint256;
534     
535     // The DUSK contract.
536     IERC20 private _token;
537     
538     // Holds all of the information for a staking individual.
539     struct Staker {
540         uint    startTime;
541         uint    endTime;
542         uint256 amount;
543         uint256 accumulatedReward;
544         uint    cooldownTime;
545         uint256 pendingReward;
546         uint256 dailyReward;
547         uint    lastUpdated;
548     }
549     
550     mapping(address => Staker) public stakersMap;
551     uint256 public stakersAmount;
552 
553     uint public deactivationTime;
554         
555     modifier onlyStaker() {
556         Staker storage staker = stakersMap[msg.sender];
557         uint startTime = staker.startTime;
558         require(startTime.add(1 days) <= block.timestamp && startTime != 0, "No stake is active for sender address");
559         _;
560     }
561 
562     modifier onlyActive() {
563         require(deactivationTime == 0);
564         _;
565     }
566 
567     modifier onlyInactive() {
568         require(deactivationTime != 0);
569         _;
570     }
571     
572     constructor(IERC20 token) public {
573         _token = token;
574     }
575     
576     /**
577      * @notice Ensure nobody can send Ether to this contract, as it is not supposed to have any.
578      */
579     receive() external payable {
580         revert();
581     }
582 
583     /**
584      * @notice Deactivate the contract. Only to be used once the campaign
585      * comes to an end.
586      *
587      * NOTE that this sets the contract to inactive indefinitely, and will
588      * not be usable from this point onwards.
589      */
590     function deactivate() external onlyOwner onlyActive {
591         deactivationTime = block.timestamp;
592     }
593 
594     /**
595      * @notice Can be used by the contract owner to return a user's stake back to them,
596      * without need for going through the withdrawal period. This should only really be used
597      * at the end of the campaign, if a user does not manually withdraw their stake.
598      * @dev This function only works on single addresses, in order to avoid potential
599      * deadlocks caused by high gas requirements.
600      */
601     function returnStake(address _staker) external onlyOwner {
602         Staker storage staker = stakersMap[_staker];
603         require(staker.amount > 0, "This person is not staking");
604 
605         uint comparisonTime = block.timestamp;
606         if (deactivationTime != 0) {
607             comparisonTime = deactivationTime;
608         }
609 
610         distributeRewards(staker, comparisonTime);
611 
612         // If this user has a pending reward, add it to the accumulated reward before
613         // paying him out.
614         staker.accumulatedReward = staker.accumulatedReward.add(staker.pendingReward);
615         removeUser(staker, _staker);
616     }
617     
618     /**
619      * @notice Lock up a given amount of DUSK in the pre-staking contract.
620      * @dev A user is required to approve the amount of DUSK prior to calling this function.
621      */
622     function stake(uint256 amount) external onlyActive {
623         // Ensure this staker does not exist yet.
624         Staker storage staker = stakersMap[msg.sender];
625         require(staker.amount == 0, "Address already known");
626 
627         if (amount > 1000000 ether || amount < 10000 ether) {
628             revert("Amount to stake is out of bounds");
629         }
630         
631         // Set information for this staker.
632         uint blockTimestamp = block.timestamp;
633         staker.amount = amount;
634         staker.startTime = blockTimestamp;
635         staker.lastUpdated = blockTimestamp;
636         staker.dailyReward = amount.mul(100033).div(100000).sub(amount);
637         stakersAmount++;
638         
639         // Transfer the DUSK to this contract.
640         _token.safeTransferFrom(msg.sender, address(this), amount);
641     }
642     
643     /**
644      * @notice Start the cooldown period for withdrawing a reward.
645      */
646     function startWithdrawReward() external onlyStaker onlyActive {
647         Staker storage staker = stakersMap[msg.sender];
648         uint blockTimestamp = block.timestamp;
649         require(staker.cooldownTime == 0, "A withdrawal call has already been triggered");
650         require(staker.endTime == 0, "Stake already withdrawn");
651         distributeRewards(staker, blockTimestamp);
652         
653         staker.cooldownTime = blockTimestamp;
654         staker.pendingReward = staker.accumulatedReward;
655         staker.accumulatedReward = 0;
656     }
657     
658     /**
659      * @notice Withdraw the reward. Will only work after the cooldown period has ended.
660      */
661     function withdrawReward() external onlyStaker {
662         Staker storage staker = stakersMap[msg.sender];
663         uint cooldownTime = staker.cooldownTime;
664         require(cooldownTime != 0, "The withdrawal cooldown has not been triggered");
665 
666         if (block.timestamp.sub(cooldownTime) >= 7 days) {
667             uint256 reward = staker.pendingReward;
668             staker.cooldownTime = 0;
669             staker.pendingReward = 0;
670             _token.safeTransfer(msg.sender, reward);
671         }
672     }
673     
674     /**
675      * @notice Start the cooldown period for withdrawing the stake.
676      */
677     function startWithdrawStake() external onlyStaker onlyActive {
678         Staker storage staker = stakersMap[msg.sender];
679         uint blockTimestamp = block.timestamp;
680         require(staker.startTime.add(30 days) <= blockTimestamp, "Stakes can only be withdrawn 30 days after initial lock up");
681         require(staker.endTime == 0, "Stake withdrawal already in progress");
682         require(staker.cooldownTime == 0, "A withdrawal call has been triggered - please wait for it to complete before withdrawing your stake");
683         
684         // We distribute the rewards first, so that the withdrawing staker
685         // receives all of their allocated rewards, before setting an `endTime`.
686         distributeRewards(staker, blockTimestamp);
687         staker.endTime = blockTimestamp;
688     }
689     
690     /**
691      * @notice Start the cooldown period for withdrawing the stake.
692      * This function can only be called once the contract is deactivated.
693      * @dev This function is nearly identical to `startWithdrawStake`,
694      * but it was included in order to prevent adding a `SLOAD` call
695      * to `distributeRewards`, making contract usage a bit cheaper during
696      * the campaign.
697      */
698     function startWithdrawStakeAfterDeactivation() external onlyStaker onlyInactive {
699         Staker storage staker = stakersMap[msg.sender];
700         uint blockTimestamp = block.timestamp;
701         require(staker.startTime.add(30 days) <= blockTimestamp, "Stakes can only be withdrawn 30 days after initial lock up");
702         require(staker.endTime == 0, "Stake withdrawal already in progress");
703         require(staker.cooldownTime == 0, "A withdrawal call has been triggered - please wait for it to complete before withdrawing your stake");
704         
705         // We distribute the rewards first, so that the withdrawing staker
706         // receives all of their allocated rewards, before setting an `endTime`.
707         distributeRewards(staker, deactivationTime);
708         staker.endTime = blockTimestamp;
709     }
710     
711     /**
712      * @notice Withdraw the stake, and clear the entry of the caller.
713      */
714     function withdrawStake() external onlyStaker {
715         Staker storage staker = stakersMap[msg.sender];
716         uint endTime = staker.endTime;
717         require(endTime != 0, "Stake withdrawal call was not yet initiated");
718         
719         if (block.timestamp.sub(endTime) >= 7 days) {
720             removeUser(staker, msg.sender);
721         }
722     }
723     
724     /**
725      * @notice Update the reward allocation for a given staker.
726      * @param staker The staker to update the reward allocation for.
727      */
728     function distributeRewards(Staker storage staker, uint comparisonTime) internal {
729         uint numDays = comparisonTime.sub(staker.lastUpdated).div(1 days);
730         if (numDays == 0) {
731             return;
732         }
733         
734         uint256 reward = staker.dailyReward.mul(numDays);
735         staker.accumulatedReward = staker.accumulatedReward.add(reward);
736         staker.lastUpdated = staker.lastUpdated.add(numDays.mul(1 days));
737     }
738 
739     /**
740      * @notice Remove a user from the staking pool. This ensures proper deletion from
741      * the stakers map and the stakers array, and ensures that all DUSK is returned to
742      * the rightful owner.
743      * @param staker The information of the staker in question
744      * @param sender The address of the staker in question
745      */
746     function removeUser(Staker storage staker, address sender) internal {
747         uint256 balance = staker.amount.add(staker.accumulatedReward);
748         delete stakersMap[sender];
749         stakersAmount--;
750         
751         _token.safeTransfer(sender, balance);
752     }
753 }