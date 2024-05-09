1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.6.12;
4 
5 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
6 
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
81 // File: @openzeppelin/contracts/math/SafeMath.sol
82 
83 /**
84  * @dev Wrappers over Solidity's arithmetic operations with added overflow
85  * checks.
86  *
87  * Arithmetic operations in Solidity wrap on overflow. This can easily result
88  * in bugs, because programmers usually assume that an overflow raises an
89  * error, which is the standard behavior in high level programming languages.
90  * `SafeMath` restores this intuition by reverting the transaction when an
91  * operation overflows.
92  *
93  * Using this library instead of the unchecked operations eliminates an entire
94  * class of bugs, so it's recommended to use it always.
95  */
96 library SafeMath {
97     /**
98      * @dev Returns the addition of two unsigned integers, reverting on
99      * overflow.
100      *
101      * Counterpart to Solidity's `+` operator.
102      *
103      * Requirements:
104      *
105      * - Addition cannot overflow.
106      */
107     function add(uint256 a, uint256 b) internal pure returns (uint256) {
108         uint256 c = a + b;
109         require(c >= a, "SafeMath: addition overflow");
110 
111         return c;
112     }
113 
114     /**
115      * @dev Returns the subtraction of two unsigned integers, reverting on
116      * overflow (when the result is negative).
117      *
118      * Counterpart to Solidity's `-` operator.
119      *
120      * Requirements:
121      *
122      * - Subtraction cannot overflow.
123      */
124     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
125         return sub(a, b, "SafeMath: subtraction overflow");
126     }
127 
128     /**
129      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
130      * overflow (when the result is negative).
131      *
132      * Counterpart to Solidity's `-` operator.
133      *
134      * Requirements:
135      *
136      * - Subtraction cannot overflow.
137      */
138     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
139         require(b <= a, errorMessage);
140         uint256 c = a - b;
141 
142         return c;
143     }
144 
145     /**
146      * @dev Returns the multiplication of two unsigned integers, reverting on
147      * overflow.
148      *
149      * Counterpart to Solidity's `*` operator.
150      *
151      * Requirements:
152      *
153      * - Multiplication cannot overflow.
154      */
155     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
156         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
157         // benefit is lost if 'b' is also tested.
158         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
159         if (a == 0) {
160             return 0;
161         }
162 
163         uint256 c = a * b;
164         require(c / a == b, "SafeMath: multiplication overflow");
165 
166         return c;
167     }
168 
169     /**
170      * @dev Returns the integer division of two unsigned integers. Reverts on
171      * division by zero. The result is rounded towards zero.
172      *
173      * Counterpart to Solidity's `/` operator. Note: this function uses a
174      * `revert` opcode (which leaves remaining gas untouched) while Solidity
175      * uses an invalid opcode to revert (consuming all remaining gas).
176      *
177      * Requirements:
178      *
179      * - The divisor cannot be zero.
180      */
181     function div(uint256 a, uint256 b) internal pure returns (uint256) {
182         return div(a, b, "SafeMath: division by zero");
183     }
184 
185     /**
186      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
187      * division by zero. The result is rounded towards zero.
188      *
189      * Counterpart to Solidity's `/` operator. Note: this function uses a
190      * `revert` opcode (which leaves remaining gas untouched) while Solidity
191      * uses an invalid opcode to revert (consuming all remaining gas).
192      *
193      * Requirements:
194      *
195      * - The divisor cannot be zero.
196      */
197     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
198         require(b > 0, errorMessage);
199         uint256 c = a / b;
200         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
201 
202         return c;
203     }
204 
205     /**
206      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
207      * Reverts when dividing by zero.
208      *
209      * Counterpart to Solidity's `%` operator. This function uses a `revert`
210      * opcode (which leaves remaining gas untouched) while Solidity uses an
211      * invalid opcode to revert (consuming all remaining gas).
212      *
213      * Requirements:
214      *
215      * - The divisor cannot be zero.
216      */
217     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
218         return mod(a, b, "SafeMath: modulo by zero");
219     }
220 
221     /**
222      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
223      * Reverts with custom message when dividing by zero.
224      *
225      * Counterpart to Solidity's `%` operator. This function uses a `revert`
226      * opcode (which leaves remaining gas untouched) while Solidity uses an
227      * invalid opcode to revert (consuming all remaining gas).
228      *
229      * Requirements:
230      *
231      * - The divisor cannot be zero.
232      */
233     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
234         require(b != 0, errorMessage);
235         return a % b;
236     }
237 }
238 
239 // File: @openzeppelin/contracts/utils/Address.sol
240 
241 /**
242  * @dev Collection of functions related to the address type
243  */
244 library Address {
245     /**
246      * @dev Returns true if `account` is a contract.
247      *
248      * [IMPORTANT]
249      * ====
250      * It is unsafe to assume that an address for which this function returns
251      * false is an externally-owned account (EOA) and not a contract.
252      *
253      * Among others, `isContract` will return false for the following
254      * types of addresses:
255      *
256      *  - an externally-owned account
257      *  - a contract in construction
258      *  - an address where a contract will be created
259      *  - an address where a contract lived, but was destroyed
260      * ====
261      */
262     function isContract(address account) internal view returns (bool) {
263         // This method relies in extcodesize, which returns 0 for contracts in
264         // construction, since the code is only stored at the end of the
265         // constructor execution.
266 
267         uint256 size;
268         // solhint-disable-next-line no-inline-assembly
269         assembly { size := extcodesize(account) }
270         return size > 0;
271     }
272 
273     /**
274      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
275      * `recipient`, forwarding all available gas and reverting on errors.
276      *
277      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
278      * of certain opcodes, possibly making contracts go over the 2300 gas limit
279      * imposed by `transfer`, making them unable to receive funds via
280      * `transfer`. {sendValue} removes this limitation.
281      *
282      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
283      *
284      * IMPORTANT: because control is transferred to `recipient`, care must be
285      * taken to not create reentrancy vulnerabilities. Consider using
286      * {ReentrancyGuard} or the
287      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
288      */
289     function sendValue(address payable recipient, uint256 amount) internal {
290         require(address(this).balance >= amount, "Address: insufficient balance");
291 
292         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
293         (bool success, ) = recipient.call{ value: amount }("");
294         require(success, "Address: unable to send value, recipient may have reverted");
295     }
296 
297     /**
298      * @dev Performs a Solidity function call using a low level `call`. A
299      * plain`call` is an unsafe replacement for a function call: use this
300      * function instead.
301      *
302      * If `target` reverts with a revert reason, it is bubbled up by this
303      * function (like regular Solidity function calls).
304      *
305      * Returns the raw returned data. To convert to the expected return value,
306      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
307      *
308      * Requirements:
309      *
310      * - `target` must be a contract.
311      * - calling `target` with `data` must not revert.
312      *
313      * _Available since v3.1._
314      */
315     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
316       return functionCall(target, data, "Address: low-level call failed");
317     }
318 
319     /**
320      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
321      * `errorMessage` as a fallback revert reason when `target` reverts.
322      *
323      * _Available since v3.1._
324      */
325     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
326         return _functionCallWithValue(target, data, 0, errorMessage);
327     }
328 
329     /**
330      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
331      * but also transferring `value` wei to `target`.
332      *
333      * Requirements:
334      *
335      * - the calling contract must have an ETH balance of at least `value`.
336      * - the called Solidity function must be `payable`.
337      *
338      * _Available since v3.1._
339      */
340     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
341         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
342     }
343 
344     /**
345      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
346      * with `errorMessage` as a fallback revert reason when `target` reverts.
347      *
348      * _Available since v3.1._
349      */
350     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
351         require(address(this).balance >= value, "Address: insufficient balance for call");
352         return _functionCallWithValue(target, data, value, errorMessage);
353     }
354 
355     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
356         require(isContract(target), "Address: call to non-contract");
357 
358         // solhint-disable-next-line avoid-low-level-calls
359         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
360         if (success) {
361             return returndata;
362         } else {
363             // Look for revert reason and bubble it up if present
364             if (returndata.length > 0) {
365                 // The easiest way to bubble the revert reason is using memory via assembly
366 
367                 // solhint-disable-next-line no-inline-assembly
368                 assembly {
369                     let returndata_size := mload(returndata)
370                     revert(add(32, returndata), returndata_size)
371                 }
372             } else {
373                 revert(errorMessage);
374             }
375         }
376     }
377 }
378 
379 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
380 
381 /**
382  * @title SafeERC20
383  * @dev Wrappers around ERC20 operations that throw on failure (when the token
384  * contract returns false). Tokens that return no value (and instead revert or
385  * throw on failure) are also supported, non-reverting calls are assumed to be
386  * successful.
387  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
388  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
389  */
390 library SafeERC20 {
391     using SafeMath for uint256;
392     using Address for address;
393 
394     function safeTransfer(IERC20 token, address to, uint256 value) internal {
395         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
396     }
397 
398     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
399         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
400     }
401 
402     /**
403      * @dev Deprecated. This function has issues similar to the ones found in
404      * {IERC20-approve}, and its usage is discouraged.
405      *
406      * Whenever possible, use {safeIncreaseAllowance} and
407      * {safeDecreaseAllowance} instead.
408      */
409     function safeApprove(IERC20 token, address spender, uint256 value) internal {
410         // safeApprove should only be called when setting an initial allowance,
411         // or when resetting it to zero. To increase and decrease it, use
412         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
413         // solhint-disable-next-line max-line-length
414         require((value == 0) || (token.allowance(address(this), spender) == 0),
415             "SafeERC20: approve from non-zero to non-zero allowance"
416         );
417         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
418     }
419 
420     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
421         uint256 newAllowance = token.allowance(address(this), spender).add(value);
422         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
423     }
424 
425     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
426         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
427         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
428     }
429 
430     /**
431      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
432      * on the return value: the return value is optional (but if data is returned, it must not be false).
433      * @param token The token targeted by the call.
434      * @param data The call data (encoded using abi.encode or one of its variants).
435      */
436     function _callOptionalReturn(IERC20 token, bytes memory data) private {
437         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
438         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
439         // the target address contains contract code and also asserts for success in the low-level call.
440 
441         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
442         if (returndata.length > 0) { // Return data is optional
443             // solhint-disable-next-line max-line-length
444             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
445         }
446     }
447 }
448 
449 // File: contracts/vaults/strategies/IStrategy.sol
450 
451 interface IStrategy {
452     function approve(IERC20 _token) external;
453 
454     function approveForSpender(IERC20 _token, address spender) external;
455 
456     // Deposit tokens to a farm to yield more tokens.
457     function deposit(address _vault, uint256 _amount) external;
458 
459     // Claim farming tokens
460     function claim(address _vault) external;
461 
462     // The vault request to harvest the profit
463     function harvest(uint256 _bankPoolId) external;
464 
465     // Withdraw the principal from a farm.
466     function withdraw(address _vault, uint256 _amount) external;
467 
468     // Target farming token of this strategy.
469     function getTargetToken() external view returns(address);
470 
471     function balanceOf(address _vault) external view returns (uint256);
472 
473     function pendingReward(address _vault) external view returns (uint256);
474 
475     function expectedAPY(address _vault) external view returns (uint256);
476 
477     function governanceRescueToken(IERC20 _token) external returns (uint256);
478 }
479 
480 // File: contracts/vaults/ValueVaultBank.sol
481 
482 interface IValueVaultMaster {
483     function minorPool() view external returns(address);
484     function performanceReward() view external returns(address);
485     function minStakeTimeToClaimVaultReward() view external returns(uint256);
486 }
487 
488 interface IValueVault {
489     function balanceOf(address account) view external returns(uint256);
490     function getStrategyCount() external view returns(uint256);
491     function depositAvailable() external view returns(bool);
492     function strategies(uint256 _index) view external returns(IStrategy);
493     function mintByBank(IERC20 _token, address _to, uint256 _amount) external;
494     function burnByBank(IERC20 _token, address _account, uint256 _amount) external;
495     function harvestAllStrategies(uint256 _bankPoolId) external;
496     function harvestStrategy(IStrategy _strategy, uint256 _bankPoolId) external;
497 }
498 
499 interface IValueMinorPool {
500     function depositOnBehalf(address farmer, uint256 _pid, uint256 _amount, address _referrer) external;
501     function withdrawOnBehalf(address farmer, uint256 _pid, uint256 _amount) external;
502 }
503 
504 interface IFreeFromUpTo {
505     function freeFromUpTo(address from, uint256 value) external returns (uint256 freed);
506 }
507 
508 contract ValueVaultBank {
509     using SafeMath for uint256;
510     using SafeERC20 for IERC20;
511 
512     IFreeFromUpTo public constant chi = IFreeFromUpTo(0x0000000000004946c0e9F43F4Dee607b0eF1fA1c);
513 
514     modifier discountCHI {
515         uint256 gasStart = gasleft();
516         _;
517         uint256 gasSpent = 21000 + gasStart - gasleft() + 16 * msg.data.length;
518         chi.freeFromUpTo(msg.sender, (gasSpent + 14154) / 41130);
519     }
520 
521     address public governance;
522     IValueVaultMaster public vaultMaster;
523 
524     // Info of each pool.
525     struct PoolInfo {
526         IERC20 token; // Address of token contract.
527         IValueVault vault; // Address of vault contract.
528         uint256 minorPoolId; // minorPool's subpool id
529         uint256 startTime;
530         uint256 individualCap; // 0 to disable
531         uint256 totalCap; // 0 to disable
532     }
533 
534     // Info of each pool.
535     mapping(uint256 => PoolInfo) public poolMap;  // By poolId
536 
537     struct Staker {
538         uint256 stake;
539         uint256 payout;
540         uint256 total_out;
541     }
542 
543     mapping(uint256 => mapping(address => Staker)) public stakers; // poolId -> stakerAddress -> staker's info
544 
545     struct Global {
546         uint256 total_stake;
547         uint256 total_out;
548         uint256 earnings_per_share;
549     }
550 
551     mapping(uint256 => Global) public global; // poolId -> global data
552 
553     mapping(uint256 => mapping(address => uint256)) public lastStakeTimes; // poolId -> user's last staked
554     uint256 constant internal magnitude = 10 ** 40;
555 
556     event Deposit(address indexed user, uint256 indexed poolId, uint256 amount);
557     event Withdraw(address indexed user, uint256 indexed poolId, uint256 amount);
558     event Claim(address indexed user, uint256 indexed poolId);
559 
560     constructor() public {
561         governance = tx.origin;
562     }
563 
564     function setGovernance(address _governance) external {
565         require(msg.sender == governance, "!governance");
566         governance = _governance;
567     }
568 
569     function setVaultMaster(IValueVaultMaster _vaultMaster) external {
570         require(msg.sender == governance, "!governance");
571         vaultMaster = _vaultMaster;
572     }
573 
574     function setPoolInfo(uint256 _poolId, IERC20 _token, IValueVault _vault, uint256 _minorPoolId, uint256 _startTime, uint256 _individualCap, uint256 _totalCap) public {
575         require(msg.sender == governance, "!governance");
576         poolMap[_poolId].token = _token;
577         poolMap[_poolId].vault = _vault;
578         poolMap[_poolId].minorPoolId = _minorPoolId;
579         poolMap[_poolId].startTime = _startTime;
580         poolMap[_poolId].individualCap = _individualCap;
581         poolMap[_poolId].totalCap = _totalCap;
582     }
583 
584     function setPoolCap(uint256 _poolId, uint256 _individualCap, uint256 _totalCap) public {
585         require(msg.sender == governance, "!governance");
586         require(_totalCap == 0 || _totalCap >= _individualCap, "_totalCap < _individualCap");
587         poolMap[_poolId].individualCap = _individualCap;
588         poolMap[_poolId].totalCap = _totalCap;
589     }
590 
591     function depositAvailable(uint256 _poolId) external view returns(bool) {
592         return poolMap[_poolId].vault.depositAvailable();
593     }
594 
595     // Deposit tokens to Bank. If we have a strategy, then tokens will be moved there.
596     function deposit(uint256 _poolId, uint256 _amount, bool _farmMinorPool, address _referrer) public discountCHI {
597         PoolInfo storage pool = poolMap[_poolId];
598         require(now >= pool.startTime, "deposit: after startTime");
599         require(_amount > 0, "!_amount");
600         require(address(pool.vault) != address(0), "pool.vault = 0");
601         require(pool.individualCap == 0 || stakers[_poolId][msg.sender].stake.add(_amount) <= pool.individualCap, "Exceed pool.individualCap");
602         require(pool.totalCap == 0 || global[_poolId].total_stake.add(_amount) <= pool.totalCap, "Exceed pool.totalCap");
603 
604         pool.token.safeTransferFrom(msg.sender, address(pool.vault), _amount);
605         pool.vault.mintByBank(pool.token, msg.sender, _amount);
606         if (_farmMinorPool && address(vaultMaster) != address(0)) {
607             address minorPool = vaultMaster.minorPool();
608             if (minorPool != address(0)) {
609                 IValueMinorPool(minorPool).depositOnBehalf(msg.sender, pool.minorPoolId, pool.vault.balanceOf(msg.sender), _referrer);
610             }
611         }
612 
613         _handleDepositStakeInfo(_poolId, _amount);
614         emit Deposit(msg.sender, _poolId, _amount);
615     }
616 
617     function _handleDepositStakeInfo(uint256 _poolId, uint256 _amount) internal {
618         stakers[_poolId][msg.sender].stake = stakers[_poolId][msg.sender].stake.add(_amount);
619         if (global[_poolId].earnings_per_share != 0) {
620             stakers[_poolId][msg.sender].payout = stakers[_poolId][msg.sender].payout.add(
621                 global[_poolId].earnings_per_share.mul(_amount).sub(1).div(magnitude).add(1)
622             );
623         }
624         global[_poolId].total_stake = global[_poolId].total_stake.add(_amount);
625         lastStakeTimes[_poolId][msg.sender] = block.timestamp;
626     }
627 
628     // Withdraw tokens from ValueVaultBank (from a strategy first if there is one).
629     function withdraw(uint256 _poolId, uint256 _amount, bool _farmMinorPool) public discountCHI {
630         PoolInfo storage pool = poolMap[_poolId];
631         require(address(pool.vault) != address(0), "pool.vault = 0");
632         require(now >= pool.startTime, "withdraw: after startTime");
633         require(_amount <= stakers[_poolId][msg.sender].stake, "!balance");
634 
635         claimProfit(_poolId);
636 
637         if (_farmMinorPool && address(vaultMaster) != address(0)) {
638             address minorPool = vaultMaster.minorPool();
639             if (minorPool != address(0)) {
640                 IValueMinorPool(minorPool).withdrawOnBehalf(msg.sender, pool.minorPoolId, _amount);
641             }
642         }
643         pool.vault.burnByBank(pool.token, msg.sender, _amount);
644         pool.token.safeTransfer(msg.sender, _amount);
645 
646         _handleWithdrawStakeInfo(_poolId, _amount);
647         emit Withdraw(msg.sender, _poolId, _amount);
648     }
649 
650     function _handleWithdrawStakeInfo(uint256 _poolId, uint256 _amount) internal {
651         stakers[_poolId][msg.sender].payout = stakers[_poolId][msg.sender].payout.sub(
652             global[_poolId].earnings_per_share.mul(_amount).div(magnitude)
653         );
654         stakers[_poolId][msg.sender].stake = stakers[_poolId][msg.sender].stake.sub(_amount);
655         global[_poolId].total_stake = global[_poolId].total_stake.sub(_amount);
656     }
657 
658     function exit(uint256 _poolId, bool _farmMinorPool) external discountCHI {
659         withdraw(_poolId, stakers[_poolId][msg.sender].stake, _farmMinorPool);
660     }
661 
662     // Withdraw without caring about rewards. EMERGENCY ONLY.
663     function emergencyWithdraw(uint256 _poolId) public {
664         uint256 amount = stakers[_poolId][msg.sender].stake;
665         poolMap[_poolId].token.safeTransfer(address(msg.sender), amount);
666         stakers[_poolId][msg.sender].stake = 0;
667         global[_poolId].total_stake = global[_poolId].total_stake.sub(amount);
668     }
669 
670     function harvestVault(uint256 _poolId) external discountCHI {
671         poolMap[_poolId].vault.harvestAllStrategies(_poolId);
672     }
673 
674     function harvestStrategy(uint256 _poolId, IStrategy _strategy) external discountCHI {
675         poolMap[_poolId].vault.harvestStrategy(_strategy, _poolId);
676     }
677 
678     function make_profit(uint256 _poolId, uint256 _amount) public {
679         require(_amount > 0, "not 0");
680         PoolInfo storage pool = poolMap[_poolId];
681         pool.token.safeTransferFrom(msg.sender, address(this), _amount);
682         if (global[_poolId].total_stake > 0) {
683             global[_poolId].earnings_per_share = global[_poolId].earnings_per_share.add(
684                 _amount.mul(magnitude).div(global[_poolId].total_stake)
685             );
686         }
687         global[_poolId].total_out = global[_poolId].total_out.add(_amount);
688     }
689 
690     function cal_out(uint256 _poolId, address user) public view returns (uint256) {
691         uint256 _cal = global[_poolId].earnings_per_share.mul(stakers[_poolId][user].stake).div(magnitude);
692         if (_cal < stakers[_poolId][user].payout) {
693             return 0;
694         } else {
695             return _cal.sub(stakers[_poolId][user].payout);
696         }
697     }
698 
699     function cal_out_pending(uint256 _pendingBalance, uint256 _poolId, address user) public view returns (uint256) {
700         uint256 _earnings_per_share = global[_poolId].earnings_per_share.add(
701             _pendingBalance.mul(magnitude).div(global[_poolId].total_stake)
702         );
703         uint256 _cal = _earnings_per_share.mul(stakers[_poolId][user].stake).div(magnitude);
704         _cal = _cal.sub(cal_out(_poolId, user));
705         if (_cal < stakers[_poolId][user].payout) {
706             return 0;
707         } else {
708             return _cal.sub(stakers[_poolId][user].payout);
709         }
710     }
711 
712     function claimProfit(uint256 _poolId) public discountCHI {
713         uint256 out = cal_out(_poolId, msg.sender);
714         stakers[_poolId][msg.sender].payout = global[_poolId].earnings_per_share.mul(stakers[_poolId][msg.sender].stake).div(magnitude);
715         stakers[_poolId][msg.sender].total_out = stakers[_poolId][msg.sender].total_out.add(out);
716 
717         if (out > 0) {
718             PoolInfo storage pool = poolMap[_poolId];
719             uint256 _stakeTime = now - lastStakeTimes[_poolId][msg.sender];
720             if (address(vaultMaster) != address(0) && _stakeTime < vaultMaster.minStakeTimeToClaimVaultReward()) { // claim too soon
721                 uint256 actually_out = _stakeTime.mul(out).mul(1e18).div(vaultMaster.minStakeTimeToClaimVaultReward()).div(1e18);
722                 uint256 earlyClaimCost = out.sub(actually_out);
723                 safeTokenTransfer(pool.token, vaultMaster.performanceReward(), earlyClaimCost);
724                 out = actually_out;
725             }
726             safeTokenTransfer(pool.token, msg.sender, out);
727         }
728     }
729 
730     // Safe token transfer function, just in case if rounding error causes pool to not have enough token.
731     function safeTokenTransfer(IERC20 _token, address _to, uint256 _amount) internal {
732         uint256 bal = _token.balanceOf(address(this));
733         if (_amount > bal) {
734             _token.safeTransfer(_to, bal);
735         } else {
736             _token.safeTransfer(_to, _amount);
737         }
738     }
739 
740     /**
741      * @dev if there is any token stuck we will need governance support to rescue the fund
742      */
743     function governanceRescueFromStrategy(IERC20 _token, IStrategy _strategy) external {
744         require(msg.sender == governance, "!governance");
745         _strategy.governanceRescueToken(_token);
746     }
747 
748     /**
749      * This function allows governance to take unsupported tokens out of the contract.
750      * This is in an effort to make someone whole, should they seriously mess up.
751      * There is no guarantee governance will vote to return these.
752      * It also allows for removal of airdropped tokens.
753      */
754     function governanceRecoverUnsupported(IERC20 _token, uint256 amount, address to) external {
755         require(msg.sender == governance, "!governance");
756         _token.safeTransfer(to, amount);
757     }
758 }