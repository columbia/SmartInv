1 /**
2  *Submitted for verification at Etherscan.io on 2021-02-17
3 */
4 
5 pragma solidity =0.6.6;
6 
7 interface IUniswapV2Factory {
8     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
9 
10     function feeTo() external view returns (address);
11     function feeToSetter() external view returns (address);
12 
13     function getPair(address tokenA, address tokenB) external view returns (address pair);
14     function allPairs(uint) external view returns (address pair);
15     function allPairsLength() external view returns (uint);
16 
17     function createPair(address tokenA, address tokenB) external returns (address pair);
18 
19     function setFeeTo(address) external;
20     function setFeeToSetter(address) external;
21 }
22 
23 interface IUniswapV2Pair {
24     event Approval(address indexed owner, address indexed spender, uint value);
25     event Transfer(address indexed from, address indexed to, uint value);
26 
27     function name() external pure returns (string memory);
28     function symbol() external pure returns (string memory);
29     function decimals() external pure returns (uint8);
30     function totalSupply() external view returns (uint);
31     function balanceOf(address owner) external view returns (uint);
32     function allowance(address owner, address spender) external view returns (uint);
33 
34     function approve(address spender, uint value) external returns (bool);
35     function transfer(address to, uint value) external returns (bool);
36     function transferFrom(address from, address to, uint value) external returns (bool);
37 
38     function DOMAIN_SEPARATOR() external view returns (bytes32);
39     function PERMIT_TYPEHASH() external pure returns (bytes32);
40     function nonces(address owner) external view returns (uint);
41 
42     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
43 
44     event Mint(address indexed sender, uint amount0, uint amount1);
45     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
46     event Swap(
47         address indexed sender,
48         uint amount0In,
49         uint amount1In,
50         uint amount0Out,
51         uint amount1Out,
52         address indexed to
53     );
54     event Sync(uint112 reserve0, uint112 reserve1);
55 
56     function MINIMUM_LIQUIDITY() external pure returns (uint);
57     function factory() external view returns (address);
58     function token0() external view returns (address);
59     function token1() external view returns (address);
60     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
61     function price0CumulativeLast() external view returns (uint);
62     function price1CumulativeLast() external view returns (uint);
63     function kLast() external view returns (uint);
64 
65     function mint(address to) external returns (uint liquidity);
66     function burn(address to) external returns (uint amount0, uint amount1);
67     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
68     function skim(address to) external;
69     function sync() external;
70 
71     function initialize(address, address) external;
72 }
73 
74 interface IUniswapV2Router01 {
75     function factory() external pure returns (address);
76     function WETH() external pure returns (address);
77 
78     function addLiquidity(
79         address tokenA,
80         address tokenB,
81         uint amountADesired,
82         uint amountBDesired,
83         uint amountAMin,
84         uint amountBMin,
85         address to,
86         uint deadline
87     ) external returns (uint amountA, uint amountB, uint liquidity);
88     function addLiquidityETH(
89         address token,
90         uint amountTokenDesired,
91         uint amountTokenMin,
92         uint amountETHMin,
93         address to,
94         uint deadline
95     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
96     function removeLiquidity(
97         address tokenA,
98         address tokenB,
99         uint liquidity,
100         uint amountAMin,
101         uint amountBMin,
102         address to,
103         uint deadline
104     ) external returns (uint amountA, uint amountB);
105     function removeLiquidityETH(
106         address token,
107         uint liquidity,
108         uint amountTokenMin,
109         uint amountETHMin,
110         address to,
111         uint deadline
112     ) external returns (uint amountToken, uint amountETH);
113     function removeLiquidityWithPermit(
114         address tokenA,
115         address tokenB,
116         uint liquidity,
117         uint amountAMin,
118         uint amountBMin,
119         address to,
120         uint deadline,
121         bool approveMax, uint8 v, bytes32 r, bytes32 s
122     ) external returns (uint amountA, uint amountB);
123     function removeLiquidityETHWithPermit(
124         address token,
125         uint liquidity,
126         uint amountTokenMin,
127         uint amountETHMin,
128         address to,
129         uint deadline,
130         bool approveMax, uint8 v, bytes32 r, bytes32 s
131     ) external returns (uint amountToken, uint amountETH);
132     function swapExactTokensForTokens(
133         uint amountIn,
134         uint amountOutMin,
135         address[] calldata path,
136         address to,
137         uint deadline
138     ) external returns (uint[] memory amounts);
139     function swapTokensForExactTokens(
140         uint amountOut,
141         uint amountInMax,
142         address[] calldata path,
143         address to,
144         uint deadline
145     ) external returns (uint[] memory amounts);
146     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
147         external
148         payable
149         returns (uint[] memory amounts);
150     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
151         external
152         returns (uint[] memory amounts);
153     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
154         external
155         returns (uint[] memory amounts);
156     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
157         external
158         payable
159         returns (uint[] memory amounts);
160 
161     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
162     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
163     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
164     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
165     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
166 }
167 
168 interface IUniswapV2Router02 is IUniswapV2Router01 {
169     function removeLiquidityETHSupportingFeeOnTransferTokens(
170         address token,
171         uint liquidity,
172         uint amountTokenMin,
173         uint amountETHMin,
174         address to,
175         uint deadline
176     ) external returns (uint amountETH);
177     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
178         address token,
179         uint liquidity,
180         uint amountTokenMin,
181         uint amountETHMin,
182         address to,
183         uint deadline,
184         bool approveMax, uint8 v, bytes32 r, bytes32 s
185     ) external returns (uint amountETH);
186 
187     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
188         uint amountIn,
189         uint amountOutMin,
190         address[] calldata path,
191         address to,
192         uint deadline
193     ) external;
194     function swapExactETHForTokensSupportingFeeOnTransferTokens(
195         uint amountOutMin,
196         address[] calldata path,
197         address to,
198         uint deadline
199     ) external payable;
200     function swapExactTokensForETHSupportingFeeOnTransferTokens(
201         uint amountIn,
202         uint amountOutMin,
203         address[] calldata path,
204         address to,
205         uint deadline
206     ) external;
207 }
208 
209 interface IERC20 {
210     event Approval(address indexed owner, address indexed spender, uint value);
211     event Transfer(address indexed from, address indexed to, uint value);
212 
213     function name() external view returns (string memory);
214     function symbol() external view returns (string memory);
215     function decimals() external view returns (uint8);
216     function totalSupply() external view returns (uint);
217     function balanceOf(address owner) external view returns (uint);
218     function allowance(address owner, address spender) external view returns (uint);
219 
220     function approve(address spender, uint value) external returns (bool);
221     function transfer(address to, uint value) external returns (bool);
222     function transferFrom(address from, address to, uint value) external returns (bool);
223 }
224 
225 interface IWETH {
226     function deposit() external payable;
227     function transfer(address to, uint value) external returns (bool);
228     function withdraw(uint) external;
229 }
230 
231 contract UniswapV2Router02 is IUniswapV2Router02 {
232     using SafeMath for uint;
233 
234     address public immutable override factory;
235     address public immutable override WETH;
236 
237     modifier ensure(uint deadline) {
238         require(deadline >= block.timestamp, 'UniswapV2Router: EXPIRED');
239         _;
240     }
241 
242     constructor(address _factory, address _WETH) public {
243         factory = _factory;
244         WETH = _WETH;
245     }
246 
247     receive() external payable {
248         assert(msg.sender == WETH); // only accept ETH via fallback from the WETH contract
249     }
250 
251     // **** ADD LIQUIDITY ****
252     function _addLiquidity(
253         address tokenA,
254         address tokenB,
255         uint amountADesired,
256         uint amountBDesired,
257         uint amountAMin,
258         uint amountBMin
259     ) internal virtual returns (uint amountA, uint amountB) {
260         // create the pair if it doesn't exist yet
261         if (IUniswapV2Factory(factory).getPair(tokenA, tokenB) == address(0)) {
262             IUniswapV2Factory(factory).createPair(tokenA, tokenB);
263         }
264         (uint reserveA, uint reserveB) = UniswapV2Library.getReserves(factory, tokenA, tokenB);
265         if (reserveA == 0 && reserveB == 0) {
266             (amountA, amountB) = (amountADesired, amountBDesired);
267         } else {
268             uint amountBOptimal = UniswapV2Library.quote(amountADesired, reserveA, reserveB);
269             if (amountBOptimal <= amountBDesired) {
270                 require(amountBOptimal >= amountBMin, 'UniswapV2Router: INSUFFICIENT_B_AMOUNT');
271                 (amountA, amountB) = (amountADesired, amountBOptimal);
272             } else {
273                 uint amountAOptimal = UniswapV2Library.quote(amountBDesired, reserveB, reserveA);
274                 assert(amountAOptimal <= amountADesired);
275                 require(amountAOptimal >= amountAMin, 'UniswapV2Router: INSUFFICIENT_A_AMOUNT');
276                 (amountA, amountB) = (amountAOptimal, amountBDesired);
277             }
278         }
279     }
280     function addLiquidity(
281         address tokenA,
282         address tokenB,
283         uint amountADesired,
284         uint amountBDesired,
285         uint amountAMin,
286         uint amountBMin,
287         address to,
288         uint deadline
289     ) external virtual override ensure(deadline) returns (uint amountA, uint amountB, uint liquidity) {
290         (amountA, amountB) = _addLiquidity(tokenA, tokenB, amountADesired, amountBDesired, amountAMin, amountBMin);
291         address pair = UniswapV2Library.pairFor(factory, tokenA, tokenB);
292         TransferHelper.safeTransferFrom(tokenA, msg.sender, pair, amountA);
293         TransferHelper.safeTransferFrom(tokenB, msg.sender, pair, amountB);
294         liquidity = IUniswapV2Pair(pair).mint(to);
295     }
296     function addLiquidityETH(
297         address token,
298         uint amountTokenDesired,
299         uint amountTokenMin,
300         uint amountETHMin,
301         address to,
302         uint deadline
303     ) external virtual override payable ensure(deadline) returns (uint amountToken, uint amountETH, uint liquidity) {
304         (amountToken, amountETH) = _addLiquidity(
305             token,
306             WETH,
307             amountTokenDesired,
308             msg.value,
309             amountTokenMin,
310             amountETHMin
311         );
312         address pair = UniswapV2Library.pairFor(factory, token, WETH);
313         TransferHelper.safeTransferFrom(token, msg.sender, pair, amountToken);
314         IWETH(WETH).deposit{value: amountETH}();
315         assert(IWETH(WETH).transfer(pair, amountETH));
316         liquidity = IUniswapV2Pair(pair).mint(to);
317         // refund dust eth, if any
318         if (msg.value > amountETH) TransferHelper.safeTransferETH(msg.sender, msg.value - amountETH);
319     }
320 
321     // **** REMOVE LIQUIDITY ****
322     function removeLiquidity(
323         address tokenA,
324         address tokenB,
325         uint liquidity,
326         uint amountAMin,
327         uint amountBMin,
328         address to,
329         uint deadline
330     ) public virtual override ensure(deadline) returns (uint amountA, uint amountB) {
331         address pair = UniswapV2Library.pairFor(factory, tokenA, tokenB);
332         IUniswapV2Pair(pair).transferFrom(msg.sender, pair, liquidity); // send liquidity to pair
333         (uint amount0, uint amount1) = IUniswapV2Pair(pair).burn(to);
334         (address token0,) = UniswapV2Library.sortTokens(tokenA, tokenB);
335         (amountA, amountB) = tokenA == token0 ? (amount0, amount1) : (amount1, amount0);
336         require(amountA >= amountAMin, 'UniswapV2Router: INSUFFICIENT_A_AMOUNT');
337         require(amountB >= amountBMin, 'UniswapV2Router: INSUFFICIENT_B_AMOUNT');
338     }
339     function removeLiquidityETH(
340         address token,
341         uint liquidity,
342         uint amountTokenMin,
343         uint amountETHMin,
344         address to,
345         uint deadline
346     ) public virtual override ensure(deadline) returns (uint amountToken, uint amountETH) {
347         (amountToken, amountETH) = removeLiquidity(
348             token,
349             WETH,
350             liquidity,
351             amountTokenMin,
352             amountETHMin,
353             address(this),
354             deadline
355         );
356         TransferHelper.safeTransfer(token, to, amountToken);
357         IWETH(WETH).withdraw(amountETH);
358         TransferHelper.safeTransferETH(to, amountETH);
359     }
360     function removeLiquidityWithPermit(
361         address tokenA,
362         address tokenB,
363         uint liquidity,
364         uint amountAMin,
365         uint amountBMin,
366         address to,
367         uint deadline,
368         bool approveMax, uint8 v, bytes32 r, bytes32 s
369     ) external virtual override returns (uint amountA, uint amountB) {
370         address pair = UniswapV2Library.pairFor(factory, tokenA, tokenB);
371         uint value = approveMax ? uint(-1) : liquidity;
372         IUniswapV2Pair(pair).permit(msg.sender, address(this), value, deadline, v, r, s);
373         (amountA, amountB) = removeLiquidity(tokenA, tokenB, liquidity, amountAMin, amountBMin, to, deadline);
374     }
375     function removeLiquidityETHWithPermit(
376         address token,
377         uint liquidity,
378         uint amountTokenMin,
379         uint amountETHMin,
380         address to,
381         uint deadline,
382         bool approveMax, uint8 v, bytes32 r, bytes32 s
383     ) external virtual override returns (uint amountToken, uint amountETH) {
384         address pair = UniswapV2Library.pairFor(factory, token, WETH);
385         uint value = approveMax ? uint(-1) : liquidity;
386         IUniswapV2Pair(pair).permit(msg.sender, address(this), value, deadline, v, r, s);
387         (amountToken, amountETH) = removeLiquidityETH(token, liquidity, amountTokenMin, amountETHMin, to, deadline);
388     }
389 
390     // **** REMOVE LIQUIDITY (supporting fee-on-transfer tokens) ****
391     function removeLiquidityETHSupportingFeeOnTransferTokens(
392         address token,
393         uint liquidity,
394         uint amountTokenMin,
395         uint amountETHMin,
396         address to,
397         uint deadline
398     ) public virtual override ensure(deadline) returns (uint amountETH) {
399         (, amountETH) = removeLiquidity(
400             token,
401             WETH,
402             liquidity,
403             amountTokenMin,
404             amountETHMin,
405             address(this),
406             deadline
407         );
408         TransferHelper.safeTransfer(token, to, IERC20(token).balanceOf(address(this)));
409         IWETH(WETH).withdraw(amountETH);
410         TransferHelper.safeTransferETH(to, amountETH);
411     }
412     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
413         address token,
414         uint liquidity,
415         uint amountTokenMin,
416         uint amountETHMin,
417         address to,
418         uint deadline,
419         bool approveMax, uint8 v, bytes32 r, bytes32 s
420     ) external virtual override returns (uint amountETH) {
421         address pair = UniswapV2Library.pairFor(factory, token, WETH);
422         uint value = approveMax ? uint(-1) : liquidity;
423         IUniswapV2Pair(pair).permit(msg.sender, address(this), value, deadline, v, r, s);
424         amountETH = removeLiquidityETHSupportingFeeOnTransferTokens(
425             token, liquidity, amountTokenMin, amountETHMin, to, deadline
426         );
427     }
428 
429     // **** SWAP ****
430     // requires the initial amount to have already been sent to the first pair
431     function _swap(uint[] memory amounts, address[] memory path, address _to) internal virtual {
432         for (uint i; i < path.length - 1; i++) {
433             (address input, address output) = (path[i], path[i + 1]);
434             (address token0,) = UniswapV2Library.sortTokens(input, output);
435             uint amountOut = amounts[i + 1];
436             (uint amount0Out, uint amount1Out) = input == token0 ? (uint(0), amountOut) : (amountOut, uint(0));
437             address to = i < path.length - 2 ? UniswapV2Library.pairFor(factory, output, path[i + 2]) : _to;
438             IUniswapV2Pair(UniswapV2Library.pairFor(factory, input, output)).swap(
439                 amount0Out, amount1Out, to, new bytes(0)
440             );
441         }
442     }
443     function swapExactTokensForTokens(
444         uint amountIn,
445         uint amountOutMin,
446         address[] calldata path,
447         address to,
448         uint deadline
449     ) external virtual override ensure(deadline) returns (uint[] memory amounts) {
450         amounts = UniswapV2Library.getAmountsOut(factory, amountIn, path);
451         require(amounts[amounts.length - 1] >= amountOutMin, 'UniswapV2Router: INSUFFICIENT_OUTPUT_AMOUNT');
452         TransferHelper.safeTransferFrom(
453             path[0], msg.sender, UniswapV2Library.pairFor(factory, path[0], path[1]), amounts[0]
454         );
455         _swap(amounts, path, to);
456     }
457     function swapTokensForExactTokens(
458         uint amountOut,
459         uint amountInMax,
460         address[] calldata path,
461         address to,
462         uint deadline
463     ) external virtual override ensure(deadline) returns (uint[] memory amounts) {
464         amounts = UniswapV2Library.getAmountsIn(factory, amountOut, path);
465         require(amounts[0] <= amountInMax, 'UniswapV2Router: EXCESSIVE_INPUT_AMOUNT');
466         TransferHelper.safeTransferFrom(
467             path[0], msg.sender, UniswapV2Library.pairFor(factory, path[0], path[1]), amounts[0]
468         );
469         _swap(amounts, path, to);
470     }
471     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
472         external
473         virtual
474         override
475         payable
476         ensure(deadline)
477         returns (uint[] memory amounts)
478     {
479         require(path[0] == WETH, 'UniswapV2Router: INVALID_PATH');
480         amounts = UniswapV2Library.getAmountsOut(factory, msg.value, path);
481         require(amounts[amounts.length - 1] >= amountOutMin, 'UniswapV2Router: INSUFFICIENT_OUTPUT_AMOUNT');
482         IWETH(WETH).deposit{value: amounts[0]}();
483         assert(IWETH(WETH).transfer(UniswapV2Library.pairFor(factory, path[0], path[1]), amounts[0]));
484         _swap(amounts, path, to);
485     }
486     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
487         external
488         virtual
489         override
490         ensure(deadline)
491         returns (uint[] memory amounts)
492     {
493         require(path[path.length - 1] == WETH, 'UniswapV2Router: INVALID_PATH');
494         amounts = UniswapV2Library.getAmountsIn(factory, amountOut, path);
495         require(amounts[0] <= amountInMax, 'UniswapV2Router: EXCESSIVE_INPUT_AMOUNT');
496         TransferHelper.safeTransferFrom(
497             path[0], msg.sender, UniswapV2Library.pairFor(factory, path[0], path[1]), amounts[0]
498         );
499         _swap(amounts, path, address(this));
500         IWETH(WETH).withdraw(amounts[amounts.length - 1]);
501         TransferHelper.safeTransferETH(to, amounts[amounts.length - 1]);
502     }
503     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
504         external
505         virtual
506         override
507         ensure(deadline)
508         returns (uint[] memory amounts)
509     {
510         require(path[path.length - 1] == WETH, 'UniswapV2Router: INVALID_PATH');
511         amounts = UniswapV2Library.getAmountsOut(factory, amountIn, path);
512         require(amounts[amounts.length - 1] >= amountOutMin, 'UniswapV2Router: INSUFFICIENT_OUTPUT_AMOUNT');
513         TransferHelper.safeTransferFrom(
514             path[0], msg.sender, UniswapV2Library.pairFor(factory, path[0], path[1]), amounts[0]
515         );
516         _swap(amounts, path, address(this));
517         IWETH(WETH).withdraw(amounts[amounts.length - 1]);
518         TransferHelper.safeTransferETH(to, amounts[amounts.length - 1]);
519     }
520     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
521         external
522         virtual
523         override
524         payable
525         ensure(deadline)
526         returns (uint[] memory amounts)
527     {
528         require(path[0] == WETH, 'UniswapV2Router: INVALID_PATH');
529         amounts = UniswapV2Library.getAmountsIn(factory, amountOut, path);
530         require(amounts[0] <= msg.value, 'UniswapV2Router: EXCESSIVE_INPUT_AMOUNT');
531         IWETH(WETH).deposit{value: amounts[0]}();
532         assert(IWETH(WETH).transfer(UniswapV2Library.pairFor(factory, path[0], path[1]), amounts[0]));
533         _swap(amounts, path, to);
534         // refund dust eth, if any
535         if (msg.value > amounts[0]) TransferHelper.safeTransferETH(msg.sender, msg.value - amounts[0]);
536     }
537 
538     // **** SWAP (supporting fee-on-transfer tokens) ****
539     // requires the initial amount to have already been sent to the first pair
540     function _swapSupportingFeeOnTransferTokens(address[] memory path, address _to) internal virtual {
541         for (uint i; i < path.length - 1; i++) {
542             (address input, address output) = (path[i], path[i + 1]);
543             (address token0,) = UniswapV2Library.sortTokens(input, output);
544             IUniswapV2Pair pair = IUniswapV2Pair(UniswapV2Library.pairFor(factory, input, output));
545             uint amountInput;
546             uint amountOutput;
547             { // scope to avoid stack too deep errors
548             (uint reserve0, uint reserve1,) = pair.getReserves();
549             (uint reserveInput, uint reserveOutput) = input == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
550             amountInput = IERC20(input).balanceOf(address(pair)).sub(reserveInput);
551             amountOutput = UniswapV2Library.getAmountOut(amountInput, reserveInput, reserveOutput);
552             }
553             (uint amount0Out, uint amount1Out) = input == token0 ? (uint(0), amountOutput) : (amountOutput, uint(0));
554             address to = i < path.length - 2 ? UniswapV2Library.pairFor(factory, output, path[i + 2]) : _to;
555             pair.swap(amount0Out, amount1Out, to, new bytes(0));
556         }
557     }
558     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
559         uint amountIn,
560         uint amountOutMin,
561         address[] calldata path,
562         address to,
563         uint deadline
564     ) external virtual override ensure(deadline) {
565         TransferHelper.safeTransferFrom(
566             path[0], msg.sender, UniswapV2Library.pairFor(factory, path[0], path[1]), amountIn
567         );
568         uint balanceBefore = IERC20(path[path.length - 1]).balanceOf(to);
569         _swapSupportingFeeOnTransferTokens(path, to);
570         require(
571             IERC20(path[path.length - 1]).balanceOf(to).sub(balanceBefore) >= amountOutMin,
572             'UniswapV2Router: INSUFFICIENT_OUTPUT_AMOUNT'
573         );
574     }
575     function swapExactETHForTokensSupportingFeeOnTransferTokens(
576         uint amountOutMin,
577         address[] calldata path,
578         address to,
579         uint deadline
580     )
581         external
582         virtual
583         override
584         payable
585         ensure(deadline)
586     {
587         require(path[0] == WETH, 'UniswapV2Router: INVALID_PATH');
588         uint amountIn = msg.value;
589         IWETH(WETH).deposit{value: amountIn}();
590         assert(IWETH(WETH).transfer(UniswapV2Library.pairFor(factory, path[0], path[1]), amountIn));
591         uint balanceBefore = IERC20(path[path.length - 1]).balanceOf(to);
592         _swapSupportingFeeOnTransferTokens(path, to);
593         require(
594             IERC20(path[path.length - 1]).balanceOf(to).sub(balanceBefore) >= amountOutMin,
595             'UniswapV2Router: INSUFFICIENT_OUTPUT_AMOUNT'
596         );
597     }
598     function swapExactTokensForETHSupportingFeeOnTransferTokens(
599         uint amountIn,
600         uint amountOutMin,
601         address[] calldata path,
602         address to,
603         uint deadline
604     )
605         external
606         virtual
607         override
608         ensure(deadline)
609     {
610         require(path[path.length - 1] == WETH, 'UniswapV2Router: INVALID_PATH');
611         TransferHelper.safeTransferFrom(
612             path[0], msg.sender, UniswapV2Library.pairFor(factory, path[0], path[1]), amountIn
613         );
614         _swapSupportingFeeOnTransferTokens(path, address(this));
615         uint amountOut = IERC20(WETH).balanceOf(address(this));
616         require(amountOut >= amountOutMin, 'UniswapV2Router: INSUFFICIENT_OUTPUT_AMOUNT');
617         IWETH(WETH).withdraw(amountOut);
618         TransferHelper.safeTransferETH(to, amountOut);
619     }
620 
621     // **** LIBRARY FUNCTIONS ****
622     function quote(uint amountA, uint reserveA, uint reserveB) public pure virtual override returns (uint amountB) {
623         return UniswapV2Library.quote(amountA, reserveA, reserveB);
624     }
625 
626     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut)
627         public
628         pure
629         virtual
630         override
631         returns (uint amountOut)
632     {
633         return UniswapV2Library.getAmountOut(amountIn, reserveIn, reserveOut);
634     }
635 
636     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut)
637         public
638         pure
639         virtual
640         override
641         returns (uint amountIn)
642     {
643         return UniswapV2Library.getAmountIn(amountOut, reserveIn, reserveOut);
644     }
645 
646     function getAmountsOut(uint amountIn, address[] memory path)
647         public
648         view
649         virtual
650         override
651         returns (uint[] memory amounts)
652     {
653         return UniswapV2Library.getAmountsOut(factory, amountIn, path);
654     }
655 
656     function getAmountsIn(uint amountOut, address[] memory path)
657         public
658         view
659         virtual
660         override
661         returns (uint[] memory amounts)
662     {
663         return UniswapV2Library.getAmountsIn(factory, amountOut, path);
664     }
665 }
666 
667 // a library for performing overflow-safe math, courtesy of DappHub (https://github.com/dapphub/ds-math)
668 
669 library SafeMath {
670     function add(uint x, uint y) internal pure returns (uint z) {
671         require((z = x + y) >= x, 'ds-math-add-overflow');
672     }
673 
674     function sub(uint x, uint y) internal pure returns (uint z) {
675         require((z = x - y) <= x, 'ds-math-sub-underflow');
676     }
677 
678     function mul(uint x, uint y) internal pure returns (uint z) {
679         require(y == 0 || (z = x * y) / y == x, 'ds-math-mul-overflow');
680     }
681 }
682 
683 library UniswapV2Library {
684     using SafeMath for uint;
685 
686     // returns sorted token addresses, used to handle return values from pairs sorted in this order
687     function sortTokens(address tokenA, address tokenB) internal pure returns (address token0, address token1) {
688         require(tokenA != tokenB, 'UniswapV2Library: IDENTICAL_ADDRESSES');
689         (token0, token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
690         require(token0 != address(0), 'UniswapV2Library: ZERO_ADDRESS');
691     }
692 
693     // calculates the CREATE2 address for a pair without making any external calls
694     function pairFor(address factory, address tokenA, address tokenB) internal pure returns (address pair) {
695         (address token0, address token1) = sortTokens(tokenA, tokenB);
696         pair = address(uint(keccak256(abi.encodePacked(
697                 hex'ff',
698                 factory,
699                 keccak256(abi.encodePacked(token0, token1)),
700                 hex'05740dac44e1a922b5ef545f15b8ccda3f21b33912dd3411cf86b2daa8dd0867' // init code hash
701             ))));
702     }
703 
704     // fetches and sorts the reserves for a pair
705     function getReserves(address factory, address tokenA, address tokenB) internal view returns (uint reserveA, uint reserveB) {
706         (address token0,) = sortTokens(tokenA, tokenB);
707         (uint reserve0, uint reserve1,) = IUniswapV2Pair(pairFor(factory, tokenA, tokenB)).getReserves();
708         (reserveA, reserveB) = tokenA == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
709     }
710 
711     // given some amount of an asset and pair reserves, returns an equivalent amount of the other asset
712     function quote(uint amountA, uint reserveA, uint reserveB) internal pure returns (uint amountB) {
713         require(amountA > 0, 'UniswapV2Library: INSUFFICIENT_AMOUNT');
714         require(reserveA > 0 && reserveB > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
715         amountB = amountA.mul(reserveB) / reserveA;
716     }
717 
718     // given an input amount of an asset and pair reserves, returns the maximum output amount of the other asset
719     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) internal pure returns (uint amountOut) {
720         require(amountIn > 0, 'UniswapV2Library: INSUFFICIENT_INPUT_AMOUNT');
721         require(reserveIn > 0 && reserveOut > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
722         uint amountInWithFee = amountIn.mul(997);
723         uint numerator = amountInWithFee.mul(reserveOut);
724         uint denominator = reserveIn.mul(1000).add(amountInWithFee);
725         amountOut = numerator / denominator;
726     }
727 
728     // given an output amount of an asset and pair reserves, returns a required input amount of the other asset
729     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) internal pure returns (uint amountIn) {
730         require(amountOut > 0, 'UniswapV2Library: INSUFFICIENT_OUTPUT_AMOUNT');
731         require(reserveIn > 0 && reserveOut > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
732         uint numerator = reserveIn.mul(amountOut).mul(1000);
733         uint denominator = reserveOut.sub(amountOut).mul(997);
734         amountIn = (numerator / denominator).add(1);
735     }
736 
737     // performs chained getAmountOut calculations on any number of pairs
738     function getAmountsOut(address factory, uint amountIn, address[] memory path) internal view returns (uint[] memory amounts) {
739         require(path.length >= 2, 'UniswapV2Library: INVALID_PATH');
740         amounts = new uint[](path.length);
741         amounts[0] = amountIn;
742         for (uint i; i < path.length - 1; i++) {
743             (uint reserveIn, uint reserveOut) = getReserves(factory, path[i], path[i + 1]);
744             amounts[i + 1] = getAmountOut(amounts[i], reserveIn, reserveOut);
745         }
746     }
747 
748     // performs chained getAmountIn calculations on any number of pairs
749     function getAmountsIn(address factory, uint amountOut, address[] memory path) internal view returns (uint[] memory amounts) {
750         require(path.length >= 2, 'UniswapV2Library: INVALID_PATH');
751         amounts = new uint[](path.length);
752         amounts[amounts.length - 1] = amountOut;
753         for (uint i = path.length - 1; i > 0; i--) {
754             (uint reserveIn, uint reserveOut) = getReserves(factory, path[i - 1], path[i]);
755             amounts[i - 1] = getAmountIn(amounts[i], reserveIn, reserveOut);
756         }
757     }
758 }
759 
760 // helper methods for interacting with ERC20 tokens and sending ETH that do not consistently return true/false
761 library TransferHelper {
762     function safeApprove(address token, address to, uint value) internal {
763         // bytes4(keccak256(bytes('approve(address,uint256)')));
764         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x095ea7b3, to, value));
765         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: APPROVE_FAILED');
766     }
767 
768     function safeTransfer(address token, address to, uint value) internal {
769         // bytes4(keccak256(bytes('transfer(address,uint256)')));
770         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));
771         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FAILED');
772     }
773 
774     function safeTransferFrom(address token, address from, address to, uint value) internal {
775         // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
776         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));
777         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FROM_FAILED');
778     }
779 
780     function safeTransferETH(address to, uint value) internal {
781         (bool success,) = to.call{value:value}(new bytes(0));
782         require(success, 'TransferHelper: ETH_TRANSFER_FAILED');
783     }
784 }