1 /*
2 
3     Copyright 2019 The Hydro Protocol Foundation
4 
5     Licensed under the Apache License, Version 2.0 (the "License");
6     you may not use this file except in compliance with the License.
7     You may obtain a copy of the License at
8 
9         http://www.apache.org/licenses/LICENSE-2.0
10 
11     Unless required by applicable law or agreed to in writing, software
12     distributed under the License is distributed on an "AS IS" BASIS,
13     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
14     See the License for the specific language governing permissions and
15     limitations under the License.
16 
17 */
18 
19 pragma solidity 0.5.8;
20 pragma experimental ABIEncoderV2;
21 
22 contract GlobalStore {
23     Store.State state;
24 }
25 
26 contract ExternalFunctions is GlobalStore {
27 
28     ////////////////////////////
29     // Batch Actions Function //
30     ////////////////////////////
31 
32     function batch(
33         BatchActions.Action[] memory actions
34     )
35         public
36         payable
37     {
38         BatchActions.batch(state, actions, msg.value);
39     }
40 
41     ////////////////////////
42     // Signature Function //
43     ////////////////////////
44 
45     function isValidSignature(
46         bytes32 hash,
47         address signerAddress,
48         Types.Signature calldata signature
49     )
50         external
51         pure
52         returns (bool isValid)
53     {
54         isValid = Signature.isValidSignature(hash, signerAddress, signature);
55     }
56 
57     ///////////////////////
58     // Markets Functions //
59     ///////////////////////
60 
61     function getAllMarketsCount()
62         external
63         view
64         returns (uint256 count)
65     {
66         count = state.marketsCount;
67     }
68 
69     function getAsset(address assetAddress)
70         external
71         view returns (Types.Asset memory asset)
72     {
73         Requires.requireAssetExist(state, assetAddress);
74         asset = state.assets[assetAddress];
75     }
76 
77     function getAssetOraclePrice(address assetAddress)
78         external
79         view
80         returns (uint256 price)
81     {
82         Requires.requireAssetExist(state, assetAddress);
83         price = AssemblyCall.getAssetPriceFromPriceOracle(
84             address(state.assets[assetAddress].priceOracle),
85             assetAddress
86         );
87     }
88 
89     function getMarket(uint16 marketID)
90         external
91         view
92         returns (Types.Market memory market)
93     {
94         Requires.requireMarketIDExist(state, marketID);
95         market = state.markets[marketID];
96     }
97 
98     //////////////////////////////////
99     // Collateral Account Functions //
100     //////////////////////////////////
101 
102     function isAccountLiquidatable(
103         address user,
104         uint16 marketID
105     )
106         external
107         view
108         returns (bool isLiquidatable)
109     {
110         Requires.requireMarketIDExist(state, marketID);
111         isLiquidatable = CollateralAccounts.getDetails(state, user, marketID).liquidatable;
112     }
113 
114     function getAccountDetails(
115         address user,
116         uint16 marketID
117     )
118         external
119         view
120         returns (Types.CollateralAccountDetails memory details)
121     {
122         Requires.requireMarketIDExist(state, marketID);
123         details = CollateralAccounts.getDetails(state, user, marketID);
124     }
125 
126     function getAuctionsCount()
127         external
128         view
129         returns (uint32 count)
130     {
131         count = state.auction.auctionsCount;
132     }
133 
134     function getCurrentAuctions()
135         external
136         view
137         returns (uint32[] memory)
138     {
139         return state.auction.currentAuctions;
140     }
141 
142     function getAuctionDetails(uint32 auctionID)
143         external
144         view
145         returns (Types.AuctionDetails memory details)
146     {
147         Requires.requireAuctionExist(state, auctionID);
148         details = Auctions.getAuctionDetails(state, auctionID);
149     }
150 
151     function fillAuctionWithAmount(
152         uint32 auctionID,
153         uint256 amount
154     )
155         external
156     {
157         Requires.requireAuctionExist(state, auctionID);
158         Requires.requireAuctionNotFinished(state, auctionID);
159         Auctions.fillAuctionWithAmount(state, auctionID, amount);
160     }
161 
162     function liquidateAccount(
163         address user,
164         uint16 marketID
165     )
166         external
167         returns (bool hasAuction, uint32 auctionID)
168     {
169         Requires.requireMarketIDExist(state, marketID);
170         (hasAuction, auctionID) = Auctions.liquidate(state, user, marketID);
171     }
172 
173     ///////////////////////////
174     // LendingPool Functions //
175     ///////////////////////////
176 
177     function getPoolCashableAmount(address asset)
178         external
179         view
180         returns (uint256 cashableAmount)
181     {
182         if (asset == Consts.ETHEREUM_TOKEN_ADDRESS()) {
183             cashableAmount = address(this).balance - uint256(state.cash[asset]);
184         } else {
185             cashableAmount = IStandardToken(asset).balanceOf(address(this)) - uint256(state.cash[asset]);
186         }
187     }
188 
189     function getIndex(address asset)
190         external
191         view
192         returns (uint256 supplyIndex, uint256 borrowIndex)
193     {
194         return LendingPool.getCurrentIndex(state, asset);
195     }
196 
197     function getTotalBorrow(address asset)
198         external
199         view
200         returns (uint256 amount)
201     {
202         Requires.requireAssetExist(state, asset);
203         amount = LendingPool.getTotalBorrow(state, asset);
204     }
205 
206     function getTotalSupply(address asset)
207         external
208         view
209         returns (uint256 amount)
210     {
211         Requires.requireAssetExist(state, asset);
212         amount = LendingPool.getTotalSupply(state, asset);
213     }
214 
215     function getAmountBorrowed(
216         address asset,
217         address user,
218         uint16 marketID
219     )
220         external
221         view
222         returns (uint256 amount)
223     {
224         Requires.requireMarketIDExist(state, marketID);
225         Requires.requireMarketIDAndAssetMatch(state, marketID, asset);
226         amount = LendingPool.getAmountBorrowed(state, asset, user, marketID);
227     }
228 
229     function getAmountSupplied(
230         address asset,
231         address user
232     )
233         external
234         view
235         returns (uint256 amount)
236     {
237         Requires.requireAssetExist(state, asset);
238         amount = LendingPool.getAmountSupplied(state, asset, user);
239     }
240 
241     function getInterestRates(
242         address asset,
243         uint256 extraBorrowAmount
244     )
245         external
246         view
247         returns (uint256 borrowInterestRate, uint256 supplyInterestRate)
248     {
249         Requires.requireAssetExist(state, asset);
250         (borrowInterestRate, supplyInterestRate) = LendingPool.getInterestRates(state, asset, extraBorrowAmount);
251     }
252 
253     function getInsuranceBalance(address asset)
254         external
255         view
256         returns (uint256 amount)
257     {
258         Requires.requireAssetExist(state, asset);
259         amount = state.pool.insuranceBalances[asset];
260     }
261 
262     ///////////////////////
263     // Relayer Functions //
264     ///////////////////////
265 
266     function approveDelegate(address delegate)
267         external
268     {
269         Relayer.approveDelegate(state, delegate);
270     }
271 
272     function revokeDelegate(address delegate)
273         external
274     {
275         Relayer.revokeDelegate(state, delegate);
276     }
277 
278     function joinIncentiveSystem()
279         external
280     {
281         Relayer.joinIncentiveSystem(state);
282     }
283 
284     function exitIncentiveSystem()
285         external
286     {
287         Relayer.exitIncentiveSystem(state);
288     }
289 
290     function canMatchOrdersFrom(address relayer)
291         external
292         view
293         returns (bool canMatch)
294     {
295         canMatch = Relayer.canMatchOrdersFrom(state, relayer);
296     }
297 
298     function isParticipant(address relayer)
299         external
300         view
301         returns (bool result)
302     {
303         result = Relayer.isParticipant(state, relayer);
304     }
305 
306     ////////////////////////
307     // Balances Functions //
308     ////////////////////////
309 
310     function balanceOf(
311         address asset,
312         address user
313     )
314         external
315         view
316         returns (uint256 balance)
317     {
318         balance = Transfer.balanceOf(state,  BalancePath.getCommonPath(user), asset);
319     }
320 
321     function marketBalanceOf(
322         uint16 marketID,
323         address asset,
324         address user
325     )
326         external
327         view
328         returns (uint256 balance)
329     {
330         Requires.requireMarketIDExist(state, marketID);
331         Requires.requireMarketIDAndAssetMatch(state, marketID, asset);
332         balance = Transfer.balanceOf(state,  BalancePath.getMarketPath(user, marketID), asset);
333     }
334 
335     function getMarketTransferableAmount(
336         uint16 marketID,
337         address asset,
338         address user
339     )
340         external
341         view
342         returns (uint256 amount)
343     {
344         Requires.requireMarketIDExist(state, marketID);
345         Requires.requireMarketIDAndAssetMatch(state, marketID, asset);
346         amount = CollateralAccounts.getTransferableAmount(state, marketID, user, asset);
347     }
348 
349     /** fallback function to allow deposit ether into this contract */
350     function ()
351         external
352         payable
353     {
354         // deposit ${msg.value} ether for ${msg.sender}
355         Transfer.deposit(
356             state,
357             Consts.ETHEREUM_TOKEN_ADDRESS(),
358             msg.value
359         );
360     }
361 
362     ////////////////////////
363     // Exchange Functions //
364     ////////////////////////
365 
366     function cancelOrder(
367         Types.Order calldata order
368     )
369         external
370     {
371         Exchange.cancelOrder(state, order);
372     }
373 
374     function isOrderCancelled(
375         bytes32 orderHash
376     )
377         external
378         view
379         returns(bool isCancelled)
380     {
381         isCancelled = state.exchange.cancelled[orderHash];
382     }
383 
384     function matchOrders(
385         Types.MatchParams memory params
386     )
387         public
388     {
389         Exchange.matchOrders(state, params);
390     }
391 
392     function getDiscountedRate(
393         address user
394     )
395         external
396         view
397         returns (uint256 rate)
398     {
399         rate = Discount.getDiscountedRate(state, user);
400     }
401 
402     function getHydroTokenAddress()
403         external
404         view
405         returns (address hydroTokenAddress)
406     {
407         hydroTokenAddress = state.exchange.hotTokenAddress;
408     }
409 
410     function getOrderFilledAmount(
411         bytes32 orderHash
412     )
413         external
414         view
415         returns (uint256 amount)
416     {
417         amount = state.exchange.filled[orderHash];
418     }
419 }
420 
421 library OperationsComponent {
422 
423     function createMarket(
424         Store.State storage state,
425         Types.Market memory market
426     )
427         public
428     {
429         Requires.requireMarketAssetsValid(state, market);
430         Requires.requireMarketNotExist(state, market);
431         Requires.requireDecimalLessOrEquanThanOne(market.auctionRatioStart);
432         Requires.requireDecimalLessOrEquanThanOne(market.auctionRatioPerBlock);
433         Requires.requireDecimalGreaterThanOne(market.liquidateRate);
434         Requires.requireDecimalGreaterThanOne(market.withdrawRate);
435         require(market.withdrawRate > market.liquidateRate, "WITHDARW_RATE_LESS_OR_EQUAL_THAN_LIQUIDATE_RATE");
436 
437         state.markets[state.marketsCount++] = market;
438         Events.logCreateMarket(market);
439     }
440 
441     function updateMarket(
442         Store.State storage state,
443         uint16 marketID,
444         uint256 newAuctionRatioStart,
445         uint256 newAuctionRatioPerBlock,
446         uint256 newLiquidateRate,
447         uint256 newWithdrawRate
448     )
449         external
450     {
451         Requires.requireMarketIDExist(state, marketID);
452         Requires.requireDecimalLessOrEquanThanOne(newAuctionRatioStart);
453         Requires.requireDecimalLessOrEquanThanOne(newAuctionRatioPerBlock);
454         Requires.requireDecimalGreaterThanOne(newLiquidateRate);
455         Requires.requireDecimalGreaterThanOne(newWithdrawRate);
456         require(newWithdrawRate > newLiquidateRate, "WITHDARW_RATE_LESS_OR_EQUAL_THAN_LIQUIDATE_RATE");
457 
458         state.markets[marketID].auctionRatioStart = newAuctionRatioStart;
459         state.markets[marketID].auctionRatioPerBlock = newAuctionRatioPerBlock;
460         state.markets[marketID].liquidateRate = newLiquidateRate;
461         state.markets[marketID].withdrawRate = newWithdrawRate;
462 
463         Events.logUpdateMarket(
464             marketID,
465             newAuctionRatioStart,
466             newAuctionRatioPerBlock,
467             newLiquidateRate,
468             newWithdrawRate
469         );
470     }
471 
472     function setMarketBorrowUsability(
473         Store.State storage state,
474         uint16 marketID,
475         bool   usability
476     )
477         external
478     {
479         Requires.requireMarketIDExist(state, marketID);
480         state.markets[marketID].borrowEnable = usability;
481         if (usability) {
482             Events.logMarketBorrowDisable(
483                 marketID
484             );
485         } else {
486             Events.logMarketBorrowEnable(
487                 marketID
488             );
489         }
490     }
491 
492     function createAsset(
493         Store.State storage state,
494         address asset,
495         address oracleAddress,
496         address interestModelAddress,
497         string calldata poolTokenName,
498         string calldata poolTokenSymbol,
499         uint8 poolTokenDecimals
500     )
501         external
502     {
503         Requires.requirePriceOracleAddressValid(oracleAddress);
504         Requires.requireAssetNotExist(state, asset);
505 
506         LendingPool.initializeAssetLendingPool(state, asset);
507 
508         state.assets[asset].priceOracle = IPriceOracle(oracleAddress);
509         state.assets[asset].interestModel = IInterestModel(interestModelAddress);
510         state.assets[asset].lendingPoolToken = ILendingPoolToken(address(new LendingPoolToken(
511             poolTokenName,
512             poolTokenSymbol,
513             poolTokenDecimals
514         )));
515 
516         Events.logCreateAsset(
517             asset,
518             oracleAddress,
519             address(state.assets[asset].lendingPoolToken),
520             interestModelAddress
521         );
522     }
523 
524     function updateAsset(
525         Store.State storage state,
526         address asset,
527         address oracleAddress,
528         address interestModelAddress
529     )
530         external
531     {
532         Requires.requirePriceOracleAddressValid(oracleAddress);
533         Requires.requireAssetExist(state, asset);
534 
535         state.assets[asset].priceOracle = IPriceOracle(oracleAddress);
536         state.assets[asset].interestModel = IInterestModel(interestModelAddress);
537 
538         Events.logUpdateAsset(
539             asset,
540             oracleAddress,
541             interestModelAddress
542         );
543     }
544 
545     /**
546      * @param newConfig A data blob representing the new discount config. Details on format above.
547      */
548     function updateDiscountConfig(
549         Store.State storage state,
550         bytes32 newConfig
551     )
552         external
553     {
554         state.exchange.discountConfig = newConfig;
555         Events.logUpdateDiscountConfig(newConfig);
556     }
557 
558     function updateAuctionInitiatorRewardRatio(
559         Store.State storage state,
560         uint256 newInitiatorRewardRatio
561     )
562         external
563     {
564         Requires.requireDecimalLessOrEquanThanOne(newInitiatorRewardRatio);
565 
566         state.auction.initiatorRewardRatio = newInitiatorRewardRatio;
567         Events.logUpdateAuctionInitiatorRewardRatio(newInitiatorRewardRatio);
568     }
569 
570     function updateInsuranceRatio(
571         Store.State storage state,
572         uint256 newInsuranceRatio
573     )
574         external
575     {
576         Requires.requireDecimalLessOrEquanThanOne(newInsuranceRatio);
577 
578         state.pool.insuranceRatio = newInsuranceRatio;
579         Events.logUpdateInsuranceRatio(newInsuranceRatio);
580     }
581 }
582 
583 library Discount {
584     using SafeMath for uint256;
585 
586     /**
587      * Calculate and return the rate at which fees will be charged for an address. The discounted
588      * rate depends on how much HOT token is owned by the user. Values returned will be a percentage
589      * used to calculate how much of the fee is paid, so a return value of 100 means there is 0
590      * discount, and a return value of 70 means a 30% rate reduction.
591      *
592      * The discountConfig is defined as such:
593      * ╔═══════════════════╤════════════════════════════════════════════╗
594      * ║                   │ length(bytes)   desc                       ║
595      * ╟───────────────────┼────────────────────────────────────────────╢
596      * ║ count             │ 1               the count of configs       ║
597      * ║ maxDiscountedRate │ 1               the max discounted rate    ║
598      * ║ config            │ 5 each                                     ║
599      * ╚═══════════════════╧════════════════════════════════════════════╝
600      *
601      * The default discount structure as defined in code would give the following result:
602      *
603      * Fee discount table
604      * ╔════════════════════╤══════════╗
605      * ║     HOT BALANCE    │ DISCOUNT ║
606      * ╠════════════════════╪══════════╣
607      * ║     0 <= x < 10000 │     0%   ║
608      * ╟────────────────────┼──────────╢
609      * ║ 10000 <= x < 20000 │    10%   ║
610      * ╟────────────────────┼──────────╢
611      * ║ 20000 <= x < 30000 │    20%   ║
612      * ╟────────────────────┼──────────╢
613      * ║ 30000 <= x < 40000 │    30%   ║
614      * ╟────────────────────┼──────────╢
615      * ║ 40000 <= x         │    40%   ║
616      * ╚════════════════════╧══════════╝
617      *
618      * Breaking down the bytes of 0x043c000027106400004e205a000075305000009c404600000000000000000000
619      *
620      * 0x  04           3c          0000271064  00004e205a  0000753050  00009c4046  0000000000  0000000000;
621      *     ~~           ~~          ~~~~~~~~~~  ~~~~~~~~~~  ~~~~~~~~~~  ~~~~~~~~~~  ~~~~~~~~~~  ~~~~~~~~~~
622      *      |            |               |           |           |           |           |           |
623      *    count  maxDiscountedRate       1           2           3           4           5           6
624      *
625      * The first config breaks down as follows:  00002710   64
626      *                                           ~~~~~~~~   ~~
627      *                                               |      |
628      *                                              bar    rate
629      *
630      * Meaning if a user has less than 10000 (0x00002710) HOT, they will pay 100%(0x64) of the
631      * standard fee.
632      *
633      * @param  user The user address to calculate a fee discount for.
634      * @return      The percentage of the regular fee this user will pay.
635      */
636     function getDiscountedRate(
637         Store.State storage state,
638         address user
639     )
640         internal
641         view
642         returns (uint256 result)
643     {
644         uint256 hotBalance = AssemblyCall.getHotBalance(
645             state.exchange.hotTokenAddress,
646             user
647         );
648 
649         if (hotBalance == 0) {
650             return Consts.DISCOUNT_RATE_BASE();
651         }
652 
653         bytes32 config = state.exchange.discountConfig;
654         uint256 count = uint256(uint8(byte(config)));
655         uint256 bar;
656 
657         // HOT Token has 18 decimals
658         hotBalance = hotBalance.div(10**18);
659 
660         for (uint256 i = 0; i < count; i++) {
661             bar = uint256(uint32(bytes4(config << (2 + i * 5) * 8)));
662 
663             if (hotBalance < bar) {
664                 result = uint256(uint8(byte(config << (2 + i * 5 + 4) * 8)));
665                 break;
666             }
667         }
668 
669         // If we haven't found a rate in the config yet, use the maximum rate.
670         if (result == 0) {
671             result = uint256(uint8(config[1]));
672         }
673 
674         // Make sure our discount algorithm never returns a higher rate than the base.
675         require(result <= Consts.DISCOUNT_RATE_BASE(), "DISCOUNT_ERROR");
676     }
677 }
678 
679 library Exchange {
680     using SafeMath for uint256;
681     using Order for Types.Order;
682     using OrderParam for Types.OrderParam;
683 
684     uint256 private constant EXCHANGE_FEE_RATE_BASE = 100000;
685     uint256 private constant SUPPORTED_ORDER_VERSION = 2;
686 
687     /**
688      * Calculated data about an order object.
689      * Generally the filledAmount is specified in base token units, however in the case of a market
690      * buy order the filledAmount is specified in quote token units.
691      */
692     struct OrderInfo {
693         bytes32 orderHash;
694         uint256 filledAmount;
695         Types.BalancePath balancePath;
696     }
697 
698     /**
699      * Match taker order to a list of maker orders. Common addresses are passed in
700      * separately as an Types.OrderAddressSet to reduce call size data and save gas.
701      */
702     function matchOrders(
703         Store.State storage state,
704         Types.MatchParams memory params
705     )
706         internal
707     {
708         require(Relayer.canMatchOrdersFrom(state, params.orderAddressSet.relayer), "INVALID_SENDER");
709         require(!params.takerOrderParam.isMakerOnly(), "MAKER_ONLY_ORDER_CANNOT_BE_TAKER");
710 
711         bool isParticipantRelayer = Relayer.isParticipant(state, params.orderAddressSet.relayer);
712         uint256 takerFeeRate = getTakerFeeRate(state, params.takerOrderParam, isParticipantRelayer);
713         OrderInfo memory takerOrderInfo = getOrderInfo(state, params.takerOrderParam, params.orderAddressSet);
714 
715         // Calculate which orders match for settlement.
716         Types.MatchResult[] memory results = new Types.MatchResult[](params.makerOrderParams.length);
717 
718         for (uint256 i = 0; i < params.makerOrderParams.length; i++) {
719             require(!params.makerOrderParams[i].isMarketOrder(), "MAKER_ORDER_CAN_NOT_BE_MARKET_ORDER");
720             require(params.takerOrderParam.isSell() != params.makerOrderParams[i].isSell(), "INVALID_SIDE");
721             validatePrice(params.takerOrderParam, params.makerOrderParams[i]);
722 
723             OrderInfo memory makerOrderInfo = getOrderInfo(state, params.makerOrderParams[i], params.orderAddressSet);
724 
725             results[i] = getMatchResult(
726                 state,
727                 params.takerOrderParam,
728                 takerOrderInfo,
729                 params.makerOrderParams[i],
730                 makerOrderInfo,
731                 params.baseAssetFilledAmounts[i],
732                 takerFeeRate,
733                 isParticipantRelayer
734             );
735 
736             // Update amount filled for this maker order.
737             state.exchange.filled[makerOrderInfo.orderHash] = makerOrderInfo.filledAmount;
738         }
739 
740         // Update amount filled for this taker order.
741         state.exchange.filled[takerOrderInfo.orderHash] = takerOrderInfo.filledAmount;
742 
743         settleResults(state, results, params.takerOrderParam, params.orderAddressSet);
744     }
745 
746     /**
747      * Cancels an order, preventing it from being matched. In practice, matching mode relayers will
748      * generally handle cancellation off chain by removing the order from their system, however if
749      * the trader wants to ensure the order never goes through, or they no longer trust the relayer,
750      * this function may be called to block it from ever matching at the contract level.
751      *
752      * Emits a Cancel event on success.
753      *
754      * @param order The order to be cancelled.
755      */
756     function cancelOrder(
757         Store.State storage state,
758         Types.Order memory order
759     )
760         internal
761     {
762         require(order.trader == msg.sender, "INVALID_TRADER");
763 
764         bytes32 orderHash = order.getHash();
765         state.exchange.cancelled[orderHash] = true;
766 
767         Events.logOrderCancel(orderHash);
768     }
769 
770     /**
771      * Calculates current state of the order. Will revert transaction if this order is not
772      * fillable for any reason, or if the order signature is invalid.
773      *
774      * @param orderParam The Types.OrderParam object containing Order data.
775      * @param orderAddressSet An object containing addresses common across each order.
776      * @return An OrderInfo object containing the hash and current amount filled
777      */
778     function getOrderInfo(
779         Store.State storage state,
780         Types.OrderParam memory orderParam,
781         Types.OrderAddressSet memory orderAddressSet
782     )
783         private
784         view
785         returns (OrderInfo memory orderInfo)
786     {
787         require(orderParam.getOrderVersion() == SUPPORTED_ORDER_VERSION, "ORDER_VERSION_NOT_SUPPORTED");
788 
789         Types.Order memory order = getOrderFromOrderParam(orderParam, orderAddressSet);
790         orderInfo.orderHash = order.getHash();
791         orderInfo.filledAmount = state.exchange.filled[orderInfo.orderHash];
792         uint8 status = uint8(Types.OrderStatus.FILLABLE);
793 
794         if (!orderParam.isMarketBuy() && orderInfo.filledAmount >= order.baseAssetAmount) {
795             status = uint8(Types.OrderStatus.FULLY_FILLED);
796         } else if (orderParam.isMarketBuy() && orderInfo.filledAmount >= order.quoteAssetAmount) {
797             status = uint8(Types.OrderStatus.FULLY_FILLED);
798         } else if (block.timestamp >= orderParam.getExpiredAtFromOrderData()) {
799             status = uint8(Types.OrderStatus.EXPIRED);
800         } else if (state.exchange.cancelled[orderInfo.orderHash]) {
801             status = uint8(Types.OrderStatus.CANCELLED);
802         }
803 
804         require(
805             status == uint8(Types.OrderStatus.FILLABLE),
806             "ORDER_IS_NOT_FILLABLE"
807         );
808 
809         require(
810             Signature.isValidSignature(orderInfo.orderHash, orderParam.trader, orderParam.signature),
811             "INVALID_ORDER_SIGNATURE"
812         );
813 
814         orderInfo.balancePath = orderParam.getBalancePathFromOrderData();
815         Requires.requirePathNormalStatus(state, orderInfo.balancePath);
816 
817         return orderInfo;
818     }
819 
820     /**
821      * Reconstruct an Order object from the given Types.OrderParam and Types.OrderAddressSet objects.
822      *
823      * @param orderParam The Types.OrderParam object containing the Order data.
824      * @param orderAddressSet An object containing addresses common across each order.
825      * @return The reconstructed Order object.
826      */
827     function getOrderFromOrderParam(
828         Types.OrderParam memory orderParam,
829         Types.OrderAddressSet memory orderAddressSet
830     )
831         private
832         pure
833         returns (Types.Order memory order)
834     {
835         order.trader = orderParam.trader;
836         order.baseAssetAmount = orderParam.baseAssetAmount;
837         order.quoteAssetAmount = orderParam.quoteAssetAmount;
838         order.gasTokenAmount = orderParam.gasTokenAmount;
839         order.data = orderParam.data;
840         order.baseAsset = orderAddressSet.baseAsset;
841         order.quoteAsset = orderAddressSet.quoteAsset;
842         order.relayer = orderAddressSet.relayer;
843     }
844 
845     /**
846      * Validates that the maker and taker orders can be matched based on the listed prices.
847      *
848      * If the taker submitted a sell order, the matching maker order must have a price greater than
849      * or equal to the price the taker is willing to sell for.
850      *
851      * Since the price of an order is computed by order.quoteAssetAmount / order.baseAssetAmount
852      * we can establish the following formula:
853      *
854      *    takerOrder.quoteAssetAmount        makerOrder.quoteAssetAmount
855      *   -----------------------------  <=  -----------------------------
856      *     takerOrder.baseAssetAmount        makerOrder.baseAssetAmount
857      *
858      * To avoid precision loss from division, we modify the formula to avoid division entirely.
859      * In shorthand, this becomes:
860      *
861      *   takerOrder.quote * makerOrder.base <= takerOrder.base * makerOrder.quote
862      *
863      * We can apply this same process to buy orders - if the taker submitted a buy order then
864      * the matching maker order must have a price less than or equal to the price the taker is
865      * willing to pay. This means we can use the same result as above, but simply flip the
866      * sign of the comparison operator.
867      *
868      * The function will revert the transaction if the orders cannot be matched.
869      *
870      * @param takerOrderParam The Types.OrderParam object representing the taker's order data
871      * @param makerOrderParam The Types.OrderParam object representing the maker's order data
872      */
873     function validatePrice(
874         Types.OrderParam memory takerOrderParam,
875         Types.OrderParam memory makerOrderParam
876     )
877         private
878         pure
879     {
880         uint256 left = takerOrderParam.quoteAssetAmount.mul(makerOrderParam.baseAssetAmount);
881         uint256 right = takerOrderParam.baseAssetAmount.mul(makerOrderParam.quoteAssetAmount);
882         require(takerOrderParam.isSell() ? left <= right : left >= right, "INVALID_MATCH");
883     }
884 
885     /**
886      * Construct a Types.MatchResult from matching taker and maker order data, which will be used when
887      * settling the orders and transferring token.
888      *
889      * @param takerOrderParam The Types.OrderParam object representing the taker's order data
890      * @param takerOrderInfo The OrderInfo object representing the current taker order state
891      * @param makerOrderParam The Types.OrderParam object representing the maker's order data
892      * @param makerOrderInfo The OrderInfo object representing the current maker order state
893      * @param takerFeeRate The rate used to calculate the fee charged to the taker
894      * @param isParticipantRelayer Whether this relayer is participating in hot discount
895      * @return Types.MatchResult object containing data that will be used during order settlement.
896      */
897     function getMatchResult(
898         Store.State storage state,
899         Types.OrderParam memory takerOrderParam,
900         OrderInfo memory takerOrderInfo,
901         Types.OrderParam memory makerOrderParam,
902         OrderInfo memory makerOrderInfo,
903         uint256 baseAssetFilledAmount,
904         uint256 takerFeeRate,
905         bool isParticipantRelayer
906     )
907         private
908         view
909         returns (Types.MatchResult memory result)
910     {
911         result.baseAssetFilledAmount = baseAssetFilledAmount;
912         result.quoteAssetFilledAmount = convertBaseToQuote(makerOrderParam, baseAssetFilledAmount);
913 
914         result.takerBalancePath = takerOrderInfo.balancePath;
915         result.makerBalancePath = makerOrderInfo.balancePath;
916 
917         // Each order only pays gas once, so only pay gas when nothing has been filled yet.
918         if (takerOrderInfo.filledAmount == 0) {
919             result.takerGasFee = takerOrderParam.gasTokenAmount;
920         }
921 
922         if (makerOrderInfo.filledAmount == 0) {
923             result.makerGasFee = makerOrderParam.gasTokenAmount;
924         }
925 
926         if(!takerOrderParam.isMarketBuy()) {
927             takerOrderInfo.filledAmount = takerOrderInfo.filledAmount.add(result.baseAssetFilledAmount);
928             require(takerOrderInfo.filledAmount <= takerOrderParam.baseAssetAmount, "TAKER_ORDER_OVER_MATCH");
929         } else {
930             takerOrderInfo.filledAmount = takerOrderInfo.filledAmount.add(result.quoteAssetFilledAmount);
931             require(takerOrderInfo.filledAmount <= takerOrderParam.quoteAssetAmount, "TAKER_ORDER_OVER_MATCH");
932         }
933 
934         makerOrderInfo.filledAmount = makerOrderInfo.filledAmount.add(result.baseAssetFilledAmount);
935         require(makerOrderInfo.filledAmount <= makerOrderParam.baseAssetAmount, "MAKER_ORDER_OVER_MATCH");
936 
937         result.maker = makerOrderParam.trader;
938         result.taker = takerOrderParam.trader;
939 
940         if(takerOrderParam.isSell()) {
941             result.buyer = result.maker;
942         } else {
943             result.buyer = result.taker;
944         }
945 
946         uint256 rebateRate = makerOrderParam.getMakerRebateRateFromOrderData();
947 
948         if (rebateRate > 0) {
949             // If the rebate rate is not zero, maker pays no fees.
950             result.makerFee = 0;
951 
952             // RebateRate will never exceed REBATE_RATE_BASE, so rebateFee will never exceed the fees paid by the taker.
953             result.makerRebate = result.quoteAssetFilledAmount.mul(takerFeeRate).mul(rebateRate).div(
954                 EXCHANGE_FEE_RATE_BASE.mul(Consts.DISCOUNT_RATE_BASE()).mul(Consts.REBATE_RATE_BASE())
955             );
956         } else {
957             uint256 makerRawFeeRate = makerOrderParam.getAsMakerFeeRateFromOrderData();
958             result.makerRebate = 0;
959 
960             // maker fee will be reduced, but still >= 0
961             uint256 makerFeeRate = getFinalFeeRate(
962                 state,
963                 makerOrderParam.trader,
964                 makerRawFeeRate,
965                 isParticipantRelayer
966             );
967 
968             result.makerFee = result.quoteAssetFilledAmount.mul(makerFeeRate).div(
969                 EXCHANGE_FEE_RATE_BASE.mul(Consts.DISCOUNT_RATE_BASE())
970             );
971         }
972 
973         result.takerFee = result.quoteAssetFilledAmount.mul(takerFeeRate).div(
974             EXCHANGE_FEE_RATE_BASE.mul(Consts.DISCOUNT_RATE_BASE())
975         );
976     }
977 
978     /**
979      * Get the rate used to calculate the taker fee.
980      *
981      * @param orderParam The Types.OrderParam object representing the taker order data.
982      * @param isParticipantRelayer Whether this relayer is participating in hot discount.
983      * @return The final potentially discounted rate to use for the taker fee.
984      */
985     function getTakerFeeRate(
986         Store.State storage state,
987         Types.OrderParam memory orderParam,
988         bool isParticipantRelayer
989     )
990         private
991         view
992         returns(uint256)
993     {
994         uint256 rawRate = orderParam.getAsTakerFeeRateFromOrderData();
995         return getFinalFeeRate(state, orderParam.trader, rawRate, isParticipantRelayer);
996     }
997 
998     /**
999      * Take a fee rate and calculate the potentially discounted rate for this trader based on
1000      * HOT token ownership.
1001      *
1002      * @param trader The address of the trader who made the order.
1003      * @param rate The raw rate which we will discount if needed.
1004      * @param isParticipantRelayer Whether this relayer is participating in hot discount.
1005      * @return The final potentially discounted rate.
1006      */
1007     function getFinalFeeRate(
1008         Store.State storage state,
1009         address trader,
1010         uint256 rate,
1011         bool isParticipantRelayer
1012     )
1013         private
1014         view
1015         returns(uint256)
1016     {
1017         if (isParticipantRelayer) {
1018             return rate.mul(Discount.getDiscountedRate(state, trader));
1019         } else {
1020             return rate.mul(Consts.DISCOUNT_RATE_BASE());
1021         }
1022     }
1023 
1024     /**
1025      * Take an amount and convert it from base token units to quote token units based on the price
1026      * in the order param.
1027      *
1028      * @param orderParam The Types.OrderParam object containing the Order data.
1029      * @param amount An amount of base token.
1030      * @return The converted amount in quote token units.
1031      */
1032     function convertBaseToQuote(
1033         Types.OrderParam memory orderParam,
1034         uint256 amount
1035     )
1036         private
1037         pure
1038         returns (uint256)
1039     {
1040         return SafeMath.getPartialAmountFloor(
1041             orderParam.quoteAssetAmount,
1042             orderParam.baseAssetAmount,
1043             amount
1044         );
1045     }
1046 
1047     /**
1048      * Take a list of matches and settle them with the taker order, transferring tokens all tokens
1049      * and paying all fees necessary to complete the transaction.
1050      *
1051      * Settles a order given a list of Types.MatchResult objects. A naive approach would be to take
1052      * each result, have the taker and maker transfer the appropriate tokens, and then have them
1053      * each send the appropriate fees to the relayer, meaning that for n makers there would be 4n
1054      * transactions.
1055      *
1056      * Instead we do the following:
1057      *
1058      * For a match which has a taker as seller:
1059      *  - Taker transfers the required base token to each maker
1060      *  - Each maker sends an amount of quote token to the taker equal to:
1061      *    [Amount owed to taker] + [Maker fee] + [Maker gas cost] - [Maker rebate amount]
1062      *  - Since the taker has received all the maker fees and gas costs, it can then send them along
1063      *    with taker fees in a single batch transaction to the relayer, equal to:
1064      *    [All maker and taker fees] + [All maker and taker gas costs] - [All maker rebates]
1065      *
1066      * Thus in the end the taker will have the full amount of quote token, sans the fee and cost of
1067      * their share of gas. Each maker will have their share of base token, sans the fee and cost of
1068      * their share of gas, and will keep their rebate in quote token. The relayer will end up with
1069      * the fees from the taker and each maker (sans rebate), and the gas costs will pay for the
1070      * transactions.
1071      *
1072      * For a match which has a taker as buyer:
1073      *  - Each maker transfers base tokens to the taker
1074      *  - The taker sends an amount of quote tokens to each maker equal to:
1075      *    [Amount owed to maker] + [Maker rebate amount] - [Maker fee] - [Maker gas cost]
1076      *  - Since the taker saved all the maker fees and gas costs, it can then send them as a single
1077      *    batch transaction to the relayer, equal to:
1078      *    [All maker and taker fees] + [All maker and taker gas costs] - [All maker rebates]
1079      *
1080      * Thus in the end the taker will have the full amount of base token, sans the fee and cost of
1081      * their share of gas. Each maker will have their share of quote token, including their rebate,
1082      * but sans the fee and cost of their share of gas. The relayer will end up with the fees from
1083      * the taker and each maker (sans rebates), and the gas costs will pay for the transactions.
1084      *
1085      * In this scenario, with n makers there will be 2n + 1 transactions, which will be a significant
1086      * gas savings over the original method.
1087      *
1088      * @param results List of Types.MatchResult objects representing each individual trade to settle.
1089      * @param takerOrderParam The Types.OrderParam object representing the taker order data.
1090      * @param orderAddressSet An object containing addresses common across each order.
1091      */
1092     function settleResults(
1093         Store.State storage state,
1094         Types.MatchResult[] memory results,
1095         Types.OrderParam memory takerOrderParam,
1096         Types.OrderAddressSet memory orderAddressSet
1097     )
1098         private
1099     {
1100         bool isTakerSell = takerOrderParam.isSell();
1101 
1102         uint256 totalFee = 0;
1103 
1104         Types.BalancePath memory relayerBalancePath = Types.BalancePath({
1105             user: orderAddressSet.relayer,
1106             marketID: 0,
1107             category: Types.BalanceCategory.Common
1108         });
1109 
1110         for (uint256 i = 0; i < results.length; i++) {
1111             Transfer.transfer(
1112                 state,
1113                 orderAddressSet.baseAsset,
1114                 isTakerSell ? results[i].takerBalancePath : results[i].makerBalancePath,
1115                 isTakerSell ? results[i].makerBalancePath : results[i].takerBalancePath,
1116                 results[i].baseAssetFilledAmount
1117             );
1118 
1119             uint256 transferredQuoteAmount;
1120 
1121             if(isTakerSell) {
1122                 transferredQuoteAmount = results[i].quoteAssetFilledAmount.
1123                     add(results[i].makerFee).
1124                     add(results[i].makerGasFee).
1125                     sub(results[i].makerRebate);
1126             } else {
1127                 transferredQuoteAmount = results[i].quoteAssetFilledAmount.
1128                     sub(results[i].makerFee).
1129                     sub(results[i].makerGasFee).
1130                     add(results[i].makerRebate);
1131             }
1132 
1133             Transfer.transfer(
1134                 state,
1135                 orderAddressSet.quoteAsset,
1136                 isTakerSell ? results[i].makerBalancePath : results[i].takerBalancePath,
1137                 isTakerSell ? results[i].takerBalancePath : results[i].makerBalancePath,
1138                 transferredQuoteAmount
1139             );
1140 
1141             Requires.requireCollateralAccountNotLiquidatable(state, results[i].makerBalancePath);
1142 
1143             totalFee = totalFee.add(results[i].takerFee).add(results[i].makerFee);
1144             totalFee = totalFee.add(results[i].makerGasFee).add(results[i].takerGasFee);
1145             totalFee = totalFee.sub(results[i].makerRebate);
1146 
1147             Events.logMatch(results[i], orderAddressSet);
1148         }
1149 
1150         Transfer.transfer(
1151             state,
1152             orderAddressSet.quoteAsset,
1153             results[0].takerBalancePath,
1154             relayerBalancePath,
1155             totalFee
1156         );
1157 
1158         Requires.requireCollateralAccountNotLiquidatable(state, results[0].takerBalancePath);
1159     }
1160 }
1161 
1162 library Relayer {
1163     /**
1164      * Approve an address to match orders on behalf of msg.sender
1165      */
1166     function approveDelegate(
1167         Store.State storage state,
1168         address delegate
1169     )
1170         internal
1171     {
1172         state.relayer.relayerDelegates[msg.sender][delegate] = true;
1173         Events.logRelayerApproveDelegate(msg.sender, delegate);
1174     }
1175 
1176     /**
1177      * Revoke an existing delegate
1178      */
1179     function revokeDelegate(
1180         Store.State storage state,
1181         address delegate
1182     )
1183         internal
1184     {
1185         state.relayer.relayerDelegates[msg.sender][delegate] = false;
1186         Events.logRelayerRevokeDelegate(msg.sender, delegate);
1187     }
1188 
1189     /**
1190      * @return true if msg.sender is allowed to match orders which belong to relayer
1191      */
1192     function canMatchOrdersFrom(
1193         Store.State storage state,
1194         address relayer
1195     )
1196         internal
1197         view
1198         returns(bool)
1199     {
1200         return msg.sender == relayer || state.relayer.relayerDelegates[relayer][msg.sender] == true;
1201     }
1202 
1203     /**
1204      * Join the Hydro incentive system.
1205      */
1206     function joinIncentiveSystem(
1207         Store.State storage state
1208     )
1209         internal
1210     {
1211         delete state.relayer.hasExited[msg.sender];
1212         Events.logRelayerJoin(msg.sender);
1213     }
1214 
1215     /**
1216      * Exit the Hydro incentive system.
1217      * For relayers that choose to opt-out, the Hydro Protocol
1218      * effective becomes a tokenless protocol.
1219      */
1220     function exitIncentiveSystem(
1221         Store.State storage state
1222     )
1223         internal
1224     {
1225         state.relayer.hasExited[msg.sender] = true;
1226         Events.logRelayerExit(msg.sender);
1227     }
1228 
1229     /**
1230      * @return true if relayer is participating in the Hydro incentive system.
1231      */
1232     function isParticipant(
1233         Store.State storage state,
1234         address relayer
1235     )
1236         internal
1237         view
1238         returns(bool)
1239     {
1240         return !state.relayer.hasExited[relayer];
1241     }
1242 }
1243 
1244 library Auctions {
1245     using SafeMath for uint256;
1246     using SafeMath for int256;
1247     using Auction for Types.Auction;
1248 
1249     /**
1250      * Liquidate a collateral account
1251      */
1252     function liquidate(
1253         Store.State storage state,
1254         address user,
1255         uint16 marketID
1256     )
1257         external
1258         returns (bool, uint32)
1259     {
1260         // if the account is in liquidate progress, liquidatable will be false
1261         Types.CollateralAccountDetails memory details = CollateralAccounts.getDetails(
1262             state,
1263             user,
1264             marketID
1265         );
1266 
1267         require(details.liquidatable, "ACCOUNT_NOT_LIQUIDABLE");
1268 
1269         Types.Market storage market = state.markets[marketID];
1270         Types.CollateralAccount storage account = state.accounts[user][marketID];
1271 
1272         LendingPool.repay(
1273             state,
1274             user,
1275             marketID,
1276             market.baseAsset,
1277             account.balances[market.baseAsset]
1278         );
1279 
1280         LendingPool.repay(
1281             state,
1282             user,
1283             marketID,
1284             market.quoteAsset,
1285             account.balances[market.quoteAsset]
1286         );
1287 
1288         address collateralAsset;
1289         address debtAsset;
1290 
1291         uint256 leftBaseAssetDebt = LendingPool.getAmountBorrowed(
1292             state,
1293             market.baseAsset,
1294             user,
1295             marketID
1296         );
1297 
1298         uint256 leftQuoteAssetDebt = LendingPool.getAmountBorrowed(
1299             state,
1300             market.quoteAsset,
1301             user,
1302             marketID
1303         );
1304 
1305         bool hasAution = !(leftBaseAssetDebt == 0 && leftQuoteAssetDebt == 0);
1306 
1307         Events.logLiquidate(
1308             user,
1309             marketID,
1310             hasAution
1311         );
1312 
1313         if (!hasAution) {
1314             // no auction
1315             return (false, 0);
1316         }
1317 
1318         account.status = Types.CollateralAccountStatus.Liquid;
1319 
1320         if(account.balances[market.baseAsset] > 0) {
1321             // quote asset is debt, base asset is collateral
1322             collateralAsset = market.baseAsset;
1323             debtAsset = market.quoteAsset;
1324         } else {
1325             // base asset is debt, quote asset is collateral
1326             collateralAsset = market.quoteAsset;
1327             debtAsset = market.baseAsset;
1328         }
1329 
1330         uint32 newAuctionID = create(
1331             state,
1332             marketID,
1333             user,
1334             msg.sender,
1335             debtAsset,
1336             collateralAsset
1337         );
1338 
1339         return (true, newAuctionID);
1340     }
1341 
1342     function fillHealthyAuction(
1343         Store.State storage state,
1344         Types.Auction storage auction,
1345         uint256 ratio,
1346         uint256 repayAmount
1347     )
1348         private
1349         returns (uint256, uint256) // bidderRepay collateral
1350     {
1351         uint256 leftDebtAmount = LendingPool.getAmountBorrowed(
1352             state,
1353             auction.debtAsset,
1354             auction.borrower,
1355             auction.marketID
1356         );
1357 
1358         // get remaining collateral
1359         uint256 leftCollateralAmount = state.accounts[auction.borrower][auction.marketID].balances[auction.collateralAsset];
1360 
1361         state.accounts[auction.borrower][auction.marketID].balances[auction.debtAsset] = repayAmount;
1362 
1363         // borrower pays back to the lending pool
1364         uint256 actualRepayAmount = LendingPool.repay(
1365             state,
1366             auction.borrower,
1367             auction.marketID,
1368             auction.debtAsset,
1369             repayAmount
1370         );
1371 
1372         state.accounts[auction.borrower][auction.marketID].balances[auction.debtAsset] = 0;
1373 
1374         // compute how much collateral is divided up amongst the bidder, auction initiator, and borrower
1375         state.balances[msg.sender][auction.debtAsset] = SafeMath.sub(
1376             state.balances[msg.sender][auction.debtAsset],
1377             actualRepayAmount
1378         );
1379 
1380         uint256 collateralToProcess = leftCollateralAmount.mul(actualRepayAmount).div(leftDebtAmount);
1381         uint256 collateralForBidder = Decimal.mulFloor(collateralToProcess, ratio);
1382 
1383         uint256 collateralForInitiator = Decimal.mulFloor(collateralToProcess.sub(collateralForBidder), state.auction.initiatorRewardRatio);
1384         uint256 collateralForBorrower = collateralToProcess.sub(collateralForBidder).sub(collateralForInitiator);
1385 
1386         // update remaining collateral ammount
1387         state.accounts[auction.borrower][auction.marketID].balances[auction.collateralAsset] = SafeMath.sub(
1388             state.accounts[auction.borrower][auction.marketID].balances[auction.collateralAsset],
1389             collateralToProcess
1390         );
1391 
1392         // send a portion of collateral to the bidder
1393         state.balances[msg.sender][auction.collateralAsset] = SafeMath.add(
1394             state.balances[msg.sender][auction.collateralAsset],
1395             collateralForBidder
1396         );
1397 
1398         // send a portion of collateral to the initiator
1399         state.balances[auction.initiator][auction.collateralAsset] = SafeMath.add(
1400             state.balances[auction.initiator][auction.collateralAsset],
1401             collateralForInitiator
1402         );
1403 
1404         // send a portion of collateral to the borrower
1405         state.balances[auction.borrower][auction.collateralAsset] = SafeMath.add(
1406             state.balances[auction.borrower][auction.collateralAsset],
1407             collateralForBorrower
1408         );
1409 
1410         // withdraw collateralForBorrower to borrower's wallet account
1411         Transfer.withdraw(
1412             state,
1413             auction.borrower,
1414             auction.collateralAsset,
1415             collateralForBorrower
1416         );
1417 
1418         return (actualRepayAmount, collateralForBidder);
1419     }
1420 
1421     /**
1422      * Msg.sender only need to afford bidderRepayAmount and get collateralAmount
1423      * insurance and suppliers will cover the badDebtAmount
1424      */
1425     function fillBadAuction(
1426         Store.State storage state,
1427         Types.Auction storage auction,
1428         uint256 ratio,
1429         uint256 bidderRepayAmount
1430     )
1431         private
1432         returns (uint256, uint256, uint256) // totalRepay bidderRepay collateral
1433     {
1434 
1435         uint256 leftDebtAmount = LendingPool.getAmountBorrowed(
1436             state,
1437             auction.debtAsset,
1438             auction.borrower,
1439             auction.marketID
1440         );
1441 
1442         uint256 leftCollateralAmount = state.accounts[auction.borrower][auction.marketID].balances[auction.collateralAsset];
1443 
1444         uint256 repayAmount = Decimal.mulFloor(bidderRepayAmount, ratio);
1445 
1446         state.accounts[auction.borrower][auction.marketID].balances[auction.debtAsset] = repayAmount;
1447 
1448         uint256 actualRepayAmount = LendingPool.repay(
1449             state,
1450             auction.borrower,
1451             auction.marketID,
1452             auction.debtAsset,
1453             repayAmount
1454         );
1455 
1456         state.accounts[auction.borrower][auction.marketID].balances[auction.debtAsset] = 0; // recover unused principal
1457 
1458         uint256 actualBidderRepay = bidderRepayAmount;
1459 
1460         if (actualRepayAmount < repayAmount) {
1461             actualBidderRepay = Decimal.divCeil(actualRepayAmount, ratio);
1462         }
1463 
1464         // gather repay capital
1465         LendingPool.claimInsurance(state, auction.debtAsset, actualRepayAmount.sub(actualBidderRepay));
1466 
1467         state.balances[msg.sender][auction.debtAsset] = SafeMath.sub(
1468             state.balances[msg.sender][auction.debtAsset],
1469             actualBidderRepay
1470         );
1471 
1472         // update collateralAmount
1473         uint256 collateralForBidder = leftCollateralAmount.mul(actualRepayAmount).div(leftDebtAmount);
1474 
1475         state.accounts[auction.borrower][auction.marketID].balances[auction.collateralAsset] = SafeMath.sub(
1476             state.accounts[auction.borrower][auction.marketID].balances[auction.collateralAsset],
1477             collateralForBidder
1478         );
1479 
1480         // bidder receive collateral
1481         state.balances[msg.sender][auction.collateralAsset] = SafeMath.add(
1482             state.balances[msg.sender][auction.collateralAsset],
1483             collateralForBidder
1484         );
1485 
1486         return (actualRepayAmount, actualBidderRepay, collateralForBidder);
1487     }
1488 
1489     // ensure repay no more than repayAmount
1490     function fillAuctionWithAmount(
1491         Store.State storage state,
1492         uint32 auctionID,
1493         uint256 repayAmount
1494     )
1495         external
1496     {
1497         Types.Auction storage auction = state.auction.auctions[auctionID];
1498         uint256 ratio = auction.ratio(state);
1499 
1500         uint256 actualRepayAmount;
1501         uint256 actualBidderRepayAmount;
1502         uint256 collateralForBidder;
1503 
1504         if (ratio <= Decimal.one()) {
1505             (actualRepayAmount, collateralForBidder) = fillHealthyAuction(state, auction, ratio, repayAmount);
1506             actualBidderRepayAmount = actualRepayAmount;
1507         } else {
1508             (actualRepayAmount, actualBidderRepayAmount, collateralForBidder) = fillBadAuction(state, auction, ratio, repayAmount);
1509         }
1510 
1511         // reset account state if all debts are paid
1512         uint256 leftDebtAmount = LendingPool.getAmountBorrowed(
1513             state,
1514             auction.debtAsset,
1515             auction.borrower,
1516             auction.marketID
1517         );
1518 
1519         Events.logFillAuction(auction.id, msg.sender, actualRepayAmount, actualBidderRepayAmount, collateralForBidder, leftDebtAmount);
1520 
1521         if (leftDebtAmount == 0) {
1522             endAuction(state, auction);
1523         }
1524     }
1525 
1526     /**
1527      * Mark an auction as finished.
1528      * An auction typically ends either when it becomes fully filled, or when it expires and is closed
1529      */
1530     function endAuction(
1531         Store.State storage state,
1532         Types.Auction storage auction
1533     )
1534         private
1535     {
1536         auction.status = Types.AuctionStatus.Finished;
1537 
1538         state.accounts[auction.borrower][auction.marketID].status = Types.CollateralAccountStatus.Normal;
1539 
1540         for (uint i = 0; i < state.auction.currentAuctions.length; i++) {
1541             if (state.auction.currentAuctions[i] == auction.id) {
1542                 state.auction.currentAuctions[i] = state.auction.currentAuctions[state.auction.currentAuctions.length-1];
1543                 state.auction.currentAuctions.length--;
1544                 return;
1545             }
1546         }
1547     }
1548 
1549     /**
1550      * Create a new auction and save it in global state
1551      */
1552     function create(
1553         Store.State storage state,
1554         uint16 marketID,
1555         address borrower,
1556         address initiator,
1557         address debtAsset,
1558         address collateralAsset
1559     )
1560         private
1561         returns (uint32)
1562     {
1563         uint32 id = state.auction.auctionsCount++;
1564 
1565         Types.Auction memory auction = Types.Auction({
1566             id: id,
1567             status: Types.AuctionStatus.InProgress,
1568             startBlockNumber: uint32(block.number),
1569             marketID: marketID,
1570             borrower: borrower,
1571             initiator: initiator,
1572             debtAsset: debtAsset,
1573             collateralAsset: collateralAsset
1574         });
1575 
1576         state.auction.auctions[id] = auction;
1577         state.auction.currentAuctions.push(id);
1578 
1579         Events.logAuctionCreate(id);
1580 
1581         return id;
1582     }
1583 
1584     // price = debt / collateral / ratio
1585     function getAuctionDetails(
1586         Store.State storage state,
1587         uint32 auctionID
1588     )
1589         external
1590         view
1591         returns (Types.AuctionDetails memory details)
1592     {
1593         Types.Auction memory auction = state.auction.auctions[auctionID];
1594 
1595         details.borrower = auction.borrower;
1596         details.marketID = auction.marketID;
1597         details.debtAsset = auction.debtAsset;
1598         details.collateralAsset = auction.collateralAsset;
1599 
1600         if (state.auction.auctions[auctionID].status == Types.AuctionStatus.Finished){
1601             details.finished = true;
1602         } else {
1603             details.finished = false;
1604             details.leftDebtAmount = LendingPool.getAmountBorrowed(
1605                 state,
1606                 auction.debtAsset,
1607                 auction.borrower,
1608                 auction.marketID
1609             );
1610             details.leftCollateralAmount = state.accounts[auction.borrower][auction.marketID].balances[auction.collateralAsset];
1611 
1612             details.ratio = auction.ratio(state);
1613 
1614             if (details.leftCollateralAmount != 0 && details.ratio != 0) {
1615                 // price = debt/collateral/ratio
1616                 details.price = Decimal.divFloor(Decimal.divFloor(details.leftDebtAmount, details.leftCollateralAmount), details.ratio);
1617             }
1618         }
1619     }
1620 }
1621 
1622 library BatchActions {
1623     using SafeMath for uint256;
1624     /**
1625      * All allowed actions types
1626      */
1627     enum ActionType {
1628         Deposit,   // Move asset from your wallet to tradeable balance
1629         Withdraw,  // Move asset from your tradeable balance to wallet
1630         Transfer,  // Move asset between tradeable balance and margin account
1631         Borrow,    // Borrow asset from pool
1632         Repay,     // Repay asset to pool
1633         Supply,    // Move asset from tradeable balance to pool to earn interest
1634         Unsupply   // Move asset from pool back to tradeable balance
1635     }
1636 
1637     /**
1638      * Uniform parameter for an action
1639      */
1640     struct Action {
1641         ActionType actionType;  // The action type
1642         bytes encodedParams;    // Encoded params, it's different for each action
1643     }
1644 
1645     /**
1646      * Batch actions entrance
1647      * @param actions List of actions
1648      */
1649     function batch(
1650         Store.State storage state,
1651         Action[] memory actions,
1652         uint256 msgValue
1653     )
1654         public
1655     {
1656         uint256 totalDepositedEtherAmount = 0;
1657 
1658         for (uint256 i = 0; i < actions.length; i++) {
1659             Action memory action = actions[i];
1660             ActionType actionType = action.actionType;
1661 
1662             if (actionType == ActionType.Deposit) {
1663                 uint256 depositedEtherAmount = deposit(state, action);
1664                 totalDepositedEtherAmount = totalDepositedEtherAmount.add(depositedEtherAmount);
1665             } else if (actionType == ActionType.Withdraw) {
1666                 withdraw(state, action);
1667             } else if (actionType == ActionType.Transfer) {
1668                 transfer(state, action);
1669             } else if (actionType == ActionType.Borrow) {
1670                 borrow(state, action);
1671             } else if (actionType == ActionType.Repay) {
1672                 repay(state, action);
1673             } else if (actionType == ActionType.Supply) {
1674                 supply(state, action);
1675             } else if (actionType == ActionType.Unsupply) {
1676                 unsupply(state, action);
1677             }
1678         }
1679 
1680         require(totalDepositedEtherAmount == msgValue, "MSG_VALUE_AND_AMOUNT_MISMATCH");
1681     }
1682 
1683     function deposit(
1684         Store.State storage state,
1685         Action memory action
1686     )
1687         private
1688         returns (uint256)
1689     {
1690         (
1691             address asset,
1692             uint256 amount
1693         ) = abi.decode(
1694             action.encodedParams,
1695             (
1696                 address,
1697                 uint256
1698             )
1699         );
1700 
1701         return Transfer.deposit(
1702             state,
1703             asset,
1704             amount
1705         );
1706     }
1707 
1708     function withdraw(
1709         Store.State storage state,
1710         Action memory action
1711     )
1712         private
1713     {
1714         (
1715             address asset,
1716             uint256 amount
1717         ) = abi.decode(
1718             action.encodedParams,
1719             (
1720                 address,
1721                 uint256
1722             )
1723         );
1724 
1725         Transfer.withdraw(
1726             state,
1727             msg.sender,
1728             asset,
1729             amount
1730         );
1731     }
1732 
1733     function transfer(
1734         Store.State storage state,
1735         Action memory action
1736     )
1737         private
1738     {
1739         (
1740             address asset,
1741             Types.BalancePath memory fromBalancePath,
1742             Types.BalancePath memory toBalancePath,
1743             uint256 amount
1744         ) = abi.decode(
1745             action.encodedParams,
1746             (
1747                 address,
1748                 Types.BalancePath,
1749                 Types.BalancePath,
1750                 uint256
1751             )
1752         );
1753 
1754         require(fromBalancePath.user == msg.sender, "CAN_NOT_MOVE_OTHER_USER_ASSET");
1755         require(toBalancePath.user == msg.sender, "CAN_NOT_MOVE_ASSET_TO_OTHER_USER");
1756 
1757         Requires.requirePathNormalStatus(state, fromBalancePath);
1758         Requires.requirePathNormalStatus(state, toBalancePath);
1759 
1760         // The below two requires will be checked in Transfer.transfer
1761         // Requires.requirePathMarketIDAssetMatch(state, fromBalancePath, asset);
1762         // Requires.requirePathMarketIDAssetMatch(state, toBalancePath, asset);
1763 
1764         if (fromBalancePath.category == Types.BalanceCategory.CollateralAccount) {
1765             require(
1766                 CollateralAccounts.getTransferableAmount(state, fromBalancePath.marketID, fromBalancePath.user, asset) >= amount,
1767                 "COLLATERAL_ACCOUNT_TRANSFERABLE_AMOUNT_NOT_ENOUGH"
1768             );
1769         }
1770 
1771         Transfer.transfer(
1772             state,
1773             asset,
1774             fromBalancePath,
1775             toBalancePath,
1776             amount
1777         );
1778 
1779         if (toBalancePath.category == Types.BalanceCategory.CollateralAccount) {
1780             Events.logIncreaseCollateral(msg.sender, toBalancePath.marketID, asset, amount);
1781         }
1782         if (fromBalancePath.category == Types.BalanceCategory.CollateralAccount) {
1783             Events.logDecreaseCollateral(msg.sender, fromBalancePath.marketID, asset, amount);
1784         }
1785     }
1786 
1787     function borrow(
1788         Store.State storage state,
1789         Action memory action
1790     )
1791         private
1792     {
1793         (
1794             uint16 marketID,
1795             address asset,
1796             uint256 amount
1797         ) = abi.decode(
1798             action.encodedParams,
1799             (
1800                 uint16,
1801                 address,
1802                 uint256
1803             )
1804         );
1805 
1806         Requires.requireMarketIDExist(state, marketID);
1807         Requires.requireMarketBorrowEnabled(state, marketID);
1808         Requires.requireMarketIDAndAssetMatch(state, marketID, asset);
1809         Requires.requireAccountNormal(state, marketID, msg.sender);
1810         LendingPool.borrow(
1811             state,
1812             msg.sender,
1813             marketID,
1814             asset,
1815             amount
1816         );
1817     }
1818 
1819     function repay(
1820         Store.State storage state,
1821         Action memory action
1822     )
1823         private
1824     {
1825         (
1826             uint16 marketID,
1827             address asset,
1828             uint256 amount
1829         ) = abi.decode(
1830             action.encodedParams,
1831             (
1832                 uint16,
1833                 address,
1834                 uint256
1835             )
1836         );
1837 
1838         Requires.requireMarketIDExist(state, marketID);
1839         Requires.requireMarketIDAndAssetMatch(state, marketID, asset);
1840 
1841         LendingPool.repay(
1842             state,
1843             msg.sender,
1844             marketID,
1845             asset,
1846             amount
1847         );
1848     }
1849 
1850     function supply(
1851         Store.State storage state,
1852         Action memory action
1853     )
1854         private
1855     {
1856         (
1857             address asset,
1858             uint256 amount
1859         ) = abi.decode(
1860             action.encodedParams,
1861             (
1862                 address,
1863                 uint256
1864             )
1865         );
1866 
1867         Requires.requireAssetExist(state, asset);
1868         LendingPool.supply(
1869             state,
1870             asset,
1871             amount,
1872             msg.sender
1873         );
1874     }
1875 
1876     function unsupply(
1877         Store.State storage state,
1878         Action memory action
1879     )
1880         private
1881     {
1882         (
1883             address asset,
1884             uint256 amount
1885         ) = abi.decode(
1886             action.encodedParams,
1887             (
1888                 address,
1889                 uint256
1890             )
1891         );
1892 
1893         Requires.requireAssetExist(state, asset);
1894         LendingPool.unsupply(
1895             state,
1896             asset,
1897             amount,
1898             msg.sender
1899         );
1900     }
1901 }
1902 
1903 library CollateralAccounts {
1904     using SafeMath for uint256;
1905 
1906     function getDetails(
1907         Store.State storage state,
1908         address user,
1909         uint16 marketID
1910     )
1911         internal
1912         view
1913         returns (Types.CollateralAccountDetails memory details)
1914     {
1915         Types.CollateralAccount storage account = state.accounts[user][marketID];
1916         Types.Market storage market = state.markets[marketID];
1917 
1918         details.status = account.status;
1919 
1920         address baseAsset = market.baseAsset;
1921         address quoteAsset = market.quoteAsset;
1922 
1923         uint256 baseUSDPrice = AssemblyCall.getAssetPriceFromPriceOracle(
1924             address(state.assets[baseAsset].priceOracle),
1925             baseAsset
1926         );
1927         uint256 quoteUSDPrice = AssemblyCall.getAssetPriceFromPriceOracle(
1928             address(state.assets[quoteAsset].priceOracle),
1929             quoteAsset
1930         );
1931 
1932         uint256 baseBorrowOf = LendingPool.getAmountBorrowed(state, baseAsset, user, marketID);
1933         uint256 quoteBorrowOf = LendingPool.getAmountBorrowed(state, quoteAsset, user, marketID);
1934 
1935         details.debtsTotalUSDValue = SafeMath.add(
1936             baseBorrowOf.mul(baseUSDPrice),
1937             quoteBorrowOf.mul(quoteUSDPrice)
1938         ) / Decimal.one();
1939 
1940         details.balancesTotalUSDValue = SafeMath.add(
1941             account.balances[baseAsset].mul(baseUSDPrice),
1942             account.balances[quoteAsset].mul(quoteUSDPrice)
1943         ) / Decimal.one();
1944 
1945         if (details.status == Types.CollateralAccountStatus.Normal) {
1946             details.liquidatable = details.balancesTotalUSDValue < Decimal.mulCeil(details.debtsTotalUSDValue, market.liquidateRate);
1947         } else {
1948             details.liquidatable = false;
1949         }
1950     }
1951 
1952     /**
1953      * Get the amount that is avaliable to transfer out of the collateral account.
1954      *
1955      * If there are no open loans, this is just the total asset balance.
1956      *
1957      * If there are open loans, then this is the maximum amount that can be withdrawn
1958      *   without falling below the withdraw collateral ratio
1959      */
1960     function getTransferableAmount(
1961         Store.State storage state,
1962         uint16 marketID,
1963         address user,
1964         address asset
1965     )
1966         internal
1967         view
1968         returns (uint256)
1969     {
1970         Types.CollateralAccountDetails memory details = getDetails(state, user, marketID);
1971 
1972         // already checked at batch operation
1973         // liquidating or liquidatable account can't move asset
1974 
1975         uint256 assetBalance = state.accounts[user][marketID].balances[asset];
1976 
1977         // If and only if balance USD value is larger than transferableUSDValueBar, the user is able to withdraw some assets
1978         uint256 transferableThresholdUSDValue = Decimal.mulCeil(
1979             details.debtsTotalUSDValue,
1980             state.markets[marketID].withdrawRate
1981         );
1982 
1983         if(transferableThresholdUSDValue > details.balancesTotalUSDValue) {
1984             return 0;
1985         } else {
1986             uint256 transferableUSD = details.balancesTotalUSDValue - transferableThresholdUSDValue;
1987             uint256 assetUSDPrice = state.assets[asset].priceOracle.getPrice(asset);
1988             uint256 transferableAmount = Decimal.divFloor(transferableUSD, assetUSDPrice);
1989             if (transferableAmount > assetBalance) {
1990                 return assetBalance;
1991             } else {
1992                 return transferableAmount;
1993             }
1994         }
1995     }
1996 }
1997 
1998 library LendingPool {
1999     using SafeMath for uint256;
2000     using SafeMath for int256;
2001 
2002     uint256 private constant SECONDS_OF_YEAR = 31536000;
2003 
2004     // create new pool
2005     function initializeAssetLendingPool(
2006         Store.State storage state,
2007         address asset
2008     )
2009         internal
2010     {
2011         // indexes starts at 1 for easy computation
2012         state.pool.borrowIndex[asset] = Decimal.one();
2013         state.pool.supplyIndex[asset] = Decimal.one();
2014 
2015         // record starting time for the pool
2016         state.pool.indexStartTime[asset] = block.timestamp;
2017     }
2018 
2019     /**
2020      * Supply asset into the pool. Supplied asset in the pool gains interest.
2021      */
2022     function supply(
2023         Store.State storage state,
2024         address asset,
2025         uint256 amount,
2026         address user
2027     )
2028         internal
2029     {
2030         // update value of index at this moment in time
2031         updateIndex(state, asset);
2032 
2033         // transfer asset from user's balance account
2034         Transfer.transferOut(state, asset, BalancePath.getCommonPath(user), amount);
2035 
2036         // compute the normalized value of 'amount'
2037         // round floor
2038         uint256 normalizedAmount = Decimal.divFloor(amount, state.pool.supplyIndex[asset]);
2039 
2040         // mint normalizedAmount of pool token for user
2041         state.assets[asset].lendingPoolToken.mint(user, normalizedAmount);
2042 
2043         // update interest rate based on latest state
2044         updateInterestRate(state, asset);
2045 
2046         Events.logSupply(user, asset, amount);
2047     }
2048 
2049     /**
2050      * unsupply asset from the pool, up to initial asset supplied plus interest
2051      */
2052     function unsupply(
2053         Store.State storage state,
2054         address asset,
2055         uint256 amount,
2056         address user
2057     )
2058         internal
2059         returns (uint256)
2060     {
2061         // update value of index at this moment in time
2062         updateIndex(state, asset);
2063 
2064         // compute the normalized value of 'amount'
2065         // round ceiling
2066         uint256 normalizedAmount = Decimal.divCeil(amount, state.pool.supplyIndex[asset]);
2067 
2068         uint256 unsupplyAmount = amount;
2069 
2070         // check and cap the amount so user can't overdraw
2071         if (getNormalizedSupplyOf(state, asset, user) <= normalizedAmount) {
2072             normalizedAmount = getNormalizedSupplyOf(state, asset, user);
2073             unsupplyAmount = Decimal.mulFloor(normalizedAmount, state.pool.supplyIndex[asset]);
2074         }
2075 
2076         // transfer asset to user's balance account
2077         Transfer.transferIn(state, asset, BalancePath.getCommonPath(user), unsupplyAmount);
2078         Requires.requireCashLessThanOrEqualContractBalance(state, asset);
2079 
2080         // subtract normalizedAmount from the pool
2081         state.assets[asset].lendingPoolToken.burn(user, normalizedAmount);
2082 
2083         // update interest rate based on latest state
2084         updateInterestRate(state, asset);
2085 
2086         Events.logUnsupply(user, asset, unsupplyAmount);
2087 
2088         return unsupplyAmount;
2089     }
2090 
2091     /**
2092      * Borrow money from the lending pool.
2093      */
2094     function borrow(
2095         Store.State storage state,
2096         address user,
2097         uint16 marketID,
2098         address asset,
2099         uint256 amount
2100     )
2101         internal
2102     {
2103         // update value of index at this moment in time
2104         updateIndex(state, asset);
2105 
2106         // compute the normalized value of 'amount'
2107         uint256 normalizedAmount = Decimal.divCeil(amount, state.pool.borrowIndex[asset]);
2108 
2109         // transfer assets to user's balance account
2110         Transfer.transferIn(state, asset, BalancePath.getMarketPath(user, marketID), amount);
2111         Requires.requireCashLessThanOrEqualContractBalance(state, asset);
2112 
2113         // update normalized amount borrowed by user
2114         state.pool.normalizedBorrow[user][marketID][asset] = state.pool.normalizedBorrow[user][marketID][asset].add(normalizedAmount);
2115 
2116         // update normalized amount borrowed from the pool
2117         state.pool.normalizedTotalBorrow[asset] = state.pool.normalizedTotalBorrow[asset].add(normalizedAmount);
2118 
2119         // update interest rate based on latest state
2120         updateInterestRate(state, asset);
2121 
2122         Requires.requireCollateralAccountNotLiquidatable(state, user, marketID);
2123 
2124         Events.logBorrow(user, marketID, asset, amount);
2125     }
2126 
2127     /**
2128      * repay money borrowed money from the pool.
2129      */
2130     function repay(
2131         Store.State storage state,
2132         address user,
2133         uint16 marketID,
2134         address asset,
2135         uint256 amount
2136     )
2137         internal
2138         returns (uint256)
2139     {
2140         // update value of index at this moment in time
2141         updateIndex(state, asset);
2142 
2143         // get normalized value of amount to be repaid, which in effect take into account interest
2144         // (ex: if you borrowed 10, with index at 1.1, amount repaid needs to be 11 to make 11/1.1 = 10)
2145         uint256 normalizedAmount = Decimal.divFloor(amount, state.pool.borrowIndex[asset]);
2146 
2147         uint256 repayAmount = amount;
2148 
2149         // make sure user cannot repay more than amount owed
2150         if (state.pool.normalizedBorrow[user][marketID][asset] <= normalizedAmount) {
2151             normalizedAmount = state.pool.normalizedBorrow[user][marketID][asset];
2152             // repayAmount <= amount
2153             // because ⌈⌊a/b⌋*b⌉ <= a
2154             repayAmount = Decimal.mulCeil(normalizedAmount, state.pool.borrowIndex[asset]);
2155         }
2156 
2157         // transfer assets from user's balance account
2158         Transfer.transferOut(state, asset, BalancePath.getMarketPath(user, marketID), repayAmount);
2159 
2160         // update amount(normalized) borrowed by user
2161         state.pool.normalizedBorrow[user][marketID][asset] = state.pool.normalizedBorrow[user][marketID][asset].sub(normalizedAmount);
2162 
2163         // update total amount(normalized) borrowed from pool
2164         state.pool.normalizedTotalBorrow[asset] = state.pool.normalizedTotalBorrow[asset].sub(normalizedAmount);
2165 
2166         // update interest rate
2167         updateInterestRate(state, asset);
2168 
2169         Events.logRepay(user, marketID, asset, repayAmount);
2170 
2171         return repayAmount;
2172     }
2173 
2174     /**
2175      * This method is called if a loan could not be paid back by the borrower, auction, or insurance,
2176      * in which case the generalized loss is recognized across all lenders.
2177      */
2178     function recognizeLoss(
2179         Store.State storage state,
2180         address asset,
2181         uint256 amount
2182     )
2183         internal
2184     {
2185         uint256 totalnormalizedSupply = getTotalNormalizedSupply(
2186             state,
2187             asset
2188         );
2189 
2190         uint256 actualSupply = getTotalSupply(
2191             state,
2192             asset
2193         ).sub(amount);
2194 
2195         state.pool.supplyIndex[asset] = Decimal.divFloor(
2196             actualSupply,
2197             totalnormalizedSupply
2198         );
2199 
2200         updateIndex(state, asset);
2201 
2202         Events.logLoss(asset, amount);
2203     }
2204 
2205     /**
2206      * Claim an amount from the insurance pool, in return for all the collateral.
2207      * Only called if an auction expired without being filled.
2208      */
2209     function claimInsurance(
2210         Store.State storage state,
2211         address asset,
2212         uint256 amount
2213     )
2214         internal
2215     {
2216         uint256 insuranceBalance = state.pool.insuranceBalances[asset];
2217 
2218         uint256 compensationAmount = SafeMath.min(amount, insuranceBalance);
2219 
2220         state.cash[asset] = state.cash[asset].add(amount);
2221 
2222         // remove compensationAmount from insurance balances
2223         state.pool.insuranceBalances[asset] = SafeMath.sub(
2224             state.pool.insuranceBalances[asset],
2225             compensationAmount
2226         );
2227 
2228         // all suppliers pay debt if insurance not enough
2229         if (compensationAmount < amount) {
2230             recognizeLoss(
2231                 state,
2232                 asset,
2233                 amount.sub(compensationAmount)
2234             );
2235         }
2236 
2237         Events.logInsuranceCompensation(
2238             asset,
2239             compensationAmount
2240         );
2241 
2242     }
2243 
2244     function updateInterestRate(
2245         Store.State storage state,
2246         address asset
2247     )
2248         private
2249     {
2250         (uint256 borrowInterestRate, uint256 supplyInterestRate) = getInterestRates(state, asset, 0);
2251         state.pool.borrowAnnualInterestRate[asset] = borrowInterestRate;
2252         state.pool.supplyAnnualInterestRate[asset] = supplyInterestRate;
2253     }
2254 
2255     // get interestRate
2256     function getInterestRates(
2257         Store.State storage state,
2258         address asset,
2259         uint256 extraBorrowAmount
2260     )
2261         internal
2262         view
2263         returns (uint256 borrowInterestRate, uint256 supplyInterestRate)
2264     {
2265         (uint256 currentSupplyIndex, uint256 currentBorrowIndex) = getCurrentIndex(state, asset);
2266 
2267         uint256 _supply = getTotalSupplyWithIndex(state, asset, currentSupplyIndex);
2268 
2269         if (_supply == 0) {
2270             return (0, 0);
2271         }
2272 
2273         uint256 _borrow = getTotalBorrowWithIndex(state, asset, currentBorrowIndex).add(extraBorrowAmount);
2274 
2275         uint256 borrowRatio = _borrow.mul(Decimal.one()).div(_supply);
2276 
2277         borrowInterestRate = AssemblyCall.getBorrowInterestRate(
2278             address(state.assets[asset].interestModel),
2279             borrowRatio
2280         );
2281         require(borrowInterestRate <= 3 * Decimal.one(), "BORROW_INTEREST_RATE_EXCEED_300%");
2282 
2283         uint256 borrowInterest = Decimal.mulCeil(_borrow, borrowInterestRate);
2284         uint256 supplyInterest = Decimal.mulFloor(borrowInterest, Decimal.one().sub(state.pool.insuranceRatio));
2285 
2286         supplyInterestRate = Decimal.divFloor(supplyInterest, _supply);
2287     }
2288 
2289     /**
2290      * update the index value
2291      */
2292     function updateIndex(
2293         Store.State storage state,
2294         address asset
2295     )
2296         private
2297     {
2298         if (state.pool.indexStartTime[asset] == block.timestamp) {
2299             return;
2300         }
2301 
2302         (uint256 currentSupplyIndex, uint256 currentBorrowIndex) = getCurrentIndex(state, asset);
2303 
2304         // get the total equity value
2305         uint256 normalizedBorrow = state.pool.normalizedTotalBorrow[asset];
2306         uint256 normalizedSupply = getTotalNormalizedSupply(state, asset);
2307 
2308         // interest = equity value * (current index value - starting index value)
2309         uint256 recentBorrowInterest = Decimal.mulCeil(
2310             normalizedBorrow,
2311             currentBorrowIndex.sub(state.pool.borrowIndex[asset])
2312         );
2313 
2314         uint256 recentSupplyInterest = Decimal.mulFloor(
2315             normalizedSupply,
2316             currentSupplyIndex.sub(state.pool.supplyIndex[asset])
2317         );
2318 
2319         // the interest rate spread goes into the insurance pool
2320         state.pool.insuranceBalances[asset] = state.pool.insuranceBalances[asset].add(recentBorrowInterest.sub(recentSupplyInterest));
2321 
2322         // update the indexes
2323         Events.logUpdateIndex(
2324             asset,
2325             state.pool.borrowIndex[asset],
2326             currentBorrowIndex,
2327             state.pool.supplyIndex[asset],
2328             currentSupplyIndex
2329         );
2330 
2331         state.pool.supplyIndex[asset] = currentSupplyIndex;
2332         state.pool.borrowIndex[asset] = currentBorrowIndex;
2333         state.pool.indexStartTime[asset] = block.timestamp;
2334 
2335     }
2336 
2337     function getAmountSupplied(
2338         Store.State storage state,
2339         address asset,
2340         address user
2341     )
2342         internal
2343         view
2344         returns (uint256)
2345     {
2346         (uint256 currentSupplyIndex, ) = getCurrentIndex(state, asset);
2347         return Decimal.mulFloor(getNormalizedSupplyOf(state, asset, user), currentSupplyIndex);
2348     }
2349 
2350     function getAmountBorrowed(
2351         Store.State storage state,
2352         address asset,
2353         address user,
2354         uint16 marketID
2355     )
2356         internal
2357         view
2358         returns (uint256)
2359     {
2360         // the actual amount borrowed = normalizedAmount * poolIndex
2361         (, uint256 currentBorrowIndex) = getCurrentIndex(state, asset);
2362         return Decimal.mulCeil(state.pool.normalizedBorrow[user][marketID][asset], currentBorrowIndex);
2363     }
2364 
2365     function getTotalSupply(
2366         Store.State storage state,
2367         address asset
2368     )
2369         internal
2370         view
2371         returns (uint256)
2372     {
2373         (uint256 currentSupplyIndex, ) = getCurrentIndex(state, asset);
2374         return getTotalSupplyWithIndex(state, asset, currentSupplyIndex);
2375     }
2376 
2377     function getTotalBorrow(
2378         Store.State storage state,
2379         address asset
2380     )
2381         internal
2382         view
2383         returns (uint256)
2384     {
2385         (, uint256 currentBorrowIndex) = getCurrentIndex(state, asset);
2386         return getTotalBorrowWithIndex(state, asset, currentBorrowIndex);
2387     }
2388 
2389     function getTotalSupplyWithIndex(
2390         Store.State storage state,
2391         address asset,
2392         uint256 currentSupplyIndex
2393     )
2394         private
2395         view
2396         returns (uint256)
2397     {
2398         return Decimal.mulFloor(getTotalNormalizedSupply(state, asset), currentSupplyIndex);
2399     }
2400 
2401     function getTotalBorrowWithIndex(
2402         Store.State storage state,
2403         address asset,
2404         uint256 currentBorrowIndex
2405     )
2406         private
2407         view
2408         returns (uint256)
2409     {
2410         return Decimal.mulCeil(state.pool.normalizedTotalBorrow[asset], currentBorrowIndex);
2411     }
2412 
2413     /**
2414      * Compute the current value of poolIndex based on the time elapsed and the interest rate
2415      */
2416     function getCurrentIndex(
2417         Store.State storage state,
2418         address asset
2419     )
2420         internal
2421         view
2422         returns (uint256 currentSupplyIndex, uint256 currentBorrowIndex)
2423     {
2424         uint256 timeDelta = block.timestamp.sub(state.pool.indexStartTime[asset]);
2425 
2426         uint256 borrowInterestRate = state.pool.borrowAnnualInterestRate[asset]
2427             .mul(timeDelta).divCeil(SECONDS_OF_YEAR); // Ceil Ensure asset greater than liability
2428 
2429         uint256 supplyInterestRate = state.pool.supplyAnnualInterestRate[asset]
2430             .mul(timeDelta).div(SECONDS_OF_YEAR);
2431 
2432         currentBorrowIndex = Decimal.mulCeil(state.pool.borrowIndex[asset], Decimal.onePlus(borrowInterestRate));
2433         currentSupplyIndex = Decimal.mulFloor(state.pool.supplyIndex[asset], Decimal.onePlus(supplyInterestRate));
2434 
2435         return (currentSupplyIndex, currentBorrowIndex);
2436     }
2437 
2438     function getNormalizedSupplyOf(
2439         Store.State storage state,
2440         address asset,
2441         address user
2442     )
2443         private
2444         view
2445         returns (uint256)
2446     {
2447         return state.assets[asset].lendingPoolToken.balanceOf(user);
2448     }
2449 
2450     function getTotalNormalizedSupply(
2451         Store.State storage state,
2452         address asset
2453     )
2454         private
2455         view
2456         returns (uint256)
2457     {
2458         return state.assets[asset].lendingPoolToken.totalSupply();
2459     }
2460 }
2461 
2462 contract StandardToken {
2463     using SafeMath for uint256;
2464 
2465     mapping(address => uint256) balances;
2466     mapping (address => mapping (address => uint256)) internal allowed;
2467 
2468     event Transfer(address indexed from, address indexed to, uint256 amount);
2469     event Approval(address indexed owner, address indexed spender, uint256 amount);
2470 
2471     /**
2472     * @dev transfer token for a specified address
2473     * @param to The address to transfer to.
2474     * @param amount The amount to be transferred.
2475     */
2476     function transfer(
2477         address to,
2478         uint256 amount
2479     )
2480         public
2481         returns (bool)
2482     {
2483         require(to != address(0), "TO_ADDRESS_IS_EMPTY");
2484         require(amount <= balances[msg.sender], "BALANCE_NOT_ENOUGH");
2485 
2486         balances[msg.sender] = balances[msg.sender].sub(amount);
2487         balances[to] = balances[to].add(amount);
2488         emit Transfer(msg.sender, to, amount);
2489         return true;
2490     }
2491 
2492     /**
2493     * @dev Gets the balance of the specified address.
2494     * @param owner The address to query the the balance of.
2495     * @return An uint256 representing the amount owned by the passed address.
2496     */
2497     function balanceOf(address owner) public view returns (uint256 balance) {
2498         return balances[owner];
2499     }
2500 
2501     /**
2502     * @dev Transfer tokens from one address to another
2503     * @param from address The address which you want to send tokens from
2504     * @param to address The address which you want to transfer to
2505     * @param amount uint256 the amount of tokens to be transferred
2506     */
2507     function transferFrom(
2508         address from,
2509         address to,
2510         uint256 amount
2511     )
2512         public
2513         returns (bool)
2514     {
2515         require(to != address(0), "TO_ADDRESS_IS_EMPTY");
2516         require(amount <= balances[from], "BALANCE_NOT_ENOUGH");
2517         require(amount <= allowed[from][msg.sender], "ALLOWANCE_NOT_ENOUGH");
2518 
2519         balances[from] = balances[from].sub(amount);
2520         balances[to] = balances[to].add(amount);
2521         allowed[from][msg.sender] = allowed[from][msg.sender].sub(amount);
2522         emit Transfer(from, to, amount);
2523         return true;
2524     }
2525 
2526     /**
2527     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
2528     * @param spender The address which will spend the funds.
2529     * @param amount The amount of tokens to be spent.
2530     */
2531     function approve(
2532         address spender,
2533         uint256 amount
2534     )
2535         public
2536         returns (bool)
2537     {
2538         allowed[msg.sender][spender] = amount;
2539         emit Approval(msg.sender, spender, amount);
2540         return true;
2541     }
2542 
2543     /**
2544     * @dev Function to check the amount of tokens that an owner allowed to a spender.
2545     * @param owner address The address which owns the funds.
2546     * @param spender address The address which will spend the funds.
2547     * @return A uint256 specifying the amount of tokens still available for the spender.
2548     */
2549     function allowance(
2550         address owner,
2551         address spender
2552     )
2553         public
2554         view
2555         returns (uint256)
2556     {
2557         return allowed[owner][spender];
2558     }
2559 }
2560 
2561 interface IInterestModel {
2562     function polynomialInterestModel(
2563         uint256 borrowRatio
2564     )
2565         external
2566         pure
2567         returns(uint256);
2568 }
2569 
2570 interface ILendingPoolToken {
2571     function mint(
2572         address user,
2573         uint256 value
2574     )
2575         external;
2576 
2577     function burn(
2578         address user,
2579         uint256 value
2580     )
2581         external;
2582 
2583     function balanceOf(
2584         address user
2585     )
2586         external
2587         view
2588         returns (uint256);
2589 
2590     function totalSupply()
2591         external
2592         view
2593         returns (uint256);
2594 }
2595 
2596 interface IPriceOracle {
2597     /** return USD price of token */
2598     function getPrice(
2599         address asset
2600     )
2601         external
2602         view
2603         returns (uint256);
2604 }
2605 
2606 interface IStandardToken {
2607     function transfer(
2608         address _to,
2609         uint256 _amount
2610     )
2611         external
2612         returns (bool);
2613 
2614     function balanceOf(
2615         address _owner)
2616         external
2617         view
2618         returns (uint256 balance);
2619 
2620     function transferFrom(
2621         address _from,
2622         address _to,
2623         uint256 _amount
2624     )
2625         external
2626         returns (bool);
2627 
2628     function approve(
2629         address _spender,
2630         uint256 _amount
2631     )
2632         external
2633         returns (bool);
2634 
2635     function allowance(
2636         address _owner,
2637         address _spender
2638     )
2639         external
2640         view
2641         returns (uint256);
2642 }
2643 
2644 library AssemblyCall {
2645     function getAssetPriceFromPriceOracle(
2646         address oracleAddress,
2647         address asset
2648     )
2649         internal
2650         view
2651         returns (uint256)
2652     {
2653         // saves about 1200 gas.
2654         // return state.assets[asset].priceOracle.getPrice(asset);
2655 
2656         // keccak256('getPrice(address)') & 0xFFFFFFFF00000000000000000000000000000000000000000000000000000000
2657         bytes32 functionSelector = 0x41976e0900000000000000000000000000000000000000000000000000000000;
2658 
2659         (uint256 result, bool success) = callWith32BytesReturnsUint256(
2660             oracleAddress,
2661             functionSelector,
2662             bytes32(uint256(uint160(asset)))
2663         );
2664 
2665         if (!success) {
2666             revert("ASSEMBLY_CALL_GET_ASSET_PRICE_FAILED");
2667         }
2668 
2669         return result;
2670     }
2671 
2672     /**
2673      * Get the HOT token balance of an address.
2674      *
2675      * @param owner The address to check.
2676      * @return The HOT balance for the owner address.
2677      */
2678     function getHotBalance(
2679         address hotToken,
2680         address owner
2681     )
2682         internal
2683         view
2684         returns (uint256)
2685     {
2686         // saves about 1200 gas.
2687         // return HydroToken(hotToken).balanceOf(owner);
2688 
2689         // keccak256('balanceOf(address)') bitmasked to 4 bytes
2690         bytes32 functionSelector = 0x70a0823100000000000000000000000000000000000000000000000000000000;
2691 
2692         (uint256 result, bool success) = callWith32BytesReturnsUint256(
2693             hotToken,
2694             functionSelector,
2695             bytes32(uint256(uint160(owner)))
2696         );
2697 
2698         if (!success) {
2699             revert("ASSEMBLY_CALL_GET_HOT_BALANCE_FAILED");
2700         }
2701 
2702         return result;
2703     }
2704 
2705     function getBorrowInterestRate(
2706         address interestModel,
2707         uint256 borrowRatio
2708     )
2709         internal
2710         view
2711         returns (uint256)
2712     {
2713         // saves about 1200 gas.
2714         // return IInterestModel(interestModel).polynomialInterestModel(borrowRatio);
2715 
2716         // keccak256('polynomialInterestModel(uint256)') & 0xFFFFFFFF00000000000000000000000000000000000000000000000000000000
2717         bytes32 functionSelector = 0x69e8a15f00000000000000000000000000000000000000000000000000000000;
2718 
2719         (uint256 result, bool success) = callWith32BytesReturnsUint256(
2720             interestModel,
2721             functionSelector,
2722             bytes32(borrowRatio)
2723         );
2724 
2725         if (!success) {
2726             revert("ASSEMBLY_CALL_GET_BORROW_INTEREST_RATE_FAILED");
2727         }
2728 
2729         return result;
2730     }
2731 
2732     function callWith32BytesReturnsUint256(
2733         address to,
2734         bytes32 functionSelector,
2735         bytes32 param1
2736     )
2737         private
2738         view
2739         returns (uint256 result, bool success)
2740     {
2741         assembly {
2742             let freePtr := mload(0x40)
2743             let tmp1 := mload(freePtr)
2744             let tmp2 := mload(add(freePtr, 4))
2745 
2746             mstore(freePtr, functionSelector)
2747             mstore(add(freePtr, 4), param1)
2748 
2749             // call ERC20 Token contract transfer function
2750             success := staticcall(
2751                 gas,           // Forward all gas
2752                 to,            // Interest Model Address
2753                 freePtr,       // Pointer to start of calldata
2754                 36,            // Length of calldata
2755                 freePtr,       // Overwrite calldata with output
2756                 32             // Expecting uint256 output
2757             )
2758 
2759             result := mload(freePtr)
2760 
2761             mstore(freePtr, tmp1)
2762             mstore(add(freePtr, 4), tmp2)
2763         }
2764     }
2765 }
2766 
2767 library Consts {
2768     function ETHEREUM_TOKEN_ADDRESS()
2769         internal
2770         pure
2771         returns (address)
2772     {
2773         return 0x000000000000000000000000000000000000000E;
2774     }
2775 
2776     // The base discounted rate is 100% of the current rate, or no discount.
2777     function DISCOUNT_RATE_BASE()
2778         internal
2779         pure
2780         returns (uint256)
2781     {
2782         return 100;
2783     }
2784 
2785     function REBATE_RATE_BASE()
2786         internal
2787         pure
2788         returns (uint256)
2789     {
2790         return 100;
2791     }
2792 }
2793 
2794 library Decimal {
2795     using SafeMath for uint256;
2796 
2797     uint256 constant BASE = 10**18;
2798 
2799     function one()
2800         internal
2801         pure
2802         returns (uint256)
2803     {
2804         return BASE;
2805     }
2806 
2807     function onePlus(
2808         uint256 d
2809     )
2810         internal
2811         pure
2812         returns (uint256)
2813     {
2814         return d.add(BASE);
2815     }
2816 
2817     function mulFloor(
2818         uint256 target,
2819         uint256 d
2820     )
2821         internal
2822         pure
2823         returns (uint256)
2824     {
2825         return target.mul(d) / BASE;
2826     }
2827 
2828     function mulCeil(
2829         uint256 target,
2830         uint256 d
2831     )
2832         internal
2833         pure
2834         returns (uint256)
2835     {
2836         return target.mul(d).divCeil(BASE);
2837     }
2838 
2839     function divFloor(
2840         uint256 target,
2841         uint256 d
2842     )
2843         internal
2844         pure
2845         returns (uint256)
2846     {
2847         return target.mul(BASE).div(d);
2848     }
2849 
2850     function divCeil(
2851         uint256 target,
2852         uint256 d
2853     )
2854         internal
2855         pure
2856         returns (uint256)
2857     {
2858         return target.mul(BASE).divCeil(d);
2859     }
2860 }
2861 
2862 library EIP712 {
2863     string private constant DOMAIN_NAME = "Hydro Protocol";
2864 
2865     /**
2866      * Hash of the EIP712 Domain Separator Schema
2867      */
2868     bytes32 private constant EIP712_DOMAIN_TYPEHASH = keccak256(
2869         abi.encodePacked("EIP712Domain(string name)")
2870     );
2871 
2872     bytes32 private constant DOMAIN_SEPARATOR = keccak256(
2873         abi.encodePacked(
2874             EIP712_DOMAIN_TYPEHASH,
2875             keccak256(bytes(DOMAIN_NAME))
2876         )
2877     );
2878 
2879     /**
2880      * Calculates EIP712 encoding for a hash struct in this EIP712 Domain.
2881      *
2882      * @param eip712hash The EIP712 hash struct.
2883      * @return EIP712 hash applied to this EIP712 Domain.
2884      */
2885     function hashMessage(
2886         bytes32 eip712hash
2887     )
2888         internal
2889         pure
2890         returns (bytes32)
2891     {
2892         return keccak256(abi.encodePacked("\x19\x01", DOMAIN_SEPARATOR, eip712hash));
2893     }
2894 }
2895 
2896 library Events {
2897     //////////////////
2898     // Funds moving //
2899     //////////////////
2900 
2901     // some assets move into contract
2902     event Deposit(
2903         address indexed user,
2904         address indexed asset,
2905         uint256 amount
2906     );
2907 
2908     function logDeposit(
2909         address user,
2910         address asset,
2911         uint256 amount
2912     )
2913         internal
2914     {
2915         emit Deposit(
2916             user,
2917             asset,
2918             amount
2919         );
2920     }
2921 
2922     // some assets move out of contract
2923     event Withdraw(
2924         address indexed user,
2925         address indexed asset,
2926         uint256 amount
2927     );
2928 
2929     function logWithdraw(
2930         address user,
2931         address asset,
2932         uint256 amount
2933     )
2934         internal
2935     {
2936         emit Withdraw(
2937             user,
2938             asset,
2939             amount
2940         );
2941     }
2942 
2943     // transfer from balance to collateral account
2944     event IncreaseCollateral (
2945         address indexed user,
2946         uint16 indexed marketID,
2947         address indexed asset,
2948         uint256 amount
2949     );
2950 
2951     function logIncreaseCollateral(
2952         address user,
2953         uint16 marketID,
2954         address asset,
2955         uint256 amount
2956     )
2957         internal
2958     {
2959         emit IncreaseCollateral(
2960             user,
2961             marketID,
2962             asset,
2963             amount
2964         );
2965     }
2966 
2967     // transfer from collateral account to balance
2968     event DecreaseCollateral (
2969         address indexed user,
2970         uint16 indexed marketID,
2971         address indexed asset,
2972         uint256 amount
2973     );
2974 
2975     function logDecreaseCollateral(
2976         address user,
2977         uint16 marketID,
2978         address asset,
2979         uint256 amount
2980     )
2981         internal
2982     {
2983         emit DecreaseCollateral(
2984             user,
2985             marketID,
2986             asset,
2987             amount
2988         );
2989     }
2990 
2991     //////////////////
2992     // Lending Pool //
2993     //////////////////
2994 
2995     event UpdateIndex(
2996         address indexed asset,
2997         uint256 oldBorrowIndex,
2998         uint256 newBorrowIndex,
2999         uint256 oldSupplyIndex,
3000         uint256 newSupplyIndex
3001     );
3002 
3003     function logUpdateIndex(
3004         address asset,
3005         uint256 oldBorrowIndex,
3006         uint256 newBorrowIndex,
3007         uint256 oldSupplyIndex,
3008         uint256 newSupplyIndex
3009     )
3010         internal
3011     {
3012         emit UpdateIndex(
3013             asset,
3014             oldBorrowIndex,
3015             newBorrowIndex,
3016             oldSupplyIndex,
3017             newSupplyIndex
3018         );
3019     }
3020 
3021     event Borrow(
3022         address indexed user,
3023         uint16 indexed marketID,
3024         address indexed asset,
3025         uint256 amount
3026     );
3027 
3028     function logBorrow(
3029         address user,
3030         uint16 marketID,
3031         address asset,
3032         uint256 amount
3033     )
3034         internal
3035     {
3036         emit Borrow(
3037             user,
3038             marketID,
3039             asset,
3040             amount
3041         );
3042     }
3043 
3044     event Repay(
3045         address indexed user,
3046         uint16 indexed marketID,
3047         address indexed asset,
3048         uint256 amount
3049     );
3050 
3051     function logRepay(
3052         address user,
3053         uint16 marketID,
3054         address asset,
3055         uint256 amount
3056     )
3057         internal
3058     {
3059         emit Repay(
3060             user,
3061             marketID,
3062             asset,
3063             amount
3064         );
3065     }
3066 
3067     event Supply(
3068         address indexed user,
3069         address indexed asset,
3070         uint256 amount
3071     );
3072 
3073     function logSupply(
3074         address user,
3075         address asset,
3076         uint256 amount
3077     )
3078         internal
3079     {
3080         emit Supply(
3081             user,
3082             asset,
3083             amount
3084         );
3085     }
3086 
3087     event Unsupply(
3088         address indexed user,
3089         address indexed asset,
3090         uint256 amount
3091     );
3092 
3093     function logUnsupply(
3094         address user,
3095         address asset,
3096         uint256 amount
3097     )
3098         internal
3099     {
3100         emit Unsupply(
3101             user,
3102             asset,
3103             amount
3104         );
3105     }
3106 
3107     event Loss(
3108         address indexed asset,
3109         uint256 amount
3110     );
3111 
3112     function logLoss(
3113         address asset,
3114         uint256 amount
3115     )
3116         internal
3117     {
3118         emit Loss(
3119             asset,
3120             amount
3121         );
3122     }
3123 
3124     event InsuranceCompensation(
3125         address indexed asset,
3126         uint256 amount
3127     );
3128 
3129     function logInsuranceCompensation(
3130         address asset,
3131         uint256 amount
3132     )
3133         internal
3134     {
3135         emit InsuranceCompensation(
3136             asset,
3137             amount
3138         );
3139     }
3140 
3141     ///////////////////
3142     // Admin Actions //
3143     ///////////////////
3144 
3145     event CreateMarket(Types.Market market);
3146 
3147     function logCreateMarket(
3148         Types.Market memory market
3149     )
3150         internal
3151     {
3152         emit CreateMarket(market);
3153     }
3154 
3155     event UpdateMarket(
3156         uint16 indexed marketID,
3157         uint256 newAuctionRatioStart,
3158         uint256 newAuctionRatioPerBlock,
3159         uint256 newLiquidateRate,
3160         uint256 newWithdrawRate
3161     );
3162 
3163     function logUpdateMarket(
3164         uint16 marketID,
3165         uint256 newAuctionRatioStart,
3166         uint256 newAuctionRatioPerBlock,
3167         uint256 newLiquidateRate,
3168         uint256 newWithdrawRate
3169     )
3170         internal
3171     {
3172         emit UpdateMarket(
3173             marketID,
3174             newAuctionRatioStart,
3175             newAuctionRatioPerBlock,
3176             newLiquidateRate,
3177             newWithdrawRate
3178         );
3179     }
3180 
3181     event MarketBorrowDisable(
3182         uint16 indexed marketID
3183     );
3184 
3185     function logMarketBorrowDisable(
3186         uint16 marketID
3187     )
3188         internal
3189     {
3190         emit MarketBorrowDisable(
3191             marketID
3192         );
3193     }
3194 
3195     event MarketBorrowEnable(
3196         uint16 indexed marketID
3197     );
3198 
3199     function logMarketBorrowEnable(
3200         uint16 marketID
3201     )
3202         internal
3203     {
3204         emit MarketBorrowEnable(
3205             marketID
3206         );
3207     }
3208 
3209     event UpdateDiscountConfig(bytes32 newConfig);
3210 
3211     function logUpdateDiscountConfig(
3212         bytes32 newConfig
3213     )
3214         internal
3215     {
3216         emit UpdateDiscountConfig(newConfig);
3217     }
3218 
3219     event CreateAsset(
3220         address asset,
3221         address oracleAddress,
3222         address poolTokenAddress,
3223         address interestModelAddress
3224     );
3225 
3226     function logCreateAsset(
3227         address asset,
3228         address oracleAddress,
3229         address poolTokenAddress,
3230         address interestModelAddress
3231     )
3232         internal
3233     {
3234         emit CreateAsset(
3235             asset,
3236             oracleAddress,
3237             poolTokenAddress,
3238             interestModelAddress
3239         );
3240     }
3241 
3242     event UpdateAsset(
3243         address indexed asset,
3244         address oracleAddress,
3245         address interestModelAddress
3246     );
3247 
3248     function logUpdateAsset(
3249         address asset,
3250         address oracleAddress,
3251         address interestModelAddress
3252     )
3253         internal
3254     {
3255         emit UpdateAsset(
3256             asset,
3257             oracleAddress,
3258             interestModelAddress
3259         );
3260     }
3261 
3262     event UpdateAuctionInitiatorRewardRatio(
3263         uint256 newInitiatorRewardRatio
3264     );
3265 
3266     function logUpdateAuctionInitiatorRewardRatio(
3267         uint256 newInitiatorRewardRatio
3268     )
3269         internal
3270     {
3271         emit UpdateAuctionInitiatorRewardRatio(
3272             newInitiatorRewardRatio
3273         );
3274     }
3275 
3276     event UpdateInsuranceRatio(
3277         uint256 newInsuranceRatio
3278     );
3279 
3280     function logUpdateInsuranceRatio(
3281         uint256 newInsuranceRatio
3282     )
3283         internal
3284     {
3285         emit UpdateInsuranceRatio(newInsuranceRatio);
3286     }
3287 
3288     /////////////
3289     // Auction //
3290     /////////////
3291 
3292     event Liquidate(
3293         address indexed user,
3294         uint16 indexed marketID,
3295         bool indexed hasAuction
3296     );
3297 
3298     function logLiquidate(
3299         address user,
3300         uint16 marketID,
3301         bool hasAuction
3302     )
3303         internal
3304     {
3305         emit Liquidate(
3306             user,
3307             marketID,
3308             hasAuction
3309         );
3310     }
3311 
3312     // an auction is created
3313     event AuctionCreate(
3314         uint256 auctionID
3315     );
3316 
3317     function logAuctionCreate(
3318         uint256 auctionID
3319     )
3320         internal
3321     {
3322         emit AuctionCreate(auctionID);
3323     }
3324 
3325     // a user filled an acution
3326     event FillAuction(
3327         uint256 indexed auctionID,
3328         address bidder,
3329         uint256 repayDebt,
3330         uint256 bidderRepayDebt,
3331         uint256 bidderCollateral,
3332         uint256 leftDebt
3333     );
3334 
3335     function logFillAuction(
3336         uint256 auctionID,
3337         address bidder,
3338         uint256 repayDebt,
3339         uint256 bidderRepayDebt,
3340         uint256 bidderCollateral,
3341         uint256 leftDebt
3342     )
3343         internal
3344     {
3345         emit FillAuction(
3346             auctionID,
3347             bidder,
3348             repayDebt,
3349             bidderRepayDebt,
3350             bidderCollateral,
3351             leftDebt
3352         );
3353     }
3354 
3355     /////////////
3356     // Relayer //
3357     /////////////
3358 
3359     event RelayerApproveDelegate(
3360         address indexed relayer,
3361         address indexed delegate
3362     );
3363 
3364     function logRelayerApproveDelegate(
3365         address relayer,
3366         address delegate
3367     )
3368         internal
3369     {
3370         emit RelayerApproveDelegate(
3371             relayer,
3372             delegate
3373         );
3374     }
3375 
3376     event RelayerRevokeDelegate(
3377         address indexed relayer,
3378         address indexed delegate
3379     );
3380 
3381     function logRelayerRevokeDelegate(
3382         address relayer,
3383         address delegate
3384     )
3385         internal
3386     {
3387         emit RelayerRevokeDelegate(
3388             relayer,
3389             delegate
3390         );
3391     }
3392 
3393     event RelayerExit(
3394         address indexed relayer
3395     );
3396 
3397     function logRelayerExit(
3398         address relayer
3399     )
3400         internal
3401     {
3402         emit RelayerExit(relayer);
3403     }
3404 
3405     event RelayerJoin(
3406         address indexed relayer
3407     );
3408 
3409     function logRelayerJoin(
3410         address relayer
3411     )
3412         internal
3413     {
3414         emit RelayerJoin(relayer);
3415     }
3416 
3417     //////////////
3418     // Exchange //
3419     //////////////
3420 
3421     event Match(
3422         Types.OrderAddressSet addressSet,
3423         address maker,
3424         address taker,
3425         address buyer,
3426         uint256 makerFee,
3427         uint256 makerRebate,
3428         uint256 takerFee,
3429         uint256 makerGasFee,
3430         uint256 takerGasFee,
3431         uint256 baseAssetFilledAmount,
3432         uint256 quoteAssetFilledAmount
3433 
3434     );
3435 
3436     function logMatch(
3437         Types.MatchResult memory result,
3438         Types.OrderAddressSet memory addressSet
3439     )
3440         internal
3441     {
3442         emit Match(
3443             addressSet,
3444             result.maker,
3445             result.taker,
3446             result.buyer,
3447             result.makerFee,
3448             result.makerRebate,
3449             result.takerFee,
3450             result.makerGasFee,
3451             result.takerGasFee,
3452             result.baseAssetFilledAmount,
3453             result.quoteAssetFilledAmount
3454         );
3455     }
3456 
3457     event OrderCancel(
3458         bytes32 indexed orderHash
3459     );
3460 
3461     function logOrderCancel(
3462         bytes32 orderHash
3463     )
3464         internal
3465     {
3466         emit OrderCancel(orderHash);
3467     }
3468 }
3469 
3470 contract Ownable {
3471     address private _owner;
3472 
3473     event OwnershipTransferred(
3474         address indexed previousOwner,
3475         address indexed newOwner
3476     );
3477 
3478     /** @dev The Ownable constructor sets the original `owner` of the contract to the sender account. */
3479     constructor()
3480         internal
3481     {
3482         _owner = msg.sender;
3483         emit OwnershipTransferred(address(0), _owner);
3484     }
3485 
3486     /** @return the address of the owner. */
3487     function owner()
3488         public
3489         view
3490         returns(address)
3491     {
3492         return _owner;
3493     }
3494 
3495     /** @dev Throws if called by any account other than the owner. */
3496     modifier onlyOwner() {
3497         require(isOwner(), "NOT_OWNER");
3498         _;
3499     }
3500 
3501     /** @return true if `msg.sender` is the owner of the contract. */
3502     function isOwner()
3503         public
3504         view
3505         returns(bool)
3506     {
3507         return msg.sender == _owner;
3508     }
3509 
3510     /** @dev Allows the current owner to relinquish control of the contract.
3511      * @notice Renouncing to ownership will leave the contract without an owner.
3512      * It will not be possible to call the functions with the `onlyOwner`
3513      * modifier anymore.
3514      */
3515     function renounceOwnership()
3516         public
3517         onlyOwner
3518     {
3519         emit OwnershipTransferred(_owner, address(0));
3520         _owner = address(0);
3521     }
3522 
3523     /** @dev Allows the current owner to transfer control of the contract to a newOwner.
3524      * @param newOwner The address to transfer ownership to.
3525      */
3526     function transferOwnership(
3527         address newOwner
3528     )
3529         public
3530         onlyOwner
3531     {
3532         require(newOwner != address(0), "INVALID_OWNER");
3533         emit OwnershipTransferred(_owner, newOwner);
3534         _owner = newOwner;
3535     }
3536 }
3537 
3538 contract Operations is Ownable, GlobalStore {
3539 
3540     function createMarket(
3541         Types.Market memory market
3542     )
3543         public
3544         onlyOwner
3545     {
3546         OperationsComponent.createMarket(state, market);
3547     }
3548 
3549     function updateMarket(
3550         uint16 marketID,
3551         uint256 newAuctionRatioStart,
3552         uint256 newAuctionRatioPerBlock,
3553         uint256 newLiquidateRate,
3554         uint256 newWithdrawRate
3555     )
3556         external
3557         onlyOwner
3558     {
3559         OperationsComponent.updateMarket(
3560             state,
3561             marketID,
3562             newAuctionRatioStart,
3563             newAuctionRatioPerBlock,
3564             newLiquidateRate,
3565             newWithdrawRate
3566         );
3567     }
3568 
3569     function setMarketBorrowUsability(
3570         uint16 marketID,
3571         bool   usability
3572     )
3573         external
3574         onlyOwner
3575     {
3576         OperationsComponent.setMarketBorrowUsability(
3577             state,
3578             marketID,
3579             usability
3580         );
3581     }
3582 
3583     function createAsset(
3584         address asset,
3585         address oracleAddress,
3586         address interestModelAddress,
3587         string calldata poolTokenName,
3588         string calldata poolTokenSymbol,
3589         uint8 poolTokenDecimals
3590     )
3591         external
3592         onlyOwner
3593     {
3594         OperationsComponent.createAsset(
3595             state,
3596             asset,
3597             oracleAddress,
3598             interestModelAddress,
3599             poolTokenName,
3600             poolTokenSymbol,
3601             poolTokenDecimals
3602         );
3603     }
3604 
3605     function updateAsset(
3606         address asset,
3607         address oracleAddress,
3608         address interestModelAddress
3609     )
3610         external
3611         onlyOwner
3612     {
3613         OperationsComponent.updateAsset(
3614             state,
3615             asset,
3616             oracleAddress,
3617             interestModelAddress
3618         );
3619     }
3620 
3621     /**
3622      * @param newConfig A data blob representing the new discount config. Details on format above.
3623      */
3624     function updateDiscountConfig(
3625         bytes32 newConfig
3626     )
3627         external
3628         onlyOwner
3629     {
3630         OperationsComponent.updateDiscountConfig(
3631             state,
3632             newConfig
3633         );
3634     }
3635 
3636     function updateAuctionInitiatorRewardRatio(
3637         uint256 newInitiatorRewardRatio
3638     )
3639         external
3640         onlyOwner
3641     {
3642         OperationsComponent.updateAuctionInitiatorRewardRatio(
3643             state,
3644             newInitiatorRewardRatio
3645         );
3646     }
3647 
3648     function updateInsuranceRatio(
3649         uint256 newInsuranceRatio
3650     )
3651         external
3652         onlyOwner
3653     {
3654         OperationsComponent.updateInsuranceRatio(
3655             state,
3656             newInsuranceRatio
3657         );
3658     }
3659 }
3660 
3661 contract Hydro is GlobalStore, ExternalFunctions, Operations {
3662     constructor(
3663         address _hotTokenAddress
3664     )
3665         public
3666     {
3667         state.exchange.hotTokenAddress = _hotTokenAddress;
3668         state.exchange.discountConfig = 0x043c000027106400004e205a000075305000009c404600000000000000000000;
3669     }
3670 }
3671 
3672 contract LendingPoolToken is StandardToken, Ownable {
3673     string public name;
3674     string public symbol;
3675     uint8 public decimals;
3676     uint256 public totalSupply;
3677 
3678     event Mint(address indexed user, uint256 value);
3679     event Burn(address indexed user, uint256 value);
3680 
3681     constructor (
3682         string memory tokenName,
3683         string memory tokenSymbol,
3684         uint8 tokenDecimals
3685     )
3686         public
3687     {
3688         name = tokenName;
3689         symbol = tokenSymbol;
3690         decimals = tokenDecimals;
3691     }
3692 
3693     function mint(
3694         address user,
3695         uint256 value
3696     )
3697         external
3698         onlyOwner
3699     {
3700         balances[user] = balances[user].add(value);
3701         totalSupply = totalSupply.add(value);
3702         emit Mint(user, value);
3703     }
3704 
3705     function burn(
3706         address user,
3707         uint256 value
3708     )
3709         external
3710         onlyOwner
3711     {
3712         balances[user] = balances[user].sub(value);
3713         totalSupply = totalSupply.sub(value);
3714         emit Burn(user, value);
3715     }
3716 
3717 }
3718 
3719 library Requires {
3720     function requireAssetExist(
3721         Store.State storage state,
3722         address asset
3723     )
3724         internal
3725         view
3726     {
3727         require(isAssetExist(state, asset), "ASSET_NOT_EXIST");
3728     }
3729 
3730     function requireAssetNotExist(
3731         Store.State storage state,
3732         address asset
3733     )
3734         internal
3735         view
3736     {
3737         require(!isAssetExist(state, asset), "ASSET_ALREADY_EXIST");
3738     }
3739 
3740     function requireMarketIDAndAssetMatch(
3741         Store.State storage state,
3742         uint16 marketID,
3743         address asset
3744     )
3745         internal
3746         view
3747     {
3748         require(
3749             asset == state.markets[marketID].baseAsset || asset == state.markets[marketID].quoteAsset,
3750             "ASSET_NOT_BELONGS_TO_MARKET"
3751         );
3752     }
3753 
3754     function requireMarketNotExist(
3755         Store.State storage state,
3756         Types.Market memory market
3757     )
3758         internal
3759         view
3760     {
3761         require(!isMarketExist(state, market), "MARKET_ALREADY_EXIST");
3762     }
3763 
3764     function requireMarketAssetsValid(
3765         Store.State storage state,
3766         Types.Market memory market
3767     )
3768         internal
3769         view
3770     {
3771         require(market.baseAsset != market.quoteAsset, "BASE_QUOTE_DUPLICATED");
3772         require(isAssetExist(state, market.baseAsset), "MARKET_BASE_ASSET_NOT_EXIST");
3773         require(isAssetExist(state, market.quoteAsset), "MARKET_QUOTE_ASSET_NOT_EXIST");
3774     }
3775 
3776     function requireCashLessThanOrEqualContractBalance(
3777         Store.State storage state,
3778         address asset
3779     )
3780         internal
3781         view
3782     {
3783         if (asset == Consts.ETHEREUM_TOKEN_ADDRESS()) {
3784             if (state.cash[asset] > 0) {
3785                 require(uint256(state.cash[asset]) <= address(this).balance, "CONTRACT_BALANCE_NOT_ENOUGH");
3786             }
3787         } else {
3788             if (state.cash[asset] > 0) {
3789                 require(uint256(state.cash[asset]) <= IStandardToken(asset).balanceOf(address(this)), "CONTRACT_BALANCE_NOT_ENOUGH");
3790             }
3791         }
3792     }
3793 
3794     function requirePriceOracleAddressValid(
3795         address oracleAddress
3796     )
3797         internal
3798         pure
3799     {
3800         require(oracleAddress != address(0), "ORACLE_ADDRESS_NOT_VALID");
3801     }
3802 
3803     function requireDecimalLessOrEquanThanOne(
3804         uint256 decimal
3805     )
3806         internal
3807         pure
3808     {
3809         require(decimal <= Decimal.one(), "DECIMAL_GREATER_THAN_ONE");
3810     }
3811 
3812     function requireDecimalGreaterThanOne(
3813         uint256 decimal
3814     )
3815         internal
3816         pure
3817     {
3818         require(decimal > Decimal.one(), "DECIMAL_LESS_OR_EQUAL_THAN_ONE");
3819     }
3820 
3821     function requireMarketIDExist(
3822         Store.State storage state,
3823         uint16 marketID
3824     )
3825         internal
3826         view
3827     {
3828         require(marketID < state.marketsCount, "MARKET_NOT_EXIST");
3829     }
3830 
3831     function requireMarketBorrowEnabled(
3832         Store.State storage state,
3833         uint16 marketID
3834     )
3835         internal
3836         view
3837     {
3838         require(state.markets[marketID].borrowEnable, "MARKET_BORROW_DISABLED");
3839     }
3840 
3841     function requirePathNormalStatus(
3842         Store.State storage state,
3843         Types.BalancePath memory path
3844     )
3845         internal
3846         view
3847     {
3848         if (path.category == Types.BalanceCategory.CollateralAccount) {
3849             requireAccountNormal(state, path.marketID, path.user);
3850         }
3851     }
3852 
3853     function requireAccountNormal(
3854         Store.State storage state,
3855         uint16 marketID,
3856         address user
3857     )
3858         internal
3859         view
3860     {
3861         require(
3862             state.accounts[user][marketID].status == Types.CollateralAccountStatus.Normal,
3863             "CAN_NOT_OPERATE_LIQUIDATING_COLLATERAL_ACCOUNT"
3864         );
3865     }
3866 
3867     function requirePathMarketIDAssetMatch(
3868         Store.State storage state,
3869         Types.BalancePath memory path,
3870         address asset
3871     )
3872         internal
3873         view
3874     {
3875         if (path.category == Types.BalanceCategory.CollateralAccount) {
3876             requireMarketIDExist(state, path.marketID);
3877             requireMarketIDAndAssetMatch(state, path.marketID, asset);
3878         }
3879     }
3880 
3881     function requireCollateralAccountNotLiquidatable(
3882         Store.State storage state,
3883         Types.BalancePath memory path
3884     )
3885         internal
3886         view
3887     {
3888         if (path.category == Types.BalanceCategory.CollateralAccount) {
3889             requireCollateralAccountNotLiquidatable(state, path.user, path.marketID);
3890         }
3891     }
3892 
3893     function requireCollateralAccountNotLiquidatable(
3894         Store.State storage state,
3895         address user,
3896         uint16 marketID
3897     )
3898         internal
3899         view
3900     {
3901         require(
3902             !CollateralAccounts.getDetails(state, user, marketID).liquidatable,
3903             "COLLATERAL_ACCOUNT_LIQUIDATABLE"
3904         );
3905     }
3906 
3907     function requireAuctionNotFinished(
3908         Store.State storage state,
3909         uint32 auctionID
3910     )
3911         internal
3912         view
3913     {
3914         require(
3915             state.auction.auctions[auctionID].status == Types.AuctionStatus.InProgress,
3916             "AUCTION_ALREADY_FINISHED"
3917         );
3918     }
3919 
3920     function requireAuctionExist(
3921         Store.State storage state,
3922         uint32 auctionID
3923     )
3924         internal
3925         view
3926     {
3927         require(
3928             auctionID < state.auction.auctionsCount,
3929             "AUCTION_NOT_EXIST"
3930         );
3931     }
3932 
3933     function isAssetExist(
3934         Store.State storage state,
3935         address asset
3936     )
3937         private
3938         view
3939         returns (bool)
3940     {
3941         return state.assets[asset].priceOracle != IPriceOracle(address(0));
3942     }
3943 
3944     function isMarketExist(
3945         Store.State storage state,
3946         Types.Market memory market
3947     )
3948         private
3949         view
3950         returns (bool)
3951     {
3952         for(uint16 i = 0; i < state.marketsCount; i++) {
3953             if (state.markets[i].baseAsset == market.baseAsset && state.markets[i].quoteAsset == market.quoteAsset) {
3954                 return true;
3955             }
3956         }
3957 
3958         return false;
3959     }
3960 
3961 }
3962 
3963 library SafeERC20 {
3964     function safeTransfer(
3965         address token,
3966         address to,
3967         uint256 amount
3968     )
3969         internal
3970     {
3971         bool result;
3972 
3973         assembly {
3974             let tmp1 := mload(0)
3975             let tmp2 := mload(4)
3976             let tmp3 := mload(36)
3977 
3978             // keccak256('transfer(address,uint256)') & 0xFFFFFFFF00000000000000000000000000000000000000000000000000000000
3979             mstore(0, 0xa9059cbb00000000000000000000000000000000000000000000000000000000)
3980             mstore(4, to)
3981             mstore(36, amount)
3982 
3983             // call ERC20 Token contract transfer function
3984             let callResult := call(gas, token, 0, 0, 68, 0, 32)
3985             let returnValue := mload(0)
3986 
3987             mstore(0, tmp1)
3988             mstore(4, tmp2)
3989             mstore(36, tmp3)
3990 
3991             // result check
3992             result := and (
3993                 eq(callResult, 1),
3994                 or(eq(returndatasize, 0), and(eq(returndatasize, 32), gt(returnValue, 0)))
3995             )
3996         }
3997 
3998         if (!result) {
3999             revert("TOKEN_TRANSFER_ERROR");
4000         }
4001     }
4002 
4003     function safeTransferFrom(
4004         address token,
4005         address from,
4006         address to,
4007         uint256 amount
4008     )
4009         internal
4010     {
4011         bool result;
4012 
4013         assembly {
4014             let tmp1 := mload(0)
4015             let tmp2 := mload(4)
4016             let tmp3 := mload(36)
4017             let tmp4 := mload(68)
4018 
4019             // keccak256('transferFrom(address,address,uint256)') & 0xFFFFFFFF00000000000000000000000000000000000000000000000000000000
4020             mstore(0, 0x23b872dd00000000000000000000000000000000000000000000000000000000)
4021             mstore(4, from)
4022             mstore(36, to)
4023             mstore(68, amount)
4024 
4025             // call ERC20 Token contract transferFrom function
4026             let callResult := call(gas, token, 0, 0, 100, 0, 32)
4027             let returnValue := mload(0)
4028 
4029             mstore(0, tmp1)
4030             mstore(4, tmp2)
4031             mstore(36, tmp3)
4032             mstore(68, tmp4)
4033 
4034             // result check
4035             result := and (
4036                 eq(callResult, 1),
4037                 or(eq(returndatasize, 0), and(eq(returndatasize, 32), gt(returnValue, 0)))
4038             )
4039         }
4040 
4041         if (!result) {
4042             revert("TOKEN_TRANSFER_FROM_ERROR");
4043         }
4044     }
4045 }
4046 
4047 library SafeMath {
4048 
4049     // Multiplies two numbers, reverts on overflow.
4050     function mul(
4051         uint256 a,
4052         uint256 b
4053     )
4054         internal
4055         pure
4056         returns (uint256)
4057     {
4058         if (a == 0) {
4059             return 0;
4060         }
4061 
4062         uint256 c = a * b;
4063         require(c / a == b, "MUL_ERROR");
4064 
4065         return c;
4066     }
4067 
4068     // Integer division of two numbers truncating the quotient, reverts on division by zero.
4069     function div(
4070         uint256 a,
4071         uint256 b
4072     )
4073         internal
4074         pure
4075         returns (uint256)
4076     {
4077         require(b > 0, "DIVIDING_ERROR");
4078         return a / b;
4079     }
4080 
4081     function divCeil(
4082         uint256 a,
4083         uint256 b
4084     )
4085         internal
4086         pure
4087         returns (uint256)
4088     {
4089         uint256 quotient = div(a, b);
4090         uint256 remainder = a - quotient * b;
4091         if (remainder > 0) {
4092             return quotient + 1;
4093         } else {
4094             return quotient;
4095         }
4096     }
4097 
4098     // Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
4099     function sub(
4100         uint256 a,
4101         uint256 b
4102     )
4103         internal
4104         pure
4105         returns (uint256)
4106     {
4107         require(b <= a, "SUB_ERROR");
4108         return a - b;
4109     }
4110 
4111     function sub(
4112         int256 a,
4113         uint256 b
4114     )
4115         internal
4116         pure
4117         returns (int256)
4118     {
4119         require(b <= 2**255-1, "INT256_SUB_ERROR");
4120         int256 c = a - int256(b);
4121         require(c <= a, "INT256_SUB_ERROR");
4122         return c;
4123     }
4124 
4125     // Adds two numbers, reverts on overflow.
4126     function add(
4127         uint256 a,
4128         uint256 b
4129     )
4130         internal
4131         pure
4132         returns (uint256)
4133     {
4134         uint256 c = a + b;
4135         require(c >= a, "ADD_ERROR");
4136         return c;
4137     }
4138 
4139     function add(
4140         int256 a,
4141         uint256 b
4142     )
4143         internal
4144         pure
4145         returns (int256)
4146     {
4147         require(b <= 2**255 - 1, "INT256_ADD_ERROR");
4148         int256 c = a + int256(b);
4149         require(c >= a, "INT256_ADD_ERROR");
4150         return c;
4151     }
4152 
4153     // Divides two numbers and returns the remainder (unsigned integer modulo), reverts when dividing by zero.
4154     function mod(
4155         uint256 a,
4156         uint256 b
4157     )
4158         internal
4159         pure
4160         returns (uint256)
4161     {
4162         require(b != 0, "MOD_ERROR");
4163         return a % b;
4164     }
4165 
4166     /**
4167      * Check the amount of precision lost by calculating multiple * (numerator / denominator). To
4168      * do this, we check the remainder and make sure it's proportionally less than 0.1%. So we have:
4169      *
4170      *     ((numerator * multiple) % denominator)     1
4171      *     -------------------------------------- < ----
4172      *              numerator * multiple            1000
4173      *
4174      * To avoid further division, we can move the denominators to the other sides and we get:
4175      *
4176      *     ((numerator * multiple) % denominator) * 1000 < numerator * multiple
4177      *
4178      * Since we want to return true if there IS a rounding error, we simply flip the sign and our
4179      * final equation becomes:
4180      *
4181      *     ((numerator * multiple) % denominator) * 1000 >= numerator * multiple
4182      *
4183      * @param numerator The numerator of the proportion
4184      * @param denominator The denominator of the proportion
4185      * @param multiple The amount we want a proportion of
4186      * @return Boolean indicating if there is a rounding error when calculating the proportion
4187      */
4188     function isRoundingError(
4189         uint256 numerator,
4190         uint256 denominator,
4191         uint256 multiple
4192     )
4193         internal
4194         pure
4195         returns (bool)
4196     {
4197         // numerator.mul(multiple).mod(denominator).mul(1000) >= numerator.mul(multiple)
4198         return mul(mod(mul(numerator, multiple), denominator), 1000) >= mul(numerator, multiple);
4199     }
4200 
4201     /**
4202      * Takes an amount (multiple) and calculates a proportion of it given a numerator/denominator
4203      * pair of values. The final value will be rounded down to the nearest integer value.
4204      *
4205      * This function will revert the transaction if rounding the final value down would lose more
4206      * than 0.1% precision.
4207      *
4208      * @param numerator The numerator of the proportion
4209      * @param denominator The denominator of the proportion
4210      * @param multiple The amount we want a proportion of
4211      * @return The final proportion of multiple rounded down
4212      */
4213     function getPartialAmountFloor(
4214         uint256 numerator,
4215         uint256 denominator,
4216         uint256 multiple
4217     )
4218         internal
4219         pure
4220         returns (uint256)
4221     {
4222         require(!isRoundingError(numerator, denominator, multiple), "ROUNDING_ERROR");
4223         // numerator.mul(multiple).div(denominator)
4224         return div(mul(numerator, multiple), denominator);
4225     }
4226 
4227     /**
4228      * Returns the smaller integer of the two passed in.
4229      *
4230      * @param a Unsigned integer
4231      * @param b Unsigned integer
4232      * @return The smaller of the two integers
4233      */
4234     function min(
4235         uint256 a,
4236         uint256 b
4237     )
4238         internal
4239         pure
4240         returns (uint256)
4241     {
4242         return a < b ? a : b;
4243     }
4244 }
4245 
4246 library Signature {
4247 
4248     enum SignatureMethod {
4249         EthSign,
4250         EIP712
4251     }
4252 
4253     /**
4254      * Validate a signature given a hash calculated from the order data, the signer, and the
4255      * signature data passed in with the order.
4256      *
4257      * This function will revert the transaction if the signature method is invalid.
4258      *
4259      * @param hash Hash bytes calculated by taking the EIP712 hash of the passed order data
4260      * @param signerAddress The address of the signer
4261      * @param signature The signature data passed along with the order to validate against
4262      * @return True if the calculated signature matches the order signature data, false otherwise.
4263      */
4264     function isValidSignature(
4265         bytes32 hash,
4266         address signerAddress,
4267         Types.Signature memory signature
4268     )
4269         internal
4270         pure
4271         returns (bool)
4272     {
4273         uint8 method = uint8(signature.config[1]);
4274         address recovered;
4275         uint8 v = uint8(signature.config[0]);
4276 
4277         if (method == uint8(SignatureMethod.EthSign)) {
4278             recovered = ecrecover(
4279                 keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash)),
4280                 v,
4281                 signature.r,
4282                 signature.s
4283             );
4284         } else if (method == uint8(SignatureMethod.EIP712)) {
4285             recovered = ecrecover(hash, v, signature.r, signature.s);
4286         } else {
4287             revert("INVALID_SIGN_METHOD");
4288         }
4289 
4290         return signerAddress == recovered;
4291     }
4292 }
4293 
4294 library Store {
4295 
4296     struct RelayerState {
4297         /**
4298         * Mapping of relayerAddress => delegateAddress
4299         */
4300         mapping (address => mapping (address => bool)) relayerDelegates;
4301 
4302         /**
4303         * Mapping of relayerAddress => whether relayer is opted out of the liquidity incentive system
4304         */
4305         mapping (address => bool) hasExited;
4306     }
4307 
4308     struct ExchangeState {
4309 
4310         /**
4311         * Calculate and return the rate at which fees will be charged for an address. The discounted
4312         * rate depends on how much HOT token is owned by the user. Values returned will be a percentage
4313         * used to calculate how much of the fee is paid, so a return value of 100 means there is 0
4314         * discount, and a return value of 70 means a 30% rate reduction.
4315         *
4316         * The discountConfig is defined as such:
4317         * ╔═══════════════════╤════════════════════════════════════════════╗
4318         * ║                   │ length(bytes)   desc                       ║
4319         * ╟───────────────────┼────────────────────────────────────────────╢
4320         * ║ count             │ 1               the count of configs       ║
4321         * ║ maxDiscountedRate │ 1               the max discounted rate    ║
4322         * ║ config            │ 5 each                                     ║
4323         * ╚═══════════════════╧════════════════════════════════════════════╝
4324         *
4325         * The default discount structure as defined in code would give the following result:
4326         *
4327         * Fee discount table
4328         * ╔════════════════════╤══════════╗
4329         * ║     HOT BALANCE    │ DISCOUNT ║
4330         * ╠════════════════════╪══════════╣
4331         * ║     0 <= x < 10000 │     0%   ║
4332         * ╟────────────────────┼──────────╢
4333         * ║ 10000 <= x < 20000 │    10%   ║
4334         * ╟────────────────────┼──────────╢
4335         * ║ 20000 <= x < 30000 │    20%   ║
4336         * ╟────────────────────┼──────────╢
4337         * ║ 30000 <= x < 40000 │    30%   ║
4338         * ╟────────────────────┼──────────╢
4339         * ║ 40000 <= x         │    40%   ║
4340         * ╚════════════════════╧══════════╝
4341         *
4342         * Breaking down the bytes of 0x043c000027106400004e205a000075305000009c404600000000000000000000
4343         *
4344         * 0x  04           3c          0000271064  00004e205a  0000753050  00009c4046  0000000000  0000000000;
4345         *     ~~           ~~          ~~~~~~~~~~  ~~~~~~~~~~  ~~~~~~~~~~  ~~~~~~~~~~  ~~~~~~~~~~  ~~~~~~~~~~
4346         *      |            |               |           |           |           |           |           |
4347         *    count  maxDiscountedRate       1           2           3           4           5           6
4348         *
4349         * The first config breaks down as follows:  00002710   64
4350         *                                           ~~~~~~~~   ~~
4351         *                                               |      |
4352         *                                              bar    rate
4353         *
4354         * Meaning if a user has less than 10000 (0x00002710) HOT, they will pay 100%(0x64) of the
4355         * standard fee.
4356         *
4357         */
4358         bytes32 discountConfig;
4359 
4360         /**
4361         * Mapping of orderHash => amount
4362         * Generally the amount will be specified in base token units, however in the case of a market
4363         * buy order the amount is specified in quote token units.
4364         */
4365         mapping (bytes32 => uint256) filled;
4366 
4367         /**
4368         * Mapping of orderHash => whether order has been cancelled.
4369         */
4370         mapping (bytes32 => bool) cancelled;
4371 
4372         address hotTokenAddress;
4373     }
4374 
4375     struct LendingPoolState {
4376         uint256 insuranceRatio;
4377 
4378         // insurance balances
4379         mapping(address => uint256) insuranceBalances;
4380 
4381         mapping (address => uint256) borrowIndex; // decimal
4382         mapping (address => uint256) supplyIndex; // decimal
4383         mapping (address => uint256) indexStartTime; // timestamp
4384 
4385         mapping (address => uint256) borrowAnnualInterestRate; // decimal
4386         mapping (address => uint256) supplyAnnualInterestRate; // decimal
4387 
4388         // total borrow
4389         mapping(address => uint256) normalizedTotalBorrow;
4390 
4391         // user => marketID => balances
4392         mapping (address => mapping (uint16 => mapping(address => uint256))) normalizedBorrow;
4393     }
4394 
4395     struct AuctionState {
4396 
4397         // count of auctions
4398         uint32 auctionsCount;
4399 
4400         // all auctions
4401         mapping(uint32 => Types.Auction) auctions;
4402 
4403         // current auctions
4404         uint32[] currentAuctions;
4405 
4406         // auction initiator reward ratio
4407         uint256 initiatorRewardRatio;
4408     }
4409 
4410     struct State {
4411 
4412         uint16 marketsCount;
4413 
4414         mapping(address => Types.Asset) assets;
4415         mapping(address => int256) cash;
4416 
4417         // user => marketID => account
4418         mapping(address => mapping(uint16 => Types.CollateralAccount)) accounts;
4419 
4420         // all markets
4421         mapping(uint16 => Types.Market) markets;
4422 
4423         // user balances
4424         mapping(address => mapping(address => uint256)) balances;
4425 
4426         LendingPoolState pool;
4427 
4428         ExchangeState exchange;
4429 
4430         RelayerState relayer;
4431 
4432         AuctionState auction;
4433     }
4434 }
4435 
4436 library Transfer {
4437     using SafeMath for uint256;
4438     using SafeMath for int256;
4439     using BalancePath for Types.BalancePath;
4440 
4441     // Transfer asset into current contract
4442     function deposit(
4443         Store.State storage state,
4444         address asset,
4445         uint256 amount
4446     )
4447         internal
4448         returns (uint256)
4449     {
4450         uint256 depositedEtherAmount = 0;
4451 
4452         if (asset == Consts.ETHEREUM_TOKEN_ADDRESS()) {
4453             // Since this method is able to be called in batch,
4454             // there is a chance that a batch contains multi deposit ether calls.
4455             // To make sure the the msg.value is equal to the total deposit ethers,
4456             // each ether deposit function needs to return the actual deposited ether amount.
4457             depositedEtherAmount = amount;
4458         } else {
4459             SafeERC20.safeTransferFrom(asset, msg.sender, address(this), amount);
4460         }
4461 
4462         transferIn(state, asset, BalancePath.getCommonPath(msg.sender), amount);
4463         Events.logDeposit(msg.sender, asset, amount);
4464 
4465         return depositedEtherAmount;
4466     }
4467 
4468     // Transfer asset out of current contract
4469     function withdraw(
4470         Store.State storage state,
4471         address user,
4472         address asset,
4473         uint256 amount
4474     )
4475         internal
4476     {
4477         require(state.balances[user][asset] >= amount, "BALANCE_NOT_ENOUGH");
4478 
4479         if (asset == Consts.ETHEREUM_TOKEN_ADDRESS()) {
4480             address payable payableUser = address(uint160(user));
4481             payableUser.transfer(amount);
4482         } else {
4483             SafeERC20.safeTransfer(asset, user, amount);
4484         }
4485 
4486         transferOut(state, asset, BalancePath.getCommonPath(user), amount);
4487 
4488         Events.logWithdraw(user, asset, amount);
4489     }
4490 
4491     // Get a user's asset balance
4492     function balanceOf(
4493         Store.State storage state,
4494         Types.BalancePath memory balancePath,
4495         address asset
4496     )
4497         internal
4498         view
4499         returns (uint256)
4500     {
4501         mapping(address => uint256) storage balances = balancePath.getBalances(state);
4502         return balances[asset];
4503     }
4504 
4505     // Move asset from a balances map to another
4506     function transfer(
4507         Store.State storage state,
4508         address asset,
4509         Types.BalancePath memory fromBalancePath,
4510         Types.BalancePath memory toBalancePath,
4511         uint256 amount
4512     )
4513         internal
4514     {
4515 
4516         Requires.requirePathMarketIDAssetMatch(state, fromBalancePath, asset);
4517         Requires.requirePathMarketIDAssetMatch(state, toBalancePath, asset);
4518 
4519         mapping(address => uint256) storage fromBalances = fromBalancePath.getBalances(state);
4520         mapping(address => uint256) storage toBalances = toBalancePath.getBalances(state);
4521 
4522         require(fromBalances[asset] >= amount, "TRANSFER_BALANCE_NOT_ENOUGH");
4523 
4524         fromBalances[asset] = fromBalances[asset] - amount;
4525         toBalances[asset] = toBalances[asset].add(amount);
4526     }
4527 
4528     function transferIn(
4529         Store.State storage state,
4530         address asset,
4531         Types.BalancePath memory path,
4532         uint256 amount
4533     )
4534         internal
4535     {
4536         mapping(address => uint256) storage balances = path.getBalances(state);
4537         balances[asset] = balances[asset].add(amount);
4538         state.cash[asset] = state.cash[asset].add(amount);
4539     }
4540 
4541     function transferOut(
4542         Store.State storage state,
4543         address asset,
4544         Types.BalancePath memory path,
4545         uint256 amount
4546     )
4547         internal
4548     {
4549         mapping(address => uint256) storage balances = path.getBalances(state);
4550         balances[asset] = balances[asset].sub(amount);
4551         state.cash[asset] = state.cash[asset].sub(amount);
4552     }
4553 }
4554 
4555 library Types {
4556     enum AuctionStatus {
4557         InProgress,
4558         Finished
4559     }
4560 
4561     enum CollateralAccountStatus {
4562         Normal,
4563         Liquid
4564     }
4565 
4566     enum OrderStatus {
4567         EXPIRED,
4568         CANCELLED,
4569         FILLABLE,
4570         FULLY_FILLED
4571     }
4572 
4573     /**
4574      * Signature struct contains typical signature data as v, r, and s with the signature
4575      * method encoded in as well.
4576      */
4577     struct Signature {
4578         /**
4579          * Config contains the following values packed into 32 bytes
4580          * ╔════════════════════╤═══════════════════════════════════════════════════════════╗
4581          * ║                    │ length(bytes)   desc                                      ║
4582          * ╟────────────────────┼───────────────────────────────────────────────────────────╢
4583          * ║ v                  │ 1               the v parameter of a signature            ║
4584          * ║ signatureMethod    │ 1               SignatureMethod enum value                ║
4585          * ╚════════════════════╧═══════════════════════════════════════════════════════════╝
4586          */
4587         bytes32 config;
4588         bytes32 r;
4589         bytes32 s;
4590     }
4591 
4592     enum BalanceCategory {
4593         Common,
4594         CollateralAccount
4595     }
4596 
4597     struct BalancePath {
4598         BalanceCategory category;
4599         uint16          marketID;
4600         address         user;
4601     }
4602 
4603     struct Asset {
4604         ILendingPoolToken  lendingPoolToken;
4605         IPriceOracle      priceOracle;
4606         IInterestModel    interestModel;
4607     }
4608 
4609     struct Market {
4610         address baseAsset;
4611         address quoteAsset;
4612 
4613         // If the collateralRate is below this rate, the account will be liquidated
4614         uint256 liquidateRate;
4615 
4616         // If the collateralRate is above this rate, the account asset balance can be withdrawed
4617         uint256 withdrawRate;
4618 
4619         uint256 auctionRatioStart;
4620         uint256 auctionRatioPerBlock;
4621 
4622         bool borrowEnable;
4623     }
4624 
4625     struct CollateralAccount {
4626         uint32 id;
4627         uint16 marketID;
4628         CollateralAccountStatus status;
4629         address owner;
4630 
4631         mapping(address => uint256) balances;
4632     }
4633 
4634     // memory only
4635     struct CollateralAccountDetails {
4636         bool       liquidatable;
4637         CollateralAccountStatus status;
4638         uint256    debtsTotalUSDValue;
4639         uint256    balancesTotalUSDValue;
4640     }
4641 
4642     struct Auction {
4643         uint32 id;
4644         AuctionStatus status;
4645 
4646         // To calculate the ratio
4647         uint32 startBlockNumber;
4648 
4649         uint16 marketID;
4650 
4651         address borrower;
4652         address initiator;
4653 
4654         address debtAsset;
4655         address collateralAsset;
4656     }
4657 
4658     struct AuctionDetails {
4659         address borrower;
4660         uint16  marketID;
4661         address debtAsset;
4662         address collateralAsset;
4663         uint256 leftDebtAmount;
4664         uint256 leftCollateralAmount;
4665         uint256 ratio;
4666         uint256 price;
4667         bool    finished;
4668     }
4669 
4670     struct Order {
4671         address trader;
4672         address relayer;
4673         address baseAsset;
4674         address quoteAsset;
4675         uint256 baseAssetAmount;
4676         uint256 quoteAssetAmount;
4677         uint256 gasTokenAmount;
4678 
4679         /**
4680          * Data contains the following values packed into 32 bytes
4681          * ╔════════════════════╤═══════════════════════════════════════════════════════════╗
4682          * ║                    │ length(bytes)   desc                                      ║
4683          * ╟────────────────────┼───────────────────────────────────────────────────────────╢
4684          * ║ version            │ 1               order version                             ║
4685          * ║ side               │ 1               0: buy, 1: sell                           ║
4686          * ║ isMarketOrder      │ 1               0: limitOrder, 1: marketOrder             ║
4687          * ║ expiredAt          │ 5               order expiration time in seconds          ║
4688          * ║ asMakerFeeRate     │ 2               maker fee rate (base 100,000)             ║
4689          * ║ asTakerFeeRate     │ 2               taker fee rate (base 100,000)             ║
4690          * ║ makerRebateRate    │ 2               rebate rate for maker (base 100)          ║
4691          * ║ salt               │ 8               salt                                      ║
4692          * ║ isMakerOnly        │ 1               is maker only                             ║
4693          * ║ balancesType       │ 1               0: common, 1: collateralAccount           ║
4694          * ║ marketID           │ 2               marketID                                  ║
4695          * ║                    │ 6               reserved                                  ║
4696          * ╚════════════════════╧═══════════════════════════════════════════════════════════╝
4697          */
4698         bytes32 data;
4699     }
4700 
4701         /**
4702      * When orders are being matched, they will always contain the exact same base token,
4703      * quote token, and relayer. Since excessive call data is very expensive, we choose
4704      * to create a stripped down OrderParam struct containing only data that may vary between
4705      * Order objects, and separate out the common elements into a set of addresses that will
4706      * be shared among all of the OrderParam items. This is meant to eliminate redundancy in
4707      * the call data, reducing it's size, and hence saving gas.
4708      */
4709     struct OrderParam {
4710         address trader;
4711         uint256 baseAssetAmount;
4712         uint256 quoteAssetAmount;
4713         uint256 gasTokenAmount;
4714         bytes32 data;
4715         Signature signature;
4716     }
4717 
4718 
4719     struct OrderAddressSet {
4720         address baseAsset;
4721         address quoteAsset;
4722         address relayer;
4723     }
4724 
4725     struct MatchResult {
4726         address maker;
4727         address taker;
4728         address buyer;
4729         uint256 makerFee;
4730         uint256 makerRebate;
4731         uint256 takerFee;
4732         uint256 makerGasFee;
4733         uint256 takerGasFee;
4734         uint256 baseAssetFilledAmount;
4735         uint256 quoteAssetFilledAmount;
4736         BalancePath makerBalancePath;
4737         BalancePath takerBalancePath;
4738     }
4739     /**
4740      * @param takerOrderParam A Types.OrderParam object representing the order from the taker.
4741      * @param makerOrderParams An array of Types.OrderParam objects representing orders from a list of makers.
4742      * @param orderAddressSet An object containing addresses common across each order.
4743      */
4744     struct MatchParams {
4745         OrderParam       takerOrderParam;
4746         OrderParam[]     makerOrderParams;
4747         uint256[]        baseAssetFilledAmounts;
4748         OrderAddressSet  orderAddressSet;
4749     }
4750 }
4751 
4752 library Auction {
4753     using SafeMath for uint256;
4754 
4755     function ratio(
4756         Types.Auction memory auction,
4757         Store.State storage state
4758     )
4759         internal
4760         view
4761         returns (uint256)
4762     {
4763         uint256 increasedRatio = (block.number - auction.startBlockNumber).mul(state.markets[auction.marketID].auctionRatioPerBlock);
4764         uint256 initRatio = state.markets[auction.marketID].auctionRatioStart;
4765         uint256 totalRatio = initRatio.add(increasedRatio);
4766         return totalRatio;
4767     }
4768 }
4769 
4770 library BalancePath {
4771 
4772     function getBalances(
4773         Types.BalancePath memory path,
4774         Store.State storage state
4775     )
4776         internal
4777         view
4778         returns (mapping(address => uint256) storage)
4779     {
4780         if (path.category == Types.BalanceCategory.Common) {
4781             return state.balances[path.user];
4782         } else {
4783             return state.accounts[path.user][path.marketID].balances;
4784         }
4785     }
4786 
4787     function getCommonPath(
4788         address user
4789     )
4790         internal
4791         pure
4792         returns (Types.BalancePath memory)
4793     {
4794         return Types.BalancePath({
4795             user: user,
4796             category: Types.BalanceCategory.Common,
4797             marketID: 0
4798         });
4799     }
4800 
4801     function getMarketPath(
4802         address user,
4803         uint16 marketID
4804     )
4805         internal
4806         pure
4807         returns (Types.BalancePath memory)
4808     {
4809         return Types.BalancePath({
4810             user: user,
4811             category: Types.BalanceCategory.CollateralAccount,
4812             marketID: marketID
4813         });
4814     }
4815 }
4816 
4817 library Order {
4818 
4819     bytes32 public constant EIP712_ORDER_TYPE = keccak256(
4820         abi.encodePacked(
4821             "Order(address trader,address relayer,address baseAsset,address quoteAsset,uint256 baseAssetAmount,uint256 quoteAssetAmount,uint256 gasTokenAmount,bytes32 data)"
4822         )
4823     );
4824 
4825     /**
4826      * Calculates the Keccak-256 EIP712 hash of the order using the Hydro Protocol domain.
4827      *
4828      * @param order The order data struct.
4829      * @return Fully qualified EIP712 hash of the order in the Hydro Protocol domain.
4830      */
4831     function getHash(
4832         Types.Order memory order
4833     )
4834         internal
4835         pure
4836         returns (bytes32 orderHash)
4837     {
4838         orderHash = EIP712.hashMessage(_hashContent(order));
4839         return orderHash;
4840     }
4841 
4842     /**
4843      * Calculates the EIP712 hash of the order.
4844      *
4845      * @param order The order data struct.
4846      * @return Hash of the order.
4847      */
4848     function _hashContent(
4849         Types.Order memory order
4850     )
4851         internal
4852         pure
4853         returns (bytes32 result)
4854     {
4855         /**
4856          * Calculate the following hash in solidity assembly to save gas.
4857          *
4858          * keccak256(
4859          *     abi.encodePacked(
4860          *         EIP712_ORDER_TYPE,
4861          *         bytes32(order.trader),
4862          *         bytes32(order.relayer),
4863          *         bytes32(order.baseAsset),
4864          *         bytes32(order.quoteAsset),
4865          *         order.baseAssetAmount,
4866          *         order.quoteAssetAmount,
4867          *         order.gasTokenAmount,
4868          *         order.data
4869          *     )
4870          * );
4871          */
4872 
4873         bytes32 orderType = EIP712_ORDER_TYPE;
4874 
4875         assembly {
4876             let start := sub(order, 32)
4877             let tmp := mload(start)
4878 
4879             // 288 = (1 + 8) * 32
4880             //
4881             // [0...32)   bytes: EIP712_ORDER_TYPE
4882             // [32...288) bytes: order
4883             mstore(start, orderType)
4884             result := keccak256(start, 288)
4885 
4886             mstore(start, tmp)
4887         }
4888 
4889         return result;
4890     }
4891 }
4892 
4893 library OrderParam {
4894     /* Functions to extract info from data bytes in Order struct */
4895 
4896     function getOrderVersion(
4897         Types.OrderParam memory order
4898     )
4899         internal
4900         pure
4901         returns (uint256)
4902     {
4903         return uint256(uint8(byte(order.data)));
4904     }
4905 
4906     function getExpiredAtFromOrderData(
4907         Types.OrderParam memory order
4908     )
4909         internal
4910         pure
4911         returns (uint256)
4912     {
4913         return uint256(uint40(bytes5(order.data << (8*3))));
4914     }
4915 
4916     function isSell(
4917         Types.OrderParam memory order
4918     )
4919         internal
4920         pure
4921         returns (bool)
4922     {
4923         return uint8(order.data[1]) == 1;
4924     }
4925 
4926     function isMarketOrder(
4927         Types.OrderParam memory order
4928     )
4929         internal
4930         pure
4931         returns (bool)
4932     {
4933         return uint8(order.data[2]) == 1;
4934     }
4935 
4936     function isMakerOnly(
4937         Types.OrderParam memory order
4938     )
4939         internal
4940         pure
4941         returns (bool)
4942     {
4943         return uint8(order.data[22]) == 1;
4944     }
4945 
4946     function isMarketBuy(
4947         Types.OrderParam memory order
4948     )
4949         internal
4950         pure
4951         returns (bool)
4952     {
4953         return !isSell(order) && isMarketOrder(order);
4954     }
4955 
4956     function getAsMakerFeeRateFromOrderData(
4957         Types.OrderParam memory order
4958     )
4959         internal
4960         pure
4961         returns (uint256)
4962     {
4963         return uint256(uint16(bytes2(order.data << (8*8))));
4964     }
4965 
4966     function getAsTakerFeeRateFromOrderData(
4967         Types.OrderParam memory order
4968     )
4969         internal
4970         pure
4971         returns (uint256)
4972     {
4973         return uint256(uint16(bytes2(order.data << (8*10))));
4974     }
4975 
4976     function getMakerRebateRateFromOrderData(
4977         Types.OrderParam memory order
4978     )
4979         internal
4980         pure
4981         returns (uint256)
4982     {
4983         uint256 makerRebate = uint256(uint16(bytes2(order.data << (8*12))));
4984 
4985         // make sure makerRebate will never be larger than REBATE_RATE_BASE, which is 100
4986         return SafeMath.min(makerRebate, Consts.REBATE_RATE_BASE());
4987     }
4988 
4989     function getBalancePathFromOrderData(
4990         Types.OrderParam memory order
4991     )
4992         internal
4993         pure
4994         returns (Types.BalancePath memory)
4995     {
4996         Types.BalanceCategory category;
4997         uint16 marketID;
4998 
4999         if (byte(order.data << (8*23)) == "\x01") {
5000             category = Types.BalanceCategory.CollateralAccount;
5001             marketID = uint16(bytes2(order.data << (8*24)));
5002         } else {
5003             category = Types.BalanceCategory.Common;
5004             marketID = 0;
5005         }
5006 
5007         return Types.BalancePath({
5008             user: order.trader,
5009             category: category,
5010             marketID: marketID
5011         });
5012     }
5013 }