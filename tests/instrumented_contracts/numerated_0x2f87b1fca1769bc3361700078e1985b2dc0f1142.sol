1 // File: @openzeppelin/contracts/math/SafeMath.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity >=0.6.0 <0.8.0;
6 
7 /**
8  * @dev Wrappers over Solidity's arithmetic operations with added overflow
9  * checks.
10  *
11  * Arithmetic operations in Solidity wrap on overflow. This can easily result
12  * in bugs, because programmers usually assume that an overflow raises an
13  * error, which is the standard behavior in high level programming languages.
14  * `SafeMath` restores this intuition by reverting the transaction when an
15  * operation overflows.
16  *
17  * Using this library instead of the unchecked operations eliminates an entire
18  * class of bugs, so it's recommended to use it always.
19  */
20 library SafeMath {
21     /**
22      * @dev Returns the addition of two unsigned integers, with an overflow flag.
23      *
24      * _Available since v3.4._
25      */
26     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
27         uint256 c = a + b;
28         if (c < a) return (false, 0);
29         return (true, c);
30     }
31 
32     /**
33      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
34      *
35      * _Available since v3.4._
36      */
37     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
38         if (b > a) return (false, 0);
39         return (true, a - b);
40     }
41 
42     /**
43      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
44      *
45      * _Available since v3.4._
46      */
47     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
48         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
49         // benefit is lost if 'b' is also tested.
50         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
51         if (a == 0) return (true, 0);
52         uint256 c = a * b;
53         if (c / a != b) return (false, 0);
54         return (true, c);
55     }
56 
57     /**
58      * @dev Returns the division of two unsigned integers, with a division by zero flag.
59      *
60      * _Available since v3.4._
61      */
62     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
63         if (b == 0) return (false, 0);
64         return (true, a / b);
65     }
66 
67     /**
68      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
69      *
70      * _Available since v3.4._
71      */
72     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
73         if (b == 0) return (false, 0);
74         return (true, a % b);
75     }
76 
77     /**
78      * @dev Returns the addition of two unsigned integers, reverting on
79      * overflow.
80      *
81      * Counterpart to Solidity's `+` operator.
82      *
83      * Requirements:
84      *
85      * - Addition cannot overflow.
86      */
87     function add(uint256 a, uint256 b) internal pure returns (uint256) {
88         uint256 c = a + b;
89         require(c >= a, "SafeMath: addition overflow");
90         return c;
91     }
92 
93     /**
94      * @dev Returns the subtraction of two unsigned integers, reverting on
95      * overflow (when the result is negative).
96      *
97      * Counterpart to Solidity's `-` operator.
98      *
99      * Requirements:
100      *
101      * - Subtraction cannot overflow.
102      */
103     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
104         require(b <= a, "SafeMath: subtraction overflow");
105         return a - b;
106     }
107 
108     /**
109      * @dev Returns the multiplication of two unsigned integers, reverting on
110      * overflow.
111      *
112      * Counterpart to Solidity's `*` operator.
113      *
114      * Requirements:
115      *
116      * - Multiplication cannot overflow.
117      */
118     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
119         if (a == 0) return 0;
120         uint256 c = a * b;
121         require(c / a == b, "SafeMath: multiplication overflow");
122         return c;
123     }
124 
125     /**
126      * @dev Returns the integer division of two unsigned integers, reverting on
127      * division by zero. The result is rounded towards zero.
128      *
129      * Counterpart to Solidity's `/` operator. Note: this function uses a
130      * `revert` opcode (which leaves remaining gas untouched) while Solidity
131      * uses an invalid opcode to revert (consuming all remaining gas).
132      *
133      * Requirements:
134      *
135      * - The divisor cannot be zero.
136      */
137     function div(uint256 a, uint256 b) internal pure returns (uint256) {
138         require(b > 0, "SafeMath: division by zero");
139         return a / b;
140     }
141 
142     /**
143      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
144      * reverting when dividing by zero.
145      *
146      * Counterpart to Solidity's `%` operator. This function uses a `revert`
147      * opcode (which leaves remaining gas untouched) while Solidity uses an
148      * invalid opcode to revert (consuming all remaining gas).
149      *
150      * Requirements:
151      *
152      * - The divisor cannot be zero.
153      */
154     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
155         require(b > 0, "SafeMath: modulo by zero");
156         return a % b;
157     }
158 
159     /**
160      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
161      * overflow (when the result is negative).
162      *
163      * CAUTION: This function is deprecated because it requires allocating memory for the error
164      * message unnecessarily. For custom revert reasons use {trySub}.
165      *
166      * Counterpart to Solidity's `-` operator.
167      *
168      * Requirements:
169      *
170      * - Subtraction cannot overflow.
171      */
172     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
173         require(b <= a, errorMessage);
174         return a - b;
175     }
176 
177     /**
178      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
179      * division by zero. The result is rounded towards zero.
180      *
181      * CAUTION: This function is deprecated because it requires allocating memory for the error
182      * message unnecessarily. For custom revert reasons use {tryDiv}.
183      *
184      * Counterpart to Solidity's `/` operator. Note: this function uses a
185      * `revert` opcode (which leaves remaining gas untouched) while Solidity
186      * uses an invalid opcode to revert (consuming all remaining gas).
187      *
188      * Requirements:
189      *
190      * - The divisor cannot be zero.
191      */
192     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
193         require(b > 0, errorMessage);
194         return a / b;
195     }
196 
197     /**
198      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
199      * reverting with custom message when dividing by zero.
200      *
201      * CAUTION: This function is deprecated because it requires allocating memory for the error
202      * message unnecessarily. For custom revert reasons use {tryMod}.
203      *
204      * Counterpart to Solidity's `%` operator. This function uses a `revert`
205      * opcode (which leaves remaining gas untouched) while Solidity uses an
206      * invalid opcode to revert (consuming all remaining gas).
207      *
208      * Requirements:
209      *
210      * - The divisor cannot be zero.
211      */
212     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
213         require(b > 0, errorMessage);
214         return a % b;
215     }
216 }
217 
218 // File: @openzeppelin/contracts/math/Math.sol
219 
220 
221 
222 pragma solidity >=0.6.0 <0.8.0;
223 
224 /**
225  * @dev Standard math utilities missing in the Solidity language.
226  */
227 library Math {
228     /**
229      * @dev Returns the largest of two numbers.
230      */
231     function max(uint256 a, uint256 b) internal pure returns (uint256) {
232         return a >= b ? a : b;
233     }
234 
235     /**
236      * @dev Returns the smallest of two numbers.
237      */
238     function min(uint256 a, uint256 b) internal pure returns (uint256) {
239         return a < b ? a : b;
240     }
241 
242     /**
243      * @dev Returns the average of two numbers. The result is rounded towards
244      * zero.
245      */
246     function average(uint256 a, uint256 b) internal pure returns (uint256) {
247         // (a + b) / 2 can overflow, so we distribute
248         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
249     }
250 }
251 
252 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
253 
254 
255 
256 pragma solidity >=0.6.0 <0.8.0;
257 
258 /**
259  * @dev Interface of the ERC20 standard as defined in the EIP.
260  */
261 interface IERC20 {
262     /**
263      * @dev Returns the amount of tokens in existence.
264      */
265     function totalSupply() external view returns (uint256);
266 
267     /**
268      * @dev Returns the amount of tokens owned by `account`.
269      */
270     function balanceOf(address account) external view returns (uint256);
271 
272     /**
273      * @dev Moves `amount` tokens from the caller's account to `recipient`.
274      *
275      * Returns a boolean value indicating whether the operation succeeded.
276      *
277      * Emits a {Transfer} event.
278      */
279     function transfer(address recipient, uint256 amount) external returns (bool);
280 
281     /**
282      * @dev Returns the remaining number of tokens that `spender` will be
283      * allowed to spend on behalf of `owner` through {transferFrom}. This is
284      * zero by default.
285      *
286      * This value changes when {approve} or {transferFrom} are called.
287      */
288     function allowance(address owner, address spender) external view returns (uint256);
289 
290     /**
291      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
292      *
293      * Returns a boolean value indicating whether the operation succeeded.
294      *
295      * IMPORTANT: Beware that changing an allowance with this method brings the risk
296      * that someone may use both the old and the new allowance by unfortunate
297      * transaction ordering. One possible solution to mitigate this race
298      * condition is to first reduce the spender's allowance to 0 and set the
299      * desired value afterwards:
300      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
301      *
302      * Emits an {Approval} event.
303      */
304     function approve(address spender, uint256 amount) external returns (bool);
305 
306     /**
307      * @dev Moves `amount` tokens from `sender` to `recipient` using the
308      * allowance mechanism. `amount` is then deducted from the caller's
309      * allowance.
310      *
311      * Returns a boolean value indicating whether the operation succeeded.
312      *
313      * Emits a {Transfer} event.
314      */
315     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
316 
317     /**
318      * @dev Emitted when `value` tokens are moved from one account (`from`) to
319      * another (`to`).
320      *
321      * Note that `value` may be zero.
322      */
323     event Transfer(address indexed from, address indexed to, uint256 value);
324 
325     /**
326      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
327      * a call to {approve}. `value` is the new allowance.
328      */
329     event Approval(address indexed owner, address indexed spender, uint256 value);
330 }
331 
332 // File: @openzeppelin/contracts/utils/Address.sol
333 
334 
335 
336 pragma solidity >=0.6.2 <0.8.0;
337 
338 /**
339  * @dev Collection of functions related to the address type
340  */
341 library Address {
342     /**
343      * @dev Returns true if `account` is a contract.
344      *
345      * [IMPORTANT]
346      * ====
347      * It is unsafe to assume that an address for which this function returns
348      * false is an externally-owned account (EOA) and not a contract.
349      *
350      * Among others, `isContract` will return false for the following
351      * types of addresses:
352      *
353      *  - an externally-owned account
354      *  - a contract in construction
355      *  - an address where a contract will be created
356      *  - an address where a contract lived, but was destroyed
357      * ====
358      */
359     function isContract(address account) internal view returns (bool) {
360         // This method relies on extcodesize, which returns 0 for contracts in
361         // construction, since the code is only stored at the end of the
362         // constructor execution.
363 
364         uint256 size;
365         // solhint-disable-next-line no-inline-assembly
366         assembly { size := extcodesize(account) }
367         return size > 0;
368     }
369 
370     /**
371      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
372      * `recipient`, forwarding all available gas and reverting on errors.
373      *
374      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
375      * of certain opcodes, possibly making contracts go over the 2300 gas limit
376      * imposed by `transfer`, making them unable to receive funds via
377      * `transfer`. {sendValue} removes this limitation.
378      *
379      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
380      *
381      * IMPORTANT: because control is transferred to `recipient`, care must be
382      * taken to not create reentrancy vulnerabilities. Consider using
383      * {ReentrancyGuard} or the
384      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
385      */
386     function sendValue(address payable recipient, uint256 amount) internal {
387         require(address(this).balance >= amount, "Address: insufficient balance");
388 
389         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
390         (bool success, ) = recipient.call{ value: amount }("");
391         require(success, "Address: unable to send value, recipient may have reverted");
392     }
393 
394     /**
395      * @dev Performs a Solidity function call using a low level `call`. A
396      * plain`call` is an unsafe replacement for a function call: use this
397      * function instead.
398      *
399      * If `target` reverts with a revert reason, it is bubbled up by this
400      * function (like regular Solidity function calls).
401      *
402      * Returns the raw returned data. To convert to the expected return value,
403      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
404      *
405      * Requirements:
406      *
407      * - `target` must be a contract.
408      * - calling `target` with `data` must not revert.
409      *
410      * _Available since v3.1._
411      */
412     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
413       return functionCall(target, data, "Address: low-level call failed");
414     }
415 
416     /**
417      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
418      * `errorMessage` as a fallback revert reason when `target` reverts.
419      *
420      * _Available since v3.1._
421      */
422     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
423         return functionCallWithValue(target, data, 0, errorMessage);
424     }
425 
426     /**
427      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
428      * but also transferring `value` wei to `target`.
429      *
430      * Requirements:
431      *
432      * - the calling contract must have an ETH balance of at least `value`.
433      * - the called Solidity function must be `payable`.
434      *
435      * _Available since v3.1._
436      */
437     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
438         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
439     }
440 
441     /**
442      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
443      * with `errorMessage` as a fallback revert reason when `target` reverts.
444      *
445      * _Available since v3.1._
446      */
447     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
448         require(address(this).balance >= value, "Address: insufficient balance for call");
449         require(isContract(target), "Address: call to non-contract");
450 
451         // solhint-disable-next-line avoid-low-level-calls
452         (bool success, bytes memory returndata) = target.call{ value: value }(data);
453         return _verifyCallResult(success, returndata, errorMessage);
454     }
455 
456     /**
457      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
458      * but performing a static call.
459      *
460      * _Available since v3.3._
461      */
462     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
463         return functionStaticCall(target, data, "Address: low-level static call failed");
464     }
465 
466     /**
467      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
468      * but performing a static call.
469      *
470      * _Available since v3.3._
471      */
472     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
473         require(isContract(target), "Address: static call to non-contract");
474 
475         // solhint-disable-next-line avoid-low-level-calls
476         (bool success, bytes memory returndata) = target.staticcall(data);
477         return _verifyCallResult(success, returndata, errorMessage);
478     }
479 
480     /**
481      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
482      * but performing a delegate call.
483      *
484      * _Available since v3.4._
485      */
486     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
487         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
488     }
489 
490     /**
491      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
492      * but performing a delegate call.
493      *
494      * _Available since v3.4._
495      */
496     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
497         require(isContract(target), "Address: delegate call to non-contract");
498 
499         // solhint-disable-next-line avoid-low-level-calls
500         (bool success, bytes memory returndata) = target.delegatecall(data);
501         return _verifyCallResult(success, returndata, errorMessage);
502     }
503 
504     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
505         if (success) {
506             return returndata;
507         } else {
508             // Look for revert reason and bubble it up if present
509             if (returndata.length > 0) {
510                 // The easiest way to bubble the revert reason is using memory via assembly
511 
512                 // solhint-disable-next-line no-inline-assembly
513                 assembly {
514                     let returndata_size := mload(returndata)
515                     revert(add(32, returndata), returndata_size)
516                 }
517             } else {
518                 revert(errorMessage);
519             }
520         }
521     }
522 }
523 
524 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
525 
526 
527 
528 pragma solidity >=0.6.0 <0.8.0;
529 
530 
531 
532 
533 /**
534  * @title SafeERC20
535  * @dev Wrappers around ERC20 operations that throw on failure (when the token
536  * contract returns false). Tokens that return no value (and instead revert or
537  * throw on failure) are also supported, non-reverting calls are assumed to be
538  * successful.
539  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
540  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
541  */
542 library SafeERC20 {
543     using SafeMath for uint256;
544     using Address for address;
545 
546     function safeTransfer(IERC20 token, address to, uint256 value) internal {
547         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
548     }
549 
550     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
551         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
552     }
553 
554     /**
555      * @dev Deprecated. This function has issues similar to the ones found in
556      * {IERC20-approve}, and its usage is discouraged.
557      *
558      * Whenever possible, use {safeIncreaseAllowance} and
559      * {safeDecreaseAllowance} instead.
560      */
561     function safeApprove(IERC20 token, address spender, uint256 value) internal {
562         // safeApprove should only be called when setting an initial allowance,
563         // or when resetting it to zero. To increase and decrease it, use
564         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
565         // solhint-disable-next-line max-line-length
566         require((value == 0) || (token.allowance(address(this), spender) == 0),
567             "SafeERC20: approve from non-zero to non-zero allowance"
568         );
569         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
570     }
571 
572     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
573         uint256 newAllowance = token.allowance(address(this), spender).add(value);
574         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
575     }
576 
577     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
578         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
579         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
580     }
581 
582     /**
583      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
584      * on the return value: the return value is optional (but if data is returned, it must not be false).
585      * @param token The token targeted by the call.
586      * @param data The call data (encoded using abi.encode or one of its variants).
587      */
588     function _callOptionalReturn(IERC20 token, bytes memory data) private {
589         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
590         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
591         // the target address contains contract code and also asserts for success in the low-level call.
592 
593         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
594         if (returndata.length > 0) { // Return data is optional
595             // solhint-disable-next-line max-line-length
596             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
597         }
598     }
599 }
600 
601 // File: @bancor/token-governance/contracts/IClaimable.sol
602 
603 
604 pragma solidity 0.6.12;
605 
606 /// @title Claimable contract interface
607 interface IClaimable {
608     function owner() external view returns (address);
609 
610     function transferOwnership(address newOwner) external;
611 
612     function acceptOwnership() external;
613 }
614 
615 // File: @bancor/token-governance/contracts/IMintableToken.sol
616 
617 
618 pragma solidity 0.6.12;
619 
620 
621 
622 /// @title Mintable Token interface
623 interface IMintableToken is IERC20, IClaimable {
624     function issue(address to, uint256 amount) external;
625 
626     function destroy(address from, uint256 amount) external;
627 }
628 
629 // File: @bancor/token-governance/contracts/ITokenGovernance.sol
630 
631 
632 pragma solidity 0.6.12;
633 
634 
635 /// @title The interface for mintable/burnable token governance.
636 interface ITokenGovernance {
637     // The address of the mintable ERC20 token.
638     function token() external view returns (IMintableToken);
639 
640     /// @dev Mints new tokens.
641     ///
642     /// @param to Account to receive the new amount.
643     /// @param amount Amount to increase the supply by.
644     ///
645     function mint(address to, uint256 amount) external;
646 
647     /// @dev Burns tokens from the caller.
648     ///
649     /// @param amount Amount to decrease the supply by.
650     ///
651     function burn(uint256 amount) external;
652 }
653 
654 // File: solidity/contracts/utility/interfaces/IOwned.sol
655 
656 
657 pragma solidity 0.6.12;
658 
659 /*
660     Owned contract interface
661 */
662 interface IOwned {
663     // this function isn't since the compiler emits automatically generated getter functions as external
664     function owner() external view returns (address);
665 
666     function transferOwnership(address _newOwner) external;
667 
668     function acceptOwnership() external;
669 }
670 
671 // File: solidity/contracts/converter/interfaces/IConverterAnchor.sol
672 
673 
674 pragma solidity 0.6.12;
675 
676 
677 /*
678     Converter Anchor interface
679 */
680 interface IConverterAnchor is IOwned {
681 
682 }
683 
684 // File: solidity/contracts/converter/interfaces/IConverterRegistry.sol
685 
686 
687 pragma solidity 0.6.12;
688 
689 
690 
691 interface IConverterRegistry {
692     function getAnchorCount() external view returns (uint256);
693 
694     function getAnchors() external view returns (address[] memory);
695 
696     function getAnchor(uint256 _index) external view returns (IConverterAnchor);
697 
698     function isAnchor(address _value) external view returns (bool);
699 
700     function getLiquidityPoolCount() external view returns (uint256);
701 
702     function getLiquidityPools() external view returns (address[] memory);
703 
704     function getLiquidityPool(uint256 _index) external view returns (IConverterAnchor);
705 
706     function isLiquidityPool(address _value) external view returns (bool);
707 
708     function getConvertibleTokenCount() external view returns (uint256);
709 
710     function getConvertibleTokens() external view returns (address[] memory);
711 
712     function getConvertibleToken(uint256 _index) external view returns (IERC20);
713 
714     function isConvertibleToken(address _value) external view returns (bool);
715 
716     function getConvertibleTokenAnchorCount(IERC20 _convertibleToken) external view returns (uint256);
717 
718     function getConvertibleTokenAnchors(IERC20 _convertibleToken) external view returns (address[] memory);
719 
720     function getConvertibleTokenAnchor(IERC20 _convertibleToken, uint256 _index)
721         external
722         view
723         returns (IConverterAnchor);
724 
725     function isConvertibleTokenAnchor(IERC20 _convertibleToken, address _value) external view returns (bool);
726 
727     function getLiquidityPoolByConfig(
728         uint16 _type,
729         IERC20[] memory _reserveTokens,
730         uint32[] memory _reserveWeights
731     ) external view returns (IConverterAnchor);
732 }
733 
734 // File: solidity/contracts/converter/interfaces/IConverter.sol
735 
736 
737 pragma solidity 0.6.12;
738 
739 
740 
741 
742 /*
743     Converter interface
744 */
745 interface IConverter is IOwned {
746     function converterType() external pure returns (uint16);
747 
748     function anchor() external view returns (IConverterAnchor);
749 
750     function isActive() external view returns (bool);
751 
752     function targetAmountAndFee(
753         IERC20 _sourceToken,
754         IERC20 _targetToken,
755         uint256 _amount
756     ) external view returns (uint256, uint256);
757 
758     function convert(
759         IERC20 _sourceToken,
760         IERC20 _targetToken,
761         uint256 _amount,
762         address _trader,
763         address payable _beneficiary
764     ) external payable returns (uint256);
765 
766     function conversionFee() external view returns (uint32);
767 
768     function maxConversionFee() external view returns (uint32);
769 
770     function reserveBalance(IERC20 _reserveToken) external view returns (uint256);
771 
772     receive() external payable;
773 
774     function transferAnchorOwnership(address _newOwner) external;
775 
776     function acceptAnchorOwnership() external;
777 
778     function setConversionFee(uint32 _conversionFee) external;
779 
780     function addReserve(IERC20 _token, uint32 _weight) external;
781 
782     function transferReservesOnUpgrade(address _newConverter) external;
783 
784     function onUpgradeComplete() external;
785 
786     // deprecated, backward compatibility
787     function token() external view returns (IConverterAnchor);
788 
789     function transferTokenOwnership(address _newOwner) external;
790 
791     function acceptTokenOwnership() external;
792 
793     function connectors(IERC20 _address)
794         external
795         view
796         returns (
797             uint256,
798             uint32,
799             bool,
800             bool,
801             bool
802         );
803 
804     function getConnectorBalance(IERC20 _connectorToken) external view returns (uint256);
805 
806     function connectorTokens(uint256 _index) external view returns (IERC20);
807 
808     function connectorTokenCount() external view returns (uint16);
809 
810     /**
811      * @dev triggered when the converter is activated
812      *
813      * @param _type        converter type
814      * @param _anchor      converter anchor
815      * @param _activated   true if the converter was activated, false if it was deactivated
816      */
817     event Activation(uint16 indexed _type, IConverterAnchor indexed _anchor, bool indexed _activated);
818 
819     /**
820      * @dev triggered when a conversion between two tokens occurs
821      *
822      * @param _fromToken       source ERC20 token
823      * @param _toToken         target ERC20 token
824      * @param _trader          wallet that initiated the trade
825      * @param _amount          input amount in units of the source token
826      * @param _return          output amount minus conversion fee in units of the target token
827      * @param _conversionFee   conversion fee in units of the target token
828      */
829     event Conversion(
830         IERC20 indexed _fromToken,
831         IERC20 indexed _toToken,
832         address indexed _trader,
833         uint256 _amount,
834         uint256 _return,
835         int256 _conversionFee
836     );
837 
838     /**
839      * @dev triggered when the rate between two tokens in the converter changes
840      * note that the event might be dispatched for rate updates between any two tokens in the converter
841      *
842      * @param  _token1 address of the first token
843      * @param  _token2 address of the second token
844      * @param  _rateN  rate of 1 unit of `_token1` in `_token2` (numerator)
845      * @param  _rateD  rate of 1 unit of `_token1` in `_token2` (denominator)
846      */
847     event TokenRateUpdate(IERC20 indexed _token1, IERC20 indexed _token2, uint256 _rateN, uint256 _rateD);
848 
849     /**
850      * @dev triggered when the conversion fee is updated
851      *
852      * @param  _prevFee    previous fee percentage, represented in ppm
853      * @param  _newFee     new fee percentage, represented in ppm
854      */
855     event ConversionFeeUpdate(uint32 _prevFee, uint32 _newFee);
856 }
857 
858 // File: solidity/contracts/utility/Owned.sol
859 
860 
861 pragma solidity 0.6.12;
862 
863 
864 /**
865  * @dev This contract provides support and utilities for contract ownership.
866  */
867 contract Owned is IOwned {
868     address public override owner;
869     address public newOwner;
870 
871     /**
872      * @dev triggered when the owner is updated
873      *
874      * @param _prevOwner previous owner
875      * @param _newOwner  new owner
876      */
877     event OwnerUpdate(address indexed _prevOwner, address indexed _newOwner);
878 
879     /**
880      * @dev initializes a new Owned instance
881      */
882     constructor() public {
883         owner = msg.sender;
884     }
885 
886     // allows execution by the owner only
887     modifier ownerOnly {
888         _ownerOnly();
889         _;
890     }
891 
892     // error message binary size optimization
893     function _ownerOnly() internal view {
894         require(msg.sender == owner, "ERR_ACCESS_DENIED");
895     }
896 
897     /**
898      * @dev allows transferring the contract ownership
899      * the new owner still needs to accept the transfer
900      * can only be called by the contract owner
901      *
902      * @param _newOwner    new contract owner
903      */
904     function transferOwnership(address _newOwner) public override ownerOnly {
905         require(_newOwner != owner, "ERR_SAME_OWNER");
906         newOwner = _newOwner;
907     }
908 
909     /**
910      * @dev used by a new owner to accept an ownership transfer
911      */
912     function acceptOwnership() public override {
913         require(msg.sender == newOwner, "ERR_ACCESS_DENIED");
914         emit OwnerUpdate(owner, newOwner);
915         owner = newOwner;
916         newOwner = address(0);
917     }
918 }
919 
920 // File: solidity/contracts/utility/Utils.sol
921 
922 
923 pragma solidity 0.6.12;
924 
925 
926 /**
927  * @dev Utilities & Common Modifiers
928  */
929 contract Utils {
930     uint32 internal constant PPM_RESOLUTION = 1000000;
931     IERC20 internal constant NATIVE_TOKEN_ADDRESS = IERC20(0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE);
932 
933     // verifies that a value is greater than zero
934     modifier greaterThanZero(uint256 _value) {
935         _greaterThanZero(_value);
936         _;
937     }
938 
939     // error message binary size optimization
940     function _greaterThanZero(uint256 _value) internal pure {
941         require(_value > 0, "ERR_ZERO_VALUE");
942     }
943 
944     // validates an address - currently only checks that it isn't null
945     modifier validAddress(address _address) {
946         _validAddress(_address);
947         _;
948     }
949 
950     // error message binary size optimization
951     function _validAddress(address _address) internal pure {
952         require(_address != address(0), "ERR_INVALID_ADDRESS");
953     }
954 
955     // ensures that the portion is valid
956     modifier validPortion(uint32 _portion) {
957         _validPortion(_portion);
958         _;
959     }
960 
961     // error message binary size optimization
962     function _validPortion(uint32 _portion) internal pure {
963         require(_portion > 0 && _portion <= PPM_RESOLUTION, "ERR_INVALID_PORTION");
964     }
965 
966     // validates an external address - currently only checks that it isn't null or this
967     modifier validExternalAddress(address _address) {
968         _validExternalAddress(_address);
969         _;
970     }
971 
972     // error message binary size optimization
973     function _validExternalAddress(address _address) internal view {
974         require(_address != address(0) && _address != address(this), "ERR_INVALID_EXTERNAL_ADDRESS");
975     }
976 
977     // ensures that the fee is valid
978     modifier validFee(uint32 fee) {
979         _validFee(fee);
980         _;
981     }
982 
983     // error message binary size optimization
984     function _validFee(uint32 fee) internal pure {
985         require(fee <= PPM_RESOLUTION, "ERR_INVALID_FEE");
986     }
987 }
988 
989 // File: solidity/contracts/utility/interfaces/IContractRegistry.sol
990 
991 
992 pragma solidity 0.6.12;
993 
994 /*
995     Contract Registry interface
996 */
997 interface IContractRegistry {
998     function addressOf(bytes32 _contractName) external view returns (address);
999 }
1000 
1001 // File: solidity/contracts/utility/ContractRegistryClient.sol
1002 
1003 
1004 pragma solidity 0.6.12;
1005 
1006 
1007 
1008 
1009 /**
1010  * @dev This is the base contract for ContractRegistry clients.
1011  */
1012 contract ContractRegistryClient is Owned, Utils {
1013     bytes32 internal constant CONTRACT_REGISTRY = "ContractRegistry";
1014     bytes32 internal constant BANCOR_NETWORK = "BancorNetwork";
1015     bytes32 internal constant BANCOR_FORMULA = "BancorFormula";
1016     bytes32 internal constant CONVERTER_FACTORY = "ConverterFactory";
1017     bytes32 internal constant CONVERSION_PATH_FINDER = "ConversionPathFinder";
1018     bytes32 internal constant CONVERTER_UPGRADER = "BancorConverterUpgrader";
1019     bytes32 internal constant CONVERTER_REGISTRY = "BancorConverterRegistry";
1020     bytes32 internal constant CONVERTER_REGISTRY_DATA = "BancorConverterRegistryData";
1021     bytes32 internal constant BNT_TOKEN = "BNTToken";
1022     bytes32 internal constant BANCOR_X = "BancorX";
1023     bytes32 internal constant BANCOR_X_UPGRADER = "BancorXUpgrader";
1024     bytes32 internal constant LIQUIDITY_PROTECTION = "LiquidityProtection";
1025     bytes32 internal constant NETWORK_SETTINGS = "NetworkSettings";
1026 
1027     IContractRegistry public registry; // address of the current contract-registry
1028     IContractRegistry public prevRegistry; // address of the previous contract-registry
1029     bool public onlyOwnerCanUpdateRegistry; // only an owner can update the contract-registry
1030 
1031     /**
1032      * @dev verifies that the caller is mapped to the given contract name
1033      *
1034      * @param _contractName    contract name
1035      */
1036     modifier only(bytes32 _contractName) {
1037         _only(_contractName);
1038         _;
1039     }
1040 
1041     // error message binary size optimization
1042     function _only(bytes32 _contractName) internal view {
1043         require(msg.sender == addressOf(_contractName), "ERR_ACCESS_DENIED");
1044     }
1045 
1046     /**
1047      * @dev initializes a new ContractRegistryClient instance
1048      *
1049      * @param  _registry   address of a contract-registry contract
1050      */
1051     constructor(IContractRegistry _registry) internal validAddress(address(_registry)) {
1052         registry = IContractRegistry(_registry);
1053         prevRegistry = IContractRegistry(_registry);
1054     }
1055 
1056     /**
1057      * @dev updates to the new contract-registry
1058      */
1059     function updateRegistry() public {
1060         // verify that this function is permitted
1061         require(msg.sender == owner || !onlyOwnerCanUpdateRegistry, "ERR_ACCESS_DENIED");
1062 
1063         // get the new contract-registry
1064         IContractRegistry newRegistry = IContractRegistry(addressOf(CONTRACT_REGISTRY));
1065 
1066         // verify that the new contract-registry is different and not zero
1067         require(newRegistry != registry && address(newRegistry) != address(0), "ERR_INVALID_REGISTRY");
1068 
1069         // verify that the new contract-registry is pointing to a non-zero contract-registry
1070         require(newRegistry.addressOf(CONTRACT_REGISTRY) != address(0), "ERR_INVALID_REGISTRY");
1071 
1072         // save a backup of the current contract-registry before replacing it
1073         prevRegistry = registry;
1074 
1075         // replace the current contract-registry with the new contract-registry
1076         registry = newRegistry;
1077     }
1078 
1079     /**
1080      * @dev restores the previous contract-registry
1081      */
1082     function restoreRegistry() public ownerOnly {
1083         // restore the previous contract-registry
1084         registry = prevRegistry;
1085     }
1086 
1087     /**
1088      * @dev restricts the permission to update the contract-registry
1089      *
1090      * @param _onlyOwnerCanUpdateRegistry  indicates whether or not permission is restricted to owner only
1091      */
1092     function restrictRegistryUpdate(bool _onlyOwnerCanUpdateRegistry) public ownerOnly {
1093         // change the permission to update the contract-registry
1094         onlyOwnerCanUpdateRegistry = _onlyOwnerCanUpdateRegistry;
1095     }
1096 
1097     /**
1098      * @dev returns the address associated with the given contract name
1099      *
1100      * @param _contractName    contract name
1101      *
1102      * @return contract address
1103      */
1104     function addressOf(bytes32 _contractName) internal view returns (address) {
1105         return registry.addressOf(_contractName);
1106     }
1107 }
1108 
1109 // File: solidity/contracts/utility/interfaces/ITokenHolder.sol
1110 
1111 
1112 pragma solidity 0.6.12;
1113 
1114 
1115 
1116 /*
1117     Token Holder interface
1118 */
1119 interface ITokenHolder is IOwned {
1120     receive() external payable;
1121 
1122     function withdrawTokens(
1123         IERC20 token,
1124         address payable to,
1125         uint256 amount
1126     ) external;
1127 
1128     function withdrawTokensMultiple(
1129         IERC20[] calldata tokens,
1130         address payable to,
1131         uint256[] calldata amounts
1132     ) external;
1133 }
1134 
1135 // File: solidity/contracts/utility/TokenHolder.sol
1136 
1137 
1138 pragma solidity 0.6.12;
1139 
1140 
1141 
1142 
1143 
1144 /**
1145  * @dev This contract provides a safety mechanism for allowing the owner to
1146  * send tokens that were sent to the contract by mistake back to the sender.
1147  *
1148  * We consider every contract to be a 'token holder' since it's currently not possible
1149  * for a contract to deny receiving tokens.
1150  */
1151 contract TokenHolder is ITokenHolder, Owned, Utils {
1152     using SafeERC20 for IERC20;
1153 
1154     // prettier-ignore
1155     receive() external payable override virtual {}
1156 
1157     /**
1158      * @dev withdraws funds held by the contract and sends them to an account
1159      * can only be called by the owner
1160      *
1161      * @param token ERC20 token contract address (with a special handling of NATIVE_TOKEN_ADDRESS)
1162      * @param to account to receive the new amount
1163      * @param amount amount to withdraw
1164      */
1165     function withdrawTokens(
1166         IERC20 token,
1167         address payable to,
1168         uint256 amount
1169     ) public virtual override ownerOnly validAddress(to) {
1170         safeTransfer(token, to, amount);
1171     }
1172 
1173     /**
1174      * @dev withdraws multiple funds held by the contract and sends them to an account
1175      * can only be called by the owner
1176      *
1177      * @param tokens ERC20 token contract addresses (with a special handling of NATIVE_TOKEN_ADDRESS)
1178      * @param to account to receive the new amount
1179      * @param amounts amounts to withdraw
1180      */
1181     function withdrawTokensMultiple(
1182         IERC20[] calldata tokens,
1183         address payable to,
1184         uint256[] calldata amounts
1185     ) public virtual override ownerOnly validAddress(to) {
1186         uint256 length = tokens.length;
1187         require(length == amounts.length, "ERR_INVALID_LENGTH");
1188 
1189         for (uint256 i = 0; i < length; ++i) {
1190             safeTransfer(tokens[i], to, amounts[i]);
1191         }
1192     }
1193 
1194     /**
1195      * @dev transfers funds held by the contract and sends them to an account
1196      *
1197      * @param token ERC20 token contract address
1198      * @param to account to receive the new amount
1199      * @param amount amount to withdraw
1200      */
1201     function safeTransfer(
1202         IERC20 token,
1203         address payable to,
1204         uint256 amount
1205     ) internal {
1206         if (amount == 0) {
1207             return;
1208         }
1209 
1210         if (token == NATIVE_TOKEN_ADDRESS) {
1211             to.transfer(amount);
1212         } else {
1213             token.safeTransfer(to, amount);
1214         }
1215     }
1216 }
1217 
1218 // File: solidity/contracts/utility/ReentrancyGuard.sol
1219 
1220 
1221 pragma solidity 0.6.12;
1222 
1223 /**
1224  * @dev This contract provides protection against calling a function
1225  * (directly or indirectly) from within itself.
1226  */
1227 contract ReentrancyGuard {
1228     uint256 private constant UNLOCKED = 1;
1229     uint256 private constant LOCKED = 2;
1230 
1231     // LOCKED while protected code is being executed, UNLOCKED otherwise
1232     uint256 private state = UNLOCKED;
1233 
1234     /**
1235      * @dev ensures instantiation only by sub-contracts
1236      */
1237     constructor() internal {}
1238 
1239     // protects a function against reentrancy attacks
1240     modifier protected() {
1241         _protected();
1242         state = LOCKED;
1243         _;
1244         state = UNLOCKED;
1245     }
1246 
1247     // error message binary size optimization
1248     function _protected() internal view {
1249         require(state == UNLOCKED, "ERR_REENTRANCY");
1250     }
1251 }
1252 
1253 // File: solidity/contracts/INetworkSettings.sol
1254 
1255 
1256 pragma solidity 0.6.12;
1257 
1258 
1259 interface INetworkSettings {
1260     function networkFeeParams() external view returns (ITokenHolder, uint32);
1261 
1262     function networkFeeWallet() external view returns (ITokenHolder);
1263 
1264     function networkFee() external view returns (uint32);
1265 }
1266 
1267 // File: solidity/contracts/IBancorNetwork.sol
1268 
1269 
1270 pragma solidity 0.6.12;
1271 
1272 interface IBancorNetwork {
1273     function rateByPath(address[] memory path, uint256 amount) external view returns (uint256);
1274 
1275     function convertByPath(
1276         address[] memory path,
1277         uint256 amount,
1278         uint256 minReturn,
1279         address payable beneficiary,
1280         address affiliateAccount,
1281         uint256 affiliateFee
1282     ) external payable returns (uint256);
1283 }
1284 
1285 // File: solidity/contracts/vortex/VortexBurner.sol
1286 
1287 
1288 pragma solidity 0.6.12;
1289 
1290 
1291 
1292 
1293 
1294 
1295 
1296 
1297 
1298 
1299 
1300 
1301 
1302 
1303 /**
1304  * @dev This contract provides any user to trigger a network fee burning event
1305  */
1306 contract VortexBurner is Owned, Utils, ReentrancyGuard, ContractRegistryClient {
1307     using SafeMath for uint256;
1308     using Math for uint256;
1309     using SafeERC20 for IERC20;
1310 
1311     struct Strategy {
1312         address[][] paths;
1313         uint256[] amounts;
1314         address[] govPath;
1315     }
1316 
1317     // the mechanism is only designed to work with 50/50 standard pool converters
1318     uint32 private constant STANDARD_POOL_RESERVE_WEIGHT = PPM_RESOLUTION / 2;
1319 
1320     // the type of the standard pool converter
1321     uint16 private constant STANDARD_POOL_CONVERTER_TYPE = 3;
1322 
1323     // the address of the network token
1324     IERC20 private immutable _networkToken;
1325 
1326     // the address of the governance token
1327     IERC20 private immutable _govToken;
1328 
1329     // the address of the governance token security module
1330     ITokenGovernance private immutable _govTokenGovernance;
1331 
1332     // the percentage of the converted network tokens to be sent to the caller of the burning event (in units of PPM)
1333     uint32 private _burnReward;
1334 
1335     // the maximum burn reward to be sent to the caller of the burning event
1336     uint256 private _maxBurnRewardAmount;
1337 
1338     // stores the total amount of the burned governance tokens
1339     uint256 private _totalBurnedAmount;
1340 
1341     /**
1342      * @dev triggered when the burn reward has been changed
1343      *
1344      * @param prevBurnReward the previous burn reward (in units of PPM)
1345      * @param newBurnReward the new burn reward (in units of PPM)
1346      * @param prevMaxBurnRewardAmount the previous maximum burn reward
1347      * @param newMaxBurnRewardAmount the new maximum burn reward
1348      */
1349     event BurnRewardUpdated(
1350         uint32 prevBurnReward,
1351         uint32 newBurnReward,
1352         uint256 prevMaxBurnRewardAmount,
1353         uint256 newMaxBurnRewardAmount
1354     );
1355 
1356     /**
1357      * @dev triggered during conversion of a single token during the burning event
1358      *
1359      * @param token the converted token
1360      * @param sourceAmount the amount of the converted token
1361      * @param targetAmount the network token amount the token were converted to
1362      */
1363     event Converted(IERC20 token, uint256 sourceAmount, uint256 targetAmount);
1364 
1365     /**
1366      * @dev triggered after a completed burning event
1367      *
1368      * @param tokens the converted tokens
1369      * @param sourceAmount the total network token amount the tokens were converted to
1370      * @param burnedAmount the total burned amount in the burning event
1371      */
1372     event Burned(IERC20[] tokens, uint256 sourceAmount, uint256 burnedAmount);
1373 
1374     /**
1375      * @dev initializes a new VortexBurner contract
1376      *
1377      * @param networkToken the address of the network token
1378      * @param govTokenGovernance the address of the governance token security module
1379      * @param registry the address of the contract registry
1380      */
1381     constructor(
1382         IERC20 networkToken,
1383         ITokenGovernance govTokenGovernance,
1384         IContractRegistry registry
1385     )
1386         public
1387         ContractRegistryClient(registry)
1388         validAddress(address(networkToken))
1389         validAddress(address(govTokenGovernance))
1390     {
1391         _networkToken = networkToken;
1392         _govTokenGovernance = govTokenGovernance;
1393         _govToken = govTokenGovernance.token();
1394     }
1395 
1396     /**
1397      * @dev ETH receive callback
1398      */
1399     receive() external payable {}
1400 
1401     /**
1402      * @dev returns the burn reward percentage and its maximum amount
1403      *
1404      * @return the burn reward percentage and its maximum amount
1405      */
1406     function burnReward() external view returns (uint32, uint256) {
1407         return (_burnReward, _maxBurnRewardAmount);
1408     }
1409 
1410     /**
1411      * @dev allows the owner to set the burn reward percentage and its maximum amount
1412      *
1413      * @param newBurnReward the percentage of the converted network tokens to be sent to the caller of the burning event (in units of PPM)
1414      * @param newMaxBurnRewardAmount the maximum burn reward to be sent to the caller of the burning event
1415      */
1416     function setBurnReward(uint32 newBurnReward, uint256 newMaxBurnRewardAmount)
1417         external
1418         ownerOnly
1419         validFee(newBurnReward)
1420     {
1421         emit BurnRewardUpdated(_burnReward, newBurnReward, _maxBurnRewardAmount, newMaxBurnRewardAmount);
1422 
1423         _burnReward = newBurnReward;
1424         _maxBurnRewardAmount = newMaxBurnRewardAmount;
1425     }
1426 
1427     /**
1428      * @dev returns the total amount of the burned governance tokens
1429      *
1430      * @return total amount of the burned governance tokens
1431      */
1432     function totalBurnedAmount() external view returns (uint256) {
1433         return _totalBurnedAmount;
1434     }
1435 
1436     /**
1437      * @dev converts the provided tokens to governance tokens and burns them
1438      *
1439      * @param tokens the tokens to convert
1440      */
1441     function burn(IERC20[] calldata tokens) external protected {
1442         ITokenHolder feeWallet = networkFeeWallet();
1443 
1444         // retrieve the burning strategy
1445         Strategy memory strategy = burnStrategy(tokens, feeWallet);
1446 
1447         // withdraw all token/ETH amounts to the contract
1448         feeWallet.withdrawTokensMultiple(tokens, address(this), strategy.amounts);
1449 
1450         // convert all amounts to the network token and record conversion amounts
1451         IBancorNetwork network = bancorNetwork();
1452 
1453         for (uint256 i = 0; i < strategy.paths.length; ++i) {
1454             // avoid empty conversions
1455             uint256 amount = strategy.amounts[i];
1456             if (amount == 0) {
1457                 continue;
1458             }
1459 
1460             address[] memory path = strategy.paths[i];
1461             IERC20 token = IERC20(path[0]);
1462             uint256 value = 0;
1463 
1464             if (token == _networkToken || token == _govToken) {
1465                 // if the source token is the network or the governance token, we won't try to convert it, but rather
1466                 // include its amount in either the total amount of tokens to convert or burn.
1467                 continue;
1468             }
1469 
1470             if (token == NATIVE_TOKEN_ADDRESS) {
1471                 // if the source token is actually an ETH reserve, make sure to pass its value to the network
1472                 value = amount;
1473             } else {
1474                 // if the source token is a regular token, approve the network to withdraw the token amount
1475                 ensureAllowance(token, network, amount);
1476             }
1477 
1478             // perform the actual conversion and optionally send ETH to the network
1479             uint256 targetAmount = network.convertByPath{ value: value }(path, amount, 1, address(this), address(0), 0);
1480 
1481             emit Converted(token, amount, targetAmount);
1482         }
1483 
1484         // calculate the burn reward and reduce it from the total amount to convert
1485         (uint256 sourceAmount, uint256 burnRewardAmount) = netNetworkConversionAmounts();
1486 
1487         // in case there are network tokens to burn, convert them to the governance token
1488         if (sourceAmount > 0) {
1489             // approve the network to withdraw the network token amount
1490             ensureAllowance(_networkToken, network, sourceAmount);
1491 
1492             // convert the entire network token amount to the governance token
1493             network.convertByPath(strategy.govPath, sourceAmount, 1, address(this), address(0), 0);
1494         }
1495 
1496         // get the governance token balance
1497         uint256 govTokenBalance = _govToken.balanceOf(address(this));
1498         require(govTokenBalance > 0, "ERR_ZERO_BURN_AMOUNT");
1499 
1500         // update the stats of the burning event
1501         _totalBurnedAmount = _totalBurnedAmount.add(govTokenBalance);
1502 
1503         // burn the entire governance token balance
1504         _govTokenGovernance.burn(govTokenBalance);
1505 
1506         // if there is a burn reward, transfer it to the caller
1507         if (burnRewardAmount > 0) {
1508             _networkToken.transfer(msg.sender, burnRewardAmount);
1509         }
1510 
1511         emit Burned(tokens, sourceAmount + burnRewardAmount, govTokenBalance);
1512     }
1513 
1514     /**
1515      * @dev transfers the ownership of the network fee wallet
1516      *
1517      * @param newOwner the new owner of the network fee wallet
1518      */
1519     function transferNetworkFeeWalletOwnership(address newOwner) external ownerOnly {
1520         networkFeeWallet().transferOwnership(newOwner);
1521     }
1522 
1523     /**
1524      * @dev accepts the ownership of he network fee wallet
1525      */
1526     function acceptNetworkFeeOwnership() external ownerOnly {
1527         networkFeeWallet().acceptOwnership();
1528     }
1529 
1530     /**
1531      * @dev returns the burning strategy for the specified tokens
1532      *
1533      * @param tokens the tokens to convert
1534      *
1535      * @return the the burning strategy for the specified tokens
1536      */
1537     function burnStrategy(IERC20[] calldata tokens, ITokenHolder feeWallet) private view returns (Strategy memory) {
1538         IConverterRegistry registry = converterRegistry();
1539 
1540         Strategy memory strategy =
1541             Strategy({
1542                 paths: new address[][](tokens.length),
1543                 amounts: new uint256[](tokens.length),
1544                 govPath: new address[](3)
1545             });
1546 
1547         for (uint256 i = 0; i < tokens.length; ++i) {
1548             IERC20 token = tokens[i];
1549 
1550             address[] memory path = new address[](3);
1551             path[0] = address(token);
1552 
1553             // don't look up for a converter for either the network or the governance token, since they are going to be
1554             // handled in a special way during the burn itself
1555             if (token != _networkToken && token != _govToken) {
1556                 path[1] = address(networkTokenConverterAnchor(token, registry));
1557                 path[2] = address(_networkToken);
1558             }
1559 
1560             strategy.paths[i] = path;
1561 
1562             // make sure to retrieve the balance of either an ERC20 or an ETH reserve
1563             if (token == NATIVE_TOKEN_ADDRESS) {
1564                 strategy.amounts[i] = address(feeWallet).balance;
1565             } else {
1566                 strategy.amounts[i] = token.balanceOf(address(feeWallet));
1567             }
1568         }
1569 
1570         // get the governance token converter path
1571         strategy.govPath[0] = address(_networkToken);
1572         strategy.govPath[1] = address(networkTokenConverterAnchor(_govToken, registry));
1573         strategy.govPath[2] = address(_govToken);
1574 
1575         return strategy;
1576     }
1577 
1578     /**
1579      * @dev applies the burn reward on the whole balance and returns the net amount and the reward
1580      *
1581      * @return network token target amount
1582      * @return burn reward amount
1583      */
1584     function netNetworkConversionAmounts() private view returns (uint256, uint256) {
1585         uint256 amount = _networkToken.balanceOf(address(this));
1586         uint256 burnRewardAmount = Math.min(amount.mul(_burnReward) / PPM_RESOLUTION, _maxBurnRewardAmount);
1587 
1588         return (amount - burnRewardAmount, burnRewardAmount);
1589     }
1590 
1591     /**
1592      * @dev finds the converter anchor of the 50/50 standard pool converter between the specified token and the network token
1593      *
1594      * @param token the source token
1595      * @param converterRegistry the converter registry
1596      *
1597      * @return the converter anchor of the 50/50 standard pool converter between the specified token
1598      */
1599     function networkTokenConverterAnchor(IERC20 token, IConverterRegistry converterRegistry)
1600         private
1601         view
1602         returns (IConverterAnchor)
1603     {
1604         // initialize both the source and the target tokens
1605         IERC20[] memory reserveTokens = new IERC20[](2);
1606         reserveTokens[0] = _networkToken;
1607         reserveTokens[1] = token;
1608 
1609         // make sure to only look up for 50/50 converters
1610         uint32[] memory standardReserveWeights = new uint32[](2);
1611         standardReserveWeights[0] = STANDARD_POOL_RESERVE_WEIGHT;
1612         standardReserveWeights[1] = STANDARD_POOL_RESERVE_WEIGHT;
1613 
1614         // find the standard pool converter between the specified token and the network token
1615         IConverterAnchor anchor =
1616             converterRegistry.getLiquidityPoolByConfig(
1617                 STANDARD_POOL_CONVERTER_TYPE,
1618                 reserveTokens,
1619                 standardReserveWeights
1620             );
1621         require(address(anchor) != address(0), "ERR_INVALID_RESERVE_TOKEN");
1622 
1623         return anchor;
1624     }
1625 
1626     /**
1627      * @dev ensures that the network is able to pull the tokens from this contact
1628      *
1629      * @param token the source token
1630      * @param network the address of the network contract
1631      * @param amount the token amount to approve
1632      */
1633     function ensureAllowance(
1634         IERC20 token,
1635         IBancorNetwork network,
1636         uint256 amount
1637     ) private {
1638         address networkAddress = address(network);
1639         uint256 allowance = token.allowance(address(this), networkAddress);
1640         if (allowance < amount) {
1641             if (allowance > 0) {
1642                 token.safeApprove(networkAddress, 0);
1643             }
1644             token.safeApprove(networkAddress, amount);
1645         }
1646     }
1647 
1648     /**
1649      * @dev returns the converter registry
1650      *
1651      * @return the converter registry
1652      */
1653     function converterRegistry() private view returns (IConverterRegistry) {
1654         return IConverterRegistry(addressOf(CONVERTER_REGISTRY));
1655     }
1656 
1657     /**
1658      * @dev returns the network contract
1659      *
1660      * @return the network contract
1661      */
1662     function bancorNetwork() private view returns (IBancorNetwork) {
1663         return IBancorNetwork(payable(addressOf(BANCOR_NETWORK)));
1664     }
1665 
1666     /**
1667      * @dev returns the network settings contract
1668      *
1669      * @return the network settings contract
1670      */
1671     function networkSetting() private view returns (INetworkSettings) {
1672         return INetworkSettings(addressOf(NETWORK_SETTINGS));
1673     }
1674 
1675     /**
1676      * @dev returns the network fee wallet
1677      *
1678      * @return the network fee wallet
1679      */
1680     function networkFeeWallet() private view returns (ITokenHolder) {
1681         return ITokenHolder(networkSetting().networkFeeWallet());
1682     }
1683 }
