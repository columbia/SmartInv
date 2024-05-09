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
250      * [IMPORTANT]
251      * ====
252      * It is unsafe to assume that an address for which this function returns
253      * false is an externally-owned account (EOA) and not a contract.
254      *
255      * Among others, `isContract` will return false for the following 
256      * types of addresses:
257      *
258      *  - an externally-owned account
259      *  - a contract in construction
260      *  - an address where a contract will be created
261      *  - an address where a contract lived, but was destroyed
262      * ====
263      */
264     function isContract(address account) internal view returns (bool) {
265         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
266         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
267         // for accounts without code, i.e. `keccak256('')`
268         bytes32 codehash;
269         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
270         // solhint-disable-next-line no-inline-assembly
271         assembly { codehash := extcodehash(account) }
272         return (codehash != accountHash && codehash != 0x0);
273     }
274 
275     /**
276      * @dev Converts an `address` into `address payable`. Note that this is
277      * simply a type cast: the actual underlying value is not changed.
278      *
279      * _Available since v2.4.0._
280      */
281     function toPayable(address account) internal pure returns (address payable) {
282         return address(uint160(account));
283     }
284 
285     /**
286      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
287      * `recipient`, forwarding all available gas and reverting on errors.
288      *
289      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
290      * of certain opcodes, possibly making contracts go over the 2300 gas limit
291      * imposed by `transfer`, making them unable to receive funds via
292      * `transfer`. {sendValue} removes this limitation.
293      *
294      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
295      *
296      * IMPORTANT: because control is transferred to `recipient`, care must be
297      * taken to not create reentrancy vulnerabilities. Consider using
298      * {ReentrancyGuard} or the
299      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
300      *
301      * _Available since v2.4.0._
302      */
303     function sendValue(address payable recipient, uint256 amount) internal {
304         require(address(this).balance >= amount, "Address: insufficient balance");
305 
306         // solhint-disable-next-line avoid-call-value
307         (bool success, ) = recipient.call.value(amount)("");
308         require(success, "Address: unable to send value, recipient may have reverted");
309     }
310 }
311 
312 // File: openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol
313 
314 pragma solidity ^0.5.0;
315 
316 
317 
318 
319 /**
320  * @title SafeERC20
321  * @dev Wrappers around ERC20 operations that throw on failure (when the token
322  * contract returns false). Tokens that return no value (and instead revert or
323  * throw on failure) are also supported, non-reverting calls are assumed to be
324  * successful.
325  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
326  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
327  */
328 library SafeERC20 {
329     using SafeMath for uint256;
330     using Address for address;
331 
332     function safeTransfer(IERC20 token, address to, uint256 value) internal {
333         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
334     }
335 
336     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
337         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
338     }
339 
340     function safeApprove(IERC20 token, address spender, uint256 value) internal {
341         // safeApprove should only be called when setting an initial allowance,
342         // or when resetting it to zero. To increase and decrease it, use
343         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
344         // solhint-disable-next-line max-line-length
345         require((value == 0) || (token.allowance(address(this), spender) == 0),
346             "SafeERC20: approve from non-zero to non-zero allowance"
347         );
348         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
349     }
350 
351     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
352         uint256 newAllowance = token.allowance(address(this), spender).add(value);
353         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
354     }
355 
356     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
357         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
358         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
359     }
360 
361     /**
362      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
363      * on the return value: the return value is optional (but if data is returned, it must not be false).
364      * @param token The token targeted by the call.
365      * @param data The call data (encoded using abi.encode or one of its variants).
366      */
367     function callOptionalReturn(IERC20 token, bytes memory data) private {
368         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
369         // we're implementing it ourselves.
370 
371         // A Solidity high level call has three parts:
372         //  1. The target address is checked to verify it contains contract code
373         //  2. The call itself is made, and success asserted
374         //  3. The return value is decoded, which in turn checks the size of the returned data.
375         // solhint-disable-next-line max-line-length
376         require(address(token).isContract(), "SafeERC20: call to non-contract");
377 
378         // solhint-disable-next-line avoid-low-level-calls
379         (bool success, bytes memory returndata) = address(token).call(data);
380         require(success, "SafeERC20: low-level call failed");
381 
382         if (returndata.length > 0) { // Return data is optional
383             // solhint-disable-next-line max-line-length
384             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
385         }
386     }
387 }
388 
389 // File: contracts/Interfaces/IBadStaticCallERC20.sol
390 
391 pragma solidity ^0.5.0;
392 
393 /**
394  * @dev Interface to be safe with not so good proxy contracts.
395  */
396 interface IBadStaticCallERC20 {
397 
398     /**
399      * @dev Returns the amount of tokens owned by `account`.
400      */
401     function balanceOf(address account) external returns (uint256);
402 
403     /**
404      * @dev Returns the remaining number of tokens that `spender` will be
405      * allowed to spend on behalf of `owner` through {transferFrom}. This is
406      * zero by default.
407      *
408      * This value changes when {approve} or {transferFrom} are called.
409      */
410     function allowance(address owner, address spender) external returns (uint256);
411 
412     /**
413      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
414      *
415      * Returns a boolean value indicating whether the operation succeeded.
416      *
417      * IMPORTANT: Beware that changing an allowance with this method brings the risk
418      * that someone may use both the old and the new allowance by unfortunate
419      * transaction ordering. One possible solution to mitigate this race
420      * condition is to first reduce the spender's allowance to 0 and set the
421      * desired value afterwards:
422      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
423      *
424      * Emits an {Approval} event.
425      */
426     function approve(address spender, uint256 amount) external returns (bool);
427 }
428 
429 // File: contracts/Utils/SafeStaticCallERC20.sol
430 
431 pragma solidity ^0.5.0;
432 
433 
434 
435 
436 library SafeStaticCallERC20 {
437     using SafeMath for uint256;
438     using Address for address;
439 
440     function safeApprove(IBadStaticCallERC20 token, address spender, uint256 value) internal {
441         // safeApprove should only be called when setting an initial allowance,
442         // or when resetting it to zero. To increase and decrease it, use
443         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
444         // solhint-disable-next-line max-line-length
445         require((value == 0) || (token.allowance(address(this), spender) == 0),
446             "SafeProxyERC20: approve from non-zero to non-zero allowance"
447         );
448         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
449     }
450 
451     /**
452      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
453      * on the return value: the return value is optional (but if data is returned, it must not be false).
454      * @param token The token targeted by the call.
455      * @param data The call data (encoded using abi.encode or one of its variants).
456      */
457     function callOptionalReturn(IBadStaticCallERC20 token, bytes memory data) private {
458         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
459         // we're implementing it ourselves.
460 
461         // A Solidity high level call has three parts:
462         //  1. The target address is checked to verify it contains contract code
463         //  2. The call itself is made, and success asserted
464         //  3. The return value is decoded, which in turn checks the size of the returned data.
465         // solhint-disable-next-line max-line-length
466         require(address(token).isContract(), "SafeProxyERC20: call to non-contract");
467 
468         // solhint-disable-next-line avoid-low-level-calls
469         (bool success, bytes memory returndata) = address(token).call(data);
470         require(success, "SafeProxyERC20: low-level call failed");
471 
472         if (returndata.length > 0) { // Return data is optional
473             // solhint-disable-next-line max-line-length
474             require(abi.decode(returndata, (bool)), "SafeProxyERC20: ERC20 operation did not succeed");
475         }
476     }
477 }
478 
479 // File: @uniswap/v2-core/contracts/interfaces/IUniswapV2Factory.sol
480 
481 pragma solidity >=0.5.0;
482 
483 interface IUniswapV2Factory {
484     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
485 
486     function feeTo() external view returns (address);
487     function feeToSetter() external view returns (address);
488 
489     function getPair(address tokenA, address tokenB) external view returns (address pair);
490     function allPairs(uint) external view returns (address pair);
491     function allPairsLength() external view returns (uint);
492 
493     function createPair(address tokenA, address tokenB) external returns (address pair);
494 
495     function setFeeTo(address) external;
496     function setFeeToSetter(address) external;
497 }
498 
499 // File: @uniswap/v2-core/contracts/interfaces/IUniswapV2Pair.sol
500 
501 pragma solidity >=0.5.0;
502 
503 interface IUniswapV2Pair {
504     event Approval(address indexed owner, address indexed spender, uint value);
505     event Transfer(address indexed from, address indexed to, uint value);
506 
507     function name() external pure returns (string memory);
508     function symbol() external pure returns (string memory);
509     function decimals() external pure returns (uint8);
510     function totalSupply() external view returns (uint);
511     function balanceOf(address owner) external view returns (uint);
512     function allowance(address owner, address spender) external view returns (uint);
513 
514     function approve(address spender, uint value) external returns (bool);
515     function transfer(address to, uint value) external returns (bool);
516     function transferFrom(address from, address to, uint value) external returns (bool);
517 
518     function DOMAIN_SEPARATOR() external view returns (bytes32);
519     function PERMIT_TYPEHASH() external pure returns (bytes32);
520     function nonces(address owner) external view returns (uint);
521 
522     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
523 
524     event Mint(address indexed sender, uint amount0, uint amount1);
525     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
526     event Swap(
527         address indexed sender,
528         uint amount0In,
529         uint amount1In,
530         uint amount0Out,
531         uint amount1Out,
532         address indexed to
533     );
534     event Sync(uint112 reserve0, uint112 reserve1);
535 
536     function MINIMUM_LIQUIDITY() external pure returns (uint);
537     function factory() external view returns (address);
538     function token0() external view returns (address);
539     function token1() external view returns (address);
540     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
541     function price0CumulativeLast() external view returns (uint);
542     function price1CumulativeLast() external view returns (uint);
543     function kLast() external view returns (uint);
544 
545     function mint(address to) external returns (uint liquidity);
546     function burn(address to) external returns (uint amount0, uint amount1);
547     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
548     function skim(address to) external;
549     function sync() external;
550 
551     function initialize(address, address) external;
552 }
553 
554 // File: @uniswap/v2-periphery/contracts/interfaces/IWETH.sol
555 
556 pragma solidity >=0.5.0;
557 
558 interface IWETH {
559     function deposit() external payable;
560     function transfer(address to, uint value) external returns (bool);
561     function withdraw(uint) external;
562 }
563 
564 // File: contracts/Utils/UniswapV2Library.sol
565 
566 pragma solidity >=0.5.0;
567 
568 // reimplemented because the original library imports the local SafeMath that requires solidity 0.6.x
569 
570 
571 
572 library UniswapV2Library {
573     using SafeMath for uint;
574 
575     // returns sorted token addresses, used to handle return values from pairs sorted in this order
576     function sortTokens(address tokenA, address tokenB) internal pure returns (address token0, address token1) {
577         require(tokenA != tokenB, 'UniswapV2Library: IDENTICAL_ADDRESSES');
578         (token0, token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
579         require(token0 != address(0), 'UniswapV2Library: ZERO_ADDRESS');
580     }
581 
582     // calculates the CREATE2 address for a pair without making any external calls
583     function pairFor(address factory, address tokenA, address tokenB) internal pure returns (address pair) {
584         (address token0, address token1) = sortTokens(tokenA, tokenB);
585         pair = address(uint(keccak256(abi.encodePacked(
586                 hex'ff',
587                 factory,
588                 keccak256(abi.encodePacked(token0, token1)),
589                 hex'96e8ac4277198ff8b6f785478aa9a39f403cb768dd02cbee326c3e7da348845f' // init code hash
590             ))));
591     }
592 
593     // fetches and sorts the reserves for a pair
594     function getReserves(address factory, address tokenA, address tokenB) internal view returns (uint reserveA, uint reserveB) {
595         (address token0,) = sortTokens(tokenA, tokenB);
596         (uint reserve0, uint reserve1,) = IUniswapV2Pair(pairFor(factory, tokenA, tokenB)).getReserves();
597         (reserveA, reserveB) = tokenA == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
598     }
599 
600     // given some amount of an asset and pair reserves, returns an equivalent amount of the other asset
601     function quote(uint amountA, uint reserveA, uint reserveB) internal pure returns (uint amountB) {
602         require(amountA > 0, 'UniswapV2Library: INSUFFICIENT_AMOUNT');
603         require(reserveA > 0 && reserveB > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
604         amountB = amountA.mul(reserveB) / reserveA;
605     }
606 
607     // given an input amount of an asset and pair reserves, returns the maximum output amount of the other asset
608     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) internal pure returns (uint amountOut) {
609         require(amountIn > 0, 'UniswapV2Library: INSUFFICIENT_INPUT_AMOUNT');
610         require(reserveIn > 0 && reserveOut > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
611         uint amountInWithFee = amountIn.mul(997);
612         uint numerator = amountInWithFee.mul(reserveOut);
613         uint denominator = reserveIn.mul(1000).add(amountInWithFee);
614         amountOut = numerator / denominator;
615     }
616 
617     // given an output amount of an asset and pair reserves, returns a required input amount of the other asset
618     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) internal pure returns (uint amountIn) {
619         require(amountOut > 0, 'UniswapV2Library: INSUFFICIENT_OUTPUT_AMOUNT');
620         require(reserveIn > 0 && reserveOut > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
621         uint numerator = reserveIn.mul(amountOut).mul(1000);
622         uint denominator = reserveOut.sub(amountOut).mul(997);
623         amountIn = (numerator / denominator).add(1);
624     }
625 
626     // performs chained getAmountOut calculations on any number of pairs
627     function getAmountsOut(address factory, uint amountIn, address[] memory path) internal view returns (uint[] memory amounts) {
628         require(path.length >= 2, 'UniswapV2Library: INVALID_PATH');
629         amounts = new uint[](path.length);
630         amounts[0] = amountIn;
631         for (uint i; i < path.length - 1; i++) {
632             (uint reserveIn, uint reserveOut) = getReserves(factory, path[i], path[i + 1]);
633             amounts[i + 1] = getAmountOut(amounts[i], reserveIn, reserveOut);
634         }
635     }
636 
637     // performs chained getAmountIn calculations on any number of pairs
638     function getAmountsIn(address factory, uint amountOut, address[] memory path) internal view returns (uint[] memory amounts) {
639         require(path.length >= 2, 'UniswapV2Library: INVALID_PATH');
640         amounts = new uint[](path.length);
641         amounts[amounts.length - 1] = amountOut;
642         for (uint i = path.length - 1; i > 0; i--) {
643             (uint reserveIn, uint reserveOut) = getReserves(factory, path[i - 1], path[i]);
644             amounts[i - 1] = getAmountIn(amounts[i], reserveIn, reserveOut);
645         }
646     }
647 }
648 
649 // File: contracts/Interfaces/IUniswapV2Router01.sol
650 
651 pragma solidity >=0.5.0;
652 
653 //interface IUniswapV2Factory {
654 //  event PairCreated(address indexed token0, address indexed token1, address pair, uint);
655 //
656 //  function getPair(address tokenA, address tokenB) external view returns (address pair);
657 //  function allPairs(uint) external view returns (address pair);
658 //  function allPairsLength() external view returns (uint);
659 //
660 //  function feeTo() external view returns (address);
661 //  function feeToSetter() external view returns (address);
662 //
663 //  function createPair(address tokenA, address tokenB) external returns (address pair);
664 //}
665 //
666 //interface IUniswapV2Pair {
667 //  event Approval(address indexed owner, address indexed spender, uint value);
668 //  event Transfer(address indexed from, address indexed to, uint value);
669 //
670 //  function name() external pure returns (string memory);
671 //  function symbol() external pure returns (string memory);
672 //  function decimals() external pure returns (uint8);
673 //  function totalSupply() external view returns (uint);
674 //  function balanceOf(address owner) external view returns (uint);
675 //  function allowance(address owner, address spender) external view returns (uint);
676 //
677 //  function approve(address spender, uint value) external returns (bool);
678 //  function transfer(address to, uint value) external returns (bool);
679 //  function transferFrom(address from, address to, uint value) external returns (bool);
680 //
681 //  function DOMAIN_SEPARATOR() external view returns (bytes32);
682 //  function PERMIT_TYPEHASH() external pure returns (bytes32);
683 //  function nonces(address owner) external view returns (uint);
684 //
685 //  function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
686 //
687 //  event Mint(address indexed sender, uint amount0, uint amount1);
688 //  event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
689 //  event Swap(
690 //    address indexed sender,
691 //    uint amount0In,
692 //    uint amount1In,
693 //    uint amount0Out,
694 //    uint amount1Out,
695 //    address indexed to
696 //  );
697 //  event Sync(uint112 reserve0, uint112 reserve1);
698 //
699 //  function MINIMUM_LIQUIDITY() external pure returns (uint);
700 //  function factory() external view returns (address);
701 //  function token0() external view returns (address);
702 //  function token1() external view returns (address);
703 //  function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
704 //  function price0CumulativeLast() external view returns (uint);
705 //  function price1CumulativeLast() external view returns (uint);
706 //  function kLast() external view returns (uint);
707 //
708 //  function mint(address to) external returns (uint liquidity);
709 //  function burn(address to) external returns (uint amount0, uint amount1);
710 //  function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
711 //  function skim(address to) external;
712 //  function sync() external;
713 //}
714 
715 interface IUniswapV2Router01 {
716   function factory() external pure returns (address);
717   function WETH() external pure returns (address);
718 
719   function addLiquidity(
720     address tokenA,
721     address tokenB,
722     uint amountADesired,
723     uint amountBDesired,
724     uint amountAMin,
725     uint amountBMin,
726     address to,
727     uint deadline
728   ) external returns (uint amountA, uint amountB, uint liquidity);
729   function addLiquidityETH(
730     address token,
731     uint amountTokenDesired,
732     uint amountTokenMin,
733     uint amountETHMin,
734     address to,
735     uint deadline
736   ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
737   function removeLiquidity(
738     address tokenA,
739     address tokenB,
740     uint liquidity,
741     uint amountAMin,
742     uint amountBMin,
743     address to,
744     uint deadline
745   ) external returns (uint amountA, uint amountB);
746   function removeLiquidityETH(
747     address token,
748     uint liquidity,
749     uint amountTokenMin,
750     uint amountETHMin,
751     address to,
752     uint deadline
753   ) external returns (uint amountToken, uint amountETH);
754   function removeLiquidityWithPermit(
755     address tokenA,
756     address tokenB,
757     uint liquidity,
758     uint amountAMin,
759     uint amountBMin,
760     address to,
761     uint deadline,
762     bool approveMax, uint8 v, bytes32 r, bytes32 s
763   ) external returns (uint amountA, uint amountB);
764   function removeLiquidityETHWithPermit(
765     address token,
766     uint liquidity,
767     uint amountTokenMin,
768     uint amountETHMin,
769     address to,
770     uint deadline,
771     bool approveMax, uint8 v, bytes32 r, bytes32 s
772   ) external returns (uint amountToken, uint amountETH);
773   function swapExactTokensForTokens(
774     uint amountIn,
775     uint amountOutMin,
776     address[] calldata path,
777     address to,
778     uint deadline
779   ) external returns (uint[] memory amounts);
780   function swapTokensForExactTokens(
781     uint amountOut,
782     uint amountInMax,
783     address[] calldata path,
784     address to,
785     uint deadline
786   ) external returns (uint[] memory amounts);
787   function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
788     external
789     payable
790     returns (uint[] memory amounts);
791   function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
792     external
793     returns (uint[] memory amounts);
794   function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
795     external
796     returns (uint[] memory amounts);
797   function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
798     external
799     payable
800     returns (uint[] memory amounts);
801 
802   function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
803   function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
804   function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
805   function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
806   function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
807 }
808 
809 // File: openzeppelin-solidity/contracts/GSN/Context.sol
810 
811 pragma solidity ^0.5.0;
812 
813 /*
814  * @dev Provides information about the current execution context, including the
815  * sender of the transaction and its data. While these are generally available
816  * via msg.sender and msg.data, they should not be accessed in such a direct
817  * manner, since when dealing with GSN meta-transactions the account sending and
818  * paying for execution may not be the actual sender (as far as an application
819  * is concerned).
820  *
821  * This contract is only required for intermediate, library-like contracts.
822  */
823 contract Context {
824     // Empty internal constructor, to prevent people from mistakenly deploying
825     // an instance of this contract, which should be used via inheritance.
826     constructor () internal { }
827     // solhint-disable-previous-line no-empty-blocks
828 
829     function _msgSender() internal view returns (address payable) {
830         return msg.sender;
831     }
832 
833     function _msgData() internal view returns (bytes memory) {
834         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
835         return msg.data;
836     }
837 }
838 
839 // File: openzeppelin-solidity/contracts/Ownership/Ownable.sol
840 
841 pragma solidity ^0.5.0;
842 
843 /**
844  * @dev Contract module which provides a basic access control mechanism, where
845  * there is an account (an owner) that can be granted exclusive access to
846  * specific functions.
847  *
848  * This module is used through inheritance. It will make available the modifier
849  * `onlyOwner`, which can be applied to your functions to restrict their use to
850  * the owner.
851  */
852 contract Ownable is Context {
853     address private _owner;
854 
855     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
856 
857     /**
858      * @dev Initializes the contract setting the deployer as the initial owner.
859      */
860     constructor () internal {
861         address msgSender = _msgSender();
862         _owner = msgSender;
863         emit OwnershipTransferred(address(0), msgSender);
864     }
865 
866     /**
867      * @dev Returns the address of the current owner.
868      */
869     function owner() public view returns (address) {
870         return _owner;
871     }
872 
873     /**
874      * @dev Throws if called by any account other than the owner.
875      */
876     modifier onlyOwner() {
877         require(isOwner(), "Ownable: caller is not the owner");
878         _;
879     }
880 
881     /**
882      * @dev Returns true if the caller is the current owner.
883      */
884     function isOwner() public view returns (bool) {
885         return _msgSender() == _owner;
886     }
887 
888     /**
889      * @dev Leaves the contract without owner. It will not be possible to call
890      * `onlyOwner` functions anymore. Can only be called by the current owner.
891      *
892      * NOTE: Renouncing ownership will leave the contract without an owner,
893      * thereby removing any functionality that is only available to the owner.
894      */
895     function renounceOwnership() public onlyOwner {
896         emit OwnershipTransferred(_owner, address(0));
897         _owner = address(0);
898     }
899 
900     /**
901      * @dev Transfers ownership of the contract to a new account (`newOwner`).
902      * Can only be called by the current owner.
903      */
904     function transferOwnership(address newOwner) public onlyOwner {
905         _transferOwnership(newOwner);
906     }
907 
908     /**
909      * @dev Transfers ownership of the contract to a new account (`newOwner`).
910      */
911     function _transferOwnership(address newOwner) internal {
912         require(newOwner != address(0), "Ownable: new owner is the zero address");
913         emit OwnershipTransferred(_owner, newOwner);
914         _owner = newOwner;
915     }
916 }
917 
918 // File: contracts/Utils/Destructible.sol
919 
920 pragma solidity >=0.5.0;
921 
922 
923 /**
924  * @title Destructible
925  * @dev Base contract that can be destroyed by owner. All funds in contract will be sent to the owner.
926  */
927 contract Destructible is Ownable {
928   /**
929    * @dev Transfers the current balance to the owner and terminates the contract.
930    */
931   function destroy() public onlyOwner {
932     selfdestruct(address(bytes20(owner())));
933   }
934 
935   function destroyAndSend(address payable _recipient) public onlyOwner {
936     selfdestruct(_recipient);
937   }
938 }
939 
940 // File: contracts/Utils/Pausable.sol
941 
942 pragma solidity >=0.4.24;
943 
944 
945 /**
946  * @title Pausable
947  * @dev Base contract which allows children to implement an emergency stop mechanism.
948  */
949 contract Pausable is Ownable {
950   event Pause();
951   event Unpause();
952 
953   bool public paused = false;
954 
955 
956   /**
957    * @dev Modifier to make a function callable only when the contract is not paused.
958    */
959   modifier whenNotPaused() {
960     require(!paused, "The contract is paused");
961     _;
962   }
963 
964   /**
965    * @dev Modifier to make a function callable only when the contract is paused.
966    */
967   modifier whenPaused() {
968     require(paused, "The contract is not paused");
969     _;
970   }
971 
972   /**
973    * @dev called by the owner to pause, triggers stopped state
974    */
975   function pause() public onlyOwner whenNotPaused {
976     paused = true;
977     emit Pause();
978   }
979 
980   /**
981    * @dev called by the owner to unpause, returns to normal state
982    */
983   function unpause() public onlyOwner whenPaused {
984     paused = false;
985     emit Unpause();
986   }
987 }
988 
989 // File: contracts/Utils/Withdrawable.sol
990 
991 pragma solidity >=0.4.24;
992 
993 
994 
995 
996 
997 contract Withdrawable is Ownable {
998   using SafeERC20 for IERC20;
999   address constant ETHER = address(0);
1000 
1001   event LogWithdrawToken(
1002     address indexed _from,
1003     address indexed _token,
1004     uint amount
1005   );
1006 
1007   /**
1008    * @dev Withdraw asset.
1009    * @param _tokenAddress Asset to be withdrawed.
1010    */
1011   function withdrawAll(address _tokenAddress) public onlyOwner {
1012     uint tokenBalance;
1013     if (_tokenAddress == ETHER) {
1014       address self = address(this); // workaround for a possible solidity bug
1015       tokenBalance = self.balance;
1016     } else {
1017       tokenBalance = IBadStaticCallERC20(_tokenAddress).balanceOf(address(this));
1018     }
1019     _withdraw(_tokenAddress, tokenBalance);
1020   }
1021 
1022   function _withdraw(address _tokenAddress, uint _amount) internal {
1023     if (_tokenAddress == ETHER) {
1024       msg.sender.transfer(_amount);
1025     } else {
1026       IERC20(_tokenAddress).safeTransfer(msg.sender, _amount);
1027     }
1028     emit LogWithdrawToken(msg.sender, _tokenAddress, _amount);
1029   }
1030 
1031 }
1032 
1033 // File: contracts/Utils/WithFee.sol
1034 
1035 pragma solidity ^0.5.0;
1036 
1037 
1038 
1039 
1040 
1041 contract WithFee is Ownable {
1042   using SafeERC20 for IERC20;
1043   using SafeMath for uint;
1044   address payable public feeWallet;
1045   uint public storedSpread;
1046   uint constant spreadDecimals = 6;
1047   uint constant spreadUnit = 10 ** spreadDecimals;
1048 
1049   event LogFee(address token, uint amount);
1050 
1051   constructor(address payable _wallet, uint _spread) public {
1052     require(_wallet != address(0), "_wallet == address(0)");
1053     require(_spread < spreadUnit, "spread >= spreadUnit");
1054     feeWallet = _wallet;
1055     storedSpread = _spread;
1056   }
1057 
1058   function setFeeWallet(address payable _wallet) external onlyOwner {
1059     require(_wallet != address(0), "_wallet == address(0)");
1060     feeWallet = _wallet;
1061   }
1062 
1063   function setSpread(uint _spread) external onlyOwner {
1064     storedSpread = _spread;
1065   }
1066 
1067   function _getFee(uint underlyingTokenTotal) internal view returns(uint) {
1068     return underlyingTokenTotal.mul(storedSpread).div(spreadUnit);
1069   }
1070 
1071   function _payFee(address feeToken, uint fee) internal {
1072     if (fee > 0) {
1073       if (feeToken == address(0)) {
1074         feeWallet.transfer(fee);
1075       } else {
1076         IERC20(feeToken).safeTransfer(feeWallet, fee);
1077       }
1078       emit LogFee(feeToken, fee);
1079     }
1080   }
1081 
1082 }
1083 
1084 // File: contracts/Interfaces/IErc20Swap.sol
1085 
1086 pragma solidity >=0.4.0;
1087 
1088 interface IErc20Swap {
1089     function getRate(address src, address dst, uint256 srcAmount) external view returns(uint expectedRate, uint slippageRate);  // real rate = returned value / 1e18
1090     function swap(address src, uint srcAmount, address dest, uint maxDestAmount, uint minConversionRate) external payable;
1091 
1092     event LogTokenSwap(
1093         address indexed _userAddress,
1094         address indexed _userSentTokenAddress,
1095         uint _userSentTokenAmount,
1096         address indexed _userReceivedTokenAddress,
1097         uint _userReceivedTokenAmount
1098     );
1099 }
1100 
1101 // File: contracts/base/NetworkBasedTokenSwap.sol
1102 
1103 pragma solidity >=0.5.0;
1104 
1105 
1106 
1107 
1108 
1109 
1110 
1111 
1112 
1113 
1114 contract NetworkBasedTokenSwap is Withdrawable, Pausable, Destructible, WithFee, IErc20Swap
1115 {
1116   using SafeMath for uint;
1117   using SafeERC20 for IERC20;
1118   address constant ETHER = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
1119 
1120   mapping (address => mapping (address => uint)) spreadCustom;
1121 
1122   event UnexpectedIntialBalance(address token, uint amount);
1123 
1124   constructor(
1125     address payable _wallet,
1126     uint _spread
1127   )
1128     public WithFee(_wallet, _spread)
1129   {}
1130 
1131   function() external payable {
1132     // can receive ethers
1133   }
1134 
1135   // spread value >= spreadUnit means no fee
1136   function setSpread(address tokenA, address tokenB, uint spread) public onlyOwner {
1137     uint value = spread > spreadUnit ? spreadUnit : spread;
1138     spreadCustom[tokenA][tokenB] = value;
1139     spreadCustom[tokenB][tokenA] = value;
1140   }
1141 
1142   function getSpread(address tokenA, address tokenB) public view returns(uint) {
1143     uint value = spreadCustom[tokenA][tokenB];
1144     if (value == 0) return storedSpread;
1145     if (value >= spreadUnit) return 0;
1146     else return value;
1147   }
1148 
1149   // kyber network style rate
1150   function getNetworkRate(address src, address dest, uint256 srcAmount) internal view returns(uint expectedRate, uint slippageRate);
1151 
1152   function getRate(address src, address dest, uint256 srcAmount) external view
1153     returns(uint expectedRate, uint slippageRate)
1154   {
1155     (uint256 kExpected, uint256 kSplippage) = getNetworkRate(src, dest, srcAmount);
1156     uint256 spread = getSpread(src, dest);
1157     expectedRate = kExpected.mul(spreadUnit - spread).div(spreadUnit);
1158     slippageRate = kSplippage.mul(spreadUnit - spread).div(spreadUnit);
1159   }
1160 
1161   function _freeUnexpectedTokens(address token) private {
1162     uint256 unexpectedBalance = token == ETHER
1163       ? _myEthBalance().sub(msg.value)
1164       : IBadStaticCallERC20(token).balanceOf(address(this));
1165     if (unexpectedBalance > 0) {
1166       _transfer(token, address(bytes20(owner())), unexpectedBalance);
1167       emit UnexpectedIntialBalance(token, unexpectedBalance);
1168     }
1169   }
1170 
1171   function swap(address src, uint srcAmount, address dest, uint maxDestAmount, uint minConversionRate) public payable {
1172     require(src != dest, "src == dest");
1173     require(srcAmount > 0, "srcAmount == 0");
1174 
1175     // empty unexpected initial balances
1176     _freeUnexpectedTokens(src);
1177     _freeUnexpectedTokens(dest);
1178 
1179     if (src == ETHER) {
1180       require(msg.value == srcAmount, "msg.value != srcAmount");
1181     } else {
1182       require(
1183         IBadStaticCallERC20(src).allowance(msg.sender, address(this)) >= srcAmount,
1184         "ERC20 allowance < srcAmount"
1185       );
1186       // get user's tokens
1187       IERC20(src).safeTransferFrom(msg.sender, address(this), srcAmount);
1188     }
1189 
1190     uint256 spread = getSpread(src, dest);
1191 
1192     // calculate the minConversionRate and maxDestAmount keeping in mind the fee
1193     uint256 adaptedMinRate = minConversionRate.mul(spreadUnit).div(spreadUnit - spread);
1194     uint256 adaptedMaxDestAmount = maxDestAmount.mul(spreadUnit).div(spreadUnit - spread);
1195     uint256 destTradedAmount = doNetworkTrade(src, srcAmount, dest, adaptedMaxDestAmount, adaptedMinRate);
1196 
1197     uint256 notTraded = _myBalance(src);
1198     uint256 srcTradedAmount = srcAmount.sub(notTraded);
1199     require(srcTradedAmount > 0, "no traded tokens");
1200     require(
1201       _myBalance(dest) >= destTradedAmount,
1202       "No enough dest tokens after trade"
1203     );
1204     // pay fee and user
1205     uint256 toUserAmount = _payFee(dest, destTradedAmount, spread);
1206     _transfer(dest, msg.sender, toUserAmount);
1207     // returns not traded tokens if any
1208     if (notTraded > 0) {
1209       _transfer(src, msg.sender, notTraded);
1210     }
1211 
1212     emit LogTokenSwap(
1213       msg.sender,
1214       src,
1215       srcTradedAmount,
1216       dest,
1217       toUserAmount
1218     );
1219   }
1220 
1221   function doNetworkTrade(address src, uint srcAmount, address dest, uint maxDestAmount, uint minConversionRate) internal returns(uint256);
1222 
1223   function _payFee(address token, uint destTradedAmount, uint spread) private returns(uint256 toUserAmount) {
1224     uint256 fee = destTradedAmount.mul(spread).div(spreadUnit);
1225     toUserAmount = destTradedAmount.sub(fee);
1226     // pay fee
1227     super._payFee(token == ETHER ? address(0) : token, fee);
1228   }
1229 
1230   // workaround for a solidity bug
1231   function _myEthBalance() private view returns(uint256) {
1232     address self = address(this);
1233     return self.balance;
1234   }
1235 
1236   function _myBalance(address token) private returns(uint256) {
1237     return token == ETHER
1238       ? _myEthBalance()
1239       : IBadStaticCallERC20(token).balanceOf(address(this));
1240   }
1241 
1242   function _transfer(address token, address payable recipient, uint256 amount) private {
1243     if (token == ETHER) {
1244       recipient.transfer(amount);
1245     } else {
1246       IERC20(token).safeTransfer(recipient, amount);
1247     }
1248   }
1249 
1250 }
1251 
1252 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Detailed.sol
1253 
1254 pragma solidity ^0.5.0;
1255 
1256 
1257 /**
1258  * @dev Optional functions from the ERC20 standard.
1259  */
1260 contract ERC20Detailed is IERC20 {
1261     string private _name;
1262     string private _symbol;
1263     uint8 private _decimals;
1264 
1265     /**
1266      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
1267      * these values are immutable: they can only be set once during
1268      * construction.
1269      */
1270     constructor (string memory name, string memory symbol, uint8 decimals) public {
1271         _name = name;
1272         _symbol = symbol;
1273         _decimals = decimals;
1274     }
1275 
1276     /**
1277      * @dev Returns the name of the token.
1278      */
1279     function name() public view returns (string memory) {
1280         return _name;
1281     }
1282 
1283     /**
1284      * @dev Returns the symbol of the token, usually a shorter version of the
1285      * name.
1286      */
1287     function symbol() public view returns (string memory) {
1288         return _symbol;
1289     }
1290 
1291     /**
1292      * @dev Returns the number of decimals used to get its user representation.
1293      * For example, if `decimals` equals `2`, a balance of `505` tokens should
1294      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
1295      *
1296      * Tokens usually opt for a value of 18, imitating the relationship between
1297      * Ether and Wei.
1298      *
1299      * NOTE: This information is only used for _display_ purposes: it in
1300      * no way affects any of the arithmetic of the contract, including
1301      * {IERC20-balanceOf} and {IERC20-transfer}.
1302      */
1303     function decimals() public view returns (uint8) {
1304         return _decimals;
1305     }
1306 }
1307 
1308 // File: contracts/Utils/LowLevel.sol
1309 
1310 pragma solidity ^0.5.0;
1311 
1312 library LowLevel {
1313   function staticCallContractAddr(address target, bytes memory payload) internal view
1314     returns (bool success_, address result_)
1315   {
1316     (bool success, bytes memory result) = address(target).staticcall(payload);
1317     if (success && result.length == 32) {
1318       return (true, abi.decode(result, (address)));
1319     }
1320     return (false, address(0));
1321   }
1322 
1323   function callContractAddr(address target, bytes memory payload) internal
1324     returns (bool success_, address result_)
1325   {
1326     (bool success, bytes memory result) = address(target).call(payload);
1327     if (success && result.length == 32) {
1328       return (true, abi.decode(result, (address)));
1329     }
1330     return (false, address(0));
1331   }
1332 
1333   function staticCallContractUint(address target, bytes memory payload) internal view
1334     returns (bool success_, uint result_)
1335   {
1336     (bool success, bytes memory result) = address(target).staticcall(payload);
1337     if (success && result.length == 32) {
1338       return (true, abi.decode(result, (uint)));
1339     }
1340     return (false, 0);
1341   }
1342 
1343   function callContractUint(address target, bytes memory payload) internal
1344     returns (bool success_, uint result_)
1345   {
1346     (bool success, bytes memory result) = address(target).call(payload);
1347     if (success && result.length == 32) {
1348       return (true, abi.decode(result, (uint)));
1349     }
1350     return (false, 0);
1351   }
1352 }
1353 
1354 // File: contracts/Utils/RateNormalization.sol
1355 
1356 pragma solidity ^0.5.0;
1357 
1358 
1359 
1360 
1361 
1362 contract RateNormalization is Ownable {
1363   using SafeMath for uint;
1364 
1365   struct RateAdjustment {
1366     uint factor;
1367     bool multiply;
1368   }
1369 
1370   mapping (address => mapping(address => RateAdjustment)) public rateAdjustment;
1371   mapping (address => uint) public forcedDecimals;
1372 
1373   function _getAdjustment(address src, address dest) private view returns(RateAdjustment memory) {
1374     RateAdjustment memory adj = rateAdjustment[src][dest];
1375     if (adj.factor == 0) {
1376       uint srcDecimals = _getDecimals(src);
1377       uint destDecimals = _getDecimals(dest);
1378       if (srcDecimals != destDecimals) {
1379         if (srcDecimals > destDecimals) {
1380           adj.multiply = true;
1381           adj.factor = 10 ** (srcDecimals - destDecimals);
1382         } else {
1383           adj.multiply = false;
1384           adj.factor = 10 ** (destDecimals - srcDecimals);
1385         }
1386       }
1387     }
1388     return adj;
1389   }
1390 
1391   // return normalized rate
1392   function normalizeRate(address src, address dest, uint256 rate) public view
1393     returns(uint)
1394   {
1395     RateAdjustment memory adj = _getAdjustment(src, dest);
1396     if (adj.factor > 1) {
1397       rate = adj.multiply
1398         ? rate.mul(adj.factor)
1399         : rate.div(adj.factor);
1400     }
1401     return rate;
1402   }
1403 
1404   function denormalizeRate(address src, address dest, uint256 rate) public view
1405     returns(uint)
1406   {
1407     RateAdjustment memory adj = _getAdjustment(src, dest);
1408     if (adj.factor > 1) {
1409       rate = adj.multiply  // invert multiply/divide for denormalization
1410         ? rate.div(adj.factor)
1411         : rate.mul(adj.factor);
1412     }
1413     return rate;
1414   }
1415 
1416   function denormalizeRate(address src, address dest, uint256 rate, uint256 slippage) public view
1417     returns(uint, uint)
1418   {
1419     RateAdjustment memory adj = _getAdjustment(src, dest);
1420     if (adj.factor > 1) {
1421       if (adj.multiply) {
1422         rate = rate.div(adj.factor);
1423         slippage = slippage.div(adj.factor);
1424       } else {
1425         rate = rate.mul(adj.factor);
1426         slippage = slippage.mul(adj.factor);
1427       }
1428     }
1429     return (rate, slippage);
1430   }
1431 
1432   function _getDecimals(address token) internal view returns(uint) {
1433     uint forced = forcedDecimals[token];
1434     if (forced > 0) return forced;
1435     bytes memory payload = abi.encodeWithSignature("decimals()");
1436     (bool success, uint decimals) = LowLevel.staticCallContractUint(token, payload);
1437     require(success, "the token doesn't expose the decimals number");
1438     return decimals;
1439   }
1440 
1441   function setRateAdjustmentFactor(address src, address dest, uint factor, bool multiply) public onlyOwner {
1442     rateAdjustment[src][dest] = RateAdjustment(factor, multiply);
1443     rateAdjustment[dest][src] = RateAdjustment(factor, !multiply);
1444   }
1445 
1446   function setForcedDecimals(address token, uint decimals) public onlyOwner {
1447     forcedDecimals[token] = decimals;
1448   }
1449 
1450 }
1451 
1452 // File: contracts/UniswapV2TokenSwap.sol
1453 
1454 pragma solidity >=0.5.0;
1455 
1456 
1457 
1458 
1459 
1460 
1461 
1462 
1463 
1464 
1465 
1466 
1467 
1468 contract UniswapV2TokenSwap is RateNormalization, NetworkBasedTokenSwap
1469 {
1470   using SafeMath for uint;
1471   using SafeERC20 for IERC20;
1472   using SafeStaticCallERC20 for IBadStaticCallERC20;
1473   uint constant expScale = 1e18;
1474 
1475   IUniswapV2Factory public uniswapFactory;
1476   IUniswapV2Router01 public router;
1477 
1478   constructor(
1479     address payable _wallet,
1480     uint _spread
1481   )
1482     public NetworkBasedTokenSwap(_wallet, _spread)
1483   {
1484     setForcedDecimals(ETHER, 18);
1485     // the router address is deterministic and it is the same in all networks
1486     setUniswap(0xf164fC0Ec4E93095b804a4795bBe1e041497b92a);
1487   }
1488 
1489   function setUniswap(address _uniswapRouter) public onlyOwner {
1490     require(_uniswapRouter != address(0), "_uniswapRouter == address(0)");
1491     router = IUniswapV2Router01(_uniswapRouter);
1492     uniswapFactory = IUniswapV2Factory(router.factory());
1493   }
1494 
1495   function _getUniswapRate(address[] memory path, uint srcAmount) private view returns(uint rate, uint destAmount) {
1496     uint[] memory amounts = UniswapV2Library.getAmountsOut(address(uniswapFactory), srcAmount, path);
1497     destAmount = amounts[amounts.length - 1];
1498 //    rate = destAmount.mul(expScale).div(srcAmount);
1499     rate = _calcRate(srcAmount, destAmount);
1500   }
1501 
1502   function _getPath(address srcToken, address destToken) internal view returns(address[] memory res) {
1503     address WETH = router.WETH();
1504     address from = srcToken == ETHER ? WETH : srcToken;
1505     address to = destToken == ETHER ? WETH : destToken;
1506     if (uniswapFactory.getPair(from, to) != address(0)) {
1507       res = new address[](2);
1508       res[0] = from;
1509       res[1] = to;
1510     } else if (
1511       uniswapFactory.getPair(from, WETH) != address(0) &&
1512       uniswapFactory.getPair(WETH, to) != address(0)
1513     ) {
1514       res = new address[](3);
1515       res[0] = from;
1516       res[1] = WETH;
1517       res[2] = to;
1518     } else {
1519       res = new address[](0);
1520     }
1521   }
1522 
1523   function _calcRate(uint srcAmount, uint destAmount) private pure returns(uint) {
1524     return destAmount.mul(expScale).div(srcAmount);
1525   }
1526 
1527   function getNetworkRate(address src, address dest, uint256 srcAmount) internal view
1528     returns(uint expectedRate, uint slippageRate)
1529   {
1530     address[] memory path = _getPath(src, dest);
1531     (uint rate, ) = _getUniswapRate(path, srcAmount);
1532     uint normalizedRate = normalizeRate(src, dest, rate);
1533     return (normalizedRate, normalizedRate);
1534   }
1535 
1536   function _approveWithReset(address token, address spender, uint amount) private {
1537     if (IBadStaticCallERC20(token).allowance(address(this), spender) > 0) {
1538       IBadStaticCallERC20(token).safeApprove(spender, 0);
1539     }
1540     IBadStaticCallERC20(token).safeApprove(spender, amount);
1541   }
1542 
1543   function doNetworkTrade(address src, uint srcAmount, address dest, uint maxDestAmount, uint minConversionRate)
1544     internal returns(uint256)
1545   {
1546     address[] memory path = _getPath(src, dest);
1547     (uint rate, uint destAmount) = _getUniswapRate(path, srcAmount);
1548     uint toTradeAmount = destAmount > maxDestAmount
1549       ? maxDestAmount.mul(expScale).div(rate)
1550       : srcAmount;
1551 
1552     // convert source ethers to WETHs
1553     if (src == ETHER) {
1554       IWETH(router.WETH()).deposit.value(toTradeAmount)();
1555     }
1556 
1557     _approveWithReset(path[0], address(router), toTradeAmount);
1558     uint[] memory amounts = router.swapExactTokensForTokens(toTradeAmount, 0, path, address(this), now);
1559     require(amounts.length > 0, 'amounts.length == 0');
1560     uint finalDestAmount = amounts[amounts.length - 1];
1561 
1562     // convert WETHs to ethers
1563     if (dest == ETHER) {
1564       IWETH(router.WETH()).withdraw(finalDestAmount);
1565     }
1566 
1567     require(normalizeRate(src, dest, _calcRate(toTradeAmount, finalDestAmount)) >= minConversionRate, "cannot satisfy minConversionRate");
1568     return finalDestAmount;
1569   }
1570 
1571 }
1572 
1573 // File: contracts/UniswapV2DoubleHop.sol
1574 
1575 pragma solidity >=0.5.0;
1576 
1577 
1578 
1579 
1580 
1581 
1582 
1583 contract UniswapV2DoubleHop is UniswapV2TokenSwap
1584 {
1585   using SafeMath for uint;
1586   using SafeERC20 for IERC20;
1587   using SafeStaticCallERC20 for IBadStaticCallERC20;
1588   uint constant expScale = 1e18;
1589 
1590   address public middleToken;
1591 
1592   constructor(
1593     address _middleToken,
1594     address payable _wallet,
1595     uint _spread
1596   )
1597     public UniswapV2TokenSwap(_wallet, _spread)
1598   {
1599     middleToken = _middleToken;
1600   }
1601 
1602   function setMiddleToken(address _middleToken) public onlyOwner {
1603     middleToken = _middleToken;
1604   }
1605 
1606   function _getPath(address srcToken, address destToken) internal view returns(address[] memory res) {
1607     address WETH = router.WETH();
1608     address from = srcToken == ETHER ? WETH : srcToken;
1609     address to = destToken == ETHER ? WETH : destToken;
1610 
1611     if (uniswapFactory.getPair(from, middleToken) != address(0) &&
1612         uniswapFactory.getPair(middleToken, to) != address(0)
1613     ) {
1614       res = new address[](3);
1615       res[0] = from;
1616       res[1] = middleToken;
1617       res[2] = to;
1618     } else {
1619       res = new address[](0);
1620     }
1621   }
1622 
1623 }