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
14  * @dev This was the first version of the Comptroller brains.
15  *  We keep it so our tests can continue to do the real-life behavior of upgrading from this logic forward.
16  */
17 contract ComptrollerG1 is ComptrollerV1Storage, ComptrollerInterface, ComptrollerErrorReporter, Exponential {
18     struct Market {
19         /**
20          * @notice Whether or not this market is listed
21          */
22         bool isListed;
23         /**
24          * @notice Multiplier representing the most one can borrow against their collateral in this market.
25          *  For instance, 0.9 to allow borrowing 90% of collateral value.
26          *  Must be between 0 and 1, and stored as a mantissa.
27          */
28         uint256 collateralFactorMantissa;
29         /**
30          * @notice Per-market mapping of "accounts in this asset"
31          */
32         mapping(address => bool) accountMembership;
33     }
34 
35     /**
36      * @notice Official mapping of cTokens -> Market metadata
37      * @dev Used e.g. to determine if a market is supported
38      */
39     mapping(address => Market) public markets;
40 
41     /**
42      * @notice Emitted when an admin supports a market
43      */
44     event MarketListed(CToken cToken);
45 
46     /**
47      * @notice Emitted when an account enters a market
48      */
49     event MarketEntered(CToken cToken, address account);
50 
51     /**
52      * @notice Emitted when an account exits a market
53      */
54     event MarketExited(CToken cToken, address account);
55 
56     /**
57      * @notice Emitted when close factor is changed by admin
58      */
59     event NewCloseFactor(uint256 oldCloseFactorMantissa, uint256 newCloseFactorMantissa);
60 
61     /**
62      * @notice Emitted when a collateral factor is changed by admin
63      */
64     event NewCollateralFactor(CToken cToken, uint256 oldCollateralFactorMantissa, uint256 newCollateralFactorMantissa);
65 
66     /**
67      * @notice Emitted when liquidation incentive is changed by admin
68      */
69     event NewLiquidationIncentive(uint256 oldLiquidationIncentiveMantissa, uint256 newLiquidationIncentiveMantissa);
70 
71     /**
72      * @notice Emitted when maxAssets is changed by admin
73      */
74     event NewMaxAssets(uint256 oldMaxAssets, uint256 newMaxAssets);
75 
76     /**
77      * @notice Emitted when price oracle is changed
78      */
79     event NewPriceOracle(PriceOracle oldPriceOracle, PriceOracle newPriceOracle);
80 
81     // closeFactorMantissa must be strictly greater than this value
82     uint256 constant closeFactorMinMantissa = 5e16; // 0.05
83 
84     // closeFactorMantissa must not exceed this value
85     uint256 constant closeFactorMaxMantissa = 9e17; // 0.9
86 
87     // No collateralFactorMantissa may exceed this value
88     uint256 constant collateralFactorMaxMantissa = 9e17; // 0.9
89 
90     // liquidationIncentiveMantissa must be no less than this value
91     uint256 constant liquidationIncentiveMinMantissa = mantissaOne;
92 
93     // liquidationIncentiveMantissa must be no greater than this value
94     uint256 constant liquidationIncentiveMaxMantissa = 15e17; // 1.5
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
134             Market storage marketToJoin = markets[address(cToken)];
135 
136             if (!marketToJoin.isListed) {
137                 // if market is not listed, cannot join move along
138                 results[i] = uint256(Error.MARKET_NOT_LISTED);
139                 continue;
140             }
141 
142             if (marketToJoin.accountMembership[msg.sender] == true) {
143                 // if already joined, move along
144                 results[i] = uint256(Error.NO_ERROR);
145                 continue;
146             }
147 
148             if (accountAssets[msg.sender].length >= maxAssets) {
149                 // if no space, cannot join, move along
150                 results[i] = uint256(Error.TOO_MANY_ASSETS);
151                 continue;
152             }
153 
154             // survived the gauntlet, add to list
155             // NOTE: we store these somewhat redundantly as a significant optimization
156             //  this avoids having to iterate through the list for the most common use cases
157             //  that is, only when we need to perform liquidity checks
158             //   and not whenever we want to check if an account is in a particular market
159             marketToJoin.accountMembership[msg.sender] = true;
160             accountAssets[msg.sender].push(cToken);
161 
162             emit MarketEntered(cToken, msg.sender);
163 
164             results[i] = uint256(Error.NO_ERROR);
165         }
166 
167         return results;
168     }
169 
170     /**
171      * @notice Removes asset from sender's account liquidity calculation
172      * @dev Sender must not have an outstanding borrow balance in the asset,
173      *  or be providing neccessary collateral for an outstanding borrow.
174      * @param cTokenAddress The address of the asset to be removed
175      * @return Whether or not the account successfully exited the market
176      */
177     function exitMarket(address cTokenAddress) external returns (uint256) {
178         CToken cToken = CToken(cTokenAddress);
179         /* Get sender tokensHeld and amountOwed underlying from the cToken */
180         (uint256 oErr, uint256 tokensHeld, uint256 amountOwed, ) = cToken.getAccountSnapshot(msg.sender);
181         require(oErr == 0, "exitMarket: getAccountSnapshot failed"); // semi-opaque error code
182 
183         /* Fail if the sender has a borrow balance */
184         if (amountOwed != 0) {
185             return fail(Error.NONZERO_BORROW_BALANCE, FailureInfo.EXIT_MARKET_BALANCE_OWED);
186         }
187 
188         /* Fail if the sender is not permitted to redeem all of their tokens */
189         uint256 allowed = redeemAllowedInternal(cTokenAddress, msg.sender, tokensHeld);
190         if (allowed != 0) {
191             return failOpaque(Error.REJECTION, FailureInfo.EXIT_MARKET_REJECTION, allowed);
192         }
193 
194         Market storage marketToExit = markets[address(cToken)];
195 
196         /* Return true if the sender is not already ‘in’ the market */
197         if (!marketToExit.accountMembership[msg.sender]) {
198             return uint256(Error.NO_ERROR);
199         }
200 
201         /* Set cToken account membership to false */
202         delete marketToExit.accountMembership[msg.sender];
203 
204         /* Delete cToken from the account’s list of assets */
205         // load into memory for faster iteration
206         CToken[] memory userAssetList = accountAssets[msg.sender];
207         uint256 len = userAssetList.length;
208         uint256 assetIndex = len;
209         for (uint256 i = 0; i < len; i++) {
210             if (userAssetList[i] == cToken) {
211                 assetIndex = i;
212                 break;
213             }
214         }
215 
216         // We *must* have found the asset in the list or our redundant data structure is broken
217         assert(assetIndex < len);
218 
219         // copy last item in list to location of item to be removed, reduce length by 1
220         CToken[] storage storedList = accountAssets[msg.sender];
221         storedList[assetIndex] = storedList[storedList.length - 1];
222         storedList.length--;
223 
224         emit MarketExited(cToken, msg.sender);
225 
226         return uint256(Error.NO_ERROR);
227     }
228 
229     /*** Policy Hooks ***/
230 
231     /**
232      * @notice Checks if the account should be allowed to mint tokens in the given market
233      * @param cToken The market to verify the mint against
234      * @param minter The account which would get the minted tokens
235      * @param mintAmount The amount of underlying being supplied to the market in exchange for tokens
236      * @return 0 if the mint is allowed, otherwise a semi-opaque error code (See ErrorReporter.sol)
237      */
238     function mintAllowed(
239         address cToken,
240         address minter,
241         uint256 mintAmount
242     ) external returns (uint256) {
243         minter; // currently unused
244         mintAmount; // currently unused
245 
246         if (!markets[cToken].isListed) {
247             return uint256(Error.MARKET_NOT_LISTED);
248         }
249 
250         // *may include Policy Hook-type checks
251 
252         return uint256(Error.NO_ERROR);
253     }
254 
255     /**
256      * @notice Validates mint and reverts on rejection. May emit logs.
257      * @param cToken Asset being minted
258      * @param minter The address minting the tokens
259      * @param mintAmount The amount of the underlying asset being minted
260      * @param mintTokens The number of tokens being minted
261      */
262     function mintVerify(
263         address cToken,
264         address minter,
265         uint256 mintAmount,
266         uint256 mintTokens
267     ) external {
268         cToken; // currently unused
269         minter; // currently unused
270         mintAmount; // currently unused
271         mintTokens; // currently unused
272 
273         if (false) {
274             maxAssets = maxAssets; // not pure
275         }
276     }
277 
278     /**
279      * @notice Checks if the account should be allowed to redeem tokens in the given market
280      * @param cToken The market to verify the redeem against
281      * @param redeemer The account which would redeem the tokens
282      * @param redeemTokens The number of cTokens to exchange for the underlying asset in the market
283      * @return 0 if the redeem is allowed, otherwise a semi-opaque error code (See ErrorReporter.sol)
284      */
285     function redeemAllowed(
286         address cToken,
287         address redeemer,
288         uint256 redeemTokens
289     ) external returns (uint256) {
290         return redeemAllowedInternal(cToken, redeemer, redeemTokens);
291     }
292 
293     function redeemAllowedInternal(
294         address cToken,
295         address redeemer,
296         uint256 redeemTokens
297     ) internal view returns (uint256) {
298         if (!markets[cToken].isListed) {
299             return uint256(Error.MARKET_NOT_LISTED);
300         }
301 
302         // *may include Policy Hook-type checks
303 
304         /* If the redeemer is not 'in' the market, then we can bypass the liquidity check */
305         if (!markets[cToken].accountMembership[redeemer]) {
306             return uint256(Error.NO_ERROR);
307         }
308 
309         /* Otherwise, perform a hypothetical liquidity check to guard against shortfall */
310         (Error err, , uint256 shortfall) = getHypotheticalAccountLiquidityInternal(
311             redeemer,
312             CToken(cToken),
313             redeemTokens,
314             0
315         );
316         if (err != Error.NO_ERROR) {
317             return uint256(err);
318         }
319         if (shortfall > 0) {
320             return uint256(Error.INSUFFICIENT_LIQUIDITY);
321         }
322 
323         return uint256(Error.NO_ERROR);
324     }
325 
326     /**
327      * @notice Validates redeem and reverts on rejection. May emit logs.
328      * @param cToken Asset being redeemed
329      * @param redeemer The address redeeming the tokens
330      * @param redeemAmount The amount of the underlying asset being redeemed
331      * @param redeemTokens The number of tokens being redeemed
332      */
333     function redeemVerify(
334         address cToken,
335         address redeemer,
336         uint256 redeemAmount,
337         uint256 redeemTokens
338     ) external {
339         cToken; // currently unused
340         redeemer; // currently unused
341         redeemAmount; // currently unused
342         redeemTokens; // currently unused
343 
344         // Require tokens is zero or amount is also zero
345         if (redeemTokens == 0 && redeemAmount > 0) {
346             revert("redeemTokens zero");
347         }
348     }
349 
350     /**
351      * @notice Checks if the account should be allowed to borrow the underlying asset of the given market
352      * @param cToken The market to verify the borrow against
353      * @param borrower The account which would borrow the asset
354      * @param borrowAmount The amount of underlying the account would borrow
355      * @return 0 if the borrow is allowed, otherwise a semi-opaque error code (See ErrorReporter.sol)
356      */
357     function borrowAllowed(
358         address cToken,
359         address borrower,
360         uint256 borrowAmount
361     ) external returns (uint256) {
362         if (!markets[cToken].isListed) {
363             return uint256(Error.MARKET_NOT_LISTED);
364         }
365 
366         // *may include Policy Hook-type checks
367 
368         if (!markets[cToken].accountMembership[borrower]) {
369             return uint256(Error.MARKET_NOT_ENTERED);
370         }
371 
372         if (oracle.getUnderlyingPrice(CToken(cToken)) == 0) {
373             return uint256(Error.PRICE_ERROR);
374         }
375 
376         (Error err, , uint256 shortfall) = getHypotheticalAccountLiquidityInternal(
377             borrower,
378             CToken(cToken),
379             0,
380             borrowAmount
381         );
382         if (err != Error.NO_ERROR) {
383             return uint256(err);
384         }
385         if (shortfall > 0) {
386             return uint256(Error.INSUFFICIENT_LIQUIDITY);
387         }
388 
389         return uint256(Error.NO_ERROR);
390     }
391 
392     /**
393      * @notice Validates borrow and reverts on rejection. May emit logs.
394      * @param cToken Asset whose underlying is being borrowed
395      * @param borrower The address borrowing the underlying
396      * @param borrowAmount The amount of the underlying asset requested to borrow
397      */
398     function borrowVerify(
399         address cToken,
400         address borrower,
401         uint256 borrowAmount
402     ) external {
403         cToken; // currently unused
404         borrower; // currently unused
405         borrowAmount; // currently unused
406 
407         if (false) {
408             maxAssets = maxAssets; // not pure
409         }
410     }
411 
412     /**
413      * @notice Checks if the account should be allowed to repay a borrow in the given market
414      * @param cToken The market to verify the repay against
415      * @param payer The account which would repay the asset
416      * @param borrower The account which would borrowed the asset
417      * @param repayAmount The amount of the underlying asset the account would repay
418      * @return 0 if the repay is allowed, otherwise a semi-opaque error code (See ErrorReporter.sol)
419      */
420     function repayBorrowAllowed(
421         address cToken,
422         address payer,
423         address borrower,
424         uint256 repayAmount
425     ) external returns (uint256) {
426         payer; // currently unused
427         borrower; // currently unused
428         repayAmount; // currently unused
429 
430         if (!markets[cToken].isListed) {
431             return uint256(Error.MARKET_NOT_LISTED);
432         }
433 
434         // *may include Policy Hook-type checks
435 
436         return uint256(Error.NO_ERROR);
437     }
438 
439     /**
440      * @notice Validates repayBorrow and reverts on rejection. May emit logs.
441      * @param cToken Asset being repaid
442      * @param payer The address repaying the borrow
443      * @param borrower The address of the borrower
444      * @param repayAmount The amount of underlying being repaid
445      */
446     function repayBorrowVerify(
447         address cToken,
448         address payer,
449         address borrower,
450         uint256 repayAmount,
451         uint256 borrowerIndex
452     ) external {
453         cToken; // currently unused
454         payer; // currently unused
455         borrower; // currently unused
456         repayAmount; // currently unused
457         borrowerIndex; // currently unused
458 
459         if (false) {
460             maxAssets = maxAssets; // not pure
461         }
462     }
463 
464     /**
465      * @notice Checks if the liquidation should be allowed to occur
466      * @param cTokenBorrowed Asset which was borrowed by the borrower
467      * @param cTokenCollateral Asset which was used as collateral and will be seized
468      * @param liquidator The address repaying the borrow and seizing the collateral
469      * @param borrower The address of the borrower
470      * @param repayAmount The amount of underlying being repaid
471      */
472     function liquidateBorrowAllowed(
473         address cTokenBorrowed,
474         address cTokenCollateral,
475         address liquidator,
476         address borrower,
477         uint256 repayAmount
478     ) external returns (uint256) {
479         liquidator; // currently unused
480         borrower; // currently unused
481         repayAmount; // currently unused
482 
483         if (!markets[cTokenBorrowed].isListed || !markets[cTokenCollateral].isListed) {
484             return uint256(Error.MARKET_NOT_LISTED);
485         }
486 
487         // *may include Policy Hook-type checks
488 
489         /* The borrower must have shortfall in order to be liquidatable */
490         (Error err, , uint256 shortfall) = getAccountLiquidityInternal(borrower);
491         if (err != Error.NO_ERROR) {
492             return uint256(err);
493         }
494         if (shortfall == 0) {
495             return uint256(Error.INSUFFICIENT_SHORTFALL);
496         }
497 
498         /* The liquidator may not repay more than what is allowed by the closeFactor */
499         uint256 borrowBalance = CToken(cTokenBorrowed).borrowBalanceStored(borrower);
500         (MathError mathErr, uint256 maxClose) = mulScalarTruncate(Exp({mantissa: closeFactorMantissa}), borrowBalance);
501         if (mathErr != MathError.NO_ERROR) {
502             return uint256(Error.MATH_ERROR);
503         }
504         if (repayAmount > maxClose) {
505             return uint256(Error.TOO_MUCH_REPAY);
506         }
507 
508         return uint256(Error.NO_ERROR);
509     }
510 
511     /**
512      * @notice Validates liquidateBorrow and reverts on rejection. May emit logs.
513      * @param cTokenBorrowed Asset which was borrowed by the borrower
514      * @param cTokenCollateral Asset which was used as collateral and will be seized
515      * @param liquidator The address repaying the borrow and seizing the collateral
516      * @param borrower The address of the borrower
517      * @param repayAmount The amount of underlying being repaid
518      */
519     function liquidateBorrowVerify(
520         address cTokenBorrowed,
521         address cTokenCollateral,
522         address liquidator,
523         address borrower,
524         uint256 repayAmount,
525         uint256 seizeTokens
526     ) external {
527         cTokenBorrowed; // currently unused
528         cTokenCollateral; // currently unused
529         liquidator; // currently unused
530         borrower; // currently unused
531         repayAmount; // currently unused
532         seizeTokens; // currently unused
533 
534         if (false) {
535             maxAssets = maxAssets; // not pure
536         }
537     }
538 
539     /**
540      * @notice Checks if the seizing of assets should be allowed to occur
541      * @param cTokenCollateral Asset which was used as collateral and will be seized
542      * @param cTokenBorrowed Asset which was borrowed by the borrower
543      * @param liquidator The address repaying the borrow and seizing the collateral
544      * @param borrower The address of the borrower
545      * @param seizeTokens The number of collateral tokens to seize
546      */
547     function seizeAllowed(
548         address cTokenCollateral,
549         address cTokenBorrowed,
550         address liquidator,
551         address borrower,
552         uint256 seizeTokens
553     ) external returns (uint256) {
554         liquidator; // currently unused
555         borrower; // currently unused
556         seizeTokens; // currently unused
557 
558         if (!markets[cTokenCollateral].isListed || !markets[cTokenBorrowed].isListed) {
559             return uint256(Error.MARKET_NOT_LISTED);
560         }
561 
562         if (CToken(cTokenCollateral).comptroller() != CToken(cTokenBorrowed).comptroller()) {
563             return uint256(Error.COMPTROLLER_MISMATCH);
564         }
565 
566         // *may include Policy Hook-type checks
567 
568         return uint256(Error.NO_ERROR);
569     }
570 
571     /**
572      * @notice Validates seize and reverts on rejection. May emit logs.
573      * @param cTokenCollateral Asset which was used as collateral and will be seized
574      * @param cTokenBorrowed Asset which was borrowed by the borrower
575      * @param liquidator The address repaying the borrow and seizing the collateral
576      * @param borrower The address of the borrower
577      * @param seizeTokens The number of collateral tokens to seize
578      */
579     function seizeVerify(
580         address cTokenCollateral,
581         address cTokenBorrowed,
582         address liquidator,
583         address borrower,
584         uint256 seizeTokens
585     ) external {
586         cTokenCollateral; // currently unused
587         cTokenBorrowed; // currently unused
588         liquidator; // currently unused
589         borrower; // currently unused
590         seizeTokens; // currently unused
591 
592         if (false) {
593             maxAssets = maxAssets; // not pure
594         }
595     }
596 
597     /**
598      * @notice Checks if the account should be allowed to transfer tokens in the given market
599      * @param cToken The market to verify the transfer against
600      * @param src The account which sources the tokens
601      * @param dst The account which receives the tokens
602      * @param transferTokens The number of cTokens to transfer
603      * @return 0 if the transfer is allowed, otherwise a semi-opaque error code (See ErrorReporter.sol)
604      */
605     function transferAllowed(
606         address cToken,
607         address src,
608         address dst,
609         uint256 transferTokens
610     ) external returns (uint256) {
611         cToken; // currently unused
612         src; // currently unused
613         dst; // currently unused
614         transferTokens; // currently unused
615 
616         // *may include Policy Hook-type checks
617 
618         // Currently the only consideration is whether or not
619         //  the src is allowed to redeem this many tokens
620         return redeemAllowedInternal(cToken, src, transferTokens);
621     }
622 
623     /**
624      * @notice Validates transfer and reverts on rejection. May emit logs.
625      * @param cToken Asset being transferred
626      * @param src The account which sources the tokens
627      * @param dst The account which receives the tokens
628      * @param transferTokens The number of cTokens to transfer
629      */
630     function transferVerify(
631         address cToken,
632         address src,
633         address dst,
634         uint256 transferTokens
635     ) external {
636         cToken; // currently unused
637         src; // currently unused
638         dst; // currently unused
639         transferTokens; // currently unused
640 
641         if (false) {
642             maxAssets = maxAssets; // not pure
643         }
644     }
645 
646     /*** Liquidity/Liquidation Calculations ***/
647 
648     /**
649      * @dev Local vars for avoiding stack-depth limits in calculating account liquidity.
650      *  Note that `cTokenBalance` is the number of cTokens the account owns in the market,
651      *  whereas `borrowBalance` is the amount of underlying that the account has borrowed.
652      */
653     struct AccountLiquidityLocalVars {
654         uint256 sumCollateral;
655         uint256 sumBorrowPlusEffects;
656         uint256 cTokenBalance;
657         uint256 borrowBalance;
658         uint256 exchangeRateMantissa;
659         uint256 oraclePriceMantissa;
660         Exp collateralFactor;
661         Exp exchangeRate;
662         Exp oraclePrice;
663         Exp tokensToEther;
664     }
665 
666     /**
667      * @notice Determine the current account liquidity wrt collateral requirements
668      * @return (possible error code (semi-opaque),
669                 account liquidity in excess of collateral requirements,
670      *          account shortfall below collateral requirements)
671      */
672     function getAccountLiquidity(address account)
673         public
674         view
675         returns (
676             uint256,
677             uint256,
678             uint256
679         )
680     {
681         (Error err, uint256 liquidity, uint256 shortfall) = getHypotheticalAccountLiquidityInternal(
682             account,
683             CToken(0),
684             0,
685             0
686         );
687 
688         return (uint256(err), liquidity, shortfall);
689     }
690 
691     /**
692      * @notice Determine the current account liquidity wrt collateral requirements
693      * @return (possible error code,
694                 account liquidity in excess of collateral requirements,
695      *          account shortfall below collateral requirements)
696      */
697     function getAccountLiquidityInternal(address account)
698         internal
699         view
700         returns (
701             Error,
702             uint256,
703             uint256
704         )
705     {
706         return getHypotheticalAccountLiquidityInternal(account, CToken(0), 0, 0);
707     }
708 
709     /**
710      * @notice Determine what the account liquidity would be if the given amounts were redeemed/borrowed
711      * @param cTokenModify The market to hypothetically redeem/borrow in
712      * @param account The account to determine liquidity for
713      * @param redeemTokens The number of tokens to hypothetically redeem
714      * @param borrowAmount The amount of underlying to hypothetically borrow
715      * @dev Note that we calculate the exchangeRateStored for each collateral cToken using stored data,
716      *  without calculating accumulated interest.
717      * @return (possible error code,
718                 hypothetical account liquidity in excess of collateral requirements,
719      *          hypothetical account shortfall below collateral requirements)
720      */
721     function getHypotheticalAccountLiquidityInternal(
722         address account,
723         CToken cTokenModify,
724         uint256 redeemTokens,
725         uint256 borrowAmount
726     )
727         internal
728         view
729         returns (
730             Error,
731             uint256,
732             uint256
733         )
734     {
735         AccountLiquidityLocalVars memory vars; // Holds all our calculation results
736         uint256 oErr;
737         MathError mErr;
738 
739         // For each asset the account is in
740         CToken[] memory assets = accountAssets[account];
741         for (uint256 i = 0; i < assets.length; i++) {
742             CToken asset = assets[i];
743 
744             // Read the balances and exchange rate from the cToken
745             (oErr, vars.cTokenBalance, vars.borrowBalance, vars.exchangeRateMantissa) = asset.getAccountSnapshot(
746                 account
747             );
748             if (oErr != 0) {
749                 // semi-opaque error code, we assume NO_ERROR == 0 is invariant between upgrades
750                 return (Error.SNAPSHOT_ERROR, 0, 0);
751             }
752             vars.collateralFactor = Exp({mantissa: markets[address(asset)].collateralFactorMantissa});
753             vars.exchangeRate = Exp({mantissa: vars.exchangeRateMantissa});
754 
755             // Get the normalized price of the asset
756             vars.oraclePriceMantissa = oracle.getUnderlyingPrice(asset);
757             if (vars.oraclePriceMantissa == 0) {
758                 return (Error.PRICE_ERROR, 0, 0);
759             }
760             vars.oraclePrice = Exp({mantissa: vars.oraclePriceMantissa});
761 
762             // Pre-compute a conversion factor from tokens -> ether (normalized price value)
763             (mErr, vars.tokensToEther) = mulExp3(vars.collateralFactor, vars.exchangeRate, vars.oraclePrice);
764             if (mErr != MathError.NO_ERROR) {
765                 return (Error.MATH_ERROR, 0, 0);
766             }
767 
768             // sumCollateral += tokensToEther * cTokenBalance
769             (mErr, vars.sumCollateral) = mulScalarTruncateAddUInt(
770                 vars.tokensToEther,
771                 vars.cTokenBalance,
772                 vars.sumCollateral
773             );
774             if (mErr != MathError.NO_ERROR) {
775                 return (Error.MATH_ERROR, 0, 0);
776             }
777 
778             // sumBorrowPlusEffects += oraclePrice * borrowBalance
779             (mErr, vars.sumBorrowPlusEffects) = mulScalarTruncateAddUInt(
780                 vars.oraclePrice,
781                 vars.borrowBalance,
782                 vars.sumBorrowPlusEffects
783             );
784             if (mErr != MathError.NO_ERROR) {
785                 return (Error.MATH_ERROR, 0, 0);
786             }
787 
788             // Calculate effects of interacting with cTokenModify
789             if (asset == cTokenModify) {
790                 // redeem effect
791                 // sumBorrowPlusEffects += tokensToEther * redeemTokens
792                 (mErr, vars.sumBorrowPlusEffects) = mulScalarTruncateAddUInt(
793                     vars.tokensToEther,
794                     redeemTokens,
795                     vars.sumBorrowPlusEffects
796                 );
797                 if (mErr != MathError.NO_ERROR) {
798                     return (Error.MATH_ERROR, 0, 0);
799                 }
800 
801                 // borrow effect
802                 // sumBorrowPlusEffects += oraclePrice * borrowAmount
803                 (mErr, vars.sumBorrowPlusEffects) = mulScalarTruncateAddUInt(
804                     vars.oraclePrice,
805                     borrowAmount,
806                     vars.sumBorrowPlusEffects
807                 );
808                 if (mErr != MathError.NO_ERROR) {
809                     return (Error.MATH_ERROR, 0, 0);
810                 }
811             }
812         }
813 
814         // These are safe, as the underflow condition is checked first
815         if (vars.sumCollateral > vars.sumBorrowPlusEffects) {
816             return (Error.NO_ERROR, vars.sumCollateral - vars.sumBorrowPlusEffects, 0);
817         } else {
818             return (Error.NO_ERROR, 0, vars.sumBorrowPlusEffects - vars.sumCollateral);
819         }
820     }
821 
822     /**
823      * @notice Calculate number of tokens of collateral asset to seize given an underlying amount
824      * @dev Used in liquidation (called in cToken.liquidateBorrowFresh)
825      * @param cTokenBorrowed The address of the borrowed cToken
826      * @param cTokenCollateral The address of the collateral cToken
827      * @param repayAmount The amount of cTokenBorrowed underlying to convert into cTokenCollateral tokens
828      * @return (errorCode, number of cTokenCollateral tokens to be seized in a liquidation)
829      */
830     function liquidateCalculateSeizeTokens(
831         address cTokenBorrowed,
832         address cTokenCollateral,
833         uint256 repayAmount
834     ) external view returns (uint256, uint256) {
835         /* Read oracle prices for borrowed and collateral markets */
836         uint256 priceBorrowedMantissa = oracle.getUnderlyingPrice(CToken(cTokenBorrowed));
837         uint256 priceCollateralMantissa = oracle.getUnderlyingPrice(CToken(cTokenCollateral));
838         if (priceBorrowedMantissa == 0 || priceCollateralMantissa == 0) {
839             return (uint256(Error.PRICE_ERROR), 0);
840         }
841 
842         /*
843          * Get the exchange rate and calculate the number of collateral tokens to seize:
844          *  seizeAmount = repayAmount * liquidationIncentive * priceBorrowed / priceCollateral
845          *  seizeTokens = seizeAmount / exchangeRate
846          *   = repayAmount * (liquidationIncentive * priceBorrowed) / (priceCollateral * exchangeRate)
847          */
848         uint256 exchangeRateMantissa = CToken(cTokenCollateral).exchangeRateStored(); // Note: reverts on error
849         uint256 seizeTokens;
850         Exp memory numerator;
851         Exp memory denominator;
852         Exp memory ratio;
853         MathError mathErr;
854 
855         (mathErr, numerator) = mulExp(liquidationIncentiveMantissa, priceBorrowedMantissa);
856         if (mathErr != MathError.NO_ERROR) {
857             return (uint256(Error.MATH_ERROR), 0);
858         }
859 
860         (mathErr, denominator) = mulExp(priceCollateralMantissa, exchangeRateMantissa);
861         if (mathErr != MathError.NO_ERROR) {
862             return (uint256(Error.MATH_ERROR), 0);
863         }
864 
865         (mathErr, ratio) = divExp(numerator, denominator);
866         if (mathErr != MathError.NO_ERROR) {
867             return (uint256(Error.MATH_ERROR), 0);
868         }
869 
870         (mathErr, seizeTokens) = mulScalarTruncate(ratio, repayAmount);
871         if (mathErr != MathError.NO_ERROR) {
872             return (uint256(Error.MATH_ERROR), 0);
873         }
874 
875         return (uint256(Error.NO_ERROR), seizeTokens);
876     }
877 
878     /*** Admin Functions ***/
879 
880     /**
881      * @notice Sets a new price oracle for the comptroller
882      * @dev Admin function to set a new price oracle
883      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
884      */
885     function _setPriceOracle(PriceOracle newOracle) public returns (uint256) {
886         // Check caller is admin OR currently initialzing as new unitroller implementation
887         if (!adminOrInitializing()) {
888             return fail(Error.UNAUTHORIZED, FailureInfo.SET_PRICE_ORACLE_OWNER_CHECK);
889         }
890 
891         // Track the old oracle for the comptroller
892         PriceOracle oldOracle = oracle;
893 
894         // Ensure invoke newOracle.isPriceOracle() returns true
895         // require(newOracle.isPriceOracle(), "oracle method isPriceOracle returned false");
896 
897         // Set comptroller's oracle to newOracle
898         oracle = newOracle;
899 
900         // Emit NewPriceOracle(oldOracle, newOracle)
901         emit NewPriceOracle(oldOracle, newOracle);
902 
903         return uint256(Error.NO_ERROR);
904     }
905 
906     /**
907      * @notice Sets the closeFactor used when liquidating borrows
908      * @dev Admin function to set closeFactor
909      * @param newCloseFactorMantissa New close factor, scaled by 1e18
910      * @return uint 0=success, otherwise a failure. (See ErrorReporter for details)
911      */
912     function _setCloseFactor(uint256 newCloseFactorMantissa) external returns (uint256) {
913         // Check caller is admin OR currently initialzing as new unitroller implementation
914         if (!adminOrInitializing()) {
915             return fail(Error.UNAUTHORIZED, FailureInfo.SET_CLOSE_FACTOR_OWNER_CHECK);
916         }
917 
918         Exp memory newCloseFactorExp = Exp({mantissa: newCloseFactorMantissa});
919         Exp memory lowLimit = Exp({mantissa: closeFactorMinMantissa});
920         if (lessThanOrEqualExp(newCloseFactorExp, lowLimit)) {
921             return fail(Error.INVALID_CLOSE_FACTOR, FailureInfo.SET_CLOSE_FACTOR_VALIDATION);
922         }
923 
924         Exp memory highLimit = Exp({mantissa: closeFactorMaxMantissa});
925         if (lessThanExp(highLimit, newCloseFactorExp)) {
926             return fail(Error.INVALID_CLOSE_FACTOR, FailureInfo.SET_CLOSE_FACTOR_VALIDATION);
927         }
928 
929         uint256 oldCloseFactorMantissa = closeFactorMantissa;
930         closeFactorMantissa = newCloseFactorMantissa;
931         emit NewCloseFactor(oldCloseFactorMantissa, closeFactorMantissa);
932 
933         return uint256(Error.NO_ERROR);
934     }
935 
936     /**
937      * @notice Sets the collateralFactor for a market
938      * @dev Admin function to set per-market collateralFactor
939      * @param cToken The market to set the factor on
940      * @param newCollateralFactorMantissa The new collateral factor, scaled by 1e18
941      * @return uint 0=success, otherwise a failure. (See ErrorReporter for details)
942      */
943     function _setCollateralFactor(CToken cToken, uint256 newCollateralFactorMantissa) external returns (uint256) {
944         // Check caller is admin
945         if (msg.sender != admin) {
946             return fail(Error.UNAUTHORIZED, FailureInfo.SET_COLLATERAL_FACTOR_OWNER_CHECK);
947         }
948 
949         // Verify market is listed
950         Market storage market = markets[address(cToken)];
951         if (!market.isListed) {
952             return fail(Error.MARKET_NOT_LISTED, FailureInfo.SET_COLLATERAL_FACTOR_NO_EXISTS);
953         }
954 
955         Exp memory newCollateralFactorExp = Exp({mantissa: newCollateralFactorMantissa});
956 
957         // Check collateral factor <= 0.9
958         Exp memory highLimit = Exp({mantissa: collateralFactorMaxMantissa});
959         if (lessThanExp(highLimit, newCollateralFactorExp)) {
960             return fail(Error.INVALID_COLLATERAL_FACTOR, FailureInfo.SET_COLLATERAL_FACTOR_VALIDATION);
961         }
962 
963         // If collateral factor != 0, fail if price == 0
964         if (newCollateralFactorMantissa != 0 && oracle.getUnderlyingPrice(cToken) == 0) {
965             return fail(Error.PRICE_ERROR, FailureInfo.SET_COLLATERAL_FACTOR_WITHOUT_PRICE);
966         }
967 
968         // Set market's collateral factor to new collateral factor, remember old value
969         uint256 oldCollateralFactorMantissa = market.collateralFactorMantissa;
970         market.collateralFactorMantissa = newCollateralFactorMantissa;
971 
972         // Emit event with asset, old collateral factor, and new collateral factor
973         emit NewCollateralFactor(cToken, oldCollateralFactorMantissa, newCollateralFactorMantissa);
974 
975         return uint256(Error.NO_ERROR);
976     }
977 
978     /**
979      * @notice Sets maxAssets which controls how many markets can be entered
980      * @dev Admin function to set maxAssets
981      * @param newMaxAssets New max assets
982      * @return uint 0=success, otherwise a failure. (See ErrorReporter for details)
983      */
984     function _setMaxAssets(uint256 newMaxAssets) external returns (uint256) {
985         // Check caller is admin OR currently initialzing as new unitroller implementation
986         if (!adminOrInitializing()) {
987             return fail(Error.UNAUTHORIZED, FailureInfo.SET_MAX_ASSETS_OWNER_CHECK);
988         }
989 
990         uint256 oldMaxAssets = maxAssets;
991         maxAssets = newMaxAssets;
992         emit NewMaxAssets(oldMaxAssets, newMaxAssets);
993 
994         return uint256(Error.NO_ERROR);
995     }
996 
997     /**
998      * @notice Sets liquidationIncentive
999      * @dev Admin function to set liquidationIncentive
1000      * @param newLiquidationIncentiveMantissa New liquidationIncentive scaled by 1e18
1001      * @return uint 0=success, otherwise a failure. (See ErrorReporter for details)
1002      */
1003     function _setLiquidationIncentive(uint256 newLiquidationIncentiveMantissa) external returns (uint256) {
1004         // Check caller is admin OR currently initialzing as new unitroller implementation
1005         if (!adminOrInitializing()) {
1006             return fail(Error.UNAUTHORIZED, FailureInfo.SET_LIQUIDATION_INCENTIVE_OWNER_CHECK);
1007         }
1008 
1009         // Check de-scaled 1 <= newLiquidationDiscount <= 1.5
1010         Exp memory newLiquidationIncentive = Exp({mantissa: newLiquidationIncentiveMantissa});
1011         Exp memory minLiquidationIncentive = Exp({mantissa: liquidationIncentiveMinMantissa});
1012         if (lessThanExp(newLiquidationIncentive, minLiquidationIncentive)) {
1013             return fail(Error.INVALID_LIQUIDATION_INCENTIVE, FailureInfo.SET_LIQUIDATION_INCENTIVE_VALIDATION);
1014         }
1015 
1016         Exp memory maxLiquidationIncentive = Exp({mantissa: liquidationIncentiveMaxMantissa});
1017         if (lessThanExp(maxLiquidationIncentive, newLiquidationIncentive)) {
1018             return fail(Error.INVALID_LIQUIDATION_INCENTIVE, FailureInfo.SET_LIQUIDATION_INCENTIVE_VALIDATION);
1019         }
1020 
1021         // Save current value for use in log
1022         uint256 oldLiquidationIncentiveMantissa = liquidationIncentiveMantissa;
1023 
1024         // Set liquidation incentive to new incentive
1025         liquidationIncentiveMantissa = newLiquidationIncentiveMantissa;
1026 
1027         // Emit event with old incentive, new incentive
1028         emit NewLiquidationIncentive(oldLiquidationIncentiveMantissa, newLiquidationIncentiveMantissa);
1029 
1030         return uint256(Error.NO_ERROR);
1031     }
1032 
1033     /**
1034      * @notice Add the market to the markets mapping and set it as listed
1035      * @dev Admin function to set isListed and add support for the market
1036      * @param cToken The address of the market (token) to list
1037      * @return uint 0=success, otherwise a failure. (See enum Error for details)
1038      */
1039     function _supportMarket(CToken cToken) external returns (uint256) {
1040         if (msg.sender != admin) {
1041             return fail(Error.UNAUTHORIZED, FailureInfo.SUPPORT_MARKET_OWNER_CHECK);
1042         }
1043 
1044         if (markets[address(cToken)].isListed) {
1045             return fail(Error.MARKET_ALREADY_LISTED, FailureInfo.SUPPORT_MARKET_EXISTS);
1046         }
1047 
1048         cToken.isCToken(); // Sanity check to make sure its really a CToken
1049 
1050         markets[address(cToken)] = Market({isListed: true, collateralFactorMantissa: 0});
1051         emit MarketListed(cToken);
1052 
1053         return uint256(Error.NO_ERROR);
1054     }
1055 
1056     function _become(
1057         Unitroller unitroller,
1058         PriceOracle _oracle,
1059         uint256 _closeFactorMantissa,
1060         uint256 _maxAssets,
1061         bool reinitializing
1062     ) public {
1063         require(msg.sender == unitroller.admin(), "only unitroller admin can change brains");
1064         uint256 changeStatus = unitroller._acceptImplementation();
1065 
1066         require(changeStatus == 0, "change not authorized");
1067 
1068         if (!reinitializing) {
1069             ComptrollerG1 freshBrainedComptroller = ComptrollerG1(address(unitroller));
1070 
1071             // Ensure invoke _setPriceOracle() = 0
1072             uint256 err = freshBrainedComptroller._setPriceOracle(_oracle);
1073             require(err == uint256(Error.NO_ERROR), "set price oracle error");
1074 
1075             // Ensure invoke _setCloseFactor() = 0
1076             err = freshBrainedComptroller._setCloseFactor(_closeFactorMantissa);
1077             require(err == uint256(Error.NO_ERROR), "set close factor error");
1078 
1079             // Ensure invoke _setMaxAssets() = 0
1080             err = freshBrainedComptroller._setMaxAssets(_maxAssets);
1081             require(err == uint256(Error.NO_ERROR), "set max asssets error");
1082 
1083             // Ensure invoke _setLiquidationIncentive(liquidationIncentiveMinMantissa) = 0
1084             err = freshBrainedComptroller._setLiquidationIncentive(liquidationIncentiveMinMantissa);
1085             require(err == uint256(Error.NO_ERROR), "set liquidation incentive error");
1086         }
1087     }
1088 
1089     /**
1090      * @dev Check that caller is admin or this contract is initializing itself as
1091      * the new implementation.
1092      * There should be no way to satisfy msg.sender == comptrollerImplementaiton
1093      * without tx.origin also being admin, but both are included for extra safety
1094      */
1095     function adminOrInitializing() internal view returns (bool) {
1096         bool initializing = (msg.sender == comptrollerImplementation &&
1097             //solium-disable-next-line security/no-tx-origin
1098             tx.origin == admin);
1099         bool isAdmin = msg.sender == admin;
1100         return isAdmin || initializing;
1101     }
1102 }
