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
16 contract CToken is CTokenInterface, Exponential, TokenErrorReporter {
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
505         return repayBorrowFresh(msg.sender, msg.sender, repayAmount, isNative);
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
522         return repayBorrowFresh(msg.sender, borrower, repayAmount, isNative);
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
542      * @return (uint, uint) An error code (0=success, otherwise a failure, see ErrorReporter.sol), and the actual repayment amount.
543      */
544     function repayBorrowFresh(
545         address payer,
546         address borrower,
547         uint256 repayAmount,
548         bool isNative
549     ) internal returns (uint256, uint256) {
550         /* Fail if repayBorrow not allowed */
551         require(
552             comptroller.repayBorrowAllowed(address(this), payer, borrower, repayAmount) == 0,
553             "comptroller rejection"
554         );
555 
556         /* Verify market's block number equals current block number */
557         require(accrualBlockNumber == getBlockNumber(), "market not fresh");
558 
559         RepayBorrowLocalVars memory vars;
560 
561         /* We remember the original borrowerIndex for verification purposes */
562         vars.borrowerIndex = accountBorrows[borrower].interestIndex;
563 
564         /* We fetch the amount the borrower owes, with accumulated interest */
565         vars.accountBorrows = borrowBalanceStoredInternal(borrower);
566 
567         /* If repayAmount == -1, repayAmount = accountBorrows */
568         if (repayAmount == uint256(-1)) {
569             vars.repayAmount = vars.accountBorrows;
570         } else {
571             vars.repayAmount = repayAmount;
572         }
573 
574         /////////////////////////
575         // EFFECTS & INTERACTIONS
576         // (No safe failures beyond this point)
577 
578         /*
579          * We call doTransferIn for the payer and the repayAmount
580          *  Note: The cToken must handle variations between ERC-20 and ETH underlying.
581          *  On success, the cToken holds an additional repayAmount of cash.
582          *  doTransferIn reverts if anything goes wrong, since we can't be sure if side effects occurred.
583          *   it returns the amount actually transferred, in case of a fee.
584          */
585         vars.actualRepayAmount = doTransferIn(payer, vars.repayAmount, isNative);
586 
587         /*
588          * We calculate the new borrower and total borrow balances, failing on underflow:
589          *  accountBorrowsNew = accountBorrows - actualRepayAmount
590          *  totalBorrowsNew = totalBorrows - actualRepayAmount
591          */
592         vars.accountBorrowsNew = sub_(vars.accountBorrows, vars.actualRepayAmount);
593         vars.totalBorrowsNew = sub_(totalBorrows, vars.actualRepayAmount);
594 
595         /* We write the previously calculated values into storage */
596         accountBorrows[borrower].principal = vars.accountBorrowsNew;
597         accountBorrows[borrower].interestIndex = borrowIndex;
598         totalBorrows = vars.totalBorrowsNew;
599 
600         /* We emit a RepayBorrow event */
601         emit RepayBorrow(payer, borrower, vars.actualRepayAmount, vars.accountBorrowsNew, vars.totalBorrowsNew);
602 
603         /* We call the defense hook */
604         comptroller.repayBorrowVerify(address(this), payer, borrower, vars.actualRepayAmount, vars.borrowerIndex);
605 
606         return (uint256(Error.NO_ERROR), vars.actualRepayAmount);
607     }
608 
609     /**
610      * @notice The sender liquidates the borrowers collateral.
611      *  The collateral seized is transferred to the liquidator.
612      * @param borrower The borrower of this cToken to be liquidated
613      * @param repayAmount The amount of the underlying borrowed asset to repay
614      * @param cTokenCollateral The market in which to seize collateral from the borrower
615      * @param isNative The amount is in native or not
616      * @return (uint, uint) An error code (0=success, otherwise a failure, see ErrorReporter.sol), and the actual repayment amount.
617      */
618     function liquidateBorrowInternal(
619         address borrower,
620         uint256 repayAmount,
621         CTokenInterface cTokenCollateral,
622         bool isNative
623     ) internal nonReentrant returns (uint256, uint256) {
624         accrueInterest();
625         require(cTokenCollateral.accrueInterest() == uint256(Error.NO_ERROR), "accrue interest failed");
626 
627         // liquidateBorrowFresh emits borrow-specific logs on errors, so we don't need to
628         return liquidateBorrowFresh(msg.sender, borrower, repayAmount, cTokenCollateral, isNative);
629     }
630 
631     struct LiquidateBorrowLocalVars {
632         uint256 repayBorrowError;
633         uint256 actualRepayAmount;
634         uint256 amountSeizeError;
635         uint256 seizeTokens;
636     }
637 
638     /**
639      * @notice The liquidator liquidates the borrowers collateral.
640      *  The collateral seized is transferred to the liquidator.
641      * @param borrower The borrower of this cToken to be liquidated
642      * @param liquidator The address repaying the borrow and seizing collateral
643      * @param cTokenCollateral The market in which to seize collateral from the borrower
644      * @param repayAmount The amount of the underlying borrowed asset to repay
645      * @param isNative The amount is in native or not
646      * @return (uint, uint) An error code (0=success, otherwise a failure, see ErrorReporter.sol), and the actual repayment amount.
647      */
648     function liquidateBorrowFresh(
649         address liquidator,
650         address borrower,
651         uint256 repayAmount,
652         CTokenInterface cTokenCollateral,
653         bool isNative
654     ) internal returns (uint256, uint256) {
655         /* Fail if liquidate not allowed */
656         require(
657             comptroller.liquidateBorrowAllowed(
658                 address(this),
659                 address(cTokenCollateral),
660                 liquidator,
661                 borrower,
662                 repayAmount
663             ) == 0,
664             "comptroller rejection"
665         );
666 
667         /* Verify market's block number equals current block number */
668         require(accrualBlockNumber == getBlockNumber(), "market not fresh");
669 
670         /* Verify cTokenCollateral market's block number equals current block number */
671         require(cTokenCollateral.accrualBlockNumber() == getBlockNumber(), "market not fresh");
672 
673         /* Fail if borrower = liquidator */
674         require(borrower != liquidator, "invalid account pair");
675 
676         /* Fail if repayAmount = 0 or repayAmount = -1 */
677         require(repayAmount > 0 && repayAmount != uint256(-1), "invalid close amount requested");
678 
679         LiquidateBorrowLocalVars memory vars;
680 
681         /* Fail if repayBorrow fails */
682         (vars.repayBorrowError, vars.actualRepayAmount) = repayBorrowFresh(liquidator, borrower, repayAmount, isNative);
683         require(vars.repayBorrowError == uint256(Error.NO_ERROR), "repay borrow failed");
684 
685         /////////////////////////
686         // EFFECTS & INTERACTIONS
687         // (No safe failures beyond this point)
688 
689         /* We calculate the number of collateral tokens that will be seized */
690         (vars.amountSeizeError, vars.seizeTokens) = comptroller.liquidateCalculateSeizeTokens(
691             address(this),
692             address(cTokenCollateral),
693             vars.actualRepayAmount
694         );
695         require(
696             vars.amountSeizeError == uint256(Error.NO_ERROR),
697             "LIQUIDATE_COMPTROLLER_CALCULATE_AMOUNT_SEIZE_FAILED"
698         );
699 
700         /* Revert if borrower collateral token balance < seizeTokens */
701         require(cTokenCollateral.balanceOf(borrower) >= vars.seizeTokens, "LIQUIDATE_SEIZE_TOO_MUCH");
702 
703         // If this is also the collateral, run seizeInternal to avoid re-entrancy, otherwise make an external call
704         uint256 seizeError;
705         if (address(cTokenCollateral) == address(this)) {
706             seizeError = seizeInternal(address(this), liquidator, borrower, vars.seizeTokens);
707         } else {
708             seizeError = cTokenCollateral.seize(liquidator, borrower, vars.seizeTokens);
709         }
710 
711         /* Revert if seize tokens fails (since we cannot be sure of side effects) */
712         require(seizeError == uint256(Error.NO_ERROR), "token seizure failed");
713 
714         /* We emit a LiquidateBorrow event */
715         emit LiquidateBorrow(liquidator, borrower, vars.actualRepayAmount, address(cTokenCollateral), vars.seizeTokens);
716 
717         /* We call the defense hook */
718         comptroller.liquidateBorrowVerify(
719             address(this),
720             address(cTokenCollateral),
721             liquidator,
722             borrower,
723             vars.actualRepayAmount,
724             vars.seizeTokens
725         );
726 
727         return (uint256(Error.NO_ERROR), vars.actualRepayAmount);
728     }
729 
730     /**
731      * @notice Transfers collateral tokens (this market) to the liquidator.
732      * @dev Will fail unless called by another cToken during the process of liquidation.
733      *  Its absolutely critical to use msg.sender as the borrowed cToken and not a parameter.
734      * @param liquidator The account receiving seized collateral
735      * @param borrower The account having collateral seized
736      * @param seizeTokens The number of cTokens to seize
737      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
738      */
739     function seize(
740         address liquidator,
741         address borrower,
742         uint256 seizeTokens
743     ) external nonReentrant returns (uint256) {
744         return seizeInternal(msg.sender, liquidator, borrower, seizeTokens);
745     }
746 
747     /*** Admin Functions ***/
748 
749     /**
750      * @notice Begins transfer of admin rights. The newPendingAdmin must call `_acceptAdmin` to finalize the transfer.
751      * @dev Admin function to begin change of admin. The newPendingAdmin must call `_acceptAdmin` to finalize the transfer.
752      * @param newPendingAdmin New pending admin.
753      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
754      */
755     function _setPendingAdmin(address payable newPendingAdmin) external returns (uint256) {
756         // Check caller = admin
757         if (msg.sender != admin) {
758             return fail(Error.UNAUTHORIZED, FailureInfo.SET_PENDING_ADMIN_OWNER_CHECK);
759         }
760 
761         // Save current value, if any, for inclusion in log
762         address oldPendingAdmin = pendingAdmin;
763 
764         // Store pendingAdmin with value newPendingAdmin
765         pendingAdmin = newPendingAdmin;
766 
767         // Emit NewPendingAdmin(oldPendingAdmin, newPendingAdmin)
768         emit NewPendingAdmin(oldPendingAdmin, newPendingAdmin);
769 
770         return uint256(Error.NO_ERROR);
771     }
772 
773     /**
774      * @notice Accepts transfer of admin rights. msg.sender must be pendingAdmin
775      * @dev Admin function for pending admin to accept role and update admin
776      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
777      */
778     function _acceptAdmin() external returns (uint256) {
779         // Check caller is pendingAdmin and pendingAdmin ≠ address(0)
780         if (msg.sender != pendingAdmin || msg.sender == address(0)) {
781             return fail(Error.UNAUTHORIZED, FailureInfo.ACCEPT_ADMIN_PENDING_ADMIN_CHECK);
782         }
783 
784         // Save current values for inclusion in log
785         address oldAdmin = admin;
786         address oldPendingAdmin = pendingAdmin;
787 
788         // Store admin with value pendingAdmin
789         admin = pendingAdmin;
790 
791         // Clear the pending value
792         pendingAdmin = address(0);
793 
794         emit NewAdmin(oldAdmin, admin);
795         emit NewPendingAdmin(oldPendingAdmin, pendingAdmin);
796 
797         return uint256(Error.NO_ERROR);
798     }
799 
800     /**
801      * @notice Sets a new comptroller for the market
802      * @dev Admin function to set a new comptroller
803      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
804      */
805     function _setComptroller(ComptrollerInterface newComptroller) public returns (uint256) {
806         // Check caller is admin
807         if (msg.sender != admin) {
808             return fail(Error.UNAUTHORIZED, FailureInfo.SET_COMPTROLLER_OWNER_CHECK);
809         }
810 
811         ComptrollerInterface oldComptroller = comptroller;
812         // Ensure invoke comptroller.isComptroller() returns true
813         require(newComptroller.isComptroller(), "invalid Comptroller");
814 
815         // Set market's comptroller to newComptroller
816         comptroller = newComptroller;
817 
818         // Emit NewComptroller(oldComptroller, newComptroller)
819         emit NewComptroller(oldComptroller, newComptroller);
820 
821         return uint256(Error.NO_ERROR);
822     }
823 
824     /**
825      * @notice accrues interest and sets a new reserve factor for the protocol using _setReserveFactorFresh
826      * @dev Admin function to accrue interest and set a new reserve factor
827      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
828      */
829     function _setReserveFactor(uint256 newReserveFactorMantissa) external nonReentrant returns (uint256) {
830         uint256 error = accrueInterest();
831         if (error != uint256(Error.NO_ERROR)) {
832             // accrueInterest emits logs on errors, but on top of that we want to log the fact that an attempted reserve factor change failed.
833             return fail(Error(error), FailureInfo.SET_RESERVE_FACTOR_ACCRUE_INTEREST_FAILED);
834         }
835         // _setReserveFactorFresh emits reserve-factor-specific logs on errors, so we don't need to.
836         return _setReserveFactorFresh(newReserveFactorMantissa);
837     }
838 
839     /**
840      * @notice Sets a new reserve factor for the protocol (*requires fresh interest accrual)
841      * @dev Admin function to set a new reserve factor
842      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
843      */
844     function _setReserveFactorFresh(uint256 newReserveFactorMantissa) internal returns (uint256) {
845         // Check caller is admin
846         if (msg.sender != admin) {
847             return fail(Error.UNAUTHORIZED, FailureInfo.SET_RESERVE_FACTOR_ADMIN_CHECK);
848         }
849 
850         // Verify market's block number equals current block number
851         if (accrualBlockNumber != getBlockNumber()) {
852             return fail(Error.MARKET_NOT_FRESH, FailureInfo.SET_RESERVE_FACTOR_FRESH_CHECK);
853         }
854 
855         // Check newReserveFactor ≤ maxReserveFactor
856         if (newReserveFactorMantissa > reserveFactorMaxMantissa) {
857             return fail(Error.BAD_INPUT, FailureInfo.SET_RESERVE_FACTOR_BOUNDS_CHECK);
858         }
859 
860         uint256 oldReserveFactorMantissa = reserveFactorMantissa;
861         reserveFactorMantissa = newReserveFactorMantissa;
862 
863         emit NewReserveFactor(oldReserveFactorMantissa, newReserveFactorMantissa);
864 
865         return uint256(Error.NO_ERROR);
866     }
867 
868     /**
869      * @notice Accrues interest and reduces reserves by transferring from msg.sender
870      * @param addAmount Amount of addition to reserves
871      * @param isNative The amount is in native or not
872      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
873      */
874     function _addReservesInternal(uint256 addAmount, bool isNative) internal nonReentrant returns (uint256) {
875         uint256 error = accrueInterest();
876         if (error != uint256(Error.NO_ERROR)) {
877             // accrueInterest emits logs on errors, but on top of that we want to log the fact that an attempted reduce reserves failed.
878             return fail(Error(error), FailureInfo.ADD_RESERVES_ACCRUE_INTEREST_FAILED);
879         }
880 
881         // _addReservesFresh emits reserve-addition-specific logs on errors, so we don't need to.
882         (error, ) = _addReservesFresh(addAmount, isNative);
883         return error;
884     }
885 
886     /**
887      * @notice Add reserves by transferring from caller
888      * @dev Requires fresh interest accrual
889      * @param addAmount Amount of addition to reserves
890      * @param isNative The amount is in native or not
891      * @return (uint, uint) An error code (0=success, otherwise a failure (see ErrorReporter.sol for details)) and the actual amount added, net token fees
892      */
893     function _addReservesFresh(uint256 addAmount, bool isNative) internal returns (uint256, uint256) {
894         // totalReserves + actualAddAmount
895         uint256 totalReservesNew;
896         uint256 actualAddAmount;
897 
898         // We fail gracefully unless market's block number equals current block number
899         if (accrualBlockNumber != getBlockNumber()) {
900             return (fail(Error.MARKET_NOT_FRESH, FailureInfo.ADD_RESERVES_FRESH_CHECK), actualAddAmount);
901         }
902 
903         /////////////////////////
904         // EFFECTS & INTERACTIONS
905         // (No safe failures beyond this point)
906 
907         /*
908          * We call doTransferIn for the caller and the addAmount
909          *  Note: The cToken must handle variations between ERC-20 and ETH underlying.
910          *  On success, the cToken holds an additional addAmount of cash.
911          *  doTransferIn reverts if anything goes wrong, since we can't be sure if side effects occurred.
912          *  it returns the amount actually transferred, in case of a fee.
913          */
914 
915         actualAddAmount = doTransferIn(msg.sender, addAmount, isNative);
916 
917         totalReservesNew = add_(totalReserves, actualAddAmount);
918 
919         // Store reserves[n+1] = reserves[n] + actualAddAmount
920         totalReserves = totalReservesNew;
921 
922         /* Emit NewReserves(admin, actualAddAmount, reserves[n+1]) */
923         emit ReservesAdded(msg.sender, actualAddAmount, totalReservesNew);
924 
925         /* Return (NO_ERROR, actualAddAmount) */
926         return (uint256(Error.NO_ERROR), actualAddAmount);
927     }
928 
929     /**
930      * @notice Accrues interest and reduces reserves by transferring to admin
931      * @param reduceAmount Amount of reduction to reserves
932      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
933      */
934     function _reduceReserves(uint256 reduceAmount) external nonReentrant returns (uint256) {
935         uint256 error = accrueInterest();
936         if (error != uint256(Error.NO_ERROR)) {
937             // accrueInterest emits logs on errors, but on top of that we want to log the fact that an attempted reduce reserves failed.
938             return fail(Error(error), FailureInfo.REDUCE_RESERVES_ACCRUE_INTEREST_FAILED);
939         }
940         // _reduceReservesFresh emits reserve-reduction-specific logs on errors, so we don't need to.
941         return _reduceReservesFresh(reduceAmount);
942     }
943 
944     /**
945      * @notice Reduces reserves by transferring to admin
946      * @dev Requires fresh interest accrual
947      * @param reduceAmount Amount of reduction to reserves
948      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
949      */
950     function _reduceReservesFresh(uint256 reduceAmount) internal returns (uint256) {
951         // totalReserves - reduceAmount
952         uint256 totalReservesNew;
953 
954         // Check caller is admin
955         if (msg.sender != admin) {
956             return fail(Error.UNAUTHORIZED, FailureInfo.REDUCE_RESERVES_ADMIN_CHECK);
957         }
958 
959         // We fail gracefully unless market's block number equals current block number
960         if (accrualBlockNumber != getBlockNumber()) {
961             return fail(Error.MARKET_NOT_FRESH, FailureInfo.REDUCE_RESERVES_FRESH_CHECK);
962         }
963 
964         // Fail gracefully if protocol has insufficient underlying cash
965         if (getCashPrior() < reduceAmount) {
966             return fail(Error.TOKEN_INSUFFICIENT_CASH, FailureInfo.REDUCE_RESERVES_CASH_NOT_AVAILABLE);
967         }
968 
969         // Check reduceAmount ≤ reserves[n] (totalReserves)
970         if (reduceAmount > totalReserves) {
971             return fail(Error.BAD_INPUT, FailureInfo.REDUCE_RESERVES_VALIDATION);
972         }
973 
974         /////////////////////////
975         // EFFECTS & INTERACTIONS
976         // (No safe failures beyond this point)
977 
978         totalReservesNew = sub_(totalReserves, reduceAmount);
979 
980         // Store reserves[n+1] = reserves[n] - reduceAmount
981         totalReserves = totalReservesNew;
982 
983         // doTransferOut reverts if anything goes wrong, since we can't be sure if side effects occurred.
984         // Restrict reducing reserves in wrapped token. Implementations except `CWrappedNative` won't use parameter `isNative`.
985         doTransferOut(admin, reduceAmount, false);
986 
987         emit ReservesReduced(admin, reduceAmount, totalReservesNew);
988 
989         return uint256(Error.NO_ERROR);
990     }
991 
992     /**
993      * @notice accrues interest and updates the interest rate model using _setInterestRateModelFresh
994      * @dev Admin function to accrue interest and update the interest rate model
995      * @param newInterestRateModel the new interest rate model to use
996      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
997      */
998     function _setInterestRateModel(InterestRateModel newInterestRateModel) public returns (uint256) {
999         uint256 error = accrueInterest();
1000         if (error != uint256(Error.NO_ERROR)) {
1001             // accrueInterest emits logs on errors, but on top of that we want to log the fact that an attempted change of interest rate model failed
1002             return fail(Error(error), FailureInfo.SET_INTEREST_RATE_MODEL_ACCRUE_INTEREST_FAILED);
1003         }
1004         // _setInterestRateModelFresh emits interest-rate-model-update-specific logs on errors, so we don't need to.
1005         return _setInterestRateModelFresh(newInterestRateModel);
1006     }
1007 
1008     /**
1009      * @notice updates the interest rate model (*requires fresh interest accrual)
1010      * @dev Admin function to update the interest rate model
1011      * @param newInterestRateModel the new interest rate model to use
1012      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
1013      */
1014     function _setInterestRateModelFresh(InterestRateModel newInterestRateModel) internal returns (uint256) {
1015         // Used to store old model for use in the event that is emitted on success
1016         InterestRateModel oldInterestRateModel;
1017 
1018         // Check caller is admin
1019         if (msg.sender != admin) {
1020             return fail(Error.UNAUTHORIZED, FailureInfo.SET_INTEREST_RATE_MODEL_OWNER_CHECK);
1021         }
1022 
1023         // We fail gracefully unless market's block number equals current block number
1024         if (accrualBlockNumber != getBlockNumber()) {
1025             return fail(Error.MARKET_NOT_FRESH, FailureInfo.SET_INTEREST_RATE_MODEL_FRESH_CHECK);
1026         }
1027 
1028         // Track the market's current interest rate model
1029         oldInterestRateModel = interestRateModel;
1030 
1031         // Ensure invoke newInterestRateModel.isInterestRateModel() returns true
1032         require(newInterestRateModel.isInterestRateModel(), "invalid IRM");
1033 
1034         // Set the interest rate model to newInterestRateModel
1035         interestRateModel = newInterestRateModel;
1036 
1037         // Emit NewMarketInterestRateModel(oldInterestRateModel, newInterestRateModel)
1038         emit NewMarketInterestRateModel(oldInterestRateModel, newInterestRateModel);
1039 
1040         return uint256(Error.NO_ERROR);
1041     }
1042 
1043     /*** Safe Token ***/
1044 
1045     /**
1046      * @notice Gets balance of this contract in terms of the underlying
1047      * @dev This excludes the value of the current message, if any
1048      * @return The quantity of underlying owned by this contract
1049      */
1050     function getCashPrior() internal view returns (uint256);
1051 
1052     /**
1053      * @dev Performs a transfer in, reverting upon failure. Returns the amount actually transferred to the protocol, in case of a fee.
1054      *  This may revert due to insufficient balance or insufficient allowance.
1055      */
1056     function doTransferIn(
1057         address from,
1058         uint256 amount,
1059         bool isNative
1060     ) internal returns (uint256);
1061 
1062     /**
1063      * @dev Performs a transfer out, ideally returning an explanatory error code upon failure tather than reverting.
1064      *  If caller has not called checked protocol's balance, may revert due to insufficient cash held in the contract.
1065      *  If caller has checked protocol's balance, and verified it is >= amount, this should not revert in normal conditions.
1066      */
1067     function doTransferOut(
1068         address payable to,
1069         uint256 amount,
1070         bool isNative
1071     ) internal;
1072 
1073     /**
1074      * @notice Transfer `tokens` tokens from `src` to `dst` by `spender`
1075      * @dev Called by both `transfer` and `transferFrom` internally
1076      */
1077     function transferTokens(
1078         address spender,
1079         address src,
1080         address dst,
1081         uint256 tokens
1082     ) internal returns (uint256);
1083 
1084     /**
1085      * @notice Get the account's cToken balances
1086      */
1087     function getCTokenBalanceInternal(address account) internal view returns (uint256);
1088 
1089     /**
1090      * @notice User supplies assets into the market and receives cTokens in exchange
1091      * @dev Assumes interest has already been accrued up to the current block
1092      */
1093     function mintFresh(
1094         address minter,
1095         uint256 mintAmount,
1096         bool isNative
1097     ) internal returns (uint256, uint256);
1098 
1099     /**
1100      * @notice User redeems cTokens in exchange for the underlying asset
1101      * @dev Assumes interest has already been accrued up to the current block
1102      */
1103     function redeemFresh(
1104         address payable redeemer,
1105         uint256 redeemTokensIn,
1106         uint256 redeemAmountIn,
1107         bool isNative
1108     ) internal returns (uint256);
1109 
1110     /**
1111      * @notice Transfers collateral tokens (this market) to the liquidator.
1112      * @dev Called only during an in-kind liquidation, or by liquidateBorrow during the liquidation of another CToken.
1113      *  Its absolutely critical to use msg.sender as the seizer cToken and not a parameter.
1114      */
1115     function seizeInternal(
1116         address seizerToken,
1117         address liquidator,
1118         address borrower,
1119         uint256 seizeTokens
1120     ) internal returns (uint256);
1121 
1122     /*** Reentrancy Guard ***/
1123 
1124     /**
1125      * @dev Prevents a contract from calling itself, directly or indirectly.
1126      */
1127     modifier nonReentrant() {
1128         require(_notEntered, "re-entered");
1129         _notEntered = false;
1130         _;
1131         _notEntered = true; // get a gas-refund post-Istanbul
1132     }
1133 }
