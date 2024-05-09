1 /**
2  *Submitted for verification at Etherscan.io on 2021-04-30
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2020-06-05
7 */
8 
9 pragma solidity =0.6.6;
10 
11 interface IUniswapV2Factory {
12     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
13 
14     function feeTo() external view returns (address);
15     function feeToSetter() external view returns (address);
16 
17     function getPair(address tokenA, address tokenB) external view returns (address pair);
18     function permissions(address user) external view returns (bool status);
19     function allPairs(uint) external view returns (address pair);
20     function allPairsLength() external view returns (uint);
21 
22     function createPair(address tokenA, address tokenB, address feeOwner) external returns (address pair);
23 
24     function setFeeTo(address) external;
25     function setFeeToSetter(address) external;
26 }
27 
28 interface IUniswapV2Pair {
29     event Approval(address indexed owner, address indexed spender, uint value);
30     event Transfer(address indexed from, address indexed to, uint value);
31 
32     function name() external pure returns (string memory);
33     function symbol() external pure returns (string memory);
34     function decimals() external pure returns (uint8);
35     function totalSupply() external view returns (uint);
36     function balanceOf(address owner) external view returns (uint);
37     function allowance(address owner, address spender) external view returns (uint);
38     function feeOwner() external view returns (address);
39 
40     function approve(address spender, uint value) external returns (bool);
41     function transfer(address to, uint value) external returns (bool);
42     function transferFrom(address from, address to, uint value) external returns (bool);
43 
44     function DOMAIN_SEPARATOR() external view returns (bytes32);
45     function PERMIT_TYPEHASH() external pure returns (bytes32);
46     function nonces(address owner) external view returns (uint);
47 
48     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
49 
50     event Mint(address indexed sender, uint amount0, uint amount1);
51     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
52     event Swap(
53         address indexed sender,
54         uint amount0In,
55         uint amount1In,
56         uint amount0Out,
57         uint amount1Out,
58         address indexed to
59     );
60     event Sync(uint112 reserve0, uint112 reserve1);
61 
62     function MINIMUM_LIQUIDITY() external pure returns (uint);
63     function factory() external view returns (address);
64     function token0() external view returns (address);
65     function token1() external view returns (address);
66     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
67     function price0CumulativeLast() external view returns (uint);
68     function price1CumulativeLast() external view returns (uint);
69     function kLast() external view returns (uint);
70 
71     function mint(address to) external returns (uint liquidity);
72     function burn(address to) external returns (uint amount0, uint amount1);
73     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
74     function skim(address to) external;
75     function sync() external;
76 
77     function initialize(address, address) external;
78 }
79 
80 interface IUniswapV2Router01 {
81     function factory() external pure returns (address);
82     function WETH() external pure returns (address);
83 
84     function addLiquidity(
85         address tokenA,
86         address tokenB,
87         uint amountADesired,
88         uint amountBDesired,
89         uint amountAMin,
90         uint amountBMin,
91         address to,
92         uint deadline,
93         address feeOwner
94     ) external returns (uint amountA, uint amountB, uint liquidity);
95     function addLiquidityETH(
96         address token,
97         uint amountTokenDesired,
98         uint amountTokenMin,
99         uint amountETHMin,
100         address to,
101         uint deadline,
102         address feeOwner
103     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
104     function removeLiquidity(
105         address tokenA,
106         address tokenB,
107         uint liquidity,
108         uint amountAMin,
109         uint amountBMin,
110         address to,
111         uint deadline
112     ) external returns (uint amountA, uint amountB);
113     function removeLiquidityETH(
114         address token,
115         uint liquidity,
116         uint amountTokenMin,
117         uint amountETHMin,
118         address to,
119         uint deadline
120     ) external returns (uint amountToken, uint amountETH);
121     function removeLiquidityWithPermit(
122         address tokenA,
123         address tokenB,
124         uint liquidity,
125         uint amountAMin,
126         uint amountBMin,
127         address to,
128         uint deadline,
129         bool approveMax, uint8 v, bytes32 r, bytes32 s
130     ) external returns (uint amountA, uint amountB);
131     function removeLiquidityETHWithPermit(
132         address token,
133         uint liquidity,
134         uint amountTokenMin,
135         uint amountETHMin,
136         address to,
137         uint deadline,
138         bool approveMax, uint8 v, bytes32 r, bytes32 s
139     ) external returns (uint amountToken, uint amountETH);
140     function swapExactTokensForTokens(
141         uint amountIn,
142         uint amountOutMin,
143         address[] calldata path,
144         address to,
145         uint deadline
146     ) external returns (uint[] memory amounts);
147     function swapTokensForExactTokens(
148         uint amountOut,
149         uint amountInMax,
150         address[] calldata path,
151         address to,
152         uint deadline
153     ) external returns (uint[] memory amounts);
154     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
155         external
156         payable
157         returns (uint[] memory amounts);
158     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
159         external
160         returns (uint[] memory amounts);
161     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
162         external
163         returns (uint[] memory amounts);
164     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
165         external
166         payable
167         returns (uint[] memory amounts);
168 
169     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
170     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
171     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
172     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
173     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
174 }
175 
176 interface IUniswapV2Router02 is IUniswapV2Router01 {
177     function removeLiquidityETHSupportingFeeOnTransferTokens(
178         address token,
179         uint liquidity,
180         uint amountTokenMin,
181         uint amountETHMin,
182         address to,
183         uint deadline
184     ) external returns (uint amountETH);
185     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
186         address token,
187         uint liquidity,
188         uint amountTokenMin,
189         uint amountETHMin,
190         address to,
191         uint deadline,
192         bool approveMax, uint8 v, bytes32 r, bytes32 s
193     ) external returns (uint amountETH);
194 
195     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
196         uint amountIn,
197         uint amountOutMin,
198         address[] calldata path,
199         address to,
200         uint deadline
201     ) external;
202     function swapExactETHForTokensSupportingFeeOnTransferTokens(
203         uint amountOutMin,
204         address[] calldata path,
205         address to,
206         uint deadline
207     ) external payable;
208     function swapExactTokensForETHSupportingFeeOnTransferTokens(
209         uint amountIn,
210         uint amountOutMin,
211         address[] calldata path,
212         address to,
213         uint deadline
214     ) external;
215 }
216 
217 interface IERC20 {
218     event Approval(address indexed owner, address indexed spender, uint value);
219     event Transfer(address indexed from, address indexed to, uint value);
220 
221     function name() external view returns (string memory);
222     function symbol() external view returns (string memory);
223     function decimals() external view returns (uint8);
224     function totalSupply() external view returns (uint);
225     function balanceOf(address owner) external view returns (uint);
226     function allowance(address owner, address spender) external view returns (uint);
227 
228     function approve(address spender, uint value) external returns (bool);
229     function transfer(address to, uint value) external returns (bool);
230     function transferFrom(address from, address to, uint value) external returns (bool);
231 }
232 
233 interface IWETH {
234     function deposit() external payable;
235     function transfer(address to, uint value) external returns (bool);
236     function withdraw(uint) external;
237 }
238 
239 
240 
241 contract UniswapV2Router02 is IUniswapV2Router02 {
242     using SafeMath for uint;
243 
244     address public immutable override factory;
245     address public immutable override WETH;
246 
247     modifier ensure(uint deadline) {
248         require(deadline >= block.timestamp, 'Crypto Mine Router: EXPIRED');
249         _;
250     }
251     
252     modifier authority(){
253         require(IUniswapV2Factory(factory).permissions(msg.sender),"Crypto Mine: access denied");
254         _;
255     }
256 
257     constructor(address _factory, address _WETH) public {
258         factory = _factory;
259         WETH = _WETH;
260     }
261 
262     receive() external payable {
263         assert(msg.sender == WETH); // only accept ETH via fallback from the WETH contract
264     }
265     
266 
267     // **** ADD LIQUIDITY ****
268     function _addLiquidity(
269         address tokenA,
270         address tokenB,
271         uint amountADesired,
272         uint amountBDesired,
273         uint amountAMin,
274         uint amountBMin,
275         address feeOwner
276     ) internal virtual authority returns (uint amountA, uint amountB) {
277         // create the pair if it doesn't exist yet
278         if (IUniswapV2Factory(factory).getPair(tokenA, tokenB) == address(0)) {
279             IUniswapV2Factory(factory).createPair(tokenA, tokenB,feeOwner);
280         }
281         (uint reserveA, uint reserveB) = UniswapV2Library.getReserves(factory, tokenA, tokenB);
282         if (reserveA == 0 && reserveB == 0) {
283             (amountA, amountB) = (amountADesired, amountBDesired);
284         } else {
285             uint amountBOptimal = UniswapV2Library.quote(amountADesired, reserveA, reserveB);
286             if (amountBOptimal <= amountBDesired) {
287                 require(amountBOptimal >= amountBMin, 'Crypto Mine Router: INSUFFICIENT_B_AMOUNT');
288                 (amountA, amountB) = (amountADesired, amountBOptimal);
289             } else {
290                 uint amountAOptimal = UniswapV2Library.quote(amountBDesired, reserveB, reserveA);
291                 assert(amountAOptimal <= amountADesired);
292                 require(amountAOptimal >= amountAMin, 'Crypto Mine Router: INSUFFICIENT_A_AMOUNT');
293                 (amountA, amountB) = (amountAOptimal, amountBDesired);
294             }
295         }
296     }
297     function addLiquidity(
298         address tokenA,
299         address tokenB,
300         uint amountADesired,
301         uint amountBDesired,
302         uint amountAMin,
303         uint amountBMin,
304         address to,
305         uint deadline,
306         address feeOwner
307     ) external virtual override ensure(deadline) returns (uint amountA, uint amountB, uint liquidity) {
308         (amountA, amountB) = _addLiquidity(tokenA, tokenB, amountADesired, amountBDesired, amountAMin, amountBMin, feeOwner);
309         address pair = UniswapV2Library.pairFor(factory, tokenA, tokenB);
310         TransferHelper.safeTransferFrom(tokenA, msg.sender, pair, amountA);
311         TransferHelper.safeTransferFrom(tokenB, msg.sender, pair, amountB);
312         liquidity = IUniswapV2Pair(pair).mint(to);
313     }
314     function addLiquidityETH(
315         address token,
316         uint amountTokenDesired,
317         uint amountTokenMin,
318         uint amountETHMin,
319         address to,
320         uint deadline,
321         address feeOwner
322     ) external virtual override payable ensure(deadline) returns (uint amountToken, uint amountETH, uint liquidity) {
323         (amountToken, amountETH) = _addLiquidity(
324             token,
325             WETH,
326             amountTokenDesired,
327             msg.value,
328             amountTokenMin,
329             amountETHMin,
330             feeOwner
331         );
332         address pair = UniswapV2Library.pairFor(factory, token, WETH);
333         TransferHelper.safeTransferFrom(token, msg.sender, pair, amountToken);
334         IWETH(WETH).deposit{value: amountETH}();
335         assert(IWETH(WETH).transfer(pair, amountETH));
336         liquidity = IUniswapV2Pair(pair).mint(to);
337         // refund dust eth, if any
338         if (msg.value > amountETH) TransferHelper.safeTransferETH(msg.sender, msg.value - amountETH);
339     }
340 
341     // **** REMOVE LIQUIDITY ****
342     function removeLiquidity(
343         address tokenA,
344         address tokenB,
345         uint liquidity,
346         uint amountAMin,
347         uint amountBMin,
348         address to,
349         uint deadline
350     ) public virtual override ensure(deadline) returns (uint amountA, uint amountB) {
351         address pair = UniswapV2Library.pairFor(factory, tokenA, tokenB);
352         IUniswapV2Pair(pair).transferFrom(msg.sender, pair, liquidity); // send liquidity to pair
353         (uint amount0, uint amount1) = IUniswapV2Pair(pair).burn(to);
354         (address token0,) = UniswapV2Library.sortTokens(tokenA, tokenB);
355         (amountA, amountB) = tokenA == token0 ? (amount0, amount1) : (amount1, amount0);
356         require(amountA >= amountAMin, 'Crypto Mine Router: INSUFFICIENT_A_AMOUNT');
357         require(amountB >= amountBMin, 'Crypto Mine Router: INSUFFICIENT_B_AMOUNT');
358     }
359     function removeLiquidityETH(
360         address token,
361         uint liquidity,
362         uint amountTokenMin,
363         uint amountETHMin,
364         address to,
365         uint deadline
366     ) public virtual override ensure(deadline) returns (uint amountToken, uint amountETH) {
367         (amountToken, amountETH) = removeLiquidity(
368             token,
369             WETH,
370             liquidity,
371             amountTokenMin,
372             amountETHMin,
373             address(this),
374             deadline
375         );
376         TransferHelper.safeTransfer(token, to, amountToken);
377         IWETH(WETH).withdraw(amountETH);
378         TransferHelper.safeTransferETH(to, amountETH);
379     }
380     function removeLiquidityWithPermit(
381         address tokenA,
382         address tokenB,
383         uint liquidity,
384         uint amountAMin,
385         uint amountBMin,
386         address to,
387         uint deadline,
388         bool approveMax, uint8 v, bytes32 r, bytes32 s
389     ) external virtual override returns (uint amountA, uint amountB) {
390         address pair = UniswapV2Library.pairFor(factory, tokenA, tokenB);
391         uint value = approveMax ? uint(-1) : liquidity;
392         IUniswapV2Pair(pair).permit(msg.sender, address(this), value, deadline, v, r, s);
393         (amountA, amountB) = removeLiquidity(tokenA, tokenB, liquidity, amountAMin, amountBMin, to, deadline);
394     }
395     function removeLiquidityETHWithPermit(
396         address token,
397         uint liquidity,
398         uint amountTokenMin,
399         uint amountETHMin,
400         address to,
401         uint deadline,
402         bool approveMax, uint8 v, bytes32 r, bytes32 s
403     ) external virtual override returns (uint amountToken, uint amountETH) {
404         address pair = UniswapV2Library.pairFor(factory, token, WETH);
405         uint value = approveMax ? uint(-1) : liquidity;
406         IUniswapV2Pair(pair).permit(msg.sender, address(this), value, deadline, v, r, s);
407         (amountToken, amountETH) = removeLiquidityETH(token, liquidity, amountTokenMin, amountETHMin, to, deadline);
408     }
409 
410     // **** REMOVE LIQUIDITY (supporting fee-on-transfer tokens) ****
411     function removeLiquidityETHSupportingFeeOnTransferTokens(
412         address token,
413         uint liquidity,
414         uint amountTokenMin,
415         uint amountETHMin,
416         address to,
417         uint deadline
418     ) public virtual override ensure(deadline) returns (uint amountETH) {
419         (, amountETH) = removeLiquidity(
420             token,
421             WETH,
422             liquidity,
423             amountTokenMin,
424             amountETHMin,
425             address(this),
426             deadline
427         );
428         TransferHelper.safeTransfer(token, to, IERC20(token).balanceOf(address(this)));
429         IWETH(WETH).withdraw(amountETH);
430         TransferHelper.safeTransferETH(to, amountETH);
431     }
432     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
433         address token,
434         uint liquidity,
435         uint amountTokenMin,
436         uint amountETHMin,
437         address to,
438         uint deadline,
439         bool approveMax, uint8 v, bytes32 r, bytes32 s
440     ) external virtual override returns (uint amountETH) {
441         address pair = UniswapV2Library.pairFor(factory, token, WETH);
442         uint value = approveMax ? uint(-1) : liquidity;
443         IUniswapV2Pair(pair).permit(msg.sender, address(this), value, deadline, v, r, s);
444         amountETH = removeLiquidityETHSupportingFeeOnTransferTokens(
445             token, liquidity, amountTokenMin, amountETHMin, to, deadline
446         );
447     }
448 
449     // **** SWAP ****
450     // requires the initial amount to have already been sent to the first pair
451     function _swap(uint[] memory amounts, address[] memory path, address _to) internal virtual {
452         for (uint i; i < path.length - 1; i++) {
453             (address input, address output) = (path[i], path[i + 1]);
454             (address token0,) = UniswapV2Library.sortTokens(input, output);
455             uint amountOut = amounts[i + 1];
456             (uint amount0Out, uint amount1Out) = input == token0 ? (uint(0), amountOut) : (amountOut, uint(0));
457             address to = i < path.length - 2 ? UniswapV2Library.pairFor(factory, output, path[i + 2]) : _to;
458             IUniswapV2Pair(UniswapV2Library.pairFor(factory, input, output)).swap(
459                 amount0Out, amount1Out, to, new bytes(0)
460             );
461         }
462     }
463 
464     function swapExactTokensForTokens(
465         uint amountIn,
466         uint amountOutMin,
467         address[] calldata path,
468         address to,
469         uint deadline
470     ) external virtual override ensure(deadline) returns (uint[] memory amounts) {
471         amounts = UniswapV2Library.getAmountsOut(factory, amountIn, path);
472         require(amounts[amounts.length - 1] >= amountOutMin, 'Crypto Mine Router: INSUFFICIENT_OUTPUT_AMOUNT');
473         
474         TransferHelper.safeTransferFrom(
475             path[0], msg.sender, UniswapV2Library.pairFor(factory, path[0], path[1]), amounts[0]
476         );
477 
478         _swap(amounts, path, to);
479     }
480     function swapTokensForExactTokens(
481         uint amountOut,
482         uint amountInMax,
483         address[] calldata path,
484         address to,
485         uint deadline
486     ) external virtual override ensure(deadline) returns (uint[] memory amounts) {
487         amounts = UniswapV2Library.getAmountsIn(factory, amountOut, path);
488         require(amounts[0] <= amountInMax, 'Crypto Mine Router: EXCESSIVE_INPUT_AMOUNT');
489         
490         TransferHelper.safeTransferFrom(
491             path[0], msg.sender, UniswapV2Library.pairFor(factory, path[0], path[1]), amounts[0]
492         );
493         
494         _swap(amounts, path, to);
495     }
496     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
497         external
498         virtual
499         override
500         payable
501         ensure(deadline)
502         returns (uint[] memory amounts)
503     {
504         require(path[0] == WETH, 'Crypto Mine Router: INVALID_PATH');
505         amounts = UniswapV2Library.getAmountsOut(factory, msg.value, path);
506         require(amounts[amounts.length - 1] >= amountOutMin, 'Crypto Mine Router: INSUFFICIENT_OUTPUT_AMOUNT');
507         IWETH(WETH).deposit{value: amounts[0]}();
508         IWETH(WETH).deposit{value: amounts[0]}();
509         _swap(amounts, path, to);
510     }
511     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
512         external
513         virtual
514         override
515         ensure(deadline)
516         returns (uint[] memory amounts)
517     {
518         require(path[path.length - 1] == WETH, 'Crypto Mine Router: INVALID_PATH');
519         amounts = UniswapV2Library.getAmountsIn(factory, amountOut, path);
520         require(amounts[0] <= amountInMax, 'Crypto Mine Router: EXCESSIVE_INPUT_AMOUNT');
521         
522         TransferHelper.safeTransferFrom(
523             path[0], msg.sender, UniswapV2Library.pairFor(factory, path[0], path[1]), amounts[0]
524         );
525         
526         _swap(amounts, path, address(this));
527         IWETH(WETH).withdraw(amounts[amounts.length - 1]);
528         TransferHelper.safeTransferETH(to, amounts[amounts.length - 1]);
529     }
530     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
531         external
532         virtual
533         override
534         ensure(deadline)
535         returns (uint[] memory amounts)
536     {
537         require(path[path.length - 1] == WETH, 'Crypto Mine Router: INVALID_PATH');
538         amounts = UniswapV2Library.getAmountsOut(factory, amountIn, path);
539         require(amounts[amounts.length - 1] >= amountOutMin, 'Crypto Mine Router: INSUFFICIENT_OUTPUT_AMOUNT');
540         TransferHelper.safeTransferFrom(
541             path[0], msg.sender, UniswapV2Library.pairFor(factory, path[0], path[1]), amounts[0]
542         );
543         _swap(amounts, path, address(this));
544         IWETH(WETH).withdraw(amounts[amounts.length - 1]);
545         TransferHelper.safeTransferETH(to, amounts[amounts.length - 1]);
546     }
547     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
548         external
549         virtual
550         override
551         payable
552         ensure(deadline)
553         returns (uint[] memory amounts)
554     {
555         require(path[0] == WETH, 'Crypto Mine Router: INVALID_PATH');
556         amounts = UniswapV2Library.getAmountsIn(factory, amountOut, path);
557         require(amounts[0] <= msg.value, 'Crypto Mine Router: EXCESSIVE_INPUT_AMOUNT');
558         IWETH(WETH).deposit{value: amounts[0]}();
559         assert(IWETH(WETH).transfer(UniswapV2Library.pairFor(factory, path[0], path[1]), amounts[0]));
560         _swap(amounts, path, to);
561         // refund dust eth, if any
562         if (msg.value > amounts[0]) TransferHelper.safeTransferETH(msg.sender, msg.value - amounts[0]);
563     }
564 
565     // **** SWAP (supporting fee-on-transfer tokens) ****
566     // requires the initial amount to have already been sent to the first pair
567     function _swapSupportingFeeOnTransferTokens(address[] memory path, address _to) internal virtual {
568         for (uint i; i < path.length - 1; i++) {
569             (address input, address output) = (path[i], path[i + 1]);
570             (address token0,) = UniswapV2Library.sortTokens(input, output);
571             IUniswapV2Pair pair = IUniswapV2Pair(UniswapV2Library.pairFor(factory, input, output));
572             uint amountInput;
573             uint amountOutput;
574             { // scope to avoid stack too deep errors
575             (uint reserve0, uint reserve1,) = pair.getReserves();
576             (uint reserveInput, uint reserveOutput) = input == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
577             amountInput = IERC20(input).balanceOf(address(pair)).sub(reserveInput);
578             amountOutput = UniswapV2Library.getAmountOut(amountInput, reserveInput, reserveOutput);
579             }
580             (uint amount0Out, uint amount1Out) = input == token0 ? (uint(0), amountOutput) : (amountOutput, uint(0));
581             address to = i < path.length - 2 ? UniswapV2Library.pairFor(factory, output, path[i + 2]) : _to;
582             pair.swap(amount0Out, amount1Out, to, new bytes(0));
583         }
584     }
585     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
586         uint amountIn,
587         uint amountOutMin,
588         address[] calldata path,
589         address to,
590         uint deadline
591     ) external virtual override ensure(deadline) {
592         TransferHelper.safeTransferFrom(
593             path[0], msg.sender, UniswapV2Library.pairFor(factory, path[0], path[1]), amountIn
594         );
595         uint balanceBefore = IERC20(path[path.length - 1]).balanceOf(to);
596         _swapSupportingFeeOnTransferTokens(path, to);
597         require(
598             IERC20(path[path.length - 1]).balanceOf(to).sub(balanceBefore) >= amountOutMin,
599             'Crypto Mine Router: INSUFFICIENT_OUTPUT_AMOUNT'
600         );
601     }
602     function swapExactETHForTokensSupportingFeeOnTransferTokens(
603         uint amountOutMin,
604         address[] calldata path,
605         address to,
606         uint deadline
607     )
608         external
609         virtual
610         override
611         payable
612         ensure(deadline)
613     {
614         require(path[0] == WETH, 'Crypto Mine Router: INVALID_PATH');
615         uint amountIn = msg.value;
616         IWETH(WETH).deposit{value: amountIn}();
617         assert(IWETH(WETH).transfer(UniswapV2Library.pairFor(factory, path[0], path[1]), amountIn));
618         uint balanceBefore = IERC20(path[path.length - 1]).balanceOf(to);
619         _swapSupportingFeeOnTransferTokens(path, to);
620         require(
621             IERC20(path[path.length - 1]).balanceOf(to).sub(balanceBefore) >= amountOutMin,
622             'Crypto Mine Router: INSUFFICIENT_OUTPUT_AMOUNT'
623         );
624     }
625     function swapExactTokensForETHSupportingFeeOnTransferTokens(
626         uint amountIn,
627         uint amountOutMin,
628         address[] calldata path,
629         address to,
630         uint deadline
631     )
632         external
633         virtual
634         override
635         ensure(deadline)
636     {
637         require(path[path.length - 1] == WETH, 'Crypto Mine Router: INVALID_PATH');
638         TransferHelper.safeTransferFrom(
639             path[0], msg.sender, UniswapV2Library.pairFor(factory, path[0], path[1]), amountIn
640         );
641         _swapSupportingFeeOnTransferTokens(path, address(this));
642         uint amountOut = IERC20(WETH).balanceOf(address(this));
643         require(amountOut >= amountOutMin, 'Crypto Mine Router: INSUFFICIENT_OUTPUT_AMOUNT');
644         IWETH(WETH).withdraw(amountOut);
645         TransferHelper.safeTransferETH(to, amountOut);
646     }
647 
648     // **** LIBRARY FUNCTIONS ****
649     function quote(uint amountA, uint reserveA, uint reserveB) public pure virtual override returns (uint amountB) {
650         return UniswapV2Library.quote(amountA, reserveA, reserveB);
651     }
652 
653     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut)
654         public
655         pure
656         virtual
657         override
658         returns (uint amountOut)
659     {
660         return UniswapV2Library.getAmountOut(amountIn, reserveIn, reserveOut);
661     }
662 
663     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut)
664         public
665         pure
666         virtual
667         override
668         returns (uint amountIn)
669     {
670         return UniswapV2Library.getAmountIn(amountOut, reserveIn, reserveOut);
671     }
672 
673     function getAmountsOut(uint amountIn, address[] memory path)
674         public
675         view
676         virtual
677         override
678         returns (uint[] memory amounts)
679     {
680         return UniswapV2Library.getAmountsOut(factory, amountIn, path);
681     }
682 
683     function getAmountsIn(uint amountOut, address[] memory path)
684         public
685         view
686         virtual
687         override
688         returns (uint[] memory amounts)
689     {
690         return UniswapV2Library.getAmountsIn(factory, amountOut, path);
691     }
692 }
693 
694 // a library for performing overflow-safe math, courtesy of DappHub (https://github.com/dapphub/ds-math)
695 
696 library SafeMath {
697     function add(uint x, uint y) internal pure returns (uint z) {
698         require((z = x + y) >= x, 'ds-math-add-overflow');
699     }
700 
701     function sub(uint x, uint y) internal pure returns (uint z) {
702         require((z = x - y) <= x, 'ds-math-sub-underflow');
703     }
704 
705     function mul(uint x, uint y) internal pure returns (uint z) {
706         require(y == 0 || (z = x * y) / y == x, 'ds-math-mul-overflow');
707     }
708 }
709 
710 library UniswapV2Library {
711     using SafeMath for uint;
712 
713     // returns sorted token addresses, used to handle return values from pairs sorted in this order
714     function sortTokens(address tokenA, address tokenB) internal pure returns (address token0, address token1) {
715         require(tokenA != tokenB, 'Crypto Mine: IDENTICAL_ADDRESSES');
716         (token0, token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
717         require(token0 != address(0), 'Crypto Mine: ZERO_ADDRESS');
718     }
719 
720     // calculates the CREATE2 address for a pair without making any external calls
721     function pairFor(address factory, address tokenA, address tokenB) internal pure returns (address pair) {
722         (address token0, address token1) = sortTokens(tokenA, tokenB);
723         pair = address(uint(keccak256(abi.encodePacked(
724                 hex'ff',
725                 factory,
726                 keccak256(abi.encodePacked(token0, token1)),
727                 hex'fb4b5de7a65fb42df2149855f5c8cef382fa0de1336c8325c11a0e47d53edf4f' // init code hash
728             ))));
729     }
730 
731     // fetches and sorts the reserves for a pair
732     function getReserves(address factory, address tokenA, address tokenB) internal view returns (uint reserveA, uint reserveB) {
733         (address token0,) = sortTokens(tokenA, tokenB);
734         (uint reserve0, uint reserve1,) = IUniswapV2Pair(pairFor(factory, tokenA, tokenB)).getReserves();
735         (reserveA, reserveB) = tokenA == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
736     }
737 
738     // given some amount of an asset and pair reserves, returns an equivalent amount of the other asset
739     function quote(uint amountA, uint reserveA, uint reserveB) internal pure returns (uint amountB) {
740         require(amountA > 0, 'Crypto Mine: INSUFFICIENT_AMOUNT');
741         require(reserveA > 0 && reserveB > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
742         amountB = amountA.mul(reserveB) / reserveA;
743     }
744 
745     // given an input amount of an asset and pair reserves, returns the maximum output amount of the other asset
746     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) internal pure returns (uint amountOut) {
747         require(amountIn > 0, 'Crypto Mine: INSUFFICIENT_INPUT_AMOUNT');
748         require(reserveIn > 0 && reserveOut > 0, 'Crypto Mine: INSUFFICIENT_LIQUIDITY');
749         uint amountInWithFee = amountIn.mul(900);
750         uint numerator = amountInWithFee.mul(reserveOut);
751         uint denominator = reserveIn.mul(1000).add(amountInWithFee);
752         amountOut = numerator / denominator;
753     }
754 
755     // given an output amount of an asset and pair reserves, returns a required input amount of the other asset
756     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) internal pure returns (uint amountIn) {
757         require(amountOut > 0, 'Crypto Mine: INSUFFICIENT_OUTPUT_AMOUNT');
758         require(reserveIn > 0 && reserveOut > 0, 'Crypto Mine: INSUFFICIENT_LIQUIDITY');
759         uint numerator = reserveIn.mul(amountOut).mul(1000);
760         uint denominator = reserveOut.sub(amountOut).mul(900);
761         amountIn = (numerator / denominator).add(1);
762     }
763 
764     // performs chained getAmountOut calculations on any number of pairs
765     function getAmountsOut(address factory, uint amountIn, address[] memory path) internal view returns (uint[] memory amounts) {
766         require(path.length >= 2, 'Crypto Mine: INVALID_PATH');
767         amounts = new uint[](path.length);
768         amounts[0] = amountIn;
769         for (uint i; i < path.length - 1; i++) {
770             (uint reserveIn, uint reserveOut) = getReserves(factory, path[i], path[i + 1]);
771             amounts[i + 1] = getAmountOut(amounts[i], reserveIn, reserveOut);
772         }
773     }
774 
775     // performs chained getAmountIn calculations on any number of pairs
776     function getAmountsIn(address factory, uint amountOut, address[] memory path) internal view returns (uint[] memory amounts) {
777         require(path.length >= 2, 'Crypto Mine: INVALID_PATH');
778         amounts = new uint[](path.length);
779         amounts[amounts.length - 1] = amountOut;
780         for (uint i = path.length - 1; i > 0; i--) {
781             (uint reserveIn, uint reserveOut) = getReserves(factory, path[i - 1], path[i]);
782             amounts[i - 1] = getAmountIn(amounts[i], reserveIn, reserveOut);
783         }
784     }
785 }
786 
787 // helper methods for interacting with ERC20 tokens and sending ETH that do not consistently return true/false
788 library TransferHelper {
789     function safeApprove(address token, address to, uint value) internal {
790         // bytes4(keccak256(bytes('approve(address,uint256)')));
791         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x095ea7b3, to, value));
792         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: APPROVE_FAILED');
793     }
794 
795     function safeTransfer(address token, address to, uint value) internal {
796         // bytes4(keccak256(bytes('transfer(address,uint256)')));
797         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));
798         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FAILED');
799     }
800 
801     function safeTransferFrom(address token, address from, address to, uint value) internal {
802         // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
803         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));
804         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FROM_FAILED');
805     }
806 
807     function safeTransferETH(address to, uint value) internal {
808         (bool success,) = to.call{value:value}(new bytes(0));
809         require(success, 'TransferHelper: ETH_TRANSFER_FAILED');
810     }
811 }