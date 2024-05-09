1 // SPDX-License-Identifier: MIT
2 
3 pragma experimental ABIEncoderV2;
4 pragma solidity 0.6.12;
5 
6 
7 // 
8 /**
9  * @dev Wrappers over Solidity's arithmetic operations with added overflow
10  * checks.
11  *
12  * Arithmetic operations in Solidity wrap on overflow. This can easily result
13  * in bugs, because programmers usually assume that an overflow raises an
14  * error, which is the standard behavior in high level programming languages.
15  * `SafeMath` restores this intuition by reverting the transaction when an
16  * operation overflows.
17  *
18  * Using this library instead of the unchecked operations eliminates an entire
19  * class of bugs, so it's recommended to use it always.
20  */
21 library SafeMath {
22     /**
23      * @dev Returns the addition of two unsigned integers, reverting on
24      * overflow.
25      *
26      * Counterpart to Solidity's `+` operator.
27      *
28      * Requirements:
29      *
30      * - Addition cannot overflow.
31      */
32     function add(uint256 a, uint256 b) internal pure returns (uint256) {
33         uint256 c = a + b;
34         require(c >= a, "SafeMath: addition overflow");
35 
36         return c;
37     }
38 
39     /**
40      * @dev Returns the subtraction of two unsigned integers, reverting on
41      * overflow (when the result is negative).
42      *
43      * Counterpart to Solidity's `-` operator.
44      *
45      * Requirements:
46      *
47      * - Subtraction cannot overflow.
48      */
49     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
50         return sub(a, b, "SafeMath: subtraction overflow");
51     }
52 
53     /**
54      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
55      * overflow (when the result is negative).
56      *
57      * Counterpart to Solidity's `-` operator.
58      *
59      * Requirements:
60      *
61      * - Subtraction cannot overflow.
62      */
63     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
64         require(b <= a, errorMessage);
65         uint256 c = a - b;
66 
67         return c;
68     }
69 
70     /**
71      * @dev Returns the multiplication of two unsigned integers, reverting on
72      * overflow.
73      *
74      * Counterpart to Solidity's `*` operator.
75      *
76      * Requirements:
77      *
78      * - Multiplication cannot overflow.
79      */
80     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
81         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
82         // benefit is lost if 'b' is also tested.
83         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
84         if (a == 0) {
85             return 0;
86         }
87 
88         uint256 c = a * b;
89         require(c / a == b, "SafeMath: multiplication overflow");
90 
91         return c;
92     }
93 
94     /**
95      * @dev Returns the integer division of two unsigned integers. Reverts on
96      * division by zero. The result is rounded towards zero.
97      *
98      * Counterpart to Solidity's `/` operator. Note: this function uses a
99      * `revert` opcode (which leaves remaining gas untouched) while Solidity
100      * uses an invalid opcode to revert (consuming all remaining gas).
101      *
102      * Requirements:
103      *
104      * - The divisor cannot be zero.
105      */
106     function div(uint256 a, uint256 b) internal pure returns (uint256) {
107         return div(a, b, "SafeMath: division by zero");
108     }
109 
110     /**
111      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
112      * division by zero. The result is rounded towards zero.
113      *
114      * Counterpart to Solidity's `/` operator. Note: this function uses a
115      * `revert` opcode (which leaves remaining gas untouched) while Solidity
116      * uses an invalid opcode to revert (consuming all remaining gas).
117      *
118      * Requirements:
119      *
120      * - The divisor cannot be zero.
121      */
122     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
123         require(b > 0, errorMessage);
124         uint256 c = a / b;
125         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
126 
127         return c;
128     }
129 
130     /**
131      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
132      * Reverts when dividing by zero.
133      *
134      * Counterpart to Solidity's `%` operator. This function uses a `revert`
135      * opcode (which leaves remaining gas untouched) while Solidity uses an
136      * invalid opcode to revert (consuming all remaining gas).
137      *
138      * Requirements:
139      *
140      * - The divisor cannot be zero.
141      */
142     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
143         return mod(a, b, "SafeMath: modulo by zero");
144     }
145 
146     /**
147      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
148      * Reverts with custom message when dividing by zero.
149      *
150      * Counterpart to Solidity's `%` operator. This function uses a `revert`
151      * opcode (which leaves remaining gas untouched) while Solidity uses an
152      * invalid opcode to revert (consuming all remaining gas).
153      *
154      * Requirements:
155      *
156      * - The divisor cannot be zero.
157      */
158     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
159         require(b != 0, errorMessage);
160         return a % b;
161     }
162 }
163 
164 // 
165 /**
166  * @dev Interface of the ERC20 standard as defined in the EIP.
167  */
168 interface IERC20 {
169     /**
170      * @dev Returns the amount of tokens in existence.
171      */
172     function totalSupply() external view returns (uint256);
173 
174     /**
175      * @dev Returns the amount of tokens owned by `account`.
176      */
177     function balanceOf(address account) external view returns (uint256);
178 
179     /**
180      * @dev Moves `amount` tokens from the caller's account to `recipient`.
181      *
182      * Returns a boolean value indicating whether the operation succeeded.
183      *
184      * Emits a {Transfer} event.
185      */
186     function transfer(address recipient, uint256 amount) external returns (bool);
187 
188     /**
189      * @dev Returns the remaining number of tokens that `spender` will be
190      * allowed to spend on behalf of `owner` through {transferFrom}. This is
191      * zero by default.
192      *
193      * This value changes when {approve} or {transferFrom} are called.
194      */
195     function allowance(address owner, address spender) external view returns (uint256);
196 
197     /**
198      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
199      *
200      * Returns a boolean value indicating whether the operation succeeded.
201      *
202      * IMPORTANT: Beware that changing an allowance with this method brings the risk
203      * that someone may use both the old and the new allowance by unfortunate
204      * transaction ordering. One possible solution to mitigate this race
205      * condition is to first reduce the spender's allowance to 0 and set the
206      * desired value afterwards:
207      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
208      *
209      * Emits an {Approval} event.
210      */
211     function approve(address spender, uint256 amount) external returns (bool);
212 
213     /**
214      * @dev Moves `amount` tokens from `sender` to `recipient` using the
215      * allowance mechanism. `amount` is then deducted from the caller's
216      * allowance.
217      *
218      * Returns a boolean value indicating whether the operation succeeded.
219      *
220      * Emits a {Transfer} event.
221      */
222     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
223 
224     /**
225      * @dev Emitted when `value` tokens are moved from one account (`from`) to
226      * another (`to`).
227      *
228      * Note that `value` may be zero.
229      */
230     event Transfer(address indexed from, address indexed to, uint256 value);
231 
232     /**
233      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
234      * a call to {approve}. `value` is the new allowance.
235      */
236     event Approval(address indexed owner, address indexed spender, uint256 value);
237 }
238 
239 // 
240 /**
241  * @dev Collection of functions related to the address type
242  */
243 library Address {
244     /**
245      * @dev Returns true if `account` is a contract.
246      *
247      * [IMPORTANT]
248      * ====
249      * It is unsafe to assume that an address for which this function returns
250      * false is an externally-owned account (EOA) and not a contract.
251      *
252      * Among others, `isContract` will return false for the following
253      * types of addresses:
254      *
255      *  - an externally-owned account
256      *  - a contract in construction
257      *  - an address where a contract will be created
258      *  - an address where a contract lived, but was destroyed
259      * ====
260      */
261     function isContract(address account) internal view returns (bool) {
262         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
263         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
264         // for accounts without code, i.e. `keccak256('')`
265         bytes32 codehash;
266         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
267         // solhint-disable-next-line no-inline-assembly
268         assembly { codehash := extcodehash(account) }
269         return (codehash != accountHash && codehash != 0x0);
270     }
271 
272     /**
273      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
274      * `recipient`, forwarding all available gas and reverting on errors.
275      *
276      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
277      * of certain opcodes, possibly making contracts go over the 2300 gas limit
278      * imposed by `transfer`, making them unable to receive funds via
279      * `transfer`. {sendValue} removes this limitation.
280      *
281      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
282      *
283      * IMPORTANT: because control is transferred to `recipient`, care must be
284      * taken to not create reentrancy vulnerabilities. Consider using
285      * {ReentrancyGuard} or the
286      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
287      */
288     function sendValue(address payable recipient, uint256 amount) internal {
289         require(address(this).balance >= amount, "Address: insufficient balance");
290 
291         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
292         (bool success, ) = recipient.call{ value: amount }("");
293         require(success, "Address: unable to send value, recipient may have reverted");
294     }
295 
296     /**
297      * @dev Performs a Solidity function call using a low level `call`. A
298      * plain`call` is an unsafe replacement for a function call: use this
299      * function instead.
300      *
301      * If `target` reverts with a revert reason, it is bubbled up by this
302      * function (like regular Solidity function calls).
303      *
304      * Returns the raw returned data. To convert to the expected return value,
305      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
306      *
307      * Requirements:
308      *
309      * - `target` must be a contract.
310      * - calling `target` with `data` must not revert.
311      *
312      * _Available since v3.1._
313      */
314     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
315       return functionCall(target, data, "Address: low-level call failed");
316     }
317 
318     /**
319      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
320      * `errorMessage` as a fallback revert reason when `target` reverts.
321      *
322      * _Available since v3.1._
323      */
324     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
325         return _functionCallWithValue(target, data, 0, errorMessage);
326     }
327 
328     /**
329      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
330      * but also transferring `value` wei to `target`.
331      *
332      * Requirements:
333      *
334      * - the calling contract must have an ETH balance of at least `value`.
335      * - the called Solidity function must be `payable`.
336      *
337      * _Available since v3.1._
338      */
339     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
340         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
341     }
342 
343     /**
344      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
345      * with `errorMessage` as a fallback revert reason when `target` reverts.
346      *
347      * _Available since v3.1._
348      */
349     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
350         require(address(this).balance >= value, "Address: insufficient balance for call");
351         return _functionCallWithValue(target, data, value, errorMessage);
352     }
353 
354     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
355         require(isContract(target), "Address: call to non-contract");
356 
357         // solhint-disable-next-line avoid-low-level-calls
358         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
359         if (success) {
360             return returndata;
361         } else {
362             // Look for revert reason and bubble it up if present
363             if (returndata.length > 0) {
364                 // The easiest way to bubble the revert reason is using memory via assembly
365 
366                 // solhint-disable-next-line no-inline-assembly
367                 assembly {
368                     let returndata_size := mload(returndata)
369                     revert(add(32, returndata), returndata_size)
370                 }
371             } else {
372                 revert(errorMessage);
373             }
374         }
375     }
376 }
377 
378 // 
379 /**
380  * @title SafeERC20
381  * @dev Wrappers around ERC20 operations that throw on failure (when the token
382  * contract returns false). Tokens that return no value (and instead revert or
383  * throw on failure) are also supported, non-reverting calls are assumed to be
384  * successful.
385  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
386  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
387  */
388 library SafeERC20 {
389     using SafeMath for uint256;
390     using Address for address;
391 
392     function safeTransfer(IERC20 token, address to, uint256 value) internal {
393         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
394     }
395 
396     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
397         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
398     }
399 
400     /**
401      * @dev Deprecated. This function has issues similar to the ones found in
402      * {IERC20-approve}, and its usage is discouraged.
403      *
404      * Whenever possible, use {safeIncreaseAllowance} and
405      * {safeDecreaseAllowance} instead.
406      */
407     function safeApprove(IERC20 token, address spender, uint256 value) internal {
408         // safeApprove should only be called when setting an initial allowance,
409         // or when resetting it to zero. To increase and decrease it, use
410         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
411         // solhint-disable-next-line max-line-length
412         require((value == 0) || (token.allowance(address(this), spender) == 0),
413             "SafeERC20: approve from non-zero to non-zero allowance"
414         );
415         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
416     }
417 
418     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
419         uint256 newAllowance = token.allowance(address(this), spender).add(value);
420         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
421     }
422 
423     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
424         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
425         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
426     }
427 
428     /**
429      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
430      * on the return value: the return value is optional (but if data is returned, it must not be false).
431      * @param token The token targeted by the call.
432      * @param data The call data (encoded using abi.encode or one of its variants).
433      */
434     function _callOptionalReturn(IERC20 token, bytes memory data) private {
435         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
436         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
437         // the target address contains contract code and also asserts for success in the low-level call.
438 
439         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
440         if (returndata.length > 0) { // Return data is optional
441             // solhint-disable-next-line max-line-length
442             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
443         }
444     }
445 }
446 
447 // 
448 /******************
449 @title WadRayMath library
450 @author Aave
451 @dev Provides mul and div function for wads (decimal numbers with 18 digits precision) and rays (decimals with 27 digits)
452  */
453 library WadRayMath {
454   using SafeMath for uint256;
455 
456   uint256 internal constant _WAD = 1e18;
457   uint256 internal constant _HALF_WAD = _WAD / 2;
458 
459   uint256 internal constant _RAY = 1e27;
460   uint256 internal constant _HALF_RAY = _RAY / 2;
461 
462   uint256 internal constant _WAD_RAY_RATIO = 1e9;
463 
464   function ray() internal pure returns (uint256) {
465     return _RAY;
466   }
467 
468   function wad() internal pure returns (uint256) {
469     return _WAD;
470   }
471 
472   function halfRay() internal pure returns (uint256) {
473     return _HALF_RAY;
474   }
475 
476   function halfWad() internal pure returns (uint256) {
477     return _HALF_WAD;
478   }
479 
480   function wadMul(uint256 a, uint256 b) internal pure returns (uint256) {
481     return _HALF_WAD.add(a.mul(b)).div(_WAD);
482   }
483 
484   function wadDiv(uint256 a, uint256 b) internal pure returns (uint256) {
485     uint256 halfB = b / 2;
486 
487     return halfB.add(a.mul(_WAD)).div(b);
488   }
489 
490   function rayMul(uint256 a, uint256 b) internal pure returns (uint256) {
491     return _HALF_RAY.add(a.mul(b)).div(_RAY);
492   }
493 
494   function rayDiv(uint256 a, uint256 b) internal pure returns (uint256) {
495     uint256 halfB = b / 2;
496 
497     return halfB.add(a.mul(_RAY)).div(b);
498   }
499 
500   function rayToWad(uint256 a) internal pure returns (uint256) {
501     uint256 halfRatio = _WAD_RAY_RATIO / 2;
502 
503     return halfRatio.add(a).div(_WAD_RAY_RATIO);
504   }
505 
506   function wadToRay(uint256 a) internal pure returns (uint256) {
507     return a.mul(_WAD_RAY_RATIO);
508   }
509 
510   /**
511    * @dev calculates x^n, in ray. The code uses the ModExp precompile
512    * @param x base
513    * @param n exponent
514    * @return z = x^n, in ray
515    */
516   function rayPow(uint256 x, uint256 n) internal pure returns (uint256 z) {
517     z = n % 2 != 0 ? x : _RAY;
518 
519     for (n /= 2; n != 0; n /= 2) {
520       x = rayMul(x, x);
521 
522       if (n % 2 != 0) {
523         z = rayMul(z, x);
524       }
525     }
526   }
527 }
528 
529 // 
530 interface IAccessController {
531   event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
532   event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
533   event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
534 
535   function grantRole(bytes32 role, address account) external;
536 
537   function revokeRole(bytes32 role, address account) external;
538 
539   function renounceRole(bytes32 role, address account) external;
540 
541   function MANAGER_ROLE() external view returns (bytes32);
542 
543   function MINTER_ROLE() external view returns (bytes32);
544 
545   function hasRole(bytes32 role, address account) external view returns (bool);
546 
547   function getRoleMemberCount(bytes32 role) external view returns (uint256);
548 
549   function getRoleMember(bytes32 role, uint256 index) external view returns (address);
550 
551   function getRoleAdmin(bytes32 role) external view returns (bytes32);
552 }
553 
554 // 
555 interface ISTABLEX is IERC20 {
556   function mint(address account, uint256 amount) external;
557 
558   function burn(address account, uint256 amount) external;
559 
560   function a() external view returns (IAddressProvider);
561 }
562 
563 // 
564 interface AggregatorV3Interface {
565   function decimals() external view returns (uint8);
566 
567   function description() external view returns (string memory);
568 
569   function version() external view returns (uint256);
570 
571   function getRoundData(uint80 _roundId)
572     external
573     view
574     returns (
575       uint80 roundId,
576       int256 answer,
577       uint256 startedAt,
578       uint256 updatedAt,
579       uint80 answeredInRound
580     );
581 
582   function latestRoundData()
583     external
584     view
585     returns (
586       uint80 roundId,
587       int256 answer,
588       uint256 startedAt,
589       uint256 updatedAt,
590       uint80 answeredInRound
591     );
592 }
593 
594 // 
595 interface IPriceFeed {
596   event OracleUpdated(address indexed asset, address oracle, address sender);
597   event EurOracleUpdated(address oracle, address sender);
598 
599   function setAssetOracle(address _asset, address _oracle) external;
600 
601   function setEurOracle(address _oracle) external;
602 
603   function a() external view returns (IAddressProvider);
604 
605   function assetOracles(address _asset) external view returns (AggregatorV3Interface);
606 
607   function eurOracle() external view returns (AggregatorV3Interface);
608 
609   function getAssetPrice(address _asset) external view returns (uint256);
610 
611   function convertFrom(address _asset, uint256 _amount) external view returns (uint256);
612 
613   function convertTo(address _asset, uint256 _amount) external view returns (uint256);
614 }
615 
616 // 
617 interface IRatesManager {
618   function a() external view returns (IAddressProvider);
619 
620   //current annualized borrow rate
621   function annualizedBorrowRate(uint256 _currentBorrowRate) external pure returns (uint256);
622 
623   //uses current cumulative rate to calculate totalDebt based on baseDebt at time T0
624   function calculateDebt(uint256 _baseDebt, uint256 _cumulativeRate) external pure returns (uint256);
625 
626   //uses current cumulative rate to calculate baseDebt at time T0
627   function calculateBaseDebt(uint256 _debt, uint256 _cumulativeRate) external pure returns (uint256);
628 
629   //calculate a new cumulative rate
630   function calculateCumulativeRate(
631     uint256 _borrowRate,
632     uint256 _cumulativeRate,
633     uint256 _timeElapsed
634   ) external view returns (uint256);
635 }
636 
637 // 
638 interface ILiquidationManager {
639   function a() external view returns (IAddressProvider);
640 
641   function calculateHealthFactor(
642     uint256 _collateralValue,
643     uint256 _vaultDebt,
644     uint256 _minRatio
645   ) external view returns (uint256 healthFactor);
646 
647   function liquidationBonus(address _collateralType, uint256 _amount) external view returns (uint256 bonus);
648 
649   function applyLiquidationDiscount(address _collateralType, uint256 _amount)
650     external
651     view
652     returns (uint256 discountedAmount);
653 
654   function isHealthy(
655     uint256 _collateralValue,
656     uint256 _vaultDebt,
657     uint256 _minRatio
658   ) external view returns (bool);
659 }
660 
661 // 
662 interface IVaultsDataProvider {
663   struct Vault {
664     // borrowedType support USDX / PAR
665     address collateralType;
666     address owner;
667     uint256 collateralBalance;
668     uint256 baseDebt;
669     uint256 createdAt;
670   }
671 
672   //Write
673   function createVault(address _collateralType, address _owner) external returns (uint256);
674 
675   function setCollateralBalance(uint256 _id, uint256 _balance) external;
676 
677   function setBaseDebt(uint256 _id, uint256 _newBaseDebt) external;
678 
679   // Read
680   function a() external view returns (IAddressProvider);
681 
682   function baseDebt(address _collateralType) external view returns (uint256);
683 
684   function vaultCount() external view returns (uint256);
685 
686   function vaults(uint256 _id) external view returns (Vault memory);
687 
688   function vaultOwner(uint256 _id) external view returns (address);
689 
690   function vaultCollateralType(uint256 _id) external view returns (address);
691 
692   function vaultCollateralBalance(uint256 _id) external view returns (uint256);
693 
694   function vaultBaseDebt(uint256 _id) external view returns (uint256);
695 
696   function vaultId(address _collateralType, address _owner) external view returns (uint256);
697 
698   function vaultExists(uint256 _id) external view returns (bool);
699 
700   function vaultDebt(uint256 _vaultId) external view returns (uint256);
701 
702   function debt() external view returns (uint256);
703 
704   function collateralDebt(address _collateralType) external view returns (uint256);
705 }
706 
707 // 
708 interface IFeeDistributor {
709   event PayeeAdded(address indexed account, uint256 shares);
710   event FeeReleased(uint256 income, uint256 releasedAt);
711 
712   function release() external;
713 
714   function changePayees(address[] memory _payees, uint256[] memory _shares) external;
715 
716   function a() external view returns (IAddressProvider);
717 
718   function lastReleasedAt() external view returns (uint256);
719 
720   function getPayees() external view returns (address[] memory);
721 
722   function totalShares() external view returns (uint256);
723 
724   function shares(address payee) external view returns (uint256);
725 }
726 
727 // 
728 interface IAddressProvider {
729   function setAccessController(IAccessController _controller) external;
730 
731   function setConfigProvider(IConfigProvider _config) external;
732 
733   function setVaultsCore(IVaultsCore _core) external;
734 
735   function setStableX(ISTABLEX _stablex) external;
736 
737   function setRatesManager(IRatesManager _ratesManager) external;
738 
739   function setPriceFeed(IPriceFeed _priceFeed) external;
740 
741   function setLiquidationManager(ILiquidationManager _liquidationManager) external;
742 
743   function setVaultsDataProvider(IVaultsDataProvider _vaultsData) external;
744 
745   function setFeeDistributor(IFeeDistributor _feeDistributor) external;
746 
747   function controller() external view returns (IAccessController);
748 
749   function config() external view returns (IConfigProvider);
750 
751   function core() external view returns (IVaultsCore);
752 
753   function stablex() external view returns (ISTABLEX);
754 
755   function ratesManager() external view returns (IRatesManager);
756 
757   function priceFeed() external view returns (IPriceFeed);
758 
759   function liquidationManager() external view returns (ILiquidationManager);
760 
761   function vaultsData() external view returns (IVaultsDataProvider);
762 
763   function feeDistributor() external view returns (IFeeDistributor);
764 }
765 
766 // 
767 interface IConfigProviderV1 {
768   struct CollateralConfig {
769     address collateralType;
770     uint256 debtLimit;
771     uint256 minCollateralRatio;
772     uint256 borrowRate;
773     uint256 originationFee;
774   }
775 
776   event CollateralUpdated(
777     address indexed collateralType,
778     uint256 debtLimit,
779     uint256 minCollateralRatio,
780     uint256 borrowRate,
781     uint256 originationFee
782   );
783   event CollateralRemoved(address indexed collateralType);
784 
785   function setCollateralConfig(
786     address _collateralType,
787     uint256 _debtLimit,
788     uint256 _minCollateralRatio,
789     uint256 _borrowRate,
790     uint256 _originationFee
791   ) external;
792 
793   function removeCollateral(address _collateralType) external;
794 
795   function setCollateralDebtLimit(address _collateralType, uint256 _debtLimit) external;
796 
797   function setCollateralMinCollateralRatio(address _collateralType, uint256 _minCollateralRatio) external;
798 
799   function setCollateralBorrowRate(address _collateralType, uint256 _borrowRate) external;
800 
801   function setCollateralOriginationFee(address _collateralType, uint256 _originationFee) external;
802 
803   function setLiquidationBonus(uint256 _bonus) external;
804 
805   function a() external view returns (IAddressProviderV1);
806 
807   function collateralConfigs(uint256 _id) external view returns (CollateralConfig memory);
808 
809   function collateralIds(address _collateralType) external view returns (uint256);
810 
811   function numCollateralConfigs() external view returns (uint256);
812 
813   function liquidationBonus() external view returns (uint256);
814 
815   function collateralDebtLimit(address _collateralType) external view returns (uint256);
816 
817   function collateralMinCollateralRatio(address _collateralType) external view returns (uint256);
818 
819   function collateralBorrowRate(address _collateralType) external view returns (uint256);
820 
821   function collateralOriginationFee(address _collateralType) external view returns (uint256);
822 }
823 
824 // 
825 interface ILiquidationManagerV1 {
826   function a() external view returns (IAddressProviderV1);
827 
828   function calculateHealthFactor(
829     address _collateralType,
830     uint256 _collateralValue,
831     uint256 _vaultDebt
832   ) external view returns (uint256 healthFactor);
833 
834   function liquidationBonus(uint256 _amount) external view returns (uint256 bonus);
835 
836   function applyLiquidationDiscount(uint256 _amount) external view returns (uint256 discountedAmount);
837 
838   function isHealthy(
839     address _collateralType,
840     uint256 _collateralValue,
841     uint256 _vaultDebt
842   ) external view returns (bool);
843 }
844 
845 // 
846 interface IVaultsCoreV1 {
847   event Opened(uint256 indexed vaultId, address indexed collateralType, address indexed owner);
848   event Deposited(uint256 indexed vaultId, uint256 amount, address indexed sender);
849   event Withdrawn(uint256 indexed vaultId, uint256 amount, address indexed sender);
850   event Borrowed(uint256 indexed vaultId, uint256 amount, address indexed sender);
851   event Repaid(uint256 indexed vaultId, uint256 amount, address indexed sender);
852   event Liquidated(
853     uint256 indexed vaultId,
854     uint256 debtRepaid,
855     uint256 collateralLiquidated,
856     address indexed owner,
857     address indexed sender
858   );
859 
860   event CumulativeRateUpdated(address indexed collateralType, uint256 elapsedTime, uint256 newCumulativeRate); //cumulative interest rate from deployment time T0
861 
862   event InsurancePaid(uint256 indexed vaultId, uint256 insuranceAmount, address indexed sender);
863 
864   function deposit(address _collateralType, uint256 _amount) external;
865 
866   function withdraw(uint256 _vaultId, uint256 _amount) external;
867 
868   function withdrawAll(uint256 _vaultId) external;
869 
870   function borrow(uint256 _vaultId, uint256 _amount) external;
871 
872   function repayAll(uint256 _vaultId) external;
873 
874   function repay(uint256 _vaultId, uint256 _amount) external;
875 
876   function liquidate(uint256 _vaultId) external;
877 
878   //Refresh
879   function initializeRates(address _collateralType) external;
880 
881   function refresh() external;
882 
883   function refreshCollateral(address collateralType) external;
884 
885   //upgrade
886   function upgrade(address _newVaultsCore) external;
887 
888   //Read only
889 
890   function a() external view returns (IAddressProviderV1);
891 
892   function availableIncome() external view returns (uint256);
893 
894   function cumulativeRates(address _collateralType) external view returns (uint256);
895 
896   function lastRefresh(address _collateralType) external view returns (uint256);
897 }
898 
899 // 
900 interface IWETH {
901   function deposit() external payable;
902 
903   function transfer(address to, uint256 value) external returns (bool);
904 
905   function withdraw(uint256 wad) external;
906 }
907 
908 // 
909 interface IGovernorAlpha {
910     /// @notice Possible states that a proposal may be in
911     enum ProposalState {
912         Active,
913         Canceled,
914         Defeated,
915         Succeeded,
916         Queued,
917         Expired,
918         Executed
919     }
920 
921     struct Proposal {
922         // Unique id for looking up a proposal
923         uint256 id;
924 
925         // Creator of the proposal
926         address proposer;
927 
928         // The timestamp that the proposal will be available for execution, set once the vote succeeds
929         uint256 eta;
930 
931         // the ordered list of target addresses for calls to be made
932         address[] targets;
933 
934         // The ordered list of values (i.e. msg.value) to be passed to the calls to be made
935         uint256[] values;
936 
937         // The ordered list of function signatures to be called
938         string[] signatures;
939 
940         // The ordered list of calldata to be passed to each call
941         bytes[] calldatas;
942 
943         // The timestamp at which voting begins: holders must delegate their votes prior to this timestamp
944         uint256 startTime;
945 
946         // The timestamp at which voting ends: votes must be cast prior to this timestamp
947         uint endTime;
948 
949         // Current number of votes in favor of this proposal
950         uint256 forVotes;
951 
952         // Current number of votes in opposition to this proposal
953         uint256 againstVotes;
954 
955         // Flag marking whether the proposal has been canceled
956         bool canceled;
957 
958         // Flag marking whether the proposal has been executed
959         bool executed;
960 
961         // Receipts of ballots for the entire set of voters
962         mapping (address => Receipt) receipts;
963     }
964 
965     /// @notice Ballot receipt record for a voter
966     struct Receipt {
967         // Whether or not a vote has been cast
968         bool hasVoted;
969 
970         // Whether or not the voter supports the proposal
971         bool support;
972 
973         // The number of votes the voter had, which were cast
974         uint votes;
975     }
976 
977     /// @notice An event emitted when a new proposal is created
978     event ProposalCreated(uint256 id, address proposer, address[] targets, uint256[] values, string[] signatures, bytes[] calldatas, uint startTime, uint endTime, string description);
979 
980     /// @notice An event emitted when a vote has been cast on a proposal
981     event VoteCast(address voter, uint256 proposalId, bool support, uint256 votes);
982 
983     /// @notice An event emitted when a proposal has been canceled
984     event ProposalCanceled(uint256 id);
985 
986     /// @notice An event emitted when a proposal has been queued in the Timelock
987     event ProposalQueued(uint256 id, uint256 eta);
988 
989     /// @notice An event emitted when a proposal has been executed in the Timelock
990     event ProposalExecuted(uint256 id);
991 
992     function propose(address[] memory targets, uint256[] memory values, string[] memory signatures, bytes[] memory calldatas, string memory description, uint256 endTime) external returns (uint);
993 
994     function queue(uint256 proposalId) external;
995 
996     function execute(uint256 proposalId) external payable;
997 
998     function cancel(uint256 proposalId) external;
999 
1000     function castVote(uint256 proposalId, bool support) external;
1001 
1002     function getActions(uint256 proposalId) external view returns (address[] memory targets, uint256[] memory values, string[] memory signatures, bytes[] memory calldatas);
1003 
1004     function getReceipt(uint256 proposalId, address voter) external view returns (Receipt memory);
1005 
1006     function state(uint proposalId) external view returns (ProposalState);
1007 
1008     function quorumVotes() external view returns (uint256);
1009 
1010     function proposalThreshold() external view returns (uint256);
1011 }
1012 
1013 // 
1014 interface ITimelock {
1015   event NewAdmin(address indexed newAdmin);
1016   event NewPendingAdmin(address indexed newPendingAdmin);
1017   event NewDelay(uint256 indexed newDelay);
1018   event CancelTransaction(
1019     bytes32 indexed txHash,
1020     address indexed target,
1021     uint256 value,
1022     string signature,
1023     bytes data,
1024     uint256 eta
1025   );
1026   event ExecuteTransaction(
1027     bytes32 indexed txHash,
1028     address indexed target,
1029     uint256 value,
1030     string signature,
1031     bytes data,
1032     uint256 eta
1033   );
1034   event QueueTransaction(
1035     bytes32 indexed txHash,
1036     address indexed target,
1037     uint256 value,
1038     string signature,
1039     bytes data,
1040     uint256 eta
1041   );
1042 
1043   function acceptAdmin() external;
1044 
1045   function queueTransaction(
1046     address target,
1047     uint256 value,
1048     string calldata signature,
1049     bytes calldata data,
1050     uint256 eta
1051   ) external returns (bytes32);
1052 
1053   function cancelTransaction(
1054     address target,
1055     uint256 value,
1056     string calldata signature,
1057     bytes calldata data,
1058     uint256 eta
1059   ) external;
1060 
1061   function executeTransaction(
1062     address target,
1063     uint256 value,
1064     string calldata signature,
1065     bytes calldata data,
1066     uint256 eta
1067   ) external payable returns (bytes memory);
1068 
1069   function delay() external view returns (uint256);
1070 
1071   function GRACE_PERIOD() external view returns (uint256);
1072 
1073   function queuedTransactions(bytes32 hash) external view returns (bool);
1074 }
1075 
1076 // 
1077 interface IVotingEscrow {
1078   enum LockAction { CREATE_LOCK, INCREASE_LOCK_AMOUNT, INCREASE_LOCK_TIME }
1079 
1080   struct LockedBalance {
1081     uint256 amount;
1082     uint256 end;
1083   }
1084 
1085   /** Shared Events */
1086   event Deposit(address indexed provider, uint256 value, uint256 locktime, LockAction indexed action, uint256 ts);
1087   event Withdraw(address indexed provider, uint256 value, uint256 ts);
1088   event Expired();
1089 
1090   function createLock(uint256 _value, uint256 _unlockTime) external;
1091 
1092   function increaseLockAmount(uint256 _value) external;
1093 
1094   function increaseLockLength(uint256 _unlockTime) external;
1095 
1096   function withdraw() external;
1097 
1098   function expireContract() external;
1099 
1100   function name() external view returns (string memory);
1101 
1102   function symbol() external view returns (string memory);
1103 
1104   function decimals() external view returns (uint256);
1105 
1106   function balanceOf(address _owner) external view returns (uint256);
1107 
1108   function balanceOfAt(address _owner, uint256 _blockTime) external view returns (uint256);
1109 
1110   function stakingToken() external view returns (IERC20);
1111 }
1112 
1113 // 
1114 interface IMIMO is IERC20 {
1115 
1116   function burn(address account, uint256 amount) external;
1117   
1118   function mint(address account, uint256 amount) external;
1119 
1120 }
1121 
1122 // 
1123 interface ISupplyMiner {
1124 
1125   function baseDebtChanged(address user, uint256 newBaseDebt) external;
1126 }
1127 
1128 // 
1129 interface IDebtNotifier {
1130 
1131   function debtChanged(uint256 _vaultId) external;
1132 
1133   function setCollateralSupplyMiner(address collateral, ISupplyMiner supplyMiner) external;
1134 
1135   function a() external view returns (IGovernanceAddressProvider);
1136 
1137 	function collateralSupplyMinerMapping(address collateral) external view returns (ISupplyMiner);
1138 }
1139 
1140 // 
1141 interface IGovernanceAddressProvider {
1142   function setParallelAddressProvider(IAddressProvider _parallel) external;
1143 
1144   function setMIMO(IMIMO _mimo) external;
1145 
1146   function setDebtNotifier(IDebtNotifier _debtNotifier) external;
1147 
1148   function setGovernorAlpha(IGovernorAlpha _governorAlpha) external;
1149 
1150   function setTimelock(ITimelock _timelock) external;
1151 
1152   function setVotingEscrow(IVotingEscrow _votingEscrow) external;
1153 
1154   function controller() external view returns (IAccessController);
1155 
1156   function parallel() external view returns (IAddressProvider);
1157 
1158   function mimo() external view returns (IMIMO);
1159 
1160   function debtNotifier() external view returns (IDebtNotifier);
1161 
1162   function governorAlpha() external view returns (IGovernorAlpha);
1163 
1164   function timelock() external view returns (ITimelock);
1165 
1166   function votingEscrow() external view returns (IVotingEscrow);
1167 }
1168 
1169 // 
1170 interface IVaultsCore {
1171   event Opened(uint256 indexed vaultId, address indexed collateralType, address indexed owner);
1172   event Deposited(uint256 indexed vaultId, uint256 amount, address indexed sender);
1173   event Withdrawn(uint256 indexed vaultId, uint256 amount, address indexed sender);
1174   event Borrowed(uint256 indexed vaultId, uint256 amount, address indexed sender);
1175   event Repaid(uint256 indexed vaultId, uint256 amount, address indexed sender);
1176   event Liquidated(
1177     uint256 indexed vaultId,
1178     uint256 debtRepaid,
1179     uint256 collateralLiquidated,
1180     address indexed owner,
1181     address indexed sender
1182   );
1183 
1184   event InsurancePaid(uint256 indexed vaultId, uint256 insuranceAmount, address indexed sender);
1185 
1186   function deposit(address _collateralType, uint256 _amount) external;
1187 
1188   function depositETH() external payable;
1189 
1190   function depositByVaultId(uint256 _vaultId, uint256 _amount) external;
1191 
1192   function depositETHByVaultId(uint256 _vaultId) external payable;
1193 
1194   function depositAndBorrow(
1195     address _collateralType,
1196     uint256 _depositAmount,
1197     uint256 _borrowAmount
1198   ) external;
1199 
1200   function depositETHAndBorrow(uint256 _borrowAmount) external payable;
1201 
1202   function withdraw(uint256 _vaultId, uint256 _amount) external;
1203 
1204   function withdrawETH(uint256 _vaultId, uint256 _amount) external;
1205 
1206   function borrow(uint256 _vaultId, uint256 _amount) external;
1207 
1208   function repayAll(uint256 _vaultId) external;
1209 
1210   function repay(uint256 _vaultId, uint256 _amount) external;
1211 
1212   function liquidate(uint256 _vaultId) external;
1213 
1214   function liquidatePartial(uint256 _vaultId, uint256 _amount) external;
1215 
1216   function upgrade(address payable _newVaultsCore) external;
1217 
1218   function acceptUpgrade(address payable _oldVaultsCore) external;
1219 
1220   function setDebtNotifier(IDebtNotifier _debtNotifier) external;
1221 
1222   //Read only
1223   function a() external view returns (IAddressProvider);
1224 
1225   function WETH() external view returns (IWETH);
1226 
1227   function debtNotifier() external view returns (IDebtNotifier);
1228 
1229   function state() external view returns (IVaultsCoreState);
1230 
1231   function cumulativeRates(address _collateralType) external view returns (uint256);
1232 }
1233 
1234 // 
1235 interface IAddressProviderV1 {
1236   function setAccessController(IAccessController _controller) external;
1237 
1238   function setConfigProvider(IConfigProviderV1 _config) external;
1239 
1240   function setVaultsCore(IVaultsCoreV1 _core) external;
1241 
1242   function setStableX(ISTABLEX _stablex) external;
1243 
1244   function setRatesManager(IRatesManager _ratesManager) external;
1245 
1246   function setPriceFeed(IPriceFeed _priceFeed) external;
1247 
1248   function setLiquidationManager(ILiquidationManagerV1 _liquidationManager) external;
1249 
1250   function setVaultsDataProvider(IVaultsDataProvider _vaultsData) external;
1251 
1252   function setFeeDistributor(IFeeDistributor _feeDistributor) external;
1253 
1254   function controller() external view returns (IAccessController);
1255 
1256   function config() external view returns (IConfigProviderV1);
1257 
1258   function core() external view returns (IVaultsCoreV1);
1259 
1260   function stablex() external view returns (ISTABLEX);
1261 
1262   function ratesManager() external view returns (IRatesManager);
1263 
1264   function priceFeed() external view returns (IPriceFeed);
1265 
1266   function liquidationManager() external view returns (ILiquidationManagerV1);
1267 
1268   function vaultsData() external view returns (IVaultsDataProvider);
1269 
1270   function feeDistributor() external view returns (IFeeDistributor);
1271 }
1272 
1273 // 
1274 interface IVaultsCoreState {
1275   event CumulativeRateUpdated(address indexed collateralType, uint256 elapsedTime, uint256 newCumulativeRate); //cumulative interest rate from deployment time T0
1276 
1277   function initializeRates(address _collateralType) external;
1278 
1279   function refresh() external;
1280 
1281   function refreshCollateral(address collateralType) external;
1282 
1283   function syncState(IVaultsCoreState _stateAddress) external;
1284 
1285   function syncStateFromV1(IVaultsCoreV1 _core) external;
1286 
1287   //Read only
1288   function a() external view returns (IAddressProvider);
1289 
1290   function availableIncome() external view returns (uint256);
1291 
1292   function cumulativeRates(address _collateralType) external view returns (uint256);
1293 
1294   function lastRefresh(address _collateralType) external view returns (uint256);
1295 
1296   function synced() external view returns (bool);
1297 }
1298 
1299 // 
1300 interface IConfigProvider {
1301   struct CollateralConfig {
1302     address collateralType;
1303     uint256 debtLimit;
1304     uint256 liquidationRatio;
1305     uint256 minCollateralRatio;
1306     uint256 borrowRate;
1307     uint256 originationFee;
1308     uint256 liquidationBonus;
1309     uint256 liquidationFee;
1310   }
1311 
1312   event CollateralUpdated(
1313     address indexed collateralType,
1314     uint256 debtLimit,
1315     uint256 liquidationRatio,
1316     uint256 minCollateralRatio,
1317     uint256 borrowRate,
1318     uint256 originationFee,
1319     uint256 liquidationBonus,
1320     uint256 liquidationFee
1321   );
1322   event CollateralRemoved(address indexed collateralType);
1323 
1324   function setCollateralConfig(
1325     address _collateralType,
1326     uint256 _debtLimit,
1327     uint256 _liquidationRatio,
1328     uint256 _minCollateralRatio,
1329     uint256 _borrowRate,
1330     uint256 _originationFee,
1331     uint256 _liquidationBonus,
1332     uint256 _liquidationFee
1333   ) external;
1334 
1335   function removeCollateral(address _collateralType) external;
1336 
1337   function setCollateralDebtLimit(address _collateralType, uint256 _debtLimit) external;
1338 
1339   function setCollateralLiquidationRatio(address _collateralType, uint256 _liquidationRatio) external;
1340 
1341   function setCollateralMinCollateralRatio(address _collateralType, uint256 _minCollateralRatio) external;
1342 
1343   function setCollateralBorrowRate(address _collateralType, uint256 _borrowRate) external;
1344 
1345   function setCollateralOriginationFee(address _collateralType, uint256 _originationFee) external;
1346 
1347   function setCollateralLiquidationBonus(address _collateralType, uint256 _liquidationBonus) external;
1348 
1349   function setCollateralLiquidationFee(address _collateralType, uint256 _liquidationFee) external;
1350 
1351   function setMinVotingPeriod(uint256 _minVotingPeriod) external;
1352 
1353   function setMaxVotingPeriod(uint256 _maxVotingPeriod) external;
1354 
1355   function setVotingQuorum(uint256 _votingQuorum) external;
1356 
1357   function setProposalThreshold(uint256 _proposalThreshold) external;
1358 
1359   function a() external view returns (IAddressProvider);
1360 
1361   function collateralConfigs(uint256 _id) external view returns (CollateralConfig memory);
1362 
1363   function collateralIds(address _collateralType) external view returns (uint256);
1364 
1365   function numCollateralConfigs() external view returns (uint256);
1366 
1367   function minVotingPeriod() external view returns (uint256);
1368 
1369   function maxVotingPeriod() external view returns (uint256);
1370 
1371   function votingQuorum() external view returns (uint256);
1372 
1373   function proposalThreshold() external view returns (uint256);
1374 
1375   function collateralDebtLimit(address _collateralType) external view returns (uint256);
1376 
1377   function collateralLiquidationRatio(address _collateralType) external view returns (uint256);
1378 
1379   function collateralMinCollateralRatio(address _collateralType) external view returns (uint256);
1380 
1381   function collateralBorrowRate(address _collateralType) external view returns (uint256);
1382 
1383   function collateralOriginationFee(address _collateralType) external view returns (uint256);
1384 
1385   function collateralLiquidationBonus(address _collateralType) external view returns (uint256);
1386 
1387   function collateralLiquidationFee(address _collateralType) external view returns (uint256);
1388 }
1389 
1390 // 
1391 interface IGenericMiner {
1392 
1393   struct UserInfo {
1394     uint256 stake;
1395     uint256 accAmountPerShare; // User's accAmountPerShare
1396   }
1397 
1398   /// @dev This emit when a users' productivity has changed
1399   /// It emits with the user's address and the the value after the change.
1400   event StakeIncreased(address indexed user, uint256 stake);
1401 
1402   /// @dev This emit when a users' productivity has changed
1403   /// It emits with the user's address and the the value after the change.
1404   event StakeDecreased(address indexed user, uint256 stake);
1405 
1406 
1407   function releaseMIMO(address _user) external;
1408 
1409   function a() external view returns (IGovernanceAddressProvider);
1410   function stake(address _user) external view returns (uint256);
1411   function pendingMIMO(address _user) external view returns (uint256);
1412   
1413   function totalStake() external view returns (uint256);
1414   function userInfo(address _user) external view returns (UserInfo memory);
1415 }
1416 
1417 //
1418 /*
1419     GenericMiner is based on ERC2917. https://github.com/gnufoo/ERC2917-Proposal
1420 
1421     The Objective of GenericMiner is to implement a decentralized staking mechanism, which calculates _users' share
1422     by accumulating stake * time. And calculates _users revenue from anytime t0 to t1 by the formula below:
1423 
1424         user_accumulated_stake(time1) - user_accumulated_stake(time0)
1425        _____________________________________________________________________________  * (gross_stake(t1) - gross_stake(t0))
1426        total_accumulated_stake(time1) - total_accumulated_stake(time0)
1427 
1428 */
1429 contract GenericMiner is IGenericMiner {
1430   using SafeMath for uint256;
1431   using WadRayMath for uint256;
1432 
1433   mapping(address => UserInfo) private _users;
1434 
1435   uint256 public override totalStake;
1436   IGovernanceAddressProvider public override a;
1437 
1438   uint256 private _balanceTracker;
1439   uint256 private _accAmountPerShare;
1440 
1441   constructor(IGovernanceAddressProvider _addresses) public {
1442     require(address(_addresses) != address(0));
1443     a = _addresses;
1444   }
1445 
1446   /**
1447     Releases the outstanding MIMO balance to the user.
1448     @param _user the address of the user for which the MIMO tokens will be released.
1449   */
1450   function releaseMIMO(address _user) public override {
1451     UserInfo storage userInfo = _users[_user];
1452     _refresh();
1453     uint256 pending = userInfo.stake.rayMul(_accAmountPerShare.sub(userInfo.accAmountPerShare));
1454     _balanceTracker = _balanceTracker.sub(pending);
1455     userInfo.accAmountPerShare = _accAmountPerShare;
1456     require(a.mimo().transfer(_user, pending));
1457   }
1458 
1459   /**
1460     Returns the number of tokens a user has staked.
1461     @param _user the address of the user.
1462     @return number of staked tokens
1463   */
1464   function stake(address _user) public view override returns (uint256) {
1465     return _users[_user].stake;
1466   }
1467 
1468   /**
1469     Returns the number of tokens a user can claim via `releaseMIMO`.
1470     @param _user the address of the user.
1471     @return number of MIMO tokens that the user can claim
1472   */
1473   function pendingMIMO(address _user) public view override returns (uint256) {
1474     uint256 currentBalance = a.mimo().balanceOf(address(this));
1475     uint256 reward = currentBalance.sub(_balanceTracker);
1476     uint256 accAmountPerShare = _accAmountPerShare.add(reward.rayDiv(totalStake));
1477 
1478     return _users[_user].stake.rayMul(accAmountPerShare.sub(_users[_user].accAmountPerShare));
1479   }
1480 
1481   /**
1482     Returns the userInfo stored of a user.
1483     @param _user the address of the user.
1484     @return `struct UserInfo {
1485       uint256 stake;
1486       uint256 rewardDebt;
1487     }`
1488   **/
1489   function userInfo(address _user) public view override returns (UserInfo memory) {
1490     return _users[_user];
1491   }
1492 
1493   /**
1494     Refreshes the global state and subsequently decreases the stake a user has.
1495     This is an internal call and meant to be called within derivative contracts.
1496     @param user the address of the user
1497     @param value the amount by which the stake will be reduced
1498   */
1499   function _decreaseStake(address user, uint256 value) internal {
1500     require(value > 0, "STAKE_MUST_BE_GREATER_THAN_ZERO"); //TODO cleanup error message
1501 
1502     UserInfo storage userInfo = _users[user];
1503     require(userInfo.stake >= value, "INSUFFICIENT_STAKE_FOR_USER"); //TODO cleanup error message
1504     _refresh();
1505     uint256 pending = userInfo.stake.rayMul(_accAmountPerShare.sub(userInfo.accAmountPerShare));
1506     _balanceTracker = _balanceTracker.sub(pending);
1507     userInfo.stake = userInfo.stake.sub(value);
1508     userInfo.accAmountPerShare = _accAmountPerShare;
1509     totalStake = totalStake.sub(value);
1510 
1511     require(a.mimo().transfer(user, pending));
1512     emit StakeDecreased(user, value);
1513   }
1514 
1515   /**
1516     Refreshes the global state and subsequently increases a user's stake.
1517     This is an internal call and meant to be called within derivative contracts.
1518     @param user the address of the user
1519     @param value the amount by which the stake will be increased
1520   */
1521   function _increaseStake(address user, uint256 value) internal {
1522     require(value > 0, "STAKE_MUST_BE_GREATER_THAN_ZERO"); //TODO cleanup error message
1523 
1524     UserInfo storage userInfo = _users[user];
1525     _refresh();
1526 
1527     uint256 pending;
1528     if (userInfo.stake > 0) {
1529       pending = userInfo.stake.rayMul(_accAmountPerShare.sub(userInfo.accAmountPerShare));
1530       _balanceTracker = _balanceTracker.sub(pending);
1531     }
1532 
1533     totalStake = totalStake.add(value);
1534     userInfo.stake = userInfo.stake.add(value);
1535     userInfo.accAmountPerShare = _accAmountPerShare;
1536 
1537     if (pending > 0) {
1538       require(a.mimo().transfer(user, pending));
1539     }
1540 
1541     emit StakeIncreased(user, value);
1542   }
1543 
1544   /**
1545     Refreshes the global state and subsequently updates a user's stake.
1546     This is an internal call and meant to be called within derivative contracts.
1547     @param user the address of the user
1548     @param stake the new amount of stake for the user
1549   */
1550   function _updateStake(address user, uint256 stake) internal returns (bool) {
1551     uint256 oldStake = _users[user].stake;
1552     if (stake > oldStake) {
1553       _increaseStake(user, stake.sub(oldStake));
1554     }
1555     if (stake < oldStake) {
1556       _decreaseStake(user, oldStake.sub(stake));
1557     }
1558   }
1559 
1560   /**
1561     Internal read function to calculate the number of MIMO tokens that
1562     have accumulated since the last token release.
1563     @dev This is an internal call and meant to be called within derivative contracts.
1564     @return newly accumulated token balance
1565   */
1566   function _newTokensReceived() internal view returns (uint256) {
1567     return a.mimo().balanceOf(address(this)).sub(_balanceTracker);
1568   }
1569 
1570   /**
1571     Updates the internal state variables after accounting for newly received MIMO tokens.
1572   */
1573   function _refresh() internal {
1574     if (totalStake == 0) {
1575       return;
1576     }
1577     uint256 currentBalance = a.mimo().balanceOf(address(this));
1578     uint256 reward = currentBalance.sub(_balanceTracker);
1579     _balanceTracker = currentBalance;
1580 
1581     _accAmountPerShare = _accAmountPerShare.add(reward.rayDiv(totalStake));
1582   }
1583 }
1584 
1585 // 
1586 interface IDemandMiner {
1587 
1588   function deposit(uint256 amount) external;
1589 
1590   function withdraw(uint256 amount) external;
1591 
1592   function token() external view returns (IERC20);
1593 }
1594 
1595 // 
1596 contract DemandMiner is IDemandMiner, GenericMiner {
1597   using SafeMath for uint256;
1598   using SafeERC20 for IERC20;
1599 
1600   IERC20 public override token;
1601 
1602   constructor(IGovernanceAddressProvider _addresses, IERC20 _token) public GenericMiner(_addresses) {
1603     require(address(_token) != address(0));
1604     require(address(_token) != address(_addresses.mimo()));
1605     token = _token;
1606   }
1607 
1608   /**
1609     Deposit an ERC20 pool token for staking
1610     @dev this function uses `transferFrom()` and requires pre-approval via `approve()` on the ERC20.
1611     @param amount the amount of tokens to be deposited. Unit is in WEI.
1612   **/
1613   function deposit(uint256 amount) public override {
1614     token.safeTransferFrom(msg.sender, address(this), amount);
1615     _increaseStake(msg.sender, amount);
1616   }
1617 
1618   /**
1619     Withdraw staked ERC20 pool tokens. Will fail if user does not have enough tokens staked.
1620     @param amount the amount of tokens to be withdrawn. Unit is in WEI.
1621   **/
1622   function withdraw(uint256 amount) public override {
1623     token.safeTransfer(msg.sender, amount);
1624     _decreaseStake(msg.sender, amount);
1625   }
1626 }