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
14  * @author Compound (modified by Arr00)
15  */
16 contract ComptrollerG6 is ComptrollerV5Storage, ComptrollerInterface, ComptrollerErrorReporter, Exponential {
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
35     /// @notice Emitted when price oracle is changed
36     event NewPriceOracle(PriceOracle oldPriceOracle, PriceOracle newPriceOracle);
37 
38     /// @notice Emitted when pause guardian is changed
39     event NewPauseGuardian(address oldPauseGuardian, address newPauseGuardian);
40 
41     /// @notice Emitted when an action is paused globally
42     event ActionPaused(string action, bool pauseState);
43 
44     /// @notice Emitted when an action is paused on a market
45     event ActionPaused(CToken cToken, string action, bool pauseState);
46 
47     /// @notice Emitted when a new COMP speed is calculated for a market
48     event CompSpeedUpdated(CToken indexed cToken, uint256 newSpeed);
49 
50     /// @notice Emitted when COMP is distributed to a supplier
51     event DistributedSupplierComp(
52         CToken indexed cToken,
53         address indexed supplier,
54         uint256 compDelta,
55         uint256 compSupplyIndex
56     );
57 
58     /// @notice Emitted when COMP is distributed to a borrower
59     event DistributedBorrowerComp(
60         CToken indexed cToken,
61         address indexed borrower,
62         uint256 compDelta,
63         uint256 compBorrowIndex
64     );
65 
66     /// @notice Emitted when borrow cap for a cToken is changed
67     event NewBorrowCap(CToken indexed cToken, uint256 newBorrowCap);
68 
69     /// @notice Emitted when borrow cap guardian is changed
70     event NewBorrowCapGuardian(address oldBorrowCapGuardian, address newBorrowCapGuardian);
71 
72     /// @notice Emitted when supply cap for a cToken is changed
73     event NewSupplyCap(CToken indexed cToken, uint256 newSupplyCap);
74 
75     /// @notice Emitted when supply cap guardian is changed
76     event NewSupplyCapGuardian(address oldSupplyCapGuardian, address newSupplyCapGuardian);
77 
78     /// @notice The threshold above which the flywheel transfers COMP, in wei
79     uint256 public constant compClaimThreshold = 0.001e18;
80 
81     /// @notice The initial COMP index for a market
82     uint224 public constant compInitialIndex = 1e36;
83 
84     // No collateralFactorMantissa may exceed this value
85     uint256 internal constant collateralFactorMaxMantissa = 0.9e18; // 0.9
86 
87     constructor() public {
88         admin = msg.sender;
89     }
90 
91     /*** Assets You Are In ***/
92 
93     /**
94      * @notice Returns the assets an account has entered
95      * @param account The address of the account to pull assets for
96      * @return A dynamic list with the assets the account has entered
97      */
98     function getAssetsIn(address account) external view returns (CToken[] memory) {
99         CToken[] memory assetsIn = accountAssets[account];
100 
101         return assetsIn;
102     }
103 
104     /**
105      * @notice Returns whether the given account is entered in the given asset
106      * @param account The address of the account to check
107      * @param cToken The cToken to check
108      * @return True if the account is in the asset, otherwise false.
109      */
110     function checkMembership(address account, CToken cToken) external view returns (bool) {
111         return markets[address(cToken)].accountMembership[account];
112     }
113 
114     /**
115      * @notice Add assets to be included in account liquidity calculation
116      * @param cTokens The list of addresses of the cToken markets to be enabled
117      * @return Success indicator for whether each corresponding market was entered
118      */
119     function enterMarkets(address[] memory cTokens) public returns (uint256[] memory) {
120         uint256 len = cTokens.length;
121 
122         uint256[] memory results = new uint256[](len);
123         for (uint256 i = 0; i < len; i++) {
124             CToken cToken = CToken(cTokens[i]);
125 
126             results[i] = uint256(addToMarketInternal(cToken, msg.sender));
127         }
128 
129         return results;
130     }
131 
132     /**
133      * @notice Add the market to the borrower's "assets in" for liquidity calculations
134      * @param cToken The market to enter
135      * @param borrower The address of the account to modify
136      * @return Success indicator for whether the market was entered
137      */
138     function addToMarketInternal(CToken cToken, address borrower) internal returns (Error) {
139         Market storage marketToJoin = markets[address(cToken)];
140 
141         if (!marketToJoin.isListed) {
142             // market is not listed, cannot join
143             return Error.MARKET_NOT_LISTED;
144         }
145 
146         if (marketToJoin.accountMembership[borrower] == true) {
147             // already joined
148             return Error.NO_ERROR;
149         }
150 
151         // survived the gauntlet, add to list
152         // NOTE: we store these somewhat redundantly as a significant optimization
153         //  this avoids having to iterate through the list for the most common use cases
154         //  that is, only when we need to perform liquidity checks
155         //  and not whenever we want to check if an account is in a particular market
156         marketToJoin.accountMembership[borrower] = true;
157         accountAssets[borrower].push(cToken);
158 
159         emit MarketEntered(cToken, borrower);
160 
161         return Error.NO_ERROR;
162     }
163 
164     /**
165      * @notice Removes asset from sender's account liquidity calculation
166      * @dev Sender must not have an outstanding borrow balance in the asset,
167      *  or be providing necessary collateral for an outstanding borrow.
168      * @param cTokenAddress The address of the asset to be removed
169      * @return Whether or not the account successfully exited the market
170      */
171     function exitMarket(address cTokenAddress) external returns (uint256) {
172         CToken cToken = CToken(cTokenAddress);
173         /* Get sender tokensHeld and amountOwed underlying from the cToken */
174         (uint256 oErr, uint256 tokensHeld, uint256 amountOwed, ) = cToken.getAccountSnapshot(msg.sender);
175         require(oErr == 0, "exitMarket: getAccountSnapshot failed"); // semi-opaque error code
176 
177         /* Fail if the sender has a borrow balance */
178         if (amountOwed != 0) {
179             return fail(Error.NONZERO_BORROW_BALANCE, FailureInfo.EXIT_MARKET_BALANCE_OWED);
180         }
181 
182         /* Fail if the sender is not permitted to redeem all of their tokens */
183         uint256 allowed = redeemAllowedInternal(cTokenAddress, msg.sender, tokensHeld);
184         if (allowed != 0) {
185             return failOpaque(Error.REJECTION, FailureInfo.EXIT_MARKET_REJECTION, allowed);
186         }
187 
188         Market storage marketToExit = markets[address(cToken)];
189 
190         /* Return true if the sender is not already ‘in’ the market */
191         if (!marketToExit.accountMembership[msg.sender]) {
192             return uint256(Error.NO_ERROR);
193         }
194 
195         /* Set cToken account membership to false */
196         delete marketToExit.accountMembership[msg.sender];
197 
198         /* Delete cToken from the account’s list of assets */
199         // load into memory for faster iteration
200         CToken[] memory userAssetList = accountAssets[msg.sender];
201         uint256 len = userAssetList.length;
202         uint256 assetIndex = len;
203         for (uint256 i = 0; i < len; i++) {
204             if (userAssetList[i] == cToken) {
205                 assetIndex = i;
206                 break;
207             }
208         }
209 
210         // We *must* have found the asset in the list or our redundant data structure is broken
211         assert(assetIndex < len);
212 
213         // copy last item in list to location of item to be removed, reduce length by 1
214         CToken[] storage storedList = accountAssets[msg.sender];
215         storedList[assetIndex] = storedList[storedList.length - 1];
216         storedList.length--;
217 
218         emit MarketExited(cToken, msg.sender);
219 
220         return uint256(Error.NO_ERROR);
221     }
222 
223     /*** Policy Hooks ***/
224 
225     /**
226      * @notice Checks if the account should be allowed to mint tokens in the given market
227      * @param cToken The market to verify the mint against
228      * @param minter The account which would get the minted tokens
229      * @param mintAmount The amount of underlying being supplied to the market in exchange for tokens
230      * @return 0 if the mint is allowed, otherwise a semi-opaque error code (See ErrorReporter.sol)
231      */
232     function mintAllowed(
233         address cToken,
234         address minter,
235         uint256 mintAmount
236     ) external returns (uint256) {
237         // Pausing is a very serious situation - we revert to sound the alarms
238         require(!mintGuardianPaused[cToken], "mint is paused");
239 
240         // Shh - currently unused
241         minter;
242 
243         if (!markets[cToken].isListed) {
244             return uint256(Error.MARKET_NOT_LISTED);
245         }
246 
247         uint256 supplyCap = supplyCaps[cToken];
248         // Supply cap of 0 corresponds to unlimited supplying
249         if (supplyCap != 0) {
250             uint256 totalCash = CToken(cToken).getCash();
251             uint256 totalBorrows = CToken(cToken).totalBorrows();
252             uint256 totalReserves = CToken(cToken).totalReserves();
253             // totalSupplies = totalCash + totalBorrows - totalReserves
254             (MathError mathErr, uint256 totalSupplies) = addThenSubUInt(totalCash, totalBorrows, totalReserves);
255             require(mathErr == MathError.NO_ERROR, "totalSupplies failed");
256 
257             uint256 nextTotalSupplies = add_(totalSupplies, mintAmount);
258             require(nextTotalSupplies < supplyCap, "market supply cap reached");
259         }
260 
261         // Keep the flywheel moving
262         updateCompSupplyIndex(cToken);
263         distributeSupplierComp(cToken, minter, false);
264 
265         return uint256(Error.NO_ERROR);
266     }
267 
268     /**
269      * @notice Validates mint and reverts on rejection. May emit logs.
270      * @param cToken Asset being minted
271      * @param minter The address minting the tokens
272      * @param actualMintAmount The amount of the underlying asset being minted
273      * @param mintTokens The number of tokens being minted
274      */
275     function mintVerify(
276         address cToken,
277         address minter,
278         uint256 actualMintAmount,
279         uint256 mintTokens
280     ) external {
281         // Shh - currently unused
282         cToken;
283         minter;
284         actualMintAmount;
285         mintTokens;
286 
287         // Shh - we don't ever want this hook to be marked pure
288         if (false) {
289             maxAssets = maxAssets;
290         }
291     }
292 
293     /**
294      * @notice Checks if the account should be allowed to redeem tokens in the given market
295      * @param cToken The market to verify the redeem against
296      * @param redeemer The account which would redeem the tokens
297      * @param redeemTokens The number of cTokens to exchange for the underlying asset in the market
298      * @return 0 if the redeem is allowed, otherwise a semi-opaque error code (See ErrorReporter.sol)
299      */
300     function redeemAllowed(
301         address cToken,
302         address redeemer,
303         uint256 redeemTokens
304     ) external returns (uint256) {
305         uint256 allowed = redeemAllowedInternal(cToken, redeemer, redeemTokens);
306         if (allowed != uint256(Error.NO_ERROR)) {
307             return allowed;
308         }
309 
310         // Keep the flywheel moving
311         updateCompSupplyIndex(cToken);
312         distributeSupplierComp(cToken, redeemer, false);
313 
314         return uint256(Error.NO_ERROR);
315     }
316 
317     function redeemAllowedInternal(
318         address cToken,
319         address redeemer,
320         uint256 redeemTokens
321     ) internal view returns (uint256) {
322         if (!markets[cToken].isListed) {
323             return uint256(Error.MARKET_NOT_LISTED);
324         }
325 
326         /* If the redeemer is not 'in' the market, then we can bypass the liquidity check */
327         if (!markets[cToken].accountMembership[redeemer]) {
328             return uint256(Error.NO_ERROR);
329         }
330 
331         /* Otherwise, perform a hypothetical liquidity check to guard against shortfall */
332         (Error err, , uint256 shortfall) = getHypotheticalAccountLiquidityInternal(
333             redeemer,
334             CToken(cToken),
335             redeemTokens,
336             0
337         );
338         if (err != Error.NO_ERROR) {
339             return uint256(err);
340         }
341         if (shortfall > 0) {
342             return uint256(Error.INSUFFICIENT_LIQUIDITY);
343         }
344 
345         return uint256(Error.NO_ERROR);
346     }
347 
348     /**
349      * @notice Validates redeem and reverts on rejection. May emit logs.
350      * @param cToken Asset being redeemed
351      * @param redeemer The address redeeming the tokens
352      * @param redeemAmount The amount of the underlying asset being redeemed
353      * @param redeemTokens The number of tokens being redeemed
354      */
355     function redeemVerify(
356         address cToken,
357         address redeemer,
358         uint256 redeemAmount,
359         uint256 redeemTokens
360     ) external {
361         // Shh - currently unused
362         cToken;
363         redeemer;
364 
365         // Require tokens is zero or amount is also zero
366         if (redeemTokens == 0 && redeemAmount > 0) {
367             revert("redeemTokens zero");
368         }
369     }
370 
371     /**
372      * @notice Checks if the account should be allowed to borrow the underlying asset of the given market
373      * @param cToken The market to verify the borrow against
374      * @param borrower The account which would borrow the asset
375      * @param borrowAmount The amount of underlying the account would borrow
376      * @return 0 if the borrow is allowed, otherwise a semi-opaque error code (See ErrorReporter.sol)
377      */
378     function borrowAllowed(
379         address cToken,
380         address borrower,
381         uint256 borrowAmount
382     ) external returns (uint256) {
383         // Pausing is a very serious situation - we revert to sound the alarms
384         require(!borrowGuardianPaused[cToken], "borrow is paused");
385 
386         if (!markets[cToken].isListed) {
387             return uint256(Error.MARKET_NOT_LISTED);
388         }
389 
390         if (!markets[cToken].accountMembership[borrower]) {
391             // only cTokens may call borrowAllowed if borrower not in market
392             require(msg.sender == cToken, "sender must be cToken");
393 
394             // attempt to add borrower to the market
395             Error err = addToMarketInternal(CToken(msg.sender), borrower);
396             if (err != Error.NO_ERROR) {
397                 return uint256(err);
398             }
399 
400             // it should be impossible to break the important invariant
401             assert(markets[cToken].accountMembership[borrower]);
402         }
403 
404         if (oracle.getUnderlyingPrice(CToken(cToken)) == 0) {
405             return uint256(Error.PRICE_ERROR);
406         }
407 
408         uint256 borrowCap = borrowCaps[cToken];
409         // Borrow cap of 0 corresponds to unlimited borrowing
410         if (borrowCap != 0) {
411             uint256 totalBorrows = CToken(cToken).totalBorrows();
412             uint256 nextTotalBorrows = add_(totalBorrows, borrowAmount);
413             require(nextTotalBorrows < borrowCap, "market borrow cap reached");
414         }
415 
416         (Error err, , uint256 shortfall) = getHypotheticalAccountLiquidityInternal(
417             borrower,
418             CToken(cToken),
419             0,
420             borrowAmount
421         );
422         if (err != Error.NO_ERROR) {
423             return uint256(err);
424         }
425         if (shortfall > 0) {
426             return uint256(Error.INSUFFICIENT_LIQUIDITY);
427         }
428 
429         // Keep the flywheel moving
430         Exp memory borrowIndex = Exp({mantissa: CToken(cToken).borrowIndex()});
431         updateCompBorrowIndex(cToken, borrowIndex);
432         distributeBorrowerComp(cToken, borrower, borrowIndex, false);
433 
434         return uint256(Error.NO_ERROR);
435     }
436 
437     /**
438      * @notice Validates borrow and reverts on rejection. May emit logs.
439      * @param cToken Asset whose underlying is being borrowed
440      * @param borrower The address borrowing the underlying
441      * @param borrowAmount The amount of the underlying asset requested to borrow
442      */
443     function borrowVerify(
444         address cToken,
445         address borrower,
446         uint256 borrowAmount
447     ) external {
448         // Shh - currently unused
449         cToken;
450         borrower;
451         borrowAmount;
452 
453         // Shh - we don't ever want this hook to be marked pure
454         if (false) {
455             maxAssets = maxAssets;
456         }
457     }
458 
459     /**
460      * @notice Checks if the account should be allowed to repay a borrow in the given market
461      * @param cToken The market to verify the repay against
462      * @param payer The account which would repay the asset
463      * @param borrower The account which would borrowed the asset
464      * @param repayAmount The amount of the underlying asset the account would repay
465      * @return 0 if the repay is allowed, otherwise a semi-opaque error code (See ErrorReporter.sol)
466      */
467     function repayBorrowAllowed(
468         address cToken,
469         address payer,
470         address borrower,
471         uint256 repayAmount
472     ) external returns (uint256) {
473         // Shh - currently unused
474         payer;
475         borrower;
476         repayAmount;
477 
478         if (!markets[cToken].isListed) {
479             return uint256(Error.MARKET_NOT_LISTED);
480         }
481 
482         // Keep the flywheel moving
483         Exp memory borrowIndex = Exp({mantissa: CToken(cToken).borrowIndex()});
484         updateCompBorrowIndex(cToken, borrowIndex);
485         distributeBorrowerComp(cToken, borrower, borrowIndex, false);
486 
487         return uint256(Error.NO_ERROR);
488     }
489 
490     /**
491      * @notice Validates repayBorrow and reverts on rejection. May emit logs.
492      * @param cToken Asset being repaid
493      * @param payer The address repaying the borrow
494      * @param borrower The address of the borrower
495      * @param actualRepayAmount The amount of underlying being repaid
496      */
497     function repayBorrowVerify(
498         address cToken,
499         address payer,
500         address borrower,
501         uint256 actualRepayAmount,
502         uint256 borrowerIndex
503     ) external {
504         // Shh - currently unused
505         cToken;
506         payer;
507         borrower;
508         actualRepayAmount;
509         borrowerIndex;
510 
511         // Shh - we don't ever want this hook to be marked pure
512         if (false) {
513             maxAssets = maxAssets;
514         }
515     }
516 
517     /**
518      * @notice Checks if the liquidation should be allowed to occur
519      * @param cTokenBorrowed Asset which was borrowed by the borrower
520      * @param cTokenCollateral Asset which was used as collateral and will be seized
521      * @param liquidator The address repaying the borrow and seizing the collateral
522      * @param borrower The address of the borrower
523      * @param repayAmount The amount of underlying being repaid
524      */
525     function liquidateBorrowAllowed(
526         address cTokenBorrowed,
527         address cTokenCollateral,
528         address liquidator,
529         address borrower,
530         uint256 repayAmount
531     ) external returns (uint256) {
532         // Shh - currently unused
533         liquidator;
534 
535         if (!markets[cTokenBorrowed].isListed || !markets[cTokenCollateral].isListed) {
536             return uint256(Error.MARKET_NOT_LISTED);
537         }
538 
539         /* The borrower must have shortfall in order to be liquidatable */
540         (Error err, , uint256 shortfall) = getAccountLiquidityInternal(borrower);
541         if (err != Error.NO_ERROR) {
542             return uint256(err);
543         }
544         if (shortfall == 0) {
545             return uint256(Error.INSUFFICIENT_SHORTFALL);
546         }
547 
548         /* The liquidator may not repay more than what is allowed by the closeFactor */
549         uint256 borrowBalance = CToken(cTokenBorrowed).borrowBalanceStored(borrower);
550         uint256 maxClose = mul_ScalarTruncate(Exp({mantissa: closeFactorMantissa}), borrowBalance);
551         if (repayAmount > maxClose) {
552             return uint256(Error.TOO_MUCH_REPAY);
553         }
554 
555         return uint256(Error.NO_ERROR);
556     }
557 
558     /**
559      * @notice Validates liquidateBorrow and reverts on rejection. May emit logs.
560      * @param cTokenBorrowed Asset which was borrowed by the borrower
561      * @param cTokenCollateral Asset which was used as collateral and will be seized
562      * @param liquidator The address repaying the borrow and seizing the collateral
563      * @param borrower The address of the borrower
564      * @param actualRepayAmount The amount of underlying being repaid
565      */
566     function liquidateBorrowVerify(
567         address cTokenBorrowed,
568         address cTokenCollateral,
569         address liquidator,
570         address borrower,
571         uint256 actualRepayAmount,
572         uint256 seizeTokens
573     ) external {
574         // Shh - currently unused
575         cTokenBorrowed;
576         cTokenCollateral;
577         liquidator;
578         borrower;
579         actualRepayAmount;
580         seizeTokens;
581 
582         // Shh - we don't ever want this hook to be marked pure
583         if (false) {
584             maxAssets = maxAssets;
585         }
586     }
587 
588     /**
589      * @notice Checks if the seizing of assets should be allowed to occur
590      * @param cTokenCollateral Asset which was used as collateral and will be seized
591      * @param cTokenBorrowed Asset which was borrowed by the borrower
592      * @param liquidator The address repaying the borrow and seizing the collateral
593      * @param borrower The address of the borrower
594      * @param seizeTokens The number of collateral tokens to seize
595      */
596     function seizeAllowed(
597         address cTokenCollateral,
598         address cTokenBorrowed,
599         address liquidator,
600         address borrower,
601         uint256 seizeTokens
602     ) external returns (uint256) {
603         // Pausing is a very serious situation - we revert to sound the alarms
604         require(!seizeGuardianPaused, "seize is paused");
605 
606         // Shh - currently unused
607         seizeTokens;
608 
609         if (!markets[cTokenCollateral].isListed || !markets[cTokenBorrowed].isListed) {
610             return uint256(Error.MARKET_NOT_LISTED);
611         }
612 
613         if (CToken(cTokenCollateral).comptroller() != CToken(cTokenBorrowed).comptroller()) {
614             return uint256(Error.COMPTROLLER_MISMATCH);
615         }
616 
617         // Keep the flywheel moving
618         updateCompSupplyIndex(cTokenCollateral);
619         distributeSupplierComp(cTokenCollateral, borrower, false);
620         distributeSupplierComp(cTokenCollateral, liquidator, false);
621 
622         return uint256(Error.NO_ERROR);
623     }
624 
625     /**
626      * @notice Validates seize and reverts on rejection. May emit logs.
627      * @param cTokenCollateral Asset which was used as collateral and will be seized
628      * @param cTokenBorrowed Asset which was borrowed by the borrower
629      * @param liquidator The address repaying the borrow and seizing the collateral
630      * @param borrower The address of the borrower
631      * @param seizeTokens The number of collateral tokens to seize
632      */
633     function seizeVerify(
634         address cTokenCollateral,
635         address cTokenBorrowed,
636         address liquidator,
637         address borrower,
638         uint256 seizeTokens
639     ) external {
640         // Shh - currently unused
641         cTokenCollateral;
642         cTokenBorrowed;
643         liquidator;
644         borrower;
645         seizeTokens;
646 
647         // Shh - we don't ever want this hook to be marked pure
648         if (false) {
649             maxAssets = maxAssets;
650         }
651     }
652 
653     /**
654      * @notice Checks if the account should be allowed to transfer tokens in the given market
655      * @param cToken The market to verify the transfer against
656      * @param src The account which sources the tokens
657      * @param dst The account which receives the tokens
658      * @param transferTokens The number of cTokens to transfer
659      * @return 0 if the transfer is allowed, otherwise a semi-opaque error code (See ErrorReporter.sol)
660      */
661     function transferAllowed(
662         address cToken,
663         address src,
664         address dst,
665         uint256 transferTokens
666     ) external returns (uint256) {
667         // Pausing is a very serious situation - we revert to sound the alarms
668         require(!transferGuardianPaused, "transfer is paused");
669 
670         // Currently the only consideration is whether or not
671         //  the src is allowed to redeem this many tokens
672         uint256 allowed = redeemAllowedInternal(cToken, src, transferTokens);
673         if (allowed != uint256(Error.NO_ERROR)) {
674             return allowed;
675         }
676 
677         // Keep the flywheel moving
678         updateCompSupplyIndex(cToken);
679         distributeSupplierComp(cToken, src, false);
680         distributeSupplierComp(cToken, dst, false);
681 
682         return uint256(Error.NO_ERROR);
683     }
684 
685     /**
686      * @notice Validates transfer and reverts on rejection. May emit logs.
687      * @param cToken Asset being transferred
688      * @param src The account which sources the tokens
689      * @param dst The account which receives the tokens
690      * @param transferTokens The number of cTokens to transfer
691      */
692     function transferVerify(
693         address cToken,
694         address src,
695         address dst,
696         uint256 transferTokens
697     ) external {
698         // Shh - currently unused
699         cToken;
700         src;
701         dst;
702         transferTokens;
703 
704         // Shh - we don't ever want this hook to be marked pure
705         if (false) {
706             maxAssets = maxAssets;
707         }
708     }
709 
710     /*** Liquidity/Liquidation Calculations ***/
711 
712     /**
713      * @dev Local vars for avoiding stack-depth limits in calculating account liquidity.
714      *  Note that `cTokenBalance` is the number of cTokens the account owns in the market,
715      *  whereas `borrowBalance` is the amount of underlying that the account has borrowed.
716      */
717     struct AccountLiquidityLocalVars {
718         uint256 sumCollateral;
719         uint256 sumBorrowPlusEffects;
720         uint256 cTokenBalance;
721         uint256 borrowBalance;
722         uint256 exchangeRateMantissa;
723         uint256 oraclePriceMantissa;
724         Exp collateralFactor;
725         Exp exchangeRate;
726         Exp oraclePrice;
727         Exp tokensToDenom;
728     }
729 
730     /**
731      * @notice Determine the current account liquidity wrt collateral requirements
732      * @return (possible error code (semi-opaque),
733                 account liquidity in excess of collateral requirements,
734      *          account shortfall below collateral requirements)
735      */
736     function getAccountLiquidity(address account)
737         public
738         view
739         returns (
740             uint256,
741             uint256,
742             uint256
743         )
744     {
745         (Error err, uint256 liquidity, uint256 shortfall) = getHypotheticalAccountLiquidityInternal(
746             account,
747             CToken(0),
748             0,
749             0
750         );
751 
752         return (uint256(err), liquidity, shortfall);
753     }
754 
755     /**
756      * @notice Determine the current account liquidity wrt collateral requirements
757      * @return (possible error code,
758                 account liquidity in excess of collateral requirements,
759      *          account shortfall below collateral requirements)
760      */
761     function getAccountLiquidityInternal(address account)
762         internal
763         view
764         returns (
765             Error,
766             uint256,
767             uint256
768         )
769     {
770         return getHypotheticalAccountLiquidityInternal(account, CToken(0), 0, 0);
771     }
772 
773     /**
774      * @notice Determine what the account liquidity would be if the given amounts were redeemed/borrowed
775      * @param cTokenModify The market to hypothetically redeem/borrow in
776      * @param account The account to determine liquidity for
777      * @param redeemTokens The number of tokens to hypothetically redeem
778      * @param borrowAmount The amount of underlying to hypothetically borrow
779      * @return (possible error code (semi-opaque),
780                 hypothetical account liquidity in excess of collateral requirements,
781      *          hypothetical account shortfall below collateral requirements)
782      */
783     function getHypotheticalAccountLiquidity(
784         address account,
785         address cTokenModify,
786         uint256 redeemTokens,
787         uint256 borrowAmount
788     )
789         public
790         view
791         returns (
792             uint256,
793             uint256,
794             uint256
795         )
796     {
797         (Error err, uint256 liquidity, uint256 shortfall) = getHypotheticalAccountLiquidityInternal(
798             account,
799             CToken(cTokenModify),
800             redeemTokens,
801             borrowAmount
802         );
803         return (uint256(err), liquidity, shortfall);
804     }
805 
806     /**
807      * @notice Determine what the account liquidity would be if the given amounts were redeemed/borrowed
808      * @param cTokenModify The market to hypothetically redeem/borrow in
809      * @param account The account to determine liquidity for
810      * @param redeemTokens The number of tokens to hypothetically redeem
811      * @param borrowAmount The amount of underlying to hypothetically borrow
812      * @dev Note that we calculate the exchangeRateStored for each collateral cToken using stored data,
813      *  without calculating accumulated interest.
814      * @return (possible error code,
815                 hypothetical account liquidity in excess of collateral requirements,
816      *          hypothetical account shortfall below collateral requirements)
817      */
818     function getHypotheticalAccountLiquidityInternal(
819         address account,
820         CToken cTokenModify,
821         uint256 redeemTokens,
822         uint256 borrowAmount
823     )
824         internal
825         view
826         returns (
827             Error,
828             uint256,
829             uint256
830         )
831     {
832         AccountLiquidityLocalVars memory vars; // Holds all our calculation results
833         uint256 oErr;
834 
835         // For each asset the account is in
836         CToken[] memory assets = accountAssets[account];
837         for (uint256 i = 0; i < assets.length; i++) {
838             CToken asset = assets[i];
839 
840             // Read the balances and exchange rate from the cToken
841             (oErr, vars.cTokenBalance, vars.borrowBalance, vars.exchangeRateMantissa) = asset.getAccountSnapshot(
842                 account
843             );
844             if (oErr != 0) {
845                 // semi-opaque error code, we assume NO_ERROR == 0 is invariant between upgrades
846                 return (Error.SNAPSHOT_ERROR, 0, 0);
847             }
848             vars.collateralFactor = Exp({mantissa: markets[address(asset)].collateralFactorMantissa});
849             vars.exchangeRate = Exp({mantissa: vars.exchangeRateMantissa});
850 
851             // Get the normalized price of the asset
852             vars.oraclePriceMantissa = oracle.getUnderlyingPrice(asset);
853             if (vars.oraclePriceMantissa == 0) {
854                 return (Error.PRICE_ERROR, 0, 0);
855             }
856             vars.oraclePrice = Exp({mantissa: vars.oraclePriceMantissa});
857 
858             // Pre-compute a conversion factor from tokens -> ether (normalized price value)
859             vars.tokensToDenom = mul_(mul_(vars.collateralFactor, vars.exchangeRate), vars.oraclePrice);
860 
861             // sumCollateral += tokensToDenom * cTokenBalance
862             vars.sumCollateral = mul_ScalarTruncateAddUInt(vars.tokensToDenom, vars.cTokenBalance, vars.sumCollateral);
863 
864             // sumBorrowPlusEffects += oraclePrice * borrowBalance
865             vars.sumBorrowPlusEffects = mul_ScalarTruncateAddUInt(
866                 vars.oraclePrice,
867                 vars.borrowBalance,
868                 vars.sumBorrowPlusEffects
869             );
870 
871             // Calculate effects of interacting with cTokenModify
872             if (asset == cTokenModify) {
873                 // redeem effect
874                 // sumBorrowPlusEffects += tokensToDenom * redeemTokens
875                 vars.sumBorrowPlusEffects = mul_ScalarTruncateAddUInt(
876                     vars.tokensToDenom,
877                     redeemTokens,
878                     vars.sumBorrowPlusEffects
879                 );
880 
881                 // borrow effect
882                 // sumBorrowPlusEffects += oraclePrice * borrowAmount
883                 vars.sumBorrowPlusEffects = mul_ScalarTruncateAddUInt(
884                     vars.oraclePrice,
885                     borrowAmount,
886                     vars.sumBorrowPlusEffects
887                 );
888             }
889         }
890 
891         // These are safe, as the underflow condition is checked first
892         if (vars.sumCollateral > vars.sumBorrowPlusEffects) {
893             return (Error.NO_ERROR, vars.sumCollateral - vars.sumBorrowPlusEffects, 0);
894         } else {
895             return (Error.NO_ERROR, 0, vars.sumBorrowPlusEffects - vars.sumCollateral);
896         }
897     }
898 
899     /**
900      * @notice Calculate number of tokens of collateral asset to seize given an underlying amount
901      * @dev Used in liquidation (called in cToken.liquidateBorrowFresh)
902      * @param cTokenBorrowed The address of the borrowed cToken
903      * @param cTokenCollateral The address of the collateral cToken
904      * @param actualRepayAmount The amount of cTokenBorrowed underlying to convert into cTokenCollateral tokens
905      * @return (errorCode, number of cTokenCollateral tokens to be seized in a liquidation)
906      */
907     function liquidateCalculateSeizeTokens(
908         address cTokenBorrowed,
909         address cTokenCollateral,
910         uint256 actualRepayAmount
911     ) external view returns (uint256, uint256) {
912         /* Read oracle prices for borrowed and collateral markets */
913         uint256 priceBorrowedMantissa = oracle.getUnderlyingPrice(CToken(cTokenBorrowed));
914         uint256 priceCollateralMantissa = oracle.getUnderlyingPrice(CToken(cTokenCollateral));
915         if (priceBorrowedMantissa == 0 || priceCollateralMantissa == 0) {
916             return (uint256(Error.PRICE_ERROR), 0);
917         }
918 
919         /*
920          * Get the exchange rate and calculate the number of collateral tokens to seize:
921          *  seizeAmount = actualRepayAmount * liquidationIncentive * priceBorrowed / priceCollateral
922          *  seizeTokens = seizeAmount / exchangeRate
923          *   = actualRepayAmount * (liquidationIncentive * priceBorrowed) / (priceCollateral * exchangeRate)
924          */
925         uint256 exchangeRateMantissa = CToken(cTokenCollateral).exchangeRateStored(); // Note: reverts on error
926         Exp memory numerator = mul_(
927             Exp({mantissa: liquidationIncentiveMantissa}),
928             Exp({mantissa: priceBorrowedMantissa})
929         );
930         Exp memory denominator = mul_(Exp({mantissa: priceCollateralMantissa}), Exp({mantissa: exchangeRateMantissa}));
931         Exp memory ratio = div_(numerator, denominator);
932         uint256 seizeTokens = mul_ScalarTruncate(ratio, actualRepayAmount);
933 
934         return (uint256(Error.NO_ERROR), seizeTokens);
935     }
936 
937     /*** Admin Functions ***/
938 
939     /**
940      * @notice Sets a new price oracle for the comptroller
941      * @dev Admin function to set a new price oracle
942      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
943      */
944     function _setPriceOracle(PriceOracle newOracle) public returns (uint256) {
945         // Check caller is admin
946         if (msg.sender != admin) {
947             return fail(Error.UNAUTHORIZED, FailureInfo.SET_PRICE_ORACLE_OWNER_CHECK);
948         }
949 
950         // Track the old oracle for the comptroller
951         PriceOracle oldOracle = oracle;
952 
953         // Set comptroller's oracle to newOracle
954         oracle = newOracle;
955 
956         // Emit NewPriceOracle(oldOracle, newOracle)
957         emit NewPriceOracle(oldOracle, newOracle);
958 
959         return uint256(Error.NO_ERROR);
960     }
961 
962     /**
963      * @notice Sets the closeFactor used when liquidating borrows
964      * @dev Admin function to set closeFactor
965      * @param newCloseFactorMantissa New close factor, scaled by 1e18
966      * @return uint 0=success, otherwise a failure. (See ErrorReporter for details)
967      */
968     function _setCloseFactor(uint256 newCloseFactorMantissa) external returns (uint256) {
969         // Check caller is admin
970         if (msg.sender != admin) {
971             return fail(Error.UNAUTHORIZED, FailureInfo.SET_CLOSE_FACTOR_OWNER_CHECK);
972         }
973 
974         uint256 oldCloseFactorMantissa = closeFactorMantissa;
975         closeFactorMantissa = newCloseFactorMantissa;
976         emit NewCloseFactor(oldCloseFactorMantissa, closeFactorMantissa);
977 
978         return uint256(Error.NO_ERROR);
979     }
980 
981     /**
982      * @notice Sets the collateralFactor for a market
983      * @dev Admin function to set per-market collateralFactor
984      * @param cToken The market to set the factor on
985      * @param newCollateralFactorMantissa The new collateral factor, scaled by 1e18
986      * @return uint 0=success, otherwise a failure. (See ErrorReporter for details)
987      */
988     function _setCollateralFactor(CToken cToken, uint256 newCollateralFactorMantissa) external returns (uint256) {
989         // Check caller is admin
990         if (msg.sender != admin) {
991             return fail(Error.UNAUTHORIZED, FailureInfo.SET_COLLATERAL_FACTOR_OWNER_CHECK);
992         }
993 
994         // Verify market is listed
995         Market storage market = markets[address(cToken)];
996         if (!market.isListed) {
997             return fail(Error.MARKET_NOT_LISTED, FailureInfo.SET_COLLATERAL_FACTOR_NO_EXISTS);
998         }
999 
1000         Exp memory newCollateralFactorExp = Exp({mantissa: newCollateralFactorMantissa});
1001 
1002         // Check collateral factor <= 0.9
1003         Exp memory highLimit = Exp({mantissa: collateralFactorMaxMantissa});
1004         if (lessThanExp(highLimit, newCollateralFactorExp)) {
1005             return fail(Error.INVALID_COLLATERAL_FACTOR, FailureInfo.SET_COLLATERAL_FACTOR_VALIDATION);
1006         }
1007 
1008         // If collateral factor != 0, fail if price == 0
1009         if (newCollateralFactorMantissa != 0 && oracle.getUnderlyingPrice(cToken) == 0) {
1010             return fail(Error.PRICE_ERROR, FailureInfo.SET_COLLATERAL_FACTOR_WITHOUT_PRICE);
1011         }
1012 
1013         // Set market's collateral factor to new collateral factor, remember old value
1014         uint256 oldCollateralFactorMantissa = market.collateralFactorMantissa;
1015         market.collateralFactorMantissa = newCollateralFactorMantissa;
1016 
1017         // Emit event with asset, old collateral factor, and new collateral factor
1018         emit NewCollateralFactor(cToken, oldCollateralFactorMantissa, newCollateralFactorMantissa);
1019 
1020         return uint256(Error.NO_ERROR);
1021     }
1022 
1023     /**
1024      * @notice Sets liquidationIncentive
1025      * @dev Admin function to set liquidationIncentive
1026      * @param newLiquidationIncentiveMantissa New liquidationIncentive scaled by 1e18
1027      * @return uint 0=success, otherwise a failure. (See ErrorReporter for details)
1028      */
1029     function _setLiquidationIncentive(uint256 newLiquidationIncentiveMantissa) external returns (uint256) {
1030         // Check caller is admin
1031         if (msg.sender != admin) {
1032             return fail(Error.UNAUTHORIZED, FailureInfo.SET_LIQUIDATION_INCENTIVE_OWNER_CHECK);
1033         }
1034 
1035         // Save current value for use in log
1036         uint256 oldLiquidationIncentiveMantissa = liquidationIncentiveMantissa;
1037 
1038         // Set liquidation incentive to new incentive
1039         liquidationIncentiveMantissa = newLiquidationIncentiveMantissa;
1040 
1041         // Emit event with old incentive, new incentive
1042         emit NewLiquidationIncentive(oldLiquidationIncentiveMantissa, newLiquidationIncentiveMantissa);
1043 
1044         return uint256(Error.NO_ERROR);
1045     }
1046 
1047     /**
1048      * @notice Add the market to the markets mapping and set it as listed
1049      * @dev Admin function to set isListed and add support for the market
1050      * @param cToken The address of the market (token) to list
1051      * @return uint 0=success, otherwise a failure. (See enum Error for details)
1052      */
1053     function _supportMarket(CToken cToken) external returns (uint256) {
1054         if (msg.sender != admin) {
1055             return fail(Error.UNAUTHORIZED, FailureInfo.SUPPORT_MARKET_OWNER_CHECK);
1056         }
1057 
1058         if (markets[address(cToken)].isListed) {
1059             return fail(Error.MARKET_ALREADY_LISTED, FailureInfo.SUPPORT_MARKET_EXISTS);
1060         }
1061 
1062         cToken.isCToken(); // Sanity check to make sure its really a CToken
1063 
1064         // TODO: isComped is unused. Remove it in v2.
1065         markets[address(cToken)] = Market({
1066             isListed: true,
1067             isComped: true,
1068             collateralFactorMantissa: 0,
1069             version: Version.VANILLA
1070         });
1071 
1072         _addMarketInternal(address(cToken));
1073 
1074         emit MarketListed(cToken);
1075 
1076         return uint256(Error.NO_ERROR);
1077     }
1078 
1079     function _addMarketInternal(address cToken) internal {
1080         for (uint256 i = 0; i < allMarkets.length; i++) {
1081             require(allMarkets[i] != CToken(cToken), "market already added");
1082         }
1083         allMarkets.push(CToken(cToken));
1084     }
1085 
1086     /**
1087      * @notice Admin function to change the Supply Cap Guardian
1088      * @param newSupplyCapGuardian The address of the new Supply Cap Guardian
1089      */
1090     function _setSupplyCapGuardian(address newSupplyCapGuardian) external {
1091         require(msg.sender == admin, "only admin can set supply cap guardian");
1092 
1093         // Save current value for inclusion in log
1094         address oldSupplyCapGuardian = supplyCapGuardian;
1095 
1096         // Store supplyCapGuardian with value newSupplyCapGuardian
1097         supplyCapGuardian = newSupplyCapGuardian;
1098 
1099         // Emit NewSupplyCapGuardian(OldSupplyCapGuardian, NewSupplyCapGuardian)
1100         emit NewSupplyCapGuardian(oldSupplyCapGuardian, newSupplyCapGuardian);
1101     }
1102 
1103     /**
1104      * @notice Set the given supply caps for the given cToken markets. Supplying that brings total supplys to or above supply cap will revert.
1105      * @dev Admin or supplyCapGuardian function to set the supply caps. A supply cap of 0 corresponds to unlimited supplying.
1106      * @param cTokens The addresses of the markets (tokens) to change the supply caps for
1107      * @param newSupplyCaps The new supply cap values in underlying to be set. A value of 0 corresponds to unlimited supplying.
1108      */
1109     function _setMarketSupplyCaps(CToken[] calldata cTokens, uint256[] calldata newSupplyCaps) external {
1110         require(
1111             msg.sender == admin || msg.sender == supplyCapGuardian,
1112             "only admin or supply cap guardian can set supply caps"
1113         );
1114 
1115         uint256 numMarkets = cTokens.length;
1116         uint256 numSupplyCaps = newSupplyCaps.length;
1117 
1118         require(numMarkets != 0 && numMarkets == numSupplyCaps, "invalid input");
1119 
1120         for (uint256 i = 0; i < numMarkets; i++) {
1121             supplyCaps[address(cTokens[i])] = newSupplyCaps[i];
1122             emit NewSupplyCap(cTokens[i], newSupplyCaps[i]);
1123         }
1124     }
1125 
1126     /**
1127      * @notice Set the given borrow caps for the given cToken markets. Borrowing that brings total borrows to or above borrow cap will revert.
1128      * @dev Admin or borrowCapGuardian function to set the borrow caps. A borrow cap of 0 corresponds to unlimited borrowing.
1129      * @param cTokens The addresses of the markets (tokens) to change the borrow caps for
1130      * @param newBorrowCaps The new borrow cap values in underlying to be set. A value of 0 corresponds to unlimited borrowing.
1131      */
1132     function _setMarketBorrowCaps(CToken[] calldata cTokens, uint256[] calldata newBorrowCaps) external {
1133         require(
1134             msg.sender == admin || msg.sender == borrowCapGuardian,
1135             "only admin or borrow cap guardian can set borrow caps"
1136         );
1137 
1138         uint256 numMarkets = cTokens.length;
1139         uint256 numBorrowCaps = newBorrowCaps.length;
1140 
1141         require(numMarkets != 0 && numMarkets == numBorrowCaps, "invalid input");
1142 
1143         for (uint256 i = 0; i < numMarkets; i++) {
1144             borrowCaps[address(cTokens[i])] = newBorrowCaps[i];
1145             emit NewBorrowCap(cTokens[i], newBorrowCaps[i]);
1146         }
1147     }
1148 
1149     /**
1150      * @notice Admin function to change the Borrow Cap Guardian
1151      * @param newBorrowCapGuardian The address of the new Borrow Cap Guardian
1152      */
1153     function _setBorrowCapGuardian(address newBorrowCapGuardian) external {
1154         require(msg.sender == admin, "only admin can set borrow cap guardian");
1155 
1156         // Save current value for inclusion in log
1157         address oldBorrowCapGuardian = borrowCapGuardian;
1158 
1159         // Store borrowCapGuardian with value newBorrowCapGuardian
1160         borrowCapGuardian = newBorrowCapGuardian;
1161 
1162         // Emit NewBorrowCapGuardian(OldBorrowCapGuardian, NewBorrowCapGuardian)
1163         emit NewBorrowCapGuardian(oldBorrowCapGuardian, newBorrowCapGuardian);
1164     }
1165 
1166     /**
1167      * @notice Admin function to change the Pause Guardian
1168      * @param newPauseGuardian The address of the new Pause Guardian
1169      * @return uint 0=success, otherwise a failure. (See enum Error for details)
1170      */
1171     function _setPauseGuardian(address newPauseGuardian) public returns (uint256) {
1172         if (msg.sender != admin) {
1173             return fail(Error.UNAUTHORIZED, FailureInfo.SET_PAUSE_GUARDIAN_OWNER_CHECK);
1174         }
1175 
1176         // Save current value for inclusion in log
1177         address oldPauseGuardian = pauseGuardian;
1178 
1179         // Store pauseGuardian with value newPauseGuardian
1180         pauseGuardian = newPauseGuardian;
1181 
1182         // Emit NewPauseGuardian(OldPauseGuardian, NewPauseGuardian)
1183         emit NewPauseGuardian(oldPauseGuardian, pauseGuardian);
1184 
1185         return uint256(Error.NO_ERROR);
1186     }
1187 
1188     function _setMintPaused(CToken cToken, bool state) public returns (bool) {
1189         require(markets[address(cToken)].isListed, "cannot pause a market that is not listed");
1190         require(msg.sender == pauseGuardian || msg.sender == admin, "only pause guardian and admin can pause");
1191         require(msg.sender == admin || state == true, "only admin can unpause");
1192 
1193         mintGuardianPaused[address(cToken)] = state;
1194         emit ActionPaused(cToken, "Mint", state);
1195         return state;
1196     }
1197 
1198     function _setBorrowPaused(CToken cToken, bool state) public returns (bool) {
1199         require(markets[address(cToken)].isListed, "cannot pause a market that is not listed");
1200         require(msg.sender == pauseGuardian || msg.sender == admin, "only pause guardian and admin can pause");
1201         require(msg.sender == admin || state == true, "only admin can unpause");
1202 
1203         borrowGuardianPaused[address(cToken)] = state;
1204         emit ActionPaused(cToken, "Borrow", state);
1205         return state;
1206     }
1207 
1208     function _setTransferPaused(bool state) public returns (bool) {
1209         require(msg.sender == pauseGuardian || msg.sender == admin, "only pause guardian and admin can pause");
1210         require(msg.sender == admin || state == true, "only admin can unpause");
1211 
1212         transferGuardianPaused = state;
1213         emit ActionPaused("Transfer", state);
1214         return state;
1215     }
1216 
1217     function _setSeizePaused(bool state) public returns (bool) {
1218         require(msg.sender == pauseGuardian || msg.sender == admin, "only pause guardian and admin can pause");
1219         require(msg.sender == admin || state == true, "only admin can unpause");
1220 
1221         seizeGuardianPaused = state;
1222         emit ActionPaused("Seize", state);
1223         return state;
1224     }
1225 
1226     function _become(Unitroller unitroller) public {
1227         require(msg.sender == unitroller.admin(), "only unitroller admin can change brains");
1228         require(unitroller._acceptImplementation() == 0, "change not authorized");
1229     }
1230 
1231     /**
1232      * @notice Checks caller is admin, or this contract is becoming the new implementation
1233      */
1234     function adminOrInitializing() internal view returns (bool) {
1235         return msg.sender == admin || msg.sender == comptrollerImplementation;
1236     }
1237 
1238     /*** Comp Distribution ***/
1239 
1240     /**
1241      * @notice Accrue COMP to the market by updating the supply index
1242      * @param cToken The market whose supply index to update
1243      */
1244     function updateCompSupplyIndex(address cToken) internal {
1245         CompMarketState storage supplyState = compSupplyState[cToken];
1246         uint256 supplySpeed = compSpeeds[cToken];
1247         uint256 blockNumber = getBlockNumber();
1248         uint256 deltaBlocks = sub_(blockNumber, uint256(supplyState.block));
1249         if (deltaBlocks > 0 && supplySpeed > 0) {
1250             uint256 supplyTokens = CToken(cToken).totalSupply();
1251             uint256 compAccrued = mul_(deltaBlocks, supplySpeed);
1252             Double memory ratio = supplyTokens > 0 ? fraction(compAccrued, supplyTokens) : Double({mantissa: 0});
1253             Double memory index = add_(Double({mantissa: supplyState.index}), ratio);
1254             compSupplyState[cToken] = CompMarketState({
1255                 index: safe224(index.mantissa, "new index exceeds 224 bits"),
1256                 block: safe32(blockNumber, "block number exceeds 32 bits")
1257             });
1258         } else if (deltaBlocks > 0) {
1259             supplyState.block = safe32(blockNumber, "block number exceeds 32 bits");
1260         }
1261     }
1262 
1263     /**
1264      * @notice Accrue COMP to the market by updating the borrow index
1265      * @param cToken The market whose borrow index to update
1266      */
1267     function updateCompBorrowIndex(address cToken, Exp memory marketBorrowIndex) internal {
1268         CompMarketState storage borrowState = compBorrowState[cToken];
1269         uint256 borrowSpeed = compSpeeds[cToken];
1270         uint256 blockNumber = getBlockNumber();
1271         uint256 deltaBlocks = sub_(blockNumber, uint256(borrowState.block));
1272         if (deltaBlocks > 0 && borrowSpeed > 0) {
1273             uint256 borrowAmount = div_(CToken(cToken).totalBorrows(), marketBorrowIndex);
1274             uint256 compAccrued = mul_(deltaBlocks, borrowSpeed);
1275             Double memory ratio = borrowAmount > 0 ? fraction(compAccrued, borrowAmount) : Double({mantissa: 0});
1276             Double memory index = add_(Double({mantissa: borrowState.index}), ratio);
1277             compBorrowState[cToken] = CompMarketState({
1278                 index: safe224(index.mantissa, "new index exceeds 224 bits"),
1279                 block: safe32(blockNumber, "block number exceeds 32 bits")
1280             });
1281         } else if (deltaBlocks > 0) {
1282             borrowState.block = safe32(blockNumber, "block number exceeds 32 bits");
1283         }
1284     }
1285 
1286     /**
1287      * @notice Calculate COMP accrued by a supplier and possibly transfer it to them
1288      * @param cToken The market in which the supplier is interacting
1289      * @param supplier The address of the supplier to distribute COMP to
1290      */
1291     function distributeSupplierComp(
1292         address cToken,
1293         address supplier,
1294         bool distributeAll
1295     ) internal {
1296         CompMarketState storage supplyState = compSupplyState[cToken];
1297         Double memory supplyIndex = Double({mantissa: supplyState.index});
1298         Double memory supplierIndex = Double({mantissa: compSupplierIndex[cToken][supplier]});
1299         compSupplierIndex[cToken][supplier] = supplyIndex.mantissa;
1300 
1301         if (supplierIndex.mantissa == 0 && supplyIndex.mantissa > 0) {
1302             supplierIndex.mantissa = compInitialIndex;
1303         }
1304 
1305         Double memory deltaIndex = sub_(supplyIndex, supplierIndex);
1306         uint256 supplierTokens = CToken(cToken).balanceOf(supplier);
1307         uint256 supplierDelta = mul_(supplierTokens, deltaIndex);
1308         uint256 supplierAccrued = add_(compAccrued[supplier], supplierDelta);
1309         compAccrued[supplier] = transferComp(supplier, supplierAccrued, distributeAll ? 0 : compClaimThreshold);
1310         emit DistributedSupplierComp(CToken(cToken), supplier, supplierDelta, supplyIndex.mantissa);
1311     }
1312 
1313     /**
1314      * @notice Calculate COMP accrued by a borrower and possibly transfer it to them
1315      * @dev Borrowers will not begin to accrue until after the first interaction with the protocol.
1316      * @param cToken The market in which the borrower is interacting
1317      * @param borrower The address of the borrower to distribute COMP to
1318      */
1319     function distributeBorrowerComp(
1320         address cToken,
1321         address borrower,
1322         Exp memory marketBorrowIndex,
1323         bool distributeAll
1324     ) internal {
1325         CompMarketState storage borrowState = compBorrowState[cToken];
1326         Double memory borrowIndex = Double({mantissa: borrowState.index});
1327         Double memory borrowerIndex = Double({mantissa: compBorrowerIndex[cToken][borrower]});
1328         compBorrowerIndex[cToken][borrower] = borrowIndex.mantissa;
1329 
1330         if (borrowerIndex.mantissa > 0) {
1331             Double memory deltaIndex = sub_(borrowIndex, borrowerIndex);
1332             uint256 borrowerAmount = div_(CToken(cToken).borrowBalanceStored(borrower), marketBorrowIndex);
1333             uint256 borrowerDelta = mul_(borrowerAmount, deltaIndex);
1334             uint256 borrowerAccrued = add_(compAccrued[borrower], borrowerDelta);
1335             compAccrued[borrower] = transferComp(borrower, borrowerAccrued, distributeAll ? 0 : compClaimThreshold);
1336             emit DistributedBorrowerComp(CToken(cToken), borrower, borrowerDelta, borrowIndex.mantissa);
1337         }
1338     }
1339 
1340     /**
1341      * @notice Transfer COMP to the user, if they are above the threshold
1342      * @dev Note: If there is not enough COMP, we do not perform the transfer all.
1343      * @param user The address of the user to transfer COMP to
1344      * @param userAccrued The amount of COMP to (possibly) transfer
1345      * @return The amount of COMP which was NOT transferred to the user
1346      */
1347     function transferComp(
1348         address user,
1349         uint256 userAccrued,
1350         uint256 threshold
1351     ) internal returns (uint256) {
1352         if (userAccrued >= threshold && userAccrued > 0) {
1353             Comp comp = Comp(getCompAddress());
1354             uint256 compRemaining = comp.balanceOf(address(this));
1355             if (userAccrued <= compRemaining) {
1356                 comp.transfer(user, userAccrued);
1357                 return 0;
1358             }
1359         }
1360         return userAccrued;
1361     }
1362 
1363     /**
1364      * @notice Claim all the comp accrued by holder in all markets
1365      * @param holder The address to claim COMP for
1366      */
1367     function claimComp(address holder) public {
1368         return claimComp(holder, allMarkets);
1369     }
1370 
1371     /**
1372      * @notice Claim all the comp accrued by holder in the specified markets
1373      * @param holder The address to claim COMP for
1374      * @param cTokens The list of markets to claim COMP in
1375      */
1376     function claimComp(address holder, CToken[] memory cTokens) public {
1377         address[] memory holders = new address[](1);
1378         holders[0] = holder;
1379         claimComp(holders, cTokens, true, true);
1380     }
1381 
1382     /**
1383      * @notice Claim all comp accrued by the holders
1384      * @param holders The addresses to claim COMP for
1385      * @param cTokens The list of markets to claim COMP in
1386      * @param borrowers Whether or not to claim COMP earned by borrowing
1387      * @param suppliers Whether or not to claim COMP earned by supplying
1388      */
1389     function claimComp(
1390         address[] memory holders,
1391         CToken[] memory cTokens,
1392         bool borrowers,
1393         bool suppliers
1394     ) public {
1395         for (uint256 i = 0; i < cTokens.length; i++) {
1396             CToken cToken = cTokens[i];
1397             require(markets[address(cToken)].isListed, "market must be listed");
1398             if (borrowers == true) {
1399                 Exp memory borrowIndex = Exp({mantissa: cToken.borrowIndex()});
1400                 updateCompBorrowIndex(address(cToken), borrowIndex);
1401                 for (uint256 j = 0; j < holders.length; j++) {
1402                     distributeBorrowerComp(address(cToken), holders[j], borrowIndex, true);
1403                 }
1404             }
1405             if (suppliers == true) {
1406                 updateCompSupplyIndex(address(cToken));
1407                 for (uint256 j = 0; j < holders.length; j++) {
1408                     distributeSupplierComp(address(cToken), holders[j], true);
1409                 }
1410             }
1411         }
1412     }
1413 
1414     /*** Comp Distribution Admin ***/
1415 
1416     /**
1417      * @notice Set cTokens compSpeed
1418      * @param cTokens The addresses of cTokens
1419      * @param speeds The list of COMP speeds
1420      */
1421     function _setCompSpeeds(address[] memory cTokens, uint256[] memory speeds) public {
1422         require(msg.sender == admin, "only admin can set comp speeds");
1423 
1424         uint256 numMarkets = cTokens.length;
1425         uint256 numSpeeds = speeds.length;
1426 
1427         require(numMarkets != 0 && numMarkets == numSpeeds, "invalid input");
1428 
1429         for (uint256 i = 0; i < numMarkets; i++) {
1430             if (speeds[i] > 0) {
1431                 _initCompState(cTokens[i]);
1432             }
1433 
1434             // Update supply and borrow index.
1435             CToken cToken = CToken(cTokens[i]);
1436             Exp memory borrowIndex = Exp({mantissa: cToken.borrowIndex()});
1437             updateCompSupplyIndex(address(cToken));
1438             updateCompBorrowIndex(address(cToken), borrowIndex);
1439 
1440             compSpeeds[address(cToken)] = speeds[i];
1441             emit CompSpeedUpdated(cToken, speeds[i]);
1442         }
1443     }
1444 
1445     function _initCompState(address cToken) internal {
1446         if (compSupplyState[cToken].index == 0 && compSupplyState[cToken].block == 0) {
1447             compSupplyState[cToken] = CompMarketState({
1448                 index: compInitialIndex,
1449                 block: safe32(getBlockNumber(), "block number exceeds 32 bits")
1450             });
1451         }
1452 
1453         if (compBorrowState[cToken].index == 0 && compBorrowState[cToken].block == 0) {
1454             compBorrowState[cToken] = CompMarketState({
1455                 index: compInitialIndex,
1456                 block: safe32(getBlockNumber(), "block number exceeds 32 bits")
1457             });
1458         }
1459     }
1460 
1461     /**
1462      * @notice Return all of the markets
1463      * @dev The automatic getter may be used to access an individual market.
1464      * @return The list of market addresses
1465      */
1466     function getAllMarkets() public view returns (CToken[] memory) {
1467         return allMarkets;
1468     }
1469 
1470     function getBlockNumber() public view returns (uint256) {
1471         return block.number;
1472     }
1473 
1474     /**
1475      * @notice Return the address of the COMP token
1476      * @return The address of COMP
1477      */
1478     function getCompAddress() public view returns (address) {
1479         return 0x2ba592F78dB6436527729929AAf6c908497cB200;
1480     }
1481 }
