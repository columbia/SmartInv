1 pragma solidity ^0.5.16;
2 
3 import "./ComptrollerInterface.sol";
4 import "./CTokenInterfaces.sol";
5 import "./ErrorReporter.sol";
6 import "./Exponential.sol";
7 import "./EIP20Interface.sol";
8 import "./EIP20NonStandardInterface.sol";
9 import "./InterestRateModel.sol";
10 
11 /**
12  * @title Compound's CToken Contract
13  * @notice Abstract base for CTokens
14  * @author Compound
15  */
16 contract CTokenCheckRepay is CTokenInterface, Exponential, TokenErrorReporter {
17     /**
18      * @notice Initialize the money market
19      * @param comptroller_ The address of the Comptroller
20      * @param interestRateModel_ The address of the interest rate model
21      * @param initialExchangeRateMantissa_ The initial exchange rate, scaled by 1e18
22      * @param name_ EIP-20 name of this token
23      * @param symbol_ EIP-20 symbol of this token
24      * @param decimals_ EIP-20 decimal precision of this token
25      */
26     function initialize(
27         ComptrollerInterface comptroller_,
28         InterestRateModel interestRateModel_,
29         uint256 initialExchangeRateMantissa_,
30         string memory name_,
31         string memory symbol_,
32         uint8 decimals_
33     ) public {
34         require(msg.sender == admin, "only admin may initialize the market");
35         require(accrualBlockNumber == 0 && borrowIndex == 0, "market may only be initialized once");
36 
37         // Set initial exchange rate
38         initialExchangeRateMantissa = initialExchangeRateMantissa_;
39         require(initialExchangeRateMantissa > 0, "initial exchange rate must be greater than zero.");
40 
41         // Set the comptroller
42         uint256 err = _setComptroller(comptroller_);
43         require(err == uint256(Error.NO_ERROR), "setting comptroller failed");
44 
45         // Initialize block number and borrow index (block number mocks depend on comptroller being set)
46         accrualBlockNumber = getBlockNumber();
47         borrowIndex = mantissaOne;
48 
49         // Set the interest rate model (depends on block number / borrow index)
50         err = _setInterestRateModelFresh(interestRateModel_);
51         require(err == uint256(Error.NO_ERROR), "setting interest rate model failed");
52 
53         name = name_;
54         symbol = symbol_;
55         decimals = decimals_;
56 
57         // The counter starts true to prevent changing it from zero to non-zero (i.e. smaller cost/refund)
58         _notEntered = true;
59     }
60 
61     /**
62      * @notice Transfer `amount` tokens from `msg.sender` to `dst`
63      * @param dst The address of the destination account
64      * @param amount The number of tokens to transfer
65      * @return Whether or not the transfer succeeded
66      */
67     function transfer(address dst, uint256 amount) external nonReentrant returns (bool) {
68         return transferTokens(msg.sender, msg.sender, dst, amount) == uint256(Error.NO_ERROR);
69     }
70 
71     /**
72      * @notice Transfer `amount` tokens from `src` to `dst`
73      * @param src The address of the source account
74      * @param dst The address of the destination account
75      * @param amount The number of tokens to transfer
76      * @return Whether or not the transfer succeeded
77      */
78     function transferFrom(
79         address src,
80         address dst,
81         uint256 amount
82     ) external nonReentrant returns (bool) {
83         return transferTokens(msg.sender, src, dst, amount) == uint256(Error.NO_ERROR);
84     }
85 
86     /**
87      * @notice Approve `spender` to transfer up to `amount` from `src`
88      * @dev This will overwrite the approval amount for `spender`
89      *  and is subject to issues noted [here](https://eips.ethereum.org/EIPS/eip-20#approve)
90      * @param spender The address of the account which may transfer tokens
91      * @param amount The number of tokens that are approved (-1 means infinite)
92      * @return Whether or not the approval succeeded
93      */
94     function approve(address spender, uint256 amount) external returns (bool) {
95         address src = msg.sender;
96         transferAllowances[src][spender] = amount;
97         emit Approval(src, spender, amount);
98         return true;
99     }
100 
101     /**
102      * @notice Get the current allowance from `owner` for `spender`
103      * @param owner The address of the account which owns the tokens to be spent
104      * @param spender The address of the account which may transfer tokens
105      * @return The number of tokens allowed to be spent (-1 means infinite)
106      */
107     function allowance(address owner, address spender) external view returns (uint256) {
108         return transferAllowances[owner][spender];
109     }
110 
111     /**
112      * @notice Get the token balance of the `owner`
113      * @param owner The address of the account to query
114      * @return The number of tokens owned by `owner`
115      */
116     function balanceOf(address owner) external view returns (uint256) {
117         return accountTokens[owner];
118     }
119 
120     /**
121      * @notice Get the underlying balance of the `owner`
122      * @dev This also accrues interest in a transaction
123      * @param owner The address of the account to query
124      * @return The amount of underlying owned by `owner`
125      */
126     function balanceOfUnderlying(address owner) external returns (uint256) {
127         Exp memory exchangeRate = Exp({mantissa: exchangeRateCurrent()});
128         return mul_ScalarTruncate(exchangeRate, accountTokens[owner]);
129     }
130 
131     /**
132      * @notice Get a snapshot of the account's balances, and the cached exchange rate
133      * @dev This is used by comptroller to more efficiently perform liquidity checks.
134      * @param account Address of the account to snapshot
135      * @return (possible error, token balance, borrow balance, exchange rate mantissa)
136      */
137     function getAccountSnapshot(address account)
138         external
139         view
140         returns (
141             uint256,
142             uint256,
143             uint256,
144             uint256
145         )
146     {
147         uint256 cTokenBalance = getCTokenBalanceInternal(account);
148         uint256 borrowBalance = borrowBalanceStoredInternal(account);
149         uint256 exchangeRateMantissa = exchangeRateStoredInternal();
150 
151         return (uint256(Error.NO_ERROR), cTokenBalance, borrowBalance, exchangeRateMantissa);
152     }
153 
154     /**
155      * @dev Function to simply retrieve block number
156      *  This exists mainly for inheriting test contracts to stub this result.
157      */
158     function getBlockNumber() internal view returns (uint256) {
159         return block.number;
160     }
161 
162     /**
163      * @notice Returns the current per-block borrow interest rate for this cToken
164      * @return The borrow interest rate per block, scaled by 1e18
165      */
166     function borrowRatePerBlock() external view returns (uint256) {
167         return interestRateModel.getBorrowRate(getCashPrior(), totalBorrows, totalReserves);
168     }
169 
170     /**
171      * @notice Returns the current per-block supply interest rate for this cToken
172      * @return The supply interest rate per block, scaled by 1e18
173      */
174     function supplyRatePerBlock() external view returns (uint256) {
175         return interestRateModel.getSupplyRate(getCashPrior(), totalBorrows, totalReserves, reserveFactorMantissa);
176     }
177 
178     /**
179      * @notice Returns the estimated per-block borrow interest rate for this cToken after some change
180      * @return The borrow interest rate per block, scaled by 1e18
181      */
182     function estimateBorrowRatePerBlockAfterChange(uint256 change, bool repay) external view returns (uint256) {
183         uint256 cashPriorNew;
184         uint256 totalBorrowsNew;
185 
186         if (repay) {
187             cashPriorNew = add_(getCashPrior(), change);
188             totalBorrowsNew = sub_(totalBorrows, change);
189         } else {
190             cashPriorNew = sub_(getCashPrior(), change);
191             totalBorrowsNew = add_(totalBorrows, change);
192         }
193         return interestRateModel.getBorrowRate(cashPriorNew, totalBorrowsNew, totalReserves);
194     }
195 
196     /**
197      * @notice Returns the estimated per-block supply interest rate for this cToken after some change
198      * @return The supply interest rate per block, scaled by 1e18
199      */
200     function estimateSupplyRatePerBlockAfterChange(uint256 change, bool repay) external view returns (uint256) {
201         uint256 cashPriorNew;
202         uint256 totalBorrowsNew;
203 
204         if (repay) {
205             cashPriorNew = add_(getCashPrior(), change);
206             totalBorrowsNew = sub_(totalBorrows, change);
207         } else {
208             cashPriorNew = sub_(getCashPrior(), change);
209             totalBorrowsNew = add_(totalBorrows, change);
210         }
211 
212         return interestRateModel.getSupplyRate(cashPriorNew, totalBorrowsNew, totalReserves, reserveFactorMantissa);
213     }
214 
215     /**
216      * @notice Returns the current total borrows plus accrued interest
217      * @return The total borrows with interest
218      */
219     function totalBorrowsCurrent() external nonReentrant returns (uint256) {
220         accrueInterest();
221         return totalBorrows;
222     }
223 
224     /**
225      * @notice Accrue interest to updated borrowIndex and then calculate account's borrow balance using the updated borrowIndex
226      * @param account The address whose balance should be calculated after updating borrowIndex
227      * @return The calculated balance
228      */
229     function borrowBalanceCurrent(address account) external nonReentrant returns (uint256) {
230         accrueInterest();
231         return borrowBalanceStored(account);
232     }
233 
234     /**
235      * @notice Return the borrow balance of account based on stored data
236      * @param account The address whose balance should be calculated
237      * @return The calculated balance
238      */
239     function borrowBalanceStored(address account) public view returns (uint256) {
240         return borrowBalanceStoredInternal(account);
241     }
242 
243     /**
244      * @notice Return the borrow balance of account based on stored data
245      * @param account The address whose balance should be calculated
246      * @return the calculated balance or 0 if error code is non-zero
247      */
248     function borrowBalanceStoredInternal(address account) internal view returns (uint256) {
249         /* Get borrowBalance and borrowIndex */
250         BorrowSnapshot storage borrowSnapshot = accountBorrows[account];
251 
252         /* If borrowBalance = 0 then borrowIndex is likely also 0.
253          * Rather than failing the calculation with a division by 0, we immediately return 0 in this case.
254          */
255         if (borrowSnapshot.principal == 0) {
256             return 0;
257         }
258 
259         /* Calculate new borrow balance using the interest index:
260          *  recentBorrowBalance = borrower.borrowBalance * market.borrowIndex / borrower.borrowIndex
261          */
262         uint256 principalTimesIndex = mul_(borrowSnapshot.principal, borrowIndex);
263         uint256 result = div_(principalTimesIndex, borrowSnapshot.interestIndex);
264         return result;
265     }
266 
267     /**
268      * @notice Accrue interest then return the up-to-date exchange rate
269      * @return Calculated exchange rate scaled by 1e18
270      */
271     function exchangeRateCurrent() public nonReentrant returns (uint256) {
272         accrueInterest();
273         return exchangeRateStored();
274     }
275 
276     /**
277      * @notice Calculates the exchange rate from the underlying to the CToken
278      * @dev This function does not accrue interest before calculating the exchange rate
279      * @return Calculated exchange rate scaled by 1e18
280      */
281     function exchangeRateStored() public view returns (uint256) {
282         return exchangeRateStoredInternal();
283     }
284 
285     /**
286      * @notice Calculates the exchange rate from the underlying to the CToken
287      * @dev This function does not accrue interest before calculating the exchange rate
288      * @return calculated exchange rate scaled by 1e18
289      */
290     function exchangeRateStoredInternal() internal view returns (uint256) {
291         uint256 _totalSupply = totalSupply;
292         if (_totalSupply == 0) {
293             /*
294              * If there are no tokens minted:
295              *  exchangeRate = initialExchangeRate
296              */
297             return initialExchangeRateMantissa;
298         } else {
299             /*
300              * Otherwise:
301              *  exchangeRate = (totalCash + totalBorrows - totalReserves) / totalSupply
302              */
303             uint256 totalCash = getCashPrior();
304             uint256 cashPlusBorrowsMinusReserves = sub_(add_(totalCash, totalBorrows), totalReserves);
305             uint256 exchangeRate = div_(cashPlusBorrowsMinusReserves, Exp({mantissa: _totalSupply}));
306             return exchangeRate;
307         }
308     }
309 
310     /**
311      * @notice Get cash balance of this cToken in the underlying asset
312      * @return The quantity of underlying asset owned by this contract
313      */
314     function getCash() external view returns (uint256) {
315         return getCashPrior();
316     }
317 
318     /**
319      * @notice Applies accrued interest to total borrows and reserves
320      * @dev This calculates interest accrued from the last checkpointed block
321      *   up to the current block and writes new checkpoint to storage.
322      */
323     function accrueInterest() public returns (uint256) {
324         /* Remember the initial block number */
325         uint256 currentBlockNumber = getBlockNumber();
326         uint256 accrualBlockNumberPrior = accrualBlockNumber;
327 
328         /* Short-circuit accumulating 0 interest */
329         if (accrualBlockNumberPrior == currentBlockNumber) {
330             return uint256(Error.NO_ERROR);
331         }
332 
333         /* Read the previous values out of storage */
334         uint256 cashPrior = getCashPrior();
335         uint256 borrowsPrior = totalBorrows;
336         uint256 reservesPrior = totalReserves;
337         uint256 borrowIndexPrior = borrowIndex;
338 
339         /* Calculate the current borrow interest rate */
340         uint256 borrowRateMantissa = interestRateModel.getBorrowRate(cashPrior, borrowsPrior, reservesPrior);
341         require(borrowRateMantissa <= borrowRateMaxMantissa, "borrow rate is absurdly high");
342 
343         /* Calculate the number of blocks elapsed since the last accrual */
344         uint256 blockDelta = sub_(currentBlockNumber, accrualBlockNumberPrior);
345 
346         /*
347          * Calculate the interest accumulated into borrows and reserves and the new index:
348          *  simpleInterestFactor = borrowRate * blockDelta
349          *  interestAccumulated = simpleInterestFactor * totalBorrows
350          *  totalBorrowsNew = interestAccumulated + totalBorrows
351          *  totalReservesNew = interestAccumulated * reserveFactor + totalReserves
352          *  borrowIndexNew = simpleInterestFactor * borrowIndex + borrowIndex
353          */
354 
355         Exp memory simpleInterestFactor = mul_(Exp({mantissa: borrowRateMantissa}), blockDelta);
356         uint256 interestAccumulated = mul_ScalarTruncate(simpleInterestFactor, borrowsPrior);
357         uint256 totalBorrowsNew = add_(interestAccumulated, borrowsPrior);
358         uint256 totalReservesNew = mul_ScalarTruncateAddUInt(
359             Exp({mantissa: reserveFactorMantissa}),
360             interestAccumulated,
361             reservesPrior
362         );
363         uint256 borrowIndexNew = mul_ScalarTruncateAddUInt(simpleInterestFactor, borrowIndexPrior, borrowIndexPrior);
364 
365         /////////////////////////
366         // EFFECTS & INTERACTIONS
367         // (No safe failures beyond this point)
368 
369         /* We write the previously calculated values into storage */
370         accrualBlockNumber = currentBlockNumber;
371         borrowIndex = borrowIndexNew;
372         totalBorrows = totalBorrowsNew;
373         totalReserves = totalReservesNew;
374 
375         /* We emit an AccrueInterest event */
376         emit AccrueInterest(cashPrior, interestAccumulated, borrowIndexNew, totalBorrowsNew);
377 
378         return uint256(Error.NO_ERROR);
379     }
380 
381     /**
382      * @notice Sender supplies assets into the market and receives cTokens in exchange
383      * @dev Accrues interest whether or not the operation succeeds, unless reverted
384      * @param mintAmount The amount of the underlying asset to supply
385      * @param isNative The amount is in native or not
386      * @return (uint, uint) An error code (0=success, otherwise a failure, see ErrorReporter.sol), and the actual mint amount.
387      */
388     function mintInternal(uint256 mintAmount, bool isNative) internal nonReentrant returns (uint256, uint256) {
389         accrueInterest();
390         // mintFresh emits the actual Mint event if successful and logs on errors, so we don't need to
391         return mintFresh(msg.sender, mintAmount, isNative);
392     }
393 
394     /**
395      * @notice Sender redeems cTokens in exchange for the underlying asset
396      * @dev Accrues interest whether or not the operation succeeds, unless reverted
397      * @param redeemTokens The number of cTokens to redeem into underlying
398      * @param isNative The amount is in native or not
399      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
400      */
401     function redeemInternal(uint256 redeemTokens, bool isNative) internal nonReentrant returns (uint256) {
402         accrueInterest();
403         // redeemFresh emits redeem-specific logs on errors, so we don't need to
404         return redeemFresh(msg.sender, redeemTokens, 0, isNative);
405     }
406 
407     /**
408      * @notice Sender redeems cTokens in exchange for a specified amount of underlying asset
409      * @dev Accrues interest whether or not the operation succeeds, unless reverted
410      * @param redeemAmount The amount of underlying to receive from redeeming cTokens
411      * @param isNative The amount is in native or not
412      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
413      */
414     function redeemUnderlyingInternal(uint256 redeemAmount, bool isNative) internal nonReentrant returns (uint256) {
415         accrueInterest();
416         // redeemFresh emits redeem-specific logs on errors, so we don't need to
417         return redeemFresh(msg.sender, 0, redeemAmount, isNative);
418     }
419 
420     /**
421      * @notice Sender borrows assets from the protocol to their own address
422      * @param borrowAmount The amount of the underlying asset to borrow
423      * @param isNative The amount is in native or not
424      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
425      */
426     function borrowInternal(uint256 borrowAmount, bool isNative) internal nonReentrant returns (uint256) {
427         accrueInterest();
428         // borrowFresh emits borrow-specific logs on errors, so we don't need to
429         return borrowFresh(msg.sender, borrowAmount, isNative);
430     }
431 
432     struct BorrowLocalVars {
433         MathError mathErr;
434         uint256 accountBorrows;
435         uint256 accountBorrowsNew;
436         uint256 totalBorrowsNew;
437     }
438 
439     /**
440      * @notice Users borrow assets from the protocol to their own address
441      * @param borrowAmount The amount of the underlying asset to borrow
442      * @param isNative The amount is in native or not
443      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
444      */
445     function borrowFresh(
446         address payable borrower,
447         uint256 borrowAmount,
448         bool isNative
449     ) internal returns (uint256) {
450         /* Fail if borrow not allowed */
451         require(comptroller.borrowAllowed(address(this), borrower, borrowAmount) == 0, "comptroller rejection");
452 
453         /* Verify market's block number equals current block number */
454         require(accrualBlockNumber == getBlockNumber(), "market not fresh");
455 
456         /* Reverts if protocol has insufficient cash */
457         require(getCashPrior() >= borrowAmount, "insufficient cash");
458 
459         BorrowLocalVars memory vars;
460 
461         /*
462          * We calculate the new borrower and total borrow balances, failing on overflow:
463          *  accountBorrowsNew = accountBorrows + borrowAmount
464          *  totalBorrowsNew = totalBorrows + borrowAmount
465          */
466         vars.accountBorrows = borrowBalanceStoredInternal(borrower);
467         vars.accountBorrowsNew = add_(vars.accountBorrows, borrowAmount);
468         vars.totalBorrowsNew = add_(totalBorrows, borrowAmount);
469 
470         /////////////////////////
471         // EFFECTS & INTERACTIONS
472         // (No safe failures beyond this point)
473 
474         /* We write the previously calculated values into storage */
475         accountBorrows[borrower].principal = vars.accountBorrowsNew;
476         accountBorrows[borrower].interestIndex = borrowIndex;
477         totalBorrows = vars.totalBorrowsNew;
478 
479         /*
480          * We invoke doTransferOut for the borrower and the borrowAmount.
481          *  Note: The cToken must handle variations between ERC-20 and ETH underlying.
482          *  On success, the cToken borrowAmount less of cash.
483          *  doTransferOut reverts if anything goes wrong, since we can't be sure if side effects occurred.
484          */
485         doTransferOut(borrower, borrowAmount, isNative);
486 
487         /* We emit a Borrow event */
488         emit Borrow(borrower, borrowAmount, vars.accountBorrowsNew, vars.totalBorrowsNew);
489 
490         /* We call the defense hook */
491         comptroller.borrowVerify(address(this), borrower, borrowAmount);
492 
493         return uint256(Error.NO_ERROR);
494     }
495 
496     /**
497      * @notice Sender repays their own borrow
498      * @param repayAmount The amount to repay
499      * @param isNative The amount is in native or not
500      * @return (uint, uint) An error code (0=success, otherwise a failure, see ErrorReporter.sol), and the actual repayment amount.
501      */
502     function repayBorrowInternal(uint256 repayAmount, bool isNative) internal nonReentrant returns (uint256, uint256) {
503         accrueInterest();
504         // repayBorrowFresh emits repay-borrow-specific logs on errors, so we don't need to
505         return repayBorrowFresh(msg.sender, msg.sender, repayAmount, isNative, false);
506     }
507 
508     /**
509      * @notice Sender repays a borrow belonging to borrower
510      * @param borrower the account with the debt being payed off
511      * @param repayAmount The amount to repay
512      * @param isNative The amount is in native or not
513      * @return (uint, uint) An error code (0=success, otherwise a failure, see ErrorReporter.sol), and the actual repayment amount.
514      */
515     function repayBorrowBehalfInternal(
516         address borrower,
517         uint256 repayAmount,
518         bool isNative
519     ) internal nonReentrant returns (uint256, uint256) {
520         accrueInterest();
521         // repayBorrowFresh emits repay-borrow-specific logs on errors, so we don't need to
522         return repayBorrowFresh(msg.sender, borrower, repayAmount, isNative, false);
523     }
524 
525     struct RepayBorrowLocalVars {
526         Error err;
527         MathError mathErr;
528         uint256 repayAmount;
529         uint256 borrowerIndex;
530         uint256 accountBorrows;
531         uint256 accountBorrowsNew;
532         uint256 totalBorrowsNew;
533         uint256 actualRepayAmount;
534     }
535 
536     /**
537      * @notice Borrows are repaid by another user (possibly the borrower).
538      * @param payer the account paying off the borrow
539      * @param borrower the account with the debt being payed off
540      * @param repayAmount the amount of undelrying tokens being returned
541      * @param isNative The amount is in native or not
542      * @param isFromLiquidation The request is from liquidation or not
543      * @return (uint, uint) An error code (0=success, otherwise a failure, see ErrorReporter.sol), and the actual repayment amount.
544      */
545     function repayBorrowFresh(
546         address payer,
547         address borrower,
548         uint256 repayAmount,
549         bool isNative,
550         bool isFromLiquidation
551     ) internal returns (uint256, uint256) {
552         /* Fail if repayBorrow not allowed */
553         require(
554             comptroller.repayBorrowAllowed(address(this), payer, borrower, repayAmount) == 0,
555             "comptroller rejection"
556         );
557 
558         /* Verify market's block number equals current block number */
559         require(accrualBlockNumber == getBlockNumber(), "market not fresh");
560 
561         RepayBorrowLocalVars memory vars;
562 
563         /* We remember the original borrowerIndex for verification purposes */
564         vars.borrowerIndex = accountBorrows[borrower].interestIndex;
565 
566         /* We fetch the amount the borrower owes, with accumulated interest */
567         vars.accountBorrows = borrowBalanceStoredInternal(borrower);
568 
569         /* If repayAmount == -1, repayAmount = accountBorrows */
570         if (repayAmount == uint256(-1)) {
571             vars.repayAmount = vars.accountBorrows;
572         } else {
573             vars.repayAmount = repayAmount;
574         }
575 
576         /////////////////////////
577         // EFFECTS & INTERACTIONS
578         // (No safe failures beyond this point)
579 
580         /*
581          * We call doTransferIn for the payer and the repayAmount
582          *  Note: The cToken must handle variations between ERC-20 and ETH underlying.
583          *  On success, the cToken holds an additional repayAmount of cash.
584          *  doTransferIn reverts if anything goes wrong, since we can't be sure if side effects occurred.
585          *   it returns the amount actually transferred, in case of a fee.
586          */
587         vars.actualRepayAmount = doTransferIn(payer, vars.repayAmount, isNative);
588 
589         // Only check account liquidity if the request is from liquidation to save gas.
590         if (isFromLiquidation) {
591             // Right after `doTransferIn` and before updating the storage, check the borrower's account liquidity again.
592             // If a reentrant call to another asset is made during transferring AMP in, a second account liquidity check
593             // could help prevent excessive liquidation.
594             (uint256 err, , uint256 shortfall) = ComptrollerInterfaceExtension(address(comptroller))
595                 .getAccountLiquidity(borrower);
596             require(err == 0, "failed to get account liquidity");
597             require(shortfall > 0, "borrower has no shortfall");
598         }
599 
600         /*
601          * We calculate the new borrower and total borrow balances, failing on underflow:
602          *  accountBorrowsNew = accountBorrows - actualRepayAmount
603          *  totalBorrowsNew = totalBorrows - actualRepayAmount
604          */
605         vars.accountBorrowsNew = sub_(vars.accountBorrows, vars.actualRepayAmount);
606         vars.totalBorrowsNew = sub_(totalBorrows, vars.actualRepayAmount);
607 
608         /* We write the previously calculated values into storage */
609         accountBorrows[borrower].principal = vars.accountBorrowsNew;
610         accountBorrows[borrower].interestIndex = borrowIndex;
611         totalBorrows = vars.totalBorrowsNew;
612 
613         /* We emit a RepayBorrow event */
614         emit RepayBorrow(payer, borrower, vars.actualRepayAmount, vars.accountBorrowsNew, vars.totalBorrowsNew);
615 
616         /* We call the defense hook */
617         comptroller.repayBorrowVerify(address(this), payer, borrower, vars.actualRepayAmount, vars.borrowerIndex);
618 
619         return (uint256(Error.NO_ERROR), vars.actualRepayAmount);
620     }
621 
622     /**
623      * @notice The sender liquidates the borrowers collateral.
624      *  The collateral seized is transferred to the liquidator.
625      * @param borrower The borrower of this cToken to be liquidated
626      * @param repayAmount The amount of the underlying borrowed asset to repay
627      * @param cTokenCollateral The market in which to seize collateral from the borrower
628      * @param isNative The amount is in native or not
629      * @return (uint, uint) An error code (0=success, otherwise a failure, see ErrorReporter.sol), and the actual repayment amount.
630      */
631     function liquidateBorrowInternal(
632         address borrower,
633         uint256 repayAmount,
634         CTokenInterface cTokenCollateral,
635         bool isNative
636     ) internal nonReentrant returns (uint256, uint256) {
637         accrueInterest();
638         require(cTokenCollateral.accrueInterest() == uint256(Error.NO_ERROR), "accrue interest failed");
639 
640         // liquidateBorrowFresh emits borrow-specific logs on errors, so we don't need to
641         return liquidateBorrowFresh(msg.sender, borrower, repayAmount, cTokenCollateral, isNative);
642     }
643 
644     struct LiquidateBorrowLocalVars {
645         uint256 repayBorrowError;
646         uint256 actualRepayAmount;
647         uint256 amountSeizeError;
648         uint256 seizeTokens;
649     }
650 
651     /**
652      * @notice The liquidator liquidates the borrowers collateral.
653      *  The collateral seized is transferred to the liquidator.
654      * @param borrower The borrower of this cToken to be liquidated
655      * @param liquidator The address repaying the borrow and seizing collateral
656      * @param cTokenCollateral The market in which to seize collateral from the borrower
657      * @param repayAmount The amount of the underlying borrowed asset to repay
658      * @param isNative The amount is in native or not
659      * @return (uint, uint) An error code (0=success, otherwise a failure, see ErrorReporter.sol), and the actual repayment amount.
660      */
661     function liquidateBorrowFresh(
662         address liquidator,
663         address borrower,
664         uint256 repayAmount,
665         CTokenInterface cTokenCollateral,
666         bool isNative
667     ) internal returns (uint256, uint256) {
668         /* Fail if liquidate not allowed */
669         require(
670             comptroller.liquidateBorrowAllowed(
671                 address(this),
672                 address(cTokenCollateral),
673                 liquidator,
674                 borrower,
675                 repayAmount
676             ) == 0,
677             "comptroller rejection"
678         );
679 
680         /* Verify market's block number equals current block number */
681         require(accrualBlockNumber == getBlockNumber(), "market not fresh");
682 
683         /* Verify cTokenCollateral market's block number equals current block number */
684         require(cTokenCollateral.accrualBlockNumber() == getBlockNumber(), "market not fresh");
685 
686         /* Fail if borrower = liquidator */
687         require(borrower != liquidator, "invalid account pair");
688 
689         /* Fail if repayAmount = 0 or repayAmount = -1 */
690         require(repayAmount > 0 && repayAmount != uint256(-1), "invalid close amount requested");
691 
692         LiquidateBorrowLocalVars memory vars;
693 
694         /* Fail if repayBorrow fails */
695         (vars.repayBorrowError, vars.actualRepayAmount) = repayBorrowFresh(
696             liquidator,
697             borrower,
698             repayAmount,
699             isNative,
700             true
701         );
702         require(vars.repayBorrowError == uint256(Error.NO_ERROR), "repay borrow failed");
703 
704         /////////////////////////
705         // EFFECTS & INTERACTIONS
706         // (No safe failures beyond this point)
707 
708         /* We calculate the number of collateral tokens that will be seized */
709         (vars.amountSeizeError, vars.seizeTokens) = comptroller.liquidateCalculateSeizeTokens(
710             address(this),
711             address(cTokenCollateral),
712             vars.actualRepayAmount
713         );
714         require(
715             vars.amountSeizeError == uint256(Error.NO_ERROR),
716             "LIQUIDATE_COMPTROLLER_CALCULATE_AMOUNT_SEIZE_FAILED"
717         );
718 
719         /* Revert if borrower collateral token balance < seizeTokens */
720         require(cTokenCollateral.balanceOf(borrower) >= vars.seizeTokens, "LIQUIDATE_SEIZE_TOO_MUCH");
721 
722         // If this is also the collateral, run seizeInternal to avoid re-entrancy, otherwise make an external call
723         uint256 seizeError;
724         if (address(cTokenCollateral) == address(this)) {
725             seizeError = seizeInternal(address(this), liquidator, borrower, vars.seizeTokens);
726         } else {
727             seizeError = cTokenCollateral.seize(liquidator, borrower, vars.seizeTokens);
728         }
729 
730         /* Revert if seize tokens fails (since we cannot be sure of side effects) */
731         require(seizeError == uint256(Error.NO_ERROR), "token seizure failed");
732 
733         /* We emit a LiquidateBorrow event */
734         emit LiquidateBorrow(liquidator, borrower, vars.actualRepayAmount, address(cTokenCollateral), vars.seizeTokens);
735 
736         /* We call the defense hook */
737         comptroller.liquidateBorrowVerify(
738             address(this),
739             address(cTokenCollateral),
740             liquidator,
741             borrower,
742             vars.actualRepayAmount,
743             vars.seizeTokens
744         );
745 
746         return (uint256(Error.NO_ERROR), vars.actualRepayAmount);
747     }
748 
749     /**
750      * @notice Transfers collateral tokens (this market) to the liquidator.
751      * @dev Will fail unless called by another cToken during the process of liquidation.
752      *  Its absolutely critical to use msg.sender as the borrowed cToken and not a parameter.
753      * @param liquidator The account receiving seized collateral
754      * @param borrower The account having collateral seized
755      * @param seizeTokens The number of cTokens to seize
756      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
757      */
758     function seize(
759         address liquidator,
760         address borrower,
761         uint256 seizeTokens
762     ) external nonReentrant returns (uint256) {
763         return seizeInternal(msg.sender, liquidator, borrower, seizeTokens);
764     }
765 
766     /*** Admin Functions ***/
767 
768     /**
769      * @notice Begins transfer of admin rights. The newPendingAdmin must call `_acceptAdmin` to finalize the transfer.
770      * @dev Admin function to begin change of admin. The newPendingAdmin must call `_acceptAdmin` to finalize the transfer.
771      * @param newPendingAdmin New pending admin.
772      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
773      */
774     function _setPendingAdmin(address payable newPendingAdmin) external returns (uint256) {
775         // Check caller = admin
776         if (msg.sender != admin) {
777             return fail(Error.UNAUTHORIZED, FailureInfo.SET_PENDING_ADMIN_OWNER_CHECK);
778         }
779 
780         // Save current value, if any, for inclusion in log
781         address oldPendingAdmin = pendingAdmin;
782 
783         // Store pendingAdmin with value newPendingAdmin
784         pendingAdmin = newPendingAdmin;
785 
786         // Emit NewPendingAdmin(oldPendingAdmin, newPendingAdmin)
787         emit NewPendingAdmin(oldPendingAdmin, newPendingAdmin);
788 
789         return uint256(Error.NO_ERROR);
790     }
791 
792     /**
793      * @notice Accepts transfer of admin rights. msg.sender must be pendingAdmin
794      * @dev Admin function for pending admin to accept role and update admin
795      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
796      */
797     function _acceptAdmin() external returns (uint256) {
798         // Check caller is pendingAdmin and pendingAdmin ≠ address(0)
799         if (msg.sender != pendingAdmin || msg.sender == address(0)) {
800             return fail(Error.UNAUTHORIZED, FailureInfo.ACCEPT_ADMIN_PENDING_ADMIN_CHECK);
801         }
802 
803         // Save current values for inclusion in log
804         address oldAdmin = admin;
805         address oldPendingAdmin = pendingAdmin;
806 
807         // Store admin with value pendingAdmin
808         admin = pendingAdmin;
809 
810         // Clear the pending value
811         pendingAdmin = address(0);
812 
813         emit NewAdmin(oldAdmin, admin);
814         emit NewPendingAdmin(oldPendingAdmin, pendingAdmin);
815 
816         return uint256(Error.NO_ERROR);
817     }
818 
819     /**
820      * @notice Sets a new comptroller for the market
821      * @dev Admin function to set a new comptroller
822      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
823      */
824     function _setComptroller(ComptrollerInterface newComptroller) public returns (uint256) {
825         // Check caller is admin
826         if (msg.sender != admin) {
827             return fail(Error.UNAUTHORIZED, FailureInfo.SET_COMPTROLLER_OWNER_CHECK);
828         }
829 
830         ComptrollerInterface oldComptroller = comptroller;
831         // Ensure invoke comptroller.isComptroller() returns true
832         require(newComptroller.isComptroller(), "invalid Comptroller");
833 
834         // Set market's comptroller to newComptroller
835         comptroller = newComptroller;
836 
837         // Emit NewComptroller(oldComptroller, newComptroller)
838         emit NewComptroller(oldComptroller, newComptroller);
839 
840         return uint256(Error.NO_ERROR);
841     }
842 
843     /**
844      * @notice accrues interest and sets a new reserve factor for the protocol using _setReserveFactorFresh
845      * @dev Admin function to accrue interest and set a new reserve factor
846      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
847      */
848     function _setReserveFactor(uint256 newReserveFactorMantissa) external nonReentrant returns (uint256) {
849         uint256 error = accrueInterest();
850         if (error != uint256(Error.NO_ERROR)) {
851             // accrueInterest emits logs on errors, but on top of that we want to log the fact that an attempted reserve factor change failed.
852             return fail(Error(error), FailureInfo.SET_RESERVE_FACTOR_ACCRUE_INTEREST_FAILED);
853         }
854         // _setReserveFactorFresh emits reserve-factor-specific logs on errors, so we don't need to.
855         return _setReserveFactorFresh(newReserveFactorMantissa);
856     }
857 
858     /**
859      * @notice Sets a new reserve factor for the protocol (*requires fresh interest accrual)
860      * @dev Admin function to set a new reserve factor
861      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
862      */
863     function _setReserveFactorFresh(uint256 newReserveFactorMantissa) internal returns (uint256) {
864         // Check caller is admin
865         if (msg.sender != admin) {
866             return fail(Error.UNAUTHORIZED, FailureInfo.SET_RESERVE_FACTOR_ADMIN_CHECK);
867         }
868 
869         // Verify market's block number equals current block number
870         if (accrualBlockNumber != getBlockNumber()) {
871             return fail(Error.MARKET_NOT_FRESH, FailureInfo.SET_RESERVE_FACTOR_FRESH_CHECK);
872         }
873 
874         // Check newReserveFactor ≤ maxReserveFactor
875         if (newReserveFactorMantissa > reserveFactorMaxMantissa) {
876             return fail(Error.BAD_INPUT, FailureInfo.SET_RESERVE_FACTOR_BOUNDS_CHECK);
877         }
878 
879         uint256 oldReserveFactorMantissa = reserveFactorMantissa;
880         reserveFactorMantissa = newReserveFactorMantissa;
881 
882         emit NewReserveFactor(oldReserveFactorMantissa, newReserveFactorMantissa);
883 
884         return uint256(Error.NO_ERROR);
885     }
886 
887     /**
888      * @notice Accrues interest and reduces reserves by transferring from msg.sender
889      * @param addAmount Amount of addition to reserves
890      * @param isNative The amount is in native or not
891      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
892      */
893     function _addReservesInternal(uint256 addAmount, bool isNative) internal nonReentrant returns (uint256) {
894         uint256 error = accrueInterest();
895         if (error != uint256(Error.NO_ERROR)) {
896             // accrueInterest emits logs on errors, but on top of that we want to log the fact that an attempted reduce reserves failed.
897             return fail(Error(error), FailureInfo.ADD_RESERVES_ACCRUE_INTEREST_FAILED);
898         }
899 
900         // _addReservesFresh emits reserve-addition-specific logs on errors, so we don't need to.
901         (error, ) = _addReservesFresh(addAmount, isNative);
902         return error;
903     }
904 
905     /**
906      * @notice Add reserves by transferring from caller
907      * @dev Requires fresh interest accrual
908      * @param addAmount Amount of addition to reserves
909      * @param isNative The amount is in native or not
910      * @return (uint, uint) An error code (0=success, otherwise a failure (see ErrorReporter.sol for details)) and the actual amount added, net token fees
911      */
912     function _addReservesFresh(uint256 addAmount, bool isNative) internal returns (uint256, uint256) {
913         // totalReserves + actualAddAmount
914         uint256 totalReservesNew;
915         uint256 actualAddAmount;
916 
917         // We fail gracefully unless market's block number equals current block number
918         if (accrualBlockNumber != getBlockNumber()) {
919             return (fail(Error.MARKET_NOT_FRESH, FailureInfo.ADD_RESERVES_FRESH_CHECK), actualAddAmount);
920         }
921 
922         /////////////////////////
923         // EFFECTS & INTERACTIONS
924         // (No safe failures beyond this point)
925 
926         /*
927          * We call doTransferIn for the caller and the addAmount
928          *  Note: The cToken must handle variations between ERC-20 and ETH underlying.
929          *  On success, the cToken holds an additional addAmount of cash.
930          *  doTransferIn reverts if anything goes wrong, since we can't be sure if side effects occurred.
931          *  it returns the amount actually transferred, in case of a fee.
932          */
933 
934         actualAddAmount = doTransferIn(msg.sender, addAmount, isNative);
935 
936         totalReservesNew = add_(totalReserves, actualAddAmount);
937 
938         // Store reserves[n+1] = reserves[n] + actualAddAmount
939         totalReserves = totalReservesNew;
940 
941         /* Emit NewReserves(admin, actualAddAmount, reserves[n+1]) */
942         emit ReservesAdded(msg.sender, actualAddAmount, totalReservesNew);
943 
944         /* Return (NO_ERROR, actualAddAmount) */
945         return (uint256(Error.NO_ERROR), actualAddAmount);
946     }
947 
948     /**
949      * @notice Accrues interest and reduces reserves by transferring to admin
950      * @param reduceAmount Amount of reduction to reserves
951      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
952      */
953     function _reduceReserves(uint256 reduceAmount) external nonReentrant returns (uint256) {
954         uint256 error = accrueInterest();
955         if (error != uint256(Error.NO_ERROR)) {
956             // accrueInterest emits logs on errors, but on top of that we want to log the fact that an attempted reduce reserves failed.
957             return fail(Error(error), FailureInfo.REDUCE_RESERVES_ACCRUE_INTEREST_FAILED);
958         }
959         // _reduceReservesFresh emits reserve-reduction-specific logs on errors, so we don't need to.
960         return _reduceReservesFresh(reduceAmount);
961     }
962 
963     /**
964      * @notice Reduces reserves by transferring to admin
965      * @dev Requires fresh interest accrual
966      * @param reduceAmount Amount of reduction to reserves
967      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
968      */
969     function _reduceReservesFresh(uint256 reduceAmount) internal returns (uint256) {
970         // totalReserves - reduceAmount
971         uint256 totalReservesNew;
972 
973         // Check caller is admin
974         if (msg.sender != admin) {
975             return fail(Error.UNAUTHORIZED, FailureInfo.REDUCE_RESERVES_ADMIN_CHECK);
976         }
977 
978         // We fail gracefully unless market's block number equals current block number
979         if (accrualBlockNumber != getBlockNumber()) {
980             return fail(Error.MARKET_NOT_FRESH, FailureInfo.REDUCE_RESERVES_FRESH_CHECK);
981         }
982 
983         // Fail gracefully if protocol has insufficient underlying cash
984         if (getCashPrior() < reduceAmount) {
985             return fail(Error.TOKEN_INSUFFICIENT_CASH, FailureInfo.REDUCE_RESERVES_CASH_NOT_AVAILABLE);
986         }
987 
988         // Check reduceAmount ≤ reserves[n] (totalReserves)
989         if (reduceAmount > totalReserves) {
990             return fail(Error.BAD_INPUT, FailureInfo.REDUCE_RESERVES_VALIDATION);
991         }
992 
993         /////////////////////////
994         // EFFECTS & INTERACTIONS
995         // (No safe failures beyond this point)
996 
997         totalReservesNew = sub_(totalReserves, reduceAmount);
998 
999         // Store reserves[n+1] = reserves[n] - reduceAmount
1000         totalReserves = totalReservesNew;
1001 
1002         // doTransferOut reverts if anything goes wrong, since we can't be sure if side effects occurred.
1003         // Restrict reducing reserves in native token. Implementations except `CWrappedNative` won't use parameter `isNative`.
1004         doTransferOut(admin, reduceAmount, true);
1005 
1006         emit ReservesReduced(admin, reduceAmount, totalReservesNew);
1007 
1008         return uint256(Error.NO_ERROR);
1009     }
1010 
1011     /**
1012      * @notice accrues interest and updates the interest rate model using _setInterestRateModelFresh
1013      * @dev Admin function to accrue interest and update the interest rate model
1014      * @param newInterestRateModel the new interest rate model to use
1015      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
1016      */
1017     function _setInterestRateModel(InterestRateModel newInterestRateModel) public returns (uint256) {
1018         uint256 error = accrueInterest();
1019         if (error != uint256(Error.NO_ERROR)) {
1020             // accrueInterest emits logs on errors, but on top of that we want to log the fact that an attempted change of interest rate model failed
1021             return fail(Error(error), FailureInfo.SET_INTEREST_RATE_MODEL_ACCRUE_INTEREST_FAILED);
1022         }
1023         // _setInterestRateModelFresh emits interest-rate-model-update-specific logs on errors, so we don't need to.
1024         return _setInterestRateModelFresh(newInterestRateModel);
1025     }
1026 
1027     /**
1028      * @notice updates the interest rate model (*requires fresh interest accrual)
1029      * @dev Admin function to update the interest rate model
1030      * @param newInterestRateModel the new interest rate model to use
1031      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
1032      */
1033     function _setInterestRateModelFresh(InterestRateModel newInterestRateModel) internal returns (uint256) {
1034         // Used to store old model for use in the event that is emitted on success
1035         InterestRateModel oldInterestRateModel;
1036 
1037         // Check caller is admin
1038         if (msg.sender != admin) {
1039             return fail(Error.UNAUTHORIZED, FailureInfo.SET_INTEREST_RATE_MODEL_OWNER_CHECK);
1040         }
1041 
1042         // We fail gracefully unless market's block number equals current block number
1043         if (accrualBlockNumber != getBlockNumber()) {
1044             return fail(Error.MARKET_NOT_FRESH, FailureInfo.SET_INTEREST_RATE_MODEL_FRESH_CHECK);
1045         }
1046 
1047         // Track the market's current interest rate model
1048         oldInterestRateModel = interestRateModel;
1049 
1050         // Ensure invoke newInterestRateModel.isInterestRateModel() returns true
1051         require(newInterestRateModel.isInterestRateModel(), "invalid IRM");
1052 
1053         // Set the interest rate model to newInterestRateModel
1054         interestRateModel = newInterestRateModel;
1055 
1056         // Emit NewMarketInterestRateModel(oldInterestRateModel, newInterestRateModel)
1057         emit NewMarketInterestRateModel(oldInterestRateModel, newInterestRateModel);
1058 
1059         return uint256(Error.NO_ERROR);
1060     }
1061 
1062     /*** Safe Token ***/
1063 
1064     /**
1065      * @notice Gets balance of this contract in terms of the underlying
1066      * @dev This excludes the value of the current message, if any
1067      * @return The quantity of underlying owned by this contract
1068      */
1069     function getCashPrior() internal view returns (uint256);
1070 
1071     /**
1072      * @dev Performs a transfer in, reverting upon failure. Returns the amount actually transferred to the protocol, in case of a fee.
1073      *  This may revert due to insufficient balance or insufficient allowance.
1074      */
1075     function doTransferIn(
1076         address from,
1077         uint256 amount,
1078         bool isNative
1079     ) internal returns (uint256);
1080 
1081     /**
1082      * @dev Performs a transfer out, ideally returning an explanatory error code upon failure tather than reverting.
1083      *  If caller has not called checked protocol's balance, may revert due to insufficient cash held in the contract.
1084      *  If caller has checked protocol's balance, and verified it is >= amount, this should not revert in normal conditions.
1085      */
1086     function doTransferOut(
1087         address payable to,
1088         uint256 amount,
1089         bool isNative
1090     ) internal;
1091 
1092     /**
1093      * @notice Transfer `tokens` tokens from `src` to `dst` by `spender`
1094      * @dev Called by both `transfer` and `transferFrom` internally
1095      */
1096     function transferTokens(
1097         address spender,
1098         address src,
1099         address dst,
1100         uint256 tokens
1101     ) internal returns (uint256);
1102 
1103     /**
1104      * @notice Get the account's cToken balances
1105      */
1106     function getCTokenBalanceInternal(address account) internal view returns (uint256);
1107 
1108     /**
1109      * @notice User supplies assets into the market and receives cTokens in exchange
1110      * @dev Assumes interest has already been accrued up to the current block
1111      */
1112     function mintFresh(
1113         address minter,
1114         uint256 mintAmount,
1115         bool isNative
1116     ) internal returns (uint256, uint256);
1117 
1118     /**
1119      * @notice User redeems cTokens in exchange for the underlying asset
1120      * @dev Assumes interest has already been accrued up to the current block
1121      */
1122     function redeemFresh(
1123         address payable redeemer,
1124         uint256 redeemTokensIn,
1125         uint256 redeemAmountIn,
1126         bool isNative
1127     ) internal returns (uint256);
1128 
1129     /**
1130      * @notice Transfers collateral tokens (this market) to the liquidator.
1131      * @dev Called only during an in-kind liquidation, or by liquidateBorrow during the liquidation of another CToken.
1132      *  Its absolutely critical to use msg.sender as the seizer cToken and not a parameter.
1133      */
1134     function seizeInternal(
1135         address seizerToken,
1136         address liquidator,
1137         address borrower,
1138         uint256 seizeTokens
1139     ) internal returns (uint256);
1140 
1141     /*** Reentrancy Guard ***/
1142 
1143     /**
1144      * @dev Prevents a contract from calling itself, directly or indirectly.
1145      */
1146     modifier nonReentrant() {
1147         require(_notEntered, "re-entered");
1148         _notEntered = false;
1149         _;
1150         _notEntered = true; // get a gas-refund post-Istanbul
1151     }
1152 }
