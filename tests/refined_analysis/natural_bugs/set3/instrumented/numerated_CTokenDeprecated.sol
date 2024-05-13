1 pragma solidity ^0.5.16;
2 
3 import "../ComptrollerInterface.sol";
4 import "../CTokenInterfaces.sol";
5 import "../ErrorReporter.sol";
6 import "../Exponential.sol";
7 import "../EIP20Interface.sol";
8 import "../EIP20NonStandardInterface.sol";
9 import "../InterestRateModel.sol";
10 
11 /**
12  * @title Deprecated CToken Contract only for CEther.
13  * @dev CEther will not be used anymore and existing CEther can't be upgraded.
14  * @author Cream
15  */
16 contract CTokenDeprecated is CTokenInterface, Exponential, TokenErrorReporter {
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
62      * @notice Transfer `tokens` tokens from `src` to `dst` by `spender`
63      * @dev Called by both `transfer` and `transferFrom` internally
64      * @param spender The address of the account performing the transfer
65      * @param src The address of the source account
66      * @param dst The address of the destination account
67      * @param tokens The number of tokens to transfer
68      * @return Whether or not the transfer succeeded
69      */
70     function transferTokens(
71         address spender,
72         address src,
73         address dst,
74         uint256 tokens
75     ) internal returns (uint256) {
76         /* Fail if transfer not allowed */
77         uint256 allowed = comptroller.transferAllowed(address(this), src, dst, tokens);
78         if (allowed != 0) {
79             return failOpaque(Error.COMPTROLLER_REJECTION, FailureInfo.TRANSFER_COMPTROLLER_REJECTION, allowed);
80         }
81 
82         /* Do not allow self-transfers */
83         if (src == dst) {
84             return fail(Error.BAD_INPUT, FailureInfo.TRANSFER_NOT_ALLOWED);
85         }
86 
87         /* Get the allowance, infinite for the account owner */
88         uint256 startingAllowance = 0;
89         if (spender == src) {
90             startingAllowance = uint256(-1);
91         } else {
92             startingAllowance = transferAllowances[src][spender];
93         }
94 
95         /* Do the calculations, checking for {under,over}flow */
96         uint256 allowanceNew = sub_(startingAllowance, tokens);
97         uint256 srcTokensNew = sub_(accountTokens[src], tokens);
98         uint256 dstTokensNew = add_(accountTokens[dst], tokens);
99 
100         /////////////////////////
101         // EFFECTS & INTERACTIONS
102         // (No safe failures beyond this point)
103 
104         accountTokens[src] = srcTokensNew;
105         accountTokens[dst] = dstTokensNew;
106 
107         /* Eat some of the allowance (if necessary) */
108         if (startingAllowance != uint256(-1)) {
109             transferAllowances[src][spender] = allowanceNew;
110         }
111 
112         /* We emit a Transfer event */
113         emit Transfer(src, dst, tokens);
114 
115         comptroller.transferVerify(address(this), src, dst, tokens);
116 
117         return uint256(Error.NO_ERROR);
118     }
119 
120     /**
121      * @notice Transfer `amount` tokens from `msg.sender` to `dst`
122      * @param dst The address of the destination account
123      * @param amount The number of tokens to transfer
124      * @return Whether or not the transfer succeeded
125      */
126     function transfer(address dst, uint256 amount) external nonReentrant returns (bool) {
127         return transferTokens(msg.sender, msg.sender, dst, amount) == uint256(Error.NO_ERROR);
128     }
129 
130     /**
131      * @notice Transfer `amount` tokens from `src` to `dst`
132      * @param src The address of the source account
133      * @param dst The address of the destination account
134      * @param amount The number of tokens to transfer
135      * @return Whether or not the transfer succeeded
136      */
137     function transferFrom(
138         address src,
139         address dst,
140         uint256 amount
141     ) external nonReentrant returns (bool) {
142         return transferTokens(msg.sender, src, dst, amount) == uint256(Error.NO_ERROR);
143     }
144 
145     /**
146      * @notice Approve `spender` to transfer up to `amount` from `src`
147      * @dev This will overwrite the approval amount for `spender`
148      *  and is subject to issues noted [here](https://eips.ethereum.org/EIPS/eip-20#approve)
149      * @param spender The address of the account which may transfer tokens
150      * @param amount The number of tokens that are approved (-1 means infinite)
151      * @return Whether or not the approval succeeded
152      */
153     function approve(address spender, uint256 amount) external returns (bool) {
154         address src = msg.sender;
155         transferAllowances[src][spender] = amount;
156         emit Approval(src, spender, amount);
157         return true;
158     }
159 
160     /**
161      * @notice Get the current allowance from `owner` for `spender`
162      * @param owner The address of the account which owns the tokens to be spent
163      * @param spender The address of the account which may transfer tokens
164      * @return The number of tokens allowed to be spent (-1 means infinite)
165      */
166     function allowance(address owner, address spender) external view returns (uint256) {
167         return transferAllowances[owner][spender];
168     }
169 
170     /**
171      * @notice Get the token balance of the `owner`
172      * @param owner The address of the account to query
173      * @return The number of tokens owned by `owner`
174      */
175     function balanceOf(address owner) external view returns (uint256) {
176         return accountTokens[owner];
177     }
178 
179     /**
180      * @notice Get the underlying balance of the `owner`
181      * @dev This also accrues interest in a transaction
182      * @param owner The address of the account to query
183      * @return The amount of underlying owned by `owner`
184      */
185     function balanceOfUnderlying(address owner) external returns (uint256) {
186         Exp memory exchangeRate = Exp({mantissa: exchangeRateCurrent()});
187         return mul_ScalarTruncate(exchangeRate, accountTokens[owner]);
188     }
189 
190     /**
191      * @notice Get a snapshot of the account's balances, and the cached exchange rate
192      * @dev This is used by comptroller to more efficiently perform liquidity checks.
193      * @param account Address of the account to snapshot
194      * @return (possible error, token balance, borrow balance, exchange rate mantissa)
195      */
196     function getAccountSnapshot(address account)
197         external
198         view
199         returns (
200             uint256,
201             uint256,
202             uint256,
203             uint256
204         )
205     {
206         uint256 cTokenBalance = accountTokens[account];
207         uint256 borrowBalance = borrowBalanceStoredInternal(account);
208         uint256 exchangeRateMantissa = exchangeRateStoredInternal();
209 
210         return (uint256(Error.NO_ERROR), cTokenBalance, borrowBalance, exchangeRateMantissa);
211     }
212 
213     /**
214      * @dev Function to simply retrieve block number
215      *  This exists mainly for inheriting test contracts to stub this result.
216      */
217     function getBlockNumber() internal view returns (uint256) {
218         return block.number;
219     }
220 
221     /**
222      * @notice Returns the current per-block borrow interest rate for this cToken
223      * @return The borrow interest rate per block, scaled by 1e18
224      */
225     function borrowRatePerBlock() external view returns (uint256) {
226         return interestRateModel.getBorrowRate(getCashPrior(), totalBorrows, totalReserves);
227     }
228 
229     /**
230      * @notice Returns the current per-block supply interest rate for this cToken
231      * @return The supply interest rate per block, scaled by 1e18
232      */
233     function supplyRatePerBlock() external view returns (uint256) {
234         return interestRateModel.getSupplyRate(getCashPrior(), totalBorrows, totalReserves, reserveFactorMantissa);
235     }
236 
237     /**
238      * @notice Returns the current total borrows plus accrued interest
239      * @return The total borrows with interest
240      */
241     function totalBorrowsCurrent() external nonReentrant returns (uint256) {
242         require(accrueInterest() == uint256(Error.NO_ERROR), "accrue interest failed");
243         return totalBorrows;
244     }
245 
246     /**
247      * @notice Accrue interest to updated borrowIndex and then calculate account's borrow balance using the updated borrowIndex
248      * @param account The address whose balance should be calculated after updating borrowIndex
249      * @return The calculated balance
250      */
251     function borrowBalanceCurrent(address account) external nonReentrant returns (uint256) {
252         require(accrueInterest() == uint256(Error.NO_ERROR), "accrue interest failed");
253         return borrowBalanceStored(account);
254     }
255 
256     /**
257      * @notice Return the borrow balance of account based on stored data
258      * @param account The address whose balance should be calculated
259      * @return The calculated balance
260      */
261     function borrowBalanceStored(address account) public view returns (uint256) {
262         return borrowBalanceStoredInternal(account);
263     }
264 
265     /**
266      * @notice Return the borrow balance of account based on stored data
267      * @param account The address whose balance should be calculated
268      * @return the calculated balance or 0 if error code is non-zero
269      */
270     function borrowBalanceStoredInternal(address account) internal view returns (uint256) {
271         /* Get borrowBalance and borrowIndex */
272         BorrowSnapshot storage borrowSnapshot = accountBorrows[account];
273 
274         /* If borrowBalance = 0 then borrowIndex is likely also 0.
275          * Rather than failing the calculation with a division by 0, we immediately return 0 in this case.
276          */
277         if (borrowSnapshot.principal == 0) {
278             return 0;
279         }
280 
281         /* Calculate new borrow balance using the interest index:
282          *  recentBorrowBalance = borrower.borrowBalance * market.borrowIndex / borrower.borrowIndex
283          */
284         uint256 principalTimesIndex = mul_(borrowSnapshot.principal, borrowIndex);
285         uint256 result = div_(principalTimesIndex, borrowSnapshot.interestIndex);
286         return result;
287     }
288 
289     /**
290      * @notice Accrue interest then return the up-to-date exchange rate
291      * @return Calculated exchange rate scaled by 1e18
292      */
293     function exchangeRateCurrent() public nonReentrant returns (uint256) {
294         require(accrueInterest() == uint256(Error.NO_ERROR), "accrue interest failed");
295         return exchangeRateStored();
296     }
297 
298     /**
299      * @notice Calculates the exchange rate from the underlying to the CToken
300      * @dev This function does not accrue interest before calculating the exchange rate
301      * @return Calculated exchange rate scaled by 1e18
302      */
303     function exchangeRateStored() public view returns (uint256) {
304         return exchangeRateStoredInternal();
305     }
306 
307     /**
308      * @notice Calculates the exchange rate from the underlying to the CToken
309      * @dev This function does not accrue interest before calculating the exchange rate
310      * @return calculated exchange rate scaled by 1e18
311      */
312     function exchangeRateStoredInternal() internal view returns (uint256) {
313         uint256 _totalSupply = totalSupply;
314         if (_totalSupply == 0) {
315             /*
316              * If there are no tokens minted:
317              *  exchangeRate = initialExchangeRate
318              */
319             return initialExchangeRateMantissa;
320         } else {
321             /*
322              * Otherwise:
323              *  exchangeRate = (totalCash + totalBorrows - totalReserves) / totalSupply
324              */
325             uint256 totalCash = getCashPrior();
326             uint256 cashPlusBorrowsMinusReserves = sub_(add_(totalCash, totalBorrows), totalReserves);
327             uint256 exchangeRate = div_(cashPlusBorrowsMinusReserves, Exp({mantissa: _totalSupply}));
328             return exchangeRate;
329         }
330     }
331 
332     /**
333      * @notice Get cash balance of this cToken in the underlying asset
334      * @return The quantity of underlying asset owned by this contract
335      */
336     function getCash() external view returns (uint256) {
337         return getCashPrior();
338     }
339 
340     /**
341      * @notice Applies accrued interest to total borrows and reserves
342      * @dev This calculates interest accrued from the last checkpointed block
343      *   up to the current block and writes new checkpoint to storage.
344      */
345     function accrueInterest() public returns (uint256) {
346         /* Remember the initial block number */
347         uint256 currentBlockNumber = getBlockNumber();
348         uint256 accrualBlockNumberPrior = accrualBlockNumber;
349 
350         /* Short-circuit accumulating 0 interest */
351         if (accrualBlockNumberPrior == currentBlockNumber) {
352             return uint256(Error.NO_ERROR);
353         }
354 
355         /* Read the previous values out of storage */
356         uint256 cashPrior = getCashPrior();
357         uint256 borrowsPrior = totalBorrows;
358         uint256 reservesPrior = totalReserves;
359         uint256 borrowIndexPrior = borrowIndex;
360 
361         /* Calculate the current borrow interest rate */
362         uint256 borrowRateMantissa = interestRateModel.getBorrowRate(cashPrior, borrowsPrior, reservesPrior);
363         require(borrowRateMantissa <= borrowRateMaxMantissa, "borrow rate is absurdly high");
364 
365         /* Calculate the number of blocks elapsed since the last accrual */
366         uint256 blockDelta = sub_(currentBlockNumber, accrualBlockNumberPrior);
367 
368         /*
369          * Calculate the interest accumulated into borrows and reserves and the new index:
370          *  simpleInterestFactor = borrowRate * blockDelta
371          *  interestAccumulated = simpleInterestFactor * totalBorrows
372          *  totalBorrowsNew = interestAccumulated + totalBorrows
373          *  totalReservesNew = interestAccumulated * reserveFactor + totalReserves
374          *  borrowIndexNew = simpleInterestFactor * borrowIndex + borrowIndex
375          */
376 
377         Exp memory simpleInterestFactor = mul_(Exp({mantissa: borrowRateMantissa}), blockDelta);
378         uint256 interestAccumulated = mul_ScalarTruncate(simpleInterestFactor, borrowsPrior);
379         uint256 totalBorrowsNew = add_(interestAccumulated, borrowsPrior);
380         uint256 totalReservesNew = mul_ScalarTruncateAddUInt(
381             Exp({mantissa: reserveFactorMantissa}),
382             interestAccumulated,
383             reservesPrior
384         );
385         uint256 borrowIndexNew = mul_ScalarTruncateAddUInt(simpleInterestFactor, borrowIndexPrior, borrowIndexPrior);
386 
387         /////////////////////////
388         // EFFECTS & INTERACTIONS
389         // (No safe failures beyond this point)
390 
391         /* We write the previously calculated values into storage */
392         accrualBlockNumber = currentBlockNumber;
393         borrowIndex = borrowIndexNew;
394         totalBorrows = totalBorrowsNew;
395         totalReserves = totalReservesNew;
396 
397         /* We emit an AccrueInterest event */
398         emit AccrueInterest(cashPrior, interestAccumulated, borrowIndexNew, totalBorrowsNew);
399 
400         return uint256(Error.NO_ERROR);
401     }
402 
403     /**
404      * @notice Sender supplies assets into the market and receives cTokens in exchange
405      * @dev Accrues interest whether or not the operation succeeds, unless reverted
406      * @param mintAmount The amount of the underlying asset to supply
407      * @return (uint, uint) An error code (0=success, otherwise a failure, see ErrorReporter.sol), and the actual mint amount.
408      */
409     function mintInternal(uint256 mintAmount) internal nonReentrant returns (uint256, uint256) {
410         uint256 error = accrueInterest();
411         if (error != uint256(Error.NO_ERROR)) {
412             // accrueInterest emits logs on errors, but we still want to log the fact that an attempted borrow failed
413             return (fail(Error(error), FailureInfo.MINT_ACCRUE_INTEREST_FAILED), 0);
414         }
415         // mintFresh emits the actual Mint event if successful and logs on errors, so we don't need to
416         return mintFresh(msg.sender, mintAmount);
417     }
418 
419     struct MintLocalVars {
420         Error err;
421         MathError mathErr;
422         uint256 exchangeRateMantissa;
423         uint256 mintTokens;
424         uint256 totalSupplyNew;
425         uint256 accountTokensNew;
426         uint256 actualMintAmount;
427     }
428 
429     /**
430      * @notice User supplies assets into the market and receives cTokens in exchange
431      * @dev Assumes interest has already been accrued up to the current block
432      * @param minter The address of the account which is supplying the assets
433      * @param mintAmount The amount of the underlying asset to supply
434      * @return (uint, uint) An error code (0=success, otherwise a failure, see ErrorReporter.sol), and the actual mint amount.
435      */
436     function mintFresh(address minter, uint256 mintAmount) internal returns (uint256, uint256) {
437         /* Fail if mint not allowed */
438         uint256 allowed = comptroller.mintAllowed(address(this), minter, mintAmount);
439         if (allowed != 0) {
440             return (failOpaque(Error.COMPTROLLER_REJECTION, FailureInfo.MINT_COMPTROLLER_REJECTION, allowed), 0);
441         }
442 
443         /* Verify market's block number equals current block number */
444         if (accrualBlockNumber != getBlockNumber()) {
445             return (fail(Error.MARKET_NOT_FRESH, FailureInfo.MINT_FRESHNESS_CHECK), 0);
446         }
447 
448         MintLocalVars memory vars;
449 
450         vars.exchangeRateMantissa = exchangeRateStoredInternal();
451 
452         /////////////////////////
453         // EFFECTS & INTERACTIONS
454         // (No safe failures beyond this point)
455 
456         /*
457          *  We call `doTransferIn` for the minter and the mintAmount.
458          *  Note: The cToken must handle variations between ERC-20 and ETH underlying.
459          *  `doTransferIn` reverts if anything goes wrong, since we can't be sure if
460          *  side-effects occurred. The function returns the amount actually transferred,
461          *  in case of a fee. On success, the cToken holds an additional `actualMintAmount`
462          *  of cash.
463          */
464         vars.actualMintAmount = doTransferIn(minter, mintAmount);
465 
466         /*
467          * We get the current exchange rate and calculate the number of cTokens to be minted:
468          *  mintTokens = actualMintAmount / exchangeRate
469          */
470 
471         vars.mintTokens = div_ScalarByExpTruncate(vars.actualMintAmount, Exp({mantissa: vars.exchangeRateMantissa}));
472 
473         /*
474          * We calculate the new total supply of cTokens and minter token balance, checking for overflow:
475          *  totalSupplyNew = totalSupply + mintTokens
476          *  accountTokensNew = accountTokens[minter] + mintTokens
477          */
478         vars.totalSupplyNew = add_(totalSupply, vars.mintTokens);
479         vars.accountTokensNew = add_(accountTokens[minter], vars.mintTokens);
480 
481         /* We write previously calculated values into storage */
482         totalSupply = vars.totalSupplyNew;
483         accountTokens[minter] = vars.accountTokensNew;
484 
485         /* We emit a Mint event, and a Transfer event */
486         emit Mint(minter, vars.actualMintAmount, vars.mintTokens);
487         emit Transfer(address(this), minter, vars.mintTokens);
488 
489         /* We call the defense hook */
490         comptroller.mintVerify(address(this), minter, vars.actualMintAmount, vars.mintTokens);
491 
492         return (uint256(Error.NO_ERROR), vars.actualMintAmount);
493     }
494 
495     /**
496      * @notice Sender redeems cTokens in exchange for the underlying asset
497      * @dev Accrues interest whether or not the operation succeeds, unless reverted
498      * @param redeemTokens The number of cTokens to redeem into underlying
499      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
500      */
501     function redeemInternal(uint256 redeemTokens) internal nonReentrant returns (uint256) {
502         uint256 error = accrueInterest();
503         if (error != uint256(Error.NO_ERROR)) {
504             // accrueInterest emits logs on errors, but we still want to log the fact that an attempted redeem failed
505             return fail(Error(error), FailureInfo.REDEEM_ACCRUE_INTEREST_FAILED);
506         }
507         // redeemFresh emits redeem-specific logs on errors, so we don't need to
508         return redeemFresh(msg.sender, redeemTokens, 0);
509     }
510 
511     /**
512      * @notice Sender redeems cTokens in exchange for a specified amount of underlying asset
513      * @dev Accrues interest whether or not the operation succeeds, unless reverted
514      * @param redeemAmount The amount of underlying to receive from redeeming cTokens
515      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
516      */
517     function redeemUnderlyingInternal(uint256 redeemAmount) internal nonReentrant returns (uint256) {
518         uint256 error = accrueInterest();
519         if (error != uint256(Error.NO_ERROR)) {
520             // accrueInterest emits logs on errors, but we still want to log the fact that an attempted redeem failed
521             return fail(Error(error), FailureInfo.REDEEM_ACCRUE_INTEREST_FAILED);
522         }
523         // redeemFresh emits redeem-specific logs on errors, so we don't need to
524         return redeemFresh(msg.sender, 0, redeemAmount);
525     }
526 
527     struct RedeemLocalVars {
528         Error err;
529         MathError mathErr;
530         uint256 exchangeRateMantissa;
531         uint256 redeemTokens;
532         uint256 redeemAmount;
533         uint256 totalSupplyNew;
534         uint256 accountTokensNew;
535     }
536 
537     /**
538      * @notice User redeems cTokens in exchange for the underlying asset
539      * @dev Assumes interest has already been accrued up to the current block
540      * @param redeemer The address of the account which is redeeming the tokens
541      * @param redeemTokensIn The number of cTokens to redeem into underlying (only one of redeemTokensIn or redeemAmountIn may be non-zero)
542      * @param redeemAmountIn The number of underlying tokens to receive from redeeming cTokens (only one of redeemTokensIn or redeemAmountIn may be non-zero)
543      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
544      */
545     function redeemFresh(
546         address payable redeemer,
547         uint256 redeemTokensIn,
548         uint256 redeemAmountIn
549     ) internal returns (uint256) {
550         require(redeemTokensIn == 0 || redeemAmountIn == 0, "one of redeemTokensIn or redeemAmountIn must be zero");
551 
552         RedeemLocalVars memory vars;
553 
554         /* exchangeRate = invoke Exchange Rate Stored() */
555         vars.exchangeRateMantissa = exchangeRateStoredInternal();
556 
557         /* If redeemTokensIn > 0: */
558         if (redeemTokensIn > 0) {
559             /*
560              * We calculate the exchange rate and the amount of underlying to be redeemed:
561              *  redeemTokens = redeemTokensIn
562              *  redeemAmount = redeemTokensIn x exchangeRateCurrent
563              */
564             vars.redeemTokens = redeemTokensIn;
565             vars.redeemAmount = mul_ScalarTruncate(Exp({mantissa: vars.exchangeRateMantissa}), redeemTokensIn);
566         } else {
567             /*
568              * We get the current exchange rate and calculate the amount to be redeemed:
569              *  redeemTokens = redeemAmountIn / exchangeRate
570              *  redeemAmount = redeemAmountIn
571              */
572             vars.redeemTokens = div_ScalarByExpTruncate(redeemAmountIn, Exp({mantissa: vars.exchangeRateMantissa}));
573             vars.redeemAmount = redeemAmountIn;
574         }
575 
576         /* Fail if redeem not allowed */
577         uint256 allowed = comptroller.redeemAllowed(address(this), redeemer, vars.redeemTokens);
578         if (allowed != 0) {
579             return failOpaque(Error.COMPTROLLER_REJECTION, FailureInfo.REDEEM_COMPTROLLER_REJECTION, allowed);
580         }
581 
582         /* Verify market's block number equals current block number */
583         if (accrualBlockNumber != getBlockNumber()) {
584             return fail(Error.MARKET_NOT_FRESH, FailureInfo.REDEEM_FRESHNESS_CHECK);
585         }
586 
587         /*
588          * We calculate the new total supply and redeemer balance, checking for underflow:
589          *  totalSupplyNew = totalSupply - redeemTokens
590          *  accountTokensNew = accountTokens[redeemer] - redeemTokens
591          */
592         vars.totalSupplyNew = sub_(totalSupply, vars.redeemTokens);
593         vars.accountTokensNew = sub_(accountTokens[redeemer], vars.redeemTokens);
594 
595         /* Fail gracefully if protocol has insufficient cash */
596         if (getCashPrior() < vars.redeemAmount) {
597             return fail(Error.TOKEN_INSUFFICIENT_CASH, FailureInfo.REDEEM_TRANSFER_OUT_NOT_POSSIBLE);
598         }
599 
600         /////////////////////////
601         // EFFECTS & INTERACTIONS
602         // (No safe failures beyond this point)
603 
604         /*
605          * We invoke doTransferOut for the redeemer and the redeemAmount.
606          *  Note: The cToken must handle variations between ERC-20 and ETH underlying.
607          *  On success, the cToken has redeemAmount less of cash.
608          *  doTransferOut reverts if anything goes wrong, since we can't be sure if side effects occurred.
609          */
610         doTransferOut(redeemer, vars.redeemAmount);
611 
612         /* We write previously calculated values into storage */
613         totalSupply = vars.totalSupplyNew;
614         accountTokens[redeemer] = vars.accountTokensNew;
615 
616         /* We emit a Transfer event, and a Redeem event */
617         emit Transfer(redeemer, address(this), vars.redeemTokens);
618         emit Redeem(redeemer, vars.redeemAmount, vars.redeemTokens);
619 
620         /* We call the defense hook */
621         comptroller.redeemVerify(address(this), redeemer, vars.redeemAmount, vars.redeemTokens);
622 
623         return uint256(Error.NO_ERROR);
624     }
625 
626     /**
627      * @notice Sender borrows assets from the protocol to their own address
628      * @param borrowAmount The amount of the underlying asset to borrow
629      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
630      */
631     function borrowInternal(uint256 borrowAmount) internal nonReentrant returns (uint256) {
632         uint256 error = accrueInterest();
633         if (error != uint256(Error.NO_ERROR)) {
634             // accrueInterest emits logs on errors, but we still want to log the fact that an attempted borrow failed
635             return fail(Error(error), FailureInfo.BORROW_ACCRUE_INTEREST_FAILED);
636         }
637         // borrowFresh emits borrow-specific logs on errors, so we don't need to
638         return borrowFresh(msg.sender, borrowAmount);
639     }
640 
641     struct BorrowLocalVars {
642         MathError mathErr;
643         uint256 accountBorrows;
644         uint256 accountBorrowsNew;
645         uint256 totalBorrowsNew;
646     }
647 
648     /**
649      * @notice Users borrow assets from the protocol to their own address
650      * @param borrowAmount The amount of the underlying asset to borrow
651      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
652      */
653     function borrowFresh(address payable borrower, uint256 borrowAmount) internal returns (uint256) {
654         /* Fail if borrow not allowed */
655         uint256 allowed = comptroller.borrowAllowed(address(this), borrower, borrowAmount);
656         if (allowed != 0) {
657             return failOpaque(Error.COMPTROLLER_REJECTION, FailureInfo.BORROW_COMPTROLLER_REJECTION, allowed);
658         }
659 
660         /* Verify market's block number equals current block number */
661         if (accrualBlockNumber != getBlockNumber()) {
662             return fail(Error.MARKET_NOT_FRESH, FailureInfo.BORROW_FRESHNESS_CHECK);
663         }
664 
665         /* Fail gracefully if protocol has insufficient underlying cash */
666         if (getCashPrior() < borrowAmount) {
667             return fail(Error.TOKEN_INSUFFICIENT_CASH, FailureInfo.BORROW_CASH_NOT_AVAILABLE);
668         }
669 
670         BorrowLocalVars memory vars;
671 
672         /*
673          * We calculate the new borrower and total borrow balances, failing on overflow:
674          *  accountBorrowsNew = accountBorrows + borrowAmount
675          *  totalBorrowsNew = totalBorrows + borrowAmount
676          */
677         vars.accountBorrows = borrowBalanceStoredInternal(borrower);
678         vars.accountBorrowsNew = add_(vars.accountBorrows, borrowAmount);
679         vars.totalBorrowsNew = add_(totalBorrows, borrowAmount);
680 
681         /////////////////////////
682         // EFFECTS & INTERACTIONS
683         // (No safe failures beyond this point)
684 
685         /*
686          * We invoke doTransferOut for the borrower and the borrowAmount.
687          *  Note: The cToken must handle variations between ERC-20 and ETH underlying.
688          *  On success, the cToken borrowAmount less of cash.
689          *  doTransferOut reverts if anything goes wrong, since we can't be sure if side effects occurred.
690          */
691         doTransferOut(borrower, borrowAmount);
692 
693         /* We write the previously calculated values into storage */
694         accountBorrows[borrower].principal = vars.accountBorrowsNew;
695         accountBorrows[borrower].interestIndex = borrowIndex;
696         totalBorrows = vars.totalBorrowsNew;
697 
698         /* We emit a Borrow event */
699         emit Borrow(borrower, borrowAmount, vars.accountBorrowsNew, vars.totalBorrowsNew);
700 
701         /* We call the defense hook */
702         comptroller.borrowVerify(address(this), borrower, borrowAmount);
703 
704         return uint256(Error.NO_ERROR);
705     }
706 
707     /**
708      * @notice Sender repays their own borrow
709      * @param repayAmount The amount to repay
710      * @return (uint, uint) An error code (0=success, otherwise a failure, see ErrorReporter.sol), and the actual repayment amount.
711      */
712     function repayBorrowInternal(uint256 repayAmount) internal nonReentrant returns (uint256, uint256) {
713         uint256 error = accrueInterest();
714         if (error != uint256(Error.NO_ERROR)) {
715             // accrueInterest emits logs on errors, but we still want to log the fact that an attempted borrow failed
716             return (fail(Error(error), FailureInfo.REPAY_BORROW_ACCRUE_INTEREST_FAILED), 0);
717         }
718         // repayBorrowFresh emits repay-borrow-specific logs on errors, so we don't need to
719         return repayBorrowFresh(msg.sender, msg.sender, repayAmount);
720     }
721 
722     /**
723      * @notice Sender repays a borrow belonging to borrower
724      * @param borrower the account with the debt being payed off
725      * @param repayAmount The amount to repay
726      * @return (uint, uint) An error code (0=success, otherwise a failure, see ErrorReporter.sol), and the actual repayment amount.
727      */
728     function repayBorrowBehalfInternal(address borrower, uint256 repayAmount)
729         internal
730         nonReentrant
731         returns (uint256, uint256)
732     {
733         uint256 error = accrueInterest();
734         if (error != uint256(Error.NO_ERROR)) {
735             // accrueInterest emits logs on errors, but we still want to log the fact that an attempted borrow failed
736             return (fail(Error(error), FailureInfo.REPAY_BEHALF_ACCRUE_INTEREST_FAILED), 0);
737         }
738         // repayBorrowFresh emits repay-borrow-specific logs on errors, so we don't need to
739         return repayBorrowFresh(msg.sender, borrower, repayAmount);
740     }
741 
742     struct RepayBorrowLocalVars {
743         Error err;
744         MathError mathErr;
745         uint256 repayAmount;
746         uint256 borrowerIndex;
747         uint256 accountBorrows;
748         uint256 accountBorrowsNew;
749         uint256 totalBorrowsNew;
750         uint256 actualRepayAmount;
751     }
752 
753     /**
754      * @notice Borrows are repaid by another user (possibly the borrower).
755      * @param payer the account paying off the borrow
756      * @param borrower the account with the debt being payed off
757      * @param repayAmount the amount of undelrying tokens being returned
758      * @return (uint, uint) An error code (0=success, otherwise a failure, see ErrorReporter.sol), and the actual repayment amount.
759      */
760     function repayBorrowFresh(
761         address payer,
762         address borrower,
763         uint256 repayAmount
764     ) internal returns (uint256, uint256) {
765         /* Fail if repayBorrow not allowed */
766         uint256 allowed = comptroller.repayBorrowAllowed(address(this), payer, borrower, repayAmount);
767         if (allowed != 0) {
768             return (
769                 failOpaque(Error.COMPTROLLER_REJECTION, FailureInfo.REPAY_BORROW_COMPTROLLER_REJECTION, allowed),
770                 0
771             );
772         }
773 
774         /* Verify market's block number equals current block number */
775         if (accrualBlockNumber != getBlockNumber()) {
776             return (fail(Error.MARKET_NOT_FRESH, FailureInfo.REPAY_BORROW_FRESHNESS_CHECK), 0);
777         }
778 
779         RepayBorrowLocalVars memory vars;
780 
781         /* We remember the original borrowerIndex for verification purposes */
782         vars.borrowerIndex = accountBorrows[borrower].interestIndex;
783 
784         /* We fetch the amount the borrower owes, with accumulated interest */
785         vars.accountBorrows = borrowBalanceStoredInternal(borrower);
786 
787         /* If repayAmount == -1, repayAmount = accountBorrows */
788         if (repayAmount == uint256(-1)) {
789             vars.repayAmount = vars.accountBorrows;
790         } else {
791             vars.repayAmount = repayAmount;
792         }
793 
794         /////////////////////////
795         // EFFECTS & INTERACTIONS
796         // (No safe failures beyond this point)
797 
798         /*
799          * We call doTransferIn for the payer and the repayAmount
800          *  Note: The cToken must handle variations between ERC-20 and ETH underlying.
801          *  On success, the cToken holds an additional repayAmount of cash.
802          *  doTransferIn reverts if anything goes wrong, since we can't be sure if side effects occurred.
803          *   it returns the amount actually transferred, in case of a fee.
804          */
805         vars.actualRepayAmount = doTransferIn(payer, vars.repayAmount);
806 
807         /*
808          * We calculate the new borrower and total borrow balances, failing on underflow:
809          *  accountBorrowsNew = accountBorrows - actualRepayAmount
810          *  totalBorrowsNew = totalBorrows - actualRepayAmount
811          */
812         vars.accountBorrowsNew = sub_(vars.accountBorrows, vars.actualRepayAmount);
813         vars.totalBorrowsNew = sub_(totalBorrows, vars.actualRepayAmount);
814 
815         /* We write the previously calculated values into storage */
816         accountBorrows[borrower].principal = vars.accountBorrowsNew;
817         accountBorrows[borrower].interestIndex = borrowIndex;
818         totalBorrows = vars.totalBorrowsNew;
819 
820         /* We emit a RepayBorrow event */
821         emit RepayBorrow(payer, borrower, vars.actualRepayAmount, vars.accountBorrowsNew, vars.totalBorrowsNew);
822 
823         /* We call the defense hook */
824         comptroller.repayBorrowVerify(address(this), payer, borrower, vars.actualRepayAmount, vars.borrowerIndex);
825 
826         return (uint256(Error.NO_ERROR), vars.actualRepayAmount);
827     }
828 
829     /**
830      * @notice The sender liquidates the borrowers collateral.
831      *  The collateral seized is transferred to the liquidator.
832      * @param borrower The borrower of this cToken to be liquidated
833      * @param cTokenCollateral The market in which to seize collateral from the borrower
834      * @param repayAmount The amount of the underlying borrowed asset to repay
835      * @return (uint, uint) An error code (0=success, otherwise a failure, see ErrorReporter.sol), and the actual repayment amount.
836      */
837     function liquidateBorrowInternal(
838         address borrower,
839         uint256 repayAmount,
840         CTokenInterface cTokenCollateral
841     ) internal nonReentrant returns (uint256, uint256) {
842         uint256 error = accrueInterest();
843         if (error != uint256(Error.NO_ERROR)) {
844             // accrueInterest emits logs on errors, but we still want to log the fact that an attempted liquidation failed
845             return (fail(Error(error), FailureInfo.LIQUIDATE_ACCRUE_BORROW_INTEREST_FAILED), 0);
846         }
847 
848         error = cTokenCollateral.accrueInterest();
849         if (error != uint256(Error.NO_ERROR)) {
850             // accrueInterest emits logs on errors, but we still want to log the fact that an attempted liquidation failed
851             return (fail(Error(error), FailureInfo.LIQUIDATE_ACCRUE_COLLATERAL_INTEREST_FAILED), 0);
852         }
853 
854         // liquidateBorrowFresh emits borrow-specific logs on errors, so we don't need to
855         return liquidateBorrowFresh(msg.sender, borrower, repayAmount, cTokenCollateral);
856     }
857 
858     /**
859      * @notice The liquidator liquidates the borrowers collateral.
860      *  The collateral seized is transferred to the liquidator.
861      * @param borrower The borrower of this cToken to be liquidated
862      * @param liquidator The address repaying the borrow and seizing collateral
863      * @param cTokenCollateral The market in which to seize collateral from the borrower
864      * @param repayAmount The amount of the underlying borrowed asset to repay
865      * @return (uint, uint) An error code (0=success, otherwise a failure, see ErrorReporter.sol), and the actual repayment amount.
866      */
867     function liquidateBorrowFresh(
868         address liquidator,
869         address borrower,
870         uint256 repayAmount,
871         CTokenInterface cTokenCollateral
872     ) internal returns (uint256, uint256) {
873         /* Fail if liquidate not allowed */
874         uint256 allowed = comptroller.liquidateBorrowAllowed(
875             address(this),
876             address(cTokenCollateral),
877             liquidator,
878             borrower,
879             repayAmount
880         );
881         if (allowed != 0) {
882             return (failOpaque(Error.COMPTROLLER_REJECTION, FailureInfo.LIQUIDATE_COMPTROLLER_REJECTION, allowed), 0);
883         }
884 
885         /* Verify market's block number equals current block number */
886         if (accrualBlockNumber != getBlockNumber()) {
887             return (fail(Error.MARKET_NOT_FRESH, FailureInfo.LIQUIDATE_FRESHNESS_CHECK), 0);
888         }
889 
890         /* Verify cTokenCollateral market's block number equals current block number */
891         if (cTokenCollateral.accrualBlockNumber() != getBlockNumber()) {
892             return (fail(Error.MARKET_NOT_FRESH, FailureInfo.LIQUIDATE_COLLATERAL_FRESHNESS_CHECK), 0);
893         }
894 
895         /* Fail if borrower = liquidator */
896         if (borrower == liquidator) {
897             return (fail(Error.INVALID_ACCOUNT_PAIR, FailureInfo.LIQUIDATE_LIQUIDATOR_IS_BORROWER), 0);
898         }
899 
900         /* Fail if repayAmount = 0 */
901         if (repayAmount == 0) {
902             return (fail(Error.INVALID_CLOSE_AMOUNT_REQUESTED, FailureInfo.LIQUIDATE_CLOSE_AMOUNT_IS_ZERO), 0);
903         }
904 
905         /* Fail if repayAmount = -1 */
906         if (repayAmount == uint256(-1)) {
907             return (fail(Error.INVALID_CLOSE_AMOUNT_REQUESTED, FailureInfo.LIQUIDATE_CLOSE_AMOUNT_IS_UINT_MAX), 0);
908         }
909 
910         /* Fail if repayBorrow fails */
911         (uint256 repayBorrowError, uint256 actualRepayAmount) = repayBorrowFresh(liquidator, borrower, repayAmount);
912         if (repayBorrowError != uint256(Error.NO_ERROR)) {
913             return (fail(Error(repayBorrowError), FailureInfo.LIQUIDATE_REPAY_BORROW_FRESH_FAILED), 0);
914         }
915 
916         /////////////////////////
917         // EFFECTS & INTERACTIONS
918         // (No safe failures beyond this point)
919 
920         /* We calculate the number of collateral tokens that will be seized */
921         (uint256 amountSeizeError, uint256 seizeTokens) = comptroller.liquidateCalculateSeizeTokens(
922             address(this),
923             address(cTokenCollateral),
924             actualRepayAmount
925         );
926         require(amountSeizeError == uint256(Error.NO_ERROR), "LIQUIDATE_COMPTROLLER_CALCULATE_AMOUNT_SEIZE_FAILED");
927 
928         /* Revert if borrower collateral token balance < seizeTokens */
929         require(cTokenCollateral.balanceOf(borrower) >= seizeTokens, "LIQUIDATE_SEIZE_TOO_MUCH");
930 
931         // If this is also the collateral, run seizeInternal to avoid re-entrancy, otherwise make an external call
932         uint256 seizeError;
933         if (address(cTokenCollateral) == address(this)) {
934             seizeError = seizeInternal(address(this), liquidator, borrower, seizeTokens);
935         } else {
936             seizeError = cTokenCollateral.seize(liquidator, borrower, seizeTokens);
937         }
938 
939         /* Revert if seize tokens fails (since we cannot be sure of side effects) */
940         require(seizeError == uint256(Error.NO_ERROR), "token seizure failed");
941 
942         /* We emit a LiquidateBorrow event */
943         emit LiquidateBorrow(liquidator, borrower, actualRepayAmount, address(cTokenCollateral), seizeTokens);
944 
945         /* We call the defense hook */
946         comptroller.liquidateBorrowVerify(
947             address(this),
948             address(cTokenCollateral),
949             liquidator,
950             borrower,
951             actualRepayAmount,
952             seizeTokens
953         );
954 
955         return (uint256(Error.NO_ERROR), actualRepayAmount);
956     }
957 
958     /**
959      * @notice Transfers collateral tokens (this market) to the liquidator.
960      * @dev Will fail unless called by another cToken during the process of liquidation.
961      *  Its absolutely critical to use msg.sender as the borrowed cToken and not a parameter.
962      * @param liquidator The account receiving seized collateral
963      * @param borrower The account having collateral seized
964      * @param seizeTokens The number of cTokens to seize
965      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
966      */
967     function seize(
968         address liquidator,
969         address borrower,
970         uint256 seizeTokens
971     ) external nonReentrant returns (uint256) {
972         return seizeInternal(msg.sender, liquidator, borrower, seizeTokens);
973     }
974 
975     /**
976      * @notice Transfers collateral tokens (this market) to the liquidator.
977      * @dev Called only during an in-kind liquidation, or by liquidateBorrow during the liquidation of another CToken.
978      *  Its absolutely critical to use msg.sender as the seizer cToken and not a parameter.
979      * @param seizerToken The contract seizing the collateral (i.e. borrowed cToken)
980      * @param liquidator The account receiving seized collateral
981      * @param borrower The account having collateral seized
982      * @param seizeTokens The number of cTokens to seize
983      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
984      */
985     function seizeInternal(
986         address seizerToken,
987         address liquidator,
988         address borrower,
989         uint256 seizeTokens
990     ) internal returns (uint256) {
991         /* Fail if seize not allowed */
992         uint256 allowed = comptroller.seizeAllowed(address(this), seizerToken, liquidator, borrower, seizeTokens);
993         if (allowed != 0) {
994             return failOpaque(Error.COMPTROLLER_REJECTION, FailureInfo.LIQUIDATE_SEIZE_COMPTROLLER_REJECTION, allowed);
995         }
996 
997         /* Fail if borrower = liquidator */
998         if (borrower == liquidator) {
999             return fail(Error.INVALID_ACCOUNT_PAIR, FailureInfo.LIQUIDATE_SEIZE_LIQUIDATOR_IS_BORROWER);
1000         }
1001 
1002         /*
1003          * We calculate the new borrower and liquidator token balances, failing on underflow/overflow:
1004          *  borrowerTokensNew = accountTokens[borrower] - seizeTokens
1005          *  liquidatorTokensNew = accountTokens[liquidator] + seizeTokens
1006          */
1007         uint256 borrowerTokensNew = sub_(accountTokens[borrower], seizeTokens);
1008         uint256 liquidatorTokensNew = add_(accountTokens[liquidator], seizeTokens);
1009 
1010         /////////////////////////
1011         // EFFECTS & INTERACTIONS
1012         // (No safe failures beyond this point)
1013 
1014         /* We write the previously calculated values into storage */
1015         accountTokens[borrower] = borrowerTokensNew;
1016         accountTokens[liquidator] = liquidatorTokensNew;
1017 
1018         /* Emit a Transfer event */
1019         emit Transfer(borrower, liquidator, seizeTokens);
1020 
1021         /* We call the defense hook */
1022         comptroller.seizeVerify(address(this), seizerToken, liquidator, borrower, seizeTokens);
1023 
1024         return uint256(Error.NO_ERROR);
1025     }
1026 
1027     /*** Admin Functions ***/
1028 
1029     /**
1030      * @notice Begins transfer of admin rights. The newPendingAdmin must call `_acceptAdmin` to finalize the transfer.
1031      * @dev Admin function to begin change of admin. The newPendingAdmin must call `_acceptAdmin` to finalize the transfer.
1032      * @param newPendingAdmin New pending admin.
1033      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
1034      */
1035     function _setPendingAdmin(address payable newPendingAdmin) external returns (uint256) {
1036         // Check caller = admin
1037         if (msg.sender != admin) {
1038             return fail(Error.UNAUTHORIZED, FailureInfo.SET_PENDING_ADMIN_OWNER_CHECK);
1039         }
1040 
1041         // Save current value, if any, for inclusion in log
1042         address oldPendingAdmin = pendingAdmin;
1043 
1044         // Store pendingAdmin with value newPendingAdmin
1045         pendingAdmin = newPendingAdmin;
1046 
1047         // Emit NewPendingAdmin(oldPendingAdmin, newPendingAdmin)
1048         emit NewPendingAdmin(oldPendingAdmin, newPendingAdmin);
1049 
1050         return uint256(Error.NO_ERROR);
1051     }
1052 
1053     /**
1054      * @notice Accepts transfer of admin rights. msg.sender must be pendingAdmin
1055      * @dev Admin function for pending admin to accept role and update admin
1056      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
1057      */
1058     function _acceptAdmin() external returns (uint256) {
1059         // Check caller is pendingAdmin and pendingAdmin ≠ address(0)
1060         if (msg.sender != pendingAdmin || msg.sender == address(0)) {
1061             return fail(Error.UNAUTHORIZED, FailureInfo.ACCEPT_ADMIN_PENDING_ADMIN_CHECK);
1062         }
1063 
1064         // Save current values for inclusion in log
1065         address oldAdmin = admin;
1066         address oldPendingAdmin = pendingAdmin;
1067 
1068         // Store admin with value pendingAdmin
1069         admin = pendingAdmin;
1070 
1071         // Clear the pending value
1072         pendingAdmin = address(0);
1073 
1074         emit NewAdmin(oldAdmin, admin);
1075         emit NewPendingAdmin(oldPendingAdmin, pendingAdmin);
1076 
1077         return uint256(Error.NO_ERROR);
1078     }
1079 
1080     /**
1081      * @notice Sets a new comptroller for the market
1082      * @dev Admin function to set a new comptroller
1083      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
1084      */
1085     function _setComptroller(ComptrollerInterface newComptroller) public returns (uint256) {
1086         // Check caller is admin
1087         if (msg.sender != admin) {
1088             return fail(Error.UNAUTHORIZED, FailureInfo.SET_COMPTROLLER_OWNER_CHECK);
1089         }
1090 
1091         ComptrollerInterface oldComptroller = comptroller;
1092         // Ensure invoke comptroller.isComptroller() returns true
1093         require(newComptroller.isComptroller(), "marker method returned false");
1094 
1095         // Set market's comptroller to newComptroller
1096         comptroller = newComptroller;
1097 
1098         // Emit NewComptroller(oldComptroller, newComptroller)
1099         emit NewComptroller(oldComptroller, newComptroller);
1100 
1101         return uint256(Error.NO_ERROR);
1102     }
1103 
1104     /**
1105      * @notice accrues interest and sets a new reserve factor for the protocol using _setReserveFactorFresh
1106      * @dev Admin function to accrue interest and set a new reserve factor
1107      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
1108      */
1109     function _setReserveFactor(uint256 newReserveFactorMantissa) external nonReentrant returns (uint256) {
1110         uint256 error = accrueInterest();
1111         if (error != uint256(Error.NO_ERROR)) {
1112             // accrueInterest emits logs on errors, but on top of that we want to log the fact that an attempted reserve factor change failed.
1113             return fail(Error(error), FailureInfo.SET_RESERVE_FACTOR_ACCRUE_INTEREST_FAILED);
1114         }
1115         // _setReserveFactorFresh emits reserve-factor-specific logs on errors, so we don't need to.
1116         return _setReserveFactorFresh(newReserveFactorMantissa);
1117     }
1118 
1119     /**
1120      * @notice Sets a new reserve factor for the protocol (*requires fresh interest accrual)
1121      * @dev Admin function to set a new reserve factor
1122      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
1123      */
1124     function _setReserveFactorFresh(uint256 newReserveFactorMantissa) internal returns (uint256) {
1125         // Check caller is admin
1126         if (msg.sender != admin) {
1127             return fail(Error.UNAUTHORIZED, FailureInfo.SET_RESERVE_FACTOR_ADMIN_CHECK);
1128         }
1129 
1130         // Verify market's block number equals current block number
1131         if (accrualBlockNumber != getBlockNumber()) {
1132             return fail(Error.MARKET_NOT_FRESH, FailureInfo.SET_RESERVE_FACTOR_FRESH_CHECK);
1133         }
1134 
1135         // Check newReserveFactor ≤ maxReserveFactor
1136         if (newReserveFactorMantissa > reserveFactorMaxMantissa) {
1137             return fail(Error.BAD_INPUT, FailureInfo.SET_RESERVE_FACTOR_BOUNDS_CHECK);
1138         }
1139 
1140         uint256 oldReserveFactorMantissa = reserveFactorMantissa;
1141         reserveFactorMantissa = newReserveFactorMantissa;
1142 
1143         emit NewReserveFactor(oldReserveFactorMantissa, newReserveFactorMantissa);
1144 
1145         return uint256(Error.NO_ERROR);
1146     }
1147 
1148     /**
1149      * @notice Accrues interest and reduces reserves by transferring from msg.sender
1150      * @param addAmount Amount of addition to reserves
1151      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
1152      */
1153     function _addReservesInternal(uint256 addAmount) internal nonReentrant returns (uint256) {
1154         uint256 error = accrueInterest();
1155         if (error != uint256(Error.NO_ERROR)) {
1156             // accrueInterest emits logs on errors, but on top of that we want to log the fact that an attempted reduce reserves failed.
1157             return fail(Error(error), FailureInfo.ADD_RESERVES_ACCRUE_INTEREST_FAILED);
1158         }
1159 
1160         // _addReservesFresh emits reserve-addition-specific logs on errors, so we don't need to.
1161         (error, ) = _addReservesFresh(addAmount);
1162         return error;
1163     }
1164 
1165     /**
1166      * @notice Add reserves by transferring from caller
1167      * @dev Requires fresh interest accrual
1168      * @param addAmount Amount of addition to reserves
1169      * @return (uint, uint) An error code (0=success, otherwise a failure (see ErrorReporter.sol for details)) and the actual amount added, net token fees
1170      */
1171     function _addReservesFresh(uint256 addAmount) internal returns (uint256, uint256) {
1172         // totalReserves + actualAddAmount
1173         uint256 totalReservesNew;
1174         uint256 actualAddAmount;
1175 
1176         // We fail gracefully unless market's block number equals current block number
1177         if (accrualBlockNumber != getBlockNumber()) {
1178             return (fail(Error.MARKET_NOT_FRESH, FailureInfo.ADD_RESERVES_FRESH_CHECK), actualAddAmount);
1179         }
1180 
1181         /////////////////////////
1182         // EFFECTS & INTERACTIONS
1183         // (No safe failures beyond this point)
1184 
1185         /*
1186          * We call doTransferIn for the caller and the addAmount
1187          *  Note: The cToken must handle variations between ERC-20 and ETH underlying.
1188          *  On success, the cToken holds an additional addAmount of cash.
1189          *  doTransferIn reverts if anything goes wrong, since we can't be sure if side effects occurred.
1190          *  it returns the amount actually transferred, in case of a fee.
1191          */
1192 
1193         actualAddAmount = doTransferIn(msg.sender, addAmount);
1194 
1195         totalReservesNew = add_(totalReserves, actualAddAmount);
1196 
1197         // Store reserves[n+1] = reserves[n] + actualAddAmount
1198         totalReserves = totalReservesNew;
1199 
1200         /* Emit NewReserves(admin, actualAddAmount, reserves[n+1]) */
1201         emit ReservesAdded(msg.sender, actualAddAmount, totalReservesNew);
1202 
1203         /* Return (NO_ERROR, actualAddAmount) */
1204         return (uint256(Error.NO_ERROR), actualAddAmount);
1205     }
1206 
1207     /**
1208      * @notice Accrues interest and reduces reserves by transferring to admin
1209      * @param reduceAmount Amount of reduction to reserves
1210      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
1211      */
1212     function _reduceReserves(uint256 reduceAmount) external nonReentrant returns (uint256) {
1213         uint256 error = accrueInterest();
1214         if (error != uint256(Error.NO_ERROR)) {
1215             // accrueInterest emits logs on errors, but on top of that we want to log the fact that an attempted reduce reserves failed.
1216             return fail(Error(error), FailureInfo.REDUCE_RESERVES_ACCRUE_INTEREST_FAILED);
1217         }
1218         // _reduceReservesFresh emits reserve-reduction-specific logs on errors, so we don't need to.
1219         return _reduceReservesFresh(reduceAmount);
1220     }
1221 
1222     /**
1223      * @notice Reduces reserves by transferring to admin
1224      * @dev Requires fresh interest accrual
1225      * @param reduceAmount Amount of reduction to reserves
1226      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
1227      */
1228     function _reduceReservesFresh(uint256 reduceAmount) internal returns (uint256) {
1229         // totalReserves - reduceAmount
1230         uint256 totalReservesNew;
1231 
1232         // Check caller is admin
1233         if (msg.sender != admin) {
1234             return fail(Error.UNAUTHORIZED, FailureInfo.REDUCE_RESERVES_ADMIN_CHECK);
1235         }
1236 
1237         // We fail gracefully unless market's block number equals current block number
1238         if (accrualBlockNumber != getBlockNumber()) {
1239             return fail(Error.MARKET_NOT_FRESH, FailureInfo.REDUCE_RESERVES_FRESH_CHECK);
1240         }
1241 
1242         // Fail gracefully if protocol has insufficient underlying cash
1243         if (getCashPrior() < reduceAmount) {
1244             return fail(Error.TOKEN_INSUFFICIENT_CASH, FailureInfo.REDUCE_RESERVES_CASH_NOT_AVAILABLE);
1245         }
1246 
1247         // Check reduceAmount ≤ reserves[n] (totalReserves)
1248         if (reduceAmount > totalReserves) {
1249             return fail(Error.BAD_INPUT, FailureInfo.REDUCE_RESERVES_VALIDATION);
1250         }
1251 
1252         /////////////////////////
1253         // EFFECTS & INTERACTIONS
1254         // (No safe failures beyond this point)
1255 
1256         totalReservesNew = sub_(totalReserves, reduceAmount);
1257 
1258         // Store reserves[n+1] = reserves[n] - reduceAmount
1259         totalReserves = totalReservesNew;
1260 
1261         // doTransferOut reverts if anything goes wrong, since we can't be sure if side effects occurred.
1262         doTransferOut(admin, reduceAmount);
1263 
1264         emit ReservesReduced(admin, reduceAmount, totalReservesNew);
1265 
1266         return uint256(Error.NO_ERROR);
1267     }
1268 
1269     /**
1270      * @notice accrues interest and updates the interest rate model using _setInterestRateModelFresh
1271      * @dev Admin function to accrue interest and update the interest rate model
1272      * @param newInterestRateModel the new interest rate model to use
1273      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
1274      */
1275     function _setInterestRateModel(InterestRateModel newInterestRateModel) public returns (uint256) {
1276         uint256 error = accrueInterest();
1277         if (error != uint256(Error.NO_ERROR)) {
1278             // accrueInterest emits logs on errors, but on top of that we want to log the fact that an attempted change of interest rate model failed
1279             return fail(Error(error), FailureInfo.SET_INTEREST_RATE_MODEL_ACCRUE_INTEREST_FAILED);
1280         }
1281         // _setInterestRateModelFresh emits interest-rate-model-update-specific logs on errors, so we don't need to.
1282         return _setInterestRateModelFresh(newInterestRateModel);
1283     }
1284 
1285     /**
1286      * @notice updates the interest rate model (*requires fresh interest accrual)
1287      * @dev Admin function to update the interest rate model
1288      * @param newInterestRateModel the new interest rate model to use
1289      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
1290      */
1291     function _setInterestRateModelFresh(InterestRateModel newInterestRateModel) internal returns (uint256) {
1292         // Used to store old model for use in the event that is emitted on success
1293         InterestRateModel oldInterestRateModel;
1294 
1295         // Check caller is admin
1296         if (msg.sender != admin) {
1297             return fail(Error.UNAUTHORIZED, FailureInfo.SET_INTEREST_RATE_MODEL_OWNER_CHECK);
1298         }
1299 
1300         // We fail gracefully unless market's block number equals current block number
1301         if (accrualBlockNumber != getBlockNumber()) {
1302             return fail(Error.MARKET_NOT_FRESH, FailureInfo.SET_INTEREST_RATE_MODEL_FRESH_CHECK);
1303         }
1304 
1305         // Track the market's current interest rate model
1306         oldInterestRateModel = interestRateModel;
1307 
1308         // Ensure invoke newInterestRateModel.isInterestRateModel() returns true
1309         require(newInterestRateModel.isInterestRateModel(), "marker method returned false");
1310 
1311         // Set the interest rate model to newInterestRateModel
1312         interestRateModel = newInterestRateModel;
1313 
1314         // Emit NewMarketInterestRateModel(oldInterestRateModel, newInterestRateModel)
1315         emit NewMarketInterestRateModel(oldInterestRateModel, newInterestRateModel);
1316 
1317         return uint256(Error.NO_ERROR);
1318     }
1319 
1320     /*** Safe Token ***/
1321 
1322     /**
1323      * @notice Gets balance of this contract in terms of the underlying
1324      * @dev This excludes the value of the current message, if any
1325      * @return The quantity of underlying owned by this contract
1326      */
1327     function getCashPrior() internal view returns (uint256);
1328 
1329     /**
1330      * @dev Performs a transfer in, reverting upon failure. Returns the amount actually transferred to the protocol, in case of a fee.
1331      *  This may revert due to insufficient balance or insufficient allowance.
1332      */
1333     function doTransferIn(address from, uint256 amount) internal returns (uint256);
1334 
1335     /**
1336      * @dev Performs a transfer out, ideally returning an explanatory error code upon failure tather than reverting.
1337      *  If caller has not called checked protocol's balance, may revert due to insufficient cash held in the contract.
1338      *  If caller has checked protocol's balance, and verified it is >= amount, this should not revert in normal conditions.
1339      */
1340     function doTransferOut(address payable to, uint256 amount) internal;
1341 
1342     /*** Reentrancy Guard ***/
1343 
1344     /**
1345      * @dev Prevents a contract from calling itself, directly or indirectly.
1346      */
1347     modifier nonReentrant() {
1348         require(_notEntered, "re-entered");
1349         _notEntered = false;
1350         _;
1351         _notEntered = true; // get a gas-refund post-Istanbul
1352     }
1353 }
