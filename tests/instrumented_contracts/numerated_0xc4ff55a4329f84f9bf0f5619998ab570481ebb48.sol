1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.7.0;
4 
5 /**
6  * @dev Interface of the ERC20 standard as defined in the EIP.
7  */
8 interface IERC20 {
9     /**
10      * @dev Returns the amount of tokens in existence.
11      */
12     function totalSupply() external view returns (uint256);
13 
14     /**
15      * @dev Returns the amount of tokens owned by `account`.
16      */
17     function balanceOf(address account) external view returns (uint256);
18 
19     /**
20      * @dev Moves `amount` tokens from the caller's account to `recipient`.
21      *
22      * Returns a boolean value indicating whether the operation succeeded.
23      *
24      * Emits a {Transfer} event.
25      */
26     function transfer(address recipient, uint256 amount) external returns (bool);
27 
28     /**
29      * @dev Returns the remaining number of tokens that `spender` will be
30      * allowed to spend on behalf of `owner` through {transferFrom}. This is
31      * zero by default.
32      *
33      * This value changes when {approve} or {transferFrom} are called.
34      */
35     function allowance(address owner, address spender) external view returns (uint256);
36 
37     /**
38      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
39      *
40      * Returns a boolean value indicating whether the operation succeeded.
41      *
42      * IMPORTANT: Beware that changing an allowance with this method brings the risk
43      * that someone may use both the old and the new allowance by unfortunate
44      * transaction ordering. One possible solution to mitigate this race
45      * condition is to first reduce the spender's allowance to 0 and set the
46      * desired value afterwards:
47      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
48      *
49      * Emits an {Approval} event.
50      */
51     function approve(address spender, uint256 amount) external returns (bool);
52 
53     /**
54      * @dev Moves `amount` tokens from `sender` to `recipient` using the
55      * allowance mechanism. `amount` is then deducted from the caller's
56      * allowance.
57      *
58      * Returns a boolean value indicating whether the operation succeeded.
59      *
60      * Emits a {Transfer} event.
61      */
62     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
63 
64     /**
65      * @dev Emitted when `value` tokens are moved from one account (`from`) to
66      * another (`to`).
67      *
68      * Note that `value` may be zero.
69      */
70     event Transfer(address indexed from, address indexed to, uint256 value);
71 
72     /**
73      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
74      * a call to {approve}. `value` is the new allowance.
75      */
76     event Approval(address indexed owner, address indexed spender, uint256 value);
77 }
78 
79 pragma solidity 0.7.6;
80 
81 
82 interface ISorbettoFragola {
83     /// @notice The first of the two tokens of the pool, sorted by address
84     /// @return The token contract address
85     function token0() external view returns (address);
86 
87     /// @notice The second of the two tokens of the pool, sorted by address
88     /// @return The token contract address
89     function token1() external view returns (address);
90     
91     /// @notice The pool tick spacing
92     /// @dev Ticks can only be used at multiples of this value, minimum of 1 and always positive
93     /// e.g.: a tickSpacing of 3 means ticks can be initialized every 3rd tick, i.e., ..., -6, -3, 0, 3, 6, ...
94     /// This value is an int24 to avoid casting even though it is always positive.
95     /// @return The tick spacing
96     function tickSpacing() external view returns (int24);
97 
98     /// @notice A Uniswap pool facilitates swapping and automated market making between any two assets that strictly conform
99     /// to the ERC20 specification
100     /// @return The address of the Uniswap V3 Pool
101     function pool() external view returns (IUniswapV3Pool);
102 
103     /// @notice The lower tick of the range
104     function tickLower() external view returns (int24);
105 
106     /// @notice The upper tick of the range
107     function tickUpper() external view returns (int24);
108 
109     /**
110      * @notice Deposits tokens in proportion to the Sorbetto's current ticks.
111      * @param amount0Desired Max amount of token0 to deposit
112      * @param amount1Desired Max amount of token1 to deposit
113      * @return shares minted
114      * @return amount0 Amount of token0 deposited
115      * @return amount1 Amount of token1 deposited
116      */
117     function deposit(uint256 amount0Desired, uint256 amount1Desired) external payable returns (uint256 shares, uint256 amount0,uint256 amount1);
118 
119     /**
120      * @notice Withdraws tokens in proportion to the Sorbetto's holdings.
121      * @dev Removes proportional amount of liquidity from Uniswap.
122      * @param shares burned by sender
123      * @return amount0 Amount of token0 sent to recipient
124      * @return amount1 Amount of token1 sent to recipient
125      */
126     function withdraw(uint256 shares) external returns (uint256 amount0, uint256 amount1);
127 
128     /**
129      * @notice Updates sorbetto's positions.
130      * @dev Finds base position and limit position for imbalanced token
131      * mints all amounts to this position(including earned fees)
132      */
133     function rerange() external;
134 
135     /**
136      * @notice Updates sorbetto's positions. Can only be called by the governance.
137      * @dev Swaps imbalanced token. Finds base position and limit position for imbalanced token if
138      * we don't have balance during swap because of price impact.
139      * mints all amounts to this position(including earned fees)
140      */
141     function rebalance() external;
142 }
143 
144 pragma solidity 0.7.6;
145 
146 interface ISorbettoStrategy {
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
157     /// @notice The protocol's fee denominated in hundredths of a bip, i.e. 1e-6
158     /// @return The fee
159     function protocolFee() external view returns (uint24);
160 
161     /// @notice The price impact percentage during swap denominated in hundredths of a bip, i.e. 1e-6
162     /// @return The max price impact percentage
163     function priceImpactPercentage() external view returns (uint24);
164 }
165 
166 pragma solidity >=0.5.0;
167 
168 library PositionKey {
169     /// @dev Returns the key of the position in the core library
170     function compute(
171         address owner,
172         int24 tickLower,
173         int24 tickUpper
174     ) internal pure returns (bytes32) {
175         return keccak256(abi.encodePacked(owner, tickLower, tickUpper));
176     }
177 }
178 
179 pragma solidity >=0.5.0;
180 
181 /// @title Math library for computing sqrt prices from ticks and vice versa
182 /// @notice Computes sqrt price for ticks of size 1.0001, i.e. sqrt(1.0001^tick) as fixed point Q64.96 numbers. Supports
183 /// prices between 2**-128 and 2**128
184 library TickMath {
185     /// @dev The minimum tick that may be passed to #getSqrtRatioAtTick computed from log base 1.0001 of 2**-128
186     int24 internal constant MIN_TICK = -887272;
187     /// @dev The maximum tick that may be passed to #getSqrtRatioAtTick computed from log base 1.0001 of 2**128
188     int24 internal constant MAX_TICK = -MIN_TICK;
189 
190     /// @dev The minimum value that can be returned from #getSqrtRatioAtTick. Equivalent to getSqrtRatioAtTick(MIN_TICK)
191     uint160 internal constant MIN_SQRT_RATIO = 4295128739;
192     /// @dev The maximum value that can be returned from #getSqrtRatioAtTick. Equivalent to getSqrtRatioAtTick(MAX_TICK)
193     uint160 internal constant MAX_SQRT_RATIO = 1461446703485210103287273052203988822378723970342;
194 
195     /// @notice Calculates sqrt(1.0001^tick) * 2^96
196     /// @dev Throws if |tick| > max tick
197     /// @param tick The input tick for the above formula
198     /// @return sqrtPriceX96 A Fixed point Q64.96 number representing the sqrt of the ratio of the two assets (token1/token0)
199     /// at the given tick
200     function getSqrtRatioAtTick(int24 tick) internal pure returns (uint160 sqrtPriceX96) {
201         uint256 absTick = tick < 0 ? uint256(-int256(tick)) : uint256(int256(tick));
202         require(absTick <= uint256(MAX_TICK), 'T');
203 
204         uint256 ratio = absTick & 0x1 != 0 ? 0xfffcb933bd6fad37aa2d162d1a594001 : 0x100000000000000000000000000000000;
205         if (absTick & 0x2 != 0) ratio = (ratio * 0xfff97272373d413259a46990580e213a) >> 128;
206         if (absTick & 0x4 != 0) ratio = (ratio * 0xfff2e50f5f656932ef12357cf3c7fdcc) >> 128;
207         if (absTick & 0x8 != 0) ratio = (ratio * 0xffe5caca7e10e4e61c3624eaa0941cd0) >> 128;
208         if (absTick & 0x10 != 0) ratio = (ratio * 0xffcb9843d60f6159c9db58835c926644) >> 128;
209         if (absTick & 0x20 != 0) ratio = (ratio * 0xff973b41fa98c081472e6896dfb254c0) >> 128;
210         if (absTick & 0x40 != 0) ratio = (ratio * 0xff2ea16466c96a3843ec78b326b52861) >> 128;
211         if (absTick & 0x80 != 0) ratio = (ratio * 0xfe5dee046a99a2a811c461f1969c3053) >> 128;
212         if (absTick & 0x100 != 0) ratio = (ratio * 0xfcbe86c7900a88aedcffc83b479aa3a4) >> 128;
213         if (absTick & 0x200 != 0) ratio = (ratio * 0xf987a7253ac413176f2b074cf7815e54) >> 128;
214         if (absTick & 0x400 != 0) ratio = (ratio * 0xf3392b0822b70005940c7a398e4b70f3) >> 128;
215         if (absTick & 0x800 != 0) ratio = (ratio * 0xe7159475a2c29b7443b29c7fa6e889d9) >> 128;
216         if (absTick & 0x1000 != 0) ratio = (ratio * 0xd097f3bdfd2022b8845ad8f792aa5825) >> 128;
217         if (absTick & 0x2000 != 0) ratio = (ratio * 0xa9f746462d870fdf8a65dc1f90e061e5) >> 128;
218         if (absTick & 0x4000 != 0) ratio = (ratio * 0x70d869a156d2a1b890bb3df62baf32f7) >> 128;
219         if (absTick & 0x8000 != 0) ratio = (ratio * 0x31be135f97d08fd981231505542fcfa6) >> 128;
220         if (absTick & 0x10000 != 0) ratio = (ratio * 0x9aa508b5b7a84e1c677de54f3e99bc9) >> 128;
221         if (absTick & 0x20000 != 0) ratio = (ratio * 0x5d6af8dedb81196699c329225ee604) >> 128;
222         if (absTick & 0x40000 != 0) ratio = (ratio * 0x2216e584f5fa1ea926041bedfe98) >> 128;
223         if (absTick & 0x80000 != 0) ratio = (ratio * 0x48a170391f7dc42444e8fa2) >> 128;
224 
225         if (tick > 0) ratio = type(uint256).max / ratio;
226 
227         // this divides by 1<<32 rounding up to go from a Q128.128 to a Q128.96.
228         // we then downcast because we know the result always fits within 160 bits due to our tick input constraint
229         // we round up in the division so getTickAtSqrtRatio of the output price is always consistent
230         sqrtPriceX96 = uint160((ratio >> 32) + (ratio % (1 << 32) == 0 ? 0 : 1));
231     }
232 
233     /// @notice Calculates the greatest tick value such that getRatioAtTick(tick) <= ratio
234     /// @dev Throws in case sqrtPriceX96 < MIN_SQRT_RATIO, as MIN_SQRT_RATIO is the lowest value getRatioAtTick may
235     /// ever return.
236     /// @param sqrtPriceX96 The sqrt ratio for which to compute the tick as a Q64.96
237     /// @return tick The greatest tick for which the ratio is less than or equal to the input ratio
238     function getTickAtSqrtRatio(uint160 sqrtPriceX96) internal pure returns (int24 tick) {
239         // second inequality must be < because the price can never reach the price at the max tick
240         require(sqrtPriceX96 >= MIN_SQRT_RATIO && sqrtPriceX96 < MAX_SQRT_RATIO, 'R');
241         uint256 ratio = uint256(sqrtPriceX96) << 32;
242 
243         uint256 r = ratio;
244         uint256 msb = 0;
245 
246         assembly {
247             let f := shl(7, gt(r, 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF))
248             msb := or(msb, f)
249             r := shr(f, r)
250         }
251         assembly {
252             let f := shl(6, gt(r, 0xFFFFFFFFFFFFFFFF))
253             msb := or(msb, f)
254             r := shr(f, r)
255         }
256         assembly {
257             let f := shl(5, gt(r, 0xFFFFFFFF))
258             msb := or(msb, f)
259             r := shr(f, r)
260         }
261         assembly {
262             let f := shl(4, gt(r, 0xFFFF))
263             msb := or(msb, f)
264             r := shr(f, r)
265         }
266         assembly {
267             let f := shl(3, gt(r, 0xFF))
268             msb := or(msb, f)
269             r := shr(f, r)
270         }
271         assembly {
272             let f := shl(2, gt(r, 0xF))
273             msb := or(msb, f)
274             r := shr(f, r)
275         }
276         assembly {
277             let f := shl(1, gt(r, 0x3))
278             msb := or(msb, f)
279             r := shr(f, r)
280         }
281         assembly {
282             let f := gt(r, 0x1)
283             msb := or(msb, f)
284         }
285 
286         if (msb >= 128) r = ratio >> (msb - 127);
287         else r = ratio << (127 - msb);
288 
289         int256 log_2 = (int256(msb) - 128) << 64;
290 
291         assembly {
292             r := shr(127, mul(r, r))
293             let f := shr(128, r)
294             log_2 := or(log_2, shl(63, f))
295             r := shr(f, r)
296         }
297         assembly {
298             r := shr(127, mul(r, r))
299             let f := shr(128, r)
300             log_2 := or(log_2, shl(62, f))
301             r := shr(f, r)
302         }
303         assembly {
304             r := shr(127, mul(r, r))
305             let f := shr(128, r)
306             log_2 := or(log_2, shl(61, f))
307             r := shr(f, r)
308         }
309         assembly {
310             r := shr(127, mul(r, r))
311             let f := shr(128, r)
312             log_2 := or(log_2, shl(60, f))
313             r := shr(f, r)
314         }
315         assembly {
316             r := shr(127, mul(r, r))
317             let f := shr(128, r)
318             log_2 := or(log_2, shl(59, f))
319             r := shr(f, r)
320         }
321         assembly {
322             r := shr(127, mul(r, r))
323             let f := shr(128, r)
324             log_2 := or(log_2, shl(58, f))
325             r := shr(f, r)
326         }
327         assembly {
328             r := shr(127, mul(r, r))
329             let f := shr(128, r)
330             log_2 := or(log_2, shl(57, f))
331             r := shr(f, r)
332         }
333         assembly {
334             r := shr(127, mul(r, r))
335             let f := shr(128, r)
336             log_2 := or(log_2, shl(56, f))
337             r := shr(f, r)
338         }
339         assembly {
340             r := shr(127, mul(r, r))
341             let f := shr(128, r)
342             log_2 := or(log_2, shl(55, f))
343             r := shr(f, r)
344         }
345         assembly {
346             r := shr(127, mul(r, r))
347             let f := shr(128, r)
348             log_2 := or(log_2, shl(54, f))
349             r := shr(f, r)
350         }
351         assembly {
352             r := shr(127, mul(r, r))
353             let f := shr(128, r)
354             log_2 := or(log_2, shl(53, f))
355             r := shr(f, r)
356         }
357         assembly {
358             r := shr(127, mul(r, r))
359             let f := shr(128, r)
360             log_2 := or(log_2, shl(52, f))
361             r := shr(f, r)
362         }
363         assembly {
364             r := shr(127, mul(r, r))
365             let f := shr(128, r)
366             log_2 := or(log_2, shl(51, f))
367             r := shr(f, r)
368         }
369         assembly {
370             r := shr(127, mul(r, r))
371             let f := shr(128, r)
372             log_2 := or(log_2, shl(50, f))
373         }
374 
375         int256 log_sqrt10001 = log_2 * 255738958999603826347141; // 128.128 number
376 
377         int24 tickLow = int24((log_sqrt10001 - 3402992956809132418596140100660247210) >> 128);
378         int24 tickHi = int24((log_sqrt10001 + 291339464771989622907027621153398088495) >> 128);
379 
380         tick = tickLow == tickHi ? tickLow : getSqrtRatioAtTick(tickHi) <= sqrtPriceX96 ? tickHi : tickLow;
381     }
382 }
383 
384 pragma solidity >=0.5.0;
385 
386 
387 
388 /// @title Liquidity amount functions
389 /// @notice Provides functions for computing liquidity amounts from token amounts and prices
390 library LiquidityAmounts {
391     /// @notice Downcasts uint256 to uint128
392     /// @param x The uint258 to be downcasted
393     /// @return y The passed value, downcasted to uint128
394     function toUint128(uint256 x) private pure returns (uint128 y) {
395         require((y = uint128(x)) == x);
396     }
397 
398     /// @notice Computes the amount of liquidity received for a given amount of token0 and price range
399     /// @dev Calculates amount0 * (sqrt(upper) * sqrt(lower)) / (sqrt(upper) - sqrt(lower))
400     /// @param sqrtRatioAX96 A sqrt price representing the first tick boundary
401     /// @param sqrtRatioBX96 A sqrt price representing the second tick boundary
402     /// @param amount0 The amount0 being sent in
403     /// @return liquidity The amount of returned liquidity
404     function getLiquidityForAmount0(
405         uint160 sqrtRatioAX96,
406         uint160 sqrtRatioBX96,
407         uint256 amount0
408     ) internal pure returns (uint128 liquidity) {
409         if (sqrtRatioAX96 > sqrtRatioBX96) (sqrtRatioAX96, sqrtRatioBX96) = (sqrtRatioBX96, sqrtRatioAX96);
410         uint256 intermediate = FullMath.mulDiv(sqrtRatioAX96, sqrtRatioBX96, FixedPoint96.Q96);
411         return toUint128(FullMath.mulDiv(amount0, intermediate, sqrtRatioBX96 - sqrtRatioAX96));
412     }
413 
414     /// @notice Computes the amount of liquidity received for a given amount of token1 and price range
415     /// @dev Calculates amount1 / (sqrt(upper) - sqrt(lower)).
416     /// @param sqrtRatioAX96 A sqrt price representing the first tick boundary
417     /// @param sqrtRatioBX96 A sqrt price representing the second tick boundary
418     /// @param amount1 The amount1 being sent in
419     /// @return liquidity The amount of returned liquidity
420     function getLiquidityForAmount1(
421         uint160 sqrtRatioAX96,
422         uint160 sqrtRatioBX96,
423         uint256 amount1
424     ) internal pure returns (uint128 liquidity) {
425         if (sqrtRatioAX96 > sqrtRatioBX96) (sqrtRatioAX96, sqrtRatioBX96) = (sqrtRatioBX96, sqrtRatioAX96);
426         return toUint128(FullMath.mulDiv(amount1, FixedPoint96.Q96, sqrtRatioBX96 - sqrtRatioAX96));
427     }
428 
429     /// @notice Computes the maximum amount of liquidity received for a given amount of token0, token1, the current
430     /// pool prices and the prices at the tick boundaries
431     /// @param sqrtRatioX96 A sqrt price representing the current pool prices
432     /// @param sqrtRatioAX96 A sqrt price representing the first tick boundary
433     /// @param sqrtRatioBX96 A sqrt price representing the second tick boundary
434     /// @param amount0 The amount of token0 being sent in
435     /// @param amount1 The amount of token1 being sent in
436     /// @return liquidity The maximum amount of liquidity received
437     function getLiquidityForAmounts(
438         uint160 sqrtRatioX96,
439         uint160 sqrtRatioAX96,
440         uint160 sqrtRatioBX96,
441         uint256 amount0,
442         uint256 amount1
443     ) internal pure returns (uint128 liquidity) {
444         if (sqrtRatioAX96 > sqrtRatioBX96) (sqrtRatioAX96, sqrtRatioBX96) = (sqrtRatioBX96, sqrtRatioAX96);
445 
446         if (sqrtRatioX96 <= sqrtRatioAX96) {
447             liquidity = getLiquidityForAmount0(sqrtRatioAX96, sqrtRatioBX96, amount0);
448         } else if (sqrtRatioX96 < sqrtRatioBX96) {
449             uint128 liquidity0 = getLiquidityForAmount0(sqrtRatioX96, sqrtRatioBX96, amount0);
450             uint128 liquidity1 = getLiquidityForAmount1(sqrtRatioAX96, sqrtRatioX96, amount1);
451 
452             liquidity = liquidity0 < liquidity1 ? liquidity0 : liquidity1;
453         } else {
454             liquidity = getLiquidityForAmount1(sqrtRatioAX96, sqrtRatioBX96, amount1);
455         }
456     }
457 
458     /// @notice Computes the amount of token0 for a given amount of liquidity and a price range
459     /// @param sqrtRatioAX96 A sqrt price representing the first tick boundary
460     /// @param sqrtRatioBX96 A sqrt price representing the second tick boundary
461     /// @param liquidity The liquidity being valued
462     /// @return amount0 The amount of token0
463     function getAmount0ForLiquidity(
464         uint160 sqrtRatioAX96,
465         uint160 sqrtRatioBX96,
466         uint128 liquidity
467     ) internal pure returns (uint256 amount0) {
468         if (sqrtRatioAX96 > sqrtRatioBX96) (sqrtRatioAX96, sqrtRatioBX96) = (sqrtRatioBX96, sqrtRatioAX96);
469 
470         return
471             FullMath.mulDiv(
472                 uint256(liquidity) << FixedPoint96.RESOLUTION,
473                 sqrtRatioBX96 - sqrtRatioAX96,
474                 sqrtRatioBX96
475             ) / sqrtRatioAX96;
476     }
477 
478     /// @notice Computes the amount of token1 for a given amount of liquidity and a price range
479     /// @param sqrtRatioAX96 A sqrt price representing the first tick boundary
480     /// @param sqrtRatioBX96 A sqrt price representing the second tick boundary
481     /// @param liquidity The liquidity being valued
482     /// @return amount1 The amount of token1
483     function getAmount1ForLiquidity(
484         uint160 sqrtRatioAX96,
485         uint160 sqrtRatioBX96,
486         uint128 liquidity
487     ) internal pure returns (uint256 amount1) {
488         if (sqrtRatioAX96 > sqrtRatioBX96) (sqrtRatioAX96, sqrtRatioBX96) = (sqrtRatioBX96, sqrtRatioAX96);
489 
490         return FullMath.mulDiv(liquidity, sqrtRatioBX96 - sqrtRatioAX96, FixedPoint96.Q96);
491     }
492 
493     /// @notice Computes the token0 and token1 value for a given amount of liquidity, the current
494     /// pool prices and the prices at the tick boundaries
495     /// @param sqrtRatioX96 A sqrt price representing the current pool prices
496     /// @param sqrtRatioAX96 A sqrt price representing the first tick boundary
497     /// @param sqrtRatioBX96 A sqrt price representing the second tick boundary
498     /// @param liquidity The liquidity being valued
499     /// @return amount0 The amount of token0
500     /// @return amount1 The amount of token1
501     function getAmountsForLiquidity(
502         uint160 sqrtRatioX96,
503         uint160 sqrtRatioAX96,
504         uint160 sqrtRatioBX96,
505         uint128 liquidity
506     ) internal pure returns (uint256 amount0, uint256 amount1) {
507         if (sqrtRatioAX96 > sqrtRatioBX96) (sqrtRatioAX96, sqrtRatioBX96) = (sqrtRatioBX96, sqrtRatioAX96);
508 
509         if (sqrtRatioX96 <= sqrtRatioAX96) {
510             amount0 = getAmount0ForLiquidity(sqrtRatioAX96, sqrtRatioBX96, liquidity);
511         } else if (sqrtRatioX96 < sqrtRatioBX96) {
512             amount0 = getAmount0ForLiquidity(sqrtRatioX96, sqrtRatioBX96, liquidity);
513             amount1 = getAmount1ForLiquidity(sqrtRatioAX96, sqrtRatioX96, liquidity);
514         } else {
515             amount1 = getAmount1ForLiquidity(sqrtRatioAX96, sqrtRatioBX96, liquidity);
516         }
517     }
518 }
519 
520 pragma solidity >=0.5.0;
521 
522 
523 
524 
525 
526 
527 /// @title Liquidity and ticks functions
528 /// @notice Provides functions for computing liquidity and ticks for token amounts and prices
529 library PoolVariables {
530     using LowGasSafeMath for uint256;
531 
532     // Cache struct for calculations
533     struct Info {
534         uint256 amount0Desired;
535         uint256 amount1Desired;
536         uint256 amount0;
537         uint256 amount1;
538         uint128 liquidity;
539         int24 tickLower;
540         int24 tickUpper;
541     }
542 
543     /// @dev Wrapper around `LiquidityAmounts.getAmountsForLiquidity()`.
544     /// @param pool Uniswap V3 pool
545     /// @param liquidity  The liquidity being valued
546     /// @param _tickLower The lower tick of the range
547     /// @param _tickUpper The upper tick of the range
548     /// @return amounts of token0 and token1 that corresponds to liquidity
549     function amountsForLiquidity(
550         IUniswapV3Pool pool,
551         uint128 liquidity,
552         int24 _tickLower,
553         int24 _tickUpper
554     ) internal view returns (uint256, uint256) {
555         //Get current price from the pool
556         (uint160 sqrtRatioX96, , , , , , ) = pool.slot0();
557         return
558             LiquidityAmounts.getAmountsForLiquidity(
559                 sqrtRatioX96,
560                 TickMath.getSqrtRatioAtTick(_tickLower),
561                 TickMath.getSqrtRatioAtTick(_tickUpper),
562                 liquidity
563             );
564     }
565 
566     /// @dev Wrapper around `LiquidityAmounts.getLiquidityForAmounts()`.
567     /// @param pool Uniswap V3 pool
568     /// @param amount0 The amount of token0
569     /// @param amount1 The amount of token1
570     /// @param _tickLower The lower tick of the range
571     /// @param _tickUpper The upper tick of the range
572     /// @return The maximum amount of liquidity that can be held amount0 and amount1
573     function liquidityForAmounts(
574         IUniswapV3Pool pool,
575         uint256 amount0,
576         uint256 amount1,
577         int24 _tickLower,
578         int24 _tickUpper
579     ) internal view returns (uint128) {
580         //Get current price from the pool
581         (uint160 sqrtRatioX96, , , , , , ) = pool.slot0();
582 
583         return
584             LiquidityAmounts.getLiquidityForAmounts(
585                 sqrtRatioX96,
586                 TickMath.getSqrtRatioAtTick(_tickLower),
587                 TickMath.getSqrtRatioAtTick(_tickUpper),
588                 amount0,
589                 amount1
590             );
591     }
592 
593     /// @dev Amounts of token0 and token1 held in contract position.
594     /// @param pool Uniswap V3 pool
595     /// @param _tickLower The lower tick of the range
596     /// @param _tickUpper The upper tick of the range
597     /// @return amount0 The amount of token0 held in position
598     /// @return amount1 The amount of token1 held in position
599     function positionAmounts(IUniswapV3Pool pool, int24 _tickLower, int24 _tickUpper)
600         internal
601         view
602         returns (uint256 amount0, uint256 amount1)
603     {   
604         //Compute position key
605         bytes32 positionKey = PositionKey.compute(address(this), _tickLower, _tickUpper);
606         //Get Position.Info for specified ticks
607         (uint128 liquidity, , , uint128 tokensOwed0, uint128 tokensOwed1) =
608             pool.positions(positionKey);
609         // Calc amounts of token0 and token1 including fees
610         (amount0, amount1) = amountsForLiquidity(pool, liquidity, _tickLower, _tickUpper);
611         amount0 = amount0.add(uint256(tokensOwed0));
612         amount1 = amount1.add(uint256(tokensOwed1));
613     }
614 
615     /// @dev Amount of liquidity in contract position.
616     /// @param pool Uniswap V3 pool
617     /// @param _tickLower The lower tick of the range
618     /// @param _tickUpper The upper tick of the range
619     /// @return liquidity stored in position
620     function positionLiquidity(IUniswapV3Pool pool, int24 _tickLower, int24 _tickUpper)
621         internal
622         view
623         returns (uint128 liquidity)
624     {
625         //Compute position key
626         bytes32 positionKey = PositionKey.compute(address(this), _tickLower, _tickUpper);
627         //Get liquidity stored in position
628         (liquidity, , , , ) = pool.positions(positionKey);
629     }
630 
631     /// @dev Common checks for valid tick inputs.
632     /// @param tickLower The lower tick of the range
633     /// @param tickUpper The upper tick of the range
634     function checkRange(int24 tickLower, int24 tickUpper) internal pure {
635         require(tickLower < tickUpper, "TLU");
636         require(tickLower >= TickMath.MIN_TICK, "TLM");
637         require(tickUpper <= TickMath.MAX_TICK, "TUM");
638     }
639 
640     /// @dev Rounds tick down towards negative infinity so that it's a multiple
641     /// of `tickSpacing`.
642     function floor(int24 tick, int24 tickSpacing) internal pure returns (int24) {
643         int24 compressed = tick / tickSpacing;
644         if (tick < 0 && tick % tickSpacing != 0) compressed--;
645         return compressed * tickSpacing;
646     }
647 
648     /// @dev Gets ticks with proportion equivalent to desired amount
649     /// @param pool Uniswap V3 pool
650     /// @param amount0Desired The desired amount of token0
651     /// @param amount1Desired The desired amount of token1
652     /// @param baseThreshold The range for upper and lower ticks
653     /// @param tickSpacing The pool tick spacing
654     /// @return tickLower The lower tick of the range
655     /// @return tickUpper The upper tick of the range
656     function getPositionTicks(IUniswapV3Pool pool, uint256 amount0Desired, uint256 amount1Desired, int24 baseThreshold, int24 tickSpacing) internal view returns(int24 tickLower, int24 tickUpper) {
657         Info memory cache = 
658             Info(amount0Desired, amount1Desired, 0, 0, 0, 0, 0);
659         // Get current price and tick from the pool
660         ( uint160 sqrtPriceX96, int24 currentTick, , , , , ) = pool.slot0();
661         //Calc base ticks 
662         (cache.tickLower, cache.tickUpper) = baseTicks(currentTick, baseThreshold, tickSpacing);
663         //Calc amounts of token0 and token1 that can be stored in base range
664         (cache.amount0, cache.amount1) = amountsForTicks(pool, cache.amount0Desired, cache.amount1Desired, cache.tickLower, cache.tickUpper);
665         //Liquidity that can be stored in base range
666         cache.liquidity = liquidityForAmounts(pool, cache.amount0, cache.amount1, cache.tickLower, cache.tickUpper);
667         //Get imbalanced token
668         bool zeroGreaterOne = amountsDirection(cache.amount0Desired, cache.amount1Desired, cache.amount0, cache.amount1);
669         //Calc new tick(upper or lower) for imbalanced token
670         if ( zeroGreaterOne) {
671             uint160 nextSqrtPrice0 = SqrtPriceMath.getNextSqrtPriceFromAmount0RoundingUp(sqrtPriceX96, cache.liquidity, cache.amount0Desired, false);
672             cache.tickUpper = PoolVariables.floor(TickMath.getTickAtSqrtRatio(nextSqrtPrice0), tickSpacing);
673         }
674         else{
675             uint160 nextSqrtPrice1 = SqrtPriceMath.getNextSqrtPriceFromAmount1RoundingDown(sqrtPriceX96, cache.liquidity, cache.amount1Desired, false);
676             cache.tickLower = PoolVariables.floor(TickMath.getTickAtSqrtRatio(nextSqrtPrice1), tickSpacing);
677         }
678         checkRange(cache.tickLower, cache.tickUpper);
679         
680         tickLower = cache.tickLower;
681         tickUpper = cache.tickUpper;
682     }
683 
684     /// @dev Gets amounts of token0 and token1 that can be stored in range of upper and lower ticks
685     /// @param pool Uniswap V3 pool
686     /// @param amount0Desired The desired amount of token0
687     /// @param amount1Desired The desired amount of token1
688     /// @param _tickLower The lower tick of the range
689     /// @param _tickUpper The upper tick of the range
690     /// @return amount0 amounts of token0 that can be stored in range
691     /// @return amount1 amounts of token1 that can be stored in range
692     function amountsForTicks(IUniswapV3Pool pool, uint256 amount0Desired, uint256 amount1Desired, int24 _tickLower, int24 _tickUpper) internal view returns(uint256 amount0, uint256 amount1) {
693         uint128 liquidity = liquidityForAmounts(pool, amount0Desired, amount1Desired, _tickLower, _tickUpper);
694 
695         (amount0, amount1) = amountsForLiquidity(pool, liquidity, _tickLower, _tickUpper);
696     }
697 
698     /// @dev Calc base ticks depending on base threshold and tickspacing
699     function baseTicks(int24 currentTick, int24 baseThreshold, int24 tickSpacing) internal pure returns(int24 tickLower, int24 tickUpper) {
700         
701         int24 tickFloor = floor(currentTick, tickSpacing);
702 
703         tickLower = tickFloor - baseThreshold;
704         tickUpper = tickFloor + baseThreshold;
705     }
706 
707     /// @dev Get imbalanced token
708     /// @param amount0Desired The desired amount of token0
709     /// @param amount1Desired The desired amount of token1
710     /// @param amount0 Amounts of token0 that can be stored in base range
711     /// @param amount1 Amounts of token1 that can be stored in base range
712     /// @return zeroGreaterOne true if token0 is imbalanced. False if token1 is imbalanced
713     function amountsDirection(uint256 amount0Desired, uint256 amount1Desired, uint256 amount0, uint256 amount1) internal pure returns (bool zeroGreaterOne) {
714         zeroGreaterOne =  amount0Desired.sub(amount0).mul(amount1Desired) > amount1Desired.sub(amount1).mul(amount0Desired) ?  true : false;
715     }
716 
717     // Check price has not moved a lot recently. This mitigates price
718     // manipulation during rebalance and also prevents placing orders
719     // when it's too volatile.
720     function checkDeviation(IUniswapV3Pool pool, int24 maxTwapDeviation, uint32 twapDuration) internal view {
721         (, int24 currentTick, , , , , ) = pool.slot0();
722         int24 twap = getTwap(pool, twapDuration);
723         int24 deviation = currentTick > twap ? currentTick - twap : twap - currentTick;
724         require(deviation <= maxTwapDeviation, "PSC");
725     }
726 
727     /// @dev Fetches time-weighted average price in ticks from Uniswap pool for specified duration
728     function getTwap(IUniswapV3Pool pool, uint32 twapDuration) internal view returns (int24) {
729         uint32 _twapDuration = twapDuration;
730         uint32[] memory secondsAgo = new uint32[](2);
731         secondsAgo[0] = _twapDuration;
732         secondsAgo[1] = 0;
733 
734         (int56[] memory tickCumulatives, ) = pool.observe(secondsAgo);
735         return int24((tickCumulatives[1] - tickCumulatives[0]) / _twapDuration);
736     }
737 }
738 
739 pragma solidity >=0.5.0;
740 
741 /// @title Permissionless pool actions
742 /// @notice Contains pool methods that can be called by anyone
743 interface IUniswapV3PoolActions {
744 
745     /// @notice Adds liquidity for the given recipient/tickLower/tickUpper position
746     /// @dev The caller of this method receives a callback in the form of IUniswapV3MintCallback#uniswapV3MintCallback
747     /// in which they must pay any token0 or token1 owed for the liquidity. The amount of token0/token1 due depends
748     /// on tickLower, tickUpper, the amount of liquidity, and the current price.
749     /// @param recipient The address for which the liquidity will be created
750     /// @param tickLower The lower tick of the position in which to add liquidity
751     /// @param tickUpper The upper tick of the position in which to add liquidity
752     /// @param amount The amount of liquidity to mint
753     /// @param data Any data that should be passed through to the callback
754     /// @return amount0 The amount of token0 that was paid to mint the given amount of liquidity. Matches the value in the callback
755     /// @return amount1 The amount of token1 that was paid to mint the given amount of liquidity. Matches the value in the callback
756     function mint(
757         address recipient,
758         int24 tickLower,
759         int24 tickUpper,
760         uint128 amount,
761         bytes calldata data
762     ) external returns (uint256 amount0, uint256 amount1);
763 
764     /// @notice Collects tokens owed to a position
765     /// @dev Does not recompute fees earned, which must be done either via mint or burn of any amount of liquidity.
766     /// Collect must be called by the position owner. To withdraw only token0 or only token1, amount0Requested or
767     /// amount1Requested may be set to zero. To withdraw all tokens owed, caller may pass any value greater than the
768     /// actual tokens owed, e.g. type(uint128).max. Tokens owed may be from accumulated swap fees or burned liquidity.
769     /// @param recipient The address which should receive the fees collected
770     /// @param tickLower The lower tick of the position for which to collect fees
771     /// @param tickUpper The upper tick of the position for which to collect fees
772     /// @param amount0Requested How much token0 should be withdrawn from the fees owed
773     /// @param amount1Requested How much token1 should be withdrawn from the fees owed
774     /// @return amount0 The amount of fees collected in token0
775     /// @return amount1 The amount of fees collected in token1
776     function collect(
777         address recipient,
778         int24 tickLower,
779         int24 tickUpper,
780         uint128 amount0Requested,
781         uint128 amount1Requested
782     ) external returns (uint128 amount0, uint128 amount1);
783 
784     /// @notice Burn liquidity from the sender and account tokens owed for the liquidity to the position
785     /// @dev Can be used to trigger a recalculation of fees owed to a position by calling with an amount of 0
786     /// @dev Fees must be collected separately via a call to #collect
787     /// @param tickLower The lower tick of the position for which to burn liquidity
788     /// @param tickUpper The upper tick of the position for which to burn liquidity
789     /// @param amount How much liquidity to burn
790     /// @return amount0 The amount of token0 sent to the recipient
791     /// @return amount1 The amount of token1 sent to the recipient
792     function burn(
793         int24 tickLower,
794         int24 tickUpper,
795         uint128 amount
796     ) external returns (uint256 amount0, uint256 amount1);
797 
798     /// @notice Swap token0 for token1, or token1 for token0
799     /// @dev The caller of this method receives a callback in the form of IUniswapV3SwapCallback#uniswapV3SwapCallback
800     /// @param recipient The address to receive the output of the swap
801     /// @param zeroForOne The direction of the swap, true for token0 to token1, false for token1 to token0
802     /// @param amountSpecified The amount of the swap, which implicitly configures the swap as exact input (positive), or exact output (negative)
803     /// @param sqrtPriceLimitX96 The Q64.96 sqrt price limit. If zero for one, the price cannot be less than this
804     /// value after the swap. If one for zero, the price cannot be greater than this value after the swap
805     /// @param data Any data to be passed through to the callback
806     /// @return amount0 The delta of the balance of token0 of the pool, exact when negative, minimum when positive
807     /// @return amount1 The delta of the balance of token1 of the pool, exact when negative, minimum when positive
808     function swap(
809         address recipient,
810         bool zeroForOne,
811         int256 amountSpecified,
812         uint160 sqrtPriceLimitX96,
813         bytes calldata data
814     ) external returns (int256 amount0, int256 amount1);
815 }
816 
817 pragma solidity >=0.5.0;
818 
819 /// @title Pool state that is not stored
820 /// @notice Contains view functions to provide information about the pool that is computed rather than stored on the
821 /// blockchain. The functions here may have variable gas costs.
822 interface IUniswapV3PoolDerivedState {
823     /// @notice Returns the cumulative tick and liquidity as of each timestamp `secondsAgo` from the current block timestamp
824     /// @dev To get a time weighted average tick or liquidity-in-range, you must call this with two values, one representing
825     /// the beginning of the period and another for the end of the period. E.g., to get the last hour time-weighted average tick,
826     /// you must call it with secondsAgos = [3600, 0].
827     /// @dev The time weighted average tick represents the geometric time weighted average price of the pool, in
828     /// log base sqrt(1.0001) of token1 / token0. The TickMath library can be used to go from a tick value to a ratio.
829     /// @param secondsAgos From how long ago each cumulative tick and liquidity value should be returned
830     /// @return tickCumulatives Cumulative tick values as of each `secondsAgos` from the current block timestamp
831     /// @return secondsPerLiquidityCumulativeX128s Cumulative seconds per liquidity-in-range value as of each `secondsAgos` from the current block
832     /// timestamp
833     function observe(uint32[] calldata secondsAgos)
834         external
835         view
836         returns (int56[] memory tickCumulatives, uint160[] memory secondsPerLiquidityCumulativeX128s);
837 }
838 
839 pragma solidity >=0.5.0;
840 
841 /// @title Pool state that can change
842 /// @notice These methods compose the pool's state, and can change with any frequency including multiple times
843 /// per transaction
844 interface IUniswapV3PoolState {
845     /// @notice The 0th storage slot in the pool stores many values, and is exposed as a single method to save gas
846     /// when accessed externally.
847     /// @return sqrtPriceX96 The current price of the pool as a sqrt(token1/token0) Q64.96 value
848     /// tick The current tick of the pool, i.e. according to the last tick transition that was run.
849     /// This value may not always be equal to SqrtTickMath.getTickAtSqrtRatio(sqrtPriceX96) if the price is on a tick
850     /// boundary.
851     /// observationIndex The index of the last oracle observation that was written,
852     /// observationCardinality The current maximum number of observations stored in the pool,
853     /// observationCardinalityNext The next maximum number of observations, to be updated when the observation.
854     /// feeProtocol The protocol fee for both tokens of the pool.
855     /// Encoded as two 4 bit values, where the protocol fee of token1 is shifted 4 bits and the protocol fee of token0
856     /// is the lower 4 bits. Used as the denominator of a fraction of the swap fee, e.g. 4 means 1/4th of the swap fee.
857     /// unlocked Whether the pool is currently locked to reentrancy
858     function slot0()
859         external
860         view
861         returns (
862             uint160 sqrtPriceX96,
863             int24 tick,
864             uint16 observationIndex,
865             uint16 observationCardinality,
866             uint16 observationCardinalityNext,
867             uint8 feeProtocol,
868             bool unlocked
869         );
870 
871     /// @notice Returns the information about a position by the position's key
872     /// @param key The position's key is a hash of a preimage composed by the owner, tickLower and tickUpper
873     /// @return _liquidity The amount of liquidity in the position,
874     /// Returns feeGrowthInside0LastX128 fee growth of token0 inside the tick range as of the last mint/burn/poke,
875     /// Returns feeGrowthInside1LastX128 fee growth of token1 inside the tick range as of the last mint/burn/poke,
876     /// Returns tokensOwed0 the computed amount of token0 owed to the position as of the last mint/burn/poke,
877     /// Returns tokensOwed1 the computed amount of token1 owed to the position as of the last mint/burn/poke
878     function positions(bytes32 key)
879         external
880         view
881         returns (
882             uint128 _liquidity,
883             uint256 feeGrowthInside0LastX128,
884             uint256 feeGrowthInside1LastX128,
885             uint128 tokensOwed0,
886             uint128 tokensOwed1
887         );
888 }
889 
890 pragma solidity >=0.5.0;
891 
892 /// @title Pool state that never changes
893 /// @notice These parameters are fixed for a pool forever, i.e., the methods will always return the same values
894 interface IUniswapV3PoolImmutables {
895 
896     /// @notice The first of the two tokens of the pool, sorted by address
897     /// @return The token contract address
898     function token0() external view returns (address);
899 
900     /// @notice The second of the two tokens of the pool, sorted by address
901     /// @return The token contract address
902     function token1() external view returns (address);
903 
904     /// @notice The pool tick spacing
905     /// @dev Ticks can only be used at multiples of this value, minimum of 1 and always positive
906     /// e.g.: a tickSpacing of 3 means ticks can be initialized every 3rd tick, i.e., ..., -6, -3, 0, 3, 6, ...
907     /// This value is an int24 to avoid casting even though it is always positive.
908     /// @return The tick spacing
909     function tickSpacing() external view returns (int24);
910 }
911 
912 pragma solidity >=0.5.0;
913 
914 /// @title The interface for a Uniswap V3 Pool
915 /// @notice A Uniswap pool facilitates swapping and automated market making between any two assets that strictly conform
916 /// to the ERC20 specification
917 /// @dev The pool interface is broken up into many smaller pieces
918 interface IUniswapV3Pool is
919     IUniswapV3PoolImmutables,
920     IUniswapV3PoolState,
921     IUniswapV3PoolDerivedState,
922     IUniswapV3PoolActions
923 {
924 
925 }
926 
927 pragma solidity 0.7.6;
928 pragma abicoder v2;
929 
930 
931 
932 /// @title This library is created to conduct a variety of burn liquidity methods
933 library PoolActions {
934     using PoolVariables for IUniswapV3Pool;
935     using LowGasSafeMath for uint256;
936     using SafeCast for uint256;
937 
938     /**
939      * @notice Withdraws liquidity in share proportion to the Sorbetto's totalSupply.
940      * @param pool Uniswap V3 pool
941      * @param tickLower The lower tick of the range
942      * @param tickUpper The upper tick of the range
943      * @param totalSupply The amount of total shares in existence
944      * @param share to burn
945      * @param to Recipient of amounts
946      * @return amount0 Amount of token0 withdrawed
947      * @return amount1 Amount of token1 withdrawed
948      */
949     function burnLiquidityShare(
950         IUniswapV3Pool pool,
951         int24 tickLower,
952         int24 tickUpper,
953         uint256 totalSupply,
954         uint256 share,
955         address to
956     ) internal returns (uint256 amount0, uint256 amount1) {
957         require(totalSupply > 0, "TS");
958         uint128 liquidityInPool = pool.positionLiquidity(tickLower, tickUpper);
959         uint256 liquidity = uint256(liquidityInPool).mul(share) / totalSupply;
960         
961 
962         if (liquidity > 0) {
963             (amount0, amount1) = pool.burn(tickLower, tickUpper, liquidity.toUint128());
964 
965             if (amount0 > 0 || amount1 > 0) {
966             // collect liquidity share
967                 (amount0, amount1) = pool.collect(
968                     to,
969                     tickLower,
970                     tickUpper,
971                     amount0.toUint128(),
972                     amount1.toUint128()
973                 );
974             }
975         }
976     }
977 
978     /**
979      * @notice Withdraws exact amount of liquidity
980      * @param pool Uniswap V3 pool
981      * @param tickLower The lower tick of the range
982      * @param tickUpper The upper tick of the range
983      * @param liquidity to burn
984      * @param to Recipient of amounts
985      * @return amount0 Amount of token0 withdrawed
986      * @return amount1 Amount of token1 withdrawed
987      */
988     function burnExactLiquidity(
989         IUniswapV3Pool pool,
990         int24 tickLower,
991         int24 tickUpper,
992         uint128 liquidity,
993         address to
994     ) internal returns (uint256 amount0, uint256 amount1) {
995         uint128 liquidityInPool = pool.positionLiquidity(tickLower, tickUpper);
996         require(liquidityInPool >= liquidity, "TML");
997         (amount0, amount1) = pool.burn(tickLower, tickUpper, liquidity);
998 
999         if (amount0 > 0 || amount1 > 0) {
1000             // collect liquidity share including earned fees
1001             (amount0, amount0) = pool.collect(
1002                 to,
1003                 tickLower,
1004                 tickUpper,
1005                 amount0.toUint128(),
1006                 amount1.toUint128()
1007             );
1008         }
1009     }
1010 
1011     /**
1012      * @notice Withdraws all liquidity in a range from Uniswap pool
1013      * @param pool Uniswap V3 pool
1014      * @param tickLower The lower tick of the range
1015      * @param tickUpper The upper tick of the range
1016      */
1017     function burnAllLiquidity(
1018         IUniswapV3Pool pool,
1019         int24 tickLower,
1020         int24 tickUpper
1021     ) internal {
1022         
1023         // Burn all liquidity in this range
1024         uint128 liquidity = pool.positionLiquidity(tickLower, tickUpper);
1025         if (liquidity > 0) {
1026             pool.burn(tickLower, tickUpper, liquidity);
1027         }
1028         
1029          // Collect all owed tokens
1030         pool.collect(
1031             address(this),
1032             tickLower,
1033             tickUpper,
1034             type(uint128).max,
1035             type(uint128).max
1036         );
1037     }
1038 }
1039 
1040 pragma solidity >=0.4.0;
1041 
1042 // computes square roots using the babylonian method
1043 // https://en.wikipedia.org/wiki/Methods_of_computing_square_roots#Babylonian_method
1044 library Babylonian {
1045     // credit for this implementation goes to
1046     // https://github.com/abdk-consulting/abdk-libraries-solidity/blob/master/ABDKMath64x64.sol#L687
1047     function sqrt(uint256 x) internal pure returns (uint256) {
1048         if (x == 0) return 0;
1049         // this block is equivalent to r = uint256(1) << (BitMath.mostSignificantBit(x) / 2);
1050         // however that code costs significantly more gas
1051         uint256 xx = x;
1052         uint256 r = 1;
1053         if (xx >= 0x100000000000000000000000000000000) {
1054             xx >>= 128;
1055             r <<= 64;
1056         }
1057         if (xx >= 0x10000000000000000) {
1058             xx >>= 64;
1059             r <<= 32;
1060         }
1061         if (xx >= 0x100000000) {
1062             xx >>= 32;
1063             r <<= 16;
1064         }
1065         if (xx >= 0x10000) {
1066             xx >>= 16;
1067             r <<= 8;
1068         }
1069         if (xx >= 0x100) {
1070             xx >>= 8;
1071             r <<= 4;
1072         }
1073         if (xx >= 0x10) {
1074             xx >>= 4;
1075             r <<= 2;
1076         }
1077         if (xx >= 0x8) {
1078             r <<= 1;
1079         }
1080         r = (r + x / r) >> 1;
1081         r = (r + x / r) >> 1;
1082         r = (r + x / r) >> 1;
1083         r = (r + x / r) >> 1;
1084         r = (r + x / r) >> 1;
1085         r = (r + x / r) >> 1;
1086         r = (r + x / r) >> 1; // Seven iterations should be enough
1087         uint256 r1 = x / r;
1088         return (r < r1 ? r : r1);
1089     }
1090 }
1091 
1092 pragma solidity ^0.7.0;
1093 
1094 
1095 /**
1096  * @title Counters
1097  * @author Matt Condon (@shrugs)
1098  * @dev Provides counters that can only be incremented or decremented by one. This can be used e.g. to track the number
1099  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
1100  *
1101  * Include with `using Counters for Counters.Counter;`
1102  * Since it is not possible to overflow a 256 bit integer with increments of one, `increment` can skip the {LowGasSafeMAth}
1103  * overflow check, thereby saving gas. This does assume however correct usage, in that the underlying `_value` is never
1104  * directly accessed.
1105  */
1106 library Counters {
1107     using LowGasSafeMath for uint256;
1108 
1109     struct Counter {
1110         // This variable should never be directly accessed by users of the library: interactions must be restricted to
1111         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
1112         // this feature: see https://github.com/ethereum/solidity/issues/4637
1113         uint256 _value; // default: 0
1114     }
1115 
1116     function current(Counter storage counter) internal view returns (uint256) {
1117         return counter._value;
1118     }
1119 
1120     function increment(Counter storage counter) internal {
1121         // The {LowGasSafeMath} overflow check can be skipped here, see the comment at the top
1122         counter._value += 1;
1123     }
1124 }
1125 
1126 pragma solidity >=0.7.0;
1127 
1128 /// @title Function for getting the current chain ID
1129 library ChainId {
1130     /// @dev Gets the current chain ID
1131     /// @return chainId The current chain ID
1132     function get() internal pure returns (uint256 chainId) {
1133         assembly {
1134             chainId := chainid()
1135         }
1136     }
1137 }
1138 
1139 pragma solidity =0.7.6;
1140 
1141 /**
1142  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
1143  *
1144  * These functions can be used to verify that a message was signed by the holder
1145  * of the private keys of a given address.
1146  */
1147 library ECDSA {
1148     /**
1149      * @dev Overload of {ECDSA-recover} that receives the `v`,
1150      * `r` and `s` signature fields separately.
1151      */
1152     function recover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal pure returns (address) {
1153         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
1154         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
1155         // the valid range for s in (281): 0 < s < secp256k1n ÷ 2 + 1, and for v in (282): v ∈ {27, 28}. Most
1156         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
1157         //
1158         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
1159         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
1160         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
1161         // these malleable signatures as well.
1162         require(uint256(s) <= 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0, "ISS");
1163         require(v == 27 || v == 28, "ISV");
1164 
1165         // If the signature is valid (and not malleable), return the signer address
1166         address signer = ecrecover(hash, v, r, s);
1167         require(signer != address(0), "IS");
1168 
1169         return signer;
1170     }
1171 
1172     /**
1173      * @dev Returns an Ethereum Signed Typed Data, created from a
1174      * `domainSeparator` and a `structHash`. This produces hash corresponding
1175      * to the one signed with the
1176      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
1177      * JSON-RPC method as part of EIP-712.
1178      *
1179      * See {recover}.
1180      */
1181     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
1182         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
1183     }
1184 }
1185 
1186 pragma solidity =0.7.6;
1187 
1188 
1189 
1190 /**
1191  * @dev https://eips.ethereum.org/EIPS/eip-712[EIP 712] is a standard for hashing and signing of typed structured data.
1192  *
1193  * The encoding specified in the EIP is very generic, and such a generic implementation in Solidity is not feasible,
1194  * thus this contract does not implement the encoding itself. Protocols need to implement the type-specific encoding
1195  * they need in their contracts using a combination of `abi.encode` and `keccak256`.
1196  *
1197  * This contract implements the EIP 712 domain separator ({_domainSeparatorV4}) that is used as part of the encoding
1198  * scheme, and the final step of the encoding to obtain the message digest that is then signed via ECDSA
1199  * ({_hashTypedDataV4}).
1200  *
1201  * The implementation of the domain separator was designed to be as efficient as possible while still properly updating
1202  * the chain id to protect against replay attacks on an eventual fork of the chain.
1203  *
1204  * NOTE: This contract implements the version of the encoding known as "v4", as implemented by the JSON RPC method
1205  * https://docs.metamask.io/guide/signing-data.html[`eth_signTypedDataV4` in MetaMask].
1206  *
1207  * _Available since v3.4._
1208  */
1209 abstract contract EIP712 {
1210     /* solhint-disable var-name-mixedcase */
1211     // Cache the domain separator as an immutable value, but also store the chain id that it corresponds to, in order to
1212     // invalidate the cached domain separator if the chain id changes.
1213     bytes32 private immutable _CACHED_DOMAIN_SEPARATOR;
1214     uint256 private immutable _CACHED_CHAIN_ID;
1215 
1216     bytes32 private immutable _HASHED_NAME;
1217     bytes32 private immutable _HASHED_VERSION;
1218     bytes32 private immutable _TYPE_HASH;
1219     /* solhint-enable var-name-mixedcase */
1220 
1221     /**
1222      * @dev Initializes the domain separator and parameter caches.
1223      *
1224      * The meaning of `name` and `version` is specified in
1225      * https://eips.ethereum.org/EIPS/eip-712#definition-of-domainseparator[EIP 712]:
1226      *
1227      * - `name`: the user readable name of the signing domain, i.e. the name of the DApp or the protocol.
1228      * - `version`: the current major version of the signing domain.
1229      *
1230      * NOTE: These parameters cannot be changed except through a xref:learn::upgrading-smart-contracts.adoc[smart
1231      * contract upgrade].
1232      */
1233     constructor(string memory name, string memory version) {
1234         bytes32 hashedName = keccak256(bytes(name));
1235         bytes32 hashedVersion = keccak256(bytes(version));
1236         bytes32 typeHash = keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)");
1237         _HASHED_NAME = hashedName;
1238         _HASHED_VERSION = hashedVersion;
1239         _CACHED_CHAIN_ID = ChainId.get();
1240         _CACHED_DOMAIN_SEPARATOR = _buildDomainSeparator(typeHash, hashedName, hashedVersion);
1241         _TYPE_HASH = typeHash;
1242     }
1243 
1244     /**
1245      * @dev Returns the domain separator for the current chain.
1246      */
1247     function _domainSeparatorV4() internal view returns (bytes32) {
1248         if (ChainId.get() == _CACHED_CHAIN_ID) {
1249             return _CACHED_DOMAIN_SEPARATOR;
1250         } else {
1251             return _buildDomainSeparator(_TYPE_HASH, _HASHED_NAME, _HASHED_VERSION);
1252         }
1253     }
1254 
1255     function _buildDomainSeparator(bytes32 typeHash, bytes32 name, bytes32 version) private view returns (bytes32) {
1256         return keccak256(
1257             abi.encode(
1258                 typeHash,
1259                 name,
1260                 version,
1261                 ChainId.get(),
1262                 address(this)
1263             )
1264         );
1265     }
1266 
1267     /**
1268      * @dev Given an already https://eips.ethereum.org/EIPS/eip-712#definition-of-hashstruct[hashed struct], this
1269      * function returns the hash of the fully encoded EIP712 message for this domain.
1270      *
1271      * This hash can be used together with {ECDSA-recover} to obtain the signer of a message. For example:
1272      *
1273      * ```solidity
1274      * bytes32 digest = _hashTypedDataV4(keccak256(abi.encode(
1275      *     keccak256("Mail(address to,string contents)"),
1276      *     mailTo,
1277      *     keccak256(bytes(mailContents))
1278      * )));
1279      * address signer = ECDSA.recover(digest, signature);
1280      * ```
1281      */
1282     function _hashTypedDataV4(bytes32 structHash) internal view virtual returns (bytes32) {
1283         return ECDSA.toTypedDataHash(_domainSeparatorV4(), structHash);
1284     }
1285 }
1286 
1287 pragma solidity >=0.6.0 <0.8.0;
1288 
1289 /**
1290  * @dev Interface of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
1291  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
1292  *
1293  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
1294  * presenting a message signed by the account. By not relying on `{IERC20-approve}`, the token holder account doesn't
1295  * need to send a transaction, and thus is not required to hold Ether at all.
1296  */
1297 interface IERC20Permit {
1298     /**
1299      * @dev Sets `value` as the allowance of `spender` over `owner`'s tokens,
1300      * given `owner`'s signed approval.
1301      *
1302      * IMPORTANT: The same issues {IERC20-approve} has related to transaction
1303      * ordering also apply here.
1304      *
1305      * Emits an {Approval} event.
1306      *
1307      * Requirements:
1308      *
1309      * - `spender` cannot be the zero address.
1310      * - `deadline` must be a timestamp in the future.
1311      * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
1312      * over the EIP712-formatted function arguments.
1313      * - the signature must use ``owner``'s current nonce (see {nonces}).
1314      *
1315      * For more information on the signature format, see the
1316      * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
1317      * section].
1318      */
1319     function permit(address owner, address spender, uint256 value, uint256 deadline, uint8 v, bytes32 r, bytes32 s) external;
1320 
1321     /**
1322      * @dev Returns the current nonce for `owner`. This value must be
1323      * included whenever a signature is generated for {permit}.
1324      *
1325      * Every successful call to {permit} increases ``owner``'s nonce by one. This
1326      * prevents a signature from being used multiple times.
1327      */
1328     function nonces(address owner) external view returns (uint256);
1329 
1330     /**
1331      * @dev Returns the domain separator used in the encoding of the signature for `permit`, as defined by {EIP712}.
1332      */
1333     // solhint-disable-next-line func-name-mixedcase
1334     function DOMAIN_SEPARATOR() external view returns (bytes32);
1335 }
1336 
1337 pragma solidity >=0.6.0 <0.8.0;
1338 
1339 /*
1340  * @dev Provides information about the current execution context, including the
1341  * sender of the transaction and its data. While these are generally available
1342  * via msg.sender and msg.data, they should not be accessed in such a direct
1343  * manner, since when dealing with GSN meta-transactions the account sending and
1344  * paying for execution may not be the actual sender (as far as an application
1345  * is concerned).
1346  *
1347  * This contract is only required for intermediate, library-like contracts.
1348  */
1349 abstract contract Context {
1350     function _msgSender() internal view virtual returns (address payable) {
1351         return msg.sender;
1352     }
1353 
1354     function _msgData() internal view virtual returns (bytes memory) {
1355         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
1356         return msg.data;
1357     }
1358 }
1359 
1360 pragma solidity ^0.7.0;
1361 
1362 
1363 
1364 
1365 /**
1366  * @dev Implementation of the {IERC20} interface.
1367  *
1368  * This implementation is agnostic to the way tokens are created. This means
1369  * that a supply mechanism has to be added in a derived contract using {_mint}.
1370  * For a generic mechanism see {ERC20PresetMinterPauser}.
1371  *
1372  * TIP: For a detailed writeup see our guide
1373  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
1374  * to implement supply mechanisms].
1375  *
1376  * We have followed general OpenZeppelin guidelines: functions revert instead
1377  * of returning `false` on failure. This behavior is nonetheless conventional
1378  * and does not conflict with the expectations of ERC20 applications.
1379  *
1380  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
1381  * This allows applications to reconstruct the allowance for all accounts just
1382  * by listening to said events. Other implementations of the EIP may not emit
1383  * these events, as it isn't required by the specification.
1384  *
1385  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
1386  * functions have been added to mitigate the well-known issues around setting
1387  * allowances. See {IERC20-approve}.
1388  */
1389 contract ERC20 is Context, IERC20 {
1390     using LowGasSafeMath for uint256;
1391 
1392     mapping (address => uint256) private _balances;
1393 
1394     mapping (address => mapping (address => uint256)) private _allowances;
1395 
1396     uint256 private _totalSupply;
1397 
1398     string private _name;
1399     string private _symbol;
1400     uint8 private _decimals;
1401 
1402     /**
1403      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
1404      * a default value of 18.
1405      *
1406      * To select a different value for {decimals}, use {_setupDecimals}.
1407      *
1408      * All three of these values are immutable: they can only be set once during
1409      * construction.
1410      */
1411     constructor (string memory name_, string memory symbol_) {
1412         _name = name_;
1413         _symbol = symbol_;
1414         _decimals = 18;
1415     }
1416 
1417     /**
1418      * @dev Returns the name of the token.
1419      */
1420     function name() public view virtual returns (string memory) {
1421         return _name;
1422     }
1423 
1424     /**
1425      * @dev Returns the symbol of the token, usually a shorter version of the
1426      * name.
1427      */
1428     function symbol() public view virtual returns (string memory) {
1429         return _symbol;
1430     }
1431 
1432     /**
1433      * @dev Returns the number of decimals used to get its user representation.
1434      * For example, if `decimals` equals `2`, a balance of `505` tokens should
1435      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
1436      *
1437      * Tokens usually opt for a value of 18, imitating the relationship between
1438      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
1439      * called.
1440      *
1441      * NOTE: This information is only used for _display_ purposes: it in
1442      * no way affects any of the arithmetic of the contract, including
1443      * {IERC20-balanceOf} and {IERC20-transfer}.
1444      */
1445     function decimals() public view virtual returns (uint8) {
1446         return _decimals;
1447     }
1448 
1449     /**
1450      * @dev See {IERC20-totalSupply}.
1451      */
1452     function totalSupply() public view virtual override returns (uint256) {
1453         return _totalSupply;
1454     }
1455 
1456     /**
1457      * @dev See {IERC20-balanceOf}.
1458      */
1459     function balanceOf(address account) public view virtual override returns (uint256) {
1460         return _balances[account];
1461     }
1462 
1463     /**
1464      * @dev See {IERC20-transfer}.
1465      *
1466      * Requirements:
1467      *
1468      * - `recipient` cannot be the zero address.
1469      * - the caller must have a balance of at least `amount`.
1470      */
1471     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
1472         _transfer(_msgSender(), recipient, amount);
1473         return true;
1474     }
1475 
1476     /**
1477      * @dev See {IERC20-allowance}.
1478      */
1479     function allowance(address owner, address spender) public view virtual override returns (uint256) {
1480         return _allowances[owner][spender];
1481     }
1482 
1483     /**
1484      * @dev See {IERC20-approve}.
1485      *
1486      * Requirements:
1487      *
1488      * - `spender` cannot be the zero address.
1489      */
1490     function approve(address spender, uint256 amount) public virtual override returns (bool) {
1491         _approve(_msgSender(), spender, amount);
1492         return true;
1493     }
1494 
1495     /**
1496      * @dev See {IERC20-transferFrom}.
1497      *
1498      * Emits an {Approval} event indicating the updated allowance. This is not
1499      * required by the EIP. See the note at the beginning of {ERC20}.
1500      *
1501      * Requirements:
1502      *
1503      * - `sender` and `recipient` cannot be the zero address.
1504      * - `sender` must have a balance of at least `amount`.
1505      * - the caller must have allowance for ``sender``'s tokens of at least
1506      * `amount`.
1507      */
1508     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
1509         _transfer(sender, recipient, amount);
1510         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "TEA"));
1511         return true;
1512     }
1513 
1514     /**
1515      * @dev Atomically increases the allowance granted to `spender` by the caller.
1516      *
1517      * This is an alternative to {approve} that can be used as a mitigation for
1518      * problems described in {IERC20-approve}.
1519      *
1520      * Emits an {Approval} event indicating the updated allowance.
1521      *
1522      * Requirements:
1523      *
1524      * - `spender` cannot be the zero address.
1525      */
1526     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
1527         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
1528         return true;
1529     }
1530 
1531     /**
1532      * @dev Atomically decreases the allowance granted to `spender` by the caller.
1533      *
1534      * This is an alternative to {approve} that can be used as a mitigation for
1535      * problems described in {IERC20-approve}.
1536      *
1537      * Emits an {Approval} event indicating the updated allowance.
1538      *
1539      * Requirements:
1540      *
1541      * - `spender` cannot be the zero address.
1542      * - `spender` must have allowance for the caller of at least
1543      * `subtractedValue`.
1544      */
1545     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1546         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "DEB"));
1547         return true;
1548     }
1549 
1550     /**
1551      * @dev Moves tokens `amount` from `sender` to `recipient`.
1552      *
1553      * This is internal function is equivalent to {transfer}, and can be used to
1554      * e.g. implement automatic token fees, slashing mechanisms, etc.
1555      *
1556      * Emits a {Transfer} event.
1557      *
1558      * Requirements:
1559      *
1560      * - `sender` cannot be the zero address.
1561      * - `recipient` cannot be the zero address.
1562      * - `sender` must have a balance of at least `amount`.
1563      */
1564     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
1565         require(sender != address(0), "FZA");
1566         require(recipient != address(0), "TZA");
1567 
1568         _beforeTokenTransfer(sender, recipient, amount);
1569 
1570         _balances[sender] = _balances[sender].sub(amount, "TEB");
1571         _balances[recipient] = _balances[recipient].add(amount);
1572         emit Transfer(sender, recipient, amount);
1573     }
1574 
1575     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1576      * the total supply.
1577      *
1578      * Emits a {Transfer} event with `from` set to the zero address.
1579      *
1580      * Requirements:
1581      *
1582      * - `to` cannot be the zero address.
1583      */
1584     function _mint(address account, uint256 amount) internal virtual {
1585         require(account != address(0), "MZA");
1586 
1587         _beforeTokenTransfer(address(0), account, amount);
1588 
1589         _totalSupply = _totalSupply.add(amount);
1590         _balances[account] = _balances[account].add(amount);
1591         emit Transfer(address(0), account, amount);
1592     }
1593 
1594     /**
1595      * @dev Destroys `amount` tokens from `account`, reducing the
1596      * total supply.
1597      *
1598      * Emits a {Transfer} event with `to` set to the zero address.
1599      *
1600      * Requirements:
1601      *
1602      * - `account` cannot be the zero address.
1603      * - `account` must have at least `amount` tokens.
1604      */
1605     function _burn(address account, uint256 amount) internal virtual {
1606         require(account != address(0), "BZA");
1607 
1608         _beforeTokenTransfer(account, address(0), amount);
1609 
1610         _balances[account] = _balances[account].sub(amount, "BEB");
1611         _totalSupply = _totalSupply.sub(amount);
1612         emit Transfer(account, address(0), amount);
1613     }
1614 
1615     /**
1616      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
1617      *
1618      * This internal function is equivalent to `approve`, and can be used to
1619      * e.g. set automatic allowances for certain subsystems, etc.
1620      *
1621      * Emits an {Approval} event.
1622      *
1623      * Requirements:
1624      *
1625      * - `owner` cannot be the zero address.
1626      * - `spender` cannot be the zero address.
1627      */
1628     function _approve(address owner, address spender, uint256 amount) internal virtual {
1629         require(owner != address(0), "AFZA");
1630         require(spender != address(0), "ATZA");
1631 
1632         _allowances[owner][spender] = amount;
1633         emit Approval(owner, spender, amount);
1634     }
1635 
1636     /**
1637      * @dev Sets {decimals} to a value other than the default one of 18.
1638      *
1639      * WARNING: This function should only be called from the constructor. Most
1640      * applications that interact with token contracts will not expect
1641      * {decimals} to ever change, and may work incorrectly if it does.
1642      */
1643     function _setupDecimals(uint8 decimals_) internal virtual {
1644         _decimals = decimals_;
1645     }
1646 
1647     /**
1648      * @dev Hook that is called before any transfer of tokens. This includes
1649      * minting and burning.
1650      *
1651      * Calling conditions:
1652      *
1653      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1654      * will be to transferred to `to`.
1655      * - when `from` is zero, `amount` tokens will be minted for `to`.
1656      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1657      * - `from` and `to` are never both zero.
1658      *
1659      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1660      */
1661     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
1662 }
1663 
1664 pragma solidity =0.7.6;
1665 
1666 /**
1667  * @dev Implementation of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
1668  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
1669  *
1670  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
1671  * presenting a message signed by the account. By not relying on `{IERC20-approve}`, the token holder account doesn't
1672  * need to send a transaction, and thus is not required to hold Ether at all.
1673  *
1674  * _Available since v3.4._
1675  */
1676 abstract contract ERC20Permit is ERC20, IERC20Permit, EIP712 {
1677     using Counters for Counters.Counter;
1678 
1679     mapping (address => Counters.Counter) private _nonces;
1680  
1681     //keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
1682     bytes32 private immutable _PERMIT_TYPEHASH = 0x6e71edae12b1b97f4d1f60370fef10105fa2faae0126114a169c64845d6126c9;
1683 
1684     /**
1685      * @dev Initializes the {EIP712} domain separator using the `name` parameter, and setting `version` to `"1"`.
1686      *
1687      * It's a good idea to use the same `name` that is defined as the ERC20 token name.
1688      */
1689     constructor(string memory name) EIP712(name, "1") {
1690     }
1691 
1692     /**
1693      * @dev See {IERC20Permit-permit}.
1694      */
1695     function permit(address owner, address spender, uint256 value, uint256 deadline, uint8 v, bytes32 r, bytes32 s) public virtual override {
1696         // solhint-disable-next-line not-rely-on-time
1697         require(block.timestamp <= deadline, "ED");
1698 
1699         bytes32 structHash = keccak256(
1700             abi.encode(
1701                 _PERMIT_TYPEHASH,
1702                 owner,
1703                 spender,
1704                 value,
1705                 _useNonce(owner),
1706                 deadline
1707             )
1708         );
1709 
1710         bytes32 hash = _hashTypedDataV4(structHash);
1711 
1712         address signer = ECDSA.recover(hash, v, r, s);
1713         require(signer == owner, "IS");
1714 
1715         _approve(owner, spender, value);
1716     }
1717 
1718     /**
1719      * @dev See {IERC20Permit-nonces}.
1720      */
1721     function nonces(address owner) public view virtual override returns (uint256) {
1722         return _nonces[owner].current();
1723     }
1724 
1725     /**
1726      * @dev See {IERC20Permit-DOMAIN_SEPARATOR}.
1727      */
1728     // solhint-disable-next-line func-name-mixedcase
1729     function DOMAIN_SEPARATOR() external view override returns (bytes32) {
1730         return _domainSeparatorV4();
1731     }
1732 
1733     /**
1734      * @dev "Consume a nonce": return the current value and increment.
1735      */
1736     function _useNonce(address owner) internal virtual returns (uint256 current) {
1737         Counters.Counter storage nonce = _nonces[owner];
1738         current = nonce.current();
1739         nonce.increment();
1740     }
1741 }
1742 
1743 pragma solidity >=0.4.0;
1744 
1745 /// @title FixedPoint96
1746 /// @notice A library for handling binary fixed point numbers, see https://en.wikipedia.org/wiki/Q_(number_format)
1747 /// @dev Used in SqrtPriceMath.sol
1748 library FixedPoint96 {
1749     uint8 internal constant RESOLUTION = 96;
1750     uint256 internal constant Q96 = 0x1000000000000000000000000;
1751 }
1752 
1753 pragma solidity >=0.5.0;
1754 
1755 /// @title Math functions that do not check inputs or outputs
1756 /// @notice Contains methods that perform common math functions but do not do any overflow or underflow checks
1757 library UnsafeMath {
1758     /// @notice Returns ceil(x / y)
1759     /// @dev division by 0 has unspecified behavior, and must be checked externally
1760     /// @param x The dividend
1761     /// @param y The divisor
1762     /// @return z The quotient, ceil(x / y)
1763     function divRoundingUp(uint256 x, uint256 y) internal pure returns (uint256 z) {
1764         assembly {
1765             z := add(div(x, y), gt(mod(x, y), 0))
1766         }
1767     }
1768 
1769     /// @notice Returns floor(x / y)
1770     /// @dev division by 0 has unspecified behavior, and must be checked externally
1771     /// @param x The dividend
1772     /// @param y The divisor
1773     /// @return z The quotient, floor(x / y)
1774     function unsafeDiv(uint256 x, uint256 y) internal pure returns (uint256 z) {
1775         assembly {
1776             z := div(x, y)
1777         }
1778     }
1779 }
1780 
1781 pragma solidity >=0.4.0;
1782 
1783 /// @title Contains 512-bit math functions
1784 /// @notice Facilitates multiplication and division that can have overflow of an intermediate value without any loss of precision
1785 /// @dev Handles "phantom overflow" i.e., allows multiplication and division where an intermediate value overflows 256 bits
1786 library FullMath {
1787     /// @notice Calculates floor(a×b÷denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
1788     /// @param a The multiplicand
1789     /// @param b The multiplier
1790     /// @param denominator The divisor
1791     /// @return result The 256-bit result
1792     /// @dev Credit to Remco Bloemen under MIT license https://xn--2-umb.com/21/muldiv
1793     function mulDiv(
1794         uint256 a,
1795         uint256 b,
1796         uint256 denominator
1797     ) internal pure returns (uint256 result) {
1798         // 512-bit multiply [prod1 prod0] = a * b
1799         // Compute the product mod 2**256 and mod 2**256 - 1
1800         // then use the Chinese Remainder Theorem to reconstruct
1801         // the 512 bit result. The result is stored in two 256
1802         // variables such that product = prod1 * 2**256 + prod0
1803         uint256 prod0; // Least significant 256 bits of the product
1804         uint256 prod1; // Most significant 256 bits of the product
1805         assembly {
1806             let mm := mulmod(a, b, not(0))
1807             prod0 := mul(a, b)
1808             prod1 := sub(sub(mm, prod0), lt(mm, prod0))
1809         }
1810 
1811         // Handle non-overflow cases, 256 by 256 division
1812         if (prod1 == 0) {
1813             require(denominator > 0);
1814             assembly {
1815                 result := div(prod0, denominator)
1816             }
1817             return result;
1818         }
1819 
1820         // Make sure the result is less than 2**256.
1821         // Also prevents denominator == 0
1822         require(denominator > prod1);
1823 
1824         ///////////////////////////////////////////////
1825         // 512 by 256 division.
1826         ///////////////////////////////////////////////
1827 
1828         // Make division exact by subtracting the remainder from [prod1 prod0]
1829         // Compute remainder using mulmod
1830         uint256 remainder;
1831         assembly {
1832             remainder := mulmod(a, b, denominator)
1833         }
1834         // Subtract 256 bit number from 512 bit number
1835         assembly {
1836             prod1 := sub(prod1, gt(remainder, prod0))
1837             prod0 := sub(prod0, remainder)
1838         }
1839 
1840         // Factor powers of two out of denominator
1841         // Compute largest power of two divisor of denominator.
1842         // Always >= 1.
1843         uint256 twos = -denominator & denominator;
1844         // Divide denominator by power of two
1845         assembly {
1846             denominator := div(denominator, twos)
1847         }
1848 
1849         // Divide [prod1 prod0] by the factors of two
1850         assembly {
1851             prod0 := div(prod0, twos)
1852         }
1853         // Shift in bits from prod1 into prod0. For this we need
1854         // to flip `twos` such that it is 2**256 / twos.
1855         // If twos is zero, then it becomes one
1856         assembly {
1857             twos := add(div(sub(0, twos), twos), 1)
1858         }
1859         prod0 |= prod1 * twos;
1860 
1861         // Invert denominator mod 2**256
1862         // Now that denominator is an odd number, it has an inverse
1863         // modulo 2**256 such that denominator * inv = 1 mod 2**256.
1864         // Compute the inverse by starting with a seed that is correct
1865         // correct for four bits. That is, denominator * inv = 1 mod 2**4
1866         uint256 inv = (3 * denominator) ^ 2;
1867         // Now use Newton-Raphson iteration to improve the precision.
1868         // Thanks to Hensel's lifting lemma, this also works in modular
1869         // arithmetic, doubling the correct bits in each step.
1870         inv *= 2 - denominator * inv; // inverse mod 2**8
1871         inv *= 2 - denominator * inv; // inverse mod 2**16
1872         inv *= 2 - denominator * inv; // inverse mod 2**32
1873         inv *= 2 - denominator * inv; // inverse mod 2**64
1874         inv *= 2 - denominator * inv; // inverse mod 2**128
1875         inv *= 2 - denominator * inv; // inverse mod 2**256
1876 
1877         // Because the division is now exact we can divide by multiplying
1878         // with the modular inverse of denominator. This will give us the
1879         // correct result modulo 2**256. Since the precoditions guarantee
1880         // that the outcome is less than 2**256, this is the final result.
1881         // We don't need to compute the high bits of the result and prod1
1882         // is no longer required.
1883         result = prod0 * inv;
1884         return result;
1885     }
1886 
1887     /// @notice Calculates ceil(a×b÷denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
1888     /// @param a The multiplicand
1889     /// @param b The multiplier
1890     /// @param denominator The divisor
1891     /// @return result The 256-bit result
1892     function mulDivRoundingUp(
1893         uint256 a,
1894         uint256 b,
1895         uint256 denominator
1896     ) internal pure returns (uint256 result) {
1897         result = mulDiv(a, b, denominator);
1898         if (mulmod(a, b, denominator) > 0) {
1899             require(result < type(uint256).max);
1900             result++;
1901         }
1902     }
1903 }
1904 
1905 pragma solidity >=0.5.0;
1906 
1907 /// @title Safe casting methods
1908 /// @notice Contains methods for safely casting between types
1909 library SafeCast {
1910     /// @notice Cast a uint256 to a uint160, revert on overflow
1911     /// @param y The uint256 to be downcasted
1912     /// @return z The downcasted integer, now type uint160
1913     function toUint160(uint256 y) internal pure returns (uint160 z) {
1914         require((z = uint160(y)) == y);
1915     }
1916 
1917     /// @notice Cast a uint256 to a uint128, revert on overflow
1918     /// @param y The uint256 to be downcasted
1919     /// @return z The downcasted integer, now type uint128
1920     function toUint128(uint256 y) internal pure returns (uint128 z) {
1921         require((z = uint128(y)) == y);
1922     }
1923 
1924     /// @notice Cast a int256 to a int128, revert on overflow or underflow
1925     /// @param y The int256 to be downcasted
1926     /// @return z The downcasted integer, now type int128
1927     function toInt128(int256 y) internal pure returns (int128 z) {
1928         require((z = int128(y)) == y);
1929     }
1930 
1931     /// @notice Cast a uint256 to a int256, revert on overflow
1932     /// @param y The uint256 to be casted
1933     /// @return z The casted integer, now type int256
1934     function toInt256(uint256 y) internal pure returns (int256 z) {
1935         require(y < 2**255);
1936         z = int256(y);
1937     }
1938 }
1939 
1940 pragma solidity >=0.7.0;
1941 
1942 /// @title Optimized overflow and underflow safe math operations
1943 /// @notice Contains methods for doing math operations that revert on overflow or underflow for minimal gas cost
1944 library LowGasSafeMath {
1945     /// @notice Returns x + y, reverts if sum overflows uint256
1946     /// @param x The augend
1947     /// @param y The addend
1948     /// @return z The sum of x and y
1949     function add(uint256 x, uint256 y) internal pure returns (uint256 z) {
1950         require((z = x + y) >= x);
1951     }
1952 
1953     /// @notice Returns x - y, reverts if underflows
1954     /// @param x The minuend
1955     /// @param y The subtrahend
1956     /// @return z The difference of x and y
1957     function sub(uint256 x, uint256 y) internal pure returns (uint256 z) {
1958         require((z = x - y) <= x);
1959     }
1960 
1961     /// @notice Returns x * y, reverts if overflows
1962     /// @param x The multiplicand
1963     /// @param y The multiplier
1964     /// @return z The product of x and y
1965     function mul(uint256 x, uint256 y) internal pure returns (uint256 z) {
1966         require(x == 0 || (z = x * y) / x == y);
1967     }
1968 
1969     /// @notice Returns x - y, reverts if underflows
1970     /// @param x The minuend
1971     /// @param y The subtrahend
1972     /// @return z The difference of x and y
1973     function sub(uint256 x, uint256 y, string memory errorMessage) internal pure returns (uint256 z) {
1974         require((z = x - y) <= x, errorMessage);
1975     }
1976 
1977     /// @notice Returns x + y, reverts if overflows or underflows
1978     /// @param x The augend
1979     /// @param y The addend
1980     /// @return z The sum of x and y
1981     function add(int256 x, int256 y) internal pure returns (int256 z) {
1982         require((z = x + y) >= x == (y >= 0));
1983     }
1984 
1985     /// @notice Returns x - y, reverts if overflows or underflows
1986     /// @param x The minuend
1987     /// @param y The subtrahend
1988     /// @return z The difference of x and y
1989     function sub(int256 x, int256 y) internal pure returns (int256 z) {
1990         require((z = x - y) <= x == (y >= 0));
1991     }
1992 
1993     /// @notice Returns x + y, reverts if sum overflows uint128
1994     /// @param x The augend
1995     /// @param y The addend
1996     /// @return z The sum of x and y
1997     function add128(uint128 x, uint128 y) internal pure returns (uint128 z) {
1998         require((z = x + y) >= x);
1999     }
2000 
2001     /// @notice Returns x - y, reverts if underflows
2002     /// @param x The minuend
2003     /// @param y The subtrahend
2004     /// @return z The difference of x and y
2005     function sub128(uint128 x, uint128 y) internal pure returns (uint128 z) {
2006         require((z = x - y) <= x);
2007     }
2008 
2009     /// @notice Returns x * y, reverts if overflows
2010     /// @param x The multiplicand
2011     /// @param y The multiplier
2012     /// @return z The product of x and y
2013     function mul128(uint128 x, uint128 y) internal pure returns (uint128 z) {
2014         require(x == 0 || (z = x * y) / x == y);
2015     }
2016 
2017     /// @notice Returns x + y, reverts if sum overflows uint128
2018     /// @param x The augend
2019     /// @param y The addend
2020     /// @return z The sum of x and y
2021     function add160(uint160 x, uint160 y) internal pure returns (uint160 z) {
2022         require((z = x + y) >= x);
2023     }
2024 
2025     /// @notice Returns x - y, reverts if underflows
2026     /// @param x The minuend
2027     /// @param y The subtrahend
2028     /// @return z The difference of x and y
2029     function sub160(uint160 x, uint160 y) internal pure returns (uint160 z) {
2030         require((z = x - y) <= x);
2031     }
2032 
2033     /// @notice Returns x * y, reverts if overflows
2034     /// @param x The multiplicand
2035     /// @param y The multiplier
2036     /// @return z The product of x and y
2037     function mul160(uint160 x, uint160 y) internal pure returns (uint160 z) {
2038         require(x == 0 || (z = x * y) / x == y);
2039     }
2040 }
2041 
2042 pragma solidity >=0.5.0;
2043 
2044 
2045 
2046 
2047 
2048 
2049 /// @title Functions based on Q64.96 sqrt price and liquidity
2050 /// @notice Contains the math that uses square root of price as a Q64.96 and liquidity to compute deltas
2051 library SqrtPriceMath {
2052     using LowGasSafeMath for uint256;
2053     using SafeCast for uint256;
2054 
2055     /// @notice Gets the next sqrt price given a delta of token0
2056     /// @dev Always rounds up, because in the exact output case (increasing price) we need to move the price at least
2057     /// far enough to get the desired output amount, and in the exact input case (decreasing price) we need to move the
2058     /// price less in order to not send too much output.
2059     /// The most precise formula for this is liquidity * sqrtPX96 / (liquidity +- amount * sqrtPX96),
2060     /// if this is impossible because of overflow, we calculate liquidity / (liquidity / sqrtPX96 +- amount).
2061     /// @param sqrtPX96 The starting price, i.e. before accounting for the token0 delta
2062     /// @param liquidity The amount of usable liquidity
2063     /// @param amount How much of token0 to add or remove from virtual reserves
2064     /// @param add Whether to add or remove the amount of token0
2065     /// @return The price after adding or removing amount, depending on add
2066     function getNextSqrtPriceFromAmount0RoundingUp(
2067         uint160 sqrtPX96,
2068         uint128 liquidity,
2069         uint256 amount,
2070         bool add
2071     ) internal pure returns (uint160) {
2072         // we short circuit amount == 0 because the result is otherwise not guaranteed to equal the input price
2073         if (amount == 0) return sqrtPX96;
2074         uint256 numerator1 = uint256(liquidity) << FixedPoint96.RESOLUTION;
2075 
2076         if (add) {
2077             uint256 product;
2078             if ((product = amount * sqrtPX96) / amount == sqrtPX96) {
2079                 uint256 denominator = numerator1 + product;
2080                 if (denominator >= numerator1)
2081                     // always fits in 160 bits
2082                     return uint160(FullMath.mulDivRoundingUp(numerator1, sqrtPX96, denominator));
2083             }
2084 
2085             return uint160(UnsafeMath.divRoundingUp(numerator1, (numerator1 / sqrtPX96).add(amount)));
2086         } else {
2087             uint256 product;
2088             // if the product overflows, we know the denominator underflows
2089             // in addition, we must check that the denominator does not underflow
2090             require((product = amount * sqrtPX96) / amount == sqrtPX96 && numerator1 > product);
2091             uint256 denominator = numerator1 - product;
2092             return FullMath.mulDivRoundingUp(numerator1, sqrtPX96, denominator).toUint160();
2093         }
2094     }
2095 
2096     /// @notice Gets the next sqrt price given a delta of token1
2097     /// @dev Always rounds down, because in the exact output case (decreasing price) we need to move the price at least
2098     /// far enough to get the desired output amount, and in the exact input case (increasing price) we need to move the
2099     /// price less in order to not send too much output.
2100     /// The formula we compute is within <1 wei of the lossless version: sqrtPX96 +- amount / liquidity
2101     /// @param sqrtPX96 The starting price, i.e., before accounting for the token1 delta
2102     /// @param liquidity The amount of usable liquidity
2103     /// @param amount How much of token1 to add, or remove, from virtual reserves
2104     /// @param add Whether to add, or remove, the amount of token1
2105     /// @return The price after adding or removing `amount`
2106     function getNextSqrtPriceFromAmount1RoundingDown(
2107         uint160 sqrtPX96,
2108         uint128 liquidity,
2109         uint256 amount,
2110         bool add
2111     ) internal pure returns (uint160) {
2112         // if we're adding (subtracting), rounding down requires rounding the quotient down (up)
2113         // in both cases, avoid a mulDiv for most inputs
2114         if (add) {
2115             uint256 quotient =
2116                 (
2117                     amount <= type(uint160).max
2118                         ? (amount << FixedPoint96.RESOLUTION) / liquidity
2119                         : FullMath.mulDiv(amount, FixedPoint96.Q96, liquidity)
2120                 );
2121 
2122             return uint256(sqrtPX96).add(quotient).toUint160();
2123         } else {
2124             uint256 quotient =
2125                 (
2126                     amount <= type(uint160).max
2127                         ? UnsafeMath.divRoundingUp(amount << FixedPoint96.RESOLUTION, liquidity)
2128                         : FullMath.mulDivRoundingUp(amount, FixedPoint96.Q96, liquidity)
2129                 );
2130 
2131             require(sqrtPX96 > quotient);
2132             // always fits 160 bits
2133             return uint160(sqrtPX96 - quotient);
2134         }
2135     }
2136 }
2137 
2138 pragma solidity >=0.6.0;
2139 
2140 
2141 library TransferHelper {
2142     /// @notice Transfers tokens from the targeted address to the given destination
2143     /// @notice Errors with 'STF' if transfer fails
2144     /// @param token The contract address of the token to be transferred
2145     /// @param from The originating address from which the tokens will be transferred
2146     /// @param to The destination address of the transfer
2147     /// @param value The amount to be transferred
2148     function safeTransferFrom(
2149         address token,
2150         address from,
2151         address to,
2152         uint256 value
2153     ) internal {
2154         (bool success, bytes memory data) =
2155             token.call(abi.encodeWithSelector(IERC20.transferFrom.selector, from, to, value));
2156         require(success && (data.length == 0 || abi.decode(data, (bool))), 'STF');
2157     }
2158 
2159     /// @notice Transfers tokens from msg.sender to a recipient
2160     /// @dev Errors with ST if transfer fails
2161     /// @param token The contract address of the token which will be transferred
2162     /// @param to The recipient of the transfer
2163     /// @param value The value of the transfer
2164     function safeTransfer(
2165         address token,
2166         address to,
2167         uint256 value
2168     ) internal {
2169         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(IERC20.transfer.selector, to, value));
2170         require(success && (data.length == 0 || abi.decode(data, (bool))), 'ST');
2171     }
2172 
2173     /// @notice Transfers ETH to the recipient address
2174     /// @dev Fails with `STE`
2175     /// @param to The destination of the transfer
2176     /// @param value The value to be transferred
2177     function safeTransferETH(address to, uint256 value) internal {
2178         (bool success, ) = to.call{value: value}(new bytes(0));
2179         require(success, 'STE');
2180     }
2181 }
2182 
2183 
2184 pragma solidity ^0.7.0;
2185 
2186 /**
2187  * @dev Contract module that helps prevent reentrant calls to a function.
2188  *
2189  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
2190  * available, which can be applied to functions to make sure there are no nested
2191  * (reentrant) calls to them.
2192  *
2193  * Note that because there is a single `nonReentrant` guard, functions marked as
2194  * `nonReentrant` may not call one another. This can be worked around by making
2195  * those functions `private`, and then adding `external` `nonReentrant` entry
2196  * points to them.
2197  *
2198  * TIP: If you would like to learn more about reentrancy and alternative ways
2199  * to protect against it, check out our blog post
2200  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
2201  */
2202 abstract contract ReentrancyGuard {
2203     // Booleans are more expensive than uint256 or any type that takes up a full
2204     // word because each write operation emits an extra SLOAD to first read the
2205     // slot's contents, replace the bits taken up by the boolean, and then write
2206     // back. This is the compiler's defense against contract upgrades and
2207     // pointer aliasing, and it cannot be disabled.
2208 
2209     // The values being non-zero value makes deployment a bit more expensive,
2210     // but in exchange the refund on every call to nonReentrant will be lower in
2211     // amount. Since refunds are capped to a percentage of the total
2212     // transaction's gas, it is best to keep them low in cases like this one, to
2213     // increase the likelihood of the full refund coming into effect.
2214     uint256 private constant _NOT_ENTERED = 1;
2215     uint256 private constant _ENTERED = 2;
2216 
2217     uint256 private _status;
2218 
2219     constructor () {
2220         _status = _NOT_ENTERED;
2221     }
2222 
2223     /**
2224      * @dev Prevents a contract from calling itself, directly or indirectly.
2225      * Calling a `nonReentrant` function from another `nonReentrant`
2226      * function is not supported. It is possible to prevent this from happening
2227      * by making the `nonReentrant` function external, and make it call a
2228      * `private` function that does the actual work.
2229      */
2230     modifier nonReentrant() {
2231         // On the first call to nonReentrant, _notEntered will be true
2232         require(_status != _ENTERED, "RC");
2233 
2234         // Any calls to nonReentrant after this point will fail
2235         _status = _ENTERED;
2236 
2237         _;
2238 
2239         // By storing the original value once again, a refund is triggered (see
2240         // https://eips.ethereum.org/EIPS/eip-2200)
2241         _status = _NOT_ENTERED;
2242     }
2243 }
2244 
2245 pragma solidity =0.7.6;
2246 
2247 
2248 /// @title Interface for WETH9
2249 interface IWETH9 is IERC20 {
2250     /// @notice Deposit ether to get wrapped ether
2251     function deposit() external payable;
2252 }
2253 
2254 pragma solidity 0.7.6;
2255 
2256 /// @title Sorbetto Fragola is a yield enchancement v3 contract
2257 /// @dev Sorbetto fragola is a Uniswap V3 yield enchancement contract which acts as
2258 /// intermediary between the user who wants to provide liquidity to specific pools
2259 /// and earn fees from such actions. The contract ensures that user position is in 
2260 /// range and earns maximum amount of fees available at current liquidity utilization
2261 /// rate. 
2262 contract SorbettoFragola is ERC20Permit, ReentrancyGuard, ISorbettoFragola {
2263     using LowGasSafeMath for uint256;
2264     using LowGasSafeMath for uint160;
2265     using LowGasSafeMath for uint128;
2266     using UnsafeMath for uint256;
2267     using SafeCast for uint256;
2268     using PoolVariables for IUniswapV3Pool;
2269     using PoolActions for IUniswapV3Pool;
2270     
2271     //Any data passed through by the caller via the IUniswapV3PoolActions#mint call
2272     struct MintCallbackData {
2273         address payer;
2274     }
2275     //Any data passed through by the caller via the IUniswapV3PoolActions#swap call
2276     struct SwapCallbackData {
2277         bool zeroForOne;
2278     }
2279     // Info of each user
2280     struct UserInfo {
2281         uint256 token0Rewards; // The amount of fees in token 0
2282         uint256 token1Rewards; // The amount of fees in token 1
2283         uint256 token0PerSharePaid; // Token 0 reward debt 
2284         uint256 token1PerSharePaid; // Token 1 reward debt
2285     }
2286 
2287     /// @notice Emitted when user adds liquidity
2288     /// @param sender The address that minted the liquidity
2289     /// @param liquidity The amount of liquidity added by the user to position
2290     /// @param amount0 How much token0 was required for the added liquidity
2291     /// @param amount1 How much token1 was required for the added liquidity
2292     event Deposit(
2293         address indexed sender,
2294         uint256 liquidity,
2295         uint256 amount0,
2296         uint256 amount1
2297     );
2298     
2299     /// @notice Emitted when user withdraws liquidity
2300     /// @param sender The address that minted the liquidity
2301     /// @param shares of liquidity withdrawn by the user from the position
2302     /// @param amount0 How much token0 was required for the added liquidity
2303     /// @param amount1 How much token1 was required for the added liquidity
2304     event Withdraw(
2305         address indexed sender,
2306         uint256 shares,
2307         uint256 amount0,
2308         uint256 amount1
2309     );
2310     
2311     /// @notice Emitted when fees was collected from the pool
2312     /// @param feesFromPool0 Total amount of fees collected in terms of token 0
2313     /// @param feesFromPool1 Total amount of fees collected in terms of token 1
2314     /// @param usersFees0 Total amount of fees collected by users in terms of token 0
2315     /// @param usersFees1 Total amount of fees collected by users in terms of token 1
2316     event CollectFees(
2317         uint256 feesFromPool0,
2318         uint256 feesFromPool1,
2319         uint256 usersFees0,
2320         uint256 usersFees1
2321     );
2322 
2323     /// @notice Emitted when sorbetto fragola changes the position in the pool
2324     /// @param tickLower Lower price tick of the positon
2325     /// @param tickUpper Upper price tick of the position
2326     /// @param amount0 Amount of token 0 deposited to the position
2327     /// @param amount1 Amount of token 1 deposited to the position
2328     event Rerange(
2329         int24 tickLower,
2330         int24 tickUpper,
2331         uint256 amount0,
2332         uint256 amount1
2333     );
2334     
2335     /// @notice Emitted when user collects his fee share
2336     /// @param sender User address
2337     /// @param fees0 Exact amount of fees claimed by the users in terms of token 0 
2338     /// @param fees1 Exact amount of fees claimed by the users in terms of token 1
2339     event RewardPaid(
2340         address indexed sender,
2341         uint256 fees0,
2342         uint256 fees1
2343     );
2344     
2345     /// @notice Shows current Sorbetto's balances
2346     /// @param totalAmount0 Current token0 Sorbetto's balance
2347     /// @param totalAmount1 Current token1 Sorbetto's balance
2348     event Snapshot(uint256 totalAmount0, uint256 totalAmount1);
2349 
2350     event TransferGovernance(address indexed previousGovernance, address indexed newGovernance);
2351     
2352     /// @notice Prevents calls from users
2353     modifier onlyGovernance {
2354         require(msg.sender == governance, "OG");
2355         _;
2356     }
2357     
2358     mapping(address => UserInfo) public userInfo; // Info of each user that provides liquidity tokens.
2359     /// @inheritdoc ISorbettoFragola
2360     address public immutable override token0;
2361     /// @inheritdoc ISorbettoFragola
2362     address public immutable override token1;
2363     // WETH address
2364     address public immutable weth = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
2365     // @inheritdoc ISorbettoFragola
2366     int24 public immutable override tickSpacing;
2367     uint24 immutable GLOBAL_DIVISIONER = 1e6; // for basis point (0.0001%)
2368 
2369     // @inheritdoc ISorbettoFragola
2370     IUniswapV3Pool public override pool;
2371     // Accrued protocol fees in terms of token0
2372     uint256 public accruedProtocolFees0;
2373     // Accrued protocol fees in terms of token1
2374     uint256 public accruedProtocolFees1;
2375     // Total lifetime accrued users fees in terms of token0
2376     uint256 public usersFees0;
2377     // Total lifetime accrued users fees in terms of token1
2378     uint256 public usersFees1;
2379     // intermediate variable for user fee token0 calculation
2380     uint256 public token0PerShareStored;
2381     // intermediate variable for user fee token1 calculation
2382     uint256 public token1PerShareStored;
2383     
2384     // Address of the Sorbetto's owner
2385     address public governance;
2386     // Pending to claim ownership address
2387     address public pendingGovernance;
2388     //Sorbetto fragola settings address
2389     address public strategy;
2390     // Current tick lower of sorbetto pool position
2391     int24 public override tickLower;
2392     // Current tick higher of sorbetto pool position
2393     int24 public override tickUpper;
2394     // Checks if sorbetto is initialized
2395     bool public finalized;
2396     
2397     /**
2398      * @dev After deploying, strategy can be set via `setStrategy()`
2399      * @param _pool Underlying Uniswap V3 pool with fee = 3000
2400      * @param _strategy Underlying Sorbetto Strategy for Sorbetto settings
2401      */
2402      constructor(
2403         address _pool,
2404         address _strategy
2405     ) ERC20("Popsicle LP V3 USDT/WETH", "PLP") ERC20Permit("Popsicle LP V3 USDT/WETH") {
2406         pool = IUniswapV3Pool(_pool);
2407         strategy = _strategy;
2408         token0 = pool.token0();
2409         token1 = pool.token1();
2410         tickSpacing = pool.tickSpacing();
2411         governance = msg.sender;
2412     }
2413     //initialize strategy
2414     function init() external onlyGovernance {
2415         require(!finalized, "F");
2416         finalized = true;
2417         int24 baseThreshold = tickSpacing * ISorbettoStrategy(strategy).tickRangeMultiplier();
2418         ( , int24 currentTick, , , , , ) = pool.slot0();
2419         int24 tickFloor = PoolVariables.floor(currentTick, tickSpacing);
2420         
2421         tickLower = tickFloor - baseThreshold;
2422         tickUpper = tickFloor + baseThreshold;
2423         PoolVariables.checkRange(tickLower, tickUpper); //check ticks also for overflow/underflow
2424     }
2425     
2426     /// @inheritdoc ISorbettoFragola
2427      function deposit(
2428         uint256 amount0Desired,
2429         uint256 amount1Desired
2430     )
2431         external
2432         payable
2433         override
2434         nonReentrant
2435         checkDeviation
2436         updateVault(msg.sender)
2437         returns (
2438             uint256 shares,
2439             uint256 amount0,
2440             uint256 amount1
2441         )
2442     {
2443         require(amount0Desired > 0 && amount1Desired > 0, "ANV");
2444         uint128 liquidityLast = pool.positionLiquidity(tickLower, tickUpper);
2445         // compute the liquidity amount
2446         uint128 liquidity = pool.liquidityForAmounts(amount0Desired, amount1Desired, tickLower, tickUpper);
2447         
2448         (amount0, amount1) = pool.mint(
2449             address(this),
2450             tickLower,
2451             tickUpper,
2452             liquidity,
2453             abi.encode(MintCallbackData({payer: msg.sender})));
2454 
2455         shares = _calcShare(liquidity, liquidityLast);
2456 
2457         _mint(msg.sender, shares);
2458         refundETH();
2459         emit Deposit(msg.sender, shares, amount0, amount1);
2460     }
2461     
2462     /// @inheritdoc ISorbettoFragola
2463     function withdraw(
2464         uint256 shares
2465     ) 
2466         external
2467         override
2468         nonReentrant
2469         checkDeviation
2470         updateVault(msg.sender)
2471         returns (
2472             uint256 amount0,
2473             uint256 amount1
2474         )
2475     {
2476         require(shares > 0, "S");
2477 
2478 
2479         (amount0, amount1) = pool.burnLiquidityShare(tickLower, tickUpper, totalSupply(), shares,  msg.sender);
2480         
2481         // Burn shares
2482         _burn(msg.sender, shares);
2483         emit Withdraw(msg.sender, shares, amount0, amount1);
2484     }
2485     
2486     /// @inheritdoc ISorbettoFragola
2487     function rerange() external override nonReentrant checkDeviation updateVault(address(0)) {
2488 
2489         //Burn all liquidity from pool to rerange for Sorbetto's balances.
2490         pool.burnAllLiquidity(tickLower, tickUpper);
2491         
2492 
2493         // Emit snapshot to record balances
2494         uint256 balance0 = _balance0();
2495         uint256 balance1 = _balance1();
2496         emit Snapshot(balance0, balance1);
2497 
2498         int24 baseThreshold = tickSpacing * ISorbettoStrategy(strategy).tickRangeMultiplier();
2499 
2500         //Get exact ticks depending on Sorbetto's balances
2501         (tickLower, tickUpper) = pool.getPositionTicks(balance0, balance1, baseThreshold, tickSpacing);
2502 
2503         //Get Liquidity for Sorbetto's balances
2504         uint128 liquidity = pool.liquidityForAmounts(balance0, balance1, tickLower, tickUpper);
2505         
2506         // Add liquidity to the pool
2507         (uint256 amount0, uint256 amount1) = pool.mint(
2508             address(this),
2509             tickLower,
2510             tickUpper,
2511             liquidity,
2512             abi.encode(MintCallbackData({payer: address(this)})));
2513         
2514         emit Rerange(tickLower, tickUpper, amount0, amount1);
2515     }
2516 
2517     /// @inheritdoc ISorbettoFragola
2518     function rebalance() external override onlyGovernance nonReentrant checkDeviation updateVault(address(0))  {
2519 
2520         //Burn all liquidity from pool to rerange for Sorbetto's balances.
2521         pool.burnAllLiquidity(tickLower, tickUpper);
2522         
2523         //Calc base ticks
2524         (uint160 sqrtPriceX96, int24 currentTick, , , , , ) = pool.slot0();
2525         PoolVariables.Info memory cache = 
2526             PoolVariables.Info(0, 0, 0, 0, 0, 0, 0);
2527         int24 baseThreshold = tickSpacing * ISorbettoStrategy(strategy).tickRangeMultiplier();
2528         (cache.tickLower, cache.tickUpper) = PoolVariables.baseTicks(currentTick, baseThreshold, tickSpacing);
2529         
2530         cache.amount0Desired = _balance0();
2531         cache.amount1Desired = _balance1();
2532         emit Snapshot(cache.amount0Desired, cache.amount1Desired);
2533         // Calc liquidity for base ticks
2534         cache.liquidity = pool.liquidityForAmounts(cache.amount0Desired, cache.amount1Desired, cache.tickLower, cache.tickUpper);
2535 
2536         // Get exact amounts for base ticks
2537         (cache.amount0, cache.amount1) = pool.amountsForLiquidity(cache.liquidity, cache.tickLower, cache.tickUpper);
2538 
2539         // Get imbalanced token
2540         bool zeroForOne = PoolVariables.amountsDirection(cache.amount0Desired, cache.amount1Desired, cache.amount0, cache.amount1);
2541         // Calculate the amount of imbalanced token that should be swapped. Calculations strive to achieve one to one ratio
2542         int256 amountSpecified = 
2543             zeroForOne
2544                 ? int256(cache.amount0Desired.sub(cache.amount0).unsafeDiv(2))
2545                 : int256(cache.amount1Desired.sub(cache.amount1).unsafeDiv(2)); // always positive. "overflow" safe convertion cuz we are dividing by 2
2546 
2547         // Calculate Price limit depending on price impact
2548         uint160 exactSqrtPriceImpact = sqrtPriceX96.mul160(ISorbettoStrategy(strategy).priceImpactPercentage() / 2) / GLOBAL_DIVISIONER;
2549         uint160 sqrtPriceLimitX96 = zeroForOne ?  sqrtPriceX96.sub160(exactSqrtPriceImpact) : sqrtPriceX96.add160(exactSqrtPriceImpact);
2550 
2551         //Swap imbalanced token as long as we haven't used the entire amountSpecified and haven't reached the price limit
2552         pool.swap(
2553             address(this),
2554             zeroForOne,
2555             amountSpecified,
2556             sqrtPriceLimitX96,
2557             abi.encode(SwapCallbackData({zeroForOne: zeroForOne}))
2558         );
2559 
2560 
2561         (sqrtPriceX96, currentTick, , , , , ) = pool.slot0();
2562 
2563         // Emit snapshot to record balances
2564         cache.amount0Desired = _balance0();
2565         cache.amount1Desired = _balance1();
2566         emit Snapshot(cache.amount0Desired, cache.amount1Desired);
2567         //Get exact ticks depending on Sorbetto's new balances
2568         (tickLower, tickUpper) = pool.getPositionTicks(cache.amount0Desired, cache.amount1Desired, baseThreshold, tickSpacing);
2569 
2570         cache.liquidity = pool.liquidityForAmounts(cache.amount0Desired, cache.amount1Desired, tickLower, tickUpper);
2571 
2572         // Add liquidity to the pool
2573         (cache.amount0, cache.amount1) = pool.mint(
2574             address(this),
2575             tickLower,
2576             tickUpper,
2577             cache.liquidity,
2578             abi.encode(MintCallbackData({payer: address(this)})));
2579         emit Rerange(tickLower, tickUpper, cache.amount0, cache.amount1);
2580     }
2581 
2582     // Calcs user share depending on deposited amounts
2583     function _calcShare(uint128 liquidity, uint128 liquidityLast)
2584         internal
2585         view
2586         returns (
2587             uint256 shares
2588         )
2589     {
2590         shares = totalSupply() == 0 ? uint256(liquidity) : uint256(liquidity).mul(totalSupply()).unsafeDiv(uint256(liquidityLast));
2591     }
2592     
2593     /// @dev Amount of token0 held as unused balance.
2594     function _balance0() internal view returns (uint256) {
2595         return IERC20(token0).balanceOf(address(this));
2596     }
2597 
2598     /// @dev Amount of token1 held as unused balance.
2599     function _balance1() internal view returns (uint256) {
2600         return IERC20(token1).balanceOf(address(this));
2601     }
2602     
2603     /// @dev collects fees from the pool
2604     function _earnFees() internal returns (uint256 userCollect0, uint256 userCollect1) {
2605          // Do zero-burns to poke the Uniswap pools so earned fees are updated
2606         pool.burn(tickLower, tickUpper, 0);
2607         
2608         (uint256 collect0, uint256 collect1) =
2609             pool.collect(
2610                 address(this),
2611                 tickLower,
2612                 tickUpper,
2613                 type(uint128).max,
2614                 type(uint128).max
2615             );
2616 
2617         // Calculate protocol's and users share of fees
2618         uint256 feeToProtocol0 = collect0.mul(ISorbettoStrategy(strategy).protocolFee()).unsafeDiv(GLOBAL_DIVISIONER);
2619         uint256 feeToProtocol1 = collect1.mul(ISorbettoStrategy(strategy).protocolFee()).unsafeDiv(GLOBAL_DIVISIONER);
2620         accruedProtocolFees0 = accruedProtocolFees0.add(feeToProtocol0);
2621         accruedProtocolFees1 = accruedProtocolFees1.add(feeToProtocol1);
2622         userCollect0 = collect0.sub(feeToProtocol0);
2623         userCollect1 = collect1.sub(feeToProtocol1);
2624         usersFees0 = usersFees0.add(userCollect0);
2625         usersFees1 = usersFees1.add(userCollect1);
2626         emit CollectFees(collect0, collect1, usersFees0, usersFees1);
2627     }
2628 
2629     /// @notice Returns current Sorbetto's position in pool
2630     function position() external view returns (uint128 liquidity, uint256 feeGrowthInside0LastX128, uint256 feeGrowthInside1LastX128, uint128 tokensOwed0, uint128 tokensOwed1) {
2631         bytes32 positionKey = PositionKey.compute(address(this), tickLower, tickUpper);
2632         (liquidity, feeGrowthInside0LastX128, feeGrowthInside1LastX128, tokensOwed0, tokensOwed1) = pool.positions(positionKey);
2633     }
2634     
2635     /// @notice Pull in tokens from sender. Called to `msg.sender` after minting liquidity to a position from IUniswapV3Pool#mint.
2636     /// @dev In the implementation you must pay to the pool for the minted liquidity.
2637     /// @param amount0 The amount of token0 due to the pool for the minted liquidity
2638     /// @param amount1 The amount of token1 due to the pool for the minted liquidity
2639     /// @param data Any data passed through by the caller via the IUniswapV3PoolActions#mint call
2640     function uniswapV3MintCallback(
2641         uint256 amount0,
2642         uint256 amount1,
2643         bytes calldata data
2644     ) external {
2645         require(msg.sender == address(pool), "FP");
2646         MintCallbackData memory decoded = abi.decode(data, (MintCallbackData));
2647         if (amount0 > 0) pay(token0, decoded.payer, msg.sender, amount0);
2648         if (amount1 > 0) pay(token1, decoded.payer, msg.sender, amount1);
2649     }
2650 
2651     /// @notice Called to `msg.sender` after minting swaping from IUniswapV3Pool#swap.
2652     /// @dev In the implementation you must pay to the pool for swap.
2653     /// @param amount0 The amount of token0 due to the pool for the swap
2654     /// @param amount1 The amount of token1 due to the pool for the swap
2655     /// @param _data Any data passed through by the caller via the IUniswapV3PoolActions#swap call
2656     function uniswapV3SwapCallback(
2657         int256 amount0,
2658         int256 amount1,
2659         bytes calldata _data
2660     ) external {
2661         require(msg.sender == address(pool), "FP");
2662         require(amount0 > 0 || amount1 > 0); // swaps entirely within 0-liquidity regions are not supported
2663         SwapCallbackData memory data = abi.decode(_data, (SwapCallbackData));
2664         bool zeroForOne = data.zeroForOne;
2665 
2666         if (zeroForOne) pay(token0, address(this), msg.sender, uint256(amount0)); 
2667         else pay(token1, address(this), msg.sender, uint256(amount1));
2668     }
2669 
2670     /// @param token The token to pay
2671     /// @param payer The entity that must pay
2672     /// @param recipient The entity that will receive payment
2673     /// @param value The amount to pay
2674     function pay(
2675         address token,
2676         address payer,
2677         address recipient,
2678         uint256 value
2679     ) internal {
2680         if (token == weth && address(this).balance >= value) {
2681             // pay with WETH9
2682             IWETH9(weth).deposit{value: value}(); // wrap only what is needed to pay
2683             IWETH9(weth).transfer(recipient, value);
2684         } else if (payer == address(this)) {
2685             // pay with tokens already in the contract (for the exact input multihop case)
2686             TransferHelper.safeTransfer(token, recipient, value);
2687         } else {
2688             // pull payment
2689             TransferHelper.safeTransferFrom(token, payer, recipient, value);
2690         }
2691     }
2692     
2693     
2694     /**
2695      * @notice Used to withdraw accumulated protocol fees.
2696      */
2697     function collectProtocolFees(
2698         uint256 amount0,
2699         uint256 amount1
2700     ) external nonReentrant onlyGovernance updateVault(address(0)) {
2701         require(accruedProtocolFees0 >= amount0, "A0F");
2702         require(accruedProtocolFees1 >= amount1, "A1F");
2703         
2704         uint256 balance0 = _balance0();
2705         uint256 balance1 = _balance1();
2706         
2707         if (balance0 >= amount0 && balance1 >= amount1)
2708         {
2709             if (amount0 > 0) pay(token0, address(this), msg.sender, amount0);
2710             if (amount1 > 0) pay(token1, address(this), msg.sender, amount1);
2711         }
2712         else
2713         {
2714             uint128 liquidity = pool.liquidityForAmounts(amount0, amount1, tickLower, tickUpper);
2715             pool.burnExactLiquidity(tickLower, tickUpper, liquidity, msg.sender);
2716         
2717         }
2718         
2719         accruedProtocolFees0 = accruedProtocolFees0.sub(amount0);
2720         accruedProtocolFees1 = accruedProtocolFees1.sub(amount1);
2721         emit RewardPaid(msg.sender, amount0, amount1);
2722     }
2723     
2724     /**
2725      * @notice Used to withdraw accumulated user's fees.
2726      */
2727     function collectFees(uint256 amount0, uint256 amount1) external nonReentrant updateVault(msg.sender) {
2728         UserInfo storage user = userInfo[msg.sender];
2729 
2730         require(user.token0Rewards >= amount0, "A0R");
2731         require(user.token1Rewards >= amount1, "A1R");
2732 
2733         uint256 balance0 = _balance0();
2734         uint256 balance1 = _balance1();
2735 
2736         if (balance0 >= amount0 && balance1 >= amount1) {
2737 
2738             if (amount0 > 0) pay(token0, address(this), msg.sender, amount0);
2739             if (amount1 > 0) pay(token1, address(this), msg.sender, amount1);
2740         }
2741         else {
2742             
2743             uint128 liquidity = pool.liquidityForAmounts(amount0, amount1, tickLower, tickUpper);
2744             (amount0, amount1) = pool.burnExactLiquidity(tickLower, tickUpper, liquidity, msg.sender);
2745         }
2746         user.token0Rewards = user.token0Rewards.sub(amount0);
2747         user.token1Rewards = user.token1Rewards.sub(amount1);
2748         emit RewardPaid(msg.sender, amount0, amount1);
2749     }
2750     
2751     // Function modifier that calls update fees reward function
2752     modifier updateVault(address account) {
2753         _updateFeesReward(account);
2754         _;
2755     }
2756 
2757     // Function modifier that checks if price has not moved a lot recently.
2758     // This mitigates price manipulation during rebalance and also prevents placing orders
2759     // when it's too volatile.
2760     modifier checkDeviation() {
2761         pool.checkDeviation(ISorbettoStrategy(strategy).maxTwapDeviation(), ISorbettoStrategy(strategy).twapDuration());
2762         _;
2763     }
2764     
2765     // Updates user's fees reward
2766     function _updateFeesReward(address account) internal {
2767         uint liquidity = pool.positionLiquidity(tickLower, tickUpper);
2768         if (liquidity == 0) return; // we can't poke when liquidity is zero
2769         (uint256 collect0, uint256 collect1) = _earnFees();
2770         
2771         
2772         token0PerShareStored = _tokenPerShare(collect0, token0PerShareStored);
2773         token1PerShareStored = _tokenPerShare(collect1, token1PerShareStored);
2774 
2775         if (account != address(0)) {
2776             UserInfo storage user = userInfo[msg.sender];
2777             user.token0Rewards = _fee0Earned(account, token0PerShareStored);
2778             user.token0PerSharePaid = token0PerShareStored;
2779             
2780             user.token1Rewards = _fee1Earned(account, token1PerShareStored);
2781             user.token1PerSharePaid = token1PerShareStored;
2782         }
2783     }
2784     
2785     // Calculates how much token0 is entitled for a particular user
2786     function _fee0Earned(address account, uint256 fee0PerShare_) internal view returns (uint256) {
2787         UserInfo memory user = userInfo[account];
2788         return
2789             balanceOf(account)
2790             .mul(fee0PerShare_.sub(user.token0PerSharePaid))
2791             .unsafeDiv(1e18)
2792             .add(user.token0Rewards);
2793     }
2794     
2795     // Calculates how much token1 is entitled for a particular user
2796     function _fee1Earned(address account, uint256 fee1PerShare_) internal view returns (uint256) {
2797         UserInfo memory user = userInfo[account];
2798         return
2799             balanceOf(account)
2800             .mul(fee1PerShare_.sub(user.token1PerSharePaid))
2801             .unsafeDiv(1e18)
2802             .add(user.token1Rewards);
2803     }
2804     
2805     // Calculates how much token is provided per LP token 
2806     function _tokenPerShare(uint256 collected, uint256 tokenPerShareStored) internal view returns (uint256) {
2807         uint _totalSupply = totalSupply();
2808         if (_totalSupply > 0) {
2809             return tokenPerShareStored
2810             .add(
2811                 collected
2812                 .mul(1e18)
2813                 .unsafeDiv(_totalSupply)
2814             );
2815         }
2816         return tokenPerShareStored;
2817     }
2818     
2819     /// @notice Refunds any ETH balance held by this contract to the `msg.sender`
2820     /// @dev Useful for bundling with mint or increase liquidity that uses ether, or exact output swaps
2821     /// that use ether for the input amount
2822     function refundETH() internal {
2823         if (address(this).balance > 0) TransferHelper.safeTransferETH(msg.sender, address(this).balance);
2824     }
2825 
2826     /**
2827      * @notice `setGovernance()` should be called by the existing governance
2828      * address prior to calling this function.
2829      */
2830     function setGovernance(address _governance) external onlyGovernance {
2831         pendingGovernance = _governance;
2832     }
2833 
2834     /**
2835      * @notice Governance address is not updated until the new governance
2836      * address has called `acceptGovernance()` to accept this responsibility.
2837      */
2838     function acceptGovernance() external {
2839         require(msg.sender == pendingGovernance, "PG");
2840         emit TransferGovernance(governance, pendingGovernance);
2841         pendingGovernance = address(0);
2842         governance = msg.sender;
2843     }
2844 
2845     // Sets new strategy contract address for new settings
2846     function setStrategy(address _strategy) external onlyGovernance {
2847         require(_strategy != address(0), "NA");
2848         strategy = _strategy;
2849     }
2850 }