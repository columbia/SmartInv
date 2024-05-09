1 // SPDX-License-Identifier: Unlicense
2 
3 pragma solidity 0.7.6;
4 
5 
6 
7 // Part: IVault
8 
9 interface IVault {
10     function deposit(
11         uint256,
12         uint256,
13         uint256,
14         uint256,
15         address
16     )
17         external
18         returns (
19             uint256,
20             uint256,
21             uint256
22         );
23 
24     function withdraw(
25         uint256,
26         uint256,
27         uint256,
28         address
29     ) external returns (uint256, uint256);
30 
31     function getTotalAmounts() external view returns (uint256, uint256);
32 }
33 
34 // Part: OpenZeppelin/openzeppelin-contracts@3.4.0/Address
35 
36 /**
37  * @dev Collection of functions related to the address type
38  */
39 library Address {
40     /**
41      * @dev Returns true if `account` is a contract.
42      *
43      * [IMPORTANT]
44      * ====
45      * It is unsafe to assume that an address for which this function returns
46      * false is an externally-owned account (EOA) and not a contract.
47      *
48      * Among others, `isContract` will return false for the following
49      * types of addresses:
50      *
51      *  - an externally-owned account
52      *  - a contract in construction
53      *  - an address where a contract will be created
54      *  - an address where a contract lived, but was destroyed
55      * ====
56      */
57     function isContract(address account) internal view returns (bool) {
58         // This method relies on extcodesize, which returns 0 for contracts in
59         // construction, since the code is only stored at the end of the
60         // constructor execution.
61 
62         uint256 size;
63         // solhint-disable-next-line no-inline-assembly
64         assembly { size := extcodesize(account) }
65         return size > 0;
66     }
67 
68     /**
69      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
70      * `recipient`, forwarding all available gas and reverting on errors.
71      *
72      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
73      * of certain opcodes, possibly making contracts go over the 2300 gas limit
74      * imposed by `transfer`, making them unable to receive funds via
75      * `transfer`. {sendValue} removes this limitation.
76      *
77      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
78      *
79      * IMPORTANT: because control is transferred to `recipient`, care must be
80      * taken to not create reentrancy vulnerabilities. Consider using
81      * {ReentrancyGuard} or the
82      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
83      */
84     function sendValue(address payable recipient, uint256 amount) internal {
85         require(address(this).balance >= amount, "Address: insufficient balance");
86 
87         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
88         (bool success, ) = recipient.call{ value: amount }("");
89         require(success, "Address: unable to send value, recipient may have reverted");
90     }
91 
92     /**
93      * @dev Performs a Solidity function call using a low level `call`. A
94      * plain`call` is an unsafe replacement for a function call: use this
95      * function instead.
96      *
97      * If `target` reverts with a revert reason, it is bubbled up by this
98      * function (like regular Solidity function calls).
99      *
100      * Returns the raw returned data. To convert to the expected return value,
101      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
102      *
103      * Requirements:
104      *
105      * - `target` must be a contract.
106      * - calling `target` with `data` must not revert.
107      *
108      * _Available since v3.1._
109      */
110     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
111       return functionCall(target, data, "Address: low-level call failed");
112     }
113 
114     /**
115      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
116      * `errorMessage` as a fallback revert reason when `target` reverts.
117      *
118      * _Available since v3.1._
119      */
120     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
121         return functionCallWithValue(target, data, 0, errorMessage);
122     }
123 
124     /**
125      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
126      * but also transferring `value` wei to `target`.
127      *
128      * Requirements:
129      *
130      * - the calling contract must have an ETH balance of at least `value`.
131      * - the called Solidity function must be `payable`.
132      *
133      * _Available since v3.1._
134      */
135     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
136         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
137     }
138 
139     /**
140      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
141      * with `errorMessage` as a fallback revert reason when `target` reverts.
142      *
143      * _Available since v3.1._
144      */
145     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
146         require(address(this).balance >= value, "Address: insufficient balance for call");
147         require(isContract(target), "Address: call to non-contract");
148 
149         // solhint-disable-next-line avoid-low-level-calls
150         (bool success, bytes memory returndata) = target.call{ value: value }(data);
151         return _verifyCallResult(success, returndata, errorMessage);
152     }
153 
154     /**
155      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
156      * but performing a static call.
157      *
158      * _Available since v3.3._
159      */
160     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
161         return functionStaticCall(target, data, "Address: low-level static call failed");
162     }
163 
164     /**
165      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
166      * but performing a static call.
167      *
168      * _Available since v3.3._
169      */
170     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
171         require(isContract(target), "Address: static call to non-contract");
172 
173         // solhint-disable-next-line avoid-low-level-calls
174         (bool success, bytes memory returndata) = target.staticcall(data);
175         return _verifyCallResult(success, returndata, errorMessage);
176     }
177 
178     /**
179      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
180      * but performing a delegate call.
181      *
182      * _Available since v3.4._
183      */
184     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
185         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
186     }
187 
188     /**
189      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
190      * but performing a delegate call.
191      *
192      * _Available since v3.4._
193      */
194     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
195         require(isContract(target), "Address: delegate call to non-contract");
196 
197         // solhint-disable-next-line avoid-low-level-calls
198         (bool success, bytes memory returndata) = target.delegatecall(data);
199         return _verifyCallResult(success, returndata, errorMessage);
200     }
201 
202     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
203         if (success) {
204             return returndata;
205         } else {
206             // Look for revert reason and bubble it up if present
207             if (returndata.length > 0) {
208                 // The easiest way to bubble the revert reason is using memory via assembly
209 
210                 // solhint-disable-next-line no-inline-assembly
211                 assembly {
212                     let returndata_size := mload(returndata)
213                     revert(add(32, returndata), returndata_size)
214                 }
215             } else {
216                 revert(errorMessage);
217             }
218         }
219     }
220 }
221 
222 // Part: OpenZeppelin/openzeppelin-contracts@3.4.0/Context
223 
224 /*
225  * @dev Provides information about the current execution context, including the
226  * sender of the transaction and its data. While these are generally available
227  * via msg.sender and msg.data, they should not be accessed in such a direct
228  * manner, since when dealing with GSN meta-transactions the account sending and
229  * paying for execution may not be the actual sender (as far as an application
230  * is concerned).
231  *
232  * This contract is only required for intermediate, library-like contracts.
233  */
234 abstract contract Context {
235     function _msgSender() internal view virtual returns (address payable) {
236         return msg.sender;
237     }
238 
239     function _msgData() internal view virtual returns (bytes memory) {
240         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
241         return msg.data;
242     }
243 }
244 
245 // Part: OpenZeppelin/openzeppelin-contracts@3.4.0/IERC20
246 
247 /**
248  * @dev Interface of the ERC20 standard as defined in the EIP.
249  */
250 interface IERC20 {
251     /**
252      * @dev Returns the amount of tokens in existence.
253      */
254     function totalSupply() external view returns (uint256);
255 
256     /**
257      * @dev Returns the amount of tokens owned by `account`.
258      */
259     function balanceOf(address account) external view returns (uint256);
260 
261     /**
262      * @dev Moves `amount` tokens from the caller's account to `recipient`.
263      *
264      * Returns a boolean value indicating whether the operation succeeded.
265      *
266      * Emits a {Transfer} event.
267      */
268     function transfer(address recipient, uint256 amount) external returns (bool);
269 
270     /**
271      * @dev Returns the remaining number of tokens that `spender` will be
272      * allowed to spend on behalf of `owner` through {transferFrom}. This is
273      * zero by default.
274      *
275      * This value changes when {approve} or {transferFrom} are called.
276      */
277     function allowance(address owner, address spender) external view returns (uint256);
278 
279     /**
280      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
281      *
282      * Returns a boolean value indicating whether the operation succeeded.
283      *
284      * IMPORTANT: Beware that changing an allowance with this method brings the risk
285      * that someone may use both the old and the new allowance by unfortunate
286      * transaction ordering. One possible solution to mitigate this race
287      * condition is to first reduce the spender's allowance to 0 and set the
288      * desired value afterwards:
289      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
290      *
291      * Emits an {Approval} event.
292      */
293     function approve(address spender, uint256 amount) external returns (bool);
294 
295     /**
296      * @dev Moves `amount` tokens from `sender` to `recipient` using the
297      * allowance mechanism. `amount` is then deducted from the caller's
298      * allowance.
299      *
300      * Returns a boolean value indicating whether the operation succeeded.
301      *
302      * Emits a {Transfer} event.
303      */
304     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
305 
306     /**
307      * @dev Emitted when `value` tokens are moved from one account (`from`) to
308      * another (`to`).
309      *
310      * Note that `value` may be zero.
311      */
312     event Transfer(address indexed from, address indexed to, uint256 value);
313 
314     /**
315      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
316      * a call to {approve}. `value` is the new allowance.
317      */
318     event Approval(address indexed owner, address indexed spender, uint256 value);
319 }
320 
321 // Part: OpenZeppelin/openzeppelin-contracts@3.4.0/Math
322 
323 /**
324  * @dev Standard math utilities missing in the Solidity language.
325  */
326 library Math {
327     /**
328      * @dev Returns the largest of two numbers.
329      */
330     function max(uint256 a, uint256 b) internal pure returns (uint256) {
331         return a >= b ? a : b;
332     }
333 
334     /**
335      * @dev Returns the smallest of two numbers.
336      */
337     function min(uint256 a, uint256 b) internal pure returns (uint256) {
338         return a < b ? a : b;
339     }
340 
341     /**
342      * @dev Returns the average of two numbers. The result is rounded towards
343      * zero.
344      */
345     function average(uint256 a, uint256 b) internal pure returns (uint256) {
346         // (a + b) / 2 can overflow, so we distribute
347         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
348     }
349 }
350 
351 // Part: OpenZeppelin/openzeppelin-contracts@3.4.0/ReentrancyGuard
352 
353 /**
354  * @dev Contract module that helps prevent reentrant calls to a function.
355  *
356  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
357  * available, which can be applied to functions to make sure there are no nested
358  * (reentrant) calls to them.
359  *
360  * Note that because there is a single `nonReentrant` guard, functions marked as
361  * `nonReentrant` may not call one another. This can be worked around by making
362  * those functions `private`, and then adding `external` `nonReentrant` entry
363  * points to them.
364  *
365  * TIP: If you would like to learn more about reentrancy and alternative ways
366  * to protect against it, check out our blog post
367  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
368  */
369 abstract contract ReentrancyGuard {
370     // Booleans are more expensive than uint256 or any type that takes up a full
371     // word because each write operation emits an extra SLOAD to first read the
372     // slot's contents, replace the bits taken up by the boolean, and then write
373     // back. This is the compiler's defense against contract upgrades and
374     // pointer aliasing, and it cannot be disabled.
375 
376     // The values being non-zero value makes deployment a bit more expensive,
377     // but in exchange the refund on every call to nonReentrant will be lower in
378     // amount. Since refunds are capped to a percentage of the total
379     // transaction's gas, it is best to keep them low in cases like this one, to
380     // increase the likelihood of the full refund coming into effect.
381     uint256 private constant _NOT_ENTERED = 1;
382     uint256 private constant _ENTERED = 2;
383 
384     uint256 private _status;
385 
386     constructor () internal {
387         _status = _NOT_ENTERED;
388     }
389 
390     /**
391      * @dev Prevents a contract from calling itself, directly or indirectly.
392      * Calling a `nonReentrant` function from another `nonReentrant`
393      * function is not supported. It is possible to prevent this from happening
394      * by making the `nonReentrant` function external, and make it call a
395      * `private` function that does the actual work.
396      */
397     modifier nonReentrant() {
398         // On the first call to nonReentrant, _notEntered will be true
399         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
400 
401         // Any calls to nonReentrant after this point will fail
402         _status = _ENTERED;
403 
404         _;
405 
406         // By storing the original value once again, a refund is triggered (see
407         // https://eips.ethereum.org/EIPS/eip-2200)
408         _status = _NOT_ENTERED;
409     }
410 }
411 
412 // Part: OpenZeppelin/openzeppelin-contracts@3.4.0/SafeMath
413 
414 /**
415  * @dev Wrappers over Solidity's arithmetic operations with added overflow
416  * checks.
417  *
418  * Arithmetic operations in Solidity wrap on overflow. This can easily result
419  * in bugs, because programmers usually assume that an overflow raises an
420  * error, which is the standard behavior in high level programming languages.
421  * `SafeMath` restores this intuition by reverting the transaction when an
422  * operation overflows.
423  *
424  * Using this library instead of the unchecked operations eliminates an entire
425  * class of bugs, so it's recommended to use it always.
426  */
427 library SafeMath {
428     /**
429      * @dev Returns the addition of two unsigned integers, with an overflow flag.
430      *
431      * _Available since v3.4._
432      */
433     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
434         uint256 c = a + b;
435         if (c < a) return (false, 0);
436         return (true, c);
437     }
438 
439     /**
440      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
441      *
442      * _Available since v3.4._
443      */
444     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
445         if (b > a) return (false, 0);
446         return (true, a - b);
447     }
448 
449     /**
450      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
451      *
452      * _Available since v3.4._
453      */
454     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
455         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
456         // benefit is lost if 'b' is also tested.
457         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
458         if (a == 0) return (true, 0);
459         uint256 c = a * b;
460         if (c / a != b) return (false, 0);
461         return (true, c);
462     }
463 
464     /**
465      * @dev Returns the division of two unsigned integers, with a division by zero flag.
466      *
467      * _Available since v3.4._
468      */
469     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
470         if (b == 0) return (false, 0);
471         return (true, a / b);
472     }
473 
474     /**
475      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
476      *
477      * _Available since v3.4._
478      */
479     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
480         if (b == 0) return (false, 0);
481         return (true, a % b);
482     }
483 
484     /**
485      * @dev Returns the addition of two unsigned integers, reverting on
486      * overflow.
487      *
488      * Counterpart to Solidity's `+` operator.
489      *
490      * Requirements:
491      *
492      * - Addition cannot overflow.
493      */
494     function add(uint256 a, uint256 b) internal pure returns (uint256) {
495         uint256 c = a + b;
496         require(c >= a, "SafeMath: addition overflow");
497         return c;
498     }
499 
500     /**
501      * @dev Returns the subtraction of two unsigned integers, reverting on
502      * overflow (when the result is negative).
503      *
504      * Counterpart to Solidity's `-` operator.
505      *
506      * Requirements:
507      *
508      * - Subtraction cannot overflow.
509      */
510     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
511         require(b <= a, "SafeMath: subtraction overflow");
512         return a - b;
513     }
514 
515     /**
516      * @dev Returns the multiplication of two unsigned integers, reverting on
517      * overflow.
518      *
519      * Counterpart to Solidity's `*` operator.
520      *
521      * Requirements:
522      *
523      * - Multiplication cannot overflow.
524      */
525     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
526         if (a == 0) return 0;
527         uint256 c = a * b;
528         require(c / a == b, "SafeMath: multiplication overflow");
529         return c;
530     }
531 
532     /**
533      * @dev Returns the integer division of two unsigned integers, reverting on
534      * division by zero. The result is rounded towards zero.
535      *
536      * Counterpart to Solidity's `/` operator. Note: this function uses a
537      * `revert` opcode (which leaves remaining gas untouched) while Solidity
538      * uses an invalid opcode to revert (consuming all remaining gas).
539      *
540      * Requirements:
541      *
542      * - The divisor cannot be zero.
543      */
544     function div(uint256 a, uint256 b) internal pure returns (uint256) {
545         require(b > 0, "SafeMath: division by zero");
546         return a / b;
547     }
548 
549     /**
550      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
551      * reverting when dividing by zero.
552      *
553      * Counterpart to Solidity's `%` operator. This function uses a `revert`
554      * opcode (which leaves remaining gas untouched) while Solidity uses an
555      * invalid opcode to revert (consuming all remaining gas).
556      *
557      * Requirements:
558      *
559      * - The divisor cannot be zero.
560      */
561     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
562         require(b > 0, "SafeMath: modulo by zero");
563         return a % b;
564     }
565 
566     /**
567      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
568      * overflow (when the result is negative).
569      *
570      * CAUTION: This function is deprecated because it requires allocating memory for the error
571      * message unnecessarily. For custom revert reasons use {trySub}.
572      *
573      * Counterpart to Solidity's `-` operator.
574      *
575      * Requirements:
576      *
577      * - Subtraction cannot overflow.
578      */
579     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
580         require(b <= a, errorMessage);
581         return a - b;
582     }
583 
584     /**
585      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
586      * division by zero. The result is rounded towards zero.
587      *
588      * CAUTION: This function is deprecated because it requires allocating memory for the error
589      * message unnecessarily. For custom revert reasons use {tryDiv}.
590      *
591      * Counterpart to Solidity's `/` operator. Note: this function uses a
592      * `revert` opcode (which leaves remaining gas untouched) while Solidity
593      * uses an invalid opcode to revert (consuming all remaining gas).
594      *
595      * Requirements:
596      *
597      * - The divisor cannot be zero.
598      */
599     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
600         require(b > 0, errorMessage);
601         return a / b;
602     }
603 
604     /**
605      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
606      * reverting with custom message when dividing by zero.
607      *
608      * CAUTION: This function is deprecated because it requires allocating memory for the error
609      * message unnecessarily. For custom revert reasons use {tryMod}.
610      *
611      * Counterpart to Solidity's `%` operator. This function uses a `revert`
612      * opcode (which leaves remaining gas untouched) while Solidity uses an
613      * invalid opcode to revert (consuming all remaining gas).
614      *
615      * Requirements:
616      *
617      * - The divisor cannot be zero.
618      */
619     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
620         require(b > 0, errorMessage);
621         return a % b;
622     }
623 }
624 
625 // Part: PositionKey
626 
627 library PositionKey {
628     /// @dev Returns the key of the position in the core library
629     function compute(
630         address owner,
631         int24 tickLower,
632         int24 tickUpper
633     ) internal pure returns (bytes32) {
634         return keccak256(abi.encodePacked(owner, tickLower, tickUpper));
635     }
636 }
637 
638 // Part: Uniswap/uniswap-v3-core@1.0.0/FixedPoint96
639 
640 /// @title FixedPoint96
641 /// @notice A library for handling binary fixed point numbers, see https://en.wikipedia.org/wiki/Q_(number_format)
642 /// @dev Used in SqrtPriceMath.sol
643 library FixedPoint96 {
644     uint8 internal constant RESOLUTION = 96;
645     uint256 internal constant Q96 = 0x1000000000000000000000000;
646 }
647 
648 // Part: Uniswap/uniswap-v3-core@1.0.0/FullMath
649 
650 /// @title Contains 512-bit math functions
651 /// @notice Facilitates multiplication and division that can have overflow of an intermediate value without any loss of precision
652 /// @dev Handles "phantom overflow" i.e., allows multiplication and division where an intermediate value overflows 256 bits
653 library FullMath {
654     /// @notice Calculates floor(a×b÷denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
655     /// @param a The multiplicand
656     /// @param b The multiplier
657     /// @param denominator The divisor
658     /// @return result The 256-bit result
659     /// @dev Credit to Remco Bloemen under MIT license https://xn--2-umb.com/21/muldiv
660     function mulDiv(
661         uint256 a,
662         uint256 b,
663         uint256 denominator
664     ) internal pure returns (uint256 result) {
665         // 512-bit multiply [prod1 prod0] = a * b
666         // Compute the product mod 2**256 and mod 2**256 - 1
667         // then use the Chinese Remainder Theorem to reconstruct
668         // the 512 bit result. The result is stored in two 256
669         // variables such that product = prod1 * 2**256 + prod0
670         uint256 prod0; // Least significant 256 bits of the product
671         uint256 prod1; // Most significant 256 bits of the product
672         assembly {
673             let mm := mulmod(a, b, not(0))
674             prod0 := mul(a, b)
675             prod1 := sub(sub(mm, prod0), lt(mm, prod0))
676         }
677 
678         // Handle non-overflow cases, 256 by 256 division
679         if (prod1 == 0) {
680             require(denominator > 0);
681             assembly {
682                 result := div(prod0, denominator)
683             }
684             return result;
685         }
686 
687         // Make sure the result is less than 2**256.
688         // Also prevents denominator == 0
689         require(denominator > prod1);
690 
691         ///////////////////////////////////////////////
692         // 512 by 256 division.
693         ///////////////////////////////////////////////
694 
695         // Make division exact by subtracting the remainder from [prod1 prod0]
696         // Compute remainder using mulmod
697         uint256 remainder;
698         assembly {
699             remainder := mulmod(a, b, denominator)
700         }
701         // Subtract 256 bit number from 512 bit number
702         assembly {
703             prod1 := sub(prod1, gt(remainder, prod0))
704             prod0 := sub(prod0, remainder)
705         }
706 
707         // Factor powers of two out of denominator
708         // Compute largest power of two divisor of denominator.
709         // Always >= 1.
710         uint256 twos = -denominator & denominator;
711         // Divide denominator by power of two
712         assembly {
713             denominator := div(denominator, twos)
714         }
715 
716         // Divide [prod1 prod0] by the factors of two
717         assembly {
718             prod0 := div(prod0, twos)
719         }
720         // Shift in bits from prod1 into prod0. For this we need
721         // to flip `twos` such that it is 2**256 / twos.
722         // If twos is zero, then it becomes one
723         assembly {
724             twos := add(div(sub(0, twos), twos), 1)
725         }
726         prod0 |= prod1 * twos;
727 
728         // Invert denominator mod 2**256
729         // Now that denominator is an odd number, it has an inverse
730         // modulo 2**256 such that denominator * inv = 1 mod 2**256.
731         // Compute the inverse by starting with a seed that is correct
732         // correct for four bits. That is, denominator * inv = 1 mod 2**4
733         uint256 inv = (3 * denominator) ^ 2;
734         // Now use Newton-Raphson iteration to improve the precision.
735         // Thanks to Hensel's lifting lemma, this also works in modular
736         // arithmetic, doubling the correct bits in each step.
737         inv *= 2 - denominator * inv; // inverse mod 2**8
738         inv *= 2 - denominator * inv; // inverse mod 2**16
739         inv *= 2 - denominator * inv; // inverse mod 2**32
740         inv *= 2 - denominator * inv; // inverse mod 2**64
741         inv *= 2 - denominator * inv; // inverse mod 2**128
742         inv *= 2 - denominator * inv; // inverse mod 2**256
743 
744         // Because the division is now exact we can divide by multiplying
745         // with the modular inverse of denominator. This will give us the
746         // correct result modulo 2**256. Since the precoditions guarantee
747         // that the outcome is less than 2**256, this is the final result.
748         // We don't need to compute the high bits of the result and prod1
749         // is no longer required.
750         result = prod0 * inv;
751         return result;
752     }
753 
754     /// @notice Calculates ceil(a×b÷denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
755     /// @param a The multiplicand
756     /// @param b The multiplier
757     /// @param denominator The divisor
758     /// @return result The 256-bit result
759     function mulDivRoundingUp(
760         uint256 a,
761         uint256 b,
762         uint256 denominator
763     ) internal pure returns (uint256 result) {
764         result = mulDiv(a, b, denominator);
765         if (mulmod(a, b, denominator) > 0) {
766             require(result < type(uint256).max);
767             result++;
768         }
769     }
770 }
771 
772 // Part: Uniswap/uniswap-v3-core@1.0.0/IUniswapV3MintCallback
773 
774 /// @title Callback for IUniswapV3PoolActions#mint
775 /// @notice Any contract that calls IUniswapV3PoolActions#mint must implement this interface
776 interface IUniswapV3MintCallback {
777     /// @notice Called to `msg.sender` after minting liquidity to a position from IUniswapV3Pool#mint.
778     /// @dev In the implementation you must pay the pool tokens owed for the minted liquidity.
779     /// The caller of this method must be checked to be a UniswapV3Pool deployed by the canonical UniswapV3Factory.
780     /// @param amount0Owed The amount of token0 due to the pool for the minted liquidity
781     /// @param amount1Owed The amount of token1 due to the pool for the minted liquidity
782     /// @param data Any data passed through by the caller via the IUniswapV3PoolActions#mint call
783     function uniswapV3MintCallback(
784         uint256 amount0Owed,
785         uint256 amount1Owed,
786         bytes calldata data
787     ) external;
788 }
789 
790 // Part: Uniswap/uniswap-v3-core@1.0.0/IUniswapV3PoolActions
791 
792 /// @title Permissionless pool actions
793 /// @notice Contains pool methods that can be called by anyone
794 interface IUniswapV3PoolActions {
795     /// @notice Sets the initial price for the pool
796     /// @dev Price is represented as a sqrt(amountToken1/amountToken0) Q64.96 value
797     /// @param sqrtPriceX96 the initial sqrt price of the pool as a Q64.96
798     function initialize(uint160 sqrtPriceX96) external;
799 
800     /// @notice Adds liquidity for the given recipient/tickLower/tickUpper position
801     /// @dev The caller of this method receives a callback in the form of IUniswapV3MintCallback#uniswapV3MintCallback
802     /// in which they must pay any token0 or token1 owed for the liquidity. The amount of token0/token1 due depends
803     /// on tickLower, tickUpper, the amount of liquidity, and the current price.
804     /// @param recipient The address for which the liquidity will be created
805     /// @param tickLower The lower tick of the position in which to add liquidity
806     /// @param tickUpper The upper tick of the position in which to add liquidity
807     /// @param amount The amount of liquidity to mint
808     /// @param data Any data that should be passed through to the callback
809     /// @return amount0 The amount of token0 that was paid to mint the given amount of liquidity. Matches the value in the callback
810     /// @return amount1 The amount of token1 that was paid to mint the given amount of liquidity. Matches the value in the callback
811     function mint(
812         address recipient,
813         int24 tickLower,
814         int24 tickUpper,
815         uint128 amount,
816         bytes calldata data
817     ) external returns (uint256 amount0, uint256 amount1);
818 
819     /// @notice Collects tokens owed to a position
820     /// @dev Does not recompute fees earned, which must be done either via mint or burn of any amount of liquidity.
821     /// Collect must be called by the position owner. To withdraw only token0 or only token1, amount0Requested or
822     /// amount1Requested may be set to zero. To withdraw all tokens owed, caller may pass any value greater than the
823     /// actual tokens owed, e.g. type(uint128).max. Tokens owed may be from accumulated swap fees or burned liquidity.
824     /// @param recipient The address which should receive the fees collected
825     /// @param tickLower The lower tick of the position for which to collect fees
826     /// @param tickUpper The upper tick of the position for which to collect fees
827     /// @param amount0Requested How much token0 should be withdrawn from the fees owed
828     /// @param amount1Requested How much token1 should be withdrawn from the fees owed
829     /// @return amount0 The amount of fees collected in token0
830     /// @return amount1 The amount of fees collected in token1
831     function collect(
832         address recipient,
833         int24 tickLower,
834         int24 tickUpper,
835         uint128 amount0Requested,
836         uint128 amount1Requested
837     ) external returns (uint128 amount0, uint128 amount1);
838 
839     /// @notice Burn liquidity from the sender and account tokens owed for the liquidity to the position
840     /// @dev Can be used to trigger a recalculation of fees owed to a position by calling with an amount of 0
841     /// @dev Fees must be collected separately via a call to #collect
842     /// @param tickLower The lower tick of the position for which to burn liquidity
843     /// @param tickUpper The upper tick of the position for which to burn liquidity
844     /// @param amount How much liquidity to burn
845     /// @return amount0 The amount of token0 sent to the recipient
846     /// @return amount1 The amount of token1 sent to the recipient
847     function burn(
848         int24 tickLower,
849         int24 tickUpper,
850         uint128 amount
851     ) external returns (uint256 amount0, uint256 amount1);
852 
853     /// @notice Swap token0 for token1, or token1 for token0
854     /// @dev The caller of this method receives a callback in the form of IUniswapV3SwapCallback#uniswapV3SwapCallback
855     /// @param recipient The address to receive the output of the swap
856     /// @param zeroForOne The direction of the swap, true for token0 to token1, false for token1 to token0
857     /// @param amountSpecified The amount of the swap, which implicitly configures the swap as exact input (positive), or exact output (negative)
858     /// @param sqrtPriceLimitX96 The Q64.96 sqrt price limit. If zero for one, the price cannot be less than this
859     /// value after the swap. If one for zero, the price cannot be greater than this value after the swap
860     /// @param data Any data to be passed through to the callback
861     /// @return amount0 The delta of the balance of token0 of the pool, exact when negative, minimum when positive
862     /// @return amount1 The delta of the balance of token1 of the pool, exact when negative, minimum when positive
863     function swap(
864         address recipient,
865         bool zeroForOne,
866         int256 amountSpecified,
867         uint160 sqrtPriceLimitX96,
868         bytes calldata data
869     ) external returns (int256 amount0, int256 amount1);
870 
871     /// @notice Receive token0 and/or token1 and pay it back, plus a fee, in the callback
872     /// @dev The caller of this method receives a callback in the form of IUniswapV3FlashCallback#uniswapV3FlashCallback
873     /// @dev Can be used to donate underlying tokens pro-rata to currently in-range liquidity providers by calling
874     /// with 0 amount{0,1} and sending the donation amount(s) from the callback
875     /// @param recipient The address which will receive the token0 and token1 amounts
876     /// @param amount0 The amount of token0 to send
877     /// @param amount1 The amount of token1 to send
878     /// @param data Any data to be passed through to the callback
879     function flash(
880         address recipient,
881         uint256 amount0,
882         uint256 amount1,
883         bytes calldata data
884     ) external;
885 
886     /// @notice Increase the maximum number of price and liquidity observations that this pool will store
887     /// @dev This method is no-op if the pool already has an observationCardinalityNext greater than or equal to
888     /// the input observationCardinalityNext.
889     /// @param observationCardinalityNext The desired minimum number of observations for the pool to store
890     function increaseObservationCardinalityNext(uint16 observationCardinalityNext) external;
891 }
892 
893 // Part: Uniswap/uniswap-v3-core@1.0.0/IUniswapV3PoolDerivedState
894 
895 /// @title Pool state that is not stored
896 /// @notice Contains view functions to provide information about the pool that is computed rather than stored on the
897 /// blockchain. The functions here may have variable gas costs.
898 interface IUniswapV3PoolDerivedState {
899     /// @notice Returns the cumulative tick and liquidity as of each timestamp `secondsAgo` from the current block timestamp
900     /// @dev To get a time weighted average tick or liquidity-in-range, you must call this with two values, one representing
901     /// the beginning of the period and another for the end of the period. E.g., to get the last hour time-weighted average tick,
902     /// you must call it with secondsAgos = [3600, 0].
903     /// @dev The time weighted average tick represents the geometric time weighted average price of the pool, in
904     /// log base sqrt(1.0001) of token1 / token0. The TickMath library can be used to go from a tick value to a ratio.
905     /// @param secondsAgos From how long ago each cumulative tick and liquidity value should be returned
906     /// @return tickCumulatives Cumulative tick values as of each `secondsAgos` from the current block timestamp
907     /// @return secondsPerLiquidityCumulativeX128s Cumulative seconds per liquidity-in-range value as of each `secondsAgos` from the current block
908     /// timestamp
909     function observe(uint32[] calldata secondsAgos)
910         external
911         view
912         returns (int56[] memory tickCumulatives, uint160[] memory secondsPerLiquidityCumulativeX128s);
913 
914     /// @notice Returns a snapshot of the tick cumulative, seconds per liquidity and seconds inside a tick range
915     /// @dev Snapshots must only be compared to other snapshots, taken over a period for which a position existed.
916     /// I.e., snapshots cannot be compared if a position is not held for the entire period between when the first
917     /// snapshot is taken and the second snapshot is taken.
918     /// @param tickLower The lower tick of the range
919     /// @param tickUpper The upper tick of the range
920     /// @return tickCumulativeInside The snapshot of the tick accumulator for the range
921     /// @return secondsPerLiquidityInsideX128 The snapshot of seconds per liquidity for the range
922     /// @return secondsInside The snapshot of seconds per liquidity for the range
923     function snapshotCumulativesInside(int24 tickLower, int24 tickUpper)
924         external
925         view
926         returns (
927             int56 tickCumulativeInside,
928             uint160 secondsPerLiquidityInsideX128,
929             uint32 secondsInside
930         );
931 }
932 
933 // Part: Uniswap/uniswap-v3-core@1.0.0/IUniswapV3PoolEvents
934 
935 /// @title Events emitted by a pool
936 /// @notice Contains all events emitted by the pool
937 interface IUniswapV3PoolEvents {
938     /// @notice Emitted exactly once by a pool when #initialize is first called on the pool
939     /// @dev Mint/Burn/Swap cannot be emitted by the pool before Initialize
940     /// @param sqrtPriceX96 The initial sqrt price of the pool, as a Q64.96
941     /// @param tick The initial tick of the pool, i.e. log base 1.0001 of the starting price of the pool
942     event Initialize(uint160 sqrtPriceX96, int24 tick);
943 
944     /// @notice Emitted when liquidity is minted for a given position
945     /// @param sender The address that minted the liquidity
946     /// @param owner The owner of the position and recipient of any minted liquidity
947     /// @param tickLower The lower tick of the position
948     /// @param tickUpper The upper tick of the position
949     /// @param amount The amount of liquidity minted to the position range
950     /// @param amount0 How much token0 was required for the minted liquidity
951     /// @param amount1 How much token1 was required for the minted liquidity
952     event Mint(
953         address sender,
954         address indexed owner,
955         int24 indexed tickLower,
956         int24 indexed tickUpper,
957         uint128 amount,
958         uint256 amount0,
959         uint256 amount1
960     );
961 
962     /// @notice Emitted when fees are collected by the owner of a position
963     /// @dev Collect events may be emitted with zero amount0 and amount1 when the caller chooses not to collect fees
964     /// @param owner The owner of the position for which fees are collected
965     /// @param tickLower The lower tick of the position
966     /// @param tickUpper The upper tick of the position
967     /// @param amount0 The amount of token0 fees collected
968     /// @param amount1 The amount of token1 fees collected
969     event Collect(
970         address indexed owner,
971         address recipient,
972         int24 indexed tickLower,
973         int24 indexed tickUpper,
974         uint128 amount0,
975         uint128 amount1
976     );
977 
978     /// @notice Emitted when a position's liquidity is removed
979     /// @dev Does not withdraw any fees earned by the liquidity position, which must be withdrawn via #collect
980     /// @param owner The owner of the position for which liquidity is removed
981     /// @param tickLower The lower tick of the position
982     /// @param tickUpper The upper tick of the position
983     /// @param amount The amount of liquidity to remove
984     /// @param amount0 The amount of token0 withdrawn
985     /// @param amount1 The amount of token1 withdrawn
986     event Burn(
987         address indexed owner,
988         int24 indexed tickLower,
989         int24 indexed tickUpper,
990         uint128 amount,
991         uint256 amount0,
992         uint256 amount1
993     );
994 
995     /// @notice Emitted by the pool for any swaps between token0 and token1
996     /// @param sender The address that initiated the swap call, and that received the callback
997     /// @param recipient The address that received the output of the swap
998     /// @param amount0 The delta of the token0 balance of the pool
999     /// @param amount1 The delta of the token1 balance of the pool
1000     /// @param sqrtPriceX96 The sqrt(price) of the pool after the swap, as a Q64.96
1001     /// @param liquidity The liquidity of the pool after the swap
1002     /// @param tick The log base 1.0001 of price of the pool after the swap
1003     event Swap(
1004         address indexed sender,
1005         address indexed recipient,
1006         int256 amount0,
1007         int256 amount1,
1008         uint160 sqrtPriceX96,
1009         uint128 liquidity,
1010         int24 tick
1011     );
1012 
1013     /// @notice Emitted by the pool for any flashes of token0/token1
1014     /// @param sender The address that initiated the swap call, and that received the callback
1015     /// @param recipient The address that received the tokens from flash
1016     /// @param amount0 The amount of token0 that was flashed
1017     /// @param amount1 The amount of token1 that was flashed
1018     /// @param paid0 The amount of token0 paid for the flash, which can exceed the amount0 plus the fee
1019     /// @param paid1 The amount of token1 paid for the flash, which can exceed the amount1 plus the fee
1020     event Flash(
1021         address indexed sender,
1022         address indexed recipient,
1023         uint256 amount0,
1024         uint256 amount1,
1025         uint256 paid0,
1026         uint256 paid1
1027     );
1028 
1029     /// @notice Emitted by the pool for increases to the number of observations that can be stored
1030     /// @dev observationCardinalityNext is not the observation cardinality until an observation is written at the index
1031     /// just before a mint/swap/burn.
1032     /// @param observationCardinalityNextOld The previous value of the next observation cardinality
1033     /// @param observationCardinalityNextNew The updated value of the next observation cardinality
1034     event IncreaseObservationCardinalityNext(
1035         uint16 observationCardinalityNextOld,
1036         uint16 observationCardinalityNextNew
1037     );
1038 
1039     /// @notice Emitted when the protocol fee is changed by the pool
1040     /// @param feeProtocol0Old The previous value of the token0 protocol fee
1041     /// @param feeProtocol1Old The previous value of the token1 protocol fee
1042     /// @param feeProtocol0New The updated value of the token0 protocol fee
1043     /// @param feeProtocol1New The updated value of the token1 protocol fee
1044     event SetFeeProtocol(uint8 feeProtocol0Old, uint8 feeProtocol1Old, uint8 feeProtocol0New, uint8 feeProtocol1New);
1045 
1046     /// @notice Emitted when the collected protocol fees are withdrawn by the factory owner
1047     /// @param sender The address that collects the protocol fees
1048     /// @param recipient The address that receives the collected protocol fees
1049     /// @param amount0 The amount of token0 protocol fees that is withdrawn
1050     /// @param amount0 The amount of token1 protocol fees that is withdrawn
1051     event CollectProtocol(address indexed sender, address indexed recipient, uint128 amount0, uint128 amount1);
1052 }
1053 
1054 // Part: Uniswap/uniswap-v3-core@1.0.0/IUniswapV3PoolImmutables
1055 
1056 /// @title Pool state that never changes
1057 /// @notice These parameters are fixed for a pool forever, i.e., the methods will always return the same values
1058 interface IUniswapV3PoolImmutables {
1059     /// @notice The contract that deployed the pool, which must adhere to the IUniswapV3Factory interface
1060     /// @return The contract address
1061     function factory() external view returns (address);
1062 
1063     /// @notice The first of the two tokens of the pool, sorted by address
1064     /// @return The token contract address
1065     function token0() external view returns (address);
1066 
1067     /// @notice The second of the two tokens of the pool, sorted by address
1068     /// @return The token contract address
1069     function token1() external view returns (address);
1070 
1071     /// @notice The pool's fee in hundredths of a bip, i.e. 1e-6
1072     /// @return The fee
1073     function fee() external view returns (uint24);
1074 
1075     /// @notice The pool tick spacing
1076     /// @dev Ticks can only be used at multiples of this value, minimum of 1 and always positive
1077     /// e.g.: a tickSpacing of 3 means ticks can be initialized every 3rd tick, i.e., ..., -6, -3, 0, 3, 6, ...
1078     /// This value is an int24 to avoid casting even though it is always positive.
1079     /// @return The tick spacing
1080     function tickSpacing() external view returns (int24);
1081 
1082     /// @notice The maximum amount of position liquidity that can use any tick in the range
1083     /// @dev This parameter is enforced per tick to prevent liquidity from overflowing a uint128 at any point, and
1084     /// also prevents out-of-range liquidity from being used to prevent adding in-range liquidity to a pool
1085     /// @return The max amount of liquidity per tick
1086     function maxLiquidityPerTick() external view returns (uint128);
1087 }
1088 
1089 // Part: Uniswap/uniswap-v3-core@1.0.0/IUniswapV3PoolOwnerActions
1090 
1091 /// @title Permissioned pool actions
1092 /// @notice Contains pool methods that may only be called by the factory owner
1093 interface IUniswapV3PoolOwnerActions {
1094     /// @notice Set the denominator of the protocol's % share of the fees
1095     /// @param feeProtocol0 new protocol fee for token0 of the pool
1096     /// @param feeProtocol1 new protocol fee for token1 of the pool
1097     function setFeeProtocol(uint8 feeProtocol0, uint8 feeProtocol1) external;
1098 
1099     /// @notice Collect the protocol fee accrued to the pool
1100     /// @param recipient The address to which collected protocol fees should be sent
1101     /// @param amount0Requested The maximum amount of token0 to send, can be 0 to collect fees in only token1
1102     /// @param amount1Requested The maximum amount of token1 to send, can be 0 to collect fees in only token0
1103     /// @return amount0 The protocol fee collected in token0
1104     /// @return amount1 The protocol fee collected in token1
1105     function collectProtocol(
1106         address recipient,
1107         uint128 amount0Requested,
1108         uint128 amount1Requested
1109     ) external returns (uint128 amount0, uint128 amount1);
1110 }
1111 
1112 // Part: Uniswap/uniswap-v3-core@1.0.0/IUniswapV3PoolState
1113 
1114 /// @title Pool state that can change
1115 /// @notice These methods compose the pool's state, and can change with any frequency including multiple times
1116 /// per transaction
1117 interface IUniswapV3PoolState {
1118     /// @notice The 0th storage slot in the pool stores many values, and is exposed as a single method to save gas
1119     /// when accessed externally.
1120     /// @return sqrtPriceX96 The current price of the pool as a sqrt(token1/token0) Q64.96 value
1121     /// tick The current tick of the pool, i.e. according to the last tick transition that was run.
1122     /// This value may not always be equal to SqrtTickMath.getTickAtSqrtRatio(sqrtPriceX96) if the price is on a tick
1123     /// boundary.
1124     /// observationIndex The index of the last oracle observation that was written,
1125     /// observationCardinality The current maximum number of observations stored in the pool,
1126     /// observationCardinalityNext The next maximum number of observations, to be updated when the observation.
1127     /// feeProtocol The protocol fee for both tokens of the pool.
1128     /// Encoded as two 4 bit values, where the protocol fee of token1 is shifted 4 bits and the protocol fee of token0
1129     /// is the lower 4 bits. Used as the denominator of a fraction of the swap fee, e.g. 4 means 1/4th of the swap fee.
1130     /// unlocked Whether the pool is currently locked to reentrancy
1131     function slot0()
1132         external
1133         view
1134         returns (
1135             uint160 sqrtPriceX96,
1136             int24 tick,
1137             uint16 observationIndex,
1138             uint16 observationCardinality,
1139             uint16 observationCardinalityNext,
1140             uint8 feeProtocol,
1141             bool unlocked
1142         );
1143 
1144     /// @notice The fee growth as a Q128.128 fees of token0 collected per unit of liquidity for the entire life of the pool
1145     /// @dev This value can overflow the uint256
1146     function feeGrowthGlobal0X128() external view returns (uint256);
1147 
1148     /// @notice The fee growth as a Q128.128 fees of token1 collected per unit of liquidity for the entire life of the pool
1149     /// @dev This value can overflow the uint256
1150     function feeGrowthGlobal1X128() external view returns (uint256);
1151 
1152     /// @notice The amounts of token0 and token1 that are owed to the protocol
1153     /// @dev Protocol fees will never exceed uint128 max in either token
1154     function protocolFees() external view returns (uint128 token0, uint128 token1);
1155 
1156     /// @notice The currently in range liquidity available to the pool
1157     /// @dev This value has no relationship to the total liquidity across all ticks
1158     function liquidity() external view returns (uint128);
1159 
1160     /// @notice Look up information about a specific tick in the pool
1161     /// @param tick The tick to look up
1162     /// @return liquidityGross the total amount of position liquidity that uses the pool either as tick lower or
1163     /// tick upper,
1164     /// liquidityNet how much liquidity changes when the pool price crosses the tick,
1165     /// feeGrowthOutside0X128 the fee growth on the other side of the tick from the current tick in token0,
1166     /// feeGrowthOutside1X128 the fee growth on the other side of the tick from the current tick in token1,
1167     /// tickCumulativeOutside the cumulative tick value on the other side of the tick from the current tick
1168     /// secondsPerLiquidityOutsideX128 the seconds spent per liquidity on the other side of the tick from the current tick,
1169     /// secondsOutside the seconds spent on the other side of the tick from the current tick,
1170     /// initialized Set to true if the tick is initialized, i.e. liquidityGross is greater than 0, otherwise equal to false.
1171     /// Outside values can only be used if the tick is initialized, i.e. if liquidityGross is greater than 0.
1172     /// In addition, these values are only relative and must be used only in comparison to previous snapshots for
1173     /// a specific position.
1174     function ticks(int24 tick)
1175         external
1176         view
1177         returns (
1178             uint128 liquidityGross,
1179             int128 liquidityNet,
1180             uint256 feeGrowthOutside0X128,
1181             uint256 feeGrowthOutside1X128,
1182             int56 tickCumulativeOutside,
1183             uint160 secondsPerLiquidityOutsideX128,
1184             uint32 secondsOutside,
1185             bool initialized
1186         );
1187 
1188     /// @notice Returns 256 packed tick initialized boolean values. See TickBitmap for more information
1189     function tickBitmap(int16 wordPosition) external view returns (uint256);
1190 
1191     /// @notice Returns the information about a position by the position's key
1192     /// @param key The position's key is a hash of a preimage composed by the owner, tickLower and tickUpper
1193     /// @return _liquidity The amount of liquidity in the position,
1194     /// Returns feeGrowthInside0LastX128 fee growth of token0 inside the tick range as of the last mint/burn/poke,
1195     /// Returns feeGrowthInside1LastX128 fee growth of token1 inside the tick range as of the last mint/burn/poke,
1196     /// Returns tokensOwed0 the computed amount of token0 owed to the position as of the last mint/burn/poke,
1197     /// Returns tokensOwed1 the computed amount of token1 owed to the position as of the last mint/burn/poke
1198     function positions(bytes32 key)
1199         external
1200         view
1201         returns (
1202             uint128 _liquidity,
1203             uint256 feeGrowthInside0LastX128,
1204             uint256 feeGrowthInside1LastX128,
1205             uint128 tokensOwed0,
1206             uint128 tokensOwed1
1207         );
1208 
1209     /// @notice Returns data about a specific observation index
1210     /// @param index The element of the observations array to fetch
1211     /// @dev You most likely want to use #observe() instead of this method to get an observation as of some amount of time
1212     /// ago, rather than at a specific index in the array.
1213     /// @return blockTimestamp The timestamp of the observation,
1214     /// Returns tickCumulative the tick multiplied by seconds elapsed for the life of the pool as of the observation timestamp,
1215     /// Returns secondsPerLiquidityCumulativeX128 the seconds per in range liquidity for the life of the pool as of the observation timestamp,
1216     /// Returns initialized whether the observation has been initialized and the values are safe to use
1217     function observations(uint256 index)
1218         external
1219         view
1220         returns (
1221             uint32 blockTimestamp,
1222             int56 tickCumulative,
1223             uint160 secondsPerLiquidityCumulativeX128,
1224             bool initialized
1225         );
1226 }
1227 
1228 // Part: Uniswap/uniswap-v3-core@1.0.0/IUniswapV3SwapCallback
1229 
1230 /// @title Callback for IUniswapV3PoolActions#swap
1231 /// @notice Any contract that calls IUniswapV3PoolActions#swap must implement this interface
1232 interface IUniswapV3SwapCallback {
1233     /// @notice Called to `msg.sender` after executing a swap via IUniswapV3Pool#swap.
1234     /// @dev In the implementation you must pay the pool tokens owed for the swap.
1235     /// The caller of this method must be checked to be a UniswapV3Pool deployed by the canonical UniswapV3Factory.
1236     /// amount0Delta and amount1Delta can both be 0 if no tokens were swapped.
1237     /// @param amount0Delta The amount of token0 that was sent (negative) or must be received (positive) by the pool by
1238     /// the end of the swap. If positive, the callback must send that amount of token0 to the pool.
1239     /// @param amount1Delta The amount of token1 that was sent (negative) or must be received (positive) by the pool by
1240     /// the end of the swap. If positive, the callback must send that amount of token1 to the pool.
1241     /// @param data Any data passed through by the caller via the IUniswapV3PoolActions#swap call
1242     function uniswapV3SwapCallback(
1243         int256 amount0Delta,
1244         int256 amount1Delta,
1245         bytes calldata data
1246     ) external;
1247 }
1248 
1249 // Part: Uniswap/uniswap-v3-core@1.0.0/TickMath
1250 
1251 /// @title Math library for computing sqrt prices from ticks and vice versa
1252 /// @notice Computes sqrt price for ticks of size 1.0001, i.e. sqrt(1.0001^tick) as fixed point Q64.96 numbers. Supports
1253 /// prices between 2**-128 and 2**128
1254 library TickMath {
1255     /// @dev The minimum tick that may be passed to #getSqrtRatioAtTick computed from log base 1.0001 of 2**-128
1256     int24 internal constant MIN_TICK = -887272;
1257     /// @dev The maximum tick that may be passed to #getSqrtRatioAtTick computed from log base 1.0001 of 2**128
1258     int24 internal constant MAX_TICK = -MIN_TICK;
1259 
1260     /// @dev The minimum value that can be returned from #getSqrtRatioAtTick. Equivalent to getSqrtRatioAtTick(MIN_TICK)
1261     uint160 internal constant MIN_SQRT_RATIO = 4295128739;
1262     /// @dev The maximum value that can be returned from #getSqrtRatioAtTick. Equivalent to getSqrtRatioAtTick(MAX_TICK)
1263     uint160 internal constant MAX_SQRT_RATIO = 1461446703485210103287273052203988822378723970342;
1264 
1265     /// @notice Calculates sqrt(1.0001^tick) * 2^96
1266     /// @dev Throws if |tick| > max tick
1267     /// @param tick The input tick for the above formula
1268     /// @return sqrtPriceX96 A Fixed point Q64.96 number representing the sqrt of the ratio of the two assets (token1/token0)
1269     /// at the given tick
1270     function getSqrtRatioAtTick(int24 tick) internal pure returns (uint160 sqrtPriceX96) {
1271         uint256 absTick = tick < 0 ? uint256(-int256(tick)) : uint256(int256(tick));
1272         require(absTick <= uint256(MAX_TICK), 'T');
1273 
1274         uint256 ratio = absTick & 0x1 != 0 ? 0xfffcb933bd6fad37aa2d162d1a594001 : 0x100000000000000000000000000000000;
1275         if (absTick & 0x2 != 0) ratio = (ratio * 0xfff97272373d413259a46990580e213a) >> 128;
1276         if (absTick & 0x4 != 0) ratio = (ratio * 0xfff2e50f5f656932ef12357cf3c7fdcc) >> 128;
1277         if (absTick & 0x8 != 0) ratio = (ratio * 0xffe5caca7e10e4e61c3624eaa0941cd0) >> 128;
1278         if (absTick & 0x10 != 0) ratio = (ratio * 0xffcb9843d60f6159c9db58835c926644) >> 128;
1279         if (absTick & 0x20 != 0) ratio = (ratio * 0xff973b41fa98c081472e6896dfb254c0) >> 128;
1280         if (absTick & 0x40 != 0) ratio = (ratio * 0xff2ea16466c96a3843ec78b326b52861) >> 128;
1281         if (absTick & 0x80 != 0) ratio = (ratio * 0xfe5dee046a99a2a811c461f1969c3053) >> 128;
1282         if (absTick & 0x100 != 0) ratio = (ratio * 0xfcbe86c7900a88aedcffc83b479aa3a4) >> 128;
1283         if (absTick & 0x200 != 0) ratio = (ratio * 0xf987a7253ac413176f2b074cf7815e54) >> 128;
1284         if (absTick & 0x400 != 0) ratio = (ratio * 0xf3392b0822b70005940c7a398e4b70f3) >> 128;
1285         if (absTick & 0x800 != 0) ratio = (ratio * 0xe7159475a2c29b7443b29c7fa6e889d9) >> 128;
1286         if (absTick & 0x1000 != 0) ratio = (ratio * 0xd097f3bdfd2022b8845ad8f792aa5825) >> 128;
1287         if (absTick & 0x2000 != 0) ratio = (ratio * 0xa9f746462d870fdf8a65dc1f90e061e5) >> 128;
1288         if (absTick & 0x4000 != 0) ratio = (ratio * 0x70d869a156d2a1b890bb3df62baf32f7) >> 128;
1289         if (absTick & 0x8000 != 0) ratio = (ratio * 0x31be135f97d08fd981231505542fcfa6) >> 128;
1290         if (absTick & 0x10000 != 0) ratio = (ratio * 0x9aa508b5b7a84e1c677de54f3e99bc9) >> 128;
1291         if (absTick & 0x20000 != 0) ratio = (ratio * 0x5d6af8dedb81196699c329225ee604) >> 128;
1292         if (absTick & 0x40000 != 0) ratio = (ratio * 0x2216e584f5fa1ea926041bedfe98) >> 128;
1293         if (absTick & 0x80000 != 0) ratio = (ratio * 0x48a170391f7dc42444e8fa2) >> 128;
1294 
1295         if (tick > 0) ratio = type(uint256).max / ratio;
1296 
1297         // this divides by 1<<32 rounding up to go from a Q128.128 to a Q128.96.
1298         // we then downcast because we know the result always fits within 160 bits due to our tick input constraint
1299         // we round up in the division so getTickAtSqrtRatio of the output price is always consistent
1300         sqrtPriceX96 = uint160((ratio >> 32) + (ratio % (1 << 32) == 0 ? 0 : 1));
1301     }
1302 
1303     /// @notice Calculates the greatest tick value such that getRatioAtTick(tick) <= ratio
1304     /// @dev Throws in case sqrtPriceX96 < MIN_SQRT_RATIO, as MIN_SQRT_RATIO is the lowest value getRatioAtTick may
1305     /// ever return.
1306     /// @param sqrtPriceX96 The sqrt ratio for which to compute the tick as a Q64.96
1307     /// @return tick The greatest tick for which the ratio is less than or equal to the input ratio
1308     function getTickAtSqrtRatio(uint160 sqrtPriceX96) internal pure returns (int24 tick) {
1309         // second inequality must be < because the price can never reach the price at the max tick
1310         require(sqrtPriceX96 >= MIN_SQRT_RATIO && sqrtPriceX96 < MAX_SQRT_RATIO, 'R');
1311         uint256 ratio = uint256(sqrtPriceX96) << 32;
1312 
1313         uint256 r = ratio;
1314         uint256 msb = 0;
1315 
1316         assembly {
1317             let f := shl(7, gt(r, 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF))
1318             msb := or(msb, f)
1319             r := shr(f, r)
1320         }
1321         assembly {
1322             let f := shl(6, gt(r, 0xFFFFFFFFFFFFFFFF))
1323             msb := or(msb, f)
1324             r := shr(f, r)
1325         }
1326         assembly {
1327             let f := shl(5, gt(r, 0xFFFFFFFF))
1328             msb := or(msb, f)
1329             r := shr(f, r)
1330         }
1331         assembly {
1332             let f := shl(4, gt(r, 0xFFFF))
1333             msb := or(msb, f)
1334             r := shr(f, r)
1335         }
1336         assembly {
1337             let f := shl(3, gt(r, 0xFF))
1338             msb := or(msb, f)
1339             r := shr(f, r)
1340         }
1341         assembly {
1342             let f := shl(2, gt(r, 0xF))
1343             msb := or(msb, f)
1344             r := shr(f, r)
1345         }
1346         assembly {
1347             let f := shl(1, gt(r, 0x3))
1348             msb := or(msb, f)
1349             r := shr(f, r)
1350         }
1351         assembly {
1352             let f := gt(r, 0x1)
1353             msb := or(msb, f)
1354         }
1355 
1356         if (msb >= 128) r = ratio >> (msb - 127);
1357         else r = ratio << (127 - msb);
1358 
1359         int256 log_2 = (int256(msb) - 128) << 64;
1360 
1361         assembly {
1362             r := shr(127, mul(r, r))
1363             let f := shr(128, r)
1364             log_2 := or(log_2, shl(63, f))
1365             r := shr(f, r)
1366         }
1367         assembly {
1368             r := shr(127, mul(r, r))
1369             let f := shr(128, r)
1370             log_2 := or(log_2, shl(62, f))
1371             r := shr(f, r)
1372         }
1373         assembly {
1374             r := shr(127, mul(r, r))
1375             let f := shr(128, r)
1376             log_2 := or(log_2, shl(61, f))
1377             r := shr(f, r)
1378         }
1379         assembly {
1380             r := shr(127, mul(r, r))
1381             let f := shr(128, r)
1382             log_2 := or(log_2, shl(60, f))
1383             r := shr(f, r)
1384         }
1385         assembly {
1386             r := shr(127, mul(r, r))
1387             let f := shr(128, r)
1388             log_2 := or(log_2, shl(59, f))
1389             r := shr(f, r)
1390         }
1391         assembly {
1392             r := shr(127, mul(r, r))
1393             let f := shr(128, r)
1394             log_2 := or(log_2, shl(58, f))
1395             r := shr(f, r)
1396         }
1397         assembly {
1398             r := shr(127, mul(r, r))
1399             let f := shr(128, r)
1400             log_2 := or(log_2, shl(57, f))
1401             r := shr(f, r)
1402         }
1403         assembly {
1404             r := shr(127, mul(r, r))
1405             let f := shr(128, r)
1406             log_2 := or(log_2, shl(56, f))
1407             r := shr(f, r)
1408         }
1409         assembly {
1410             r := shr(127, mul(r, r))
1411             let f := shr(128, r)
1412             log_2 := or(log_2, shl(55, f))
1413             r := shr(f, r)
1414         }
1415         assembly {
1416             r := shr(127, mul(r, r))
1417             let f := shr(128, r)
1418             log_2 := or(log_2, shl(54, f))
1419             r := shr(f, r)
1420         }
1421         assembly {
1422             r := shr(127, mul(r, r))
1423             let f := shr(128, r)
1424             log_2 := or(log_2, shl(53, f))
1425             r := shr(f, r)
1426         }
1427         assembly {
1428             r := shr(127, mul(r, r))
1429             let f := shr(128, r)
1430             log_2 := or(log_2, shl(52, f))
1431             r := shr(f, r)
1432         }
1433         assembly {
1434             r := shr(127, mul(r, r))
1435             let f := shr(128, r)
1436             log_2 := or(log_2, shl(51, f))
1437             r := shr(f, r)
1438         }
1439         assembly {
1440             r := shr(127, mul(r, r))
1441             let f := shr(128, r)
1442             log_2 := or(log_2, shl(50, f))
1443         }
1444 
1445         int256 log_sqrt10001 = log_2 * 255738958999603826347141; // 128.128 number
1446 
1447         int24 tickLow = int24((log_sqrt10001 - 3402992956809132418596140100660247210) >> 128);
1448         int24 tickHi = int24((log_sqrt10001 + 291339464771989622907027621153398088495) >> 128);
1449 
1450         tick = tickLow == tickHi ? tickLow : getSqrtRatioAtTick(tickHi) <= sqrtPriceX96 ? tickHi : tickLow;
1451     }
1452 }
1453 
1454 // Part: LiquidityAmounts
1455 
1456 /// @title Liquidity amount functions
1457 /// @notice Provides functions for computing liquidity amounts from token amounts and prices
1458 library LiquidityAmounts {
1459     /// @notice Downcasts uint256 to uint128
1460     /// @param x The uint258 to be downcasted
1461     /// @return y The passed value, downcasted to uint128
1462     function toUint128(uint256 x) private pure returns (uint128 y) {
1463         require((y = uint128(x)) == x);
1464     }
1465 
1466     /// @notice Computes the amount of liquidity received for a given amount of token0 and price range
1467     /// @dev Calculates amount0 * (sqrt(upper) * sqrt(lower)) / (sqrt(upper) - sqrt(lower))
1468     /// @param sqrtRatioAX96 A sqrt price representing the first tick boundary
1469     /// @param sqrtRatioBX96 A sqrt price representing the second tick boundary
1470     /// @param amount0 The amount0 being sent in
1471     /// @return liquidity The amount of returned liquidity
1472     function getLiquidityForAmount0(
1473         uint160 sqrtRatioAX96,
1474         uint160 sqrtRatioBX96,
1475         uint256 amount0
1476     ) internal pure returns (uint128 liquidity) {
1477         if (sqrtRatioAX96 > sqrtRatioBX96) (sqrtRatioAX96, sqrtRatioBX96) = (sqrtRatioBX96, sqrtRatioAX96);
1478         uint256 intermediate = FullMath.mulDiv(sqrtRatioAX96, sqrtRatioBX96, FixedPoint96.Q96);
1479         return toUint128(FullMath.mulDiv(amount0, intermediate, sqrtRatioBX96 - sqrtRatioAX96));
1480     }
1481 
1482     /// @notice Computes the amount of liquidity received for a given amount of token1 and price range
1483     /// @dev Calculates amount1 / (sqrt(upper) - sqrt(lower)).
1484     /// @param sqrtRatioAX96 A sqrt price representing the first tick boundary
1485     /// @param sqrtRatioBX96 A sqrt price representing the second tick boundary
1486     /// @param amount1 The amount1 being sent in
1487     /// @return liquidity The amount of returned liquidity
1488     function getLiquidityForAmount1(
1489         uint160 sqrtRatioAX96,
1490         uint160 sqrtRatioBX96,
1491         uint256 amount1
1492     ) internal pure returns (uint128 liquidity) {
1493         if (sqrtRatioAX96 > sqrtRatioBX96) (sqrtRatioAX96, sqrtRatioBX96) = (sqrtRatioBX96, sqrtRatioAX96);
1494         return toUint128(FullMath.mulDiv(amount1, FixedPoint96.Q96, sqrtRatioBX96 - sqrtRatioAX96));
1495     }
1496 
1497     /// @notice Computes the maximum amount of liquidity received for a given amount of token0, token1, the current
1498     /// pool prices and the prices at the tick boundaries
1499     /// @param sqrtRatioX96 A sqrt price representing the current pool prices
1500     /// @param sqrtRatioAX96 A sqrt price representing the first tick boundary
1501     /// @param sqrtRatioBX96 A sqrt price representing the second tick boundary
1502     /// @param amount0 The amount of token0 being sent in
1503     /// @param amount1 The amount of token1 being sent in
1504     /// @return liquidity The maximum amount of liquidity received
1505     function getLiquidityForAmounts(
1506         uint160 sqrtRatioX96,
1507         uint160 sqrtRatioAX96,
1508         uint160 sqrtRatioBX96,
1509         uint256 amount0,
1510         uint256 amount1
1511     ) internal pure returns (uint128 liquidity) {
1512         if (sqrtRatioAX96 > sqrtRatioBX96) (sqrtRatioAX96, sqrtRatioBX96) = (sqrtRatioBX96, sqrtRatioAX96);
1513 
1514         if (sqrtRatioX96 <= sqrtRatioAX96) {
1515             liquidity = getLiquidityForAmount0(sqrtRatioAX96, sqrtRatioBX96, amount0);
1516         } else if (sqrtRatioX96 < sqrtRatioBX96) {
1517             uint128 liquidity0 = getLiquidityForAmount0(sqrtRatioX96, sqrtRatioBX96, amount0);
1518             uint128 liquidity1 = getLiquidityForAmount1(sqrtRatioAX96, sqrtRatioX96, amount1);
1519 
1520             liquidity = liquidity0 < liquidity1 ? liquidity0 : liquidity1;
1521         } else {
1522             liquidity = getLiquidityForAmount1(sqrtRatioAX96, sqrtRatioBX96, amount1);
1523         }
1524     }
1525 
1526     /// @notice Computes the amount of token0 for a given amount of liquidity and a price range
1527     /// @param sqrtRatioAX96 A sqrt price representing the first tick boundary
1528     /// @param sqrtRatioBX96 A sqrt price representing the second tick boundary
1529     /// @param liquidity The liquidity being valued
1530     /// @return amount0 The amount of token0
1531     function getAmount0ForLiquidity(
1532         uint160 sqrtRatioAX96,
1533         uint160 sqrtRatioBX96,
1534         uint128 liquidity
1535     ) internal pure returns (uint256 amount0) {
1536         if (sqrtRatioAX96 > sqrtRatioBX96) (sqrtRatioAX96, sqrtRatioBX96) = (sqrtRatioBX96, sqrtRatioAX96);
1537 
1538         return
1539             FullMath.mulDiv(
1540                 uint256(liquidity) << FixedPoint96.RESOLUTION,
1541                 sqrtRatioBX96 - sqrtRatioAX96,
1542                 sqrtRatioBX96
1543             ) / sqrtRatioAX96;
1544     }
1545 
1546     /// @notice Computes the amount of token1 for a given amount of liquidity and a price range
1547     /// @param sqrtRatioAX96 A sqrt price representing the first tick boundary
1548     /// @param sqrtRatioBX96 A sqrt price representing the second tick boundary
1549     /// @param liquidity The liquidity being valued
1550     /// @return amount1 The amount of token1
1551     function getAmount1ForLiquidity(
1552         uint160 sqrtRatioAX96,
1553         uint160 sqrtRatioBX96,
1554         uint128 liquidity
1555     ) internal pure returns (uint256 amount1) {
1556         if (sqrtRatioAX96 > sqrtRatioBX96) (sqrtRatioAX96, sqrtRatioBX96) = (sqrtRatioBX96, sqrtRatioAX96);
1557 
1558         return FullMath.mulDiv(liquidity, sqrtRatioBX96 - sqrtRatioAX96, FixedPoint96.Q96);
1559     }
1560 
1561     /// @notice Computes the token0 and token1 value for a given amount of liquidity, the current
1562     /// pool prices and the prices at the tick boundaries
1563     /// @param sqrtRatioX96 A sqrt price representing the current pool prices
1564     /// @param sqrtRatioAX96 A sqrt price representing the first tick boundary
1565     /// @param sqrtRatioBX96 A sqrt price representing the second tick boundary
1566     /// @param liquidity The liquidity being valued
1567     /// @return amount0 The amount of token0
1568     /// @return amount1 The amount of token1
1569     function getAmountsForLiquidity(
1570         uint160 sqrtRatioX96,
1571         uint160 sqrtRatioAX96,
1572         uint160 sqrtRatioBX96,
1573         uint128 liquidity
1574     ) internal pure returns (uint256 amount0, uint256 amount1) {
1575         if (sqrtRatioAX96 > sqrtRatioBX96) (sqrtRatioAX96, sqrtRatioBX96) = (sqrtRatioBX96, sqrtRatioAX96);
1576 
1577         if (sqrtRatioX96 <= sqrtRatioAX96) {
1578             amount0 = getAmount0ForLiquidity(sqrtRatioAX96, sqrtRatioBX96, liquidity);
1579         } else if (sqrtRatioX96 < sqrtRatioBX96) {
1580             amount0 = getAmount0ForLiquidity(sqrtRatioX96, sqrtRatioBX96, liquidity);
1581             amount1 = getAmount1ForLiquidity(sqrtRatioAX96, sqrtRatioX96, liquidity);
1582         } else {
1583             amount1 = getAmount1ForLiquidity(sqrtRatioAX96, sqrtRatioBX96, liquidity);
1584         }
1585     }
1586 }
1587 
1588 // Part: OpenZeppelin/openzeppelin-contracts@3.4.0/ERC20
1589 
1590 /**
1591  * @dev Implementation of the {IERC20} interface.
1592  *
1593  * This implementation is agnostic to the way tokens are created. This means
1594  * that a supply mechanism has to be added in a derived contract using {_mint}.
1595  * For a generic mechanism see {ERC20PresetMinterPauser}.
1596  *
1597  * TIP: For a detailed writeup see our guide
1598  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
1599  * to implement supply mechanisms].
1600  *
1601  * We have followed general OpenZeppelin guidelines: functions revert instead
1602  * of returning `false` on failure. This behavior is nonetheless conventional
1603  * and does not conflict with the expectations of ERC20 applications.
1604  *
1605  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
1606  * This allows applications to reconstruct the allowance for all accounts just
1607  * by listening to said events. Other implementations of the EIP may not emit
1608  * these events, as it isn't required by the specification.
1609  *
1610  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
1611  * functions have been added to mitigate the well-known issues around setting
1612  * allowances. See {IERC20-approve}.
1613  */
1614 contract ERC20 is Context, IERC20 {
1615     using SafeMath for uint256;
1616 
1617     mapping (address => uint256) private _balances;
1618 
1619     mapping (address => mapping (address => uint256)) private _allowances;
1620 
1621     uint256 private _totalSupply;
1622 
1623     string private _name;
1624     string private _symbol;
1625     uint8 private _decimals;
1626 
1627     /**
1628      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
1629      * a default value of 18.
1630      *
1631      * To select a different value for {decimals}, use {_setupDecimals}.
1632      *
1633      * All three of these values are immutable: they can only be set once during
1634      * construction.
1635      */
1636     constructor (string memory name_, string memory symbol_) public {
1637         _name = name_;
1638         _symbol = symbol_;
1639         _decimals = 18;
1640     }
1641 
1642     /**
1643      * @dev Returns the name of the token.
1644      */
1645     function name() public view virtual returns (string memory) {
1646         return _name;
1647     }
1648 
1649     /**
1650      * @dev Returns the symbol of the token, usually a shorter version of the
1651      * name.
1652      */
1653     function symbol() public view virtual returns (string memory) {
1654         return _symbol;
1655     }
1656 
1657     /**
1658      * @dev Returns the number of decimals used to get its user representation.
1659      * For example, if `decimals` equals `2`, a balance of `505` tokens should
1660      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
1661      *
1662      * Tokens usually opt for a value of 18, imitating the relationship between
1663      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
1664      * called.
1665      *
1666      * NOTE: This information is only used for _display_ purposes: it in
1667      * no way affects any of the arithmetic of the contract, including
1668      * {IERC20-balanceOf} and {IERC20-transfer}.
1669      */
1670     function decimals() public view virtual returns (uint8) {
1671         return _decimals;
1672     }
1673 
1674     /**
1675      * @dev See {IERC20-totalSupply}.
1676      */
1677     function totalSupply() public view virtual override returns (uint256) {
1678         return _totalSupply;
1679     }
1680 
1681     /**
1682      * @dev See {IERC20-balanceOf}.
1683      */
1684     function balanceOf(address account) public view virtual override returns (uint256) {
1685         return _balances[account];
1686     }
1687 
1688     /**
1689      * @dev See {IERC20-transfer}.
1690      *
1691      * Requirements:
1692      *
1693      * - `recipient` cannot be the zero address.
1694      * - the caller must have a balance of at least `amount`.
1695      */
1696     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
1697         _transfer(_msgSender(), recipient, amount);
1698         return true;
1699     }
1700 
1701     /**
1702      * @dev See {IERC20-allowance}.
1703      */
1704     function allowance(address owner, address spender) public view virtual override returns (uint256) {
1705         return _allowances[owner][spender];
1706     }
1707 
1708     /**
1709      * @dev See {IERC20-approve}.
1710      *
1711      * Requirements:
1712      *
1713      * - `spender` cannot be the zero address.
1714      */
1715     function approve(address spender, uint256 amount) public virtual override returns (bool) {
1716         _approve(_msgSender(), spender, amount);
1717         return true;
1718     }
1719 
1720     /**
1721      * @dev See {IERC20-transferFrom}.
1722      *
1723      * Emits an {Approval} event indicating the updated allowance. This is not
1724      * required by the EIP. See the note at the beginning of {ERC20}.
1725      *
1726      * Requirements:
1727      *
1728      * - `sender` and `recipient` cannot be the zero address.
1729      * - `sender` must have a balance of at least `amount`.
1730      * - the caller must have allowance for ``sender``'s tokens of at least
1731      * `amount`.
1732      */
1733     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
1734         _transfer(sender, recipient, amount);
1735         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
1736         return true;
1737     }
1738 
1739     /**
1740      * @dev Atomically increases the allowance granted to `spender` by the caller.
1741      *
1742      * This is an alternative to {approve} that can be used as a mitigation for
1743      * problems described in {IERC20-approve}.
1744      *
1745      * Emits an {Approval} event indicating the updated allowance.
1746      *
1747      * Requirements:
1748      *
1749      * - `spender` cannot be the zero address.
1750      */
1751     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
1752         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
1753         return true;
1754     }
1755 
1756     /**
1757      * @dev Atomically decreases the allowance granted to `spender` by the caller.
1758      *
1759      * This is an alternative to {approve} that can be used as a mitigation for
1760      * problems described in {IERC20-approve}.
1761      *
1762      * Emits an {Approval} event indicating the updated allowance.
1763      *
1764      * Requirements:
1765      *
1766      * - `spender` cannot be the zero address.
1767      * - `spender` must have allowance for the caller of at least
1768      * `subtractedValue`.
1769      */
1770     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1771         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
1772         return true;
1773     }
1774 
1775     /**
1776      * @dev Moves tokens `amount` from `sender` to `recipient`.
1777      *
1778      * This is internal function is equivalent to {transfer}, and can be used to
1779      * e.g. implement automatic token fees, slashing mechanisms, etc.
1780      *
1781      * Emits a {Transfer} event.
1782      *
1783      * Requirements:
1784      *
1785      * - `sender` cannot be the zero address.
1786      * - `recipient` cannot be the zero address.
1787      * - `sender` must have a balance of at least `amount`.
1788      */
1789     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
1790         require(sender != address(0), "ERC20: transfer from the zero address");
1791         require(recipient != address(0), "ERC20: transfer to the zero address");
1792 
1793         _beforeTokenTransfer(sender, recipient, amount);
1794 
1795         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
1796         _balances[recipient] = _balances[recipient].add(amount);
1797         emit Transfer(sender, recipient, amount);
1798     }
1799 
1800     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1801      * the total supply.
1802      *
1803      * Emits a {Transfer} event with `from` set to the zero address.
1804      *
1805      * Requirements:
1806      *
1807      * - `to` cannot be the zero address.
1808      */
1809     function _mint(address account, uint256 amount) internal virtual {
1810         require(account != address(0), "ERC20: mint to the zero address");
1811 
1812         _beforeTokenTransfer(address(0), account, amount);
1813 
1814         _totalSupply = _totalSupply.add(amount);
1815         _balances[account] = _balances[account].add(amount);
1816         emit Transfer(address(0), account, amount);
1817     }
1818 
1819     /**
1820      * @dev Destroys `amount` tokens from `account`, reducing the
1821      * total supply.
1822      *
1823      * Emits a {Transfer} event with `to` set to the zero address.
1824      *
1825      * Requirements:
1826      *
1827      * - `account` cannot be the zero address.
1828      * - `account` must have at least `amount` tokens.
1829      */
1830     function _burn(address account, uint256 amount) internal virtual {
1831         require(account != address(0), "ERC20: burn from the zero address");
1832 
1833         _beforeTokenTransfer(account, address(0), amount);
1834 
1835         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
1836         _totalSupply = _totalSupply.sub(amount);
1837         emit Transfer(account, address(0), amount);
1838     }
1839 
1840     /**
1841      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
1842      *
1843      * This internal function is equivalent to `approve`, and can be used to
1844      * e.g. set automatic allowances for certain subsystems, etc.
1845      *
1846      * Emits an {Approval} event.
1847      *
1848      * Requirements:
1849      *
1850      * - `owner` cannot be the zero address.
1851      * - `spender` cannot be the zero address.
1852      */
1853     function _approve(address owner, address spender, uint256 amount) internal virtual {
1854         require(owner != address(0), "ERC20: approve from the zero address");
1855         require(spender != address(0), "ERC20: approve to the zero address");
1856 
1857         _allowances[owner][spender] = amount;
1858         emit Approval(owner, spender, amount);
1859     }
1860 
1861     /**
1862      * @dev Sets {decimals} to a value other than the default one of 18.
1863      *
1864      * WARNING: This function should only be called from the constructor. Most
1865      * applications that interact with token contracts will not expect
1866      * {decimals} to ever change, and may work incorrectly if it does.
1867      */
1868     function _setupDecimals(uint8 decimals_) internal virtual {
1869         _decimals = decimals_;
1870     }
1871 
1872     /**
1873      * @dev Hook that is called before any transfer of tokens. This includes
1874      * minting and burning.
1875      *
1876      * Calling conditions:
1877      *
1878      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1879      * will be to transferred to `to`.
1880      * - when `from` is zero, `amount` tokens will be minted for `to`.
1881      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1882      * - `from` and `to` are never both zero.
1883      *
1884      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1885      */
1886     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
1887 }
1888 
1889 // Part: OpenZeppelin/openzeppelin-contracts@3.4.0/SafeERC20
1890 
1891 /**
1892  * @title SafeERC20
1893  * @dev Wrappers around ERC20 operations that throw on failure (when the token
1894  * contract returns false). Tokens that return no value (and instead revert or
1895  * throw on failure) are also supported, non-reverting calls are assumed to be
1896  * successful.
1897  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
1898  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
1899  */
1900 library SafeERC20 {
1901     using SafeMath for uint256;
1902     using Address for address;
1903 
1904     function safeTransfer(IERC20 token, address to, uint256 value) internal {
1905         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
1906     }
1907 
1908     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
1909         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
1910     }
1911 
1912     /**
1913      * @dev Deprecated. This function has issues similar to the ones found in
1914      * {IERC20-approve}, and its usage is discouraged.
1915      *
1916      * Whenever possible, use {safeIncreaseAllowance} and
1917      * {safeDecreaseAllowance} instead.
1918      */
1919     function safeApprove(IERC20 token, address spender, uint256 value) internal {
1920         // safeApprove should only be called when setting an initial allowance,
1921         // or when resetting it to zero. To increase and decrease it, use
1922         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
1923         // solhint-disable-next-line max-line-length
1924         require((value == 0) || (token.allowance(address(this), spender) == 0),
1925             "SafeERC20: approve from non-zero to non-zero allowance"
1926         );
1927         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
1928     }
1929 
1930     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
1931         uint256 newAllowance = token.allowance(address(this), spender).add(value);
1932         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
1933     }
1934 
1935     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
1936         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
1937         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
1938     }
1939 
1940     /**
1941      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
1942      * on the return value: the return value is optional (but if data is returned, it must not be false).
1943      * @param token The token targeted by the call.
1944      * @param data The call data (encoded using abi.encode or one of its variants).
1945      */
1946     function _callOptionalReturn(IERC20 token, bytes memory data) private {
1947         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
1948         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
1949         // the target address contains contract code and also asserts for success in the low-level call.
1950 
1951         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
1952         if (returndata.length > 0) { // Return data is optional
1953             // solhint-disable-next-line max-line-length
1954             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
1955         }
1956     }
1957 }
1958 
1959 // Part: Uniswap/uniswap-v3-core@1.0.0/IUniswapV3Pool
1960 
1961 /// @title The interface for a Uniswap V3 Pool
1962 /// @notice A Uniswap pool facilitates swapping and automated market making between any two assets that strictly conform
1963 /// to the ERC20 specification
1964 /// @dev The pool interface is broken up into many smaller pieces
1965 interface IUniswapV3Pool is
1966     IUniswapV3PoolImmutables,
1967     IUniswapV3PoolState,
1968     IUniswapV3PoolDerivedState,
1969     IUniswapV3PoolActions,
1970     IUniswapV3PoolOwnerActions,
1971     IUniswapV3PoolEvents
1972 {
1973 
1974 }
1975 
1976 // File: AlphaVault.sol
1977 
1978 /**
1979  * @title   Alpha Vault
1980  * @notice  A vault that provides liquidity on Uniswap V3.
1981  */
1982 contract AlphaVault is
1983     IVault,
1984     IUniswapV3MintCallback,
1985     IUniswapV3SwapCallback,
1986     ERC20,
1987     ReentrancyGuard
1988 {
1989     using SafeERC20 for IERC20;
1990     using SafeMath for uint256;
1991 
1992     event Deposit(
1993         address indexed sender,
1994         address indexed to,
1995         uint256 shares,
1996         uint256 amount0,
1997         uint256 amount1
1998     );
1999 
2000     event Withdraw(
2001         address indexed sender,
2002         address indexed to,
2003         uint256 shares,
2004         uint256 amount0,
2005         uint256 amount1
2006     );
2007 
2008     event CollectFees(
2009         uint256 feesToVault0,
2010         uint256 feesToVault1,
2011         uint256 feesToProtocol0,
2012         uint256 feesToProtocol1
2013     );
2014 
2015     event Snapshot(int24 tick, uint256 totalAmount0, uint256 totalAmount1, uint256 totalSupply);
2016 
2017     IUniswapV3Pool public immutable pool;
2018     IERC20 public immutable token0;
2019     IERC20 public immutable token1;
2020     int24 public immutable tickSpacing;
2021 
2022     uint256 public protocolFee;
2023     uint256 public maxTotalSupply;
2024     address public strategy;
2025     address public governance;
2026     address public pendingGovernance;
2027 
2028     int24 public baseLower;
2029     int24 public baseUpper;
2030     int24 public limitLower;
2031     int24 public limitUpper;
2032     uint256 public accruedProtocolFees0;
2033     uint256 public accruedProtocolFees1;
2034 
2035     /**
2036      * @dev After deploying, strategy needs to be set via `setStrategy()`
2037      * @param _pool Underlying Uniswap V3 pool
2038      * @param _protocolFee Protocol fee expressed as multiple of 1e-6
2039      * @param _maxTotalSupply Cap on total supply
2040      */
2041     constructor(
2042         address _pool,
2043         uint256 _protocolFee,
2044         uint256 _maxTotalSupply
2045     ) ERC20("Alpha Vault", "AV") {
2046         pool = IUniswapV3Pool(_pool);
2047         token0 = IERC20(IUniswapV3Pool(_pool).token0());
2048         token1 = IERC20(IUniswapV3Pool(_pool).token1());
2049         tickSpacing = IUniswapV3Pool(_pool).tickSpacing();
2050 
2051         protocolFee = _protocolFee;
2052         maxTotalSupply = _maxTotalSupply;
2053         governance = msg.sender;
2054 
2055         require(_protocolFee < 1e6, "protocolFee");
2056     }
2057 
2058     /**
2059      * @notice Deposits tokens in proportion to the vault's current holdings.
2060      * @dev These tokens sit in the vault and are not used for liquidity on
2061      * Uniswap until the next rebalance. Also note it's not necessary to check
2062      * if user manipulated price to deposit cheaper, as the value of range
2063      * orders can only by manipulated higher.
2064      * @param amount0Desired Max amount of token0 to deposit
2065      * @param amount1Desired Max amount of token1 to deposit
2066      * @param amount0Min Revert if resulting `amount0` is less than this
2067      * @param amount1Min Revert if resulting `amount1` is less than this
2068      * @param to Recipient of shares
2069      * @return shares Number of shares minted
2070      * @return amount0 Amount of token0 deposited
2071      * @return amount1 Amount of token1 deposited
2072      */
2073     function deposit(
2074         uint256 amount0Desired,
2075         uint256 amount1Desired,
2076         uint256 amount0Min,
2077         uint256 amount1Min,
2078         address to
2079     )
2080         external
2081         override
2082         nonReentrant
2083         returns (
2084             uint256 shares,
2085             uint256 amount0,
2086             uint256 amount1
2087         )
2088     {
2089         require(amount0Desired > 0 || amount1Desired > 0, "amount0Desired or amount1Desired");
2090         require(to != address(0) && to != address(this), "to");
2091 
2092         // Poke positions so vault's current holdings are up-to-date
2093         _poke(baseLower, baseUpper);
2094         _poke(limitLower, limitUpper);
2095 
2096         // Calculate amounts proportional to vault's holdings
2097         (shares, amount0, amount1) = _calcSharesAndAmounts(amount0Desired, amount1Desired);
2098         require(shares > 0, "shares");
2099         require(amount0 >= amount0Min, "amount0Min");
2100         require(amount1 >= amount1Min, "amount1Min");
2101 
2102         // Pull in tokens from sender
2103         if (amount0 > 0) token0.safeTransferFrom(msg.sender, address(this), amount0);
2104         if (amount1 > 0) token1.safeTransferFrom(msg.sender, address(this), amount1);
2105 
2106         // Mint shares to recipient
2107         _mint(to, shares);
2108         emit Deposit(msg.sender, to, shares, amount0, amount1);
2109         require(totalSupply() <= maxTotalSupply, "maxTotalSupply");
2110     }
2111 
2112     /// @dev Do zero-burns to poke a position on Uniswap so earned fees are
2113     /// updated. Should be called if total amounts needs to include up-to-date
2114     /// fees.
2115     function _poke(int24 tickLower, int24 tickUpper) internal {
2116         (uint128 liquidity, , , , ) = _position(tickLower, tickUpper);
2117         if (liquidity > 0) {
2118             pool.burn(tickLower, tickUpper, 0);
2119         }
2120     }
2121 
2122     /// @dev Calculates the largest possible `amount0` and `amount1` such that
2123     /// they're in the same proportion as total amounts, but not greater than
2124     /// `amount0Desired` and `amount1Desired` respectively.
2125     function _calcSharesAndAmounts(uint256 amount0Desired, uint256 amount1Desired)
2126         internal
2127         view
2128         returns (
2129             uint256 shares,
2130             uint256 amount0,
2131             uint256 amount1
2132         )
2133     {
2134         uint256 totalSupply = totalSupply();
2135         (uint256 total0, uint256 total1) = getTotalAmounts();
2136 
2137         // If total supply > 0, vault can't be empty
2138         assert(totalSupply == 0 || total0 > 0 || total1 > 0);
2139 
2140         if (totalSupply == 0) {
2141             // For first deposit, just use the amounts desired
2142             amount0 = amount0Desired;
2143             amount1 = amount1Desired;
2144             shares = Math.max(amount0, amount1);
2145         } else if (total0 == 0) {
2146             amount1 = amount1Desired;
2147             shares = amount1.mul(totalSupply).div(total1);
2148         } else if (total1 == 0) {
2149             amount0 = amount0Desired;
2150             shares = amount0.mul(totalSupply).div(total0);
2151         } else {
2152             uint256 cross = Math.min(amount0Desired.mul(total1), amount1Desired.mul(total0));
2153             require(cross > 0, "cross");
2154 
2155             // Round up amounts
2156             amount0 = cross.sub(1).div(total1).add(1);
2157             amount1 = cross.sub(1).div(total0).add(1);
2158             shares = cross.mul(totalSupply).div(total0).div(total1);
2159         }
2160     }
2161 
2162     /**
2163      * @notice Withdraws tokens in proportion to the vault's holdings.
2164      * @param shares Shares burned by sender
2165      * @param amount0Min Revert if resulting `amount0` is smaller than this
2166      * @param amount1Min Revert if resulting `amount1` is smaller than this
2167      * @param to Recipient of tokens
2168      * @return amount0 Amount of token0 sent to recipient
2169      * @return amount1 Amount of token1 sent to recipient
2170      */
2171     function withdraw(
2172         uint256 shares,
2173         uint256 amount0Min,
2174         uint256 amount1Min,
2175         address to
2176     ) external override nonReentrant returns (uint256 amount0, uint256 amount1) {
2177         require(shares > 0, "shares");
2178         require(to != address(0) && to != address(this), "to");
2179         uint256 totalSupply = totalSupply();
2180 
2181         // Burn shares
2182         _burn(msg.sender, shares);
2183 
2184         // Calculate token amounts proportional to unused balances
2185         uint256 unusedAmount0 = getBalance0().mul(shares).div(totalSupply);
2186         uint256 unusedAmount1 = getBalance1().mul(shares).div(totalSupply);
2187 
2188         // Withdraw proportion of liquidity from Uniswap pool
2189         (uint256 baseAmount0, uint256 baseAmount1) =
2190             _burnLiquidityShare(baseLower, baseUpper, shares, totalSupply);
2191         (uint256 limitAmount0, uint256 limitAmount1) =
2192             _burnLiquidityShare(limitLower, limitUpper, shares, totalSupply);
2193 
2194         // Sum up total amounts owed to recipient
2195         amount0 = unusedAmount0.add(baseAmount0).add(limitAmount0);
2196         amount1 = unusedAmount1.add(baseAmount1).add(limitAmount1);
2197         require(amount0 >= amount0Min, "amount0Min");
2198         require(amount1 >= amount1Min, "amount1Min");
2199 
2200         // Push tokens to recipient
2201         if (amount0 > 0) token0.safeTransfer(to, amount0);
2202         if (amount1 > 0) token1.safeTransfer(to, amount1);
2203 
2204         emit Withdraw(msg.sender, to, shares, amount0, amount1);
2205     }
2206 
2207     /// @dev Withdraws share of liquidity in a range from Uniswap pool.
2208     function _burnLiquidityShare(
2209         int24 tickLower,
2210         int24 tickUpper,
2211         uint256 shares,
2212         uint256 totalSupply
2213     ) internal returns (uint256 amount0, uint256 amount1) {
2214         (uint128 totalLiquidity, , , , ) = _position(tickLower, tickUpper);
2215         uint256 liquidity = uint256(totalLiquidity).mul(shares).div(totalSupply);
2216 
2217         if (liquidity > 0) {
2218             (uint256 burned0, uint256 burned1, uint256 fees0, uint256 fees1) =
2219                 _burnAndCollect(tickLower, tickUpper, _toUint128(liquidity));
2220 
2221             // Add share of fees
2222             amount0 = burned0.add(fees0.mul(shares).div(totalSupply));
2223             amount1 = burned1.add(fees1.mul(shares).div(totalSupply));
2224         }
2225     }
2226 
2227     /**
2228      * @notice Updates vault's positions. Can only be called by the strategy.
2229      * @dev Two orders are placed - a base order and a limit order. The base
2230      * order is placed first with as much liquidity as possible. This order
2231      * should use up all of one token, leaving only the other one. This excess
2232      * amount is then placed as a single-sided bid or ask order.
2233      */
2234     function rebalance(
2235         int256 swapAmount,
2236         uint160 sqrtPriceLimitX96,
2237         int24 _baseLower,
2238         int24 _baseUpper,
2239         int24 _bidLower,
2240         int24 _bidUpper,
2241         int24 _askLower,
2242         int24 _askUpper
2243     ) external nonReentrant {
2244         require(msg.sender == strategy, "strategy");
2245         _checkRange(_baseLower, _baseUpper);
2246         _checkRange(_bidLower, _bidUpper);
2247         _checkRange(_askLower, _askUpper);
2248 
2249         (, int24 tick, , , , , ) = pool.slot0();
2250         require(_bidUpper <= tick, "bidUpper");
2251         require(_askLower > tick, "askLower"); // inequality is strict as tick is rounded down
2252 
2253         // Withdraw all current liquidity from Uniswap pool
2254         {
2255             (uint128 baseLiquidity, , , , ) = _position(baseLower, baseUpper);
2256             (uint128 limitLiquidity, , , , ) = _position(limitLower, limitUpper);
2257             _burnAndCollect(baseLower, baseUpper, baseLiquidity);
2258             _burnAndCollect(limitLower, limitUpper, limitLiquidity);
2259         }
2260 
2261         // Emit snapshot to record balances and supply
2262         uint256 balance0 = getBalance0();
2263         uint256 balance1 = getBalance1();
2264         emit Snapshot(tick, balance0, balance1, totalSupply());
2265 
2266         if (swapAmount != 0) {
2267             pool.swap(
2268                 address(this),
2269                 swapAmount > 0,
2270                 swapAmount > 0 ? swapAmount : -swapAmount,
2271                 sqrtPriceLimitX96,
2272                 ""
2273             );
2274             balance0 = getBalance0();
2275             balance1 = getBalance1();
2276         }
2277 
2278         // Place base order on Uniswap
2279         uint128 liquidity = _liquidityForAmounts(_baseLower, _baseUpper, balance0, balance1);
2280         _mintLiquidity(_baseLower, _baseUpper, liquidity);
2281         (baseLower, baseUpper) = (_baseLower, _baseUpper);
2282 
2283         balance0 = getBalance0();
2284         balance1 = getBalance1();
2285 
2286         // Place bid or ask order on Uniswap depending on which token is left
2287         uint128 bidLiquidity = _liquidityForAmounts(_bidLower, _bidUpper, balance0, balance1);
2288         uint128 askLiquidity = _liquidityForAmounts(_askLower, _askUpper, balance0, balance1);
2289         if (bidLiquidity > askLiquidity) {
2290             _mintLiquidity(_bidLower, _bidUpper, bidLiquidity);
2291             (limitLower, limitUpper) = (_bidLower, _bidUpper);
2292         } else {
2293             _mintLiquidity(_askLower, _askUpper, askLiquidity);
2294             (limitLower, limitUpper) = (_askLower, _askUpper);
2295         }
2296     }
2297 
2298     function _checkRange(int24 tickLower, int24 tickUpper) internal view {
2299         int24 _tickSpacing = tickSpacing;
2300         require(tickLower < tickUpper, "tickLower < tickUpper");
2301         require(tickLower >= TickMath.MIN_TICK, "tickLower too low");
2302         require(tickUpper <= TickMath.MAX_TICK, "tickUpper too high");
2303         require(tickLower % _tickSpacing == 0, "tickLower % tickSpacing");
2304         require(tickUpper % _tickSpacing == 0, "tickUpper % tickSpacing");
2305     }
2306 
2307     /// @dev Withdraws liquidity from a range and collects all fees in the
2308     /// process.
2309     function _burnAndCollect(
2310         int24 tickLower,
2311         int24 tickUpper,
2312         uint128 liquidity
2313     )
2314         internal
2315         returns (
2316             uint256 burned0,
2317             uint256 burned1,
2318             uint256 feesToVault0,
2319             uint256 feesToVault1
2320         )
2321     {
2322         if (liquidity > 0) {
2323             (burned0, burned1) = pool.burn(tickLower, tickUpper, liquidity);
2324         }
2325 
2326         // Collect all owed tokens including earned fees
2327         (uint256 collect0, uint256 collect1) =
2328             pool.collect(
2329                 address(this),
2330                 tickLower,
2331                 tickUpper,
2332                 type(uint128).max,
2333                 type(uint128).max
2334             );
2335 
2336         feesToVault0 = collect0.sub(burned0);
2337         feesToVault1 = collect1.sub(burned1);
2338         uint256 feesToProtocol0;
2339         uint256 feesToProtocol1;
2340 
2341         // Update accrued protocol fees
2342         uint256 _protocolFee = protocolFee;
2343         if (_protocolFee > 0) {
2344             feesToProtocol0 = feesToVault0.mul(_protocolFee).div(1e6);
2345             feesToProtocol1 = feesToVault1.mul(_protocolFee).div(1e6);
2346             feesToVault0 = feesToVault0.sub(feesToProtocol0);
2347             feesToVault1 = feesToVault1.sub(feesToProtocol1);
2348             accruedProtocolFees0 = accruedProtocolFees0.add(feesToProtocol0);
2349             accruedProtocolFees1 = accruedProtocolFees1.add(feesToProtocol1);
2350         }
2351         emit CollectFees(feesToVault0, feesToVault1, feesToProtocol0, feesToProtocol1);
2352     }
2353 
2354     /// @dev Deposits liquidity in a range on the Uniswap pool.
2355     function _mintLiquidity(
2356         int24 tickLower,
2357         int24 tickUpper,
2358         uint128 liquidity
2359     ) internal {
2360         if (liquidity > 0) {
2361             pool.mint(address(this), tickLower, tickUpper, liquidity, "");
2362         }
2363     }
2364 
2365     /**
2366      * @notice Calculates the vault's total holdings of token0 and token1 - in
2367      * other words, how much of each token the vault would hold if it withdrew
2368      * all its liquidity from Uniswap.
2369      */
2370     function getTotalAmounts() public view override returns (uint256 total0, uint256 total1) {
2371         (uint256 baseAmount0, uint256 baseAmount1) = getPositionAmounts(baseLower, baseUpper);
2372         (uint256 limitAmount0, uint256 limitAmount1) =
2373             getPositionAmounts(limitLower, limitUpper);
2374         total0 = getBalance0().add(baseAmount0).add(limitAmount0);
2375         total1 = getBalance1().add(baseAmount1).add(limitAmount1);
2376     }
2377 
2378     /**
2379      * @notice Amounts of token0 and token1 held in vault's position. Includes
2380      * owed fees but excludes the proportion of fees that will be paid to the
2381      * protocol. Doesn't include fees accrued since last poke.
2382      */
2383     function getPositionAmounts(int24 tickLower, int24 tickUpper)
2384         public
2385         view
2386         returns (uint256 amount0, uint256 amount1)
2387     {
2388         (uint128 liquidity, , , uint128 tokensOwed0, uint128 tokensOwed1) =
2389             _position(tickLower, tickUpper);
2390         (amount0, amount1) = _amountsForLiquidity(tickLower, tickUpper, liquidity);
2391 
2392         // Subtract protocol fees
2393         uint256 oneMinusFee = uint256(1e6).sub(protocolFee);
2394         amount0 = amount0.add(uint256(tokensOwed0).mul(oneMinusFee).div(1e6));
2395         amount1 = amount1.add(uint256(tokensOwed1).mul(oneMinusFee).div(1e6));
2396     }
2397 
2398     /**
2399      * @notice Balance of token0 in vault not used in any position.
2400      */
2401     function getBalance0() public view returns (uint256) {
2402         return token0.balanceOf(address(this)).sub(accruedProtocolFees0);
2403     }
2404 
2405     /**
2406      * @notice Balance of token1 in vault not used in any position.
2407      */
2408     function getBalance1() public view returns (uint256) {
2409         return token1.balanceOf(address(this)).sub(accruedProtocolFees1);
2410     }
2411 
2412     /// @dev Wrapper around `IUniswapV3Pool.positions()`.
2413     function _position(int24 tickLower, int24 tickUpper)
2414         internal
2415         view
2416         returns (
2417             uint128,
2418             uint256,
2419             uint256,
2420             uint128,
2421             uint128
2422         )
2423     {
2424         bytes32 positionKey = PositionKey.compute(address(this), tickLower, tickUpper);
2425         return pool.positions(positionKey);
2426     }
2427 
2428     /// @dev Wrapper around `LiquidityAmounts.getAmountsForLiquidity()`.
2429     function _amountsForLiquidity(
2430         int24 tickLower,
2431         int24 tickUpper,
2432         uint128 liquidity
2433     ) internal view returns (uint256, uint256) {
2434         (uint160 sqrtRatioX96, , , , , , ) = pool.slot0();
2435         return
2436             LiquidityAmounts.getAmountsForLiquidity(
2437                 sqrtRatioX96,
2438                 TickMath.getSqrtRatioAtTick(tickLower),
2439                 TickMath.getSqrtRatioAtTick(tickUpper),
2440                 liquidity
2441             );
2442     }
2443 
2444     /// @dev Wrapper around `LiquidityAmounts.getLiquidityForAmounts()`.
2445     function _liquidityForAmounts(
2446         int24 tickLower,
2447         int24 tickUpper,
2448         uint256 amount0,
2449         uint256 amount1
2450     ) internal view returns (uint128) {
2451         (uint160 sqrtRatioX96, , , , , , ) = pool.slot0();
2452         return
2453             LiquidityAmounts.getLiquidityForAmounts(
2454                 sqrtRatioX96,
2455                 TickMath.getSqrtRatioAtTick(tickLower),
2456                 TickMath.getSqrtRatioAtTick(tickUpper),
2457                 amount0,
2458                 amount1
2459             );
2460     }
2461 
2462     /// @dev Casts uint256 to uint128 with overflow check.
2463     function _toUint128(uint256 x) internal pure returns (uint128) {
2464         assert(x <= type(uint128).max);
2465         return uint128(x);
2466     }
2467 
2468     /// @dev Callback for Uniswap V3 pool.
2469     function uniswapV3MintCallback(
2470         uint256 amount0,
2471         uint256 amount1,
2472         bytes calldata data
2473     ) external override {
2474         require(msg.sender == address(pool));
2475         if (amount0 > 0) token0.safeTransfer(msg.sender, amount0);
2476         if (amount1 > 0) token1.safeTransfer(msg.sender, amount1);
2477     }
2478 
2479     /// @dev Callback for Uniswap V3 pool.
2480     function uniswapV3SwapCallback(
2481         int256 amount0Delta,
2482         int256 amount1Delta,
2483         bytes calldata data
2484     ) external override {
2485         require(msg.sender == address(pool));
2486         if (amount0Delta > 0) token0.safeTransfer(msg.sender, uint256(amount0Delta));
2487         if (amount1Delta > 0) token1.safeTransfer(msg.sender, uint256(amount1Delta));
2488     }
2489 
2490     /**
2491      * @notice Used to collect accumulated protocol fees.
2492      */
2493     function collectProtocol(
2494         uint256 amount0,
2495         uint256 amount1,
2496         address to
2497     ) external onlyGovernance {
2498         accruedProtocolFees0 = accruedProtocolFees0.sub(amount0);
2499         accruedProtocolFees1 = accruedProtocolFees1.sub(amount1);
2500         if (amount0 > 0) token0.safeTransfer(to, amount0);
2501         if (amount1 > 0) token1.safeTransfer(to, amount1);
2502     }
2503 
2504     /**
2505      * @notice Removes tokens accidentally sent to this vault.
2506      */
2507     function sweep(
2508         IERC20 token,
2509         uint256 amount,
2510         address to
2511     ) external onlyGovernance {
2512         require(token != token0 && token != token1, "token");
2513         token.safeTransfer(to, amount);
2514     }
2515 
2516     /**
2517      * @notice Used to set the strategy contract that determines the position
2518      * ranges and calls rebalance(). Must be called after this vault is
2519      * deployed.
2520      */
2521     function setStrategy(address _strategy) external onlyGovernance {
2522         strategy = _strategy;
2523     }
2524 
2525     /**
2526      * @notice Used to change the protocol fee charged on pool fees earned from
2527      * Uniswap, expressed as multiple of 1e-6.
2528      */
2529     function setProtocolFee(uint256 _protocolFee) external onlyGovernance {
2530         require(_protocolFee < 1e6, "protocolFee");
2531         protocolFee = _protocolFee;
2532     }
2533 
2534     /**
2535      * @notice Used to change deposit cap for a guarded launch or to ensure
2536      * vault doesn't grow too large relative to the pool. Cap is on total
2537      * supply rather than amounts of token0 and token1 as those amounts
2538      * fluctuate naturally over time.
2539      */
2540     function setMaxTotalSupply(uint256 _maxTotalSupply) external onlyGovernance {
2541         maxTotalSupply = _maxTotalSupply;
2542     }
2543 
2544     /**
2545      * @notice Removes liquidity in case of emergency.
2546      */
2547     function emergencyBurn(
2548         int24 tickLower,
2549         int24 tickUpper,
2550         uint128 liquidity
2551     ) external onlyGovernance {
2552         pool.burn(tickLower, tickUpper, liquidity);
2553         pool.collect(address(this), tickLower, tickUpper, type(uint128).max, type(uint128).max);
2554     }
2555 
2556     /**
2557      * @notice Governance address is not updated until the new governance
2558      * address has called `acceptGovernance()` to accept this responsibility.
2559      */
2560     function setGovernance(address _governance) external onlyGovernance {
2561         pendingGovernance = _governance;
2562     }
2563 
2564     /**
2565      * @notice `setGovernance()` should be called by the existing governance
2566      * address prior to calling this function.
2567      */
2568     function acceptGovernance() external {
2569         require(msg.sender == pendingGovernance, "pendingGovernance");
2570         governance = msg.sender;
2571     }
2572 
2573     modifier onlyGovernance {
2574         require(msg.sender == governance, "governance");
2575         _;
2576     }
2577 }
