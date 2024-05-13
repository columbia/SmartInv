1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.7.4;
4 
5 import "../interfaces/IBabyNormalRouter.sol";
6 import "../libraries/TransferHelper.sol";
7 import "../interfaces/IBabyFactory.sol";
8 import "../interfaces/ISwapMining.sol";
9 import "../libraries/BabyLibrary.sol";
10 import "../interfaces/IERC20.sol";
11 import "../interfaces/IWETH.sol";
12 import "./BabyBaseRouter.sol";
13 
14 contract BabyNormalRouter is BabyBaseRouter, IBabyNormalRouter {
15     using SafeMath for uint;
16 
17     constructor(
18         address _factory, 
19         address _WETH, 
20         address _swapMining,
21         address _routerFeeReceiver
22     ) BabyBaseRouter(_factory, _WETH, _swapMining, _routerFeeReceiver) {
23     }
24 
25     function routerFee(address _user, address _token, uint _amount) internal returns (uint) {
26         if (routerFeeReceiver != address(0)) {
27             uint fee = _amount.mul(1).div(1000);
28             if (fee > 0) {
29                 if (_user == address(this)) {
30                     TransferHelper.safeTransfer(_token, routerFeeReceiver, fee);
31                 } else {
32                     TransferHelper.safeTransferFrom(
33                         _token, msg.sender, routerFeeReceiver, fee
34                     );
35                 }
36                 _amount = _amount.sub(fee);
37             }
38         }
39         return _amount;
40     }
41     //liquidity    
42     function _addLiquidity(
43         address tokenA,
44         address tokenB,
45         uint amountADesired,
46         uint amountBDesired,
47         uint amountAMin,
48         uint amountBMin
49     ) internal virtual returns (uint amountA, uint amountB) {
50         if (IBabyFactory(factory).getPair(tokenA, tokenB) == address(0)) {
51             IBabyFactory(factory).createPair(tokenA, tokenB);
52         }
53         (uint reserveA, uint reserveB) = BabyLibrary.getReserves(factory, tokenA, tokenB);
54         if (reserveA == 0 && reserveB == 0) {
55             (amountA, amountB) = (amountADesired, amountBDesired);
56         } else {
57             uint amountBOptimal = BabyLibrary.quote(amountADesired, reserveA, reserveB);
58             if (amountBOptimal <= amountBDesired) {
59                 require(amountBOptimal >= amountBMin, 'BabyRouter: INSUFFICIENT_B_AMOUNT');
60                 (amountA, amountB) = (amountADesired, amountBOptimal);
61             } else {
62                 uint amountAOptimal = BabyLibrary.quote(amountBDesired, reserveB, reserveA);
63                 assert(amountAOptimal <= amountADesired);
64                 require(amountAOptimal >= amountAMin, 'BabyRouter: INSUFFICIENT_A_AMOUNT');
65                 (amountA, amountB) = (amountAOptimal, amountBDesired);
66             }
67         }
68     }
69 
70     function addLiquidity(
71         address tokenA,
72         address tokenB,
73         uint amountADesired,
74         uint amountBDesired,
75         uint amountAMin,
76         uint amountBMin,
77         address to,
78         uint deadline
79     ) external virtual override ensure(deadline) returns (uint amountA, uint amountB, uint liquidity) {
80         (amountA, amountB) = _addLiquidity(tokenA, tokenB, amountADesired, amountBDesired, amountAMin, amountBMin);
81         address pair = BabyLibrary.pairFor(factory, tokenA, tokenB);
82         TransferHelper.safeTransferFrom(tokenA, msg.sender, pair, amountA);
83         TransferHelper.safeTransferFrom(tokenB, msg.sender, pair, amountB);
84         liquidity = IBabyPair(pair).mint(to);
85     }
86 
87     function addLiquidityETH(
88         address token,
89         uint amountTokenDesired,
90         uint amountTokenMin,
91         uint amountETHMin,
92         address to,
93         uint deadline
94     ) external virtual override payable ensure(deadline) returns (uint amountToken, uint amountETH, uint liquidity) {
95         (amountToken, amountETH) = _addLiquidity(
96             token,
97             WETH,
98             amountTokenDesired,
99             msg.value,
100             amountTokenMin,
101             amountETHMin
102         );
103         address pair = BabyLibrary.pairFor(factory, token, WETH);
104         TransferHelper.safeTransferFrom(token, msg.sender, pair, amountToken);
105         IWETH(WETH).deposit{value: amountETH}();
106         assert(IWETH(WETH).transfer(pair, amountETH));
107         liquidity = IBabyPair(pair).mint(to);
108         // refund dust eth, if any
109         if (msg.value > amountETH) TransferHelper.safeTransferETH(msg.sender, msg.value.sub(amountETH));
110     }
111 
112     function removeLiquidity(
113         address tokenA,
114         address tokenB,
115         uint liquidity,
116         uint amountAMin,
117         uint amountBMin,
118         address to,
119         uint deadline
120     ) public virtual override ensure(deadline) returns (uint amountA, uint amountB) {
121         address pair = BabyLibrary.pairFor(factory, tokenA, tokenB);
122         IBabyPair(pair).transferFrom(msg.sender, pair, liquidity); // send liquidity to pair
123         (uint amount0, uint amount1) = IBabyPair(pair).burn(to);
124         (address token0,) = BabyLibrary.sortTokens(tokenA, tokenB);
125         (amountA, amountB) = tokenA == token0 ? (amount0, amount1) : (amount1, amount0);
126         require(amountA >= amountAMin, 'BabyRouter: INSUFFICIENT_A_AMOUNT');
127         require(amountB >= amountBMin, 'BabyRouter: INSUFFICIENT_B_AMOUNT');
128     }
129 
130     function removeLiquidityWithPermit(
131         address tokenA,
132         address tokenB,
133         uint liquidity,
134         uint amountAMin,
135         uint amountBMin,
136         address to,
137         uint deadline,
138         bool approveMax, uint8 v, bytes32 r, bytes32 s
139     ) external virtual override returns (uint amountA, uint amountB) {
140         address pair = BabyLibrary.pairFor(factory, tokenA, tokenB);
141         uint value = approveMax ? uint(-1) : liquidity;
142         IBabyPair(pair).permit(msg.sender, address(this), value, deadline, v, r, s);
143         (amountA, amountB) = removeLiquidity(tokenA, tokenB, liquidity, amountAMin, amountBMin, to, deadline);
144     }
145 
146     function removeLiquidityETH(
147         address token,
148         uint liquidity,
149         uint amountTokenMin,
150         uint amountETHMin,
151         address to,
152         uint deadline
153     ) public virtual override ensure(deadline) returns (uint amountToken, uint amountETH) {
154         (amountToken, amountETH) = removeLiquidity(
155             token,
156             WETH,
157             liquidity,
158             amountTokenMin,
159             amountETHMin,
160             address(this),
161             deadline
162         );
163         TransferHelper.safeTransfer(token, to, amountToken);
164         IWETH(WETH).withdraw(amountETH);
165         TransferHelper.safeTransferETH(to, amountETH);
166     }
167 
168     function removeLiquidityETHWithPermit(
169         address token,
170         uint liquidity,
171         uint amountTokenMin,
172         uint amountETHMin,
173         address to,
174         uint deadline,
175         bool approveMax, uint8 v, bytes32 r, bytes32 s
176     ) external virtual override returns (uint amountToken, uint amountETH) {
177         address pair = BabyLibrary.pairFor(factory, token, WETH);
178         uint value = approveMax ? uint(-1) : liquidity;
179         IBabyPair(pair).permit(msg.sender, address(this), value, deadline, v, r, s);
180         (amountToken, amountETH) = removeLiquidityETH(token, liquidity, amountTokenMin, amountETHMin, to, deadline);
181     }
182 
183     function removeLiquidityETHSupportingFeeOnTransferTokens(
184         address token,
185         uint liquidity,
186         uint amountTokenMin,
187         uint amountETHMin,
188         address to,
189         uint deadline
190     ) public virtual override ensure(deadline) returns (uint amountETH) {
191         (, amountETH) = removeLiquidity(
192             token,
193             WETH,
194             liquidity,
195             amountTokenMin,
196             amountETHMin,
197             address(this),
198             deadline
199         );
200         TransferHelper.safeTransfer(token, to, IERC20(token).balanceOf(address(this)));
201         IWETH(WETH).withdraw(amountETH);
202         TransferHelper.safeTransferETH(to, amountETH);
203     }
204 
205     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
206         address token,
207         uint liquidity,
208         uint amountTokenMin,
209         uint amountETHMin,
210         address to,
211         uint deadline,
212         bool approveMax, uint8 v, bytes32 r, bytes32 s
213     ) external virtual override returns (uint amountETH) {
214         address pair = BabyLibrary.pairFor(factory, token, WETH);
215         uint value = approveMax ? uint(-1) : liquidity;
216         IBabyPair(pair).permit(msg.sender, address(this), value, deadline, v, r, s);
217         amountETH = removeLiquidityETHSupportingFeeOnTransferTokens(
218             token, liquidity, amountTokenMin, amountETHMin, to, deadline
219         );
220     }
221     //swap
222     function _swap(
223         uint[] memory amounts, 
224         address[] memory path, 
225         address _to
226     ) internal virtual {
227         for (uint i; i < path.length - 1; i++) {
228             (address input, address output) = (path[i], path[i + 1]);
229             (address token0,) = BabyLibrary.sortTokens(input, output);
230             uint amountOut = amounts[i + 1];
231             if (swapMining != address(0)) {
232                 ISwapMining(swapMining).swap(msg.sender, input, output, amountOut);
233             }
234             (uint amount0Out, uint amount1Out) = input == token0 ? (uint(0), amountOut) : (amountOut, uint(0));
235             address to = i < path.length - 2 ? address(this) : _to;
236             IBabyPair(BabyLibrary.pairFor(factory, input, output)).swap(
237                 amount0Out, amount1Out, to, new bytes(0)
238             );
239             if (i < path.length - 2) {
240                 amounts[i + 1] = routerFee(address(this), path[i + 1], amounts[i + 1]);
241                 TransferHelper.safeTransfer(path[i + 1], BabyLibrary.pairFor(factory, output, path[i + 2]), amounts[i + 1]);
242             }
243         }
244     }
245 
246     function swapExactTokensForTokens(
247         uint amountIn,
248         uint amountOutMin,
249         address[] memory path,
250         address to,
251         uint deadline
252     ) external virtual override ensure(deadline) returns (uint[] memory amounts) {
253         amounts = BabyLibrary.getAmountsOut(factory, amountIn, path);
254         require(amounts[amounts.length - 1] >= amountOutMin, 'BabyRouter: INSUFFICIENT_OUTPUT_AMOUNT');
255         amounts[0] = routerFee(msg.sender, path[0], amounts[0]);
256         TransferHelper.safeTransferFrom(
257             path[0], msg.sender, BabyLibrary.pairFor(factory, path[0], path[1]), amounts[0]
258         );
259         _swap(amounts, path, to);
260     }
261 
262     function swapTokensForExactTokens(
263         uint amountOut,
264         uint amountInMax,
265         address[] memory path,
266         address to,
267         uint deadline
268     ) external virtual override ensure(deadline) returns (uint[] memory amounts) {
269         amounts = BabyLibrary.getAmountsIn(factory, amountOut, path);
270         require(amounts[0] <= amountInMax, 'BabyRouter: EXCESSIVE_INPUT_AMOUNT');
271         amounts[0] = routerFee(msg.sender, path[0], amounts[0]);
272         TransferHelper.safeTransferFrom(
273             path[0], msg.sender, BabyLibrary.pairFor(factory, path[0], path[1]), amounts[0]
274         );
275         _swap(amounts, path, to);
276     }
277 
278     function swapExactETHForTokens(uint amountOutMin, address[] memory path, address to, uint deadline)
279         external
280         virtual
281         override
282         payable
283         ensure(deadline)
284         returns (uint[] memory amounts
285     ) {
286         require(path[0] == WETH, 'BabyRouter: INVALID_PATH');
287         amounts = BabyLibrary.getAmountsOut(factory, msg.value, path);
288         require(amounts[amounts.length - 1] >= amountOutMin, 'BabyRouter: INSUFFICIENT_OUTPUT_AMOUNT');
289         IWETH(WETH).deposit{value: amounts[0]}();
290         amounts[0] = routerFee(address(this), path[0], amounts[0]);
291         assert(IWETH(WETH).transfer(BabyLibrary.pairFor(factory, path[0], path[1]), amounts[0]));
292         _swap(amounts, path, to);
293     }
294 
295     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] memory path, address to, uint deadline)
296         external
297         virtual
298         override
299         ensure(deadline)
300         returns (uint[] memory amounts
301     ) {
302         require(path[path.length - 1] == WETH, 'BabyRouter: INVALID_PATH');
303         amounts = BabyLibrary.getAmountsIn(factory, amountOut, path);
304         require(amounts[0] <= amountInMax, 'BabyRouter: EXCESSIVE_INPUT_AMOUNT');
305         amounts[0] = routerFee(msg.sender, path[0], amounts[0]);
306         TransferHelper.safeTransferFrom(
307             path[0], msg.sender, BabyLibrary.pairFor(factory, path[0], path[1]), amounts[0]
308         );
309         _swap(amounts, path, address(this));
310         IWETH(WETH).withdraw(amounts[amounts.length - 1]);
311         TransferHelper.safeTransferETH(to, amounts[amounts.length - 1]);
312     }
313 
314     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] memory path, address to, uint deadline)
315         external
316         virtual
317         override
318         ensure(deadline)
319         returns (uint[] memory amounts
320     ) {
321         require(path[path.length - 1] == WETH, 'BabyRouter: INVALID_PATH');
322         amounts = BabyLibrary.getAmountsOut(factory, amountIn, path);
323         require(amounts[amounts.length - 1] >= amountOutMin, 'BabyRouter: INSUFFICIENT_OUTPUT_AMOUNT');
324         amounts[0] = routerFee(msg.sender, path[0], amounts[0]);
325         TransferHelper.safeTransferFrom(
326             path[0], msg.sender, BabyLibrary.pairFor(factory, path[0], path[1]), amounts[0]
327         );
328         _swap(amounts, path, address(this));
329         IWETH(WETH).withdraw(amounts[amounts.length - 1]);
330         TransferHelper.safeTransferETH(to, amounts[amounts.length - 1]);
331     }
332 
333     function swapETHForExactTokens(uint amountOut, address[] memory path, address to, uint deadline)
334         external
335         virtual
336         override
337         payable
338         ensure(deadline)
339         returns (uint[] memory amounts
340     ) {
341         require(path[0] == WETH, 'BabyRouter: INVALID_PATH');
342         amounts = BabyLibrary.getAmountsIn(factory, amountOut, path);
343         require(amounts[0] <= msg.value, 'BabyRouter: EXCESSIVE_INPUT_AMOUNT');
344         IWETH(WETH).deposit{value: amounts[0]}();
345         uint oldAmounts = amounts[0];
346         amounts[0] = routerFee(address(this), path[0], amounts[0]);
347         assert(IWETH(WETH).transfer(BabyLibrary.pairFor(factory, path[0], path[1]), amounts[0]));
348         _swap(amounts, path, to);
349         // refund dust eth, if any
350         if (msg.value > oldAmounts) TransferHelper.safeTransferETH(msg.sender, msg.value - oldAmounts);
351     }
352 
353     function _swapSupportingFeeOnTransferTokens(
354         address[] memory path, 
355         address _to
356     ) internal virtual {
357         for (uint i; i < path.length - 1; i++) {
358             (address input, address output) = (path[i], path[i + 1]);
359             (address token0,) = BabyLibrary.sortTokens(input, output);
360             IBabyPair pair = IBabyPair(BabyLibrary.pairFor(factory, input, output));
361             uint amountInput;
362             uint amountOutput;
363             { // scope to avoid stack too deep errors
364             (uint reserve0, uint reserve1,) = pair.getReserves();
365             (uint reserveInput, uint reserveOutput) = input == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
366             amountInput = IERC20(input).balanceOf(address(pair)).sub(reserveInput);
367             amountOutput = BabyLibrary.getAmountOut(amountInput, reserveInput, reserveOutput);
368             }
369             if (swapMining != address(0)) {
370                 ISwapMining(swapMining).swap(msg.sender, input, output, amountOutput);
371             }
372             (uint amount0Out, uint amount1Out) = input == token0 ? (uint(0), amountOutput) : (amountOutput, uint(0));
373             //address to = i < path.length - 2 ? BabyLibrary.pairFor(factory, output, path[i + 2]) : _to;
374             //address to = i < path.length - 2 ? address(this) : _to;
375             pair.swap(amount0Out, amount1Out, i < path.length - 2 ? address(this) : _to, new bytes(0));
376             if (i < path.length - 2) {
377                 amountOutput = IERC20(output).balanceOf(address(this));
378                 routerFee(address(this), output, amountOutput);
379                 TransferHelper.safeTransfer(path[i + 1], BabyLibrary.pairFor(factory, output, path[i + 2]), IERC20(output).balanceOf(address(this)));
380             }
381         }
382     }
383 
384     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
385         uint amountIn,
386         uint amountOutMin,
387         address[] memory path,
388         address to,
389         uint deadline
390     ) external virtual override ensure(deadline) {
391         amountIn = routerFee(msg.sender, path[0], amountIn);
392         TransferHelper.safeTransferFrom(
393             path[0], msg.sender, BabyLibrary.pairFor(factory, path[0], path[1]), amountIn
394         );
395         uint balanceBefore = IERC20(path[path.length - 1]).balanceOf(to);
396         _swapSupportingFeeOnTransferTokens(path, to);
397         require(
398             IERC20(path[path.length - 1]).balanceOf(to).sub(balanceBefore) >= amountOutMin,
399             'BabyRouter: INSUFFICIENT_OUTPUT_AMOUNT'
400         );
401     }
402 
403     function swapExactETHForTokensSupportingFeeOnTransferTokens(
404         uint amountOutMin,
405         address[] memory path,
406         address to,
407         uint deadline
408     ) external virtual override payable ensure(deadline) {
409         require(path[0] == WETH, 'BabyRouter: INVALID_PATH');
410         uint amountIn = msg.value;
411         IWETH(WETH).deposit{value: amountIn}();
412         amountIn = routerFee(address(this), path[0], amountIn);
413         assert(IWETH(WETH).transfer(BabyLibrary.pairFor(factory, path[0], path[1]), amountIn));
414         uint balanceBefore = IERC20(path[path.length - 1]).balanceOf(to);
415         _swapSupportingFeeOnTransferTokens(path, to);
416         require(
417             IERC20(path[path.length - 1]).balanceOf(to).sub(balanceBefore) >= amountOutMin,
418             'BabyRouter: INSUFFICIENT_OUTPUT_AMOUNT'
419         );
420     }
421 
422     function swapExactTokensForETHSupportingFeeOnTransferTokens(
423         uint amountIn,
424         uint amountOutMin,
425         address[] memory path,
426         address to,
427         uint deadline
428     ) external virtual override ensure(deadline) {
429         require(path[path.length - 1] == WETH, 'BabyRouter: INVALID_PATH');
430         amountIn = routerFee(msg.sender, path[0], amountIn);
431         TransferHelper.safeTransferFrom(
432             path[0], msg.sender, BabyLibrary.pairFor(factory, path[0], path[1]), amountIn
433         );
434         _swapSupportingFeeOnTransferTokens(path, address(this));
435         uint amountOut = IERC20(WETH).balanceOf(address(this));
436         require(amountOut >= amountOutMin, 'BabyRouter: INSUFFICIENT_OUTPUT_AMOUNT');
437         IWETH(WETH).withdraw(amountOut);
438         TransferHelper.safeTransferETH(to, amountOut);
439     }
440     //helper
441     function quote(
442         uint amountA, 
443         uint reserveA, 
444         uint reserveB
445     ) public pure virtual override returns (uint amountB) {
446         return BabyLibrary.quote(amountA, reserveA, reserveB);
447     }
448 
449     function getAmountOut(
450         uint amountIn, 
451         uint reserveIn, 
452         uint reserveOut
453     ) public pure virtual override returns (uint amountOut) {
454         return BabyLibrary.getAmountOut(amountIn, reserveIn, reserveOut);
455     }
456 
457     function getAmountIn(
458         uint amountOut, 
459         uint reserveIn, 
460         uint reserveOut
461     ) public pure virtual override returns (uint amountIn) {
462         return BabyLibrary.getAmountIn(amountOut, reserveIn, reserveOut);
463     }
464 
465     function getAmountsOut(
466         uint amountIn, 
467         address[] memory path
468     ) public view virtual override returns (uint[] memory amounts) {
469         return BabyLibrary.getAmountsOut(factory, amountIn, path);
470     }
471 
472     function getAmountsIn(
473         uint amountOut, 
474         address[] memory path
475     ) public view virtual override returns (uint[] memory amounts) {
476         return BabyLibrary.getAmountsIn(factory, amountOut, path);
477     }
478 }
