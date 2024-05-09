1 // SPDX-License-Identifier: GPL-3.0
2 
3 pragma solidity 0.6.12;
4 pragma experimental ABIEncoderV2;
5 
6 // Global Enums and Structs
7 
8 
9 
10 struct PoolInfo {
11     IERC20 lpToken;           // Address of LP token contract.
12     uint256 allocPoint;       // How many allocation points assigned to this pool. TOKENs to distribute per block.
13     uint256 lastRewardBlock;  // Last block number that TOKENs distribution occurs.
14     uint256 accPerShare;      // Accumulated TOKENs per share, times 1e12. See below.
15     uint256 lockPeriod;       // Lock period of LP pool
16 }
17 
18 // Part: OpenZeppelin/openzeppelin-contracts@3.1.0/Address
19 
20 /**
21  * @dev Collection of functions related to the address type
22  */
23 library Address {
24     /**
25      * @dev Returns true if `account` is a contract.
26      *
27      * [IMPORTANT]
28      * ====
29      * It is unsafe to assume that an address for which this function returns
30      * false is an externally-owned account (EOA) and not a contract.
31      *
32      * Among others, `isContract` will return false for the following
33      * types of addresses:
34      *
35      *  - an externally-owned account
36      *  - a contract in construction
37      *  - an address where a contract will be created
38      *  - an address where a contract lived, but was destroyed
39      * ====
40      */
41     function isContract(address account) internal view returns (bool) {
42         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
43         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
44         // for accounts without code, i.e. `keccak256('')`
45         bytes32 codehash;
46         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
47         // solhint-disable-next-line no-inline-assembly
48         assembly { codehash := extcodehash(account) }
49         return (codehash != accountHash && codehash != 0x0);
50     }
51 
52     /**
53      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
54      * `recipient`, forwarding all available gas and reverting on errors.
55      *
56      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
57      * of certain opcodes, possibly making contracts go over the 2300 gas limit
58      * imposed by `transfer`, making them unable to receive funds via
59      * `transfer`. {sendValue} removes this limitation.
60      *
61      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
62      *
63      * IMPORTANT: because control is transferred to `recipient`, care must be
64      * taken to not create reentrancy vulnerabilities. Consider using
65      * {ReentrancyGuard} or the
66      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
67      */
68     function sendValue(address payable recipient, uint256 amount) internal {
69         require(address(this).balance >= amount, "Address: insufficient balance");
70 
71         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
72         (bool success, ) = recipient.call{ value: amount }("");
73         require(success, "Address: unable to send value, recipient may have reverted");
74     }
75 
76     /**
77      * @dev Performs a Solidity function call using a low level `call`. A
78      * plain`call` is an unsafe replacement for a function call: use this
79      * function instead.
80      *
81      * If `target` reverts with a revert reason, it is bubbled up by this
82      * function (like regular Solidity function calls).
83      *
84      * Returns the raw returned data. To convert to the expected return value,
85      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
86      *
87      * Requirements:
88      *
89      * - `target` must be a contract.
90      * - calling `target` with `data` must not revert.
91      *
92      * _Available since v3.1._
93      */
94     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
95       return functionCall(target, data, "Address: low-level call failed");
96     }
97 
98     /**
99      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
100      * `errorMessage` as a fallback revert reason when `target` reverts.
101      *
102      * _Available since v3.1._
103      */
104     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
105         return _functionCallWithValue(target, data, 0, errorMessage);
106     }
107 
108     /**
109      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
110      * but also transferring `value` wei to `target`.
111      *
112      * Requirements:
113      *
114      * - the calling contract must have an ETH balance of at least `value`.
115      * - the called Solidity function must be `payable`.
116      *
117      * _Available since v3.1._
118      */
119     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
120         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
121     }
122 
123     /**
124      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
125      * with `errorMessage` as a fallback revert reason when `target` reverts.
126      *
127      * _Available since v3.1._
128      */
129     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
130         require(address(this).balance >= value, "Address: insufficient balance for call");
131         return _functionCallWithValue(target, data, value, errorMessage);
132     }
133 
134     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
135         require(isContract(target), "Address: call to non-contract");
136 
137         // solhint-disable-next-line avoid-low-level-calls
138         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
139         if (success) {
140             return returndata;
141         } else {
142             // Look for revert reason and bubble it up if present
143             if (returndata.length > 0) {
144                 // The easiest way to bubble the revert reason is using memory via assembly
145 
146                 // solhint-disable-next-line no-inline-assembly
147                 assembly {
148                     let returndata_size := mload(returndata)
149                     revert(add(32, returndata), returndata_size)
150                 }
151             } else {
152                 revert(errorMessage);
153             }
154         }
155     }
156 }
157 
158 // Part: OpenZeppelin/openzeppelin-contracts@3.1.0/Context
159 
160 /*
161  * @dev Provides information about the current execution context, including the
162  * sender of the transaction and its data. While these are generally available
163  * via msg.sender and msg.data, they should not be accessed in such a direct
164  * manner, since when dealing with GSN meta-transactions the account sending and
165  * paying for execution may not be the actual sender (as far as an application
166  * is concerned).
167  *
168  * This contract is only required for intermediate, library-like contracts.
169  */
170 abstract contract Context {
171     function _msgSender() internal view virtual returns (address payable) {
172         return msg.sender;
173     }
174 
175     function _msgData() internal view virtual returns (bytes memory) {
176         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
177         return msg.data;
178     }
179 }
180 
181 // Part: OpenZeppelin/openzeppelin-contracts@3.1.0/IERC20
182 
183 /**
184  * @dev Interface of the ERC20 standard as defined in the EIP.
185  */
186 interface IERC20 {
187     /**
188      * @dev Returns the amount of tokens in existence.
189      */
190     function totalSupply() external view returns (uint256);
191 
192     /**
193      * @dev Returns the amount of tokens owned by `account`.
194      */
195     function balanceOf(address account) external view returns (uint256);
196 
197     /**
198      * @dev Moves `amount` tokens from the caller's account to `recipient`.
199      *
200      * Returns a boolean value indicating whether the operation succeeded.
201      *
202      * Emits a {Transfer} event.
203      */
204     function transfer(address recipient, uint256 amount) external returns (bool);
205 
206     /**
207      * @dev Returns the remaining number of tokens that `spender` will be
208      * allowed to spend on behalf of `owner` through {transferFrom}. This is
209      * zero by default.
210      *
211      * This value changes when {approve} or {transferFrom} are called.
212      */
213     function allowance(address owner, address spender) external view returns (uint256);
214 
215     /**
216      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
217      *
218      * Returns a boolean value indicating whether the operation succeeded.
219      *
220      * IMPORTANT: Beware that changing an allowance with this method brings the risk
221      * that someone may use both the old and the new allowance by unfortunate
222      * transaction ordering. One possible solution to mitigate this race
223      * condition is to first reduce the spender's allowance to 0 and set the
224      * desired value afterwards:
225      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
226      *
227      * Emits an {Approval} event.
228      */
229     function approve(address spender, uint256 amount) external returns (bool);
230 
231     /**
232      * @dev Moves `amount` tokens from `sender` to `recipient` using the
233      * allowance mechanism. `amount` is then deducted from the caller's
234      * allowance.
235      *
236      * Returns a boolean value indicating whether the operation succeeded.
237      *
238      * Emits a {Transfer} event.
239      */
240     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
241 
242     /**
243      * @dev Emitted when `value` tokens are moved from one account (`from`) to
244      * another (`to`).
245      *
246      * Note that `value` may be zero.
247      */
248     event Transfer(address indexed from, address indexed to, uint256 value);
249 
250     /**
251      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
252      * a call to {approve}. `value` is the new allowance.
253      */
254     event Approval(address indexed owner, address indexed spender, uint256 value);
255 }
256 
257 // Part: OpenZeppelin/openzeppelin-contracts@3.1.0/Math
258 
259 /**
260  * @dev Standard math utilities missing in the Solidity language.
261  */
262 library Math {
263     /**
264      * @dev Returns the largest of two numbers.
265      */
266     function max(uint256 a, uint256 b) internal pure returns (uint256) {
267         return a >= b ? a : b;
268     }
269 
270     /**
271      * @dev Returns the smallest of two numbers.
272      */
273     function min(uint256 a, uint256 b) internal pure returns (uint256) {
274         return a < b ? a : b;
275     }
276 
277     /**
278      * @dev Returns the average of two numbers. The result is rounded towards
279      * zero.
280      */
281     function average(uint256 a, uint256 b) internal pure returns (uint256) {
282         // (a + b) / 2 can overflow, so we distribute
283         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
284     }
285 }
286 
287 // Part: OpenZeppelin/openzeppelin-contracts@3.1.0/SafeMath
288 
289 /**
290  * @dev Wrappers over Solidity's arithmetic operations with added overflow
291  * checks.
292  *
293  * Arithmetic operations in Solidity wrap on overflow. This can easily result
294  * in bugs, because programmers usually assume that an overflow raises an
295  * error, which is the standard behavior in high level programming languages.
296  * `SafeMath` restores this intuition by reverting the transaction when an
297  * operation overflows.
298  *
299  * Using this library instead of the unchecked operations eliminates an entire
300  * class of bugs, so it's recommended to use it always.
301  */
302 library SafeMath {
303     /**
304      * @dev Returns the addition of two unsigned integers, reverting on
305      * overflow.
306      *
307      * Counterpart to Solidity's `+` operator.
308      *
309      * Requirements:
310      *
311      * - Addition cannot overflow.
312      */
313     function add(uint256 a, uint256 b) internal pure returns (uint256) {
314         uint256 c = a + b;
315         require(c >= a, "SafeMath: addition overflow");
316 
317         return c;
318     }
319 
320     /**
321      * @dev Returns the subtraction of two unsigned integers, reverting on
322      * overflow (when the result is negative).
323      *
324      * Counterpart to Solidity's `-` operator.
325      *
326      * Requirements:
327      *
328      * - Subtraction cannot overflow.
329      */
330     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
331         return sub(a, b, "SafeMath: subtraction overflow");
332     }
333 
334     /**
335      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
336      * overflow (when the result is negative).
337      *
338      * Counterpart to Solidity's `-` operator.
339      *
340      * Requirements:
341      *
342      * - Subtraction cannot overflow.
343      */
344     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
345         require(b <= a, errorMessage);
346         uint256 c = a - b;
347 
348         return c;
349     }
350 
351     /**
352      * @dev Returns the multiplication of two unsigned integers, reverting on
353      * overflow.
354      *
355      * Counterpart to Solidity's `*` operator.
356      *
357      * Requirements:
358      *
359      * - Multiplication cannot overflow.
360      */
361     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
362         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
363         // benefit is lost if 'b' is also tested.
364         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
365         if (a == 0) {
366             return 0;
367         }
368 
369         uint256 c = a * b;
370         require(c / a == b, "SafeMath: multiplication overflow");
371 
372         return c;
373     }
374 
375     /**
376      * @dev Returns the integer division of two unsigned integers. Reverts on
377      * division by zero. The result is rounded towards zero.
378      *
379      * Counterpart to Solidity's `/` operator. Note: this function uses a
380      * `revert` opcode (which leaves remaining gas untouched) while Solidity
381      * uses an invalid opcode to revert (consuming all remaining gas).
382      *
383      * Requirements:
384      *
385      * - The divisor cannot be zero.
386      */
387     function div(uint256 a, uint256 b) internal pure returns (uint256) {
388         return div(a, b, "SafeMath: division by zero");
389     }
390 
391     /**
392      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
393      * division by zero. The result is rounded towards zero.
394      *
395      * Counterpart to Solidity's `/` operator. Note: this function uses a
396      * `revert` opcode (which leaves remaining gas untouched) while Solidity
397      * uses an invalid opcode to revert (consuming all remaining gas).
398      *
399      * Requirements:
400      *
401      * - The divisor cannot be zero.
402      */
403     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
404         require(b > 0, errorMessage);
405         uint256 c = a / b;
406         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
407 
408         return c;
409     }
410 
411     /**
412      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
413      * Reverts when dividing by zero.
414      *
415      * Counterpart to Solidity's `%` operator. This function uses a `revert`
416      * opcode (which leaves remaining gas untouched) while Solidity uses an
417      * invalid opcode to revert (consuming all remaining gas).
418      *
419      * Requirements:
420      *
421      * - The divisor cannot be zero.
422      */
423     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
424         return mod(a, b, "SafeMath: modulo by zero");
425     }
426 
427     /**
428      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
429      * Reverts with custom message when dividing by zero.
430      *
431      * Counterpart to Solidity's `%` operator. This function uses a `revert`
432      * opcode (which leaves remaining gas untouched) while Solidity uses an
433      * invalid opcode to revert (consuming all remaining gas).
434      *
435      * Requirements:
436      *
437      * - The divisor cannot be zero.
438      */
439     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
440         require(b != 0, errorMessage);
441         return a % b;
442     }
443 }
444 
445 // Part: VaultWithdrawAPI
446 
447 interface VaultWithdrawAPI {
448     function withdraw(uint256 maxShares, address recipient) external returns (uint256);
449 }
450 
451 // Part: OpenZeppelin/openzeppelin-contracts@3.1.0/Ownable
452 
453 /**
454  * @dev Contract module which provides a basic access control mechanism, where
455  * there is an account (an owner) that can be granted exclusive access to
456  * specific functions.
457  *
458  * By default, the owner account will be the one that deploys the contract. This
459  * can later be changed with {transferOwnership}.
460  *
461  * This module is used through inheritance. It will make available the modifier
462  * `onlyOwner`, which can be applied to your functions to restrict their use to
463  * the owner.
464  */
465 contract Ownable is Context {
466     address private _owner;
467 
468     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
469 
470     /**
471      * @dev Initializes the contract setting the deployer as the initial owner.
472      */
473     constructor () internal {
474         address msgSender = _msgSender();
475         _owner = msgSender;
476         emit OwnershipTransferred(address(0), msgSender);
477     }
478 
479     /**
480      * @dev Returns the address of the current owner.
481      */
482     function owner() public view returns (address) {
483         return _owner;
484     }
485 
486     /**
487      * @dev Throws if called by any account other than the owner.
488      */
489     modifier onlyOwner() {
490         require(_owner == _msgSender(), "Ownable: caller is not the owner");
491         _;
492     }
493 
494     /**
495      * @dev Leaves the contract without owner. It will not be possible to call
496      * `onlyOwner` functions anymore. Can only be called by the current owner.
497      *
498      * NOTE: Renouncing ownership will leave the contract without an owner,
499      * thereby removing any functionality that is only available to the owner.
500      */
501     function renounceOwnership() public virtual onlyOwner {
502         emit OwnershipTransferred(_owner, address(0));
503         _owner = address(0);
504     }
505 
506     /**
507      * @dev Transfers ownership of the contract to a new account (`newOwner`).
508      * Can only be called by the current owner.
509      */
510     function transferOwnership(address newOwner) public virtual onlyOwner {
511         require(newOwner != address(0), "Ownable: new owner is the zero address");
512         emit OwnershipTransferred(_owner, newOwner);
513         _owner = newOwner;
514     }
515 }
516 
517 // Part: OpenZeppelin/openzeppelin-contracts@3.1.0/SafeERC20
518 
519 /**
520  * @title SafeERC20
521  * @dev Wrappers around ERC20 operations that throw on failure (when the token
522  * contract returns false). Tokens that return no value (and instead revert or
523  * throw on failure) are also supported, non-reverting calls are assumed to be
524  * successful.
525  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
526  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
527  */
528 library SafeERC20 {
529     using SafeMath for uint256;
530     using Address for address;
531 
532     function safeTransfer(IERC20 token, address to, uint256 value) internal {
533         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
534     }
535 
536     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
537         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
538     }
539 
540     /**
541      * @dev Deprecated. This function has issues similar to the ones found in
542      * {IERC20-approve}, and its usage is discouraged.
543      *
544      * Whenever possible, use {safeIncreaseAllowance} and
545      * {safeDecreaseAllowance} instead.
546      */
547     function safeApprove(IERC20 token, address spender, uint256 value) internal {
548         // safeApprove should only be called when setting an initial allowance,
549         // or when resetting it to zero. To increase and decrease it, use
550         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
551         // solhint-disable-next-line max-line-length
552         require((value == 0) || (token.allowance(address(this), spender) == 0),
553             "SafeERC20: approve from non-zero to non-zero allowance"
554         );
555         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
556     }
557 
558     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
559         uint256 newAllowance = token.allowance(address(this), spender).add(value);
560         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
561     }
562 
563     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
564         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
565         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
566     }
567 
568     /**
569      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
570      * on the return value: the return value is optional (but if data is returned, it must not be false).
571      * @param token The token targeted by the call.
572      * @param data The call data (encoded using abi.encode or one of its variants).
573      */
574     function _callOptionalReturn(IERC20 token, bytes memory data) private {
575         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
576         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
577         // the target address contains contract code and also asserts for success in the low-level call.
578 
579         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
580         if (returndata.length > 0) { // Return data is optional
581             // solhint-disable-next-line max-line-length
582             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
583         }
584     }
585 }
586 
587 // File: Staking.sol
588 
589 contract Staking is Ownable {
590     using SafeMath for uint256;
591     using SafeERC20 for IERC20;
592 
593     // Info of each user.
594     struct UserInfo {
595         uint256 amount;       // How many LP tokens the user has provided.
596         uint256 rewardDebt;   // Reward debt. See explanation below.
597         uint256 depositTime;  // Last time of deposit/withdraw operation.
598         //
599         // We do some fancy math here. Basically, any point in time, the amount of TOKENs
600         // entitled to a user but is pending to be distributed is:
601         //
602         //   pending reward = (user.amount * pool.accPerShare) - user.rewardDebt
603         //
604         // Whenever a user deposits or withdraws LP tokens to a pool. Here's what happens:
605         //   1. The pool's `accPerShare` (and `lastRewardBlock`) gets updated.
606         //   2. User receives the pending reward sent to his/her address.
607         //   3. User's `amount` gets updated.
608         //   4. User's `rewardDebt` gets updated.
609     }
610 
611     IERC20 public token;
612     // tokens created per block.
613     uint256 public tokenPerBlock;
614     uint256 public tokenDistributed;
615 
616     // Info of each pool.
617     PoolInfo[] public poolInfo;
618     // Info of each user that stakes LP tokens.
619     mapping (uint256 => mapping (address => UserInfo)) public userInfo;
620     // Total allocation points. Must be the sum of all allocation points in all pools.
621     uint256 public totalAllocPoint = 0;
622     // The block number when mining starts.
623     uint256 public startBlock;
624 
625     event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
626     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
627     event Harvest(address indexed user, uint256 indexed pid, uint256 amount);
628 
629     constructor(
630         IERC20 _token,
631         uint256 _tokenPerBlock,
632         uint256 _startBlock
633     ) public {
634         token = _token;
635         tokenPerBlock = _tokenPerBlock;
636         startBlock = _startBlock;
637     }
638 
639     function poolLength() external view returns (uint256) {
640         return poolInfo.length;
641     }
642 
643     function checkPoolDuplicate(IERC20 _lpToken) internal {
644         uint256 length = poolInfo.length;
645         for (uint256 pid = 0; pid < length; ++pid) {
646             require(poolInfo[pid].lpToken != _lpToken, "add: existing pool");
647         }
648     }
649 
650     // Add a new lp to the pool. Can only be called by the owner.
651     function add(uint256 _allocPoint, IERC20 _lpToken) external onlyOwner {
652         checkPoolDuplicate(_lpToken);
653         massUpdatePools();
654 
655         uint256 lastRewardBlock = block.number > startBlock ? block.number : startBlock;
656         totalAllocPoint = totalAllocPoint.add(_allocPoint);
657         poolInfo.push(PoolInfo({
658             lpToken: _lpToken,
659             allocPoint: _allocPoint,
660             lastRewardBlock: lastRewardBlock,
661             accPerShare: 0,
662             lockPeriod: 0
663         }));
664     }
665 
666     function setLockPeriod(uint256 _pid, uint256 _lockPeriod) external onlyOwner {
667         poolInfo[_pid].lockPeriod = _lockPeriod;
668     }
669 
670     function remainingLockPeriod(uint256 _pid, address _user) external view returns (uint256) {
671         return _remainingLockPeriod(_pid, _user);
672     }
673 
674     function _remainingLockPeriod(uint256 _pid, address _user) internal view returns (uint256) {
675         uint256 lockPeriod = poolInfo[_pid].lockPeriod;
676         UserInfo storage user= userInfo[_pid][_user];
677         uint256 timeElapsed = block.timestamp.sub(user.depositTime);
678         
679         if (user.amount > 0 && timeElapsed < lockPeriod) {
680             return lockPeriod.sub(timeElapsed);
681         } else {
682             return 0;
683         }
684     }
685 
686     // Update the given pool's TOKEN allocation point. Can only be called by the owner.
687     function set(uint256 _pid, uint256 _allocPoint) external onlyOwner {
688         massUpdatePools();
689         totalAllocPoint = totalAllocPoint.sub(poolInfo[_pid].allocPoint).add(_allocPoint);
690         poolInfo[_pid].allocPoint = _allocPoint;
691     }
692 
693     function setTokenPerBlock(uint256 _tokenPerBlock) external onlyOwner {
694         massUpdatePools();
695         tokenPerBlock = _tokenPerBlock;
696     }
697 
698     // Sweep all STN to owner
699     function sweep(uint256 _amount) external onlyOwner {
700         token.safeTransfer(owner(), _amount);
701     }
702 
703     // Return reward multiplier over the given _from to _to block.
704     function getMultiplier(uint256 _from, uint256 _to) internal pure returns (uint256) {
705         return _to.sub(_from);
706     }
707 
708     function rewardForPoolPerBlock(uint256 _pid) external view returns (uint256) {
709         PoolInfo storage pool = poolInfo[_pid];
710         return tokenPerBlock.mul(pool.allocPoint).div(totalAllocPoint);
711     }
712 
713     // View function to see deposited TOKENs on frontend.
714     function tokenOfUser(uint256 _pid, address _user) external view returns (uint256) {
715         UserInfo storage user = userInfo[_pid][_user];
716         return user.amount;
717     }
718 
719     // View function to see pending TOKENs on frontend.
720     function pendingToken(uint256 _pid, address _user) external view returns (uint256) {
721         PoolInfo storage pool = poolInfo[_pid];
722         UserInfo storage user = userInfo[_pid][_user];
723         uint256 accPerShare = pool.accPerShare;
724         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
725         if (block.number > pool.lastRewardBlock && lpSupply != 0) {
726             uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
727             uint256 tokenReward = multiplier.mul(tokenPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
728             accPerShare = accPerShare.add(tokenReward.mul(1e12).div(lpSupply));
729         }
730 
731         uint256 pending = user.amount.mul(accPerShare).div(1e12).sub(user.rewardDebt);
732         uint256 remaining = token.balanceOf(address(this));
733         return Math.min(pending, remaining);
734     }
735 
736     // Update reward variables for all pools. Be careful of gas spending!
737     //  Should be invoked if pool status changed, such as adding new pool, setting new pool config
738     //    otherwise, other pools can't split token reward fairly since they only update state
739     //    when someone interact with it directly.
740     function massUpdatePools() internal {
741         uint256 length = poolInfo.length;
742         for (uint256 pid = 0; pid < length; ++pid) {
743             updatePool(pid);
744         }
745     }
746 
747     // Update reward variables of the given pool to be up-to-date.
748     function updatePool(uint256 _pid) internal {
749         PoolInfo storage pool = poolInfo[_pid];
750         if (block.number <= pool.lastRewardBlock) {
751             return;
752         }
753         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
754         if (lpSupply == 0) {
755             pool.lastRewardBlock = block.number;
756             return;
757         }
758         uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
759         uint256 tokenReward = multiplier.mul(tokenPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
760         pool.accPerShare = pool.accPerShare.add(tokenReward.mul(1e12).div(lpSupply));
761         pool.lastRewardBlock = block.number;
762     }
763 
764     // Deposit LP tokens.
765     //  In normal case, _recipient should be same as msg.sender
766     //  In deposit and stake, _recipient should be address of initial user
767     function deposit(uint256 _pid, uint256 _amount, address _recipient) public returns (uint256) {
768 
769         PoolInfo storage pool = poolInfo[_pid];
770         UserInfo storage user = userInfo[_pid][_recipient];
771         uint256 rewards = _harvest(_recipient, _pid);
772 
773         // Update debt before calling external function
774         uint256 newAmount = user.amount.add(_amount);
775         user.rewardDebt = newAmount.mul(pool.accPerShare).div(1e12);
776         if (_amount > 0) {
777             pool.lpToken.safeTransferFrom(msg.sender, address(this), _amount);
778             user.amount = newAmount;
779             user.depositTime = block.timestamp;
780         }
781 
782         emit Deposit(_recipient, _pid, _amount);
783         return rewards;
784     }
785 
786     // Withdraw LP tokens.
787     function unstakeAndWithdraw(uint256 _pid, uint256 _amount, VaultWithdrawAPI vault) external returns (uint256) {
788         address sender = msg.sender;
789         PoolInfo storage pool = poolInfo[_pid];
790         UserInfo storage user = userInfo[_pid][sender];
791 
792         require(user.amount >= _amount, "withdraw: not good");
793         require(_remainingLockPeriod(_pid, sender) == 0, "withdraw: still in lockPeriod");
794 
795         uint256 rewards = _harvest(sender, _pid);
796 
797         // Update debt before calling external function
798         uint256 newAmount = user.amount.sub(_amount);
799         user.rewardDebt = newAmount.mul(pool.accPerShare).div(1e12);
800         if(_amount > 0) {
801             // Update state variable before we call function of external contract
802             user.amount = newAmount;
803             user.depositTime = block.timestamp;
804 
805             IERC20 sVault = IERC20(address(vault));
806             uint256 beforeBalance = sVault.balanceOf(address(this));
807 
808             vault.withdraw(_amount, sender);
809 
810             // Detect delta amount by comparing balance
811             uint256 delta = beforeBalance.sub(sVault.balanceOf(address(this)));
812             // Should never withdraw more than _amount
813             assert(delta <= _amount);
814 
815             // If vault didn't burn all shares, we update amount by substracting delta
816             if(delta < _amount) {
817                 user.amount = user.amount.add(_amount).sub(delta);
818                 user.rewardDebt = user.amount.mul(pool.accPerShare).div(1e12);
819             }
820         }
821 
822         emit Withdraw(sender, _pid, _amount);
823         return rewards;
824     }
825 
826     // Withdraw LP tokens.
827     function withdraw(uint256 _pid, uint256 _amount) external returns (uint256) {
828         address sender = msg.sender;
829         PoolInfo storage pool = poolInfo[_pid];
830         UserInfo storage user = userInfo[_pid][sender];
831 
832         require(user.amount >= _amount, "withdraw: not good");
833         require(_remainingLockPeriod(_pid, sender) == 0, "withdraw: still in lockPeriod");
834 
835         uint256 rewards = _harvest(sender, _pid);
836 
837         // Update debt before calling external function
838         uint256 newAmount = user.amount.sub(_amount);
839         user.rewardDebt = newAmount.mul(pool.accPerShare).div(1e12);
840         if(_amount > 0) {
841             user.amount = newAmount;
842             user.depositTime = block.timestamp;
843             pool.lpToken.safeTransfer(address(sender), _amount);
844         }
845 
846         emit Withdraw(sender, _pid, _amount);
847         return rewards;
848     }
849 
850     // Harvest TOKEN to wallet
851     function harvest(uint256 _pid) external returns (uint256) {
852         address sender = msg.sender;
853         uint256 rewards = _harvest(sender, _pid);
854         PoolInfo storage pool = poolInfo[_pid];
855         UserInfo storage user = userInfo[_pid][sender];
856         user.rewardDebt = user.amount.mul(pool.accPerShare).div(1e12);
857         return rewards;
858     }
859 
860     function _harvest(address _user, uint256 _pid) internal returns (uint256) {
861         PoolInfo storage pool = poolInfo[_pid];
862         UserInfo storage user = userInfo[_pid][_user];
863         updatePool(_pid);
864         if (user.amount == 0) {
865             return 0;
866         }
867 
868         uint256 pending = user.amount.mul(pool.accPerShare).div(1e12).sub(user.rewardDebt);
869         uint256 remaining = token.balanceOf(address(this));
870         pending = Math.min(pending, remaining);
871         if(pending > 0) {
872             tokenDistributed = tokenDistributed.add(pending);
873             token.safeTransfer(_user, pending);
874         }
875         emit Harvest(_user, _pid, pending);
876         return pending;
877     }
878 
879 }
