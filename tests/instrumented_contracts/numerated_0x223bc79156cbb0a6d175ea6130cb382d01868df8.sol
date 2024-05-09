1 pragma solidity 0.6.12;
2 
3 
4 // 
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
79 // 
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
101      *
102      * - Addition cannot overflow.
103      */
104     function add(uint256 a, uint256 b) internal pure returns (uint256) {
105         uint256 c = a + b;
106         require(c >= a, "SafeMath: addition overflow");
107 
108         return c;
109     }
110 
111     /**
112      * @dev Returns the subtraction of two unsigned integers, reverting on
113      * overflow (when the result is negative).
114      *
115      * Counterpart to Solidity's `-` operator.
116      *
117      * Requirements:
118      *
119      * - Subtraction cannot overflow.
120      */
121     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
122         return sub(a, b, "SafeMath: subtraction overflow");
123     }
124 
125     /**
126      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
127      * overflow (when the result is negative).
128      *
129      * Counterpart to Solidity's `-` operator.
130      *
131      * Requirements:
132      *
133      * - Subtraction cannot overflow.
134      */
135     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
136         require(b <= a, errorMessage);
137         uint256 c = a - b;
138 
139         return c;
140     }
141 
142     /**
143      * @dev Returns the multiplication of two unsigned integers, reverting on
144      * overflow.
145      *
146      * Counterpart to Solidity's `*` operator.
147      *
148      * Requirements:
149      *
150      * - Multiplication cannot overflow.
151      */
152     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
153         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
154         // benefit is lost if 'b' is also tested.
155         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
156         if (a == 0) {
157             return 0;
158         }
159 
160         uint256 c = a * b;
161         require(c / a == b, "SafeMath: multiplication overflow");
162 
163         return c;
164     }
165 
166     /**
167      * @dev Returns the integer division of two unsigned integers. Reverts on
168      * division by zero. The result is rounded towards zero.
169      *
170      * Counterpart to Solidity's `/` operator. Note: this function uses a
171      * `revert` opcode (which leaves remaining gas untouched) while Solidity
172      * uses an invalid opcode to revert (consuming all remaining gas).
173      *
174      * Requirements:
175      *
176      * - The divisor cannot be zero.
177      */
178     function div(uint256 a, uint256 b) internal pure returns (uint256) {
179         return div(a, b, "SafeMath: division by zero");
180     }
181 
182     /**
183      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
184      * division by zero. The result is rounded towards zero.
185      *
186      * Counterpart to Solidity's `/` operator. Note: this function uses a
187      * `revert` opcode (which leaves remaining gas untouched) while Solidity
188      * uses an invalid opcode to revert (consuming all remaining gas).
189      *
190      * Requirements:
191      *
192      * - The divisor cannot be zero.
193      */
194     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
195         require(b > 0, errorMessage);
196         uint256 c = a / b;
197         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
198 
199         return c;
200     }
201 
202     /**
203      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
204      * Reverts when dividing by zero.
205      *
206      * Counterpart to Solidity's `%` operator. This function uses a `revert`
207      * opcode (which leaves remaining gas untouched) while Solidity uses an
208      * invalid opcode to revert (consuming all remaining gas).
209      *
210      * Requirements:
211      *
212      * - The divisor cannot be zero.
213      */
214     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
215         return mod(a, b, "SafeMath: modulo by zero");
216     }
217 
218     /**
219      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
220      * Reverts with custom message when dividing by zero.
221      *
222      * Counterpart to Solidity's `%` operator. This function uses a `revert`
223      * opcode (which leaves remaining gas untouched) while Solidity uses an
224      * invalid opcode to revert (consuming all remaining gas).
225      *
226      * Requirements:
227      *
228      * - The divisor cannot be zero.
229      */
230     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
231         require(b != 0, errorMessage);
232         return a % b;
233     }
234 }
235 
236 // 
237 /**
238  * @dev Collection of functions related to the address type
239  */
240 library Address {
241     /**
242      * @dev Returns true if `account` is a contract.
243      *
244      * [IMPORTANT]
245      * ====
246      * It is unsafe to assume that an address for which this function returns
247      * false is an externally-owned account (EOA) and not a contract.
248      *
249      * Among others, `isContract` will return false for the following
250      * types of addresses:
251      *
252      *  - an externally-owned account
253      *  - a contract in construction
254      *  - an address where a contract will be created
255      *  - an address where a contract lived, but was destroyed
256      * ====
257      */
258     function isContract(address account) internal view returns (bool) {
259         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
260         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
261         // for accounts without code, i.e. `keccak256('')`
262         bytes32 codehash;
263         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
264         // solhint-disable-next-line no-inline-assembly
265         assembly { codehash := extcodehash(account) }
266         return (codehash != accountHash && codehash != 0x0);
267     }
268 
269     /**
270      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
271      * `recipient`, forwarding all available gas and reverting on errors.
272      *
273      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
274      * of certain opcodes, possibly making contracts go over the 2300 gas limit
275      * imposed by `transfer`, making them unable to receive funds via
276      * `transfer`. {sendValue} removes this limitation.
277      *
278      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
279      *
280      * IMPORTANT: because control is transferred to `recipient`, care must be
281      * taken to not create reentrancy vulnerabilities. Consider using
282      * {ReentrancyGuard} or the
283      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
284      */
285     function sendValue(address payable recipient, uint256 amount) internal {
286         require(address(this).balance >= amount, "Address: insufficient balance");
287 
288         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
289         (bool success, ) = recipient.call{ value: amount }("");
290         require(success, "Address: unable to send value, recipient may have reverted");
291     }
292 
293     /**
294      * @dev Performs a Solidity function call using a low level `call`. A
295      * plain`call` is an unsafe replacement for a function call: use this
296      * function instead.
297      *
298      * If `target` reverts with a revert reason, it is bubbled up by this
299      * function (like regular Solidity function calls).
300      *
301      * Returns the raw returned data. To convert to the expected return value,
302      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
303      *
304      * Requirements:
305      *
306      * - `target` must be a contract.
307      * - calling `target` with `data` must not revert.
308      *
309      * _Available since v3.1._
310      */
311     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
312       return functionCall(target, data, "Address: low-level call failed");
313     }
314 
315     /**
316      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
317      * `errorMessage` as a fallback revert reason when `target` reverts.
318      *
319      * _Available since v3.1._
320      */
321     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
322         return _functionCallWithValue(target, data, 0, errorMessage);
323     }
324 
325     /**
326      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
327      * but also transferring `value` wei to `target`.
328      *
329      * Requirements:
330      *
331      * - the calling contract must have an ETH balance of at least `value`.
332      * - the called Solidity function must be `payable`.
333      *
334      * _Available since v3.1._
335      */
336     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
337         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
338     }
339 
340     /**
341      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
342      * with `errorMessage` as a fallback revert reason when `target` reverts.
343      *
344      * _Available since v3.1._
345      */
346     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
347         require(address(this).balance >= value, "Address: insufficient balance for call");
348         return _functionCallWithValue(target, data, value, errorMessage);
349     }
350 
351     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
352         require(isContract(target), "Address: call to non-contract");
353 
354         // solhint-disable-next-line avoid-low-level-calls
355         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
356         if (success) {
357             return returndata;
358         } else {
359             // Look for revert reason and bubble it up if present
360             if (returndata.length > 0) {
361                 // The easiest way to bubble the revert reason is using memory via assembly
362 
363                 // solhint-disable-next-line no-inline-assembly
364                 assembly {
365                     let returndata_size := mload(returndata)
366                     revert(add(32, returndata), returndata_size)
367                 }
368             } else {
369                 revert(errorMessage);
370             }
371         }
372     }
373 }
374 
375 // 
376 /**
377  * @title SafeERC20
378  * @dev Wrappers around ERC20 operations that throw on failure (when the token
379  * contract returns false). Tokens that return no value (and instead revert or
380  * throw on failure) are also supported, non-reverting calls are assumed to be
381  * successful.
382  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
383  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
384  */
385 library SafeERC20 {
386     using SafeMath for uint256;
387     using Address for address;
388 
389     function safeTransfer(IERC20 token, address to, uint256 value) internal {
390         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
391     }
392 
393     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
394         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
395     }
396 
397     /**
398      * @dev Deprecated. This function has issues similar to the ones found in
399      * {IERC20-approve}, and its usage is discouraged.
400      *
401      * Whenever possible, use {safeIncreaseAllowance} and
402      * {safeDecreaseAllowance} instead.
403      */
404     function safeApprove(IERC20 token, address spender, uint256 value) internal {
405         // safeApprove should only be called when setting an initial allowance,
406         // or when resetting it to zero. To increase and decrease it, use
407         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
408         // solhint-disable-next-line max-line-length
409         require((value == 0) || (token.allowance(address(this), spender) == 0),
410             "SafeERC20: approve from non-zero to non-zero allowance"
411         );
412         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
413     }
414 
415     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
416         uint256 newAllowance = token.allowance(address(this), spender).add(value);
417         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
418     }
419 
420     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
421         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
422         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
423     }
424 
425     /**
426      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
427      * on the return value: the return value is optional (but if data is returned, it must not be false).
428      * @param token The token targeted by the call.
429      * @param data The call data (encoded using abi.encode or one of its variants).
430      */
431     function _callOptionalReturn(IERC20 token, bytes memory data) private {
432         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
433         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
434         // the target address contains contract code and also asserts for success in the low-level call.
435 
436         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
437         if (returndata.length > 0) { // Return data is optional
438             // solhint-disable-next-line max-line-length
439             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
440         }
441     }
442 }
443 
444 // 
445 /*
446  * @dev Provides information about the current execution context, including the
447  * sender of the transaction and its data. While these are generally available
448  * via msg.sender and msg.data, they should not be accessed in such a direct
449  * manner, since when dealing with GSN meta-transactions the account sending and
450  * paying for execution may not be the actual sender (as far as an application
451  * is concerned).
452  *
453  * This contract is only required for intermediate, library-like contracts.
454  */
455 abstract contract Context {
456     function _msgSender() internal view virtual returns (address payable) {
457         return msg.sender;
458     }
459 
460     function _msgData() internal view virtual returns (bytes memory) {
461         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
462         return msg.data;
463     }
464 }
465 
466 // 
467 /**
468  * @dev Contract module which provides a basic access control mechanism, where
469  * there is an account (an owner) that can be granted exclusive access to
470  * specific functions.
471  *
472  * By default, the owner account will be the one that deploys the contract. This
473  * can later be changed with {transferOwnership}.
474  *
475  * This module is used through inheritance. It will make available the modifier
476  * `onlyOwner`, which can be applied to your functions to restrict their use to
477  * the owner.
478  */
479 contract Ownable is Context {
480     address private _owner;
481 
482     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
483 
484     /**
485      * @dev Initializes the contract setting the deployer as the initial owner.
486      */
487     constructor () internal {
488         address msgSender = _msgSender();
489         _owner = msgSender;
490         emit OwnershipTransferred(address(0), msgSender);
491     }
492 
493     /**
494      * @dev Returns the address of the current owner.
495      */
496     function owner() public view returns (address) {
497         return _owner;
498     }
499 
500     /**
501      * @dev Throws if called by any account other than the owner.
502      */
503     modifier onlyOwner() {
504         require(_owner == _msgSender(), "Ownable: caller is not the owner");
505         _;
506     }
507 
508     /**
509      * @dev Leaves the contract without owner. It will not be possible to call
510      * `onlyOwner` functions anymore. Can only be called by the current owner.
511      *
512      * NOTE: Renouncing ownership will leave the contract without an owner,
513      * thereby removing any functionality that is only available to the owner.
514      */
515     function renounceOwnership() public virtual onlyOwner {
516         emit OwnershipTransferred(_owner, address(0));
517         _owner = address(0);
518     }
519 
520     /**
521      * @dev Transfers ownership of the contract to a new account (`newOwner`).
522      * Can only be called by the current owner.
523      */
524     function transferOwnership(address newOwner) public virtual onlyOwner {
525         require(newOwner != address(0), "Ownable: new owner is the zero address");
526         emit OwnershipTransferred(_owner, newOwner);
527         _owner = newOwner;
528     }
529 }
530 
531 // import "./INBUNIERC20.sol";
532 // import "@nomiclabs/buidler/console.sol";
533 interface IMigratorToChadSwap {
534     // Perform LP token migration from legacy UniswapV2 to ChadSwap.
535     // Take the current LP token address and return the new LP token address.
536     // Migrator should have full access to the caller's LP token.
537     // Return the new LP token address.
538     //
539     // XXX Migrator must have allowance access to UniswapV2 LP tokens.
540     // ChadSwap must mint EXACTLY the same amount of ChadSwap LP tokens or
541     // else something bad will happen. Traditional UniswapV2 does not
542     // do that so be careful!
543     function migrate(IERC20 token) external returns (IERC20);
544 }
545 
546 interface IStacyVaultRewardsLock {
547     function lock(address _holder, uint256 _amount) external; 
548     function lockToBlock() external returns (uint256);
549 }
550 
551 // Only true Chads can enter Stacy's vault.
552 contract StacyVault is Ownable {
553     using SafeMath for uint256;
554     using SafeERC20 for IERC20;
555 
556     // Info of each user.
557     struct UserInfo {
558         uint256 amount; // How many  tokens the user has provided.
559         uint256 rewardDebt; // Reward debt. See explanation below.
560         uint256 lastDepositBlock;
561         //
562         // We do some fancy math here. Basically, any point in time, the amount of STACYs
563         // entitled to a user but is pending to be distributed is:
564         //
565         //   pending reward = (user.amount * pool.accStacyPerShare) - user.rewardDebt
566         //
567         // Whenever a user deposits or withdraws  tokens to a pool. Here's what happens:
568         //   1. The pool's `accStacyPerShare` (and `lastRewardBlock`) gets updated.
569         //   2. User receives the pending reward sent to his/her address.
570         //   3. User's `amount` gets updated.
571         //   4. User's `rewardDebt` gets updated.
572     }
573 
574     // Info of each pool.
575     struct PoolInfo {
576         IERC20 token; // Address of  token contract.
577         uint256 allocPoint; // How many allocation points assigned to this pool. STACYs to distribute per block.
578         uint256 accStacyPerShare; // Accumulated STACYs per share, times 1e12. See below.
579         bool withdrawable; // Is this pool withdrawable?
580         mapping(address => mapping(address => uint256)) allowance;
581     }
582 
583     IERC20 public stacy;
584     // Dev address.
585     address public devaddr;
586 
587     IStacyVaultRewardsLock public rewardsLock;
588 
589     // Info of each pool.
590     PoolInfo[] public poolInfo;
591     // Info of each user that stakes  tokens.
592     mapping(uint256 => mapping(address => UserInfo)) public userInfo;
593     // Total allocation poitns. Must be the sum of all allocation points in all pools.
594     uint256 public totalAllocPoint;
595 
596     //// pending rewards awaiting anyone to massUpdate
597     uint256 public pendingRewards;
598 
599     uint256 public contractStartBlock;
600     uint256 public epochCalculationStartBlock;
601     uint256 public cumulativeRewardsSinceStart;
602     uint256 public rewardsInThisEpoch;
603     uint public epoch;
604 
605     uint256 public constant PERCENT_LOCK_BONUS_REWARD = 75; // lock 75% of bonus reward
606 
607     // Returns fees generated since start of this contract
608     function averageFeesPerBlockSinceStart() external view returns (uint averagePerBlock) {
609         averagePerBlock = cumulativeRewardsSinceStart.add(rewardsInThisEpoch).div(block.number.sub(contractStartBlock));
610     }        
611 
612     // Returns averge fees in this epoch
613     function averageFeesPerBlockEpoch() external view returns (uint256 averagePerBlock) {
614         averagePerBlock = rewardsInThisEpoch.div(block.number.sub(epochCalculationStartBlock));
615     }
616 
617     // For easy graphing historical epoch rewards
618     mapping(uint => uint256) public epochRewards;
619 
620     //Starts a new calculation epoch
621     // Because averge since start will not be accurate
622     function startNewEpoch() public {
623         require(epochCalculationStartBlock + 50000 < block.number, "New epoch not ready yet"); // About a week
624         epochRewards[epoch] = rewardsInThisEpoch;
625         cumulativeRewardsSinceStart = cumulativeRewardsSinceStart.add(rewardsInThisEpoch);
626         rewardsInThisEpoch = 0;
627         epochCalculationStartBlock = block.number;
628         ++epoch;
629     }
630 
631     event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
632     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
633     event EmergencyWithdraw(
634         address indexed user,
635         uint256 indexed pid,
636         uint256 amount
637     );
638     event Approval(address indexed owner, address indexed spender, uint256 _pid, uint256 value);
639 
640     constructor(
641         IERC20 _stacy,
642         IStacyVaultRewardsLock _rewardsLock,
643         address _devaddr, 
644         address superAdmin
645     )
646     public
647     Ownable() 
648     {
649         DEV_FEE = 500; // 5% (of the burn %)
650         stacy = _stacy;
651         rewardsLock = _rewardsLock;
652         devaddr = _devaddr;
653         contractStartBlock = block.number;
654         _superAdmin = superAdmin;
655     }
656 
657     function poolLength() external view returns (uint256) {
658         return poolInfo.length;
659     }
660 
661     // Add a new token pool. Can only be called by the owner. 
662     function add(
663         uint256 _allocPoint,
664         IERC20 _token,
665         bool _withUpdate,
666         bool _withdrawable
667     ) public onlyOwner {
668         if (_withUpdate) {
669             massUpdatePools();
670         }
671 
672         uint256 length = poolInfo.length;
673         for (uint256 pid = 0; pid < length; ++pid) {
674             require(poolInfo[pid].token != _token,"Error pool already added");
675         }
676 
677         totalAllocPoint = totalAllocPoint.add(_allocPoint);
678 
679         poolInfo.push(
680             PoolInfo({
681                 token: _token,
682                 allocPoint: _allocPoint,
683                 accStacyPerShare: 0,
684                 withdrawable : _withdrawable
685             })
686         );
687     }
688 
689     // Update the given pool's STACYs allocation point. Can only be called by the owner.
690     function set(
691         uint256 _pid,
692         uint256 _allocPoint,
693         bool _withUpdate
694     ) public onlyOwner {
695         if (_withUpdate) {
696             massUpdatePools();
697         }
698         
699         totalAllocPoint = totalAllocPoint.sub(poolInfo[_pid].allocPoint).add(
700             _allocPoint
701         );
702         poolInfo[_pid].allocPoint = _allocPoint;
703     }
704 
705     // Update the given pool's ability to withdraw tokens
706     function setPoolWithdrawable(
707         uint256 _pid,
708         bool _withdrawable
709     ) public onlyOwner {
710         poolInfo[_pid].withdrawable = _withdrawable;
711     }
712 
713     function setRewardsLock(IStacyVaultRewardsLock _rewardsLock) public onlyOwner {
714         rewardsLock = _rewardsLock;
715     }
716 
717     // Sets the dev fee for this contract
718     // defaults at 5.00%
719     uint16 DEV_FEE;
720     function setDevFee(uint16 _DEV_FEE) public onlyOwner {
721         require(_DEV_FEE <= 1000, 'Dev fee clamped at 10%');
722         DEV_FEE = _DEV_FEE;
723     }
724     uint256 pending_DEV_rewards;
725 
726 
727     // View function to see pending STACYs on frontend.
728     function pendingStacy(uint256 _pid, address _user)
729         public
730         view
731         returns (uint256)
732     {
733         PoolInfo storage pool = poolInfo[_pid];
734         UserInfo storage user = userInfo[_pid][_user];
735         uint256 accStacyPerShare = pool.accStacyPerShare;
736 
737         return user.amount.mul(accStacyPerShare).div(1e12).sub(user.rewardDebt);
738     }
739 
740     // Update reward vairables for all pools. Be careful of gas spending!
741     function massUpdatePools() public {
742         // console.log("Mass Updating Pools");
743         uint256 length = poolInfo.length;
744         uint allRewards;
745         for (uint256 pid = 0; pid < length; ++pid) {
746             allRewards = allRewards.add(updatePool(pid));
747         }
748 
749         pendingRewards = pendingRewards.sub(allRewards);
750     }
751 
752     // ----
753     // Function that adds pending rewards, called by the STACY token.
754     // ----
755     uint256 private stacyBalance;
756     function addPendingRewards(uint256 _) public {
757         uint256 newRewards = stacy.balanceOf(address(this)).sub(stacyBalance);
758         
759         if (newRewards > 0) {
760             stacyBalance = stacy.balanceOf(address(this)); // If there is no change the balance didn't change
761             pendingRewards = pendingRewards.add(newRewards);
762             rewardsInThisEpoch = rewardsInThisEpoch.add(newRewards);
763         }
764     }
765 
766     // Update reward variables of the given pool to be up-to-date.
767     function updatePool(uint256 _pid) internal returns (uint256 stacyRewardWhole) {
768         PoolInfo storage pool = poolInfo[_pid];
769 
770         uint256 tokenSupply = pool.token.balanceOf(address(this));
771         if (tokenSupply == 0) { // avoids division by 0 errors
772             return 0;
773         }
774         stacyRewardWhole = pendingRewards // Multiplies pending rewards by allocation point of this pool and then total allocation
775             .mul(pool.allocPoint)        // getting the percent of total pending rewards this pool should get
776             .div(totalAllocPoint);       // we can do this because pools are only mass updated
777         uint256 stacyRewardFee = stacyRewardWhole.mul(DEV_FEE).div(10000);
778         uint256 stacyRewardToDistribute = stacyRewardWhole.sub(stacyRewardFee);
779 
780         pending_DEV_rewards = pending_DEV_rewards.add(stacyRewardFee);
781 
782         pool.accStacyPerShare = pool.accStacyPerShare.add(
783             stacyRewardToDistribute.mul(1e12).div(tokenSupply)
784         );
785     }
786 
787     function deposit(uint256 _pid, uint256 _amount) public {
788 
789         PoolInfo storage pool = poolInfo[_pid];
790         UserInfo storage user = userInfo[_pid][msg.sender];
791 
792         massUpdatePools();
793         
794         // Transfer pending tokens
795         // to user
796         updateAndPayOutPending(_pid, msg.sender);
797 
798         // Transfer in the amounts from user
799         // save gas
800         if (_amount > 0) {
801             pool.token.safeTransferFrom(address(msg.sender), address(this), _amount);
802             user.amount = user.amount.add(_amount);
803         }
804 
805 
806         user.rewardDebt = user.amount.mul(pool.accStacyPerShare).div(1e12);
807         user.lastDepositBlock = block.number;
808         emit Deposit(msg.sender, _pid, _amount);
809     }
810 
811     // Test coverage
812     // [x] Does user get the deposited amounts?
813     // [x] Does user that its deposited for update correcty?
814     // [x] Does the depositor get their tokens decreased
815     function depositFor(address depositForAddress, uint256 _pid, uint256 _amount) public {
816         // requires no allowances
817         PoolInfo storage pool = poolInfo[_pid];
818         UserInfo storage user = userInfo[_pid][depositForAddress];
819 
820         massUpdatePools();
821         
822         // Transfer pending tokens
823         // to user
824         updateAndPayOutPending(_pid, depositForAddress); // Update the balances of person that amount is being deposited for
825 
826         if(_amount > 0) {
827             pool.token.safeTransferFrom(address(msg.sender), address(this), _amount);
828             user.amount = user.amount.add(_amount); // This is depositedFor address
829         }
830 
831         user.rewardDebt = user.amount.mul(pool.accStacyPerShare).div(1e12); /// This is deposited for address
832         emit Deposit(depositForAddress, _pid, _amount);
833 
834     }
835 
836     // Test coverage
837     // [x] Does allowance update correctly?
838     function setAllowanceForPoolToken(address spender, uint256 _pid, uint256 value) public {
839         PoolInfo storage pool = poolInfo[_pid];
840         pool.allowance[msg.sender][spender] = value;
841         emit Approval(msg.sender, spender, _pid, value);
842     }
843 
844     // Test coverage
845     // [x] Does allowance decrease?
846     // [x] Do oyu need allowance
847     // [x] Withdraws to correct address
848     function withdrawFrom(address owner, uint256 _pid, uint256 _amount) public{
849         PoolInfo storage pool = poolInfo[_pid];
850         require(pool.allowance[owner][msg.sender] >= _amount, "withdraw: insufficient allowance");
851         pool.allowance[owner][msg.sender] = pool.allowance[owner][msg.sender].sub(_amount);
852         _withdraw(_pid, _amount, owner, msg.sender);
853     }
854 
855     function withdraw(uint256 _pid, uint256 _amount) public {
856         _withdraw(_pid, _amount, msg.sender, msg.sender);
857     }
858 
859     // Low level withdraw function
860     function _withdraw(uint256 _pid, uint256 _amount, address from, address to) internal {
861         PoolInfo storage pool = poolInfo[_pid];
862         require(pool.withdrawable, "Withdrawing from this pool is disabled");
863         UserInfo storage user = userInfo[_pid][from];
864         require(user.amount >= _amount, "withdraw: not good");
865         require(block.number > user.lastDepositBlock, "withdraw: same block as deposit");
866 
867         massUpdatePools();
868         updateAndPayOutPending(_pid, from); // Update balances of from this is not withdrawal but claiming STACY farmed
869 
870         if (_amount > 0) {
871             user.amount = user.amount.sub(_amount);
872             pool.token.safeTransfer(address(to), _amount);
873         }
874         user.rewardDebt = user.amount.mul(pool.accStacyPerShare).div(1e12);
875 
876         emit Withdraw(to, _pid, _amount);
877     }
878 
879     // Withdraw without caring about rewards. EMERGENCY ONLY.
880     // !Caution this will remove all your pending rewards!
881     function emergencyWithdraw(uint256 _pid) public {
882         PoolInfo storage pool = poolInfo[_pid];
883         require(pool.withdrawable, "Withdrawing from this pool is disabled");
884         UserInfo storage user = userInfo[_pid][msg.sender];
885         pool.token.safeTransfer(address(msg.sender), user.amount);
886         emit EmergencyWithdraw(msg.sender, _pid, user.amount);
887         user.amount = 0;
888         user.rewardDebt = 0;
889         // No mass update dont update pending rewards
890     }    
891 
892     function updateAndPayOutPending(uint256 _pid, address _addr) internal {
893         uint256 pending = pendingStacy(_pid, _addr);
894 
895         if (pending > 0) {
896             uint256 stacyBal = stacy.balanceOf(address(this));
897             uint256 availableAmountToTransfer = pending > stacyBal ? stacyBal : pending;
898 
899             // if (block.number < rewardsLock.lockToBlock()) {}
900 
901             uint256 lockAmount = availableAmountToTransfer.mul(PERCENT_LOCK_BONUS_REWARD).div(100);
902 
903             // Transfer 25% immediately
904             stacy.transfer(_addr, availableAmountToTransfer.sub(lockAmount));
905 
906             // Lock the remaining 75% in the vault rewards lock contract
907             stacy.safeApprove(address(rewardsLock), lockAmount);
908             // console.log("lockAmount", lockAmount, "amountTransferred", availableAmountToTransfer);
909             rewardsLock.lock(_addr, lockAmount);
910             stacy.safeApprove(address(rewardsLock), 0);
911 
912             // Book keeping
913             stacyBalance = stacy.balanceOf(address(this));
914 
915             transferDevFee();
916         }
917     }
918 
919     // function that lets owner/governance contract
920     // approve allowance for any token inside this contract
921     // This means all future UNI like airdrops are covered
922     // And at the same time allows us to give allowance to strategy contracts.
923     // Upcoming cYFI etc vaults strategy contracts will  se this function to manage and farm yield on value locked
924     function setStrategyContractOrDistributionContractAllowance(address tokenAddress, uint256 _amount, address contractAddress) public onlySuperAdmin {
925         require(isContract(contractAddress), "Recipent is not a smart contract, BAD");
926         require(block.number > contractStartBlock.add(95_000), "Governance setup grace period not over"); // about 2weeks
927         IERC20(tokenAddress).approve(contractAddress, _amount);
928     }
929 
930     function isContract(address addr) public returns (bool) {
931         uint size;
932         assembly { size := extcodesize(addr) }
933         return size > 0;
934     }
935 
936     // Safe stacy transfer function, just in case if rounding error causes pool to not have enough STACYs.
937     function safeStacyTransfer(address _to, uint256 _amount) internal returns (uint256 amountToTransfer) {
938         uint256 stacyBal = stacy.balanceOf(address(this));
939 
940         amountToTransfer = _amount > stacyBal ? stacyBal : _amount;
941         stacy.transfer(_to, amountToTransfer);
942         stacyBalance = stacy.balanceOf(address(this));
943 
944         transferDevFee();
945 
946         return amountToTransfer;
947     }
948 
949     function transferDevFee() public {
950         if (pending_DEV_rewards == 0) {
951             return;
952         }
953 
954         uint256 stacyBal = stacy.balanceOf(address(this));
955         if (pending_DEV_rewards > stacyBal) {
956             stacy.transfer(devaddr, stacyBal);
957             stacyBalance = stacy.balanceOf(address(this));
958         } else {
959             stacy.transfer(devaddr, pending_DEV_rewards);
960             stacyBalance = stacy.balanceOf(address(this));
961         }
962 
963         pending_DEV_rewards = 0;
964     }
965 
966     // Update dev address by the previous dev.
967     // Note onlyOwner functions are meant for the governance contract
968     function setDevFeeReciever(address _devaddr) public onlyOwner {
969         devaddr = _devaddr;
970     }
971 
972     address private _superAdmin;
973 
974     event SuperAdminTransfered(address indexed previousOwner, address indexed newOwner);
975 
976     /**
977      * @dev Returns the address of the current super admin
978      */
979     function superAdmin() public view returns (address) {
980         return _superAdmin;
981     }
982 
983     /**
984      * @dev Throws if called by any account other than the superAdmin
985      */
986     modifier onlySuperAdmin() {
987         require(_superAdmin == _msgSender(), "Super admin : caller is not super admin.");
988         _;
989     }
990 
991     // Assisns super admint to address 0, making it unreachable forever
992     function burnSuperAdmin() public virtual onlySuperAdmin {
993         emit SuperAdminTransfered(_superAdmin, address(0));
994         _superAdmin = address(0);
995     }
996 
997     // Super admin can transfer its powers to another address
998     function newSuperAdmin(address newOwner) public virtual onlySuperAdmin {
999         require(newOwner != address(0), "Ownable: new owner is the zero address");
1000         emit SuperAdminTransfered(_superAdmin, newOwner);
1001         _superAdmin = newOwner;
1002     }
1003 
1004     // ChadSwap hooks
1005 
1006     IMigratorToChadSwap public migrator;
1007 
1008     function setMigrator(IMigratorToChadSwap _migrator) public onlyOwner {
1009         migrator = _migrator;
1010     }
1011 
1012     function migrate(uint256 _pid) public {
1013         require(address(migrator) != address(0), "migrate: no migrator");
1014         PoolInfo storage pool = poolInfo[_pid];
1015         IERC20 lpToken = pool.token;
1016         uint256 bal = lpToken.balanceOf(address(this));
1017         lpToken.safeApprove(address(migrator), bal);
1018         IERC20 newLpToken = migrator.migrate(lpToken);
1019         require(bal == newLpToken.balanceOf(address(this)), "migrate: bad");
1020         pool.token = newLpToken;
1021     }
1022 }