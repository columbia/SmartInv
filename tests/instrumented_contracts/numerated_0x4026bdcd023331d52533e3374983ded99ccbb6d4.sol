1 // SPDX-License-Identifier: MIT
2 
3 pragma experimental ABIEncoderV2;
4 pragma solidity 0.6.12;
5 
6 
7 // 
8 /**
9  * @dev Interface of the ERC20 standard as defined in the EIP.
10  */
11 interface IERC20 {
12     /**
13      * @dev Returns the amount of tokens in existence.
14      */
15     function totalSupply() external view returns (uint256);
16 
17     /**
18      * @dev Returns the amount of tokens owned by `account`.
19      */
20     function balanceOf(address account) external view returns (uint256);
21 
22     /**
23      * @dev Moves `amount` tokens from the caller's account to `recipient`.
24      *
25      * Returns a boolean value indicating whether the operation succeeded.
26      *
27      * Emits a {Transfer} event.
28      */
29     function transfer(address recipient, uint256 amount) external returns (bool);
30 
31     /**
32      * @dev Returns the remaining number of tokens that `spender` will be
33      * allowed to spend on behalf of `owner` through {transferFrom}. This is
34      * zero by default.
35      *
36      * This value changes when {approve} or {transferFrom} are called.
37      */
38     function allowance(address owner, address spender) external view returns (uint256);
39 
40     /**
41      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
42      *
43      * Returns a boolean value indicating whether the operation succeeded.
44      *
45      * IMPORTANT: Beware that changing an allowance with this method brings the risk
46      * that someone may use both the old and the new allowance by unfortunate
47      * transaction ordering. One possible solution to mitigate this race
48      * condition is to first reduce the spender's allowance to 0 and set the
49      * desired value afterwards:
50      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
51      *
52      * Emits an {Approval} event.
53      */
54     function approve(address spender, uint256 amount) external returns (bool);
55 
56     /**
57      * @dev Moves `amount` tokens from `sender` to `recipient` using the
58      * allowance mechanism. `amount` is then deducted from the caller's
59      * allowance.
60      *
61      * Returns a boolean value indicating whether the operation succeeded.
62      *
63      * Emits a {Transfer} event.
64      */
65     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
66 
67     /**
68      * @dev Emitted when `value` tokens are moved from one account (`from`) to
69      * another (`to`).
70      *
71      * Note that `value` may be zero.
72      */
73     event Transfer(address indexed from, address indexed to, uint256 value);
74 
75     /**
76      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
77      * a call to {approve}. `value` is the new allowance.
78      */
79     event Approval(address indexed owner, address indexed spender, uint256 value);
80 }
81 
82 // 
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
448 /**
449  * @dev Contract module that helps prevent reentrant calls to a function.
450  *
451  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
452  * available, which can be applied to functions to make sure there are no nested
453  * (reentrant) calls to them.
454  *
455  * Note that because there is a single `nonReentrant` guard, functions marked as
456  * `nonReentrant` may not call one another. This can be worked around by making
457  * those functions `private`, and then adding `external` `nonReentrant` entry
458  * points to them.
459  *
460  * TIP: If you would like to learn more about reentrancy and alternative ways
461  * to protect against it, check out our blog post
462  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
463  */
464 contract ReentrancyGuard {
465     // Booleans are more expensive than uint256 or any type that takes up a full
466     // word because each write operation emits an extra SLOAD to first read the
467     // slot's contents, replace the bits taken up by the boolean, and then write
468     // back. This is the compiler's defense against contract upgrades and
469     // pointer aliasing, and it cannot be disabled.
470 
471     // The values being non-zero value makes deployment a bit more expensive,
472     // but in exchange the refund on every call to nonReentrant will be lower in
473     // amount. Since refunds are capped to a percentage of the total
474     // transaction's gas, it is best to keep them low in cases like this one, to
475     // increase the likelihood of the full refund coming into effect.
476     uint256 private constant _NOT_ENTERED = 1;
477     uint256 private constant _ENTERED = 2;
478 
479     uint256 private _status;
480 
481     constructor () internal {
482         _status = _NOT_ENTERED;
483     }
484 
485     /**
486      * @dev Prevents a contract from calling itself, directly or indirectly.
487      * Calling a `nonReentrant` function from another `nonReentrant`
488      * function is not supported. It is possible to prevent this from happening
489      * by making the `nonReentrant` function external, and make it call a
490      * `private` function that does the actual work.
491      */
492     modifier nonReentrant() {
493         // On the first call to nonReentrant, _notEntered will be true
494         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
495 
496         // Any calls to nonReentrant after this point will fail
497         _status = _ENTERED;
498 
499         _;
500 
501         // By storing the original value once again, a refund is triggered (see
502         // https://eips.ethereum.org/EIPS/eip-2200)
503         _status = _NOT_ENTERED;
504     }
505 }
506 
507 // 
508 /******************
509 @title WadRayMath library
510 @author Aave
511 @dev Provides mul and div function for wads (decimal numbers with 18 digits precision) and rays (decimals with 27 digits)
512  */
513 library WadRayMath {
514   using SafeMath for uint256;
515 
516   uint256 internal constant _WAD = 1e18;
517   uint256 internal constant _HALF_WAD = _WAD / 2;
518 
519   uint256 internal constant _RAY = 1e27;
520   uint256 internal constant _HALF_RAY = _RAY / 2;
521 
522   uint256 internal constant _WAD_RAY_RATIO = 1e9;
523 
524   function ray() internal pure returns (uint256) {
525     return _RAY;
526   }
527 
528   function wad() internal pure returns (uint256) {
529     return _WAD;
530   }
531 
532   function halfRay() internal pure returns (uint256) {
533     return _HALF_RAY;
534   }
535 
536   function halfWad() internal pure returns (uint256) {
537     return _HALF_WAD;
538   }
539 
540   function wadMul(uint256 a, uint256 b) internal pure returns (uint256) {
541     return _HALF_WAD.add(a.mul(b)).div(_WAD);
542   }
543 
544   function wadDiv(uint256 a, uint256 b) internal pure returns (uint256) {
545     uint256 halfB = b / 2;
546 
547     return halfB.add(a.mul(_WAD)).div(b);
548   }
549 
550   function rayMul(uint256 a, uint256 b) internal pure returns (uint256) {
551     return _HALF_RAY.add(a.mul(b)).div(_RAY);
552   }
553 
554   function rayDiv(uint256 a, uint256 b) internal pure returns (uint256) {
555     uint256 halfB = b / 2;
556 
557     return halfB.add(a.mul(_RAY)).div(b);
558   }
559 
560   function rayToWad(uint256 a) internal pure returns (uint256) {
561     uint256 halfRatio = _WAD_RAY_RATIO / 2;
562 
563     return halfRatio.add(a).div(_WAD_RAY_RATIO);
564   }
565 
566   function wadToRay(uint256 a) internal pure returns (uint256) {
567     return a.mul(_WAD_RAY_RATIO);
568   }
569 
570   /**
571    * @dev calculates x^n, in ray. The code uses the ModExp precompile
572    * @param x base
573    * @param n exponent
574    * @return z = x^n, in ray
575    */
576   function rayPow(uint256 x, uint256 n) internal pure returns (uint256 z) {
577     z = n % 2 != 0 ? x : _RAY;
578 
579     for (n /= 2; n != 0; n /= 2) {
580       x = rayMul(x, x);
581 
582       if (n % 2 != 0) {
583         z = rayMul(z, x);
584       }
585     }
586   }
587 }
588 
589 // 
590 interface IAccessController {
591   event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
592   event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
593   event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
594 
595   function grantRole(bytes32 role, address account) external;
596 
597   function revokeRole(bytes32 role, address account) external;
598 
599   function renounceRole(bytes32 role, address account) external;
600 
601   function MANAGER_ROLE() external view returns (bytes32);
602 
603   function MINTER_ROLE() external view returns (bytes32);
604 
605   function hasRole(bytes32 role, address account) external view returns (bool);
606 
607   function getRoleMemberCount(bytes32 role) external view returns (uint256);
608 
609   function getRoleMember(bytes32 role, uint256 index) external view returns (address);
610 
611   function getRoleAdmin(bytes32 role) external view returns (bytes32);
612 }
613 
614 // 
615 interface IConfigProvider {
616   struct CollateralConfig {
617     address collateralType;
618     uint256 debtLimit;
619     uint256 liquidationRatio;
620     uint256 minCollateralRatio;
621     uint256 borrowRate;
622     uint256 originationFee;
623     uint256 liquidationBonus;
624     uint256 liquidationFee;
625   }
626 
627   event CollateralUpdated(
628     address indexed collateralType,
629     uint256 debtLimit,
630     uint256 liquidationRatio,
631     uint256 minCollateralRatio,
632     uint256 borrowRate,
633     uint256 originationFee,
634     uint256 liquidationBonus,
635     uint256 liquidationFee
636   );
637   event CollateralRemoved(address indexed collateralType);
638 
639   function setCollateralConfig(
640     address _collateralType,
641     uint256 _debtLimit,
642     uint256 _liquidationRatio,
643     uint256 _minCollateralRatio,
644     uint256 _borrowRate,
645     uint256 _originationFee,
646     uint256 _liquidationBonus,
647     uint256 _liquidationFee
648   ) external;
649 
650   function removeCollateral(address _collateralType) external;
651 
652   function setCollateralDebtLimit(address _collateralType, uint256 _debtLimit) external;
653 
654   function setCollateralLiquidationRatio(address _collateralType, uint256 _liquidationRatio) external;
655 
656   function setCollateralMinCollateralRatio(address _collateralType, uint256 _minCollateralRatio) external;
657 
658   function setCollateralBorrowRate(address _collateralType, uint256 _borrowRate) external;
659 
660   function setCollateralOriginationFee(address _collateralType, uint256 _originationFee) external;
661 
662   function setCollateralLiquidationBonus(address _collateralType, uint256 _liquidationBonus) external;
663 
664   function setCollateralLiquidationFee(address _collateralType, uint256 _liquidationFee) external;
665 
666   function setMinVotingPeriod(uint256 _minVotingPeriod) external;
667 
668   function setMaxVotingPeriod(uint256 _maxVotingPeriod) external;
669 
670   function setVotingQuorum(uint256 _votingQuorum) external;
671 
672   function setProposalThreshold(uint256 _proposalThreshold) external;
673 
674   function a() external view returns (IAddressProvider);
675 
676   function collateralConfigs(uint256 _id) external view returns (CollateralConfig memory);
677 
678   function collateralIds(address _collateralType) external view returns (uint256);
679 
680   function numCollateralConfigs() external view returns (uint256);
681 
682   function minVotingPeriod() external view returns (uint256);
683 
684   function maxVotingPeriod() external view returns (uint256);
685 
686   function votingQuorum() external view returns (uint256);
687 
688   function proposalThreshold() external view returns (uint256);
689 
690   function collateralDebtLimit(address _collateralType) external view returns (uint256);
691 
692   function collateralLiquidationRatio(address _collateralType) external view returns (uint256);
693 
694   function collateralMinCollateralRatio(address _collateralType) external view returns (uint256);
695 
696   function collateralBorrowRate(address _collateralType) external view returns (uint256);
697 
698   function collateralOriginationFee(address _collateralType) external view returns (uint256);
699 
700   function collateralLiquidationBonus(address _collateralType) external view returns (uint256);
701 
702   function collateralLiquidationFee(address _collateralType) external view returns (uint256);
703 }
704 
705 // 
706 interface ISTABLEX is IERC20 {
707   function mint(address account, uint256 amount) external;
708 
709   function burn(address account, uint256 amount) external;
710 
711   function a() external view returns (IAddressProvider);
712 }
713 
714 // 
715 interface AggregatorV3Interface {
716   function decimals() external view returns (uint8);
717 
718   function description() external view returns (string memory);
719 
720   function version() external view returns (uint256);
721 
722   function getRoundData(uint80 _roundId)
723     external
724     view
725     returns (
726       uint80 roundId,
727       int256 answer,
728       uint256 startedAt,
729       uint256 updatedAt,
730       uint80 answeredInRound
731     );
732 
733   function latestRoundData()
734     external
735     view
736     returns (
737       uint80 roundId,
738       int256 answer,
739       uint256 startedAt,
740       uint256 updatedAt,
741       uint80 answeredInRound
742     );
743 }
744 
745 // 
746 interface IPriceFeed {
747   event OracleUpdated(address indexed asset, address oracle, address sender);
748   event EurOracleUpdated(address oracle, address sender);
749 
750   function setAssetOracle(address _asset, address _oracle) external;
751 
752   function setEurOracle(address _oracle) external;
753 
754   function a() external view returns (IAddressProvider);
755 
756   function assetOracles(address _asset) external view returns (AggregatorV3Interface);
757 
758   function eurOracle() external view returns (AggregatorV3Interface);
759 
760   function getAssetPrice(address _asset) external view returns (uint256);
761 
762   function convertFrom(address _asset, uint256 _amount) external view returns (uint256);
763 
764   function convertTo(address _asset, uint256 _amount) external view returns (uint256);
765 }
766 
767 // 
768 interface IRatesManager {
769   function a() external view returns (IAddressProvider);
770 
771   //current annualized borrow rate
772   function annualizedBorrowRate(uint256 _currentBorrowRate) external pure returns (uint256);
773 
774   //uses current cumulative rate to calculate totalDebt based on baseDebt at time T0
775   function calculateDebt(uint256 _baseDebt, uint256 _cumulativeRate) external pure returns (uint256);
776 
777   //uses current cumulative rate to calculate baseDebt at time T0
778   function calculateBaseDebt(uint256 _debt, uint256 _cumulativeRate) external pure returns (uint256);
779 
780   //calculate a new cumulative rate
781   function calculateCumulativeRate(
782     uint256 _borrowRate,
783     uint256 _cumulativeRate,
784     uint256 _timeElapsed
785   ) external view returns (uint256);
786 }
787 
788 // 
789 interface ILiquidationManager {
790   function a() external view returns (IAddressProvider);
791 
792   function calculateHealthFactor(
793     uint256 _collateralValue,
794     uint256 _vaultDebt,
795     uint256 _minRatio
796   ) external view returns (uint256 healthFactor);
797 
798   function liquidationBonus(address _collateralType, uint256 _amount) external view returns (uint256 bonus);
799 
800   function applyLiquidationDiscount(address _collateralType, uint256 _amount)
801     external
802     view
803     returns (uint256 discountedAmount);
804 
805   function isHealthy(
806     uint256 _collateralValue,
807     uint256 _vaultDebt,
808     uint256 _minRatio
809   ) external view returns (bool);
810 }
811 
812 // 
813 interface IVaultsDataProvider {
814   struct Vault {
815     // borrowedType support USDX / PAR
816     address collateralType;
817     address owner;
818     uint256 collateralBalance;
819     uint256 baseDebt;
820     uint256 createdAt;
821   }
822 
823   //Write
824   function createVault(address _collateralType, address _owner) external returns (uint256);
825 
826   function setCollateralBalance(uint256 _id, uint256 _balance) external;
827 
828   function setBaseDebt(uint256 _id, uint256 _newBaseDebt) external;
829 
830   // Read
831   function a() external view returns (IAddressProvider);
832 
833   function baseDebt(address _collateralType) external view returns (uint256);
834 
835   function vaultCount() external view returns (uint256);
836 
837   function vaults(uint256 _id) external view returns (Vault memory);
838 
839   function vaultOwner(uint256 _id) external view returns (address);
840 
841   function vaultCollateralType(uint256 _id) external view returns (address);
842 
843   function vaultCollateralBalance(uint256 _id) external view returns (uint256);
844 
845   function vaultBaseDebt(uint256 _id) external view returns (uint256);
846 
847   function vaultId(address _collateralType, address _owner) external view returns (uint256);
848 
849   function vaultExists(uint256 _id) external view returns (bool);
850 
851   function vaultDebt(uint256 _vaultId) external view returns (uint256);
852 
853   function debt() external view returns (uint256);
854 
855   function collateralDebt(address _collateralType) external view returns (uint256);
856 }
857 
858 // 
859 interface IFeeDistributor {
860   event PayeeAdded(address indexed account, uint256 shares);
861   event FeeReleased(uint256 income, uint256 releasedAt);
862 
863   function release() external;
864 
865   function changePayees(address[] memory _payees, uint256[] memory _shares) external;
866 
867   function a() external view returns (IAddressProvider);
868 
869   function lastReleasedAt() external view returns (uint256);
870 
871   function getPayees() external view returns (address[] memory);
872 
873   function totalShares() external view returns (uint256);
874 
875   function shares(address payee) external view returns (uint256);
876 }
877 
878 // 
879 interface IAddressProvider {
880   function setAccessController(IAccessController _controller) external;
881 
882   function setConfigProvider(IConfigProvider _config) external;
883 
884   function setVaultsCore(IVaultsCore _core) external;
885 
886   function setStableX(ISTABLEX _stablex) external;
887 
888   function setRatesManager(IRatesManager _ratesManager) external;
889 
890   function setPriceFeed(IPriceFeed _priceFeed) external;
891 
892   function setLiquidationManager(ILiquidationManager _liquidationManager) external;
893 
894   function setVaultsDataProvider(IVaultsDataProvider _vaultsData) external;
895 
896   function setFeeDistributor(IFeeDistributor _feeDistributor) external;
897 
898   function controller() external view returns (IAccessController);
899 
900   function config() external view returns (IConfigProvider);
901 
902   function core() external view returns (IVaultsCore);
903 
904   function stablex() external view returns (ISTABLEX);
905 
906   function ratesManager() external view returns (IRatesManager);
907 
908   function priceFeed() external view returns (IPriceFeed);
909 
910   function liquidationManager() external view returns (ILiquidationManager);
911 
912   function vaultsData() external view returns (IVaultsDataProvider);
913 
914   function feeDistributor() external view returns (IFeeDistributor);
915 }
916 
917 // 
918 interface IConfigProviderV1 {
919   struct CollateralConfig {
920     address collateralType;
921     uint256 debtLimit;
922     uint256 minCollateralRatio;
923     uint256 borrowRate;
924     uint256 originationFee;
925   }
926 
927   event CollateralUpdated(
928     address indexed collateralType,
929     uint256 debtLimit,
930     uint256 minCollateralRatio,
931     uint256 borrowRate,
932     uint256 originationFee
933   );
934   event CollateralRemoved(address indexed collateralType);
935 
936   function setCollateralConfig(
937     address _collateralType,
938     uint256 _debtLimit,
939     uint256 _minCollateralRatio,
940     uint256 _borrowRate,
941     uint256 _originationFee
942   ) external;
943 
944   function removeCollateral(address _collateralType) external;
945 
946   function setCollateralDebtLimit(address _collateralType, uint256 _debtLimit) external;
947 
948   function setCollateralMinCollateralRatio(address _collateralType, uint256 _minCollateralRatio) external;
949 
950   function setCollateralBorrowRate(address _collateralType, uint256 _borrowRate) external;
951 
952   function setCollateralOriginationFee(address _collateralType, uint256 _originationFee) external;
953 
954   function setLiquidationBonus(uint256 _bonus) external;
955 
956   function a() external view returns (IAddressProviderV1);
957 
958   function collateralConfigs(uint256 _id) external view returns (CollateralConfig memory);
959 
960   function collateralIds(address _collateralType) external view returns (uint256);
961 
962   function numCollateralConfigs() external view returns (uint256);
963 
964   function liquidationBonus() external view returns (uint256);
965 
966   function collateralDebtLimit(address _collateralType) external view returns (uint256);
967 
968   function collateralMinCollateralRatio(address _collateralType) external view returns (uint256);
969 
970   function collateralBorrowRate(address _collateralType) external view returns (uint256);
971 
972   function collateralOriginationFee(address _collateralType) external view returns (uint256);
973 }
974 
975 // 
976 interface ILiquidationManagerV1 {
977   function a() external view returns (IAddressProviderV1);
978 
979   function calculateHealthFactor(
980     address _collateralType,
981     uint256 _collateralValue,
982     uint256 _vaultDebt
983   ) external view returns (uint256 healthFactor);
984 
985   function liquidationBonus(uint256 _amount) external view returns (uint256 bonus);
986 
987   function applyLiquidationDiscount(uint256 _amount) external view returns (uint256 discountedAmount);
988 
989   function isHealthy(
990     address _collateralType,
991     uint256 _collateralValue,
992     uint256 _vaultDebt
993   ) external view returns (bool);
994 }
995 
996 // 
997 interface IVaultsCoreV1 {
998   event Opened(uint256 indexed vaultId, address indexed collateralType, address indexed owner);
999   event Deposited(uint256 indexed vaultId, uint256 amount, address indexed sender);
1000   event Withdrawn(uint256 indexed vaultId, uint256 amount, address indexed sender);
1001   event Borrowed(uint256 indexed vaultId, uint256 amount, address indexed sender);
1002   event Repaid(uint256 indexed vaultId, uint256 amount, address indexed sender);
1003   event Liquidated(
1004     uint256 indexed vaultId,
1005     uint256 debtRepaid,
1006     uint256 collateralLiquidated,
1007     address indexed owner,
1008     address indexed sender
1009   );
1010 
1011   event CumulativeRateUpdated(address indexed collateralType, uint256 elapsedTime, uint256 newCumulativeRate); //cumulative interest rate from deployment time T0
1012 
1013   event InsurancePaid(uint256 indexed vaultId, uint256 insuranceAmount, address indexed sender);
1014 
1015   function deposit(address _collateralType, uint256 _amount) external;
1016 
1017   function withdraw(uint256 _vaultId, uint256 _amount) external;
1018 
1019   function withdrawAll(uint256 _vaultId) external;
1020 
1021   function borrow(uint256 _vaultId, uint256 _amount) external;
1022 
1023   function repayAll(uint256 _vaultId) external;
1024 
1025   function repay(uint256 _vaultId, uint256 _amount) external;
1026 
1027   function liquidate(uint256 _vaultId) external;
1028 
1029   //Refresh
1030   function initializeRates(address _collateralType) external;
1031 
1032   function refresh() external;
1033 
1034   function refreshCollateral(address collateralType) external;
1035 
1036   //upgrade
1037   function upgrade(address _newVaultsCore) external;
1038 
1039   //Read only
1040 
1041   function a() external view returns (IAddressProviderV1);
1042 
1043   function availableIncome() external view returns (uint256);
1044 
1045   function cumulativeRates(address _collateralType) external view returns (uint256);
1046 
1047   function lastRefresh(address _collateralType) external view returns (uint256);
1048 }
1049 
1050 // 
1051 interface IWETH {
1052   function deposit() external payable;
1053 
1054   function transfer(address to, uint256 value) external returns (bool);
1055 
1056   function withdraw(uint256 wad) external;
1057 }
1058 
1059 // 
1060 interface IGovernorAlpha {
1061     /// @notice Possible states that a proposal may be in
1062     enum ProposalState {
1063         Active,
1064         Canceled,
1065         Defeated,
1066         Succeeded,
1067         Queued,
1068         Expired,
1069         Executed
1070     }
1071 
1072     struct Proposal {
1073         // Unique id for looking up a proposal
1074         uint256 id;
1075 
1076         // Creator of the proposal
1077         address proposer;
1078 
1079         // The timestamp that the proposal will be available for execution, set once the vote succeeds
1080         uint256 eta;
1081 
1082         // the ordered list of target addresses for calls to be made
1083         address[] targets;
1084 
1085         // The ordered list of values (i.e. msg.value) to be passed to the calls to be made
1086         uint256[] values;
1087 
1088         // The ordered list of function signatures to be called
1089         string[] signatures;
1090 
1091         // The ordered list of calldata to be passed to each call
1092         bytes[] calldatas;
1093 
1094         // The timestamp at which voting begins: holders must delegate their votes prior to this timestamp
1095         uint256 startTime;
1096 
1097         // The timestamp at which voting ends: votes must be cast prior to this timestamp
1098         uint endTime;
1099 
1100         // Current number of votes in favor of this proposal
1101         uint256 forVotes;
1102 
1103         // Current number of votes in opposition to this proposal
1104         uint256 againstVotes;
1105 
1106         // Flag marking whether the proposal has been canceled
1107         bool canceled;
1108 
1109         // Flag marking whether the proposal has been executed
1110         bool executed;
1111 
1112         // Receipts of ballots for the entire set of voters
1113         mapping (address => Receipt) receipts;
1114     }
1115 
1116     /// @notice Ballot receipt record for a voter
1117     struct Receipt {
1118         // Whether or not a vote has been cast
1119         bool hasVoted;
1120 
1121         // Whether or not the voter supports the proposal
1122         bool support;
1123 
1124         // The number of votes the voter had, which were cast
1125         uint votes;
1126     }
1127 
1128     /// @notice An event emitted when a new proposal is created
1129     event ProposalCreated(uint256 id, address proposer, address[] targets, uint256[] values, string[] signatures, bytes[] calldatas, uint startTime, uint endTime, string description);
1130 
1131     /// @notice An event emitted when a vote has been cast on a proposal
1132     event VoteCast(address voter, uint256 proposalId, bool support, uint256 votes);
1133 
1134     /// @notice An event emitted when a proposal has been canceled
1135     event ProposalCanceled(uint256 id);
1136 
1137     /// @notice An event emitted when a proposal has been queued in the Timelock
1138     event ProposalQueued(uint256 id, uint256 eta);
1139 
1140     /// @notice An event emitted when a proposal has been executed in the Timelock
1141     event ProposalExecuted(uint256 id);
1142 
1143     function propose(address[] memory targets, uint256[] memory values, string[] memory signatures, bytes[] memory calldatas, string memory description, uint256 endTime) external returns (uint);
1144 
1145     function queue(uint256 proposalId) external;
1146 
1147     function execute(uint256 proposalId) external payable;
1148 
1149     function cancel(uint256 proposalId) external;
1150 
1151     function castVote(uint256 proposalId, bool support) external;
1152 
1153     function getActions(uint256 proposalId) external view returns (address[] memory targets, uint256[] memory values, string[] memory signatures, bytes[] memory calldatas);
1154 
1155     function getReceipt(uint256 proposalId, address voter) external view returns (Receipt memory);
1156 
1157     function state(uint proposalId) external view returns (ProposalState);
1158 
1159     function quorumVotes() external view returns (uint256);
1160 
1161     function proposalThreshold() external view returns (uint256);
1162 }
1163 
1164 // 
1165 interface ITimelock {
1166   event NewAdmin(address indexed newAdmin);
1167   event NewPendingAdmin(address indexed newPendingAdmin);
1168   event NewDelay(uint256 indexed newDelay);
1169   event CancelTransaction(
1170     bytes32 indexed txHash,
1171     address indexed target,
1172     uint256 value,
1173     string signature,
1174     bytes data,
1175     uint256 eta
1176   );
1177   event ExecuteTransaction(
1178     bytes32 indexed txHash,
1179     address indexed target,
1180     uint256 value,
1181     string signature,
1182     bytes data,
1183     uint256 eta
1184   );
1185   event QueueTransaction(
1186     bytes32 indexed txHash,
1187     address indexed target,
1188     uint256 value,
1189     string signature,
1190     bytes data,
1191     uint256 eta
1192   );
1193 
1194   function acceptAdmin() external;
1195 
1196   function queueTransaction(
1197     address target,
1198     uint256 value,
1199     string calldata signature,
1200     bytes calldata data,
1201     uint256 eta
1202   ) external returns (bytes32);
1203 
1204   function cancelTransaction(
1205     address target,
1206     uint256 value,
1207     string calldata signature,
1208     bytes calldata data,
1209     uint256 eta
1210   ) external;
1211 
1212   function executeTransaction(
1213     address target,
1214     uint256 value,
1215     string calldata signature,
1216     bytes calldata data,
1217     uint256 eta
1218   ) external payable returns (bytes memory);
1219 
1220   function delay() external view returns (uint256);
1221 
1222   function GRACE_PERIOD() external view returns (uint256);
1223 
1224   function queuedTransactions(bytes32 hash) external view returns (bool);
1225 }
1226 
1227 // 
1228 interface IVotingEscrow {
1229   enum LockAction { CREATE_LOCK, INCREASE_LOCK_AMOUNT, INCREASE_LOCK_TIME }
1230 
1231   struct LockedBalance {
1232     uint256 amount;
1233     uint256 end;
1234   }
1235 
1236   /** Shared Events */
1237   event Deposit(address indexed provider, uint256 value, uint256 locktime, LockAction indexed action, uint256 ts);
1238   event Withdraw(address indexed provider, uint256 value, uint256 ts);
1239   event Expired();
1240 
1241   function createLock(uint256 _value, uint256 _unlockTime) external;
1242 
1243   function increaseLockAmount(uint256 _value) external;
1244 
1245   function increaseLockLength(uint256 _unlockTime) external;
1246 
1247   function withdraw() external;
1248 
1249   function expireContract() external;
1250 
1251   function name() external view returns (string memory);
1252 
1253   function symbol() external view returns (string memory);
1254 
1255   function decimals() external view returns (uint256);
1256 
1257   function balanceOf(address _owner) external view returns (uint256);
1258 
1259   function balanceOfAt(address _owner, uint256 _blockTime) external view returns (uint256);
1260 
1261   function stakingToken() external view returns (IERC20);
1262 }
1263 
1264 // 
1265 interface IMIMO is IERC20 {
1266 
1267   function burn(address account, uint256 amount) external;
1268   
1269   function mint(address account, uint256 amount) external;
1270 
1271 }
1272 
1273 // 
1274 interface ISupplyMiner {
1275 
1276   function baseDebtChanged(address user, uint256 newBaseDebt) external;
1277 }
1278 
1279 // 
1280 interface IDebtNotifier {
1281 
1282   function debtChanged(uint256 _vaultId) external;
1283 
1284   function setCollateralSupplyMiner(address collateral, ISupplyMiner supplyMiner) external;
1285 
1286   function a() external view returns (IGovernanceAddressProvider);
1287 
1288 	function collateralSupplyMinerMapping(address collateral) external view returns (ISupplyMiner);
1289 }
1290 
1291 // 
1292 interface IGovernanceAddressProvider {
1293   function setParallelAddressProvider(IAddressProvider _parallel) external;
1294 
1295   function setMIMO(IMIMO _mimo) external;
1296 
1297   function setDebtNotifier(IDebtNotifier _debtNotifier) external;
1298 
1299   function setGovernorAlpha(IGovernorAlpha _governorAlpha) external;
1300 
1301   function setTimelock(ITimelock _timelock) external;
1302 
1303   function setVotingEscrow(IVotingEscrow _votingEscrow) external;
1304 
1305   function controller() external view returns (IAccessController);
1306 
1307   function parallel() external view returns (IAddressProvider);
1308 
1309   function mimo() external view returns (IMIMO);
1310 
1311   function debtNotifier() external view returns (IDebtNotifier);
1312 
1313   function governorAlpha() external view returns (IGovernorAlpha);
1314 
1315   function timelock() external view returns (ITimelock);
1316 
1317   function votingEscrow() external view returns (IVotingEscrow);
1318 }
1319 
1320 // 
1321 interface IVaultsCore {
1322   event Opened(uint256 indexed vaultId, address indexed collateralType, address indexed owner);
1323   event Deposited(uint256 indexed vaultId, uint256 amount, address indexed sender);
1324   event Withdrawn(uint256 indexed vaultId, uint256 amount, address indexed sender);
1325   event Borrowed(uint256 indexed vaultId, uint256 amount, address indexed sender);
1326   event Repaid(uint256 indexed vaultId, uint256 amount, address indexed sender);
1327   event Liquidated(
1328     uint256 indexed vaultId,
1329     uint256 debtRepaid,
1330     uint256 collateralLiquidated,
1331     address indexed owner,
1332     address indexed sender
1333   );
1334 
1335   event InsurancePaid(uint256 indexed vaultId, uint256 insuranceAmount, address indexed sender);
1336 
1337   function deposit(address _collateralType, uint256 _amount) external;
1338 
1339   function depositETH() external payable;
1340 
1341   function depositByVaultId(uint256 _vaultId, uint256 _amount) external;
1342 
1343   function depositETHByVaultId(uint256 _vaultId) external payable;
1344 
1345   function depositAndBorrow(
1346     address _collateralType,
1347     uint256 _depositAmount,
1348     uint256 _borrowAmount
1349   ) external;
1350 
1351   function depositETHAndBorrow(uint256 _borrowAmount) external payable;
1352 
1353   function withdraw(uint256 _vaultId, uint256 _amount) external;
1354 
1355   function withdrawETH(uint256 _vaultId, uint256 _amount) external;
1356 
1357   function borrow(uint256 _vaultId, uint256 _amount) external;
1358 
1359   function repayAll(uint256 _vaultId) external;
1360 
1361   function repay(uint256 _vaultId, uint256 _amount) external;
1362 
1363   function liquidate(uint256 _vaultId) external;
1364 
1365   function liquidatePartial(uint256 _vaultId, uint256 _amount) external;
1366 
1367   function upgrade(address payable _newVaultsCore) external;
1368 
1369   function acceptUpgrade(address payable _oldVaultsCore) external;
1370 
1371   function setDebtNotifier(IDebtNotifier _debtNotifier) external;
1372 
1373   //Read only
1374   function a() external view returns (IAddressProvider);
1375 
1376   function WETH() external view returns (IWETH);
1377 
1378   function debtNotifier() external view returns (IDebtNotifier);
1379 
1380   function state() external view returns (IVaultsCoreState);
1381 
1382   function cumulativeRates(address _collateralType) external view returns (uint256);
1383 }
1384 
1385 // 
1386 interface IAddressProviderV1 {
1387   function setAccessController(IAccessController _controller) external;
1388 
1389   function setConfigProvider(IConfigProviderV1 _config) external;
1390 
1391   function setVaultsCore(IVaultsCoreV1 _core) external;
1392 
1393   function setStableX(ISTABLEX _stablex) external;
1394 
1395   function setRatesManager(IRatesManager _ratesManager) external;
1396 
1397   function setPriceFeed(IPriceFeed _priceFeed) external;
1398 
1399   function setLiquidationManager(ILiquidationManagerV1 _liquidationManager) external;
1400 
1401   function setVaultsDataProvider(IVaultsDataProvider _vaultsData) external;
1402 
1403   function setFeeDistributor(IFeeDistributor _feeDistributor) external;
1404 
1405   function controller() external view returns (IAccessController);
1406 
1407   function config() external view returns (IConfigProviderV1);
1408 
1409   function core() external view returns (IVaultsCoreV1);
1410 
1411   function stablex() external view returns (ISTABLEX);
1412 
1413   function ratesManager() external view returns (IRatesManager);
1414 
1415   function priceFeed() external view returns (IPriceFeed);
1416 
1417   function liquidationManager() external view returns (ILiquidationManagerV1);
1418 
1419   function vaultsData() external view returns (IVaultsDataProvider);
1420 
1421   function feeDistributor() external view returns (IFeeDistributor);
1422 }
1423 
1424 // 
1425 interface IVaultsCoreState {
1426   event CumulativeRateUpdated(address indexed collateralType, uint256 elapsedTime, uint256 newCumulativeRate); //cumulative interest rate from deployment time T0
1427 
1428   function initializeRates(address _collateralType) external;
1429 
1430   function refresh() external;
1431 
1432   function refreshCollateral(address collateralType) external;
1433 
1434   function syncState(IVaultsCoreState _stateAddress) external;
1435 
1436   function syncStateFromV1(IVaultsCoreV1 _core) external;
1437 
1438   //Read only
1439   function a() external view returns (IAddressProvider);
1440 
1441   function availableIncome() external view returns (uint256);
1442 
1443   function cumulativeRates(address _collateralType) external view returns (uint256);
1444 
1445   function lastRefresh(address _collateralType) external view returns (uint256);
1446 
1447   function synced() external view returns (bool);
1448 }
1449 
1450 // 
1451 contract VaultsCore is IVaultsCore, ReentrancyGuard {
1452   using SafeERC20 for IERC20;
1453   using SafeMath for uint256;
1454   using WadRayMath for uint256;
1455 
1456   uint256 internal constant _MAX_INT = 2**256 - 1;
1457 
1458   IAddressProvider public override a;
1459   IWETH public override WETH;
1460   IVaultsCoreState public override state;
1461   IDebtNotifier public override debtNotifier;
1462 
1463   modifier onlyManager() {
1464     require(a.controller().hasRole(a.controller().MANAGER_ROLE(), msg.sender));
1465     _;
1466   }
1467 
1468   modifier onlyVaultOwner(uint256 _vaultId) {
1469     require(a.vaultsData().vaultOwner(_vaultId) == msg.sender);
1470     _;
1471   }
1472 
1473   constructor(
1474     IAddressProvider _addresses,
1475     IWETH _IWETH,
1476     IVaultsCoreState _vaultsCoreState
1477   ) public {
1478     require(address(_addresses) != address(0));
1479     require(address(_IWETH) != address(0));
1480     require(address(_vaultsCoreState) != address(0));
1481     a = _addresses;
1482     WETH = _IWETH;
1483     state = _vaultsCoreState;
1484   }
1485 
1486   // For a contract to receive ETH, it needs to have a payable fallback function
1487   // https://ethereum.stackexchange.com/a/47415
1488   receive() external payable {
1489     require(msg.sender == address(WETH));
1490   }
1491 
1492   /*
1493     Allow smooth upgrading of the vaultscore.
1494     @dev this function approves token transfers to the new vaultscore of
1495     both stablex and all configured collateral types
1496     @param _newVaultsCore address of the new vaultscore
1497   */
1498   function upgrade(address payable _newVaultsCore) public override onlyManager {
1499     require(address(_newVaultsCore) != address(0));
1500     require(a.stablex().approve(_newVaultsCore, _MAX_INT));
1501 
1502     for (uint256 i = 1; i <= a.config().numCollateralConfigs(); i++) {
1503       address collateralType = a.config().collateralConfigs(i).collateralType;
1504       IERC20 asset = IERC20(collateralType);
1505       asset.safeApprove(_newVaultsCore, _MAX_INT);
1506     }
1507   }
1508 
1509   /*
1510     Allow smooth upgrading of the VaultsCore.
1511     @dev this function transfers both PAR and all configured collateral
1512     types to the new vaultscore.
1513   */
1514   function acceptUpgrade(address payable _oldVaultsCore) public override onlyManager {
1515     IERC20 stableX = IERC20(a.stablex());
1516     stableX.safeTransferFrom(_oldVaultsCore, address(this), stableX.balanceOf(_oldVaultsCore));
1517 
1518     for (uint256 i = 1; i <= a.config().numCollateralConfigs(); i++) {
1519       address collateralType = a.config().collateralConfigs(i).collateralType;
1520       IERC20 asset = IERC20(collateralType);
1521       asset.safeTransferFrom(_oldVaultsCore, address(this), asset.balanceOf(_oldVaultsCore));
1522     }
1523   }
1524 
1525   /**
1526     Configure the debt notifier.
1527     @param _debtNotifier the new DebtNotifier module address.
1528   **/
1529   function setDebtNotifier(IDebtNotifier _debtNotifier) public override onlyManager {
1530     require(address(_debtNotifier) != address(0));
1531     debtNotifier = _debtNotifier;
1532   }
1533 
1534   /**
1535     Deposit an ERC20 token into the vault of the msg.sender as collateral
1536     @dev A new vault is created if no vault exists for the `msg.sender` with the specified collateral type.
1537     this function uses `transferFrom()` and requires pre-approval via `approve()` on the ERC20.
1538     @param _collateralType the address of the collateral type to be deposited
1539     @param _amount the amount of tokens to be deposited in WEI.
1540   **/
1541   function deposit(address _collateralType, uint256 _amount) public override {
1542     require(a.config().collateralIds(_collateralType) != 0);
1543 
1544     IERC20 asset = IERC20(_collateralType);
1545     asset.safeTransferFrom(msg.sender, address(this), _amount);
1546 
1547     _addCollateralToVault(_collateralType, _amount);
1548   }
1549 
1550   /**
1551     Wraps ETH and deposits WETH into the vault of the msg.sender as collateral
1552     @dev A new vault is created if no WETH vault exists
1553   **/
1554   function depositETH() public payable override {
1555     WETH.deposit{ value: msg.value }();
1556     _addCollateralToVault(address(WETH), msg.value);
1557   }
1558 
1559   /**
1560     Deposit an ERC20 token into the specified vault as collateral
1561     @dev this function uses `transferFrom()` and requires pre-approval via `approve()` on the ERC20.
1562     @param _vaultId the address of the collateral type to be deposited
1563     @param _amount the amount of tokens to be deposited in WEI.
1564   **/
1565   function depositByVaultId(uint256 _vaultId, uint256 _amount) public override {
1566     IVaultsDataProvider.Vault memory v = a.vaultsData().vaults(_vaultId);
1567     require(v.collateralType != address(0));
1568 
1569     IERC20 asset = IERC20(v.collateralType);
1570     asset.safeTransferFrom(msg.sender, address(this), _amount);
1571 
1572     _addCollateralToVaultById(_vaultId, _amount);
1573   }
1574 
1575   /**
1576     Wraps ETH and deposits WETH into the specified vault as collateral
1577     @dev this function uses `transferFrom()` and requires pre-approval via `approve()` on the ERC20.
1578     @param _vaultId the address of the collateral type to be deposited
1579   **/
1580   function depositETHByVaultId(uint256 _vaultId) public payable override {
1581     IVaultsDataProvider.Vault memory v = a.vaultsData().vaults(_vaultId);
1582     require(v.collateralType == address(WETH));
1583 
1584     WETH.deposit{ value: msg.value }();
1585 
1586     _addCollateralToVaultById(_vaultId, msg.value);
1587   }
1588 
1589   /**
1590     Deposit an ERC20 token into the vault of the msg.sender as collateral and borrows the specified amount of tokens in WEI
1591     @dev see deposit() and borrow()
1592     @param _collateralType the address of the collateral type to be deposited
1593     @param _depositAmount the amount of tokens to be deposited in WEI.
1594     @param _borrowAmount the amount of borrowed StableX tokens in WEI.
1595   **/
1596   function depositAndBorrow(
1597     address _collateralType,
1598     uint256 _depositAmount,
1599     uint256 _borrowAmount
1600   ) public override {
1601     deposit(_collateralType, _depositAmount);
1602     uint256 vaultId = a.vaultsData().vaultId(_collateralType, msg.sender);
1603     borrow(vaultId, _borrowAmount);
1604   }
1605 
1606   /**
1607     Wraps ETH and deposits WETH into the vault of the msg.sender as collateral and borrows the specified amount of tokens in WEI
1608     @dev see depositETH() and borrow()
1609     @param _borrowAmount the amount of borrowed StableX tokens in WEI.
1610   **/
1611   function depositETHAndBorrow(uint256 _borrowAmount) public payable override {
1612     depositETH();
1613     uint256 vaultId = a.vaultsData().vaultId(address(WETH), msg.sender);
1614     borrow(vaultId, _borrowAmount);
1615   }
1616 
1617   function _addCollateralToVault(address _collateralType, uint256 _amount) internal {
1618     uint256 vaultId = a.vaultsData().vaultId(_collateralType, msg.sender);
1619     if (vaultId == 0) {
1620       vaultId = a.vaultsData().createVault(_collateralType, msg.sender);
1621     }
1622 
1623     _addCollateralToVaultById(vaultId, _amount);
1624   }
1625 
1626   function _addCollateralToVaultById(uint256 _vaultId, uint256 _amount) internal {
1627     IVaultsDataProvider.Vault memory v = a.vaultsData().vaults(_vaultId);
1628 
1629     a.vaultsData().setCollateralBalance(_vaultId, v.collateralBalance.add(_amount));
1630 
1631     emit Deposited(_vaultId, _amount, msg.sender);
1632   }
1633 
1634   /**
1635     Withdraws ERC20 tokens from a vault.
1636     @dev Only the owner of a vault can withdraw collateral from it.
1637     `withdraw()` will fail if it would bring the vault below the minimum collateralization treshold.
1638     @param _vaultId the ID of the vault from which to withdraw the collateral.
1639     @param _amount the amount of ERC20 tokens to be withdrawn in WEI.
1640   **/
1641   function withdraw(uint256 _vaultId, uint256 _amount) public override onlyVaultOwner(_vaultId) nonReentrant {
1642     _removeCollateralFromVault(_vaultId, _amount);
1643     IVaultsDataProvider.Vault memory v = a.vaultsData().vaults(_vaultId);
1644 
1645     IERC20 asset = IERC20(v.collateralType);
1646     asset.safeTransfer(msg.sender, _amount);
1647   }
1648 
1649   /**
1650     Withdraws ETH from a WETH vault.
1651     @dev Only the owner of a vault can withdraw collateral from it.
1652     `withdraw()` will fail if it would bring the vault below the minimum collateralization treshold.
1653     @param _vaultId the ID of the vault from which to withdraw the collateral.
1654     @param _amount the amount of ETH to be withdrawn in WEI.
1655   **/
1656   function withdrawETH(uint256 _vaultId, uint256 _amount) public override onlyVaultOwner(_vaultId) nonReentrant {
1657     _removeCollateralFromVault(_vaultId, _amount);
1658     IVaultsDataProvider.Vault memory v = a.vaultsData().vaults(_vaultId);
1659 
1660     require(v.collateralType == address(WETH));
1661 
1662     WETH.withdraw(_amount);
1663     msg.sender.transfer(_amount);
1664   }
1665 
1666   function _removeCollateralFromVault(uint256 _vaultId, uint256 _amount) internal {
1667     IVaultsDataProvider.Vault memory v = a.vaultsData().vaults(_vaultId);
1668     require(_amount <= v.collateralBalance);
1669     uint256 newCollateralBalance = v.collateralBalance.sub(_amount);
1670     a.vaultsData().setCollateralBalance(_vaultId, newCollateralBalance);
1671     if (v.baseDebt > 0) {
1672       // Save gas cost when withdrawing from 0 debt vault
1673       state.refreshCollateral(v.collateralType);
1674       uint256 newCollateralValue = a.priceFeed().convertFrom(v.collateralType, newCollateralBalance);
1675       require(
1676         a.liquidationManager().isHealthy(
1677           newCollateralValue,
1678           a.vaultsData().vaultDebt(_vaultId),
1679           a.config().collateralConfigs(a.config().collateralIds(v.collateralType)).minCollateralRatio
1680         )
1681       );
1682     }
1683 
1684     emit Withdrawn(_vaultId, _amount, msg.sender);
1685   }
1686 
1687   /**
1688     Borrow new PAR tokens from a vault.
1689     @dev Only the owner of a vault can borrow from it.
1690     `borrow()` will update the outstanding vault debt to the current time before attempting the withdrawal.
1691      `borrow()` will fail if it would bring the vault below the minimum collateralization treshold.
1692     @param _vaultId the ID of the vault from which to borrow.
1693     @param _amount the amount of borrowed PAR tokens in WEI.
1694   **/
1695   function borrow(uint256 _vaultId, uint256 _amount) public override onlyVaultOwner(_vaultId) nonReentrant {
1696     IVaultsDataProvider.Vault memory v = a.vaultsData().vaults(_vaultId);
1697 
1698     // Make sure current rate is up to date
1699     state.refreshCollateral(v.collateralType);
1700 
1701     uint256 originationFeePercentage = a.config().collateralOriginationFee(v.collateralType);
1702     uint256 newDebt = _amount;
1703     if (originationFeePercentage > 0) {
1704       newDebt = newDebt.add(_amount.wadMul(originationFeePercentage));
1705     }
1706 
1707     // Increment vault borrow balance
1708     uint256 newBaseDebt = a.ratesManager().calculateBaseDebt(newDebt, cumulativeRates(v.collateralType));
1709 
1710     a.vaultsData().setBaseDebt(_vaultId, v.baseDebt.add(newBaseDebt));
1711 
1712     uint256 collateralValue = a.priceFeed().convertFrom(v.collateralType, v.collateralBalance);
1713     uint256 newVaultDebt = a.vaultsData().vaultDebt(_vaultId);
1714 
1715     require(a.vaultsData().collateralDebt(v.collateralType) <= a.config().collateralDebtLimit(v.collateralType));
1716 
1717     bool isHealthy = a.liquidationManager().isHealthy(
1718       collateralValue,
1719       newVaultDebt,
1720       a.config().collateralConfigs(a.config().collateralIds(v.collateralType)).minCollateralRatio
1721     );
1722     require(isHealthy);
1723 
1724     a.stablex().mint(msg.sender, _amount);
1725     debtNotifier.debtChanged(_vaultId);
1726     emit Borrowed(_vaultId, _amount, msg.sender);
1727   }
1728 
1729   /**
1730     Convenience function to repay all debt of a vault
1731     @dev `repayAll()` will update the outstanding vault debt to the current time.
1732     @param _vaultId the ID of the vault for which to repay the debt.
1733   **/
1734   function repayAll(uint256 _vaultId) public override {
1735     repay(_vaultId, _MAX_INT);
1736   }
1737 
1738   /**
1739     Repay an outstanding PAR balance to a vault.
1740     @dev `repay()` will update the outstanding vault debt to the current time.
1741     @param _vaultId the ID of the vault for which to repay the outstanding debt balance.
1742     @param _amount the amount of PAR tokens in WEI to be repaid.
1743   **/
1744   function repay(uint256 _vaultId, uint256 _amount) public override nonReentrant {
1745     address collateralType = a.vaultsData().vaultCollateralType(_vaultId);
1746 
1747     // Make sure current rate is up to date
1748     state.refreshCollateral(collateralType);
1749 
1750     uint256 currentVaultDebt = a.vaultsData().vaultDebt(_vaultId);
1751     // Decrement vault borrow balance
1752     if (_amount >= currentVaultDebt) {
1753       //full repayment
1754       _amount = currentVaultDebt; //only pay back what's outstanding
1755     }
1756     _reduceVaultDebt(_vaultId, _amount);
1757     a.stablex().burn(msg.sender, _amount);
1758     debtNotifier.debtChanged(_vaultId);
1759     emit Repaid(_vaultId, _amount, msg.sender);
1760   }
1761 
1762   /**
1763     Internal helper function to reduce the debt of a vault.
1764     @dev assumes cumulative rates for the vault's collateral type are up to date.
1765     please call `refreshCollateral()` before calling this function.
1766     @param _vaultId the ID of the vault for which to reduce the debt.
1767     @param _amount the amount of debt to be reduced.
1768   **/
1769   function _reduceVaultDebt(uint256 _vaultId, uint256 _amount) internal {
1770     address collateralType = a.vaultsData().vaultCollateralType(_vaultId);
1771 
1772     uint256 currentVaultDebt = a.vaultsData().vaultDebt(_vaultId);
1773     uint256 remainder = currentVaultDebt.sub(_amount);
1774     uint256 cumulativeRate = cumulativeRates(collateralType);
1775 
1776     if (remainder == 0) {
1777       a.vaultsData().setBaseDebt(_vaultId, 0);
1778     } else {
1779       uint256 newBaseDebt = a.ratesManager().calculateBaseDebt(remainder, cumulativeRate);
1780       a.vaultsData().setBaseDebt(_vaultId, newBaseDebt);
1781     }
1782   }
1783 
1784   /**
1785     Liquidate a vault that is below the liquidation treshold by repaying its outstanding debt.
1786     @dev `liquidate()` will update the outstanding vault debt to the current time and pay a `liquidationBonus`
1787     to the liquidator. `liquidate()` can be called by anyone.
1788     @param _vaultId the ID of the vault to be liquidated.
1789   **/
1790   function liquidate(uint256 _vaultId) public override {
1791     liquidatePartial(_vaultId, _MAX_INT);
1792   }
1793 
1794   /**
1795     Liquidate a vault partially that is below the liquidation treshold by repaying part of its outstanding debt.
1796     @dev `liquidatePartial()` will update the outstanding vault debt to the current time and pay a `liquidationBonus`
1797     to the liquidator. A LiquidationFee will be applied to the borrower during the liquidation.
1798     This means that the change in outstanding debt can be smaller than the repaid amount.
1799     `liquidatePartial()` can be called by anyone.
1800     @param _vaultId the ID of the vault to be liquidated.
1801     @param _amount the amount of debt+liquidationFee to repay.
1802   **/
1803   function liquidatePartial(uint256 _vaultId, uint256 _amount) public override nonReentrant {
1804     IVaultsDataProvider.Vault memory v = a.vaultsData().vaults(_vaultId);
1805 
1806     state.refreshCollateral(v.collateralType);
1807 
1808     uint256 collateralValue = a.priceFeed().convertFrom(v.collateralType, v.collateralBalance);
1809     uint256 currentVaultDebt = a.vaultsData().vaultDebt(_vaultId);
1810 
1811     require(
1812       !a.liquidationManager().isHealthy(
1813         collateralValue,
1814         currentVaultDebt,
1815         a.config().collateralConfigs(a.config().collateralIds(v.collateralType)).liquidationRatio
1816       )
1817     );
1818 
1819     uint256 repaymentAfterLiquidationFeeRatio = WadRayMath.wad().sub(
1820       a.config().collateralLiquidationFee(v.collateralType)
1821     );
1822     uint256 maxLiquiditionCost = currentVaultDebt.wadDiv(repaymentAfterLiquidationFeeRatio);
1823 
1824     uint256 repayAmount;
1825 
1826     if (_amount > maxLiquiditionCost) {
1827       _amount = maxLiquiditionCost;
1828       repayAmount = currentVaultDebt;
1829     } else {
1830       repayAmount = _amount.wadMul(repaymentAfterLiquidationFeeRatio);
1831     }
1832 
1833     // collateral value to be received by the liquidator is based on the total amount repaid (including the liquidationFee).
1834     uint256 collateralValueToReceive = _amount.add(a.liquidationManager().liquidationBonus(v.collateralType, _amount));
1835     uint256 insuranceAmount = 0;
1836     if (collateralValueToReceive >= collateralValue) {
1837       // Not enough collateral for debt & liquidation fee
1838       collateralValueToReceive = collateralValue;
1839       uint256 discountedCollateralValue = a.liquidationManager().applyLiquidationDiscount(
1840         v.collateralType,
1841         collateralValue
1842       );
1843 
1844       if (currentVaultDebt > discountedCollateralValue) {
1845         // Not enough collateral for debt alone
1846         insuranceAmount = currentVaultDebt.sub(discountedCollateralValue);
1847         require(a.stablex().balanceOf(address(this)) >= insuranceAmount);
1848         a.stablex().burn(address(this), insuranceAmount); // Insurance uses local reserves to pay down debt
1849         emit InsurancePaid(_vaultId, insuranceAmount, msg.sender);
1850       }
1851 
1852       repayAmount = currentVaultDebt.sub(insuranceAmount);
1853       _amount = discountedCollateralValue;
1854     }
1855 
1856     // reduce the vault debt by repayAmount
1857     _reduceVaultDebt(_vaultId, repayAmount.add(insuranceAmount));
1858     a.stablex().burn(msg.sender, _amount);
1859 
1860     // send the claimed collateral to the liquidator
1861     uint256 collateralToReceive = a.priceFeed().convertTo(v.collateralType, collateralValueToReceive);
1862     a.vaultsData().setCollateralBalance(_vaultId, v.collateralBalance.sub(collateralToReceive));
1863     IERC20 asset = IERC20(v.collateralType);
1864     asset.safeTransfer(msg.sender, collateralToReceive);
1865 
1866     debtNotifier.debtChanged(_vaultId);
1867 
1868     emit Liquidated(_vaultId, repayAmount, collateralToReceive, v.owner, msg.sender);
1869   }
1870 
1871   /**
1872     Returns the cumulativeRate of a collateral type. This function exists for
1873     backwards compatibility with the VaultsDataProvider.
1874     @param _collateralType the address of the collateral type.
1875   **/
1876   function cumulativeRates(address _collateralType) public view override returns (uint256) {
1877     return state.cumulativeRates(_collateralType);
1878   }
1879 }