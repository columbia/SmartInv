1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity >=0.6.6;
4 
5 import "@openzeppelin/contracts/access/Ownable.sol";
6 import '../interfaces/IBabyFactory.sol';
7 import '../interfaces/IBabyRouter02.sol';
8 import '../libraries/TransferHelper.sol';
9 import '../libraries/BabyLibrary.sol';
10 import '../libraries/SafeMath.sol';
11 import '../interfaces/IERC20.sol';
12 import '../interfaces/IWETH.sol';
13 import 'hardhat/console.sol';
14 
15 interface ISwapMining {
16     function swap(address account, address input, address output, uint256 amount) external returns (bool);
17 }
18 
19 
20 contract BabyRouter is IBabyRouter02, Ownable {
21     using SafeMath for uint;
22 
23     address public immutable override factory;
24     address[] public factories;
25     uint[] public fees;
26     mapping(address => uint) public tokenMinAmount;
27     address immutable oldRouter;
28 
29     address public immutable override WETH;
30     address public swapMining;
31 
32     modifier ensure(uint deadline) {
33         require(deadline >= block.timestamp, 'BabyRouter');
34         _;
35     }
36 
37     function setSwapMining(address _swapMininng) public onlyOwner {
38         swapMining = _swapMininng;
39     }
40 
41     constructor(address _oldRouter, address _factory, uint _fee, address _WETH) {
42         oldRouter = _oldRouter;
43         factory = _factory;
44         WETH = _WETH;
45         factories.push(_factory);
46         fees.push(_fee);
47     }
48 
49     function setFactoryAndFee(uint _id, address _factory, uint _fee) external onlyOwner {
50         require(_id > 0, "index 0 cannot be set");
51         if (_id < factories.length) {
52             factories[_id] = _factory;
53             fees[_id] = _fee;
54         } else {
55             require(_id == factories.length, "illegal idx");
56             factories.push(_factory);
57             fees.push(_fee);
58         }
59     }
60 
61     function delFactoryAndFee(uint _id) external onlyOwner {
62         require(_id > 0, "index 0 cannot be set");
63         if (_id == factories.length - 1) {
64             factories.pop();
65             fees.pop();
66         } else {
67             factories[_id] = address(0);
68             fees[_id] = 0;
69         }
70     }
71 
72     function setTokenMinAmount(address _token, uint _amount) external onlyOwner {
73         tokenMinAmount[_token] = _amount;
74     }
75 
76     receive() external payable {
77         assert(msg.sender == WETH); // only accept ETH via fallback from the WETH contract
78     }
79 
80     function addLiquidity(
81         address tokenA,
82         address tokenB,
83         uint amountADesired,
84         uint amountBDesired,
85         uint amountAMin,
86         uint amountBMin,
87         address to,
88         uint deadline
89     ) external virtual override ensure(deadline) returns (uint amountA, uint amountB, uint liquidity) {
90         (bool success, ) = oldRouter.delegatecall(msg.data); 
91         assembly {
92             if eq(success, 0) {
93                 revert(0, 0)
94             }
95         }
96     }
97     function addLiquidityETH(
98         address token,
99         uint amountTokenDesired,
100         uint amountTokenMin,
101         uint amountETHMin,
102         address to,
103         uint deadline
104     ) external virtual override payable ensure(deadline) returns (uint amountToken, uint amountETH, uint liquidity) {
105         (bool success, ) = oldRouter.delegatecall(msg.data); 
106         assembly {
107             if eq(success, 0) {
108                 revert(0, 0)
109             }
110         }
111     }
112 
113     // **** REMOVE LIQUIDITY ****
114     function removeLiquidity(
115         address tokenA,
116         address tokenB,
117         uint liquidity,
118         uint amountAMin,
119         uint amountBMin,
120         address to,
121         uint deadline
122     ) public virtual override ensure(deadline) returns (uint amountA, uint amountB) {
123         (bool success, ) = oldRouter.delegatecall(msg.data); 
124         assembly {
125             if eq(success, 0) {
126                 revert(0, 0)
127             }
128         }
129     }
130     function removeLiquidityETH(
131         address token,
132         uint liquidity,
133         uint amountTokenMin,
134         uint amountETHMin,
135         address to,
136         uint deadline
137     ) public virtual override ensure(deadline) returns (uint amountToken, uint amountETH) {
138         (bool success, ) = oldRouter.delegatecall(msg.data); 
139         assembly {
140             if eq(success, 0) {
141                 revert(0, 0)
142             }
143         }
144     }
145     function removeLiquidityWithPermit(
146         address tokenA,
147         address tokenB,
148         uint liquidity,
149         uint amountAMin,
150         uint amountBMin,
151         address to,
152         uint deadline,
153         bool approveMax, uint8 v, bytes32 r, bytes32 s
154     ) external virtual override returns (uint amountA, uint amountB) {
155         (bool success, ) = oldRouter.delegatecall(msg.data); 
156         assembly {
157             if eq(success, 0) {
158                 revert(0, 0)
159             }
160         }
161     }
162     function removeLiquidityETHWithPermit(
163         address token,
164         uint liquidity,
165         uint amountTokenMin,
166         uint amountETHMin,
167         address to,
168         uint deadline,
169         bool approveMax, uint8 v, bytes32 r, bytes32 s
170     ) external virtual override returns (uint amountToken, uint amountETH) {
171         (bool success, ) = oldRouter.delegatecall(msg.data); 
172         assembly {
173             if eq(success, 0) {
174                 revert(0, 0)
175             }
176         }
177     }
178 
179     // **** REMOVE LIQUIDITY (supporting fee-on-transfer tokens) ****
180     function removeLiquidityETHSupportingFeeOnTransferTokens(
181         address token,
182         uint liquidity,
183         uint amountTokenMin,
184         uint amountETHMin,
185         address to,
186         uint deadline
187     ) public virtual override ensure(deadline) returns (uint amountETH) {
188         (bool success, ) = oldRouter.delegatecall(msg.data); 
189         assembly {
190             if eq(success, 0) {
191                 revert(0, 0)
192             }
193         }
194     }
195     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
196         address token,
197         uint liquidity,
198         uint amountTokenMin,
199         uint amountETHMin,
200         address to,
201         uint deadline,
202         bool approveMax, uint8 v, bytes32 r, bytes32 s
203     ) external virtual override returns (uint amountETH) {
204         (bool success, ) = oldRouter.delegatecall(msg.data); 
205         assembly {
206             if eq(success, 0) {
207                 revert(0, 0)
208             }
209         }
210     }
211 
212     // **** SWAP ****
213     // requires the initial amount to have already been sent to the first pair
214     function _swap(uint[] memory amounts, address[] memory path, address[] memory usedFactories, address _to) internal virtual {
215         for (uint i; i < path.length - 1; i++) {
216             (address input, address output) = (path[i], path[i + 1]);
217             (address token0,) = BabyLibrary.sortTokens(input, output);
218             uint amountOut = amounts[i + 1];
219             if (swapMining != address(0) && usedFactories[i] == factory) {
220                 ISwapMining(swapMining).swap(msg.sender, input, output, amountOut);
221             }
222             (uint amount0Out, uint amount1Out) = input == token0 ? (uint(0), amountOut) : (amountOut, uint(0));
223             address to = i < path.length - 2 ? BabyLibrary.pairFor(usedFactories[i + 2], output, path[i + 2]) : _to;
224             IBabyPair(BabyLibrary.pairFor(usedFactories[i + 1], input, output)).swap(
225                 amount0Out, amount1Out, to, new bytes(0)
226             );
227         }
228     }
229     function swapExactTokensForTokens(
230         uint amountIn,
231         uint amountOutMin,
232         address[] calldata path,
233         address to,
234         uint deadline
235     ) external virtual override ensure(deadline) returns (uint[] memory amounts) {
236         uint[] memory minAmounts = new uint[](path.length);
237         for (uint i = 0; i < path.length; i ++) {
238             minAmounts[i] = tokenMinAmount[path[i]];
239         }
240         address[] memory usedFactories;
241         (amounts, usedFactories) = BabyLibrary.getAggregationAmountsOut(factories, fees, minAmounts, amountIn, path);
242         require(amounts[amounts.length - 1] >= amountOutMin, 'BabyRouter: INSUFFICIENT_OUTPUT_AMOUNT');
243         TransferHelper.safeTransferFrom(
244             path[0], msg.sender, BabyLibrary.pairFor(usedFactories[0], path[0], path[1]), amounts[0]
245         );
246         _swap(amounts, path, usedFactories, to);
247     }
248     function swapTokensForExactTokens(
249         uint amountOut,
250         uint amountInMax,
251         address[] calldata path,
252         address to,
253         uint deadline
254     ) external virtual override ensure(deadline) returns (uint[] memory amounts) {
255         uint[] memory minAmounts = new uint[](path.length);
256         for (uint i = 0; i < path.length; i ++) {
257             minAmounts[i] = tokenMinAmount[path[i]];
258         }
259         address[] memory usedFactories;
260         (amounts, usedFactories) = BabyLibrary.getAggregationAmountsIn(factories, fees, minAmounts, amountOut, path);
261         require(amounts[0] <= amountInMax, 'BabyRouter: EXCESSIVE_INPUT_AMOUNT');
262         TransferHelper.safeTransferFrom(
263             path[0], msg.sender, BabyLibrary.pairFor(usedFactories[0], path[0], path[1]), amounts[0]
264         );
265         _swap(amounts, path, usedFactories, to);
266     }
267     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
268         external
269         virtual
270         override
271         payable
272         ensure(deadline)
273         returns (uint[] memory amounts)
274     {
275         uint[] memory minAmounts = new uint[](path.length);
276         for (uint i = 0; i < path.length; i ++) {
277             minAmounts[i] = tokenMinAmount[path[i]];
278         }
279         address[] memory usedFactories;
280         require(path[0] == WETH, 'BabyRouter: INVALID_PATH');
281         (amounts, usedFactories) = BabyLibrary.getAggregationAmountsOut(factories, fees, minAmounts, msg.value, path);
282         require(amounts[amounts.length - 1] >= amountOutMin, 'BabyRouter: INSUFFICIENT_OUTPUT_AMOUNT');
283         IWETH(WETH).deposit{value: amounts[0]}();
284         assert(IWETH(WETH).transfer(BabyLibrary.pairFor(usedFactories[0], path[0], path[1]), amounts[0]));
285         _swap(amounts, path, usedFactories, to);
286     }
287     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
288         external
289         virtual
290         override
291         ensure(deadline)
292         returns (uint[] memory amounts)
293     {
294         uint[] memory minAmounts = new uint[](path.length);
295         for (uint i = 0; i < path.length; i ++) {
296             minAmounts[i] = tokenMinAmount[path[i]];
297         }
298         address[] memory usedFactories;
299         require(path[path.length - 1] == WETH, 'BabyRouter: INVALID_PATH');
300         (amounts, usedFactories) = BabyLibrary.getAggregationAmountsIn(factories, fees, minAmounts, amountOut, path);
301         require(amounts[0] <= amountInMax, 'BabyRouter: EXCESSIVE_INPUT_AMOUNT');
302         TransferHelper.safeTransferFrom(
303             path[0], msg.sender, BabyLibrary.pairFor(usedFactories[0], path[0], path[1]), amounts[0]
304         );
305         _swap(amounts, path, usedFactories, address(this));
306         IWETH(WETH).withdraw(amounts[amounts.length - 1]);
307         TransferHelper.safeTransferETH(to, amounts[amounts.length - 1]);
308     }
309     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
310         external
311         virtual
312         override
313         ensure(deadline)
314         returns (uint[] memory amounts)
315     {
316         uint[] memory minAmounts = new uint[](path.length);
317         for (uint i = 0; i < path.length; i ++) {
318             minAmounts[i] = tokenMinAmount[path[i]];
319         }
320         address[] memory usedFactories;
321         require(path[path.length - 1] == WETH, 'BabyRouter: INVALID_PATH');
322         (amounts, usedFactories) = BabyLibrary.getAggregationAmountsOut(factories, fees, minAmounts, amountIn, path);
323         require(amounts[amounts.length - 1] >= amountOutMin, 'BabyRouter: INSUFFICIENT_OUTPUT_AMOUNT');
324         TransferHelper.safeTransferFrom(
325             path[0], msg.sender, BabyLibrary.pairFor(usedFactories[0], path[0], path[1]), amounts[0]
326         );
327         _swap(amounts, usedFactories, path, address(this));
328         IWETH(WETH).withdraw(amounts[amounts.length - 1]);
329         TransferHelper.safeTransferETH(to, amounts[amounts.length - 1]);
330     }
331     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
332         external
333         virtual
334         override
335         payable
336         ensure(deadline)
337         returns (uint[] memory amounts)
338     {
339         uint[] memory minAmounts = new uint[](path.length);
340         for (uint i = 0; i < path.length; i ++) {
341             minAmounts[i] = tokenMinAmount[path[i]];
342         }
343         address[] memory usedFactories;
344         require(path[0] == WETH, 'BabyRouter: INVALID_PATH');
345         (amounts, usedFactories) = BabyLibrary.getAggregationAmountsIn(factories, fees, minAmounts, amountOut, path);
346         require(amounts[0] <= msg.value, 'BabyRouter: EXCESSIVE_INPUT_AMOUNT');
347         IWETH(WETH).deposit{value: amounts[0]}();
348         assert(IWETH(WETH).transfer(BabyLibrary.pairFor(usedFactories[0], path[0], path[1]), amounts[0]));
349         _swap(amounts, usedFactories, path, to);
350         // refund dust eth, if any
351         if (msg.value > amounts[0]) TransferHelper.safeTransferETH(msg.sender, msg.value - amounts[0]);
352     }
353 
354     function getReserve(IBabyPair pair, address token0, address token1) internal view returns(uint reserve0, uint reserve1, address token) {
355         (token,) = BabyLibrary.sortTokens(token0, token1);
356         (uint _reserve0, uint _reserve1,) = pair.getReserves();
357         (reserve0, reserve1) = token0 == token ? (_reserve0, _reserve1) : (_reserve1, _reserve0);
358     }
359 
360     // **** SWAP (supporting fee-on-transfer tokens) ****
361     // requires the initial amount to have already been sent to the first pair
362     function _swapSupportingFeeOnTransferTokens(address[] memory path, address[] memory pairs, uint[] memory usedFees, address _to) internal virtual {
363         for (uint i; i < path.length - 1; i++) {
364             (address input, address output) = (path[i], path[i + 1]);
365             (uint reserveInput, uint reserveOutput, address token0) = getReserve(IBabyPair(pairs[i + 1]), input, output);
366             uint amountInput;
367             uint amountOutput;
368             { // scope to avoid stack too deep errors
369             amountInput = IERC20(input).balanceOf(address(pairs[i + 1])).sub(reserveInput);
370             amountOutput = BabyLibrary.getAmountOutWithFee(amountInput, reserveInput, reserveOutput, usedFees[i + 1]);
371             }
372             if (swapMining != address(0) && IBabyPair(pairs[i + 1]).factory() == factory) {
373                 ISwapMining(swapMining).swap(msg.sender, input, output, amountOutput);
374             }
375             (uint amount0Out, uint amount1Out) = input == token0 ? (uint(0), amountOutput) : (amountOutput, uint(0));
376             address to = i < path.length - 2 ? pairs[i + 2] : _to;
377             IBabyPair(pairs[i + 1]).swap(amount0Out, amount1Out, to, new bytes(0));
378         }
379     }
380 
381     function getPairs(address[] calldata path) internal view returns (address[] memory pairs, uint[] memory usedFees) {
382         uint[] memory minAmounts = new uint[](path.length);
383         for (uint i = 0; i < path.length; i ++) {
384             minAmounts[i] = tokenMinAmount[path[i]];
385         }
386         for (uint i = 0; i < path.length - 1; i ++) {
387             (address input, address output) = (path[i], path[i + 1]);
388             (address token0,) = BabyLibrary.sortTokens(input, output);
389             uint j = 0;
390             for (; j < factories.length; j ++) {
391                 IBabyPair pair = IBabyPair(BabyLibrary.pairFor(factories[j], path[i], path[i + 1]));
392                 (uint reserve0, uint reserve1,) = pair.getReserves();
393                 (uint reserveInput, uint reserveOutput) = input == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
394                 if (reserveInput >= minAmounts[i] && reserveOutput >= minAmounts[i + 1]) {
395                     pairs[i + 1] = address(pair);
396                     usedFees[i + 1] = fees[j];
397                     break;
398                 }
399             }
400             if (j == factories.length) {
401                 pairs[i + 1] = BabyLibrary.pairFor(factories[0], path[i], path[i + 1]); 
402                 usedFees[i + 1] = fees[0];
403             }
404         }
405     }
406 
407     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
408         uint amountIn,
409         uint amountOutMin,
410         address[] calldata path,
411         address to,
412         uint deadline
413     ) external virtual override ensure(deadline) {
414         address[] memory pairs = new address[](path.length);
415         uint[] memory usedFees = new uint[](path.length);
416         (pairs, usedFees) = getPairs(path);
417         TransferHelper.safeTransferFrom(
418             path[0], msg.sender, pairs[1], amountIn
419         );
420         uint balanceBefore = IERC20(path[path.length - 1]).balanceOf(to);
421         _swapSupportingFeeOnTransferTokens(path, pairs, usedFees,  to);
422         require(
423             IERC20(path[path.length - 1]).balanceOf(to).sub(balanceBefore) >= amountOutMin,
424             'BabyRouter'
425         );
426     }
427     function swapExactETHForTokensSupportingFeeOnTransferTokens(
428         uint amountOutMin,
429         address[] calldata path,
430         address to,
431         uint deadline
432     )
433         external
434         virtual
435         override
436         payable
437         ensure(deadline)
438     {
439         require(path[0] == WETH, 'BabyRouter');
440         uint amountIn = msg.value;
441         IWETH(WETH).deposit{value: amountIn}();
442         address[] memory pairs = new address[](path.length);
443         uint[] memory usedFees = new uint[](path.length);
444         (pairs, usedFees) = getPairs(path);
445         assert(IWETH(WETH).transfer(pairs[1], amountIn));
446         uint balanceBefore = IERC20(path[path.length - 1]).balanceOf(to);
447         _swapSupportingFeeOnTransferTokens(path, pairs, usedFees, to);
448         require(
449             IERC20(path[path.length - 1]).balanceOf(to).sub(balanceBefore) >= amountOutMin,
450             'BabyRouter'
451         );
452     }
453     function swapExactTokensForETHSupportingFeeOnTransferTokens(
454         uint amountIn,
455         uint amountOutMin,
456         address[] calldata path,
457         address to,
458         uint deadline
459     )
460         external
461         virtual
462         override
463         ensure(deadline)
464     {
465         require(path[path.length - 1] == WETH, 'BabyRouter: INVALID_PATH');
466         address[] memory pairs = new address[](path.length);
467         uint[] memory usedFees = new uint[](path.length);
468         (pairs, usedFees) = getPairs(path);
469         TransferHelper.safeTransferFrom(
470             path[0], msg.sender, pairs[1], amountIn
471         );
472         _swapSupportingFeeOnTransferTokens(path, pairs, usedFees, address(this));
473         uint amountOut = IERC20(WETH).balanceOf(address(this));
474         require(amountOut >= amountOutMin, 'BabyRouter: INSUFFICIENT_OUTPUT_AMOUNT');
475         IWETH(WETH).withdraw(amountOut);
476         TransferHelper.safeTransferETH(to, amountOut);
477     }
478 
479     // **** LIBRARY FUNCTIONS ****
480     function quote(uint amountA, uint reserveA, uint reserveB) public pure virtual override returns (uint amountB) {
481         return BabyLibrary.quote(amountA, reserveA, reserveB);
482     }
483 
484     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut)
485         public
486         pure
487         virtual
488         override
489         returns (uint amountOut)
490     {
491         return BabyLibrary.getAmountOut(amountIn, reserveIn, reserveOut);
492     }
493 
494     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut)
495         public
496         pure
497         virtual
498         override
499         returns (uint amountIn)
500     {
501         return BabyLibrary.getAmountIn(amountOut, reserveIn, reserveOut);
502     }
503 
504     function getAmountsOut(uint amountIn, address[] memory path)
505         public
506         view
507         virtual
508         override
509         returns (uint[] memory amounts)
510     {
511         uint[] memory minAmounts = new uint[](path.length);
512         for (uint i = 0; i < path.length; i ++) {
513             minAmounts[i] = tokenMinAmount[path[i]];
514         }
515         (amounts, ) = BabyLibrary.getAggregationAmountsOut(factories, fees, minAmounts, amountIn, path);
516     }
517 
518     function getAmountsIn(uint amountOut, address[] memory path)
519         public
520         view
521         virtual
522         override
523         returns (uint[] memory amounts)
524     {
525         uint[] memory minAmounts = new uint[](path.length);
526         for (uint i = 0; i < path.length; i ++) {
527             minAmounts[i] = tokenMinAmount[path[i]];
528         }
529         (amounts, ) = BabyLibrary.getAggregationAmountsIn(factories, fees, minAmounts, amountOut, path);
530     }
531 }
