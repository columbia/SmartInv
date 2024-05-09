1 pragma solidity =0.6.6;
2 
3 interface IUniswapV2Factory {
4     event D4APairCreated(address indexed token0, address indexed token1, address pair, uint256);
5 
6     function feeTo() external view returns (address);
7     function feeToSetter() external view returns (address);
8 
9     function getPair(address tokenA, address tokenB) external view returns (address pair);
10     function allPairs(uint256) external view returns (address pair);
11     function allPairsLength() external view returns (uint256);
12 
13     function createPair(address tokenA, address tokenB) external returns (address pair);
14 
15     function setFeeTo(address) external;
16     function setFeeToSetter(address) external;
17 }
18 
19 // helper methods for interacting with ERC20 tokens and sending ETH that do not consistently return true/false
20 library TransferHelper {
21     function safeApprove(
22         address token,
23         address to,
24         uint256 value
25     ) internal {
26         // bytes4(keccak256(bytes('approve(address,uint256)')));
27         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x095ea7b3, to, value));
28         require(
29             success && (data.length == 0 || abi.decode(data, (bool))),
30             'TransferHelper::safeApprove: approve failed'
31         );
32     }
33 
34     function safeTransfer(
35         address token,
36         address to,
37         uint256 value
38     ) internal {
39         // bytes4(keccak256(bytes('transfer(address,uint256)')));
40         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));
41         require(
42             success && (data.length == 0 || abi.decode(data, (bool))),
43             'TransferHelper::safeTransfer: transfer failed'
44         );
45     }
46 
47     function safeTransferFrom(
48         address token,
49         address from,
50         address to,
51         uint256 value
52     ) internal {
53         // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
54         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));
55         require(
56             success && (data.length == 0 || abi.decode(data, (bool))),
57             'TransferHelper::transferFrom: transferFrom failed'
58         );
59     }
60 
61     function safeTransferETH(address to, uint256 value) internal {
62         (bool success, ) = to.call{value: value}(new bytes(0));
63         require(success, 'TransferHelper::safeTransferETH: ETH transfer failed');
64     }
65 }
66 
67 interface IUniswapV2Router01 {
68     function factory() external pure returns (address);
69     function WETH() external pure returns (address);
70 
71     function addLiquidity(
72         address tokenA,
73         address tokenB,
74         uint amountADesired,
75         uint amountBDesired,
76         uint amountAMin,
77         uint amountBMin,
78         address to,
79         uint deadline
80     ) external returns (uint amountA, uint amountB, uint liquidity);
81     function addLiquidityETH(
82         address token,
83         uint amountTokenDesired,
84         uint amountTokenMin,
85         uint amountETHMin,
86         address to,
87         uint deadline
88     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
89     function removeLiquidity(
90         address tokenA,
91         address tokenB,
92         uint liquidity,
93         uint amountAMin,
94         uint amountBMin,
95         address to,
96         uint deadline
97     ) external returns (uint amountA, uint amountB);
98     function removeLiquidityETH(
99         address token,
100         uint liquidity,
101         uint amountTokenMin,
102         uint amountETHMin,
103         address to,
104         uint deadline
105     ) external returns (uint amountToken, uint amountETH);
106     function removeLiquidityWithPermit(
107         address tokenA,
108         address tokenB,
109         uint liquidity,
110         uint amountAMin,
111         uint amountBMin,
112         address to,
113         uint deadline,
114         bool approveMax, uint8 v, bytes32 r, bytes32 s
115     ) external returns (uint amountA, uint amountB);
116     function removeLiquidityETHWithPermit(
117         address token,
118         uint liquidity,
119         uint amountTokenMin,
120         uint amountETHMin,
121         address to,
122         uint deadline,
123         bool approveMax, uint8 v, bytes32 r, bytes32 s
124     ) external returns (uint amountToken, uint amountETH);
125     function swapExactTokensForTokens(
126         uint amountIn,
127         uint amountOutMin,
128         address[] calldata path,
129         address to,
130         uint deadline
131     ) external returns (uint[] memory amounts);
132     function swapTokensForExactTokens(
133         uint amountOut,
134         uint amountInMax,
135         address[] calldata path,
136         address to,
137         uint deadline
138     ) external returns (uint[] memory amounts);
139     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
140         external
141         payable
142         returns (uint[] memory amounts);
143     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
144         external
145         returns (uint[] memory amounts);
146     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
147         external
148         returns (uint[] memory amounts);
149     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
150         external
151         payable
152         returns (uint[] memory amounts);
153 
154     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
155     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
156     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
157     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
158     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
159 }
160 
161 interface IUniswapV2Router02 is IUniswapV2Router01 {
162 // function removeLiquidityETHSupportingFeeOnTransferTokens(
163 //     address token,
164 //     uint liquidity,
165 //     uint amountTokenMin,
166 //     uint amountETHMin,
167 //     address to,
168 //     uint deadline
169 // ) external returns (uint amountETH);
170 // function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
171 //     address token,
172 //     uint liquidity,
173 //     uint amountTokenMin,
174 //     uint amountETHMin,
175 //     address to,
176 //     uint deadline,
177 //     bool approveMax, uint8 v, bytes32 r, bytes32 s
178 // ) external returns (uint amountETH);
179 
180 // function swapExactTokensForTokensSupportingFeeOnTransferTokens(
181 //     uint amountIn,
182 //     uint amountOutMin,
183 //     address[] calldata path,
184 //     address to,
185 //     uint deadline
186 // ) external;
187 // function swapExactETHForTokensSupportingFeeOnTransferTokens(
188 //     uint amountOutMin,
189 //     address[] calldata path,
190 //     address to,
191 //     uint deadline
192 // ) external payable;
193 // function swapExactTokensForETHSupportingFeeOnTransferTokens(
194 //     uint amountIn,
195 //     uint amountOutMin,
196 //     address[] calldata path,
197 //     address to,
198 //     uint deadline
199 // ) external;
200 }
201 
202 interface IUniswapV2Pair {
203     event D4AApproval(address indexed owner, address indexed spender, uint value);
204     event D4ATransfer(address indexed from, address indexed to, uint value);
205 
206     function name() external pure returns (string memory);
207     function symbol() external pure returns (string memory);
208     function decimals() external pure returns (uint8);
209     function totalSupply() external view returns (uint);
210     function balanceOf(address owner) external view returns (uint);
211     function allowance(address owner, address spender) external view returns (uint);
212 
213     function approve(address spender, uint value) external returns (bool);
214     function transfer(address to, uint value) external returns (bool);
215     function transferFrom(address from, address to, uint value) external returns (bool);
216 
217     function DOMAIN_SEPARATOR() external view returns (bytes32);
218     function PERMIT_TYPEHASH() external pure returns (bytes32);
219     function nonces(address owner) external view returns (uint);
220 
221     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
222 
223     event D4AMint(address indexed sender, uint amount0, uint amount1);
224     event D4ABurn(address indexed sender, uint amount0, uint amount1, address indexed to);
225     event D4ASwap(
226         address indexed sender,
227         uint amount0In,
228         uint amount1In,
229         uint amount0Out,
230         uint amount1Out,
231         address indexed to
232     );
233     event D4ASync(uint112 reserve0, uint112 reserve1);
234 
235     function MINIMUM_LIQUIDITY() external pure returns (uint);
236     function factory() external view returns (address);
237     function token0() external view returns (address);
238     function token1() external view returns (address);
239     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
240     function price0CumulativeLast() external view returns (uint);
241     function price1CumulativeLast() external view returns (uint);
242     function kLast() external view returns (uint);
243 
244     function mint(address to) external returns (uint liquidity);
245     function burn(address to) external returns (uint amount0, uint amount1);
246     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
247     function skim(address to) external;
248     function sync() external;
249 
250     function initialize(address, address) external;
251 }
252 
253 // a library for performing overflow-safe math, courtesy of DappHub (https://github.com/dapphub/ds-math)
254 
255 library SafeMath {
256     function add(uint x, uint y) internal pure returns (uint z) {
257         require((z = x + y) >= x, 'ds-math-add-overflow');
258     }
259 
260     function sub(uint x, uint y) internal pure returns (uint z) {
261         require((z = x - y) <= x, 'ds-math-sub-underflow');
262     }
263 
264     function mul(uint x, uint y) internal pure returns (uint z) {
265         require(y == 0 || (z = x * y) / y == x, 'ds-math-mul-overflow');
266     }
267 }
268 
269 library UniswapV2Library {
270     using SafeMath for uint256;
271 
272     // returns sorted token addresses, used to handle return values from pairs sorted in this order
273     function sortTokens(address tokenA, address tokenB) internal pure returns (address token0, address token1) {
274         require(tokenA != tokenB, "UniswapV2Library: IDENTICAL_ADDRESSES");
275         (token0, token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
276         require(token0 != address(0), "UniswapV2Library: ZERO_ADDRESS");
277     }
278 
279     // calculates the CREATE2 address for a pair without making any external calls
280     function pairFor(address factory, address tokenA, address tokenB) internal pure returns (address pair) {
281         (address token0, address token1) = sortTokens(tokenA, tokenB);
282         pair = address(
283             uint256(
284                 keccak256(
285                     abi.encodePacked(
286                         hex"ff",
287                         factory,
288                         keccak256(abi.encodePacked(token0, token1)),
289                         // forge inspect contracts/UniswapV2Pair.sol:UniswapV2Pair bytecode --optimize --optimizer-runs 999999 --evm-version istanbul | xargs cast keccak
290                         hex"d9e9cd45e90f644f4960c80e52cb0bd934165726f194c9d9a34bc8ee414e654c" // init code hash
291                             // hex"96e8ac4277198ff8b6f785478aa9a39f403cb768dd02cbee326c3e7da348845f"
292                     )
293                 )
294             )
295         );
296     }
297 
298     // fetches and sorts the reserves for a pair
299     function getReserves(address factory, address tokenA, address tokenB)
300         internal
301         view
302         returns (uint256 reserveA, uint256 reserveB)
303     {
304         (address token0,) = sortTokens(tokenA, tokenB);
305         (uint256 reserve0, uint256 reserve1,) = IUniswapV2Pair(pairFor(factory, tokenA, tokenB)).getReserves();
306         (reserveA, reserveB) = tokenA == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
307     }
308 
309     // given some amount of an asset and pair reserves, returns an equivalent amount of the other asset
310     function quote(uint256 amountA, uint256 reserveA, uint256 reserveB) internal pure returns (uint256 amountB) {
311         require(amountA > 0, "UniswapV2Library: INSUFFICIENT_AMOUNT");
312         require(reserveA > 0 && reserveB > 0, "UniswapV2Library: INSUFFICIENT_LIQUIDITY");
313         amountB = amountA.mul(reserveB) / reserveA;
314     }
315 
316     // given an input amount of an asset and pair reserves, returns the maximum output amount of the other asset
317     function getAmountOut(uint256 amountIn, uint256 reserveIn, uint256 reserveOut)
318         internal
319         pure
320         returns (uint256 amountOut)
321     {
322         require(amountIn > 0, "UniswapV2Library: INSUFFICIENT_INPUT_AMOUNT");
323         require(reserveIn > 0 && reserveOut > 0, "UniswapV2Library: INSUFFICIENT_LIQUIDITY");
324         uint256 amountInWithFee = amountIn.mul(997);
325         uint256 numerator = amountInWithFee.mul(reserveOut);
326         uint256 denominator = reserveIn.mul(1000).add(amountInWithFee);
327         amountOut = numerator / denominator;
328     }
329 
330     // given an output amount of an asset and pair reserves, returns a required input amount of the other asset
331     function getAmountIn(uint256 amountOut, uint256 reserveIn, uint256 reserveOut)
332         internal
333         pure
334         returns (uint256 amountIn)
335     {
336         require(amountOut > 0, "UniswapV2Library: INSUFFICIENT_OUTPUT_AMOUNT");
337         require(reserveIn > 0 && reserveOut > 0, "UniswapV2Library: INSUFFICIENT_LIQUIDITY");
338         uint256 numerator = reserveIn.mul(amountOut).mul(1000);
339         uint256 denominator = reserveOut.sub(amountOut).mul(997);
340         amountIn = (numerator / denominator).add(1);
341     }
342 
343     // performs chained getAmountOut calculations on any number of pairs
344     function getAmountsOut(address factory, uint256 amountIn, address[] memory path)
345         internal
346         view
347         returns (uint256[] memory amounts)
348     {
349         require(path.length >= 2, "UniswapV2Library: INVALID_PATH");
350         amounts = new uint[](path.length);
351         amounts[0] = amountIn;
352         for (uint256 i; i < path.length - 1; i++) {
353             (uint256 reserveIn, uint256 reserveOut) = getReserves(factory, path[i], path[i + 1]);
354             amounts[i + 1] = getAmountOut(amounts[i], reserveIn, reserveOut);
355         }
356     }
357 
358     // performs chained getAmountIn calculations on any number of pairs
359     function getAmountsIn(address factory, uint256 amountOut, address[] memory path)
360         internal
361         view
362         returns (uint256[] memory amounts)
363     {
364         require(path.length >= 2, "UniswapV2Library: INVALID_PATH");
365         amounts = new uint[](path.length);
366         amounts[amounts.length - 1] = amountOut;
367         for (uint256 i = path.length - 1; i > 0; i--) {
368             (uint256 reserveIn, uint256 reserveOut) = getReserves(factory, path[i - 1], path[i]);
369             amounts[i - 1] = getAmountIn(amounts[i], reserveIn, reserveOut);
370         }
371     }
372 }
373 
374 interface IERC20 {
375     event Approval(address indexed owner, address indexed spender, uint value);
376     event Transfer(address indexed from, address indexed to, uint value);
377 
378     function name() external view returns (string memory);
379     function symbol() external view returns (string memory);
380     function decimals() external view returns (uint8);
381     function totalSupply() external view returns (uint);
382     function balanceOf(address owner) external view returns (uint);
383     function allowance(address owner, address spender) external view returns (uint);
384 
385     function approve(address spender, uint value) external returns (bool);
386     function transfer(address to, uint value) external returns (bool);
387     function transferFrom(address from, address to, uint value) external returns (bool);
388 }
389 
390 interface IWETH {
391     function deposit() external payable;
392     function transfer(address to, uint value) external returns (bool);
393     function withdraw(uint) external;
394 }
395 
396 contract UniswapV2Router02 is IUniswapV2Router02 {
397     using SafeMath for uint256;
398 
399     // Events from Pair contract, Emit in Router to facilitate event subscription
400     event RouterD4AMint(address indexed pair, address indexed sender, uint256 amount0, uint256 amount1);
401     event RouterD4ABurn(
402         address indexed pair, address indexed sender, uint256 amount0, uint256 amount1, address indexed to
403     );
404     event RouterD4ASwap(
405         address indexed pair,
406         address indexed sender,
407         uint256 amount0In,
408         uint256 amount1In,
409         uint256 amount0Out,
410         uint256 amount1Out,
411         address indexed to
412     );
413     event RouterD4ASync(address indexed pair, uint112 reserve0, uint112 reserve1);
414 
415     address public immutable override factory;
416     address public immutable override WETH;
417 
418     modifier ensure(uint256 deadline) {
419         require(deadline >= block.timestamp, "UniswapV2Router: EXPIRED");
420         _;
421     }
422 
423     constructor(address _factory, address _WETH) public {
424         factory = _factory;
425         WETH = _WETH;
426     }
427 
428     receive() external payable {
429         assert(msg.sender == WETH); // only accept ETH via fallback from the WETH contract
430     }
431 
432     // **** ADD LIQUIDITY ****
433     function _addLiquidity(
434         address tokenA,
435         address tokenB,
436         uint256 amountADesired,
437         uint256 amountBDesired,
438         uint256 amountAMin,
439         uint256 amountBMin
440     ) internal virtual returns (uint256 amountA, uint256 amountB) {
441         // create the pair if it doesn't exist yet
442         if (IUniswapV2Factory(factory).getPair(tokenA, tokenB) == address(0)) {
443             IUniswapV2Factory(factory).createPair(tokenA, tokenB);
444         }
445         (uint256 reserveA, uint256 reserveB) = UniswapV2Library.getReserves(factory, tokenA, tokenB);
446         if (reserveA == 0 && reserveB == 0) {
447             (amountA, amountB) = (amountADesired, amountBDesired);
448         } else {
449             uint256 amountBOptimal = UniswapV2Library.quote(amountADesired, reserveA, reserveB);
450             if (amountBOptimal <= amountBDesired) {
451                 require(amountBOptimal >= amountBMin, "UniswapV2Router: INSUFFICIENT_B_AMOUNT");
452                 (amountA, amountB) = (amountADesired, amountBOptimal);
453             } else {
454                 uint256 amountAOptimal = UniswapV2Library.quote(amountBDesired, reserveB, reserveA);
455                 assert(amountAOptimal <= amountADesired);
456                 require(amountAOptimal >= amountAMin, "UniswapV2Router: INSUFFICIENT_A_AMOUNT");
457                 (amountA, amountB) = (amountAOptimal, amountBDesired);
458             }
459         }
460     }
461 
462     function addLiquidity(
463         address tokenA,
464         address tokenB,
465         uint256 amountADesired,
466         uint256 amountBDesired,
467         uint256 amountAMin,
468         uint256 amountBMin,
469         address to,
470         uint256 deadline
471     ) external virtual override ensure(deadline) returns (uint256 amountA, uint256 amountB, uint256 liquidity) {
472         (amountA, amountB) = _addLiquidity(tokenA, tokenB, amountADesired, amountBDesired, amountAMin, amountBMin);
473         address pair = UniswapV2Library.pairFor(factory, tokenA, tokenB);
474         TransferHelper.safeTransferFrom(tokenA, msg.sender, pair, amountA);
475         TransferHelper.safeTransferFrom(tokenB, msg.sender, pair, amountB);
476 
477         // Emit events to facilitate event subscription
478         {
479             (address token0, address token1) = UniswapV2Library.sortTokens(tokenA, tokenB);
480             uint256 balance0 = IERC20(token0).balanceOf(address(pair));
481             uint256 balance1 = IERC20(token1).balanceOf(address(pair));
482             (uint112 _reserve0, uint112 _reserve1,) = IUniswapV2Pair(pair).getReserves(); // gas savings
483             uint256 amount0 = balance0.sub(_reserve0);
484             uint256 amount1 = balance1.sub(_reserve1);
485             emit RouterD4AMint(pair, msg.sender, amount0, amount1);
486             emit RouterD4ASync(pair, uint112(balance0), uint112(balance1));
487         }
488 
489         liquidity = IUniswapV2Pair(pair).mint(to);
490     }
491 
492     function addLiquidityETH(
493         address token,
494         uint256 amountTokenDesired,
495         uint256 amountTokenMin,
496         uint256 amountETHMin,
497         address to,
498         uint256 deadline
499     )
500         external
501         payable
502         virtual
503         override
504         ensure(deadline)
505         returns (uint256 amountToken, uint256 amountETH, uint256 liquidity)
506     {
507         (amountToken, amountETH) =
508             _addLiquidity(token, WETH, amountTokenDesired, msg.value, amountTokenMin, amountETHMin);
509         address pair = UniswapV2Library.pairFor(factory, token, WETH);
510         TransferHelper.safeTransferFrom(token, msg.sender, pair, amountToken);
511         IWETH(WETH).deposit{value: amountETH}();
512         assert(IWETH(WETH).transfer(pair, amountETH));
513 
514         // Emit events to facilitate event subscription
515         {
516             (uint112 _reserve0, uint112 _reserve1,) = IUniswapV2Pair(pair).getReserves(); // gas savings
517             (address token0, address token1) = UniswapV2Library.sortTokens(token, WETH);
518             uint256 balance0 = IERC20(token0).balanceOf(address(pair));
519             uint256 balance1 = IERC20(token1).balanceOf(address(pair));
520             uint256 amount0 = balance0.sub(_reserve0);
521             uint256 amount1 = balance1.sub(_reserve1);
522             emit RouterD4AMint(pair, msg.sender, amount0, amount1);
523             emit RouterD4ASync(pair, uint112(balance0), uint112(balance1));
524         }
525 
526         liquidity = IUniswapV2Pair(pair).mint(to);
527         // refund dust eth, if any
528         if (msg.value > amountETH) TransferHelper.safeTransferETH(msg.sender, msg.value - amountETH);
529     }
530 
531     // **** REMOVE LIQUIDITY ****
532     function removeLiquidity(
533         address tokenA,
534         address tokenB,
535         uint256 liquidity,
536         uint256 amountAMin,
537         uint256 amountBMin,
538         address to,
539         uint256 deadline
540     ) public virtual override ensure(deadline) returns (uint256 amountA, uint256 amountB) {
541         address pair = UniswapV2Library.pairFor(factory, tokenA, tokenB);
542         IUniswapV2Pair(pair).transferFrom(msg.sender, pair, liquidity); // send liquidity to pair
543         (uint256 amount0, uint256 amount1) = IUniswapV2Pair(pair).burn(to);
544         (address token0, address token1) = UniswapV2Library.sortTokens(tokenA, tokenB);
545         (amountA, amountB) = tokenA == token0 ? (amount0, amount1) : (amount1, amount0);
546         require(amountA >= amountAMin, "UniswapV2Router: INSUFFICIENT_A_AMOUNT");
547         require(amountB >= amountBMin, "UniswapV2Router: INSUFFICIENT_B_AMOUNT");
548 
549         {
550             // Emit events to facilitate event subscription
551             emit RouterD4ABurn(pair, msg.sender, amount0, amount1, to);
552             uint256 balance0 = IERC20(token0).balanceOf(pair);
553             uint256 balance1 = IERC20(token1).balanceOf(pair);
554             emit RouterD4ASync(pair, uint112(balance0), uint112(balance1));
555         }
556     }
557 
558     function removeLiquidityETH(
559         address token,
560         uint256 liquidity,
561         uint256 amountTokenMin,
562         uint256 amountETHMin,
563         address to,
564         uint256 deadline
565     ) public virtual override ensure(deadline) returns (uint256 amountToken, uint256 amountETH) {
566         (amountToken, amountETH) =
567             removeLiquidity(token, WETH, liquidity, amountTokenMin, amountETHMin, address(this), deadline);
568         TransferHelper.safeTransfer(token, to, amountToken);
569         IWETH(WETH).withdraw(amountETH);
570         TransferHelper.safeTransferETH(to, amountETH);
571     }
572 
573     function removeLiquidityWithPermit(
574         address tokenA,
575         address tokenB,
576         uint256 liquidity,
577         uint256 amountAMin,
578         uint256 amountBMin,
579         address to,
580         uint256 deadline,
581         bool approveMax,
582         uint8 v,
583         bytes32 r,
584         bytes32 s
585     ) external virtual override returns (uint256 amountA, uint256 amountB) {
586         address pair = UniswapV2Library.pairFor(factory, tokenA, tokenB);
587         uint256 value = approveMax ? uint256(-1) : liquidity;
588         IUniswapV2Pair(pair).permit(msg.sender, address(this), value, deadline, v, r, s);
589         (amountA, amountB) = removeLiquidity(tokenA, tokenB, liquidity, amountAMin, amountBMin, to, deadline);
590     }
591 
592     function removeLiquidityETHWithPermit(
593         address token,
594         uint256 liquidity,
595         uint256 amountTokenMin,
596         uint256 amountETHMin,
597         address to,
598         uint256 deadline,
599         bool approveMax,
600         uint8 v,
601         bytes32 r,
602         bytes32 s
603     ) external virtual override returns (uint256 amountToken, uint256 amountETH) {
604         address pair = UniswapV2Library.pairFor(factory, token, WETH);
605         uint256 value = approveMax ? uint256(-1) : liquidity;
606         IUniswapV2Pair(pair).permit(msg.sender, address(this), value, deadline, v, r, s);
607         (amountToken, amountETH) = removeLiquidityETH(token, liquidity, amountTokenMin, amountETHMin, to, deadline);
608     }
609 
610     // // **** REMOVE LIQUIDITY (supporting fee-on-transfer tokens) ****
611     // function removeLiquidityETHSupportingFeeOnTransferTokens(
612     //     address token,
613     //     uint256 liquidity,
614     //     uint256 amountTokenMin,
615     //     uint256 amountETHMin,
616     //     address to,
617     //     uint256 deadline
618     // ) public virtual override ensure(deadline) returns (uint256 amountETH) {
619     //     (, amountETH) = removeLiquidity(token, WETH, liquidity, amountTokenMin, amountETHMin, address(this), deadline);
620     //     TransferHelper.safeTransfer(token, to, IERC20(token).balanceOf(address(this)));
621     //     IWETH(WETH).withdraw(amountETH);
622     //     TransferHelper.safeTransferETH(to, amountETH);
623     // }
624 
625     // function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
626     //     address token,
627     //     uint256 liquidity,
628     //     uint256 amountTokenMin,
629     //     uint256 amountETHMin,
630     //     address to,
631     //     uint256 deadline,
632     //     bool approveMax,
633     //     uint8 v,
634     //     bytes32 r,
635     //     bytes32 s
636     // ) external virtual override returns (uint256 amountETH) {
637     //     address pair = UniswapV2Library.pairFor(factory, token, WETH);
638     //     uint256 value = approveMax ? uint256(-1) : liquidity;
639     //     IUniswapV2Pair(pair).permit(msg.sender, address(this), value, deadline, v, r, s);
640     //     amountETH = removeLiquidityETHSupportingFeeOnTransferTokens(
641     //         token, liquidity, amountTokenMin, amountETHMin, to, deadline
642     //     );
643     // }
644 
645     // **** SWAP ****
646     // requires the initial amount to have already been sent to the first pair
647     function _swap(uint256[] memory amounts, address[] memory path, address _to) internal virtual {
648         for (uint256 i; i < path.length - 1; i++) {
649             (address input, address output) = (path[i], path[i + 1]);
650             (address token0, address token1) = UniswapV2Library.sortTokens(input, output);
651             uint256 amountOut = amounts[i + 1];
652             (uint256 amount0Out, uint256 amount1Out) =
653                 input == token0 ? (uint256(0), amountOut) : (amountOut, uint256(0));
654             address to = i < path.length - 2 ? UniswapV2Library.pairFor(factory, output, path[i + 2]) : _to;
655 
656             {
657                 address pair = UniswapV2Library.pairFor(factory, input, output);
658                 (uint112 _reserve0, uint112 _reserve1,) = IUniswapV2Pair(pair).getReserves(); // gas savings
659                 uint256 balance0 = IERC20(token0).balanceOf(pair) - amount0Out;
660                 uint256 balance1 = IERC20(token1).balanceOf(pair) - amount1Out;
661                 uint256 amount0In = balance0 > _reserve0 - amount0Out ? balance0 - (_reserve0 - amount0Out) : 0;
662                 uint256 amount1In = balance1 > _reserve1 - amount1Out ? balance1 - (_reserve1 - amount1Out) : 0;
663                 emit RouterD4ASwap(pair, msg.sender, amount0In, amount1In, amount0Out, amount1Out, to);
664                 emit RouterD4ASync(pair, uint112(balance0), uint112(balance1));
665             }
666 
667             IUniswapV2Pair(UniswapV2Library.pairFor(factory, input, output)).swap(
668                 amount0Out, amount1Out, to, new bytes(0)
669             );
670         }
671     }
672 
673     function swapExactTokensForTokens(
674         uint256 amountIn,
675         uint256 amountOutMin,
676         address[] calldata path,
677         address to,
678         uint256 deadline
679     ) external virtual override ensure(deadline) returns (uint256[] memory amounts) {
680         amounts = UniswapV2Library.getAmountsOut(factory, amountIn, path);
681         require(amounts[amounts.length - 1] >= amountOutMin, "UniswapV2Router: INSUFFICIENT_OUTPUT_AMOUNT");
682         TransferHelper.safeTransferFrom(
683             path[0], msg.sender, UniswapV2Library.pairFor(factory, path[0], path[1]), amounts[0]
684         );
685         _swap(amounts, path, to);
686     }
687 
688     function swapTokensForExactTokens(
689         uint256 amountOut,
690         uint256 amountInMax,
691         address[] calldata path,
692         address to,
693         uint256 deadline
694     ) external virtual override ensure(deadline) returns (uint256[] memory amounts) {
695         amounts = UniswapV2Library.getAmountsIn(factory, amountOut, path);
696         require(amounts[0] <= amountInMax, "UniswapV2Router: EXCESSIVE_INPUT_AMOUNT");
697         TransferHelper.safeTransferFrom(
698             path[0], msg.sender, UniswapV2Library.pairFor(factory, path[0], path[1]), amounts[0]
699         );
700         _swap(amounts, path, to);
701     }
702 
703     function swapExactETHForTokens(uint256 amountOutMin, address[] calldata path, address to, uint256 deadline)
704         external
705         payable
706         virtual
707         override
708         ensure(deadline)
709         returns (uint256[] memory amounts)
710     {
711         require(path[0] == WETH, "UniswapV2Router: INVALID_PATH");
712         amounts = UniswapV2Library.getAmountsOut(factory, msg.value, path);
713         require(amounts[amounts.length - 1] >= amountOutMin, "UniswapV2Router: INSUFFICIENT_OUTPUT_AMOUNT");
714         IWETH(WETH).deposit{value: amounts[0]}();
715         assert(IWETH(WETH).transfer(UniswapV2Library.pairFor(factory, path[0], path[1]), amounts[0]));
716         _swap(amounts, path, to);
717     }
718 
719     function swapTokensForExactETH(
720         uint256 amountOut,
721         uint256 amountInMax,
722         address[] calldata path,
723         address to,
724         uint256 deadline
725     ) external virtual override ensure(deadline) returns (uint256[] memory amounts) {
726         require(path[path.length - 1] == WETH, "UniswapV2Router: INVALID_PATH");
727         amounts = UniswapV2Library.getAmountsIn(factory, amountOut, path);
728         require(amounts[0] <= amountInMax, "UniswapV2Router: EXCESSIVE_INPUT_AMOUNT");
729         TransferHelper.safeTransferFrom(
730             path[0], msg.sender, UniswapV2Library.pairFor(factory, path[0], path[1]), amounts[0]
731         );
732         _swap(amounts, path, address(this));
733         IWETH(WETH).withdraw(amounts[amounts.length - 1]);
734         TransferHelper.safeTransferETH(to, amounts[amounts.length - 1]);
735     }
736 
737     function swapExactTokensForETH(
738         uint256 amountIn,
739         uint256 amountOutMin,
740         address[] calldata path,
741         address to,
742         uint256 deadline
743     ) external virtual override ensure(deadline) returns (uint256[] memory amounts) {
744         require(path[path.length - 1] == WETH, "UniswapV2Router: INVALID_PATH");
745         amounts = UniswapV2Library.getAmountsOut(factory, amountIn, path);
746         require(amounts[amounts.length - 1] >= amountOutMin, "UniswapV2Router: INSUFFICIENT_OUTPUT_AMOUNT");
747         TransferHelper.safeTransferFrom(
748             path[0], msg.sender, UniswapV2Library.pairFor(factory, path[0], path[1]), amounts[0]
749         );
750         _swap(amounts, path, address(this));
751         IWETH(WETH).withdraw(amounts[amounts.length - 1]);
752         TransferHelper.safeTransferETH(to, amounts[amounts.length - 1]);
753     }
754 
755     function swapETHForExactTokens(uint256 amountOut, address[] calldata path, address to, uint256 deadline)
756         external
757         payable
758         virtual
759         override
760         ensure(deadline)
761         returns (uint256[] memory amounts)
762     {
763         require(path[0] == WETH, "UniswapV2Router: INVALID_PATH");
764         amounts = UniswapV2Library.getAmountsIn(factory, amountOut, path);
765         require(amounts[0] <= msg.value, "UniswapV2Router: EXCESSIVE_INPUT_AMOUNT");
766         IWETH(WETH).deposit{value: amounts[0]}();
767         assert(IWETH(WETH).transfer(UniswapV2Library.pairFor(factory, path[0], path[1]), amounts[0]));
768         _swap(amounts, path, to);
769         // refund dust eth, if any
770         if (msg.value > amounts[0]) TransferHelper.safeTransferETH(msg.sender, msg.value - amounts[0]);
771     }
772 
773     // // **** SWAP (supporting fee-on-transfer tokens) ****
774     // // requires the initial amount to have already been sent to the first pair
775     // function _swapSupportingFeeOnTransferTokens(address[] memory path, address _to) internal virtual {
776     //     for (uint256 i; i < path.length - 1; i++) {
777     //         (address input, address output) = (path[i], path[i + 1]);
778     //         (address token0,) = UniswapV2Library.sortTokens(input, output);
779     //         IUniswapV2Pair pair = IUniswapV2Pair(UniswapV2Library.pairFor(factory, input, output));
780     //         uint256 amountInput;
781     //         uint256 amountOutput;
782     //         {
783     //             // scope to avoid stack too deep errors
784     //             (uint256 reserve0, uint256 reserve1,) = pair.getReserves();
785     //             (uint256 reserveInput, uint256 reserveOutput) =
786     //                 input == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
787     //             amountInput = IERC20(input).balanceOf(address(pair)).sub(reserveInput);
788     //             amountOutput = UniswapV2Library.getAmountOut(amountInput, reserveInput, reserveOutput);
789     //         }
790     //         (uint256 amount0Out, uint256 amount1Out) =
791     //             input == token0 ? (uint256(0), amountOutput) : (amountOutput, uint256(0));
792     //         address to = i < path.length - 2 ? UniswapV2Library.pairFor(factory, output, path[i + 2]) : _to;
793     //         pair.swap(amount0Out, amount1Out, to, new bytes(0));
794     //     }
795     // }
796 
797     // function swapExactTokensForTokensSupportingFeeOnTransferTokens(
798     //     uint256 amountIn,
799     //     uint256 amountOutMin,
800     //     address[] calldata path,
801     //     address to,
802     //     uint256 deadline
803     // ) external virtual override ensure(deadline) {
804     //     TransferHelper.safeTransferFrom(
805     //         path[0], msg.sender, UniswapV2Library.pairFor(factory, path[0], path[1]), amountIn
806     //     );
807     //     uint256 balanceBefore = IERC20(path[path.length - 1]).balanceOf(to);
808     //     _swapSupportingFeeOnTransferTokens(path, to);
809     //     require(
810     //         IERC20(path[path.length - 1]).balanceOf(to).sub(balanceBefore) >= amountOutMin,
811     //         "UniswapV2Router: INSUFFICIENT_OUTPUT_AMOUNT"
812     //     );
813     // }
814 
815     // function swapExactETHForTokensSupportingFeeOnTransferTokens(
816     //     uint256 amountOutMin,
817     //     address[] calldata path,
818     //     address to,
819     //     uint256 deadline
820     // ) external payable virtual override ensure(deadline) {
821     //     require(path[0] == WETH, "UniswapV2Router: INVALID_PATH");
822     //     uint256 amountIn = msg.value;
823     //     IWETH(WETH).deposit{value: amountIn}();
824     //     assert(IWETH(WETH).transfer(UniswapV2Library.pairFor(factory, path[0], path[1]), amountIn));
825     //     uint256 balanceBefore = IERC20(path[path.length - 1]).balanceOf(to);
826     //     _swapSupportingFeeOnTransferTokens(path, to);
827     //     require(
828     //         IERC20(path[path.length - 1]).balanceOf(to).sub(balanceBefore) >= amountOutMin,
829     //         "UniswapV2Router: INSUFFICIENT_OUTPUT_AMOUNT"
830     //     );
831     // }
832 
833     // function swapExactTokensForETHSupportingFeeOnTransferTokens(
834     //     uint256 amountIn,
835     //     uint256 amountOutMin,
836     //     address[] calldata path,
837     //     address to,
838     //     uint256 deadline
839     // ) external virtual override ensure(deadline) {
840     //     require(path[path.length - 1] == WETH, "UniswapV2Router: INVALID_PATH");
841     //     TransferHelper.safeTransferFrom(
842     //         path[0], msg.sender, UniswapV2Library.pairFor(factory, path[0], path[1]), amountIn
843     //     );
844     //     _swapSupportingFeeOnTransferTokens(path, address(this));
845     //     uint256 amountOut = IERC20(WETH).balanceOf(address(this));
846     //     require(amountOut >= amountOutMin, "UniswapV2Router: INSUFFICIENT_OUTPUT_AMOUNT");
847     //     IWETH(WETH).withdraw(amountOut);
848     //     TransferHelper.safeTransferETH(to, amountOut);
849     // }
850 
851     // **** LIBRARY FUNCTIONS ****
852     function quote(uint256 amountA, uint256 reserveA, uint256 reserveB)
853         public
854         pure
855         virtual
856         override
857         returns (uint256 amountB)
858     {
859         return UniswapV2Library.quote(amountA, reserveA, reserveB);
860     }
861 
862     function getAmountOut(uint256 amountIn, uint256 reserveIn, uint256 reserveOut)
863         public
864         pure
865         virtual
866         override
867         returns (uint256 amountOut)
868     {
869         return UniswapV2Library.getAmountOut(amountIn, reserveIn, reserveOut);
870     }
871 
872     function getAmountIn(uint256 amountOut, uint256 reserveIn, uint256 reserveOut)
873         public
874         pure
875         virtual
876         override
877         returns (uint256 amountIn)
878     {
879         return UniswapV2Library.getAmountIn(amountOut, reserveIn, reserveOut);
880     }
881 
882     function getAmountsOut(uint256 amountIn, address[] memory path)
883         public
884         view
885         virtual
886         override
887         returns (uint256[] memory amounts)
888     {
889         return UniswapV2Library.getAmountsOut(factory, amountIn, path);
890     }
891 
892     function getAmountsIn(uint256 amountOut, address[] memory path)
893         public
894         view
895         virtual
896         override
897         returns (uint256[] memory amounts)
898     {
899         return UniswapV2Library.getAmountsIn(factory, amountOut, path);
900     }
901 }