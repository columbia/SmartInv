1 pragma solidity ^0.5.16;
2 
3 import "./CToken.sol";
4 import "./ErrorReporter.sol";
5 import "./Exponential.sol";
6 import "./PriceOracle/PriceOracle.sol";
7 import "./ComptrollerInterface.sol";
8 import "./ComptrollerStorage.sol";
9 import "./LiquidityMiningInterface.sol";
10 import "./Unitroller.sol";
11 import "./Governance/Comp.sol";
12 
13 /**
14  * @title Compound's Comptroller Contract
15  * @author Compound (modified by Cream)
16  */
17 contract Comptroller is ComptrollerV7Storage, ComptrollerInterface, ComptrollerErrorReporter, Exponential {
18     /// @notice Emitted when an admin supports a market
19     event MarketListed(CToken cToken);
20 
21     /// @notice Emitted when an admin delists a market
22     event MarketDelisted(CToken cToken);
23 
24     /// @notice Emitted when an account enters a market
25     event MarketEntered(CToken cToken, address account);
26 
27     /// @notice Emitted when an account exits a market
28     event MarketExited(CToken cToken, address account);
29 
30     /// @notice Emitted when close factor is changed by admin
31     event NewCloseFactor(uint256 oldCloseFactorMantissa, uint256 newCloseFactorMantissa);
32 
33     /// @notice Emitted when a collateral factor is changed by admin
34     event NewCollateralFactor(CToken cToken, uint256 oldCollateralFactorMantissa, uint256 newCollateralFactorMantissa);
35 
36     /// @notice Emitted when liquidation incentive is changed by admin
37     event NewLiquidationIncentive(uint256 oldLiquidationIncentiveMantissa, uint256 newLiquidationIncentiveMantissa);
38 
39     /// @notice Emitted when price oracle is changed
40     event NewPriceOracle(PriceOracle oldPriceOracle, PriceOracle newPriceOracle);
41 
42     /// @notice Emitted when pause guardian is changed
43     event NewPauseGuardian(address oldPauseGuardian, address newPauseGuardian);
44 
45     /// @notice Emitted when liquidity mining module is changed
46     event NewLiquidityMining(address oldLiquidityMining, address newLiquidityMining);
47 
48     /// @notice Emitted when an action is paused globally
49     event ActionPaused(string action, bool pauseState);
50 
51     /// @notice Emitted when an action is paused on a market
52     event ActionPaused(CToken cToken, string action, bool pauseState);
53 
54     /// @notice Emitted when COMP is distributed to a supplier
55     event DistributedSupplierComp(
56         CToken indexed cToken,
57         address indexed supplier,
58         uint256 compDelta,
59         uint256 compSupplyIndex
60     );
61 
62     /// @notice Emitted when COMP is distributed to a borrower
63     event DistributedBorrowerComp(
64         CToken indexed cToken,
65         address indexed borrower,
66         uint256 compDelta,
67         uint256 compBorrowIndex
68     );
69 
70     /// @notice Emitted when borrow cap for a cToken is changed
71     event NewBorrowCap(CToken indexed cToken, uint256 newBorrowCap);
72 
73     /// @notice Emitted when borrow cap guardian is changed
74     event NewBorrowCapGuardian(address oldBorrowCapGuardian, address newBorrowCapGuardian);
75 
76     /// @notice Emitted when supply cap for a cToken is changed
77     event NewSupplyCap(CToken indexed cToken, uint256 newSupplyCap);
78 
79     /// @notice Emitted when supply cap guardian is changed
80     event NewSupplyCapGuardian(address oldSupplyCapGuardian, address newSupplyCapGuardian);
81 
82     /// @notice Emitted when cToken version is changed
83     event NewCTokenVersion(CToken cToken, Version oldVersion, Version newVersion);
84 
85     /// @notice The initial COMP index for a market
86     uint224 public constant compInitialIndex = 1e36;
87 
88     // No collateralFactorMantissa may exceed this value
89     uint256 internal constant collateralFactorMaxMantissa = 0.9e18; // 0.9
90 
91     constructor() public {
92         admin = msg.sender;
93     }
94 
95     /*** Assets You Are In ***/
96 
97     /**
98      * @notice Returns the assets an account has entered
99      * @param account The address of the account to pull assets for
100      * @return A dynamic list with the assets the account has entered
101      */
102     function getAssetsIn(address account) external view returns (CToken[] memory) {
103         CToken[] memory assetsIn = accountAssets[account];
104 
105         return assetsIn;
106     }
107 
108     /**
109      * @notice Returns whether the given account is entered in the given asset
110      * @param account The address of the account to check
111      * @param cToken The cToken to check
112      * @return True if the account is in the asset, otherwise false.
113      */
114     function checkMembership(address account, CToken cToken) external view returns (bool) {
115         return markets[address(cToken)].accountMembership[account];
116     }
117 
118     /**
119      * @notice Add assets to be included in account liquidity calculation
120      * @param cTokens The list of addresses of the cToken markets to be enabled
121      * @return Success indicator for whether each corresponding market was entered
122      */
123     function enterMarkets(address[] memory cTokens) public returns (uint256[] memory) {
124         uint256 len = cTokens.length;
125 
126         uint256[] memory results = new uint256[](len);
127         for (uint256 i = 0; i < len; i++) {
128             CToken cToken = CToken(cTokens[i]);
129 
130             results[i] = uint256(addToMarketInternal(cToken, msg.sender));
131         }
132 
133         return results;
134     }
135 
136     /**
137      * @notice Add the market to the borrower's "assets in" for liquidity calculations
138      * @param cToken The market to enter
139      * @param borrower The address of the account to modify
140      * @return Success indicator for whether the market was entered
141      */
142     function addToMarketInternal(CToken cToken, address borrower) internal returns (Error) {
143         Market storage marketToJoin = markets[address(cToken)];
144 
145         require(marketToJoin.isListed, "market not listed");
146 
147         if (marketToJoin.version == Version.COLLATERALCAP) {
148             // register collateral for the borrower if the token is CollateralCap version.
149             CCollateralCapErc20Interface(address(cToken)).registerCollateral(borrower);
150         }
151 
152         if (marketToJoin.accountMembership[borrower] == true) {
153             // already joined
154             return Error.NO_ERROR;
155         }
156 
157         // survived the gauntlet, add to list
158         // NOTE: we store these somewhat redundantly as a significant optimization
159         //  this avoids having to iterate through the list for the most common use cases
160         //  that is, only when we need to perform liquidity checks
161         //  and not whenever we want to check if an account is in a particular market
162         marketToJoin.accountMembership[borrower] = true;
163         accountAssets[borrower].push(cToken);
164 
165         emit MarketEntered(cToken, borrower);
166 
167         return Error.NO_ERROR;
168     }
169 
170     /**
171      * @notice Removes asset from sender's account liquidity calculation
172      * @dev Sender must not have an outstanding borrow balance in the asset,
173      *  or be providing necessary collateral for an outstanding borrow.
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
184         require(amountOwed == 0, "nonzero borrow balance");
185 
186         /* Fail if the sender is not permitted to redeem all of their tokens */
187         require(redeemAllowedInternal(cTokenAddress, msg.sender, tokensHeld) == 0, "failed to exit market");
188 
189         Market storage marketToExit = markets[cTokenAddress];
190 
191         if (marketToExit.version == Version.COLLATERALCAP) {
192             CCollateralCapErc20Interface(cTokenAddress).unregisterCollateral(msg.sender);
193         }
194 
195         /* Return true if the sender is not already ‘in’ the market */
196         if (!marketToExit.accountMembership[msg.sender]) {
197             return uint256(Error.NO_ERROR);
198         }
199 
200         /* Set cToken account membership to false */
201         delete marketToExit.accountMembership[msg.sender];
202 
203         /* Delete cToken from the account’s list of assets */
204         // load into memory for faster iteration
205         CToken[] memory userAssetList = accountAssets[msg.sender];
206         uint256 len = userAssetList.length;
207         uint256 assetIndex = len;
208         for (uint256 i = 0; i < len; i++) {
209             if (userAssetList[i] == cToken) {
210                 assetIndex = i;
211                 break;
212             }
213         }
214 
215         // We *must* have found the asset in the list or our redundant data structure is broken
216         assert(assetIndex < len);
217 
218         // copy last item in list to location of item to be removed, reduce length by 1
219         CToken[] storage storedList = accountAssets[msg.sender];
220         if (assetIndex != storedList.length - 1) {
221             storedList[assetIndex] = storedList[storedList.length - 1];
222         }
223         storedList.length--;
224 
225         emit MarketExited(cToken, msg.sender);
226 
227         return uint256(Error.NO_ERROR);
228     }
229 
230     /**
231      * @notice Return a specific market is listed or not
232      * @param cTokenAddress The address of the asset to be checked
233      * @return Whether or not the market is listed
234      */
235     function isMarketListed(address cTokenAddress) public view returns (bool) {
236         return markets[cTokenAddress].isListed;
237     }
238 
239     /*** Policy Hooks ***/
240 
241     /**
242      * @notice Checks if the account should be allowed to mint tokens in the given market
243      * @param cToken The market to verify the mint against
244      * @param minter The account which would get the minted tokens
245      * @param mintAmount The amount of underlying being supplied to the market in exchange for tokens
246      * @return 0 if the mint is allowed, otherwise a semi-opaque error code (See ErrorReporter.sol)
247      */
248     function mintAllowed(
249         address cToken,
250         address minter,
251         uint256 mintAmount
252     ) external returns (uint256) {
253         // Pausing is a very serious situation - we revert to sound the alarms
254         require(!mintGuardianPaused[cToken], "mint is paused");
255 
256         // Shh - currently unused
257         minter;
258 
259         require(isMarketListed(cToken), "market not listed");
260 
261         uint256 supplyCap = supplyCaps[cToken];
262         // Supply cap of 0 corresponds to unlimited supplying
263         if (supplyCap != 0) {
264             uint256 totalCash = CToken(cToken).getCash();
265             uint256 totalBorrows = CToken(cToken).totalBorrows();
266             uint256 totalReserves = CToken(cToken).totalReserves();
267             // totalSupplies = totalCash + totalBorrows - totalReserves
268             (MathError mathErr, uint256 totalSupplies) = addThenSubUInt(totalCash, totalBorrows, totalReserves);
269             require(mathErr == MathError.NO_ERROR, "totalSupplies failed");
270 
271             uint256 nextTotalSupplies = add_(totalSupplies, mintAmount);
272             require(nextTotalSupplies < supplyCap, "market supply cap reached");
273         }
274 
275         return uint256(Error.NO_ERROR);
276     }
277 
278     /**
279      * @notice Validates mint and reverts on rejection. May emit logs.
280      * @param cToken Asset being minted
281      * @param minter The address minting the tokens
282      * @param actualMintAmount The amount of the underlying asset being minted
283      * @param mintTokens The number of tokens being minted
284      */
285     function mintVerify(
286         address cToken,
287         address minter,
288         uint256 actualMintAmount,
289         uint256 mintTokens
290     ) external {
291         // Shh - currently unused
292         cToken;
293         minter;
294         actualMintAmount;
295         mintTokens;
296 
297         // Shh - we don't ever want this hook to be marked pure
298         if (false) {
299             maxAssets = maxAssets;
300         }
301     }
302 
303     /**
304      * @notice Checks if the account should be allowed to redeem tokens in the given market
305      * @param cToken The market to verify the redeem against
306      * @param redeemer The account which would redeem the tokens
307      * @param redeemTokens The number of cTokens to exchange for the underlying asset in the market
308      * @return 0 if the redeem is allowed, otherwise a semi-opaque error code (See ErrorReporter.sol)
309      */
310     function redeemAllowed(
311         address cToken,
312         address redeemer,
313         uint256 redeemTokens
314     ) external returns (uint256) {
315         return redeemAllowedInternal(cToken, redeemer, redeemTokens);
316     }
317 
318     function redeemAllowedInternal(
319         address cToken,
320         address redeemer,
321         uint256 redeemTokens
322     ) internal view returns (uint256) {
323         require(isMarketListed(cToken), "market not listed");
324 
325         /* If the redeemer is not 'in' the market, then we can bypass the liquidity check */
326         if (!markets[cToken].accountMembership[redeemer]) {
327             return uint256(Error.NO_ERROR);
328         }
329 
330         /* Otherwise, perform a hypothetical liquidity check to guard against shortfall */
331         (Error err, , uint256 shortfall) = getHypotheticalAccountLiquidityInternal(
332             redeemer,
333             CToken(cToken),
334             redeemTokens,
335             0
336         );
337         require(err == Error.NO_ERROR, "failed to get account liquidity");
338         require(shortfall == 0, "insufficient liquidity");
339 
340         return uint256(Error.NO_ERROR);
341     }
342 
343     /**
344      * @notice Validates redeem and reverts on rejection. May emit logs.
345      * @param cToken Asset being redeemed
346      * @param redeemer The address redeeming the tokens
347      * @param redeemAmount The amount of the underlying asset being redeemed
348      * @param redeemTokens The number of tokens being redeemed
349      */
350     function redeemVerify(
351         address cToken,
352         address redeemer,
353         uint256 redeemAmount,
354         uint256 redeemTokens
355     ) external {
356         // Shh - currently unused
357         cToken;
358         redeemer;
359 
360         // Require tokens is zero or amount is also zero
361         if (redeemTokens == 0 && redeemAmount > 0) {
362             revert("redeemTokens zero");
363         }
364     }
365 
366     /**
367      * @notice Checks if the account should be allowed to borrow the underlying asset of the given market
368      * @param cToken The market to verify the borrow against
369      * @param borrower The account which would borrow the asset
370      * @param borrowAmount The amount of underlying the account would borrow
371      * @return 0 if the borrow is allowed, otherwise a semi-opaque error code (See ErrorReporter.sol)
372      */
373     function borrowAllowed(
374         address cToken,
375         address borrower,
376         uint256 borrowAmount
377     ) external returns (uint256) {
378         // Pausing is a very serious situation - we revert to sound the alarms
379         require(!borrowGuardianPaused[cToken], "borrow is paused");
380 
381         require(isMarketListed(cToken), "market not listed");
382 
383         if (!markets[cToken].accountMembership[borrower]) {
384             // only cTokens may call borrowAllowed if borrower not in market
385             require(msg.sender == cToken, "sender must be cToken");
386 
387             // attempt to add borrower to the market
388             require(addToMarketInternal(CToken(msg.sender), borrower) == Error.NO_ERROR, "failed to add market");
389 
390             // it should be impossible to break the important invariant
391             assert(markets[cToken].accountMembership[borrower]);
392         }
393 
394         require(oracle.getUnderlyingPrice(CToken(cToken)) != 0, "price error");
395 
396         uint256 borrowCap = borrowCaps[cToken];
397         // Borrow cap of 0 corresponds to unlimited borrowing
398         if (borrowCap != 0) {
399             uint256 totalBorrows = CToken(cToken).totalBorrows();
400             uint256 nextTotalBorrows = add_(totalBorrows, borrowAmount);
401             require(nextTotalBorrows < borrowCap, "market borrow cap reached");
402         }
403 
404         (Error err, , uint256 shortfall) = getHypotheticalAccountLiquidityInternal(
405             borrower,
406             CToken(cToken),
407             0,
408             borrowAmount
409         );
410         require(err == Error.NO_ERROR, "failed to get account liquidity");
411         require(shortfall == 0, "insufficient liquidity");
412 
413         return uint256(Error.NO_ERROR);
414     }
415 
416     /**
417      * @notice Validates borrow and reverts on rejection. May emit logs.
418      * @param cToken Asset whose underlying is being borrowed
419      * @param borrower The address borrowing the underlying
420      * @param borrowAmount The amount of the underlying asset requested to borrow
421      */
422     function borrowVerify(
423         address cToken,
424         address borrower,
425         uint256 borrowAmount
426     ) external {
427         // Shh - currently unused
428         cToken;
429         borrower;
430         borrowAmount;
431 
432         // Shh - we don't ever want this hook to be marked pure
433         if (false) {
434             maxAssets = maxAssets;
435         }
436     }
437 
438     /**
439      * @notice Checks if the account should be allowed to repay a borrow in the given market
440      * @param cToken The market to verify the repay against
441      * @param payer The account which would repay the asset
442      * @param borrower The account which would borrowed the asset
443      * @param repayAmount The amount of the underlying asset the account would repay
444      * @return 0 if the repay is allowed, otherwise a semi-opaque error code (See ErrorReporter.sol)
445      */
446     function repayBorrowAllowed(
447         address cToken,
448         address payer,
449         address borrower,
450         uint256 repayAmount
451     ) external returns (uint256) {
452         // Shh - currently unused
453         payer;
454         borrower;
455         repayAmount;
456 
457         require(isMarketListed(cToken), "market not listed");
458 
459         return uint256(Error.NO_ERROR);
460     }
461 
462     /**
463      * @notice Validates repayBorrow and reverts on rejection. May emit logs.
464      * @param cToken Asset being repaid
465      * @param payer The address repaying the borrow
466      * @param borrower The address of the borrower
467      * @param actualRepayAmount The amount of underlying being repaid
468      */
469     function repayBorrowVerify(
470         address cToken,
471         address payer,
472         address borrower,
473         uint256 actualRepayAmount,
474         uint256 borrowerIndex
475     ) external {
476         // Shh - currently unused
477         cToken;
478         payer;
479         borrower;
480         actualRepayAmount;
481         borrowerIndex;
482 
483         // Shh - we don't ever want this hook to be marked pure
484         if (false) {
485             maxAssets = maxAssets;
486         }
487     }
488 
489     /**
490      * @notice Checks if the liquidation should be allowed to occur
491      * @param cTokenBorrowed Asset which was borrowed by the borrower
492      * @param cTokenCollateral Asset which was used as collateral and will be seized
493      * @param liquidator The address repaying the borrow and seizing the collateral
494      * @param borrower The address of the borrower
495      * @param repayAmount The amount of underlying being repaid
496      */
497     function liquidateBorrowAllowed(
498         address cTokenBorrowed,
499         address cTokenCollateral,
500         address liquidator,
501         address borrower,
502         uint256 repayAmount
503     ) external returns (uint256) {
504         // Shh - currently unused
505         liquidator;
506 
507         require(isMarketListed(cTokenBorrowed) && isMarketListed(cTokenCollateral), "market not listed");
508 
509         /* The borrower must have shortfall in order to be liquidatable */
510         (Error err, , uint256 shortfall) = getAccountLiquidityInternal(borrower);
511         require(err == Error.NO_ERROR, "failed to get account liquidity");
512         require(shortfall > 0, "insufficient shortfall");
513 
514         /* The liquidator may not repay more than what is allowed by the closeFactor */
515         uint256 borrowBalance = CToken(cTokenBorrowed).borrowBalanceStored(borrower);
516         uint256 maxClose = mul_ScalarTruncate(Exp({mantissa: closeFactorMantissa}), borrowBalance);
517         if (repayAmount > maxClose) {
518             return uint256(Error.TOO_MUCH_REPAY);
519         }
520 
521         return uint256(Error.NO_ERROR);
522     }
523 
524     /**
525      * @notice Validates liquidateBorrow and reverts on rejection. May emit logs.
526      * @param cTokenBorrowed Asset which was borrowed by the borrower
527      * @param cTokenCollateral Asset which was used as collateral and will be seized
528      * @param liquidator The address repaying the borrow and seizing the collateral
529      * @param borrower The address of the borrower
530      * @param actualRepayAmount The amount of underlying being repaid
531      */
532     function liquidateBorrowVerify(
533         address cTokenBorrowed,
534         address cTokenCollateral,
535         address liquidator,
536         address borrower,
537         uint256 actualRepayAmount,
538         uint256 seizeTokens
539     ) external {
540         // Shh - currently unused
541         cTokenBorrowed;
542         cTokenCollateral;
543         liquidator;
544         borrower;
545         actualRepayAmount;
546         seizeTokens;
547 
548         // Shh - we don't ever want this hook to be marked pure
549         if (false) {
550             maxAssets = maxAssets;
551         }
552     }
553 
554     /**
555      * @notice Checks if the seizing of assets should be allowed to occur
556      * @param cTokenCollateral Asset which was used as collateral and will be seized
557      * @param cTokenBorrowed Asset which was borrowed by the borrower
558      * @param liquidator The address repaying the borrow and seizing the collateral
559      * @param borrower The address of the borrower
560      * @param seizeTokens The number of collateral tokens to seize
561      */
562     function seizeAllowed(
563         address cTokenCollateral,
564         address cTokenBorrowed,
565         address liquidator,
566         address borrower,
567         uint256 seizeTokens
568     ) external returns (uint256) {
569         // Pausing is a very serious situation - we revert to sound the alarms
570         require(!seizeGuardianPaused, "seize is paused");
571 
572         // Shh - currently unused
573         liquidator;
574         borrower;
575         seizeTokens;
576 
577         require(isMarketListed(cTokenBorrowed) && isMarketListed(cTokenCollateral), "market not listed");
578         require(
579             CToken(cTokenCollateral).comptroller() == CToken(cTokenBorrowed).comptroller(),
580             "comptroller mismatched"
581         );
582 
583         return uint256(Error.NO_ERROR);
584     }
585 
586     /**
587      * @notice Validates seize and reverts on rejection. May emit logs.
588      * @param cTokenCollateral Asset which was used as collateral and will be seized
589      * @param cTokenBorrowed Asset which was borrowed by the borrower
590      * @param liquidator The address repaying the borrow and seizing the collateral
591      * @param borrower The address of the borrower
592      * @param seizeTokens The number of collateral tokens to seize
593      */
594     function seizeVerify(
595         address cTokenCollateral,
596         address cTokenBorrowed,
597         address liquidator,
598         address borrower,
599         uint256 seizeTokens
600     ) external {
601         // Shh - currently unused
602         cTokenCollateral;
603         cTokenBorrowed;
604         liquidator;
605         borrower;
606         seizeTokens;
607 
608         // Shh - we don't ever want this hook to be marked pure
609         if (false) {
610             maxAssets = maxAssets;
611         }
612     }
613 
614     /**
615      * @notice Checks if the account should be allowed to transfer tokens in the given market
616      * @param cToken The market to verify the transfer against
617      * @param src The account which sources the tokens
618      * @param dst The account which receives the tokens
619      * @param transferTokens The number of cTokens to transfer
620      * @return 0 if the transfer is allowed, otherwise a semi-opaque error code (See ErrorReporter.sol)
621      */
622     function transferAllowed(
623         address cToken,
624         address src,
625         address dst,
626         uint256 transferTokens
627     ) external returns (uint256) {
628         // Pausing is a very serious situation - we revert to sound the alarms
629         require(!transferGuardianPaused, "transfer is paused");
630 
631         // Shh - currently unused
632         dst;
633 
634         // Currently the only consideration is whether or not
635         //  the src is allowed to redeem this many tokens
636         return redeemAllowedInternal(cToken, src, transferTokens);
637     }
638 
639     /**
640      * @notice Validates transfer and reverts on rejection. May emit logs.
641      * @param cToken Asset being transferred
642      * @param src The account which sources the tokens
643      * @param dst The account which receives the tokens
644      * @param transferTokens The number of cTokens to transfer
645      */
646     function transferVerify(
647         address cToken,
648         address src,
649         address dst,
650         uint256 transferTokens
651     ) external {
652         // Shh - currently unused
653         cToken;
654         src;
655         dst;
656         transferTokens;
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
667      * @param receiver The account which receives the tokens
668      * @param amount The amount of the tokens
669      * @param params The other parameters
670      */
671 
672     function flashloanAllowed(
673         address cToken,
674         address receiver,
675         uint256 amount,
676         bytes calldata params
677     ) external view returns (bool) {
678         return !flashloanGuardianPaused[cToken];
679     }
680 
681     /**
682      * @notice Update CToken's version.
683      * @param cToken Version of the asset being updated
684      * @param newVersion The new version
685      */
686     function updateCTokenVersion(address cToken, Version newVersion) external {
687         require(msg.sender == cToken, "cToken only");
688 
689         // This function will be called when a new CToken implementation becomes active.
690         // If a new CToken is newly created, this market is not listed yet. The version of
691         // this market will be taken care of when calling `_supportMarket`.
692         if (isMarketListed(cToken)) {
693             Version oldVersion = markets[cToken].version;
694             markets[cToken].version = newVersion;
695 
696             emit NewCTokenVersion(CToken(cToken), oldVersion, newVersion);
697         }
698     }
699 
700     /*** Liquidity/Liquidation Calculations ***/
701 
702     /**
703      * @dev Local vars for avoiding stack-depth limits in calculating account liquidity.
704      *  Note that `cTokenBalance` is the number of cTokens the account owns in the market,
705      *  whereas `borrowBalance` is the amount of underlying that the account has borrowed.
706      */
707     struct AccountLiquidityLocalVars {
708         uint256 sumCollateral;
709         uint256 sumBorrowPlusEffects;
710         uint256 cTokenBalance;
711         uint256 borrowBalance;
712         uint256 exchangeRateMantissa;
713         uint256 oraclePriceMantissa;
714         Exp collateralFactor;
715         Exp exchangeRate;
716         Exp oraclePrice;
717         Exp tokensToDenom;
718     }
719 
720     /**
721      * @notice Determine the current account liquidity wrt collateral requirements
722      * @return (possible error code (semi-opaque),
723                 account liquidity in excess of collateral requirements,
724      *          account shortfall below collateral requirements)
725      */
726     function getAccountLiquidity(address account)
727         public
728         view
729         returns (
730             uint256,
731             uint256,
732             uint256
733         )
734     {
735         (Error err, uint256 liquidity, uint256 shortfall) = getHypotheticalAccountLiquidityInternal(
736             account,
737             CToken(0),
738             0,
739             0
740         );
741 
742         return (uint256(err), liquidity, shortfall);
743     }
744 
745     /**
746      * @notice Determine the current account liquidity wrt collateral requirements
747      * @return (possible error code,
748                 account liquidity in excess of collateral requirements,
749      *          account shortfall below collateral requirements)
750      */
751     function getAccountLiquidityInternal(address account)
752         internal
753         view
754         returns (
755             Error,
756             uint256,
757             uint256
758         )
759     {
760         return getHypotheticalAccountLiquidityInternal(account, CToken(0), 0, 0);
761     }
762 
763     /**
764      * @notice Determine what the account liquidity would be if the given amounts were redeemed/borrowed
765      * @param cTokenModify The market to hypothetically redeem/borrow in
766      * @param account The account to determine liquidity for
767      * @param redeemTokens The number of tokens to hypothetically redeem
768      * @param borrowAmount The amount of underlying to hypothetically borrow
769      * @return (possible error code (semi-opaque),
770                 hypothetical account liquidity in excess of collateral requirements,
771      *          hypothetical account shortfall below collateral requirements)
772      */
773     function getHypotheticalAccountLiquidity(
774         address account,
775         address cTokenModify,
776         uint256 redeemTokens,
777         uint256 borrowAmount
778     )
779         public
780         view
781         returns (
782             uint256,
783             uint256,
784             uint256
785         )
786     {
787         (Error err, uint256 liquidity, uint256 shortfall) = getHypotheticalAccountLiquidityInternal(
788             account,
789             CToken(cTokenModify),
790             redeemTokens,
791             borrowAmount
792         );
793         return (uint256(err), liquidity, shortfall);
794     }
795 
796     /**
797      * @notice Determine what the account liquidity would be if the given amounts were redeemed/borrowed
798      * @param cTokenModify The market to hypothetically redeem/borrow in
799      * @param account The account to determine liquidity for
800      * @param redeemTokens The number of tokens to hypothetically redeem
801      * @param borrowAmount The amount of underlying to hypothetically borrow
802      * @dev Note that we calculate the exchangeRateStored for each collateral cToken using stored data,
803      *  without calculating accumulated interest.
804      * @return (possible error code,
805                 hypothetical account liquidity in excess of collateral requirements,
806      *          hypothetical account shortfall below collateral requirements)
807      */
808     function getHypotheticalAccountLiquidityInternal(
809         address account,
810         CToken cTokenModify,
811         uint256 redeemTokens,
812         uint256 borrowAmount
813     )
814         internal
815         view
816         returns (
817             Error,
818             uint256,
819             uint256
820         )
821     {
822         AccountLiquidityLocalVars memory vars; // Holds all our calculation results
823         uint256 oErr;
824 
825         // For each asset the account is in
826         CToken[] memory assets = accountAssets[account];
827         for (uint256 i = 0; i < assets.length; i++) {
828             CToken asset = assets[i];
829 
830             // Read the balances and exchange rate from the cToken
831             (oErr, vars.cTokenBalance, vars.borrowBalance, vars.exchangeRateMantissa) = asset.getAccountSnapshot(
832                 account
833             );
834             require(oErr == 0, "snapshot error");
835 
836             // Unlike compound protocol, getUnderlyingPrice is relatively expensive because we use ChainLink as our primary price feed.
837             // If user has no supply / borrow balance on this asset, and user is not redeeming / borrowing this asset, skip it.
838             if (vars.cTokenBalance == 0 && vars.borrowBalance == 0 && asset != cTokenModify) {
839                 continue;
840             }
841 
842             vars.collateralFactor = Exp({mantissa: markets[address(asset)].collateralFactorMantissa});
843             vars.exchangeRate = Exp({mantissa: vars.exchangeRateMantissa});
844 
845             // Get the normalized price of the asset
846             vars.oraclePriceMantissa = oracle.getUnderlyingPrice(asset);
847             require(vars.oraclePriceMantissa > 0, "price error");
848             vars.oraclePrice = Exp({mantissa: vars.oraclePriceMantissa});
849 
850             // Pre-compute a conversion factor from tokens -> ether (normalized price value)
851             vars.tokensToDenom = mul_(mul_(vars.collateralFactor, vars.exchangeRate), vars.oraclePrice);
852 
853             // sumCollateral += tokensToDenom * cTokenBalance
854             vars.sumCollateral = mul_ScalarTruncateAddUInt(vars.tokensToDenom, vars.cTokenBalance, vars.sumCollateral);
855 
856             // sumBorrowPlusEffects += oraclePrice * borrowBalance
857             vars.sumBorrowPlusEffects = mul_ScalarTruncateAddUInt(
858                 vars.oraclePrice,
859                 vars.borrowBalance,
860                 vars.sumBorrowPlusEffects
861             );
862 
863             // Calculate effects of interacting with cTokenModify
864             if (asset == cTokenModify) {
865                 // redeem effect
866                 // sumBorrowPlusEffects += tokensToDenom * redeemTokens
867                 vars.sumBorrowPlusEffects = mul_ScalarTruncateAddUInt(
868                     vars.tokensToDenom,
869                     redeemTokens,
870                     vars.sumBorrowPlusEffects
871                 );
872 
873                 // borrow effect
874                 // sumBorrowPlusEffects += oraclePrice * borrowAmount
875                 vars.sumBorrowPlusEffects = mul_ScalarTruncateAddUInt(
876                     vars.oraclePrice,
877                     borrowAmount,
878                     vars.sumBorrowPlusEffects
879                 );
880             }
881         }
882 
883         // These are safe, as the underflow condition is checked first
884         if (vars.sumCollateral > vars.sumBorrowPlusEffects) {
885             return (Error.NO_ERROR, vars.sumCollateral - vars.sumBorrowPlusEffects, 0);
886         } else {
887             return (Error.NO_ERROR, 0, vars.sumBorrowPlusEffects - vars.sumCollateral);
888         }
889     }
890 
891     /**
892      * @notice Calculate number of tokens of collateral asset to seize given an underlying amount
893      * @dev Used in liquidation (called in cToken.liquidateBorrowFresh)
894      * @param cTokenBorrowed The address of the borrowed cToken
895      * @param cTokenCollateral The address of the collateral cToken
896      * @param actualRepayAmount The amount of cTokenBorrowed underlying to convert into cTokenCollateral tokens
897      * @return (errorCode, number of cTokenCollateral tokens to be seized in a liquidation)
898      */
899     function liquidateCalculateSeizeTokens(
900         address cTokenBorrowed,
901         address cTokenCollateral,
902         uint256 actualRepayAmount
903     ) external view returns (uint256, uint256) {
904         /* Read oracle prices for borrowed and collateral markets */
905         uint256 priceBorrowedMantissa = oracle.getUnderlyingPrice(CToken(cTokenBorrowed));
906         uint256 priceCollateralMantissa = oracle.getUnderlyingPrice(CToken(cTokenCollateral));
907         require(priceBorrowedMantissa > 0 && priceCollateralMantissa > 0, "price error");
908 
909         /*
910          * Get the exchange rate and calculate the number of collateral tokens to seize:
911          *  seizeAmount = actualRepayAmount * liquidationIncentive * priceBorrowed / priceCollateral
912          *  seizeTokens = seizeAmount / exchangeRate
913          *   = actualRepayAmount * (liquidationIncentive * priceBorrowed) / (priceCollateral * exchangeRate)
914          */
915         uint256 exchangeRateMantissa = CToken(cTokenCollateral).exchangeRateStored(); // Note: reverts on error
916         Exp memory numerator = mul_(
917             Exp({mantissa: liquidationIncentiveMantissa}),
918             Exp({mantissa: priceBorrowedMantissa})
919         );
920         Exp memory denominator = mul_(Exp({mantissa: priceCollateralMantissa}), Exp({mantissa: exchangeRateMantissa}));
921         Exp memory ratio = div_(numerator, denominator);
922         uint256 seizeTokens = mul_ScalarTruncate(ratio, actualRepayAmount);
923 
924         return (uint256(Error.NO_ERROR), seizeTokens);
925     }
926 
927     /*** Admin Functions ***/
928 
929     /**
930      * @notice Sets a new price oracle for the comptroller
931      * @dev Admin function to set a new price oracle
932      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
933      */
934     function _setPriceOracle(PriceOracle newOracle) public returns (uint256) {
935         // Check caller is admin
936         if (msg.sender != admin) {
937             return fail(Error.UNAUTHORIZED, FailureInfo.SET_PRICE_ORACLE_OWNER_CHECK);
938         }
939 
940         // Track the old oracle for the comptroller
941         PriceOracle oldOracle = oracle;
942 
943         // Set comptroller's oracle to newOracle
944         oracle = newOracle;
945 
946         // Emit NewPriceOracle(oldOracle, newOracle)
947         emit NewPriceOracle(oldOracle, newOracle);
948 
949         return uint256(Error.NO_ERROR);
950     }
951 
952     /**
953      * @notice Sets the closeFactor used when liquidating borrows
954      * @dev Admin function to set closeFactor
955      * @param newCloseFactorMantissa New close factor, scaled by 1e18
956      * @return uint 0=success, otherwise a failure. (See ErrorReporter for details)
957      */
958     function _setCloseFactor(uint256 newCloseFactorMantissa) external returns (uint256) {
959         // Check caller is admin
960         if (msg.sender != admin) {
961             return fail(Error.UNAUTHORIZED, FailureInfo.SET_CLOSE_FACTOR_OWNER_CHECK);
962         }
963 
964         uint256 oldCloseFactorMantissa = closeFactorMantissa;
965         closeFactorMantissa = newCloseFactorMantissa;
966         emit NewCloseFactor(oldCloseFactorMantissa, closeFactorMantissa);
967 
968         return uint256(Error.NO_ERROR);
969     }
970 
971     /**
972      * @notice Sets the collateralFactor for a market
973      * @dev Admin function to set per-market collateralFactor
974      * @param cToken The market to set the factor on
975      * @param newCollateralFactorMantissa The new collateral factor, scaled by 1e18
976      * @return uint 0=success, otherwise a failure. (See ErrorReporter for details)
977      */
978     function _setCollateralFactor(CToken cToken, uint256 newCollateralFactorMantissa) external returns (uint256) {
979         // Check caller is admin
980         if (msg.sender != admin) {
981             return fail(Error.UNAUTHORIZED, FailureInfo.SET_COLLATERAL_FACTOR_OWNER_CHECK);
982         }
983 
984         // Verify market is listed
985         Market storage market = markets[address(cToken)];
986         if (!market.isListed) {
987             return fail(Error.MARKET_NOT_LISTED, FailureInfo.SET_COLLATERAL_FACTOR_NO_EXISTS);
988         }
989 
990         Exp memory newCollateralFactorExp = Exp({mantissa: newCollateralFactorMantissa});
991 
992         // Check collateral factor <= 0.9
993         Exp memory highLimit = Exp({mantissa: collateralFactorMaxMantissa});
994         if (lessThanExp(highLimit, newCollateralFactorExp)) {
995             return fail(Error.INVALID_COLLATERAL_FACTOR, FailureInfo.SET_COLLATERAL_FACTOR_VALIDATION);
996         }
997 
998         // If collateral factor != 0, fail if price == 0
999         if (newCollateralFactorMantissa != 0 && oracle.getUnderlyingPrice(cToken) == 0) {
1000             return fail(Error.PRICE_ERROR, FailureInfo.SET_COLLATERAL_FACTOR_WITHOUT_PRICE);
1001         }
1002 
1003         // Set market's collateral factor to new collateral factor, remember old value
1004         uint256 oldCollateralFactorMantissa = market.collateralFactorMantissa;
1005         market.collateralFactorMantissa = newCollateralFactorMantissa;
1006 
1007         // Emit event with asset, old collateral factor, and new collateral factor
1008         emit NewCollateralFactor(cToken, oldCollateralFactorMantissa, newCollateralFactorMantissa);
1009 
1010         return uint256(Error.NO_ERROR);
1011     }
1012 
1013     /**
1014      * @notice Sets liquidationIncentive
1015      * @dev Admin function to set liquidationIncentive
1016      * @param newLiquidationIncentiveMantissa New liquidationIncentive scaled by 1e18
1017      * @return uint 0=success, otherwise a failure. (See ErrorReporter for details)
1018      */
1019     function _setLiquidationIncentive(uint256 newLiquidationIncentiveMantissa) external returns (uint256) {
1020         // Check caller is admin
1021         if (msg.sender != admin) {
1022             return fail(Error.UNAUTHORIZED, FailureInfo.SET_LIQUIDATION_INCENTIVE_OWNER_CHECK);
1023         }
1024 
1025         // Save current value for use in log
1026         uint256 oldLiquidationIncentiveMantissa = liquidationIncentiveMantissa;
1027 
1028         // Set liquidation incentive to new incentive
1029         liquidationIncentiveMantissa = newLiquidationIncentiveMantissa;
1030 
1031         // Emit event with old incentive, new incentive
1032         emit NewLiquidationIncentive(oldLiquidationIncentiveMantissa, newLiquidationIncentiveMantissa);
1033 
1034         return uint256(Error.NO_ERROR);
1035     }
1036 
1037     /**
1038      * @notice Add the market to the markets mapping and set it as listed
1039      * @dev Admin function to set isListed and add support for the market
1040      * @param cToken The address of the market (token) to list
1041      * @param version The version of the market (token)
1042      * @return uint 0=success, otherwise a failure. (See enum Error for details)
1043      */
1044     function _supportMarket(CToken cToken, Version version) external returns (uint256) {
1045         require(msg.sender == admin, "admin only");
1046         require(!isMarketListed(address(cToken)), "market already listed");
1047 
1048         cToken.isCToken(); // Sanity check to make sure its really a CToken
1049 
1050         markets[address(cToken)] = Market({
1051             isListed: true,
1052             isComped: true,
1053             collateralFactorMantissa: 0,
1054             version: version
1055         });
1056 
1057         _addMarketInternal(address(cToken));
1058 
1059         emit MarketListed(cToken);
1060 
1061         return uint256(Error.NO_ERROR);
1062     }
1063 
1064     /**
1065      * @notice Remove the market from the markets mapping
1066      * @param cToken The address of the market (token) to delist
1067      */
1068     function _delistMarket(CToken cToken) external {
1069         require(msg.sender == admin, "admin only");
1070         require(isMarketListed(address(cToken)), "market not listed");
1071         require(cToken.totalSupply() == 0, "market not empty");
1072 
1073         cToken.isCToken(); // Sanity check to make sure its really a CToken
1074 
1075         delete markets[address(cToken)];
1076 
1077         for (uint256 i = 0; i < allMarkets.length; i++) {
1078             if (allMarkets[i] == cToken) {
1079                 allMarkets[i] = allMarkets[allMarkets.length - 1];
1080                 delete allMarkets[allMarkets.length - 1];
1081                 allMarkets.length--;
1082                 break;
1083             }
1084         }
1085 
1086         emit MarketDelisted(cToken);
1087     }
1088 
1089     function _addMarketInternal(address cToken) internal {
1090         for (uint256 i = 0; i < allMarkets.length; i++) {
1091             require(allMarkets[i] != CToken(cToken), "market already added");
1092         }
1093         allMarkets.push(CToken(cToken));
1094     }
1095 
1096     /**
1097      * @notice Admin function to change the Supply Cap Guardian
1098      * @param newSupplyCapGuardian The address of the new Supply Cap Guardian
1099      */
1100     function _setSupplyCapGuardian(address newSupplyCapGuardian) external {
1101         require(msg.sender == admin, "admin only");
1102 
1103         // Save current value for inclusion in log
1104         address oldSupplyCapGuardian = supplyCapGuardian;
1105 
1106         // Store supplyCapGuardian with value newSupplyCapGuardian
1107         supplyCapGuardian = newSupplyCapGuardian;
1108 
1109         // Emit NewSupplyCapGuardian(OldSupplyCapGuardian, NewSupplyCapGuardian)
1110         emit NewSupplyCapGuardian(oldSupplyCapGuardian, newSupplyCapGuardian);
1111     }
1112 
1113     /**
1114      * @notice Set the given supply caps for the given cToken markets. Supplying that brings total supplys to or above supply cap will revert.
1115      * @dev Admin or supplyCapGuardian function to set the supply caps. A supply cap of 0 corresponds to unlimited supplying. If the total borrows
1116      *      already exceeded the cap, it will prevent anyone to borrow.
1117      * @param cTokens The addresses of the markets (tokens) to change the supply caps for
1118      * @param newSupplyCaps The new supply cap values in underlying to be set. A value of 0 corresponds to unlimited supplying.
1119      */
1120     function _setMarketSupplyCaps(CToken[] calldata cTokens, uint256[] calldata newSupplyCaps) external {
1121         require(msg.sender == admin || msg.sender == supplyCapGuardian, "admin or supply cap guardian only");
1122 
1123         uint256 numMarkets = cTokens.length;
1124         uint256 numSupplyCaps = newSupplyCaps.length;
1125 
1126         require(numMarkets != 0 && numMarkets == numSupplyCaps, "invalid input");
1127 
1128         for (uint256 i = 0; i < numMarkets; i++) {
1129             supplyCaps[address(cTokens[i])] = newSupplyCaps[i];
1130             emit NewSupplyCap(cTokens[i], newSupplyCaps[i]);
1131         }
1132     }
1133 
1134     /**
1135      * @notice Set the given borrow caps for the given cToken markets. Borrowing that brings total borrows to or above borrow cap will revert.
1136      * @dev Admin or borrowCapGuardian function to set the borrow caps. A borrow cap of 0 corresponds to unlimited borrowing. If the total supplies
1137      *      already exceeded the cap, it will prevent anyone to mint.
1138      * @param cTokens The addresses of the markets (tokens) to change the borrow caps for
1139      * @param newBorrowCaps The new borrow cap values in underlying to be set. A value of 0 corresponds to unlimited borrowing.
1140      */
1141     function _setMarketBorrowCaps(CToken[] calldata cTokens, uint256[] calldata newBorrowCaps) external {
1142         require(msg.sender == admin || msg.sender == borrowCapGuardian, "admin or borrow cap guardian only");
1143 
1144         uint256 numMarkets = cTokens.length;
1145         uint256 numBorrowCaps = newBorrowCaps.length;
1146 
1147         require(numMarkets != 0 && numMarkets == numBorrowCaps, "invalid input");
1148 
1149         for (uint256 i = 0; i < numMarkets; i++) {
1150             borrowCaps[address(cTokens[i])] = newBorrowCaps[i];
1151             emit NewBorrowCap(cTokens[i], newBorrowCaps[i]);
1152         }
1153     }
1154 
1155     /**
1156      * @notice Admin function to change the Borrow Cap Guardian
1157      * @param newBorrowCapGuardian The address of the new Borrow Cap Guardian
1158      */
1159     function _setBorrowCapGuardian(address newBorrowCapGuardian) external {
1160         require(msg.sender == admin, "admin only");
1161 
1162         // Save current value for inclusion in log
1163         address oldBorrowCapGuardian = borrowCapGuardian;
1164 
1165         // Store borrowCapGuardian with value newBorrowCapGuardian
1166         borrowCapGuardian = newBorrowCapGuardian;
1167 
1168         // Emit NewBorrowCapGuardian(OldBorrowCapGuardian, NewBorrowCapGuardian)
1169         emit NewBorrowCapGuardian(oldBorrowCapGuardian, newBorrowCapGuardian);
1170     }
1171 
1172     /**
1173      * @notice Admin function to change the Pause Guardian
1174      * @param newPauseGuardian The address of the new Pause Guardian
1175      * @return uint 0=success, otherwise a failure. (See enum Error for details)
1176      */
1177     function _setPauseGuardian(address newPauseGuardian) public returns (uint256) {
1178         if (msg.sender != admin) {
1179             return fail(Error.UNAUTHORIZED, FailureInfo.SET_PAUSE_GUARDIAN_OWNER_CHECK);
1180         }
1181 
1182         // Save current value for inclusion in log
1183         address oldPauseGuardian = pauseGuardian;
1184 
1185         // Store pauseGuardian with value newPauseGuardian
1186         pauseGuardian = newPauseGuardian;
1187 
1188         // Emit NewPauseGuardian(OldPauseGuardian, NewPauseGuardian)
1189         emit NewPauseGuardian(oldPauseGuardian, pauseGuardian);
1190 
1191         return uint256(Error.NO_ERROR);
1192     }
1193 
1194     /**
1195      * @notice Admin function to set the liquidity mining module address
1196      * @dev Removing the liquidity mining module address could cause the inconsistency in the LM module.
1197      * @param newLiquidityMining The address of the new liquidity mining module
1198      */
1199     function _setLiquidityMining(address newLiquidityMining) external {
1200         require(msg.sender == admin, "admin only");
1201         require(LiquidityMiningInterface(newLiquidityMining).comptroller() == address(this), "mismatch comptroller");
1202 
1203         // Save current value for inclusion in log
1204         address oldLiquidityMining = liquidityMining;
1205 
1206         // Store pauseGuardian with value newLiquidityMining
1207         liquidityMining = newLiquidityMining;
1208 
1209         // Emit NewLiquidityMining(OldLiquidityMining, NewLiquidityMining)
1210         emit NewLiquidityMining(oldLiquidityMining, liquidityMining);
1211     }
1212 
1213     function _setMintPaused(CToken cToken, bool state) public returns (bool) {
1214         require(isMarketListed(address(cToken)), "market not listed");
1215         require(msg.sender == pauseGuardian || msg.sender == admin, "guardian or admin only");
1216         require(msg.sender == admin || state == true, "admin only");
1217 
1218         mintGuardianPaused[address(cToken)] = state;
1219         emit ActionPaused(cToken, "Mint", state);
1220         return state;
1221     }
1222 
1223     function _setBorrowPaused(CToken cToken, bool state) public returns (bool) {
1224         require(isMarketListed(address(cToken)), "market not listed");
1225         require(msg.sender == pauseGuardian || msg.sender == admin, "guardian or admin only");
1226         require(msg.sender == admin || state == true, "admin only");
1227 
1228         borrowGuardianPaused[address(cToken)] = state;
1229         emit ActionPaused(cToken, "Borrow", state);
1230         return state;
1231     }
1232 
1233     function _setFlashloanPaused(CToken cToken, bool state) public returns (bool) {
1234         require(isMarketListed(address(cToken)), "market not listed");
1235         require(msg.sender == pauseGuardian || msg.sender == admin, "guardian or admin only");
1236         require(msg.sender == admin || state == true, "admin only");
1237 
1238         flashloanGuardianPaused[address(cToken)] = state;
1239         emit ActionPaused(cToken, "Flashloan", state);
1240         return state;
1241     }
1242 
1243     function _setTransferPaused(bool state) public returns (bool) {
1244         require(msg.sender == pauseGuardian || msg.sender == admin, "guardian or admin only");
1245         require(msg.sender == admin || state == true, "admin only");
1246 
1247         transferGuardianPaused = state;
1248         emit ActionPaused("Transfer", state);
1249         return state;
1250     }
1251 
1252     function _setSeizePaused(bool state) public returns (bool) {
1253         require(msg.sender == pauseGuardian || msg.sender == admin, "guardian or admin only");
1254         require(msg.sender == admin || state == true, "admin only");
1255 
1256         seizeGuardianPaused = state;
1257         emit ActionPaused("Seize", state);
1258         return state;
1259     }
1260 
1261     function _become(Unitroller unitroller) public {
1262         require(msg.sender == unitroller.admin(), "unitroller admin only");
1263         require(unitroller._acceptImplementation() == 0, "unauthorized");
1264     }
1265 
1266     /*** Comp Distribution ***/
1267 
1268     /**
1269      * @notice Calculate COMP accrued by a supplier and possibly transfer it to them
1270      * @param cToken The market in which the supplier is interacting
1271      * @param supplier The address of the supplier to distribute COMP to
1272      */
1273     function distributeSupplierComp(address cToken, address supplier) internal {
1274         // We won't relaunch LM program on comptroller again. Do nothing if the user's supplierIndex is 0.
1275         if (compSupplierIndex[cToken][supplier] == 0) {
1276             return;
1277         }
1278 
1279         CompMarketState storage supplyState = compSupplyState[cToken];
1280         Double memory supplyIndex = Double({mantissa: supplyState.index});
1281         Double memory supplierIndex = Double({mantissa: compSupplierIndex[cToken][supplier]});
1282         compSupplierIndex[cToken][supplier] = supplyIndex.mantissa;
1283 
1284         if (supplierIndex.mantissa == 0 && supplyIndex.mantissa > 0) {
1285             supplierIndex.mantissa = compInitialIndex;
1286         }
1287 
1288         Double memory deltaIndex = sub_(supplyIndex, supplierIndex);
1289         uint256 supplierTokens = CToken(cToken).balanceOf(supplier);
1290         uint256 supplierDelta = mul_(supplierTokens, deltaIndex);
1291         uint256 supplierAccrued = add_(compAccrued[supplier], supplierDelta);
1292         compAccrued[supplier] = transferComp(supplier, supplierAccrued);
1293         emit DistributedSupplierComp(CToken(cToken), supplier, supplierDelta, supplyIndex.mantissa);
1294     }
1295 
1296     /**
1297      * @notice Calculate COMP accrued by a borrower and possibly transfer it to them
1298      * @dev Borrowers will not begin to accrue until after the first interaction with the protocol.
1299      * @param cToken The market in which the borrower is interacting
1300      * @param borrower The address of the borrower to distribute COMP to
1301      */
1302     function distributeBorrowerComp(
1303         address cToken,
1304         address borrower,
1305         Exp memory marketBorrowIndex
1306     ) internal {
1307         // We won't relaunch LM program on comptroller again. Do nothing if the user's borrowerIndex is 0.
1308         if (compBorrowerIndex[cToken][borrower] == 0) {
1309             return;
1310         }
1311 
1312         CompMarketState storage borrowState = compBorrowState[cToken];
1313         Double memory borrowIndex = Double({mantissa: borrowState.index});
1314         Double memory borrowerIndex = Double({mantissa: compBorrowerIndex[cToken][borrower]});
1315         compBorrowerIndex[cToken][borrower] = borrowIndex.mantissa;
1316 
1317         if (borrowerIndex.mantissa > 0) {
1318             Double memory deltaIndex = sub_(borrowIndex, borrowerIndex);
1319             uint256 borrowerAmount = div_(CToken(cToken).borrowBalanceStored(borrower), marketBorrowIndex);
1320             uint256 borrowerDelta = mul_(borrowerAmount, deltaIndex);
1321             uint256 borrowerAccrued = add_(compAccrued[borrower], borrowerDelta);
1322             compAccrued[borrower] = transferComp(borrower, borrowerAccrued);
1323             emit DistributedBorrowerComp(CToken(cToken), borrower, borrowerDelta, borrowIndex.mantissa);
1324         }
1325     }
1326 
1327     /**
1328      * @notice Transfer COMP to the user, if they are above the threshold
1329      * @dev Note: If there is not enough COMP, we do not perform the transfer all.
1330      * @param user The address of the user to transfer COMP to
1331      * @param userAccrued The amount of COMP to (possibly) transfer
1332      * @return The amount of COMP which was NOT transferred to the user
1333      */
1334     function transferComp(address user, uint256 userAccrued) internal returns (uint256) {
1335         if (userAccrued > 0) {
1336             Comp comp = Comp(getCompAddress());
1337             uint256 compRemaining = comp.balanceOf(address(this));
1338             if (userAccrued <= compRemaining) {
1339                 comp.transfer(user, userAccrued);
1340                 return 0;
1341             }
1342         }
1343         return userAccrued;
1344     }
1345 
1346     /**
1347      * @notice Claim all the comp accrued by holder in all markets
1348      * @param holder The address to claim COMP for
1349      */
1350     function claimComp(address holder) public {
1351         address[] memory holders = new address[](1);
1352         holders[0] = holder;
1353         return claimComp(holders, allMarkets, true, true);
1354     }
1355 
1356     /**
1357      * @notice Claim all comp accrued by the holders
1358      * @param holders The addresses to claim COMP for
1359      * @param cTokens The list of markets to claim COMP in
1360      * @param borrowers Whether or not to claim COMP earned by borrowing
1361      * @param suppliers Whether or not to claim COMP earned by supplying
1362      */
1363     function claimComp(
1364         address[] memory holders,
1365         CToken[] memory cTokens,
1366         bool borrowers,
1367         bool suppliers
1368     ) public {
1369         for (uint256 i = 0; i < cTokens.length; i++) {
1370             CToken cToken = cTokens[i];
1371             require(isMarketListed(address(cToken)), "market not listed");
1372             if (borrowers == true) {
1373                 Exp memory borrowIndex = Exp({mantissa: cToken.borrowIndex()});
1374                 for (uint256 j = 0; j < holders.length; j++) {
1375                     distributeBorrowerComp(address(cToken), holders[j], borrowIndex);
1376                 }
1377             }
1378             if (suppliers == true) {
1379                 for (uint256 j = 0; j < holders.length; j++) {
1380                     distributeSupplierComp(address(cToken), holders[j]);
1381                 }
1382             }
1383         }
1384     }
1385 
1386     /**
1387      * @notice Return all of the markets
1388      * @dev The automatic getter may be used to access an individual market.
1389      * @return The list of market addresses
1390      */
1391     function getAllMarkets() public view returns (CToken[] memory) {
1392         return allMarkets;
1393     }
1394 
1395     function getBlockNumber() public view returns (uint256) {
1396         return block.number;
1397     }
1398 
1399     /**
1400      * @notice Return the address of the COMP token
1401      * @return The address of COMP
1402      */
1403     function getCompAddress() public view returns (address) {
1404         return 0x2ba592F78dB6436527729929AAf6c908497cB200;
1405     }
1406 }
