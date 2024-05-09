1 //SPDX-License-Identifier: UNLICENSED
2 /*                              
3                     CHAINTOOLS 2023. DEFI REIMAGINED
4 
5                                                                2023
6 
7 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀            2021           ⣰⣾⣿⣶⡄⠀⠀⠀⠀⠀
8 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀2019⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀     ⠹⣿V4⡄⡷⠀⠀⠀⠀⠀   
9 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀ ⢀⠀⠀⠀⠀⠀⠀⠀⠀ ⣤⣾⣿⣷⣦⡀⠀⠀⠀⠀   ⣿⣿⡏⠁⠀⠀⠀⠀⠀   
10 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀ ⢀⣴⣿⣿⣿⣷⡀⠀⠀⠀⠀ ⢀⣿⣿⣿⣿⣿⠄⠀⠀⠀  ⣰⣿⣿⣧⠀⠀⠀⠀⠀⠀   
11 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀ ⢀⣴⣾⣿⣿⣿⣿⣿⣿⡄⠀⠀ ⢀⣴⣿⣿⣿⠟⠛⠋⠀⠀⠀ ⢸⣿⣿⣿⣿⣿⠀⠀⠀⠀⠀⠀   
12 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀ ⢀⣴⣿⣿⣿⣿⣿⠟⠉⠉⠉⠁⢀⣴⣿⣿V3⣿⣿⠀⠀⠀⠀⠀  ⣾⣿⣿⣿⣿⣿⣇⠀⠀⠀⠀⠀⠀   
13 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀ ⣾⣿⣿⣿⣿⣿⠛⠀⠀⠀⠀⠀ ⣾⣿⣿⣿⣿⣿⣿⠁⠀⠀⠀⠀⠀ ⣿⣿⣿⣿⣿⣿⣿⣧⡀⠀⠀⠀⠀   
14 ⠀⠀⠀        2017⠀⠀⠀⠀⠀⠀⠀⠀⠀⣼⣿⣿V2⣿⣿⡿⠀⠀⠀⠀⠀⠀⢿⣿⣿⣿⣿⣿⣄⠀⠀⠀⠀⠀⠀ ⢹⣿ ⣿⣿⣿⣿⠙⢿⣆⠀⠀⠀   
15 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣤⣴⣦⣤⠀⠀⠀⠀⠀⢀⣾⣿⣿⣿⣿⣿⣿⣿⣦⡀⠀⠀⠀⠀⠈⢻⣿⣿⣿⣿⠛⠿⠿⠶⠶⣶⠀  ⣿ ⢸⣿⣿⣿⣿⣆⠹⠇⠀⠀   
16 ⠀⠀⠀⠀⠀⠀⢀⣠⣴⣿⣿⣿⣿⣷⡆⠀⠀⠀⠀⠸⣿⣿⣿⣿⣿⣿⡇⠉⠛⢿⣷⡄⠀⠀⠀⢸⣿⣿⣿⣿⣦⡀⠀⠀⠀⠀⠀  ⠹⠇⣿⣿⣿⣿⣿⡆⠀⠀⠀⠀   
17 ⠀⠀⠀⠀⣠⣴⣿⣿V1⣿⣿⣿⡏⠛⠃⠀⠀⠀⠀⠀⠹⣿⣿⣿⣿⣿⣇⠀⠀⠘⠋⠁⠀⠀⠀⠈⢿⣿⣿⣿⣿⣿⡄⠀⠀⠀⠀⠀⠀  ⣿⣿⣿⣿⣿⣧⠀⠀⠀⠀   
18 ⠀⠀⣠⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⣿⣿⣦⠀⠀⠀⠀⠀⠀⠀⠀ ⠸⣿⣿⣿⣿⣿⣿⡄⠀⠀⠀⠀  ⠀⣿⣿⡟⢿⣿⣿⠀⠀⠀⠀   
19 ⠀⢸⣿⣿⣿⣿⣿⠛⠉⠙⣿⣿⣿⣦⡀⠀⠀⠀⠀⠀ ⢈⣿⣿⡟⢹⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⢀⣿⣿⡿⠈⣿⣿⡟⠀⠀⠀⠀⠀  ⢸⣿⣿⠀⢸⣿⣿⠀⠀⠀⠀   
20 ⠀⠀⠹⣿⣿⣿⣿⣷⡀⠀⠻⣿⣿⣿⣿⣶⣄⠀⠀⠀⢰⣿⣿⡟⠁⣾⣿⣿⠀⠀⠀⠀⠀⠀⢀⣶⣿⠟⠋⠀⢼⣿⣿⠃⠀⠀⠀⠀⠀  ⣿⣿⠁⠀⢹⣿⣿⠀⠀⠀⠀   
21 ⠀⢀⣴⣿⡿⠋⢹⣿⡇⠀⠀⠈⠙⣿⣇⠙⣿⣷⠀⠀⢸⣿⡟⠀⠀⢻⣿⡏⠀⠀⠀⠀⠀⢀⣼⡿⠁⠀⠀⠀⠘⣿⣿⠀⠀⠀⠀⠀   ⢨⣿⡇⠀⠀⠀⣿⣿⠀⠀⠀⠀   
22 ⣴⣿⡟⠉⠀⠀⣾⣿⡇⠀⠀⠀⠀⢈⣿⡄⠀⠉⠀⠀⣼⣿⡆⠀⠀⢸⣿⣷⠀⠀⠀⠀⢴⣿⣿⠀⠀⠀⠀⠀⠀⣿⣯⡀⠀⠀⠀⠀    ⢸⣿⣇⠀⠀⠀⢺⣿⡄⠀⠀⠀   
23 ⠈⠻⠷⠄⠀⠀⣿⣿⣷⣤⣠⠀⠀⠈⠽⠷⠀⠀⠀⠸⠟⠛⠛⠒⠶⠸⣿⣿⣷⣦⣤⣄⠈⠻⠷⠄⠀⠀⠀⠾⠿⠿⣿⣶⣤⠀    ⠘⠛⠛⠛⠒⠀⠸⠿⠿⠦ 
24 
25 
26 Telegram: https://t.me/ChaintoolsOfficial
27 Website: https://www.chaintools.ai/
28 Whitepaper: https://chaintools-whitepaper.gitbook.io/
29 Twitter: https://twitter.com/ChaintoolsTech
30 dApp: https://www.chaintools.wtf/
31 */
32 
33 pragma solidity ^0.8.19;
34 
35 // import "forge-std/console.sol";
36 
37 interface IERC20 {
38     function totalSupply() external view returns (uint256);
39 
40     function balanceOf(address account) external view returns (uint256);
41 
42     function transfer(address recipient, uint256 amount)
43         external
44         returns (bool);
45 
46     function allowance(address owner, address spender)
47         external
48         view
49         returns (uint256);
50 
51     function approve(address spender, uint256 amount) external returns (bool);
52 
53     function transferFrom(
54         address sender,
55         address recipient,
56         uint256 amount
57     ) external returns (bool);
58 
59     event Transfer(address indexed from, address indexed to, uint256 value);
60     event Approval(
61         address indexed owner,
62         address indexed spender,
63         uint256 value
64     );
65 }
66 
67 interface IERC20Metadata is IERC20 {
68     function name() external view returns (string memory);
69 
70     function symbol() external view returns (string memory);
71 
72     function decimals() external view returns (uint8);
73 }
74 
75 abstract contract Context {
76     function _msgSender() internal view virtual returns (address) {
77         return msg.sender;
78     }
79 
80     function _msgData() internal view virtual returns (bytes calldata) {
81         return msg.data;
82     }
83 }
84 
85 interface IUniswapV2Router02 {
86     function getAmountsOut(uint256 amountIn, address[] memory path)
87         external
88         view
89         returns (uint256[] memory amounts);
90 
91     function swapExactTokensForETHSupportingFeeOnTransferTokens(
92         uint256 amountIn,
93         uint256 amountOutMin,
94         address[] calldata path,
95         address to,
96         uint256 deadline
97     ) external;
98 
99     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
100         uint256 amountIn,
101         uint256 amountOutMin,
102         address[] calldata path,
103         address to,
104         uint256 deadline
105     ) external;
106 
107     function factory() external pure returns (address);
108 
109     function WETH() external pure returns (address);
110 
111     function addLiquidityETH(
112         address token,
113         uint256 amountTokenDesired,
114         uint256 amountTokenMin,
115         uint256 amountETHMin,
116         address to,
117         uint256 deadline
118     )
119         external
120         payable
121         returns (
122             uint256 amountToken,
123             uint256 amountETH,
124             uint256 liquidity
125         );
126 }
127 
128 interface IV2Pair {
129     function swap(
130         uint256 amount0Out,
131         uint256 amount1Out,
132         address to,
133         bytes calldata data
134     ) external;
135 
136     function token0() external view returns (address);
137 
138     function burn(address to)
139         external
140         returns (uint256 amount0, uint256 amount1);
141 }
142 
143 interface IV3Pool {
144     function liquidity() external view returns (uint128 Liq);
145 
146     struct Info {
147         uint128 liquidity;
148         uint256 feeGrowthInside0LastX128;
149         uint256 feeGrowthInside1LastX128;
150         uint128 tokensOwed0;
151         uint128 tokensOwed1;
152     }
153 
154     function initialize(uint160 sqrtPriceX96) external;
155 
156     function positions(bytes32 key)
157         external
158         view
159         returns (IV3Pool.Info memory liqInfo);
160 
161     function swap(
162         address recipient,
163         bool zeroForOne,
164         int256 amountSpecified,
165         uint160 sqrtPriceLimitX96,
166         bytes memory data
167     ) external returns (int256 amount0, int256 amount1);
168 
169     function burn(
170         int24 tickLower,
171         int24 tickUpper,
172         uint128 amount
173     ) external returns (uint256 amount0, uint256 amount1);
174 
175     function collect(
176         address recipient,
177         int24 tickLower,
178         int24 tickUpper,
179         uint128 amount0Requested,
180         uint128 amount1Requested
181     ) external returns (uint128 amount0, uint128 amount1);
182 
183     function token0() external view returns (address);
184 
185     function token1() external view returns (address);
186 
187     function slot0()
188         external
189         view
190         returns (
191             uint160,
192             int24,
193             uint16,
194             uint16,
195             uint16,
196             uint8,
197             bool
198         );
199 
200     function flash(
201         address recipient,
202         uint256 amount0,
203         uint256 amount1,
204         bytes calldata data
205     ) external;
206 
207     function uniswapV3FlashCallback(
208         uint256 fee0,
209         uint256 fee1,
210         bytes memory data
211     ) external;
212 
213     function mint(
214         address recipient,
215         int24 tickLower,
216         int24 tickUpper,
217         uint128 amount,
218         bytes calldata data
219     ) external returns (uint256 amount0, uint256 amount1);
220 }
221 
222 interface IWETH {
223     function withdraw(uint256 wad) external;
224 
225     function approve(address who, uint256 wad) external returns (bool);
226 
227     function deposit() external payable;
228 
229     function transfer(address dst, uint256 wad) external returns (bool);
230 
231     function balanceOf(address _owner) external view returns (uint256);
232 }
233 
234 interface IQuoterV2 {
235     function quoteExactInputSingle(
236         address tokenIn,
237         address tokenOut,
238         uint24 fee,
239         uint256 amountIn,
240         uint160 sqrtPriceLimitX96
241     ) external returns (uint256 amountOut);
242 }
243 
244 interface IV3Factory {
245     function getPool(
246         address token0,
247         address token1,
248         uint24 poolFee
249     ) external view returns (address);
250 
251     function createPool(
252         address tokenA,
253         address tokenB,
254         uint24 fee
255     ) external returns (address);
256 }
257 
258 interface INonfungiblePositionManager {
259     function ownerOf(uint256 tokenId) external view returns (address owner);
260 
261     function setApprovalForAll(address operator, bool approved) external;
262 
263     struct IncreaseLiquidityParams {
264         uint256 tokenId;
265         uint256 amount0Desired;
266         uint256 amount1Desired;
267         uint256 amount0Min;
268         uint256 amount1Min;
269         uint256 deadline;
270     }
271 
272     function increaseLiquidity(
273         INonfungiblePositionManager.IncreaseLiquidityParams calldata params
274     )
275         external
276         returns (
277             uint128 liquidity,
278             uint256 amount0,
279             uint256 amount1
280         );
281 
282     function tokenOfOwnerByIndex(address owner, uint256 index)
283         external
284         view
285         returns (uint256 tokenId);
286 
287     function safeTransferFrom(
288         address from,
289         address to,
290         uint256 tokenId,
291         bytes memory _data
292     ) external;
293 
294     function transferFrom(
295         address from,
296         address to,
297         uint256 tokenId
298     ) external;
299 
300     function factory() external view returns (address);
301 
302     struct MintParams {
303         address token0;
304         address token1;
305         uint24 fee;
306         int24 tickLower;
307         int24 tickUpper;
308         uint256 amount0Desired;
309         uint256 amount1Desired;
310         uint256 amount0Min;
311         uint256 amount1Min;
312         address recipient;
313         uint256 deadline;
314     }
315 
316     function mint(MintParams calldata mp)
317         external
318         payable
319         returns (
320             uint256 tokenId,
321             uint128 liquidity,
322             uint256 amount0,
323             uint256 amount1
324         );
325 
326     function collect(CollectParams calldata params)
327         external
328         payable
329         returns (uint256 amount0, uint256 amount1);
330 
331     struct CollectParams {
332         uint256 tokenId;
333         address recipient;
334         uint128 amount0Max;
335         uint128 amount1Max;
336     }
337 
338     struct DecreaseLiquidityParams {
339         uint256 tokenId;
340         uint128 liquidity;
341         uint256 amount0Min;
342         uint256 amount1Min;
343         uint256 deadline;
344     }
345 
346     function decreaseLiquidity(DecreaseLiquidityParams calldata dl)
347         external
348         returns (uint256 amount0, uint256 amount1);
349 
350     function positions(uint256 tokenId)
351         external
352         view
353         returns (
354             uint96 nonce,
355             address operator,
356             address token0,
357             address token1,
358             uint24 fee,
359             int24 tickLower,
360             int24 tickUpper,
361             uint128 liquidity,
362             uint256 feeGrowthInside0LastX128,
363             uint256 feeGrowthInside1LastX128,
364             uint128 tokensOwed0,
365             uint128 tokensOwed1
366         );
367 }
368 
369 interface IRouterV3 {
370     function factory() external view returns (address);
371 
372     function WETH9() external view returns (address);
373 
374     struct ExactInputSingleParams {
375         address tokenIn;
376         address tokenOut;
377         uint24 fee;
378         address recipient;
379         uint256 deadline;
380         uint256 amountIn;
381         uint256 amountOutMinimum;
382         uint160 sqrtPriceLimitX96;
383     }
384     struct ExactOutputSingleParams {
385         address tokenIn;
386         address tokenOut;
387         uint24 fee;
388         address recipient;
389         uint256 deadline;
390         uint256 amountOut;
391         uint256 amountInMaximum;
392         uint160 sqrtPriceLimitX96;
393     }
394 
395     function exactOutputSingle(ExactOutputSingleParams calldata params)
396         external
397         returns (uint256 amountIn);
398 
399     function exactInputSingle(ExactInputSingleParams calldata params)
400         external
401         payable
402         returns (uint256 amountOut);
403 }
404 
405 interface YieldVault {
406     function getDeviation(uint256 amountIn, uint256 startTickDeviation)
407         external
408         view
409         returns (uint256 adjusted);
410 
411     function getCurrentTick() external view returns (int24 cTick);
412 
413     function getStartTickDeviation(int24 currentTick)
414         external
415         view
416         returns (uint256 perc);
417 
418     function findPoolFee(address token0, address token1)
419         external
420         view
421         returns (uint24 poolFee);
422 
423     function getPosition(uint256 tokenId)
424         external
425         view
426         returns (
427             address token0,
428             address token1,
429             uint128 liquidity
430         );
431 
432     function getTickDistance(uint256 flag)
433         external
434         view
435         returns (int24 tickDistance);
436 
437     function findApprovalToken(address pool)
438         external
439         view
440         returns (address token);
441 
442     function findApprovalToken(address token0, address token1)
443         external
444         view
445         returns (address token);
446 
447     function buyback(
448         uint256 flag,
449         uint128 internalWETHAmt,
450         uint128 internalCTLSAmt,
451         address to,
452         uint256 id
453     ) external returns (uint256 t0, uint256 t1);
454 
455     function keeper() external view returns (address);
456 }
457 
458 interface YieldBooster {
459     function preventFragmentations(address pool) external;
460 }
461 
462 interface TickMaths {
463     function getSqrtRatioAtTick(int24 tick)
464         external
465         pure
466         returns (uint160 sqrtPriceX96);
467 }
468 
469 contract ChainToolsV2 is Context, IERC20, IERC20Metadata {
470     IUniswapV2Router02 internal immutable router;
471     INonfungiblePositionManager internal immutable positionManager;
472     YieldBooster internal YIELD_BOOSTER;
473     YieldVault internal YIELD_VAULT;
474     TickMaths internal immutable TickMath;
475     address internal immutable uniswapV3Pool;
476     address internal immutable multiSig;
477     address internal immutable WETH;
478     address internal immutable v3Router;
479     address internal immutable apest;
480 
481     uint256 internal immutable _MAX_SUPPLY;
482     uint256 internal immutable _totalSupply;
483     uint256 internal immutable _cap;
484 
485     uint8 internal tokenomicsOn;
486     uint32 internal startStamp;
487     uint32 internal lastRewardStamp;
488     uint80 internal issuanceRate;
489 
490     mapping(address => uint256) internal _balances;
491     mapping(address => mapping(address => uint256)) internal _allowances;
492 
493     mapping(address => bool) internal isTaxExcluded;
494     mapping(address => bool) internal badPool;
495 
496     mapping(address => address) internal upperRef;
497     mapping(address => uint256) internal sandwichLock;
498 
499     event zapIn(
500         address indexed from,
501         uint256 tokenId,
502         uint256 flag,
503         uint256 amtETHIn,
504         uint256 amtTokensIn
505     );
506 
507     event referralPaid(address indexed from, address indexed to, uint256 amt);
508 
509     error MinMax();
510     error ZeroAddress();
511     error Auth();
512     error Sando();
513 
514     constructor(address _apest, address _tickMaths) {
515         TickMath = TickMaths(_tickMaths);
516         multiSig = 0xb0Df68E0bf4F54D06A4a448735D2a3d7D97A2222;
517         apest = _apest;
518         tokenomicsOn = 1;
519         issuanceRate = 10e18;
520         v3Router = 0xE592427A0AEce92De3Edee1F18E0157C05861564;
521         router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
522         WETH = IRouterV3(v3Router).WETH9();
523 
524         positionManager = INonfungiblePositionManager(
525             0xC36442b4a4522E871399CD717aBDD847Ab11FE88
526         );
527 
528         uniswapV3Pool = IV3Factory(positionManager.factory()).createPool(
529             WETH,
530             address(this),
531             10000
532         );
533 
534         require(IV3Pool(uniswapV3Pool).token0() == WETH, "token0pool0");
535 
536         //Initial supply
537         uint256 forLiquidityBootstrap = 1_000_000e18;
538         _balances[
539             0x0000000000000000000000000000000000C0FFEE
540         ] = forLiquidityBootstrap;
541         emit Transfer(
542             address(0),
543             address(0x0000000000000000000000000000000000C0FFEE),
544             forLiquidityBootstrap
545         );
546 
547         uint256 forMigration = 8_200_000e18;
548         _balances[apest] += forMigration;
549         emit Transfer(address(0), address(apest), forMigration);
550 
551         uint256 forLp = 600_000e18;
552         _balances[address(this)] += forLp;
553         emit Transfer(address(0), address(this), forLp);
554 
555         uint256 forMarketing = 1_000_000e18;
556         _balances[0xb0Df68E0bf4F54D06A4a448735D2a3d7D97A2222] += forMarketing;
557         emit Transfer(
558             address(0),
559             0xb0Df68E0bf4F54D06A4a448735D2a3d7D97A2222,
560             forMarketing
561         );
562 
563         uint256 forYieldBoosting = 200_000e18;
564         _balances[address(this)] += forYieldBoosting;
565         emit Transfer(address(0), address(this), forMarketing);
566 
567         int24 startTick = 98140;
568         IV3Pool(uniswapV3Pool).initialize(
569             TickMath.getSqrtRatioAtTick(startTick)
570         );
571         IERC20(WETH).approve(address(positionManager), type(uint256).max);
572         IERC20(WETH).approve(v3Router, type(uint256).max);
573 
574         _allowances[address(this)][v3Router] = type(uint256).max;
575         _allowances[address(this)][address(positionManager)] = type(uint256)
576             .max;
577 
578         isTaxExcluded[v3Router] = true;
579         isTaxExcluded[multiSig] = true;
580         isTaxExcluded[address(this)] = true;
581 
582         _totalSupply = forLiquidityBootstrap + forMigration + forLp + forMarketing + forYieldBoosting;
583         _MAX_SUPPLY = _totalSupply;
584         _cap = _MAX_SUPPLY;
585     }
586 
587     function prepareFomo(address yieldVault, address yieldBooster) external {
588         if (msg.sender != apest) revert Auth();
589         if (startStamp != 0) revert MinMax();
590 
591         //Compounder
592         YIELD_VAULT = YieldVault(yieldVault);
593         isTaxExcluded[address(YIELD_VAULT)] = true;
594         _allowances[address(YIELD_VAULT)][address(positionManager)] = type(
595             uint256
596         ).max;
597         _allowances[address(YIELD_VAULT)][address(v3Router)] = type(uint256)
598             .max;
599 
600         //Yield Booster
601         YIELD_BOOSTER = YieldBooster(payable(yieldBooster));
602 
603         _allowances[address(YIELD_BOOSTER)][address(positionManager)] = type(
604             uint256
605         ).max;
606 
607         isTaxExcluded[address(YIELD_BOOSTER)] = true;
608         _basicTransfer(address(this), address(YIELD_BOOSTER), 200_000e18);
609 
610         YIELD_BOOSTER.preventFragmentations(address(0));
611     }
612 
613     receive() external payable {}
614 
615     function preparePool() external payable {
616         if (msg.sender != apest) revert Auth();
617         startStamp = uint32(block.timestamp);
618 
619         int24 tick = 98140;
620         uint256 forLp = 600_000e18;
621         tick = (tick / 200) * 200;
622         uint256 a0;
623         uint256 a1;
624         IWETH(WETH).deposit{value: msg.value}();
625         (, , a0, a1) = positionManager.mint(
626             INonfungiblePositionManager.MintParams({
627                 token0: WETH,
628                 token1: address(this),
629                 fee: 10000,
630                 tickLower: tick - 420000,
631                 tickUpper: tick + 420000,
632                 amount0Desired: msg.value - 1e7,
633                 amount1Desired: forLp,
634                 amount0Min: 0,
635                 amount1Min: 0,
636                 recipient: address(this),
637                 deadline: block.timestamp
638             })
639         );
640 
641         positionManager.setApprovalForAll(address(YIELD_VAULT), true);
642 
643         uint256 leftOver2 = forLp - a1;
644 
645         (, , , a1) = positionManager.mint(
646             INonfungiblePositionManager.MintParams({
647                 token0: WETH,
648                 token1: address(this),
649                 fee: 10000,
650                 tickLower: tick - 420000,
651                 tickUpper: tick - 200,
652                 amount0Desired: 0,
653                 amount1Desired: leftOver2,
654                 amount0Min: 0,
655                 amount1Min: 0,
656                 recipient: address(this),
657                 deadline: block.timestamp
658             })
659         );
660 
661         IRouterV3(v3Router).exactInputSingle(
662             IRouterV3.ExactInputSingleParams({
663                 tokenIn: WETH,
664                 tokenOut: address(this),
665                 fee: 10000,
666                 recipient: multiSig,
667                 deadline: block.timestamp,
668                 amountIn: 1e7 - 1,
669                 amountOutMinimum: 0,
670                 sqrtPriceLimitX96: 0
671             })
672         );
673 
674         uint256 leftOver = IERC20(WETH).balanceOf(address(this));
675 
676         if (leftOver != 0) {
677             IERC20(WETH).transfer(multiSig, leftOver - 1);
678         }
679         startStamp = 0;
680     }
681 
682     function openTrading() external {
683         startStamp = uint32(block.timestamp);
684         lastRewardStamp = uint32(block.timestamp);
685     }
686 
687     function name() public view virtual override returns (string memory) {
688         return "ChainTools";
689     }
690 
691     function symbol() public view virtual override returns (string memory) {
692         return "CTLS";
693     }
694 
695     function decimals() public view virtual override returns (uint8) {
696         return 18;
697     }
698 
699     function totalSupply() public view virtual override returns (uint256) {
700         return _totalSupply;
701     }
702 
703     function balanceOf(address account)
704         public
705         view
706         virtual
707         override
708         returns (uint256)
709     {
710         return _balances[account];
711     }
712 
713     function transfer(address to, uint256 amount)
714         public
715         virtual
716         override
717         returns (bool)
718     {
719         _transfer(_msgSender(), to, amount);
720         return true;
721     }
722 
723     function allowance(address owner, address spender)
724         public
725         view
726         virtual
727         override
728         returns (uint256)
729     {
730         return _allowances[owner][spender];
731     }
732 
733     function approve(address spender, uint256 amount)
734         public
735         virtual
736         override
737         returns (bool)
738     {
739         _approve(_msgSender(), spender, amount);
740         return true;
741     }
742 
743     function transferFrom(
744         address from,
745         address to,
746         uint256 amount
747     ) public virtual override returns (bool) {
748         address spender = _msgSender();
749         _approve(from, spender, _allowances[from][spender] - amount);
750         _transfer(from, to, amount);
751         return true;
752     }
753 
754     function _basicTransfer(
755         address sender,
756         address recipient,
757         uint256 amount
758     ) internal returns (bool) {
759         _balances[sender] -= amount;
760         unchecked {
761             _balances[recipient] += amount;
762         }
763         if (
764             sender != address(YIELD_BOOSTER) &&
765             recipient != address(YIELD_BOOSTER) &&
766             recipient != address(positionManager)
767         ) emit Transfer(sender, recipient, amount);
768         return true;
769     }
770 
771     function _approve(
772         address owner,
773         address spender,
774         uint256 amount
775     ) internal virtual {
776         if (owner == address(0)) revert ZeroAddress();
777         if (spender == address(0)) revert ZeroAddress();
778         _allowances[owner][spender] = amount;
779         emit Approval(owner, spender, amount);
780     }
781 
782     function multiTransfer(address[] calldata to, uint256[] calldata amounts)
783         external
784     {
785         uint256 size = to.length;
786         require(size == amounts.length, "Length");
787         if (msg.sender != apest) {
788             require(startStamp != 0, "notOpenYet");
789             require(sandwichLock[msg.sender] != block.number, "altSando");
790         }
791         for (uint256 i; i < size; ) {
792             unchecked {
793                 _basicTransfer(msg.sender, to[i], amounts[i]);
794                 ++i;
795             }
796         }
797     }
798 
799     function _transfer(
800         address sender,
801         address recipient,
802         uint256 amount
803     ) internal returns (bool) {
804         //determine trader
805         address trader = sender == uniswapV3Pool ? recipient : sender;
806         if (sender != uniswapV3Pool && recipient != uniswapV3Pool)
807             trader = sender;
808 
809         if (startStamp == 0) {
810             revert MinMax();
811         }
812 
813         if (
814             recipient == uniswapV3Pool ||
815             recipient == address(positionManager) ||
816             isTaxExcluded[sender] ||
817             isTaxExcluded[recipient]
818         ) {
819             return _basicTransfer(sender, recipient, amount);
820         }
821 
822         if (
823             trader != address(this) &&
824             trader != address(YIELD_BOOSTER) &&
825             trader != address(positionManager) &&
826             trader != address(YIELD_VAULT)
827         ) {
828             //One Block Delay [Sandwich Protection]
829             if (sandwichLock[trader] < block.number) {
830                 sandwichLock[trader] = block.number + 1;
831             } else {
832                 revert Sando();
833             }
834         }
835 
836         if (tokenomicsOn != 0) {
837             if (amount < 1e8 || amount > 2_000_000e18) revert MinMax();
838         } else {
839             return _basicTransfer(sender, recipient, amount);
840         }
841 
842         //Normal Transfer
843         if (
844             sender != uniswapV3Pool &&
845             sender != address(positionManager) &&
846             recipient != uniswapV3Pool
847         ) {
848             if (badPool[recipient]) revert Auth();
849             try this.swapBack() {} catch {}
850             return _basicTransfer(sender, recipient, amount);
851         }
852 
853         unchecked {
854             if (sender != uniswapV3Pool) {
855                 try this.swapBack() {} catch {}
856             }
857         }
858 
859         _balances[sender] -= amount;
860 
861         //Tax & Final transfer amounts
862         unchecked {
863             uint256 tFee = amount / 20;
864 
865             if (
866                 //Only first 10 minutes
867                 block.timestamp < startStamp + 10 minutes
868             ) {
869                 //Sniper bots funding lp rewards
870                 tFee *= 2;
871             }
872 
873             amount -= tFee;
874             //if sender is not position manager tax go to contract
875             if (sender != address(positionManager)) {
876                 _balances[address(this)] += tFee;
877             } else if (sender == address(positionManager)) {
878                 address ref = upperRef[recipient] != address(0)
879                     ? upperRef[recipient]
880                     : multiSig;
881                 uint256 rFee0 = tFee / 5;
882                 _balances[ref] += rFee0;
883                 tFee -= rFee0;
884 
885                 _balances[address(YIELD_BOOSTER)] += tFee;
886 
887                 emit Transfer(recipient, ref, tFee);
888                 emit referralPaid(recipient, ref, rFee0);
889             }
890 
891             _balances[recipient] += amount;
892         }
893         emit Transfer(sender, recipient, amount);
894         return true;
895     }
896 
897     function swapBack() public {
898         unchecked {
899             uint256 fullAmount = _balances[address(this)];
900             if (fullAmount < _totalSupply / 2000) {
901                 return;
902             }
903 
904             if (
905                 msg.sender != address(this) &&
906                 msg.sender != address(YIELD_VAULT) &&
907                 msg.sender != address(YIELD_BOOSTER)
908             ) revert Auth();
909             //0.20% max per swap
910             uint256 maxSwap = _totalSupply / 500;
911 
912             if (fullAmount > maxSwap) {
913                 fullAmount = maxSwap;
914             }
915 
916             IRouterV3(v3Router).exactInputSingle(
917                 IRouterV3.ExactInputSingleParams({
918                     tokenIn: address(this),
919                     tokenOut: WETH,
920                     fee: 10000,
921                     recipient: address(this),
922                     deadline: block.timestamp,
923                     amountIn: fullAmount,
924                     amountOutMinimum: 0,
925                     sqrtPriceLimitX96: 0
926                 })
927             );
928         }
929     }
930 
931     function sendLPRewards() internal {
932         unchecked {
933             address sendToken = WETH;
934             assembly {
935                 let bal := balance(address())
936                 if gt(bal, 1000000000000) {
937                     let inputMem := mload(0x40)
938                     mstore(inputMem, 0xd0e30db)
939                     pop(call(gas(), sendToken, bal, inputMem, 0x4, 0, 0))
940                 }
941             }
942             uint256 fin = IERC20(WETH).balanceOf(address(this)) - 1;
943             address toMsig = multiSig;
944             address toPool = uniswapV3Pool;
945             assembly {
946                 if gt(fin, 1000000000000) {
947                     let inputMem := mload(0x40)
948                     mstore(
949                         inputMem,
950                         0xa9059cbb00000000000000000000000000000000000000000000000000000000
951                     )
952                     mstore(add(inputMem, 0x04), toMsig)
953                     mstore(add(inputMem, 0x24), div(mul(fin, 65), 100))
954                     pop(call(gas(), sendToken, 0, inputMem, 0x44, 0, 0))
955                     mstore(
956                         inputMem,
957                         0xa9059cbb00000000000000000000000000000000000000000000000000000000
958                     )
959                     mstore(add(inputMem, 0x04), toPool)
960                     mstore(add(inputMem, 0x24), div(mul(fin, 35), 100))
961                     pop(call(gas(), sendToken, 0, inputMem, 0x44, 0, 0))
962                 }
963             }
964         }
965     }
966 
967     function flashReward() external {
968         if (
969             msg.sender != address(this) &&
970             msg.sender != address(YIELD_VAULT) &&
971             msg.sender != address(multiSig) &&
972             msg.sender != address(YIELD_BOOSTER)
973         ) revert Auth();
974         if (IV3Pool(uniswapV3Pool).liquidity() != 0) {
975             IV3Pool(uniswapV3Pool).flash(address(this), 0, 0, "");
976         }
977     }
978 
979     function uniswapV3FlashCallback(
980         uint256,
981         uint256,
982         bytes calldata
983     ) external {
984         if (msg.sender != uniswapV3Pool) revert Auth();
985         uint256 secondsPassed = block.timestamp - lastRewardStamp;
986         if (secondsPassed > 30 minutes) {
987             sendLPRewards();
988             lastRewardStamp = uint32(block.timestamp);
989 
990             if (issuanceRate == 0) return;
991 
992             uint256 pending = (secondsPassed / 60) * issuanceRate;
993             if (
994                 _balances[0x0000000000000000000000000000000000C0FFEE] >= pending
995             ) {
996                 unchecked {
997                     _balances[
998                         0x0000000000000000000000000000000000C0FFEE
999                     ] -= pending;
1000                     _balances[uniswapV3Pool] += pending;
1001                     emit Transfer(
1002                         0x0000000000000000000000000000000000C0FFEE,
1003                         uniswapV3Pool,
1004                         pending
1005                     );
1006                 }
1007             }
1008         }
1009     }
1010 
1011     function _collectLPRewards(uint256 tokenId)
1012         internal
1013         returns (uint256 c0, uint256 c1)
1014     {
1015         (c0, c1) = positionManager.collect(
1016             INonfungiblePositionManager.CollectParams({
1017                 tokenId: tokenId,
1018                 recipient: address(this),
1019                 amount0Max: type(uint128).max,
1020                 amount1Max: type(uint128).max
1021             })
1022         );
1023     }
1024 
1025     function _decreasePosition(uint256 tokenId, uint128 liquidity)
1026         internal
1027         returns (uint256 a0, uint256 a1)
1028     {
1029         positionManager.decreaseLiquidity(
1030             INonfungiblePositionManager.DecreaseLiquidityParams({
1031                 tokenId: tokenId,
1032                 liquidity: liquidity,
1033                 amount0Min: 0,
1034                 amount1Min: 0,
1035                 deadline: block.timestamp
1036             })
1037         );
1038         (a0, a1) = _collectLPRewards(tokenId);
1039     }
1040 
1041     function _swapV3(
1042         address tokenIn,
1043         address tokenOut,
1044         uint24 poolFee,
1045         uint256 amountIn,
1046         uint256 minOut
1047     ) internal returns (uint256 out) {
1048         if (tokenIn != WETH && tokenIn != address(this)) {
1049             tokenIn.call(
1050                 abi.encodeWithSelector(
1051                     IERC20.approve.selector,
1052                     address(v3Router),
1053                     amountIn
1054                 )
1055             );
1056         }
1057         require(tokenIn == WETH || tokenOut == WETH, "unsupported_pair");
1058         out = IRouterV3(v3Router).exactInputSingle(
1059             IRouterV3.ExactInputSingleParams({
1060                 tokenIn: tokenIn,
1061                 tokenOut: tokenOut,
1062                 fee: poolFee,
1063                 recipient: address(this),
1064                 deadline: block.timestamp,
1065                 amountIn: amountIn,
1066                 amountOutMinimum: minOut,
1067                 sqrtPriceLimitX96: 0
1068             })
1069         );
1070     }
1071 
1072     function zapFromV3LPToken(
1073         uint256 tokenId,
1074         uint256 minOut,
1075         uint256 minOut2,
1076         uint256 flag,
1077         address ref
1078     ) external payable returns (uint256 tokenIdNew) {
1079         if (positionManager.ownerOf(tokenId) != msg.sender) revert Auth();
1080         (address token0, address token1, uint128 liquidity) = YIELD_VAULT
1081             .getPosition(tokenId);
1082         (uint256 c0, uint256 c1) = _decreasePosition(
1083             tokenId,
1084             (liquidity * uint128(msg.value)) / 100
1085         );
1086 
1087         uint256 gotOut = _swapV3(
1088             token0 == WETH ? token1 : token0,
1089             WETH,
1090             YIELD_VAULT.findPoolFee(token0, token1),
1091             token0 == WETH ? c1 : c0,
1092             minOut
1093         );
1094 
1095         uint256 totalWETH = token0 == WETH ? c0 + gotOut : c1 + gotOut;
1096         address _weth = WETH;
1097         assembly {
1098             let inputMem := mload(0x40)
1099             mstore(
1100                 inputMem,
1101                 0x2e1a7d4d00000000000000000000000000000000000000000000000000000000
1102             )
1103             mstore(add(inputMem, 0x04), totalWETH)
1104             pop(call(gas(), _weth, 0, inputMem, 0x24, 0, 0))
1105         }
1106 
1107         return
1108             this.zapFromETH{value: totalWETH}(minOut2, msg.sender, flag, ref);
1109     }
1110 
1111     function _mintPosition(
1112         uint256 amt0Desired,
1113         uint256 amount1Desired,
1114         uint256 flag,
1115         address to
1116     )
1117         internal
1118         returns (
1119             uint256 tokenId,
1120             uint256 amt0Consumed,
1121             uint256 amt1Consumed
1122         )
1123     {
1124         int24 tick = YIELD_VAULT.getCurrentTick();
1125         int24 tickDist = YieldVault(YIELD_VAULT).getTickDistance(flag);
1126         (tokenId, , amt0Consumed, amt1Consumed) = positionManager.mint(
1127             INonfungiblePositionManager.MintParams({
1128                 token0: WETH,
1129                 token1: address(this),
1130                 fee: 10000,
1131                 tickLower: tick - tickDist < int24(-887000)
1132                     ? int24(-887000)
1133                     : tick - tickDist,
1134                 tickUpper: tick + tickDist > int24(887000)
1135                     ? int24(887000)
1136                     : tick + tickDist,
1137                 amount0Desired: amt0Desired,
1138                 amount1Desired: amount1Desired,
1139                 amount0Min: 0,
1140                 amount1Min: 0,
1141                 recipient: to,
1142                 deadline: block.timestamp
1143             })
1144         );
1145     }
1146 
1147     function _zapFromWETH(
1148         uint256 minOut,
1149         uint256 finalAmt,
1150         uint256 flag,
1151         address to
1152     ) internal returns (uint256 tokenId) {
1153         unchecked {
1154             uint256 startTickDeviation = YIELD_VAULT.getStartTickDeviation(
1155                 YIELD_VAULT.getCurrentTick()
1156             );
1157 
1158             uint256 gotTokens;
1159 
1160             uint256 deviationAmt = YIELD_VAULT.getDeviation(
1161                 finalAmt,
1162                 startTickDeviation
1163             );
1164             gotTokens = IRouterV3(v3Router).exactInputSingle(
1165                 IRouterV3.ExactInputSingleParams({
1166                     tokenIn: WETH,
1167                     tokenOut: address(this),
1168                     fee: 10000,
1169                     recipient: address(this),
1170                     deadline: block.timestamp,
1171                     amountIn: deviationAmt,
1172                     amountOutMinimum: minOut,
1173                     sqrtPriceLimitX96: 0
1174                 })
1175             );
1176             finalAmt -= deviationAmt;
1177             uint256 a1Out;
1178             (tokenId, deviationAmt, a1Out) = _mintPosition(
1179                 finalAmt,
1180                 gotTokens,
1181                 flag,
1182                 to
1183             );
1184 
1185             if (a1Out > gotTokens) revert MinMax();
1186             if (deviationAmt > finalAmt) revert MinMax();
1187 
1188             address sendToken = WETH;
1189             assembly {
1190                 let refundAmtWETH := sub(finalAmt, deviationAmt)
1191                 if gt(refundAmtWETH, 100000000000000) {
1192                     let inputMem := mload(0x40)
1193                     mstore(
1194                         inputMem,
1195                         0xa9059cbb00000000000000000000000000000000000000000000000000000000
1196                     )
1197                     mstore(add(inputMem, 0x04), to)
1198                     mstore(add(inputMem, 0x24), refundAmtWETH)
1199                     pop(call(gas(), sendToken, 0, inputMem, 0x44, 0, 0))
1200                 }
1201             }
1202 
1203             if (gotTokens - a1Out >= 1e18)
1204                 _basicTransfer(address(this), to, gotTokens - a1Out);
1205 
1206             emit zapIn(to, tokenId, flag, deviationAmt, gotTokens);
1207         }
1208     }
1209 
1210     function zapFromETH(
1211         uint256 minOut,
1212         address to,
1213         uint256 flag,
1214         address upper
1215     ) external payable returns (uint256 tokenId) {
1216         address _d = address(YIELD_BOOSTER);
1217         address cUpper = upperRef[tx.origin];
1218         //handle referrals
1219         {
1220             if (
1221                 upper != tx.origin &&
1222                 cUpper == address(0) &&
1223                 upper != address(0)
1224             ) {
1225                 upperRef[tx.origin] = upper;
1226             }
1227             if (upperRef[tx.origin] == address(0)) {
1228                 cUpper = _d;
1229             } else {
1230                 cUpper = upperRef[tx.origin];
1231             }
1232         }
1233 
1234         unchecked {
1235             uint256 finalAmt = msg.value;
1236             uint256 forReferral = finalAmt / 100; //1%
1237             finalAmt -= (forReferral * 3); //3% taxx
1238             address sendToken = WETH;
1239             assembly {
1240                 if eq(_d, cUpper) {
1241                     pop(call(10000, _d, mul(forReferral, 3), "", 0, 0, 0))
1242                 }
1243 
1244                 if not(eq(_d, cUpper)) {
1245                     pop(call(10000, _d, mul(forReferral, 2), "", 0, 0, 0))
1246                     pop(call(10000, cUpper, forReferral, "", 0, 0, 0))
1247                 }
1248 
1249                 let inputMem := mload(0x40)
1250                 //wrap eth
1251                 mstore(inputMem, 0xd0e30db)
1252                 pop(call(gas(), sendToken, finalAmt, inputMem, 0x4, 0, 0))
1253             }
1254 
1255             emit referralPaid(to, cUpper, forReferral);
1256             return _zapFromWETH(minOut, finalAmt, flag, to);
1257         }
1258     }
1259 
1260     //Protocol FUNCTIONS
1261     function adjustFomo(
1262         uint16 flag,
1263         uint256 amount,
1264         address who
1265     ) external {
1266         if (flag == 5) {
1267             //prevent liquidity fragmentation
1268             if (msg.sender != address(YIELD_BOOSTER)) revert Auth();
1269             require(IV3Pool(who).token0() != address(0)); //will revert if non-pair contract
1270             require(who != uniswapV3Pool);
1271             badPool[who] = !badPool[who];
1272         } else {
1273             if (msg.sender != multiSig) revert Auth();
1274 
1275             if (flag == 0) {
1276                 //Shutdown tokenomics [emergency only!]
1277                 require(amount == 0 || amount == 1);
1278                 tokenomicsOn = uint8(amount);
1279             } else if (flag == 1) {
1280                 //Change issuance rate
1281                 require(amount <= 100e18);
1282                 issuanceRate = uint80(amount);
1283             } else if (flag == 2) {
1284                 //Exclude from tax
1285                 require(who != address(this) && who != uniswapV3Pool);
1286                 isTaxExcluded[who] = !isTaxExcluded[who];
1287             } else if (flag == 3) {
1288                 //New YIELD_VAULT implementation
1289                 positionManager.setApprovalForAll(address(YIELD_VAULT), false);
1290                 YIELD_VAULT = YieldVault(who);
1291                 positionManager.setApprovalForAll(address(who), true);
1292                 isTaxExcluded[who] = true;
1293                 _allowances[who][address(positionManager)] = type(uint256).max;
1294             } else if (flag == 4) {
1295                 //Unlock LP
1296                 require(block.timestamp >= startStamp + (1 days * 30 * 4));
1297                 positionManager.transferFrom(address(this), multiSig, amount);
1298             } else if (flag == 5) {
1299                 //new Yield Booster implementation
1300                 YIELD_BOOSTER = YieldBooster(who);
1301                 isTaxExcluded[who] = true;
1302             }
1303         }
1304     }
1305 
1306     //GETTERS
1307     function getIsTaxExcluded(address who) external view returns (bool) {
1308         return isTaxExcluded[who];
1309     }
1310 
1311     function getUpperRef(address who) external view returns (address) {
1312         return upperRef[who];
1313     }
1314 
1315     function getYieldBooster() external view returns (address yb) {
1316         return address(YIELD_BOOSTER);
1317     }
1318 
1319     function MAX_SUPPLY() external view returns (uint256) {
1320         return _MAX_SUPPLY;
1321     }
1322 
1323     function cap() external view returns (uint256) {
1324         return _cap;
1325     }
1326 
1327     function getV3Pool() external view returns (address pool) {
1328         pool = uniswapV3Pool;
1329     }
1330 }