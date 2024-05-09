1 // File: @uniswap/v3-core/contracts/interfaces/pool/IUniswapV3PoolEvents.sol
2 
3 
4 pragma solidity >=0.5.0;
5 
6 /// @title Events emitted by a pool
7 /// @notice Contains all events emitted by the pool
8 interface IUniswapV3PoolEvents {
9     /// @notice Emitted exactly once by a pool when #initialize is first called on the pool
10     /// @dev Mint/Burn/Swap cannot be emitted by the pool before Initialize
11     /// @param sqrtPriceX96 The initial sqrt price of the pool, as a Q64.96
12     /// @param tick The initial tick of the pool, i.e. log base 1.0001 of the starting price of the pool
13     event Initialize(uint160 sqrtPriceX96, int24 tick);
14 
15     /// @notice Emitted when liquidity is minted for a given position
16     /// @param sender The address that minted the liquidity
17     /// @param owner The owner of the position and recipient of any minted liquidity
18     /// @param tickLower The lower tick of the position
19     /// @param tickUpper The upper tick of the position
20     /// @param amount The amount of liquidity minted to the position range
21     /// @param amount0 How much token0 was required for the minted liquidity
22     /// @param amount1 How much token1 was required for the minted liquidity
23     event Mint(
24         address sender,
25         address indexed owner,
26         int24 indexed tickLower,
27         int24 indexed tickUpper,
28         uint128 amount,
29         uint256 amount0,
30         uint256 amount1
31     );
32 
33     /// @notice Emitted when fees are collected by the owner of a position
34     /// @dev Collect events may be emitted with zero amount0 and amount1 when the caller chooses not to collect fees
35     /// @param owner The owner of the position for which fees are collected
36     /// @param tickLower The lower tick of the position
37     /// @param tickUpper The upper tick of the position
38     /// @param amount0 The amount of token0 fees collected
39     /// @param amount1 The amount of token1 fees collected
40     event Collect(
41         address indexed owner,
42         address recipient,
43         int24 indexed tickLower,
44         int24 indexed tickUpper,
45         uint128 amount0,
46         uint128 amount1
47     );
48 
49     /// @notice Emitted when a position's liquidity is removed
50     /// @dev Does not withdraw any fees earned by the liquidity position, which must be withdrawn via #collect
51     /// @param owner The owner of the position for which liquidity is removed
52     /// @param tickLower The lower tick of the position
53     /// @param tickUpper The upper tick of the position
54     /// @param amount The amount of liquidity to remove
55     /// @param amount0 The amount of token0 withdrawn
56     /// @param amount1 The amount of token1 withdrawn
57     event Burn(
58         address indexed owner,
59         int24 indexed tickLower,
60         int24 indexed tickUpper,
61         uint128 amount,
62         uint256 amount0,
63         uint256 amount1
64     );
65 
66     /// @notice Emitted by the pool for any swaps between token0 and token1
67     /// @param sender The address that initiated the swap call, and that received the callback
68     /// @param recipient The address that received the output of the swap
69     /// @param amount0 The delta of the token0 balance of the pool
70     /// @param amount1 The delta of the token1 balance of the pool
71     /// @param sqrtPriceX96 The sqrt(price) of the pool after the swap, as a Q64.96
72     /// @param liquidity The liquidity of the pool after the swap
73     /// @param tick The log base 1.0001 of price of the pool after the swap
74     event Swap(
75         address indexed sender,
76         address indexed recipient,
77         int256 amount0,
78         int256 amount1,
79         uint160 sqrtPriceX96,
80         uint128 liquidity,
81         int24 tick
82     );
83 
84     /// @notice Emitted by the pool for any flashes of token0/token1
85     /// @param sender The address that initiated the swap call, and that received the callback
86     /// @param recipient The address that received the tokens from flash
87     /// @param amount0 The amount of token0 that was flashed
88     /// @param amount1 The amount of token1 that was flashed
89     /// @param paid0 The amount of token0 paid for the flash, which can exceed the amount0 plus the fee
90     /// @param paid1 The amount of token1 paid for the flash, which can exceed the amount1 plus the fee
91     event Flash(
92         address indexed sender,
93         address indexed recipient,
94         uint256 amount0,
95         uint256 amount1,
96         uint256 paid0,
97         uint256 paid1
98     );
99 
100     /// @notice Emitted by the pool for increases to the number of observations that can be stored
101     /// @dev observationCardinalityNext is not the observation cardinality until an observation is written at the index
102     /// just before a mint/swap/burn.
103     /// @param observationCardinalityNextOld The previous value of the next observation cardinality
104     /// @param observationCardinalityNextNew The updated value of the next observation cardinality
105     event IncreaseObservationCardinalityNext(
106         uint16 observationCardinalityNextOld,
107         uint16 observationCardinalityNextNew
108     );
109 
110     /// @notice Emitted when the protocol fee is changed by the pool
111     /// @param feeProtocol0Old The previous value of the token0 protocol fee
112     /// @param feeProtocol1Old The previous value of the token1 protocol fee
113     /// @param feeProtocol0New The updated value of the token0 protocol fee
114     /// @param feeProtocol1New The updated value of the token1 protocol fee
115     event SetFeeProtocol(uint8 feeProtocol0Old, uint8 feeProtocol1Old, uint8 feeProtocol0New, uint8 feeProtocol1New);
116 
117     /// @notice Emitted when the collected protocol fees are withdrawn by the factory owner
118     /// @param sender The address that collects the protocol fees
119     /// @param recipient The address that receives the collected protocol fees
120     /// @param amount0 The amount of token0 protocol fees that is withdrawn
121     /// @param amount0 The amount of token1 protocol fees that is withdrawn
122     event CollectProtocol(address indexed sender, address indexed recipient, uint128 amount0, uint128 amount1);
123 }
124 
125 // File: @uniswap/v3-core/contracts/interfaces/pool/IUniswapV3PoolOwnerActions.sol
126 
127 
128 pragma solidity >=0.5.0;
129 
130 /// @title Permissioned pool actions
131 /// @notice Contains pool methods that may only be called by the factory owner
132 interface IUniswapV3PoolOwnerActions {
133     /// @notice Set the denominator of the protocol's % share of the fees
134     /// @param feeProtocol0 new protocol fee for token0 of the pool
135     /// @param feeProtocol1 new protocol fee for token1 of the pool
136     function setFeeProtocol(uint8 feeProtocol0, uint8 feeProtocol1) external;
137 
138     /// @notice Collect the protocol fee accrued to the pool
139     /// @param recipient The address to which collected protocol fees should be sent
140     /// @param amount0Requested The maximum amount of token0 to send, can be 0 to collect fees in only token1
141     /// @param amount1Requested The maximum amount of token1 to send, can be 0 to collect fees in only token0
142     /// @return amount0 The protocol fee collected in token0
143     /// @return amount1 The protocol fee collected in token1
144     function collectProtocol(
145         address recipient,
146         uint128 amount0Requested,
147         uint128 amount1Requested
148     ) external returns (uint128 amount0, uint128 amount1);
149 }
150 
151 // File: @uniswap/v3-core/contracts/interfaces/pool/IUniswapV3PoolActions.sol
152 
153 
154 pragma solidity >=0.5.0;
155 
156 /// @title Permissionless pool actions
157 /// @notice Contains pool methods that can be called by anyone
158 interface IUniswapV3PoolActions {
159     /// @notice Sets the initial price for the pool
160     /// @dev Price is represented as a sqrt(amountToken1/amountToken0) Q64.96 value
161     /// @param sqrtPriceX96 the initial sqrt price of the pool as a Q64.96
162     function initialize(uint160 sqrtPriceX96) external;
163 
164     /// @notice Adds liquidity for the given recipient/tickLower/tickUpper position
165     /// @dev The caller of this method receives a callback in the form of IUniswapV3MintCallback#uniswapV3MintCallback
166     /// in which they must pay any token0 or token1 owed for the liquidity. The amount of token0/token1 due depends
167     /// on tickLower, tickUpper, the amount of liquidity, and the current price.
168     /// @param recipient The address for which the liquidity will be created
169     /// @param tickLower The lower tick of the position in which to add liquidity
170     /// @param tickUpper The upper tick of the position in which to add liquidity
171     /// @param amount The amount of liquidity to mint
172     /// @param data Any data that should be passed through to the callback
173     /// @return amount0 The amount of token0 that was paid to mint the given amount of liquidity. Matches the value in the callback
174     /// @return amount1 The amount of token1 that was paid to mint the given amount of liquidity. Matches the value in the callback
175     function mint(
176         address recipient,
177         int24 tickLower,
178         int24 tickUpper,
179         uint128 amount,
180         bytes calldata data
181     ) external returns (uint256 amount0, uint256 amount1);
182 
183     /// @notice Collects tokens owed to a position
184     /// @dev Does not recompute fees earned, which must be done either via mint or burn of any amount of liquidity.
185     /// Collect must be called by the position owner. To withdraw only token0 or only token1, amount0Requested or
186     /// amount1Requested may be set to zero. To withdraw all tokens owed, caller may pass any value greater than the
187     /// actual tokens owed, e.g. type(uint128).max. Tokens owed may be from accumulated swap fees or burned liquidity.
188     /// @param recipient The address which should receive the fees collected
189     /// @param tickLower The lower tick of the position for which to collect fees
190     /// @param tickUpper The upper tick of the position for which to collect fees
191     /// @param amount0Requested How much token0 should be withdrawn from the fees owed
192     /// @param amount1Requested How much token1 should be withdrawn from the fees owed
193     /// @return amount0 The amount of fees collected in token0
194     /// @return amount1 The amount of fees collected in token1
195     function collect(
196         address recipient,
197         int24 tickLower,
198         int24 tickUpper,
199         uint128 amount0Requested,
200         uint128 amount1Requested
201     ) external returns (uint128 amount0, uint128 amount1);
202 
203     /// @notice Burn liquidity from the sender and account tokens owed for the liquidity to the position
204     /// @dev Can be used to trigger a recalculation of fees owed to a position by calling with an amount of 0
205     /// @dev Fees must be collected separately via a call to #collect
206     /// @param tickLower The lower tick of the position for which to burn liquidity
207     /// @param tickUpper The upper tick of the position for which to burn liquidity
208     /// @param amount How much liquidity to burn
209     /// @return amount0 The amount of token0 sent to the recipient
210     /// @return amount1 The amount of token1 sent to the recipient
211     function burn(
212         int24 tickLower,
213         int24 tickUpper,
214         uint128 amount
215     ) external returns (uint256 amount0, uint256 amount1);
216 
217     /// @notice Swap token0 for token1, or token1 for token0
218     /// @dev The caller of this method receives a callback in the form of IUniswapV3SwapCallback#uniswapV3SwapCallback
219     /// @param recipient The address to receive the output of the swap
220     /// @param zeroForOne The direction of the swap, true for token0 to token1, false for token1 to token0
221     /// @param amountSpecified The amount of the swap, which implicitly configures the swap as exact input (positive), or exact output (negative)
222     /// @param sqrtPriceLimitX96 The Q64.96 sqrt price limit. If zero for one, the price cannot be less than this
223     /// value after the swap. If one for zero, the price cannot be greater than this value after the swap
224     /// @param data Any data to be passed through to the callback
225     /// @return amount0 The delta of the balance of token0 of the pool, exact when negative, minimum when positive
226     /// @return amount1 The delta of the balance of token1 of the pool, exact when negative, minimum when positive
227     function swap(
228         address recipient,
229         bool zeroForOne,
230         int256 amountSpecified,
231         uint160 sqrtPriceLimitX96,
232         bytes calldata data
233     ) external returns (int256 amount0, int256 amount1);
234 
235     /// @notice Receive token0 and/or token1 and pay it back, plus a fee, in the callback
236     /// @dev The caller of this method receives a callback in the form of IUniswapV3FlashCallback#uniswapV3FlashCallback
237     /// @dev Can be used to donate underlying tokens pro-rata to currently in-range liquidity providers by calling
238     /// with 0 amount{0,1} and sending the donation amount(s) from the callback
239     /// @param recipient The address which will receive the token0 and token1 amounts
240     /// @param amount0 The amount of token0 to send
241     /// @param amount1 The amount of token1 to send
242     /// @param data Any data to be passed through to the callback
243     function flash(
244         address recipient,
245         uint256 amount0,
246         uint256 amount1,
247         bytes calldata data
248     ) external;
249 
250     /// @notice Increase the maximum number of price and liquidity observations that this pool will store
251     /// @dev This method is no-op if the pool already has an observationCardinalityNext greater than or equal to
252     /// the input observationCardinalityNext.
253     /// @param observationCardinalityNext The desired minimum number of observations for the pool to store
254     function increaseObservationCardinalityNext(uint16 observationCardinalityNext) external;
255 }
256 
257 // File: @uniswap/v3-core/contracts/interfaces/pool/IUniswapV3PoolDerivedState.sol
258 
259 
260 pragma solidity >=0.5.0;
261 
262 /// @title Pool state that is not stored
263 /// @notice Contains view functions to provide information about the pool that is computed rather than stored on the
264 /// blockchain. The functions here may have variable gas costs.
265 interface IUniswapV3PoolDerivedState {
266     /// @notice Returns the cumulative tick and liquidity as of each timestamp `secondsAgo` from the current block timestamp
267     /// @dev To get a time weighted average tick or liquidity-in-range, you must call this with two values, one representing
268     /// the beginning of the period and another for the end of the period. E.g., to get the last hour time-weighted average tick,
269     /// you must call it with secondsAgos = [3600, 0].
270     /// @dev The time weighted average tick represents the geometric time weighted average price of the pool, in
271     /// log base sqrt(1.0001) of token1 / token0. The TickMath library can be used to go from a tick value to a ratio.
272     /// @param secondsAgos From how long ago each cumulative tick and liquidity value should be returned
273     /// @return tickCumulatives Cumulative tick values as of each `secondsAgos` from the current block timestamp
274     /// @return secondsPerLiquidityCumulativeX128s Cumulative seconds per liquidity-in-range value as of each `secondsAgos` from the current block
275     /// timestamp
276     function observe(uint32[] calldata secondsAgos)
277         external
278         view
279         returns (int56[] memory tickCumulatives, uint160[] memory secondsPerLiquidityCumulativeX128s);
280 
281     /// @notice Returns a snapshot of the tick cumulative, seconds per liquidity and seconds inside a tick range
282     /// @dev Snapshots must only be compared to other snapshots, taken over a period for which a position existed.
283     /// I.e., snapshots cannot be compared if a position is not held for the entire period between when the first
284     /// snapshot is taken and the second snapshot is taken.
285     /// @param tickLower The lower tick of the range
286     /// @param tickUpper The upper tick of the range
287     /// @return tickCumulativeInside The snapshot of the tick accumulator for the range
288     /// @return secondsPerLiquidityInsideX128 The snapshot of seconds per liquidity for the range
289     /// @return secondsInside The snapshot of seconds per liquidity for the range
290     function snapshotCumulativesInside(int24 tickLower, int24 tickUpper)
291         external
292         view
293         returns (
294             int56 tickCumulativeInside,
295             uint160 secondsPerLiquidityInsideX128,
296             uint32 secondsInside
297         );
298 }
299 
300 // File: @uniswap/v3-core/contracts/interfaces/pool/IUniswapV3PoolState.sol
301 
302 
303 pragma solidity >=0.5.0;
304 
305 /// @title Pool state that can change
306 /// @notice These methods compose the pool's state, and can change with any frequency including multiple times
307 /// per transaction
308 interface IUniswapV3PoolState {
309     /// @notice The 0th storage slot in the pool stores many values, and is exposed as a single method to save gas
310     /// when accessed externally.
311     /// @return sqrtPriceX96 The current price of the pool as a sqrt(token1/token0) Q64.96 value
312     /// tick The current tick of the pool, i.e. according to the last tick transition that was run.
313     /// This value may not always be equal to SqrtTickMath.getTickAtSqrtRatio(sqrtPriceX96) if the price is on a tick
314     /// boundary.
315     /// observationIndex The index of the last oracle observation that was written,
316     /// observationCardinality The current maximum number of observations stored in the pool,
317     /// observationCardinalityNext The next maximum number of observations, to be updated when the observation.
318     /// feeProtocol The protocol fee for both tokens of the pool.
319     /// Encoded as two 4 bit values, where the protocol fee of token1 is shifted 4 bits and the protocol fee of token0
320     /// is the lower 4 bits. Used as the denominator of a fraction of the swap fee, e.g. 4 means 1/4th of the swap fee.
321     /// unlocked Whether the pool is currently locked to reentrancy
322     function slot0()
323         external
324         view
325         returns (
326             uint160 sqrtPriceX96,
327             int24 tick,
328             uint16 observationIndex,
329             uint16 observationCardinality,
330             uint16 observationCardinalityNext,
331             uint8 feeProtocol,
332             bool unlocked
333         );
334 
335     /// @notice The fee growth as a Q128.128 fees of token0 collected per unit of liquidity for the entire life of the pool
336     /// @dev This value can overflow the uint256
337     function feeGrowthGlobal0X128() external view returns (uint256);
338 
339     /// @notice The fee growth as a Q128.128 fees of token1 collected per unit of liquidity for the entire life of the pool
340     /// @dev This value can overflow the uint256
341     function feeGrowthGlobal1X128() external view returns (uint256);
342 
343     /// @notice The amounts of token0 and token1 that are owed to the protocol
344     /// @dev Protocol fees will never exceed uint128 max in either token
345     function protocolFees() external view returns (uint128 token0, uint128 token1);
346 
347     /// @notice The currently in range liquidity available to the pool
348     /// @dev This value has no relationship to the total liquidity across all ticks
349     function liquidity() external view returns (uint128);
350 
351     /// @notice Look up information about a specific tick in the pool
352     /// @param tick The tick to look up
353     /// @return liquidityGross the total amount of position liquidity that uses the pool either as tick lower or
354     /// tick upper,
355     /// liquidityNet how much liquidity changes when the pool price crosses the tick,
356     /// feeGrowthOutside0X128 the fee growth on the other side of the tick from the current tick in token0,
357     /// feeGrowthOutside1X128 the fee growth on the other side of the tick from the current tick in token1,
358     /// tickCumulativeOutside the cumulative tick value on the other side of the tick from the current tick
359     /// secondsPerLiquidityOutsideX128 the seconds spent per liquidity on the other side of the tick from the current tick,
360     /// secondsOutside the seconds spent on the other side of the tick from the current tick,
361     /// initialized Set to true if the tick is initialized, i.e. liquidityGross is greater than 0, otherwise equal to false.
362     /// Outside values can only be used if the tick is initialized, i.e. if liquidityGross is greater than 0.
363     /// In addition, these values are only relative and must be used only in comparison to previous snapshots for
364     /// a specific position.
365     function ticks(int24 tick)
366         external
367         view
368         returns (
369             uint128 liquidityGross,
370             int128 liquidityNet,
371             uint256 feeGrowthOutside0X128,
372             uint256 feeGrowthOutside1X128,
373             int56 tickCumulativeOutside,
374             uint160 secondsPerLiquidityOutsideX128,
375             uint32 secondsOutside,
376             bool initialized
377         );
378 
379     /// @notice Returns 256 packed tick initialized boolean values. See TickBitmap for more information
380     function tickBitmap(int16 wordPosition) external view returns (uint256);
381 
382     /// @notice Returns the information about a position by the position's key
383     /// @param key The position's key is a hash of a preimage composed by the owner, tickLower and tickUpper
384     /// @return _liquidity The amount of liquidity in the position,
385     /// Returns feeGrowthInside0LastX128 fee growth of token0 inside the tick range as of the last mint/burn/poke,
386     /// Returns feeGrowthInside1LastX128 fee growth of token1 inside the tick range as of the last mint/burn/poke,
387     /// Returns tokensOwed0 the computed amount of token0 owed to the position as of the last mint/burn/poke,
388     /// Returns tokensOwed1 the computed amount of token1 owed to the position as of the last mint/burn/poke
389     function positions(bytes32 key)
390         external
391         view
392         returns (
393             uint128 _liquidity,
394             uint256 feeGrowthInside0LastX128,
395             uint256 feeGrowthInside1LastX128,
396             uint128 tokensOwed0,
397             uint128 tokensOwed1
398         );
399 
400     /// @notice Returns data about a specific observation index
401     /// @param index The element of the observations array to fetch
402     /// @dev You most likely want to use #observe() instead of this method to get an observation as of some amount of time
403     /// ago, rather than at a specific index in the array.
404     /// @return blockTimestamp The timestamp of the observation,
405     /// Returns tickCumulative the tick multiplied by seconds elapsed for the life of the pool as of the observation timestamp,
406     /// Returns secondsPerLiquidityCumulativeX128 the seconds per in range liquidity for the life of the pool as of the observation timestamp,
407     /// Returns initialized whether the observation has been initialized and the values are safe to use
408     function observations(uint256 index)
409         external
410         view
411         returns (
412             uint32 blockTimestamp,
413             int56 tickCumulative,
414             uint160 secondsPerLiquidityCumulativeX128,
415             bool initialized
416         );
417 }
418 
419 // File: @uniswap/v3-core/contracts/interfaces/pool/IUniswapV3PoolImmutables.sol
420 
421 
422 pragma solidity >=0.5.0;
423 
424 /// @title Pool state that never changes
425 /// @notice These parameters are fixed for a pool forever, i.e., the methods will always return the same values
426 interface IUniswapV3PoolImmutables {
427     /// @notice The contract that deployed the pool, which must adhere to the IUniswapV3Factory interface
428     /// @return The contract address
429     function factory() external view returns (address);
430 
431     /// @notice The first of the two tokens of the pool, sorted by address
432     /// @return The token contract address
433     function token0() external view returns (address);
434 
435     /// @notice The second of the two tokens of the pool, sorted by address
436     /// @return The token contract address
437     function token1() external view returns (address);
438 
439     /// @notice The pool's fee in hundredths of a bip, i.e. 1e-6
440     /// @return The fee
441     function fee() external view returns (uint24);
442 
443     /// @notice The pool tick spacing
444     /// @dev Ticks can only be used at multiples of this value, minimum of 1 and always positive
445     /// e.g.: a tickSpacing of 3 means ticks can be initialized every 3rd tick, i.e., ..., -6, -3, 0, 3, 6, ...
446     /// This value is an int24 to avoid casting even though it is always positive.
447     /// @return The tick spacing
448     function tickSpacing() external view returns (int24);
449 
450     /// @notice The maximum amount of position liquidity that can use any tick in the range
451     /// @dev This parameter is enforced per tick to prevent liquidity from overflowing a uint128 at any point, and
452     /// also prevents out-of-range liquidity from being used to prevent adding in-range liquidity to a pool
453     /// @return The max amount of liquidity per tick
454     function maxLiquidityPerTick() external view returns (uint128);
455 }
456 
457 // File: @uniswap/v3-core/contracts/interfaces/IUniswapV3Pool.sol
458 
459 
460 pragma solidity >=0.5.0;
461 
462 
463 
464 
465 
466 
467 
468 /// @title The interface for a Uniswap V3 Pool
469 /// @notice A Uniswap pool facilitates swapping and automated market making between any two assets that strictly conform
470 /// to the ERC20 specification
471 /// @dev The pool interface is broken up into many smaller pieces
472 interface IUniswapV3Pool is
473     IUniswapV3PoolImmutables,
474     IUniswapV3PoolState,
475     IUniswapV3PoolDerivedState,
476     IUniswapV3PoolActions,
477     IUniswapV3PoolOwnerActions,
478     IUniswapV3PoolEvents
479 {
480 
481 }
482 
483 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
484 
485 
486 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
487 
488 pragma solidity ^0.8.0;
489 
490 /**
491  * @dev Interface of the ERC20 standard as defined in the EIP.
492  */
493 interface IERC20 {
494     /**
495      * @dev Emitted when `value` tokens are moved from one account (`from`) to
496      * another (`to`).
497      *
498      * Note that `value` may be zero.
499      */
500     event Transfer(address indexed from, address indexed to, uint256 value);
501 
502     /**
503      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
504      * a call to {approve}. `value` is the new allowance.
505      */
506     event Approval(address indexed owner, address indexed spender, uint256 value);
507 
508     /**
509      * @dev Returns the amount of tokens in existence.
510      */
511     function totalSupply() external view returns (uint256);
512 
513     /**
514      * @dev Returns the amount of tokens owned by `account`.
515      */
516     function balanceOf(address account) external view returns (uint256);
517 
518     /**
519      * @dev Moves `amount` tokens from the caller's account to `to`.
520      *
521      * Returns a boolean value indicating whether the operation succeeded.
522      *
523      * Emits a {Transfer} event.
524      */
525     function transfer(address to, uint256 amount) external returns (bool);
526 
527     /**
528      * @dev Returns the remaining number of tokens that `spender` will be
529      * allowed to spend on behalf of `owner` through {transferFrom}. This is
530      * zero by default.
531      *
532      * This value changes when {approve} or {transferFrom} are called.
533      */
534     function allowance(address owner, address spender) external view returns (uint256);
535 
536     /**
537      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
538      *
539      * Returns a boolean value indicating whether the operation succeeded.
540      *
541      * IMPORTANT: Beware that changing an allowance with this method brings the risk
542      * that someone may use both the old and the new allowance by unfortunate
543      * transaction ordering. One possible solution to mitigate this race
544      * condition is to first reduce the spender's allowance to 0 and set the
545      * desired value afterwards:
546      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
547      *
548      * Emits an {Approval} event.
549      */
550     function approve(address spender, uint256 amount) external returns (bool);
551 
552     /**
553      * @dev Moves `amount` tokens from `from` to `to` using the
554      * allowance mechanism. `amount` is then deducted from the caller's
555      * allowance.
556      *
557      * Returns a boolean value indicating whether the operation succeeded.
558      *
559      * Emits a {Transfer} event.
560      */
561     function transferFrom(
562         address from,
563         address to,
564         uint256 amount
565     ) external returns (bool);
566 }
567 
568 // File: @openzeppelin/contracts/utils/Context.sol
569 
570 
571 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
572 
573 pragma solidity ^0.8.0;
574 
575 /**
576  * @dev Provides information about the current execution context, including the
577  * sender of the transaction and its data. While these are generally available
578  * via msg.sender and msg.data, they should not be accessed in such a direct
579  * manner, since when dealing with meta-transactions the account sending and
580  * paying for execution may not be the actual sender (as far as an application
581  * is concerned).
582  *
583  * This contract is only required for intermediate, library-like contracts.
584  */
585 abstract contract Context {
586     function _msgSender() internal view virtual returns (address) {
587         return msg.sender;
588     }
589 
590     function _msgData() internal view virtual returns (bytes calldata) {
591         return msg.data;
592     }
593 }
594 
595 // File: @openzeppelin/contracts/security/Pausable.sol
596 
597 
598 // OpenZeppelin Contracts (last updated v4.7.0) (security/Pausable.sol)
599 
600 pragma solidity ^0.8.0;
601 
602 
603 /**
604  * @dev Contract module which allows children to implement an emergency stop
605  * mechanism that can be triggered by an authorized account.
606  *
607  * This module is used through inheritance. It will make available the
608  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
609  * the functions of your contract. Note that they will not be pausable by
610  * simply including this module, only once the modifiers are put in place.
611  */
612 abstract contract Pausable is Context {
613     /**
614      * @dev Emitted when the pause is triggered by `account`.
615      */
616     event Paused(address account);
617 
618     /**
619      * @dev Emitted when the pause is lifted by `account`.
620      */
621     event Unpaused(address account);
622 
623     bool private _paused;
624 
625     /**
626      * @dev Initializes the contract in unpaused state.
627      */
628     constructor() {
629         _paused = false;
630     }
631 
632     /**
633      * @dev Modifier to make a function callable only when the contract is not paused.
634      *
635      * Requirements:
636      *
637      * - The contract must not be paused.
638      */
639     modifier whenNotPaused() {
640         _requireNotPaused();
641         _;
642     }
643 
644     /**
645      * @dev Modifier to make a function callable only when the contract is paused.
646      *
647      * Requirements:
648      *
649      * - The contract must be paused.
650      */
651     modifier whenPaused() {
652         _requirePaused();
653         _;
654     }
655 
656     /**
657      * @dev Returns true if the contract is paused, and false otherwise.
658      */
659     function paused() public view virtual returns (bool) {
660         return _paused;
661     }
662 
663     /**
664      * @dev Throws if the contract is paused.
665      */
666     function _requireNotPaused() internal view virtual {
667         require(!paused(), "Pausable: paused");
668     }
669 
670     /**
671      * @dev Throws if the contract is not paused.
672      */
673     function _requirePaused() internal view virtual {
674         require(paused(), "Pausable: not paused");
675     }
676 
677     /**
678      * @dev Triggers stopped state.
679      *
680      * Requirements:
681      *
682      * - The contract must not be paused.
683      */
684     function _pause() internal virtual whenNotPaused {
685         _paused = true;
686         emit Paused(_msgSender());
687     }
688 
689     /**
690      * @dev Returns to normal state.
691      *
692      * Requirements:
693      *
694      * - The contract must be paused.
695      */
696     function _unpause() internal virtual whenPaused {
697         _paused = false;
698         emit Unpaused(_msgSender());
699     }
700 }
701 
702 // File: @openzeppelin/contracts/access/Ownable.sol
703 
704 
705 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
706 
707 pragma solidity ^0.8.0;
708 
709 
710 /**
711  * @dev Contract module which provides a basic access control mechanism, where
712  * there is an account (an owner) that can be granted exclusive access to
713  * specific functions.
714  *
715  * By default, the owner account will be the one that deploys the contract. This
716  * can later be changed with {transferOwnership}.
717  *
718  * This module is used through inheritance. It will make available the modifier
719  * `onlyOwner`, which can be applied to your functions to restrict their use to
720  * the owner.
721  */
722 abstract contract Ownable is Context {
723     address private _owner;
724 
725     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
726 
727     /**
728      * @dev Initializes the contract setting the deployer as the initial owner.
729      */
730     constructor() {
731         _transferOwnership(_msgSender());
732     }
733 
734     /**
735      * @dev Throws if called by any account other than the owner.
736      */
737     modifier onlyOwner() {
738         _checkOwner();
739         _;
740     }
741 
742     /**
743      * @dev Returns the address of the current owner.
744      */
745     function owner() public view virtual returns (address) {
746         return _owner;
747     }
748 
749     /**
750      * @dev Throws if the sender is not the owner.
751      */
752     function _checkOwner() internal view virtual {
753         require(owner() == _msgSender(), "Ownable: caller is not the owner");
754     }
755 
756     /**
757      * @dev Leaves the contract without owner. It will not be possible to call
758      * `onlyOwner` functions anymore. Can only be called by the current owner.
759      *
760      * NOTE: Renouncing ownership will leave the contract without an owner,
761      * thereby removing any functionality that is only available to the owner.
762      */
763     function renounceOwnership() public virtual onlyOwner {
764         _transferOwnership(address(0));
765     }
766 
767     /**
768      * @dev Transfers ownership of the contract to a new account (`newOwner`).
769      * Can only be called by the current owner.
770      */
771     function transferOwnership(address newOwner) public virtual onlyOwner {
772         require(newOwner != address(0), "Ownable: new owner is the zero address");
773         _transferOwnership(newOwner);
774     }
775 
776     /**
777      * @dev Transfers ownership of the contract to a new account (`newOwner`).
778      * Internal function without access restriction.
779      */
780     function _transferOwnership(address newOwner) internal virtual {
781         address oldOwner = _owner;
782         _owner = newOwner;
783         emit OwnershipTransferred(oldOwner, newOwner);
784     }
785 }
786 
787 // File: contracts/ExchangeV2Dino.sol
788 
789 
790 pragma solidity ^0.8.0;
791 
792 
793 
794 
795 
796 //Exchange...selling tokens for ETH
797 contract ExchangeDino is Ownable, Pausable {
798 	uint256 public minAmount = 1 * (10**18); //1 token with 18 decimals
799 	uint256 public maxAmount = 700000 * (10**18); //1000 tokens with 18 decimals
800 	uint256 public errorPercetage = 1;
801 
802 	IERC20 public theToken = IERC20(0x49642110B712C1FD7261Bc074105E9E44676c68F); //the token being sold - DINO
803 
804 	IUniswapV3Pool public pool = IUniswapV3Pool(0x19c10E1F20df3a8c2AC93a62d7FBA719fa777026);
805 
806 	/**
807       Events
808     */
809     event Withdraw(address indexed user, uint256 amount);
810 	event WithdrawTokens(address indexed user, IERC20 indexed token, uint256 amount);
811     event TokenExchanged(address indexed user, uint256 amountTokens, uint256 amountEth);
812 	event AddFunds(address indexed user, uint256 amount);
813 
814 	constructor() {
815 	}
816 
817 	// add funds to the smart contract (must have approval)
818 	function addFunds(uint256 _amount) external {
819 		require(theToken.transferFrom(msg.sender, address(this), _amount), "Transfer failed");
820 		emit AddFunds(msg.sender, _amount);
821 	}
822 
823 	//buy tokens for Wei.  _amountTokens is with decimals
824 	function buyWithWei(uint256 _amountTokens) external payable whenNotPaused {
825 		require(_amountTokens >= minAmount, "below min");
826 		require(_amountTokens <= maxAmount, "above max");
827 		uint amountOut = getAmountOutFromEth(msg.value);
828 		uint amountOfError = amountOut/1000*errorPercetage;
829 		require(amountOut + amountOfError > _amountTokens && amountOut - amountOfError < _amountTokens, "Expected amount is different more than expected");
830 
831 		//you cannot buy more than the contract has
832 		uint256 balToken = theToken.balanceOf(address(this));
833 		require(_amountTokens <= balToken, "contract does not have enough balance");
834 
835 		//finally give the user the tokens
836 		require(theToken.transfer(msg.sender, _amountTokens), "Transfer failed");
837 		emit TokenExchanged(msg.sender, _amountTokens, msg.value);
838 	}
839 
840 	//sets the minimum tokens amount
841 	function setMinAmount(uint256 _newMinAmount) public onlyOwner {
842 		minAmount = _newMinAmount;
843 	}
844 
845 	//sets the maximum tokens amount
846 	function setMaxAmount(uint256 _newMaxAmount) public onlyOwner {
847 		maxAmount = _newMaxAmount;
848 	}
849 
850 	function pause() public onlyOwner {
851 		_pause();
852 	}
853 
854 	function unpause() public onlyOwner {
855 		_unpause();
856 	}
857 
858 	//owner can withdraw ETH
859 	function withdraw() public onlyOwner {
860 		uint256 ethBalance = address(this).balance;
861 		payable(msg.sender).transfer(ethBalance);
862 		emit Withdraw(msg.sender, ethBalance);
863 	}
864 
865 	function withdrawTokens(IERC20 token, uint256 _amount) public onlyOwner {
866 		require(address(token) != address(0));
867 		uint256 balance = token.balanceOf(address(this));
868 		require(_amount <= balance, "not enough balance");
869 		require(token.transfer(msg.sender, _amount), "Transfer failed");
870 		emit WithdrawTokens(msg.sender, token, _amount);
871 	}
872 
873 	function getSqrt() public view returns (uint256) {
874         (uint160 sqrtPriceX96,,,,,,) =  pool.slot0();
875          return sqrtPriceX96;
876 	}
877     
878 	function getAmountOutFromEth(uint256 _amount) public view returns (uint256) {
879 		uint256 result =  (2**192)*_amount/(getSqrt()**2);
880 		return result;
881 	}
882 
883 	function getAmountOutFromTokenToETH(uint256 _amount) public view returns (uint256) {
884         uint256 result = ((getSqrt()**2)*_amount)/(2**192);
885         return result;
886 	}
887 
888 }