1 pragma solidity ^0.5.16;
2 
3 import "./CToken.sol";
4 import "./CTokenCheckRepay.sol";
5 import "./ERC3156FlashLenderInterface.sol";
6 import "./ERC3156FlashBorrowerInterface.sol";
7 
8 /**
9  * @title Cream's CCollateralCapErc20CheckRepay Contract
10  * @notice CTokens which wrap an EIP-20 underlying with collateral cap
11  * @author Cream
12  */
13 contract CCollateralCapErc20CheckRepay is CTokenCheckRepay, CCollateralCapErc20Interface {
14     /**
15      * @notice Initialize the new money market
16      * @param underlying_ The address of the underlying asset
17      * @param comptroller_ The address of the Comptroller
18      * @param interestRateModel_ The address of the interest rate model
19      * @param initialExchangeRateMantissa_ The initial exchange rate, scaled by 1e18
20      * @param name_ ERC-20 name of this token
21      * @param symbol_ ERC-20 symbol of this token
22      * @param decimals_ ERC-20 decimal precision of this token
23      */
24     function initialize(
25         address underlying_,
26         ComptrollerInterface comptroller_,
27         InterestRateModel interestRateModel_,
28         uint256 initialExchangeRateMantissa_,
29         string memory name_,
30         string memory symbol_,
31         uint8 decimals_
32     ) public {
33         // CToken initialize does the bulk of the work
34         super.initialize(comptroller_, interestRateModel_, initialExchangeRateMantissa_, name_, symbol_, decimals_);
35 
36         // Set underlying and sanity check it
37         underlying = underlying_;
38         EIP20Interface(underlying).totalSupply();
39     }
40 
41     /*** User Interface ***/
42 
43     /**
44      * @notice Sender supplies assets into the market and receives cTokens in exchange
45      * @dev Accrues interest whether or not the operation succeeds, unless reverted
46      * @param mintAmount The amount of the underlying asset to supply
47      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
48      */
49     function mint(uint256 mintAmount) external returns (uint256) {
50         (uint256 err, ) = mintInternal(mintAmount, false);
51         return err;
52     }
53 
54     /**
55      * @notice Sender redeems cTokens in exchange for the underlying asset
56      * @dev Accrues interest whether or not the operation succeeds, unless reverted
57      * @param redeemTokens The number of cTokens to redeem into underlying
58      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
59      */
60     function redeem(uint256 redeemTokens) external returns (uint256) {
61         return redeemInternal(redeemTokens, false);
62     }
63 
64     /**
65      * @notice Sender redeems cTokens in exchange for a specified amount of underlying asset
66      * @dev Accrues interest whether or not the operation succeeds, unless reverted
67      * @param redeemAmount The amount of underlying to redeem
68      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
69      */
70     function redeemUnderlying(uint256 redeemAmount) external returns (uint256) {
71         return redeemUnderlyingInternal(redeemAmount, false);
72     }
73 
74     /**
75      * @notice Sender borrows assets from the protocol to their own address
76      * @param borrowAmount The amount of the underlying asset to borrow
77      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
78      */
79     function borrow(uint256 borrowAmount) external returns (uint256) {
80         return borrowInternal(borrowAmount, false);
81     }
82 
83     /**
84      * @notice Sender repays their own borrow
85      * @param repayAmount The amount to repay
86      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
87      */
88     function repayBorrow(uint256 repayAmount) external returns (uint256) {
89         (uint256 err, ) = repayBorrowInternal(repayAmount, false);
90         return err;
91     }
92 
93     /**
94      * @notice Sender repays a borrow belonging to borrower
95      * @param borrower the account with the debt being payed off
96      * @param repayAmount The amount to repay
97      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
98      */
99     function repayBorrowBehalf(address borrower, uint256 repayAmount) external returns (uint256) {
100         (uint256 err, ) = repayBorrowBehalfInternal(borrower, repayAmount, false);
101         return err;
102     }
103 
104     /**
105      * @notice The sender liquidates the borrowers collateral.
106      *  The collateral seized is transferred to the liquidator.
107      * @param borrower The borrower of this cToken to be liquidated
108      * @param repayAmount The amount of the underlying borrowed asset to repay
109      * @param cTokenCollateral The market in which to seize collateral from the borrower
110      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
111      */
112     function liquidateBorrow(
113         address borrower,
114         uint256 repayAmount,
115         CTokenInterface cTokenCollateral
116     ) external returns (uint256) {
117         (uint256 err, ) = liquidateBorrowInternal(borrower, repayAmount, cTokenCollateral, false);
118         return err;
119     }
120 
121     /**
122      * @notice The sender adds to reserves.
123      * @param addAmount The amount fo underlying token to add as reserves
124      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
125      */
126     function _addReserves(uint256 addAmount) external returns (uint256) {
127         return _addReservesInternal(addAmount, false);
128     }
129 
130     /**
131      * @notice Set the given collateral cap for the market.
132      * @param newCollateralCap New collateral cap for this market. A value of 0 corresponds to no cap.
133      */
134     function _setCollateralCap(uint256 newCollateralCap) external {
135         require(msg.sender == admin, "admin only");
136 
137         collateralCap = newCollateralCap;
138         emit NewCollateralCap(address(this), newCollateralCap);
139     }
140 
141     /**
142      * @notice Absorb excess cash into reserves.
143      */
144     function gulp() external nonReentrant {
145         uint256 cashOnChain = getCashOnChain();
146         uint256 cashPrior = getCashPrior();
147 
148         uint256 excessCash = sub_(cashOnChain, cashPrior);
149         totalReserves = add_(totalReserves, excessCash);
150         internalCash = cashOnChain;
151     }
152 
153     /**
154      * @notice Get the max flash loan amount
155      */
156     function maxFlashLoan() external view returns (uint256) {
157         uint256 amount = 0;
158         if (
159             ComptrollerInterfaceExtension(address(comptroller)).flashloanAllowed(address(this), address(0), amount, "")
160         ) {
161             amount = getCashPrior();
162         }
163         return amount;
164     }
165 
166     /**
167      * @notice Get the flash loan fees
168      * @param amount amount of token to borrow
169      */
170     function flashFee(uint256 amount) external view returns (uint256) {
171         require(
172             ComptrollerInterfaceExtension(address(comptroller)).flashloanAllowed(address(this), address(0), amount, ""),
173             "flashloan is paused"
174         );
175         return div_(mul_(amount, flashFeeBips), 10000);
176     }
177 
178     /**
179      * @notice Flash loan funds to a given account.
180      * @param receiver The receiver address for the funds
181      * @param initiator flash loan initiator
182      * @param amount The amount of the funds to be loaned
183      * @param data The other data
184      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
185      */
186     function flashLoan(
187         ERC3156FlashBorrowerInterface receiver,
188         address initiator,
189         uint256 amount,
190         bytes calldata data
191     ) external nonReentrant returns (bool) {
192         require(amount > 0, "invalid flashloan amount");
193         accrueInterest();
194         require(
195             ComptrollerInterfaceExtension(address(comptroller)).flashloanAllowed(
196                 address(this),
197                 address(receiver),
198                 amount,
199                 data
200             ),
201             "flashloan is paused"
202         );
203         uint256 cashOnChainBefore = getCashOnChain();
204         uint256 cashBefore = getCashPrior();
205         require(cashBefore >= amount, "INSUFFICIENT_LIQUIDITY");
206 
207         // 1. calculate fee, 1 bips = 1/10000
208         uint256 totalFee = this.flashFee(amount);
209 
210         // 2. transfer fund to receiver
211         doTransferOut(address(uint160(address(receiver))), amount, false);
212 
213         // 3. update totalBorrows
214         totalBorrows = add_(totalBorrows, amount);
215 
216         // 4. execute receiver's callback function
217 
218         require(
219             receiver.onFlashLoan(initiator, underlying, amount, totalFee, data) ==
220                 keccak256("ERC3156FlashBorrowerInterface.onFlashLoan"),
221             "IERC3156: Callback failed"
222         );
223 
224         // 5. take amount + fee from receiver, then check balance
225         uint256 repaymentAmount = add_(amount, totalFee);
226         doTransferIn(address(receiver), repaymentAmount, false);
227 
228         uint256 cashOnChainAfter = getCashOnChain();
229 
230         require(cashOnChainAfter == add_(cashOnChainBefore, totalFee), "BALANCE_INCONSISTENT");
231 
232         // 6. update reserves and internal cash and totalBorrows
233         uint256 reservesFee = mul_ScalarTruncate(Exp({mantissa: reserveFactorMantissa}), totalFee);
234         totalReserves = add_(totalReserves, reservesFee);
235         internalCash = add_(cashBefore, totalFee);
236         totalBorrows = sub_(totalBorrows, amount);
237 
238         emit Flashloan(address(receiver), amount, totalFee, reservesFee);
239         return true;
240     }
241 
242     /**
243      * @notice Register account collateral tokens if there is space.
244      * @param account The account to register
245      * @dev This function could only be called by comptroller.
246      * @return The actual registered amount of collateral
247      */
248     function registerCollateral(address account) external returns (uint256) {
249         // Make sure accountCollateralTokens of `account` is initialized.
250         initializeAccountCollateralTokens(account);
251 
252         require(msg.sender == address(comptroller), "comptroller only");
253 
254         uint256 amount = sub_(accountTokens[account], accountCollateralTokens[account]);
255         return increaseUserCollateralInternal(account, amount);
256     }
257 
258     /**
259      * @notice Unregister account collateral tokens if the account still has enough collateral.
260      * @dev This function could only be called by comptroller.
261      * @param account The account to unregister
262      */
263     function unregisterCollateral(address account) external {
264         // Make sure accountCollateralTokens of `account` is initialized.
265         initializeAccountCollateralTokens(account);
266 
267         require(msg.sender == address(comptroller), "comptroller only");
268         require(
269             comptroller.redeemAllowed(address(this), account, accountCollateralTokens[account]) == 0,
270             "comptroller rejection"
271         );
272 
273         decreaseUserCollateralInternal(account, accountCollateralTokens[account]);
274     }
275 
276     /*** Safe Token ***/
277 
278     /**
279      * @notice Gets internal balance of this contract in terms of the underlying.
280      *  It excludes balance from direct transfer.
281      * @dev This excludes the value of the current message, if any
282      * @return The quantity of underlying tokens owned by this contract
283      */
284     function getCashPrior() internal view returns (uint256) {
285         return internalCash;
286     }
287 
288     /**
289      * @notice Gets total balance of this contract in terms of the underlying
290      * @dev This excludes the value of the current message, if any
291      * @return The quantity of underlying tokens owned by this contract
292      */
293     function getCashOnChain() internal view returns (uint256) {
294         EIP20Interface token = EIP20Interface(underlying);
295         return token.balanceOf(address(this));
296     }
297 
298     /**
299      * @notice Initialize the account's collateral tokens. This function should be called in the beginning of every function
300      *  that accesses accountCollateralTokens or accountTokens.
301      * @param account The account of accountCollateralTokens that needs to be updated
302      */
303     function initializeAccountCollateralTokens(address account) internal {
304         /**
305          * If isCollateralTokenInit is false, it means accountCollateralTokens was not initialized yet.
306          * This case will only happen once and must be the very beginning. accountCollateralTokens is a new structure and its
307          * initial value should be equal to accountTokens if user has entered the market. However, it's almost impossible to
308          * check every user's value when the implementation becomes active. Therefore, it must rely on every action which will
309          * access accountTokens to call this function to check if accountCollateralTokens needed to be initialized.
310          */
311         if (!isCollateralTokenInit[account]) {
312             if (ComptrollerInterfaceExtension(address(comptroller)).checkMembership(account, CToken(address(this)))) {
313                 accountCollateralTokens[account] = accountTokens[account];
314                 totalCollateralTokens = add_(totalCollateralTokens, accountTokens[account]);
315 
316                 emit UserCollateralChanged(account, accountCollateralTokens[account]);
317             }
318             isCollateralTokenInit[account] = true;
319         }
320     }
321 
322     /**
323      * @dev Similar to EIP20 transfer, except it handles a False result from `transferFrom` and reverts in that case.
324      *      This will revert due to insufficient balance or insufficient allowance.
325      *      This function returns the actual amount received,
326      *      which may be less than `amount` if there is a fee attached to the transfer.
327      *
328      *      Note: This wrapper safely handles non-standard ERC-20 tokens that do not return a value.
329      *            See here: https://medium.com/coinmonks/missing-return-value-bug-at-least-130-tokens-affected-d67bf08521ca
330      */
331     function doTransferIn(
332         address from,
333         uint256 amount,
334         bool isNative
335     ) internal returns (uint256) {
336         isNative; // unused
337 
338         EIP20NonStandardInterface token = EIP20NonStandardInterface(underlying);
339         uint256 balanceBefore = EIP20Interface(underlying).balanceOf(address(this));
340         token.transferFrom(from, address(this), amount);
341 
342         bool success;
343         assembly {
344             switch returndatasize()
345             case 0 {
346                 // This is a non-standard ERC-20
347                 success := not(0) // set success to true
348             }
349             case 32 {
350                 // This is a compliant ERC-20
351                 returndatacopy(0, 0, 32)
352                 success := mload(0) // Set `success = returndata` of external call
353             }
354             default {
355                 // This is an excessively non-compliant ERC-20, revert.
356                 revert(0, 0)
357             }
358         }
359         require(success, "TOKEN_TRANSFER_IN_FAILED");
360 
361         // Calculate the amount that was *actually* transferred
362         uint256 balanceAfter = EIP20Interface(underlying).balanceOf(address(this));
363         uint256 transferredIn = sub_(balanceAfter, balanceBefore);
364         internalCash = add_(internalCash, transferredIn);
365         return transferredIn;
366     }
367 
368     /**
369      * @dev Similar to EIP20 transfer, except it handles a False success from `transfer` and returns an explanatory
370      *      error code rather than reverting. If caller has not called checked protocol's balance, this may revert due to
371      *      insufficient cash held in this contract. If caller has checked protocol's balance prior to this call, and verified
372      *      it is >= amount, this should not revert in normal conditions.
373      *
374      *      Note: This wrapper safely handles non-standard ERC-20 tokens that do not return a value.
375      *            See here: https://medium.com/coinmonks/missing-return-value-bug-at-least-130-tokens-affected-d67bf08521ca
376      */
377     function doTransferOut(
378         address payable to,
379         uint256 amount,
380         bool isNative
381     ) internal {
382         isNative; // unused
383 
384         EIP20NonStandardInterface token = EIP20NonStandardInterface(underlying);
385         token.transfer(to, amount);
386 
387         bool success;
388         assembly {
389             switch returndatasize()
390             case 0 {
391                 // This is a non-standard ERC-20
392                 success := not(0) // set success to true
393             }
394             case 32 {
395                 // This is a complaint ERC-20
396                 returndatacopy(0, 0, 32)
397                 success := mload(0) // Set `success = returndata` of external call
398             }
399             default {
400                 // This is an excessively non-compliant ERC-20, revert.
401                 revert(0, 0)
402             }
403         }
404         require(success, "TOKEN_TRANSFER_OUT_FAILED");
405         internalCash = sub_(internalCash, amount);
406     }
407 
408     /**
409      * @notice Transfer `tokens` tokens from `src` to `dst` by `spender`
410      * @dev Called by both `transfer` and `transferFrom` internally
411      * @param spender The address of the account performing the transfer
412      * @param src The address of the source account
413      * @param dst The address of the destination account
414      * @param tokens The number of tokens to transfer
415      * @return Whether or not the transfer succeeded
416      */
417     function transferTokens(
418         address spender,
419         address src,
420         address dst,
421         uint256 tokens
422     ) internal returns (uint256) {
423         // Make sure accountCollateralTokens of `src` and `dst` are initialized.
424         initializeAccountCollateralTokens(src);
425         initializeAccountCollateralTokens(dst);
426 
427         /**
428          * For every user, accountTokens must be greater than or equal to accountCollateralTokens.
429          * The buffer between the two values will be transferred first.
430          * bufferTokens = accountTokens[src] - accountCollateralTokens[src]
431          * collateralTokens = tokens - bufferTokens
432          */
433         uint256 bufferTokens = sub_(accountTokens[src], accountCollateralTokens[src]);
434         uint256 collateralTokens = 0;
435         if (tokens > bufferTokens) {
436             collateralTokens = tokens - bufferTokens;
437         }
438 
439         /**
440          * Since bufferTokens are not collateralized and can be transferred freely, we only check with comptroller
441          * whether collateralized tokens can be transferred.
442          */
443         require(comptroller.transferAllowed(address(this), src, dst, collateralTokens) == 0, "comptroller rejection");
444 
445         /* Do not allow self-transfers */
446         require(src != dst, "bad input");
447 
448         /* Get the allowance, infinite for the account owner */
449         uint256 startingAllowance = 0;
450         if (spender == src) {
451             startingAllowance = uint256(-1);
452         } else {
453             startingAllowance = transferAllowances[src][spender];
454         }
455 
456         /* Do the calculations, checking for {under,over}flow */
457         accountTokens[src] = sub_(accountTokens[src], tokens);
458         accountTokens[dst] = add_(accountTokens[dst], tokens);
459         if (collateralTokens > 0) {
460             accountCollateralTokens[src] = sub_(accountCollateralTokens[src], collateralTokens);
461             accountCollateralTokens[dst] = add_(accountCollateralTokens[dst], collateralTokens);
462 
463             emit UserCollateralChanged(src, accountCollateralTokens[src]);
464             emit UserCollateralChanged(dst, accountCollateralTokens[dst]);
465         }
466 
467         /* Eat some of the allowance (if necessary) */
468         if (startingAllowance != uint256(-1)) {
469             transferAllowances[src][spender] = sub_(startingAllowance, tokens);
470         }
471 
472         /* We emit a Transfer event */
473         emit Transfer(src, dst, tokens);
474 
475         comptroller.transferVerify(address(this), src, dst, tokens);
476 
477         return uint256(Error.NO_ERROR);
478     }
479 
480     /**
481      * @notice Get the account's cToken balances
482      * @param account The address of the account
483      */
484     function getCTokenBalanceInternal(address account) internal view returns (uint256) {
485         if (isCollateralTokenInit[account]) {
486             return accountCollateralTokens[account];
487         } else {
488             /**
489              * If the value of accountCollateralTokens was not initialized, we should return the value of accountTokens.
490              */
491             return accountTokens[account];
492         }
493     }
494 
495     /**
496      * @notice Increase user's collateral. Increase as much as we can.
497      * @param account The address of the account
498      * @param amount The amount of collateral user wants to increase
499      * @return The actual increased amount of collateral
500      */
501     function increaseUserCollateralInternal(address account, uint256 amount) internal returns (uint256) {
502         uint256 totalCollateralTokensNew = add_(totalCollateralTokens, amount);
503         if (collateralCap == 0 || (collateralCap != 0 && totalCollateralTokensNew <= collateralCap)) {
504             // 1. If collateral cap is not set,
505             // 2. If collateral cap is set but has enough space for this user,
506             // give all the user needs.
507             totalCollateralTokens = totalCollateralTokensNew;
508             accountCollateralTokens[account] = add_(accountCollateralTokens[account], amount);
509 
510             emit UserCollateralChanged(account, accountCollateralTokens[account]);
511             return amount;
512         } else if (collateralCap > totalCollateralTokens) {
513             // If the collateral cap is set but the remaining cap is not enough for this user,
514             // give the remaining parts to the user.
515             uint256 gap = sub_(collateralCap, totalCollateralTokens);
516             totalCollateralTokens = add_(totalCollateralTokens, gap);
517             accountCollateralTokens[account] = add_(accountCollateralTokens[account], gap);
518 
519             emit UserCollateralChanged(account, accountCollateralTokens[account]);
520             return gap;
521         }
522         return 0;
523     }
524 
525     /**
526      * @notice Decrease user's collateral. Reject if the amount can't be fully decrease.
527      * @param account The address of the account
528      * @param amount The amount of collateral user wants to decrease
529      */
530     function decreaseUserCollateralInternal(address account, uint256 amount) internal {
531         /*
532          * Return if amount is zero.
533          * Put behind `redeemAllowed` for accuring potential COMP rewards.
534          */
535         if (amount == 0) {
536             return;
537         }
538 
539         totalCollateralTokens = sub_(totalCollateralTokens, amount);
540         accountCollateralTokens[account] = sub_(accountCollateralTokens[account], amount);
541 
542         emit UserCollateralChanged(account, accountCollateralTokens[account]);
543     }
544 
545     struct MintLocalVars {
546         uint256 exchangeRateMantissa;
547         uint256 mintTokens;
548         uint256 actualMintAmount;
549     }
550 
551     /**
552      * @notice User supplies assets into the market and receives cTokens in exchange
553      * @dev Assumes interest has already been accrued up to the current block
554      * @param minter The address of the account which is supplying the assets
555      * @param mintAmount The amount of the underlying asset to supply
556      * @param isNative The amount is in native or not
557      * @return (uint, uint) An error code (0=success, otherwise a failure, see ErrorReporter.sol), and the actual mint amount.
558      */
559     function mintFresh(
560         address minter,
561         uint256 mintAmount,
562         bool isNative
563     ) internal returns (uint256, uint256) {
564         // Make sure accountCollateralTokens of `minter` is initialized.
565         initializeAccountCollateralTokens(minter);
566 
567         /* Fail if mint not allowed */
568         require(comptroller.mintAllowed(address(this), minter, mintAmount) == 0, "comptroller rejection");
569 
570         /*
571          * Return if mintAmount is zero.
572          * Put behind `mintAllowed` for accuring potential COMP rewards.
573          */
574         if (mintAmount == 0) {
575             return (uint256(Error.NO_ERROR), 0);
576         }
577 
578         /* Verify market's block number equals current block number */
579         require(accrualBlockNumber == getBlockNumber(), "market not fresh");
580 
581         MintLocalVars memory vars;
582 
583         vars.exchangeRateMantissa = exchangeRateStoredInternal();
584 
585         /////////////////////////
586         // EFFECTS & INTERACTIONS
587         // (No safe failures beyond this point)
588 
589         /*
590          *  We call `doTransferIn` for the minter and the mintAmount.
591          *  Note: The cToken must handle variations between ERC-20 and ETH underlying.
592          *  `doTransferIn` reverts if anything goes wrong, since we can't be sure if
593          *  side-effects occurred. The function returns the amount actually transferred,
594          *  in case of a fee. On success, the cToken holds an additional `actualMintAmount`
595          *  of cash.
596          */
597         vars.actualMintAmount = doTransferIn(minter, mintAmount, isNative);
598 
599         /*
600          * We get the current exchange rate and calculate the number of cTokens to be minted:
601          *  mintTokens = actualMintAmount / exchangeRate
602          */
603         vars.mintTokens = div_ScalarByExpTruncate(vars.actualMintAmount, Exp({mantissa: vars.exchangeRateMantissa}));
604 
605         /*
606          * We calculate the new total supply of cTokens and minter token balance, checking for overflow:
607          *  totalSupply = totalSupply + mintTokens
608          *  accountTokens[minter] = accountTokens[minter] + mintTokens
609          */
610         totalSupply = add_(totalSupply, vars.mintTokens);
611         accountTokens[minter] = add_(accountTokens[minter], vars.mintTokens);
612 
613         /*
614          * We only allocate collateral tokens if the minter has entered the market.
615          */
616         if (ComptrollerInterfaceExtension(address(comptroller)).checkMembership(minter, CToken(address(this)))) {
617             increaseUserCollateralInternal(minter, vars.mintTokens);
618         }
619 
620         /* We emit a Mint event, and a Transfer event */
621         emit Mint(minter, vars.actualMintAmount, vars.mintTokens);
622         emit Transfer(address(this), minter, vars.mintTokens);
623 
624         /* We call the defense hook */
625         comptroller.mintVerify(address(this), minter, vars.actualMintAmount, vars.mintTokens);
626 
627         return (uint256(Error.NO_ERROR), vars.actualMintAmount);
628     }
629 
630     struct RedeemLocalVars {
631         uint256 exchangeRateMantissa;
632         uint256 redeemTokens;
633         uint256 redeemAmount;
634     }
635 
636     /**
637      * @notice User redeems cTokens in exchange for the underlying asset
638      * @dev Assumes interest has already been accrued up to the current block. Only one of redeemTokensIn or redeemAmountIn may be non-zero and it would do nothing if both are zero.
639      * @param redeemer The address of the account which is redeeming the tokens
640      * @param redeemTokensIn The number of cTokens to redeem into underlying
641      * @param redeemAmountIn The number of underlying tokens to receive from redeeming cTokens
642      * @param isNative The amount is in native or not
643      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
644      */
645     function redeemFresh(
646         address payable redeemer,
647         uint256 redeemTokensIn,
648         uint256 redeemAmountIn,
649         bool isNative
650     ) internal returns (uint256) {
651         // Make sure accountCollateralTokens of `redeemer` is initialized.
652         initializeAccountCollateralTokens(redeemer);
653 
654         require(redeemTokensIn == 0 || redeemAmountIn == 0, "bad input");
655 
656         RedeemLocalVars memory vars;
657 
658         /* exchangeRate = invoke Exchange Rate Stored() */
659         vars.exchangeRateMantissa = exchangeRateStoredInternal();
660 
661         /* If redeemTokensIn > 0: */
662         if (redeemTokensIn > 0) {
663             /*
664              * We calculate the exchange rate and the amount of underlying to be redeemed:
665              *  redeemTokens = redeemTokensIn
666              *  redeemAmount = redeemTokensIn x exchangeRateCurrent
667              */
668             vars.redeemTokens = redeemTokensIn;
669             vars.redeemAmount = mul_ScalarTruncate(Exp({mantissa: vars.exchangeRateMantissa}), redeemTokensIn);
670         } else {
671             /*
672              * We get the current exchange rate and calculate the amount to be redeemed:
673              *  redeemTokens = redeemAmountIn / exchangeRate
674              *  redeemAmount = redeemAmountIn
675              */
676             vars.redeemTokens = div_ScalarByExpTruncate(redeemAmountIn, Exp({mantissa: vars.exchangeRateMantissa}));
677             vars.redeemAmount = redeemAmountIn;
678         }
679 
680         /**
681          * For every user, accountTokens must be greater than or equal to accountCollateralTokens.
682          * The buffer between the two values will be redeemed first.
683          * bufferTokens = accountTokens[redeemer] - accountCollateralTokens[redeemer]
684          * collateralTokens = redeemTokens - bufferTokens
685          */
686         uint256 bufferTokens = sub_(accountTokens[redeemer], accountCollateralTokens[redeemer]);
687         uint256 collateralTokens = 0;
688         if (vars.redeemTokens > bufferTokens) {
689             collateralTokens = vars.redeemTokens - bufferTokens;
690         }
691 
692         /* redeemAllowed might check more than user's liquidity. */
693         require(comptroller.redeemAllowed(address(this), redeemer, collateralTokens) == 0, "comptroller rejection");
694 
695         /* Verify market's block number equals current block number */
696         require(accrualBlockNumber == getBlockNumber(), "market not fresh");
697 
698         /* Reverts if protocol has insufficient cash */
699         require(getCashPrior() >= vars.redeemAmount, "insufficient cash");
700 
701         /////////////////////////
702         // EFFECTS & INTERACTIONS
703         // (No safe failures beyond this point)
704 
705         /*
706          * We calculate the new total supply and redeemer balance, checking for underflow:
707          *  totalSupplyNew = totalSupply - redeemTokens
708          *  accountTokensNew = accountTokens[redeemer] - redeemTokens
709          */
710         totalSupply = sub_(totalSupply, vars.redeemTokens);
711         accountTokens[redeemer] = sub_(accountTokens[redeemer], vars.redeemTokens);
712 
713         /*
714          * We only deallocate collateral tokens if the redeemer needs to redeem them.
715          */
716         decreaseUserCollateralInternal(redeemer, collateralTokens);
717 
718         /*
719          * We invoke doTransferOut for the redeemer and the redeemAmount.
720          *  Note: The cToken must handle variations between ERC-20 and ETH underlying.
721          *  On success, the cToken has redeemAmount less of cash.
722          *  doTransferOut reverts if anything goes wrong, since we can't be sure if side effects occurred.
723          */
724         doTransferOut(redeemer, vars.redeemAmount, isNative);
725 
726         /* We emit a Transfer event, and a Redeem event */
727         emit Transfer(redeemer, address(this), vars.redeemTokens);
728         emit Redeem(redeemer, vars.redeemAmount, vars.redeemTokens);
729 
730         /* We call the defense hook */
731         comptroller.redeemVerify(address(this), redeemer, vars.redeemAmount, vars.redeemTokens);
732 
733         return uint256(Error.NO_ERROR);
734     }
735 
736     /**
737      * @notice Transfers collateral tokens (this market) to the liquidator.
738      * @dev Called only during an in-kind liquidation, or by liquidateBorrow during the liquidation of another CToken.
739      *  Its absolutely critical to use msg.sender as the seizer cToken and not a parameter.
740      * @param seizerToken The contract seizing the collateral (i.e. borrowed cToken)
741      * @param liquidator The account receiving seized collateral
742      * @param borrower The account having collateral seized
743      * @param seizeTokens The number of cTokens to seize
744      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
745      */
746     function seizeInternal(
747         address seizerToken,
748         address liquidator,
749         address borrower,
750         uint256 seizeTokens
751     ) internal returns (uint256) {
752         // Make sure accountCollateralTokens of `liquidator` and `borrower` are initialized.
753         initializeAccountCollateralTokens(liquidator);
754         initializeAccountCollateralTokens(borrower);
755 
756         /* Fail if seize not allowed */
757         require(
758             comptroller.seizeAllowed(address(this), seizerToken, liquidator, borrower, seizeTokens) == 0,
759             "comptroller rejection"
760         );
761 
762         /*
763          * Return if seizeTokens is zero.
764          * Put behind `seizeAllowed` for accuring potential COMP rewards.
765          */
766         if (seizeTokens == 0) {
767             return uint256(Error.NO_ERROR);
768         }
769 
770         /* Fail if borrower = liquidator */
771         require(borrower != liquidator, "invalid account pair");
772 
773         /*
774          * We calculate the new borrower and liquidator token balances and token collateral balances, failing on underflow/overflow:
775          *  accountTokens[borrower] = accountTokens[borrower] - seizeTokens
776          *  accountTokens[liquidator] = accountTokens[liquidator] + seizeTokens
777          *  accountCollateralTokens[borrower] = accountCollateralTokens[borrower] - seizeTokens
778          *  accountCollateralTokens[liquidator] = accountCollateralTokens[liquidator] + seizeTokens
779          */
780         accountTokens[borrower] = sub_(accountTokens[borrower], seizeTokens);
781         accountTokens[liquidator] = add_(accountTokens[liquidator], seizeTokens);
782         accountCollateralTokens[borrower] = sub_(accountCollateralTokens[borrower], seizeTokens);
783         accountCollateralTokens[liquidator] = add_(accountCollateralTokens[liquidator], seizeTokens);
784 
785         /* Emit a Transfer, UserCollateralChanged events */
786         emit Transfer(borrower, liquidator, seizeTokens);
787         emit UserCollateralChanged(borrower, accountCollateralTokens[borrower]);
788         emit UserCollateralChanged(liquidator, accountCollateralTokens[liquidator]);
789 
790         /* We call the defense hook */
791         comptroller.seizeVerify(address(this), seizerToken, liquidator, borrower, seizeTokens);
792 
793         return uint256(Error.NO_ERROR);
794     }
795 }
