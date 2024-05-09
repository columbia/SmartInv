1 // SPDX-License-Identifier: MIT
2 pragma solidity >=0.6.0;
3 
4 // helper methods for interacting with ERC20 tokens and sending ETH that do not consistently return true/false
5 library TransferHelper {
6     function safeApprove(address token, address to, uint value) internal {
7         // bytes4(keccak256(bytes('approve(address,uint256)')));
8         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x095ea7b3, to, value));
9         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: APPROVE_FAILED');
10     }
11 
12     function safeTransfer(address token, address to, uint value) internal {
13         // bytes4(keccak256(bytes('transfer(address,uint256)')));
14         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));
15         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FAILED');
16     }
17 
18     function safeTransferFrom(address token, address from, address to, uint value) internal {
19         // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
20         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));
21         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FROM_FAILED');
22     }
23 
24     function safeTransferETH(address to, uint value) internal {
25         (bool success,) = to.call{value:value}(new bytes(0));
26         require(success, 'TransferHelper: ETH_TRANSFER_FAILED');
27     }
28 }
29 
30 // File: contracts\interfaces\IHopRouter01.sol
31 
32 pragma solidity >=0.6.2;
33 
34 interface IHopRouter01 {
35     function factory() external pure returns (address);
36     function WETH() external pure returns (address);
37 
38     function addLiquidity(
39         address tokenA,
40         address tokenB,
41         uint amountADesired,
42         uint amountBDesired,
43         uint amountAMin,
44         uint amountBMin,
45         address to,
46         uint deadline
47     ) external returns (uint amountA, uint amountB, uint liquidity);
48     function addLiquidityETH(
49         address token,
50         uint amountTokenDesired,
51         uint amountTokenMin,
52         uint amountETHMin,
53         address to,
54         uint deadline
55     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
56     function removeLiquidity(
57         address tokenA,
58         address tokenB,
59         uint liquidity,
60         uint amountAMin,
61         uint amountBMin,
62         address to,
63         uint deadline
64     ) external returns (uint amountA, uint amountB);
65     function removeLiquidityETH(
66         address token,
67         uint liquidity,
68         uint amountTokenMin,
69         uint amountETHMin,
70         address to,
71         uint deadline
72     ) external returns (uint amountToken, uint amountETH);
73     function removeLiquidityWithPermit(
74         address tokenA,
75         address tokenB,
76         uint liquidity,
77         uint amountAMin,
78         uint amountBMin,
79         address to,
80         uint deadline,
81         bool approveMax, uint8 v, bytes32 r, bytes32 s
82     ) external returns (uint amountA, uint amountB);
83     function removeLiquidityETHWithPermit(
84         address token,
85         uint liquidity,
86         uint amountTokenMin,
87         uint amountETHMin,
88         address to,
89         uint deadline,
90         bool approveMax, uint8 v, bytes32 r, bytes32 s
91     ) external returns (uint amountToken, uint amountETH);
92     function swapExactTokensForTokens(
93         uint amountIn,
94         uint amountOutMin,
95         address[] calldata path,
96         address to,
97         uint deadline
98     ) external returns (uint[] memory amounts);
99     function swapTokensForExactTokens(
100         uint amountOut,
101         uint amountInMax,
102         address[] calldata path,
103         address to,
104         uint deadline
105     ) external returns (uint[] memory amounts);
106     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
107         external
108         payable
109         returns (uint[] memory amounts);
110     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
111         external
112         returns (uint[] memory amounts);
113     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
114         external
115         returns (uint[] memory amounts);
116     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
117         external
118         payable
119         returns (uint[] memory amounts);
120 
121     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
122     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
123     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
124     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
125     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
126 }
127 
128 // File: contracts\interfaces\IHopRouter02.sol
129 
130 pragma solidity >=0.6.2;
131 
132 interface IHopRouter02 is IHopRouter01 {
133     function removeLiquidityETHSupportingFeeOnTransferTokens(
134         address token,
135         uint liquidity,
136         uint amountTokenMin,
137         uint amountETHMin,
138         address to,
139         uint deadline
140     ) external returns (uint amountETH);
141     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
142         address token,
143         uint liquidity,
144         uint amountTokenMin,
145         uint amountETHMin,
146         address to,
147         uint deadline,
148         bool approveMax, uint8 v, bytes32 r, bytes32 s
149     ) external returns (uint amountETH);
150 
151     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
152         uint amountIn,
153         uint amountOutMin,
154         address[] calldata path,
155         address to,
156         uint deadline
157     ) external;
158     function swapExactETHForTokensSupportingFeeOnTransferTokens(
159         uint amountOutMin,
160         address[] calldata path,
161         address to,
162         uint deadline
163     ) external payable;
164     function swapExactTokensForETHSupportingFeeOnTransferTokens(
165         uint amountIn,
166         uint amountOutMin,
167         address[] calldata path,
168         address to,
169         uint deadline
170     ) external;
171 }
172 
173 // File: contracts\interfaces\IHopFactory.sol
174 
175 pragma solidity >=0.5.0;
176 
177 interface IHopFactory {
178     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
179 
180     function feeTo() external view returns (address);
181     function feeToSetter() external view returns (address);
182 
183     function getPair(address tokenA, address tokenB) external view returns (address pair);
184     function allPairs(uint) external view returns (address pair);
185     function allPairsLength() external view returns (uint);
186 
187     function createPair(address tokenA, address tokenB) external returns (address pair);
188 
189     function setFeeTo(address) external;
190     function setFeeToSetter(address) external;
191 
192     function INIT_CODE_PAIR_HASH() external view returns (bytes32);
193 }
194 
195 // File: contracts\libraries\SafeMath.sol
196 
197 pragma solidity =0.6.6;
198 
199 // a library for performing overflow-safe math, courtesy of DappHub (https://github.com/dapphub/ds-math)
200 
201 library SafeMath {
202     function add(uint x, uint y) internal pure returns (uint z) {
203         require((z = x + y) >= x, 'ds-math-add-overflow');
204     }
205 
206     function sub(uint x, uint y) internal pure returns (uint z) {
207         require((z = x - y) <= x, 'ds-math-sub-underflow');
208     }
209 
210     function mul(uint x, uint y) internal pure returns (uint z) {
211         require(y == 0 || (z = x * y) / y == x, 'ds-math-mul-overflow');
212     }
213 }
214 
215 // File: contracts\interfaces\IHopPair.sol
216 
217 pragma solidity >=0.5.0;
218 
219 interface IHopPair {
220     event Approval(address indexed owner, address indexed spender, uint value);
221     event Transfer(address indexed from, address indexed to, uint value);
222 
223     function name() external pure returns (string memory);
224     function symbol() external pure returns (string memory);
225     function decimals() external pure returns (uint8);
226     function totalSupply() external view returns (uint);
227     function balanceOf(address owner) external view returns (uint);
228     function allowance(address owner, address spender) external view returns (uint);
229 
230     function approve(address spender, uint value) external returns (bool);
231     function transfer(address to, uint value) external returns (bool);
232     function transferFrom(address from, address to, uint value) external returns (bool);
233 
234     function DOMAIN_SEPARATOR() external view returns (bytes32);
235     function PERMIT_TYPEHASH() external pure returns (bytes32);
236     function nonces(address owner) external view returns (uint);
237 
238     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
239 
240     event Mint(address indexed sender, uint amount0, uint amount1);
241     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
242     event Swap(
243         address indexed sender,
244         uint amount0In,
245         uint amount1In,
246         uint amount0Out,
247         uint amount1Out,
248         address indexed to
249     );
250     event Sync(uint112 reserve0, uint112 reserve1);
251 
252     function MINIMUM_LIQUIDITY() external pure returns (uint);
253     function factory() external view returns (address);
254     function token0() external view returns (address);
255     function token1() external view returns (address);
256     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
257     function price0CumulativeLast() external view returns (uint);
258     function price1CumulativeLast() external view returns (uint);
259     function kLast() external view returns (uint);
260 
261     function mint(address to) external returns (uint liquidity);
262     function burn(address to) external returns (uint amount0, uint amount1);
263     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
264     function skim(address to) external;
265     function sync() external;
266 
267     function initialize(address, address) external;
268 }
269 
270 // File: contracts\libraries\HopLibrary.sol
271 
272 pragma solidity >=0.5.0;
273 
274 
275 
276 library HopLibrary {
277     using SafeMath for uint;
278 
279     // returns sorted token addresses, used to handle return values from pairs sorted in this order
280     function sortTokens(address tokenA, address tokenB) internal pure returns (address token0, address token1) {
281         require(tokenA != tokenB, 'HopLibrary: IDENTICAL_ADDRESSES');
282         (token0, token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
283         require(token0 != address(0), 'HopLibrary: ZERO_ADDRESS');
284     }
285 
286     // calculates the CREATE2 address for a pair without making any external calls
287     function pairFor(address factory, address tokenA, address tokenB) internal pure returns (address pair) {
288         (address token0, address token1) = sortTokens(tokenA, tokenB);
289         pair = address(uint(keccak256(abi.encodePacked(
290                 hex'ff',
291                 factory,
292                 keccak256(abi.encodePacked(token0, token1)),
293                 hex'd788d8433081cb1398ee06d930808a50bb2d6a0493c2573b6b68323cfe9b481c' // init code hash
294             ))));
295     }
296 
297     // fetches and sorts the reserves for a pair
298     function getReserves(address factory, address tokenA, address tokenB) internal view returns (uint reserveA, uint reserveB) {
299         (address token0,) = sortTokens(tokenA, tokenB);
300         pairFor(factory, tokenA, tokenB);
301         (uint reserve0, uint reserve1,) = IHopPair(pairFor(factory, tokenA, tokenB)).getReserves();
302         (reserveA, reserveB) = tokenA == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
303     }
304 
305     // given some amount of an asset and pair reserves, returns an equivalent amount of the other asset
306     function quote(uint amountA, uint reserveA, uint reserveB) internal pure returns (uint amountB) {
307         require(amountA > 0, 'HopLibrary: INSUFFICIENT_AMOUNT');
308         require(reserveA > 0 && reserveB > 0, 'HopLibrary: INSUFFICIENT_LIQUIDITY');
309         amountB = amountA.mul(reserveB) / reserveA;
310     }
311 
312     // given an input amount of an asset and pair reserves, returns the maximum output amount of the other asset
313     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) internal pure returns (uint amountOut) {
314         require(amountIn > 0, 'HopLibrary: INSUFFICIENT_INPUT_AMOUNT');
315         require(reserveIn > 0 && reserveOut > 0, 'HopLibrary: INSUFFICIENT_LIQUIDITY');
316         uint amountInWithFee = amountIn.mul(9800);
317         uint numerator = amountInWithFee.mul(reserveOut);
318         uint denominator = reserveIn.mul(10000).add(amountInWithFee);
319         amountOut = numerator / denominator;
320     }
321 
322     // given an output amount of an asset and pair reserves, returns a required input amount of the other asset
323     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) internal pure returns (uint amountIn) {
324         require(amountOut > 0, 'HopLibrary: INSUFFICIENT_OUTPUT_AMOUNT');
325         require(reserveIn > 0 && reserveOut > 0, 'HopLibrary: INSUFFICIENT_LIQUIDITY');
326         uint numerator = reserveIn.mul(amountOut).mul(10000);
327         uint denominator = reserveOut.sub(amountOut).mul(9800);
328         amountIn = (numerator / denominator).add(1);
329     }
330 
331     // performs chained getAmountOut calculations on any number of pairs
332     function getAmountsOut(address factory, uint amountIn, address[] memory path) internal view returns (uint[] memory amounts) {
333         require(path.length >= 2, 'HopLibrary: INVALID_PATH');
334         amounts = new uint[](path.length);
335         amounts[0] = amountIn;
336         for (uint i; i < path.length - 1; i++) {
337             (uint reserveIn, uint reserveOut) = getReserves(factory, path[i], path[i + 1]);
338             amounts[i + 1] = getAmountOut(amounts[i], reserveIn, reserveOut);
339         }
340     }
341 
342     // performs chained getAmountIn calculations on any number of pairs
343     function getAmountsIn(address factory, uint amountOut, address[] memory path) internal view returns (uint[] memory amounts) {
344         require(path.length >= 2, 'HopLibrary: INVALID_PATH');
345         amounts = new uint[](path.length);
346         amounts[amounts.length - 1] = amountOut;
347         for (uint i = path.length - 1; i > 0; i--) {
348             (uint reserveIn, uint reserveOut) = getReserves(factory, path[i - 1], path[i]);
349             amounts[i - 1] = getAmountIn(amounts[i], reserveIn, reserveOut);
350         }
351     }
352 }
353 
354 // File: contracts\interfaces\IERC20.sol
355 
356 pragma solidity >=0.5.0;
357 
358 interface IERC20 {
359     event Approval(address indexed owner, address indexed spender, uint value);
360     event Transfer(address indexed from, address indexed to, uint value);
361 
362     function name() external view returns (string memory);
363     function symbol() external view returns (string memory);
364     function decimals() external view returns (uint8);
365     function totalSupply() external view returns (uint);
366     function balanceOf(address owner) external view returns (uint);
367     function allowance(address owner, address spender) external view returns (uint);
368 
369     function approve(address spender, uint value) external returns (bool);
370     function transfer(address to, uint value) external returns (bool);
371     function transferFrom(address from, address to, uint value) external returns (bool);
372 }
373 
374 // File: contracts\interfaces\IWETH.sol
375 
376 pragma solidity >=0.5.0;
377 
378 interface IWETH {
379     function deposit() external payable;
380     function transfer(address to, uint value) external returns (bool);
381     function withdraw(uint) external;
382 }
383 
384 // File: contracts\HopRouter.sol
385 
386 pragma solidity =0.6.6;
387 
388 
389 
390 
391 
392 
393 
394 contract HopRouter is IHopRouter02 {
395     using SafeMath for uint;
396 
397     address public immutable override factory;
398     address public immutable override WETH;
399 
400     modifier ensure(uint deadline) {
401         require(deadline >= block.timestamp, 'HopRouter: EXPIRED');
402         _;
403     }
404 
405     constructor(address _factory, address _WETH) public {
406         factory = _factory;
407         WETH = _WETH;
408     }
409 
410     receive() external payable {
411         assert(msg.sender == WETH); // only accept ETH via fallback from the WETH contract
412     }
413 
414     // **** ADD LIQUIDITY ****
415     function _addLiquidity(
416         address tokenA,
417         address tokenB,
418         uint amountADesired,
419         uint amountBDesired,
420         uint amountAMin,
421         uint amountBMin
422     ) internal virtual returns (uint amountA, uint amountB) {
423         // create the pair if it doesn't exist yet
424         if (IHopFactory(factory).getPair(tokenA, tokenB) == address(0)) {
425             IHopFactory(factory).createPair(tokenA, tokenB);
426         }
427         (uint reserveA, uint reserveB) = HopLibrary.getReserves(factory, tokenA, tokenB);
428         if (reserveA == 0 && reserveB == 0) {
429             (amountA, amountB) = (amountADesired, amountBDesired);
430         } else {
431             uint amountBOptimal = HopLibrary.quote(amountADesired, reserveA, reserveB);
432             if (amountBOptimal <= amountBDesired) {
433                 require(amountBOptimal >= amountBMin, 'HopRouter: INSUFFICIENT_B_AMOUNT');
434                 (amountA, amountB) = (amountADesired, amountBOptimal);
435             } else {
436                 uint amountAOptimal = HopLibrary.quote(amountBDesired, reserveB, reserveA);
437                 assert(amountAOptimal <= amountADesired);
438                 require(amountAOptimal >= amountAMin, 'HopRouter: INSUFFICIENT_A_AMOUNT');
439                 (amountA, amountB) = (amountAOptimal, amountBDesired);
440             }
441         }
442     }
443     function addLiquidity(
444         address tokenA,
445         address tokenB,
446         uint amountADesired,
447         uint amountBDesired,
448         uint amountAMin,
449         uint amountBMin,
450         address to,
451         uint deadline
452     ) external virtual override ensure(deadline) returns (uint amountA, uint amountB, uint liquidity) {
453         (amountA, amountB) = _addLiquidity(tokenA, tokenB, amountADesired, amountBDesired, amountAMin, amountBMin);
454         address pair = HopLibrary.pairFor(factory, tokenA, tokenB);
455         TransferHelper.safeTransferFrom(tokenA, msg.sender, pair, amountA);
456         TransferHelper.safeTransferFrom(tokenB, msg.sender, pair, amountB);
457         liquidity = IHopPair(pair).mint(to);
458     }
459     function addLiquidityETH(
460         address token,
461         uint amountTokenDesired,
462         uint amountTokenMin,
463         uint amountETHMin,
464         address to,
465         uint deadline
466     ) external virtual override payable ensure(deadline) returns (uint amountToken, uint amountETH, uint liquidity) {
467         (amountToken, amountETH) = _addLiquidity(
468             token,
469             WETH,
470             amountTokenDesired,
471             msg.value,
472             amountTokenMin,
473             amountETHMin
474         );
475         address pair = HopLibrary.pairFor(factory, token, WETH);
476         TransferHelper.safeTransferFrom(token, msg.sender, pair, amountToken);
477         IWETH(WETH).deposit{value: amountETH}();
478         assert(IWETH(WETH).transfer(pair, amountETH));
479         liquidity = IHopPair(pair).mint(to);
480         // refund dust eth, if any
481         if (msg.value > amountETH) TransferHelper.safeTransferETH(msg.sender, msg.value - amountETH);
482     }
483 
484     // **** REMOVE LIQUIDITY ****
485     function removeLiquidity(
486         address tokenA,
487         address tokenB,
488         uint liquidity,
489         uint amountAMin,
490         uint amountBMin,
491         address to,
492         uint deadline
493     ) public virtual override ensure(deadline) returns (uint amountA, uint amountB) {
494         address pair = HopLibrary.pairFor(factory, tokenA, tokenB);
495         IHopPair(pair).transferFrom(msg.sender, pair, liquidity); // send liquidity to pair
496         (uint amount0, uint amount1) = IHopPair(pair).burn(to);
497         (address token0,) = HopLibrary.sortTokens(tokenA, tokenB);
498         (amountA, amountB) = tokenA == token0 ? (amount0, amount1) : (amount1, amount0);
499         require(amountA >= amountAMin, 'HopRouter: INSUFFICIENT_A_AMOUNT');
500         require(amountB >= amountBMin, 'HopRouter: INSUFFICIENT_B_AMOUNT');
501     }
502     function removeLiquidityETH(
503         address token,
504         uint liquidity,
505         uint amountTokenMin,
506         uint amountETHMin,
507         address to,
508         uint deadline
509     ) public virtual override ensure(deadline) returns (uint amountToken, uint amountETH) {
510         (amountToken, amountETH) = removeLiquidity(
511             token,
512             WETH,
513             liquidity,
514             amountTokenMin,
515             amountETHMin,
516             address(this),
517             deadline
518         );
519         TransferHelper.safeTransfer(token, to, amountToken);
520         IWETH(WETH).withdraw(amountETH);
521         TransferHelper.safeTransferETH(to, amountETH);
522     }
523     function removeLiquidityWithPermit(
524         address tokenA,
525         address tokenB,
526         uint liquidity,
527         uint amountAMin,
528         uint amountBMin,
529         address to,
530         uint deadline,
531         bool approveMax, uint8 v, bytes32 r, bytes32 s
532     ) external virtual override returns (uint amountA, uint amountB) {
533         address pair = HopLibrary.pairFor(factory, tokenA, tokenB);
534         uint value = approveMax ? uint(-1) : liquidity;
535         IHopPair(pair).permit(msg.sender, address(this), value, deadline, v, r, s);
536         (amountA, amountB) = removeLiquidity(tokenA, tokenB, liquidity, amountAMin, amountBMin, to, deadline);
537     }
538     function removeLiquidityETHWithPermit(
539         address token,
540         uint liquidity,
541         uint amountTokenMin,
542         uint amountETHMin,
543         address to,
544         uint deadline,
545         bool approveMax, uint8 v, bytes32 r, bytes32 s
546     ) external virtual override returns (uint amountToken, uint amountETH) {
547         address pair = HopLibrary.pairFor(factory, token, WETH);
548         uint value = approveMax ? uint(-1) : liquidity;
549         IHopPair(pair).permit(msg.sender, address(this), value, deadline, v, r, s);
550         (amountToken, amountETH) = removeLiquidityETH(token, liquidity, amountTokenMin, amountETHMin, to, deadline);
551     }
552 
553     // **** REMOVE LIQUIDITY (supporting fee-on-transfer tokens) ****
554     function removeLiquidityETHSupportingFeeOnTransferTokens(
555         address token,
556         uint liquidity,
557         uint amountTokenMin,
558         uint amountETHMin,
559         address to,
560         uint deadline
561     ) public virtual override ensure(deadline) returns (uint amountETH) {
562         (, amountETH) = removeLiquidity(
563             token,
564             WETH,
565             liquidity,
566             amountTokenMin,
567             amountETHMin,
568             address(this),
569             deadline
570         );
571         TransferHelper.safeTransfer(token, to, IERC20(token).balanceOf(address(this)));
572         IWETH(WETH).withdraw(amountETH);
573         TransferHelper.safeTransferETH(to, amountETH);
574     }
575     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
576         address token,
577         uint liquidity,
578         uint amountTokenMin,
579         uint amountETHMin,
580         address to,
581         uint deadline,
582         bool approveMax, uint8 v, bytes32 r, bytes32 s
583     ) external virtual override returns (uint amountETH) {
584         address pair = HopLibrary.pairFor(factory, token, WETH);
585         uint value = approveMax ? uint(-1) : liquidity;
586         IHopPair(pair).permit(msg.sender, address(this), value, deadline, v, r, s);
587         amountETH = removeLiquidityETHSupportingFeeOnTransferTokens(
588             token, liquidity, amountTokenMin, amountETHMin, to, deadline
589         );
590     }
591 
592     // **** SWAP ****
593     // requires the initial amount to have already been sent to the first pair
594     function _swap(uint[] memory amounts, address[] memory path, address _to) internal virtual {
595         for (uint i; i < path.length - 1; i++) {
596             (address input, address output) = (path[i], path[i + 1]);
597             (address token0,) = HopLibrary.sortTokens(input, output);
598             uint amountOut = amounts[i + 1];
599             (uint amount0Out, uint amount1Out) = input == token0 ? (uint(0), amountOut) : (amountOut, uint(0));
600             address to = i < path.length - 2 ? HopLibrary.pairFor(factory, output, path[i + 2]) : _to;
601             IHopPair(HopLibrary.pairFor(factory, input, output)).swap(
602                 amount0Out, amount1Out, to, new bytes(0)
603             );
604         }
605     }
606     function swapExactTokensForTokens(
607         uint amountIn,
608         uint amountOutMin,
609         address[] calldata path,
610         address to,
611         uint deadline
612     ) external virtual override ensure(deadline) returns (uint[] memory amounts) {
613         amounts = HopLibrary.getAmountsOut(factory, amountIn, path);
614         require(amounts[amounts.length - 1] >= amountOutMin, 'HopRouter: INSUFFICIENT_OUTPUT_AMOUNT');
615         TransferHelper.safeTransferFrom(
616             path[0], msg.sender, HopLibrary.pairFor(factory, path[0], path[1]), amounts[0]
617         );
618         _swap(amounts, path, to);
619     }
620     function swapTokensForExactTokens(
621         uint amountOut,
622         uint amountInMax,
623         address[] calldata path,
624         address to,
625         uint deadline
626     ) external virtual override ensure(deadline) returns (uint[] memory amounts) {
627         amounts = HopLibrary.getAmountsIn(factory, amountOut, path);
628         require(amounts[0] <= amountInMax, 'HopRouter: EXCESSIVE_INPUT_AMOUNT');
629         TransferHelper.safeTransferFrom(
630             path[0], msg.sender, HopLibrary.pairFor(factory, path[0], path[1]), amounts[0]
631         );
632         _swap(amounts, path, to);
633     }
634     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
635         external
636         virtual
637         override
638         payable
639         ensure(deadline)
640         returns (uint[] memory amounts)
641     {
642         require(path[0] == WETH, 'HopRouter: INVALID_PATH');
643         amounts = HopLibrary.getAmountsOut(factory, msg.value, path);
644         require(amounts[amounts.length - 1] >= amountOutMin, 'HopRouter: INSUFFICIENT_OUTPUT_AMOUNT');
645         IWETH(WETH).deposit{value: amounts[0]}();
646         assert(IWETH(WETH).transfer(HopLibrary.pairFor(factory, path[0], path[1]), amounts[0]));
647         _swap(amounts, path, to);
648     }
649     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
650         external
651         virtual
652         override
653         ensure(deadline)
654         returns (uint[] memory amounts)
655     {
656         require(path[path.length - 1] == WETH, 'HopRouter: INVALID_PATH');
657         amounts = HopLibrary.getAmountsIn(factory, amountOut, path);
658         require(amounts[0] <= amountInMax, 'HopRouter: EXCESSIVE_INPUT_AMOUNT');
659         TransferHelper.safeTransferFrom(
660             path[0], msg.sender, HopLibrary.pairFor(factory, path[0], path[1]), amounts[0]
661         );
662         _swap(amounts, path, address(this));
663         IWETH(WETH).withdraw(amounts[amounts.length - 1]);
664         TransferHelper.safeTransferETH(to, amounts[amounts.length - 1]);
665     }
666     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
667         external
668         virtual
669         override
670         ensure(deadline)
671         returns (uint[] memory amounts)
672     {
673         require(path[path.length - 1] == WETH, 'HopRouter: INVALID_PATH');
674         amounts = HopLibrary.getAmountsOut(factory, amountIn, path);
675         require(amounts[amounts.length - 1] >= amountOutMin, 'HopRouter: INSUFFICIENT_OUTPUT_AMOUNT');
676         TransferHelper.safeTransferFrom(
677             path[0], msg.sender, HopLibrary.pairFor(factory, path[0], path[1]), amounts[0]
678         );
679         _swap(amounts, path, address(this));
680         IWETH(WETH).withdraw(amounts[amounts.length - 1]);
681         TransferHelper.safeTransferETH(to, amounts[amounts.length - 1]);
682     }
683     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
684         external
685         virtual
686         override
687         payable
688         ensure(deadline)
689         returns (uint[] memory amounts)
690     {
691         require(path[0] == WETH, 'HopRouter: INVALID_PATH');
692         amounts = HopLibrary.getAmountsIn(factory, amountOut, path);
693         require(amounts[0] <= msg.value, 'HopRouter: EXCESSIVE_INPUT_AMOUNT');
694         IWETH(WETH).deposit{value: amounts[0]}();
695         assert(IWETH(WETH).transfer(HopLibrary.pairFor(factory, path[0], path[1]), amounts[0]));
696         _swap(amounts, path, to);
697         // refund dust eth, if any
698         if (msg.value > amounts[0]) TransferHelper.safeTransferETH(msg.sender, msg.value - amounts[0]);
699     }
700 
701     // **** SWAP (supporting fee-on-transfer tokens) ****
702     // requires the initial amount to have already been sent to the first pair
703     function _swapSupportingFeeOnTransferTokens(address[] memory path, address _to) internal virtual {
704         for (uint i; i < path.length - 1; i++) {
705             (address input, address output) = (path[i], path[i + 1]);
706             (address token0,) = HopLibrary.sortTokens(input, output);
707             IHopPair pair = IHopPair(HopLibrary.pairFor(factory, input, output));
708             uint amountInput;
709             uint amountOutput;
710             { // scope to avoid stack too deep errors
711             (uint reserve0, uint reserve1,) = pair.getReserves();
712             (uint reserveInput, uint reserveOutput) = input == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
713             amountInput = IERC20(input).balanceOf(address(pair)).sub(reserveInput);
714             amountOutput = HopLibrary.getAmountOut(amountInput, reserveInput, reserveOutput);
715             }
716             (uint amount0Out, uint amount1Out) = input == token0 ? (uint(0), amountOutput) : (amountOutput, uint(0));
717             address to = i < path.length - 2 ? HopLibrary.pairFor(factory, output, path[i + 2]) : _to;
718             pair.swap(amount0Out, amount1Out, to, new bytes(0));
719         }
720     }
721     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
722         uint amountIn,
723         uint amountOutMin,
724         address[] calldata path,
725         address to,
726         uint deadline
727     ) external virtual override ensure(deadline) {
728         TransferHelper.safeTransferFrom(
729             path[0], msg.sender, HopLibrary.pairFor(factory, path[0], path[1]), amountIn
730         );
731         uint balanceBefore = IERC20(path[path.length - 1]).balanceOf(to);
732         _swapSupportingFeeOnTransferTokens(path, to);
733         require(
734             IERC20(path[path.length - 1]).balanceOf(to).sub(balanceBefore) >= amountOutMin,
735             'HopRouter: INSUFFICIENT_OUTPUT_AMOUNT'
736         );
737     }
738     function swapExactETHForTokensSupportingFeeOnTransferTokens(
739         uint amountOutMin,
740         address[] calldata path,
741         address to,
742         uint deadline
743     )
744         external
745         virtual
746         override
747         payable
748         ensure(deadline)
749     {
750         require(path[0] == WETH, 'HopRouter: INVALID_PATH');
751         uint amountIn = msg.value;
752         IWETH(WETH).deposit{value: amountIn}();
753         assert(IWETH(WETH).transfer(HopLibrary.pairFor(factory, path[0], path[1]), amountIn));
754         uint balanceBefore = IERC20(path[path.length - 1]).balanceOf(to);
755         _swapSupportingFeeOnTransferTokens(path, to);
756         require(
757             IERC20(path[path.length - 1]).balanceOf(to).sub(balanceBefore) >= amountOutMin,
758             'HopRouter: INSUFFICIENT_OUTPUT_AMOUNT'
759         );
760     }
761     function swapExactTokensForETHSupportingFeeOnTransferTokens(
762         uint amountIn,
763         uint amountOutMin,
764         address[] calldata path,
765         address to,
766         uint deadline
767     )
768         external
769         virtual
770         override
771         ensure(deadline)
772     {
773         require(path[path.length - 1] == WETH, 'HopRouter: INVALID_PATH');
774         TransferHelper.safeTransferFrom(
775             path[0], msg.sender, HopLibrary.pairFor(factory, path[0], path[1]), amountIn
776         );
777         _swapSupportingFeeOnTransferTokens(path, address(this));
778         uint amountOut = IERC20(WETH).balanceOf(address(this));
779         require(amountOut >= amountOutMin, 'HopRouter: INSUFFICIENT_OUTPUT_AMOUNT');
780         IWETH(WETH).withdraw(amountOut);
781         TransferHelper.safeTransferETH(to, amountOut);
782     }
783 
784     // **** LIBRARY FUNCTIONS ****
785     function quote(uint amountA, uint reserveA, uint reserveB) public pure virtual override returns (uint amountB) {
786         return HopLibrary.quote(amountA, reserveA, reserveB);
787     }
788 
789     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut)
790         public
791         pure
792         virtual
793         override
794         returns (uint amountOut)
795     {
796         return HopLibrary.getAmountOut(amountIn, reserveIn, reserveOut);
797     }
798 
799     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut)
800         public
801         pure
802         virtual
803         override
804         returns (uint amountIn)
805     {
806         return HopLibrary.getAmountIn(amountOut, reserveIn, reserveOut);
807     }
808 
809     function getAmountsOut(uint amountIn, address[] memory path)
810         public
811         view
812         virtual
813         override
814         returns (uint[] memory amounts)
815     {
816         return HopLibrary.getAmountsOut(factory, amountIn, path);
817     }
818 
819     function getAmountsIn(uint amountOut, address[] memory path)
820         public
821         view
822         virtual
823         override
824         returns (uint[] memory amounts)
825     {
826         return HopLibrary.getAmountsIn(factory, amountOut, path);
827     }
828 }