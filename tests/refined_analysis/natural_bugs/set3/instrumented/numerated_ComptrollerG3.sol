1 pragma solidity ^0.5.16;
2 
3 import "../CToken.sol";
4 import "../ErrorReporter.sol";
5 import "../Exponential.sol";
6 import "../PriceOracle/PriceOracle.sol";
7 import "../ComptrollerInterface.sol";
8 import "../ComptrollerStorage.sol";
9 import "../Unitroller.sol";
10 import "../Governance/Comp.sol";
11 
12 /**
13  * @title Compound's Comptroller Contract
14  * @author Compound
15  */
16 contract ComptrollerG3 is ComptrollerV3Storage, ComptrollerInterface, ComptrollerErrorReporter, Exponential {
17     /// @notice Emitted when an admin supports a market
18     event MarketListed(CToken cToken);
19 
20     /// @notice Emitted when an account enters a market
21     event MarketEntered(CToken cToken, address account);
22 
23     /// @notice Emitted when an account exits a market
24     event MarketExited(CToken cToken, address account);
25 
26     /// @notice Emitted when close factor is changed by admin
27     event NewCloseFactor(uint256 oldCloseFactorMantissa, uint256 newCloseFactorMantissa);
28 
29     /// @notice Emitted when a collateral factor is changed by admin
30     event NewCollateralFactor(CToken cToken, uint256 oldCollateralFactorMantissa, uint256 newCollateralFactorMantissa);
31 
32     /// @notice Emitted when liquidation incentive is changed by admin
33     event NewLiquidationIncentive(uint256 oldLiquidationIncentiveMantissa, uint256 newLiquidationIncentiveMantissa);
34 
35     /// @notice Emitted when maxAssets is changed by admin
36     event NewMaxAssets(uint256 oldMaxAssets, uint256 newMaxAssets);
37 
38     /// @notice Emitted when price oracle is changed
39     event NewPriceOracle(PriceOracle oldPriceOracle, PriceOracle newPriceOracle);
40 
41     /// @notice Emitted when pause guardian is changed
42     event NewPauseGuardian(address oldPauseGuardian, address newPauseGuardian);
43 
44     /// @notice Emitted when an action is paused globally
45     event ActionPaused(string action, bool pauseState);
46 
47     /// @notice Emitted when an action is paused on a market
48     event ActionPaused(CToken cToken, string action, bool pauseState);
49 
50     /// @notice Emitted when market comped status is changed
51     event MarketComped(CToken cToken, bool isComped);
52 
53     /// @notice Emitted when COMP rate is changed
54     event NewCompRate(uint256 oldCompRate, uint256 newCompRate);
55 
56     /// @notice Emitted when a new COMP speed is calculated for a market
57     event CompSpeedUpdated(CToken indexed cToken, uint256 newSpeed);
58 
59     /// @notice Emitted when COMP is distributed to a supplier
60     event DistributedSupplierComp(
61         CToken indexed cToken,
62         address indexed supplier,
63         uint256 compDelta,
64         uint256 compSupplyIndex
65     );
66 
67     /// @notice Emitted when COMP is distributed to a borrower
68     event DistributedBorrowerComp(
69         CToken indexed cToken,
70         address indexed borrower,
71         uint256 compDelta,
72         uint256 compBorrowIndex
73     );
74 
75     /// @notice The threshold above which the flywheel transfers COMP, in wei
76     uint256 public constant compClaimThreshold = 0.001e18;
77 
78     /// @notice The initial COMP index for a market
79     uint224 public constant compInitialIndex = 1e36;
80 
81     // closeFactorMantissa must be strictly greater than this value
82     uint256 internal constant closeFactorMinMantissa = 0.05e18; // 0.05
83 
84     // closeFactorMantissa must not exceed this value
85     uint256 internal constant closeFactorMaxMantissa = 0.9e18; // 0.9
86 
87     // No collateralFactorMantissa may exceed this value
88     uint256 internal constant collateralFactorMaxMantissa = 0.9e18; // 0.9
89 
90     // liquidationIncentiveMantissa must be no less than this value
91     uint256 internal constant liquidationIncentiveMinMantissa = 1.0e18; // 1.0
92 
93     // liquidationIncentiveMantissa must be no greater than this value
94     uint256 internal constant liquidationIncentiveMaxMantissa = 1.5e18; // 1.5
95 
96     constructor() public {
97         admin = msg.sender;
98     }
99 
100     /*** Assets You Are In ***/
101 
102     /**
103      * @notice Returns the assets an account has entered
104      * @param account The address of the account to pull assets for
105      * @return A dynamic list with the assets the account has entered
106      */
107     function getAssetsIn(address account) external view returns (CToken[] memory) {
108         CToken[] memory assetsIn = accountAssets[account];
109 
110         return assetsIn;
111     }
112 
113     /**
114      * @notice Returns whether the given account is entered in the given asset
115      * @param account The address of the account to check
116      * @param cToken The cToken to check
117      * @return True if the account is in the asset, otherwise false.
118      */
119     function checkMembership(address account, CToken cToken) external view returns (bool) {
120         return markets[address(cToken)].accountMembership[account];
121     }
122 
123     /**
124      * @notice Add assets to be included in account liquidity calculation
125      * @param cTokens The list of addresses of the cToken markets to be enabled
126      * @return Success indicator for whether each corresponding market was entered
127      */
128     function enterMarkets(address[] memory cTokens) public returns (uint256[] memory) {
129         uint256 len = cTokens.length;
130 
131         uint256[] memory results = new uint256[](len);
132         for (uint256 i = 0; i < len; i++) {
133             CToken cToken = CToken(cTokens[i]);
134 
135             results[i] = uint256(addToMarketInternal(cToken, msg.sender));
136         }
137 
138         return results;
139     }
140 
141     /**
142      * @notice Add the market to the borrower's "assets in" for liquidity calculations
143      * @param cToken The market to enter
144      * @param borrower The address of the account to modify
145      * @return Success indicator for whether the market was entered
146      */
147     function addToMarketInternal(CToken cToken, address borrower) internal returns (Error) {
148         Market storage marketToJoin = markets[address(cToken)];
149 
150         if (!marketToJoin.isListed) {
151             // market is not listed, cannot join
152             return Error.MARKET_NOT_LISTED;
153         }
154 
155         if (marketToJoin.accountMembership[borrower] == true) {
156             // already joined
157             return Error.NO_ERROR;
158         }
159 
160         if (accountAssets[borrower].length >= maxAssets) {
161             // no space, cannot join
162             return Error.TOO_MANY_ASSETS;
163         }
164 
165         // survived the gauntlet, add to list
166         // NOTE: we store these somewhat redundantly as a significant optimization
167         //  this avoids having to iterate through the list for the most common use cases
168         //  that is, only when we need to perform liquidity checks
169         //  and not whenever we want to check if an account is in a particular market
170         marketToJoin.accountMembership[borrower] = true;
171         accountAssets[borrower].push(cToken);
172 
173         emit MarketEntered(cToken, borrower);
174 
175         return Error.NO_ERROR;
176     }
177 
178     /**
179      * @notice Removes asset from sender's account liquidity calculation
180      * @dev Sender must not have an outstanding borrow balance in the asset,
181      *  or be providing neccessary collateral for an outstanding borrow.
182      * @param cTokenAddress The address of the asset to be removed
183      * @return Whether or not the account successfully exited the market
184      */
185     function exitMarket(address cTokenAddress) external returns (uint256) {
186         CToken cToken = CToken(cTokenAddress);
187         /* Get sender tokensHeld and amountOwed underlying from the cToken */
188         (uint256 oErr, uint256 tokensHeld, uint256 amountOwed, ) = cToken.getAccountSnapshot(msg.sender);
189         require(oErr == 0, "exitMarket: getAccountSnapshot failed"); // semi-opaque error code
190 
191         /* Fail if the sender has a borrow balance */
192         if (amountOwed != 0) {
193             return fail(Error.NONZERO_BORROW_BALANCE, FailureInfo.EXIT_MARKET_BALANCE_OWED);
194         }
195 
196         /* Fail if the sender is not permitted to redeem all of their tokens */
197         uint256 allowed = redeemAllowedInternal(cTokenAddress, msg.sender, tokensHeld);
198         if (allowed != 0) {
199             return failOpaque(Error.REJECTION, FailureInfo.EXIT_MARKET_REJECTION, allowed);
200         }
201 
202         Market storage marketToExit = markets[address(cToken)];
203 
204         /* Return true if the sender is not already ‘in’ the market */
205         if (!marketToExit.accountMembership[msg.sender]) {
206             return uint256(Error.NO_ERROR);
207         }
208 
209         /* Set cToken account membership to false */
210         delete marketToExit.accountMembership[msg.sender];
211 
212         /* Delete cToken from the account’s list of assets */
213         // load into memory for faster iteration
214         CToken[] memory userAssetList = accountAssets[msg.sender];
215         uint256 len = userAssetList.length;
216         uint256 assetIndex = len;
217         for (uint256 i = 0; i < len; i++) {
218             if (userAssetList[i] == cToken) {
219                 assetIndex = i;
220                 break;
221             }
222         }
223 
224         // We *must* have found the asset in the list or our redundant data structure is broken
225         assert(assetIndex < len);
226 
227         // copy last item in list to location of item to be removed, reduce length by 1
228         CToken[] storage storedList = accountAssets[msg.sender];
229         storedList[assetIndex] = storedList[storedList.length - 1];
230         storedList.length--;
231 
232         emit MarketExited(cToken, msg.sender);
233 
234         return uint256(Error.NO_ERROR);
235     }
236 
237     /*** Policy Hooks ***/
238 
239     /**
240      * @notice Checks if the account should be allowed to mint tokens in the given market
241      * @param cToken The market to verify the mint against
242      * @param minter The account which would get the minted tokens
243      * @param mintAmount The amount of underlying being supplied to the market in exchange for tokens
244      * @return 0 if the mint is allowed, otherwise a semi-opaque error code (See ErrorReporter.sol)
245      */
246     function mintAllowed(
247         address cToken,
248         address minter,
249         uint256 mintAmount
250     ) external returns (uint256) {
251         // Pausing is a very serious situation - we revert to sound the alarms
252         require(!mintGuardianPaused[cToken], "mint is paused");
253 
254         // Shh - currently unused
255         minter;
256         mintAmount;
257 
258         if (!markets[cToken].isListed) {
259             return uint256(Error.MARKET_NOT_LISTED);
260         }
261 
262         // Keep the flywheel moving
263         updateCompSupplyIndex(cToken);
264         distributeSupplierComp(cToken, minter, false);
265 
266         return uint256(Error.NO_ERROR);
267     }
268 
269     /**
270      * @notice Validates mint and reverts on rejection. May emit logs.
271      * @param cToken Asset being minted
272      * @param minter The address minting the tokens
273      * @param actualMintAmount The amount of the underlying asset being minted
274      * @param mintTokens The number of tokens being minted
275      */
276     function mintVerify(
277         address cToken,
278         address minter,
279         uint256 actualMintAmount,
280         uint256 mintTokens
281     ) external {
282         // Shh - currently unused
283         cToken;
284         minter;
285         actualMintAmount;
286         mintTokens;
287 
288         // Shh - we don't ever want this hook to be marked pure
289         if (false) {
290             maxAssets = maxAssets;
291         }
292     }
293 
294     /**
295      * @notice Checks if the account should be allowed to redeem tokens in the given market
296      * @param cToken The market to verify the redeem against
297      * @param redeemer The account which would redeem the tokens
298      * @param redeemTokens The number of cTokens to exchange for the underlying asset in the market
299      * @return 0 if the redeem is allowed, otherwise a semi-opaque error code (See ErrorReporter.sol)
300      */
301     function redeemAllowed(
302         address cToken,
303         address redeemer,
304         uint256 redeemTokens
305     ) external returns (uint256) {
306         uint256 allowed = redeemAllowedInternal(cToken, redeemer, redeemTokens);
307         if (allowed != uint256(Error.NO_ERROR)) {
308             return allowed;
309         }
310 
311         // Keep the flywheel moving
312         updateCompSupplyIndex(cToken);
313         distributeSupplierComp(cToken, redeemer, false);
314 
315         return uint256(Error.NO_ERROR);
316     }
317 
318     function redeemAllowedInternal(
319         address cToken,
320         address redeemer,
321         uint256 redeemTokens
322     ) internal view returns (uint256) {
323         if (!markets[cToken].isListed) {
324             return uint256(Error.MARKET_NOT_LISTED);
325         }
326 
327         /* If the redeemer is not 'in' the market, then we can bypass the liquidity check */
328         if (!markets[cToken].accountMembership[redeemer]) {
329             return uint256(Error.NO_ERROR);
330         }
331 
332         /* Otherwise, perform a hypothetical liquidity check to guard against shortfall */
333         (Error err, , uint256 shortfall) = getHypotheticalAccountLiquidityInternal(
334             redeemer,
335             CToken(cToken),
336             redeemTokens,
337             0
338         );
339         if (err != Error.NO_ERROR) {
340             return uint256(err);
341         }
342         if (shortfall > 0) {
343             return uint256(Error.INSUFFICIENT_LIQUIDITY);
344         }
345 
346         return uint256(Error.NO_ERROR);
347     }
348 
349     /**
350      * @notice Validates redeem and reverts on rejection. May emit logs.
351      * @param cToken Asset being redeemed
352      * @param redeemer The address redeeming the tokens
353      * @param redeemAmount The amount of the underlying asset being redeemed
354      * @param redeemTokens The number of tokens being redeemed
355      */
356     function redeemVerify(
357         address cToken,
358         address redeemer,
359         uint256 redeemAmount,
360         uint256 redeemTokens
361     ) external {
362         // Shh - currently unused
363         cToken;
364         redeemer;
365 
366         // Require tokens is zero or amount is also zero
367         if (redeemTokens == 0 && redeemAmount > 0) {
368             revert("redeemTokens zero");
369         }
370     }
371 
372     /**
373      * @notice Checks if the account should be allowed to borrow the underlying asset of the given market
374      * @param cToken The market to verify the borrow against
375      * @param borrower The account which would borrow the asset
376      * @param borrowAmount The amount of underlying the account would borrow
377      * @return 0 if the borrow is allowed, otherwise a semi-opaque error code (See ErrorReporter.sol)
378      */
379     function borrowAllowed(
380         address cToken,
381         address borrower,
382         uint256 borrowAmount
383     ) external returns (uint256) {
384         // Pausing is a very serious situation - we revert to sound the alarms
385         require(!borrowGuardianPaused[cToken], "borrow is paused");
386 
387         if (!markets[cToken].isListed) {
388             return uint256(Error.MARKET_NOT_LISTED);
389         }
390 
391         if (!markets[cToken].accountMembership[borrower]) {
392             // only cTokens may call borrowAllowed if borrower not in market
393             require(msg.sender == cToken, "sender must be cToken");
394 
395             // attempt to add borrower to the market
396             Error err = addToMarketInternal(CToken(msg.sender), borrower);
397             if (err != Error.NO_ERROR) {
398                 return uint256(err);
399             }
400 
401             // it should be impossible to break the important invariant
402             assert(markets[cToken].accountMembership[borrower]);
403         }
404 
405         if (oracle.getUnderlyingPrice(CToken(cToken)) == 0) {
406             return uint256(Error.PRICE_ERROR);
407         }
408 
409         (Error err, , uint256 shortfall) = getHypotheticalAccountLiquidityInternal(
410             borrower,
411             CToken(cToken),
412             0,
413             borrowAmount
414         );
415         if (err != Error.NO_ERROR) {
416             return uint256(err);
417         }
418         if (shortfall > 0) {
419             return uint256(Error.INSUFFICIENT_LIQUIDITY);
420         }
421 
422         // Keep the flywheel moving
423         Exp memory borrowIndex = Exp({mantissa: CToken(cToken).borrowIndex()});
424         updateCompBorrowIndex(cToken, borrowIndex);
425         distributeBorrowerComp(cToken, borrower, borrowIndex, false);
426 
427         return uint256(Error.NO_ERROR);
428     }
429 
430     /**
431      * @notice Validates borrow and reverts on rejection. May emit logs.
432      * @param cToken Asset whose underlying is being borrowed
433      * @param borrower The address borrowing the underlying
434      * @param borrowAmount The amount of the underlying asset requested to borrow
435      */
436     function borrowVerify(
437         address cToken,
438         address borrower,
439         uint256 borrowAmount
440     ) external {
441         // Shh - currently unused
442         cToken;
443         borrower;
444         borrowAmount;
445 
446         // Shh - we don't ever want this hook to be marked pure
447         if (false) {
448             maxAssets = maxAssets;
449         }
450     }
451 
452     /**
453      * @notice Checks if the account should be allowed to repay a borrow in the given market
454      * @param cToken The market to verify the repay against
455      * @param payer The account which would repay the asset
456      * @param borrower The account which would borrowed the asset
457      * @param repayAmount The amount of the underlying asset the account would repay
458      * @return 0 if the repay is allowed, otherwise a semi-opaque error code (See ErrorReporter.sol)
459      */
460     function repayBorrowAllowed(
461         address cToken,
462         address payer,
463         address borrower,
464         uint256 repayAmount
465     ) external returns (uint256) {
466         // Shh - currently unused
467         payer;
468         borrower;
469         repayAmount;
470 
471         if (!markets[cToken].isListed) {
472             return uint256(Error.MARKET_NOT_LISTED);
473         }
474 
475         // Keep the flywheel moving
476         Exp memory borrowIndex = Exp({mantissa: CToken(cToken).borrowIndex()});
477         updateCompBorrowIndex(cToken, borrowIndex);
478         distributeBorrowerComp(cToken, borrower, borrowIndex, false);
479 
480         return uint256(Error.NO_ERROR);
481     }
482 
483     /**
484      * @notice Validates repayBorrow and reverts on rejection. May emit logs.
485      * @param cToken Asset being repaid
486      * @param payer The address repaying the borrow
487      * @param borrower The address of the borrower
488      * @param actualRepayAmount The amount of underlying being repaid
489      */
490     function repayBorrowVerify(
491         address cToken,
492         address payer,
493         address borrower,
494         uint256 actualRepayAmount,
495         uint256 borrowerIndex
496     ) external {
497         // Shh - currently unused
498         cToken;
499         payer;
500         borrower;
501         actualRepayAmount;
502         borrowerIndex;
503 
504         // Shh - we don't ever want this hook to be marked pure
505         if (false) {
506             maxAssets = maxAssets;
507         }
508     }
509 
510     /**
511      * @notice Checks if the liquidation should be allowed to occur
512      * @param cTokenBorrowed Asset which was borrowed by the borrower
513      * @param cTokenCollateral Asset which was used as collateral and will be seized
514      * @param liquidator The address repaying the borrow and seizing the collateral
515      * @param borrower The address of the borrower
516      * @param repayAmount The amount of underlying being repaid
517      */
518     function liquidateBorrowAllowed(
519         address cTokenBorrowed,
520         address cTokenCollateral,
521         address liquidator,
522         address borrower,
523         uint256 repayAmount
524     ) external returns (uint256) {
525         // Shh - currently unused
526         liquidator;
527 
528         if (!markets[cTokenBorrowed].isListed || !markets[cTokenCollateral].isListed) {
529             return uint256(Error.MARKET_NOT_LISTED);
530         }
531 
532         /* The borrower must have shortfall in order to be liquidatable */
533         (Error err, , uint256 shortfall) = getAccountLiquidityInternal(borrower);
534         if (err != Error.NO_ERROR) {
535             return uint256(err);
536         }
537         if (shortfall == 0) {
538             return uint256(Error.INSUFFICIENT_SHORTFALL);
539         }
540 
541         /* The liquidator may not repay more than what is allowed by the closeFactor */
542         uint256 borrowBalance = CToken(cTokenBorrowed).borrowBalanceStored(borrower);
543         (MathError mathErr, uint256 maxClose) = mulScalarTruncate(Exp({mantissa: closeFactorMantissa}), borrowBalance);
544         if (mathErr != MathError.NO_ERROR) {
545             return uint256(Error.MATH_ERROR);
546         }
547         if (repayAmount > maxClose) {
548             return uint256(Error.TOO_MUCH_REPAY);
549         }
550 
551         return uint256(Error.NO_ERROR);
552     }
553 
554     /**
555      * @notice Validates liquidateBorrow and reverts on rejection. May emit logs.
556      * @param cTokenBorrowed Asset which was borrowed by the borrower
557      * @param cTokenCollateral Asset which was used as collateral and will be seized
558      * @param liquidator The address repaying the borrow and seizing the collateral
559      * @param borrower The address of the borrower
560      * @param actualRepayAmount The amount of underlying being repaid
561      */
562     function liquidateBorrowVerify(
563         address cTokenBorrowed,
564         address cTokenCollateral,
565         address liquidator,
566         address borrower,
567         uint256 actualRepayAmount,
568         uint256 seizeTokens
569     ) external {
570         // Shh - currently unused
571         cTokenBorrowed;
572         cTokenCollateral;
573         liquidator;
574         borrower;
575         actualRepayAmount;
576         seizeTokens;
577 
578         // Shh - we don't ever want this hook to be marked pure
579         if (false) {
580             maxAssets = maxAssets;
581         }
582     }
583 
584     /**
585      * @notice Checks if the seizing of assets should be allowed to occur
586      * @param cTokenCollateral Asset which was used as collateral and will be seized
587      * @param cTokenBorrowed Asset which was borrowed by the borrower
588      * @param liquidator The address repaying the borrow and seizing the collateral
589      * @param borrower The address of the borrower
590      * @param seizeTokens The number of collateral tokens to seize
591      */
592     function seizeAllowed(
593         address cTokenCollateral,
594         address cTokenBorrowed,
595         address liquidator,
596         address borrower,
597         uint256 seizeTokens
598     ) external returns (uint256) {
599         // Pausing is a very serious situation - we revert to sound the alarms
600         require(!seizeGuardianPaused, "seize is paused");
601 
602         // Shh - currently unused
603         seizeTokens;
604 
605         if (!markets[cTokenCollateral].isListed || !markets[cTokenBorrowed].isListed) {
606             return uint256(Error.MARKET_NOT_LISTED);
607         }
608 
609         if (CToken(cTokenCollateral).comptroller() != CToken(cTokenBorrowed).comptroller()) {
610             return uint256(Error.COMPTROLLER_MISMATCH);
611         }
612 
613         // Keep the flywheel moving
614         updateCompSupplyIndex(cTokenCollateral);
615         distributeSupplierComp(cTokenCollateral, borrower, false);
616         distributeSupplierComp(cTokenCollateral, liquidator, false);
617 
618         return uint256(Error.NO_ERROR);
619     }
620 
621     /**
622      * @notice Validates seize and reverts on rejection. May emit logs.
623      * @param cTokenCollateral Asset which was used as collateral and will be seized
624      * @param cTokenBorrowed Asset which was borrowed by the borrower
625      * @param liquidator The address repaying the borrow and seizing the collateral
626      * @param borrower The address of the borrower
627      * @param seizeTokens The number of collateral tokens to seize
628      */
629     function seizeVerify(
630         address cTokenCollateral,
631         address cTokenBorrowed,
632         address liquidator,
633         address borrower,
634         uint256 seizeTokens
635     ) external {
636         // Shh - currently unused
637         cTokenCollateral;
638         cTokenBorrowed;
639         liquidator;
640         borrower;
641         seizeTokens;
642 
643         // Shh - we don't ever want this hook to be marked pure
644         if (false) {
645             maxAssets = maxAssets;
646         }
647     }
648 
649     /**
650      * @notice Checks if the account should be allowed to transfer tokens in the given market
651      * @param cToken The market to verify the transfer against
652      * @param src The account which sources the tokens
653      * @param dst The account which receives the tokens
654      * @param transferTokens The number of cTokens to transfer
655      * @return 0 if the transfer is allowed, otherwise a semi-opaque error code (See ErrorReporter.sol)
656      */
657     function transferAllowed(
658         address cToken,
659         address src,
660         address dst,
661         uint256 transferTokens
662     ) external returns (uint256) {
663         // Pausing is a very serious situation - we revert to sound the alarms
664         require(!transferGuardianPaused, "transfer is paused");
665 
666         // Currently the only consideration is whether or not
667         //  the src is allowed to redeem this many tokens
668         uint256 allowed = redeemAllowedInternal(cToken, src, transferTokens);
669         if (allowed != uint256(Error.NO_ERROR)) {
670             return allowed;
671         }
672 
673         // Keep the flywheel moving
674         updateCompSupplyIndex(cToken);
675         distributeSupplierComp(cToken, src, false);
676         distributeSupplierComp(cToken, dst, false);
677 
678         return uint256(Error.NO_ERROR);
679     }
680 
681     /**
682      * @notice Validates transfer and reverts on rejection. May emit logs.
683      * @param cToken Asset being transferred
684      * @param src The account which sources the tokens
685      * @param dst The account which receives the tokens
686      * @param transferTokens The number of cTokens to transfer
687      */
688     function transferVerify(
689         address cToken,
690         address src,
691         address dst,
692         uint256 transferTokens
693     ) external {
694         // Shh - currently unused
695         cToken;
696         src;
697         dst;
698         transferTokens;
699 
700         // Shh - we don't ever want this hook to be marked pure
701         if (false) {
702             maxAssets = maxAssets;
703         }
704     }
705 
706     /*** Liquidity/Liquidation Calculations ***/
707 
708     /**
709      * @dev Local vars for avoiding stack-depth limits in calculating account liquidity.
710      *  Note that `cTokenBalance` is the number of cTokens the account owns in the market,
711      *  whereas `borrowBalance` is the amount of underlying that the account has borrowed.
712      */
713     struct AccountLiquidityLocalVars {
714         uint256 sumCollateral;
715         uint256 sumBorrowPlusEffects;
716         uint256 cTokenBalance;
717         uint256 borrowBalance;
718         uint256 exchangeRateMantissa;
719         uint256 oraclePriceMantissa;
720         Exp collateralFactor;
721         Exp exchangeRate;
722         Exp oraclePrice;
723         Exp tokensToDenom;
724     }
725 
726     /**
727      * @notice Determine the current account liquidity wrt collateral requirements
728      * @return (possible error code (semi-opaque),
729                 account liquidity in excess of collateral requirements,
730      *          account shortfall below collateral requirements)
731      */
732     function getAccountLiquidity(address account)
733         public
734         view
735         returns (
736             uint256,
737             uint256,
738             uint256
739         )
740     {
741         (Error err, uint256 liquidity, uint256 shortfall) = getHypotheticalAccountLiquidityInternal(
742             account,
743             CToken(0),
744             0,
745             0
746         );
747 
748         return (uint256(err), liquidity, shortfall);
749     }
750 
751     /**
752      * @notice Determine the current account liquidity wrt collateral requirements
753      * @return (possible error code,
754                 account liquidity in excess of collateral requirements,
755      *          account shortfall below collateral requirements)
756      */
757     function getAccountLiquidityInternal(address account)
758         internal
759         view
760         returns (
761             Error,
762             uint256,
763             uint256
764         )
765     {
766         return getHypotheticalAccountLiquidityInternal(account, CToken(0), 0, 0);
767     }
768 
769     /**
770      * @notice Determine what the account liquidity would be if the given amounts were redeemed/borrowed
771      * @param cTokenModify The market to hypothetically redeem/borrow in
772      * @param account The account to determine liquidity for
773      * @param redeemTokens The number of tokens to hypothetically redeem
774      * @param borrowAmount The amount of underlying to hypothetically borrow
775      * @return (possible error code (semi-opaque),
776                 hypothetical account liquidity in excess of collateral requirements,
777      *          hypothetical account shortfall below collateral requirements)
778      */
779     function getHypotheticalAccountLiquidity(
780         address account,
781         address cTokenModify,
782         uint256 redeemTokens,
783         uint256 borrowAmount
784     )
785         public
786         view
787         returns (
788             uint256,
789             uint256,
790             uint256
791         )
792     {
793         (Error err, uint256 liquidity, uint256 shortfall) = getHypotheticalAccountLiquidityInternal(
794             account,
795             CToken(cTokenModify),
796             redeemTokens,
797             borrowAmount
798         );
799         return (uint256(err), liquidity, shortfall);
800     }
801 
802     /**
803      * @notice Determine what the account liquidity would be if the given amounts were redeemed/borrowed
804      * @param cTokenModify The market to hypothetically redeem/borrow in
805      * @param account The account to determine liquidity for
806      * @param redeemTokens The number of tokens to hypothetically redeem
807      * @param borrowAmount The amount of underlying to hypothetically borrow
808      * @dev Note that we calculate the exchangeRateStored for each collateral cToken using stored data,
809      *  without calculating accumulated interest.
810      * @return (possible error code,
811                 hypothetical account liquidity in excess of collateral requirements,
812      *          hypothetical account shortfall below collateral requirements)
813      */
814     function getHypotheticalAccountLiquidityInternal(
815         address account,
816         CToken cTokenModify,
817         uint256 redeemTokens,
818         uint256 borrowAmount
819     )
820         internal
821         view
822         returns (
823             Error,
824             uint256,
825             uint256
826         )
827     {
828         AccountLiquidityLocalVars memory vars; // Holds all our calculation results
829         uint256 oErr;
830         MathError mErr;
831 
832         // For each asset the account is in
833         CToken[] memory assets = accountAssets[account];
834         for (uint256 i = 0; i < assets.length; i++) {
835             CToken asset = assets[i];
836 
837             // Read the balances and exchange rate from the cToken
838             (oErr, vars.cTokenBalance, vars.borrowBalance, vars.exchangeRateMantissa) = asset.getAccountSnapshot(
839                 account
840             );
841             if (oErr != 0) {
842                 // semi-opaque error code, we assume NO_ERROR == 0 is invariant between upgrades
843                 return (Error.SNAPSHOT_ERROR, 0, 0);
844             }
845             vars.collateralFactor = Exp({mantissa: markets[address(asset)].collateralFactorMantissa});
846             vars.exchangeRate = Exp({mantissa: vars.exchangeRateMantissa});
847 
848             // Get the normalized price of the asset
849             vars.oraclePriceMantissa = oracle.getUnderlyingPrice(asset);
850             if (vars.oraclePriceMantissa == 0) {
851                 return (Error.PRICE_ERROR, 0, 0);
852             }
853             vars.oraclePrice = Exp({mantissa: vars.oraclePriceMantissa});
854 
855             // Pre-compute a conversion factor from tokens -> ether (normalized price value)
856             (mErr, vars.tokensToDenom) = mulExp3(vars.collateralFactor, vars.exchangeRate, vars.oraclePrice);
857             if (mErr != MathError.NO_ERROR) {
858                 return (Error.MATH_ERROR, 0, 0);
859             }
860 
861             // sumCollateral += tokensToDenom * cTokenBalance
862             (mErr, vars.sumCollateral) = mulScalarTruncateAddUInt(
863                 vars.tokensToDenom,
864                 vars.cTokenBalance,
865                 vars.sumCollateral
866             );
867             if (mErr != MathError.NO_ERROR) {
868                 return (Error.MATH_ERROR, 0, 0);
869             }
870 
871             // sumBorrowPlusEffects += oraclePrice * borrowBalance
872             (mErr, vars.sumBorrowPlusEffects) = mulScalarTruncateAddUInt(
873                 vars.oraclePrice,
874                 vars.borrowBalance,
875                 vars.sumBorrowPlusEffects
876             );
877             if (mErr != MathError.NO_ERROR) {
878                 return (Error.MATH_ERROR, 0, 0);
879             }
880 
881             // Calculate effects of interacting with cTokenModify
882             if (asset == cTokenModify) {
883                 // redeem effect
884                 // sumBorrowPlusEffects += tokensToDenom * redeemTokens
885                 (mErr, vars.sumBorrowPlusEffects) = mulScalarTruncateAddUInt(
886                     vars.tokensToDenom,
887                     redeemTokens,
888                     vars.sumBorrowPlusEffects
889                 );
890                 if (mErr != MathError.NO_ERROR) {
891                     return (Error.MATH_ERROR, 0, 0);
892                 }
893 
894                 // borrow effect
895                 // sumBorrowPlusEffects += oraclePrice * borrowAmount
896                 (mErr, vars.sumBorrowPlusEffects) = mulScalarTruncateAddUInt(
897                     vars.oraclePrice,
898                     borrowAmount,
899                     vars.sumBorrowPlusEffects
900                 );
901                 if (mErr != MathError.NO_ERROR) {
902                     return (Error.MATH_ERROR, 0, 0);
903                 }
904             }
905         }
906 
907         // These are safe, as the underflow condition is checked first
908         if (vars.sumCollateral > vars.sumBorrowPlusEffects) {
909             return (Error.NO_ERROR, vars.sumCollateral - vars.sumBorrowPlusEffects, 0);
910         } else {
911             return (Error.NO_ERROR, 0, vars.sumBorrowPlusEffects - vars.sumCollateral);
912         }
913     }
914 
915     /**
916      * @notice Calculate number of tokens of collateral asset to seize given an underlying amount
917      * @dev Used in liquidation (called in cToken.liquidateBorrowFresh)
918      * @param cTokenBorrowed The address of the borrowed cToken
919      * @param cTokenCollateral The address of the collateral cToken
920      * @param actualRepayAmount The amount of cTokenBorrowed underlying to convert into cTokenCollateral tokens
921      * @return (errorCode, number of cTokenCollateral tokens to be seized in a liquidation)
922      */
923     function liquidateCalculateSeizeTokens(
924         address cTokenBorrowed,
925         address cTokenCollateral,
926         uint256 actualRepayAmount
927     ) external view returns (uint256, uint256) {
928         /* Read oracle prices for borrowed and collateral markets */
929         uint256 priceBorrowedMantissa = oracle.getUnderlyingPrice(CToken(cTokenBorrowed));
930         uint256 priceCollateralMantissa = oracle.getUnderlyingPrice(CToken(cTokenCollateral));
931         if (priceBorrowedMantissa == 0 || priceCollateralMantissa == 0) {
932             return (uint256(Error.PRICE_ERROR), 0);
933         }
934 
935         /*
936          * Get the exchange rate and calculate the number of collateral tokens to seize:
937          *  seizeAmount = actualRepayAmount * liquidationIncentive * priceBorrowed / priceCollateral
938          *  seizeTokens = seizeAmount / exchangeRate
939          *   = actualRepayAmount * (liquidationIncentive * priceBorrowed) / (priceCollateral * exchangeRate)
940          */
941         uint256 exchangeRateMantissa = CToken(cTokenCollateral).exchangeRateStored(); // Note: reverts on error
942         uint256 seizeTokens;
943         Exp memory numerator;
944         Exp memory denominator;
945         Exp memory ratio;
946         MathError mathErr;
947 
948         (mathErr, numerator) = mulExp(liquidationIncentiveMantissa, priceBorrowedMantissa);
949         if (mathErr != MathError.NO_ERROR) {
950             return (uint256(Error.MATH_ERROR), 0);
951         }
952 
953         (mathErr, denominator) = mulExp(priceCollateralMantissa, exchangeRateMantissa);
954         if (mathErr != MathError.NO_ERROR) {
955             return (uint256(Error.MATH_ERROR), 0);
956         }
957 
958         (mathErr, ratio) = divExp(numerator, denominator);
959         if (mathErr != MathError.NO_ERROR) {
960             return (uint256(Error.MATH_ERROR), 0);
961         }
962 
963         (mathErr, seizeTokens) = mulScalarTruncate(ratio, actualRepayAmount);
964         if (mathErr != MathError.NO_ERROR) {
965             return (uint256(Error.MATH_ERROR), 0);
966         }
967 
968         return (uint256(Error.NO_ERROR), seizeTokens);
969     }
970 
971     /*** Admin Functions ***/
972 
973     /**
974      * @notice Sets a new price oracle for the comptroller
975      * @dev Admin function to set a new price oracle
976      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
977      */
978     function _setPriceOracle(PriceOracle newOracle) public returns (uint256) {
979         // Check caller is admin
980         if (msg.sender != admin) {
981             return fail(Error.UNAUTHORIZED, FailureInfo.SET_PRICE_ORACLE_OWNER_CHECK);
982         }
983 
984         // Track the old oracle for the comptroller
985         PriceOracle oldOracle = oracle;
986 
987         // Set comptroller's oracle to newOracle
988         oracle = newOracle;
989 
990         // Emit NewPriceOracle(oldOracle, newOracle)
991         emit NewPriceOracle(oldOracle, newOracle);
992 
993         return uint256(Error.NO_ERROR);
994     }
995 
996     /**
997      * @notice Sets the closeFactor used when liquidating borrows
998      * @dev Admin function to set closeFactor
999      * @param newCloseFactorMantissa New close factor, scaled by 1e18
1000      * @return uint 0=success, otherwise a failure. (See ErrorReporter for details)
1001      */
1002     function _setCloseFactor(uint256 newCloseFactorMantissa) external returns (uint256) {
1003         // Check caller is admin
1004         if (msg.sender != admin) {
1005             return fail(Error.UNAUTHORIZED, FailureInfo.SET_CLOSE_FACTOR_OWNER_CHECK);
1006         }
1007 
1008         Exp memory newCloseFactorExp = Exp({mantissa: newCloseFactorMantissa});
1009         Exp memory lowLimit = Exp({mantissa: closeFactorMinMantissa});
1010         if (lessThanOrEqualExp(newCloseFactorExp, lowLimit)) {
1011             return fail(Error.INVALID_CLOSE_FACTOR, FailureInfo.SET_CLOSE_FACTOR_VALIDATION);
1012         }
1013 
1014         Exp memory highLimit = Exp({mantissa: closeFactorMaxMantissa});
1015         if (lessThanExp(highLimit, newCloseFactorExp)) {
1016             return fail(Error.INVALID_CLOSE_FACTOR, FailureInfo.SET_CLOSE_FACTOR_VALIDATION);
1017         }
1018 
1019         uint256 oldCloseFactorMantissa = closeFactorMantissa;
1020         closeFactorMantissa = newCloseFactorMantissa;
1021         emit NewCloseFactor(oldCloseFactorMantissa, closeFactorMantissa);
1022 
1023         return uint256(Error.NO_ERROR);
1024     }
1025 
1026     /**
1027      * @notice Sets the collateralFactor for a market
1028      * @dev Admin function to set per-market collateralFactor
1029      * @param cToken The market to set the factor on
1030      * @param newCollateralFactorMantissa The new collateral factor, scaled by 1e18
1031      * @return uint 0=success, otherwise a failure. (See ErrorReporter for details)
1032      */
1033     function _setCollateralFactor(CToken cToken, uint256 newCollateralFactorMantissa) external returns (uint256) {
1034         // Check caller is admin
1035         if (msg.sender != admin) {
1036             return fail(Error.UNAUTHORIZED, FailureInfo.SET_COLLATERAL_FACTOR_OWNER_CHECK);
1037         }
1038 
1039         // Verify market is listed
1040         Market storage market = markets[address(cToken)];
1041         if (!market.isListed) {
1042             return fail(Error.MARKET_NOT_LISTED, FailureInfo.SET_COLLATERAL_FACTOR_NO_EXISTS);
1043         }
1044 
1045         Exp memory newCollateralFactorExp = Exp({mantissa: newCollateralFactorMantissa});
1046 
1047         // Check collateral factor <= 0.9
1048         Exp memory highLimit = Exp({mantissa: collateralFactorMaxMantissa});
1049         if (lessThanExp(highLimit, newCollateralFactorExp)) {
1050             return fail(Error.INVALID_COLLATERAL_FACTOR, FailureInfo.SET_COLLATERAL_FACTOR_VALIDATION);
1051         }
1052 
1053         // If collateral factor != 0, fail if price == 0
1054         if (newCollateralFactorMantissa != 0 && oracle.getUnderlyingPrice(cToken) == 0) {
1055             return fail(Error.PRICE_ERROR, FailureInfo.SET_COLLATERAL_FACTOR_WITHOUT_PRICE);
1056         }
1057 
1058         // Set market's collateral factor to new collateral factor, remember old value
1059         uint256 oldCollateralFactorMantissa = market.collateralFactorMantissa;
1060         market.collateralFactorMantissa = newCollateralFactorMantissa;
1061 
1062         // Emit event with asset, old collateral factor, and new collateral factor
1063         emit NewCollateralFactor(cToken, oldCollateralFactorMantissa, newCollateralFactorMantissa);
1064 
1065         return uint256(Error.NO_ERROR);
1066     }
1067 
1068     /**
1069      * @notice Sets maxAssets which controls how many markets can be entered
1070      * @dev Admin function to set maxAssets
1071      * @param newMaxAssets New max assets
1072      * @return uint 0=success, otherwise a failure. (See ErrorReporter for details)
1073      */
1074     function _setMaxAssets(uint256 newMaxAssets) external returns (uint256) {
1075         // Check caller is admin
1076         if (msg.sender != admin) {
1077             return fail(Error.UNAUTHORIZED, FailureInfo.SET_MAX_ASSETS_OWNER_CHECK);
1078         }
1079 
1080         uint256 oldMaxAssets = maxAssets;
1081         maxAssets = newMaxAssets;
1082         emit NewMaxAssets(oldMaxAssets, newMaxAssets);
1083 
1084         return uint256(Error.NO_ERROR);
1085     }
1086 
1087     /**
1088      * @notice Sets liquidationIncentive
1089      * @dev Admin function to set liquidationIncentive
1090      * @param newLiquidationIncentiveMantissa New liquidationIncentive scaled by 1e18
1091      * @return uint 0=success, otherwise a failure. (See ErrorReporter for details)
1092      */
1093     function _setLiquidationIncentive(uint256 newLiquidationIncentiveMantissa) external returns (uint256) {
1094         // Check caller is admin
1095         if (msg.sender != admin) {
1096             return fail(Error.UNAUTHORIZED, FailureInfo.SET_LIQUIDATION_INCENTIVE_OWNER_CHECK);
1097         }
1098 
1099         // Check de-scaled min <= newLiquidationIncentive <= max
1100         Exp memory newLiquidationIncentive = Exp({mantissa: newLiquidationIncentiveMantissa});
1101         Exp memory minLiquidationIncentive = Exp({mantissa: liquidationIncentiveMinMantissa});
1102         if (lessThanExp(newLiquidationIncentive, minLiquidationIncentive)) {
1103             return fail(Error.INVALID_LIQUIDATION_INCENTIVE, FailureInfo.SET_LIQUIDATION_INCENTIVE_VALIDATION);
1104         }
1105 
1106         Exp memory maxLiquidationIncentive = Exp({mantissa: liquidationIncentiveMaxMantissa});
1107         if (lessThanExp(maxLiquidationIncentive, newLiquidationIncentive)) {
1108             return fail(Error.INVALID_LIQUIDATION_INCENTIVE, FailureInfo.SET_LIQUIDATION_INCENTIVE_VALIDATION);
1109         }
1110 
1111         // Save current value for use in log
1112         uint256 oldLiquidationIncentiveMantissa = liquidationIncentiveMantissa;
1113 
1114         // Set liquidation incentive to new incentive
1115         liquidationIncentiveMantissa = newLiquidationIncentiveMantissa;
1116 
1117         // Emit event with old incentive, new incentive
1118         emit NewLiquidationIncentive(oldLiquidationIncentiveMantissa, newLiquidationIncentiveMantissa);
1119 
1120         return uint256(Error.NO_ERROR);
1121     }
1122 
1123     /**
1124      * @notice Add the market to the markets mapping and set it as listed
1125      * @dev Admin function to set isListed and add support for the market
1126      * @param cToken The address of the market (token) to list
1127      * @return uint 0=success, otherwise a failure. (See enum Error for details)
1128      */
1129     function _supportMarket(CToken cToken) external returns (uint256) {
1130         if (msg.sender != admin) {
1131             return fail(Error.UNAUTHORIZED, FailureInfo.SUPPORT_MARKET_OWNER_CHECK);
1132         }
1133 
1134         if (markets[address(cToken)].isListed) {
1135             return fail(Error.MARKET_ALREADY_LISTED, FailureInfo.SUPPORT_MARKET_EXISTS);
1136         }
1137 
1138         cToken.isCToken(); // Sanity check to make sure its really a CToken
1139 
1140         markets[address(cToken)] = Market({
1141             isListed: true,
1142             isComped: false,
1143             collateralFactorMantissa: 0,
1144             version: Version.VANILLA
1145         });
1146 
1147         _addMarketInternal(address(cToken));
1148 
1149         emit MarketListed(cToken);
1150 
1151         return uint256(Error.NO_ERROR);
1152     }
1153 
1154     function _addMarketInternal(address cToken) internal {
1155         for (uint256 i = 0; i < allMarkets.length; i++) {
1156             require(allMarkets[i] != CToken(cToken), "market already added");
1157         }
1158         allMarkets.push(CToken(cToken));
1159     }
1160 
1161     /**
1162      * @notice Admin function to change the Pause Guardian
1163      * @param newPauseGuardian The address of the new Pause Guardian
1164      * @return uint 0=success, otherwise a failure. (See enum Error for details)
1165      */
1166     function _setPauseGuardian(address newPauseGuardian) public returns (uint256) {
1167         if (msg.sender != admin) {
1168             return fail(Error.UNAUTHORIZED, FailureInfo.SET_PAUSE_GUARDIAN_OWNER_CHECK);
1169         }
1170 
1171         // Save current value for inclusion in log
1172         address oldPauseGuardian = pauseGuardian;
1173 
1174         // Store pauseGuardian with value newPauseGuardian
1175         pauseGuardian = newPauseGuardian;
1176 
1177         // Emit NewPauseGuardian(OldPauseGuardian, NewPauseGuardian)
1178         emit NewPauseGuardian(oldPauseGuardian, pauseGuardian);
1179 
1180         return uint256(Error.NO_ERROR);
1181     }
1182 
1183     function _setMintPaused(CToken cToken, bool state) public returns (bool) {
1184         require(markets[address(cToken)].isListed, "cannot pause a market that is not listed");
1185         require(msg.sender == pauseGuardian || msg.sender == admin, "only pause guardian and admin can pause");
1186         require(msg.sender == admin || state == true, "only admin can unpause");
1187 
1188         mintGuardianPaused[address(cToken)] = state;
1189         emit ActionPaused(cToken, "Mint", state);
1190         return state;
1191     }
1192 
1193     function _setBorrowPaused(CToken cToken, bool state) public returns (bool) {
1194         require(markets[address(cToken)].isListed, "cannot pause a market that is not listed");
1195         require(msg.sender == pauseGuardian || msg.sender == admin, "only pause guardian and admin can pause");
1196         require(msg.sender == admin || state == true, "only admin can unpause");
1197 
1198         borrowGuardianPaused[address(cToken)] = state;
1199         emit ActionPaused(cToken, "Borrow", state);
1200         return state;
1201     }
1202 
1203     function _setTransferPaused(bool state) public returns (bool) {
1204         require(msg.sender == pauseGuardian || msg.sender == admin, "only pause guardian and admin can pause");
1205         require(msg.sender == admin || state == true, "only admin can unpause");
1206 
1207         transferGuardianPaused = state;
1208         emit ActionPaused("Transfer", state);
1209         return state;
1210     }
1211 
1212     function _setSeizePaused(bool state) public returns (bool) {
1213         require(msg.sender == pauseGuardian || msg.sender == admin, "only pause guardian and admin can pause");
1214         require(msg.sender == admin || state == true, "only admin can unpause");
1215 
1216         seizeGuardianPaused = state;
1217         emit ActionPaused("Seize", state);
1218         return state;
1219     }
1220 
1221     function _become(
1222         Unitroller unitroller,
1223         uint256 compRate_,
1224         address[] memory compMarketsToAdd,
1225         address[] memory otherMarketsToAdd
1226     ) public {
1227         require(msg.sender == unitroller.admin(), "only unitroller admin can change brains");
1228         require(unitroller._acceptImplementation() == 0, "change not authorized");
1229 
1230         ComptrollerG3(address(unitroller))._becomeG3(compRate_, compMarketsToAdd, otherMarketsToAdd);
1231     }
1232 
1233     function _becomeG3(
1234         uint256 compRate_,
1235         address[] memory compMarketsToAdd,
1236         address[] memory otherMarketsToAdd
1237     ) public {
1238         require(msg.sender == comptrollerImplementation, "only brains can become itself");
1239 
1240         for (uint256 i = 0; i < compMarketsToAdd.length; i++) {
1241             _addMarketInternal(address(compMarketsToAdd[i]));
1242         }
1243 
1244         for (uint256 i = 0; i < otherMarketsToAdd.length; i++) {
1245             _addMarketInternal(address(otherMarketsToAdd[i]));
1246         }
1247 
1248         _setCompRate(compRate_);
1249         _addCompMarkets(compMarketsToAdd);
1250     }
1251 
1252     /**
1253      * @notice Checks caller is admin, or this contract is becoming the new implementation
1254      */
1255     function adminOrInitializing() internal view returns (bool) {
1256         return msg.sender == admin || msg.sender == comptrollerImplementation;
1257     }
1258 
1259     /*** Comp Distribution ***/
1260 
1261     /**
1262      * @notice Recalculate and update COMP speeds for all COMP markets
1263      */
1264     function refreshCompSpeeds() public {
1265         CToken[] memory allMarkets_ = allMarkets;
1266 
1267         for (uint256 i = 0; i < allMarkets_.length; i++) {
1268             CToken cToken = allMarkets_[i];
1269             Exp memory borrowIndex = Exp({mantissa: cToken.borrowIndex()});
1270             updateCompSupplyIndex(address(cToken));
1271             updateCompBorrowIndex(address(cToken), borrowIndex);
1272         }
1273 
1274         Exp memory totalUtility = Exp({mantissa: 0});
1275         Exp[] memory utilities = new Exp[](allMarkets_.length);
1276         for (uint256 i = 0; i < allMarkets_.length; i++) {
1277             CToken cToken = allMarkets_[i];
1278             if (markets[address(cToken)].isComped) {
1279                 Exp memory assetPrice = Exp({mantissa: oracle.getUnderlyingPrice(cToken)});
1280                 Exp memory interestPerBlock = mul_(Exp({mantissa: cToken.borrowRatePerBlock()}), cToken.totalBorrows());
1281                 Exp memory utility = mul_(interestPerBlock, assetPrice);
1282                 utilities[i] = utility;
1283                 totalUtility = add_(totalUtility, utility);
1284             }
1285         }
1286 
1287         for (uint256 i = 0; i < allMarkets_.length; i++) {
1288             CToken cToken = allMarkets[i];
1289             uint256 newSpeed = totalUtility.mantissa > 0 ? mul_(compRate, div_(utilities[i], totalUtility)) : 0;
1290             compSpeeds[address(cToken)] = newSpeed;
1291             emit CompSpeedUpdated(cToken, newSpeed);
1292         }
1293     }
1294 
1295     /**
1296      * @notice Accrue COMP to the market by updating the supply index
1297      * @param cToken The market whose supply index to update
1298      */
1299     function updateCompSupplyIndex(address cToken) internal {
1300         CompMarketState storage supplyState = compSupplyState[cToken];
1301         uint256 supplySpeed = compSpeeds[cToken];
1302         uint256 blockNumber = getBlockNumber();
1303         uint256 deltaBlocks = sub_(blockNumber, uint256(supplyState.block));
1304         if (deltaBlocks > 0 && supplySpeed > 0) {
1305             uint256 supplyTokens = CToken(cToken).totalSupply();
1306             uint256 compAccrued = mul_(deltaBlocks, supplySpeed);
1307             Double memory ratio = supplyTokens > 0 ? fraction(compAccrued, supplyTokens) : Double({mantissa: 0});
1308             Double memory index = add_(Double({mantissa: supplyState.index}), ratio);
1309             compSupplyState[cToken] = CompMarketState({
1310                 index: safe224(index.mantissa, "new index exceeds 224 bits"),
1311                 block: safe32(blockNumber, "block number exceeds 32 bits")
1312             });
1313         } else if (deltaBlocks > 0) {
1314             supplyState.block = safe32(blockNumber, "block number exceeds 32 bits");
1315         }
1316     }
1317 
1318     /**
1319      * @notice Accrue COMP to the market by updating the borrow index
1320      * @param cToken The market whose borrow index to update
1321      */
1322     function updateCompBorrowIndex(address cToken, Exp memory marketBorrowIndex) internal {
1323         CompMarketState storage borrowState = compBorrowState[cToken];
1324         uint256 borrowSpeed = compSpeeds[cToken];
1325         uint256 blockNumber = getBlockNumber();
1326         uint256 deltaBlocks = sub_(blockNumber, uint256(borrowState.block));
1327         if (deltaBlocks > 0 && borrowSpeed > 0) {
1328             uint256 borrowAmount = div_(CToken(cToken).totalBorrows(), marketBorrowIndex);
1329             uint256 compAccrued = mul_(deltaBlocks, borrowSpeed);
1330             Double memory ratio = borrowAmount > 0 ? fraction(compAccrued, borrowAmount) : Double({mantissa: 0});
1331             Double memory index = add_(Double({mantissa: borrowState.index}), ratio);
1332             compBorrowState[cToken] = CompMarketState({
1333                 index: safe224(index.mantissa, "new index exceeds 224 bits"),
1334                 block: safe32(blockNumber, "block number exceeds 32 bits")
1335             });
1336         } else if (deltaBlocks > 0) {
1337             borrowState.block = safe32(blockNumber, "block number exceeds 32 bits");
1338         }
1339     }
1340 
1341     /**
1342      * @notice Calculate COMP accrued by a supplier and possibly transfer it to them
1343      * @param cToken The market in which the supplier is interacting
1344      * @param supplier The address of the supplier to distribute COMP to
1345      */
1346     function distributeSupplierComp(
1347         address cToken,
1348         address supplier,
1349         bool distributeAll
1350     ) internal {
1351         CompMarketState storage supplyState = compSupplyState[cToken];
1352         Double memory supplyIndex = Double({mantissa: supplyState.index});
1353         Double memory supplierIndex = Double({mantissa: compSupplierIndex[cToken][supplier]});
1354         compSupplierIndex[cToken][supplier] = supplyIndex.mantissa;
1355 
1356         if (supplierIndex.mantissa == 0 && supplyIndex.mantissa > 0) {
1357             supplierIndex.mantissa = compInitialIndex;
1358         }
1359 
1360         Double memory deltaIndex = sub_(supplyIndex, supplierIndex);
1361         uint256 supplierTokens = CToken(cToken).balanceOf(supplier);
1362         uint256 supplierDelta = mul_(supplierTokens, deltaIndex);
1363         uint256 supplierAccrued = add_(compAccrued[supplier], supplierDelta);
1364         compAccrued[supplier] = transferComp(supplier, supplierAccrued, distributeAll ? 0 : compClaimThreshold);
1365         emit DistributedSupplierComp(CToken(cToken), supplier, supplierDelta, supplyIndex.mantissa);
1366     }
1367 
1368     /**
1369      * @notice Calculate COMP accrued by a borrower and possibly transfer it to them
1370      * @dev Borrowers will not begin to accrue until after the first interaction with the protocol.
1371      * @param cToken The market in which the borrower is interacting
1372      * @param borrower The address of the borrower to distribute COMP to
1373      */
1374     function distributeBorrowerComp(
1375         address cToken,
1376         address borrower,
1377         Exp memory marketBorrowIndex,
1378         bool distributeAll
1379     ) internal {
1380         CompMarketState storage borrowState = compBorrowState[cToken];
1381         Double memory borrowIndex = Double({mantissa: borrowState.index});
1382         Double memory borrowerIndex = Double({mantissa: compBorrowerIndex[cToken][borrower]});
1383         compBorrowerIndex[cToken][borrower] = borrowIndex.mantissa;
1384 
1385         if (borrowerIndex.mantissa > 0) {
1386             Double memory deltaIndex = sub_(borrowIndex, borrowerIndex);
1387             uint256 borrowerAmount = div_(CToken(cToken).borrowBalanceStored(borrower), marketBorrowIndex);
1388             uint256 borrowerDelta = mul_(borrowerAmount, deltaIndex);
1389             uint256 borrowerAccrued = add_(compAccrued[borrower], borrowerDelta);
1390             compAccrued[borrower] = transferComp(borrower, borrowerAccrued, distributeAll ? 0 : compClaimThreshold);
1391             emit DistributedBorrowerComp(CToken(cToken), borrower, borrowerDelta, borrowIndex.mantissa);
1392         }
1393     }
1394 
1395     /**
1396      * @notice Transfer COMP to the user, if they are above the threshold
1397      * @dev Note: If there is not enough COMP, we do not perform the transfer all.
1398      * @param user The address of the user to transfer COMP to
1399      * @param userAccrued The amount of COMP to (possibly) transfer
1400      * @return The amount of COMP which was NOT transferred to the user
1401      */
1402     function transferComp(
1403         address user,
1404         uint256 userAccrued,
1405         uint256 threshold
1406     ) internal returns (uint256) {
1407         if (userAccrued >= threshold && userAccrued > 0) {
1408             Comp comp = Comp(getCompAddress());
1409             uint256 compRemaining = comp.balanceOf(address(this));
1410             if (userAccrued <= compRemaining) {
1411                 comp.transfer(user, userAccrued);
1412                 return 0;
1413             }
1414         }
1415         return userAccrued;
1416     }
1417 
1418     /**
1419      * @notice Claim all the comp accrued by holder in all markets
1420      * @param holder The address to claim COMP for
1421      */
1422     function claimComp(address holder) public {
1423         return claimComp(holder, allMarkets);
1424     }
1425 
1426     /**
1427      * @notice Claim all the comp accrued by holder in the specified markets
1428      * @param holder The address to claim COMP for
1429      * @param cTokens The list of markets to claim COMP in
1430      */
1431     function claimComp(address holder, CToken[] memory cTokens) public {
1432         address[] memory holders = new address[](1);
1433         holders[0] = holder;
1434         claimComp(holders, cTokens, true, true);
1435     }
1436 
1437     /**
1438      * @notice Claim all comp accrued by the holders
1439      * @param holders The addresses to claim COMP for
1440      * @param cTokens The list of markets to claim COMP in
1441      * @param borrowers Whether or not to claim COMP earned by borrowing
1442      * @param suppliers Whether or not to claim COMP earned by supplying
1443      */
1444     function claimComp(
1445         address[] memory holders,
1446         CToken[] memory cTokens,
1447         bool borrowers,
1448         bool suppliers
1449     ) public {
1450         for (uint256 i = 0; i < cTokens.length; i++) {
1451             CToken cToken = cTokens[i];
1452             require(markets[address(cToken)].isListed, "market must be listed");
1453             if (borrowers == true) {
1454                 Exp memory borrowIndex = Exp({mantissa: cToken.borrowIndex()});
1455                 updateCompBorrowIndex(address(cToken), borrowIndex);
1456                 for (uint256 j = 0; j < holders.length; j++) {
1457                     distributeBorrowerComp(address(cToken), holders[j], borrowIndex, true);
1458                 }
1459             }
1460             if (suppliers == true) {
1461                 updateCompSupplyIndex(address(cToken));
1462                 for (uint256 j = 0; j < holders.length; j++) {
1463                     distributeSupplierComp(address(cToken), holders[j], true);
1464                 }
1465             }
1466         }
1467     }
1468 
1469     /*** Comp Distribution Admin ***/
1470 
1471     /**
1472      * @notice Set the amount of COMP distributed per block
1473      * @param compRate_ The amount of COMP wei per block to distribute
1474      */
1475     function _setCompRate(uint256 compRate_) public {
1476         require(adminOrInitializing(), "only admin can change comp rate");
1477 
1478         uint256 oldRate = compRate;
1479         compRate = compRate_;
1480         emit NewCompRate(oldRate, compRate_);
1481 
1482         refreshCompSpeeds();
1483     }
1484 
1485     /**
1486      * @notice Add markets to compMarkets, allowing them to earn COMP in the flywheel
1487      * @param cTokens The addresses of the markets to add
1488      */
1489     function _addCompMarkets(address[] memory cTokens) public {
1490         require(adminOrInitializing(), "only admin can add comp market");
1491 
1492         for (uint256 i = 0; i < cTokens.length; i++) {
1493             _addCompMarketInternal(cTokens[i]);
1494         }
1495 
1496         refreshCompSpeeds();
1497     }
1498 
1499     function _addCompMarketInternal(address cToken) internal {
1500         Market storage market = markets[cToken];
1501         require(market.isListed == true, "comp market is not listed");
1502         require(market.isComped == false, "comp market already added");
1503 
1504         market.isComped = true;
1505         emit MarketComped(CToken(cToken), true);
1506 
1507         if (compSupplyState[cToken].index == 0 && compSupplyState[cToken].block == 0) {
1508             compSupplyState[cToken] = CompMarketState({
1509                 index: compInitialIndex,
1510                 block: safe32(getBlockNumber(), "block number exceeds 32 bits")
1511             });
1512         }
1513 
1514         if (compBorrowState[cToken].index == 0 && compBorrowState[cToken].block == 0) {
1515             compBorrowState[cToken] = CompMarketState({
1516                 index: compInitialIndex,
1517                 block: safe32(getBlockNumber(), "block number exceeds 32 bits")
1518             });
1519         }
1520     }
1521 
1522     /**
1523      * @notice Remove a market from compMarkets, preventing it from earning COMP in the flywheel
1524      * @param cToken The address of the market to drop
1525      */
1526     function _dropCompMarket(address cToken) public {
1527         require(msg.sender == admin, "only admin can drop comp market");
1528 
1529         Market storage market = markets[cToken];
1530         require(market.isComped == true, "market is not a comp market");
1531 
1532         market.isComped = false;
1533         emit MarketComped(CToken(cToken), false);
1534 
1535         refreshCompSpeeds();
1536     }
1537 
1538     /**
1539      * @notice Return all of the markets
1540      * @dev The automatic getter may be used to access an individual market.
1541      * @return The list of market addresses
1542      */
1543     function getAllMarkets() public view returns (CToken[] memory) {
1544         return allMarkets;
1545     }
1546 
1547     function getBlockNumber() public view returns (uint256) {
1548         return block.number;
1549     }
1550 
1551     /**
1552      * @notice Return the address of the COMP token
1553      * @return The address of COMP
1554      */
1555     function getCompAddress() public view returns (address) {
1556         return 0xc00e94Cb662C3520282E6f5717214004A7f26888;
1557     }
1558 }
