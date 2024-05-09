1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.6.12;
4 
5 
6 // 
7 /**
8  * @dev Interface of the ERC20 standard as defined in the EIP.
9  */
10 interface IERC20 {
11     /**
12      * @dev Returns the amount of tokens in existence.
13      */
14     function totalSupply() external view returns (uint256);
15 
16     /**
17      * @dev Returns the amount of tokens owned by `account`.
18      */
19     function balanceOf(address account) external view returns (uint256);
20 
21     /**
22      * @dev Moves `amount` tokens from the caller's account to `recipient`.
23      *
24      * Returns a boolean value indicating whether the operation succeeded.
25      *
26      * Emits a {Transfer} event.
27      */
28     function transfer(address recipient, uint256 amount) external returns (bool);
29 
30     /**
31      * @dev Returns the remaining number of tokens that `spender` will be
32      * allowed to spend on behalf of `owner` through {transferFrom}. This is
33      * zero by default.
34      *
35      * This value changes when {approve} or {transferFrom} are called.
36      */
37     function allowance(address owner, address spender) external view returns (uint256);
38 
39     /**
40      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
41      *
42      * Returns a boolean value indicating whether the operation succeeded.
43      *
44      * IMPORTANT: Beware that changing an allowance with this method brings the risk
45      * that someone may use both the old and the new allowance by unfortunate
46      * transaction ordering. One possible solution to mitigate this race
47      * condition is to first reduce the spender's allowance to 0 and set the
48      * desired value afterwards:
49      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
50      *
51      * Emits an {Approval} event.
52      */
53     function approve(address spender, uint256 amount) external returns (bool);
54 
55     /**
56      * @dev Moves `amount` tokens from `sender` to `recipient` using the
57      * allowance mechanism. `amount` is then deducted from the caller's
58      * allowance.
59      *
60      * Returns a boolean value indicating whether the operation succeeded.
61      *
62      * Emits a {Transfer} event.
63      */
64     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
65 
66     /**
67      * @dev Emitted when `value` tokens are moved from one account (`from`) to
68      * another (`to`).
69      *
70      * Note that `value` may be zero.
71      */
72     event Transfer(address indexed from, address indexed to, uint256 value);
73 
74     /**
75      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
76      * a call to {approve}. `value` is the new allowance.
77      */
78     event Approval(address indexed owner, address indexed spender, uint256 value);
79 }
80 
81 // 
82 /**
83  * @dev Wrappers over Solidity's arithmetic operations with added overflow
84  * checks.
85  *
86  * Arithmetic operations in Solidity wrap on overflow. This can easily result
87  * in bugs, because programmers usually assume that an overflow raises an
88  * error, which is the standard behavior in high level programming languages.
89  * `SafeMath` restores this intuition by reverting the transaction when an
90  * operation overflows.
91  *
92  * Using this library instead of the unchecked operations eliminates an entire
93  * class of bugs, so it's recommended to use it always.
94  */
95 library SafeMath {
96     /**
97      * @dev Returns the addition of two unsigned integers, reverting on
98      * overflow.
99      *
100      * Counterpart to Solidity's `+` operator.
101      *
102      * Requirements:
103      *
104      * - Addition cannot overflow.
105      */
106     function add(uint256 a, uint256 b) internal pure returns (uint256) {
107         uint256 c = a + b;
108         require(c >= a, "SafeMath: addition overflow");
109 
110         return c;
111     }
112 
113     /**
114      * @dev Returns the subtraction of two unsigned integers, reverting on
115      * overflow (when the result is negative).
116      *
117      * Counterpart to Solidity's `-` operator.
118      *
119      * Requirements:
120      *
121      * - Subtraction cannot overflow.
122      */
123     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
124         return sub(a, b, "SafeMath: subtraction overflow");
125     }
126 
127     /**
128      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
129      * overflow (when the result is negative).
130      *
131      * Counterpart to Solidity's `-` operator.
132      *
133      * Requirements:
134      *
135      * - Subtraction cannot overflow.
136      */
137     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
138         require(b <= a, errorMessage);
139         uint256 c = a - b;
140 
141         return c;
142     }
143 
144     /**
145      * @dev Returns the multiplication of two unsigned integers, reverting on
146      * overflow.
147      *
148      * Counterpart to Solidity's `*` operator.
149      *
150      * Requirements:
151      *
152      * - Multiplication cannot overflow.
153      */
154     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
155         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
156         // benefit is lost if 'b' is also tested.
157         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
158         if (a == 0) {
159             return 0;
160         }
161 
162         uint256 c = a * b;
163         require(c / a == b, "SafeMath: multiplication overflow");
164 
165         return c;
166     }
167 
168     /**
169      * @dev Returns the integer division of two unsigned integers. Reverts on
170      * division by zero. The result is rounded towards zero.
171      *
172      * Counterpart to Solidity's `/` operator. Note: this function uses a
173      * `revert` opcode (which leaves remaining gas untouched) while Solidity
174      * uses an invalid opcode to revert (consuming all remaining gas).
175      *
176      * Requirements:
177      *
178      * - The divisor cannot be zero.
179      */
180     function div(uint256 a, uint256 b) internal pure returns (uint256) {
181         return div(a, b, "SafeMath: division by zero");
182     }
183 
184     /**
185      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
186      * division by zero. The result is rounded towards zero.
187      *
188      * Counterpart to Solidity's `/` operator. Note: this function uses a
189      * `revert` opcode (which leaves remaining gas untouched) while Solidity
190      * uses an invalid opcode to revert (consuming all remaining gas).
191      *
192      * Requirements:
193      *
194      * - The divisor cannot be zero.
195      */
196     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
197         require(b > 0, errorMessage);
198         uint256 c = a / b;
199         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
200 
201         return c;
202     }
203 
204     /**
205      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
206      * Reverts when dividing by zero.
207      *
208      * Counterpart to Solidity's `%` operator. This function uses a `revert`
209      * opcode (which leaves remaining gas untouched) while Solidity uses an
210      * invalid opcode to revert (consuming all remaining gas).
211      *
212      * Requirements:
213      *
214      * - The divisor cannot be zero.
215      */
216     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
217         return mod(a, b, "SafeMath: modulo by zero");
218     }
219 
220     /**
221      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
222      * Reverts with custom message when dividing by zero.
223      *
224      * Counterpart to Solidity's `%` operator. This function uses a `revert`
225      * opcode (which leaves remaining gas untouched) while Solidity uses an
226      * invalid opcode to revert (consuming all remaining gas).
227      *
228      * Requirements:
229      *
230      * - The divisor cannot be zero.
231      */
232     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
233         require(b != 0, errorMessage);
234         return a % b;
235     }
236 }
237 
238 // 
239 /**
240  * @dev Collection of functions related to the address type
241  */
242 library Address {
243     /**
244      * @dev Returns true if `account` is a contract.
245      *
246      * [IMPORTANT]
247      * ====
248      * It is unsafe to assume that an address for which this function returns
249      * false is an externally-owned account (EOA) and not a contract.
250      *
251      * Among others, `isContract` will return false for the following
252      * types of addresses:
253      *
254      *  - an externally-owned account
255      *  - a contract in construction
256      *  - an address where a contract will be created
257      *  - an address where a contract lived, but was destroyed
258      * ====
259      */
260     function isContract(address account) internal view returns (bool) {
261         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
262         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
263         // for accounts without code, i.e. `keccak256('')`
264         bytes32 codehash;
265         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
266         // solhint-disable-next-line no-inline-assembly
267         assembly { codehash := extcodehash(account) }
268         return (codehash != accountHash && codehash != 0x0);
269     }
270 
271     /**
272      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
273      * `recipient`, forwarding all available gas and reverting on errors.
274      *
275      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
276      * of certain opcodes, possibly making contracts go over the 2300 gas limit
277      * imposed by `transfer`, making them unable to receive funds via
278      * `transfer`. {sendValue} removes this limitation.
279      *
280      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
281      *
282      * IMPORTANT: because control is transferred to `recipient`, care must be
283      * taken to not create reentrancy vulnerabilities. Consider using
284      * {ReentrancyGuard} or the
285      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
286      */
287     function sendValue(address payable recipient, uint256 amount) internal {
288         require(address(this).balance >= amount, "Address: insufficient balance");
289 
290         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
291         (bool success, ) = recipient.call{ value: amount }("");
292         require(success, "Address: unable to send value, recipient may have reverted");
293     }
294 
295     /**
296      * @dev Performs a Solidity function call using a low level `call`. A
297      * plain`call` is an unsafe replacement for a function call: use this
298      * function instead.
299      *
300      * If `target` reverts with a revert reason, it is bubbled up by this
301      * function (like regular Solidity function calls).
302      *
303      * Returns the raw returned data. To convert to the expected return value,
304      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
305      *
306      * Requirements:
307      *
308      * - `target` must be a contract.
309      * - calling `target` with `data` must not revert.
310      *
311      * _Available since v3.1._
312      */
313     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
314       return functionCall(target, data, "Address: low-level call failed");
315     }
316 
317     /**
318      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
319      * `errorMessage` as a fallback revert reason when `target` reverts.
320      *
321      * _Available since v3.1._
322      */
323     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
324         return _functionCallWithValue(target, data, 0, errorMessage);
325     }
326 
327     /**
328      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
329      * but also transferring `value` wei to `target`.
330      *
331      * Requirements:
332      *
333      * - the calling contract must have an ETH balance of at least `value`.
334      * - the called Solidity function must be `payable`.
335      *
336      * _Available since v3.1._
337      */
338     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
339         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
340     }
341 
342     /**
343      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
344      * with `errorMessage` as a fallback revert reason when `target` reverts.
345      *
346      * _Available since v3.1._
347      */
348     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
349         require(address(this).balance >= value, "Address: insufficient balance for call");
350         return _functionCallWithValue(target, data, value, errorMessage);
351     }
352 
353     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
354         require(isContract(target), "Address: call to non-contract");
355 
356         // solhint-disable-next-line avoid-low-level-calls
357         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
358         if (success) {
359             return returndata;
360         } else {
361             // Look for revert reason and bubble it up if present
362             if (returndata.length > 0) {
363                 // The easiest way to bubble the revert reason is using memory via assembly
364 
365                 // solhint-disable-next-line no-inline-assembly
366                 assembly {
367                     let returndata_size := mload(returndata)
368                     revert(add(32, returndata), returndata_size)
369                 }
370             } else {
371                 revert(errorMessage);
372             }
373         }
374     }
375 }
376 
377 // 
378 /**
379  * @title SafeERC20
380  * @dev Wrappers around ERC20 operations that throw on failure (when the token
381  * contract returns false). Tokens that return no value (and instead revert or
382  * throw on failure) are also supported, non-reverting calls are assumed to be
383  * successful.
384  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
385  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
386  */
387 library SafeERC20 {
388     using SafeMath for uint256;
389     using Address for address;
390 
391     function safeTransfer(IERC20 token, address to, uint256 value) internal {
392         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
393     }
394 
395     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
396         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
397     }
398 
399     /**
400      * @dev Deprecated. This function has issues similar to the ones found in
401      * {IERC20-approve}, and its usage is discouraged.
402      *
403      * Whenever possible, use {safeIncreaseAllowance} and
404      * {safeDecreaseAllowance} instead.
405      */
406     function safeApprove(IERC20 token, address spender, uint256 value) internal {
407         // safeApprove should only be called when setting an initial allowance,
408         // or when resetting it to zero. To increase and decrease it, use
409         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
410         // solhint-disable-next-line max-line-length
411         require((value == 0) || (token.allowance(address(this), spender) == 0),
412             "SafeERC20: approve from non-zero to non-zero allowance"
413         );
414         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
415     }
416 
417     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
418         uint256 newAllowance = token.allowance(address(this), spender).add(value);
419         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
420     }
421 
422     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
423         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
424         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
425     }
426 
427     /**
428      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
429      * on the return value: the return value is optional (but if data is returned, it must not be false).
430      * @param token The token targeted by the call.
431      * @param data The call data (encoded using abi.encode or one of its variants).
432      */
433     function _callOptionalReturn(IERC20 token, bytes memory data) private {
434         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
435         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
436         // the target address contains contract code and also asserts for success in the low-level call.
437 
438         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
439         if (returndata.length > 0) { // Return data is optional
440             // solhint-disable-next-line max-line-length
441             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
442         }
443     }
444 }
445 
446 // 
447 /*
448  * @dev Provides information about the current execution context, including the
449  * sender of the transaction and its data. While these are generally available
450  * via msg.sender and msg.data, they should not be accessed in such a direct
451  * manner, since when dealing with GSN meta-transactions the account sending and
452  * paying for execution may not be the actual sender (as far as an application
453  * is concerned).
454  *
455  * This contract is only required for intermediate, library-like contracts.
456  */
457 abstract contract Context {
458     function _msgSender() internal view virtual returns (address payable) {
459         return msg.sender;
460     }
461 
462     function _msgData() internal view virtual returns (bytes memory) {
463         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
464         return msg.data;
465     }
466 }
467 
468 // 
469 /**
470  * @dev Contract module which provides a basic access control mechanism, where
471  * there is an account (an owner) that can be granted exclusive access to
472  * specific functions.
473  *
474  * By default, the owner account will be the one that deploys the contract. This
475  * can later be changed with {transferOwnership}.
476  *
477  * This module is used through inheritance. It will make available the modifier
478  * `onlyOwner`, which can be applied to your functions to restrict their use to
479  * the owner.
480  */
481 contract Ownable is Context {
482     address private _owner;
483 
484     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
485 
486     /**
487      * @dev Initializes the contract setting the deployer as the initial owner.
488      */
489     constructor () internal {
490         address msgSender = _msgSender();
491         _owner = msgSender;
492         emit OwnershipTransferred(address(0), msgSender);
493     }
494 
495     /**
496      * @dev Returns the address of the current owner.
497      */
498     function owner() public view returns (address) {
499         return _owner;
500     }
501 
502     /**
503      * @dev Throws if called by any account other than the owner.
504      */
505     modifier onlyOwner() {
506         require(_owner == _msgSender(), "Ownable: caller is not the owner");
507         _;
508     }
509 
510     /**
511      * @dev Leaves the contract without owner. It will not be possible to call
512      * `onlyOwner` functions anymore. Can only be called by the current owner.
513      *
514      * NOTE: Renouncing ownership will leave the contract without an owner,
515      * thereby removing any functionality that is only available to the owner.
516      */
517     function renounceOwnership() public virtual onlyOwner {
518         emit OwnershipTransferred(_owner, address(0));
519         _owner = address(0);
520     }
521 
522     /**
523      * @dev Transfers ownership of the contract to a new account (`newOwner`).
524      * Can only be called by the current owner.
525      */
526     function transferOwnership(address newOwner) public virtual onlyOwner {
527         require(newOwner != address(0), "Ownable: new owner is the zero address");
528         emit OwnershipTransferred(_owner, newOwner);
529         _owner = newOwner;
530     }
531 }
532 
533 // 
534 contract HoneycombV3 is Ownable {
535   using SafeMath for uint256;
536   using SafeERC20 for IERC20;
537 
538   // Info of each user.
539   struct UserInfo {
540     uint256 amount;     // How many staking tokens the user has provided.
541     uint256 rewardDebt; // Reward debt.
542     uint256 mined;
543     uint256 collected;
544   }
545 
546   struct CollectingInfo {
547     uint256 collectableTime;
548     uint256 amount;
549     bool collected;
550   }
551 
552   // Info of each pool.
553   struct PoolInfo {
554     IERC20 stakingToken;           // Address of staking token contract.
555     uint256 allocPoint;       // How many allocation points assigned to this pool.
556     uint256 lastRewardBlock;  // Last block number that HONEYs distribution occurs.
557     uint256 accHoneyPerShare; // Accumulated HONEYs per share, times 1e12.
558     uint256 totalShares;
559   }
560 
561   struct BatchInfo {
562     uint256 startBlock;
563     uint256 endBlock;
564     uint256 honeyPerBlock;
565     uint256 totalAllocPoint;
566   }
567 
568   // Info of each batch
569   BatchInfo[] public batchInfo;
570   // Info of each pool at specified batch.
571   mapping (uint256 => PoolInfo[]) public poolInfo;
572   // Info of each user at specified batch and pool
573   mapping (uint256 => mapping (uint256 => mapping (address => UserInfo))) public userInfo;
574   mapping (uint256 => mapping (uint256 => mapping (address => CollectingInfo[]))) public collectingInfo;
575 
576   IERC20 public honeyToken;
577   uint256 public collectingDuration = 86400 * 3;
578   uint256 public instantCollectBurnRate = 4000; // 40%
579   address public burnDestination;
580 
581   event Deposit(address indexed user, uint256 indexed batch, uint256 indexed pid, uint256 amount);
582   event Withdraw(address indexed user, uint256 indexed batch, uint256 indexed pid, uint256 amount);
583   event EmergencyWithdraw(address indexed user, uint256 indexed batch, uint256 indexed pid, uint256 amount);
584 
585   constructor (address _honeyToken, address _burnDestination) public {
586     honeyToken = IERC20(_honeyToken);
587     burnDestination = _burnDestination;
588   }
589 
590   function addBatch(uint256 startBlock, uint256 endBlock, uint256 honeyPerBlock) public onlyOwner {
591     require(endBlock > startBlock, "endBlock should be larger than startBlock");
592     require(endBlock > block.number, "endBlock should be larger than the current block number");
593     require(startBlock > block.number, "startBlock should be larger than the current block number");
594     
595     if (batchInfo.length > 0) {
596       uint256 lastEndBlock = batchInfo[batchInfo.length - 1].endBlock;
597       require(startBlock >= lastEndBlock, "startBlock should be >= the endBlock of the last batch");
598     }
599 
600     uint256 senderHoneyBalance = honeyToken.balanceOf(address(msg.sender));
601     uint256 requiredHoney = endBlock.sub(startBlock).mul(honeyPerBlock);
602     require(senderHoneyBalance >= requiredHoney, "insufficient HONEY for the batch");
603 
604     honeyToken.safeTransferFrom(address(msg.sender), address(this), requiredHoney);
605     batchInfo.push(BatchInfo({
606       startBlock: startBlock,
607       endBlock: endBlock,
608       honeyPerBlock: honeyPerBlock,
609       totalAllocPoint: 0
610     }));
611   }
612 
613   function addPool(uint256 batch, IERC20 stakingToken, uint256 multiplier) public onlyOwner {
614     require(batch < batchInfo.length, "batch must exist");
615     
616     BatchInfo storage targetBatch = batchInfo[batch];
617     if (targetBatch.startBlock <= block.number && block.number < targetBatch.endBlock) {
618       updateAllPools(batch);
619     }
620 
621     uint256 lastRewardBlock = block.number > targetBatch.startBlock ? block.number : targetBatch.startBlock;
622     batchInfo[batch].totalAllocPoint = targetBatch.totalAllocPoint.add(multiplier);
623     poolInfo[batch].push(PoolInfo({
624       stakingToken: stakingToken,
625       allocPoint: multiplier,
626       lastRewardBlock: lastRewardBlock,
627       accHoneyPerShare: 0,
628       totalShares: 0
629     }));
630   }
631 
632   // Return rewardable block count over the given _from to _to block.
633   function getPendingBlocks(uint256 batch, uint256 from, uint256 to) public view returns (uint256) {
634     require(batch < batchInfo.length, "batch must exist");   
635  
636     BatchInfo storage targetBatch = batchInfo[batch];
637 
638     if (to < targetBatch.startBlock) {
639       return 0;
640     }
641     
642     if (to > targetBatch.endBlock) {
643       if (from > targetBatch.endBlock) {
644         return 0;
645       } else {
646         return targetBatch.endBlock.sub(from);
647       }
648     } else {
649       return to.sub(from);
650     }
651   }
652 
653   // View function to see pending HONEYs on frontend.
654   function minedHoney(uint256 batch, uint256 pid, address account) external view returns (uint256) {
655     require(batch < batchInfo.length, "batch must exist");   
656     require(pid < poolInfo[batch].length, "pool must exist");
657     BatchInfo storage targetBatch = batchInfo[batch];
658 
659     if (block.number < targetBatch.startBlock) {
660       return 0;
661     }
662 
663     PoolInfo storage pool = poolInfo[batch][pid];
664     UserInfo storage user = userInfo[batch][pid][account];
665     uint256 accHoneyPerShare = pool.accHoneyPerShare;
666     if (block.number > pool.lastRewardBlock && pool.totalShares != 0) {
667       uint256 pendingBlocks = getPendingBlocks(batch, pool.lastRewardBlock, block.number);
668       uint256 honeyReward = pendingBlocks.mul(targetBatch.honeyPerBlock).mul(pool.allocPoint).div(targetBatch.totalAllocPoint);
669       accHoneyPerShare = accHoneyPerShare.add(honeyReward.mul(1e12).div(pool.totalShares));
670     }
671     return user.amount.mul(accHoneyPerShare).div(1e12).sub(user.rewardDebt).add(user.mined);
672   }
673 
674   function updateAllPools(uint256 batch) public {
675     require(batch < batchInfo.length, "batch must exist");
676 
677     uint256 length = poolInfo[batch].length;
678     for (uint256 pid = 0; pid < length; ++pid) {
679       updatePool(batch, pid);
680     }
681   }
682 
683   // Update reward variables of the given pool to be up-to-date.
684   function updatePool(uint256 batch, uint256 pid) public {
685     require(batch < batchInfo.length, "batch must exist");
686     require(pid < poolInfo[batch].length, "pool must exist");
687 
688     BatchInfo storage targetBatch = batchInfo[batch];
689     PoolInfo storage pool = poolInfo[batch][pid];
690 
691     if (block.number < targetBatch.startBlock || block.number <= pool.lastRewardBlock || pool.lastRewardBlock > targetBatch.endBlock) {
692       return;
693     }
694     if (pool.totalShares == 0) {
695       pool.lastRewardBlock = block.number;
696       return;
697     }
698     uint256 pendingBlocks = getPendingBlocks(batch, pool.lastRewardBlock, block.number);
699     uint256 honeyReward = pendingBlocks.mul(targetBatch.honeyPerBlock).mul(pool.allocPoint).div(targetBatch.totalAllocPoint);
700     pool.accHoneyPerShare = pool.accHoneyPerShare.add(honeyReward.mul(1e12).div(pool.totalShares));
701     pool.lastRewardBlock = block.number;
702   }
703 
704   // Deposit staking tokens for HONEY allocation.
705   function deposit(uint256 batch, uint256 pid, uint256 amount) public {
706     require(batch < batchInfo.length, "batch must exist");
707     require(pid < poolInfo[batch].length, "pool must exist");
708 
709     BatchInfo storage targetBatch = batchInfo[batch];
710 
711     require(block.number < targetBatch.endBlock, "batch ended");
712 
713     PoolInfo storage pool = poolInfo[batch][pid];
714     UserInfo storage user = userInfo[batch][pid][msg.sender];
715 
716     // 1. Update pool.accHoneyPerShare
717     updatePool(batch, pid);
718 
719     // 2. Transfer pending HONEY to user
720     if (user.amount > 0) {
721       uint256 pending = user.amount.mul(pool.accHoneyPerShare).div(1e12).sub(user.rewardDebt);
722       if (pending > 0) {
723         addToMined(batch, pid, msg.sender, pending);
724       }
725     }
726 
727     // 3. Transfer Staking Token from user to honeycomb
728     if (amount > 0) {
729       pool.stakingToken.safeTransferFrom(address(msg.sender), address(this), amount);
730       user.amount = user.amount.add(amount);
731     }
732 
733     // 4. Update user.rewardDebt
734     pool.totalShares = pool.totalShares.add(amount);
735     user.rewardDebt = user.amount.mul(pool.accHoneyPerShare).div(1e12);
736     emit Deposit(msg.sender, batch, pid, amount);
737   }
738 
739   // Withdraw staking tokens.
740   function withdraw(uint256 batch, uint256 pid, uint256 amount) public {
741     require(batch < batchInfo.length, "batch must exist");
742     require(pid < poolInfo[batch].length, "pool must exist");
743     UserInfo storage user = userInfo[batch][pid][msg.sender];
744     require(user.amount >= amount, "insufficient balance");
745 
746     // 1. Update pool.accHoneyPerShare
747     updatePool(batch, pid);
748 
749     // 2. Transfer pending HONEY to user
750     PoolInfo storage pool = poolInfo[batch][pid];
751     uint256 pending = user.amount.mul(pool.accHoneyPerShare).div(1e12).sub(user.rewardDebt);
752     if (pending > 0) {
753       addToMined(batch, pid, msg.sender, pending);
754     }
755 
756     // 3. Transfer Staking Token from honeycomb to user
757     pool.stakingToken.safeTransfer(address(msg.sender), amount);
758     user.amount = user.amount.sub(amount);
759 
760     // 4. Update user.rewardDebt
761     pool.totalShares = pool.totalShares.sub(amount);
762     user.rewardDebt = user.amount.mul(pool.accHoneyPerShare).div(1e12);
763     emit Withdraw(msg.sender, batch, pid, amount);
764   }
765 
766   // Withdraw without caring about rewards. EMERGENCY ONLY.
767   function emergencyWithdraw(uint256 batch, uint256 pid) public {
768     require(batch < batchInfo.length, "batch must exist");
769     require(pid < poolInfo[batch].length, "pool must exist");
770 
771     PoolInfo storage pool = poolInfo[batch][pid];
772     UserInfo storage user = userInfo[batch][pid][msg.sender];
773     pool.stakingToken.safeTransfer(address(msg.sender), user.amount);
774     emit EmergencyWithdraw(msg.sender, batch, pid, user.amount);
775     user.amount = 0;
776     user.rewardDebt = 0;
777   }
778 
779   function migrate(uint256 toBatch, uint256 toPid, uint256 amount, uint256 fromBatch, uint256 fromPid) public {
780     require(toBatch < batchInfo.length, "target batch must exist");
781     require(toPid < poolInfo[toBatch].length, "target pool must exist");
782     require(fromBatch < batchInfo.length, "source batch must exist");
783     require(fromPid < poolInfo[fromBatch].length, "source pool must exist");
784 
785     BatchInfo storage targetBatch = batchInfo[toBatch];
786     require(block.number < targetBatch.endBlock, "batch ended");
787 
788     UserInfo storage userFrom = userInfo[fromBatch][fromPid][msg.sender];
789     if (userFrom.amount > 0) {
790       PoolInfo storage poolFrom = poolInfo[fromBatch][fromPid];
791       PoolInfo storage poolTo = poolInfo[toBatch][toPid];
792       require(address(poolFrom.stakingToken) == address(poolTo.stakingToken), "must be the same token");
793       withdraw(fromBatch, fromPid, amount);
794       deposit(toBatch, toPid, amount);
795     }
796   }
797 
798   // Safe honey transfer function, just in case if rounding error causes pool to not have enough HONEYs.
799   function safeHoneyTransfer(uint256 batch, uint256 pid, address to, uint256 amount) internal {
800     uint256 honeyBal = honeyToken.balanceOf(address(this));
801     require(honeyBal > 0, "insufficient HONEY balance");
802 
803     UserInfo storage user = userInfo[batch][pid][to];
804     if (amount > honeyBal) {
805       honeyToken.transfer(to, honeyBal);
806       user.collected = user.collected.add(honeyBal);
807     } else {
808       honeyToken.transfer(to, amount);
809       user.collected = user.collected.add(amount);
810     }
811   }
812 
813   function addToMined(uint256 batch, uint256 pid, address account, uint256 amount) internal {
814     UserInfo storage user = userInfo[batch][pid][account];
815     user.mined = user.mined.add(amount);
816   }
817 
818   function startCollecting(uint256 batch, uint256 pid) external {
819     require(batch < batchInfo.length, "batch must exist");
820     require(pid < poolInfo[batch].length, "pool must exist");
821 
822     withdraw(batch, pid, 0);
823     
824     UserInfo storage user = userInfo[batch][pid][msg.sender];
825     CollectingInfo[] storage collecting = collectingInfo[batch][pid][msg.sender];
826 
827     if (user.mined > 0) {
828       collecting.push(CollectingInfo({
829         collectableTime: block.timestamp + collectingDuration,
830         amount: user.mined,
831         collected: false
832       }));
833       user.mined = 0;
834     }
835   }
836 
837   function collectingHoney(uint256 batch, uint256 pid, address account) external view returns (uint256) {
838     require(batch < batchInfo.length, "batch must exist");
839     require(pid < poolInfo[batch].length, "pool must exist");
840 
841     CollectingInfo[] storage collecting = collectingInfo[batch][pid][account];
842     uint256 total = 0;
843     for (uint i = 0; i < collecting.length; ++i) {
844       if (!collecting[i].collected && block.timestamp < collecting[i].collectableTime) {
845         total = total.add(collecting[i].amount);
846       }
847     }
848     return total;
849   }
850 
851   function collectableHoney(uint256 batch, uint256 pid, address account) external view returns (uint256) {
852     require(batch < batchInfo.length, "batch must exist");
853     require(pid < poolInfo[batch].length, "pool must exist");
854 
855     CollectingInfo[] storage collecting = collectingInfo[batch][pid][account];
856     uint256 total = 0;
857     for (uint i = 0; i < collecting.length; ++i) {
858       if (!collecting[i].collected && block.timestamp >= collecting[i].collectableTime) {
859         total = total.add(collecting[i].amount);
860       }
861     }
862     return total;
863   }
864 
865   function collectHoney(uint256 batch, uint256 pid) external {
866     require(batch < batchInfo.length, "batch must exist");
867     require(pid < poolInfo[batch].length, "pool must exist");
868 
869     CollectingInfo[] storage collecting = collectingInfo[batch][pid][msg.sender];
870     require(collecting.length > 0, "nothing to collect");
871 
872     uint256 total = 0;
873     for (uint i = 0; i < collecting.length; ++i) {
874       if (!collecting[i].collected && block.timestamp >= collecting[i].collectableTime) {
875         total = total.add(collecting[i].amount);
876         collecting[i].collected = true;
877       }
878     }
879 
880     safeHoneyTransfer(batch, pid, msg.sender, total);
881   }
882 
883   function instantCollectHoney(uint256 batch, uint256 pid) external {
884     require(batch < batchInfo.length, "batch must exist");
885     require(pid < poolInfo[batch].length, "pool must exist");
886 
887     withdraw(batch, pid, 0);
888     
889     UserInfo storage user = userInfo[batch][pid][msg.sender];
890     if (user.mined > 0) {
891       uint256 portion = 10000 - instantCollectBurnRate;
892       safeHoneyTransfer(batch, pid, msg.sender, user.mined.mul(portion).div(10000));
893       honeyToken.transfer(burnDestination, user.mined.mul(instantCollectBurnRate).div(10000));
894       user.mined = 0;
895     }
896   }
897 
898   function setInstantCollectBurnRate(uint256 value) public onlyOwner {
899     require(value <= 10000, "Value range: 0 ~ 10000");
900     instantCollectBurnRate = value;
901   }
902 
903   function setCollectingDuration(uint256 value) public onlyOwner {
904     collectingDuration = value;
905   }
906 }