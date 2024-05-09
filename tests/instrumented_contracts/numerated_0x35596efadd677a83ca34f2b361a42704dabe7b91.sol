1 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
2 
3 pragma solidity ^0.5.0;
4 
5 /**
6  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
7  * the optional functions; to access them see {ERC20Detailed}.
8  */
9 interface IERC20 {
10     /**
11      * @dev Returns the amount of tokens in existence.
12      */
13     function totalSupply() external view returns (uint256);
14 
15     /**
16      * @dev Returns the amount of tokens owned by `account`.
17      */
18     function balanceOf(address account) external view returns (uint256);
19 
20     /**
21      * @dev Moves `amount` tokens from the caller's account to `recipient`.
22      *
23      * Returns a boolean value indicating whether the operation succeeded.
24      *
25      * Emits a {Transfer} event.
26      */
27     function transfer(address recipient, uint256 amount) external returns (bool);
28 
29     /**
30      * @dev Returns the remaining number of tokens that `spender` will be
31      * allowed to spend on behalf of `owner` through {transferFrom}. This is
32      * zero by default.
33      *
34      * This value changes when {approve} or {transferFrom} are called.
35      */
36     function allowance(address owner, address spender) external view returns (uint256);
37 
38     /**
39      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
40      *
41      * Returns a boolean value indicating whether the operation succeeded.
42      *
43      * IMPORTANT: Beware that changing an allowance with this method brings the risk
44      * that someone may use both the old and the new allowance by unfortunate
45      * transaction ordering. One possible solution to mitigate this race
46      * condition is to first reduce the spender's allowance to 0 and set the
47      * desired value afterwards:
48      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
49      *
50      * Emits an {Approval} event.
51      */
52     function approve(address spender, uint256 amount) external returns (bool);
53 
54     /**
55      * @dev Moves `amount` tokens from `sender` to `recipient` using the
56      * allowance mechanism. `amount` is then deducted from the caller's
57      * allowance.
58      *
59      * Returns a boolean value indicating whether the operation succeeded.
60      *
61      * Emits a {Transfer} event.
62      */
63     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
64 
65     /**
66      * @dev Emitted when `value` tokens are moved from one account (`from`) to
67      * another (`to`).
68      *
69      * Note that `value` may be zero.
70      */
71     event Transfer(address indexed from, address indexed to, uint256 value);
72 
73     /**
74      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
75      * a call to {approve}. `value` is the new allowance.
76      */
77     event Approval(address indexed owner, address indexed spender, uint256 value);
78 }
79 
80 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
81 
82 pragma solidity ^0.5.0;
83 
84 /**
85  * @dev Wrappers over Solidity's arithmetic operations with added overflow
86  * checks.
87  *
88  * Arithmetic operations in Solidity wrap on overflow. This can easily result
89  * in bugs, because programmers usually assume that an overflow raises an
90  * error, which is the standard behavior in high level programming languages.
91  * `SafeMath` restores this intuition by reverting the transaction when an
92  * operation overflows.
93  *
94  * Using this library instead of the unchecked operations eliminates an entire
95  * class of bugs, so it's recommended to use it always.
96  */
97 library SafeMath {
98     /**
99      * @dev Returns the addition of two unsigned integers, reverting on
100      * overflow.
101      *
102      * Counterpart to Solidity's `+` operator.
103      *
104      * Requirements:
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
121      * - Subtraction cannot overflow.
122      */
123     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
124         return sub(a, b, "SafeMath: subtraction overflow");
125     }
126 
127     /**
128      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
129      * overflow (when the result is negative).
130      *
131      * Counterpart to Solidity's `-` operator.
132      *
133      * Requirements:
134      * - Subtraction cannot overflow.
135      *
136      * _Available since v2.4.0._
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
152      * - Multiplication cannot overflow.
153      */
154     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
155         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
156         // benefit is lost if 'b' is also tested.
157         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
158         if (a == 0) {
159             return 0;
160         }
161 
162         uint256 c = a * b;
163         require(c / a == b, "SafeMath: multiplication overflow");
164 
165         return c;
166     }
167 
168     /**
169      * @dev Returns the integer division of two unsigned integers. Reverts on
170      * division by zero. The result is rounded towards zero.
171      *
172      * Counterpart to Solidity's `/` operator. Note: this function uses a
173      * `revert` opcode (which leaves remaining gas untouched) while Solidity
174      * uses an invalid opcode to revert (consuming all remaining gas).
175      *
176      * Requirements:
177      * - The divisor cannot be zero.
178      */
179     function div(uint256 a, uint256 b) internal pure returns (uint256) {
180         return div(a, b, "SafeMath: division by zero");
181     }
182 
183     /**
184      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
185      * division by zero. The result is rounded towards zero.
186      *
187      * Counterpart to Solidity's `/` operator. Note: this function uses a
188      * `revert` opcode (which leaves remaining gas untouched) while Solidity
189      * uses an invalid opcode to revert (consuming all remaining gas).
190      *
191      * Requirements:
192      * - The divisor cannot be zero.
193      *
194      * _Available since v2.4.0._
195      */
196     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
197         // Solidity only automatically asserts when dividing by 0
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
214      * - The divisor cannot be zero.
215      */
216     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
217         return mod(a, b, "SafeMath: modulo by zero");
218     }
219 
220     /**
221      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
222      * Reverts with custom message when dividing by zero.
223      *
224      * Counterpart to Solidity's `%` operator. This function uses a `revert`
225      * opcode (which leaves remaining gas untouched) while Solidity uses an
226      * invalid opcode to revert (consuming all remaining gas).
227      *
228      * Requirements:
229      * - The divisor cannot be zero.
230      *
231      * _Available since v2.4.0._
232      */
233     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
234         require(b != 0, errorMessage);
235         return a % b;
236     }
237 }
238 
239 // File: openzeppelin-solidity/contracts/utils/Address.sol
240 
241 pragma solidity ^0.5.5;
242 
243 /**
244  * @dev Collection of functions related to the address type
245  */
246 library Address {
247     /**
248      * @dev Returns true if `account` is a contract.
249      *
250      * This test is non-exhaustive, and there may be false-negatives: during the
251      * execution of a contract's constructor, its address will be reported as
252      * not containing a contract.
253      *
254      * IMPORTANT: It is unsafe to assume that an address for which this
255      * function returns false is an externally-owned account (EOA) and not a
256      * contract.
257      */
258     function isContract(address account) internal view returns (bool) {
259         // This method relies in extcodesize, which returns 0 for contracts in
260         // construction, since the code is only stored at the end of the
261         // constructor execution.
262 
263         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
264         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
265         // for accounts without code, i.e. `keccak256('')`
266         bytes32 codehash;
267         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
268         // solhint-disable-next-line no-inline-assembly
269         assembly { codehash := extcodehash(account) }
270         return (codehash != 0x0 && codehash != accountHash);
271     }
272 
273     /**
274      * @dev Converts an `address` into `address payable`. Note that this is
275      * simply a type cast: the actual underlying value is not changed.
276      *
277      * _Available since v2.4.0._
278      */
279     function toPayable(address account) internal pure returns (address payable) {
280         return address(uint160(account));
281     }
282 
283     /**
284      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
285      * `recipient`, forwarding all available gas and reverting on errors.
286      *
287      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
288      * of certain opcodes, possibly making contracts go over the 2300 gas limit
289      * imposed by `transfer`, making them unable to receive funds via
290      * `transfer`. {sendValue} removes this limitation.
291      *
292      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
293      *
294      * IMPORTANT: because control is transferred to `recipient`, care must be
295      * taken to not create reentrancy vulnerabilities. Consider using
296      * {ReentrancyGuard} or the
297      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
298      *
299      * _Available since v2.4.0._
300      */
301     function sendValue(address payable recipient, uint256 amount) internal {
302         require(address(this).balance >= amount, "Address: insufficient balance");
303 
304         // solhint-disable-next-line avoid-call-value
305         (bool success, ) = recipient.call.value(amount)("");
306         require(success, "Address: unable to send value, recipient may have reverted");
307     }
308 }
309 
310 // File: openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol
311 
312 pragma solidity ^0.5.0;
313 
314 
315 
316 
317 /**
318  * @title SafeERC20
319  * @dev Wrappers around ERC20 operations that throw on failure (when the token
320  * contract returns false). Tokens that return no value (and instead revert or
321  * throw on failure) are also supported, non-reverting calls are assumed to be
322  * successful.
323  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
324  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
325  */
326 library SafeERC20 {
327     using SafeMath for uint256;
328     using Address for address;
329 
330     function safeTransfer(IERC20 token, address to, uint256 value) internal {
331         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
332     }
333 
334     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
335         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
336     }
337 
338     function safeApprove(IERC20 token, address spender, uint256 value) internal {
339         // safeApprove should only be called when setting an initial allowance,
340         // or when resetting it to zero. To increase and decrease it, use
341         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
342         // solhint-disable-next-line max-line-length
343         require((value == 0) || (token.allowance(address(this), spender) == 0),
344             "SafeERC20: approve from non-zero to non-zero allowance"
345         );
346         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
347     }
348 
349     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
350         uint256 newAllowance = token.allowance(address(this), spender).add(value);
351         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
352     }
353 
354     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
355         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
356         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
357     }
358 
359     /**
360      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
361      * on the return value: the return value is optional (but if data is returned, it must not be false).
362      * @param token The token targeted by the call.
363      * @param data The call data (encoded using abi.encode or one of its variants).
364      */
365     function callOptionalReturn(IERC20 token, bytes memory data) private {
366         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
367         // we're implementing it ourselves.
368 
369         // A Solidity high level call has three parts:
370         //  1. The target address is checked to verify it contains contract code
371         //  2. The call itself is made, and success asserted
372         //  3. The return value is decoded, which in turn checks the size of the returned data.
373         // solhint-disable-next-line max-line-length
374         require(address(token).isContract(), "SafeERC20: call to non-contract");
375 
376         // solhint-disable-next-line avoid-low-level-calls
377         (bool success, bytes memory returndata) = address(token).call(data);
378         require(success, "SafeERC20: low-level call failed");
379 
380         if (returndata.length > 0) { // Return data is optional
381             // solhint-disable-next-line max-line-length
382             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
383         }
384     }
385 }
386 
387 // File: @uniswap/v2-core/contracts/interfaces/IUniswapV2Factory.sol
388 
389 pragma solidity >=0.5.0;
390 
391 interface IUniswapV2Factory {
392     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
393 
394     function feeTo() external view returns (address);
395     function feeToSetter() external view returns (address);
396 
397     function getPair(address tokenA, address tokenB) external view returns (address pair);
398     function allPairs(uint) external view returns (address pair);
399     function allPairsLength() external view returns (uint);
400 
401     function createPair(address tokenA, address tokenB) external returns (address pair);
402 
403     function setFeeTo(address) external;
404     function setFeeToSetter(address) external;
405 }
406 
407 // File: @uniswap/v2-core/contracts/interfaces/IUniswapV2Pair.sol
408 
409 pragma solidity >=0.5.0;
410 
411 interface IUniswapV2Pair {
412     event Approval(address indexed owner, address indexed spender, uint value);
413     event Transfer(address indexed from, address indexed to, uint value);
414 
415     function name() external pure returns (string memory);
416     function symbol() external pure returns (string memory);
417     function decimals() external pure returns (uint8);
418     function totalSupply() external view returns (uint);
419     function balanceOf(address owner) external view returns (uint);
420     function allowance(address owner, address spender) external view returns (uint);
421 
422     function approve(address spender, uint value) external returns (bool);
423     function transfer(address to, uint value) external returns (bool);
424     function transferFrom(address from, address to, uint value) external returns (bool);
425 
426     function DOMAIN_SEPARATOR() external view returns (bytes32);
427     function PERMIT_TYPEHASH() external pure returns (bytes32);
428     function nonces(address owner) external view returns (uint);
429 
430     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
431 
432     event Mint(address indexed sender, uint amount0, uint amount1);
433     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
434     event Swap(
435         address indexed sender,
436         uint amount0In,
437         uint amount1In,
438         uint amount0Out,
439         uint amount1Out,
440         address indexed to
441     );
442     event Sync(uint112 reserve0, uint112 reserve1);
443 
444     function MINIMUM_LIQUIDITY() external pure returns (uint);
445     function factory() external view returns (address);
446     function token0() external view returns (address);
447     function token1() external view returns (address);
448     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
449     function price0CumulativeLast() external view returns (uint);
450     function price1CumulativeLast() external view returns (uint);
451     function kLast() external view returns (uint);
452 
453     function mint(address to) external returns (uint liquidity);
454     function burn(address to) external returns (uint amount0, uint amount1);
455     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
456     function skim(address to) external;
457     function sync() external;
458 
459     function initialize(address, address) external;
460 }
461 
462 // File: @uniswap/v2-periphery/contracts/interfaces/IWETH.sol
463 
464 pragma solidity >=0.5.0;
465 
466 interface IWETH {
467     function deposit() external payable;
468     function transfer(address to, uint value) external returns (bool);
469     function withdraw(uint) external;
470 }
471 
472 // File: contracts/Utils/UniswapV2Library.sol
473 
474 pragma solidity >=0.5.0;
475 
476 // reimplemented because the original library imports the local SafeMath that requires solidity 0.6.x
477 
478 
479 
480 library UniswapV2Library {
481     using SafeMath for uint;
482 
483     // returns sorted token addresses, used to handle return values from pairs sorted in this order
484     function sortTokens(address tokenA, address tokenB) internal pure returns (address token0, address token1) {
485         require(tokenA != tokenB, 'UniswapV2Library: IDENTICAL_ADDRESSES');
486         (token0, token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
487         require(token0 != address(0), 'UniswapV2Library: ZERO_ADDRESS');
488     }
489 
490     // calculates the CREATE2 address for a pair without making any external calls
491     function pairFor(address factory, address tokenA, address tokenB) internal pure returns (address pair) {
492         (address token0, address token1) = sortTokens(tokenA, tokenB);
493         pair = address(uint(keccak256(abi.encodePacked(
494                 hex'ff',
495                 factory,
496                 keccak256(abi.encodePacked(token0, token1)),
497                 hex'96e8ac4277198ff8b6f785478aa9a39f403cb768dd02cbee326c3e7da348845f' // init code hash
498             ))));
499     }
500 
501     // fetches and sorts the reserves for a pair
502     function getReserves(address factory, address tokenA, address tokenB) internal view returns (uint reserveA, uint reserveB) {
503         (address token0,) = sortTokens(tokenA, tokenB);
504         (uint reserve0, uint reserve1,) = IUniswapV2Pair(pairFor(factory, tokenA, tokenB)).getReserves();
505         (reserveA, reserveB) = tokenA == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
506     }
507 
508     // given some amount of an asset and pair reserves, returns an equivalent amount of the other asset
509     function quote(uint amountA, uint reserveA, uint reserveB) internal pure returns (uint amountB) {
510         require(amountA > 0, 'UniswapV2Library: INSUFFICIENT_AMOUNT');
511         require(reserveA > 0 && reserveB > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
512         amountB = amountA.mul(reserveB) / reserveA;
513     }
514 
515     // given an input amount of an asset and pair reserves, returns the maximum output amount of the other asset
516     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) internal pure returns (uint amountOut) {
517         require(amountIn > 0, 'UniswapV2Library: INSUFFICIENT_INPUT_AMOUNT');
518         require(reserveIn > 0 && reserveOut > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
519         uint amountInWithFee = amountIn.mul(997);
520         uint numerator = amountInWithFee.mul(reserveOut);
521         uint denominator = reserveIn.mul(1000).add(amountInWithFee);
522         amountOut = numerator / denominator;
523     }
524 
525     // given an output amount of an asset and pair reserves, returns a required input amount of the other asset
526     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) internal pure returns (uint amountIn) {
527         require(amountOut > 0, 'UniswapV2Library: INSUFFICIENT_OUTPUT_AMOUNT');
528         require(reserveIn > 0 && reserveOut > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
529         uint numerator = reserveIn.mul(amountOut).mul(1000);
530         uint denominator = reserveOut.sub(amountOut).mul(997);
531         amountIn = (numerator / denominator).add(1);
532     }
533 
534     // performs chained getAmountOut calculations on any number of pairs
535     function getAmountsOut(address factory, uint amountIn, address[] memory path) internal view returns (uint[] memory amounts) {
536         require(path.length >= 2, 'UniswapV2Library: INVALID_PATH');
537         amounts = new uint[](path.length);
538         amounts[0] = amountIn;
539         for (uint i; i < path.length - 1; i++) {
540             (uint reserveIn, uint reserveOut) = getReserves(factory, path[i], path[i + 1]);
541             amounts[i + 1] = getAmountOut(amounts[i], reserveIn, reserveOut);
542         }
543     }
544 
545     // performs chained getAmountIn calculations on any number of pairs
546     function getAmountsIn(address factory, uint amountOut, address[] memory path) internal view returns (uint[] memory amounts) {
547         require(path.length >= 2, 'UniswapV2Library: INVALID_PATH');
548         amounts = new uint[](path.length);
549         amounts[amounts.length - 1] = amountOut;
550         for (uint i = path.length - 1; i > 0; i--) {
551             (uint reserveIn, uint reserveOut) = getReserves(factory, path[i - 1], path[i]);
552             amounts[i - 1] = getAmountIn(amounts[i], reserveIn, reserveOut);
553         }
554     }
555 }
556 
557 // File: contracts/Interfaces/IUniswapV2Router01.sol
558 
559 pragma solidity >=0.5.0;
560 
561 //interface IUniswapV2Factory {
562 //  event PairCreated(address indexed token0, address indexed token1, address pair, uint);
563 //
564 //  function getPair(address tokenA, address tokenB) external view returns (address pair);
565 //  function allPairs(uint) external view returns (address pair);
566 //  function allPairsLength() external view returns (uint);
567 //
568 //  function feeTo() external view returns (address);
569 //  function feeToSetter() external view returns (address);
570 //
571 //  function createPair(address tokenA, address tokenB) external returns (address pair);
572 //}
573 //
574 //interface IUniswapV2Pair {
575 //  event Approval(address indexed owner, address indexed spender, uint value);
576 //  event Transfer(address indexed from, address indexed to, uint value);
577 //
578 //  function name() external pure returns (string memory);
579 //  function symbol() external pure returns (string memory);
580 //  function decimals() external pure returns (uint8);
581 //  function totalSupply() external view returns (uint);
582 //  function balanceOf(address owner) external view returns (uint);
583 //  function allowance(address owner, address spender) external view returns (uint);
584 //
585 //  function approve(address spender, uint value) external returns (bool);
586 //  function transfer(address to, uint value) external returns (bool);
587 //  function transferFrom(address from, address to, uint value) external returns (bool);
588 //
589 //  function DOMAIN_SEPARATOR() external view returns (bytes32);
590 //  function PERMIT_TYPEHASH() external pure returns (bytes32);
591 //  function nonces(address owner) external view returns (uint);
592 //
593 //  function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
594 //
595 //  event Mint(address indexed sender, uint amount0, uint amount1);
596 //  event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
597 //  event Swap(
598 //    address indexed sender,
599 //    uint amount0In,
600 //    uint amount1In,
601 //    uint amount0Out,
602 //    uint amount1Out,
603 //    address indexed to
604 //  );
605 //  event Sync(uint112 reserve0, uint112 reserve1);
606 //
607 //  function MINIMUM_LIQUIDITY() external pure returns (uint);
608 //  function factory() external view returns (address);
609 //  function token0() external view returns (address);
610 //  function token1() external view returns (address);
611 //  function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
612 //  function price0CumulativeLast() external view returns (uint);
613 //  function price1CumulativeLast() external view returns (uint);
614 //  function kLast() external view returns (uint);
615 //
616 //  function mint(address to) external returns (uint liquidity);
617 //  function burn(address to) external returns (uint amount0, uint amount1);
618 //  function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
619 //  function skim(address to) external;
620 //  function sync() external;
621 //}
622 
623 interface IUniswapV2Router01 {
624   function factory() external pure returns (address);
625   function WETH() external pure returns (address);
626 
627   function addLiquidity(
628     address tokenA,
629     address tokenB,
630     uint amountADesired,
631     uint amountBDesired,
632     uint amountAMin,
633     uint amountBMin,
634     address to,
635     uint deadline
636   ) external returns (uint amountA, uint amountB, uint liquidity);
637   function addLiquidityETH(
638     address token,
639     uint amountTokenDesired,
640     uint amountTokenMin,
641     uint amountETHMin,
642     address to,
643     uint deadline
644   ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
645   function removeLiquidity(
646     address tokenA,
647     address tokenB,
648     uint liquidity,
649     uint amountAMin,
650     uint amountBMin,
651     address to,
652     uint deadline
653   ) external returns (uint amountA, uint amountB);
654   function removeLiquidityETH(
655     address token,
656     uint liquidity,
657     uint amountTokenMin,
658     uint amountETHMin,
659     address to,
660     uint deadline
661   ) external returns (uint amountToken, uint amountETH);
662   function removeLiquidityWithPermit(
663     address tokenA,
664     address tokenB,
665     uint liquidity,
666     uint amountAMin,
667     uint amountBMin,
668     address to,
669     uint deadline,
670     bool approveMax, uint8 v, bytes32 r, bytes32 s
671   ) external returns (uint amountA, uint amountB);
672   function removeLiquidityETHWithPermit(
673     address token,
674     uint liquidity,
675     uint amountTokenMin,
676     uint amountETHMin,
677     address to,
678     uint deadline,
679     bool approveMax, uint8 v, bytes32 r, bytes32 s
680   ) external returns (uint amountToken, uint amountETH);
681   function swapExactTokensForTokens(
682     uint amountIn,
683     uint amountOutMin,
684     address[] calldata path,
685     address to,
686     uint deadline
687   ) external returns (uint[] memory amounts);
688   function swapTokensForExactTokens(
689     uint amountOut,
690     uint amountInMax,
691     address[] calldata path,
692     address to,
693     uint deadline
694   ) external returns (uint[] memory amounts);
695   function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
696     external
697     payable
698     returns (uint[] memory amounts);
699   function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
700     external
701     returns (uint[] memory amounts);
702   function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
703     external
704     returns (uint[] memory amounts);
705   function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
706     external
707     payable
708     returns (uint[] memory amounts);
709 
710   function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
711   function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
712   function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
713   function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
714   function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
715 }
716 
717 // File: contracts/Interfaces/IBadStaticCallERC20.sol
718 
719 pragma solidity ^0.5.0;
720 
721 /**
722  * @dev Interface to be safe with not so good proxy contracts.
723  */
724 interface IBadStaticCallERC20 {
725 
726     /**
727      * @dev Returns the amount of tokens owned by `account`.
728      */
729     function balanceOf(address account) external returns (uint256);
730 
731     /**
732      * @dev Returns the remaining number of tokens that `spender` will be
733      * allowed to spend on behalf of `owner` through {transferFrom}. This is
734      * zero by default.
735      *
736      * This value changes when {approve} or {transferFrom} are called.
737      */
738     function allowance(address owner, address spender) external returns (uint256);
739 
740     /**
741      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
742      *
743      * Returns a boolean value indicating whether the operation succeeded.
744      *
745      * IMPORTANT: Beware that changing an allowance with this method brings the risk
746      * that someone may use both the old and the new allowance by unfortunate
747      * transaction ordering. One possible solution to mitigate this race
748      * condition is to first reduce the spender's allowance to 0 and set the
749      * desired value afterwards:
750      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
751      *
752      * Emits an {Approval} event.
753      */
754     function approve(address spender, uint256 amount) external returns (bool);
755 }
756 
757 // File: contracts/Utils/SafeStaticCallERC20.sol
758 
759 pragma solidity ^0.5.0;
760 
761 
762 
763 
764 library SafeStaticCallERC20 {
765     using SafeMath for uint256;
766     using Address for address;
767 
768     function safeApprove(IBadStaticCallERC20 token, address spender, uint256 value) internal {
769         // safeApprove should only be called when setting an initial allowance,
770         // or when resetting it to zero. To increase and decrease it, use
771         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
772         // solhint-disable-next-line max-line-length
773         require((value == 0) || (token.allowance(address(this), spender) == 0),
774             "SafeProxyERC20: approve from non-zero to non-zero allowance"
775         );
776         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
777     }
778 
779     /**
780      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
781      * on the return value: the return value is optional (but if data is returned, it must not be false).
782      * @param token The token targeted by the call.
783      * @param data The call data (encoded using abi.encode or one of its variants).
784      */
785     function callOptionalReturn(IBadStaticCallERC20 token, bytes memory data) private {
786         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
787         // we're implementing it ourselves.
788 
789         // A Solidity high level call has three parts:
790         //  1. The target address is checked to verify it contains contract code
791         //  2. The call itself is made, and success asserted
792         //  3. The return value is decoded, which in turn checks the size of the returned data.
793         // solhint-disable-next-line max-line-length
794         require(address(token).isContract(), "SafeProxyERC20: call to non-contract");
795 
796         // solhint-disable-next-line avoid-low-level-calls
797         (bool success, bytes memory returndata) = address(token).call(data);
798         require(success, "SafeProxyERC20: low-level call failed");
799 
800         if (returndata.length > 0) { // Return data is optional
801             // solhint-disable-next-line max-line-length
802             require(abi.decode(returndata, (bool)), "SafeProxyERC20: ERC20 operation did not succeed");
803         }
804     }
805 }
806 
807 // File: openzeppelin-solidity/contracts/GSN/Context.sol
808 
809 pragma solidity ^0.5.0;
810 
811 /*
812  * @dev Provides information about the current execution context, including the
813  * sender of the transaction and its data. While these are generally available
814  * via msg.sender and msg.data, they should not be accessed in such a direct
815  * manner, since when dealing with GSN meta-transactions the account sending and
816  * paying for execution may not be the actual sender (as far as an application
817  * is concerned).
818  *
819  * This contract is only required for intermediate, library-like contracts.
820  */
821 contract Context {
822     // Empty internal constructor, to prevent people from mistakenly deploying
823     // an instance of this contract, which should be used via inheritance.
824     constructor () internal { }
825     // solhint-disable-previous-line no-empty-blocks
826 
827     function _msgSender() internal view returns (address payable) {
828         return msg.sender;
829     }
830 
831     function _msgData() internal view returns (bytes memory) {
832         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
833         return msg.data;
834     }
835 }
836 
837 // File: openzeppelin-solidity/contracts/Ownership/Ownable.sol
838 
839 pragma solidity ^0.5.0;
840 
841 /**
842  * @dev Contract module which provides a basic access control mechanism, where
843  * there is an account (an owner) that can be granted exclusive access to
844  * specific functions.
845  *
846  * This module is used through inheritance. It will make available the modifier
847  * `onlyOwner`, which can be applied to your functions to restrict their use to
848  * the owner.
849  */
850 contract Ownable is Context {
851     address private _owner;
852 
853     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
854 
855     /**
856      * @dev Initializes the contract setting the deployer as the initial owner.
857      */
858     constructor () internal {
859         _owner = _msgSender();
860         emit OwnershipTransferred(address(0), _owner);
861     }
862 
863     /**
864      * @dev Returns the address of the current owner.
865      */
866     function owner() public view returns (address) {
867         return _owner;
868     }
869 
870     /**
871      * @dev Throws if called by any account other than the owner.
872      */
873     modifier onlyOwner() {
874         require(isOwner(), "Ownable: caller is not the owner");
875         _;
876     }
877 
878     /**
879      * @dev Returns true if the caller is the current owner.
880      */
881     function isOwner() public view returns (bool) {
882         return _msgSender() == _owner;
883     }
884 
885     /**
886      * @dev Leaves the contract without owner. It will not be possible to call
887      * `onlyOwner` functions anymore. Can only be called by the current owner.
888      *
889      * NOTE: Renouncing ownership will leave the contract without an owner,
890      * thereby removing any functionality that is only available to the owner.
891      */
892     function renounceOwnership() public onlyOwner {
893         emit OwnershipTransferred(_owner, address(0));
894         _owner = address(0);
895     }
896 
897     /**
898      * @dev Transfers ownership of the contract to a new account (`newOwner`).
899      * Can only be called by the current owner.
900      */
901     function transferOwnership(address newOwner) public onlyOwner {
902         _transferOwnership(newOwner);
903     }
904 
905     /**
906      * @dev Transfers ownership of the contract to a new account (`newOwner`).
907      */
908     function _transferOwnership(address newOwner) internal {
909         require(newOwner != address(0), "Ownable: new owner is the zero address");
910         emit OwnershipTransferred(_owner, newOwner);
911         _owner = newOwner;
912     }
913 }
914 
915 // File: contracts/Utils/Destructible.sol
916 
917 pragma solidity >=0.5.0;
918 
919 
920 /**
921  * @title Destructible
922  * @dev Base contract that can be destroyed by owner. All funds in contract will be sent to the owner.
923  */
924 contract Destructible is Ownable {
925   /**
926    * @dev Transfers the current balance to the owner and terminates the contract.
927    */
928   function destroy() public onlyOwner {
929     selfdestruct(address(bytes20(owner())));
930   }
931 
932   function destroyAndSend(address payable _recipient) public onlyOwner {
933     selfdestruct(_recipient);
934   }
935 }
936 
937 // File: contracts/Utils/Pausable.sol
938 
939 pragma solidity >=0.4.24;
940 
941 
942 /**
943  * @title Pausable
944  * @dev Base contract which allows children to implement an emergency stop mechanism.
945  */
946 contract Pausable is Ownable {
947   event Pause();
948   event Unpause();
949 
950   bool public paused = false;
951 
952 
953   /**
954    * @dev Modifier to make a function callable only when the contract is not paused.
955    */
956   modifier whenNotPaused() {
957     require(!paused, "The contract is paused");
958     _;
959   }
960 
961   /**
962    * @dev Modifier to make a function callable only when the contract is paused.
963    */
964   modifier whenPaused() {
965     require(paused, "The contract is not paused");
966     _;
967   }
968 
969   /**
970    * @dev called by the owner to pause, triggers stopped state
971    */
972   function pause() public onlyOwner whenNotPaused {
973     paused = true;
974     emit Pause();
975   }
976 
977   /**
978    * @dev called by the owner to unpause, returns to normal state
979    */
980   function unpause() public onlyOwner whenPaused {
981     paused = false;
982     emit Unpause();
983   }
984 }
985 
986 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
987 
988 pragma solidity ^0.5.0;
989 
990 
991 
992 
993 /**
994  * @dev Implementation of the {IERC20} interface.
995  *
996  * This implementation is agnostic to the way tokens are created. This means
997  * that a supply mechanism has to be added in a derived contract using {_mint}.
998  * For a generic mechanism see {ERC20Mintable}.
999  *
1000  * TIP: For a detailed writeup see our guide
1001  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
1002  * to implement supply mechanisms].
1003  *
1004  * We have followed general OpenZeppelin guidelines: functions revert instead
1005  * of returning `false` on failure. This behavior is nonetheless conventional
1006  * and does not conflict with the expectations of ERC20 applications.
1007  *
1008  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
1009  * This allows applications to reconstruct the allowance for all accounts just
1010  * by listening to said events. Other implementations of the EIP may not emit
1011  * these events, as it isn't required by the specification.
1012  *
1013  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
1014  * functions have been added to mitigate the well-known issues around setting
1015  * allowances. See {IERC20-approve}.
1016  */
1017 contract ERC20 is Context, IERC20 {
1018     using SafeMath for uint256;
1019 
1020     mapping (address => uint256) private _balances;
1021 
1022     mapping (address => mapping (address => uint256)) private _allowances;
1023 
1024     uint256 private _totalSupply;
1025 
1026     /**
1027      * @dev See {IERC20-totalSupply}.
1028      */
1029     function totalSupply() public view returns (uint256) {
1030         return _totalSupply;
1031     }
1032 
1033     /**
1034      * @dev See {IERC20-balanceOf}.
1035      */
1036     function balanceOf(address account) public view returns (uint256) {
1037         return _balances[account];
1038     }
1039 
1040     /**
1041      * @dev See {IERC20-transfer}.
1042      *
1043      * Requirements:
1044      *
1045      * - `recipient` cannot be the zero address.
1046      * - the caller must have a balance of at least `amount`.
1047      */
1048     function transfer(address recipient, uint256 amount) public returns (bool) {
1049         _transfer(_msgSender(), recipient, amount);
1050         return true;
1051     }
1052 
1053     /**
1054      * @dev See {IERC20-allowance}.
1055      */
1056     function allowance(address owner, address spender) public view returns (uint256) {
1057         return _allowances[owner][spender];
1058     }
1059 
1060     /**
1061      * @dev See {IERC20-approve}.
1062      *
1063      * Requirements:
1064      *
1065      * - `spender` cannot be the zero address.
1066      */
1067     function approve(address spender, uint256 amount) public returns (bool) {
1068         _approve(_msgSender(), spender, amount);
1069         return true;
1070     }
1071 
1072     /**
1073      * @dev See {IERC20-transferFrom}.
1074      *
1075      * Emits an {Approval} event indicating the updated allowance. This is not
1076      * required by the EIP. See the note at the beginning of {ERC20};
1077      *
1078      * Requirements:
1079      * - `sender` and `recipient` cannot be the zero address.
1080      * - `sender` must have a balance of at least `amount`.
1081      * - the caller must have allowance for `sender`'s tokens of at least
1082      * `amount`.
1083      */
1084     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
1085         _transfer(sender, recipient, amount);
1086         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
1087         return true;
1088     }
1089 
1090     /**
1091      * @dev Atomically increases the allowance granted to `spender` by the caller.
1092      *
1093      * This is an alternative to {approve} that can be used as a mitigation for
1094      * problems described in {IERC20-approve}.
1095      *
1096      * Emits an {Approval} event indicating the updated allowance.
1097      *
1098      * Requirements:
1099      *
1100      * - `spender` cannot be the zero address.
1101      */
1102     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
1103         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
1104         return true;
1105     }
1106 
1107     /**
1108      * @dev Atomically decreases the allowance granted to `spender` by the caller.
1109      *
1110      * This is an alternative to {approve} that can be used as a mitigation for
1111      * problems described in {IERC20-approve}.
1112      *
1113      * Emits an {Approval} event indicating the updated allowance.
1114      *
1115      * Requirements:
1116      *
1117      * - `spender` cannot be the zero address.
1118      * - `spender` must have allowance for the caller of at least
1119      * `subtractedValue`.
1120      */
1121     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
1122         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
1123         return true;
1124     }
1125 
1126     /**
1127      * @dev Moves tokens `amount` from `sender` to `recipient`.
1128      *
1129      * This is internal function is equivalent to {transfer}, and can be used to
1130      * e.g. implement automatic token fees, slashing mechanisms, etc.
1131      *
1132      * Emits a {Transfer} event.
1133      *
1134      * Requirements:
1135      *
1136      * - `sender` cannot be the zero address.
1137      * - `recipient` cannot be the zero address.
1138      * - `sender` must have a balance of at least `amount`.
1139      */
1140     function _transfer(address sender, address recipient, uint256 amount) internal {
1141         require(sender != address(0), "ERC20: transfer from the zero address");
1142         require(recipient != address(0), "ERC20: transfer to the zero address");
1143 
1144         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
1145         _balances[recipient] = _balances[recipient].add(amount);
1146         emit Transfer(sender, recipient, amount);
1147     }
1148 
1149     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1150      * the total supply.
1151      *
1152      * Emits a {Transfer} event with `from` set to the zero address.
1153      *
1154      * Requirements
1155      *
1156      * - `to` cannot be the zero address.
1157      */
1158     function _mint(address account, uint256 amount) internal {
1159         require(account != address(0), "ERC20: mint to the zero address");
1160 
1161         _totalSupply = _totalSupply.add(amount);
1162         _balances[account] = _balances[account].add(amount);
1163         emit Transfer(address(0), account, amount);
1164     }
1165 
1166      /**
1167      * @dev Destroys `amount` tokens from `account`, reducing the
1168      * total supply.
1169      *
1170      * Emits a {Transfer} event with `to` set to the zero address.
1171      *
1172      * Requirements
1173      *
1174      * - `account` cannot be the zero address.
1175      * - `account` must have at least `amount` tokens.
1176      */
1177     function _burn(address account, uint256 amount) internal {
1178         require(account != address(0), "ERC20: burn from the zero address");
1179 
1180         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
1181         _totalSupply = _totalSupply.sub(amount);
1182         emit Transfer(account, address(0), amount);
1183     }
1184 
1185     /**
1186      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
1187      *
1188      * This is internal function is equivalent to `approve`, and can be used to
1189      * e.g. set automatic allowances for certain subsystems, etc.
1190      *
1191      * Emits an {Approval} event.
1192      *
1193      * Requirements:
1194      *
1195      * - `owner` cannot be the zero address.
1196      * - `spender` cannot be the zero address.
1197      */
1198     function _approve(address owner, address spender, uint256 amount) internal {
1199         require(owner != address(0), "ERC20: approve from the zero address");
1200         require(spender != address(0), "ERC20: approve to the zero address");
1201 
1202         _allowances[owner][spender] = amount;
1203         emit Approval(owner, spender, amount);
1204     }
1205 
1206     /**
1207      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
1208      * from the caller's allowance.
1209      *
1210      * See {_burn} and {_approve}.
1211      */
1212     function _burnFrom(address account, uint256 amount) internal {
1213         _burn(account, amount);
1214         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
1215     }
1216 }
1217 
1218 // File: contracts/Utils/Withdrawable.sol
1219 
1220 pragma solidity >=0.4.24;
1221 
1222 
1223 
1224 
1225 contract Withdrawable is Ownable {
1226   using SafeERC20 for ERC20;
1227   address constant ETHER = address(0);
1228 
1229   event LogWithdrawToken(
1230     address indexed _from,
1231     address indexed _token,
1232     uint amount
1233   );
1234 
1235   /**
1236    * @dev Withdraw asset.
1237    * @param _tokenAddress Asset to be withdrawed.
1238    * @return bool.
1239    */
1240   function withdrawToken(address _tokenAddress) public onlyOwner {
1241     uint tokenBalance;
1242     if (_tokenAddress == ETHER) {
1243       address self = address(this); // workaround for a possible solidity bug
1244       tokenBalance = self.balance;
1245       msg.sender.transfer(tokenBalance);
1246     } else {
1247       tokenBalance = ERC20(_tokenAddress).balanceOf(address(this));
1248       ERC20(_tokenAddress).safeTransfer(msg.sender, tokenBalance);
1249     }
1250     emit LogWithdrawToken(msg.sender, _tokenAddress, tokenBalance);
1251   }
1252 
1253 }
1254 
1255 // File: contracts/Utils/WithFee.sol
1256 
1257 pragma solidity ^0.5.0;
1258 
1259 
1260 
1261 
1262 
1263 contract WithFee is Ownable {
1264   using SafeERC20 for IERC20;
1265   using SafeMath for uint;
1266   address payable public feeWallet;
1267   uint public storedSpread;
1268   uint constant spreadDecimals = 6;
1269   uint constant spreadUnit = 10 ** spreadDecimals;
1270 
1271   event LogFee(address token, uint amount);
1272 
1273   constructor(address payable _wallet, uint _spread) public {
1274     require(_wallet != address(0), "_wallet == address(0)");
1275     require(_spread < spreadUnit, "spread >= spreadUnit");
1276     feeWallet = _wallet;
1277     storedSpread = _spread;
1278   }
1279 
1280   function setFeeWallet(address payable _wallet) external onlyOwner {
1281     require(_wallet != address(0), "_wallet == address(0)");
1282     feeWallet = _wallet;
1283   }
1284 
1285   function setSpread(uint _spread) external onlyOwner {
1286     storedSpread = _spread;
1287   }
1288 
1289   function _getFee(uint underlyingTokenTotal) internal view returns(uint) {
1290     return underlyingTokenTotal.mul(storedSpread).div(spreadUnit);
1291   }
1292 
1293   function _payFee(address feeToken, uint fee) internal {
1294     if (fee > 0) {
1295       if (feeToken == address(0)) {
1296         feeWallet.transfer(fee);
1297       } else {
1298         IERC20(feeToken).safeTransfer(feeWallet, fee);
1299       }
1300       emit LogFee(feeToken, fee);
1301     }
1302   }
1303 
1304 }
1305 
1306 // File: contracts/Interfaces/IErc20Swap.sol
1307 
1308 pragma solidity >=0.4.0;
1309 
1310 interface IErc20Swap {
1311     function getRate(address src, address dst, uint256 srcAmount) external view returns(uint expectedRate, uint slippageRate);  // real rate = returned value / 1e18
1312     function swap(address src, uint srcAmount, address dest, uint maxDestAmount, uint minConversionRate) external payable;
1313 
1314     event LogTokenSwap(
1315         address indexed _userAddress,
1316         address indexed _userSentTokenAddress,
1317         uint _userSentTokenAmount,
1318         address indexed _userReceivedTokenAddress,
1319         uint _userReceivedTokenAmount
1320     );
1321 }
1322 
1323 // File: contracts/base/NetworkBasedTokenSwap.sol
1324 
1325 pragma solidity >=0.5.0;
1326 
1327 
1328 
1329 
1330 
1331 
1332 
1333 
1334 
1335 
1336 contract NetworkBasedTokenSwap is Withdrawable, Pausable, Destructible, WithFee, IErc20Swap
1337 {
1338   using SafeMath for uint;
1339   using SafeERC20 for IERC20;
1340   address constant ETHER = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
1341 
1342   mapping (address => mapping (address => uint)) spreadCustom;
1343 
1344   event UnexpectedIntialBalance(address token, uint amount);
1345 
1346   constructor(
1347     address payable _wallet,
1348     uint _spread
1349   )
1350     public WithFee(_wallet, _spread)
1351   {}
1352 
1353   function() external payable {
1354     // can receive ethers
1355   }
1356 
1357   // spread value >= spreadUnit means no fee
1358   function setSpread(address tokenA, address tokenB, uint spread) public onlyOwner {
1359     uint value = spread > spreadUnit ? spreadUnit : spread;
1360     spreadCustom[tokenA][tokenB] = value;
1361     spreadCustom[tokenB][tokenA] = value;
1362   }
1363 
1364   function getSpread(address tokenA, address tokenB) public view returns(uint) {
1365     uint value = spreadCustom[tokenA][tokenB];
1366     if (value == 0) return storedSpread;
1367     if (value >= spreadUnit) return 0;
1368     else return value;
1369   }
1370 
1371   // kyber network style rate
1372   function getNetworkRate(address src, address dest, uint256 srcAmount) internal view returns(uint expectedRate, uint slippageRate);
1373 
1374   function getRate(address src, address dest, uint256 srcAmount) external view
1375     returns(uint expectedRate, uint slippageRate)
1376   {
1377     (uint256 kExpected, uint256 kSplippage) = getNetworkRate(src, dest, srcAmount);
1378     uint256 spread = getSpread(src, dest);
1379     expectedRate = kExpected.mul(spreadUnit - spread).div(spreadUnit);
1380     slippageRate = kSplippage.mul(spreadUnit - spread).div(spreadUnit);
1381   }
1382 
1383   function _freeUnexpectedTokens(address token) private {
1384     uint256 unexpectedBalance = token == ETHER
1385       ? _myEthBalance().sub(msg.value)
1386       : IBadStaticCallERC20(token).balanceOf(address(this));
1387     if (unexpectedBalance > 0) {
1388       _transfer(token, address(bytes20(owner())), unexpectedBalance);
1389       emit UnexpectedIntialBalance(token, unexpectedBalance);
1390     }
1391   }
1392 
1393   function swap(address src, uint srcAmount, address dest, uint maxDestAmount, uint minConversionRate) public payable {
1394     require(src != dest, "src == dest");
1395     require(srcAmount > 0, "srcAmount == 0");
1396 
1397     // empty unexpected initial balances
1398     _freeUnexpectedTokens(src);
1399     _freeUnexpectedTokens(dest);
1400 
1401     if (src == ETHER) {
1402       require(msg.value == srcAmount, "msg.value != srcAmount");
1403     } else {
1404       require(
1405         IBadStaticCallERC20(src).allowance(msg.sender, address(this)) >= srcAmount,
1406         "ERC20 allowance < srcAmount"
1407       );
1408       // get user's tokens
1409       IERC20(src).safeTransferFrom(msg.sender, address(this), srcAmount);
1410     }
1411 
1412     uint256 spread = getSpread(src, dest);
1413 
1414     // calculate the minConversionRate and maxDestAmount keeping in mind the fee
1415     uint256 adaptedMinRate = minConversionRate.mul(spreadUnit).div(spreadUnit - spread);
1416     uint256 adaptedMaxDestAmount = maxDestAmount.mul(spreadUnit).div(spreadUnit - spread);
1417     uint256 destTradedAmount = doNetworkTrade(src, srcAmount, dest, adaptedMaxDestAmount, adaptedMinRate);
1418 
1419     uint256 notTraded = _myBalance(src);
1420     uint256 srcTradedAmount = srcAmount.sub(notTraded);
1421     require(srcTradedAmount > 0, "no traded tokens");
1422     require(
1423       _myBalance(dest) >= destTradedAmount,
1424       "No enough dest tokens after trade"
1425     );
1426     // pay fee and user
1427     uint256 toUserAmount = _payFee(dest, destTradedAmount, spread);
1428     _transfer(dest, msg.sender, toUserAmount);
1429     // returns not traded tokens if any
1430     if (notTraded > 0) {
1431       _transfer(src, msg.sender, notTraded);
1432     }
1433 
1434     emit LogTokenSwap(
1435       msg.sender,
1436       src,
1437       srcTradedAmount,
1438       dest,
1439       toUserAmount
1440     );
1441   }
1442 
1443   function doNetworkTrade(address src, uint srcAmount, address dest, uint maxDestAmount, uint minConversionRate) internal returns(uint256);
1444 
1445   function _payFee(address token, uint destTradedAmount, uint spread) private returns(uint256 toUserAmount) {
1446     uint256 fee = destTradedAmount.mul(spread).div(spreadUnit);
1447     toUserAmount = destTradedAmount.sub(fee);
1448     // pay fee
1449     super._payFee(token == ETHER ? address(0) : token, fee);
1450   }
1451 
1452   // workaround for a solidity bug
1453   function _myEthBalance() private view returns(uint256) {
1454     address self = address(this);
1455     return self.balance;
1456   }
1457 
1458   function _myBalance(address token) private returns(uint256) {
1459     return token == ETHER
1460       ? _myEthBalance()
1461       : IBadStaticCallERC20(token).balanceOf(address(this));
1462   }
1463 
1464   function _transfer(address token, address payable recipient, uint256 amount) private {
1465     if (token == ETHER) {
1466       recipient.transfer(amount);
1467     } else {
1468       IERC20(token).safeTransfer(recipient, amount);
1469     }
1470   }
1471 
1472 }
1473 
1474 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Detailed.sol
1475 
1476 pragma solidity ^0.5.0;
1477 
1478 
1479 /**
1480  * @dev Optional functions from the ERC20 standard.
1481  */
1482 contract ERC20Detailed is IERC20 {
1483     string private _name;
1484     string private _symbol;
1485     uint8 private _decimals;
1486 
1487     /**
1488      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
1489      * these values are immutable: they can only be set once during
1490      * construction.
1491      */
1492     constructor (string memory name, string memory symbol, uint8 decimals) public {
1493         _name = name;
1494         _symbol = symbol;
1495         _decimals = decimals;
1496     }
1497 
1498     /**
1499      * @dev Returns the name of the token.
1500      */
1501     function name() public view returns (string memory) {
1502         return _name;
1503     }
1504 
1505     /**
1506      * @dev Returns the symbol of the token, usually a shorter version of the
1507      * name.
1508      */
1509     function symbol() public view returns (string memory) {
1510         return _symbol;
1511     }
1512 
1513     /**
1514      * @dev Returns the number of decimals used to get its user representation.
1515      * For example, if `decimals` equals `2`, a balance of `505` tokens should
1516      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
1517      *
1518      * Tokens usually opt for a value of 18, imitating the relationship between
1519      * Ether and Wei.
1520      *
1521      * NOTE: This information is only used for _display_ purposes: it in
1522      * no way affects any of the arithmetic of the contract, including
1523      * {IERC20-balanceOf} and {IERC20-transfer}.
1524      */
1525     function decimals() public view returns (uint8) {
1526         return _decimals;
1527     }
1528 }
1529 
1530 // File: contracts/Utils/LowLevel.sol
1531 
1532 pragma solidity ^0.5.0;
1533 
1534 library LowLevel {
1535   function staticCallContractAddr(address target, bytes memory payload) internal view
1536     returns (bool success_, address result_)
1537   {
1538     (bool success, bytes memory result) = address(target).staticcall(payload);
1539     if (success && result.length == 32) {
1540       return (true, abi.decode(result, (address)));
1541     }
1542     return (false, address(0));
1543   }
1544 
1545   function callContractAddr(address target, bytes memory payload) internal
1546     returns (bool success_, address result_)
1547   {
1548     (bool success, bytes memory result) = address(target).call(payload);
1549     if (success && result.length == 32) {
1550       return (true, abi.decode(result, (address)));
1551     }
1552     return (false, address(0));
1553   }
1554 
1555   function staticCallContractUint(address target, bytes memory payload) internal view
1556     returns (bool success_, uint result_)
1557   {
1558     (bool success, bytes memory result) = address(target).staticcall(payload);
1559     if (success && result.length == 32) {
1560       return (true, abi.decode(result, (uint)));
1561     }
1562     return (false, 0);
1563   }
1564 
1565   function callContractUint(address target, bytes memory payload) internal
1566     returns (bool success_, uint result_)
1567   {
1568     (bool success, bytes memory result) = address(target).call(payload);
1569     if (success && result.length == 32) {
1570       return (true, abi.decode(result, (uint)));
1571     }
1572     return (false, 0);
1573   }
1574 }
1575 
1576 // File: contracts/Utils/RateNormalization.sol
1577 
1578 pragma solidity ^0.5.0;
1579 
1580 
1581 
1582 
1583 
1584 contract RateNormalization is Ownable {
1585   using SafeMath for uint;
1586 
1587   struct RateAdjustment {
1588     uint factor;
1589     bool multiply;
1590   }
1591 
1592   mapping (address => mapping(address => RateAdjustment)) public rateAdjustment;
1593   mapping (address => uint) public forcedDecimals;
1594 
1595   function _getAdjustment(address src, address dest) private view returns(RateAdjustment memory) {
1596     RateAdjustment memory adj = rateAdjustment[src][dest];
1597     if (adj.factor == 0) {
1598       uint srcDecimals = _getDecimals(src);
1599       uint destDecimals = _getDecimals(dest);
1600       if (srcDecimals != destDecimals) {
1601         if (srcDecimals > destDecimals) {
1602           adj.multiply = true;
1603           adj.factor = 10 ** (srcDecimals - destDecimals);
1604         } else {
1605           adj.multiply = false;
1606           adj.factor = 10 ** (destDecimals - srcDecimals);
1607         }
1608       }
1609     }
1610     return adj;
1611   }
1612 
1613   // return normalized rate
1614   function normalizeRate(address src, address dest, uint256 rate) public view
1615     returns(uint)
1616   {
1617     RateAdjustment memory adj = _getAdjustment(src, dest);
1618     if (adj.factor > 1) {
1619       rate = adj.multiply
1620         ? rate.mul(adj.factor)
1621         : rate.div(adj.factor);
1622     }
1623     return rate;
1624   }
1625 
1626   function denormalizeRate(address src, address dest, uint256 rate) public view
1627     returns(uint)
1628   {
1629     RateAdjustment memory adj = _getAdjustment(src, dest);
1630     if (adj.factor > 1) {
1631       rate = adj.multiply  // invert multiply/divide for denormalization
1632         ? rate.div(adj.factor)
1633         : rate.mul(adj.factor);
1634     }
1635     return rate;
1636   }
1637 
1638   function denormalizeRate(address src, address dest, uint256 rate, uint256 slippage) public view
1639     returns(uint, uint)
1640   {
1641     RateAdjustment memory adj = _getAdjustment(src, dest);
1642     if (adj.factor > 1) {
1643       if (adj.multiply) {
1644         rate = rate.div(adj.factor);
1645         slippage = slippage.div(adj.factor);
1646       } else {
1647         rate = rate.mul(adj.factor);
1648         slippage = slippage.mul(adj.factor);
1649       }
1650     }
1651     return (rate, slippage);
1652   }
1653 
1654   function _getDecimals(address token) internal view returns(uint) {
1655     uint forced = forcedDecimals[token];
1656     if (forced > 0) return forced;
1657     bytes memory payload = abi.encodeWithSignature("decimals()");
1658     (bool success, uint decimals) = LowLevel.staticCallContractUint(token, payload);
1659     require(success, "the token doesn't expose the decimals number");
1660     return decimals;
1661   }
1662 
1663   function setRateAdjustmentFactor(address src, address dest, uint factor, bool multiply) public onlyOwner {
1664     rateAdjustment[src][dest] = RateAdjustment(factor, multiply);
1665     rateAdjustment[dest][src] = RateAdjustment(factor, !multiply);
1666   }
1667 
1668   function setForcedDecimals(address token, uint decimals) public onlyOwner {
1669     forcedDecimals[token] = decimals;
1670   }
1671 
1672 }
1673 
1674 // File: contracts/UniswapV2TokenSwap.sol
1675 
1676 pragma solidity >=0.5.0;
1677 
1678 
1679 
1680 
1681 
1682 
1683 
1684 
1685 
1686 
1687 
1688 
1689 
1690 contract UniswapV2TokenSwap is RateNormalization, NetworkBasedTokenSwap
1691 {
1692   using SafeMath for uint;
1693   using SafeERC20 for IERC20;
1694   using SafeStaticCallERC20 for IBadStaticCallERC20;
1695   uint constant expScale = 1e18;
1696 
1697   IUniswapV2Factory public uniswapFactory;
1698   IUniswapV2Router01 public router;
1699 
1700   mapping (address => address) public exchangeAddressCustom;
1701 
1702   constructor(
1703     address payable _wallet,
1704     uint _spread
1705   )
1706     public NetworkBasedTokenSwap(_wallet, _spread)
1707   {
1708     setForcedDecimals(ETHER, 18);
1709     // the router address is deterministic and it is the same in all networks
1710     setUniswap(0xf164fC0Ec4E93095b804a4795bBe1e041497b92a);
1711   }
1712 
1713   function setUniswap(address _uniswapRouter) public onlyOwner {
1714     require(_uniswapRouter != address(0), "_uniswapRouter == address(0)");
1715     router = IUniswapV2Router01(_uniswapRouter);
1716     uniswapFactory = IUniswapV2Factory(router.factory());
1717   }
1718 
1719   function _getUniswapRate(address[] memory path, uint srcAmount) private view returns(uint rate, uint destAmount) {
1720     uint[] memory amounts = UniswapV2Library.getAmountsOut(address(uniswapFactory), srcAmount, path);
1721     destAmount = amounts[amounts.length - 1];
1722 //    rate = destAmount.mul(expScale).div(srcAmount);
1723     rate = _calcRate(srcAmount, destAmount);
1724   }
1725 
1726   function _getPath(address srcToken, address destToken) private view returns(address[] memory res) {
1727     address WETH = router.WETH();
1728     address from = srcToken == ETHER ? WETH : srcToken;
1729     address to = destToken == ETHER ? WETH : destToken;
1730     if (uniswapFactory.getPair(from, to) != address(0)) {
1731       res = new address[](2);
1732       res[0] = from;
1733       res[1] = to;
1734     } else if (
1735       uniswapFactory.getPair(from, WETH) != address(0) &&
1736       uniswapFactory.getPair(WETH, to) != address(0)
1737     ) {
1738       res = new address[](3);
1739       res[0] = from;
1740       res[1] = WETH;
1741       res[2] = to;
1742     } else {
1743       res = new address[](0);
1744     }
1745   }
1746 
1747   function _calcRate(uint srcAmount, uint destAmount) private pure returns(uint) {
1748     return destAmount.mul(expScale).div(srcAmount);
1749   }
1750 
1751   function getNetworkRate(address src, address dest, uint256 srcAmount) internal view
1752     returns(uint expectedRate, uint slippageRate)
1753   {
1754     address[] memory path = _getPath(src, dest);
1755     (uint rate, ) = _getUniswapRate(path, srcAmount);
1756     uint normalizedRate = normalizeRate(src, dest, rate);
1757     return (normalizedRate, normalizedRate);
1758   }
1759 
1760   function _approveWithReset(address token, address spender, uint amount) private {
1761     if (IBadStaticCallERC20(token).allowance(address(this), spender) > 0) {
1762       IBadStaticCallERC20(token).safeApprove(spender, 0);
1763     }
1764     IBadStaticCallERC20(token).safeApprove(spender, amount);
1765   }
1766 
1767   function doNetworkTrade(address src, uint srcAmount, address dest, uint maxDestAmount, uint minConversionRate)
1768     internal returns(uint256)
1769   {
1770     address[] memory path = _getPath(src, dest);
1771     (uint rate, uint destAmount) = _getUniswapRate(path, srcAmount);
1772     uint toTradeAmount = destAmount > maxDestAmount
1773       ? maxDestAmount.mul(expScale).div(rate)
1774       : srcAmount;
1775 
1776     // convert source ethers to WETHs
1777     if (src == ETHER) {
1778       IWETH(router.WETH()).deposit.value(toTradeAmount)();
1779     }
1780 
1781     _approveWithReset(path[0], address(router), toTradeAmount);
1782     uint[] memory amounts = router.swapExactTokensForTokens(toTradeAmount, 0, path, address(this), now);
1783     require(amounts.length > 0, 'amounts.length == 0');
1784     uint finalDestAmount = amounts[amounts.length - 1];
1785 
1786     // convert WETHs to ethers
1787     if (dest == ETHER) {
1788       IWETH(router.WETH()).withdraw(finalDestAmount);
1789     }
1790 
1791     require(normalizeRate(src, dest, _calcRate(toTradeAmount, finalDestAmount)) >= minConversionRate, "cannot satisfy minConversionRate");
1792     return finalDestAmount;
1793   }
1794 
1795 }