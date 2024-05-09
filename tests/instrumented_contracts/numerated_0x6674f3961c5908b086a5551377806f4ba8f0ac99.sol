1 // SPDX-License-Identifier: MIT
2 // File: contracts/BIFI/zap/IUniswapV2Pair.sol
3 
4 pragma solidity >=0.5.0;
5 
6 interface IUniswapV2Pair {
7     event Approval(address indexed owner, address indexed spender, uint value);
8     event Transfer(address indexed from, address indexed to, uint value);
9 
10     function name() external pure returns (string memory);
11     function symbol() external pure returns (string memory);
12     function decimals() external pure returns (uint8);
13     function totalSupply() external view returns (uint);
14     function balanceOf(address owner) external view returns (uint);
15     function allowance(address owner, address spender) external view returns (uint);
16 
17     function approve(address spender, uint value) external returns (bool);
18     function transfer(address to, uint value) external returns (bool);
19     function transferFrom(address from, address to, uint value) external returns (bool);
20 
21     function DOMAIN_SEPARATOR() external view returns (bytes32);
22     function PERMIT_TYPEHASH() external pure returns (bytes32);
23     function nonces(address owner) external view returns (uint);
24 
25     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
26 
27     event Mint(address indexed sender, uint amount0, uint amount1);
28     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
29     event Swap(
30         address indexed sender,
31         uint amount0In,
32         uint amount1In,
33         uint amount0Out,
34         uint amount1Out,
35         address indexed to
36     );
37     event Sync(uint112 reserve0, uint112 reserve1);
38 
39     function MINIMUM_LIQUIDITY() external pure returns (uint);
40     function factory() external view returns (address);
41     function token0() external view returns (address);
42     function token1() external view returns (address);
43     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
44     function price0CumulativeLast() external view returns (uint);
45     function price1CumulativeLast() external view returns (uint);
46     function kLast() external view returns (uint);
47 
48     function mint(address to) external returns (uint liquidity);
49     function burn(address to) external returns (uint amount0, uint amount1);
50     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
51     function skim(address to) external;
52     function sync() external;
53     function stable() external view returns (bool);
54     function getAmountOut(uint256 amountIn, address tokenIn) external view returns (uint256);
55 
56     function initialize(address, address) external;
57 }
58 
59 // File: contracts/BIFI/zap/Babylonian.sol
60 
61 
62 pragma solidity >=0.4.0;
63 
64 // computes square roots using the babylonian method
65 // https://en.wikipedia.org/wiki/Methods_of_computing_square_roots#Babylonian_method
66 library Babylonian {
67     // credit for this implementation goes to
68     // https://github.com/abdk-consulting/abdk-libraries-solidity/blob/master/ABDKMath64x64.sol#L687
69     function sqrt(uint256 x) internal pure returns (uint256) {
70         if (x == 0) return 0;
71         // this block is equivalent to r = uint256(1) << (BitMath.mostSignificantBit(x) / 2);
72         // however that code costs significantly more gas
73         uint256 xx = x;
74         uint256 r = 1;
75         if (xx >= 0x100000000000000000000000000000000) {
76             xx >>= 128;
77             r <<= 64;
78         }
79         if (xx >= 0x10000000000000000) {
80             xx >>= 64;
81             r <<= 32;
82         }
83         if (xx >= 0x100000000) {
84             xx >>= 32;
85             r <<= 16;
86         }
87         if (xx >= 0x10000) {
88             xx >>= 16;
89             r <<= 8;
90         }
91         if (xx >= 0x100) {
92             xx >>= 8;
93             r <<= 4;
94         }
95         if (xx >= 0x10) {
96             xx >>= 4;
97             r <<= 2;
98         }
99         if (xx >= 0x8) {
100             r <<= 1;
101         }
102         r = (r + x / r) >> 1;
103         r = (r + x / r) >> 1;
104         r = (r + x / r) >> 1;
105         r = (r + x / r) >> 1;
106         r = (r + x / r) >> 1;
107         r = (r + x / r) >> 1;
108         r = (r + x / r) >> 1; // Seven iterations should be enough
109         uint256 r1 = x / r;
110         return (r < r1 ? r : r1);
111     }
112 }
113 
114 // File: contracts/BIFI/zap/IERC20.sol
115 
116 
117 pragma solidity >=0.6.0 <0.9.0;
118 
119 /**
120  * @dev Interface of the ERC20 standard as defined in the EIP.
121  */
122 interface IERC20 {
123     /**
124      * @dev Returns the amount of tokens in existence.
125      */
126     function totalSupply() external view returns (uint256);
127 
128     /**
129      * @dev Returns the amount of tokens owned by `account`.
130      */
131     function balanceOf(address account) external view returns (uint256);
132 
133     /**
134      * @dev Moves `amount` tokens from the caller's account to `recipient`.
135      *
136      * Returns a boolean value indicating whether the operation succeeded.
137      *
138      * Emits a {Transfer} event.
139      */
140     function transfer(address recipient, uint256 amount) external returns (bool);
141 
142     /**
143      * @dev Returns the remaining number of tokens that `spender` will be
144      * allowed to spend on behalf of `owner` through {transferFrom}. This is
145      * zero by default.
146      *
147      * This value changes when {approve} or {transferFrom} are called.
148      */
149     function allowance(address owner, address spender) external view returns (uint256);
150 
151     /**
152      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
153      *
154      * Returns a boolean value indicating whether the operation succeeded.
155      *
156      * IMPORTANT: Beware that changing an allowance with this method brings the risk
157      * that someone may use both the old and the new allowance by unfortunate
158      * transaction ordering. One possible solution to mitigate this race
159      * condition is to first reduce the spender's allowance to 0 and set the
160      * desired value afterwards:
161      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
162      *
163      * Emits an {Approval} event.
164      */
165     function approve(address spender, uint256 amount) external returns (bool);
166 
167     /**
168      * @dev Moves `amount` tokens from `sender` to `recipient` using the
169      * allowance mechanism. `amount` is then deducted from the caller's
170      * allowance.
171      *
172      * Returns a boolean value indicating whether the operation succeeded.
173      *
174      * Emits a {Transfer} event.
175      */
176     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
177 
178     /**
179      * @dev Emitted when `value` tokens are moved from one account (`from`) to
180      * another (`to`).
181      *
182      * Note that `value` may be zero.
183      */
184     event Transfer(address indexed from, address indexed to, uint256 value);
185 
186     /**
187      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
188      * a call to {approve}. `value` is the new allowance.
189      */
190     event Approval(address indexed owner, address indexed spender, uint256 value);
191 }
192 
193 // File: contracts/BIFI/zap/SafeMath.sol
194 
195 
196 pragma solidity >=0.6.0 <0.9.0;
197 
198 /**
199  * @dev Wrappers over Solidity's arithmetic operations with added overflow
200  * checks.
201  *
202  * Arithmetic operations in Solidity wrap on overflow. This can easily result
203  * in bugs, because programmers usually assume that an overflow raises an
204  * error, which is the standard behavior in high level programming languages.
205  * `SafeMath` restores this intuition by reverting the transaction when an
206  * operation overflows.
207  *
208  * Using this library instead of the unchecked operations eliminates an entire
209  * class of bugs, so it's recommended to use it always.
210  */
211 library SafeMath {
212     /**
213      * @dev Returns the addition of two unsigned integers, reverting on
214      * overflow.
215      *
216      * Counterpart to Solidity's `+` operator.
217      *
218      * Requirements:
219      *
220      * - Addition cannot overflow.
221      */
222     function add(uint256 a, uint256 b) internal pure returns (uint256) {
223         uint256 c = a + b;
224         require(c >= a, "SafeMath: addition overflow");
225 
226         return c;
227     }
228 
229     /**
230      * @dev Returns the subtraction of two unsigned integers, reverting on
231      * overflow (when the result is negative).
232      *
233      * Counterpart to Solidity's `-` operator.
234      *
235      * Requirements:
236      *
237      * - Subtraction cannot overflow.
238      */
239     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
240         return sub(a, b, "SafeMath: subtraction overflow");
241     }
242 
243     /**
244      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
245      * overflow (when the result is negative).
246      *
247      * Counterpart to Solidity's `-` operator.
248      *
249      * Requirements:
250      *
251      * - Subtraction cannot overflow.
252      */
253     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
254         require(b <= a, errorMessage);
255         uint256 c = a - b;
256 
257         return c;
258     }
259 
260     /**
261      * @dev Returns the multiplication of two unsigned integers, reverting on
262      * overflow.
263      *
264      * Counterpart to Solidity's `*` operator.
265      *
266      * Requirements:
267      *
268      * - Multiplication cannot overflow.
269      */
270     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
271         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
272         // benefit is lost if 'b' is also tested.
273         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
274         if (a == 0) {
275             return 0;
276         }
277 
278         uint256 c = a * b;
279         require(c / a == b, "SafeMath: multiplication overflow");
280 
281         return c;
282     }
283 
284     /**
285      * @dev Returns the integer division of two unsigned integers. Reverts on
286      * division by zero. The result is rounded towards zero.
287      *
288      * Counterpart to Solidity's `/` operator. Note: this function uses a
289      * `revert` opcode (which leaves remaining gas untouched) while Solidity
290      * uses an invalid opcode to revert (consuming all remaining gas).
291      *
292      * Requirements:
293      *
294      * - The divisor cannot be zero.
295      */
296     function div(uint256 a, uint256 b) internal pure returns (uint256) {
297         return div(a, b, "SafeMath: division by zero");
298     }
299 
300     /**
301      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
302      * division by zero. The result is rounded towards zero.
303      *
304      * Counterpart to Solidity's `/` operator. Note: this function uses a
305      * `revert` opcode (which leaves remaining gas untouched) while Solidity
306      * uses an invalid opcode to revert (consuming all remaining gas).
307      *
308      * Requirements:
309      *
310      * - The divisor cannot be zero.
311      */
312     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
313         require(b > 0, errorMessage);
314         uint256 c = a / b;
315         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
316 
317         return c;
318     }
319 
320     /**
321      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
322      * Reverts when dividing by zero.
323      *
324      * Counterpart to Solidity's `%` operator. This function uses a `revert`
325      * opcode (which leaves remaining gas untouched) while Solidity uses an
326      * invalid opcode to revert (consuming all remaining gas).
327      *
328      * Requirements:
329      *
330      * - The divisor cannot be zero.
331      */
332     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
333         return mod(a, b, "SafeMath: modulo by zero");
334     }
335 
336     /**
337      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
338      * Reverts with custom message when dividing by zero.
339      *
340      * Counterpart to Solidity's `%` operator. This function uses a `revert`
341      * opcode (which leaves remaining gas untouched) while Solidity uses an
342      * invalid opcode to revert (consuming all remaining gas).
343      *
344      * Requirements:
345      *
346      * - The divisor cannot be zero.
347      */
348     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
349         require(b != 0, errorMessage);
350         return a % b;
351     }
352 }
353 
354 // File: contracts/BIFI/zap/Address.sol
355 
356 
357 pragma solidity >=0.6.2 <0.9.0;
358 
359 /**
360  * @dev Collection of functions related to the address type
361  */
362 library Address {
363     /**
364      * @dev Returns true if `account` is a contract.
365      *
366      * [IMPORTANT]
367      * ====
368      * It is unsafe to assume that an address for which this function returns
369      * false is an externally-owned account (EOA) and not a contract.
370      *
371      * Among others, `isContract` will return false for the following
372      * types of addresses:
373      *
374      *  - an externally-owned account
375      *  - a contract in construction
376      *  - an address where a contract will be created
377      *  - an address where a contract lived, but was destroyed
378      * ====
379      */
380     function isContract(address account) internal view returns (bool) {
381         // This method relies on extcodesize, which returns 0 for contracts in
382         // construction, since the code is only stored at the end of the
383         // constructor execution.
384 
385         uint256 size;
386         // solhint-disable-next-line no-inline-assembly
387         assembly { size := extcodesize(account) }
388         return size > 0;
389     }
390 
391     /**
392      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
393      * `recipient`, forwarding all available gas and reverting on errors.
394      *
395      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
396      * of certain opcodes, possibly making contracts go over the 2300 gas limit
397      * imposed by `transfer`, making them unable to receive funds via
398      * `transfer`. {sendValue} removes this limitation.
399      *
400      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
401      *
402      * IMPORTANT: because control is transferred to `recipient`, care must be
403      * taken to not create reentrancy vulnerabilities. Consider using
404      * {ReentrancyGuard} or the
405      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
406      */
407     function sendValue(address payable recipient, uint256 amount) internal {
408         require(address(this).balance >= amount, "Address: insufficient balance");
409 
410         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
411         (bool success, ) = recipient.call{ value: amount }("");
412         require(success, "Address: unable to send value, recipient may have reverted");
413     }
414 
415     /**
416      * @dev Performs a Solidity function call using a low level `call`. A
417      * plain`call` is an unsafe replacement for a function call: use this
418      * function instead.
419      *
420      * If `target` reverts with a revert reason, it is bubbled up by this
421      * function (like regular Solidity function calls).
422      *
423      * Returns the raw returned data. To convert to the expected return value,
424      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
425      *
426      * Requirements:
427      *
428      * - `target` must be a contract.
429      * - calling `target` with `data` must not revert.
430      *
431      * _Available since v3.1._
432      */
433     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
434       return functionCall(target, data, "Address: low-level call failed");
435     }
436 
437     /**
438      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
439      * `errorMessage` as a fallback revert reason when `target` reverts.
440      *
441      * _Available since v3.1._
442      */
443     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
444         return functionCallWithValue(target, data, 0, errorMessage);
445     }
446 
447     /**
448      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
449      * but also transferring `value` wei to `target`.
450      *
451      * Requirements:
452      *
453      * - the calling contract must have an ETH balance of at least `value`.
454      * - the called Solidity function must be `payable`.
455      *
456      * _Available since v3.1._
457      */
458     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
459         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
460     }
461 
462     /**
463      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
464      * with `errorMessage` as a fallback revert reason when `target` reverts.
465      *
466      * _Available since v3.1._
467      */
468     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
469         require(address(this).balance >= value, "Address: insufficient balance for call");
470         require(isContract(target), "Address: call to non-contract");
471 
472         // solhint-disable-next-line avoid-low-level-calls
473         (bool success, bytes memory returndata) = target.call{ value: value }(data);
474         return _verifyCallResult(success, returndata, errorMessage);
475     }
476 
477     /**
478      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
479      * but performing a static call.
480      *
481      * _Available since v3.3._
482      */
483     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
484         return functionStaticCall(target, data, "Address: low-level static call failed");
485     }
486 
487     /**
488      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
489      * but performing a static call.
490      *
491      * _Available since v3.3._
492      */
493     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
494         require(isContract(target), "Address: static call to non-contract");
495 
496         // solhint-disable-next-line avoid-low-level-calls
497         (bool success, bytes memory returndata) = target.staticcall(data);
498         return _verifyCallResult(success, returndata, errorMessage);
499     }
500 
501     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
502         if (success) {
503             return returndata;
504         } else {
505             // Look for revert reason and bubble it up if present
506             if (returndata.length > 0) {
507                 // The easiest way to bubble the revert reason is using memory via assembly
508 
509                 // solhint-disable-next-line no-inline-assembly
510                 assembly {
511                     let returndata_size := mload(returndata)
512                     revert(add(32, returndata), returndata_size)
513                 }
514             } else {
515                 revert(errorMessage);
516             }
517         }
518     }
519 }
520 
521 // File: contracts/BIFI/zap/SafeERC20.sol
522 
523 
524 pragma solidity >=0.6.0 <0.9.0;
525 
526 
527 
528 
529 /**
530  * @title SafeERC20
531  * @dev Wrappers around ERC20 operations that throw on failure (when the token
532  * contract returns false). Tokens that return no value (and instead revert or
533  * throw on failure) are also supported, non-reverting calls are assumed to be
534  * successful.
535  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
536  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
537  */
538 library SafeERC20 {
539     using SafeMath for uint256;
540     using Address for address;
541 
542     function safeTransfer(IERC20 token, address to, uint256 value) internal {
543         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
544     }
545 
546     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
547         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
548     }
549 
550     /**
551      * @dev Deprecated. This function has issues similar to the ones found in
552      * {IERC20-approve}, and its usage is discouraged.
553      *
554      * Whenever possible, use {safeIncreaseAllowance} and
555      * {safeDecreaseAllowance} instead.
556      */
557     function safeApprove(IERC20 token, address spender, uint256 value) internal {
558         // safeApprove should only be called when setting an initial allowance,
559         // or when resetting it to zero. To increase and decrease it, use
560         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
561         // solhint-disable-next-line max-line-length
562         require((value == 0) || (token.allowance(address(this), spender) == 0),
563             "SafeERC20: approve from non-zero to non-zero allowance"
564         );
565         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
566     }
567 
568     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
569         uint256 newAllowance = token.allowance(address(this), spender).add(value);
570         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
571     }
572 
573     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
574         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
575         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
576     }
577 
578     /**
579      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
580      * on the return value: the return value is optional (but if data is returned, it must not be false).
581      * @param token The token targeted by the call.
582      * @param data The call data (encoded using abi.encode or one of its variants).
583      */
584     function _callOptionalReturn(IERC20 token, bytes memory data) private {
585         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
586         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
587         // the target address contains contract code and also asserts for success in the low-level call.
588 
589         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
590         if (returndata.length > 0) { // Return data is optional
591             // solhint-disable-next-line max-line-length
592             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
593         }
594     }
595 }
596 
597 // File: contracts/BIFI/zap/LowGasSafeMath.sol
598 
599 pragma solidity >=0.7.0;
600 
601 /// @title Optimized overflow and underflow safe math operations
602 /// @notice Contains methods for doing math operations that revert on overflow or underflow for minimal gas cost
603 library LowGasSafeMath {
604     /// @notice Returns x + y, reverts if sum overflows uint256
605     /// @param x The augend
606     /// @param y The addend
607     /// @return z The sum of x and y
608     function add(uint256 x, uint256 y) internal pure returns (uint256 z) {
609         require((z = x + y) >= x);
610     }
611 
612     /// @notice Returns x - y, reverts if underflows
613     /// @param x The minuend
614     /// @param y The subtrahend
615     /// @return z The difference of x and y
616     function sub(uint256 x, uint256 y) internal pure returns (uint256 z) {
617         require((z = x - y) <= x);
618     }
619 
620     /// @notice Returns x * y, reverts if overflows
621     /// @param x The multiplicand
622     /// @param y The multiplier
623     /// @return z The product of x and y
624     function mul(uint256 x, uint256 y) internal pure returns (uint256 z) {
625         require(x == 0 || (z = x * y) / x == y);
626     }
627 
628     /// @notice Returns x + y, reverts if overflows or underflows
629     /// @param x The augend
630     /// @param y The addend
631     /// @return z The sum of x and y
632     function add(int256 x, int256 y) internal pure returns (int256 z) {
633         require((z = x + y) >= x == (y >= 0));
634     }
635 
636     /// @notice Returns x - y, reverts if overflows or underflows
637     /// @param x The minuend
638     /// @param y The subtrahend
639     /// @return z The difference of x and y
640     function sub(int256 x, int256 y) internal pure returns (int256 z) {
641         require((z = x - y) <= x == (y >= 0));
642     }
643 }
644 
645 // File: contracts/BIFI/zap/IUniswapV2Router01.sol
646 
647 pragma solidity >=0.6.0 <0.9.0;
648 interface IUniswapRouterSolidly {
649 
650 
651     function addLiquidity(
652         address tokenA,
653         address tokenB,
654         bool stable,
655         uint amountADesired,
656         uint amountBDesired,
657         uint amountAMin,
658         uint amountBMin,
659         address to,
660         uint deadline
661     ) external returns (uint amountA, uint amountB, uint liquidity);
662 
663     function addLiquidityETH(
664         address token,
665         bool stable, 
666         uint amountTokenDesired,
667         uint amountTokenMin,
668         uint amountETHMin,
669         address to,
670         uint deadline
671     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
672 
673     function removeLiquidity(
674         address tokenA,
675         address tokenB,
676         bool stable, 
677         uint liquidity,
678         uint amountAMin,
679         uint amountBMin,
680         address to,
681         uint deadline
682     ) external returns (uint amountA, uint amountB);
683 
684     function removeLiquidityETH(
685         address token,
686         bool stable,
687         uint liquidity,
688         uint amountTokenMin,
689         uint amountETHMin,
690         address to,
691         uint deadline
692     ) external returns (uint amountToken, uint amountETH);
693 
694     function swapExactTokensForTokensSimple(
695         uint amountIn, 
696         uint amountOutMin, 
697         address tokenFrom, 
698         address tokenTo,
699         bool stable, 
700         address to, 
701         uint deadline
702     ) external returns (uint[] memory amounts);
703 
704     function getAmountOut(uint amountIn, address tokenIn, address tokenOut) external view returns (uint amount, bool stable);
705    
706     function quoteAddLiquidity(
707         address tokenA,
708         address tokenB,
709         bool stable,
710         uint amountADesired,
711         uint amountBDesired
712     ) external view returns (uint amountA, uint amountB, uint liquidity);
713 
714     function quoteLiquidity(uint amountA, uint reserveA, uint reserveB) external view returns (uint amountB);
715     function factory() external view returns (address);
716     function weth() external view returns (address);
717 }
718 
719 
720 // File: contracts/BIFI/zap/BeefyUniV2Zap.sol
721 
722 
723 // This program is free software: you can redistribute it and/or modify
724 // it under the terms of the GNU Affero General Public License as published by
725 // the Free Software Foundation, either version 2 of the License, or
726 // (at your option) any later version.
727 //
728 // This program is distributed in the hope that it will be useful,
729 // but WITHOUT ANY WARRANTY; without even the implied warranty of
730 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
731 // GNU Affero General Public License for more details.
732 
733 // @author Wivern for Beefy.Finance
734 // @notice This contract adds liquidity to Uniswap V2 compatible liquidity pair pools and stake.
735 
736 pragma solidity >=0.7.0;
737 
738 
739 
740 interface IERC20Extended { 
741     function decimals() external view returns (uint256);
742 }
743 
744 
745 interface IWETH is IERC20 {
746     function deposit() external payable;
747     function withdraw(uint256 wad) external;
748 }
749 
750 interface IBeefyVaultV6 is IERC20 {
751     function deposit(uint256 amount) external;
752     function withdraw(uint256 shares) external;
753     function want() external pure returns (address);
754 }
755 
756 contract BeefyUniV2ZapSolidly {
757     using LowGasSafeMath for uint256;
758     using SafeERC20 for IERC20;
759     using SafeERC20 for IBeefyVaultV6;
760 
761     
762     IUniswapRouterSolidly public immutable router;
763     address public immutable WETH;
764     uint256 public constant minimumAmount = 1000;
765     
766     constructor(address _router, address _WETH) {
767         router = IUniswapRouterSolidly(_router);
768         WETH = _WETH;
769     }
770 
771     receive() external payable {
772         assert(msg.sender == WETH);
773     }
774 
775     function beefInETH (address beefyVault, uint256 tokenAmountOutMin) external payable {
776         require(msg.value >= minimumAmount, 'Beefy: Insignificant input amount');
777 
778         IWETH(WETH).deposit{value: msg.value}();
779 
780         _swapAndStake(beefyVault, tokenAmountOutMin, WETH);
781     }
782 
783     function beefIn (address beefyVault, uint256 tokenAmountOutMin, address tokenIn, uint256 tokenInAmount) external {
784         require(tokenInAmount >= minimumAmount, 'Beefy: Insignificant input amount');
785         require(IERC20(tokenIn).allowance(msg.sender, address(this)) >= tokenInAmount, 'Beefy: Input token is not approved');
786 
787         IERC20(tokenIn).safeTransferFrom(msg.sender, address(this), tokenInAmount);
788 
789         _swapAndStake(beefyVault, tokenAmountOutMin, tokenIn);
790     }
791 
792     function beefOut (address beefyVault, uint256 withdrawAmount) external {
793         (IBeefyVaultV6 vault, IUniswapV2Pair pair) = _getVaultPair(beefyVault);
794 
795         IERC20(beefyVault).safeTransferFrom(msg.sender, address(this), withdrawAmount);
796         vault.withdraw(withdrawAmount);
797 
798         if (pair.token0() != WETH && pair.token1() != WETH) {
799             return _removeLiquidity(address(pair), msg.sender);
800         }
801 
802         _removeLiquidity(address(pair), address(this));
803 
804         address[] memory tokens = new address[](2);
805         tokens[0] = pair.token0();
806         tokens[1] = pair.token1();
807 
808         _returnAssets(tokens);
809     }
810 
811     function beefOutAndSwap(address beefyVault, uint256 withdrawAmount, address desiredToken, uint256 desiredTokenOutMin) external {
812         (IBeefyVaultV6 vault, IUniswapV2Pair pair) = _getVaultPair(beefyVault);
813         address token0 = pair.token0();
814         address token1 = pair.token1();
815         require(token0 == desiredToken || token1 == desiredToken, 'Beefy: desired token not present in liqudity pair');
816 
817         vault.safeTransferFrom(msg.sender, address(this), withdrawAmount);
818         vault.withdraw(withdrawAmount);
819         _removeLiquidity(address(pair), address(this));
820 
821         address swapToken = token1 == desiredToken ? token0 : token1;
822         address[] memory path = new address[](2);
823         path[0] = swapToken;
824         path[1] = desiredToken;
825 
826         _approveTokenIfNeeded(path[0], address(router));
827         router.swapExactTokensForTokensSimple(IERC20(swapToken).balanceOf(address(this)), desiredTokenOutMin, path[0], path[1], pair.stable(), address(this), block.timestamp);
828 
829         _returnAssets(path);
830     }
831 
832     function _removeLiquidity(address pair, address to) private {
833         IERC20(pair).safeTransfer(pair, IERC20(pair).balanceOf(address(this)));
834         (uint256 amount0, uint256 amount1) = IUniswapV2Pair(pair).burn(to);
835 
836         require(amount0 >= minimumAmount, 'UniswapV2Router: INSUFFICIENT_A_AMOUNT');
837         require(amount1 >= minimumAmount, 'UniswapV2Router: INSUFFICIENT_B_AMOUNT');
838     }
839 
840     function _getVaultPair (address beefyVault) private pure returns (IBeefyVaultV6 vault, IUniswapV2Pair pair) {
841         vault = IBeefyVaultV6(beefyVault);
842         pair = IUniswapV2Pair(vault.want());
843     }
844 
845     function _swapAndStake(address beefyVault, uint256 tokenAmountOutMin, address tokenIn) private {
846         (IBeefyVaultV6 vault, IUniswapV2Pair pair) = _getVaultPair(beefyVault);
847 
848         (uint256 reserveA, uint256 reserveB,) = pair.getReserves();
849         require(reserveA > minimumAmount && reserveB > minimumAmount, 'Beefy: Liquidity pair reserves too low');
850 
851         bool isInputA = pair.token0() == tokenIn;
852         require(isInputA || pair.token1() == tokenIn, 'Beefy: Input token not present in liqudity pair');
853 
854         address[] memory path = new address[](2);
855         path[0] = tokenIn;
856         path[1] = isInputA ? pair.token1() : pair.token0();
857 
858         uint256 fullInvestment = IERC20(tokenIn).balanceOf(address(this));
859         uint256 swapAmountIn;
860         if (isInputA) {
861             swapAmountIn = _getSwapAmount(pair, fullInvestment, reserveA, reserveB, path[0], path[1]);
862         } else {
863             swapAmountIn = _getSwapAmount(pair, fullInvestment, reserveB, reserveA, path[0], path[1]);
864         }
865 
866         _approveTokenIfNeeded(path[0], address(router));
867         uint256[] memory swapedAmounts = router
868             .swapExactTokensForTokensSimple(swapAmountIn, tokenAmountOutMin, path[0], path[1], pair.stable(), address(this), block.timestamp);
869 
870         _approveTokenIfNeeded(path[1], address(router));
871         (,, uint256 amountLiquidity) = router
872             .addLiquidity(path[0], path[1], pair.stable(), fullInvestment.sub(swapedAmounts[0]), swapedAmounts[1], 1, 1, address(this), block.timestamp);
873 
874         _approveTokenIfNeeded(address(pair), address(vault));
875         vault.deposit(amountLiquidity);
876 
877         vault.safeTransfer(msg.sender, vault.balanceOf(address(this)));
878         _returnAssets(path);
879     }
880 
881     function _returnAssets(address[] memory tokens) private {
882         uint256 balance;
883         for (uint256 i; i < tokens.length; i++) {
884             balance = IERC20(tokens[i]).balanceOf(address(this));
885             if (balance > 0) {
886                 if (tokens[i] == WETH) {
887                     IWETH(WETH).withdraw(balance);
888                     (bool success,) = msg.sender.call{value: balance}(new bytes(0));
889                     require(success, 'Beefy: ETH transfer failed');
890                 } else {
891                     IERC20(tokens[i]).safeTransfer(msg.sender, balance);
892                 }
893             }
894         }
895     }
896 
897     function _getSwapAmount(IUniswapV2Pair pair, uint256 investmentA, uint256 reserveA, uint256 reserveB, address tokenA, address tokenB) private view returns (uint256 swapAmount) {
898         uint256 halfInvestment = investmentA / 2;
899 
900         if (pair.stable()) {
901             swapAmount = _getStableSwap(pair, investmentA, halfInvestment, tokenA, tokenB);
902         } else {
903             uint256 nominator = pair.getAmountOut(halfInvestment, tokenA);
904             uint256 denominator = halfInvestment * reserveB.sub(nominator) / reserveA.add(halfInvestment);
905             swapAmount = investmentA.sub(Babylonian.sqrt(halfInvestment * halfInvestment * nominator / denominator));
906         }
907     }
908 
909     function _getStableSwap(IUniswapV2Pair pair, uint256 investmentA, uint256 halfInvestment, address tokenA, address tokenB) private view returns (uint256 swapAmount) {
910         uint out = pair.getAmountOut(halfInvestment, tokenA);
911         (uint amountA, uint amountB,) = router.quoteAddLiquidity(tokenA, tokenB, pair.stable(), halfInvestment, out);
912                 
913         amountA = amountA * 1e18 / 10**IERC20Extended(tokenA).decimals();
914         amountB = amountB * 1e18 / 10**IERC20Extended(tokenB).decimals();
915         out = out * 1e18 / 10**IERC20Extended(tokenB).decimals();
916         halfInvestment = halfInvestment * 1e18 / 10**IERC20Extended(tokenA).decimals();
917                 
918         uint ratio = out * 1e18 / halfInvestment * amountA / amountB; 
919                 
920         return investmentA * 1e18 / (ratio + 1e18);
921     }
922 
923     function estimateSwap(address beefyVault, address tokenIn, uint256 fullInvestmentIn) public view returns(uint256 swapAmountIn, uint256 swapAmountOut, address swapTokenOut) {
924         checkWETH();
925         (, IUniswapV2Pair pair) = _getVaultPair(beefyVault);
926 
927         bool isInputA = pair.token0() == tokenIn;
928         require(isInputA || pair.token1() == tokenIn, 'Beefy: Input token not present in liqudity pair');
929 
930         (uint256 reserveA, uint256 reserveB,) = pair.getReserves();
931         (reserveA, reserveB) = isInputA ? (reserveA, reserveB) : (reserveB, reserveA);
932 
933         swapTokenOut = isInputA ? pair.token1() : pair.token0();
934         swapAmountIn = _getSwapAmount(pair, fullInvestmentIn, reserveA, reserveB, tokenIn, swapTokenOut);
935         swapAmountOut = pair.getAmountOut(swapAmountIn, tokenIn); 
936     }
937 
938     function checkWETH() public view returns (bool isValid) {
939         isValid = WETH == router.weth();
940         require(isValid, 'Beefy: WETH address not matching Router.weth()');
941     }
942 
943     function _approveTokenIfNeeded(address token, address spender) private {
944         if (IERC20(token).allowance(address(this), spender) == 0) {
945             IERC20(token).safeApprove(spender, type(uint256).max);
946         }
947     }
948 
949 }