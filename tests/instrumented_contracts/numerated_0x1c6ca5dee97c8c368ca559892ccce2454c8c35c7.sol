1 // SPDX-License-Identifier: GPL-2.0-or-later
2 pragma solidity >=0.8.0;
3 
4 // Sources flattened with hardhat v2.9.3 https://hardhat.org
5 
6 // File contracts/Fraxswap/core/interfaces/IUniswapV2FactoryV5.sol
7 
8 
9 interface IUniswapV2FactoryV5 {
10     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
11 
12     function feeTo() external view returns (address);
13     function feeToSetter() external view returns (address);
14 
15     function getPair(address tokenA, address tokenB) external view returns (address pair);
16     function allPairs(uint) external view returns (address pair);
17     function allPairsLength() external view returns (uint);
18 
19     function createPair(address tokenA, address tokenB) external returns (address pair);
20 
21     function setFeeTo(address) external;
22     function setFeeToSetter(address) external;
23 }
24 
25 
26 // File contracts/Fraxswap/core/interfaces/IUniswapV2PairV5.sol
27 
28 
29 interface IUniswapV2PairV5 {
30     event Approval(address indexed owner, address indexed spender, uint value);
31     event Transfer(address indexed from, address indexed to, uint value);
32 
33     function name() external pure returns (string memory);
34     function symbol() external pure returns (string memory);
35     function decimals() external pure returns (uint8);
36     function totalSupply() external view returns (uint);
37     function balanceOf(address owner) external view returns (uint);
38     function allowance(address owner, address spender) external view returns (uint);
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
76     function initialize(address, address) external;
77 }
78 
79 
80 // File contracts/Fraxswap/core/interfaces/IFraxswapPair.sol
81 
82 
83 // ====================================================================
84 // |     ______                   _______                             |
85 // |    / _____________ __  __   / ____(_____  ____ _____  ________   |
86 // |   / /_  / ___/ __ `| |/_/  / /_  / / __ \/ __ `/ __ \/ ___/ _ \  |
87 // |  / __/ / /  / /_/ _>  <   / __/ / / / / / /_/ / / / / /__/  __/  |
88 // | /_/   /_/   \__,_/_/|_|  /_/   /_/_/ /_/\__,_/_/ /_/\___/\___/   |
89 // |                                                                  |
90 // ====================================================================
91 // ========================= IFraxswapPair ==========================
92 // ====================================================================
93 // Fraxswap LP Pair Interface
94 // Inspired by https://www.paradigm.xyz/2021/07/twamm
95 // https://github.com/para-dave/twamm
96 
97 // Frax Finance: https://github.com/FraxFinance
98 
99 // Primary Author(s)
100 // Rich Gee: https://github.com/zer0blockchain
101 // Dennis: https://github.com/denett
102 
103 // Reviewer(s) / Contributor(s)
104 // Travis Moore: https://github.com/FortisFortuna
105 // Sam Kazemian: https://github.com/samkazemian
106 
107 interface IFraxswapPair is IUniswapV2PairV5 {
108     // TWAMM
109 
110     event LongTermSwap0To1(address indexed addr, uint256 orderId, uint256 amount0In, uint256 numberOfTimeIntervals);
111     event LongTermSwap1To0(address indexed addr, uint256 orderId, uint256 amount1In, uint256 numberOfTimeIntervals);
112     event CancelLongTermOrder(address indexed addr, uint256 orderId, address sellToken, uint256 unsoldAmount, address buyToken, uint256 purchasedAmount);
113     event WithdrawProceedsFromLongTermOrder(address indexed addr, uint256 orderId, address indexed proceedToken, uint256 proceeds, bool orderExpired);
114 
115     function longTermSwapFrom0To1(uint256 amount0In, uint256 numberOfTimeIntervals) external returns (uint256 orderId);
116     function longTermSwapFrom1To0(uint256 amount1In, uint256 numberOfTimeIntervals) external returns (uint256 orderId);
117     function cancelLongTermSwap(uint256 orderId) external;
118     function withdrawProceedsFromLongTermSwap(uint256 orderId) external returns (bool is_expired, address rewardTkn, uint256 totalReward);
119     function executeVirtualOrders(uint256 blockTimestamp) external;
120 
121     function orderTimeInterval() external returns (uint256);
122     function getTWAPHistoryLength() external view returns (uint);
123     function getTwammReserves() external view returns (uint112 _reserve0, uint112 _reserve1, uint32 _blockTimestampLast, uint112 _twammReserve0, uint112 _twammReserve1);
124     function getReserveAfterTwamm(uint256 blockTimestamp) external view returns (uint112 _reserve0, uint112 _reserve1, uint256 lastVirtualOrderTimestamp, uint112 _twammReserve0, uint112 _twammReserve1);
125     function getNextOrderID() external view returns (uint256);
126     function getOrderIDsForUser(address user) external view returns (uint256[] memory);
127     function getOrderIDsForUserLength(address user) external view returns (uint256);
128 //    function getDetailedOrdersForUser(address user, uint256 offset, uint256 limit) external view returns (LongTermOrdersLib.Order[] memory detailed_orders);
129     function twammUpToDate() external view returns (bool);
130     function getTwammState() external view returns (uint256 token0Rate, uint256 token1Rate, uint256 lastVirtualOrderTimestamp, uint256 orderTimeInterval_rtn, uint256 rewardFactorPool0, uint256 rewardFactorPool1);
131     function getTwammSalesRateEnding(uint256 _blockTimestamp) external view returns (uint256 orderPool0SalesRateEnding, uint256 orderPool1SalesRateEnding);
132     function getTwammRewardFactor(uint256 _blockTimestamp) external view returns (uint256 rewardFactorPool0AtTimestamp, uint256 rewardFactorPool1AtTimestamp);
133     function getTwammOrder(uint256 orderId) external view returns (uint256 id, uint256 expirationTimestamp, uint256 saleRate, address owner, address sellTokenAddr, address buyTokenAddr);
134     function getTwammOrderProceedsView(uint256 orderId, uint256 blockTimestamp) external view returns (bool orderExpired, uint256 totalReward);
135     function getTwammOrderProceeds(uint256 orderId) external returns (bool orderExpired, uint256 totalReward);
136 
137 
138     function togglePauseNewSwaps() external;
139 }
140 
141 
142 // File contracts/Fraxswap/libraries/TransferHelper.sol
143 
144 
145 
146 // helper methods for interacting with ERC20 tokens and sending ETH that do not consistently return true/false
147 library TransferHelper {
148     function safeApprove(
149         address token,
150         address to,
151         uint256 value
152     ) internal {
153         // bytes4(keccak256(bytes('approve(address,uint256)')));
154         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x095ea7b3, to, value));
155         require(
156             success && (data.length == 0 || abi.decode(data, (bool))),
157             'TransferHelper::safeApprove: approve failed'
158         );
159     }
160 
161     function safeTransfer(
162         address token,
163         address to,
164         uint256 value
165     ) internal {
166         // bytes4(keccak256(bytes('transfer(address,uint256)')));
167         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));
168         require(
169             success && (data.length == 0 || abi.decode(data, (bool))),
170             'TransferHelper::safeTransfer: transfer failed'
171         );
172     }
173 
174     function safeTransferFrom(
175         address token,
176         address from,
177         address to,
178         uint256 value
179     ) internal {
180         // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
181         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));
182         require(
183             success && (data.length == 0 || abi.decode(data, (bool))),
184             'TransferHelper::transferFrom: transferFrom failed'
185         );
186     }
187 
188     function safeTransferETH(address to, uint256 value) internal {
189         (bool success, ) = to.call{value: value}(new bytes(0));
190         require(success, 'TransferHelper::safeTransferETH: ETH transfer failed');
191     }
192 }
193 
194 
195 // File contracts/Fraxswap/periphery/interfaces/IUniswapV2Router01V5.sol
196 
197 
198 interface IUniswapV2Router01V5 {
199     function factory() external view returns (address);
200     function WETH() external view returns (address);
201 
202     function addLiquidity(
203         address tokenA,
204         address tokenB,
205         uint amountADesired,
206         uint amountBDesired,
207         uint amountAMin,
208         uint amountBMin,
209         address to,
210         uint deadline
211     ) external returns (uint amountA, uint amountB, uint liquidity);
212     function addLiquidityETH(
213         address token,
214         uint amountTokenDesired,
215         uint amountTokenMin,
216         uint amountETHMin,
217         address to,
218         uint deadline
219     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
220     function removeLiquidity(
221         address tokenA,
222         address tokenB,
223         uint liquidity,
224         uint amountAMin,
225         uint amountBMin,
226         address to,
227         uint deadline
228     ) external returns (uint amountA, uint amountB);
229     function removeLiquidityETH(
230         address token,
231         uint liquidity,
232         uint amountTokenMin,
233         uint amountETHMin,
234         address to,
235         uint deadline
236     ) external returns (uint amountToken, uint amountETH);
237     function removeLiquidityWithPermit(
238         address tokenA,
239         address tokenB,
240         uint liquidity,
241         uint amountAMin,
242         uint amountBMin,
243         address to,
244         uint deadline,
245         bool approveMax, uint8 v, bytes32 r, bytes32 s
246     ) external returns (uint amountA, uint amountB);
247     function removeLiquidityETHWithPermit(
248         address token,
249         uint liquidity,
250         uint amountTokenMin,
251         uint amountETHMin,
252         address to,
253         uint deadline,
254         bool approveMax, uint8 v, bytes32 r, bytes32 s
255     ) external returns (uint amountToken, uint amountETH);
256     function swapExactTokensForTokens(
257         uint amountIn,
258         uint amountOutMin,
259         address[] calldata path,
260         address to,
261         uint deadline
262     ) external returns (uint[] memory amounts);
263     function swapTokensForExactTokens(
264         uint amountOut,
265         uint amountInMax,
266         address[] calldata path,
267         address to,
268         uint deadline
269     ) external returns (uint[] memory amounts);
270     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
271         external
272         payable
273         returns (uint[] memory amounts);
274     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
275         external
276         returns (uint[] memory amounts);
277     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
278         external
279         returns (uint[] memory amounts);
280     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
281         external
282         payable
283         returns (uint[] memory amounts);
284 
285     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
286     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
287     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
288     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
289     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
290 }
291 
292 
293 // File contracts/Fraxswap/periphery/interfaces/IUniswapV2Router02V5.sol
294 
295 
296 interface IUniswapV2Router02V5 is IUniswapV2Router01V5 {
297     function removeLiquidityETHSupportingFeeOnTransferTokens(
298         address token,
299         uint liquidity,
300         uint amountTokenMin,
301         uint amountETHMin,
302         address to,
303         uint deadline
304     ) external returns (uint amountETH);
305     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
306         address token,
307         uint liquidity,
308         uint amountTokenMin,
309         uint amountETHMin,
310         address to,
311         uint deadline,
312         bool approveMax, uint8 v, bytes32 r, bytes32 s
313     ) external returns (uint amountETH);
314 
315     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
316         uint amountIn,
317         uint amountOutMin,
318         address[] calldata path,
319         address to,
320         uint deadline
321     ) external;
322     function swapExactETHForTokensSupportingFeeOnTransferTokens(
323         uint amountOutMin,
324         address[] calldata path,
325         address to,
326         uint deadline
327     ) external payable;
328     function swapExactTokensForETHSupportingFeeOnTransferTokens(
329         uint amountIn,
330         uint amountOutMin,
331         address[] calldata path,
332         address to,
333         uint deadline
334     ) external;
335 }
336 
337 
338 // File contracts/Fraxswap/periphery/libraries/FraxswapRouterLibrary.sol
339 
340 
341 // ====================================================================
342 // |     ______                   _______                             |
343 // |    / _____________ __  __   / ____(_____  ____ _____  ________   |
344 // |   / /_  / ___/ __ `| |/_/  / /_  / / __ \/ __ `/ __ \/ ___/ _ \  |
345 // |  / __/ / /  / /_/ _>  <   / __/ / / / / / /_/ / / / / /__/  __/  |
346 // | /_/   /_/   \__,_/_/|_|  /_/   /_/_/ /_/\__,_/_/ /_/\___/\___/   |
347 // |                                                                  |
348 // ====================================================================
349 // ======================= FraxswapRouterLibrary ======================
350 // ====================================================================
351 // Fraxswap Router Library Functions
352 // Inspired by https://www.paradigm.xyz/2021/07/twamm
353 // https://github.com/para-dave/twamm
354 
355 // Frax Finance: https://github.com/FraxFinance
356 
357 // Primary Author(s)
358 // Rich Gee: https://github.com/zer0blockchain
359 // Dennis: https://github.com/denett
360 
361 // Logic / Algorithm Ideas
362 // FrankieIsLost: https://github.com/FrankieIsLost
363 
364 // Reviewer(s) / Contributor(s)
365 // Travis Moore: https://github.com/FortisFortuna
366 // Sam Kazemian: https://github.com/samkazemian
367 // Drake Evans: https://github.com/DrakeEvans
368 // Jack Corddry: https://github.com/corddry
369 // Justin Moore: https://github.com/0xJM
370 
371 library FraxswapRouterLibrary {
372 
373     // returns sorted token addresses, used to handle return values from pairs sorted in this order
374     function sortTokens(address tokenA, address tokenB) internal pure returns (address token0, address token1) {
375         require(tokenA != tokenB, 'FraxswapRouterLibrary: IDENTICAL_ADDRESSES');
376         (token0, token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
377         require(token0 != address(0), 'FraxswapRouterLibrary: ZERO_ADDRESS');
378     }
379 
380     // calculates the CREATE2 address for a pair without making any external calls
381     function pairFor(address factory, address tokenA, address tokenB) internal pure returns (address pair) {
382         (address token0, address token1) = sortTokens(tokenA, tokenB);
383         pair = address(uint160(uint(keccak256(abi.encodePacked(
384                 hex'ff',
385                 factory,
386                 keccak256(abi.encodePacked(token0, token1)),
387                 hex'56d8137e6dc7681d67b2c0b0ecb99a25da51343f540d36e93a2d172fea4597f7' // init code hash
388             )))));
389     }
390 
391     // fetches and sorts the reserves for a pair
392     function getReserves(address factory, address tokenA, address tokenB) internal view returns (uint reserveA, uint reserveB) {
393         (address token0,) = sortTokens(tokenA, tokenB);
394 
395         (uint reserve0, uint reserve1,) = IFraxswapPair(pairFor(factory, tokenA, tokenB)).getReserves();
396 
397         (reserveA, reserveB) = tokenA == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
398     }
399 
400     function getReservesWithTwamm(address factory, address tokenA, address tokenB) internal returns (uint reserveA, uint reserveB, uint twammReserveA, uint twammReserveB) {
401         (address token0,) = sortTokens(tokenA, tokenB);
402 
403         IFraxswapPair pair = IFraxswapPair(pairFor(factory, tokenA, tokenB));
404 
405         pair.executeVirtualOrders(block.timestamp);
406 
407         (uint reserve0, uint reserve1,,uint twammReserve0, uint twammReserve1) = pair.getTwammReserves();
408 
409         (reserveA, reserveB, twammReserveA, twammReserveB) = tokenA == token0 ? (reserve0, reserve1, twammReserve0, twammReserve1) : (reserve1, reserve0, twammReserve1, twammReserve0);
410     }
411 
412     // given some amount of an asset and pair reserves, returns an equivalent amount of the other asset
413     function quote(uint amountA, uint reserveA, uint reserveB) internal pure returns (uint amountB) {
414         require(amountA > 0, 'FraxswapRouterLibrary: INSUFFICIENT_AMOUNT');
415         require(reserveA > 0 && reserveB > 0, 'FraxswapRouterLibrary: INSUFFICIENT_LIQUIDITY');
416         amountB = amountA * reserveB / reserveA;
417     }
418 
419     // given an input amount of an asset and pair reserves, returns the maximum output amount of the other asset
420     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) internal pure returns (uint amountOut) {
421         require(amountIn > 0, 'FraxswapRouterLibrary: INSUFFICIENT_INPUT_AMOUNT');
422         require(reserveIn > 0 && reserveOut > 0, 'FraxswapRouterLibrary: INSUFFICIENT_LIQUIDITY');
423         uint amountInWithFee = amountIn * 997;
424         uint numerator = amountInWithFee * reserveOut;
425         uint denominator = (reserveIn * 1000) + amountInWithFee;
426         amountOut = numerator / denominator;
427     }
428 
429     // given an output amount of an asset and pair reserves, returns a required input amount of the other asset
430     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) internal pure returns (uint amountIn) {
431         require(amountOut > 0, 'FraxswapRouterLibrary: INSUFFICIENT_OUTPUT_AMOUNT');
432         require(reserveIn > 0 && reserveOut > 0, 'FraxswapRouterLibrary: INSUFFICIENT_LIQUIDITY');
433         uint numerator = reserveIn * amountOut * 1000;
434         uint denominator = (reserveOut - amountOut) * 997;
435         amountIn = (numerator / denominator) + 1;
436     }
437 
438     // performs chained getAmountOut calculations on any number of pairs
439     function getAmountsOut(address factory, uint amountIn, address[] memory path) internal view returns (uint[] memory amounts) {
440         require(path.length >= 2, 'FraxswapRouterLibrary: INVALID_PATH');
441         amounts = new uint[](path.length);
442         amounts[0] = amountIn;
443         for (uint i; i < path.length - 1; i++) {
444             require(IFraxswapPair(FraxswapRouterLibrary.pairFor(factory, path[i], path[i + 1])).twammUpToDate(), 'twamm out of date');
445             (uint reserveIn, uint reserveOut) = getReserves(factory, path[i], path[i + 1]);
446             amounts[i + 1] = getAmountOut(amounts[i], reserveIn, reserveOut);
447         }
448     }
449 
450     // performs chained getAmountIn calculations on any number of pairs
451     function getAmountsIn(address factory, uint amountOut, address[] memory path) internal view returns (uint[] memory amounts) {
452         require(path.length >= 2, 'FraxswapRouterLibrary: INVALID_PATH');
453         amounts = new uint[](path.length);
454         amounts[amounts.length - 1] = amountOut;
455         for (uint i = path.length - 1; i > 0; i--) {
456             require(IFraxswapPair(FraxswapRouterLibrary.pairFor(factory, path[i - 1], path[i])).twammUpToDate(), 'twamm out of date');
457             (uint reserveIn, uint reserveOut) = getReserves(factory, path[i - 1], path[i]);
458             amounts[i - 1] = getAmountIn(amounts[i], reserveIn, reserveOut);
459         }
460     }
461 
462     // performs chained getAmountOut calculations on any number of pairs with Twamm
463     function getAmountsOutWithTwamm(address factory, uint amountIn, address[] memory path) internal returns (uint[] memory amounts) {
464         require(path.length >= 2, 'FraxswapRouterLibrary: INVALID_PATH');
465         amounts = new uint[](path.length);
466         amounts[0] = amountIn;
467         for (uint i; i < path.length - 1; i++) {
468             address pairAddress = FraxswapRouterLibrary.pairFor(factory, path[i], path[i + 1]);
469             IFraxswapPair(pairAddress).executeVirtualOrders(block.timestamp);
470             (uint reserveIn, uint reserveOut) = getReserves(factory, path[i], path[i + 1]);
471             amounts[i + 1] = getAmountOut(amounts[i], reserveIn, reserveOut);
472         }
473     }
474 
475     // performs chained getAmountIn calculations on any number of pairs with Twamm
476     function getAmountsInWithTwamm(address factory, uint amountOut, address[] memory path) internal returns (uint[] memory amounts) {
477         require(path.length >= 2, 'FraxswapRouterLibrary: INVALID_PATH');
478         amounts = new uint[](path.length);
479         amounts[amounts.length - 1] = amountOut;
480         for (uint i = path.length - 1; i > 0; i--) {
481             address pairAddress = FraxswapRouterLibrary.pairFor(factory, path[i - 1], path[i]);
482             IFraxswapPair(pairAddress).executeVirtualOrders(block.timestamp);
483             (uint reserveIn, uint reserveOut) = getReserves(factory, path[i - 1], path[i]);
484             amounts[i - 1] = getAmountIn(amounts[i], reserveIn, reserveOut);
485         }
486     }
487 }
488 
489 
490 // File contracts/Fraxswap/periphery/interfaces/IERC20.sol
491 
492 
493 interface IERC20 {
494     event Approval(address indexed owner, address indexed spender, uint value);
495     event Transfer(address indexed from, address indexed to, uint value);
496 
497     function name() external view returns (string memory);
498     function symbol() external view returns (string memory);
499     function decimals() external view returns (uint8);
500     function totalSupply() external view returns (uint);
501     function balanceOf(address owner) external view returns (uint);
502     function allowance(address owner, address spender) external view returns (uint);
503 
504     function approve(address spender, uint value) external returns (bool);
505     function transfer(address to, uint value) external returns (bool);
506     function transferFrom(address from, address to, uint value) external returns (bool);
507 }
508 
509 
510 // File contracts/Fraxswap/periphery/interfaces/IWETH.sol
511 
512 
513 interface IWETH {
514     function deposit() external payable;
515     function transfer(address to, uint value) external returns (bool);
516     function withdraw(uint) external;
517 }
518 
519 
520 // File contracts/Fraxswap/periphery/FraxswapRouter.sol
521 
522 
523 // ====================================================================
524 // |     ______                   _______                             |
525 // |    / _____________ __  __   / ____(_____  ____ _____  ________   |
526 // |   / /_  / ___/ __ `| |/_/  / /_  / / __ \/ __ `/ __ \/ ___/ _ \  |
527 // |  / __/ / /  / /_/ _>  <   / __/ / / / / / /_/ / / / / /__/  __/  |
528 // | /_/   /_/   \__,_/_/|_|  /_/   /_/_/ /_/\__,_/_/ /_/\___/\___/   |
529 // |                                                                  |
530 // ====================================================================
531 // ========================== FraxswapRouter ==========================
532 // ====================================================================
533 // TWAMM Router
534 // Inspired by https://www.paradigm.xyz/2021/07/twamm
535 // https://github.com/para-dave/twamm
536 
537 // Frax Finance: https://github.com/FraxFinance
538 
539 // Primary Author(s)
540 // Rich Gee: https://github.com/zer0blockchain
541 // Dennis: https://github.com/denett
542 
543 // Logic / Algorithm Ideas
544 // FrankieIsLost: https://github.com/FrankieIsLost
545 
546 // Reviewer(s) / Contributor(s)
547 // Travis Moore: https://github.com/FortisFortuna
548 // Sam Kazemian: https://github.com/samkazemian
549 // Drake Evans: https://github.com/DrakeEvans
550 // Jack Corddry: https://github.com/corddry
551 // Justin Moore: https://github.com/0xJM
552 contract FraxswapRouter is IUniswapV2Router02V5 {
553 
554     address public immutable override factory;
555     address public immutable override WETH;
556 
557     modifier ensure(uint deadline) {
558         require(deadline >= block.timestamp, 'FraxswapV1Router: EXPIRED');
559         _;
560     }
561 
562     constructor(address _factory, address _WETH) public {
563         factory = _factory;
564         WETH = _WETH;
565     }
566 
567     receive() external payable {
568         assert(msg.sender == WETH); // only accept ETH via fallback from the WETH contract
569     }
570 
571     // **** ADD LIQUIDITY ****
572     function _addLiquidity(
573         address tokenA,
574         address tokenB,
575         uint amountADesired,
576         uint amountBDesired,
577         uint amountAMin,
578         uint amountBMin
579     ) internal virtual returns (uint amountA, uint amountB) {
580         // create the pair if it doesn't exist yet
581         if (IUniswapV2FactoryV5(factory).getPair(tokenA, tokenB) == address(0)) {
582             IUniswapV2FactoryV5(factory).createPair(tokenA, tokenB);
583         }
584         (uint reserveA, uint reserveB,,) = FraxswapRouterLibrary.getReservesWithTwamm(factory, tokenA, tokenB);
585         if (reserveA == 0 && reserveB == 0) {
586             (amountA, amountB) = (amountADesired, amountBDesired);
587         } else {
588             uint amountBOptimal = FraxswapRouterLibrary.quote(amountADesired, reserveA, reserveB);
589             if (amountBOptimal <= amountBDesired) {
590                 require(amountBOptimal >= amountBMin, 'FraxswapV1Router: INSUFFICIENT_B_AMOUNT');
591                 (amountA, amountB) = (amountADesired, amountBOptimal);
592             } else {
593                 uint amountAOptimal = FraxswapRouterLibrary.quote(amountBDesired, reserveB, reserveA);
594                 assert(amountAOptimal <= amountADesired);
595                 require(amountAOptimal >= amountAMin, 'FraxswapV1Router: INSUFFICIENT_A_AMOUNT');
596                 (amountA, amountB) = (amountAOptimal, amountBDesired);
597             }
598         }
599     }
600     function addLiquidity(
601         address tokenA,
602         address tokenB,
603         uint amountADesired,
604         uint amountBDesired,
605         uint amountAMin,
606         uint amountBMin,
607         address to,
608         uint deadline
609     ) external virtual override ensure(deadline) returns (uint amountA, uint amountB, uint liquidity) {
610         (amountA, amountB) = _addLiquidity(tokenA, tokenB, amountADesired, amountBDesired, amountAMin, amountBMin);
611         address pair = FraxswapRouterLibrary.pairFor(factory, tokenA, tokenB);
612         TransferHelper.safeTransferFrom(tokenA, msg.sender, pair, amountA);
613         TransferHelper.safeTransferFrom(tokenB, msg.sender, pair, amountB);
614         liquidity = IFraxswapPair(pair).mint(to);
615     }
616     function addLiquidityETH(
617         address token,
618         uint amountTokenDesired,
619         uint amountTokenMin,
620         uint amountETHMin,
621         address to,
622         uint deadline
623     ) external virtual override payable ensure(deadline) returns (uint amountToken, uint amountETH, uint liquidity) {
624         (amountToken, amountETH) = _addLiquidity(
625             token,
626             WETH,
627             amountTokenDesired,
628             msg.value,
629             amountTokenMin,
630             amountETHMin
631         );
632         address pair = FraxswapRouterLibrary.pairFor(factory, token, WETH);
633         TransferHelper.safeTransferFrom(token, msg.sender, pair, amountToken);
634         IWETH(WETH).deposit{value: amountETH}();
635         assert(IWETH(WETH).transfer(pair, amountETH));
636         liquidity = IFraxswapPair(pair).mint(to);
637         // refund dust eth, if any
638         if (msg.value > amountETH) TransferHelper.safeTransferETH(msg.sender, msg.value - amountETH);
639     }
640 
641     // **** REMOVE LIQUIDITY ****
642     function removeLiquidity(
643         address tokenA,
644         address tokenB,
645         uint liquidity,
646         uint amountAMin,
647         uint amountBMin,
648         address to,
649         uint deadline
650     ) public virtual override ensure(deadline) returns (uint amountA, uint amountB) {
651         address pair = FraxswapRouterLibrary.pairFor(factory, tokenA, tokenB);
652         IFraxswapPair(pair).transferFrom(msg.sender, pair, liquidity); // send liquidity to pair
653         (uint amount0, uint amount1) = IFraxswapPair(pair).burn(to);
654         (address token0,) = FraxswapRouterLibrary.sortTokens(tokenA, tokenB);
655         (amountA, amountB) = tokenA == token0 ? (amount0, amount1) : (amount1, amount0);
656         require(amountA >= amountAMin, 'FraxswapV1Router: INSUFFICIENT_A_AMOUNT');
657         require(amountB >= amountBMin, 'FraxswapV1Router: INSUFFICIENT_B_AMOUNT');
658     }
659     function removeLiquidityETH(
660         address token,
661         uint liquidity,
662         uint amountTokenMin,
663         uint amountETHMin,
664         address to,
665         uint deadline
666     ) public virtual override ensure(deadline) returns (uint amountToken, uint amountETH) {
667         (amountToken, amountETH) = removeLiquidity(
668             token,
669             WETH,
670             liquidity,
671             amountTokenMin,
672             amountETHMin,
673             address(this),
674             deadline
675         );
676         TransferHelper.safeTransfer(token, to, amountToken);
677         IWETH(WETH).withdraw(amountETH);
678         TransferHelper.safeTransferETH(to, amountETH);
679     }
680     function removeLiquidityWithPermit(
681         address tokenA,
682         address tokenB,
683         uint liquidity,
684         uint amountAMin,
685         uint amountBMin,
686         address to,
687         uint deadline,
688         bool approveMax, uint8 v, bytes32 r, bytes32 s
689     ) external virtual override returns (uint amountA, uint amountB) {
690         address pair = FraxswapRouterLibrary.pairFor(factory, tokenA, tokenB);
691         uint value = approveMax ? type(uint).max : liquidity;
692         IFraxswapPair(pair).permit(msg.sender, address(this), value, deadline, v, r, s);
693         (amountA, amountB) = removeLiquidity(tokenA, tokenB, liquidity, amountAMin, amountBMin, to, deadline);
694     }
695     function removeLiquidityETHWithPermit(
696         address token,
697         uint liquidity,
698         uint amountTokenMin,
699         uint amountETHMin,
700         address to,
701         uint deadline,
702         bool approveMax, uint8 v, bytes32 r, bytes32 s
703     ) external virtual override returns (uint amountToken, uint amountETH) {
704         address pair = FraxswapRouterLibrary.pairFor(factory, token, WETH);
705         uint value = approveMax ? type(uint).max : liquidity;
706         IFraxswapPair(pair).permit(msg.sender, address(this), value, deadline, v, r, s);
707         (amountToken, amountETH) = removeLiquidityETH(token, liquidity, amountTokenMin, amountETHMin, to, deadline);
708     }
709 
710     // **** REMOVE LIQUIDITY (supporting fee-on-transfer tokens) ****
711     function removeLiquidityETHSupportingFeeOnTransferTokens(
712         address token,
713         uint liquidity,
714         uint amountTokenMin,
715         uint amountETHMin,
716         address to,
717         uint deadline
718     ) public virtual override ensure(deadline) returns (uint amountETH) {
719         (, amountETH) = removeLiquidity(
720             token,
721             WETH,
722             liquidity,
723             amountTokenMin,
724             amountETHMin,
725             address(this),
726             deadline
727         );
728         TransferHelper.safeTransfer(token, to, IERC20(token).balanceOf(address(this)));
729         IWETH(WETH).withdraw(amountETH);
730         TransferHelper.safeTransferETH(to, amountETH);
731     }
732     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
733         address token,
734         uint liquidity,
735         uint amountTokenMin,
736         uint amountETHMin,
737         address to,
738         uint deadline,
739         bool approveMax, uint8 v, bytes32 r, bytes32 s
740     ) external virtual override returns (uint amountETH) {
741         address pair = FraxswapRouterLibrary.pairFor(factory, token, WETH);
742         uint value = approveMax ? type(uint).max : liquidity;
743         IFraxswapPair(pair).permit(msg.sender, address(this), value, deadline, v, r, s);
744         amountETH = removeLiquidityETHSupportingFeeOnTransferTokens(
745             token, liquidity, amountTokenMin, amountETHMin, to, deadline
746         );
747     }
748 
749     // **** SWAP ****
750     // requires the initial amount to have already been sent to the first pair
751     function _swap(uint[] memory amounts, address[] memory path, address _to) internal virtual {
752         for (uint i; i < path.length - 1; i++) {
753             (address input, address output) = (path[i], path[i + 1]);
754             (address token0,) = FraxswapRouterLibrary.sortTokens(input, output);
755             uint amountOut = amounts[i + 1];
756             (uint amount0Out, uint amount1Out) = input == token0 ? (uint(0), amountOut) : (amountOut, uint(0));
757             address to = i < path.length - 2 ? FraxswapRouterLibrary.pairFor(factory, output, path[i + 2]) : _to;
758             IFraxswapPair(FraxswapRouterLibrary.pairFor(factory, input, output)).swap(
759                 amount0Out, amount1Out, to, new bytes(0)
760             );
761         }
762     }
763     function swapExactTokensForTokens(
764         uint amountIn,
765         uint amountOutMin,
766         address[] calldata path,
767         address to,
768         uint deadline
769     ) external virtual override ensure(deadline) returns (uint[] memory amounts) {
770         amounts = FraxswapRouterLibrary.getAmountsOutWithTwamm(factory, amountIn, path);
771         require(amounts[amounts.length - 1] >= amountOutMin, 'FraxswapV1Router: INSUFFICIENT_OUTPUT_AMOUNT');
772         TransferHelper.safeTransferFrom(
773             path[0], msg.sender, FraxswapRouterLibrary.pairFor(factory, path[0], path[1]), amounts[0]
774         );
775         _swap(amounts, path, to);
776     }
777     function swapTokensForExactTokens(
778         uint amountOut,
779         uint amountInMax,
780         address[] calldata path,
781         address to,
782         uint deadline
783     ) external virtual override ensure(deadline) returns (uint[] memory amounts) {
784         amounts = FraxswapRouterLibrary.getAmountsInWithTwamm(factory, amountOut, path);
785         require(amounts[0] <= amountInMax, 'FraxswapV1Router: EXCESSIVE_INPUT_AMOUNT');
786         TransferHelper.safeTransferFrom(
787             path[0], msg.sender, FraxswapRouterLibrary.pairFor(factory, path[0], path[1]), amounts[0]
788         );
789         _swap(amounts, path, to);
790     }
791     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
792     external
793     virtual
794     override
795     payable
796     ensure(deadline)
797     returns (uint[] memory amounts)
798     {
799         require(path[0] == WETH, 'FraxswapV1Router: INVALID_PATH');
800         amounts = FraxswapRouterLibrary.getAmountsOutWithTwamm(factory, msg.value, path);
801         require(amounts[amounts.length - 1] >= amountOutMin, 'FraxswapV1Router: INSUFFICIENT_OUTPUT_AMOUNT');
802         IWETH(WETH).deposit{value: amounts[0]}();
803         assert(IWETH(WETH).transfer(FraxswapRouterLibrary.pairFor(factory, path[0], path[1]), amounts[0]));
804         _swap(amounts, path, to);
805     }
806     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
807     external
808     virtual
809     override
810     ensure(deadline)
811     returns (uint[] memory amounts)
812     {
813         require(path[path.length - 1] == WETH, 'FraxswapV1Router: INVALID_PATH');
814         amounts = FraxswapRouterLibrary.getAmountsInWithTwamm(factory, amountOut, path);
815         require(amounts[0] <= amountInMax, 'FraxswapV1Router: EXCESSIVE_INPUT_AMOUNT');
816         TransferHelper.safeTransferFrom(
817             path[0], msg.sender, FraxswapRouterLibrary.pairFor(factory, path[0], path[1]), amounts[0]
818         );
819         _swap(amounts, path, address(this));
820         IWETH(WETH).withdraw(amounts[amounts.length - 1]);
821         TransferHelper.safeTransferETH(to, amounts[amounts.length - 1]);
822     }
823     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
824     external
825     virtual
826     override
827     ensure(deadline)
828     returns (uint[] memory amounts)
829     {
830         require(path[path.length - 1] == WETH, 'FraxswapV1Router: INVALID_PATH');
831         amounts = FraxswapRouterLibrary.getAmountsOutWithTwamm(factory, amountIn, path);
832         require(amounts[amounts.length - 1] >= amountOutMin, 'FraxswapV1Router: INSUFFICIENT_OUTPUT_AMOUNT');
833         TransferHelper.safeTransferFrom(
834             path[0], msg.sender, FraxswapRouterLibrary.pairFor(factory, path[0], path[1]), amounts[0]
835         );
836         _swap(amounts, path, address(this));
837         IWETH(WETH).withdraw(amounts[amounts.length - 1]);
838         TransferHelper.safeTransferETH(to, amounts[amounts.length - 1]);
839     }
840     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
841     external
842     virtual
843     override
844     payable
845     ensure(deadline)
846     returns (uint[] memory amounts)
847     {
848         require(path[0] == WETH, 'FraxswapV1Router: INVALID_PATH');
849         amounts = FraxswapRouterLibrary.getAmountsInWithTwamm(factory, amountOut, path);
850         require(amounts[0] <= msg.value, 'FraxswapV1Router: EXCESSIVE_INPUT_AMOUNT');
851         IWETH(WETH).deposit{value: amounts[0]}();
852         assert(IWETH(WETH).transfer(FraxswapRouterLibrary.pairFor(factory, path[0], path[1]), amounts[0]));
853         _swap(amounts, path, to);
854         // refund dust eth, if any
855         if (msg.value > amounts[0]) TransferHelper.safeTransferETH(msg.sender, msg.value - amounts[0]);
856     }
857 
858     // **** SWAP (supporting fee-on-transfer tokens) ****
859     // requires the initial amount to have already been sent to the first pair
860     function _swapSupportingFeeOnTransferTokens(address[] memory path, address _to) internal virtual {
861         for (uint i; i < path.length - 1; i++) {
862             (address input, address output) = (path[i], path[i + 1]);
863             (address token0,) = FraxswapRouterLibrary.sortTokens(input, output);
864             IFraxswapPair pair = IFraxswapPair(FraxswapRouterLibrary.pairFor(factory, input, output));
865             uint amountInput;
866             uint amountOutput;
867             { // scope to avoid stack too deep errors
868                 (uint reserveInput, uint reserveOutput, uint twammReserveInput, uint twammReserveOutput) =  FraxswapRouterLibrary.getReservesWithTwamm(factory, input, output);
869                 amountInput = IERC20(input).balanceOf(address(pair)) - reserveInput - twammReserveInput;
870                 amountOutput = FraxswapRouterLibrary.getAmountOut(amountInput, reserveInput, reserveOutput);
871             }
872             (uint amount0Out, uint amount1Out) = input == token0 ? (uint(0), amountOutput) : (amountOutput, uint(0));
873             address to = i < path.length - 2 ? FraxswapRouterLibrary.pairFor(factory, output, path[i + 2]) : _to;
874             pair.swap(amount0Out, amount1Out, to, new bytes(0));
875         }
876     }
877     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
878         uint amountIn,
879         uint amountOutMin,
880         address[] calldata path,
881         address to,
882         uint deadline
883     ) external virtual override ensure(deadline) {
884         TransferHelper.safeTransferFrom(
885             path[0], msg.sender, FraxswapRouterLibrary.pairFor(factory, path[0], path[1]), amountIn
886         );
887         uint balanceBefore = IERC20(path[path.length - 1]).balanceOf(to);
888         _swapSupportingFeeOnTransferTokens(path, to);
889         require(
890             IERC20(path[path.length - 1]).balanceOf(to) - balanceBefore >= amountOutMin,
891             'FraxswapV1Router: INSUFFICIENT_OUTPUT_AMOUNT'
892         );
893     }
894     function swapExactETHForTokensSupportingFeeOnTransferTokens(
895         uint amountOutMin,
896         address[] calldata path,
897         address to,
898         uint deadline
899     )
900     external
901     virtual
902     override
903     payable
904     ensure(deadline)
905     {
906         require(path[0] == WETH, 'FraxswapV1Router: INVALID_PATH');
907         uint amountIn = msg.value;
908         IWETH(WETH).deposit{value: amountIn}();
909         assert(IWETH(WETH).transfer(FraxswapRouterLibrary.pairFor(factory, path[0], path[1]), amountIn));
910         uint balanceBefore = IERC20(path[path.length - 1]).balanceOf(to);
911         _swapSupportingFeeOnTransferTokens(path, to);
912         require(
913             IERC20(path[path.length - 1]).balanceOf(to) - balanceBefore >= amountOutMin,
914             'FraxswapV1Router: INSUFFICIENT_OUTPUT_AMOUNT'
915         );
916     }
917     function swapExactTokensForETHSupportingFeeOnTransferTokens(
918         uint amountIn,
919         uint amountOutMin,
920         address[] calldata path,
921         address to,
922         uint deadline
923     )
924     external
925     virtual
926     override
927     ensure(deadline)
928     {
929         require(path[path.length - 1] == WETH, 'FraxswapV1Router: INVALID_PATH');
930         TransferHelper.safeTransferFrom(
931             path[0], msg.sender, FraxswapRouterLibrary.pairFor(factory, path[0], path[1]), amountIn
932         );
933         _swapSupportingFeeOnTransferTokens(path, address(this));
934         uint amountOut = IERC20(WETH).balanceOf(address(this));
935         require(amountOut >= amountOutMin, 'FraxswapV1Router: INSUFFICIENT_OUTPUT_AMOUNT');
936         IWETH(WETH).withdraw(amountOut);
937         TransferHelper.safeTransferETH(to, amountOut);
938     }
939 
940     // **** LIBRARY FUNCTIONS ****
941     function quote(uint amountA, uint reserveA, uint reserveB) public pure virtual override returns (uint amountB) {
942         return FraxswapRouterLibrary.quote(amountA, reserveA, reserveB);
943     }
944 
945     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut)
946     public
947     pure
948     virtual
949     override
950     returns (uint amountOut)
951     {
952         return FraxswapRouterLibrary.getAmountOut(amountIn, reserveIn, reserveOut);
953     }
954 
955     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut)
956     public
957     pure
958     virtual
959     override
960     returns (uint amountIn)
961     {
962         return FraxswapRouterLibrary.getAmountIn(amountOut, reserveIn, reserveOut);
963     }
964 
965     function getAmountsOut(uint amountIn, address[] memory path)
966     public
967     view
968     virtual
969     override
970     returns (uint[] memory amounts)
971     {
972         return FraxswapRouterLibrary.getAmountsOut(factory, amountIn, path);
973     }
974 
975     function getAmountsIn(uint amountOut, address[] memory path)
976     public
977     view
978     virtual
979     override
980     returns (uint[] memory amounts)
981     {
982         return FraxswapRouterLibrary.getAmountsIn(factory, amountOut, path);
983     }
984 
985     function getAmountsOutWithTwamm(uint amountIn, address[] memory path)
986     public
987     returns (uint[] memory amounts)
988     {
989         return FraxswapRouterLibrary.getAmountsOutWithTwamm(factory, amountIn, path);
990     }
991 
992     function getAmountsInWithTwamm(uint amountOut, address[] memory path)
993     public
994     returns (uint[] memory amounts)
995     {
996         return FraxswapRouterLibrary.getAmountsInWithTwamm(factory, amountOut, path);
997     }
998 }