1 pragma solidity =0.6.6;
2 
3 import '@uniswap/v2-core/contracts/interfaces/IUniswapV2Factory.sol';
4 import '@uniswap/lib/contracts/libraries/TransferHelper.sol';
5 
6 import './interfaces/IUniswapV2Router02.sol';
7 import './libraries/UniswapV2Library.sol';
8 import './libraries/SafeMath.sol';
9 import './interfaces/IERC20.sol';
10 import './interfaces/IWETH.sol';
11 
12 contract UniswapV2Router02 is IUniswapV2Router02 {
13     using SafeMath for uint;
14 
15     address public immutable override factory;
16     address public immutable override WETH;
17 
18     modifier ensure(uint deadline) {
19         require(deadline >= block.timestamp, 'UniswapV2Router: EXPIRED');
20         _;
21     }
22 
23     constructor(address _factory, address _WETH) public {
24         factory = _factory;
25         WETH = _WETH;
26     }
27 
28     receive() external payable {
29         assert(msg.sender == WETH); // only accept ETH via fallback from the WETH contract
30     }
31 
32     // **** ADD LIQUIDITY ****
33     function _addLiquidity(
34         address tokenA,
35         address tokenB,
36         uint amountADesired,
37         uint amountBDesired,
38         uint amountAMin,
39         uint amountBMin
40     ) internal virtual returns (uint amountA, uint amountB) {
41         // create the pair if it doesn't exist yet
42         if (IUniswapV2Factory(factory).getPair(tokenA, tokenB) == address(0)) {
43             IUniswapV2Factory(factory).createPair(tokenA, tokenB);
44         }
45         (uint reserveA, uint reserveB) = UniswapV2Library.getReserves(factory, tokenA, tokenB);
46         if (reserveA == 0 && reserveB == 0) {
47             (amountA, amountB) = (amountADesired, amountBDesired);
48         } else {
49             uint amountBOptimal = UniswapV2Library.quote(amountADesired, reserveA, reserveB);
50             if (amountBOptimal <= amountBDesired) {
51                 require(amountBOptimal >= amountBMin, 'UniswapV2Router: INSUFFICIENT_B_AMOUNT');
52                 (amountA, amountB) = (amountADesired, amountBOptimal);
53             } else {
54                 uint amountAOptimal = UniswapV2Library.quote(amountBDesired, reserveB, reserveA);
55                 assert(amountAOptimal <= amountADesired);
56                 require(amountAOptimal >= amountAMin, 'UniswapV2Router: INSUFFICIENT_A_AMOUNT');
57                 (amountA, amountB) = (amountAOptimal, amountBDesired);
58             }
59         }
60     }
61     function addLiquidity(
62         address tokenA,
63         address tokenB,
64         uint amountADesired,
65         uint amountBDesired,
66         uint amountAMin,
67         uint amountBMin,
68         address to,
69         uint deadline
70     ) external virtual override ensure(deadline) returns (uint amountA, uint amountB, uint liquidity) {
71         (amountA, amountB) = _addLiquidity(tokenA, tokenB, amountADesired, amountBDesired, amountAMin, amountBMin);
72         address pair = UniswapV2Library.pairFor(factory, tokenA, tokenB);
73         TransferHelper.safeTransferFrom(tokenA, msg.sender, pair, amountA);
74         TransferHelper.safeTransferFrom(tokenB, msg.sender, pair, amountB);
75         liquidity = IUniswapV2Pair(pair).mint(to);
76     }
77     function addLiquidityETH(
78         address token,
79         uint amountTokenDesired,
80         uint amountTokenMin,
81         uint amountETHMin,
82         address to,
83         uint deadline
84     ) external virtual override payable ensure(deadline) returns (uint amountToken, uint amountETH, uint liquidity) {
85         (amountToken, amountETH) = _addLiquidity(
86             token,
87             WETH,
88             amountTokenDesired,
89             msg.value,
90             amountTokenMin,
91             amountETHMin
92         );
93         address pair = UniswapV2Library.pairFor(factory, token, WETH);
94         TransferHelper.safeTransferFrom(token, msg.sender, pair, amountToken);
95         IWETH(WETH).deposit{value: amountETH}();
96         assert(IWETH(WETH).transfer(pair, amountETH));
97         liquidity = IUniswapV2Pair(pair).mint(to);
98         // refund dust eth, if any
99         if (msg.value > amountETH) TransferHelper.safeTransferETH(msg.sender, msg.value - amountETH);
100     }
101 
102     // **** REMOVE LIQUIDITY ****
103     function removeLiquidity(
104         address tokenA,
105         address tokenB,
106         uint liquidity,
107         uint amountAMin,
108         uint amountBMin,
109         address to,
110         uint deadline
111     ) public virtual override ensure(deadline) returns (uint amountA, uint amountB) {
112         address pair = UniswapV2Library.pairFor(factory, tokenA, tokenB);
113         IUniswapV2Pair(pair).transferFrom(msg.sender, pair, liquidity); // send liquidity to pair
114         (uint amount0, uint amount1) = IUniswapV2Pair(pair).burn(to);
115         (address token0,) = UniswapV2Library.sortTokens(tokenA, tokenB);
116         (amountA, amountB) = tokenA == token0 ? (amount0, amount1) : (amount1, amount0);
117         require(amountA >= amountAMin, 'UniswapV2Router: INSUFFICIENT_A_AMOUNT');
118         require(amountB >= amountBMin, 'UniswapV2Router: INSUFFICIENT_B_AMOUNT');
119     }
120     function removeLiquidityETH(
121         address token,
122         uint liquidity,
123         uint amountTokenMin,
124         uint amountETHMin,
125         address to,
126         uint deadline
127     ) public virtual override ensure(deadline) returns (uint amountToken, uint amountETH) {
128         (amountToken, amountETH) = removeLiquidity(
129             token,
130             WETH,
131             liquidity,
132             amountTokenMin,
133             amountETHMin,
134             address(this),
135             deadline
136         );
137         TransferHelper.safeTransfer(token, to, amountToken);
138         IWETH(WETH).withdraw(amountETH);
139         TransferHelper.safeTransferETH(to, amountETH);
140     }
141     function removeLiquidityWithPermit(
142         address tokenA,
143         address tokenB,
144         uint liquidity,
145         uint amountAMin,
146         uint amountBMin,
147         address to,
148         uint deadline,
149         bool approveMax, uint8 v, bytes32 r, bytes32 s
150     ) external virtual override returns (uint amountA, uint amountB) {
151         address pair = UniswapV2Library.pairFor(factory, tokenA, tokenB);
152         uint value = approveMax ? uint(-1) : liquidity;
153         IUniswapV2Pair(pair).permit(msg.sender, address(this), value, deadline, v, r, s);
154         (amountA, amountB) = removeLiquidity(tokenA, tokenB, liquidity, amountAMin, amountBMin, to, deadline);
155     }
156     function removeLiquidityETHWithPermit(
157         address token,
158         uint liquidity,
159         uint amountTokenMin,
160         uint amountETHMin,
161         address to,
162         uint deadline,
163         bool approveMax, uint8 v, bytes32 r, bytes32 s
164     ) external virtual override returns (uint amountToken, uint amountETH) {
165         address pair = UniswapV2Library.pairFor(factory, token, WETH);
166         uint value = approveMax ? uint(-1) : liquidity;
167         IUniswapV2Pair(pair).permit(msg.sender, address(this), value, deadline, v, r, s);
168         (amountToken, amountETH) = removeLiquidityETH(token, liquidity, amountTokenMin, amountETHMin, to, deadline);
169     }
170 
171     // **** REMOVE LIQUIDITY (supporting fee-on-transfer tokens) ****
172     function removeLiquidityETHSupportingFeeOnTransferTokens(
173         address token,
174         uint liquidity,
175         uint amountTokenMin,
176         uint amountETHMin,
177         address to,
178         uint deadline
179     ) public virtual override ensure(deadline) returns (uint amountETH) {
180         (, amountETH) = removeLiquidity(
181             token,
182             WETH,
183             liquidity,
184             amountTokenMin,
185             amountETHMin,
186             address(this),
187             deadline
188         );
189         TransferHelper.safeTransfer(token, to, IERC20(token).balanceOf(address(this)));
190         IWETH(WETH).withdraw(amountETH);
191         TransferHelper.safeTransferETH(to, amountETH);
192     }
193     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
194         address token,
195         uint liquidity,
196         uint amountTokenMin,
197         uint amountETHMin,
198         address to,
199         uint deadline,
200         bool approveMax, uint8 v, bytes32 r, bytes32 s
201     ) external virtual override returns (uint amountETH) {
202         address pair = UniswapV2Library.pairFor(factory, token, WETH);
203         uint value = approveMax ? uint(-1) : liquidity;
204         IUniswapV2Pair(pair).permit(msg.sender, address(this), value, deadline, v, r, s);
205         amountETH = removeLiquidityETHSupportingFeeOnTransferTokens(
206             token, liquidity, amountTokenMin, amountETHMin, to, deadline
207         );
208     }
209 
210     // **** SWAP ****
211     // requires the initial amount to have already been sent to the first pair
212     function _swap(uint[] memory amounts, address[] memory path, address _to) internal virtual {
213         for (uint i; i < path.length - 1; i++) {
214             (address input, address output) = (path[i], path[i + 1]);
215             (address token0,) = UniswapV2Library.sortTokens(input, output);
216             uint amountOut = amounts[i + 1];
217             (uint amount0Out, uint amount1Out) = input == token0 ? (uint(0), amountOut) : (amountOut, uint(0));
218             address to = i < path.length - 2 ? UniswapV2Library.pairFor(factory, output, path[i + 2]) : _to;
219             IUniswapV2Pair(UniswapV2Library.pairFor(factory, input, output)).swap(
220                 amount0Out, amount1Out, to, new bytes(0)
221             );
222         }
223     }
224     function swapExactTokensForTokens(
225         uint amountIn,
226         uint amountOutMin,
227         address[] calldata path,
228         address to,
229         uint deadline
230     ) external virtual override ensure(deadline) returns (uint[] memory amounts) {
231         amounts = UniswapV2Library.getAmountsOut(factory, amountIn, path);
232         require(amounts[amounts.length - 1] >= amountOutMin, 'UniswapV2Router: INSUFFICIENT_OUTPUT_AMOUNT');
233         TransferHelper.safeTransferFrom(
234             path[0], msg.sender, UniswapV2Library.pairFor(factory, path[0], path[1]), amounts[0]
235         );
236         _swap(amounts, path, to);
237     }
238     function swapTokensForExactTokens(
239         uint amountOut,
240         uint amountInMax,
241         address[] calldata path,
242         address to,
243         uint deadline
244     ) external virtual override ensure(deadline) returns (uint[] memory amounts) {
245         amounts = UniswapV2Library.getAmountsIn(factory, amountOut, path);
246         require(amounts[0] <= amountInMax, 'UniswapV2Router: EXCESSIVE_INPUT_AMOUNT');
247         TransferHelper.safeTransferFrom(
248             path[0], msg.sender, UniswapV2Library.pairFor(factory, path[0], path[1]), amounts[0]
249         );
250         _swap(amounts, path, to);
251     }
252     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
253         external
254         virtual
255         override
256         payable
257         ensure(deadline)
258         returns (uint[] memory amounts)
259     {
260         require(path[0] == WETH, 'UniswapV2Router: INVALID_PATH');
261         amounts = UniswapV2Library.getAmountsOut(factory, msg.value, path);
262         require(amounts[amounts.length - 1] >= amountOutMin, 'UniswapV2Router: INSUFFICIENT_OUTPUT_AMOUNT');
263         IWETH(WETH).deposit{value: amounts[0]}();
264         assert(IWETH(WETH).transfer(UniswapV2Library.pairFor(factory, path[0], path[1]), amounts[0]));
265         _swap(amounts, path, to);
266     }
267     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
268         external
269         virtual
270         override
271         ensure(deadline)
272         returns (uint[] memory amounts)
273     {
274         require(path[path.length - 1] == WETH, 'UniswapV2Router: INVALID_PATH');
275         amounts = UniswapV2Library.getAmountsIn(factory, amountOut, path);
276         require(amounts[0] <= amountInMax, 'UniswapV2Router: EXCESSIVE_INPUT_AMOUNT');
277         TransferHelper.safeTransferFrom(
278             path[0], msg.sender, UniswapV2Library.pairFor(factory, path[0], path[1]), amounts[0]
279         );
280         _swap(amounts, path, address(this));
281         IWETH(WETH).withdraw(amounts[amounts.length - 1]);
282         TransferHelper.safeTransferETH(to, amounts[amounts.length - 1]);
283     }
284     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
285         external
286         virtual
287         override
288         ensure(deadline)
289         returns (uint[] memory amounts)
290     {
291         require(path[path.length - 1] == WETH, 'UniswapV2Router: INVALID_PATH');
292         amounts = UniswapV2Library.getAmountsOut(factory, amountIn, path);
293         require(amounts[amounts.length - 1] >= amountOutMin, 'UniswapV2Router: INSUFFICIENT_OUTPUT_AMOUNT');
294         TransferHelper.safeTransferFrom(
295             path[0], msg.sender, UniswapV2Library.pairFor(factory, path[0], path[1]), amounts[0]
296         );
297         _swap(amounts, path, address(this));
298         IWETH(WETH).withdraw(amounts[amounts.length - 1]);
299         TransferHelper.safeTransferETH(to, amounts[amounts.length - 1]);
300     }
301     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
302         external
303         virtual
304         override
305         payable
306         ensure(deadline)
307         returns (uint[] memory amounts)
308     {
309         require(path[0] == WETH, 'UniswapV2Router: INVALID_PATH');
310         amounts = UniswapV2Library.getAmountsIn(factory, amountOut, path);
311         require(amounts[0] <= msg.value, 'UniswapV2Router: EXCESSIVE_INPUT_AMOUNT');
312         IWETH(WETH).deposit{value: amounts[0]}();
313         assert(IWETH(WETH).transfer(UniswapV2Library.pairFor(factory, path[0], path[1]), amounts[0]));
314         _swap(amounts, path, to);
315         // refund dust eth, if any
316         if (msg.value > amounts[0]) TransferHelper.safeTransferETH(msg.sender, msg.value - amounts[0]);
317     }
318 
319     // **** SWAP (supporting fee-on-transfer tokens) ****
320     // requires the initial amount to have already been sent to the first pair
321     function _swapSupportingFeeOnTransferTokens(address[] memory path, address _to) internal virtual {
322         for (uint i; i < path.length - 1; i++) {
323             (address input, address output) = (path[i], path[i + 1]);
324             (address token0,) = UniswapV2Library.sortTokens(input, output);
325             IUniswapV2Pair pair = IUniswapV2Pair(UniswapV2Library.pairFor(factory, input, output));
326             uint amountInput;
327             uint amountOutput;
328             { // scope to avoid stack too deep errors
329             (uint reserve0, uint reserve1,) = pair.getReserves();
330             (uint reserveInput, uint reserveOutput) = input == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
331             amountInput = IERC20(input).balanceOf(address(pair)).sub(reserveInput);
332             amountOutput = UniswapV2Library.getAmountOut(amountInput, reserveInput, reserveOutput);
333             }
334             (uint amount0Out, uint amount1Out) = input == token0 ? (uint(0), amountOutput) : (amountOutput, uint(0));
335             address to = i < path.length - 2 ? UniswapV2Library.pairFor(factory, output, path[i + 2]) : _to;
336             pair.swap(amount0Out, amount1Out, to, new bytes(0));
337         }
338     }
339     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
340         uint amountIn,
341         uint amountOutMin,
342         address[] calldata path,
343         address to,
344         uint deadline
345     ) external virtual override ensure(deadline) {
346         TransferHelper.safeTransferFrom(
347             path[0], msg.sender, UniswapV2Library.pairFor(factory, path[0], path[1]), amountIn
348         );
349         uint balanceBefore = IERC20(path[path.length - 1]).balanceOf(to);
350         _swapSupportingFeeOnTransferTokens(path, to);
351         require(
352             IERC20(path[path.length - 1]).balanceOf(to).sub(balanceBefore) >= amountOutMin,
353             'UniswapV2Router: INSUFFICIENT_OUTPUT_AMOUNT'
354         );
355     }
356     function swapExactETHForTokensSupportingFeeOnTransferTokens(
357         uint amountOutMin,
358         address[] calldata path,
359         address to,
360         uint deadline
361     )
362         external
363         virtual
364         override
365         payable
366         ensure(deadline)
367     {
368         require(path[0] == WETH, 'UniswapV2Router: INVALID_PATH');
369         uint amountIn = msg.value;
370         IWETH(WETH).deposit{value: amountIn}();
371         assert(IWETH(WETH).transfer(UniswapV2Library.pairFor(factory, path[0], path[1]), amountIn));
372         uint balanceBefore = IERC20(path[path.length - 1]).balanceOf(to);
373         _swapSupportingFeeOnTransferTokens(path, to);
374         require(
375             IERC20(path[path.length - 1]).balanceOf(to).sub(balanceBefore) >= amountOutMin,
376             'UniswapV2Router: INSUFFICIENT_OUTPUT_AMOUNT'
377         );
378     }
379     function swapExactTokensForETHSupportingFeeOnTransferTokens(
380         uint amountIn,
381         uint amountOutMin,
382         address[] calldata path,
383         address to,
384         uint deadline
385     )
386         external
387         virtual
388         override
389         ensure(deadline)
390     {
391         require(path[path.length - 1] == WETH, 'UniswapV2Router: INVALID_PATH');
392         TransferHelper.safeTransferFrom(
393             path[0], msg.sender, UniswapV2Library.pairFor(factory, path[0], path[1]), amountIn
394         );
395         _swapSupportingFeeOnTransferTokens(path, address(this));
396         uint amountOut = IERC20(WETH).balanceOf(address(this));
397         require(amountOut >= amountOutMin, 'UniswapV2Router: INSUFFICIENT_OUTPUT_AMOUNT');
398         IWETH(WETH).withdraw(amountOut);
399         TransferHelper.safeTransferETH(to, amountOut);
400     }
401 
402     // **** LIBRARY FUNCTIONS ****
403     function quote(uint amountA, uint reserveA, uint reserveB) public pure virtual override returns (uint amountB) {
404         return UniswapV2Library.quote(amountA, reserveA, reserveB);
405     }
406 
407     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut)
408         public
409         pure
410         virtual
411         override
412         returns (uint amountOut)
413     {
414         return UniswapV2Library.getAmountOut(amountIn, reserveIn, reserveOut);
415     }
416 
417     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut)
418         public
419         pure
420         virtual
421         override
422         returns (uint amountIn)
423     {
424         return UniswapV2Library.getAmountIn(amountOut, reserveIn, reserveOut);
425     }
426 
427     function getAmountsOut(uint amountIn, address[] memory path)
428         public
429         view
430         virtual
431         override
432         returns (uint[] memory amounts)
433     {
434         return UniswapV2Library.getAmountsOut(factory, amountIn, path);
435     }
436 
437     function getAmountsIn(uint amountOut, address[] memory path)
438         public
439         view
440         virtual
441         override
442         returns (uint[] memory amounts)
443     {
444         return UniswapV2Library.getAmountsIn(factory, amountOut, path);
445     }
446 }
