1 pragma solidity 0.5.15;
2 pragma experimental ABIEncoderV2;
3 
4 /**
5  * @dev Wrappers over Solidity's arithmetic operations with added overflow
6  * checks.
7  *
8  * Arithmetic operations in Solidity wrap on overflow. This can easily result
9  * in bugs, because programmers usually assume that an overflow raises an
10  * error, which is the standard behavior in high level programming languages.
11  * `SafeMath` restores this intuition by reverting the transaction when an
12  * operation overflows.
13  *
14  * Using this library instead of the unchecked operations eliminates an entire
15  * class of bugs, so it's recommended to use it always.
16  */
17 library SafeMath {
18     /**
19      * @dev Returns the addition of two unsigned integers, reverting on
20      * overflow.
21      *
22      * Counterpart to Solidity's `+` operator.
23      *
24      * Requirements:
25      *
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
42      *
43      * - Subtraction cannot overflow.
44      */
45     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
46         return sub(a, b, "SafeMath: subtraction overflow");
47     }
48 
49     /**
50      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
51      * overflow (when the result is negative).
52      *
53      * Counterpart to Solidity's `-` operator.
54      *
55      * Requirements:
56      *
57      * - Subtraction cannot overflow.
58      */
59     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
60         require(b <= a, errorMessage);
61         uint256 c = a - b;
62 
63         return c;
64     }
65 
66     /**
67      * @dev Returns the multiplication of two unsigned integers, reverting on
68      * overflow.
69      *
70      * Counterpart to Solidity's `*` operator.
71      *
72      * Requirements:
73      *
74      * - Multiplication cannot overflow.
75      */
76     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
77         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
78         // benefit is lost if 'b' is also tested.
79         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
80         if (a == 0) {
81             return 0;
82         }
83 
84         uint256 c = a * b;
85         require(c / a == b, "SafeMath: multiplication overflow");
86 
87         return c;
88     }
89 
90     /**
91      * @dev Returns the integer division of two unsigned integers. Reverts on
92      * division by zero. The result is rounded towards zero.
93      *
94      * Counterpart to Solidity's `/` operator. Note: this function uses a
95      * `revert` opcode (which leaves remaining gas untouched) while Solidity
96      * uses an invalid opcode to revert (consuming all remaining gas).
97      *
98      * Requirements:
99      *
100      * - The divisor cannot be zero.
101      */
102     function div(uint256 a, uint256 b) internal pure returns (uint256) {
103         return div(a, b, "SafeMath: division by zero");
104     }
105 
106     /**
107      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
108      * division by zero. The result is rounded towards zero.
109      *
110      * Counterpart to Solidity's `/` operator. Note: this function uses a
111      * `revert` opcode (which leaves remaining gas untouched) while Solidity
112      * uses an invalid opcode to revert (consuming all remaining gas).
113      *
114      * Requirements:
115      *
116      * - The divisor cannot be zero.
117      */
118     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
119         require(b > 0, errorMessage);
120         uint256 c = a / b;
121         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
122 
123         return c;
124     }
125 
126     /**
127      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
128      * Reverts when dividing by zero.
129      *
130      * Counterpart to Solidity's `%` operator. This function uses a `revert`
131      * opcode (which leaves remaining gas untouched) while Solidity uses an
132      * invalid opcode to revert (consuming all remaining gas).
133      *
134      * Requirements:
135      *
136      * - The divisor cannot be zero.
137      */
138     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
139         return mod(a, b, "SafeMath: modulo by zero");
140     }
141 
142     /**
143      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
144      * Reverts with custom message when dividing by zero.
145      *
146      * Counterpart to Solidity's `%` operator. This function uses a `revert`
147      * opcode (which leaves remaining gas untouched) while Solidity uses an
148      * invalid opcode to revert (consuming all remaining gas).
149      *
150      * Requirements:
151      *
152      * - The divisor cannot be zero.
153      */
154     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
155         require(b != 0, errorMessage);
156         return a % b;
157     }
158 }
159 
160 /**
161  * @dev Interface of the ERC20 standard as defined in the EIP.
162  */
163 interface IERC20 {
164     /**
165      * @dev Returns the amount of tokens in existence.
166      */
167     function totalSupply() external view returns (uint256);
168 
169     /**
170      * @dev Returns the amount of tokens owned by `account`.
171      */
172     function balanceOf(address account) external view returns (uint256);
173 
174     /**
175      * @dev Moves `amount` tokens from the caller's account to `recipient`.
176      *
177      * Returns a boolean value indicating whether the operation succeeded.
178      *
179      * Emits a {Transfer} event.
180      */
181     function transfer(address recipient, uint256 amount) external returns (bool);
182 
183     /**
184      * @dev Returns the remaining number of tokens that `spender` will be
185      * allowed to spend on behalf of `owner` through {transferFrom}. This is
186      * zero by default.
187      *
188      * This value changes when {approve} or {transferFrom} are called.
189      */
190     function allowance(address owner, address spender) external view returns (uint256);
191 
192     /**
193      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
194      *
195      * Returns a boolean value indicating whether the operation succeeded.
196      *
197      * IMPORTANT: Beware that changing an allowance with this method brings the risk
198      * that someone may use both the old and the new allowance by unfortunate
199      * transaction ordering. One possible solution to mitigate this race
200      * condition is to first reduce the spender's allowance to 0 and set the
201      * desired value afterwards:
202      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
203      *
204      * Emits an {Approval} event.
205      */
206     function approve(address spender, uint256 amount) external returns (bool);
207 
208     /**
209      * @dev Moves `amount` tokens from `sender` to `recipient` using the
210      * allowance mechanism. `amount` is then deducted from the caller's
211      * allowance.
212      *
213      * Returns a boolean value indicating whether the operation succeeded.
214      *
215      * Emits a {Transfer} event.
216      */
217     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
218 
219     /**
220      * @dev Emitted when `value` tokens are moved from one account (`from`) to
221      * another (`to`).
222      *
223      * Note that `value` may be zero.
224      */
225     event Transfer(address indexed from, address indexed to, uint256 value);
226 
227     /**
228      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
229      * a call to {approve}. `value` is the new allowance.
230      */
231     event Approval(address indexed owner, address indexed spender, uint256 value);
232 }
233 
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
287         (bool success, ) = recipient.call.value(amount)("");
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
353         (bool success, bytes memory returndata) = target.call.value(weiValue)(data);
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
373 
374 /**
375  * @title SafeERC20
376  * @dev Wrappers around ERC20 operations that throw on failure (when the token
377  * contract returns false). Tokens that return no value (and instead revert or
378  * throw on failure) are also supported, non-reverting calls are assumed to be
379  * successful.
380  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
381  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
382  */
383 library SafeERC20 {
384     using SafeMath for uint256;
385     using Address for address;
386 
387     function safeTransfer(IERC20 token, address to, uint256 value) internal {
388         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
389     }
390 
391     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
392         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
393     }
394 
395     /**
396      * @dev Deprecated. This function has issues similar to the ones found in
397      * {IERC20-approve}, and its usage is discouraged.
398      *
399      * Whenever possible, use {safeIncreaseAllowance} and
400      * {safeDecreaseAllowance} instead.
401      */
402     function safeApprove(IERC20 token, address spender, uint256 value) internal {
403         // safeApprove should only be called when setting an initial allowance,
404         // or when resetting it to zero. To increase and decrease it, use
405         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
406         // solhint-disable-next-line max-line-length
407         require((value == 0) || (token.allowance(address(this), spender) == 0),
408             "SafeERC20: approve from non-zero to non-zero allowance"
409         );
410         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
411     }
412 
413     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
414         uint256 newAllowance = token.allowance(address(this), spender).add(value);
415         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
416     }
417 
418     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
419         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
420         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
421     }
422 
423     /**
424      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
425      * on the return value: the return value is optional (but if data is returned, it must not be false).
426      * @param token The token targeted by the call.
427      * @param data The call data (encoded using abi.encode or one of its variants).
428      */
429     function _callOptionalReturn(IERC20 token, bytes memory data) private {
430         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
431         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
432         // the target address contains contract code and also asserts for success in the low-level call.
433 
434         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
435         if (returndata.length > 0) { // Return data is optional
436             // solhint-disable-next-line max-line-length
437             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
438         }
439     }
440 }
441 
442 interface BAL {
443   function gulp(address token) external;
444 }
445 
446 interface UniswapPair {
447     event Approval(address indexed owner, address indexed spender, uint value);
448     event Transfer(address indexed from, address indexed to, uint value);
449 
450     function name() external pure returns (string memory);
451     function symbol() external pure returns (string memory);
452     function decimals() external pure returns (uint8);
453     function totalSupply() external view returns (uint);
454     function balanceOf(address owner) external view returns (uint);
455     function allowance(address owner, address spender) external view returns (uint);
456 
457     function approve(address spender, uint value) external returns (bool);
458     function transfer(address to, uint value) external returns (bool);
459     function transferFrom(address from, address to, uint value) external returns (bool);
460 
461     function DOMAIN_SEPARATOR() external view returns (bytes32);
462     function PERMIT_TYPEHASH() external pure returns (bytes32);
463     function nonces(address owner) external view returns (uint);
464 
465     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
466 
467     event Mint(address indexed sender, uint amount0, uint amount1);
468     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
469     event Swap(
470         address indexed sender,
471         uint amount0In,
472         uint amount1In,
473         uint amount0Out,
474         uint amount1Out,
475         address indexed to
476     );
477     event Sync(uint112 reserve0, uint112 reserve1);
478 
479     function MINIMUM_LIQUIDITY() external pure returns (uint);
480     function factory() external view returns (address);
481     function token0() external view returns (address);
482     function token1() external view returns (address);
483     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
484     function price0CumulativeLast() external view returns (uint);
485     function price1CumulativeLast() external view returns (uint);
486     function kLast() external view returns (uint);
487 
488     function mint(address to) external returns (uint liquidity);
489     function burn(address to) external returns (uint amount0, uint amount1);
490     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
491     function skim(address to) external;
492     function sync() external;
493 
494     function initialize(address, address) external;
495 }
496 
497 // computes square roots using the babylonian method
498 // https://en.wikipedia.org/wiki/Methods_of_computing_square_roots#Babylonian_method
499 library Babylonian {
500     function sqrt(uint y) internal pure returns (uint z) {
501         if (y > 3) {
502             z = y;
503             uint x = y / 2 + 1;
504             while (x < z) {
505                 z = x;
506                 x = (y / x + x) / 2;
507             }
508         } else if (y != 0) {
509             z = 1;
510         }
511         // else z = 0
512     }
513 }
514 
515 // a library for handling binary fixed point numbers (https://en.wikipedia.org/wiki/Q_(number_format))
516 library FixedPoint {
517     // range: [0, 2**112 - 1]
518     // resolution: 1 / 2**112
519     struct uq112x112 {
520         uint224 _x;
521     }
522 
523     // range: [0, 2**144 - 1]
524     // resolution: 1 / 2**112
525     struct uq144x112 {
526         uint _x;
527     }
528 
529     uint8 private constant RESOLUTION = 112;
530     uint private constant Q112 = uint(1) << RESOLUTION;
531     uint private constant Q224 = Q112 << RESOLUTION;
532 
533     // encode a uint112 as a UQ112x112
534     function encode(uint112 x) internal pure returns (uq112x112 memory) {
535         return uq112x112(uint224(x) << RESOLUTION);
536     }
537 
538     // encodes a uint144 as a UQ144x112
539     function encode144(uint144 x) internal pure returns (uq144x112 memory) {
540         return uq144x112(uint256(x) << RESOLUTION);
541     }
542 
543     // divide a UQ112x112 by a uint112, returning a UQ112x112
544     function div(uq112x112 memory self, uint112 x) internal pure returns (uq112x112 memory) {
545         require(x != 0, 'FixedPoint: DIV_BY_ZERO');
546         return uq112x112(self._x / uint224(x));
547     }
548 
549     // multiply a UQ112x112 by a uint, returning a UQ144x112
550     // reverts on overflow
551     function mul(uq112x112 memory self, uint y) internal pure returns (uq144x112 memory) {
552         uint z;
553         require(y == 0 || (z = uint(self._x) * y) / y == uint(self._x), "FixedPoint: MULTIPLICATION_OVERFLOW");
554         return uq144x112(z);
555     }
556 
557     // returns a UQ112x112 which represents the ratio of the numerator to the denominator
558     // equivalent to encode(numerator).div(denominator)
559     function fraction(uint112 numerator, uint112 denominator) internal pure returns (uq112x112 memory) {
560         require(denominator > 0, "FixedPoint: DIV_BY_ZERO");
561         return uq112x112((uint224(numerator) << RESOLUTION) / denominator);
562     }
563 
564     // decode a UQ112x112 into a uint112 by truncating after the radix point
565     function decode(uq112x112 memory self) internal pure returns (uint112) {
566         return uint112(self._x >> RESOLUTION);
567     }
568 
569     // decode a UQ144x112 into a uint144 by truncating after the radix point
570     function decode144(uq144x112 memory self) internal pure returns (uint144) {
571         return uint144(self._x >> RESOLUTION);
572     }
573 
574     // take the reciprocal of a UQ112x112
575     function reciprocal(uq112x112 memory self) internal pure returns (uq112x112 memory) {
576         require(self._x != 0, 'FixedPoint: ZERO_RECIPROCAL');
577         return uq112x112(uint224(Q224 / self._x));
578     }
579 
580     // square root of a UQ112x112
581     function sqrt(uq112x112 memory self) internal pure returns (uq112x112 memory) {
582         return uq112x112(uint224(Babylonian.sqrt(uint256(self._x)) << 56));
583     }
584 }
585 
586 // library with helper methods for oracles that are concerned with computing average prices
587 library UniswapV2OracleLibrary {
588     using FixedPoint for *;
589 
590     // helper function that returns the current block timestamp within the range of uint32, i.e. [0, 2**32 - 1]
591     function currentBlockTimestamp() internal view returns (uint32) {
592         return uint32(block.timestamp % 2 ** 32);
593     }
594 
595     // produces the cumulative price using counterfactuals to save gas and avoid a call to sync.
596     function currentCumulativePrices(
597         address pair,
598         bool isToken0
599     ) internal view returns (uint priceCumulative, uint32 blockTimestamp) {
600         blockTimestamp = currentBlockTimestamp();
601         (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast) = UniswapPair(pair).getReserves();
602         if (isToken0) {
603           priceCumulative = UniswapPair(pair).price0CumulativeLast();
604 
605           // if time has elapsed since the last update on the pair, mock the accumulated price values
606           if (blockTimestampLast != blockTimestamp) {
607               // subtraction overflow is desired
608               uint32 timeElapsed = blockTimestamp - blockTimestampLast;
609               // addition overflow is desired
610               // counterfactual
611               priceCumulative += uint(FixedPoint.fraction(reserve1, reserve0)._x) * timeElapsed;
612           }
613         } else {
614           priceCumulative = UniswapPair(pair).price1CumulativeLast();
615           // if time has elapsed since the last update on the pair, mock the accumulated price values
616           if (blockTimestampLast != blockTimestamp) {
617               // subtraction overflow is desired
618               uint32 timeElapsed = blockTimestamp - blockTimestampLast;
619               // addition overflow is desired
620               // counterfactual
621               priceCumulative += uint(FixedPoint.fraction(reserve0, reserve1)._x) * timeElapsed;
622           }
623         }
624 
625     }
626 }
627 
628 // Storage for a YAM token
629 contract YAMTokenStorage {
630 
631     using SafeMath for uint256;
632 
633     /**
634      * @dev Guard variable for re-entrancy checks. Not currently used
635      */
636     bool internal _notEntered;
637 
638     /**
639      * @notice EIP-20 token name for this token
640      */
641     string public name;
642 
643     /**
644      * @notice EIP-20 token symbol for this token
645      */
646     string public symbol;
647 
648     /**
649      * @notice EIP-20 token decimals for this token
650      */
651     uint8 public decimals;
652 
653     /**
654      * @notice Governor for this contract
655      */
656     address public gov;
657 
658     /**
659      * @notice Pending governance for this contract
660      */
661     address public pendingGov;
662 
663     /**
664      * @notice Approved rebaser for this contract
665      */
666     address public rebaser;
667 
668     /**
669      * @notice Approved migrator for this contract
670      */
671     address public migrator;
672 
673     /**
674      * @notice Incentivizer address of YAM protocol
675      */
676     address public incentivizer;
677 
678     /**
679      * @notice Total supply of YAMs
680      */
681     uint256 public totalSupply;
682 
683     /**
684      * @notice Internal decimals used to handle scaling factor
685      */
686     uint256 public constant internalDecimals = 10**24;
687 
688     /**
689      * @notice Used for percentage maths
690      */
691     uint256 public constant BASE = 10**18;
692 
693     /**
694      * @notice Scaling factor that adjusts everyone's balances
695      */
696     uint256 public yamsScalingFactor;
697 
698     mapping (address => uint256) internal _yamBalances;
699 
700     mapping (address => mapping (address => uint256)) internal _allowedFragments;
701 
702     uint256 public initSupply;
703 
704 
705     // keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
706     bytes32 public constant PERMIT_TYPEHASH = 0x6e71edae12b1b97f4d1f60370fef10105fa2faae0126114a169c64845d6126c9;
707     bytes32 public DOMAIN_SEPARATOR;
708 }
709 
710 /* Copyright 2020 Compound Labs, Inc.
711 
712 Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
713 
714 1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
715 
716 2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
717 
718 3. Neither the name of the copyright holder nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
719 
720 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE. */
721 
722 
723 contract YAMGovernanceStorage {
724     /// @notice A record of each accounts delegate
725     mapping (address => address) internal _delegates;
726 
727     /// @notice A checkpoint for marking number of votes from a given block
728     struct Checkpoint {
729         uint32 fromBlock;
730         uint256 votes;
731     }
732 
733     /// @notice A record of votes checkpoints for each account, by index
734     mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;
735 
736     /// @notice The number of checkpoints for each account
737     mapping (address => uint32) public numCheckpoints;
738 
739     /// @notice The EIP-712 typehash for the contract's domain
740     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
741 
742     /// @notice The EIP-712 typehash for the delegation struct used by the contract
743     bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
744 
745     /// @notice A record of states for signing / validating signatures
746     mapping (address => uint) public nonces;
747 }
748 
749 
750 contract YAMTokenInterface is YAMTokenStorage, YAMGovernanceStorage {
751 
752     /// @notice An event thats emitted when an account changes its delegate
753     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
754 
755     /// @notice An event thats emitted when a delegate account's vote balance changes
756     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
757 
758     /**
759      * @notice Event emitted when tokens are rebased
760      */
761     event Rebase(uint256 epoch, uint256 prevYamsScalingFactor, uint256 newYamsScalingFactor);
762 
763     /*** Gov Events ***/
764 
765     /**
766      * @notice Event emitted when pendingGov is changed
767      */
768     event NewPendingGov(address oldPendingGov, address newPendingGov);
769 
770     /**
771      * @notice Event emitted when gov is changed
772      */
773     event NewGov(address oldGov, address newGov);
774 
775     /**
776      * @notice Sets the rebaser contract
777      */
778     event NewRebaser(address oldRebaser, address newRebaser);
779 
780     /**
781      * @notice Sets the migrator contract
782      */
783     event NewMigrator(address oldMigrator, address newMigrator);
784 
785     /**
786      * @notice Sets the incentivizer contract
787      */
788     event NewIncentivizer(address oldIncentivizer, address newIncentivizer);
789 
790     /* - ERC20 Events - */
791 
792     /**
793      * @notice EIP20 Transfer event
794      */
795     event Transfer(address indexed from, address indexed to, uint amount);
796 
797     /**
798      * @notice EIP20 Approval event
799      */
800     event Approval(address indexed owner, address indexed spender, uint amount);
801 
802     /* - Extra Events - */
803     /**
804      * @notice Tokens minted event
805      */
806     event Mint(address to, uint256 amount);
807 
808     // Public functions
809     function transfer(address to, uint256 value) external returns(bool);
810     function transferFrom(address from, address to, uint256 value) external returns(bool);
811     function balanceOf(address who) external view returns(uint256);
812     function balanceOfUnderlying(address who) external view returns(uint256);
813     function allowance(address owner_, address spender) external view returns(uint256);
814     function approve(address spender, uint256 value) external returns (bool);
815     function increaseAllowance(address spender, uint256 addedValue) external returns (bool);
816     function decreaseAllowance(address spender, uint256 subtractedValue) external returns (bool);
817     function maxScalingFactor() external view returns (uint256);
818     function yamToFragment(uint256 yam) external view returns (uint256);
819     function fragmentToYam(uint256 value) external view returns (uint256);
820 
821     /* - Governance Functions - */
822     function getPriorVotes(address account, uint blockNumber) external view returns (uint256);
823     function delegateBySig(address delegatee, uint nonce, uint expiry, uint8 v, bytes32 r, bytes32 s) external;
824     function delegate(address delegatee) external;
825     function delegates(address delegator) external view returns (address);
826     function getCurrentVotes(address account) external view returns (uint256);
827 
828     /* - Permissioned/Governance functions - */
829     function mint(address to, uint256 amount) external returns (bool);
830     function rebase(uint256 epoch, uint256 indexDelta, bool positive) external returns (uint256);
831     function _setRebaser(address rebaser_) external;
832     function _setIncentivizer(address incentivizer_) external;
833     function _setPendingGov(address pendingGov_) external;
834     function _acceptGov() external;
835 }
836 contract YAMRebaser {
837 
838     using SafeMath for uint256;
839 
840     modifier onlyGov() {
841         require(msg.sender == gov);
842         _;
843     }
844 
845     struct Transaction {
846         bool enabled;
847         address destination;
848         bytes data;
849     }
850 
851     struct UniVars {
852       uint256 yamsToUni;
853       uint256 amountFromReserves;
854       uint256 mintToReserves;
855     }
856 
857     /// @notice an event emitted when a transaction fails
858     event TransactionFailed(address indexed destination, uint index, bytes data);
859 
860     /// @notice an event emitted when maxSlippageFactor is changed
861     event NewMaxSlippageFactor(uint256 oldSlippageFactor, uint256 newSlippageFactor);
862 
863     /// @notice an event emitted when deviationThreshold is changed
864     event NewDeviationThreshold(uint256 oldDeviationThreshold, uint256 newDeviationThreshold);
865 
866     /**
867      * @notice Sets the treasury mint percentage of rebase
868      */
869     event NewRebaseMintPercent(uint256 oldRebaseMintPerc, uint256 newRebaseMintPerc);
870 
871 
872     /**
873      * @notice Sets the reserve contract
874      */
875     event NewReserveContract(address oldReserveContract, address newReserveContract);
876 
877     /**
878      * @notice Sets the reserve contract
879      */
880     event TreasuryIncreased(uint256 reservesAdded, uint256 yamsSold, uint256 yamsFromReserves, uint256 yamsToReserves);
881 
882 
883     /**
884      * @notice Event emitted when pendingGov is changed
885      */
886     event NewPendingGov(address oldPendingGov, address newPendingGov);
887 
888     /**
889      * @notice Event emitted when gov is changed
890      */
891     event NewGov(address oldGov, address newGov);
892 
893     // Stable ordering is not guaranteed.
894     Transaction[] public transactions;
895 
896 
897     /// @notice Governance address
898     address public gov;
899 
900     /// @notice Pending Governance address
901     address public pendingGov;
902 
903     /// @notice Spreads out getting to the target price
904     uint256 public rebaseLag;
905 
906     /// @notice Peg target
907     uint256 public targetRate;
908 
909     /// @notice Percent of rebase that goes to minting for treasury building
910     uint256 public rebaseMintPerc;
911 
912     // If the current exchange rate is within this fractional distance from the target, no supply
913     // update is performed. Fixed point number--same format as the rate.
914     // (ie) abs(rate - targetRate) / targetRate < deviationThreshold, then no supply change.
915     uint256 public deviationThreshold;
916 
917     /// @notice More than this much time must pass between rebase operations.
918     uint256 public minRebaseTimeIntervalSec;
919 
920     /// @notice Block timestamp of last rebase operation
921     uint256 public lastRebaseTimestampSec;
922 
923     /// @notice The rebase window begins this many seconds into the minRebaseTimeInterval period.
924     // For example if minRebaseTimeInterval is 24hrs, it represents the time of day in seconds.
925     uint256 public rebaseWindowOffsetSec;
926 
927     /// @notice The length of the time window where a rebase operation is allowed to execute, in seconds.
928     uint256 public rebaseWindowLengthSec;
929 
930     /// @notice The number of rebase cycles since inception
931     uint256 public epoch;
932 
933     // rebasing is not active initially. It can be activated at T+12 hours from
934     // deployment time
935     ///@notice boolean showing rebase activation status
936     bool public rebasingActive;
937 
938     /// @notice delays rebasing activation to facilitate liquidity
939     uint256 public constant rebaseDelay = 12 hours;
940 
941     /// @notice Time of TWAP initialization
942     uint256 public timeOfTWAPInit;
943 
944     /// @notice YAM token address
945     address public yamAddress;
946 
947     /// @notice reserve token
948     address public reserveToken;
949 
950     /// @notice Reserves vault contract
951     address public reservesContract;
952 
953     /// @notice pair for reserveToken <> YAM
954     address public uniswap_pair;
955 
956     /// @notice list of uniswap pairs to sync
957     address[] public uniSyncPairs;
958 
959     /// @notice list of balancer pairs to gulp
960     address[] public balGulpPairs;
961 
962     /// @notice last TWAP update time
963     uint32 public blockTimestampLast;
964 
965     /// @notice last TWAP cumulative price;
966     uint256 public priceCumulativeLast;
967 
968 
969     /// @notice address to send part of treasury to
970     address public public_goods;
971 
972     /// @notice percentage of treasury to send to public goods address
973     uint256 public public_goods_perc;
974 
975     // Max slippage factor when buying reserve token. Magic number based on
976     // the fact that uniswap is a constant product. Therefore,
977     // targeting a % max slippage can be achieved by using a single precomputed
978     // number. i.e. 2.5% slippage is always equal to some f(maxSlippageFactor, reserves)
979     /// @notice the maximum slippage factor when buying reserve token
980     uint256 public maxSlippageFactor;
981 
982     /// @notice Whether or not this token is first in uniswap YAM<>Reserve pair
983     bool public isToken0;
984 
985 
986     uint256 public constant BASE = 10**18;
987 
988     uint256 public constant MAX_SLIPPAGE_PARAM = 1180339 * 10**11; // max ~20% market impact
989 
990     uint256 public constant MAX_MINT_PERC_PARAM = 25 * 10**16; // max 25% of rebase can go to treasury
991 
992     uint256 public constant MIN_TIME_FIRST_REBASE = 1600718400; // Monday, September 21, 2020 8:00:00 PM
993 
994     constructor(
995         address yamAddress_,
996         address reserveToken_,
997         address uniswap_factory,
998         address reservesContract_,
999         address public_goods_,
1000         uint256 public_goods_perc_
1001     )
1002         public
1003     {
1004           minRebaseTimeIntervalSec = 12 hours;
1005           rebaseWindowOffsetSec = 28800; // 8am/8pm UTC rebases
1006 
1007           (address token0, address token1) = sortTokens(yamAddress_, reserveToken_);
1008 
1009           // used for interacting with uniswap
1010           if (token0 == yamAddress_) {
1011               isToken0 = true;
1012           } else {
1013               isToken0 = false;
1014           }
1015           // uniswap YAM<>Reserve pair
1016           uniswap_pair = pairFor(uniswap_factory, token0, token1);
1017 
1018           uniSyncPairs.push(uniswap_pair);
1019 
1020           // Reserves contract is mutable
1021           reservesContract = reservesContract_;
1022 
1023           // Reserve token is not mutable. Must deploy a new rebaser to update it
1024           reserveToken = reserveToken_;
1025 
1026           yamAddress = yamAddress_;
1027 
1028           public_goods = public_goods_;
1029           public_goods_perc = public_goods_perc_;
1030 
1031           // target 10% slippage
1032           // 5.4%
1033           maxSlippageFactor = 5409258 * 10**10;
1034 
1035           // 1 YYCRV
1036           targetRate = BASE;
1037 
1038           // twice daily rebase, with targeting reaching peg in 5 days
1039           rebaseLag = 10;
1040 
1041           // 10%
1042           rebaseMintPerc = 10**17;
1043 
1044           // 5%
1045           deviationThreshold = 5 * 10**16;
1046 
1047           // 60 minutes
1048           rebaseWindowLengthSec = 60 * 60;
1049 
1050           // Changed in deployment scripts to facilitate protocol initiation
1051           gov = msg.sender;
1052 
1053     }
1054 
1055 
1056     function removeUniPair(uint256 index) public onlyGov {
1057         if (index >= uniSyncPairs.length) return;
1058 
1059         for (uint i = index; i < uniSyncPairs.length-1; i++){
1060             uniSyncPairs[i] = uniSyncPairs[i+1];
1061         }
1062         uniSyncPairs.length--;
1063     }
1064 
1065     function removeBalPair(uint256 index) public onlyGov {
1066         if (index >= balGulpPairs.length) return;
1067 
1068         for (uint i = index; i < balGulpPairs.length-1; i++){
1069             balGulpPairs[i] = balGulpPairs[i+1];
1070         }
1071         balGulpPairs.length--;
1072     }
1073 
1074     /**
1075     @notice Adds pairs to sync
1076     *
1077     */
1078     function addSyncPairs(address[] memory uniSyncPairs_, address[] memory balGulpPairs_)
1079         public
1080         onlyGov
1081     {
1082         for (uint256 i = 0; i < uniSyncPairs_.length; i++) {
1083             uniSyncPairs.push(uniSyncPairs_[i]);
1084         }
1085 
1086         for (uint256 i = 0; i < balGulpPairs_.length; i++) {
1087             balGulpPairs.push(balGulpPairs_[i]);
1088         }
1089     }
1090 
1091     /**
1092     @notice Uniswap synced pairs
1093     *
1094     */
1095     function getUniSyncPairs()
1096         public
1097         view
1098         returns (address[] memory)
1099     {
1100         address[] memory pairs = uniSyncPairs;
1101         return pairs;
1102     }
1103 
1104     /**
1105     @notice Uniswap synced pairs
1106     *
1107     */
1108     function getBalGulpPairs()
1109         public
1110         view
1111         returns (address[] memory)
1112     {
1113         address[] memory pairs = balGulpPairs;
1114         return pairs;
1115     }
1116 
1117 
1118 
1119     /**
1120     @notice Updates slippage factor
1121     @param maxSlippageFactor_ the new slippage factor
1122     *
1123     */
1124     function setMaxSlippageFactor(uint256 maxSlippageFactor_)
1125         public
1126         onlyGov
1127     {
1128         require(maxSlippageFactor_ < MAX_SLIPPAGE_PARAM);
1129         uint256 oldSlippageFactor = maxSlippageFactor;
1130         maxSlippageFactor = maxSlippageFactor_;
1131         emit NewMaxSlippageFactor(oldSlippageFactor, maxSlippageFactor_);
1132     }
1133 
1134     /**
1135     @notice Updates rebase mint percentage
1136     @param rebaseMintPerc_ the new rebase mint percentage
1137     *
1138     */
1139     function setRebaseMintPerc(uint256 rebaseMintPerc_)
1140         public
1141         onlyGov
1142     {
1143         require(rebaseMintPerc_ < MAX_MINT_PERC_PARAM);
1144         uint256 oldPerc = rebaseMintPerc;
1145         rebaseMintPerc = rebaseMintPerc_;
1146         emit NewRebaseMintPercent(oldPerc, rebaseMintPerc_);
1147     }
1148 
1149 
1150     /**
1151     @notice Updates reserve contract
1152     @param reservesContract_ the new reserve contract
1153     *
1154     */
1155     function setReserveContract(address reservesContract_)
1156         public
1157         onlyGov
1158     {
1159         address oldReservesContract = reservesContract;
1160         reservesContract = reservesContract_;
1161         emit NewReserveContract(oldReservesContract, reservesContract_);
1162     }
1163 
1164 
1165     /** @notice sets the pendingGov
1166      * @param pendingGov_ The address of the rebaser contract to use for authentication.
1167      */
1168     function _setPendingGov(address pendingGov_)
1169         external
1170         onlyGov
1171     {
1172         address oldPendingGov = pendingGov;
1173         pendingGov = pendingGov_;
1174         emit NewPendingGov(oldPendingGov, pendingGov_);
1175     }
1176 
1177     /** @notice lets msg.sender accept governance
1178      *
1179      */
1180     function _acceptGov()
1181         external
1182     {
1183         require(msg.sender == pendingGov, "!pending");
1184         address oldGov = gov;
1185         gov = pendingGov;
1186         pendingGov = address(0);
1187         emit NewGov(oldGov, gov);
1188     }
1189 
1190     /** @notice Initializes TWAP start point, starts countdown to first rebase
1191     *
1192     */
1193     function init_twap()
1194         public
1195     {
1196         require(timeOfTWAPInit == 0, "already activated");
1197         (uint priceCumulative, uint32 blockTimestamp) =
1198            UniswapV2OracleLibrary.currentCumulativePrices(uniswap_pair, isToken0);
1199         require(blockTimestamp > 0, "no trades");
1200         blockTimestampLast = blockTimestamp;
1201         priceCumulativeLast = priceCumulative;
1202         timeOfTWAPInit = blockTimestamp;
1203     }
1204 
1205     /** @notice Activates rebasing
1206     *   @dev One way function, cannot be undone, callable by anyone
1207     */
1208     function activate_rebasing()
1209         public
1210     {
1211         require(timeOfTWAPInit > 0, "twap wasnt intitiated, call init_twap()");
1212         // ensure rebase activation is allowed
1213         require(now >= MIN_TIME_FIRST_REBASE, "!first_rebase");
1214         // cannot enable prior to end of rebaseDelay
1215         require(now >= timeOfTWAPInit + rebaseDelay, "!end_delay");
1216 
1217         rebasingActive = true;
1218     }
1219 
1220     /**
1221      * @notice Initiates a new rebase operation, provided the minimum time period has elapsed.
1222      *
1223      * @dev The supply adjustment equals (_totalSupply * DeviationFromTargetRate) / rebaseLag
1224      *      Where DeviationFromTargetRate is (MarketOracleRate - targetRate) / targetRate
1225      *      and targetRate is 1e18
1226      */
1227     function rebase()
1228         public
1229     {
1230         // EOA only or gov
1231         require(msg.sender == tx.origin);
1232         // ensure rebasing at correct time
1233         _inRebaseWindow();
1234 
1235         // This comparison also ensures there is no reentrancy.
1236         require(lastRebaseTimestampSec.add(minRebaseTimeIntervalSec) < now);
1237 
1238         // Snap the rebase time to the start of this window.
1239         lastRebaseTimestampSec = now.sub(
1240             now.mod(minRebaseTimeIntervalSec)).add(rebaseWindowOffsetSec);
1241 
1242         epoch = epoch.add(1);
1243 
1244         // get twap from uniswap v2;
1245         uint256 exchangeRate = getTWAP();
1246 
1247         // calculates % change to supply
1248         (uint256 offPegPerc, bool positive) = computeOffPegPerc(exchangeRate);
1249 
1250         uint256 indexDelta = offPegPerc;
1251 
1252         // Apply the Dampening factor.
1253         indexDelta = indexDelta.div(rebaseLag);
1254 
1255         YAMTokenInterface yam = YAMTokenInterface(yamAddress);
1256 
1257         if (positive) {
1258             require(yam.yamsScalingFactor().mul(BASE.add(indexDelta)).div(BASE) < yam.maxScalingFactor(), "new scaling factor will be too big");
1259         }
1260 
1261 
1262         uint256 currSupply = yam.totalSupply();
1263 
1264         uint256 mintAmount;
1265         // reduce indexDelta to account for minting
1266         if (positive) {
1267             uint256 mintPerc = indexDelta.mul(rebaseMintPerc).div(BASE);
1268             indexDelta = indexDelta.sub(mintPerc);
1269             mintAmount = currSupply.mul(mintPerc).div(BASE);
1270         }
1271 
1272         // rebase
1273         // ignore returned var
1274         yam.rebase(epoch, indexDelta, positive);
1275 
1276         // perform actions after rebase
1277         afterRebase(mintAmount, offPegPerc);
1278     }
1279 
1280 
1281     function uniswapV2Call(
1282         address sender,
1283         uint256 amount0,
1284         uint256 amount1,
1285         bytes memory data
1286     )
1287         public
1288     {
1289         // enforce that it is coming from uniswap
1290         require(msg.sender == uniswap_pair, "bad msg.sender");
1291         // enforce that this contract called uniswap
1292         require(sender == address(this), "bad origin");
1293         (UniVars memory uniVars) = abi.decode(data, (UniVars));
1294 
1295         YAMTokenInterface yam = YAMTokenInterface(yamAddress);
1296 
1297         if (uniVars.amountFromReserves > 0) {
1298             // transfer from reserves and mint to uniswap
1299             yam.transferFrom(reservesContract, uniswap_pair, uniVars.amountFromReserves);
1300             if (uniVars.amountFromReserves < uniVars.yamsToUni) {
1301                 // if the amount from reserves > yamsToUni, we have fully paid for the yCRV tokens
1302                 // thus this number would be 0 so no need to mint
1303                 yam.mint(uniswap_pair, uniVars.yamsToUni.sub(uniVars.amountFromReserves));
1304             }
1305         } else {
1306             // mint to uniswap
1307             yam.mint(uniswap_pair, uniVars.yamsToUni);
1308         }
1309 
1310         // mint unsold to mintAmount
1311         if (uniVars.mintToReserves > 0) {
1312             yam.mint(reservesContract, uniVars.mintToReserves);
1313         }
1314 
1315         // transfer reserve token to reserves
1316         if (isToken0) {
1317             if (public_goods != address(0) && public_goods_perc > 0) {
1318               uint256 amount_to_public_goods = amount1.mul(public_goods_perc).div(BASE);
1319               SafeERC20.safeTransfer(IERC20(reserveToken), reservesContract, amount1.sub(amount_to_public_goods));
1320               SafeERC20.safeTransfer(IERC20(reserveToken), public_goods, amount_to_public_goods);
1321               emit TreasuryIncreased(amount1.sub(amount_to_public_goods), uniVars.yamsToUni, uniVars.amountFromReserves, uniVars.mintToReserves);
1322             } else {
1323               SafeERC20.safeTransfer(IERC20(reserveToken), reservesContract, amount1);
1324               emit TreasuryIncreased(amount1, uniVars.yamsToUni, uniVars.amountFromReserves, uniVars.mintToReserves);
1325             }
1326         } else {
1327           if (public_goods != address(0) && public_goods_perc > 0) {
1328             uint256 amount_to_public_goods = amount0.mul(public_goods_perc).div(BASE);
1329             SafeERC20.safeTransfer(IERC20(reserveToken), reservesContract, amount0.sub(amount_to_public_goods));
1330             SafeERC20.safeTransfer(IERC20(reserveToken), public_goods, amount_to_public_goods);
1331             emit TreasuryIncreased(amount0.sub(amount_to_public_goods), uniVars.yamsToUni, uniVars.amountFromReserves, uniVars.mintToReserves);
1332           } else {
1333             SafeERC20.safeTransfer(IERC20(reserveToken), reservesContract, amount0);
1334             emit TreasuryIncreased(amount0, uniVars.yamsToUni, uniVars.amountFromReserves, uniVars.mintToReserves);
1335           }
1336         }
1337     }
1338 
1339     function buyReserveAndTransfer(
1340         uint256 mintAmount,
1341         uint256 offPegPerc
1342     )
1343         internal
1344     {
1345         UniswapPair pair = UniswapPair(uniswap_pair);
1346 
1347         YAMTokenInterface yam = YAMTokenInterface(yamAddress);
1348 
1349         // get reserves
1350         (uint256 token0Reserves, uint256 token1Reserves, ) = pair.getReserves();
1351 
1352         // check if protocol has excess yam in the reserve
1353         uint256 excess = yam.balanceOf(reservesContract);
1354 
1355 
1356         uint256 tokens_to_max_slippage = uniswapMaxSlippage(token0Reserves, token1Reserves, offPegPerc);
1357 
1358         UniVars memory uniVars = UniVars({
1359           yamsToUni: tokens_to_max_slippage, // how many yams uniswap needs
1360           amountFromReserves: excess, // how much of yamsToUni comes from reserves
1361           mintToReserves: 0 // how much yams protocol mints to reserves
1362         });
1363 
1364         // tries to sell all mint + excess
1365         // falls back to selling some of mint and all of excess
1366         // if all else fails, sells portion of excess
1367         // upon pair.swap, `uniswapV2Call` is called by the uniswap pair contract
1368         if (isToken0) {
1369             if (tokens_to_max_slippage > mintAmount.add(excess)) {
1370                 // we already have performed a safemath check on mintAmount+excess
1371                 // so we dont need to continue using it in this code path
1372 
1373                 // can handle selling all of reserves and mint
1374                 uint256 buyTokens = getAmountOut(mintAmount + excess, token0Reserves, token1Reserves);
1375                 uniVars.yamsToUni = mintAmount + excess;
1376                 uniVars.amountFromReserves = excess;
1377                 // call swap using entire mint amount and excess; mint 0 to reserves
1378                 pair.swap(0, buyTokens, address(this), abi.encode(uniVars));
1379             } else {
1380                 if (tokens_to_max_slippage > excess) {
1381                     // uniswap can handle entire reserves
1382                     uint256 buyTokens = getAmountOut(tokens_to_max_slippage, token0Reserves, token1Reserves);
1383 
1384                     // swap up to slippage limit, taking entire yam reserves, and minting part of total
1385                     uniVars.mintToReserves = mintAmount.sub((tokens_to_max_slippage - excess));
1386                     pair.swap(0, buyTokens, address(this), abi.encode(uniVars));
1387                 } else {
1388                     // uniswap cant handle all of excess
1389                     uint256 buyTokens = getAmountOut(tokens_to_max_slippage, token0Reserves, token1Reserves);
1390                     uniVars.amountFromReserves = tokens_to_max_slippage;
1391                     uniVars.mintToReserves = mintAmount;
1392                     // swap up to slippage limit, taking excess - remainingExcess from reserves, and minting full amount
1393                     // to reserves
1394                     pair.swap(0, buyTokens, address(this), abi.encode(uniVars));
1395                 }
1396             }
1397         } else {
1398             if (tokens_to_max_slippage > mintAmount.add(excess)) {
1399                 // can handle all of reserves and mint
1400                 uint256 buyTokens = getAmountOut(mintAmount + excess, token1Reserves, token0Reserves);
1401                 uniVars.yamsToUni = mintAmount + excess;
1402                 uniVars.amountFromReserves = excess;
1403                 // call swap using entire mint amount and excess; mint 0 to reserves
1404                 pair.swap(buyTokens, 0, address(this), abi.encode(uniVars));
1405             } else {
1406                 if (tokens_to_max_slippage > excess) {
1407                     // uniswap can handle entire reserves
1408                     uint256 buyTokens = getAmountOut(tokens_to_max_slippage, token1Reserves, token0Reserves);
1409 
1410                     // swap up to slippage limit, taking entire yam reserves, and minting part of total
1411                     uniVars.mintToReserves = mintAmount.sub( (tokens_to_max_slippage - excess));
1412                     // swap up to slippage limit, taking entire yam reserves, and minting part of total
1413                     pair.swap(buyTokens, 0, address(this), abi.encode(uniVars));
1414                 } else {
1415                     // uniswap cant handle all of excess
1416                     uint256 buyTokens = getAmountOut(tokens_to_max_slippage, token1Reserves, token0Reserves);
1417                     uniVars.amountFromReserves = tokens_to_max_slippage;
1418                     uniVars.mintToReserves = mintAmount;
1419                     // swap up to slippage limit, taking excess - remainingExcess from reserves, and minting full amount
1420                     // to reserves
1421                     pair.swap(buyTokens, 0, address(this), abi.encode(uniVars));
1422                 }
1423             }
1424         }
1425     }
1426 
1427     function uniswapMaxSlippage(
1428         uint256 token0,
1429         uint256 token1,
1430         uint256 offPegPerc
1431     )
1432       internal
1433       view
1434       returns (uint256)
1435     {
1436         if (isToken0) {
1437           if (offPegPerc >= 10**17) {
1438               // cap slippage
1439               return token0.mul(maxSlippageFactor).div(BASE);
1440           } else {
1441               // in the 5-10% off peg range, slippage is essentially 2*x (where x is percentage of pool to buy).
1442               // all we care about is not pushing below the peg, so underestimate
1443               // the amount we can sell by dividing by 3. resulting price impact
1444               // should be ~= offPegPerc * 2 / 3, which will keep us above the peg
1445               //
1446               // this is a conservative heuristic
1447               return token0.mul(offPegPerc).div(3 * BASE);
1448           }
1449         } else {
1450             if (offPegPerc >= 10**17) {
1451                 return token1.mul(maxSlippageFactor).div(BASE);
1452             } else {
1453                 return token1.mul(offPegPerc).div(3 * BASE);
1454             }
1455         }
1456     }
1457 
1458     /**
1459      * @notice given an input amount of an asset and pair reserves, returns the maximum output amount of the other asset
1460      *
1461      * @param amountIn input amount of the asset
1462      * @param reserveIn reserves of the asset being sold
1463      * @param reserveOut reserves if the asset being purchased
1464      */
1465 
1466    function getAmountOut(
1467         uint amountIn,
1468         uint reserveIn,
1469         uint reserveOut
1470     )
1471         internal
1472         pure
1473         returns (uint amountOut)
1474     {
1475        require(amountIn > 0, 'UniswapV2Library: INSUFFICIENT_INPUT_AMOUNT');
1476        require(reserveIn > 0 && reserveOut > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
1477        uint amountInWithFee = amountIn.mul(997);
1478        uint numerator = amountInWithFee.mul(reserveOut);
1479        uint denominator = reserveIn.mul(1000).add(amountInWithFee);
1480        amountOut = numerator / denominator;
1481    }
1482 
1483 
1484     function afterRebase(
1485         uint256 mintAmount,
1486         uint256 offPegPerc
1487     )
1488         internal
1489     {
1490         // update uniswap pairs
1491         for (uint256 i = 0; i < uniSyncPairs.length; i++) {
1492             UniswapPair(uniSyncPairs[i]).sync();
1493         }
1494 
1495         // update balancer pairs
1496         for (uint256 i = 0; i < balGulpPairs.length; i++) {
1497             BAL(balGulpPairs[i]).gulp(yamAddress);
1498         }
1499 
1500 
1501         if (mintAmount > 0) {
1502             buyReserveAndTransfer(
1503                 mintAmount,
1504                 offPegPerc
1505             );
1506         }
1507 
1508         // call any extra functions
1509         for (uint i = 0; i < transactions.length; i++) {
1510             Transaction storage t = transactions[i];
1511             if (t.enabled) {
1512                 bool result =
1513                     externalCall(t.destination, t.data);
1514                 if (!result) {
1515                     emit TransactionFailed(t.destination, i, t.data);
1516                     revert("Transaction Failed");
1517                 }
1518             }
1519         }
1520     }
1521 
1522 
1523     /**
1524      * @notice Calculates TWAP from uniswap
1525      *
1526      * @dev When liquidity is low, this can be manipulated by an end of block -> next block
1527      *      attack. We delay the activation of rebases 12 hours after liquidity incentives
1528      *      to reduce this attack vector. Additional there is very little supply
1529      *      to be able to manipulate this during that time period of highest vuln.
1530      */
1531     function getTWAP()
1532         internal
1533         returns (uint256)
1534     {
1535         (uint priceCumulative, uint32 blockTimestamp) =
1536             UniswapV2OracleLibrary.currentCumulativePrices(uniswap_pair, isToken0);
1537         uint32 timeElapsed = blockTimestamp - blockTimestampLast; // overflow is desired
1538 
1539         // no period check as is done in isRebaseWindow
1540 
1541 
1542         // overflow is desired
1543         uint256 priceAverage = uint256(uint224((priceCumulative - priceCumulativeLast) / timeElapsed));
1544 
1545         priceCumulativeLast = priceCumulative;
1546         blockTimestampLast = blockTimestamp;
1547 
1548         // BASE is on order of 1e18, which takes 2^60 bits
1549         // multiplication will revert if priceAverage > 2^196
1550         // (which it can because it overflows intentially)
1551         if (priceAverage > uint192(-1)) {
1552            // eat loss of precision
1553            // effectively: (x / 2**112) * 1e18
1554            return (priceAverage >> 112) * BASE;
1555         }
1556         // cant overflow
1557         // effectively: (x * 1e18 / 2**112)
1558         return (priceAverage * BASE) >> 112;
1559     }
1560 
1561     /**
1562      * @notice Calculates current TWAP from uniswap
1563      *
1564      */
1565     function getCurrentTWAP()
1566         public
1567         view
1568         returns (uint256)
1569     {
1570       (uint priceCumulative, uint32 blockTimestamp) =
1571          UniswapV2OracleLibrary.currentCumulativePrices(uniswap_pair, isToken0);
1572        uint32 timeElapsed = blockTimestamp - blockTimestampLast; // overflow is desired
1573 
1574        // no period check as is done in isRebaseWindow
1575 
1576        // overflow is desired
1577         uint256 priceAverage = uint256(uint224((priceCumulative - priceCumulativeLast) / timeElapsed));
1578 
1579         // BASE is on order of 1e18, which takes 2^60 bits
1580         // multiplication will revert if priceAverage > 2^196
1581         // (which it can because it overflows intentially)
1582         if (priceAverage > uint192(-1)) {
1583             // eat loss of precision
1584             // effectively: (x / 2**112) * 1e18
1585             return (priceAverage >> 112) * BASE;
1586         }
1587         // cant overflow
1588         // effectively: (x * 1e18 / 2**112)
1589         return (priceAverage * BASE) >> 112;
1590     }
1591 
1592     /**
1593      * @notice Sets the deviation threshold fraction. If the exchange rate given by the market
1594      *         oracle is within this fractional distance from the targetRate, then no supply
1595      *         modifications are made.
1596      * @param deviationThreshold_ The new exchange rate threshold fraction.
1597      */
1598     function setDeviationThreshold(uint256 deviationThreshold_)
1599         external
1600         onlyGov
1601     {
1602         require(deviationThreshold > 0);
1603         uint256 oldDeviationThreshold = deviationThreshold;
1604         deviationThreshold = deviationThreshold_;
1605         emit NewDeviationThreshold(oldDeviationThreshold, deviationThreshold_);
1606     }
1607 
1608     /**
1609      * @notice Sets the rebase lag parameter.
1610                It is used to dampen the applied supply adjustment by 1 / rebaseLag
1611                If the rebase lag R, equals 1, the smallest value for R, then the full supply
1612                correction is applied on each rebase cycle.
1613                If it is greater than 1, then a correction of 1/R of is applied on each rebase.
1614      * @param rebaseLag_ The new rebase lag parameter.
1615      */
1616     function setRebaseLag(uint256 rebaseLag_)
1617         external
1618         onlyGov
1619     {
1620         require(rebaseLag_ > 0);
1621         rebaseLag = rebaseLag_;
1622     }
1623 
1624     /**
1625      * @notice Sets the targetRate parameter.
1626      * @param targetRate_ The new target rate parameter.
1627      */
1628     function setTargetRate(uint256 targetRate_)
1629         external
1630         onlyGov
1631     {
1632         require(targetRate_ > 0);
1633         targetRate = targetRate_;
1634     }
1635 
1636     /**
1637      * @notice Sets the parameters which control the timing and frequency of
1638      *         rebase operations.
1639      *         a) the minimum time period that must elapse between rebase cycles.
1640      *         b) the rebase window offset parameter.
1641      *         c) the rebase window length parameter.
1642      * @param minRebaseTimeIntervalSec_ More than this much time must pass between rebase
1643      *        operations, in seconds.
1644      * @param rebaseWindowOffsetSec_ The number of seconds from the beginning of
1645               the rebase interval, where the rebase window begins.
1646      * @param rebaseWindowLengthSec_ The length of the rebase window in seconds.
1647      */
1648     function setRebaseTimingParameters(
1649         uint256 minRebaseTimeIntervalSec_,
1650         uint256 rebaseWindowOffsetSec_,
1651         uint256 rebaseWindowLengthSec_)
1652         external
1653         onlyGov
1654     {
1655         require(minRebaseTimeIntervalSec_ > 0);
1656         require(rebaseWindowOffsetSec_ < minRebaseTimeIntervalSec_);
1657         require(rebaseWindowOffsetSec_ + rebaseWindowLengthSec_ < minRebaseTimeIntervalSec_);
1658         minRebaseTimeIntervalSec = minRebaseTimeIntervalSec_;
1659         rebaseWindowOffsetSec = rebaseWindowOffsetSec_;
1660         rebaseWindowLengthSec = rebaseWindowLengthSec_;
1661     }
1662 
1663     /**
1664      * @return If the latest block timestamp is within the rebase time window it, returns true.
1665      *         Otherwise, returns false.
1666      */
1667     function inRebaseWindow() public view returns (bool) {
1668 
1669         // rebasing is delayed until there is a liquid market
1670         _inRebaseWindow();
1671         return true;
1672     }
1673 
1674     function _inRebaseWindow() internal view {
1675 
1676         // rebasing is delayed until there is a liquid market
1677         require(rebasingActive, "rebasing not active");
1678 
1679         require(now.mod(minRebaseTimeIntervalSec) >= rebaseWindowOffsetSec, "too early");
1680         require(now.mod(minRebaseTimeIntervalSec) < (rebaseWindowOffsetSec.add(rebaseWindowLengthSec)), "too late");
1681     }
1682 
1683     /**
1684      * @return Computes in % how far off market is from peg
1685      */
1686     function computeOffPegPerc(uint256 rate)
1687         private
1688         view
1689         returns (uint256, bool)
1690     {
1691         if (withinDeviationThreshold(rate)) {
1692             return (0, false);
1693         }
1694 
1695         // indexDelta =  (rate - targetRate) / targetRate
1696         if (rate > targetRate) {
1697             return (rate.sub(targetRate).mul(BASE).div(targetRate), true);
1698         } else {
1699             return (targetRate.sub(rate).mul(BASE).div(targetRate), false);
1700         }
1701     }
1702 
1703     /**
1704      * @param rate The current exchange rate, an 18 decimal fixed point number.
1705      * @return If the rate is within the deviation threshold from the target rate, returns true.
1706      *         Otherwise, returns false.
1707      */
1708     function withinDeviationThreshold(uint256 rate)
1709         private
1710         view
1711         returns (bool)
1712     {
1713         uint256 absoluteDeviationThreshold = targetRate.mul(deviationThreshold)
1714             .div(10 ** 18);
1715 
1716         return (rate >= targetRate && rate.sub(targetRate) < absoluteDeviationThreshold)
1717             || (rate < targetRate && targetRate.sub(rate) < absoluteDeviationThreshold);
1718     }
1719 
1720     /* - Constructor Helpers - */
1721 
1722     // calculates the CREATE2 address for a pair without making any external calls
1723     function pairFor(
1724         address factory,
1725         address token0,
1726         address token1
1727     )
1728         internal
1729         pure
1730         returns (address pair)
1731     {
1732         pair = address(uint(keccak256(abi.encodePacked(
1733                 hex'ff',
1734                 factory,
1735                 keccak256(abi.encodePacked(token0, token1)),
1736                 hex'96e8ac4277198ff8b6f785478aa9a39f403cb768dd02cbee326c3e7da348845f' // init code hash
1737             ))));
1738     }
1739 
1740     // returns sorted token addresses, used to handle return values from pairs sorted in this order
1741     function sortTokens(
1742         address tokenA,
1743         address tokenB
1744     )
1745         internal
1746         pure
1747         returns (address token0, address token1)
1748     {
1749         require(tokenA != tokenB, 'UniswapV2Library: IDENTICAL_ADDRESSES');
1750         (token0, token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
1751         require(token0 != address(0), 'UniswapV2Library: ZERO_ADDRESS');
1752     }
1753 
1754     /* -- Rebase helpers -- */
1755 
1756     /**
1757      * @notice Adds a transaction that gets called for a downstream receiver of rebases
1758      * @param destination Address of contract destination
1759      * @param data Transaction data payload
1760      */
1761     function addTransaction(address destination, bytes calldata data)
1762         external
1763         onlyGov
1764     {
1765         transactions.push(Transaction({
1766             enabled: true,
1767             destination: destination,
1768             data: data
1769         }));
1770     }
1771 
1772 
1773     /**
1774      * @param index Index of transaction to remove.
1775      *              Transaction ordering may have changed since adding.
1776      */
1777     function removeTransaction(uint index)
1778         external
1779         onlyGov
1780     {
1781         require(index < transactions.length, "index out of bounds");
1782 
1783         if (index < transactions.length - 1) {
1784             transactions[index] = transactions[transactions.length - 1];
1785         }
1786 
1787         transactions.length--;
1788     }
1789 
1790     /**
1791      * @param index Index of transaction. Transaction ordering may have changed since adding.
1792      * @param enabled True for enabled, false for disabled.
1793      */
1794     function setTransactionEnabled(uint index, bool enabled)
1795         external
1796         onlyGov
1797     {
1798         require(index < transactions.length, "index must be in range of stored tx list");
1799         transactions[index].enabled = enabled;
1800     }
1801 
1802     /**
1803      * @dev wrapper to call the encoded transactions on downstream consumers.
1804      * @param destination Address of destination contract.
1805      * @param data The encoded data payload.
1806      * @return True on success
1807      */
1808     function externalCall(address destination, bytes memory data)
1809         internal
1810         returns (bool)
1811     {
1812         bool result;
1813         assembly {  // solhint-disable-line no-inline-assembly
1814             // "Allocate" memory for output
1815             // (0x40 is where "free memory" pointer is stored by convention)
1816             let outputAddress := mload(0x40)
1817 
1818             // First 32 bytes are the padded length of data, so exclude that
1819             let dataAddress := add(data, 32)
1820 
1821             result := call(
1822                 // 34710 is the value that solidity is currently emitting
1823                 // It includes callGas (700) + callVeryLow (3, to pay for SUB)
1824                 // + callValueTransferGas (9000) + callNewAccountGas
1825                 // (25000, in case the destination address does not exist and needs creating)
1826                 sub(gas, 34710),
1827 
1828 
1829                 destination,
1830                 0, // transfer value in wei
1831                 dataAddress,
1832                 mload(data),  // Size of the input, in bytes. Stored in position 0 of the array.
1833                 outputAddress,
1834                 0  // Output is ignored, therefore the output size is zero
1835             )
1836         }
1837         return result;
1838     }
1839 
1840 
1841     // Rescue tokens
1842     function rescueTokens(
1843         address token,
1844         address to,
1845         uint256 amount
1846     )
1847         external
1848         onlyGov
1849         returns (bool)
1850     {
1851         // transfer to
1852         SafeERC20.safeTransfer(IERC20(token), to, amount);
1853     }
1854 }