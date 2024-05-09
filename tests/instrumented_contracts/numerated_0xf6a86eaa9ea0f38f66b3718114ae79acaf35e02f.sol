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
99                 hex'1c879dcd3af04306445addd2c308bd4d26010c7ca84c959c3564d4f6957ab20c' // init code hash
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
295     function addLiquidityAndStake(
296         address tokenA,
297         address tokenB,
298         uint amountADesired,
299         uint amountBDesired,
300         uint amountAMin,
301         uint amountBMin,
302         address to,
303         uint deadline,
304         bool burnFee
305     ) external returns (uint amountA, uint amountB, uint liquidity);
306     function addLiquidityETHAndStake(
307         address token,
308         uint amountTokenDesired,
309         uint amountTokenMin,
310         uint amountETHMin,
311         address to,
312         uint deadline,
313         bool burnFee
314     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
315     function removeLiquidityETHSupportingFeeOnTransferTokens(
316         address token,
317         uint liquidity,
318         uint amountTokenMin,
319         uint amountETHMin,
320         address to,
321         uint deadline
322     ) external returns (uint amountETH);
323     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
324         address token,
325         uint liquidity,
326         uint amountTokenMin,
327         uint amountETHMin,
328         address to,
329         uint deadline,
330         bool approveMax, uint8 v, bytes32 r, bytes32 s
331     ) external returns (uint amountETH);
332 
333     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
334         uint amountIn,
335         uint amountOutMin,
336         address[] calldata path,
337         address to,
338         uint deadline
339     ) external;
340     function swapExactETHForTokensSupportingFeeOnTransferTokens(
341         uint amountOutMin,
342         address[] calldata path,
343         address to,
344         uint deadline
345     ) external payable;
346     function swapExactTokensForETHSupportingFeeOnTransferTokens(
347         uint amountIn,
348         uint amountOutMin,
349         address[] calldata path,
350         address to,
351         uint deadline
352     ) external;
353 }
354 
355 // File: contracts/uniswapv2/interfaces/IUniswapV2Factory.sol
356 
357 pragma solidity >=0.5.0;
358 
359 interface IUniswapV2Factory {
360     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
361 
362     // SMARTXXX: function feeTo() external view returns (address);
363     // SMARTXXX: function feeToSetter() external view returns (address);
364     function feeInfoSetter() external view returns (address);
365 
366     function getPair(address tokenA, address tokenB) external view returns (address pair);
367     function allPairs(uint) external view returns (address pair);
368     function allPairsLength() external view returns (uint);
369 
370     function createPair(address tokenA, address tokenB) external returns (address pair);
371 
372     // SMARTXXX: function setFeeTo(address) external;
373     function setFeeInfo(address, uint32, uint32) external;
374     // SMARTXXX: function setFeeToSetter(address) external;
375     function setFeeInfoSetter(address) external;
376 
377     // SMARTXXX: fee info getter
378     function getFeeInfo() external view returns (address, uint32, uint32);
379 }
380 
381 // File: contracts/uniswapv2/interfaces/IERC20.sol
382 
383 pragma solidity >=0.5.0;
384 
385 interface IERC20Uniswap {
386     event Approval(address indexed owner, address indexed spender, uint value);
387     event Transfer(address indexed from, address indexed to, uint value);
388 
389     function name() external view returns (string memory);
390     function symbol() external view returns (string memory);
391     function decimals() external view returns (uint8);
392     function totalSupply() external view returns (uint);
393     function balanceOf(address owner) external view returns (uint);
394     function allowance(address owner, address spender) external view returns (uint);
395 
396     function approve(address spender, uint value) external returns (bool);
397     function transfer(address to, uint value) external returns (bool);
398     function transferFrom(address from, address to, uint value) external returns (bool);
399 }
400 
401 // File: contracts/uniswapv2/interfaces/IWETH.sol
402 
403 pragma solidity >=0.5.0;
404 
405 interface IWETH {
406     function deposit() external payable;
407     function transfer(address to, uint value) external returns (bool);
408     function withdraw(uint) external;
409 }
410 
411 // File: contracts/uniswapv2/UniswapV2Router02.sol
412 
413 pragma solidity =0.6.12;
414 
415 
416 
417 
418 
419 
420 
421 
422 interface IEqualizer {
423     function depositTo(address _token0, address _token1, uint256 _amount, address _to, bool _burnFee) external;
424 }
425 
426 
427 contract UniswapV2Router02 is IUniswapV2Router02 {
428     using SafeMathUniswap for uint;
429 
430     address public immutable override factory;
431     address public immutable override WETH;
432     address public immutable master;
433 
434     modifier ensure(uint deadline) {
435         require(deadline >= block.timestamp, 'UniswapV2Router: EXPIRED');
436         _;
437     }
438 
439     constructor(address _factory, address _master, address _WETH) public {
440         factory = _factory;
441         master = _master;
442         WETH = _WETH;
443     }
444 
445     receive() external payable {
446         assert(msg.sender == WETH); // only accept ETH via fallback from the WETH contract
447     }
448 
449     // **** ADD LIQUIDITY ****
450     function _addLiquidity(
451         address tokenA,
452         address tokenB,
453         uint amountADesired,
454         uint amountBDesired,
455         uint amountAMin,
456         uint amountBMin
457     ) internal virtual returns (uint amountA, uint amountB) {
458         // create the pair if it doesn't exist yet
459         if (IUniswapV2Factory(factory).getPair(tokenA, tokenB) == address(0)) {
460             IUniswapV2Factory(factory).createPair(tokenA, tokenB);
461         }
462         (uint reserveA, uint reserveB) = UniswapV2Library.getReserves(factory, tokenA, tokenB);
463         if (reserveA == 0 && reserveB == 0) {
464             (amountA, amountB) = (amountADesired, amountBDesired);
465         } else {
466             uint amountBOptimal = UniswapV2Library.quote(amountADesired, reserveA, reserveB);
467             if (amountBOptimal <= amountBDesired) {
468                 require(amountBOptimal >= amountBMin, 'UniswapV2Router: INSUFFICIENT_B_AMOUNT');
469                 (amountA, amountB) = (amountADesired, amountBOptimal);
470             } else {
471                 uint amountAOptimal = UniswapV2Library.quote(amountBDesired, reserveB, reserveA);
472                 assert(amountAOptimal <= amountADesired);
473                 require(amountAOptimal >= amountAMin, 'UniswapV2Router: INSUFFICIENT_A_AMOUNT');
474                 (amountA, amountB) = (amountAOptimal, amountBDesired);
475             }
476         }
477     }
478     function addLiquidity(
479         address tokenA,
480         address tokenB,
481         uint amountADesired,
482         uint amountBDesired,
483         uint amountAMin,
484         uint amountBMin,
485         address to,
486         uint deadline
487     ) external virtual override ensure(deadline) returns (uint amountA, uint amountB, uint liquidity) {
488         (amountA, amountB) = _addLiquidity(tokenA, tokenB, amountADesired, amountBDesired, amountAMin, amountBMin);
489         address pair = UniswapV2Library.pairFor(factory, tokenA, tokenB);
490         TransferHelper.safeTransferFrom(tokenA, msg.sender, pair, amountA);
491         TransferHelper.safeTransferFrom(tokenB, msg.sender, pair, amountB);
492         liquidity = IUniswapV2Pair(pair).mint(to);
493     }
494     function addLiquidityETH(
495         address token,
496         uint amountTokenDesired,
497         uint amountTokenMin,
498         uint amountETHMin,
499         address to,
500         uint deadline
501     ) external virtual override payable ensure(deadline) returns (uint amountToken, uint amountETH, uint liquidity) {
502         (amountToken, amountETH) = _addLiquidity(
503             token,
504             WETH,
505             amountTokenDesired,
506             msg.value,
507             amountTokenMin,
508             amountETHMin
509         );
510         address pair = UniswapV2Library.pairFor(factory, token, WETH);
511         TransferHelper.safeTransferFrom(token, msg.sender, pair, amountToken);
512         IWETH(WETH).deposit{value: amountETH}();
513         assert(IWETH(WETH).transfer(pair, amountETH));
514         liquidity = IUniswapV2Pair(pair).mint(to);
515         // refund dust eth, if any
516         if (msg.value > amountETH) TransferHelper.safeTransferETH(msg.sender, msg.value - amountETH);
517     }
518     function addLiquidityAndStake(
519         address tokenA,
520         address tokenB,
521         uint amountADesired,
522         uint amountBDesired,
523         uint amountAMin,
524         uint amountBMin,
525         address to,
526         uint deadline,
527         bool burnFee
528     ) external virtual override ensure(deadline) returns (uint amountA, uint amountB, uint liquidity)
529     {
530         (amountA, amountB) = _addLiquidity(tokenA, tokenB, amountADesired, amountBDesired, amountAMin, amountBMin);
531         address pair = UniswapV2Library.pairFor(factory, tokenA, tokenB);
532         TransferHelper.safeTransferFrom(tokenA, msg.sender, pair, amountA);
533         TransferHelper.safeTransferFrom(tokenB, msg.sender, pair, amountB);
534         liquidity = IUniswapV2Pair(pair).mint(address(this));
535         IUniswapV2Pair(pair).approve(master, liquidity);
536         IEqualizer(master).depositTo(tokenA, tokenB, liquidity, to, burnFee);
537     }
538     function addLiquidityETHAndStake(
539         address token,
540         uint amountTokenDesired,
541         uint amountTokenMin,
542         uint amountETHMin,
543         address to,
544         uint deadline,
545         bool burnFee
546     ) external virtual override payable ensure(deadline) returns (uint amountToken, uint amountETH, uint liquidity)
547     {
548         (amountToken, amountETH) = _addLiquidity(
549             token,
550             WETH,
551             amountTokenDesired,
552             msg.value,
553             amountTokenMin,
554             amountETHMin
555         );
556         address pair = UniswapV2Library.pairFor(factory, token, WETH);
557         TransferHelper.safeTransferFrom(token, msg.sender, pair, amountToken);
558         IWETH(WETH).deposit{value: amountETH}();
559         assert(IWETH(WETH).transfer(pair, amountETH));
560         liquidity = IUniswapV2Pair(pair).mint(address(this));
561         IUniswapV2Pair(pair).approve(master, liquidity);
562         IEqualizer(master).depositTo(token, WETH, liquidity, to, burnFee);
563         // refund dust eth, if any
564         if (msg.value > amountETH) TransferHelper.safeTransferETH(msg.sender, msg.value - amountETH);
565     }
566 
567     // **** REMOVE LIQUIDITY ****
568     function removeLiquidity(
569         address tokenA,
570         address tokenB,
571         uint liquidity,
572         uint amountAMin,
573         uint amountBMin,
574         address to,
575         uint deadline
576     ) public virtual override ensure(deadline) returns (uint amountA, uint amountB) {
577         address pair = UniswapV2Library.pairFor(factory, tokenA, tokenB);
578         IUniswapV2Pair(pair).transferFrom(msg.sender, pair, liquidity); // send liquidity to pair
579         (uint amount0, uint amount1) = IUniswapV2Pair(pair).burn(to);
580         (address token0,) = UniswapV2Library.sortTokens(tokenA, tokenB);
581         (amountA, amountB) = tokenA == token0 ? (amount0, amount1) : (amount1, amount0);
582         require(amountA >= amountAMin, 'UniswapV2Router: INSUFFICIENT_A_AMOUNT');
583         require(amountB >= amountBMin, 'UniswapV2Router: INSUFFICIENT_B_AMOUNT');
584     }
585     function removeLiquidityETH(
586         address token,
587         uint liquidity,
588         uint amountTokenMin,
589         uint amountETHMin,
590         address to,
591         uint deadline
592     ) public virtual override ensure(deadline) returns (uint amountToken, uint amountETH) {
593         (amountToken, amountETH) = removeLiquidity(
594             token,
595             WETH,
596             liquidity,
597             amountTokenMin,
598             amountETHMin,
599             address(this),
600             deadline
601         );
602         TransferHelper.safeTransfer(token, to, amountToken);
603         IWETH(WETH).withdraw(amountETH);
604         TransferHelper.safeTransferETH(to, amountETH);
605     }
606     function removeLiquidityWithPermit(
607         address tokenA,
608         address tokenB,
609         uint liquidity,
610         uint amountAMin,
611         uint amountBMin,
612         address to,
613         uint deadline,
614         bool approveMax, uint8 v, bytes32 r, bytes32 s
615     ) external virtual override returns (uint amountA, uint amountB) {
616         address pair = UniswapV2Library.pairFor(factory, tokenA, tokenB);
617         uint value = approveMax ? uint(-1) : liquidity;
618         IUniswapV2Pair(pair).permit(msg.sender, address(this), value, deadline, v, r, s);
619         (amountA, amountB) = removeLiquidity(tokenA, tokenB, liquidity, amountAMin, amountBMin, to, deadline);
620     }
621     function removeLiquidityETHWithPermit(
622         address token,
623         uint liquidity,
624         uint amountTokenMin,
625         uint amountETHMin,
626         address to,
627         uint deadline,
628         bool approveMax, uint8 v, bytes32 r, bytes32 s
629     ) external virtual override returns (uint amountToken, uint amountETH) {
630         address pair = UniswapV2Library.pairFor(factory, token, WETH);
631         uint value = approveMax ? uint(-1) : liquidity;
632         IUniswapV2Pair(pair).permit(msg.sender, address(this), value, deadline, v, r, s);
633         (amountToken, amountETH) = removeLiquidityETH(token, liquidity, amountTokenMin, amountETHMin, to, deadline);
634     }
635 
636     // **** REMOVE LIQUIDITY (supporting fee-on-transfer tokens) ****
637     function removeLiquidityETHSupportingFeeOnTransferTokens(
638         address token,
639         uint liquidity,
640         uint amountTokenMin,
641         uint amountETHMin,
642         address to,
643         uint deadline
644     ) public virtual override ensure(deadline) returns (uint amountETH) {
645         (, amountETH) = removeLiquidity(
646             token,
647             WETH,
648             liquidity,
649             amountTokenMin,
650             amountETHMin,
651             address(this),
652             deadline
653         );
654         TransferHelper.safeTransfer(token, to, IERC20Uniswap(token).balanceOf(address(this)));
655         IWETH(WETH).withdraw(amountETH);
656         TransferHelper.safeTransferETH(to, amountETH);
657     }
658     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
659         address token,
660         uint liquidity,
661         uint amountTokenMin,
662         uint amountETHMin,
663         address to,
664         uint deadline,
665         bool approveMax, uint8 v, bytes32 r, bytes32 s
666     ) external virtual override returns (uint amountETH) {
667         address pair = UniswapV2Library.pairFor(factory, token, WETH);
668         uint value = approveMax ? uint(-1) : liquidity;
669         IUniswapV2Pair(pair).permit(msg.sender, address(this), value, deadline, v, r, s);
670         amountETH = removeLiquidityETHSupportingFeeOnTransferTokens(
671             token, liquidity, amountTokenMin, amountETHMin, to, deadline
672         );
673     }
674 
675     // **** SWAP ****
676     // requires the initial amount to have already been sent to the first pair
677     function _swap(uint[] memory amounts, address[] memory path, address _to) internal virtual {
678         for (uint i; i < path.length - 1; i++) {
679             (address input, address output) = (path[i], path[i + 1]);
680             (address token0,) = UniswapV2Library.sortTokens(input, output);
681             uint amountOut = amounts[i + 1];
682             (uint amount0Out, uint amount1Out) = input == token0 ? (uint(0), amountOut) : (amountOut, uint(0));
683             address to = i < path.length - 2 ? UniswapV2Library.pairFor(factory, output, path[i + 2]) : _to;
684             IUniswapV2Pair(UniswapV2Library.pairFor(factory, input, output)).swap(
685                 amount0Out, amount1Out, to, new bytes(0)
686             );
687         }
688     }
689     function swapExactTokensForTokens(
690         uint amountIn,
691         uint amountOutMin,
692         address[] calldata path,
693         address to,
694         uint deadline
695     ) external virtual override ensure(deadline) returns (uint[] memory amounts) {
696         amounts = UniswapV2Library.getAmountsOut(factory, amountIn, path);
697         require(amounts[amounts.length - 1] >= amountOutMin, 'UniswapV2Router: INSUFFICIENT_OUTPUT_AMOUNT');
698         TransferHelper.safeTransferFrom(
699             path[0], msg.sender, UniswapV2Library.pairFor(factory, path[0], path[1]), amounts[0]
700         );
701         _swap(amounts, path, to);
702     }
703     function swapTokensForExactTokens(
704         uint amountOut,
705         uint amountInMax,
706         address[] calldata path,
707         address to,
708         uint deadline
709     ) external virtual override ensure(deadline) returns (uint[] memory amounts) {
710         amounts = UniswapV2Library.getAmountsIn(factory, amountOut, path);
711         require(amounts[0] <= amountInMax, 'UniswapV2Router: EXCESSIVE_INPUT_AMOUNT');
712         TransferHelper.safeTransferFrom(
713             path[0], msg.sender, UniswapV2Library.pairFor(factory, path[0], path[1]), amounts[0]
714         );
715         _swap(amounts, path, to);
716     }
717     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
718         external
719         virtual
720         override
721         payable
722         ensure(deadline)
723         returns (uint[] memory amounts)
724     {
725         require(path[0] == WETH, 'UniswapV2Router: INVALID_PATH');
726         amounts = UniswapV2Library.getAmountsOut(factory, msg.value, path);
727         require(amounts[amounts.length - 1] >= amountOutMin, 'UniswapV2Router: INSUFFICIENT_OUTPUT_AMOUNT');
728         IWETH(WETH).deposit{value: amounts[0]}();
729         assert(IWETH(WETH).transfer(UniswapV2Library.pairFor(factory, path[0], path[1]), amounts[0]));
730         _swap(amounts, path, to);
731     }
732     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
733         external
734         virtual
735         override
736         ensure(deadline)
737         returns (uint[] memory amounts)
738     {
739         require(path[path.length - 1] == WETH, 'UniswapV2Router: INVALID_PATH');
740         amounts = UniswapV2Library.getAmountsIn(factory, amountOut, path);
741         require(amounts[0] <= amountInMax, 'UniswapV2Router: EXCESSIVE_INPUT_AMOUNT');
742         TransferHelper.safeTransferFrom(
743             path[0], msg.sender, UniswapV2Library.pairFor(factory, path[0], path[1]), amounts[0]
744         );
745         _swap(amounts, path, address(this));
746         IWETH(WETH).withdraw(amounts[amounts.length - 1]);
747         TransferHelper.safeTransferETH(to, amounts[amounts.length - 1]);
748     }
749     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
750         external
751         virtual
752         override
753         ensure(deadline)
754         returns (uint[] memory amounts)
755     {
756         require(path[path.length - 1] == WETH, 'UniswapV2Router: INVALID_PATH');
757         amounts = UniswapV2Library.getAmountsOut(factory, amountIn, path);
758         require(amounts[amounts.length - 1] >= amountOutMin, 'UniswapV2Router: INSUFFICIENT_OUTPUT_AMOUNT');
759         TransferHelper.safeTransferFrom(
760             path[0], msg.sender, UniswapV2Library.pairFor(factory, path[0], path[1]), amounts[0]
761         );
762         _swap(amounts, path, address(this));
763         IWETH(WETH).withdraw(amounts[amounts.length - 1]);
764         TransferHelper.safeTransferETH(to, amounts[amounts.length - 1]);
765     }
766     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
767         external
768         virtual
769         override
770         payable
771         ensure(deadline)
772         returns (uint[] memory amounts)
773     {
774         require(path[0] == WETH, 'UniswapV2Router: INVALID_PATH');
775         amounts = UniswapV2Library.getAmountsIn(factory, amountOut, path);
776         require(amounts[0] <= msg.value, 'UniswapV2Router: EXCESSIVE_INPUT_AMOUNT');
777         IWETH(WETH).deposit{value: amounts[0]}();
778         assert(IWETH(WETH).transfer(UniswapV2Library.pairFor(factory, path[0], path[1]), amounts[0]));
779         _swap(amounts, path, to);
780         // refund dust eth, if any
781         if (msg.value > amounts[0]) TransferHelper.safeTransferETH(msg.sender, msg.value - amounts[0]);
782     }
783 
784     // **** SWAP (supporting fee-on-transfer tokens) ****
785     // requires the initial amount to have already been sent to the first pair
786     function _swapSupportingFeeOnTransferTokens(address[] memory path, address _to) internal virtual {
787         for (uint i; i < path.length - 1; i++) {
788             (address input, address output) = (path[i], path[i + 1]);
789             (address token0,) = UniswapV2Library.sortTokens(input, output);
790             IUniswapV2Pair pair = IUniswapV2Pair(UniswapV2Library.pairFor(factory, input, output));
791             uint amountInput;
792             uint amountOutput;
793             { // scope to avoid stack too deep errors
794             (uint reserve0, uint reserve1,) = pair.getReserves();
795             (uint reserveInput, uint reserveOutput) = input == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
796             amountInput = IERC20Uniswap(input).balanceOf(address(pair)).sub(reserveInput);
797             amountOutput = UniswapV2Library.getAmountOut(amountInput, reserveInput, reserveOutput);
798             }
799             (uint amount0Out, uint amount1Out) = input == token0 ? (uint(0), amountOutput) : (amountOutput, uint(0));
800             address to = i < path.length - 2 ? UniswapV2Library.pairFor(factory, output, path[i + 2]) : _to;
801             pair.swap(amount0Out, amount1Out, to, new bytes(0));
802         }
803     }
804     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
805         uint amountIn,
806         uint amountOutMin,
807         address[] calldata path,
808         address to,
809         uint deadline
810     ) external virtual override ensure(deadline) {
811         TransferHelper.safeTransferFrom(
812             path[0], msg.sender, UniswapV2Library.pairFor(factory, path[0], path[1]), amountIn
813         );
814         uint balanceBefore = IERC20Uniswap(path[path.length - 1]).balanceOf(to);
815         _swapSupportingFeeOnTransferTokens(path, to);
816         require(
817             IERC20Uniswap(path[path.length - 1]).balanceOf(to).sub(balanceBefore) >= amountOutMin,
818             'UniswapV2Router: INSUFFICIENT_OUTPUT_AMOUNT'
819         );
820     }
821     function swapExactETHForTokensSupportingFeeOnTransferTokens(
822         uint amountOutMin,
823         address[] calldata path,
824         address to,
825         uint deadline
826     )
827         external
828         virtual
829         override
830         payable
831         ensure(deadline)
832     {
833         require(path[0] == WETH, 'UniswapV2Router: INVALID_PATH');
834         uint amountIn = msg.value;
835         IWETH(WETH).deposit{value: amountIn}();
836         assert(IWETH(WETH).transfer(UniswapV2Library.pairFor(factory, path[0], path[1]), amountIn));
837         uint balanceBefore = IERC20Uniswap(path[path.length - 1]).balanceOf(to);
838         _swapSupportingFeeOnTransferTokens(path, to);
839         require(
840             IERC20Uniswap(path[path.length - 1]).balanceOf(to).sub(balanceBefore) >= amountOutMin,
841             'UniswapV2Router: INSUFFICIENT_OUTPUT_AMOUNT'
842         );
843     }
844     function swapExactTokensForETHSupportingFeeOnTransferTokens(
845         uint amountIn,
846         uint amountOutMin,
847         address[] calldata path,
848         address to,
849         uint deadline
850     )
851         external
852         virtual
853         override
854         ensure(deadline)
855     {
856         require(path[path.length - 1] == WETH, 'UniswapV2Router: INVALID_PATH');
857         TransferHelper.safeTransferFrom(
858             path[0], msg.sender, UniswapV2Library.pairFor(factory, path[0], path[1]), amountIn
859         );
860         _swapSupportingFeeOnTransferTokens(path, address(this));
861         uint amountOut = IERC20Uniswap(WETH).balanceOf(address(this));
862         require(amountOut >= amountOutMin, 'UniswapV2Router: INSUFFICIENT_OUTPUT_AMOUNT');
863         IWETH(WETH).withdraw(amountOut);
864         TransferHelper.safeTransferETH(to, amountOut);
865     }
866 
867     // **** LIBRARY FUNCTIONS ****
868     function quote(uint amountA, uint reserveA, uint reserveB) public pure virtual override returns (uint amountB) {
869         return UniswapV2Library.quote(amountA, reserveA, reserveB);
870     }
871 
872     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut)
873         public
874         pure
875         virtual
876         override
877         returns (uint amountOut)
878     {
879         return UniswapV2Library.getAmountOut(amountIn, reserveIn, reserveOut);
880     }
881 
882     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut)
883         public
884         pure
885         virtual
886         override
887         returns (uint amountIn)
888     {
889         return UniswapV2Library.getAmountIn(amountOut, reserveIn, reserveOut);
890     }
891 
892     function getAmountsOut(uint amountIn, address[] memory path)
893         public
894         view
895         virtual
896         override
897         returns (uint[] memory amounts)
898     {
899         return UniswapV2Library.getAmountsOut(factory, amountIn, path);
900     }
901 
902     function getAmountsIn(uint amountOut, address[] memory path)
903         public
904         view
905         virtual
906         override
907         returns (uint[] memory amounts)
908     {
909         return UniswapV2Library.getAmountsIn(factory, amountOut, path);
910     }
911 }