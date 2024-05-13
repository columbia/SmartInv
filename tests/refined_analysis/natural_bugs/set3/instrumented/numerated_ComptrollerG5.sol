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
16 contract ComptrollerG5 is ComptrollerV4Storage, ComptrollerInterface, ComptrollerErrorReporter, Exponential {
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
75     /// @notice Emitted when borrow cap for a cToken is changed
76     event NewBorrowCap(CToken indexed cToken, uint256 newBorrowCap);
77 
78     /// @notice Emitted when borrow cap guardian is changed
79     event NewBorrowCapGuardian(address oldBorrowCapGuardian, address newBorrowCapGuardian);
80 
81     /// @notice The threshold above which the flywheel transfers COMP, in wei
82     uint256 public constant compClaimThreshold = 0.001e18;
83 
84     /// @notice The initial COMP index for a market
85     uint224 public constant compInitialIndex = 1e36;
86 
87     // closeFactorMantissa must be strictly greater than this value
88     uint256 internal constant closeFactorMinMantissa = 0.05e18; // 0.05
89 
90     // closeFactorMantissa must not exceed this value
91     uint256 internal constant closeFactorMaxMantissa = 0.9e18; // 0.9
92 
93     // No collateralFactorMantissa may exceed this value
94     uint256 internal constant collateralFactorMaxMantissa = 0.9e18; // 0.9
95 
96     // liquidationIncentiveMantissa must be no less than this value
97     uint256 internal constant liquidationIncentiveMinMantissa = 1.0e18; // 1.0
98 
99     // liquidationIncentiveMantissa must be no greater than this value
100     uint256 internal constant liquidationIncentiveMaxMantissa = 1.5e18; // 1.5
101 
102     constructor() public {
103         admin = msg.sender;
104     }
105 
106     /*** Assets You Are In ***/
107 
108     /**
109      * @notice Returns the assets an account has entered
110      * @param account The address of the account to pull assets for
111      * @return A dynamic list with the assets the account has entered
112      */
113     function getAssetsIn(address account) external view returns (CToken[] memory) {
114         CToken[] memory assetsIn = accountAssets[account];
115 
116         return assetsIn;
117     }
118 
119     /**
120      * @notice Returns whether the given account is entered in the given asset
121      * @param account The address of the account to check
122      * @param cToken The cToken to check
123      * @return True if the account is in the asset, otherwise false.
124      */
125     function checkMembership(address account, CToken cToken) external view returns (bool) {
126         return markets[address(cToken)].accountMembership[account];
127     }
128 
129     /**
130      * @notice Add assets to be included in account liquidity calculation
131      * @param cTokens The list of addresses of the cToken markets to be enabled
132      * @return Success indicator for whether each corresponding market was entered
133      */
134     function enterMarkets(address[] memory cTokens) public returns (uint256[] memory) {
135         uint256 len = cTokens.length;
136 
137         uint256[] memory results = new uint256[](len);
138         for (uint256 i = 0; i < len; i++) {
139             CToken cToken = CToken(cTokens[i]);
140 
141             results[i] = uint256(addToMarketInternal(cToken, msg.sender));
142         }
143 
144         return results;
145     }
146 
147     /**
148      * @notice Add the market to the borrower's "assets in" for liquidity calculations
149      * @param cToken The market to enter
150      * @param borrower The address of the account to modify
151      * @return Success indicator for whether the market was entered
152      */
153     function addToMarketInternal(CToken cToken, address borrower) internal returns (Error) {
154         Market storage marketToJoin = markets[address(cToken)];
155 
156         if (!marketToJoin.isListed) {
157             // market is not listed, cannot join
158             return Error.MARKET_NOT_LISTED;
159         }
160 
161         if (marketToJoin.accountMembership[borrower] == true) {
162             // already joined
163             return Error.NO_ERROR;
164         }
165 
166         if (accountAssets[borrower].length >= maxAssets) {
167             // no space, cannot join
168             return Error.TOO_MANY_ASSETS;
169         }
170 
171         // survived the gauntlet, add to list
172         // NOTE: we store these somewhat redundantly as a significant optimization
173         //  this avoids having to iterate through the list for the most common use cases
174         //  that is, only when we need to perform liquidity checks
175         //  and not whenever we want to check if an account is in a particular market
176         marketToJoin.accountMembership[borrower] = true;
177         accountAssets[borrower].push(cToken);
178 
179         emit MarketEntered(cToken, borrower);
180 
181         return Error.NO_ERROR;
182     }
183 
184     /**
185      * @notice Removes asset from sender's account liquidity calculation
186      * @dev Sender must not have an outstanding borrow balance in the asset,
187      *  or be providing necessary collateral for an outstanding borrow.
188      * @param cTokenAddress The address of the asset to be removed
189      * @return Whether or not the account successfully exited the market
190      */
191     function exitMarket(address cTokenAddress) external returns (uint256) {
192         CToken cToken = CToken(cTokenAddress);
193         /* Get sender tokensHeld and amountOwed underlying from the cToken */
194         (uint256 oErr, uint256 tokensHeld, uint256 amountOwed, ) = cToken.getAccountSnapshot(msg.sender);
195         require(oErr == 0, "exitMarket: getAccountSnapshot failed"); // semi-opaque error code
196 
197         /* Fail if the sender has a borrow balance */
198         if (amountOwed != 0) {
199             return fail(Error.NONZERO_BORROW_BALANCE, FailureInfo.EXIT_MARKET_BALANCE_OWED);
200         }
201 
202         /* Fail if the sender is not permitted to redeem all of their tokens */
203         uint256 allowed = redeemAllowedInternal(cTokenAddress, msg.sender, tokensHeld);
204         if (allowed != 0) {
205             return failOpaque(Error.REJECTION, FailureInfo.EXIT_MARKET_REJECTION, allowed);
206         }
207 
208         Market storage marketToExit = markets[address(cToken)];
209 
210         /* Return true if the sender is not already ‘in’ the market */
211         if (!marketToExit.accountMembership[msg.sender]) {
212             return uint256(Error.NO_ERROR);
213         }
214 
215         /* Set cToken account membership to false */
216         delete marketToExit.accountMembership[msg.sender];
217 
218         /* Delete cToken from the account’s list of assets */
219         // load into memory for faster iteration
220         CToken[] memory userAssetList = accountAssets[msg.sender];
221         uint256 len = userAssetList.length;
222         uint256 assetIndex = len;
223         for (uint256 i = 0; i < len; i++) {
224             if (userAssetList[i] == cToken) {
225                 assetIndex = i;
226                 break;
227             }
228         }
229 
230         // We *must* have found the asset in the list or our redundant data structure is broken
231         assert(assetIndex < len);
232 
233         // copy last item in list to location of item to be removed, reduce length by 1
234         CToken[] storage storedList = accountAssets[msg.sender];
235         storedList[assetIndex] = storedList[storedList.length - 1];
236         storedList.length--;
237 
238         emit MarketExited(cToken, msg.sender);
239 
240         return uint256(Error.NO_ERROR);
241     }
242 
243     /*** Policy Hooks ***/
244 
245     /**
246      * @notice Checks if the account should be allowed to mint tokens in the given market
247      * @param cToken The market to verify the mint against
248      * @param minter The account which would get the minted tokens
249      * @param mintAmount The amount of underlying being supplied to the market in exchange for tokens
250      * @return 0 if the mint is allowed, otherwise a semi-opaque error code (See ErrorReporter.sol)
251      */
252     function mintAllowed(
253         address cToken,
254         address minter,
255         uint256 mintAmount
256     ) external returns (uint256) {
257         // Pausing is a very serious situation - we revert to sound the alarms
258         require(!mintGuardianPaused[cToken], "mint is paused");
259 
260         // Shh - currently unused
261         minter;
262         mintAmount;
263 
264         if (!markets[cToken].isListed) {
265             return uint256(Error.MARKET_NOT_LISTED);
266         }
267 
268         // Keep the flywheel moving
269         updateCompSupplyIndex(cToken);
270         distributeSupplierComp(cToken, minter, false);
271 
272         return uint256(Error.NO_ERROR);
273     }
274 
275     /**
276      * @notice Validates mint and reverts on rejection. May emit logs.
277      * @param cToken Asset being minted
278      * @param minter The address minting the tokens
279      * @param actualMintAmount The amount of the underlying asset being minted
280      * @param mintTokens The number of tokens being minted
281      */
282     function mintVerify(
283         address cToken,
284         address minter,
285         uint256 actualMintAmount,
286         uint256 mintTokens
287     ) external {
288         // Shh - currently unused
289         cToken;
290         minter;
291         actualMintAmount;
292         mintTokens;
293 
294         // Shh - we don't ever want this hook to be marked pure
295         if (false) {
296             maxAssets = maxAssets;
297         }
298     }
299 
300     /**
301      * @notice Checks if the account should be allowed to redeem tokens in the given market
302      * @param cToken The market to verify the redeem against
303      * @param redeemer The account which would redeem the tokens
304      * @param redeemTokens The number of cTokens to exchange for the underlying asset in the market
305      * @return 0 if the redeem is allowed, otherwise a semi-opaque error code (See ErrorReporter.sol)
306      */
307     function redeemAllowed(
308         address cToken,
309         address redeemer,
310         uint256 redeemTokens
311     ) external returns (uint256) {
312         uint256 allowed = redeemAllowedInternal(cToken, redeemer, redeemTokens);
313         if (allowed != uint256(Error.NO_ERROR)) {
314             return allowed;
315         }
316 
317         // Keep the flywheel moving
318         updateCompSupplyIndex(cToken);
319         distributeSupplierComp(cToken, redeemer, false);
320 
321         return uint256(Error.NO_ERROR);
322     }
323 
324     function redeemAllowedInternal(
325         address cToken,
326         address redeemer,
327         uint256 redeemTokens
328     ) internal view returns (uint256) {
329         if (!markets[cToken].isListed) {
330             return uint256(Error.MARKET_NOT_LISTED);
331         }
332 
333         /* If the redeemer is not 'in' the market, then we can bypass the liquidity check */
334         if (!markets[cToken].accountMembership[redeemer]) {
335             return uint256(Error.NO_ERROR);
336         }
337 
338         /* Otherwise, perform a hypothetical liquidity check to guard against shortfall */
339         (Error err, , uint256 shortfall) = getHypotheticalAccountLiquidityInternal(
340             redeemer,
341             CToken(cToken),
342             redeemTokens,
343             0
344         );
345         if (err != Error.NO_ERROR) {
346             return uint256(err);
347         }
348         if (shortfall > 0) {
349             return uint256(Error.INSUFFICIENT_LIQUIDITY);
350         }
351 
352         return uint256(Error.NO_ERROR);
353     }
354 
355     /**
356      * @notice Validates redeem and reverts on rejection. May emit logs.
357      * @param cToken Asset being redeemed
358      * @param redeemer The address redeeming the tokens
359      * @param redeemAmount The amount of the underlying asset being redeemed
360      * @param redeemTokens The number of tokens being redeemed
361      */
362     function redeemVerify(
363         address cToken,
364         address redeemer,
365         uint256 redeemAmount,
366         uint256 redeemTokens
367     ) external {
368         // Shh - currently unused
369         cToken;
370         redeemer;
371 
372         // Require tokens is zero or amount is also zero
373         if (redeemTokens == 0 && redeemAmount > 0) {
374             revert("redeemTokens zero");
375         }
376     }
377 
378     /**
379      * @notice Checks if the account should be allowed to borrow the underlying asset of the given market
380      * @param cToken The market to verify the borrow against
381      * @param borrower The account which would borrow the asset
382      * @param borrowAmount The amount of underlying the account would borrow
383      * @return 0 if the borrow is allowed, otherwise a semi-opaque error code (See ErrorReporter.sol)
384      */
385     function borrowAllowed(
386         address cToken,
387         address borrower,
388         uint256 borrowAmount
389     ) external returns (uint256) {
390         // Pausing is a very serious situation - we revert to sound the alarms
391         require(!borrowGuardianPaused[cToken], "borrow is paused");
392 
393         if (!markets[cToken].isListed) {
394             return uint256(Error.MARKET_NOT_LISTED);
395         }
396 
397         if (!markets[cToken].accountMembership[borrower]) {
398             // only cTokens may call borrowAllowed if borrower not in market
399             require(msg.sender == cToken, "sender must be cToken");
400 
401             // attempt to add borrower to the market
402             Error err = addToMarketInternal(CToken(msg.sender), borrower);
403             if (err != Error.NO_ERROR) {
404                 return uint256(err);
405             }
406 
407             // it should be impossible to break the important invariant
408             assert(markets[cToken].accountMembership[borrower]);
409         }
410 
411         if (oracle.getUnderlyingPrice(CToken(cToken)) == 0) {
412             return uint256(Error.PRICE_ERROR);
413         }
414 
415         uint256 borrowCap = borrowCaps[cToken];
416         // Borrow cap of 0 corresponds to unlimited borrowing
417         if (borrowCap != 0) {
418             uint256 totalBorrows = CToken(cToken).totalBorrows();
419             (MathError mathErr, uint256 nextTotalBorrows) = addUInt(totalBorrows, borrowAmount);
420             require(mathErr == MathError.NO_ERROR, "total borrows overflow");
421             require(nextTotalBorrows < borrowCap, "market borrow cap reached");
422         }
423 
424         (Error err, , uint256 shortfall) = getHypotheticalAccountLiquidityInternal(
425             borrower,
426             CToken(cToken),
427             0,
428             borrowAmount
429         );
430         if (err != Error.NO_ERROR) {
431             return uint256(err);
432         }
433         if (shortfall > 0) {
434             return uint256(Error.INSUFFICIENT_LIQUIDITY);
435         }
436 
437         // Keep the flywheel moving
438         Exp memory borrowIndex = Exp({mantissa: CToken(cToken).borrowIndex()});
439         updateCompBorrowIndex(cToken, borrowIndex);
440         distributeBorrowerComp(cToken, borrower, borrowIndex, false);
441 
442         return uint256(Error.NO_ERROR);
443     }
444 
445     /**
446      * @notice Validates borrow and reverts on rejection. May emit logs.
447      * @param cToken Asset whose underlying is being borrowed
448      * @param borrower The address borrowing the underlying
449      * @param borrowAmount The amount of the underlying asset requested to borrow
450      */
451     function borrowVerify(
452         address cToken,
453         address borrower,
454         uint256 borrowAmount
455     ) external {
456         // Shh - currently unused
457         cToken;
458         borrower;
459         borrowAmount;
460 
461         // Shh - we don't ever want this hook to be marked pure
462         if (false) {
463             maxAssets = maxAssets;
464         }
465     }
466 
467     /**
468      * @notice Checks if the account should be allowed to repay a borrow in the given market
469      * @param cToken The market to verify the repay against
470      * @param payer The account which would repay the asset
471      * @param borrower The account which would borrowed the asset
472      * @param repayAmount The amount of the underlying asset the account would repay
473      * @return 0 if the repay is allowed, otherwise a semi-opaque error code (See ErrorReporter.sol)
474      */
475     function repayBorrowAllowed(
476         address cToken,
477         address payer,
478         address borrower,
479         uint256 repayAmount
480     ) external returns (uint256) {
481         // Shh - currently unused
482         payer;
483         borrower;
484         repayAmount;
485 
486         if (!markets[cToken].isListed) {
487             return uint256(Error.MARKET_NOT_LISTED);
488         }
489 
490         // Keep the flywheel moving
491         Exp memory borrowIndex = Exp({mantissa: CToken(cToken).borrowIndex()});
492         updateCompBorrowIndex(cToken, borrowIndex);
493         distributeBorrowerComp(cToken, borrower, borrowIndex, false);
494 
495         return uint256(Error.NO_ERROR);
496     }
497 
498     /**
499      * @notice Validates repayBorrow and reverts on rejection. May emit logs.
500      * @param cToken Asset being repaid
501      * @param payer The address repaying the borrow
502      * @param borrower The address of the borrower
503      * @param actualRepayAmount The amount of underlying being repaid
504      */
505     function repayBorrowVerify(
506         address cToken,
507         address payer,
508         address borrower,
509         uint256 actualRepayAmount,
510         uint256 borrowerIndex
511     ) external {
512         // Shh - currently unused
513         cToken;
514         payer;
515         borrower;
516         actualRepayAmount;
517         borrowerIndex;
518 
519         // Shh - we don't ever want this hook to be marked pure
520         if (false) {
521             maxAssets = maxAssets;
522         }
523     }
524 
525     /**
526      * @notice Checks if the liquidation should be allowed to occur
527      * @param cTokenBorrowed Asset which was borrowed by the borrower
528      * @param cTokenCollateral Asset which was used as collateral and will be seized
529      * @param liquidator The address repaying the borrow and seizing the collateral
530      * @param borrower The address of the borrower
531      * @param repayAmount The amount of underlying being repaid
532      */
533     function liquidateBorrowAllowed(
534         address cTokenBorrowed,
535         address cTokenCollateral,
536         address liquidator,
537         address borrower,
538         uint256 repayAmount
539     ) external returns (uint256) {
540         // Shh - currently unused
541         liquidator;
542 
543         if (!markets[cTokenBorrowed].isListed || !markets[cTokenCollateral].isListed) {
544             return uint256(Error.MARKET_NOT_LISTED);
545         }
546 
547         /* The borrower must have shortfall in order to be liquidatable */
548         (Error err, , uint256 shortfall) = getAccountLiquidityInternal(borrower);
549         if (err != Error.NO_ERROR) {
550             return uint256(err);
551         }
552         if (shortfall == 0) {
553             return uint256(Error.INSUFFICIENT_SHORTFALL);
554         }
555 
556         /* The liquidator may not repay more than what is allowed by the closeFactor */
557         uint256 borrowBalance = CToken(cTokenBorrowed).borrowBalanceStored(borrower);
558         (MathError mathErr, uint256 maxClose) = mulScalarTruncate(Exp({mantissa: closeFactorMantissa}), borrowBalance);
559         if (mathErr != MathError.NO_ERROR) {
560             return uint256(Error.MATH_ERROR);
561         }
562         if (repayAmount > maxClose) {
563             return uint256(Error.TOO_MUCH_REPAY);
564         }
565 
566         return uint256(Error.NO_ERROR);
567     }
568 
569     /**
570      * @notice Validates liquidateBorrow and reverts on rejection. May emit logs.
571      * @param cTokenBorrowed Asset which was borrowed by the borrower
572      * @param cTokenCollateral Asset which was used as collateral and will be seized
573      * @param liquidator The address repaying the borrow and seizing the collateral
574      * @param borrower The address of the borrower
575      * @param actualRepayAmount The amount of underlying being repaid
576      */
577     function liquidateBorrowVerify(
578         address cTokenBorrowed,
579         address cTokenCollateral,
580         address liquidator,
581         address borrower,
582         uint256 actualRepayAmount,
583         uint256 seizeTokens
584     ) external {
585         // Shh - currently unused
586         cTokenBorrowed;
587         cTokenCollateral;
588         liquidator;
589         borrower;
590         actualRepayAmount;
591         seizeTokens;
592 
593         // Shh - we don't ever want this hook to be marked pure
594         if (false) {
595             maxAssets = maxAssets;
596         }
597     }
598 
599     /**
600      * @notice Checks if the seizing of assets should be allowed to occur
601      * @param cTokenCollateral Asset which was used as collateral and will be seized
602      * @param cTokenBorrowed Asset which was borrowed by the borrower
603      * @param liquidator The address repaying the borrow and seizing the collateral
604      * @param borrower The address of the borrower
605      * @param seizeTokens The number of collateral tokens to seize
606      */
607     function seizeAllowed(
608         address cTokenCollateral,
609         address cTokenBorrowed,
610         address liquidator,
611         address borrower,
612         uint256 seizeTokens
613     ) external returns (uint256) {
614         // Pausing is a very serious situation - we revert to sound the alarms
615         require(!seizeGuardianPaused, "seize is paused");
616 
617         // Shh - currently unused
618         seizeTokens;
619 
620         if (!markets[cTokenCollateral].isListed || !markets[cTokenBorrowed].isListed) {
621             return uint256(Error.MARKET_NOT_LISTED);
622         }
623 
624         if (CToken(cTokenCollateral).comptroller() != CToken(cTokenBorrowed).comptroller()) {
625             return uint256(Error.COMPTROLLER_MISMATCH);
626         }
627 
628         // Keep the flywheel moving
629         updateCompSupplyIndex(cTokenCollateral);
630         distributeSupplierComp(cTokenCollateral, borrower, false);
631         distributeSupplierComp(cTokenCollateral, liquidator, false);
632 
633         return uint256(Error.NO_ERROR);
634     }
635 
636     /**
637      * @notice Validates seize and reverts on rejection. May emit logs.
638      * @param cTokenCollateral Asset which was used as collateral and will be seized
639      * @param cTokenBorrowed Asset which was borrowed by the borrower
640      * @param liquidator The address repaying the borrow and seizing the collateral
641      * @param borrower The address of the borrower
642      * @param seizeTokens The number of collateral tokens to seize
643      */
644     function seizeVerify(
645         address cTokenCollateral,
646         address cTokenBorrowed,
647         address liquidator,
648         address borrower,
649         uint256 seizeTokens
650     ) external {
651         // Shh - currently unused
652         cTokenCollateral;
653         cTokenBorrowed;
654         liquidator;
655         borrower;
656         seizeTokens;
657 
658         // Shh - we don't ever want this hook to be marked pure
659         if (false) {
660             maxAssets = maxAssets;
661         }
662     }
663 
664     /**
665      * @notice Checks if the account should be allowed to transfer tokens in the given market
666      * @param cToken The market to verify the transfer against
667      * @param src The account which sources the tokens
668      * @param dst The account which receives the tokens
669      * @param transferTokens The number of cTokens to transfer
670      * @return 0 if the transfer is allowed, otherwise a semi-opaque error code (See ErrorReporter.sol)
671      */
672     function transferAllowed(
673         address cToken,
674         address src,
675         address dst,
676         uint256 transferTokens
677     ) external returns (uint256) {
678         // Pausing is a very serious situation - we revert to sound the alarms
679         require(!transferGuardianPaused, "transfer is paused");
680 
681         // Currently the only consideration is whether or not
682         //  the src is allowed to redeem this many tokens
683         uint256 allowed = redeemAllowedInternal(cToken, src, transferTokens);
684         if (allowed != uint256(Error.NO_ERROR)) {
685             return allowed;
686         }
687 
688         // Keep the flywheel moving
689         updateCompSupplyIndex(cToken);
690         distributeSupplierComp(cToken, src, false);
691         distributeSupplierComp(cToken, dst, false);
692 
693         return uint256(Error.NO_ERROR);
694     }
695 
696     /**
697      * @notice Validates transfer and reverts on rejection. May emit logs.
698      * @param cToken Asset being transferred
699      * @param src The account which sources the tokens
700      * @param dst The account which receives the tokens
701      * @param transferTokens The number of cTokens to transfer
702      */
703     function transferVerify(
704         address cToken,
705         address src,
706         address dst,
707         uint256 transferTokens
708     ) external {
709         // Shh - currently unused
710         cToken;
711         src;
712         dst;
713         transferTokens;
714 
715         // Shh - we don't ever want this hook to be marked pure
716         if (false) {
717             maxAssets = maxAssets;
718         }
719     }
720 
721     /*** Liquidity/Liquidation Calculations ***/
722 
723     /**
724      * @dev Local vars for avoiding stack-depth limits in calculating account liquidity.
725      *  Note that `cTokenBalance` is the number of cTokens the account owns in the market,
726      *  whereas `borrowBalance` is the amount of underlying that the account has borrowed.
727      */
728     struct AccountLiquidityLocalVars {
729         uint256 sumCollateral;
730         uint256 sumBorrowPlusEffects;
731         uint256 cTokenBalance;
732         uint256 borrowBalance;
733         uint256 exchangeRateMantissa;
734         uint256 oraclePriceMantissa;
735         Exp collateralFactor;
736         Exp exchangeRate;
737         Exp oraclePrice;
738         Exp tokensToDenom;
739     }
740 
741     /**
742      * @notice Determine the current account liquidity wrt collateral requirements
743      * @return (possible error code (semi-opaque),
744                 account liquidity in excess of collateral requirements,
745      *          account shortfall below collateral requirements)
746      */
747     function getAccountLiquidity(address account)
748         public
749         view
750         returns (
751             uint256,
752             uint256,
753             uint256
754         )
755     {
756         (Error err, uint256 liquidity, uint256 shortfall) = getHypotheticalAccountLiquidityInternal(
757             account,
758             CToken(0),
759             0,
760             0
761         );
762 
763         return (uint256(err), liquidity, shortfall);
764     }
765 
766     /**
767      * @notice Determine the current account liquidity wrt collateral requirements
768      * @return (possible error code,
769                 account liquidity in excess of collateral requirements,
770      *          account shortfall below collateral requirements)
771      */
772     function getAccountLiquidityInternal(address account)
773         internal
774         view
775         returns (
776             Error,
777             uint256,
778             uint256
779         )
780     {
781         return getHypotheticalAccountLiquidityInternal(account, CToken(0), 0, 0);
782     }
783 
784     /**
785      * @notice Determine what the account liquidity would be if the given amounts were redeemed/borrowed
786      * @param cTokenModify The market to hypothetically redeem/borrow in
787      * @param account The account to determine liquidity for
788      * @param redeemTokens The number of tokens to hypothetically redeem
789      * @param borrowAmount The amount of underlying to hypothetically borrow
790      * @return (possible error code (semi-opaque),
791                 hypothetical account liquidity in excess of collateral requirements,
792      *          hypothetical account shortfall below collateral requirements)
793      */
794     function getHypotheticalAccountLiquidity(
795         address account,
796         address cTokenModify,
797         uint256 redeemTokens,
798         uint256 borrowAmount
799     )
800         public
801         view
802         returns (
803             uint256,
804             uint256,
805             uint256
806         )
807     {
808         (Error err, uint256 liquidity, uint256 shortfall) = getHypotheticalAccountLiquidityInternal(
809             account,
810             CToken(cTokenModify),
811             redeemTokens,
812             borrowAmount
813         );
814         return (uint256(err), liquidity, shortfall);
815     }
816 
817     /**
818      * @notice Determine what the account liquidity would be if the given amounts were redeemed/borrowed
819      * @param cTokenModify The market to hypothetically redeem/borrow in
820      * @param account The account to determine liquidity for
821      * @param redeemTokens The number of tokens to hypothetically redeem
822      * @param borrowAmount The amount of underlying to hypothetically borrow
823      * @dev Note that we calculate the exchangeRateStored for each collateral cToken using stored data,
824      *  without calculating accumulated interest.
825      * @return (possible error code,
826                 hypothetical account liquidity in excess of collateral requirements,
827      *          hypothetical account shortfall below collateral requirements)
828      */
829     function getHypotheticalAccountLiquidityInternal(
830         address account,
831         CToken cTokenModify,
832         uint256 redeemTokens,
833         uint256 borrowAmount
834     )
835         internal
836         view
837         returns (
838             Error,
839             uint256,
840             uint256
841         )
842     {
843         AccountLiquidityLocalVars memory vars; // Holds all our calculation results
844         uint256 oErr;
845         MathError mErr;
846 
847         // For each asset the account is in
848         CToken[] memory assets = accountAssets[account];
849         for (uint256 i = 0; i < assets.length; i++) {
850             CToken asset = assets[i];
851 
852             // Read the balances and exchange rate from the cToken
853             (oErr, vars.cTokenBalance, vars.borrowBalance, vars.exchangeRateMantissa) = asset.getAccountSnapshot(
854                 account
855             );
856             if (oErr != 0) {
857                 // semi-opaque error code, we assume NO_ERROR == 0 is invariant between upgrades
858                 return (Error.SNAPSHOT_ERROR, 0, 0);
859             }
860             vars.collateralFactor = Exp({mantissa: markets[address(asset)].collateralFactorMantissa});
861             vars.exchangeRate = Exp({mantissa: vars.exchangeRateMantissa});
862 
863             // Get the normalized price of the asset
864             vars.oraclePriceMantissa = oracle.getUnderlyingPrice(asset);
865             if (vars.oraclePriceMantissa == 0) {
866                 return (Error.PRICE_ERROR, 0, 0);
867             }
868             vars.oraclePrice = Exp({mantissa: vars.oraclePriceMantissa});
869 
870             // Pre-compute a conversion factor from tokens -> ether (normalized price value)
871             (mErr, vars.tokensToDenom) = mulExp3(vars.collateralFactor, vars.exchangeRate, vars.oraclePrice);
872             if (mErr != MathError.NO_ERROR) {
873                 return (Error.MATH_ERROR, 0, 0);
874             }
875 
876             // sumCollateral += tokensToDenom * cTokenBalance
877             (mErr, vars.sumCollateral) = mulScalarTruncateAddUInt(
878                 vars.tokensToDenom,
879                 vars.cTokenBalance,
880                 vars.sumCollateral
881             );
882             if (mErr != MathError.NO_ERROR) {
883                 return (Error.MATH_ERROR, 0, 0);
884             }
885 
886             // sumBorrowPlusEffects += oraclePrice * borrowBalance
887             (mErr, vars.sumBorrowPlusEffects) = mulScalarTruncateAddUInt(
888                 vars.oraclePrice,
889                 vars.borrowBalance,
890                 vars.sumBorrowPlusEffects
891             );
892             if (mErr != MathError.NO_ERROR) {
893                 return (Error.MATH_ERROR, 0, 0);
894             }
895 
896             // Calculate effects of interacting with cTokenModify
897             if (asset == cTokenModify) {
898                 // redeem effect
899                 // sumBorrowPlusEffects += tokensToDenom * redeemTokens
900                 (mErr, vars.sumBorrowPlusEffects) = mulScalarTruncateAddUInt(
901                     vars.tokensToDenom,
902                     redeemTokens,
903                     vars.sumBorrowPlusEffects
904                 );
905                 if (mErr != MathError.NO_ERROR) {
906                     return (Error.MATH_ERROR, 0, 0);
907                 }
908 
909                 // borrow effect
910                 // sumBorrowPlusEffects += oraclePrice * borrowAmount
911                 (mErr, vars.sumBorrowPlusEffects) = mulScalarTruncateAddUInt(
912                     vars.oraclePrice,
913                     borrowAmount,
914                     vars.sumBorrowPlusEffects
915                 );
916                 if (mErr != MathError.NO_ERROR) {
917                     return (Error.MATH_ERROR, 0, 0);
918                 }
919             }
920         }
921 
922         // These are safe, as the underflow condition is checked first
923         if (vars.sumCollateral > vars.sumBorrowPlusEffects) {
924             return (Error.NO_ERROR, vars.sumCollateral - vars.sumBorrowPlusEffects, 0);
925         } else {
926             return (Error.NO_ERROR, 0, vars.sumBorrowPlusEffects - vars.sumCollateral);
927         }
928     }
929 
930     /**
931      * @notice Calculate number of tokens of collateral asset to seize given an underlying amount
932      * @dev Used in liquidation (called in cToken.liquidateBorrowFresh)
933      * @param cTokenBorrowed The address of the borrowed cToken
934      * @param cTokenCollateral The address of the collateral cToken
935      * @param actualRepayAmount The amount of cTokenBorrowed underlying to convert into cTokenCollateral tokens
936      * @return (errorCode, number of cTokenCollateral tokens to be seized in a liquidation)
937      */
938     function liquidateCalculateSeizeTokens(
939         address cTokenBorrowed,
940         address cTokenCollateral,
941         uint256 actualRepayAmount
942     ) external view returns (uint256, uint256) {
943         /* Read oracle prices for borrowed and collateral markets */
944         uint256 priceBorrowedMantissa = oracle.getUnderlyingPrice(CToken(cTokenBorrowed));
945         uint256 priceCollateralMantissa = oracle.getUnderlyingPrice(CToken(cTokenCollateral));
946         if (priceBorrowedMantissa == 0 || priceCollateralMantissa == 0) {
947             return (uint256(Error.PRICE_ERROR), 0);
948         }
949 
950         /*
951          * Get the exchange rate and calculate the number of collateral tokens to seize:
952          *  seizeAmount = actualRepayAmount * liquidationIncentive * priceBorrowed / priceCollateral
953          *  seizeTokens = seizeAmount / exchangeRate
954          *   = actualRepayAmount * (liquidationIncentive * priceBorrowed) / (priceCollateral * exchangeRate)
955          */
956         uint256 exchangeRateMantissa = CToken(cTokenCollateral).exchangeRateStored(); // Note: reverts on error
957         uint256 seizeTokens;
958         Exp memory numerator;
959         Exp memory denominator;
960         Exp memory ratio;
961         MathError mathErr;
962 
963         (mathErr, numerator) = mulExp(liquidationIncentiveMantissa, priceBorrowedMantissa);
964         if (mathErr != MathError.NO_ERROR) {
965             return (uint256(Error.MATH_ERROR), 0);
966         }
967 
968         (mathErr, denominator) = mulExp(priceCollateralMantissa, exchangeRateMantissa);
969         if (mathErr != MathError.NO_ERROR) {
970             return (uint256(Error.MATH_ERROR), 0);
971         }
972 
973         (mathErr, ratio) = divExp(numerator, denominator);
974         if (mathErr != MathError.NO_ERROR) {
975             return (uint256(Error.MATH_ERROR), 0);
976         }
977 
978         (mathErr, seizeTokens) = mulScalarTruncate(ratio, actualRepayAmount);
979         if (mathErr != MathError.NO_ERROR) {
980             return (uint256(Error.MATH_ERROR), 0);
981         }
982 
983         return (uint256(Error.NO_ERROR), seizeTokens);
984     }
985 
986     /*** Admin Functions ***/
987 
988     /**
989      * @notice Sets a new price oracle for the comptroller
990      * @dev Admin function to set a new price oracle
991      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
992      */
993     function _setPriceOracle(PriceOracle newOracle) public returns (uint256) {
994         // Check caller is admin
995         if (msg.sender != admin) {
996             return fail(Error.UNAUTHORIZED, FailureInfo.SET_PRICE_ORACLE_OWNER_CHECK);
997         }
998 
999         // Track the old oracle for the comptroller
1000         PriceOracle oldOracle = oracle;
1001 
1002         // Set comptroller's oracle to newOracle
1003         oracle = newOracle;
1004 
1005         // Emit NewPriceOracle(oldOracle, newOracle)
1006         emit NewPriceOracle(oldOracle, newOracle);
1007 
1008         return uint256(Error.NO_ERROR);
1009     }
1010 
1011     /**
1012      * @notice Sets the closeFactor used when liquidating borrows
1013      * @dev Admin function to set closeFactor
1014      * @param newCloseFactorMantissa New close factor, scaled by 1e18
1015      * @return uint 0=success, otherwise a failure. (See ErrorReporter for details)
1016      */
1017     function _setCloseFactor(uint256 newCloseFactorMantissa) external returns (uint256) {
1018         // Check caller is admin
1019         if (msg.sender != admin) {
1020             return fail(Error.UNAUTHORIZED, FailureInfo.SET_CLOSE_FACTOR_OWNER_CHECK);
1021         }
1022 
1023         Exp memory newCloseFactorExp = Exp({mantissa: newCloseFactorMantissa});
1024         Exp memory lowLimit = Exp({mantissa: closeFactorMinMantissa});
1025         if (lessThanOrEqualExp(newCloseFactorExp, lowLimit)) {
1026             return fail(Error.INVALID_CLOSE_FACTOR, FailureInfo.SET_CLOSE_FACTOR_VALIDATION);
1027         }
1028 
1029         Exp memory highLimit = Exp({mantissa: closeFactorMaxMantissa});
1030         if (lessThanExp(highLimit, newCloseFactorExp)) {
1031             return fail(Error.INVALID_CLOSE_FACTOR, FailureInfo.SET_CLOSE_FACTOR_VALIDATION);
1032         }
1033 
1034         uint256 oldCloseFactorMantissa = closeFactorMantissa;
1035         closeFactorMantissa = newCloseFactorMantissa;
1036         emit NewCloseFactor(oldCloseFactorMantissa, closeFactorMantissa);
1037 
1038         return uint256(Error.NO_ERROR);
1039     }
1040 
1041     /**
1042      * @notice Sets the collateralFactor for a market
1043      * @dev Admin function to set per-market collateralFactor
1044      * @param cToken The market to set the factor on
1045      * @param newCollateralFactorMantissa The new collateral factor, scaled by 1e18
1046      * @return uint 0=success, otherwise a failure. (See ErrorReporter for details)
1047      */
1048     function _setCollateralFactor(CToken cToken, uint256 newCollateralFactorMantissa) external returns (uint256) {
1049         // Check caller is admin
1050         if (msg.sender != admin) {
1051             return fail(Error.UNAUTHORIZED, FailureInfo.SET_COLLATERAL_FACTOR_OWNER_CHECK);
1052         }
1053 
1054         // Verify market is listed
1055         Market storage market = markets[address(cToken)];
1056         if (!market.isListed) {
1057             return fail(Error.MARKET_NOT_LISTED, FailureInfo.SET_COLLATERAL_FACTOR_NO_EXISTS);
1058         }
1059 
1060         Exp memory newCollateralFactorExp = Exp({mantissa: newCollateralFactorMantissa});
1061 
1062         // Check collateral factor <= 0.9
1063         Exp memory highLimit = Exp({mantissa: collateralFactorMaxMantissa});
1064         if (lessThanExp(highLimit, newCollateralFactorExp)) {
1065             return fail(Error.INVALID_COLLATERAL_FACTOR, FailureInfo.SET_COLLATERAL_FACTOR_VALIDATION);
1066         }
1067 
1068         // If collateral factor != 0, fail if price == 0
1069         if (newCollateralFactorMantissa != 0 && oracle.getUnderlyingPrice(cToken) == 0) {
1070             return fail(Error.PRICE_ERROR, FailureInfo.SET_COLLATERAL_FACTOR_WITHOUT_PRICE);
1071         }
1072 
1073         // Set market's collateral factor to new collateral factor, remember old value
1074         uint256 oldCollateralFactorMantissa = market.collateralFactorMantissa;
1075         market.collateralFactorMantissa = newCollateralFactorMantissa;
1076 
1077         // Emit event with asset, old collateral factor, and new collateral factor
1078         emit NewCollateralFactor(cToken, oldCollateralFactorMantissa, newCollateralFactorMantissa);
1079 
1080         return uint256(Error.NO_ERROR);
1081     }
1082 
1083     /**
1084      * @notice Sets maxAssets which controls how many markets can be entered
1085      * @dev Admin function to set maxAssets
1086      * @param newMaxAssets New max assets
1087      * @return uint 0=success, otherwise a failure. (See ErrorReporter for details)
1088      */
1089     function _setMaxAssets(uint256 newMaxAssets) external returns (uint256) {
1090         // Check caller is admin
1091         if (msg.sender != admin) {
1092             return fail(Error.UNAUTHORIZED, FailureInfo.SET_MAX_ASSETS_OWNER_CHECK);
1093         }
1094 
1095         uint256 oldMaxAssets = maxAssets;
1096         maxAssets = newMaxAssets;
1097         emit NewMaxAssets(oldMaxAssets, newMaxAssets);
1098 
1099         return uint256(Error.NO_ERROR);
1100     }
1101 
1102     /**
1103      * @notice Sets liquidationIncentive
1104      * @dev Admin function to set liquidationIncentive
1105      * @param newLiquidationIncentiveMantissa New liquidationIncentive scaled by 1e18
1106      * @return uint 0=success, otherwise a failure. (See ErrorReporter for details)
1107      */
1108     function _setLiquidationIncentive(uint256 newLiquidationIncentiveMantissa) external returns (uint256) {
1109         // Check caller is admin
1110         if (msg.sender != admin) {
1111             return fail(Error.UNAUTHORIZED, FailureInfo.SET_LIQUIDATION_INCENTIVE_OWNER_CHECK);
1112         }
1113 
1114         // Check de-scaled min <= newLiquidationIncentive <= max
1115         Exp memory newLiquidationIncentive = Exp({mantissa: newLiquidationIncentiveMantissa});
1116         Exp memory minLiquidationIncentive = Exp({mantissa: liquidationIncentiveMinMantissa});
1117         if (lessThanExp(newLiquidationIncentive, minLiquidationIncentive)) {
1118             return fail(Error.INVALID_LIQUIDATION_INCENTIVE, FailureInfo.SET_LIQUIDATION_INCENTIVE_VALIDATION);
1119         }
1120 
1121         Exp memory maxLiquidationIncentive = Exp({mantissa: liquidationIncentiveMaxMantissa});
1122         if (lessThanExp(maxLiquidationIncentive, newLiquidationIncentive)) {
1123             return fail(Error.INVALID_LIQUIDATION_INCENTIVE, FailureInfo.SET_LIQUIDATION_INCENTIVE_VALIDATION);
1124         }
1125 
1126         // Save current value for use in log
1127         uint256 oldLiquidationIncentiveMantissa = liquidationIncentiveMantissa;
1128 
1129         // Set liquidation incentive to new incentive
1130         liquidationIncentiveMantissa = newLiquidationIncentiveMantissa;
1131 
1132         // Emit event with old incentive, new incentive
1133         emit NewLiquidationIncentive(oldLiquidationIncentiveMantissa, newLiquidationIncentiveMantissa);
1134 
1135         return uint256(Error.NO_ERROR);
1136     }
1137 
1138     /**
1139      * @notice Add the market to the markets mapping and set it as listed
1140      * @dev Admin function to set isListed and add support for the market
1141      * @param cToken The address of the market (token) to list
1142      * @return uint 0=success, otherwise a failure. (See enum Error for details)
1143      */
1144     function _supportMarket(CToken cToken) external returns (uint256) {
1145         if (msg.sender != admin) {
1146             return fail(Error.UNAUTHORIZED, FailureInfo.SUPPORT_MARKET_OWNER_CHECK);
1147         }
1148 
1149         if (markets[address(cToken)].isListed) {
1150             return fail(Error.MARKET_ALREADY_LISTED, FailureInfo.SUPPORT_MARKET_EXISTS);
1151         }
1152 
1153         cToken.isCToken(); // Sanity check to make sure its really a CToken
1154 
1155         markets[address(cToken)] = Market({
1156             isListed: true,
1157             isComped: false,
1158             collateralFactorMantissa: 0,
1159             version: Version.VANILLA
1160         });
1161 
1162         _addMarketInternal(address(cToken));
1163 
1164         emit MarketListed(cToken);
1165 
1166         return uint256(Error.NO_ERROR);
1167     }
1168 
1169     function _addMarketInternal(address cToken) internal {
1170         for (uint256 i = 0; i < allMarkets.length; i++) {
1171             require(allMarkets[i] != CToken(cToken), "market already added");
1172         }
1173         allMarkets.push(CToken(cToken));
1174     }
1175 
1176     /**
1177      * @notice Set the given borrow caps for the given cToken markets. Borrowing that brings total borrows to or above borrow cap will revert.
1178      * @dev Admin or borrowCapGuardian function to set the borrow caps. A borrow cap of 0 corresponds to unlimited borrowing.
1179      * @param cTokens The addresses of the markets (tokens) to change the borrow caps for
1180      * @param newBorrowCaps The new borrow cap values in underlying to be set. A value of 0 corresponds to unlimited borrowing.
1181      */
1182     function _setMarketBorrowCaps(CToken[] calldata cTokens, uint256[] calldata newBorrowCaps) external {
1183         require(
1184             msg.sender == admin || msg.sender == borrowCapGuardian,
1185             "only admin or borrow cap guardian can set borrow caps"
1186         );
1187 
1188         uint256 numMarkets = cTokens.length;
1189         uint256 numBorrowCaps = newBorrowCaps.length;
1190 
1191         require(numMarkets != 0 && numMarkets == numBorrowCaps, "invalid input");
1192 
1193         for (uint256 i = 0; i < numMarkets; i++) {
1194             borrowCaps[address(cTokens[i])] = newBorrowCaps[i];
1195             emit NewBorrowCap(cTokens[i], newBorrowCaps[i]);
1196         }
1197     }
1198 
1199     /**
1200      * @notice Admin function to change the Borrow Cap Guardian
1201      * @param newBorrowCapGuardian The address of the new Borrow Cap Guardian
1202      */
1203     function _setBorrowCapGuardian(address newBorrowCapGuardian) external {
1204         require(msg.sender == admin, "only admin can set borrow cap guardian");
1205 
1206         // Save current value for inclusion in log
1207         address oldBorrowCapGuardian = borrowCapGuardian;
1208 
1209         // Store borrowCapGuardian with value newBorrowCapGuardian
1210         borrowCapGuardian = newBorrowCapGuardian;
1211 
1212         // Emit NewBorrowCapGuardian(OldBorrowCapGuardian, NewBorrowCapGuardian)
1213         emit NewBorrowCapGuardian(oldBorrowCapGuardian, newBorrowCapGuardian);
1214     }
1215 
1216     /**
1217      * @notice Admin function to change the Pause Guardian
1218      * @param newPauseGuardian The address of the new Pause Guardian
1219      * @return uint 0=success, otherwise a failure. (See enum Error for details)
1220      */
1221     function _setPauseGuardian(address newPauseGuardian) public returns (uint256) {
1222         if (msg.sender != admin) {
1223             return fail(Error.UNAUTHORIZED, FailureInfo.SET_PAUSE_GUARDIAN_OWNER_CHECK);
1224         }
1225 
1226         // Save current value for inclusion in log
1227         address oldPauseGuardian = pauseGuardian;
1228 
1229         // Store pauseGuardian with value newPauseGuardian
1230         pauseGuardian = newPauseGuardian;
1231 
1232         // Emit NewPauseGuardian(OldPauseGuardian, NewPauseGuardian)
1233         emit NewPauseGuardian(oldPauseGuardian, pauseGuardian);
1234 
1235         return uint256(Error.NO_ERROR);
1236     }
1237 
1238     function _setMintPaused(CToken cToken, bool state) public returns (bool) {
1239         require(markets[address(cToken)].isListed, "cannot pause a market that is not listed");
1240         require(msg.sender == pauseGuardian || msg.sender == admin, "only pause guardian and admin can pause");
1241         require(msg.sender == admin || state == true, "only admin can unpause");
1242 
1243         mintGuardianPaused[address(cToken)] = state;
1244         emit ActionPaused(cToken, "Mint", state);
1245         return state;
1246     }
1247 
1248     function _setBorrowPaused(CToken cToken, bool state) public returns (bool) {
1249         require(markets[address(cToken)].isListed, "cannot pause a market that is not listed");
1250         require(msg.sender == pauseGuardian || msg.sender == admin, "only pause guardian and admin can pause");
1251         require(msg.sender == admin || state == true, "only admin can unpause");
1252 
1253         borrowGuardianPaused[address(cToken)] = state;
1254         emit ActionPaused(cToken, "Borrow", state);
1255         return state;
1256     }
1257 
1258     function _setTransferPaused(bool state) public returns (bool) {
1259         require(msg.sender == pauseGuardian || msg.sender == admin, "only pause guardian and admin can pause");
1260         require(msg.sender == admin || state == true, "only admin can unpause");
1261 
1262         transferGuardianPaused = state;
1263         emit ActionPaused("Transfer", state);
1264         return state;
1265     }
1266 
1267     function _setSeizePaused(bool state) public returns (bool) {
1268         require(msg.sender == pauseGuardian || msg.sender == admin, "only pause guardian and admin can pause");
1269         require(msg.sender == admin || state == true, "only admin can unpause");
1270 
1271         seizeGuardianPaused = state;
1272         emit ActionPaused("Seize", state);
1273         return state;
1274     }
1275 
1276     function _become(Unitroller unitroller) public {
1277         require(msg.sender == unitroller.admin(), "only unitroller admin can change brains");
1278         require(unitroller._acceptImplementation() == 0, "change not authorized");
1279     }
1280 
1281     /**
1282      * @notice Checks caller is admin, or this contract is becoming the new implementation
1283      */
1284     function adminOrInitializing() internal view returns (bool) {
1285         return msg.sender == admin || msg.sender == comptrollerImplementation;
1286     }
1287 
1288     /*** Comp Distribution ***/
1289 
1290     /**
1291      * @notice Recalculate and update COMP speeds for all COMP markets
1292      */
1293     function refreshCompSpeeds() public {
1294         require(msg.sender == tx.origin, "only externally owned accounts may refresh speeds");
1295         refreshCompSpeedsInternal();
1296     }
1297 
1298     function refreshCompSpeedsInternal() internal {
1299         CToken[] memory allMarkets_ = allMarkets;
1300 
1301         for (uint256 i = 0; i < allMarkets_.length; i++) {
1302             CToken cToken = allMarkets_[i];
1303             Exp memory borrowIndex = Exp({mantissa: cToken.borrowIndex()});
1304             updateCompSupplyIndex(address(cToken));
1305             updateCompBorrowIndex(address(cToken), borrowIndex);
1306         }
1307 
1308         Exp memory totalUtility = Exp({mantissa: 0});
1309         Exp[] memory utilities = new Exp[](allMarkets_.length);
1310         for (uint256 i = 0; i < allMarkets_.length; i++) {
1311             CToken cToken = allMarkets_[i];
1312             if (markets[address(cToken)].isComped) {
1313                 Exp memory assetPrice = Exp({mantissa: oracle.getUnderlyingPrice(cToken)});
1314                 Exp memory utility = mul_(assetPrice, cToken.totalBorrows());
1315                 utilities[i] = utility;
1316                 totalUtility = add_(totalUtility, utility);
1317             }
1318         }
1319 
1320         for (uint256 i = 0; i < allMarkets_.length; i++) {
1321             CToken cToken = allMarkets[i];
1322             uint256 newSpeed = totalUtility.mantissa > 0 ? mul_(compRate, div_(utilities[i], totalUtility)) : 0;
1323             compSpeeds[address(cToken)] = newSpeed;
1324             emit CompSpeedUpdated(cToken, newSpeed);
1325         }
1326     }
1327 
1328     /**
1329      * @notice Accrue COMP to the market by updating the supply index
1330      * @param cToken The market whose supply index to update
1331      */
1332     function updateCompSupplyIndex(address cToken) internal {
1333         CompMarketState storage supplyState = compSupplyState[cToken];
1334         uint256 supplySpeed = compSpeeds[cToken];
1335         uint256 blockNumber = getBlockNumber();
1336         uint256 deltaBlocks = sub_(blockNumber, uint256(supplyState.block));
1337         if (deltaBlocks > 0 && supplySpeed > 0) {
1338             uint256 supplyTokens = CToken(cToken).totalSupply();
1339             uint256 compAccrued = mul_(deltaBlocks, supplySpeed);
1340             Double memory ratio = supplyTokens > 0 ? fraction(compAccrued, supplyTokens) : Double({mantissa: 0});
1341             Double memory index = add_(Double({mantissa: supplyState.index}), ratio);
1342             compSupplyState[cToken] = CompMarketState({
1343                 index: safe224(index.mantissa, "new index exceeds 224 bits"),
1344                 block: safe32(blockNumber, "block number exceeds 32 bits")
1345             });
1346         } else if (deltaBlocks > 0) {
1347             supplyState.block = safe32(blockNumber, "block number exceeds 32 bits");
1348         }
1349     }
1350 
1351     /**
1352      * @notice Accrue COMP to the market by updating the borrow index
1353      * @param cToken The market whose borrow index to update
1354      */
1355     function updateCompBorrowIndex(address cToken, Exp memory marketBorrowIndex) internal {
1356         CompMarketState storage borrowState = compBorrowState[cToken];
1357         uint256 borrowSpeed = compSpeeds[cToken];
1358         uint256 blockNumber = getBlockNumber();
1359         uint256 deltaBlocks = sub_(blockNumber, uint256(borrowState.block));
1360         if (deltaBlocks > 0 && borrowSpeed > 0) {
1361             uint256 borrowAmount = div_(CToken(cToken).totalBorrows(), marketBorrowIndex);
1362             uint256 compAccrued = mul_(deltaBlocks, borrowSpeed);
1363             Double memory ratio = borrowAmount > 0 ? fraction(compAccrued, borrowAmount) : Double({mantissa: 0});
1364             Double memory index = add_(Double({mantissa: borrowState.index}), ratio);
1365             compBorrowState[cToken] = CompMarketState({
1366                 index: safe224(index.mantissa, "new index exceeds 224 bits"),
1367                 block: safe32(blockNumber, "block number exceeds 32 bits")
1368             });
1369         } else if (deltaBlocks > 0) {
1370             borrowState.block = safe32(blockNumber, "block number exceeds 32 bits");
1371         }
1372     }
1373 
1374     /**
1375      * @notice Calculate COMP accrued by a supplier and possibly transfer it to them
1376      * @param cToken The market in which the supplier is interacting
1377      * @param supplier The address of the supplier to distribute COMP to
1378      */
1379     function distributeSupplierComp(
1380         address cToken,
1381         address supplier,
1382         bool distributeAll
1383     ) internal {
1384         CompMarketState storage supplyState = compSupplyState[cToken];
1385         Double memory supplyIndex = Double({mantissa: supplyState.index});
1386         Double memory supplierIndex = Double({mantissa: compSupplierIndex[cToken][supplier]});
1387         compSupplierIndex[cToken][supplier] = supplyIndex.mantissa;
1388 
1389         if (supplierIndex.mantissa == 0 && supplyIndex.mantissa > 0) {
1390             supplierIndex.mantissa = compInitialIndex;
1391         }
1392 
1393         Double memory deltaIndex = sub_(supplyIndex, supplierIndex);
1394         uint256 supplierTokens = CToken(cToken).balanceOf(supplier);
1395         uint256 supplierDelta = mul_(supplierTokens, deltaIndex);
1396         uint256 supplierAccrued = add_(compAccrued[supplier], supplierDelta);
1397         compAccrued[supplier] = transferComp(supplier, supplierAccrued, distributeAll ? 0 : compClaimThreshold);
1398         emit DistributedSupplierComp(CToken(cToken), supplier, supplierDelta, supplyIndex.mantissa);
1399     }
1400 
1401     /**
1402      * @notice Calculate COMP accrued by a borrower and possibly transfer it to them
1403      * @dev Borrowers will not begin to accrue until after the first interaction with the protocol.
1404      * @param cToken The market in which the borrower is interacting
1405      * @param borrower The address of the borrower to distribute COMP to
1406      */
1407     function distributeBorrowerComp(
1408         address cToken,
1409         address borrower,
1410         Exp memory marketBorrowIndex,
1411         bool distributeAll
1412     ) internal {
1413         CompMarketState storage borrowState = compBorrowState[cToken];
1414         Double memory borrowIndex = Double({mantissa: borrowState.index});
1415         Double memory borrowerIndex = Double({mantissa: compBorrowerIndex[cToken][borrower]});
1416         compBorrowerIndex[cToken][borrower] = borrowIndex.mantissa;
1417 
1418         if (borrowerIndex.mantissa > 0) {
1419             Double memory deltaIndex = sub_(borrowIndex, borrowerIndex);
1420             uint256 borrowerAmount = div_(CToken(cToken).borrowBalanceStored(borrower), marketBorrowIndex);
1421             uint256 borrowerDelta = mul_(borrowerAmount, deltaIndex);
1422             uint256 borrowerAccrued = add_(compAccrued[borrower], borrowerDelta);
1423             compAccrued[borrower] = transferComp(borrower, borrowerAccrued, distributeAll ? 0 : compClaimThreshold);
1424             emit DistributedBorrowerComp(CToken(cToken), borrower, borrowerDelta, borrowIndex.mantissa);
1425         }
1426     }
1427 
1428     /**
1429      * @notice Transfer COMP to the user, if they are above the threshold
1430      * @dev Note: If there is not enough COMP, we do not perform the transfer all.
1431      * @param user The address of the user to transfer COMP to
1432      * @param userAccrued The amount of COMP to (possibly) transfer
1433      * @return The amount of COMP which was NOT transferred to the user
1434      */
1435     function transferComp(
1436         address user,
1437         uint256 userAccrued,
1438         uint256 threshold
1439     ) internal returns (uint256) {
1440         if (userAccrued >= threshold && userAccrued > 0) {
1441             Comp comp = Comp(getCompAddress());
1442             uint256 compRemaining = comp.balanceOf(address(this));
1443             if (userAccrued <= compRemaining) {
1444                 comp.transfer(user, userAccrued);
1445                 return 0;
1446             }
1447         }
1448         return userAccrued;
1449     }
1450 
1451     /**
1452      * @notice Claim all the comp accrued by holder in all markets
1453      * @param holder The address to claim COMP for
1454      */
1455     function claimComp(address holder) public {
1456         return claimComp(holder, allMarkets);
1457     }
1458 
1459     /**
1460      * @notice Claim all the comp accrued by holder in the specified markets
1461      * @param holder The address to claim COMP for
1462      * @param cTokens The list of markets to claim COMP in
1463      */
1464     function claimComp(address holder, CToken[] memory cTokens) public {
1465         address[] memory holders = new address[](1);
1466         holders[0] = holder;
1467         claimComp(holders, cTokens, true, true);
1468     }
1469 
1470     /**
1471      * @notice Claim all comp accrued by the holders
1472      * @param holders The addresses to claim COMP for
1473      * @param cTokens The list of markets to claim COMP in
1474      * @param borrowers Whether or not to claim COMP earned by borrowing
1475      * @param suppliers Whether or not to claim COMP earned by supplying
1476      */
1477     function claimComp(
1478         address[] memory holders,
1479         CToken[] memory cTokens,
1480         bool borrowers,
1481         bool suppliers
1482     ) public {
1483         for (uint256 i = 0; i < cTokens.length; i++) {
1484             CToken cToken = cTokens[i];
1485             require(markets[address(cToken)].isListed, "market must be listed");
1486             if (borrowers == true) {
1487                 Exp memory borrowIndex = Exp({mantissa: cToken.borrowIndex()});
1488                 updateCompBorrowIndex(address(cToken), borrowIndex);
1489                 for (uint256 j = 0; j < holders.length; j++) {
1490                     distributeBorrowerComp(address(cToken), holders[j], borrowIndex, true);
1491                 }
1492             }
1493             if (suppliers == true) {
1494                 updateCompSupplyIndex(address(cToken));
1495                 for (uint256 j = 0; j < holders.length; j++) {
1496                     distributeSupplierComp(address(cToken), holders[j], true);
1497                 }
1498             }
1499         }
1500     }
1501 
1502     /*** Comp Distribution Admin ***/
1503 
1504     /**
1505      * @notice Set the amount of COMP distributed per block
1506      * @param compRate_ The amount of COMP wei per block to distribute
1507      */
1508     function _setCompRate(uint256 compRate_) public {
1509         require(adminOrInitializing(), "only admin can change comp rate");
1510 
1511         uint256 oldRate = compRate;
1512         compRate = compRate_;
1513         emit NewCompRate(oldRate, compRate_);
1514 
1515         refreshCompSpeedsInternal();
1516     }
1517 
1518     /**
1519      * @notice Add markets to compMarkets, allowing them to earn COMP in the flywheel
1520      * @param cTokens The addresses of the markets to add
1521      */
1522     function _addCompMarkets(address[] memory cTokens) public {
1523         require(adminOrInitializing(), "only admin can add comp market");
1524 
1525         for (uint256 i = 0; i < cTokens.length; i++) {
1526             _addCompMarketInternal(cTokens[i]);
1527         }
1528 
1529         refreshCompSpeedsInternal();
1530     }
1531 
1532     function _addCompMarketInternal(address cToken) internal {
1533         Market storage market = markets[cToken];
1534         require(market.isListed == true, "comp market is not listed");
1535         require(market.isComped == false, "comp market already added");
1536 
1537         market.isComped = true;
1538         emit MarketComped(CToken(cToken), true);
1539 
1540         if (compSupplyState[cToken].index == 0 && compSupplyState[cToken].block == 0) {
1541             compSupplyState[cToken] = CompMarketState({
1542                 index: compInitialIndex,
1543                 block: safe32(getBlockNumber(), "block number exceeds 32 bits")
1544             });
1545         }
1546 
1547         if (compBorrowState[cToken].index == 0 && compBorrowState[cToken].block == 0) {
1548             compBorrowState[cToken] = CompMarketState({
1549                 index: compInitialIndex,
1550                 block: safe32(getBlockNumber(), "block number exceeds 32 bits")
1551             });
1552         }
1553     }
1554 
1555     /**
1556      * @notice Remove a market from compMarkets, preventing it from earning COMP in the flywheel
1557      * @param cToken The address of the market to drop
1558      */
1559     function _dropCompMarket(address cToken) public {
1560         require(msg.sender == admin, "only admin can drop comp market");
1561 
1562         Market storage market = markets[cToken];
1563         require(market.isComped == true, "market is not a comp market");
1564 
1565         market.isComped = false;
1566         emit MarketComped(CToken(cToken), false);
1567 
1568         refreshCompSpeedsInternal();
1569     }
1570 
1571     /**
1572      * @notice Return all of the markets
1573      * @dev The automatic getter may be used to access an individual market.
1574      * @return The list of market addresses
1575      */
1576     function getAllMarkets() public view returns (CToken[] memory) {
1577         return allMarkets;
1578     }
1579 
1580     function getBlockNumber() public view returns (uint256) {
1581         return block.number;
1582     }
1583 
1584     /**
1585      * @notice Return the address of the COMP token
1586      * @return The address of COMP
1587      */
1588     function getCompAddress() public view returns (address) {
1589         return 0x2ba592F78dB6436527729929AAf6c908497cB200;
1590     }
1591 }
