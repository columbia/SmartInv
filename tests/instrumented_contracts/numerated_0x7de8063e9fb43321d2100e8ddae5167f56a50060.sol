1 // SPDX-License-Identifier: GPL-3.0
2 pragma solidity =0.8.15;
3 
4 /*
5 
6  /$$   /$$ /$$$$$$$$       /$$$$$$$$ /$$
7 | $$  / $$|_____ $$/      | $$_____/|__/
8 |  $$/ $$/     /$$/       | $$       /$$ /$$$$$$$   /$$$$$$  /$$$$$$$   /$$$$$$$  /$$$$$$
9  \  $$$$/     /$$/        | $$$$$   | $$| $$__  $$ |____  $$| $$__  $$ /$$_____/ /$$__  $$
10   >$$  $$    /$$/         | $$__/   | $$| $$  \ $$  /$$$$$$$| $$  \ $$| $$      | $$$$$$$$
11  /$$/\  $$  /$$/          | $$      | $$| $$  | $$ /$$__  $$| $$  | $$| $$      | $$_____/
12 | $$  \ $$ /$$/           | $$      | $$| $$  | $$|  $$$$$$$| $$  | $$|  $$$$$$$|  $$$$$$$
13 |__/  |__/|__/            |__/      |__/|__/  |__/ \_______/|__/  |__/ \_______/ \_______/
14 
15 Contract: Uniswapv2 Fork - XchangeRouter
16 
17 In addition to the standard Uniswap V2 Router, this contract includes functionality to remove liquidity in a failsafe manner to permit liquidation of fee liquidity in all cases.
18 
19 The authority to call that function is assigned via the Xchange Factory.
20 
21 This contract will NOT be renounced, however it has no functions which affect the contract. The contract is "owned" solely as a formality.
22 
23 */
24 
25 abstract contract Ownable {
26     address private _owner;
27 
28     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
29 
30     constructor(address owner_) {
31         _transferOwnership(owner_);
32     }
33 
34     modifier onlyOwner() {
35         _checkOwner();
36         _;
37     }
38 
39     function owner() public view virtual returns (address) {
40         return _owner;
41     }
42 
43     function _checkOwner() internal view virtual {
44         require(owner() == msg.sender, "Ownable: caller is not the owner");
45     }
46 
47     function renounceOwnership() public virtual onlyOwner {
48         _transferOwnership(address(0));
49     }
50 
51     function transferOwnership(address newOwner) public virtual onlyOwner {
52         require(newOwner != address(0), "Ownable: new owner is the zero address");
53         _transferOwnership(newOwner);
54     }
55 
56     function _transferOwnership(address newOwner) internal virtual {
57         address oldOwner = _owner;
58         _owner = newOwner;
59         emit OwnershipTransferred(oldOwner, newOwner);
60     }
61 }
62 
63 interface IXchangeFactory {
64     function isFailsafeLiquidator(address) external view returns (bool);
65     function getPair(address tokenA, address tokenB) external view returns (address pair);
66     function createPair(address tokenA, address tokenB) external returns (address pair);
67 }
68 
69 interface IXchangePair {
70     function transferFrom(address from, address to, uint value) external returns (bool);
71     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
72     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
73     function mint(address to) external returns (uint liquidity);
74     function burn(address to) external returns (uint amount0, uint amount1);
75     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
76     function mustBurn(address to, uint256 gasAmount) external returns (uint256 amount0, uint256 amount1);
77 }
78 
79 interface IXchangeRouter {
80     function factory() external view returns (address);
81 
82     function WETH() external view returns (address);
83 
84     function addLiquidity(
85         address tokenA,
86         address tokenB,
87         uint amountADesired,
88         uint amountBDesired,
89         uint amountAMin,
90         uint amountBMin,
91         address to,
92         uint deadline
93     ) external returns (uint amountA, uint amountB, uint liquidity);
94 
95     function addLiquidityETH(
96         address token,
97         uint amountTokenDesired,
98         uint amountTokenMin,
99         uint amountETHMin,
100         address to,
101         uint deadline
102     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
103 
104     function removeLiquidity(
105         address tokenA,
106         address tokenB,
107         uint liquidity,
108         uint amountAMin,
109         uint amountBMin,
110         address to,
111         uint deadline
112     ) external returns (uint amountA, uint amountB);
113 
114     function mustRemoveLiquidity(
115         address tokenA,
116         address tokenB,
117         uint liquidity,
118         uint amountAMin,
119         uint amountBMin,
120         address to,
121         uint deadline,
122         uint gasAmount
123     ) external returns (uint amountA, uint amountB);
124 
125     function removeLiquidityETH(
126         address token,
127         uint liquidity,
128         uint amountTokenMin,
129         uint amountETHMin,
130         address to,
131         uint deadline
132     ) external returns (uint amountToken, uint amountETH);
133 
134     function removeLiquidityWithPermit(
135         address tokenA,
136         address tokenB,
137         uint liquidity,
138         uint amountAMin,
139         uint amountBMin,
140         address to,
141         uint deadline,
142         bool approveMax, uint8 v, bytes32 r, bytes32 s
143     ) external returns (uint amountA, uint amountB);
144 
145     function removeLiquidityETHWithPermit(
146         address token,
147         uint liquidity,
148         uint amountTokenMin,
149         uint amountETHMin,
150         address to,
151         uint deadline,
152         bool approveMax, uint8 v, bytes32 r, bytes32 s
153     ) external returns (uint amountToken, uint amountETH);
154 
155     function swapExactTokensForTokens(
156         uint amountIn,
157         uint amountOutMin,
158         address[] calldata path,
159         address to,
160         uint deadline
161     ) external returns (uint[] memory amounts);
162 
163     function swapTokensForExactTokens(
164         uint amountOut,
165         uint amountInMax,
166         address[] calldata path,
167         address to,
168         uint deadline
169     ) external returns (uint[] memory amounts);
170 
171     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
172     external
173     payable
174     returns (uint[] memory amounts);
175 
176     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
177     external
178     returns (uint[] memory amounts);
179 
180     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
181     external
182     returns (uint[] memory amounts);
183 
184     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
185     external
186     payable
187     returns (uint[] memory amounts);
188 
189     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
190 
191     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
192 
193     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
194 
195     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
196 
197     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
198 
199     function removeLiquidityETHSupportingFeeOnTransferTokens(
200         address token,
201         uint liquidity,
202         uint amountTokenMin,
203         uint amountETHMin,
204         address to,
205         uint deadline
206     ) external returns (uint amountETH);
207 
208     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
209         address token,
210         uint liquidity,
211         uint amountTokenMin,
212         uint amountETHMin,
213         address to,
214         uint deadline,
215         bool approveMax, uint8 v, bytes32 r, bytes32 s
216     ) external returns (uint amountETH);
217 
218     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
219         uint amountIn,
220         uint amountOutMin,
221         address[] calldata path,
222         address to,
223         uint deadline
224     ) external;
225 
226     function swapExactETHForTokensSupportingFeeOnTransferTokens(
227         uint amountOutMin,
228         address[] calldata path,
229         address to,
230         uint deadline
231     ) external payable;
232 
233     function swapExactTokensForETHSupportingFeeOnTransferTokens(
234         uint amountIn,
235         uint amountOutMin,
236         address[] calldata path,
237         address to,
238         uint deadline
239     ) external;
240 }
241 
242 interface IERC20 {
243     function balanceOf(address owner) external view returns (uint);
244 }
245 
246 interface IWETH {
247     function deposit() external payable;
248     function transfer(address to, uint value) external returns (bool);
249     function withdraw(uint) external;
250 }
251 
252 interface IXchangeDiscountAuthority {
253     function fee(address) external view returns (uint256);
254 }
255 
256 contract XchangeRouter is IXchangeRouter, Ownable {
257     address public immutable override factory;
258     address public immutable override WETH;
259 
260     modifier ensure(uint deadline) {
261         require(deadline >= block.timestamp, 'Xchange: EXPIRED');
262         _;
263     }
264 
265     constructor(address _factory, address _WETH) Ownable(msg.sender) {
266         factory = _factory;
267         WETH = _WETH;
268     }
269 
270     receive() external payable {
271         require(msg.sender == WETH);
272         // only accept ETH via fallback from the WETH contract
273     }
274 
275     function quote(uint amountA, uint reserveA, uint reserveB) public pure virtual override returns (uint amountB) {
276         return XchangeLibrary.quote(amountA, reserveA, reserveB);
277     }
278 
279     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut)
280     public
281     pure
282     virtual
283     override
284     returns (uint amountOut)
285     {
286         return XchangeLibrary.getAmountOut(amountIn, reserveIn, reserveOut, 20);
287     }
288 
289     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut)
290     public
291     pure
292     virtual
293     override
294     returns (uint amountIn)
295     {
296         return XchangeLibrary.getAmountIn(amountOut, reserveIn, reserveOut, 20);
297     }
298 
299     function getAmountsOut(uint amountIn, address[] memory path)
300     public
301     view
302     virtual
303     override
304     returns (uint[] memory amounts)
305     {
306         return XchangeLibrary.getAmountsOut(factory, amountIn, 20, path);
307     }
308 
309     function getAmountsIn(uint amountOut, address[] memory path)
310     public
311     view
312     virtual
313     override
314     returns (uint[] memory amounts)
315     {
316         return XchangeLibrary.getAmountsIn(factory, amountOut, 20, path);
317     }
318 
319     function addLiquidity(
320         address tokenA,
321         address tokenB,
322         uint amountADesired,
323         uint amountBDesired,
324         uint amountAMin,
325         uint amountBMin,
326         address to,
327         uint deadline
328     ) external virtual override ensure(deadline) returns (uint amountA, uint amountB, uint liquidity) {
329         (amountA, amountB) = _addLiquidity(tokenA, tokenB, amountADesired, amountBDesired, amountAMin, amountBMin);
330         address pair = XchangeLibrary.pairFor(factory, tokenA, tokenB);
331         TransferHelper.safeTransferFrom(tokenA, msg.sender, pair, amountA);
332         TransferHelper.safeTransferFrom(tokenB, msg.sender, pair, amountB);
333         liquidity = IXchangePair(pair).mint(to);
334     }
335 
336     function addLiquidityETH(
337         address token,
338         uint amountTokenDesired,
339         uint amountTokenMin,
340         uint amountETHMin,
341         address to,
342         uint deadline
343     ) external virtual override payable ensure(deadline) returns (uint amountToken, uint amountETH, uint liquidity) {
344         (amountToken, amountETH) = _addLiquidity(
345             token,
346             WETH,
347             amountTokenDesired,
348             msg.value,
349             amountTokenMin,
350             amountETHMin
351         );
352         address pair = XchangeLibrary.pairFor(factory, token, WETH);
353         TransferHelper.safeTransferFrom(token, msg.sender, pair, amountToken);
354         IWETH(WETH).deposit{value : amountETH}();
355         assert(IWETH(WETH).transfer(pair, amountETH));
356         liquidity = IXchangePair(pair).mint(to);
357         // refund dust eth, if any
358         if (msg.value > amountETH) TransferHelper.safeTransferETH(msg.sender, msg.value - amountETH);
359     }
360 
361     // **** REMOVE LIQUIDITY ****
362     function removeLiquidity(
363         address tokenA,
364         address tokenB,
365         uint liquidity,
366         uint amountAMin,
367         uint amountBMin,
368         address to,
369         uint deadline
370     ) public virtual override ensure(deadline) returns (uint amountA, uint amountB) {
371         address pair = XchangeLibrary.pairFor(factory, tokenA, tokenB);
372         IXchangePair(pair).transferFrom(msg.sender, pair, liquidity);
373         // send liquidity to pair
374         (uint amount0, uint amount1) = IXchangePair(pair).burn(to);
375         (address token0,) = XchangeLibrary.sortTokens(tokenA, tokenB);
376         (amountA, amountB) = tokenA == token0 ? (amount0, amount1) : (amount1, amount0);
377         require(amountA >= amountAMin, 'Xchange: INSUFFICIENT_A_AMOUNT');
378         require(amountB >= amountBMin, 'Xchange: INSUFFICIENT_B_AMOUNT');
379     }
380 
381     function mustRemoveLiquidity(
382         address tokenA,
383         address tokenB,
384         uint liquidity,
385         uint amountAMin,
386         uint amountBMin,
387         address to,
388         uint deadline,
389         uint gasAmount
390     ) public virtual override ensure(deadline) returns (uint amountA, uint amountB) {
391         require(IXchangeFactory(factory).isFailsafeLiquidator(msg.sender));
392         address pair = XchangeLibrary.pairFor(factory, tokenA, tokenB);
393 
394         // send liquidity to pair
395         IXchangePair(pair).transferFrom(msg.sender, pair, liquidity);
396 
397         // call the modified "mustBurn" function to ensure no token behavior can
398         // prevent this call from succeeding
399         (uint amount0, uint amount1) = IXchangePair(pair).mustBurn(to, gasAmount);
400         (address token0,) = XchangeLibrary.sortTokens(tokenA, tokenB);
401         (amountA, amountB) = tokenA == token0 ? (amount0, amount1) : (amount1, amount0);
402         require(amountA >= amountAMin, 'Xchange: INSUFFICIENT_A_AMOUNT');
403         require(amountB >= amountBMin, 'Xchange: INSUFFICIENT_B_AMOUNT');
404     }
405 
406     function removeLiquidityETH(
407         address token,
408         uint liquidity,
409         uint amountTokenMin,
410         uint amountETHMin,
411         address to,
412         uint deadline
413     ) public virtual override ensure(deadline) returns (uint amountToken, uint amountETH) {
414         (amountToken, amountETH) = removeLiquidity(
415             token,
416             WETH,
417             liquidity,
418             amountTokenMin,
419             amountETHMin,
420             address(this),
421             deadline
422         );
423         TransferHelper.safeTransfer(token, to, amountToken);
424         IWETH(WETH).withdraw(amountETH);
425         TransferHelper.safeTransferETH(to, amountETH);
426     }
427 
428     function removeLiquidityWithPermit(
429         address tokenA,
430         address tokenB,
431         uint liquidity,
432         uint amountAMin,
433         uint amountBMin,
434         address to,
435         uint deadline,
436         bool approveMax, uint8 v, bytes32 r, bytes32 s
437     ) external virtual override returns (uint amountA, uint amountB) {
438         address pair = XchangeLibrary.pairFor(factory, tokenA, tokenB);
439         uint value = approveMax ? type(uint256).max : liquidity;
440         IXchangePair(pair).permit(msg.sender, address(this), value, deadline, v, r, s);
441         (amountA, amountB) = removeLiquidity(tokenA, tokenB, liquidity, amountAMin, amountBMin, to, deadline);
442     }
443 
444     function removeLiquidityETHWithPermit(
445         address token,
446         uint liquidity,
447         uint amountTokenMin,
448         uint amountETHMin,
449         address to,
450         uint deadline,
451         bool approveMax, uint8 v, bytes32 r, bytes32 s
452     ) external virtual override returns (uint amountToken, uint amountETH) {
453         address pair = XchangeLibrary.pairFor(factory, token, WETH);
454         uint value = approveMax ? type(uint256).max : liquidity;
455         IXchangePair(pair).permit(msg.sender, address(this), value, deadline, v, r, s);
456         (amountToken, amountETH) = removeLiquidityETH(token, liquidity, amountTokenMin, amountETHMin, to, deadline);
457     }
458 
459     // **** REMOVE LIQUIDITY (supporting fee-on-transfer tokens) ****
460     function removeLiquidityETHSupportingFeeOnTransferTokens(
461         address token,
462         uint liquidity,
463         uint amountTokenMin,
464         uint amountETHMin,
465         address to,
466         uint deadline
467     ) public virtual override ensure(deadline) returns (uint amountETH) {
468         (, amountETH) = removeLiquidity(
469             token,
470             WETH,
471             liquidity,
472             amountTokenMin,
473             amountETHMin,
474             address(this),
475             deadline
476         );
477         TransferHelper.safeTransfer(token, to, IERC20(token).balanceOf(address(this)));
478         IWETH(WETH).withdraw(amountETH);
479         TransferHelper.safeTransferETH(to, amountETH);
480     }
481 
482     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
483         address token,
484         uint liquidity,
485         uint amountTokenMin,
486         uint amountETHMin,
487         address to,
488         uint deadline,
489         bool approveMax, uint8 v, bytes32 r, bytes32 s
490     ) external virtual override returns (uint amountETH) {
491         address pair = XchangeLibrary.pairFor(factory, token, WETH);
492         uint value = approveMax ? type(uint256).max : liquidity;
493         IXchangePair(pair).permit(msg.sender, address(this), value, deadline, v, r, s);
494         amountETH = removeLiquidityETHSupportingFeeOnTransferTokens(
495             token, liquidity, amountTokenMin, amountETHMin, to, deadline
496         );
497     }
498 
499     function swapExactTokensForTokens(
500         uint amountIn,
501         uint amountOutMin,
502         address[] calldata path,
503         address to,
504         uint deadline
505     ) external virtual override ensure(deadline) returns (uint[] memory amounts) {
506         amounts = XchangeLibrary.getAmountsOut(factory, amountIn, 20, path);
507         require(amounts[amounts.length - 1] >= amountOutMin, 'Xchange: INSUFFICIENT_OUTPUT_AMOUNT');
508         TransferHelper.safeTransferFrom(
509             path[0], msg.sender, XchangeLibrary.pairFor(factory, path[0], path[1]), amounts[0]
510         );
511         _swap(amounts, path, to);
512     }
513 
514     function swapTokensForExactTokens(
515         uint amountOut,
516         uint amountInMax,
517         address[] calldata path,
518         address to,
519         uint deadline
520     ) external virtual override ensure(deadline) returns (uint[] memory amounts) {
521         amounts = XchangeLibrary.getAmountsIn(factory, amountOut, 20, path);
522         require(amounts[0] <= amountInMax, 'Xchange: EXCESSIVE_INPUT_AMOUNT');
523         TransferHelper.safeTransferFrom(
524             path[0], msg.sender, XchangeLibrary.pairFor(factory, path[0], path[1]), amounts[0]
525         );
526         _swap(amounts, path, to);
527     }
528 
529     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
530     external
531     virtual
532     override
533     payable
534     ensure(deadline)
535     returns (uint[] memory amounts)
536     {
537         require(path[0] == WETH, 'Xchange: INVALID_PATH');
538         amounts = XchangeLibrary.getAmountsOut(factory, msg.value, 20, path);
539         require(amounts[amounts.length - 1] >= amountOutMin, 'Xchange: INSUFFICIENT_OUTPUT_AMOUNT');
540         IWETH(WETH).deposit{value : amounts[0]}();
541         assert(IWETH(WETH).transfer(XchangeLibrary.pairFor(factory, path[0], path[1]), amounts[0]));
542         _swap(amounts, path, to);
543     }
544 
545     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
546     external
547     virtual
548     override
549     ensure(deadline)
550     returns (uint[] memory amounts)
551     {
552         require(path[path.length - 1] == WETH, 'Xchange: INVALID_PATH');
553         amounts = XchangeLibrary.getAmountsIn(factory, amountOut, 20, path);
554         require(amounts[0] <= amountInMax, 'Xchange: EXCESSIVE_INPUT_AMOUNT');
555         TransferHelper.safeTransferFrom(
556             path[0], msg.sender, XchangeLibrary.pairFor(factory, path[0], path[1]), amounts[0]
557         );
558         _swap(amounts, path, address(this));
559         IWETH(WETH).withdraw(amounts[amounts.length - 1]);
560         TransferHelper.safeTransferETH(to, amounts[amounts.length - 1]);
561     }
562 
563     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
564     external
565     virtual
566     override
567     ensure(deadline)
568     returns (uint[] memory amounts)
569     {
570         require(path[path.length - 1] == WETH, 'Xchange: INVALID_PATH');
571         amounts = XchangeLibrary.getAmountsOut(factory, amountIn, 20, path);
572         require(amounts[amounts.length - 1] >= amountOutMin, 'Xchange: INSUFFICIENT_OUTPUT_AMOUNT');
573         TransferHelper.safeTransferFrom(
574             path[0], msg.sender, XchangeLibrary.pairFor(factory, path[0], path[1]), amounts[0]
575         );
576         _swap(amounts, path, address(this));
577         IWETH(WETH).withdraw(amounts[amounts.length - 1]);
578         TransferHelper.safeTransferETH(to, amounts[amounts.length - 1]);
579     }
580 
581     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
582     external
583     virtual
584     override
585     payable
586     ensure(deadline)
587     returns (uint[] memory amounts)
588     {
589         require(path[0] == WETH, 'Xchange: INVALID_PATH');
590         amounts = XchangeLibrary.getAmountsIn(factory, amountOut, 20, path);
591         require(amounts[0] <= msg.value, 'Xchange: EXCESSIVE_INPUT_AMOUNT');
592         IWETH(WETH).deposit{value : amounts[0]}();
593         assert(IWETH(WETH).transfer(XchangeLibrary.pairFor(factory, path[0], path[1]), amounts[0]));
594         _swap(amounts, path, to);
595         // refund dust eth, if any
596         if (msg.value > amounts[0]) TransferHelper.safeTransferETH(msg.sender, msg.value - amounts[0]);
597     }
598 
599     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
600         uint amountIn,
601         uint amountOutMin,
602         address[] calldata path,
603         address to,
604         uint deadline
605     ) external virtual override ensure(deadline) {
606         TransferHelper.safeTransferFrom(
607             path[0], msg.sender, XchangeLibrary.pairFor(factory, path[0], path[1]), amountIn
608         );
609         uint balanceBefore = IERC20(path[path.length - 1]).balanceOf(to);
610         _swapSupportingFeeOnTransferTokens(path, to);
611         require(
612             IERC20(path[path.length - 1]).balanceOf(to) - balanceBefore >= amountOutMin,
613             'Xchange: INSUFFICIENT_OUTPUT_AMOUNT'
614         );
615     }
616 
617     function swapExactETHForTokensSupportingFeeOnTransferTokens(
618         uint amountOutMin,
619         address[] calldata path,
620         address to,
621         uint deadline
622     )
623     external
624     virtual
625     override
626     payable
627     ensure(deadline)
628     {
629         require(path[0] == WETH, 'Xchange: INVALID_PATH');
630         uint amountIn = msg.value;
631         IWETH(WETH).deposit{value : amountIn}();
632         assert(IWETH(WETH).transfer(XchangeLibrary.pairFor(factory, path[0], path[1]), amountIn));
633         uint balanceBefore = IERC20(path[path.length - 1]).balanceOf(to);
634         _swapSupportingFeeOnTransferTokens(path, to);
635         require(
636             IERC20(path[path.length - 1]).balanceOf(to) - balanceBefore >= amountOutMin,
637             'Xchange: INSUFFICIENT_OUTPUT_AMOUNT'
638         );
639     }
640 
641     function swapExactTokensForETHSupportingFeeOnTransferTokens(
642         uint amountIn,
643         uint amountOutMin,
644         address[] calldata path,
645         address to,
646         uint deadline
647     )
648     external
649     virtual
650     override
651     ensure(deadline)
652     {
653         require(path[path.length - 1] == WETH, 'Xchange: INVALID_PATH');
654         TransferHelper.safeTransferFrom(
655             path[0], msg.sender, XchangeLibrary.pairFor(factory, path[0], path[1]), amountIn
656         );
657         _swapSupportingFeeOnTransferTokens(path, address(this));
658         uint amountOut = IERC20(WETH).balanceOf(address(this));
659         require(amountOut >= amountOutMin, 'Xchange: INSUFFICIENT_OUTPUT_AMOUNT');
660         IWETH(WETH).withdraw(amountOut);
661         TransferHelper.safeTransferETH(to, amountOut);
662     }
663 
664     // **** ADD LIQUIDITY ****
665     function _addLiquidity(
666         address tokenA,
667         address tokenB,
668         uint amountADesired,
669         uint amountBDesired,
670         uint amountAMin,
671         uint amountBMin
672     ) internal virtual returns (uint amountA, uint amountB) {
673         // create the pair if it doesn't exist yet
674         if (IXchangeFactory(factory).getPair(tokenA, tokenB) == address(0)) {
675             IXchangeFactory(factory).createPair(tokenA, tokenB);
676         }
677         (uint reserveA, uint reserveB) = XchangeLibrary.getReserves(factory, tokenA, tokenB);
678         if (reserveA == 0 && reserveB == 0) {
679             (amountA, amountB) = (amountADesired, amountBDesired);
680         } else {
681             uint amountBOptimal = XchangeLibrary.quote(amountADesired, reserveA, reserveB);
682             if (amountBOptimal <= amountBDesired) {
683                 require(amountBOptimal >= amountBMin, 'Xchange: INSUFFICIENT_B_AMOUNT');
684                 (amountA, amountB) = (amountADesired, amountBOptimal);
685             } else {
686                 uint amountAOptimal = XchangeLibrary.quote(amountBDesired, reserveB, reserveA);
687                 assert(amountAOptimal <= amountADesired);
688                 require(amountAOptimal >= amountAMin, 'Xchange: INSUFFICIENT_A_AMOUNT');
689                 (amountA, amountB) = (amountAOptimal, amountBDesired);
690             }
691         }
692     }
693 
694     // **** SWAP ****
695     // requires the initial amount to have already been sent to the first pair
696     function _swap(uint[] memory amounts, address[] memory path, address _to) internal virtual {
697         for (uint i; i < path.length - 1; i++) {
698             (address input, address output) = (path[i], path[i + 1]);
699             (address token0,) = XchangeLibrary.sortTokens(input, output);
700             uint amountOut = amounts[i + 1];
701             (uint amount0Out, uint amount1Out) = input == token0 ? (uint(0), amountOut) : (amountOut, uint(0));
702             address to = i < path.length - 2 ? XchangeLibrary.pairFor(factory, output, path[i + 2]) : _to;
703             IXchangePair(XchangeLibrary.pairFor(factory, input, output)).swap(
704                 amount0Out, amount1Out, to, new bytes(0)
705             );
706         }
707     }
708 
709     // **** SWAP (supporting fee-on-transfer tokens) ****
710     // requires the initial amount to have already been sent to the first pair
711     function _swapSupportingFeeOnTransferTokens(address[] memory path, address _to) internal virtual {
712         for (uint i; i < path.length - 1; i++) {
713             (address input, address output) = (path[i], path[i + 1]);
714             (address token0,) = XchangeLibrary.sortTokens(input, output);
715             IXchangePair pair = IXchangePair(XchangeLibrary.pairFor(factory, input, output));
716             uint amountInput;
717             uint amountOutput;
718             {// scope to avoid stack too deep errors
719                 (uint reserve0, uint reserve1,) = pair.getReserves();
720                 (uint reserveInput, uint reserveOutput) = input == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
721                 amountInput = IERC20(input).balanceOf(address(pair)) - reserveInput;
722                 amountOutput = XchangeLibrary.getAmountOut(amountInput, reserveInput, reserveOutput, 20);
723             }
724             (uint amount0Out, uint amount1Out) = input == token0 ? (uint(0), amountOutput) : (amountOutput, uint(0));
725             address to = i < path.length - 2 ? XchangeLibrary.pairFor(factory, output, path[i + 2]) : _to;
726             pair.swap(amount0Out, amount1Out, to, new bytes(0));
727         }
728     }
729 }
730 
731 library XchangeLibrary {
732 
733     // returns sorted token addresses, used to handle return values from pairs sorted in this order
734     function sortTokens(address tokenA, address tokenB) internal pure returns (address token0, address token1) {
735         require(tokenA != tokenB, 'XchangeLibrary: IDENTICAL_ADDRESSES');
736         (token0, token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
737         require(token0 != address(0), 'XchangeLibrary: ZERO_ADDRESS');
738     }
739 
740     // calculates the CREATE2 address for a pair without making any external calls
741     function pairFor(address factory, address tokenA, address tokenB) internal pure returns (address pair) {
742         (address token0, address token1) = sortTokens(tokenA, tokenB);
743         pair = address(uint160(uint(keccak256(abi.encodePacked(
744                 hex'ff',
745                 factory,
746                 keccak256(abi.encodePacked(token0, token1)),
747                 hex'8ef3e731dfb0265c5b89d4d1ef69c1d448b1335eb48d76cb6df26c198f75bc68' // init code hash
748             )))));
749     }
750 
751     // fetches and sorts the reserves for a pair
752     function getReserves(address factory, address tokenA, address tokenB) internal view returns (uint reserveA, uint reserveB) {
753         (address token0,) = sortTokens(tokenA, tokenB);
754         (uint reserve0, uint reserve1,) = IXchangePair(pairFor(factory, tokenA, tokenB)).getReserves();
755         (reserveA, reserveB) = tokenA == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
756     }
757 
758     // given some amount of an asset and pair reserves, returns an equivalent amount of the other asset
759     function quote(uint amountA, uint reserveA, uint reserveB) internal pure returns (uint amountB) {
760         require(amountA > 0, 'XchangeLibrary: INSUFFICIENT_AMOUNT');
761         require(reserveA > 0 && reserveB > 0, 'XchangeLibrary: INSUFFICIENT_LIQUIDITY');
762         amountB = amountA * reserveB / reserveA;
763     }
764 
765     // given an input amount of an asset and pair reserves, returns the maximum output amount of the other asset
766     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut, uint feeAmount) internal pure returns (uint amountOut) {
767         require(amountIn > 0, 'XchangeLibrary: INSUFFICIENT_INPUT_AMOUNT');
768         require(reserveIn > 0 && reserveOut > 0, 'XchangeLibrary: INSUFFICIENT_LIQUIDITY');
769         require(feeAmount <= 20, 'XchangeLibrary: EXCESSIVE_FEE');
770         uint amountInWithFee = amountIn * (10000 - feeAmount);
771         uint numerator = amountInWithFee * reserveOut;
772         uint denominator = (reserveIn * 10000) + amountInWithFee;
773         amountOut = numerator / denominator;
774     }
775 
776     // given an output amount of an asset and pair reserves, returns a required input amount of the other asset
777     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut, uint feeAmount) internal pure returns (uint amountIn) {
778         require(amountOut > 0, 'XchangeLibrary: INSUFFICIENT_OUTPUT_AMOUNT');
779         require(reserveIn > 0 && reserveOut > 0, 'XchangeLibrary: INSUFFICIENT_LIQUIDITY');
780         require(feeAmount <= 20, 'XchangeLibrary: EXCESSIVE_FEE');
781         uint numerator = reserveIn * (10000 - feeAmount);
782         uint denominator = (reserveOut - amountOut) * (10000 - feeAmount);
783         amountIn = (numerator / denominator) + 1;
784     }
785 
786     // performs chained getAmountOut calculations on any number of pairs
787     function getAmountsOut(address factory, uint amountIn, uint feeAmount, address[] memory path) internal view returns (uint[] memory amounts) {
788         require(path.length >= 2, 'XchangeLibrary: INVALID_PATH');
789         amounts = new uint[](path.length);
790         amounts[0] = amountIn;
791         for (uint i; i < path.length - 1; i++) {
792             (uint reserveIn, uint reserveOut) = getReserves(factory, path[i], path[i + 1]);
793             amounts[i + 1] = getAmountOut(amounts[i], reserveIn, reserveOut, feeAmount);
794         }
795     }
796 
797     // performs chained getAmountIn calculations on any number of pairs
798     function getAmountsIn(address factory, uint amountOut, uint feeAmount, address[] memory path) internal view returns (uint[] memory amounts) {
799         require(path.length >= 2, 'XchangeLibrary: INVALID_PATH');
800         amounts = new uint[](path.length);
801         amounts[amounts.length - 1] = amountOut;
802         for (uint i = path.length - 1; i > 0; i--) {
803             (uint reserveIn, uint reserveOut) = getReserves(factory, path[i - 1], path[i]);
804             amounts[i - 1] = getAmountIn(amounts[i], reserveIn, reserveOut, feeAmount);
805         }
806     }
807 }
808 
809 // helper methods for interacting with ERC20 tokens and sending ETH that do not consistently return true/false
810 library TransferHelper {
811 
812     function safeTransfer(address token, address to, uint value) internal {
813         // bytes4(keccak256(bytes('transfer(address,uint256)')));
814         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));
815         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FAILED');
816     }
817 
818     function safeTransferFrom(address token, address from, address to, uint value) internal {
819         // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
820         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));
821         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FROM_FAILED');
822     }
823 
824     function safeTransferETH(address to, uint value) internal {
825         (bool success,) = to.call{value : value}(new bytes(0));
826         require(success, 'TransferHelper: ETH_TRANSFER_FAILED');
827     }
828 }