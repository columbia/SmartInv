1 // SPDX-License-Identifier: GPL-3.0-or-later
2 
3 pragma solidity >=0.8.0;
4 
5 import "../../interfaces/IBentoBoxMinimal.sol";
6 import "../../interfaces/IMasterDeployer.sol";
7 import "../../interfaces/IPool.sol";
8 import "../../interfaces/IPositionManager.sol";
9 import "../../interfaces/ITridentCallee.sol";
10 import "../../interfaces/ITridentRouter.sol";
11 import "../../libraries/concentratedPool/FullMath.sol";
12 import "../../libraries/concentratedPool/TickMath.sol";
13 import "../../libraries/concentratedPool/UnsafeMath.sol";
14 import "../../libraries/concentratedPool/DyDxMath.sol";
15 import "../../libraries/concentratedPool/SwapLib.sol";
16 import "../../libraries/concentratedPool/Ticks.sol";
17 import "hardhat/console.sol";
18 
19 
20 contract ConcentratedLiquidityPool is IPool {
21     using Ticks for mapping(int24 => Ticks.Tick);
22 
23     event Mint(address indexed sender, uint256 amount0, uint256 amount1, address indexed recipient);
24     event Burn(address indexed sender, uint256 amount0, uint256 amount1, address indexed recipient);
25     event Collect(address indexed sender, uint256 amount0, uint256 amount1);
26     event Sync(uint256 reserveShares0, uint256 reserveShares1);
27 
28     /// @dev References for tickSpacing:
29     // 100 tickSpacing -> 2% between ticks.
30     bytes32 public constant override poolIdentifier = "Trident:ConcentratedLiquidity";
31 
32     uint24 internal constant MAX_FEE = 100000; /// @dev Maximum `swapFee` is 10%.
33 
34     uint128 internal immutable MAX_TICK_LIQUIDITY;
35     uint24 internal immutable tickSpacing;
36     uint24 internal immutable swapFee; /// @dev 1000 corresponds to 0.1% fee. Fee is measured in pips.
37 
38     address internal immutable barFeeTo;
39     IBentoBoxMinimal internal immutable bento;
40     IMasterDeployer internal immutable masterDeployer;
41 
42     address internal immutable token0;
43     address internal immutable token1;
44 
45     uint128 public liquidity;
46 
47     uint160 internal secondsPerLiquidity; /// @dev Multiplied by 2^128.
48     uint32 internal lastObservation;
49 
50     uint256 public feeGrowthGlobal0; /// @dev All fee growth counters are multiplied by 2^128.
51     uint256 public feeGrowthGlobal1;
52 
53     uint256 public barFee;
54 
55     uint128 internal token0ProtocolFee;
56     uint128 internal token1ProtocolFee;
57 
58     uint128 internal reserve0; /// @dev `bento` share balance tracker.
59     uint128 internal reserve1;
60 
61     uint160 internal price; /// @dev Sqrt of price aka. √(y/x), multiplied by 2^96.
62     int24 internal nearestTick; /// @dev Tick that is just below the current price.
63 
64     uint256 internal unlocked;
65     modifier lock() {
66         require(unlocked == 1, "LOCKED");
67         unlocked = 2;
68         _;
69         unlocked = 1;
70     }
71 
72     mapping(int24 => Ticks.Tick) public ticks;
73     mapping(address => mapping(int24 => mapping(int24 => Position))) public positions;
74 
75     struct Position {
76         uint128 liquidity;
77         uint256 feeGrowthInside0Last;
78         uint256 feeGrowthInside1Last;
79     }
80 
81     struct SwapCache {
82         uint256 feeAmount;
83         uint256 totalFeeAmount;
84         uint256 protocolFee;
85         uint256 feeGrowthGlobal;
86         uint256 currentPrice;
87         uint256 currentLiquidity;
88         uint256 input;
89         int24 nextTickToCross;
90     }
91 
92     struct MintParams {
93         int24 lowerOld;
94         int24 lower;
95         int24 upperOld;
96         int24 upper;
97         uint256 amount0Desired;
98         uint256 amount1Desired;
99         bool token0native;
100         bool token1native;
101         /// @dev To mint an NFT the positionOwner should be set to the positionManager contract.
102         address positionOwner;
103         /// @dev When minting through the positionManager contract positionRecipient should be the NFT recipient.
104         //    It can be set to address(0) if we are not minting through the positionManager contract.
105         address positionRecipient;
106     }
107 
108     /// @dev Only set immutable variables here - state changes made here will not be used.
109     constructor(bytes memory _deployData, IMasterDeployer _masterDeployer) {
110         (address _token0, address _token1, uint24 _swapFee, uint160 _price, uint24 _tickSpacing) = abi.decode(
111             _deployData,
112             (address, address, uint24, uint160, uint24)
113         );
114 
115         require(_token0 != address(0), "ZERO_ADDRESS");
116         require(_token0 != address(this), "INVALID_TOKEN0");
117         require(_token1 != address(this), "INVALID_TOKEN1");
118         require(_swapFee <= MAX_FEE, "INVALID_SWAP_FEE");
119         
120         token0 = _token0;
121         token1 = _token1;
122         swapFee = _swapFee;
123         price = _price;
124         tickSpacing = _tickSpacing;
125         /// @dev Prevents global liquidity overflow in the case all ticks are initialised.
126         MAX_TICK_LIQUIDITY = Ticks.getMaxLiquidity(_tickSpacing);
127         ticks[TickMath.MIN_TICK] = Ticks.Tick(TickMath.MIN_TICK, TickMath.MAX_TICK, uint128(0), 0, 0, 0);
128         ticks[TickMath.MAX_TICK] = Ticks.Tick(TickMath.MIN_TICK, TickMath.MAX_TICK, uint128(0), 0, 0, 0);
129         nearestTick = TickMath.MIN_TICK;
130         bento = IBentoBoxMinimal(_masterDeployer.bento());
131         barFeeTo = _masterDeployer.barFeeTo();
132         barFee = _masterDeployer.barFee();
133         masterDeployer = _masterDeployer;
134         unlocked = 1;
135     }
136 
137 
138     function mint(bytes calldata data) public override lock returns (uint256 _liquidity) {
139         MintParams memory mintParams = abi.decode(data, (MintParams));
140 
141         uint256 priceLower = uint256(TickMath.getSqrtRatioAtTick(mintParams.lower));
142         uint256 priceUpper = uint256(TickMath.getSqrtRatioAtTick(mintParams.upper));
143         uint256 currentPrice = uint256(price);
144 
145         _liquidity = DyDxMath.getLiquidityForAmounts(
146             priceLower,
147             priceUpper,
148             currentPrice,
149             mintParams.amount1Desired,
150             mintParams.amount0Desired
151         );
152 
153         {
154             require(_liquidity <= MAX_TICK_LIQUIDITY, "LIQUIDITY_OVERFLOW");
155 
156             (uint256 amount0fees, uint256 amount1fees) = _updatePosition(
157                 mintParams.positionOwner,
158                 mintParams.lower,
159                 mintParams.upper,
160                 int128(uint128(_liquidity))
161             );
162             if (amount0fees > 0) {
163                 _transfer(token0, amount0fees, mintParams.positionOwner, false);
164                 reserve0 -= uint128(amount0fees);
165             }
166             if (amount1fees > 0) {
167                 _transfer(token1, amount1fees, mintParams.positionOwner, false);
168                 reserve1 -= uint128(amount1fees);
169             }
170         }
171 
172         unchecked {
173             if (priceLower < currentPrice && currentPrice < priceUpper) liquidity += uint128(_liquidity);
174         }
175 
176         _ensureTickSpacing(mintParams.lower, mintParams.upper);
177         nearestTick = Ticks.insert(
178             ticks,
179             feeGrowthGlobal0,
180             feeGrowthGlobal1,
181             secondsPerLiquidity,
182             mintParams.lowerOld,
183             mintParams.lower,
184             mintParams.upperOld,
185             mintParams.upper,
186             uint128(_liquidity),
187             nearestTick,
188             uint160(currentPrice)
189         );
190 
191         (uint128 amount0Actual, uint128 amount1Actual) = _getAmountsForLiquidity(priceLower, priceUpper, currentPrice, _liquidity);
192 
193         ITridentRouter.TokenInput[] memory callbackData = new ITridentRouter.TokenInput[](2);
194         callbackData[0] = ITridentRouter.TokenInput(token0, mintParams.token0native, amount0Actual);
195         callbackData[1] = ITridentRouter.TokenInput(token1, mintParams.token1native, amount1Actual);
196 
197         ITridentCallee(msg.sender).tridentMintCallback(abi.encode(callbackData));
198 
199         unchecked {
200             if (amount0Actual != 0) {
201                 require(amount0Actual + reserve0 <= _balance(token0), "TOKEN0_MISSING");
202                 reserve0 += amount0Actual;
203             }
204 
205             if (amount1Actual != 0) {
206                 require(amount1Actual + reserve1 <= _balance(token1), "TOKEN1_MISSING");
207                 reserve1 += amount1Actual;
208             }
209         }
210 
211         (uint256 feeGrowth0, uint256 feeGrowth1) = rangeFeeGrowth(mintParams.lower, mintParams.upper);
212 
213         if (mintParams.positionRecipient != address(0)) {
214             IPositionManager(mintParams.positionOwner).positionMintCallback(
215                 mintParams.positionRecipient,
216                 mintParams.lower,
217                 mintParams.upper,
218                 uint128(_liquidity),
219                 feeGrowth0,
220                 feeGrowth1
221             );
222         }
223 
224         emit Mint(mintParams.positionOwner, amount0Actual, amount1Actual, mintParams.positionRecipient);
225     }
226 
227     /// @dev Burns LP tokens sent to this contract. The router must ensure that the user gets sufficient output tokens.
228     function burn(bytes calldata data) public override lock returns (IPool.TokenAmount[] memory withdrawnAmounts) {
229         (int24 lower, int24 upper, uint128 amount, address recipient, bool unwrapBento) = abi.decode(
230             data,
231             (int24, int24, uint128, address, bool)
232         );
233 
234         uint160 priceLower = TickMath.getSqrtRatioAtTick(lower);
235         uint160 priceUpper = TickMath.getSqrtRatioAtTick(upper);
236         uint160 currentPrice = price;
237 
238         unchecked {
239             if (priceLower < currentPrice && currentPrice < priceUpper) liquidity -= amount;
240         }
241 
242         (uint256 amount0, uint256 amount1) = _getAmountsForLiquidity(
243             uint256(priceLower),
244             uint256(priceUpper),
245             uint256(currentPrice),
246             uint256(amount)
247         );
248 
249         (uint256 amount0fees, uint256 amount1fees) = _updatePosition(msg.sender, lower, upper, -int128(amount));
250 
251         unchecked {
252             amount0 += amount0fees;
253             amount1 += amount1fees;
254         }
255 
256         withdrawnAmounts = new TokenAmount[](2);
257         withdrawnAmounts[0] = TokenAmount({token: token0, amount: amount0});
258         withdrawnAmounts[1] = TokenAmount({token: token1, amount: amount1});
259 
260         unchecked {
261             reserve0 -= uint128(amount0fees);
262             reserve1 -= uint128(amount1fees);
263         }
264 
265         _transferBothTokens(recipient, amount0, amount1, unwrapBento);
266 
267         nearestTick = Ticks.remove(ticks, lower, upper, amount, nearestTick);
268         emit Burn(msg.sender, amount0, amount1, recipient);
269     }
270 
271     function burnSingle(bytes calldata) public override returns (uint256) {
272         revert();
273     }
274 
275     function collect(
276         int24 lower,
277         int24 upper,
278         address recipient,
279         bool unwrapBento
280     ) public lock returns (uint256 amount0fees, uint256 amount1fees) {
281         (amount0fees, amount1fees) = _updatePosition(msg.sender, lower, upper, 0);
282 
283         _transferBothTokens(recipient, amount0fees, amount1fees, unwrapBento);
284 
285         reserve0 -= uint128(amount0fees);
286         reserve1 -= uint128(amount1fees);
287 
288         emit Collect(msg.sender, amount0fees, amount1fees);
289     }
290 
291    
292     function swap(bytes memory data) public override lock returns (uint256 amountOut) {
293         (bool zeroForOne, uint256 inAmount, address recipient, bool unwrapBento) = abi.decode(data, (bool, uint256, address, bool));
294 
295         SwapCache memory cache = SwapCache({
296             feeAmount: 0,
297             totalFeeAmount: 0,
298             protocolFee: 0,
299             feeGrowthGlobal: zeroForOne ? feeGrowthGlobal1 : feeGrowthGlobal0,
300             currentPrice: uint256(price),
301             currentLiquidity: uint256(liquidity),
302             input: inAmount,
303             nextTickToCross: zeroForOne ? nearestTick : ticks[nearestTick].nextTick
304         });
305 
306         {
307             uint256 timestamp = block.timestamp;
308             uint256 diff = timestamp - uint256(lastObservation); /// @dev Underflow in 2106.
309             if (diff > 0 && liquidity > 0) {
310                 lastObservation = uint32(timestamp);
311                 secondsPerLiquidity += uint160((diff << 128) / liquidity);
312             }
313         }
314 
315         while (cache.input != 0) {
316             uint256 nextTickPrice = uint256(TickMath.getSqrtRatioAtTick(cache.nextTickToCross));
317             uint256 output = 0;
318             bool cross = false;
319 
320             if (zeroForOne) {
321                 // Trading token 0 (x) for token 1 (y).
322                 // Price is decreasing.
323                 // Maximum input amount within current tick range: Δx = Δ(1/√𝑃) · L.
324                 uint256 maxDx = DyDxMath.getDx(cache.currentLiquidity, nextTickPrice, cache.currentPrice, false);
325 
326                 if (cache.input <= maxDx) {
327                     // We can swap within the current range.
328                     uint256 liquidityPadded = cache.currentLiquidity << 96;
329                     // Calculate new price after swap: √𝑃[new] =  L · √𝑃 / (L + Δx · √𝑃)
330                     // This is derrived from Δ(1/√𝑃) = Δx/L
331                     // where Δ(1/√𝑃) is 1/√𝑃[old] - 1/√𝑃[new] and we solve for √𝑃[new].
332                     // In case of an owerflow we can use: √𝑃[new] = L / (L / √𝑃 + Δx).
333                     // This is derrived by dividing the original fraction by √𝑃 on both sides.
334                     uint256 newPrice = uint256(
335                         FullMath.mulDivRoundingUp(liquidityPadded, cache.currentPrice, liquidityPadded + cache.currentPrice * cache.input)
336                     );
337 
338                     if (!(nextTickPrice <= newPrice && newPrice < cache.currentPrice)) {
339                         // Overflow. We use a modified version of the formula.
340                         newPrice = uint160(UnsafeMath.divRoundingUp(liquidityPadded, liquidityPadded / cache.currentPrice + cache.input));
341                     }
342                     // Based on the price difference calculate the output of th swap: Δy = Δ√P · L.
343                     output = DyDxMath.getDy(cache.currentLiquidity, newPrice, cache.currentPrice, false);
344                     cache.currentPrice = newPrice;
345                     cache.input = 0;
346                 } else {
347                     // Execute swap step and cross the tick.
348                     output = DyDxMath.getDy(cache.currentLiquidity, nextTickPrice, cache.currentPrice, false);
349                     cache.currentPrice = nextTickPrice;
350                     cross = true;
351                     cache.input -= maxDx;
352                 }
353             } else {
354     
355                 uint256 maxDy = DyDxMath.getDy(cache.currentLiquidity, cache.currentPrice, nextTickPrice, false);
356 
357                 if (cache.input <= maxDy) {
358       
359                     uint256 newPrice = cache.currentPrice +
360                         FullMath.mulDiv(cache.input, 0x1000000000000000000000000, cache.currentLiquidity);
361 
362                     output = DyDxMath.getDx(cache.currentLiquidity, cache.currentPrice, newPrice, false);
363                     cache.currentPrice = newPrice;
364                     cache.input = 0;
365                 } else {
366                     /// @dev Swap & cross the tick.
367                     output = DyDxMath.getDx(cache.currentLiquidity, cache.currentPrice, nextTickPrice, false);
368                     cache.currentPrice = nextTickPrice;
369                     cross = true;
370                     cache.input -= maxDy;
371                 }
372             }
373             (cache.totalFeeAmount, amountOut, cache.protocolFee, cache.feeGrowthGlobal) = SwapLib.handleFees(
374                 output,
375                 swapFee,
376                 barFee,
377                 cache.currentLiquidity,
378                 cache.totalFeeAmount,
379                 amountOut,
380                 cache.protocolFee,
381                 cache.feeGrowthGlobal
382             );
383             if (cross) {
384                 (cache.currentLiquidity, cache.nextTickToCross) = Ticks.cross(
385                     ticks,
386                     cache.nextTickToCross,
387                     secondsPerLiquidity,
388                     cache.currentLiquidity,
389                     cache.feeGrowthGlobal,
390                     zeroForOne
391                 );
392                 if (cache.currentLiquidity == 0) {
393                     // We step into a zone that has liquidity - or we reach the end of the linked list.
394                     cache.currentPrice = uint256(TickMath.getSqrtRatioAtTick(cache.nextTickToCross));
395                     (cache.currentLiquidity, cache.nextTickToCross) = Ticks.cross(
396                         ticks,
397                         cache.nextTickToCross,
398                         secondsPerLiquidity,
399                         cache.currentLiquidity,
400                         cache.feeGrowthGlobal,
401                         zeroForOne
402                     );
403                 }
404             }
405         }
406 
407         price = uint160(cache.currentPrice);
408 
409         int24 newNearestTick = zeroForOne ? cache.nextTickToCross : ticks[cache.nextTickToCross].previousTick;
410 
411         if (nearestTick != newNearestTick) {
412             nearestTick = newNearestTick;
413             liquidity = uint128(cache.currentLiquidity);
414         }
415 
416         _updateReserves(zeroForOne, uint128(inAmount), amountOut);
417 
418         _updateFees(zeroForOne, cache.feeGrowthGlobal, uint128(cache.protocolFee));
419 
420         if (zeroForOne) {
421             _transfer(token1, amountOut, recipient, unwrapBento);
422             emit Swap(recipient, token0, token1, inAmount, amountOut);
423         } else {
424             _transfer(token0, amountOut, recipient, unwrapBento);
425             emit Swap(recipient, token1, token0, inAmount, amountOut);
426         }
427     }
428 
429     function flashSwap(bytes calldata) public override returns (uint256) {
430         revert();
431     }
432 
433     function updateBarFee() public {
434         barFee = IMasterDeployer(masterDeployer).barFee();
435     }
436 
437     function collectProtocolFee() public lock returns (uint128 amount0, uint128 amount1) {
438         if (token0ProtocolFee > 1) {
439             amount0 = token0ProtocolFee - 1;
440             token0ProtocolFee = 1;
441             reserve0 -= amount0;
442             _transfer(token0, amount0, barFeeTo, false);
443         }
444         if (token1ProtocolFee > 1) {
445             amount1 = token1ProtocolFee - 1;
446             token1ProtocolFee = 1;
447             reserve1 -= amount1;
448             _transfer(token1, amount1, barFeeTo, false);
449         }
450     }
451 
452     function _ensureTickSpacing(int24 lower, int24 upper) internal view {
453         require(lower % int24(tickSpacing) == 0, "INVALID_TICK");
454         require((lower / int24(tickSpacing)) % 2 == 0, "LOWER_EVEN");
455 
456         require(upper % int24(tickSpacing) == 0, "INVALID_TICK");
457         require((upper / int24(tickSpacing)) % 2 != 0, "UPPER_ODD"); /// @dev Can be either -1 or 1.
458     }
459 
460     function _getAmountsForLiquidity(
461         uint256 priceLower,
462         uint256 priceUpper,
463         uint256 currentPrice,
464         uint256 liquidityAmount
465     ) internal pure returns (uint128 token0amount, uint128 token1amount) {
466         if (priceUpper <= currentPrice) {
467 
468             token1amount = uint128(DyDxMath.getDy(liquidityAmount, priceLower, priceUpper, true));
469         } else if (currentPrice <= priceLower) {
470 
471             token0amount = uint128(DyDxMath.getDx(liquidityAmount, priceLower, priceUpper, true));
472         } else {
473 
474             token0amount = uint128(DyDxMath.getDx(liquidityAmount, currentPrice, priceUpper, true));
475             token1amount = uint128(DyDxMath.getDy(liquidityAmount, priceLower, currentPrice, true));
476         }
477     }
478 
479     function _updateReserves(
480         bool zeroForOne,
481         uint128 inAmount,
482         uint256 amountOut
483     ) internal {
484         if (zeroForOne) {
485             uint256 balance0 = _balance(token0);
486             uint128 newBalance = reserve0 + inAmount;
487             require(uint256(newBalance) <= balance0, "TOKEN0_MISSING");
488             reserve0 = newBalance;
489             reserve1 -= uint128(amountOut);
490         } else {
491             uint256 balance1 = _balance(token1);
492             uint128 newBalance = reserve1 + inAmount;
493             require(uint256(newBalance) <= balance1, "TOKEN1_MISSING");
494             reserve1 = newBalance;
495             reserve0 -= uint128(amountOut);
496         }
497     }
498 
499     function _updateFees(
500         bool zeroForOne,
501         uint256 feeGrowthGlobal,
502         uint128 protocolFee
503     ) internal {
504         if (zeroForOne) {
505             feeGrowthGlobal1 = feeGrowthGlobal;
506             token1ProtocolFee += protocolFee;
507         } else {
508             feeGrowthGlobal0 = feeGrowthGlobal;
509             token0ProtocolFee += protocolFee;
510         }
511     }
512 
513     function _updatePosition(
514         address owner,
515         int24 lower,
516         int24 upper,
517         int128 amount
518     ) internal returns (uint256 amount0fees, uint256 amount1fees) {
519         Position storage position = positions[owner][lower][upper];
520 
521         (uint256 growth0current, uint256 growth1current) = rangeFeeGrowth(lower, upper);
522         amount0fees = FullMath.mulDiv(
523             growth0current - position.feeGrowthInside0Last,
524             position.liquidity,
525             0x100000000000000000000000000000000
526         );
527 
528         amount1fees = FullMath.mulDiv(
529             growth1current - position.feeGrowthInside1Last,
530             position.liquidity,
531             0x100000000000000000000000000000000
532         );
533 
534         if (amount < 0) position.liquidity -= uint128(-amount);
535         if (amount > 0) position.liquidity += uint128(amount);
536 
537         require(position.liquidity < MAX_TICK_LIQUIDITY, "MAX_TICK_LIQUIDITY");
538 
539         position.feeGrowthInside0Last = growth0current;
540         position.feeGrowthInside1Last = growth1current;
541     }
542 
543     function _balance(address token) internal view returns (uint256 balance) {
544         balance = bento.balanceOf(token, address(this));
545     }
546 
547     function _transfer(
548         address token,
549         uint256 shares,
550         address to,
551         bool unwrapBento
552     ) internal {
553         if (unwrapBento) {
554             bento.withdraw(token, address(this), to, 0, shares);
555         } else {
556             bento.transfer(token, address(this), to, shares);
557         }
558     }
559 
560     function _transferBothTokens(
561         address to,
562         uint256 shares0,
563         uint256 shares1,
564         bool unwrapBento
565     ) internal {
566         if (unwrapBento) {
567             bento.withdraw(token0, address(this), to, 0, shares0);
568             bento.withdraw(token1, address(this), to, 0, shares1);
569         } else {
570             bento.transfer(token0, address(this), to, shares0);
571             bento.transfer(token1, address(this), to, shares1);
572         }
573     }
574 
575     function rangeFeeGrowth(int24 lowerTick, int24 upperTick) public view returns (uint256 feeGrowthInside0, uint256 feeGrowthInside1) {
576         int24 currentTick = nearestTick;
577 
578         Ticks.Tick storage lower = ticks[lowerTick];
579         Ticks.Tick storage upper = ticks[upperTick];
580 
581         uint256 _feeGrowthGlobal0 = feeGrowthGlobal0;
582         uint256 _feeGrowthGlobal1 = feeGrowthGlobal1;
583         uint256 feeGrowthBelow0;
584         uint256 feeGrowthBelow1;
585         uint256 feeGrowthAbove0;
586         uint256 feeGrowthAbove1;
587 
588         if (lowerTick <= currentTick) {
589             feeGrowthBelow0 = lower.feeGrowthOutside0;
590             feeGrowthBelow1 = lower.feeGrowthOutside1;
591         } else {
592             feeGrowthBelow0 = _feeGrowthGlobal0 - lower.feeGrowthOutside0;
593             feeGrowthBelow1 = _feeGrowthGlobal1 - lower.feeGrowthOutside1;
594         }
595 
596         if (currentTick < upperTick) {
597             feeGrowthAbove0 = upper.feeGrowthOutside0;
598             feeGrowthAbove1 = upper.feeGrowthOutside1;
599         } else {
600             feeGrowthAbove0 = _feeGrowthGlobal0 - upper.feeGrowthOutside0;
601             feeGrowthAbove1 = _feeGrowthGlobal1 - upper.feeGrowthOutside1;
602         }
603 
604         feeGrowthInside0 = _feeGrowthGlobal0 - feeGrowthBelow0 - feeGrowthAbove0;
605         feeGrowthInside1 = _feeGrowthGlobal1 - feeGrowthBelow1 - feeGrowthAbove1;
606     }
607 
608     function rangeSecondsInside(int24 lowerTick, int24 upperTick) public view returns (uint256 secondsInside) {
609         int24 currentTick = nearestTick;
610 
611         Ticks.Tick storage lower = ticks[lowerTick];
612         Ticks.Tick storage upper = ticks[upperTick];
613 
614         uint256 secondsGlobal = secondsPerLiquidity;
615         uint256 secondsBelow;
616         uint256 secondsAbove;
617 
618         if (lowerTick <= currentTick) {
619             secondsBelow = lower.secondsPerLiquidityOutside;
620         } else {
621             secondsBelow = secondsGlobal - lower.secondsPerLiquidityOutside;
622         }
623 
624         if (currentTick < upperTick) {
625             secondsAbove = upper.secondsPerLiquidityOutside;
626         } else {
627             secondsAbove = secondsGlobal - upper.secondsPerLiquidityOutside;
628         }
629 
630         secondsInside = secondsGlobal - secondsBelow - secondsAbove;
631     }
632 
633     function getAssets() public view override returns (address[] memory assets) {
634         assets = new address[](2);
635         assets[0] = token0;
636         assets[1] = token1;
637     }
638 
639     /// @dev Reserved for IPool.
640     function getAmountOut(bytes calldata) public pure override returns (uint256) {
641         revert();
642     }
643 
644     function getImmutables()
645         public
646         view
647         returns (
648             uint128 _MAX_TICK_LIQUIDITY,
649             uint24 _tickSpacing,
650             uint24 _swapFee,
651             address _barFeeTo,
652             IBentoBoxMinimal _bento,
653             IMasterDeployer _masterDeployer,
654             address _token0,
655             address _token1
656         )
657     {
658         _MAX_TICK_LIQUIDITY = MAX_TICK_LIQUIDITY;
659         _tickSpacing = tickSpacing;
660         _swapFee = swapFee; 
661         _barFeeTo = barFeeTo;
662         _bento = bento;
663         _masterDeployer = masterDeployer;
664         _token0 = token0;
665         _token1 = token1;
666     }
667 
668     function getPriceAndNearestTicks() public view returns (uint160 _price, int24 _nearestTick) {
669         _price = price;
670         _nearestTick = nearestTick;
671     }
672 
673     function getTokenProtocolFees() public view returns (uint128 _token0ProtocolFee, uint128 _token1ProtocolFee) {
674         _token0ProtocolFee = token0ProtocolFee;
675         _token1ProtocolFee = token1ProtocolFee;
676     }
677 
678     function getReserves() public view returns (uint128 _reserve0, uint128 _reserve1) {
679         _reserve0 = reserve0;
680         _reserve1 = reserve1;
681     }
682 
683     function getLiquidityAndLastObservation() public view returns (uint160 _secondsPerLiquidity, uint32 _lastObservation) {
684         _secondsPerLiquidity = secondsPerLiquidity;
685         _lastObservation = lastObservation;
686     }
687 }