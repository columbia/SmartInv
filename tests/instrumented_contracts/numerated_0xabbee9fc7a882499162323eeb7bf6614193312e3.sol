1 // File: @openzeppelin/contracts/math/SafeMath.sol
2 
3 pragma solidity ^0.6.0;
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
19     /**
20      * @dev Returns the addition of two unsigned integers, reverting on
21      * overflow.
22      *
23      * Counterpart to Solidity's `+` operator.
24      *
25      * Requirements:
26      * - Addition cannot overflow.
27      */
28     function add(uint256 a, uint256 b) internal pure returns (uint256) {
29         uint256 c = a + b;
30         require(c >= a, "SafeMath: addition overflow");
31 
32         return c;
33     }
34 
35     /**
36      * @dev Returns the subtraction of two unsigned integers, reverting on
37      * overflow (when the result is negative).
38      *
39      * Counterpart to Solidity's `-` operator.
40      *
41      * Requirements:
42      * - Subtraction cannot overflow.
43      */
44     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
45         return sub(a, b, "SafeMath: subtraction overflow");
46     }
47 
48     /**
49      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
50      * overflow (when the result is negative).
51      *
52      * Counterpart to Solidity's `-` operator.
53      *
54      * Requirements:
55      * - Subtraction cannot overflow.
56      */
57     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
58         require(b <= a, errorMessage);
59         uint256 c = a - b;
60 
61         return c;
62     }
63 
64     /**
65      * @dev Returns the multiplication of two unsigned integers, reverting on
66      * overflow.
67      *
68      * Counterpart to Solidity's `*` operator.
69      *
70      * Requirements:
71      * - Multiplication cannot overflow.
72      */
73     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
74         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
75         // benefit is lost if 'b' is also tested.
76         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
77         if (a == 0) {
78             return 0;
79         }
80 
81         uint256 c = a * b;
82         require(c / a == b, "SafeMath: multiplication overflow");
83 
84         return c;
85     }
86 
87     /**
88      * @dev Returns the integer division of two unsigned integers. Reverts on
89      * division by zero. The result is rounded towards zero.
90      *
91      * Counterpart to Solidity's `/` operator. Note: this function uses a
92      * `revert` opcode (which leaves remaining gas untouched) while Solidity
93      * uses an invalid opcode to revert (consuming all remaining gas).
94      *
95      * Requirements:
96      * - The divisor cannot be zero.
97      */
98     function div(uint256 a, uint256 b) internal pure returns (uint256) {
99         return div(a, b, "SafeMath: division by zero");
100     }
101 
102     /**
103      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
104      * division by zero. The result is rounded towards zero.
105      *
106      * Counterpart to Solidity's `/` operator. Note: this function uses a
107      * `revert` opcode (which leaves remaining gas untouched) while Solidity
108      * uses an invalid opcode to revert (consuming all remaining gas).
109      *
110      * Requirements:
111      * - The divisor cannot be zero.
112      */
113     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
114         // Solidity only automatically asserts when dividing by 0
115         require(b > 0, errorMessage);
116         uint256 c = a / b;
117         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
118 
119         return c;
120     }
121 
122     /**
123      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
124      * Reverts when dividing by zero.
125      *
126      * Counterpart to Solidity's `%` operator. This function uses a `revert`
127      * opcode (which leaves remaining gas untouched) while Solidity uses an
128      * invalid opcode to revert (consuming all remaining gas).
129      *
130      * Requirements:
131      * - The divisor cannot be zero.
132      */
133     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
134         return mod(a, b, "SafeMath: modulo by zero");
135     }
136 
137     /**
138      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
139      * Reverts with custom message when dividing by zero.
140      *
141      * Counterpart to Solidity's `%` operator. This function uses a `revert`
142      * opcode (which leaves remaining gas untouched) while Solidity uses an
143      * invalid opcode to revert (consuming all remaining gas).
144      *
145      * Requirements:
146      * - The divisor cannot be zero.
147      */
148     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
149         require(b != 0, errorMessage);
150         return a % b;
151     }
152 }
153 
154 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
155 
156 pragma solidity ^0.6.0;
157 
158 /**
159  * @dev Interface of the ERC20 standard as defined in the EIP.
160  */
161 interface IERC20 {
162     /**
163      * @dev Returns the amount of tokens in existence.
164      */
165     function totalSupply() external view returns (uint256);
166 
167     /**
168      * @dev Returns the amount of tokens owned by `account`.
169      */
170     function balanceOf(address account) external view returns (uint256);
171 
172     /**
173      * @dev Moves `amount` tokens from the caller's account to `recipient`.
174      *
175      * Returns a boolean value indicating whether the operation succeeded.
176      *
177      * Emits a {Transfer} event.
178      */
179     function transfer(address recipient, uint256 amount) external returns (bool);
180 
181     /**
182      * @dev Returns the remaining number of tokens that `spender` will be
183      * allowed to spend on behalf of `owner` through {transferFrom}. This is
184      * zero by default.
185      *
186      * This value changes when {approve} or {transferFrom} are called.
187      */
188     function allowance(address owner, address spender) external view returns (uint256);
189 
190     /**
191      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
192      *
193      * Returns a boolean value indicating whether the operation succeeded.
194      *
195      * IMPORTANT: Beware that changing an allowance with this method brings the risk
196      * that someone may use both the old and the new allowance by unfortunate
197      * transaction ordering. One possible solution to mitigate this race
198      * condition is to first reduce the spender's allowance to 0 and set the
199      * desired value afterwards:
200      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
201      *
202      * Emits an {Approval} event.
203      */
204     function approve(address spender, uint256 amount) external returns (bool);
205 
206     /**
207      * @dev Moves `amount` tokens from `sender` to `recipient` using the
208      * allowance mechanism. `amount` is then deducted from the caller's
209      * allowance.
210      *
211      * Returns a boolean value indicating whether the operation succeeded.
212      *
213      * Emits a {Transfer} event.
214      */
215     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
216 
217     /**
218      * @dev Emitted when `value` tokens are moved from one account (`from`) to
219      * another (`to`).
220      *
221      * Note that `value` may be zero.
222      */
223     event Transfer(address indexed from, address indexed to, uint256 value);
224 
225     /**
226      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
227      * a call to {approve}. `value` is the new allowance.
228      */
229     event Approval(address indexed owner, address indexed spender, uint256 value);
230 }
231 
232 // File: @openzeppelin/contracts/utils/Address.sol
233 
234 pragma solidity ^0.6.2;
235 
236 /**
237  * @dev Collection of functions related to the address type
238  */
239 library Address {
240     /**
241      * @dev Returns true if `account` is a contract.
242      *
243      * [IMPORTANT]
244      * ====
245      * It is unsafe to assume that an address for which this function returns
246      * false is an externally-owned account (EOA) and not a contract.
247      *
248      * Among others, `isContract` will return false for the following
249      * types of addresses:
250      *
251      *  - an externally-owned account
252      *  - a contract in construction
253      *  - an address where a contract will be created
254      *  - an address where a contract lived, but was destroyed
255      * ====
256      */
257     function isContract(address account) internal view returns (bool) {
258         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
259         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
260         // for accounts without code, i.e. `keccak256('')`
261         bytes32 codehash;
262         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
263         // solhint-disable-next-line no-inline-assembly
264         assembly { codehash := extcodehash(account) }
265         return (codehash != accountHash && codehash != 0x0);
266     }
267 
268     /**
269      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
270      * `recipient`, forwarding all available gas and reverting on errors.
271      *
272      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
273      * of certain opcodes, possibly making contracts go over the 2300 gas limit
274      * imposed by `transfer`, making them unable to receive funds via
275      * `transfer`. {sendValue} removes this limitation.
276      *
277      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
278      *
279      * IMPORTANT: because control is transferred to `recipient`, care must be
280      * taken to not create reentrancy vulnerabilities. Consider using
281      * {ReentrancyGuard} or the
282      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
283      */
284     function sendValue(address payable recipient, uint256 amount) internal {
285         require(address(this).balance >= amount, "Address: insufficient balance");
286 
287         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
288         (bool success, ) = recipient.call{ value: amount }("");
289         require(success, "Address: unable to send value, recipient may have reverted");
290     }
291 }
292 
293 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
294 
295 pragma solidity ^0.6.0;
296 
297 
298 
299 
300 /**
301  * @title SafeERC20
302  * @dev Wrappers around ERC20 operations that throw on failure (when the token
303  * contract returns false). Tokens that return no value (and instead revert or
304  * throw on failure) are also supported, non-reverting calls are assumed to be
305  * successful.
306  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
307  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
308  */
309 library SafeERC20 {
310     using SafeMath for uint256;
311     using Address for address;
312 
313     function safeTransfer(IERC20 token, address to, uint256 value) internal {
314         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
315     }
316 
317     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
318         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
319     }
320 
321     function safeApprove(IERC20 token, address spender, uint256 value) internal {
322         // safeApprove should only be called when setting an initial allowance,
323         // or when resetting it to zero. To increase and decrease it, use
324         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
325         // solhint-disable-next-line max-line-length
326         require((value == 0) || (token.allowance(address(this), spender) == 0),
327             "SafeERC20: approve from non-zero to non-zero allowance"
328         );
329         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
330     }
331 
332     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
333         uint256 newAllowance = token.allowance(address(this), spender).add(value);
334         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
335     }
336 
337     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
338         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
339         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
340     }
341 
342     /**
343      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
344      * on the return value: the return value is optional (but if data is returned, it must not be false).
345      * @param token The token targeted by the call.
346      * @param data The call data (encoded using abi.encode or one of its variants).
347      */
348     function _callOptionalReturn(IERC20 token, bytes memory data) private {
349         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
350         // we're implementing it ourselves.
351 
352         // A Solidity high level call has three parts:
353         //  1. The target address is checked to verify it contains contract code
354         //  2. The call itself is made, and success asserted
355         //  3. The return value is decoded, which in turn checks the size of the returned data.
356         // solhint-disable-next-line max-line-length
357         require(address(token).isContract(), "SafeERC20: call to non-contract");
358 
359         // solhint-disable-next-line avoid-low-level-calls
360         (bool success, bytes memory returndata) = address(token).call(data);
361         require(success, "SafeERC20: low-level call failed");
362 
363         if (returndata.length > 0) { // Return data is optional
364             // solhint-disable-next-line max-line-length
365             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
366         }
367     }
368 }
369 
370 // File: contracts/common/implementation/FixedPoint.sol
371 
372 pragma solidity ^0.6.0;
373 
374 
375 
376 /**
377  * @title Library for fixed point arithmetic on uints
378  */
379 library FixedPoint {
380     using SafeMath for uint256;
381 
382     // Supports 18 decimals. E.g., 1e18 represents "1", 5e17 represents "0.5".
383     // Can represent a value up to (2^256 - 1)/10^18 = ~10^59. 10^59 will be stored internally as uint256 10^77.
384     uint256 private constant FP_SCALING_FACTOR = 10**18;
385 
386     struct Unsigned {
387         uint256 rawValue;
388     }
389 
390     /**
391      * @notice Constructs an `Unsigned` from an unscaled uint, e.g., `b=5` gets stored internally as `5**18`.
392      * @param a uint to convert into a FixedPoint.
393      * @return the converted FixedPoint.
394      */
395     function fromUnscaledUint(uint256 a) internal pure returns (Unsigned memory) {
396         return Unsigned(a.mul(FP_SCALING_FACTOR));
397     }
398 
399     /**
400      * @notice Whether `a` is equal to `b`.
401      * @param a a FixedPoint.
402      * @param b a uint256.
403      * @return True if equal, or False.
404      */
405     function isEqual(Unsigned memory a, uint256 b) internal pure returns (bool) {
406         return a.rawValue == fromUnscaledUint(b).rawValue;
407     }
408 
409     /**
410      * @notice Whether `a` is equal to `b`.
411      * @param a a FixedPoint.
412      * @param b a FixedPoint.
413      * @return True if equal, or False.
414      */
415     function isEqual(Unsigned memory a, Unsigned memory b) internal pure returns (bool) {
416         return a.rawValue == b.rawValue;
417     }
418 
419     /**
420      * @notice Whether `a` is greater than `b`.
421      * @param a a FixedPoint.
422      * @param b a FixedPoint.
423      * @return True if `a > b`, or False.
424      */
425     function isGreaterThan(Unsigned memory a, Unsigned memory b) internal pure returns (bool) {
426         return a.rawValue > b.rawValue;
427     }
428 
429     /**
430      * @notice Whether `a` is greater than `b`.
431      * @param a a FixedPoint.
432      * @param b a uint256.
433      * @return True if `a > b`, or False.
434      */
435     function isGreaterThan(Unsigned memory a, uint256 b) internal pure returns (bool) {
436         return a.rawValue > fromUnscaledUint(b).rawValue;
437     }
438 
439     /**
440      * @notice Whether `a` is greater than `b`.
441      * @param a a uint256.
442      * @param b a FixedPoint.
443      * @return True if `a > b`, or False.
444      */
445     function isGreaterThan(uint256 a, Unsigned memory b) internal pure returns (bool) {
446         return fromUnscaledUint(a).rawValue > b.rawValue;
447     }
448 
449     /**
450      * @notice Whether `a` is greater than or equal to `b`.
451      * @param a a FixedPoint.
452      * @param b a FixedPoint.
453      * @return True if `a >= b`, or False.
454      */
455     function isGreaterThanOrEqual(Unsigned memory a, Unsigned memory b) internal pure returns (bool) {
456         return a.rawValue >= b.rawValue;
457     }
458 
459     /**
460      * @notice Whether `a` is greater than or equal to `b`.
461      * @param a a FixedPoint.
462      * @param b a uint256.
463      * @return True if `a >= b`, or False.
464      */
465     function isGreaterThanOrEqual(Unsigned memory a, uint256 b) internal pure returns (bool) {
466         return a.rawValue >= fromUnscaledUint(b).rawValue;
467     }
468 
469     /**
470      * @notice Whether `a` is greater than or equal to `b`.
471      * @param a a uint256.
472      * @param b a FixedPoint.
473      * @return True if `a >= b`, or False.
474      */
475     function isGreaterThanOrEqual(uint256 a, Unsigned memory b) internal pure returns (bool) {
476         return fromUnscaledUint(a).rawValue >= b.rawValue;
477     }
478 
479     /**
480      * @notice Whether `a` is less than `b`.
481      * @param a a FixedPoint.
482      * @param b a FixedPoint.
483      * @return True if `a < b`, or False.
484      */
485     function isLessThan(Unsigned memory a, Unsigned memory b) internal pure returns (bool) {
486         return a.rawValue < b.rawValue;
487     }
488 
489     /**
490      * @notice Whether `a` is less than `b`.
491      * @param a a FixedPoint.
492      * @param b a uint256.
493      * @return True if `a < b`, or False.
494      */
495     function isLessThan(Unsigned memory a, uint256 b) internal pure returns (bool) {
496         return a.rawValue < fromUnscaledUint(b).rawValue;
497     }
498 
499     /**
500      * @notice Whether `a` is less than `b`.
501      * @param a a uint256.
502      * @param b a FixedPoint.
503      * @return True if `a < b`, or False.
504      */
505     function isLessThan(uint256 a, Unsigned memory b) internal pure returns (bool) {
506         return fromUnscaledUint(a).rawValue < b.rawValue;
507     }
508 
509     /**
510      * @notice Whether `a` is less than or equal to `b`.
511      * @param a a FixedPoint.
512      * @param b a FixedPoint.
513      * @return True if `a <= b`, or False.
514      */
515     function isLessThanOrEqual(Unsigned memory a, Unsigned memory b) internal pure returns (bool) {
516         return a.rawValue <= b.rawValue;
517     }
518 
519     /**
520      * @notice Whether `a` is less than or equal to `b`.
521      * @param a a FixedPoint.
522      * @param b a uint256.
523      * @return True if `a <= b`, or False.
524      */
525     function isLessThanOrEqual(Unsigned memory a, uint256 b) internal pure returns (bool) {
526         return a.rawValue <= fromUnscaledUint(b).rawValue;
527     }
528 
529     /**
530      * @notice Whether `a` is less than or equal to `b`.
531      * @param a a uint256.
532      * @param b a FixedPoint.
533      * @return True if `a <= b`, or False.
534      */
535     function isLessThanOrEqual(uint256 a, Unsigned memory b) internal pure returns (bool) {
536         return fromUnscaledUint(a).rawValue <= b.rawValue;
537     }
538 
539     /**
540      * @notice The minimum of `a` and `b`.
541      * @param a a FixedPoint.
542      * @param b a FixedPoint.
543      * @return the minimum of `a` and `b`.
544      */
545     function min(Unsigned memory a, Unsigned memory b) internal pure returns (Unsigned memory) {
546         return a.rawValue < b.rawValue ? a : b;
547     }
548 
549     /**
550      * @notice The maximum of `a` and `b`.
551      * @param a a FixedPoint.
552      * @param b a FixedPoint.
553      * @return the maximum of `a` and `b`.
554      */
555     function max(Unsigned memory a, Unsigned memory b) internal pure returns (Unsigned memory) {
556         return a.rawValue > b.rawValue ? a : b;
557     }
558 
559     /**
560      * @notice Adds two `Unsigned`s, reverting on overflow.
561      * @param a a FixedPoint.
562      * @param b a FixedPoint.
563      * @return the sum of `a` and `b`.
564      */
565     function add(Unsigned memory a, Unsigned memory b) internal pure returns (Unsigned memory) {
566         return Unsigned(a.rawValue.add(b.rawValue));
567     }
568 
569     /**
570      * @notice Adds an `Unsigned` to an unscaled uint, reverting on overflow.
571      * @param a a FixedPoint.
572      * @param b a uint256.
573      * @return the sum of `a` and `b`.
574      */
575     function add(Unsigned memory a, uint256 b) internal pure returns (Unsigned memory) {
576         return add(a, fromUnscaledUint(b));
577     }
578 
579     /**
580      * @notice Subtracts two `Unsigned`s, reverting on overflow.
581      * @param a a FixedPoint.
582      * @param b a FixedPoint.
583      * @return the difference of `a` and `b`.
584      */
585     function sub(Unsigned memory a, Unsigned memory b) internal pure returns (Unsigned memory) {
586         return Unsigned(a.rawValue.sub(b.rawValue));
587     }
588 
589     /**
590      * @notice Subtracts an unscaled uint256 from an `Unsigned`, reverting on overflow.
591      * @param a a FixedPoint.
592      * @param b a uint256.
593      * @return the difference of `a` and `b`.
594      */
595     function sub(Unsigned memory a, uint256 b) internal pure returns (Unsigned memory) {
596         return sub(a, fromUnscaledUint(b));
597     }
598 
599     /**
600      * @notice Subtracts an `Unsigned` from an unscaled uint256, reverting on overflow.
601      * @param a a uint256.
602      * @param b a FixedPoint.
603      * @return the difference of `a` and `b`.
604      */
605     function sub(uint256 a, Unsigned memory b) internal pure returns (Unsigned memory) {
606         return sub(fromUnscaledUint(a), b);
607     }
608 
609     /**
610      * @notice Multiplies two `Unsigned`s, reverting on overflow.
611      * @dev This will "floor" the product.
612      * @param a a FixedPoint.
613      * @param b a FixedPoint.
614      * @return the product of `a` and `b`.
615      */
616     function mul(Unsigned memory a, Unsigned memory b) internal pure returns (Unsigned memory) {
617         // There are two caveats with this computation:
618         // 1. Max output for the represented number is ~10^41, otherwise an intermediate value overflows. 10^41 is
619         // stored internally as a uint256 ~10^59.
620         // 2. Results that can't be represented exactly are truncated not rounded. E.g., 1.4 * 2e-18 = 2.8e-18, which
621         // would round to 3, but this computation produces the result 2.
622         // No need to use SafeMath because FP_SCALING_FACTOR != 0.
623         return Unsigned(a.rawValue.mul(b.rawValue) / FP_SCALING_FACTOR);
624     }
625 
626     /**
627      * @notice Multiplies an `Unsigned` and an unscaled uint256, reverting on overflow.
628      * @dev This will "floor" the product.
629      * @param a a FixedPoint.
630      * @param b a uint256.
631      * @return the product of `a` and `b`.
632      */
633     function mul(Unsigned memory a, uint256 b) internal pure returns (Unsigned memory) {
634         return Unsigned(a.rawValue.mul(b));
635     }
636 
637     /**
638      * @notice Multiplies two `Unsigned`s and "ceil's" the product, reverting on overflow.
639      * @param a a FixedPoint.
640      * @param b a FixedPoint.
641      * @return the product of `a` and `b`.
642      */
643     function mulCeil(Unsigned memory a, Unsigned memory b) internal pure returns (Unsigned memory) {
644         uint256 mulRaw = a.rawValue.mul(b.rawValue);
645         uint256 mulFloor = mulRaw / FP_SCALING_FACTOR;
646         uint256 mod = mulRaw.mod(FP_SCALING_FACTOR);
647         if (mod != 0) {
648             return Unsigned(mulFloor.add(1));
649         } else {
650             return Unsigned(mulFloor);
651         }
652     }
653 
654     /**
655      * @notice Multiplies an `Unsigned` and an unscaled uint256 and "ceil's" the product, reverting on overflow.
656      * @param a a FixedPoint.
657      * @param b a FixedPoint.
658      * @return the product of `a` and `b`.
659      */
660     function mulCeil(Unsigned memory a, uint256 b) internal pure returns (Unsigned memory) {
661         // Since b is an int, there is no risk of truncation and we can just mul it normally
662         return Unsigned(a.rawValue.mul(b));
663     }
664 
665     /**
666      * @notice Divides one `Unsigned` by an `Unsigned`, reverting on overflow or division by 0.
667      * @dev This will "floor" the quotient.
668      * @param a a FixedPoint numerator.
669      * @param b a FixedPoint denominator.
670      * @return the quotient of `a` divided by `b`.
671      */
672     function div(Unsigned memory a, Unsigned memory b) internal pure returns (Unsigned memory) {
673         // There are two caveats with this computation:
674         // 1. Max value for the number dividend `a` represents is ~10^41, otherwise an intermediate value overflows.
675         // 10^41 is stored internally as a uint256 10^59.
676         // 2. Results that can't be represented exactly are truncated not rounded. E.g., 2 / 3 = 0.6 repeating, which
677         // would round to 0.666666666666666667, but this computation produces the result 0.666666666666666666.
678         return Unsigned(a.rawValue.mul(FP_SCALING_FACTOR).div(b.rawValue));
679     }
680 
681     /**
682      * @notice Divides one `Unsigned` by an unscaled uint256, reverting on overflow or division by 0.
683      * @dev This will "floor" the quotient.
684      * @param a a FixedPoint numerator.
685      * @param b a uint256 denominator.
686      * @return the quotient of `a` divided by `b`.
687      */
688     function div(Unsigned memory a, uint256 b) internal pure returns (Unsigned memory) {
689         return Unsigned(a.rawValue.div(b));
690     }
691 
692     /**
693      * @notice Divides one unscaled uint256 by an `Unsigned`, reverting on overflow or division by 0.
694      * @dev This will "floor" the quotient.
695      * @param a a uint256 numerator.
696      * @param b a FixedPoint denominator.
697      * @return the quotient of `a` divided by `b`.
698      */
699     function div(uint256 a, Unsigned memory b) internal pure returns (Unsigned memory) {
700         return div(fromUnscaledUint(a), b);
701     }
702 
703     /**
704      * @notice Divides one `Unsigned` by an `Unsigned` and "ceil's" the quotient, reverting on overflow or division by 0.
705      * @param a a FixedPoint numerator.
706      * @param b a FixedPoint denominator.
707      * @return the quotient of `a` divided by `b`.
708      */
709     function divCeil(Unsigned memory a, Unsigned memory b) internal pure returns (Unsigned memory) {
710         uint256 aScaled = a.rawValue.mul(FP_SCALING_FACTOR);
711         uint256 divFloor = aScaled.div(b.rawValue);
712         uint256 mod = aScaled.mod(b.rawValue);
713         if (mod != 0) {
714             return Unsigned(divFloor.add(1));
715         } else {
716             return Unsigned(divFloor);
717         }
718     }
719 
720     /**
721      * @notice Divides one `Unsigned` by an unscaled uint256 and "ceil's" the quotient, reverting on overflow or division by 0.
722      * @param a a FixedPoint numerator.
723      * @param b a uint256 denominator.
724      * @return the quotient of `a` divided by `b`.
725      */
726     function divCeil(Unsigned memory a, uint256 b) internal pure returns (Unsigned memory) {
727         // Because it is possible that a quotient gets truncated, we can't just call "Unsigned(a.rawValue.div(b))"
728         // similarly to mulCeil with a uint256 as the second parameter. Therefore we need to convert b into an Unsigned.
729         // This creates the possibility of overflow if b is very large.
730         return divCeil(a, fromUnscaledUint(b));
731     }
732 
733     /**
734      * @notice Raises an `Unsigned` to the power of an unscaled uint256, reverting on overflow. E.g., `b=2` squares `a`.
735      * @dev This will "floor" the result.
736      * @param a a FixedPoint numerator.
737      * @param b a uint256 denominator.
738      * @return output is `a` to the power of `b`.
739      */
740     function pow(Unsigned memory a, uint256 b) internal pure returns (Unsigned memory output) {
741         output = fromUnscaledUint(1);
742         for (uint256 i = 0; i < b; i = i.add(1)) {
743             output = mul(output, a);
744         }
745     }
746 }
747 
748 // File: contracts/common/interfaces/ExpandedIERC20.sol
749 
750 pragma solidity ^0.6.0;
751 
752 
753 
754 /**
755  * @title ERC20 interface that includes burn and mint methods.
756  */
757 abstract contract ExpandedIERC20 is IERC20 {
758     /**
759      * @notice Burns a specific amount of the caller's tokens.
760      * @dev Only burns the caller's tokens, so it is safe to leave this method permissionless.
761      */
762     function burn(uint256 value) external virtual;
763 
764     /**
765      * @notice Mints tokens and adds them to the balance of the `to` address.
766      * @dev This method should be permissioned to only allow designated parties to mint tokens.
767      */
768     function mint(address to, uint256 value) external virtual returns (bool);
769 }
770 
771 // File: contracts/oracle/interfaces/OracleInterface.sol
772 
773 pragma solidity ^0.6.0;
774 
775 
776 /**
777  * @title Financial contract facing Oracle interface.
778  * @dev Interface used by financial contracts to interact with the Oracle. Voters will use a different interface.
779  */
780 interface OracleInterface {
781     /**
782      * @notice Enqueues a request (if a request isn't already present) for the given `identifier`, `time` pair.
783      * @dev Time must be in the past and the identifier must be supported.
784      * @param identifier uniquely identifies the price requested. eg BTC/USD (encoded as bytes32) could be requested.
785      * @param time unix timestamp for the price request.
786      */
787     function requestPrice(bytes32 identifier, uint256 time) external;
788 
789     /**
790      * @notice Whether the price for `identifier` and `time` is available.
791      * @dev Time must be in the past and the identifier must be supported.
792      * @param identifier uniquely identifies the price requested. eg BTC/USD (encoded as bytes32) could be requested.
793      * @param time unix timestamp for the price request.
794      * @return bool if the DVM has resolved to a price for the given identifier and timestamp.
795      */
796     function hasPrice(bytes32 identifier, uint256 time) external view returns (bool);
797 
798     /**
799      * @notice Gets the price for `identifier` and `time` if it has already been requested and resolved.
800      * @dev If the price is not available, the method reverts.
801      * @param identifier uniquely identifies the price requested. eg BTC/USD (encoded as bytes32) could be requested.
802      * @param time unix timestamp for the price request.
803      * @return int256 representing the resolved price for the given identifier and timestamp.
804      */
805     function getPrice(bytes32 identifier, uint256 time) external view returns (int256);
806 }
807 
808 // File: contracts/oracle/interfaces/IdentifierWhitelistInterface.sol
809 
810 pragma solidity ^0.6.0;
811 
812 pragma experimental ABIEncoderV2;
813 
814 
815 /**
816  * @title Interface for whitelists of supported identifiers that the oracle can provide prices for.
817  */
818 interface IdentifierWhitelistInterface {
819     /**
820      * @notice Adds the provided identifier as a supported identifier.
821      * @dev Price requests using this identifier will succeed after this call.
822      * @param identifier bytes32 encoding of the string identifier. Eg: BTC/USD.
823      */
824     function addSupportedIdentifier(bytes32 identifier) external;
825 
826     /**
827      * @notice Removes the identifier from the whitelist.
828      * @dev Price requests using this identifier will no longer succeed after this call.
829      * @param identifier bytes32 encoding of the string identifier. Eg: BTC/USD.
830      */
831     function removeSupportedIdentifier(bytes32 identifier) external;
832 
833     /**
834      * @notice Checks whether an identifier is on the whitelist.
835      * @param identifier bytes32 encoding of the string identifier. Eg: BTC/USD.
836      * @return bool if the identifier is supported (or not).
837      */
838     function isIdentifierSupported(bytes32 identifier) external view returns (bool);
839 }
840 
841 // File: contracts/oracle/interfaces/AdministrateeInterface.sol
842 
843 pragma solidity ^0.6.0;
844 
845 
846 /**
847  * @title Interface that all financial contracts expose to the admin.
848  */
849 interface AdministrateeInterface {
850     /**
851      * @notice Initiates the shutdown process, in case of an emergency.
852      */
853     function emergencyShutdown() external;
854 
855     /**
856      * @notice A core contract method called independently or as a part of other financial contract transactions.
857      * @dev It pays fees and moves money between margin accounts to make sure they reflect the NAV of the contract.
858      */
859     function remargin() external;
860 }
861 
862 // File: contracts/oracle/implementation/Constants.sol
863 
864 pragma solidity ^0.6.0;
865 
866 
867 /**
868  * @title Stores common interface names used throughout the DVM by registration in the Finder.
869  */
870 library OracleInterfaces {
871     bytes32 public constant Oracle = "Oracle";
872     bytes32 public constant IdentifierWhitelist = "IdentifierWhitelist";
873     bytes32 public constant Store = "Store";
874     bytes32 public constant FinancialContractsAdmin = "FinancialContractsAdmin";
875     bytes32 public constant Registry = "Registry";
876     bytes32 public constant CollateralWhitelist = "CollateralWhitelist";
877 }
878 
879 // File: @openzeppelin/contracts/GSN/Context.sol
880 
881 pragma solidity ^0.6.0;
882 
883 /*
884  * @dev Provides information about the current execution context, including the
885  * sender of the transaction and its data. While these are generally available
886  * via msg.sender and msg.data, they should not be accessed in such a direct
887  * manner, since when dealing with GSN meta-transactions the account sending and
888  * paying for execution may not be the actual sender (as far as an application
889  * is concerned).
890  *
891  * This contract is only required for intermediate, library-like contracts.
892  */
893 contract Context {
894     // Empty internal constructor, to prevent people from mistakenly deploying
895     // an instance of this contract, which should be used via inheritance.
896     constructor () internal { }
897 
898     function _msgSender() internal view virtual returns (address payable) {
899         return msg.sender;
900     }
901 
902     function _msgData() internal view virtual returns (bytes memory) {
903         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
904         return msg.data;
905     }
906 }
907 
908 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
909 
910 pragma solidity ^0.6.0;
911 
912 
913 
914 
915 
916 /**
917  * @dev Implementation of the {IERC20} interface.
918  *
919  * This implementation is agnostic to the way tokens are created. This means
920  * that a supply mechanism has to be added in a derived contract using {_mint}.
921  * For a generic mechanism see {ERC20MinterPauser}.
922  *
923  * TIP: For a detailed writeup see our guide
924  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
925  * to implement supply mechanisms].
926  *
927  * We have followed general OpenZeppelin guidelines: functions revert instead
928  * of returning `false` on failure. This behavior is nonetheless conventional
929  * and does not conflict with the expectations of ERC20 applications.
930  *
931  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
932  * This allows applications to reconstruct the allowance for all accounts just
933  * by listening to said events. Other implementations of the EIP may not emit
934  * these events, as it isn't required by the specification.
935  *
936  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
937  * functions have been added to mitigate the well-known issues around setting
938  * allowances. See {IERC20-approve}.
939  */
940 contract ERC20 is Context, IERC20 {
941     using SafeMath for uint256;
942     using Address for address;
943 
944     mapping (address => uint256) private _balances;
945 
946     mapping (address => mapping (address => uint256)) private _allowances;
947 
948     uint256 private _totalSupply;
949 
950     string private _name;
951     string private _symbol;
952     uint8 private _decimals;
953 
954     /**
955      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
956      * a default value of 18.
957      *
958      * To select a different value for {decimals}, use {_setupDecimals}.
959      *
960      * All three of these values are immutable: they can only be set once during
961      * construction.
962      */
963     constructor (string memory name, string memory symbol) public {
964         _name = name;
965         _symbol = symbol;
966         _decimals = 18;
967     }
968 
969     /**
970      * @dev Returns the name of the token.
971      */
972     function name() public view returns (string memory) {
973         return _name;
974     }
975 
976     /**
977      * @dev Returns the symbol of the token, usually a shorter version of the
978      * name.
979      */
980     function symbol() public view returns (string memory) {
981         return _symbol;
982     }
983 
984     /**
985      * @dev Returns the number of decimals used to get its user representation.
986      * For example, if `decimals` equals `2`, a balance of `505` tokens should
987      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
988      *
989      * Tokens usually opt for a value of 18, imitating the relationship between
990      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
991      * called.
992      *
993      * NOTE: This information is only used for _display_ purposes: it in
994      * no way affects any of the arithmetic of the contract, including
995      * {IERC20-balanceOf} and {IERC20-transfer}.
996      */
997     function decimals() public view returns (uint8) {
998         return _decimals;
999     }
1000 
1001     /**
1002      * @dev See {IERC20-totalSupply}.
1003      */
1004     function totalSupply() public view override returns (uint256) {
1005         return _totalSupply;
1006     }
1007 
1008     /**
1009      * @dev See {IERC20-balanceOf}.
1010      */
1011     function balanceOf(address account) public view override returns (uint256) {
1012         return _balances[account];
1013     }
1014 
1015     /**
1016      * @dev See {IERC20-transfer}.
1017      *
1018      * Requirements:
1019      *
1020      * - `recipient` cannot be the zero address.
1021      * - the caller must have a balance of at least `amount`.
1022      */
1023     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
1024         _transfer(_msgSender(), recipient, amount);
1025         return true;
1026     }
1027 
1028     /**
1029      * @dev See {IERC20-allowance}.
1030      */
1031     function allowance(address owner, address spender) public view virtual override returns (uint256) {
1032         return _allowances[owner][spender];
1033     }
1034 
1035     /**
1036      * @dev See {IERC20-approve}.
1037      *
1038      * Requirements:
1039      *
1040      * - `spender` cannot be the zero address.
1041      */
1042     function approve(address spender, uint256 amount) public virtual override returns (bool) {
1043         _approve(_msgSender(), spender, amount);
1044         return true;
1045     }
1046 
1047     /**
1048      * @dev See {IERC20-transferFrom}.
1049      *
1050      * Emits an {Approval} event indicating the updated allowance. This is not
1051      * required by the EIP. See the note at the beginning of {ERC20};
1052      *
1053      * Requirements:
1054      * - `sender` and `recipient` cannot be the zero address.
1055      * - `sender` must have a balance of at least `amount`.
1056      * - the caller must have allowance for ``sender``'s tokens of at least
1057      * `amount`.
1058      */
1059     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
1060         _transfer(sender, recipient, amount);
1061         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
1062         return true;
1063     }
1064 
1065     /**
1066      * @dev Atomically increases the allowance granted to `spender` by the caller.
1067      *
1068      * This is an alternative to {approve} that can be used as a mitigation for
1069      * problems described in {IERC20-approve}.
1070      *
1071      * Emits an {Approval} event indicating the updated allowance.
1072      *
1073      * Requirements:
1074      *
1075      * - `spender` cannot be the zero address.
1076      */
1077     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
1078         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
1079         return true;
1080     }
1081 
1082     /**
1083      * @dev Atomically decreases the allowance granted to `spender` by the caller.
1084      *
1085      * This is an alternative to {approve} that can be used as a mitigation for
1086      * problems described in {IERC20-approve}.
1087      *
1088      * Emits an {Approval} event indicating the updated allowance.
1089      *
1090      * Requirements:
1091      *
1092      * - `spender` cannot be the zero address.
1093      * - `spender` must have allowance for the caller of at least
1094      * `subtractedValue`.
1095      */
1096     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1097         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
1098         return true;
1099     }
1100 
1101     /**
1102      * @dev Moves tokens `amount` from `sender` to `recipient`.
1103      *
1104      * This is internal function is equivalent to {transfer}, and can be used to
1105      * e.g. implement automatic token fees, slashing mechanisms, etc.
1106      *
1107      * Emits a {Transfer} event.
1108      *
1109      * Requirements:
1110      *
1111      * - `sender` cannot be the zero address.
1112      * - `recipient` cannot be the zero address.
1113      * - `sender` must have a balance of at least `amount`.
1114      */
1115     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
1116         require(sender != address(0), "ERC20: transfer from the zero address");
1117         require(recipient != address(0), "ERC20: transfer to the zero address");
1118 
1119         _beforeTokenTransfer(sender, recipient, amount);
1120 
1121         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
1122         _balances[recipient] = _balances[recipient].add(amount);
1123         emit Transfer(sender, recipient, amount);
1124     }
1125 
1126     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1127      * the total supply.
1128      *
1129      * Emits a {Transfer} event with `from` set to the zero address.
1130      *
1131      * Requirements
1132      *
1133      * - `to` cannot be the zero address.
1134      */
1135     function _mint(address account, uint256 amount) internal virtual {
1136         require(account != address(0), "ERC20: mint to the zero address");
1137 
1138         _beforeTokenTransfer(address(0), account, amount);
1139 
1140         _totalSupply = _totalSupply.add(amount);
1141         _balances[account] = _balances[account].add(amount);
1142         emit Transfer(address(0), account, amount);
1143     }
1144 
1145     /**
1146      * @dev Destroys `amount` tokens from `account`, reducing the
1147      * total supply.
1148      *
1149      * Emits a {Transfer} event with `to` set to the zero address.
1150      *
1151      * Requirements
1152      *
1153      * - `account` cannot be the zero address.
1154      * - `account` must have at least `amount` tokens.
1155      */
1156     function _burn(address account, uint256 amount) internal virtual {
1157         require(account != address(0), "ERC20: burn from the zero address");
1158 
1159         _beforeTokenTransfer(account, address(0), amount);
1160 
1161         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
1162         _totalSupply = _totalSupply.sub(amount);
1163         emit Transfer(account, address(0), amount);
1164     }
1165 
1166     /**
1167      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
1168      *
1169      * This is internal function is equivalent to `approve`, and can be used to
1170      * e.g. set automatic allowances for certain subsystems, etc.
1171      *
1172      * Emits an {Approval} event.
1173      *
1174      * Requirements:
1175      *
1176      * - `owner` cannot be the zero address.
1177      * - `spender` cannot be the zero address.
1178      */
1179     function _approve(address owner, address spender, uint256 amount) internal virtual {
1180         require(owner != address(0), "ERC20: approve from the zero address");
1181         require(spender != address(0), "ERC20: approve to the zero address");
1182 
1183         _allowances[owner][spender] = amount;
1184         emit Approval(owner, spender, amount);
1185     }
1186 
1187     /**
1188      * @dev Sets {decimals} to a value other than the default one of 18.
1189      *
1190      * WARNING: This function should only be called from the constructor. Most
1191      * applications that interact with token contracts will not expect
1192      * {decimals} to ever change, and may work incorrectly if it does.
1193      */
1194     function _setupDecimals(uint8 decimals_) internal {
1195         _decimals = decimals_;
1196     }
1197 
1198     /**
1199      * @dev Hook that is called before any transfer of tokens. This includes
1200      * minting and burning.
1201      *
1202      * Calling conditions:
1203      *
1204      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1205      * will be to transferred to `to`.
1206      * - when `from` is zero, `amount` tokens will be minted for `to`.
1207      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1208      * - `from` and `to` are never both zero.
1209      *
1210      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1211      */
1212     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
1213 }
1214 
1215 // File: contracts/common/implementation/MultiRole.sol
1216 
1217 pragma solidity ^0.6.0;
1218 
1219 
1220 library Exclusive {
1221     struct RoleMembership {
1222         address member;
1223     }
1224 
1225     function isMember(RoleMembership storage roleMembership, address memberToCheck) internal view returns (bool) {
1226         return roleMembership.member == memberToCheck;
1227     }
1228 
1229     function resetMember(RoleMembership storage roleMembership, address newMember) internal {
1230         require(newMember != address(0x0), "Cannot set an exclusive role to 0x0");
1231         roleMembership.member = newMember;
1232     }
1233 
1234     function getMember(RoleMembership storage roleMembership) internal view returns (address) {
1235         return roleMembership.member;
1236     }
1237 
1238     function init(RoleMembership storage roleMembership, address initialMember) internal {
1239         resetMember(roleMembership, initialMember);
1240     }
1241 }
1242 
1243 
1244 library Shared {
1245     struct RoleMembership {
1246         mapping(address => bool) members;
1247     }
1248 
1249     function isMember(RoleMembership storage roleMembership, address memberToCheck) internal view returns (bool) {
1250         return roleMembership.members[memberToCheck];
1251     }
1252 
1253     function addMember(RoleMembership storage roleMembership, address memberToAdd) internal {
1254         require(memberToAdd != address(0x0), "Cannot add 0x0 to a shared role");
1255         roleMembership.members[memberToAdd] = true;
1256     }
1257 
1258     function removeMember(RoleMembership storage roleMembership, address memberToRemove) internal {
1259         roleMembership.members[memberToRemove] = false;
1260     }
1261 
1262     function init(RoleMembership storage roleMembership, address[] memory initialMembers) internal {
1263         for (uint256 i = 0; i < initialMembers.length; i++) {
1264             addMember(roleMembership, initialMembers[i]);
1265         }
1266     }
1267 }
1268 
1269 
1270 /**
1271  * @title Base class to manage permissions for the derived class.
1272  */
1273 abstract contract MultiRole {
1274     using Exclusive for Exclusive.RoleMembership;
1275     using Shared for Shared.RoleMembership;
1276 
1277     enum RoleType { Invalid, Exclusive, Shared }
1278 
1279     struct Role {
1280         uint256 managingRole;
1281         RoleType roleType;
1282         Exclusive.RoleMembership exclusiveRoleMembership;
1283         Shared.RoleMembership sharedRoleMembership;
1284     }
1285 
1286     mapping(uint256 => Role) private roles;
1287 
1288     event ResetExclusiveMember(uint256 indexed roleId, address indexed newMember, address indexed manager);
1289     event AddedSharedMember(uint256 indexed roleId, address indexed newMember, address indexed manager);
1290     event RemovedSharedMember(uint256 indexed roleId, address indexed oldMember, address indexed manager);
1291 
1292     /**
1293      * @notice Reverts unless the caller is a member of the specified roleId.
1294      */
1295     modifier onlyRoleHolder(uint256 roleId) {
1296         require(holdsRole(roleId, msg.sender), "Sender does not hold required role");
1297         _;
1298     }
1299 
1300     /**
1301      * @notice Reverts unless the caller is a member of the manager role for the specified roleId.
1302      */
1303     modifier onlyRoleManager(uint256 roleId) {
1304         require(holdsRole(roles[roleId].managingRole, msg.sender), "Can only be called by a role manager");
1305         _;
1306     }
1307 
1308     /**
1309      * @notice Reverts unless the roleId represents an initialized, exclusive roleId.
1310      */
1311     modifier onlyExclusive(uint256 roleId) {
1312         require(roles[roleId].roleType == RoleType.Exclusive, "Must be called on an initialized Exclusive role");
1313         _;
1314     }
1315 
1316     /**
1317      * @notice Reverts unless the roleId represents an initialized, shared roleId.
1318      */
1319     modifier onlyShared(uint256 roleId) {
1320         require(roles[roleId].roleType == RoleType.Shared, "Must be called on an initialized Shared role");
1321         _;
1322     }
1323 
1324     /**
1325      * @notice Whether `memberToCheck` is a member of roleId.
1326      * @dev Reverts if roleId does not correspond to an initialized role.
1327      * @param roleId the Role to check.
1328      * @param memberToCheck the address to check.
1329      * @return True if `memberToCheck` is a member of `roleId`.
1330      */
1331     function holdsRole(uint256 roleId, address memberToCheck) public view returns (bool) {
1332         Role storage role = roles[roleId];
1333         if (role.roleType == RoleType.Exclusive) {
1334             return role.exclusiveRoleMembership.isMember(memberToCheck);
1335         } else if (role.roleType == RoleType.Shared) {
1336             return role.sharedRoleMembership.isMember(memberToCheck);
1337         }
1338         revert("Invalid roleId");
1339     }
1340 
1341     /**
1342      * @notice Changes the exclusive role holder of `roleId` to `newMember`.
1343      * @dev Reverts if the caller is not a member of the managing role for `roleId` or if `roleId` is not an
1344      * initialized, ExclusiveRole.
1345      * @param roleId the ExclusiveRole membership to modify.
1346      * @param newMember the new ExclusiveRole member.
1347      */
1348     function resetMember(uint256 roleId, address newMember) public onlyExclusive(roleId) onlyRoleManager(roleId) {
1349         roles[roleId].exclusiveRoleMembership.resetMember(newMember);
1350         emit ResetExclusiveMember(roleId, newMember, msg.sender);
1351     }
1352 
1353     /**
1354      * @notice Gets the current holder of the exclusive role, `roleId`.
1355      * @dev Reverts if `roleId` does not represent an initialized, exclusive role.
1356      * @param roleId the ExclusiveRole membership to check.
1357      * @return the address of the current ExclusiveRole member.
1358      */
1359     function getMember(uint256 roleId) public view onlyExclusive(roleId) returns (address) {
1360         return roles[roleId].exclusiveRoleMembership.getMember();
1361     }
1362 
1363     /**
1364      * @notice Adds `newMember` to the shared role, `roleId`.
1365      * @dev Reverts if `roleId` does not represent an initialized, SharedRole or if the caller is not a member of the
1366      * managing role for `roleId`.
1367      * @param roleId the SharedRole membership to modify.
1368      * @param newMember the new SharedRole member.
1369      */
1370     function addMember(uint256 roleId, address newMember) public onlyShared(roleId) onlyRoleManager(roleId) {
1371         roles[roleId].sharedRoleMembership.addMember(newMember);
1372         emit AddedSharedMember(roleId, newMember, msg.sender);
1373     }
1374 
1375     /**
1376      * @notice Removes `memberToRemove` from the shared role, `roleId`.
1377      * @dev Reverts if `roleId` does not represent an initialized, SharedRole or if the caller is not a member of the
1378      * managing role for `roleId`.
1379      * @param roleId the SharedRole membership to modify.
1380      * @param memberToRemove the current SharedRole member to remove.
1381      */
1382     function removeMember(uint256 roleId, address memberToRemove) public onlyShared(roleId) onlyRoleManager(roleId) {
1383         roles[roleId].sharedRoleMembership.removeMember(memberToRemove);
1384         emit RemovedSharedMember(roleId, memberToRemove, msg.sender);
1385     }
1386 
1387     /**
1388      * @notice Removes caller from the role, `roleId`.
1389      * @dev Reverts if the caller is not a member of the role for `roleId` or if `roleId` is not an
1390      * initialized, SharedRole.
1391      * @param roleId the SharedRole membership to modify.
1392      */
1393     function renounceMembership(uint256 roleId) public onlyShared(roleId) onlyRoleHolder(roleId) {
1394         roles[roleId].sharedRoleMembership.removeMember(msg.sender);
1395         emit RemovedSharedMember(roleId, msg.sender, msg.sender);
1396     }
1397 
1398     /**
1399      * @notice Reverts if `roleId` is not initialized.
1400      */
1401     modifier onlyValidRole(uint256 roleId) {
1402         require(roles[roleId].roleType != RoleType.Invalid, "Attempted to use an invalid roleId");
1403         _;
1404     }
1405 
1406     /**
1407      * @notice Reverts if `roleId` is initialized.
1408      */
1409     modifier onlyInvalidRole(uint256 roleId) {
1410         require(roles[roleId].roleType == RoleType.Invalid, "Cannot use a pre-existing role");
1411         _;
1412     }
1413 
1414     /**
1415      * @notice Internal method to initialize a shared role, `roleId`, which will be managed by `managingRoleId`.
1416      * `initialMembers` will be immediately added to the role.
1417      * @dev Should be called by derived contracts, usually at construction time. Will revert if the role is already
1418      * initialized.
1419      */
1420     function _createSharedRole(
1421         uint256 roleId,
1422         uint256 managingRoleId,
1423         address[] memory initialMembers
1424     ) internal onlyInvalidRole(roleId) {
1425         Role storage role = roles[roleId];
1426         role.roleType = RoleType.Shared;
1427         role.managingRole = managingRoleId;
1428         role.sharedRoleMembership.init(initialMembers);
1429         require(
1430             roles[managingRoleId].roleType != RoleType.Invalid,
1431             "Attempted to use an invalid role to manage a shared role"
1432         );
1433     }
1434 
1435     /**
1436      * @notice Internal method to initialize an exclusive role, `roleId`, which will be managed by `managingRoleId`.
1437      * `initialMember` will be immediately added to the role.
1438      * @dev Should be called by derived contracts, usually at construction time. Will revert if the role is already
1439      * initialized.
1440      */
1441     function _createExclusiveRole(
1442         uint256 roleId,
1443         uint256 managingRoleId,
1444         address initialMember
1445     ) internal onlyInvalidRole(roleId) {
1446         Role storage role = roles[roleId];
1447         role.roleType = RoleType.Exclusive;
1448         role.managingRole = managingRoleId;
1449         role.exclusiveRoleMembership.init(initialMember);
1450         require(
1451             roles[managingRoleId].roleType != RoleType.Invalid,
1452             "Attempted to use an invalid role to manage an exclusive role"
1453         );
1454     }
1455 }
1456 
1457 // File: contracts/common/implementation/ExpandedERC20.sol
1458 
1459 pragma solidity ^0.6.0;
1460 
1461 
1462 
1463 
1464 
1465 /**
1466  * @title An ERC20 with permissioned burning and minting. The contract deployer will initially
1467  * be the owner who is capable of adding new roles.
1468  */
1469 contract ExpandedERC20 is ExpandedIERC20, ERC20, MultiRole {
1470     enum Roles {
1471         // Can set the minter and burner.
1472         Owner,
1473         // Addresses that can mint new tokens.
1474         Minter,
1475         // Addresses that can burn tokens that address owns.
1476         Burner
1477     }
1478 
1479     /**
1480      * @notice Constructs the ExpandedERC20.
1481      * @param _tokenName The name which describes the new token.
1482      * @param _tokenSymbol The ticker abbreviation of the name. Ideally < 5 chars.
1483      * @param _tokenDecimals The number of decimals to define token precision.
1484      */
1485     constructor(
1486         string memory _tokenName,
1487         string memory _tokenSymbol,
1488         uint8 _tokenDecimals
1489     ) public ERC20(_tokenName, _tokenSymbol) {
1490         _setupDecimals(_tokenDecimals);
1491         _createExclusiveRole(uint256(Roles.Owner), uint256(Roles.Owner), msg.sender);
1492         _createSharedRole(uint256(Roles.Minter), uint256(Roles.Owner), new address[](0));
1493         _createSharedRole(uint256(Roles.Burner), uint256(Roles.Owner), new address[](0));
1494     }
1495 
1496     /**
1497      * @dev Mints `value` tokens to `recipient`, returning true on success.
1498      * @param recipient address to mint to.
1499      * @param value amount of tokens to mint.
1500      * @return True if the mint succeeded, or False.
1501      */
1502     function mint(address recipient, uint256 value)
1503         external
1504         override
1505         onlyRoleHolder(uint256(Roles.Minter))
1506         returns (bool)
1507     {
1508         _mint(recipient, value);
1509         return true;
1510     }
1511 
1512     /**
1513      * @dev Burns `value` tokens owned by `msg.sender`.
1514      * @param value amount of tokens to burn.
1515      */
1516     function burn(uint256 value) external override onlyRoleHolder(uint256(Roles.Burner)) {
1517         _burn(msg.sender, value);
1518     }
1519 }
1520 
1521 // File: contracts/common/implementation/Lockable.sol
1522 
1523 pragma solidity ^0.6.0;
1524 
1525 
1526 /**
1527  * @title A contract that provides modifiers to prevent reentrancy to state-changing and view-only methods. This contract
1528  * is inspired by https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/ReentrancyGuard.sol
1529  * and https://github.com/balancer-labs/balancer-core/blob/master/contracts/BPool.sol.
1530  */
1531 contract Lockable {
1532     bool private _notEntered;
1533 
1534     constructor() internal {
1535         // Storing an initial non-zero value makes deployment a bit more
1536         // expensive, but in exchange the refund on every call to nonReentrant
1537         // will be lower in amount. Since refunds are capped to a percetange of
1538         // the total transaction's gas, it is best to keep them low in cases
1539         // like this one, to increase the likelihood of the full refund coming
1540         // into effect.
1541         _notEntered = true;
1542     }
1543 
1544     /**
1545      * @dev Prevents a contract from calling itself, directly or indirectly.
1546      * Calling a `nonReentrant` function from another `nonReentrant`
1547      * function is not supported. It is possible to prevent this from happening
1548      * by making the `nonReentrant` function external, and make it call a
1549      * `private` function that does the actual work.
1550      */
1551     modifier nonReentrant() {
1552         _preEntranceCheck();
1553         _preEntranceSet();
1554         _;
1555         _postEntranceReset();
1556     }
1557 
1558     /**
1559      * @dev Designed to prevent a view-only method from being re-entered during a call to a `nonReentrant()` state-changing method.
1560      */
1561     modifier nonReentrantView() {
1562         _preEntranceCheck();
1563         _;
1564     }
1565 
1566     // Internal methods are used to avoid copying the require statement's bytecode to every `nonReentrant()` method.
1567     // On entry into a function, `_preEntranceCheck()` should always be called to check if the function is being re-entered.
1568     // Then, if the function modifies state, it should call `_postEntranceSet()`, perform its logic, and then call `_postEntranceReset()`.
1569     // View-only methods can simply call `_preEntranceCheck()` to make sure that it is not being re-entered.
1570     function _preEntranceCheck() internal view {
1571         // On the first call to nonReentrant, _notEntered will be true
1572         require(_notEntered, "ReentrancyGuard: reentrant call");
1573     }
1574 
1575     function _preEntranceSet() internal {
1576         // Any calls to nonReentrant after this point will fail
1577         _notEntered = false;
1578     }
1579 
1580     function _postEntranceReset() internal {
1581         // By storing the original value once again, a refund is triggered (see
1582         // https://eips.ethereum.org/EIPS/eip-2200)
1583         _notEntered = true;
1584     }
1585 }
1586 
1587 // File: contracts/financial-templates/common/SyntheticToken.sol
1588 
1589 pragma solidity ^0.6.0;
1590 
1591 
1592 
1593 
1594 /**
1595  * @title Burnable and mintable ERC20.
1596  * @dev The contract deployer will initially be the only minter, burner and owner capable of adding new roles.
1597  */
1598 
1599 contract SyntheticToken is ExpandedERC20, Lockable {
1600     /**
1601      * @notice Constructs the SyntheticToken.
1602      * @param tokenName The name which describes the new token.
1603      * @param tokenSymbol The ticker abbreviation of the name. Ideally < 5 chars.
1604      * @param tokenDecimals The number of decimals to define token precision.
1605      */
1606     constructor(
1607         string memory tokenName,
1608         string memory tokenSymbol,
1609         uint8 tokenDecimals
1610     ) public ExpandedERC20(tokenName, tokenSymbol, tokenDecimals) nonReentrant() {}
1611 
1612     /**
1613      * @notice Add Minter role to account.
1614      * @dev The caller must have the Owner role.
1615      * @param account The address to which the Minter role is added.
1616      */
1617     function addMinter(address account) external nonReentrant() {
1618         addMember(uint256(Roles.Minter), account);
1619     }
1620 
1621     /**
1622      * @notice Remove Minter role from account.
1623      * @dev The caller must have the Owner role.
1624      * @param account The address from which the Minter role is removed.
1625      */
1626     function removeMinter(address account) external nonReentrant() {
1627         removeMember(uint256(Roles.Minter), account);
1628     }
1629 
1630     /**
1631      * @notice Add Burner role to account.
1632      * @dev The caller must have the Owner role.
1633      * @param account The address to which the Burner role is added.
1634      */
1635     function addBurner(address account) external nonReentrant() {
1636         addMember(uint256(Roles.Burner), account);
1637     }
1638 
1639     /**
1640      * @notice Removes Burner role from account.
1641      * @dev The caller must have the Owner role.
1642      * @param account The address from which the Burner role is removed.
1643      */
1644     function removeBurner(address account) external nonReentrant() {
1645         removeMember(uint256(Roles.Burner), account);
1646     }
1647 
1648     /**
1649      * @notice Reset Owner role to account.
1650      * @dev The caller must have the Owner role.
1651      * @param account The new holder of the Owner role.
1652      */
1653     function resetOwner(address account) external nonReentrant() {
1654         resetMember(uint256(Roles.Owner), account);
1655     }
1656 
1657     /**
1658      * @notice Checks if a given account holds the Minter role.
1659      * @param account The address which is checked for the Minter role.
1660      * @return bool True if the provided account is a Minter.
1661      */
1662     function isMinter(address account) public view nonReentrantView() returns (bool) {
1663         return holdsRole(uint256(Roles.Minter), account);
1664     }
1665 
1666     /**
1667      * @notice Checks if a given account holds the Burner role.
1668      * @param account The address which is checked for the Burner role.
1669      * @return bool True if the provided account is a Burner.
1670      */
1671     function isBurner(address account) public view nonReentrantView() returns (bool) {
1672         return holdsRole(uint256(Roles.Burner), account);
1673     }
1674 }
1675 
1676 // File: contracts/financial-templates/common/TokenFactory.sol
1677 
1678 pragma solidity ^0.6.0;
1679 
1680 
1681 
1682 
1683 
1684 /**
1685  * @title Factory for creating new mintable and burnable tokens.
1686  */
1687 
1688 contract TokenFactory is Lockable {
1689     /**
1690      * @notice Create a new token and return it to the caller.
1691      * @dev The caller will become the only minter and burner and the new owner capable of assigning the roles.
1692      * @param tokenName used to describe the new token.
1693      * @param tokenSymbol short ticker abbreviation of the name. Ideally < 5 chars.
1694      * @param tokenDecimals used to define the precision used in the token's numerical representation.
1695      * @return newToken an instance of the newly created token interface.
1696      */
1697     function createToken(
1698         string calldata tokenName,
1699         string calldata tokenSymbol,
1700         uint8 tokenDecimals
1701     ) external nonReentrant() returns (ExpandedIERC20 newToken) {
1702         SyntheticToken mintableToken = new SyntheticToken(tokenName, tokenSymbol, tokenDecimals);
1703         mintableToken.addMinter(msg.sender);
1704         mintableToken.addBurner(msg.sender);
1705         mintableToken.resetOwner(msg.sender);
1706         newToken = ExpandedIERC20(address(mintableToken));
1707     }
1708 }
1709 
1710 // File: contracts/common/implementation/Timer.sol
1711 
1712 pragma solidity ^0.6.0;
1713 
1714 
1715 /**
1716  * @title Universal store of current contract time for testing environments.
1717  */
1718 contract Timer {
1719     uint256 private currentTime;
1720 
1721     constructor() public {
1722         currentTime = now; // solhint-disable-line not-rely-on-time
1723     }
1724 
1725     /**
1726      * @notice Sets the current time.
1727      * @dev Will revert if not running in test mode.
1728      * @param time timestamp to set `currentTime` to.
1729      */
1730     function setCurrentTime(uint256 time) external {
1731         currentTime = time;
1732     }
1733 
1734     /**
1735      * @notice Gets the current time. Will return the last time set in `setCurrentTime` if running in test mode.
1736      * Otherwise, it will return the block timestamp.
1737      * @return uint256 for the current Testable timestamp.
1738      */
1739     function getCurrentTime() public view returns (uint256) {
1740         return currentTime;
1741     }
1742 }
1743 
1744 // File: contracts/common/implementation/Testable.sol
1745 
1746 pragma solidity ^0.6.0;
1747 
1748 
1749 
1750 /**
1751  * @title Base class that provides time overrides, but only if being run in test mode.
1752  */
1753 abstract contract Testable {
1754     // If the contract is being run on the test network, then `timerAddress` will be the 0x0 address.
1755     // Note: this variable should be set on construction and never modified.
1756     address public timerAddress;
1757 
1758     /**
1759      * @notice Constructs the Testable contract. Called by child contracts.
1760      * @param _timerAddress Contract that stores the current time in a testing environment.
1761      * Must be set to 0x0 for production environments that use live time.
1762      */
1763     constructor(address _timerAddress) internal {
1764         timerAddress = _timerAddress;
1765     }
1766 
1767     /**
1768      * @notice Reverts if not running in test mode.
1769      */
1770     modifier onlyIfTest {
1771         require(timerAddress != address(0x0));
1772         _;
1773     }
1774 
1775     /**
1776      * @notice Sets the current time.
1777      * @dev Will revert if not running in test mode.
1778      * @param time timestamp to set current Testable time to.
1779      */
1780     function setCurrentTime(uint256 time) external onlyIfTest {
1781         Timer(timerAddress).setCurrentTime(time);
1782     }
1783 
1784     /**
1785      * @notice Gets the current time. Will return the last time set in `setCurrentTime` if running in test mode.
1786      * Otherwise, it will return the block timestamp.
1787      * @return uint for the current Testable timestamp.
1788      */
1789     function getCurrentTime() public view returns (uint256) {
1790         if (timerAddress != address(0x0)) {
1791             return Timer(timerAddress).getCurrentTime();
1792         } else {
1793             return now; // solhint-disable-line not-rely-on-time
1794         }
1795     }
1796 }
1797 
1798 // File: contracts/oracle/interfaces/StoreInterface.sol
1799 
1800 pragma solidity ^0.6.0;
1801 
1802 
1803 
1804 
1805 /**
1806  * @title Interface that allows financial contracts to pay oracle fees for their use of the system.
1807  */
1808 interface StoreInterface {
1809     /**
1810      * @notice Pays Oracle fees in ETH to the store.
1811      * @dev To be used by contracts whose margin currency is ETH.
1812      */
1813     function payOracleFees() external payable;
1814 
1815     /**
1816      * @notice Pays oracle fees in the margin currency, erc20Address, to the store.
1817      * @dev To be used if the margin currency is an ERC20 token rather than ETH.
1818      * @param erc20Address address of the ERC20 token used to pay the fee.
1819      * @param amount number of tokens to transfer. An approval for at least this amount must exist.
1820      */
1821     function payOracleFeesErc20(address erc20Address, FixedPoint.Unsigned calldata amount) external;
1822 
1823     /**
1824      * @notice Computes the regular oracle fees that a contract should pay for a period.
1825      * @param startTime defines the beginning time from which the fee is paid.
1826      * @param endTime end time until which the fee is paid.
1827      * @param pfc "profit from corruption", or the maximum amount of margin currency that a
1828      * token sponsor could extract from the contract through corrupting the price feed in their favor.
1829      * @return regularFee amount owed for the duration from start to end time for the given pfc.
1830      * @return latePenalty for paying the fee after the deadline.
1831      */
1832     function computeRegularFee(
1833         uint256 startTime,
1834         uint256 endTime,
1835         FixedPoint.Unsigned calldata pfc
1836     ) external view returns (FixedPoint.Unsigned memory regularFee, FixedPoint.Unsigned memory latePenalty);
1837 
1838     /**
1839      * @notice Computes the final oracle fees that a contract should pay at settlement.
1840      * @param currency token used to pay the final fee.
1841      * @return finalFee amount due.
1842      */
1843     function computeFinalFee(address currency) external view returns (FixedPoint.Unsigned memory);
1844 }
1845 
1846 // File: contracts/oracle/interfaces/FinderInterface.sol
1847 
1848 pragma solidity ^0.6.0;
1849 
1850 
1851 /**
1852  * @title Provides addresses of the live contracts implementing certain interfaces.
1853  * @dev Examples are the Oracle or Store interfaces.
1854  */
1855 interface FinderInterface {
1856     /**
1857      * @notice Updates the address of the contract that implements `interfaceName`.
1858      * @param interfaceName bytes32 encoding of the interface name that is either changed or registered.
1859      * @param implementationAddress address of the deployed contract that implements the interface.
1860      */
1861     function changeImplementationAddress(bytes32 interfaceName, address implementationAddress) external;
1862 
1863     /**
1864      * @notice Gets the address of the contract that implements the given `interfaceName`.
1865      * @param interfaceName queried interface.
1866      * @return implementationAddress address of the deployed contract that implements the interface.
1867      */
1868     function getImplementationAddress(bytes32 interfaceName) external view returns (address);
1869 }
1870 
1871 // File: contracts/financial-templates/common/FeePayer.sol
1872 
1873 pragma solidity ^0.6.0;
1874 
1875 
1876 
1877 
1878 
1879 
1880 
1881 
1882 
1883 
1884 /**
1885  * @title FeePayer contract.
1886  * @notice Provides fee payment functionality for the ExpiringMultiParty contract.
1887  * contract is abstract as each derived contract that inherits `FeePayer` must implement `pfc()`.
1888  */
1889 
1890 abstract contract FeePayer is Testable, Lockable {
1891     using SafeMath for uint256;
1892     using FixedPoint for FixedPoint.Unsigned;
1893     using SafeERC20 for IERC20;
1894 
1895     /****************************************
1896      *      FEE PAYER DATA STRUCTURES       *
1897      ****************************************/
1898 
1899     // The collateral currency used to back the positions in this contract.
1900     IERC20 public collateralCurrency;
1901 
1902     // Finder contract used to look up addresses for UMA system contracts.
1903     FinderInterface public finder;
1904 
1905     // Tracks the last block time when the fees were paid.
1906     uint256 private lastPaymentTime;
1907 
1908     // Tracks the cumulative fees that have been paid by the contract for use by derived contracts.
1909     // The multiplier starts at 1, and is updated by computing cumulativeFeeMultiplier * (1 - effectiveFee).
1910     // Put another way, the cumulativeFeeMultiplier is (1 - effectiveFee1) * (1 - effectiveFee2) ...
1911     // For example:
1912     // The cumulativeFeeMultiplier should start at 1.
1913     // If a 1% fee is charged, the multiplier should update to .99.
1914     // If another 1% fee is charged, the multiplier should be 0.99^2 (0.9801).
1915     FixedPoint.Unsigned public cumulativeFeeMultiplier;
1916 
1917     /****************************************
1918      *                EVENTS                *
1919      ****************************************/
1920 
1921     event RegularFeesPaid(uint256 indexed regularFee, uint256 indexed lateFee);
1922     event FinalFeesPaid(uint256 indexed amount);
1923 
1924     /****************************************
1925      *              MODIFIERS               *
1926      ****************************************/
1927 
1928     // modifier that calls payRegularFees().
1929     modifier fees {
1930         payRegularFees();
1931         _;
1932     }
1933 
1934     /**
1935      * @notice Constructs the FeePayer contract. Called by child contracts.
1936      * @param _collateralAddress ERC20 token that is used as the underlying collateral for the synthetic.
1937      * @param _finderAddress UMA protocol Finder used to discover other protocol contracts.
1938      * @param _timerAddress Contract that stores the current time in a testing environment.
1939      * Must be set to 0x0 for production environments that use live time.
1940      */
1941     constructor(
1942         address _collateralAddress,
1943         address _finderAddress,
1944         address _timerAddress
1945     ) public Testable(_timerAddress) nonReentrant() {
1946         collateralCurrency = IERC20(_collateralAddress);
1947         finder = FinderInterface(_finderAddress);
1948         lastPaymentTime = getCurrentTime();
1949         cumulativeFeeMultiplier = FixedPoint.fromUnscaledUint(1);
1950     }
1951 
1952     /****************************************
1953      *        FEE PAYMENT FUNCTIONS         *
1954      ****************************************/
1955 
1956     /**
1957      * @notice Pays UMA DVM regular fees (as a % of the collateral pool) to the Store contract.
1958      * @dev These must be paid periodically for the life of the contract. If the contract has not paid its regular fee
1959      * in a week or more then a late penalty is applied which is sent to the caller. If the amount of
1960      * fees owed are greater than the pfc, then this will pay as much as possible from the available collateral.
1961      * An event is only fired if the fees charged are greater than 0.
1962      * @return totalPaid Amount of collateral that the contract paid (sum of the amount paid to the Store and caller).
1963      * This returns 0 and exit early if there is no pfc, fees were already paid during the current block, or the fee rate is 0.
1964      */
1965     function payRegularFees() public nonReentrant() returns (FixedPoint.Unsigned memory totalPaid) {
1966         StoreInterface store = _getStore();
1967         uint256 time = getCurrentTime();
1968         FixedPoint.Unsigned memory collateralPool = _pfc();
1969 
1970         // Exit early if there is no collateral from which to pay fees.
1971         if (collateralPool.isEqual(0)) {
1972             return totalPaid;
1973         }
1974 
1975         // Exit early if fees were already paid during this block.
1976         if (lastPaymentTime == time) {
1977             return totalPaid;
1978         }
1979 
1980         (FixedPoint.Unsigned memory regularFee, FixedPoint.Unsigned memory latePenalty) = store.computeRegularFee(
1981             lastPaymentTime,
1982             time,
1983             collateralPool
1984         );
1985         lastPaymentTime = time;
1986 
1987         totalPaid = regularFee.add(latePenalty);
1988         if (totalPaid.isEqual(0)) {
1989             return totalPaid;
1990         }
1991         // If the effective fees paid as a % of the pfc is > 100%, then we need to reduce it and make the contract pay
1992         // as much of the fee that it can (up to 100% of its pfc). We'll reduce the late penalty first and then the
1993         // regular fee, which has the effect of paying the store first, followed by the caller if there is any fee remaining.
1994         if (totalPaid.isGreaterThan(collateralPool)) {
1995             FixedPoint.Unsigned memory deficit = totalPaid.sub(collateralPool);
1996             FixedPoint.Unsigned memory latePenaltyReduction = FixedPoint.min(latePenalty, deficit);
1997             latePenalty = latePenalty.sub(latePenaltyReduction);
1998             deficit = deficit.sub(latePenaltyReduction);
1999             regularFee = regularFee.sub(FixedPoint.min(regularFee, deficit));
2000             totalPaid = collateralPool;
2001         }
2002 
2003         emit RegularFeesPaid(regularFee.rawValue, latePenalty.rawValue);
2004 
2005         _adjustCumulativeFeeMultiplier(totalPaid, collateralPool);
2006 
2007         if (regularFee.isGreaterThan(0)) {
2008             collateralCurrency.safeIncreaseAllowance(address(store), regularFee.rawValue);
2009             store.payOracleFeesErc20(address(collateralCurrency), regularFee);
2010         }
2011 
2012         if (latePenalty.isGreaterThan(0)) {
2013             collateralCurrency.safeTransfer(msg.sender, latePenalty.rawValue);
2014         }
2015         return totalPaid;
2016     }
2017 
2018     /**
2019      * @notice Gets the current profit from corruption for this contract in terms of the collateral currency.
2020      * @dev This is equivalent to the collateral pool available from which to pay fees. Therefore, derived contracts are
2021      * expected to implement this so that pay-fee methods can correctly compute the owed fees as a % of PfC.
2022      * @return pfc value for equal to the current profit from corruption denominated in collateral currency.
2023      */
2024     function pfc() public view nonReentrantView() returns (FixedPoint.Unsigned memory) {
2025         return _pfc();
2026     }
2027 
2028     /****************************************
2029      *         INTERNAL FUNCTIONS           *
2030      ****************************************/
2031 
2032     // Pays UMA Oracle final fees of `amount` in `collateralCurrency` to the Store contract. Final fee is a flat fee
2033     // charged for each price request. If payer is the contract, adjusts internal bookkeeping variables. If payer is not
2034     // the contract, pulls in `amount` of collateral currency.
2035     function _payFinalFees(address payer, FixedPoint.Unsigned memory amount) internal {
2036         if (amount.isEqual(0)) {
2037             return;
2038         }
2039 
2040         if (payer != address(this)) {
2041             // If the payer is not the contract pull the collateral from the payer.
2042             collateralCurrency.safeTransferFrom(payer, address(this), amount.rawValue);
2043         } else {
2044             // If the payer is the contract, adjust the cumulativeFeeMultiplier to compensate.
2045             FixedPoint.Unsigned memory collateralPool = _pfc();
2046 
2047             // The final fee must be < available collateral or the fee will be larger than 100%.
2048             require(collateralPool.isGreaterThan(amount), "Final fee is more than PfC");
2049 
2050             _adjustCumulativeFeeMultiplier(amount, collateralPool);
2051         }
2052 
2053         emit FinalFeesPaid(amount.rawValue);
2054 
2055         StoreInterface store = _getStore();
2056         collateralCurrency.safeIncreaseAllowance(address(store), amount.rawValue);
2057         store.payOracleFeesErc20(address(collateralCurrency), amount);
2058     }
2059 
2060     function _pfc() internal virtual view returns (FixedPoint.Unsigned memory);
2061 
2062     function _getStore() internal view returns (StoreInterface) {
2063         return StoreInterface(finder.getImplementationAddress(OracleInterfaces.Store));
2064     }
2065 
2066     function _computeFinalFees() internal view returns (FixedPoint.Unsigned memory finalFees) {
2067         StoreInterface store = _getStore();
2068         return store.computeFinalFee(address(collateralCurrency));
2069     }
2070 
2071     // Returns the user's collateral minus any fees that have been subtracted since it was originally
2072     // deposited into the contract. Note: if the contract has paid fees since it was deployed, the raw
2073     // value should be larger than the returned value.
2074     function _getFeeAdjustedCollateral(FixedPoint.Unsigned memory rawCollateral)
2075         internal
2076         view
2077         returns (FixedPoint.Unsigned memory collateral)
2078     {
2079         return rawCollateral.mul(cumulativeFeeMultiplier);
2080     }
2081 
2082     // Converts a user-readable collateral value into a raw value that accounts for already-assessed fees. If any fees
2083     // have been taken from this contract in the past, then the raw value will be larger than the user-readable value.
2084     function _convertToRawCollateral(FixedPoint.Unsigned memory collateral)
2085         internal
2086         view
2087         returns (FixedPoint.Unsigned memory rawCollateral)
2088     {
2089         return collateral.div(cumulativeFeeMultiplier);
2090     }
2091 
2092     // Decrease rawCollateral by a fee-adjusted collateralToRemove amount. Fee adjustment scales up collateralToRemove
2093     // by dividing it by cumulativeFeeMultiplier. There is potential for this quotient to be floored, therefore
2094     // rawCollateral is decreased by less than expected. Because this method is usually called in conjunction with an
2095     // actual removal of collateral from this contract, return the fee-adjusted amount that the rawCollateral is
2096     // decreased by so that the caller can minimize error between collateral removed and rawCollateral debited.
2097     function _removeCollateral(FixedPoint.Unsigned storage rawCollateral, FixedPoint.Unsigned memory collateralToRemove)
2098         internal
2099         returns (FixedPoint.Unsigned memory removedCollateral)
2100     {
2101         FixedPoint.Unsigned memory initialBalance = _getFeeAdjustedCollateral(rawCollateral);
2102         FixedPoint.Unsigned memory adjustedCollateral = _convertToRawCollateral(collateralToRemove);
2103         rawCollateral.rawValue = rawCollateral.sub(adjustedCollateral).rawValue;
2104         removedCollateral = initialBalance.sub(_getFeeAdjustedCollateral(rawCollateral));
2105     }
2106 
2107     // Increase rawCollateral by a fee-adjusted collateralToAdd amount. Fee adjustment scales up collateralToAdd
2108     // by dividing it by cumulativeFeeMultiplier. There is potential for this quotient to be floored, therefore
2109     // rawCollateral is increased by less than expected. Because this method is usually called in conjunction with an
2110     // actual addition of collateral to this contract, return the fee-adjusted amount that the rawCollateral is
2111     // increased by so that the caller can minimize error between collateral added and rawCollateral credited.
2112     // NOTE: This return value exists only for the sake of symmetry with _removeCollateral. We don't actually use it
2113     // because we are OK if more collateral is stored in the contract than is represented by rawTotalPositionCollateral.
2114     function _addCollateral(FixedPoint.Unsigned storage rawCollateral, FixedPoint.Unsigned memory collateralToAdd)
2115         internal
2116         returns (FixedPoint.Unsigned memory addedCollateral)
2117     {
2118         FixedPoint.Unsigned memory initialBalance = _getFeeAdjustedCollateral(rawCollateral);
2119         FixedPoint.Unsigned memory adjustedCollateral = _convertToRawCollateral(collateralToAdd);
2120         rawCollateral.rawValue = rawCollateral.add(adjustedCollateral).rawValue;
2121         addedCollateral = _getFeeAdjustedCollateral(rawCollateral).sub(initialBalance);
2122     }
2123 
2124     // Scale the cumulativeFeeMultiplier by the ratio of fees paid to the current available collateral.
2125     function _adjustCumulativeFeeMultiplier(FixedPoint.Unsigned memory amount, FixedPoint.Unsigned memory currentPfc)
2126         internal
2127     {
2128         FixedPoint.Unsigned memory effectiveFee = amount.divCeil(currentPfc);
2129         cumulativeFeeMultiplier = cumulativeFeeMultiplier.mul(FixedPoint.fromUnscaledUint(1).sub(effectiveFee));
2130     }
2131 }
2132 
2133 // File: contracts/financial-templates/expiring-multiparty/PricelessPositionManager.sol
2134 
2135 pragma solidity ^0.6.0;
2136 
2137 
2138 
2139 
2140 
2141 
2142 
2143 
2144 
2145 
2146 
2147 
2148 
2149 /**
2150  * @title Financial contract with priceless position management.
2151  * @notice Handles positions for multiple sponsors in an optimistic (i.e., priceless) way without relying
2152  * on a price feed. On construction, deploys a new ERC20, managed by this contract, that is the synthetic token.
2153  */
2154 
2155 contract PricelessPositionManager is FeePayer, AdministrateeInterface {
2156     using SafeMath for uint256;
2157     using FixedPoint for FixedPoint.Unsigned;
2158     using SafeERC20 for IERC20;
2159     using SafeERC20 for ExpandedIERC20;
2160 
2161     /****************************************
2162      *  PRICELESS POSITION DATA STRUCTURES  *
2163      ****************************************/
2164 
2165     // Stores the state of the PricelessPositionManager. Set on expiration, emergency shutdown, or settlement.
2166     enum ContractState { Open, ExpiredPriceRequested, ExpiredPriceReceived }
2167     ContractState public contractState;
2168 
2169     // Represents a single sponsor's position. All collateral is held by this contract.
2170     // This struct acts as bookkeeping for how much of that collateral is allocated to each sponsor.
2171     struct PositionData {
2172         FixedPoint.Unsigned tokensOutstanding;
2173         // Tracks pending withdrawal requests. A withdrawal request is pending if `withdrawalRequestPassTimestamp != 0`.
2174         uint256 withdrawalRequestPassTimestamp;
2175         FixedPoint.Unsigned withdrawalRequestAmount;
2176         // Raw collateral value. This value should never be accessed directly -- always use _getFeeAdjustedCollateral().
2177         // To add or remove collateral, use _addCollateral() and _removeCollateral().
2178         FixedPoint.Unsigned rawCollateral;
2179         // Tracks pending transfer position requests. A transfer position request is pending if `transferPositionRequestPassTimestamp != 0`.
2180         uint256 transferPositionRequestPassTimestamp;
2181     }
2182 
2183     // Maps sponsor addresses to their positions. Each sponsor can have only one position.
2184     mapping(address => PositionData) public positions;
2185 
2186     // Keep track of the total collateral and tokens across all positions to enable calculating the
2187     // global collateralization ratio without iterating over all positions.
2188     FixedPoint.Unsigned public totalTokensOutstanding;
2189 
2190     // Similar to the rawCollateral in PositionData, this value should not be used directly.
2191     // _getFeeAdjustedCollateral(), _addCollateral() and _removeCollateral() must be used to access and adjust.
2192     FixedPoint.Unsigned public rawTotalPositionCollateral;
2193 
2194     // Synthetic token created by this contract.
2195     ExpandedIERC20 public tokenCurrency;
2196 
2197     // Unique identifier for DVM price feed ticker.
2198     bytes32 public priceIdentifier;
2199     // Time that this contract expires. Should not change post-construction unless an emergency shutdown occurs.
2200     uint256 public expirationTimestamp;
2201     // Time that has to elapse for a withdrawal request to be considered passed, if no liquidations occur.
2202     // !!Note: The lower the withdrawal liveness value, the more risk incurred by the contract.
2203     //       Extremely low liveness values increase the chance that opportunistic invalid withdrawal requests
2204     //       expire without liquidation, thereby increasing the insolvency risk for the contract as a whole. An insolvent
2205     //       contract is extremely risky for any sponsor or synthetic token holder for the contract.
2206     uint256 public withdrawalLiveness;
2207 
2208     // Minimum number of tokens in a sponsor's position.
2209     FixedPoint.Unsigned public minSponsorTokens;
2210 
2211     // The expiry price pulled from the DVM.
2212     FixedPoint.Unsigned public expiryPrice;
2213 
2214     // The excessTokenBeneficiary of any excess tokens added to the contract.
2215     address public excessTokenBeneficiary;
2216 
2217     /****************************************
2218      *                EVENTS                *
2219      ****************************************/
2220 
2221     event RequestTransferPosition(address indexed oldSponsor);
2222     event RequestTransferPositionExecuted(address indexed oldSponsor, address indexed newSponsor);
2223     event RequestTransferPositionCanceled(address indexed oldSponsor);
2224     event Deposit(address indexed sponsor, uint256 indexed collateralAmount);
2225     event Withdrawal(address indexed sponsor, uint256 indexed collateralAmount);
2226     event RequestWithdrawal(address indexed sponsor, uint256 indexed collateralAmount);
2227     event RequestWithdrawalExecuted(address indexed sponsor, uint256 indexed collateralAmount);
2228     event RequestWithdrawalCanceled(address indexed sponsor, uint256 indexed collateralAmount);
2229     event PositionCreated(address indexed sponsor, uint256 indexed collateralAmount, uint256 indexed tokenAmount);
2230     event NewSponsor(address indexed sponsor);
2231     event EndedSponsorPosition(address indexed sponsor);
2232     event Redeem(address indexed sponsor, uint256 indexed collateralAmount, uint256 indexed tokenAmount);
2233     event ContractExpired(address indexed caller);
2234     event SettleExpiredPosition(
2235         address indexed caller,
2236         uint256 indexed collateralReturned,
2237         uint256 indexed tokensBurned
2238     );
2239     event EmergencyShutdown(address indexed caller, uint256 originalExpirationTimestamp, uint256 shutdownTimestamp);
2240 
2241     /****************************************
2242      *               MODIFIERS              *
2243      ****************************************/
2244 
2245     modifier onlyPreExpiration() {
2246         _onlyPreExpiration();
2247         _;
2248     }
2249 
2250     modifier onlyPostExpiration() {
2251         _onlyPostExpiration();
2252         _;
2253     }
2254 
2255     modifier onlyCollateralizedPosition(address sponsor) {
2256         _onlyCollateralizedPosition(sponsor);
2257         _;
2258     }
2259 
2260     // Check that the current state of the pricelessPositionManager is Open.
2261     // This prevents multiple calls to `expire` and `EmergencyShutdown` post expiration.
2262     modifier onlyOpenState() {
2263         _onlyOpenState();
2264         _;
2265     }
2266 
2267     modifier noPendingWithdrawal(address sponsor) {
2268         _positionHasNoPendingWithdrawal(sponsor);
2269         _;
2270     }
2271 
2272     /**
2273      * @notice Construct the PricelessPositionManager
2274      * @param _expirationTimestamp unix timestamp of when the contract will expire.
2275      * @param _withdrawalLiveness liveness delay, in seconds, for pending withdrawals.
2276      * @param _collateralAddress ERC20 token used as collateral for all positions.
2277      * @param _finderAddress UMA protocol Finder used to discover other protocol contracts.
2278      * @param _priceIdentifier registered in the DVM for the synthetic.
2279      * @param _syntheticName name for the token contract that will be deployed.
2280      * @param _syntheticSymbol symbol for the token contract that will be deployed.
2281      * @param _tokenFactoryAddress deployed UMA token factory to create the synthetic token.
2282      * @param _minSponsorTokens minimum amount of collateral that must exist at any time in a position.
2283      * @param _timerAddress Contract that stores the current time in a testing environment.
2284      * @param _excessTokenBeneficiary Beneficiary to which all excess token balances that accrue in the contract can be
2285      * sent.
2286      * Must be set to 0x0 for production environments that use live time.
2287      */
2288     constructor(
2289         uint256 _expirationTimestamp,
2290         uint256 _withdrawalLiveness,
2291         address _collateralAddress,
2292         address _finderAddress,
2293         bytes32 _priceIdentifier,
2294         string memory _syntheticName,
2295         string memory _syntheticSymbol,
2296         address _tokenFactoryAddress,
2297         FixedPoint.Unsigned memory _minSponsorTokens,
2298         address _timerAddress,
2299         address _excessTokenBeneficiary
2300     ) public FeePayer(_collateralAddress, _finderAddress, _timerAddress) nonReentrant() {
2301         require(_expirationTimestamp > getCurrentTime(), "Invalid expiration in future");
2302         require(_getIdentifierWhitelist().isIdentifierSupported(_priceIdentifier), "Unsupported price identifier");
2303 
2304         expirationTimestamp = _expirationTimestamp;
2305         withdrawalLiveness = _withdrawalLiveness;
2306         TokenFactory tf = TokenFactory(_tokenFactoryAddress);
2307         tokenCurrency = tf.createToken(_syntheticName, _syntheticSymbol, 18);
2308         minSponsorTokens = _minSponsorTokens;
2309         priceIdentifier = _priceIdentifier;
2310         excessTokenBeneficiary = _excessTokenBeneficiary;
2311     }
2312 
2313     /****************************************
2314      *          POSITION FUNCTIONS          *
2315      ****************************************/
2316 
2317     /**
2318      * @notice Requests to transfer ownership of the caller's current position to a new sponsor address.
2319      * Once the request liveness is passed, the sponsor can execute the transfer and specify the new sponsor.
2320      * @dev The liveness length is the same as the withdrawal liveness.
2321      */
2322     function requestTransferPosition() public onlyPreExpiration() nonReentrant() {
2323         PositionData storage positionData = _getPositionData(msg.sender);
2324         require(positionData.transferPositionRequestPassTimestamp == 0, "Pending transfer");
2325 
2326         // Make sure the proposed expiration of this request is not post-expiry.
2327         uint256 requestPassTime = getCurrentTime().add(withdrawalLiveness);
2328         require(requestPassTime < expirationTimestamp, "Request expires post-expiry");
2329 
2330         // Update the position object for the user.
2331         positionData.transferPositionRequestPassTimestamp = requestPassTime;
2332 
2333         emit RequestTransferPosition(msg.sender);
2334     }
2335 
2336     /**
2337      * @notice After a passed transfer position request (i.e., by a call to `requestTransferPosition` and waiting
2338      * `withdrawalLiveness`), transfers ownership of the caller's current position to `newSponsorAddress`.
2339      * @dev Transferring positions can only occur if the recipient does not already have a position.
2340      * @param newSponsorAddress is the address to which the position will be transferred.
2341      */
2342     function transferPositionPassedRequest(address newSponsorAddress)
2343         public
2344         onlyPreExpiration()
2345         noPendingWithdrawal(msg.sender)
2346         nonReentrant()
2347     {
2348         require(
2349             _getFeeAdjustedCollateral(positions[newSponsorAddress].rawCollateral).isEqual(
2350                 FixedPoint.fromUnscaledUint(0)
2351             ),
2352             "Sponsor already has position"
2353         );
2354         PositionData storage positionData = _getPositionData(msg.sender);
2355         require(
2356             positionData.transferPositionRequestPassTimestamp != 0 &&
2357                 positionData.transferPositionRequestPassTimestamp <= getCurrentTime(),
2358             "Invalid transfer request"
2359         );
2360 
2361         // Reset transfer request.
2362         positionData.transferPositionRequestPassTimestamp = 0;
2363 
2364         positions[newSponsorAddress] = positionData;
2365         delete positions[msg.sender];
2366 
2367         emit RequestTransferPositionExecuted(msg.sender, newSponsorAddress);
2368         emit NewSponsor(newSponsorAddress);
2369         emit EndedSponsorPosition(msg.sender);
2370     }
2371 
2372     /**
2373      * @notice Cancels a pending transfer position request.
2374      */
2375     function cancelTransferPosition() external onlyPreExpiration() nonReentrant() {
2376         PositionData storage positionData = _getPositionData(msg.sender);
2377         require(positionData.transferPositionRequestPassTimestamp != 0, "No pending transfer");
2378 
2379         emit RequestTransferPositionCanceled(msg.sender);
2380 
2381         // Reset withdrawal request.
2382         positionData.transferPositionRequestPassTimestamp = 0;
2383     }
2384 
2385     /**
2386      * @notice Transfers `collateralAmount` of `collateralCurrency` into the specified sponsor's position.
2387      * @dev Increases the collateralization level of a position after creation. This contract must be approved to spend
2388      * at least `collateralAmount` of `collateralCurrency`.
2389      * @param sponsor the sponsor to credit the deposit to.
2390      * @param collateralAmount total amount of collateral tokens to be sent to the sponsor's position.
2391      */
2392     function depositTo(address sponsor, FixedPoint.Unsigned memory collateralAmount)
2393         public
2394         onlyPreExpiration()
2395         noPendingWithdrawal(sponsor)
2396         fees()
2397         nonReentrant()
2398     {
2399         require(collateralAmount.isGreaterThan(0), "Invalid collateral amount");
2400         PositionData storage positionData = _getPositionData(sponsor);
2401 
2402         // Increase the position and global collateral balance by collateral amount.
2403         _incrementCollateralBalances(positionData, collateralAmount);
2404 
2405         emit Deposit(sponsor, collateralAmount.rawValue);
2406 
2407         // Move collateral currency from sender to contract.
2408         collateralCurrency.safeTransferFrom(msg.sender, address(this), collateralAmount.rawValue);
2409     }
2410 
2411     /**
2412      * @notice Transfers `collateralAmount` of `collateralCurrency` into the caller's position.
2413      * @dev Increases the collateralization level of a position after creation. This contract must be approved to spend
2414      * at least `collateralAmount` of `collateralCurrency`.
2415      * @param collateralAmount total amount of collateral tokens to be sent to the sponsor's position.
2416      */
2417     function deposit(FixedPoint.Unsigned memory collateralAmount) public {
2418         // This is just a thin wrapper over depositTo that specified the sender as the sponsor.
2419         depositTo(msg.sender, collateralAmount);
2420     }
2421 
2422     /**
2423      * @notice Transfers `collateralAmount` of `collateralCurrency` from the sponsor's position to the sponsor.
2424      * @dev Reverts if the withdrawal puts this position's collateralization ratio below the global collateralization
2425      * ratio. In that case, use `requestWithdrawal`. Might not withdraw the full requested amount to account for precision loss.
2426      * @param collateralAmount is the amount of collateral to withdraw.
2427      * @return amountWithdrawn The actual amount of collateral withdrawn.
2428      */
2429     function withdraw(FixedPoint.Unsigned memory collateralAmount)
2430         public
2431         onlyPreExpiration()
2432         noPendingWithdrawal(msg.sender)
2433         fees()
2434         nonReentrant()
2435         returns (FixedPoint.Unsigned memory amountWithdrawn)
2436     {
2437         PositionData storage positionData = _getPositionData(msg.sender);
2438         require(collateralAmount.isGreaterThan(0), "Invalid collateral amount");
2439 
2440         // Decrement the sponsor's collateral and global collateral amounts. Check the GCR between decrement to ensure
2441         // position remains above the GCR within the witdrawl. If this is not the case the caller must submit a request.
2442         amountWithdrawn = _decrementCollateralBalancesCheckGCR(positionData, collateralAmount);
2443 
2444         emit Withdrawal(msg.sender, amountWithdrawn.rawValue);
2445 
2446         // Move collateral currency from contract to sender.
2447         // Note: that we move the amount of collateral that is decreased from rawCollateral (inclusive of fees)
2448         // instead of the user requested amount. This eliminates precision loss that could occur
2449         // where the user withdraws more collateral than rawCollateral is decremented by.
2450         collateralCurrency.safeTransfer(msg.sender, amountWithdrawn.rawValue);
2451     }
2452 
2453     /**
2454      * @notice Starts a withdrawal request that, if passed, allows the sponsor to withdraw` from their position.
2455      * @dev The request will be pending for `withdrawalLiveness`, during which the position can be liquidated.
2456      * @param collateralAmount the amount of collateral requested to withdraw
2457      */
2458     function requestWithdrawal(FixedPoint.Unsigned memory collateralAmount)
2459         public
2460         onlyPreExpiration()
2461         noPendingWithdrawal(msg.sender)
2462         nonReentrant()
2463     {
2464         PositionData storage positionData = _getPositionData(msg.sender);
2465         require(
2466             collateralAmount.isGreaterThan(0) &&
2467                 collateralAmount.isLessThanOrEqual(_getFeeAdjustedCollateral(positionData.rawCollateral)),
2468             "Invalid collateral amount"
2469         );
2470 
2471         // Make sure the proposed expiration of this request is not post-expiry.
2472         uint256 requestPassTime = getCurrentTime().add(withdrawalLiveness);
2473         require(requestPassTime < expirationTimestamp, "Request expires post-expiry");
2474 
2475         // Update the position object for the user.
2476         positionData.withdrawalRequestPassTimestamp = requestPassTime;
2477         positionData.withdrawalRequestAmount = collateralAmount;
2478 
2479         emit RequestWithdrawal(msg.sender, collateralAmount.rawValue);
2480     }
2481 
2482     /**
2483      * @notice After a passed withdrawal request (i.e., by a call to `requestWithdrawal` and waiting
2484      * `withdrawalLiveness`), withdraws `positionData.withdrawalRequestAmount` of collateral currency.
2485      * @dev Might not withdraw the full requested amount in order to account for precision loss or if the full requested
2486      * amount exceeds the collateral in the position (due to paying fees).
2487      * @return amountWithdrawn The actual amount of collateral withdrawn.
2488      */
2489     function withdrawPassedRequest()
2490         external
2491         onlyPreExpiration()
2492         fees()
2493         nonReentrant()
2494         returns (FixedPoint.Unsigned memory amountWithdrawn)
2495     {
2496         PositionData storage positionData = _getPositionData(msg.sender);
2497         require(
2498             positionData.withdrawalRequestPassTimestamp != 0 &&
2499                 positionData.withdrawalRequestPassTimestamp <= getCurrentTime(),
2500             "Invalid withdraw request"
2501         );
2502 
2503         // If withdrawal request amount is > position collateral, then withdraw the full collateral amount.
2504         // This situation is possible due to fees charged since the withdrawal was originally requested.
2505         FixedPoint.Unsigned memory amountToWithdraw = positionData.withdrawalRequestAmount;
2506         if (positionData.withdrawalRequestAmount.isGreaterThan(_getFeeAdjustedCollateral(positionData.rawCollateral))) {
2507             amountToWithdraw = _getFeeAdjustedCollateral(positionData.rawCollateral);
2508         }
2509 
2510         // Decrement the sponsor's collateral and global collateral amounts.
2511         amountWithdrawn = _decrementCollateralBalances(positionData, amountToWithdraw);
2512 
2513         // Reset withdrawal request by setting withdrawal amount and withdrawal timestamp to 0.
2514         _resetWithdrawalRequest(positionData);
2515 
2516         // Transfer approved withdrawal amount from the contract to the caller.
2517         collateralCurrency.safeTransfer(msg.sender, amountWithdrawn.rawValue);
2518 
2519         emit RequestWithdrawalExecuted(msg.sender, amountWithdrawn.rawValue);
2520     }
2521 
2522     /**
2523      * @notice Cancels a pending withdrawal request.
2524      */
2525     function cancelWithdrawal() external nonReentrant() {
2526         PositionData storage positionData = _getPositionData(msg.sender);
2527         require(positionData.withdrawalRequestPassTimestamp != 0, "No pending withdrawal");
2528 
2529         emit RequestWithdrawalCanceled(msg.sender, positionData.withdrawalRequestAmount.rawValue);
2530 
2531         // Reset withdrawal request by setting withdrawal amount and withdrawal timestamp to 0.
2532         _resetWithdrawalRequest(positionData);
2533     }
2534 
2535     /**
2536      * @notice Creates tokens by creating a new position or by augmenting an existing position. Pulls `collateralAmount` into the sponsor's position and mints `numTokens` of `tokenCurrency`.
2537      * @dev Reverts if minting these tokens would put the position's collateralization ratio below the
2538      * global collateralization ratio. This contract must be approved to spend at least `collateralAmount` of
2539      * `collateralCurrency`.
2540      * @param collateralAmount is the number of collateral tokens to collateralize the position with
2541      * @param numTokens is the number of tokens to mint from the position.
2542      */
2543     function create(FixedPoint.Unsigned memory collateralAmount, FixedPoint.Unsigned memory numTokens)
2544         public
2545         onlyPreExpiration()
2546         fees()
2547         nonReentrant()
2548     {
2549         PositionData storage positionData = positions[msg.sender];
2550 
2551         // Either the new create ratio or the resultant position CR must be above the current GCR.
2552         require(
2553             (_checkCollateralization(
2554                 _getFeeAdjustedCollateral(positionData.rawCollateral).add(collateralAmount),
2555                 positionData.tokensOutstanding.add(numTokens)
2556             ) || _checkCollateralization(collateralAmount, numTokens)),
2557             "Insufficient collateral"
2558         );
2559 
2560         require(positionData.withdrawalRequestPassTimestamp == 0, "Pending withdrawal");
2561         if (positionData.tokensOutstanding.isEqual(0)) {
2562             require(numTokens.isGreaterThanOrEqual(minSponsorTokens), "Below minimum sponsor position");
2563             emit NewSponsor(msg.sender);
2564         }
2565 
2566         // Increase the position and global collateral balance by collateral amount.
2567         _incrementCollateralBalances(positionData, collateralAmount);
2568 
2569         // Add the number of tokens created to the position's outstanding tokens.
2570         positionData.tokensOutstanding = positionData.tokensOutstanding.add(numTokens);
2571 
2572         totalTokensOutstanding = totalTokensOutstanding.add(numTokens);
2573 
2574         emit PositionCreated(msg.sender, collateralAmount.rawValue, numTokens.rawValue);
2575 
2576         // Transfer tokens into the contract from caller and mint corresponding synthetic tokens to the caller's address.
2577         collateralCurrency.safeTransferFrom(msg.sender, address(this), collateralAmount.rawValue);
2578         require(tokenCurrency.mint(msg.sender, numTokens.rawValue), "Minting synthetic tokens failed");
2579     }
2580 
2581     /**
2582      * @notice Burns `numTokens` of `tokenCurrency` and sends back the proportional amount of `collateralCurrency`.
2583      * @dev Can only be called by a token sponsor. Might not redeem the full proportional amount of collateral
2584      * in order to account for precision loss. This contract must be approved to spend at least `numTokens` of
2585      * `tokenCurrency`.
2586      * @param numTokens is the number of tokens to be burnt for a commensurate amount of collateral.
2587      * @return amountWithdrawn The actual amount of collateral withdrawn.
2588      */
2589     function redeem(FixedPoint.Unsigned memory numTokens)
2590         public
2591         noPendingWithdrawal(msg.sender)
2592         fees()
2593         nonReentrant()
2594         returns (FixedPoint.Unsigned memory amountWithdrawn)
2595     {
2596         PositionData storage positionData = _getPositionData(msg.sender);
2597         require(!numTokens.isGreaterThan(positionData.tokensOutstanding), "Invalid token amount");
2598 
2599         FixedPoint.Unsigned memory fractionRedeemed = numTokens.div(positionData.tokensOutstanding);
2600         FixedPoint.Unsigned memory collateralRedeemed = fractionRedeemed.mul(
2601             _getFeeAdjustedCollateral(positionData.rawCollateral)
2602         );
2603 
2604         // If redemption returns all tokens the sponsor has then we can delete their position. Else, downsize.
2605         if (positionData.tokensOutstanding.isEqual(numTokens)) {
2606             amountWithdrawn = _deleteSponsorPosition(msg.sender);
2607         } else {
2608             // Decrement the sponsor's collateral and global collateral amounts.
2609             amountWithdrawn = _decrementCollateralBalances(positionData, collateralRedeemed);
2610 
2611             // Decrease the sponsors position tokens size. Ensure it is above the min sponsor size.
2612             FixedPoint.Unsigned memory newTokenCount = positionData.tokensOutstanding.sub(numTokens);
2613             require(newTokenCount.isGreaterThanOrEqual(minSponsorTokens), "Below minimum sponsor position");
2614             positionData.tokensOutstanding = newTokenCount;
2615 
2616             // Update the totalTokensOutstanding after redemption.
2617             totalTokensOutstanding = totalTokensOutstanding.sub(numTokens);
2618         }
2619 
2620         emit Redeem(msg.sender, amountWithdrawn.rawValue, numTokens.rawValue);
2621 
2622         // Transfer collateral from contract to caller and burn callers synthetic tokens.
2623         collateralCurrency.safeTransfer(msg.sender, amountWithdrawn.rawValue);
2624         tokenCurrency.safeTransferFrom(msg.sender, address(this), numTokens.rawValue);
2625         tokenCurrency.burn(numTokens.rawValue);
2626     }
2627 
2628     /**
2629      * @notice After a contract has passed expiry all token holders can redeem their tokens for underlying at the
2630      * prevailing price defined by the DVM from the `expire` function.
2631      * @dev This burns all tokens from the caller of `tokenCurrency` and sends back the proportional amount of
2632      * `collateralCurrency`. Might not redeem the full proportional amount of collateral in order to account for
2633      * precision loss. This contract must be approved to spend `tokenCurrency` at least up to the caller's full balance.
2634      * @return amountWithdrawn The actual amount of collateral withdrawn.
2635      */
2636     function settleExpired()
2637         external
2638         onlyPostExpiration()
2639         fees()
2640         nonReentrant()
2641         returns (FixedPoint.Unsigned memory amountWithdrawn)
2642     {
2643         // If the contract state is open and onlyPostExpiration passed then `expire()` has not yet been called.
2644         require(contractState != ContractState.Open, "Unexpired position");
2645 
2646         // Get the current settlement price and store it. If it is not resolved will revert.
2647         if (contractState != ContractState.ExpiredPriceReceived) {
2648             expiryPrice = _getOraclePrice(expirationTimestamp);
2649             contractState = ContractState.ExpiredPriceReceived;
2650         }
2651 
2652         // Get caller's tokens balance and calculate amount of underlying entitled to them.
2653         FixedPoint.Unsigned memory tokensToRedeem = FixedPoint.Unsigned(tokenCurrency.balanceOf(msg.sender));
2654         FixedPoint.Unsigned memory totalRedeemableCollateral = tokensToRedeem.mul(expiryPrice);
2655 
2656         // If the caller is a sponsor with outstanding collateral they are also entitled to their excess collateral after their debt.
2657         PositionData storage positionData = positions[msg.sender];
2658         if (_getFeeAdjustedCollateral(positionData.rawCollateral).isGreaterThan(0)) {
2659             // Calculate the underlying entitled to a token sponsor. This is collateral - debt in underlying.
2660             FixedPoint.Unsigned memory tokenDebtValueInCollateral = positionData.tokensOutstanding.mul(expiryPrice);
2661             FixedPoint.Unsigned memory positionCollateral = _getFeeAdjustedCollateral(positionData.rawCollateral);
2662 
2663             // If the debt is greater than the remaining collateral, they cannot redeem anything.
2664             FixedPoint.Unsigned memory positionRedeemableCollateral = tokenDebtValueInCollateral.isLessThan(
2665                 positionCollateral
2666             )
2667                 ? positionCollateral.sub(tokenDebtValueInCollateral)
2668                 : FixedPoint.Unsigned(0);
2669 
2670             // Add the number of redeemable tokens for the sponsor to their total redeemable collateral.
2671             totalRedeemableCollateral = totalRedeemableCollateral.add(positionRedeemableCollateral);
2672 
2673             // Reset the position state as all the value has been removed after settlement.
2674             delete positions[msg.sender];
2675             emit EndedSponsorPosition(msg.sender);
2676         }
2677 
2678         // Take the min of the remaining collateral and the collateral "owed". If the contract is undercapitalized,
2679         // the caller will get as much collateral as the contract can pay out.
2680         FixedPoint.Unsigned memory payout = FixedPoint.min(
2681             _getFeeAdjustedCollateral(rawTotalPositionCollateral),
2682             totalRedeemableCollateral
2683         );
2684 
2685         // Decrement total contract collateral and outstanding debt.
2686         amountWithdrawn = _removeCollateral(rawTotalPositionCollateral, payout);
2687         totalTokensOutstanding = totalTokensOutstanding.sub(tokensToRedeem);
2688 
2689         emit SettleExpiredPosition(msg.sender, amountWithdrawn.rawValue, tokensToRedeem.rawValue);
2690 
2691         // Transfer tokens & collateral and burn the redeemed tokens.
2692         collateralCurrency.safeTransfer(msg.sender, amountWithdrawn.rawValue);
2693         tokenCurrency.safeTransferFrom(msg.sender, address(this), tokensToRedeem.rawValue);
2694         tokenCurrency.burn(tokensToRedeem.rawValue);
2695     }
2696 
2697     /****************************************
2698      *        GLOBAL STATE FUNCTIONS        *
2699      ****************************************/
2700 
2701     /**
2702      * @notice Locks contract state in expired and requests oracle price.
2703      * @dev this function can only be called once the contract is expired and can't be re-called.
2704      */
2705     function expire() external onlyPostExpiration() onlyOpenState() fees() nonReentrant() {
2706         contractState = ContractState.ExpiredPriceRequested;
2707 
2708         // The final fee for this request is paid out of the contract rather than by the caller.
2709         _payFinalFees(address(this), _computeFinalFees());
2710         _requestOraclePrice(expirationTimestamp);
2711 
2712         emit ContractExpired(msg.sender);
2713     }
2714 
2715     /**
2716      * @notice Premature contract settlement under emergency circumstances.
2717      * @dev Only the governor can call this function as they are permissioned within the `FinancialContractAdmin`.
2718      * Upon emergency shutdown, the contract settlement time is set to the shutdown time. This enables withdrawal
2719      * to occur via the standard `settleExpired` function. Contract state is set to `ExpiredPriceRequested`
2720      * which prevents re-entry into this function or the `expire` function. No fees are paid when calling
2721      * `emergencyShutdown` as the governor who would call the function would also receive the fees.
2722      */
2723     function emergencyShutdown() external override onlyPreExpiration() onlyOpenState() nonReentrant() {
2724         require(msg.sender == _getFinancialContractsAdminAddress(), "Caller not Governor");
2725 
2726         contractState = ContractState.ExpiredPriceRequested;
2727         // Expiratory time now becomes the current time (emergency shutdown time).
2728         // Price requested at this time stamp. `settleExpired` can now withdraw at this timestamp.
2729         uint256 oldExpirationTimestamp = expirationTimestamp;
2730         expirationTimestamp = getCurrentTime();
2731         _requestOraclePrice(expirationTimestamp);
2732 
2733         emit EmergencyShutdown(msg.sender, oldExpirationTimestamp, expirationTimestamp);
2734     }
2735 
2736     /**
2737      * @notice Theoretically supposed to pay fees and move money between margin accounts to make sure they
2738      * reflect the NAV of the contract. However, this functionality doesn't apply to this contract.
2739      * @dev This is supposed to be implemented by any contract that inherits `AdministrateeInterface` and callable
2740      * only by the Governor contract. This method is therefore minimally implemented in this contract and does nothing.
2741      */
2742     function remargin() external override onlyPreExpiration() nonReentrant() {
2743         return;
2744     }
2745 
2746     /**
2747      * @notice Drains any excess balance of the provided ERC20 token to a pre-selected beneficiary.
2748      * @dev This will drain down to the amount of tracked collateral and drain the full balance of any other token.
2749      * @param token address of the ERC20 token whose excess balance should be drained.
2750      */
2751     function trimExcess(IERC20 token) external fees() nonReentrant() returns (FixedPoint.Unsigned memory amount) {
2752         FixedPoint.Unsigned memory balance = FixedPoint.Unsigned(token.balanceOf(address(this)));
2753 
2754         if (address(token) == address(collateralCurrency)) {
2755             // If it is the collateral currency, send only the amount that the contract is not tracking.
2756             // Note: this could be due to rounding error or balance-changing tokens, like aTokens.
2757             amount = balance.sub(_pfc());
2758         } else {
2759             // If it's not the collateral currency, send the entire balance.
2760             amount = balance;
2761         }
2762         token.safeTransfer(excessTokenBeneficiary, amount.rawValue);
2763     }
2764 
2765     /**
2766      * @notice Accessor method for a sponsor's collateral.
2767      * @dev This is necessary because the struct returned by the positions() method shows
2768      * rawCollateral, which isn't a user-readable value.
2769      * @param sponsor address whose collateral amount is retrieved.
2770      * @return collateralAmount amount of collateral within a sponsors position.
2771      */
2772     function getCollateral(address sponsor)
2773         external
2774         view
2775         nonReentrantView()
2776         returns (FixedPoint.Unsigned memory collateralAmount)
2777     {
2778         // Note: do a direct access to avoid the validity check.
2779         return _getFeeAdjustedCollateral(positions[sponsor].rawCollateral);
2780     }
2781 
2782     /**
2783      * @notice Accessor method for the total collateral stored within the PricelessPositionManager.
2784      * @return totalCollateral amount of all collateral within the Expiring Multi Party Contract.
2785      */
2786     function totalPositionCollateral()
2787         external
2788         view
2789         nonReentrantView()
2790         returns (FixedPoint.Unsigned memory totalCollateral)
2791     {
2792         return _getFeeAdjustedCollateral(rawTotalPositionCollateral);
2793     }
2794 
2795     /****************************************
2796      *          INTERNAL FUNCTIONS          *
2797      ****************************************/
2798 
2799     // Reduces a sponsor's position and global counters by the specified parameters. Handles deleting the entire
2800     // position if the entire position is being removed. Does not make any external transfers.
2801     function _reduceSponsorPosition(
2802         address sponsor,
2803         FixedPoint.Unsigned memory tokensToRemove,
2804         FixedPoint.Unsigned memory collateralToRemove,
2805         FixedPoint.Unsigned memory withdrawalAmountToRemove
2806     ) internal {
2807         PositionData storage positionData = _getPositionData(sponsor);
2808 
2809         // If the entire position is being removed, delete it instead.
2810         if (
2811             tokensToRemove.isEqual(positionData.tokensOutstanding) &&
2812             _getFeeAdjustedCollateral(positionData.rawCollateral).isEqual(collateralToRemove)
2813         ) {
2814             _deleteSponsorPosition(sponsor);
2815             return;
2816         }
2817 
2818         // Decrement the sponsor's collateral and global collateral amounts.
2819         _decrementCollateralBalances(positionData, collateralToRemove);
2820 
2821         // Ensure that the sponsor will meet the min position size after the reduction.
2822         FixedPoint.Unsigned memory newTokenCount = positionData.tokensOutstanding.sub(tokensToRemove);
2823         require(newTokenCount.isGreaterThanOrEqual(minSponsorTokens), "Below minimum sponsor position");
2824         positionData.tokensOutstanding = newTokenCount;
2825 
2826         // Decrement the position's withdrawal amount.
2827         positionData.withdrawalRequestAmount = positionData.withdrawalRequestAmount.sub(withdrawalAmountToRemove);
2828 
2829         // Decrement the total outstanding tokens in the overall contract.
2830         totalTokensOutstanding = totalTokensOutstanding.sub(tokensToRemove);
2831     }
2832 
2833     // Deletes a sponsor's position and updates global counters. Does not make any external transfers.
2834     function _deleteSponsorPosition(address sponsor) internal returns (FixedPoint.Unsigned memory) {
2835         PositionData storage positionToLiquidate = _getPositionData(sponsor);
2836 
2837         FixedPoint.Unsigned memory startingGlobalCollateral = _getFeeAdjustedCollateral(rawTotalPositionCollateral);
2838 
2839         // Remove the collateral and outstanding from the overall total position.
2840         FixedPoint.Unsigned memory remainingRawCollateral = positionToLiquidate.rawCollateral;
2841         rawTotalPositionCollateral = rawTotalPositionCollateral.sub(remainingRawCollateral);
2842         totalTokensOutstanding = totalTokensOutstanding.sub(positionToLiquidate.tokensOutstanding);
2843 
2844         // Reset the sponsors position to have zero outstanding and collateral.
2845         delete positions[sponsor];
2846 
2847         emit EndedSponsorPosition(sponsor);
2848 
2849         // Return fee-adjusted amount of collateral deleted from position.
2850         return startingGlobalCollateral.sub(_getFeeAdjustedCollateral(rawTotalPositionCollateral));
2851     }
2852 
2853     function _pfc() internal virtual override view returns (FixedPoint.Unsigned memory) {
2854         return _getFeeAdjustedCollateral(rawTotalPositionCollateral);
2855     }
2856 
2857     function _getPositionData(address sponsor)
2858         internal
2859         view
2860         onlyCollateralizedPosition(sponsor)
2861         returns (PositionData storage)
2862     {
2863         return positions[sponsor];
2864     }
2865 
2866     function _getIdentifierWhitelist() internal view returns (IdentifierWhitelistInterface) {
2867         return IdentifierWhitelistInterface(finder.getImplementationAddress(OracleInterfaces.IdentifierWhitelist));
2868     }
2869 
2870     function _getOracle() internal view returns (OracleInterface) {
2871         return OracleInterface(finder.getImplementationAddress(OracleInterfaces.Oracle));
2872     }
2873 
2874     function _getFinancialContractsAdminAddress() internal view returns (address) {
2875         return finder.getImplementationAddress(OracleInterfaces.FinancialContractsAdmin);
2876     }
2877 
2878     // Requests a price for `priceIdentifier` at `requestedTime` from the Oracle.
2879     function _requestOraclePrice(uint256 requestedTime) internal {
2880         OracleInterface oracle = _getOracle();
2881         oracle.requestPrice(priceIdentifier, requestedTime);
2882     }
2883 
2884     // Fetches a resolved Oracle price from the Oracle. Reverts if the Oracle hasn't resolved for this request.
2885     function _getOraclePrice(uint256 requestedTime) internal view returns (FixedPoint.Unsigned memory) {
2886         // Create an instance of the oracle and get the price. If the price is not resolved revert.
2887         OracleInterface oracle = _getOracle();
2888         require(oracle.hasPrice(priceIdentifier, requestedTime), "Unresolved oracle price");
2889         int256 oraclePrice = oracle.getPrice(priceIdentifier, requestedTime);
2890 
2891         // For now we don't want to deal with negative prices in positions.
2892         if (oraclePrice < 0) {
2893             oraclePrice = 0;
2894         }
2895         return FixedPoint.Unsigned(uint256(oraclePrice));
2896     }
2897 
2898     // Reset withdrawal request by setting the withdrawal request and withdrawal timestamp to 0.
2899     function _resetWithdrawalRequest(PositionData storage positionData) internal {
2900         positionData.withdrawalRequestAmount = FixedPoint.fromUnscaledUint(0);
2901         positionData.withdrawalRequestPassTimestamp = 0;
2902     }
2903 
2904     // Ensure individual and global consistency when increasing collateral balances. Returns the change to the position.
2905     function _incrementCollateralBalances(
2906         PositionData storage positionData,
2907         FixedPoint.Unsigned memory collateralAmount
2908     ) internal returns (FixedPoint.Unsigned memory) {
2909         _addCollateral(positionData.rawCollateral, collateralAmount);
2910         return _addCollateral(rawTotalPositionCollateral, collateralAmount);
2911     }
2912 
2913     // Ensure individual and global consistency when decrementing collateral balances. Returns the change to the
2914     // position. We elect to return the amount that the global collateral is decreased by, rather than the individual
2915     // position's collateral, because we need to maintain the invariant that the global collateral is always
2916     // <= the collateral owned by the contract to avoid reverts on withdrawals. The amount returned = amount withdrawn.
2917     function _decrementCollateralBalances(
2918         PositionData storage positionData,
2919         FixedPoint.Unsigned memory collateralAmount
2920     ) internal returns (FixedPoint.Unsigned memory) {
2921         _removeCollateral(positionData.rawCollateral, collateralAmount);
2922         return _removeCollateral(rawTotalPositionCollateral, collateralAmount);
2923     }
2924 
2925     // Ensure individual and global consistency when decrementing collateral balances. Returns the change to the position.
2926     // This function is similar to the _decrementCollateralBalances function except this function checks position GCR
2927     // between the decrements. This ensures that collateral removal will not leave the position undercollateralized.
2928     function _decrementCollateralBalancesCheckGCR(
2929         PositionData storage positionData,
2930         FixedPoint.Unsigned memory collateralAmount
2931     ) internal returns (FixedPoint.Unsigned memory) {
2932         _removeCollateral(positionData.rawCollateral, collateralAmount);
2933         require(_checkPositionCollateralization(positionData), "CR below GCR");
2934         return _removeCollateral(rawTotalPositionCollateral, collateralAmount);
2935     }
2936 
2937     // These internal functions are supposed to act identically to modifiers, but re-used modifiers
2938     // unnecessarily increase contract bytecode size.
2939     // source: https://blog.polymath.network/solidity-tips-and-tricks-to-save-gas-and-reduce-bytecode-size-c44580b218e6
2940     function _onlyOpenState() internal view {
2941         require(contractState == ContractState.Open, "Contract state is not OPEN");
2942     }
2943 
2944     function _onlyPreExpiration() internal view {
2945         require(getCurrentTime() < expirationTimestamp, "Only callable pre-expiry");
2946     }
2947 
2948     function _onlyPostExpiration() internal view {
2949         require(getCurrentTime() >= expirationTimestamp, "Only callable post-expiry");
2950     }
2951 
2952     function _onlyCollateralizedPosition(address sponsor) internal view {
2953         require(
2954             _getFeeAdjustedCollateral(positions[sponsor].rawCollateral).isGreaterThan(0),
2955             "Position has no collateral"
2956         );
2957     }
2958 
2959     // Note: This checks whether an already existing position has a pending withdrawal. This cannot be used on the
2960     // `create` method because it is possible that `create` is called on a new position (i.e. one without any collateral
2961     // or tokens outstanding) which would fail the `onlyCollateralizedPosition` modifier on `_getPositionData`.
2962     function _positionHasNoPendingWithdrawal(address sponsor) internal view {
2963         require(_getPositionData(sponsor).withdrawalRequestPassTimestamp == 0, "Pending withdrawal");
2964     }
2965 
2966     /****************************************
2967      *          PRIVATE FUNCTIONS          *
2968      ****************************************/
2969 
2970     function _checkPositionCollateralization(PositionData storage positionData) private view returns (bool) {
2971         return
2972             _checkCollateralization(
2973                 _getFeeAdjustedCollateral(positionData.rawCollateral),
2974                 positionData.tokensOutstanding
2975             );
2976     }
2977 
2978     // Checks whether the provided `collateral` and `numTokens` have a collateralization ratio above the global
2979     // collateralization ratio.
2980     function _checkCollateralization(FixedPoint.Unsigned memory collateral, FixedPoint.Unsigned memory numTokens)
2981         private
2982         view
2983         returns (bool)
2984     {
2985         FixedPoint.Unsigned memory global = _getCollateralizationRatio(
2986             _getFeeAdjustedCollateral(rawTotalPositionCollateral),
2987             totalTokensOutstanding
2988         );
2989         FixedPoint.Unsigned memory thisChange = _getCollateralizationRatio(collateral, numTokens);
2990         return !global.isGreaterThan(thisChange);
2991     }
2992 
2993     function _getCollateralizationRatio(FixedPoint.Unsigned memory collateral, FixedPoint.Unsigned memory numTokens)
2994         private
2995         pure
2996         returns (FixedPoint.Unsigned memory ratio)
2997     {
2998         if (!numTokens.isGreaterThan(0)) {
2999             return FixedPoint.fromUnscaledUint(0);
3000         } else {
3001             return collateral.div(numTokens);
3002         }
3003     }
3004 }
3005 
3006 // File: contracts/financial-templates/expiring-multiparty/Liquidatable.sol
3007 
3008 pragma solidity ^0.6.0;
3009 
3010 
3011 
3012 
3013 
3014 
3015 /**
3016  * @title Liquidatable
3017  * @notice Adds logic to a position-managing contract that enables callers to liquidate an undercollateralized position.
3018  * @dev The liquidation has a liveness period before expiring successfully, during which someone can "dispute" the
3019  * liquidation, which sends a price request to the relevant Oracle to settle the final collateralization ratio based on
3020  * a DVM price. The contract enforces dispute rewards in order to incentivize disputers to correctly dispute false
3021  * liquidations and compensate position sponsors who had their position incorrectly liquidated. Importantly, a
3022  * prospective disputer must deposit a dispute bond that they can lose in the case of an unsuccessful dispute.
3023  */
3024 contract Liquidatable is PricelessPositionManager {
3025     using FixedPoint for FixedPoint.Unsigned;
3026     using SafeMath for uint256;
3027     using SafeERC20 for IERC20;
3028 
3029     /****************************************
3030      *     LIQUIDATION DATA STRUCTURES      *
3031      ****************************************/
3032 
3033     // Because of the check in withdrawable(), the order of these enum values should not change.
3034     enum Status { Uninitialized, PreDispute, PendingDispute, DisputeSucceeded, DisputeFailed }
3035 
3036     struct LiquidationData {
3037         // Following variables set upon creation of liquidation:
3038         address sponsor; // Address of the liquidated position's sponsor
3039         address liquidator; // Address who created this liquidation
3040         Status state; // Liquidated (and expired or not), Pending a Dispute, or Dispute has resolved
3041         uint256 liquidationTime; // Time when liquidation is initiated, needed to get price from Oracle
3042         // Following variables determined by the position that is being liquidated:
3043         FixedPoint.Unsigned tokensOutstanding; // Synthetic tokens required to be burned by liquidator to initiate dispute
3044         FixedPoint.Unsigned lockedCollateral; // Collateral locked by contract and released upon expiry or post-dispute
3045         // Amount of collateral being liquidated, which could be different from
3046         // lockedCollateral if there were pending withdrawals at the time of liquidation
3047         FixedPoint.Unsigned liquidatedCollateral;
3048         // Unit value (starts at 1) that is used to track the fees per unit of collateral over the course of the liquidation.
3049         FixedPoint.Unsigned rawUnitCollateral;
3050         // Following variable set upon initiation of a dispute:
3051         address disputer; // Person who is disputing a liquidation
3052         // Following variable set upon a resolution of a dispute:
3053         FixedPoint.Unsigned settlementPrice; // Final price as determined by an Oracle following a dispute
3054         FixedPoint.Unsigned finalFee;
3055     }
3056 
3057     // Define the contract's constructor parameters as a struct to enable more variables to be specified.
3058     // This is required to enable more params, over and above Solidity's limits.
3059     struct ConstructorParams {
3060         // Params for PricelessPositionManager only.
3061         uint256 expirationTimestamp;
3062         uint256 withdrawalLiveness;
3063         address collateralAddress;
3064         address finderAddress;
3065         address tokenFactoryAddress;
3066         address timerAddress;
3067         address excessTokenBeneficiary;
3068         bytes32 priceFeedIdentifier;
3069         string syntheticName;
3070         string syntheticSymbol;
3071         FixedPoint.Unsigned minSponsorTokens;
3072         // Params specifically for Liquidatable.
3073         uint256 liquidationLiveness;
3074         FixedPoint.Unsigned collateralRequirement;
3075         FixedPoint.Unsigned disputeBondPct;
3076         FixedPoint.Unsigned sponsorDisputeRewardPct;
3077         FixedPoint.Unsigned disputerDisputeRewardPct;
3078     }
3079 
3080     // Liquidations are unique by ID per sponsor
3081     mapping(address => LiquidationData[]) public liquidations;
3082 
3083     // Total collateral in liquidation.
3084     FixedPoint.Unsigned public rawLiquidationCollateral;
3085 
3086     // Immutable contract parameters:
3087     // Amount of time for pending liquidation before expiry.
3088     // !!Note: The lower the liquidation liveness value, the more risk incurred by sponsors.
3089     //       Extremely low liveness values increase the chance that opportunistic invalid liquidations
3090     //       expire without dispute, thereby decreasing the usability for sponsors and increasing the risk
3091     //       for the contract as a whole. An insolvent contract is extremely risky for any sponsor or synthetic
3092     //       token holder for the contract.
3093     uint256 public liquidationLiveness;
3094     // Required collateral:TRV ratio for a position to be considered sufficiently collateralized.
3095     FixedPoint.Unsigned public collateralRequirement;
3096     // Percent of a Liquidation/Position's lockedCollateral to be deposited by a potential disputer
3097     // Represented as a multiplier, for example 1.5e18 = "150%" and 0.05e18 = "5%"
3098     FixedPoint.Unsigned public disputeBondPct;
3099     // Percent of oraclePrice paid to sponsor in the Disputed state (i.e. following a successful dispute)
3100     // Represented as a multiplier, see above.
3101     FixedPoint.Unsigned public sponsorDisputeRewardPct;
3102     // Percent of oraclePrice paid to disputer in the Disputed state (i.e. following a successful dispute)
3103     // Represented as a multiplier, see above.
3104     FixedPoint.Unsigned public disputerDisputeRewardPct;
3105 
3106     /****************************************
3107      *                EVENTS                *
3108      ****************************************/
3109 
3110     event LiquidationCreated(
3111         address indexed sponsor,
3112         address indexed liquidator,
3113         uint256 indexed liquidationId,
3114         uint256 tokensOutstanding,
3115         uint256 lockedCollateral,
3116         uint256 liquidatedCollateral,
3117         uint256 liquidationTime
3118     );
3119     event LiquidationDisputed(
3120         address indexed sponsor,
3121         address indexed liquidator,
3122         address indexed disputer,
3123         uint256 liquidationId,
3124         uint256 disputeBondAmount
3125     );
3126     event DisputeSettled(
3127         address indexed caller,
3128         address indexed sponsor,
3129         address indexed liquidator,
3130         address disputer,
3131         uint256 liquidationId,
3132         bool disputeSucceeded
3133     );
3134     event LiquidationWithdrawn(
3135         address indexed caller,
3136         uint256 withdrawalAmount,
3137         Status indexed liquidationStatus,
3138         uint256 settlementPrice
3139     );
3140 
3141     /****************************************
3142      *              MODIFIERS               *
3143      ****************************************/
3144 
3145     modifier disputable(uint256 liquidationId, address sponsor) {
3146         _disputable(liquidationId, sponsor);
3147         _;
3148     }
3149 
3150     modifier withdrawable(uint256 liquidationId, address sponsor) {
3151         _withdrawable(liquidationId, sponsor);
3152         _;
3153     }
3154 
3155     /**
3156      * @notice Constructs the liquidatable contract.
3157      * @param params struct to define input parameters for construction of Liquidatable. Some params
3158      * are fed directly into the PricelessPositionManager's constructor within the inheritance tree.
3159      */
3160     constructor(ConstructorParams memory params)
3161         public
3162         PricelessPositionManager(
3163             params.expirationTimestamp,
3164             params.withdrawalLiveness,
3165             params.collateralAddress,
3166             params.finderAddress,
3167             params.priceFeedIdentifier,
3168             params.syntheticName,
3169             params.syntheticSymbol,
3170             params.tokenFactoryAddress,
3171             params.minSponsorTokens,
3172             params.timerAddress,
3173             params.excessTokenBeneficiary
3174         )
3175         nonReentrant()
3176     {
3177         require(params.collateralRequirement.isGreaterThan(1), "CR is more than 100%");
3178         require(
3179             params.sponsorDisputeRewardPct.add(params.disputerDisputeRewardPct).isLessThan(1),
3180             "Rewards are more than 100%"
3181         );
3182 
3183         // Set liquidatable specific variables.
3184         liquidationLiveness = params.liquidationLiveness;
3185         collateralRequirement = params.collateralRequirement;
3186         disputeBondPct = params.disputeBondPct;
3187         sponsorDisputeRewardPct = params.sponsorDisputeRewardPct;
3188         disputerDisputeRewardPct = params.disputerDisputeRewardPct;
3189     }
3190 
3191     /****************************************
3192      *        LIQUIDATION FUNCTIONS         *
3193      ****************************************/
3194 
3195     /**
3196      * @notice Liquidates the sponsor's position if the caller has enough
3197      * synthetic tokens to retire the position's outstanding tokens. Liquidations above
3198      * a minimum size also reset an ongoing "slow withdrawal"'s liveness.
3199      * @dev This method generates an ID that will uniquely identify liquidation for the sponsor. This contract must be
3200      * approved to spend at least `tokensLiquidated` of `tokenCurrency` and at least `finalFeeBond` of `collateralCurrency`.
3201      * @param sponsor address of the sponsor to liquidate.
3202      * @param minCollateralPerToken abort the liquidation if the position's collateral per token is below this value.
3203      * @param maxCollateralPerToken abort the liquidation if the position's collateral per token exceeds this value.
3204      * @param maxTokensToLiquidate max number of tokens to liquidate.
3205      * @param deadline abort the liquidation if the transaction is mined after this timestamp.
3206      * @return liquidationId ID of the newly created liquidation.
3207      * @return tokensLiquidated amount of synthetic tokens removed and liquidated from the `sponsor`'s position.
3208      * @return finalFeeBond amount of collateral to be posted by liquidator and returned if not disputed successfully.
3209      */
3210     function createLiquidation(
3211         address sponsor,
3212         FixedPoint.Unsigned calldata minCollateralPerToken,
3213         FixedPoint.Unsigned calldata maxCollateralPerToken,
3214         FixedPoint.Unsigned calldata maxTokensToLiquidate,
3215         uint256 deadline
3216     )
3217         external
3218         fees()
3219         onlyPreExpiration()
3220         nonReentrant()
3221         returns (
3222             uint256 liquidationId,
3223             FixedPoint.Unsigned memory tokensLiquidated,
3224             FixedPoint.Unsigned memory finalFeeBond
3225         )
3226     {
3227         // Check that this transaction was mined pre-deadline.
3228         require(getCurrentTime() <= deadline, "Mined after deadline");
3229 
3230         // Retrieve Position data for sponsor
3231         PositionData storage positionToLiquidate = _getPositionData(sponsor);
3232 
3233         tokensLiquidated = FixedPoint.min(maxTokensToLiquidate, positionToLiquidate.tokensOutstanding);
3234 
3235         // Starting values for the Position being liquidated. If withdrawal request amount is > position's collateral,
3236         // then set this to 0, otherwise set it to (startCollateral - withdrawal request amount).
3237         FixedPoint.Unsigned memory startCollateral = _getFeeAdjustedCollateral(positionToLiquidate.rawCollateral);
3238         FixedPoint.Unsigned memory startCollateralNetOfWithdrawal = FixedPoint.fromUnscaledUint(0);
3239         if (positionToLiquidate.withdrawalRequestAmount.isLessThanOrEqual(startCollateral)) {
3240             startCollateralNetOfWithdrawal = startCollateral.sub(positionToLiquidate.withdrawalRequestAmount);
3241         }
3242 
3243         // Scoping to get rid of a stack too deep error.
3244         {
3245             FixedPoint.Unsigned memory startTokens = positionToLiquidate.tokensOutstanding;
3246 
3247             // The Position's collateralization ratio must be between [minCollateralPerToken, maxCollateralPerToken].
3248             // maxCollateralPerToken >= startCollateralNetOfWithdrawal / startTokens.
3249             require(
3250                 maxCollateralPerToken.mul(startTokens).isGreaterThanOrEqual(startCollateralNetOfWithdrawal),
3251                 "CR is more than max liq. price"
3252             );
3253             // minCollateralPerToken >= startCollateralNetOfWithdrawal / startTokens.
3254             require(
3255                 minCollateralPerToken.mul(startTokens).isLessThanOrEqual(startCollateralNetOfWithdrawal),
3256                 "CR is less than min liq. price"
3257             );
3258         }
3259 
3260         // Compute final fee at time of liquidation.
3261         finalFeeBond = _computeFinalFees();
3262 
3263         // These will be populated within the scope below.
3264         FixedPoint.Unsigned memory lockedCollateral;
3265         FixedPoint.Unsigned memory liquidatedCollateral;
3266 
3267         // Scoping to get rid of a stack too deep error.
3268         {
3269             FixedPoint.Unsigned memory ratio = tokensLiquidated.div(positionToLiquidate.tokensOutstanding);
3270 
3271             // The actual amount of collateral that gets moved to the liquidation.
3272             lockedCollateral = startCollateral.mul(ratio);
3273 
3274             // For purposes of disputes, it's actually this liquidatedCollateral value that's used. This value is net of
3275             // withdrawal requests.
3276             liquidatedCollateral = startCollateralNetOfWithdrawal.mul(ratio);
3277 
3278             // Part of the withdrawal request is also removed. Ideally:
3279             // liquidatedCollateral + withdrawalAmountToRemove = lockedCollateral.
3280             FixedPoint.Unsigned memory withdrawalAmountToRemove = positionToLiquidate.withdrawalRequestAmount.mul(
3281                 ratio
3282             );
3283             _reduceSponsorPosition(sponsor, tokensLiquidated, lockedCollateral, withdrawalAmountToRemove);
3284         }
3285 
3286         // Add to the global liquidation collateral count.
3287         _addCollateral(rawLiquidationCollateral, lockedCollateral.add(finalFeeBond));
3288 
3289         // Construct liquidation object.
3290         // Note: All dispute-related values are zeroed out until a dispute occurs. liquidationId is the index of the new
3291         // LiquidationData that is pushed into the array, which is equal to the current length of the array pre-push.
3292         liquidationId = liquidations[sponsor].length;
3293         liquidations[sponsor].push(
3294             LiquidationData({
3295                 sponsor: sponsor,
3296                 liquidator: msg.sender,
3297                 state: Status.PreDispute,
3298                 liquidationTime: getCurrentTime(),
3299                 tokensOutstanding: tokensLiquidated,
3300                 lockedCollateral: lockedCollateral,
3301                 liquidatedCollateral: liquidatedCollateral,
3302                 rawUnitCollateral: _convertToRawCollateral(FixedPoint.fromUnscaledUint(1)),
3303                 disputer: address(0),
3304                 settlementPrice: FixedPoint.fromUnscaledUint(0),
3305                 finalFee: finalFeeBond
3306             })
3307         );
3308 
3309         // If this liquidation is a subsequent liquidation on the position, and the liquidation size is larger than
3310         // some "griefing threshold", then re-set the liveness. This enables a liquidation against a withdraw request to be
3311         // "dragged out" if the position is very large and liquidators need time to gather funds. The griefing threshold
3312         // is enforced so that liquidations for trivially small # of tokens cannot drag out an honest sponsor's slow withdrawal.
3313 
3314         // We arbitrarily set the "griefing threshold" to `minSponsorTokens` because it is the only parameter
3315         // denominated in token currency units and we can avoid adding another parameter.
3316         FixedPoint.Unsigned memory griefingThreshold = minSponsorTokens;
3317         if (
3318             positionToLiquidate.withdrawalRequestPassTimestamp > 0 && // The position is undergoing a slow withdrawal.
3319             positionToLiquidate.withdrawalRequestPassTimestamp <= getCurrentTime() && // The slow withdrawal has not yet expired.
3320             tokensLiquidated.isGreaterThanOrEqual(griefingThreshold) // The liquidated token count is above a "griefing threshold".
3321         ) {
3322             positionToLiquidate.withdrawalRequestPassTimestamp = getCurrentTime().add(liquidationLiveness);
3323         }
3324 
3325         emit LiquidationCreated(
3326             sponsor,
3327             msg.sender,
3328             liquidationId,
3329             tokensLiquidated.rawValue,
3330             lockedCollateral.rawValue,
3331             liquidatedCollateral.rawValue,
3332             getCurrentTime()
3333         );
3334 
3335         // Destroy tokens
3336         tokenCurrency.safeTransferFrom(msg.sender, address(this), tokensLiquidated.rawValue);
3337         tokenCurrency.burn(tokensLiquidated.rawValue);
3338 
3339         // Pull final fee from liquidator.
3340         collateralCurrency.safeTransferFrom(msg.sender, address(this), finalFeeBond.rawValue);
3341     }
3342 
3343     /**
3344      * @notice Disputes a liquidation, if the caller has enough collateral to post a dispute bond
3345      * and pay a fixed final fee charged on each price request.
3346      * @dev Can only dispute a liquidation before the liquidation expires and if there are no other pending disputes.
3347      * This contract must be approved to spend at least the dispute bond amount of `collateralCurrency`. This dispute
3348      * bond amount is calculated from `disputeBondPct` times the collateral in the liquidation.
3349      * @param liquidationId of the disputed liquidation.
3350      * @param sponsor the address of the sponsor whose liquidation is being disputed.
3351      * @return totalPaid amount of collateral charged to disputer (i.e. final fee bond + dispute bond).
3352      */
3353     function dispute(uint256 liquidationId, address sponsor)
3354         external
3355         disputable(liquidationId, sponsor)
3356         fees()
3357         nonReentrant()
3358         returns (FixedPoint.Unsigned memory totalPaid)
3359     {
3360         LiquidationData storage disputedLiquidation = _getLiquidationData(sponsor, liquidationId);
3361 
3362         // Multiply by the unit collateral so the dispute bond is a percentage of the locked collateral after fees.
3363         FixedPoint.Unsigned memory disputeBondAmount = disputedLiquidation.lockedCollateral.mul(disputeBondPct).mul(
3364             _getFeeAdjustedCollateral(disputedLiquidation.rawUnitCollateral)
3365         );
3366         _addCollateral(rawLiquidationCollateral, disputeBondAmount);
3367 
3368         // Request a price from DVM. Liquidation is pending dispute until DVM returns a price.
3369         disputedLiquidation.state = Status.PendingDispute;
3370         disputedLiquidation.disputer = msg.sender;
3371 
3372         // Enqueue a request with the DVM.
3373         _requestOraclePrice(disputedLiquidation.liquidationTime);
3374 
3375         emit LiquidationDisputed(
3376             sponsor,
3377             disputedLiquidation.liquidator,
3378             msg.sender,
3379             liquidationId,
3380             disputeBondAmount.rawValue
3381         );
3382         totalPaid = disputeBondAmount.add(disputedLiquidation.finalFee);
3383 
3384         // Pay the final fee for requesting price from the DVM.
3385         _payFinalFees(msg.sender, disputedLiquidation.finalFee);
3386 
3387         // Transfer the dispute bond amount from the caller to this contract.
3388         collateralCurrency.safeTransferFrom(msg.sender, address(this), disputeBondAmount.rawValue);
3389     }
3390 
3391     /**
3392      * @notice After a dispute has settled or after a non-disputed liquidation has expired,
3393      * the sponsor, liquidator, and/or disputer can call this method to receive payments.
3394      * @dev If the dispute SUCCEEDED: the sponsor, liquidator, and disputer are eligible for payment.
3395      * If the dispute FAILED: only the liquidator can receive payment.
3396      * Once all collateral is withdrawn, delete the liquidation data.
3397      * @param liquidationId uniquely identifies the sponsor's liquidation.
3398      * @param sponsor address of the sponsor associated with the liquidation.
3399      * @return amountWithdrawn the total amount of underlying returned from the liquidation.
3400      */
3401     function withdrawLiquidation(uint256 liquidationId, address sponsor)
3402         public
3403         withdrawable(liquidationId, sponsor)
3404         fees()
3405         nonReentrant()
3406         returns (FixedPoint.Unsigned memory amountWithdrawn)
3407     {
3408         LiquidationData storage liquidation = _getLiquidationData(sponsor, liquidationId);
3409         require(
3410             (msg.sender == liquidation.disputer) ||
3411                 (msg.sender == liquidation.liquidator) ||
3412                 (msg.sender == liquidation.sponsor),
3413             "Caller cannot withdraw rewards"
3414         );
3415 
3416         // Settles the liquidation if necessary. This call will revert if the price has not resolved yet.
3417         _settle(liquidationId, sponsor);
3418 
3419         // Calculate rewards as a function of the TRV.
3420         // Note: all payouts are scaled by the unit collateral value so all payouts are charged the fees pro rata.
3421         FixedPoint.Unsigned memory feeAttenuation = _getFeeAdjustedCollateral(liquidation.rawUnitCollateral);
3422         FixedPoint.Unsigned memory settlementPrice = liquidation.settlementPrice;
3423         FixedPoint.Unsigned memory tokenRedemptionValue = liquidation.tokensOutstanding.mul(settlementPrice).mul(
3424             feeAttenuation
3425         );
3426         FixedPoint.Unsigned memory collateral = liquidation.lockedCollateral.mul(feeAttenuation);
3427         FixedPoint.Unsigned memory disputerDisputeReward = disputerDisputeRewardPct.mul(tokenRedemptionValue);
3428         FixedPoint.Unsigned memory sponsorDisputeReward = sponsorDisputeRewardPct.mul(tokenRedemptionValue);
3429         FixedPoint.Unsigned memory disputeBondAmount = collateral.mul(disputeBondPct);
3430         FixedPoint.Unsigned memory finalFee = liquidation.finalFee.mul(feeAttenuation);
3431 
3432         // There are three main outcome states: either the dispute succeeded, failed or was not updated.
3433         // Based on the state, different parties of a liquidation can withdraw different amounts.
3434         // Once a caller has been paid their address deleted from the struct.
3435         // This prevents them from being paid multiple from times the same liquidation.
3436         FixedPoint.Unsigned memory withdrawalAmount = FixedPoint.fromUnscaledUint(0);
3437         if (liquidation.state == Status.DisputeSucceeded) {
3438             // If the dispute is successful then all three users can withdraw from the contract.
3439             if (msg.sender == liquidation.disputer) {
3440                 // Pay DISPUTER: disputer reward + dispute bond + returned final fee
3441                 FixedPoint.Unsigned memory payToDisputer = disputerDisputeReward.add(disputeBondAmount).add(finalFee);
3442                 withdrawalAmount = withdrawalAmount.add(payToDisputer);
3443                 delete liquidation.disputer;
3444             }
3445 
3446             if (msg.sender == liquidation.sponsor) {
3447                 // Pay SPONSOR: remaining collateral (collateral - TRV) + sponsor reward
3448                 FixedPoint.Unsigned memory remainingCollateral = collateral.sub(tokenRedemptionValue);
3449                 FixedPoint.Unsigned memory payToSponsor = sponsorDisputeReward.add(remainingCollateral);
3450                 withdrawalAmount = withdrawalAmount.add(payToSponsor);
3451                 delete liquidation.sponsor;
3452             }
3453 
3454             if (msg.sender == liquidation.liquidator) {
3455                 // Pay LIQUIDATOR: TRV - dispute reward - sponsor reward
3456                 // If TRV > Collateral, then subtract rewards from collateral
3457                 // NOTE: This should never be below zero since we prevent (sponsorDisputePct+disputerDisputePct) >= 0 in
3458                 // the constructor when these params are set.
3459                 FixedPoint.Unsigned memory payToLiquidator = tokenRedemptionValue.sub(sponsorDisputeReward).sub(
3460                     disputerDisputeReward
3461                 );
3462                 withdrawalAmount = withdrawalAmount.add(payToLiquidator);
3463                 delete liquidation.liquidator;
3464             }
3465 
3466             // Free up space once all collateral is withdrawn by removing the liquidation object from the array.
3467             if (
3468                 liquidation.disputer == address(0) &&
3469                 liquidation.sponsor == address(0) &&
3470                 liquidation.liquidator == address(0)
3471             ) {
3472                 delete liquidations[sponsor][liquidationId];
3473             }
3474             // In the case of a failed dispute only the liquidator can withdraw.
3475         } else if (liquidation.state == Status.DisputeFailed && msg.sender == liquidation.liquidator) {
3476             // Pay LIQUIDATOR: collateral + dispute bond + returned final fee
3477             withdrawalAmount = collateral.add(disputeBondAmount).add(finalFee);
3478             delete liquidations[sponsor][liquidationId];
3479             // If the state is pre-dispute but time has passed liveness then there was no dispute. We represent this
3480             // state as a dispute failed and the liquidator can withdraw.
3481         } else if (liquidation.state == Status.PreDispute && msg.sender == liquidation.liquidator) {
3482             // Pay LIQUIDATOR: collateral + returned final fee
3483             withdrawalAmount = collateral.add(finalFee);
3484             delete liquidations[sponsor][liquidationId];
3485         }
3486         require(withdrawalAmount.isGreaterThan(0), "Invalid withdrawal amount");
3487 
3488         // Decrease the total collateral held in liquidatable by the amount withdrawn.
3489         amountWithdrawn = _removeCollateral(rawLiquidationCollateral, withdrawalAmount);
3490 
3491         emit LiquidationWithdrawn(msg.sender, amountWithdrawn.rawValue, liquidation.state, settlementPrice.rawValue);
3492 
3493         // Transfer amount withdrawn from this contract to the caller.
3494         collateralCurrency.safeTransfer(msg.sender, amountWithdrawn.rawValue);
3495 
3496         return amountWithdrawn;
3497     }
3498 
3499     /**
3500      * @notice Gets all liquidation information for a given sponsor address.
3501      * @param sponsor address of the position sponsor.
3502      * @return liquidationData array of all liquidation information for the given sponsor address.
3503      */
3504     function getLiquidations(address sponsor)
3505         external
3506         view
3507         nonReentrantView()
3508         returns (LiquidationData[] memory liquidationData)
3509     {
3510         return liquidations[sponsor];
3511     }
3512 
3513     /****************************************
3514      *          INTERNAL FUNCTIONS          *
3515      ****************************************/
3516 
3517     // This settles a liquidation if it is in the PendingDispute state. If not, it will immediately return.
3518     // If the liquidation is in the PendingDispute state, but a price is not available, this will revert.
3519     function _settle(uint256 liquidationId, address sponsor) internal {
3520         LiquidationData storage liquidation = _getLiquidationData(sponsor, liquidationId);
3521 
3522         // Settlement only happens when state == PendingDispute and will only happen once per liquidation.
3523         // If this liquidation is not ready to be settled, this method should return immediately.
3524         if (liquidation.state != Status.PendingDispute) {
3525             return;
3526         }
3527 
3528         // Get the returned price from the oracle. If this has not yet resolved will revert.
3529         liquidation.settlementPrice = _getOraclePrice(liquidation.liquidationTime);
3530 
3531         // Find the value of the tokens in the underlying collateral.
3532         FixedPoint.Unsigned memory tokenRedemptionValue = liquidation.tokensOutstanding.mul(
3533             liquidation.settlementPrice
3534         );
3535 
3536         // The required collateral is the value of the tokens in underlying * required collateral ratio.
3537         FixedPoint.Unsigned memory requiredCollateral = tokenRedemptionValue.mul(collateralRequirement);
3538 
3539         // If the position has more than the required collateral it is solvent and the dispute is valid(liquidation is invalid)
3540         // Note that this check uses the liquidatedCollateral not the lockedCollateral as this considers withdrawals.
3541         bool disputeSucceeded = liquidation.liquidatedCollateral.isGreaterThanOrEqual(requiredCollateral);
3542         liquidation.state = disputeSucceeded ? Status.DisputeSucceeded : Status.DisputeFailed;
3543 
3544         emit DisputeSettled(
3545             msg.sender,
3546             sponsor,
3547             liquidation.liquidator,
3548             liquidation.disputer,
3549             liquidationId,
3550             disputeSucceeded
3551         );
3552     }
3553 
3554     function _pfc() internal override view returns (FixedPoint.Unsigned memory) {
3555         return super._pfc().add(_getFeeAdjustedCollateral(rawLiquidationCollateral));
3556     }
3557 
3558     function _getLiquidationData(address sponsor, uint256 liquidationId)
3559         internal
3560         view
3561         returns (LiquidationData storage liquidation)
3562     {
3563         LiquidationData[] storage liquidationArray = liquidations[sponsor];
3564 
3565         // Revert if the caller is attempting to access an invalid liquidation
3566         // (one that has never been created or one has never been initialized).
3567         require(
3568             liquidationId < liquidationArray.length && liquidationArray[liquidationId].state != Status.Uninitialized,
3569             "Invalid liquidation ID"
3570         );
3571         return liquidationArray[liquidationId];
3572     }
3573 
3574     function _getLiquidationExpiry(LiquidationData storage liquidation) internal view returns (uint256) {
3575         return liquidation.liquidationTime.add(liquidationLiveness);
3576     }
3577 
3578     // These internal functions are supposed to act identically to modifiers, but re-used modifiers
3579     // unnecessarily increase contract bytecode size.
3580     // source: https://blog.polymath.network/solidity-tips-and-tricks-to-save-gas-and-reduce-bytecode-size-c44580b218e6
3581     function _disputable(uint256 liquidationId, address sponsor) internal view {
3582         LiquidationData storage liquidation = _getLiquidationData(sponsor, liquidationId);
3583         require(
3584             (getCurrentTime() < _getLiquidationExpiry(liquidation)) && (liquidation.state == Status.PreDispute),
3585             "Liquidation not disputable"
3586         );
3587     }
3588 
3589     function _withdrawable(uint256 liquidationId, address sponsor) internal view {
3590         LiquidationData storage liquidation = _getLiquidationData(sponsor, liquidationId);
3591         Status state = liquidation.state;
3592 
3593         // Must be disputed or the liquidation has passed expiry.
3594         require(
3595             (state > Status.PreDispute) ||
3596                 ((_getLiquidationExpiry(liquidation) <= getCurrentTime()) && (state == Status.PreDispute)),
3597             "Liquidation not withdrawable"
3598         );
3599     }
3600 }
3601 
3602 // File: contracts/financial-templates/expiring-multiparty/ExpiringMultiParty.sol
3603 
3604 pragma solidity ^0.6.0;
3605 
3606 
3607 
3608 /**
3609  * @title Expiring Multi Party.
3610  * @notice Convenient wrapper for Liquidatable.
3611  */
3612 contract ExpiringMultiParty is Liquidatable {
3613     /**
3614      * @notice Constructs the ExpiringMultiParty contract.
3615      * @param params struct to define input parameters for construction of Liquidatable. Some params
3616      * are fed directly into the PricelessPositionManager's constructor within the inheritance tree.
3617      */
3618     constructor(ConstructorParams memory params)
3619         public
3620         Liquidatable(params)
3621     // Note: since there is no logic here, there is no need to add a re-entrancy guard.
3622     {
3623 
3624     }
3625 }