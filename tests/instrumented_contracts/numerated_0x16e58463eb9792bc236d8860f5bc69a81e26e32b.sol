1 pragma solidity 0.6.12;
2 
3 
4 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
5 
6 
7 
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
82 // File: @openzeppelin/contracts/math/SafeMath.sol
83 
84 
85 
86 /**
87  * @dev Wrappers over Solidity's arithmetic operations with added overflow
88  * checks.
89  *
90  * Arithmetic operations in Solidity wrap on overflow. This can easily result
91  * in bugs, because programmers usually assume that an overflow raises an
92  * error, which is the standard behavior in high level programming languages.
93  * `SafeMath` restores this intuition by reverting the transaction when an
94  * operation overflows.
95  *
96  * Using this library instead of the unchecked operations eliminates an entire
97  * class of bugs, so it's recommended to use it always.
98  */
99 library SafeMath {
100     /**
101      * @dev Returns the addition of two unsigned integers, reverting on
102      * overflow.
103      *
104      * Counterpart to Solidity's `+` operator.
105      *
106      * Requirements:
107      *
108      * - Addition cannot overflow.
109      */
110     function add(uint256 a, uint256 b) internal pure returns (uint256) {
111         uint256 c = a + b;
112         require(c >= a, "SafeMath: addition overflow");
113 
114         return c;
115     }
116 
117     /**
118      * @dev Returns the subtraction of two unsigned integers, reverting on
119      * overflow (when the result is negative).
120      *
121      * Counterpart to Solidity's `-` operator.
122      *
123      * Requirements:
124      *
125      * - Subtraction cannot overflow.
126      */
127     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
128         return sub(a, b, "SafeMath: subtraction overflow");
129     }
130 
131     /**
132      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
133      * overflow (when the result is negative).
134      *
135      * Counterpart to Solidity's `-` operator.
136      *
137      * Requirements:
138      *
139      * - Subtraction cannot overflow.
140      */
141     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
142         require(b <= a, errorMessage);
143         uint256 c = a - b;
144 
145         return c;
146     }
147 
148     /**
149      * @dev Returns the multiplication of two unsigned integers, reverting on
150      * overflow.
151      *
152      * Counterpart to Solidity's `*` operator.
153      *
154      * Requirements:
155      *
156      * - Multiplication cannot overflow.
157      */
158     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
159         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
160         // benefit is lost if 'b' is also tested.
161         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
162         if (a == 0) {
163             return 0;
164         }
165 
166         uint256 c = a * b;
167         require(c / a == b, "SafeMath: multiplication overflow");
168 
169         return c;
170     }
171 
172     /**
173      * @dev Returns the integer division of two unsigned integers. Reverts on
174      * division by zero. The result is rounded towards zero.
175      *
176      * Counterpart to Solidity's `/` operator. Note: this function uses a
177      * `revert` opcode (which leaves remaining gas untouched) while Solidity
178      * uses an invalid opcode to revert (consuming all remaining gas).
179      *
180      * Requirements:
181      *
182      * - The divisor cannot be zero.
183      */
184     function div(uint256 a, uint256 b) internal pure returns (uint256) {
185         return div(a, b, "SafeMath: division by zero");
186     }
187 
188     /**
189      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
190      * division by zero. The result is rounded towards zero.
191      *
192      * Counterpart to Solidity's `/` operator. Note: this function uses a
193      * `revert` opcode (which leaves remaining gas untouched) while Solidity
194      * uses an invalid opcode to revert (consuming all remaining gas).
195      *
196      * Requirements:
197      *
198      * - The divisor cannot be zero.
199      */
200     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
201         require(b > 0, errorMessage);
202         uint256 c = a / b;
203         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
204 
205         return c;
206     }
207 
208     /**
209      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
210      * Reverts when dividing by zero.
211      *
212      * Counterpart to Solidity's `%` operator. This function uses a `revert`
213      * opcode (which leaves remaining gas untouched) while Solidity uses an
214      * invalid opcode to revert (consuming all remaining gas).
215      *
216      * Requirements:
217      *
218      * - The divisor cannot be zero.
219      */
220     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
221         return mod(a, b, "SafeMath: modulo by zero");
222     }
223 
224     /**
225      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
226      * Reverts with custom message when dividing by zero.
227      *
228      * Counterpart to Solidity's `%` operator. This function uses a `revert`
229      * opcode (which leaves remaining gas untouched) while Solidity uses an
230      * invalid opcode to revert (consuming all remaining gas).
231      *
232      * Requirements:
233      *
234      * - The divisor cannot be zero.
235      */
236     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
237         require(b != 0, errorMessage);
238         return a % b;
239     }
240 }
241 
242 // File: @openzeppelin/contracts/utils/Address.sol
243 
244 
245 
246 /**
247  * @dev Collection of functions related to the address type
248  */
249 library Address {
250     /**
251      * @dev Returns true if `account` is a contract.
252      *
253      * [IMPORTANT]
254      * ====
255      * It is unsafe to assume that an address for which this function returns
256      * false is an externally-owned account (EOA) and not a contract.
257      *
258      * Among others, `isContract` will return false for the following
259      * types of addresses:
260      *
261      *  - an externally-owned account
262      *  - a contract in construction
263      *  - an address where a contract will be created
264      *  - an address where a contract lived, but was destroyed
265      * ====
266      */
267     function isContract(address account) internal view returns (bool) {
268         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
269         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
270         // for accounts without code, i.e. `keccak256('')`
271         bytes32 codehash;
272         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
273         // solhint-disable-next-line no-inline-assembly
274         assembly { codehash := extcodehash(account) }
275         return (codehash != accountHash && codehash != 0x0);
276     }
277 
278     /**
279      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
280      * `recipient`, forwarding all available gas and reverting on errors.
281      *
282      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
283      * of certain opcodes, possibly making contracts go over the 2300 gas limit
284      * imposed by `transfer`, making them unable to receive funds via
285      * `transfer`. {sendValue} removes this limitation.
286      *
287      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
288      *
289      * IMPORTANT: because control is transferred to `recipient`, care must be
290      * taken to not create reentrancy vulnerabilities. Consider using
291      * {ReentrancyGuard} or the
292      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
293      */
294     function sendValue(address payable recipient, uint256 amount) internal {
295         require(address(this).balance >= amount, "Address: insufficient balance");
296 
297         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
298         (bool success, ) = recipient.call{ value: amount }("");
299         require(success, "Address: unable to send value, recipient may have reverted");
300     }
301 
302     /**
303      * @dev Performs a Solidity function call using a low level `call`. A
304      * plain`call` is an unsafe replacement for a function call: use this
305      * function instead.
306      *
307      * If `target` reverts with a revert reason, it is bubbled up by this
308      * function (like regular Solidity function calls).
309      *
310      * Returns the raw returned data. To convert to the expected return value,
311      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
312      *
313      * Requirements:
314      *
315      * - `target` must be a contract.
316      * - calling `target` with `data` must not revert.
317      *
318      * _Available since v3.1._
319      */
320     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
321       return functionCall(target, data, "Address: low-level call failed");
322     }
323 
324     /**
325      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
326      * `errorMessage` as a fallback revert reason when `target` reverts.
327      *
328      * _Available since v3.1._
329      */
330     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
331         return _functionCallWithValue(target, data, 0, errorMessage);
332     }
333 
334     /**
335      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
336      * but also transferring `value` wei to `target`.
337      *
338      * Requirements:
339      *
340      * - the calling contract must have an ETH balance of at least `value`.
341      * - the called Solidity function must be `payable`.
342      *
343      * _Available since v3.1._
344      */
345     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
346         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
347     }
348 
349     /**
350      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
351      * with `errorMessage` as a fallback revert reason when `target` reverts.
352      *
353      * _Available since v3.1._
354      */
355     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
356         require(address(this).balance >= value, "Address: insufficient balance for call");
357         return _functionCallWithValue(target, data, value, errorMessage);
358     }
359 
360     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
361         require(isContract(target), "Address: call to non-contract");
362 
363         // solhint-disable-next-line avoid-low-level-calls
364         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
365         if (success) {
366             return returndata;
367         } else {
368             // Look for revert reason and bubble it up if present
369             if (returndata.length > 0) {
370                 // The easiest way to bubble the revert reason is using memory via assembly
371 
372                 // solhint-disable-next-line no-inline-assembly
373                 assembly {
374                     let returndata_size := mload(returndata)
375                     revert(add(32, returndata), returndata_size)
376                 }
377             } else {
378                 revert(errorMessage);
379             }
380         }
381     }
382 }
383 
384 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
385 
386 
387 
388 
389 
390 
391 /**
392  * @title SafeERC20
393  * @dev Wrappers around ERC20 operations that throw on failure (when the token
394  * contract returns false). Tokens that return no value (and instead revert or
395  * throw on failure) are also supported, non-reverting calls are assumed to be
396  * successful.
397  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
398  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
399  */
400 library SafeERC20 {
401     using SafeMath for uint256;
402     using Address for address;
403 
404     function safeTransfer(IERC20 token, address to, uint256 value) internal {
405         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
406     }
407 
408     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
409         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
410     }
411 
412     /**
413      * @dev Deprecated. This function has issues similar to the ones found in
414      * {IERC20-approve}, and its usage is discouraged.
415      *
416      * Whenever possible, use {safeIncreaseAllowance} and
417      * {safeDecreaseAllowance} instead.
418      */
419     function safeApprove(IERC20 token, address spender, uint256 value) internal {
420         // safeApprove should only be called when setting an initial allowance,
421         // or when resetting it to zero. To increase and decrease it, use
422         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
423         // solhint-disable-next-line max-line-length
424         require((value == 0) || (token.allowance(address(this), spender) == 0),
425             "SafeERC20: approve from non-zero to non-zero allowance"
426         );
427         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
428     }
429 
430     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
431         uint256 newAllowance = token.allowance(address(this), spender).add(value);
432         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
433     }
434 
435     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
436         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
437         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
438     }
439 
440     /**
441      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
442      * on the return value: the return value is optional (but if data is returned, it must not be false).
443      * @param token The token targeted by the call.
444      * @param data The call data (encoded using abi.encode or one of its variants).
445      */
446     function _callOptionalReturn(IERC20 token, bytes memory data) private {
447         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
448         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
449         // the target address contains contract code and also asserts for success in the low-level call.
450 
451         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
452         if (returndata.length > 0) { // Return data is optional
453             // solhint-disable-next-line max-line-length
454             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
455         }
456     }
457 }
458 
459 // File: contracts/uniswapv2/interfaces/IUniswapV2Pair.sol
460 
461 
462 interface IUniswapV2Pair {
463     event Approval(address indexed owner, address indexed spender, uint value);
464     event Transfer(address indexed from, address indexed to, uint value);
465 
466     function name() external pure returns (string memory);
467     function symbol() external pure returns (string memory);
468     function decimals() external pure returns (uint8);
469     function totalSupply() external view returns (uint);
470     function balanceOf(address owner) external view returns (uint);
471     function allowance(address owner, address spender) external view returns (uint);
472 
473     function approve(address spender, uint value) external returns (bool);
474     function transfer(address to, uint value) external returns (bool);
475     function transferFrom(address from, address to, uint value) external returns (bool);
476 
477     function DOMAIN_SEPARATOR() external view returns (bytes32);
478     function PERMIT_TYPEHASH() external pure returns (bytes32);
479     function nonces(address owner) external view returns (uint);
480 
481     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
482 
483     event Mint(address indexed sender, uint amount0, uint amount1);
484     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
485     event Swap(
486         address indexed sender,
487         uint amount0In,
488         uint amount1In,
489         uint amount0Out,
490         uint amount1Out,
491         address indexed to
492     );
493     event Sync(uint112 reserve0, uint112 reserve1);
494 
495     function MINIMUM_LIQUIDITY() external pure returns (uint);
496     function factory() external view returns (address);
497     function token0() external view returns (address);
498     function token1() external view returns (address);
499     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
500     function price0CumulativeLast() external view returns (uint);
501     function price1CumulativeLast() external view returns (uint);
502     function kLast() external view returns (uint);
503 
504     function mint(address to) external returns (uint liquidity);
505     function burn(address to) external returns (uint amount0, uint amount1);
506     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
507     function skim(address to) external;
508     function sync() external;
509 
510     function initialize(address, address) external;
511 }
512 
513 // File: contracts/uniswapv2/interfaces/IUniswapV2Router01.sol
514 
515 
516 interface IUniswapV2Router01 {
517     function factory() external pure returns (address);
518     function WETH() external pure returns (address);
519 
520     function addLiquidity(
521         address tokenA,
522         address tokenB,
523         uint amountADesired,
524         uint amountBDesired,
525         uint amountAMin,
526         uint amountBMin,
527         address to,
528         uint deadline
529     ) external returns (uint amountA, uint amountB, uint liquidity);
530     function addLiquidityETH(
531         address token,
532         uint amountTokenDesired,
533         uint amountTokenMin,
534         uint amountETHMin,
535         address to,
536         uint deadline
537     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
538     function removeLiquidity(
539         address tokenA,
540         address tokenB,
541         uint liquidity,
542         uint amountAMin,
543         uint amountBMin,
544         address to,
545         uint deadline
546     ) external returns (uint amountA, uint amountB);
547     function removeLiquidityETH(
548         address token,
549         uint liquidity,
550         uint amountTokenMin,
551         uint amountETHMin,
552         address to,
553         uint deadline
554     ) external returns (uint amountToken, uint amountETH);
555     function removeLiquidityWithPermit(
556         address tokenA,
557         address tokenB,
558         uint liquidity,
559         uint amountAMin,
560         uint amountBMin,
561         address to,
562         uint deadline,
563         bool approveMax, uint8 v, bytes32 r, bytes32 s
564     ) external returns (uint amountA, uint amountB);
565     function removeLiquidityETHWithPermit(
566         address token,
567         uint liquidity,
568         uint amountTokenMin,
569         uint amountETHMin,
570         address to,
571         uint deadline,
572         bool approveMax, uint8 v, bytes32 r, bytes32 s
573     ) external returns (uint amountToken, uint amountETH);
574     function swapExactTokensForTokens(
575         uint amountIn,
576         uint amountOutMin,
577         address[] calldata path,
578         address to,
579         uint deadline
580     ) external returns (uint[] memory amounts);
581     function swapTokensForExactTokens(
582         uint amountOut,
583         uint amountInMax,
584         address[] calldata path,
585         address to,
586         uint deadline
587     ) external returns (uint[] memory amounts);
588     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
589         external
590         payable
591         returns (uint[] memory amounts);
592     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
593         external
594         returns (uint[] memory amounts);
595     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
596         external
597         returns (uint[] memory amounts);
598     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
599         external
600         payable
601         returns (uint[] memory amounts);
602 
603     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
604     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
605     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
606     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
607     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
608 }
609 
610 // File: contracts/uniswapv2/interfaces/IUniswapV2Factory.sol
611 
612 
613 interface IUniswapV2Factory {
614     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
615 
616     function feeTo() external view returns (address);
617     function feeToSetter() external view returns (address);
618     function migrator() external view returns (address);
619 
620     function getPair(address tokenA, address tokenB) external view returns (address pair);
621     function allPairs(uint) external view returns (address pair);
622     function allPairsLength() external view returns (uint);
623 
624     function createPair(address tokenA, address tokenB) external returns (address pair);
625 
626     function setFeeTo(address) external;
627     function setFeeToSetter(address) external;
628     function setMigrator(address) external;
629 }
630 
631 // File: contracts/uniswapv2/libraries/SafeMath.sol
632 
633 
634 // a library for performing overflow-safe math, courtesy of DappHub (https://github.com/dapphub/ds-math)
635 
636 library SafeMathUniswap {
637     function add(uint x, uint y) internal pure returns (uint z) {
638         require((z = x + y) >= x, 'ds-math-add-overflow');
639     }
640 
641     function sub(uint x, uint y) internal pure returns (uint z) {
642         require((z = x - y) <= x, 'ds-math-sub-underflow');
643     }
644 
645     function mul(uint x, uint y) internal pure returns (uint z) {
646         require(y == 0 || (z = x * y) / y == x, 'ds-math-mul-overflow');
647     }
648 }
649 
650 // File: contracts/uniswapv2/libraries/UniswapV2Library.sol
651 
652 
653 
654 
655 library UniswapV2Library {
656     using SafeMathUniswap for uint;
657 
658     // returns sorted token addresses, used to handle return values from pairs sorted in this order
659     function sortTokens(address tokenA, address tokenB) internal pure returns (address token0, address token1) {
660         require(tokenA != tokenB, 'UniswapV2Library: IDENTICAL_ADDRESSES');
661         (token0, token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
662         require(token0 != address(0), 'UniswapV2Library: ZERO_ADDRESS');
663     }
664 
665     // calculates the CREATE2 address for a pair without making any external calls
666     function pairFor(address factory, address tokenA, address tokenB) internal pure returns (address pair) {
667         (address token0, address token1) = sortTokens(tokenA, tokenB);
668         pair = address(uint(keccak256(abi.encodePacked(
669                 hex'ff',
670                 factory,
671                 keccak256(abi.encodePacked(token0, token1)),
672                 hex'e18a34eb0e04b04f7a0ac29a6e80748dca96319b42c54d679cb821dca90c6303' // init code hash
673             ))));
674     }
675 
676     // fetches and sorts the reserves for a pair
677     function getReserves(address factory, address tokenA, address tokenB) internal view returns (uint reserveA, uint reserveB) {
678         (address token0,) = sortTokens(tokenA, tokenB);
679         (uint reserve0, uint reserve1,) = IUniswapV2Pair(pairFor(factory, tokenA, tokenB)).getReserves();
680         (reserveA, reserveB) = tokenA == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
681     }
682 
683     // given some amount of an asset and pair reserves, returns an equivalent amount of the other asset
684     function quote(uint amountA, uint reserveA, uint reserveB) internal pure returns (uint amountB) {
685         require(amountA > 0, 'UniswapV2Library: INSUFFICIENT_AMOUNT');
686         require(reserveA > 0 && reserveB > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
687         amountB = amountA.mul(reserveB) / reserveA;
688     }
689 
690     // given an input amount of an asset and pair reserves, returns the maximum output amount of the other asset
691     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) internal pure returns (uint amountOut) {
692         require(amountIn > 0, 'UniswapV2Library: INSUFFICIENT_INPUT_AMOUNT');
693         require(reserveIn > 0 && reserveOut > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
694         uint amountInWithFee = amountIn.mul(997);
695         uint numerator = amountInWithFee.mul(reserveOut);
696         uint denominator = reserveIn.mul(1000).add(amountInWithFee);
697         amountOut = numerator / denominator;
698     }
699 
700     // given an output amount of an asset and pair reserves, returns a required input amount of the other asset
701     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) internal pure returns (uint amountIn) {
702         require(amountOut > 0, 'UniswapV2Library: INSUFFICIENT_OUTPUT_AMOUNT');
703         require(reserveIn > 0 && reserveOut > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
704         uint numerator = reserveIn.mul(amountOut).mul(1000);
705         uint denominator = reserveOut.sub(amountOut).mul(997);
706         amountIn = (numerator / denominator).add(1);
707     }
708 
709     // performs chained getAmountOut calculations on any number of pairs
710     function getAmountsOut(address factory, uint amountIn, address[] memory path) internal view returns (uint[] memory amounts) {
711         require(path.length >= 2, 'UniswapV2Library: INVALID_PATH');
712         amounts = new uint[](path.length);
713         amounts[0] = amountIn;
714         for (uint i; i < path.length - 1; i++) {
715             (uint reserveIn, uint reserveOut) = getReserves(factory, path[i], path[i + 1]);
716             amounts[i + 1] = getAmountOut(amounts[i], reserveIn, reserveOut);
717         }
718     }
719 
720     // performs chained getAmountIn calculations on any number of pairs
721     function getAmountsIn(address factory, uint amountOut, address[] memory path) internal view returns (uint[] memory amounts) {
722         require(path.length >= 2, 'UniswapV2Library: INVALID_PATH');
723         amounts = new uint[](path.length);
724         amounts[amounts.length - 1] = amountOut;
725         for (uint i = path.length - 1; i > 0; i--) {
726             (uint reserveIn, uint reserveOut) = getReserves(factory, path[i - 1], path[i]);
727             amounts[i - 1] = getAmountIn(amounts[i], reserveIn, reserveOut);
728         }
729     }
730 }
731 
732 // File: contracts/SushiRoll.sol
733 
734 
735 
736 
737 
738 
739 
740 
741 // SushiRoll helps your migrate your existing Uniswap LP tokens to SushiSwap LP ones
742 contract SushiRoll {
743     using SafeERC20 for IERC20;
744 
745     IUniswapV2Router01 public oldRouter;
746     IUniswapV2Router01 public router;
747 
748     constructor(IUniswapV2Router01 _oldRouter, IUniswapV2Router01 _router) public {
749         oldRouter = _oldRouter;
750         router = _router;
751     }
752 
753     function migrateWithPermit(
754         address tokenA,
755         address tokenB,
756         uint256 liquidity,
757         uint256 amountAMin,
758         uint256 amountBMin,
759         uint256 deadline,
760         uint8 v,
761         bytes32 r,
762         bytes32 s
763     ) public {
764         IUniswapV2Pair pair = IUniswapV2Pair(pairForOldRouter(tokenA, tokenB));
765         pair.permit(msg.sender, address(this), liquidity, deadline, v, r, s);
766 
767         migrate(tokenA, tokenB, liquidity, amountAMin, amountBMin, deadline);
768     }
769 
770     // msg.sender should have approved 'liquidity' amount of LP token of 'tokenA' and 'tokenB'
771     function migrate(
772         address tokenA,
773         address tokenB,
774         uint256 liquidity,
775         uint256 amountAMin,
776         uint256 amountBMin,
777         uint256 deadline
778     ) public {
779         require(deadline >= block.timestamp, 'SushiSwap: EXPIRED');
780 
781         // Remove liquidity from the old router with permit
782         (uint256 amountA, uint256 amountB) = removeLiquidity(
783             tokenA,
784             tokenB,
785             liquidity,
786             amountAMin,
787             amountBMin,
788             deadline
789         );
790 
791         // Add liquidity to the new router
792         (uint256 pooledAmountA, uint256 pooledAmountB) = addLiquidity(tokenA, tokenB, amountA, amountB);
793 
794         // Send remaining tokens to msg.sender
795         if (amountA > pooledAmountA) {
796             IERC20(tokenA).safeTransfer(msg.sender, amountA - pooledAmountA);
797         }
798         if (amountB > pooledAmountB) {
799             IERC20(tokenB).safeTransfer(msg.sender, amountB - pooledAmountB);
800         }
801     }
802 
803     function removeLiquidity(
804         address tokenA,
805         address tokenB,
806         uint256 liquidity,
807         uint256 amountAMin,
808         uint256 amountBMin,
809         uint256 deadline
810     ) internal returns (uint256 amountA, uint256 amountB) {
811         IUniswapV2Pair pair = IUniswapV2Pair(pairForOldRouter(tokenA, tokenB));
812         pair.transferFrom(msg.sender, address(pair), liquidity);
813         (uint256 amount0, uint256 amount1) = pair.burn(address(this));
814         (address token0,) = UniswapV2Library.sortTokens(tokenA, tokenB);
815         (amountA, amountB) = tokenA == token0 ? (amount0, amount1) : (amount1, amount0);
816         require(amountA >= amountAMin, 'SushiRoll: INSUFFICIENT_A_AMOUNT');
817         require(amountB >= amountBMin, 'SushiRoll: INSUFFICIENT_B_AMOUNT');
818     }
819 
820     // calculates the CREATE2 address for a pair without making any external calls
821     function pairForOldRouter(address tokenA, address tokenB) internal view returns (address pair) {
822         (address token0, address token1) = UniswapV2Library.sortTokens(tokenA, tokenB);
823         pair = address(uint(keccak256(abi.encodePacked(
824                 hex'ff',
825                 oldRouter.factory(),
826                 keccak256(abi.encodePacked(token0, token1)),
827                 hex'96e8ac4277198ff8b6f785478aa9a39f403cb768dd02cbee326c3e7da348845f' // init code hash
828             ))));
829     }
830 
831     function addLiquidity(
832         address tokenA,
833         address tokenB,
834         uint256 amountADesired,
835         uint256 amountBDesired
836     ) internal returns (uint amountA, uint amountB) {
837         (amountA, amountB) = _addLiquidity(tokenA, tokenB, amountADesired, amountBDesired);
838         address pair = UniswapV2Library.pairFor(router.factory(), tokenA, tokenB);
839         IERC20(tokenA).safeTransfer(pair, amountA);
840         IERC20(tokenB).safeTransfer(pair, amountB);
841         IUniswapV2Pair(pair).mint(msg.sender);
842     }
843 
844     function _addLiquidity(
845         address tokenA,
846         address tokenB,
847         uint256 amountADesired,
848         uint256 amountBDesired
849     ) internal returns (uint256 amountA, uint256 amountB) {
850         // create the pair if it doesn't exist yet
851         IUniswapV2Factory factory = IUniswapV2Factory(router.factory());
852         if (factory.getPair(tokenA, tokenB) == address(0)) {
853             factory.createPair(tokenA, tokenB);
854         }
855         (uint256 reserveA, uint256 reserveB) = UniswapV2Library.getReserves(address(factory), tokenA, tokenB);
856         if (reserveA == 0 && reserveB == 0) {
857             (amountA, amountB) = (amountADesired, amountBDesired);
858         } else {
859             uint256 amountBOptimal = UniswapV2Library.quote(amountADesired, reserveA, reserveB);
860             if (amountBOptimal <= amountBDesired) {
861                 (amountA, amountB) = (amountADesired, amountBOptimal);
862             } else {
863                 uint256 amountAOptimal = UniswapV2Library.quote(amountBDesired, reserveB, reserveA);
864                 assert(amountAOptimal <= amountADesired);
865                 (amountA, amountB) = (amountAOptimal, amountBDesired);
866             }
867         }
868     }
869 }