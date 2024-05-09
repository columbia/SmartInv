1 // SPDX-License-Identifier: GPL-2.0-or-later
2 pragma solidity >=0.8.0;
3 
4 // Sources flattened with hardhat v2.10.1 https://hardhat.org
5 
6 // File contracts/Fraxswap/core/interfaces/IUniswapV2FactoryV5.sol
7 
8 
9 interface IUniswapV2FactoryV5 {
10     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
11 
12     function feeTo() external view returns (address);
13     function feeToSetter() external view returns (address);
14     function globalPause() external view returns (bool);
15 
16     function getPair(address tokenA, address tokenB) external view returns (address pair);
17     function allPairs(uint) external view returns (address pair);
18     function allPairsLength() external view returns (uint);
19 
20     function createPair(address tokenA, address tokenB) external returns (address pair);
21     function createPair(address tokenA, address tokenB, uint fee) external returns (address pair);
22 
23     function setFeeTo(address) external;
24     function setFeeToSetter(address) external;
25     function toggleGlobalPause() external;
26 }
27 
28 
29 // File contracts/Fraxswap/core/interfaces/IUniswapV2PairV5.sol
30 
31 
32 interface IUniswapV2PairV5 {
33     event Approval(address indexed owner, address indexed spender, uint value);
34     event Transfer(address indexed from, address indexed to, uint value);
35 
36     function name() external pure returns (string memory);
37     function symbol() external pure returns (string memory);
38     function decimals() external pure returns (uint8);
39     function totalSupply() external view returns (uint);
40     function balanceOf(address owner) external view returns (uint);
41     function allowance(address owner, address spender) external view returns (uint);
42 
43     function approve(address spender, uint value) external returns (bool);
44     function transfer(address to, uint value) external returns (bool);
45     function transferFrom(address from, address to, uint value) external returns (bool);
46 
47     function DOMAIN_SEPARATOR() external view returns (bytes32);
48     function PERMIT_TYPEHASH() external pure returns (bytes32);
49     function nonces(address owner) external view returns (uint);
50 
51     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
52 
53     event Mint(address indexed sender, uint amount0, uint amount1);
54     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
55     event Swap(
56         address indexed sender,
57         uint amount0In,
58         uint amount1In,
59         uint amount0Out,
60         uint amount1Out,
61         address indexed to
62     );
63     event Sync(uint112 reserve0, uint112 reserve1);
64 
65     function MINIMUM_LIQUIDITY() external pure returns (uint);
66     function factory() external view returns (address);
67     function token0() external view returns (address);
68     function token1() external view returns (address);
69     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
70     function price0CumulativeLast() external view returns (uint);
71     function price1CumulativeLast() external view returns (uint);
72     function kLast() external view returns (uint);
73 
74     function mint(address to) external returns (uint liquidity);
75     function burn(address to) external returns (uint amount0, uint amount1);
76     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
77     function skim(address to) external;
78     function sync() external;
79     function initialize(address, address) external;
80 }
81 
82 
83 // File contracts/Fraxswap/core/interfaces/IFraxswapPair.sol
84 
85 
86 // ====================================================================
87 // |     ______                   _______                             |
88 // |    / _____________ __  __   / ____(_____  ____ _____  ________   |
89 // |   / /_  / ___/ __ `| |/_/  / /_  / / __ \/ __ `/ __ \/ ___/ _ \  |
90 // |  / __/ / /  / /_/ _>  <   / __/ / / / / / /_/ / / / / /__/  __/  |
91 // | /_/   /_/   \__,_/_/|_|  /_/   /_/_/ /_/\__,_/_/ /_/\___/\___/   |
92 // |                                                                  |
93 // ====================================================================
94 // ========================= IFraxswapPair ==========================
95 // ====================================================================
96 // Fraxswap LP Pair Interface
97 // Inspired by https://www.paradigm.xyz/2021/07/twamm
98 // https://github.com/para-dave/twamm
99 
100 // Frax Finance: https://github.com/FraxFinance
101 
102 // Primary Author(s)
103 // Rich Gee: https://github.com/zer0blockchain
104 // Dennis: https://github.com/denett
105 
106 // Reviewer(s) / Contributor(s)
107 // Travis Moore: https://github.com/FortisFortuna
108 // Sam Kazemian: https://github.com/samkazemian
109 
110 interface IFraxswapPair is IUniswapV2PairV5 {
111     // TWAMM
112 
113     event LongTermSwap0To1(address indexed addr, uint256 orderId, uint256 amount0In, uint256 numberOfTimeIntervals);
114     event LongTermSwap1To0(address indexed addr, uint256 orderId, uint256 amount1In, uint256 numberOfTimeIntervals);
115     event CancelLongTermOrder(address indexed addr, uint256 orderId, address sellToken, uint256 unsoldAmount, address buyToken, uint256 purchasedAmount);
116     event WithdrawProceedsFromLongTermOrder(address indexed addr, uint256 orderId, address indexed proceedToken, uint256 proceeds, bool orderExpired);
117     
118     function fee() external view returns (uint);
119 
120     function longTermSwapFrom0To1(uint256 amount0In, uint256 numberOfTimeIntervals) external returns (uint256 orderId);
121     function longTermSwapFrom1To0(uint256 amount1In, uint256 numberOfTimeIntervals) external returns (uint256 orderId);
122     function cancelLongTermSwap(uint256 orderId) external;
123     function withdrawProceedsFromLongTermSwap(uint256 orderId) external returns (bool is_expired, address rewardTkn, uint256 totalReward);
124     function executeVirtualOrders(uint256 blockTimestamp) external;
125 
126     function getAmountOut(uint amountIn, address tokenIn) external view returns (uint);
127     function getAmountIn(uint amountOut, address tokenOut) external view returns (uint);
128 
129     function orderTimeInterval() external returns (uint256);
130     function getTWAPHistoryLength() external view returns (uint);
131     function getTwammReserves() external view returns (uint112 _reserve0, uint112 _reserve1, uint32 _blockTimestampLast, uint112 _twammReserve0, uint112 _twammReserve1, uint256 _fee);
132     function getReserveAfterTwamm(uint256 blockTimestamp) external view returns (uint112 _reserve0, uint112 _reserve1, uint256 lastVirtualOrderTimestamp, uint112 _twammReserve0, uint112 _twammReserve1);
133     function getNextOrderID() external view returns (uint256);
134     function getOrderIDsForUser(address user) external view returns (uint256[] memory);
135     function getOrderIDsForUserLength(address user) external view returns (uint256);
136 //    function getDetailedOrdersForUser(address user, uint256 offset, uint256 limit) external view returns (LongTermOrdersLib.Order[] memory detailed_orders);
137     function twammUpToDate() external view returns (bool);
138     function getTwammState() external view returns (uint256 token0Rate, uint256 token1Rate, uint256 lastVirtualOrderTimestamp, uint256 orderTimeInterval_rtn, uint256 rewardFactorPool0, uint256 rewardFactorPool1);
139     function getTwammSalesRateEnding(uint256 _blockTimestamp) external view returns (uint256 orderPool0SalesRateEnding, uint256 orderPool1SalesRateEnding);
140     function getTwammRewardFactor(uint256 _blockTimestamp) external view returns (uint256 rewardFactorPool0AtTimestamp, uint256 rewardFactorPool1AtTimestamp);
141     function getTwammOrder(uint256 orderId) external view returns (uint256 id, uint256 creationTimestamp, uint256 expirationTimestamp, uint256 saleRate, address owner, address sellTokenAddr, address buyTokenAddr);
142     function getTwammOrderProceedsView(uint256 orderId, uint256 blockTimestamp) external view returns (bool orderExpired, uint256 totalReward);
143     function getTwammOrderProceeds(uint256 orderId) external returns (bool orderExpired, uint256 totalReward);
144 
145 
146     function togglePauseNewSwaps() external;
147 }
148 
149 
150 // File contracts/Fraxswap/libraries/TransferHelper.sol
151 
152 
153 
154 // helper methods for interacting with ERC20 tokens and sending ETH that do not consistently return true/false
155 library TransferHelper {
156     function safeApprove(
157         address token,
158         address to,
159         uint256 value
160     ) internal {
161         // bytes4(keccak256(bytes('approve(address,uint256)')));
162         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x095ea7b3, to, value));
163         require(
164             success && (data.length == 0 || abi.decode(data, (bool))),
165             'TransferHelper::safeApprove: approve failed'
166         );
167     }
168 
169     function safeTransfer(
170         address token,
171         address to,
172         uint256 value
173     ) internal {
174         // bytes4(keccak256(bytes('transfer(address,uint256)')));
175         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));
176         require(
177             success && (data.length == 0 || abi.decode(data, (bool))),
178             'TransferHelper::safeTransfer: transfer failed'
179         );
180     }
181 
182     function safeTransferFrom(
183         address token,
184         address from,
185         address to,
186         uint256 value
187     ) internal {
188         // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
189         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));
190         require(
191             success && (data.length == 0 || abi.decode(data, (bool))),
192             'TransferHelper::transferFrom: transferFrom failed'
193         );
194     }
195 
196     function safeTransferETH(address to, uint256 value) internal {
197         (bool success, ) = to.call{value: value}(new bytes(0));
198         require(success, 'TransferHelper::safeTransferETH: ETH transfer failed');
199     }
200 }
201 
202 
203 // File contracts/Fraxswap/periphery/interfaces/IUniswapV2Router01V5.sol
204 
205 
206 interface IUniswapV2Router01V5 {
207     function factory() external view returns (address);
208     function WETH() external view returns (address);
209 
210     function addLiquidity(
211         address tokenA,
212         address tokenB,
213         uint amountADesired,
214         uint amountBDesired,
215         uint amountAMin,
216         uint amountBMin,
217         address to,
218         uint deadline
219     ) external returns (uint amountA, uint amountB, uint liquidity);
220     function addLiquidityETH(
221         address token,
222         uint amountTokenDesired,
223         uint amountTokenMin,
224         uint amountETHMin,
225         address to,
226         uint deadline
227     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
228     function removeLiquidity(
229         address tokenA,
230         address tokenB,
231         uint liquidity,
232         uint amountAMin,
233         uint amountBMin,
234         address to,
235         uint deadline
236     ) external returns (uint amountA, uint amountB);
237     function removeLiquidityETH(
238         address token,
239         uint liquidity,
240         uint amountTokenMin,
241         uint amountETHMin,
242         address to,
243         uint deadline
244     ) external returns (uint amountToken, uint amountETH);
245     function removeLiquidityWithPermit(
246         address tokenA,
247         address tokenB,
248         uint liquidity,
249         uint amountAMin,
250         uint amountBMin,
251         address to,
252         uint deadline,
253         bool approveMax, uint8 v, bytes32 r, bytes32 s
254     ) external returns (uint amountA, uint amountB);
255     function removeLiquidityETHWithPermit(
256         address token,
257         uint liquidity,
258         uint amountTokenMin,
259         uint amountETHMin,
260         address to,
261         uint deadline,
262         bool approveMax, uint8 v, bytes32 r, bytes32 s
263     ) external returns (uint amountToken, uint amountETH);
264     function swapExactTokensForTokens(
265         uint amountIn,
266         uint amountOutMin,
267         address[] calldata path,
268         address to,
269         uint deadline
270     ) external returns (uint[] memory amounts);
271     function swapTokensForExactTokens(
272         uint amountOut,
273         uint amountInMax,
274         address[] calldata path,
275         address to,
276         uint deadline
277     ) external returns (uint[] memory amounts);
278     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
279         external
280         payable
281         returns (uint[] memory amounts);
282     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
283         external
284         returns (uint[] memory amounts);
285     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
286         external
287         returns (uint[] memory amounts);
288     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
289         external
290         payable
291         returns (uint[] memory amounts);
292 
293     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
294     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
295     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
296     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
297     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
298 }
299 
300 
301 // File contracts/Fraxswap/periphery/interfaces/IUniswapV2Router02V5.sol
302 
303 
304 interface IUniswapV2Router02V5 is IUniswapV2Router01V5 {
305     function removeLiquidityETHSupportingFeeOnTransferTokens(
306         address token,
307         uint liquidity,
308         uint amountTokenMin,
309         uint amountETHMin,
310         address to,
311         uint deadline
312     ) external returns (uint amountETH);
313     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
314         address token,
315         uint liquidity,
316         uint amountTokenMin,
317         uint amountETHMin,
318         address to,
319         uint deadline,
320         bool approveMax, uint8 v, bytes32 r, bytes32 s
321     ) external returns (uint amountETH);
322 
323     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
324         uint amountIn,
325         uint amountOutMin,
326         address[] calldata path,
327         address to,
328         uint deadline
329     ) external;
330     function swapExactETHForTokensSupportingFeeOnTransferTokens(
331         uint amountOutMin,
332         address[] calldata path,
333         address to,
334         uint deadline
335     ) external payable;
336     function swapExactTokensForETHSupportingFeeOnTransferTokens(
337         uint amountIn,
338         uint amountOutMin,
339         address[] calldata path,
340         address to,
341         uint deadline
342     ) external;
343 }
344 
345 
346 // File contracts/Fraxswap/periphery/libraries/FraxswapRouterLibrary.sol
347 
348 
349 // ====================================================================
350 // |     ______                   _______                             |
351 // |    / _____________ __  __   / ____(_____  ____ _____  ________   |
352 // |   / /_  / ___/ __ `| |/_/  / /_  / / __ \/ __ `/ __ \/ ___/ _ \  |
353 // |  / __/ / /  / /_/ _>  <   / __/ / / / / / /_/ / / / / /__/  __/  |
354 // | /_/   /_/   \__,_/_/|_|  /_/   /_/_/ /_/\__,_/_/ /_/\___/\___/   |
355 // |                                                                  |
356 // ====================================================================
357 // ======================= FraxswapRouterLibrary ======================
358 // ====================================================================
359 // Fraxswap Router Library Functions
360 // Inspired by https://www.paradigm.xyz/2021/07/twamm
361 // https://github.com/para-dave/twamm
362 
363 // Frax Finance: https://github.com/FraxFinance
364 
365 // Primary Author(s)
366 // Rich Gee: https://github.com/zer0blockchain
367 // Dennis: https://github.com/denett
368 
369 // Logic / Algorithm Ideas
370 // FrankieIsLost: https://github.com/FrankieIsLost
371 
372 // Reviewer(s) / Contributor(s)
373 // Travis Moore: https://github.com/FortisFortuna
374 // Sam Kazemian: https://github.com/samkazemian
375 // Drake Evans: https://github.com/DrakeEvans
376 // Jack Corddry: https://github.com/corddry
377 // Justin Moore: https://github.com/0xJM
378 
379 library FraxswapRouterLibrary {
380 
381     // returns sorted token addresses, used to handle return values from pairs sorted in this order
382     function sortTokens(address tokenA, address tokenB) internal pure returns (address token0, address token1) {
383         require(tokenA != tokenB, 'FraxswapRouterLibrary: IDENTICAL_ADDRESSES');
384         (token0, token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
385         require(token0 != address(0), 'FraxswapRouterLibrary: ZERO_ADDRESS');
386     }
387 
388     // calculates the CREATE2 address for a pair without making any external calls
389     function pairFor(address factory, address tokenA, address tokenB) internal pure returns (address pair) {
390         (address token0, address token1) = sortTokens(tokenA, tokenB);
391         pair = address(uint160(uint(keccak256(abi.encodePacked(
392                 hex'ff',
393                 factory,
394                 keccak256(abi.encodePacked(token0, token1)),
395                 hex'4ce0b4ab368f39e4bd03ec712dfc405eb5a36cdb0294b3887b441cd1c743ced3' // init code / init hash
396             )))));
397     }
398 
399     // fetches and sorts the reserves for a pair
400     function getReserves(address factory, address tokenA, address tokenB) internal view returns (uint reserveA, uint reserveB) {
401         (address token0,) = sortTokens(tokenA, tokenB);
402 
403         (uint reserve0, uint reserve1,) = IFraxswapPair(pairFor(factory, tokenA, tokenB)).getReserves();
404 
405         (reserveA, reserveB) = tokenA == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
406     }
407 
408     function getReservesWithTwamm(address factory, address tokenA, address tokenB) internal returns (uint reserveA, uint reserveB, uint twammReserveA, uint twammReserveB) {
409         (address token0,) = sortTokens(tokenA, tokenB);
410 
411         IFraxswapPair pair = IFraxswapPair(pairFor(factory, tokenA, tokenB));
412 
413         pair.executeVirtualOrders(block.timestamp);
414 
415         (uint reserve0, uint reserve1,,uint twammReserve0, uint twammReserve1, ) = pair.getTwammReserves();
416 
417         (reserveA, reserveB, twammReserveA, twammReserveB) = tokenA == token0 ? (reserve0, reserve1, twammReserve0, twammReserve1) : (reserve1, reserve0, twammReserve1, twammReserve0);
418     }
419 
420     // given some amount of an asset and pair reserves, returns an equivalent amount of the other asset
421     function quote(uint amountA, uint reserveA, uint reserveB) internal pure returns (uint amountB) {
422         require(amountA > 0, 'FraxswapRouterLibrary: INSUFFICIENT_AMOUNT');
423         require(reserveA > 0 && reserveB > 0, 'FraxswapRouterLibrary: INSUFFICIENT_LIQUIDITY');
424         amountB = amountA * reserveB / reserveA;
425     }
426 
427     // performs chained getAmountOut calculations on any number of pairs
428     function getAmountsOut(address factory, uint amountIn, address[] memory path) internal view returns (uint[] memory amounts) {
429         require(path.length >= 2, 'FraxswapRouterLibrary: INVALID_PATH');
430         amounts = new uint[](path.length);
431         amounts[0] = amountIn;
432         for (uint i; i < path.length - 1; i++) {
433             IFraxswapPair pair = IFraxswapPair(FraxswapRouterLibrary.pairFor(factory, path[i], path[i + 1]));
434             require(pair.twammUpToDate(), 'twamm out of date');
435             amounts[i + 1] = pair.getAmountOut(amounts[i], path[i]);
436         }
437     }
438 
439     // performs chained getAmountIn calculations on any number of pairs
440     function getAmountsIn(address factory, uint amountOut, address[] memory path) internal view returns (uint[] memory amounts) {
441         require(path.length >= 2, 'FraxswapRouterLibrary: INVALID_PATH');
442         amounts = new uint[](path.length);
443         amounts[amounts.length - 1] = amountOut;
444         for (uint i = path.length - 1; i > 0; i--) {
445             IFraxswapPair pair = IFraxswapPair(FraxswapRouterLibrary.pairFor(factory, path[i - 1], path[i]));
446             require(pair.twammUpToDate(), 'twamm out of date');
447             amounts[i - 1] = pair.getAmountIn(amounts[i], path[i - 1]);
448         }
449     }
450 
451     // performs chained getAmountOut calculations on any number of pairs with Twamm
452     function getAmountsOutWithTwamm(address factory, uint amountIn, address[] memory path) internal returns (uint[] memory amounts) {
453         require(path.length >= 2, 'FraxswapRouterLibrary: INVALID_PATH');
454         amounts = new uint[](path.length);
455         amounts[0] = amountIn;
456         for (uint i; i < path.length - 1; i++) {
457             IFraxswapPair pair = IFraxswapPair(FraxswapRouterLibrary.pairFor(factory, path[i], path[i + 1]));
458             pair.executeVirtualOrders(block.timestamp);
459             amounts[i + 1] = pair.getAmountOut(amounts[i], path[i]);
460         }
461     }
462 
463     // performs chained getAmountIn calculations on any number of pairs with Twamm
464     function getAmountsInWithTwamm(address factory, uint amountOut, address[] memory path) internal returns (uint[] memory amounts) {
465         require(path.length >= 2, 'FraxswapRouterLibrary: INVALID_PATH');
466         amounts = new uint[](path.length);
467         amounts[amounts.length - 1] = amountOut;
468         for (uint i = path.length - 1; i > 0; i--) {
469             IFraxswapPair pair = IFraxswapPair(FraxswapRouterLibrary.pairFor(factory, path[i - 1], path[i]));
470             pair.executeVirtualOrders(block.timestamp);
471             amounts[i - 1] = pair.getAmountIn(amounts[i], path[i - 1]);
472         }
473     }
474 }
475 
476 
477 // File contracts/Fraxswap/periphery/interfaces/IERC20.sol
478 
479 
480 interface IERC20 {
481     event Approval(address indexed owner, address indexed spender, uint value);
482     event Transfer(address indexed from, address indexed to, uint value);
483 
484     function name() external view returns (string memory);
485     function symbol() external view returns (string memory);
486     function decimals() external view returns (uint8);
487     function totalSupply() external view returns (uint);
488     function balanceOf(address owner) external view returns (uint);
489     function allowance(address owner, address spender) external view returns (uint);
490 
491     function approve(address spender, uint value) external returns (bool);
492     function transfer(address to, uint value) external returns (bool);
493     function transferFrom(address from, address to, uint value) external returns (bool);
494 }
495 
496 
497 // File contracts/Fraxswap/periphery/interfaces/IWETH.sol
498 
499 
500 interface IWETH {
501     function deposit() external payable;
502     function transfer(address to, uint value) external returns (bool);
503     function withdraw(uint) external;
504 }
505 
506 
507 // File contracts/Fraxswap/periphery/FraxswapRouter.sol
508 
509 
510 // ====================================================================
511 // |     ______                   _______                             |
512 // |    / _____________ __  __   / ____(_____  ____ _____  ________   |
513 // |   / /_  / ___/ __ `| |/_/  / /_  / / __ \/ __ `/ __ \/ ___/ _ \  |
514 // |  / __/ / /  / /_/ _>  <   / __/ / / / / / /_/ / / / / /__/  __/  |
515 // | /_/   /_/   \__,_/_/|_|  /_/   /_/_/ /_/\__,_/_/ /_/\___/\___/   |
516 // |                                                                  |
517 // ====================================================================
518 // ========================== FraxswapRouter ==========================
519 // ====================================================================
520 // TWAMM Router
521 // Inspired by https://www.paradigm.xyz/2021/07/twamm
522 // https://github.com/para-dave/twamm
523 
524 // Frax Finance: https://github.com/FraxFinance
525 
526 // Primary Author(s)
527 // Rich Gee: https://github.com/zer0blockchain
528 // Dennis: https://github.com/denett
529 
530 // Logic / Algorithm Ideas
531 // FrankieIsLost: https://github.com/FrankieIsLost
532 
533 // Reviewer(s) / Contributor(s)
534 // Travis Moore: https://github.com/FortisFortuna
535 // Sam Kazemian: https://github.com/samkazemian
536 // Drake Evans: https://github.com/DrakeEvans
537 // Jack Corddry: https://github.com/corddry
538 // Justin Moore: https://github.com/0xJM
539 contract FraxswapRouter is IUniswapV2Router02V5 {
540 
541     address public immutable override factory;
542     address public immutable override WETH;
543 
544     modifier ensure(uint deadline) {
545         require(deadline >= block.timestamp, 'FraxswapV1Router: EXPIRED');
546         _;
547     }
548 
549     constructor(address _factory, address _WETH) public {
550         factory = _factory;
551         WETH = _WETH;
552     }
553 
554     receive() external payable {
555         assert(msg.sender == WETH); // only accept ETH via fallback from the WETH contract
556     }
557 
558     // **** ADD LIQUIDITY ****
559     function _addLiquidity(
560         address tokenA,
561         address tokenB,
562         uint amountADesired,
563         uint amountBDesired,
564         uint amountAMin,
565         uint amountBMin
566     ) internal virtual returns (uint amountA, uint amountB) {
567         // create the pair if it doesn't exist yet
568         if (IUniswapV2FactoryV5(factory).getPair(tokenA, tokenB) == address(0)) {
569             IUniswapV2FactoryV5(factory).createPair(tokenA, tokenB);
570         }
571         (uint reserveA, uint reserveB,,) = FraxswapRouterLibrary.getReservesWithTwamm(factory, tokenA, tokenB);
572         if (reserveA == 0 && reserveB == 0) {
573             (amountA, amountB) = (amountADesired, amountBDesired);
574         } else {
575             uint amountBOptimal = FraxswapRouterLibrary.quote(amountADesired, reserveA, reserveB);
576             if (amountBOptimal <= amountBDesired) {
577                 require(amountBOptimal >= amountBMin, 'FraxswapV1Router: INSUFFICIENT_B_AMOUNT');
578                 (amountA, amountB) = (amountADesired, amountBOptimal);
579             } else {
580                 uint amountAOptimal = FraxswapRouterLibrary.quote(amountBDesired, reserveB, reserveA);
581                 assert(amountAOptimal <= amountADesired);
582                 require(amountAOptimal >= amountAMin, 'FraxswapV1Router: INSUFFICIENT_A_AMOUNT');
583                 (amountA, amountB) = (amountAOptimal, amountBDesired);
584             }
585         }
586     }
587     function addLiquidity(
588         address tokenA,
589         address tokenB,
590         uint amountADesired,
591         uint amountBDesired,
592         uint amountAMin,
593         uint amountBMin,
594         address to,
595         uint deadline
596     ) external virtual override ensure(deadline) returns (uint amountA, uint amountB, uint liquidity) {
597         (amountA, amountB) = _addLiquidity(tokenA, tokenB, amountADesired, amountBDesired, amountAMin, amountBMin);
598         address pair = FraxswapRouterLibrary.pairFor(factory, tokenA, tokenB);
599         TransferHelper.safeTransferFrom(tokenA, msg.sender, pair, amountA);
600         TransferHelper.safeTransferFrom(tokenB, msg.sender, pair, amountB);
601         liquidity = IFraxswapPair(pair).mint(to);
602     }
603     function addLiquidityETH(
604         address token,
605         uint amountTokenDesired,
606         uint amountTokenMin,
607         uint amountETHMin,
608         address to,
609         uint deadline
610     ) external virtual override payable ensure(deadline) returns (uint amountToken, uint amountETH, uint liquidity) {
611         (amountToken, amountETH) = _addLiquidity(
612             token,
613             WETH,
614             amountTokenDesired,
615             msg.value,
616             amountTokenMin,
617             amountETHMin
618         );
619         address pair = FraxswapRouterLibrary.pairFor(factory, token, WETH);
620         TransferHelper.safeTransferFrom(token, msg.sender, pair, amountToken);
621         IWETH(WETH).deposit{value: amountETH}();
622         assert(IWETH(WETH).transfer(pair, amountETH));
623         liquidity = IFraxswapPair(pair).mint(to);
624         // refund dust eth, if any
625         if (msg.value > amountETH) TransferHelper.safeTransferETH(msg.sender, msg.value - amountETH);
626     }
627 
628     // **** REMOVE LIQUIDITY ****
629     function removeLiquidity(
630         address tokenA,
631         address tokenB,
632         uint liquidity,
633         uint amountAMin,
634         uint amountBMin,
635         address to,
636         uint deadline
637     ) public virtual override ensure(deadline) returns (uint amountA, uint amountB) {
638         address pair = FraxswapRouterLibrary.pairFor(factory, tokenA, tokenB);
639         IFraxswapPair(pair).transferFrom(msg.sender, pair, liquidity); // send liquidity to pair
640         (uint amount0, uint amount1) = IFraxswapPair(pair).burn(to);
641         (address token0,) = FraxswapRouterLibrary.sortTokens(tokenA, tokenB);
642         (amountA, amountB) = tokenA == token0 ? (amount0, amount1) : (amount1, amount0);
643         require(amountA >= amountAMin, 'FraxswapV1Router: INSUFFICIENT_A_AMOUNT');
644         require(amountB >= amountBMin, 'FraxswapV1Router: INSUFFICIENT_B_AMOUNT');
645     }
646     function removeLiquidityETH(
647         address token,
648         uint liquidity,
649         uint amountTokenMin,
650         uint amountETHMin,
651         address to,
652         uint deadline
653     ) public virtual override ensure(deadline) returns (uint amountToken, uint amountETH) {
654         (amountToken, amountETH) = removeLiquidity(
655             token,
656             WETH,
657             liquidity,
658             amountTokenMin,
659             amountETHMin,
660             address(this),
661             deadline
662         );
663         TransferHelper.safeTransfer(token, to, amountToken);
664         IWETH(WETH).withdraw(amountETH);
665         TransferHelper.safeTransferETH(to, amountETH);
666     }
667     function removeLiquidityWithPermit(
668         address tokenA,
669         address tokenB,
670         uint liquidity,
671         uint amountAMin,
672         uint amountBMin,
673         address to,
674         uint deadline,
675         bool approveMax, uint8 v, bytes32 r, bytes32 s
676     ) external virtual override returns (uint amountA, uint amountB) {
677         address pair = FraxswapRouterLibrary.pairFor(factory, tokenA, tokenB);
678         uint value = approveMax ? type(uint).max : liquidity;
679         IFraxswapPair(pair).permit(msg.sender, address(this), value, deadline, v, r, s);
680         (amountA, amountB) = removeLiquidity(tokenA, tokenB, liquidity, amountAMin, amountBMin, to, deadline);
681     }
682     function removeLiquidityETHWithPermit(
683         address token,
684         uint liquidity,
685         uint amountTokenMin,
686         uint amountETHMin,
687         address to,
688         uint deadline,
689         bool approveMax, uint8 v, bytes32 r, bytes32 s
690     ) external virtual override returns (uint amountToken, uint amountETH) {
691         address pair = FraxswapRouterLibrary.pairFor(factory, token, WETH);
692         uint value = approveMax ? type(uint).max : liquidity;
693         IFraxswapPair(pair).permit(msg.sender, address(this), value, deadline, v, r, s);
694         (amountToken, amountETH) = removeLiquidityETH(token, liquidity, amountTokenMin, amountETHMin, to, deadline);
695     }
696 
697     // **** REMOVE LIQUIDITY (supporting fee-on-transfer tokens) ****
698     function removeLiquidityETHSupportingFeeOnTransferTokens(
699         address token,
700         uint liquidity,
701         uint amountTokenMin,
702         uint amountETHMin,
703         address to,
704         uint deadline
705     ) public virtual override ensure(deadline) returns (uint amountETH) {
706         (, amountETH) = removeLiquidity(
707             token,
708             WETH,
709             liquidity,
710             amountTokenMin,
711             amountETHMin,
712             address(this),
713             deadline
714         );
715         TransferHelper.safeTransfer(token, to, IERC20(token).balanceOf(address(this)));
716         IWETH(WETH).withdraw(amountETH);
717         TransferHelper.safeTransferETH(to, amountETH);
718     }
719     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
720         address token,
721         uint liquidity,
722         uint amountTokenMin,
723         uint amountETHMin,
724         address to,
725         uint deadline,
726         bool approveMax, uint8 v, bytes32 r, bytes32 s
727     ) external virtual override returns (uint amountETH) {
728         address pair = FraxswapRouterLibrary.pairFor(factory, token, WETH);
729         uint value = approveMax ? type(uint).max : liquidity;
730         IFraxswapPair(pair).permit(msg.sender, address(this), value, deadline, v, r, s);
731         amountETH = removeLiquidityETHSupportingFeeOnTransferTokens(
732             token, liquidity, amountTokenMin, amountETHMin, to, deadline
733         );
734     }
735 
736     // **** SWAP ****
737     // requires the initial amount to have already been sent to the first pair
738     function _swap(uint[] memory amounts, address[] memory path, address _to) internal virtual {
739         for (uint i; i < path.length - 1; i++) {
740             (address input, address output) = (path[i], path[i + 1]);
741             (address token0,) = FraxswapRouterLibrary.sortTokens(input, output);
742             uint amountOut = amounts[i + 1];
743             (uint amount0Out, uint amount1Out) = input == token0 ? (uint(0), amountOut) : (amountOut, uint(0));
744             address to = i < path.length - 2 ? FraxswapRouterLibrary.pairFor(factory, output, path[i + 2]) : _to;
745             IFraxswapPair(FraxswapRouterLibrary.pairFor(factory, input, output)).swap(
746                 amount0Out, amount1Out, to, new bytes(0)
747             );
748         }
749     }
750     function swapExactTokensForTokens(
751         uint amountIn,
752         uint amountOutMin,
753         address[] calldata path,
754         address to,
755         uint deadline
756     ) external virtual override ensure(deadline) returns (uint[] memory amounts) {
757         amounts = FraxswapRouterLibrary.getAmountsOutWithTwamm(factory, amountIn, path);
758         require(amounts[amounts.length - 1] >= amountOutMin, 'FraxswapV1Router: INSUFFICIENT_OUTPUT_AMOUNT');
759         TransferHelper.safeTransferFrom(
760             path[0], msg.sender, FraxswapRouterLibrary.pairFor(factory, path[0], path[1]), amounts[0]
761         );
762         _swap(amounts, path, to);
763     }
764     function swapTokensForExactTokens(
765         uint amountOut,
766         uint amountInMax,
767         address[] calldata path,
768         address to,
769         uint deadline
770     ) external virtual override ensure(deadline) returns (uint[] memory amounts) {
771         amounts = FraxswapRouterLibrary.getAmountsInWithTwamm(factory, amountOut, path);
772         require(amounts[0] <= amountInMax, 'FraxswapV1Router: EXCESSIVE_INPUT_AMOUNT');
773         TransferHelper.safeTransferFrom(
774             path[0], msg.sender, FraxswapRouterLibrary.pairFor(factory, path[0], path[1]), amounts[0]
775         );
776         _swap(amounts, path, to);
777     }
778     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
779     external
780     virtual
781     override
782     payable
783     ensure(deadline)
784     returns (uint[] memory amounts)
785     {
786         require(path[0] == WETH, 'FraxswapV1Router: INVALID_PATH');
787         amounts = FraxswapRouterLibrary.getAmountsOutWithTwamm(factory, msg.value, path);
788         require(amounts[amounts.length - 1] >= amountOutMin, 'FraxswapV1Router: INSUFFICIENT_OUTPUT_AMOUNT');
789         IWETH(WETH).deposit{value: amounts[0]}();
790         assert(IWETH(WETH).transfer(FraxswapRouterLibrary.pairFor(factory, path[0], path[1]), amounts[0]));
791         _swap(amounts, path, to);
792     }
793     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
794     external
795     virtual
796     override
797     ensure(deadline)
798     returns (uint[] memory amounts)
799     {
800         require(path[path.length - 1] == WETH, 'FraxswapV1Router: INVALID_PATH');
801         amounts = FraxswapRouterLibrary.getAmountsInWithTwamm(factory, amountOut, path);
802         require(amounts[0] <= amountInMax, 'FraxswapV1Router: EXCESSIVE_INPUT_AMOUNT');
803         TransferHelper.safeTransferFrom(
804             path[0], msg.sender, FraxswapRouterLibrary.pairFor(factory, path[0], path[1]), amounts[0]
805         );
806         _swap(amounts, path, address(this));
807         IWETH(WETH).withdraw(amounts[amounts.length - 1]);
808         TransferHelper.safeTransferETH(to, amounts[amounts.length - 1]);
809     }
810     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
811     external
812     virtual
813     override
814     ensure(deadline)
815     returns (uint[] memory amounts)
816     {
817         require(path[path.length - 1] == WETH, 'FraxswapV1Router: INVALID_PATH');
818         amounts = FraxswapRouterLibrary.getAmountsOutWithTwamm(factory, amountIn, path);
819         require(amounts[amounts.length - 1] >= amountOutMin, 'FraxswapV1Router: INSUFFICIENT_OUTPUT_AMOUNT');
820         TransferHelper.safeTransferFrom(
821             path[0], msg.sender, FraxswapRouterLibrary.pairFor(factory, path[0], path[1]), amounts[0]
822         );
823         _swap(amounts, path, address(this));
824         IWETH(WETH).withdraw(amounts[amounts.length - 1]);
825         TransferHelper.safeTransferETH(to, amounts[amounts.length - 1]);
826     }
827     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
828     external
829     virtual
830     override
831     payable
832     ensure(deadline)
833     returns (uint[] memory amounts)
834     {
835         require(path[0] == WETH, 'FraxswapV1Router: INVALID_PATH');
836         amounts = FraxswapRouterLibrary.getAmountsInWithTwamm(factory, amountOut, path);
837         require(amounts[0] <= msg.value, 'FraxswapV1Router: EXCESSIVE_INPUT_AMOUNT');
838         IWETH(WETH).deposit{value: amounts[0]}();
839         assert(IWETH(WETH).transfer(FraxswapRouterLibrary.pairFor(factory, path[0], path[1]), amounts[0]));
840         _swap(amounts, path, to);
841         // refund dust eth, if any
842         if (msg.value > amounts[0]) TransferHelper.safeTransferETH(msg.sender, msg.value - amounts[0]);
843     }
844 
845     // **** SWAP (supporting fee-on-transfer tokens) ****
846     // requires the initial amount to have already been sent to the first pair
847     function _swapSupportingFeeOnTransferTokens(address[] memory path, address _to) internal virtual {
848         for (uint i; i < path.length - 1; i++) {
849             (address input, address output) = (path[i], path[i + 1]);
850             (address token0,) = FraxswapRouterLibrary.sortTokens(input, output);
851             IFraxswapPair pair = IFraxswapPair(FraxswapRouterLibrary.pairFor(factory, input, output));
852             uint amountInput;
853             uint amountOutput;
854             { // scope to avoid stack too deep errors
855                 (uint reserveInput, uint reserveOutput, uint twammReserveInput, uint twammReserveOutput) =  FraxswapRouterLibrary.getReservesWithTwamm(factory, input, output);
856                 amountInput = IERC20(input).balanceOf(address(pair)) - reserveInput - twammReserveInput;
857                 amountOutput = pair.getAmountOut(amountInput, input);
858             }
859             (uint amount0Out, uint amount1Out) = input == token0 ? (uint(0), amountOutput) : (amountOutput, uint(0));
860             address to = i < path.length - 2 ? FraxswapRouterLibrary.pairFor(factory, output, path[i + 2]) : _to;
861             pair.swap(amount0Out, amount1Out, to, new bytes(0));
862         }
863     }
864     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
865         uint amountIn,
866         uint amountOutMin,
867         address[] calldata path,
868         address to,
869         uint deadline
870     ) external virtual override ensure(deadline) {
871         TransferHelper.safeTransferFrom(
872             path[0], msg.sender, FraxswapRouterLibrary.pairFor(factory, path[0], path[1]), amountIn
873         );
874         uint balanceBefore = IERC20(path[path.length - 1]).balanceOf(to);
875         _swapSupportingFeeOnTransferTokens(path, to);
876         require(
877             IERC20(path[path.length - 1]).balanceOf(to) - balanceBefore >= amountOutMin,
878             'FraxswapV1Router: INSUFFICIENT_OUTPUT_AMOUNT'
879         );
880     }
881     function swapExactETHForTokensSupportingFeeOnTransferTokens(
882         uint amountOutMin,
883         address[] calldata path,
884         address to,
885         uint deadline
886     )
887     external
888     virtual
889     override
890     payable
891     ensure(deadline)
892     {
893         require(path[0] == WETH, 'FraxswapV1Router: INVALID_PATH');
894         uint amountIn = msg.value;
895         IWETH(WETH).deposit{value: amountIn}();
896         assert(IWETH(WETH).transfer(FraxswapRouterLibrary.pairFor(factory, path[0], path[1]), amountIn));
897         uint balanceBefore = IERC20(path[path.length - 1]).balanceOf(to);
898         _swapSupportingFeeOnTransferTokens(path, to);
899         require(
900             IERC20(path[path.length - 1]).balanceOf(to) - balanceBefore >= amountOutMin,
901             'FraxswapV1Router: INSUFFICIENT_OUTPUT_AMOUNT'
902         );
903     }
904     function swapExactTokensForETHSupportingFeeOnTransferTokens(
905         uint amountIn,
906         uint amountOutMin,
907         address[] calldata path,
908         address to,
909         uint deadline
910     )
911     external
912     virtual
913     override
914     ensure(deadline)
915     {
916         require(path[path.length - 1] == WETH, 'FraxswapV1Router: INVALID_PATH');
917         TransferHelper.safeTransferFrom(
918             path[0], msg.sender, FraxswapRouterLibrary.pairFor(factory, path[0], path[1]), amountIn
919         );
920         _swapSupportingFeeOnTransferTokens(path, address(this));
921         uint amountOut = IERC20(WETH).balanceOf(address(this));
922         require(amountOut >= amountOutMin, 'FraxswapV1Router: INSUFFICIENT_OUTPUT_AMOUNT');
923         IWETH(WETH).withdraw(amountOut);
924         TransferHelper.safeTransferETH(to, amountOut);
925     }
926 
927     // **** LIBRARY FUNCTIONS ****
928     function quote(uint amountA, uint reserveA, uint reserveB) public pure virtual override returns (uint amountB) {
929         return FraxswapRouterLibrary.quote(amountA, reserveA, reserveB);
930     }
931 
932     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut)
933     public
934     pure
935     virtual
936     override
937     returns (uint amountOut)
938     {
939         revert("Deprecated: Use getAmountsOut"); // depends on the fee of the pool
940     }
941 
942     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut)
943     public
944     pure
945     virtual
946     override
947     returns (uint amountIn)
948     {
949         revert("Deprecated: Use getAmountsIn"); // depends on the fee of the pool
950     }
951 
952     function getAmountsOut(uint amountIn, address[] memory path)
953     public
954     view
955     virtual
956     override
957     returns (uint[] memory amounts)
958     {
959         return FraxswapRouterLibrary.getAmountsOut(factory, amountIn, path);
960     }
961 
962     function getAmountsIn(uint amountOut, address[] memory path)
963     public
964     view
965     virtual
966     override
967     returns (uint[] memory amounts)
968     {
969         return FraxswapRouterLibrary.getAmountsIn(factory, amountOut, path);
970     }
971 
972     function getAmountsOutWithTwamm(uint amountIn, address[] memory path)
973     public
974     returns (uint[] memory amounts)
975     {
976         return FraxswapRouterLibrary.getAmountsOutWithTwamm(factory, amountIn, path);
977     }
978 
979     function getAmountsInWithTwamm(uint amountOut, address[] memory path)
980     public
981     returns (uint[] memory amounts)
982     {
983         return FraxswapRouterLibrary.getAmountsInWithTwamm(factory, amountOut, path);
984     }
985 }