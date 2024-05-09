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
64 abstract contract StabilityFeeTreasuryLike {
65     function getAllowance(address) virtual external view returns (uint, uint);
66     function systemCoin() virtual external view returns (address);
67     function pullFunds(address, address, uint) virtual external;
68 }
69 
70 contract IncreasingTreasuryReimbursement is GebMath {
71     // --- Auth ---
72     mapping (address => uint) public authorizedAccounts;
73     function addAuthorization(address account) virtual external isAuthorized {
74         authorizedAccounts[account] = 1;
75         emit AddAuthorization(account);
76     }
77     function removeAuthorization(address account) virtual external isAuthorized {
78         authorizedAccounts[account] = 0;
79         emit RemoveAuthorization(account);
80     }
81     modifier isAuthorized {
82         require(authorizedAccounts[msg.sender] == 1, "IncreasingTreasuryReimbursement/account-not-authorized");
83         _;
84     }
85 
86     // --- Variables ---
87     // Starting reward for the fee receiver/keeper
88     uint256 public baseUpdateCallerReward;          // [wad]
89     // Max possible reward for the fee receiver/keeper
90     uint256 public maxUpdateCallerReward;           // [wad]
91     // Max delay taken into consideration when calculating the adjusted reward
92     uint256 public maxRewardIncreaseDelay;          // [seconds]
93     // Rate applied to baseUpdateCallerReward every extra second passed beyond a certain point (e.g next time when a specific function needs to be called)
94     uint256 public perSecondCallerRewardIncrease;   // [ray]
95 
96     // SF treasury
97     StabilityFeeTreasuryLike  public treasury;
98 
99     // --- Events ---
100     event AddAuthorization(address account);
101     event RemoveAuthorization(address account);
102     event ModifyParameters(
103       bytes32 parameter,
104       address addr
105     );
106     event ModifyParameters(
107       bytes32 parameter,
108       uint256 val
109     );
110     event FailRewardCaller(bytes revertReason, address feeReceiver, uint256 amount);
111 
112     constructor(
113       address treasury_,
114       uint256 baseUpdateCallerReward_,
115       uint256 maxUpdateCallerReward_,
116       uint256 perSecondCallerRewardIncrease_
117     ) public {
118         if (address(treasury_) != address(0)) {
119           require(StabilityFeeTreasuryLike(treasury_).systemCoin() != address(0), "IncreasingTreasuryReimbursement/treasury-coin-not-set");
120         }
121         require(maxUpdateCallerReward_ >= baseUpdateCallerReward_, "IncreasingTreasuryReimbursement/invalid-max-caller-reward");
122         require(perSecondCallerRewardIncrease_ >= RAY, "IncreasingTreasuryReimbursement/invalid-per-second-reward-increase");
123         authorizedAccounts[msg.sender] = 1;
124 
125         treasury                        = StabilityFeeTreasuryLike(treasury_);
126         baseUpdateCallerReward          = baseUpdateCallerReward_;
127         maxUpdateCallerReward           = maxUpdateCallerReward_;
128         perSecondCallerRewardIncrease   = perSecondCallerRewardIncrease_;
129         maxRewardIncreaseDelay          = uint(-1);
130 
131         emit AddAuthorization(msg.sender);
132         emit ModifyParameters("treasury", treasury_);
133         emit ModifyParameters("baseUpdateCallerReward", baseUpdateCallerReward);
134         emit ModifyParameters("maxUpdateCallerReward", maxUpdateCallerReward);
135         emit ModifyParameters("perSecondCallerRewardIncrease", perSecondCallerRewardIncrease);
136     }
137 
138     // --- Boolean Logic ---
139     function either(bool x, bool y) internal pure returns (bool z) {
140         assembly{ z := or(x, y)}
141     }
142 
143     // --- Treasury ---
144     /**
145     * @notice This returns the stability fee treasury allowance for this contract by taking the minimum between the per block and the total allowances
146     **/
147     function treasuryAllowance() public view returns (uint256) {
148         (uint total, uint perBlock) = treasury.getAllowance(address(this));
149         return minimum(total, perBlock);
150     }
151     /*
152     * @notice Get the SF reward that can be sent to a function caller right now
153     */
154     function getCallerReward(uint256 timeOfLastUpdate, uint256 defaultDelayBetweenCalls) public view returns (uint256) {
155         bool nullRewards = (baseUpdateCallerReward == 0 && maxUpdateCallerReward == 0);
156         if (either(timeOfLastUpdate >= now, nullRewards)) return 0;
157         uint256 timeElapsed = (timeOfLastUpdate == 0) ? defaultDelayBetweenCalls : subtract(now, timeOfLastUpdate);
158         if (either(timeElapsed < defaultDelayBetweenCalls, baseUpdateCallerReward == 0)) {
159             return 0;
160         }
161         uint256 adjustedTime      = subtract(timeElapsed, defaultDelayBetweenCalls);
162         uint256 maxPossibleReward = minimum(maxUpdateCallerReward, treasuryAllowance() / RAY);
163         if (adjustedTime > maxRewardIncreaseDelay) {
164             return maxPossibleReward;
165         }
166         uint256 calculatedReward = baseUpdateCallerReward;
167         if (adjustedTime > 0) {
168             calculatedReward = rmultiply(rpower(perSecondCallerRewardIncrease, adjustedTime, RAY), calculatedReward);
169         }
170         if (calculatedReward > maxPossibleReward) {
171             calculatedReward = maxPossibleReward;
172         }
173         return calculatedReward;
174     }
175     /**
176     * @notice Send a stability fee reward to an address
177     * @param proposedFeeReceiver The SF receiver
178     * @param reward The system coin amount to send
179     **/
180     function rewardCaller(address proposedFeeReceiver, uint256 reward) internal {
181         if (address(treasury) == proposedFeeReceiver) return;
182         if (either(address(treasury) == address(0), reward == 0)) return;
183         address finalFeeReceiver = (proposedFeeReceiver == address(0)) ? msg.sender : proposedFeeReceiver;
184         try treasury.pullFunds(finalFeeReceiver, treasury.systemCoin(), reward) {}
185         catch(bytes memory revertReason) {
186             emit FailRewardCaller(revertReason, finalFeeReceiver, reward);
187         }
188     }
189 }
190 
191 interface IUniswapV2Factory {
192     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
193 
194     function feeTo() external view returns (address);
195     function feeToSetter() external view returns (address);
196 
197     function getPair(address tokenA, address tokenB) external view returns (address pair);
198     function allPairs(uint) external view returns (address pair);
199     function allPairsLength() external view returns (uint);
200 
201     function createPair(address tokenA, address tokenB) external returns (address pair);
202 
203     function setFeeTo(address) external;
204     function setFeeToSetter(address) external;
205 }
206 
207 interface IUniswapV2Pair {
208     event Approval(address indexed owner, address indexed spender, uint value);
209     event Transfer(address indexed from, address indexed to, uint value);
210 
211     function name() external pure returns (string memory);
212     function symbol() external pure returns (string memory);
213     function decimals() external pure returns (uint8);
214     function totalSupply() external view returns (uint);
215     function balanceOf(address owner) external view returns (uint);
216     function allowance(address owner, address spender) external view returns (uint);
217 
218     function approve(address spender, uint value) external returns (bool);
219     function transfer(address to, uint value) external returns (bool);
220     function transferFrom(address from, address to, uint value) external returns (bool);
221 
222     function DOMAIN_SEPARATOR() external view returns (bytes32);
223     function PERMIT_TYPEHASH() external pure returns (bytes32);
224     function nonces(address owner) external view returns (uint);
225 
226     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
227 
228     event Mint(address indexed sender, uint amount0, uint amount1);
229     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
230     event Swap(
231         address indexed sender,
232         uint amount0In,
233         uint amount1In,
234         uint amount0Out,
235         uint amount1Out,
236         address indexed to
237     );
238     event Sync(uint112 reserve0, uint112 reserve1);
239 
240     function MINIMUM_LIQUIDITY() external pure returns (uint);
241     function factory() external view returns (address);
242     function token0() external view returns (address);
243     function token1() external view returns (address);
244     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
245     function price0CumulativeLast() external view returns (uint);
246     function price1CumulativeLast() external view returns (uint);
247     function kLast() external view returns (uint);
248 
249     function mint(address to) external returns (uint liquidity);
250     function burn(address to) external returns (uint amount0, uint amount1);
251     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
252     function skim(address to) external;
253     function sync() external;
254 
255     function initialize(address, address) external;
256 }
257 
258 // computes square roots using the babylonian method
259 // https://en.wikipedia.org/wiki/Methods_of_computing_square_roots#Babylonian_method
260 contract BabylonianMath {
261     function sqrt(uint y) internal pure returns (uint z) {
262         if (y > 3) {
263             z = y;
264             uint x = y / 2 + 1;
265             while (x < z) {
266                 z = x;
267                 x = (y / x + x) / 2;
268             }
269         } else if (y != 0) {
270             z = 1;
271         }
272         // else z = 0
273     }
274 }
275 
276 // Contract for handling binary fixed point numbers (https://en.wikipedia.org/wiki/Q_(number_format))
277 contract FixedPointMath is BabylonianMath {
278     // range: [0, 2**112 - 1]
279     // resolution: 1 / 2**112
280     struct uq112x112 {
281         uint224 _x;
282     }
283 
284     // range: [0, 2**144 - 1]
285     // resolution: 1 / 2**112
286     struct uq144x112 {
287         uint _x;
288     }
289 
290     uint8 private constant RESOLUTION = 112;
291     uint private constant Q112 = uint(1) << RESOLUTION;
292     uint private constant Q224 = Q112 << RESOLUTION;
293 
294     // encode a uint112 as a UQ112x112
295     function encode(uint112 x) internal pure returns (uq112x112 memory) {
296         return uq112x112(uint224(x) << RESOLUTION);
297     }
298 
299     // encodes a uint144 as a UQ144x112
300     function encode144(uint144 x) internal pure returns (uq144x112 memory) {
301         return uq144x112(uint256(x) << RESOLUTION);
302     }
303 
304     // divide a UQ112x112 by a uint112, returning a UQ112x112
305     function div(uq112x112 memory self, uint112 x) internal pure returns (uq112x112 memory) {
306         require(x != 0, 'FixedPoint: DIV_BY_ZERO');
307         return uq112x112(self._x / uint224(x));
308     }
309 
310     // multiply a UQ112x112 by a uint, returning a UQ144x112
311     // reverts on overflow
312     function mul(uq112x112 memory self, uint y) internal pure returns (uq144x112 memory) {
313         uint z;
314         require(y == 0 || (z = uint(self._x) * y) / y == uint(self._x), "FixedPoint: MULTIPLICATION_OVERFLOW");
315         return uq144x112(z);
316     }
317 
318     // returns a UQ112x112 which represents the ratio of the numerator to the denominator
319     // equivalent to encode(numerator).divide(denominator)
320     function frac(uint112 numerator, uint112 denominator) internal pure returns (uq112x112 memory) {
321         require(denominator > 0, "FixedPoint: DIV_BY_ZERO");
322         return uq112x112((uint224(numerator) << RESOLUTION) / denominator);
323     }
324 
325     // decode a UQ112x112 into a uint112 by truncating after the radix point
326     function decode(uq112x112 memory self) internal pure returns (uint112) {
327         return uint112(self._x >> RESOLUTION);
328     }
329 
330     // decode a UQ144x112 into a uint144 by truncating after the radix point
331     function decode144(uq144x112 memory self) internal pure returns (uint144) {
332         return uint144(self._x >> RESOLUTION);
333     }
334 
335     // take the reciprocal of a UQ112x112
336     function reciprocal(uq112x112 memory self) internal pure returns (uq112x112 memory) {
337         require(self._x != 0, 'FixedPoint: ZERO_RECIPROCAL');
338         return uq112x112(uint224(Q224 / self._x));
339     }
340 
341     // square root of a UQ112x112
342     function sqrt(uq112x112 memory self) internal pure returns (uq112x112 memory) {
343         return uq112x112(uint224(super.sqrt(uint256(self._x)) << 56));
344     }
345 }
346 
347 // Contract with helper methods for oracles that are concerned with computing average prices
348 contract UniswapV2OracleLibrary is FixedPointMath {
349     // Helper function that returns the current block timestamp within the range of uint32, i.e. [0, 2**32 - 1]
350     function currentBlockTimestamp() internal view returns (uint32) {
351         return uint32(block.timestamp % 2 ** 32);
352     }
353 
354     // Produces the cumulative price using counterfactuals to save gas and avoid a call to sync.
355     function currentCumulativePrices(
356         address pair
357     ) internal view returns (uint price0Cumulative, uint price1Cumulative, uint32 blockTimestamp) {
358         blockTimestamp = currentBlockTimestamp();
359         price0Cumulative = IUniswapV2Pair(pair).price0CumulativeLast();
360         price1Cumulative = IUniswapV2Pair(pair).price1CumulativeLast();
361 
362         // if time has elapsed since the last update on the pair, mock the accumulated price values
363         (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast) = IUniswapV2Pair(pair).getReserves();
364         if (blockTimestampLast != blockTimestamp) {
365             // subtraction overflow is desired
366             uint32 timeElapsed = blockTimestamp - blockTimestampLast;
367             // addition overflow is desired
368             // counterfactual
369             price0Cumulative += uint(frac(reserve1, reserve0)._x) * timeElapsed;
370             // counterfactual
371             price1Cumulative += uint(frac(reserve0, reserve1)._x) * timeElapsed;
372         }
373     }
374 }
375 
376 contract UniswapV2Library {
377     // --- Math ---
378     function uniAddition(uint x, uint y) internal pure returns (uint z) {
379         require((z = x + y) >= x, 'UniswapV2Library: add-overflow');
380     }
381     function uniSubtract(uint x, uint y) internal pure returns (uint z) {
382         require((z = x - y) <= x, 'UniswapV2Library: sub-underflow');
383     }
384     function uniMultiply(uint x, uint y) internal pure returns (uint z) {
385         require(y == 0 || (z = x * y) / y == x, 'UniswapV2Library: mul-overflow');
386     }
387 
388     // returns sorted token addresses, used to handle return values from pairs sorted in this order
389     function sortTokens(address tokenA, address tokenB) internal pure returns (address token0, address token1) {
390         require(tokenA != tokenB, 'UniswapV2Library: IDENTICAL_ADDRESSES');
391         (token0, token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
392         require(token0 != address(0), 'UniswapV2Library: ZERO_ADDRESS');
393     }
394 
395     // Modified Uniswap function to work with dapp.tools (CREATE2 throws)
396     function pairFor(address factory, address tokenA, address tokenB) internal view returns (address pair) {
397         (address token0, address token1) = sortTokens(tokenA, tokenB);
398         return IUniswapV2Factory(factory).getPair(tokenA, tokenB);
399     }
400 
401     // fetches and sorts the reserves for a pair; modified from the initial Uniswap version in order to work with dapp.tools
402     function getReserves(address factory, address tokenA, address tokenB) internal view returns (uint reserveA, uint reserveB) {
403         (address token0,) = sortTokens(tokenA, tokenB);
404         (uint reserve0, uint reserve1,) = IUniswapV2Pair(IUniswapV2Factory(factory).getPair(tokenA, tokenB)).getReserves();
405         (reserveA, reserveB) = tokenA == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
406     }
407 
408     // Given some amount of an asset and pair reserves, returns an equivalent amount of the other asset
409     function quote(uint amountA, uint reserveA, uint reserveB) internal pure returns (uint amountB) {
410         require(amountA > 0, 'UniswapV2Library: INSUFFICIENT_AMOUNT');
411         require(reserveA > 0 && reserveB > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
412         amountB = uniMultiply(amountA, reserveB) / reserveA;
413     }
414 
415     // Given an input amount of an asset and pair reserves, returns the maximum output amount of the other asset
416     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) internal pure returns (uint amountOut) {
417         require(amountIn > 0, 'UniswapV2Library: INSUFFICIENT_INPUT_AMOUNT');
418         require(reserveIn > 0 && reserveOut > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
419         uint amountInWithFee = uniMultiply(amountIn, 997);
420         uint numerator = uniMultiply(amountInWithFee, reserveOut);
421         uint denominator = uniAddition(uniMultiply(reserveIn, 1000), amountInWithFee);
422         amountOut = numerator / denominator;
423     }
424 
425     // given an output amount of an asset and pair reserves, returns a required input amount of the other asset
426     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) internal pure returns (uint amountIn) {
427         require(amountOut > 0, 'UniswapV2Library: INSUFFICIENT_OUTPUT_AMOUNT');
428         require(reserveIn > 0 && reserveOut > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
429         uint numerator = uniMultiply(uniMultiply(reserveIn, amountOut), 1000);
430         uint denominator = uniMultiply(uniSubtract(reserveOut, amountOut), 997);
431         amountIn = uniAddition((numerator / denominator), 1);
432     }
433 
434     // performs chained getAmountOut calculations on any number of pairs
435     function getAmountsOut(address factory, uint amountIn, address[] memory path) internal view returns (uint[] memory amounts) {
436         require(path.length >= 2, 'UniswapV2Library: INVALID_PATH');
437         amounts = new uint[](path.length);
438         amounts[0] = amountIn;
439         for (uint i; i < path.length - 1; i++) {
440             (uint reserveIn, uint reserveOut) = getReserves(factory, path[i], path[i + 1]);
441             amounts[i + 1] = getAmountOut(amounts[i], reserveIn, reserveOut);
442         }
443     }
444 
445     // performs chained getAmountIn calculations on any number of pairs
446     function getAmountsIn(address factory, uint amountOut, address[] memory path) internal view returns (uint[] memory amounts) {
447         require(path.length >= 2, 'UniswapV2Library: INVALID_PATH');
448         amounts = new uint[](path.length);
449         amounts[amounts.length - 1] = amountOut;
450         for (uint i = path.length - 1; i > 0; i--) {
451             (uint reserveIn, uint reserveOut) = getReserves(factory, path[i - 1], path[i]);
452             amounts[i - 1] = getAmountIn(amounts[i], reserveIn, reserveOut);
453         }
454     }
455 }
456 
457 abstract contract ConverterFeedLike {
458     function getResultWithValidity() virtual external view returns (uint256,bool);
459     function updateResult(address) virtual external;
460 }
461 
462 contract UniswapConsecutiveSlotsPriceFeedMedianizer is IncreasingTreasuryReimbursement, UniswapV2Library, UniswapV2OracleLibrary {
463     // --- Observations ---
464     struct UniswapObservation {
465         uint timestamp;
466         uint price0Cumulative;
467         uint price1Cumulative;
468     }
469     struct ConverterFeedObservation {
470         uint timestamp;
471         uint timeAdjustedPrice;
472     }
473 
474     // --- Uniswap Vars ---
475     // Default amount of targetToken used when calculating the denominationToken output
476     uint256              public defaultAmountIn;
477     // Token for which the contract calculates the medianPrice for
478     address              public targetToken;
479     // Pair token from the Uniswap pair
480     address              public denominationToken;
481     address              public uniswapPair;
482 
483     IUniswapV2Factory    public uniswapFactory;
484 
485     UniswapObservation[] public uniswapObservations;
486 
487     // --- Converter Feed Vars ---
488     // Latest converter price accumulator snapshot
489     uint256                    public converterPriceCumulative;
490 
491     ConverterFeedLike          public converterFeed;
492     ConverterFeedObservation[] public converterFeedObservations;
493 
494     // --- General Vars ---
495     // Symbol - you want to change this every deployment
496     bytes32 public symbol = "raiusd";
497 
498     uint8   public granularity;
499     // When the price feed was last updated
500     uint256 public lastUpdateTime;
501     // Total number of updates
502     uint256 public updates;
503     /**
504       The ideal amount of time over which the moving average should be computed, e.g. 24 hours.
505       In practice it can and most probably will be different than the actual window over which the contract medianizes.
506     **/
507     uint256 public windowSize;
508     // Maximum window size used to determine if the median is 'valid' (close to the real one) or not
509     uint256 public maxWindowSize;
510     // Stored for gas savings. Equals windowSize / granularity
511     uint256 public periodSize;
512     // This is the denominator for computing
513     uint256 public converterFeedScalingFactor;
514     // The last computed median price
515     uint256 private medianPrice;
516     // Manual flag that can be set by governance and indicates if a result is valid or not
517     uint256 public validityFlag;
518 
519     // --- Events ---
520     event UpdateResult(uint256 medianPrice, uint256 lastUpdateTime);
521     event FailedConverterFeedUpdate(bytes reason);
522     event FailedUniswapPairSync(bytes reason);
523 
524     constructor(
525       address converterFeed_,
526       address uniswapFactory_,
527       address treasury_,
528       uint256 defaultAmountIn_,
529       uint256 windowSize_,
530       uint256 converterFeedScalingFactor_,
531       uint256 baseUpdateCallerReward_,
532       uint256 maxUpdateCallerReward_,
533       uint256 perSecondCallerRewardIncrease_,
534       uint256 maxWindowSize_,
535       uint8   granularity_
536     ) public IncreasingTreasuryReimbursement(treasury_, baseUpdateCallerReward_, maxUpdateCallerReward_, perSecondCallerRewardIncrease_) {
537         require(uniswapFactory_ != address(0), "UniswapConsecutiveSlotsPriceFeedMedianizer/null-uniswap-factory");
538         require(granularity_ > 1, 'UniswapConsecutiveSlotsPriceFeedMedianizer/null-granularity');
539         require(windowSize_ > 0, 'UniswapConsecutiveSlotsPriceFeedMedianizer/null-window-size');
540         require(maxWindowSize_ > windowSize_, 'UniswapConsecutiveSlotsPriceFeedMedianizer/invalid-max-window-size');
541         require(defaultAmountIn_ > 0, 'UniswapConsecutiveSlotsPriceFeedMedianizer/invalid-default-amount-in');
542         require(converterFeedScalingFactor_ > 0, 'UniswapConsecutiveSlotsPriceFeedMedianizer/null-feed-scaling-factor');
543         require(
544             (periodSize = windowSize_ / granularity_) * granularity_ == windowSize_,
545             'UniswapConsecutiveSlotsPriceFeedMedianizer/window-not-evenly-divisible'
546         );
547 
548         converterFeed               = ConverterFeedLike(converterFeed_);
549         uniswapFactory              = IUniswapV2Factory(uniswapFactory_);
550         defaultAmountIn             = defaultAmountIn_;
551         windowSize                  = windowSize_;
552         maxWindowSize               = maxWindowSize_;
553         converterFeedScalingFactor  = converterFeedScalingFactor_;
554         granularity                 = granularity_;
555         lastUpdateTime              = now;
556         validityFlag                = 1;
557 
558         // Emit events
559         emit ModifyParameters(bytes32("converterFeed"), converterFeed_);
560         emit ModifyParameters(bytes32("maxWindowSize"), maxWindowSize_);
561     }
562 
563     // --- Administration ---
564     /**
565     * @notice Modify the converter feed address
566     * @param parameter Name of the parameter to modify
567     * @param data New parameter value
568     **/
569     function modifyParameters(bytes32 parameter, address data) external isAuthorized {
570         require(data != address(0), "UniswapConsecutiveSlotsPriceFeedMedianizer/null-data");
571         if (parameter == "converterFeed") {
572           require(data != address(0), "UniswapConsecutiveSlotsPriceFeedMedianizer/null-converter-feed");
573           converterFeed = ConverterFeedLike(data);
574         }
575         else if (parameter == "treasury") {
576       	  require(StabilityFeeTreasuryLike(data).systemCoin() != address(0), "UniswapConsecutiveSlotsPriceFeedMedianizer/treasury-coin-not-set");
577       	  treasury = StabilityFeeTreasuryLike(data);
578       	}
579         else if (parameter == "targetToken") {
580           require(uniswapPair == address(0), "UniswapConsecutiveSlotsPriceFeedMedianizer/pair-already-set");
581           targetToken = data;
582           if (denominationToken != address(0)) {
583             uniswapPair = uniswapFactory.getPair(targetToken, denominationToken);
584             require(uniswapPair != address(0), "UniswapConsecutiveSlotsPriceFeedMedianizer/null-uniswap-pair");
585           }
586         }
587         else if (parameter == "denominationToken") {
588           require(uniswapPair == address(0), "UniswapConsecutiveSlotsPriceFeedMedianizer/pair-already-set");
589           denominationToken = data;
590           if (targetToken != address(0)) {
591             uniswapPair = uniswapFactory.getPair(targetToken, denominationToken);
592             require(uniswapPair != address(0), "UniswapConsecutiveSlotsPriceFeedMedianizer/null-uniswap-pair");
593           }
594         }
595         else revert("UniswapConsecutiveSlotsPriceFeedMedianizer/modify-unrecognized-param");
596         emit ModifyParameters(parameter, data);
597     }
598     function modifyParameters(bytes32 parameter, uint256 data) external isAuthorized {
599         if (parameter == "baseUpdateCallerReward") baseUpdateCallerReward = data;
600         else if (parameter == "validityFlag") {
601           require(either(data == 1, data == 0), "UniswapConsecutiveSlotsPriceFeedMedianizer/invalid-data");
602           validityFlag = data;
603         }
604         else if (parameter == "maxUpdateCallerReward") {
605           require(data > baseUpdateCallerReward, "UniswapConsecutiveSlotsPriceFeedMedianizer/invalid-max-reward");
606           maxUpdateCallerReward = data;
607         }
608         else if (parameter == "perSecondCallerRewardIncrease") {
609           require(data >= RAY, "UniswapConsecutiveSlotsPriceFeedMedianizer/invalid-reward-increase");
610           perSecondCallerRewardIncrease = data;
611         }
612         else if (parameter == "maxRewardIncreaseDelay") {
613           require(data > 0, "UniswapConsecutiveSlotsPriceFeedMedianizer/invalid-max-increase-delay");
614           maxRewardIncreaseDelay = data;
615         }
616         else if (parameter == "defaultAmountIn") {
617           require(data > 0, "UniswapConsecutiveSlotsPriceFeedMedianizer/invalid-default-amount-in");
618           defaultAmountIn = data;
619         }
620         else if (parameter == "maxWindowSize") {
621           require(data > windowSize, 'UniswapConsecutiveSlotsPriceFeedMedianizer/invalid-max-window-size');
622           maxWindowSize = data;
623         }
624         else revert("UniswapConsecutiveSlotsPriceFeedMedianizer/modify-unrecognized-param");
625         emit ModifyParameters(parameter, data);
626     }
627 
628     // --- General Utils ---
629     function both(bool x, bool y) private pure returns (bool z) {
630         assembly{ z := and(x, y)}
631     }
632     /**
633     * @notice Returns the oldest observations (relative to the current index in the Uniswap/Converter lists)
634     **/
635     function getFirstObservationsInWindow()
636       private view returns (UniswapObservation storage firstUniswapObservation, ConverterFeedObservation storage firstConverterFeedObservation) {
637         uint256 earliestObservationIndex = earliestObservationIndex();
638         firstUniswapObservation          = uniswapObservations[earliestObservationIndex];
639         firstConverterFeedObservation    = converterFeedObservations[earliestObservationIndex];
640     }
641     /**
642       @notice It returns the time passed since the first observation in the window
643     **/
644     function timeElapsedSinceFirstObservation() public view returns (uint256) {
645         if (updates > 1) {
646           (
647             UniswapObservation storage firstUniswapObservation,
648           ) = getFirstObservationsInWindow();
649           return subtract(now, firstUniswapObservation.timestamp);
650         }
651         return 0;
652     }
653     /**
654     * @notice Calculate the median price using the latest observations and the latest Uniswap pair prices
655     * @param price0Cumulative Cumulative price for the first token in the pair
656     * @param price1Cumulative Cumulative price for the second token in the pair
657     **/
658     function getMedianPrice(uint256 price0Cumulative, uint256 price1Cumulative) private view returns (uint256) {
659         if (updates > 1) {
660           (
661             UniswapObservation storage firstUniswapObservation,
662           ) = getFirstObservationsInWindow();
663 
664           uint timeSinceFirst = subtract(now, firstUniswapObservation.timestamp);
665           (address token0,)   = sortTokens(targetToken, denominationToken);
666           uint256 uniswapAmountOut;
667 
668           if (token0 == targetToken) {
669               uniswapAmountOut = uniswapComputeAmountOut(
670                 firstUniswapObservation.price0Cumulative, price0Cumulative, timeSinceFirst, defaultAmountIn
671               );
672           } else {
673               uniswapAmountOut = uniswapComputeAmountOut(
674                 firstUniswapObservation.price1Cumulative, price1Cumulative, timeSinceFirst, defaultAmountIn
675               );
676           }
677 
678           return converterComputeAmountOut(timeSinceFirst, uniswapAmountOut);
679         }
680 
681         return medianPrice;
682     }
683     /**
684     * @notice Returns the index of the earliest observation in the window
685     **/
686     function earliestObservationIndex() public view returns (uint256) {
687         if (updates <= granularity) {
688           return 0;
689         }
690         return subtract(updates, uint(granularity));
691     }
692     /**
693     * @notice Get the observation list length
694     **/
695     function getObservationListLength() public view returns (uint256, uint256) {
696         return (uniswapObservations.length, converterFeedObservations.length);
697     }
698 
699     // --- Uniswap Utils ---
700     /**
701     * @notice Given the Uniswap cumulative prices of the start and end of a period, and the length of the period, compute the average
702     *         price in terms of how much amount out is received for the amount in.
703     * @param priceCumulativeStart Old snapshot of the cumulative price of a token
704     * @param priceCumulativeEnd New snapshot of the cumulative price of a token
705     * @param timeElapsed Total time elapsed
706     * @param amountIn Amount of target tokens we want to find the price for
707     **/
708     function uniswapComputeAmountOut(
709         uint256 priceCumulativeStart,
710         uint256 priceCumulativeEnd,
711         uint256 timeElapsed,
712         uint256 amountIn
713     ) public pure returns (uint256 amountOut) {
714         require(priceCumulativeEnd >= priceCumulativeStart, "UniswapConverterBasicAveragePriceFeedMedianizer/invalid-end-cumulative");
715         require(timeElapsed > 0, "UniswapConsecutiveSlotsPriceFeedMedianizer/null-time-elapsed");
716         // Overflow is desired
717         uq112x112 memory priceAverage = uq112x112(
718             uint224((priceCumulativeEnd - priceCumulativeStart) / timeElapsed)
719         );
720         amountOut = decode144(mul(priceAverage, amountIn));
721     }
722 
723     // --- Converter Utils ---
724     /**
725     * @notice Calculate the price of an amount of tokens using the converter price feed as well as the time elapsed between
726     *         the latest timestamp and the timestamp of the earliest observation in the window.
727     *         Used after the contract determines the amount of Uniswap pair denomination tokens for amountIn target tokens
728     * @param timeElapsed Time elapsed between now and the earliest observation in the window.
729     * @param amountIn Amount of denomination tokens to calculate the price for
730     **/
731     function converterComputeAmountOut(
732         uint256 timeElapsed,
733         uint256 amountIn
734     ) public view returns (uint256 amountOut) {
735         require(timeElapsed > 0, "UniswapConsecutiveSlotsPriceFeedMedianizer/null-time-elapsed");
736         uint256 priceAverage = converterPriceCumulative / timeElapsed;
737         amountOut            = multiply(amountIn, priceAverage) / converterFeedScalingFactor;
738     }
739 
740     // --- Core Logic ---
741     /**
742     * @notice Update the internal median price
743     **/
744     function updateResult(address feeReceiver) external {
745         require(uniswapPair != address(0), "UniswapConsecutiveSlotsPriceFeedMedianizer/null-uniswap-pair");
746 
747         // Get final fee receiver
748         address finalFeeReceiver = (feeReceiver == address(0)) ? msg.sender : feeReceiver;
749 
750         // Update the converter's median price first
751         try converterFeed.updateResult(finalFeeReceiver) {}
752         catch (bytes memory converterRevertReason) {
753           emit FailedConverterFeedUpdate(converterRevertReason);
754         }
755 
756         // Get the observation for the current period
757         uint256 timeElapsedSinceLatest = (uniswapObservations.length == 0) ?
758           subtract(now, lastUpdateTime) : subtract(now, uniswapObservations[uniswapObservations.length - 1].timestamp);
759         // We only want to commit updates once per period (i.e. windowSize / granularity)
760         if (uniswapObservations.length > 0) {
761           require(timeElapsedSinceLatest >= periodSize, "UniswapConsecutiveSlotsPriceFeedMedianizer/not-enough-time-elapsed");
762         }
763 
764         // Update Uniswap pair
765         try IUniswapV2Pair(uniswapPair).sync() {}
766         catch (bytes memory uniswapRevertReason) {
767           emit FailedUniswapPairSync(uniswapRevertReason);
768         }
769 
770         // Get the last update time used when calculating the reward
771         uint256 rewardCalculationLastUpdateTime = (uniswapObservations.length == 0) ? 0 : lastUpdateTime;
772         // Get caller's reward
773         uint256 callerReward = getCallerReward(rewardCalculationLastUpdateTime, periodSize);
774 
775         // Get Uniswap cumulative prices
776         (uint uniswapPrice0Cumulative, uint uniswapPrice1Cumulative,) = currentCumulativePrices(uniswapPair);
777 
778         // Add new observations
779         updateObservations(timeElapsedSinceLatest, uniswapPrice0Cumulative, uniswapPrice1Cumulative);
780 
781         // Calculate latest medianPrice
782         medianPrice    = getMedianPrice(uniswapPrice0Cumulative, uniswapPrice1Cumulative);
783         lastUpdateTime = now;
784         updates        = addition(updates, 1);
785 
786         emit UpdateResult(medianPrice, lastUpdateTime);
787 
788         // Reward caller
789         rewardCaller(feeReceiver, callerReward);
790     }
791     /**
792     * @notice Push new observation data in the observation arrays
793     * @param timeElapsedSinceLatest Time elapsed between now and the earliest observation in the window
794     * @param uniswapPrice0Cumulative Latest cumulative price of the first token in a Uniswap pair
795     * @param uniswapPrice1Cumulative Latest cumulative price of the second tokens in a Uniswap pair
796     **/
797     function updateObservations(
798       uint256 timeElapsedSinceLatest,
799       uint256 uniswapPrice0Cumulative,
800       uint256 uniswapPrice1Cumulative
801     ) internal {
802         // Add converter feed observation
803         (uint256 priceFeedValue, bool hasValidValue) = converterFeed.getResultWithValidity();
804         require(hasValidValue, "UniswapConsecutiveSlotsPriceFeedMedianizer/invalid-converter-price-feed");
805         uint256 newTimeAdjustedPrice = multiply(priceFeedValue, timeElapsedSinceLatest);
806 
807         // Add converter observation
808         converterFeedObservations.push(ConverterFeedObservation(now, newTimeAdjustedPrice));
809         // Add Uniswap observation
810         uniswapObservations.push(UniswapObservation(now, uniswapPrice0Cumulative, uniswapPrice1Cumulative));
811 
812         // Add the new update
813         converterPriceCumulative = addition(converterPriceCumulative, newTimeAdjustedPrice);
814 
815         // Subtract the earliest update
816         if (updates >= granularity) {
817           (
818             ,
819             ConverterFeedObservation storage firstConverterFeedObservation
820           ) = getFirstObservationsInWindow();
821           converterPriceCumulative = subtract(converterPriceCumulative, firstConverterFeedObservation.timeAdjustedPrice);
822         }
823     }
824 
825     // --- Getters ---
826     /**
827     * @notice Fetch the latest medianPrice or revert if is is null
828     **/
829     function read() external view returns (uint256) {
830         require(
831           both(both(both(medianPrice > 0, updates > granularity), timeElapsedSinceFirstObservation() <= maxWindowSize), validityFlag == 1),
832           "UniswapConsecutiveSlotsPriceFeedMedianizer/invalid-price-feed"
833         );
834         return medianPrice;
835     }
836     /**
837     * @notice Fetch the latest medianPrice and whether it is null or not
838     **/
839     function getResultWithValidity() external view returns (uint256, bool) {
840         return (
841           medianPrice,
842           both(both(both(medianPrice > 0, updates > granularity), timeElapsedSinceFirstObservation() <= maxWindowSize), validityFlag == 1)
843         );
844     }
845 }
846 
847 contract UniswapConsecutiveSlotsMedianRAIUSD is UniswapConsecutiveSlotsPriceFeedMedianizer {
848     constructor(
849       address uniswapFactory_,
850       uint256 defaultAmountIn_,
851       uint256 windowSize_,
852       uint256 converterFeedScalingFactor_,
853       uint256 baseUpdateCallerReward_,
854       uint256 maxUpdateCallerReward_,
855       uint256 perSecondCallerRewardIncrease_,
856       uint256 maxWindow_,
857       uint8   granularity_
858     ) UniswapConsecutiveSlotsPriceFeedMedianizer(
859         address(0),
860         uniswapFactory_,
861         address(0),
862         defaultAmountIn_,
863         windowSize_,
864         converterFeedScalingFactor_,
865         baseUpdateCallerReward_,
866         maxUpdateCallerReward_,
867         perSecondCallerRewardIncrease_,
868         maxWindow_,
869         granularity_
870     ) public {
871         symbol = "RAIUSD";
872     }
873 }