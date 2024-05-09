1 // File: contracts\farming\FarmDataRegular.sol
2 
3 //SPDX-License-Identifier: MIT
4 pragma solidity >=0.7.0;
5 
6 struct FarmingPositionRequest {
7     uint256 setupIndex; // index of the chosen setup.
8     uint256 amount0; // amount of main token or liquidity pool token.
9     uint256 amount1; // amount of other token or liquidity pool token. Needed for gen2
10     address positionOwner; // position extension or address(0) [msg.sender].
11     uint256 amount0Min;
12     uint256 amount1Min;
13 }
14 
15 struct FarmingSetupConfiguration {
16     bool add; // true if we're adding a new setup, false we're updating it.
17     bool disable;
18     uint256 index; // index of the setup we're updating.
19     FarmingSetupInfo info; // data of the new or updated setup
20 }
21 
22 struct FarmingSetupInfo {
23     uint256 blockDuration; // duration of setup
24     uint256 startBlock; // optional start block used for the delayed activation of the first setup
25     uint256 originalRewardPerBlock;
26     uint256 minStakeable; // minimum amount of staking tokens.
27     uint256 renewTimes; // if the setup is renewable or if it's one time.
28     address liquidityPoolTokenAddress; // address of the liquidity pool token
29     address mainTokenAddress; // eg. buidl address.
30     bool involvingETH; // if the setup involves ETH or not.
31     uint256 setupsCount; // number of setups created by this info.
32     uint256 lastSetupIndex; // index of last setup;
33     int24 tickLower; // Gen2 Only - tickLower of the UniswapV3 pool
34     int24 tickUpper; // Gen 2 Only - tickUpper of the UniswapV3 pool
35 }
36 
37 struct FarmingSetup {
38     uint256 infoIndex; // setup info
39     bool active; // if the setup is active or not.
40     uint256 startBlock; // farming setup start block.
41     uint256 endBlock; // farming setup end block.
42     uint256 lastUpdateBlock; // number of the block where an update was triggered.
43     uint256 deprecatedObjectId; // need for gen2. uniswapV3 NFT position Id
44     uint256 rewardPerBlock; // farming setup reward per single block.
45     uint128 totalSupply; // Total LP token liquidity of all the positions of this setup
46 }
47 
48 struct FarmingPosition {
49     address uniqueOwner; // address representing the owner of the position.
50     uint256 setupIndex; // the setup index related to this position.
51     uint256 creationBlock; // block when this position was created.
52     uint256 tokenId; // amount of liquidity pool token in the position.
53     uint256 reward; // position reward.
54 }
55 
56 // File: contracts\farming\IFarmMainRegular.sol
57 
58 //SPDX_License_Identifier: MIT
59 pragma solidity >=0.7.0;
60 pragma abicoder v2;
61 
62 
63 interface IFarmMainRegular {
64 
65     function ONE_HUNDRED() external view returns(uint256);
66     function _rewardTokenAddress() external view returns(address);
67     function position(uint256 positionId) external view returns (FarmingPosition memory);
68     function setups() external view returns (FarmingSetup[] memory);
69     function setup(uint256 setupIndex) external view returns (FarmingSetup memory, FarmingSetupInfo memory);
70     function setFarmingSetups(FarmingSetupConfiguration[] memory farmingSetups) external;
71     function openPosition(FarmingPositionRequest calldata request) external payable returns(uint256 positionId);
72     function addLiquidity(uint256 positionId, FarmingPositionRequest calldata request) external payable;
73 }
74 
75 // File: contracts\farming\IFarmExtensionRegular.sol
76 
77 //SPDX_License_Identifier: MIT
78 pragma solidity >=0.7.0;
79 //pragma abicoder v2;
80 
81 
82 interface IFarmExtensionRegular {
83 
84     function init(bool byMint, address host, address treasury) external;
85 
86     function setHost(address host) external;
87     function setTreasury(address treasury) external;
88 
89     function data() external view returns(address farmMainContract, bool byMint, address host, address treasury, address rewardTokenAddress);
90 
91     function transferTo(uint256 amount) external;
92     function backToYou(uint256 amount) external payable;
93 
94     function setFarmingSetups(FarmingSetupConfiguration[] memory farmingSetups) external;
95 }
96 
97 // File: contracts\farming\util\IERC20.sol
98 
99 // SPDX_License_Identifier: MIT
100 
101 pragma solidity >=0.7.0;
102 
103 interface IERC20 {
104 
105     function totalSupply() external view returns (uint256);
106 
107     function balanceOf(address account) external view returns (uint256);
108 
109     function transfer(address recipient, uint256 amount) external returns (bool);
110 
111     function allowance(address owner, address spender) external view returns (uint256);
112 
113     function approve(address spender, uint256 amount) external returns (bool);
114 
115     function safeApprove(address spender, uint256 amount) external;
116 
117     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
118 
119     function decimals() external view returns (uint8);
120 }
121 
122 // File: node_modules\@uniswap\v3-core\contracts\interfaces\pool\IUniswapV3PoolImmutables.sol
123 
124 // SPDX_License_Identifier: GPL-2.0-or-later
125 pragma solidity >=0.5.0;
126 
127 /// @title Pool state that never changes
128 /// @notice These parameters are fixed for a pool forever, i.e., the methods will always return the same values
129 interface IUniswapV3PoolImmutables {
130     /// @notice The contract that deployed the pool, which must adhere to the IUniswapV3Factory interface
131     /// @return The contract address
132     function factory() external view returns (address);
133 
134     /// @notice The first of the two tokens of the pool, sorted by address
135     /// @return The token contract address
136     function token0() external view returns (address);
137 
138     /// @notice The second of the two tokens of the pool, sorted by address
139     /// @return The token contract address
140     function token1() external view returns (address);
141 
142     /// @notice The pool's fee in hundredths of a bip, i.e. 1e-6
143     /// @return The fee
144     function fee() external view returns (uint24);
145 
146     /// @notice The pool tick spacing
147     /// @dev Ticks can only be used at multiples of this value, minimum of 1 and always positive
148     /// e.g.: a tickSpacing of 3 means ticks can be initialized every 3rd tick, i.e., ..., -6, -3, 0, 3, 6, ...
149     /// This value is an int24 to avoid casting even though it is always positive.
150     /// @return The tick spacing
151     function tickSpacing() external view returns (int24);
152 
153     /// @notice The maximum amount of position liquidity that can use any tick in the range
154     /// @dev This parameter is enforced per tick to prevent liquidity from overflowing a uint128 at any point, and
155     /// also prevents out-of-range liquidity from being used to prevent adding in-range liquidity to a pool
156     /// @return The max amount of liquidity per tick
157     function maxLiquidityPerTick() external view returns (uint128);
158 }
159 
160 // File: node_modules\@uniswap\v3-core\contracts\interfaces\pool\IUniswapV3PoolState.sol
161 
162 // SPDX_License_Identifier: GPL-2.0-or-later
163 pragma solidity >=0.5.0;
164 
165 /// @title Pool state that can change
166 /// @notice These methods compose the pool's state, and can change with any frequency including multiple times
167 /// per transaction
168 interface IUniswapV3PoolState {
169     /// @notice The 0th storage slot in the pool stores many values, and is exposed as a single method to save gas
170     /// when accessed externally.
171     /// @return sqrtPriceX96 The current price of the pool as a sqrt(token1/token0) Q64.96 value
172     /// tick The current tick of the pool, i.e. according to the last tick transition that was run.
173     /// This value may not always be equal to SqrtTickMath.getTickAtSqrtRatio(sqrtPriceX96) if the price is on a tick
174     /// boundary.
175     /// observationIndex The index of the last oracle observation that was written,
176     /// observationCardinality The current maximum number of observations stored in the pool,
177     /// observationCardinalityNext The next maximum number of observations, to be updated when the observation.
178     /// feeProtocol The protocol fee for both tokens of the pool.
179     /// Encoded as two 4 bit values, where the protocol fee of token1 is shifted 4 bits and the protocol fee of token0
180     /// is the lower 4 bits. Used as the denominator of a fraction of the swap fee, e.g. 4 means 1/4th of the swap fee.
181     /// unlocked Whether the pool is currently locked to reentrancy
182     function slot0()
183         external
184         view
185         returns (
186             uint160 sqrtPriceX96,
187             int24 tick,
188             uint16 observationIndex,
189             uint16 observationCardinality,
190             uint16 observationCardinalityNext,
191             uint8 feeProtocol,
192             bool unlocked
193         );
194 
195     /// @notice The fee growth as a Q128.128 fees of token0 collected per unit of liquidity for the entire life of the pool
196     /// @dev This value can overflow the uint256
197     function feeGrowthGlobal0X128() external view returns (uint256);
198 
199     /// @notice The fee growth as a Q128.128 fees of token1 collected per unit of liquidity for the entire life of the pool
200     /// @dev This value can overflow the uint256
201     function feeGrowthGlobal1X128() external view returns (uint256);
202 
203     /// @notice The amounts of token0 and token1 that are owed to the protocol
204     /// @dev Protocol fees will never exceed uint128 max in either token
205     function protocolFees() external view returns (uint128 token0, uint128 token1);
206 
207     /// @notice The currently in range liquidity available to the pool
208     /// @dev This value has no relationship to the total liquidity across all ticks
209     function liquidity() external view returns (uint128);
210 
211     /// @notice Look up information about a specific tick in the pool
212     /// @param tick The tick to look up
213     /// @return liquidityGross the total amount of position liquidity that uses the pool either as tick lower or
214     /// tick upper,
215     /// liquidityNet how much liquidity changes when the pool price crosses the tick,
216     /// feeGrowthOutside0X128 the fee growth on the other side of the tick from the current tick in token0,
217     /// feeGrowthOutside1X128 the fee growth on the other side of the tick from the current tick in token1,
218     /// tickCumulativeOutside the cumulative tick value on the other side of the tick from the current tick
219     /// secondsPerLiquidityOutsideX128 the seconds spent per liquidity on the other side of the tick from the current tick,
220     /// secondsOutside the seconds spent on the other side of the tick from the current tick,
221     /// initialized Set to true if the tick is initialized, i.e. liquidityGross is greater than 0, otherwise equal to false.
222     /// Outside values can only be used if the tick is initialized, i.e. if liquidityGross is greater than 0.
223     /// In addition, these values are only relative and must be used only in comparison to previous snapshots for
224     /// a specific position.
225     function ticks(int24 tick)
226         external
227         view
228         returns (
229             uint128 liquidityGross,
230             int128 liquidityNet,
231             uint256 feeGrowthOutside0X128,
232             uint256 feeGrowthOutside1X128,
233             int56 tickCumulativeOutside,
234             uint160 secondsPerLiquidityOutsideX128,
235             uint32 secondsOutside,
236             bool initialized
237         );
238 
239     /// @notice Returns 256 packed tick initialized boolean values. See TickBitmap for more information
240     function tickBitmap(int16 wordPosition) external view returns (uint256);
241 
242     /// @notice Returns the information about a position by the position's key
243     /// @param key The position's key is a hash of a preimage composed by the owner, tickLower and tickUpper
244     /// @return _liquidity The amount of liquidity in the position,
245     /// Returns feeGrowthInside0LastX128 fee growth of token0 inside the tick range as of the last mint/burn/poke,
246     /// Returns feeGrowthInside1LastX128 fee growth of token1 inside the tick range as of the last mint/burn/poke,
247     /// Returns tokensOwed0 the computed amount of token0 owed to the position as of the last mint/burn/poke,
248     /// Returns tokensOwed1 the computed amount of token1 owed to the position as of the last mint/burn/poke
249     function positions(bytes32 key)
250         external
251         view
252         returns (
253             uint128 _liquidity,
254             uint256 feeGrowthInside0LastX128,
255             uint256 feeGrowthInside1LastX128,
256             uint128 tokensOwed0,
257             uint128 tokensOwed1
258         );
259 
260     /// @notice Returns data about a specific observation index
261     /// @param index The element of the observations array to fetch
262     /// @dev You most likely want to use #observe() instead of this method to get an observation as of some amount of time
263     /// ago, rather than at a specific index in the array.
264     /// @return blockTimestamp The timestamp of the observation,
265     /// Returns tickCumulative the tick multiplied by seconds elapsed for the life of the pool as of the observation timestamp,
266     /// Returns secondsPerLiquidityCumulativeX128 the seconds per in range liquidity for the life of the pool as of the observation timestamp,
267     /// Returns initialized whether the observation has been initialized and the values are safe to use
268     function observations(uint256 index)
269         external
270         view
271         returns (
272             uint32 blockTimestamp,
273             int56 tickCumulative,
274             uint160 secondsPerLiquidityCumulativeX128,
275             bool initialized
276         );
277 }
278 
279 // File: node_modules\@uniswap\v3-core\contracts\interfaces\pool\IUniswapV3PoolDerivedState.sol
280 
281 // SPDX_License_Identifier: GPL-2.0-or-later
282 pragma solidity >=0.5.0;
283 
284 /// @title Pool state that is not stored
285 /// @notice Contains view functions to provide information about the pool that is computed rather than stored on the
286 /// blockchain. The functions here may have variable gas costs.
287 interface IUniswapV3PoolDerivedState {
288     /// @notice Returns the cumulative tick and liquidity as of each timestamp `secondsAgo` from the current block timestamp
289     /// @dev To get a time weighted average tick or liquidity-in-range, you must call this with two values, one representing
290     /// the beginning of the period and another for the end of the period. E.g., to get the last hour time-weighted average tick,
291     /// you must call it with secondsAgos = [3600, 0].
292     /// @dev The time weighted average tick represents the geometric time weighted average price of the pool, in
293     /// log base sqrt(1.0001) of token1 / token0. The TickMath library can be used to go from a tick value to a ratio.
294     /// @param secondsAgos From how long ago each cumulative tick and liquidity value should be returned
295     /// @return tickCumulatives Cumulative tick values as of each `secondsAgos` from the current block timestamp
296     /// @return secondsPerLiquidityCumulativeX128s Cumulative seconds per liquidity-in-range value as of each `secondsAgos` from the current block
297     /// timestamp
298     function observe(uint32[] calldata secondsAgos)
299         external
300         view
301         returns (int56[] memory tickCumulatives, uint160[] memory secondsPerLiquidityCumulativeX128s);
302 
303     /// @notice Returns a snapshot of the tick cumulative, seconds per liquidity and seconds inside a tick range
304     /// @dev Snapshots must only be compared to other snapshots, taken over a period for which a position existed.
305     /// I.e., snapshots cannot be compared if a position is not held for the entire period between when the first
306     /// snapshot is taken and the second snapshot is taken.
307     /// @param tickLower The lower tick of the range
308     /// @param tickUpper The upper tick of the range
309     /// @return tickCumulativeInside The snapshot of the tick accumulator for the range
310     /// @return secondsPerLiquidityInsideX128 The snapshot of seconds per liquidity for the range
311     /// @return secondsInside The snapshot of seconds per liquidity for the range
312     function snapshotCumulativesInside(int24 tickLower, int24 tickUpper)
313         external
314         view
315         returns (
316             int56 tickCumulativeInside,
317             uint160 secondsPerLiquidityInsideX128,
318             uint32 secondsInside
319         );
320 }
321 
322 // File: node_modules\@uniswap\v3-core\contracts\interfaces\pool\IUniswapV3PoolActions.sol
323 
324 // SPDX_License_Identifier: GPL-2.0-or-later
325 pragma solidity >=0.5.0;
326 
327 /// @title Permissionless pool actions
328 /// @notice Contains pool methods that can be called by anyone
329 interface IUniswapV3PoolActions {
330     /// @notice Sets the initial price for the pool
331     /// @dev Price is represented as a sqrt(amountToken1/amountToken0) Q64.96 value
332     /// @param sqrtPriceX96 the initial sqrt price of the pool as a Q64.96
333     function initialize(uint160 sqrtPriceX96) external;
334 
335     /// @notice Adds liquidity for the given recipient/tickLower/tickUpper position
336     /// @dev The caller of this method receives a callback in the form of IUniswapV3MintCallback#uniswapV3MintCallback
337     /// in which they must pay any token0 or token1 owed for the liquidity. The amount of token0/token1 due depends
338     /// on tickLower, tickUpper, the amount of liquidity, and the current price.
339     /// @param recipient The address for which the liquidity will be created
340     /// @param tickLower The lower tick of the position in which to add liquidity
341     /// @param tickUpper The upper tick of the position in which to add liquidity
342     /// @param amount The amount of liquidity to mint
343     /// @param data Any data that should be passed through to the callback
344     /// @return amount0 The amount of token0 that was paid to mint the given amount of liquidity. Matches the value in the callback
345     /// @return amount1 The amount of token1 that was paid to mint the given amount of liquidity. Matches the value in the callback
346     function mint(
347         address recipient,
348         int24 tickLower,
349         int24 tickUpper,
350         uint128 amount,
351         bytes calldata data
352     ) external returns (uint256 amount0, uint256 amount1);
353 
354     /// @notice Collects tokens owed to a position
355     /// @dev Does not recompute fees earned, which must be done either via mint or burn of any amount of liquidity.
356     /// Collect must be called by the position owner. To withdraw only token0 or only token1, amount0Requested or
357     /// amount1Requested may be set to zero. To withdraw all tokens owed, caller may pass any value greater than the
358     /// actual tokens owed, e.g. type(uint128).max. Tokens owed may be from accumulated swap fees or burned liquidity.
359     /// @param recipient The address which should receive the fees collected
360     /// @param tickLower The lower tick of the position for which to collect fees
361     /// @param tickUpper The upper tick of the position for which to collect fees
362     /// @param amount0Requested How much token0 should be withdrawn from the fees owed
363     /// @param amount1Requested How much token1 should be withdrawn from the fees owed
364     /// @return amount0 The amount of fees collected in token0
365     /// @return amount1 The amount of fees collected in token1
366     function collect(
367         address recipient,
368         int24 tickLower,
369         int24 tickUpper,
370         uint128 amount0Requested,
371         uint128 amount1Requested
372     ) external returns (uint128 amount0, uint128 amount1);
373 
374     /// @notice Burn liquidity from the sender and account tokens owed for the liquidity to the position
375     /// @dev Can be used to trigger a recalculation of fees owed to a position by calling with an amount of 0
376     /// @dev Fees must be collected separately via a call to #collect
377     /// @param tickLower The lower tick of the position for which to burn liquidity
378     /// @param tickUpper The upper tick of the position for which to burn liquidity
379     /// @param amount How much liquidity to burn
380     /// @return amount0 The amount of token0 sent to the recipient
381     /// @return amount1 The amount of token1 sent to the recipient
382     function burn(
383         int24 tickLower,
384         int24 tickUpper,
385         uint128 amount
386     ) external returns (uint256 amount0, uint256 amount1);
387 
388     /// @notice Swap token0 for token1, or token1 for token0
389     /// @dev The caller of this method receives a callback in the form of IUniswapV3SwapCallback#uniswapV3SwapCallback
390     /// @param recipient The address to receive the output of the swap
391     /// @param zeroForOne The direction of the swap, true for token0 to token1, false for token1 to token0
392     /// @param amountSpecified The amount of the swap, which implicitly configures the swap as exact input (positive), or exact output (negative)
393     /// @param sqrtPriceLimitX96 The Q64.96 sqrt price limit. If zero for one, the price cannot be less than this
394     /// value after the swap. If one for zero, the price cannot be greater than this value after the swap
395     /// @param data Any data to be passed through to the callback
396     /// @return amount0 The delta of the balance of token0 of the pool, exact when negative, minimum when positive
397     /// @return amount1 The delta of the balance of token1 of the pool, exact when negative, minimum when positive
398     function swap(
399         address recipient,
400         bool zeroForOne,
401         int256 amountSpecified,
402         uint160 sqrtPriceLimitX96,
403         bytes calldata data
404     ) external returns (int256 amount0, int256 amount1);
405 
406     /// @notice Receive token0 and/or token1 and pay it back, plus a fee, in the callback
407     /// @dev The caller of this method receives a callback in the form of IUniswapV3FlashCallback#uniswapV3FlashCallback
408     /// @dev Can be used to donate underlying tokens pro-rata to currently in-range liquidity providers by calling
409     /// with 0 amount{0,1} and sending the donation amount(s) from the callback
410     /// @param recipient The address which will receive the token0 and token1 amounts
411     /// @param amount0 The amount of token0 to send
412     /// @param amount1 The amount of token1 to send
413     /// @param data Any data to be passed through to the callback
414     function flash(
415         address recipient,
416         uint256 amount0,
417         uint256 amount1,
418         bytes calldata data
419     ) external;
420 
421     /// @notice Increase the maximum number of price and liquidity observations that this pool will store
422     /// @dev This method is no-op if the pool already has an observationCardinalityNext greater than or equal to
423     /// the input observationCardinalityNext.
424     /// @param observationCardinalityNext The desired minimum number of observations for the pool to store
425     function increaseObservationCardinalityNext(uint16 observationCardinalityNext) external;
426 }
427 
428 // File: node_modules\@uniswap\v3-core\contracts\interfaces\pool\IUniswapV3PoolOwnerActions.sol
429 
430 // SPDX_License_Identifier: GPL-2.0-or-later
431 pragma solidity >=0.5.0;
432 
433 /// @title Permissioned pool actions
434 /// @notice Contains pool methods that may only be called by the factory owner
435 interface IUniswapV3PoolOwnerActions {
436     /// @notice Set the denominator of the protocol's % share of the fees
437     /// @param feeProtocol0 new protocol fee for token0 of the pool
438     /// @param feeProtocol1 new protocol fee for token1 of the pool
439     function setFeeProtocol(uint8 feeProtocol0, uint8 feeProtocol1) external;
440 
441     /// @notice Collect the protocol fee accrued to the pool
442     /// @param recipient The address to which collected protocol fees should be sent
443     /// @param amount0Requested The maximum amount of token0 to send, can be 0 to collect fees in only token1
444     /// @param amount1Requested The maximum amount of token1 to send, can be 0 to collect fees in only token0
445     /// @return amount0 The protocol fee collected in token0
446     /// @return amount1 The protocol fee collected in token1
447     function collectProtocol(
448         address recipient,
449         uint128 amount0Requested,
450         uint128 amount1Requested
451     ) external returns (uint128 amount0, uint128 amount1);
452 }
453 
454 // File: node_modules\@uniswap\v3-core\contracts\interfaces\pool\IUniswapV3PoolEvents.sol
455 
456 // SPDX_License_Identifier: GPL-2.0-or-later
457 pragma solidity >=0.5.0;
458 
459 /// @title Events emitted by a pool
460 /// @notice Contains all events emitted by the pool
461 interface IUniswapV3PoolEvents {
462     /// @notice Emitted exactly once by a pool when #initialize is first called on the pool
463     /// @dev Mint/Burn/Swap cannot be emitted by the pool before Initialize
464     /// @param sqrtPriceX96 The initial sqrt price of the pool, as a Q64.96
465     /// @param tick The initial tick of the pool, i.e. log base 1.0001 of the starting price of the pool
466     event Initialize(uint160 sqrtPriceX96, int24 tick);
467 
468     /// @notice Emitted when liquidity is minted for a given position
469     /// @param sender The address that minted the liquidity
470     /// @param owner The owner of the position and recipient of any minted liquidity
471     /// @param tickLower The lower tick of the position
472     /// @param tickUpper The upper tick of the position
473     /// @param amount The amount of liquidity minted to the position range
474     /// @param amount0 How much token0 was required for the minted liquidity
475     /// @param amount1 How much token1 was required for the minted liquidity
476     event Mint(
477         address sender,
478         address indexed owner,
479         int24 indexed tickLower,
480         int24 indexed tickUpper,
481         uint128 amount,
482         uint256 amount0,
483         uint256 amount1
484     );
485 
486     /// @notice Emitted when fees are collected by the owner of a position
487     /// @dev Collect events may be emitted with zero amount0 and amount1 when the caller chooses not to collect fees
488     /// @param owner The owner of the position for which fees are collected
489     /// @param tickLower The lower tick of the position
490     /// @param tickUpper The upper tick of the position
491     /// @param amount0 The amount of token0 fees collected
492     /// @param amount1 The amount of token1 fees collected
493     event Collect(
494         address indexed owner,
495         address recipient,
496         int24 indexed tickLower,
497         int24 indexed tickUpper,
498         uint128 amount0,
499         uint128 amount1
500     );
501 
502     /// @notice Emitted when a position's liquidity is removed
503     /// @dev Does not withdraw any fees earned by the liquidity position, which must be withdrawn via #collect
504     /// @param owner The owner of the position for which liquidity is removed
505     /// @param tickLower The lower tick of the position
506     /// @param tickUpper The upper tick of the position
507     /// @param amount The amount of liquidity to remove
508     /// @param amount0 The amount of token0 withdrawn
509     /// @param amount1 The amount of token1 withdrawn
510     event Burn(
511         address indexed owner,
512         int24 indexed tickLower,
513         int24 indexed tickUpper,
514         uint128 amount,
515         uint256 amount0,
516         uint256 amount1
517     );
518 
519     /// @notice Emitted by the pool for any swaps between token0 and token1
520     /// @param sender The address that initiated the swap call, and that received the callback
521     /// @param recipient The address that received the output of the swap
522     /// @param amount0 The delta of the token0 balance of the pool
523     /// @param amount1 The delta of the token1 balance of the pool
524     /// @param sqrtPriceX96 The sqrt(price) of the pool after the swap, as a Q64.96
525     /// @param liquidity The liquidity of the pool after the swap
526     /// @param tick The log base 1.0001 of price of the pool after the swap
527     event Swap(
528         address indexed sender,
529         address indexed recipient,
530         int256 amount0,
531         int256 amount1,
532         uint160 sqrtPriceX96,
533         uint128 liquidity,
534         int24 tick
535     );
536 
537     /// @notice Emitted by the pool for any flashes of token0/token1
538     /// @param sender The address that initiated the swap call, and that received the callback
539     /// @param recipient The address that received the tokens from flash
540     /// @param amount0 The amount of token0 that was flashed
541     /// @param amount1 The amount of token1 that was flashed
542     /// @param paid0 The amount of token0 paid for the flash, which can exceed the amount0 plus the fee
543     /// @param paid1 The amount of token1 paid for the flash, which can exceed the amount1 plus the fee
544     event Flash(
545         address indexed sender,
546         address indexed recipient,
547         uint256 amount0,
548         uint256 amount1,
549         uint256 paid0,
550         uint256 paid1
551     );
552 
553     /// @notice Emitted by the pool for increases to the number of observations that can be stored
554     /// @dev observationCardinalityNext is not the observation cardinality until an observation is written at the index
555     /// just before a mint/swap/burn.
556     /// @param observationCardinalityNextOld The previous value of the next observation cardinality
557     /// @param observationCardinalityNextNew The updated value of the next observation cardinality
558     event IncreaseObservationCardinalityNext(
559         uint16 observationCardinalityNextOld,
560         uint16 observationCardinalityNextNew
561     );
562 
563     /// @notice Emitted when the protocol fee is changed by the pool
564     /// @param feeProtocol0Old The previous value of the token0 protocol fee
565     /// @param feeProtocol1Old The previous value of the token1 protocol fee
566     /// @param feeProtocol0New The updated value of the token0 protocol fee
567     /// @param feeProtocol1New The updated value of the token1 protocol fee
568     event SetFeeProtocol(uint8 feeProtocol0Old, uint8 feeProtocol1Old, uint8 feeProtocol0New, uint8 feeProtocol1New);
569 
570     /// @notice Emitted when the collected protocol fees are withdrawn by the factory owner
571     /// @param sender The address that collects the protocol fees
572     /// @param recipient The address that receives the collected protocol fees
573     /// @param amount0 The amount of token0 protocol fees that is withdrawn
574     /// @param amount0 The amount of token1 protocol fees that is withdrawn
575     event CollectProtocol(address indexed sender, address indexed recipient, uint128 amount0, uint128 amount1);
576 }
577 
578 // File: @uniswap\v3-core\contracts\interfaces\IUniswapV3Pool.sol
579 
580 // SPDX_License_Identifier: GPL-2.0-or-later
581 pragma solidity >=0.5.0;
582 
583 
584 
585 
586 
587 
588 
589 /// @title The interface for a Uniswap V3 Pool
590 /// @notice A Uniswap pool facilitates swapping and automated market making between any two assets that strictly conform
591 /// to the ERC20 specification
592 /// @dev The pool interface is broken up into many smaller pieces
593 interface IUniswapV3Pool is
594     IUniswapV3PoolImmutables,
595     IUniswapV3PoolState,
596     IUniswapV3PoolDerivedState,
597     IUniswapV3PoolActions,
598     IUniswapV3PoolOwnerActions,
599     IUniswapV3PoolEvents
600 {
601 
602 }
603 
604 // File: @uniswap\v3-core\contracts\libraries\TickMath.sol
605 
606 // SPDX_License_Identifier: GPL-2.0-or-later
607 pragma solidity >=0.5.0;
608 
609 /// @title Math library for computing sqrt prices from ticks and vice versa
610 /// @notice Computes sqrt price for ticks of size 1.0001, i.e. sqrt(1.0001^tick) as fixed point Q64.96 numbers. Supports
611 /// prices between 2**-128 and 2**128
612 library TickMath {
613     /// @dev The minimum tick that may be passed to #getSqrtRatioAtTick computed from log base 1.0001 of 2**-128
614     int24 internal constant MIN_TICK = -887272;
615     /// @dev The maximum tick that may be passed to #getSqrtRatioAtTick computed from log base 1.0001 of 2**128
616     int24 internal constant MAX_TICK = -MIN_TICK;
617 
618     /// @dev The minimum value that can be returned from #getSqrtRatioAtTick. Equivalent to getSqrtRatioAtTick(MIN_TICK)
619     uint160 internal constant MIN_SQRT_RATIO = 4295128739;
620     /// @dev The maximum value that can be returned from #getSqrtRatioAtTick. Equivalent to getSqrtRatioAtTick(MAX_TICK)
621     uint160 internal constant MAX_SQRT_RATIO = 1461446703485210103287273052203988822378723970342;
622 
623     /// @notice Calculates sqrt(1.0001^tick) * 2^96
624     /// @dev Throws if |tick| > max tick
625     /// @param tick The input tick for the above formula
626     /// @return sqrtPriceX96 A Fixed point Q64.96 number representing the sqrt of the ratio of the two assets (token1/token0)
627     /// at the given tick
628     function getSqrtRatioAtTick(int24 tick) internal pure returns (uint160 sqrtPriceX96) {
629         uint256 absTick = tick < 0 ? uint256(-int256(tick)) : uint256(int256(tick));
630         require(absTick <= uint256(MAX_TICK), 'T');
631 
632         uint256 ratio = absTick & 0x1 != 0 ? 0xfffcb933bd6fad37aa2d162d1a594001 : 0x100000000000000000000000000000000;
633         if (absTick & 0x2 != 0) ratio = (ratio * 0xfff97272373d413259a46990580e213a) >> 128;
634         if (absTick & 0x4 != 0) ratio = (ratio * 0xfff2e50f5f656932ef12357cf3c7fdcc) >> 128;
635         if (absTick & 0x8 != 0) ratio = (ratio * 0xffe5caca7e10e4e61c3624eaa0941cd0) >> 128;
636         if (absTick & 0x10 != 0) ratio = (ratio * 0xffcb9843d60f6159c9db58835c926644) >> 128;
637         if (absTick & 0x20 != 0) ratio = (ratio * 0xff973b41fa98c081472e6896dfb254c0) >> 128;
638         if (absTick & 0x40 != 0) ratio = (ratio * 0xff2ea16466c96a3843ec78b326b52861) >> 128;
639         if (absTick & 0x80 != 0) ratio = (ratio * 0xfe5dee046a99a2a811c461f1969c3053) >> 128;
640         if (absTick & 0x100 != 0) ratio = (ratio * 0xfcbe86c7900a88aedcffc83b479aa3a4) >> 128;
641         if (absTick & 0x200 != 0) ratio = (ratio * 0xf987a7253ac413176f2b074cf7815e54) >> 128;
642         if (absTick & 0x400 != 0) ratio = (ratio * 0xf3392b0822b70005940c7a398e4b70f3) >> 128;
643         if (absTick & 0x800 != 0) ratio = (ratio * 0xe7159475a2c29b7443b29c7fa6e889d9) >> 128;
644         if (absTick & 0x1000 != 0) ratio = (ratio * 0xd097f3bdfd2022b8845ad8f792aa5825) >> 128;
645         if (absTick & 0x2000 != 0) ratio = (ratio * 0xa9f746462d870fdf8a65dc1f90e061e5) >> 128;
646         if (absTick & 0x4000 != 0) ratio = (ratio * 0x70d869a156d2a1b890bb3df62baf32f7) >> 128;
647         if (absTick & 0x8000 != 0) ratio = (ratio * 0x31be135f97d08fd981231505542fcfa6) >> 128;
648         if (absTick & 0x10000 != 0) ratio = (ratio * 0x9aa508b5b7a84e1c677de54f3e99bc9) >> 128;
649         if (absTick & 0x20000 != 0) ratio = (ratio * 0x5d6af8dedb81196699c329225ee604) >> 128;
650         if (absTick & 0x40000 != 0) ratio = (ratio * 0x2216e584f5fa1ea926041bedfe98) >> 128;
651         if (absTick & 0x80000 != 0) ratio = (ratio * 0x48a170391f7dc42444e8fa2) >> 128;
652 
653         if (tick > 0) ratio = type(uint256).max / ratio;
654 
655         // this divides by 1<<32 rounding up to go from a Q128.128 to a Q128.96.
656         // we then downcast because we know the result always fits within 160 bits due to our tick input constraint
657         // we round up in the division so getTickAtSqrtRatio of the output price is always consistent
658         sqrtPriceX96 = uint160((ratio >> 32) + (ratio % (1 << 32) == 0 ? 0 : 1));
659     }
660 
661     /// @notice Calculates the greatest tick value such that getRatioAtTick(tick) <= ratio
662     /// @dev Throws in case sqrtPriceX96 < MIN_SQRT_RATIO, as MIN_SQRT_RATIO is the lowest value getRatioAtTick may
663     /// ever return.
664     /// @param sqrtPriceX96 The sqrt ratio for which to compute the tick as a Q64.96
665     /// @return tick The greatest tick for which the ratio is less than or equal to the input ratio
666     function getTickAtSqrtRatio(uint160 sqrtPriceX96) internal pure returns (int24 tick) {
667         // second inequality must be < because the price can never reach the price at the max tick
668         require(sqrtPriceX96 >= MIN_SQRT_RATIO && sqrtPriceX96 < MAX_SQRT_RATIO, 'R');
669         uint256 ratio = uint256(sqrtPriceX96) << 32;
670 
671         uint256 r = ratio;
672         uint256 msb = 0;
673 
674         assembly {
675             let f := shl(7, gt(r, 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF))
676             msb := or(msb, f)
677             r := shr(f, r)
678         }
679         assembly {
680             let f := shl(6, gt(r, 0xFFFFFFFFFFFFFFFF))
681             msb := or(msb, f)
682             r := shr(f, r)
683         }
684         assembly {
685             let f := shl(5, gt(r, 0xFFFFFFFF))
686             msb := or(msb, f)
687             r := shr(f, r)
688         }
689         assembly {
690             let f := shl(4, gt(r, 0xFFFF))
691             msb := or(msb, f)
692             r := shr(f, r)
693         }
694         assembly {
695             let f := shl(3, gt(r, 0xFF))
696             msb := or(msb, f)
697             r := shr(f, r)
698         }
699         assembly {
700             let f := shl(2, gt(r, 0xF))
701             msb := or(msb, f)
702             r := shr(f, r)
703         }
704         assembly {
705             let f := shl(1, gt(r, 0x3))
706             msb := or(msb, f)
707             r := shr(f, r)
708         }
709         assembly {
710             let f := gt(r, 0x1)
711             msb := or(msb, f)
712         }
713 
714         if (msb >= 128) r = ratio >> (msb - 127);
715         else r = ratio << (127 - msb);
716 
717         int256 log_2 = (int256(msb) - 128) << 64;
718 
719         assembly {
720             r := shr(127, mul(r, r))
721             let f := shr(128, r)
722             log_2 := or(log_2, shl(63, f))
723             r := shr(f, r)
724         }
725         assembly {
726             r := shr(127, mul(r, r))
727             let f := shr(128, r)
728             log_2 := or(log_2, shl(62, f))
729             r := shr(f, r)
730         }
731         assembly {
732             r := shr(127, mul(r, r))
733             let f := shr(128, r)
734             log_2 := or(log_2, shl(61, f))
735             r := shr(f, r)
736         }
737         assembly {
738             r := shr(127, mul(r, r))
739             let f := shr(128, r)
740             log_2 := or(log_2, shl(60, f))
741             r := shr(f, r)
742         }
743         assembly {
744             r := shr(127, mul(r, r))
745             let f := shr(128, r)
746             log_2 := or(log_2, shl(59, f))
747             r := shr(f, r)
748         }
749         assembly {
750             r := shr(127, mul(r, r))
751             let f := shr(128, r)
752             log_2 := or(log_2, shl(58, f))
753             r := shr(f, r)
754         }
755         assembly {
756             r := shr(127, mul(r, r))
757             let f := shr(128, r)
758             log_2 := or(log_2, shl(57, f))
759             r := shr(f, r)
760         }
761         assembly {
762             r := shr(127, mul(r, r))
763             let f := shr(128, r)
764             log_2 := or(log_2, shl(56, f))
765             r := shr(f, r)
766         }
767         assembly {
768             r := shr(127, mul(r, r))
769             let f := shr(128, r)
770             log_2 := or(log_2, shl(55, f))
771             r := shr(f, r)
772         }
773         assembly {
774             r := shr(127, mul(r, r))
775             let f := shr(128, r)
776             log_2 := or(log_2, shl(54, f))
777             r := shr(f, r)
778         }
779         assembly {
780             r := shr(127, mul(r, r))
781             let f := shr(128, r)
782             log_2 := or(log_2, shl(53, f))
783             r := shr(f, r)
784         }
785         assembly {
786             r := shr(127, mul(r, r))
787             let f := shr(128, r)
788             log_2 := or(log_2, shl(52, f))
789             r := shr(f, r)
790         }
791         assembly {
792             r := shr(127, mul(r, r))
793             let f := shr(128, r)
794             log_2 := or(log_2, shl(51, f))
795             r := shr(f, r)
796         }
797         assembly {
798             r := shr(127, mul(r, r))
799             let f := shr(128, r)
800             log_2 := or(log_2, shl(50, f))
801         }
802 
803         int256 log_sqrt10001 = log_2 * 255738958999603826347141; // 128.128 number
804 
805         int24 tickLow = int24((log_sqrt10001 - 3402992956809132418596140100660247210) >> 128);
806         int24 tickHi = int24((log_sqrt10001 + 291339464771989622907027621153398088495) >> 128);
807 
808         tick = tickLow == tickHi ? tickLow : getSqrtRatioAtTick(tickHi) <= sqrtPriceX96 ? tickHi : tickLow;
809     }
810 }
811 
812 // File: node_modules\@openzeppelin\contracts\introspection\IERC165.sol
813 
814 // SPDX_License_Identifier: MIT
815 
816 pragma solidity ^0.7.0;
817 
818 /**
819  * @dev Interface of the ERC165 standard, as defined in the
820  * https://eips.ethereum.org/EIPS/eip-165[EIP].
821  *
822  * Implementers can declare support of contract interfaces, which can then be
823  * queried by others ({ERC165Checker}).
824  *
825  * For an implementation, see {ERC165}.
826  */
827 interface IERC165 {
828     /**
829      * @dev Returns true if this contract implements the interface defined by
830      * `interfaceId`. See the corresponding
831      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
832      * to learn more about how these ids are created.
833      *
834      * This function call must use less than 30 000 gas.
835      */
836     function supportsInterface(bytes4 interfaceId) external view returns (bool);
837 }
838 
839 // File: node_modules\@openzeppelin\contracts\token\ERC721\IERC721.sol
840 
841 // SPDX_License_Identifier: MIT
842 
843 pragma solidity ^0.7.0;
844 
845 
846 /**
847  * @dev Required interface of an ERC721 compliant contract.
848  */
849 interface IERC721 is IERC165 {
850     /**
851      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
852      */
853     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
854 
855     /**
856      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
857      */
858     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
859 
860     /**
861      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
862      */
863     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
864 
865     /**
866      * @dev Returns the number of tokens in ``owner``'s account.
867      */
868     function balanceOf(address owner) external view returns (uint256 balance);
869 
870     /**
871      * @dev Returns the owner of the `tokenId` token.
872      *
873      * Requirements:
874      *
875      * - `tokenId` must exist.
876      */
877     function ownerOf(uint256 tokenId) external view returns (address owner);
878 
879     /**
880      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
881      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
882      *
883      * Requirements:
884      *
885      * - `from` cannot be the zero address.
886      * - `to` cannot be the zero address.
887      * - `tokenId` token must exist and be owned by `from`.
888      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
889      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
890      *
891      * Emits a {Transfer} event.
892      */
893     function safeTransferFrom(address from, address to, uint256 tokenId) external;
894 
895     /**
896      * @dev Transfers `tokenId` token from `from` to `to`.
897      *
898      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
899      *
900      * Requirements:
901      *
902      * - `from` cannot be the zero address.
903      * - `to` cannot be the zero address.
904      * - `tokenId` token must be owned by `from`.
905      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
906      *
907      * Emits a {Transfer} event.
908      */
909     function transferFrom(address from, address to, uint256 tokenId) external;
910 
911     /**
912      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
913      * The approval is cleared when the token is transferred.
914      *
915      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
916      *
917      * Requirements:
918      *
919      * - The caller must own the token or be an approved operator.
920      * - `tokenId` must exist.
921      *
922      * Emits an {Approval} event.
923      */
924     function approve(address to, uint256 tokenId) external;
925 
926     /**
927      * @dev Returns the account approved for `tokenId` token.
928      *
929      * Requirements:
930      *
931      * - `tokenId` must exist.
932      */
933     function getApproved(uint256 tokenId) external view returns (address operator);
934 
935     /**
936      * @dev Approve or remove `operator` as an operator for the caller.
937      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
938      *
939      * Requirements:
940      *
941      * - The `operator` cannot be the caller.
942      *
943      * Emits an {ApprovalForAll} event.
944      */
945     function setApprovalForAll(address operator, bool _approved) external;
946 
947     /**
948      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
949      *
950      * See {setApprovalForAll}
951      */
952     function isApprovedForAll(address owner, address operator) external view returns (bool);
953 
954     /**
955       * @dev Safely transfers `tokenId` token from `from` to `to`.
956       *
957       * Requirements:
958       *
959       * - `from` cannot be the zero address.
960       * - `to` cannot be the zero address.
961       * - `tokenId` token must exist and be owned by `from`.
962       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
963       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
964       *
965       * Emits a {Transfer} event.
966       */
967     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
968 }
969 
970 // File: @openzeppelin\contracts\token\ERC721\IERC721Metadata.sol
971 
972 // SPDX_License_Identifier: MIT
973 
974 pragma solidity ^0.7.0;
975 
976 
977 /**
978  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
979  * @dev See https://eips.ethereum.org/EIPS/eip-721
980  */
981 interface IERC721Metadata is IERC721 {
982 
983     /**
984      * @dev Returns the token collection name.
985      */
986     function name() external view returns (string memory);
987 
988     /**
989      * @dev Returns the token collection symbol.
990      */
991     function symbol() external view returns (string memory);
992 
993     /**
994      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
995      */
996     function tokenURI(uint256 tokenId) external view returns (string memory);
997 }
998 
999 // File: @openzeppelin\contracts\token\ERC721\IERC721Enumerable.sol
1000 
1001 // SPDX_License_Identifier: MIT
1002 
1003 pragma solidity ^0.7.0;
1004 
1005 
1006 /**
1007  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1008  * @dev See https://eips.ethereum.org/EIPS/eip-721
1009  */
1010 interface IERC721Enumerable is IERC721 {
1011 
1012     /**
1013      * @dev Returns the total amount of tokens stored by the contract.
1014      */
1015     function totalSupply() external view returns (uint256);
1016 
1017     /**
1018      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1019      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1020      */
1021     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1022 
1023     /**
1024      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1025      * Use along with {totalSupply} to enumerate all tokens.
1026      */
1027     function tokenByIndex(uint256 index) external view returns (uint256);
1028 }
1029 
1030 // File: node_modules\@uniswap\v3-periphery\contracts\interfaces\IPoolInitializer.sol
1031 
1032 // SPDX_License_Identifier: GPL-2.0-or-later
1033 pragma solidity >=0.7.5;
1034 //pragma abicoder v2;
1035 
1036 /// @title Creates and initializes V3 Pools
1037 /// @notice Provides a method for creating and initializing a pool, if necessary, for bundling with other methods that
1038 /// require the pool to exist.
1039 interface IPoolInitializer {
1040     /// @notice Creates a new pool if it does not exist, then initializes if not initialized
1041     /// @dev This method can be bundled with others via IMulticall for the first action (e.g. mint) performed against a pool
1042     /// @param token0 The contract address of token0 of the pool
1043     /// @param token1 The contract address of token1 of the pool
1044     /// @param fee The fee amount of the v3 pool for the specified token pair
1045     /// @param sqrtPriceX96 The initial square root price of the pool as a Q64.96 value
1046     /// @return pool Returns the pool address based on the pair of tokens and fee, will return the newly created pool address if necessary
1047     function createAndInitializePoolIfNecessary(
1048         address token0,
1049         address token1,
1050         uint24 fee,
1051         uint160 sqrtPriceX96
1052     ) external payable returns (address pool);
1053 }
1054 
1055 // File: node_modules\@uniswap\v3-periphery\contracts\interfaces\IERC721Permit.sol
1056 
1057 // SPDX_License_Identifier: GPL-2.0-or-later
1058 pragma solidity >=0.7.5;
1059 
1060 
1061 /// @title ERC721 with permit
1062 /// @notice Extension to ERC721 that includes a permit function for signature based approvals
1063 interface IERC721Permit is IERC721 {
1064     /// @notice The permit typehash used in the permit signature
1065     /// @return The typehash for the permit
1066     function PERMIT_TYPEHASH() external pure returns (bytes32);
1067 
1068     /// @notice The domain separator used in the permit signature
1069     /// @return The domain seperator used in encoding of permit signature
1070     function DOMAIN_SEPARATOR() external view returns (bytes32);
1071 
1072     /// @notice Approve of a specific token ID for spending by spender via signature
1073     /// @param spender The account that is being approved
1074     /// @param tokenId The ID of the token that is being approved for spending
1075     /// @param deadline The deadline timestamp by which the call must be mined for the approve to work
1076     /// @param v Must produce valid secp256k1 signature from the holder along with `r` and `s`
1077     /// @param r Must produce valid secp256k1 signature from the holder along with `v` and `s`
1078     /// @param s Must produce valid secp256k1 signature from the holder along with `r` and `v`
1079     function permit(
1080         address spender,
1081         uint256 tokenId,
1082         uint256 deadline,
1083         uint8 v,
1084         bytes32 r,
1085         bytes32 s
1086     ) external payable;
1087 }
1088 
1089 // File: node_modules\@uniswap\v3-periphery\contracts\interfaces\IPeripheryPayments.sol
1090 
1091 // SPDX_License_Identifier: GPL-2.0-or-later
1092 pragma solidity >=0.7.5;
1093 
1094 /// @title Periphery Payments
1095 /// @notice Functions to ease deposits and withdrawals of ETH
1096 interface IPeripheryPayments {
1097     /// @notice Unwraps the contract's WETH9 balance and sends it to recipient as ETH.
1098     /// @dev The amountMinimum parameter prevents malicious contracts from stealing WETH9 from users.
1099     /// @param amountMinimum The minimum amount of WETH9 to unwrap
1100     /// @param recipient The address receiving ETH
1101     function unwrapWETH9(uint256 amountMinimum, address recipient) external payable;
1102 
1103     /// @notice Refunds any ETH balance held by this contract to the `msg.sender`
1104     /// @dev Useful for bundling with mint or increase liquidity that uses ether, or exact output swaps
1105     /// that use ether for the input amount
1106     function refundETH() external payable;
1107 
1108     /// @notice Transfers the full amount of a token held by this contract to recipient
1109     /// @dev The amountMinimum parameter prevents malicious contracts from stealing the token from users
1110     /// @param token The contract address of the token which will be transferred to `recipient`
1111     /// @param amountMinimum The minimum amount of token required for a transfer
1112     /// @param recipient The destination address of the token
1113     function sweepToken(
1114         address token,
1115         uint256 amountMinimum,
1116         address recipient
1117     ) external payable;
1118 }
1119 
1120 // File: node_modules\@uniswap\v3-periphery\contracts\interfaces\IPeripheryImmutableState.sol
1121 
1122 // SPDX_License_Identifier: GPL-2.0-or-later
1123 pragma solidity >=0.5.0;
1124 
1125 /// @title Immutable state
1126 /// @notice Functions that return immutable state of the router
1127 interface IPeripheryImmutableState {
1128     /// @return Returns the address of the Uniswap V3 factory
1129     function factory() external view returns (address);
1130 
1131     /// @return Returns the address of WETH9
1132     function WETH9() external view returns (address);
1133 }
1134 
1135 // File: node_modules\@uniswap\v3-periphery\contracts\libraries\PoolAddress.sol
1136 
1137 // SPDX_License_Identifier: GPL-2.0-or-later
1138 pragma solidity >=0.5.0;
1139 
1140 /// @title Provides functions for deriving a pool address from the factory, tokens, and the fee
1141 library PoolAddress {
1142     bytes32 internal constant POOL_INIT_CODE_HASH = 0xe34f199b19b2b4f47f68442619d555527d244f78a3297ea89325f843f87b8b54;
1143 
1144     /// @notice The identifying key of the pool
1145     struct PoolKey {
1146         address token0;
1147         address token1;
1148         uint24 fee;
1149     }
1150 
1151     /// @notice Returns PoolKey: the ordered tokens with the matched fee levels
1152     /// @param tokenA The first token of a pool, unsorted
1153     /// @param tokenB The second token of a pool, unsorted
1154     /// @param fee The fee level of the pool
1155     /// @return Poolkey The pool details with ordered token0 and token1 assignments
1156     function getPoolKey(
1157         address tokenA,
1158         address tokenB,
1159         uint24 fee
1160     ) internal pure returns (PoolKey memory) {
1161         if (tokenA > tokenB) (tokenA, tokenB) = (tokenB, tokenA);
1162         return PoolKey({token0: tokenA, token1: tokenB, fee: fee});
1163     }
1164 
1165     /// @notice Deterministically computes the pool address given the factory and PoolKey
1166     /// @param factory The Uniswap V3 factory contract address
1167     /// @param key The PoolKey
1168     /// @return pool The contract address of the V3 pool
1169     function computeAddress(address factory, PoolKey memory key) internal pure returns (address pool) {
1170         require(key.token0 < key.token1);
1171         pool = address(
1172             uint256(
1173                 keccak256(
1174                     abi.encodePacked(
1175                         hex'ff',
1176                         factory,
1177                         keccak256(abi.encode(key.token0, key.token1, key.fee)),
1178                         POOL_INIT_CODE_HASH
1179                     )
1180                 )
1181             )
1182         );
1183     }
1184 }
1185 
1186 // File: @uniswap\v3-periphery\contracts\interfaces\INonfungiblePositionManager.sol
1187 
1188 // SPDX_License_Identifier: GPL-2.0-or-later
1189 pragma solidity >=0.7.5;
1190 //pragma abicoder v2;
1191 
1192 
1193 
1194 
1195 
1196 
1197 
1198 
1199 /// @title Non-fungible token for positions
1200 /// @notice Wraps Uniswap V3 positions in a non-fungible token interface which allows for them to be transferred
1201 /// and authorized.
1202 interface INonfungiblePositionManager is
1203     IPoolInitializer,
1204     IPeripheryPayments,
1205     IPeripheryImmutableState,
1206     IERC721Metadata,
1207     IERC721Enumerable,
1208     IERC721Permit
1209 {
1210     /// @notice Emitted when liquidity is increased for a position NFT
1211     /// @dev Also emitted when a token is minted
1212     /// @param tokenId The ID of the token for which liquidity was increased
1213     /// @param liquidity The amount by which liquidity for the NFT position was increased
1214     /// @param amount0 The amount of token0 that was paid for the increase in liquidity
1215     /// @param amount1 The amount of token1 that was paid for the increase in liquidity
1216     event IncreaseLiquidity(uint256 indexed tokenId, uint128 liquidity, uint256 amount0, uint256 amount1);
1217     /// @notice Emitted when liquidity is decreased for a position NFT
1218     /// @param tokenId The ID of the token for which liquidity was decreased
1219     /// @param liquidity The amount by which liquidity for the NFT position was decreased
1220     /// @param amount0 The amount of token0 that was accounted for the decrease in liquidity
1221     /// @param amount1 The amount of token1 that was accounted for the decrease in liquidity
1222     event DecreaseLiquidity(uint256 indexed tokenId, uint128 liquidity, uint256 amount0, uint256 amount1);
1223     /// @notice Emitted when tokens are collected for a position NFT
1224     /// @dev The amounts reported may not be exactly equivalent to the amounts transferred, due to rounding behavior
1225     /// @param tokenId The ID of the token for which underlying tokens were collected
1226     /// @param recipient The address of the account that received the collected tokens
1227     /// @param amount0 The amount of token0 owed to the position that was collected
1228     /// @param amount1 The amount of token1 owed to the position that was collected
1229     event Collect(uint256 indexed tokenId, address recipient, uint256 amount0, uint256 amount1);
1230 
1231     /// @notice Returns the position information associated with a given token ID.
1232     /// @dev Throws if the token ID is not valid.
1233     /// @param tokenId The ID of the token that represents the position
1234     /// @return nonce The nonce for permits
1235     /// @return operator The address that is approved for spending
1236     /// @return token0 The address of the token0 for a specific pool
1237     /// @return token1 The address of the token1 for a specific pool
1238     /// @return fee The fee associated with the pool
1239     /// @return tickLower The lower end of the tick range for the position
1240     /// @return tickUpper The higher end of the tick range for the position
1241     /// @return liquidity The liquidity of the position
1242     /// @return feeGrowthInside0LastX128 The fee growth of token0 as of the last action on the individual position
1243     /// @return feeGrowthInside1LastX128 The fee growth of token1 as of the last action on the individual position
1244     /// @return tokensOwed0 The uncollected amount of token0 owed to the position as of the last computation
1245     /// @return tokensOwed1 The uncollected amount of token1 owed to the position as of the last computation
1246     function positions(uint256 tokenId)
1247         external
1248         view
1249         returns (
1250             uint96 nonce,
1251             address operator,
1252             address token0,
1253             address token1,
1254             uint24 fee,
1255             int24 tickLower,
1256             int24 tickUpper,
1257             uint128 liquidity,
1258             uint256 feeGrowthInside0LastX128,
1259             uint256 feeGrowthInside1LastX128,
1260             uint128 tokensOwed0,
1261             uint128 tokensOwed1
1262         );
1263 
1264     struct MintParams {
1265         address token0;
1266         address token1;
1267         uint24 fee;
1268         int24 tickLower;
1269         int24 tickUpper;
1270         uint256 amount0Desired;
1271         uint256 amount1Desired;
1272         uint256 amount0Min;
1273         uint256 amount1Min;
1274         address recipient;
1275         uint256 deadline;
1276     }
1277 
1278     /// @notice Creates a new position wrapped in a NFT
1279     /// @dev Call this when the pool does exist and is initialized. Note that if the pool is created but not initialized
1280     /// a method does not exist, i.e. the pool is assumed to be initialized.
1281     /// @param params The params necessary to mint a position, encoded as `MintParams` in calldata
1282     /// @return tokenId The ID of the token that represents the minted position
1283     /// @return liquidity The amount of liquidity for this position
1284     /// @return amount0 The amount of token0
1285     /// @return amount1 The amount of token1
1286     function mint(MintParams calldata params)
1287         external
1288         payable
1289         returns (
1290             uint256 tokenId,
1291             uint128 liquidity,
1292             uint256 amount0,
1293             uint256 amount1
1294         );
1295 
1296     struct IncreaseLiquidityParams {
1297         uint256 tokenId;
1298         uint256 amount0Desired;
1299         uint256 amount1Desired;
1300         uint256 amount0Min;
1301         uint256 amount1Min;
1302         uint256 deadline;
1303     }
1304 
1305     /// @notice Increases the amount of liquidity in a position, with tokens paid by the `msg.sender`
1306     /// @param params tokenId The ID of the token for which liquidity is being increased,
1307     /// amount0Desired The desired amount of token0 to be spent,
1308     /// amount1Desired The desired amount of token1 to be spent,
1309     /// amount0Min The minimum amount of token0 to spend, which serves as a slippage check,
1310     /// amount1Min The minimum amount of token1 to spend, which serves as a slippage check,
1311     /// deadline The time by which the transaction must be included to effect the change
1312     /// @return liquidity The new liquidity amount as a result of the increase
1313     /// @return amount0 The amount of token0 to acheive resulting liquidity
1314     /// @return amount1 The amount of token1 to acheive resulting liquidity
1315     function increaseLiquidity(IncreaseLiquidityParams calldata params)
1316         external
1317         payable
1318         returns (
1319             uint128 liquidity,
1320             uint256 amount0,
1321             uint256 amount1
1322         );
1323 
1324     struct DecreaseLiquidityParams {
1325         uint256 tokenId;
1326         uint128 liquidity;
1327         uint256 amount0Min;
1328         uint256 amount1Min;
1329         uint256 deadline;
1330     }
1331 
1332     /// @notice Decreases the amount of liquidity in a position and accounts it to the position
1333     /// @param params tokenId The ID of the token for which liquidity is being decreased,
1334     /// amount The amount by which liquidity will be decreased,
1335     /// amount0Min The minimum amount of token0 that should be accounted for the burned liquidity,
1336     /// amount1Min The minimum amount of token1 that should be accounted for the burned liquidity,
1337     /// deadline The time by which the transaction must be included to effect the change
1338     /// @return amount0 The amount of token0 accounted to the position's tokens owed
1339     /// @return amount1 The amount of token1 accounted to the position's tokens owed
1340     function decreaseLiquidity(DecreaseLiquidityParams calldata params)
1341         external
1342         payable
1343         returns (uint256 amount0, uint256 amount1);
1344 
1345     struct CollectParams {
1346         uint256 tokenId;
1347         address recipient;
1348         uint128 amount0Max;
1349         uint128 amount1Max;
1350     }
1351 
1352     /// @notice Collects up to a maximum amount of fees owed to a specific position to the recipient
1353     /// @param params tokenId The ID of the NFT for which tokens are being collected,
1354     /// recipient The account that should receive the tokens,
1355     /// amount0Max The maximum amount of token0 to collect,
1356     /// amount1Max The maximum amount of token1 to collect
1357     /// @return amount0 The amount of fees collected in token0
1358     /// @return amount1 The amount of fees collected in token1
1359     function collect(CollectParams calldata params) external payable returns (uint256 amount0, uint256 amount1);
1360 
1361     /// @notice Burns a token ID, which deletes it from the NFT contract. The token must have 0 liquidity and all tokens
1362     /// must be collected first.
1363     /// @param tokenId The ID of the token that is being burned
1364     function burn(uint256 tokenId) external payable;
1365 }
1366 
1367 // File: @uniswap\v3-periphery\contracts\interfaces\IMulticall.sol
1368 
1369 // SPDX_License_Identifier: GPL-2.0-or-later
1370 pragma solidity >=0.7.5;
1371 //pragma abicoder v2;
1372 
1373 /// @title Multicall interface
1374 /// @notice Enables calling multiple methods in a single call to the contract
1375 interface IMulticall {
1376     /// @notice Call multiple functions in the current contract and return the data from all of them if they all succeed
1377     /// @dev The `msg.value` should not be trusted for any method callable from multicall.
1378     /// @param data The encoded function data for each of the calls to make to this contract
1379     /// @return results The results from each of the calls passed in via data
1380     function multicall(bytes[] calldata data) external payable returns (bytes[] memory results);
1381 }
1382 
1383 // File: contracts\farming\FarmMainRegularMinStake.sol
1384 
1385 //SPDX_License_Identifier: MIT
1386 pragma solidity ^0.7.6;
1387 //pragma abicoder v2;
1388 
1389 
1390 
1391 
1392 
1393 
1394 
1395 
1396 contract FarmMainRegularMinStake is IFarmMainRegular {
1397 
1398     // percentage
1399     uint256 public override constant ONE_HUNDRED = 1e18;
1400     // event that tracks contracts deployed for the given reward token
1401     event RewardToken(address indexed rewardTokenAddress);
1402     // new or transferred farming position event
1403     event Transfer(uint256 indexed positionId, address indexed from, address indexed to);
1404     // event that tracks involved tokens for this contract
1405     event SetupToken(address indexed mainToken, address indexed involvedToken);
1406     // factory address that will create clones of this contract
1407     address public initializer;
1408     // address of the extension of this contract
1409     address public host;
1410     // address of the reward token
1411     address public override _rewardTokenAddress;
1412     // address of the NonfungblePositionManager used for gen2
1413     INonfungiblePositionManager public nonfungiblePositionManager;
1414     // mapping containing all the currently available farming setups info
1415     mapping(uint256 => FarmingSetupInfo) private _setupsInfo;
1416     // counter for the farming setup info
1417     uint256 public _farmingSetupsInfoCount;
1418     // mapping containing all the currently available farming setups
1419     mapping(uint256 => FarmingSetup) private _setups;
1420     // counter for the farming setups
1421     uint256 public _farmingSetupsCount;
1422     // mapping containing all the positions
1423     mapping(uint256 => FarmingPosition) private _positions;
1424     // mapping containing the reward per token per setup per block
1425     mapping(uint256 => uint256) private _rewardPerTokenPerSetup;
1426     // mapping containing the reward per token paid per position
1427     mapping(uint256 => uint256) private _rewardPerTokenPaid;
1428     // mapping containing all the number of opened positions for each setups
1429     mapping(uint256 => uint256) private _setupPositionsCount;
1430     // mapping containing all the reward received/paid per setup
1431     mapping(uint256 => uint256) public _rewardReceived;
1432     mapping(uint256 => uint256) public _rewardPaid;
1433 
1434     address private _WETH;
1435 
1436     /** Modifiers. */
1437 
1438     /** @dev byExtension modifier used to check for unauthorized changes. */
1439     modifier byExtension() {
1440         require(msg.sender == host, "Unauthorized");
1441         _;
1442     }
1443 
1444     /** @dev byPositionOwner modifier used to check for unauthorized accesses. */
1445     modifier byPositionOwner(uint256 positionId) {
1446         require(_positions[positionId].uniqueOwner == msg.sender && _positions[positionId].creationBlock != 0, "Not owned");
1447         _;
1448     }
1449 
1450     /** @dev activeSetupOnly modifier used to check for function calls only if the setup is active. */
1451     modifier activeSetupOnly(uint256 setupIndex) {
1452         require(_setups[setupIndex].active, "Setup not active");
1453         require(_setups[setupIndex].startBlock <= block.number && _setups[setupIndex].endBlock > block.number, "Invalid setup");
1454         _;
1455     }
1456 
1457     receive() external payable {}
1458 
1459     /** Extension methods */
1460 
1461     /** dev initializes the farming contract.
1462       * param extension extension address.
1463       * param extensionInitData lm extension init payload.
1464       * param uniswapV3NonfungiblePositionManager Uniswap V3 Nonfungible Position Manager address.
1465       * param rewardTokenAddress address of the reward token.
1466       * param farmingSetupInfosBytes optional initial farming Setup Info
1467       * return extensionReturnCall result of the extension initialization function, if it was called.
1468      */
1469     function lazyInit(bytes memory lazyInitData) public returns(bytes memory extensionReturnCall) {
1470         require(initializer == address(0), "Already initialized");
1471         initializer = msg.sender;
1472         address uniswapV3NonfungiblePositionManager;
1473         (uniswapV3NonfungiblePositionManager, lazyInitData) = abi.decode(lazyInitData, (address, bytes));
1474         (address extension, bytes memory extensionInitData, address rewardTokenAddress, bytes memory farmingSetupInfosBytes) = abi.decode(lazyInitData, (address, bytes, address, bytes));
1475         require((host = extension) != address(0), "extension");
1476         emit RewardToken(_rewardTokenAddress = rewardTokenAddress);
1477         if (keccak256(extensionInitData) != keccak256("")) {
1478             extensionReturnCall = _call(host, extensionInitData);
1479         }
1480         _WETH = (nonfungiblePositionManager = INonfungiblePositionManager(uniswapV3NonfungiblePositionManager)).WETH9();
1481         if(farmingSetupInfosBytes.length > 0) {
1482             FarmingSetupInfo[] memory farmingSetupInfos = abi.decode(farmingSetupInfosBytes, (FarmingSetupInfo[]));
1483             for(uint256 i = 0; i < farmingSetupInfos.length; i++) {
1484                 _setOrAddFarmingSetupInfo(farmingSetupInfos[i], true, false, 0);
1485             }
1486         }
1487     }
1488 
1489     function setFarmingSetups(FarmingSetupConfiguration[] memory farmingSetups) public override byExtension {
1490         for (uint256 i = 0; i < farmingSetups.length; i++) {
1491             _setOrAddFarmingSetupInfo(farmingSetups[i].info, farmingSetups[i].add, farmingSetups[i].disable, farmingSetups[i].index);
1492         }
1493     }
1494 
1495     function finalFlush(address[] calldata tokens, uint256[] calldata amounts) public {
1496         for(uint256 i = 0; i < _farmingSetupsCount; i++) {
1497             require(_setupPositionsCount[i] == 0 && !_setups[i].active && _setups[i].totalSupply == 0, "Not Empty");
1498         }
1499         (,,, address receiver,) = IFarmExtensionRegular(host).data();
1500         require(tokens.length == amounts.length, "length");
1501         for(uint256 i = 0; i < tokens.length; i++) {
1502             address token = tokens[i];
1503             uint256 amount = amounts[i];
1504             require(receiver != address(0));
1505             if(token == address(0)) {
1506                 (bool result,) = receiver.call{value : amount}("");
1507                 require(result, "ETH");
1508             } else {
1509                 _safeTransfer(token, receiver, amount);
1510             }
1511         }
1512     }
1513 
1514     /** Public methods */
1515 
1516     /** @dev returns the position with the given id.
1517       * @param positionId id of the position.
1518       * @return farming position with the given id.
1519      */
1520     function position(uint256 positionId) public override view returns (FarmingPosition memory) {
1521         return _positions[positionId];
1522     }
1523 
1524     function setup(uint256 setupIndex) public override view returns (FarmingSetup memory, FarmingSetupInfo memory) {
1525         return (_setups[setupIndex], _setupsInfo[_setups[setupIndex].infoIndex]);
1526     }
1527 
1528     function setups() public override view returns (FarmingSetup[] memory) {
1529         FarmingSetup[] memory farmingSetups = new FarmingSetup[](_farmingSetupsCount);
1530         for (uint256 i = 0; i < _farmingSetupsCount; i++) {
1531             farmingSetups[i] = _setups[i];
1532         }
1533         return farmingSetups;
1534     }
1535 
1536     function activateSetup(uint256 setupInfoIndex) public {
1537         require(_setupsInfo[setupInfoIndex].renewTimes > 0 && !_setups[_setupsInfo[setupInfoIndex].lastSetupIndex].active, "Invalid toggle.");
1538         _toggleSetup(_setupsInfo[setupInfoIndex].lastSetupIndex);
1539     }
1540 
1541     function toggleSetup(uint256 setupInfoIndex) public {
1542         uint256 setupIndex = _setupsInfo[setupInfoIndex].lastSetupIndex;
1543         require(_setups[setupIndex].active && block.number > _setups[setupIndex].endBlock, "Invalid toggle.");
1544         _toggleSetup(setupIndex);
1545         _tryClearSetup(setupIndex);
1546     }
1547 
1548     function openPosition(FarmingPositionRequest memory request) public override payable returns(uint256 positionId) {
1549         if(!_setups[request.setupIndex].active) {
1550             activateSetup(_setups[request.setupIndex].infoIndex);
1551         }
1552         require(_setups[request.setupIndex].active, "Setup not active");
1553         require(_setups[request.setupIndex].startBlock <= block.number && _setups[request.setupIndex].endBlock > block.number, "Invalid setup");
1554         // retrieve the unique owner
1555         address uniqueOwner = (request.positionOwner != address(0)) ? request.positionOwner : msg.sender;
1556         // create the position id
1557         positionId = uint256(keccak256(abi.encode(uniqueOwner, request.setupIndex)));
1558         require(_positions[positionId].creationBlock == 0, "Invalid open");
1559         (uint256 tokenId, uint128 liquidityAmount) = _addLiquidity(request.setupIndex, request, 0);
1560         _updateFreeSetup(request.setupIndex, liquidityAmount, positionId, false);
1561         _positions[positionId] = FarmingPosition({
1562             uniqueOwner: uniqueOwner,
1563             setupIndex : request.setupIndex,
1564             tokenId: tokenId,
1565             reward: 0,
1566             creationBlock: block.number
1567         });
1568         _setupPositionsCount[request.setupIndex] += 1;
1569         emit Transfer(positionId, address(0), uniqueOwner);
1570     }
1571 
1572     function addLiquidity(uint256 positionId, FarmingPositionRequest memory request) public override payable activeSetupOnly(request.setupIndex) byPositionOwner(positionId) {
1573         // retrieve farming position
1574         FarmingPosition storage farmingPosition = _positions[positionId];
1575         FarmingSetup storage chosenSetup = _setups[farmingPosition.setupIndex];
1576         // rebalance the reward per token
1577         _rewardPerTokenPerSetup[farmingPosition.setupIndex] += (((block.number - chosenSetup.lastUpdateBlock) * chosenSetup.rewardPerBlock) * 1e18) / chosenSetup.totalSupply;
1578         farmingPosition.reward = calculateFreeFarmingReward(positionId, false);
1579         (, uint128 liquidityAmount) = _addLiquidity(farmingPosition.setupIndex, request, farmingPosition.tokenId);
1580         _rewardPerTokenPaid[positionId] = _rewardPerTokenPerSetup[farmingPosition.setupIndex];
1581         // update the last block update variablex
1582         chosenSetup.lastUpdateBlock = block.number;
1583         chosenSetup.totalSupply += liquidityAmount;
1584     }
1585 
1586 
1587     /** @dev this function allows a user to withdraw the reward.
1588       * @param positionId farming position id.
1589      */
1590     function withdrawReward(uint256 positionId) external byPositionOwner(positionId) {
1591         _withdrawReward(positionId, 0, 0, 0, "");
1592     }
1593 
1594     function _withdrawReward(uint256 positionId, uint128 liquidityToRemove, uint256 amount0Min, uint256 amount1Min, bytes memory burnData) private {
1595         // retrieve farming position
1596         FarmingPosition storage farmingPosition = _positions[positionId];
1597         FarmingSetup storage farmingSetup = _setups[farmingPosition.setupIndex];
1598         uint256 reward = farmingPosition.reward;
1599         uint256 currentBlock = block.number;
1600         // rebalance setup
1601         currentBlock = currentBlock > farmingSetup.endBlock ? farmingSetup.endBlock : currentBlock;
1602         _rewardPerTokenPerSetup[farmingPosition.setupIndex] += (((currentBlock - farmingSetup.lastUpdateBlock) * farmingSetup.rewardPerBlock) * 1e18) / farmingSetup.totalSupply;
1603         reward = calculateFreeFarmingReward(positionId, false);
1604         _rewardPerTokenPaid[positionId] = _rewardPerTokenPerSetup[farmingPosition.setupIndex];
1605         farmingPosition.reward = 0;
1606         // update the last block update variable
1607         farmingSetup.lastUpdateBlock = currentBlock;
1608         _safeTransfer(_rewardTokenAddress, farmingPosition.uniqueOwner, reward);
1609 
1610         _retrieveGen2LiquidityAndFees(positionId, farmingPosition.tokenId, farmingPosition.uniqueOwner, liquidityToRemove, amount0Min, amount1Min, burnData);
1611 
1612         _rewardPaid[farmingPosition.setupIndex] += reward;
1613         if (farmingSetup.endBlock <= block.number && farmingSetup.active) {
1614             _toggleSetup(farmingPosition.setupIndex);
1615         }
1616     }
1617 
1618     function withdrawLiquidity(uint256 positionId, uint128 removedLiquidity, bytes memory burnData) byPositionOwner(positionId) public {
1619         _withdrawLiquidity(positionId, removedLiquidity, 0, 0, burnData);
1620     }
1621 
1622     function withdrawLiquidity(uint256 positionId, uint128 removedLiquidity, uint256 amount0Min, uint256 amount1Min, bytes memory burnData) byPositionOwner(positionId) public {
1623         _withdrawLiquidity(positionId, removedLiquidity, amount0Min, amount1Min, burnData);
1624     }
1625 
1626     function _withdrawLiquidity(uint256 positionId, uint128 removedLiquidity, uint256 amount0Min, uint256 amount1Min, bytes memory burnData) public {
1627         // retrieve farming position
1628         FarmingPosition storage farmingPosition = _positions[positionId];
1629         uint128 liquidityPoolTokenAmount = _getLiquidityPoolTokenAmount(farmingPosition.tokenId);
1630         // current owned liquidity
1631         require(
1632             farmingPosition.creationBlock != 0 &&
1633             removedLiquidity <= liquidityPoolTokenAmount &&
1634             farmingPosition.uniqueOwner == msg.sender,
1635             "Invalid withdraw"
1636         );
1637         _withdrawReward(positionId, removedLiquidity, amount0Min, amount1Min, burnData);
1638         _setups[farmingPosition.setupIndex].totalSupply -= removedLiquidity;
1639         liquidityPoolTokenAmount -= removedLiquidity;
1640         // delete the farming position after the withdraw
1641         if (liquidityPoolTokenAmount == 0) {
1642             _setupPositionsCount[farmingPosition.setupIndex] -= 1;
1643             address(nonfungiblePositionManager).call(abi.encodeWithSelector(nonfungiblePositionManager.collect.selector, INonfungiblePositionManager.CollectParams({
1644                 tokenId: farmingPosition.tokenId,
1645                 recipient: farmingPosition.uniqueOwner,
1646                 amount0Max: 0xffffffffffffffffffffffffffffffff,
1647                 amount1Max: 0xffffffffffffffffffffffffffffffff
1648             })));
1649             nonfungiblePositionManager.burn(farmingPosition.tokenId);
1650             _tryClearSetup(farmingPosition.setupIndex);
1651             delete _positions[positionId];
1652         } else {
1653             require(_setupsInfo[_setups[farmingPosition.setupIndex].infoIndex].minStakeable == 0, "Min stake: cannot remove partial liquidity");
1654         }
1655     }
1656 
1657     function _tryClearSetup(uint256 setupIndex) private {
1658         if (_setupPositionsCount[setupIndex] == 0 && !_setups[setupIndex].active) {
1659             delete _setups[setupIndex];
1660         }
1661     }
1662 
1663     function calculateFreeFarmingReward(uint256 positionId, bool isExt) public view returns(uint256 reward) {
1664         FarmingPosition memory farmingPosition = _positions[positionId];
1665         uint128 liquidityPoolTokenAmount = _getLiquidityPoolTokenAmount(farmingPosition.tokenId);
1666         reward = ((_rewardPerTokenPerSetup[farmingPosition.setupIndex] - _rewardPerTokenPaid[positionId]) * liquidityPoolTokenAmount) / 1e18;
1667         if (isExt) {
1668             uint256 currentBlock = block.number < _setups[farmingPosition.setupIndex].endBlock ? block.number : _setups[farmingPosition.setupIndex].endBlock;
1669             uint256 lastUpdateBlock = _setups[farmingPosition.setupIndex].lastUpdateBlock < _setups[farmingPosition.setupIndex].startBlock ? _setups[farmingPosition.setupIndex].startBlock : _setups[farmingPosition.setupIndex].lastUpdateBlock;
1670             uint256 rpt = (((currentBlock - lastUpdateBlock) * _setups[farmingPosition.setupIndex].rewardPerBlock) * 1e18) / _setups[farmingPosition.setupIndex].totalSupply;
1671             reward += (rpt * liquidityPoolTokenAmount) / 1e18;
1672         }
1673         reward += farmingPosition.reward;
1674     }
1675 
1676     /** Private methods */
1677 
1678     function _getLiquidityPoolTokenAmount(uint256 tokenId) private view returns (uint128 liquidityAmount){
1679         (,,,,,,,liquidityAmount,,,,) = nonfungiblePositionManager.positions(tokenId);
1680     }
1681 
1682     function _setOrAddFarmingSetupInfo(FarmingSetupInfo memory info, bool add, bool disable, uint256 setupIndex) private {
1683         FarmingSetupInfo memory farmingSetupInfo = info;
1684 
1685         if(add || !disable) {
1686             farmingSetupInfo.renewTimes = farmingSetupInfo.renewTimes + 1;
1687             if(farmingSetupInfo.renewTimes == 0) {
1688                 farmingSetupInfo.renewTimes = farmingSetupInfo.renewTimes - 1;
1689             }
1690         }
1691 
1692         if (add) {
1693             require(
1694                 farmingSetupInfo.liquidityPoolTokenAddress != address(0) &&
1695                 farmingSetupInfo.originalRewardPerBlock > 0,
1696                 "Invalid setup configuration"
1697             );
1698             _checkTicks(farmingSetupInfo.tickLower, farmingSetupInfo.tickUpper);
1699             address[] memory tokenAddresses = new address[](2);
1700             tokenAddresses[0] = IUniswapV3Pool(info.liquidityPoolTokenAddress).token0();
1701             tokenAddresses[1] = IUniswapV3Pool(info.liquidityPoolTokenAddress).token1();
1702             bool mainTokenFound = false;
1703             bool ethTokenFound = false;
1704             for(uint256 z = 0; z < tokenAddresses.length; z++) {
1705                 if(tokenAddresses[z] == _WETH) {
1706                     ethTokenFound = true;
1707                 }
1708                 if(tokenAddresses[z] == farmingSetupInfo.mainTokenAddress) {
1709                     mainTokenFound = true;
1710                 } else {
1711                     emit SetupToken(farmingSetupInfo.mainTokenAddress, tokenAddresses[z]);
1712                 }
1713             }
1714             require(mainTokenFound, "No main token");
1715             require(!farmingSetupInfo.involvingETH || ethTokenFound, "No ETH token");
1716             farmingSetupInfo.setupsCount = 0;
1717             _setupsInfo[_farmingSetupsInfoCount] = farmingSetupInfo;
1718             _setups[_farmingSetupsCount] = FarmingSetup(_farmingSetupsInfoCount, false, 0, 0, 0, 0, farmingSetupInfo.originalRewardPerBlock, 0);
1719             _setupsInfo[_farmingSetupsInfoCount].lastSetupIndex = _farmingSetupsCount;
1720             _farmingSetupsInfoCount += 1;
1721             _farmingSetupsCount += 1;
1722             return;
1723         }
1724 
1725         FarmingSetup storage setup = _setups[setupIndex];
1726         farmingSetupInfo = _setupsInfo[_setups[setupIndex].infoIndex];
1727 
1728         if(disable) {
1729             require(setup.active, "Not possible");
1730             _toggleSetup(setupIndex);
1731             return;
1732         }
1733 
1734         info.renewTimes -= 1;
1735 
1736         if (setup.active) {
1737             setup = _setups[setupIndex];
1738             if(block.number < setup.endBlock) {
1739                 uint256 difference = info.originalRewardPerBlock < farmingSetupInfo.originalRewardPerBlock ? farmingSetupInfo.originalRewardPerBlock - info.originalRewardPerBlock : info.originalRewardPerBlock - farmingSetupInfo.originalRewardPerBlock;
1740                 uint256 duration = setup.endBlock - block.number;
1741                 uint256 amount = difference * duration;
1742                 if (amount > 0) {
1743                     if (info.originalRewardPerBlock > farmingSetupInfo.originalRewardPerBlock) {
1744                         require(_ensureTransfer(amount), "Insufficient reward in extension.");
1745                         _rewardReceived[setupIndex] += amount;
1746                     }
1747                     _updateFreeSetup(setupIndex, 0, 0, false);
1748                     setup.rewardPerBlock = info.originalRewardPerBlock;
1749                 }
1750             }
1751             _setupsInfo[_setups[setupIndex].infoIndex].originalRewardPerBlock = info.originalRewardPerBlock;
1752         }
1753         if(_setupsInfo[_setups[setupIndex].infoIndex].renewTimes > 0) {
1754             _setupsInfo[_setups[setupIndex].infoIndex].renewTimes = info.renewTimes;
1755         }
1756     }
1757 
1758     function _transferToMeAndCheckAllowance(FarmingSetup memory setup, FarmingPositionRequest memory request) private returns(uint256 mainTokenPosition) {
1759         address[] memory tokens = new address[](2);
1760         tokens[0] = IUniswapV3Pool(_setupsInfo[setup.infoIndex].liquidityPoolTokenAddress).token0();
1761         tokens[1] = IUniswapV3Pool(_setupsInfo[setup.infoIndex].liquidityPoolTokenAddress).token1();
1762         mainTokenPosition = _setupsInfo[setup.infoIndex].mainTokenAddress == tokens[0] ? 0 : 1;
1763         uint256[] memory tokenAmounts = new uint256[](2);
1764         tokenAmounts[0] = request.amount0;
1765         tokenAmounts[1] = request.amount1;
1766         require((_setupsInfo[setup.infoIndex].mainTokenAddress == tokens[0] ? tokenAmounts[0] : tokenAmounts[1]) >= _setupsInfo[setup.infoIndex].minStakeable, "Invalid liquidity.");
1767         // iterate the tokens and perform the transferFrom and the approve
1768         for(uint256 i = 0; i < tokens.length; i++) {
1769             if(_setupsInfo[setup.infoIndex].involvingETH && _WETH == tokens[i]) {
1770                 require(msg.value == tokenAmounts[i], "Incorrect eth value");
1771             } else {
1772                 _safeTransferFrom(tokens[i], msg.sender, address(this), tokenAmounts[i]);
1773                 _safeApprove(tokens[i], address(nonfungiblePositionManager), tokenAmounts[i]);
1774             }
1775         }
1776     }
1777 
1778     /// @dev addliquidity only for gen2
1779     function _addLiquidity(uint256 setupIndex, FarmingPositionRequest memory request, uint256 tokenIdInput) private returns(uint256 tokenId, uint128 liquidityAmount) {
1780         tokenId = tokenIdInput;
1781         uint256 mainTokenPosition = _transferToMeAndCheckAllowance(_setups[setupIndex], request);
1782 
1783         FarmingSetupInfo memory setupInfo = _setupsInfo[_setups[setupIndex].infoIndex];
1784         bytes[] memory data = new bytes[](setupInfo.involvingETH ? 2 : 1);
1785 
1786         address token0 = IUniswapV3Pool(setupInfo.liquidityPoolTokenAddress).token0();
1787         address token1 = IUniswapV3Pool(setupInfo.liquidityPoolTokenAddress).token1();
1788         uint256 ethValue = setupInfo.involvingETH ? token0 == _WETH ? request.amount0 : request.amount1 : 0;
1789         uint256 amount0;
1790         uint256 amount1;
1791 
1792         if(setupInfo.involvingETH) {
1793             data[1] = abi.encodeWithSelector(nonfungiblePositionManager.refundETH.selector);
1794         }
1795         if(tokenId == 0) {
1796             data[0] = abi.encodeWithSelector(nonfungiblePositionManager.mint.selector, INonfungiblePositionManager.MintParams({
1797                 token0: token0,
1798                 token1: token1,
1799                 fee: IUniswapV3Pool(setupInfo.liquidityPoolTokenAddress).fee(),
1800                 tickLower: setupInfo.tickLower,
1801                 tickUpper: setupInfo.tickUpper,
1802                 amount0Desired: request.amount0,
1803                 amount1Desired: request.amount1,
1804                 amount0Min: request.amount0Min,
1805                 amount1Min: request.amount1Min,
1806                 recipient: address(this),
1807                 deadline: block.timestamp + 10000
1808             }));
1809             (tokenId, liquidityAmount, amount0, amount1) = abi.decode(IMulticall(address(nonfungiblePositionManager)).multicall{ value: ethValue }(data)[0], (uint256, uint128, uint256, uint256));
1810         } else {
1811             data[0] = abi.encodeWithSelector(nonfungiblePositionManager.increaseLiquidity.selector, INonfungiblePositionManager.IncreaseLiquidityParams({
1812                 tokenId: tokenId,
1813                 amount0Desired: request.amount0,
1814                 amount1Desired: request.amount1,
1815                 amount0Min: request.amount0Min,
1816                 amount1Min: request.amount1Min,
1817                 deadline: block.timestamp + 10000
1818             }));
1819             (liquidityAmount, amount0, amount1) = abi.decode(IMulticall(address(nonfungiblePositionManager)).multicall{ value : ethValue }(data)[0], (uint128, uint256, uint256));
1820         }
1821 
1822         require((mainTokenPosition == 0 ? amount0 : amount1) >= setupInfo.minStakeable, "Min stakeable unreached");
1823 
1824         if(amount0 < request.amount0){
1825             _safeTransfer(setupInfo.involvingETH && token0 == _WETH ? address(0) : token0, msg.sender, request.amount0 - amount0);
1826         }
1827 
1828         if(amount1 < request.amount1){
1829             _safeTransfer(setupInfo.involvingETH && token1 == _WETH ? address(0) : token1, msg.sender, request.amount1 - amount1);
1830         }
1831     }
1832 
1833     /** @dev updates the free setup with the given index.
1834       * @param setupIndex index of the setup that we're updating.
1835       * @param amount amount of liquidity that we're adding/removeing.
1836       * @param positionId position id.
1837       * @param fromExit if it's from an exit or not.
1838      */
1839     function _updateFreeSetup(uint256 setupIndex, uint128 amount, uint256 positionId, bool fromExit) private {
1840         uint256 currentBlock = block.number < _setups[setupIndex].endBlock ? block.number : _setups[setupIndex].endBlock;
1841         if (_setups[setupIndex].totalSupply != 0) {
1842             uint256 lastUpdateBlock = _setups[setupIndex].lastUpdateBlock < _setups[setupIndex].startBlock ? _setups[setupIndex].startBlock : _setups[setupIndex].lastUpdateBlock;
1843             _rewardPerTokenPerSetup[setupIndex] += (((currentBlock - lastUpdateBlock) * _setups[setupIndex].rewardPerBlock) * 1e18) / _setups[setupIndex].totalSupply;
1844         }
1845         // update the last block update variable
1846         _setups[setupIndex].lastUpdateBlock = currentBlock;
1847         if (positionId != 0) {
1848             _rewardPerTokenPaid[positionId] = _rewardPerTokenPerSetup[setupIndex];
1849         }
1850         if (amount > 0) {
1851             fromExit ? _setups[setupIndex].totalSupply -= amount : _setups[setupIndex].totalSupply += amount;
1852         }
1853     }
1854 
1855     function _toggleSetup(uint256 setupIndex) private {
1856         FarmingSetup storage setup = _setups[setupIndex];
1857         // require(!setup.active || block.number >= setup.endBlock, "Not valid activation");
1858 
1859         require(block.number > _setupsInfo[setup.infoIndex].startBlock, "Too early for this setup");
1860 
1861         if (setup.active && block.number >= setup.endBlock && _setupsInfo[setup.infoIndex].renewTimes == 0) {
1862             setup.active = false;
1863             return;
1864         } else if (block.number >= setup.startBlock && block.number < setup.endBlock && setup.active) {
1865             setup.active = false;
1866             _setupsInfo[setup.infoIndex].renewTimes = 0;
1867             uint256 amount = (setup.endBlock - block.number) * setup.rewardPerBlock;
1868             setup.endBlock = block.number;
1869             _updateFreeSetup(setupIndex, 0, 0, false);
1870             _rewardReceived[setupIndex] -= amount;
1871             _giveBack(amount);
1872             return;
1873         }
1874 
1875         bool wasActive = setup.active;
1876         setup.active = _ensureTransfer(setup.rewardPerBlock * _setupsInfo[setup.infoIndex].blockDuration);
1877 
1878         if (setup.active && wasActive) {
1879             _rewardReceived[_farmingSetupsCount] = setup.rewardPerBlock * _setupsInfo[setup.infoIndex].blockDuration;
1880             // set new setup
1881             _setups[_farmingSetupsCount] = abi.decode(abi.encode(setup), (FarmingSetup));
1882             // update old setup
1883             _setups[setupIndex].active = false;
1884             // update new setup
1885             _setupsInfo[setup.infoIndex].renewTimes -= 1;
1886             _setupsInfo[setup.infoIndex].setupsCount += 1;
1887             _setupsInfo[setup.infoIndex].lastSetupIndex = _farmingSetupsCount;
1888             _setups[_farmingSetupsCount].startBlock = block.number;
1889             _setups[_farmingSetupsCount].endBlock = block.number + _setupsInfo[_setups[_farmingSetupsCount].infoIndex].blockDuration;
1890             _setups[_farmingSetupsCount].deprecatedObjectId = 0;
1891             _setups[_farmingSetupsCount].totalSupply = 0;
1892             _farmingSetupsCount += 1;
1893         } else if (setup.active && !wasActive) {
1894             _rewardReceived[setupIndex] = setup.rewardPerBlock * _setupsInfo[_setups[setupIndex].infoIndex].blockDuration;
1895             // update new setup
1896             _setups[setupIndex].startBlock = block.number;
1897             _setups[setupIndex].endBlock = block.number + _setupsInfo[_setups[setupIndex].infoIndex].blockDuration;
1898             _setups[setupIndex].totalSupply = 0;
1899             _setupsInfo[_setups[setupIndex].infoIndex].renewTimes -= 1;
1900         } else {
1901             _setupsInfo[_setups[setupIndex].infoIndex].renewTimes = 0;
1902         }
1903     }
1904 
1905     /** @dev function used to safely approve ERC20 transfers.
1906       * @param erc20TokenAddress address of the token to approve.
1907       * @param to receiver of the approval.
1908       * @param value amount to approve for.
1909      */
1910     function _safeApprove(address erc20TokenAddress, address to, uint256 value) internal virtual {
1911         if(value == 0) {
1912             return;
1913         }
1914         bytes memory returnData = _call(erc20TokenAddress, abi.encodeWithSelector(IERC20(erc20TokenAddress).approve.selector, to, value));
1915         require(returnData.length == 0 || abi.decode(returnData, (bool)), 'APPROVE_FAILED');
1916     }
1917 
1918     /** @dev function used to safe transfer ERC20 tokens.
1919       * @param erc20TokenAddress address of the token to transfer.
1920       * @param to receiver of the tokens.
1921       * @param value amount of tokens to transfer.
1922      */
1923     function _safeTransfer(address erc20TokenAddress, address to, uint256 value) internal virtual {
1924         if(value == 0) {
1925             return;
1926         }
1927         if(erc20TokenAddress == address(0)) {
1928             (bool result,) = to.call{value : value}("");
1929             require(result, "TRANSFER_FAILED");
1930             return;
1931         }
1932         bytes memory returnData = _call(erc20TokenAddress, abi.encodeWithSelector(IERC20(erc20TokenAddress).transfer.selector, to, value));
1933         require(returnData.length == 0 || abi.decode(returnData, (bool)), 'TRANSFER_FAILED');
1934     }
1935 
1936     /** @dev this function safely transfers the given ERC20 value from an address to another.
1937       * @param erc20TokenAddress erc20 token address.
1938       * @param from address from.
1939       * @param to address to.
1940       * @param value amount to transfer.
1941      */
1942     function _safeTransferFrom(address erc20TokenAddress, address from, address to, uint256 value) private {
1943         if(value == 0) {
1944             return;
1945         }
1946         bytes memory returnData = _call(erc20TokenAddress, abi.encodeWithSelector(IERC20(erc20TokenAddress).transferFrom.selector, from, to, value));
1947         require(returnData.length == 0 || abi.decode(returnData, (bool)), 'TRANSFERFROM_FAILED');
1948     }
1949 
1950     /** @dev calls the contract at the given location using the given payload and returns the returnData.
1951       * @param location location to call.
1952       * @param payload call payload.
1953       * @return returnData call return data.
1954      */
1955     function _call(address location, bytes memory payload) private returns(bytes memory returnData) {
1956         assembly {
1957             let result := call(gas(), location, 0, add(payload, 0x20), mload(payload), 0, 0)
1958             let size := returndatasize()
1959             returnData := mload(0x40)
1960             mstore(returnData, size)
1961             let returnDataPayloadStart := add(returnData, 0x20)
1962             returndatacopy(returnDataPayloadStart, 0, size)
1963             mstore(0x40, add(returnDataPayloadStart, size))
1964             switch result case 0 {revert(returnDataPayloadStart, size)}
1965         }
1966     }
1967 
1968     /** @dev gives back the reward to the extension.
1969       * @param amount to give back.
1970      */
1971     function _giveBack(uint256 amount) private {
1972         if(amount == 0) {
1973             return;
1974         }
1975         if (_rewardTokenAddress == address(0)) {
1976             IFarmExtensionRegular(host).backToYou{value : amount}(amount);
1977         } else {
1978             _safeApprove(_rewardTokenAddress, host, amount);
1979             IFarmExtensionRegular(host).backToYou(amount);
1980         }
1981     }
1982 
1983     /** @dev ensures the transfer from the contract to the extension.
1984       * @param amount amount to transfer.
1985      */
1986     function _ensureTransfer(uint256 amount) private returns(bool) {
1987         uint256 initialBalance = _rewardTokenAddress == address(0) ? address(this).balance : IERC20(_rewardTokenAddress).balanceOf(address(this));
1988         uint256 expectedBalance = initialBalance + amount;
1989         try IFarmExtensionRegular(host).transferTo(amount) {} catch {}
1990         uint256 actualBalance = _rewardTokenAddress == address(0) ? address(this).balance : IERC20(_rewardTokenAddress).balanceOf(address(this));
1991         if(actualBalance == expectedBalance) {
1992             return true;
1993         }
1994         _giveBack(actualBalance - initialBalance);
1995         return false;
1996     }
1997 
1998     /// @dev Common checks for valid tick inputs.
1999     function _checkTicks(int24 tickLower, int24 tickUpper) private pure {
2000         require(tickLower < tickUpper, 'TLU');
2001         require(tickLower >= TickMath.MIN_TICK, 'TLM');
2002         require(tickUpper <= TickMath.MAX_TICK, 'TUM');
2003     }
2004 
2005     // only called from gen2 code
2006     function _retrieveGen2LiquidityAndFees(uint256 positionId, uint256 tokenId, address recipient, uint128 liquidityToRemove, uint256 amount0Min, uint256 amount1Min, bytes memory burnData) private {
2007         uint256 decreasedAmount0 = 0;
2008         uint256 decreasedAmount1 = 0;
2009 
2010         if(liquidityToRemove > 0) {
2011             (decreasedAmount0, decreasedAmount1) = nonfungiblePositionManager.decreaseLiquidity(INonfungiblePositionManager.DecreaseLiquidityParams(
2012                 tokenId,
2013                 liquidityToRemove,
2014                 amount0Min,
2015                 amount1Min,
2016                 block.timestamp + 10000
2017             ));
2018         }
2019 
2020         address token0;
2021         address token1;
2022         uint256 collectedAmount0;
2023         uint256 collectedAmount1;
2024         (token0, token1, collectedAmount0, collectedAmount1) = _collect(positionId, tokenId);
2025         uint256 feeAmount0 = collectedAmount0 - decreasedAmount0;
2026         uint256 feeAmount1 = collectedAmount1 - decreasedAmount1;
2027         if(feeAmount0 > 0 || feeAmount1 > 0) {
2028             if(burnData.length == 0) {
2029                 feeAmount0 = feeAmount0 == 0 ? 0 : _payFee(token0, feeAmount0);
2030                 feeAmount1 = feeAmount1 == 0 ? 0 : _payFee(token1, feeAmount1);
2031             } else {
2032                 feeAmount0 = 0;
2033                 feeAmount1 = 0;
2034                 _burnFee(burnData);
2035             }
2036         }
2037         _safeTransfer(token0, recipient, collectedAmount0 - feeAmount0);
2038         _safeTransfer(token1, recipient, collectedAmount1 - feeAmount1);
2039     }
2040 
2041     function _payFee(address tokenAddress, uint256 feeAmount) private returns (uint256) {
2042         if(tokenAddress != address(0)) {
2043             _safeApprove(tokenAddress, IFarmFactory(initializer).initializer(), feeAmount);
2044         }
2045         return IFarmFactory(initializer).payFee{value : tokenAddress != address(0) ? 0 : feeAmount}(address(this), tokenAddress, feeAmount, "");
2046     }
2047 
2048     function _burnFee(bytes memory burnData) private returns (uint256) {
2049         (, burnData) = abi.decode(burnData, (bool, bytes));
2050         return IFarmFactory(initializer).burnOrTransferToken(msg.sender, burnData);
2051     }
2052 
2053     function _collect(uint256 positionId, uint256 tokenId) private returns (address token0, address token1, uint256 amount0, uint256 amount1) {
2054         bool involvingETH = _setupsInfo[_setups[_positions[positionId].setupIndex].infoIndex].involvingETH;
2055         bytes[] memory data = new bytes[](involvingETH ? 3 : 1);
2056         data[0] = abi.encodeWithSelector(nonfungiblePositionManager.collect.selector, INonfungiblePositionManager.CollectParams({
2057             tokenId: tokenId,
2058             recipient: involvingETH ? address(0) : address(this),
2059             amount0Max: 0xffffffffffffffffffffffffffffffff,
2060             amount1Max: 0xffffffffffffffffffffffffffffffff
2061         }));
2062         (,, token0, token1, , , , , , , , ) = nonfungiblePositionManager.positions(tokenId);
2063         if(involvingETH) {
2064             data[1] = abi.encodeWithSelector(nonfungiblePositionManager.unwrapWETH9.selector, 0, address(this));
2065             data[2] = abi.encodeWithSelector(nonfungiblePositionManager.sweepToken.selector, token0 == _WETH ? token1 : token0, 0, address(this));
2066             token0 = token0 == _WETH ? address(0) : token0;
2067             token1 = token1 == _WETH ? address(0) : token1;
2068         }
2069         (amount0, amount1) = abi.decode(IMulticall(address(nonfungiblePositionManager)).multicall(data)[0], (uint256, uint256));
2070     }
2071 }
2072 
2073 interface IFarmFactory {
2074     function initializer() external view returns (address);
2075     function payFee(address sender, address tokenAddress, uint256 value, bytes calldata permitSignature) external payable returns (uint256 feePaid);
2076     function burnOrTransferToken(address sender, bytes calldata permitSignature) external payable returns(uint256 amountTransferedOrBurnt);
2077 }