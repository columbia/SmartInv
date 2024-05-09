1 // File: @openzeppelin/contracts/math/Math.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity ^0.6.0;
6 
7 /**
8  * @dev Standard math utilities missing in the Solidity language.
9  */
10 library Math {
11     /**
12      * @dev Returns the largest of two numbers.
13      */
14     function max(uint256 a, uint256 b) internal pure returns (uint256) {
15         return a >= b ? a : b;
16     }
17 
18     /**
19      * @dev Returns the smallest of two numbers.
20      */
21     function min(uint256 a, uint256 b) internal pure returns (uint256) {
22         return a < b ? a : b;
23     }
24 
25     /**
26      * @dev Returns the average of two numbers. The result is rounded towards
27      * zero.
28      */
29     function average(uint256 a, uint256 b) internal pure returns (uint256) {
30         // (a + b) / 2 can overflow, so we distribute
31         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
32     }
33 }
34 
35 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
36 
37 pragma solidity ^0.6.0;
38 
39 /**
40  * @dev Interface of the ERC20 standard as defined in the EIP.
41  */
42 interface IERC20 {
43     /**
44      * @dev Returns the amount of tokens in existence.
45      */
46     function totalSupply() external view returns (uint256);
47 
48     /**
49      * @dev Returns the amount of tokens owned by `account`.
50      */
51     function balanceOf(address account) external view returns (uint256);
52 
53     /**
54      * @dev Moves `amount` tokens from the caller's account to `recipient`.
55      *
56      * Returns a boolean value indicating whether the operation succeeded.
57      *
58      * Emits a {Transfer} event.
59      */
60     function transfer(address recipient, uint256 amount) external returns (bool);
61 
62     /**
63      * @dev Returns the remaining number of tokens that `spender` will be
64      * allowed to spend on behalf of `owner` through {transferFrom}. This is
65      * zero by default.
66      *
67      * This value changes when {approve} or {transferFrom} are called.
68      */
69     function allowance(address owner, address spender) external view returns (uint256);
70 
71     /**
72      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
73      *
74      * Returns a boolean value indicating whether the operation succeeded.
75      *
76      * IMPORTANT: Beware that changing an allowance with this method brings the risk
77      * that someone may use both the old and the new allowance by unfortunate
78      * transaction ordering. One possible solution to mitigate this race
79      * condition is to first reduce the spender's allowance to 0 and set the
80      * desired value afterwards:
81      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
82      *
83      * Emits an {Approval} event.
84      */
85     function approve(address spender, uint256 amount) external returns (bool);
86 
87     /**
88      * @dev Moves `amount` tokens from `sender` to `recipient` using the
89      * allowance mechanism. `amount` is then deducted from the caller's
90      * allowance.
91      *
92      * Returns a boolean value indicating whether the operation succeeded.
93      *
94      * Emits a {Transfer} event.
95      */
96     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
97 
98     /**
99      * @dev Emitted when `value` tokens are moved from one account (`from`) to
100      * another (`to`).
101      *
102      * Note that `value` may be zero.
103      */
104     event Transfer(address indexed from, address indexed to, uint256 value);
105 
106     /**
107      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
108      * a call to {approve}. `value` is the new allowance.
109      */
110     event Approval(address indexed owner, address indexed spender, uint256 value);
111 }
112 
113 // File: @openzeppelin/contracts/math/SafeMath.sol
114 
115 pragma solidity ^0.6.0;
116 
117 /**
118  * @dev Wrappers over Solidity's arithmetic operations with added overflow
119  * checks.
120  *
121  * Arithmetic operations in Solidity wrap on overflow. This can easily result
122  * in bugs, because programmers usually assume that an overflow raises an
123  * error, which is the standard behavior in high level programming languages.
124  * `SafeMath` restores this intuition by reverting the transaction when an
125  * operation overflows.
126  *
127  * Using this library instead of the unchecked operations eliminates an entire
128  * class of bugs, so it's recommended to use it always.
129  */
130 library SafeMath {
131     /**
132      * @dev Returns the addition of two unsigned integers, reverting on
133      * overflow.
134      *
135      * Counterpart to Solidity's `+` operator.
136      *
137      * Requirements:
138      *
139      * - Addition cannot overflow.
140      */
141     function add(uint256 a, uint256 b) internal pure returns (uint256) {
142         uint256 c = a + b;
143         require(c >= a, "SafeMath: addition overflow");
144 
145         return c;
146     }
147 
148     /**
149      * @dev Returns the subtraction of two unsigned integers, reverting on
150      * overflow (when the result is negative).
151      *
152      * Counterpart to Solidity's `-` operator.
153      *
154      * Requirements:
155      *
156      * - Subtraction cannot overflow.
157      */
158     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
159         return sub(a, b, "SafeMath: subtraction overflow");
160     }
161 
162     /**
163      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
164      * overflow (when the result is negative).
165      *
166      * Counterpart to Solidity's `-` operator.
167      *
168      * Requirements:
169      *
170      * - Subtraction cannot overflow.
171      */
172     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
173         require(b <= a, errorMessage);
174         uint256 c = a - b;
175 
176         return c;
177     }
178 
179     /**
180      * @dev Returns the multiplication of two unsigned integers, reverting on
181      * overflow.
182      *
183      * Counterpart to Solidity's `*` operator.
184      *
185      * Requirements:
186      *
187      * - Multiplication cannot overflow.
188      */
189     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
190         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
191         // benefit is lost if 'b' is also tested.
192         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
193         if (a == 0) {
194             return 0;
195         }
196 
197         uint256 c = a * b;
198         require(c / a == b, "SafeMath: multiplication overflow");
199 
200         return c;
201     }
202 
203     /**
204      * @dev Returns the integer division of two unsigned integers. Reverts on
205      * division by zero. The result is rounded towards zero.
206      *
207      * Counterpart to Solidity's `/` operator. Note: this function uses a
208      * `revert` opcode (which leaves remaining gas untouched) while Solidity
209      * uses an invalid opcode to revert (consuming all remaining gas).
210      *
211      * Requirements:
212      *
213      * - The divisor cannot be zero.
214      */
215     function div(uint256 a, uint256 b) internal pure returns (uint256) {
216         return div(a, b, "SafeMath: division by zero");
217     }
218 
219     /**
220      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
221      * division by zero. The result is rounded towards zero.
222      *
223      * Counterpart to Solidity's `/` operator. Note: this function uses a
224      * `revert` opcode (which leaves remaining gas untouched) while Solidity
225      * uses an invalid opcode to revert (consuming all remaining gas).
226      *
227      * Requirements:
228      *
229      * - The divisor cannot be zero.
230      */
231     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
232         require(b > 0, errorMessage);
233         uint256 c = a / b;
234         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
235 
236         return c;
237     }
238 
239     /**
240      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
241      * Reverts when dividing by zero.
242      *
243      * Counterpart to Solidity's `%` operator. This function uses a `revert`
244      * opcode (which leaves remaining gas untouched) while Solidity uses an
245      * invalid opcode to revert (consuming all remaining gas).
246      *
247      * Requirements:
248      *
249      * - The divisor cannot be zero.
250      */
251     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
252         return mod(a, b, "SafeMath: modulo by zero");
253     }
254 
255     /**
256      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
257      * Reverts with custom message when dividing by zero.
258      *
259      * Counterpart to Solidity's `%` operator. This function uses a `revert`
260      * opcode (which leaves remaining gas untouched) while Solidity uses an
261      * invalid opcode to revert (consuming all remaining gas).
262      *
263      * Requirements:
264      *
265      * - The divisor cannot be zero.
266      */
267     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
268         require(b != 0, errorMessage);
269         return a % b;
270     }
271 }
272 
273 // File: @openzeppelin/contracts/utils/Address.sol
274 
275 pragma solidity ^0.6.2;
276 
277 /**
278  * @dev Collection of functions related to the address type
279  */
280 library Address {
281     /**
282      * @dev Returns true if `account` is a contract.
283      *
284      * [IMPORTANT]
285      * ====
286      * It is unsafe to assume that an address for which this function returns
287      * false is an externally-owned account (EOA) and not a contract.
288      *
289      * Among others, `isContract` will return false for the following
290      * types of addresses:
291      *
292      *  - an externally-owned account
293      *  - a contract in construction
294      *  - an address where a contract will be created
295      *  - an address where a contract lived, but was destroyed
296      * ====
297      */
298     function isContract(address account) internal view returns (bool) {
299         // This method relies in extcodesize, which returns 0 for contracts in
300         // construction, since the code is only stored at the end of the
301         // constructor execution.
302 
303         uint256 size;
304         // solhint-disable-next-line no-inline-assembly
305         assembly { size := extcodesize(account) }
306         return size > 0;
307     }
308 
309     /**
310      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
311      * `recipient`, forwarding all available gas and reverting on errors.
312      *
313      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
314      * of certain opcodes, possibly making contracts go over the 2300 gas limit
315      * imposed by `transfer`, making them unable to receive funds via
316      * `transfer`. {sendValue} removes this limitation.
317      *
318      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
319      *
320      * IMPORTANT: because control is transferred to `recipient`, care must be
321      * taken to not create reentrancy vulnerabilities. Consider using
322      * {ReentrancyGuard} or the
323      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
324      */
325     function sendValue(address payable recipient, uint256 amount) internal {
326         require(address(this).balance >= amount, "Address: insufficient balance");
327 
328         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
329         (bool success, ) = recipient.call{ value: amount }("");
330         require(success, "Address: unable to send value, recipient may have reverted");
331     }
332 
333     /**
334      * @dev Performs a Solidity function call using a low level `call`. A
335      * plain`call` is an unsafe replacement for a function call: use this
336      * function instead.
337      *
338      * If `target` reverts with a revert reason, it is bubbled up by this
339      * function (like regular Solidity function calls).
340      *
341      * Returns the raw returned data. To convert to the expected return value,
342      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
343      *
344      * Requirements:
345      *
346      * - `target` must be a contract.
347      * - calling `target` with `data` must not revert.
348      *
349      * _Available since v3.1._
350      */
351     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
352       return functionCall(target, data, "Address: low-level call failed");
353     }
354 
355     /**
356      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
357      * `errorMessage` as a fallback revert reason when `target` reverts.
358      *
359      * _Available since v3.1._
360      */
361     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
362         return _functionCallWithValue(target, data, 0, errorMessage);
363     }
364 
365     /**
366      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
367      * but also transferring `value` wei to `target`.
368      *
369      * Requirements:
370      *
371      * - the calling contract must have an ETH balance of at least `value`.
372      * - the called Solidity function must be `payable`.
373      *
374      * _Available since v3.1._
375      */
376     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
377         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
378     }
379 
380     /**
381      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
382      * with `errorMessage` as a fallback revert reason when `target` reverts.
383      *
384      * _Available since v3.1._
385      */
386     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
387         require(address(this).balance >= value, "Address: insufficient balance for call");
388         return _functionCallWithValue(target, data, value, errorMessage);
389     }
390 
391     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
392         require(isContract(target), "Address: call to non-contract");
393 
394         // solhint-disable-next-line avoid-low-level-calls
395         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
396         if (success) {
397             return returndata;
398         } else {
399             // Look for revert reason and bubble it up if present
400             if (returndata.length > 0) {
401                 // The easiest way to bubble the revert reason is using memory via assembly
402 
403                 // solhint-disable-next-line no-inline-assembly
404                 assembly {
405                     let returndata_size := mload(returndata)
406                     revert(add(32, returndata), returndata_size)
407                 }
408             } else {
409                 revert(errorMessage);
410             }
411         }
412     }
413 }
414 
415 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
416 
417 pragma solidity ^0.6.0;
418 
419 
420 
421 
422 /**
423  * @title SafeERC20
424  * @dev Wrappers around ERC20 operations that throw on failure (when the token
425  * contract returns false). Tokens that return no value (and instead revert or
426  * throw on failure) are also supported, non-reverting calls are assumed to be
427  * successful.
428  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
429  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
430  */
431 library SafeERC20 {
432     using SafeMath for uint256;
433     using Address for address;
434 
435     function safeTransfer(IERC20 token, address to, uint256 value) internal {
436         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
437     }
438 
439     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
440         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
441     }
442 
443     /**
444      * @dev Deprecated. This function has issues similar to the ones found in
445      * {IERC20-approve}, and its usage is discouraged.
446      *
447      * Whenever possible, use {safeIncreaseAllowance} and
448      * {safeDecreaseAllowance} instead.
449      */
450     function safeApprove(IERC20 token, address spender, uint256 value) internal {
451         // safeApprove should only be called when setting an initial allowance,
452         // or when resetting it to zero. To increase and decrease it, use
453         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
454         // solhint-disable-next-line max-line-length
455         require((value == 0) || (token.allowance(address(this), spender) == 0),
456             "SafeERC20: approve from non-zero to non-zero allowance"
457         );
458         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
459     }
460 
461     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
462         uint256 newAllowance = token.allowance(address(this), spender).add(value);
463         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
464     }
465 
466     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
467         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
468         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
469     }
470 
471     /**
472      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
473      * on the return value: the return value is optional (but if data is returned, it must not be false).
474      * @param token The token targeted by the call.
475      * @param data The call data (encoded using abi.encode or one of its variants).
476      */
477     function _callOptionalReturn(IERC20 token, bytes memory data) private {
478         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
479         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
480         // the target address contains contract code and also asserts for success in the low-level call.
481 
482         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
483         if (returndata.length > 0) { // Return data is optional
484             // solhint-disable-next-line max-line-length
485             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
486         }
487     }
488 }
489 
490 // File: @openzeppelin/contracts/utils/ReentrancyGuard.sol
491 
492 pragma solidity ^0.6.0;
493 
494 /**
495  * @dev Contract module that helps prevent reentrant calls to a function.
496  *
497  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
498  * available, which can be applied to functions to make sure there are no nested
499  * (reentrant) calls to them.
500  *
501  * Note that because there is a single `nonReentrant` guard, functions marked as
502  * `nonReentrant` may not call one another. This can be worked around by making
503  * those functions `private`, and then adding `external` `nonReentrant` entry
504  * points to them.
505  *
506  * TIP: If you would like to learn more about reentrancy and alternative ways
507  * to protect against it, check out our blog post
508  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
509  */
510 contract ReentrancyGuard {
511     // Booleans are more expensive than uint256 or any type that takes up a full
512     // word because each write operation emits an extra SLOAD to first read the
513     // slot's contents, replace the bits taken up by the boolean, and then write
514     // back. This is the compiler's defense against contract upgrades and
515     // pointer aliasing, and it cannot be disabled.
516 
517     // The values being non-zero value makes deployment a bit more expensive,
518     // but in exchange the refund on every call to nonReentrant will be lower in
519     // amount. Since refunds are capped to a percentage of the total
520     // transaction's gas, it is best to keep them low in cases like this one, to
521     // increase the likelihood of the full refund coming into effect.
522     uint256 private constant _NOT_ENTERED = 1;
523     uint256 private constant _ENTERED = 2;
524 
525     uint256 private _status;
526 
527     constructor () internal {
528         _status = _NOT_ENTERED;
529     }
530 
531     /**
532      * @dev Prevents a contract from calling itself, directly or indirectly.
533      * Calling a `nonReentrant` function from another `nonReentrant`
534      * function is not supported. It is possible to prevent this from happening
535      * by making the `nonReentrant` function external, and make it call a
536      * `private` function that does the actual work.
537      */
538     modifier nonReentrant() {
539         // On the first call to nonReentrant, _notEntered will be true
540         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
541 
542         // Any calls to nonReentrant after this point will fail
543         _status = _ENTERED;
544 
545         _;
546 
547         // By storing the original value once again, a refund is triggered (see
548         // https://eips.ethereum.org/EIPS/eip-2200)
549         _status = _NOT_ENTERED;
550     }
551 }
552 
553 // File: contracts/interfaces/IOracle.sol
554 
555 pragma solidity ^0.6.0;
556 
557 interface IOracle {
558     function update() external;
559 
560     function consult(address token, uint256 amountIn)
561         external
562         view
563         returns (uint256 amountOut);
564     // function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestamp);
565 }
566 
567 // File: contracts/interfaces/IBoardroom.sol
568 
569 pragma solidity ^0.6.0;
570 
571 interface IBoardroom {
572     function allocateSeigniorage(uint256 amount) external;
573 }
574 
575 // File: contracts/interfaces/IBasisAsset.sol
576 
577 pragma solidity ^0.6.0;
578 
579 interface IBasisAsset {
580     function mint(address recipient, uint256 amount) external returns (bool);
581 
582     function burn(uint256 amount) external;
583 
584     function burnFrom(address from, uint256 amount) external;
585 
586     function isOperator() external returns (bool);
587 
588     function operator() external view returns (address);
589 }
590 
591 // File: contracts/interfaces/ISimpleERCFund.sol
592 
593 pragma solidity ^0.6.0;
594 
595 interface ISimpleERCFund {
596     function deposit(
597         address token,
598         uint256 amount,
599         string memory reason
600     ) external;
601 
602     function withdraw(
603         address token,
604         uint256 amount,
605         address to,
606         string memory reason
607     ) external;
608 }
609 
610 // File: contracts/lib/Babylonian.sol
611 
612 pragma solidity ^0.6.0;
613 
614 library Babylonian {
615     function sqrt(uint256 y) internal pure returns (uint256 z) {
616         if (y > 3) {
617             z = y;
618             uint256 x = y / 2 + 1;
619             while (x < z) {
620                 z = x;
621                 x = (y / x + x) / 2;
622             }
623         } else if (y != 0) {
624             z = 1;
625         }
626         // else z = 0
627     }
628 }
629 
630 // File: contracts/lib/FixedPoint.sol
631 
632 pragma solidity ^0.6.0;
633 
634 
635 // a library for handling binary fixed point numbers (https://en.wikipedia.org/wiki/Q_(number_format))
636 library FixedPoint {
637     // range: [0, 2**112 - 1]
638     // resolution: 1 / 2**112
639     struct uq112x112 {
640         uint224 _x;
641     }
642 
643     // range: [0, 2**144 - 1]
644     // resolution: 1 / 2**112
645     struct uq144x112 {
646         uint256 _x;
647     }
648 
649     uint8 private constant RESOLUTION = 112;
650     uint256 private constant Q112 = uint256(1) << RESOLUTION;
651     uint256 private constant Q224 = Q112 << RESOLUTION;
652 
653     // encode a uint112 as a UQ112x112
654     function encode(uint112 x) internal pure returns (uq112x112 memory) {
655         return uq112x112(uint224(x) << RESOLUTION);
656     }
657 
658     // encodes a uint144 as a UQ144x112
659     function encode144(uint144 x) internal pure returns (uq144x112 memory) {
660         return uq144x112(uint256(x) << RESOLUTION);
661     }
662 
663     // divide a UQ112x112 by a uint112, returning a UQ112x112
664     function div(uq112x112 memory self, uint112 x)
665         internal
666         pure
667         returns (uq112x112 memory)
668     {
669         require(x != 0, 'FixedPoint: DIV_BY_ZERO');
670         return uq112x112(self._x / uint224(x));
671     }
672 
673     // multiply a UQ112x112 by a uint, returning a UQ144x112
674     // reverts on overflow
675     function mul(uq112x112 memory self, uint256 y)
676         internal
677         pure
678         returns (uq144x112 memory)
679     {
680         uint256 z;
681         require(
682             y == 0 || (z = uint256(self._x) * y) / y == uint256(self._x),
683             'FixedPoint: MULTIPLICATION_OVERFLOW'
684         );
685         return uq144x112(z);
686     }
687 
688     // returns a UQ112x112 which represents the ratio of the numerator to the denominator
689     // equivalent to encode(numerator).div(denominator)
690     function fraction(uint112 numerator, uint112 denominator)
691         internal
692         pure
693         returns (uq112x112 memory)
694     {
695         require(denominator > 0, 'FixedPoint: DIV_BY_ZERO');
696         return uq112x112((uint224(numerator) << RESOLUTION) / denominator);
697     }
698 
699     // decode a UQ112x112 into a uint112 by truncating after the radix point
700     function decode(uq112x112 memory self) internal pure returns (uint112) {
701         return uint112(self._x >> RESOLUTION);
702     }
703 
704     // decode a UQ144x112 into a uint144 by truncating after the radix point
705     function decode144(uq144x112 memory self) internal pure returns (uint144) {
706         return uint144(self._x >> RESOLUTION);
707     }
708 
709     // take the reciprocal of a UQ112x112
710     function reciprocal(uq112x112 memory self)
711         internal
712         pure
713         returns (uq112x112 memory)
714     {
715         require(self._x != 0, 'FixedPoint: ZERO_RECIPROCAL');
716         return uq112x112(uint224(Q224 / self._x));
717     }
718 
719     // square root of a UQ112x112
720     function sqrt(uq112x112 memory self)
721         internal
722         pure
723         returns (uq112x112 memory)
724     {
725         return uq112x112(uint224(Babylonian.sqrt(uint256(self._x)) << 56));
726     }
727 }
728 
729 // File: contracts/lib/Safe112.sol
730 
731 pragma solidity ^0.6.0;
732 
733 library Safe112 {
734     function add(uint112 a, uint112 b) internal pure returns (uint256) {
735         uint256 c = a + b;
736         require(c >= a, 'Safe112: addition overflow');
737 
738         return c;
739     }
740 
741     function sub(uint112 a, uint112 b) internal pure returns (uint256) {
742         return sub(a, b, 'Safe112: subtraction overflow');
743     }
744 
745     function sub(
746         uint112 a,
747         uint112 b,
748         string memory errorMessage
749     ) internal pure returns (uint112) {
750         require(b <= a, errorMessage);
751         uint112 c = a - b;
752 
753         return c;
754     }
755 
756     function mul(uint112 a, uint112 b) internal pure returns (uint256) {
757         if (a == 0) {
758             return 0;
759         }
760 
761         uint256 c = a * b;
762         require(c / a == b, 'Safe112: multiplication overflow');
763 
764         return c;
765     }
766 
767     function div(uint112 a, uint112 b) internal pure returns (uint256) {
768         return div(a, b, 'Safe112: division by zero');
769     }
770 
771     function div(
772         uint112 a,
773         uint112 b,
774         string memory errorMessage
775     ) internal pure returns (uint112) {
776         // Solidity only automatically asserts when dividing by 0
777         require(b > 0, errorMessage);
778         uint112 c = a / b;
779 
780         return c;
781     }
782 
783     function mod(uint112 a, uint112 b) internal pure returns (uint256) {
784         return mod(a, b, 'Safe112: modulo by zero');
785     }
786 
787     function mod(
788         uint112 a,
789         uint112 b,
790         string memory errorMessage
791     ) internal pure returns (uint112) {
792         require(b != 0, errorMessage);
793         return a % b;
794     }
795 }
796 
797 // File: @openzeppelin/contracts/GSN/Context.sol
798 
799 pragma solidity ^0.6.0;
800 
801 /*
802  * @dev Provides information about the current execution context, including the
803  * sender of the transaction and its data. While these are generally available
804  * via msg.sender and msg.data, they should not be accessed in such a direct
805  * manner, since when dealing with GSN meta-transactions the account sending and
806  * paying for execution may not be the actual sender (as far as an application
807  * is concerned).
808  *
809  * This contract is only required for intermediate, library-like contracts.
810  */
811 abstract contract Context {
812     function _msgSender() internal view virtual returns (address payable) {
813         return msg.sender;
814     }
815 
816     function _msgData() internal view virtual returns (bytes memory) {
817         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
818         return msg.data;
819     }
820 }
821 
822 // File: @openzeppelin/contracts/access/Ownable.sol
823 
824 pragma solidity ^0.6.0;
825 
826 /**
827  * @dev Contract module which provides a basic access control mechanism, where
828  * there is an account (an owner) that can be granted exclusive access to
829  * specific functions.
830  *
831  * By default, the owner account will be the one that deploys the contract. This
832  * can later be changed with {transferOwnership}.
833  *
834  * This module is used through inheritance. It will make available the modifier
835  * `onlyOwner`, which can be applied to your functions to restrict their use to
836  * the owner.
837  */
838 contract Ownable is Context {
839     address private _owner;
840 
841     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
842 
843     /**
844      * @dev Initializes the contract setting the deployer as the initial owner.
845      */
846     constructor () internal {
847         address msgSender = _msgSender();
848         _owner = msgSender;
849         emit OwnershipTransferred(address(0), msgSender);
850     }
851 
852     /**
853      * @dev Returns the address of the current owner.
854      */
855     function owner() public view returns (address) {
856         return _owner;
857     }
858 
859     /**
860      * @dev Throws if called by any account other than the owner.
861      */
862     modifier onlyOwner() {
863         require(_owner == _msgSender(), "Ownable: caller is not the owner");
864         _;
865     }
866 
867     /**
868      * @dev Leaves the contract without owner. It will not be possible to call
869      * `onlyOwner` functions anymore. Can only be called by the current owner.
870      *
871      * NOTE: Renouncing ownership will leave the contract without an owner,
872      * thereby removing any functionality that is only available to the owner.
873      */
874     function renounceOwnership() public virtual onlyOwner {
875         emit OwnershipTransferred(_owner, address(0));
876         _owner = address(0);
877     }
878 
879     /**
880      * @dev Transfers ownership of the contract to a new account (`newOwner`).
881      * Can only be called by the current owner.
882      */
883     function transferOwnership(address newOwner) public virtual onlyOwner {
884         require(newOwner != address(0), "Ownable: new owner is the zero address");
885         emit OwnershipTransferred(_owner, newOwner);
886         _owner = newOwner;
887     }
888 }
889 
890 // File: contracts/owner/Operator.sol
891 
892 pragma solidity ^0.6.0;
893 
894 
895 
896 contract Operator is Context, Ownable {
897     address private _operator;
898 
899     event OperatorTransferred(
900         address indexed previousOperator,
901         address indexed newOperator
902     );
903 
904     constructor() internal {
905         _operator = _msgSender();
906         emit OperatorTransferred(address(0), _operator);
907     }
908 
909     function operator() public view returns (address) {
910         return _operator;
911     }
912 
913     modifier onlyOperator() {
914         require(
915             _operator == msg.sender,
916             'operator: caller is not the operator'
917         );
918         _;
919     }
920 
921     function isOperator() public view returns (bool) {
922         return _msgSender() == _operator;
923     }
924 
925     function transferOperator(address newOperator_) public onlyOwner {
926         _transferOperator(newOperator_);
927     }
928 
929     function _transferOperator(address newOperator_) internal {
930         require(
931             newOperator_ != address(0),
932             'operator: zero address given for new operator'
933         );
934         emit OperatorTransferred(address(0), newOperator_);
935         _operator = newOperator_;
936     }
937 }
938 
939 // File: contracts/utils/Epoch.sol
940 
941 pragma solidity ^0.6.0;
942 
943 
944 
945 contract Epoch is Operator {
946     using SafeMath for uint256;
947 
948     uint256 private period;
949     uint256 private startTime;
950     uint256 private epoch;
951 
952     /* ========== CONSTRUCTOR ========== */
953 
954     constructor(
955         uint256 _period,
956         uint256 _startTime,
957         uint256 _startEpoch
958     ) public {
959         period = _period;
960         startTime = _startTime;
961         epoch = _startEpoch;
962     }
963 
964     /* ========== Modifier ========== */
965 
966     modifier checkStartTime {
967         require(now >= startTime, 'Epoch: not started yet');
968 
969         _;
970     }
971 
972     modifier checkEpoch {
973         require(now >= nextEpochPoint(), 'Epoch: not allowed');
974 
975         _;
976 
977         epoch = epoch.add(1);
978     }
979 
980     /* ========== VIEW FUNCTIONS ========== */
981 
982     function getCurrentEpoch() public view returns (uint256) {
983         return epoch;
984     }
985 
986     function getPeriod() public view returns (uint256) {
987         return period;
988     }
989 
990     function getStartTime() public view returns (uint256) {
991         return startTime;
992     }
993 
994     function nextEpochPoint() public view returns (uint256) {
995         return startTime.add(epoch.mul(period));
996     }
997 
998     /* ========== GOVERNANCE ========== */
999 
1000     function setPeriod(uint256 _period) external onlyOperator {
1001         period = _period;
1002     }
1003 }
1004 
1005 // File: contracts/utils/ContractGuard.sol
1006 
1007 pragma solidity ^0.6.12;
1008 
1009 contract ContractGuard {
1010     mapping(uint256 => mapping(address => bool)) private _status;
1011 
1012     function checkSameOriginReentranted() internal view returns (bool) {
1013         return _status[block.number][tx.origin];
1014     }
1015 
1016     function checkSameSenderReentranted() internal view returns (bool) {
1017         return _status[block.number][msg.sender];
1018     }
1019 
1020     modifier onlyOneBlock() {
1021         require(
1022             !checkSameOriginReentranted(),
1023             'ContractGuard: one block, one function'
1024         );
1025         require(
1026             !checkSameSenderReentranted(),
1027             'ContractGuard: one block, one function'
1028         );
1029 
1030         _;
1031 
1032         _status[block.number][tx.origin] = true;
1033         _status[block.number][msg.sender] = true;
1034     }
1035 }
1036 
1037 // File: contracts/Treasury.sol
1038 
1039 pragma solidity ^0.6.0;
1040 
1041 
1042 
1043 
1044 
1045 
1046 
1047 
1048 
1049 
1050 
1051 
1052 
1053 
1054 
1055 /**
1056  * @title Basis Cash Treasury contract
1057  * @notice Monetary policy logic to adjust supplies of basis cash assets
1058  * @author Summer Smith & Rick Sanchez
1059  */
1060 contract Treasury is ContractGuard, Epoch {
1061     using FixedPoint for *;
1062     using SafeERC20 for IERC20;
1063     using Address for address;
1064     using SafeMath for uint256;
1065     using Safe112 for uint112;
1066 
1067     /* ========== STATE VARIABLES ========== */
1068 
1069     // ========== FLAGS
1070     bool public migrated = false;
1071     bool public initialized = false;
1072 
1073     // ========== CORE
1074     address public fund;
1075     address public cash;
1076     address public bond;
1077     address public share;
1078     address public boardroom;
1079 
1080     address public bondOracle;
1081     address public seigniorageOracle;
1082 
1083     // ========== PARAMS
1084     uint256 public cashPriceOne;
1085     uint256 public cashPriceCeiling;
1086     uint256 public bondDepletionFloor;
1087     uint256 private accumulatedSeigniorage = 0;
1088     uint256 public fundAllocationRate = 2; // %
1089 
1090     /* ========== CONSTRUCTOR ========== */
1091 
1092     constructor(
1093         address _cash,
1094         address _bond,
1095         address _share,
1096         address _bondOracle,
1097         address _seigniorageOracle,
1098         address _boardroom,
1099         address _fund,
1100         uint256 _startTime
1101     ) public Epoch(1 days, _startTime, 0) {
1102         cash = _cash;
1103         bond = _bond;
1104         share = _share;
1105         bondOracle = _bondOracle;
1106         seigniorageOracle = _seigniorageOracle;
1107 
1108         boardroom = _boardroom;
1109         fund = _fund;
1110 
1111         cashPriceOne = 10**18;
1112         cashPriceCeiling = uint256(105).mul(cashPriceOne).div(10**2);
1113 
1114         bondDepletionFloor = uint256(1000).mul(cashPriceOne);
1115     }
1116 
1117     /* =================== Modifier =================== */
1118 
1119     modifier checkMigration {
1120         require(!migrated, 'Treasury: migrated');
1121 
1122         _;
1123     }
1124 
1125     modifier checkOperator {
1126         require(
1127             IBasisAsset(cash).operator() == address(this) &&
1128                 IBasisAsset(bond).operator() == address(this) &&
1129                 IBasisAsset(share).operator() == address(this) &&
1130                 Operator(boardroom).operator() == address(this),
1131             'Treasury: need more permission'
1132         );
1133 
1134         _;
1135     }
1136 
1137     /* ========== VIEW FUNCTIONS ========== */
1138 
1139     // budget
1140     function getReserve() public view returns (uint256) {
1141         return accumulatedSeigniorage;
1142     }
1143 
1144     // oracle
1145     function getBondOraclePrice() public view returns (uint256) {
1146         return _getCashPrice(bondOracle);
1147     }
1148 
1149     function getSeigniorageOraclePrice() public view returns (uint256) {
1150         return _getCashPrice(seigniorageOracle);
1151     }
1152 
1153     function _getCashPrice(address oracle) internal view returns (uint256) {
1154         try IOracle(oracle).consult(cash, 1e18) returns (uint256 price) {
1155             return price.mul(1e12); // for USDT decimal
1156         } catch {
1157             revert('Treasury: failed to consult cash price from the oracle');
1158         }
1159     }
1160 
1161     /* ========== GOVERNANCE ========== */
1162 
1163     function initialize() public checkOperator {
1164         require(!initialized, 'Treasury: initialized');
1165 
1166         // burn all of it's balance
1167         IBasisAsset(cash).burn(IERC20(cash).balanceOf(address(this)));
1168 
1169         // set accumulatedSeigniorage to it's balance
1170         accumulatedSeigniorage = IERC20(cash).balanceOf(address(this));
1171 
1172         initialized = true;
1173         emit Initialized(msg.sender, block.number);
1174     }
1175 
1176     function migrate(address target) public onlyOperator checkOperator {
1177         require(!migrated, 'Treasury: migrated');
1178 
1179         // cash
1180         Operator(cash).transferOperator(target);
1181         Operator(cash).transferOwnership(target);
1182         IERC20(cash).transfer(target, IERC20(cash).balanceOf(address(this)));
1183 
1184         // bond
1185         Operator(bond).transferOperator(target);
1186         Operator(bond).transferOwnership(target);
1187         IERC20(bond).transfer(target, IERC20(bond).balanceOf(address(this)));
1188 
1189         // share
1190         Operator(share).transferOperator(target);
1191         Operator(share).transferOwnership(target);
1192         IERC20(share).transfer(target, IERC20(share).balanceOf(address(this)));
1193 
1194         migrated = true;
1195         emit Migration(target);
1196     }
1197 
1198     function setFund(address newFund) public onlyOperator {
1199         fund = newFund;
1200         emit ContributionPoolChanged(msg.sender, newFund);
1201     }
1202 
1203     function setFundAllocationRate(uint256 rate) public onlyOperator {
1204         fundAllocationRate = rate;
1205         emit ContributionPoolRateChanged(msg.sender, rate);
1206     }
1207 
1208     /* ========== MUTABLE FUNCTIONS ========== */
1209 
1210     function _updateCashPrice() internal {
1211         try IOracle(bondOracle).update()  {} catch {}
1212         try IOracle(seigniorageOracle).update()  {} catch {}
1213     }
1214 
1215     function buyBonds(uint256 amount, uint256 targetPrice)
1216         external
1217         onlyOneBlock
1218         checkMigration
1219         checkStartTime
1220         checkOperator
1221     {
1222         require(amount > 0, 'Treasury: cannot purchase bonds with zero amount');
1223 
1224         uint256 cashPrice = _getCashPrice(bondOracle);
1225         require(cashPrice == targetPrice, 'Treasury: cash price moved');
1226         require(
1227             cashPrice < cashPriceOne, // price < $1
1228             'Treasury: cashPrice not eligible for bond purchase'
1229         );
1230 
1231         uint256 bondPrice = cashPrice;
1232 
1233         IBasisAsset(cash).burnFrom(msg.sender, amount);
1234         IBasisAsset(bond).mint(msg.sender, amount.mul(1e18).div(bondPrice));
1235         _updateCashPrice();
1236 
1237         emit BoughtBonds(msg.sender, amount);
1238     }
1239 
1240     function redeemBonds(uint256 amount, uint256 targetPrice)
1241         external
1242         onlyOneBlock
1243         checkMigration
1244         checkStartTime
1245         checkOperator
1246     {
1247         require(amount > 0, 'Treasury: cannot redeem bonds with zero amount');
1248 
1249         uint256 cashPrice = _getCashPrice(bondOracle);
1250         require(cashPrice == targetPrice, 'Treasury: cash price moved');
1251         require(
1252             cashPrice > cashPriceCeiling, // price > $1.05
1253             'Treasury: cashPrice not eligible for bond purchase'
1254         );
1255         require(
1256             IERC20(cash).balanceOf(address(this)) >= amount,
1257             'Treasury: treasury has no more budget'
1258         );
1259 
1260         accumulatedSeigniorage = accumulatedSeigniorage.sub(
1261             Math.min(accumulatedSeigniorage, amount)
1262         );
1263 
1264         IBasisAsset(bond).burnFrom(msg.sender, amount);
1265         IERC20(cash).safeTransfer(msg.sender, amount);
1266         _updateCashPrice();
1267 
1268         emit RedeemedBonds(msg.sender, amount);
1269     }
1270 
1271     function allocateSeigniorage()
1272         external
1273         onlyOneBlock
1274         checkMigration
1275         checkStartTime
1276         checkEpoch
1277         checkOperator
1278     {
1279         _updateCashPrice();
1280         uint256 cashPrice = _getCashPrice(seigniorageOracle);
1281         if (cashPrice <= cashPriceCeiling) {
1282             return; // just advance epoch instead revert
1283         }
1284 
1285         // circulating supply
1286         uint256 cashSupply = IERC20(cash).totalSupply().sub(
1287             accumulatedSeigniorage
1288         );
1289         uint256 percentage = cashPrice.sub(cashPriceOne);
1290         uint256 seigniorage = cashSupply.mul(percentage).div(1e18);
1291         IBasisAsset(cash).mint(address(this), seigniorage);
1292 
1293         // ======================== BIP-3
1294         // uint256 fundReserve = seigniorage.mul(fundAllocationRate).div(100);
1295         // if (fundReserve > 0) {
1296         //     IERC20(cash).safeApprove(fund, fundReserve);
1297         //     ISimpleERCFund(fund).deposit(
1298         //         cash,
1299         //         fundReserve,
1300         //         'Treasury: Seigniorage Allocation'
1301         //     );
1302         //     emit ContributionPoolFunded(now, fundReserve);
1303         // }
1304 
1305         // seigniorage = seigniorage.sub(fundReserve);
1306 
1307         // ======================== BIP-4
1308         uint256 treasuryReserve = Math.min(
1309             seigniorage,
1310             IERC20(bond).totalSupply().sub(accumulatedSeigniorage)
1311         );
1312         if (treasuryReserve > 0) {
1313             accumulatedSeigniorage = accumulatedSeigniorage.add(
1314                 treasuryReserve
1315             );
1316             emit TreasuryFunded(now, treasuryReserve);
1317         }
1318 
1319         // boardroom
1320         uint256 boardroomReserve = seigniorage.sub(treasuryReserve);
1321         if (boardroomReserve > 0) {
1322             IERC20(cash).safeApprove(boardroom, boardroomReserve);
1323             IBoardroom(boardroom).allocateSeigniorage(boardroomReserve);
1324             emit BoardroomFunded(now, boardroomReserve);
1325         }
1326     }
1327 
1328     // GOV
1329     event Initialized(address indexed executor, uint256 at);
1330     event Migration(address indexed target);
1331     event ContributionPoolChanged(address indexed operator, address newFund);
1332     event ContributionPoolRateChanged(
1333         address indexed operator,
1334         uint256 newRate
1335     );
1336 
1337     // CORE
1338     event RedeemedBonds(address indexed from, uint256 amount);
1339     event BoughtBonds(address indexed from, uint256 amount);
1340     event TreasuryFunded(uint256 timestamp, uint256 seigniorage);
1341     event BoardroomFunded(uint256 timestamp, uint256 seigniorage);
1342     event ContributionPoolFunded(uint256 timestamp, uint256 seigniorage);
1343 }