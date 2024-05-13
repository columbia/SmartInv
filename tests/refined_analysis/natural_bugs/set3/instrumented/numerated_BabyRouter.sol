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
24     address public immutable override WETH;
25     address public swapMining;
26 
27     modifier ensure(uint deadline) {
28         require(deadline >= block.timestamp, 'BabyRouter: EXPIRED');
29         _;
30     }
31 
32     function setSwapMining(address _swapMininng) public onlyOwner {
33         swapMining = _swapMininng;
34     }
35 
36     constructor(address _factory, address _WETH) {
37         factory = _factory;
38         WETH = _WETH;
39     }
40 
41     receive() external payable {
42         assert(msg.sender == WETH); // only accept ETH via fallback from the WETH contract
43     }
44 
45     // **** ADD LIQUIDITY ****
46     function _addLiquidity(
47         address tokenA,
48         address tokenB,
49         uint amountADesired,
50         uint amountBDesired,
51         uint amountAMin,
52         uint amountBMin
53     ) internal virtual returns (uint amountA, uint amountB) {
54         // create the pair if it doesn't exist yet
55         if (IBabyFactory(factory).getPair(tokenA, tokenB) == address(0)) {
56             IBabyFactory(factory).createPair(tokenA, tokenB);
57         }
58         (uint reserveA, uint reserveB) = BabyLibrary.getReserves(factory, tokenA, tokenB);
59         if (reserveA == 0 && reserveB == 0) {
60             (amountA, amountB) = (amountADesired, amountBDesired);
61         } else {
62             uint amountBOptimal = BabyLibrary.quote(amountADesired, reserveA, reserveB);
63             if (amountBOptimal <= amountBDesired) {
64                 require(amountBOptimal >= amountBMin, 'BabyRouter: INSUFFICIENT_B_AMOUNT');
65                 (amountA, amountB) = (amountADesired, amountBOptimal);
66             } else {
67                 uint amountAOptimal = BabyLibrary.quote(amountBDesired, reserveB, reserveA);
68                 assert(amountAOptimal <= amountADesired);
69                 require(amountAOptimal >= amountAMin, 'BabyRouter: INSUFFICIENT_A_AMOUNT');
70                 (amountA, amountB) = (amountAOptimal, amountBDesired);
71             }
72         }
73     }
74     function addLiquidity(
75         address tokenA,
76         address tokenB,
77         uint amountADesired,
78         uint amountBDesired,
79         uint amountAMin,
80         uint amountBMin,
81         address to,
82         uint deadline
83     ) external virtual override ensure(deadline) returns (uint amountA, uint amountB, uint liquidity) {
84         (amountA, amountB) = _addLiquidity(tokenA, tokenB, amountADesired, amountBDesired, amountAMin, amountBMin);
85         address pair = BabyLibrary.pairFor(factory, tokenA, tokenB);
86         TransferHelper.safeTransferFrom(tokenA, msg.sender, pair, amountA);
87         TransferHelper.safeTransferFrom(tokenB, msg.sender, pair, amountB);
88         liquidity = IBabyPair(pair).mint(to);
89     }
90     function addLiquidityETH(
91         address token,
92         uint amountTokenDesired,
93         uint amountTokenMin,
94         uint amountETHMin,
95         address to,
96         uint deadline
97     ) external virtual override payable ensure(deadline) returns (uint amountToken, uint amountETH, uint liquidity) {
98         (amountToken, amountETH) = _addLiquidity(
99             token,
100             WETH,
101             amountTokenDesired,
102             msg.value,
103             amountTokenMin,
104             amountETHMin
105         );
106         address pair = BabyLibrary.pairFor(factory, token, WETH);
107         TransferHelper.safeTransferFrom(token, msg.sender, pair, amountToken);
108         IWETH(WETH).deposit{value: amountETH}();
109         assert(IWETH(WETH).transfer(pair, amountETH));
110         liquidity = IBabyPair(pair).mint(to);
111         // refund dust eth, if any
112         if (msg.value > amountETH) TransferHelper.safeTransferETH(msg.sender, msg.value - amountETH);
113     }
114 
115     // **** REMOVE LIQUIDITY ****
116     function removeLiquidity(
117         address tokenA,
118         address tokenB,
119         uint liquidity,
120         uint amountAMin,
121         uint amountBMin,
122         address to,
123         uint deadline
124     ) public virtual override ensure(deadline) returns (uint amountA, uint amountB) {
125         address pair = BabyLibrary.pairFor(factory, tokenA, tokenB);
126         console.log("tet123");
127         IBabyPair(pair).transferFrom(msg.sender, pair, liquidity); // send liquidity to pair
128         console.log("tet1234");
129         (uint amount0, uint amount1) = IBabyPair(pair).burn(to);
130         (address token0,) = BabyLibrary.sortTokens(tokenA, tokenB);
131         (amountA, amountB) = tokenA == token0 ? (amount0, amount1) : (amount1, amount0);
132         require(amountA >= amountAMin, 'BabyRouter: INSUFFICIENT_A_AMOUNT');
133         require(amountB >= amountBMin, 'BabyRouter: INSUFFICIENT_B_AMOUNT');
134     }
135     function removeLiquidityETH(
136         address token,
137         uint liquidity,
138         uint amountTokenMin,
139         uint amountETHMin,
140         address to,
141         uint deadline
142     ) public virtual override ensure(deadline) returns (uint amountToken, uint amountETH) {
143         (amountToken, amountETH) = removeLiquidity(
144             token,
145             WETH,
146             liquidity,
147             amountTokenMin,
148             amountETHMin,
149             address(this),
150             deadline
151         );
152         TransferHelper.safeTransfer(token, to, amountToken);
153         IWETH(WETH).withdraw(amountETH);
154         TransferHelper.safeTransferETH(to, amountETH);
155     }
156     function removeLiquidityWithPermit(
157         address tokenA,
158         address tokenB,
159         uint liquidity,
160         uint amountAMin,
161         uint amountBMin,
162         address to,
163         uint deadline,
164         bool approveMax, uint8 v, bytes32 r, bytes32 s
165     ) external virtual override returns (uint amountA, uint amountB) {
166         address pair = BabyLibrary.pairFor(factory, tokenA, tokenB);
167         uint value = approveMax ? uint(-1) : liquidity;
168         IBabyPair(pair).permit(msg.sender, address(this), value, deadline, v, r, s);
169         (amountA, amountB) = removeLiquidity(tokenA, tokenB, liquidity, amountAMin, amountBMin, to, deadline);
170     }
171     function removeLiquidityETHWithPermit(
172         address token,
173         uint liquidity,
174         uint amountTokenMin,
175         uint amountETHMin,
176         address to,
177         uint deadline,
178         bool approveMax, uint8 v, bytes32 r, bytes32 s
179     ) external virtual override returns (uint amountToken, uint amountETH) {
180         address pair = BabyLibrary.pairFor(factory, token, WETH);
181         uint value = approveMax ? uint(-1) : liquidity;
182         IBabyPair(pair).permit(msg.sender, address(this), value, deadline, v, r, s);
183         (amountToken, amountETH) = removeLiquidityETH(token, liquidity, amountTokenMin, amountETHMin, to, deadline);
184     }
185 
186     // **** REMOVE LIQUIDITY (supporting fee-on-transfer tokens) ****
187     function removeLiquidityETHSupportingFeeOnTransferTokens(
188         address token,
189         uint liquidity,
190         uint amountTokenMin,
191         uint amountETHMin,
192         address to,
193         uint deadline
194     ) public virtual override ensure(deadline) returns (uint amountETH) {
195         (, amountETH) = removeLiquidity(
196             token,
197             WETH,
198             liquidity,
199             amountTokenMin,
200             amountETHMin,
201             address(this),
202             deadline
203         );
204         TransferHelper.safeTransfer(token, to, IERC20(token).balanceOf(address(this)));
205         IWETH(WETH).withdraw(amountETH);
206         TransferHelper.safeTransferETH(to, amountETH);
207     }
208     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
209         address token,
210         uint liquidity,
211         uint amountTokenMin,
212         uint amountETHMin,
213         address to,
214         uint deadline,
215         bool approveMax, uint8 v, bytes32 r, bytes32 s
216     ) external virtual override returns (uint amountETH) {
217         address pair = BabyLibrary.pairFor(factory, token, WETH);
218         uint value = approveMax ? uint(-1) : liquidity;
219         IBabyPair(pair).permit(msg.sender, address(this), value, deadline, v, r, s);
220         amountETH = removeLiquidityETHSupportingFeeOnTransferTokens(
221             token, liquidity, amountTokenMin, amountETHMin, to, deadline
222         );
223     }
224 
225     // **** SWAP ****
226     // requires the initial amount to have already been sent to the first pair
227     function _swap(uint[] memory amounts, address[] memory path, address _to) internal virtual {
228         for (uint i; i < path.length - 1; i++) {
229             (address input, address output) = (path[i], path[i + 1]);
230             (address token0,) = BabyLibrary.sortTokens(input, output);
231             uint amountOut = amounts[i + 1];
232             if (swapMining != address(0)) {
233                 ISwapMining(swapMining).swap(msg.sender, input, output, amountOut);
234             }
235             (uint amount0Out, uint amount1Out) = input == token0 ? (uint(0), amountOut) : (amountOut, uint(0));
236             address to = i < path.length - 2 ? BabyLibrary.pairFor(factory, output, path[i + 2]) : _to;
237             IBabyPair(BabyLibrary.pairFor(factory, input, output)).swap(
238                 amount0Out, amount1Out, to, new bytes(0)
239             );
240         }
241     }
242     function swapExactTokensForTokens(
243         uint amountIn,
244         uint amountOutMin,
245         address[] calldata path,
246         address to,
247         uint deadline
248     ) external virtual override ensure(deadline) returns (uint[] memory amounts) {
249         amounts = BabyLibrary.getAmountsOut(factory, amountIn, path);
250         require(amounts[amounts.length - 1] >= amountOutMin, 'BabyRouter: INSUFFICIENT_OUTPUT_AMOUNT');
251         TransferHelper.safeTransferFrom(
252             path[0], msg.sender, BabyLibrary.pairFor(factory, path[0], path[1]), amounts[0]
253         );
254         _swap(amounts, path, to);
255     }
256     function swapTokensForExactTokens(
257         uint amountOut,
258         uint amountInMax,
259         address[] calldata path,
260         address to,
261         uint deadline
262     ) external virtual override ensure(deadline) returns (uint[] memory amounts) {
263         amounts = BabyLibrary.getAmountsIn(factory, amountOut, path);
264         require(amounts[0] <= amountInMax, 'BabyRouter: EXCESSIVE_INPUT_AMOUNT');
265         TransferHelper.safeTransferFrom(
266             path[0], msg.sender, BabyLibrary.pairFor(factory, path[0], path[1]), amounts[0]
267         );
268         _swap(amounts, path, to);
269     }
270     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
271         external
272         virtual
273         override
274         payable
275         ensure(deadline)
276         returns (uint[] memory amounts)
277     {
278         require(path[0] == WETH, 'BabyRouter: INVALID_PATH');
279         amounts = BabyLibrary.getAmountsOut(factory, msg.value, path);
280         require(amounts[amounts.length - 1] >= amountOutMin, 'BabyRouter: INSUFFICIENT_OUTPUT_AMOUNT');
281         IWETH(WETH).deposit{value: amounts[0]}();
282         assert(IWETH(WETH).transfer(BabyLibrary.pairFor(factory, path[0], path[1]), amounts[0]));
283         _swap(amounts, path, to);
284     }
285     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
286         external
287         virtual
288         override
289         ensure(deadline)
290         returns (uint[] memory amounts)
291     {
292         require(path[path.length - 1] == WETH, 'BabyRouter: INVALID_PATH');
293         amounts = BabyLibrary.getAmountsIn(factory, amountOut, path);
294         require(amounts[0] <= amountInMax, 'BabyRouter: EXCESSIVE_INPUT_AMOUNT');
295         TransferHelper.safeTransferFrom(
296             path[0], msg.sender, BabyLibrary.pairFor(factory, path[0], path[1]), amounts[0]
297         );
298         _swap(amounts, path, address(this));
299         IWETH(WETH).withdraw(amounts[amounts.length - 1]);
300         TransferHelper.safeTransferETH(to, amounts[amounts.length - 1]);
301     }
302     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
303         external
304         virtual
305         override
306         ensure(deadline)
307         returns (uint[] memory amounts)
308     {
309         require(path[path.length - 1] == WETH, 'BabyRouter: INVALID_PATH');
310         amounts = BabyLibrary.getAmountsOut(factory, amountIn, path);
311         require(amounts[amounts.length - 1] >= amountOutMin, 'BabyRouter: INSUFFICIENT_OUTPUT_AMOUNT');
312         TransferHelper.safeTransferFrom(
313             path[0], msg.sender, BabyLibrary.pairFor(factory, path[0], path[1]), amounts[0]
314         );
315         _swap(amounts, path, address(this));
316         IWETH(WETH).withdraw(amounts[amounts.length - 1]);
317         TransferHelper.safeTransferETH(to, amounts[amounts.length - 1]);
318     }
319     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
320         external
321         virtual
322         override
323         payable
324         ensure(deadline)
325         returns (uint[] memory amounts)
326     {
327         require(path[0] == WETH, 'BabyRouter: INVALID_PATH');
328         amounts = BabyLibrary.getAmountsIn(factory, amountOut, path);
329         require(amounts[0] <= msg.value, 'BabyRouter: EXCESSIVE_INPUT_AMOUNT');
330         IWETH(WETH).deposit{value: amounts[0]}();
331         assert(IWETH(WETH).transfer(BabyLibrary.pairFor(factory, path[0], path[1]), amounts[0]));
332         _swap(amounts, path, to);
333         // refund dust eth, if any
334         if (msg.value > amounts[0]) TransferHelper.safeTransferETH(msg.sender, msg.value - amounts[0]);
335     }
336 
337     // **** SWAP (supporting fee-on-transfer tokens) ****
338     // requires the initial amount to have already been sent to the first pair
339     function _swapSupportingFeeOnTransferTokens(address[] memory path, address _to) internal virtual {
340         for (uint i; i < path.length - 1; i++) {
341             (address input, address output) = (path[i], path[i + 1]);
342             (address token0,) = BabyLibrary.sortTokens(input, output);
343             IBabyPair pair = IBabyPair(BabyLibrary.pairFor(factory, input, output));
344             uint amountInput;
345             uint amountOutput;
346             { // scope to avoid stack too deep errors
347             (uint reserve0, uint reserve1,) = pair.getReserves();
348             (uint reserveInput, uint reserveOutput) = input == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
349             amountInput = IERC20(input).balanceOf(address(pair)).sub(reserveInput);
350             amountOutput = BabyLibrary.getAmountOut(amountInput, reserveInput, reserveOutput);
351             }
352             if (swapMining != address(0)) {
353                 ISwapMining(swapMining).swap(msg.sender, input, output, amountOutput);
354             }
355             (uint amount0Out, uint amount1Out) = input == token0 ? (uint(0), amountOutput) : (amountOutput, uint(0));
356             address to = i < path.length - 2 ? BabyLibrary.pairFor(factory, output, path[i + 2]) : _to;
357             pair.swap(amount0Out, amount1Out, to, new bytes(0));
358         }
359     }
360     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
361         uint amountIn,
362         uint amountOutMin,
363         address[] calldata path,
364         address to,
365         uint deadline
366     ) external virtual override ensure(deadline) {
367         TransferHelper.safeTransferFrom(
368             path[0], msg.sender, BabyLibrary.pairFor(factory, path[0], path[1]), amountIn
369         );
370         uint balanceBefore = IERC20(path[path.length - 1]).balanceOf(to);
371         _swapSupportingFeeOnTransferTokens(path, to);
372         require(
373             IERC20(path[path.length - 1]).balanceOf(to).sub(balanceBefore) >= amountOutMin,
374             'BabyRouter: INSUFFICIENT_OUTPUT_AMOUNT'
375         );
376     }
377     function swapExactETHForTokensSupportingFeeOnTransferTokens(
378         uint amountOutMin,
379         address[] calldata path,
380         address to,
381         uint deadline
382     )
383         external
384         virtual
385         override
386         payable
387         ensure(deadline)
388     {
389         require(path[0] == WETH, 'BabyRouter: INVALID_PATH');
390         uint amountIn = msg.value;
391         IWETH(WETH).deposit{value: amountIn}();
392         assert(IWETH(WETH).transfer(BabyLibrary.pairFor(factory, path[0], path[1]), amountIn));
393         uint balanceBefore = IERC20(path[path.length - 1]).balanceOf(to);
394         _swapSupportingFeeOnTransferTokens(path, to);
395         require(
396             IERC20(path[path.length - 1]).balanceOf(to).sub(balanceBefore) >= amountOutMin,
397             'BabyRouter: INSUFFICIENT_OUTPUT_AMOUNT'
398         );
399     }
400     function swapExactTokensForETHSupportingFeeOnTransferTokens(
401         uint amountIn,
402         uint amountOutMin,
403         address[] calldata path,
404         address to,
405         uint deadline
406     )
407         external
408         virtual
409         override
410         ensure(deadline)
411     {
412         require(path[path.length - 1] == WETH, 'BabyRouter: INVALID_PATH');
413         TransferHelper.safeTransferFrom(
414             path[0], msg.sender, BabyLibrary.pairFor(factory, path[0], path[1]), amountIn
415         );
416         _swapSupportingFeeOnTransferTokens(path, address(this));
417         uint amountOut = IERC20(WETH).balanceOf(address(this));
418         require(amountOut >= amountOutMin, 'BabyRouter: INSUFFICIENT_OUTPUT_AMOUNT');
419         IWETH(WETH).withdraw(amountOut);
420         TransferHelper.safeTransferETH(to, amountOut);
421     }
422 
423     // **** LIBRARY FUNCTIONS ****
424     function quote(uint amountA, uint reserveA, uint reserveB) public pure virtual override returns (uint amountB) {
425         return BabyLibrary.quote(amountA, reserveA, reserveB);
426     }
427 
428     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut)
429         public
430         pure
431         virtual
432         override
433         returns (uint amountOut)
434     {
435         return BabyLibrary.getAmountOut(amountIn, reserveIn, reserveOut);
436     }
437 
438     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut)
439         public
440         pure
441         virtual
442         override
443         returns (uint amountIn)
444     {
445         return BabyLibrary.getAmountIn(amountOut, reserveIn, reserveOut);
446     }
447 
448     function getAmountsOut(uint amountIn, address[] memory path)
449         public
450         view
451         virtual
452         override
453         returns (uint[] memory amounts)
454     {
455         return BabyLibrary.getAmountsOut(factory, amountIn, path);
456     }
457 
458     function getAmountsIn(uint amountOut, address[] memory path)
459         public
460         view
461         virtual
462         override
463         returns (uint[] memory amounts)
464     {
465         return BabyLibrary.getAmountsIn(factory, amountOut, path);
466     }
467 }
