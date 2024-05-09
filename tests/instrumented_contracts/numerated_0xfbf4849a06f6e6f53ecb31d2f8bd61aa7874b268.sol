1 pragma solidity 0.6.7;
2 
3 contract GebMath {
4     uint256 public constant RAY = 10 ** 27;
5     uint256 public constant WAD = 10 ** 18;
6 
7     function ray(uint x) public pure returns (uint z) {
8         z = multiply(x, 10 ** 9);
9     }
10     function rad(uint x) public pure returns (uint z) {
11         z = multiply(x, 10 ** 27);
12     }
13     function minimum(uint x, uint y) public pure returns (uint z) {
14         z = (x <= y) ? x : y;
15     }
16     function addition(uint x, uint y) public pure returns (uint z) {
17         z = x + y;
18         require(z >= x, "uint-uint-add-overflow");
19     }
20     function subtract(uint x, uint y) public pure returns (uint z) {
21         z = x - y;
22         require(z <= x, "uint-uint-sub-underflow");
23     }
24     function multiply(uint x, uint y) public pure returns (uint z) {
25         require(y == 0 || (z = x * y) / y == x, "uint-uint-mul-overflow");
26     }
27     function rmultiply(uint x, uint y) public pure returns (uint z) {
28         z = multiply(x, y) / RAY;
29     }
30     function rdivide(uint x, uint y) public pure returns (uint z) {
31         z = multiply(x, RAY) / y;
32     }
33     function wdivide(uint x, uint y) public pure returns (uint z) {
34         z = multiply(x, WAD) / y;
35     }
36     function wmultiply(uint x, uint y) public pure returns (uint z) {
37         z = multiply(x, y) / WAD;
38     }
39     function rpower(uint x, uint n, uint base) public pure returns (uint z) {
40         assembly {
41             switch x case 0 {switch n case 0 {z := base} default {z := 0}}
42             default {
43                 switch mod(n, 2) case 0 { z := base } default { z := x }
44                 let half := div(base, 2)  // for rounding.
45                 for { n := div(n, 2) } n { n := div(n,2) } {
46                     let xx := mul(x, x)
47                     if iszero(eq(div(xx, x), x)) { revert(0,0) }
48                     let xxRound := add(xx, half)
49                     if lt(xxRound, xx) { revert(0,0) }
50                     x := div(xxRound, base)
51                     if mod(n,2) {
52                         let zx := mul(z, x)
53                         if and(iszero(iszero(x)), iszero(eq(div(zx, x), z))) { revert(0,0) }
54                         let zxRound := add(zx, half)
55                         if lt(zxRound, zx) { revert(0,0) }
56                         z := div(zxRound, base)
57                     }
58                 }
59             }
60         }
61     }
62 }
63 
64 interface IUniswapV2Factory {
65     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
66 
67     function feeTo() external view returns (address);
68     function feeToSetter() external view returns (address);
69 
70     function getPair(address tokenA, address tokenB) external view returns (address pair);
71     function allPairs(uint) external view returns (address pair);
72     function allPairsLength() external view returns (uint);
73 
74     function createPair(address tokenA, address tokenB) external returns (address pair);
75 
76     function setFeeTo(address) external;
77     function setFeeToSetter(address) external;
78 }
79 
80 interface IUniswapV2Pair {
81     event Approval(address indexed owner, address indexed spender, uint value);
82     event Transfer(address indexed from, address indexed to, uint value);
83 
84     function name() external pure returns (string memory);
85     function symbol() external pure returns (string memory);
86     function decimals() external pure returns (uint8);
87     function totalSupply() external view returns (uint);
88     function balanceOf(address owner) external view returns (uint);
89     function allowance(address owner, address spender) external view returns (uint);
90 
91     function approve(address spender, uint value) external returns (bool);
92     function transfer(address to, uint value) external returns (bool);
93     function transferFrom(address from, address to, uint value) external returns (bool);
94 
95     function DOMAIN_SEPARATOR() external view returns (bytes32);
96     function PERMIT_TYPEHASH() external pure returns (bytes32);
97     function nonces(address owner) external view returns (uint);
98 
99     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
100 
101     event Mint(address indexed sender, uint amount0, uint amount1);
102     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
103     event Swap(
104         address indexed sender,
105         uint amount0In,
106         uint amount1In,
107         uint amount0Out,
108         uint amount1Out,
109         address indexed to
110     );
111     event Sync(uint112 reserve0, uint112 reserve1);
112 
113     function MINIMUM_LIQUIDITY() external pure returns (uint);
114     function factory() external view returns (address);
115     function token0() external view returns (address);
116     function token1() external view returns (address);
117     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
118     function price0CumulativeLast() external view returns (uint);
119     function price1CumulativeLast() external view returns (uint);
120     function kLast() external view returns (uint);
121 
122     function mint(address to) external returns (uint liquidity);
123     function burn(address to) external returns (uint amount0, uint amount1);
124     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
125     function skim(address to) external;
126     function sync() external;
127 
128     function initialize(address, address) external;
129 }
130 
131 interface IUniswapV2Router01 {
132     function factory() external pure returns (address);
133     function WETH() external pure returns (address);
134 
135     function addLiquidity(
136         address tokenA,
137         address tokenB,
138         uint amountADesired,
139         uint amountBDesired,
140         uint amountAMin,
141         uint amountBMin,
142         address to,
143         uint deadline
144     ) external returns (uint amountA, uint amountB, uint liquidity);
145     function addLiquidityETH(
146         address token,
147         uint amountTokenDesired,
148         uint amountTokenMin,
149         uint amountETHMin,
150         address to,
151         uint deadline
152     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
153     function removeLiquidity(
154         address tokenA,
155         address tokenB,
156         uint liquidity,
157         uint amountAMin,
158         uint amountBMin,
159         address to,
160         uint deadline
161     ) external returns (uint amountA, uint amountB);
162     function removeLiquidityETH(
163         address token,
164         uint liquidity,
165         uint amountTokenMin,
166         uint amountETHMin,
167         address to,
168         uint deadline
169     ) external returns (uint amountToken, uint amountETH);
170     function removeLiquidityWithPermit(
171         address tokenA,
172         address tokenB,
173         uint liquidity,
174         uint amountAMin,
175         uint amountBMin,
176         address to,
177         uint deadline,
178         bool approveMax, uint8 v, bytes32 r, bytes32 s
179     ) external returns (uint amountA, uint amountB);
180     function removeLiquidityETHWithPermit(
181         address token,
182         uint liquidity,
183         uint amountTokenMin,
184         uint amountETHMin,
185         address to,
186         uint deadline,
187         bool approveMax, uint8 v, bytes32 r, bytes32 s
188     ) external returns (uint amountToken, uint amountETH);
189     function swapExactTokensForTokens(
190         uint amountIn,
191         uint amountOutMin,
192         address[] calldata path,
193         address to,
194         uint deadline
195     ) external returns (uint[] memory amounts);
196     function swapTokensForExactTokens(
197         uint amountOut,
198         uint amountInMax,
199         address[] calldata path,
200         address to,
201         uint deadline
202     ) external returns (uint[] memory amounts);
203     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
204         external
205         payable
206         returns (uint[] memory amounts);
207     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
208         external
209         returns (uint[] memory amounts);
210     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
211         external
212         returns (uint[] memory amounts);
213     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
214         external
215         payable
216         returns (uint[] memory amounts);
217 
218     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
219     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
220     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
221     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
222     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
223 }
224 
225 interface IUniswapV2Router02 is IUniswapV2Router01 {
226     function removeLiquidityETHSupportingFeeOnTransferTokens(
227         address token,
228         uint liquidity,
229         uint amountTokenMin,
230         uint amountETHMin,
231         address to,
232         uint deadline
233     ) external returns (uint amountETH);
234     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
235         address token,
236         uint liquidity,
237         uint amountTokenMin,
238         uint amountETHMin,
239         address to,
240         uint deadline,
241         bool approveMax, uint8 v, bytes32 r, bytes32 s
242     ) external returns (uint amountETH);
243 
244     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
245         uint amountIn,
246         uint amountOutMin,
247         address[] calldata path,
248         address to,
249         uint deadline
250     ) external;
251     function swapExactETHForTokensSupportingFeeOnTransferTokens(
252         uint amountOutMin,
253         address[] calldata path,
254         address to,
255         uint deadline
256     ) external payable;
257     function swapExactTokensForETHSupportingFeeOnTransferTokens(
258         uint amountIn,
259         uint amountOutMin,
260         address[] calldata path,
261         address to,
262         uint deadline
263     ) external;
264 }
265 
266 // computes square roots using the babylonian method
267 // https://en.wikipedia.org/wiki/Methods_of_computing_square_roots#Babylonian_method
268 contract BabylonianMath {
269     function sqrt(uint y) internal pure returns (uint z) {
270         if (y > 3) {
271             z = y;
272             uint x = y / 2 + 1;
273             while (x < z) {
274                 z = x;
275                 x = (y / x + x) / 2;
276             }
277         } else if (y != 0) {
278             z = 1;
279         }
280         // else z = 0
281     }
282 }
283 
284 // Contract for handling binary fixed point numbers (https://en.wikipedia.org/wiki/Q_(number_format))
285 contract FixedPointMath is BabylonianMath {
286     // range: [0, 2**112 - 1]
287     // resolution: 1 / 2**112
288     struct uq112x112 {
289         uint224 _x;
290     }
291 
292     // range: [0, 2**144 - 1]
293     // resolution: 1 / 2**112
294     struct uq144x112 {
295         uint _x;
296     }
297 
298     uint8 private constant RESOLUTION = 112;
299     uint private constant Q112 = uint(1) << RESOLUTION;
300     uint private constant Q224 = Q112 << RESOLUTION;
301 
302     // encode a uint112 as a UQ112x112
303     function encode(uint112 x) internal pure returns (uq112x112 memory) {
304         return uq112x112(uint224(x) << RESOLUTION);
305     }
306 
307     // encodes a uint144 as a UQ144x112
308     function encode144(uint144 x) internal pure returns (uq144x112 memory) {
309         return uq144x112(uint256(x) << RESOLUTION);
310     }
311 
312     // divide a UQ112x112 by a uint112, returning a UQ112x112
313     function div(uq112x112 memory self, uint112 x) internal pure returns (uq112x112 memory) {
314         require(x != 0, 'FixedPoint: DIV_BY_ZERO');
315         return uq112x112(self._x / uint224(x));
316     }
317 
318     // multiply a UQ112x112 by a uint, returning a UQ144x112
319     // reverts on overflow
320     function mul(uq112x112 memory self, uint y) internal pure returns (uq144x112 memory) {
321         uint z;
322         require(y == 0 || (z = uint(self._x) * y) / y == uint(self._x), "FixedPoint: MULTIPLICATION_OVERFLOW");
323         return uq144x112(z);
324     }
325 
326     // returns a UQ112x112 which represents the ratio of the numerator to the denominator
327     // equivalent to encode(numerator).divide(denominator)
328     function frac(uint112 numerator, uint112 denominator) internal pure returns (uq112x112 memory) {
329         require(denominator > 0, "FixedPoint: DIV_BY_ZERO");
330         return uq112x112((uint224(numerator) << RESOLUTION) / denominator);
331     }
332 
333     // decode a UQ112x112 into a uint112 by truncating after the radix point
334     function decode(uq112x112 memory self) internal pure returns (uint112) {
335         return uint112(self._x >> RESOLUTION);
336     }
337 
338     // decode a UQ144x112 into a uint144 by truncating after the radix point
339     function decode144(uq144x112 memory self) internal pure returns (uint144) {
340         return uint144(self._x >> RESOLUTION);
341     }
342 
343     // take the reciprocal of a UQ112x112
344     function reciprocal(uq112x112 memory self) internal pure returns (uq112x112 memory) {
345         require(self._x != 0, 'FixedPoint: ZERO_RECIPROCAL');
346         return uq112x112(uint224(Q224 / self._x));
347     }
348 
349     // square root of a UQ112x112
350     function sqrt(uq112x112 memory self) internal pure returns (uq112x112 memory) {
351         return uq112x112(uint224(super.sqrt(uint256(self._x)) << 56));
352     }
353 }
354 
355 // Contract with helper methods for oracles that are concerned with computing average prices
356 contract UniswapV2OracleLibrary is FixedPointMath {
357     // Helper function that returns the current block timestamp within the range of uint32, i.e. [0, 2**32 - 1]
358     function currentBlockTimestamp() internal view returns (uint32) {
359         return uint32(block.timestamp % 2 ** 32);
360     }
361 
362     // Produces the cumulative price using counterfactuals to save gas and avoid a call to sync.
363     function currentCumulativePrices(
364         address pair
365     ) internal view returns (uint price0Cumulative, uint price1Cumulative, uint32 blockTimestamp) {
366         blockTimestamp = currentBlockTimestamp();
367         price0Cumulative = IUniswapV2Pair(pair).price0CumulativeLast();
368         price1Cumulative = IUniswapV2Pair(pair).price1CumulativeLast();
369 
370         // if time has elapsed since the last update on the pair, mock the accumulated price values
371         (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast) = IUniswapV2Pair(pair).getReserves();
372         if (blockTimestampLast != blockTimestamp) {
373             // subtraction overflow is desired
374             uint32 timeElapsed = blockTimestamp - blockTimestampLast;
375             // addition overflow is desired
376             // counterfactual
377             price0Cumulative += uint(frac(reserve1, reserve0)._x) * timeElapsed;
378             // counterfactual
379             price1Cumulative += uint(frac(reserve0, reserve1)._x) * timeElapsed;
380         }
381     }
382 }
383 
384 contract UniswapV2Library {
385     // --- Math ---
386     function uniAddition(uint x, uint y) internal pure returns (uint z) {
387         require((z = x + y) >= x, 'UniswapV2Library: add-overflow');
388     }
389     function uniSubtract(uint x, uint y) internal pure returns (uint z) {
390         require((z = x - y) <= x, 'UniswapV2Library: sub-underflow');
391     }
392     function uniMultiply(uint x, uint y) internal pure returns (uint z) {
393         require(y == 0 || (z = x * y) / y == x, 'UniswapV2Library: mul-overflow');
394     }
395 
396     // returns sorted token addresses, used to handle return values from pairs sorted in this order
397     function sortTokens(address tokenA, address tokenB) internal pure returns (address token0, address token1) {
398         require(tokenA != tokenB, 'UniswapV2Library: IDENTICAL_ADDRESSES');
399         (token0, token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
400         require(token0 != address(0), 'UniswapV2Library: ZERO_ADDRESS');
401     }
402 
403     // Modified Uniswap function to work with dapp.tools (CREATE2 throws)
404     function pairFor(address factory, address tokenA, address tokenB) internal view returns (address pair) {
405         (address token0, address token1) = sortTokens(tokenA, tokenB);
406         return IUniswapV2Factory(factory).getPair(tokenA, tokenB);
407     }
408 
409     // fetches and sorts the reserves for a pair; modified from the initial Uniswap version in order to work with dapp.tools
410     function getReserves(address factory, address tokenA, address tokenB) internal view returns (uint reserveA, uint reserveB) {
411         (address token0,) = sortTokens(tokenA, tokenB);
412         (uint reserve0, uint reserve1,) = IUniswapV2Pair(IUniswapV2Factory(factory).getPair(tokenA, tokenB)).getReserves();
413         (reserveA, reserveB) = tokenA == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
414     }
415 
416     // Given some amount of an asset and pair reserves, returns an equivalent amount of the other asset
417     function quote(uint amountA, uint reserveA, uint reserveB) internal pure returns (uint amountB) {
418         require(amountA > 0, 'UniswapV2Library: INSUFFICIENT_AMOUNT');
419         require(reserveA > 0 && reserveB > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
420         amountB = uniMultiply(amountA, reserveB) / reserveA;
421     }
422 
423     // Given an input amount of an asset and pair reserves, returns the maximum output amount of the other asset
424     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) internal pure returns (uint amountOut) {
425         require(amountIn > 0, 'UniswapV2Library: INSUFFICIENT_INPUT_AMOUNT');
426         require(reserveIn > 0 && reserveOut > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
427         uint amountInWithFee = uniMultiply(amountIn, 997);
428         uint numerator = uniMultiply(amountInWithFee, reserveOut);
429         uint denominator = uniAddition(uniMultiply(reserveIn, 1000), amountInWithFee);
430         amountOut = numerator / denominator;
431     }
432 
433     // given an output amount of an asset and pair reserves, returns a required input amount of the other asset
434     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) internal pure returns (uint amountIn) {
435         require(amountOut > 0, 'UniswapV2Library: INSUFFICIENT_OUTPUT_AMOUNT');
436         require(reserveIn > 0 && reserveOut > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
437         uint numerator = uniMultiply(uniMultiply(reserveIn, amountOut), 1000);
438         uint denominator = uniMultiply(uniSubtract(reserveOut, amountOut), 997);
439         amountIn = uniAddition((numerator / denominator), 1);
440     }
441 
442     // performs chained getAmountOut calculations on any number of pairs
443     function getAmountsOut(address factory, uint amountIn, address[] memory path) internal view returns (uint[] memory amounts) {
444         require(path.length >= 2, 'UniswapV2Library: INVALID_PATH');
445         amounts = new uint[](path.length);
446         amounts[0] = amountIn;
447         for (uint i; i < path.length - 1; i++) {
448             (uint reserveIn, uint reserveOut) = getReserves(factory, path[i], path[i + 1]);
449             amounts[i + 1] = getAmountOut(amounts[i], reserveIn, reserveOut);
450         }
451     }
452 
453     // performs chained getAmountIn calculations on any number of pairs
454     function getAmountsIn(address factory, uint amountOut, address[] memory path) internal view returns (uint[] memory amounts) {
455         require(path.length >= 2, 'UniswapV2Library: INVALID_PATH');
456         amounts = new uint[](path.length);
457         amounts[amounts.length - 1] = amountOut;
458         for (uint i = path.length - 1; i > 0; i--) {
459             (uint reserveIn, uint reserveOut) = getReserves(factory, path[i - 1], path[i]);
460             amounts[i - 1] = getAmountIn(amounts[i], reserveIn, reserveOut);
461         }
462     }
463 }
464 
465 abstract contract ConverterFeedLike {
466     function getResultWithValidity() virtual external view returns (uint256,bool);
467     function updateResult(address) virtual external;
468 }
469 
470 abstract contract IncreasingRewardRelayerLike {
471     function reimburseCaller(address) virtual external;
472 }
473 
474 contract UniswapConsecutiveSlotsPriceFeedMedianizer is GebMath, UniswapV2Library, UniswapV2OracleLibrary {
475     // --- Auth ---
476     mapping (address => uint) public authorizedAccounts;
477     /**
478      * @notice Add auth to an account
479      * @param account Account to add auth to
480      */
481     function addAuthorization(address account) virtual external isAuthorized {
482         authorizedAccounts[account] = 1;
483         emit AddAuthorization(account);
484     }
485     /**
486      * @notice Remove auth from an account
487      * @param account Account to remove auth from
488      */
489     function removeAuthorization(address account) virtual external isAuthorized {
490         authorizedAccounts[account] = 0;
491         emit RemoveAuthorization(account);
492     }
493     /**
494     * @notice Checks whether msg.sender can call an authed function
495     **/
496     modifier isAuthorized {
497         require(authorizedAccounts[msg.sender] == 1, "UniswapConsecutiveSlotsPriceFeedMedianizer/account-not-authorized");
498         _;
499     }
500 
501     // --- Observations ---
502     struct UniswapObservation {
503         uint timestamp;
504         uint price0Cumulative;
505         uint price1Cumulative;
506     }
507     struct ConverterFeedObservation {
508         uint timestamp;
509         uint timeAdjustedPrice;
510     }
511 
512     // --- Uniswap Vars ---
513     // Default amount of targetToken used when calculating the denominationToken output
514     uint256              public defaultAmountIn;
515     // Token for which the contract calculates the medianPrice for
516     address              public targetToken;
517     // Pair token from the Uniswap pair
518     address              public denominationToken;
519     address              public uniswapPair;
520 
521     IUniswapV2Factory    public uniswapFactory;
522 
523     UniswapObservation[] public uniswapObservations;
524 
525     // --- Converter Feed Vars ---
526     // Latest converter price accumulator snapshot
527     uint256                    public converterPriceCumulative;
528 
529     ConverterFeedLike          public converterFeed;
530     ConverterFeedObservation[] public converterFeedObservations;
531 
532     // --- General Vars ---
533     // Symbol - you want to change this every deployment
534     bytes32 public symbol = "raiusd";
535 
536     uint8   public granularity;
537     // When the price feed was last updated
538     uint256 public lastUpdateTime;
539     // Total number of updates
540     uint256 public updates;
541     /**
542       The ideal amount of time over which the moving average should be computed, e.g. 24 hours.
543       In practice it can and most probably will be different than the actual window over which the contract medianizes.
544     **/
545     uint256 public windowSize;
546     // Maximum window size used to determine if the median is 'valid' (close to the real one) or not
547     uint256 public maxWindowSize;
548     // Stored for gas savings. Equals windowSize / granularity
549     uint256 public periodSize;
550     // This is the denominator for computing
551     uint256 public converterFeedScalingFactor;
552     // The last computed median price
553     uint256 private medianPrice;
554     // Manual flag that can be set by governance and indicates if a result is valid or not
555     uint256 public validityFlag;
556 
557     // Contract relaying the SF reward to addresses that update this oracle
558     IncreasingRewardRelayerLike public relayer;
559 
560     // --- Events ---
561     event AddAuthorization(address account);
562     event RemoveAuthorization(address account);
563     event ModifyParameters(
564       bytes32 parameter,
565       address addr
566     );
567     event ModifyParameters(
568       bytes32 parameter,
569       uint256 val
570     );
571     event UpdateResult(uint256 medianPrice, uint256 lastUpdateTime);
572     event FailedConverterFeedUpdate(bytes reason);
573     event FailedUniswapPairSync(bytes reason);
574     event FailedReimburseCaller(bytes revertReason);
575 
576     constructor(
577       address converterFeed_,
578       address uniswapFactory_,
579       uint256 defaultAmountIn_,
580       uint256 windowSize_,
581       uint256 converterFeedScalingFactor_,
582       uint256 maxWindowSize_,
583       uint8   granularity_
584     ) public {
585         require(uniswapFactory_ != address(0), "UniswapConsecutiveSlotsPriceFeedMedianizer/null-uniswap-factory");
586         require(granularity_ > 1, 'UniswapConsecutiveSlotsPriceFeedMedianizer/null-granularity');
587         require(windowSize_ > 0, 'UniswapConsecutiveSlotsPriceFeedMedianizer/null-window-size');
588         require(maxWindowSize_ > windowSize_, 'UniswapConsecutiveSlotsPriceFeedMedianizer/invalid-max-window-size');
589         require(defaultAmountIn_ > 0, 'UniswapConsecutiveSlotsPriceFeedMedianizer/invalid-default-amount-in');
590         require(converterFeedScalingFactor_ > 0, 'UniswapConsecutiveSlotsPriceFeedMedianizer/null-feed-scaling-factor');
591         require(
592             (periodSize = windowSize_ / granularity_) * granularity_ == windowSize_,
593             'UniswapConsecutiveSlotsPriceFeedMedianizer/window-not-evenly-divisible'
594         );
595 
596         authorizedAccounts[msg.sender] = 1;
597 
598         converterFeed                  = ConverterFeedLike(converterFeed_);
599         uniswapFactory                 = IUniswapV2Factory(uniswapFactory_);
600         defaultAmountIn                = defaultAmountIn_;
601         windowSize                     = windowSize_;
602         maxWindowSize                  = maxWindowSize_;
603         converterFeedScalingFactor     = converterFeedScalingFactor_;
604         granularity                    = granularity_;
605         lastUpdateTime                 = now;
606         validityFlag                   = 1;
607 
608         // Emit events
609         emit AddAuthorization(msg.sender);
610         emit ModifyParameters(bytes32("converterFeed"), converterFeed_);
611         emit ModifyParameters(bytes32("maxWindowSize"), maxWindowSize_);
612     }
613 
614     // --- Administration ---
615     /**
616     * @notice Modify address parameters
617     * @param parameter Name of the parameter to modify
618     * @param data New parameter value
619     **/
620     function modifyParameters(bytes32 parameter, address data) external isAuthorized {
621         require(data != address(0), "UniswapConsecutiveSlotsPriceFeedMedianizer/null-data");
622         if (parameter == "converterFeed") {
623           require(data != address(0), "UniswapConsecutiveSlotsPriceFeedMedianizer/null-converter-feed");
624           converterFeed = ConverterFeedLike(data);
625         }
626         else if (parameter == "targetToken") {
627           require(uniswapPair == address(0), "UniswapConsecutiveSlotsPriceFeedMedianizer/pair-already-set");
628           targetToken = data;
629           if (denominationToken != address(0)) {
630             uniswapPair = uniswapFactory.getPair(targetToken, denominationToken);
631             require(uniswapPair != address(0), "UniswapConsecutiveSlotsPriceFeedMedianizer/null-uniswap-pair");
632           }
633         }
634         else if (parameter == "denominationToken") {
635           require(uniswapPair == address(0), "UniswapConsecutiveSlotsPriceFeedMedianizer/pair-already-set");
636           denominationToken = data;
637           if (targetToken != address(0)) {
638             uniswapPair = uniswapFactory.getPair(targetToken, denominationToken);
639             require(uniswapPair != address(0), "UniswapConsecutiveSlotsPriceFeedMedianizer/null-uniswap-pair");
640           }
641         }
642         else if (parameter == "relayer") {
643           relayer = IncreasingRewardRelayerLike(data);
644         }
645         else revert("UniswapConsecutiveSlotsPriceFeedMedianizer/modify-unrecognized-param");
646         emit ModifyParameters(parameter, data);
647     }
648     /**
649     * @notice Modify uint256 parameters
650     * @param parameter Name of the parameter to modify
651     * @param data New parameter value
652     **/
653     function modifyParameters(bytes32 parameter, uint256 data) external isAuthorized {
654         if (parameter == "validityFlag") {
655           require(either(data == 1, data == 0), "UniswapConsecutiveSlotsPriceFeedMedianizer/invalid-data");
656           validityFlag = data;
657         }
658         else if (parameter == "defaultAmountIn") {
659           require(data > 0, "UniswapConsecutiveSlotsPriceFeedMedianizer/invalid-default-amount-in");
660           defaultAmountIn = data;
661         }
662         else if (parameter == "maxWindowSize") {
663           require(data > windowSize, 'UniswapConsecutiveSlotsPriceFeedMedianizer/invalid-max-window-size');
664           maxWindowSize = data;
665         }
666         else revert("UniswapConsecutiveSlotsPriceFeedMedianizer/modify-unrecognized-param");
667         emit ModifyParameters(parameter, data);
668     }
669 
670     // --- General Utils ---
671     function either(bool x, bool y) internal pure returns (bool z) {
672         assembly{ z := or(x, y)}
673     }
674     function both(bool x, bool y) private pure returns (bool z) {
675         assembly{ z := and(x, y)}
676     }
677     /**
678     * @notice Returns the oldest observations (relative to the current index in the Uniswap/Converter lists)
679     **/
680     function getFirstObservationsInWindow()
681       private view returns (UniswapObservation storage firstUniswapObservation, ConverterFeedObservation storage firstConverterFeedObservation) {
682         uint256 earliestObservationIndex = earliestObservationIndex();
683         firstUniswapObservation          = uniswapObservations[earliestObservationIndex];
684         firstConverterFeedObservation    = converterFeedObservations[earliestObservationIndex];
685     }
686     /**
687       @notice It returns the time passed since the first observation in the window
688     **/
689     function timeElapsedSinceFirstObservation() public view returns (uint256) {
690         if (updates > 1) {
691           (
692             UniswapObservation storage firstUniswapObservation,
693           ) = getFirstObservationsInWindow();
694           return subtract(now, firstUniswapObservation.timestamp);
695         }
696         return 0;
697     }
698     /**
699     * @notice Calculate the median price using the latest observations and the latest Uniswap pair prices
700     * @param price0Cumulative Cumulative price for the first token in the pair
701     * @param price1Cumulative Cumulative price for the second token in the pair
702     **/
703     function getMedianPrice(uint256 price0Cumulative, uint256 price1Cumulative) private view returns (uint256) {
704         if (updates > 1) {
705           (
706             UniswapObservation storage firstUniswapObservation,
707           ) = getFirstObservationsInWindow();
708 
709           uint timeSinceFirst = subtract(now, firstUniswapObservation.timestamp);
710           (address token0,)   = sortTokens(targetToken, denominationToken);
711           uint256 uniswapAmountOut;
712 
713           if (token0 == targetToken) {
714               uniswapAmountOut = uniswapComputeAmountOut(
715                 firstUniswapObservation.price0Cumulative, price0Cumulative, timeSinceFirst, defaultAmountIn
716               );
717           } else {
718               uniswapAmountOut = uniswapComputeAmountOut(
719                 firstUniswapObservation.price1Cumulative, price1Cumulative, timeSinceFirst, defaultAmountIn
720               );
721           }
722 
723           return converterComputeAmountOut(timeSinceFirst, uniswapAmountOut);
724         }
725 
726         return medianPrice;
727     }
728     /**
729     * @notice Returns the index of the earliest observation in the window
730     **/
731     function earliestObservationIndex() public view returns (uint256) {
732         if (updates <= granularity) {
733           return 0;
734         }
735         return subtract(updates, uint(granularity));
736     }
737     /**
738     * @notice Get the observation list length
739     **/
740     function getObservationListLength() public view returns (uint256, uint256) {
741         return (uniswapObservations.length, converterFeedObservations.length);
742     }
743 
744     // --- Uniswap Utils ---
745     /**
746     * @notice Given the Uniswap cumulative prices of the start and end of a period, and the length of the period, compute the average
747     *         price in terms of how much amount out is received for the amount in.
748     * @param priceCumulativeStart Old snapshot of the cumulative price of a token
749     * @param priceCumulativeEnd New snapshot of the cumulative price of a token
750     * @param timeElapsed Total time elapsed
751     * @param amountIn Amount of target tokens we want to find the price for
752     **/
753     function uniswapComputeAmountOut(
754         uint256 priceCumulativeStart,
755         uint256 priceCumulativeEnd,
756         uint256 timeElapsed,
757         uint256 amountIn
758     ) public pure returns (uint256 amountOut) {
759         require(priceCumulativeEnd >= priceCumulativeStart, "UniswapConverterBasicAveragePriceFeedMedianizer/invalid-end-cumulative");
760         require(timeElapsed > 0, "UniswapConsecutiveSlotsPriceFeedMedianizer/null-time-elapsed");
761         // Overflow is desired
762         uq112x112 memory priceAverage = uq112x112(
763             uint224((priceCumulativeEnd - priceCumulativeStart) / timeElapsed)
764         );
765         amountOut = decode144(mul(priceAverage, amountIn));
766     }
767 
768     // --- Converter Utils ---
769     /**
770     * @notice Calculate the price of an amount of tokens using the converter price feed as well as the time elapsed between
771     *         the latest timestamp and the timestamp of the earliest observation in the window.
772     *         Used after the contract determines the amount of Uniswap pair denomination tokens for amountIn target tokens
773     * @param timeElapsed Time elapsed between now and the earliest observation in the window.
774     * @param amountIn Amount of denomination tokens to calculate the price for
775     **/
776     function converterComputeAmountOut(
777         uint256 timeElapsed,
778         uint256 amountIn
779     ) public view returns (uint256 amountOut) {
780         require(timeElapsed > 0, "UniswapConsecutiveSlotsPriceFeedMedianizer/null-time-elapsed");
781         uint256 priceAverage = converterPriceCumulative / timeElapsed;
782         amountOut            = multiply(amountIn, priceAverage) / converterFeedScalingFactor;
783     }
784 
785     // --- Core Logic ---
786     /**
787     * @notice Update the internal median price
788     **/
789     function updateResult(address feeReceiver) external {
790         require(address(relayer) != address(0), "UniswapConsecutiveSlotsPriceFeedMedianizer/null-relayer");
791         require(uniswapPair != address(0), "UniswapConsecutiveSlotsPriceFeedMedianizer/null-uniswap-pair");
792 
793         // Get final fee receiver
794         address finalFeeReceiver = (feeReceiver == address(0)) ? msg.sender : feeReceiver;
795 
796         // Update the converter's median price first
797         try converterFeed.updateResult(finalFeeReceiver) {}
798         catch (bytes memory converterRevertReason) {
799           emit FailedConverterFeedUpdate(converterRevertReason);
800         }
801 
802         // Get the observation for the current period
803         uint256 timeElapsedSinceLatest = (uniswapObservations.length == 0) ?
804           subtract(now, lastUpdateTime) : subtract(now, uniswapObservations[uniswapObservations.length - 1].timestamp);
805         // We only want to commit updates once per period (i.e. windowSize / granularity)
806         if (uniswapObservations.length > 0) {
807           require(timeElapsedSinceLatest >= periodSize, "UniswapConsecutiveSlotsPriceFeedMedianizer/not-enough-time-elapsed");
808         }
809 
810         // Update Uniswap pair
811         try IUniswapV2Pair(uniswapPair).sync() {}
812         catch (bytes memory uniswapRevertReason) {
813           emit FailedUniswapPairSync(uniswapRevertReason);
814         }
815 
816         // Get Uniswap cumulative prices
817         (uint uniswapPrice0Cumulative, uint uniswapPrice1Cumulative,) = currentCumulativePrices(uniswapPair);
818 
819         // Add new observations
820         updateObservations(timeElapsedSinceLatest, uniswapPrice0Cumulative, uniswapPrice1Cumulative);
821 
822         // Calculate latest medianPrice
823         medianPrice    = getMedianPrice(uniswapPrice0Cumulative, uniswapPrice1Cumulative);
824         lastUpdateTime = now;
825         updates        = addition(updates, 1);
826 
827         emit UpdateResult(medianPrice, lastUpdateTime);
828 
829         // Try to reward the caller
830         try relayer.reimburseCaller(finalFeeReceiver) {
831         } catch (bytes memory revertReason) {
832           emit FailedReimburseCaller(revertReason);
833         }
834     }
835     /**
836     * @notice Push new observation data in the observation arrays
837     * @param timeElapsedSinceLatest Time elapsed between now and the earliest observation in the window
838     * @param uniswapPrice0Cumulative Latest cumulative price of the first token in a Uniswap pair
839     * @param uniswapPrice1Cumulative Latest cumulative price of the second tokens in a Uniswap pair
840     **/
841     function updateObservations(
842       uint256 timeElapsedSinceLatest,
843       uint256 uniswapPrice0Cumulative,
844       uint256 uniswapPrice1Cumulative
845     ) internal {
846         // Add converter feed observation
847         (uint256 priceFeedValue, bool hasValidValue) = converterFeed.getResultWithValidity();
848         require(hasValidValue, "UniswapConsecutiveSlotsPriceFeedMedianizer/invalid-converter-price-feed");
849         uint256 newTimeAdjustedPrice = multiply(priceFeedValue, timeElapsedSinceLatest);
850 
851         // Add converter observation
852         converterFeedObservations.push(ConverterFeedObservation(now, newTimeAdjustedPrice));
853         // Add Uniswap observation
854         uniswapObservations.push(UniswapObservation(now, uniswapPrice0Cumulative, uniswapPrice1Cumulative));
855 
856         // Add the new update
857         converterPriceCumulative = addition(converterPriceCumulative, newTimeAdjustedPrice);
858 
859         // Subtract the earliest update
860         if (updates >= granularity) {
861           (
862             ,
863             ConverterFeedObservation storage firstConverterFeedObservation
864           ) = getFirstObservationsInWindow();
865           converterPriceCumulative = subtract(converterPriceCumulative, firstConverterFeedObservation.timeAdjustedPrice);
866         }
867     }
868 
869     // --- Getters ---
870     /**
871     * @notice Fetch the latest medianPrice or revert if is is null
872     **/
873     function read() external view returns (uint256) {
874         require(
875           both(both(both(medianPrice > 0, updates > granularity), timeElapsedSinceFirstObservation() <= maxWindowSize), validityFlag == 1),
876           "UniswapConsecutiveSlotsPriceFeedMedianizer/invalid-price-feed"
877         );
878         return medianPrice;
879     }
880     /**
881     * @notice Fetch the latest medianPrice and whether it is null or not
882     **/
883     function getResultWithValidity() external view returns (uint256, bool) {
884         return (
885           medianPrice,
886           both(both(both(medianPrice > 0, updates > granularity), timeElapsedSinceFirstObservation() <= maxWindowSize), validityFlag == 1)
887         );
888     }
889 }