1 pragma solidity =0.6.6;
2 
3 import './interfaces/IParaFactory.sol';
4 import './libraries/TransferHelper.sol';
5 import "./libraries/Ownable.sol";
6 import './interfaces/IParaRouter02.sol';
7 import './libraries/ParaLibrary.sol';
8 import './libraries/SafeMath_Router.sol';
9 import './interfaces/IERC20.sol';
10 import './interfaces/IWETH.sol';
11 import './interfaces/IParaToken.sol';
12 
13 
14 contract ParaRouter is IParaRouter02 , Ownable {
15     using SafeMath for uint;
16 
17     address public immutable override factory;
18     address public immutable override WETH;
19     address public paraToken;
20     address public t42Lp;
21 
22     modifier ensure(uint deadline) {
23         require(deadline >= block.timestamp, 'ParaRouter: EXPIRED');
24         _;
25     }
26 
27     constructor(address _factory, address _WETH) public {
28         factory = _factory;
29         WETH = _WETH;
30     }
31 
32     function setT42(address _paraToken) external onlyOwner{
33         require(_paraToken != address(0),"!0");
34         paraToken = _paraToken;
35     }
36 
37     function setT42Lp(address _t42Lp) external onlyOwner{
38         require(_t42Lp != address(0),"!0");
39         t42Lp = _t42Lp;
40     }
41 
42     receive() external payable {
43         assert(msg.sender == WETH); // only accept ETH via fallback from the WETH contract
44     }
45 
46     // **** ADD LIQUIDITY ****
47     function _addLiquidity(
48         address tokenA,
49         address tokenB,
50         uint amountADesired,
51         uint amountBDesired,
52         uint amountAMin,
53         uint amountBMin
54     ) internal virtual returns (uint amountA, uint amountB) {
55         // create the pair if it doesn't exist yet
56         if (IParaFactory(factory).getPair(tokenA, tokenB) == address(0)) {
57             IParaFactory(factory).createPair(tokenA, tokenB);
58         }
59         (uint reserveA, uint reserveB) = ParaLibrary.getReserves(factory, tokenA, tokenB);
60         if (reserveA == 0 && reserveB == 0) {
61             (amountA, amountB) = (amountADesired, amountBDesired);
62         } else {
63             uint amountBOptimal = ParaLibrary.quote(amountADesired, reserveA, reserveB);
64             if (amountBOptimal <= amountBDesired) {
65                 require(amountBOptimal >= amountBMin, 'ParaRouter: INSUFFICIENT_B_AMOUNT');
66                 (amountA, amountB) = (amountADesired, amountBOptimal);
67             } else {
68                 uint amountAOptimal = ParaLibrary.quote(amountBDesired, reserveB, reserveA);
69                 assert(amountAOptimal <= amountADesired);
70                 require(amountAOptimal >= amountAMin, 'ParaRouter: INSUFFICIENT_A_AMOUNT');
71                 (amountA, amountB) = (amountAOptimal, amountBDesired);
72             }
73         }
74     }
75     
76     function noFees(address token0, address token1) internal{
77         require(paraToken != address(0), "!0");
78         if(token0 == paraToken || token1 == paraToken){
79            //setWhiteList
80            IParaToken(paraToken)._setWhiteList(0, t42Lp, true);
81         }
82     }
83 
84     function FeesOn(address token0, address token1) internal{
85         require(paraToken != address(0), "!0");
86         if(token0 == paraToken || token1 == paraToken){
87            IParaToken(paraToken)._setWhiteList(0, t42Lp, false);
88         }
89     }
90 
91     //modifier too stack deep
92 
93     function addLiquidity(
94         address tokenA,
95         address tokenB,
96         uint amountADesired,
97         uint amountBDesired,
98         uint amountAMin,
99         uint amountBMin,
100         address to,
101         uint deadline
102     ) external virtual override ensure(deadline) returns (uint amountA, uint amountB, uint liquidity) {
103         noFees(tokenA, tokenB);
104         (amountA, amountB) = _addLiquidity(tokenA, tokenB, amountADesired, amountBDesired, amountAMin, amountBMin);
105         address pair = ParaLibrary.pairFor(factory, tokenA, tokenB);
106         TransferHelper.safeTransferFrom(tokenA, msg.sender, pair, amountA);
107         TransferHelper.safeTransferFrom(tokenB, msg.sender, pair, amountB);
108         liquidity = IParaPair(pair).mint(to);
109         FeesOn(tokenA, tokenB);
110     }
111     function addLiquidityETH(
112         address token,
113         uint amountTokenDesired,
114         uint amountTokenMin,
115         uint amountETHMin,
116         address to,
117         uint deadline
118     ) external virtual override payable ensure(deadline) returns (uint amountToken, uint amountETH, uint liquidity) {
119         noFees(token, token);
120         (amountToken, amountETH) = _addLiquidity(
121             token,
122             WETH,
123             amountTokenDesired,
124             msg.value,
125             amountTokenMin,
126             amountETHMin
127         );
128         address pair = ParaLibrary.pairFor(factory, token, WETH);
129         TransferHelper.safeTransferFrom(token, msg.sender, pair, amountToken);
130         IWETH(WETH).deposit{value: amountETH}();
131         assert(IWETH(WETH).transfer(pair, amountETH));
132         liquidity = IParaPair(pair).mint(to);
133         // refund dust eth, if any
134         if (msg.value > amountETH) TransferHelper.safeTransferETH(msg.sender, msg.value - amountETH);
135         FeesOn(token, token);
136     }
137 
138     // **** REMOVE LIQUIDITY ****
139     function removeLiquidity(
140         address tokenA,
141         address tokenB,
142         uint liquidity,
143         uint amountAMin,
144         uint amountBMin,
145         address to,
146         uint deadline
147     ) public virtual override ensure(deadline) returns (uint amountA, uint amountB) {
148         address pair = ParaLibrary.pairFor(factory, tokenA, tokenB);
149         IParaPair(pair).transferFrom(msg.sender, pair, liquidity); // send liquidity to pair
150         (uint amount0, uint amount1) = IParaPair(pair).burn(to);
151         (address token0,) = ParaLibrary.sortTokens(tokenA, tokenB);
152         (amountA, amountB) = tokenA == token0 ? (amount0, amount1) : (amount1, amount0);
153         require(amountA >= amountAMin, 'ParaRouter: INSUFFICIENT_A_AMOUNT');
154         require(amountB >= amountBMin, 'ParaRouter: INSUFFICIENT_B_AMOUNT');
155     }
156     function removeLiquidityETH(
157         address token,
158         uint liquidity,
159         uint amountTokenMin,
160         uint amountETHMin,
161         address to,
162         uint deadline
163     ) public virtual override ensure(deadline) returns (uint amountToken, uint amountETH) {
164         (amountToken, amountETH) = removeLiquidity(
165             token,
166             WETH,
167             liquidity,
168             amountTokenMin,
169             amountETHMin,
170             address(this),
171             deadline
172         );
173         TransferHelper.safeTransfer(token, to, amountToken);
174         IWETH(WETH).withdraw(amountETH);
175         TransferHelper.safeTransferETH(to, amountETH);
176     }
177     function removeLiquidityWithPermit(
178         address tokenA,
179         address tokenB,
180         uint liquidity,
181         uint amountAMin,
182         uint amountBMin,
183         address to,
184         uint deadline,
185         bool approveMax, uint8 v, bytes32 r, bytes32 s
186     ) external virtual override returns (uint amountA, uint amountB) {
187         address pair = ParaLibrary.pairFor(factory, tokenA, tokenB);
188         uint value = approveMax ? uint(-1) : liquidity;
189         IParaPair(pair).permit(msg.sender, address(this), value, deadline, v, r, s);
190         (amountA, amountB) = removeLiquidity(tokenA, tokenB, liquidity, amountAMin, amountBMin, to, deadline);
191     }
192     function removeLiquidityETHWithPermit(
193         address token,
194         uint liquidity,
195         uint amountTokenMin,
196         uint amountETHMin,
197         address to,
198         uint deadline,
199         bool approveMax, uint8 v, bytes32 r, bytes32 s
200     ) external virtual override returns (uint amountToken, uint amountETH) {
201         address pair = ParaLibrary.pairFor(factory, token, WETH);
202         uint value = approveMax ? uint(-1) : liquidity;
203         IParaPair(pair).permit(msg.sender, address(this), value, deadline, v, r, s);
204         (amountToken, amountETH) = removeLiquidityETH(token, liquidity, amountTokenMin, amountETHMin, to, deadline);
205     }
206 
207     // **** REMOVE LIQUIDITY (supporting fee-on-transfer tokens) ****
208     function removeLiquidityETHSupportingFeeOnTransferTokens(
209         address token,
210         uint liquidity,
211         uint amountTokenMin,
212         uint amountETHMin,
213         address to,
214         uint deadline
215     ) public virtual override ensure(deadline) returns (uint amountETH) {
216         (, amountETH) = removeLiquidity(
217             token,
218             WETH,
219             liquidity,
220             amountTokenMin,
221             amountETHMin,
222             address(this),
223             deadline
224         );
225         TransferHelper.safeTransfer(token, to, IERC20(token).balanceOf(address(this)));
226         IWETH(WETH).withdraw(amountETH);
227         TransferHelper.safeTransferETH(to, amountETH);
228     }
229     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
230         address token,
231         uint liquidity,
232         uint amountTokenMin,
233         uint amountETHMin,
234         address to,
235         uint deadline,
236         bool approveMax, uint8 v, bytes32 r, bytes32 s
237     ) external virtual override returns (uint amountETH) {
238         address pair = ParaLibrary.pairFor(factory, token, WETH);
239         uint value = approveMax ? uint(-1) : liquidity;
240         IParaPair(pair).permit(msg.sender, address(this), value, deadline, v, r, s);
241         amountETH = removeLiquidityETHSupportingFeeOnTransferTokens(
242             token, liquidity, amountTokenMin, amountETHMin, to, deadline
243         );
244     }
245 
246     // **** SWAP ****
247     // requires the initial amount to have already been sent to the first pair
248     function _swap(uint[] memory amounts, address[] memory path, address _to, bool isAmountIn) internal virtual {
249         for (uint i; i < path.length - 1; i++) {
250             (address input, address output) = (path[i], path[i + 1]);
251             (address token0,) = ParaLibrary.sortTokens(input, output);
252             uint amountOut = amounts[i + 1];
253             (uint amount0Out, uint amount1Out) = input == token0 ? (uint(0), amountOut) : (amountOut, uint(0));
254             address to = i < path.length - 2 ? ParaLibrary.pairFor(factory, output, path[i + 2]) : _to;
255             IParaPair(ParaLibrary.pairFor(factory, input, output)).swap(
256                 amount0Out, amount1Out, to, new bytes(0)
257             );
258         }
259     }
260     function swapExactTokensForTokens(
261         uint amountIn,
262         uint amountOutMin,
263         address[] calldata path,
264         address to,
265         uint deadline
266     ) external virtual override ensure(deadline) returns (uint[] memory amounts) {
267         amounts = ParaLibrary.getAmountsOut(factory, amountIn, path);
268         require(amounts[amounts.length - 1] >= amountOutMin, 'ParaRouter: INSUFFICIENT_OUTPUT_AMOUNT');
269         TransferHelper.safeTransferFrom(
270             path[0], msg.sender, ParaLibrary.pairFor(factory, path[0], path[1]), amounts[0]
271         );
272         _swap(amounts, path, to, false);
273     }
274     function swapTokensForExactTokens(
275         uint amountOut,
276         uint amountInMax,
277         address[] calldata path,
278         address to,
279         uint deadline
280     ) external virtual override ensure(deadline) returns (uint[] memory amounts) {
281         amounts = ParaLibrary.getAmountsIn(factory, amountOut, path);
282         require(amounts[0] <= amountInMax, 'ParaRouter: EXCESSIVE_INPUT_AMOUNT');
283         TransferHelper.safeTransferFrom(
284             path[0], msg.sender, ParaLibrary.pairFor(factory, path[0], path[1]), amounts[0]
285         );
286         _swap(amounts, path, to, true);
287     }
288     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
289         external
290         virtual
291         override
292         payable
293         ensure(deadline)
294         returns (uint[] memory amounts)
295     {
296         require(path[0] == WETH, 'ParaRouter: INVALID_PATH');
297         amounts = ParaLibrary.getAmountsOut(factory, msg.value, path);
298         require(amounts[amounts.length - 1] >= amountOutMin, 'ParaRouter: INSUFFICIENT_OUTPUT_AMOUNT');
299         IWETH(WETH).deposit{value: amounts[0]}();
300         assert(IWETH(WETH).transfer(ParaLibrary.pairFor(factory, path[0], path[1]), amounts[0]));
301         _swap(amounts, path, to, false);
302     }
303     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
304         external
305         virtual
306         override
307         ensure(deadline)
308         returns (uint[] memory amounts)
309     {
310         require(path[path.length - 1] == WETH, 'ParaRouter: INVALID_PATH');
311         amounts = ParaLibrary.getAmountsIn(factory, amountOut, path);
312         require(amounts[0] <= amountInMax, 'ParaRouter: EXCESSIVE_INPUT_AMOUNT');
313         TransferHelper.safeTransferFrom(
314             path[0], msg.sender, ParaLibrary.pairFor(factory, path[0], path[1]), amounts[0]
315         );
316         _swap(amounts, path, address(this), true);
317         IWETH(WETH).withdraw(amounts[amounts.length - 1]);
318         TransferHelper.safeTransferETH(to, amounts[amounts.length - 1]);
319     }
320     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
321         external
322         virtual
323         override
324         ensure(deadline)
325         returns (uint[] memory amounts)
326     {   
327         require(path[path.length - 1] == WETH, 'ParaRouter: INVALID_PATH');
328         amounts = ParaLibrary.getAmountsOut(factory, amountIn, path);
329         require(amounts[amounts.length - 1] >= amountOutMin, 'ParaRouter: INSUFFICIENT_OUTPUT_AMOUNT');
330         TransferHelper.safeTransferFrom(
331             path[0], msg.sender, ParaLibrary.pairFor(factory, path[0], path[1]), amounts[0]
332         );
333         _swap(amounts, path, address(this), false);
334         IWETH(WETH).withdraw(amounts[amounts.length - 1]);
335         TransferHelper.safeTransferETH(to, amounts[amounts.length - 1]);
336     }
337     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
338         external
339         virtual
340         override
341         payable
342         ensure(deadline)
343         returns (uint[] memory amounts)
344     {
345         require(path[0] == WETH, 'ParaRouter: INVALID_PATH');
346         amounts = ParaLibrary.getAmountsIn(factory, amountOut, path);
347         require(amounts[0] <= msg.value, 'ParaRouter: EXCESSIVE_INPUT_AMOUNT');
348         IWETH(WETH).deposit{value: amounts[0]}();
349         assert(IWETH(WETH).transfer(ParaLibrary.pairFor(factory, path[0], path[1]), amounts[0]));
350         _swap(amounts, path, to, true);
351         // refund dust eth, if any
352         if (msg.value > amounts[0]) TransferHelper.safeTransferETH(msg.sender, msg.value - amounts[0]);
353     }
354 
355     // **** SWAP (supporting fee-on-transfer tokens) ****
356     // requires the initial amount to have already been sent to the first pair
357     function _swapSupportingFeeOnTransferTokens(address[] memory path, address _to) internal virtual {
358         for (uint i; i < path.length - 1; i++) {
359             (address input, address output) = (path[i], path[i + 1]);
360             (address token0,) = ParaLibrary.sortTokens(input, output);
361             IParaPair pair = IParaPair(ParaLibrary.pairFor(factory, input, output));
362             uint amountInput;
363             uint amountOutput;
364             { // scope to avoid stack too deep errors
365             (uint reserve0, uint reserve1,) = pair.getReserves();
366             (uint reserveInput, uint reserveOutput) = input == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
367             amountInput = IERC20(input).balanceOf(address(pair)).sub(reserveInput);
368             amountOutput = ParaLibrary.getAmountOut(amountInput, reserveInput, reserveOutput);
369             }
370             (uint amount0Out, uint amount1Out) = input == token0 ? (uint(0), amountOutput) : (amountOutput, uint(0));
371             address to = i < path.length - 2 ? ParaLibrary.pairFor(factory, output, path[i + 2]) : _to;
372             pair.swap(amount0Out, amount1Out, to, new bytes(0));
373         }
374     }
375     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
376         uint amountIn,
377         uint amountOutMin,
378         address[] calldata path,
379         address to,
380         uint deadline
381     ) external virtual override ensure(deadline) {
382         TransferHelper.safeTransferFrom(
383             path[0], msg.sender, ParaLibrary.pairFor(factory, path[0], path[1]), amountIn
384         );
385         uint balanceBefore = IERC20(path[path.length - 1]).balanceOf(to);
386         _swapSupportingFeeOnTransferTokens(path, to);
387         require(
388             IERC20(path[path.length - 1]).balanceOf(to).sub(balanceBefore) >= amountOutMin,
389             'ParaRouter: INSUFFICIENT_OUTPUT_AMOUNT'
390         );
391     }
392     function swapExactETHForTokensSupportingFeeOnTransferTokens(
393         uint amountOutMin,
394         address[] calldata path,
395         address to,
396         uint deadline
397     )
398         external
399         virtual
400         override
401         payable
402         ensure(deadline)
403     {
404         require(path[0] == WETH, 'ParaRouter: INVALID_PATH');
405         uint amountIn = msg.value;
406         IWETH(WETH).deposit{value: amountIn}();
407         assert(IWETH(WETH).transfer(ParaLibrary.pairFor(factory, path[0], path[1]), amountIn));
408         uint balanceBefore = IERC20(path[path.length - 1]).balanceOf(to);
409         _swapSupportingFeeOnTransferTokens(path, to);
410         require(
411             IERC20(path[path.length - 1]).balanceOf(to).sub(balanceBefore) >= amountOutMin,
412             'ParaRouter: INSUFFICIENT_OUTPUT_AMOUNT'
413         );
414     }
415     function swapExactTokensForETHSupportingFeeOnTransferTokens(
416         uint amountIn,
417         uint amountOutMin,
418         address[] calldata path,
419         address to,
420         uint deadline
421     )
422         external
423         virtual
424         override
425         ensure(deadline)
426     {
427         require(path[path.length - 1] == WETH, 'ParaRouter: INVALID_PATH');
428         TransferHelper.safeTransferFrom(
429             path[0], msg.sender, ParaLibrary.pairFor(factory, path[0], path[1]), amountIn
430         );
431         _swapSupportingFeeOnTransferTokens(path, address(this));
432         uint amountOut = IERC20(WETH).balanceOf(address(this));
433         require(amountOut >= amountOutMin, 'ParaRouter: INSUFFICIENT_OUTPUT_AMOUNT');
434         IWETH(WETH).withdraw(amountOut);
435         TransferHelper.safeTransferETH(to, amountOut);
436     }
437 
438     // **** LIBRARY FUNCTIONS ****
439     function quote(uint amountA, uint reserveA, uint reserveB) public pure virtual override returns (uint amountB) {
440         return ParaLibrary.quote(amountA, reserveA, reserveB);
441     }
442 
443     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut)
444         public
445         pure
446         virtual
447         override
448         returns (uint amountOut)
449     {
450         return ParaLibrary.getAmountOut(amountIn, reserveIn, reserveOut);
451     }
452 
453     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut)
454         public
455         pure
456         virtual
457         override
458         returns (uint amountIn)
459     {
460         return ParaLibrary.getAmountIn(amountOut, reserveIn, reserveOut);
461     }
462 
463     function getAmountsOut(uint amountIn, address[] memory path)
464         public
465         view
466         virtual
467         override
468         returns (uint[] memory amounts)
469     {
470         return ParaLibrary.getAmountsOut(factory, amountIn, path);
471     }
472 
473     function getAmountsIn(uint amountOut, address[] memory path)
474         public
475         view
476         virtual
477         override
478         returns (uint[] memory amounts)
479     {
480         return ParaLibrary.getAmountsIn(factory, amountOut, path);
481     }
482 }
