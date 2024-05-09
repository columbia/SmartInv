1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.7.6;
4 pragma abicoder v2;
5 
6 /**
7  * @dev Interface of the ERC20 standard as defined in the EIP.
8  */
9 interface IERC20 {
10     /**
11      * @dev Returns the amount of tokens in existence.
12      */
13     function totalSupply() external view returns (uint256);
14 
15     /**
16      * @dev Returns the amount of tokens owned by `account`.
17      */
18     function balanceOf(address account) external view returns (uint256);
19 
20     /**
21      * @dev Moves `amount` tokens from the caller's account to `recipient`.
22      *
23      * Returns a boolean value indicating whether the operation succeeded.
24      *
25      * Emits a {Transfer} event.
26      */
27     function transfer(address recipient, uint256 amount) external returns (bool);
28 
29     /**
30      * @dev Returns the remaining number of tokens that `spender` will be
31      * allowed to spend on behalf of `owner` through {transferFrom}. This is
32      * zero by default.
33      *
34      * This value changes when {approve} or {transferFrom} are called.
35      */
36     function allowance(address owner, address spender) external view returns (uint256);
37 
38     /**
39      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
40      *
41      * Returns a boolean value indicating whether the operation succeeded.
42      *
43      * IMPORTANT: Beware that changing an allowance with this method brings the risk
44      * that someone may use both the old and the new allowance by unfortunate
45      * transaction ordering. One possible solution to mitigate this race
46      * condition is to first reduce the spender's allowance to 0 and set the
47      * desired value afterwards:
48      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
49      *
50      * Emits an {Approval} event.
51      */
52     function approve(address spender, uint256 amount) external returns (bool);
53 
54     /**
55      * @dev Moves `amount` tokens from `sender` to `recipient` using the
56      * allowance mechanism. `amount` is then deducted from the caller's
57      * allowance.
58      *
59      * Returns a boolean value indicating whether the operation succeeded.
60      *
61      * Emits a {Transfer} event.
62      */
63     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
64 
65     /**
66      * @dev Emitted when `value` tokens are moved from one account (`from`) to
67      * another (`to`).
68      *
69      * Note that `value` may be zero.
70      */
71     event Transfer(address indexed from, address indexed to, uint256 value);
72 
73     /**
74      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
75      * a call to {approve}. `value` is the new allowance.
76      */
77     event Approval(address indexed owner, address indexed spender, uint256 value);
78 }
79 
80 interface IPopsicleV3Optimizer {
81     /// @notice The first of the two tokens of the pool, sorted by address
82     /// @return The token contract address
83     function token0() external view returns (address);
84 
85     /// @notice The second of the two tokens of the pool, sorted by address
86     /// @return The token contract address
87     function token1() external view returns (address);
88     
89     /// @notice The pool tick spacing
90     /// @dev Ticks can only be used at multiples of this value, minimum of 1 and always positive
91     /// e.g.: a tickSpacing of 3 means ticks can be initialized every 3rd tick, i.e., ..., -6, -3, 0, 3, 6, ...
92     /// This value is an int24 to avoid casting even though it is always positive.
93     /// @return The tick spacing
94     function tickSpacing() external view returns (int24);
95 
96     /// @notice A Uniswap pool facilitates swapping and automated market making between any two assets that strictly conform
97     /// to the ERC20 specification
98     /// @return The address of the Uniswap V3 Pool
99     function pool() external view returns (IUniswapV3Pool);
100 
101     /// @notice The lower tick of the range
102     function tickLower() external view returns (int24);
103 
104     /// @notice The upper tick of the range
105     function tickUpper() external view returns (int24);
106 
107     /**
108      * @notice Deposits tokens in proportion to the Optimizer's current ticks.
109      * @param amount0Desired Max amount of token0 to deposit
110      * @param amount1Desired Max amount of token1 to deposit
111      * @param to address that plp should be transfered
112      * @return shares minted
113      * @return amount0 Amount of token0 deposited
114      * @return amount1 Amount of token1 deposited
115      */
116     function deposit(uint256 amount0Desired, uint256 amount1Desired, address to) external returns (uint256 shares, uint256 amount0,uint256 amount1);
117 
118     /**
119      * @notice Withdraws tokens in proportion to the Optimizer's holdings.
120      * @dev Removes proportional amount of liquidity from Uniswap.
121      * @param shares burned by sender
122      * @return amount0 Amount of token0 sent to recipient
123      * @return amount1 Amount of token1 sent to recipient
124      */
125     function withdraw(uint256 shares, address to) external returns (uint256 amount0, uint256 amount1);
126 
127     /**
128      * @notice Updates Optimizer's positions.
129      * @dev Finds base position and limit position for imbalanced token
130      * mints all amounts to this position(including earned fees)
131      */
132     function rerange() external;
133 
134     /**
135      * @notice Updates Optimizer's positions. Can only be called by the governance.
136      * @dev Swaps imbalanced token. Finds base position and limit position for imbalanced token if
137      * we don't have balance during swap because of price impact.
138      * mints all amounts to this position(including earned fees)
139      */
140     function rebalance() external;
141 }
142 
143 interface IOptimizerStrategy {
144     /// @return Maximul PLP value that could be minted
145     function maxTotalSupply() external view returns (uint256);
146 
147     /// @notice Period of time that we observe for price slippage
148     /// @return time in seconds
149     function twapDuration() external view returns (uint32);
150 
151     /// @notice Maximum deviation of time waited avarage price in ticks
152     function maxTwapDeviation() external view returns (int24);
153 
154     /// @notice Tick multuplier for base range calculation
155     function tickRangeMultiplier() external view returns (int24);
156 
157     /// @notice The price impact percentage during swap denominated in hundredths of a bip, i.e. 1e-6
158     /// @return The max price impact percentage
159     function priceImpactPercentage() external view returns (uint24);
160 }
161 
162 library PositionKey {
163     /// @dev Returns the key of the position in the core library
164     function compute(
165         address owner,
166         int24 tickLower,
167         int24 tickUpper
168     ) internal pure returns (bytes32) {
169         return keccak256(abi.encodePacked(owner, tickLower, tickUpper));
170     }
171 }
172 
173 /// @title Math library for computing sqrt prices from ticks and vice versa
174 /// @notice Computes sqrt price for ticks of size 1.0001, i.e. sqrt(1.0001^tick) as fixed point Q64.96 numbers. Supports
175 /// prices between 2**-128 and 2**128
176 library TickMath {
177     /// @dev The minimum tick that may be passed to #getSqrtRatioAtTick computed from log base 1.0001 of 2**-128
178     int24 internal constant MIN_TICK = -887272;
179     /// @dev The maximum tick that may be passed to #getSqrtRatioAtTick computed from log base 1.0001 of 2**128
180     int24 internal constant MAX_TICK = -MIN_TICK;
181 
182     /// @dev The minimum value that can be returned from #getSqrtRatioAtTick. Equivalent to getSqrtRatioAtTick(MIN_TICK)
183     uint160 internal constant MIN_SQRT_RATIO = 4295128739;
184     /// @dev The maximum value that can be returned from #getSqrtRatioAtTick. Equivalent to getSqrtRatioAtTick(MAX_TICK)
185     uint160 internal constant MAX_SQRT_RATIO = 1461446703485210103287273052203988822378723970342;
186 
187     /// @notice Calculates sqrt(1.0001^tick) * 2^96
188     /// @dev Throws if |tick| > max tick
189     /// @param tick The input tick for the above formula
190     /// @return sqrtPriceX96 A Fixed point Q64.96 number representing the sqrt of the ratio of the two assets (token1/token0)
191     /// at the given tick
192     function getSqrtRatioAtTick(int24 tick) internal pure returns (uint160 sqrtPriceX96) {
193         uint256 absTick = tick < 0 ? uint256(-int256(tick)) : uint256(int256(tick));
194         require(absTick <= uint256(MAX_TICK), 'T');
195 
196         uint256 ratio = absTick & 0x1 != 0 ? 0xfffcb933bd6fad37aa2d162d1a594001 : 0x100000000000000000000000000000000;
197         if (absTick & 0x2 != 0) ratio = (ratio * 0xfff97272373d413259a46990580e213a) >> 128;
198         if (absTick & 0x4 != 0) ratio = (ratio * 0xfff2e50f5f656932ef12357cf3c7fdcc) >> 128;
199         if (absTick & 0x8 != 0) ratio = (ratio * 0xffe5caca7e10e4e61c3624eaa0941cd0) >> 128;
200         if (absTick & 0x10 != 0) ratio = (ratio * 0xffcb9843d60f6159c9db58835c926644) >> 128;
201         if (absTick & 0x20 != 0) ratio = (ratio * 0xff973b41fa98c081472e6896dfb254c0) >> 128;
202         if (absTick & 0x40 != 0) ratio = (ratio * 0xff2ea16466c96a3843ec78b326b52861) >> 128;
203         if (absTick & 0x80 != 0) ratio = (ratio * 0xfe5dee046a99a2a811c461f1969c3053) >> 128;
204         if (absTick & 0x100 != 0) ratio = (ratio * 0xfcbe86c7900a88aedcffc83b479aa3a4) >> 128;
205         if (absTick & 0x200 != 0) ratio = (ratio * 0xf987a7253ac413176f2b074cf7815e54) >> 128;
206         if (absTick & 0x400 != 0) ratio = (ratio * 0xf3392b0822b70005940c7a398e4b70f3) >> 128;
207         if (absTick & 0x800 != 0) ratio = (ratio * 0xe7159475a2c29b7443b29c7fa6e889d9) >> 128;
208         if (absTick & 0x1000 != 0) ratio = (ratio * 0xd097f3bdfd2022b8845ad8f792aa5825) >> 128;
209         if (absTick & 0x2000 != 0) ratio = (ratio * 0xa9f746462d870fdf8a65dc1f90e061e5) >> 128;
210         if (absTick & 0x4000 != 0) ratio = (ratio * 0x70d869a156d2a1b890bb3df62baf32f7) >> 128;
211         if (absTick & 0x8000 != 0) ratio = (ratio * 0x31be135f97d08fd981231505542fcfa6) >> 128;
212         if (absTick & 0x10000 != 0) ratio = (ratio * 0x9aa508b5b7a84e1c677de54f3e99bc9) >> 128;
213         if (absTick & 0x20000 != 0) ratio = (ratio * 0x5d6af8dedb81196699c329225ee604) >> 128;
214         if (absTick & 0x40000 != 0) ratio = (ratio * 0x2216e584f5fa1ea926041bedfe98) >> 128;
215         if (absTick & 0x80000 != 0) ratio = (ratio * 0x48a170391f7dc42444e8fa2) >> 128;
216 
217         if (tick > 0) ratio = type(uint256).max / ratio;
218 
219         // this divides by 1<<32 rounding up to go from a Q128.128 to a Q128.96.
220         // we then downcast because we know the result always fits within 160 bits due to our tick input constraint
221         // we round up in the division so getTickAtSqrtRatio of the output price is always consistent
222         sqrtPriceX96 = uint160((ratio >> 32) + (ratio % (1 << 32) == 0 ? 0 : 1));
223     }
224 
225     /// @notice Calculates the greatest tick value such that getRatioAtTick(tick) <= ratio
226     /// @dev Throws in case sqrtPriceX96 < MIN_SQRT_RATIO, as MIN_SQRT_RATIO is the lowest value getRatioAtTick may
227     /// ever return.
228     /// @param sqrtPriceX96 The sqrt ratio for which to compute the tick as a Q64.96
229     /// @return tick The greatest tick for which the ratio is less than or equal to the input ratio
230     function getTickAtSqrtRatio(uint160 sqrtPriceX96) internal pure returns (int24 tick) {
231         // second inequality must be < because the price can never reach the price at the max tick
232         require(sqrtPriceX96 >= MIN_SQRT_RATIO && sqrtPriceX96 < MAX_SQRT_RATIO, 'R');
233         uint256 ratio = uint256(sqrtPriceX96) << 32;
234 
235         uint256 r = ratio;
236         uint256 msb = 0;
237 
238         assembly {
239             let f := shl(7, gt(r, 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF))
240             msb := or(msb, f)
241             r := shr(f, r)
242         }
243         assembly {
244             let f := shl(6, gt(r, 0xFFFFFFFFFFFFFFFF))
245             msb := or(msb, f)
246             r := shr(f, r)
247         }
248         assembly {
249             let f := shl(5, gt(r, 0xFFFFFFFF))
250             msb := or(msb, f)
251             r := shr(f, r)
252         }
253         assembly {
254             let f := shl(4, gt(r, 0xFFFF))
255             msb := or(msb, f)
256             r := shr(f, r)
257         }
258         assembly {
259             let f := shl(3, gt(r, 0xFF))
260             msb := or(msb, f)
261             r := shr(f, r)
262         }
263         assembly {
264             let f := shl(2, gt(r, 0xF))
265             msb := or(msb, f)
266             r := shr(f, r)
267         }
268         assembly {
269             let f := shl(1, gt(r, 0x3))
270             msb := or(msb, f)
271             r := shr(f, r)
272         }
273         assembly {
274             let f := gt(r, 0x1)
275             msb := or(msb, f)
276         }
277 
278         if (msb >= 128) r = ratio >> (msb - 127);
279         else r = ratio << (127 - msb);
280 
281         int256 log_2 = (int256(msb) - 128) << 64;
282 
283         assembly {
284             r := shr(127, mul(r, r))
285             let f := shr(128, r)
286             log_2 := or(log_2, shl(63, f))
287             r := shr(f, r)
288         }
289         assembly {
290             r := shr(127, mul(r, r))
291             let f := shr(128, r)
292             log_2 := or(log_2, shl(62, f))
293             r := shr(f, r)
294         }
295         assembly {
296             r := shr(127, mul(r, r))
297             let f := shr(128, r)
298             log_2 := or(log_2, shl(61, f))
299             r := shr(f, r)
300         }
301         assembly {
302             r := shr(127, mul(r, r))
303             let f := shr(128, r)
304             log_2 := or(log_2, shl(60, f))
305             r := shr(f, r)
306         }
307         assembly {
308             r := shr(127, mul(r, r))
309             let f := shr(128, r)
310             log_2 := or(log_2, shl(59, f))
311             r := shr(f, r)
312         }
313         assembly {
314             r := shr(127, mul(r, r))
315             let f := shr(128, r)
316             log_2 := or(log_2, shl(58, f))
317             r := shr(f, r)
318         }
319         assembly {
320             r := shr(127, mul(r, r))
321             let f := shr(128, r)
322             log_2 := or(log_2, shl(57, f))
323             r := shr(f, r)
324         }
325         assembly {
326             r := shr(127, mul(r, r))
327             let f := shr(128, r)
328             log_2 := or(log_2, shl(56, f))
329             r := shr(f, r)
330         }
331         assembly {
332             r := shr(127, mul(r, r))
333             let f := shr(128, r)
334             log_2 := or(log_2, shl(55, f))
335             r := shr(f, r)
336         }
337         assembly {
338             r := shr(127, mul(r, r))
339             let f := shr(128, r)
340             log_2 := or(log_2, shl(54, f))
341             r := shr(f, r)
342         }
343         assembly {
344             r := shr(127, mul(r, r))
345             let f := shr(128, r)
346             log_2 := or(log_2, shl(53, f))
347             r := shr(f, r)
348         }
349         assembly {
350             r := shr(127, mul(r, r))
351             let f := shr(128, r)
352             log_2 := or(log_2, shl(52, f))
353             r := shr(f, r)
354         }
355         assembly {
356             r := shr(127, mul(r, r))
357             let f := shr(128, r)
358             log_2 := or(log_2, shl(51, f))
359             r := shr(f, r)
360         }
361         assembly {
362             r := shr(127, mul(r, r))
363             let f := shr(128, r)
364             log_2 := or(log_2, shl(50, f))
365         }
366 
367         int256 log_sqrt10001 = log_2 * 255738958999603826347141; // 128.128 number
368 
369         int24 tickLow = int24((log_sqrt10001 - 3402992956809132418596140100660247210) >> 128);
370         int24 tickHi = int24((log_sqrt10001 + 291339464771989622907027621153398088495) >> 128);
371 
372         tick = tickLow == tickHi ? tickLow : getSqrtRatioAtTick(tickHi) <= sqrtPriceX96 ? tickHi : tickLow;
373     }
374 }
375 
376 
377 
378 /// @title Liquidity amount functions
379 /// @notice Provides functions for computing liquidity amounts from token amounts and prices
380 library LiquidityAmounts {
381     /// @notice Downcasts uint256 to uint128
382     /// @param x The uint258 to be downcasted
383     /// @return y The passed value, downcasted to uint128
384     function toUint128(uint256 x) private pure returns (uint128 y) {
385         require((y = uint128(x)) == x);
386     }
387 
388     /// @notice Computes the amount of liquidity received for a given amount of token0 and price range
389     /// @dev Calculates amount0 * (sqrt(upper) * sqrt(lower)) / (sqrt(upper) - sqrt(lower))
390     /// @param sqrtRatioAX96 A sqrt price representing the first tick boundary
391     /// @param sqrtRatioBX96 A sqrt price representing the second tick boundary
392     /// @param amount0 The amount0 being sent in
393     /// @return liquidity The amount of returned liquidity
394     function getLiquidityForAmount0(
395         uint160 sqrtRatioAX96,
396         uint160 sqrtRatioBX96,
397         uint256 amount0
398     ) internal pure returns (uint128 liquidity) {
399         if (sqrtRatioAX96 > sqrtRatioBX96) (sqrtRatioAX96, sqrtRatioBX96) = (sqrtRatioBX96, sqrtRatioAX96);
400         uint256 intermediate = FullMath.mulDiv(sqrtRatioAX96, sqrtRatioBX96, FixedPoint96.Q96);
401         return toUint128(FullMath.mulDiv(amount0, intermediate, sqrtRatioBX96 - sqrtRatioAX96));
402     }
403 
404     /// @notice Computes the amount of liquidity received for a given amount of token1 and price range
405     /// @dev Calculates amount1 / (sqrt(upper) - sqrt(lower)).
406     /// @param sqrtRatioAX96 A sqrt price representing the first tick boundary
407     /// @param sqrtRatioBX96 A sqrt price representing the second tick boundary
408     /// @param amount1 The amount1 being sent in
409     /// @return liquidity The amount of returned liquidity
410     function getLiquidityForAmount1(
411         uint160 sqrtRatioAX96,
412         uint160 sqrtRatioBX96,
413         uint256 amount1
414     ) internal pure returns (uint128 liquidity) {
415         if (sqrtRatioAX96 > sqrtRatioBX96) (sqrtRatioAX96, sqrtRatioBX96) = (sqrtRatioBX96, sqrtRatioAX96);
416         return toUint128(FullMath.mulDiv(amount1, FixedPoint96.Q96, sqrtRatioBX96 - sqrtRatioAX96));
417     }
418 
419     /// @notice Computes the maximum amount of liquidity received for a given amount of token0, token1, the current
420     /// pool prices and the prices at the tick boundaries
421     /// @param sqrtRatioX96 A sqrt price representing the current pool prices
422     /// @param sqrtRatioAX96 A sqrt price representing the first tick boundary
423     /// @param sqrtRatioBX96 A sqrt price representing the second tick boundary
424     /// @param amount0 The amount of token0 being sent in
425     /// @param amount1 The amount of token1 being sent in
426     /// @return liquidity The maximum amount of liquidity received
427     function getLiquidityForAmounts(
428         uint160 sqrtRatioX96,
429         uint160 sqrtRatioAX96,
430         uint160 sqrtRatioBX96,
431         uint256 amount0,
432         uint256 amount1
433     ) internal pure returns (uint128 liquidity) {
434         if (sqrtRatioAX96 > sqrtRatioBX96) (sqrtRatioAX96, sqrtRatioBX96) = (sqrtRatioBX96, sqrtRatioAX96);
435 
436         if (sqrtRatioX96 <= sqrtRatioAX96) {
437             liquidity = getLiquidityForAmount0(sqrtRatioAX96, sqrtRatioBX96, amount0);
438         } else if (sqrtRatioX96 < sqrtRatioBX96) {
439             uint128 liquidity0 = getLiquidityForAmount0(sqrtRatioX96, sqrtRatioBX96, amount0);
440             uint128 liquidity1 = getLiquidityForAmount1(sqrtRatioAX96, sqrtRatioX96, amount1);
441 
442             liquidity = liquidity0 < liquidity1 ? liquidity0 : liquidity1;
443         } else {
444             liquidity = getLiquidityForAmount1(sqrtRatioAX96, sqrtRatioBX96, amount1);
445         }
446     }
447 
448     /// @notice Computes the amount of token0 for a given amount of liquidity and a price range
449     /// @param sqrtRatioAX96 A sqrt price representing the first tick boundary
450     /// @param sqrtRatioBX96 A sqrt price representing the second tick boundary
451     /// @param liquidity The liquidity being valued
452     /// @return amount0 The amount of token0
453     function getAmount0ForLiquidity(
454         uint160 sqrtRatioAX96,
455         uint160 sqrtRatioBX96,
456         uint128 liquidity
457     ) internal pure returns (uint256 amount0) {
458         if (sqrtRatioAX96 > sqrtRatioBX96) (sqrtRatioAX96, sqrtRatioBX96) = (sqrtRatioBX96, sqrtRatioAX96);
459 
460         return
461             FullMath.mulDiv(
462                 uint256(liquidity) << FixedPoint96.RESOLUTION,
463                 sqrtRatioBX96 - sqrtRatioAX96,
464                 sqrtRatioBX96
465             ) / sqrtRatioAX96;
466     }
467 
468     /// @notice Computes the amount of token1 for a given amount of liquidity and a price range
469     /// @param sqrtRatioAX96 A sqrt price representing the first tick boundary
470     /// @param sqrtRatioBX96 A sqrt price representing the second tick boundary
471     /// @param liquidity The liquidity being valued
472     /// @return amount1 The amount of token1
473     function getAmount1ForLiquidity(
474         uint160 sqrtRatioAX96,
475         uint160 sqrtRatioBX96,
476         uint128 liquidity
477     ) internal pure returns (uint256 amount1) {
478         if (sqrtRatioAX96 > sqrtRatioBX96) (sqrtRatioAX96, sqrtRatioBX96) = (sqrtRatioBX96, sqrtRatioAX96);
479 
480         return FullMath.mulDiv(liquidity, sqrtRatioBX96 - sqrtRatioAX96, FixedPoint96.Q96);
481     }
482 
483     /// @notice Computes the token0 and token1 value for a given amount of liquidity, the current
484     /// pool prices and the prices at the tick boundaries
485     /// @param sqrtRatioX96 A sqrt price representing the current pool prices
486     /// @param sqrtRatioAX96 A sqrt price representing the first tick boundary
487     /// @param sqrtRatioBX96 A sqrt price representing the second tick boundary
488     /// @param liquidity The liquidity being valued
489     /// @return amount0 The amount of token0
490     /// @return amount1 The amount of token1
491     function getAmountsForLiquidity(
492         uint160 sqrtRatioX96,
493         uint160 sqrtRatioAX96,
494         uint160 sqrtRatioBX96,
495         uint128 liquidity
496     ) internal pure returns (uint256 amount0, uint256 amount1) {
497         if (sqrtRatioAX96 > sqrtRatioBX96) (sqrtRatioAX96, sqrtRatioBX96) = (sqrtRatioBX96, sqrtRatioAX96);
498 
499         if (sqrtRatioX96 <= sqrtRatioAX96) {
500             amount0 = getAmount0ForLiquidity(sqrtRatioAX96, sqrtRatioBX96, liquidity);
501         } else if (sqrtRatioX96 < sqrtRatioBX96) {
502             amount0 = getAmount0ForLiquidity(sqrtRatioX96, sqrtRatioBX96, liquidity);
503             amount1 = getAmount1ForLiquidity(sqrtRatioAX96, sqrtRatioX96, liquidity);
504         } else {
505             amount1 = getAmount1ForLiquidity(sqrtRatioAX96, sqrtRatioBX96, liquidity);
506         }
507     }
508 }
509 
510 /// @title Liquidity and ticks functions
511 /// @notice Provides functions for computing liquidity and ticks for token amounts and prices
512 library PoolVariables {
513     using LowGasSafeMath for uint256;
514     using LowGasSafeMath for uint128;
515 
516     // Cache struct for calculations
517     struct Info {
518         uint256 amount0Desired;
519         uint256 amount1Desired;
520         uint256 amount0;
521         uint256 amount1;
522         uint128 liquidity;
523         int24 tickLower;
524         int24 tickUpper;
525     }
526 
527     /// @dev Wrapper around `LiquidityAmounts.getAmountsForLiquidity()`.
528     /// @param pool Uniswap V3 pool
529     /// @param liquidity  The liquidity being valued
530     /// @param _tickLower The lower tick of the range
531     /// @param _tickUpper The upper tick of the range
532     /// @return amounts of token0 and token1 that corresponds to liquidity
533     function amountsForLiquidity(
534         IUniswapV3Pool pool,
535         uint128 liquidity,
536         int24 _tickLower,
537         int24 _tickUpper
538     ) internal view returns (uint256, uint256) {
539         //Get current price from the pool
540         (uint160 sqrtRatioX96, , , , , , ) = pool.slot0();
541         return
542             LiquidityAmounts.getAmountsForLiquidity(
543                 sqrtRatioX96,
544                 TickMath.getSqrtRatioAtTick(_tickLower),
545                 TickMath.getSqrtRatioAtTick(_tickUpper),
546                 liquidity
547             );
548     }
549 
550     /// @dev Wrapper around `LiquidityAmounts.getLiquidityForAmounts()`.
551     /// @param pool Uniswap V3 pool
552     /// @param amount0 The amount of token0
553     /// @param amount1 The amount of token1
554     /// @param _tickLower The lower tick of the range
555     /// @param _tickUpper The upper tick of the range
556     /// @return The maximum amount of liquidity that can be held amount0 and amount1
557     function liquidityForAmounts(
558         IUniswapV3Pool pool,
559         uint256 amount0,
560         uint256 amount1,
561         int24 _tickLower,
562         int24 _tickUpper
563     ) internal view returns (uint128) {
564         //Get current price from the pool
565         (uint160 sqrtRatioX96, , , , , , ) = pool.slot0();
566 
567         return
568             LiquidityAmounts.getLiquidityForAmounts(
569                 sqrtRatioX96,
570                 TickMath.getSqrtRatioAtTick(_tickLower),
571                 TickMath.getSqrtRatioAtTick(_tickUpper),
572                 amount0,
573                 amount1
574             );
575     }
576 
577     /// @dev Amounts of token0 and token1 held in contract position.
578     /// @param pool Uniswap V3 pool
579     /// @param _tickLower The lower tick of the range
580     /// @param _tickUpper The upper tick of the range
581     /// @return amount0 The amount of token0 held in position
582     /// @return amount1 The amount of token1 held in position
583     function usersAmounts(IUniswapV3Pool pool,  int24 _tickLower, int24 _tickUpper)
584         internal
585         view
586         returns (uint256 amount0, uint256 amount1)
587     {   
588         //Compute position key
589         bytes32 positionKey = PositionKey.compute(address(this), _tickLower, _tickUpper);
590         //Get Position.Info for specified ticks
591         (uint128 liquidity, , , uint128 tokensOwed0, uint128 tokensOwed1) =
592             pool.positions(positionKey);
593         
594         // Calc amounts of token0 and token1 including fees
595         (amount0, amount1) = amountsForLiquidity(pool, liquidity, _tickLower, _tickUpper);
596 
597         amount0 = amount0.add(tokensOwed0);
598         amount1 = amount1.add(tokensOwed1);
599     }
600 
601     /// @dev Amount of liquidity in contract position.
602     /// @param pool Uniswap V3 pool
603     /// @param _tickLower The lower tick of the range
604     /// @param _tickUpper The upper tick of the range
605     /// @return liquidity stored in position
606     function positionLiquidity(IUniswapV3Pool pool, int24 _tickLower, int24 _tickUpper)
607         internal
608         view
609         returns (uint128 liquidity)
610     {
611         //Compute position key
612         bytes32 positionKey = PositionKey.compute(address(this), _tickLower, _tickUpper);
613         //Get liquidity stored in position
614         (liquidity, , , , ) = pool.positions(positionKey);
615     }
616 
617     /// @dev Common checks for valid tick inputs.
618     /// @param tickLower The lower tick of the range
619     /// @param tickUpper The upper tick of the range
620     function checkRange(int24 tickLower, int24 tickUpper) internal pure {
621         require(tickLower < tickUpper, "TLU");
622         require(tickLower >= TickMath.MIN_TICK, "TLM");
623         require(tickUpper <= TickMath.MAX_TICK, "TUM");
624     }
625 
626     /// @dev Rounds tick down towards negative infinity so that it's a multiple
627     /// of `tickSpacing`.
628     function floor(int24 tick, int24 tickSpacing) internal pure returns (int24) {
629         int24 compressed = tick / tickSpacing;
630         if (tick < 0 && tick % tickSpacing != 0) compressed--;
631         return compressed * tickSpacing;
632     }
633 
634     /// @dev Gets ticks with proportion equivalent to desired amount
635     /// @param pool Uniswap V3 pool
636     /// @param amount0Desired The desired amount of token0
637     /// @param amount1Desired The desired amount of token1
638     /// @param baseThreshold The range for upper and lower ticks
639     /// @param tickSpacing The pool tick spacing
640     /// @return tickLower The lower tick of the range
641     /// @return tickUpper The upper tick of the range
642     function getPositionTicks(IUniswapV3Pool pool, uint256 amount0Desired, uint256 amount1Desired, int24 baseThreshold, int24 tickSpacing) internal view returns(int24 tickLower, int24 tickUpper) {
643         Info memory cache = 
644             Info(amount0Desired, amount1Desired, 0, 0, 0, 0, 0);
645         // Get current price and tick from the pool
646         ( uint160 sqrtPriceX96, int24 currentTick, , , , , ) = pool.slot0();
647         //Calc base ticks 
648         (cache.tickLower, cache.tickUpper) = baseTicks(currentTick, baseThreshold, tickSpacing);
649         //Calc amounts of token0 and token1 that can be stored in base range
650         (cache.amount0, cache.amount1) = amountsForTicks(pool, cache.amount0Desired, cache.amount1Desired, cache.tickLower, cache.tickUpper);
651         //Liquidity that can be stored in base range
652         cache.liquidity = liquidityForAmounts(pool, cache.amount0, cache.amount1, cache.tickLower, cache.tickUpper);
653         //Get imbalanced token
654         bool zeroGreaterOne = amountsDirection(cache.amount0Desired, cache.amount1Desired, cache.amount0, cache.amount1);
655         //Calc new tick(upper or lower) for imbalanced token
656         if ( zeroGreaterOne) {
657             uint160 nextSqrtPrice0 = SqrtPriceMath.getNextSqrtPriceFromAmount0RoundingUp(sqrtPriceX96, cache.liquidity, cache.amount0Desired, false);
658             cache.tickUpper = PoolVariables.floor(TickMath.getTickAtSqrtRatio(nextSqrtPrice0), tickSpacing);
659         }
660         else{
661             uint160 nextSqrtPrice1 = SqrtPriceMath.getNextSqrtPriceFromAmount1RoundingDown(sqrtPriceX96, cache.liquidity, cache.amount1Desired, false);
662             cache.tickLower = PoolVariables.floor(TickMath.getTickAtSqrtRatio(nextSqrtPrice1), tickSpacing);
663         }
664         checkRange(cache.tickLower, cache.tickUpper);
665         
666         tickLower = cache.tickLower;
667         tickUpper = cache.tickUpper;
668     }
669 
670     /// @dev Gets amounts of token0 and token1 that can be stored in range of upper and lower ticks
671     /// @param pool Uniswap V3 pool
672     /// @param amount0Desired The desired amount of token0
673     /// @param amount1Desired The desired amount of token1
674     /// @param _tickLower The lower tick of the range
675     /// @param _tickUpper The upper tick of the range
676     /// @return amount0 amounts of token0 that can be stored in range
677     /// @return amount1 amounts of token1 that can be stored in range
678     function amountsForTicks(IUniswapV3Pool pool, uint256 amount0Desired, uint256 amount1Desired, int24 _tickLower, int24 _tickUpper) internal view returns(uint256 amount0, uint256 amount1) {
679         uint128 liquidity = liquidityForAmounts(pool, amount0Desired, amount1Desired, _tickLower, _tickUpper);
680 
681         (amount0, amount1) = amountsForLiquidity(pool, liquidity, _tickLower, _tickUpper);
682     }
683 
684     /// @dev Calc base ticks depending on base threshold and tickspacing
685     function baseTicks(int24 currentTick, int24 baseThreshold, int24 tickSpacing) internal pure returns(int24 tickLower, int24 tickUpper) {
686         
687         int24 tickFloor = floor(currentTick, tickSpacing);
688 
689         tickLower = tickFloor - baseThreshold;
690         tickUpper = tickFloor + baseThreshold;
691     }
692 
693     /// @dev Get imbalanced token
694     /// @param amount0Desired The desired amount of token0
695     /// @param amount1Desired The desired amount of token1
696     /// @param amount0 Amounts of token0 that can be stored in base range
697     /// @param amount1 Amounts of token1 that can be stored in base range
698     /// @return zeroGreaterOne true if token0 is imbalanced. False if token1 is imbalanced
699     function amountsDirection(uint256 amount0Desired, uint256 amount1Desired, uint256 amount0, uint256 amount1) internal pure returns (bool zeroGreaterOne) {
700         zeroGreaterOne =  amount0Desired.sub(amount0).mul(amount1Desired) > amount1Desired.sub(amount1).mul(amount0Desired) ?  true : false;
701     }
702 
703     // Check price has not moved a lot recently. This mitigates price
704     // manipulation during rebalance and also prevents placing orders
705     // when it's too volatile.
706     function checkDeviation(IUniswapV3Pool pool, int24 maxTwapDeviation, uint32 twapDuration) internal view {
707         (, int24 currentTick, , , , , ) = pool.slot0();
708         int24 twap = getTwap(pool, twapDuration);
709         int24 deviation = currentTick > twap ? currentTick - twap : twap - currentTick;
710         require(deviation <= maxTwapDeviation, "PSC");
711     }
712 
713     /// @dev Fetches time-weighted average price in ticks from Uniswap pool for specified duration
714     function getTwap(IUniswapV3Pool pool, uint32 twapDuration) internal view returns (int24) {
715         uint32 _twapDuration = twapDuration;
716         uint32[] memory secondsAgo = new uint32[](2);
717         secondsAgo[0] = _twapDuration;
718         secondsAgo[1] = 0;
719 
720         (int56[] memory tickCumulatives, ) = pool.observe(secondsAgo);
721         return int24((tickCumulatives[1] - tickCumulatives[0]) / _twapDuration);
722     }
723 }
724 
725 /// @title Permissionless pool actions
726 /// @notice Contains pool methods that can be called by anyone
727 interface IUniswapV3PoolActions {
728 
729     /// @notice Adds liquidity for the given recipient/tickLower/tickUpper position
730     /// @dev The caller of this method receives a callback in the form of IUniswapV3MintCallback#uniswapV3MintCallback
731     /// in which they must pay any token0 or token1 owed for the liquidity. The amount of token0/token1 due depends
732     /// on tickLower, tickUpper, the amount of liquidity, and the current price.
733     /// @param recipient The address for which the liquidity will be created
734     /// @param tickLower The lower tick of the position in which to add liquidity
735     /// @param tickUpper The upper tick of the position in which to add liquidity
736     /// @param amount The amount of liquidity to mint
737     /// @param data Any data that should be passed through to the callback
738     /// @return amount0 The amount of token0 that was paid to mint the given amount of liquidity. Matches the value in the callback
739     /// @return amount1 The amount of token1 that was paid to mint the given amount of liquidity. Matches the value in the callback
740     function mint(
741         address recipient,
742         int24 tickLower,
743         int24 tickUpper,
744         uint128 amount,
745         bytes calldata data
746     ) external returns (uint256 amount0, uint256 amount1);
747 
748     /// @notice Collects tokens owed to a position
749     /// @dev Does not recompute fees earned, which must be done either via mint or burn of any amount of liquidity.
750     /// Collect must be called by the position owner. To withdraw only token0 or only token1, amount0Requested or
751     /// amount1Requested may be set to zero. To withdraw all tokens owed, caller may pass any value greater than the
752     /// actual tokens owed, e.g. type(uint128).max. Tokens owed may be from accumulated swap fees or burned liquidity.
753     /// @param recipient The address which should receive the fees collected
754     /// @param tickLower The lower tick of the position for which to collect fees
755     /// @param tickUpper The upper tick of the position for which to collect fees
756     /// @param amount0Requested How much token0 should be withdrawn from the fees owed
757     /// @param amount1Requested How much token1 should be withdrawn from the fees owed
758     /// @return amount0 The amount of fees collected in token0
759     /// @return amount1 The amount of fees collected in token1
760     function collect(
761         address recipient,
762         int24 tickLower,
763         int24 tickUpper,
764         uint128 amount0Requested,
765         uint128 amount1Requested
766     ) external returns (uint128 amount0, uint128 amount1);
767 
768     /// @notice Burn liquidity from the sender and account tokens owed for the liquidity to the position
769     /// @dev Can be used to trigger a recalculation of fees owed to a position by calling with an amount of 0
770     /// @dev Fees must be collected separately via a call to #collect
771     /// @param tickLower The lower tick of the position for which to burn liquidity
772     /// @param tickUpper The upper tick of the position for which to burn liquidity
773     /// @param amount How much liquidity to burn
774     /// @return amount0 The amount of token0 sent to the recipient
775     /// @return amount1 The amount of token1 sent to the recipient
776     function burn(
777         int24 tickLower,
778         int24 tickUpper,
779         uint128 amount
780     ) external returns (uint256 amount0, uint256 amount1);
781 
782     /// @notice Swap token0 for token1, or token1 for token0
783     /// @dev The caller of this method receives a callback in the form of IUniswapV3SwapCallback#uniswapV3SwapCallback
784     /// @param recipient The address to receive the output of the swap
785     /// @param zeroForOne The direction of the swap, true for token0 to token1, false for token1 to token0
786     /// @param amountSpecified The amount of the swap, which implicitly configures the swap as exact input (positive), or exact output (negative)
787     /// @param sqrtPriceLimitX96 The Q64.96 sqrt price limit. If zero for one, the price cannot be less than this
788     /// value after the swap. If one for zero, the price cannot be greater than this value after the swap
789     /// @param data Any data to be passed through to the callback
790     /// @return amount0 The delta of the balance of token0 of the pool, exact when negative, minimum when positive
791     /// @return amount1 The delta of the balance of token1 of the pool, exact when negative, minimum when positive
792     function swap(
793         address recipient,
794         bool zeroForOne,
795         int256 amountSpecified,
796         uint160 sqrtPriceLimitX96,
797         bytes calldata data
798     ) external returns (int256 amount0, int256 amount1);
799 }
800 
801 /// @title Pool state that is not stored
802 /// @notice Contains view functions to provide information about the pool that is computed rather than stored on the
803 /// blockchain. The functions here may have variable gas costs.
804 interface IUniswapV3PoolDerivedState {
805     /// @notice Returns the cumulative tick and liquidity as of each timestamp `secondsAgo` from the current block timestamp
806     /// @dev To get a time weighted average tick or liquidity-in-range, you must call this with two values, one representing
807     /// the beginning of the period and another for the end of the period. E.g., to get the last hour time-weighted average tick,
808     /// you must call it with secondsAgos = [3600, 0].
809     /// @dev The time weighted average tick represents the geometric time weighted average price of the pool, in
810     /// log base sqrt(1.0001) of token1 / token0. The TickMath library can be used to go from a tick value to a ratio.
811     /// @param secondsAgos From how long ago each cumulative tick and liquidity value should be returned
812     /// @return tickCumulatives Cumulative tick values as of each `secondsAgos` from the current block timestamp
813     /// @return secondsPerLiquidityCumulativeX128s Cumulative seconds per liquidity-in-range value as of each `secondsAgos` from the current block
814     /// timestamp
815     function observe(uint32[] calldata secondsAgos)
816         external
817         view
818         returns (int56[] memory tickCumulatives, uint160[] memory secondsPerLiquidityCumulativeX128s);
819 }
820 
821 /// @title Pool state that can change
822 /// @notice These methods compose the pool's state, and can change with any frequency including multiple times
823 /// per transaction
824 interface IUniswapV3PoolState {
825     /// @notice The 0th storage slot in the pool stores many values, and is exposed as a single method to save gas
826     /// when accessed externally.
827     /// @return sqrtPriceX96 The current price of the pool as a sqrt(token1/token0) Q64.96 value
828     /// tick The current tick of the pool, i.e. according to the last tick transition that was run.
829     /// This value may not always be equal to SqrtTickMath.getTickAtSqrtRatio(sqrtPriceX96) if the price is on a tick
830     /// boundary.
831     /// observationIndex The index of the last oracle observation that was written,
832     /// observationCardinality The current maximum number of observations stored in the pool,
833     /// observationCardinalityNext The next maximum number of observations, to be updated when the observation.
834     /// feeProtocol The protocol fee for both tokens of the pool.
835     /// Encoded as two 4 bit values, where the protocol fee of token1 is shifted 4 bits and the protocol fee of token0
836     /// is the lower 4 bits. Used as the denominator of a fraction of the swap fee, e.g. 4 means 1/4th of the swap fee.
837     /// unlocked Whether the pool is currently locked to reentrancy
838     function slot0()
839         external
840         view
841         returns (
842             uint160 sqrtPriceX96,
843             int24 tick,
844             uint16 observationIndex,
845             uint16 observationCardinality,
846             uint16 observationCardinalityNext,
847             uint8 feeProtocol,
848             bool unlocked
849         );
850 
851     /// @notice Returns the information about a position by the position's key
852     /// @param key The position's key is a hash of a preimage composed by the owner, tickLower and tickUpper
853     /// @return _liquidity The amount of liquidity in the position,
854     /// Returns feeGrowthInside0LastX128 fee growth of token0 inside the tick range as of the last mint/burn/poke,
855     /// Returns feeGrowthInside1LastX128 fee growth of token1 inside the tick range as of the last mint/burn/poke,
856     /// Returns tokensOwed0 the computed amount of token0 owed to the position as of the last mint/burn/poke,
857     /// Returns tokensOwed1 the computed amount of token1 owed to the position as of the last mint/burn/poke
858     function positions(bytes32 key)
859         external
860         view
861         returns (
862             uint128 _liquidity,
863             uint256 feeGrowthInside0LastX128,
864             uint256 feeGrowthInside1LastX128,
865             uint128 tokensOwed0,
866             uint128 tokensOwed1
867         );
868 }
869 
870 /// @title Pool state that never changes
871 /// @notice These parameters are fixed for a pool forever, i.e., the methods will always return the same values
872 interface IUniswapV3PoolImmutables {
873 
874     /// @notice The first of the two tokens of the pool, sorted by address
875     /// @return The token contract address
876     function token0() external view returns (address);
877 
878     /// @notice The second of the two tokens of the pool, sorted by address
879     /// @return The token contract address
880     function token1() external view returns (address);
881 
882     /// @notice The pool tick spacing
883     /// @dev Ticks can only be used at multiples of this value, minimum of 1 and always positive
884     /// e.g.: a tickSpacing of 3 means ticks can be initialized every 3rd tick, i.e., ..., -6, -3, 0, 3, 6, ...
885     /// This value is an int24 to avoid casting even though it is always positive.
886     /// @return The tick spacing
887     function tickSpacing() external view returns (int24);
888 }
889 
890 /// @title The interface for a Uniswap V3 Pool
891 /// @notice A Uniswap pool facilitates swapping and automated market making between any two assets that strictly conform
892 /// to the ERC20 specification
893 /// @dev The pool interface is broken up into many smaller pieces
894 interface IUniswapV3Pool is
895     IUniswapV3PoolImmutables,
896     IUniswapV3PoolState,
897     IUniswapV3PoolDerivedState,
898     IUniswapV3PoolActions
899 {
900 
901 }
902 
903 /// @title This library is created to conduct a variety of burn liquidity methods
904 library PoolActions {
905     using PoolVariables for IUniswapV3Pool;
906     using LowGasSafeMath for uint256;
907     using SafeCast for uint256;
908 
909     /**
910      * @notice Withdraws liquidity in share proportion to the Optimizer's totalSupply.
911      * @param pool Uniswap V3 pool
912      * @param tickLower The lower tick of the range
913      * @param tickUpper The upper tick of the range
914      * @param totalSupply The amount of total shares in existence
915      * @param share to burn
916      * @param to Recipient of amounts
917      * @return amount0 Amount of token0 withdrawed
918      * @return amount1 Amount of token1 withdrawed
919      */
920     function burnLiquidityShare(
921         IUniswapV3Pool pool,
922         int24 tickLower,
923         int24 tickUpper,
924         uint256 totalSupply,
925         uint256 share,
926         address to
927     ) internal returns (uint256 amount0, uint256 amount1) {
928         require(totalSupply > 0, "TS");
929         uint128 liquidityInPool = pool.positionLiquidity(tickLower, tickUpper);
930         uint256 liquidity = uint256(liquidityInPool).mul(share) / totalSupply;
931 
932         if (liquidity > 0) {
933             (amount0, amount1) = pool.burn(tickLower, tickUpper, liquidity.toUint128());
934 
935             if (amount0 > 0 || amount1 > 0) {
936             // collect liquidity share
937                 (amount0, amount1) = pool.collect(
938                     to,
939                     tickLower,
940                     tickUpper,
941                     amount0.toUint128(),
942                     amount1.toUint128()
943                 );
944             }
945         }
946     }
947 
948     /**
949      * @notice Withdraws all liquidity in a range from Uniswap pool
950      * @param pool Uniswap V3 pool
951      * @param tickLower The lower tick of the range
952      * @param tickUpper The upper tick of the range
953      */
954     function burnAllLiquidity(
955         IUniswapV3Pool pool,
956         int24 tickLower,
957         int24 tickUpper
958     ) internal {
959         
960         // Burn all liquidity in this range
961         uint128 liquidity = pool.positionLiquidity(tickLower, tickUpper);
962         if (liquidity > 0) {
963             pool.burn(tickLower, tickUpper, liquidity);
964         }
965         
966          // Collect all owed tokens
967         pool.collect(
968             address(this),
969             tickLower,
970             tickUpper,
971             type(uint128).max,
972             type(uint128).max
973         );
974     }
975 }
976 
977 /**
978  * @title Counters
979  * @author Matt Condon (@shrugs)
980  * @dev Provides counters that can only be incremented or decremented by one. This can be used e.g. to track the number
981  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
982  *
983  * Include with `using Counters for Counters.Counter;`
984  * Since it is not possible to overflow a 256 bit integer with increments of one, `increment` can skip the {LowGasSafeMAth}
985  * overflow check, thereby saving gas. This does assume however correct usage, in that the underlying `_value` is never
986  * directly accessed.
987  */
988 library Counters {
989     using LowGasSafeMath for uint256;
990 
991     struct Counter {
992         // This variable should never be directly accessed by users of the library: interactions must be restricted to
993         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
994         // this feature: see https://github.com/ethereum/solidity/issues/4637
995         uint256 _value; // default: 0
996     }
997 
998     function current(Counter storage counter) internal view returns (uint256) {
999         return counter._value;
1000     }
1001 
1002     function increment(Counter storage counter) internal {
1003         // The {LowGasSafeMath} overflow check can be skipped here, see the comment at the top
1004         counter._value += 1;
1005     }
1006 }
1007 
1008 /// @title Function for getting the current chain ID
1009 library ChainId {
1010     /// @dev Gets the current chain ID
1011     /// @return chainId The current chain ID
1012     function get() internal pure returns (uint256 chainId) {
1013         assembly {
1014             chainId := chainid()
1015         }
1016     }
1017 }
1018 
1019 /**
1020  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
1021  *
1022  * These functions can be used to verify that a message was signed by the holder
1023  * of the private keys of a given address.
1024  */
1025 library ECDSA {
1026     /**
1027      * @dev Overload of {ECDSA-recover} that receives the `v`,
1028      * `r` and `s` signature fields separately.
1029      */
1030     function recover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal pure returns (address) {
1031         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
1032         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
1033         // the valid range for s in (281): 0 < s < secp256k1n ÷ 2 + 1, and for v in (282): v ∈ {27, 28}. Most
1034         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
1035         //
1036         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
1037         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
1038         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
1039         // these malleable signatures as well.
1040         require(uint256(s) <= 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0, "ISS");
1041         require(v == 27 || v == 28, "ISV");
1042 
1043         // If the signature is valid (and not malleable), return the signer address
1044         address signer = ecrecover(hash, v, r, s);
1045         require(signer != address(0), "IS");
1046 
1047         return signer;
1048     }
1049 
1050     /**
1051      * @dev Returns an Ethereum Signed Typed Data, created from a
1052      * `domainSeparator` and a `structHash`. This produces hash corresponding
1053      * to the one signed with the
1054      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
1055      * JSON-RPC method as part of EIP-712.
1056      *
1057      * See {recover}.
1058      */
1059     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
1060         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
1061     }
1062 }
1063 
1064 /**
1065  * @dev https://eips.ethereum.org/EIPS/eip-712[EIP 712] is a standard for hashing and signing of typed structured data.
1066  *
1067  * The encoding specified in the EIP is very generic, and such a generic implementation in Solidity is not feasible,
1068  * thus this contract does not implement the encoding itself. Protocols need to implement the type-specific encoding
1069  * they need in their contracts using a combination of `abi.encode` and `keccak256`.
1070  *
1071  * This contract implements the EIP 712 domain separator ({_domainSeparatorV4}) that is used as part of the encoding
1072  * scheme, and the final step of the encoding to obtain the message digest that is then signed via ECDSA
1073  * ({_hashTypedDataV4}).
1074  *
1075  * The implementation of the domain separator was designed to be as efficient as possible while still properly updating
1076  * the chain id to protect against replay attacks on an eventual fork of the chain.
1077  *
1078  * NOTE: This contract implements the version of the encoding known as "v4", as implemented by the JSON RPC method
1079  * https://docs.metamask.io/guide/signing-data.html[`eth_signTypedDataV4` in MetaMask].
1080  *
1081  * _Available since v3.4._
1082  */
1083 abstract contract EIP712 {
1084     /* solhint-disable var-name-mixedcase */
1085     // Cache the domain separator as an immutable value, but also store the chain id that it corresponds to, in order to
1086     // invalidate the cached domain separator if the chain id changes.
1087     bytes32 private immutable _CACHED_DOMAIN_SEPARATOR;
1088     uint256 private immutable _CACHED_CHAIN_ID;
1089 
1090     bytes32 private immutable _HASHED_NAME;
1091     bytes32 private immutable _HASHED_VERSION;
1092     bytes32 private immutable _TYPE_HASH;
1093     /* solhint-enable var-name-mixedcase */
1094 
1095     /**
1096      * @dev Initializes the domain separator and parameter caches.
1097      *
1098      * The meaning of `name` and `version` is specified in
1099      * https://eips.ethereum.org/EIPS/eip-712#definition-of-domainseparator[EIP 712]:
1100      *
1101      * - `name`: the user readable name of the signing domain, i.e. the name of the DApp or the protocol.
1102      * - `version`: the current major version of the signing domain.
1103      *
1104      * NOTE: These parameters cannot be changed except through a xref:learn::upgrading-smart-contracts.adoc[smart
1105      * contract upgrade].
1106      */
1107     constructor(string memory name, string memory version) {
1108         bytes32 hashedName = keccak256(bytes(name));
1109         bytes32 hashedVersion = keccak256(bytes(version));
1110         bytes32 typeHash = keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)");
1111         _HASHED_NAME = hashedName;
1112         _HASHED_VERSION = hashedVersion;
1113         _CACHED_CHAIN_ID = ChainId.get();
1114         _CACHED_DOMAIN_SEPARATOR = _buildDomainSeparator(typeHash, hashedName, hashedVersion);
1115         _TYPE_HASH = typeHash;
1116     }
1117 
1118     /**
1119      * @dev Returns the domain separator for the current chain.
1120      */
1121     function _domainSeparatorV4() internal view returns (bytes32) {
1122         if (ChainId.get() == _CACHED_CHAIN_ID) {
1123             return _CACHED_DOMAIN_SEPARATOR;
1124         } else {
1125             return _buildDomainSeparator(_TYPE_HASH, _HASHED_NAME, _HASHED_VERSION);
1126         }
1127     }
1128 
1129     function _buildDomainSeparator(bytes32 typeHash, bytes32 name, bytes32 version) private view returns (bytes32) {
1130         return keccak256(
1131             abi.encode(
1132                 typeHash,
1133                 name,
1134                 version,
1135                 ChainId.get(),
1136                 address(this)
1137             )
1138         );
1139     }
1140 
1141     /**
1142      * @dev Given an already https://eips.ethereum.org/EIPS/eip-712#definition-of-hashstruct[hashed struct], this
1143      * function returns the hash of the fully encoded EIP712 message for this domain.
1144      *
1145      * This hash can be used together with {ECDSA-recover} to obtain the signer of a message. For example:
1146      *
1147      * ```solidity
1148      * bytes32 digest = _hashTypedDataV4(keccak256(abi.encode(
1149      *     keccak256("Mail(address to,string contents)"),
1150      *     mailTo,
1151      *     keccak256(bytes(mailContents))
1152      * )));
1153      * address signer = ECDSA.recover(digest, signature);
1154      * ```
1155      */
1156     function _hashTypedDataV4(bytes32 structHash) internal view virtual returns (bytes32) {
1157         return ECDSA.toTypedDataHash(_domainSeparatorV4(), structHash);
1158     }
1159 }
1160 
1161 /**
1162  * @dev Interface of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
1163  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
1164  *
1165  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
1166  * presenting a message signed by the account. By not relying on `{IERC20-approve}`, the token holder account doesn't
1167  * need to send a transaction, and thus is not required to hold Ether at all.
1168  */
1169 interface IERC20Permit {
1170     /**
1171      * @dev Sets `value` as the allowance of `spender` over `owner`'s tokens,
1172      * given `owner`'s signed approval.
1173      *
1174      * IMPORTANT: The same issues {IERC20-approve} has related to transaction
1175      * ordering also apply here.
1176      *
1177      * Emits an {Approval} event.
1178      *
1179      * Requirements:
1180      *
1181      * - `spender` cannot be the zero address.
1182      * - `deadline` must be a timestamp in the future.
1183      * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
1184      * over the EIP712-formatted function arguments.
1185      * - the signature must use ``owner``'s current nonce (see {nonces}).
1186      *
1187      * For more information on the signature format, see the
1188      * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
1189      * section].
1190      */
1191     function permit(address owner, address spender, uint256 value, uint256 deadline, uint8 v, bytes32 r, bytes32 s) external;
1192 
1193     /**
1194      * @dev Returns the current nonce for `owner`. This value must be
1195      * included whenever a signature is generated for {permit}.
1196      *
1197      * Every successful call to {permit} increases ``owner``'s nonce by one. This
1198      * prevents a signature from being used multiple times.
1199      */
1200     function nonces(address owner) external view returns (uint256);
1201 
1202     /**
1203      * @dev Returns the domain separator used in the encoding of the signature for `permit`, as defined by {EIP712}.
1204      */
1205     // solhint-disable-next-line func-name-mixedcase
1206     function DOMAIN_SEPARATOR() external view returns (bytes32);
1207 }
1208 
1209 /*
1210  * @dev Provides information about the current execution context, including the
1211  * sender of the transaction and its data. While these are generally available
1212  * via msg.sender and msg.data, they should not be accessed in such a direct
1213  * manner, since when dealing with GSN meta-transactions the account sending and
1214  * paying for execution may not be the actual sender (as far as an application
1215  * is concerned).
1216  *
1217  * This contract is only required for intermediate, library-like contracts.
1218  */
1219 abstract contract Context {
1220     function _msgSender() internal view virtual returns (address payable) {
1221         return msg.sender;
1222     }
1223 
1224     function _msgData() internal view virtual returns (bytes memory) {
1225         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
1226         return msg.data;
1227     }
1228 }
1229 
1230 /**
1231  * @dev Implementation of the {IERC20} interface.
1232  *
1233  * This implementation is agnostic to the way tokens are created. This means
1234  * that a supply mechanism has to be added in a derived contract using {_mint}.
1235  * For a generic mechanism see {ERC20PresetMinterPauser}.
1236  *
1237  * TIP: For a detailed writeup see our guide
1238  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
1239  * to implement supply mechanisms].
1240  *
1241  * We have followed general OpenZeppelin guidelines: functions revert instead
1242  * of returning `false` on failure. This behavior is nonetheless conventional
1243  * and does not conflict with the expectations of ERC20 applications.
1244  *
1245  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
1246  * This allows applications to reconstruct the allowance for all accounts just
1247  * by listening to said events. Other implementations of the EIP may not emit
1248  * these events, as it isn't required by the specification.
1249  *
1250  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
1251  * functions have been added to mitigate the well-known issues around setting
1252  * allowances. See {IERC20-approve}.
1253  */
1254 contract ERC20 is Context, IERC20 {
1255     using LowGasSafeMath for uint256;
1256 
1257     mapping (address => uint256) private _balances;
1258 
1259     mapping (address => mapping (address => uint256)) private _allowances;
1260 
1261     uint256 private _totalSupply;
1262 
1263     string private _name;
1264     string private _symbol;
1265     uint8 private _decimals;
1266 
1267     /**
1268      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
1269      * a default value of 18.
1270      *
1271      * To select a different value for {decimals}, use {_setupDecimals}.
1272      *
1273      * All three of these values are immutable: they can only be set once during
1274      * construction.
1275      */
1276     constructor (string memory name_, string memory symbol_) {
1277         _name = name_;
1278         _symbol = symbol_;
1279         _decimals = 18;
1280     }
1281 
1282     /**
1283      * @dev Returns the name of the token.
1284      */
1285     function name() public view virtual returns (string memory) {
1286         return _name;
1287     }
1288 
1289     /**
1290      * @dev Returns the symbol of the token, usually a shorter version of the
1291      * name.
1292      */
1293     function symbol() public view virtual returns (string memory) {
1294         return _symbol;
1295     }
1296 
1297     /**
1298      * @dev Returns the number of decimals used to get its user representation.
1299      * For example, if `decimals` equals `2`, a balance of `505` tokens should
1300      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
1301      *
1302      * Tokens usually opt for a value of 18, imitating the relationship between
1303      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
1304      * called.
1305      *
1306      * NOTE: This information is only used for _display_ purposes: it in
1307      * no way affects any of the arithmetic of the contract, including
1308      * {IERC20-balanceOf} and {IERC20-transfer}.
1309      */
1310     function decimals() public view virtual returns (uint8) {
1311         return _decimals;
1312     }
1313 
1314     /**
1315      * @dev See {IERC20-totalSupply}.
1316      */
1317     function totalSupply() public view virtual override returns (uint256) {
1318         return _totalSupply;
1319     }
1320 
1321     /**
1322      * @dev See {IERC20-balanceOf}.
1323      */
1324     function balanceOf(address account) public view virtual override returns (uint256) {
1325         return _balances[account];
1326     }
1327 
1328     /**
1329      * @dev See {IERC20-transfer}.
1330      *
1331      * Requirements:
1332      *
1333      * - `recipient` cannot be the zero address.
1334      * - the caller must have a balance of at least `amount`.
1335      */
1336     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
1337         _transfer(_msgSender(), recipient, amount);
1338         return true;
1339     }
1340 
1341     /**
1342      * @dev See {IERC20-allowance}.
1343      */
1344     function allowance(address owner, address spender) public view virtual override returns (uint256) {
1345         return _allowances[owner][spender];
1346     }
1347 
1348     /**
1349      * @dev See {IERC20-approve}.
1350      *
1351      * Requirements:
1352      *
1353      * - `spender` cannot be the zero address.
1354      */
1355     function approve(address spender, uint256 amount) public virtual override returns (bool) {
1356         _approve(_msgSender(), spender, amount);
1357         return true;
1358     }
1359 
1360     /**
1361      * @dev See {IERC20-transferFrom}.
1362      *
1363      * Emits an {Approval} event indicating the updated allowance. This is not
1364      * required by the EIP. See the note at the beginning of {ERC20}.
1365      *
1366      * Requirements:
1367      *
1368      * - `sender` and `recipient` cannot be the zero address.
1369      * - `sender` must have a balance of at least `amount`.
1370      * - the caller must have allowance for ``sender``'s tokens of at least
1371      * `amount`.
1372      */
1373     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
1374         _transfer(sender, recipient, amount);
1375         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "TEA"));
1376         return true;
1377     }
1378 
1379     /**
1380      * @dev Atomically increases the allowance granted to `spender` by the caller.
1381      *
1382      * This is an alternative to {approve} that can be used as a mitigation for
1383      * problems described in {IERC20-approve}.
1384      *
1385      * Emits an {Approval} event indicating the updated allowance.
1386      *
1387      * Requirements:
1388      *
1389      * - `spender` cannot be the zero address.
1390      */
1391     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
1392         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
1393         return true;
1394     }
1395 
1396     /**
1397      * @dev Atomically decreases the allowance granted to `spender` by the caller.
1398      *
1399      * This is an alternative to {approve} that can be used as a mitigation for
1400      * problems described in {IERC20-approve}.
1401      *
1402      * Emits an {Approval} event indicating the updated allowance.
1403      *
1404      * Requirements:
1405      *
1406      * - `spender` cannot be the zero address.
1407      * - `spender` must have allowance for the caller of at least
1408      * `subtractedValue`.
1409      */
1410     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1411         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "DEB"));
1412         return true;
1413     }
1414 
1415     /**
1416      * @dev Moves tokens `amount` from `sender` to `recipient`.
1417      *
1418      * This is internal function is equivalent to {transfer}, and can be used to
1419      * e.g. implement automatic token fees, slashing mechanisms, etc.
1420      *
1421      * Emits a {Transfer} event.
1422      *
1423      * Requirements:
1424      *
1425      * - `sender` cannot be the zero address.
1426      * - `recipient` cannot be the zero address.
1427      * - `sender` must have a balance of at least `amount`.
1428      */
1429     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
1430         require(sender != address(0), "FZA");
1431         require(recipient != address(0), "TZA");
1432 
1433         _beforeTokenTransfer(sender, recipient, amount);
1434 
1435         _balances[sender] = _balances[sender].sub(amount, "TEB");
1436         _balances[recipient] = _balances[recipient].add(amount);
1437         emit Transfer(sender, recipient, amount);
1438     }
1439 
1440     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1441      * the total supply.
1442      *
1443      * Emits a {Transfer} event with `from` set to the zero address.
1444      *
1445      * Requirements:
1446      *
1447      * - `to` cannot be the zero address.
1448      */
1449     function _mint(address account, uint256 amount) internal virtual {
1450         require(account != address(0), "MZA");
1451 
1452         _beforeTokenTransfer(address(0), account, amount);
1453 
1454         _totalSupply = _totalSupply.add(amount);
1455         _balances[account] = _balances[account].add(amount);
1456         emit Transfer(address(0), account, amount);
1457     }
1458 
1459     /**
1460      * @dev Destroys `amount` tokens from `account`, reducing the
1461      * total supply.
1462      *
1463      * Emits a {Transfer} event with `to` set to the zero address.
1464      *
1465      * Requirements:
1466      *
1467      * - `account` cannot be the zero address.
1468      * - `account` must have at least `amount` tokens.
1469      */
1470     function _burn(address account, uint256 amount) internal virtual {
1471         require(account != address(0), "BZA");
1472 
1473         _beforeTokenTransfer(account, address(0), amount);
1474 
1475         _balances[account] = _balances[account].sub(amount, "BEB");
1476         _totalSupply = _totalSupply.sub(amount);
1477         emit Transfer(account, address(0), amount);
1478     }
1479 
1480     /**
1481      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
1482      *
1483      * This internal function is equivalent to `approve`, and can be used to
1484      * e.g. set automatic allowances for certain subsystems, etc.
1485      *
1486      * Emits an {Approval} event.
1487      *
1488      * Requirements:
1489      *
1490      * - `owner` cannot be the zero address.
1491      * - `spender` cannot be the zero address.
1492      */
1493     function _approve(address owner, address spender, uint256 amount) internal virtual {
1494         require(owner != address(0), "AFZA");
1495         require(spender != address(0), "ATZA");
1496 
1497         _allowances[owner][spender] = amount;
1498         emit Approval(owner, spender, amount);
1499     }
1500 
1501     /**
1502      * @dev Sets {decimals} to a value other than the default one of 18.
1503      *
1504      * WARNING: This function should only be called from the constructor. Most
1505      * applications that interact with token contracts will not expect
1506      * {decimals} to ever change, and may work incorrectly if it does.
1507      */
1508     function _setupDecimals(uint8 decimals_) internal virtual {
1509         _decimals = decimals_;
1510     }
1511 
1512     /**
1513      * @dev Hook that is called before any transfer of tokens. This includes
1514      * minting and burning.
1515      *
1516      * Calling conditions:
1517      *
1518      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1519      * will be to transferred to `to`.
1520      * - when `from` is zero, `amount` tokens will be minted for `to`.
1521      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1522      * - `from` and `to` are never both zero.
1523      *
1524      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1525      */
1526     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
1527 }
1528 
1529 /**
1530  * @dev Implementation of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
1531  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
1532  *
1533  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
1534  * presenting a message signed by the account. By not relying on `{IERC20-approve}`, the token holder account doesn't
1535  * need to send a transaction, and thus is not required to hold Ether at all.
1536  *
1537  * _Available since v3.4._
1538  */
1539 abstract contract ERC20Permit is ERC20, IERC20Permit, EIP712 {
1540     using Counters for Counters.Counter;
1541 
1542     mapping (address => Counters.Counter) private _nonces;
1543  
1544     //keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
1545     bytes32 private immutable _PERMIT_TYPEHASH = 0x6e71edae12b1b97f4d1f60370fef10105fa2faae0126114a169c64845d6126c9;
1546 
1547     /**
1548      * @dev Initializes the {EIP712} domain separator using the `name` parameter, and setting `version` to `"1"`.
1549      *
1550      * It's a good idea to use the same `name` that is defined as the ERC20 token name.
1551      */
1552     constructor(string memory name) EIP712(name, "1") {
1553     }
1554 
1555     /**
1556      * @dev See {IERC20Permit-permit}.
1557      */
1558     function permit(address owner, address spender, uint256 value, uint256 deadline, uint8 v, bytes32 r, bytes32 s) public virtual override {
1559         // solhint-disable-next-line not-rely-on-time
1560         require(block.timestamp <= deadline, "ED");
1561 
1562         bytes32 structHash = keccak256(
1563             abi.encode(
1564                 _PERMIT_TYPEHASH,
1565                 owner,
1566                 spender,
1567                 value,
1568                 _useNonce(owner),
1569                 deadline
1570             )
1571         );
1572 
1573         bytes32 hash = _hashTypedDataV4(structHash);
1574 
1575         address signer = ECDSA.recover(hash, v, r, s);
1576         require(signer == owner, "IS");
1577 
1578         _approve(owner, spender, value);
1579     }
1580 
1581     /**
1582      * @dev See {IERC20Permit-nonces}.
1583      */
1584     function nonces(address owner) public view virtual override returns (uint256) {
1585         return _nonces[owner].current();
1586     }
1587 
1588     /**
1589      * @dev See {IERC20Permit-DOMAIN_SEPARATOR}.
1590      */
1591     // solhint-disable-next-line func-name-mixedcase
1592     function DOMAIN_SEPARATOR() external view override returns (bytes32) {
1593         return _domainSeparatorV4();
1594     }
1595 
1596     /**
1597      * @dev "Consume a nonce": return the current value and increment.
1598      */
1599     function _useNonce(address owner) internal virtual returns (uint256 current) {
1600         Counters.Counter storage nonce = _nonces[owner];
1601         current = nonce.current();
1602         nonce.increment();
1603     }
1604 }
1605 
1606 /// @title FixedPoint96
1607 /// @notice A library for handling binary fixed point numbers, see https://en.wikipedia.org/wiki/Q_(number_format)
1608 /// @dev Used in SqrtPriceMath.sol
1609 library FixedPoint96 {
1610     uint8 internal constant RESOLUTION = 96;
1611     uint256 internal constant Q96 = 0x1000000000000000000000000;
1612 }
1613 
1614 /// @title Math functions that do not check inputs or outputs
1615 /// @notice Contains methods that perform common math functions but do not do any overflow or underflow checks
1616 library UnsafeMath {
1617     /// @notice Returns ceil(x / y)
1618     /// @dev division by 0 has unspecified behavior, and must be checked externally
1619     /// @param x The dividend
1620     /// @param y The divisor
1621     /// @return z The quotient, ceil(x / y)
1622     function divRoundingUp(uint256 x, uint256 y) internal pure returns (uint256 z) {
1623         assembly {
1624             z := add(div(x, y), gt(mod(x, y), 0))
1625         }
1626     }
1627 
1628     /// @notice Returns floor(x / y)
1629     /// @dev division by 0 has unspecified behavior, and must be checked externally
1630     /// @param x The dividend
1631     /// @param y The divisor
1632     /// @return z The quotient, floor(x / y)
1633     function unsafeDiv(uint256 x, uint256 y) internal pure returns (uint256 z) {
1634         assembly {
1635             z := div(x, y)
1636         }
1637     }
1638 }
1639 
1640 /// @title Contains 512-bit math functions
1641 /// @notice Facilitates multiplication and division that can have overflow of an intermediate value without any loss of precision
1642 /// @dev Handles "phantom overflow" i.e., allows multiplication and division where an intermediate value overflows 256 bits
1643 library FullMath {
1644     /// @notice Calculates floor(a×b÷denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
1645     /// @param a The multiplicand
1646     /// @param b The multiplier
1647     /// @param denominator The divisor
1648     /// @return result The 256-bit result
1649     /// @dev Credit to Remco Bloemen under MIT license https://xn--2-umb.com/21/muldiv
1650     function mulDiv(
1651         uint256 a,
1652         uint256 b,
1653         uint256 denominator
1654     ) internal pure returns (uint256 result) {
1655         // 512-bit multiply [prod1 prod0] = a * b
1656         // Compute the product mod 2**256 and mod 2**256 - 1
1657         // then use the Chinese Remainder Theorem to reconstruct
1658         // the 512 bit result. The result is stored in two 256
1659         // variables such that product = prod1 * 2**256 + prod0
1660         uint256 prod0; // Least significant 256 bits of the product
1661         uint256 prod1; // Most significant 256 bits of the product
1662         assembly {
1663             let mm := mulmod(a, b, not(0))
1664             prod0 := mul(a, b)
1665             prod1 := sub(sub(mm, prod0), lt(mm, prod0))
1666         }
1667 
1668         // Handle non-overflow cases, 256 by 256 division
1669         if (prod1 == 0) {
1670             require(denominator > 0);
1671             assembly {
1672                 result := div(prod0, denominator)
1673             }
1674             return result;
1675         }
1676 
1677         // Make sure the result is less than 2**256.
1678         // Also prevents denominator == 0
1679         require(denominator > prod1);
1680 
1681         ///////////////////////////////////////////////
1682         // 512 by 256 division.
1683         ///////////////////////////////////////////////
1684 
1685         // Make division exact by subtracting the remainder from [prod1 prod0]
1686         // Compute remainder using mulmod
1687         uint256 remainder;
1688         assembly {
1689             remainder := mulmod(a, b, denominator)
1690         }
1691         // Subtract 256 bit number from 512 bit number
1692         assembly {
1693             prod1 := sub(prod1, gt(remainder, prod0))
1694             prod0 := sub(prod0, remainder)
1695         }
1696 
1697         // Factor powers of two out of denominator
1698         // Compute largest power of two divisor of denominator.
1699         // Always >= 1.
1700         uint256 twos = -denominator & denominator;
1701         // Divide denominator by power of two
1702         assembly {
1703             denominator := div(denominator, twos)
1704         }
1705 
1706         // Divide [prod1 prod0] by the factors of two
1707         assembly {
1708             prod0 := div(prod0, twos)
1709         }
1710         // Shift in bits from prod1 into prod0. For this we need
1711         // to flip `twos` such that it is 2**256 / twos.
1712         // If twos is zero, then it becomes one
1713         assembly {
1714             twos := add(div(sub(0, twos), twos), 1)
1715         }
1716         prod0 |= prod1 * twos;
1717 
1718         // Invert denominator mod 2**256
1719         // Now that denominator is an odd number, it has an inverse
1720         // modulo 2**256 such that denominator * inv = 1 mod 2**256.
1721         // Compute the inverse by starting with a seed that is correct
1722         // correct for four bits. That is, denominator * inv = 1 mod 2**4
1723         uint256 inv = (3 * denominator) ^ 2;
1724         // Now use Newton-Raphson iteration to improve the precision.
1725         // Thanks to Hensel's lifting lemma, this also works in modular
1726         // arithmetic, doubling the correct bits in each step.
1727         inv *= 2 - denominator * inv; // inverse mod 2**8
1728         inv *= 2 - denominator * inv; // inverse mod 2**16
1729         inv *= 2 - denominator * inv; // inverse mod 2**32
1730         inv *= 2 - denominator * inv; // inverse mod 2**64
1731         inv *= 2 - denominator * inv; // inverse mod 2**128
1732         inv *= 2 - denominator * inv; // inverse mod 2**256
1733 
1734         // Because the division is now exact we can divide by multiplying
1735         // with the modular inverse of denominator. This will give us the
1736         // correct result modulo 2**256. Since the precoditions guarantee
1737         // that the outcome is less than 2**256, this is the final result.
1738         // We don't need to compute the high bits of the result and prod1
1739         // is no longer required.
1740         result = prod0 * inv;
1741         return result;
1742     }
1743 
1744     /// @notice Calculates ceil(a×b÷denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
1745     /// @param a The multiplicand
1746     /// @param b The multiplier
1747     /// @param denominator The divisor
1748     /// @return result The 256-bit result
1749     function mulDivRoundingUp(
1750         uint256 a,
1751         uint256 b,
1752         uint256 denominator
1753     ) internal pure returns (uint256 result) {
1754         result = mulDiv(a, b, denominator);
1755         if (mulmod(a, b, denominator) > 0) {
1756             require(result < type(uint256).max);
1757             result++;
1758         }
1759     }
1760 }
1761 
1762 /// @title Safe casting methods
1763 /// @notice Contains methods for safely casting between types
1764 library SafeCast {
1765     /// @notice Cast a uint256 to a uint160, revert on overflow
1766     /// @param y The uint256 to be downcasted
1767     /// @return z The downcasted integer, now type uint160
1768     function toUint160(uint256 y) internal pure returns (uint160 z) {
1769         require((z = uint160(y)) == y);
1770     }
1771 
1772     /// @notice Cast a uint256 to a uint128, revert on overflow
1773     /// @param y The uint256 to be downcasted
1774     /// @return z The downcasted integer, now type uint128
1775     function toUint128(uint256 y) internal pure returns (uint128 z) {
1776         require((z = uint128(y)) == y);
1777     }
1778 
1779     /// @notice Cast a int256 to a int128, revert on overflow or underflow
1780     /// @param y The int256 to be downcasted
1781     /// @return z The downcasted integer, now type int128
1782     function toInt128(int256 y) internal pure returns (int128 z) {
1783         require((z = int128(y)) == y);
1784     }
1785 
1786     /// @notice Cast a uint256 to a int256, revert on overflow
1787     /// @param y The uint256 to be casted
1788     /// @return z The casted integer, now type int256
1789     function toInt256(uint256 y) internal pure returns (int256 z) {
1790         require(y < 2**255);
1791         z = int256(y);
1792     }
1793 }
1794 
1795 /// @title Optimized overflow and underflow safe math operations
1796 /// @notice Contains methods for doing math operations that revert on overflow or underflow for minimal gas cost
1797 library LowGasSafeMath {
1798     /// @notice Returns x + y, reverts if sum overflows uint256
1799     /// @param x The augend
1800     /// @param y The addend
1801     /// @return z The sum of x and y
1802     function add(uint256 x, uint256 y) internal pure returns (uint256 z) {
1803         require((z = x + y) >= x);
1804     }
1805 
1806     /// @notice Returns x - y, reverts if underflows
1807     /// @param x The minuend
1808     /// @param y The subtrahend
1809     /// @return z The difference of x and y
1810     function sub(uint256 x, uint256 y) internal pure returns (uint256 z) {
1811         require((z = x - y) <= x);
1812     }
1813 
1814     /// @notice Returns x * y, reverts if overflows
1815     /// @param x The multiplicand
1816     /// @param y The multiplier
1817     /// @return z The product of x and y
1818     function mul(uint256 x, uint256 y) internal pure returns (uint256 z) {
1819         require(x == 0 || (z = x * y) / x == y);
1820     }
1821 
1822     /// @notice Returns x - y, reverts if underflows
1823     /// @param x The minuend
1824     /// @param y The subtrahend
1825     /// @return z The difference of x and y
1826     function sub(uint256 x, uint256 y, string memory errorMessage) internal pure returns (uint256 z) {
1827         require((z = x - y) <= x, errorMessage);
1828     }
1829 
1830     /// @notice Returns x + y, reverts if overflows or underflows
1831     /// @param x The augend
1832     /// @param y The addend
1833     /// @return z The sum of x and y
1834     function add(int256 x, int256 y) internal pure returns (int256 z) {
1835         require((z = x + y) >= x == (y >= 0));
1836     }
1837 
1838     /// @notice Returns x - y, reverts if overflows or underflows
1839     /// @param x The minuend
1840     /// @param y The subtrahend
1841     /// @return z The difference of x and y
1842     function sub(int256 x, int256 y) internal pure returns (int256 z) {
1843         require((z = x - y) <= x == (y >= 0));
1844     }
1845 
1846     /// @notice Returns x + y, reverts if sum overflows uint128
1847     /// @param x The augend
1848     /// @param y The addend
1849     /// @return z The sum of x and y
1850     function add128(uint128 x, uint128 y) internal pure returns (uint128 z) {
1851         require((z = x + y) >= x);
1852     }
1853 
1854     /// @notice Returns x - y, reverts if underflows
1855     /// @param x The minuend
1856     /// @param y The subtrahend
1857     /// @return z The difference of x and y
1858     function sub128(uint128 x, uint128 y) internal pure returns (uint128 z) {
1859         require((z = x - y) <= x);
1860     }
1861 
1862     /// @notice Returns x * y, reverts if overflows
1863     /// @param x The multiplicand
1864     /// @param y The multiplier
1865     /// @return z The product of x and y
1866     function mul128(uint128 x, uint128 y) internal pure returns (uint128 z) {
1867         require(x == 0 || (z = x * y) / x == y);
1868     }
1869 
1870     /// @notice Returns x + y, reverts if sum overflows uint128
1871     /// @param x The augend
1872     /// @param y The addend
1873     /// @return z The sum of x and y
1874     function add160(uint160 x, uint160 y) internal pure returns (uint160 z) {
1875         require((z = x + y) >= x);
1876     }
1877 
1878     /// @notice Returns x - y, reverts if underflows
1879     /// @param x The minuend
1880     /// @param y The subtrahend
1881     /// @return z The difference of x and y
1882     function sub160(uint160 x, uint160 y) internal pure returns (uint160 z) {
1883         require((z = x - y) <= x);
1884     }
1885 
1886     /// @notice Returns x * y, reverts if overflows
1887     /// @param x The multiplicand
1888     /// @param y The multiplier
1889     /// @return z The product of x and y
1890     function mul160(uint160 x, uint160 y) internal pure returns (uint160 z) {
1891         require(x == 0 || (z = x * y) / x == y);
1892     }
1893 }
1894 
1895 /// @title Functions based on Q64.96 sqrt price and liquidity
1896 /// @notice Contains the math that uses square root of price as a Q64.96 and liquidity to compute deltas
1897 library SqrtPriceMath {
1898     using LowGasSafeMath for uint256;
1899     using SafeCast for uint256;
1900 
1901     /// @notice Gets the next sqrt price given a delta of token0
1902     /// @dev Always rounds up, because in the exact output case (increasing price) we need to move the price at least
1903     /// far enough to get the desired output amount, and in the exact input case (decreasing price) we need to move the
1904     /// price less in order to not send too much output.
1905     /// The most precise formula for this is liquidity * sqrtPX96 / (liquidity +- amount * sqrtPX96),
1906     /// if this is impossible because of overflow, we calculate liquidity / (liquidity / sqrtPX96 +- amount).
1907     /// @param sqrtPX96 The starting price, i.e. before accounting for the token0 delta
1908     /// @param liquidity The amount of usable liquidity
1909     /// @param amount How much of token0 to add or remove from virtual reserves
1910     /// @param add Whether to add or remove the amount of token0
1911     /// @return The price after adding or removing amount, depending on add
1912     function getNextSqrtPriceFromAmount0RoundingUp(
1913         uint160 sqrtPX96,
1914         uint128 liquidity,
1915         uint256 amount,
1916         bool add
1917     ) internal pure returns (uint160) {
1918         // we short circuit amount == 0 because the result is otherwise not guaranteed to equal the input price
1919         if (amount == 0) return sqrtPX96;
1920         uint256 numerator1 = uint256(liquidity) << FixedPoint96.RESOLUTION;
1921 
1922         if (add) {
1923             uint256 product;
1924             if ((product = amount * sqrtPX96) / amount == sqrtPX96) {
1925                 uint256 denominator = numerator1 + product;
1926                 if (denominator >= numerator1)
1927                     // always fits in 160 bits
1928                     return uint160(FullMath.mulDivRoundingUp(numerator1, sqrtPX96, denominator));
1929             }
1930 
1931             return uint160(UnsafeMath.divRoundingUp(numerator1, (numerator1 / sqrtPX96).add(amount)));
1932         } else {
1933             uint256 product;
1934             // if the product overflows, we know the denominator underflows
1935             // in addition, we must check that the denominator does not underflow
1936             require((product = amount * sqrtPX96) / amount == sqrtPX96 && numerator1 > product);
1937             uint256 denominator = numerator1 - product;
1938             return FullMath.mulDivRoundingUp(numerator1, sqrtPX96, denominator).toUint160();
1939         }
1940     }
1941 
1942     /// @notice Gets the next sqrt price given a delta of token1
1943     /// @dev Always rounds down, because in the exact output case (decreasing price) we need to move the price at least
1944     /// far enough to get the desired output amount, and in the exact input case (increasing price) we need to move the
1945     /// price less in order to not send too much output.
1946     /// The formula we compute is within <1 wei of the lossless version: sqrtPX96 +- amount / liquidity
1947     /// @param sqrtPX96 The starting price, i.e., before accounting for the token1 delta
1948     /// @param liquidity The amount of usable liquidity
1949     /// @param amount How much of token1 to add, or remove, from virtual reserves
1950     /// @param add Whether to add, or remove, the amount of token1
1951     /// @return The price after adding or removing `amount`
1952     function getNextSqrtPriceFromAmount1RoundingDown(
1953         uint160 sqrtPX96,
1954         uint128 liquidity,
1955         uint256 amount,
1956         bool add
1957     ) internal pure returns (uint160) {
1958         // if we're adding (subtracting), rounding down requires rounding the quotient down (up)
1959         // in both cases, avoid a mulDiv for most inputs
1960         if (add) {
1961             uint256 quotient =
1962                 (
1963                     amount <= type(uint160).max
1964                         ? (amount << FixedPoint96.RESOLUTION) / liquidity
1965                         : FullMath.mulDiv(amount, FixedPoint96.Q96, liquidity)
1966                 );
1967 
1968             return uint256(sqrtPX96).add(quotient).toUint160();
1969         } else {
1970             uint256 quotient =
1971                 (
1972                     amount <= type(uint160).max
1973                         ? UnsafeMath.divRoundingUp(amount << FixedPoint96.RESOLUTION, liquidity)
1974                         : FullMath.mulDivRoundingUp(amount, FixedPoint96.Q96, liquidity)
1975                 );
1976 
1977             require(sqrtPX96 > quotient);
1978             // always fits 160 bits
1979             return uint160(sqrtPX96 - quotient);
1980         }
1981     }
1982 }
1983 
1984 
1985 library TransferHelper {
1986     /// @notice Transfers tokens from the targeted address to the given destination
1987     /// @notice Errors with 'STF' if transfer fails
1988     /// @param token The contract address of the token to be transferred
1989     /// @param from The originating address from which the tokens will be transferred
1990     /// @param to The destination address of the transfer
1991     /// @param value The amount to be transferred
1992     function safeTransferFrom(
1993         address token,
1994         address from,
1995         address to,
1996         uint256 value
1997     ) internal {
1998         (bool success, bytes memory data) =
1999             token.call(abi.encodeWithSelector(IERC20.transferFrom.selector, from, to, value));
2000         require(success && (data.length == 0 || abi.decode(data, (bool))), 'STF');
2001     }
2002 
2003     /// @notice Transfers tokens from msg.sender to a recipient
2004     /// @dev Errors with ST if transfer fails
2005     /// @param token The contract address of the token which will be transferred
2006     /// @param to The recipient of the transfer
2007     /// @param value The value of the transfer
2008     function safeTransfer(
2009         address token,
2010         address to,
2011         uint256 value
2012     ) internal {
2013         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(IERC20.transfer.selector, to, value));
2014         require(success && (data.length == 0 || abi.decode(data, (bool))), 'ST');
2015     }
2016 }
2017 
2018 /**
2019  * @dev Contract module that helps prevent reentrant calls to a function.
2020  *
2021  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
2022  * available, which can be applied to functions to make sure there are no nested
2023  * (reentrant) calls to them.
2024  *
2025  * Note that because there is a single `nonReentrant` guard, functions marked as
2026  * `nonReentrant` may not call one another. This can be worked around by making
2027  * those functions `private`, and then adding `external` `nonReentrant` entry
2028  * points to them.
2029  *
2030  * TIP: If you would like to learn more about reentrancy and alternative ways
2031  * to protect against it, check out our blog post
2032  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
2033  */
2034 abstract contract ReentrancyGuard {
2035     // Booleans are more expensive than uint256 or any type that takes up a full
2036     // word because each write operation emits an extra SLOAD to first read the
2037     // slot's contents, replace the bits taken up by the boolean, and then write
2038     // back. This is the compiler's defense against contract upgrades and
2039     // pointer aliasing, and it cannot be disabled.
2040 
2041     // The values being non-zero value makes deployment a bit more expensive,
2042     // but in exchange the refund on every call to nonReentrant will be lower in
2043     // amount. Since refunds are capped to a percentage of the total
2044     // transaction's gas, it is best to keep them low in cases like this one, to
2045     // increase the likelihood of the full refund coming into effect.
2046     uint256 private constant _NOT_ENTERED = 1;
2047     uint256 private constant _ENTERED = 2;
2048 
2049     uint256 private _status;
2050 
2051     constructor () {
2052         _status = _NOT_ENTERED;
2053     }
2054 
2055     /**
2056      * @dev Prevents a contract from calling itself, directly or indirectly.
2057      * Calling a `nonReentrant` function from another `nonReentrant`
2058      * function is not supported. It is possible to prevent this from happening
2059      * by making the `nonReentrant` function external, and make it call a
2060      * `private` function that does the actual work.
2061      */
2062     modifier nonReentrant() {
2063         // On the first call to nonReentrant, _notEntered will be true
2064         require(_status != _ENTERED, "RC");
2065 
2066         // Any calls to nonReentrant after this point will fail
2067         _status = _ENTERED;
2068 
2069         _;
2070 
2071         // By storing the original value once again, a refund is triggered (see
2072         // https://eips.ethereum.org/EIPS/eip-2200)
2073         _status = _NOT_ENTERED;
2074     }
2075 }
2076 
2077 /// @title PopsicleV3 Optimizer is a yield enchancement v3 contract
2078 /// @dev PopsicleV3 Optimizer is a Uniswap V3 yield enchancement contract which acts as
2079 /// intermediary between the user who wants to provide liquidity to specific pools
2080 /// and earn fees from such actions. The contract ensures that user position is in 
2081 /// range and earns maximum amount of fees available at current liquidity utilization
2082 /// rate. 
2083 contract PopsicleV3Optimizer is ERC20Permit, ReentrancyGuard, IPopsicleV3Optimizer {
2084     using LowGasSafeMath for uint256;
2085     using LowGasSafeMath for uint160;
2086     using LowGasSafeMath for uint128;
2087     using UnsafeMath for uint256;
2088     using SafeCast for uint256;
2089     using PoolVariables for IUniswapV3Pool;
2090     using PoolActions for IUniswapV3Pool;
2091     
2092     //Any data passed through by the caller via the IUniswapV3PoolActions#mint call
2093     struct MintCallbackData {
2094         address payer;
2095     }
2096     //Any data passed through by the caller via the IUniswapV3PoolActions#swap call
2097     struct SwapCallbackData {
2098         bool zeroForOne;
2099     }
2100 
2101     /// @notice Emitted when user adds liquidity
2102     /// @param sender The address that minted the liquidity
2103     /// @param recipient The address that get shares
2104     /// @param share The amount of share of liquidity added by the user to position
2105     /// @param amount0 How much token0 was required for the added liquidity
2106     /// @param amount1 How much token1 was required for the added liquidity
2107     event Deposit(
2108         address indexed sender,
2109         address indexed recipient,
2110         uint256 share,
2111         uint256 amount0,
2112         uint256 amount1
2113     );
2114     
2115     /// @notice Emitted when user withdraws liquidity
2116     /// @param sender The address that minted the liquidity
2117     /// @param recipient The address that get amounts
2118     /// @param shares of liquidity withdrawn by the user from the position
2119     /// @param amount0 How much token0 was required for the added liquidity
2120     /// @param amount1 How much token1 was required for the added liquidity
2121     event Withdraw(
2122         address indexed sender,
2123         address indexed recipient,
2124         uint256 shares,
2125         uint256 amount0,
2126         uint256 amount1
2127     );
2128     
2129     /// @notice Emitted when fees was collected from the pool
2130     /// @param feesFromPool0 Total amount of fees collected in terms of token 0
2131     /// @param feesFromPool1 Total amount of fees collected in terms of token 1
2132     /// @param usersFees0 Total amount of fees collected by users in terms of token 0
2133     /// @param usersFees1 Total amount of fees collected by users in terms of token 1
2134     event CollectFees(
2135         uint256 feesFromPool0,
2136         uint256 feesFromPool1,
2137         uint256 usersFees0,
2138         uint256 usersFees1
2139     );
2140 
2141     /// @notice Emitted when fees was compuonded to the pool
2142     /// @param amount0 Total amount of fees compounded in terms of token 0
2143     /// @param amount1 Total amount of fees compounded in terms of token 1
2144     event CompoundFees(
2145         uint256 amount0,
2146         uint256 amount1
2147     );
2148 
2149     /// @notice Emitted when PopsicleV3 Optimizer changes the position in the pool
2150     /// @param tickLower Lower price tick of the positon
2151     /// @param tickUpper Upper price tick of the position
2152     /// @param amount0 Amount of token 0 deposited to the position
2153     /// @param amount1 Amount of token 1 deposited to the position
2154     event Rerange(
2155         int24 tickLower,
2156         int24 tickUpper,
2157         uint256 amount0,
2158         uint256 amount1
2159     );
2160     
2161     /// @notice Emitted when user collects his fee share
2162     /// @param sender User address
2163     /// @param fees0 Exact amount of fees claimed by the users in terms of token 0 
2164     /// @param fees1 Exact amount of fees claimed by the users in terms of token 1
2165     event RewardPaid(
2166         address indexed sender,
2167         uint256 fees0,
2168         uint256 fees1
2169     );
2170     
2171     /// @notice Shows current Optimizer's balances
2172     /// @param totalAmount0 Current token0 Optimizer's balance
2173     /// @param totalAmount1 Current token1 Optimizer's balance
2174     event Snapshot(uint256 totalAmount0, uint256 totalAmount1);
2175 
2176     event TransferGovernance(address indexed previousGovernance, address indexed newGovernance);
2177     
2178     /// @notice Prevents calls from users
2179     modifier onlyGovernance {
2180         require(msg.sender == governance, "OG");
2181         _;
2182     }
2183 
2184     /// @inheritdoc IPopsicleV3Optimizer
2185     address public immutable override token0;
2186     /// @inheritdoc IPopsicleV3Optimizer
2187     address public immutable override token1;
2188     // @inheritdoc IPopsicleV3Optimizer
2189     int24 public immutable override tickSpacing;
2190     uint24 constant MULTIPLIER = 1e6;
2191     uint24 constant GLOBAL_DIVISIONER = 1e6; // for basis point (0.0001%)
2192     //The protocol's fee in hundredths of a bip, i.e. 1e-6
2193     uint24 constant protocolFee = 2 * 1e5; //20%
2194 
2195     mapping (address => bool) private _operatorApproved;
2196 
2197     // @inheritdoc IPopsicleV3Optimizer
2198     IUniswapV3Pool public override pool;
2199     // Accrued protocol fees in terms of token0
2200     uint256 public protocolFees0;
2201     // Accrued protocol fees in terms of token1
2202     uint256 public protocolFees1;
2203     // Total lifetime accrued fees in terms of token0
2204     uint256 public totalFees0;
2205     // Total lifetime accrued fees in terms of token1
2206     uint256 public totalFees1;
2207     
2208     // Address of the Optimizer's owner
2209     address public governance;
2210     // Pending to claim ownership address
2211     address public pendingGovernance;
2212     //PopsicleV3 Optimizer settings address
2213     address public strategy;
2214     // Current tick lower of Optimizer pool position
2215     int24 public override tickLower;
2216     // Current tick higher of Optimizer pool position
2217     int24 public override tickUpper;
2218     // Checks if Optimizer is initialized
2219     bool public initialized;
2220 
2221     bool private _paused = false;
2222     
2223     /**
2224      * @dev After deploying, strategy can be set via `setStrategy()`
2225      * @param _pool Underlying Uniswap V3 pool with fee = 3000
2226      * @param _strategy Underlying Optimizer Strategy for Optimizer settings
2227      */
2228      constructor(
2229         address _pool,
2230         address _strategy
2231     ) ERC20("Popsicle LP V3 AXS/WETH", "PLP") ERC20Permit("Popsicle LP V3 AXS/WETH") {
2232         pool = IUniswapV3Pool(_pool);
2233         strategy = _strategy;
2234         token0 = pool.token0();
2235         token1 = pool.token1();
2236         tickSpacing = pool.tickSpacing();
2237         governance = msg.sender;
2238         _operatorApproved[msg.sender] = true;
2239     }
2240     //initialize strategy
2241     function init() external onlyGovernance {
2242         require(!initialized, "F");
2243         initialized = true;
2244         int24 baseThreshold = tickSpacing * IOptimizerStrategy(strategy).tickRangeMultiplier();
2245         ( , int24 currentTick, , , , , ) = pool.slot0();
2246         int24 tickFloor = PoolVariables.floor(currentTick, tickSpacing);
2247         
2248         tickLower = tickFloor - baseThreshold;
2249         tickUpper = tickFloor + baseThreshold;
2250         PoolVariables.checkRange(tickLower, tickUpper); //check ticks also for overflow/underflow
2251     }
2252     
2253     /// @inheritdoc IPopsicleV3Optimizer
2254      function deposit(
2255         uint256 amount0Desired,
2256         uint256 amount1Desired,
2257         address to
2258     )
2259         external
2260         override
2261         nonReentrant
2262         checkDeviation
2263         whenNotPaused
2264         returns (
2265             uint256 shares,
2266             uint256 amount0,
2267             uint256 amount1
2268         )
2269     {
2270         _earnFees();
2271         _compoundFees(); // prevent user drains others
2272         uint128 liquidityLast = pool.positionLiquidity(tickLower, tickUpper);
2273         
2274         // compute the liquidity amount
2275         uint128 liquidity = pool.liquidityForAmounts(amount0Desired, amount1Desired, tickLower, tickUpper);
2276         
2277         (amount0, amount1) = pool.mint(
2278             address(this),
2279             tickLower,
2280             tickUpper,
2281             liquidity,
2282             abi.encode(MintCallbackData({payer: msg.sender})));
2283         
2284         require(amount0 > 0 && amount1 > 0, "ANV");
2285         shares = totalSupply() == 0 ? liquidity*MULTIPLIER : FullMath.mulDiv(liquidity, totalSupply(), liquidityLast);
2286 
2287         _mint(to, shares);
2288         require(IOptimizerStrategy(strategy).maxTotalSupply() >= totalSupply(), "MTS");
2289         emit Deposit(msg.sender, to, shares, amount0, amount1);
2290     }
2291     
2292     /// @inheritdoc IPopsicleV3Optimizer
2293     function withdraw(
2294         uint256 shares,
2295         address to
2296     ) 
2297         external
2298         override
2299         nonReentrant
2300         checkDeviation
2301         whenNotPaused
2302         returns (
2303             uint256 amount0,
2304             uint256 amount1
2305         )
2306     {
2307         require(shares > 0, "S");
2308         require(to != address(0), "WZA");
2309         _earnFees();
2310         _compoundFees();
2311         (amount0, amount1) = pool.burnLiquidityShare(tickLower, tickUpper, totalSupply(), shares,  to);
2312         require(amount0 > 0 || amount1 > 0, "EA");
2313 
2314         // Burn shares
2315         _burn(msg.sender, shares);
2316 
2317         emit Withdraw(msg.sender, to, shares, amount0, amount1);
2318     }
2319     
2320     /// @inheritdoc IPopsicleV3Optimizer
2321     function rerange() external override nonReentrant checkDeviation {
2322         require(_operatorApproved[msg.sender], "ONA");
2323         _earnFees();
2324         //Burn all liquidity from pool to rerange for Optimizer's balances.
2325         pool.burnAllLiquidity(tickLower, tickUpper);
2326         
2327 
2328         // Emit snapshot to record balances
2329         uint256 balance0 = _balance0();
2330         uint256 balance1 = _balance1();
2331         emit Snapshot(balance0, balance1);
2332 
2333         int24 baseThreshold = tickSpacing * IOptimizerStrategy(strategy).tickRangeMultiplier();
2334 
2335         //Get exact ticks depending on Optimizer's balances
2336         (tickLower, tickUpper) = pool.getPositionTicks(balance0, balance1, baseThreshold, tickSpacing);
2337 
2338         //Get Liquidity for Optimizer's balances
2339         uint128 liquidity = pool.liquidityForAmounts(balance0, balance1, tickLower, tickUpper);
2340         
2341         // Add liquidity to the pool
2342         (uint256 amount0, uint256 amount1) = pool.mint(
2343             address(this),
2344             tickLower,
2345             tickUpper,
2346             liquidity,
2347             abi.encode(MintCallbackData({payer: address(this)})));
2348 
2349         emit Rerange(tickLower, tickUpper, amount0, amount1);
2350     }
2351 
2352     /// @inheritdoc IPopsicleV3Optimizer
2353     function rebalance() external override nonReentrant checkDeviation {
2354         require(_operatorApproved[msg.sender], "ONA");
2355         _earnFees();
2356         //Burn all liquidity from pool to rerange for Optimizer's balances.
2357         pool.burnAllLiquidity(tickLower, tickUpper);
2358         
2359         //Calc base ticks
2360         (uint160 sqrtPriceX96, int24 currentTick, , , , , ) = pool.slot0();
2361         PoolVariables.Info memory cache;
2362         int24 baseThreshold = tickSpacing * IOptimizerStrategy(strategy).tickRangeMultiplier();
2363         (cache.tickLower, cache.tickUpper) = PoolVariables.baseTicks(currentTick, baseThreshold, tickSpacing);
2364         
2365         cache.amount0Desired = _balance0();
2366         cache.amount1Desired = _balance1();
2367         emit Snapshot(cache.amount0Desired, cache.amount1Desired);
2368         // Calc liquidity for base ticks
2369         cache.liquidity = pool.liquidityForAmounts(cache.amount0Desired, cache.amount1Desired, cache.tickLower, cache.tickUpper);
2370 
2371         // Get exact amounts for base ticks
2372         (cache.amount0, cache.amount1) = pool.amountsForLiquidity(cache.liquidity, cache.tickLower, cache.tickUpper);
2373 
2374         // Get imbalanced token
2375         bool zeroForOne = PoolVariables.amountsDirection(cache.amount0Desired, cache.amount1Desired, cache.amount0, cache.amount1);
2376         // Calculate the amount of imbalanced token that should be swapped. Calculations strive to achieve one to one ratio
2377         int256 amountSpecified = 
2378             zeroForOne
2379                 ? int256(cache.amount0Desired.sub(cache.amount0).unsafeDiv(2))
2380                 : int256(cache.amount1Desired.sub(cache.amount1).unsafeDiv(2)); // always positive. "overflow" safe convertion cuz we are dividing by 2
2381 
2382         // Calculate Price limit depending on price impact
2383         uint160 exactSqrtPriceImpact = sqrtPriceX96.mul160(IOptimizerStrategy(strategy).priceImpactPercentage() / 2) / GLOBAL_DIVISIONER;
2384         uint160 sqrtPriceLimitX96 = zeroForOne ?  sqrtPriceX96.sub160(exactSqrtPriceImpact) : sqrtPriceX96.add160(exactSqrtPriceImpact);
2385 
2386         //Swap imbalanced token as long as we haven't used the entire amountSpecified and haven't reached the price limit
2387         pool.swap(
2388             address(this),
2389             zeroForOne,
2390             amountSpecified,
2391             sqrtPriceLimitX96,
2392             abi.encode(SwapCallbackData({zeroForOne: zeroForOne}))
2393         );
2394 
2395 
2396         (sqrtPriceX96, currentTick, , , , , ) = pool.slot0();
2397 
2398         // Emit snapshot to record balances
2399         cache.amount0Desired = _balance0();
2400         cache.amount1Desired = _balance1();
2401         emit Snapshot(cache.amount0Desired, cache.amount1Desired);
2402         //Get exact ticks depending on Optimizer's new balances
2403         (tickLower, tickUpper) = pool.getPositionTicks(cache.amount0Desired, cache.amount1Desired, baseThreshold, tickSpacing);
2404 
2405         cache.liquidity = pool.liquidityForAmounts(cache.amount0Desired, cache.amount1Desired, tickLower, tickUpper);
2406 
2407         // Add liquidity to the pool
2408         (cache.amount0, cache.amount1) = pool.mint(
2409             address(this),
2410             tickLower,
2411             tickUpper,
2412             cache.liquidity,
2413             abi.encode(MintCallbackData({payer: address(this)})));
2414 
2415         emit Rerange(tickLower, tickUpper, cache.amount0, cache.amount1);
2416     }
2417     
2418     /// @dev Amount of token0 held as unused balance.
2419     function _balance0() internal view returns (uint256) {
2420         return IERC20(token0).balanceOf(address(this)).sub(protocolFees0);
2421     }
2422 
2423     /// @dev Amount of token1 held as unused balance.
2424     function _balance1() internal view returns (uint256) {
2425         return IERC20(token1).balanceOf(address(this)).sub(protocolFees1);
2426     }
2427     
2428     /// @dev collects fees from the pool
2429     function _earnFees() internal {
2430         uint liquidity = pool.positionLiquidity(tickLower, tickUpper);
2431         if (liquidity == 0) return; // we can't poke when liquidity is zero
2432          // Do zero-burns to poke the Uniswap pools so earned fees are updated
2433         pool.burn(tickLower, tickUpper, 0);
2434         
2435         (uint256 collect0, uint256 collect1) =
2436             pool.collect(
2437                 address(this),
2438                 tickLower,
2439                 tickUpper,
2440                 type(uint128).max,
2441                 type(uint128).max
2442             );
2443 
2444         // Calculate protocol's fees
2445         uint256 earnedProtocolFees0 = collect0.mul(protocolFee).unsafeDiv(GLOBAL_DIVISIONER);
2446         uint256 earnedProtocolFees1 = collect1.mul(protocolFee).unsafeDiv(GLOBAL_DIVISIONER);
2447         protocolFees0 = protocolFees0.add(earnedProtocolFees0);
2448         protocolFees1 = protocolFees1.add(earnedProtocolFees1);
2449         totalFees0 = totalFees0.add(collect0);
2450         totalFees1 = totalFees1.add(collect1);
2451         emit CollectFees(collect0, collect1, totalFees0, totalFees1);
2452     }
2453 
2454     function _compoundFees() internal returns (uint256 amount0, uint256 amount1){
2455         uint256 balance0 = _balance0();
2456         uint256 balance1 = _balance1();
2457 
2458         emit Snapshot(balance0, balance1);
2459 
2460         //Get Liquidity for Optimizer's balances
2461         uint128 liquidity = pool.liquidityForAmounts(balance0, balance1, tickLower, tickUpper);
2462         
2463         // Add liquidity to the pool
2464         if (liquidity > 0)
2465         {
2466             (amount0, amount1) = pool.mint(
2467                 address(this),
2468                 tickLower,
2469                 tickUpper,
2470                 liquidity,
2471                 abi.encode(MintCallbackData({payer: address(this)})));
2472             emit CompoundFees(amount0, amount1);
2473         }
2474     }
2475 
2476     /// @notice Returns current Optimizer's position in pool
2477     function position() external view returns (uint128 liquidity, uint256 feeGrowthInside0LastX128, uint256 feeGrowthInside1LastX128, uint128 tokensOwed0, uint128 tokensOwed1) {
2478         bytes32 positionKey = PositionKey.compute(address(this), tickLower, tickUpper);
2479         (liquidity, feeGrowthInside0LastX128, feeGrowthInside1LastX128, tokensOwed0, tokensOwed1) = pool.positions(positionKey);
2480     }
2481 
2482     /// @notice Returns current Optimizer's users amounts in pool
2483     function usersAmounts() public view returns (uint256 amount0, uint256 amount1) {
2484         (amount0, amount1) = pool.usersAmounts(tickLower, tickUpper);
2485         amount0 = amount0.add(_balance0());
2486         amount1 = amount1.add(_balance1());
2487     }
2488     
2489     /// @notice Pull in tokens from sender. Called to `msg.sender` after minting liquidity to a position from IUniswapV3Pool#mint.
2490     /// @dev In the implementation you must pay to the pool for the minted liquidity.
2491     /// @param amount0 The amount of token0 due to the pool for the minted liquidity
2492     /// @param amount1 The amount of token1 due to the pool for the minted liquidity
2493     /// @param data Any data passed through by the caller via the IUniswapV3PoolActions#mint call
2494     function uniswapV3MintCallback(
2495         uint256 amount0,
2496         uint256 amount1,
2497         bytes calldata data
2498     ) external {
2499         require(msg.sender == address(pool), "FP");
2500         MintCallbackData memory decoded = abi.decode(data, (MintCallbackData));
2501         if (amount0 > 0) pay(token0, decoded.payer, msg.sender, amount0);
2502         if (amount1 > 0) pay(token1, decoded.payer, msg.sender, amount1);
2503     }
2504 
2505     /// @notice Called to `msg.sender` after minting swaping from IUniswapV3Pool#swap.
2506     /// @dev In the implementation you must pay to the pool for swap.
2507     /// @param amount0 The amount of token0 due to the pool for the swap
2508     /// @param amount1 The amount of token1 due to the pool for the swap
2509     /// @param _data Any data passed through by the caller via the IUniswapV3PoolActions#swap call
2510     function uniswapV3SwapCallback(
2511         int256 amount0,
2512         int256 amount1,
2513         bytes calldata _data
2514     ) external {
2515         require(msg.sender == address(pool), "FP");
2516         require(amount0 > 0 || amount1 > 0, "LEZ"); // swaps entirely within 0-liquidity regions are not supported
2517         SwapCallbackData memory data = abi.decode(_data, (SwapCallbackData));
2518         bool zeroForOne = data.zeroForOne;
2519 
2520         if (zeroForOne) pay(token0, address(this), msg.sender, uint256(amount0)); 
2521         else pay(token1, address(this), msg.sender, uint256(amount1));
2522     }
2523 
2524     /// @param token The token to pay
2525     /// @param payer The entity that must pay
2526     /// @param recipient The entity that will receive payment
2527     /// @param value The amount to pay
2528     function pay(
2529         address token,
2530         address payer,
2531         address recipient,
2532         uint256 value
2533     ) internal {
2534         if (payer == address(this)) {
2535             // pay with tokens already in the contract (for the exact input multihop case)
2536             TransferHelper.safeTransfer(token, recipient, value);
2537         } else {
2538             // pull payment
2539             TransferHelper.safeTransferFrom(token, payer, recipient, value);
2540         }
2541     }
2542     
2543     /**
2544      * @notice Used to withdraw accumulated protocol fees.
2545      */
2546     function collectProtocolFees(
2547         uint256 amount0,
2548         uint256 amount1
2549     ) external nonReentrant onlyGovernance {
2550         _earnFees();
2551         require(protocolFees0 >= amount0, "A0F");
2552         require(protocolFees1 >= amount1, "A1F");
2553         uint256 balance0 = IERC20(token0).balanceOf(address(this));
2554         uint256 balance1 = IERC20(token1).balanceOf(address(this));
2555         require(balance0 >= amount0 && balance1 >= amount1);
2556         if (amount0 > 0) pay(token0, address(this), msg.sender, amount0);
2557         if (amount1 > 0) pay(token1, address(this), msg.sender, amount1);
2558         
2559         protocolFees0 = protocolFees0.sub(amount0);
2560         protocolFees1 = protocolFees1.sub(amount1);
2561         _compoundFees();
2562         emit RewardPaid(msg.sender, amount0, amount1);
2563     }
2564 
2565     // Function modifier that checks if price has not moved a lot recently.
2566     // This mitigates price manipulation during rebalance and also prevents placing orders
2567     // when it's too volatile.
2568     modifier checkDeviation() {
2569         pool.checkDeviation(IOptimizerStrategy(strategy).maxTwapDeviation(), IOptimizerStrategy(strategy).twapDuration());
2570         _;
2571     }
2572 
2573     /**
2574      * @notice `setGovernance()` should be called by the existing governance
2575      * address prior to calling this function.
2576      */
2577     function setGovernance(address _governance) external onlyGovernance {
2578         pendingGovernance = _governance;
2579     }
2580 
2581     /**
2582      * @notice Governance address is not updated until the new governance
2583      * address has called `acceptGovernance()` to accept this responsibility.
2584      */
2585     function acceptGovernance() external {
2586         require(msg.sender == pendingGovernance, "PG");
2587         emit TransferGovernance(governance, pendingGovernance);
2588         pendingGovernance = address(0);
2589         governance = msg.sender;
2590     }
2591 
2592     // Sets new strategy contract address for new settings
2593     function setStrategy(address _strategy) external onlyGovernance {
2594         require(_strategy != address(0), "NA");
2595         strategy = _strategy;
2596     }
2597 
2598     function approveOperator(address _operator) external onlyGovernance {
2599         _operatorApproved[_operator] = true;
2600     }
2601     
2602     function disableOperator(address _operator) external onlyGovernance {
2603         _operatorApproved[_operator] = false;
2604     }
2605     
2606     function isOperator(address _operator) external view returns (bool) {
2607         return _operatorApproved[_operator];
2608     }
2609 
2610     /**
2611      * @dev Modifier to make a function callable only when the contract is not paused.
2612      *
2613      * Requirements:
2614      *
2615      * - The contract must not be paused.
2616      */
2617     modifier whenNotPaused() {
2618         require(!_paused, "P");
2619         _;
2620     }
2621 
2622     /**
2623      * @dev Modifier to make a function callable only when the contract is paused.
2624      *
2625      * Requirements:
2626      *
2627      * - The contract must be paused.
2628      */
2629     modifier whenPaused() {
2630         require(_paused, "NP");
2631         _;
2632     }
2633 
2634     /**
2635      * @dev Triggers stopped state.
2636      *
2637      * Requirements:
2638      *
2639      * - The contract must not be paused.
2640      */
2641     function pause() external onlyGovernance whenNotPaused {
2642         _paused = true;
2643     }
2644 
2645     /**
2646      * @dev Returns to normal state.
2647      *
2648      * Requirements:
2649      *
2650      * - The contract must be paused.
2651      */
2652     function unpause() external onlyGovernance whenPaused {
2653         _paused = false;
2654     }
2655 }