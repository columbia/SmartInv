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
811 pragma experimental ABIEncoderV2;
812 
813 
814 /**
815  * @title Interface for whitelists of supported identifiers that the oracle can provide prices for.
816  */
817 interface IdentifierWhitelistInterface {
818     /**
819      * @notice Adds the provided identifier as a supported identifier.
820      * @dev Price requests using this identifier will succeed after this call.
821      * @param identifier bytes32 encoding of the string identifier. Eg: BTC/USD.
822      */
823     function addSupportedIdentifier(bytes32 identifier) external;
824 
825     /**
826      * @notice Removes the identifier from the whitelist.
827      * @dev Price requests using this identifier will no longer succeed after this call.
828      * @param identifier bytes32 encoding of the string identifier. Eg: BTC/USD.
829      */
830     function removeSupportedIdentifier(bytes32 identifier) external;
831 
832     /**
833      * @notice Checks whether an identifier is on the whitelist.
834      * @param identifier bytes32 encoding of the string identifier. Eg: BTC/USD.
835      * @return bool if the identifier is supported (or not).
836      */
837     function isIdentifierSupported(bytes32 identifier) external view returns (bool);
838 }
839 
840 // File: contracts/oracle/interfaces/AdministrateeInterface.sol
841 
842 pragma solidity ^0.6.0;
843 
844 
845 /**
846  * @title Interface that all financial contracts expose to the admin.
847  */
848 interface AdministrateeInterface {
849     /**
850      * @notice Initiates the shutdown process, in case of an emergency.
851      */
852     function emergencyShutdown() external;
853 
854     /**
855      * @notice A core contract method called independently or as a part of other financial contract transactions.
856      * @dev It pays fees and moves money between margin accounts to make sure they reflect the NAV of the contract.
857      */
858     function remargin() external;
859 }
860 
861 // File: contracts/oracle/implementation/Constants.sol
862 
863 pragma solidity ^0.6.0;
864 
865 
866 /**
867  * @title Stores common interface names used throughout the DVM by registration in the Finder.
868  */
869 library OracleInterfaces {
870     bytes32 public constant Oracle = "Oracle";
871     bytes32 public constant IdentifierWhitelist = "IdentifierWhitelist";
872     bytes32 public constant Store = "Store";
873     bytes32 public constant FinancialContractsAdmin = "FinancialContractsAdmin";
874     bytes32 public constant Registry = "Registry";
875     bytes32 public constant CollateralWhitelist = "CollateralWhitelist";
876 }
877 
878 // File: @openzeppelin/contracts/GSN/Context.sol
879 
880 pragma solidity ^0.6.0;
881 
882 /*
883  * @dev Provides information about the current execution context, including the
884  * sender of the transaction and its data. While these are generally available
885  * via msg.sender and msg.data, they should not be accessed in such a direct
886  * manner, since when dealing with GSN meta-transactions the account sending and
887  * paying for execution may not be the actual sender (as far as an application
888  * is concerned).
889  *
890  * This contract is only required for intermediate, library-like contracts.
891  */
892 contract Context {
893     // Empty internal constructor, to prevent people from mistakenly deploying
894     // an instance of this contract, which should be used via inheritance.
895     constructor () internal { }
896 
897     function _msgSender() internal view virtual returns (address payable) {
898         return msg.sender;
899     }
900 
901     function _msgData() internal view virtual returns (bytes memory) {
902         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
903         return msg.data;
904     }
905 }
906 
907 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
908 
909 pragma solidity ^0.6.0;
910 
911 
912 
913 
914 
915 /**
916  * @dev Implementation of the {IERC20} interface.
917  *
918  * This implementation is agnostic to the way tokens are created. This means
919  * that a supply mechanism has to be added in a derived contract using {_mint}.
920  * For a generic mechanism see {ERC20MinterPauser}.
921  *
922  * TIP: For a detailed writeup see our guide
923  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
924  * to implement supply mechanisms].
925  *
926  * We have followed general OpenZeppelin guidelines: functions revert instead
927  * of returning `false` on failure. This behavior is nonetheless conventional
928  * and does not conflict with the expectations of ERC20 applications.
929  *
930  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
931  * This allows applications to reconstruct the allowance for all accounts just
932  * by listening to said events. Other implementations of the EIP may not emit
933  * these events, as it isn't required by the specification.
934  *
935  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
936  * functions have been added to mitigate the well-known issues around setting
937  * allowances. See {IERC20-approve}.
938  */
939 contract ERC20 is Context, IERC20 {
940     using SafeMath for uint256;
941     using Address for address;
942 
943     mapping (address => uint256) private _balances;
944 
945     mapping (address => mapping (address => uint256)) private _allowances;
946 
947     uint256 private _totalSupply;
948 
949     string private _name;
950     string private _symbol;
951     uint8 private _decimals;
952 
953     /**
954      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
955      * a default value of 18.
956      *
957      * To select a different value for {decimals}, use {_setupDecimals}.
958      *
959      * All three of these values are immutable: they can only be set once during
960      * construction.
961      */
962     constructor (string memory name, string memory symbol) public {
963         _name = name;
964         _symbol = symbol;
965         _decimals = 18;
966     }
967 
968     /**
969      * @dev Returns the name of the token.
970      */
971     function name() public view returns (string memory) {
972         return _name;
973     }
974 
975     /**
976      * @dev Returns the symbol of the token, usually a shorter version of the
977      * name.
978      */
979     function symbol() public view returns (string memory) {
980         return _symbol;
981     }
982 
983     /**
984      * @dev Returns the number of decimals used to get its user representation.
985      * For example, if `decimals` equals `2`, a balance of `505` tokens should
986      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
987      *
988      * Tokens usually opt for a value of 18, imitating the relationship between
989      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
990      * called.
991      *
992      * NOTE: This information is only used for _display_ purposes: it in
993      * no way affects any of the arithmetic of the contract, including
994      * {IERC20-balanceOf} and {IERC20-transfer}.
995      */
996     function decimals() public view returns (uint8) {
997         return _decimals;
998     }
999 
1000     /**
1001      * @dev See {IERC20-totalSupply}.
1002      */
1003     function totalSupply() public view override returns (uint256) {
1004         return _totalSupply;
1005     }
1006 
1007     /**
1008      * @dev See {IERC20-balanceOf}.
1009      */
1010     function balanceOf(address account) public view override returns (uint256) {
1011         return _balances[account];
1012     }
1013 
1014     /**
1015      * @dev See {IERC20-transfer}.
1016      *
1017      * Requirements:
1018      *
1019      * - `recipient` cannot be the zero address.
1020      * - the caller must have a balance of at least `amount`.
1021      */
1022     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
1023         _transfer(_msgSender(), recipient, amount);
1024         return true;
1025     }
1026 
1027     /**
1028      * @dev See {IERC20-allowance}.
1029      */
1030     function allowance(address owner, address spender) public view virtual override returns (uint256) {
1031         return _allowances[owner][spender];
1032     }
1033 
1034     /**
1035      * @dev See {IERC20-approve}.
1036      *
1037      * Requirements:
1038      *
1039      * - `spender` cannot be the zero address.
1040      */
1041     function approve(address spender, uint256 amount) public virtual override returns (bool) {
1042         _approve(_msgSender(), spender, amount);
1043         return true;
1044     }
1045 
1046     /**
1047      * @dev See {IERC20-transferFrom}.
1048      *
1049      * Emits an {Approval} event indicating the updated allowance. This is not
1050      * required by the EIP. See the note at the beginning of {ERC20};
1051      *
1052      * Requirements:
1053      * - `sender` and `recipient` cannot be the zero address.
1054      * - `sender` must have a balance of at least `amount`.
1055      * - the caller must have allowance for ``sender``'s tokens of at least
1056      * `amount`.
1057      */
1058     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
1059         _transfer(sender, recipient, amount);
1060         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
1061         return true;
1062     }
1063 
1064     /**
1065      * @dev Atomically increases the allowance granted to `spender` by the caller.
1066      *
1067      * This is an alternative to {approve} that can be used as a mitigation for
1068      * problems described in {IERC20-approve}.
1069      *
1070      * Emits an {Approval} event indicating the updated allowance.
1071      *
1072      * Requirements:
1073      *
1074      * - `spender` cannot be the zero address.
1075      */
1076     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
1077         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
1078         return true;
1079     }
1080 
1081     /**
1082      * @dev Atomically decreases the allowance granted to `spender` by the caller.
1083      *
1084      * This is an alternative to {approve} that can be used as a mitigation for
1085      * problems described in {IERC20-approve}.
1086      *
1087      * Emits an {Approval} event indicating the updated allowance.
1088      *
1089      * Requirements:
1090      *
1091      * - `spender` cannot be the zero address.
1092      * - `spender` must have allowance for the caller of at least
1093      * `subtractedValue`.
1094      */
1095     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1096         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
1097         return true;
1098     }
1099 
1100     /**
1101      * @dev Moves tokens `amount` from `sender` to `recipient`.
1102      *
1103      * This is internal function is equivalent to {transfer}, and can be used to
1104      * e.g. implement automatic token fees, slashing mechanisms, etc.
1105      *
1106      * Emits a {Transfer} event.
1107      *
1108      * Requirements:
1109      *
1110      * - `sender` cannot be the zero address.
1111      * - `recipient` cannot be the zero address.
1112      * - `sender` must have a balance of at least `amount`.
1113      */
1114     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
1115         require(sender != address(0), "ERC20: transfer from the zero address");
1116         require(recipient != address(0), "ERC20: transfer to the zero address");
1117 
1118         _beforeTokenTransfer(sender, recipient, amount);
1119 
1120         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
1121         _balances[recipient] = _balances[recipient].add(amount);
1122         emit Transfer(sender, recipient, amount);
1123     }
1124 
1125     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1126      * the total supply.
1127      *
1128      * Emits a {Transfer} event with `from` set to the zero address.
1129      *
1130      * Requirements
1131      *
1132      * - `to` cannot be the zero address.
1133      */
1134     function _mint(address account, uint256 amount) internal virtual {
1135         require(account != address(0), "ERC20: mint to the zero address");
1136 
1137         _beforeTokenTransfer(address(0), account, amount);
1138 
1139         _totalSupply = _totalSupply.add(amount);
1140         _balances[account] = _balances[account].add(amount);
1141         emit Transfer(address(0), account, amount);
1142     }
1143 
1144     /**
1145      * @dev Destroys `amount` tokens from `account`, reducing the
1146      * total supply.
1147      *
1148      * Emits a {Transfer} event with `to` set to the zero address.
1149      *
1150      * Requirements
1151      *
1152      * - `account` cannot be the zero address.
1153      * - `account` must have at least `amount` tokens.
1154      */
1155     function _burn(address account, uint256 amount) internal virtual {
1156         require(account != address(0), "ERC20: burn from the zero address");
1157 
1158         _beforeTokenTransfer(account, address(0), amount);
1159 
1160         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
1161         _totalSupply = _totalSupply.sub(amount);
1162         emit Transfer(account, address(0), amount);
1163     }
1164 
1165     /**
1166      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
1167      *
1168      * This is internal function is equivalent to `approve`, and can be used to
1169      * e.g. set automatic allowances for certain subsystems, etc.
1170      *
1171      * Emits an {Approval} event.
1172      *
1173      * Requirements:
1174      *
1175      * - `owner` cannot be the zero address.
1176      * - `spender` cannot be the zero address.
1177      */
1178     function _approve(address owner, address spender, uint256 amount) internal virtual {
1179         require(owner != address(0), "ERC20: approve from the zero address");
1180         require(spender != address(0), "ERC20: approve to the zero address");
1181 
1182         _allowances[owner][spender] = amount;
1183         emit Approval(owner, spender, amount);
1184     }
1185 
1186     /**
1187      * @dev Sets {decimals} to a value other than the default one of 18.
1188      *
1189      * WARNING: This function should only be called from the constructor. Most
1190      * applications that interact with token contracts will not expect
1191      * {decimals} to ever change, and may work incorrectly if it does.
1192      */
1193     function _setupDecimals(uint8 decimals_) internal {
1194         _decimals = decimals_;
1195     }
1196 
1197     /**
1198      * @dev Hook that is called before any transfer of tokens. This includes
1199      * minting and burning.
1200      *
1201      * Calling conditions:
1202      *
1203      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1204      * will be to transferred to `to`.
1205      * - when `from` is zero, `amount` tokens will be minted for `to`.
1206      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1207      * - `from` and `to` are never both zero.
1208      *
1209      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1210      */
1211     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
1212 }
1213 
1214 // File: contracts/common/implementation/MultiRole.sol
1215 
1216 pragma solidity ^0.6.0;
1217 
1218 
1219 library Exclusive {
1220     struct RoleMembership {
1221         address member;
1222     }
1223 
1224     function isMember(RoleMembership storage roleMembership, address memberToCheck) internal view returns (bool) {
1225         return roleMembership.member == memberToCheck;
1226     }
1227 
1228     function resetMember(RoleMembership storage roleMembership, address newMember) internal {
1229         require(newMember != address(0x0), "Cannot set an exclusive role to 0x0");
1230         roleMembership.member = newMember;
1231     }
1232 
1233     function getMember(RoleMembership storage roleMembership) internal view returns (address) {
1234         return roleMembership.member;
1235     }
1236 
1237     function init(RoleMembership storage roleMembership, address initialMember) internal {
1238         resetMember(roleMembership, initialMember);
1239     }
1240 }
1241 
1242 
1243 library Shared {
1244     struct RoleMembership {
1245         mapping(address => bool) members;
1246     }
1247 
1248     function isMember(RoleMembership storage roleMembership, address memberToCheck) internal view returns (bool) {
1249         return roleMembership.members[memberToCheck];
1250     }
1251 
1252     function addMember(RoleMembership storage roleMembership, address memberToAdd) internal {
1253         require(memberToAdd != address(0x0), "Cannot add 0x0 to a shared role");
1254         roleMembership.members[memberToAdd] = true;
1255     }
1256 
1257     function removeMember(RoleMembership storage roleMembership, address memberToRemove) internal {
1258         roleMembership.members[memberToRemove] = false;
1259     }
1260 
1261     function init(RoleMembership storage roleMembership, address[] memory initialMembers) internal {
1262         for (uint256 i = 0; i < initialMembers.length; i++) {
1263             addMember(roleMembership, initialMembers[i]);
1264         }
1265     }
1266 }
1267 
1268 
1269 /**
1270  * @title Base class to manage permissions for the derived class.
1271  */
1272 abstract contract MultiRole {
1273     using Exclusive for Exclusive.RoleMembership;
1274     using Shared for Shared.RoleMembership;
1275 
1276     enum RoleType { Invalid, Exclusive, Shared }
1277 
1278     struct Role {
1279         uint256 managingRole;
1280         RoleType roleType;
1281         Exclusive.RoleMembership exclusiveRoleMembership;
1282         Shared.RoleMembership sharedRoleMembership;
1283     }
1284 
1285     mapping(uint256 => Role) private roles;
1286 
1287     event ResetExclusiveMember(uint256 indexed roleId, address indexed newMember, address indexed manager);
1288     event AddedSharedMember(uint256 indexed roleId, address indexed newMember, address indexed manager);
1289     event RemovedSharedMember(uint256 indexed roleId, address indexed oldMember, address indexed manager);
1290 
1291     /**
1292      * @notice Reverts unless the caller is a member of the specified roleId.
1293      */
1294     modifier onlyRoleHolder(uint256 roleId) {
1295         require(holdsRole(roleId, msg.sender), "Sender does not hold required role");
1296         _;
1297     }
1298 
1299     /**
1300      * @notice Reverts unless the caller is a member of the manager role for the specified roleId.
1301      */
1302     modifier onlyRoleManager(uint256 roleId) {
1303         require(holdsRole(roles[roleId].managingRole, msg.sender), "Can only be called by a role manager");
1304         _;
1305     }
1306 
1307     /**
1308      * @notice Reverts unless the roleId represents an initialized, exclusive roleId.
1309      */
1310     modifier onlyExclusive(uint256 roleId) {
1311         require(roles[roleId].roleType == RoleType.Exclusive, "Must be called on an initialized Exclusive role");
1312         _;
1313     }
1314 
1315     /**
1316      * @notice Reverts unless the roleId represents an initialized, shared roleId.
1317      */
1318     modifier onlyShared(uint256 roleId) {
1319         require(roles[roleId].roleType == RoleType.Shared, "Must be called on an initialized Shared role");
1320         _;
1321     }
1322 
1323     /**
1324      * @notice Whether `memberToCheck` is a member of roleId.
1325      * @dev Reverts if roleId does not correspond to an initialized role.
1326      * @param roleId the Role to check.
1327      * @param memberToCheck the address to check.
1328      * @return True if `memberToCheck` is a member of `roleId`.
1329      */
1330     function holdsRole(uint256 roleId, address memberToCheck) public view returns (bool) {
1331         Role storage role = roles[roleId];
1332         if (role.roleType == RoleType.Exclusive) {
1333             return role.exclusiveRoleMembership.isMember(memberToCheck);
1334         } else if (role.roleType == RoleType.Shared) {
1335             return role.sharedRoleMembership.isMember(memberToCheck);
1336         }
1337         revert("Invalid roleId");
1338     }
1339 
1340     /**
1341      * @notice Changes the exclusive role holder of `roleId` to `newMember`.
1342      * @dev Reverts if the caller is not a member of the managing role for `roleId` or if `roleId` is not an
1343      * initialized, ExclusiveRole.
1344      * @param roleId the ExclusiveRole membership to modify.
1345      * @param newMember the new ExclusiveRole member.
1346      */
1347     function resetMember(uint256 roleId, address newMember) public onlyExclusive(roleId) onlyRoleManager(roleId) {
1348         roles[roleId].exclusiveRoleMembership.resetMember(newMember);
1349         emit ResetExclusiveMember(roleId, newMember, msg.sender);
1350     }
1351 
1352     /**
1353      * @notice Gets the current holder of the exclusive role, `roleId`.
1354      * @dev Reverts if `roleId` does not represent an initialized, exclusive role.
1355      * @param roleId the ExclusiveRole membership to check.
1356      * @return the address of the current ExclusiveRole member.
1357      */
1358     function getMember(uint256 roleId) public view onlyExclusive(roleId) returns (address) {
1359         return roles[roleId].exclusiveRoleMembership.getMember();
1360     }
1361 
1362     /**
1363      * @notice Adds `newMember` to the shared role, `roleId`.
1364      * @dev Reverts if `roleId` does not represent an initialized, SharedRole or if the caller is not a member of the
1365      * managing role for `roleId`.
1366      * @param roleId the SharedRole membership to modify.
1367      * @param newMember the new SharedRole member.
1368      */
1369     function addMember(uint256 roleId, address newMember) public onlyShared(roleId) onlyRoleManager(roleId) {
1370         roles[roleId].sharedRoleMembership.addMember(newMember);
1371         emit AddedSharedMember(roleId, newMember, msg.sender);
1372     }
1373 
1374     /**
1375      * @notice Removes `memberToRemove` from the shared role, `roleId`.
1376      * @dev Reverts if `roleId` does not represent an initialized, SharedRole or if the caller is not a member of the
1377      * managing role for `roleId`.
1378      * @param roleId the SharedRole membership to modify.
1379      * @param memberToRemove the current SharedRole member to remove.
1380      */
1381     function removeMember(uint256 roleId, address memberToRemove) public onlyShared(roleId) onlyRoleManager(roleId) {
1382         roles[roleId].sharedRoleMembership.removeMember(memberToRemove);
1383         emit RemovedSharedMember(roleId, memberToRemove, msg.sender);
1384     }
1385 
1386     /**
1387      * @notice Removes caller from the role, `roleId`.
1388      * @dev Reverts if the caller is not a member of the role for `roleId` or if `roleId` is not an
1389      * initialized, SharedRole.
1390      * @param roleId the SharedRole membership to modify.
1391      */
1392     function renounceMembership(uint256 roleId) public onlyShared(roleId) onlyRoleHolder(roleId) {
1393         roles[roleId].sharedRoleMembership.removeMember(msg.sender);
1394         emit RemovedSharedMember(roleId, msg.sender, msg.sender);
1395     }
1396 
1397     /**
1398      * @notice Reverts if `roleId` is not initialized.
1399      */
1400     modifier onlyValidRole(uint256 roleId) {
1401         require(roles[roleId].roleType != RoleType.Invalid, "Attempted to use an invalid roleId");
1402         _;
1403     }
1404 
1405     /**
1406      * @notice Reverts if `roleId` is initialized.
1407      */
1408     modifier onlyInvalidRole(uint256 roleId) {
1409         require(roles[roleId].roleType == RoleType.Invalid, "Cannot use a pre-existing role");
1410         _;
1411     }
1412 
1413     /**
1414      * @notice Internal method to initialize a shared role, `roleId`, which will be managed by `managingRoleId`.
1415      * `initialMembers` will be immediately added to the role.
1416      * @dev Should be called by derived contracts, usually at construction time. Will revert if the role is already
1417      * initialized.
1418      */
1419     function _createSharedRole(
1420         uint256 roleId,
1421         uint256 managingRoleId,
1422         address[] memory initialMembers
1423     ) internal onlyInvalidRole(roleId) {
1424         Role storage role = roles[roleId];
1425         role.roleType = RoleType.Shared;
1426         role.managingRole = managingRoleId;
1427         role.sharedRoleMembership.init(initialMembers);
1428         require(
1429             roles[managingRoleId].roleType != RoleType.Invalid,
1430             "Attempted to use an invalid role to manage a shared role"
1431         );
1432     }
1433 
1434     /**
1435      * @notice Internal method to initialize an exclusive role, `roleId`, which will be managed by `managingRoleId`.
1436      * `initialMember` will be immediately added to the role.
1437      * @dev Should be called by derived contracts, usually at construction time. Will revert if the role is already
1438      * initialized.
1439      */
1440     function _createExclusiveRole(
1441         uint256 roleId,
1442         uint256 managingRoleId,
1443         address initialMember
1444     ) internal onlyInvalidRole(roleId) {
1445         Role storage role = roles[roleId];
1446         role.roleType = RoleType.Exclusive;
1447         role.managingRole = managingRoleId;
1448         role.exclusiveRoleMembership.init(initialMember);
1449         require(
1450             roles[managingRoleId].roleType != RoleType.Invalid,
1451             "Attempted to use an invalid role to manage an exclusive role"
1452         );
1453     }
1454 }
1455 
1456 // File: contracts/common/implementation/ExpandedERC20.sol
1457 
1458 pragma solidity ^0.6.0;
1459 
1460 
1461 
1462 
1463 
1464 /**
1465  * @title An ERC20 with permissioned burning and minting. The contract deployer will initially
1466  * be the owner who is capable of adding new roles.
1467  */
1468 contract ExpandedERC20 is ExpandedIERC20, ERC20, MultiRole {
1469     enum Roles {
1470         // Can set the minter and burner.
1471         Owner,
1472         // Addresses that can mint new tokens.
1473         Minter,
1474         // Addresses that can burn tokens that address owns.
1475         Burner
1476     }
1477 
1478     /**
1479      * @notice Constructs the ExpandedERC20.
1480      * @param _tokenName The name which describes the new token.
1481      * @param _tokenSymbol The ticker abbreviation of the name. Ideally < 5 chars.
1482      * @param _tokenDecimals The number of decimals to define token precision.
1483      */
1484     constructor(
1485         string memory _tokenName,
1486         string memory _tokenSymbol,
1487         uint8 _tokenDecimals
1488     ) public ERC20(_tokenName, _tokenSymbol) {
1489         _setupDecimals(_tokenDecimals);
1490         _createExclusiveRole(uint256(Roles.Owner), uint256(Roles.Owner), msg.sender);
1491         _createSharedRole(uint256(Roles.Minter), uint256(Roles.Owner), new address[](0));
1492         _createSharedRole(uint256(Roles.Burner), uint256(Roles.Owner), new address[](0));
1493     }
1494 
1495     /**
1496      * @dev Mints `value` tokens to `recipient`, returning true on success.
1497      * @param recipient address to mint to.
1498      * @param value amount of tokens to mint.
1499      * @return True if the mint succeeded, or False.
1500      */
1501     function mint(address recipient, uint256 value)
1502         external
1503         override
1504         onlyRoleHolder(uint256(Roles.Minter))
1505         returns (bool)
1506     {
1507         _mint(recipient, value);
1508         return true;
1509     }
1510 
1511     /**
1512      * @dev Burns `value` tokens owned by `msg.sender`.
1513      * @param value amount of tokens to burn.
1514      */
1515     function burn(uint256 value) external override onlyRoleHolder(uint256(Roles.Burner)) {
1516         _burn(msg.sender, value);
1517     }
1518 }
1519 
1520 // File: contracts/common/implementation/Lockable.sol
1521 
1522 pragma solidity ^0.6.0;
1523 
1524 
1525 /**
1526  * @title A contract that provides modifiers to prevent reentrancy to state-changing and view-only methods. This contract
1527  * is inspired by https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/ReentrancyGuard.sol
1528  * and https://github.com/balancer-labs/balancer-core/blob/master/contracts/BPool.sol.
1529  */
1530 contract Lockable {
1531     bool private _notEntered;
1532 
1533     constructor() internal {
1534         // Storing an initial non-zero value makes deployment a bit more
1535         // expensive, but in exchange the refund on every call to nonReentrant
1536         // will be lower in amount. Since refunds are capped to a percetange of
1537         // the total transaction's gas, it is best to keep them low in cases
1538         // like this one, to increase the likelihood of the full refund coming
1539         // into effect.
1540         _notEntered = true;
1541     }
1542 
1543     /**
1544      * @dev Prevents a contract from calling itself, directly or indirectly.
1545      * Calling a `nonReentrant` function from another `nonReentrant`
1546      * function is not supported. It is possible to prevent this from happening
1547      * by making the `nonReentrant` function external, and make it call a
1548      * `private` function that does the actual work.
1549      */
1550     modifier nonReentrant() {
1551         _preEntranceCheck();
1552         _preEntranceSet();
1553         _;
1554         _postEntranceReset();
1555     }
1556 
1557     /**
1558      * @dev Designed to prevent a view-only method from being re-entered during a call to a `nonReentrant()` state-changing method.
1559      */
1560     modifier nonReentrantView() {
1561         _preEntranceCheck();
1562         _;
1563     }
1564 
1565     // Internal methods are used to avoid copying the require statement's bytecode to every `nonReentrant()` method.
1566     // On entry into a function, `_preEntranceCheck()` should always be called to check if the function is being re-entered.
1567     // Then, if the function modifies state, it should call `_postEntranceSet()`, perform its logic, and then call `_postEntranceReset()`.
1568     // View-only methods can simply call `_preEntranceCheck()` to make sure that it is not being re-entered.
1569     function _preEntranceCheck() internal view {
1570         // On the first call to nonReentrant, _notEntered will be true
1571         require(_notEntered, "ReentrancyGuard: reentrant call");
1572     }
1573 
1574     function _preEntranceSet() internal {
1575         // Any calls to nonReentrant after this point will fail
1576         _notEntered = false;
1577     }
1578 
1579     function _postEntranceReset() internal {
1580         // By storing the original value once again, a refund is triggered (see
1581         // https://eips.ethereum.org/EIPS/eip-2200)
1582         _notEntered = true;
1583     }
1584 }
1585 
1586 // File: contracts/financial-templates/common/SyntheticToken.sol
1587 
1588 pragma solidity ^0.6.0;
1589 
1590 
1591 
1592 
1593 /**
1594  * @title Burnable and mintable ERC20.
1595  * @dev The contract deployer will initially be the only minter, burner and owner capable of adding new roles.
1596  */
1597 
1598 contract SyntheticToken is ExpandedERC20, Lockable {
1599     /**
1600      * @notice Constructs the SyntheticToken.
1601      * @param tokenName The name which describes the new token.
1602      * @param tokenSymbol The ticker abbreviation of the name. Ideally < 5 chars.
1603      * @param tokenDecimals The number of decimals to define token precision.
1604      */
1605     constructor(
1606         string memory tokenName,
1607         string memory tokenSymbol,
1608         uint8 tokenDecimals
1609     ) public ExpandedERC20(tokenName, tokenSymbol, tokenDecimals) nonReentrant() {}
1610 
1611     /**
1612      * @notice Add Minter role to account.
1613      * @dev The caller must have the Owner role.
1614      * @param account The address to which the Minter role is added.
1615      */
1616     function addMinter(address account) external nonReentrant() {
1617         addMember(uint256(Roles.Minter), account);
1618     }
1619 
1620     /**
1621      * @notice Remove Minter role from account.
1622      * @dev The caller must have the Owner role.
1623      * @param account The address from which the Minter role is removed.
1624      */
1625     function removeMinter(address account) external nonReentrant() {
1626         removeMember(uint256(Roles.Minter), account);
1627     }
1628 
1629     /**
1630      * @notice Add Burner role to account.
1631      * @dev The caller must have the Owner role.
1632      * @param account The address to which the Burner role is added.
1633      */
1634     function addBurner(address account) external nonReentrant() {
1635         addMember(uint256(Roles.Burner), account);
1636     }
1637 
1638     /**
1639      * @notice Removes Burner role from account.
1640      * @dev The caller must have the Owner role.
1641      * @param account The address from which the Burner role is removed.
1642      */
1643     function removeBurner(address account) external nonReentrant() {
1644         removeMember(uint256(Roles.Burner), account);
1645     }
1646 
1647     /**
1648      * @notice Reset Owner role to account.
1649      * @dev The caller must have the Owner role.
1650      * @param account The new holder of the Owner role.
1651      */
1652     function resetOwner(address account) external nonReentrant() {
1653         resetMember(uint256(Roles.Owner), account);
1654     }
1655 
1656     /**
1657      * @notice Checks if a given account holds the Minter role.
1658      * @param account The address which is checked for the Minter role.
1659      * @return bool True if the provided account is a Minter.
1660      */
1661     function isMinter(address account) public view nonReentrantView() returns (bool) {
1662         return holdsRole(uint256(Roles.Minter), account);
1663     }
1664 
1665     /**
1666      * @notice Checks if a given account holds the Burner role.
1667      * @param account The address which is checked for the Burner role.
1668      * @return bool True if the provided account is a Burner.
1669      */
1670     function isBurner(address account) public view nonReentrantView() returns (bool) {
1671         return holdsRole(uint256(Roles.Burner), account);
1672     }
1673 }
1674 
1675 // File: contracts/financial-templates/common/TokenFactory.sol
1676 
1677 pragma solidity ^0.6.0;
1678 
1679 
1680 
1681 
1682 
1683 /**
1684  * @title Factory for creating new mintable and burnable tokens.
1685  */
1686 
1687 contract TokenFactory is Lockable {
1688     /**
1689      * @notice Create a new token and return it to the caller.
1690      * @dev The caller will become the only minter and burner and the new owner capable of assigning the roles.
1691      * @param tokenName used to describe the new token.
1692      * @param tokenSymbol short ticker abbreviation of the name. Ideally < 5 chars.
1693      * @param tokenDecimals used to define the precision used in the token's numerical representation.
1694      * @return newToken an instance of the newly created token interface.
1695      */
1696     function createToken(
1697         string calldata tokenName,
1698         string calldata tokenSymbol,
1699         uint8 tokenDecimals
1700     ) external nonReentrant() returns (ExpandedIERC20 newToken) {
1701         SyntheticToken mintableToken = new SyntheticToken(tokenName, tokenSymbol, tokenDecimals);
1702         mintableToken.addMinter(msg.sender);
1703         mintableToken.addBurner(msg.sender);
1704         mintableToken.resetOwner(msg.sender);
1705         newToken = ExpandedIERC20(address(mintableToken));
1706     }
1707 }
1708 
1709 // File: contracts/common/implementation/Timer.sol
1710 
1711 pragma solidity ^0.6.0;
1712 
1713 
1714 /**
1715  * @title Universal store of current contract time for testing environments.
1716  */
1717 contract Timer {
1718     uint256 private currentTime;
1719 
1720     constructor() public {
1721         currentTime = now; // solhint-disable-line not-rely-on-time
1722     }
1723 
1724     /**
1725      * @notice Sets the current time.
1726      * @dev Will revert if not running in test mode.
1727      * @param time timestamp to set `currentTime` to.
1728      */
1729     function setCurrentTime(uint256 time) external {
1730         currentTime = time;
1731     }
1732 
1733     /**
1734      * @notice Gets the current time. Will return the last time set in `setCurrentTime` if running in test mode.
1735      * Otherwise, it will return the block timestamp.
1736      * @return uint256 for the current Testable timestamp.
1737      */
1738     function getCurrentTime() public view returns (uint256) {
1739         return currentTime;
1740     }
1741 }
1742 
1743 // File: contracts/common/implementation/Testable.sol
1744 
1745 pragma solidity ^0.6.0;
1746 
1747 
1748 
1749 /**
1750  * @title Base class that provides time overrides, but only if being run in test mode.
1751  */
1752 abstract contract Testable {
1753     // If the contract is being run on the test network, then `timerAddress` will be the 0x0 address.
1754     // Note: this variable should be set on construction and never modified.
1755     address public timerAddress;
1756 
1757     /**
1758      * @notice Constructs the Testable contract. Called by child contracts.
1759      * @param _timerAddress Contract that stores the current time in a testing environment.
1760      * Must be set to 0x0 for production environments that use live time.
1761      */
1762     constructor(address _timerAddress) internal {
1763         timerAddress = _timerAddress;
1764     }
1765 
1766     /**
1767      * @notice Reverts if not running in test mode.
1768      */
1769     modifier onlyIfTest {
1770         require(timerAddress != address(0x0));
1771         _;
1772     }
1773 
1774     /**
1775      * @notice Sets the current time.
1776      * @dev Will revert if not running in test mode.
1777      * @param time timestamp to set current Testable time to.
1778      */
1779     function setCurrentTime(uint256 time) external onlyIfTest {
1780         Timer(timerAddress).setCurrentTime(time);
1781     }
1782 
1783     /**
1784      * @notice Gets the current time. Will return the last time set in `setCurrentTime` if running in test mode.
1785      * Otherwise, it will return the block timestamp.
1786      * @return uint for the current Testable timestamp.
1787      */
1788     function getCurrentTime() public view returns (uint256) {
1789         if (timerAddress != address(0x0)) {
1790             return Timer(timerAddress).getCurrentTime();
1791         } else {
1792             return now; // solhint-disable-line not-rely-on-time
1793         }
1794     }
1795 }
1796 
1797 // File: contracts/oracle/interfaces/StoreInterface.sol
1798 
1799 pragma solidity ^0.6.0;
1800 
1801 
1802 
1803 
1804 /**
1805  * @title Interface that allows financial contracts to pay oracle fees for their use of the system.
1806  */
1807 interface StoreInterface {
1808     /**
1809      * @notice Pays Oracle fees in ETH to the store.
1810      * @dev To be used by contracts whose margin currency is ETH.
1811      */
1812     function payOracleFees() external payable;
1813 
1814     /**
1815      * @notice Pays oracle fees in the margin currency, erc20Address, to the store.
1816      * @dev To be used if the margin currency is an ERC20 token rather than ETH.
1817      * @param erc20Address address of the ERC20 token used to pay the fee.
1818      * @param amount number of tokens to transfer. An approval for at least this amount must exist.
1819      */
1820     function payOracleFeesErc20(address erc20Address, FixedPoint.Unsigned calldata amount) external;
1821 
1822     /**
1823      * @notice Computes the regular oracle fees that a contract should pay for a period.
1824      * @param startTime defines the beginning time from which the fee is paid.
1825      * @param endTime end time until which the fee is paid.
1826      * @param pfc "profit from corruption", or the maximum amount of margin currency that a
1827      * token sponsor could extract from the contract through corrupting the price feed in their favor.
1828      * @return regularFee amount owed for the duration from start to end time for the given pfc.
1829      * @return latePenalty for paying the fee after the deadline.
1830      */
1831     function computeRegularFee(
1832         uint256 startTime,
1833         uint256 endTime,
1834         FixedPoint.Unsigned calldata pfc
1835     ) external view returns (FixedPoint.Unsigned memory regularFee, FixedPoint.Unsigned memory latePenalty);
1836 
1837     /**
1838      * @notice Computes the final oracle fees that a contract should pay at settlement.
1839      * @param currency token used to pay the final fee.
1840      * @return finalFee amount due.
1841      */
1842     function computeFinalFee(address currency) external view returns (FixedPoint.Unsigned memory);
1843 }
1844 
1845 // File: contracts/oracle/interfaces/FinderInterface.sol
1846 
1847 pragma solidity ^0.6.0;
1848 
1849 
1850 /**
1851  * @title Provides addresses of the live contracts implementing certain interfaces.
1852  * @dev Examples are the Oracle or Store interfaces.
1853  */
1854 interface FinderInterface {
1855     /**
1856      * @notice Updates the address of the contract that implements `interfaceName`.
1857      * @param interfaceName bytes32 encoding of the interface name that is either changed or registered.
1858      * @param implementationAddress address of the deployed contract that implements the interface.
1859      */
1860     function changeImplementationAddress(bytes32 interfaceName, address implementationAddress) external;
1861 
1862     /**
1863      * @notice Gets the address of the contract that implements the given `interfaceName`.
1864      * @param interfaceName queried interface.
1865      * @return implementationAddress address of the deployed contract that implements the interface.
1866      */
1867     function getImplementationAddress(bytes32 interfaceName) external view returns (address);
1868 }
1869 
1870 // File: contracts/financial-templates/common/FeePayer.sol
1871 
1872 pragma solidity ^0.6.0;
1873 
1874 
1875 
1876 
1877 
1878 
1879 
1880 
1881 
1882 
1883 /**
1884  * @title FeePayer contract.
1885  * @notice Provides fee payment functionality for the ExpiringMultiParty contract.
1886  * contract is abstract as each derived contract that inherits `FeePayer` must implement `pfc()`.
1887  */
1888 
1889 abstract contract FeePayer is Testable, Lockable {
1890     using SafeMath for uint256;
1891     using FixedPoint for FixedPoint.Unsigned;
1892     using SafeERC20 for IERC20;
1893 
1894     /****************************************
1895      *      FEE PAYER DATA STRUCTURES       *
1896      ****************************************/
1897 
1898     // The collateral currency used to back the positions in this contract.
1899     IERC20 public collateralCurrency;
1900 
1901     // Finder contract used to look up addresses for UMA system contracts.
1902     FinderInterface public finder;
1903 
1904     // Tracks the last block time when the fees were paid.
1905     uint256 private lastPaymentTime;
1906 
1907     // Tracks the cumulative fees that have been paid by the contract for use by derived contracts.
1908     // The multiplier starts at 1, and is updated by computing cumulativeFeeMultiplier * (1 - effectiveFee).
1909     // Put another way, the cumulativeFeeMultiplier is (1 - effectiveFee1) * (1 - effectiveFee2) ...
1910     // For example:
1911     // The cumulativeFeeMultiplier should start at 1.
1912     // If a 1% fee is charged, the multiplier should update to .99.
1913     // If another 1% fee is charged, the multiplier should be 0.99^2 (0.9801).
1914     FixedPoint.Unsigned public cumulativeFeeMultiplier;
1915 
1916     /****************************************
1917      *                EVENTS                *
1918      ****************************************/
1919 
1920     event RegularFeesPaid(uint256 indexed regularFee, uint256 indexed lateFee);
1921     event FinalFeesPaid(uint256 indexed amount);
1922 
1923     /****************************************
1924      *              MODIFIERS               *
1925      ****************************************/
1926 
1927     // modifier that calls payRegularFees().
1928     modifier fees {
1929         payRegularFees();
1930         _;
1931     }
1932 
1933     /**
1934      * @notice Constructs the FeePayer contract. Called by child contracts.
1935      * @param _collateralAddress ERC20 token that is used as the underlying collateral for the synthetic.
1936      * @param _finderAddress UMA protocol Finder used to discover other protocol contracts.
1937      * @param _timerAddress Contract that stores the current time in a testing environment.
1938      * Must be set to 0x0 for production environments that use live time.
1939      */
1940     constructor(
1941         address _collateralAddress,
1942         address _finderAddress,
1943         address _timerAddress
1944     ) public Testable(_timerAddress) nonReentrant() {
1945         collateralCurrency = IERC20(_collateralAddress);
1946         finder = FinderInterface(_finderAddress);
1947         lastPaymentTime = getCurrentTime();
1948         cumulativeFeeMultiplier = FixedPoint.fromUnscaledUint(1);
1949     }
1950 
1951     /****************************************
1952      *        FEE PAYMENT FUNCTIONS         *
1953      ****************************************/
1954 
1955     /**
1956      * @notice Pays UMA DVM regular fees (as a % of the collateral pool) to the Store contract.
1957      * @dev These must be paid periodically for the life of the contract. If the contract has not paid its regular fee
1958      * in a week or more then a late penalty is applied which is sent to the caller. If the amount of
1959      * fees owed are greater than the pfc, then this will pay as much as possible from the available collateral.
1960      * An event is only fired if the fees charged are greater than 0.
1961      * @return totalPaid Amount of collateral that the contract paid (sum of the amount paid to the Store and caller).
1962      * This returns 0 and exit early if there is no pfc, fees were already paid during the current block, or the fee rate is 0.
1963      */
1964     function payRegularFees() public nonReentrant() returns (FixedPoint.Unsigned memory totalPaid) {
1965         StoreInterface store = _getStore();
1966         uint256 time = getCurrentTime();
1967         FixedPoint.Unsigned memory collateralPool = _pfc();
1968 
1969         // Exit early if there is no collateral from which to pay fees.
1970         if (collateralPool.isEqual(0)) {
1971             return totalPaid;
1972         }
1973 
1974         // Exit early if fees were already paid during this block.
1975         if (lastPaymentTime == time) {
1976             return totalPaid;
1977         }
1978 
1979         (FixedPoint.Unsigned memory regularFee, FixedPoint.Unsigned memory latePenalty) = store.computeRegularFee(
1980             lastPaymentTime,
1981             time,
1982             collateralPool
1983         );
1984         lastPaymentTime = time;
1985 
1986         totalPaid = regularFee.add(latePenalty);
1987         if (totalPaid.isEqual(0)) {
1988             return totalPaid;
1989         }
1990         // If the effective fees paid as a % of the pfc is > 100%, then we need to reduce it and make the contract pay
1991         // as much of the fee that it can (up to 100% of its pfc). We'll reduce the late penalty first and then the
1992         // regular fee, which has the effect of paying the store first, followed by the caller if there is any fee remaining.
1993         if (totalPaid.isGreaterThan(collateralPool)) {
1994             FixedPoint.Unsigned memory deficit = totalPaid.sub(collateralPool);
1995             FixedPoint.Unsigned memory latePenaltyReduction = FixedPoint.min(latePenalty, deficit);
1996             latePenalty = latePenalty.sub(latePenaltyReduction);
1997             deficit = deficit.sub(latePenaltyReduction);
1998             regularFee = regularFee.sub(FixedPoint.min(regularFee, deficit));
1999             totalPaid = collateralPool;
2000         }
2001 
2002         emit RegularFeesPaid(regularFee.rawValue, latePenalty.rawValue);
2003 
2004         _adjustCumulativeFeeMultiplier(totalPaid, collateralPool);
2005 
2006         if (regularFee.isGreaterThan(0)) {
2007             collateralCurrency.safeIncreaseAllowance(address(store), regularFee.rawValue);
2008             store.payOracleFeesErc20(address(collateralCurrency), regularFee);
2009         }
2010 
2011         if (latePenalty.isGreaterThan(0)) {
2012             collateralCurrency.safeTransfer(msg.sender, latePenalty.rawValue);
2013         }
2014         return totalPaid;
2015     }
2016 
2017     /**
2018      * @notice Gets the current profit from corruption for this contract in terms of the collateral currency.
2019      * @dev This is equivalent to the collateral pool available from which to pay fees. Therefore, derived contracts are
2020      * expected to implement this so that pay-fee methods can correctly compute the owed fees as a % of PfC.
2021      * @return pfc value for equal to the current profit from corrution denominated in collateral currency.
2022      */
2023     function pfc() public view nonReentrantView() returns (FixedPoint.Unsigned memory) {
2024         return _pfc();
2025     }
2026 
2027     /****************************************
2028      *         INTERNAL FUNCTIONS           *
2029      ****************************************/
2030 
2031     // Pays UMA Oracle final fees of `amount` in `collateralCurrency` to the Store contract. Final fee is a flat fee
2032     // charged for each price request. If payer is the contract, adjusts internal bookkeeping variables. If payer is not
2033     // the contract, pulls in `amount` of collateral currency.
2034     function _payFinalFees(address payer, FixedPoint.Unsigned memory amount) internal {
2035         if (amount.isEqual(0)) {
2036             return;
2037         }
2038 
2039         if (payer != address(this)) {
2040             // If the payer is not the contract pull the collateral from the payer.
2041             collateralCurrency.safeTransferFrom(payer, address(this), amount.rawValue);
2042         } else {
2043             // If the payer is the contract, adjust the cumulativeFeeMultiplier to compensate.
2044             FixedPoint.Unsigned memory collateralPool = _pfc();
2045 
2046             // The final fee must be < available collateral or the fee will be larger than 100%.
2047             require(collateralPool.isGreaterThan(amount), "Final fee is more than PfC");
2048 
2049             _adjustCumulativeFeeMultiplier(amount, collateralPool);
2050         }
2051 
2052         emit FinalFeesPaid(amount.rawValue);
2053 
2054         StoreInterface store = _getStore();
2055         collateralCurrency.safeIncreaseAllowance(address(store), amount.rawValue);
2056         store.payOracleFeesErc20(address(collateralCurrency), amount);
2057     }
2058 
2059     function _pfc() internal virtual view returns (FixedPoint.Unsigned memory);
2060 
2061     function _getStore() internal view returns (StoreInterface) {
2062         return StoreInterface(finder.getImplementationAddress(OracleInterfaces.Store));
2063     }
2064 
2065     function _computeFinalFees() internal view returns (FixedPoint.Unsigned memory finalFees) {
2066         StoreInterface store = _getStore();
2067         return store.computeFinalFee(address(collateralCurrency));
2068     }
2069 
2070     // Returns the user's collateral minus any fees that have been subtracted since it was originally
2071     // deposited into the contract. Note: if the contract has paid fees since it was deployed, the raw
2072     // value should be larger than the returned value.
2073     function _getFeeAdjustedCollateral(FixedPoint.Unsigned memory rawCollateral)
2074         internal
2075         view
2076         returns (FixedPoint.Unsigned memory collateral)
2077     {
2078         return rawCollateral.mul(cumulativeFeeMultiplier);
2079     }
2080 
2081     // Converts a user-readable collateral value into a raw value that accounts for already-assessed fees. If any fees
2082     // have been taken from this contract in the past, then the raw value will be larger than the user-readable value.
2083     function _convertToRawCollateral(FixedPoint.Unsigned memory collateral)
2084         internal
2085         view
2086         returns (FixedPoint.Unsigned memory rawCollateral)
2087     {
2088         return collateral.div(cumulativeFeeMultiplier);
2089     }
2090 
2091     // Decrease rawCollateral by a fee-adjusted collateralToRemove amount. Fee adjustment scales up collateralToRemove
2092     // by dividing it by cumulativeFeeMultiplier. There is potential for this quotient to be floored, therefore
2093     // rawCollateral is decreased by less than expected. Because this method is usually called in conjunction with an
2094     // actual removal of collateral from this contract, return the fee-adjusted amount that the rawCollateral is
2095     // decreased by so that the caller can minimize error between collateral removed and rawCollateral debited.
2096     function _removeCollateral(FixedPoint.Unsigned storage rawCollateral, FixedPoint.Unsigned memory collateralToRemove)
2097         internal
2098         returns (FixedPoint.Unsigned memory removedCollateral)
2099     {
2100         FixedPoint.Unsigned memory initialBalance = _getFeeAdjustedCollateral(rawCollateral);
2101         FixedPoint.Unsigned memory adjustedCollateral = _convertToRawCollateral(collateralToRemove);
2102         rawCollateral.rawValue = rawCollateral.sub(adjustedCollateral).rawValue;
2103         removedCollateral = initialBalance.sub(_getFeeAdjustedCollateral(rawCollateral));
2104     }
2105 
2106     // Increase rawCollateral by a fee-adjusted collateralToAdd amount. Fee adjustment scales up collateralToAdd
2107     // by dividing it by cumulativeFeeMultiplier. There is potential for this quotient to be floored, therefore
2108     // rawCollateral is increased by less than expected. Because this method is usually called in conjunction with an
2109     // actual addition of collateral to this contract, return the fee-adjusted amount that the rawCollateral is
2110     // increased by so that the caller can minimize error between collateral added and rawCollateral credited.
2111     // NOTE: This return value exists only for the sake of symmetry with _removeCollateral. We don't actually use it
2112     // because we are OK if more collateral is stored in the contract than is represented by rawTotalPositionCollateral.
2113     function _addCollateral(FixedPoint.Unsigned storage rawCollateral, FixedPoint.Unsigned memory collateralToAdd)
2114         internal
2115         returns (FixedPoint.Unsigned memory addedCollateral)
2116     {
2117         FixedPoint.Unsigned memory initialBalance = _getFeeAdjustedCollateral(rawCollateral);
2118         FixedPoint.Unsigned memory adjustedCollateral = _convertToRawCollateral(collateralToAdd);
2119         rawCollateral.rawValue = rawCollateral.add(adjustedCollateral).rawValue;
2120         addedCollateral = _getFeeAdjustedCollateral(rawCollateral).sub(initialBalance);
2121     }
2122 
2123     // Scale the cumulativeFeeMultiplier by the ratio of fees paid to the current available collateral.
2124     function _adjustCumulativeFeeMultiplier(FixedPoint.Unsigned memory amount, FixedPoint.Unsigned memory currentPfc)
2125         internal
2126     {
2127         FixedPoint.Unsigned memory effectiveFee = amount.divCeil(currentPfc);
2128         cumulativeFeeMultiplier = cumulativeFeeMultiplier.mul(FixedPoint.fromUnscaledUint(1).sub(effectiveFee));
2129     }
2130 }
2131 
2132 // File: contracts/financial-templates/expiring-multiparty/PricelessPositionManager.sol
2133 
2134 pragma solidity ^0.6.0;
2135 
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
2148 /**
2149  * @title Financial contract with priceless position management.
2150  * @notice Handles positions for multiple sponsors in an optimistic (i.e., priceless) way without relying
2151  * on a price feed. On construction, deploys a new ERC20, managed by this contract, that is the synthetic token.
2152  */
2153 
2154 contract PricelessPositionManager is FeePayer, AdministrateeInterface {
2155     using SafeMath for uint256;
2156     using FixedPoint for FixedPoint.Unsigned;
2157     using SafeERC20 for IERC20;
2158     using SafeERC20 for ExpandedIERC20;
2159 
2160     /****************************************
2161      *  PRICELESS POSITION DATA STRUCTURES  *
2162      ****************************************/
2163 
2164     // Stores the state of the PricelessPositionManager. Set on expiration, emergency shutdown, or settlement.
2165     enum ContractState { Open, ExpiredPriceRequested, ExpiredPriceReceived }
2166     ContractState public contractState;
2167 
2168     // Represents a single sponsor's position. All collateral is held by this contract.
2169     // This struct acts as bookkeeping for how much of that collateral is allocated to each sponsor.
2170     struct PositionData {
2171         FixedPoint.Unsigned tokensOutstanding;
2172         // Tracks pending withdrawal requests. A withdrawal request is pending if `withdrawalRequestPassTimestamp != 0`.
2173         uint256 withdrawalRequestPassTimestamp;
2174         FixedPoint.Unsigned withdrawalRequestAmount;
2175         // Raw collateral value. This value should never be accessed directly -- always use _getFeeAdjustedCollateral().
2176         // To add or remove collateral, use _addCollateral() and _removeCollateral().
2177         FixedPoint.Unsigned rawCollateral;
2178         // Tracks pending transfer position requests. A transfer position request is pending if `transferPositionRequestPassTimestamp != 0`.
2179         uint256 transferPositionRequestPassTimestamp;
2180     }
2181 
2182     // Maps sponsor addresses to their positions. Each sponsor can have only one position.
2183     mapping(address => PositionData) public positions;
2184 
2185     // Keep track of the total collateral and tokens across all positions to enable calculating the
2186     // global collateralization ratio without iterating over all positions.
2187     FixedPoint.Unsigned public totalTokensOutstanding;
2188 
2189     // Similar to the rawCollateral in PositionData, this value should not be used directly.
2190     // _getFeeAdjustedCollateral(), _addCollateral() and _removeCollateral() must be used to access and adjust.
2191     FixedPoint.Unsigned public rawTotalPositionCollateral;
2192 
2193     // Synthetic token created by this contract.
2194     ExpandedIERC20 public tokenCurrency;
2195 
2196     // Unique identifier for DVM price feed ticker.
2197     bytes32 public priceIdentifier;
2198     // Time that this contract expires. Should not change post-construction unless an emergency shutdown occurs.
2199     uint256 public expirationTimestamp;
2200     // Time that has to elapse for a withdrawal request to be considered passed, if no liquidations occur.
2201     uint256 public withdrawalLiveness;
2202 
2203     // Minimum number of tokens in a sponsor's position.
2204     FixedPoint.Unsigned public minSponsorTokens;
2205 
2206     // The expiry price pulled from the DVM.
2207     FixedPoint.Unsigned public expiryPrice;
2208 
2209     /****************************************
2210      *                EVENTS                *
2211      ****************************************/
2212 
2213     event RequestTransferPosition(address indexed oldSponsor);
2214     event RequestTransferPositionExecuted(address indexed oldSponsor, address indexed newSponsor);
2215     event RequestTransferPositionCanceled(address indexed oldSponsor);
2216     event Deposit(address indexed sponsor, uint256 indexed collateralAmount);
2217     event Withdrawal(address indexed sponsor, uint256 indexed collateralAmount);
2218     event RequestWithdrawal(address indexed sponsor, uint256 indexed collateralAmount);
2219     event RequestWithdrawalExecuted(address indexed sponsor, uint256 indexed collateralAmount);
2220     event RequestWithdrawalCanceled(address indexed sponsor, uint256 indexed collateralAmount);
2221     event PositionCreated(address indexed sponsor, uint256 indexed collateralAmount, uint256 indexed tokenAmount);
2222     event NewSponsor(address indexed sponsor);
2223     event EndedSponsorPosition(address indexed sponsor);
2224     event Redeem(address indexed sponsor, uint256 indexed collateralAmount, uint256 indexed tokenAmount);
2225     event ContractExpired(address indexed caller);
2226     event SettleExpiredPosition(
2227         address indexed caller,
2228         uint256 indexed collateralReturned,
2229         uint256 indexed tokensBurned
2230     );
2231     event EmergencyShutdown(address indexed caller, uint256 originalExpirationTimestamp, uint256 shutdownTimestamp);
2232 
2233     /****************************************
2234      *               MODIFIERS              *
2235      ****************************************/
2236 
2237     modifier onlyPreExpiration() {
2238         _onlyPreExpiration();
2239         _;
2240     }
2241 
2242     modifier onlyPostExpiration() {
2243         _onlyPostExpiration();
2244         _;
2245     }
2246 
2247     modifier onlyCollateralizedPosition(address sponsor) {
2248         _onlyCollateralizedPosition(sponsor);
2249         _;
2250     }
2251 
2252     // Check that the current state of the pricelessPositionManager is Open.
2253     // This prevents multiple calls to `expire` and `EmergencyShutdown` post expiration.
2254     modifier onlyOpenState() {
2255         _onlyOpenState();
2256         _;
2257     }
2258 
2259     modifier noPendingWithdrawal(address sponsor) {
2260         _positionHasNoPendingWithdrawal(sponsor);
2261         _;
2262     }
2263 
2264     /**
2265      * @notice Construct the PricelessPositionManager
2266      * @param _expirationTimestamp unix timestamp of when the contract will expire.
2267      * @param _withdrawalLiveness liveness delay, in seconds, for pending withdrawals.
2268      * @param _collateralAddress ERC20 token used as collateral for all positions.
2269      * @param _finderAddress UMA protocol Finder used to discover other protocol contracts.
2270      * @param _priceIdentifier registered in the DVM for the synthetic.
2271      * @param _syntheticName name for the token contract that will be deployed.
2272      * @param _syntheticSymbol symbol for the token contract that will be deployed.
2273      * @param _tokenFactoryAddress deployed UMA token factory to create the synthetic token.
2274      * @param _minSponsorTokens minimum amount of collateral that must exist at any time in a position.
2275      * @param _timerAddress Contract that stores the current time in a testing environment.
2276      * Must be set to 0x0 for production environments that use live time.
2277      */
2278     constructor(
2279         uint256 _expirationTimestamp,
2280         uint256 _withdrawalLiveness,
2281         address _collateralAddress,
2282         address _finderAddress,
2283         bytes32 _priceIdentifier,
2284         string memory _syntheticName,
2285         string memory _syntheticSymbol,
2286         address _tokenFactoryAddress,
2287         FixedPoint.Unsigned memory _minSponsorTokens,
2288         address _timerAddress
2289     ) public FeePayer(_collateralAddress, _finderAddress, _timerAddress) nonReentrant() {
2290         require(_expirationTimestamp > getCurrentTime(), "Invalid expiration in future");
2291         require(_getIdentifierWhitelist().isIdentifierSupported(_priceIdentifier), "Unsupported price identifier");
2292 
2293         expirationTimestamp = _expirationTimestamp;
2294         withdrawalLiveness = _withdrawalLiveness;
2295         TokenFactory tf = TokenFactory(_tokenFactoryAddress);
2296         tokenCurrency = tf.createToken(_syntheticName, _syntheticSymbol, 18);
2297         minSponsorTokens = _minSponsorTokens;
2298         priceIdentifier = _priceIdentifier;
2299     }
2300 
2301     /****************************************
2302      *          POSITION FUNCTIONS          *
2303      ****************************************/
2304 
2305     /**
2306      * @notice Requests to transfer ownership of the caller's current position to a new sponsor address.
2307      * Once the request liveness is passed, the sponsor can execute the transfer and specify the new sponsor.
2308      * @dev The liveness length is the same as the withdrawal liveness.
2309      */
2310     function requestTransferPosition() public onlyPreExpiration() nonReentrant() {
2311         PositionData storage positionData = _getPositionData(msg.sender);
2312         require(positionData.transferPositionRequestPassTimestamp == 0, "Pending transfer");
2313 
2314         // Make sure the proposed expiration of this request is not post-expiry.
2315         uint256 requestPassTime = getCurrentTime().add(withdrawalLiveness);
2316         require(requestPassTime < expirationTimestamp, "Request expires post-expiry");
2317 
2318         // Update the position object for the user.
2319         positionData.transferPositionRequestPassTimestamp = requestPassTime;
2320 
2321         emit RequestTransferPosition(msg.sender);
2322     }
2323 
2324     /**
2325      * @notice After a passed transfer position request (i.e., by a call to `requestTransferPosition` and waiting
2326      * `withdrawalLiveness`), transfers ownership of the caller's current position to `newSponsorAddress`.
2327      * @dev Transferring positions can only occur if the recipient does not already have a position.
2328      * @param newSponsorAddress is the address to which the position will be transferred.
2329      */
2330     function transferPositionPassedRequest(address newSponsorAddress)
2331         public
2332         onlyPreExpiration()
2333         noPendingWithdrawal(msg.sender)
2334         nonReentrant()
2335     {
2336         require(
2337             _getFeeAdjustedCollateral(positions[newSponsorAddress].rawCollateral).isEqual(
2338                 FixedPoint.fromUnscaledUint(0)
2339             ),
2340             "Sponsor already has position"
2341         );
2342         PositionData storage positionData = _getPositionData(msg.sender);
2343         require(
2344             positionData.transferPositionRequestPassTimestamp != 0 &&
2345                 positionData.transferPositionRequestPassTimestamp <= getCurrentTime(),
2346             "Invalid transfer request"
2347         );
2348 
2349         // Reset transfer request.
2350         positionData.transferPositionRequestPassTimestamp = 0;
2351 
2352         positions[newSponsorAddress] = positionData;
2353         delete positions[msg.sender];
2354 
2355         emit RequestTransferPositionExecuted(msg.sender, newSponsorAddress);
2356         emit NewSponsor(newSponsorAddress);
2357         emit EndedSponsorPosition(msg.sender);
2358     }
2359 
2360     /**
2361      * @notice Cancels a pending transfer position request.
2362      */
2363     function cancelTransferPosition() external onlyPreExpiration() nonReentrant() {
2364         PositionData storage positionData = _getPositionData(msg.sender);
2365         require(positionData.transferPositionRequestPassTimestamp != 0, "No pending transfer");
2366 
2367         emit RequestTransferPositionCanceled(msg.sender);
2368 
2369         // Reset withdrawal request.
2370         positionData.transferPositionRequestPassTimestamp = 0;
2371     }
2372 
2373     /**
2374      * @notice Transfers `collateralAmount` of `collateralCurrency` into the specified sponsor's position.
2375      * @dev Increases the collateralization level of a position after creation. This contract must be approved to spend
2376      * at least `collateralAmount` of `collateralCurrency`.
2377      * @param sponsor the sponsor to credit the deposit to.
2378      * @param collateralAmount total amount of collateral tokens to be sent to the sponsor's position.
2379      */
2380     function depositTo(address sponsor, FixedPoint.Unsigned memory collateralAmount)
2381         public
2382         onlyPreExpiration()
2383         noPendingWithdrawal(sponsor)
2384         fees()
2385         nonReentrant()
2386     {
2387         require(collateralAmount.isGreaterThan(0), "Invalid collateral amount");
2388         PositionData storage positionData = _getPositionData(sponsor);
2389 
2390         // Increase the position and global collateral balance by collateral amount.
2391         _incrementCollateralBalances(positionData, collateralAmount);
2392 
2393         emit Deposit(sponsor, collateralAmount.rawValue);
2394 
2395         // Move collateral currency from sender to contract.
2396         collateralCurrency.safeTransferFrom(msg.sender, address(this), collateralAmount.rawValue);
2397     }
2398 
2399     /**
2400      * @notice Transfers `collateralAmount` of `collateralCurrency` into the caller's position.
2401      * @dev Increases the collateralization level of a position after creation. This contract must be approved to spend
2402      * at least `collateralAmount` of `collateralCurrency`.
2403      * @param collateralAmount total amount of collateral tokens to be sent to the sponsor's position.
2404      */
2405     function deposit(FixedPoint.Unsigned memory collateralAmount) public {
2406         // This is just a thin wrapper over depositTo that specified the sender as the sponsor.
2407         depositTo(msg.sender, collateralAmount);
2408     }
2409 
2410     /**
2411      * @notice Transfers `collateralAmount` of `collateralCurrency` from the sponsor's position to the sponsor.
2412      * @dev Reverts if the withdrawal puts this position's collateralization ratio below the global collateralization
2413      * ratio. In that case, use `requestWithdrawal`. Might not withdraw the full requested amount to account for precision loss.
2414      * @param collateralAmount is the amount of collateral to withdraw.
2415      * @return amountWithdrawn The actual amount of collateral withdrawn.
2416      */
2417     function withdraw(FixedPoint.Unsigned memory collateralAmount)
2418         public
2419         onlyPreExpiration()
2420         noPendingWithdrawal(msg.sender)
2421         fees()
2422         nonReentrant()
2423         returns (FixedPoint.Unsigned memory amountWithdrawn)
2424     {
2425         PositionData storage positionData = _getPositionData(msg.sender);
2426         require(collateralAmount.isGreaterThan(0), "Invalid collateral amount");
2427 
2428         // Decrement the sponsor's collateral and global collateral amounts. Check the GCR between decrement to ensure
2429         // position remains above the GCR within the witdrawl. If this is not the case the caller must submit a request.
2430         amountWithdrawn = _decrementCollateralBalancesCheckGCR(positionData, collateralAmount);
2431 
2432         emit Withdrawal(msg.sender, amountWithdrawn.rawValue);
2433 
2434         // Move collateral currency from contract to sender.
2435         // Note: that we move the amount of collateral that is decreased from rawCollateral (inclusive of fees)
2436         // instead of the user requested amount. This eliminates precision loss that could occur
2437         // where the user withdraws more collateral than rawCollateral is decremented by.
2438         collateralCurrency.safeTransfer(msg.sender, amountWithdrawn.rawValue);
2439     }
2440 
2441     /**
2442      * @notice Starts a withdrawal request that, if passed, allows the sponsor to withdraw` from their position.
2443      * @dev The request will be pending for `withdrawalLiveness`, during which the position can be liquidated.
2444      * @param collateralAmount the amount of collateral requested to withdraw
2445      */
2446     function requestWithdrawal(FixedPoint.Unsigned memory collateralAmount)
2447         public
2448         onlyPreExpiration()
2449         noPendingWithdrawal(msg.sender)
2450         nonReentrant()
2451     {
2452         PositionData storage positionData = _getPositionData(msg.sender);
2453         require(
2454             collateralAmount.isGreaterThan(0) &&
2455                 collateralAmount.isLessThanOrEqual(_getFeeAdjustedCollateral(positionData.rawCollateral)),
2456             "Invalid collateral amount"
2457         );
2458 
2459         // Make sure the proposed expiration of this request is not post-expiry.
2460         uint256 requestPassTime = getCurrentTime().add(withdrawalLiveness);
2461         require(requestPassTime < expirationTimestamp, "Request expires post-expiry");
2462 
2463         // Update the position object for the user.
2464         positionData.withdrawalRequestPassTimestamp = requestPassTime;
2465         positionData.withdrawalRequestAmount = collateralAmount;
2466 
2467         emit RequestWithdrawal(msg.sender, collateralAmount.rawValue);
2468     }
2469 
2470     /**
2471      * @notice After a passed withdrawal request (i.e., by a call to `requestWithdrawal` and waiting
2472      * `withdrawalLiveness`), withdraws `positionData.withdrawalRequestAmount` of collateral currency.
2473      * @dev Might not withdraw the full requested amount in order to account for precision loss or if the full requested
2474      * amount exceeds the collateral in the position (due to paying fees).
2475      * @return amountWithdrawn The actual amount of collateral withdrawn.
2476      */
2477     function withdrawPassedRequest()
2478         external
2479         onlyPreExpiration()
2480         fees()
2481         nonReentrant()
2482         returns (FixedPoint.Unsigned memory amountWithdrawn)
2483     {
2484         PositionData storage positionData = _getPositionData(msg.sender);
2485         require(
2486             positionData.withdrawalRequestPassTimestamp != 0 &&
2487                 positionData.withdrawalRequestPassTimestamp <= getCurrentTime(),
2488             "Invalid withdraw request"
2489         );
2490 
2491         // If withdrawal request amount is > position collateral, then withdraw the full collateral amount.
2492         // This situation is possible due to fees charged since the withdrawal was originally requested.
2493         FixedPoint.Unsigned memory amountToWithdraw = positionData.withdrawalRequestAmount;
2494         if (positionData.withdrawalRequestAmount.isGreaterThan(_getFeeAdjustedCollateral(positionData.rawCollateral))) {
2495             amountToWithdraw = _getFeeAdjustedCollateral(positionData.rawCollateral);
2496         }
2497 
2498         // Decrement the sponsor's collateral and global collateral amounts.
2499         amountWithdrawn = _decrementCollateralBalances(positionData, amountToWithdraw);
2500 
2501         // Reset withdrawal request by setting withdrawal amount and withdrawal timestamp to 0.
2502         _resetWithdrawalRequest(positionData);
2503 
2504         // Transfer approved withdrawal amount from the contract to the caller.
2505         collateralCurrency.safeTransfer(msg.sender, amountWithdrawn.rawValue);
2506 
2507         emit RequestWithdrawalExecuted(msg.sender, amountWithdrawn.rawValue);
2508     }
2509 
2510     /**
2511      * @notice Cancels a pending withdrawal request.
2512      */
2513     function cancelWithdrawal() external onlyPreExpiration() nonReentrant() {
2514         PositionData storage positionData = _getPositionData(msg.sender);
2515         require(positionData.withdrawalRequestPassTimestamp != 0, "No pending withdrawal");
2516 
2517         emit RequestWithdrawalCanceled(msg.sender, positionData.withdrawalRequestAmount.rawValue);
2518 
2519         // Reset withdrawal request by setting withdrawal amount and withdrawal timestamp to 0.
2520         _resetWithdrawalRequest(positionData);
2521     }
2522 
2523     /**
2524      * @notice Creates tokens by creating a new position or by augmenting an existing position. Pulls `collateralAmount` into the sponsor's position and mints `numTokens` of `tokenCurrency`.
2525      * @dev Reverts if minting these tokens would put the position's collateralization ratio below the
2526      * global collateralization ratio. This contract must be approved to spend at least `collateralAmount` of
2527      * `collateralCurrency`.
2528      * @param collateralAmount is the number of collateral tokens to collateralize the position with
2529      * @param numTokens is the number of tokens to mint from the position.
2530      */
2531     function create(FixedPoint.Unsigned memory collateralAmount, FixedPoint.Unsigned memory numTokens)
2532         public
2533         onlyPreExpiration()
2534         fees()
2535         nonReentrant()
2536     {
2537         require(_checkCollateralization(collateralAmount, numTokens), "CR below GCR");
2538 
2539         PositionData storage positionData = positions[msg.sender];
2540         require(positionData.withdrawalRequestPassTimestamp == 0, "Pending withdrawal");
2541         if (positionData.tokensOutstanding.isEqual(0)) {
2542             require(numTokens.isGreaterThanOrEqual(minSponsorTokens), "Below minimum sponsor position");
2543             emit NewSponsor(msg.sender);
2544         }
2545 
2546         // Increase the position and global collateral balance by collateral amount.
2547         _incrementCollateralBalances(positionData, collateralAmount);
2548 
2549         // Add the number of tokens created to the position's outstanding tokens.
2550         positionData.tokensOutstanding = positionData.tokensOutstanding.add(numTokens);
2551 
2552         totalTokensOutstanding = totalTokensOutstanding.add(numTokens);
2553 
2554         emit PositionCreated(msg.sender, collateralAmount.rawValue, numTokens.rawValue);
2555 
2556         // Transfer tokens into the contract from caller and mint corresponding synthetic tokens to the caller's address.
2557         collateralCurrency.safeTransferFrom(msg.sender, address(this), collateralAmount.rawValue);
2558         require(tokenCurrency.mint(msg.sender, numTokens.rawValue), "Minting synthetic tokens failed");
2559     }
2560 
2561     /**
2562      * @notice Burns `numTokens` of `tokenCurrency` and sends back the proportional amount of `collateralCurrency`.
2563      * @dev Can only be called by a token sponsor. Might not redeem the full proportional amount of collateral
2564      * in order to account for precision loss. This contract must be approved to spend at least `numTokens` of
2565      * `tokenCurrency`.
2566      * @param numTokens is the number of tokens to be burnt for a commensurate amount of collateral.
2567      * @return amountWithdrawn The actual amount of collateral withdrawn.
2568      */
2569     function redeem(FixedPoint.Unsigned memory numTokens)
2570         public
2571         onlyPreExpiration()
2572         noPendingWithdrawal(msg.sender)
2573         fees()
2574         nonReentrant()
2575         returns (FixedPoint.Unsigned memory amountWithdrawn)
2576     {
2577         PositionData storage positionData = _getPositionData(msg.sender);
2578         require(!numTokens.isGreaterThan(positionData.tokensOutstanding), "Invalid token amount");
2579 
2580         FixedPoint.Unsigned memory fractionRedeemed = numTokens.div(positionData.tokensOutstanding);
2581         FixedPoint.Unsigned memory collateralRedeemed = fractionRedeemed.mul(
2582             _getFeeAdjustedCollateral(positionData.rawCollateral)
2583         );
2584 
2585         // If redemption returns all tokens the sponsor has then we can delete their position. Else, downsize.
2586         if (positionData.tokensOutstanding.isEqual(numTokens)) {
2587             amountWithdrawn = _deleteSponsorPosition(msg.sender);
2588         } else {
2589             // Decrement the sponsor's collateral and global collateral amounts.
2590             amountWithdrawn = _decrementCollateralBalances(positionData, collateralRedeemed);
2591 
2592             // Decrease the sponsors position tokens size. Ensure it is above the min sponsor size.
2593             FixedPoint.Unsigned memory newTokenCount = positionData.tokensOutstanding.sub(numTokens);
2594             require(newTokenCount.isGreaterThanOrEqual(minSponsorTokens), "Below minimum sponsor position");
2595             positionData.tokensOutstanding = newTokenCount;
2596 
2597             // Update the totalTokensOutstanding after redemption.
2598             totalTokensOutstanding = totalTokensOutstanding.sub(numTokens);
2599         }
2600 
2601         emit Redeem(msg.sender, amountWithdrawn.rawValue, numTokens.rawValue);
2602 
2603         // Transfer collateral from contract to caller and burn callers synthetic tokens.
2604         collateralCurrency.safeTransfer(msg.sender, amountWithdrawn.rawValue);
2605         tokenCurrency.safeTransferFrom(msg.sender, address(this), numTokens.rawValue);
2606         tokenCurrency.burn(numTokens.rawValue);
2607     }
2608 
2609     /**
2610      * @notice After a contract has passed expiry all token holders can redeem their tokens for underlying at the
2611      * prevailing price defined by the DVM from the `expire` function.
2612      * @dev This burns all tokens from the caller of `tokenCurrency` and sends back the proportional amount of
2613      * `collateralCurrency`. Might not redeem the full proportional amount of collateral in order to account for
2614      * precision loss. This contract must be approved to spend `tokenCurrency` at least up to the caller's full balance.
2615      * @return amountWithdrawn The actual amount of collateral withdrawn.
2616      */
2617     function settleExpired()
2618         external
2619         onlyPostExpiration()
2620         fees()
2621         nonReentrant()
2622         returns (FixedPoint.Unsigned memory amountWithdrawn)
2623     {
2624         // If the contract state is open and onlyPostExpiration passed then `expire()` has not yet been called.
2625         require(contractState != ContractState.Open, "Unexpired position");
2626 
2627         // Get the current settlement price and store it. If it is not resolved will revert.
2628         if (contractState != ContractState.ExpiredPriceReceived) {
2629             expiryPrice = _getOraclePrice(expirationTimestamp);
2630             contractState = ContractState.ExpiredPriceReceived;
2631         }
2632 
2633         // Get caller's tokens balance and calculate amount of underlying entitled to them.
2634         FixedPoint.Unsigned memory tokensToRedeem = FixedPoint.Unsigned(tokenCurrency.balanceOf(msg.sender));
2635         FixedPoint.Unsigned memory totalRedeemableCollateral = tokensToRedeem.mul(expiryPrice);
2636 
2637         // If the caller is a sponsor with outstanding collateral they are also entitled to their excess collateral after their debt.
2638         PositionData storage positionData = positions[msg.sender];
2639         if (_getFeeAdjustedCollateral(positionData.rawCollateral).isGreaterThan(0)) {
2640             // Calculate the underlying entitled to a token sponsor. This is collateral - debt in underlying.
2641             FixedPoint.Unsigned memory tokenDebtValueInCollateral = positionData.tokensOutstanding.mul(expiryPrice);
2642             FixedPoint.Unsigned memory positionCollateral = _getFeeAdjustedCollateral(positionData.rawCollateral);
2643 
2644             // If the debt is greater than the remaining collateral, they cannot redeem anything.
2645             FixedPoint.Unsigned memory positionRedeemableCollateral = tokenDebtValueInCollateral.isLessThan(
2646                 positionCollateral
2647             )
2648                 ? positionCollateral.sub(tokenDebtValueInCollateral)
2649                 : FixedPoint.Unsigned(0);
2650 
2651             // Add the number of redeemable tokens for the sponsor to their total redeemable collateral.
2652             totalRedeemableCollateral = totalRedeemableCollateral.add(positionRedeemableCollateral);
2653 
2654             // Reset the position state as all the value has been removed after settlement.
2655             delete positions[msg.sender];
2656             emit EndedSponsorPosition(msg.sender);
2657         }
2658 
2659         // Take the min of the remaining collateral and the collateral "owed". If the contract is undercapitalized,
2660         // the caller will get as much collateral as the contract can pay out.
2661         FixedPoint.Unsigned memory payout = FixedPoint.min(
2662             _getFeeAdjustedCollateral(rawTotalPositionCollateral),
2663             totalRedeemableCollateral
2664         );
2665 
2666         // Decrement total contract collateral and outstanding debt.
2667         amountWithdrawn = _removeCollateral(rawTotalPositionCollateral, payout);
2668         totalTokensOutstanding = totalTokensOutstanding.sub(tokensToRedeem);
2669 
2670         emit SettleExpiredPosition(msg.sender, amountWithdrawn.rawValue, tokensToRedeem.rawValue);
2671 
2672         // Transfer tokens & collateral and burn the redeemed tokens.
2673         collateralCurrency.safeTransfer(msg.sender, amountWithdrawn.rawValue);
2674         tokenCurrency.safeTransferFrom(msg.sender, address(this), tokensToRedeem.rawValue);
2675         tokenCurrency.burn(tokensToRedeem.rawValue);
2676     }
2677 
2678     /****************************************
2679      *        GLOBAL STATE FUNCTIONS        *
2680      ****************************************/
2681 
2682     /**
2683      * @notice Locks contract state in expired and requests oracle price.
2684      * @dev this function can only be called once the contract is expired and can't be re-called.
2685      */
2686     function expire() external onlyPostExpiration() onlyOpenState() fees() nonReentrant() {
2687         contractState = ContractState.ExpiredPriceRequested;
2688 
2689         // The final fee for this request is paid out of the contract rather than by the caller.
2690         _payFinalFees(address(this), _computeFinalFees());
2691         _requestOraclePrice(expirationTimestamp);
2692 
2693         emit ContractExpired(msg.sender);
2694     }
2695 
2696     /**
2697      * @notice Premature contract settlement under emergency circumstances.
2698      * @dev Only the governor can call this function as they are permissioned within the `FinancialContractAdmin`.
2699      * Upon emergency shutdown, the contract settlement time is set to the shutdown time. This enables withdrawal
2700      * to occur via the standard `settleExpired` function. Contract state is set to `ExpiredPriceRequested`
2701      * which prevents re-entry into this function or the `expire` function. No fees are paid when calling
2702      * `emergencyShutdown` as the governor who would call the function would also receive the fees.
2703      */
2704     function emergencyShutdown() external override onlyPreExpiration() onlyOpenState() nonReentrant() {
2705         require(msg.sender == _getFinancialContractsAdminAddress(), "Caller not Governor");
2706 
2707         contractState = ContractState.ExpiredPriceRequested;
2708         // Expiratory time now becomes the current time (emergency shutdown time).
2709         // Price requested at this time stamp. `settleExpired` can now withdraw at this timestamp.
2710         uint256 oldExpirationTimestamp = expirationTimestamp;
2711         expirationTimestamp = getCurrentTime();
2712         _requestOraclePrice(expirationTimestamp);
2713 
2714         emit EmergencyShutdown(msg.sender, oldExpirationTimestamp, expirationTimestamp);
2715     }
2716 
2717     /**
2718      * @notice Theoretically supposed to pay fees and move money between margin accounts to make sure they
2719      * reflect the NAV of the contract. However, this functionality doesn't apply to this contract.
2720      * @dev This is supposed to be implemented by any contract that inherits `AdministrateeInterface` and callable
2721      * only by the Governor contract. This method is therefore minimally implemented in this contract and does nothing.
2722      */
2723     function remargin() external override onlyPreExpiration() nonReentrant() {
2724         return;
2725     }
2726 
2727     /**
2728      * @notice Accessor method for a sponsor's collateral.
2729      * @dev This is necessary because the struct returned by the positions() method shows
2730      * rawCollateral, which isn't a user-readable value.
2731      * @param sponsor address whose collateral amount is retrieved.
2732      * @return collateralAmount amount of collateral within a sponsors position.
2733      */
2734     function getCollateral(address sponsor)
2735         external
2736         view
2737         nonReentrantView()
2738         returns (FixedPoint.Unsigned memory collateralAmount)
2739     {
2740         // Note: do a direct access to avoid the validity check.
2741         return _getFeeAdjustedCollateral(positions[sponsor].rawCollateral);
2742     }
2743 
2744     /**
2745      * @notice Accessor method for the total collateral stored within the PricelessPositionManager.
2746      * @return totalCollateral amount of all collateral within the Expiring Multi Party Contract.
2747      */
2748     function totalPositionCollateral()
2749         external
2750         view
2751         nonReentrantView()
2752         returns (FixedPoint.Unsigned memory totalCollateral)
2753     {
2754         return _getFeeAdjustedCollateral(rawTotalPositionCollateral);
2755     }
2756 
2757     /****************************************
2758      *          INTERNAL FUNCTIONS          *
2759      ****************************************/
2760 
2761     // Reduces a sponsor's position and global counters by the specified parameters. Handles deleting the entire
2762     // position if the entire position is being removed. Does not make any external transfers.
2763     function _reduceSponsorPosition(
2764         address sponsor,
2765         FixedPoint.Unsigned memory tokensToRemove,
2766         FixedPoint.Unsigned memory collateralToRemove,
2767         FixedPoint.Unsigned memory withdrawalAmountToRemove
2768     ) internal {
2769         PositionData storage positionData = _getPositionData(sponsor);
2770 
2771         // If the entire position is being removed, delete it instead.
2772         if (
2773             tokensToRemove.isEqual(positionData.tokensOutstanding) &&
2774             _getFeeAdjustedCollateral(positionData.rawCollateral).isEqual(collateralToRemove)
2775         ) {
2776             _deleteSponsorPosition(sponsor);
2777             return;
2778         }
2779 
2780         // Decrement the sponsor's collateral and global collateral amounts.
2781         _decrementCollateralBalances(positionData, collateralToRemove);
2782 
2783         // Ensure that the sponsor will meet the min position size after the reduction.
2784         FixedPoint.Unsigned memory newTokenCount = positionData.tokensOutstanding.sub(tokensToRemove);
2785         require(newTokenCount.isGreaterThanOrEqual(minSponsorTokens), "Below minimum sponsor position");
2786         positionData.tokensOutstanding = newTokenCount;
2787 
2788         // Decrement the position's withdrawal amount.
2789         positionData.withdrawalRequestAmount = positionData.withdrawalRequestAmount.sub(withdrawalAmountToRemove);
2790 
2791         // Decrement the total outstanding tokens in the overall contract.
2792         totalTokensOutstanding = totalTokensOutstanding.sub(tokensToRemove);
2793     }
2794 
2795     // Deletes a sponsor's position and updates global counters. Does not make any external transfers.
2796     function _deleteSponsorPosition(address sponsor) internal returns (FixedPoint.Unsigned memory) {
2797         PositionData storage positionToLiquidate = _getPositionData(sponsor);
2798 
2799         FixedPoint.Unsigned memory startingGlobalCollateral = _getFeeAdjustedCollateral(rawTotalPositionCollateral);
2800 
2801         // Remove the collateral and outstanding from the overall total position.
2802         FixedPoint.Unsigned memory remainingRawCollateral = positionToLiquidate.rawCollateral;
2803         rawTotalPositionCollateral = rawTotalPositionCollateral.sub(remainingRawCollateral);
2804         totalTokensOutstanding = totalTokensOutstanding.sub(positionToLiquidate.tokensOutstanding);
2805 
2806         // Reset the sponsors position to have zero outstanding and collateral.
2807         delete positions[sponsor];
2808 
2809         emit EndedSponsorPosition(sponsor);
2810 
2811         // Return fee-adjusted amount of collateral deleted from position.
2812         return startingGlobalCollateral.sub(_getFeeAdjustedCollateral(rawTotalPositionCollateral));
2813     }
2814 
2815     function _pfc() internal virtual override view returns (FixedPoint.Unsigned memory) {
2816         return _getFeeAdjustedCollateral(rawTotalPositionCollateral);
2817     }
2818 
2819     function _getPositionData(address sponsor)
2820         internal
2821         view
2822         onlyCollateralizedPosition(sponsor)
2823         returns (PositionData storage)
2824     {
2825         return positions[sponsor];
2826     }
2827 
2828     function _getIdentifierWhitelist() internal view returns (IdentifierWhitelistInterface) {
2829         return IdentifierWhitelistInterface(finder.getImplementationAddress(OracleInterfaces.IdentifierWhitelist));
2830     }
2831 
2832     function _getOracle() internal view returns (OracleInterface) {
2833         return OracleInterface(finder.getImplementationAddress(OracleInterfaces.Oracle));
2834     }
2835 
2836     function _getFinancialContractsAdminAddress() internal view returns (address) {
2837         return finder.getImplementationAddress(OracleInterfaces.FinancialContractsAdmin);
2838     }
2839 
2840     // Requests a price for `priceIdentifier` at `requestedTime` from the Oracle.
2841     function _requestOraclePrice(uint256 requestedTime) internal {
2842         OracleInterface oracle = _getOracle();
2843         oracle.requestPrice(priceIdentifier, requestedTime);
2844     }
2845 
2846     // Fetches a resolved Oracle price from the Oracle. Reverts if the Oracle hasn't resolved for this request.
2847     function _getOraclePrice(uint256 requestedTime) internal view returns (FixedPoint.Unsigned memory) {
2848         // Create an instance of the oracle and get the price. If the price is not resolved revert.
2849         OracleInterface oracle = _getOracle();
2850         require(oracle.hasPrice(priceIdentifier, requestedTime), "Unresolved oracle price");
2851         int256 oraclePrice = oracle.getPrice(priceIdentifier, requestedTime);
2852 
2853         // For now we don't want to deal with negative prices in positions.
2854         if (oraclePrice < 0) {
2855             oraclePrice = 0;
2856         }
2857         return FixedPoint.Unsigned(uint256(oraclePrice));
2858     }
2859 
2860     // Reset withdrawal request by setting the withdrawal request and withdrawal timestamp to 0.
2861     function _resetWithdrawalRequest(PositionData storage positionData) internal {
2862         positionData.withdrawalRequestAmount = FixedPoint.fromUnscaledUint(0);
2863         positionData.withdrawalRequestPassTimestamp = 0;
2864     }
2865 
2866     // Ensure individual and global consistency when increasing collateral balances. Returns the change to the position.
2867     function _incrementCollateralBalances(
2868         PositionData storage positionData,
2869         FixedPoint.Unsigned memory collateralAmount
2870     ) internal returns (FixedPoint.Unsigned memory) {
2871         _addCollateral(positionData.rawCollateral, collateralAmount);
2872         return _addCollateral(rawTotalPositionCollateral, collateralAmount);
2873     }
2874 
2875     // Ensure individual and global consistency when decrementing collateral balances. Returns the change to the
2876     // position. We elect to return the amount that the global collateral is decreased by, rather than the individual
2877     // position's collateral, because we need to maintain the invariant that the global collateral is always
2878     // <= the collateral owned by the contract to avoid reverts on withdrawals. The amount returned = amount withdrawn.
2879     function _decrementCollateralBalances(
2880         PositionData storage positionData,
2881         FixedPoint.Unsigned memory collateralAmount
2882     ) internal returns (FixedPoint.Unsigned memory) {
2883         _removeCollateral(positionData.rawCollateral, collateralAmount);
2884         return _removeCollateral(rawTotalPositionCollateral, collateralAmount);
2885     }
2886 
2887     // Ensure individual and global consistency when decrementing collateral balances. Returns the change to the position.
2888     // This function is similar to the _decrementCollateralBalances function except this function checks position GCR
2889     // between the decrements. This ensures that collateral removal will not leave the position undercollateralized.
2890     function _decrementCollateralBalancesCheckGCR(
2891         PositionData storage positionData,
2892         FixedPoint.Unsigned memory collateralAmount
2893     ) internal returns (FixedPoint.Unsigned memory) {
2894         _removeCollateral(positionData.rawCollateral, collateralAmount);
2895         require(_checkPositionCollateralization(positionData), "CR below GCR");
2896         return _removeCollateral(rawTotalPositionCollateral, collateralAmount);
2897     }
2898 
2899     // These internal functions are supposed to act identically to modifiers, but re-used modifiers
2900     // unnecessarily increase contract bytecode size.
2901     // source: https://blog.polymath.network/solidity-tips-and-tricks-to-save-gas-and-reduce-bytecode-size-c44580b218e6
2902     function _onlyOpenState() internal view {
2903         require(contractState == ContractState.Open, "Contract state is not OPEN");
2904     }
2905 
2906     function _onlyPreExpiration() internal view {
2907         require(getCurrentTime() < expirationTimestamp, "Only callable pre-expiry");
2908     }
2909 
2910     function _onlyPostExpiration() internal view {
2911         require(getCurrentTime() >= expirationTimestamp, "Only callable post-expiry");
2912     }
2913 
2914     function _onlyCollateralizedPosition(address sponsor) internal view {
2915         require(
2916             _getFeeAdjustedCollateral(positions[sponsor].rawCollateral).isGreaterThan(0),
2917             "Position has no collateral"
2918         );
2919     }
2920 
2921     // Note: This checks whether an already existing position has a pending withdrawal. This cannot be used on the
2922     // `create` method because it is possible that `create` is called on a new position (i.e. one without any collateral
2923     // or tokens outstanding) which would fail the `onlyCollateralizedPosition` modifier on `_getPositionData`.
2924     function _positionHasNoPendingWithdrawal(address sponsor) internal view {
2925         require(_getPositionData(sponsor).withdrawalRequestPassTimestamp == 0, "Pending withdrawal");
2926     }
2927 
2928     /****************************************
2929      *          PRIVATE FUNCTIONS          *
2930      ****************************************/
2931 
2932     function _checkPositionCollateralization(PositionData storage positionData) private view returns (bool) {
2933         return
2934             _checkCollateralization(
2935                 _getFeeAdjustedCollateral(positionData.rawCollateral),
2936                 positionData.tokensOutstanding
2937             );
2938     }
2939 
2940     // Checks whether the provided `collateral` and `numTokens` have a collateralization ratio above the global
2941     // collateralization ratio.
2942     function _checkCollateralization(FixedPoint.Unsigned memory collateral, FixedPoint.Unsigned memory numTokens)
2943         private
2944         view
2945         returns (bool)
2946     {
2947         FixedPoint.Unsigned memory global = _getCollateralizationRatio(
2948             _getFeeAdjustedCollateral(rawTotalPositionCollateral),
2949             totalTokensOutstanding
2950         );
2951         FixedPoint.Unsigned memory thisChange = _getCollateralizationRatio(collateral, numTokens);
2952         return !global.isGreaterThan(thisChange);
2953     }
2954 
2955     function _getCollateralizationRatio(FixedPoint.Unsigned memory collateral, FixedPoint.Unsigned memory numTokens)
2956         private
2957         pure
2958         returns (FixedPoint.Unsigned memory ratio)
2959     {
2960         if (!numTokens.isGreaterThan(0)) {
2961             return FixedPoint.fromUnscaledUint(0);
2962         } else {
2963             return collateral.div(numTokens);
2964         }
2965     }
2966 }
2967 
2968 // File: contracts/financial-templates/expiring-multiparty/Liquidatable.sol
2969 
2970 pragma solidity ^0.6.0;
2971 
2972 
2973 
2974 
2975 
2976 
2977 /**
2978  * @title Liquidatable
2979  * @notice Adds logic to a position-managing contract that enables callers to liquidate an undercollateralized position.
2980  * @dev The liquidation has a liveness period before expiring successfully, during which someone can "dispute" the
2981  * liquidation, which sends a price request to the relevant Oracle to settle the final collateralization ratio based on
2982  * a DVM price. The contract enforces dispute rewards in order to incentivize disputers to correctly dispute false
2983  * liquidations and compensate position sponsors who had their position incorrectly liquidated. Importantly, a
2984  * prospective disputer must deposit a dispute bond that they can lose in the case of an unsuccessful dispute.
2985  */
2986 contract Liquidatable is PricelessPositionManager {
2987     using FixedPoint for FixedPoint.Unsigned;
2988     using SafeMath for uint256;
2989     using SafeERC20 for IERC20;
2990 
2991     /****************************************
2992      *     LIQUIDATION DATA STRUCTURES      *
2993      ****************************************/
2994 
2995     // Because of the check in withdrawable(), the order of these enum values should not change.
2996     enum Status { Uninitialized, PreDispute, PendingDispute, DisputeSucceeded, DisputeFailed }
2997 
2998     struct LiquidationData {
2999         // Following variables set upon creation of liquidation:
3000         address sponsor; // Address of the liquidated position's sponsor
3001         address liquidator; // Address who created this liquidation
3002         Status state; // Liquidated (and expired or not), Pending a Dispute, or Dispute has resolved
3003         uint256 liquidationTime; // Time when liquidation is initiated, needed to get price from Oracle
3004         // Following variables determined by the position that is being liquidated:
3005         FixedPoint.Unsigned tokensOutstanding; // Synthetic tokens required to be burned by liquidator to initiate dispute
3006         FixedPoint.Unsigned lockedCollateral; // Collateral locked by contract and released upon expiry or post-dispute
3007         // Amount of collateral being liquidated, which could be different from
3008         // lockedCollateral if there were pending withdrawals at the time of liquidation
3009         FixedPoint.Unsigned liquidatedCollateral;
3010         // Unit value (starts at 1) that is used to track the fees per unit of collateral over the course of the liquidation.
3011         FixedPoint.Unsigned rawUnitCollateral;
3012         // Following variable set upon initiation of a dispute:
3013         address disputer; // Person who is disputing a liquidation
3014         // Following variable set upon a resolution of a dispute:
3015         FixedPoint.Unsigned settlementPrice; // Final price as determined by an Oracle following a dispute
3016         FixedPoint.Unsigned finalFee;
3017     }
3018 
3019     // Define the contract's constructor parameters as a struct to enable more variables to be specified.
3020     // This is required to enable more params, over and above Solidity's limits.
3021     struct ConstructorParams {
3022         // Params for PricelessPositionManager only.
3023         uint256 expirationTimestamp;
3024         uint256 withdrawalLiveness;
3025         address collateralAddress;
3026         address finderAddress;
3027         address tokenFactoryAddress;
3028         address timerAddress;
3029         bytes32 priceFeedIdentifier;
3030         string syntheticName;
3031         string syntheticSymbol;
3032         FixedPoint.Unsigned minSponsorTokens;
3033         // Params specifically for Liquidatable.
3034         uint256 liquidationLiveness;
3035         FixedPoint.Unsigned collateralRequirement;
3036         FixedPoint.Unsigned disputeBondPct;
3037         FixedPoint.Unsigned sponsorDisputeRewardPct;
3038         FixedPoint.Unsigned disputerDisputeRewardPct;
3039     }
3040 
3041     // Liquidations are unique by ID per sponsor
3042     mapping(address => LiquidationData[]) public liquidations;
3043 
3044     // Total collateral in liquidation.
3045     FixedPoint.Unsigned public rawLiquidationCollateral;
3046 
3047     // Immutable contract parameters:
3048     // Amount of time for pending liquidation before expiry.
3049     uint256 public liquidationLiveness;
3050     // Required collateral:TRV ratio for a position to be considered sufficiently collateralized.
3051     FixedPoint.Unsigned public collateralRequirement;
3052     // Percent of a Liquidation/Position's lockedCollateral to be deposited by a potential disputer
3053     // Represented as a multiplier, for example 1.5e18 = "150%" and 0.05e18 = "5%"
3054     FixedPoint.Unsigned public disputeBondPct;
3055     // Percent of oraclePrice paid to sponsor in the Disputed state (i.e. following a successful dispute)
3056     // Represented as a multiplier, see above.
3057     FixedPoint.Unsigned public sponsorDisputeRewardPct;
3058     // Percent of oraclePrice paid to disputer in the Disputed state (i.e. following a successful dispute)
3059     // Represented as a multiplier, see above.
3060     FixedPoint.Unsigned public disputerDisputeRewardPct;
3061 
3062     /****************************************
3063      *                EVENTS                *
3064      ****************************************/
3065 
3066     event LiquidationCreated(
3067         address indexed sponsor,
3068         address indexed liquidator,
3069         uint256 indexed liquidationId,
3070         uint256 tokensOutstanding,
3071         uint256 lockedCollateral,
3072         uint256 liquidatedCollateral,
3073         uint256 liquidationTime
3074     );
3075     event LiquidationDisputed(
3076         address indexed sponsor,
3077         address indexed liquidator,
3078         address indexed disputer,
3079         uint256 liquidationId,
3080         uint256 disputeBondAmount
3081     );
3082     event DisputeSettled(
3083         address indexed caller,
3084         address indexed sponsor,
3085         address indexed liquidator,
3086         address disputer,
3087         uint256 liquidationId,
3088         bool disputeSucceeded
3089     );
3090     event LiquidationWithdrawn(
3091         address indexed caller,
3092         uint256 withdrawalAmount,
3093         Status indexed liquidationStatus,
3094         uint256 settlementPrice
3095     );
3096 
3097     /****************************************
3098      *              MODIFIERS               *
3099      ****************************************/
3100 
3101     modifier disputable(uint256 liquidationId, address sponsor) {
3102         _disputable(liquidationId, sponsor);
3103         _;
3104     }
3105 
3106     modifier withdrawable(uint256 liquidationId, address sponsor) {
3107         _withdrawable(liquidationId, sponsor);
3108         _;
3109     }
3110 
3111     /**
3112      * @notice Constructs the liquidatable contract.
3113      * @param params struct to define input parameters for construction of Liquidatable. Some params
3114      * are fed directly into the PricelessPositionManager's constructor within the inheritance tree.
3115      */
3116     constructor(ConstructorParams memory params)
3117         public
3118         PricelessPositionManager(
3119             params.expirationTimestamp,
3120             params.withdrawalLiveness,
3121             params.collateralAddress,
3122             params.finderAddress,
3123             params.priceFeedIdentifier,
3124             params.syntheticName,
3125             params.syntheticSymbol,
3126             params.tokenFactoryAddress,
3127             params.minSponsorTokens,
3128             params.timerAddress
3129         )
3130         nonReentrant()
3131     {
3132         require(params.collateralRequirement.isGreaterThan(1), "CR is more than 100%");
3133         require(
3134             params.sponsorDisputeRewardPct.add(params.disputerDisputeRewardPct).isLessThan(1),
3135             "Rewards are more than 100%"
3136         );
3137 
3138         // Set liquidatable specific variables.
3139         liquidationLiveness = params.liquidationLiveness;
3140         collateralRequirement = params.collateralRequirement;
3141         disputeBondPct = params.disputeBondPct;
3142         sponsorDisputeRewardPct = params.sponsorDisputeRewardPct;
3143         disputerDisputeRewardPct = params.disputerDisputeRewardPct;
3144     }
3145 
3146     /****************************************
3147      *        LIQUIDATION FUNCTIONS         *
3148      ****************************************/
3149 
3150     /**
3151      * @notice Liquidates the sponsor's position if the caller has enough
3152      * synthetic tokens to retire the position's outstanding tokens.
3153      * @dev This method generates an ID that will uniquely identify liquidation for the sponsor. This contract must be
3154      * approved to spend at least `tokensLiquidated` of `tokenCurrency` and at least `finalFeeBond` of `collateralCurrency`.
3155      * @param sponsor address of the sponsor to liquidate.
3156      * @param minCollateralPerToken abort the liquidation if the position's collateral per token is below this value.
3157      * @param maxCollateralPerToken abort the liquidation if the position's collateral per token exceeds this value.
3158      * @param maxTokensToLiquidate max number of tokens to liquidate.
3159      * @param deadline abort the liquidation if the transaction is mined after this timestamp.
3160      * @return liquidationId ID of the newly created liquidation.
3161      * @return tokensLiquidated amount of synthetic tokens removed and liquidated from the `sponsor`'s position.
3162      * @return finalFeeBond amount of collateral to be posted by liquidator and returned if not disputed successfully.
3163      */
3164     function createLiquidation(
3165         address sponsor,
3166         FixedPoint.Unsigned calldata minCollateralPerToken,
3167         FixedPoint.Unsigned calldata maxCollateralPerToken,
3168         FixedPoint.Unsigned calldata maxTokensToLiquidate,
3169         uint256 deadline
3170     )
3171         external
3172         fees()
3173         onlyPreExpiration()
3174         nonReentrant()
3175         returns (
3176             uint256 liquidationId,
3177             FixedPoint.Unsigned memory tokensLiquidated,
3178             FixedPoint.Unsigned memory finalFeeBond
3179         )
3180     {
3181         // Check that this transaction was mined pre-deadline.
3182         require(getCurrentTime() <= deadline, "Mined after deadline");
3183 
3184         // Retrieve Position data for sponsor
3185         PositionData storage positionToLiquidate = _getPositionData(sponsor);
3186 
3187         tokensLiquidated = FixedPoint.min(maxTokensToLiquidate, positionToLiquidate.tokensOutstanding);
3188 
3189         // Starting values for the Position being liquidated. If withdrawal request amount is > position's collateral,
3190         // then set this to 0, otherwise set it to (startCollateral - withdrawal request amount).
3191         FixedPoint.Unsigned memory startCollateral = _getFeeAdjustedCollateral(positionToLiquidate.rawCollateral);
3192         FixedPoint.Unsigned memory startCollateralNetOfWithdrawal = FixedPoint.fromUnscaledUint(0);
3193         if (positionToLiquidate.withdrawalRequestAmount.isLessThanOrEqual(startCollateral)) {
3194             startCollateralNetOfWithdrawal = startCollateral.sub(positionToLiquidate.withdrawalRequestAmount);
3195         }
3196 
3197         // Scoping to get rid of a stack too deep error.
3198         {
3199             FixedPoint.Unsigned memory startTokens = positionToLiquidate.tokensOutstanding;
3200 
3201             // The Position's collateralization ratio must be between [minCollateralPerToken, maxCollateralPerToken].
3202             // maxCollateralPerToken >= startCollateralNetOfWithdrawal / startTokens.
3203             require(
3204                 maxCollateralPerToken.mul(startTokens).isGreaterThanOrEqual(startCollateralNetOfWithdrawal),
3205                 "CR is more than max liq. price"
3206             );
3207             // minCollateralPerToken >= startCollateralNetOfWithdrawal / startTokens.
3208             require(
3209                 minCollateralPerToken.mul(startTokens).isLessThanOrEqual(startCollateralNetOfWithdrawal),
3210                 "CR is less than min liq. price"
3211             );
3212         }
3213 
3214         // Compute final fee at time of liquidation.
3215         finalFeeBond = _computeFinalFees();
3216 
3217         // These will be populated within the scope below.
3218         FixedPoint.Unsigned memory lockedCollateral;
3219         FixedPoint.Unsigned memory liquidatedCollateral;
3220 
3221         // Scoping to get rid of a stack too deep error.
3222         {
3223             FixedPoint.Unsigned memory ratio = tokensLiquidated.div(positionToLiquidate.tokensOutstanding);
3224 
3225             // The actual amount of collateral that gets moved to the liquidation.
3226             lockedCollateral = startCollateral.mul(ratio);
3227 
3228             // For purposes of disputes, it's actually this liquidatedCollateral value that's used. This value is net of
3229             // withdrawal requests.
3230             liquidatedCollateral = startCollateralNetOfWithdrawal.mul(ratio);
3231 
3232             // Part of the withdrawal request is also removed. Ideally:
3233             // liquidatedCollateral + withdrawalAmountToRemove = lockedCollateral.
3234             FixedPoint.Unsigned memory withdrawalAmountToRemove = positionToLiquidate.withdrawalRequestAmount.mul(
3235                 ratio
3236             );
3237             _reduceSponsorPosition(sponsor, tokensLiquidated, lockedCollateral, withdrawalAmountToRemove);
3238         }
3239 
3240         // Add to the global liquidation collateral count.
3241         _addCollateral(rawLiquidationCollateral, lockedCollateral.add(finalFeeBond));
3242 
3243         // Construct liquidation object.
3244         // Note: All dispute-related values are zeroed out until a dispute occurs. liquidationId is the index of the new
3245         // LiquidationData that is pushed into the array, which is equal to the current length of the array pre-push.
3246         liquidationId = liquidations[sponsor].length;
3247         liquidations[sponsor].push(
3248             LiquidationData({
3249                 sponsor: sponsor,
3250                 liquidator: msg.sender,
3251                 state: Status.PreDispute,
3252                 liquidationTime: getCurrentTime(),
3253                 tokensOutstanding: tokensLiquidated,
3254                 lockedCollateral: lockedCollateral,
3255                 liquidatedCollateral: liquidatedCollateral,
3256                 rawUnitCollateral: _convertToRawCollateral(FixedPoint.fromUnscaledUint(1)),
3257                 disputer: address(0),
3258                 settlementPrice: FixedPoint.fromUnscaledUint(0),
3259                 finalFee: finalFeeBond
3260             })
3261         );
3262 
3263         emit LiquidationCreated(
3264             sponsor,
3265             msg.sender,
3266             liquidationId,
3267             tokensLiquidated.rawValue,
3268             lockedCollateral.rawValue,
3269             liquidatedCollateral.rawValue,
3270             getCurrentTime()
3271         );
3272 
3273         // Destroy tokens
3274         tokenCurrency.safeTransferFrom(msg.sender, address(this), tokensLiquidated.rawValue);
3275         tokenCurrency.burn(tokensLiquidated.rawValue);
3276 
3277         // Pull final fee from liquidator.
3278         collateralCurrency.safeTransferFrom(msg.sender, address(this), finalFeeBond.rawValue);
3279     }
3280 
3281     /**
3282      * @notice Disputes a liquidation, if the caller has enough collateral to post a dispute bond
3283      * and pay a fixed final fee charged on each price request.
3284      * @dev Can only dispute a liquidation before the liquidation expires and if there are no other pending disputes.
3285      * This contract must be approved to spend at least the dispute bond amount of `collateralCurrency`. This dispute
3286      * bond amount is calculated from `disputeBondPct` times the collateral in the liquidation.
3287      * @param liquidationId of the disputed liquidation.
3288      * @param sponsor the address of the sponsor whose liquidation is being disputed.
3289      * @return totalPaid amount of collateral charged to disputer (i.e. final fee bond + dispute bond).
3290      */
3291     function dispute(uint256 liquidationId, address sponsor)
3292         external
3293         disputable(liquidationId, sponsor)
3294         fees()
3295         nonReentrant()
3296         returns (FixedPoint.Unsigned memory totalPaid)
3297     {
3298         LiquidationData storage disputedLiquidation = _getLiquidationData(sponsor, liquidationId);
3299 
3300         // Multiply by the unit collateral so the dispute bond is a percentage of the locked collateral after fees.
3301         FixedPoint.Unsigned memory disputeBondAmount = disputedLiquidation.lockedCollateral.mul(disputeBondPct).mul(
3302             _getFeeAdjustedCollateral(disputedLiquidation.rawUnitCollateral)
3303         );
3304         _addCollateral(rawLiquidationCollateral, disputeBondAmount);
3305 
3306         // Request a price from DVM. Liquidation is pending dispute until DVM returns a price.
3307         disputedLiquidation.state = Status.PendingDispute;
3308         disputedLiquidation.disputer = msg.sender;
3309 
3310         // Enqueue a request with the DVM.
3311         _requestOraclePrice(disputedLiquidation.liquidationTime);
3312 
3313         emit LiquidationDisputed(
3314             sponsor,
3315             disputedLiquidation.liquidator,
3316             msg.sender,
3317             liquidationId,
3318             disputeBondAmount.rawValue
3319         );
3320         totalPaid = disputeBondAmount.add(disputedLiquidation.finalFee);
3321 
3322         // Pay the final fee for requesting price from the DVM.
3323         _payFinalFees(msg.sender, disputedLiquidation.finalFee);
3324 
3325         // Transfer the dispute bond amount from the caller to this contract.
3326         collateralCurrency.safeTransferFrom(msg.sender, address(this), disputeBondAmount.rawValue);
3327     }
3328 
3329     /**
3330      * @notice After a dispute has settled or after a non-disputed liquidation has expired,
3331      * the sponsor, liquidator, and/or disputer can call this method to receive payments.
3332      * @dev If the dispute SUCCEEDED: the sponsor, liquidator, and disputer are eligible for payment.
3333      * If the dispute FAILED: only the liquidator can receive payment.
3334      * Once all collateral is withdrawn, delete the liquidation data.
3335      * @param liquidationId uniquely identifies the sponsor's liquidation.
3336      * @param sponsor address of the sponsor associated with the liquidation.
3337      * @return amountWithdrawn the total amount of underlying returned from the liquidation.
3338      */
3339     function withdrawLiquidation(uint256 liquidationId, address sponsor)
3340         public
3341         withdrawable(liquidationId, sponsor)
3342         fees()
3343         nonReentrant()
3344         returns (FixedPoint.Unsigned memory amountWithdrawn)
3345     {
3346         LiquidationData storage liquidation = _getLiquidationData(sponsor, liquidationId);
3347         require(
3348             (msg.sender == liquidation.disputer) ||
3349                 (msg.sender == liquidation.liquidator) ||
3350                 (msg.sender == liquidation.sponsor),
3351             "Caller cannot withdraw rewards"
3352         );
3353 
3354         // Settles the liquidation if necessary. This call will revert if the price has not resolved yet.
3355         _settle(liquidationId, sponsor);
3356 
3357         // Calculate rewards as a function of the TRV.
3358         // Note: all payouts are scaled by the unit collateral value so all payouts are charged the fees pro rata.
3359         FixedPoint.Unsigned memory feeAttenuation = _getFeeAdjustedCollateral(liquidation.rawUnitCollateral);
3360         FixedPoint.Unsigned memory tokenRedemptionValue = liquidation
3361             .tokensOutstanding
3362             .mul(liquidation.settlementPrice)
3363             .mul(feeAttenuation);
3364         FixedPoint.Unsigned memory collateral = liquidation.lockedCollateral.mul(feeAttenuation);
3365         FixedPoint.Unsigned memory disputerDisputeReward = disputerDisputeRewardPct.mul(tokenRedemptionValue);
3366         FixedPoint.Unsigned memory sponsorDisputeReward = sponsorDisputeRewardPct.mul(tokenRedemptionValue);
3367         FixedPoint.Unsigned memory disputeBondAmount = collateral.mul(disputeBondPct);
3368         FixedPoint.Unsigned memory finalFee = liquidation.finalFee.mul(feeAttenuation);
3369 
3370         // There are three main outcome states: either the dispute succeeded, failed or was not updated.
3371         // Based on the state, different parties of a liquidation can withdraw different amounts.
3372         // Once a caller has been paid their address deleted from the struct.
3373         // This prevents them from being paid multiple from times the same liquidation.
3374         FixedPoint.Unsigned memory withdrawalAmount = FixedPoint.fromUnscaledUint(0);
3375         if (liquidation.state == Status.DisputeSucceeded) {
3376             // If the dispute is successful then all three users can withdraw from the contract.
3377             if (msg.sender == liquidation.disputer) {
3378                 // Pay DISPUTER: disputer reward + dispute bond + returned final fee
3379                 FixedPoint.Unsigned memory payToDisputer = disputerDisputeReward.add(disputeBondAmount).add(finalFee);
3380                 withdrawalAmount = withdrawalAmount.add(payToDisputer);
3381                 delete liquidation.disputer;
3382             }
3383 
3384             if (msg.sender == liquidation.sponsor) {
3385                 // Pay SPONSOR: remaining collateral (collateral - TRV) + sponsor reward
3386                 FixedPoint.Unsigned memory remainingCollateral = collateral.sub(tokenRedemptionValue);
3387                 FixedPoint.Unsigned memory payToSponsor = sponsorDisputeReward.add(remainingCollateral);
3388                 withdrawalAmount = withdrawalAmount.add(payToSponsor);
3389                 delete liquidation.sponsor;
3390             }
3391 
3392             if (msg.sender == liquidation.liquidator) {
3393                 // Pay LIQUIDATOR: TRV - dispute reward - sponsor reward
3394                 // If TRV > Collateral, then subtract rewards from collateral
3395                 // NOTE: This should never be below zero since we prevent (sponsorDisputePct+disputerDisputePct) >= 0 in
3396                 // the constructor when these params are set.
3397                 FixedPoint.Unsigned memory payToLiquidator = tokenRedemptionValue.sub(sponsorDisputeReward).sub(
3398                     disputerDisputeReward
3399                 );
3400                 withdrawalAmount = withdrawalAmount.add(payToLiquidator);
3401                 delete liquidation.liquidator;
3402             }
3403 
3404             // Free up space once all collateral is withdrawn by removing the liquidation object from the array.
3405             if (
3406                 liquidation.disputer == address(0) &&
3407                 liquidation.sponsor == address(0) &&
3408                 liquidation.liquidator == address(0)
3409             ) {
3410                 delete liquidations[sponsor][liquidationId];
3411             }
3412             // In the case of a failed dispute only the liquidator can withdraw.
3413         } else if (liquidation.state == Status.DisputeFailed && msg.sender == liquidation.liquidator) {
3414             // Pay LIQUIDATOR: collateral + dispute bond + returned final fee
3415             withdrawalAmount = collateral.add(disputeBondAmount).add(finalFee);
3416             delete liquidations[sponsor][liquidationId];
3417             // If the state is pre-dispute but time has passed liveness then there was no dispute. We represent this
3418             // state as a dispute failed and the liquidator can withdraw.
3419         } else if (liquidation.state == Status.PreDispute && msg.sender == liquidation.liquidator) {
3420             // Pay LIQUIDATOR: collateral + returned final fee
3421             withdrawalAmount = collateral.add(finalFee);
3422             delete liquidations[sponsor][liquidationId];
3423         }
3424         require(withdrawalAmount.isGreaterThan(0), "Invalid withdrawal amount");
3425 
3426         // Decrease the total collateral held in liquidatable by the amount withdrawn.
3427         amountWithdrawn = _removeCollateral(rawLiquidationCollateral, withdrawalAmount);
3428 
3429         emit LiquidationWithdrawn(
3430             msg.sender,
3431             amountWithdrawn.rawValue,
3432             liquidation.state,
3433             liquidation.settlementPrice.rawValue
3434         );
3435 
3436         // Transfer amount withdrawn from this contract to the caller.
3437         collateralCurrency.safeTransfer(msg.sender, amountWithdrawn.rawValue);
3438 
3439         return amountWithdrawn;
3440     }
3441 
3442     /**
3443      * @notice Gets all liquidation information for a given sponsor address.
3444      * @param sponsor address of the position sponsor.
3445      * @return liquidationData array of all liquidation information for the given sponsor address.
3446      */
3447     function getLiquidations(address sponsor)
3448         external
3449         view
3450         nonReentrantView()
3451         returns (LiquidationData[] memory liquidationData)
3452     {
3453         return liquidations[sponsor];
3454     }
3455 
3456     /****************************************
3457      *          INTERNAL FUNCTIONS          *
3458      ****************************************/
3459 
3460     // This settles a liquidation if it is in the PendingDispute state. If not, it will immediately return.
3461     // If the liquidation is in the PendingDispute state, but a price is not available, this will revert.
3462     function _settle(uint256 liquidationId, address sponsor) internal {
3463         LiquidationData storage liquidation = _getLiquidationData(sponsor, liquidationId);
3464 
3465         // Settlement only happens when state == PendingDispute and will only happen once per liquidation.
3466         // If this liquidation is not ready to be settled, this method should return immediately.
3467         if (liquidation.state != Status.PendingDispute) {
3468             return;
3469         }
3470 
3471         // Get the returned price from the oracle. If this has not yet resolved will revert.
3472         liquidation.settlementPrice = _getOraclePrice(liquidation.liquidationTime);
3473 
3474         // Find the value of the tokens in the underlying collateral.
3475         FixedPoint.Unsigned memory tokenRedemptionValue = liquidation.tokensOutstanding.mul(
3476             liquidation.settlementPrice
3477         );
3478 
3479         // The required collateral is the value of the tokens in underlying * required collateral ratio.
3480         FixedPoint.Unsigned memory requiredCollateral = tokenRedemptionValue.mul(collateralRequirement);
3481 
3482         // If the position has more than the required collateral it is solvent and the dispute is valid(liquidation is invalid)
3483         // Note that this check uses the liquidatedCollateral not the lockedCollateral as this considers withdrawals.
3484         bool disputeSucceeded = liquidation.liquidatedCollateral.isGreaterThanOrEqual(requiredCollateral);
3485         liquidation.state = disputeSucceeded ? Status.DisputeSucceeded : Status.DisputeFailed;
3486 
3487         emit DisputeSettled(
3488             msg.sender,
3489             sponsor,
3490             liquidation.liquidator,
3491             liquidation.disputer,
3492             liquidationId,
3493             disputeSucceeded
3494         );
3495     }
3496 
3497     function _pfc() internal override view returns (FixedPoint.Unsigned memory) {
3498         return super._pfc().add(_getFeeAdjustedCollateral(rawLiquidationCollateral));
3499     }
3500 
3501     function _getLiquidationData(address sponsor, uint256 liquidationId)
3502         internal
3503         view
3504         returns (LiquidationData storage liquidation)
3505     {
3506         LiquidationData[] storage liquidationArray = liquidations[sponsor];
3507 
3508         // Revert if the caller is attempting to access an invalid liquidation
3509         // (one that has never been created or one has never been initialized).
3510         require(
3511             liquidationId < liquidationArray.length && liquidationArray[liquidationId].state != Status.Uninitialized,
3512             "Invalid liquidation ID"
3513         );
3514         return liquidationArray[liquidationId];
3515     }
3516 
3517     function _getLiquidationExpiry(LiquidationData storage liquidation) internal view returns (uint256) {
3518         return liquidation.liquidationTime.add(liquidationLiveness);
3519     }
3520 
3521     // These internal functions are supposed to act identically to modifiers, but re-used modifiers
3522     // unnecessarily increase contract bytecode size.
3523     // source: https://blog.polymath.network/solidity-tips-and-tricks-to-save-gas-and-reduce-bytecode-size-c44580b218e6
3524     function _disputable(uint256 liquidationId, address sponsor) internal view {
3525         LiquidationData storage liquidation = _getLiquidationData(sponsor, liquidationId);
3526         require(
3527             (getCurrentTime() < _getLiquidationExpiry(liquidation)) && (liquidation.state == Status.PreDispute),
3528             "Liquidation not disputable"
3529         );
3530     }
3531 
3532     function _withdrawable(uint256 liquidationId, address sponsor) internal view {
3533         LiquidationData storage liquidation = _getLiquidationData(sponsor, liquidationId);
3534         Status state = liquidation.state;
3535 
3536         // Must be disputed or the liquidation has passed expiry.
3537         require(
3538             (state > Status.PreDispute) ||
3539                 ((_getLiquidationExpiry(liquidation) <= getCurrentTime()) && (state == Status.PreDispute)),
3540             "Liquidation not withdrawable"
3541         );
3542     }
3543 }
3544 
3545 // File: contracts/financial-templates/expiring-multiparty/ExpiringMultiParty.sol
3546 
3547 pragma solidity ^0.6.0;
3548 
3549 
3550 
3551 /**
3552  * @title Expiring Multi Party.
3553  * @notice Convenient wrapper for Liquidatable.
3554  */
3555 contract ExpiringMultiParty is Liquidatable {
3556     /**
3557      * @notice Constructs the ExpiringMultiParty contract.
3558      * @param params struct to define input parameters for construction of Liquidatable. Some params
3559      * are fed directly into the PricelessPositionManager's constructor within the inheritance tree.
3560      */
3561     constructor(ConstructorParams memory params)
3562         public
3563         Liquidatable(params)
3564     // Note: since there is no logic here, there is no need to add a re-entrancy guard.
3565     {
3566 
3567     }
3568 }