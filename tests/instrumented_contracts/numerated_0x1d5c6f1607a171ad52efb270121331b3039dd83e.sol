1 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity ^0.6.0;
6 
7 /**
8  * @dev Interface of the ERC20 standard as defined in the EIP.
9  */
10 interface IERC20 {
11     /**
12      * @dev Returns the amount of tokens in existence.
13      */
14     function totalSupply() external view returns (uint256);
15 
16     /**
17      * @dev Returns the amount of tokens owned by `account`.
18      */
19     function balanceOf(address account) external view returns (uint256);
20 
21     /**
22      * @dev Moves `amount` tokens from the caller's account to `recipient`.
23      *
24      * Returns a boolean value indicating whether the operation succeeded.
25      *
26      * Emits a {Transfer} event.
27      */
28     function transfer(address recipient, uint256 amount) external returns (bool);
29 
30     /**
31      * @dev Returns the remaining number of tokens that `spender` will be
32      * allowed to spend on behalf of `owner` through {transferFrom}. This is
33      * zero by default.
34      *
35      * This value changes when {approve} or {transferFrom} are called.
36      */
37     function allowance(address owner, address spender) external view returns (uint256);
38 
39     /**
40      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
41      *
42      * Returns a boolean value indicating whether the operation succeeded.
43      *
44      * IMPORTANT: Beware that changing an allowance with this method brings the risk
45      * that someone may use both the old and the new allowance by unfortunate
46      * transaction ordering. One possible solution to mitigate this race
47      * condition is to first reduce the spender's allowance to 0 and set the
48      * desired value afterwards:
49      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
50      *
51      * Emits an {Approval} event.
52      */
53     function approve(address spender, uint256 amount) external returns (bool);
54 
55     /**
56      * @dev Moves `amount` tokens from `sender` to `recipient` using the
57      * allowance mechanism. `amount` is then deducted from the caller's
58      * allowance.
59      *
60      * Returns a boolean value indicating whether the operation succeeded.
61      *
62      * Emits a {Transfer} event.
63      */
64     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
65 
66     /**
67      * @dev Emitted when `value` tokens are moved from one account (`from`) to
68      * another (`to`).
69      *
70      * Note that `value` may be zero.
71      */
72     event Transfer(address indexed from, address indexed to, uint256 value);
73 
74     /**
75      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
76      * a call to {approve}. `value` is the new allowance.
77      */
78     event Approval(address indexed owner, address indexed spender, uint256 value);
79 }
80 
81 // File: @openzeppelin/contracts/math/SafeMath.sol
82 
83 
84 pragma solidity ^0.6.0;
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
242 // File: contracts/uniswapv2/interfaces/IUniswapV2Pair.sol
243 
244 pragma solidity >=0.5.0;
245 
246 interface IUniswapV2Pair {
247     event Approval(address indexed owner, address indexed spender, uint value);
248     event Transfer(address indexed from, address indexed to, uint value);
249 
250     function name() external pure returns (string memory);
251     function symbol() external pure returns (string memory);
252     function decimals() external pure returns (uint8);
253     function totalSupply() external view returns (uint);
254     function balanceOf(address owner) external view returns (uint);
255     function allowance(address owner, address spender) external view returns (uint);
256 
257     function approve(address spender, uint value) external returns (bool);
258     function transfer(address to, uint value) external returns (bool);
259     function transferFrom(address from, address to, uint value) external returns (bool);
260 
261     function DOMAIN_SEPARATOR() external view returns (bytes32);
262     function PERMIT_TYPEHASH() external pure returns (bytes32);
263     function nonces(address owner) external view returns (uint);
264 
265     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
266 
267     event Mint(address indexed sender, uint amount0, uint amount1);
268     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
269     event Swap(
270         address indexed sender,
271         uint amount0In,
272         uint amount1In,
273         uint amount0Out,
274         uint amount1Out,
275         address indexed to
276     );
277     event Sync(uint112 reserve0, uint112 reserve1);
278 
279     function MINIMUM_LIQUIDITY() external pure returns (uint);
280     function factory() external view returns (address);
281     function token0() external view returns (address);
282     function token1() external view returns (address);
283     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
284     function price0CumulativeLast() external view returns (uint);
285     function price1CumulativeLast() external view returns (uint);
286     function kLast() external view returns (uint);
287 
288     function mint(address to) external returns (uint liquidity);
289     function burn(address to) external returns (uint amount0, uint amount1);
290     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
291     function skim(address to) external;
292     function sync() external;
293 
294     function initialize(address, address) external;
295 }
296 
297 // File: contracts/uniswapv2/interfaces/IUniswapV2Factory.sol
298 
299 pragma solidity >=0.5.0;
300 
301 interface IUniswapV2Factory {
302     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
303 
304     function feeTo() external view returns (address);
305     function withdrawFeeTo() external view returns (address);
306     function swapFee() external view returns (uint);
307     function withdrawFee() external view returns (uint);
308     
309     function feeSetter() external view returns (address);
310     function migrator() external view returns (address);
311 
312     function getPair(address tokenA, address tokenB) external view returns (address pair);
313     function allPairs(uint) external view returns (address pair);
314     function allPairsLength() external view returns (uint);
315 
316     function createPair(address tokenA, address tokenB) external returns (address pair);
317 
318     function setFeeTo(address) external;
319     function setWithdrawFeeTo(address) external;
320     function setSwapFee(uint) external;
321     function setFeeSetter(address) external;
322     function setMigrator(address) external;
323 }
324 
325 // File: contracts/uniswapv2/libraries/UniswapV2Library.sol
326 
327 pragma solidity >=0.5.0;
328 
329 
330 
331 
332 
333 library UniswapV2Library {
334     using SafeMath for uint;
335 
336     // returns sorted token addresses, used to handle return values from pairs sorted in this order
337     function sortTokens(address tokenA, address tokenB) internal pure returns (address token0, address token1) {
338         require(tokenA != tokenB, 'UniswapV2Library: IDENTICAL_ADDRESSES');
339         (token0, token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
340         require(token0 != address(0), 'UniswapV2Library: ZERO_ADDRESS');
341     }
342 
343     function pairFor(address factory, address tokenA, address tokenB) internal view returns (address pair) {
344         return IUniswapV2Factory(factory).getPair(tokenA, tokenB);
345     }
346 
347     // fetches and sorts the reserves for a pair
348     function getReserves(address factory, address tokenA, address tokenB) internal view returns (uint reserveA, uint reserveB) {
349         (address token0,) = sortTokens(tokenA, tokenB);
350         address pair = pairFor(factory, tokenA, tokenB);
351         (uint reserve0, uint reserve1,) = IUniswapV2Pair(pair).getReserves();
352         (reserveA, reserveB) = tokenA == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
353     }
354 
355     // given some amount of an asset and pair reserves, returns an equivalent amount of the other asset
356     function quote(uint amountA, uint reserveA, uint reserveB) internal pure returns (uint amountB) {
357         require(amountA > 0, 'UniswapV2Library: INSUFFICIENT_AMOUNT');
358         require(reserveA > 0 && reserveB > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
359         amountB = amountA.mul(reserveB) / reserveA;
360     }
361 
362     // given an input amount of an asset and pair reserves, returns the maximum output amount of the other asset
363     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut, uint swapFee) internal pure returns (uint amountOut) {
364         require(amountIn > 0, 'UniswapV2Library: INSUFFICIENT_INPUT_AMOUNT');
365         require(reserveIn > 0 && reserveOut > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
366         uint amountInWithFee = amountIn.mul(1000 - swapFee);
367         uint numerator = amountInWithFee.mul(reserveOut);
368         uint denominator = reserveIn.mul(1000).add(amountInWithFee);
369         amountOut = numerator / denominator;
370     }
371 
372     // given an output amount of an asset and pair reserves, returns a required input amount of the other asset
373     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut, uint swapFee) internal pure returns (uint amountIn) {
374         require(amountOut > 0, 'UniswapV2Library: INSUFFICIENT_OUTPUT_AMOUNT');
375         require(reserveIn > 0 && reserveOut > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
376         uint numerator = reserveIn.mul(amountOut).mul(1000);
377         uint denominator = reserveOut.sub(amountOut).mul(1000 - swapFee);
378         amountIn = (numerator / denominator).add(1);
379     }
380 
381     // performs chained getAmountOut calculations on any number of pairs
382     function getAmountsOut(address factory, uint amountIn, address[] memory path, uint swapFee) internal view returns (uint[] memory amounts) {
383         require(path.length >= 2, 'UniswapV2Library: INVALID_PATH');
384         amounts = new uint[](path.length);
385         amounts[0] = amountIn;
386         for (uint i; i < path.length - 1; i++) {
387             (uint reserveIn, uint reserveOut) = getReserves(factory, path[i], path[i + 1]);
388             amounts[i + 1] = getAmountOut(amounts[i], reserveIn, reserveOut, swapFee);
389         }
390     }
391 
392     // performs chained getAmountIn calculations on any number of pairs
393     function getAmountsIn(address factory, uint amountOut, address[] memory path, uint swapFee) internal view returns (uint[] memory amounts) {
394         require(path.length >= 2, 'UniswapV2Library: INVALID_PATH');
395         amounts = new uint[](path.length);
396         amounts[amounts.length - 1] = amountOut;
397         for (uint i = path.length - 1; i > 0; i--) {
398             (uint reserveIn, uint reserveOut) = getReserves(factory, path[i - 1], path[i]);
399             amounts[i - 1] = getAmountIn(amounts[i], reserveIn, reserveOut, swapFee);
400         }
401     }
402 }
403 
404 // File: contracts/uniswapv2/libraries/TransferHelper.sol
405 
406 pragma solidity >=0.6.0;
407 
408 // helper methods for interacting with ERC20 tokens and sending ETH that do not consistently return true/false
409 library TransferHelper {
410     function safeApprove(address token, address to, uint value) internal {
411         // bytes4(keccak256(bytes('approve(address,uint256)')));
412         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x095ea7b3, to, value));
413         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: APPROVE_FAILED');
414     }
415 
416     function safeTransfer(address token, address to, uint value) internal {
417         // bytes4(keccak256(bytes('transfer(address,uint256)')));
418         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));
419         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FAILED');
420     }
421 
422     function safeTransferFrom(address token, address from, address to, uint value) internal {
423         // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
424         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));
425         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FROM_FAILED');
426     }
427 
428     function safeTransferETH(address to, uint value) internal {
429         (bool success,) = to.call{value:value}(new bytes(0));
430         require(success, 'TransferHelper: ETH_TRANSFER_FAILED');
431     }
432 }
433 
434 // File: contracts/uniswapv2/interfaces/IUniswapV2Router01.sol
435 
436 pragma solidity >=0.6.2;
437 
438 interface IUniswapV2Router01 {
439     function factory() external pure returns (address);
440     function WETH() external pure returns (address);
441 
442     function addLiquidity(
443         address tokenA,
444         address tokenB,
445         uint amountADesired,
446         uint amountBDesired,
447         uint amountAMin,
448         uint amountBMin,
449         address to,
450         uint deadline
451     ) external returns (uint amountA, uint amountB, uint liquidity);
452     function addLiquidityETH(
453         address token,
454         uint amountTokenDesired,
455         uint amountTokenMin,
456         uint amountETHMin,
457         address to,
458         uint deadline
459     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
460     function removeLiquidity(
461         address tokenA,
462         address tokenB,
463         uint liquidity,
464         uint amountAMin,
465         uint amountBMin,
466         address to,
467         uint deadline
468     ) external returns (uint amountA, uint amountB);
469     function removeLiquidityETH(
470         address token,
471         uint liquidity,
472         uint amountTokenMin,
473         uint amountETHMin,
474         address to,
475         uint deadline
476     ) external returns (uint amountToken, uint amountETH);
477     function removeLiquidityWithPermit(
478         address tokenA,
479         address tokenB,
480         uint liquidity,
481         uint amountAMin,
482         uint amountBMin,
483         address to,
484         uint deadline,
485         bool approveMax, uint8 v, bytes32 r, bytes32 s
486     ) external returns (uint amountA, uint amountB);
487     function removeLiquidityETHWithPermit(
488         address token,
489         uint liquidity,
490         uint amountTokenMin,
491         uint amountETHMin,
492         address to,
493         uint deadline,
494         bool approveMax, uint8 v, bytes32 r, bytes32 s
495     ) external returns (uint amountToken, uint amountETH);
496     function swapExactTokensForTokens(
497         uint amountIn,
498         uint amountOutMin,
499         address[] calldata path,
500         address to,
501         uint deadline
502     ) external returns (uint[] memory amounts);
503     function swapTokensForExactTokens(
504         uint amountOut,
505         uint amountInMax,
506         address[] calldata path,
507         address to,
508         uint deadline
509     ) external returns (uint[] memory amounts);
510     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
511         external
512         payable
513         returns (uint[] memory amounts);
514     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
515         external
516         returns (uint[] memory amounts);
517     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
518         external
519         returns (uint[] memory amounts);
520     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
521         external
522         payable
523         returns (uint[] memory amounts);
524 
525     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
526     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external view returns (uint amountOut);
527     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external view returns (uint amountIn);
528     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
529     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
530 }
531 
532 // File: contracts/uniswapv2/interfaces/IUniswapV2Router02.sol
533 
534 pragma solidity >=0.6.2;
535 
536 
537 interface IUniswapV2Router02 is IUniswapV2Router01 {
538     function removeLiquidityETHSupportingFeeOnTransferTokens(
539         address token,
540         uint liquidity,
541         uint amountTokenMin,
542         uint amountETHMin,
543         address to,
544         uint deadline
545     ) external returns (uint amountETH);
546     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
547         address token,
548         uint liquidity,
549         uint amountTokenMin,
550         uint amountETHMin,
551         address to,
552         uint deadline,
553         bool approveMax, uint8 v, bytes32 r, bytes32 s
554     ) external returns (uint amountETH);
555 
556     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
557         uint amountIn,
558         uint amountOutMin,
559         address[] calldata path,
560         address to,
561         uint deadline
562     ) external;
563     function swapExactETHForTokensSupportingFeeOnTransferTokens(
564         uint amountOutMin,
565         address[] calldata path,
566         address to,
567         uint deadline
568     ) external payable;
569     function swapExactTokensForETHSupportingFeeOnTransferTokens(
570         uint amountIn,
571         uint amountOutMin,
572         address[] calldata path,
573         address to,
574         uint deadline
575     ) external;
576 }
577 
578 // File: contracts/uniswapv2/interfaces/IWETH.sol
579 
580 pragma solidity >=0.5.0;
581 
582 interface IWETH {
583     function deposit() external payable;
584     function transfer(address to, uint value) external returns (bool);
585     function withdraw(uint) external;
586 }
587 
588 // File: contracts/uniswapv2/UniswapV2Router02.sol
589 
590 pragma solidity =0.6.12;
591 
592 
593 
594 
595 
596 
597 
598 
599 contract UniswapV2Router02 is IUniswapV2Router02 {
600     using SafeMath for uint;
601 
602     address public immutable override factory;
603     address public immutable override WETH;
604 
605     modifier ensure(uint deadline) {
606         require(deadline >= block.timestamp, 'UniswapV2Router: EXPIRED');
607         _;
608     }
609 
610     constructor(address _factory, address _WETH) public {
611         factory = _factory;
612         WETH = _WETH;
613     }
614 
615     receive() external payable {
616         assert(msg.sender == WETH); // only accept ETH via fallback from the WETH contract
617     }
618 
619     // **** ADD LIQUIDITY ****
620     function _addLiquidity(
621         address tokenA,
622         address tokenB,
623         uint amountADesired,
624         uint amountBDesired,
625         uint amountAMin,
626         uint amountBMin
627     ) internal virtual returns (uint amountA, uint amountB) {
628         // create the pair if it doesn't exist yet
629         if (IUniswapV2Factory(factory).getPair(tokenA, tokenB) == address(0)) {
630             IUniswapV2Factory(factory).createPair(tokenA, tokenB);
631         }
632         (uint reserveA, uint reserveB) = UniswapV2Library.getReserves(factory, tokenA, tokenB);
633         if (reserveA == 0 && reserveB == 0) {
634             (amountA, amountB) = (amountADesired, amountBDesired);
635         } else {
636             uint amountBOptimal = UniswapV2Library.quote(amountADesired, reserveA, reserveB);
637             if (amountBOptimal <= amountBDesired) {
638                 require(amountBOptimal >= amountBMin, 'UniswapV2Router: INSUFFICIENT_B_AMOUNT');
639                 (amountA, amountB) = (amountADesired, amountBOptimal);
640             } else {
641                 uint amountAOptimal = UniswapV2Library.quote(amountBDesired, reserveB, reserveA);
642                 assert(amountAOptimal <= amountADesired);
643                 require(amountAOptimal >= amountAMin, 'UniswapV2Router: INSUFFICIENT_A_AMOUNT');
644                 (amountA, amountB) = (amountAOptimal, amountBDesired);
645             }
646         }
647     }
648     function addLiquidity(
649         address tokenA,
650         address tokenB,
651         uint amountADesired,
652         uint amountBDesired,
653         uint amountAMin,
654         uint amountBMin,
655         address to,
656         uint deadline
657     ) external virtual override ensure(deadline) returns (uint amountA, uint amountB, uint liquidity) {
658         (amountA, amountB) = _addLiquidity(tokenA, tokenB, amountADesired, amountBDesired, amountAMin, amountBMin);
659         address pair = UniswapV2Library.pairFor(factory, tokenA, tokenB);
660         TransferHelper.safeTransferFrom(tokenA, msg.sender, pair, amountA);
661         TransferHelper.safeTransferFrom(tokenB, msg.sender, pair, amountB);
662         liquidity = IUniswapV2Pair(pair).mint(to);
663     }
664     function addLiquidityETH(
665         address token,
666         uint amountTokenDesired,
667         uint amountTokenMin,
668         uint amountETHMin,
669         address to,
670         uint deadline
671     ) external virtual override payable ensure(deadline) returns (uint amountToken, uint amountETH, uint liquidity) {
672         (amountToken, amountETH) = _addLiquidity(
673             token,
674             WETH,
675             amountTokenDesired,
676             msg.value,
677             amountTokenMin,
678             amountETHMin
679         );
680         address pair = UniswapV2Library.pairFor(factory, token, WETH);
681         TransferHelper.safeTransferFrom(token, msg.sender, pair, amountToken);
682         IWETH(WETH).deposit{value: amountETH}();
683         assert(IWETH(WETH).transfer(pair, amountETH));
684         liquidity = IUniswapV2Pair(pair).mint(to);
685         // refund dust eth, if any
686         if (msg.value > amountETH) TransferHelper.safeTransferETH(msg.sender, msg.value - amountETH);
687     }
688 
689     // **** REMOVE LIQUIDITY ****
690     function removeLiquidity(
691         address tokenA,
692         address tokenB,
693         uint liquidity,
694         uint amountAMin,
695         uint amountBMin,
696         address to,
697         uint deadline
698     ) public virtual override ensure(deadline) returns (uint amountA, uint amountB) {
699         address pair = UniswapV2Library.pairFor(factory, tokenA, tokenB);
700         IUniswapV2Pair(pair).transferFrom(msg.sender, pair, liquidity); // send liquidity to pair
701         (uint amount0, uint amount1) = IUniswapV2Pair(pair).burn(to);
702         (address token0,) = UniswapV2Library.sortTokens(tokenA, tokenB);
703         (amountA, amountB) = tokenA == token0 ? (amount0, amount1) : (amount1, amount0);
704         require(amountA >= amountAMin, 'UniswapV2Router: INSUFFICIENT_A_AMOUNT');
705         require(amountB >= amountBMin, 'UniswapV2Router: INSUFFICIENT_B_AMOUNT');
706     }
707     function removeLiquidityETH(
708         address token,
709         uint liquidity,
710         uint amountTokenMin,
711         uint amountETHMin,
712         address to,
713         uint deadline
714     ) public virtual override ensure(deadline) returns (uint amountToken, uint amountETH) {
715         (amountToken, amountETH) = removeLiquidity(
716             token,
717             WETH,
718             liquidity,
719             amountTokenMin,
720             amountETHMin,
721             address(this),
722             deadline
723         );
724         TransferHelper.safeTransfer(token, to, amountToken);
725         IWETH(WETH).withdraw(amountETH);
726         TransferHelper.safeTransferETH(to, amountETH);
727     }
728     function removeLiquidityWithPermit(
729         address tokenA,
730         address tokenB,
731         uint liquidity,
732         uint amountAMin,
733         uint amountBMin,
734         address to,
735         uint deadline,
736         bool approveMax, uint8 v, bytes32 r, bytes32 s
737     ) external virtual override returns (uint amountA, uint amountB) {
738         address pair = UniswapV2Library.pairFor(factory, tokenA, tokenB);
739         uint value = approveMax ? uint(-1) : liquidity;
740         IUniswapV2Pair(pair).permit(msg.sender, address(this), value, deadline, v, r, s);
741         (amountA, amountB) = removeLiquidity(tokenA, tokenB, liquidity, amountAMin, amountBMin, to, deadline);
742     }
743     function removeLiquidityETHWithPermit(
744         address token,
745         uint liquidity,
746         uint amountTokenMin,
747         uint amountETHMin,
748         address to,
749         uint deadline,
750         bool approveMax, uint8 v, bytes32 r, bytes32 s
751     ) external virtual override returns (uint amountToken, uint amountETH) {
752         address pair = UniswapV2Library.pairFor(factory, token, WETH);
753         uint value = approveMax ? uint(-1) : liquidity;
754         IUniswapV2Pair(pair).permit(msg.sender, address(this), value, deadline, v, r, s);
755         (amountToken, amountETH) = removeLiquidityETH(token, liquidity, amountTokenMin, amountETHMin, to, deadline);
756     }
757 
758     // **** REMOVE LIQUIDITY (supporting fee-on-transfer tokens) ****
759     function removeLiquidityETHSupportingFeeOnTransferTokens(
760         address token,
761         uint liquidity,
762         uint amountTokenMin,
763         uint amountETHMin,
764         address to,
765         uint deadline
766     ) public virtual override ensure(deadline) returns (uint amountETH) {
767         (, amountETH) = removeLiquidity(
768             token,
769             WETH,
770             liquidity,
771             amountTokenMin,
772             amountETHMin,
773             address(this),
774             deadline
775         );
776         TransferHelper.safeTransfer(token, to, IERC20(token).balanceOf(address(this)));
777         IWETH(WETH).withdraw(amountETH);
778         TransferHelper.safeTransferETH(to, amountETH);
779     }
780     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
781         address token,
782         uint liquidity,
783         uint amountTokenMin,
784         uint amountETHMin,
785         address to,
786         uint deadline,
787         bool approveMax, uint8 v, bytes32 r, bytes32 s
788     ) external virtual override returns (uint amountETH) {
789         address pair = UniswapV2Library.pairFor(factory, token, WETH);
790         uint value = approveMax ? uint(-1) : liquidity;
791         IUniswapV2Pair(pair).permit(msg.sender, address(this), value, deadline, v, r, s);
792         amountETH = removeLiquidityETHSupportingFeeOnTransferTokens(
793             token, liquidity, amountTokenMin, amountETHMin, to, deadline
794         );
795     }
796 
797     // **** SWAP ****
798     // requires the initial amount to have already been sent to the first pair
799     function _swap(uint[] memory amounts, address[] memory path, address _to) internal virtual {
800         for (uint i; i < path.length - 1; i++) {
801             (address input, address output) = (path[i], path[i + 1]);
802             (address token0,) = UniswapV2Library.sortTokens(input, output);
803             uint amountOut = amounts[i + 1];
804             (uint amount0Out, uint amount1Out) = input == token0 ? (uint(0), amountOut) : (amountOut, uint(0));
805             address to = i < path.length - 2 ? UniswapV2Library.pairFor(factory, output, path[i + 2]) : _to;
806             IUniswapV2Pair(UniswapV2Library.pairFor(factory, input, output)).swap(
807                 amount0Out, amount1Out, to, new bytes(0)
808             );
809         }
810     }
811     function swapExactTokensForTokens(
812         uint amountIn,
813         uint amountOutMin,
814         address[] calldata path,
815         address to,
816         uint deadline
817     ) external virtual override ensure(deadline) returns (uint[] memory amounts) {
818         amounts = UniswapV2Library.getAmountsOut(factory, amountIn, path, IUniswapV2Factory(factory).swapFee());
819         require(amounts[amounts.length - 1] >= amountOutMin, 'UniswapV2Router: INSUFFICIENT_OUTPUT_AMOUNT');
820         TransferHelper.safeTransferFrom(
821             path[0], msg.sender, UniswapV2Library.pairFor(factory, path[0], path[1]), amounts[0]
822         );
823         _swap(amounts, path, to);
824     }
825     function swapTokensForExactTokens(
826         uint amountOut,
827         uint amountInMax,
828         address[] calldata path,
829         address to,
830         uint deadline
831     ) external virtual override ensure(deadline) returns (uint[] memory amounts) {
832         amounts = UniswapV2Library.getAmountsIn(factory, amountOut, path, IUniswapV2Factory(factory).swapFee());
833         require(amounts[0] <= amountInMax, 'UniswapV2Router: EXCESSIVE_INPUT_AMOUNT');
834         TransferHelper.safeTransferFrom(
835             path[0], msg.sender, UniswapV2Library.pairFor(factory, path[0], path[1]), amounts[0]
836         );
837         _swap(amounts, path, to);
838     }
839     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
840         external
841         virtual
842         override
843         payable
844         ensure(deadline)
845         returns (uint[] memory amounts)
846     {
847         require(path[0] == WETH, 'UniswapV2Router: INVALID_PATH');
848         amounts = UniswapV2Library.getAmountsOut(factory, msg.value, path, IUniswapV2Factory(factory).swapFee());
849         require(amounts[amounts.length - 1] >= amountOutMin, 'UniswapV2Router: INSUFFICIENT_OUTPUT_AMOUNT');
850         IWETH(WETH).deposit{value: amounts[0]}();
851         assert(IWETH(WETH).transfer(UniswapV2Library.pairFor(factory, path[0], path[1]), amounts[0]));
852         _swap(amounts, path, to);
853     }
854     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
855         external
856         virtual
857         override
858         ensure(deadline)
859         returns (uint[] memory amounts)
860     {
861         require(path[path.length - 1] == WETH, 'UniswapV2Router: INVALID_PATH');
862         amounts = UniswapV2Library.getAmountsIn(factory, amountOut, path, IUniswapV2Factory(factory).swapFee());
863         require(amounts[0] <= amountInMax, 'UniswapV2Router: EXCESSIVE_INPUT_AMOUNT');
864         TransferHelper.safeTransferFrom(
865             path[0], msg.sender, UniswapV2Library.pairFor(factory, path[0], path[1]), amounts[0]
866         );
867         _swap(amounts, path, address(this));
868         IWETH(WETH).withdraw(amounts[amounts.length - 1]);
869         TransferHelper.safeTransferETH(to, amounts[amounts.length - 1]);
870     }
871     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
872         external
873         virtual
874         override
875         ensure(deadline)
876         returns (uint[] memory amounts)
877     {
878         require(path[path.length - 1] == WETH, 'UniswapV2Router: INVALID_PATH');
879         amounts = UniswapV2Library.getAmountsOut(factory, amountIn, path, IUniswapV2Factory(factory).swapFee());
880         require(amounts[amounts.length - 1] >= amountOutMin, 'UniswapV2Router: INSUFFICIENT_OUTPUT_AMOUNT');
881         TransferHelper.safeTransferFrom(
882             path[0], msg.sender, UniswapV2Library.pairFor(factory, path[0], path[1]), amounts[0]
883         );
884         _swap(amounts, path, address(this));
885         IWETH(WETH).withdraw(amounts[amounts.length - 1]);
886         TransferHelper.safeTransferETH(to, amounts[amounts.length - 1]);
887     }
888     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
889         external
890         virtual
891         override
892         payable
893         ensure(deadline)
894         returns (uint[] memory amounts)
895     {
896         require(path[0] == WETH, 'UniswapV2Router: INVALID_PATH');
897         amounts = UniswapV2Library.getAmountsIn(factory, amountOut, path, IUniswapV2Factory(factory).swapFee());
898         require(amounts[0] <= msg.value, 'UniswapV2Router: EXCESSIVE_INPUT_AMOUNT');
899         IWETH(WETH).deposit{value: amounts[0]}();
900         assert(IWETH(WETH).transfer(UniswapV2Library.pairFor(factory, path[0], path[1]), amounts[0]));
901         _swap(amounts, path, to);
902         // refund dust eth, if any
903         if (msg.value > amounts[0]) TransferHelper.safeTransferETH(msg.sender, msg.value - amounts[0]);
904     }
905 
906     // **** SWAP (supporting fee-on-transfer tokens) ****
907     // requires the initial amount to have already been sent to the first pair
908     function _swapSupportingFeeOnTransferTokens(address[] memory path, address _to) internal virtual {
909         for (uint i; i < path.length - 1; i++) {
910             (address input, address output) = (path[i], path[i + 1]);
911             (address token0,) = UniswapV2Library.sortTokens(input, output);
912             IUniswapV2Pair pair = IUniswapV2Pair(UniswapV2Library.pairFor(factory, input, output));
913             uint amountInput;
914             uint amountOutput;
915             { // scope to avoid stack too deep errors
916             (uint reserve0, uint reserve1,) = pair.getReserves();
917             (uint reserveInput, uint reserveOutput) = input == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
918             amountInput = IERC20(input).balanceOf(address(pair)).sub(reserveInput);
919             amountOutput = UniswapV2Library.getAmountOut(amountInput, reserveInput, reserveOutput, IUniswapV2Factory(factory).swapFee());
920             }
921             (uint amount0Out, uint amount1Out) = input == token0 ? (uint(0), amountOutput) : (amountOutput, uint(0));
922             address to = i < path.length - 2 ? UniswapV2Library.pairFor(factory, output, path[i + 2]) : _to;
923             pair.swap(amount0Out, amount1Out, to, new bytes(0));
924         }
925     }
926     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
927         uint amountIn,
928         uint amountOutMin,
929         address[] calldata path,
930         address to,
931         uint deadline
932     ) external virtual override ensure(deadline) {
933         TransferHelper.safeTransferFrom(
934             path[0], msg.sender, UniswapV2Library.pairFor(factory, path[0], path[1]), amountIn
935         );
936         uint balanceBefore = IERC20(path[path.length - 1]).balanceOf(to);
937         _swapSupportingFeeOnTransferTokens(path, to);
938         require(
939             IERC20(path[path.length - 1]).balanceOf(to).sub(balanceBefore) >= amountOutMin,
940             'UniswapV2Router: INSUFFICIENT_OUTPUT_AMOUNT'
941         );
942     }
943     function swapExactETHForTokensSupportingFeeOnTransferTokens(
944         uint amountOutMin,
945         address[] calldata path,
946         address to,
947         uint deadline
948     )
949         external
950         virtual
951         override
952         payable
953         ensure(deadline)
954     {
955         require(path[0] == WETH, 'UniswapV2Router: INVALID_PATH');
956         uint amountIn = msg.value;
957         IWETH(WETH).deposit{value: amountIn}();
958         assert(IWETH(WETH).transfer(UniswapV2Library.pairFor(factory, path[0], path[1]), amountIn));
959         uint balanceBefore = IERC20(path[path.length - 1]).balanceOf(to);
960         _swapSupportingFeeOnTransferTokens(path, to);
961         require(
962             IERC20(path[path.length - 1]).balanceOf(to).sub(balanceBefore) >= amountOutMin,
963             'UniswapV2Router: INSUFFICIENT_OUTPUT_AMOUNT'
964         );
965     }
966     function swapExactTokensForETHSupportingFeeOnTransferTokens(
967         uint amountIn,
968         uint amountOutMin,
969         address[] calldata path,
970         address to,
971         uint deadline
972     )
973         external
974         virtual
975         override
976         ensure(deadline)
977     {
978         require(path[path.length - 1] == WETH, 'UniswapV2Router: INVALID_PATH');
979         TransferHelper.safeTransferFrom(
980             path[0], msg.sender, UniswapV2Library.pairFor(factory, path[0], path[1]), amountIn
981         );
982         _swapSupportingFeeOnTransferTokens(path, address(this));
983         uint amountOut = IERC20(WETH).balanceOf(address(this));
984         require(amountOut >= amountOutMin, 'UniswapV2Router: INSUFFICIENT_OUTPUT_AMOUNT');
985         IWETH(WETH).withdraw(amountOut);
986         TransferHelper.safeTransferETH(to, amountOut);
987     }
988 
989     // **** LIBRARY FUNCTIONS ****
990     function quote(uint amountA, uint reserveA, uint reserveB) public pure virtual override returns (uint amountB) {
991         return UniswapV2Library.quote(amountA, reserveA, reserveB);
992     }
993 
994     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut)
995         public
996         view
997         virtual
998         override
999         returns (uint amountOut)
1000     {
1001         return UniswapV2Library.getAmountOut(amountIn, reserveIn, reserveOut, IUniswapV2Factory(factory).swapFee());
1002     }
1003 
1004     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut)
1005         public
1006         view
1007         virtual
1008         override
1009         returns (uint amountIn)
1010     {
1011         return UniswapV2Library.getAmountIn(amountOut, reserveIn, reserveOut, IUniswapV2Factory(factory).swapFee());
1012     }
1013 
1014     function getAmountsOut(uint amountIn, address[] memory path)
1015         public
1016         view
1017         virtual
1018         override
1019         returns (uint[] memory amounts)
1020     {
1021         return UniswapV2Library.getAmountsOut(factory, amountIn, path, IUniswapV2Factory(factory).swapFee());
1022     }
1023 
1024     function getAmountsIn(uint amountOut, address[] memory path)
1025         public
1026         view
1027         virtual
1028         override
1029         returns (uint[] memory amounts)
1030     {
1031         return UniswapV2Library.getAmountsIn(factory, amountOut, path, IUniswapV2Factory(factory).swapFee());
1032     }
1033 }