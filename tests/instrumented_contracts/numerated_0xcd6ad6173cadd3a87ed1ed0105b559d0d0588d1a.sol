1 // Sources flattened with hardhat v2.0.2 https://hardhat.org
2 
3 // File @openzeppelin/contracts/GSN/Context.sol@v3.2.0
4 
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity ^0.6.0;
8 
9 /*
10  * @dev Provides information about the current execution context, including the
11  * sender of the transaction and its data. While these are generally available
12  * via msg.sender and msg.data, they should not be accessed in such a direct
13  * manner, since when dealing with GSN meta-transactions the account sending and
14  * paying for execution may not be the actual sender (as far as an application
15  * is concerned).
16  *
17  * This contract is only required for intermediate, library-like contracts.
18  */
19 abstract contract Context {
20     function _msgSender() internal view virtual returns (address payable) {
21         return msg.sender;
22     }
23 
24     function _msgData() internal view virtual returns (bytes memory) {
25         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
26         return msg.data;
27     }
28 }
29 
30 
31 // File @openzeppelin/contracts/access/Ownable.sol@v3.2.0
32 
33 // SPDX-License-Identifier: MIT
34 
35 pragma solidity ^0.6.0;
36 
37 /**
38  * @dev Contract module which provides a basic access control mechanism, where
39  * there is an account (an owner) that can be granted exclusive access to
40  * specific functions.
41  *
42  * By default, the owner account will be the one that deploys the contract. This
43  * can later be changed with {transferOwnership}.
44  *
45  * This module is used through inheritance. It will make available the modifier
46  * `onlyOwner`, which can be applied to your functions to restrict their use to
47  * the owner.
48  */
49 contract Ownable is Context {
50     address private _owner;
51 
52     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
53 
54     /**
55      * @dev Initializes the contract setting the deployer as the initial owner.
56      */
57     constructor () internal {
58         address msgSender = _msgSender();
59         _owner = msgSender;
60         emit OwnershipTransferred(address(0), msgSender);
61     }
62 
63     /**
64      * @dev Returns the address of the current owner.
65      */
66     function owner() public view returns (address) {
67         return _owner;
68     }
69 
70     /**
71      * @dev Throws if called by any account other than the owner.
72      */
73     modifier onlyOwner() {
74         require(_owner == _msgSender(), "Ownable: caller is not the owner");
75         _;
76     }
77 
78     /**
79      * @dev Leaves the contract without owner. It will not be possible to call
80      * `onlyOwner` functions anymore. Can only be called by the current owner.
81      *
82      * NOTE: Renouncing ownership will leave the contract without an owner,
83      * thereby removing any functionality that is only available to the owner.
84      */
85     function renounceOwnership() public virtual onlyOwner {
86         emit OwnershipTransferred(_owner, address(0));
87         _owner = address(0);
88     }
89 
90     /**
91      * @dev Transfers ownership of the contract to a new account (`newOwner`).
92      * Can only be called by the current owner.
93      */
94     function transferOwnership(address newOwner) public virtual onlyOwner {
95         require(newOwner != address(0), "Ownable: new owner is the zero address");
96         emit OwnershipTransferred(_owner, newOwner);
97         _owner = newOwner;
98     }
99 }
100 
101 
102 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v3.2.0
103 
104 // SPDX-License-Identifier: MIT
105 
106 pragma solidity ^0.6.0;
107 
108 /**
109  * @dev Interface of the ERC20 standard as defined in the EIP.
110  */
111 interface IERC20 {
112     /**
113      * @dev Returns the amount of tokens in existence.
114      */
115     function totalSupply() external view returns (uint256);
116 
117     /**
118      * @dev Returns the amount of tokens owned by `account`.
119      */
120     function balanceOf(address account) external view returns (uint256);
121 
122     /**
123      * @dev Moves `amount` tokens from the caller's account to `recipient`.
124      *
125      * Returns a boolean value indicating whether the operation succeeded.
126      *
127      * Emits a {Transfer} event.
128      */
129     function transfer(address recipient, uint256 amount) external returns (bool);
130 
131     /**
132      * @dev Returns the remaining number of tokens that `spender` will be
133      * allowed to spend on behalf of `owner` through {transferFrom}. This is
134      * zero by default.
135      *
136      * This value changes when {approve} or {transferFrom} are called.
137      */
138     function allowance(address owner, address spender) external view returns (uint256);
139 
140     /**
141      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
142      *
143      * Returns a boolean value indicating whether the operation succeeded.
144      *
145      * IMPORTANT: Beware that changing an allowance with this method brings the risk
146      * that someone may use both the old and the new allowance by unfortunate
147      * transaction ordering. One possible solution to mitigate this race
148      * condition is to first reduce the spender's allowance to 0 and set the
149      * desired value afterwards:
150      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
151      *
152      * Emits an {Approval} event.
153      */
154     function approve(address spender, uint256 amount) external returns (bool);
155 
156     /**
157      * @dev Moves `amount` tokens from `sender` to `recipient` using the
158      * allowance mechanism. `amount` is then deducted from the caller's
159      * allowance.
160      *
161      * Returns a boolean value indicating whether the operation succeeded.
162      *
163      * Emits a {Transfer} event.
164      */
165     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
166 
167     /**
168      * @dev Emitted when `value` tokens are moved from one account (`from`) to
169      * another (`to`).
170      *
171      * Note that `value` may be zero.
172      */
173     event Transfer(address indexed from, address indexed to, uint256 value);
174 
175     /**
176      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
177      * a call to {approve}. `value` is the new allowance.
178      */
179     event Approval(address indexed owner, address indexed spender, uint256 value);
180 }
181 
182 
183 // File @openzeppelin/contracts/math/SafeMath.sol@v3.2.0
184 
185 // SPDX-License-Identifier: MIT
186 
187 pragma solidity ^0.6.0;
188 
189 /**
190  * @dev Wrappers over Solidity's arithmetic operations with added overflow
191  * checks.
192  *
193  * Arithmetic operations in Solidity wrap on overflow. This can easily result
194  * in bugs, because programmers usually assume that an overflow raises an
195  * error, which is the standard behavior in high level programming languages.
196  * `SafeMath` restores this intuition by reverting the transaction when an
197  * operation overflows.
198  *
199  * Using this library instead of the unchecked operations eliminates an entire
200  * class of bugs, so it's recommended to use it always.
201  */
202 library SafeMath {
203     /**
204      * @dev Returns the addition of two unsigned integers, reverting on
205      * overflow.
206      *
207      * Counterpart to Solidity's `+` operator.
208      *
209      * Requirements:
210      *
211      * - Addition cannot overflow.
212      */
213     function add(uint256 a, uint256 b) internal pure returns (uint256) {
214         uint256 c = a + b;
215         require(c >= a, "SafeMath: addition overflow");
216 
217         return c;
218     }
219 
220     /**
221      * @dev Returns the subtraction of two unsigned integers, reverting on
222      * overflow (when the result is negative).
223      *
224      * Counterpart to Solidity's `-` operator.
225      *
226      * Requirements:
227      *
228      * - Subtraction cannot overflow.
229      */
230     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
231         return sub(a, b, "SafeMath: subtraction overflow");
232     }
233 
234     /**
235      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
236      * overflow (when the result is negative).
237      *
238      * Counterpart to Solidity's `-` operator.
239      *
240      * Requirements:
241      *
242      * - Subtraction cannot overflow.
243      */
244     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
245         require(b <= a, errorMessage);
246         uint256 c = a - b;
247 
248         return c;
249     }
250 
251     /**
252      * @dev Returns the multiplication of two unsigned integers, reverting on
253      * overflow.
254      *
255      * Counterpart to Solidity's `*` operator.
256      *
257      * Requirements:
258      *
259      * - Multiplication cannot overflow.
260      */
261     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
262         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
263         // benefit is lost if 'b' is also tested.
264         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
265         if (a == 0) {
266             return 0;
267         }
268 
269         uint256 c = a * b;
270         require(c / a == b, "SafeMath: multiplication overflow");
271 
272         return c;
273     }
274 
275     /**
276      * @dev Returns the integer division of two unsigned integers. Reverts on
277      * division by zero. The result is rounded towards zero.
278      *
279      * Counterpart to Solidity's `/` operator. Note: this function uses a
280      * `revert` opcode (which leaves remaining gas untouched) while Solidity
281      * uses an invalid opcode to revert (consuming all remaining gas).
282      *
283      * Requirements:
284      *
285      * - The divisor cannot be zero.
286      */
287     function div(uint256 a, uint256 b) internal pure returns (uint256) {
288         return div(a, b, "SafeMath: division by zero");
289     }
290 
291     /**
292      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
293      * division by zero. The result is rounded towards zero.
294      *
295      * Counterpart to Solidity's `/` operator. Note: this function uses a
296      * `revert` opcode (which leaves remaining gas untouched) while Solidity
297      * uses an invalid opcode to revert (consuming all remaining gas).
298      *
299      * Requirements:
300      *
301      * - The divisor cannot be zero.
302      */
303     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
304         require(b > 0, errorMessage);
305         uint256 c = a / b;
306         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
307 
308         return c;
309     }
310 
311     /**
312      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
313      * Reverts when dividing by zero.
314      *
315      * Counterpart to Solidity's `%` operator. This function uses a `revert`
316      * opcode (which leaves remaining gas untouched) while Solidity uses an
317      * invalid opcode to revert (consuming all remaining gas).
318      *
319      * Requirements:
320      *
321      * - The divisor cannot be zero.
322      */
323     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
324         return mod(a, b, "SafeMath: modulo by zero");
325     }
326 
327     /**
328      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
329      * Reverts with custom message when dividing by zero.
330      *
331      * Counterpart to Solidity's `%` operator. This function uses a `revert`
332      * opcode (which leaves remaining gas untouched) while Solidity uses an
333      * invalid opcode to revert (consuming all remaining gas).
334      *
335      * Requirements:
336      *
337      * - The divisor cannot be zero.
338      */
339     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
340         require(b != 0, errorMessage);
341         return a % b;
342     }
343 }
344 
345 
346 // File @openzeppelin/contracts/utils/Address.sol@v3.2.0
347 
348 // SPDX-License-Identifier: MIT
349 
350 pragma solidity ^0.6.2;
351 
352 /**
353  * @dev Collection of functions related to the address type
354  */
355 library Address {
356     /**
357      * @dev Returns true if `account` is a contract.
358      *
359      * [IMPORTANT]
360      * ====
361      * It is unsafe to assume that an address for which this function returns
362      * false is an externally-owned account (EOA) and not a contract.
363      *
364      * Among others, `isContract` will return false for the following
365      * types of addresses:
366      *
367      *  - an externally-owned account
368      *  - a contract in construction
369      *  - an address where a contract will be created
370      *  - an address where a contract lived, but was destroyed
371      * ====
372      */
373     function isContract(address account) internal view returns (bool) {
374         // This method relies in extcodesize, which returns 0 for contracts in
375         // construction, since the code is only stored at the end of the
376         // constructor execution.
377 
378         uint256 size;
379         // solhint-disable-next-line no-inline-assembly
380         assembly { size := extcodesize(account) }
381         return size > 0;
382     }
383 
384     /**
385      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
386      * `recipient`, forwarding all available gas and reverting on errors.
387      *
388      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
389      * of certain opcodes, possibly making contracts go over the 2300 gas limit
390      * imposed by `transfer`, making them unable to receive funds via
391      * `transfer`. {sendValue} removes this limitation.
392      *
393      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
394      *
395      * IMPORTANT: because control is transferred to `recipient`, care must be
396      * taken to not create reentrancy vulnerabilities. Consider using
397      * {ReentrancyGuard} or the
398      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
399      */
400     function sendValue(address payable recipient, uint256 amount) internal {
401         require(address(this).balance >= amount, "Address: insufficient balance");
402 
403         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
404         (bool success, ) = recipient.call{ value: amount }("");
405         require(success, "Address: unable to send value, recipient may have reverted");
406     }
407 
408     /**
409      * @dev Performs a Solidity function call using a low level `call`. A
410      * plain`call` is an unsafe replacement for a function call: use this
411      * function instead.
412      *
413      * If `target` reverts with a revert reason, it is bubbled up by this
414      * function (like regular Solidity function calls).
415      *
416      * Returns the raw returned data. To convert to the expected return value,
417      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
418      *
419      * Requirements:
420      *
421      * - `target` must be a contract.
422      * - calling `target` with `data` must not revert.
423      *
424      * _Available since v3.1._
425      */
426     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
427       return functionCall(target, data, "Address: low-level call failed");
428     }
429 
430     /**
431      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
432      * `errorMessage` as a fallback revert reason when `target` reverts.
433      *
434      * _Available since v3.1._
435      */
436     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
437         return _functionCallWithValue(target, data, 0, errorMessage);
438     }
439 
440     /**
441      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
442      * but also transferring `value` wei to `target`.
443      *
444      * Requirements:
445      *
446      * - the calling contract must have an ETH balance of at least `value`.
447      * - the called Solidity function must be `payable`.
448      *
449      * _Available since v3.1._
450      */
451     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
452         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
453     }
454 
455     /**
456      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
457      * with `errorMessage` as a fallback revert reason when `target` reverts.
458      *
459      * _Available since v3.1._
460      */
461     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
462         require(address(this).balance >= value, "Address: insufficient balance for call");
463         return _functionCallWithValue(target, data, value, errorMessage);
464     }
465 
466     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
467         require(isContract(target), "Address: call to non-contract");
468 
469         // solhint-disable-next-line avoid-low-level-calls
470         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
471         if (success) {
472             return returndata;
473         } else {
474             // Look for revert reason and bubble it up if present
475             if (returndata.length > 0) {
476                 // The easiest way to bubble the revert reason is using memory via assembly
477 
478                 // solhint-disable-next-line no-inline-assembly
479                 assembly {
480                     let returndata_size := mload(returndata)
481                     revert(add(32, returndata), returndata_size)
482                 }
483             } else {
484                 revert(errorMessage);
485             }
486         }
487     }
488 }
489 
490 
491 // File @openzeppelin/contracts/token/ERC20/SafeERC20.sol@v3.2.0
492 
493 // SPDX-License-Identifier: MIT
494 
495 pragma solidity ^0.6.0;
496 
497 
498 
499 /**
500  * @title SafeERC20
501  * @dev Wrappers around ERC20 operations that throw on failure (when the token
502  * contract returns false). Tokens that return no value (and instead revert or
503  * throw on failure) are also supported, non-reverting calls are assumed to be
504  * successful.
505  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
506  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
507  */
508 library SafeERC20 {
509     using SafeMath for uint256;
510     using Address for address;
511 
512     function safeTransfer(IERC20 token, address to, uint256 value) internal {
513         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
514     }
515 
516     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
517         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
518     }
519 
520     /**
521      * @dev Deprecated. This function has issues similar to the ones found in
522      * {IERC20-approve}, and its usage is discouraged.
523      *
524      * Whenever possible, use {safeIncreaseAllowance} and
525      * {safeDecreaseAllowance} instead.
526      */
527     function safeApprove(IERC20 token, address spender, uint256 value) internal {
528         // safeApprove should only be called when setting an initial allowance,
529         // or when resetting it to zero. To increase and decrease it, use
530         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
531         // solhint-disable-next-line max-line-length
532         require((value == 0) || (token.allowance(address(this), spender) == 0),
533             "SafeERC20: approve from non-zero to non-zero allowance"
534         );
535         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
536     }
537 
538     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
539         uint256 newAllowance = token.allowance(address(this), spender).add(value);
540         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
541     }
542 
543     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
544         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
545         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
546     }
547 
548     /**
549      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
550      * on the return value: the return value is optional (but if data is returned, it must not be false).
551      * @param token The token targeted by the call.
552      * @param data The call data (encoded using abi.encode or one of its variants).
553      */
554     function _callOptionalReturn(IERC20 token, bytes memory data) private {
555         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
556         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
557         // the target address contains contract code and also asserts for success in the low-level call.
558 
559         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
560         if (returndata.length > 0) { // Return data is optional
561             // solhint-disable-next-line max-line-length
562             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
563         }
564     }
565 }
566 
567 
568 // File contracts/RampStaking.sol
569 
570 pragma solidity ^0.6.0;
571 
572 
573 
574 
575 contract RampStaking is Ownable {
576     using SafeMath for uint256;
577     using SafeERC20 for IERC20;
578 
579     uint256 DECIMALS = 18;
580     uint256 UNITS = 10 ** DECIMALS;
581 
582     // Info of each user.
583     struct UserInfo {
584         uint256 amount;             // How many LP tokens the user has provided.
585         uint256 rewardDebt;         // Reward debt. See explanation below.
586         uint256 rewardDebtAtBlock;  // the last block user stake
587     }
588 
589     // Info of each pool.
590     struct PoolInfo {
591         IERC20 token;             // Address of LP token contract.
592         uint256 rampPerBlock;       // Ramps to distribute per block.
593         uint256 lastRewardBlock;    // Last block number that Ramps distribution occurs.
594         uint256 accRampPerShare;    // Accumulated Ramps per share, times 1e18 (UNITS).
595     }
596 
597     IERC20 public rampToken;
598     address public rampTokenFarmingWallet;
599 
600     // The block number when Ramp mining starts.
601     uint256 public START_BLOCK;
602 
603     // Info of each pool.
604     PoolInfo[] public poolInfo;
605 
606     // poolId1 count from 1, subtraction 1 before using with poolInfo
607     mapping(address => uint256) public poolId1;
608 
609     // Info of each user that stakes LP tokens. pid => user address => info
610     mapping(uint256 => mapping(address => UserInfo)) public userInfo;
611 
612     // Default fee to burn is 5%
613     uint256 public feePercentage = 5;
614 
615     event Deposit(
616         address indexed user,
617         uint256 indexed poolId,
618         uint256 amount
619     );
620 
621     event Withdraw(
622         address indexed user,
623         uint256 indexed poolId,
624         uint256 amount
625     );
626 
627     event EmergencyWithdraw(
628         address indexed user,
629         uint256 indexed poolId,
630         uint256 amount
631     );
632 
633     event SendRampReward(
634         address indexed user,
635         uint256 indexed poolId,
636         uint256 amount
637     );
638 
639     constructor(
640         address _rampTokenAddress,
641         address _rampTokenFarmingWallet,
642         uint256 _startBlock
643     ) public {
644 
645         rampToken = IERC20(_rampTokenAddress);
646         rampTokenFarmingWallet = _rampTokenFarmingWallet;
647         START_BLOCK = _startBlock;
648     }
649 
650     /********************** PUBLIC ********************************/
651 
652 
653     // Add a new erc20 token to the pool. Can only be called by the owner.
654     function add(uint256 _rampPerBlock, IERC20 _token, bool _withUpdate) public onlyOwner {
655 
656         require(poolId1[address(_token)] == 0, "Token is already in pool");
657 
658         if (_withUpdate) {
659             massUpdatePools();
660         }
661 
662         uint256 lastRewardBlock = block.number > START_BLOCK ? block.number : START_BLOCK;
663 
664         poolId1[address(_token)] = poolInfo.length + 1;
665 
666         poolInfo.push(PoolInfo({
667         token : _token,
668         rampPerBlock : _rampPerBlock,
669         lastRewardBlock : lastRewardBlock,
670         accRampPerShare : 0
671         }));
672     }
673 
674     // Update the given pool's Ramp allocation point. Can only be called by the owner.
675     function set(uint256 _poolId, uint256 _rampPerBlock, bool _withUpdate) public onlyOwner {
676 
677         if (_withUpdate) {
678             massUpdatePools();
679         }
680 
681         poolInfo[_poolId].rampPerBlock = _rampPerBlock;
682 
683     }
684 
685     // Update reward variables for all pools. Be careful of gas spending!
686     function massUpdatePools() public {
687 
688         uint256 length = poolInfo.length;
689 
690         for (uint256 poolId = 0; poolId < length; ++poolId) {
691             updatePool(poolId);
692         }
693 
694     }
695 
696     // Update reward variables of the given pool to be up-to-date.
697     function updatePool(uint256 _poolId) public {
698         PoolInfo storage pool = poolInfo[_poolId];
699 
700         // Return if it's too early (if START_BLOCK is in the future probably)
701         if (block.number <= pool.lastRewardBlock) return;
702 
703         // Retrieve amount of tokens held in contract
704         uint256 poolBalance = pool.token.balanceOf(address(this));
705 
706         // If the contract holds no tokens at all, don't proceed.
707         if (poolBalance == 0) {
708             pool.lastRewardBlock = block.number;
709             return;
710         }
711 
712         // Calculate the amount of RAMP to send to the contract to pay out for this pool
713         uint256 rewards = getPoolReward(pool.lastRewardBlock, block.number, pool.rampPerBlock);
714 
715 
716         // Update the accumulated RampPerShare
717         pool.accRampPerShare = pool.accRampPerShare.add(rewards.mul(UNITS).div(poolBalance));
718 
719         // Update the last block
720         pool.lastRewardBlock = block.number;
721 
722     }
723 
724     // Get rewards for a specific amount of rampPerBlocks
725     function getPoolReward(uint256 _from, uint256 _to, uint256 _rampPerBlock)
726     public view
727     returns (uint256 rewards) {
728 
729         // Calculate number of blocks covered.
730         uint256 blockCount = _to.sub(_from);
731 
732         // Get the amount of RAMP for this pool
733         uint256 amount = blockCount.mul(_rampPerBlock);
734 
735         // Retrieve allowance and balance
736         uint256 allowedRamp = rampToken.allowance(rampTokenFarmingWallet, address(this));
737         uint256 farmingBalance = rampToken.balanceOf(rampTokenFarmingWallet);
738 
739         // If the actual balance is less than the allowance, use the balance.
740         allowedRamp = farmingBalance < allowedRamp ? farmingBalance : allowedRamp;
741 
742         // If we reached the total amount allowed already, return the allowedRamp
743         if (allowedRamp < amount) {
744             rewards = allowedRamp;
745         } else {
746             rewards = amount;
747         }
748     }
749 
750 
751     function claimReward(uint256 _poolId) public {
752         updatePool(_poolId);
753         _harvest(_poolId);
754     }
755 
756     // Deposit LP tokens to RampStaking for Ramp allocation.
757     function deposit(uint256 _poolId, uint256 _amount) public {
758         require(_amount > 0, "Amount cannot be 0");
759 
760         PoolInfo storage pool = poolInfo[_poolId];
761         UserInfo storage user = userInfo[_poolId][msg.sender];
762 
763         updatePool(_poolId);
764 
765         _harvest(_poolId);
766 
767         pool.token.safeTransferFrom(address(msg.sender), address(this), _amount);
768 
769         // This is the very first deposit
770         if (user.amount == 0) {
771             user.rewardDebtAtBlock = block.number;
772         }
773 
774         user.amount = user.amount.add(_amount);
775         user.rewardDebt = user.amount.mul(pool.accRampPerShare).div(UNITS);
776         emit Deposit(msg.sender, _poolId, _amount);
777     }
778 
779     // Withdraw LP tokens from RampStaking.
780     function withdraw(uint256 _poolId, uint256 _amount) public {
781         PoolInfo storage pool = poolInfo[_poolId];
782         UserInfo storage user = userInfo[_poolId][msg.sender];
783 
784         require(_amount > 0, "Amount cannot be 0");
785         require(user.amount >= _amount, "Cannot withdraw more than balance");
786 
787         updatePool(_poolId);
788         _harvest(_poolId);
789 
790         user.amount = user.amount.sub(_amount);
791 
792         pool.token.safeTransfer(address(msg.sender), _amount);
793 
794         user.rewardDebt = user.amount.mul(pool.accRampPerShare).div(UNITS);
795 
796         emit Withdraw(msg.sender, _poolId, _amount);
797     }
798 
799     // Withdraw without caring about rewards. EMERGENCY ONLY.
800     function emergencyWithdraw(uint256 _poolId) public {
801         PoolInfo storage pool = poolInfo[_poolId];
802         UserInfo storage user = userInfo[_poolId][msg.sender];
803 
804         pool.token.safeTransfer(address(msg.sender), user.amount);
805 
806         emit EmergencyWithdraw(msg.sender, _poolId, user.amount);
807 
808         user.amount = 0;
809         user.rewardDebt = 0;
810 
811     }
812 
813     /********************** EXTERNAL ********************************/
814 
815     // Return the number of registered pools
816     function poolLength() external view returns (uint256) {
817         return poolInfo.length;
818     }
819 
820     // View function to see pending Ramps on frontend.
821     function pendingReward(uint256 _poolId, address _user) external view returns (uint256) {
822 
823         PoolInfo storage pool = poolInfo[_poolId];
824         UserInfo storage user = userInfo[_poolId][_user];
825 
826         uint256 accRampPerShare = pool.accRampPerShare;
827         uint256 poolBalance = pool.token.balanceOf(address(this));
828 
829         if (block.number > pool.lastRewardBlock && poolBalance > 0) {
830 
831             uint256 rewards = getPoolReward(pool.lastRewardBlock, block.number, pool.rampPerBlock);
832             accRampPerShare = accRampPerShare.add(rewards.mul(UNITS).div(poolBalance));
833 
834         }
835 
836         uint256 pending = user.amount.mul(accRampPerShare).div(UNITS).sub(user.rewardDebt);
837 
838         uint256 fee = pending.mul(feePercentage).div(100);
839 
840         return pending.sub(fee);
841     }
842 
843     function setFee(uint256 _feePercentage) external onlyOwner {
844         require(_feePercentage <= 10, "Max 10");
845         feePercentage = _feePercentage;
846     }
847 
848     /********************** INTERNAL ********************************/
849 
850     // Burn Ramp tokens (used for fees)
851     function _burnRamp(uint256 _amount) internal {
852         // Since RampToken is using OpenZeppelin's ERC20, sending to address(0) is not possible
853         // We'll send to address(1) instead.
854         rampToken.transferFrom(rampTokenFarmingWallet, address(1), _amount);
855     }
856 
857     function _harvest(uint256 _poolId) internal {
858         PoolInfo storage pool = poolInfo[_poolId];
859         UserInfo storage user = userInfo[_poolId][msg.sender];
860 
861         if (user.amount == 0) return;
862 
863         uint256 pending = user.amount.mul(pool.accRampPerShare).div(UNITS).sub(user.rewardDebt);
864 
865         uint256 rampAvailable = rampToken.balanceOf(rampTokenFarmingWallet);
866 
867         if (pending > rampAvailable) {
868             pending = rampAvailable;
869         }
870 
871         if (pending > 0) {
872 
873             uint256 fee = pending.mul(feePercentage).div(100);
874 
875             // Burn the fees if there were any
876             _burnRamp(fee);
877 
878             // Pay out the pending rewards
879             rampToken.transferFrom(rampTokenFarmingWallet, msg.sender, pending.sub(fee));
880 
881             user.rewardDebtAtBlock = block.number;
882 
883             emit SendRampReward(msg.sender, _poolId, pending.sub(fee));
884         }
885 
886         user.rewardDebt = user.amount.mul(pool.accRampPerShare).div(UNITS);
887 
888     }
889 }