1 // SPDX-License-Identifier: BUSL-1.1
2 pragma solidity 0.8.19;
3 import { Initializable } from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
4 import { EnumerableSetUpgradeable } from "@openzeppelin/contracts-upgradeable/utils/structs/EnumerableSetUpgradeable.sol";
5 import { MathUpgradeable } from "@openzeppelin/contracts-upgradeable/utils/math/MathUpgradeable.sol";
6 import { SafeCastUpgradeable } from "@openzeppelin/contracts-upgradeable/utils/math/SafeCastUpgradeable.sol";
7 import { Address } from "@openzeppelin/contracts/utils/Address.sol";
8 import { MathEx } from "../utility/MathEx.sol";
9 import { Token } from "../token/Token.sol";
10 import { TokenLibrary } from "../token/TokenLibrary.sol";
11 import { Pool } from "./Pools.sol";
12 import { IVoucher } from "../voucher/interfaces/IVoucher.sol";
13 import { PPM_RESOLUTION } from "../utility/Constants.sol";
14 import { MAX_GAP } from "../utility/Constants.sol";
15 
16 /**
17  * @dev:
18  *
19  * a strategy consists of two orders:
20  * - order 0 sells `y0` units of token 0 at a marginal rate `M0` ranging between `L0` and `H0`
21  * - order 1 sells `y1` units of token 1 at a marginal rate `M1` ranging between `L1` and `H1`
22  *
23  * rate symbols:
24  * - `L0` indicates the lowest value of one wei of token 0 in units of token 1
25  * - `H0` indicates the highest value of one wei of token 0 in units of token 1
26  * - `M0` indicates the marginal value of one wei of token 0 in units of token 1
27  * - `L1` indicates the lowest value of one wei of token 1 in units of token 0
28  * - `H1` indicates the highest value of one wei of token 1 in units of token 0
29  * - `M1` indicates the marginal value of one wei of token 1 in units of token 0
30  *
31  * the term "one wei" serves here as a simplification of "an amount tending to zero",
32  * hence the rate values above are all theoretical.
33  * moreover, since trade calculation is based on the square roots of the rates,
34  * an order doesn't actually hold the rate values, but a modified version of them.
35  * for each rate `r`, the order maintains:
36  * - mantissa: the value of the 48 most significant bits of `floor(sqrt(r) * 2 ^ 48)`
37  * - exponent: the number of the remaining (least significant) bits, limited up to 48
38  * this allows for rates between ~12.6e-28 and ~7.92e+28, at an average resolution of ~2.81e+14.
39  * it also ensures that every rate value `r` is supported if and only if `1 / r` is supported.
40  * however, it also yields a certain degree of accuracy loss as soon as the order is created.
41  *
42  * encoding / decoding scheme:
43  * - `b(x) = bit-length of x`
44  * - `c(x) = max(b(x) - 48, 0)`
45  * - `f(x) = floor(sqrt(x) * (1 << 48))`
46  * - `g(x) = f(x) >> c(f(x)) << c(f(x))`
47  * - `e(x) = (x >> c(x)) | (c(x) << 48)`
48  * - `d(x) = (x & ((1 << 48) - 1)) << (x >> 48)`
49  *
50  * let the following denote:
51  * - `L = g(lowest rate)`
52  * - `H = g(highest rate)`
53  * - `M = g(marginal rate)`
54  *
55  * then the order maintains:
56  * - `y = current liquidity`
57  * - `z = current liquidity * (H - L) / (M - L)`
58  * - `A = e(H - L)`
59  * - `B = e(L)`
60  *
61  * and the order reflects:
62  * - `L = d(B)`
63  * - `H = d(B + A)`
64  * - `M = d(B + A * y / z)`
65  *
66  * upon trading on a given order in a given strategy:
67  * - the value of `y` in the given order decreases
68  * - the value of `y` in the other order increases
69  * - the value of `z` in the other order may increase
70  * - the values of all other parameters remain unchanged
71  *
72  * given a source amount `x`, the expected target amount is:
73  * - theoretical formula: `M ^ 2 * x * y / (M * (M - L) * x + y)`
74  * - implemented formula: `x * (A * y + B * z) ^ 2 / (A * x * (A * y + B * z) + z ^ 2)`
75  *
76  * given a target amount `x`, the required source amount is:
77  * - theoretical formula: `x * y / (M * (L - M) * x + M ^ 2 * y)`
78  * - implemented formula: `x * z ^ 2 / ((A * y + B * z) * (A * y + B * z - A * x))`
79  *
80  * fee scheme:
81  * +-------------------+---------------------------------+---------------------------------+
82  * | trade function    | trader transfers to contract    | contract transfers to trader    |
83  * +-------------------+---------------------------------+---------------------------------+
84  * | bySourceAmount(x) | trader transfers to contract: x | p = expectedTargetAmount(x)     |
85  * |                   |                                 | q = p * (100 - fee%) / 100      |
86  * |                   |                                 | contract transfers to trader: q |
87  * |                   |                                 | contract retains as fee: p - q  |
88  * +-------------------+---------------------------------+---------------------------------+
89  * | byTargetAmount(x) | p = requiredSourceAmount(x)     | contract transfers to trader: x |
90  * |                   | q = p * 100 / (100 - fee%)      |                                 |
91  * |                   | trader transfers to contract: q |                                 |
92  * |                   | contract retains as fee: q - p  |                                 |
93  * +-------------------+---------------------------------+---------------------------------+
94  */
95 
96 // solhint-disable var-name-mixedcase
97 struct Order {
98     uint128 y;
99     uint128 z;
100     uint64 A;
101     uint64 B;
102 }
103 // solhint-enable var-name-mixedcase
104 
105 struct TradeTokens {
106     Token source;
107     Token target;
108 }
109 
110 struct Strategy {
111     uint256 id;
112     address owner;
113     Token[2] tokens;
114     Order[2] orders;
115 }
116 
117 struct TradeAction {
118     uint256 strategyId;
119     uint128 amount;
120 }
121 
122 abstract contract Strategies is Initializable {
123     using EnumerableSetUpgradeable for EnumerableSetUpgradeable.UintSet;
124     using TokenLibrary for Token;
125     using Address for address payable;
126     using MathUpgradeable for uint256;
127     using SafeCastUpgradeable for uint256;
128 
129     error NativeAmountMismatch();
130     error GreaterThanMaxInput();
131     error LowerThanMinReturn();
132     error InvalidIndices();
133     error InsufficientCapacity();
134     error InvalidRate();
135     error InsufficientLiquidity();
136     error TokensMismatch();
137     error StrategyDoesNotExist();
138     error OutDated();
139 
140     struct SourceAndTargetAmounts {
141         uint128 sourceAmount;
142         uint128 targetAmount;
143     }
144 
145     struct TradeParams {
146         address trader;
147         TradeTokens tokens;
148         bool byTargetAmount;
149         uint128 constraint;
150         uint256 txValue;
151         Pool pool;
152     }
153 
154     struct TradeOrders {
155         uint256[3] packedOrders;
156         Order[2] orders;
157     }
158 
159     uint256 private constant ONE = 1 << 48;
160 
161     uint32 private constant DEFAULT_TRADING_FEE_PPM = 2000; // 0.2%
162 
163     // total number of strategies
164     uint256 private _strategyCounter;
165 
166     // mapping between a strategy to its packed orders
167     mapping(uint256 => uint256[3]) private _packedOrdersByStrategyId;
168 
169     // mapping between a pool id to its strategies ids
170     mapping(uint256 => EnumerableSetUpgradeable.UintSet) private _strategiesByPoolIdStorage;
171 
172     // the global trading fee (in units of PPM)
173     uint32 private _tradingFeePPM;
174 
175     // accumulated fees per token
176     mapping(address => uint256) private _accumulatedFees;
177 
178     // upgrade forward-compatibility storage gap
179     uint256[MAX_GAP - 5] private __gap;
180 
181     /**
182      * @dev triggered when the network fee is updated
183      */
184     event TradingFeePPMUpdated(uint32 prevFeePPM, uint32 newFeePPM);
185 
186     /**
187      * @dev emits following a pool's creation
188      */
189     event StrategyCreated(
190         uint256 id,
191         address indexed owner,
192         Token indexed token0,
193         Token indexed token1,
194         Order order0,
195         Order order1
196     );
197 
198     /**
199      * @dev emits following a pool's creation
200      */
201     event StrategyDeleted(
202         uint256 id,
203         address indexed owner,
204         Token indexed token0,
205         Token indexed token1,
206         Order order0,
207         Order order1
208     );
209 
210     /**
211      * @dev emits following an update to either or both of the orders
212      */
213     event StrategyUpdated(uint256 indexed id, Token indexed token0, Token indexed token1, Order order0, Order order1);
214 
215     /**
216      * @dev emits following a user initiated trade
217      */
218     event TokensTraded(
219         address indexed trader,
220         address indexed sourceToken,
221         address indexed targetToken,
222         uint256 sourceAmount,
223         uint256 targetAmount,
224         uint128 tradingFeeAmount,
225         bool byTargetAmount
226     );
227 
228     // solhint-disable func-name-mixedcase
229     /**
230      * @dev initializes the contract and its parents
231      */
232     function __Strategies_init() internal onlyInitializing {
233         __Strategies_init_unchained();
234     }
235 
236     /**
237      * @dev performs contract-specific initialization
238      */
239     function __Strategies_init_unchained() internal onlyInitializing {
240         _setTradingFeePPM(DEFAULT_TRADING_FEE_PPM);
241     }
242 
243     // solhint-enable func-name-mixedcase
244 
245     /**
246      * @dev creates a new strategy
247      */
248     function _createStrategy(
249         IVoucher voucher,
250         Token[2] memory tokens,
251         Order[2] calldata orders,
252         Pool memory pool,
253         address owner,
254         uint256 value
255     ) internal returns (uint256) {
256         // transfer funds
257         _validateDepositAndRefundExcessNativeToken(tokens[0], owner, orders[0].y, value);
258         _validateDepositAndRefundExcessNativeToken(tokens[1], owner, orders[1].y, value);
259 
260         // store id
261         _strategyCounter++;
262         uint256 id = _strategyId(pool.id, _strategyCounter);
263         _strategiesByPoolIdStorage[pool.id].add(id);
264 
265         // store orders
266         bool ordersInverted = tokens[0] == pool.tokens[1];
267         _packedOrdersByStrategyId[id] = _packOrders(orders, ordersInverted);
268 
269         // mint voucher
270         voucher.mint(owner, id);
271 
272         // emit event
273         emit StrategyCreated({
274             id: id,
275             owner: owner,
276             token0: tokens[0],
277             token1: tokens[1],
278             order0: orders[0],
279             order1: orders[1]
280         });
281 
282         return id;
283     }
284 
285     /**
286      * @dev updates an existing strategy
287      */
288     function _updateStrategy(
289         uint256 strategyId,
290         Pool memory pool,
291         Order[2] calldata currentOrders,
292         Order[2] calldata newOrders,
293         uint256 value,
294         address owner
295     ) internal {
296         // prepare storage variable
297         uint256[3] storage packedOrders = _packedOrdersByStrategyId[strategyId];
298         uint256[3] memory packedOrdersMemory = _packedOrdersByStrategyId[strategyId];
299         (Order[2] memory orders, bool ordersInverted) = _unpackOrders(packedOrdersMemory);
300 
301         // revert if the strategy mutated since this tx was sent
302         if (!_equalStrategyOrders(currentOrders, orders)) {
303             revert OutDated();
304         }
305 
306         // store new values if necessary
307         uint256[3] memory newPackedOrders = _packOrders(newOrders, ordersInverted);
308         for (uint256 n = 0; n < 3; n++) {
309             if (packedOrdersMemory[n] != newPackedOrders[n]) {
310                 packedOrders[n] = newPackedOrders[n];
311             }
312         }
313 
314         // deposit and withdraw
315         Token[2] memory sortedTokens = _sortStrategyTokens(pool, ordersInverted);
316         for (uint256 i = 0; i < 2; i++) {
317             Token token = sortedTokens[i];
318             if (newOrders[i].y < orders[i].y) {
319                 // liquidity decreased - withdraw the difference
320                 uint128 delta = orders[i].y - newOrders[i].y;
321                 _withdrawFunds(token, payable(owner), delta);
322             } else if (newOrders[i].y > orders[i].y) {
323                 // liquidity increased - deposit the difference
324                 uint128 delta = newOrders[i].y - orders[i].y;
325                 _validateDepositAndRefundExcessNativeToken(token, owner, delta, value);
326             }
327         }
328 
329         // emit event
330         emit StrategyUpdated({
331             id: strategyId,
332             token0: sortedTokens[0],
333             token1: sortedTokens[1],
334             order0: newOrders[0],
335             order1: newOrders[1]
336         });
337     }
338 
339     /**
340      * @dev deletes a strategy
341      */
342     function _deleteStrategy(Strategy memory strategy, IVoucher voucher, Pool memory pool) internal {
343         // burn the voucher nft token
344         voucher.burn(strategy.id);
345 
346         // clear storage
347         delete _packedOrdersByStrategyId[strategy.id];
348         _strategiesByPoolIdStorage[pool.id].remove(strategy.id);
349 
350         // withdraw funds
351         _withdrawFunds(strategy.tokens[0], payable(strategy.owner), strategy.orders[0].y);
352         _withdrawFunds(strategy.tokens[1], payable(strategy.owner), strategy.orders[1].y);
353 
354         // emit event
355         emit StrategyDeleted({
356             id: strategy.id,
357             owner: strategy.owner,
358             token0: strategy.tokens[0],
359             token1: strategy.tokens[1],
360             order0: strategy.orders[0],
361             order1: strategy.orders[1]
362         });
363     }
364 
365     /**
366      * @dev perform trade, update affected strategies
367      *
368      * requirements:
369      *
370      * - the caller must have approved the source token
371      */
372     function _trade(
373         TradeAction[] calldata tradeActions,
374         TradeParams memory params
375     ) internal returns (SourceAndTargetAmounts memory totals) {
376         // process trade actions
377         for (uint256 i = 0; i < tradeActions.length; i++) {
378             // prepare variables
379             uint256 strategyId = tradeActions[i].strategyId;
380             uint256[3] storage packedOrders = _packedOrdersByStrategyId[strategyId];
381             uint256[3] memory packedOrdersMemory = _packedOrdersByStrategyId[strategyId];
382             (Order[2] memory orders, bool ordersInverted) = _unpackOrders(packedOrdersMemory);
383 
384             // make sure strategyIds match the provided source/target tokens
385             if (_poolIdbyStrategyId(strategyId) != params.pool.id) {
386                 revert TokensMismatch();
387             }
388 
389             // calculate the orders new values
390             uint256 targetTokenIndex = _findTargetOrderIndex(params.pool, params.tokens, ordersInverted);
391 
392             Order memory targetOrder = orders[targetTokenIndex];
393             Order memory sourceOrder = orders[1 - targetTokenIndex];
394 
395             SourceAndTargetAmounts memory tempTradeAmounts = _singleTradeActionSourceAndTargetAmounts(
396                 targetOrder,
397                 tradeActions[i].amount,
398                 params.byTargetAmount
399             );
400 
401             // update the orders with the new values
402             targetOrder.y -= tempTradeAmounts.targetAmount;
403             sourceOrder.y += tempTradeAmounts.sourceAmount;
404             if (sourceOrder.z < sourceOrder.y) {
405                 sourceOrder.z = sourceOrder.y;
406             }
407 
408             // store new values if necessary
409             uint256[3] memory newPackedOrders = _packOrders(orders, ordersInverted);
410             for (uint256 n = 0; n < 3; n++) {
411                 if (packedOrdersMemory[n] != newPackedOrders[n]) {
412                     packedOrders[n] = newPackedOrders[n];
413                 }
414             }
415 
416             // emit update events if necessary
417             Token[2] memory sortedTokens = _sortStrategyTokens(params.pool, ordersInverted);
418             emit StrategyUpdated({
419                 id: strategyId,
420                 token0: sortedTokens[0],
421                 token1: sortedTokens[1],
422                 order0: orders[0],
423                 order1: orders[1]
424             });
425 
426             totals.sourceAmount += tempTradeAmounts.sourceAmount;
427             totals.targetAmount += tempTradeAmounts.targetAmount;
428         }
429 
430         // apply trading fee
431         uint128 tradingFeeAmount;
432         address tradingFeeToken;
433         if (params.byTargetAmount) {
434             uint128 amountIncludingFee = _addFee(totals.sourceAmount);
435             tradingFeeAmount = amountIncludingFee - totals.sourceAmount;
436             tradingFeeToken = address(params.tokens.source);
437             totals.sourceAmount = amountIncludingFee;
438             if (totals.sourceAmount > params.constraint) {
439                 revert GreaterThanMaxInput();
440             }
441         } else {
442             uint128 amountIncludingFee = _subtractFee(totals.targetAmount);
443             tradingFeeAmount = totals.targetAmount - amountIncludingFee;
444             tradingFeeToken = address(params.tokens.target);
445             totals.targetAmount = amountIncludingFee;
446             if (totals.targetAmount < params.constraint) {
447                 revert LowerThanMinReturn();
448             }
449         }
450 
451         // transfer funds
452         _validateDepositAndRefundExcessNativeToken(
453             params.tokens.source,
454             params.trader,
455             totals.sourceAmount,
456             params.txValue
457         );
458         _withdrawFunds(params.tokens.target, payable(params.trader), totals.targetAmount);
459 
460         // update fee counters
461         _accumulatedFees[tradingFeeToken] += tradingFeeAmount;
462 
463         // tokens traded sucesfully, emit event
464         emit TokensTraded({
465             trader: params.trader,
466             sourceToken: address(params.tokens.source),
467             targetToken: address(params.tokens.target),
468             sourceAmount: totals.sourceAmount,
469             targetAmount: totals.targetAmount,
470             tradingFeeAmount: tradingFeeAmount,
471             byTargetAmount: params.byTargetAmount
472         });
473 
474         return totals;
475     }
476 
477     /**
478      * @dev calculates the required amount plus fee
479      */
480     function _addFee(uint128 amount) private view returns (uint128) {
481         // divide the input amount by `1 - fee`
482         return MathEx.mulDivC(amount, PPM_RESOLUTION, PPM_RESOLUTION - _tradingFeePPM).toUint128();
483     }
484 
485     /**
486      * @dev calculates the expected amount minus fee
487      */
488     function _subtractFee(uint128 amount) private view returns (uint128) {
489         // multiply the input amount by `1 - fee`
490         return MathEx.mulDivF(amount, PPM_RESOLUTION - _tradingFeePPM, PPM_RESOLUTION).toUint128();
491     }
492 
493     /**
494      * @dev returns the index of a trade's target token in a strategy
495      */
496     function _findTargetOrderIndex(
497         Pool memory pool,
498         TradeTokens memory tokens,
499         bool ordersInverted
500     ) private pure returns (uint256) {
501         uint256 index = tokens.target == pool.tokens[0] ? 0 : 1;
502         if (ordersInverted) {
503             index = 1 - index;
504         }
505         return index;
506     }
507 
508     /**
509      * @dev calculates and returns the total source and target amounts of a trade, including fees
510      */
511     function _tradeSourceAndTargetAmounts(
512         TradeTokens memory tokens,
513         TradeAction[] calldata tradeActions,
514         Pool memory pool,
515         bool byTargetAmount
516     ) internal view returns (SourceAndTargetAmounts memory totals) {
517         // process trade actions
518         for (uint256 i = 0; i < tradeActions.length; i++) {
519             // prepare variables
520             uint256[3] memory packedOrdersMemory = _packedOrdersByStrategyId[tradeActions[i].strategyId];
521             (Order[2] memory orders, bool ordersInverted) = _unpackOrders(packedOrdersMemory);
522 
523             // calculate the orders new values
524             uint256 targetTokenIndex = _findTargetOrderIndex(pool, tokens, ordersInverted);
525             SourceAndTargetAmounts memory tempTradeAmounts = _singleTradeActionSourceAndTargetAmounts(
526                 orders[targetTokenIndex],
527                 tradeActions[i].amount,
528                 byTargetAmount
529             );
530 
531             // update totals
532             totals.sourceAmount += tempTradeAmounts.sourceAmount;
533             totals.targetAmount += tempTradeAmounts.targetAmount;
534         }
535 
536         // apply trading fee
537         if (byTargetAmount) {
538             totals.sourceAmount = _addFee(totals.sourceAmount);
539         } else {
540             totals.targetAmount = _subtractFee(totals.targetAmount);
541         }
542     }
543 
544     /**
545      * @dev returns stored strategies of a pool
546      */
547     function _strategiesByPool(
548         Pool memory pool,
549         uint256 startIndex,
550         uint256 endIndex,
551         IVoucher voucher
552     ) internal view returns (Strategy[] memory) {
553         EnumerableSetUpgradeable.UintSet storage strategyIds = _strategiesByPoolIdStorage[pool.id];
554         uint256 allLength = strategyIds.length();
555 
556         // when the endIndex is 0 or out of bound, set the endIndex to the last value possible
557         if (endIndex == 0 || endIndex > allLength) {
558             endIndex = allLength;
559         }
560 
561         // revert when startIndex is out of bound
562         if (startIndex > endIndex) {
563             revert InvalidIndices();
564         }
565 
566         // populate the result
567         uint256 resultLength = endIndex - startIndex;
568         Strategy[] memory result = new Strategy[](resultLength);
569         for (uint256 i = 0; i < resultLength; i++) {
570             uint256 strategyId = strategyIds.at(startIndex + i);
571             result[i] = _strategy(strategyId, voucher, pool);
572         }
573 
574         return result;
575     }
576 
577     /**
578      * @dev returns the count of stored strategies of a pool
579      */
580     function _strategiesByPoolCount(Pool memory pool) internal view returns (uint256) {
581         EnumerableSetUpgradeable.UintSet storage strategyIds = _strategiesByPoolIdStorage[pool.id];
582         return strategyIds.length();
583     }
584 
585     /**
586      @dev retuns a strategy object matching the provided id.
587      */
588     function _strategy(uint256 id, IVoucher voucher, Pool memory pool) internal view returns (Strategy memory) {
589         // fetch data
590         address _owner = voucher.ownerOf(id);
591         uint256[3] memory packedOrdersMemory = _packedOrdersByStrategyId[id];
592         (Order[2] memory _orders, bool ordersInverted) = _unpackOrders(packedOrdersMemory);
593 
594         // handle sorting
595         Token[2] memory sortedTokens = _sortStrategyTokens(pool, ordersInverted);
596 
597         return Strategy({ id: id, owner: _owner, tokens: sortedTokens, orders: _orders });
598     }
599 
600     /**
601      * @dev validates deposit amounts, refunds excess native tokens sent
602      */
603     function _validateDepositAndRefundExcessNativeToken(
604         Token token,
605         address owner,
606         uint256 depositAmount,
607         uint256 txValue
608     ) private {
609         if (depositAmount == 0) {
610             return;
611         }
612 
613         if (token.isNative()) {
614             if (txValue < depositAmount) {
615                 revert NativeAmountMismatch();
616             }
617 
618             // refund the owner for the remaining native token amount
619             if (txValue > depositAmount) {
620                 payable(address(owner)).sendValue(txValue - depositAmount);
621             }
622         } else {
623             token.safeTransferFrom(owner, address(this), depositAmount);
624         }
625     }
626 
627     /**
628      * @dev sets the trading fee (in units of PPM)
629      */
630     function _setTradingFeePPM(uint32 newTradingFeePPM) internal {
631         uint32 prevTradingFeePPM = _tradingFeePPM;
632         if (prevTradingFeePPM == newTradingFeePPM) {
633             return;
634         }
635 
636         _tradingFeePPM = newTradingFeePPM;
637 
638         emit TradingFeePPMUpdated({ prevFeePPM: prevTradingFeePPM, newFeePPM: newTradingFeePPM });
639     }
640 
641     /**
642      * returns the current trading fee
643      */
644     function _currentTradingFeePPM() internal view returns (uint32) {
645         return _tradingFeePPM;
646     }
647 
648     /**
649      * returns the current amount of accumulated fees for a specific token
650      */
651     function _getAccumulatedFees(address token) internal view returns (uint256) {
652         return _accumulatedFees[token];
653     }
654 
655     /**
656      * returns true if the provided orders are equal, false otherwise
657      */
658     function _equalStrategyOrders(Order[2] memory orders0, Order[2] memory orders1) internal pure returns (bool) {
659         uint256 i;
660         for (i = 0; i < 2; i++) {
661             if (
662                 orders0[i].y != orders1[i].y ||
663                 orders0[i].z != orders1[i].z ||
664                 orders0[i].A != orders1[i].A ||
665                 orders0[i].B != orders1[i].B
666             ) {
667                 return false;
668             }
669         }
670         return true;
671     }
672 
673     // solhint-disable var-name-mixedcase
674 
675     /**
676      * @dev returns:
677      *
678      *      x * (A * y + B * z) ^ 2
679      * ---------------------------------
680      *  A * x * (A * y + B * z) + z ^ 2
681      *
682      */
683     function _calculateTradeTargetAmount(
684         uint256 x,
685         uint256 y,
686         uint256 z,
687         uint256 A,
688         uint256 B
689     ) private pure returns (uint256) {
690         if (A == 0) {
691             return MathEx.mulDivF(x, B * B, ONE * ONE);
692         }
693 
694         uint256 temp1 = z * ONE;
695         uint256 temp2 = y * A + z * B;
696         uint256 temp3 = temp2 * x;
697 
698         uint256 factor1 = MathEx.mulDivC(temp1, temp1, type(uint256).max);
699         uint256 factor2 = MathEx.mulDivC(temp3, A, type(uint256).max);
700         uint256 factor = MathUpgradeable.max(factor1, factor2);
701 
702         uint256 temp4 = MathEx.mulDivC(temp1, temp1, factor);
703         uint256 temp5 = MathEx.mulDivC(temp3, A, factor);
704         return MathEx.mulDivF(temp2, temp3 / factor, temp4 + temp5);
705     }
706 
707     /**
708      * @dev returns:
709      *
710      *                  x * z ^ 2
711      * -------------------------------------------
712      *  (A * y + B * z) * (A * y + B * z - A * x)
713      *
714      */
715     function _calculateTradeSourceAmount(
716         uint256 x,
717         uint256 y,
718         uint256 z,
719         uint256 A,
720         uint256 B
721     ) private pure returns (uint256) {
722         if (A == 0) {
723             return MathEx.mulDivC(x, ONE * ONE, B * B);
724         }
725 
726         uint256 temp1 = z * ONE;
727         uint256 temp2 = y * A + z * B;
728         uint256 temp3 = temp2 - x * A;
729 
730         uint256 factor1 = MathEx.mulDivC(temp1, temp1, type(uint256).max);
731         uint256 factor2 = MathEx.mulDivC(temp2, temp3, type(uint256).max);
732         uint256 factor = MathUpgradeable.max(factor1, factor2);
733 
734         uint256 temp4 = MathEx.mulDivC(temp1, temp1, factor);
735         uint256 temp5 = MathEx.mulDivF(temp2, temp3, factor);
736         return MathEx.mulDivC(x, temp4, temp5);
737     }
738 
739     // solhint-enable var-name-mixedcase
740 
741     /**
742      * @dev pack 2 orders into a 3 slot uint256 data structure
743      */
744     function _packOrders(Order[2] memory orders, bool ordersInverted) private pure returns (uint256[3] memory) {
745         return [
746             uint256((uint256(orders[0].y) << 0) | (uint256(orders[1].y) << 128)),
747             uint256((uint256(orders[0].z) << 0) | (uint256(orders[0].A) << 128) | (uint256(orders[0].B) << 192)),
748             uint256(
749                 (uint256(orders[1].z) << 0) |
750                     (uint256(orders[1].A) << 128) |
751                     (uint256(orders[1].B) << 192) |
752                     (_booleanToNumber(ordersInverted) << 255)
753             )
754         ];
755     }
756 
757     /**
758      * @dev unpack 2 stored orders into an array of Order types
759      */
760     function _unpackOrders(
761         uint256[3] memory values
762     ) private pure returns (Order[2] memory orders, bool ordersInverted) {
763         if (values[0] == 0 && values[1] == 0 && values[2] == 0) {
764             revert StrategyDoesNotExist();
765         }
766         orders = [
767             Order({
768                 y: uint128(values[0] >> 0),
769                 z: uint128(values[1] >> 0),
770                 A: uint64(values[1] >> 128),
771                 B: uint64(values[1] >> 192)
772             }),
773             Order({
774                 y: uint128(values[0] >> 128),
775                 z: uint128(values[2] >> 0),
776                 A: uint64(values[2] >> 128),
777                 B: uint64((values[2] << 1) >> 193)
778             })
779         ];
780         ordersInverted = _numberToBoolean(values[2] >> 255);
781     }
782 
783     /**
784      * @dev expand a given rate
785      */
786     function _expandRate(uint256 rate) private pure returns (uint256) {
787         return (rate % ONE) << (rate / ONE);
788     }
789 
790     /**
791      * @dev validates a given rate
792      */
793     function _validRate(uint256 rate) private pure returns (bool) {
794         return (ONE >> (rate / ONE)) > 0;
795     }
796 
797     /**
798      * @dev returns the source and target amounts of a single trade action
799      */
800     function _singleTradeActionSourceAndTargetAmounts(
801         Order memory order,
802         uint128 amount,
803         bool byTargetAmount
804     ) internal pure returns (SourceAndTargetAmounts memory amounts) {
805         uint256 y = uint256(order.y);
806         uint256 z = uint256(order.z);
807         uint256 a = _expandRate(uint256(order.A));
808         uint256 b = _expandRate(uint256(order.B));
809         if (byTargetAmount) {
810             amounts.sourceAmount = _calculateTradeSourceAmount(amount, y, z, a, b).toUint128();
811             amounts.targetAmount = amount;
812         } else {
813             amounts.sourceAmount = amount;
814             amounts.targetAmount = _calculateTradeTargetAmount(amount, y, z, a, b).toUint128();
815         }
816     }
817 
818     /**
819      * revert if any of the orders is invalid
820      */
821     function _validateOrders(Order[2] calldata orders) internal pure {
822         for (uint256 i = 0; i < 2; i++) {
823             if (orders[i].z < orders[i].y) {
824                 revert InsufficientCapacity();
825             }
826             if (!_validRate(orders[i].A)) {
827                 revert InvalidRate();
828             }
829             if (!_validRate(orders[i].B)) {
830                 revert InvalidRate();
831             }
832         }
833     }
834 
835     /**
836      * returns the strategyId for a given poolId and a given strategyIndex
837      */
838     function _strategyId(uint256 poolId, uint256 strategyIndex) internal pure returns (uint256) {
839         return (uint256(poolId.toUint128()) << 128) | strategyIndex.toUint128();
840     }
841 
842     /**
843      * returns the poolId associated with a given strategyId
844      */
845     function _poolIdbyStrategyId(uint256 strategyId) internal pure returns (uint256) {
846         return strategyId >> 128;
847     }
848 
849     /**
850      * returns a number representation for a boolean
851      */
852     function _booleanToNumber(bool b) private pure returns (uint256) {
853         return b ? 1 : 0;
854     }
855 
856     /**
857      * returns a boolean representation for a number
858      */
859     function _numberToBoolean(uint256 u) private pure returns (bool) {
860         return u != 0;
861     }
862 
863     /**
864      * retuns tokens sorted accordingly to a strategy orders inversion
865      */
866     function _sortStrategyTokens(Pool memory pool, bool ordersInverted) private pure returns (Token[2] memory) {
867         return ordersInverted ? [pool.tokens[1], pool.tokens[0]] : pool.tokens;
868     }
869 
870     /**
871      * sends erc20 or native token to the provided target
872      */
873     function _withdrawFunds(Token token, address payable target, uint256 amount) private {
874         if (amount == 0) {
875             return;
876         }
877 
878         if (token.isNative()) {
879             // using a regular transfer here would revert due to exceeding the 2300 gas limit which is why we're using
880             // call instead (via sendValue), which the 2300 gas limit does not apply for
881             target.sendValue(amount);
882         } else {
883             token.safeTransfer(target, amount);
884         }
885     }
886 }
