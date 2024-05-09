1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity >=0.6.12;
3 
4 interface IUniswapV2Pair {
5     event Approval(address indexed owner, address indexed spender, uint value);
6     event Transfer(address indexed from, address indexed to, uint value);
7 
8     function name() external pure returns (string memory);
9     function symbol() external pure returns (string memory);
10     function decimals() external pure returns (uint8);
11     function totalSupply() external view returns (uint);
12     function balanceOf(address owner) external view returns (uint);
13     function allowance(address owner, address spender) external view returns (uint);
14 
15     function approve(address spender, uint value) external returns (bool);
16     function transfer(address to, uint value) external returns (bool);
17     function transferFrom(address from, address to, uint value) external returns (bool);
18 
19     function DOMAIN_SEPARATOR() external view returns (bytes32);
20     function PERMIT_TYPEHASH() external pure returns (bytes32);
21     function nonces(address owner) external view returns (uint);
22 
23     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
24 
25     event Mint(address indexed sender, uint amount0, uint amount1);
26     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
27     event Swap(
28         address indexed sender,
29         uint amount0In,
30         uint amount1In,
31         uint amount0Out,
32         uint amount1Out,
33         address indexed to
34     );
35     event Sync(uint112 reserve0, uint112 reserve1);
36 
37     function MINIMUM_LIQUIDITY() external pure returns (uint);
38     function factory() external view returns (address);
39     function token0() external view returns (address);
40     function token1() external view returns (address);
41     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
42     function price0CumulativeLast() external view returns (uint);
43     function price1CumulativeLast() external view returns (uint);
44     function kLast() external view returns (uint);
45 
46     function mint(address to) external returns (uint liquidity);
47     function burn(address to) external returns (uint amount0, uint amount1);
48     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
49     function skim(address to) external;
50     function sync() external;
51 
52     function initialize(address, address) external;
53 }
54 
55 // a library for performing overflow-safe math, courtesy of DappHub (https://github.com/dapphub/ds-math)
56 library SafeMathUniswap {
57     function add(uint x, uint y) internal pure returns (uint z) {
58         require((z = x + y) >= x, 'ds-math-add-overflow');
59     }
60 
61     function sub(uint x, uint y) internal pure returns (uint z) {
62         require((z = x - y) <= x, 'ds-math-sub-underflow');
63     }
64 
65     function mul(uint x, uint y) internal pure returns (uint z) {
66         require(y == 0 || (z = x * y) / y == x, 'ds-math-mul-overflow');
67     }
68 }
69 
70 library UniswapV2Library {
71     using SafeMathUniswap for uint;
72 
73     // returns sorted token addresses, used to handle return values from pairs sorted in this order
74     function sortTokens(address tokenA, address tokenB) internal pure returns (address token0, address token1) {
75         require(tokenA != tokenB, 'UniswapV2Library: IDENTICAL_ADDRESSES');
76         (token0, token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
77         require(token0 != address(0), 'UniswapV2Library: ZERO_ADDRESS');
78     }
79 
80     // calculates the CREATE2 address for a pair without making any external calls
81     function pairFor(address factory, address tokenA, address tokenB) internal pure returns (address pair) {
82         (address token0, address token1) = sortTokens(tokenA, tokenB);
83         pair = address(uint(keccak256(abi.encodePacked(
84                 hex'ff',
85                 factory,
86                 keccak256(abi.encodePacked(token0, token1)),
87                 hex'c0a9356ab077d90fe1de58a439051e5714122360ab1f0b1d9a65e20dae6b98d8' // init code hash
88             ))));
89     }
90 
91     // fetches and sorts the reserves for a pair
92     function getReserves(address factory, address tokenA, address tokenB) internal view returns (uint reserveA, uint reserveB) {
93         (address token0,) = sortTokens(tokenA, tokenB);
94         (uint reserve0, uint reserve1,) = IUniswapV2Pair(pairFor(factory, tokenA, tokenB)).getReserves();
95         (reserveA, reserveB) = tokenA == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
96     }
97 
98     // given some amount of an asset and pair reserves, returns an equivalent amount of the other asset
99     function quote(uint amountA, uint reserveA, uint reserveB) internal pure returns (uint amountB) {
100         require(amountA > 0, 'UniswapV2Library: INSUFFICIENT_AMOUNT');
101         require(reserveA > 0 && reserveB > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
102         amountB = amountA.mul(reserveB) / reserveA;
103     }
104 
105     // given an input amount of an asset and pair reserves, returns the maximum output amount of the other asset
106     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) internal pure returns (uint amountOut) {
107         require(amountIn > 0, 'UniswapV2Library: INSUFFICIENT_INPUT_AMOUNT');
108         require(reserveIn > 0 && reserveOut > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
109         uint amountInWithFee = amountIn.mul(997);
110         uint numerator = amountInWithFee.mul(reserveOut);
111         uint denominator = reserveIn.mul(1000).add(amountInWithFee);
112         amountOut = numerator / denominator;
113     }
114 
115     // given an output amount of an asset and pair reserves, returns a required input amount of the other asset
116     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) internal pure returns (uint amountIn) {
117         require(amountOut > 0, 'UniswapV2Library: INSUFFICIENT_OUTPUT_AMOUNT');
118         require(reserveIn > 0 && reserveOut > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
119         uint numerator = reserveIn.mul(amountOut).mul(1000);
120         uint denominator = reserveOut.sub(amountOut).mul(997);
121         amountIn = (numerator / denominator).add(1);
122     }
123 
124     // performs chained getAmountOut calculations on any number of pairs
125     function getAmountsOut(address factory, uint amountIn, address[] memory path) internal view returns (uint[] memory amounts) {
126         require(path.length >= 2, 'UniswapV2Library: INVALID_PATH');
127         amounts = new uint[](path.length);
128         amounts[0] = amountIn;
129         for (uint i; i < path.length - 1; i++) {
130             (uint reserveIn, uint reserveOut) = getReserves(factory, path[i], path[i + 1]);
131             amounts[i + 1] = getAmountOut(amounts[i], reserveIn, reserveOut);
132         }
133     }
134 
135     // performs chained getAmountIn calculations on any number of pairs
136     function getAmountsIn(address factory, uint amountOut, address[] memory path) internal view returns (uint[] memory amounts) {
137         require(path.length >= 2, 'UniswapV2Library: INVALID_PATH');
138         amounts = new uint[](path.length);
139         amounts[amounts.length - 1] = amountOut;
140         for (uint i = path.length - 1; i > 0; i--) {
141             (uint reserveIn, uint reserveOut) = getReserves(factory, path[i - 1], path[i]);
142             amounts[i - 1] = getAmountIn(amounts[i], reserveIn, reserveOut);
143         }
144     }
145 }
146 
147 // helper methods for interacting with ERC20 tokens and sending ETH that do not consistently return true/false
148 library TransferHelper {
149     function safeApprove(address token, address to, uint value) internal {
150         // bytes4(keccak256(bytes('approve(address,uint256)')));
151         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x095ea7b3, to, value));
152         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: APPROVE_FAILED');
153     }
154 
155     function safeTransfer(address token, address to, uint value) internal {
156         // bytes4(keccak256(bytes('transfer(address,uint256)')));
157         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));
158         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FAILED');
159     }
160 
161     function safeTransferFrom(address token, address from, address to, uint value) internal {
162         // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
163         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));
164         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FROM_FAILED');
165     }
166 
167     function safeTransferETH(address to, uint value) internal {
168         (bool success,) = to.call{value:value}(new bytes(0));
169         require(success, 'TransferHelper: ETH_TRANSFER_FAILED');
170     }
171 }
172 
173 interface IUniswapV2Router01 {
174     function factory() external pure returns (address);
175     function WETH() external pure returns (address);
176 
177     function addLiquidity(
178         address tokenA,
179         address tokenB,
180         uint amountADesired,
181         uint amountBDesired,
182         uint amountAMin,
183         uint amountBMin,
184         address to,
185         uint deadline
186     ) external returns (uint amountA, uint amountB, uint liquidity);
187     function addLiquidityETH(
188         address token,
189         uint amountTokenDesired,
190         uint amountTokenMin,
191         uint amountETHMin,
192         address to,
193         uint deadline
194     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
195     function removeLiquidity(
196         address tokenA,
197         address tokenB,
198         uint liquidity,
199         uint amountAMin,
200         uint amountBMin,
201         address to,
202         uint deadline
203     ) external returns (uint amountA, uint amountB);
204     function removeLiquidityETH(
205         address token,
206         uint liquidity,
207         uint amountTokenMin,
208         uint amountETHMin,
209         address to,
210         uint deadline
211     ) external returns (uint amountToken, uint amountETH);
212     function removeLiquidityWithPermit(
213         address tokenA,
214         address tokenB,
215         uint liquidity,
216         uint amountAMin,
217         uint amountBMin,
218         address to,
219         uint deadline,
220         bool approveMax, uint8 v, bytes32 r, bytes32 s
221     ) external returns (uint amountA, uint amountB);
222     function removeLiquidityETHWithPermit(
223         address token,
224         uint liquidity,
225         uint amountTokenMin,
226         uint amountETHMin,
227         address to,
228         uint deadline,
229         bool approveMax, uint8 v, bytes32 r, bytes32 s
230     ) external returns (uint amountToken, uint amountETH);
231     function swapExactTokensForTokens(
232         uint amountIn,
233         uint amountOutMin,
234         address[] calldata path,
235         address to,
236         uint deadline
237     ) external returns (uint[] memory amounts);
238     function swapTokensForExactTokens(
239         uint amountOut,
240         uint amountInMax,
241         address[] calldata path,
242         address to,
243         uint deadline
244     ) external returns (uint[] memory amounts);
245     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
246     external
247     payable
248     returns (uint[] memory amounts);
249     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
250     external
251     returns (uint[] memory amounts);
252     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
253     external
254     returns (uint[] memory amounts);
255     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
256     external
257     payable
258     returns (uint[] memory amounts);
259 
260     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
261     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
262     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
263     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
264     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
265 }
266 
267 interface IUniswapV2Router02 is IUniswapV2Router01 {
268     function removeLiquidityETHSupportingFeeOnTransferTokens(
269         address token,
270         uint liquidity,
271         uint amountTokenMin,
272         uint amountETHMin,
273         address to,
274         uint deadline
275     ) external returns (uint amountETH);
276     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
277         address token,
278         uint liquidity,
279         uint amountTokenMin,
280         uint amountETHMin,
281         address to,
282         uint deadline,
283         bool approveMax, uint8 v, bytes32 r, bytes32 s
284     ) external returns (uint amountETH);
285 
286     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
287         uint amountIn,
288         uint amountOutMin,
289         address[] calldata path,
290         address to,
291         uint deadline
292     ) external;
293     function swapExactETHForTokensSupportingFeeOnTransferTokens(
294         uint amountOutMin,
295         address[] calldata path,
296         address to,
297         uint deadline
298     ) external payable;
299     function swapExactTokensForETHSupportingFeeOnTransferTokens(
300         uint amountIn,
301         uint amountOutMin,
302         address[] calldata path,
303         address to,
304         uint deadline
305     ) external;
306 }
307 
308 interface IUniswapV2Factory {
309     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
310 
311     function feeTo() external view returns (address);
312     function feeToSetter() external view returns (address);
313     // add migrator for cityswap
314     function migrator() external view returns (address);
315 
316     function getPair(address tokenA, address tokenB) external view returns (address pair);
317     function allPairs(uint) external view returns (address pair);
318     function allPairsLength() external view returns (uint);
319 
320     function createPair(address tokenA, address tokenB) external returns (address pair);
321 
322     function setFeeTo(address) external;
323     function setFeeToSetter(address) external;
324     // set migrator for cityswap
325     function setMigrator(address) external;
326 }
327 
328 interface IERC20Uniswap {
329     event Approval(address indexed owner, address indexed spender, uint value);
330     event Transfer(address indexed from, address indexed to, uint value);
331 
332     function name() external view returns (string memory);
333     function symbol() external view returns (string memory);
334     function decimals() external view returns (uint8);
335     function totalSupply() external view returns (uint);
336     function balanceOf(address owner) external view returns (uint);
337     function allowance(address owner, address spender) external view returns (uint);
338 
339     function approve(address spender, uint value) external returns (bool);
340     function transfer(address to, uint value) external returns (bool);
341     function transferFrom(address from, address to, uint value) external returns (bool);
342 }
343 
344 interface IWETH {
345     function deposit() external payable;
346     function transfer(address to, uint value) external returns (bool);
347     function withdraw(uint) external;
348 }
349 
350 contract UniswapV2Router02 is IUniswapV2Router02 {
351     using SafeMathUniswap for uint;
352 
353     address public immutable override factory;
354     address public immutable override WETH;
355 
356     modifier ensure(uint deadline) {
357         require(deadline >= block.timestamp, 'UniswapV2Router: EXPIRED');
358         _;
359     }
360 
361     constructor(address _factory, address _WETH) public {
362         factory = _factory;
363         WETH = _WETH;
364     }
365 
366     receive() external payable {
367         // only accept ETH via fallback from the WETH contract
368         assert(msg.sender == WETH);
369     }
370 
371     // **** ADD LIQUIDITY ****
372     function _addLiquidity(
373         address tokenA,
374         address tokenB,
375         uint amountADesired,
376         uint amountBDesired,
377         uint amountAMin,
378         uint amountBMin
379     ) internal virtual returns (uint amountA, uint amountB) {
380         // create the pair if it doesn't exist yet
381         if (IUniswapV2Factory(factory).getPair(tokenA, tokenB) == address(0)) {
382             IUniswapV2Factory(factory).createPair(tokenA, tokenB);
383         }
384         (uint reserveA, uint reserveB) = UniswapV2Library.getReserves(factory, tokenA, tokenB);
385         if (reserveA == 0 && reserveB == 0) {
386             (amountA, amountB) = (amountADesired, amountBDesired);
387         } else {
388             uint amountBOptimal = UniswapV2Library.quote(amountADesired, reserveA, reserveB);
389             if (amountBOptimal <= amountBDesired) {
390                 require(amountBOptimal >= amountBMin, 'UniswapV2Router: INSUFFICIENT_B_AMOUNT');
391                 (amountA, amountB) = (amountADesired, amountBOptimal);
392             } else {
393                 uint amountAOptimal = UniswapV2Library.quote(amountBDesired, reserveB, reserveA);
394                 assert(amountAOptimal <= amountADesired);
395                 require(amountAOptimal >= amountAMin, 'UniswapV2Router: INSUFFICIENT_A_AMOUNT');
396                 (amountA, amountB) = (amountAOptimal, amountBDesired);
397             }
398         }
399     }
400 
401     function addLiquidity(
402         address tokenA,
403         address tokenB,
404         uint amountADesired,
405         uint amountBDesired,
406         uint amountAMin,
407         uint amountBMin,
408         address to,
409         uint deadline
410     ) external virtual override ensure(deadline) returns (uint amountA, uint amountB, uint liquidity) {
411         (amountA, amountB) = _addLiquidity(tokenA, tokenB, amountADesired, amountBDesired, amountAMin, amountBMin);
412         address pair = UniswapV2Library.pairFor(factory, tokenA, tokenB);
413         TransferHelper.safeTransferFrom(tokenA, msg.sender, pair, amountA);
414         TransferHelper.safeTransferFrom(tokenB, msg.sender, pair, amountB);
415         liquidity = IUniswapV2Pair(pair).mint(to);
416     }
417 
418     function addLiquidityETH(
419         address token,
420         uint amountTokenDesired,
421         uint amountTokenMin,
422         uint amountETHMin,
423         address to,
424         uint deadline
425     ) external virtual override payable ensure(deadline) returns (uint amountToken, uint amountETH, uint liquidity) {
426         (amountToken, amountETH) = _addLiquidity(
427             token,
428             WETH,
429             amountTokenDesired,
430             msg.value,
431             amountTokenMin,
432             amountETHMin
433         );
434         address pair = UniswapV2Library.pairFor(factory, token, WETH);
435         TransferHelper.safeTransferFrom(token, msg.sender, pair, amountToken);
436         IWETH(WETH).deposit{value : amountETH}();
437         assert(IWETH(WETH).transfer(pair, amountETH));
438         liquidity = IUniswapV2Pair(pair).mint(to);
439         // refund dust eth, if any
440         if (msg.value > amountETH) TransferHelper.safeTransferETH(msg.sender, msg.value - amountETH);
441     }
442 
443     // **** REMOVE LIQUIDITY ****
444     function removeLiquidity(
445         address tokenA,
446         address tokenB,
447         uint liquidity,
448         uint amountAMin,
449         uint amountBMin,
450         address to,
451         uint deadline
452     ) public virtual override ensure(deadline) returns (uint amountA, uint amountB) {
453         address pair = UniswapV2Library.pairFor(factory, tokenA, tokenB);
454         IUniswapV2Pair(pair).transferFrom(msg.sender, pair, liquidity);
455         // send liquidity to pair
456         (uint amount0, uint amount1) = IUniswapV2Pair(pair).burn(to);
457         (address token0,) = UniswapV2Library.sortTokens(tokenA, tokenB);
458         (amountA, amountB) = tokenA == token0 ? (amount0, amount1) : (amount1, amount0);
459         require(amountA >= amountAMin, 'UniswapV2Router: INSUFFICIENT_A_AMOUNT');
460         require(amountB >= amountBMin, 'UniswapV2Router: INSUFFICIENT_B_AMOUNT');
461     }
462 
463     function removeLiquidityETH(
464         address token,
465         uint liquidity,
466         uint amountTokenMin,
467         uint amountETHMin,
468         address to,
469         uint deadline
470     ) public virtual override ensure(deadline) returns (uint amountToken, uint amountETH) {
471         (amountToken, amountETH) = removeLiquidity(
472             token,
473             WETH,
474             liquidity,
475             amountTokenMin,
476             amountETHMin,
477             address(this),
478             deadline
479         );
480         TransferHelper.safeTransfer(token, to, amountToken);
481         IWETH(WETH).withdraw(amountETH);
482         TransferHelper.safeTransferETH(to, amountETH);
483     }
484 
485     function removeLiquidityWithPermit(
486         address tokenA,
487         address tokenB,
488         uint liquidity,
489         uint amountAMin,
490         uint amountBMin,
491         address to,
492         uint deadline,
493         bool approveMax, uint8 v, bytes32 r, bytes32 s
494     ) external virtual override returns (uint amountA, uint amountB) {
495         address pair = UniswapV2Library.pairFor(factory, tokenA, tokenB);
496         uint value = approveMax ? uint(- 1) : liquidity;
497         IUniswapV2Pair(pair).permit(msg.sender, address(this), value, deadline, v, r, s);
498         (amountA, amountB) = removeLiquidity(tokenA, tokenB, liquidity, amountAMin, amountBMin, to, deadline);
499     }
500 
501     function removeLiquidityETHWithPermit(
502         address token,
503         uint liquidity,
504         uint amountTokenMin,
505         uint amountETHMin,
506         address to,
507         uint deadline,
508         bool approveMax, uint8 v, bytes32 r, bytes32 s
509     ) external virtual override returns (uint amountToken, uint amountETH) {
510         address pair = UniswapV2Library.pairFor(factory, token, WETH);
511         uint value = approveMax ? uint(- 1) : liquidity;
512         IUniswapV2Pair(pair).permit(msg.sender, address(this), value, deadline, v, r, s);
513         (amountToken, amountETH) = removeLiquidityETH(token, liquidity, amountTokenMin, amountETHMin, to, deadline);
514     }
515 
516     // **** REMOVE LIQUIDITY (supporting fee-on-transfer tokens) ****
517     function removeLiquidityETHSupportingFeeOnTransferTokens(
518         address token,
519         uint liquidity,
520         uint amountTokenMin,
521         uint amountETHMin,
522         address to,
523         uint deadline
524     ) public virtual override ensure(deadline) returns (uint amountETH) {
525         (, amountETH) = removeLiquidity(
526             token,
527             WETH,
528             liquidity,
529             amountTokenMin,
530             amountETHMin,
531             address(this),
532             deadline
533         );
534         TransferHelper.safeTransfer(token, to, IERC20Uniswap(token).balanceOf(address(this)));
535         IWETH(WETH).withdraw(amountETH);
536         TransferHelper.safeTransferETH(to, amountETH);
537     }
538 
539     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
540         address token,
541         uint liquidity,
542         uint amountTokenMin,
543         uint amountETHMin,
544         address to,
545         uint deadline,
546         bool approveMax, uint8 v, bytes32 r, bytes32 s
547     ) external virtual override returns (uint amountETH) {
548         address pair = UniswapV2Library.pairFor(factory, token, WETH);
549         uint value = approveMax ? uint(- 1) : liquidity;
550         IUniswapV2Pair(pair).permit(msg.sender, address(this), value, deadline, v, r, s);
551         amountETH = removeLiquidityETHSupportingFeeOnTransferTokens(
552             token, liquidity, amountTokenMin, amountETHMin, to, deadline
553         );
554     }
555 
556     // **** SWAP ****
557     // requires the initial amount to have already been sent to the first pair
558     function _swap(uint[] memory amounts, address[] memory path, address _to) internal virtual {
559         for (uint i; i < path.length - 1; i++) {
560             (address input, address output) = (path[i], path[i + 1]);
561             (address token0,) = UniswapV2Library.sortTokens(input, output);
562             uint amountOut = amounts[i + 1];
563             (uint amount0Out, uint amount1Out) = input == token0 ? (uint(0), amountOut) : (amountOut, uint(0));
564             address to = i < path.length - 2 ? UniswapV2Library.pairFor(factory, output, path[i + 2]) : _to;
565             IUniswapV2Pair(UniswapV2Library.pairFor(factory, input, output)).swap(
566                 amount0Out, amount1Out, to, new bytes(0)
567             );
568         }
569     }
570 
571     function swapExactTokensForTokens(
572         uint amountIn,
573         uint amountOutMin,
574         address[] calldata path,
575         address to,
576         uint deadline
577     ) external virtual override ensure(deadline) returns (uint[] memory amounts) {
578         amounts = UniswapV2Library.getAmountsOut(factory, amountIn, path);
579         require(amounts[amounts.length - 1] >= amountOutMin, 'UniswapV2Router: INSUFFICIENT_OUTPUT_AMOUNT');
580         TransferHelper.safeTransferFrom(
581             path[0], msg.sender, UniswapV2Library.pairFor(factory, path[0], path[1]), amounts[0]
582         );
583         _swap(amounts, path, to);
584     }
585 
586     function swapTokensForExactTokens(
587         uint amountOut,
588         uint amountInMax,
589         address[] calldata path,
590         address to,
591         uint deadline
592     ) external virtual override ensure(deadline) returns (uint[] memory amounts) {
593         amounts = UniswapV2Library.getAmountsIn(factory, amountOut, path);
594         require(amounts[0] <= amountInMax, 'UniswapV2Router: EXCESSIVE_INPUT_AMOUNT');
595         TransferHelper.safeTransferFrom(
596             path[0], msg.sender, UniswapV2Library.pairFor(factory, path[0], path[1]), amounts[0]
597         );
598         _swap(amounts, path, to);
599     }
600 
601     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
602     external
603     virtual
604     override
605     payable
606     ensure(deadline)
607     returns (uint[] memory amounts)
608     {
609         require(path[0] == WETH, 'UniswapV2Router: INVALID_PATH');
610         amounts = UniswapV2Library.getAmountsOut(factory, msg.value, path);
611         require(amounts[amounts.length - 1] >= amountOutMin, 'UniswapV2Router: INSUFFICIENT_OUTPUT_AMOUNT');
612         IWETH(WETH).deposit{value : amounts[0]}();
613         assert(IWETH(WETH).transfer(UniswapV2Library.pairFor(factory, path[0], path[1]), amounts[0]));
614         _swap(amounts, path, to);
615     }
616 
617     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
618     external
619     virtual
620     override
621     ensure(deadline)
622     returns (uint[] memory amounts)
623     {
624         require(path[path.length - 1] == WETH, 'UniswapV2Router: INVALID_PATH');
625         amounts = UniswapV2Library.getAmountsIn(factory, amountOut, path);
626         require(amounts[0] <= amountInMax, 'UniswapV2Router: EXCESSIVE_INPUT_AMOUNT');
627         TransferHelper.safeTransferFrom(
628             path[0], msg.sender, UniswapV2Library.pairFor(factory, path[0], path[1]), amounts[0]
629         );
630         _swap(amounts, path, address(this));
631         IWETH(WETH).withdraw(amounts[amounts.length - 1]);
632         TransferHelper.safeTransferETH(to, amounts[amounts.length - 1]);
633     }
634 
635     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
636     external
637     virtual
638     override
639     ensure(deadline)
640     returns (uint[] memory amounts)
641     {
642         require(path[path.length - 1] == WETH, 'UniswapV2Router: INVALID_PATH');
643         amounts = UniswapV2Library.getAmountsOut(factory, amountIn, path);
644         require(amounts[amounts.length - 1] >= amountOutMin, 'UniswapV2Router: INSUFFICIENT_OUTPUT_AMOUNT');
645         TransferHelper.safeTransferFrom(
646             path[0], msg.sender, UniswapV2Library.pairFor(factory, path[0], path[1]), amounts[0]
647         );
648         _swap(amounts, path, address(this));
649         IWETH(WETH).withdraw(amounts[amounts.length - 1]);
650         TransferHelper.safeTransferETH(to, amounts[amounts.length - 1]);
651     }
652 
653     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
654     external
655     virtual
656     override
657     payable
658     ensure(deadline)
659     returns (uint[] memory amounts)
660     {
661         require(path[0] == WETH, 'UniswapV2Router: INVALID_PATH');
662         amounts = UniswapV2Library.getAmountsIn(factory, amountOut, path);
663         require(amounts[0] <= msg.value, 'UniswapV2Router: EXCESSIVE_INPUT_AMOUNT');
664         IWETH(WETH).deposit{value : amounts[0]}();
665         assert(IWETH(WETH).transfer(UniswapV2Library.pairFor(factory, path[0], path[1]), amounts[0]));
666         _swap(amounts, path, to);
667         // refund dust eth, if any
668         if (msg.value > amounts[0]) TransferHelper.safeTransferETH(msg.sender, msg.value - amounts[0]);
669     }
670 
671     // **** SWAP (supporting fee-on-transfer tokens) ****
672     // requires the initial amount to have already been sent to the first pair
673     function _swapSupportingFeeOnTransferTokens(address[] memory path, address _to) internal virtual {
674         for (uint i; i < path.length - 1; i++) {
675             (address input, address output) = (path[i], path[i + 1]);
676             (address token0,) = UniswapV2Library.sortTokens(input, output);
677             IUniswapV2Pair pair = IUniswapV2Pair(UniswapV2Library.pairFor(factory, input, output));
678             uint amountInput;
679             uint amountOutput;
680             {// scope to avoid stack too deep errors
681                 (uint reserve0, uint reserve1,) = pair.getReserves();
682                 (uint reserveInput, uint reserveOutput) = input == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
683                 amountInput = IERC20Uniswap(input).balanceOf(address(pair)).sub(reserveInput);
684                 amountOutput = UniswapV2Library.getAmountOut(amountInput, reserveInput, reserveOutput);
685             }
686             (uint amount0Out, uint amount1Out) = input == token0 ? (uint(0), amountOutput) : (amountOutput, uint(0));
687             address to = i < path.length - 2 ? UniswapV2Library.pairFor(factory, output, path[i + 2]) : _to;
688             pair.swap(amount0Out, amount1Out, to, new bytes(0));
689         }
690     }
691 
692     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
693         uint amountIn,
694         uint amountOutMin,
695         address[] calldata path,
696         address to,
697         uint deadline
698     ) external virtual override ensure(deadline) {
699         TransferHelper.safeTransferFrom(
700             path[0], msg.sender, UniswapV2Library.pairFor(factory, path[0], path[1]), amountIn
701         );
702         uint balanceBefore = IERC20Uniswap(path[path.length - 1]).balanceOf(to);
703         _swapSupportingFeeOnTransferTokens(path, to);
704         require(
705             IERC20Uniswap(path[path.length - 1]).balanceOf(to).sub(balanceBefore) >= amountOutMin,
706             'UniswapV2Router: INSUFFICIENT_OUTPUT_AMOUNT'
707         );
708     }
709 
710     function swapExactETHForTokensSupportingFeeOnTransferTokens(
711         uint amountOutMin,
712         address[] calldata path,
713         address to,
714         uint deadline
715     )
716     external
717     virtual
718     override
719     payable
720     ensure(deadline)
721     {
722         require(path[0] == WETH, 'UniswapV2Router: INVALID_PATH');
723         uint amountIn = msg.value;
724         IWETH(WETH).deposit{value : amountIn}();
725         assert(IWETH(WETH).transfer(UniswapV2Library.pairFor(factory, path[0], path[1]), amountIn));
726         uint balanceBefore = IERC20Uniswap(path[path.length - 1]).balanceOf(to);
727         _swapSupportingFeeOnTransferTokens(path, to);
728         require(
729             IERC20Uniswap(path[path.length - 1]).balanceOf(to).sub(balanceBefore) >= amountOutMin,
730             'UniswapV2Router: INSUFFICIENT_OUTPUT_AMOUNT'
731         );
732     }
733 
734     function swapExactTokensForETHSupportingFeeOnTransferTokens(
735         uint amountIn,
736         uint amountOutMin,
737         address[] calldata path,
738         address to,
739         uint deadline
740     )
741     external
742     virtual
743     override
744     ensure(deadline)
745     {
746         require(path[path.length - 1] == WETH, 'UniswapV2Router: INVALID_PATH');
747         TransferHelper.safeTransferFrom(
748             path[0], msg.sender, UniswapV2Library.pairFor(factory, path[0], path[1]), amountIn
749         );
750         _swapSupportingFeeOnTransferTokens(path, address(this));
751         uint amountOut = IERC20Uniswap(WETH).balanceOf(address(this));
752         require(amountOut >= amountOutMin, 'UniswapV2Router: INSUFFICIENT_OUTPUT_AMOUNT');
753         IWETH(WETH).withdraw(amountOut);
754         TransferHelper.safeTransferETH(to, amountOut);
755     }
756 
757     // **** LIBRARY FUNCTIONS ****
758     function quote(uint amountA, uint reserveA, uint reserveB) public pure virtual override returns (uint amountB) {
759         return UniswapV2Library.quote(amountA, reserveA, reserveB);
760     }
761 
762     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut)
763     public
764     pure
765     virtual
766     override
767     returns (uint amountOut)
768     {
769         return UniswapV2Library.getAmountOut(amountIn, reserveIn, reserveOut);
770     }
771 
772     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut)
773     public
774     pure
775     virtual
776     override
777     returns (uint amountIn)
778     {
779         return UniswapV2Library.getAmountIn(amountOut, reserveIn, reserveOut);
780     }
781 
782     function getAmountsOut(uint amountIn, address[] memory path)
783     public
784     view
785     virtual
786     override
787     returns (uint[] memory amounts)
788     {
789         return UniswapV2Library.getAmountsOut(factory, amountIn, path);
790     }
791 
792     function getAmountsIn(uint amountOut, address[] memory path)
793     public
794     view
795     virtual
796     override
797     returns (uint[] memory amounts)
798     {
799         return UniswapV2Library.getAmountsIn(factory, amountOut, path);
800     }
801 }