1 /**
2  *Submitted for verification at Etherscan.io on 2020-09-04
3 */
4 
5 // File: contracts/uniswapv2/interfaces/IUniswapV2Pair.sol
6 
7 pragma solidity >=0.5.0;
8 
9 interface IUniswapV2Pair {
10     event Approval(address indexed owner, address indexed spender, uint value);
11     event Transfer(address indexed from, address indexed to, uint value);
12 
13     function name() external pure returns (string memory);
14     function symbol() external pure returns (string memory);
15     function decimals() external pure returns (uint8);
16     function totalSupply() external view returns (uint);
17     function balanceOf(address owner) external view returns (uint);
18     function allowance(address owner, address spender) external view returns (uint);
19 
20     function approve(address spender, uint value) external returns (bool);
21     function transfer(address to, uint value) external returns (bool);
22     function transferFrom(address from, address to, uint value) external returns (bool);
23 
24     function DOMAIN_SEPARATOR() external view returns (bytes32);
25     function PERMIT_TYPEHASH() external pure returns (bytes32);
26     function nonces(address owner) external view returns (uint);
27 
28     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
29 
30     event Mint(address indexed sender, uint amount0, uint amount1);
31     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
32     event Swap(
33         address indexed sender,
34         uint amount0In,
35         uint amount1In,
36         uint amount0Out,
37         uint amount1Out,
38         address indexed to
39     );
40     event Sync(uint112 reserve0, uint112 reserve1);
41 
42     function MINIMUM_LIQUIDITY() external pure returns (uint);
43     function factory() external view returns (address);
44     function token0() external view returns (address);
45     function token1() external view returns (address);
46     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
47     function price0CumulativeLast() external view returns (uint);
48     function price1CumulativeLast() external view returns (uint);
49     function kLast() external view returns (uint);
50 
51     function mint(address to) external returns (uint liquidity);
52     function burn(address to) external returns (uint amount0, uint amount1);
53     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
54     function skim(address to) external;
55     function sync() external;
56 
57     function initialize(address, address) external;
58 }
59 
60 // File: contracts/uniswapv2/libraries/SafeMath.sol
61 
62 pragma solidity =0.6.12;
63 
64 // a library for performing overflow-safe math, courtesy of DappHub (https://github.com/dapphub/ds-math)
65 
66 library SafeMathUniswap {
67     function add(uint x, uint y) internal pure returns (uint z) {
68         require((z = x + y) >= x, 'ds-math-add-overflow');
69     }
70 
71     function sub(uint x, uint y) internal pure returns (uint z) {
72         require((z = x - y) <= x, 'ds-math-sub-underflow');
73     }
74 
75     function mul(uint x, uint y) internal pure returns (uint z) {
76         require(y == 0 || (z = x * y) / y == x, 'ds-math-mul-overflow');
77     }
78 }
79 
80 
81 // File: contracts/uniswapv2/interfaces/IUniswapV2Factory.sol
82 
83 pragma solidity >=0.5.0;
84 
85 interface IUniswapV2Factory {
86     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
87 
88     function feeTo() external view returns (address);
89     function feeRate() external view returns (uint);
90     function feeToSetter() external view returns (address);
91     function migrator() external view returns (address);
92 
93     function getPair(address tokenA, address tokenB) external view returns (address pair);
94     function allPairs(uint) external view returns (address pair);
95     function allPairsLength() external view returns (uint);
96 
97     function createPair(address tokenA, address tokenB) external returns (address pair);
98 
99     function setFeeTo(address) external;
100     function setFeeToSetter(address) external;
101     function setMigrator(address) external;
102 }
103 
104 // File: contracts/uniswapv2/libraries/UniswapV2Library.sol
105 
106 pragma solidity >=0.5.0;
107 
108 
109 
110 library UniswapV2Library {
111     using SafeMathUniswap for uint;
112 
113     // returns sorted token addresses, used to handle return values from pairs sorted in this order
114     function sortTokens(address tokenA, address tokenB) internal pure returns (address token0, address token1) {
115         require(tokenA != tokenB, 'UniswapV2Library: IDENTICAL_ADDRESSES');
116         (token0, token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
117         require(token0 != address(0), 'UniswapV2Library: ZERO_ADDRESS');
118     }
119 
120     // calculates the CREATE2 address for a pair without making any external calls
121     function pairFor(address factory, address tokenA, address tokenB) internal pure returns (address pair) {
122         (address token0, address token1) = sortTokens(tokenA, tokenB);
123         pair = address(uint(keccak256(abi.encodePacked(
124                 hex'ff',
125                 factory,
126                 keccak256(abi.encodePacked(token0, token1)),
127                 hex'54477e068e43d7c838c564c7963aeaa90fd514f0939b57b5ca3afab70469c957' // init code hash
128             ))));
129     }
130 
131     // fetches and sorts the reserves for a pair
132     function getReserves(address factory, address tokenA, address tokenB) internal view returns (uint reserveA, uint reserveB) {
133         (address token0,) = sortTokens(tokenA, tokenB);
134         (uint reserve0, uint reserve1,) = IUniswapV2Pair(pairFor(factory, tokenA, tokenB)).getReserves();
135         (reserveA, reserveB) = tokenA == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
136     }
137 
138     // given some amount of an asset and pair reserves, returns an equivalent amount of the other asset
139     function quote(uint amountA, uint reserveA, uint reserveB) internal pure returns (uint amountB) {
140         require(amountA > 0, 'UniswapV2Library: INSUFFICIENT_AMOUNT');
141         require(reserveA > 0 && reserveB > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
142         amountB = amountA.mul(reserveB) / reserveA;
143     }
144 
145     // given an input amount of an asset and pair reserves, returns the maximum output amount of the other asset
146     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut, uint feeRate) internal pure returns (uint amountOut) {
147         require(amountIn > 0, 'UniswapV2Library: INSUFFICIENT_INPUT_AMOUNT');
148         require(reserveIn > 0 && reserveOut > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
149         uint amountInWithFee = amountIn.mul(1000 - feeRate);
150         uint numerator = amountInWithFee.mul(reserveOut);
151         uint denominator = reserveIn.mul(1000).add(amountInWithFee);
152         amountOut = numerator / denominator;
153     }
154 
155     // given an output amount of an asset and pair reserves, returns a required input amount of the other asset
156     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut, uint feeRate) internal pure returns (uint amountIn) {
157         require(amountOut > 0, 'UniswapV2Library: INSUFFICIENT_OUTPUT_AMOUNT');
158         require(reserveIn > 0 && reserveOut > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
159         uint numerator = reserveIn.mul(amountOut).mul(1000);
160         uint denominator = reserveOut.sub(amountOut).mul(1000 - feeRate);
161         amountIn = (numerator / denominator).add(1);
162     }
163 
164     // performs chained getAmountOut calculations on any number of pairs
165     function getAmountsOut(address factory, uint amountIn, address[] memory path, uint feeRate) internal view returns (uint[] memory amounts) {
166         require(path.length >= 2, 'UniswapV2Library: INVALID_PATH');
167         amounts = new uint[](path.length);
168         amounts[0] = amountIn;
169         for (uint i; i < path.length - 1; i++) {
170             (uint reserveIn, uint reserveOut) = getReserves(factory, path[i], path[i + 1]);
171             amounts[i + 1] = getAmountOut(amounts[i], reserveIn, reserveOut, feeRate);
172         }
173     }
174 
175     // performs chained getAmountIn calculations on any number of pairs
176     function getAmountsIn(address factory, uint amountOut, address[] memory path, uint feeRate) internal view returns (uint[] memory amounts) {
177         require(path.length >= 2, 'UniswapV2Library: INVALID_PATH');
178         amounts = new uint[](path.length);
179         amounts[amounts.length - 1] = amountOut;
180         for (uint i = path.length - 1; i > 0; i--) {
181             (uint reserveIn, uint reserveOut) = getReserves(factory, path[i - 1], path[i]);
182             amounts[i - 1] = getAmountIn(amounts[i], reserveIn, reserveOut, feeRate);
183         }
184     }
185 }
186 
187 // File: contracts/uniswapv2/libraries/TransferHelper.sol
188 
189 // SPDX-License-Identifier: GPL-3.0-or-later
190 
191 pragma solidity >=0.6.0;
192 
193 // helper methods for interacting with ERC20 tokens and sending ETH that do not consistently return true/false
194 library TransferHelper {
195     function safeApprove(address token, address to, uint value) internal {
196         // bytes4(keccak256(bytes('approve(address,uint256)')));
197         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x095ea7b3, to, value));
198         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: APPROVE_FAILED');
199     }
200 
201     function safeTransfer(address token, address to, uint value) internal {
202         // bytes4(keccak256(bytes('transfer(address,uint256)')));
203         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));
204         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FAILED');
205     }
206 
207     function safeTransferFrom(address token, address from, address to, uint value) internal {
208         // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
209         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));
210         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FROM_FAILED');
211     }
212 
213     function safeTransferETH(address to, uint value) internal {
214         (bool success,) = to.call{value:value}(new bytes(0));
215         require(success, 'TransferHelper: ETH_TRANSFER_FAILED');
216     }
217 }
218 
219 // File: contracts/uniswapv2/interfaces/IUniswapV2Router01.sol
220 
221 pragma solidity >=0.6.2;
222 
223 interface IUniswapV2Router01 {
224     function factory() external pure returns (address);
225     function WETH() external pure returns (address);
226 
227     function addLiquidity(
228         address tokenA,
229         address tokenB,
230         uint amountADesired,
231         uint amountBDesired,
232         uint amountAMin,
233         uint amountBMin,
234         address to,
235         uint deadline
236     ) external returns (uint amountA, uint amountB, uint liquidity);
237     function addLiquidityETH(
238         address token,
239         uint amountTokenDesired,
240         uint amountTokenMin,
241         uint amountETHMin,
242         address to,
243         uint deadline
244     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
245     function removeLiquidity(
246         address tokenA,
247         address tokenB,
248         uint liquidity,
249         uint amountAMin,
250         uint amountBMin,
251         address to,
252         uint deadline
253     ) external returns (uint amountA, uint amountB);
254     function removeLiquidityETH(
255         address token,
256         uint liquidity,
257         uint amountTokenMin,
258         uint amountETHMin,
259         address to,
260         uint deadline
261     ) external returns (uint amountToken, uint amountETH);
262     function removeLiquidityWithPermit(
263         address tokenA,
264         address tokenB,
265         uint liquidity,
266         uint amountAMin,
267         uint amountBMin,
268         address to,
269         uint deadline,
270         bool approveMax, uint8 v, bytes32 r, bytes32 s
271     ) external returns (uint amountA, uint amountB);
272     function removeLiquidityETHWithPermit(
273         address token,
274         uint liquidity,
275         uint amountTokenMin,
276         uint amountETHMin,
277         address to,
278         uint deadline,
279         bool approveMax, uint8 v, bytes32 r, bytes32 s
280     ) external returns (uint amountToken, uint amountETH);
281     function swapExactTokensForTokens(
282         uint amountIn,
283         uint amountOutMin,
284         address[] calldata path,
285         address to,
286         uint deadline
287     ) external returns (uint[] memory amounts);
288     function swapTokensForExactTokens(
289         uint amountOut,
290         uint amountInMax,
291         address[] calldata path,
292         address to,
293         uint deadline
294     ) external returns (uint[] memory amounts);
295     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
296         external
297         payable
298         returns (uint[] memory amounts);
299     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
300         external
301         returns (uint[] memory amounts);
302     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
303         external
304         returns (uint[] memory amounts);
305     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
306         external
307         payable
308         returns (uint[] memory amounts);
309 
310     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
311     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external view returns (uint amountOut);
312     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external view returns (uint amountIn);
313     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
314     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
315 }
316 
317 // File: contracts/uniswapv2/interfaces/IUniswapV2Router02.sol
318 
319 pragma solidity >=0.6.2;
320 
321 
322 interface IUniswapV2Router02 is IUniswapV2Router01 {
323     function removeLiquidityETHSupportingFeeOnTransferTokens(
324         address token,
325         uint liquidity,
326         uint amountTokenMin,
327         uint amountETHMin,
328         address to,
329         uint deadline
330     ) external returns (uint amountETH);
331     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
332         address token,
333         uint liquidity,
334         uint amountTokenMin,
335         uint amountETHMin,
336         address to,
337         uint deadline,
338         bool approveMax, uint8 v, bytes32 r, bytes32 s
339     ) external returns (uint amountETH);
340 
341     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
342         uint amountIn,
343         uint amountOutMin,
344         address[] calldata path,
345         address to,
346         uint deadline
347     ) external;
348     function swapExactETHForTokensSupportingFeeOnTransferTokens(
349         uint amountOutMin,
350         address[] calldata path,
351         address to,
352         uint deadline
353     ) external payable;
354     function swapExactTokensForETHSupportingFeeOnTransferTokens(
355         uint amountIn,
356         uint amountOutMin,
357         address[] calldata path,
358         address to,
359         uint deadline
360     ) external;
361 }
362 
363 
364 // File: contracts/uniswapv2/interfaces/IERC20.sol
365 
366 pragma solidity >=0.5.0;
367 
368 interface IERC20Uniswap {
369     event Approval(address indexed owner, address indexed spender, uint value);
370     event Transfer(address indexed from, address indexed to, uint value);
371 
372     function name() external view returns (string memory);
373     function symbol() external view returns (string memory);
374     function decimals() external view returns (uint8);
375     function totalSupply() external view returns (uint);
376     function balanceOf(address owner) external view returns (uint);
377     function allowance(address owner, address spender) external view returns (uint);
378 
379     function approve(address spender, uint value) external returns (bool);
380     function transfer(address to, uint value) external returns (bool);
381     function transferFrom(address from, address to, uint value) external returns (bool);
382 }
383 
384 // File: contracts/uniswapv2/interfaces/IWETH.sol
385 
386 pragma solidity >=0.5.0;
387 
388 interface IWETH {
389     function deposit() external payable;
390     function transfer(address to, uint value) external returns (bool);
391     function withdraw(uint) external;
392 }
393 
394 // File: contracts/uniswapv2/UniswapV2Router02.sol
395 
396 pragma solidity =0.6.12;
397 
398 contract UniswapV2Router02 is IUniswapV2Router02 {
399     using SafeMathUniswap for uint;
400 
401     address public immutable override factory;
402     address public immutable override WETH;
403 
404     modifier ensure(uint deadline) {
405         require(deadline >= block.timestamp, 'UniswapV2Router: EXPIRED');
406         _;
407     }
408 
409     constructor(address _factory, address _WETH) public {
410         factory = _factory;
411         WETH = _WETH;
412     }
413 
414     receive() external payable {
415         assert(msg.sender == WETH); // only accept ETH via fallback from the WETH contract
416     }
417 
418     // **** ADD LIQUIDITY ****
419     function _addLiquidity(
420         address tokenA,
421         address tokenB,
422         uint amountADesired,
423         uint amountBDesired,
424         uint amountAMin,
425         uint amountBMin
426     ) internal virtual returns (uint amountA, uint amountB) {
427         // create the pair if it doesn't exist yet
428         if (IUniswapV2Factory(factory).getPair(tokenA, tokenB) == address(0)) {
429             IUniswapV2Factory(factory).createPair(tokenA, tokenB);
430         }
431         (uint reserveA, uint reserveB) = UniswapV2Library.getReserves(factory, tokenA, tokenB);
432         if (reserveA == 0 && reserveB == 0) {
433             (amountA, amountB) = (amountADesired, amountBDesired);
434         } else {
435             uint amountBOptimal = UniswapV2Library.quote(amountADesired, reserveA, reserveB);
436             if (amountBOptimal <= amountBDesired) {
437                 require(amountBOptimal >= amountBMin, 'UniswapV2Router: INSUFFICIENT_B_AMOUNT');
438                 (amountA, amountB) = (amountADesired, amountBOptimal);
439             } else {
440                 uint amountAOptimal = UniswapV2Library.quote(amountBDesired, reserveB, reserveA);
441                 assert(amountAOptimal <= amountADesired);
442                 require(amountAOptimal >= amountAMin, 'UniswapV2Router: INSUFFICIENT_A_AMOUNT');
443                 (amountA, amountB) = (amountAOptimal, amountBDesired);
444             }
445         }
446     }
447     function addLiquidity(
448         address tokenA,
449         address tokenB,
450         uint amountADesired,
451         uint amountBDesired,
452         uint amountAMin,
453         uint amountBMin,
454         address to,
455         uint deadline
456     ) external virtual override ensure(deadline) returns (uint amountA, uint amountB, uint liquidity) {
457         (amountA, amountB) = _addLiquidity(tokenA, tokenB, amountADesired, amountBDesired, amountAMin, amountBMin);
458         address pair = UniswapV2Library.pairFor(factory, tokenA, tokenB);
459         TransferHelper.safeTransferFrom(tokenA, msg.sender, pair, amountA);
460         TransferHelper.safeTransferFrom(tokenB, msg.sender, pair, amountB);
461         liquidity = IUniswapV2Pair(pair).mint(to);
462     }
463     function addLiquidityETH(
464         address token,
465         uint amountTokenDesired,
466         uint amountTokenMin,
467         uint amountETHMin,
468         address to,
469         uint deadline
470     ) external virtual override payable ensure(deadline) returns (uint amountToken, uint amountETH, uint liquidity) {
471         (amountToken, amountETH) = _addLiquidity(
472             token,
473             WETH,
474             amountTokenDesired,
475             msg.value,
476             amountTokenMin,
477             amountETHMin
478         );
479         address pair = UniswapV2Library.pairFor(factory, token, WETH);
480         TransferHelper.safeTransferFrom(token, msg.sender, pair, amountToken);
481         IWETH(WETH).deposit{value: amountETH}();
482         assert(IWETH(WETH).transfer(pair, amountETH));
483         liquidity = IUniswapV2Pair(pair).mint(to);
484         // refund dust eth, if any
485         if (msg.value > amountETH) TransferHelper.safeTransferETH(msg.sender, msg.value - amountETH);
486     }
487 
488     // **** REMOVE LIQUIDITY ****
489     function removeLiquidity(
490         address tokenA,
491         address tokenB,
492         uint liquidity,
493         uint amountAMin,
494         uint amountBMin,
495         address to,
496         uint deadline
497     ) public virtual override ensure(deadline) returns (uint amountA, uint amountB) {
498         address pair = UniswapV2Library.pairFor(factory, tokenA, tokenB);
499         IUniswapV2Pair(pair).transferFrom(msg.sender, pair, liquidity); // send liquidity to pair
500         (uint amount0, uint amount1) = IUniswapV2Pair(pair).burn(to);
501         (address token0,) = UniswapV2Library.sortTokens(tokenA, tokenB);
502         (amountA, amountB) = tokenA == token0 ? (amount0, amount1) : (amount1, amount0);
503         require(amountA >= amountAMin, 'UniswapV2Router: INSUFFICIENT_A_AMOUNT');
504         require(amountB >= amountBMin, 'UniswapV2Router: INSUFFICIENT_B_AMOUNT');
505     }
506     function removeLiquidityETH(
507         address token,
508         uint liquidity,
509         uint amountTokenMin,
510         uint amountETHMin,
511         address to,
512         uint deadline
513     ) public virtual override ensure(deadline) returns (uint amountToken, uint amountETH) {
514         (amountToken, amountETH) = removeLiquidity(
515             token,
516             WETH,
517             liquidity,
518             amountTokenMin,
519             amountETHMin,
520             address(this),
521             deadline
522         );
523         TransferHelper.safeTransfer(token, to, amountToken);
524         IWETH(WETH).withdraw(amountETH);
525         TransferHelper.safeTransferETH(to, amountETH);
526     }
527     function removeLiquidityWithPermit(
528         address tokenA,
529         address tokenB,
530         uint liquidity,
531         uint amountAMin,
532         uint amountBMin,
533         address to,
534         uint deadline,
535         bool approveMax, uint8 v, bytes32 r, bytes32 s
536     ) external virtual override returns (uint amountA, uint amountB) {
537         address pair = UniswapV2Library.pairFor(factory, tokenA, tokenB);
538         uint value = approveMax ? uint(-1) : liquidity;
539         IUniswapV2Pair(pair).permit(msg.sender, address(this), value, deadline, v, r, s);
540         (amountA, amountB) = removeLiquidity(tokenA, tokenB, liquidity, amountAMin, amountBMin, to, deadline);
541     }
542     function removeLiquidityETHWithPermit(
543         address token,
544         uint liquidity,
545         uint amountTokenMin,
546         uint amountETHMin,
547         address to,
548         uint deadline,
549         bool approveMax, uint8 v, bytes32 r, bytes32 s
550     ) external virtual override returns (uint amountToken, uint amountETH) {
551         address pair = UniswapV2Library.pairFor(factory, token, WETH);
552         uint value = approveMax ? uint(-1) : liquidity;
553         IUniswapV2Pair(pair).permit(msg.sender, address(this), value, deadline, v, r, s);
554         (amountToken, amountETH) = removeLiquidityETH(token, liquidity, amountTokenMin, amountETHMin, to, deadline);
555     }
556 
557     // **** REMOVE LIQUIDITY (supporting fee-on-transfer tokens) ****
558     function removeLiquidityETHSupportingFeeOnTransferTokens(
559         address token,
560         uint liquidity,
561         uint amountTokenMin,
562         uint amountETHMin,
563         address to,
564         uint deadline
565     ) public virtual override ensure(deadline) returns (uint amountETH) {
566         (, amountETH) = removeLiquidity(
567             token,
568             WETH,
569             liquidity,
570             amountTokenMin,
571             amountETHMin,
572             address(this),
573             deadline
574         );
575         TransferHelper.safeTransfer(token, to, IERC20Uniswap(token).balanceOf(address(this)));
576         IWETH(WETH).withdraw(amountETH);
577         TransferHelper.safeTransferETH(to, amountETH);
578     }
579     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
580         address token,
581         uint liquidity,
582         uint amountTokenMin,
583         uint amountETHMin,
584         address to,
585         uint deadline,
586         bool approveMax, uint8 v, bytes32 r, bytes32 s
587     ) external virtual override returns (uint amountETH) {
588         address pair = UniswapV2Library.pairFor(factory, token, WETH);
589         uint value = approveMax ? uint(-1) : liquidity;
590         IUniswapV2Pair(pair).permit(msg.sender, address(this), value, deadline, v, r, s);
591         amountETH = removeLiquidityETHSupportingFeeOnTransferTokens(
592             token, liquidity, amountTokenMin, amountETHMin, to, deadline
593         );
594     }
595 
596     // **** SWAP ****
597     // requires the initial amount to have already been sent to the first pair
598     function _swap(uint[] memory amounts, address[] memory path, address _to) internal virtual {
599         for (uint i; i < path.length - 1; i++) {
600             (address input, address output) = (path[i], path[i + 1]);
601             (address token0,) = UniswapV2Library.sortTokens(input, output);
602             uint amountOut = amounts[i + 1];
603             (uint amount0Out, uint amount1Out) = input == token0 ? (uint(0), amountOut) : (amountOut, uint(0));
604             address to = i < path.length - 2 ? UniswapV2Library.pairFor(factory, output, path[i + 2]) : _to;
605             IUniswapV2Pair(UniswapV2Library.pairFor(factory, input, output)).swap(
606                 amount0Out, amount1Out, to, new bytes(0)
607             );
608         }
609     }
610     function swapExactTokensForTokens(
611         uint amountIn,
612         uint amountOutMin,
613         address[] calldata path,
614         address to,
615         uint deadline
616     ) external virtual override ensure(deadline) returns (uint[] memory amounts) {
617         amounts = UniswapV2Library.getAmountsOut(factory, amountIn, path, IUniswapV2Factory(factory).feeRate());
618         require(amounts[amounts.length - 1] >= amountOutMin, 'UniswapV2Router: INSUFFICIENT_OUTPUT_AMOUNT');
619         TransferHelper.safeTransferFrom(
620             path[0], msg.sender, UniswapV2Library.pairFor(factory, path[0], path[1]), amounts[0]
621         );
622         _swap(amounts, path, to);
623     }
624     function swapTokensForExactTokens(
625         uint amountOut,
626         uint amountInMax,
627         address[] calldata path,
628         address to,
629         uint deadline
630     ) external virtual override ensure(deadline) returns (uint[] memory amounts) {
631         amounts = UniswapV2Library.getAmountsIn(factory, amountOut, path, IUniswapV2Factory(factory).feeRate());
632         require(amounts[0] <= amountInMax, 'UniswapV2Router: EXCESSIVE_INPUT_AMOUNT');
633         TransferHelper.safeTransferFrom(
634             path[0], msg.sender, UniswapV2Library.pairFor(factory, path[0], path[1]), amounts[0]
635         );
636         _swap(amounts, path, to);
637     }
638     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
639         external
640         virtual
641         override
642         payable
643         ensure(deadline)
644         returns (uint[] memory amounts)
645     {
646         require(path[0] == WETH, 'UniswapV2Router: INVALID_PATH');
647         amounts = UniswapV2Library.getAmountsOut(factory, msg.value, path, IUniswapV2Factory(factory).feeRate());
648         require(amounts[amounts.length - 1] >= amountOutMin, 'UniswapV2Router: INSUFFICIENT_OUTPUT_AMOUNT');
649         IWETH(WETH).deposit{value: amounts[0]}();
650         assert(IWETH(WETH).transfer(UniswapV2Library.pairFor(factory, path[0], path[1]), amounts[0]));
651         _swap(amounts, path, to);
652     }
653     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
654         external
655         virtual
656         override
657         ensure(deadline)
658         returns (uint[] memory amounts)
659     {
660         require(path[path.length - 1] == WETH, 'UniswapV2Router: INVALID_PATH');
661         amounts = UniswapV2Library.getAmountsIn(factory, amountOut, path, IUniswapV2Factory(factory).feeRate());
662         require(amounts[0] <= amountInMax, 'UniswapV2Router: EXCESSIVE_INPUT_AMOUNT');
663         TransferHelper.safeTransferFrom(
664             path[0], msg.sender, UniswapV2Library.pairFor(factory, path[0], path[1]), amounts[0]
665         );
666         _swap(amounts, path, address(this));
667         IWETH(WETH).withdraw(amounts[amounts.length - 1]);
668         TransferHelper.safeTransferETH(to, amounts[amounts.length - 1]);
669     }
670     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
671         external
672         virtual
673         override
674         ensure(deadline)
675         returns (uint[] memory amounts)
676     {
677         require(path[path.length - 1] == WETH, 'UniswapV2Router: INVALID_PATH');
678         amounts = UniswapV2Library.getAmountsOut(factory, amountIn, path, IUniswapV2Factory(factory).feeRate());
679         require(amounts[amounts.length - 1] >= amountOutMin, 'UniswapV2Router: INSUFFICIENT_OUTPUT_AMOUNT');
680         TransferHelper.safeTransferFrom(
681             path[0], msg.sender, UniswapV2Library.pairFor(factory, path[0], path[1]), amounts[0]
682         );
683         _swap(amounts, path, address(this));
684         IWETH(WETH).withdraw(amounts[amounts.length - 1]);
685         TransferHelper.safeTransferETH(to, amounts[amounts.length - 1]);
686     }
687     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
688         external
689         virtual
690         override
691         payable
692         ensure(deadline)
693         returns (uint[] memory amounts)
694     {
695         require(path[0] == WETH, 'UniswapV2Router: INVALID_PATH');
696         amounts = UniswapV2Library.getAmountsIn(factory, amountOut, path, IUniswapV2Factory(factory).feeRate());
697         require(amounts[0] <= msg.value, 'UniswapV2Router: EXCESSIVE_INPUT_AMOUNT');
698         IWETH(WETH).deposit{value: amounts[0]}();
699         assert(IWETH(WETH).transfer(UniswapV2Library.pairFor(factory, path[0], path[1]), amounts[0]));
700         _swap(amounts, path, to);
701         // refund dust eth, if any
702         if (msg.value > amounts[0]) TransferHelper.safeTransferETH(msg.sender, msg.value - amounts[0]);
703     }
704 
705     // **** SWAP (supporting fee-on-transfer tokens) ****
706     // requires the initial amount to have already been sent to the first pair
707     function _swapSupportingFeeOnTransferTokens(address[] memory path, address _to) internal virtual {
708         for (uint i; i < path.length - 1; i++) {
709             (address input, address output) = (path[i], path[i + 1]);
710             (address token0,) = UniswapV2Library.sortTokens(input, output);
711             IUniswapV2Pair pair = IUniswapV2Pair(UniswapV2Library.pairFor(factory, input, output));
712             uint amountInput;
713             uint amountOutput;
714             { // scope to avoid stack too deep errors
715             (uint reserve0, uint reserve1,) = pair.getReserves();
716             (uint reserveInput, uint reserveOutput) = input == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
717             amountInput = IERC20Uniswap(input).balanceOf(address(pair)).sub(reserveInput);
718             amountOutput = UniswapV2Library.getAmountOut(amountInput, reserveInput, reserveOutput, IUniswapV2Factory(factory).feeRate());
719             }
720             (uint amount0Out, uint amount1Out) = input == token0 ? (uint(0), amountOutput) : (amountOutput, uint(0));
721             address to = i < path.length - 2 ? UniswapV2Library.pairFor(factory, output, path[i + 2]) : _to;
722             pair.swap(amount0Out, amount1Out, to, new bytes(0));
723         }
724     }
725     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
726         uint amountIn,
727         uint amountOutMin,
728         address[] calldata path,
729         address to,
730         uint deadline
731     ) external virtual override ensure(deadline) {
732         TransferHelper.safeTransferFrom(
733             path[0], msg.sender, UniswapV2Library.pairFor(factory, path[0], path[1]), amountIn
734         );
735         uint balanceBefore = IERC20Uniswap(path[path.length - 1]).balanceOf(to);
736         _swapSupportingFeeOnTransferTokens(path, to);
737         require(
738             IERC20Uniswap(path[path.length - 1]).balanceOf(to).sub(balanceBefore) >= amountOutMin,
739             'UniswapV2Router: INSUFFICIENT_OUTPUT_AMOUNT'
740         );
741     }
742     function swapExactETHForTokensSupportingFeeOnTransferTokens(
743         uint amountOutMin,
744         address[] calldata path,
745         address to,
746         uint deadline
747     )
748         external
749         virtual
750         override
751         payable
752         ensure(deadline)
753     {
754         require(path[0] == WETH, 'UniswapV2Router: INVALID_PATH');
755         uint amountIn = msg.value;
756         IWETH(WETH).deposit{value: amountIn}();
757         assert(IWETH(WETH).transfer(UniswapV2Library.pairFor(factory, path[0], path[1]), amountIn));
758         uint balanceBefore = IERC20Uniswap(path[path.length - 1]).balanceOf(to);
759         _swapSupportingFeeOnTransferTokens(path, to);
760         require(
761             IERC20Uniswap(path[path.length - 1]).balanceOf(to).sub(balanceBefore) >= amountOutMin,
762             'UniswapV2Router: INSUFFICIENT_OUTPUT_AMOUNT'
763         );
764     }
765     function swapExactTokensForETHSupportingFeeOnTransferTokens(
766         uint amountIn,
767         uint amountOutMin,
768         address[] calldata path,
769         address to,
770         uint deadline
771     )
772         external
773         virtual
774         override
775         ensure(deadline)
776     {
777         require(path[path.length - 1] == WETH, 'UniswapV2Router: INVALID_PATH');
778         TransferHelper.safeTransferFrom(
779             path[0], msg.sender, UniswapV2Library.pairFor(factory, path[0], path[1]), amountIn
780         );
781         _swapSupportingFeeOnTransferTokens(path, address(this));
782         uint amountOut = IERC20Uniswap(WETH).balanceOf(address(this));
783         require(amountOut >= amountOutMin, 'UniswapV2Router: INSUFFICIENT_OUTPUT_AMOUNT');
784         IWETH(WETH).withdraw(amountOut);
785         TransferHelper.safeTransferETH(to, amountOut);
786     }
787 
788     // **** LIBRARY FUNCTIONS ****
789     function quote(uint amountA, uint reserveA, uint reserveB) public pure virtual override returns (uint amountB) {
790         return UniswapV2Library.quote(amountA, reserveA, reserveB);
791     }
792 
793     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut)
794         public
795         view
796         virtual
797         override
798         returns (uint amountOut)
799     {
800         return UniswapV2Library.getAmountOut(amountIn, reserveIn, reserveOut, IUniswapV2Factory(factory).feeRate());
801     }
802 
803     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut)
804         public
805         view
806         virtual
807         override
808         returns (uint amountIn)
809     {
810         return UniswapV2Library.getAmountIn(amountOut, reserveIn, reserveOut, IUniswapV2Factory(factory).feeRate());
811     }
812 
813     function getAmountsOut(uint amountIn, address[] memory path)
814         public
815         view
816         virtual
817         override
818         returns (uint[] memory amounts)
819     {
820         return UniswapV2Library.getAmountsOut(factory, amountIn, path, IUniswapV2Factory(factory).feeRate());
821     }
822 
823     function getAmountsIn(uint amountOut, address[] memory path)
824         public
825         view
826         virtual
827         override
828         returns (uint[] memory amounts)
829     {
830         return UniswapV2Library.getAmountsIn(factory, amountOut, path, IUniswapV2Factory(factory).feeRate());
831     }
832 }