1 /**
2  *Submitted for verification at Etherscan.io on 2020-12-29
3 */
4 
5 pragma solidity =0.6.12;
6 
7 // SPDX-License-Identifier: MIT
8 
9 interface PocketSwapV2Pair {
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
60 library SafeMatswap {
61     function add(uint x, uint y) internal pure returns (uint z) {
62         require((z = x + y) >= x, 'ds-math-add-overflow');
63     }
64 
65     function sub(uint x, uint y) internal pure returns (uint z) {
66         require((z = x - y) <= x, 'ds-math-sub-underflow');
67     }
68 
69     function mul(uint x, uint y) internal pure returns (uint z) {
70         require(y == 0 || (z = x * y) / y == x, 'ds-math-mul-overflow');
71     }
72 }
73 
74 
75 library PocketSwapV2Library {
76     using SafeMatswap for uint;
77 
78     // returns sorted token addresses, used to handle return values from pairs sorted in this order
79     function sortTokens(address tokenA, address tokenB) internal pure returns (address token0, address token1) {
80         require(tokenA != tokenB, 'PocketSwapV2Library: IDENTICAL_ADDRESSES');
81         (token0, token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
82         require(token0 != address(0), 'PocketSwapV2Library: ZERO_ADDRESS');
83     }
84 
85     // calculates the CREATE2 address for a pair without making any external calls
86     function pairFor(address factory, address tokenA, address tokenB) internal pure returns (address pair) {
87         (address token0, address token1) = sortTokens(tokenA, tokenB);
88         pair = address(uint(keccak256(abi.encodePacked(
89                 hex'ff',
90                 factory,
91                 keccak256(abi.encodePacked(token0, token1)),
92                 hex'769bed9500aa97b61c54bd21d2e876339984fecd50d2a5d78668f8fdb3754b6f' // init code hash
93             ))));
94     }
95 
96     // fetches and sorts the reserves for a pair
97     function getReserves(address factory, address tokenA, address tokenB) internal view returns (uint reserveA, uint reserveB) {
98         (address token0,) = sortTokens(tokenA, tokenB);
99         (uint reserve0, uint reserve1,) = PocketSwapV2Pair(pairFor(factory, tokenA, tokenB)).getReserves();
100         (reserveA, reserveB) = tokenA == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
101     }
102 
103     // given some amount of an asset and pair reserves, returns an equivalent amount of the other asset
104     function quote(uint amountA, uint reserveA, uint reserveB) internal pure returns (uint amountB) {
105         require(amountA > 0, 'PocketSwapV2Library: INSUFFICIENT_AMOUNT');
106         require(reserveA > 0 && reserveB > 0, 'PocketSwapV2Library: INSUFFICIENT_LIQUIDITY');
107         amountB = amountA.mul(reserveB) / reserveA;
108     }
109 
110     // given an input amount of an asset and pair reserves, returns the maximum output amount of the other asset
111     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) internal pure returns (uint amountOut) {
112         require(amountIn > 0, 'PocketSwapV2Library: INSUFFICIENT_INPUT_AMOUNT');
113         require(reserveIn > 0 && reserveOut > 0, 'PocketSwapV2Library: INSUFFICIENT_LIQUIDITY');
114         uint amountInWithFee = amountIn.mul(997);
115         uint numerator = amountInWithFee.mul(reserveOut);
116         uint denominator = reserveIn.mul(1000).add(amountInWithFee);
117         amountOut = numerator / denominator;
118     }
119 
120     // given an output amount of an asset and pair reserves, returns a required input amount of the other asset
121     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) internal pure returns (uint amountIn) {
122         require(amountOut > 0, 'PocketSwapV2Library: INSUFFICIENT_OUTPUT_AMOUNT');
123         require(reserveIn > 0 && reserveOut > 0, 'PocketSwapV2Library: INSUFFICIENT_LIQUIDITY');
124         uint numerator = reserveIn.mul(amountOut).mul(1000);
125         uint denominator = reserveOut.sub(amountOut).mul(997);
126         amountIn = (numerator / denominator).add(1);
127     }
128 
129     // performs chained getAmountOut calculations on any number of pairs
130     function getAmountsOut(address factory, uint amountIn, address[] memory path) internal view returns (uint[] memory amounts) {
131         require(path.length >= 2, 'PocketSwapV2Library: INVALID_PATH');
132         amounts = new uint[](path.length);
133         amounts[0] = amountIn;
134         for (uint i; i < path.length - 1; i++) {
135             (uint reserveIn, uint reserveOut) = getReserves(factory, path[i], path[i + 1]);
136             amounts[i + 1] = getAmountOut(amounts[i], reserveIn, reserveOut);
137         }
138     }
139 
140     // performs chained getAmountIn calculations on any number of pairs
141     function getAmountsIn(address factory, uint amountOut, address[] memory path) internal view returns (uint[] memory amounts) {
142         require(path.length >= 2, 'PocketSwapV2Library: INVALID_PATH');
143         amounts = new uint[](path.length);
144         amounts[amounts.length - 1] = amountOut;
145         for (uint i = path.length - 1; i > 0; i--) {
146             (uint reserveIn, uint reserveOut) = getReserves(factory, path[i - 1], path[i]);
147             amounts[i - 1] = getAmountIn(amounts[i], reserveIn, reserveOut);
148         }
149     }
150 }
151 
152 
153 // helper methods for interacting with ERC20 tokens and sending ETH that do not consistently return true/false
154 library TransferHelper {
155     function safeApprove(address token, address to, uint value) internal {
156         // bytes4(keccak256(bytes('approve(address,uint256)')));
157         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x095ea7b3, to, value));
158         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: APPROVE_FAILED');
159     }
160 
161     function safeTransfer(address token, address to, uint value) internal {
162         // bytes4(keccak256(bytes('transfer(address,uint256)')));
163         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));
164         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FAILED');
165     }
166 
167     function safeTransferFrom(address token, address from, address to, uint value) internal {
168         // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
169         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));
170         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FROM_FAILED');
171     }
172 
173     function safeTransferETH(address to, uint value) internal {
174         (bool success,) = to.call{value:value}(new bytes(0));
175         require(success, 'TransferHelper: ETH_TRANSFER_FAILED');
176     }
177 }
178 
179 interface IPocketSwapV2Router01 {
180     function factory() external pure returns (address);
181     function WETH() external pure returns (address);
182 
183     function addLiquidity(
184         address tokenA,
185         address tokenB,
186         uint amountADesired,
187         uint amountBDesired,
188         uint amountAMin,
189         uint amountBMin,
190         address to,
191         uint deadline
192     ) external returns (uint amountA, uint amountB, uint liquidity);
193     function addLiquidityETH(
194         address token,
195         uint amountTokenDesired,
196         uint amountTokenMin,
197         uint amountETHMin,
198         address to,
199         uint deadline
200     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
201     function removeLiquidity(
202         address tokenA,
203         address tokenB,
204         uint liquidity,
205         uint amountAMin,
206         uint amountBMin,
207         address to,
208         uint deadline
209     ) external returns (uint amountA, uint amountB);
210     function removeLiquidityETH(
211         address token,
212         uint liquidity,
213         uint amountTokenMin,
214         uint amountETHMin,
215         address to,
216         uint deadline
217     ) external returns (uint amountToken, uint amountETH);
218     function removeLiquidityWithPermit(
219         address tokenA,
220         address tokenB,
221         uint liquidity,
222         uint amountAMin,
223         uint amountBMin,
224         address to,
225         uint deadline,
226         bool approveMax, uint8 v, bytes32 r, bytes32 s
227     ) external returns (uint amountA, uint amountB);
228     function removeLiquidityETHWithPermit(
229         address token,
230         uint liquidity,
231         uint amountTokenMin,
232         uint amountETHMin,
233         address to,
234         uint deadline,
235         bool approveMax, uint8 v, bytes32 r, bytes32 s
236     ) external returns (uint amountToken, uint amountETH);
237     function swapExactTokensForTokens(
238         uint amountIn,
239         uint amountOutMin,
240         address[] calldata path,
241         address to,
242         uint deadline
243     ) external returns (uint[] memory amounts);
244     function swapTokensForExactTokens(
245         uint amountOut,
246         uint amountInMax,
247         address[] calldata path,
248         address to,
249         uint deadline
250     ) external returns (uint[] memory amounts);
251     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
252         external
253         payable
254         returns (uint[] memory amounts);
255     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
256         external
257         returns (uint[] memory amounts);
258     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
259         external
260         returns (uint[] memory amounts);
261     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
262         external
263         payable
264         returns (uint[] memory amounts);
265 
266     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
267     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
268     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
269     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
270     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
271 }
272 
273 interface IPocketSwapV2Router02 is IPocketSwapV2Router01 {
274     function removeLiquidityETHSupportingFeeOnTransferTokens(
275         address token,
276         uint liquidity,
277         uint amountTokenMin,
278         uint amountETHMin,
279         address to,
280         uint deadline
281     ) external returns (uint amountETH);
282     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
283         address token,
284         uint liquidity,
285         uint amountTokenMin,
286         uint amountETHMin,
287         address to,
288         uint deadline,
289         bool approveMax, uint8 v, bytes32 r, bytes32 s
290     ) external returns (uint amountETH);
291 
292     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
293         uint amountIn,
294         uint amountOutMin,
295         address[] calldata path,
296         address to,
297         uint deadline
298     ) external;
299     function swapExactETHForTokensSupportingFeeOnTransferTokens(
300         uint amountOutMin,
301         address[] calldata path,
302         address to,
303         uint deadline
304     ) external payable;
305     function swapExactTokensForETHSupportingFeeOnTransferTokens(
306         uint amountIn,
307         uint amountOutMin,
308         address[] calldata path,
309         address to,
310         uint deadline
311     ) external;
312 }
313 interface IPocketSwapV2Factory {
314     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
315 
316     function feeTo() external view returns (address);
317     function feeToSetter() external view returns (address);
318 
319     function getPair(address tokenA, address tokenB) external view returns (address pair);
320     function allPairs(uint) external view returns (address pair);
321     function allPairsLength() external view returns (uint);
322 
323     function createPair(address tokenA, address tokenB) external returns (address pair);
324 
325     function setFeeTo(address) external;
326     function setFeeToSetter(address) external;
327 }
328 
329 interface IERC20PocketSwap {
330     event Approval(address indexed owner, address indexed spender, uint value);
331     event Transfer(address indexed from, address indexed to, uint value);
332 
333     function name() external view returns (string memory);
334     function symbol() external view returns (string memory);
335     function decimals() external view returns (uint8);
336     function totalSupply() external view returns (uint);
337     function balanceOf(address owner) external view returns (uint);
338     function allowance(address owner, address spender) external view returns (uint);
339 
340     function approve(address spender, uint value) external returns (bool);
341     function transfer(address to, uint value) external returns (bool);
342     function transferFrom(address from, address to, uint value) external returns (bool);
343 }
344 
345 
346 
347 interface IWETH {
348     function deposit() external payable;
349     function transfer(address to, uint value) external returns (bool);
350     function withdraw(uint) external;
351 }
352 
353 contract PocketSwapV2Router02 is IPocketSwapV2Router02 {
354     using SafeMatswap for uint;
355 
356     address public immutable override factory;
357     address public immutable override WETH;
358 
359     modifier ensure(uint deadline) {
360         require(deadline >= block.timestamp, 'PocketSwapV2Router: EXPIRED');
361         _;
362     }
363 
364     constructor(address _factory, address _WETH) public {
365         factory = _factory;
366         WETH = _WETH;
367     }
368 
369     receive() external payable {
370         assert(msg.sender == WETH); // only accept ETH via fallback from the WETH contract
371     }
372 
373     // **** ADD LIQUIDITY ****
374     function _addLiquidity(
375         address tokenA,
376         address tokenB,
377         uint amountADesired,
378         uint amountBDesired,
379         uint amountAMin,
380         uint amountBMin
381     ) internal virtual returns (uint amountA, uint amountB) {
382         // create the pair if it doesn't exist yet
383         if (IPocketSwapV2Factory(factory).getPair(tokenA, tokenB) == address(0)) {
384             IPocketSwapV2Factory(factory).createPair(tokenA, tokenB);
385         }
386         (uint reserveA, uint reserveB) = PocketSwapV2Library.getReserves(factory, tokenA, tokenB);
387         if (reserveA == 0 && reserveB == 0) {
388             (amountA, amountB) = (amountADesired, amountBDesired);
389         } else {
390             uint amountBOptimal = PocketSwapV2Library.quote(amountADesired, reserveA, reserveB);
391             if (amountBOptimal <= amountBDesired) {
392                 require(amountBOptimal >= amountBMin, 'PocketSwapV2Router: INSUFFICIENT_B_AMOUNT');
393                 (amountA, amountB) = (amountADesired, amountBOptimal);
394             } else {
395                 uint amountAOptimal = PocketSwapV2Library.quote(amountBDesired, reserveB, reserveA);
396                 assert(amountAOptimal <= amountADesired);
397                 require(amountAOptimal >= amountAMin, 'PocketSwapV2Router: INSUFFICIENT_A_AMOUNT');
398                 (amountA, amountB) = (amountAOptimal, amountBDesired);
399             }
400         }
401     }
402     function addLiquidity(
403         address tokenA,
404         address tokenB,
405         uint amountADesired,
406         uint amountBDesired,
407         uint amountAMin,
408         uint amountBMin,
409         address to,
410         uint deadline
411     ) external virtual override ensure(deadline) returns (uint amountA, uint amountB, uint liquidity) {
412         (amountA, amountB) = _addLiquidity(tokenA, tokenB, amountADesired, amountBDesired, amountAMin, amountBMin);
413         address pair = PocketSwapV2Library.pairFor(factory, tokenA, tokenB);
414         TransferHelper.safeTransferFrom(tokenA, msg.sender, pair, amountA);
415         TransferHelper.safeTransferFrom(tokenB, msg.sender, pair, amountB);
416         liquidity = PocketSwapV2Pair(pair).mint(to);
417     }
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
434         address pair = PocketSwapV2Library.pairFor(factory, token, WETH);
435         TransferHelper.safeTransferFrom(token, msg.sender, pair, amountToken);
436         IWETH(WETH).deposit{value: amountETH}();
437         assert(IWETH(WETH).transfer(pair, amountETH));
438         liquidity = PocketSwapV2Pair(pair).mint(to);
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
453         address pair = PocketSwapV2Library.pairFor(factory, tokenA, tokenB);
454         PocketSwapV2Pair(pair).transferFrom(msg.sender, pair, liquidity); // send liquidity to pair
455         (uint amount0, uint amount1) = PocketSwapV2Pair(pair).burn(to);
456         (address token0,) = PocketSwapV2Library.sortTokens(tokenA, tokenB);
457         (amountA, amountB) = tokenA == token0 ? (amount0, amount1) : (amount1, amount0);
458         require(amountA >= amountAMin, 'PocketSwapV2Router: INSUFFICIENT_A_AMOUNT');
459         require(amountB >= amountBMin, 'PocketSwapV2Router: INSUFFICIENT_B_AMOUNT');
460     }
461     function removeLiquidityETH(
462         address token,
463         uint liquidity,
464         uint amountTokenMin,
465         uint amountETHMin,
466         address to,
467         uint deadline
468     ) public virtual override ensure(deadline) returns (uint amountToken, uint amountETH) {
469         (amountToken, amountETH) = removeLiquidity(
470             token,
471             WETH,
472             liquidity,
473             amountTokenMin,
474             amountETHMin,
475             address(this),
476             deadline
477         );
478         TransferHelper.safeTransfer(token, to, amountToken);
479         IWETH(WETH).withdraw(amountETH);
480         TransferHelper.safeTransferETH(to, amountETH);
481     }
482     function removeLiquidityWithPermit(
483         address tokenA,
484         address tokenB,
485         uint liquidity,
486         uint amountAMin,
487         uint amountBMin,
488         address to,
489         uint deadline,
490         bool approveMax, uint8 v, bytes32 r, bytes32 s
491     ) external virtual override returns (uint amountA, uint amountB) {
492         address pair = PocketSwapV2Library.pairFor(factory, tokenA, tokenB);
493         uint value = approveMax ? uint(-1) : liquidity;
494         PocketSwapV2Pair(pair).permit(msg.sender, address(this), value, deadline, v, r, s);
495         (amountA, amountB) = removeLiquidity(tokenA, tokenB, liquidity, amountAMin, amountBMin, to, deadline);
496     }
497     function removeLiquidityETHWithPermit(
498         address token,
499         uint liquidity,
500         uint amountTokenMin,
501         uint amountETHMin,
502         address to,
503         uint deadline,
504         bool approveMax, uint8 v, bytes32 r, bytes32 s
505     ) external virtual override returns (uint amountToken, uint amountETH) {
506         address pair = PocketSwapV2Library.pairFor(factory, token, WETH);
507         uint value = approveMax ? uint(-1) : liquidity;
508         PocketSwapV2Pair(pair).permit(msg.sender, address(this), value, deadline, v, r, s);
509         (amountToken, amountETH) = removeLiquidityETH(token, liquidity, amountTokenMin, amountETHMin, to, deadline);
510     }
511 
512     // **** REMOVE LIQUIDITY (supporting fee-on-transfer tokens) ****
513     function removeLiquidityETHSupportingFeeOnTransferTokens(
514         address token,
515         uint liquidity,
516         uint amountTokenMin,
517         uint amountETHMin,
518         address to,
519         uint deadline
520     ) public virtual override ensure(deadline) returns (uint amountETH) {
521         (, amountETH) = removeLiquidity(
522             token,
523             WETH,
524             liquidity,
525             amountTokenMin,
526             amountETHMin,
527             address(this),
528             deadline
529         );
530         TransferHelper.safeTransfer(token, to, IERC20PocketSwap(token).balanceOf(address(this)));
531         IWETH(WETH).withdraw(amountETH);
532         TransferHelper.safeTransferETH(to, amountETH);
533     }
534     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
535         address token,
536         uint liquidity,
537         uint amountTokenMin,
538         uint amountETHMin,
539         address to,
540         uint deadline,
541         bool approveMax, uint8 v, bytes32 r, bytes32 s
542     ) external virtual override returns (uint amountETH) {
543         address pair = PocketSwapV2Library.pairFor(factory, token, WETH);
544         uint value = approveMax ? uint(-1) : liquidity;
545         PocketSwapV2Pair(pair).permit(msg.sender, address(this), value, deadline, v, r, s);
546         amountETH = removeLiquidityETHSupportingFeeOnTransferTokens(
547             token, liquidity, amountTokenMin, amountETHMin, to, deadline
548         );
549     }
550 
551     // **** SWAP ****
552     // requires the initial amount to have already been sent to the first pair
553     function _swap(uint[] memory amounts, address[] memory path, address _to) internal virtual {
554         for (uint i; i < path.length - 1; i++) {
555             (address input, address output) = (path[i], path[i + 1]);
556             (address token0,) = PocketSwapV2Library.sortTokens(input, output);
557             uint amountOut = amounts[i + 1];
558             (uint amount0Out, uint amount1Out) = input == token0 ? (uint(0), amountOut) : (amountOut, uint(0));
559             address to = i < path.length - 2 ? PocketSwapV2Library.pairFor(factory, output, path[i + 2]) : _to;
560             PocketSwapV2Pair(PocketSwapV2Library.pairFor(factory, input, output)).swap(
561                 amount0Out, amount1Out, to, new bytes(0)
562             );
563         }
564     }
565     function swapExactTokensForTokens(
566         uint amountIn,
567         uint amountOutMin,
568         address[] calldata path,
569         address to,
570         uint deadline
571     ) external virtual override ensure(deadline) returns (uint[] memory amounts) {
572         amounts = PocketSwapV2Library.getAmountsOut(factory, amountIn, path);
573         require(amounts[amounts.length - 1] >= amountOutMin, 'PocketSwapV2Router: INSUFFICIENT_OUTPUT_AMOUNT');
574         TransferHelper.safeTransferFrom(
575             path[0], msg.sender, PocketSwapV2Library.pairFor(factory, path[0], path[1]), amounts[0]
576         );
577         _swap(amounts, path, to);
578     }
579     function swapTokensForExactTokens(
580         uint amountOut,
581         uint amountInMax,
582         address[] calldata path,
583         address to,
584         uint deadline
585     ) external virtual override ensure(deadline) returns (uint[] memory amounts) {
586         amounts = PocketSwapV2Library.getAmountsIn(factory, amountOut, path);
587         require(amounts[0] <= amountInMax, 'PocketSwapV2Router: EXCESSIVE_INPUT_AMOUNT');
588         TransferHelper.safeTransferFrom(
589             path[0], msg.sender, PocketSwapV2Library.pairFor(factory, path[0], path[1]), amounts[0]
590         );
591         _swap(amounts, path, to);
592     }
593     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
594         external
595         virtual
596         override
597         payable
598         ensure(deadline)
599         returns (uint[] memory amounts)
600     {
601         require(path[0] == WETH, 'PocketSwapV2Router: INVALID_PATH');
602         amounts = PocketSwapV2Library.getAmountsOut(factory, msg.value, path);
603         require(amounts[amounts.length - 1] >= amountOutMin, 'PocketSwapV2Router: INSUFFICIENT_OUTPUT_AMOUNT');
604         IWETH(WETH).deposit{value: amounts[0]}();
605         assert(IWETH(WETH).transfer(PocketSwapV2Library.pairFor(factory, path[0], path[1]), amounts[0]));
606         _swap(amounts, path, to);
607     }
608     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
609         external
610         virtual
611         override
612         ensure(deadline)
613         returns (uint[] memory amounts)
614     {
615         require(path[path.length - 1] == WETH, 'PocketSwapV2Router: INVALID_PATH');
616         amounts = PocketSwapV2Library.getAmountsIn(factory, amountOut, path);
617         require(amounts[0] <= amountInMax, 'PocketSwapV2Router: EXCESSIVE_INPUT_AMOUNT');
618         TransferHelper.safeTransferFrom(
619             path[0], msg.sender, PocketSwapV2Library.pairFor(factory, path[0], path[1]), amounts[0]
620         );
621         _swap(amounts, path, address(this));
622         IWETH(WETH).withdraw(amounts[amounts.length - 1]);
623         TransferHelper.safeTransferETH(to, amounts[amounts.length - 1]);
624     }
625     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
626         external
627         virtual
628         override
629         ensure(deadline)
630         returns (uint[] memory amounts)
631     {
632         require(path[path.length - 1] == WETH, 'PocketSwapV2Router: INVALID_PATH');
633         amounts = PocketSwapV2Library.getAmountsOut(factory, amountIn, path);
634         require(amounts[amounts.length - 1] >= amountOutMin, 'PocketSwapV2Router: INSUFFICIENT_OUTPUT_AMOUNT');
635         TransferHelper.safeTransferFrom(
636             path[0], msg.sender, PocketSwapV2Library.pairFor(factory, path[0], path[1]), amounts[0]
637         );
638         _swap(amounts, path, address(this));
639         IWETH(WETH).withdraw(amounts[amounts.length - 1]);
640         TransferHelper.safeTransferETH(to, amounts[amounts.length - 1]);
641     }
642     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
643         external
644         virtual
645         override
646         payable
647         ensure(deadline)
648         returns (uint[] memory amounts)
649     {
650         require(path[0] == WETH, 'PocketSwapV2Router: INVALID_PATH');
651         amounts = PocketSwapV2Library.getAmountsIn(factory, amountOut, path);
652         require(amounts[0] <= msg.value, 'PocketSwapV2Router: EXCESSIVE_INPUT_AMOUNT');
653         IWETH(WETH).deposit{value: amounts[0]}();
654         assert(IWETH(WETH).transfer(PocketSwapV2Library.pairFor(factory, path[0], path[1]), amounts[0]));
655         _swap(amounts, path, to);
656         // refund dust eth, if any
657         if (msg.value > amounts[0]) TransferHelper.safeTransferETH(msg.sender, msg.value - amounts[0]);
658     }
659 
660     // **** SWAP (supporting fee-on-transfer tokens) ****
661     // requires the initial amount to have already been sent to the first pair
662     function _swapSupportingFeeOnTransferTokens(address[] memory path, address _to) internal virtual {
663         for (uint i; i < path.length - 1; i++) {
664             (address input, address output) = (path[i], path[i + 1]);
665             (address token0,) = PocketSwapV2Library.sortTokens(input, output);
666             PocketSwapV2Pair pair = PocketSwapV2Pair(PocketSwapV2Library.pairFor(factory, input, output));
667             uint amountInput;
668             uint amountOutput;
669             { // scope to avoid stack too deep errors
670             (uint reserve0, uint reserve1,) = pair.getReserves();
671             (uint reserveInput, uint reserveOutput) = input == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
672             amountInput = IERC20PocketSwap(input).balanceOf(address(pair)).sub(reserveInput);
673             amountOutput = PocketSwapV2Library.getAmountOut(amountInput, reserveInput, reserveOutput);
674             }
675             (uint amount0Out, uint amount1Out) = input == token0 ? (uint(0), amountOutput) : (amountOutput, uint(0));
676             address to = i < path.length - 2 ? PocketSwapV2Library.pairFor(factory, output, path[i + 2]) : _to;
677             pair.swap(amount0Out, amount1Out, to, new bytes(0));
678         }
679     }
680     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
681         uint amountIn,
682         uint amountOutMin,
683         address[] calldata path,
684         address to,
685         uint deadline
686     ) external virtual override ensure(deadline) {
687         TransferHelper.safeTransferFrom(
688             path[0], msg.sender, PocketSwapV2Library.pairFor(factory, path[0], path[1]), amountIn
689         );
690         uint balanceBefore = IERC20PocketSwap(path[path.length - 1]).balanceOf(to);
691         _swapSupportingFeeOnTransferTokens(path, to);
692         require(
693             IERC20PocketSwap(path[path.length - 1]).balanceOf(to).sub(balanceBefore) >= amountOutMin,
694             'PocketSwapV2Router: INSUFFICIENT_OUTPUT_AMOUNT'
695         );
696     }
697     function swapExactETHForTokensSupportingFeeOnTransferTokens(
698         uint amountOutMin,
699         address[] calldata path,
700         address to,
701         uint deadline
702     )
703         external
704         virtual
705         override
706         payable
707         ensure(deadline)
708     {
709         require(path[0] == WETH, 'PocketSwapV2Router: INVALID_PATH');
710         uint amountIn = msg.value;
711         IWETH(WETH).deposit{value: amountIn}();
712         assert(IWETH(WETH).transfer(PocketSwapV2Library.pairFor(factory, path[0], path[1]), amountIn));
713         uint balanceBefore = IERC20PocketSwap(path[path.length - 1]).balanceOf(to);
714         _swapSupportingFeeOnTransferTokens(path, to);
715         require(
716             IERC20PocketSwap(path[path.length - 1]).balanceOf(to).sub(balanceBefore) >= amountOutMin,
717             'PocketSwapV2Router: INSUFFICIENT_OUTPUT_AMOUNT'
718         );
719     }
720     function swapExactTokensForETHSupportingFeeOnTransferTokens(
721         uint amountIn,
722         uint amountOutMin,
723         address[] calldata path,
724         address to,
725         uint deadline
726     )
727         external
728         virtual
729         override
730         ensure(deadline)
731     {
732         require(path[path.length - 1] == WETH, 'PocketSwapV2Router: INVALID_PATH');
733         TransferHelper.safeTransferFrom(
734             path[0], msg.sender, PocketSwapV2Library.pairFor(factory, path[0], path[1]), amountIn
735         );
736         _swapSupportingFeeOnTransferTokens(path, address(this));
737         uint amountOut = IERC20PocketSwap(WETH).balanceOf(address(this));
738         require(amountOut >= amountOutMin, 'PocketSwapV2Router: INSUFFICIENT_OUTPUT_AMOUNT');
739         IWETH(WETH).withdraw(amountOut);
740         TransferHelper.safeTransferETH(to, amountOut);
741     }
742 
743     // **** LIBRARY FUNCTIONS ****
744     function quote(uint amountA, uint reserveA, uint reserveB) public pure virtual override returns (uint amountB) {
745         return PocketSwapV2Library.quote(amountA, reserveA, reserveB);
746     }
747 
748     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut)
749         public
750         pure
751         virtual
752         override
753         returns (uint amountOut)
754     {
755         return PocketSwapV2Library.getAmountOut(amountIn, reserveIn, reserveOut);
756     }
757 
758     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut)
759         public
760         pure
761         virtual
762         override
763         returns (uint amountIn)
764     {
765         return PocketSwapV2Library.getAmountIn(amountOut, reserveIn, reserveOut);
766     }
767 
768     function getAmountsOut(uint amountIn, address[] memory path)
769         public
770         view
771         virtual
772         override
773         returns (uint[] memory amounts)
774     {
775         return PocketSwapV2Library.getAmountsOut(factory, amountIn, path);
776     }
777 
778     function getAmountsIn(uint amountOut, address[] memory path)
779         public
780         view
781         virtual
782         override
783         returns (uint[] memory amounts)
784     {
785         return PocketSwapV2Library.getAmountsIn(factory, amountOut, path);
786     }
787 }