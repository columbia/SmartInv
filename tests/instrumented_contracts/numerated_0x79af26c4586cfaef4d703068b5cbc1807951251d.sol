1 // Sources flattened with hardhat v2.2.1 https://hardhat.org
2 
3 // File @uniswap/v3-core/contracts/libraries/TickMath.sol@v1.0.0
4 
5 pragma solidity >=0.5.0;
6 
7 /// @title Math library for computing sqrt prices from ticks and vice versa
8 /// @notice Computes sqrt price for ticks of size 1.0001, i.e. sqrt(1.0001^tick) as fixed point Q64.96 numbers. Supports
9 /// prices between 2**-128 and 2**128
10 library TickMath {
11     /// @dev The minimum tick that may be passed to #getSqrtRatioAtTick computed from log base 1.0001 of 2**-128
12     int24 internal constant MIN_TICK = -887272;
13     /// @dev The maximum tick that may be passed to #getSqrtRatioAtTick computed from log base 1.0001 of 2**128
14     int24 internal constant MAX_TICK = -MIN_TICK;
15 
16     /// @dev The minimum value that can be returned from #getSqrtRatioAtTick. Equivalent to getSqrtRatioAtTick(MIN_TICK)
17     uint160 internal constant MIN_SQRT_RATIO = 4295128739;
18     /// @dev The maximum value that can be returned from #getSqrtRatioAtTick. Equivalent to getSqrtRatioAtTick(MAX_TICK)
19     uint160 internal constant MAX_SQRT_RATIO = 1461446703485210103287273052203988822378723970342;
20 
21     /// @notice Calculates sqrt(1.0001^tick) * 2^96
22     /// @dev Throws if |tick| > max tick
23     /// @param tick The input tick for the above formula
24     /// @return sqrtPriceX96 A Fixed point Q64.96 number representing the sqrt of the ratio of the two assets (token1/token0)
25     /// at the given tick
26     function getSqrtRatioAtTick(int24 tick) internal pure returns (uint160 sqrtPriceX96) {
27         uint256 absTick = tick < 0 ? uint256(-int256(tick)) : uint256(int256(tick));
28         require(absTick <= uint256(MAX_TICK), 'T');
29 
30         uint256 ratio = absTick & 0x1 != 0 ? 0xfffcb933bd6fad37aa2d162d1a594001 : 0x100000000000000000000000000000000;
31         if (absTick & 0x2 != 0) ratio = (ratio * 0xfff97272373d413259a46990580e213a) >> 128;
32         if (absTick & 0x4 != 0) ratio = (ratio * 0xfff2e50f5f656932ef12357cf3c7fdcc) >> 128;
33         if (absTick & 0x8 != 0) ratio = (ratio * 0xffe5caca7e10e4e61c3624eaa0941cd0) >> 128;
34         if (absTick & 0x10 != 0) ratio = (ratio * 0xffcb9843d60f6159c9db58835c926644) >> 128;
35         if (absTick & 0x20 != 0) ratio = (ratio * 0xff973b41fa98c081472e6896dfb254c0) >> 128;
36         if (absTick & 0x40 != 0) ratio = (ratio * 0xff2ea16466c96a3843ec78b326b52861) >> 128;
37         if (absTick & 0x80 != 0) ratio = (ratio * 0xfe5dee046a99a2a811c461f1969c3053) >> 128;
38         if (absTick & 0x100 != 0) ratio = (ratio * 0xfcbe86c7900a88aedcffc83b479aa3a4) >> 128;
39         if (absTick & 0x200 != 0) ratio = (ratio * 0xf987a7253ac413176f2b074cf7815e54) >> 128;
40         if (absTick & 0x400 != 0) ratio = (ratio * 0xf3392b0822b70005940c7a398e4b70f3) >> 128;
41         if (absTick & 0x800 != 0) ratio = (ratio * 0xe7159475a2c29b7443b29c7fa6e889d9) >> 128;
42         if (absTick & 0x1000 != 0) ratio = (ratio * 0xd097f3bdfd2022b8845ad8f792aa5825) >> 128;
43         if (absTick & 0x2000 != 0) ratio = (ratio * 0xa9f746462d870fdf8a65dc1f90e061e5) >> 128;
44         if (absTick & 0x4000 != 0) ratio = (ratio * 0x70d869a156d2a1b890bb3df62baf32f7) >> 128;
45         if (absTick & 0x8000 != 0) ratio = (ratio * 0x31be135f97d08fd981231505542fcfa6) >> 128;
46         if (absTick & 0x10000 != 0) ratio = (ratio * 0x9aa508b5b7a84e1c677de54f3e99bc9) >> 128;
47         if (absTick & 0x20000 != 0) ratio = (ratio * 0x5d6af8dedb81196699c329225ee604) >> 128;
48         if (absTick & 0x40000 != 0) ratio = (ratio * 0x2216e584f5fa1ea926041bedfe98) >> 128;
49         if (absTick & 0x80000 != 0) ratio = (ratio * 0x48a170391f7dc42444e8fa2) >> 128;
50 
51         if (tick > 0) ratio = type(uint256).max / ratio;
52 
53         // this divides by 1<<32 rounding up to go from a Q128.128 to a Q128.96.
54         // we then downcast because we know the result always fits within 160 bits due to our tick input constraint
55         // we round up in the division so getTickAtSqrtRatio of the output price is always consistent
56         sqrtPriceX96 = uint160((ratio >> 32) + (ratio % (1 << 32) == 0 ? 0 : 1));
57     }
58 
59     /// @notice Calculates the greatest tick value such that getRatioAtTick(tick) <= ratio
60     /// @dev Throws in case sqrtPriceX96 < MIN_SQRT_RATIO, as MIN_SQRT_RATIO is the lowest value getRatioAtTick may
61     /// ever return.
62     /// @param sqrtPriceX96 The sqrt ratio for which to compute the tick as a Q64.96
63     /// @return tick The greatest tick for which the ratio is less than or equal to the input ratio
64     function getTickAtSqrtRatio(uint160 sqrtPriceX96) internal pure returns (int24 tick) {
65         // second inequality must be < because the price can never reach the price at the max tick
66         require(sqrtPriceX96 >= MIN_SQRT_RATIO && sqrtPriceX96 < MAX_SQRT_RATIO, 'R');
67         uint256 ratio = uint256(sqrtPriceX96) << 32;
68 
69         uint256 r = ratio;
70         uint256 msb = 0;
71 
72         assembly {
73             let f := shl(7, gt(r, 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF))
74             msb := or(msb, f)
75             r := shr(f, r)
76         }
77         assembly {
78             let f := shl(6, gt(r, 0xFFFFFFFFFFFFFFFF))
79             msb := or(msb, f)
80             r := shr(f, r)
81         }
82         assembly {
83             let f := shl(5, gt(r, 0xFFFFFFFF))
84             msb := or(msb, f)
85             r := shr(f, r)
86         }
87         assembly {
88             let f := shl(4, gt(r, 0xFFFF))
89             msb := or(msb, f)
90             r := shr(f, r)
91         }
92         assembly {
93             let f := shl(3, gt(r, 0xFF))
94             msb := or(msb, f)
95             r := shr(f, r)
96         }
97         assembly {
98             let f := shl(2, gt(r, 0xF))
99             msb := or(msb, f)
100             r := shr(f, r)
101         }
102         assembly {
103             let f := shl(1, gt(r, 0x3))
104             msb := or(msb, f)
105             r := shr(f, r)
106         }
107         assembly {
108             let f := gt(r, 0x1)
109             msb := or(msb, f)
110         }
111 
112         if (msb >= 128) r = ratio >> (msb - 127);
113         else r = ratio << (127 - msb);
114 
115         int256 log_2 = (int256(msb) - 128) << 64;
116 
117         assembly {
118             r := shr(127, mul(r, r))
119             let f := shr(128, r)
120             log_2 := or(log_2, shl(63, f))
121             r := shr(f, r)
122         }
123         assembly {
124             r := shr(127, mul(r, r))
125             let f := shr(128, r)
126             log_2 := or(log_2, shl(62, f))
127             r := shr(f, r)
128         }
129         assembly {
130             r := shr(127, mul(r, r))
131             let f := shr(128, r)
132             log_2 := or(log_2, shl(61, f))
133             r := shr(f, r)
134         }
135         assembly {
136             r := shr(127, mul(r, r))
137             let f := shr(128, r)
138             log_2 := or(log_2, shl(60, f))
139             r := shr(f, r)
140         }
141         assembly {
142             r := shr(127, mul(r, r))
143             let f := shr(128, r)
144             log_2 := or(log_2, shl(59, f))
145             r := shr(f, r)
146         }
147         assembly {
148             r := shr(127, mul(r, r))
149             let f := shr(128, r)
150             log_2 := or(log_2, shl(58, f))
151             r := shr(f, r)
152         }
153         assembly {
154             r := shr(127, mul(r, r))
155             let f := shr(128, r)
156             log_2 := or(log_2, shl(57, f))
157             r := shr(f, r)
158         }
159         assembly {
160             r := shr(127, mul(r, r))
161             let f := shr(128, r)
162             log_2 := or(log_2, shl(56, f))
163             r := shr(f, r)
164         }
165         assembly {
166             r := shr(127, mul(r, r))
167             let f := shr(128, r)
168             log_2 := or(log_2, shl(55, f))
169             r := shr(f, r)
170         }
171         assembly {
172             r := shr(127, mul(r, r))
173             let f := shr(128, r)
174             log_2 := or(log_2, shl(54, f))
175             r := shr(f, r)
176         }
177         assembly {
178             r := shr(127, mul(r, r))
179             let f := shr(128, r)
180             log_2 := or(log_2, shl(53, f))
181             r := shr(f, r)
182         }
183         assembly {
184             r := shr(127, mul(r, r))
185             let f := shr(128, r)
186             log_2 := or(log_2, shl(52, f))
187             r := shr(f, r)
188         }
189         assembly {
190             r := shr(127, mul(r, r))
191             let f := shr(128, r)
192             log_2 := or(log_2, shl(51, f))
193             r := shr(f, r)
194         }
195         assembly {
196             r := shr(127, mul(r, r))
197             let f := shr(128, r)
198             log_2 := or(log_2, shl(50, f))
199         }
200 
201         int256 log_sqrt10001 = log_2 * 255738958999603826347141; // 128.128 number
202 
203         int24 tickLow = int24((log_sqrt10001 - 3402992956809132418596140100660247210) >> 128);
204         int24 tickHi = int24((log_sqrt10001 + 291339464771989622907027621153398088495) >> 128);
205 
206         tick = tickLow == tickHi ? tickLow : getSqrtRatioAtTick(tickHi) <= sqrtPriceX96 ? tickHi : tickLow;
207     }
208 }
209 
210 
211 // File @uniswap/v3-core/contracts/interfaces/IUniswapV3Factory.sol@v1.0.0
212 
213 pragma solidity >=0.5.0;
214 
215 /// @title The interface for the Uniswap V3 Factory
216 /// @notice The Uniswap V3 Factory facilitates creation of Uniswap V3 pools and control over the protocol fees
217 interface IUniswapV3Factory {
218     /// @notice Emitted when the owner of the factory is changed
219     /// @param oldOwner The owner before the owner was changed
220     /// @param newOwner The owner after the owner was changed
221     event OwnerChanged(address indexed oldOwner, address indexed newOwner);
222 
223     /// @notice Emitted when a pool is created
224     /// @param token0 The first token of the pool by address sort order
225     /// @param token1 The second token of the pool by address sort order
226     /// @param fee The fee collected upon every swap in the pool, denominated in hundredths of a bip
227     /// @param tickSpacing The minimum number of ticks between initialized ticks
228     /// @param pool The address of the created pool
229     event PoolCreated(
230         address indexed token0,
231         address indexed token1,
232         uint24 indexed fee,
233         int24 tickSpacing,
234         address pool
235     );
236 
237     /// @notice Emitted when a new fee amount is enabled for pool creation via the factory
238     /// @param fee The enabled fee, denominated in hundredths of a bip
239     /// @param tickSpacing The minimum number of ticks between initialized ticks for pools created with the given fee
240     event FeeAmountEnabled(uint24 indexed fee, int24 indexed tickSpacing);
241 
242     /// @notice Returns the current owner of the factory
243     /// @dev Can be changed by the current owner via setOwner
244     /// @return The address of the factory owner
245     function owner() external view returns (address);
246 
247     /// @notice Returns the tick spacing for a given fee amount, if enabled, or 0 if not enabled
248     /// @dev A fee amount can never be removed, so this value should be hard coded or cached in the calling context
249     /// @param fee The enabled fee, denominated in hundredths of a bip. Returns 0 in case of unenabled fee
250     /// @return The tick spacing
251     function feeAmountTickSpacing(uint24 fee) external view returns (int24);
252 
253     /// @notice Returns the pool address for a given pair of tokens and a fee, or address 0 if it does not exist
254     /// @dev tokenA and tokenB may be passed in either token0/token1 or token1/token0 order
255     /// @param tokenA The contract address of either token0 or token1
256     /// @param tokenB The contract address of the other token
257     /// @param fee The fee collected upon every swap in the pool, denominated in hundredths of a bip
258     /// @return pool The pool address
259     function getPool(
260         address tokenA,
261         address tokenB,
262         uint24 fee
263     ) external view returns (address pool);
264 
265     /// @notice Creates a pool for the given two tokens and fee
266     /// @param tokenA One of the two tokens in the desired pool
267     /// @param tokenB The other of the two tokens in the desired pool
268     /// @param fee The desired fee for the pool
269     /// @dev tokenA and tokenB may be passed in either order: token0/token1 or token1/token0. tickSpacing is retrieved
270     /// from the fee. The call will revert if the pool already exists, the fee is invalid, or the token arguments
271     /// are invalid.
272     /// @return pool The address of the newly created pool
273     function createPool(
274         address tokenA,
275         address tokenB,
276         uint24 fee
277     ) external returns (address pool);
278 
279     /// @notice Updates the owner of the factory
280     /// @dev Must be called by the current owner
281     /// @param _owner The new owner of the factory
282     function setOwner(address _owner) external;
283 
284     /// @notice Enables a fee amount with the given tickSpacing
285     /// @dev Fee amounts may never be removed once enabled
286     /// @param fee The fee amount to enable, denominated in hundredths of a bip (i.e. 1e-6)
287     /// @param tickSpacing The spacing between ticks to be enforced for all pools created with the given fee amount
288     function enableFeeAmount(uint24 fee, int24 tickSpacing) external;
289 }
290 
291 
292 // File @uniswap/v3-periphery/contracts/libraries/PoolAddress.sol@v1.2.1
293 
294 pragma solidity >=0.5.0;
295 
296 /// @title Provides functions for deriving a pool address from the factory, tokens, and the fee
297 library PoolAddress {
298     bytes32 internal constant POOL_INIT_CODE_HASH = 0xe34f199b19b2b4f47f68442619d555527d244f78a3297ea89325f843f87b8b54;
299 
300     /// @notice The identifying key of the pool
301     struct PoolKey {
302         address token0;
303         address token1;
304         uint24 fee;
305     }
306 
307     /// @notice Returns PoolKey: the ordered tokens with the matched fee levels
308     /// @param tokenA The first token of a pool, unsorted
309     /// @param tokenB The second token of a pool, unsorted
310     /// @param fee The fee level of the pool
311     /// @return Poolkey The pool details with ordered token0 and token1 assignments
312     function getPoolKey(
313         address tokenA,
314         address tokenB,
315         uint24 fee
316     ) internal pure returns (PoolKey memory) {
317         if (tokenA > tokenB) (tokenA, tokenB) = (tokenB, tokenA);
318         return PoolKey({token0: tokenA, token1: tokenB, fee: fee});
319     }
320 
321     /// @notice Deterministically computes the pool address given the factory and PoolKey
322     /// @param factory The Uniswap V3 factory contract address
323     /// @param key The PoolKey
324     /// @return pool The contract address of the V3 pool
325     function computeAddress(address factory, PoolKey memory key) internal pure returns (address pool) {
326         require(key.token0 < key.token1);
327         pool = address(
328             uint256(
329                 keccak256(
330                     abi.encodePacked(
331                         hex'ff',
332                         factory,
333                         keccak256(abi.encode(key.token0, key.token1, key.fee)),
334                         POOL_INIT_CODE_HASH
335                     )
336                 )
337             )
338         );
339     }
340 }
341 
342 
343 // File @uniswap/v3-core/contracts/interfaces/pool/IUniswapV3PoolImmutables.sol@v1.0.0
344 
345 pragma solidity >=0.5.0;
346 
347 /// @title Pool state that never changes
348 /// @notice These parameters are fixed for a pool forever, i.e., the methods will always return the same values
349 interface IUniswapV3PoolImmutables {
350     /// @notice The contract that deployed the pool, which must adhere to the IUniswapV3Factory interface
351     /// @return The contract address
352     function factory() external view returns (address);
353 
354     /// @notice The first of the two tokens of the pool, sorted by address
355     /// @return The token contract address
356     function token0() external view returns (address);
357 
358     /// @notice The second of the two tokens of the pool, sorted by address
359     /// @return The token contract address
360     function token1() external view returns (address);
361 
362     /// @notice The pool's fee in hundredths of a bip, i.e. 1e-6
363     /// @return The fee
364     function fee() external view returns (uint24);
365 
366     /// @notice The pool tick spacing
367     /// @dev Ticks can only be used at multiples of this value, minimum of 1 and always positive
368     /// e.g.: a tickSpacing of 3 means ticks can be initialized every 3rd tick, i.e., ..., -6, -3, 0, 3, 6, ...
369     /// This value is an int24 to avoid casting even though it is always positive.
370     /// @return The tick spacing
371     function tickSpacing() external view returns (int24);
372 
373     /// @notice The maximum amount of position liquidity that can use any tick in the range
374     /// @dev This parameter is enforced per tick to prevent liquidity from overflowing a uint128 at any point, and
375     /// also prevents out-of-range liquidity from being used to prevent adding in-range liquidity to a pool
376     /// @return The max amount of liquidity per tick
377     function maxLiquidityPerTick() external view returns (uint128);
378 }
379 
380 
381 // File @uniswap/v3-core/contracts/interfaces/pool/IUniswapV3PoolState.sol@v1.0.0
382 
383 pragma solidity >=0.5.0;
384 
385 /// @title Pool state that can change
386 /// @notice These methods compose the pool's state, and can change with any frequency including multiple times
387 /// per transaction
388 interface IUniswapV3PoolState {
389     /// @notice The 0th storage slot in the pool stores many values, and is exposed as a single method to save gas
390     /// when accessed externally.
391     /// @return sqrtPriceX96 The current price of the pool as a sqrt(token1/token0) Q64.96 value
392     /// tick The current tick of the pool, i.e. according to the last tick transition that was run.
393     /// This value may not always be equal to SqrtTickMath.getTickAtSqrtRatio(sqrtPriceX96) if the price is on a tick
394     /// boundary.
395     /// observationIndex The index of the last oracle observation that was written,
396     /// observationCardinality The current maximum number of observations stored in the pool,
397     /// observationCardinalityNext The next maximum number of observations, to be updated when the observation.
398     /// feeProtocol The protocol fee for both tokens of the pool.
399     /// Encoded as two 4 bit values, where the protocol fee of token1 is shifted 4 bits and the protocol fee of token0
400     /// is the lower 4 bits. Used as the denominator of a fraction of the swap fee, e.g. 4 means 1/4th of the swap fee.
401     /// unlocked Whether the pool is currently locked to reentrancy
402     function slot0()
403         external
404         view
405         returns (
406             uint160 sqrtPriceX96,
407             int24 tick,
408             uint16 observationIndex,
409             uint16 observationCardinality,
410             uint16 observationCardinalityNext,
411             uint8 feeProtocol,
412             bool unlocked
413         );
414 
415     /// @notice The fee growth as a Q128.128 fees of token0 collected per unit of liquidity for the entire life of the pool
416     /// @dev This value can overflow the uint256
417     function feeGrowthGlobal0X128() external view returns (uint256);
418 
419     /// @notice The fee growth as a Q128.128 fees of token1 collected per unit of liquidity for the entire life of the pool
420     /// @dev This value can overflow the uint256
421     function feeGrowthGlobal1X128() external view returns (uint256);
422 
423     /// @notice The amounts of token0 and token1 that are owed to the protocol
424     /// @dev Protocol fees will never exceed uint128 max in either token
425     function protocolFees() external view returns (uint128 token0, uint128 token1);
426 
427     /// @notice The currently in range liquidity available to the pool
428     /// @dev This value has no relationship to the total liquidity across all ticks
429     function liquidity() external view returns (uint128);
430 
431     /// @notice Look up information about a specific tick in the pool
432     /// @param tick The tick to look up
433     /// @return liquidityGross the total amount of position liquidity that uses the pool either as tick lower or
434     /// tick upper,
435     /// liquidityNet how much liquidity changes when the pool price crosses the tick,
436     /// feeGrowthOutside0X128 the fee growth on the other side of the tick from the current tick in token0,
437     /// feeGrowthOutside1X128 the fee growth on the other side of the tick from the current tick in token1,
438     /// tickCumulativeOutside the cumulative tick value on the other side of the tick from the current tick
439     /// secondsPerLiquidityOutsideX128 the seconds spent per liquidity on the other side of the tick from the current tick,
440     /// secondsOutside the seconds spent on the other side of the tick from the current tick,
441     /// initialized Set to true if the tick is initialized, i.e. liquidityGross is greater than 0, otherwise equal to false.
442     /// Outside values can only be used if the tick is initialized, i.e. if liquidityGross is greater than 0.
443     /// In addition, these values are only relative and must be used only in comparison to previous snapshots for
444     /// a specific position.
445     function ticks(int24 tick)
446         external
447         view
448         returns (
449             uint128 liquidityGross,
450             int128 liquidityNet,
451             uint256 feeGrowthOutside0X128,
452             uint256 feeGrowthOutside1X128,
453             int56 tickCumulativeOutside,
454             uint160 secondsPerLiquidityOutsideX128,
455             uint32 secondsOutside,
456             bool initialized
457         );
458 
459     /// @notice Returns 256 packed tick initialized boolean values. See TickBitmap for more information
460     function tickBitmap(int16 wordPosition) external view returns (uint256);
461 
462     /// @notice Returns the information about a position by the position's key
463     /// @param key The position's key is a hash of a preimage composed by the owner, tickLower and tickUpper
464     /// @return _liquidity The amount of liquidity in the position,
465     /// Returns feeGrowthInside0LastX128 fee growth of token0 inside the tick range as of the last mint/burn/poke,
466     /// Returns feeGrowthInside1LastX128 fee growth of token1 inside the tick range as of the last mint/burn/poke,
467     /// Returns tokensOwed0 the computed amount of token0 owed to the position as of the last mint/burn/poke,
468     /// Returns tokensOwed1 the computed amount of token1 owed to the position as of the last mint/burn/poke
469     function positions(bytes32 key)
470         external
471         view
472         returns (
473             uint128 _liquidity,
474             uint256 feeGrowthInside0LastX128,
475             uint256 feeGrowthInside1LastX128,
476             uint128 tokensOwed0,
477             uint128 tokensOwed1
478         );
479 
480     /// @notice Returns data about a specific observation index
481     /// @param index The element of the observations array to fetch
482     /// @dev You most likely want to use #observe() instead of this method to get an observation as of some amount of time
483     /// ago, rather than at a specific index in the array.
484     /// @return blockTimestamp The timestamp of the observation,
485     /// Returns tickCumulative the tick multiplied by seconds elapsed for the life of the pool as of the observation timestamp,
486     /// Returns secondsPerLiquidityCumulativeX128 the seconds per in range liquidity for the life of the pool as of the observation timestamp,
487     /// Returns initialized whether the observation has been initialized and the values are safe to use
488     function observations(uint256 index)
489         external
490         view
491         returns (
492             uint32 blockTimestamp,
493             int56 tickCumulative,
494             uint160 secondsPerLiquidityCumulativeX128,
495             bool initialized
496         );
497 }
498 
499 
500 // File @uniswap/v3-core/contracts/interfaces/pool/IUniswapV3PoolDerivedState.sol@v1.0.0
501 
502 pragma solidity >=0.5.0;
503 
504 /// @title Pool state that is not stored
505 /// @notice Contains view functions to provide information about the pool that is computed rather than stored on the
506 /// blockchain. The functions here may have variable gas costs.
507 interface IUniswapV3PoolDerivedState {
508     /// @notice Returns the cumulative tick and liquidity as of each timestamp `secondsAgo` from the current block timestamp
509     /// @dev To get a time weighted average tick or liquidity-in-range, you must call this with two values, one representing
510     /// the beginning of the period and another for the end of the period. E.g., to get the last hour time-weighted average tick,
511     /// you must call it with secondsAgos = [3600, 0].
512     /// @dev The time weighted average tick represents the geometric time weighted average price of the pool, in
513     /// log base sqrt(1.0001) of token1 / token0. The TickMath library can be used to go from a tick value to a ratio.
514     /// @param secondsAgos From how long ago each cumulative tick and liquidity value should be returned
515     /// @return tickCumulatives Cumulative tick values as of each `secondsAgos` from the current block timestamp
516     /// @return secondsPerLiquidityCumulativeX128s Cumulative seconds per liquidity-in-range value as of each `secondsAgos` from the current block
517     /// timestamp
518     function observe(uint32[] calldata secondsAgos)
519         external
520         view
521         returns (int56[] memory tickCumulatives, uint160[] memory secondsPerLiquidityCumulativeX128s);
522 
523     /// @notice Returns a snapshot of the tick cumulative, seconds per liquidity and seconds inside a tick range
524     /// @dev Snapshots must only be compared to other snapshots, taken over a period for which a position existed.
525     /// I.e., snapshots cannot be compared if a position is not held for the entire period between when the first
526     /// snapshot is taken and the second snapshot is taken.
527     /// @param tickLower The lower tick of the range
528     /// @param tickUpper The upper tick of the range
529     /// @return tickCumulativeInside The snapshot of the tick accumulator for the range
530     /// @return secondsPerLiquidityInsideX128 The snapshot of seconds per liquidity for the range
531     /// @return secondsInside The snapshot of seconds per liquidity for the range
532     function snapshotCumulativesInside(int24 tickLower, int24 tickUpper)
533         external
534         view
535         returns (
536             int56 tickCumulativeInside,
537             uint160 secondsPerLiquidityInsideX128,
538             uint32 secondsInside
539         );
540 }
541 
542 
543 // File @uniswap/v3-core/contracts/interfaces/pool/IUniswapV3PoolActions.sol@v1.0.0
544 
545 pragma solidity >=0.5.0;
546 
547 /// @title Permissionless pool actions
548 /// @notice Contains pool methods that can be called by anyone
549 interface IUniswapV3PoolActions {
550     /// @notice Sets the initial price for the pool
551     /// @dev Price is represented as a sqrt(amountToken1/amountToken0) Q64.96 value
552     /// @param sqrtPriceX96 the initial sqrt price of the pool as a Q64.96
553     function initialize(uint160 sqrtPriceX96) external;
554 
555     /// @notice Adds liquidity for the given recipient/tickLower/tickUpper position
556     /// @dev The caller of this method receives a callback in the form of IUniswapV3MintCallback#uniswapV3MintCallback
557     /// in which they must pay any token0 or token1 owed for the liquidity. The amount of token0/token1 due depends
558     /// on tickLower, tickUpper, the amount of liquidity, and the current price.
559     /// @param recipient The address for which the liquidity will be created
560     /// @param tickLower The lower tick of the position in which to add liquidity
561     /// @param tickUpper The upper tick of the position in which to add liquidity
562     /// @param amount The amount of liquidity to mint
563     /// @param data Any data that should be passed through to the callback
564     /// @return amount0 The amount of token0 that was paid to mint the given amount of liquidity. Matches the value in the callback
565     /// @return amount1 The amount of token1 that was paid to mint the given amount of liquidity. Matches the value in the callback
566     function mint(
567         address recipient,
568         int24 tickLower,
569         int24 tickUpper,
570         uint128 amount,
571         bytes calldata data
572     ) external returns (uint256 amount0, uint256 amount1);
573 
574     /// @notice Collects tokens owed to a position
575     /// @dev Does not recompute fees earned, which must be done either via mint or burn of any amount of liquidity.
576     /// Collect must be called by the position owner. To withdraw only token0 or only token1, amount0Requested or
577     /// amount1Requested may be set to zero. To withdraw all tokens owed, caller may pass any value greater than the
578     /// actual tokens owed, e.g. type(uint128).max. Tokens owed may be from accumulated swap fees or burned liquidity.
579     /// @param recipient The address which should receive the fees collected
580     /// @param tickLower The lower tick of the position for which to collect fees
581     /// @param tickUpper The upper tick of the position for which to collect fees
582     /// @param amount0Requested How much token0 should be withdrawn from the fees owed
583     /// @param amount1Requested How much token1 should be withdrawn from the fees owed
584     /// @return amount0 The amount of fees collected in token0
585     /// @return amount1 The amount of fees collected in token1
586     function collect(
587         address recipient,
588         int24 tickLower,
589         int24 tickUpper,
590         uint128 amount0Requested,
591         uint128 amount1Requested
592     ) external returns (uint128 amount0, uint128 amount1);
593 
594     /// @notice Burn liquidity from the sender and account tokens owed for the liquidity to the position
595     /// @dev Can be used to trigger a recalculation of fees owed to a position by calling with an amount of 0
596     /// @dev Fees must be collected separately via a call to #collect
597     /// @param tickLower The lower tick of the position for which to burn liquidity
598     /// @param tickUpper The upper tick of the position for which to burn liquidity
599     /// @param amount How much liquidity to burn
600     /// @return amount0 The amount of token0 sent to the recipient
601     /// @return amount1 The amount of token1 sent to the recipient
602     function burn(
603         int24 tickLower,
604         int24 tickUpper,
605         uint128 amount
606     ) external returns (uint256 amount0, uint256 amount1);
607 
608     /// @notice Swap token0 for token1, or token1 for token0
609     /// @dev The caller of this method receives a callback in the form of IUniswapV3SwapCallback#uniswapV3SwapCallback
610     /// @param recipient The address to receive the output of the swap
611     /// @param zeroForOne The direction of the swap, true for token0 to token1, false for token1 to token0
612     /// @param amountSpecified The amount of the swap, which implicitly configures the swap as exact input (positive), or exact output (negative)
613     /// @param sqrtPriceLimitX96 The Q64.96 sqrt price limit. If zero for one, the price cannot be less than this
614     /// value after the swap. If one for zero, the price cannot be greater than this value after the swap
615     /// @param data Any data to be passed through to the callback
616     /// @return amount0 The delta of the balance of token0 of the pool, exact when negative, minimum when positive
617     /// @return amount1 The delta of the balance of token1 of the pool, exact when negative, minimum when positive
618     function swap(
619         address recipient,
620         bool zeroForOne,
621         int256 amountSpecified,
622         uint160 sqrtPriceLimitX96,
623         bytes calldata data
624     ) external returns (int256 amount0, int256 amount1);
625 
626     /// @notice Receive token0 and/or token1 and pay it back, plus a fee, in the callback
627     /// @dev The caller of this method receives a callback in the form of IUniswapV3FlashCallback#uniswapV3FlashCallback
628     /// @dev Can be used to donate underlying tokens pro-rata to currently in-range liquidity providers by calling
629     /// with 0 amount{0,1} and sending the donation amount(s) from the callback
630     /// @param recipient The address which will receive the token0 and token1 amounts
631     /// @param amount0 The amount of token0 to send
632     /// @param amount1 The amount of token1 to send
633     /// @param data Any data to be passed through to the callback
634     function flash(
635         address recipient,
636         uint256 amount0,
637         uint256 amount1,
638         bytes calldata data
639     ) external;
640 
641     /// @notice Increase the maximum number of price and liquidity observations that this pool will store
642     /// @dev This method is no-op if the pool already has an observationCardinalityNext greater than or equal to
643     /// the input observationCardinalityNext.
644     /// @param observationCardinalityNext The desired minimum number of observations for the pool to store
645     function increaseObservationCardinalityNext(uint16 observationCardinalityNext) external;
646 }
647 
648 
649 // File @uniswap/v3-core/contracts/interfaces/pool/IUniswapV3PoolOwnerActions.sol@v1.0.0
650 
651 pragma solidity >=0.5.0;
652 
653 /// @title Permissioned pool actions
654 /// @notice Contains pool methods that may only be called by the factory owner
655 interface IUniswapV3PoolOwnerActions {
656     /// @notice Set the denominator of the protocol's % share of the fees
657     /// @param feeProtocol0 new protocol fee for token0 of the pool
658     /// @param feeProtocol1 new protocol fee for token1 of the pool
659     function setFeeProtocol(uint8 feeProtocol0, uint8 feeProtocol1) external;
660 
661     /// @notice Collect the protocol fee accrued to the pool
662     /// @param recipient The address to which collected protocol fees should be sent
663     /// @param amount0Requested The maximum amount of token0 to send, can be 0 to collect fees in only token1
664     /// @param amount1Requested The maximum amount of token1 to send, can be 0 to collect fees in only token0
665     /// @return amount0 The protocol fee collected in token0
666     /// @return amount1 The protocol fee collected in token1
667     function collectProtocol(
668         address recipient,
669         uint128 amount0Requested,
670         uint128 amount1Requested
671     ) external returns (uint128 amount0, uint128 amount1);
672 }
673 
674 
675 // File @uniswap/v3-core/contracts/interfaces/pool/IUniswapV3PoolEvents.sol@v1.0.0
676 
677 pragma solidity >=0.5.0;
678 
679 /// @title Events emitted by a pool
680 /// @notice Contains all events emitted by the pool
681 interface IUniswapV3PoolEvents {
682     /// @notice Emitted exactly once by a pool when #initialize is first called on the pool
683     /// @dev Mint/Burn/Swap cannot be emitted by the pool before Initialize
684     /// @param sqrtPriceX96 The initial sqrt price of the pool, as a Q64.96
685     /// @param tick The initial tick of the pool, i.e. log base 1.0001 of the starting price of the pool
686     event Initialize(uint160 sqrtPriceX96, int24 tick);
687 
688     /// @notice Emitted when liquidity is minted for a given position
689     /// @param sender The address that minted the liquidity
690     /// @param owner The owner of the position and recipient of any minted liquidity
691     /// @param tickLower The lower tick of the position
692     /// @param tickUpper The upper tick of the position
693     /// @param amount The amount of liquidity minted to the position range
694     /// @param amount0 How much token0 was required for the minted liquidity
695     /// @param amount1 How much token1 was required for the minted liquidity
696     event Mint(
697         address sender,
698         address indexed owner,
699         int24 indexed tickLower,
700         int24 indexed tickUpper,
701         uint128 amount,
702         uint256 amount0,
703         uint256 amount1
704     );
705 
706     /// @notice Emitted when fees are collected by the owner of a position
707     /// @dev Collect events may be emitted with zero amount0 and amount1 when the caller chooses not to collect fees
708     /// @param owner The owner of the position for which fees are collected
709     /// @param tickLower The lower tick of the position
710     /// @param tickUpper The upper tick of the position
711     /// @param amount0 The amount of token0 fees collected
712     /// @param amount1 The amount of token1 fees collected
713     event Collect(
714         address indexed owner,
715         address recipient,
716         int24 indexed tickLower,
717         int24 indexed tickUpper,
718         uint128 amount0,
719         uint128 amount1
720     );
721 
722     /// @notice Emitted when a position's liquidity is removed
723     /// @dev Does not withdraw any fees earned by the liquidity position, which must be withdrawn via #collect
724     /// @param owner The owner of the position for which liquidity is removed
725     /// @param tickLower The lower tick of the position
726     /// @param tickUpper The upper tick of the position
727     /// @param amount The amount of liquidity to remove
728     /// @param amount0 The amount of token0 withdrawn
729     /// @param amount1 The amount of token1 withdrawn
730     event Burn(
731         address indexed owner,
732         int24 indexed tickLower,
733         int24 indexed tickUpper,
734         uint128 amount,
735         uint256 amount0,
736         uint256 amount1
737     );
738 
739     /// @notice Emitted by the pool for any swaps between token0 and token1
740     /// @param sender The address that initiated the swap call, and that received the callback
741     /// @param recipient The address that received the output of the swap
742     /// @param amount0 The delta of the token0 balance of the pool
743     /// @param amount1 The delta of the token1 balance of the pool
744     /// @param sqrtPriceX96 The sqrt(price) of the pool after the swap, as a Q64.96
745     /// @param liquidity The liquidity of the pool after the swap
746     /// @param tick The log base 1.0001 of price of the pool after the swap
747     event Swap(
748         address indexed sender,
749         address indexed recipient,
750         int256 amount0,
751         int256 amount1,
752         uint160 sqrtPriceX96,
753         uint128 liquidity,
754         int24 tick
755     );
756 
757     /// @notice Emitted by the pool for any flashes of token0/token1
758     /// @param sender The address that initiated the swap call, and that received the callback
759     /// @param recipient The address that received the tokens from flash
760     /// @param amount0 The amount of token0 that was flashed
761     /// @param amount1 The amount of token1 that was flashed
762     /// @param paid0 The amount of token0 paid for the flash, which can exceed the amount0 plus the fee
763     /// @param paid1 The amount of token1 paid for the flash, which can exceed the amount1 plus the fee
764     event Flash(
765         address indexed sender,
766         address indexed recipient,
767         uint256 amount0,
768         uint256 amount1,
769         uint256 paid0,
770         uint256 paid1
771     );
772 
773     /// @notice Emitted by the pool for increases to the number of observations that can be stored
774     /// @dev observationCardinalityNext is not the observation cardinality until an observation is written at the index
775     /// just before a mint/swap/burn.
776     /// @param observationCardinalityNextOld The previous value of the next observation cardinality
777     /// @param observationCardinalityNextNew The updated value of the next observation cardinality
778     event IncreaseObservationCardinalityNext(
779         uint16 observationCardinalityNextOld,
780         uint16 observationCardinalityNextNew
781     );
782 
783     /// @notice Emitted when the protocol fee is changed by the pool
784     /// @param feeProtocol0Old The previous value of the token0 protocol fee
785     /// @param feeProtocol1Old The previous value of the token1 protocol fee
786     /// @param feeProtocol0New The updated value of the token0 protocol fee
787     /// @param feeProtocol1New The updated value of the token1 protocol fee
788     event SetFeeProtocol(uint8 feeProtocol0Old, uint8 feeProtocol1Old, uint8 feeProtocol0New, uint8 feeProtocol1New);
789 
790     /// @notice Emitted when the collected protocol fees are withdrawn by the factory owner
791     /// @param sender The address that collects the protocol fees
792     /// @param recipient The address that receives the collected protocol fees
793     /// @param amount0 The amount of token0 protocol fees that is withdrawn
794     /// @param amount0 The amount of token1 protocol fees that is withdrawn
795     event CollectProtocol(address indexed sender, address indexed recipient, uint128 amount0, uint128 amount1);
796 }
797 
798 
799 // File @uniswap/v3-core/contracts/interfaces/IUniswapV3Pool.sol@v1.0.0
800 
801 pragma solidity >=0.5.0;
802 
803 
804 
805 
806 
807 
808 /// @title The interface for a Uniswap V3 Pool
809 /// @notice A Uniswap pool facilitates swapping and automated market making between any two assets that strictly conform
810 /// to the ERC20 specification
811 /// @dev The pool interface is broken up into many smaller pieces
812 interface IUniswapV3Pool is
813     IUniswapV3PoolImmutables,
814     IUniswapV3PoolState,
815     IUniswapV3PoolDerivedState,
816     IUniswapV3PoolActions,
817     IUniswapV3PoolOwnerActions,
818     IUniswapV3PoolEvents
819 {
820 
821 }
822 
823 
824 // File contracts/interfaces/IERC20Permit.sol
825 
826 
827 pragma solidity ^0.7.0;
828 
829 /**
830  * @dev Interface of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
831  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
832  *
833  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
834  * presenting a message signed by the account. By not relying on `{IERC20-approve}`, the token holder account doesn't
835  * need to send a transaction, and thus is not required to hold Ether at all.
836  */
837 interface IERC20Permit {
838   /**
839    * @dev Sets `value` as the allowance of `spender` over `owner`'s tokens,
840    * given `owner`'s signed approval.
841    *
842    * IMPORTANT: The same issues {IERC20-approve} has related to transaction
843    * ordering also apply here.
844    *
845    * Emits an {Approval} event.
846    *
847    * Requirements:
848    *
849    * - `spender` cannot be the zero address.
850    * - `deadline` must be a timestamp in the future.
851    * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
852    * over the EIP712-formatted function arguments.
853    * - the signature must use ``owner``'s current nonce (see {nonces}).
854    *
855    * For more information on the signature format, see the
856    * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
857    * section].
858    */
859   function permit(
860     address owner,
861     address spender,
862     uint256 value,
863     uint256 deadline,
864     uint8 v,
865     bytes32 r,
866     bytes32 s
867   ) external;
868 
869   /**
870    * @dev Returns the current nonce for `owner`. This value must be
871    * included whenever a signature is generated for {permit}.
872    *
873    * Every successful call to {permit} increases ``owner``'s nonce by one. This
874    * prevents a signature from being used multiple times.
875    */
876   function nonces(address owner) external view returns (uint256);
877 
878   /**
879    * @dev Returns the domain separator used in the encoding of the signature for `permit`, as defined by {EIP712}.
880    */
881   // solhint-disable-next-line func-name-mixedcase
882   function DOMAIN_SEPARATOR() external view returns (bytes32);
883 }
884 
885 
886 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v3.4.1-solc-0.7-2
887 
888 
889 pragma solidity ^0.7.0;
890 
891 /**
892  * @dev Interface of the ERC20 standard as defined in the EIP.
893  */
894 interface IERC20 {
895     /**
896      * @dev Returns the amount of tokens in existence.
897      */
898     function totalSupply() external view returns (uint256);
899 
900     /**
901      * @dev Returns the amount of tokens owned by `account`.
902      */
903     function balanceOf(address account) external view returns (uint256);
904 
905     /**
906      * @dev Moves `amount` tokens from the caller's account to `recipient`.
907      *
908      * Returns a boolean value indicating whether the operation succeeded.
909      *
910      * Emits a {Transfer} event.
911      */
912     function transfer(address recipient, uint256 amount) external returns (bool);
913 
914     /**
915      * @dev Returns the remaining number of tokens that `spender` will be
916      * allowed to spend on behalf of `owner` through {transferFrom}. This is
917      * zero by default.
918      *
919      * This value changes when {approve} or {transferFrom} are called.
920      */
921     function allowance(address owner, address spender) external view returns (uint256);
922 
923     /**
924      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
925      *
926      * Returns a boolean value indicating whether the operation succeeded.
927      *
928      * IMPORTANT: Beware that changing an allowance with this method brings the risk
929      * that someone may use both the old and the new allowance by unfortunate
930      * transaction ordering. One possible solution to mitigate this race
931      * condition is to first reduce the spender's allowance to 0 and set the
932      * desired value afterwards:
933      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
934      *
935      * Emits an {Approval} event.
936      */
937     function approve(address spender, uint256 amount) external returns (bool);
938 
939     /**
940      * @dev Moves `amount` tokens from `sender` to `recipient` using the
941      * allowance mechanism. `amount` is then deducted from the caller's
942      * allowance.
943      *
944      * Returns a boolean value indicating whether the operation succeeded.
945      *
946      * Emits a {Transfer} event.
947      */
948     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
949 
950     /**
951      * @dev Emitted when `value` tokens are moved from one account (`from`) to
952      * another (`to`).
953      *
954      * Note that `value` may be zero.
955      */
956     event Transfer(address indexed from, address indexed to, uint256 value);
957 
958     /**
959      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
960      * a call to {approve}. `value` is the new allowance.
961      */
962     event Approval(address indexed owner, address indexed spender, uint256 value);
963 }
964 
965 
966 // File contracts/interfaces/ILixirVaultToken.sol
967 
968 pragma solidity ^0.7.0;
969 
970 
971 interface ILixirVaultToken is IERC20, IERC20Permit {}
972 
973 
974 // File contracts/interfaces/ILixirVault.sol
975 
976 pragma solidity ^0.7.6;
977 
978 interface ILixirVault is ILixirVaultToken {
979   function initialize(
980     string memory name,
981     string memory symbol,
982     address _token0,
983     address _token1,
984     address _strategist,
985     address _keeper,
986     address _strategy
987   ) external;
988 
989   function token0() external view returns (IERC20);
990 
991   function token1() external view returns (IERC20);
992 
993   function activeFee() external view returns (uint24);
994 
995   function activePool() external view returns (IUniswapV3Pool);
996 
997   function performanceFee() external view returns (uint24);
998 
999   function strategist() external view returns (address);
1000 
1001   function strategy() external view returns (address);
1002 
1003   function keeper() external view returns (address);
1004 
1005   function setKeeper(address _keeper) external;
1006 
1007   function setStrategist(address _strategist) external;
1008 
1009   function setStrategy(address _strategy) external;
1010 
1011   function setPerformanceFee(uint24 newFee) external;
1012 
1013   function mainPosition()
1014     external
1015     view
1016     returns (int24 tickLower, int24 tickUpper);
1017 
1018   function rangePosition()
1019     external
1020     view
1021     returns (int24 tickLower, int24 tickUpper);
1022 
1023   function rebalance(
1024     int24 mainTickLower,
1025     int24 mainTickUpper,
1026     int24 rangeTickLower0,
1027     int24 rangeTickUpper0,
1028     int24 rangeTickLower1,
1029     int24 rangeTickUpper1,
1030     uint24 fee
1031   ) external;
1032 
1033   function withdraw(
1034     uint256 shares,
1035     uint256 amount0Min,
1036     uint256 amount1Min,
1037     address receiver,
1038     uint256 deadline
1039   ) external returns (uint256 amount0Out, uint256 amount1Out);
1040 
1041   function withdrawFrom(
1042     address withdrawer,
1043     uint256 shares,
1044     uint256 amount0Min,
1045     uint256 amount1Min,
1046     address recipient,
1047     uint256 deadline
1048   ) external returns (uint256 amount0Out, uint256 amount1Out);
1049 
1050   function deposit(
1051     uint256 amount0Desired,
1052     uint256 amount1Desired,
1053     uint256 amount0Min,
1054     uint256 amount1Min,
1055     address recipient,
1056     uint256 deadline
1057   )
1058     external
1059     returns (
1060       uint256 shares,
1061       uint256 amount0,
1062       uint256 amount1
1063     );
1064 
1065   function calculateTotals()
1066     external
1067     view
1068     returns (
1069       uint256 total0,
1070       uint256 total1,
1071       uint128 mL,
1072       uint128 rL
1073     );
1074 
1075   function calculateTotalsFromTick(int24 virtualTick)
1076     external
1077     view
1078     returns (
1079       uint256 total0,
1080       uint256 total1,
1081       uint128 mL,
1082       uint128 rL
1083     );
1084 }
1085 
1086 
1087 // File contracts/interfaces/ILixirStrategy.sol
1088 
1089 pragma solidity ^0.7.6;
1090 
1091 interface ILixirStrategy {
1092   function initializeVault(ILixirVault _vault, bytes memory data) external;
1093 }
1094 
1095 
1096 // File contracts/libraries/LixirRoles.sol
1097 
1098 pragma solidity ^0.7.6;
1099 
1100 library LixirRoles {
1101   bytes32 constant gov_role = keccak256('v1_gov_role');
1102   bytes32 constant delegate_role = keccak256('v1_delegate_role');
1103   bytes32 constant vault_role = keccak256('v1_vault_role');
1104   bytes32 constant strategist_role = keccak256('v1_strategist_role');
1105   bytes32 constant pauser_role = keccak256('v1_pauser_role');
1106   bytes32 constant keeper_role = keccak256('v1_keeper_role');
1107   bytes32 constant deployer_role = keccak256('v1_deployer_role');
1108   bytes32 constant strategy_role = keccak256('v1_strategy_role');
1109   bytes32 constant vault_implementation_role =
1110     keccak256('v1_vault_implementation_role');
1111   bytes32 constant eth_vault_implementation_role =
1112     keccak256('v1_eth_vault_implementation_role');
1113   bytes32 constant factory_role = keccak256('v1_factory_role');
1114   bytes32 constant fee_setter_role = keccak256('fee_setter_role');
1115 }
1116 
1117 
1118 // File @openzeppelin/contracts/math/Math.sol@v3.4.1-solc-0.7-2
1119 
1120 
1121 pragma solidity ^0.7.0;
1122 
1123 /**
1124  * @dev Standard math utilities missing in the Solidity language.
1125  */
1126 library Math {
1127     /**
1128      * @dev Returns the largest of two numbers.
1129      */
1130     function max(uint256 a, uint256 b) internal pure returns (uint256) {
1131         return a >= b ? a : b;
1132     }
1133 
1134     /**
1135      * @dev Returns the smallest of two numbers.
1136      */
1137     function min(uint256 a, uint256 b) internal pure returns (uint256) {
1138         return a < b ? a : b;
1139     }
1140 
1141     /**
1142      * @dev Returns the average of two numbers. The result is rounded towards
1143      * zero.
1144      */
1145     function average(uint256 a, uint256 b) internal pure returns (uint256) {
1146         // (a + b) / 2 can overflow, so we distribute
1147         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
1148     }
1149 }
1150 
1151 
1152 // File @openzeppelin/contracts/utils/EnumerableSet.sol@v3.4.1-solc-0.7-2
1153 
1154 
1155 pragma solidity ^0.7.0;
1156 
1157 /**
1158  * @dev Library for managing
1159  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
1160  * types.
1161  *
1162  * Sets have the following properties:
1163  *
1164  * - Elements are added, removed, and checked for existence in constant time
1165  * (O(1)).
1166  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
1167  *
1168  * ```
1169  * contract Example {
1170  *     // Add the library methods
1171  *     using EnumerableSet for EnumerableSet.AddressSet;
1172  *
1173  *     // Declare a set state variable
1174  *     EnumerableSet.AddressSet private mySet;
1175  * }
1176  * ```
1177  *
1178  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
1179  * and `uint256` (`UintSet`) are supported.
1180  */
1181 library EnumerableSet {
1182     // To implement this library for multiple types with as little code
1183     // repetition as possible, we write it in terms of a generic Set type with
1184     // bytes32 values.
1185     // The Set implementation uses private functions, and user-facing
1186     // implementations (such as AddressSet) are just wrappers around the
1187     // underlying Set.
1188     // This means that we can only create new EnumerableSets for types that fit
1189     // in bytes32.
1190 
1191     struct Set {
1192         // Storage of set values
1193         bytes32[] _values;
1194 
1195         // Position of the value in the `values` array, plus 1 because index 0
1196         // means a value is not in the set.
1197         mapping (bytes32 => uint256) _indexes;
1198     }
1199 
1200     /**
1201      * @dev Add a value to a set. O(1).
1202      *
1203      * Returns true if the value was added to the set, that is if it was not
1204      * already present.
1205      */
1206     function _add(Set storage set, bytes32 value) private returns (bool) {
1207         if (!_contains(set, value)) {
1208             set._values.push(value);
1209             // The value is stored at length-1, but we add 1 to all indexes
1210             // and use 0 as a sentinel value
1211             set._indexes[value] = set._values.length;
1212             return true;
1213         } else {
1214             return false;
1215         }
1216     }
1217 
1218     /**
1219      * @dev Removes a value from a set. O(1).
1220      *
1221      * Returns true if the value was removed from the set, that is if it was
1222      * present.
1223      */
1224     function _remove(Set storage set, bytes32 value) private returns (bool) {
1225         // We read and store the value's index to prevent multiple reads from the same storage slot
1226         uint256 valueIndex = set._indexes[value];
1227 
1228         if (valueIndex != 0) { // Equivalent to contains(set, value)
1229             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
1230             // the array, and then remove the last element (sometimes called as 'swap and pop').
1231             // This modifies the order of the array, as noted in {at}.
1232 
1233             uint256 toDeleteIndex = valueIndex - 1;
1234             uint256 lastIndex = set._values.length - 1;
1235 
1236             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
1237             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
1238 
1239             bytes32 lastvalue = set._values[lastIndex];
1240 
1241             // Move the last value to the index where the value to delete is
1242             set._values[toDeleteIndex] = lastvalue;
1243             // Update the index for the moved value
1244             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
1245 
1246             // Delete the slot where the moved value was stored
1247             set._values.pop();
1248 
1249             // Delete the index for the deleted slot
1250             delete set._indexes[value];
1251 
1252             return true;
1253         } else {
1254             return false;
1255         }
1256     }
1257 
1258     /**
1259      * @dev Returns true if the value is in the set. O(1).
1260      */
1261     function _contains(Set storage set, bytes32 value) private view returns (bool) {
1262         return set._indexes[value] != 0;
1263     }
1264 
1265     /**
1266      * @dev Returns the number of values on the set. O(1).
1267      */
1268     function _length(Set storage set) private view returns (uint256) {
1269         return set._values.length;
1270     }
1271 
1272    /**
1273     * @dev Returns the value stored at position `index` in the set. O(1).
1274     *
1275     * Note that there are no guarantees on the ordering of values inside the
1276     * array, and it may change when more values are added or removed.
1277     *
1278     * Requirements:
1279     *
1280     * - `index` must be strictly less than {length}.
1281     */
1282     function _at(Set storage set, uint256 index) private view returns (bytes32) {
1283         require(set._values.length > index, "EnumerableSet: index out of bounds");
1284         return set._values[index];
1285     }
1286 
1287     // Bytes32Set
1288 
1289     struct Bytes32Set {
1290         Set _inner;
1291     }
1292 
1293     /**
1294      * @dev Add a value to a set. O(1).
1295      *
1296      * Returns true if the value was added to the set, that is if it was not
1297      * already present.
1298      */
1299     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
1300         return _add(set._inner, value);
1301     }
1302 
1303     /**
1304      * @dev Removes a value from a set. O(1).
1305      *
1306      * Returns true if the value was removed from the set, that is if it was
1307      * present.
1308      */
1309     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
1310         return _remove(set._inner, value);
1311     }
1312 
1313     /**
1314      * @dev Returns true if the value is in the set. O(1).
1315      */
1316     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
1317         return _contains(set._inner, value);
1318     }
1319 
1320     /**
1321      * @dev Returns the number of values in the set. O(1).
1322      */
1323     function length(Bytes32Set storage set) internal view returns (uint256) {
1324         return _length(set._inner);
1325     }
1326 
1327    /**
1328     * @dev Returns the value stored at position `index` in the set. O(1).
1329     *
1330     * Note that there are no guarantees on the ordering of values inside the
1331     * array, and it may change when more values are added or removed.
1332     *
1333     * Requirements:
1334     *
1335     * - `index` must be strictly less than {length}.
1336     */
1337     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
1338         return _at(set._inner, index);
1339     }
1340 
1341     // AddressSet
1342 
1343     struct AddressSet {
1344         Set _inner;
1345     }
1346 
1347     /**
1348      * @dev Add a value to a set. O(1).
1349      *
1350      * Returns true if the value was added to the set, that is if it was not
1351      * already present.
1352      */
1353     function add(AddressSet storage set, address value) internal returns (bool) {
1354         return _add(set._inner, bytes32(uint256(uint160(value))));
1355     }
1356 
1357     /**
1358      * @dev Removes a value from a set. O(1).
1359      *
1360      * Returns true if the value was removed from the set, that is if it was
1361      * present.
1362      */
1363     function remove(AddressSet storage set, address value) internal returns (bool) {
1364         return _remove(set._inner, bytes32(uint256(uint160(value))));
1365     }
1366 
1367     /**
1368      * @dev Returns true if the value is in the set. O(1).
1369      */
1370     function contains(AddressSet storage set, address value) internal view returns (bool) {
1371         return _contains(set._inner, bytes32(uint256(uint160(value))));
1372     }
1373 
1374     /**
1375      * @dev Returns the number of values in the set. O(1).
1376      */
1377     function length(AddressSet storage set) internal view returns (uint256) {
1378         return _length(set._inner);
1379     }
1380 
1381    /**
1382     * @dev Returns the value stored at position `index` in the set. O(1).
1383     *
1384     * Note that there are no guarantees on the ordering of values inside the
1385     * array, and it may change when more values are added or removed.
1386     *
1387     * Requirements:
1388     *
1389     * - `index` must be strictly less than {length}.
1390     */
1391     function at(AddressSet storage set, uint256 index) internal view returns (address) {
1392         return address(uint160(uint256(_at(set._inner, index))));
1393     }
1394 
1395 
1396     // UintSet
1397 
1398     struct UintSet {
1399         Set _inner;
1400     }
1401 
1402     /**
1403      * @dev Add a value to a set. O(1).
1404      *
1405      * Returns true if the value was added to the set, that is if it was not
1406      * already present.
1407      */
1408     function add(UintSet storage set, uint256 value) internal returns (bool) {
1409         return _add(set._inner, bytes32(value));
1410     }
1411 
1412     /**
1413      * @dev Removes a value from a set. O(1).
1414      *
1415      * Returns true if the value was removed from the set, that is if it was
1416      * present.
1417      */
1418     function remove(UintSet storage set, uint256 value) internal returns (bool) {
1419         return _remove(set._inner, bytes32(value));
1420     }
1421 
1422     /**
1423      * @dev Returns true if the value is in the set. O(1).
1424      */
1425     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
1426         return _contains(set._inner, bytes32(value));
1427     }
1428 
1429     /**
1430      * @dev Returns the number of values on the set. O(1).
1431      */
1432     function length(UintSet storage set) internal view returns (uint256) {
1433         return _length(set._inner);
1434     }
1435 
1436    /**
1437     * @dev Returns the value stored at position `index` in the set. O(1).
1438     *
1439     * Note that there are no guarantees on the ordering of values inside the
1440     * array, and it may change when more values are added or removed.
1441     *
1442     * Requirements:
1443     *
1444     * - `index` must be strictly less than {length}.
1445     */
1446     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
1447         return uint256(_at(set._inner, index));
1448     }
1449 }
1450 
1451 
1452 // File @openzeppelin/contracts/utils/Address.sol@v3.4.1-solc-0.7-2
1453 
1454 
1455 pragma solidity ^0.7.0;
1456 
1457 /**
1458  * @dev Collection of functions related to the address type
1459  */
1460 library Address {
1461     /**
1462      * @dev Returns true if `account` is a contract.
1463      *
1464      * [IMPORTANT]
1465      * ====
1466      * It is unsafe to assume that an address for which this function returns
1467      * false is an externally-owned account (EOA) and not a contract.
1468      *
1469      * Among others, `isContract` will return false for the following
1470      * types of addresses:
1471      *
1472      *  - an externally-owned account
1473      *  - a contract in construction
1474      *  - an address where a contract will be created
1475      *  - an address where a contract lived, but was destroyed
1476      * ====
1477      */
1478     function isContract(address account) internal view returns (bool) {
1479         // This method relies on extcodesize, which returns 0 for contracts in
1480         // construction, since the code is only stored at the end of the
1481         // constructor execution.
1482 
1483         uint256 size;
1484         // solhint-disable-next-line no-inline-assembly
1485         assembly { size := extcodesize(account) }
1486         return size > 0;
1487     }
1488 
1489     /**
1490      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
1491      * `recipient`, forwarding all available gas and reverting on errors.
1492      *
1493      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
1494      * of certain opcodes, possibly making contracts go over the 2300 gas limit
1495      * imposed by `transfer`, making them unable to receive funds via
1496      * `transfer`. {sendValue} removes this limitation.
1497      *
1498      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
1499      *
1500      * IMPORTANT: because control is transferred to `recipient`, care must be
1501      * taken to not create reentrancy vulnerabilities. Consider using
1502      * {ReentrancyGuard} or the
1503      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
1504      */
1505     function sendValue(address payable recipient, uint256 amount) internal {
1506         require(address(this).balance >= amount, "Address: insufficient balance");
1507 
1508         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
1509         (bool success, ) = recipient.call{ value: amount }("");
1510         require(success, "Address: unable to send value, recipient may have reverted");
1511     }
1512 
1513     /**
1514      * @dev Performs a Solidity function call using a low level `call`. A
1515      * plain`call` is an unsafe replacement for a function call: use this
1516      * function instead.
1517      *
1518      * If `target` reverts with a revert reason, it is bubbled up by this
1519      * function (like regular Solidity function calls).
1520      *
1521      * Returns the raw returned data. To convert to the expected return value,
1522      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
1523      *
1524      * Requirements:
1525      *
1526      * - `target` must be a contract.
1527      * - calling `target` with `data` must not revert.
1528      *
1529      * _Available since v3.1._
1530      */
1531     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
1532       return functionCall(target, data, "Address: low-level call failed");
1533     }
1534 
1535     /**
1536      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
1537      * `errorMessage` as a fallback revert reason when `target` reverts.
1538      *
1539      * _Available since v3.1._
1540      */
1541     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
1542         return functionCallWithValue(target, data, 0, errorMessage);
1543     }
1544 
1545     /**
1546      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1547      * but also transferring `value` wei to `target`.
1548      *
1549      * Requirements:
1550      *
1551      * - the calling contract must have an ETH balance of at least `value`.
1552      * - the called Solidity function must be `payable`.
1553      *
1554      * _Available since v3.1._
1555      */
1556     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
1557         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
1558     }
1559 
1560     /**
1561      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
1562      * with `errorMessage` as a fallback revert reason when `target` reverts.
1563      *
1564      * _Available since v3.1._
1565      */
1566     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
1567         require(address(this).balance >= value, "Address: insufficient balance for call");
1568         require(isContract(target), "Address: call to non-contract");
1569 
1570         // solhint-disable-next-line avoid-low-level-calls
1571         (bool success, bytes memory returndata) = target.call{ value: value }(data);
1572         return _verifyCallResult(success, returndata, errorMessage);
1573     }
1574 
1575     /**
1576      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1577      * but performing a static call.
1578      *
1579      * _Available since v3.3._
1580      */
1581     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
1582         return functionStaticCall(target, data, "Address: low-level static call failed");
1583     }
1584 
1585     /**
1586      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1587      * but performing a static call.
1588      *
1589      * _Available since v3.3._
1590      */
1591     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
1592         require(isContract(target), "Address: static call to non-contract");
1593 
1594         // solhint-disable-next-line avoid-low-level-calls
1595         (bool success, bytes memory returndata) = target.staticcall(data);
1596         return _verifyCallResult(success, returndata, errorMessage);
1597     }
1598 
1599     /**
1600      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1601      * but performing a delegate call.
1602      *
1603      * _Available since v3.4._
1604      */
1605     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
1606         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
1607     }
1608 
1609     /**
1610      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1611      * but performing a delegate call.
1612      *
1613      * _Available since v3.4._
1614      */
1615     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
1616         require(isContract(target), "Address: delegate call to non-contract");
1617 
1618         // solhint-disable-next-line avoid-low-level-calls
1619         (bool success, bytes memory returndata) = target.delegatecall(data);
1620         return _verifyCallResult(success, returndata, errorMessage);
1621     }
1622 
1623     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
1624         if (success) {
1625             return returndata;
1626         } else {
1627             // Look for revert reason and bubble it up if present
1628             if (returndata.length > 0) {
1629                 // The easiest way to bubble the revert reason is using memory via assembly
1630 
1631                 // solhint-disable-next-line no-inline-assembly
1632                 assembly {
1633                     let returndata_size := mload(returndata)
1634                     revert(add(32, returndata), returndata_size)
1635                 }
1636             } else {
1637                 revert(errorMessage);
1638             }
1639         }
1640     }
1641 }
1642 
1643 
1644 // File @openzeppelin/contracts/utils/Context.sol@v3.4.1-solc-0.7-2
1645 
1646 
1647 pragma solidity >=0.6.0 <0.8.0;
1648 
1649 /*
1650  * @dev Provides information about the current execution context, including the
1651  * sender of the transaction and its data. While these are generally available
1652  * via msg.sender and msg.data, they should not be accessed in such a direct
1653  * manner, since when dealing with GSN meta-transactions the account sending and
1654  * paying for execution may not be the actual sender (as far as an application
1655  * is concerned).
1656  *
1657  * This contract is only required for intermediate, library-like contracts.
1658  */
1659 abstract contract Context {
1660     function _msgSender() internal view virtual returns (address payable) {
1661         return msg.sender;
1662     }
1663 
1664     function _msgData() internal view virtual returns (bytes memory) {
1665         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
1666         return msg.data;
1667     }
1668 }
1669 
1670 
1671 // File @openzeppelin/contracts/access/AccessControl.sol@v3.4.1-solc-0.7-2
1672 
1673 
1674 pragma solidity ^0.7.0;
1675 
1676 
1677 
1678 /**
1679  * @dev Contract module that allows children to implement role-based access
1680  * control mechanisms.
1681  *
1682  * Roles are referred to by their `bytes32` identifier. These should be exposed
1683  * in the external API and be unique. The best way to achieve this is by
1684  * using `public constant` hash digests:
1685  *
1686  * ```
1687  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
1688  * ```
1689  *
1690  * Roles can be used to represent a set of permissions. To restrict access to a
1691  * function call, use {hasRole}:
1692  *
1693  * ```
1694  * function foo() public {
1695  *     require(hasRole(MY_ROLE, msg.sender));
1696  *     ...
1697  * }
1698  * ```
1699  *
1700  * Roles can be granted and revoked dynamically via the {grantRole} and
1701  * {revokeRole} functions. Each role has an associated admin role, and only
1702  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
1703  *
1704  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
1705  * that only accounts with this role will be able to grant or revoke other
1706  * roles. More complex role relationships can be created by using
1707  * {_setRoleAdmin}.
1708  *
1709  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
1710  * grant and revoke this role. Extra precautions should be taken to secure
1711  * accounts that have been granted it.
1712  */
1713 abstract contract AccessControl is Context {
1714     using EnumerableSet for EnumerableSet.AddressSet;
1715     using Address for address;
1716 
1717     struct RoleData {
1718         EnumerableSet.AddressSet members;
1719         bytes32 adminRole;
1720     }
1721 
1722     mapping (bytes32 => RoleData) private _roles;
1723 
1724     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
1725 
1726     /**
1727      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
1728      *
1729      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
1730      * {RoleAdminChanged} not being emitted signaling this.
1731      *
1732      * _Available since v3.1._
1733      */
1734     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
1735 
1736     /**
1737      * @dev Emitted when `account` is granted `role`.
1738      *
1739      * `sender` is the account that originated the contract call, an admin role
1740      * bearer except when using {_setupRole}.
1741      */
1742     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
1743 
1744     /**
1745      * @dev Emitted when `account` is revoked `role`.
1746      *
1747      * `sender` is the account that originated the contract call:
1748      *   - if using `revokeRole`, it is the admin role bearer
1749      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
1750      */
1751     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
1752 
1753     /**
1754      * @dev Returns `true` if `account` has been granted `role`.
1755      */
1756     function hasRole(bytes32 role, address account) public view returns (bool) {
1757         return _roles[role].members.contains(account);
1758     }
1759 
1760     /**
1761      * @dev Returns the number of accounts that have `role`. Can be used
1762      * together with {getRoleMember} to enumerate all bearers of a role.
1763      */
1764     function getRoleMemberCount(bytes32 role) public view returns (uint256) {
1765         return _roles[role].members.length();
1766     }
1767 
1768     /**
1769      * @dev Returns one of the accounts that have `role`. `index` must be a
1770      * value between 0 and {getRoleMemberCount}, non-inclusive.
1771      *
1772      * Role bearers are not sorted in any particular way, and their ordering may
1773      * change at any point.
1774      *
1775      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
1776      * you perform all queries on the same block. See the following
1777      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
1778      * for more information.
1779      */
1780     function getRoleMember(bytes32 role, uint256 index) public view returns (address) {
1781         return _roles[role].members.at(index);
1782     }
1783 
1784     /**
1785      * @dev Returns the admin role that controls `role`. See {grantRole} and
1786      * {revokeRole}.
1787      *
1788      * To change a role's admin, use {_setRoleAdmin}.
1789      */
1790     function getRoleAdmin(bytes32 role) public view returns (bytes32) {
1791         return _roles[role].adminRole;
1792     }
1793 
1794     /**
1795      * @dev Grants `role` to `account`.
1796      *
1797      * If `account` had not been already granted `role`, emits a {RoleGranted}
1798      * event.
1799      *
1800      * Requirements:
1801      *
1802      * - the caller must have ``role``'s admin role.
1803      */
1804     function grantRole(bytes32 role, address account) public virtual {
1805         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to grant");
1806 
1807         _grantRole(role, account);
1808     }
1809 
1810     /**
1811      * @dev Revokes `role` from `account`.
1812      *
1813      * If `account` had been granted `role`, emits a {RoleRevoked} event.
1814      *
1815      * Requirements:
1816      *
1817      * - the caller must have ``role``'s admin role.
1818      */
1819     function revokeRole(bytes32 role, address account) public virtual {
1820         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to revoke");
1821 
1822         _revokeRole(role, account);
1823     }
1824 
1825     /**
1826      * @dev Revokes `role` from the calling account.
1827      *
1828      * Roles are often managed via {grantRole} and {revokeRole}: this function's
1829      * purpose is to provide a mechanism for accounts to lose their privileges
1830      * if they are compromised (such as when a trusted device is misplaced).
1831      *
1832      * If the calling account had been granted `role`, emits a {RoleRevoked}
1833      * event.
1834      *
1835      * Requirements:
1836      *
1837      * - the caller must be `account`.
1838      */
1839     function renounceRole(bytes32 role, address account) public virtual {
1840         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
1841 
1842         _revokeRole(role, account);
1843     }
1844 
1845     /**
1846      * @dev Grants `role` to `account`.
1847      *
1848      * If `account` had not been already granted `role`, emits a {RoleGranted}
1849      * event. Note that unlike {grantRole}, this function doesn't perform any
1850      * checks on the calling account.
1851      *
1852      * [WARNING]
1853      * ====
1854      * This function should only be called from the constructor when setting
1855      * up the initial roles for the system.
1856      *
1857      * Using this function in any other way is effectively circumventing the admin
1858      * system imposed by {AccessControl}.
1859      * ====
1860      */
1861     function _setupRole(bytes32 role, address account) internal virtual {
1862         _grantRole(role, account);
1863     }
1864 
1865     /**
1866      * @dev Sets `adminRole` as ``role``'s admin role.
1867      *
1868      * Emits a {RoleAdminChanged} event.
1869      */
1870     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
1871         emit RoleAdminChanged(role, _roles[role].adminRole, adminRole);
1872         _roles[role].adminRole = adminRole;
1873     }
1874 
1875     function _grantRole(bytes32 role, address account) private {
1876         if (_roles[role].members.add(account)) {
1877             emit RoleGranted(role, account, _msgSender());
1878         }
1879     }
1880 
1881     function _revokeRole(bytes32 role, address account) private {
1882         if (_roles[role].members.remove(account)) {
1883             emit RoleRevoked(role, account, _msgSender());
1884         }
1885     }
1886 }
1887 
1888 
1889 // File @uniswap/v3-periphery/contracts/interfaces/external/IWETH9.sol@v1.2.1
1890 
1891 pragma solidity =0.7.6;
1892 
1893 /// @title Interface for WETH9
1894 interface IWETH9 is IERC20 {
1895     /// @notice Deposit ether to get wrapped ether
1896     function deposit() external payable;
1897 
1898     /// @notice Withdraw wrapped ether to get ether
1899     function withdraw(uint256) external;
1900 }
1901 
1902 
1903 // File contracts/LixirRegistry.sol
1904 
1905 pragma solidity ^0.7.6;
1906 
1907 
1908 
1909 /**
1910   @notice an access control contract with roles used to handle
1911   permissioning throughout the `Vault` and `Strategy` contracts.
1912  */
1913 contract LixirRegistry is AccessControl {
1914   address public immutable uniV3Factory;
1915   IWETH9 public immutable weth9;
1916 
1917   /// king
1918   bytes32 public constant gov_role = keccak256('v1_gov_role');
1919   /// same privileges as `gov_role`
1920   bytes32 public constant delegate_role = keccak256('v1_delegate_role');
1921   /// configuring options within the strategy contract & vault
1922   bytes32 public constant strategist_role = keccak256('v1_strategist_role');
1923   /// can `emergencyExit` a vault
1924   bytes32 public constant pauser_role = keccak256('v1_pauser_role');
1925   /// can `rebalance` the vault via the strategy contract
1926   bytes32 public constant keeper_role = keccak256('v1_keeper_role');
1927   /// can `createVault`s from the factory contract
1928   bytes32 public constant deployer_role = keccak256('v1_deployer_role');
1929   /// verified vault in the registry
1930   bytes32 public constant vault_role = keccak256('v1_vault_role');
1931   /// can initialize vaults
1932   bytes32 public constant strategy_role = keccak256('v1_strategy_role');
1933   bytes32 public constant vault_implementation_role =
1934     keccak256('v1_vault_implementation_role');
1935   bytes32 public constant eth_vault_implementation_role =
1936     keccak256('v1_eth_vault_implementation_role');
1937   /// verified vault factory in the registry
1938   bytes32 public constant factory_role = keccak256('v1_factory_role');
1939   /// can `setPerformanceFee` on a vault
1940   bytes32 public constant fee_setter_role = keccak256('fee_setter_role');
1941 
1942   address public feeTo;
1943 
1944   address public emergencyReturn;
1945 
1946   uint24 public constant PERFORMANCE_FEE_PRECISION = 1e6;
1947 
1948   event FeeToChanged(address indexed previousFeeTo, address indexed newFeeTo);
1949 
1950   event EmergencyReturnChanged(
1951     address indexed previousEmergencyReturn,
1952     address indexed newEmergencyReturn
1953   );
1954 
1955   constructor(
1956     address _governance,
1957     address _delegate,
1958     address _uniV3Factory,
1959     address _weth9
1960   ) {
1961     uniV3Factory = _uniV3Factory;
1962     weth9 = IWETH9(_weth9);
1963     _setupRole(gov_role, _governance);
1964     _setupRole(delegate_role, _delegate);
1965     // gov is its own admin
1966     _setRoleAdmin(gov_role, gov_role);
1967     _setRoleAdmin(delegate_role, gov_role);
1968     _setRoleAdmin(strategist_role, delegate_role);
1969     _setRoleAdmin(fee_setter_role, delegate_role);
1970     _setRoleAdmin(pauser_role, delegate_role);
1971     _setRoleAdmin(keeper_role, delegate_role);
1972     _setRoleAdmin(deployer_role, delegate_role);
1973     _setRoleAdmin(factory_role, delegate_role);
1974     _setRoleAdmin(strategy_role, delegate_role);
1975     _setRoleAdmin(vault_implementation_role, delegate_role);
1976     _setRoleAdmin(eth_vault_implementation_role, delegate_role);
1977     _setRoleAdmin(vault_role, factory_role);
1978   }
1979 
1980   function addRole(bytes32 role, bytes32 roleAdmin) public {
1981     require(isGovOrDelegate(msg.sender));
1982     require(getRoleAdmin(role) == bytes32(0) && getRoleMemberCount(role) == 0);
1983     _setRoleAdmin(role, roleAdmin);
1984   }
1985 
1986   function isGovOrDelegate(address account) public view returns (bool) {
1987     return hasRole(gov_role, account) || hasRole(delegate_role, account);
1988   }
1989 
1990   function setFeeTo(address _feeTo) external {
1991     require(isGovOrDelegate(msg.sender));
1992     address previous = feeTo;
1993     feeTo = _feeTo;
1994     emit FeeToChanged(previous, _feeTo);
1995   }
1996 
1997   function setEmergencyReturn(address _emergencyReturn) external {
1998     require(isGovOrDelegate(msg.sender));
1999     address previous = emergencyReturn;
2000     emergencyReturn = _emergencyReturn;
2001     emit EmergencyReturnChanged(previous, _emergencyReturn);
2002   }
2003 }
2004 
2005 
2006 // File contracts/LixirBase.sol
2007 
2008 pragma solidity ^0.7.6;
2009 
2010 
2011 /**
2012   @notice An abstract contract that gives access to the registry
2013   and contains common modifiers for restricting access to
2014   functions based on role. 
2015  */
2016 abstract contract LixirBase {
2017   LixirRegistry public immutable registry;
2018 
2019   constructor(address _registry) {
2020     registry = LixirRegistry(_registry);
2021   }
2022 
2023   modifier onlyRole(bytes32 role) {
2024     require(registry.hasRole(role, msg.sender));
2025     _;
2026   }
2027   modifier onlyGovOrDelegate {
2028     require(registry.isGovOrDelegate(msg.sender));
2029     _;
2030   }
2031   modifier hasRole(bytes32 role, address account) {
2032     require(registry.hasRole(role, account));
2033     _;
2034   }
2035 }
2036 
2037 
2038 // File contracts/LixirStrategySimpleGWAP.sol
2039 
2040 pragma solidity ^0.7.6;
2041 
2042 
2043 
2044 
2045 contract LixirStrategySimpleGWAP is LixirBase, ILixirStrategy {
2046   constructor(address _registry) LixirBase(_registry) {}
2047 
2048   mapping(address => VaultData) public vaultDatas;
2049 
2050   /**
2051    * @notice Struct for containing data pertaining to strategy vaults
2052    * @param TICK_SHORT_DURATION how long we want to wait to get a TWAP to prevent sandwiching
2053    * @param MAX_TICK_DIFF check on the short_gwap and expected tick to prevent sandwiching
2054    * @param mainSpread tick width of the main position
2055    * @param rangeSpread tick width of the range position
2056    * @param timestamp keeping track of last time of rebalance or config
2057    * @param tickCumulative last cumulative tick value from pool
2058    */
2059   struct VaultData {
2060     uint32 TICK_SHORT_DURATION;
2061     int24 MAX_TICK_DIFF;
2062     int24 mainSpread;
2063     int24 rangeSpread;
2064     uint32 timestamp;
2065     int56 tickCumulative;
2066   }
2067 
2068   event VaultConfigUpdate(
2069     address indexed vault,
2070     uint32 TICK_SHORT_DURATION,
2071     int24 MAX_TICK_DIFF,
2072     int24 mainSpread,
2073     int24 rangeSpread
2074   );
2075 
2076   /**
2077     @notice adds a vault to this strategy contract.
2078     @dev called externally by the `LixirFactory` when you `createVault`
2079    */
2080   function initializeVault(ILixirVault _vault, bytes memory data)
2081     external
2082     override
2083     onlyRole(LixirRoles.factory_role)
2084   {
2085     (
2086       uint24 fee,
2087       uint32 TICK_SHORT_DURATION,
2088       int24 MAX_TICK_DIFF,
2089       int24 mainSpread,
2090       int24 rangeSpread
2091     ) = abi.decode(data, (uint24, uint32, int24, int24, int24));
2092     _configureVault(
2093       _vault,
2094       fee,
2095       TICK_SHORT_DURATION,
2096       MAX_TICK_DIFF,
2097       mainSpread,
2098       rangeSpread
2099     );
2100   }
2101 
2102   function setTickShortDuration(ILixirVault _vault, uint32 TICK_SHORT_DURATION)
2103     external
2104     onlyRole(LixirRoles.strategist_role)
2105     hasRole(LixirRoles.vault_role, address(_vault))
2106   {
2107     require(msg.sender == _vault.strategist());
2108     require(
2109       TICK_SHORT_DURATION >= 30,
2110       'TICK_SHORT_DURATION must be greater than 30 seconds'
2111     );
2112     VaultData storage vaultData = vaultDatas[address(_vault)];
2113     vaultData.TICK_SHORT_DURATION = TICK_SHORT_DURATION;
2114     emit VaultConfigUpdate(
2115       address(_vault),
2116       TICK_SHORT_DURATION,
2117       vaultData.MAX_TICK_DIFF,
2118       vaultData.mainSpread,
2119       vaultData.rangeSpread
2120     );
2121   }
2122 
2123   function setMaxTickDiff(ILixirVault _vault, int24 MAX_TICK_DIFF)
2124     external
2125     onlyRole(LixirRoles.strategist_role)
2126     hasRole(LixirRoles.vault_role, address(_vault))
2127   {
2128     require(msg.sender == _vault.strategist());
2129     require(
2130       MAX_TICK_DIFF >= 0,
2131       'MAX_TICK_DIFF must be greater than or equal to 0'
2132     );
2133     VaultData storage vaultData = vaultDatas[address(_vault)];
2134     vaultData.MAX_TICK_DIFF = MAX_TICK_DIFF;
2135     emit VaultConfigUpdate(
2136       address(_vault),
2137       vaultData.TICK_SHORT_DURATION,
2138       MAX_TICK_DIFF,
2139       vaultData.mainSpread,
2140       vaultData.rangeSpread
2141     );
2142   }
2143 
2144   /**
2145     @notice sets the tick width of the main and range positions when rebalancing
2146    */
2147   function setSpreads(
2148     ILixirVault _vault,
2149     int24 mainSpread,
2150     int24 rangeSpread
2151   )
2152     external
2153     onlyRole(LixirRoles.strategist_role)
2154     hasRole(LixirRoles.vault_role, address(_vault))
2155   {
2156     require(msg.sender == _vault.strategist());
2157     require(mainSpread >= 0);
2158     require(rangeSpread >= 0);
2159     VaultData storage vaultData = vaultDatas[address(_vault)];
2160     vaultData.mainSpread = mainSpread;
2161     vaultData.rangeSpread = rangeSpread;
2162     emit VaultConfigUpdate(
2163       address(_vault),
2164       vaultData.TICK_SHORT_DURATION,
2165       vaultData.MAX_TICK_DIFF,
2166       mainSpread,
2167       rangeSpread
2168     );
2169   }
2170 
2171   /**
2172     @notice function for strategist to set all `VaultData` in one call
2173    */
2174   function configureVault(
2175     ILixirVault _vault,
2176     uint24 fee,
2177     uint32 TICK_SHORT_DURATION,
2178     int24 MAX_TICK_DIFF,
2179     int24 mainSpread,
2180     int24 rangeSpread
2181   )
2182     external
2183     onlyRole(LixirRoles.strategist_role)
2184     hasRole(LixirRoles.vault_role, address(_vault))
2185   {
2186     require(msg.sender == _vault.strategist());
2187     _configureVault(
2188       _vault,
2189       fee,
2190       TICK_SHORT_DURATION,
2191       MAX_TICK_DIFF,
2192       mainSpread,
2193       rangeSpread
2194     );
2195   }
2196 
2197   function _configureVault(
2198     ILixirVault _vault,
2199     uint24 fee,
2200     uint32 TICK_SHORT_DURATION,
2201     int24 MAX_TICK_DIFF,
2202     int24 mainSpread,
2203     int24 rangeSpread
2204   ) internal {
2205     require(TICK_SHORT_DURATION >= 30);
2206     require(MAX_TICK_DIFF > 0);
2207     require(mainSpread >= 0);
2208     require(rangeSpread >= 0);
2209     require(_vault.strategy() == address(this), 'Incorrect vault strategy');
2210     VaultData storage vaultData = vaultDatas[address(_vault)];
2211     vaultData.TICK_SHORT_DURATION = TICK_SHORT_DURATION;
2212     vaultData.MAX_TICK_DIFF = MAX_TICK_DIFF;
2213     vaultData.mainSpread = mainSpread;
2214     vaultData.rangeSpread = rangeSpread;
2215     if (
2216       block.timestamp - vaultData.timestamp > 60 * 60 * 24 ||
2217       fee != _vault.activeFee()
2218     ) {
2219       IUniswapV3Pool newPool = IUniswapV3Pool(
2220         PoolAddress.computeAddress(
2221           registry.uniV3Factory(),
2222           PoolAddress.getPoolKey(
2223             address(_vault.token0()),
2224             address(_vault.token1()),
2225             fee
2226           )
2227         )
2228       );
2229       (int24 short_gwap, int56 lastShortTicksCumulative) = getTickShortGwap(
2230         newPool,
2231         TICK_SHORT_DURATION
2232       );
2233       vaultData.tickCumulative = lastShortTicksCumulative;
2234       vaultData.timestamp = uint32(block.timestamp - TICK_SHORT_DURATION);
2235       (uint160 sqrtRatioX96, int24 tick) = getSqrtRatioX96AndTick(newPool);
2236       // neither check tick nor _rebalance read timestamp or tickCumulative
2237       // so we don't have to update the cache
2238       checkTick(tick, short_gwap, vaultData.MAX_TICK_DIFF);
2239       emit VaultConfigUpdate(
2240         address(_vault),
2241         TICK_SHORT_DURATION,
2242         MAX_TICK_DIFF,
2243         mainSpread,
2244         rangeSpread
2245       );
2246       _rebalance(
2247         _vault,
2248         newPool,
2249         sqrtRatioX96,
2250         tick,
2251         short_gwap,
2252         mainSpread,
2253         rangeSpread
2254       );
2255     }
2256   }
2257 
2258   /**
2259     @dev Calculates short term TWAP for rebalance sanity checks
2260     @return tick_gwap short term TWAP
2261    */
2262   function getTickShortGwap(IUniswapV3Pool pool, uint32 TICK_SHORT_DURATION)
2263     internal
2264     view
2265     returns (int24 tick_gwap, int56 lastShortTicksCumulative)
2266   {
2267     uint32[] memory secondsAgos = new uint32[](2);
2268     secondsAgos[0] = TICK_SHORT_DURATION;
2269     secondsAgos[1] = 0;
2270     (int56[] memory ticksCumulative, ) = pool.observe(secondsAgos);
2271     lastShortTicksCumulative = ticksCumulative[0];
2272     // compute the time weighted tick, rounded towards negative infinity
2273     int56 numerator = (ticksCumulative[1] - lastShortTicksCumulative);
2274     int56 timeWeightedTick = numerator / int56(TICK_SHORT_DURATION);
2275     if (numerator < 0 && numerator % int56(TICK_SHORT_DURATION) != 0) {
2276       timeWeightedTick--;
2277     }
2278     tick_gwap = int24(timeWeightedTick);
2279     require(int56(tick_gwap) == timeWeightedTick, 'Tick over/underflow');
2280   }
2281 
2282   /**
2283     @dev Sanity checks on current tick, expected tick from keeper, and GWAP tick
2284     @param expectedTick Expected tick passed by keeper
2285    */
2286   function checkTick(
2287     int24 tick,
2288     int24 expectedTick,
2289     int24 MAX_TICK_DIFF
2290   ) internal pure {
2291     int24 diff = expectedTick >= tick
2292       ? expectedTick - tick
2293       : tick - expectedTick;
2294     require(diff <= MAX_TICK_DIFF, 'Tick diff to great');
2295   }
2296 
2297   function getMainTicks(
2298     int24 tick_gwap,
2299     int24 tickSpacing,
2300     int24 spread
2301   ) internal pure returns (int24 lower, int24 upper) {
2302     lower = roundTickDown(tick_gwap - spread, tickSpacing);
2303     upper = roundTickUp(tick_gwap + spread, tickSpacing);
2304     require(lower < upper, 'Main ticks are the same');
2305   }
2306 
2307   function getRangeTicks(
2308     uint160 sqrtRatioX96,
2309     int24 tick,
2310     int24 tickSpacing,
2311     int24 spread
2312   )
2313     internal
2314     pure
2315     returns (
2316       int24 lower0,
2317       int24 upper0,
2318       int24 lower1,
2319       int24 upper1
2320     )
2321   {
2322     lower0 = roundTickUp(
2323       (TickMath.getSqrtRatioAtTick(tick) == sqrtRatioX96) ? tick : tick + 1,
2324       tickSpacing
2325     );
2326     upper0 = roundTickUp(lower0 + spread, tickSpacing);
2327 
2328     upper1 = roundTickDown(tick, tickSpacing);
2329     lower1 = roundTickDown(upper1 - spread, tickSpacing);
2330     require(lower0 < upper0, 'Range0 ticks are the same');
2331     require(lower1 < upper1, 'Range1 ticks are the same');
2332   }
2333 
2334   /**
2335     @dev Calculates long term TWAP for setting ranges
2336     @return tick_gwap Long term TWAP
2337    */
2338   function getTickGwapUpdateCumulative(
2339     IUniswapV3Pool pool,
2340     VaultData storage vaultData
2341   ) internal returns (int24 tick_gwap) {
2342     uint32[] memory secondsAgos = new uint32[](1);
2343     secondsAgos[0] = 0;
2344     (int56[] memory ticksCumulative, ) = pool.observe(secondsAgos);
2345     int56 tickCumulative = ticksCumulative[0];
2346     // compute the time weighted tick, rounded towards negative infinity
2347     int56 numerator = (tickCumulative - vaultData.tickCumulative);
2348     int56 secondsAgo = int56(block.timestamp - vaultData.timestamp);
2349     int56 timeWeightedTick = numerator / secondsAgo;
2350     if (numerator < 0 && numerator % secondsAgo != 0) {
2351       timeWeightedTick--;
2352     }
2353     tick_gwap = int24(timeWeightedTick);
2354     require(int56(tick_gwap) == timeWeightedTick, 'Tick over/underflow');
2355     vaultData.timestamp = uint32(block.timestamp);
2356     vaultData.tickCumulative = tickCumulative;
2357   }
2358 
2359   /**
2360     @notice rebalances the vault to the given tick. In the process
2361     it collects UniV3 fees and repools them.
2362     @dev only keeper role can call
2363 
2364    */
2365   function rebalance(ILixirVault vault, int24 expectedTick)
2366     external
2367     hasRole(LixirRoles.vault_role, address(vault))
2368     onlyRole(LixirRoles.keeper_role)
2369   {
2370     VaultData storage vaultData = vaultDatas[address(vault)];
2371     require(vaultData.timestamp > 0);
2372     IUniswapV3Pool pool = vault.activePool();
2373     (int24 short_gwap, ) = getTickShortGwap(
2374       pool,
2375       vaultData.TICK_SHORT_DURATION
2376     );
2377     (uint160 sqrtRatioX96, int24 tick) = getSqrtRatioX96AndTick(pool);
2378     int24 MAX_TICK_DIFF = vaultData.MAX_TICK_DIFF;
2379     checkTick(tick, short_gwap, MAX_TICK_DIFF);
2380     checkTick(tick, expectedTick, MAX_TICK_DIFF);
2381     int24 tick_gwap = getTickGwapUpdateCumulative(pool, vaultData);
2382     _rebalance(
2383       vault,
2384       pool,
2385       sqrtRatioX96,
2386       tick,
2387       tick_gwap,
2388       vaultData.mainSpread,
2389       vaultData.rangeSpread
2390     );
2391   }
2392 
2393   function _rebalance(
2394     ILixirVault vault,
2395     IUniswapV3Pool pool,
2396     uint160 sqrtRatioX96,
2397     int24 tick,
2398     int24 tick_gwap,
2399     int24 mainSpread,
2400     int24 rangeSpread
2401   ) internal {
2402     int24 mlower;
2403     int24 mupper;
2404     int24 rlower0;
2405     int24 rupper0;
2406     int24 rlower1;
2407     int24 rupper1;
2408     uint24 fee;
2409     {
2410       int24 tickSpacing = pool.tickSpacing();
2411       (mlower, mupper) = getMainTicks(tick_gwap, tickSpacing, mainSpread);
2412       (rlower0, rupper0, rlower1, rupper1) = getRangeTicks(
2413         sqrtRatioX96,
2414         tick,
2415         tickSpacing,
2416         rangeSpread
2417       );
2418       fee = pool.fee();
2419     }
2420     vault.rebalance(mlower, mupper, rlower0, rupper0, rlower1, rupper1, fee);
2421   }
2422 
2423   /**
2424    * @dev Queries activePool for current square root price and current tick
2425    * @return _sqrtRatioX96 Current square root price
2426    * @return _tick Current tick
2427    */
2428   function getSqrtRatioX96AndTick(IUniswapV3Pool pool)
2429     internal
2430     view
2431     returns (uint160 _sqrtRatioX96, int24 _tick)
2432   {
2433     (_sqrtRatioX96, _tick, , , , , ) = pool.slot0();
2434   }
2435 
2436   function max(int24 x, int24 y) internal pure returns (int24) {
2437     return y < x ? x : y;
2438   }
2439 
2440   function min(int24 x, int24 y) internal pure returns (int24) {
2441     return x < y ? x : y;
2442   }
2443 
2444   function roundTickDown(int24 tick, int24 tickSpacing)
2445     internal
2446     pure
2447     returns (int24)
2448   {
2449     int24 tickMod = tick % tickSpacing;
2450     int24 roundedTick;
2451     if (tickMod == 0) {
2452       roundedTick = tick;
2453     } else if (0 < tick) {
2454       roundedTick = tick - tickMod;
2455     } else {
2456       roundedTick = tick - tickSpacing + (-tickMod);
2457     }
2458     return max(roundedTick, TickMath.MIN_TICK);
2459   }
2460 
2461   function roundTickUp(int24 tick, int24 tickSpacing)
2462     internal
2463     pure
2464     returns (int24)
2465   {
2466     int24 tickDown = roundTickDown(tick, tickSpacing);
2467     return
2468       min(tick == tickDown ? tick : tickDown + tickSpacing, TickMath.MAX_TICK);
2469   }
2470 }