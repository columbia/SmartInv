1 // SPDX-License-Identifier: MIT + WTFPL
2 
3 
4 // File: contracts/uniswapv2/interfaces/IUniswapV2Pair.sol
5 
6 pragma solidity >=0.5.0;
7 
8 interface IUniswapV2Pair {
9     event Approval(address indexed owner, address indexed spender, uint value);
10     event Transfer(address indexed from, address indexed to, uint value);
11 
12     function name() external pure returns (string memory);
13     function symbol() external pure returns (string memory);
14     function decimals() external pure returns (uint8);
15     function totalSupply() external view returns (uint);
16     function balanceOf(address owner) external view returns (uint);
17     function allowance(address owner, address spender) external view returns (uint);
18 
19     function approve(address spender, uint value) external returns (bool);
20     function transfer(address to, uint value) external returns (bool);
21     function transferFrom(address from, address to, uint value) external returns (bool);
22 
23     function DOMAIN_SEPARATOR() external view returns (bytes32);
24     function PERMIT_TYPEHASH() external pure returns (bytes32);
25     function nonces(address owner) external view returns (uint);
26 
27     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
28 
29     event Mint(address indexed sender, uint amount0, uint amount1);
30     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
31     event Swap(
32         address indexed sender,
33         uint amount0In,
34         uint amount1In,
35         uint amount0Out,
36         uint amount1Out,
37         address indexed to
38     );
39     event Sync(uint112 reserve0, uint112 reserve1);
40 
41     function MINIMUM_LIQUIDITY() external pure returns (uint);
42     function factory() external view returns (address);
43     function token0() external view returns (address);
44     function token1() external view returns (address);
45     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
46     function price0CumulativeLast() external view returns (uint);
47     function price1CumulativeLast() external view returns (uint);
48     function kLast() external view returns (uint);
49 
50     function mint(address to) external returns (uint liquidity);
51     function burn(address to) external returns (uint amount0, uint amount1);
52     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
53     function skim(address to) external;
54     function sync() external;
55 
56     function initialize(address, address) external;
57 }
58 
59 // File: contracts/uniswapv2/libraries/SafeMath.sol
60 
61 pragma solidity =0.6.12;
62 
63 // a library for performing overflow-safe math, courtesy of DappHub (https://github.com/dapphub/ds-math)
64 
65 library SafeMathUniswap {
66     function add(uint x, uint y) internal pure returns (uint z) {
67         require((z = x + y) >= x, 'ds-math-add-overflow');
68     }
69 
70     function sub(uint x, uint y) internal pure returns (uint z) {
71         require((z = x - y) <= x, 'ds-math-sub-underflow');
72     }
73 
74     function mul(uint x, uint y) internal pure returns (uint z) {
75         require(y == 0 || (z = x * y) / y == x, 'ds-math-mul-overflow');
76     }
77 }
78 
79 // File: contracts/uniswapv2/libraries/UniswapV2Library.sol
80 
81 pragma solidity >=0.5.0;
82 
83 
84 
85 library UniswapV2Library {
86     using SafeMathUniswap for uint;
87 
88     // returns sorted token addresses, used to handle return values from pairs sorted in this order
89     function sortTokens(address tokenA, address tokenB) internal pure returns (address token0, address token1) {
90         require(tokenA != tokenB, 'UniswapV2Library: IDENTICAL_ADDRESSES');
91         (token0, token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
92         require(token0 != address(0), 'UniswapV2Library: ZERO_ADDRESS');
93     }
94 
95     // calculates the CREATE2 address for a pair without making any external calls
96     function pairFor(address factory, address tokenA, address tokenB) internal pure returns (address pair) {
97         (address token0, address token1) = sortTokens(tokenA, tokenB);
98         pair = address(uint(keccak256(abi.encodePacked(
99                 hex'ff',
100                 factory,
101                 keccak256(abi.encodePacked(token0, token1)),
102                 hex'5ba571870cabbb0abe0328915192960c6813c0a4e84883307a126bc19fa69614' // init code hash
103             ))));
104     }
105 
106     // fetches and sorts the reserves for a pair
107     function getReserves(address factory, address tokenA, address tokenB) internal view returns (uint reserveA, uint reserveB) {
108         (address token0,) = sortTokens(tokenA, tokenB);
109         (uint reserve0, uint reserve1,) = IUniswapV2Pair(pairFor(factory, tokenA, tokenB)).getReserves();
110         (reserveA, reserveB) = tokenA == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
111     }
112 
113     // given some amount of an asset and pair reserves, returns an equivalent amount of the other asset
114     function quote(uint amountA, uint reserveA, uint reserveB) internal pure returns (uint amountB) {
115         require(amountA > 0, 'UniswapV2Library: INSUFFICIENT_AMOUNT');
116         require(reserveA > 0 && reserveB > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
117         amountB = amountA.mul(reserveB) / reserveA;
118     }
119 
120     // given an input amount of an asset and pair reserves, returns the maximum output amount of the other asset
121     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) internal pure returns (uint amountOut) {
122         require(amountIn > 0, 'UniswapV2Library: INSUFFICIENT_INPUT_AMOUNT');
123         require(reserveIn > 0 && reserveOut > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
124         uint amountInWithFee = amountIn.mul(997);
125         uint numerator = amountInWithFee.mul(reserveOut);
126         uint denominator = reserveIn.mul(1000).add(amountInWithFee);
127         amountOut = numerator / denominator;
128     }
129 
130     // given an output amount of an asset and pair reserves, returns a required input amount of the other asset
131     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) internal pure returns (uint amountIn) {
132         require(amountOut > 0, 'UniswapV2Library: INSUFFICIENT_OUTPUT_AMOUNT');
133         require(reserveIn > 0 && reserveOut > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
134         uint numerator = reserveIn.mul(amountOut).mul(1000);
135         uint denominator = reserveOut.sub(amountOut).mul(997);
136         amountIn = (numerator / denominator).add(1);
137     }
138 
139     // performs chained getAmountOut calculations on any number of pairs
140     function getAmountsOut(address factory, uint amountIn, address[] memory path) internal view returns (uint[] memory amounts) {
141         require(path.length >= 2, 'UniswapV2Library: INVALID_PATH');
142         amounts = new uint[](path.length);
143         amounts[0] = amountIn;
144         for (uint i; i < path.length - 1; i++) {
145             (uint reserveIn, uint reserveOut) = getReserves(factory, path[i], path[i + 1]);
146             amounts[i + 1] = getAmountOut(amounts[i], reserveIn, reserveOut);
147         }
148     }
149 
150     // performs chained getAmountIn calculations on any number of pairs
151     function getAmountsIn(address factory, uint amountOut, address[] memory path) internal view returns (uint[] memory amounts) {
152         require(path.length >= 2, 'UniswapV2Library: INVALID_PATH');
153         amounts = new uint[](path.length);
154         amounts[amounts.length - 1] = amountOut;
155         for (uint i = path.length - 1; i > 0; i--) {
156             (uint reserveIn, uint reserveOut) = getReserves(factory, path[i - 1], path[i]);
157             amounts[i - 1] = getAmountIn(amounts[i], reserveIn, reserveOut);
158         }
159     }
160 }
161 
162 // File: contracts/uniswapv2/libraries/TransferHelper.sol
163 
164 
165 
166 pragma solidity >=0.6.0;
167 
168 // helper methods for interacting with ERC20 tokens and sending ETH that do not consistently return true/false
169 library TransferHelper {
170     function safeApprove(address token, address to, uint value) internal {
171         // bytes4(keccak256(bytes('approve(address,uint256)')));
172         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x095ea7b3, to, value));
173         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: APPROVE_FAILED');
174     }
175 
176     function safeTransfer(address token, address to, uint value) internal {
177         // bytes4(keccak256(bytes('transfer(address,uint256)')));
178         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));
179         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FAILED');
180     }
181 
182     function safeTransferFrom(address token, address from, address to, uint value) internal {
183         // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
184         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));
185         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FROM_FAILED');
186     }
187 
188     function safeTransferETH(address to, uint value) internal {
189         (bool success,) = to.call{value:value}(new bytes(0));
190         require(success, 'TransferHelper: ETH_TRANSFER_FAILED');
191     }
192 }
193 
194 // File: contracts/uniswapv2/interfaces/IUniswapV2Router01.sol
195 
196 pragma solidity >=0.6.2;
197 
198 interface IUniswapV2Router01 {
199     function factory() external pure returns (address);
200     function WETH() external pure returns (address);
201 
202     function addLiquidity(
203         address tokenA,
204         address tokenB,
205         uint amountADesired,
206         uint amountBDesired,
207         uint amountAMin,
208         uint amountBMin,
209         address to,
210         uint deadline
211     ) external returns (uint amountA, uint amountB, uint liquidity);
212     function addLiquidityETH(
213         address token,
214         uint amountTokenDesired,
215         uint amountTokenMin,
216         uint amountETHMin,
217         address to,
218         uint deadline
219     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
220     function removeLiquidity(
221         address tokenA,
222         address tokenB,
223         uint liquidity,
224         uint amountAMin,
225         uint amountBMin,
226         address to,
227         uint deadline
228     ) external returns (uint amountA, uint amountB);
229     function removeLiquidityETH(
230         address token,
231         uint liquidity,
232         uint amountTokenMin,
233         uint amountETHMin,
234         address to,
235         uint deadline
236     ) external returns (uint amountToken, uint amountETH);
237     function removeLiquidityWithPermit(
238         address tokenA,
239         address tokenB,
240         uint liquidity,
241         uint amountAMin,
242         uint amountBMin,
243         address to,
244         uint deadline,
245         bool approveMax, uint8 v, bytes32 r, bytes32 s
246     ) external returns (uint amountA, uint amountB);
247     function removeLiquidityETHWithPermit(
248         address token,
249         uint liquidity,
250         uint amountTokenMin,
251         uint amountETHMin,
252         address to,
253         uint deadline,
254         bool approveMax, uint8 v, bytes32 r, bytes32 s
255     ) external returns (uint amountToken, uint amountETH);
256     function swapExactTokensForTokens(
257         uint amountIn,
258         uint amountOutMin,
259         address[] calldata path,
260         address to,
261         uint deadline
262     ) external returns (uint[] memory amounts);
263     function swapTokensForExactTokens(
264         uint amountOut,
265         uint amountInMax,
266         address[] calldata path,
267         address to,
268         uint deadline
269     ) external returns (uint[] memory amounts);
270     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
271         external
272         payable
273         returns (uint[] memory amounts);
274     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
275         external
276         returns (uint[] memory amounts);
277     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
278         external
279         returns (uint[] memory amounts);
280     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
281         external
282         payable
283         returns (uint[] memory amounts);
284 
285     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
286     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
287     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
288     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
289     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
290 }
291 
292 // File: contracts/uniswapv2/interfaces/IUniswapV2Router02.sol
293 
294 pragma solidity >=0.6.2;
295 
296 
297 interface IUniswapV2Router02 is IUniswapV2Router01 {
298     function removeLiquidityETHSupportingFeeOnTransferTokens(
299         address token,
300         uint liquidity,
301         uint amountTokenMin,
302         uint amountETHMin,
303         address to,
304         uint deadline
305     ) external returns (uint amountETH);
306     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
307         address token,
308         uint liquidity,
309         uint amountTokenMin,
310         uint amountETHMin,
311         address to,
312         uint deadline,
313         bool approveMax, uint8 v, bytes32 r, bytes32 s
314     ) external returns (uint amountETH);
315 
316     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
317         uint amountIn,
318         uint amountOutMin,
319         address[] calldata path,
320         address to,
321         uint deadline
322     ) external;
323     function swapExactETHForTokensSupportingFeeOnTransferTokens(
324         uint amountOutMin,
325         address[] calldata path,
326         address to,
327         uint deadline
328     ) external payable;
329     function swapExactTokensForETHSupportingFeeOnTransferTokens(
330         uint amountIn,
331         uint amountOutMin,
332         address[] calldata path,
333         address to,
334         uint deadline
335     ) external;
336 }
337 
338 // File: contracts/uniswapv2/interfaces/IUniswapV2Factory.sol
339 
340 pragma solidity >=0.5.0;
341 
342 interface IUniswapV2Factory {
343     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
344 
345     function feeTo() external view returns (address);
346     function feeToSetter() external view returns (address);
347     function migrator() external view returns (address);
348 
349     function getPair(address tokenA, address tokenB) external view returns (address pair);
350     function allPairs(uint) external view returns (address pair);
351     function allPairsLength() external view returns (uint);
352 
353     function createPair(address tokenA, address tokenB) external returns (address pair);
354 
355     function setFeeTo(address) external;
356     function setFeeToSetter(address) external;
357     function setMigrator(address) external;
358 }
359 
360 // File: contracts/uniswapv2/interfaces/IERC20.sol
361 
362 pragma solidity >=0.5.0;
363 
364 interface IERC20Uniswap {
365     event Approval(address indexed owner, address indexed spender, uint value);
366     event Transfer(address indexed from, address indexed to, uint value);
367 
368     function name() external view returns (string memory);
369     function symbol() external view returns (string memory);
370     function decimals() external view returns (uint8);
371     function totalSupply() external view returns (uint);
372     function balanceOf(address owner) external view returns (uint);
373     function allowance(address owner, address spender) external view returns (uint);
374 
375     function approve(address spender, uint value) external returns (bool);
376     function transfer(address to, uint value) external returns (bool);
377     function transferFrom(address from, address to, uint value) external returns (bool);
378 }
379 
380 // File: contracts/uniswapv2/interfaces/IWETH.sol
381 
382 pragma solidity >=0.5.0;
383 
384 interface IWETH {
385     function deposit() external payable;
386     function transfer(address to, uint value) external returns (bool);
387     function withdraw(uint) external;
388 }
389 
390 // File: contracts/uniswapv2/UniswapV2Router02.sol
391 
392 pragma solidity =0.6.12;
393 
394 
395 
396 
397 
398 
399 
400 
401 contract UniswapV2Router02 is IUniswapV2Router02 {
402     using SafeMathUniswap for uint;
403 
404     address public immutable override factory;
405     address public immutable override WETH;
406 
407     modifier ensure(uint deadline) {
408         require(deadline >= block.timestamp, 'UniswapV2Router: EXPIRED');
409         _;
410     }
411 
412     constructor(address _factory, address _WETH) public {
413         factory = _factory;
414         WETH = _WETH;
415     }
416 
417     receive() external payable {
418         assert(msg.sender == WETH); // only accept ETH via fallback from the WETH contract
419     }
420 
421     // **** ADD LIQUIDITY ****
422     function _addLiquidity(
423         address tokenA,
424         address tokenB,
425         uint amountADesired,
426         uint amountBDesired,
427         uint amountAMin,
428         uint amountBMin
429     ) internal virtual returns (uint amountA, uint amountB) {
430         // create the pair if it doesn't exist yet
431         if (IUniswapV2Factory(factory).getPair(tokenA, tokenB) == address(0)) {
432             IUniswapV2Factory(factory).createPair(tokenA, tokenB);
433         }
434         (uint reserveA, uint reserveB) = UniswapV2Library.getReserves(factory, tokenA, tokenB);
435         if (reserveA == 0 && reserveB == 0) {
436             (amountA, amountB) = (amountADesired, amountBDesired);
437         } else {
438             uint amountBOptimal = UniswapV2Library.quote(amountADesired, reserveA, reserveB);
439             if (amountBOptimal <= amountBDesired) {
440                 require(amountBOptimal >= amountBMin, 'UniswapV2Router: INSUFFICIENT_B_AMOUNT');
441                 (amountA, amountB) = (amountADesired, amountBOptimal);
442             } else {
443                 uint amountAOptimal = UniswapV2Library.quote(amountBDesired, reserveB, reserveA);
444                 assert(amountAOptimal <= amountADesired);
445                 require(amountAOptimal >= amountAMin, 'UniswapV2Router: INSUFFICIENT_A_AMOUNT');
446                 (amountA, amountB) = (amountAOptimal, amountBDesired);
447             }
448         }
449     }
450     function addLiquidity(
451         address tokenA,
452         address tokenB,
453         uint amountADesired,
454         uint amountBDesired,
455         uint amountAMin,
456         uint amountBMin,
457         address to,
458         uint deadline
459     ) external virtual override ensure(deadline) returns (uint amountA, uint amountB, uint liquidity) {
460         (amountA, amountB) = _addLiquidity(tokenA, tokenB, amountADesired, amountBDesired, amountAMin, amountBMin);
461         address pair = UniswapV2Library.pairFor(factory, tokenA, tokenB);
462         TransferHelper.safeTransferFrom(tokenA, msg.sender, pair, amountA);
463         TransferHelper.safeTransferFrom(tokenB, msg.sender, pair, amountB);
464         liquidity = IUniswapV2Pair(pair).mint(to);
465     }
466     function addLiquidityETH(
467         address token,
468         uint amountTokenDesired,
469         uint amountTokenMin,
470         uint amountETHMin,
471         address to,
472         uint deadline
473     ) external virtual override payable ensure(deadline) returns (uint amountToken, uint amountETH, uint liquidity) {
474         (amountToken, amountETH) = _addLiquidity(
475             token,
476             WETH,
477             amountTokenDesired,
478             msg.value,
479             amountTokenMin,
480             amountETHMin
481         );
482         address pair = UniswapV2Library.pairFor(factory, token, WETH);
483         TransferHelper.safeTransferFrom(token, msg.sender, pair, amountToken);
484         IWETH(WETH).deposit{value: amountETH}();
485         assert(IWETH(WETH).transfer(pair, amountETH));
486         liquidity = IUniswapV2Pair(pair).mint(to);
487         // refund dust eth, if any
488         if (msg.value > amountETH) TransferHelper.safeTransferETH(msg.sender, msg.value - amountETH);
489     }
490 
491     // **** REMOVE LIQUIDITY ****
492     function removeLiquidity(
493         address tokenA,
494         address tokenB,
495         uint liquidity,
496         uint amountAMin,
497         uint amountBMin,
498         address to,
499         uint deadline
500     ) public virtual override ensure(deadline) returns (uint amountA, uint amountB) {
501         address pair = UniswapV2Library.pairFor(factory, tokenA, tokenB);
502         IUniswapV2Pair(pair).transferFrom(msg.sender, pair, liquidity); // send liquidity to pair
503         (uint amount0, uint amount1) = IUniswapV2Pair(pair).burn(to);
504         (address token0,) = UniswapV2Library.sortTokens(tokenA, tokenB);
505         (amountA, amountB) = tokenA == token0 ? (amount0, amount1) : (amount1, amount0);
506         require(amountA >= amountAMin, 'UniswapV2Router: INSUFFICIENT_A_AMOUNT');
507         require(amountB >= amountBMin, 'UniswapV2Router: INSUFFICIENT_B_AMOUNT');
508     }
509     function removeLiquidityETH(
510         address token,
511         uint liquidity,
512         uint amountTokenMin,
513         uint amountETHMin,
514         address to,
515         uint deadline
516     ) public virtual override ensure(deadline) returns (uint amountToken, uint amountETH) {
517         (amountToken, amountETH) = removeLiquidity(
518             token,
519             WETH,
520             liquidity,
521             amountTokenMin,
522             amountETHMin,
523             address(this),
524             deadline
525         );
526         TransferHelper.safeTransfer(token, to, amountToken);
527         IWETH(WETH).withdraw(amountETH);
528         TransferHelper.safeTransferETH(to, amountETH);
529     }
530     function removeLiquidityWithPermit(
531         address tokenA,
532         address tokenB,
533         uint liquidity,
534         uint amountAMin,
535         uint amountBMin,
536         address to,
537         uint deadline,
538         bool approveMax, uint8 v, bytes32 r, bytes32 s
539     ) external virtual override returns (uint amountA, uint amountB) {
540         address pair = UniswapV2Library.pairFor(factory, tokenA, tokenB);
541         uint value = approveMax ? uint(-1) : liquidity;
542         IUniswapV2Pair(pair).permit(msg.sender, address(this), value, deadline, v, r, s);
543         (amountA, amountB) = removeLiquidity(tokenA, tokenB, liquidity, amountAMin, amountBMin, to, deadline);
544     }
545     function removeLiquidityETHWithPermit(
546         address token,
547         uint liquidity,
548         uint amountTokenMin,
549         uint amountETHMin,
550         address to,
551         uint deadline,
552         bool approveMax, uint8 v, bytes32 r, bytes32 s
553     ) external virtual override returns (uint amountToken, uint amountETH) {
554         address pair = UniswapV2Library.pairFor(factory, token, WETH);
555         uint value = approveMax ? uint(-1) : liquidity;
556         IUniswapV2Pair(pair).permit(msg.sender, address(this), value, deadline, v, r, s);
557         (amountToken, amountETH) = removeLiquidityETH(token, liquidity, amountTokenMin, amountETHMin, to, deadline);
558     }
559 
560     // **** REMOVE LIQUIDITY (supporting fee-on-transfer tokens) ****
561     function removeLiquidityETHSupportingFeeOnTransferTokens(
562         address token,
563         uint liquidity,
564         uint amountTokenMin,
565         uint amountETHMin,
566         address to,
567         uint deadline
568     ) public virtual override ensure(deadline) returns (uint amountETH) {
569         (, amountETH) = removeLiquidity(
570             token,
571             WETH,
572             liquidity,
573             amountTokenMin,
574             amountETHMin,
575             address(this),
576             deadline
577         );
578         TransferHelper.safeTransfer(token, to, IERC20Uniswap(token).balanceOf(address(this)));
579         IWETH(WETH).withdraw(amountETH);
580         TransferHelper.safeTransferETH(to, amountETH);
581     }
582     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
583         address token,
584         uint liquidity,
585         uint amountTokenMin,
586         uint amountETHMin,
587         address to,
588         uint deadline,
589         bool approveMax, uint8 v, bytes32 r, bytes32 s
590     ) external virtual override returns (uint amountETH) {
591         address pair = UniswapV2Library.pairFor(factory, token, WETH);
592         uint value = approveMax ? uint(-1) : liquidity;
593         IUniswapV2Pair(pair).permit(msg.sender, address(this), value, deadline, v, r, s);
594         amountETH = removeLiquidityETHSupportingFeeOnTransferTokens(
595             token, liquidity, amountTokenMin, amountETHMin, to, deadline
596         );
597     }
598 
599     // **** SWAP ****
600     // requires the initial amount to have already been sent to the first pair
601     function _swap(uint[] memory amounts, address[] memory path, address _to) internal virtual {
602         for (uint i; i < path.length - 1; i++) {
603             (address input, address output) = (path[i], path[i + 1]);
604             (address token0,) = UniswapV2Library.sortTokens(input, output);
605             uint amountOut = amounts[i + 1];
606             (uint amount0Out, uint amount1Out) = input == token0 ? (uint(0), amountOut) : (amountOut, uint(0));
607             address to = i < path.length - 2 ? UniswapV2Library.pairFor(factory, output, path[i + 2]) : _to;
608             IUniswapV2Pair(UniswapV2Library.pairFor(factory, input, output)).swap(
609                 amount0Out, amount1Out, to, new bytes(0)
610             );
611         }
612     }
613     function swapExactTokensForTokens(
614         uint amountIn,
615         uint amountOutMin,
616         address[] calldata path,
617         address to,
618         uint deadline
619     ) external virtual override ensure(deadline) returns (uint[] memory amounts) {
620         amounts = UniswapV2Library.getAmountsOut(factory, amountIn, path);
621         require(amounts[amounts.length - 1] >= amountOutMin, 'UniswapV2Router: INSUFFICIENT_OUTPUT_AMOUNT');
622         TransferHelper.safeTransferFrom(
623             path[0], msg.sender, UniswapV2Library.pairFor(factory, path[0], path[1]), amounts[0]
624         );
625         _swap(amounts, path, to);
626     }
627     function swapTokensForExactTokens(
628         uint amountOut,
629         uint amountInMax,
630         address[] calldata path,
631         address to,
632         uint deadline
633     ) external virtual override ensure(deadline) returns (uint[] memory amounts) {
634         amounts = UniswapV2Library.getAmountsIn(factory, amountOut, path);
635         require(amounts[0] <= amountInMax, 'UniswapV2Router: EXCESSIVE_INPUT_AMOUNT');
636         TransferHelper.safeTransferFrom(
637             path[0], msg.sender, UniswapV2Library.pairFor(factory, path[0], path[1]), amounts[0]
638         );
639         _swap(amounts, path, to);
640     }
641     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
642         external
643         virtual
644         override
645         payable
646         ensure(deadline)
647         returns (uint[] memory amounts)
648     {
649         require(path[0] == WETH, 'UniswapV2Router: INVALID_PATH');
650         amounts = UniswapV2Library.getAmountsOut(factory, msg.value, path);
651         require(amounts[amounts.length - 1] >= amountOutMin, 'UniswapV2Router: INSUFFICIENT_OUTPUT_AMOUNT');
652         IWETH(WETH).deposit{value: amounts[0]}();
653         assert(IWETH(WETH).transfer(UniswapV2Library.pairFor(factory, path[0], path[1]), amounts[0]));
654         _swap(amounts, path, to);
655     }
656     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
657         external
658         virtual
659         override
660         ensure(deadline)
661         returns (uint[] memory amounts)
662     {
663         require(path[path.length - 1] == WETH, 'UniswapV2Router: INVALID_PATH');
664         amounts = UniswapV2Library.getAmountsIn(factory, amountOut, path);
665         require(amounts[0] <= amountInMax, 'UniswapV2Router: EXCESSIVE_INPUT_AMOUNT');
666         TransferHelper.safeTransferFrom(
667             path[0], msg.sender, UniswapV2Library.pairFor(factory, path[0], path[1]), amounts[0]
668         );
669         _swap(amounts, path, address(this));
670         IWETH(WETH).withdraw(amounts[amounts.length - 1]);
671         TransferHelper.safeTransferETH(to, amounts[amounts.length - 1]);
672     }
673     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
674         external
675         virtual
676         override
677         ensure(deadline)
678         returns (uint[] memory amounts)
679     {
680         require(path[path.length - 1] == WETH, 'UniswapV2Router: INVALID_PATH');
681         amounts = UniswapV2Library.getAmountsOut(factory, amountIn, path);
682         require(amounts[amounts.length - 1] >= amountOutMin, 'UniswapV2Router: INSUFFICIENT_OUTPUT_AMOUNT');
683         TransferHelper.safeTransferFrom(
684             path[0], msg.sender, UniswapV2Library.pairFor(factory, path[0], path[1]), amounts[0]
685         );
686         _swap(amounts, path, address(this));
687         IWETH(WETH).withdraw(amounts[amounts.length - 1]);
688         TransferHelper.safeTransferETH(to, amounts[amounts.length - 1]);
689     }
690     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
691         external
692         virtual
693         override
694         payable
695         ensure(deadline)
696         returns (uint[] memory amounts)
697     {
698         require(path[0] == WETH, 'UniswapV2Router: INVALID_PATH');
699         amounts = UniswapV2Library.getAmountsIn(factory, amountOut, path);
700         require(amounts[0] <= msg.value, 'UniswapV2Router: EXCESSIVE_INPUT_AMOUNT');
701         IWETH(WETH).deposit{value: amounts[0]}();
702         assert(IWETH(WETH).transfer(UniswapV2Library.pairFor(factory, path[0], path[1]), amounts[0]));
703         _swap(amounts, path, to);
704         // refund dust eth, if any
705         if (msg.value > amounts[0]) TransferHelper.safeTransferETH(msg.sender, msg.value - amounts[0]);
706     }
707 
708     // **** SWAP (supporting fee-on-transfer tokens) ****
709     // requires the initial amount to have already been sent to the first pair
710     function _swapSupportingFeeOnTransferTokens(address[] memory path, address _to) internal virtual {
711         for (uint i; i < path.length - 1; i++) {
712             (address input, address output) = (path[i], path[i + 1]);
713             (address token0,) = UniswapV2Library.sortTokens(input, output);
714             IUniswapV2Pair pair = IUniswapV2Pair(UniswapV2Library.pairFor(factory, input, output));
715             uint amountInput;
716             uint amountOutput;
717             { // scope to avoid stack too deep errors
718             (uint reserve0, uint reserve1,) = pair.getReserves();
719             (uint reserveInput, uint reserveOutput) = input == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
720             amountInput = IERC20Uniswap(input).balanceOf(address(pair)).sub(reserveInput);
721             amountOutput = UniswapV2Library.getAmountOut(amountInput, reserveInput, reserveOutput);
722             }
723             (uint amount0Out, uint amount1Out) = input == token0 ? (uint(0), amountOutput) : (amountOutput, uint(0));
724             address to = i < path.length - 2 ? UniswapV2Library.pairFor(factory, output, path[i + 2]) : _to;
725             pair.swap(amount0Out, amount1Out, to, new bytes(0));
726         }
727     }
728     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
729         uint amountIn,
730         uint amountOutMin,
731         address[] calldata path,
732         address to,
733         uint deadline
734     ) external virtual override ensure(deadline) {
735         TransferHelper.safeTransferFrom(
736             path[0], msg.sender, UniswapV2Library.pairFor(factory, path[0], path[1]), amountIn
737         );
738         uint balanceBefore = IERC20Uniswap(path[path.length - 1]).balanceOf(to);
739         _swapSupportingFeeOnTransferTokens(path, to);
740         require(
741             IERC20Uniswap(path[path.length - 1]).balanceOf(to).sub(balanceBefore) >= amountOutMin,
742             'UniswapV2Router: INSUFFICIENT_OUTPUT_AMOUNT'
743         );
744     }
745     function swapExactETHForTokensSupportingFeeOnTransferTokens(
746         uint amountOutMin,
747         address[] calldata path,
748         address to,
749         uint deadline
750     )
751         external
752         virtual
753         override
754         payable
755         ensure(deadline)
756     {
757         require(path[0] == WETH, 'UniswapV2Router: INVALID_PATH');
758         uint amountIn = msg.value;
759         IWETH(WETH).deposit{value: amountIn}();
760         assert(IWETH(WETH).transfer(UniswapV2Library.pairFor(factory, path[0], path[1]), amountIn));
761         uint balanceBefore = IERC20Uniswap(path[path.length - 1]).balanceOf(to);
762         _swapSupportingFeeOnTransferTokens(path, to);
763         require(
764             IERC20Uniswap(path[path.length - 1]).balanceOf(to).sub(balanceBefore) >= amountOutMin,
765             'UniswapV2Router: INSUFFICIENT_OUTPUT_AMOUNT'
766         );
767     }
768     function swapExactTokensForETHSupportingFeeOnTransferTokens(
769         uint amountIn,
770         uint amountOutMin,
771         address[] calldata path,
772         address to,
773         uint deadline
774     )
775         external
776         virtual
777         override
778         ensure(deadline)
779     {
780         require(path[path.length - 1] == WETH, 'UniswapV2Router: INVALID_PATH');
781         TransferHelper.safeTransferFrom(
782             path[0], msg.sender, UniswapV2Library.pairFor(factory, path[0], path[1]), amountIn
783         );
784         _swapSupportingFeeOnTransferTokens(path, address(this));
785         uint amountOut = IERC20Uniswap(WETH).balanceOf(address(this));
786         require(amountOut >= amountOutMin, 'UniswapV2Router: INSUFFICIENT_OUTPUT_AMOUNT');
787         IWETH(WETH).withdraw(amountOut);
788         TransferHelper.safeTransferETH(to, amountOut);
789     }
790 
791     // **** LIBRARY FUNCTIONS ****
792     function quote(uint amountA, uint reserveA, uint reserveB) public pure virtual override returns (uint amountB) {
793         return UniswapV2Library.quote(amountA, reserveA, reserveB);
794     }
795 
796     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut)
797         public
798         pure
799         virtual
800         override
801         returns (uint amountOut)
802     {
803         return UniswapV2Library.getAmountOut(amountIn, reserveIn, reserveOut);
804     }
805 
806     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut)
807         public
808         pure
809         virtual
810         override
811         returns (uint amountIn)
812     {
813         return UniswapV2Library.getAmountIn(amountOut, reserveIn, reserveOut);
814     }
815 
816     function getAmountsOut(uint amountIn, address[] memory path)
817         public
818         view
819         virtual
820         override
821         returns (uint[] memory amounts)
822     {
823         return UniswapV2Library.getAmountsOut(factory, amountIn, path);
824     }
825 
826     function getAmountsIn(uint amountOut, address[] memory path)
827         public
828         view
829         virtual
830         override
831         returns (uint[] memory amounts)
832     {
833         return UniswapV2Library.getAmountsIn(factory, amountOut, path);
834     }
835 }