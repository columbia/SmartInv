1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.6.12;
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
79 /**
80  * @dev Wrappers over Solidity's arithmetic operations with added overflow
81  * checks.
82  *
83  * Arithmetic operations in Solidity wrap on overflow. This can easily result
84  * in bugs, because programmers usually assume that an overflow raises an
85  * error, which is the standard behavior in high level programming languages.
86  * `SafeMath` restores this intuition by reverting the transaction when an
87  * operation overflows.
88  *
89  * Using this library instead of the unchecked operations eliminates an entire
90  * class of bugs, so it's recommended to use it always.
91  */
92 library SafeMath {
93     /**
94      * @dev Returns the addition of two unsigned integers, reverting on
95      * overflow.
96      *
97      * Counterpart to Solidity's `+` operator.
98      *
99      * Requirements:
100      *
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
117      *
118      * - Subtraction cannot overflow.
119      */
120     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
121         return sub(a, b, "SafeMath: subtraction overflow");
122     }
123 
124     /**
125      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
126      * overflow (when the result is negative).
127      *
128      * Counterpart to Solidity's `-` operator.
129      *
130      * Requirements:
131      *
132      * - Subtraction cannot overflow.
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
148      *
149      * - Multiplication cannot overflow.
150      */
151     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
152         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
153         // benefit is lost if 'b' is also tested.
154         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
155         if (a == 0) {
156             return 0;
157         }
158 
159         uint256 c = a * b;
160         require(c / a == b, "SafeMath: multiplication overflow");
161 
162         return c;
163     }
164 
165     /**
166      * @dev Returns the integer division of two unsigned integers. Reverts on
167      * division by zero. The result is rounded towards zero.
168      *
169      * Counterpart to Solidity's `/` operator. Note: this function uses a
170      * `revert` opcode (which leaves remaining gas untouched) while Solidity
171      * uses an invalid opcode to revert (consuming all remaining gas).
172      *
173      * Requirements:
174      *
175      * - The divisor cannot be zero.
176      */
177     function div(uint256 a, uint256 b) internal pure returns (uint256) {
178         return div(a, b, "SafeMath: division by zero");
179     }
180 
181     /**
182      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
183      * division by zero. The result is rounded towards zero.
184      *
185      * Counterpart to Solidity's `/` operator. Note: this function uses a
186      * `revert` opcode (which leaves remaining gas untouched) while Solidity
187      * uses an invalid opcode to revert (consuming all remaining gas).
188      *
189      * Requirements:
190      *
191      * - The divisor cannot be zero.
192      */
193     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
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
210      *
211      * - The divisor cannot be zero.
212      */
213     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
214         return mod(a, b, "SafeMath: modulo by zero");
215     }
216 
217     /**
218      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
219      * Reverts with custom message when dividing by zero.
220      *
221      * Counterpart to Solidity's `%` operator. This function uses a `revert`
222      * opcode (which leaves remaining gas untouched) while Solidity uses an
223      * invalid opcode to revert (consuming all remaining gas).
224      *
225      * Requirements:
226      *
227      * - The divisor cannot be zero.
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
242      * [IMPORTANT]
243      * ====
244      * It is unsafe to assume that an address for which this function returns
245      * false is an externally-owned account (EOA) and not a contract.
246      *
247      * Among others, `isContract` will return false for the following
248      * types of addresses:
249      *
250      *  - an externally-owned account
251      *  - a contract in construction
252      *  - an address where a contract will be created
253      *  - an address where a contract lived, but was destroyed
254      * ====
255      */
256     function isContract(address account) internal view returns (bool) {
257         // This method relies in extcodesize, which returns 0 for contracts in
258         // construction, since the code is only stored at the end of the
259         // constructor execution.
260 
261         uint256 size;
262         // solhint-disable-next-line no-inline-assembly
263         assembly { size := extcodesize(account) }
264         return size > 0;
265     }
266 
267     /**
268      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
269      * `recipient`, forwarding all available gas and reverting on errors.
270      *
271      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
272      * of certain opcodes, possibly making contracts go over the 2300 gas limit
273      * imposed by `transfer`, making them unable to receive funds via
274      * `transfer`. {sendValue} removes this limitation.
275      *
276      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
277      *
278      * IMPORTANT: because control is transferred to `recipient`, care must be
279      * taken to not create reentrancy vulnerabilities. Consider using
280      * {ReentrancyGuard} or the
281      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
282      */
283     function sendValue(address payable recipient, uint256 amount) internal {
284         require(address(this).balance >= amount, "Address: insufficient balance");
285 
286         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
287         (bool success, ) = recipient.call{ value: amount }("");
288         require(success, "Address: unable to send value, recipient may have reverted");
289     }
290 
291     /**
292      * @dev Performs a Solidity function call using a low level `call`. A
293      * plain`call` is an unsafe replacement for a function call: use this
294      * function instead.
295      *
296      * If `target` reverts with a revert reason, it is bubbled up by this
297      * function (like regular Solidity function calls).
298      *
299      * Returns the raw returned data. To convert to the expected return value,
300      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
301      *
302      * Requirements:
303      *
304      * - `target` must be a contract.
305      * - calling `target` with `data` must not revert.
306      *
307      * _Available since v3.1._
308      */
309     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
310       return functionCall(target, data, "Address: low-level call failed");
311     }
312 
313     /**
314      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
315      * `errorMessage` as a fallback revert reason when `target` reverts.
316      *
317      * _Available since v3.1._
318      */
319     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
320         return _functionCallWithValue(target, data, 0, errorMessage);
321     }
322 
323     /**
324      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
325      * but also transferring `value` wei to `target`.
326      *
327      * Requirements:
328      *
329      * - the calling contract must have an ETH balance of at least `value`.
330      * - the called Solidity function must be `payable`.
331      *
332      * _Available since v3.1._
333      */
334     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
335         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
336     }
337 
338     /**
339      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
340      * with `errorMessage` as a fallback revert reason when `target` reverts.
341      *
342      * _Available since v3.1._
343      */
344     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
345         require(address(this).balance >= value, "Address: insufficient balance for call");
346         return _functionCallWithValue(target, data, value, errorMessage);
347     }
348 
349     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
350         require(isContract(target), "Address: call to non-contract");
351 
352         // solhint-disable-next-line avoid-low-level-calls
353         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
354         if (success) {
355             return returndata;
356         } else {
357             // Look for revert reason and bubble it up if present
358             if (returndata.length > 0) {
359                 // The easiest way to bubble the revert reason is using memory via assembly
360 
361                 // solhint-disable-next-line no-inline-assembly
362                 assembly {
363                     let returndata_size := mload(returndata)
364                     revert(add(32, returndata), returndata_size)
365                 }
366             } else {
367                 revert(errorMessage);
368             }
369         }
370     }
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
441 interface IValueVaultMaster {
442     function bank(address) view external returns (address);
443     function isVault(address) view external returns (bool);
444     function isController(address) view external returns (bool);
445     function isStrategy(address) view external returns (bool);
446 
447     function slippage(address) view external returns (uint);
448     function convertSlippage(address _input, address _output) view external returns (uint);
449 
450     function valueToken() view external returns (address);
451     function govVault() view external returns (address);
452     function insuranceFund() view external returns (address);
453     function performanceReward() view external returns (address);
454 
455     function govVaultProfitShareFee() view external returns (uint);
456     function gasFee() view external returns (uint);
457     function insuranceFee() view external returns (uint);
458     function withdrawalProtectionFee() view external returns (uint);
459 }
460 
461 interface IValueMultiVault {
462     function cap() external view returns (uint);
463     function getConverter(address _want) external view returns (address);
464     function getVaultMaster() external view returns (address);
465     function balance() external view returns (uint);
466     function token() external view returns (address);
467     function available(address _want) external view returns (uint);
468     function accept(address _input) external view returns (bool);
469 
470     function claimInsurance() external;
471     function earn(address _want) external;
472     function harvest(address reserve, uint amount) external;
473 
474     function withdraw_fee(uint _shares) external view returns (uint);
475     function calc_token_amount_deposit(uint[] calldata _amounts) external view returns (uint);
476     function calc_token_amount_withdraw(uint _shares, address _output) external view returns (uint);
477     function convert_rate(address _input, uint _amount) external view returns (uint);
478     function getPricePerFullShare() external view returns (uint);
479     function get_virtual_price() external view returns (uint); // average dollar value of vault share token
480 
481     function deposit(address _input, uint _amount, uint _min_mint_amount) external returns (uint _mint_amount);
482     function depositFor(address _account, address _to, address _input, uint _amount, uint _min_mint_amount) external returns (uint _mint_amount);
483     function depositAll(uint[] calldata _amounts, uint _min_mint_amount) external returns (uint _mint_amount);
484     function depositAllFor(address _account, address _to, uint[] calldata _amounts, uint _min_mint_amount) external returns (uint _mint_amount);
485     function withdraw(uint _shares, address _output, uint _min_output_amount) external returns (uint);
486     function withdrawFor(address _account, uint _shares, address _output, uint _min_output_amount) external returns (uint _output_amount);
487 
488     function harvestStrategy(address _strategy) external;
489     function harvestWant(address _want) external;
490     function harvestAllStrategies() external;
491 }
492 
493 interface IMultiVaultConverter {
494     function token() external returns (address);
495     function get_virtual_price() external view returns (uint);
496 
497     function convert_rate(address _input, address _output, uint _inputAmount) external view returns (uint _outputAmount);
498     function calc_token_amount_deposit(uint[] calldata _amounts) external view returns (uint _shareAmount);
499     function calc_token_amount_withdraw(uint _shares, address _output) external view returns (uint _outputAmount);
500 
501     function convert(address _input, address _output, uint _inputAmount) external returns (uint _outputAmount);
502     function convertAll(uint[] calldata _amounts) external returns (uint _outputAmount);
503 }
504 
505 interface IFreeFromUpTo {
506     function freeFromUpTo(address from, uint value) external returns (uint freed);
507 }
508 
509 contract ValueMultiVaultBank {
510     using SafeMath for uint;
511     using SafeERC20 for IERC20;
512 
513     IFreeFromUpTo public constant chi = IFreeFromUpTo(0x0000000000004946c0e9F43F4Dee607b0eF1fA1c);
514 
515     modifier discountCHI(uint8 _flag) {
516         if ((_flag & 0x1) == 0) {
517             _;
518         } else {
519             uint gasStart = gasleft();
520             _;
521             uint gasSpent = 21000 + gasStart - gasleft() + 16 * msg.data.length;
522             chi.freeFromUpTo(msg.sender, (gasSpent + 14154) / 41130);
523         }
524     }
525 
526     IERC20 public valueToken = IERC20(0x49E833337ECe7aFE375e44F4E3e8481029218E5c);
527 
528     address public governance;
529     address public strategist; // who can call harvestXXX()
530 
531     IValueVaultMaster public vaultMaster;
532     
533     struct UserInfo {
534         uint amount;
535         mapping(uint8 => uint) rewardDebt;
536         mapping(uint8 => uint) accumulatedEarned; // will accumulate every time user harvest
537     }
538 
539     struct RewardPoolInfo {
540         IERC20 rewardToken;     // Address of rewardPool token contract.
541         uint lastRewardBlock;   // Last block number that rewardPool distribution occurs.
542         uint endRewardBlock;    // Block number which rewardPool distribution ends.
543         uint rewardPerBlock;    // Reward token amount to distribute per block.
544         uint accRewardPerShare; // Accumulated rewardPool per share, times 1e18.
545         uint totalPaidRewards;  // for stat only
546     }
547 
548     mapping(address => RewardPoolInfo[]) public rewardPoolInfos; // vault address => pool info
549     mapping(address => mapping(address => UserInfo)) public userInfo; // vault address => account => userInfo
550 
551     event Deposit(address indexed vault, address indexed user, uint amount);
552     event Withdraw(address indexed vault, address indexed user, uint amount);
553     event RewardPaid(address indexed vault, uint pid, address indexed user, uint reward);
554 
555     constructor(IERC20 _valueToken, IValueVaultMaster _vaultMaster) public {
556         valueToken = _valueToken;
557         vaultMaster = _vaultMaster;
558         governance = msg.sender;
559         strategist = msg.sender;
560     }
561 
562     function setGovernance(address _governance) external {
563         require(msg.sender == governance, "!governance");
564         governance = _governance;
565     }
566 
567     function setStrategist(address _strategist) external {
568         require(msg.sender == governance, "!governance");
569         strategist = _strategist;
570     }
571 
572     function setVaultMaster(IValueVaultMaster _vaultMaster) external {
573         require(msg.sender == governance, "!governance");
574         vaultMaster = _vaultMaster;
575     }
576 
577     function addVaultRewardPool(address _vault, IERC20 _rewardToken, uint _startBlock, uint _endRewardBlock, uint _rewardPerBlock) external {
578         require(msg.sender == governance, "!governance");
579         RewardPoolInfo[] storage rewardPools = rewardPoolInfos[_vault];
580         require(rewardPools.length < 8, "exceed rwdPoolLim");
581         _startBlock = (block.number > _startBlock) ? block.number : _startBlock;
582         require(_startBlock <= _endRewardBlock, "sVB>eVB");
583         updateReward(_vault);
584         rewardPools.push(RewardPoolInfo({
585             rewardToken : _rewardToken,
586             lastRewardBlock : _startBlock,
587             endRewardBlock : _endRewardBlock,
588             rewardPerBlock : _rewardPerBlock,
589             accRewardPerShare : 0,
590             totalPaidRewards : 0
591             }));
592     }
593 
594     function updateRewardPool(address _vault, uint8 _pid, uint _endRewardBlock, uint _rewardPerBlock) external {
595         require(msg.sender == governance, "!governance");
596         updateRewardPool(_vault, _pid);
597         RewardPoolInfo storage rewardPool = rewardPoolInfos[_vault][_pid];
598         require(block.number <= rewardPool.endRewardBlock, "late");
599         rewardPool.endRewardBlock = _endRewardBlock;
600         rewardPool.rewardPerBlock = _rewardPerBlock;
601     }
602 
603     function updateReward(address _vault) public {
604         uint8 rewardPoolLength = uint8(rewardPoolInfos[_vault].length);
605         for (uint8 _pid = 0; _pid < rewardPoolLength; ++_pid) {
606             updateRewardPool(_vault, _pid);
607         }
608     }
609 
610     function updateRewardPool(address _vault, uint8 _pid) public {
611         RewardPoolInfo storage rewardPool = rewardPoolInfos[_vault][_pid];
612         uint _endRewardBlockApplicable = block.number > rewardPool.endRewardBlock ? rewardPool.endRewardBlock : block.number;
613         if (_endRewardBlockApplicable > rewardPool.lastRewardBlock) {
614             uint lpSupply = IERC20(address(_vault)).balanceOf(address(this));
615             if (lpSupply > 0) {
616                 uint _numBlocks = _endRewardBlockApplicable.sub(rewardPool.lastRewardBlock);
617                 uint _incRewardPerShare = _numBlocks.mul(rewardPool.rewardPerBlock).mul(1e18).div(lpSupply);
618                 rewardPool.accRewardPerShare = rewardPool.accRewardPerShare.add(_incRewardPerShare);
619             }
620             rewardPool.lastRewardBlock = _endRewardBlockApplicable;
621         }
622     }
623 
624     function cap(IValueMultiVault _vault) external view returns (uint) {
625         return _vault.cap();
626     }
627 
628     function approveForSpender(IERC20 _token, address _spender, uint _amount) external {
629         require(msg.sender == governance, "!governance");
630         require(!vaultMaster.isVault(address(_token)), "vaultToken");
631         _token.safeApprove(_spender, _amount);
632     }
633 
634     function deposit(IValueMultiVault _vault, address _input, uint _amount, uint _min_mint_amount, bool _isStake, uint8 _flag) public discountCHI(_flag) {
635         require(_vault.accept(_input), "vault does not accept this asset");
636         require(_amount > 0, "!_amount");
637 
638         if (!_isStake) {
639             _vault.depositFor(msg.sender, msg.sender, _input, _amount, _min_mint_amount);
640         } else {
641             uint _mint_amount = _vault.depositFor(msg.sender, address(this), _input, _amount, _min_mint_amount);
642             _stakeVaultShares(address(_vault), _mint_amount);
643         }
644     }
645 
646     function depositAll(IValueMultiVault _vault, uint[] calldata _amounts, uint _min_mint_amount, bool _isStake, uint8 _flag) public discountCHI(_flag) {
647         if (!_isStake) {
648             _vault.depositAllFor(msg.sender, msg.sender, _amounts, _min_mint_amount);
649         } else {
650             uint _mint_amount = _vault.depositAllFor(msg.sender, address(this), _amounts, _min_mint_amount);
651             _stakeVaultShares(address(_vault), _mint_amount);
652         }
653     }
654 
655     function stakeVaultShares(address _vault, uint _shares) external {
656         uint _before = IERC20(address(_vault)).balanceOf(address(this));
657         IERC20(address(_vault)).safeTransferFrom(msg.sender, address(this), _shares);
658         uint _after = IERC20(address(_vault)).balanceOf(address(this));
659         _shares = _after.sub(_before); // Additional check for deflationary tokens
660         _stakeVaultShares(_vault, _shares);
661     }
662 
663     function _stakeVaultShares(address _vault, uint _shares) internal {
664         UserInfo storage user = userInfo[_vault][msg.sender];
665         updateReward(_vault);
666         if (user.amount > 0) {
667             getAllRewards(_vault, msg.sender, uint8(0));
668         }
669         user.amount = user.amount.add(_shares);
670         RewardPoolInfo[] storage rewardPools = rewardPoolInfos[_vault];
671         uint8 rewardPoolLength = uint8(rewardPools.length);
672         for (uint8 _pid = 0; _pid < rewardPoolLength; ++_pid) {
673             user.rewardDebt[_pid] = user.amount.mul(rewardPools[_pid].accRewardPerShare).div(1e18);
674         }
675         emit Deposit(_vault, msg.sender, _shares);
676     }
677 
678     // call unstake(_vault, 0) for getting reward
679     function unstake(address _vault, uint _amount, uint8 _flag) public discountCHI(_flag) {
680         UserInfo storage user = userInfo[_vault][msg.sender];
681         updateReward(_vault);
682         if (user.amount > 0) {
683             getAllRewards(_vault, msg.sender, uint8(0));
684         }
685         if (_amount > 0) {
686             user.amount = user.amount.sub(_amount);
687             IERC20(address(_vault)).safeTransfer(msg.sender, _amount);
688         }
689         RewardPoolInfo[] storage rewardPools = rewardPoolInfos[_vault];
690         uint8 rewardPoolLength = uint8(rewardPools.length);
691         for (uint8 _pid = 0; _pid < rewardPoolLength; ++_pid) {
692             user.rewardDebt[_pid] = user.amount.mul(rewardPools[_pid].accRewardPerShare).div(1e18);
693         }
694         emit Withdraw(_vault, msg.sender, _amount);
695     }
696 
697     // using PUSH pattern
698     function getAllRewards(address _vault, address _account, uint8 _flag) public discountCHI(_flag) {
699         uint8 rewardPoolLength = uint8(rewardPoolInfos[_vault].length);
700         for (uint8 _pid = 0; _pid < rewardPoolLength; ++_pid) {
701             getReward(_vault, _pid, _account, uint8(0));
702         }
703     }
704 
705     function getReward(address _vault, uint8 _pid, address _account, uint8 _flag) public discountCHI(_flag) {
706         updateRewardPool(_vault, _pid);
707         UserInfo storage user = userInfo[_vault][_account];
708         RewardPoolInfo storage rewardPool = rewardPoolInfos[_vault][_pid];
709         uint _pendingReward = user.amount.mul(rewardPool.accRewardPerShare).div(1e18).sub(user.rewardDebt[_pid]);
710         if (_pendingReward > 0) {
711             user.accumulatedEarned[_pid] = user.accumulatedEarned[_pid].add(_pendingReward);
712             rewardPool.totalPaidRewards = rewardPool.totalPaidRewards.add(_pendingReward);
713             safeTokenTransfer(rewardPool.rewardToken, _account, _pendingReward);
714             emit RewardPaid(_vault, _pid, _account, _pendingReward);
715             user.rewardDebt[_pid] = user.amount.mul(rewardPool.accRewardPerShare).div(1e18);
716         }
717     }
718 
719     function pendingReward(address _vault, uint8 _pid, address _account) public view returns (uint _pending) {
720         UserInfo storage user = userInfo[_vault][_account];
721         RewardPoolInfo storage rewardPool = rewardPoolInfos[_vault][_pid];
722         uint _accRewardPerShare = rewardPool.accRewardPerShare;
723         uint lpSupply = IERC20(_vault).balanceOf(address(this));
724         uint _endRewardBlockApplicable = block.number > rewardPool.endRewardBlock ? rewardPool.endRewardBlock : block.number;
725         if (_endRewardBlockApplicable > rewardPool.lastRewardBlock && lpSupply != 0) {
726             uint _numBlocks = _endRewardBlockApplicable.sub(rewardPool.lastRewardBlock);
727             uint _incRewardPerShare = _numBlocks.mul(rewardPool.rewardPerBlock).mul(1e18).div(lpSupply);
728             _accRewardPerShare = _accRewardPerShare.add(_incRewardPerShare);
729         }
730         _pending = user.amount.mul(_accRewardPerShare).div(1e18).sub(user.rewardDebt[_pid]);
731     }
732 
733     function shares_owner(address _vault, address _account) public view returns (uint) {
734         return IERC20(_vault).balanceOf(_account).add(userInfo[_vault][_account].amount);
735     }
736 
737     // No rebalance implementation for lower fees and faster swaps
738     function withdraw(address _vault, uint _shares, address _output, uint _min_output_amount, uint8 _flag) public discountCHI(_flag) {
739         uint _userBal = IERC20(address(_vault)).balanceOf(msg.sender);
740         if (_shares > _userBal) {
741             uint _need = _shares.sub(_userBal);
742             require(_need <= userInfo[_vault][msg.sender].amount, "_userBal+staked < _shares");
743             unstake(_vault, _need, uint8(0));
744         }
745         IERC20(address(_vault)).safeTransferFrom(msg.sender, address(this), _shares);
746         IValueMultiVault(_vault).withdrawFor(msg.sender, _shares, _output, _min_output_amount);
747     }
748 
749     function exit(address _vault, address _output, uint _min_output_amount, uint8 _flag) external discountCHI(_flag) {
750         unstake(_vault, userInfo[_vault][msg.sender].amount, uint8(0));
751         withdraw(_vault, IERC20(address(_vault)).balanceOf(msg.sender), _output, _min_output_amount, uint8(0));
752     }
753 
754     function withdraw_fee(IValueMultiVault _vault, uint _shares) external view returns (uint) {
755         return _vault.withdraw_fee(_shares);
756     }
757 
758     function calc_token_amount_deposit(IValueMultiVault _vault, uint[] calldata _amounts) external view returns (uint) {
759         return _vault.calc_token_amount_deposit(_amounts);
760     }
761 
762     function calc_token_amount_withdraw(IValueMultiVault _vault, uint _shares, address _output) external view returns (uint) {
763         return _vault.calc_token_amount_withdraw(_shares, _output);
764     }
765 
766     function convert_rate(IValueMultiVault _vault, address _input, uint _amount) external view returns (uint) {
767         return _vault.convert_rate(_input, _amount);
768     }
769 
770     function harvestStrategy(IValueMultiVault _vault, address _strategy, uint8 _flag) external discountCHI(_flag) {
771         require(msg.sender == strategist || msg.sender == governance, "!strategist");
772         _vault.harvestStrategy(_strategy);
773     }
774 
775     function harvestWant(IValueMultiVault _vault, address _want, uint8 _flag) external discountCHI(_flag) {
776         require(msg.sender == strategist || msg.sender == governance, "!strategist");
777         _vault.harvestWant(_want);
778     }
779 
780     function harvestAllStrategies(IValueMultiVault _vault, uint8 _flag) external discountCHI(_flag) {
781         require(msg.sender == strategist || msg.sender == governance, "!strategist");
782         _vault.harvestAllStrategies();
783     }
784 
785     // Safe token transfer function, just in case if rounding error causes vinfo to not have enough token.
786     function safeTokenTransfer(IERC20 _token, address _to, uint _amount) internal {
787         uint bal = _token.balanceOf(address(this));
788         if (_amount > bal) {
789             _token.safeTransfer(_to, bal);
790         } else {
791             _token.safeTransfer(_to, _amount);
792         }
793     }
794 
795     /**
796      * This function allows governance to take unsupported tokens out of the contract. This is in an effort to make someone whole, should they seriously mess up.
797      * There is no guarantee governance will vote to return these. It also allows for removal of airdropped tokens.
798      */
799     function governanceRecoverUnsupported(IERC20 _token, uint amount, address to) external {
800         require(msg.sender == governance, "!governance");
801         require(!vaultMaster.isVault(address(_token)), "vaultToken");
802         _token.safeTransfer(to, amount);
803     }
804 }