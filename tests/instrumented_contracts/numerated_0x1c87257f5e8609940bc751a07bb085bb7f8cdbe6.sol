1 /**
2  *Submitted for verification at Etherscan.io on 2021-04-27
3 */
4 
5 // SPDX-License-Identifier: BUSL-1.1
6 // File: @uniswap/lib/contracts/libraries/TransferHelper.sol
7 
8 pragma solidity >=0.6.0;
9 
10 // helper methods for interacting with ERC20 tokens and sending ETH that do not consistently return true/false
11 library TransferHelper {
12     function safeApprove(address token, address to, uint value) internal {
13         // bytes4(keccak256(bytes('approve(address,uint256)')));
14         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x095ea7b3, to, value));
15         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: APPROVE_FAILED');
16     }
17 
18     function safeTransfer(address token, address to, uint value) internal {
19         // bytes4(keccak256(bytes('transfer(address,uint256)')));
20         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));
21         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FAILED');
22     }
23 
24     function safeTransferFrom(address token, address from, address to, uint value) internal {
25         // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
26         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));
27         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FROM_FAILED');
28     }
29 
30     function safeTransferETH(address to, uint value) internal {
31         (bool success,) = to.call{value:value}(new bytes(0));
32         require(success, 'TransferHelper: ETH_TRANSFER_FAILED');
33     }
34 }
35 
36 // File: @openzeppelin/contracts/math/SafeMath.sol
37 
38 pragma solidity >=0.6.0 <0.8.0;
39 
40 /**
41  * @dev Wrappers over Solidity's arithmetic operations with added overflow
42  * checks.
43  *
44  * Arithmetic operations in Solidity wrap on overflow. This can easily result
45  * in bugs, because programmers usually assume that an overflow raises an
46  * error, which is the standard behavior in high level programming languages.
47  * `SafeMath` restores this intuition by reverting the transaction when an
48  * operation overflows.
49  *
50  * Using this library instead of the unchecked operations eliminates an entire
51  * class of bugs, so it's recommended to use it always.
52  */
53 library SafeMath {
54     /**
55      * @dev Returns the addition of two unsigned integers, with an overflow flag.
56      *
57      * _Available since v3.4._
58      */
59     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
60         uint256 c = a + b;
61         if (c < a) return (false, 0);
62         return (true, c);
63     }
64 
65     /**
66      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
67      *
68      * _Available since v3.4._
69      */
70     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
71         if (b > a) return (false, 0);
72         return (true, a - b);
73     }
74 
75     /**
76      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
77      *
78      * _Available since v3.4._
79      */
80     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
81         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
82         // benefit is lost if 'b' is also tested.
83         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
84         if (a == 0) return (true, 0);
85         uint256 c = a * b;
86         if (c / a != b) return (false, 0);
87         return (true, c);
88     }
89 
90     /**
91      * @dev Returns the division of two unsigned integers, with a division by zero flag.
92      *
93      * _Available since v3.4._
94      */
95     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
96         if (b == 0) return (false, 0);
97         return (true, a / b);
98     }
99 
100     /**
101      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
102      *
103      * _Available since v3.4._
104      */
105     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
106         if (b == 0) return (false, 0);
107         return (true, a % b);
108     }
109 
110     /**
111      * @dev Returns the addition of two unsigned integers, reverting on
112      * overflow.
113      *
114      * Counterpart to Solidity's `+` operator.
115      *
116      * Requirements:
117      *
118      * - Addition cannot overflow.
119      */
120     function add(uint256 a, uint256 b) internal pure returns (uint256) {
121         uint256 c = a + b;
122         require(c >= a, "SafeMath: addition overflow");
123         return c;
124     }
125 
126     /**
127      * @dev Returns the subtraction of two unsigned integers, reverting on
128      * overflow (when the result is negative).
129      *
130      * Counterpart to Solidity's `-` operator.
131      *
132      * Requirements:
133      *
134      * - Subtraction cannot overflow.
135      */
136     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
137         require(b <= a, "SafeMath: subtraction overflow");
138         return a - b;
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
152         if (a == 0) return 0;
153         uint256 c = a * b;
154         require(c / a == b, "SafeMath: multiplication overflow");
155         return c;
156     }
157 
158     /**
159      * @dev Returns the integer division of two unsigned integers, reverting on
160      * division by zero. The result is rounded towards zero.
161      *
162      * Counterpart to Solidity's `/` operator. Note: this function uses a
163      * `revert` opcode (which leaves remaining gas untouched) while Solidity
164      * uses an invalid opcode to revert (consuming all remaining gas).
165      *
166      * Requirements:
167      *
168      * - The divisor cannot be zero.
169      */
170     function div(uint256 a, uint256 b) internal pure returns (uint256) {
171         require(b > 0, "SafeMath: division by zero");
172         return a / b;
173     }
174 
175     /**
176      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
177      * reverting when dividing by zero.
178      *
179      * Counterpart to Solidity's `%` operator. This function uses a `revert`
180      * opcode (which leaves remaining gas untouched) while Solidity uses an
181      * invalid opcode to revert (consuming all remaining gas).
182      *
183      * Requirements:
184      *
185      * - The divisor cannot be zero.
186      */
187     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
188         require(b > 0, "SafeMath: modulo by zero");
189         return a % b;
190     }
191 
192     /**
193      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
194      * overflow (when the result is negative).
195      *
196      * CAUTION: This function is deprecated because it requires allocating memory for the error
197      * message unnecessarily. For custom revert reasons use {trySub}.
198      *
199      * Counterpart to Solidity's `-` operator.
200      *
201      * Requirements:
202      *
203      * - Subtraction cannot overflow.
204      */
205     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
206         require(b <= a, errorMessage);
207         return a - b;
208     }
209 
210     /**
211      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
212      * division by zero. The result is rounded towards zero.
213      *
214      * CAUTION: This function is deprecated because it requires allocating memory for the error
215      * message unnecessarily. For custom revert reasons use {tryDiv}.
216      *
217      * Counterpart to Solidity's `/` operator. Note: this function uses a
218      * `revert` opcode (which leaves remaining gas untouched) while Solidity
219      * uses an invalid opcode to revert (consuming all remaining gas).
220      *
221      * Requirements:
222      *
223      * - The divisor cannot be zero.
224      */
225     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
226         require(b > 0, errorMessage);
227         return a / b;
228     }
229 
230     /**
231      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
232      * reverting with custom message when dividing by zero.
233      *
234      * CAUTION: This function is deprecated because it requires allocating memory for the error
235      * message unnecessarily. For custom revert reasons use {tryMod}.
236      *
237      * Counterpart to Solidity's `%` operator. This function uses a `revert`
238      * opcode (which leaves remaining gas untouched) while Solidity uses an
239      * invalid opcode to revert (consuming all remaining gas).
240      *
241      * Requirements:
242      *
243      * - The divisor cannot be zero.
244      */
245     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
246         require(b > 0, errorMessage);
247         return a % b;
248     }
249 }
250 
251 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
252 
253 pragma solidity >=0.6.0 <0.8.0;
254 
255 /**
256  * @dev Interface of the ERC20 standard as defined in the EIP.
257  */
258 interface IERC20 {
259     /**
260      * @dev Returns the amount of tokens in existence.
261      */
262     function totalSupply() external view returns (uint256);
263 
264     /**
265      * @dev Returns the amount of tokens owned by `account`.
266      */
267     function balanceOf(address account) external view returns (uint256);
268 
269     /**
270      * @dev Moves `amount` tokens from the caller's account to `recipient`.
271      *
272      * Returns a boolean value indicating whether the operation succeeded.
273      *
274      * Emits a {Transfer} event.
275      */
276     function transfer(address recipient, uint256 amount) external returns (bool);
277 
278     /**
279      * @dev Returns the remaining number of tokens that `spender` will be
280      * allowed to spend on behalf of `owner` through {transferFrom}. This is
281      * zero by default.
282      *
283      * This value changes when {approve} or {transferFrom} are called.
284      */
285     function allowance(address owner, address spender) external view returns (uint256);
286 
287     /**
288      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
289      *
290      * Returns a boolean value indicating whether the operation succeeded.
291      *
292      * IMPORTANT: Beware that changing an allowance with this method brings the risk
293      * that someone may use both the old and the new allowance by unfortunate
294      * transaction ordering. One possible solution to mitigate this race
295      * condition is to first reduce the spender's allowance to 0 and set the
296      * desired value afterwards:
297      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
298      *
299      * Emits an {Approval} event.
300      */
301     function approve(address spender, uint256 amount) external returns (bool);
302 
303     /**
304      * @dev Moves `amount` tokens from `sender` to `recipient` using the
305      * allowance mechanism. `amount` is then deducted from the caller's
306      * allowance.
307      *
308      * Returns a boolean value indicating whether the operation succeeded.
309      *
310      * Emits a {Transfer} event.
311      */
312     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
313 
314     /**
315      * @dev Emitted when `value` tokens are moved from one account (`from`) to
316      * another (`to`).
317      *
318      * Note that `value` may be zero.
319      */
320     event Transfer(address indexed from, address indexed to, uint256 value);
321 
322     /**
323      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
324      * a call to {approve}. `value` is the new allowance.
325      */
326     event Approval(address indexed owner, address indexed spender, uint256 value);
327 }
328 
329 // File: @openzeppelin/contracts/utils/Address.sol
330 
331 pragma solidity >=0.6.2 <0.8.0;
332 
333 /**
334  * @dev Collection of functions related to the address type
335  */
336 library Address {
337     /**
338      * @dev Returns true if `account` is a contract.
339      *
340      * [IMPORTANT]
341      * ====
342      * It is unsafe to assume that an address for which this function returns
343      * false is an externally-owned account (EOA) and not a contract.
344      *
345      * Among others, `isContract` will return false for the following
346      * types of addresses:
347      *
348      *  - an externally-owned account
349      *  - a contract in construction
350      *  - an address where a contract will be created
351      *  - an address where a contract lived, but was destroyed
352      * ====
353      */
354     function isContract(address account) internal view returns (bool) {
355         // This method relies on extcodesize, which returns 0 for contracts in
356         // construction, since the code is only stored at the end of the
357         // constructor execution.
358 
359         uint256 size;
360         // solhint-disable-next-line no-inline-assembly
361         assembly { size := extcodesize(account) }
362         return size > 0;
363     }
364 
365     /**
366      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
367      * `recipient`, forwarding all available gas and reverting on errors.
368      *
369      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
370      * of certain opcodes, possibly making contracts go over the 2300 gas limit
371      * imposed by `transfer`, making them unable to receive funds via
372      * `transfer`. {sendValue} removes this limitation.
373      *
374      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
375      *
376      * IMPORTANT: because control is transferred to `recipient`, care must be
377      * taken to not create reentrancy vulnerabilities. Consider using
378      * {ReentrancyGuard} or the
379      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
380      */
381     function sendValue(address payable recipient, uint256 amount) internal {
382         require(address(this).balance >= amount, "Address: insufficient balance");
383 
384         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
385         (bool success, ) = recipient.call{ value: amount }("");
386         require(success, "Address: unable to send value, recipient may have reverted");
387     }
388 
389     /**
390      * @dev Performs a Solidity function call using a low level `call`. A
391      * plain`call` is an unsafe replacement for a function call: use this
392      * function instead.
393      *
394      * If `target` reverts with a revert reason, it is bubbled up by this
395      * function (like regular Solidity function calls).
396      *
397      * Returns the raw returned data. To convert to the expected return value,
398      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
399      *
400      * Requirements:
401      *
402      * - `target` must be a contract.
403      * - calling `target` with `data` must not revert.
404      *
405      * _Available since v3.1._
406      */
407     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
408       return functionCall(target, data, "Address: low-level call failed");
409     }
410 
411     /**
412      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
413      * `errorMessage` as a fallback revert reason when `target` reverts.
414      *
415      * _Available since v3.1._
416      */
417     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
418         return functionCallWithValue(target, data, 0, errorMessage);
419     }
420 
421     /**
422      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
423      * but also transferring `value` wei to `target`.
424      *
425      * Requirements:
426      *
427      * - the calling contract must have an ETH balance of at least `value`.
428      * - the called Solidity function must be `payable`.
429      *
430      * _Available since v3.1._
431      */
432     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
433         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
434     }
435 
436     /**
437      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
438      * with `errorMessage` as a fallback revert reason when `target` reverts.
439      *
440      * _Available since v3.1._
441      */
442     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
443         require(address(this).balance >= value, "Address: insufficient balance for call");
444         require(isContract(target), "Address: call to non-contract");
445 
446         // solhint-disable-next-line avoid-low-level-calls
447         (bool success, bytes memory returndata) = target.call{ value: value }(data);
448         return _verifyCallResult(success, returndata, errorMessage);
449     }
450 
451     /**
452      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
453      * but performing a static call.
454      *
455      * _Available since v3.3._
456      */
457     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
458         return functionStaticCall(target, data, "Address: low-level static call failed");
459     }
460 
461     /**
462      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
463      * but performing a static call.
464      *
465      * _Available since v3.3._
466      */
467     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
468         require(isContract(target), "Address: static call to non-contract");
469 
470         // solhint-disable-next-line avoid-low-level-calls
471         (bool success, bytes memory returndata) = target.staticcall(data);
472         return _verifyCallResult(success, returndata, errorMessage);
473     }
474 
475     /**
476      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
477      * but performing a delegate call.
478      *
479      * _Available since v3.4._
480      */
481     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
482         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
483     }
484 
485     /**
486      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
487      * but performing a delegate call.
488      *
489      * _Available since v3.4._
490      */
491     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
492         require(isContract(target), "Address: delegate call to non-contract");
493 
494         // solhint-disable-next-line avoid-low-level-calls
495         (bool success, bytes memory returndata) = target.delegatecall(data);
496         return _verifyCallResult(success, returndata, errorMessage);
497     }
498 
499     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
500         if (success) {
501             return returndata;
502         } else {
503             // Look for revert reason and bubble it up if present
504             if (returndata.length > 0) {
505                 // The easiest way to bubble the revert reason is using memory via assembly
506 
507                 // solhint-disable-next-line no-inline-assembly
508                 assembly {
509                     let returndata_size := mload(returndata)
510                     revert(add(32, returndata), returndata_size)
511                 }
512             } else {
513                 revert(errorMessage);
514             }
515         }
516     }
517 }
518 
519 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
520 
521 pragma solidity >=0.6.0 <0.8.0;
522 
523 
524 
525 
526 /**
527  * @title SafeERC20
528  * @dev Wrappers around ERC20 operations that throw on failure (when the token
529  * contract returns false). Tokens that return no value (and instead revert or
530  * throw on failure) are also supported, non-reverting calls are assumed to be
531  * successful.
532  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
533  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
534  */
535 library SafeERC20 {
536     using SafeMath for uint256;
537     using Address for address;
538 
539     function safeTransfer(IERC20 token, address to, uint256 value) internal {
540         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
541     }
542 
543     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
544         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
545     }
546 
547     /**
548      * @dev Deprecated. This function has issues similar to the ones found in
549      * {IERC20-approve}, and its usage is discouraged.
550      *
551      * Whenever possible, use {safeIncreaseAllowance} and
552      * {safeDecreaseAllowance} instead.
553      */
554     function safeApprove(IERC20 token, address spender, uint256 value) internal {
555         // safeApprove should only be called when setting an initial allowance,
556         // or when resetting it to zero. To increase and decrease it, use
557         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
558         // solhint-disable-next-line max-line-length
559         require((value == 0) || (token.allowance(address(this), spender) == 0),
560             "SafeERC20: approve from non-zero to non-zero allowance"
561         );
562         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
563     }
564 
565     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
566         uint256 newAllowance = token.allowance(address(this), spender).add(value);
567         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
568     }
569 
570     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
571         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
572         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
573     }
574 
575     /**
576      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
577      * on the return value: the return value is optional (but if data is returned, it must not be false).
578      * @param token The token targeted by the call.
579      * @param data The call data (encoded using abi.encode or one of its variants).
580      */
581     function _callOptionalReturn(IERC20 token, bytes memory data) private {
582         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
583         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
584         // the target address contains contract code and also asserts for success in the low-level call.
585 
586         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
587         if (returndata.length > 0) { // Return data is optional
588             // solhint-disable-next-line max-line-length
589             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
590         }
591     }
592 }
593 
594 // File: contracts/interfaces/IDMMFactory.sol
595 pragma solidity 0.6.12;
596 
597 
598 interface IDMMFactory {
599     function createPool(
600         IERC20 tokenA,
601         IERC20 tokenB,
602         uint32 ampBps
603     ) external returns (address pool);
604 
605     function setFeeConfiguration(address feeTo, uint16 governmentFeeBps) external;
606 
607     function setFeeToSetter(address) external;
608 
609     function getFeeConfiguration() external view returns (address feeTo, uint16 governmentFeeBps);
610 
611     function feeToSetter() external view returns (address);
612 
613     function allPools(uint256) external view returns (address pool);
614 
615     function allPoolsLength() external view returns (uint256);
616 
617     function getUnamplifiedPool(IERC20 token0, IERC20 token1) external view returns (address);
618 
619     function getPools(IERC20 token0, IERC20 token1)
620         external
621         view
622         returns (address[] memory _tokenPools);
623 
624     function isPool(
625         IERC20 token0,
626         IERC20 token1,
627         address pool
628     ) external view returns (bool);
629 }
630 
631 // File: contracts/interfaces/IWETH.sol
632 pragma solidity 0.6.12;
633 
634 
635 interface IWETH is IERC20 {
636     function deposit() external payable;
637 
638     function withdraw(uint256) external;
639 }
640 
641 // File: contracts/interfaces/IDMMExchangeRouter.sol
642 pragma solidity 0.6.12;
643 
644 
645 /// @dev an simple interface for integration dApp to swap
646 interface IDMMExchangeRouter {
647     function swapExactTokensForTokens(
648         uint256 amountIn,
649         uint256 amountOutMin,
650         address[] calldata poolsPath,
651         IERC20[] calldata path,
652         address to,
653         uint256 deadline
654     ) external returns (uint256[] memory amounts);
655 
656     function swapTokensForExactTokens(
657         uint256 amountOut,
658         uint256 amountInMax,
659         address[] calldata poolsPath,
660         IERC20[] calldata path,
661         address to,
662         uint256 deadline
663     ) external returns (uint256[] memory amounts);
664 
665     function swapExactETHForTokens(
666         uint256 amountOutMin,
667         address[] calldata poolsPath,
668         IERC20[] calldata path,
669         address to,
670         uint256 deadline
671     ) external payable returns (uint256[] memory amounts);
672 
673     function swapTokensForExactETH(
674         uint256 amountOut,
675         uint256 amountInMax,
676         address[] calldata poolsPath,
677         IERC20[] calldata path,
678         address to,
679         uint256 deadline
680     ) external returns (uint256[] memory amounts);
681 
682     function swapExactTokensForETH(
683         uint256 amountIn,
684         uint256 amountOutMin,
685         address[] calldata poolsPath,
686         IERC20[] calldata path,
687         address to,
688         uint256 deadline
689     ) external returns (uint256[] memory amounts);
690 
691     function swapETHForExactTokens(
692         uint256 amountOut,
693         address[] calldata poolsPath,
694         IERC20[] calldata path,
695         address to,
696         uint256 deadline
697     ) external payable returns (uint256[] memory amounts);
698 
699     function getAmountsOut(
700         uint256 amountIn,
701         address[] calldata poolsPath,
702         IERC20[] calldata path
703     ) external view returns (uint256[] memory amounts);
704 
705     function getAmountsIn(
706         uint256 amountOut,
707         address[] calldata poolsPath,
708         IERC20[] calldata path
709     ) external view returns (uint256[] memory amounts);
710 }
711 
712 // File: contracts/interfaces/IDMMLiquidityRouter.sol
713 pragma solidity 0.6.12;
714 
715 
716 /// @dev an simple interface for integration dApp to contribute liquidity
717 interface IDMMLiquidityRouter {
718     /**
719      * @param tokenA address of token in the pool
720      * @param tokenB address of token in the pool
721      * @param pool the address of the pool
722      * @param amountADesired the amount of tokenA users want to add to the pool
723      * @param amountBDesired the amount of tokenB users want to add to the pool
724      * @param amountAMin bounds to the extents to which amountB/amountA can go up
725      * @param amountBMin bounds to the extents to which amountB/amountA can go down
726      * @param vReserveRatioBounds bounds to the extents to which vReserveB/vReserveA can go (precision: 2 ** 112)
727      * @param to Recipient of the liquidity tokens.
728      * @param deadline Unix timestamp after which the transaction will revert.
729      */
730     function addLiquidity(
731         IERC20 tokenA,
732         IERC20 tokenB,
733         address pool,
734         uint256 amountADesired,
735         uint256 amountBDesired,
736         uint256 amountAMin,
737         uint256 amountBMin,
738         uint256[2] calldata vReserveRatioBounds,
739         address to,
740         uint256 deadline
741     )
742         external
743         returns (
744             uint256 amountA,
745             uint256 amountB,
746             uint256 liquidity
747         );
748 
749     function addLiquidityNewPool(
750         IERC20 tokenA,
751         IERC20 tokenB,
752         uint32 ampBps,
753         uint256 amountADesired,
754         uint256 amountBDesired,
755         uint256 amountAMin,
756         uint256 amountBMin,
757         address to,
758         uint256 deadline
759     )
760         external
761         returns (
762             uint256 amountA,
763             uint256 amountB,
764             uint256 liquidity
765         );
766 
767     function addLiquidityNewPoolETH(
768         IERC20 token,
769         uint32 ampBps,
770         uint256 amountTokenDesired,
771         uint256 amountTokenMin,
772         uint256 amountETHMin,
773         address to,
774         uint256 deadline
775     )
776         external
777         payable
778         returns (
779             uint256 amountToken,
780             uint256 amountETH,
781             uint256 liquidity
782         );
783 
784     /**
785      * @param token address of token in the pool
786      * @param pool the address of the pool
787      * @param amountTokenDesired the amount of token users want to add to the pool
788      * @dev   msg.value equals to amountEthDesired
789      * @param amountTokenMin bounds to the extents to which WETH/token can go up
790      * @param amountETHMin bounds to the extents to which WETH/token can go down
791      * @param vReserveRatioBounds bounds to the extents to which vReserveB/vReserveA can go (precision: 2 ** 112)
792      * @param to Recipient of the liquidity tokens.
793      * @param deadline Unix timestamp after which the transaction will revert.
794      */
795     function addLiquidityETH(
796         IERC20 token,
797         address pool,
798         uint256 amountTokenDesired,
799         uint256 amountTokenMin,
800         uint256 amountETHMin,
801         uint256[2] calldata vReserveRatioBounds,
802         address to,
803         uint256 deadline
804     )
805         external
806         payable
807         returns (
808             uint256 amountToken,
809             uint256 amountETH,
810             uint256 liquidity
811         );
812 
813     /**
814      * @param tokenA address of token in the pool
815      * @param tokenB address of token in the pool
816      * @param pool the address of the pool
817      * @param liquidity the amount of lp token users want to burn
818      * @param amountAMin the minimum token retuned after burning
819      * @param amountBMin the minimum token retuned after burning
820      * @param to Recipient of the returned tokens.
821      * @param deadline Unix timestamp after which the transaction will revert.
822      */
823     function removeLiquidity(
824         IERC20 tokenA,
825         IERC20 tokenB,
826         address pool,
827         uint256 liquidity,
828         uint256 amountAMin,
829         uint256 amountBMin,
830         address to,
831         uint256 deadline
832     ) external returns (uint256 amountA, uint256 amountB);
833 
834     /**
835      * @param tokenA address of token in the pool
836      * @param tokenB address of token in the pool
837      * @param pool the address of the pool
838      * @param liquidity the amount of lp token users want to burn
839      * @param amountAMin the minimum token retuned after burning
840      * @param amountBMin the minimum token retuned after burning
841      * @param to Recipient of the returned tokens.
842      * @param deadline Unix timestamp after which the transaction will revert.
843      * @param approveMax whether users permit the router spending max lp token or not.
844      * @param r s v Signature of user to permit the router spending lp token
845      */
846     function removeLiquidityWithPermit(
847         IERC20 tokenA,
848         IERC20 tokenB,
849         address pool,
850         uint256 liquidity,
851         uint256 amountAMin,
852         uint256 amountBMin,
853         address to,
854         uint256 deadline,
855         bool approveMax,
856         uint8 v,
857         bytes32 r,
858         bytes32 s
859     ) external returns (uint256 amountA, uint256 amountB);
860 
861     /**
862      * @param token address of token in the pool
863      * @param pool the address of the pool
864      * @param liquidity the amount of lp token users want to burn
865      * @param amountTokenMin the minimum token retuned after burning
866      * @param amountETHMin the minimum eth in wei retuned after burning
867      * @param to Recipient of the returned tokens.
868      * @param deadline Unix timestamp after which the transaction will revert
869      */
870     function removeLiquidityETH(
871         IERC20 token,
872         address pool,
873         uint256 liquidity,
874         uint256 amountTokenMin,
875         uint256 amountETHMin,
876         address to,
877         uint256 deadline
878     ) external returns (uint256 amountToken, uint256 amountETH);
879 
880     /**
881      * @param token address of token in the pool
882      * @param pool the address of the pool
883      * @param liquidity the amount of lp token users want to burn
884      * @param amountTokenMin the minimum token retuned after burning
885      * @param amountETHMin the minimum eth in wei retuned after burning
886      * @param to Recipient of the returned tokens.
887      * @param deadline Unix timestamp after which the transaction will revert
888      * @param approveMax whether users permit the router spending max lp token
889      * @param r s v signatures of user to permit the router spending lp token.
890      */
891     function removeLiquidityETHWithPermit(
892         IERC20 token,
893         address pool,
894         uint256 liquidity,
895         uint256 amountTokenMin,
896         uint256 amountETHMin,
897         address to,
898         uint256 deadline,
899         bool approveMax,
900         uint8 v,
901         bytes32 r,
902         bytes32 s
903     ) external returns (uint256 amountToken, uint256 amountETH);
904 
905     /**
906      * @param amountA amount of 1 side token added to the pool
907      * @param reserveA current reserve of the pool
908      * @param reserveB current reserve of the pool
909      * @return amountB amount of the other token added to the pool
910      */
911     function quote(
912         uint256 amountA,
913         uint256 reserveA,
914         uint256 reserveB
915     ) external pure returns (uint256 amountB);
916 }
917 
918 // File: contracts/interfaces/IDMMRouter01.sol
919 pragma solidity 0.6.12;
920 
921 
922 
923 
924 
925 /// @dev full interface for router
926 interface IDMMRouter01 is IDMMExchangeRouter, IDMMLiquidityRouter {
927     function factory() external pure returns (address);
928 
929     function weth() external pure returns (IWETH);
930 }
931 
932 // File: contracts/interfaces/IDMMRouter02.sol
933 pragma solidity 0.6.12;
934 
935 
936 interface IDMMRouter02 is IDMMRouter01 {
937     function removeLiquidityETHSupportingFeeOnTransferTokens(
938         IERC20 token,
939         address pool,
940         uint256 liquidity,
941         uint256 amountTokenMin,
942         uint256 amountETHMin,
943         address to,
944         uint256 deadline
945     ) external returns (uint256 amountETH);
946 
947     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
948         IERC20 token,
949         address pool,
950         uint256 liquidity,
951         uint256 amountTokenMin,
952         uint256 amountETHMin,
953         address to,
954         uint256 deadline,
955         bool approveMax,
956         uint8 v,
957         bytes32 r,
958         bytes32 s
959     ) external returns (uint256 amountETH);
960 
961     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
962         uint256 amountIn,
963         uint256 amountOutMin,
964         address[] calldata poolsPath,
965         IERC20[] calldata path,
966         address to,
967         uint256 deadline
968     ) external;
969 
970     function swapExactETHForTokensSupportingFeeOnTransferTokens(
971         uint256 amountOutMin,
972         address[] calldata poolsPath,
973         IERC20[] calldata path,
974         address to,
975         uint256 deadline
976     ) external payable;
977 
978     function swapExactTokensForETHSupportingFeeOnTransferTokens(
979         uint256 amountIn,
980         uint256 amountOutMin,
981         address[] calldata poolsPath,
982         IERC20[] calldata path,
983         address to,
984         uint256 deadline
985     ) external;
986 }
987 
988 // File: contracts/interfaces/IERC20Permit.sol
989 
990 pragma solidity 0.6.12;
991 
992 
993 interface IERC20Permit is IERC20 {
994     function permit(
995         address owner,
996         address spender,
997         uint256 value,
998         uint256 deadline,
999         uint8 v,
1000         bytes32 r,
1001         bytes32 s
1002     ) external;
1003 }
1004 
1005 // File: contracts/interfaces/IDMMPool.sol
1006 
1007 pragma solidity 0.6.12;
1008 
1009 
1010 
1011 interface IDMMPool {
1012     function mint(address to) external returns (uint256 liquidity);
1013 
1014     function burn(address to) external returns (uint256 amount0, uint256 amount1);
1015 
1016     function swap(
1017         uint256 amount0Out,
1018         uint256 amount1Out,
1019         address to,
1020         bytes calldata data
1021     ) external;
1022 
1023     function sync() external;
1024 
1025     function getReserves() external view returns (uint112 reserve0, uint112 reserve1);
1026 
1027     function getTradeInfo()
1028         external
1029         view
1030         returns (
1031             uint112 _vReserve0,
1032             uint112 _vReserve1,
1033             uint112 reserve0,
1034             uint112 reserve1,
1035             uint256 feeInPrecision
1036         );
1037 
1038     function token0() external view returns (IERC20);
1039 
1040     function token1() external view returns (IERC20);
1041 
1042     function ampBps() external view returns (uint32);
1043 
1044     function factory() external view returns (IDMMFactory);
1045 
1046     function kLast() external view returns (uint256);
1047 }
1048 
1049 // File: contracts/libraries/DMMLibrary.sol
1050 
1051 pragma solidity 0.6.12;
1052 
1053 
1054 
1055 
1056 library DMMLibrary {
1057     using SafeMath for uint256;
1058 
1059     uint256 public constant PRECISION = 1e18;
1060 
1061     // returns sorted token addresses, used to handle return values from pools sorted in this order
1062     function sortTokens(IERC20 tokenA, IERC20 tokenB)
1063         internal
1064         pure
1065         returns (IERC20 token0, IERC20 token1)
1066     {
1067         require(tokenA != tokenB, "DMMLibrary: IDENTICAL_ADDRESSES");
1068         (token0, token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
1069         require(address(token0) != address(0), "DMMLibrary: ZERO_ADDRESS");
1070     }
1071 
1072     /// @dev fetch the reserves and fee for a pool, used for trading purposes
1073     function getTradeInfo(
1074         address pool,
1075         IERC20 tokenA,
1076         IERC20 tokenB
1077     )
1078         internal
1079         view
1080         returns (
1081             uint256 reserveA,
1082             uint256 reserveB,
1083             uint256 vReserveA,
1084             uint256 vReserveB,
1085             uint256 feeInPrecision
1086         )
1087     {
1088         (IERC20 token0, ) = sortTokens(tokenA, tokenB);
1089         uint256 reserve0;
1090         uint256 reserve1;
1091         uint256 vReserve0;
1092         uint256 vReserve1;
1093         (reserve0, reserve1, vReserve0, vReserve1, feeInPrecision) = IDMMPool(pool).getTradeInfo();
1094         (reserveA, reserveB, vReserveA, vReserveB) = tokenA == token0
1095             ? (reserve0, reserve1, vReserve0, vReserve1)
1096             : (reserve1, reserve0, vReserve1, vReserve0);
1097     }
1098 
1099     /// @dev fetches the reserves for a pool, used for liquidity adding
1100     function getReserves(
1101         address pool,
1102         IERC20 tokenA,
1103         IERC20 tokenB
1104     ) internal view returns (uint256 reserveA, uint256 reserveB) {
1105         (IERC20 token0, ) = sortTokens(tokenA, tokenB);
1106         (uint256 reserve0, uint256 reserve1) = IDMMPool(pool).getReserves();
1107         (reserveA, reserveB) = tokenA == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
1108     }
1109 
1110     // given some amount of an asset and pool reserves, returns an equivalent amount of the other asset
1111     function quote(
1112         uint256 amountA,
1113         uint256 reserveA,
1114         uint256 reserveB
1115     ) internal pure returns (uint256 amountB) {
1116         require(amountA > 0, "DMMLibrary: INSUFFICIENT_AMOUNT");
1117         require(reserveA > 0 && reserveB > 0, "DMMLibrary: INSUFFICIENT_LIQUIDITY");
1118         amountB = amountA.mul(reserveB) / reserveA;
1119     }
1120 
1121     // given an input amount of an asset and pool reserves, returns the maximum output amount of the other asset
1122     function getAmountOut(
1123         uint256 amountIn,
1124         uint256 reserveIn,
1125         uint256 reserveOut,
1126         uint256 vReserveIn,
1127         uint256 vReserveOut,
1128         uint256 feeInPrecision
1129     ) internal pure returns (uint256 amountOut) {
1130         require(amountIn > 0, "DMMLibrary: INSUFFICIENT_INPUT_AMOUNT");
1131         require(reserveIn > 0 && reserveOut > 0, "DMMLibrary: INSUFFICIENT_LIQUIDITY");
1132         uint256 amountInWithFee = amountIn.mul(PRECISION.sub(feeInPrecision)).div(PRECISION);
1133         uint256 numerator = amountInWithFee.mul(vReserveOut);
1134         uint256 denominator = vReserveIn.add(amountInWithFee);
1135         amountOut = numerator.div(denominator);
1136         require(reserveOut > amountOut, "DMMLibrary: INSUFFICIENT_LIQUIDITY");
1137     }
1138 
1139     // given an output amount of an asset and pool reserves, returns a required input amount of the other asset
1140     function getAmountIn(
1141         uint256 amountOut,
1142         uint256 reserveIn,
1143         uint256 reserveOut,
1144         uint256 vReserveIn,
1145         uint256 vReserveOut,
1146         uint256 feeInPrecision
1147     ) internal pure returns (uint256 amountIn) {
1148         require(amountOut > 0, "DMMLibrary: INSUFFICIENT_OUTPUT_AMOUNT");
1149         require(reserveIn > 0 && reserveOut > amountOut, "DMMLibrary: INSUFFICIENT_LIQUIDITY");
1150         uint256 numerator = vReserveIn.mul(amountOut);
1151         uint256 denominator = vReserveOut.sub(amountOut);
1152         amountIn = numerator.div(denominator).add(1);
1153         // amountIn = floor(amountIN *PRECISION / (PRECISION - feeInPrecision));
1154         numerator = amountIn.mul(PRECISION);
1155         denominator = PRECISION.sub(feeInPrecision);
1156         amountIn = numerator.add(denominator - 1).div(denominator);
1157     }
1158 
1159     // performs chained getAmountOut calculations on any number of pools
1160     function getAmountsOut(
1161         uint256 amountIn,
1162         address[] memory poolsPath,
1163         IERC20[] memory path
1164     ) internal view returns (uint256[] memory amounts) {
1165         amounts = new uint256[](path.length);
1166         amounts[0] = amountIn;
1167         for (uint256 i; i < path.length - 1; i++) {
1168             (
1169                 uint256 reserveIn,
1170                 uint256 reserveOut,
1171                 uint256 vReserveIn,
1172                 uint256 vReserveOut,
1173                 uint256 feeInPrecision
1174             ) = getTradeInfo(poolsPath[i], path[i], path[i + 1]);
1175             amounts[i + 1] = getAmountOut(
1176                 amounts[i],
1177                 reserveIn,
1178                 reserveOut,
1179                 vReserveIn,
1180                 vReserveOut,
1181                 feeInPrecision
1182             );
1183         }
1184     }
1185 
1186     // performs chained getAmountIn calculations on any number of pools
1187     function getAmountsIn(
1188         uint256 amountOut,
1189         address[] memory poolsPath,
1190         IERC20[] memory path
1191     ) internal view returns (uint256[] memory amounts) {
1192         amounts = new uint256[](path.length);
1193         amounts[amounts.length - 1] = amountOut;
1194         for (uint256 i = path.length - 1; i > 0; i--) {
1195             (
1196                 uint256 reserveIn,
1197                 uint256 reserveOut,
1198                 uint256 vReserveIn,
1199                 uint256 vReserveOut,
1200                 uint256 feeInPrecision
1201             ) = getTradeInfo(poolsPath[i - 1], path[i - 1], path[i]);
1202             amounts[i - 1] = getAmountIn(
1203                 amounts[i],
1204                 reserveIn,
1205                 reserveOut,
1206                 vReserveIn,
1207                 vReserveOut,
1208                 feeInPrecision
1209             );
1210         }
1211     }
1212 }
1213 
1214 // File: contracts/periphery/DMMRouter02.sol
1215 pragma solidity 0.6.12;
1216 
1217 
1218 
1219 
1220 
1221 
1222 
1223 
1224 
1225 
1226 contract DMMRouter02 is IDMMRouter02 {
1227     using SafeERC20 for IERC20;
1228     using SafeERC20 for IWETH;
1229     using SafeMath for uint256;
1230 
1231     uint256 internal constant BPS = 10000;
1232     uint256 internal constant MIN_VRESERVE_RATIO = 0;
1233     uint256 internal constant MAX_VRESERVE_RATIO = 2**256 - 1;
1234     uint256 internal constant Q112 = 2**112;
1235 
1236     address public immutable override factory;
1237     IWETH public immutable override weth;
1238 
1239     modifier ensure(uint256 deadline) {
1240         require(deadline >= block.timestamp, "DMMRouter: EXPIRED");
1241         _;
1242     }
1243 
1244     constructor(address _factory, IWETH _weth) public {
1245         factory = _factory;
1246         weth = _weth;
1247     }
1248 
1249     receive() external payable {
1250         assert(msg.sender == address(weth)); // only accept ETH via fallback from the WETH contract
1251     }
1252 
1253     // **** ADD LIQUIDITY ****
1254     function _addLiquidity(
1255         IERC20 tokenA,
1256         IERC20 tokenB,
1257         address pool,
1258         uint256 amountADesired,
1259         uint256 amountBDesired,
1260         uint256 amountAMin,
1261         uint256 amountBMin,
1262         uint256[2] memory vReserveRatioBounds
1263     ) internal virtual view returns (uint256 amountA, uint256 amountB) {
1264         (uint256 reserveA, uint256 reserveB, uint256 vReserveA, uint256 vReserveB, ) = DMMLibrary
1265             .getTradeInfo(pool, tokenA, tokenB);
1266         if (reserveA == 0 && reserveB == 0) {
1267             (amountA, amountB) = (amountADesired, amountBDesired);
1268         } else {
1269             uint256 amountBOptimal = DMMLibrary.quote(amountADesired, reserveA, reserveB);
1270             if (amountBOptimal <= amountBDesired) {
1271                 require(amountBOptimal >= amountBMin, "DMMRouter: INSUFFICIENT_B_AMOUNT");
1272                 (amountA, amountB) = (amountADesired, amountBOptimal);
1273             } else {
1274                 uint256 amountAOptimal = DMMLibrary.quote(amountBDesired, reserveB, reserveA);
1275                 assert(amountAOptimal <= amountADesired);
1276                 require(amountAOptimal >= amountAMin, "DMMRouter: INSUFFICIENT_A_AMOUNT");
1277                 (amountA, amountB) = (amountAOptimal, amountBDesired);
1278             }
1279             uint256 currentRate = (vReserveB * Q112) / vReserveA;
1280             require(
1281                 currentRate >= vReserveRatioBounds[0] && currentRate <= vReserveRatioBounds[1],
1282                 "DMMRouter: OUT_OF_BOUNDS_VRESERVE"
1283             );
1284         }
1285     }
1286 
1287     function addLiquidity(
1288         IERC20 tokenA,
1289         IERC20 tokenB,
1290         address pool,
1291         uint256 amountADesired,
1292         uint256 amountBDesired,
1293         uint256 amountAMin,
1294         uint256 amountBMin,
1295         uint256[2] memory vReserveRatioBounds,
1296         address to,
1297         uint256 deadline
1298     )
1299         public
1300         virtual
1301         override
1302         ensure(deadline)
1303         returns (
1304             uint256 amountA,
1305             uint256 amountB,
1306             uint256 liquidity
1307         )
1308     {
1309         verifyPoolAddress(tokenA, tokenB, pool);
1310         (amountA, amountB) = _addLiquidity(
1311             tokenA,
1312             tokenB,
1313             pool,
1314             amountADesired,
1315             amountBDesired,
1316             amountAMin,
1317             amountBMin,
1318             vReserveRatioBounds
1319         );
1320         // using tokenA.safeTransferFrom will get "Stack too deep"
1321         SafeERC20.safeTransferFrom(tokenA, msg.sender, pool, amountA);
1322         SafeERC20.safeTransferFrom(tokenB, msg.sender, pool, amountB);
1323         liquidity = IDMMPool(pool).mint(to);
1324     }
1325 
1326     function addLiquidityETH(
1327         IERC20 token,
1328         address pool,
1329         uint256 amountTokenDesired,
1330         uint256 amountTokenMin,
1331         uint256 amountETHMin,
1332         uint256[2] memory vReserveRatioBounds,
1333         address to,
1334         uint256 deadline
1335     )
1336         public
1337         override
1338         payable
1339         ensure(deadline)
1340         returns (
1341             uint256 amountToken,
1342             uint256 amountETH,
1343             uint256 liquidity
1344         )
1345     {
1346         verifyPoolAddress(token, weth, pool);
1347         (amountToken, amountETH) = _addLiquidity(
1348             token,
1349             weth,
1350             pool,
1351             amountTokenDesired,
1352             msg.value,
1353             amountTokenMin,
1354             amountETHMin,
1355             vReserveRatioBounds
1356         );
1357         token.safeTransferFrom(msg.sender, pool, amountToken);
1358         weth.deposit{value: amountETH}();
1359         weth.safeTransfer(pool, amountETH);
1360         liquidity = IDMMPool(pool).mint(to);
1361         // refund dust eth, if any
1362         if (msg.value > amountETH) {
1363             TransferHelper.safeTransferETH(msg.sender, msg.value - amountETH);
1364         }
1365     }
1366 
1367     function addLiquidityNewPool(
1368         IERC20 tokenA,
1369         IERC20 tokenB,
1370         uint32 ampBps,
1371         uint256 amountADesired,
1372         uint256 amountBDesired,
1373         uint256 amountAMin,
1374         uint256 amountBMin,
1375         address to,
1376         uint256 deadline
1377     )
1378         external
1379         override
1380         returns (
1381             uint256 amountA,
1382             uint256 amountB,
1383             uint256 liquidity
1384         )
1385     {
1386         address pool;
1387         if (ampBps == BPS) {
1388             pool = IDMMFactory(factory).getUnamplifiedPool(tokenA, tokenB);
1389         }
1390         if (pool == address(0)) {
1391             pool = IDMMFactory(factory).createPool(tokenA, tokenB, ampBps);
1392         }
1393         // if we add liquidity to an existing pool, this is an unamplifed pool
1394         // so there is no need for bounds of virtual reserve ratio
1395         uint256[2] memory vReserveRatioBounds = [MIN_VRESERVE_RATIO, MAX_VRESERVE_RATIO];
1396         (amountA, amountB, liquidity) = addLiquidity(
1397             tokenA,
1398             tokenB,
1399             pool,
1400             amountADesired,
1401             amountBDesired,
1402             amountAMin,
1403             amountBMin,
1404             vReserveRatioBounds,
1405             to,
1406             deadline
1407         );
1408     }
1409 
1410     function addLiquidityNewPoolETH(
1411         IERC20 token,
1412         uint32 ampBps,
1413         uint256 amountTokenDesired,
1414         uint256 amountTokenMin,
1415         uint256 amountETHMin,
1416         address to,
1417         uint256 deadline
1418     )
1419         external
1420         override
1421         payable
1422         returns (
1423             uint256 amountToken,
1424             uint256 amountETH,
1425             uint256 liquidity
1426         )
1427     {
1428         address pool;
1429         if (ampBps == BPS) {
1430             pool = IDMMFactory(factory).getUnamplifiedPool(token, weth);
1431         }
1432         if (pool == address(0)) {
1433             pool = IDMMFactory(factory).createPool(token, weth, ampBps);
1434         }
1435         // if we add liquidity to an existing pool, this is an unamplifed pool
1436         // so there is no need for bounds of virtual reserve ratio
1437         uint256[2] memory vReserveRatioBounds = [MIN_VRESERVE_RATIO, MAX_VRESERVE_RATIO];
1438         (amountToken, amountETH, liquidity) = addLiquidityETH(
1439             token,
1440             pool,
1441             amountTokenDesired,
1442             amountTokenMin,
1443             amountETHMin,
1444             vReserveRatioBounds,
1445             to,
1446             deadline
1447         );
1448     }
1449 
1450     // **** REMOVE LIQUIDITY ****
1451     function removeLiquidity(
1452         IERC20 tokenA,
1453         IERC20 tokenB,
1454         address pool,
1455         uint256 liquidity,
1456         uint256 amountAMin,
1457         uint256 amountBMin,
1458         address to,
1459         uint256 deadline
1460     ) public override ensure(deadline) returns (uint256 amountA, uint256 amountB) {
1461         verifyPoolAddress(tokenA, tokenB, pool);
1462         IERC20(pool).safeTransferFrom(msg.sender, pool, liquidity); // send liquidity to pool
1463         (uint256 amount0, uint256 amount1) = IDMMPool(pool).burn(to);
1464         (IERC20 token0, ) = DMMLibrary.sortTokens(tokenA, tokenB);
1465         (amountA, amountB) = tokenA == token0 ? (amount0, amount1) : (amount1, amount0);
1466         require(amountA >= amountAMin, "DMMRouter: INSUFFICIENT_A_AMOUNT");
1467         require(amountB >= amountBMin, "DMMRouter: INSUFFICIENT_B_AMOUNT");
1468     }
1469 
1470     function removeLiquidityETH(
1471         IERC20 token,
1472         address pool,
1473         uint256 liquidity,
1474         uint256 amountTokenMin,
1475         uint256 amountETHMin,
1476         address to,
1477         uint256 deadline
1478     ) public override ensure(deadline) returns (uint256 amountToken, uint256 amountETH) {
1479         (amountToken, amountETH) = removeLiquidity(
1480             token,
1481             weth,
1482             pool,
1483             liquidity,
1484             amountTokenMin,
1485             amountETHMin,
1486             address(this),
1487             deadline
1488         );
1489         token.safeTransfer(to, amountToken);
1490         IWETH(weth).withdraw(amountETH);
1491         TransferHelper.safeTransferETH(to, amountETH);
1492     }
1493 
1494     function removeLiquidityWithPermit(
1495         IERC20 tokenA,
1496         IERC20 tokenB,
1497         address pool,
1498         uint256 liquidity,
1499         uint256 amountAMin,
1500         uint256 amountBMin,
1501         address to,
1502         uint256 deadline,
1503         bool approveMax,
1504         uint8 v,
1505         bytes32 r,
1506         bytes32 s
1507     ) external virtual override returns (uint256 amountA, uint256 amountB) {
1508         uint256 value = approveMax ? uint256(-1) : liquidity;
1509         IERC20Permit(pool).permit(msg.sender, address(this), value, deadline, v, r, s);
1510         (amountA, amountB) = removeLiquidity(
1511             tokenA,
1512             tokenB,
1513             pool,
1514             liquidity,
1515             amountAMin,
1516             amountBMin,
1517             to,
1518             deadline
1519         );
1520     }
1521 
1522     function removeLiquidityETHWithPermit(
1523         IERC20 token,
1524         address pool,
1525         uint256 liquidity,
1526         uint256 amountTokenMin,
1527         uint256 amountETHMin,
1528         address to,
1529         uint256 deadline,
1530         bool approveMax,
1531         uint8 v,
1532         bytes32 r,
1533         bytes32 s
1534     ) external override returns (uint256 amountToken, uint256 amountETH) {
1535         uint256 value = approveMax ? uint256(-1) : liquidity;
1536         IERC20Permit(pool).permit(msg.sender, address(this), value, deadline, v, r, s);
1537         (amountToken, amountETH) = removeLiquidityETH(
1538             token,
1539             pool,
1540             liquidity,
1541             amountTokenMin,
1542             amountETHMin,
1543             to,
1544             deadline
1545         );
1546     }
1547 
1548     // **** REMOVE LIQUIDITY (supporting fee-on-transfer tokens) ****
1549 
1550     function removeLiquidityETHSupportingFeeOnTransferTokens(
1551         IERC20 token,
1552         address pool,
1553         uint256 liquidity,
1554         uint256 amountTokenMin,
1555         uint256 amountETHMin,
1556         address to,
1557         uint256 deadline
1558     ) public override ensure(deadline) returns (uint256 amountETH) {
1559         (, amountETH) = removeLiquidity(
1560             token,
1561             weth,
1562             pool,
1563             liquidity,
1564             amountTokenMin,
1565             amountETHMin,
1566             address(this),
1567             deadline
1568         );
1569         token.safeTransfer(to, IERC20(token).balanceOf(address(this)));
1570         IWETH(weth).withdraw(amountETH);
1571         TransferHelper.safeTransferETH(to, amountETH);
1572     }
1573 
1574     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
1575         IERC20 token,
1576         address pool,
1577         uint256 liquidity,
1578         uint256 amountTokenMin,
1579         uint256 amountETHMin,
1580         address to,
1581         uint256 deadline,
1582         bool approveMax,
1583         uint8 v,
1584         bytes32 r,
1585         bytes32 s
1586     ) external override returns (uint256 amountETH) {
1587         uint256 value = approveMax ? uint256(-1) : liquidity;
1588         IERC20Permit(pool).permit(msg.sender, address(this), value, deadline, v, r, s);
1589         amountETH = removeLiquidityETHSupportingFeeOnTransferTokens(
1590             token,
1591             pool,
1592             liquidity,
1593             amountTokenMin,
1594             amountETHMin,
1595             to,
1596             deadline
1597         );
1598     }
1599 
1600     // **** SWAP ****
1601     // requires the initial amount to have already been sent to the first pool
1602     function _swap(
1603         uint256[] memory amounts,
1604         address[] memory poolsPath,
1605         IERC20[] memory path,
1606         address _to
1607     ) private {
1608         for (uint256 i; i < path.length - 1; i++) {
1609             (IERC20 input, IERC20 output) = (path[i], path[i + 1]);
1610             (IERC20 token0, ) = DMMLibrary.sortTokens(input, output);
1611             uint256 amountOut = amounts[i + 1];
1612             (uint256 amount0Out, uint256 amount1Out) = input == token0
1613                 ? (uint256(0), amountOut)
1614                 : (amountOut, uint256(0));
1615             address to = i < path.length - 2 ? poolsPath[i + 1] : _to;
1616             IDMMPool(poolsPath[i]).swap(amount0Out, amount1Out, to, new bytes(0));
1617         }
1618     }
1619 
1620     function swapExactTokensForTokens(
1621         uint256 amountIn,
1622         uint256 amountOutMin,
1623         address[] memory poolsPath,
1624         IERC20[] memory path,
1625         address to,
1626         uint256 deadline
1627     ) public virtual override ensure(deadline) returns (uint256[] memory amounts) {
1628         verifyPoolsPathSwap(poolsPath, path);
1629         amounts = DMMLibrary.getAmountsOut(amountIn, poolsPath, path);
1630         require(
1631             amounts[amounts.length - 1] >= amountOutMin,
1632             "DMMRouter: INSUFFICIENT_OUTPUT_AMOUNT"
1633         );
1634         IERC20(path[0]).safeTransferFrom(msg.sender, poolsPath[0], amounts[0]);
1635         _swap(amounts, poolsPath, path, to);
1636     }
1637 
1638     function swapTokensForExactTokens(
1639         uint256 amountOut,
1640         uint256 amountInMax,
1641         address[] memory poolsPath,
1642         IERC20[] memory path,
1643         address to,
1644         uint256 deadline
1645     ) public override ensure(deadline) returns (uint256[] memory amounts) {
1646         verifyPoolsPathSwap(poolsPath, path);
1647         amounts = DMMLibrary.getAmountsIn(amountOut, poolsPath, path);
1648         require(amounts[0] <= amountInMax, "DMMRouter: EXCESSIVE_INPUT_AMOUNT");
1649         path[0].safeTransferFrom(msg.sender, poolsPath[0], amounts[0]);
1650         _swap(amounts, poolsPath, path, to);
1651     }
1652 
1653     function swapExactETHForTokens(
1654         uint256 amountOutMin,
1655         address[] calldata poolsPath,
1656         IERC20[] calldata path,
1657         address to,
1658         uint256 deadline
1659     ) external override payable ensure(deadline) returns (uint256[] memory amounts) {
1660         require(path[0] == weth, "DMMRouter: INVALID_PATH");
1661         verifyPoolsPathSwap(poolsPath, path);
1662         amounts = DMMLibrary.getAmountsOut(msg.value, poolsPath, path);
1663         require(
1664             amounts[amounts.length - 1] >= amountOutMin,
1665             "DMMRouter: INSUFFICIENT_OUTPUT_AMOUNT"
1666         );
1667         IWETH(weth).deposit{value: amounts[0]}();
1668         weth.safeTransfer(poolsPath[0], amounts[0]);
1669         _swap(amounts, poolsPath, path, to);
1670     }
1671 
1672     function swapTokensForExactETH(
1673         uint256 amountOut,
1674         uint256 amountInMax,
1675         address[] calldata poolsPath,
1676         IERC20[] calldata path,
1677         address to,
1678         uint256 deadline
1679     ) external override ensure(deadline) returns (uint256[] memory amounts) {
1680         require(path[path.length - 1] == weth, "DMMRouter: INVALID_PATH");
1681         verifyPoolsPathSwap(poolsPath, path);
1682         amounts = DMMLibrary.getAmountsIn(amountOut, poolsPath, path);
1683         require(amounts[0] <= amountInMax, "DMMRouter: EXCESSIVE_INPUT_AMOUNT");
1684         path[0].safeTransferFrom(msg.sender, poolsPath[0], amounts[0]);
1685         _swap(amounts, poolsPath, path, address(this));
1686         IWETH(weth).withdraw(amounts[amounts.length - 1]);
1687         TransferHelper.safeTransferETH(to, amounts[amounts.length - 1]);
1688     }
1689 
1690     function swapExactTokensForETH(
1691         uint256 amountIn,
1692         uint256 amountOutMin,
1693         address[] calldata poolsPath,
1694         IERC20[] calldata path,
1695         address to,
1696         uint256 deadline
1697     ) external override ensure(deadline) returns (uint256[] memory amounts) {
1698         require(path[path.length - 1] == weth, "DMMRouter: INVALID_PATH");
1699         verifyPoolsPathSwap(poolsPath, path);
1700         amounts = DMMLibrary.getAmountsOut(amountIn, poolsPath, path);
1701         require(
1702             amounts[amounts.length - 1] >= amountOutMin,
1703             "DMMRouter: INSUFFICIENT_OUTPUT_AMOUNT"
1704         );
1705         path[0].safeTransferFrom(msg.sender, poolsPath[0], amounts[0]);
1706         _swap(amounts, poolsPath, path, address(this));
1707         IWETH(weth).withdraw(amounts[amounts.length - 1]);
1708         TransferHelper.safeTransferETH(to, amounts[amounts.length - 1]);
1709     }
1710 
1711     function swapETHForExactTokens(
1712         uint256 amountOut,
1713         address[] calldata poolsPath,
1714         IERC20[] calldata path,
1715         address to,
1716         uint256 deadline
1717     ) external override payable ensure(deadline) returns (uint256[] memory amounts) {
1718         require(path[0] == weth, "DMMRouter: INVALID_PATH");
1719         verifyPoolsPathSwap(poolsPath, path);
1720         amounts = DMMLibrary.getAmountsIn(amountOut, poolsPath, path);
1721         require(amounts[0] <= msg.value, "DMMRouter: EXCESSIVE_INPUT_AMOUNT");
1722         IWETH(weth).deposit{value: amounts[0]}();
1723         weth.safeTransfer(poolsPath[0], amounts[0]);
1724         _swap(amounts, poolsPath, path, to);
1725         // refund dust eth, if any
1726         if (msg.value > amounts[0]) {
1727             TransferHelper.safeTransferETH(msg.sender, msg.value - amounts[0]);
1728         }
1729     }
1730 
1731     // **** SWAP (supporting fee-on-transfer tokens) ****
1732     // requires the initial amount to have already been sent to the first pool
1733     function _swapSupportingFeeOnTransferTokens(
1734         address[] memory poolsPath,
1735         IERC20[] memory path,
1736         address _to
1737     ) internal {
1738         verifyPoolsPathSwap(poolsPath, path);
1739         for (uint256 i; i < path.length - 1; i++) {
1740             (IERC20 input, IERC20 output) = (path[i], path[i + 1]);
1741             (IERC20 token0, ) = DMMLibrary.sortTokens(input, output);
1742             IDMMPool pool = IDMMPool(poolsPath[i]);
1743             uint256 amountOutput;
1744             {
1745                 // scope to avoid stack too deep errors
1746                 (
1747                     uint256 reserveIn,
1748                     uint256 reserveOut,
1749                     uint256 vReserveIn,
1750                     uint256 vReserveOut,
1751                     uint256 feeInPrecision
1752                 ) = DMMLibrary.getTradeInfo(poolsPath[i], input, output);
1753                 uint256 amountInput = IERC20(input).balanceOf(address(pool)).sub(reserveIn);
1754                 amountOutput = DMMLibrary.getAmountOut(
1755                     amountInput,
1756                     reserveIn,
1757                     reserveOut,
1758                     vReserveIn,
1759                     vReserveOut,
1760                     feeInPrecision
1761                 );
1762             }
1763             (uint256 amount0Out, uint256 amount1Out) = input == token0
1764                 ? (uint256(0), amountOutput)
1765                 : (amountOutput, uint256(0));
1766             address to = i < path.length - 2 ? poolsPath[i + 1] : _to;
1767             pool.swap(amount0Out, amount1Out, to, new bytes(0));
1768         }
1769     }
1770 
1771     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
1772         uint256 amountIn,
1773         uint256 amountOutMin,
1774         address[] memory poolsPath,
1775         IERC20[] memory path,
1776         address to,
1777         uint256 deadline
1778     ) public override ensure(deadline) {
1779         path[0].safeTransferFrom(msg.sender, poolsPath[0], amountIn);
1780         uint256 balanceBefore = path[path.length - 1].balanceOf(to);
1781         _swapSupportingFeeOnTransferTokens(poolsPath, path, to);
1782         uint256 balanceAfter = path[path.length - 1].balanceOf(to);
1783         require(
1784             balanceAfter >= balanceBefore.add(amountOutMin),
1785             "DMMRouter: INSUFFICIENT_OUTPUT_AMOUNT"
1786         );
1787     }
1788 
1789     function swapExactETHForTokensSupportingFeeOnTransferTokens(
1790         uint256 amountOutMin,
1791         address[] calldata poolsPath,
1792         IERC20[] calldata path,
1793         address to,
1794         uint256 deadline
1795     ) external override payable ensure(deadline) {
1796         require(path[0] == weth, "DMMRouter: INVALID_PATH");
1797         uint256 amountIn = msg.value;
1798         IWETH(weth).deposit{value: amountIn}();
1799         weth.safeTransfer(poolsPath[0], amountIn);
1800         uint256 balanceBefore = IERC20(path[path.length - 1]).balanceOf(to);
1801         _swapSupportingFeeOnTransferTokens(poolsPath, path, to);
1802         require(
1803             path[path.length - 1].balanceOf(to).sub(balanceBefore) >= amountOutMin,
1804             "DMMRouter: INSUFFICIENT_OUTPUT_AMOUNT"
1805         );
1806     }
1807 
1808     function swapExactTokensForETHSupportingFeeOnTransferTokens(
1809         uint256 amountIn,
1810         uint256 amountOutMin,
1811         address[] calldata poolsPath,
1812         IERC20[] calldata path,
1813         address to,
1814         uint256 deadline
1815     ) external override ensure(deadline) {
1816         require(path[path.length - 1] == weth, "DMMRouter: INVALID_PATH");
1817         path[0].safeTransferFrom(msg.sender, poolsPath[0], amountIn);
1818         _swapSupportingFeeOnTransferTokens(poolsPath, path, address(this));
1819         uint256 amountOut = IWETH(weth).balanceOf(address(this));
1820         require(amountOut >= amountOutMin, "DMMRouter: INSUFFICIENT_OUTPUT_AMOUNT");
1821         IWETH(weth).withdraw(amountOut);
1822         TransferHelper.safeTransferETH(to, amountOut);
1823     }
1824 
1825     // **** LIBRARY FUNCTIONS ****
1826 
1827     /// @dev get the amount of tokenB for adding liquidity with given amount of token A and the amount of tokens in the pool
1828     function quote(
1829         uint256 amountA,
1830         uint256 reserveA,
1831         uint256 reserveB
1832     ) external override pure returns (uint256 amountB) {
1833         return DMMLibrary.quote(amountA, reserveA, reserveB);
1834     }
1835 
1836     function getAmountsOut(
1837         uint256 amountIn,
1838         address[] calldata poolsPath,
1839         IERC20[] calldata path
1840     ) external override view returns (uint256[] memory amounts) {
1841         verifyPoolsPathSwap(poolsPath, path);
1842         return DMMLibrary.getAmountsOut(amountIn, poolsPath, path);
1843     }
1844 
1845     function getAmountsIn(
1846         uint256 amountOut,
1847         address[] calldata poolsPath,
1848         IERC20[] calldata path
1849     ) external override view returns (uint256[] memory amounts) {
1850         verifyPoolsPathSwap(poolsPath, path);
1851         return DMMLibrary.getAmountsIn(amountOut, poolsPath, path);
1852     }
1853 
1854     function verifyPoolsPathSwap(address[] memory poolsPath, IERC20[] memory path) internal view {
1855         require(path.length >= 2, "DMMRouter: INVALID_PATH");
1856         require(poolsPath.length == path.length - 1, "DMMRouter: INVALID_POOLS_PATH");
1857         for (uint256 i = 0; i < poolsPath.length; i++) {
1858             verifyPoolAddress(path[i], path[i + 1], poolsPath[i]);
1859         }
1860     }
1861 
1862     function verifyPoolAddress(
1863         IERC20 tokenA,
1864         IERC20 tokenB,
1865         address pool
1866     ) internal view {
1867         require(IDMMFactory(factory).isPool(tokenA, tokenB, pool), "DMMRouter: INVALID_POOL");
1868     }
1869 }