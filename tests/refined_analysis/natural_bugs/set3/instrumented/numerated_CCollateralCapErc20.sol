1 pragma solidity ^0.5.16;
2 
3 import "./CToken.sol";
4 import "./ERC3156FlashLenderInterface.sol";
5 import "./ERC3156FlashBorrowerInterface.sol";
6 
7 /**
8  * @title Cream's CCollateralCapErc20 Contract
9  * @notice CTokens which wrap an EIP-20 underlying with collateral cap
10  * @author Cream
11  */
12 contract CCollateralCapErc20 is CToken, CCollateralCapErc20Interface {
13     /**
14      * @notice Initialize the new money market
15      * @param underlying_ The address of the underlying asset
16      * @param comptroller_ The address of the Comptroller
17      * @param interestRateModel_ The address of the interest rate model
18      * @param initialExchangeRateMantissa_ The initial exchange rate, scaled by 1e18
19      * @param name_ ERC-20 name of this token
20      * @param symbol_ ERC-20 symbol of this token
21      * @param decimals_ ERC-20 decimal precision of this token
22      */
23     function initialize(
24         address underlying_,
25         ComptrollerInterface comptroller_,
26         InterestRateModel interestRateModel_,
27         uint256 initialExchangeRateMantissa_,
28         string memory name_,
29         string memory symbol_,
30         uint8 decimals_
31     ) public {
32         // CToken initialize does the bulk of the work
33         super.initialize(comptroller_, interestRateModel_, initialExchangeRateMantissa_, name_, symbol_, decimals_);
34 
35         // Set underlying and sanity check it
36         underlying = underlying_;
37         EIP20Interface(underlying).totalSupply();
38     }
39 
40     /*** User Interface ***/
41 
42     /**
43      * @notice Sender supplies assets into the market and receives cTokens in exchange
44      * @dev Accrues interest whether or not the operation succeeds, unless reverted
45      * @param mintAmount The amount of the underlying asset to supply
46      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
47      */
48     function mint(uint256 mintAmount) external returns (uint256) {
49         (uint256 err, ) = mintInternal(mintAmount, false);
50         require(err == 0, "mint failed");
51     }
52 
53     /**
54      * @notice Sender redeems cTokens in exchange for the underlying asset
55      * @dev Accrues interest whether or not the operation succeeds, unless reverted
56      * @param redeemTokens The number of cTokens to redeem into underlying
57      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
58      */
59     function redeem(uint256 redeemTokens) external returns (uint256) {
60         require(redeemInternal(redeemTokens, false) == 0, "redeem failed");
61     }
62 
63     /**
64      * @notice Sender redeems cTokens in exchange for a specified amount of underlying asset
65      * @dev Accrues interest whether or not the operation succeeds, unless reverted
66      * @param redeemAmount The amount of underlying to redeem
67      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
68      */
69     function redeemUnderlying(uint256 redeemAmount) external returns (uint256) {
70         require(redeemUnderlyingInternal(redeemAmount, false) == 0, "redeem underlying failed");
71     }
72 
73     /**
74      * @notice Sender borrows assets from the protocol to their own address
75      * @param borrowAmount The amount of the underlying asset to borrow
76      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
77      */
78     function borrow(uint256 borrowAmount) external returns (uint256) {
79         require(borrowInternal(borrowAmount, false) == 0, "borrow failed");
80     }
81 
82     /**
83      * @notice Sender repays their own borrow
84      * @param repayAmount The amount to repay
85      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
86      */
87     function repayBorrow(uint256 repayAmount) external returns (uint256) {
88         (uint256 err, ) = repayBorrowInternal(repayAmount, false);
89         require(err == 0, "repay failed");
90     }
91 
92     /**
93      * @notice Sender repays a borrow belonging to borrower
94      * @param borrower the account with the debt being payed off
95      * @param repayAmount The amount to repay
96      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
97      */
98     function repayBorrowBehalf(address borrower, uint256 repayAmount) external returns (uint256) {
99         (uint256 err, ) = repayBorrowBehalfInternal(borrower, repayAmount, false);
100         require(err == 0, "repay behalf failed");
101     }
102 
103     /**
104      * @notice The sender liquidates the borrowers collateral.
105      *  The collateral seized is transferred to the liquidator.
106      * @param borrower The borrower of this cToken to be liquidated
107      * @param repayAmount The amount of the underlying borrowed asset to repay
108      * @param cTokenCollateral The market in which to seize collateral from the borrower
109      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
110      */
111     function liquidateBorrow(
112         address borrower,
113         uint256 repayAmount,
114         CTokenInterface cTokenCollateral
115     ) external returns (uint256) {
116         (uint256 err, ) = liquidateBorrowInternal(borrower, repayAmount, cTokenCollateral, false);
117         require(err == 0, "liquidate borrow failed");
118     }
119 
120     /**
121      * @notice The sender adds to reserves.
122      * @param addAmount The amount fo underlying token to add as reserves
123      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
124      */
125     function _addReserves(uint256 addAmount) external returns (uint256) {
126         require(_addReservesInternal(addAmount, false) == 0, "add reserves failed");
127     }
128 
129     /**
130      * @notice Set the given collateral cap for the market.
131      * @param newCollateralCap New collateral cap for this market. A value of 0 corresponds to no cap.
132      */
133     function _setCollateralCap(uint256 newCollateralCap) external {
134         require(msg.sender == admin, "admin only");
135 
136         collateralCap = newCollateralCap;
137         emit NewCollateralCap(address(this), newCollateralCap);
138     }
139 
140     /**
141      * @notice Absorb excess cash into reserves.
142      */
143     function gulp() external nonReentrant {
144         uint256 cashOnChain = getCashOnChain();
145         uint256 cashPrior = getCashPrior();
146 
147         uint256 excessCash = sub_(cashOnChain, cashPrior);
148         totalReserves = add_(totalReserves, excessCash);
149         internalCash = cashOnChain;
150     }
151 
152     /**
153      * @notice Get the max flash loan amount
154      */
155     function maxFlashLoan() external view returns (uint256) {
156         uint256 amount = 0;
157         if (
158             ComptrollerInterfaceExtension(address(comptroller)).flashloanAllowed(address(this), address(0), amount, "")
159         ) {
160             amount = getCashPrior();
161         }
162         return amount;
163     }
164 
165     /**
166      * @notice Get the flash loan fees
167      * @param amount amount of token to borrow
168      */
169     function flashFee(uint256 amount) external view returns (uint256) {
170         require(
171             ComptrollerInterfaceExtension(address(comptroller)).flashloanAllowed(address(this), address(0), amount, ""),
172             "flashloan is paused"
173         );
174         return div_(mul_(amount, flashFeeBips), 10000);
175     }
176 
177     /**
178      * @notice Flash loan funds to a given account.
179      * @param receiver The receiver address for the funds
180      * @param initiator flash loan initiator
181      * @param amount The amount of the funds to be loaned
182      * @param data The other data
183      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
184      */
185     function flashLoan(
186         ERC3156FlashBorrowerInterface receiver,
187         address initiator,
188         uint256 amount,
189         bytes calldata data
190     ) external nonReentrant returns (bool) {
191         require(amount > 0, "invalid flashloan amount");
192         accrueInterest();
193         require(
194             ComptrollerInterfaceExtension(address(comptroller)).flashloanAllowed(
195                 address(this),
196                 address(receiver),
197                 amount,
198                 data
199             ),
200             "flashloan is paused"
201         );
202         uint256 cashOnChainBefore = getCashOnChain();
203         uint256 cashBefore = getCashPrior();
204         require(cashBefore >= amount, "INSUFFICIENT_LIQUIDITY");
205 
206         // 1. calculate fee, 1 bips = 1/10000
207         uint256 totalFee = this.flashFee(amount);
208 
209         // 2. transfer fund to receiver
210         doTransferOut(address(uint160(address(receiver))), amount, false);
211 
212         // 3. update totalBorrows
213         totalBorrows = add_(totalBorrows, amount);
214 
215         // 4. execute receiver's callback function
216 
217         require(
218             receiver.onFlashLoan(initiator, underlying, amount, totalFee, data) ==
219                 keccak256("ERC3156FlashBorrowerInterface.onFlashLoan"),
220             "IERC3156: Callback failed"
221         );
222 
223         // 5. take amount + fee from receiver, then check balance
224         uint256 repaymentAmount = add_(amount, totalFee);
225         doTransferIn(address(receiver), repaymentAmount, false);
226 
227         uint256 cashOnChainAfter = getCashOnChain();
228 
229         require(cashOnChainAfter == add_(cashOnChainBefore, totalFee), "BALANCE_INCONSISTENT");
230 
231         // 6. update reserves and internal cash and totalBorrows
232         uint256 reservesFee = mul_ScalarTruncate(Exp({mantissa: reserveFactorMantissa}), totalFee);
233         totalReserves = add_(totalReserves, reservesFee);
234         internalCash = add_(cashBefore, totalFee);
235         totalBorrows = sub_(totalBorrows, amount);
236 
237         emit Flashloan(address(receiver), amount, totalFee, reservesFee);
238         return true;
239     }
240 
241     /**
242      * @notice Register account collateral tokens if there is space.
243      * @param account The account to register
244      * @dev This function could only be called by comptroller.
245      * @return The actual registered amount of collateral
246      */
247     function registerCollateral(address account) external returns (uint256) {
248         // Make sure accountCollateralTokens of `account` is initialized.
249         initializeAccountCollateralTokens(account);
250 
251         require(msg.sender == address(comptroller), "comptroller only");
252 
253         uint256 amount = sub_(accountTokens[account], accountCollateralTokens[account]);
254         return increaseUserCollateralInternal(account, amount);
255     }
256 
257     /**
258      * @notice Unregister account collateral tokens if the account still has enough collateral.
259      * @dev This function could only be called by comptroller.
260      * @param account The account to unregister
261      */
262     function unregisterCollateral(address account) external {
263         // Make sure accountCollateralTokens of `account` is initialized.
264         initializeAccountCollateralTokens(account);
265 
266         require(msg.sender == address(comptroller), "comptroller only");
267         require(
268             comptroller.redeemAllowed(address(this), account, accountCollateralTokens[account]) == 0,
269             "comptroller rejection"
270         );
271 
272         decreaseUserCollateralInternal(account, accountCollateralTokens[account]);
273     }
274 
275     /*** Safe Token ***/
276 
277     /**
278      * @notice Gets internal balance of this contract in terms of the underlying.
279      *  It excludes balance from direct transfer.
280      * @dev This excludes the value of the current message, if any
281      * @return The quantity of underlying tokens owned by this contract
282      */
283     function getCashPrior() internal view returns (uint256) {
284         return internalCash;
285     }
286 
287     /**
288      * @notice Gets total balance of this contract in terms of the underlying
289      * @dev This excludes the value of the current message, if any
290      * @return The quantity of underlying tokens owned by this contract
291      */
292     function getCashOnChain() internal view returns (uint256) {
293         EIP20Interface token = EIP20Interface(underlying);
294         return token.balanceOf(address(this));
295     }
296 
297     /**
298      * @notice Initialize the account's collateral tokens. This function should be called in the beginning of every function
299      *  that accesses accountCollateralTokens or accountTokens.
300      * @param account The account of accountCollateralTokens that needs to be updated
301      */
302     function initializeAccountCollateralTokens(address account) internal {
303         /**
304          * If isCollateralTokenInit is false, it means accountCollateralTokens was not initialized yet.
305          * This case will only happen once and must be the very beginning. accountCollateralTokens is a new structure and its
306          * initial value should be equal to accountTokens if user has entered the market. However, it's almost impossible to
307          * check every user's value when the implementation becomes active. Therefore, it must rely on every action which will
308          * access accountTokens to call this function to check if accountCollateralTokens needed to be initialized.
309          */
310         if (!isCollateralTokenInit[account]) {
311             if (ComptrollerInterfaceExtension(address(comptroller)).checkMembership(account, CToken(this))) {
312                 accountCollateralTokens[account] = accountTokens[account];
313                 totalCollateralTokens = add_(totalCollateralTokens, accountTokens[account]);
314 
315                 emit UserCollateralChanged(account, accountCollateralTokens[account]);
316             }
317             isCollateralTokenInit[account] = true;
318         }
319     }
320 
321     /**
322      * @dev Similar to EIP20 transfer, except it handles a False result from `transferFrom` and reverts in that case.
323      *      This will revert due to insufficient balance or insufficient allowance.
324      *      This function returns the actual amount received,
325      *      which may be less than `amount` if there is a fee attached to the transfer.
326      *
327      *      Note: This wrapper safely handles non-standard ERC-20 tokens that do not return a value.
328      *            See here: https://medium.com/coinmonks/missing-return-value-bug-at-least-130-tokens-affected-d67bf08521ca
329      */
330     function doTransferIn(
331         address from,
332         uint256 amount,
333         bool isNative
334     ) internal returns (uint256) {
335         isNative; // unused
336 
337         EIP20NonStandardInterface token = EIP20NonStandardInterface(underlying);
338         uint256 balanceBefore = EIP20Interface(underlying).balanceOf(address(this));
339         token.transferFrom(from, address(this), amount);
340 
341         bool success;
342         assembly {
343             switch returndatasize()
344             case 0 {
345                 // This is a non-standard ERC-20
346                 success := not(0) // set success to true
347             }
348             case 32 {
349                 // This is a compliant ERC-20
350                 returndatacopy(0, 0, 32)
351                 success := mload(0) // Set `success = returndata` of external call
352             }
353             default {
354                 // This is an excessively non-compliant ERC-20, revert.
355                 revert(0, 0)
356             }
357         }
358         require(success, "TOKEN_TRANSFER_IN_FAILED");
359 
360         // Calculate the amount that was *actually* transferred
361         uint256 balanceAfter = EIP20Interface(underlying).balanceOf(address(this));
362         uint256 transferredIn = sub_(balanceAfter, balanceBefore);
363         internalCash = add_(internalCash, transferredIn);
364         return transferredIn;
365     }
366 
367     /**
368      * @dev Similar to EIP20 transfer, except it handles a False success from `transfer` and returns an explanatory
369      *      error code rather than reverting. If caller has not called checked protocol's balance, this may revert due to
370      *      insufficient cash held in this contract. If caller has checked protocol's balance prior to this call, and verified
371      *      it is >= amount, this should not revert in normal conditions.
372      *
373      *      Note: This wrapper safely handles non-standard ERC-20 tokens that do not return a value.
374      *            See here: https://medium.com/coinmonks/missing-return-value-bug-at-least-130-tokens-affected-d67bf08521ca
375      */
376     function doTransferOut(
377         address payable to,
378         uint256 amount,
379         bool isNative
380     ) internal {
381         isNative; // unused
382 
383         EIP20NonStandardInterface token = EIP20NonStandardInterface(underlying);
384         token.transfer(to, amount);
385 
386         bool success;
387         assembly {
388             switch returndatasize()
389             case 0 {
390                 // This is a non-standard ERC-20
391                 success := not(0) // set success to true
392             }
393             case 32 {
394                 // This is a complaint ERC-20
395                 returndatacopy(0, 0, 32)
396                 success := mload(0) // Set `success = returndata` of external call
397             }
398             default {
399                 // This is an excessively non-compliant ERC-20, revert.
400                 revert(0, 0)
401             }
402         }
403         require(success, "TOKEN_TRANSFER_OUT_FAILED");
404         internalCash = sub_(internalCash, amount);
405     }
406 
407     /**
408      * @notice Transfer `tokens` tokens from `src` to `dst` by `spender`
409      * @dev Called by both `transfer` and `transferFrom` internally
410      * @param spender The address of the account performing the transfer
411      * @param src The address of the source account
412      * @param dst The address of the destination account
413      * @param tokens The number of tokens to transfer
414      * @return Whether or not the transfer succeeded
415      */
416     function transferTokens(
417         address spender,
418         address src,
419         address dst,
420         uint256 tokens
421     ) internal returns (uint256) {
422         // Make sure accountCollateralTokens of `src` and `dst` are initialized.
423         initializeAccountCollateralTokens(src);
424         initializeAccountCollateralTokens(dst);
425 
426         /**
427          * For every user, accountTokens must be greater than or equal to accountCollateralTokens.
428          * The buffer between the two values will be transferred first.
429          * bufferTokens = accountTokens[src] - accountCollateralTokens[src]
430          * collateralTokens = tokens - bufferTokens
431          */
432         uint256 bufferTokens = sub_(accountTokens[src], accountCollateralTokens[src]);
433         uint256 collateralTokens = 0;
434         if (tokens > bufferTokens) {
435             collateralTokens = tokens - bufferTokens;
436         }
437 
438         /**
439          * Since bufferTokens are not collateralized and can be transferred freely, we only check with comptroller
440          * whether collateralized tokens can be transferred.
441          */
442         require(comptroller.transferAllowed(address(this), src, dst, collateralTokens) == 0, "comptroller rejection");
443 
444         /* Do not allow self-transfers */
445         require(src != dst, "bad input");
446 
447         /* Get the allowance, infinite for the account owner */
448         uint256 startingAllowance = 0;
449         if (spender == src) {
450             startingAllowance = uint256(-1);
451         } else {
452             startingAllowance = transferAllowances[src][spender];
453         }
454 
455         /* Do the calculations, checking for {under,over}flow */
456         accountTokens[src] = sub_(accountTokens[src], tokens);
457         accountTokens[dst] = add_(accountTokens[dst], tokens);
458         if (collateralTokens > 0) {
459             accountCollateralTokens[src] = sub_(accountCollateralTokens[src], collateralTokens);
460             accountCollateralTokens[dst] = add_(accountCollateralTokens[dst], collateralTokens);
461 
462             emit UserCollateralChanged(src, accountCollateralTokens[src]);
463             emit UserCollateralChanged(dst, accountCollateralTokens[dst]);
464         }
465 
466         /* Eat some of the allowance (if necessary) */
467         if (startingAllowance != uint256(-1)) {
468             transferAllowances[src][spender] = sub_(startingAllowance, tokens);
469         }
470 
471         /* We emit a Transfer event */
472         emit Transfer(src, dst, tokens);
473 
474         comptroller.transferVerify(address(this), src, dst, tokens);
475 
476         return uint256(Error.NO_ERROR);
477     }
478 
479     /**
480      * @notice Get the account's cToken balances
481      * @param account The address of the account
482      */
483     function getCTokenBalanceInternal(address account) internal view returns (uint256) {
484         if (isCollateralTokenInit[account]) {
485             return accountCollateralTokens[account];
486         } else {
487             /**
488              * If the value of accountCollateralTokens was not initialized, we should return the value of accountTokens.
489              */
490             return accountTokens[account];
491         }
492     }
493 
494     /**
495      * @notice Increase user's collateral. Increase as much as we can.
496      * @param account The address of the account
497      * @param amount The amount of collateral user wants to increase
498      * @return The actual increased amount of collateral
499      */
500     function increaseUserCollateralInternal(address account, uint256 amount) internal returns (uint256) {
501         uint256 totalCollateralTokensNew = add_(totalCollateralTokens, amount);
502         if (collateralCap == 0 || (collateralCap != 0 && totalCollateralTokensNew <= collateralCap)) {
503             // 1. If collateral cap is not set,
504             // 2. If collateral cap is set but has enough space for this user,
505             // give all the user needs.
506             totalCollateralTokens = totalCollateralTokensNew;
507             accountCollateralTokens[account] = add_(accountCollateralTokens[account], amount);
508 
509             emit UserCollateralChanged(account, accountCollateralTokens[account]);
510             return amount;
511         } else if (collateralCap > totalCollateralTokens) {
512             // If the collateral cap is set but the remaining cap is not enough for this user,
513             // give the remaining parts to the user.
514             uint256 gap = sub_(collateralCap, totalCollateralTokens);
515             totalCollateralTokens = add_(totalCollateralTokens, gap);
516             accountCollateralTokens[account] = add_(accountCollateralTokens[account], gap);
517 
518             emit UserCollateralChanged(account, accountCollateralTokens[account]);
519             return gap;
520         }
521         return 0;
522     }
523 
524     /**
525      * @notice Decrease user's collateral. Reject if the amount can't be fully decrease.
526      * @param account The address of the account
527      * @param amount The amount of collateral user wants to decrease
528      */
529     function decreaseUserCollateralInternal(address account, uint256 amount) internal {
530         /*
531          * Return if amount is zero.
532          * Put behind `redeemAllowed` for accuring potential COMP rewards.
533          */
534         if (amount == 0) {
535             return;
536         }
537 
538         totalCollateralTokens = sub_(totalCollateralTokens, amount);
539         accountCollateralTokens[account] = sub_(accountCollateralTokens[account], amount);
540 
541         emit UserCollateralChanged(account, accountCollateralTokens[account]);
542     }
543 
544     struct MintLocalVars {
545         uint256 exchangeRateMantissa;
546         uint256 mintTokens;
547         uint256 actualMintAmount;
548     }
549 
550     /**
551      * @notice User supplies assets into the market and receives cTokens in exchange
552      * @dev Assumes interest has already been accrued up to the current block
553      * @param minter The address of the account which is supplying the assets
554      * @param mintAmount The amount of the underlying asset to supply
555      * @param isNative The amount is in native or not
556      * @return (uint, uint) An error code (0=success, otherwise a failure, see ErrorReporter.sol), and the actual mint amount.
557      */
558     function mintFresh(
559         address minter,
560         uint256 mintAmount,
561         bool isNative
562     ) internal returns (uint256, uint256) {
563         // Make sure accountCollateralTokens of `minter` is initialized.
564         initializeAccountCollateralTokens(minter);
565 
566         /* Fail if mint not allowed */
567         require(comptroller.mintAllowed(address(this), minter, mintAmount) == 0, "comptroller rejection");
568 
569         /*
570          * Return if mintAmount is zero.
571          * Put behind `mintAllowed` for accuring potential COMP rewards.
572          */
573         if (mintAmount == 0) {
574             return (uint256(Error.NO_ERROR), 0);
575         }
576 
577         /* Verify market's block number equals current block number */
578         require(accrualBlockNumber == getBlockNumber(), "market not fresh");
579 
580         MintLocalVars memory vars;
581 
582         vars.exchangeRateMantissa = exchangeRateStoredInternal();
583 
584         /////////////////////////
585         // EFFECTS & INTERACTIONS
586         // (No safe failures beyond this point)
587 
588         /*
589          *  We call `doTransferIn` for the minter and the mintAmount.
590          *  Note: The cToken must handle variations between ERC-20 and ETH underlying.
591          *  `doTransferIn` reverts if anything goes wrong, since we can't be sure if
592          *  side-effects occurred. The function returns the amount actually transferred,
593          *  in case of a fee. On success, the cToken holds an additional `actualMintAmount`
594          *  of cash.
595          */
596         vars.actualMintAmount = doTransferIn(minter, mintAmount, isNative);
597 
598         /*
599          * We get the current exchange rate and calculate the number of cTokens to be minted:
600          *  mintTokens = actualMintAmount / exchangeRate
601          */
602         vars.mintTokens = div_ScalarByExpTruncate(vars.actualMintAmount, Exp({mantissa: vars.exchangeRateMantissa}));
603 
604         /*
605          * We calculate the new total supply of cTokens and minter token balance, checking for overflow:
606          *  totalSupply = totalSupply + mintTokens
607          *  accountTokens[minter] = accountTokens[minter] + mintTokens
608          */
609         totalSupply = add_(totalSupply, vars.mintTokens);
610         accountTokens[minter] = add_(accountTokens[minter], vars.mintTokens);
611 
612         /*
613          * We only allocate collateral tokens if the minter has entered the market.
614          */
615         if (ComptrollerInterfaceExtension(address(comptroller)).checkMembership(minter, CToken(this))) {
616             increaseUserCollateralInternal(minter, vars.mintTokens);
617         }
618 
619         /* We emit a Mint event, and a Transfer event */
620         emit Mint(minter, vars.actualMintAmount, vars.mintTokens);
621         emit Transfer(address(this), minter, vars.mintTokens);
622 
623         /* We call the defense hook */
624         comptroller.mintVerify(address(this), minter, vars.actualMintAmount, vars.mintTokens);
625 
626         return (uint256(Error.NO_ERROR), vars.actualMintAmount);
627     }
628 
629     struct RedeemLocalVars {
630         uint256 exchangeRateMantissa;
631         uint256 redeemTokens;
632         uint256 redeemAmount;
633     }
634 
635     /**
636      * @notice User redeems cTokens in exchange for the underlying asset
637      * @dev Assumes interest has already been accrued up to the current block. Only one of redeemTokensIn or redeemAmountIn may be non-zero and it would do nothing if both are zero.
638      * @param redeemer The address of the account which is redeeming the tokens
639      * @param redeemTokensIn The number of cTokens to redeem into underlying
640      * @param redeemAmountIn The number of underlying tokens to receive from redeeming cTokens
641      * @param isNative The amount is in native or not
642      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
643      */
644     function redeemFresh(
645         address payable redeemer,
646         uint256 redeemTokensIn,
647         uint256 redeemAmountIn,
648         bool isNative
649     ) internal returns (uint256) {
650         // Make sure accountCollateralTokens of `redeemer` is initialized.
651         initializeAccountCollateralTokens(redeemer);
652 
653         require(redeemTokensIn == 0 || redeemAmountIn == 0, "bad input");
654 
655         RedeemLocalVars memory vars;
656 
657         /* exchangeRate = invoke Exchange Rate Stored() */
658         vars.exchangeRateMantissa = exchangeRateStoredInternal();
659 
660         /* If redeemTokensIn > 0: */
661         if (redeemTokensIn > 0) {
662             /*
663              * We calculate the exchange rate and the amount of underlying to be redeemed:
664              *  redeemTokens = redeemTokensIn
665              *  redeemAmount = redeemTokensIn x exchangeRateCurrent
666              */
667             vars.redeemTokens = redeemTokensIn;
668             vars.redeemAmount = mul_ScalarTruncate(Exp({mantissa: vars.exchangeRateMantissa}), redeemTokensIn);
669         } else {
670             /*
671              * We get the current exchange rate and calculate the amount to be redeemed:
672              *  redeemTokens = redeemAmountIn / exchangeRate
673              *  redeemAmount = redeemAmountIn
674              */
675             vars.redeemTokens = div_ScalarByExpTruncate(redeemAmountIn, Exp({mantissa: vars.exchangeRateMantissa}));
676             vars.redeemAmount = redeemAmountIn;
677         }
678 
679         /**
680          * For every user, accountTokens must be greater than or equal to accountCollateralTokens.
681          * The buffer between the two values will be redeemed first.
682          * bufferTokens = accountTokens[redeemer] - accountCollateralTokens[redeemer]
683          * collateralTokens = redeemTokens - bufferTokens
684          */
685         uint256 bufferTokens = sub_(accountTokens[redeemer], accountCollateralTokens[redeemer]);
686         uint256 collateralTokens = 0;
687         if (vars.redeemTokens > bufferTokens) {
688             collateralTokens = vars.redeemTokens - bufferTokens;
689         }
690 
691         /* redeemAllowed might check more than user's liquidity. */
692         require(comptroller.redeemAllowed(address(this), redeemer, collateralTokens) == 0, "comptroller rejection");
693 
694         /* Verify market's block number equals current block number */
695         require(accrualBlockNumber == getBlockNumber(), "market not fresh");
696 
697         /* Reverts if protocol has insufficient cash */
698         require(getCashPrior() >= vars.redeemAmount, "insufficient cash");
699 
700         /////////////////////////
701         // EFFECTS & INTERACTIONS
702         // (No safe failures beyond this point)
703 
704         /*
705          * We calculate the new total supply and redeemer balance, checking for underflow:
706          *  totalSupplyNew = totalSupply - redeemTokens
707          *  accountTokensNew = accountTokens[redeemer] - redeemTokens
708          */
709         totalSupply = sub_(totalSupply, vars.redeemTokens);
710         accountTokens[redeemer] = sub_(accountTokens[redeemer], vars.redeemTokens);
711 
712         /*
713          * We only deallocate collateral tokens if the redeemer needs to redeem them.
714          */
715         decreaseUserCollateralInternal(redeemer, collateralTokens);
716 
717         /*
718          * We invoke doTransferOut for the redeemer and the redeemAmount.
719          *  Note: The cToken must handle variations between ERC-20 and ETH underlying.
720          *  On success, the cToken has redeemAmount less of cash.
721          *  doTransferOut reverts if anything goes wrong, since we can't be sure if side effects occurred.
722          */
723         doTransferOut(redeemer, vars.redeemAmount, isNative);
724 
725         /* We emit a Transfer event, and a Redeem event */
726         emit Transfer(redeemer, address(this), vars.redeemTokens);
727         emit Redeem(redeemer, vars.redeemAmount, vars.redeemTokens);
728 
729         /* We call the defense hook */
730         comptroller.redeemVerify(address(this), redeemer, vars.redeemAmount, vars.redeemTokens);
731 
732         return uint256(Error.NO_ERROR);
733     }
734 
735     /**
736      * @notice Transfers collateral tokens (this market) to the liquidator.
737      * @dev Called only during an in-kind liquidation, or by liquidateBorrow during the liquidation of another CToken.
738      *  Its absolutely critical to use msg.sender as the seizer cToken and not a parameter.
739      * @param seizerToken The contract seizing the collateral (i.e. borrowed cToken)
740      * @param liquidator The account receiving seized collateral
741      * @param borrower The account having collateral seized
742      * @param seizeTokens The number of cTokens to seize
743      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
744      */
745     function seizeInternal(
746         address seizerToken,
747         address liquidator,
748         address borrower,
749         uint256 seizeTokens
750     ) internal returns (uint256) {
751         // Make sure accountCollateralTokens of `liquidator` and `borrower` are initialized.
752         initializeAccountCollateralTokens(liquidator);
753         initializeAccountCollateralTokens(borrower);
754 
755         /* Fail if seize not allowed */
756         require(
757             comptroller.seizeAllowed(address(this), seizerToken, liquidator, borrower, seizeTokens) == 0,
758             "comptroller rejection"
759         );
760 
761         /*
762          * Return if seizeTokens is zero.
763          * Put behind `seizeAllowed` for accuring potential COMP rewards.
764          */
765         if (seizeTokens == 0) {
766             return uint256(Error.NO_ERROR);
767         }
768 
769         /* Fail if borrower = liquidator */
770         require(borrower != liquidator, "invalid account pair");
771 
772         /*
773          * We calculate the new borrower and liquidator token balances and token collateral balances, failing on underflow/overflow:
774          *  accountTokens[borrower] = accountTokens[borrower] - seizeTokens
775          *  accountTokens[liquidator] = accountTokens[liquidator] + seizeTokens
776          *  accountCollateralTokens[borrower] = accountCollateralTokens[borrower] - seizeTokens
777          *  accountCollateralTokens[liquidator] = accountCollateralTokens[liquidator] + seizeTokens
778          */
779         accountTokens[borrower] = sub_(accountTokens[borrower], seizeTokens);
780         accountTokens[liquidator] = add_(accountTokens[liquidator], seizeTokens);
781         accountCollateralTokens[borrower] = sub_(accountCollateralTokens[borrower], seizeTokens);
782         accountCollateralTokens[liquidator] = add_(accountCollateralTokens[liquidator], seizeTokens);
783 
784         /* Emit a Transfer, UserCollateralChanged events */
785         emit Transfer(borrower, liquidator, seizeTokens);
786         emit UserCollateralChanged(borrower, accountCollateralTokens[borrower]);
787         emit UserCollateralChanged(liquidator, accountCollateralTokens[liquidator]);
788 
789         /* We call the defense hook */
790         comptroller.seizeVerify(address(this), seizerToken, liquidator, borrower, seizeTokens);
791 
792         return uint256(Error.NO_ERROR);
793     }
794 }
