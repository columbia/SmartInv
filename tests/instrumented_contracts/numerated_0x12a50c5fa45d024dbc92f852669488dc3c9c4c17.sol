1 // File: @openzeppelin/contracts/math/SafeMath.sol
2 
3 pragma solidity ^0.5.0;
4 
5 /**
6  * @dev Wrappers over Solidity's arithmetic operations with added overflow
7  * checks.
8  *
9  * Arithmetic operations in Solidity wrap on overflow. This can easily result
10  * in bugs, because programmers usually assume that an overflow raises an
11  * error, which is the standard behavior in high level programming languages.
12  * `SafeMath` restores this intuition by reverting the transaction when an
13  * operation overflows.
14  *
15  * Using this library instead of the unchecked operations eliminates an entire
16  * class of bugs, so it's recommended to use it always.
17  */
18 library SafeMath {
19   /**
20    * @dev Returns the addition of two unsigned integers, reverting on
21    * overflow.
22    *
23    * Counterpart to Solidity's `+` operator.
24    *
25    * Requirements:
26    * - Addition cannot overflow.
27    */
28   function add(uint256 a, uint256 b) internal pure returns (uint256) {
29     uint256 c = a + b;
30     require(c >= a, "SafeMath: addition overflow");
31 
32     return c;
33   }
34 
35   /**
36    * @dev Returns the subtraction of two unsigned integers, reverting on
37    * overflow (when the result is negative).
38    *
39    * Counterpart to Solidity's `-` operator.
40    *
41    * Requirements:
42    * - Subtraction cannot overflow.
43    */
44   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
45     return sub(a, b, "SafeMath: subtraction overflow");
46   }
47 
48   /**
49    * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
50    * overflow (when the result is negative).
51    *
52    * Counterpart to Solidity's `-` operator.
53    *
54    * Requirements:
55    * - Subtraction cannot overflow.
56    *
57    * _Available since v2.4.0._
58    */
59   function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
60     require(b <= a, errorMessage);
61     uint256 c = a - b;
62 
63     return c;
64   }
65 
66   /**
67    * @dev Returns the multiplication of two unsigned integers, reverting on
68    * overflow.
69    *
70    * Counterpart to Solidity's `*` operator.
71    *
72    * Requirements:
73    * - Multiplication cannot overflow.
74    */
75   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
76     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
77     // benefit is lost if 'b' is also tested.
78     // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
79     if (a == 0) {
80       return 0;
81     }
82 
83     uint256 c = a * b;
84     require(c / a == b, "SafeMath: multiplication overflow");
85 
86     return c;
87   }
88 
89   /**
90    * @dev Returns the integer division of two unsigned integers. Reverts on
91    * division by zero. The result is rounded towards zero.
92    *
93    * Counterpart to Solidity's `/` operator. Note: this function uses a
94    * `revert` opcode (which leaves remaining gas untouched) while Solidity
95    * uses an invalid opcode to revert (consuming all remaining gas).
96    *
97    * Requirements:
98    * - The divisor cannot be zero.
99    */
100   function div(uint256 a, uint256 b) internal pure returns (uint256) {
101     return div(a, b, "SafeMath: division by zero");
102   }
103 
104   /**
105    * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
106    * division by zero. The result is rounded towards zero.
107    *
108    * Counterpart to Solidity's `/` operator. Note: this function uses a
109    * `revert` opcode (which leaves remaining gas untouched) while Solidity
110    * uses an invalid opcode to revert (consuming all remaining gas).
111    *
112    * Requirements:
113    * - The divisor cannot be zero.
114    *
115    * _Available since v2.4.0._
116    */
117   function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
118     // Solidity only automatically asserts when dividing by 0
119     require(b > 0, errorMessage);
120     uint256 c = a / b;
121     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
122 
123     return c;
124   }
125 
126   /**
127    * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
128    * Reverts when dividing by zero.
129    *
130    * Counterpart to Solidity's `%` operator. This function uses a `revert`
131    * opcode (which leaves remaining gas untouched) while Solidity uses an
132    * invalid opcode to revert (consuming all remaining gas).
133    *
134    * Requirements:
135    * - The divisor cannot be zero.
136    */
137   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
138     return mod(a, b, "SafeMath: modulo by zero");
139   }
140 
141   /**
142    * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
143    * Reverts with custom message when dividing by zero.
144    *
145    * Counterpart to Solidity's `%` operator. This function uses a `revert`
146    * opcode (which leaves remaining gas untouched) while Solidity uses an
147    * invalid opcode to revert (consuming all remaining gas).
148    *
149    * Requirements:
150    * - The divisor cannot be zero.
151    *
152    * _Available since v2.4.0._
153    */
154   function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
155     require(b != 0, errorMessage);
156     return a % b;
157   }
158 }
159 
160 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
161 
162 pragma solidity ^0.5.0;
163 
164 /**
165  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
166  * the optional functions; to access them see {ERC20Detailed}.
167  */
168 interface IERC20 {
169   /**
170    * @dev Returns the amount of tokens in existence.
171    */
172   function totalSupply() external view returns (uint256);
173 
174   /**
175    * @dev Returns the amount of tokens owned by `account`.
176    */
177   function balanceOf(address account) external view returns (uint256);
178 
179   /**
180    * @dev Moves `amount` tokens from the caller's account to `recipient`.
181    *
182    * Returns a boolean value indicating whether the operation succeeded.
183    *
184    * Emits a {Transfer} event.
185    */
186   function transfer(address recipient, uint256 amount) external returns (bool);
187 
188   /**
189    * @dev Returns the remaining number of tokens that `spender` will be
190    * allowed to spend on behalf of `owner` through {transferFrom}. This is
191    * zero by default.
192    *
193    * This value changes when {approve} or {transferFrom} are called.
194    */
195   function allowance(address owner, address spender) external view returns (uint256);
196 
197   /**
198    * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
199    *
200    * Returns a boolean value indicating whether the operation succeeded.
201    *
202    * IMPORTANT: Beware that changing an allowance with this method brings the risk
203    * that someone may use both the old and the new allowance by unfortunate
204    * transaction ordering. One possible solution to mitigate this race
205    * condition is to first reduce the spender's allowance to 0 and set the
206    * desired value afterwards:
207    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
208    *
209    * Emits an {Approval} event.
210    */
211   function approve(address spender, uint256 amount) external returns (bool);
212 
213   /**
214    * @dev Moves `amount` tokens from `sender` to `recipient` using the
215    * allowance mechanism. `amount` is then deducted from the caller's
216    * allowance.
217    *
218    * Returns a boolean value indicating whether the operation succeeded.
219    *
220    * Emits a {Transfer} event.
221    */
222   function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
223 
224   /**
225    * @dev Emitted when `value` tokens are moved from one account (`from`) to
226    * another (`to`).
227    *
228    * Note that `value` may be zero.
229    */
230   event Transfer(address indexed from, address indexed to, uint256 value);
231 
232   /**
233    * @dev Emitted when the allowance of a `spender` for an `owner` is set by
234    * a call to {approve}. `value` is the new allowance.
235    */
236   event Approval(address indexed owner, address indexed spender, uint256 value);
237 }
238 
239 // File: @openzeppelin/contracts/utils/Address.sol
240 
241 pragma solidity ^0.5.5;
242 
243 /**
244  * @dev Collection of functions related to the address type
245  */
246 library Address {
247   /**
248    * @dev Returns true if `account` is a contract.
249    *
250    * This test is non-exhaustive, and there may be false-negatives: during the
251    * execution of a contract's constructor, its address will be reported as
252    * not containing a contract.
253    *
254    * IMPORTANT: It is unsafe to assume that an address for which this
255    * function returns false is an externally-owned account (EOA) and not a
256    * contract.
257    */
258   function isContract(address account) internal view returns (bool) {
259     // This method relies in extcodesize, which returns 0 for contracts in
260     // construction, since the code is only stored at the end of the
261     // constructor execution.
262 
263     // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
264     // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
265     // for accounts without code, i.e. `keccak256('')`
266     bytes32 codehash;
267     bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
268     // solhint-disable-next-line no-inline-assembly
269     assembly { codehash := extcodehash(account) }
270     return (codehash != 0x0 && codehash != accountHash);
271   }
272 
273   /**
274    * @dev Converts an `address` into `address payable`. Note that this is
275    * simply a type cast: the actual underlying value is not changed.
276    *
277    * _Available since v2.4.0._
278    */
279   function toPayable(address account) internal pure returns (address payable) {
280     return address(uint160(account));
281   }
282 
283   /**
284    * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
285    * `recipient`, forwarding all available gas and reverting on errors.
286    *
287    * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
288    * of certain opcodes, possibly making contracts go over the 2300 gas limit
289    * imposed by `transfer`, making them unable to receive funds via
290    * `transfer`. {sendValue} removes this limitation.
291    *
292    * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
293    *
294    * IMPORTANT: because control is transferred to `recipient`, care must be
295    * taken to not create reentrancy vulnerabilities. Consider using
296    * {ReentrancyGuard} or the
297    * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
298    *
299    * _Available since v2.4.0._
300    */
301   function sendValue(address payable recipient, uint256 amount) internal {
302     require(address(this).balance >= amount, "Address: insufficient balance");
303 
304     // solhint-disable-next-line avoid-call-value
305     (bool success, ) = recipient.call.value(amount)("");
306     require(success, "Address: unable to send value, recipient may have reverted");
307   }
308 }
309 
310 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
311 
312 pragma solidity ^0.5.0;
313 
314 
315 
316 
317 /**
318  * @title SafeERC20
319  * @dev Wrappers around ERC20 operations that throw on failure (when the token
320  * contract returns false). Tokens that return no value (and instead revert or
321  * throw on failure) are also supported, non-reverting calls are assumed to be
322  * successful.
323  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
324  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
325  */
326 library SafeERC20 {
327   using SafeMath for uint256;
328   using Address for address;
329 
330   function safeTransfer(IERC20 token, address to, uint256 value) internal {
331     callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
332   }
333 
334   function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
335     callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
336   }
337 
338   function safeApprove(IERC20 token, address spender, uint256 value) internal {
339     // safeApprove should only be called when setting an initial allowance,
340     // or when resetting it to zero. To increase and decrease it, use
341     // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
342     // solhint-disable-next-line max-line-length
343     require((value == 0) || (token.allowance(address(this), spender) == 0),
344       "SafeERC20: approve from non-zero to non-zero allowance"
345     );
346     callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
347   }
348 
349   function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
350     uint256 newAllowance = token.allowance(address(this), spender).add(value);
351     callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
352   }
353 
354   function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
355     uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
356     callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
357   }
358 
359   /**
360    * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
361    * on the return value: the return value is optional (but if data is returned, it must not be false).
362    * @param token The token targeted by the call.
363    * @param data The call data (encoded using abi.encode or one of its variants).
364    */
365   function callOptionalReturn(IERC20 token, bytes memory data) private {
366     // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
367     // we're implementing it ourselves.
368 
369     // A Solidity high level call has three parts:
370     //  1. The target address is checked to verify it contains contract code
371     //  2. The call itself is made, and success asserted
372     //  3. The return value is decoded, which in turn checks the size of the returned data.
373     // solhint-disable-next-line max-line-length
374     require(address(token).isContract(), "SafeERC20: call to non-contract");
375 
376     // solhint-disable-next-line avoid-low-level-calls
377     (bool success, bytes memory returndata) = address(token).call(data);
378     require(success, "SafeERC20: low-level call failed");
379 
380     if (returndata.length > 0) { // Return data is optional
381       // solhint-disable-next-line max-line-length
382       require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
383     }
384   }
385 }
386 
387 
388 contract Storage {
389 
390   address public governance;
391   address public controller;
392 
393   constructor() public {
394     governance = msg.sender;
395   }
396 
397   modifier onlyGovernance() {
398     require(isGovernance(msg.sender), "Not governance");
399     _;
400   }
401 
402   function setGovernance(address _governance) public onlyGovernance {
403     require(_governance != address(0), "new governance shouldn't be empty");
404     governance = _governance;
405   }
406 
407   function setController(address _controller) public onlyGovernance {
408     require(_controller != address(0), "new controller shouldn't be empty");
409     controller = _controller;
410   }
411 
412   function isGovernance(address account) public view returns (bool) {
413     return account == governance;
414   }
415 
416   function isController(address account) public view returns (bool) {
417     return account == controller;
418   }
419 }
420 
421 contract Governable {
422 
423   Storage public store;
424 
425   constructor(address _store) public {
426     require(_store != address(0), "new storage shouldn't be empty");
427     store = Storage(_store);
428   }
429 
430   modifier onlyGovernance() {
431     require(store.isGovernance(msg.sender), "Not governance");
432     _;
433   }
434 
435   function setStorage(address _store) public onlyGovernance {
436     require(_store != address(0), "new storage shouldn't be empty");
437     store = Storage(_store);
438   }
439 
440   function governance() public view returns (address) {
441     return store.governance();
442   }
443 }
444 
445 contract Controllable is Governable {
446 
447   constructor(address _storage) Governable(_storage) public {
448   }
449 
450   modifier onlyController() {
451     require(store.isController(msg.sender), "Not a controller");
452     _;
453   }
454 
455   modifier onlyControllerOrGovernance(){
456     require((store.isController(msg.sender) || store.isGovernance(msg.sender)),
457       "The caller must be controller or governance");
458     _;
459   }
460 
461   function controller() public view returns (address) {
462     return store.controller();
463   }
464 }
465 
466 
467 interface IMintRewardPool {
468   function balanceOf(address account) external view returns (uint256);
469   function exit() external;
470   function stake(uint256 amount) external;
471   function earned(address account) external view returns (uint256);
472 }
473 
474 
475 interface IController {
476   // [Grey list]
477   // An EOA can safely interact with the system no matter what.
478   // If you're using Metamask, you're using an EOA.
479   // Only smart contracts may be affected by this grey list.
480   //
481   // This contract will not be able to ban any EOA from the system
482   // even if an EOA is being added to the greyList, he/she will still be able
483   // to interact with the whole system as if nothing happened.
484   // Only smart contracts will be affected by being added to the greyList.
485   // This grey list is only used in Vault.sol, see the code there for reference
486   function greyList(address _target) external view returns(bool);
487 
488   function addVaultAndStrategy(address _vault, address _strategy) external;
489   function doHardWork(address _vault) external;
490   function hasVault(address _vault) external returns(bool);
491 
492   function salvage(address _token, uint256 amount) external;
493   function salvageStrategy(address _strategy, address _token, uint256 amount) external;
494 
495   function notifyFee(address _underlying, uint256 fee) external;
496   function profitSharingNumerator() external view returns (uint256);
497   function profitSharingDenominator() external view returns (uint256);
498 }
499 
500 
501 
502 contract AutoStake is Controllable {
503 
504   using SafeERC20 for IERC20;
505   using SafeMath for uint256;
506 
507   IMintRewardPool public rewardPool;
508   IERC20 public lpToken;
509   uint256 public unit = 1e18;
510   uint256 public valuePerShare = unit;
511   uint256 public totalShares = 0;
512   uint256 public totalValue = 0;
513   mapping(address => uint256) public share;
514 
515   event Staked(address indexed user, uint256 amount, uint256 sharesIssued, uint256 oldShareVaule, uint256 newShareValue, uint256 balanceOf);
516   event Withdrawn(address indexed user, uint256 total);
517 
518   constructor(address _storage, address pool, address token) public
519   Controllable(_storage)
520   {
521     rewardPool = IMintRewardPool(pool);
522     lpToken = IERC20(token);
523   }
524 
525   function refreshAutoStake() external {
526     exitRewardPool();
527     updateValuePerShare();
528     restakeIntoRewardPool();
529   }
530 
531   function stake(uint256 amount) public {
532     exitRewardPool();
533     updateValuePerShare();
534 
535     // now we can issue shares
536     lpToken.safeTransferFrom(msg.sender, address(this), amount);
537     uint256 sharesToIssue = amount.mul(unit).div(valuePerShare);
538     totalShares = totalShares.add(sharesToIssue);
539     share[msg.sender] = share[msg.sender].add(sharesToIssue);
540 
541     uint256 oldValuePerShare = valuePerShare;
542 
543     // Rate needs to be updated here, otherwise the valuePerShare would be incorrect.
544     updateValuePerShare();
545 
546     emit Staked(msg.sender, amount, sharesToIssue, oldValuePerShare, valuePerShare, balanceOf(msg.sender));
547 
548     restakeIntoRewardPool();
549   }
550 
551   function exit() public {
552     exitRewardPool();
553     updateValuePerShare();
554 
555     // now we can transfer funds and burn shares
556     uint256 toTransfer = balanceOf(msg.sender);
557     lpToken.safeTransfer(msg.sender, toTransfer);
558     totalShares = totalShares.sub(share[msg.sender]);
559     share[msg.sender] = 0;
560     emit Withdrawn(msg.sender, toTransfer);
561     // Rate needs to be updated here, otherwise the valuePerShare would be incorrect.
562     updateValuePerShare();
563 
564     restakeIntoRewardPool();
565   }
566 
567   function balanceOf(address who) public view returns(uint256) {
568     return valuePerShare.mul(share[who]).div(unit);
569   }
570 
571   function earned(address account) external view returns (uint256) {
572     if (totalShares == 0) {
573       return 0;
574     }
575     uint256 totalBalance = rewardPool.balanceOf(address(this));
576     uint256 totalEarn = rewardPool.earned(address(this));
577     uint256 perShare = totalBalance.add(totalEarn).mul(unit).div(totalShares);
578 
579     return perShare.mul(share[account]).div(unit);
580   }
581 
582   function updateValuePerShare() internal {
583     if (totalShares == 0) {
584       totalValue = 0;
585       valuePerShare = unit;
586     } else {
587       totalValue = lpToken.balanceOf(address(this));
588       valuePerShare = totalValue.mul(unit).div(totalShares);
589     }
590   }
591 
592   function exitRewardPool() internal {
593     if(rewardPool.balanceOf(address(this)) != 0){
594       // exit and do accounting first
595       rewardPool.exit();
596     }
597   }
598 
599   function restakeIntoRewardPool() internal {
600     if(lpToken.balanceOf(address(this)) != 0){
601       // stake back to the pool
602       lpToken.safeApprove(address(rewardPool), 0);
603       lpToken.safeApprove(address(rewardPool), lpToken.balanceOf(address(this)));
604       rewardPool.stake(lpToken.balanceOf(address(this)));
605     }
606   }
607 }