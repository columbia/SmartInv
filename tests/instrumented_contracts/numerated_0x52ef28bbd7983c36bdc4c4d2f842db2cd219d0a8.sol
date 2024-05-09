1 // File: contracts/uniswapv2/interfaces/IUniswapV2Pair.sol
2 
3 pragma solidity >=0.5.0;
4 
5 interface IUniswapV2Pair {
6     event Approval(address indexed owner, address indexed spender, uint value);
7     event Transfer(address indexed from, address indexed to, uint value);
8 
9     function name() external pure returns (string memory);
10     function symbol() external pure returns (string memory);
11     function decimals() external pure returns (uint8);
12     function totalSupply() external view returns (uint);
13     function balanceOf(address owner) external view returns (uint);
14     function allowance(address owner, address spender) external view returns (uint);
15 
16     function approve(address spender, uint value) external returns (bool);
17     function transfer(address to, uint value) external returns (bool);
18     function transferFrom(address from, address to, uint value) external returns (bool);
19 
20     function DOMAIN_SEPARATOR() external view returns (bytes32);
21     function PERMIT_TYPEHASH() external pure returns (bytes32);
22     function nonces(address owner) external view returns (uint);
23 
24     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
25 
26     event Mint(address indexed sender, uint amount0, uint amount1);
27     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
28     event Swap(
29         address indexed sender,
30         uint amount0In,
31         uint amount1In,
32         uint amount0Out,
33         uint amount1Out,
34         address indexed to
35     );
36     event Sync(uint112 reserve0, uint112 reserve1);
37 
38     function MINIMUM_LIQUIDITY() external pure returns (uint);
39     function factory() external view returns (address);
40     function token0() external view returns (address);
41     function token1() external view returns (address);
42     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
43     function price0CumulativeLast() external view returns (uint);
44     function price1CumulativeLast() external view returns (uint);
45     function kLast() external view returns (uint);
46 
47     function mint(address to) external returns (uint liquidity);
48     function burn(address to) external returns (uint amount0, uint amount1);
49     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
50     function skim(address to) external;
51     function sync() external;
52 
53     function initialize(address, address) external;
54 }
55 
56 // File: contracts/uniswapv2/libraries/SafeMath.sol
57 
58 pragma solidity =0.6.12;
59 
60 // a library for performing overflow-safe math, courtesy of DappHub (https://github.com/dapphub/ds-math)
61 
62 library SafeMathUniswap {
63     function add(uint x, uint y) internal pure returns (uint z) {
64         require((z = x + y) >= x, 'ds-math-add-overflow');
65     }
66 
67     function sub(uint x, uint y) internal pure returns (uint z) {
68         require((z = x - y) <= x, 'ds-math-sub-underflow');
69     }
70 
71     function mul(uint x, uint y) internal pure returns (uint z) {
72         require(y == 0 || (z = x * y) / y == x, 'ds-math-mul-overflow');
73     }
74 }
75 
76 // File: contracts/uniswapv2/libraries/UniswapV2Library.sol
77 
78 pragma solidity >=0.5.0;
79 
80 
81 
82 library UniswapV2Library {
83     using SafeMathUniswap for uint;
84 
85     // returns sorted token addresses, used to handle return values from pairs sorted in this order
86     function sortTokens(address tokenA, address tokenB) internal pure returns (address token0, address token1) {
87         require(tokenA != tokenB, 'UniswapV2Library: IDENTICAL_ADDRESSES');
88         (token0, token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
89         require(token0 != address(0), 'UniswapV2Library: ZERO_ADDRESS');
90     }
91 
92     // calculates the CREATE2 address for a pair without making any external calls
93     function pairFor(address factory, address tokenA, address tokenB) internal pure returns (address pair) {
94         (address token0, address token1) = sortTokens(tokenA, tokenB);
95         pair = address(uint(keccak256(abi.encodePacked(
96                 hex'ff',
97                 factory,
98                 keccak256(abi.encodePacked(token0, token1)),
99                 hex'b5c5cbb243a92796f04631c8a3a4119cdc108843616e70ff792d33b8db749dcc' // init code hash
100             ))));
101     }
102 
103     // fetches and sorts the reserves for a pair
104     function getReserves(address factory, address tokenA, address tokenB) internal view returns (uint reserveA, uint reserveB) {
105         (address token0,) = sortTokens(tokenA, tokenB);
106         (uint reserve0, uint reserve1,) = IUniswapV2Pair(pairFor(factory, tokenA, tokenB)).getReserves();
107         (reserveA, reserveB) = tokenA == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
108     }
109 
110     // given some amount of an asset and pair reserves, returns an equivalent amount of the other asset
111     function quote(uint amountA, uint reserveA, uint reserveB) internal pure returns (uint amountB) {
112         require(amountA > 0, 'UniswapV2Library: INSUFFICIENT_AMOUNT');
113         require(reserveA > 0 && reserveB > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
114         amountB = amountA.mul(reserveB) / reserveA;
115     }
116 
117     // given an input amount of an asset and pair reserves, returns the maximum output amount of the other asset
118     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) internal pure returns (uint amountOut) {
119         require(amountIn > 0, 'UniswapV2Library: INSUFFICIENT_INPUT_AMOUNT');
120         require(reserveIn > 0 && reserveOut > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
121         uint amountInWithFee = amountIn.mul(997);
122         uint numerator = amountInWithFee.mul(reserveOut);
123         uint denominator = reserveIn.mul(1000).add(amountInWithFee);
124         amountOut = numerator / denominator;
125     }
126 
127     // given an output amount of an asset and pair reserves, returns a required input amount of the other asset
128     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) internal pure returns (uint amountIn) {
129         require(amountOut > 0, 'UniswapV2Library: INSUFFICIENT_OUTPUT_AMOUNT');
130         require(reserveIn > 0 && reserveOut > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
131         uint numerator = reserveIn.mul(amountOut).mul(1000);
132         uint denominator = reserveOut.sub(amountOut).mul(997);
133         amountIn = (numerator / denominator).add(1);
134     }
135 
136     // performs chained getAmountOut calculations on any number of pairs
137     function getAmountsOut(address factory, uint amountIn, address[] memory path) internal view returns (uint[] memory amounts) {
138         require(path.length >= 2, 'UniswapV2Library: INVALID_PATH');
139         amounts = new uint[](path.length);
140         amounts[0] = amountIn;
141         for (uint i; i < path.length - 1; i++) {
142             (uint reserveIn, uint reserveOut) = getReserves(factory, path[i], path[i + 1]);
143             amounts[i + 1] = getAmountOut(amounts[i], reserveIn, reserveOut);
144         }
145     }
146 
147     // performs chained getAmountIn calculations on any number of pairs
148     function getAmountsIn(address factory, uint amountOut, address[] memory path) internal view returns (uint[] memory amounts) {
149         require(path.length >= 2, 'UniswapV2Library: INVALID_PATH');
150         amounts = new uint[](path.length);
151         amounts[amounts.length - 1] = amountOut;
152         for (uint i = path.length - 1; i > 0; i--) {
153             (uint reserveIn, uint reserveOut) = getReserves(factory, path[i - 1], path[i]);
154             amounts[i - 1] = getAmountIn(amounts[i], reserveIn, reserveOut);
155         }
156     }
157 }
158 
159 // File: contracts/uniswapv2/libraries/TransferHelper.sol
160 
161 // SPDX-License-Identifier: GPL-3.0-or-later
162 
163 pragma solidity >=0.6.0;
164 
165 // helper methods for interacting with ERC20 tokens and sending ETH that do not consistently return true/false
166 library TransferHelper {
167     function safeApprove(address token, address to, uint value) internal {
168         // bytes4(keccak256(bytes('approve(address,uint256)')));
169         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x095ea7b3, to, value));
170         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: APPROVE_FAILED');
171     }
172 
173     function safeTransfer(address token, address to, uint value) internal {
174         // bytes4(keccak256(bytes('transfer(address,uint256)')));
175         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));
176         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FAILED');
177     }
178 
179     function safeTransferFrom(address token, address from, address to, uint value) internal {
180         // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
181         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));
182         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FROM_FAILED');
183     }
184 
185     function safeTransferETH(address to, uint value) internal {
186         (bool success,) = to.call{value:value}(new bytes(0));
187         require(success, 'TransferHelper: ETH_TRANSFER_FAILED');
188     }
189 }
190 
191 // File: contracts/uniswapv2/interfaces/IUniswapV2Router01.sol
192 
193 pragma solidity >=0.6.2;
194 
195 interface IUniswapV2Router01 {
196     function factory() external pure returns (address);
197     function WETH() external pure returns (address);
198 
199     function addLiquidity(
200         address tokenA,
201         address tokenB,
202         uint amountADesired,
203         uint amountBDesired,
204         uint amountAMin,
205         uint amountBMin,
206         address to,
207         uint deadline
208     ) external returns (uint amountA, uint amountB, uint liquidity);
209     function addLiquidityETH(
210         address token,
211         uint amountTokenDesired,
212         uint amountTokenMin,
213         uint amountETHMin,
214         address to,
215         uint deadline
216     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
217     function removeLiquidity(
218         address tokenA,
219         address tokenB,
220         uint liquidity,
221         uint amountAMin,
222         uint amountBMin,
223         address to,
224         uint deadline
225     ) external returns (uint amountA, uint amountB);
226     function removeLiquidityETH(
227         address token,
228         uint liquidity,
229         uint amountTokenMin,
230         uint amountETHMin,
231         address to,
232         uint deadline
233     ) external returns (uint amountToken, uint amountETH);
234     function removeLiquidityWithPermit(
235         address tokenA,
236         address tokenB,
237         uint liquidity,
238         uint amountAMin,
239         uint amountBMin,
240         address to,
241         uint deadline,
242         bool approveMax, uint8 v, bytes32 r, bytes32 s
243     ) external returns (uint amountA, uint amountB);
244     function removeLiquidityETHWithPermit(
245         address token,
246         uint liquidity,
247         uint amountTokenMin,
248         uint amountETHMin,
249         address to,
250         uint deadline,
251         bool approveMax, uint8 v, bytes32 r, bytes32 s
252     ) external returns (uint amountToken, uint amountETH);
253     function swapExactTokensForTokens(
254         uint amountIn,
255         uint amountOutMin,
256         address[] calldata path,
257         address to,
258         uint deadline
259     ) external returns (uint[] memory amounts);
260     function swapTokensForExactTokens(
261         uint amountOut,
262         uint amountInMax,
263         address[] calldata path,
264         address to,
265         uint deadline
266     ) external returns (uint[] memory amounts);
267     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
268         external
269         payable
270         returns (uint[] memory amounts);
271     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
272         external
273         returns (uint[] memory amounts);
274     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
275         external
276         returns (uint[] memory amounts);
277     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
278         external
279         payable
280         returns (uint[] memory amounts);
281 
282     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
283     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
284     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
285     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
286     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
287 }
288 
289 // File: contracts/uniswapv2/interfaces/IUniswapV2Router02.sol
290 
291 pragma solidity >=0.6.2;
292 
293 
294 interface IUniswapV2Router02 is IUniswapV2Router01 {
295     function removeLiquidityETHSupportingFeeOnTransferTokens(
296         address token,
297         uint liquidity,
298         uint amountTokenMin,
299         uint amountETHMin,
300         address to,
301         uint deadline
302     ) external returns (uint amountETH);
303     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
304         address token,
305         uint liquidity,
306         uint amountTokenMin,
307         uint amountETHMin,
308         address to,
309         uint deadline,
310         bool approveMax, uint8 v, bytes32 r, bytes32 s
311     ) external returns (uint amountETH);
312 
313     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
314         uint amountIn,
315         uint amountOutMin,
316         address[] calldata path,
317         address to,
318         uint deadline
319     ) external;
320     function swapExactETHForTokensSupportingFeeOnTransferTokens(
321         uint amountOutMin,
322         address[] calldata path,
323         address to,
324         uint deadline
325     ) external payable;
326     function swapExactTokensForETHSupportingFeeOnTransferTokens(
327         uint amountIn,
328         uint amountOutMin,
329         address[] calldata path,
330         address to,
331         uint deadline
332     ) external;
333 }
334 
335 // File: contracts/uniswapv2/interfaces/IUniswapV2Factory.sol
336 
337 pragma solidity >=0.5.0;
338 
339 interface IUniswapV2Factory {
340     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
341 
342     function feeTo() external view returns (address);
343     function feeToSetter() external view returns (address);
344     function migrator() external view returns (address);
345 
346     function getPair(address tokenA, address tokenB) external view returns (address pair);
347     function allPairs(uint) external view returns (address pair);
348     function allPairsLength() external view returns (uint);
349 
350     function createPair(address tokenA, address tokenB) external returns (address pair);
351 
352     function setFeeTo(address) external;
353     function setFeeToSetter(address) external;
354     function setMigrator(address) external;
355 }
356 
357 // File: contracts/uniswapv2/interfaces/IERC20.sol
358 
359 pragma solidity >=0.5.0;
360 
361 interface IERC20Uniswap {
362     event Approval(address indexed owner, address indexed spender, uint value);
363     event Transfer(address indexed from, address indexed to, uint value);
364 
365     function name() external view returns (string memory);
366     function symbol() external view returns (string memory);
367     function decimals() external view returns (uint8);
368     function totalSupply() external view returns (uint);
369     function balanceOf(address owner) external view returns (uint);
370     function allowance(address owner, address spender) external view returns (uint);
371 
372     function approve(address spender, uint value) external returns (bool);
373     function transfer(address to, uint value) external returns (bool);
374     function transferFrom(address from, address to, uint value) external returns (bool);
375 }
376 
377 // File: contracts/uniswapv2/interfaces/IWETH.sol
378 
379 pragma solidity >=0.5.0;
380 
381 interface IWETH {
382     function deposit() external payable;
383     function transfer(address to, uint value) external returns (bool);
384     function withdraw(uint) external;
385 }
386 
387 // File: contracts/uniswapv2/UniswapV2Router02.sol
388 
389 pragma solidity =0.6.12;
390 
391 
392 
393 
394 
395 
396 
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
617         amounts = UniswapV2Library.getAmountsOut(factory, amountIn, path);
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
631         amounts = UniswapV2Library.getAmountsIn(factory, amountOut, path);
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
647         amounts = UniswapV2Library.getAmountsOut(factory, msg.value, path);
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
661         amounts = UniswapV2Library.getAmountsIn(factory, amountOut, path);
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
678         amounts = UniswapV2Library.getAmountsOut(factory, amountIn, path);
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
696         amounts = UniswapV2Library.getAmountsIn(factory, amountOut, path);
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
718             amountOutput = UniswapV2Library.getAmountOut(amountInput, reserveInput, reserveOutput);
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
795         pure
796         virtual
797         override
798         returns (uint amountOut)
799     {
800         return UniswapV2Library.getAmountOut(amountIn, reserveIn, reserveOut);
801     }
802 
803     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut)
804         public
805         pure
806         virtual
807         override
808         returns (uint amountIn)
809     {
810         return UniswapV2Library.getAmountIn(amountOut, reserveIn, reserveOut);
811     }
812 
813     function getAmountsOut(uint amountIn, address[] memory path)
814         public
815         view
816         virtual
817         override
818         returns (uint[] memory amounts)
819     {
820         return UniswapV2Library.getAmountsOut(factory, amountIn, path);
821     }
822 
823     function getAmountsIn(uint amountOut, address[] memory path)
824         public
825         view
826         virtual
827         override
828         returns (uint[] memory amounts)
829     {
830         return UniswapV2Library.getAmountsIn(factory, amountOut, path);
831     }
832 }