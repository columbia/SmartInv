1 // Verified using https://dapp.tools
2 
3 // hevm: flattened sources of /nix/store/jhkj8my1hkpiklhhkl8xyzpxwpzix5fj-geb-uniswap-median/dapp/geb-uniswap-median/src/UniswapConsecutiveSlotsPriceFeedMedianizer.sol
4 pragma solidity =0.6.7;
5 
6 ////// /nix/store/3d3msxain9q01swpn63dsh9wl2hsal24-geb-treasury-reimbursement/dapp/geb-treasury-reimbursement/src/math/GebMath.sol
7 /* pragma solidity 0.6.7; */
8 
9 contract GebMath {
10     uint256 public constant RAY = 10 ** 27;
11     uint256 public constant WAD = 10 ** 18;
12 
13     function ray(uint x) public pure returns (uint z) {
14         z = multiply(x, 10 ** 9);
15     }
16     function rad(uint x) public pure returns (uint z) {
17         z = multiply(x, 10 ** 27);
18     }
19     function minimum(uint x, uint y) public pure returns (uint z) {
20         z = (x <= y) ? x : y;
21     }
22     function addition(uint x, uint y) public pure returns (uint z) {
23         z = x + y;
24         require(z >= x, "uint-uint-add-overflow");
25     }
26     function subtract(uint x, uint y) public pure returns (uint z) {
27         z = x - y;
28         require(z <= x, "uint-uint-sub-underflow");
29     }
30     function multiply(uint x, uint y) public pure returns (uint z) {
31         require(y == 0 || (z = x * y) / y == x, "uint-uint-mul-overflow");
32     }
33     function rmultiply(uint x, uint y) public pure returns (uint z) {
34         z = multiply(x, y) / RAY;
35     }
36     function rdivide(uint x, uint y) public pure returns (uint z) {
37         z = multiply(x, RAY) / y;
38     }
39     function wdivide(uint x, uint y) public pure returns (uint z) {
40         z = multiply(x, WAD) / y;
41     }
42     function wmultiply(uint x, uint y) public pure returns (uint z) {
43         z = multiply(x, y) / WAD;
44     }
45     function rpower(uint x, uint n, uint base) public pure returns (uint z) {
46         assembly {
47             switch x case 0 {switch n case 0 {z := base} default {z := 0}}
48             default {
49                 switch mod(n, 2) case 0 { z := base } default { z := x }
50                 let half := div(base, 2)  // for rounding.
51                 for { n := div(n, 2) } n { n := div(n,2) } {
52                     let xx := mul(x, x)
53                     if iszero(eq(div(xx, x), x)) { revert(0,0) }
54                     let xxRound := add(xx, half)
55                     if lt(xxRound, xx) { revert(0,0) }
56                     x := div(xxRound, base)
57                     if mod(n,2) {
58                         let zx := mul(z, x)
59                         if and(iszero(iszero(x)), iszero(eq(div(zx, x), z))) { revert(0,0) }
60                         let zxRound := add(zx, half)
61                         if lt(zxRound, zx) { revert(0,0) }
62                         z := div(zxRound, base)
63                     }
64                 }
65             }
66         }
67     }
68 }
69 
70 ////// /nix/store/jhkj8my1hkpiklhhkl8xyzpxwpzix5fj-geb-uniswap-median/dapp/geb-uniswap-median/src/univ2/interfaces/IUniswapV2Factory.sol
71 /* pragma solidity 0.6.7; */
72 
73 interface IUniswapV2Factory {
74     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
75 
76     function feeTo() external view returns (address);
77     function feeToSetter() external view returns (address);
78 
79     function getPair(address tokenA, address tokenB) external view returns (address pair);
80     function allPairs(uint) external view returns (address pair);
81     function allPairsLength() external view returns (uint);
82 
83     function createPair(address tokenA, address tokenB) external returns (address pair);
84 
85     function setFeeTo(address) external;
86     function setFeeToSetter(address) external;
87 }
88 
89 ////// /nix/store/jhkj8my1hkpiklhhkl8xyzpxwpzix5fj-geb-uniswap-median/dapp/geb-uniswap-median/src/univ2/interfaces/IUniswapV2Pair.sol
90 /* pragma solidity 0.6.7; */
91 
92 interface IUniswapV2Pair {
93     event Approval(address indexed owner, address indexed spender, uint value);
94     event Transfer(address indexed from, address indexed to, uint value);
95 
96     function name() external pure returns (string memory);
97     function symbol() external pure returns (string memory);
98     function decimals() external pure returns (uint8);
99     function totalSupply() external view returns (uint);
100     function balanceOf(address owner) external view returns (uint);
101     function allowance(address owner, address spender) external view returns (uint);
102 
103     function approve(address spender, uint value) external returns (bool);
104     function transfer(address to, uint value) external returns (bool);
105     function transferFrom(address from, address to, uint value) external returns (bool);
106 
107     function DOMAIN_SEPARATOR() external view returns (bytes32);
108     function PERMIT_TYPEHASH() external pure returns (bytes32);
109     function nonces(address owner) external view returns (uint);
110 
111     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
112 
113     event Mint(address indexed sender, uint amount0, uint amount1);
114     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
115     event Swap(
116         address indexed sender,
117         uint amount0In,
118         uint amount1In,
119         uint amount0Out,
120         uint amount1Out,
121         address indexed to
122     );
123     event Sync(uint112 reserve0, uint112 reserve1);
124 
125     function MINIMUM_LIQUIDITY() external pure returns (uint);
126     function factory() external view returns (address);
127     function token0() external view returns (address);
128     function token1() external view returns (address);
129     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
130     function price0CumulativeLast() external view returns (uint);
131     function price1CumulativeLast() external view returns (uint);
132     function kLast() external view returns (uint);
133 
134     function mint(address to) external returns (uint liquidity);
135     function burn(address to) external returns (uint amount0, uint amount1);
136     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
137     function skim(address to) external;
138     function sync() external;
139 
140     function initialize(address, address) external;
141 }
142 
143 ////// /nix/store/jhkj8my1hkpiklhhkl8xyzpxwpzix5fj-geb-uniswap-median/dapp/geb-uniswap-median/src/univ2/libs/UniswapV2Library.sol
144 /* pragma solidity 0.6.7; */
145 
146 /* import '../interfaces/IUniswapV2Pair.sol'; */
147 /* import '../interfaces/IUniswapV2Factory.sol'; */
148 
149 contract UniswapV2Library {
150     // --- Math ---
151     function uniAddition(uint x, uint y) internal pure returns (uint z) {
152         require((z = x + y) >= x, 'UniswapV2Library: add-overflow');
153     }
154     function uniSubtract(uint x, uint y) internal pure returns (uint z) {
155         require((z = x - y) <= x, 'UniswapV2Library: sub-underflow');
156     }
157     function uniMultiply(uint x, uint y) internal pure returns (uint z) {
158         require(y == 0 || (z = x * y) / y == x, 'UniswapV2Library: mul-overflow');
159     }
160 
161     // returns sorted token addresses, used to handle return values from pairs sorted in this order
162     function sortTokens(address tokenA, address tokenB) internal pure returns (address token0, address token1) {
163         require(tokenA != tokenB, 'UniswapV2Library: IDENTICAL_ADDRESSES');
164         (token0, token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
165         require(token0 != address(0), 'UniswapV2Library: ZERO_ADDRESS');
166     }
167 
168     // Modified Uniswap function to work with dapp.tools (CREATE2 throws)
169     function pairFor(address factory, address tokenA, address tokenB) internal view returns (address pair) {
170         (address token0, address token1) = sortTokens(tokenA, tokenB);
171         return IUniswapV2Factory(factory).getPair(tokenA, tokenB);
172     }
173 
174     // fetches and sorts the reserves for a pair; modified from the initial Uniswap version in order to work with dapp.tools
175     function getReserves(address factory, address tokenA, address tokenB) internal view returns (uint reserveA, uint reserveB) {
176         (address token0,) = sortTokens(tokenA, tokenB);
177         (uint reserve0, uint reserve1,) = IUniswapV2Pair(IUniswapV2Factory(factory).getPair(tokenA, tokenB)).getReserves();
178         (reserveA, reserveB) = tokenA == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
179     }
180 
181     // Given some amount of an asset and pair reserves, returns an equivalent amount of the other asset
182     function quote(uint amountA, uint reserveA, uint reserveB) internal pure returns (uint amountB) {
183         require(amountA > 0, 'UniswapV2Library: INSUFFICIENT_AMOUNT');
184         require(reserveA > 0 && reserveB > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
185         amountB = uniMultiply(amountA, reserveB) / reserveA;
186     }
187 
188     // Given an input amount of an asset and pair reserves, returns the maximum output amount of the other asset
189     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) internal pure returns (uint amountOut) {
190         require(amountIn > 0, 'UniswapV2Library: INSUFFICIENT_INPUT_AMOUNT');
191         require(reserveIn > 0 && reserveOut > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
192         uint amountInWithFee = uniMultiply(amountIn, 997);
193         uint numerator = uniMultiply(amountInWithFee, reserveOut);
194         uint denominator = uniAddition(uniMultiply(reserveIn, 1000), amountInWithFee);
195         amountOut = numerator / denominator;
196     }
197 
198     // given an output amount of an asset and pair reserves, returns a required input amount of the other asset
199     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) internal pure returns (uint amountIn) {
200         require(amountOut > 0, 'UniswapV2Library: INSUFFICIENT_OUTPUT_AMOUNT');
201         require(reserveIn > 0 && reserveOut > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
202         uint numerator = uniMultiply(uniMultiply(reserveIn, amountOut), 1000);
203         uint denominator = uniMultiply(uniSubtract(reserveOut, amountOut), 997);
204         amountIn = uniAddition((numerator / denominator), 1);
205     }
206 
207     // performs chained getAmountOut calculations on any number of pairs
208     function getAmountsOut(address factory, uint amountIn, address[] memory path) internal view returns (uint[] memory amounts) {
209         require(path.length >= 2, 'UniswapV2Library: INVALID_PATH');
210         amounts = new uint[](path.length);
211         amounts[0] = amountIn;
212         for (uint i; i < path.length - 1; i++) {
213             (uint reserveIn, uint reserveOut) = getReserves(factory, path[i], path[i + 1]);
214             amounts[i + 1] = getAmountOut(amounts[i], reserveIn, reserveOut);
215         }
216     }
217 
218     // performs chained getAmountIn calculations on any number of pairs
219     function getAmountsIn(address factory, uint amountOut, address[] memory path) internal view returns (uint[] memory amounts) {
220         require(path.length >= 2, 'UniswapV2Library: INVALID_PATH');
221         amounts = new uint[](path.length);
222         amounts[amounts.length - 1] = amountOut;
223         for (uint i = path.length - 1; i > 0; i--) {
224             (uint reserveIn, uint reserveOut) = getReserves(factory, path[i - 1], path[i]);
225             amounts[i - 1] = getAmountIn(amounts[i], reserveIn, reserveOut);
226         }
227     }
228 }
229 
230 ////// /nix/store/jhkj8my1hkpiklhhkl8xyzpxwpzix5fj-geb-uniswap-median/dapp/geb-uniswap-median/src/univ2/libs/BabylonianMath.sol
231 // SPDX-License-Identifier: GPL-3.0-or-later
232 
233 /* pragma solidity 0.6.7; */
234 
235 // computes square roots using the babylonian method
236 // https://en.wikipedia.org/wiki/Methods_of_computing_square_roots#Babylonian_method
237 contract BabylonianMath {
238     function sqrt(uint y) internal pure returns (uint z) {
239         if (y > 3) {
240             z = y;
241             uint x = y / 2 + 1;
242             while (x < z) {
243                 z = x;
244                 x = (y / x + x) / 2;
245             }
246         } else if (y != 0) {
247             z = 1;
248         }
249         // else z = 0
250     }
251 }
252 
253 ////// /nix/store/jhkj8my1hkpiklhhkl8xyzpxwpzix5fj-geb-uniswap-median/dapp/geb-uniswap-median/src/univ2/libs/FixedPointMath.sol
254 // SPDX-License-Identifier: GPL-3.0-or-later
255 
256 /* pragma solidity 0.6.7; */
257 
258 /* import './BabylonianMath.sol'; */
259 
260 // Contract for handling binary fixed point numbers (https://en.wikipedia.org/wiki/Q_(number_format))
261 contract FixedPointMath is BabylonianMath {
262     // range: [0, 2**112 - 1]
263     // resolution: 1 / 2**112
264     struct uq112x112 {
265         uint224 _x;
266     }
267 
268     // range: [0, 2**144 - 1]
269     // resolution: 1 / 2**112
270     struct uq144x112 {
271         uint _x;
272     }
273 
274     uint8 private constant RESOLUTION = 112;
275     uint private constant Q112 = uint(1) << RESOLUTION;
276     uint private constant Q224 = Q112 << RESOLUTION;
277 
278     // encode a uint112 as a UQ112x112
279     function encode(uint112 x) internal pure returns (uq112x112 memory) {
280         return uq112x112(uint224(x) << RESOLUTION);
281     }
282 
283     // encodes a uint144 as a UQ144x112
284     function encode144(uint144 x) internal pure returns (uq144x112 memory) {
285         return uq144x112(uint256(x) << RESOLUTION);
286     }
287 
288     // divide a UQ112x112 by a uint112, returning a UQ112x112
289     function div(uq112x112 memory self, uint112 x) internal pure returns (uq112x112 memory) {
290         require(x != 0, 'FixedPoint: DIV_BY_ZERO');
291         return uq112x112(self._x / uint224(x));
292     }
293 
294     // multiply a UQ112x112 by a uint, returning a UQ144x112
295     // reverts on overflow
296     function mul(uq112x112 memory self, uint y) internal pure returns (uq144x112 memory) {
297         uint z;
298         require(y == 0 || (z = uint(self._x) * y) / y == uint(self._x), "FixedPoint: MULTIPLICATION_OVERFLOW");
299         return uq144x112(z);
300     }
301 
302     // returns a UQ112x112 which represents the ratio of the numerator to the denominator
303     // equivalent to encode(numerator).divide(denominator)
304     function frac(uint112 numerator, uint112 denominator) internal pure returns (uq112x112 memory) {
305         require(denominator > 0, "FixedPoint: DIV_BY_ZERO");
306         return uq112x112((uint224(numerator) << RESOLUTION) / denominator);
307     }
308 
309     // decode a UQ112x112 into a uint112 by truncating after the radix point
310     function decode(uq112x112 memory self) internal pure returns (uint112) {
311         return uint112(self._x >> RESOLUTION);
312     }
313 
314     // decode a UQ144x112 into a uint144 by truncating after the radix point
315     function decode144(uq144x112 memory self) internal pure returns (uint144) {
316         return uint144(self._x >> RESOLUTION);
317     }
318 
319     // take the reciprocal of a UQ112x112
320     function reciprocal(uq112x112 memory self) internal pure returns (uq112x112 memory) {
321         require(self._x != 0, 'FixedPoint: ZERO_RECIPROCAL');
322         return uq112x112(uint224(Q224 / self._x));
323     }
324 
325     // square root of a UQ112x112
326     function sqrt(uq112x112 memory self) internal pure returns (uq112x112 memory) {
327         return uq112x112(uint224(super.sqrt(uint256(self._x)) << 56));
328     }
329 }
330 
331 ////// /nix/store/jhkj8my1hkpiklhhkl8xyzpxwpzix5fj-geb-uniswap-median/dapp/geb-uniswap-median/src/univ2/libs/UniswapV2OracleLibrary.sol
332 /* pragma solidity 0.6.7; */
333 
334 /* import '../interfaces/IUniswapV2Pair.sol'; */
335 /* import './FixedPointMath.sol'; */
336 
337 // Contract with helper methods for oracles that are concerned with computing average prices
338 contract UniswapV2OracleLibrary is FixedPointMath {
339     // Helper function that returns the current block timestamp within the range of uint32, i.e. [0, 2**32 - 1]
340     function currentBlockTimestamp() internal view returns (uint32) {
341         return uint32(block.timestamp % 2 ** 32);
342     }
343 
344     // Produces the cumulative price using counterfactuals to save gas and avoid a call to sync.
345     function currentCumulativePrices(
346         address pair
347     ) internal view returns (uint price0Cumulative, uint price1Cumulative, uint32 blockTimestamp) {
348         blockTimestamp = currentBlockTimestamp();
349         price0Cumulative = IUniswapV2Pair(pair).price0CumulativeLast();
350         price1Cumulative = IUniswapV2Pair(pair).price1CumulativeLast();
351 
352         // if time has elapsed since the last update on the pair, mock the accumulated price values
353         (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast) = IUniswapV2Pair(pair).getReserves();
354         if (blockTimestampLast != blockTimestamp) {
355             // subtraction overflow is desired
356             uint32 timeElapsed = blockTimestamp - blockTimestampLast;
357             // addition overflow is desired
358             // counterfactual
359             price0Cumulative += uint(frac(reserve1, reserve0)._x) * timeElapsed;
360             // counterfactual
361             price1Cumulative += uint(frac(reserve0, reserve1)._x) * timeElapsed;
362         }
363     }
364 }
365 
366 ////// /nix/store/jhkj8my1hkpiklhhkl8xyzpxwpzix5fj-geb-uniswap-median/dapp/geb-uniswap-median/src/UniswapConsecutiveSlotsPriceFeedMedianizer.sol
367 /* pragma solidity 0.6.7; */
368 
369 /* import "geb-treasury-reimbursement/math/GebMath.sol"; */
370 
371 /* import './univ2/interfaces/IUniswapV2Factory.sol'; */
372 /* import './univ2/interfaces/IUniswapV2Pair.sol'; */
373 
374 /* import './univ2/libs/UniswapV2Library.sol'; */
375 /* import './univ2/libs/UniswapV2OracleLibrary.sol'; */
376 
377 abstract contract ConverterFeedLike_2 {
378     function getResultWithValidity() virtual external view returns (uint256,bool);
379     function updateResult(address) virtual external;
380 }
381 
382 abstract contract IncreasingRewardRelayerLike_1 {
383     function reimburseCaller(address) virtual external;
384 }
385 
386 contract UniswapConsecutiveSlotsPriceFeedMedianizer is GebMath, UniswapV2Library, UniswapV2OracleLibrary {
387     // --- Auth ---
388     mapping (address => uint) public authorizedAccounts;
389     /**
390      * @notice Add auth to an account
391      * @param account Account to add auth to
392      */
393     function addAuthorization(address account) virtual external isAuthorized {
394         authorizedAccounts[account] = 1;
395         emit AddAuthorization(account);
396     }
397     /**
398      * @notice Remove auth from an account
399      * @param account Account to remove auth from
400      */
401     function removeAuthorization(address account) virtual external isAuthorized {
402         authorizedAccounts[account] = 0;
403         emit RemoveAuthorization(account);
404     }
405     /**
406     * @notice Checks whether msg.sender can call an authed function
407     **/
408     modifier isAuthorized {
409         require(authorizedAccounts[msg.sender] == 1, "UniswapConsecutiveSlotsPriceFeedMedianizer/account-not-authorized");
410         _;
411     }
412 
413     // --- Observations ---
414     struct UniswapObservation {
415         uint timestamp;
416         uint price0Cumulative;
417         uint price1Cumulative;
418     }
419     struct ConverterFeedObservation {
420         uint timestamp;
421         uint timeAdjustedPrice;
422     }
423 
424     // --- Uniswap Vars ---
425     // Default amount of targetToken used when calculating the denominationToken output
426     uint256              public defaultAmountIn;
427     // Token for which the contract calculates the medianPrice for
428     address              public targetToken;
429     // Pair token from the Uniswap pair
430     address              public denominationToken;
431     address              public uniswapPair;
432 
433     IUniswapV2Factory    public uniswapFactory;
434 
435     UniswapObservation[] public uniswapObservations;
436 
437     // --- Converter Feed Vars ---
438     // Latest converter price accumulator snapshot
439     uint256                    public converterPriceCumulative;
440 
441     ConverterFeedLike_2          public converterFeed;
442     ConverterFeedObservation[] public converterFeedObservations;
443 
444     // --- General Vars ---
445     // Symbol - you want to change this every deployment
446     bytes32 public symbol = "raiusd";
447 
448     uint8   public granularity;
449     // When the price feed was last updated
450     uint256 public lastUpdateTime;
451     // Total number of updates
452     uint256 public updates;
453     /**
454       The ideal amount of time over which the moving average should be computed, e.g. 24 hours.
455       In practice it can and most probably will be different than the actual window over which the contract medianizes.
456     **/
457     uint256 public windowSize;
458     // Maximum window size used to determine if the median is 'valid' (close to the real one) or not
459     uint256 public maxWindowSize;
460     // Stored for gas savings. Equals windowSize / granularity
461     uint256 public periodSize;
462     // This is the denominator for computing
463     uint256 public converterFeedScalingFactor;
464     // The last computed median price
465     uint256 private medianPrice;
466     // Manual flag that can be set by governance and indicates if a result is valid or not
467     uint256 public validityFlag;
468 
469     // Contract relaying the SF reward to addresses that update this oracle
470     IncreasingRewardRelayerLike_1 public relayer;
471 
472     // --- Events ---
473     event AddAuthorization(address account);
474     event RemoveAuthorization(address account);
475     event ModifyParameters(
476       bytes32 parameter,
477       address addr
478     );
479     event ModifyParameters(
480       bytes32 parameter,
481       uint256 val
482     );
483     event UpdateResult(uint256 medianPrice, uint256 lastUpdateTime);
484     event FailedConverterFeedUpdate(bytes reason);
485     event FailedUniswapPairSync(bytes reason);
486     event FailedReimburseCaller(bytes revertReason);
487 
488     constructor(
489       address converterFeed_,
490       address uniswapFactory_,
491       uint256 defaultAmountIn_,
492       uint256 windowSize_,
493       uint256 converterFeedScalingFactor_,
494       uint256 maxWindowSize_,
495       uint8   granularity_
496     ) public {
497         require(uniswapFactory_ != address(0), "UniswapConsecutiveSlotsPriceFeedMedianizer/null-uniswap-factory");
498         require(granularity_ > 1, 'UniswapConsecutiveSlotsPriceFeedMedianizer/null-granularity');
499         require(windowSize_ > 0, 'UniswapConsecutiveSlotsPriceFeedMedianizer/null-window-size');
500         require(maxWindowSize_ > windowSize_, 'UniswapConsecutiveSlotsPriceFeedMedianizer/invalid-max-window-size');
501         require(defaultAmountIn_ > 0, 'UniswapConsecutiveSlotsPriceFeedMedianizer/invalid-default-amount-in');
502         require(converterFeedScalingFactor_ > 0, 'UniswapConsecutiveSlotsPriceFeedMedianizer/null-feed-scaling-factor');
503         require(
504             (periodSize = windowSize_ / granularity_) * granularity_ == windowSize_,
505             'UniswapConsecutiveSlotsPriceFeedMedianizer/window-not-evenly-divisible'
506         );
507 
508         authorizedAccounts[msg.sender] = 1;
509 
510         converterFeed                  = ConverterFeedLike_2(converterFeed_);
511         uniswapFactory                 = IUniswapV2Factory(uniswapFactory_);
512         defaultAmountIn                = defaultAmountIn_;
513         windowSize                     = windowSize_;
514         maxWindowSize                  = maxWindowSize_;
515         converterFeedScalingFactor     = converterFeedScalingFactor_;
516         granularity                    = granularity_;
517         lastUpdateTime                 = now;
518         validityFlag                   = 1;
519 
520         // Emit events
521         emit AddAuthorization(msg.sender);
522         emit ModifyParameters(bytes32("converterFeed"), converterFeed_);
523         emit ModifyParameters(bytes32("maxWindowSize"), maxWindowSize_);
524     }
525 
526     // --- Administration ---
527     /**
528     * @notice Modify address parameters
529     * @param parameter Name of the parameter to modify
530     * @param data New parameter value
531     **/
532     function modifyParameters(bytes32 parameter, address data) external isAuthorized {
533         require(data != address(0), "UniswapConsecutiveSlotsPriceFeedMedianizer/null-data");
534         if (parameter == "converterFeed") {
535           require(data != address(0), "UniswapConsecutiveSlotsPriceFeedMedianizer/null-converter-feed");
536           converterFeed = ConverterFeedLike_2(data);
537         }
538         else if (parameter == "targetToken") {
539           require(uniswapPair == address(0), "UniswapConsecutiveSlotsPriceFeedMedianizer/pair-already-set");
540           targetToken = data;
541           if (denominationToken != address(0)) {
542             uniswapPair = uniswapFactory.getPair(targetToken, denominationToken);
543             require(uniswapPair != address(0), "UniswapConsecutiveSlotsPriceFeedMedianizer/null-uniswap-pair");
544           }
545         }
546         else if (parameter == "denominationToken") {
547           require(uniswapPair == address(0), "UniswapConsecutiveSlotsPriceFeedMedianizer/pair-already-set");
548           denominationToken = data;
549           if (targetToken != address(0)) {
550             uniswapPair = uniswapFactory.getPair(targetToken, denominationToken);
551             require(uniswapPair != address(0), "UniswapConsecutiveSlotsPriceFeedMedianizer/null-uniswap-pair");
552           }
553         }
554         else if (parameter == "relayer") {
555           relayer = IncreasingRewardRelayerLike_1(data);
556         }
557         else revert("UniswapConsecutiveSlotsPriceFeedMedianizer/modify-unrecognized-param");
558         emit ModifyParameters(parameter, data);
559     }
560     /**
561     * @notice Modify uint256 parameters
562     * @param parameter Name of the parameter to modify
563     * @param data New parameter value
564     **/
565     function modifyParameters(bytes32 parameter, uint256 data) external isAuthorized {
566         if (parameter == "validityFlag") {
567           require(either(data == 1, data == 0), "UniswapConsecutiveSlotsPriceFeedMedianizer/invalid-data");
568           validityFlag = data;
569         }
570         else if (parameter == "defaultAmountIn") {
571           require(data > 0, "UniswapConsecutiveSlotsPriceFeedMedianizer/invalid-default-amount-in");
572           defaultAmountIn = data;
573         }
574         else if (parameter == "maxWindowSize") {
575           require(data > windowSize, 'UniswapConsecutiveSlotsPriceFeedMedianizer/invalid-max-window-size');
576           maxWindowSize = data;
577         }
578         else revert("UniswapConsecutiveSlotsPriceFeedMedianizer/modify-unrecognized-param");
579         emit ModifyParameters(parameter, data);
580     }
581 
582     // --- General Utils ---
583     function either(bool x, bool y) internal pure returns (bool z) {
584         assembly{ z := or(x, y)}
585     }
586     function both(bool x, bool y) private pure returns (bool z) {
587         assembly{ z := and(x, y)}
588     }
589     /**
590     * @notice Returns the oldest observations (relative to the current index in the Uniswap/Converter lists)
591     **/
592     function getFirstObservationsInWindow()
593       private view returns (UniswapObservation storage firstUniswapObservation, ConverterFeedObservation storage firstConverterFeedObservation) {
594         uint256 earliestObservationIndex = earliestObservationIndex();
595         firstUniswapObservation          = uniswapObservations[earliestObservationIndex];
596         firstConverterFeedObservation    = converterFeedObservations[earliestObservationIndex];
597     }
598     /**
599       @notice It returns the time passed since the first observation in the window
600     **/
601     function timeElapsedSinceFirstObservation() public view returns (uint256) {
602         if (updates > 1) {
603           (
604             UniswapObservation storage firstUniswapObservation,
605           ) = getFirstObservationsInWindow();
606           return subtract(now, firstUniswapObservation.timestamp);
607         }
608         return 0;
609     }
610     /**
611     * @notice Calculate the median price using the latest observations and the latest Uniswap pair prices
612     * @param price0Cumulative Cumulative price for the first token in the pair
613     * @param price1Cumulative Cumulative price for the second token in the pair
614     **/
615     function getMedianPrice(uint256 price0Cumulative, uint256 price1Cumulative) private view returns (uint256) {
616         if (updates > 1) {
617           (
618             UniswapObservation storage firstUniswapObservation,
619           ) = getFirstObservationsInWindow();
620 
621           uint timeSinceFirst = subtract(now, firstUniswapObservation.timestamp);
622           (address token0,)   = sortTokens(targetToken, denominationToken);
623           uint256 uniswapAmountOut;
624 
625           if (token0 == targetToken) {
626               uniswapAmountOut = uniswapComputeAmountOut(
627                 firstUniswapObservation.price0Cumulative, price0Cumulative, timeSinceFirst, defaultAmountIn
628               );
629           } else {
630               uniswapAmountOut = uniswapComputeAmountOut(
631                 firstUniswapObservation.price1Cumulative, price1Cumulative, timeSinceFirst, defaultAmountIn
632               );
633           }
634 
635           return converterComputeAmountOut(timeSinceFirst, uniswapAmountOut);
636         }
637 
638         return medianPrice;
639     }
640     /**
641     * @notice Returns the index of the earliest observation in the window
642     **/
643     function earliestObservationIndex() public view returns (uint256) {
644         if (updates <= granularity) {
645           return 0;
646         }
647         return subtract(updates, uint(granularity));
648     }
649     /**
650     * @notice Get the observation list length
651     **/
652     function getObservationListLength() public view returns (uint256, uint256) {
653         return (uniswapObservations.length, converterFeedObservations.length);
654     }
655 
656     // --- Uniswap Utils ---
657     /**
658     * @notice Given the Uniswap cumulative prices of the start and end of a period, and the length of the period, compute the average
659     *         price in terms of how much amount out is received for the amount in.
660     * @param priceCumulativeStart Old snapshot of the cumulative price of a token
661     * @param priceCumulativeEnd New snapshot of the cumulative price of a token
662     * @param timeElapsed Total time elapsed
663     * @param amountIn Amount of target tokens we want to find the price for
664     **/
665     function uniswapComputeAmountOut(
666         uint256 priceCumulativeStart,
667         uint256 priceCumulativeEnd,
668         uint256 timeElapsed,
669         uint256 amountIn
670     ) public pure returns (uint256 amountOut) {
671         require(priceCumulativeEnd >= priceCumulativeStart, "UniswapConverterBasicAveragePriceFeedMedianizer/invalid-end-cumulative");
672         require(timeElapsed > 0, "UniswapConsecutiveSlotsPriceFeedMedianizer/null-time-elapsed");
673         // Overflow is desired
674         uq112x112 memory priceAverage = uq112x112(
675             uint224((priceCumulativeEnd - priceCumulativeStart) / timeElapsed)
676         );
677         amountOut = decode144(mul(priceAverage, amountIn));
678     }
679 
680     // --- Converter Utils ---
681     /**
682     * @notice Calculate the price of an amount of tokens using the converter price feed as well as the time elapsed between
683     *         the latest timestamp and the timestamp of the earliest observation in the window.
684     *         Used after the contract determines the amount of Uniswap pair denomination tokens for amountIn target tokens
685     * @param timeElapsed Time elapsed between now and the earliest observation in the window.
686     * @param amountIn Amount of denomination tokens to calculate the price for
687     **/
688     function converterComputeAmountOut(
689         uint256 timeElapsed,
690         uint256 amountIn
691     ) public view returns (uint256 amountOut) {
692         require(timeElapsed > 0, "UniswapConsecutiveSlotsPriceFeedMedianizer/null-time-elapsed");
693         uint256 priceAverage = converterPriceCumulative / timeElapsed;
694         amountOut            = multiply(amountIn, priceAverage) / converterFeedScalingFactor;
695     }
696 
697     // --- Core Logic ---
698     /**
699     * @notice Update the internal median price
700     **/
701     function updateResult(address feeReceiver) external {
702         require(address(relayer) != address(0), "UniswapConsecutiveSlotsPriceFeedMedianizer/null-relayer");
703         require(uniswapPair != address(0), "UniswapConsecutiveSlotsPriceFeedMedianizer/null-uniswap-pair");
704 
705         // Get final fee receiver
706         address finalFeeReceiver = (feeReceiver == address(0)) ? msg.sender : feeReceiver;
707 
708         // Update the converter's median price first
709         try converterFeed.updateResult(finalFeeReceiver) {}
710         catch (bytes memory converterRevertReason) {
711           emit FailedConverterFeedUpdate(converterRevertReason);
712         }
713 
714         // Get the observation for the current period
715         uint256 timeElapsedSinceLatest = (uniswapObservations.length == 0) ?
716           subtract(now, lastUpdateTime) : subtract(now, uniswapObservations[uniswapObservations.length - 1].timestamp);
717         // We only want to commit updates once per period (i.e. windowSize / granularity)
718         if (uniswapObservations.length > 0) {
719           require(timeElapsedSinceLatest >= periodSize, "UniswapConsecutiveSlotsPriceFeedMedianizer/not-enough-time-elapsed");
720         }
721 
722         // Update Uniswap pair
723         try IUniswapV2Pair(uniswapPair).sync() {}
724         catch (bytes memory uniswapRevertReason) {
725           emit FailedUniswapPairSync(uniswapRevertReason);
726         }
727 
728         // Get Uniswap cumulative prices
729         (uint uniswapPrice0Cumulative, uint uniswapPrice1Cumulative,) = currentCumulativePrices(uniswapPair);
730 
731         // Add new observations
732         updateObservations(timeElapsedSinceLatest, uniswapPrice0Cumulative, uniswapPrice1Cumulative);
733 
734         // Calculate latest medianPrice
735         medianPrice    = getMedianPrice(uniswapPrice0Cumulative, uniswapPrice1Cumulative);
736         lastUpdateTime = now;
737         updates        = addition(updates, 1);
738 
739         emit UpdateResult(medianPrice, lastUpdateTime);
740 
741         // Try to reward the caller
742         try relayer.reimburseCaller(finalFeeReceiver) {
743         } catch (bytes memory revertReason) {
744           emit FailedReimburseCaller(revertReason);
745         }
746     }
747     /**
748     * @notice Push new observation data in the observation arrays
749     * @param timeElapsedSinceLatest Time elapsed between now and the earliest observation in the window
750     * @param uniswapPrice0Cumulative Latest cumulative price of the first token in a Uniswap pair
751     * @param uniswapPrice1Cumulative Latest cumulative price of the second tokens in a Uniswap pair
752     **/
753     function updateObservations(
754       uint256 timeElapsedSinceLatest,
755       uint256 uniswapPrice0Cumulative,
756       uint256 uniswapPrice1Cumulative
757     ) internal {
758         // Add converter feed observation
759         (uint256 priceFeedValue, bool hasValidValue) = converterFeed.getResultWithValidity();
760         require(hasValidValue, "UniswapConsecutiveSlotsPriceFeedMedianizer/invalid-converter-price-feed");
761         uint256 newTimeAdjustedPrice = multiply(priceFeedValue, timeElapsedSinceLatest);
762 
763         // Add converter observation
764         converterFeedObservations.push(ConverterFeedObservation(now, newTimeAdjustedPrice));
765         // Add Uniswap observation
766         uniswapObservations.push(UniswapObservation(now, uniswapPrice0Cumulative, uniswapPrice1Cumulative));
767 
768         // Add the new update
769         converterPriceCumulative = addition(converterPriceCumulative, newTimeAdjustedPrice);
770 
771         // Subtract the earliest update
772         if (updates >= granularity) {
773           (
774             ,
775             ConverterFeedObservation storage firstConverterFeedObservation
776           ) = getFirstObservationsInWindow();
777           converterPriceCumulative = subtract(converterPriceCumulative, firstConverterFeedObservation.timeAdjustedPrice);
778         }
779     }
780 
781     // --- Getters ---
782     /**
783     * @notice Fetch the latest medianPrice or revert if is is null
784     **/
785     function read() external view returns (uint256) {
786         require(
787           both(both(both(medianPrice > 0, updates > granularity), timeElapsedSinceFirstObservation() <= maxWindowSize), validityFlag == 1),
788           "UniswapConsecutiveSlotsPriceFeedMedianizer/invalid-price-feed"
789         );
790         return medianPrice;
791     }
792     /**
793     * @notice Fetch the latest medianPrice and whether it is null or not
794     **/
795     function getResultWithValidity() external view returns (uint256, bool) {
796         return (
797           medianPrice,
798           both(both(both(medianPrice > 0, updates > granularity), timeElapsedSinceFirstObservation() <= maxWindowSize), validityFlag == 1)
799         );
800     }
801 }
