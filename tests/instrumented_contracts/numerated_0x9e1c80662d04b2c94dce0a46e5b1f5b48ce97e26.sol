1 // Sources flattened with hardhat v2.8.0 https://hardhat.org
2 
3 // File contracts/interfaces/IUniswapV3Factory.sol
4 
5 // SPDX-License-Identifier: GPL-2.0-or-later
6 pragma solidity ^0.8.0;
7 
8 /// @title The interface for the Uniswap V3 Factory
9 /// @notice The Uniswap V3 Factory facilitates creation of Uniswap V3 pools and control over the protocol fees
10 interface IUniswapV3Factory {
11     /// @notice Returns the pool address for a given pair of tokens and a fee, or address 0 if it does not exist
12     /// @dev tokenA and tokenB may be passed in either token0/token1 or token1/token0 order
13     /// @param tokenA The contract address of either token0 or token1
14     /// @param tokenB The contract address of the other token
15     /// @param fee The fee collected upon every swap in the pool, denominated in hundredths of a bip
16     /// @return pool The pool address
17     function getPool(
18         address tokenA,
19         address tokenB,
20         uint24 fee
21     ) external view returns (address pool);
22 
23     /// @notice Creates a pool for the given two tokens and fee
24     /// @param tokenA One of the two tokens in the desired pool
25     /// @param tokenB The other of the two tokens in the desired pool
26     /// @param fee The desired fee for the pool
27     /// @dev tokenA and tokenB may be passed in either order: token0/token1 or token1/token0. tickSpacing is retrieved
28     /// from the fee. The call will revert if the pool already exists, the fee is invalid, or the token arguments
29     /// are invalid.
30     /// @return pool The address of the newly created pool
31     function createPool(
32         address tokenA,
33         address tokenB,
34         uint24 fee
35     ) external returns (address pool);
36 }
37 
38 
39 // File contracts/interfaces/IUniswapV3Pool.sol
40 
41 interface IUniswapV3Pool {
42     /// @notice Sets the initial price for the pool
43     /// @dev Price is represented as a sqrt(amountToken1/amountToken0) Q64.96 value
44     /// @param sqrtPriceX96 the initial sqrt price of the pool as a Q64.96
45     function initialize(uint160 sqrtPriceX96) external;
46 
47     /// @notice The 0th storage slot in the pool stores many values, and is exposed as a single method to save gas
48     /// when accessed externally.
49     /// @return sqrtPriceX96 The current price of the pool as a sqrt(token1/token0) Q64.96 value
50     /// tick The current tick of the pool, i.e. according to the last tick transition that was run.
51     /// This value may not always be equal to SqrtTickMath.getTickAtSqrtRatio(sqrtPriceX96) if the price is on a tick
52     /// boundary.
53     /// observationIndex The index of the last oracle observation that was written,
54     /// observationCardinality The current maximum number of observations stored in the pool,
55     /// observationCardinalityNext The next maximum number of observations, to be updated when the observation.
56     /// feeProtocol The protocol fee for both tokens of the pool.
57     /// Encoded as two 4 bit values, where the protocol fee of token1 is shifted 4 bits and the protocol fee of token0
58     /// is the lower 4 bits. Used as the denominator of a fraction of the swap fee, e.g. 4 means 1/4th of the swap fee.
59     /// unlocked Whether the pool is currently locked to reentrancy
60     function slot0()
61         external
62         view
63         returns (
64             uint160 sqrtPriceX96,
65             int24 tick,
66             uint16 observationIndex,
67             uint16 observationCardinality,
68             uint16 observationCardinalityNext,
69             uint8 feeProtocol,
70             bool unlocked
71         );
72 
73     /// @notice Increase the maximum number of price and liquidity observations that this pool will store
74     /// @dev This method is no-op if the pool already has an observationCardinalityNext greater than or equal to
75     /// the input observationCardinalityNext.
76     /// @param observationCardinalityNext The desired minimum number of observations for the pool to store
77     function increaseObservationCardinalityNext(
78         uint16 observationCardinalityNext
79     ) external;
80 
81     /// @notice Returns the cumulative tick and liquidity as of each timestamp `secondsAgo` from the current block timestamp
82     /// @dev To get a time weighted average tick or liquidity-in-range, you must call this with two values, one representing
83     /// the beginning of the period and another for the end of the period. E.g., to get the last hour time-weighted average tick,
84     /// you must call it with secondsAgos = [3600, 0].
85     /// @dev The time weighted average tick represents the geometric time weighted average price of the pool, in
86     /// log base sqrt(1.0001) of token1 / token0. The TickMath library can be used to go from a tick value to a ratio.
87     /// @param secondsAgos From how long ago each cumulative tick and liquidity value should be returned
88     /// @return tickCumulatives Cumulative tick values as of each `secondsAgos` from the current block timestamp
89     /// @return secondsPerLiquidityCumulativeX128s Cumulative seconds per liquidity-in-range value as of each `secondsAgos` from the current block
90     /// timestamp
91     function observe(uint32[] calldata secondsAgos)
92         external
93         view
94         returns (
95             int56[] memory tickCumulatives,
96             uint160[] memory secondsPerLiquidityCumulativeX128s
97         );
98 }
99 
100 
101 // File contracts/interfaces/ISwapRouter.sol
102 
103 /// @title Router token swapping functionality
104 /// @notice Functions for swapping tokens via Uniswap V3
105 interface ISwapRouter {
106     struct ExactInputSingleParams {
107         address tokenIn;
108         address tokenOut;
109         uint24 fee;
110         address recipient;
111         uint256 deadline;
112         uint256 amountIn;
113         uint256 amountOutMinimum;
114         uint160 sqrtPriceLimitX96;
115     }
116 
117     /// @notice Swaps `amountIn` of one token for as much as possible of another token
118     /// @param params The parameters necessary for the swap, encoded as `ExactInputSingleParams` in calldata
119     /// @return amountOut The amount of the received token
120     function exactInputSingle(ExactInputSingleParams calldata params)
121         external
122         payable
123         returns (uint256 amountOut);
124 
125     struct ExactInputParams {
126         bytes path;
127         address recipient;
128         uint256 deadline;
129         uint256 amountIn;
130         uint256 amountOutMinimum;
131     }
132 }
133 
134 
135 // File contracts/interfaces/IERC20.sol
136 
137 interface IERC20 {
138     function totalSupply() external view returns (uint256);
139 
140     function balanceOf(address account) external view returns (uint256);
141 
142     function transfer(address recipient, uint256 amount)
143         external
144         returns (bool);
145 
146     function allowance(address owner, address spender)
147         external
148         view
149         returns (uint256);
150 
151     function approve(address spender, uint256 amount) external returns (bool);
152 
153     function transferFrom(
154         address sender,
155         address recipient,
156         uint256 amount
157     ) external returns (bool);
158 
159     event Transfer(address indexed from, address indexed to, uint256 value);
160     event Approval(
161         address indexed owner,
162         address indexed spender,
163         uint256 value
164     );
165 }
166 
167 
168 // File contracts/interfaces/IWETH.sol
169 
170 /// @title Interface for WETH
171 interface IWETH is IERC20 {
172     /// @notice Deposit ether to get wrapped ether
173     function deposit() external payable;
174 
175     /// @notice Withdraw wrapped ether to get ether
176     function withdraw(uint256) external;
177 }
178 
179 
180 // File contracts/interfaces/INonfungiblePositionManager.sol
181 
182 /// @title Non-fungible token for positions
183 /// @notice Wraps Uniswap V3 positions in a non-fungible token interface which allows for them to be transferred
184 /// and authorized.
185 interface INonfungiblePositionManager {
186     struct MintParams {
187         address token0;
188         address token1;
189         uint24 fee;
190         int24 tickLower;
191         int24 tickUpper;
192         uint256 amount0Desired;
193         uint256 amount1Desired;
194         uint256 amount0Min;
195         uint256 amount1Min;
196         address recipient;
197         uint256 deadline;
198     }
199 
200     /// @notice Creates a new position wrapped in a NFT
201     /// @dev Call this when the pool does exist and is initialized. Note that if the pool is created but not initialized
202     /// a method does not exist, i.e. the pool is assumed to be initialized.
203     /// @param params The params necessary to mint a position, encoded as `MintParams` in calldata
204     /// @return tokenId The ID of the token that represents the minted position
205     /// @return liquidity The amount of liquidity for this position
206     /// @return amount0 The amount of token0
207     /// @return amount1 The amount of token1
208     function mint(MintParams calldata params)
209         external
210         payable
211         returns (
212             uint256 tokenId,
213             uint128 liquidity,
214             uint256 amount0,
215             uint256 amount1
216         );
217 
218     struct DecreaseLiquidityParams {
219         uint256 tokenId;
220         uint128 liquidity;
221         uint256 amount0Min;
222         uint256 amount1Min;
223         uint256 deadline;
224     }
225 
226     /// @notice Decreases the amount of liquidity in a position and accounts it to the position
227     /// @param params tokenId The ID of the token for which liquidity is being decreased,
228     /// amount The amount by which liquidity will be decreased,
229     /// amount0Min The minimum amount of token0 that should be accounted for the burned liquidity,
230     /// amount1Min The minimum amount of token1 that should be accounted for the burned liquidity,
231     /// deadline The time by which the transaction must be included to effect the change
232     /// @return amount0 The amount of token0 accounted to the position's tokens owed
233     /// @return amount1 The amount of token1 accounted to the position's tokens owed
234     function decreaseLiquidity(DecreaseLiquidityParams calldata params)
235         external
236         payable
237         returns (uint256 amount0, uint256 amount1);
238 
239     struct CollectParams {
240         uint256 tokenId;
241         address recipient;
242         uint128 amount0Max;
243         uint128 amount1Max;
244     }
245 
246     /// @notice Collects up to a maximum amount of fees owed to a specific position to the recipient
247     /// @param params tokenId The ID of the NFT for which tokens are being collected,
248     /// recipient The account that should receive the tokens,
249     /// amount0Max The maximum amount of token0 to collect,
250     /// amount1Max The maximum amount of token1 to collect
251     /// @return amount0 The amount of fees collected in token0
252     /// @return amount1 The amount of fees collected in token1
253     function collect(CollectParams calldata params)
254         external
255         payable
256         returns (uint256 amount0, uint256 amount1);
257 
258     /// @notice Burns a token ID, which deletes it from the NFT contract. The token must have 0 liquidity and all tokens
259     /// must be collected first.
260     /// @param tokenId The ID of the token that is being burned
261     function burn(uint256 tokenId) external payable;
262 }
263 
264 
265 // File contracts/libraries/Lockable.sol
266 
267 /// @title Prevents re-entry attack
268 abstract contract Lockable {
269     bool private _locked;
270 
271     modifier lock() {
272         require(!_locked, "Locked");
273         _locked = true;
274         _;
275         _locked = false;
276     }
277 }
278 
279 
280 // File contracts/libraries/Ownable.sol
281 
282 /**
283  * @dev Contract module which provides a basic access control mechanism, where
284  * there is an account (an owner) that can be granted exclusive access to
285  * specific functions.
286  *
287  * By default, the owner account will be the one that deploys the contract. This
288  * can later be changed with {transferOwnership}.
289  *
290  * This module is used through inheritance. It will make available the modifier
291  * `onlyOwner`, which can be applied to your functions to restrict their use to
292  * the owner.
293  */
294 abstract contract Ownable {
295     address private _owner;
296 
297     event OwnershipTransferred(
298         address indexed previousOwner,
299         address indexed newOwner
300     );
301 
302     /**
303      * @dev Initializes the contract setting the deployer as the initial owner.
304      */
305     constructor() {
306         _transferOwnership(msg.sender);
307     }
308 
309     /**
310      * @dev Returns the address of the current owner.
311      */
312     function owner() public view virtual returns (address) {
313         return _owner;
314     }
315 
316     /**
317      * @dev Throws if called by any account other than the owner.
318      */
319     modifier onlyOwner() {
320         require(owner() == msg.sender, "Ownable: caller is not the owner");
321         _;
322     }
323 
324     /**
325      * @dev Leaves the contract without owner. It will not be possible to call
326      * `onlyOwner` functions anymore. Can only be called by the current owner.
327      *
328      * NOTE: Renouncing ownership will leave the contract without an owner,
329      * thereby removing any functionality that is only available to the owner.
330      */
331     function renounceOwnership() public virtual onlyOwner {
332         _transferOwnership(address(0));
333     }
334 
335     /**
336      * @dev Transfers ownership of the contract to a new account (`newOwner`).
337      * Can only be called by the current owner.
338      */
339     function transferOwnership(address newOwner) public virtual onlyOwner {
340         require(
341             newOwner != address(0),
342             "Ownable: new owner is the zero address"
343         );
344         _transferOwnership(newOwner);
345     }
346 
347     /**
348      * @dev Transfers ownership of the contract to a new account (`newOwner`).
349      * Internal function without access restriction.
350      */
351     function _transferOwnership(address newOwner) internal virtual {
352         address oldOwner = _owner;
353         _owner = newOwner;
354         emit OwnershipTransferred(oldOwner, newOwner);
355     }
356 }
357 
358 
359 // File contracts/libraries/SafeTransfer.sol
360 
361 // helper methods for interacting with ERC20 tokens and sending ETH that do not consistently return true/false
362 library TransferHelper {
363     function safeApprove(
364         address token,
365         address to,
366         uint256 value
367     ) internal {
368         // bytes4(keccak256(bytes('approve(address,uint256)')));
369         (bool success, bytes memory data) = token.call(
370             abi.encodeWithSelector(0x095ea7b3, to, value)
371         );
372         require(
373             success && (data.length == 0 || abi.decode(data, (bool))),
374             "safe approve failed"
375         );
376     }
377 
378     function safeTransfer(
379         address token,
380         address to,
381         uint256 value
382     ) internal {
383         // bytes4(keccak256(bytes('transfer(address,uint256)')));
384         (bool success, bytes memory data) = token.call(
385             abi.encodeWithSelector(0xa9059cbb, to, value)
386         );
387         require(
388             success && (data.length == 0 || abi.decode(data, (bool))),
389             "safe transfer failed"
390         );
391     }
392 
393     function safeTransferFrom(
394         address token,
395         address from,
396         address to,
397         uint256 value
398     ) internal {
399         // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
400         (bool success, bytes memory data) = token.call(
401             abi.encodeWithSelector(0x23b872dd, from, to, value)
402         );
403         require(
404             success && (data.length == 0 || abi.decode(data, (bool))),
405             "safe transferFrom failed"
406         );
407     }
408 
409     function safeTransferETH(address to, uint256 value) internal {
410         (bool success, ) = to.call{ value: value }(new bytes(0));
411         require(success, "safe transferETH failed");
412     }
413 }
414 
415 
416 // File contracts/libraries/TickMath.sol
417 
418 /// @title Math library for computing sqrt prices from ticks and vice versa
419 /// @notice Computes sqrt price for ticks of size 1.0001, i.e. sqrt(1.0001^tick) as fixed point Q64.96 numbers. Supports
420 /// prices between 2**-128 and 2**128
421 library TickMath {
422     /// @dev The minimum tick that may be passed to #getSqrtRatioAtTick computed from log base 1.0001 of 2**-128
423     int24 internal constant MIN_TICK = -887272;
424     /// @dev The maximum tick that may be passed to #getSqrtRatioAtTick computed from log base 1.0001 of 2**128
425     int24 internal constant MAX_TICK = -MIN_TICK;
426 
427     /// @dev The minimum value that can be returned from #getSqrtRatioAtTick. Equivalent to getSqrtRatioAtTick(MIN_TICK)
428     uint160 internal constant MIN_SQRT_RATIO = 4295128739;
429     /// @dev The maximum value that can be returned from #getSqrtRatioAtTick. Equivalent to getSqrtRatioAtTick(MAX_TICK)
430     uint160 internal constant MAX_SQRT_RATIO =
431         1461446703485210103287273052203988822378723970342;
432 
433     /// @notice Calculates sqrt(1.0001^tick) * 2^96
434     /// @dev Throws if |tick| > max tick
435     /// @param tick The input tick for the above formula
436     /// @return sqrtPriceX96 A Fixed point Q64.96 number representing the sqrt of the ratio of the two assets (token1/token0)
437     /// at the given tick
438     function getSqrtRatioAtTick(int24 tick)
439         internal
440         pure
441         returns (uint160 sqrtPriceX96)
442     {
443         uint256 absTick = tick < 0
444             ? uint256(-int256(tick))
445             : uint256(int256(tick));
446         require(absTick <= uint256(int256(MAX_TICK)), "T");
447 
448         uint256 ratio = absTick & 0x1 != 0
449             ? 0xfffcb933bd6fad37aa2d162d1a594001
450             : 0x100000000000000000000000000000000;
451         if (absTick & 0x2 != 0)
452             ratio = (ratio * 0xfff97272373d413259a46990580e213a) >> 128;
453         if (absTick & 0x4 != 0)
454             ratio = (ratio * 0xfff2e50f5f656932ef12357cf3c7fdcc) >> 128;
455         if (absTick & 0x8 != 0)
456             ratio = (ratio * 0xffe5caca7e10e4e61c3624eaa0941cd0) >> 128;
457         if (absTick & 0x10 != 0)
458             ratio = (ratio * 0xffcb9843d60f6159c9db58835c926644) >> 128;
459         if (absTick & 0x20 != 0)
460             ratio = (ratio * 0xff973b41fa98c081472e6896dfb254c0) >> 128;
461         if (absTick & 0x40 != 0)
462             ratio = (ratio * 0xff2ea16466c96a3843ec78b326b52861) >> 128;
463         if (absTick & 0x80 != 0)
464             ratio = (ratio * 0xfe5dee046a99a2a811c461f1969c3053) >> 128;
465         if (absTick & 0x100 != 0)
466             ratio = (ratio * 0xfcbe86c7900a88aedcffc83b479aa3a4) >> 128;
467         if (absTick & 0x200 != 0)
468             ratio = (ratio * 0xf987a7253ac413176f2b074cf7815e54) >> 128;
469         if (absTick & 0x400 != 0)
470             ratio = (ratio * 0xf3392b0822b70005940c7a398e4b70f3) >> 128;
471         if (absTick & 0x800 != 0)
472             ratio = (ratio * 0xe7159475a2c29b7443b29c7fa6e889d9) >> 128;
473         if (absTick & 0x1000 != 0)
474             ratio = (ratio * 0xd097f3bdfd2022b8845ad8f792aa5825) >> 128;
475         if (absTick & 0x2000 != 0)
476             ratio = (ratio * 0xa9f746462d870fdf8a65dc1f90e061e5) >> 128;
477         if (absTick & 0x4000 != 0)
478             ratio = (ratio * 0x70d869a156d2a1b890bb3df62baf32f7) >> 128;
479         if (absTick & 0x8000 != 0)
480             ratio = (ratio * 0x31be135f97d08fd981231505542fcfa6) >> 128;
481         if (absTick & 0x10000 != 0)
482             ratio = (ratio * 0x9aa508b5b7a84e1c677de54f3e99bc9) >> 128;
483         if (absTick & 0x20000 != 0)
484             ratio = (ratio * 0x5d6af8dedb81196699c329225ee604) >> 128;
485         if (absTick & 0x40000 != 0)
486             ratio = (ratio * 0x2216e584f5fa1ea926041bedfe98) >> 128;
487         if (absTick & 0x80000 != 0)
488             ratio = (ratio * 0x48a170391f7dc42444e8fa2) >> 128;
489 
490         if (tick > 0) ratio = type(uint256).max / ratio;
491 
492         // this divides by 1<<32 rounding up to go from a Q128.128 to a Q128.96.
493         // we then downcast because we know the result always fits within 160 bits due to our tick input constraint
494         // we round up in the division so getTickAtSqrtRatio of the output price is always consistent
495         sqrtPriceX96 = uint160(
496             (ratio >> 32) + (ratio % (1 << 32) == 0 ? 0 : 1)
497         );
498     }
499 
500     /// @notice Calculates the greatest tick value such that getRatioAtTick(tick) <= ratio
501     /// @dev Throws in case sqrtPriceX96 < MIN_SQRT_RATIO, as MIN_SQRT_RATIO is the lowest value getRatioAtTick may
502     /// ever return.
503     /// @param sqrtPriceX96 The sqrt ratio for which to compute the tick as a Q64.96
504     /// @return tick The greatest tick for which the ratio is less than or equal to the input ratio
505     function getTickAtSqrtRatio(uint160 sqrtPriceX96)
506         internal
507         pure
508         returns (int24 tick)
509     {
510         // second inequality must be < because the price can never reach the price at the max tick
511         require(
512             sqrtPriceX96 >= MIN_SQRT_RATIO && sqrtPriceX96 < MAX_SQRT_RATIO,
513             "R"
514         );
515         uint256 ratio = uint256(sqrtPriceX96) << 32;
516 
517         uint256 r = ratio;
518         uint256 msb = 0;
519 
520         assembly {
521             let f := shl(7, gt(r, 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF))
522             msb := or(msb, f)
523             r := shr(f, r)
524         }
525         assembly {
526             let f := shl(6, gt(r, 0xFFFFFFFFFFFFFFFF))
527             msb := or(msb, f)
528             r := shr(f, r)
529         }
530         assembly {
531             let f := shl(5, gt(r, 0xFFFFFFFF))
532             msb := or(msb, f)
533             r := shr(f, r)
534         }
535         assembly {
536             let f := shl(4, gt(r, 0xFFFF))
537             msb := or(msb, f)
538             r := shr(f, r)
539         }
540         assembly {
541             let f := shl(3, gt(r, 0xFF))
542             msb := or(msb, f)
543             r := shr(f, r)
544         }
545         assembly {
546             let f := shl(2, gt(r, 0xF))
547             msb := or(msb, f)
548             r := shr(f, r)
549         }
550         assembly {
551             let f := shl(1, gt(r, 0x3))
552             msb := or(msb, f)
553             r := shr(f, r)
554         }
555         assembly {
556             let f := gt(r, 0x1)
557             msb := or(msb, f)
558         }
559 
560         if (msb >= 128) r = ratio >> (msb - 127);
561         else r = ratio << (127 - msb);
562 
563         int256 log_2 = (int256(msb) - 128) << 64;
564 
565         assembly {
566             r := shr(127, mul(r, r))
567             let f := shr(128, r)
568             log_2 := or(log_2, shl(63, f))
569             r := shr(f, r)
570         }
571         assembly {
572             r := shr(127, mul(r, r))
573             let f := shr(128, r)
574             log_2 := or(log_2, shl(62, f))
575             r := shr(f, r)
576         }
577         assembly {
578             r := shr(127, mul(r, r))
579             let f := shr(128, r)
580             log_2 := or(log_2, shl(61, f))
581             r := shr(f, r)
582         }
583         assembly {
584             r := shr(127, mul(r, r))
585             let f := shr(128, r)
586             log_2 := or(log_2, shl(60, f))
587             r := shr(f, r)
588         }
589         assembly {
590             r := shr(127, mul(r, r))
591             let f := shr(128, r)
592             log_2 := or(log_2, shl(59, f))
593             r := shr(f, r)
594         }
595         assembly {
596             r := shr(127, mul(r, r))
597             let f := shr(128, r)
598             log_2 := or(log_2, shl(58, f))
599             r := shr(f, r)
600         }
601         assembly {
602             r := shr(127, mul(r, r))
603             let f := shr(128, r)
604             log_2 := or(log_2, shl(57, f))
605             r := shr(f, r)
606         }
607         assembly {
608             r := shr(127, mul(r, r))
609             let f := shr(128, r)
610             log_2 := or(log_2, shl(56, f))
611             r := shr(f, r)
612         }
613         assembly {
614             r := shr(127, mul(r, r))
615             let f := shr(128, r)
616             log_2 := or(log_2, shl(55, f))
617             r := shr(f, r)
618         }
619         assembly {
620             r := shr(127, mul(r, r))
621             let f := shr(128, r)
622             log_2 := or(log_2, shl(54, f))
623             r := shr(f, r)
624         }
625         assembly {
626             r := shr(127, mul(r, r))
627             let f := shr(128, r)
628             log_2 := or(log_2, shl(53, f))
629             r := shr(f, r)
630         }
631         assembly {
632             r := shr(127, mul(r, r))
633             let f := shr(128, r)
634             log_2 := or(log_2, shl(52, f))
635             r := shr(f, r)
636         }
637         assembly {
638             r := shr(127, mul(r, r))
639             let f := shr(128, r)
640             log_2 := or(log_2, shl(51, f))
641             r := shr(f, r)
642         }
643         assembly {
644             r := shr(127, mul(r, r))
645             let f := shr(128, r)
646             log_2 := or(log_2, shl(50, f))
647         }
648 
649         int256 log_sqrt10001 = log_2 * 255738958999603826347141; // 128.128 number
650 
651         int24 tickLow = int24(
652             (log_sqrt10001 - 3402992956809132418596140100660247210) >> 128
653         );
654         int24 tickHi = int24(
655             (log_sqrt10001 + 291339464771989622907027621153398088495) >> 128
656         );
657 
658         tick = tickLow == tickHi
659             ? tickLow
660             : getSqrtRatioAtTick(tickHi) <= sqrtPriceX96
661             ? tickHi
662             : tickLow;
663     }
664 }
665 
666 
667 // File contracts/libraries/Math.sol
668 
669 library Math {
670     function compound(uint256 rewardRateX96, uint256 nCompounds)
671         internal
672         pure
673         returns (uint256 compoundedX96)
674     {
675         if (nCompounds == 0) {
676             compoundedX96 = 2**96;
677         } else if (nCompounds == 1) {
678             compoundedX96 = rewardRateX96;
679         } else {
680             compoundedX96 = compound(rewardRateX96, nCompounds / 2);
681             compoundedX96 = mulX96(compoundedX96, compoundedX96);
682 
683             if (nCompounds % 2 == 1) {
684                 compoundedX96 = mulX96(compoundedX96, rewardRateX96);
685             }
686         }
687     }
688 
689     // ref: https://blogs.sas.com/content/iml/2016/05/16/babylonian-square-roots.html
690     function sqrt(uint256 x) internal pure returns (uint256 y) {
691         uint256 z = (x + 1) / 2;
692         y = x;
693         while (z < y) {
694             y = z;
695             z = (x / z + z) / 2;
696         }
697     }
698 
699     function mulX96(uint256 x, uint256 y) internal pure returns (uint256 z) {
700         z = (x * y) >> 96;
701     }
702 
703     function divX96(uint256 x, uint256 y) internal pure returns (uint256 z) {
704         z = (x << 96) / y;
705     }
706 
707     function max(uint256 a, uint256 b) internal pure returns (uint256) {
708         return a >= b ? a : b;
709     }
710 
711     function min(uint256 a, uint256 b) internal pure returns (uint256) {
712         return a < b ? a : b;
713     }
714 }
715 
716 
717 // File contracts/libraries/Time.sol
718 
719 library Time {
720     function current_hour_timestamp() internal view returns (uint64) {
721         return uint64((block.timestamp / 1 hours) * 1 hours);
722     }
723 
724     function block_timestamp() internal view returns (uint64) {
725         return uint64(block.timestamp);
726     }
727 }
728 
729 
730 // File contracts/Const.sol
731 
732 int24 constant INITIAL_QLT_PRICE_TICK = -23000; // QLT_USDC price ~ 100.0
733 
734 // initial values
735 uint24 constant UNISWAP_POOL_FEE = 10000;
736 int24 constant UNISWAP_POOL_TICK_SPACING = 200;
737 uint16 constant UNISWAP_POOL_OBSERVATION_CADINALITY = 64;
738 
739 // default values
740 uint256 constant DEFAULT_MIN_MINT_PRICE_X96 = 100 * Q96;
741 uint32 constant DEFAULT_TWAP_DURATION = 1 hours;
742 uint32 constant DEFAULT_UNSTAKE_LOCKUP_PERIOD = 3 days;
743 
744 // floating point math
745 uint256 constant Q96 = 2**96;
746 uint256 constant MX96 = Q96 / 10**6;
747 uint256 constant TX96 = Q96 / 10**12;
748 
749 // ERC-20 contract addresses
750 address constant WETH = address(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);
751 address constant USDC = address(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48);
752 address constant USDT = address(0xdAC17F958D2ee523a2206206994597C13D831ec7);
753 address constant DAI = address(0x6B175474E89094C44Da98b954EedeAC495271d0F);
754 address constant BUSD = address(0x4Fabb145d64652a948d72533023f6E7A623C7C53);
755 address constant FRAX = address(0x853d955aCEf822Db058eb8505911ED77F175b99e);
756 address constant WBTC = address(0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599);
757 
758 // Uniswap, see `https://docs.uniswap.org/protocol/reference/deployments`
759 address constant UNISWAP_FACTORY = address(
760     0x1F98431c8aD98523631AE4a59f267346ea31F984
761 );
762 address constant UNISWAP_ROUTER = address(
763     0xE592427A0AEce92De3Edee1F18E0157C05861564
764 );
765 address constant UNISWAP_NFP_MGR = address(
766     0xC36442b4a4522E871399CD717aBDD847Ab11FE88
767 );
768 
769 
770 // File contracts/libraries/ERC20.sol
771 
772 /**
773  * @dev Implementation of the {IERC20} interface.
774  *
775  * This implementation is agnostic to the way tokens are created. This means
776  * that a supply mechanism has to be added in a derived contract using {_mint}.
777  * For a generic mechanism see {ERC20PresetMinterPauser}.
778  *
779  * TIP: For a detailed writeup see our guide
780  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
781  * to implement supply mechanisms].
782  *
783  * We have followed general OpenZeppelin Contracts guidelines: functions revert
784  * instead returning `false` on failure. This behavior is nonetheless
785  * conventional and does not conflict with the expectations of ERC20
786  * applications.
787  *
788  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
789  * This allows applications to reconstruct the allowance for all accounts just
790  * by listening to said events. Other implementations of the EIP may not emit
791  * these events, as it isn't required by the specification.
792  *
793  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
794  * functions have been added to mitigate the well-known issues around setting
795  * allowances. See {IERC20-approve}.
796  */
797 contract ERC20 is IERC20 {
798     mapping(address => uint256) private _balances;
799 
800     mapping(address => mapping(address => uint256)) private _allowances;
801 
802     uint256 private _totalSupply;
803 
804     string private _name;
805     string private _symbol;
806     uint8 private _decimals;
807 
808     /**
809      * @dev Sets the values for {name} and {symbol}.
810      *
811      * The default value of {decimals} is 18. To select a different value for
812      * {decimals} you should overload it.
813      *
814      * All two of these values are immutable: they can only be set once during
815      * construction.
816      */
817     constructor(
818         string memory name_,
819         string memory symbol_,
820         uint8 decimals_
821     ) {
822         _name = name_;
823         _symbol = symbol_;
824         _decimals = decimals_;
825     }
826 
827     /**
828      * @dev Returns the name of the token.
829      */
830     function name() public view virtual returns (string memory) {
831         return _name;
832     }
833 
834     /**
835      * @dev Returns the symbol of the token, usually a shorter version of the
836      * name.
837      */
838     function symbol() public view virtual returns (string memory) {
839         return _symbol;
840     }
841 
842     /**
843      * @dev Returns the number of decimals used to get its user representation.
844      * For example, if `decimals` equals `2`, a balance of `505` tokens should
845      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
846      *
847      * Tokens usually opt for a value of 18, imitating the relationship between
848      * Ether and Wei. This is the value {ERC20} uses, unless this function is
849      * overridden;
850      *
851      * NOTE: This information is only used for _display_ purposes: it in
852      * no way affects any of the arithmetic of the contract, including
853      * {IERC20-balanceOf} and {IERC20-transfer}.
854      */
855     function decimals() public view virtual returns (uint8) {
856         return _decimals;
857     }
858 
859     /**
860      * @dev See {IERC20-totalSupply}.
861      */
862     function totalSupply() public view virtual override returns (uint256) {
863         return _totalSupply;
864     }
865 
866     /**
867      * @dev See {IERC20-balanceOf}.
868      */
869     function balanceOf(address account)
870         public
871         view
872         virtual
873         override
874         returns (uint256)
875     {
876         return _balances[account];
877     }
878 
879     /**
880      * @dev See {IERC20-transfer}.
881      *
882      * Requirements:
883      *
884      * - `recipient` cannot be the zero address.
885      * - the caller must have a balance of at least `amount`.
886      */
887     function transfer(address recipient, uint256 amount)
888         public
889         virtual
890         override
891         returns (bool)
892     {
893         _transfer(msg.sender, recipient, amount);
894         return true;
895     }
896 
897     /**
898      * @dev See {IERC20-allowance}.
899      */
900     function allowance(address owner, address spender)
901         public
902         view
903         virtual
904         override
905         returns (uint256)
906     {
907         return _allowances[owner][spender];
908     }
909 
910     /**
911      * @dev See {IERC20-approve}.
912      *
913      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
914      * `transferFrom`. This is semantically equivalent to an infinite approval.
915      *
916      * Requirements:
917      *
918      * - `spender` cannot be the zero address.
919      */
920     function approve(address spender, uint256 amount)
921         public
922         virtual
923         override
924         returns (bool)
925     {
926         _approve(msg.sender, spender, amount);
927         return true;
928     }
929 
930     /**
931      * @dev See {IERC20-transferFrom}.
932      *
933      * Emits an {Approval} event indicating the updated allowance. This is not
934      * required by the EIP. See the note at the beginning of {ERC20}.
935      *
936      * NOTE: Does not update the allowance if the current allowance
937      * is the maximum `uint256`.
938      *
939      * Requirements:
940      *
941      * - `sender` and `recipient` cannot be the zero address.
942      * - `sender` must have a balance of at least `amount`.
943      * - the caller must have allowance for ``sender``'s tokens of at least
944      * `amount`.
945      */
946     function transferFrom(
947         address sender,
948         address recipient,
949         uint256 amount
950     ) public virtual override returns (bool) {
951         uint256 currentAllowance = _allowances[sender][msg.sender];
952         if (currentAllowance != type(uint256).max) {
953             require(
954                 currentAllowance >= amount,
955                 "ERC20: transfer amount exceeds allowance"
956             );
957             unchecked {
958                 _approve(sender, msg.sender, currentAllowance - amount);
959             }
960         }
961 
962         _transfer(sender, recipient, amount);
963 
964         return true;
965     }
966 
967     /**
968      * @dev Atomically increases the allowance granted to `spender` by the caller.
969      *
970      * This is an alternative to {approve} that can be used as a mitigation for
971      * problems described in {IERC20-approve}.
972      *
973      * Emits an {Approval} event indicating the updated allowance.
974      *
975      * Requirements:
976      *
977      * - `spender` cannot be the zero address.
978      */
979     function increaseAllowance(address spender, uint256 addedValue)
980         public
981         virtual
982         returns (bool)
983     {
984         _approve(
985             msg.sender,
986             spender,
987             _allowances[msg.sender][spender] + addedValue
988         );
989         return true;
990     }
991 
992     /**
993      * @dev Atomically decreases the allowance granted to `spender` by the caller.
994      *
995      * This is an alternative to {approve} that can be used as a mitigation for
996      * problems described in {IERC20-approve}.
997      *
998      * Emits an {Approval} event indicating the updated allowance.
999      *
1000      * Requirements:
1001      *
1002      * - `spender` cannot be the zero address.
1003      * - `spender` must have allowance for the caller of at least
1004      * `subtractedValue`.
1005      */
1006     function decreaseAllowance(address spender, uint256 subtractedValue)
1007         public
1008         virtual
1009         returns (bool)
1010     {
1011         uint256 currentAllowance = _allowances[msg.sender][spender];
1012         require(
1013             currentAllowance >= subtractedValue,
1014             "ERC20: decreased allowance below zero"
1015         );
1016         unchecked {
1017             _approve(msg.sender, spender, currentAllowance - subtractedValue);
1018         }
1019 
1020         return true;
1021     }
1022 
1023     /**
1024      * @dev Moves `amount` of tokens from `sender` to `recipient`.
1025      *
1026      * This internal function is equivalent to {transfer}, and can be used to
1027      * e.g. implement automatic token fees, slashing mechanisms, etc.
1028      *
1029      * Emits a {Transfer} event.
1030      *
1031      * Requirements:
1032      *
1033      * - `sender` cannot be the zero address.
1034      * - `recipient` cannot be the zero address.
1035      * - `sender` must have a balance of at least `amount`.
1036      */
1037     function _transfer(
1038         address sender,
1039         address recipient,
1040         uint256 amount
1041     ) internal virtual {
1042         require(sender != address(0), "ERC20: transfer from the zero address");
1043         require(recipient != address(0), "ERC20: transfer to the zero address");
1044 
1045         _beforeTokenTransfer(sender, recipient, amount);
1046 
1047         uint256 senderBalance = _balances[sender];
1048         require(
1049             senderBalance >= amount,
1050             "ERC20: transfer amount exceeds balance"
1051         );
1052         unchecked {
1053             _balances[sender] = senderBalance - amount;
1054         }
1055         _balances[recipient] += amount;
1056 
1057         emit Transfer(sender, recipient, amount);
1058 
1059         _afterTokenTransfer(sender, recipient, amount);
1060     }
1061 
1062     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1063      * the total supply.
1064      *
1065      * Emits a {Transfer} event with `from` set to the zero address.
1066      *
1067      * Requirements:
1068      *
1069      * - `account` cannot be the zero address.
1070      */
1071     function _mint(address account, uint256 amount) internal virtual {
1072         require(account != address(0), "ERC20: mint to the zero address");
1073 
1074         _beforeTokenTransfer(address(0), account, amount);
1075 
1076         _totalSupply += amount;
1077         _balances[account] += amount;
1078         emit Transfer(address(0), account, amount);
1079 
1080         _afterTokenTransfer(address(0), account, amount);
1081     }
1082 
1083     /**
1084      * @dev Destroys `amount` tokens from `account`, reducing the
1085      * total supply.
1086      *
1087      * Emits a {Transfer} event with `to` set to the zero address.
1088      *
1089      * Requirements:
1090      *
1091      * - `account` cannot be the zero address.
1092      * - `account` must have at least `amount` tokens.
1093      */
1094     function _burn(address account, uint256 amount) internal virtual {
1095         require(account != address(0), "ERC20: burn from the zero address");
1096 
1097         _beforeTokenTransfer(account, address(0), amount);
1098 
1099         uint256 accountBalance = _balances[account];
1100         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
1101         unchecked {
1102             _balances[account] = accountBalance - amount;
1103         }
1104         _totalSupply -= amount;
1105 
1106         emit Transfer(account, address(0), amount);
1107 
1108         _afterTokenTransfer(account, address(0), amount);
1109     }
1110 
1111     /**
1112      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
1113      *
1114      * This internal function is equivalent to `approve`, and can be used to
1115      * e.g. set automatic allowances for certain subsystems, etc.
1116      *
1117      * Emits an {Approval} event.
1118      *
1119      * Requirements:
1120      *
1121      * - `owner` cannot be the zero address.
1122      * - `spender` cannot be the zero address.
1123      */
1124     function _approve(
1125         address owner,
1126         address spender,
1127         uint256 amount
1128     ) internal virtual {
1129         require(owner != address(0), "ERC20: approve from the zero address");
1130         require(spender != address(0), "ERC20: approve to the zero address");
1131 
1132         _allowances[owner][spender] = amount;
1133         emit Approval(owner, spender, amount);
1134     }
1135 
1136     /**
1137      * @dev Hook that is called before any transfer of tokens. This includes
1138      * minting and burning.
1139      *
1140      * Calling conditions:
1141      *
1142      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1143      * will be transferred to `to`.
1144      * - when `from` is zero, `amount` tokens will be minted for `to`.
1145      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1146      * - `from` and `to` are never both zero.
1147      *
1148      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1149      */
1150     function _beforeTokenTransfer(
1151         address from,
1152         address to,
1153         uint256 amount
1154     ) internal virtual {}
1155 
1156     /**
1157      * @dev Hook that is called after any transfer of tokens. This includes
1158      * minting and burning.
1159      *
1160      * Calling conditions:
1161      *
1162      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1163      * has been transferred to `to`.
1164      * - when `from` is zero, `amount` tokens have been minted for `to`.
1165      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
1166      * - `from` and `to` are never both zero.
1167      *
1168      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1169      */
1170     function _afterTokenTransfer(
1171         address from,
1172         address to,
1173         uint256 amount
1174     ) internal virtual {}
1175 }
1176 
1177 
1178 // File contracts/QLT.sol
1179 
1180 contract QLT is ERC20, Ownable {
1181     event Mint(address indexed account, uint256 amount);
1182     event Burn(uint256 amount);
1183 
1184     mapping(address => bool) public authorizedMinters;
1185 
1186     constructor() ERC20("Quantland", "QLT", 9) {
1187         require(
1188             address(this) < USDC,
1189             "QLT contract address must be smaller than USDC token contract address"
1190         );
1191         authorizedMinters[msg.sender] = true;
1192 
1193         // deploy uniswap pool
1194         IUniswapV3Pool pool = IUniswapV3Pool(
1195             IUniswapV3Factory(UNISWAP_FACTORY).createPool(
1196                 address(this),
1197                 USDC,
1198                 UNISWAP_POOL_FEE
1199             )
1200         );
1201         pool.initialize(TickMath.getSqrtRatioAtTick(INITIAL_QLT_PRICE_TICK));
1202         pool.increaseObservationCardinalityNext(
1203             UNISWAP_POOL_OBSERVATION_CADINALITY
1204         );
1205     }
1206 
1207     function mint(address account, uint256 amount)
1208         external
1209         onlyAuthorizedMinter
1210     {
1211         _mint(account, amount);
1212 
1213         emit Mint(account, amount);
1214     }
1215 
1216     function burn(uint256 amount) external onlyOwner {
1217         _burn(msg.sender, amount);
1218 
1219         emit Burn(amount);
1220     }
1221 
1222     /* Access Control */
1223     modifier onlyAuthorizedMinter() {
1224         require(authorizedMinters[msg.sender], "not authorized minter");
1225         _;
1226     }
1227 
1228     function addAuthorizedMinter(address account) external onlyOwner {
1229         authorizedMinters[account] = true;
1230     }
1231 
1232     function removeAuthorizedMinter(address account) external onlyOwner {
1233         authorizedMinters[account] = false;
1234     }
1235 }
1236 
1237 
1238 // File contracts/interfaces/IERC721.sol
1239 
1240 /**
1241  * @dev Required interface of an ERC721 compliant contract.
1242  */
1243 interface IERC721 {
1244     /**
1245      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1246      */
1247     event Transfer(
1248         address indexed from,
1249         address indexed to,
1250         uint256 indexed tokenId
1251     );
1252 
1253     /**
1254      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1255      */
1256     event Approval(
1257         address indexed owner,
1258         address indexed approved,
1259         uint256 indexed tokenId
1260     );
1261 
1262     /**
1263      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1264      */
1265     event ApprovalForAll(
1266         address indexed owner,
1267         address indexed operator,
1268         bool approved
1269     );
1270 
1271     /**
1272      * @dev Returns the token collection name.
1273      */
1274     function name() external view returns (string memory);
1275 
1276     /**
1277      * @dev Returns the token collection symbol.
1278      */
1279     function symbol() external view returns (string memory);
1280 
1281     /**
1282      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1283      */
1284     function tokenURI(uint256 tokenId) external view returns (string memory);
1285 
1286     /**
1287      * @dev Returns the number of tokens in ``owner``'s account.
1288      */
1289     function balanceOf(address owner) external view returns (uint256 balance);
1290 
1291     /**
1292      * @dev Returns the owner of the `tokenId` token.
1293      *
1294      * Requirements:
1295      *
1296      * - `tokenId` must exist.
1297      */
1298     function ownerOf(uint256 tokenId) external view returns (address owner);
1299 
1300     /**
1301      * @dev Transfers `tokenId` token from `from` to `to`.
1302      *
1303      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1304      *
1305      * Requirements:
1306      *
1307      * - `from` cannot be the zero address.
1308      * - `to` cannot be the zero address.
1309      * - `tokenId` token must be owned by `from`.
1310      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1311      *
1312      * Emits a {Transfer} event.
1313      */
1314     function transferFrom(
1315         address from,
1316         address to,
1317         uint256 tokenId
1318     ) external;
1319 
1320     /**
1321      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1322      * The approval is cleared when the token is transferred.
1323      *
1324      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1325      *
1326      * Requirements:
1327      *
1328      * - The caller must own the token or be an approved operator.
1329      * - `tokenId` must exist.
1330      *
1331      * Emits an {Approval} event.
1332      */
1333     function approve(address to, uint256 tokenId) external;
1334 
1335     /**
1336      * @dev Returns the account approved for `tokenId` token.
1337      *
1338      * Requirements:
1339      *
1340      * - `tokenId` must exist.
1341      */
1342     function getApproved(uint256 tokenId)
1343         external
1344         view
1345         returns (address operator);
1346 
1347     /**
1348      * @dev Approve or remove `operator` as an operator for the caller.
1349      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1350      *
1351      * Requirements:
1352      *
1353      * - The `operator` cannot be the caller.
1354      *
1355      * Emits an {ApprovalForAll} event.
1356      */
1357     function setApprovalForAll(address operator, bool _approved) external;
1358 
1359     /**
1360      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1361      *
1362      * See {setApprovalForAll}
1363      */
1364     function isApprovedForAll(address owner, address operator)
1365         external
1366         view
1367         returns (bool);
1368 }
1369 
1370 
1371 // File contracts/libraries/Strings.sol
1372 
1373 /**
1374  * @dev String operations.
1375  */
1376 library Strings {
1377     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
1378 
1379     /**
1380      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1381      */
1382     function toString(uint256 value) internal pure returns (string memory) {
1383         // Inspired by OraclizeAPI's implementation - MIT licence
1384         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1385 
1386         if (value == 0) {
1387             return "0";
1388         }
1389         uint256 temp = value;
1390         uint256 digits;
1391         while (temp != 0) {
1392             digits++;
1393             temp /= 10;
1394         }
1395         bytes memory buffer = new bytes(digits);
1396         while (value != 0) {
1397             digits -= 1;
1398             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1399             value /= 10;
1400         }
1401         return string(buffer);
1402     }
1403 
1404     /**
1405      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1406      */
1407     function toHexString(uint256 value) internal pure returns (string memory) {
1408         if (value == 0) {
1409             return "0x00";
1410         }
1411         uint256 temp = value;
1412         uint256 length = 0;
1413         while (temp != 0) {
1414             length++;
1415             temp >>= 8;
1416         }
1417         return toHexString(value, length);
1418     }
1419 
1420     /**
1421      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1422      */
1423     function toHexString(uint256 value, uint256 length)
1424         internal
1425         pure
1426         returns (string memory)
1427     {
1428         bytes memory buffer = new bytes(2 * length + 2);
1429         buffer[0] = "0";
1430         buffer[1] = "x";
1431         for (uint256 i = 2 * length + 1; i > 1; --i) {
1432             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1433             value >>= 4;
1434         }
1435         require(value == 0, "Strings: hex length insufficient");
1436         return string(buffer);
1437     }
1438 }
1439 
1440 
1441 // File contracts/libraries/ERC721.sol
1442 
1443 /**
1444  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1445  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1446  * {ERC721Enumerable}.
1447  */
1448 contract ERC721 is IERC721 {
1449     using Strings for uint256;
1450 
1451     // Token name
1452     string private _name;
1453 
1454     // Token symbol
1455     string private _symbol;
1456 
1457     // Base URI
1458     string private _baseURI;
1459 
1460     // Mapping from token ID to owner address
1461     mapping(uint256 => address) private _owners;
1462 
1463     // Mapping owner address to token count
1464     mapping(address => uint256) private _balances;
1465 
1466     // Mapping from token ID to approved address
1467     mapping(uint256 => address) private _tokenApprovals;
1468 
1469     // Mapping from owner to operator approvals
1470     mapping(address => mapping(address => bool)) private _operatorApprovals;
1471 
1472     /**
1473      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1474      */
1475     constructor(
1476         string memory name_,
1477         string memory symbol_,
1478         string memory baseURI_
1479     ) {
1480         _name = name_;
1481         _symbol = symbol_;
1482         _baseURI = baseURI_;
1483     }
1484 
1485     /**
1486      * @dev See {IERC721-balanceOf}.
1487      */
1488     function balanceOf(address owner)
1489         public
1490         view
1491         virtual
1492         override
1493         returns (uint256)
1494     {
1495         require(
1496             owner != address(0),
1497             "ERC721: balance query for the zero address"
1498         );
1499         return _balances[owner];
1500     }
1501 
1502     /**
1503      * @dev See {IERC721-ownerOf}.
1504      */
1505     function ownerOf(uint256 tokenId)
1506         public
1507         view
1508         virtual
1509         override
1510         returns (address)
1511     {
1512         address owner = _owners[tokenId];
1513         require(
1514             owner != address(0),
1515             "ERC721: owner query for nonexistent token"
1516         );
1517         return owner;
1518     }
1519 
1520     /**
1521      * @dev See {IERC721Metadata-name}.
1522      */
1523     function name() public view virtual override returns (string memory) {
1524         return _name;
1525     }
1526 
1527     /**
1528      * @dev See {IERC721Metadata-symbol}.
1529      */
1530     function symbol() public view virtual override returns (string memory) {
1531         return _symbol;
1532     }
1533 
1534     /**
1535      * @dev See {IERC721Metadata-tokenURI}.
1536      */
1537     function tokenURI(uint256 tokenId)
1538         public
1539         view
1540         virtual
1541         override
1542         returns (string memory)
1543     {
1544         require(
1545             _exists(tokenId),
1546             "ERC721Metadata: URI query for nonexistent token"
1547         );
1548 
1549         string memory baseURI = _baseURI;
1550         return
1551             bytes(baseURI).length > 0
1552                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
1553                 : "";
1554     }
1555 
1556     /**
1557      * @dev See {IERC721-approve}.
1558      */
1559     function approve(address to, uint256 tokenId) public virtual override {
1560         address owner = ERC721.ownerOf(tokenId);
1561         require(to != owner, "ERC721: approval to current owner");
1562 
1563         require(
1564             msg.sender == owner || isApprovedForAll(owner, msg.sender),
1565             "ERC721: approve caller is not owner nor approved for all"
1566         );
1567 
1568         _approve(to, tokenId);
1569     }
1570 
1571     /**
1572      * @dev See {IERC721-getApproved}.
1573      */
1574     function getApproved(uint256 tokenId)
1575         public
1576         view
1577         virtual
1578         override
1579         returns (address)
1580     {
1581         require(
1582             _exists(tokenId),
1583             "ERC721: approved query for nonexistent token"
1584         );
1585 
1586         return _tokenApprovals[tokenId];
1587     }
1588 
1589     /**
1590      * @dev See {IERC721-setApprovalForAll}.
1591      */
1592     function setApprovalForAll(address operator, bool approved)
1593         public
1594         virtual
1595         override
1596     {
1597         _setApprovalForAll(msg.sender, operator, approved);
1598     }
1599 
1600     /**
1601      * @dev See {IERC721-isApprovedForAll}.
1602      */
1603     function isApprovedForAll(address owner, address operator)
1604         public
1605         view
1606         virtual
1607         override
1608         returns (bool)
1609     {
1610         return _operatorApprovals[owner][operator];
1611     }
1612 
1613     /**
1614      * @dev See {IERC721-transferFrom}.
1615      */
1616     function transferFrom(
1617         address from,
1618         address to,
1619         uint256 tokenId
1620     ) public virtual override {
1621         //solhint-disable-next-line max-line-length
1622         require(
1623             _isApprovedOrOwner(msg.sender, tokenId),
1624             "ERC721: transfer caller is not owner nor approved"
1625         );
1626 
1627         _transfer(from, to, tokenId);
1628     }
1629 
1630     /**
1631      * @dev Returns whether `tokenId` exists.
1632      *
1633      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1634      *
1635      * Tokens start existing when they are minted (`_mint`),
1636      * and stop existing when they are burned (`_burn`).
1637      */
1638     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1639         return _owners[tokenId] != address(0);
1640     }
1641 
1642     /**
1643      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1644      *
1645      * Requirements:
1646      *
1647      * - `tokenId` must exist.
1648      */
1649     function _isApprovedOrOwner(address spender, uint256 tokenId)
1650         internal
1651         view
1652         virtual
1653         returns (bool)
1654     {
1655         require(
1656             _exists(tokenId),
1657             "ERC721: operator query for nonexistent token"
1658         );
1659         address owner = ERC721.ownerOf(tokenId);
1660         return (spender == owner ||
1661             getApproved(tokenId) == spender ||
1662             isApprovedForAll(owner, spender));
1663     }
1664 
1665     /**
1666      * @dev Mints `tokenId` and transfers it to `to`.
1667      *
1668      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1669      *
1670      * Requirements:
1671      *
1672      * - `tokenId` must not exist.
1673      * - `to` cannot be the zero address.
1674      *
1675      * Emits a {Transfer} event.
1676      */
1677     function _mint(address to, uint256 tokenId) internal virtual {
1678         require(to != address(0), "ERC721: mint to the zero address");
1679         require(!_exists(tokenId), "ERC721: token already minted");
1680 
1681         _beforeTokenTransfer(address(0), to, tokenId);
1682 
1683         _balances[to] += 1;
1684         _owners[tokenId] = to;
1685 
1686         emit Transfer(address(0), to, tokenId);
1687     }
1688 
1689     /**
1690      * @dev Destroys `tokenId`.
1691      * The approval is cleared when the token is burned.
1692      *
1693      * Requirements:
1694      *
1695      * - `tokenId` must exist.
1696      *
1697      * Emits a {Transfer} event.
1698      */
1699     function _burn(uint256 tokenId) internal virtual {
1700         address owner = ERC721.ownerOf(tokenId);
1701 
1702         _beforeTokenTransfer(owner, address(0), tokenId);
1703 
1704         // Clear approvals
1705         _approve(address(0), tokenId);
1706 
1707         _balances[owner] -= 1;
1708         delete _owners[tokenId];
1709 
1710         emit Transfer(owner, address(0), tokenId);
1711     }
1712 
1713     /**
1714      * @dev Transfers `tokenId` from `from` to `to`.
1715      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1716      *
1717      * Requirements:
1718      *
1719      * - `to` cannot be the zero address.
1720      * - `tokenId` token must be owned by `from`.
1721      *
1722      * Emits a {Transfer} event.
1723      */
1724     function _transfer(
1725         address from,
1726         address to,
1727         uint256 tokenId
1728     ) internal virtual {
1729         require(
1730             ERC721.ownerOf(tokenId) == from,
1731             "ERC721: transfer from incorrect owner"
1732         );
1733         require(to != address(0), "ERC721: transfer to the zero address");
1734 
1735         _beforeTokenTransfer(from, to, tokenId);
1736 
1737         // Clear approvals from the previous owner
1738         _approve(address(0), tokenId);
1739 
1740         _balances[from] -= 1;
1741         _balances[to] += 1;
1742         _owners[tokenId] = to;
1743 
1744         emit Transfer(from, to, tokenId);
1745     }
1746 
1747     /**
1748      * @dev Approve `to` to operate on `tokenId`
1749      *
1750      * Emits a {Approval} event.
1751      */
1752     function _approve(address to, uint256 tokenId) internal virtual {
1753         _tokenApprovals[tokenId] = to;
1754         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1755     }
1756 
1757     /**
1758      * @dev Approve `operator` to operate on all of `owner` tokens
1759      *
1760      * Emits a {ApprovalForAll} event.
1761      */
1762     function _setApprovalForAll(
1763         address owner,
1764         address operator,
1765         bool approved
1766     ) internal virtual {
1767         require(owner != operator, "ERC721: approve to caller");
1768         _operatorApprovals[owner][operator] = approved;
1769         emit ApprovalForAll(owner, operator, approved);
1770     }
1771 
1772     /**
1773      * @dev Hook that is called before any token transfer. This includes minting
1774      * and burning.
1775      *
1776      * Calling conditions:
1777      *
1778      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1779      * transferred to `to`.
1780      * - When `from` is zero, `tokenId` will be minted for `to`.
1781      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1782      * - `from` and `to` are never both zero.
1783      *
1784      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1785      */
1786     function _beforeTokenTransfer(
1787         address from,
1788         address to,
1789         uint256 tokenId
1790     ) internal virtual {}
1791 }
1792 
1793 
1794 // File contracts/interfaces/IERC721Enumerable.sol
1795 
1796 /**
1797  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1798  * @dev See https://eips.ethereum.org/EIPS/eip-721
1799  */
1800 interface IERC721Enumerable is IERC721 {
1801     /**
1802      * @dev Returns the total amount of tokens stored by the contract.
1803      */
1804     function totalSupply() external view returns (uint256);
1805 
1806     /**
1807      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1808      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1809      */
1810     function tokenOfOwnerByIndex(address owner, uint256 index)
1811         external
1812         view
1813         returns (uint256 tokenId);
1814 
1815     /**
1816      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1817      * Use along with {totalSupply} to enumerate all tokens.
1818      */
1819     function tokenByIndex(uint256 index) external view returns (uint256);
1820 }
1821 
1822 
1823 // File contracts/libraries/ERC721Enumerable.sol
1824 
1825 /**
1826  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1827  * enumerability of all the token ids in the contract as well as all token ids owned by each
1828  * account.
1829  */
1830 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1831     // Mapping from owner to list of owned token IDs
1832     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1833 
1834     // Mapping from token ID to index of the owner tokens list
1835     mapping(uint256 => uint256) private _ownedTokensIndex;
1836 
1837     // Array with all token ids, used for enumeration
1838     uint256[] private _allTokens;
1839 
1840     // Mapping from token id to position in the allTokens array
1841     mapping(uint256 => uint256) private _allTokensIndex;
1842 
1843     /**
1844      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1845      */
1846     function tokenOfOwnerByIndex(address owner, uint256 index)
1847         public
1848         view
1849         virtual
1850         override
1851         returns (uint256)
1852     {
1853         require(
1854             index < ERC721.balanceOf(owner),
1855             "ERC721Enumerable: owner index out of bounds"
1856         );
1857         return _ownedTokens[owner][index];
1858     }
1859 
1860     /**
1861      * @dev See {IERC721Enumerable-totalSupply}.
1862      */
1863     function totalSupply() public view virtual override returns (uint256) {
1864         return _allTokens.length;
1865     }
1866 
1867     /**
1868      * @dev See {IERC721Enumerable-tokenByIndex}.
1869      */
1870     function tokenByIndex(uint256 index)
1871         public
1872         view
1873         virtual
1874         override
1875         returns (uint256)
1876     {
1877         require(
1878             index < ERC721Enumerable.totalSupply(),
1879             "ERC721Enumerable: global index out of bounds"
1880         );
1881         return _allTokens[index];
1882     }
1883 
1884     /**
1885      * @dev Hook that is called before any token transfer. This includes minting
1886      * and burning.
1887      *
1888      * Calling conditions:
1889      *
1890      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1891      * transferred to `to`.
1892      * - When `from` is zero, `tokenId` will be minted for `to`.
1893      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1894      * - `from` cannot be the zero address.
1895      * - `to` cannot be the zero address.
1896      *
1897      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1898      */
1899     function _beforeTokenTransfer(
1900         address from,
1901         address to,
1902         uint256 tokenId
1903     ) internal virtual override {
1904         super._beforeTokenTransfer(from, to, tokenId);
1905 
1906         if (from == address(0)) {
1907             _addTokenToAllTokensEnumeration(tokenId);
1908         } else if (from != to) {
1909             _removeTokenFromOwnerEnumeration(from, tokenId);
1910         }
1911         if (to == address(0)) {
1912             _removeTokenFromAllTokensEnumeration(tokenId);
1913         } else if (to != from) {
1914             _addTokenToOwnerEnumeration(to, tokenId);
1915         }
1916     }
1917 
1918     /**
1919      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1920      * @param to address representing the new owner of the given token ID
1921      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1922      */
1923     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1924         uint256 length = ERC721.balanceOf(to);
1925         _ownedTokens[to][length] = tokenId;
1926         _ownedTokensIndex[tokenId] = length;
1927     }
1928 
1929     /**
1930      * @dev Private function to add a token to this extension's token tracking data structures.
1931      * @param tokenId uint256 ID of the token to be added to the tokens list
1932      */
1933     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1934         _allTokensIndex[tokenId] = _allTokens.length;
1935         _allTokens.push(tokenId);
1936     }
1937 
1938     /**
1939      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1940      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1941      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1942      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1943      * @param from address representing the previous owner of the given token ID
1944      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1945      */
1946     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId)
1947         private
1948     {
1949         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1950         // then delete the last slot (swap and pop).
1951 
1952         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1953         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1954 
1955         // When the token to delete is the last token, the swap operation is unnecessary
1956         if (tokenIndex != lastTokenIndex) {
1957             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1958 
1959             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1960             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1961         }
1962 
1963         // This also deletes the contents at the last position of the array
1964         delete _ownedTokensIndex[tokenId];
1965         delete _ownedTokens[from][lastTokenIndex];
1966     }
1967 
1968     /**
1969      * @dev Private function to remove a token from this extension's token tracking data structures.
1970      * This has O(1) time complexity, but alters the order of the _allTokens array.
1971      * @param tokenId uint256 ID of the token to be removed from the tokens list
1972      */
1973     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1974         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1975         // then delete the last slot (swap and pop).
1976 
1977         uint256 lastTokenIndex = _allTokens.length - 1;
1978         uint256 tokenIndex = _allTokensIndex[tokenId];
1979 
1980         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1981         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1982         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1983         uint256 lastTokenId = _allTokens[lastTokenIndex];
1984 
1985         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1986         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1987 
1988         // This also deletes the contents at the last position of the array
1989         delete _allTokensIndex[tokenId];
1990         _allTokens.pop();
1991     }
1992 }
1993 
1994 
1995 // File contracts/StakedQLT.sol
1996 
1997 struct StakingInfo {
1998     bytes32 stakingPlan;
1999     uint256 stakedAmount;
2000     uint64 stakeTime;
2001     uint64 unstakeTime;
2002     uint64 redeemTime;
2003     uint64 lastHarvestTime;
2004     uint256 accumulatedStakingReward;
2005 }
2006 
2007 struct StakingRewardRate {
2008     uint256 rewardRateX96;
2009     uint64 startTime;
2010 }
2011 
2012 struct StakingPowerMultiplier {
2013     uint64 multiplier;
2014     uint64 startTime;
2015 }
2016 
2017 struct StakingPlan {
2018     bytes32 name;
2019     uint256 stakingAmount;
2020     uint256 accumulatedStakingReward;
2021     StakingRewardRate[] rewardRates;
2022     StakingPowerMultiplier[] multipliers;
2023     uint64 lockupPeriod;
2024     uint64 createdAt;
2025     uint64 deactivatedAt;
2026 }
2027 
2028 contract StakedQLT is ERC721Enumerable, Ownable {
2029     using Math for uint256;
2030 
2031     event Stake(
2032         uint256 indexed tokenId,
2033         address staker,
2034         bytes32 stakingPlan,
2035         uint256 amount
2036     );
2037     event Unstake(uint256 indexed tokenId);
2038     event Redeem(uint256 indexed tokenId, uint256 amount);
2039     event Harvest(uint256 indexed tokenId, uint256 rewardAmount);
2040     event HarvestAll(uint256[] tokenIds, uint256 rewardAmount);
2041     event StakingPlanCreated(bytes32 name);
2042     event StakingPlanDeactivated(bytes32 name);
2043     event StakingRewardRateUpdated(bytes32 name, uint256 rewardRateX96);
2044     event StakingPowerMultiplierUpdated(bytes32 name, uint256 multiplier);
2045 
2046     QLT private immutable QLTContract;
2047 
2048     uint256 public tokenIdCounter;
2049     uint64 public harvestStartTime;
2050     uint64 public unstakeLockupPeriod;
2051 
2052     uint256 public totalStakingAmount;
2053     address public treasuryAddress;
2054     mapping(uint256 => StakingInfo) public stakingInfos;
2055     mapping(bytes32 => StakingPlan) public stakingPlans;
2056 
2057     mapping(address => bool) public authorizedOperators;
2058 
2059     constructor(address _QLTContract)
2060         ERC721("Staked QLT", "sQLT", "https://staked.quantland.finance/")
2061     {
2062         addAuthorizedOperator(msg.sender);
2063         harvestStartTime = type(uint64).max;
2064         unstakeLockupPeriod = DEFAULT_UNSTAKE_LOCKUP_PERIOD;
2065 
2066         addStakingPlan("gold", 7 days, (100040 * Q96) / 100000, 1); // APY 3,222 %
2067         addStakingPlan("platinum", 30 days, (100060 * Q96) / 100000, 3); // APY 19,041 %
2068         addStakingPlan("diamond", 90 days, (100080 * Q96) / 100000, 5); // APY 110,200 %
2069 
2070         QLTContract = QLT(_QLTContract);
2071     }
2072 
2073     /* Staking Plan Governance Functions */
2074     function addStakingPlan(
2075         bytes32 name,
2076         uint64 lockupPeriod,
2077         uint256 rewardRateX96,
2078         uint64 multiplier
2079     ) public onlyOwner {
2080         require(stakingPlans[name].createdAt == 0, "already created");
2081         StakingPlan storage stakingPlan = stakingPlans[name];
2082         stakingPlan.name = name;
2083         stakingPlan.rewardRates.push(
2084             StakingRewardRate({
2085                 rewardRateX96: rewardRateX96,
2086                 startTime: Time.current_hour_timestamp()
2087             })
2088         );
2089         stakingPlan.multipliers.push(
2090             StakingPowerMultiplier({
2091                 multiplier: multiplier,
2092                 startTime: Time.block_timestamp()
2093             })
2094         );
2095         stakingPlan.lockupPeriod = lockupPeriod;
2096         stakingPlan.createdAt = Time.block_timestamp();
2097 
2098         emit StakingPlanCreated(name);
2099     }
2100 
2101     function deactivateStakingPlan(bytes32 name) public onlyOwner {
2102         _checkStakingPlanActive(name);
2103 
2104         StakingPlan storage stakingPlan = stakingPlans[name];
2105         stakingPlan.deactivatedAt = Time.block_timestamp();
2106 
2107         emit StakingPlanDeactivated(name);
2108     }
2109 
2110     function updateStakingRewardRate(bytes32 name, uint256 rewardRateX96)
2111         public
2112         onlyOperator
2113     {
2114         _checkStakingPlanActive(name);
2115 
2116         StakingPlan storage stakingPlan = stakingPlans[name];
2117         stakingPlan.rewardRates.push(
2118             StakingRewardRate({
2119                 rewardRateX96: rewardRateX96,
2120                 startTime: Time.current_hour_timestamp()
2121             })
2122         );
2123 
2124         emit StakingRewardRateUpdated(name, rewardRateX96);
2125     }
2126 
2127     function updateStakingPowerMultiplier(bytes32 name, uint64 multiplier)
2128         public
2129         onlyOperator
2130     {
2131         _checkStakingPlanActive(name);
2132 
2133         StakingPlan storage stakingPlan = stakingPlans[name];
2134         stakingPlan.multipliers.push(
2135             StakingPowerMultiplier({
2136                 multiplier: multiplier,
2137                 startTime: Time.block_timestamp()
2138             })
2139         );
2140 
2141         emit StakingPowerMultiplierUpdated(name, multiplier);
2142     }
2143 
2144     /* Staking-Related Functions */
2145     function stake(
2146         address recipient,
2147         bytes32 stakingPlan,
2148         uint256 amount
2149     ) external returns (uint256 tokenId) {
2150         require(amount > 0, "amount is 0");
2151         _checkStakingPlanActive(stakingPlan);
2152 
2153         // transfer QLT
2154         QLTContract.transferFrom(msg.sender, address(this), amount);
2155 
2156         // mint
2157         tokenIdCounter += 1;
2158         tokenId = tokenIdCounter;
2159         _mint(recipient, tokenId);
2160         _approve(address(this), tokenId);
2161 
2162         // update staking info
2163         StakingInfo storage stakingInfo = stakingInfos[tokenId];
2164         stakingInfo.stakingPlan = stakingPlan;
2165         stakingInfo.stakedAmount = amount;
2166         stakingInfo.stakeTime = Time.block_timestamp();
2167         stakingInfo.lastHarvestTime = Time.current_hour_timestamp();
2168 
2169         // update staking plan info
2170         stakingPlans[stakingPlan].stakingAmount += amount;
2171         totalStakingAmount += amount;
2172 
2173         emit Stake(tokenId, recipient, stakingPlan, amount);
2174     }
2175 
2176     function unstake(uint256 tokenId) external returns (uint256 rewardAmount) {
2177         _checkOwnershipOfStakingToken(tokenId);
2178 
2179         StakingInfo storage stakingInfo = stakingInfos[tokenId];
2180         uint64 lockupPeriod = stakingPlans[stakingInfo.stakingPlan]
2181             .lockupPeriod;
2182         uint64 stakeTime = stakingInfo.stakeTime;
2183         uint64 unstakeTime = stakingInfo.unstakeTime;
2184 
2185         if (msg.sender == treasuryAddress) {
2186             lockupPeriod = 0;
2187         }
2188 
2189         require(unstakeTime == 0, "already unstaked");
2190         require(
2191             Time.block_timestamp() >= (stakeTime + lockupPeriod),
2192             "still in lockup"
2193         );
2194 
2195         // harvest first
2196         rewardAmount = harvestInternal(tokenId);
2197 
2198         // update staking info
2199         uint256 unstakedAmount = stakingInfo.stakedAmount;
2200         stakingInfo.unstakeTime = Time.block_timestamp();
2201 
2202         // update staking plan info
2203         stakingPlans[stakingInfo.stakingPlan].stakingAmount -= unstakedAmount;
2204         totalStakingAmount -= unstakedAmount;
2205 
2206         emit Unstake(tokenId);
2207     }
2208 
2209     function redeem(uint256 tokenId) external returns (uint256 redeemedAmount) {
2210         _checkOwnershipOfStakingToken(tokenId);
2211 
2212         StakingInfo storage stakingInfo = stakingInfos[tokenId];
2213         uint64 unstakeTime = stakingInfo.unstakeTime;
2214         uint64 redeemTime = stakingInfo.redeemTime;
2215         uint64 _unstakeLockupPeriod = unstakeLockupPeriod;
2216 
2217         if (msg.sender == treasuryAddress) {
2218             _unstakeLockupPeriod = 0;
2219         }
2220 
2221         // check if can unstake
2222         require(unstakeTime > 0, "not unstaked");
2223         require(
2224             Time.block_timestamp() >= (unstakeTime + _unstakeLockupPeriod),
2225             "still in lockup"
2226         );
2227         require(redeemTime == 0, "already redeemed");
2228 
2229         // recycle and burn staking NFT
2230         address staker = ownerOf(tokenId);
2231         transferFrom(msg.sender, address(this), tokenId);
2232         _burn(tokenId);
2233 
2234         // transfer QLT back to staker
2235         redeemedAmount = stakingInfo.stakedAmount;
2236         QLTContract.transfer(staker, redeemedAmount);
2237 
2238         // update staking info
2239         stakingInfo.redeemTime = Time.block_timestamp();
2240 
2241         emit Redeem(tokenId, redeemedAmount);
2242     }
2243 
2244     function harvest(uint256 tokenId) external returns (uint256 rewardAmount) {
2245         return harvestInternal(tokenId);
2246     }
2247 
2248     function harvestAll(uint256[] calldata tokenIds)
2249         external
2250         returns (uint256 rewardAmount)
2251     {
2252         for (uint256 i = 0; i < tokenIds.length; i++) {
2253             rewardAmount += harvestInternal(tokenIds[i]);
2254         }
2255 
2256         emit HarvestAll(tokenIds, rewardAmount);
2257     }
2258 
2259     function harvestInternal(uint256 tokenId)
2260         internal
2261         returns (uint256 rewardAmount)
2262     {
2263         require(Time.block_timestamp() >= harvestStartTime, "come back later");
2264         _checkOwnershipOfStakingToken(tokenId);
2265 
2266         rewardAmount = getRewardsToHarvest(tokenId);
2267 
2268         if (rewardAmount > 0) {
2269             // mint QLT to recipient
2270             QLTContract.mint(ownerOf(tokenId), rewardAmount);
2271 
2272             // update staking info
2273             StakingInfo storage stakingInfo = stakingInfos[tokenId];
2274             stakingInfo.lastHarvestTime = Time.current_hour_timestamp();
2275             stakingInfo.accumulatedStakingReward += rewardAmount;
2276 
2277             // update staking plan info
2278             StakingPlan storage stakingPlan = stakingPlans[
2279                 stakingInfo.stakingPlan
2280             ];
2281             stakingPlan.accumulatedStakingReward += rewardAmount;
2282 
2283             emit Harvest(tokenId, rewardAmount);
2284         }
2285     }
2286 
2287     /* Staking State View Functions */
2288     function getRewardsToHarvest(uint256 tokenId)
2289         public
2290         view
2291         returns (uint256 rewardAmount)
2292     {
2293         require(tokenId <= tokenIdCounter, "not existent");
2294 
2295         StakingInfo storage stakingInfo = stakingInfos[tokenId];
2296 
2297         if (stakingInfo.unstakeTime > 0) {
2298             return 0;
2299         }
2300 
2301         StakingPlan storage stakingPlan = stakingPlans[stakingInfo.stakingPlan];
2302 
2303         // calculate compounded rewards of QLT
2304         uint256 stakedAmountX96 = stakingInfo.stakedAmount * Q96;
2305         uint256 compoundedAmountX96 = stakedAmountX96;
2306         uint64 rewardEndTime = Time.current_hour_timestamp();
2307         uint64 lastHarvestTime = stakingInfo.lastHarvestTime;
2308 
2309         StakingRewardRate[] storage rewardRates = stakingPlan.rewardRates;
2310         uint256 i = rewardRates.length;
2311         while (i > 0) {
2312             i--;
2313 
2314             uint64 rewardStartTime = rewardRates[i].startTime;
2315             uint256 rewardRateX96 = rewardRates[i].rewardRateX96;
2316             uint256 nCompounds;
2317 
2318             if (rewardEndTime < rewardStartTime) {
2319                 continue;
2320             }
2321 
2322             if (rewardStartTime >= lastHarvestTime) {
2323                 nCompounds = (rewardEndTime - rewardStartTime) / 1 hours;
2324                 compoundedAmountX96 = compoundedAmountX96.mulX96(
2325                     Math.compound(rewardRateX96, nCompounds)
2326                 );
2327                 rewardEndTime = rewardStartTime;
2328             } else {
2329                 nCompounds = (rewardEndTime - lastHarvestTime) / 1 hours;
2330                 compoundedAmountX96 = compoundedAmountX96.mulX96(
2331                     Math.compound(rewardRateX96, nCompounds)
2332                 );
2333                 break;
2334             }
2335         }
2336 
2337         rewardAmount = (compoundedAmountX96 - stakedAmountX96) / Q96;
2338     }
2339 
2340     function getAllRewardsToHarvest(uint256[] calldata tokenIds)
2341         public
2342         view
2343         returns (uint256 rewardAmount)
2344     {
2345         for (uint256 i = 0; i < tokenIds.length; i++) {
2346             rewardAmount += getRewardsToHarvest(tokenIds[i]);
2347         }
2348     }
2349 
2350     function getStakingPower(
2351         uint256 tokenId,
2352         uint64 startTime,
2353         uint64 endTime
2354     ) public view returns (uint256 stakingPower) {
2355         require(tokenId <= tokenIdCounter, "not existent");
2356 
2357         StakingInfo storage stakingInfo = stakingInfos[tokenId];
2358         if (stakingInfo.stakeTime >= endTime || stakingInfo.unstakeTime > 0) {
2359             return 0;
2360         }
2361         if (stakingInfo.stakeTime > startTime) {
2362             startTime = stakingInfo.stakeTime;
2363         }
2364 
2365         StakingPlan storage stakingPlan = stakingPlans[stakingInfo.stakingPlan];
2366         uint256 stakedAmount = stakingInfo.stakedAmount;
2367         StakingPowerMultiplier[] storage multipliers = stakingPlan.multipliers;
2368         uint256 i = multipliers.length;
2369         while (i > 0) {
2370             i--;
2371 
2372             uint64 rewardStartTime = multipliers[i].startTime;
2373             uint256 multiplier = multipliers[i].multiplier;
2374 
2375             if (rewardStartTime >= endTime) {
2376                 continue;
2377             }
2378 
2379             if (rewardStartTime >= startTime) {
2380                 stakingPower +=
2381                     stakedAmount *
2382                     (endTime - rewardStartTime) *
2383                     multiplier;
2384                 endTime = rewardStartTime;
2385             } else {
2386                 stakingPower +=
2387                     stakedAmount *
2388                     (endTime - startTime) *
2389                     multiplier;
2390                 break;
2391             }
2392         }
2393     }
2394 
2395     function getAllStakingPower(
2396         uint256[] calldata tokenIds,
2397         uint64 startTime,
2398         uint64 endTime
2399     ) public view returns (uint256 stakingPower) {
2400         for (uint256 i = 0; i < tokenIds.length; i++) {
2401             stakingPower += getStakingPower(tokenIds[i], startTime, endTime);
2402         }
2403     }
2404 
2405     /* Config Setters */
2406     function setHarvestStartTime(uint64 _harvestStartTime) external onlyOwner {
2407         harvestStartTime = _harvestStartTime;
2408     }
2409 
2410     function setUnstakeLockupPeriod(uint64 _unstakeLockupPeriod)
2411         external
2412         onlyOwner
2413     {
2414         unstakeLockupPeriod = _unstakeLockupPeriod;
2415     }
2416 
2417     function setTreasuryAddress(address _treasuryAddress) external onlyOwner {
2418         treasuryAddress = _treasuryAddress;
2419     }
2420 
2421     /* Helper Functions */
2422     function _checkOwnershipOfStakingToken(uint256 tokenId) internal view {
2423         require(ownerOf(tokenId) == msg.sender, "not owner");
2424     }
2425 
2426     function _checkStakingPlanActive(bytes32 stakingPlan) internal view {
2427         require(
2428             stakingPlans[stakingPlan].deactivatedAt == 0,
2429             "staking plan not active"
2430         );
2431     }
2432 
2433     /* Access Control */
2434     function addAuthorizedOperator(address account) public onlyOwner {
2435         authorizedOperators[account] = true;
2436     }
2437 
2438     function removeAuthorizedOperator(address account) external onlyOwner {
2439         authorizedOperators[account] = false;
2440     }
2441 
2442     modifier onlyOperator() {
2443         require(authorizedOperators[msg.sender], "not authorized");
2444         _;
2445     }
2446 }
2447 
2448 
2449 // File contracts/Treasury.sol
2450 
2451 struct TreasuryConfig {
2452     uint256 minMintPriceX96;
2453     uint64 mintStartTime;
2454     uint32 twapDuration;
2455     bool isGenesisPhase;
2456 }
2457 
2458 struct TreasuryStats {
2459     uint128 amountQLTMinted;
2460     uint128 amountUSDCReceived;
2461 }
2462 
2463 struct LiquidityPosition {
2464     uint256 tokenId;
2465     uint128 liquidity;
2466     int24 lowerTick;
2467     int24 upperTick;
2468     uint256 amountQLT;
2469     uint256 amountUSDC;
2470     int24 refreshedAtTick;
2471     uint64 refreshTime;
2472 }
2473 
2474 contract Treasury is Lockable, Ownable {
2475     using Math for uint256;
2476 
2477     event Mint(
2478         address indexed minter,
2479         address srcToken,
2480         uint256 amountSrcToken,
2481         uint256 amountUSDC,
2482         uint256 amountQLT,
2483         uint256 mintPriceX96,
2484         bytes32 stakingPlan,
2485         uint256 mintDiscountedRateX96,
2486         uint256 tokenId
2487     );
2488     event TreasuryBuy(uint256 amountUSDC, uint256 amountQLT);
2489     event TreasurySell(uint256 amountQLT, uint256 amountUSDC);
2490     event LiquidityPositionRefreshed(
2491         uint256 tokenId,
2492         uint128 liquidity,
2493         int24 lowerTick,
2494         int24 upperTick,
2495         uint256 amountQLT,
2496         uint256 amountUSDC,
2497         int24 refreshedAtTick
2498     );
2499 
2500     QLT public immutable QLTContract;
2501     StakedQLT public StakedQLTContract;
2502     IUniswapV3Pool public immutable QLT_USDC_Pool;
2503     INonfungiblePositionManager public immutable liquidityPositionManager;
2504 
2505     TreasuryConfig public config;
2506     TreasuryStats public stats;
2507     LiquidityPosition public liquidityPosition;
2508     uint256 public stakingTokenId;
2509 
2510     mapping(address => bool) public authorizedSrcToken;
2511     mapping(address => bool) public authorizedOperators;
2512     mapping(bytes32 => bool) public authorizedMintStakingPlan;
2513     mapping(bytes32 => uint256) public stakingPlanMintDiscountedRatesX96;
2514 
2515     constructor(address _QLTContract, address _StakedQLTContract) {
2516         authorizedOperators[msg.sender] = true;
2517 
2518         // initialize configs
2519         config = TreasuryConfig({
2520             minMintPriceX96: DEFAULT_MIN_MINT_PRICE_X96,
2521             mintStartTime: type(uint64).max,
2522             twapDuration: DEFAULT_TWAP_DURATION,
2523             isGenesisPhase: true
2524         });
2525 
2526         // authorized mint src token list
2527         authorizedSrcToken[WETH] = true;
2528         authorizedSrcToken[USDC] = true;
2529         authorizedSrcToken[USDT] = true;
2530         authorizedSrcToken[DAI] = true;
2531         authorizedSrcToken[BUSD] = true;
2532         authorizedSrcToken[FRAX] = true;
2533         authorizedSrcToken[WBTC] = true;
2534 
2535         // authorized mint staking plan list
2536         authorizedMintStakingPlan["gold"] = true;
2537         authorizedMintStakingPlan["platinum"] = true;
2538         authorizedMintStakingPlan["diamond"] = true;
2539 
2540         // mint discount rate
2541         stakingPlanMintDiscountedRatesX96["gold"] = (98 * Q96) / 100; // 2% discount
2542         stakingPlanMintDiscountedRatesX96["platinum"] = (95 * Q96) / 100; // 5% discount
2543         stakingPlanMintDiscountedRatesX96["diamond"] = (92 * Q96) / 100; // 8% discount
2544 
2545         QLTContract = QLT(_QLTContract);
2546         StakedQLTContract = StakedQLT(_StakedQLTContract);
2547 
2548         QLT_USDC_Pool = IUniswapV3Pool(
2549             IUniswapV3Factory(UNISWAP_FACTORY).getPool(
2550                 address(QLTContract),
2551                 USDC,
2552                 UNISWAP_POOL_FEE
2553             )
2554         );
2555 
2556         liquidityPositionManager = INonfungiblePositionManager(UNISWAP_NFP_MGR);
2557     }
2558 
2559     function mint(
2560         address srcToken,
2561         uint256 amountSrcToken,
2562         uint24 poolFee,
2563         bytes32 stakingPlan
2564     ) external payable lock returns (uint256 amountQLT, uint256 tokenId) {
2565         require(block.timestamp >= config.mintStartTime, "come back later");
2566         require(authorizedMintStakingPlan[stakingPlan], "invalid staking plan");
2567 
2568         // mint by ETH -> convert to WETH
2569         if (msg.value > 0) {
2570             IWETH(WETH).deposit{value: msg.value}();
2571             srcToken = WETH;
2572             amountSrcToken = msg.value;
2573             poolFee = 500;
2574         } else {
2575             require(authorizedSrcToken[srcToken], "invalid srcToken");
2576 
2577             TransferHelper.safeTransferFrom(
2578                 srcToken,
2579                 msg.sender,
2580                 address(this),
2581                 amountSrcToken
2582             );
2583         }
2584 
2585         // Swap as USDC
2586         uint256 amountUSDC = 0;
2587 
2588         if (srcToken != USDC) {
2589             TransferHelper.safeApprove(
2590                 srcToken,
2591                 address(UNISWAP_ROUTER),
2592                 amountSrcToken
2593             );
2594             amountUSDC = ISwapRouter(UNISWAP_ROUTER).exactInputSingle(
2595                 ISwapRouter.ExactInputSingleParams({
2596                     tokenIn: srcToken,
2597                     tokenOut: USDC,
2598                     fee: poolFee,
2599                     recipient: address(this),
2600                     deadline: block.timestamp,
2601                     amountIn: amountSrcToken,
2602                     amountOutMinimum: 0,
2603                     sqrtPriceLimitX96: 0
2604                 })
2605             );
2606         } else {
2607             amountUSDC = amountSrcToken;
2608         }
2609 
2610         require(amountUSDC > 0, "no USDC received");
2611         uint256 mintPriceX96 = getMintPriceX96(stakingPlan, amountUSDC);
2612         amountQLT = ((amountUSDC * Q96).divX96(mintPriceX96) * 10**3) / Q96;
2613         QLTContract.mint(address(this), amountQLT * 2); // 1:1 for treasury reserve
2614 
2615         // stake
2616         QLTContract.approve(address(StakedQLTContract), amountQLT);
2617         tokenId = StakedQLTContract.stake(msg.sender, stakingPlan, amountQLT);
2618 
2619         // update stats
2620         stats.amountQLTMinted += uint128(amountQLT);
2621         stats.amountUSDCReceived += uint128(amountUSDC);
2622 
2623         emit Mint(
2624             msg.sender,
2625             srcToken,
2626             amountSrcToken,
2627             amountUSDC,
2628             amountQLT,
2629             mintPriceX96,
2630             stakingPlan,
2631             stakingPlanMintDiscountedRatesX96[stakingPlan],
2632             tokenId
2633         );
2634     }
2635 
2636     /* Token Transfer Utility Functions */
2637     function transferETH(address to, uint256 value) external onlyOwner {
2638         TransferHelper.safeTransferETH(to, value);
2639     }
2640 
2641     function transferToken(
2642         address token,
2643         address to,
2644         uint256 value
2645     ) external onlyOwner {
2646         TransferHelper.safeTransfer(token, to, value);
2647     }
2648 
2649     function approveToken(
2650         address token,
2651         address to,
2652         uint256 value
2653     ) external onlyOwner {
2654         TransferHelper.safeApprove(token, to, value);
2655     }
2656 
2657     function call(address target, bytes calldata payload) external onlyOwner {
2658         (bool success, ) = target.call(payload);
2659         require(success);
2660     }
2661 
2662     /* Treasury Utility Functions */
2663     function buyQLT(uint256 amountUSDC) external onlyOperator {
2664         require(amountUSDC > 0);
2665 
2666         TransferHelper.safeApprove(USDC, address(UNISWAP_ROUTER), amountUSDC);
2667         uint256 amountQLT = ISwapRouter(UNISWAP_ROUTER).exactInputSingle(
2668             ISwapRouter.ExactInputSingleParams({
2669                 tokenIn: USDC,
2670                 tokenOut: address(QLTContract),
2671                 fee: UNISWAP_POOL_FEE,
2672                 recipient: address(this),
2673                 deadline: block.timestamp,
2674                 amountIn: amountUSDC,
2675                 amountOutMinimum: 0,
2676                 sqrtPriceLimitX96: 0
2677             })
2678         );
2679 
2680         emit TreasuryBuy(amountUSDC, amountQLT);
2681     }
2682 
2683     function sellQLT(uint256 amountQLT) external onlyOperator {
2684         require(amountQLT > 0);
2685 
2686         QLTContract.approve(address(UNISWAP_ROUTER), amountQLT);
2687         uint256 amountUSDC = ISwapRouter(UNISWAP_ROUTER).exactInputSingle(
2688             ISwapRouter.ExactInputSingleParams({
2689                 tokenIn: address(QLTContract),
2690                 tokenOut: USDC,
2691                 fee: UNISWAP_POOL_FEE,
2692                 recipient: address(this),
2693                 deadline: block.timestamp,
2694                 amountIn: amountQLT,
2695                 amountOutMinimum: 0,
2696                 sqrtPriceLimitX96: 0
2697             })
2698         );
2699 
2700         emit TreasurySell(amountQLT, amountUSDC);
2701     }
2702 
2703     function refreshLiquidityPosition(
2704         int24 lowerTick,
2705         int24 upperTick,
2706         uint256 amountQLT,
2707         uint256 amountUSDC
2708     ) external onlyOperator {
2709         if (liquidityPosition.tokenId != 0) {
2710             // decrease liquidity
2711             liquidityPositionManager.decreaseLiquidity(
2712                 INonfungiblePositionManager.DecreaseLiquidityParams({
2713                     tokenId: liquidityPosition.tokenId,
2714                     liquidity: liquidityPosition.liquidity,
2715                     amount0Min: 0,
2716                     amount1Min: 0,
2717                     deadline: block.timestamp
2718                 })
2719             );
2720 
2721             // collect fees
2722             liquidityPositionManager.collect(
2723                 INonfungiblePositionManager.CollectParams({
2724                     tokenId: liquidityPosition.tokenId,
2725                     recipient: address(this),
2726                     amount0Max: type(uint128).max,
2727                     amount1Max: type(uint128).max
2728                 })
2729             );
2730 
2731             // burn liquidity position
2732             liquidityPositionManager.burn(liquidityPosition.tokenId);
2733 
2734             delete liquidityPosition;
2735         }
2736 
2737         // mint liquidity position
2738         if (amountQLT > 0 && amountUSDC > 0) {
2739             QLTContract.approve(address(liquidityPositionManager), amountQLT);
2740             TransferHelper.safeApprove(
2741                 USDC,
2742                 address(liquidityPositionManager),
2743                 amountUSDC
2744             );
2745             (
2746                 uint256 tokenId,
2747                 uint128 liquidity,
2748                 uint256 consumedQLT,
2749                 uint256 consumedUSDC
2750             ) = liquidityPositionManager.mint(
2751                     INonfungiblePositionManager.MintParams({
2752                         token0: address(QLTContract),
2753                         token1: USDC,
2754                         fee: UNISWAP_POOL_FEE,
2755                         tickLower: lowerTick,
2756                         tickUpper: upperTick,
2757                         amount0Desired: amountQLT,
2758                         amount1Desired: amountUSDC,
2759                         amount0Min: 0,
2760                         amount1Min: 0,
2761                         recipient: address(this),
2762                         deadline: block.timestamp
2763                     })
2764                 );
2765             QLTContract.approve(address(liquidityPositionManager), 0);
2766             TransferHelper.safeApprove(
2767                 USDC,
2768                 address(liquidityPositionManager),
2769                 0
2770             );
2771 
2772             // update liquidity state
2773             liquidityPosition.tokenId = tokenId;
2774             liquidityPosition.liquidity = liquidity;
2775             liquidityPosition.lowerTick = lowerTick;
2776             liquidityPosition.upperTick = upperTick;
2777             liquidityPosition.amountQLT = consumedQLT;
2778             liquidityPosition.amountUSDC = consumedUSDC;
2779             liquidityPosition.refreshedAtTick = getPriceTick();
2780             liquidityPosition.refreshTime = Time.block_timestamp();
2781         }
2782 
2783         emit LiquidityPositionRefreshed(
2784             liquidityPosition.tokenId,
2785             liquidityPosition.liquidity,
2786             liquidityPosition.lowerTick,
2787             liquidityPosition.upperTick,
2788             liquidityPosition.amountQLT,
2789             liquidityPosition.amountUSDC,
2790             liquidityPosition.refreshedAtTick
2791         );
2792     }
2793 
2794     function updateStakingAmount(bytes32 stakingPlan, uint256 amount)
2795         external
2796         onlyOperator
2797     {
2798         if (stakingTokenId != 0) {
2799             StakedQLTContract.unstake(stakingTokenId);
2800             StakedQLTContract.redeem(stakingTokenId);
2801             stakingTokenId = 0;
2802         }
2803 
2804         if (amount > 0) {
2805             QLTContract.approve(address(StakedQLTContract), amount);
2806             stakingTokenId = StakedQLTContract.stake(
2807                 address(this),
2808                 stakingPlan,
2809                 amount
2810             );
2811         }
2812     }
2813 
2814     /* Config Setters */
2815     function setTreasuryConfig(
2816         uint64 mintStartTime,
2817         bool isGenesisPhase,
2818         uint256 minMintPriceX96,
2819         uint32 twapDuration
2820     ) external onlyOperator {
2821         config.mintStartTime = mintStartTime;
2822         config.isGenesisPhase = isGenesisPhase;
2823         config.minMintPriceX96 = minMintPriceX96;
2824         config.twapDuration = twapDuration;
2825     }
2826 
2827     function setMintDiscountedRate(
2828         bytes32 stakingPlan,
2829         uint256 mintDiscountedRateX96
2830     ) external onlyOperator {
2831         stakingPlanMintDiscountedRatesX96[stakingPlan] = mintDiscountedRateX96;
2832     }
2833 
2834     function upgradeStakedQLTContract(address _StakedQLTContract)
2835         external
2836         onlyOwner
2837     {
2838         StakedQLTContract = StakedQLT(_StakedQLTContract);
2839     }
2840 
2841     /* Utility Functions */
2842     function getPriceTick() public view returns (int24 priceTick) {
2843         (, priceTick, , , , , ) = QLT_USDC_Pool.slot0();
2844     }
2845 
2846     function getMintPriceX96(bytes32 stakingPlan, uint256 amountUSDC)
2847         public
2848         view
2849         returns (uint256 mintPriceX96)
2850     {
2851         if (config.isGenesisPhase) {
2852             uint256 totalUSDC = stats.amountUSDCReceived + amountUSDC;
2853             uint256 receivedMX96 = stats.amountUSDCReceived * TX96;
2854             uint256 totalMX96 = totalUSDC * TX96;
2855             // d a(1+x^0.5/5) / dx = a(x+2x^1.5/15)
2856             mintPriceX96 = DEFAULT_MIN_MINT_PRICE_X96
2857                 .mulX96(
2858                     totalMX96 -
2859                         receivedMX96 +
2860                         (2 *
2861                             (totalMX96.mulX96(Math.sqrt(totalUSDC) * MX96) -
2862                                 receivedMX96.mulX96(
2863                                     Math.sqrt(stats.amountUSDCReceived) * MX96
2864                                 ))) /
2865                         15
2866                 )
2867                 .divX96(amountUSDC * TX96);
2868         } else {
2869             mintPriceX96 = Math.max(getTwapPriceX96(), getPriceX96());
2870         }
2871 
2872         uint256 mintDiscountedRateX96 = stakingPlanMintDiscountedRatesX96[
2873             stakingPlan
2874         ];
2875         require(mintDiscountedRateX96 > 0);
2876 
2877         mintPriceX96 = Math.max(mintPriceX96, config.minMintPriceX96);
2878         mintPriceX96 = mintPriceX96.mulX96(mintDiscountedRateX96);
2879     }
2880 
2881     function getTwapPriceX96() public view returns (uint256 twapPriceX96) {
2882         (uint256 sqrtPriceX96, , , , , , ) = QLT_USDC_Pool.slot0();
2883         uint32 twapDuration = config.twapDuration;
2884 
2885         if (twapDuration > 0) {
2886             uint32[] memory secondsAgos = new uint32[](2);
2887             secondsAgos[0] = twapDuration;
2888             secondsAgos[1] = 0;
2889 
2890             try QLT_USDC_Pool.observe(secondsAgos) returns (
2891                 int56[] memory tickCumulatives,
2892                 uint160[] memory
2893             ) {
2894                 sqrtPriceX96 = TickMath.getSqrtRatioAtTick(
2895                     int24(
2896                         (tickCumulatives[1] - tickCumulatives[0]) /
2897                             int32(twapDuration)
2898                     )
2899                 );
2900             } catch {}
2901         }
2902 
2903         twapPriceX96 = (sqrtPriceX96 * sqrtPriceX96) / Q96;
2904     }
2905 
2906     function getPriceX96() public view returns (uint256 priceX96) {
2907         (uint256 sqrtPriceX96, , , , , , ) = QLT_USDC_Pool.slot0();
2908 
2909         priceX96 = (sqrtPriceX96 * sqrtPriceX96) / Q96;
2910     }
2911 
2912     /* Access Control */
2913     function addAuthorizedMintStakingPlan(bytes32 stakingPlan)
2914         external
2915         onlyOwner
2916     {
2917         authorizedMintStakingPlan[stakingPlan] = true;
2918     }
2919 
2920     function removeAuthorizedMintStakingPlan(bytes32 stakingPlan)
2921         external
2922         onlyOwner
2923     {
2924         authorizedMintStakingPlan[stakingPlan] = false;
2925     }
2926 
2927     function addAuthorizedSrcToken(address srcToken) external onlyOwner {
2928         authorizedSrcToken[srcToken] = true;
2929     }
2930 
2931     function removeAuthorizedSrcToken(address srcToken) external onlyOwner {
2932         authorizedSrcToken[srcToken] = false;
2933     }
2934 
2935     function addAuthorizedOperator(address account) external onlyOwner {
2936         authorizedOperators[account] = true;
2937     }
2938 
2939     function removeAuthorizedOperator(address account) external onlyOwner {
2940         authorizedOperators[account] = false;
2941     }
2942 
2943     modifier onlyOperator() {
2944         require(authorizedOperators[msg.sender], "not authorized");
2945         _;
2946     }
2947 
2948     /* Fallback Function */
2949     fallback() external payable {}
2950 
2951     receive() external payable {}
2952 }