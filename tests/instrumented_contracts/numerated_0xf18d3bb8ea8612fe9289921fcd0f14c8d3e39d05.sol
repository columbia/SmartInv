1 pragma solidity =0.6.6;
2 
3 interface IUniswapV2Factory {
4     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
5 
6     function feeTo() external view returns (address);
7     function feeToSetter() external view returns (address);
8 
9     function getPair(address tokenA, address tokenB) external view returns (address pair);
10     function allPairs(uint) external view returns (address pair);
11     function allPairsLength() external view returns (uint);
12 
13     function createPair(address tokenA, address tokenB) external returns (address pair);
14 
15     function setFeeTo(address) external;
16     function setFeeToSetter(address) external;
17 }
18 
19 interface IUniswapV2Pair {
20     event Approval(address indexed owner, address indexed spender, uint value);
21     event Transfer(address indexed from, address indexed to, uint value);
22 
23     function name() external pure returns (string memory);
24     function symbol() external pure returns (string memory);
25     function decimals() external pure returns (uint8);
26     function totalSupply() external view returns (uint);
27     function balanceOf(address owner) external view returns (uint);
28     function allowance(address owner, address spender) external view returns (uint);
29 
30     function approve(address spender, uint value) external returns (bool);
31     function transfer(address to, uint value) external returns (bool);
32     function transferFrom(address from, address to, uint value) external returns (bool);
33 
34     function DOMAIN_SEPARATOR() external view returns (bytes32);
35     function PERMIT_TYPEHASH() external pure returns (bytes32);
36     function nonces(address owner) external view returns (uint);
37 
38     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
39 
40     event Mint(address indexed sender, uint amount0, uint amount1);
41     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
42     event Swap(
43         address indexed sender,
44         uint amount0In,
45         uint amount1In,
46         uint amount0Out,
47         uint amount1Out,
48         address indexed to
49     );
50     event Sync(uint112 reserve0, uint112 reserve1);
51 
52     function MINIMUM_LIQUIDITY() external pure returns (uint);
53     function factory() external view returns (address);
54     function token0() external view returns (address);
55     function token1() external view returns (address);
56     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
57     function price0CumulativeLast() external view returns (uint);
58     function price1CumulativeLast() external view returns (uint);
59     function kLast() external view returns (uint);
60 
61     function mint(address to) external returns (uint liquidity);
62     function burn(address to) external returns (uint amount0, uint amount1);
63     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
64     function skim(address to) external;
65     function sync() external;
66 
67     function initialize(address, address) external;
68 }
69 
70 interface IUniswapV2Router01 {
71     function factory() external pure returns (address);
72     function WETH() external pure returns (address);
73 
74     function addLiquidity(
75         address tokenA,
76         address tokenB,
77         uint amountADesired,
78         uint amountBDesired,
79         uint amountAMin,
80         uint amountBMin,
81         address to,
82         uint deadline
83     ) external returns (uint amountA, uint amountB, uint liquidity);
84     function addLiquidityETH(
85         address token,
86         uint amountTokenDesired,
87         uint amountTokenMin,
88         uint amountETHMin,
89         address to,
90         uint deadline
91     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
92     function removeLiquidity(
93         address tokenA,
94         address tokenB,
95         uint liquidity,
96         uint amountAMin,
97         uint amountBMin,
98         address to,
99         uint deadline
100     ) external returns (uint amountA, uint amountB);
101     function removeLiquidityETH(
102         address token,
103         uint liquidity,
104         uint amountTokenMin,
105         uint amountETHMin,
106         address to,
107         uint deadline
108     ) external returns (uint amountToken, uint amountETH);
109     function removeLiquidityWithPermit(
110         address tokenA,
111         address tokenB,
112         uint liquidity,
113         uint amountAMin,
114         uint amountBMin,
115         address to,
116         uint deadline,
117         bool approveMax, uint8 v, bytes32 r, bytes32 s
118     ) external returns (uint amountA, uint amountB);
119     function removeLiquidityETHWithPermit(
120         address token,
121         uint liquidity,
122         uint amountTokenMin,
123         uint amountETHMin,
124         address to,
125         uint deadline,
126         bool approveMax, uint8 v, bytes32 r, bytes32 s
127     ) external returns (uint amountToken, uint amountETH);
128     function swapExactTokensForTokens(
129         uint amountIn,
130         uint amountOutMin,
131         address[] calldata path,
132         address to,
133         uint deadline
134     ) external returns (uint[] memory amounts);
135     function swapTokensForExactTokens(
136         uint amountOut,
137         uint amountInMax,
138         address[] calldata path,
139         address to,
140         uint deadline
141     ) external returns (uint[] memory amounts);
142     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
143         external
144         payable
145         returns (uint[] memory amounts);
146     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
147         external
148         returns (uint[] memory amounts);
149     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
150         external
151         returns (uint[] memory amounts);
152     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
153         external
154         payable
155         returns (uint[] memory amounts);
156 
157     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
158     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
159     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
160     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
161     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
162 }
163 
164 interface IUniswapV2Router02 is IUniswapV2Router01 {
165     function removeLiquidityETHSupportingFeeOnTransferTokens(
166         address token,
167         uint liquidity,
168         uint amountTokenMin,
169         uint amountETHMin,
170         address to,
171         uint deadline
172     ) external returns (uint amountETH);
173     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
174         address token,
175         uint liquidity,
176         uint amountTokenMin,
177         uint amountETHMin,
178         address to,
179         uint deadline,
180         bool approveMax, uint8 v, bytes32 r, bytes32 s
181     ) external returns (uint amountETH);
182 
183     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
184         uint amountIn,
185         uint amountOutMin,
186         address[] calldata path,
187         address to,
188         uint deadline
189     ) external;
190     function swapExactETHForTokensSupportingFeeOnTransferTokens(
191         uint amountOutMin,
192         address[] calldata path,
193         address to,
194         uint deadline
195     ) external payable;
196     function swapExactTokensForETHSupportingFeeOnTransferTokens(
197         uint amountIn,
198         uint amountOutMin,
199         address[] calldata path,
200         address to,
201         uint deadline
202     ) external;
203 }
204 
205 interface IERC20 {
206     event Approval(address indexed owner, address indexed spender, uint value);
207     event Transfer(address indexed from, address indexed to, uint value);
208 
209     function name() external view returns (string memory);
210     function symbol() external view returns (string memory);
211     function decimals() external view returns (uint8);
212     function totalSupply() external view returns (uint);
213     function balanceOf(address owner) external view returns (uint);
214     function allowance(address owner, address spender) external view returns (uint);
215 
216     function approve(address spender, uint value) external returns (bool);
217     function transfer(address to, uint value) external returns (bool);
218     function transferFrom(address from, address to, uint value) external returns (bool);
219 }
220 
221 interface IWETH {
222     function deposit() external payable;
223     function transfer(address to, uint value) external returns (bool);
224     function withdraw(uint) external;
225 }
226 
227 contract UniswapV2Router02 is IUniswapV2Router02 {
228     using SafeMath for uint;
229 
230     address public immutable override factory;
231     address public immutable override WETH;
232 
233     modifier ensure(uint deadline) {
234         require(deadline >= block.timestamp, 'UniswapV2Router: EXPIRED');
235         _;
236     }
237 
238     constructor(address _factory, address _WETH) public {
239         factory = _factory;
240         WETH = _WETH;
241     }
242 
243     receive() external payable {
244         assert(msg.sender == WETH); // only accept ETH via fallback from the WETH contract
245     }
246 
247     // **** ADD LIQUIDITY ****
248     function _addLiquidity(
249         address tokenA,
250         address tokenB,
251         uint amountADesired,
252         uint amountBDesired,
253         uint amountAMin,
254         uint amountBMin
255     ) internal virtual returns (uint amountA, uint amountB) {
256         // create the pair if it doesn't exist yet
257         if (IUniswapV2Factory(factory).getPair(tokenA, tokenB) == address(0)) {
258             IUniswapV2Factory(factory).createPair(tokenA, tokenB);
259         }
260         (uint reserveA, uint reserveB) = UniswapV2Library.getReserves(factory, tokenA, tokenB);
261         if (reserveA == 0 && reserveB == 0) {
262             (amountA, amountB) = (amountADesired, amountBDesired);
263         } else {
264             uint amountBOptimal = UniswapV2Library.quote(amountADesired, reserveA, reserveB);
265             if (amountBOptimal <= amountBDesired) {
266                 require(amountBOptimal >= amountBMin, 'UniswapV2Router: INSUFFICIENT_B_AMOUNT');
267                 (amountA, amountB) = (amountADesired, amountBOptimal);
268             } else {
269                 uint amountAOptimal = UniswapV2Library.quote(amountBDesired, reserveB, reserveA);
270                 assert(amountAOptimal <= amountADesired);
271                 require(amountAOptimal >= amountAMin, 'UniswapV2Router: INSUFFICIENT_A_AMOUNT');
272                 (amountA, amountB) = (amountAOptimal, amountBDesired);
273             }
274         }
275     }
276     function addLiquidity(
277         address tokenA,
278         address tokenB,
279         uint amountADesired,
280         uint amountBDesired,
281         uint amountAMin,
282         uint amountBMin,
283         address to,
284         uint deadline
285     ) external virtual override ensure(deadline) returns (uint amountA, uint amountB, uint liquidity) {
286         (amountA, amountB) = _addLiquidity(tokenA, tokenB, amountADesired, amountBDesired, amountAMin, amountBMin);
287         address pair = UniswapV2Library.pairFor(factory, tokenA, tokenB);
288         TransferHelper.safeTransferFrom(tokenA, msg.sender, pair, amountA);
289         TransferHelper.safeTransferFrom(tokenB, msg.sender, pair, amountB);
290         liquidity = IUniswapV2Pair(pair).mint(to);
291     }
292     function addLiquidityETH(
293         address token,
294         uint amountTokenDesired,
295         uint amountTokenMin,
296         uint amountETHMin,
297         address to,
298         uint deadline
299     ) external virtual override payable ensure(deadline) returns (uint amountToken, uint amountETH, uint liquidity) {
300         (amountToken, amountETH) = _addLiquidity(
301             token,
302             WETH,
303             amountTokenDesired,
304             msg.value,
305             amountTokenMin,
306             amountETHMin
307         );
308         address pair = UniswapV2Library.pairFor(factory, token, WETH);
309         TransferHelper.safeTransferFrom(token, msg.sender, pair, amountToken);
310         IWETH(WETH).deposit{value: amountETH}();
311         assert(IWETH(WETH).transfer(pair, amountETH));
312         liquidity = IUniswapV2Pair(pair).mint(to);
313         // refund dust eth, if any
314         if (msg.value > amountETH) TransferHelper.safeTransferETH(msg.sender, msg.value - amountETH);
315     }
316 
317     // **** REMOVE LIQUIDITY ****
318     function removeLiquidity(
319         address tokenA,
320         address tokenB,
321         uint liquidity,
322         uint amountAMin,
323         uint amountBMin,
324         address to,
325         uint deadline
326     ) public virtual override ensure(deadline) returns (uint amountA, uint amountB) {
327         address pair = UniswapV2Library.pairFor(factory, tokenA, tokenB);
328         IUniswapV2Pair(pair).transferFrom(msg.sender, pair, liquidity); // send liquidity to pair
329         (uint amount0, uint amount1) = IUniswapV2Pair(pair).burn(to);
330         (address token0,) = UniswapV2Library.sortTokens(tokenA, tokenB);
331         (amountA, amountB) = tokenA == token0 ? (amount0, amount1) : (amount1, amount0);
332         require(amountA >= amountAMin, 'UniswapV2Router: INSUFFICIENT_A_AMOUNT');
333         require(amountB >= amountBMin, 'UniswapV2Router: INSUFFICIENT_B_AMOUNT');
334     }
335     function removeLiquidityETH(
336         address token,
337         uint liquidity,
338         uint amountTokenMin,
339         uint amountETHMin,
340         address to,
341         uint deadline
342     ) public virtual override ensure(deadline) returns (uint amountToken, uint amountETH) {
343         (amountToken, amountETH) = removeLiquidity(
344             token,
345             WETH,
346             liquidity,
347             amountTokenMin,
348             amountETHMin,
349             address(this),
350             deadline
351         );
352         TransferHelper.safeTransfer(token, to, amountToken);
353         IWETH(WETH).withdraw(amountETH);
354         TransferHelper.safeTransferETH(to, amountETH);
355     }
356     function removeLiquidityWithPermit(
357         address tokenA,
358         address tokenB,
359         uint liquidity,
360         uint amountAMin,
361         uint amountBMin,
362         address to,
363         uint deadline,
364         bool approveMax, uint8 v, bytes32 r, bytes32 s
365     ) external virtual override returns (uint amountA, uint amountB) {
366         address pair = UniswapV2Library.pairFor(factory, tokenA, tokenB);
367         uint value = approveMax ? uint(-1) : liquidity;
368         IUniswapV2Pair(pair).permit(msg.sender, address(this), value, deadline, v, r, s);
369         (amountA, amountB) = removeLiquidity(tokenA, tokenB, liquidity, amountAMin, amountBMin, to, deadline);
370     }
371     function removeLiquidityETHWithPermit(
372         address token,
373         uint liquidity,
374         uint amountTokenMin,
375         uint amountETHMin,
376         address to,
377         uint deadline,
378         bool approveMax, uint8 v, bytes32 r, bytes32 s
379     ) external virtual override returns (uint amountToken, uint amountETH) {
380         address pair = UniswapV2Library.pairFor(factory, token, WETH);
381         uint value = approveMax ? uint(-1) : liquidity;
382         IUniswapV2Pair(pair).permit(msg.sender, address(this), value, deadline, v, r, s);
383         (amountToken, amountETH) = removeLiquidityETH(token, liquidity, amountTokenMin, amountETHMin, to, deadline);
384     }
385 
386     // **** REMOVE LIQUIDITY (supporting fee-on-transfer tokens) ****
387     function removeLiquidityETHSupportingFeeOnTransferTokens(
388         address token,
389         uint liquidity,
390         uint amountTokenMin,
391         uint amountETHMin,
392         address to,
393         uint deadline
394     ) public virtual override ensure(deadline) returns (uint amountETH) {
395         (, amountETH) = removeLiquidity(
396             token,
397             WETH,
398             liquidity,
399             amountTokenMin,
400             amountETHMin,
401             address(this),
402             deadline
403         );
404         TransferHelper.safeTransfer(token, to, IERC20(token).balanceOf(address(this)));
405         IWETH(WETH).withdraw(amountETH);
406         TransferHelper.safeTransferETH(to, amountETH);
407     }
408     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
409         address token,
410         uint liquidity,
411         uint amountTokenMin,
412         uint amountETHMin,
413         address to,
414         uint deadline,
415         bool approveMax, uint8 v, bytes32 r, bytes32 s
416     ) external virtual override returns (uint amountETH) {
417         address pair = UniswapV2Library.pairFor(factory, token, WETH);
418         uint value = approveMax ? uint(-1) : liquidity;
419         IUniswapV2Pair(pair).permit(msg.sender, address(this), value, deadline, v, r, s);
420         amountETH = removeLiquidityETHSupportingFeeOnTransferTokens(
421             token, liquidity, amountTokenMin, amountETHMin, to, deadline
422         );
423     }
424 
425     // **** SWAP ****
426     // requires the initial amount to have already been sent to the first pair
427     function _swap(uint[] memory amounts, address[] memory path, address _to) internal virtual {
428         for (uint i; i < path.length - 1; i++) {
429             (address input, address output) = (path[i], path[i + 1]);
430             (address token0,) = UniswapV2Library.sortTokens(input, output);
431             uint amountOut = amounts[i + 1];
432             (uint amount0Out, uint amount1Out) = input == token0 ? (uint(0), amountOut) : (amountOut, uint(0));
433             address to = i < path.length - 2 ? UniswapV2Library.pairFor(factory, output, path[i + 2]) : _to;
434             IUniswapV2Pair(UniswapV2Library.pairFor(factory, input, output)).swap(
435                 amount0Out, amount1Out, to, new bytes(0)
436             );
437         }
438     }
439     function swapExactTokensForTokens(
440         uint amountIn,
441         uint amountOutMin,
442         address[] calldata path,
443         address to,
444         uint deadline
445     ) external virtual override ensure(deadline) returns (uint[] memory amounts) {
446         amounts = UniswapV2Library.getAmountsOut(factory, amountIn, path);
447         require(amounts[amounts.length - 1] >= amountOutMin, 'UniswapV2Router: INSUFFICIENT_OUTPUT_AMOUNT');
448         TransferHelper.safeTransferFrom(
449             path[0], msg.sender, UniswapV2Library.pairFor(factory, path[0], path[1]), amounts[0]
450         );
451         _swap(amounts, path, to);
452     }
453     function swapTokensForExactTokens(
454         uint amountOut,
455         uint amountInMax,
456         address[] calldata path,
457         address to,
458         uint deadline
459     ) external virtual override ensure(deadline) returns (uint[] memory amounts) {
460         amounts = UniswapV2Library.getAmountsIn(factory, amountOut, path);
461         require(amounts[0] <= amountInMax, 'UniswapV2Router: EXCESSIVE_INPUT_AMOUNT');
462         TransferHelper.safeTransferFrom(
463             path[0], msg.sender, UniswapV2Library.pairFor(factory, path[0], path[1]), amounts[0]
464         );
465         _swap(amounts, path, to);
466     }
467     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
468         external
469         virtual
470         override
471         payable
472         ensure(deadline)
473         returns (uint[] memory amounts)
474     {
475         require(path[0] == WETH, 'UniswapV2Router: INVALID_PATH');
476         amounts = UniswapV2Library.getAmountsOut(factory, msg.value, path);
477         require(amounts[amounts.length - 1] >= amountOutMin, 'UniswapV2Router: INSUFFICIENT_OUTPUT_AMOUNT');
478         IWETH(WETH).deposit{value: amounts[0]}();
479         assert(IWETH(WETH).transfer(UniswapV2Library.pairFor(factory, path[0], path[1]), amounts[0]));
480         _swap(amounts, path, to);
481     }
482     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
483         external
484         virtual
485         override
486         ensure(deadline)
487         returns (uint[] memory amounts)
488     {
489         require(path[path.length - 1] == WETH, 'UniswapV2Router: INVALID_PATH');
490         amounts = UniswapV2Library.getAmountsIn(factory, amountOut, path);
491         require(amounts[0] <= amountInMax, 'UniswapV2Router: EXCESSIVE_INPUT_AMOUNT');
492         TransferHelper.safeTransferFrom(
493             path[0], msg.sender, UniswapV2Library.pairFor(factory, path[0], path[1]), amounts[0]
494         );
495         _swap(amounts, path, address(this));
496         IWETH(WETH).withdraw(amounts[amounts.length - 1]);
497         TransferHelper.safeTransferETH(to, amounts[amounts.length - 1]);
498     }
499     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
500         external
501         virtual
502         override
503         ensure(deadline)
504         returns (uint[] memory amounts)
505     {
506         require(path[path.length - 1] == WETH, 'UniswapV2Router: INVALID_PATH');
507         amounts = UniswapV2Library.getAmountsOut(factory, amountIn, path);
508         require(amounts[amounts.length - 1] >= amountOutMin, 'UniswapV2Router: INSUFFICIENT_OUTPUT_AMOUNT');
509         TransferHelper.safeTransferFrom(
510             path[0], msg.sender, UniswapV2Library.pairFor(factory, path[0], path[1]), amounts[0]
511         );
512         _swap(amounts, path, address(this));
513         IWETH(WETH).withdraw(amounts[amounts.length - 1]);
514         TransferHelper.safeTransferETH(to, amounts[amounts.length - 1]);
515     }
516     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
517         external
518         virtual
519         override
520         payable
521         ensure(deadline)
522         returns (uint[] memory amounts)
523     {
524         require(path[0] == WETH, 'UniswapV2Router: INVALID_PATH');
525         amounts = UniswapV2Library.getAmountsIn(factory, amountOut, path);
526         require(amounts[0] <= msg.value, 'UniswapV2Router: EXCESSIVE_INPUT_AMOUNT');
527         IWETH(WETH).deposit{value: amounts[0]}();
528         assert(IWETH(WETH).transfer(UniswapV2Library.pairFor(factory, path[0], path[1]), amounts[0]));
529         _swap(amounts, path, to);
530         // refund dust eth, if any
531         if (msg.value > amounts[0]) TransferHelper.safeTransferETH(msg.sender, msg.value - amounts[0]);
532     }
533 
534     // **** SWAP (supporting fee-on-transfer tokens) ****
535     // requires the initial amount to have already been sent to the first pair
536     function _swapSupportingFeeOnTransferTokens(address[] memory path, address _to) internal virtual {
537         for (uint i; i < path.length - 1; i++) {
538             (address input, address output) = (path[i], path[i + 1]);
539             (address token0,) = UniswapV2Library.sortTokens(input, output);
540             IUniswapV2Pair pair = IUniswapV2Pair(UniswapV2Library.pairFor(factory, input, output));
541             uint amountInput;
542             uint amountOutput;
543             { // scope to avoid stack too deep errors
544             (uint reserve0, uint reserve1,) = pair.getReserves();
545             (uint reserveInput, uint reserveOutput) = input == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
546             amountInput = IERC20(input).balanceOf(address(pair)).sub(reserveInput);
547             amountOutput = UniswapV2Library.getAmountOut(amountInput, reserveInput, reserveOutput);
548             }
549             (uint amount0Out, uint amount1Out) = input == token0 ? (uint(0), amountOutput) : (amountOutput, uint(0));
550             address to = i < path.length - 2 ? UniswapV2Library.pairFor(factory, output, path[i + 2]) : _to;
551             pair.swap(amount0Out, amount1Out, to, new bytes(0));
552         }
553     }
554     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
555         uint amountIn,
556         uint amountOutMin,
557         address[] calldata path,
558         address to,
559         uint deadline
560     ) external virtual override ensure(deadline) {
561         TransferHelper.safeTransferFrom(
562             path[0], msg.sender, UniswapV2Library.pairFor(factory, path[0], path[1]), amountIn
563         );
564         uint balanceBefore = IERC20(path[path.length - 1]).balanceOf(to);
565         _swapSupportingFeeOnTransferTokens(path, to);
566         require(
567             IERC20(path[path.length - 1]).balanceOf(to).sub(balanceBefore) >= amountOutMin,
568             'UniswapV2Router: INSUFFICIENT_OUTPUT_AMOUNT'
569         );
570     }
571     function swapExactETHForTokensSupportingFeeOnTransferTokens(
572         uint amountOutMin,
573         address[] calldata path,
574         address to,
575         uint deadline
576     )
577         external
578         virtual
579         override
580         payable
581         ensure(deadline)
582     {
583         require(path[0] == WETH, 'UniswapV2Router: INVALID_PATH');
584         uint amountIn = msg.value;
585         IWETH(WETH).deposit{value: amountIn}();
586         assert(IWETH(WETH).transfer(UniswapV2Library.pairFor(factory, path[0], path[1]), amountIn));
587         uint balanceBefore = IERC20(path[path.length - 1]).balanceOf(to);
588         _swapSupportingFeeOnTransferTokens(path, to);
589         require(
590             IERC20(path[path.length - 1]).balanceOf(to).sub(balanceBefore) >= amountOutMin,
591             'UniswapV2Router: INSUFFICIENT_OUTPUT_AMOUNT'
592         );
593     }
594     function swapExactTokensForETHSupportingFeeOnTransferTokens(
595         uint amountIn,
596         uint amountOutMin,
597         address[] calldata path,
598         address to,
599         uint deadline
600     )
601         external
602         virtual
603         override
604         ensure(deadline)
605     {
606         require(path[path.length - 1] == WETH, 'UniswapV2Router: INVALID_PATH');
607         TransferHelper.safeTransferFrom(
608             path[0], msg.sender, UniswapV2Library.pairFor(factory, path[0], path[1]), amountIn
609         );
610         _swapSupportingFeeOnTransferTokens(path, address(this));
611         uint amountOut = IERC20(WETH).balanceOf(address(this));
612         require(amountOut >= amountOutMin, 'UniswapV2Router: INSUFFICIENT_OUTPUT_AMOUNT');
613         IWETH(WETH).withdraw(amountOut);
614         TransferHelper.safeTransferETH(to, amountOut);
615     }
616 
617     // **** LIBRARY FUNCTIONS ****
618     function quote(uint amountA, uint reserveA, uint reserveB) public pure virtual override returns (uint amountB) {
619         return UniswapV2Library.quote(amountA, reserveA, reserveB);
620     }
621 
622     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut)
623         public
624         pure
625         virtual
626         override
627         returns (uint amountOut)
628     {
629         return UniswapV2Library.getAmountOut(amountIn, reserveIn, reserveOut);
630     }
631 
632     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut)
633         public
634         pure
635         virtual
636         override
637         returns (uint amountIn)
638     {
639         return UniswapV2Library.getAmountIn(amountOut, reserveIn, reserveOut);
640     }
641 
642     function getAmountsOut(uint amountIn, address[] memory path)
643         public
644         view
645         virtual
646         override
647         returns (uint[] memory amounts)
648     {
649         return UniswapV2Library.getAmountsOut(factory, amountIn, path);
650     }
651 
652     function getAmountsIn(uint amountOut, address[] memory path)
653         public
654         view
655         virtual
656         override
657         returns (uint[] memory amounts)
658     {
659         return UniswapV2Library.getAmountsIn(factory, amountOut, path);
660     }
661 }
662 
663 // a library for performing overflow-safe math, courtesy of DappHub (https://github.com/dapphub/ds-math)
664 
665 library SafeMath {
666     function add(uint x, uint y) internal pure returns (uint z) {
667         require((z = x + y) >= x, 'ds-math-add-overflow');
668     }
669 
670     function sub(uint x, uint y) internal pure returns (uint z) {
671         require((z = x - y) <= x, 'ds-math-sub-underflow');
672     }
673 
674     function mul(uint x, uint y) internal pure returns (uint z) {
675         require(y == 0 || (z = x * y) / y == x, 'ds-math-mul-overflow');
676     }
677 }
678 
679 library UniswapV2Library {
680     using SafeMath for uint;
681 
682     // returns sorted token addresses, used to handle return values from pairs sorted in this order
683     function sortTokens(address tokenA, address tokenB) internal pure returns (address token0, address token1) {
684         require(tokenA != tokenB, 'UniswapV2Library: IDENTICAL_ADDRESSES');
685         (token0, token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
686         require(token0 != address(0), 'UniswapV2Library: ZERO_ADDRESS');
687     }
688 
689     // calculates the CREATE2 address for a pair without making any external calls
690     function pairFor(address factory, address tokenA, address tokenB) internal pure returns (address pair) {
691         (address token0, address token1) = sortTokens(tokenA, tokenB);
692         pair = address(uint(keccak256(abi.encodePacked(
693                 hex'ff',
694                 factory,
695                 keccak256(abi.encodePacked(token0, token1)),
696                 hex'90d23d436361e287bc8023d90678b1f39ab5e47059d5627ae77fc769d3d33822' // init code hash
697             ))));
698     }
699 
700     // fetches and sorts the reserves for a pair
701     function getReserves(address factory, address tokenA, address tokenB) internal view returns (uint reserveA, uint reserveB) {
702         (address token0,) = sortTokens(tokenA, tokenB);
703         (uint reserve0, uint reserve1,) = IUniswapV2Pair(pairFor(factory, tokenA, tokenB)).getReserves();
704         (reserveA, reserveB) = tokenA == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
705     }
706 
707     // given some amount of an asset and pair reserves, returns an equivalent amount of the other asset
708     function quote(uint amountA, uint reserveA, uint reserveB) internal pure returns (uint amountB) {
709         require(amountA > 0, 'UniswapV2Library: INSUFFICIENT_AMOUNT');
710         require(reserveA > 0 && reserveB > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
711         amountB = amountA.mul(reserveB) / reserveA;
712     }
713 
714     // given an input amount of an asset and pair reserves, returns the maximum output amount of the other asset
715     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) internal pure returns (uint amountOut) {
716         require(amountIn > 0, 'UniswapV2Library: INSUFFICIENT_INPUT_AMOUNT');
717         require(reserveIn > 0 && reserveOut > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
718         uint amountInWithFee = amountIn.mul(997);
719         uint numerator = amountInWithFee.mul(reserveOut);
720         uint denominator = reserveIn.mul(1000).add(amountInWithFee);
721         amountOut = numerator / denominator;
722     }
723 
724     // given an output amount of an asset and pair reserves, returns a required input amount of the other asset
725     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) internal pure returns (uint amountIn) {
726         require(amountOut > 0, 'UniswapV2Library: INSUFFICIENT_OUTPUT_AMOUNT');
727         require(reserveIn > 0 && reserveOut > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
728         uint numerator = reserveIn.mul(amountOut).mul(1000);
729         uint denominator = reserveOut.sub(amountOut).mul(997);
730         amountIn = (numerator / denominator).add(1);
731     }
732 
733     // performs chained getAmountOut calculations on any number of pairs
734     function getAmountsOut(address factory, uint amountIn, address[] memory path) internal view returns (uint[] memory amounts) {
735         require(path.length >= 2, 'UniswapV2Library: INVALID_PATH');
736         amounts = new uint[](path.length);
737         amounts[0] = amountIn;
738         for (uint i; i < path.length - 1; i++) {
739             (uint reserveIn, uint reserveOut) = getReserves(factory, path[i], path[i + 1]);
740             amounts[i + 1] = getAmountOut(amounts[i], reserveIn, reserveOut);
741         }
742     }
743 
744     // performs chained getAmountIn calculations on any number of pairs
745     function getAmountsIn(address factory, uint amountOut, address[] memory path) internal view returns (uint[] memory amounts) {
746         require(path.length >= 2, 'UniswapV2Library: INVALID_PATH');
747         amounts = new uint[](path.length);
748         amounts[amounts.length - 1] = amountOut;
749         for (uint i = path.length - 1; i > 0; i--) {
750             (uint reserveIn, uint reserveOut) = getReserves(factory, path[i - 1], path[i]);
751             amounts[i - 1] = getAmountIn(amounts[i], reserveIn, reserveOut);
752         }
753     }
754 }
755 
756 // helper methods for interacting with ERC20 tokens and sending ETH that do not consistently return true/false
757 library TransferHelper {
758     function safeApprove(address token, address to, uint value) internal {
759         // bytes4(keccak256(bytes('approve(address,uint256)')));
760         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x095ea7b3, to, value));
761         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: APPROVE_FAILED');
762     }
763 
764     function safeTransfer(address token, address to, uint value) internal {
765         // bytes4(keccak256(bytes('transfer(address,uint256)')));
766         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));
767         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FAILED');
768     }
769 
770     function safeTransferFrom(address token, address from, address to, uint value) internal {
771         // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
772         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));
773         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FROM_FAILED');
774     }
775 
776     function safeTransferETH(address to, uint value) internal {
777         (bool success,) = to.call{value:value}(new bytes(0));
778         require(success, 'TransferHelper: ETH_TRANSFER_FAILED');
779     }
780 }