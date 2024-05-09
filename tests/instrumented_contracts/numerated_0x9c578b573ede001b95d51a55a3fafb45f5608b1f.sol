1 // File: contracts\sakeswap\interfaces\ISakeSwapFactory.sol
2 
3 // SPDX-License-Identifier: GPL-3.0
4 pragma solidity >=0.5.0;
5 
6 interface ISakeSwapFactory {
7     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
8 
9     function feeTo() external view returns (address);
10     function feeToSetter() external view returns (address);
11     function migrator() external view returns (address);
12 
13     function getPair(address tokenA, address tokenB) external view returns (address pair);
14     function allPairs(uint) external view returns (address pair);
15     function allPairsLength() external view returns (uint);
16 
17     function createPair(address tokenA, address tokenB) external returns (address pair);
18 
19     function setFeeTo(address) external;
20     function setFeeToSetter(address) external;
21     function setMigrator(address) external;
22 }
23 
24 // File: contracts\sakeswap\libraries\TransferHelper.sol
25 
26 
27 pragma solidity >=0.6.0;
28 
29 // helper methods for interacting with ERC20 tokens and sending ETH that do not consistently return true/false
30 library TransferHelper {
31     function safeApprove(address token, address to, uint value) internal {
32         // bytes4(keccak256(bytes('approve(address,uint256)')));
33         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x095ea7b3, to, value));
34         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: APPROVE_FAILED');
35     }
36 
37     function safeTransfer(address token, address to, uint value) internal {
38         // bytes4(keccak256(bytes('transfer(address,uint256)')));
39         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));
40         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FAILED');
41     }
42 
43     function safeTransferFrom(address token, address from, address to, uint value) internal {
44         // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
45         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));
46         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FROM_FAILED');
47     }
48 
49     function safeTransferETH(address to, uint value) internal {
50         (bool success,) = to.call{value:value}(new bytes(0));
51         require(success, 'TransferHelper: ETH_TRANSFER_FAILED');
52     }
53 }
54 
55 // File: contracts\sakeswap\interfaces\ISakeSwapRouter.sol
56 
57 pragma solidity >=0.6.2;
58 
59 interface ISakeSwapRouter {
60     function factory() external pure returns (address);
61 
62     function WETH() external pure returns (address);
63 
64     function addLiquidity(
65         address tokenA,
66         address tokenB,
67         uint256 amountADesired,
68         uint256 amountBDesired,
69         uint256 amountAMin,
70         uint256 amountBMin,
71         address to,
72         uint256 deadline
73     )
74         external
75         returns (
76             uint256 amountA,
77             uint256 amountB,
78             uint256 liquidity
79         );
80 
81     function addLiquidityETH(
82         address token,
83         uint256 amountTokenDesired,
84         uint256 amountTokenMin,
85         uint256 amountETHMin,
86         address to,
87         uint256 deadline
88     )
89         external
90         payable
91         returns (
92             uint256 amountToken,
93             uint256 amountETH,
94             uint256 liquidity
95         );
96 
97     function removeLiquidity(
98         address tokenA,
99         address tokenB,
100         uint256 liquidity,
101         uint256 amountAMin,
102         uint256 amountBMin,
103         address to,
104         uint256 deadline
105     )
106         external
107         returns (
108             uint256 amountA,
109             uint256 amountB
110         );
111 
112     function removeLiquidityETH(
113         address token,
114         uint256 liquidity,
115         uint256 amountTokenMin,
116         uint256 amountETHMin,
117         address to,
118         uint256 deadline
119     )
120         external
121         returns (
122             uint256 amountToken,
123             uint256 amountETH
124         );
125 
126     function removeLiquidityWithPermit(
127         address tokenA,
128         address tokenB,
129         uint256 liquidity,
130         uint256 amountAMin,
131         uint256 amountBMin,
132         address to,
133         uint256 deadline,
134         bool approveMax,
135         uint8 v,
136         bytes32 r,
137         bytes32 s
138     )
139         external
140         returns (
141             uint256 amountA,
142             uint256 amountB
143         );
144 
145     function removeLiquidityETHWithPermit(
146         address token,
147         uint256 liquidity,
148         uint256 amountTokenMin,
149         uint256 amountETHMin,
150         address to,
151         uint256 deadline,
152         bool approveMax,
153         uint8 v,
154         bytes32 r,
155         bytes32 s
156     )
157         external
158         returns (
159             uint256 amountToken,
160             uint256 amountETH
161         );
162 
163     function swapExactTokensForTokens(
164         uint256 amountIn,
165         uint256 amountOutMin,
166         address[] calldata path,
167         address to,
168         uint256 deadline,
169         bool ifmint
170     ) external returns (uint256[] memory amounts);
171 
172     function swapTokensForExactTokens(
173         uint256 amountOut,
174         uint256 amountInMax,
175         address[] calldata path,
176         address to,
177         uint256 deadline,
178         bool ifmint
179     ) external returns (uint256[] memory amounts);
180 
181     function swapExactETHForTokens(
182         uint256 amountOutMin,
183         address[] calldata path,
184         address to,
185         uint256 deadline,
186         bool ifmint
187     ) external payable returns (uint256[] memory amounts);
188 
189     function swapTokensForExactETH(
190         uint256 amountOut,
191         uint256 amountInMax,
192         address[] calldata path,
193         address to,
194         uint256 deadline,
195         bool ifmint
196     ) external returns (uint256[] memory amounts);
197 
198     function swapExactTokensForETH(
199         uint256 amountIn,
200         uint256 amountOutMin,
201         address[] calldata path,
202         address to,
203         uint256 deadline,
204         bool ifmint
205     ) external returns (uint256[] memory amounts);
206 
207     function swapETHForExactTokens(
208         uint256 amountOut,
209         address[] calldata path,
210         address to,
211         uint256 deadline,
212         bool ifmint
213     ) external payable returns (uint256[] memory amounts);
214 
215     function quote(
216         uint256 amountA,
217         uint256 reserveA,
218         uint256 reserveB
219     ) external pure returns (uint256 amountB);
220 
221     function getAmountOut(
222         uint256 amountIn,
223         uint256 reserveIn,
224         uint256 reserveOut
225     ) external pure returns (uint256 amountOut);
226 
227     function getAmountIn(
228         uint256 amountOut,
229         uint256 reserveIn,
230         uint256 reserveOut
231     ) external pure returns (uint256 amountIn);
232 
233     function getAmountsOut(uint256 amountIn, address[] calldata path) external view returns (uint256[] memory amounts);
234 
235     function getAmountsIn(uint256 amountOut, address[] calldata path) external view returns (uint256[] memory amounts);
236 
237     function removeLiquidityETHSupportingFeeOnTransferTokens(
238         address token,
239         uint256 liquidity,
240         uint256 amountTokenMin,
241         uint256 amountETHMin,
242         address to,
243         uint256 deadline
244     ) external returns (uint256 amountETH);
245 
246     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
247         address token,
248         uint256 liquidity,
249         uint256 amountTokenMin,
250         uint256 amountETHMin,
251         address to,
252         uint256 deadline,
253         bool approveMax,
254         uint8 v,
255         bytes32 r,
256         bytes32 s
257     ) external returns (uint256 amountETH);
258 
259     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
260         uint256 amountIn,
261         uint256 amountOutMin,
262         address[] calldata path,
263         address to,
264         uint256 deadline,
265         bool ifmint
266     ) external;
267 
268     function swapExactETHForTokensSupportingFeeOnTransferTokens(
269         uint256 amountOutMin,
270         address[] calldata path,
271         address to,
272         uint256 deadline,
273         bool ifmint
274     ) external payable;
275 
276     function swapExactTokensForETHSupportingFeeOnTransferTokens(
277         uint256 amountIn,
278         uint256 amountOutMin,
279         address[] calldata path,
280         address to,
281         uint256 deadline,
282         bool ifmint
283     ) external;
284 }
285 
286 // File: contracts\sakeswap\interfaces\ISakeSwapPair.sol
287 
288 pragma solidity >=0.5.0;
289 
290 interface ISakeSwapPair {
291     event Approval(address indexed owner, address indexed spender, uint value);
292     event Transfer(address indexed from, address indexed to, uint value);
293 
294     function name() external pure returns (string memory);
295     function symbol() external pure returns (string memory);
296     function decimals() external pure returns (uint8);
297     function totalSupply() external view returns (uint);
298     function balanceOf(address owner) external view returns (uint);
299     function allowance(address owner, address spender) external view returns (uint);
300 
301     function approve(address spender, uint value) external returns (bool);
302     function transfer(address to, uint value) external returns (bool);
303     function transferFrom(address from, address to, uint value) external returns (bool);
304 
305     function DOMAIN_SEPARATOR() external view returns (bytes32);
306     function PERMIT_TYPEHASH() external pure returns (bytes32);
307     function nonces(address owner) external view returns (uint);
308 
309     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
310 
311     event Mint(address indexed sender, uint amount0, uint amount1);
312     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
313     event Swap(
314         address indexed sender,
315         uint amount0In,
316         uint amount1In,
317         uint amount0Out,
318         uint amount1Out,
319         address indexed to
320     );
321     event Sync(uint112 reserve0, uint112 reserve1);
322 
323     function MINIMUM_LIQUIDITY() external pure returns (uint);
324     function factory() external view returns (address);
325     function token0() external view returns (address);
326     function token1() external view returns (address);
327     function stoken() external view returns (address);
328     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
329     function price0CumulativeLast() external view returns (uint);
330     function price1CumulativeLast() external view returns (uint);
331     function kLast() external view returns (uint);
332 
333     function mint(address to) external returns (uint liquidity);
334     function burn(address to) external returns (uint amount0, uint amount1);
335     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
336     function skim(address to) external;
337     function sync() external;
338 
339     function initialize(address, address) external;
340     function dealSlippageWithIn(address[] calldata path, uint amountIn, address to, bool ifmint) external returns (uint amountOut);
341     function dealSlippageWithOut(address[] calldata path, uint amountOut, address to, bool ifmint) external returns (uint extra);
342     function getAmountOutMarket(address token, uint amountIn) external view returns (uint _out, uint t0Price);
343     function getAmountInMarket(address token, uint amountOut) external view returns (uint _in, uint t0Price);
344     function getAmountOutFinal(address token, uint256 amountIn) external view returns (uint256 amountOut, uint256 stokenAmount);
345     function getAmountInFinal(address token, uint256 amountOut) external view returns (uint256 amountIn, uint256 stokenAmount);
346     function getTokenMarketPrice(address token) external view returns (uint price);
347 }
348 
349 // File: contracts\sakeswap\libraries\SafeMath.sol
350 
351 pragma solidity =0.6.12;
352 
353 // a library for performing overflow-safe math, courtesy of DappHub (https://github.com/dapphub/ds-math)
354 
355 library SafeMath {
356     function add(uint x, uint y) internal pure returns (uint z) {
357         require((z = x + y) >= x, 'ds-math-add-overflow');
358     }
359 
360     function sub(uint x, uint y) internal pure returns (uint z) {
361         require((z = x - y) <= x, 'ds-math-sub-underflow');
362     }
363 
364     function mul(uint x, uint y) internal pure returns (uint z) {
365         require(y == 0 || (z = x * y) / y == x, 'ds-math-mul-overflow');
366     }
367 }
368 
369 // File: contracts\sakeswap\libraries\SakeSwapLibrary.sol
370 
371 pragma solidity >=0.5.0;
372 
373 
374 
375 library SakeSwapLibrary {
376     using SafeMath for uint256;
377 
378     // returns sorted token addresses, used to handle return values from pairs sorted in this order
379     function sortTokens(address tokenA, address tokenB) internal pure returns (address token0, address token1) {
380         require(tokenA != tokenB, 'SakeSwapLibrary: IDENTICAL_ADDRESSES');
381         (token0, token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
382         require(token0 != address(0), 'SakeSwapLibrary: ZERO_ADDRESS');
383     }
384 
385     // calculates the CREATE2 address for a pair without making any external calls
386     function pairFor(
387         address factory,
388         address tokenA,
389         address tokenB
390     ) internal pure returns (address pair) {
391         (address token0, address token1) = sortTokens(tokenA, tokenB);
392         pair = address(
393             uint256(
394                 keccak256(
395                     abi.encodePacked(
396                         hex'ff',
397                         factory,
398                         keccak256(abi.encodePacked(token0, token1)),
399                         hex'b2b53dca60cae1d1f93f64d80703b888689f28b63c483459183f2f4271fa0308' // init code hash
400                     )
401                 )
402             )
403         );
404     }
405 
406     // fetches and sorts the reserves for a pair
407     function getReserves(
408         address factory,
409         address tokenA,
410         address tokenB
411     ) internal view returns (uint256 reserveA, uint256 reserveB) {
412         (address token0, ) = sortTokens(tokenA, tokenB);
413         (uint256 reserve0, uint256 reserve1, ) = ISakeSwapPair(pairFor(factory, tokenA, tokenB)).getReserves();
414         (reserveA, reserveB) = tokenA == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
415     }
416 
417     // given some amount of an asset and pair reserves, returns an equivalent amount of the other asset
418     function quote(
419         uint256 amountA,
420         uint256 reserveA,
421         uint256 reserveB
422     ) internal pure returns (uint256 amountB) {
423         require(amountA > 0, 'SakeSwapLibrary: INSUFFICIENT_AMOUNT');
424         require(reserveA > 0 && reserveB > 0, 'SakeSwapLibrary: INSUFFICIENT_LIQUIDITY');
425         amountB = amountA.mul(reserveB) / reserveA;
426     }
427 
428     // given an input amount of an asset and pair reserves, returns the maximum output amount of the other asset
429     function getAmountOut(
430         uint256 amountIn,
431         uint256 reserveIn,
432         uint256 reserveOut
433     ) internal pure returns (uint256 amountOut) {
434         require(amountIn > 0, 'SakeSwapLibrary: INSUFFICIENT_INPUT_AMOUNT');
435         require(reserveIn > 0 && reserveOut > 0, 'SakeSwapLibrary: INSUFFICIENT_LIQUIDITY');
436         uint256 amountInWithFee = amountIn.mul(997);
437         uint256 numerator = amountInWithFee.mul(reserveOut);
438         uint256 denominator = reserveIn.mul(1000).add(amountInWithFee);
439         amountOut = numerator / denominator;
440     }
441 
442     // given an output amount of an asset and pair reserves, returns a required input amount of the other asset
443     function getAmountIn(
444         uint256 amountOut,
445         uint256 reserveIn,
446         uint256 reserveOut
447     ) internal pure returns (uint256 amountIn) {
448         require(amountOut > 0, 'SakeSwapLibrary: INSUFFICIENT_OUTPUT_AMOUNT');
449         require(reserveIn > 0 && reserveOut > 0, 'SakeSwapLibrary: INSUFFICIENT_LIQUIDITY');
450         uint256 numerator = reserveIn.mul(amountOut).mul(1000);
451         uint256 denominator = reserveOut.sub(amountOut).mul(997);
452         amountIn = (numerator / denominator).add(1);
453     }
454 
455     // performs chained getAmountOut calculations on any number of pairs
456     function getAmountsOut(
457         address factory,
458         uint256 amountIn,
459         address[] memory path
460     ) internal view returns (uint256[] memory amounts) {
461         require(path.length >= 2, 'SakeSwapLibrary: INVALID_PATH');
462         amounts = new uint256[](path.length);
463         amounts[0] = amountIn;
464         for (uint256 i; i < path.length - 1; i++) {
465             (uint256 reserveIn, uint256 reserveOut) = getReserves(factory, path[i], path[i + 1]);
466             amounts[i + 1] = getAmountOut(amounts[i], reserveIn, reserveOut);
467         }
468     }
469 
470     // performs chained getAmountIn calculations on any number of pairs
471     function getAmountsIn(
472         address factory,
473         uint256 amountOut,
474         address[] memory path
475     ) internal view returns (uint256[] memory amounts) {
476         require(path.length >= 2, 'SakeSwapLibrary: INVALID_PATH');
477         amounts = new uint256[](path.length);
478         amounts[amounts.length - 1] = amountOut;
479         for (uint256 i = path.length - 1; i > 0; i--) {
480             (uint256 reserveIn, uint256 reserveOut) = getReserves(factory, path[i - 1], path[i]);
481             amounts[i - 1] = getAmountIn(amounts[i], reserveIn, reserveOut);
482         }
483     }
484 }
485 
486 // File: contracts\sakeswap\interfaces\IERC20.sol
487 
488 pragma solidity >=0.5.0;
489 
490 interface IERC20 {
491     event Approval(address indexed owner, address indexed spender, uint value);
492     event Transfer(address indexed from, address indexed to, uint value);
493 
494     function name() external view returns (string memory);
495     function symbol() external view returns (string memory);
496     function decimals() external view returns (uint8);
497     function totalSupply() external view returns (uint);
498     function balanceOf(address owner) external view returns (uint);
499     function allowance(address owner, address spender) external view returns (uint);
500 
501     function approve(address spender, uint value) external returns (bool);
502     function transfer(address to, uint value) external returns (bool);
503     function transferFrom(address from, address to, uint value) external returns (bool);
504     function mint(address to, uint value) external returns (bool);
505     function burn(address from, uint value) external returns (bool);
506 }
507 
508 // File: contracts\sakeswap\interfaces\IWETH.sol
509 
510 pragma solidity >=0.5.0;
511 
512 interface IWETH {
513     function deposit() external payable;
514     function transfer(address to, uint value) external returns (bool);
515     function withdraw(uint) external;
516 }
517 
518 // File: contracts\sakeswap\SakeSwapRouter.sol
519 
520 pragma solidity =0.6.12;
521 
522 
523 
524 
525 
526 
527 
528 
529 contract SakeSwapRouter is ISakeSwapRouter {
530     using SafeMath for uint256;
531 
532     address public immutable override factory;
533     address public immutable override WETH;
534 
535     modifier ensure(uint256 deadline) {
536         require(deadline >= block.timestamp, "SakeSwapRouter: EXPIRED");
537         _;
538     }
539 
540     constructor(address _factory, address _WETH) public {
541         factory = _factory;
542         WETH = _WETH;
543     }
544 
545     receive() external payable {
546         assert(msg.sender == WETH); // only accept ETH via fallback from the WETH contract
547     }
548 
549     // **** ADD LIQUIDITY ****
550     function _addLiquidity(
551         address tokenA,
552         address tokenB,
553         uint256 amountADesired,
554         uint256 amountBDesired,
555         uint256 amountAMin,
556         uint256 amountBMin
557     ) internal virtual returns (uint256 amountA, uint256 amountB) {
558         // create the pair if it doesn"t exist yet
559         if (ISakeSwapFactory(factory).getPair(tokenA, tokenB) == address(0)) {
560             ISakeSwapFactory(factory).createPair(tokenA, tokenB);
561         }
562         (uint256 reserveA, uint256 reserveB) = SakeSwapLibrary.getReserves(factory, tokenA, tokenB);
563         if (reserveA == 0 && reserveB == 0) {
564             (amountA, amountB) = (amountADesired, amountBDesired);
565         } else {
566             uint256 amountBOptimal = SakeSwapLibrary.quote(amountADesired, reserveA, reserveB);
567             if (amountBOptimal <= amountBDesired) {
568                 require(amountBOptimal >= amountBMin, "SakeSwapRouter: INSUFFICIENT_B_AMOUNT");
569                 (amountA, amountB) = (amountADesired, amountBOptimal);
570             } else {
571                 uint256 amountAOptimal = SakeSwapLibrary.quote(amountBDesired, reserveB, reserveA);
572                 assert(amountAOptimal <= amountADesired);
573                 require(amountAOptimal >= amountAMin, "SakeSwapRouter: INSUFFICIENT_A_AMOUNT");
574                 (amountA, amountB) = (amountAOptimal, amountBDesired);
575             }
576         }
577     }
578 
579     function addLiquidity(
580         address tokenA,
581         address tokenB,
582         uint256 amountADesired,
583         uint256 amountBDesired,
584         uint256 amountAMin,
585         uint256 amountBMin,
586         address to,
587         uint256 deadline
588     )
589         external
590         virtual
591         override
592         ensure(deadline)
593         returns (
594             uint256 amountA,
595             uint256 amountB,
596             uint256 liquidity
597         )
598     {
599         (amountA, amountB) = _addLiquidity(tokenA, tokenB, amountADesired, amountBDesired, amountAMin, amountBMin);
600         address pair = SakeSwapLibrary.pairFor(factory, tokenA, tokenB);
601         TransferHelper.safeTransferFrom(tokenA, msg.sender, pair, amountA);
602         TransferHelper.safeTransferFrom(tokenB, msg.sender, pair, amountB);
603         liquidity = ISakeSwapPair(pair).mint(to);
604     }
605 
606     function addLiquidityETH(
607         address token,
608         uint256 amountTokenDesired,
609         uint256 amountTokenMin,
610         uint256 amountETHMin,
611         address to,
612         uint256 deadline
613     )
614         external
615         virtual
616         override
617         payable
618         ensure(deadline)
619         returns (
620             uint256 amountToken,
621             uint256 amountETH,
622             uint256 liquidity
623         )
624     {
625         (amountToken, amountETH) = _addLiquidity(
626             token,
627             WETH,
628             amountTokenDesired,
629             msg.value,
630             amountTokenMin,
631             amountETHMin
632         );
633         address pair = SakeSwapLibrary.pairFor(factory, token, WETH);
634         TransferHelper.safeTransferFrom(token, msg.sender, pair, amountToken);
635         IWETH(WETH).deposit{value: amountETH}();
636         assert(IWETH(WETH).transfer(pair, amountETH));
637         liquidity = ISakeSwapPair(pair).mint(to);
638         // refund dust eth, if any
639         if (msg.value > amountETH) TransferHelper.safeTransferETH(msg.sender, msg.value - amountETH);
640     }
641 
642     // **** REMOVE LIQUIDITY ****
643     function removeLiquidity(
644         address tokenA,
645         address tokenB,
646         uint256 liquidity,
647         uint256 amountAMin,
648         uint256 amountBMin,
649         address to,
650         uint256 deadline
651     )
652         public
653         virtual
654         override
655         ensure(deadline)
656         returns (
657             uint256 amountA,
658             uint256 amountB
659         )
660     {
661         address pair = SakeSwapLibrary.pairFor(factory, tokenA, tokenB);
662         ISakeSwapPair(pair).transferFrom(msg.sender, pair, liquidity); // send liquidity to pair
663         (address token0, ) = SakeSwapLibrary.sortTokens(tokenA, tokenB);
664         if (tokenA == token0) {
665             (amountA, amountB) = ISakeSwapPair(pair).burn(to);
666         } else {
667             (amountB, amountA) = ISakeSwapPair(pair).burn(to);
668         }
669         require(amountA >= amountAMin, "SakeSwappRouter: INSUFFICIENT_A_AMOUNT");
670         require(amountB >= amountBMin, "SakeSwapRouter: INSUFFICIENT_B_AMOUNT");
671     }
672 
673     function removeLiquidityETH(
674         address token,
675         uint256 liquidity,
676         uint256 amountTokenMin,
677         uint256 amountETHMin,
678         address to,
679         uint256 deadline
680     )
681         public
682         virtual
683         override
684         ensure(deadline)
685         returns (
686             uint256 amountToken,
687             uint256 amountETH
688         )
689     {
690         (amountToken, amountETH) = removeLiquidity(
691             token,
692             WETH,
693             liquidity,
694             amountTokenMin,
695             amountETHMin,
696             address(this),
697             deadline
698         );
699         TransferHelper.safeTransfer(token, to, amountToken);
700         IWETH(WETH).withdraw(amountETH);
701         TransferHelper.safeTransferETH(to, amountETH);
702     }
703 
704     function removeLiquidityWithPermit(
705         address tokenA,
706         address tokenB,
707         uint256 liquidity,
708         uint256 amountAMin,
709         uint256 amountBMin,
710         address to,
711         uint256 deadline,
712         bool approveMax,
713         uint8 v,
714         bytes32 r,
715         bytes32 s
716     )
717         external
718         virtual
719         override
720         returns (
721             uint256 amountA,
722             uint256 amountB
723         )
724     {
725         ISakeSwapPair(SakeSwapLibrary.pairFor(factory, tokenA, tokenB)).permit(
726             msg.sender,
727             address(this),
728             approveMax ? uint256(-1) : liquidity,
729             deadline,
730             v,
731             r,
732             s
733         );
734         (amountA, amountB) = removeLiquidity(
735             tokenA,
736             tokenB,
737             liquidity,
738             amountAMin,
739             amountBMin,
740             to,
741             deadline
742         );
743     }
744 
745     function removeLiquidityETHWithPermit(
746         address token,
747         uint256 liquidity,
748         uint256 amountTokenMin,
749         uint256 amountETHMin,
750         address to,
751         uint256 deadline,
752         bool approveMax,
753         uint8 v,
754         bytes32 r,
755         bytes32 s
756     )
757         external
758         virtual
759         override
760         returns (
761             uint256 amountToken,
762             uint256 amountETH
763         )
764     {
765         address pair = SakeSwapLibrary.pairFor(factory, token, WETH);
766         uint256 value = approveMax ? uint256(-1) : liquidity;
767         ISakeSwapPair(pair).permit(msg.sender, address(this), value, deadline, v, r, s);
768         (amountToken, amountETH) = removeLiquidityETH(
769             token,
770             liquidity,
771             amountTokenMin,
772             amountETHMin,
773             to,
774             deadline
775         );
776     }
777 
778     // **** REMOVE LIQUIDITY (supporting fee-on-transfer tokens) ****
779     function removeLiquidityETHSupportingFeeOnTransferTokens(
780         address token,
781         uint256 liquidity,
782         uint256 amountTokenMin,
783         uint256 amountETHMin,
784         address to,
785         uint256 deadline
786     ) public virtual override ensure(deadline) returns (uint256 amountETH) {
787         (, amountETH) = removeLiquidity(
788             token,
789             WETH,
790             liquidity,
791             amountTokenMin,
792             amountETHMin,
793             address(this),
794             deadline
795         );
796         TransferHelper.safeTransfer(token, to, IERC20(token).balanceOf(address(this)));
797         IWETH(WETH).withdraw(amountETH);
798         TransferHelper.safeTransferETH(to, amountETH);
799     }
800 
801     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
802         address token,
803         uint256 liquidity,
804         uint256 amountTokenMin,
805         uint256 amountETHMin,
806         address to,
807         uint256 deadline,
808         bool approveMax,
809         uint8 v,
810         bytes32 r,
811         bytes32 s
812     ) external virtual override returns (uint256 amountETH) {
813         address pair = SakeSwapLibrary.pairFor(factory, token, WETH);
814         uint256 value = approveMax ? uint256(-1) : liquidity;
815         ISakeSwapPair(pair).permit(msg.sender, address(this), value, deadline, v, r, s);
816         (amountETH) = removeLiquidityETHSupportingFeeOnTransferTokens(
817             token,
818             liquidity,
819             amountTokenMin,
820             amountETHMin,
821             to,
822             deadline
823         );
824     }
825 
826     // **** SWAP ****
827     // requires the initial amount to have already been sent to the first pair
828     function _swap(
829         uint256[] memory amounts,
830         address[] memory path,
831         address _to
832     ) internal virtual {
833         for (uint256 i; i < path.length - 1; i++) {
834             (address input, address output) = (path[i], path[i + 1]);
835             (address token0, ) = SakeSwapLibrary.sortTokens(input, output);
836             uint256 amountOut = amounts[i + 1];
837             (uint256 amount0Out, uint256 amount1Out) = input == token0
838                 ? (uint256(0), amountOut)
839                 : (amountOut, uint256(0));
840             address to = i < path.length - 2 ? SakeSwapLibrary.pairFor(factory, output, path[i + 2]) : _to;
841             ISakeSwapPair(SakeSwapLibrary.pairFor(factory, input, output)).swap(
842                 amount0Out,
843                 amount1Out,
844                 to,
845                 new bytes(0)
846             );
847         }
848     }
849 
850     function swapExactTokensForTokens(
851         uint256 amountIn,
852         uint256 amountOutMin,
853         address[] calldata path,
854         address to,
855         uint256 deadline,
856         bool ifmint
857     ) external virtual override ensure(deadline) returns (uint256[] memory amounts) {
858         amounts = SakeSwapLibrary.getAmountsOut(factory, amountIn, path);
859         address pair = SakeSwapLibrary.pairFor(factory, path[0], path[1]);
860         TransferHelper.safeTransferFrom(path[0], msg.sender, pair, amounts[0]);
861         if (path.length == 2) {
862             amounts[1] = ISakeSwapPair(pair).dealSlippageWithIn(path, amounts[0], to, ifmint);
863         }
864         require(amounts[amounts.length - 1] >= amountOutMin, "SakeSwapRouter: INSUFFICIENT_OUTPUT_AMOUNT");
865         _swap(amounts, path, to);
866     }
867 
868     function swapTokensForExactTokens(
869         uint256 amountOut,
870         uint256 amountInMax,
871         address[] calldata path,
872         address to,
873         uint256 deadline,
874         bool ifmint
875     ) external virtual override ensure(deadline) returns (uint256[] memory amounts) {
876         amounts = SakeSwapLibrary.getAmountsIn(factory, amountOut, path);
877         address pair = SakeSwapLibrary.pairFor(factory, path[0], path[1]);
878         if (path.length == 2) {
879             uint256 extra = ISakeSwapPair(pair).dealSlippageWithOut(path, amountOut, to, ifmint);
880             amounts[0] = amounts[0].add(extra);
881         }
882         require(amounts[0] <= amountInMax, "SakeSwapRouter: EXCESSIVE_INPUT_AMOUNT");
883         TransferHelper.safeTransferFrom(path[0], msg.sender, pair, amounts[0]);
884         _swap(amounts, path, to);
885     }
886 
887     function swapExactETHForTokens(
888         uint256 amountOutMin,
889         address[] calldata path,
890         address to,
891         uint256 deadline,
892         bool ifmint
893     ) external virtual override payable ensure(deadline) returns (uint256[] memory amounts) {
894         require(path[0] == WETH, "SakeSwapRouter: INVALID_PATH");
895         amounts = SakeSwapLibrary.getAmountsOut(factory, msg.value, path);
896         address pair = SakeSwapLibrary.pairFor(factory, path[0], path[1]);
897         IWETH(WETH).deposit{value: amounts[0]}();
898         assert(IWETH(WETH).transfer(pair, amounts[0]));
899         if (path.length == 2) {
900             amounts[1] = ISakeSwapPair(pair).dealSlippageWithIn(path, amounts[0], to, ifmint);
901         }
902         require(amounts[amounts.length - 1] >= amountOutMin, "SakeSwapRouter: INSUFFICIENT_OUTPUT_AMOUNT");
903         _swap(amounts, path, to);
904     }
905 
906     function swapTokensForExactETH(
907         uint256 amountOut,
908         uint256 amountInMax,
909         address[] calldata path,
910         address to,
911         uint256 deadline,
912         bool ifmint
913     ) external virtual override ensure(deadline) returns (uint256[] memory amounts) {
914         require(path[path.length - 1] == WETH, "SakeSwapRouter: INVALID_PATH");
915         amounts = SakeSwapLibrary.getAmountsIn(factory, amountOut, path);
916         address pair = SakeSwapLibrary.pairFor(factory, path[0], path[1]);
917         if (path.length == 2) {
918             uint256 extra = ISakeSwapPair(pair).dealSlippageWithOut(path, amountOut, to, ifmint);
919             amounts[0] = amounts[0].add(extra);
920         }
921         require(amounts[0] <= amountInMax, "SakeSwapRouter: EXCESSIVE_INPUT_AMOUNT");
922         TransferHelper.safeTransferFrom(path[0], msg.sender, pair, amounts[0]);
923         _swap(amounts, path, address(this));
924         IWETH(WETH).withdraw(amounts[amounts.length - 1]);
925         TransferHelper.safeTransferETH(to, amounts[amounts.length - 1]);
926     }
927 
928     function swapExactTokensForETH(
929         uint256 amountIn,
930         uint256 amountOutMin,
931         address[] calldata path,
932         address to,
933         uint256 deadline,
934         bool ifmint
935     ) external virtual override ensure(deadline) returns (uint256[] memory amounts) {
936         require(path[path.length - 1] == WETH, "SakeSwapRouter: INVALID_PATH");
937         amounts = SakeSwapLibrary.getAmountsOut(factory, amountIn, path);
938         address pair = SakeSwapLibrary.pairFor(factory, path[0], path[1]);
939         TransferHelper.safeTransferFrom(path[0], msg.sender, pair, amounts[0]);
940         if (path.length == 2) {
941             amounts[1] = ISakeSwapPair(pair).dealSlippageWithIn(path, amounts[0], to, ifmint);
942         }
943         require(amounts[amounts.length - 1] >= amountOutMin, "SakeSwapRouter: INSUFFICIENT_OUTPUT_AMOUNT");
944         _swap(amounts, path, address(this));
945         IWETH(WETH).withdraw(amounts[amounts.length - 1]);
946         TransferHelper.safeTransferETH(to, amounts[amounts.length - 1]);
947     }
948 
949     function swapETHForExactTokens(
950         uint256 amountOut,
951         address[] calldata path,
952         address to,
953         uint256 deadline,
954         bool ifmint
955     ) external virtual override payable ensure(deadline) returns (uint256[] memory amounts) {
956         require(path[0] == WETH, "SakeSwapRouter: INVALID_PATH");
957         amounts = SakeSwapLibrary.getAmountsIn(factory, amountOut, path);
958         address pair = SakeSwapLibrary.pairFor(factory, path[0], path[1]);
959         if (path.length == 2) {
960             uint256 extra = ISakeSwapPair(pair).dealSlippageWithOut(path, amountOut, to, ifmint);
961             amounts[0] = amounts[0].add(extra);
962         }
963         IWETH(WETH).deposit{value: amounts[0]}();
964         assert(IWETH(WETH).transfer(pair, amounts[0]));
965         _swap(amounts, path, to);
966         // refund dust eth, if any
967         if (msg.value > amounts[0]) TransferHelper.safeTransferETH(msg.sender, msg.value - amounts[0]);
968     }
969 
970     // **** SWAP (supporting fee-on-transfer tokens) ****
971     // requires the initial amount to have already been sent to the first pair
972     function _swapSupportingFeeOnTransferTokens(
973         address[] memory path,
974         address _to,
975         bool ifmint
976     ) internal virtual {
977         for (uint256 i; i < path.length - 1; i++) {
978             (address token0, ) = SakeSwapLibrary.sortTokens(path[i], path[i + 1]);
979             ISakeSwapPair pair = ISakeSwapPair(SakeSwapLibrary.pairFor(factory, path[i], path[i + 1]));
980             uint256 amountOutput;
981             {
982                 // scope to avoid stack too deep errors
983                 (uint256 reserve0, uint256 reserve1, ) = pair.getReserves();
984                 (uint256 reserveInput, uint256 reserveOutput) = path[i] == token0
985                     ? (reserve0, reserve1)
986                     : (reserve1, reserve0);
987                 uint256 amountInput = IERC20(path[i]).balanceOf(address(pair)).sub(reserveInput);
988                 if (path.length == 2) {
989                     amountOutput = pair.dealSlippageWithIn(path, amountInput, _to, ifmint);
990                 } else {
991                     amountOutput = SakeSwapLibrary.getAmountOut(amountInput, reserveInput, reserveOutput);
992                 }
993             }
994             (uint256 amount0Out, uint256 amount1Out) = path[i] == token0
995                 ? (uint256(0), amountOutput)
996                 : (amountOutput, uint256(0));
997             address to = i < path.length - 2 ? SakeSwapLibrary.pairFor(factory, path[i + 1], path[i + 2]) : _to;
998             pair.swap(amount0Out, amount1Out, to, new bytes(0));
999         }
1000     }
1001 
1002     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
1003         uint256 amountIn,
1004         uint256 amountOutMin,
1005         address[] calldata path,
1006         address to,
1007         uint256 deadline,
1008         bool ifmint
1009     ) external virtual override ensure(deadline) {
1010         TransferHelper.safeTransferFrom(
1011             path[0],
1012             msg.sender,
1013             SakeSwapLibrary.pairFor(factory, path[0], path[1]),
1014             amountIn
1015         );
1016         uint256 balanceBefore = IERC20(path[path.length - 1]).balanceOf(to);
1017         _swapSupportingFeeOnTransferTokens(path, to, ifmint);
1018         require(
1019             IERC20(path[path.length - 1]).balanceOf(to).sub(balanceBefore) >= amountOutMin,
1020             "SakeSwapRouter: INSUFFICIENT_OUTPUT_AMOUNT"
1021         );
1022     }
1023 
1024     function swapExactETHForTokensSupportingFeeOnTransferTokens(
1025         uint256 amountOutMin,
1026         address[] calldata path,
1027         address to,
1028         uint256 deadline,
1029         bool ifmint
1030     ) external virtual override payable ensure(deadline) {
1031         require(path[0] == WETH, "SakeSwapRouter: INVALID_PATH");
1032         uint256 amountIn = msg.value;
1033         IWETH(WETH).deposit{value: amountIn}();
1034         assert(IWETH(WETH).transfer(SakeSwapLibrary.pairFor(factory, path[0], path[1]), amountIn));
1035         uint256 balanceBefore = IERC20(path[path.length - 1]).balanceOf(to);
1036         _swapSupportingFeeOnTransferTokens(path, to, ifmint);
1037         require(
1038             IERC20(path[path.length - 1]).balanceOf(to).sub(balanceBefore) >= amountOutMin,
1039             "SakeSwapRouter: INSUFFICIENT_OUTPUT_AMOUNT"
1040         );
1041     }
1042 
1043     function swapExactTokensForETHSupportingFeeOnTransferTokens(
1044         uint256 amountIn,
1045         uint256 amountOutMin,
1046         address[] calldata path,
1047         address to,
1048         uint256 deadline,
1049         bool ifmint
1050     ) external virtual override ensure(deadline) {
1051         require(path[path.length - 1] == WETH, "SakeSwapRouter: INVALID_PATH");
1052         TransferHelper.safeTransferFrom(
1053             path[0],
1054             msg.sender,
1055             SakeSwapLibrary.pairFor(factory, path[0], path[1]),
1056             amountIn
1057         );
1058         _swapSupportingFeeOnTransferTokens(path, address(this), ifmint);
1059         uint256 amountOut = IERC20(WETH).balanceOf(address(this));
1060         require(amountOut >= amountOutMin, "SakeSwapRouter: INSUFFICIENT_OUTPUT_AMOUNT");
1061         IWETH(WETH).withdraw(amountOut);
1062         TransferHelper.safeTransferETH(to, amountOut);
1063     }
1064 
1065     // **** LIBRARY FUNCTIONS ****
1066     function quote(
1067         uint256 amountA,
1068         uint256 reserveA,
1069         uint256 reserveB
1070     ) public virtual override pure returns (uint256 amountB) {
1071         return SakeSwapLibrary.quote(amountA, reserveA, reserveB);
1072     }
1073 
1074     function getAmountOut(
1075         uint256 amountIn,
1076         uint256 reserveIn,
1077         uint256 reserveOut
1078     ) public virtual override pure returns (uint256 amountOut) {
1079         return SakeSwapLibrary.getAmountOut(amountIn, reserveIn, reserveOut);
1080     }
1081 
1082     function getAmountIn(
1083         uint256 amountOut,
1084         uint256 reserveIn,
1085         uint256 reserveOut
1086     ) public virtual override pure returns (uint256 amountIn) {
1087         return SakeSwapLibrary.getAmountIn(amountOut, reserveIn, reserveOut);
1088     }
1089 
1090     function getAmountsOut(uint256 amountIn, address[] memory path)
1091         public
1092         virtual
1093         override
1094         view
1095         returns (uint256[] memory amounts)
1096     {
1097         return SakeSwapLibrary.getAmountsOut(factory, amountIn, path);
1098     }
1099 
1100     function getAmountsIn(uint256 amountOut, address[] memory path)
1101         public
1102         virtual
1103         override
1104         view
1105         returns (uint256[] memory amounts)
1106     {
1107         return SakeSwapLibrary.getAmountsIn(factory, amountOut, path);
1108     }
1109 }