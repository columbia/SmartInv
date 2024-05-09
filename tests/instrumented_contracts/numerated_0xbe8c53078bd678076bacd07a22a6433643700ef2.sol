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
58 pragma solidity >=0.6.0;
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
99                 hex'428feead4bc5e2c26e92d219cf69bda842c86d6c27530d4d2fcc2e3e36b66fc1' // init code hash
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
121         uint amountInWithFee = amountIn.mul(995);
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
132         uint denominator = reserveOut.sub(amountOut).mul(995);
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
344     function feeRate() external view returns (uint);
345 
346     function getPair(address tokenA, address tokenB) external view returns (address pair);
347     function allPairs(uint) external view returns (address pair);
348     function allPairsLength() external view returns (uint);
349 
350     function allowedTokens(address) external view returns(bool);
351 
352     function createPair(address tokenA, address tokenB) external returns (address pair);
353 
354     function setFeeTo(address) external;
355     function setFeeToSetter(address) external;
356     function setFeeRate(uint) external;
357 
358     function addAllowdPair(address) external;
359 }
360 
361 // File: contracts/uniswapv2/interfaces/IERC20.sol
362 
363 pragma solidity >=0.5.0;
364 
365 interface IERC20Uniswap {
366     event Approval(address indexed owner, address indexed spender, uint value);
367     event Transfer(address indexed from, address indexed to, uint value);
368 
369     function name() external view returns (string memory);
370     function symbol() external view returns (string memory);
371     function decimals() external view returns (uint8);
372     function totalSupply() external view returns (uint);
373     function balanceOf(address owner) external view returns (uint);
374     function allowance(address owner, address spender) external view returns (uint);
375 
376     function approve(address spender, uint value) external returns (bool);
377     function transfer(address to, uint value) external returns (bool);
378     function transferFrom(address from, address to, uint value) external returns (bool);
379 }
380 
381 // File: contracts/uniswapv2/interfaces/IWETH.sol
382 
383 pragma solidity >=0.5.0;
384 
385 interface IWETH {
386     function deposit() external payable;
387     function transfer(address to, uint value) external returns (bool);
388     function withdraw(uint) external;
389 }
390 
391 // File: contracts/uniswapv2/UniswapV2Router02.sol
392 
393 pragma solidity >=0.6.0;
394 
395 
396 
397 
398 
399 
400 
401 
402 contract UniswapV2Router02 is IUniswapV2Router02 {
403     using SafeMathUniswap for uint;
404 
405     address public immutable override factory;
406     address public immutable override WETH;
407 
408     modifier ensure(uint deadline) {
409         require(deadline >= block.timestamp, 'UniswapV2Router: EXPIRED');
410         _;
411     }
412 
413     constructor(address _factory, address _WETH) public {
414         factory = _factory;
415         WETH = _WETH;
416     }
417 
418     receive() external payable {
419         assert(msg.sender == WETH); // only accept ETH via fallback from the WETH contract
420     }
421 
422     // **** ADD LIQUIDITY ****
423     function _addLiquidity(
424         address tokenA,
425         address tokenB,
426         uint amountADesired,
427         uint amountBDesired,
428         uint amountAMin,
429         uint amountBMin
430     ) internal virtual returns (uint amountA, uint amountB) {
431         // create the pair if it doesn't exist yet
432         if (IUniswapV2Factory(factory).getPair(tokenA, tokenB) == address(0)) {
433             IUniswapV2Factory(factory).createPair(tokenA, tokenB);
434         }
435         (uint reserveA, uint reserveB) = UniswapV2Library.getReserves(factory, tokenA, tokenB);
436         if (reserveA == 0 && reserveB == 0) {
437             (amountA, amountB) = (amountADesired, amountBDesired);
438         } else {
439             uint amountBOptimal = UniswapV2Library.quote(amountADesired, reserveA, reserveB);
440             if (amountBOptimal <= amountBDesired) {
441                 require(amountBOptimal >= amountBMin, 'UniswapV2Router: INSUFFICIENT_B_AMOUNT');
442                 (amountA, amountB) = (amountADesired, amountBOptimal);
443             } else {
444                 uint amountAOptimal = UniswapV2Library.quote(amountBDesired, reserveB, reserveA);
445                 assert(amountAOptimal <= amountADesired);
446                 require(amountAOptimal >= amountAMin, 'UniswapV2Router: INSUFFICIENT_A_AMOUNT');
447                 (amountA, amountB) = (amountAOptimal, amountBDesired);
448             }
449         }
450     }
451     function addLiquidity(
452         address tokenA,
453         address tokenB,
454         uint amountADesired,
455         uint amountBDesired,
456         uint amountAMin,
457         uint amountBMin,
458         address to,
459         uint deadline
460     ) external virtual override ensure(deadline) returns (uint amountA, uint amountB, uint liquidity) {
461         (amountA, amountB) = _addLiquidity(tokenA, tokenB, amountADesired, amountBDesired, amountAMin, amountBMin);
462         address pair = UniswapV2Library.pairFor(factory, tokenA, tokenB);
463         TransferHelper.safeTransferFrom(tokenA, msg.sender, pair, amountA);
464         TransferHelper.safeTransferFrom(tokenB, msg.sender, pair, amountB);
465         liquidity = IUniswapV2Pair(pair).mint(to);
466     }
467     function addLiquidityETH(
468         address token,
469         uint amountTokenDesired,
470         uint amountTokenMin,
471         uint amountETHMin,
472         address to,
473         uint deadline
474     ) external virtual override payable ensure(deadline) returns (uint amountToken, uint amountETH, uint liquidity) {
475         (amountToken, amountETH) = _addLiquidity(
476             token,
477             WETH,
478             amountTokenDesired,
479             msg.value,
480             amountTokenMin,
481             amountETHMin
482         );
483         address pair = UniswapV2Library.pairFor(factory, token, WETH);
484         TransferHelper.safeTransferFrom(token, msg.sender, pair, amountToken);
485         IWETH(WETH).deposit{value: amountETH}();
486         assert(IWETH(WETH).transfer(pair, amountETH));
487         liquidity = IUniswapV2Pair(pair).mint(to);
488         // refund dust eth, if any
489         if (msg.value > amountETH) TransferHelper.safeTransferETH(msg.sender, msg.value - amountETH);
490     }
491 
492     // **** REMOVE LIQUIDITY ****
493     function removeLiquidity(
494         address tokenA,
495         address tokenB,
496         uint liquidity,
497         uint amountAMin,
498         uint amountBMin,
499         address to,
500         uint deadline
501     ) public virtual override ensure(deadline) returns (uint amountA, uint amountB) {
502         address pair = UniswapV2Library.pairFor(factory, tokenA, tokenB);
503         IUniswapV2Pair(pair).transferFrom(msg.sender, pair, liquidity); // send liquidity to pair
504         (uint amount0, uint amount1) = IUniswapV2Pair(pair).burn(to);
505         (address token0,) = UniswapV2Library.sortTokens(tokenA, tokenB);
506         (amountA, amountB) = tokenA == token0 ? (amount0, amount1) : (amount1, amount0);
507         require(amountA >= amountAMin, 'UniswapV2Router: INSUFFICIENT_A_AMOUNT');
508         require(amountB >= amountBMin, 'UniswapV2Router: INSUFFICIENT_B_AMOUNT');
509     }
510     function removeLiquidityETH(
511         address token,
512         uint liquidity,
513         uint amountTokenMin,
514         uint amountETHMin,
515         address to,
516         uint deadline
517     ) public virtual override ensure(deadline) returns (uint amountToken, uint amountETH) {
518         (amountToken, amountETH) = removeLiquidity(
519             token,
520             WETH,
521             liquidity,
522             amountTokenMin,
523             amountETHMin,
524             address(this),
525             deadline
526         );
527         TransferHelper.safeTransfer(token, to, amountToken);
528         IWETH(WETH).withdraw(amountETH);
529         TransferHelper.safeTransferETH(to, amountETH);
530     }
531     function removeLiquidityWithPermit(
532         address tokenA,
533         address tokenB,
534         uint liquidity,
535         uint amountAMin,
536         uint amountBMin,
537         address to,
538         uint deadline,
539         bool approveMax, uint8 v, bytes32 r, bytes32 s
540     ) external virtual override returns (uint amountA, uint amountB) {
541         address pair = UniswapV2Library.pairFor(factory, tokenA, tokenB);
542         uint value = approveMax ? uint(-1) : liquidity;
543         IUniswapV2Pair(pair).permit(msg.sender, address(this), value, deadline, v, r, s);
544         (amountA, amountB) = removeLiquidity(tokenA, tokenB, liquidity, amountAMin, amountBMin, to, deadline);
545     }
546     function removeLiquidityETHWithPermit(
547         address token,
548         uint liquidity,
549         uint amountTokenMin,
550         uint amountETHMin,
551         address to,
552         uint deadline,
553         bool approveMax, uint8 v, bytes32 r, bytes32 s
554     ) external virtual override returns (uint amountToken, uint amountETH) {
555         address pair = UniswapV2Library.pairFor(factory, token, WETH);
556         uint value = approveMax ? uint(-1) : liquidity;
557         IUniswapV2Pair(pair).permit(msg.sender, address(this), value, deadline, v, r, s);
558         (amountToken, amountETH) = removeLiquidityETH(token, liquidity, amountTokenMin, amountETHMin, to, deadline);
559     }
560 
561     // **** REMOVE LIQUIDITY (supporting fee-on-transfer tokens) ****
562     function removeLiquidityETHSupportingFeeOnTransferTokens(
563         address token,
564         uint liquidity,
565         uint amountTokenMin,
566         uint amountETHMin,
567         address to,
568         uint deadline
569     ) public virtual override ensure(deadline) returns (uint amountETH) {
570         (, amountETH) = removeLiquidity(
571             token,
572             WETH,
573             liquidity,
574             amountTokenMin,
575             amountETHMin,
576             address(this),
577             deadline
578         );
579         TransferHelper.safeTransfer(token, to, IERC20Uniswap(token).balanceOf(address(this)));
580         IWETH(WETH).withdraw(amountETH);
581         TransferHelper.safeTransferETH(to, amountETH);
582     }
583     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
584         address token,
585         uint liquidity,
586         uint amountTokenMin,
587         uint amountETHMin,
588         address to,
589         uint deadline,
590         bool approveMax, uint8 v, bytes32 r, bytes32 s
591     ) external virtual override returns (uint amountETH) {
592         address pair = UniswapV2Library.pairFor(factory, token, WETH);
593         uint value = approveMax ? uint(-1) : liquidity;
594         IUniswapV2Pair(pair).permit(msg.sender, address(this), value, deadline, v, r, s);
595         amountETH = removeLiquidityETHSupportingFeeOnTransferTokens(
596             token, liquidity, amountTokenMin, amountETHMin, to, deadline
597         );
598     }
599 
600     // **** SWAP ****
601     // requires the initial amount to have already been sent to the first pair
602     function _swap(uint[] memory amounts, address[] memory path, address _to) internal virtual {
603         for (uint i; i < path.length - 1; i++) {
604             (address input, address output) = (path[i], path[i + 1]);
605             (address token0,) = UniswapV2Library.sortTokens(input, output);
606             uint amountOut = amounts[i + 1];
607             (uint amount0Out, uint amount1Out) = input == token0 ? (uint(0), amountOut) : (amountOut, uint(0));
608             address to = i < path.length - 2 ? UniswapV2Library.pairFor(factory, output, path[i + 2]) : _to;
609             IUniswapV2Pair(UniswapV2Library.pairFor(factory, input, output)).swap(
610                 amount0Out, amount1Out, to, new bytes(0)
611             );
612         }
613     }
614     function swapExactTokensForTokens(
615         uint amountIn,
616         uint amountOutMin,
617         address[] calldata path,
618         address to,
619         uint deadline
620     ) external virtual override ensure(deadline) returns (uint[] memory amounts) {
621         amounts = UniswapV2Library.getAmountsOut(factory, amountIn, path);
622         require(amounts[amounts.length - 1] >= amountOutMin, 'UniswapV2Router: INSUFFICIENT_OUTPUT_AMOUNT');
623         TransferHelper.safeTransferFrom(
624             path[0], msg.sender, UniswapV2Library.pairFor(factory, path[0], path[1]), amounts[0]
625         );
626         _swap(amounts, path, to);
627     }
628     function swapTokensForExactTokens(
629         uint amountOut,
630         uint amountInMax,
631         address[] calldata path,
632         address to,
633         uint deadline
634     ) external virtual override ensure(deadline) returns (uint[] memory amounts) {
635         amounts = UniswapV2Library.getAmountsIn(factory, amountOut, path);
636         require(amounts[0] <= amountInMax, 'UniswapV2Router: EXCESSIVE_INPUT_AMOUNT');
637         TransferHelper.safeTransferFrom(
638             path[0], msg.sender, UniswapV2Library.pairFor(factory, path[0], path[1]), amounts[0]
639         );
640         _swap(amounts, path, to);
641     }
642     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
643         external
644         virtual
645         override
646         payable
647         ensure(deadline)
648         returns (uint[] memory amounts)
649     {
650         require(path[0] == WETH, 'UniswapV2Router: INVALID_PATH');
651         amounts = UniswapV2Library.getAmountsOut(factory, msg.value, path);
652         require(amounts[amounts.length - 1] >= amountOutMin, 'UniswapV2Router: INSUFFICIENT_OUTPUT_AMOUNT');
653         IWETH(WETH).deposit{value: amounts[0]}();
654         assert(IWETH(WETH).transfer(UniswapV2Library.pairFor(factory, path[0], path[1]), amounts[0]));
655         _swap(amounts, path, to);
656     }
657     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
658         external
659         virtual
660         override
661         ensure(deadline)
662         returns (uint[] memory amounts)
663     {
664         require(path[path.length - 1] == WETH, 'UniswapV2Router: INVALID_PATH');
665         amounts = UniswapV2Library.getAmountsIn(factory, amountOut, path);
666         require(amounts[0] <= amountInMax, 'UniswapV2Router: EXCESSIVE_INPUT_AMOUNT');
667         TransferHelper.safeTransferFrom(
668             path[0], msg.sender, UniswapV2Library.pairFor(factory, path[0], path[1]), amounts[0]
669         );
670         _swap(amounts, path, address(this));
671         IWETH(WETH).withdraw(amounts[amounts.length - 1]);
672         TransferHelper.safeTransferETH(to, amounts[amounts.length - 1]);
673     }
674     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
675         external
676         virtual
677         override
678         ensure(deadline)
679         returns (uint[] memory amounts)
680     {
681         require(path[path.length - 1] == WETH, 'UniswapV2Router: INVALID_PATH');
682         amounts = UniswapV2Library.getAmountsOut(factory, amountIn, path);
683         require(amounts[amounts.length - 1] >= amountOutMin, 'UniswapV2Router: INSUFFICIENT_OUTPUT_AMOUNT');
684         TransferHelper.safeTransferFrom(
685             path[0], msg.sender, UniswapV2Library.pairFor(factory, path[0], path[1]), amounts[0]
686         );
687         _swap(amounts, path, address(this));
688         IWETH(WETH).withdraw(amounts[amounts.length - 1]);
689         TransferHelper.safeTransferETH(to, amounts[amounts.length - 1]);
690     }
691     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
692         external
693         virtual
694         override
695         payable
696         ensure(deadline)
697         returns (uint[] memory amounts)
698     {
699         require(path[0] == WETH, 'UniswapV2Router: INVALID_PATH');
700         amounts = UniswapV2Library.getAmountsIn(factory, amountOut, path);
701         require(amounts[0] <= msg.value, 'UniswapV2Router: EXCESSIVE_INPUT_AMOUNT');
702         IWETH(WETH).deposit{value: amounts[0]}();
703         assert(IWETH(WETH).transfer(UniswapV2Library.pairFor(factory, path[0], path[1]), amounts[0]));
704         _swap(amounts, path, to);
705         // refund dust eth, if any
706         if (msg.value > amounts[0]) TransferHelper.safeTransferETH(msg.sender, msg.value - amounts[0]);
707     }
708 
709     // **** SWAP (supporting fee-on-transfer tokens) ****
710     // requires the initial amount to have already been sent to the first pair
711     function _swapSupportingFeeOnTransferTokens(address[] memory path, address _to) internal virtual {
712         for (uint i; i < path.length - 1; i++) {
713             (address input, address output) = (path[i], path[i + 1]);
714             (address token0,) = UniswapV2Library.sortTokens(input, output);
715             IUniswapV2Pair pair = IUniswapV2Pair(UniswapV2Library.pairFor(factory, input, output));
716             uint amountInput;
717             uint amountOutput;
718             { // scope to avoid stack too deep errors
719             (uint reserve0, uint reserve1,) = pair.getReserves();
720             (uint reserveInput, uint reserveOutput) = input == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
721             amountInput = IERC20Uniswap(input).balanceOf(address(pair)).sub(reserveInput);
722             amountOutput = UniswapV2Library.getAmountOut(amountInput, reserveInput, reserveOutput);
723             }
724             (uint amount0Out, uint amount1Out) = input == token0 ? (uint(0), amountOutput) : (amountOutput, uint(0));
725             address to = i < path.length - 2 ? UniswapV2Library.pairFor(factory, output, path[i + 2]) : _to;
726             pair.swap(amount0Out, amount1Out, to, new bytes(0));
727         }
728     }
729     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
730         uint amountIn,
731         uint amountOutMin,
732         address[] calldata path,
733         address to,
734         uint deadline
735     ) external virtual override ensure(deadline) {
736         TransferHelper.safeTransferFrom(
737             path[0], msg.sender, UniswapV2Library.pairFor(factory, path[0], path[1]), amountIn
738         );
739         uint balanceBefore = IERC20Uniswap(path[path.length - 1]).balanceOf(to);
740         _swapSupportingFeeOnTransferTokens(path, to);
741         require(
742             IERC20Uniswap(path[path.length - 1]).balanceOf(to).sub(balanceBefore) >= amountOutMin,
743             'UniswapV2Router: INSUFFICIENT_OUTPUT_AMOUNT'
744         );
745     }
746     function swapExactETHForTokensSupportingFeeOnTransferTokens(
747         uint amountOutMin,
748         address[] calldata path,
749         address to,
750         uint deadline
751     )
752         external
753         virtual
754         override
755         payable
756         ensure(deadline)
757     {
758         require(path[0] == WETH, 'UniswapV2Router: INVALID_PATH');
759         uint amountIn = msg.value;
760         IWETH(WETH).deposit{value: amountIn}();
761         assert(IWETH(WETH).transfer(UniswapV2Library.pairFor(factory, path[0], path[1]), amountIn));
762         uint balanceBefore = IERC20Uniswap(path[path.length - 1]).balanceOf(to);
763         _swapSupportingFeeOnTransferTokens(path, to);
764         require(
765             IERC20Uniswap(path[path.length - 1]).balanceOf(to).sub(balanceBefore) >= amountOutMin,
766             'UniswapV2Router: INSUFFICIENT_OUTPUT_AMOUNT'
767         );
768     }
769     function swapExactTokensForETHSupportingFeeOnTransferTokens(
770         uint amountIn,
771         uint amountOutMin,
772         address[] calldata path,
773         address to,
774         uint deadline
775     )
776         external
777         virtual
778         override
779         ensure(deadline)
780     {
781         require(path[path.length - 1] == WETH, 'UniswapV2Router: INVALID_PATH');
782         TransferHelper.safeTransferFrom(
783             path[0], msg.sender, UniswapV2Library.pairFor(factory, path[0], path[1]), amountIn
784         );
785         _swapSupportingFeeOnTransferTokens(path, address(this));
786         uint amountOut = IERC20Uniswap(WETH).balanceOf(address(this));
787         require(amountOut >= amountOutMin, 'UniswapV2Router: INSUFFICIENT_OUTPUT_AMOUNT');
788         IWETH(WETH).withdraw(amountOut);
789         TransferHelper.safeTransferETH(to, amountOut);
790     }
791 
792     // **** LIBRARY FUNCTIONS ****
793     function quote(uint amountA, uint reserveA, uint reserveB) public pure virtual override returns (uint amountB) {
794         return UniswapV2Library.quote(amountA, reserveA, reserveB);
795     }
796 
797     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut)
798         public
799         pure
800         virtual
801         override
802         returns (uint amountOut)
803     {
804         return UniswapV2Library.getAmountOut(amountIn, reserveIn, reserveOut);
805     }
806 
807     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut)
808         public
809         pure
810         virtual
811         override
812         returns (uint amountIn)
813     {
814         return UniswapV2Library.getAmountIn(amountOut, reserveIn, reserveOut);
815     }
816 
817     function getAmountsOut(uint amountIn, address[] memory path)
818         public
819         view
820         virtual
821         override
822         returns (uint[] memory amounts)
823     {
824         return UniswapV2Library.getAmountsOut(factory, amountIn, path);
825     }
826 
827     function getAmountsIn(uint amountOut, address[] memory path)
828         public
829         view
830         virtual
831         override
832         returns (uint[] memory amounts)
833     {
834         return UniswapV2Library.getAmountsIn(factory, amountOut, path);
835     }
836 }