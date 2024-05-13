1 pragma solidity ^0.5.16;
2 
3 import "../CToken.sol";
4 import "../ErrorReporter.sol";
5 import "../Exponential.sol";
6 import "../PriceOracle/PriceOracle.sol";
7 import "../ComptrollerInterface.sol";
8 import "../ComptrollerStorage.sol";
9 import "../Unitroller.sol";
10 
11 /**
12  * @title Compound's Comptroller Contract
13  * @author Compound
14  */
15 contract ComptrollerG2 is ComptrollerV2Storage, ComptrollerInterface, ComptrollerErrorReporter, Exponential {
16     /**
17      * @notice Emitted when an admin supports a market
18      */
19     event MarketListed(CToken cToken);
20 
21     /**
22      * @notice Emitted when an account enters a market
23      */
24     event MarketEntered(CToken cToken, address account);
25 
26     /**
27      * @notice Emitted when an account exits a market
28      */
29     event MarketExited(CToken cToken, address account);
30 
31     /**
32      * @notice Emitted when close factor is changed by admin
33      */
34     event NewCloseFactor(uint256 oldCloseFactorMantissa, uint256 newCloseFactorMantissa);
35 
36     /**
37      * @notice Emitted when a collateral factor is changed by admin
38      */
39     event NewCollateralFactor(CToken cToken, uint256 oldCollateralFactorMantissa, uint256 newCollateralFactorMantissa);
40 
41     /**
42      * @notice Emitted when liquidation incentive is changed by admin
43      */
44     event NewLiquidationIncentive(uint256 oldLiquidationIncentiveMantissa, uint256 newLiquidationIncentiveMantissa);
45 
46     /**
47      * @notice Emitted when maxAssets is changed by admin
48      */
49     event NewMaxAssets(uint256 oldMaxAssets, uint256 newMaxAssets);
50 
51     /**
52      * @notice Emitted when price oracle is changed
53      */
54     event NewPriceOracle(PriceOracle oldPriceOracle, PriceOracle newPriceOracle);
55 
56     /**
57      * @notice Emitted when pause guardian is changed
58      */
59     event NewPauseGuardian(address oldPauseGuardian, address newPauseGuardian);
60 
61     /**
62      * @notice Emitted when an action is paused globally
63      */
64     event ActionPaused(string action, bool pauseState);
65 
66     /**
67      * @notice Emitted when an action is paused on a market
68      */
69     event ActionPaused(CToken cToken, string action, bool pauseState);
70 
71     // closeFactorMantissa must be strictly greater than this value
72     uint256 internal constant closeFactorMinMantissa = 0.05e18; // 0.05
73 
74     // closeFactorMantissa must not exceed this value
75     uint256 internal constant closeFactorMaxMantissa = 0.9e18; // 0.9
76 
77     // No collateralFactorMantissa may exceed this value
78     uint256 internal constant collateralFactorMaxMantissa = 0.9e18; // 0.9
79 
80     // liquidationIncentiveMantissa must be no less than this value
81     uint256 internal constant liquidationIncentiveMinMantissa = 1.0e18; // 1.0
82 
83     // liquidationIncentiveMantissa must be no greater than this value
84     uint256 internal constant liquidationIncentiveMaxMantissa = 1.5e18; // 1.5
85 
86     constructor() public {
87         admin = msg.sender;
88     }
89 
90     /*** Assets You Are In ***/
91 
92     /**
93      * @notice Returns the assets an account has entered
94      * @param account The address of the account to pull assets for
95      * @return A dynamic list with the assets the account has entered
96      */
97     function getAssetsIn(address account) external view returns (CToken[] memory) {
98         CToken[] memory assetsIn = accountAssets[account];
99 
100         return assetsIn;
101     }
102 
103     /**
104      * @notice Returns whether the given account is entered in the given asset
105      * @param account The address of the account to check
106      * @param cToken The cToken to check
107      * @return True if the account is in the asset, otherwise false.
108      */
109     function checkMembership(address account, CToken cToken) external view returns (bool) {
110         return markets[address(cToken)].accountMembership[account];
111     }
112 
113     /**
114      * @notice Add assets to be included in account liquidity calculation
115      * @param cTokens The list of addresses of the cToken markets to be enabled
116      * @return Success indicator for whether each corresponding market was entered
117      */
118     function enterMarkets(address[] memory cTokens) public returns (uint256[] memory) {
119         uint256 len = cTokens.length;
120 
121         uint256[] memory results = new uint256[](len);
122         for (uint256 i = 0; i < len; i++) {
123             CToken cToken = CToken(cTokens[i]);
124 
125             results[i] = uint256(addToMarketInternal(cToken, msg.sender));
126         }
127 
128         return results;
129     }
130 
131     /**
132      * @notice Add the market to the borrower's "assets in" for liquidity calculations
133      * @param cToken The market to enter
134      * @param borrower The address of the account to modify
135      * @return Success indicator for whether the market was entered
136      */
137     function addToMarketInternal(CToken cToken, address borrower) internal returns (Error) {
138         Market storage marketToJoin = markets[address(cToken)];
139 
140         if (!marketToJoin.isListed) {
141             // market is not listed, cannot join
142             return Error.MARKET_NOT_LISTED;
143         }
144 
145         if (marketToJoin.accountMembership[borrower] == true) {
146             // already joined
147             return Error.NO_ERROR;
148         }
149 
150         if (accountAssets[borrower].length >= maxAssets) {
151             // no space, cannot join
152             return Error.TOO_MANY_ASSETS;
153         }
154 
155         // survived the gauntlet, add to list
156         // NOTE: we store these somewhat redundantly as a significant optimization
157         //  this avoids having to iterate through the list for the most common use cases
158         //  that is, only when we need to perform liquidity checks
159         //  and not whenever we want to check if an account is in a particular market
160         marketToJoin.accountMembership[borrower] = true;
161         accountAssets[borrower].push(cToken);
162 
163         emit MarketEntered(cToken, borrower);
164 
165         return Error.NO_ERROR;
166     }
167 
168     /**
169      * @notice Removes asset from sender's account liquidity calculation
170      * @dev Sender must not have an outstanding borrow balance in the asset,
171      *  or be providing neccessary collateral for an outstanding borrow.
172      * @param cTokenAddress The address of the asset to be removed
173      * @return Whether or not the account successfully exited the market
174      */
175     function exitMarket(address cTokenAddress) external returns (uint256) {
176         CToken cToken = CToken(cTokenAddress);
177         /* Get sender tokensHeld and amountOwed underlying from the cToken */
178         (uint256 oErr, uint256 tokensHeld, uint256 amountOwed, ) = cToken.getAccountSnapshot(msg.sender);
179         require(oErr == 0, "exitMarket: getAccountSnapshot failed"); // semi-opaque error code
180 
181         /* Fail if the sender has a borrow balance */
182         if (amountOwed != 0) {
183             return fail(Error.NONZERO_BORROW_BALANCE, FailureInfo.EXIT_MARKET_BALANCE_OWED);
184         }
185 
186         /* Fail if the sender is not permitted to redeem all of their tokens */
187         uint256 allowed = redeemAllowedInternal(cTokenAddress, msg.sender, tokensHeld);
188         if (allowed != 0) {
189             return failOpaque(Error.REJECTION, FailureInfo.EXIT_MARKET_REJECTION, allowed);
190         }
191 
192         Market storage marketToExit = markets[address(cToken)];
193 
194         /* Return true if the sender is not already ‘in’ the market */
195         if (!marketToExit.accountMembership[msg.sender]) {
196             return uint256(Error.NO_ERROR);
197         }
198 
199         /* Set cToken account membership to false */
200         delete marketToExit.accountMembership[msg.sender];
201 
202         /* Delete cToken from the account’s list of assets */
203         // load into memory for faster iteration
204         CToken[] memory userAssetList = accountAssets[msg.sender];
205         uint256 len = userAssetList.length;
206         uint256 assetIndex = len;
207         for (uint256 i = 0; i < len; i++) {
208             if (userAssetList[i] == cToken) {
209                 assetIndex = i;
210                 break;
211             }
212         }
213 
214         // We *must* have found the asset in the list or our redundant data structure is broken
215         assert(assetIndex < len);
216 
217         // copy last item in list to location of item to be removed, reduce length by 1
218         CToken[] storage storedList = accountAssets[msg.sender];
219         storedList[assetIndex] = storedList[storedList.length - 1];
220         storedList.length--;
221 
222         emit MarketExited(cToken, msg.sender);
223 
224         return uint256(Error.NO_ERROR);
225     }
226 
227     /*** Policy Hooks ***/
228 
229     /**
230      * @notice Checks if the account should be allowed to mint tokens in the given market
231      * @param cToken The market to verify the mint against
232      * @param minter The account which would get the minted tokens
233      * @param mintAmount The amount of underlying being supplied to the market in exchange for tokens
234      * @return 0 if the mint is allowed, otherwise a semi-opaque error code (See ErrorReporter.sol)
235      */
236     function mintAllowed(
237         address cToken,
238         address minter,
239         uint256 mintAmount
240     ) external returns (uint256) {
241         // Pausing is a very serious situation - we revert to sound the alarms
242         require(!mintGuardianPaused[cToken], "mint is paused");
243 
244         // Shh - currently unused
245         minter;
246         mintAmount;
247 
248         if (!markets[cToken].isListed) {
249             return uint256(Error.MARKET_NOT_LISTED);
250         }
251 
252         // *may include Policy Hook-type checks
253 
254         return uint256(Error.NO_ERROR);
255     }
256 
257     /**
258      * @notice Validates mint and reverts on rejection. May emit logs.
259      * @param cToken Asset being minted
260      * @param minter The address minting the tokens
261      * @param actualMintAmount The amount of the underlying asset being minted
262      * @param mintTokens The number of tokens being minted
263      */
264     function mintVerify(
265         address cToken,
266         address minter,
267         uint256 actualMintAmount,
268         uint256 mintTokens
269     ) external {
270         // Shh - currently unused
271         cToken;
272         minter;
273         actualMintAmount;
274         mintTokens;
275 
276         // Shh - we don't ever want this hook to be marked pure
277         if (false) {
278             maxAssets = maxAssets;
279         }
280     }
281 
282     /**
283      * @notice Checks if the account should be allowed to redeem tokens in the given market
284      * @param cToken The market to verify the redeem against
285      * @param redeemer The account which would redeem the tokens
286      * @param redeemTokens The number of cTokens to exchange for the underlying asset in the market
287      * @return 0 if the redeem is allowed, otherwise a semi-opaque error code (See ErrorReporter.sol)
288      */
289     function redeemAllowed(
290         address cToken,
291         address redeemer,
292         uint256 redeemTokens
293     ) external returns (uint256) {
294         return redeemAllowedInternal(cToken, redeemer, redeemTokens);
295     }
296 
297     function redeemAllowedInternal(
298         address cToken,
299         address redeemer,
300         uint256 redeemTokens
301     ) internal view returns (uint256) {
302         if (!markets[cToken].isListed) {
303             return uint256(Error.MARKET_NOT_LISTED);
304         }
305 
306         // *may include Policy Hook-type checks
307 
308         /* If the redeemer is not 'in' the market, then we can bypass the liquidity check */
309         if (!markets[cToken].accountMembership[redeemer]) {
310             return uint256(Error.NO_ERROR);
311         }
312 
313         /* Otherwise, perform a hypothetical liquidity check to guard against shortfall */
314         (Error err, , uint256 shortfall) = getHypotheticalAccountLiquidityInternal(
315             redeemer,
316             CToken(cToken),
317             redeemTokens,
318             0
319         );
320         if (err != Error.NO_ERROR) {
321             return uint256(err);
322         }
323         if (shortfall > 0) {
324             return uint256(Error.INSUFFICIENT_LIQUIDITY);
325         }
326 
327         return uint256(Error.NO_ERROR);
328     }
329 
330     /**
331      * @notice Validates redeem and reverts on rejection. May emit logs.
332      * @param cToken Asset being redeemed
333      * @param redeemer The address redeeming the tokens
334      * @param redeemAmount The amount of the underlying asset being redeemed
335      * @param redeemTokens The number of tokens being redeemed
336      */
337     function redeemVerify(
338         address cToken,
339         address redeemer,
340         uint256 redeemAmount,
341         uint256 redeemTokens
342     ) external {
343         // Shh - currently unused
344         cToken;
345         redeemer;
346 
347         // Require tokens is zero or amount is also zero
348         if (redeemTokens == 0 && redeemAmount > 0) {
349             revert("redeemTokens zero");
350         }
351     }
352 
353     /**
354      * @notice Checks if the account should be allowed to borrow the underlying asset of the given market
355      * @param cToken The market to verify the borrow against
356      * @param borrower The account which would borrow the asset
357      * @param borrowAmount The amount of underlying the account would borrow
358      * @return 0 if the borrow is allowed, otherwise a semi-opaque error code (See ErrorReporter.sol)
359      */
360     function borrowAllowed(
361         address cToken,
362         address borrower,
363         uint256 borrowAmount
364     ) external returns (uint256) {
365         // Pausing is a very serious situation - we revert to sound the alarms
366         require(!borrowGuardianPaused[cToken], "borrow is paused");
367 
368         if (!markets[cToken].isListed) {
369             return uint256(Error.MARKET_NOT_LISTED);
370         }
371 
372         // *may include Policy Hook-type checks
373 
374         if (!markets[cToken].accountMembership[borrower]) {
375             // only cTokens may call borrowAllowed if borrower not in market
376             require(msg.sender == cToken, "sender must be cToken");
377 
378             // attempt to add borrower to the market
379             Error err = addToMarketInternal(CToken(msg.sender), borrower);
380             if (err != Error.NO_ERROR) {
381                 return uint256(err);
382             }
383 
384             // it should be impossible to break the important invariant
385             assert(markets[cToken].accountMembership[borrower]);
386         }
387 
388         if (oracle.getUnderlyingPrice(CToken(cToken)) == 0) {
389             return uint256(Error.PRICE_ERROR);
390         }
391 
392         (Error err, , uint256 shortfall) = getHypotheticalAccountLiquidityInternal(
393             borrower,
394             CToken(cToken),
395             0,
396             borrowAmount
397         );
398         if (err != Error.NO_ERROR) {
399             return uint256(err);
400         }
401         if (shortfall > 0) {
402             return uint256(Error.INSUFFICIENT_LIQUIDITY);
403         }
404 
405         return uint256(Error.NO_ERROR);
406     }
407 
408     /**
409      * @notice Validates borrow and reverts on rejection. May emit logs.
410      * @param cToken Asset whose underlying is being borrowed
411      * @param borrower The address borrowing the underlying
412      * @param borrowAmount The amount of the underlying asset requested to borrow
413      */
414     function borrowVerify(
415         address cToken,
416         address borrower,
417         uint256 borrowAmount
418     ) external {
419         // Shh - currently unused
420         cToken;
421         borrower;
422         borrowAmount;
423 
424         // Shh - we don't ever want this hook to be marked pure
425         if (false) {
426             maxAssets = maxAssets;
427         }
428     }
429 
430     /**
431      * @notice Checks if the account should be allowed to repay a borrow in the given market
432      * @param cToken The market to verify the repay against
433      * @param payer The account which would repay the asset
434      * @param borrower The account which would borrowed the asset
435      * @param repayAmount The amount of the underlying asset the account would repay
436      * @return 0 if the repay is allowed, otherwise a semi-opaque error code (See ErrorReporter.sol)
437      */
438     function repayBorrowAllowed(
439         address cToken,
440         address payer,
441         address borrower,
442         uint256 repayAmount
443     ) external returns (uint256) {
444         // Shh - currently unused
445         payer;
446         borrower;
447         repayAmount;
448 
449         if (!markets[cToken].isListed) {
450             return uint256(Error.MARKET_NOT_LISTED);
451         }
452 
453         // *may include Policy Hook-type checks
454 
455         return uint256(Error.NO_ERROR);
456     }
457 
458     /**
459      * @notice Validates repayBorrow and reverts on rejection. May emit logs.
460      * @param cToken Asset being repaid
461      * @param payer The address repaying the borrow
462      * @param borrower The address of the borrower
463      * @param actualRepayAmount The amount of underlying being repaid
464      */
465     function repayBorrowVerify(
466         address cToken,
467         address payer,
468         address borrower,
469         uint256 actualRepayAmount,
470         uint256 borrowerIndex
471     ) external {
472         // Shh - currently unused
473         cToken;
474         payer;
475         borrower;
476         actualRepayAmount;
477         borrowerIndex;
478 
479         // Shh - we don't ever want this hook to be marked pure
480         if (false) {
481             maxAssets = maxAssets;
482         }
483     }
484 
485     /**
486      * @notice Checks if the liquidation should be allowed to occur
487      * @param cTokenBorrowed Asset which was borrowed by the borrower
488      * @param cTokenCollateral Asset which was used as collateral and will be seized
489      * @param liquidator The address repaying the borrow and seizing the collateral
490      * @param borrower The address of the borrower
491      * @param repayAmount The amount of underlying being repaid
492      */
493     function liquidateBorrowAllowed(
494         address cTokenBorrowed,
495         address cTokenCollateral,
496         address liquidator,
497         address borrower,
498         uint256 repayAmount
499     ) external returns (uint256) {
500         // Shh - currently unused
501         liquidator;
502 
503         if (!markets[cTokenBorrowed].isListed || !markets[cTokenCollateral].isListed) {
504             return uint256(Error.MARKET_NOT_LISTED);
505         }
506 
507         // *may include Policy Hook-type checks
508 
509         /* The borrower must have shortfall in order to be liquidatable */
510         (Error err, , uint256 shortfall) = getAccountLiquidityInternal(borrower);
511         if (err != Error.NO_ERROR) {
512             return uint256(err);
513         }
514         if (shortfall == 0) {
515             return uint256(Error.INSUFFICIENT_SHORTFALL);
516         }
517 
518         /* The liquidator may not repay more than what is allowed by the closeFactor */
519         uint256 borrowBalance = CToken(cTokenBorrowed).borrowBalanceStored(borrower);
520         (MathError mathErr, uint256 maxClose) = mulScalarTruncate(Exp({mantissa: closeFactorMantissa}), borrowBalance);
521         if (mathErr != MathError.NO_ERROR) {
522             return uint256(Error.MATH_ERROR);
523         }
524         if (repayAmount > maxClose) {
525             return uint256(Error.TOO_MUCH_REPAY);
526         }
527 
528         return uint256(Error.NO_ERROR);
529     }
530 
531     /**
532      * @notice Validates liquidateBorrow and reverts on rejection. May emit logs.
533      * @param cTokenBorrowed Asset which was borrowed by the borrower
534      * @param cTokenCollateral Asset which was used as collateral and will be seized
535      * @param liquidator The address repaying the borrow and seizing the collateral
536      * @param borrower The address of the borrower
537      * @param actualRepayAmount The amount of underlying being repaid
538      */
539     function liquidateBorrowVerify(
540         address cTokenBorrowed,
541         address cTokenCollateral,
542         address liquidator,
543         address borrower,
544         uint256 actualRepayAmount,
545         uint256 seizeTokens
546     ) external {
547         // Shh - currently unused
548         cTokenBorrowed;
549         cTokenCollateral;
550         liquidator;
551         borrower;
552         actualRepayAmount;
553         seizeTokens;
554 
555         // Shh - we don't ever want this hook to be marked pure
556         if (false) {
557             maxAssets = maxAssets;
558         }
559     }
560 
561     /**
562      * @notice Checks if the seizing of assets should be allowed to occur
563      * @param cTokenCollateral Asset which was used as collateral and will be seized
564      * @param cTokenBorrowed Asset which was borrowed by the borrower
565      * @param liquidator The address repaying the borrow and seizing the collateral
566      * @param borrower The address of the borrower
567      * @param seizeTokens The number of collateral tokens to seize
568      */
569     function seizeAllowed(
570         address cTokenCollateral,
571         address cTokenBorrowed,
572         address liquidator,
573         address borrower,
574         uint256 seizeTokens
575     ) external returns (uint256) {
576         // Pausing is a very serious situation - we revert to sound the alarms
577         require(!seizeGuardianPaused, "seize is paused");
578 
579         // Shh - currently unused
580         liquidator;
581         borrower;
582         seizeTokens;
583 
584         if (!markets[cTokenCollateral].isListed || !markets[cTokenBorrowed].isListed) {
585             return uint256(Error.MARKET_NOT_LISTED);
586         }
587 
588         if (CToken(cTokenCollateral).comptroller() != CToken(cTokenBorrowed).comptroller()) {
589             return uint256(Error.COMPTROLLER_MISMATCH);
590         }
591 
592         // *may include Policy Hook-type checks
593 
594         return uint256(Error.NO_ERROR);
595     }
596 
597     /**
598      * @notice Validates seize and reverts on rejection. May emit logs.
599      * @param cTokenCollateral Asset which was used as collateral and will be seized
600      * @param cTokenBorrowed Asset which was borrowed by the borrower
601      * @param liquidator The address repaying the borrow and seizing the collateral
602      * @param borrower The address of the borrower
603      * @param seizeTokens The number of collateral tokens to seize
604      */
605     function seizeVerify(
606         address cTokenCollateral,
607         address cTokenBorrowed,
608         address liquidator,
609         address borrower,
610         uint256 seizeTokens
611     ) external {
612         // Shh - currently unused
613         cTokenCollateral;
614         cTokenBorrowed;
615         liquidator;
616         borrower;
617         seizeTokens;
618 
619         // Shh - we don't ever want this hook to be marked pure
620         if (false) {
621             maxAssets = maxAssets;
622         }
623     }
624 
625     /**
626      * @notice Checks if the account should be allowed to transfer tokens in the given market
627      * @param cToken The market to verify the transfer against
628      * @param src The account which sources the tokens
629      * @param dst The account which receives the tokens
630      * @param transferTokens The number of cTokens to transfer
631      * @return 0 if the transfer is allowed, otherwise a semi-opaque error code (See ErrorReporter.sol)
632      */
633     function transferAllowed(
634         address cToken,
635         address src,
636         address dst,
637         uint256 transferTokens
638     ) external returns (uint256) {
639         // Pausing is a very serious situation - we revert to sound the alarms
640         require(!transferGuardianPaused, "transfer is paused");
641 
642         // Shh - currently unused
643         dst;
644 
645         // *may include Policy Hook-type checks
646 
647         // Currently the only consideration is whether or not
648         //  the src is allowed to redeem this many tokens
649         return redeemAllowedInternal(cToken, src, transferTokens);
650     }
651 
652     /**
653      * @notice Validates transfer and reverts on rejection. May emit logs.
654      * @param cToken Asset being transferred
655      * @param src The account which sources the tokens
656      * @param dst The account which receives the tokens
657      * @param transferTokens The number of cTokens to transfer
658      */
659     function transferVerify(
660         address cToken,
661         address src,
662         address dst,
663         uint256 transferTokens
664     ) external {
665         // Shh - currently unused
666         cToken;
667         src;
668         dst;
669         transferTokens;
670 
671         // Shh - we don't ever want this hook to be marked pure
672         if (false) {
673             maxAssets = maxAssets;
674         }
675     }
676 
677     /*** Liquidity/Liquidation Calculations ***/
678 
679     /**
680      * @dev Local vars for avoiding stack-depth limits in calculating account liquidity.
681      *  Note that `cTokenBalance` is the number of cTokens the account owns in the market,
682      *  whereas `borrowBalance` is the amount of underlying that the account has borrowed.
683      */
684     struct AccountLiquidityLocalVars {
685         uint256 sumCollateral;
686         uint256 sumBorrowPlusEffects;
687         uint256 cTokenBalance;
688         uint256 borrowBalance;
689         uint256 exchangeRateMantissa;
690         uint256 oraclePriceMantissa;
691         Exp collateralFactor;
692         Exp exchangeRate;
693         Exp oraclePrice;
694         Exp tokensToEther;
695     }
696 
697     /**
698      * @notice Determine the current account liquidity wrt collateral requirements
699      * @return (possible error code (semi-opaque),
700                 account liquidity in excess of collateral requirements,
701      *          account shortfall below collateral requirements)
702      */
703     function getAccountLiquidity(address account)
704         public
705         view
706         returns (
707             uint256,
708             uint256,
709             uint256
710         )
711     {
712         (Error err, uint256 liquidity, uint256 shortfall) = getHypotheticalAccountLiquidityInternal(
713             account,
714             CToken(0),
715             0,
716             0
717         );
718 
719         return (uint256(err), liquidity, shortfall);
720     }
721 
722     /**
723      * @notice Determine the current account liquidity wrt collateral requirements
724      * @return (possible error code,
725                 account liquidity in excess of collateral requirements,
726      *          account shortfall below collateral requirements)
727      */
728     function getAccountLiquidityInternal(address account)
729         internal
730         view
731         returns (
732             Error,
733             uint256,
734             uint256
735         )
736     {
737         return getHypotheticalAccountLiquidityInternal(account, CToken(0), 0, 0);
738     }
739 
740     /**
741      * @notice Determine what the account liquidity would be if the given amounts were redeemed/borrowed
742      * @param cTokenModify The market to hypothetically redeem/borrow in
743      * @param account The account to determine liquidity for
744      * @param redeemTokens The number of tokens to hypothetically redeem
745      * @param borrowAmount The amount of underlying to hypothetically borrow
746      * @return (possible error code (semi-opaque),
747                 hypothetical account liquidity in excess of collateral requirements,
748      *          hypothetical account shortfall below collateral requirements)
749      */
750     function getHypotheticalAccountLiquidity(
751         address account,
752         address cTokenModify,
753         uint256 redeemTokens,
754         uint256 borrowAmount
755     )
756         public
757         view
758         returns (
759             uint256,
760             uint256,
761             uint256
762         )
763     {
764         (Error err, uint256 liquidity, uint256 shortfall) = getHypotheticalAccountLiquidityInternal(
765             account,
766             CToken(cTokenModify),
767             redeemTokens,
768             borrowAmount
769         );
770         return (uint256(err), liquidity, shortfall);
771     }
772 
773     /**
774      * @notice Determine what the account liquidity would be if the given amounts were redeemed/borrowed
775      * @param cTokenModify The market to hypothetically redeem/borrow in
776      * @param account The account to determine liquidity for
777      * @param redeemTokens The number of tokens to hypothetically redeem
778      * @param borrowAmount The amount of underlying to hypothetically borrow
779      * @dev Note that we calculate the exchangeRateStored for each collateral cToken using stored data,
780      *  without calculating accumulated interest.
781      * @return (possible error code,
782                 hypothetical account liquidity in excess of collateral requirements,
783      *          hypothetical account shortfall below collateral requirements)
784      */
785     function getHypotheticalAccountLiquidityInternal(
786         address account,
787         CToken cTokenModify,
788         uint256 redeemTokens,
789         uint256 borrowAmount
790     )
791         internal
792         view
793         returns (
794             Error,
795             uint256,
796             uint256
797         )
798     {
799         AccountLiquidityLocalVars memory vars; // Holds all our calculation results
800         uint256 oErr;
801         MathError mErr;
802 
803         // For each asset the account is in
804         CToken[] memory assets = accountAssets[account];
805         for (uint256 i = 0; i < assets.length; i++) {
806             CToken asset = assets[i];
807 
808             // Read the balances and exchange rate from the cToken
809             (oErr, vars.cTokenBalance, vars.borrowBalance, vars.exchangeRateMantissa) = asset.getAccountSnapshot(
810                 account
811             );
812             if (oErr != 0) {
813                 // semi-opaque error code, we assume NO_ERROR == 0 is invariant between upgrades
814                 return (Error.SNAPSHOT_ERROR, 0, 0);
815             }
816             vars.collateralFactor = Exp({mantissa: markets[address(asset)].collateralFactorMantissa});
817             vars.exchangeRate = Exp({mantissa: vars.exchangeRateMantissa});
818 
819             // Get the normalized price of the asset
820             vars.oraclePriceMantissa = oracle.getUnderlyingPrice(asset);
821             if (vars.oraclePriceMantissa == 0) {
822                 return (Error.PRICE_ERROR, 0, 0);
823             }
824             vars.oraclePrice = Exp({mantissa: vars.oraclePriceMantissa});
825 
826             // Pre-compute a conversion factor from tokens -> ether (normalized price value)
827             (mErr, vars.tokensToEther) = mulExp3(vars.collateralFactor, vars.exchangeRate, vars.oraclePrice);
828             if (mErr != MathError.NO_ERROR) {
829                 return (Error.MATH_ERROR, 0, 0);
830             }
831 
832             // sumCollateral += tokensToEther * cTokenBalance
833             (mErr, vars.sumCollateral) = mulScalarTruncateAddUInt(
834                 vars.tokensToEther,
835                 vars.cTokenBalance,
836                 vars.sumCollateral
837             );
838             if (mErr != MathError.NO_ERROR) {
839                 return (Error.MATH_ERROR, 0, 0);
840             }
841 
842             // sumBorrowPlusEffects += oraclePrice * borrowBalance
843             (mErr, vars.sumBorrowPlusEffects) = mulScalarTruncateAddUInt(
844                 vars.oraclePrice,
845                 vars.borrowBalance,
846                 vars.sumBorrowPlusEffects
847             );
848             if (mErr != MathError.NO_ERROR) {
849                 return (Error.MATH_ERROR, 0, 0);
850             }
851 
852             // Calculate effects of interacting with cTokenModify
853             if (asset == cTokenModify) {
854                 // redeem effect
855                 // sumBorrowPlusEffects += tokensToEther * redeemTokens
856                 (mErr, vars.sumBorrowPlusEffects) = mulScalarTruncateAddUInt(
857                     vars.tokensToEther,
858                     redeemTokens,
859                     vars.sumBorrowPlusEffects
860                 );
861                 if (mErr != MathError.NO_ERROR) {
862                     return (Error.MATH_ERROR, 0, 0);
863                 }
864 
865                 // borrow effect
866                 // sumBorrowPlusEffects += oraclePrice * borrowAmount
867                 (mErr, vars.sumBorrowPlusEffects) = mulScalarTruncateAddUInt(
868                     vars.oraclePrice,
869                     borrowAmount,
870                     vars.sumBorrowPlusEffects
871                 );
872                 if (mErr != MathError.NO_ERROR) {
873                     return (Error.MATH_ERROR, 0, 0);
874                 }
875             }
876         }
877 
878         // These are safe, as the underflow condition is checked first
879         if (vars.sumCollateral > vars.sumBorrowPlusEffects) {
880             return (Error.NO_ERROR, vars.sumCollateral - vars.sumBorrowPlusEffects, 0);
881         } else {
882             return (Error.NO_ERROR, 0, vars.sumBorrowPlusEffects - vars.sumCollateral);
883         }
884     }
885 
886     /**
887      * @notice Calculate number of tokens of collateral asset to seize given an underlying amount
888      * @dev Used in liquidation (called in cToken.liquidateBorrowFresh)
889      * @param cTokenBorrowed The address of the borrowed cToken
890      * @param cTokenCollateral The address of the collateral cToken
891      * @param actualRepayAmount The amount of cTokenBorrowed underlying to convert into cTokenCollateral tokens
892      * @return (errorCode, number of cTokenCollateral tokens to be seized in a liquidation)
893      */
894     function liquidateCalculateSeizeTokens(
895         address cTokenBorrowed,
896         address cTokenCollateral,
897         uint256 actualRepayAmount
898     ) external view returns (uint256, uint256) {
899         /* Read oracle prices for borrowed and collateral markets */
900         uint256 priceBorrowedMantissa = oracle.getUnderlyingPrice(CToken(cTokenBorrowed));
901         uint256 priceCollateralMantissa = oracle.getUnderlyingPrice(CToken(cTokenCollateral));
902         if (priceBorrowedMantissa == 0 || priceCollateralMantissa == 0) {
903             return (uint256(Error.PRICE_ERROR), 0);
904         }
905 
906         /*
907          * Get the exchange rate and calculate the number of collateral tokens to seize:
908          *  seizeAmount = actualRepayAmount * liquidationIncentive * priceBorrowed / priceCollateral
909          *  seizeTokens = seizeAmount / exchangeRate
910          *   = actualRepayAmount * (liquidationIncentive * priceBorrowed) / (priceCollateral * exchangeRate)
911          */
912         uint256 exchangeRateMantissa = CToken(cTokenCollateral).exchangeRateStored(); // Note: reverts on error
913         uint256 seizeTokens;
914         Exp memory numerator;
915         Exp memory denominator;
916         Exp memory ratio;
917         MathError mathErr;
918 
919         (mathErr, numerator) = mulExp(liquidationIncentiveMantissa, priceBorrowedMantissa);
920         if (mathErr != MathError.NO_ERROR) {
921             return (uint256(Error.MATH_ERROR), 0);
922         }
923 
924         (mathErr, denominator) = mulExp(priceCollateralMantissa, exchangeRateMantissa);
925         if (mathErr != MathError.NO_ERROR) {
926             return (uint256(Error.MATH_ERROR), 0);
927         }
928 
929         (mathErr, ratio) = divExp(numerator, denominator);
930         if (mathErr != MathError.NO_ERROR) {
931             return (uint256(Error.MATH_ERROR), 0);
932         }
933 
934         (mathErr, seizeTokens) = mulScalarTruncate(ratio, actualRepayAmount);
935         if (mathErr != MathError.NO_ERROR) {
936             return (uint256(Error.MATH_ERROR), 0);
937         }
938 
939         return (uint256(Error.NO_ERROR), seizeTokens);
940     }
941 
942     /*** Admin Functions ***/
943 
944     /**
945      * @notice Sets a new price oracle for the comptroller
946      * @dev Admin function to set a new price oracle
947      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
948      */
949     function _setPriceOracle(PriceOracle newOracle) public returns (uint256) {
950         // Check caller is admin
951         if (msg.sender != admin) {
952             return fail(Error.UNAUTHORIZED, FailureInfo.SET_PRICE_ORACLE_OWNER_CHECK);
953         }
954 
955         // Track the old oracle for the comptroller
956         PriceOracle oldOracle = oracle;
957 
958         // Set comptroller's oracle to newOracle
959         oracle = newOracle;
960 
961         // Emit NewPriceOracle(oldOracle, newOracle)
962         emit NewPriceOracle(oldOracle, newOracle);
963 
964         return uint256(Error.NO_ERROR);
965     }
966 
967     /**
968      * @notice Sets the closeFactor used when liquidating borrows
969      * @dev Admin function to set closeFactor
970      * @param newCloseFactorMantissa New close factor, scaled by 1e18
971      * @return uint 0=success, otherwise a failure. (See ErrorReporter for details)
972      */
973     function _setCloseFactor(uint256 newCloseFactorMantissa) external returns (uint256) {
974         // Check caller is admin
975         if (msg.sender != admin) {
976             return fail(Error.UNAUTHORIZED, FailureInfo.SET_CLOSE_FACTOR_OWNER_CHECK);
977         }
978 
979         Exp memory newCloseFactorExp = Exp({mantissa: newCloseFactorMantissa});
980         Exp memory lowLimit = Exp({mantissa: closeFactorMinMantissa});
981         if (lessThanOrEqualExp(newCloseFactorExp, lowLimit)) {
982             return fail(Error.INVALID_CLOSE_FACTOR, FailureInfo.SET_CLOSE_FACTOR_VALIDATION);
983         }
984 
985         Exp memory highLimit = Exp({mantissa: closeFactorMaxMantissa});
986         if (lessThanExp(highLimit, newCloseFactorExp)) {
987             return fail(Error.INVALID_CLOSE_FACTOR, FailureInfo.SET_CLOSE_FACTOR_VALIDATION);
988         }
989 
990         uint256 oldCloseFactorMantissa = closeFactorMantissa;
991         closeFactorMantissa = newCloseFactorMantissa;
992         emit NewCloseFactor(oldCloseFactorMantissa, closeFactorMantissa);
993 
994         return uint256(Error.NO_ERROR);
995     }
996 
997     /**
998      * @notice Sets the collateralFactor for a market
999      * @dev Admin function to set per-market collateralFactor
1000      * @param cToken The market to set the factor on
1001      * @param newCollateralFactorMantissa The new collateral factor, scaled by 1e18
1002      * @return uint 0=success, otherwise a failure. (See ErrorReporter for details)
1003      */
1004     function _setCollateralFactor(CToken cToken, uint256 newCollateralFactorMantissa) external returns (uint256) {
1005         // Check caller is admin
1006         if (msg.sender != admin) {
1007             return fail(Error.UNAUTHORIZED, FailureInfo.SET_COLLATERAL_FACTOR_OWNER_CHECK);
1008         }
1009 
1010         // Verify market is listed
1011         Market storage market = markets[address(cToken)];
1012         if (!market.isListed) {
1013             return fail(Error.MARKET_NOT_LISTED, FailureInfo.SET_COLLATERAL_FACTOR_NO_EXISTS);
1014         }
1015 
1016         Exp memory newCollateralFactorExp = Exp({mantissa: newCollateralFactorMantissa});
1017 
1018         // Check collateral factor <= 0.9
1019         Exp memory highLimit = Exp({mantissa: collateralFactorMaxMantissa});
1020         if (lessThanExp(highLimit, newCollateralFactorExp)) {
1021             return fail(Error.INVALID_COLLATERAL_FACTOR, FailureInfo.SET_COLLATERAL_FACTOR_VALIDATION);
1022         }
1023 
1024         // If collateral factor != 0, fail if price == 0
1025         if (newCollateralFactorMantissa != 0 && oracle.getUnderlyingPrice(cToken) == 0) {
1026             return fail(Error.PRICE_ERROR, FailureInfo.SET_COLLATERAL_FACTOR_WITHOUT_PRICE);
1027         }
1028 
1029         // Set market's collateral factor to new collateral factor, remember old value
1030         uint256 oldCollateralFactorMantissa = market.collateralFactorMantissa;
1031         market.collateralFactorMantissa = newCollateralFactorMantissa;
1032 
1033         // Emit event with asset, old collateral factor, and new collateral factor
1034         emit NewCollateralFactor(cToken, oldCollateralFactorMantissa, newCollateralFactorMantissa);
1035 
1036         return uint256(Error.NO_ERROR);
1037     }
1038 
1039     /**
1040      * @notice Sets maxAssets which controls how many markets can be entered
1041      * @dev Admin function to set maxAssets
1042      * @param newMaxAssets New max assets
1043      * @return uint 0=success, otherwise a failure. (See ErrorReporter for details)
1044      */
1045     function _setMaxAssets(uint256 newMaxAssets) external returns (uint256) {
1046         // Check caller is admin
1047         if (msg.sender != admin) {
1048             return fail(Error.UNAUTHORIZED, FailureInfo.SET_MAX_ASSETS_OWNER_CHECK);
1049         }
1050 
1051         uint256 oldMaxAssets = maxAssets;
1052         maxAssets = newMaxAssets;
1053         emit NewMaxAssets(oldMaxAssets, newMaxAssets);
1054 
1055         return uint256(Error.NO_ERROR);
1056     }
1057 
1058     /**
1059      * @notice Sets liquidationIncentive
1060      * @dev Admin function to set liquidationIncentive
1061      * @param newLiquidationIncentiveMantissa New liquidationIncentive scaled by 1e18
1062      * @return uint 0=success, otherwise a failure. (See ErrorReporter for details)
1063      */
1064     function _setLiquidationIncentive(uint256 newLiquidationIncentiveMantissa) external returns (uint256) {
1065         // Check caller is admin
1066         if (msg.sender != admin) {
1067             return fail(Error.UNAUTHORIZED, FailureInfo.SET_LIQUIDATION_INCENTIVE_OWNER_CHECK);
1068         }
1069 
1070         // Check de-scaled min <= newLiquidationIncentive <= max
1071         Exp memory newLiquidationIncentive = Exp({mantissa: newLiquidationIncentiveMantissa});
1072         Exp memory minLiquidationIncentive = Exp({mantissa: liquidationIncentiveMinMantissa});
1073         if (lessThanExp(newLiquidationIncentive, minLiquidationIncentive)) {
1074             return fail(Error.INVALID_LIQUIDATION_INCENTIVE, FailureInfo.SET_LIQUIDATION_INCENTIVE_VALIDATION);
1075         }
1076 
1077         Exp memory maxLiquidationIncentive = Exp({mantissa: liquidationIncentiveMaxMantissa});
1078         if (lessThanExp(maxLiquidationIncentive, newLiquidationIncentive)) {
1079             return fail(Error.INVALID_LIQUIDATION_INCENTIVE, FailureInfo.SET_LIQUIDATION_INCENTIVE_VALIDATION);
1080         }
1081 
1082         // Save current value for use in log
1083         uint256 oldLiquidationIncentiveMantissa = liquidationIncentiveMantissa;
1084 
1085         // Set liquidation incentive to new incentive
1086         liquidationIncentiveMantissa = newLiquidationIncentiveMantissa;
1087 
1088         // Emit event with old incentive, new incentive
1089         emit NewLiquidationIncentive(oldLiquidationIncentiveMantissa, newLiquidationIncentiveMantissa);
1090 
1091         return uint256(Error.NO_ERROR);
1092     }
1093 
1094     /**
1095      * @notice Add the market to the markets mapping and set it as listed
1096      * @dev Admin function to set isListed and add support for the market
1097      * @param cToken The address of the market (token) to list
1098      * @return uint 0=success, otherwise a failure. (See enum Error for details)
1099      */
1100     function _supportMarket(CToken cToken) external returns (uint256) {
1101         if (msg.sender != admin) {
1102             return fail(Error.UNAUTHORIZED, FailureInfo.SUPPORT_MARKET_OWNER_CHECK);
1103         }
1104 
1105         if (markets[address(cToken)].isListed) {
1106             return fail(Error.MARKET_ALREADY_LISTED, FailureInfo.SUPPORT_MARKET_EXISTS);
1107         }
1108 
1109         cToken.isCToken(); // Sanity check to make sure its really a CToken
1110 
1111         markets[address(cToken)] = Market({
1112             isListed: true,
1113             isComped: false,
1114             collateralFactorMantissa: 0,
1115             version: Version.VANILLA
1116         });
1117         emit MarketListed(cToken);
1118 
1119         return uint256(Error.NO_ERROR);
1120     }
1121 
1122     /**
1123      * @notice Admin function to change the Pause Guardian
1124      * @param newPauseGuardian The address of the new Pause Guardian
1125      * @return uint 0=success, otherwise a failure. (See enum Error for details)
1126      */
1127     function _setPauseGuardian(address newPauseGuardian) public returns (uint256) {
1128         if (msg.sender != admin) {
1129             return fail(Error.UNAUTHORIZED, FailureInfo.SET_PAUSE_GUARDIAN_OWNER_CHECK);
1130         }
1131 
1132         // Save current value for inclusion in log
1133         address oldPauseGuardian = pauseGuardian;
1134 
1135         // Store pauseGuardian with value newPauseGuardian
1136         pauseGuardian = newPauseGuardian;
1137 
1138         // Emit NewPauseGuardian(OldPauseGuardian, NewPauseGuardian)
1139         emit NewPauseGuardian(oldPauseGuardian, pauseGuardian);
1140 
1141         return uint256(Error.NO_ERROR);
1142     }
1143 
1144     function _setMintPaused(CToken cToken, bool state) public returns (bool) {
1145         require(markets[address(cToken)].isListed, "cannot pause a market that is not listed");
1146         require(msg.sender == pauseGuardian || msg.sender == admin, "only pause guardian and admin can pause");
1147         require(msg.sender == admin || state == true, "only admin can unpause");
1148 
1149         mintGuardianPaused[address(cToken)] = state;
1150         emit ActionPaused(cToken, "Mint", state);
1151         return state;
1152     }
1153 
1154     function _setBorrowPaused(CToken cToken, bool state) public returns (bool) {
1155         require(markets[address(cToken)].isListed, "cannot pause a market that is not listed");
1156         require(msg.sender == pauseGuardian || msg.sender == admin, "only pause guardian and admin can pause");
1157         require(msg.sender == admin || state == true, "only admin can unpause");
1158 
1159         borrowGuardianPaused[address(cToken)] = state;
1160         emit ActionPaused(cToken, "Borrow", state);
1161         return state;
1162     }
1163 
1164     function _setTransferPaused(bool state) public returns (bool) {
1165         require(msg.sender == pauseGuardian || msg.sender == admin, "only pause guardian and admin can pause");
1166         require(msg.sender == admin || state == true, "only admin can unpause");
1167 
1168         transferGuardianPaused = state;
1169         emit ActionPaused("Transfer", state);
1170         return state;
1171     }
1172 
1173     function _setSeizePaused(bool state) public returns (bool) {
1174         require(msg.sender == pauseGuardian || msg.sender == admin, "only pause guardian and admin can pause");
1175         require(msg.sender == admin || state == true, "only admin can unpause");
1176 
1177         seizeGuardianPaused = state;
1178         emit ActionPaused("Seize", state);
1179         return state;
1180     }
1181 
1182     function _become(Unitroller unitroller) public {
1183         require(msg.sender == unitroller.admin(), "only unitroller admin can change brains");
1184 
1185         uint256 changeStatus = unitroller._acceptImplementation();
1186         require(changeStatus == 0, "change not authorized");
1187     }
1188 }
