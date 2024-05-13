1 pragma solidity ^0.5.16;
2 
3 import "../CToken.sol";
4 
5 /**
6  * @title Deprecated Cream's CCapableErc20 Contract
7  * @notice CTokens which wrap an EIP-20 underlying
8  * @author Cream
9  */
10 contract CCapableErc20 is CToken, CCapableErc20Interface {
11     /**
12      * @notice Initialize the new money market
13      * @param underlying_ The address of the underlying asset
14      * @param comptroller_ The address of the Comptroller
15      * @param interestRateModel_ The address of the interest rate model
16      * @param initialExchangeRateMantissa_ The initial exchange rate, scaled by 1e18
17      * @param name_ ERC-20 name of this token
18      * @param symbol_ ERC-20 symbol of this token
19      * @param decimals_ ERC-20 decimal precision of this token
20      */
21     function initialize(
22         address underlying_,
23         ComptrollerInterface comptroller_,
24         InterestRateModel interestRateModel_,
25         uint256 initialExchangeRateMantissa_,
26         string memory name_,
27         string memory symbol_,
28         uint8 decimals_
29     ) public {
30         // CToken initialize does the bulk of the work
31         super.initialize(comptroller_, interestRateModel_, initialExchangeRateMantissa_, name_, symbol_, decimals_);
32 
33         // Set underlying and sanity check it
34         underlying = underlying_;
35         EIP20Interface(underlying).totalSupply();
36     }
37 
38     /*** User Interface ***/
39 
40     /**
41      * @notice Sender supplies assets into the market and receives cTokens in exchange
42      * @dev Accrues interest whether or not the operation succeeds, unless reverted
43      * @param mintAmount The amount of the underlying asset to supply
44      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
45      */
46     function mint(uint256 mintAmount) external returns (uint256) {
47         (uint256 err, ) = mintInternal(mintAmount, false);
48         return err;
49     }
50 
51     /**
52      * @notice Sender redeems cTokens in exchange for the underlying asset
53      * @dev Accrues interest whether or not the operation succeeds, unless reverted
54      * @param redeemTokens The number of cTokens to redeem into underlying
55      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
56      */
57     function redeem(uint256 redeemTokens) external returns (uint256) {
58         return redeemInternal(redeemTokens, false);
59     }
60 
61     /**
62      * @notice Sender redeems cTokens in exchange for a specified amount of underlying asset
63      * @dev Accrues interest whether or not the operation succeeds, unless reverted
64      * @param redeemAmount The amount of underlying to redeem
65      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
66      */
67     function redeemUnderlying(uint256 redeemAmount) external returns (uint256) {
68         return redeemUnderlyingInternal(redeemAmount, false);
69     }
70 
71     /**
72      * @notice Sender borrows assets from the protocol to their own address
73      * @param borrowAmount The amount of the underlying asset to borrow
74      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
75      */
76     function borrow(uint256 borrowAmount) external returns (uint256) {
77         return borrowInternal(borrowAmount, false);
78     }
79 
80     /**
81      * @notice Sender repays their own borrow
82      * @param repayAmount The amount to repay
83      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
84      */
85     function repayBorrow(uint256 repayAmount) external returns (uint256) {
86         (uint256 err, ) = repayBorrowInternal(repayAmount, false);
87         return err;
88     }
89 
90     /**
91      * @notice Sender repays a borrow belonging to borrower
92      * @param borrower the account with the debt being payed off
93      * @param repayAmount The amount to repay
94      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
95      */
96     function repayBorrowBehalf(address borrower, uint256 repayAmount) external returns (uint256) {
97         (uint256 err, ) = repayBorrowBehalfInternal(borrower, repayAmount, false);
98         return err;
99     }
100 
101     /**
102      * @notice The sender liquidates the borrowers collateral.
103      *  The collateral seized is transferred to the liquidator.
104      * @param borrower The borrower of this cToken to be liquidated
105      * @param repayAmount The amount of the underlying borrowed asset to repay
106      * @param cTokenCollateral The market in which to seize collateral from the borrower
107      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
108      */
109     function liquidateBorrow(
110         address borrower,
111         uint256 repayAmount,
112         CTokenInterface cTokenCollateral
113     ) external returns (uint256) {
114         (uint256 err, ) = liquidateBorrowInternal(borrower, repayAmount, cTokenCollateral, false);
115         return err;
116     }
117 
118     /**
119      * @notice The sender adds to reserves.
120      * @param addAmount The amount fo underlying token to add as reserves
121      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
122      */
123     function _addReserves(uint256 addAmount) external returns (uint256) {
124         return _addReservesInternal(addAmount, false);
125     }
126 
127     /**
128      * @notice Absorb excess cash into reserves.
129      */
130     function gulp() external nonReentrant {
131         uint256 cashOnChain = getCashOnChain();
132         uint256 cashPrior = getCashPrior();
133 
134         uint256 excessCash = sub_(cashOnChain, cashPrior);
135         totalReserves = add_(totalReserves, excessCash);
136         internalCash = cashOnChain;
137     }
138 
139     /**
140      * @notice Flash loan funds to a given account.
141      * @param receiver The receiver address for the funds
142      * @param amount The amount of the funds to be loaned
143      * @param params The other parameters
144      */
145     function flashLoan(
146         address receiver,
147         uint256 amount,
148         bytes calldata params
149     ) external nonReentrant {
150         require(amount > 0, "flashLoan amount should be greater than zero");
151         require(accrueInterest() == uint256(Error.NO_ERROR), "accrue interest failed");
152 
153         uint256 cashOnChainBefore = getCashOnChain();
154         uint256 cashBefore = getCashPrior();
155         require(cashBefore >= amount, "INSUFFICIENT_LIQUIDITY");
156 
157         // 1. calculate fee, 1 bips = 1/10000
158         uint256 totalFee = div_(mul_(amount, flashFeeBips), 10000);
159 
160         // 2. transfer fund to receiver
161         doTransferOut(address(uint160(receiver)), amount, false);
162 
163         // 3. update totalBorrows
164         totalBorrows = add_(totalBorrows, amount);
165 
166         // 4. execute receiver's callback function
167         IFlashloanReceiver(receiver).executeOperation(msg.sender, underlying, amount, totalFee, params);
168 
169         // 5. check balance
170         uint256 cashOnChainAfter = getCashOnChain();
171         require(cashOnChainAfter == add_(cashOnChainBefore, totalFee), "BALANCE_INCONSISTENT");
172 
173         // 6. update reserves and internal cash and totalBorrows
174         uint256 reservesFee = mul_ScalarTruncate(Exp({mantissa: reserveFactorMantissa}), totalFee);
175         totalReserves = add_(totalReserves, reservesFee);
176         internalCash = add_(cashBefore, totalFee);
177         totalBorrows = sub_(totalBorrows, amount);
178 
179         emit Flashloan(receiver, amount, totalFee, reservesFee);
180     }
181 
182     /*** Safe Token ***/
183 
184     /**
185      * @notice Gets internal balance of this contract in terms of the underlying.
186      *  It excludes balance from direct transfer.
187      * @dev This excludes the value of the current message, if any
188      * @return The quantity of underlying tokens owned by this contract
189      */
190     function getCashPrior() internal view returns (uint256) {
191         return internalCash;
192     }
193 
194     /**
195      * @notice Gets total balance of this contract in terms of the underlying
196      * @dev This excludes the value of the current message, if any
197      * @return The quantity of underlying tokens owned by this contract
198      */
199     function getCashOnChain() internal view returns (uint256) {
200         EIP20Interface token = EIP20Interface(underlying);
201         return token.balanceOf(address(this));
202     }
203 
204     /**
205      * @dev Similar to EIP20 transfer, except it handles a False result from `transferFrom` and reverts in that case.
206      *      This will revert due to insufficient balance or insufficient allowance.
207      *      This function returns the actual amount received,
208      *      which may be less than `amount` if there is a fee attached to the transfer.
209      *
210      *      Note: This wrapper safely handles non-standard ERC-20 tokens that do not return a value.
211      *            See here: https://medium.com/coinmonks/missing-return-value-bug-at-least-130-tokens-affected-d67bf08521ca
212      */
213     function doTransferIn(
214         address from,
215         uint256 amount,
216         bool isNative
217     ) internal returns (uint256) {
218         isNative; // unused
219 
220         EIP20NonStandardInterface token = EIP20NonStandardInterface(underlying);
221         uint256 balanceBefore = EIP20Interface(underlying).balanceOf(address(this));
222         token.transferFrom(from, address(this), amount);
223 
224         bool success;
225         assembly {
226             switch returndatasize()
227             case 0 {
228                 // This is a non-standard ERC-20
229                 success := not(0) // set success to true
230             }
231             case 32 {
232                 // This is a compliant ERC-20
233                 returndatacopy(0, 0, 32)
234                 success := mload(0) // Set `success = returndata` of external call
235             }
236             default {
237                 // This is an excessively non-compliant ERC-20, revert.
238                 revert(0, 0)
239             }
240         }
241         require(success, "TOKEN_TRANSFER_IN_FAILED");
242 
243         // Calculate the amount that was *actually* transferred
244         uint256 balanceAfter = EIP20Interface(underlying).balanceOf(address(this));
245         uint256 transferredIn = sub_(balanceAfter, balanceBefore);
246         internalCash = add_(internalCash, transferredIn);
247         return transferredIn;
248     }
249 
250     /**
251      * @dev Similar to EIP20 transfer, except it handles a False success from `transfer` and returns an explanatory
252      *      error code rather than reverting. If caller has not called checked protocol's balance, this may revert due to
253      *      insufficient cash held in this contract. If caller has checked protocol's balance prior to this call, and verified
254      *      it is >= amount, this should not revert in normal conditions.
255      *
256      *      Note: This wrapper safely handles non-standard ERC-20 tokens that do not return a value.
257      *            See here: https://medium.com/coinmonks/missing-return-value-bug-at-least-130-tokens-affected-d67bf08521ca
258      */
259     function doTransferOut(
260         address payable to,
261         uint256 amount,
262         bool isNative
263     ) internal {
264         isNative; // unused
265 
266         EIP20NonStandardInterface token = EIP20NonStandardInterface(underlying);
267         token.transfer(to, amount);
268 
269         bool success;
270         assembly {
271             switch returndatasize()
272             case 0 {
273                 // This is a non-standard ERC-20
274                 success := not(0) // set success to true
275             }
276             case 32 {
277                 // This is a complaint ERC-20
278                 returndatacopy(0, 0, 32)
279                 success := mload(0) // Set `success = returndata` of external call
280             }
281             default {
282                 // This is an excessively non-compliant ERC-20, revert.
283                 revert(0, 0)
284             }
285         }
286         require(success, "TOKEN_TRANSFER_OUT_FAILED");
287         internalCash = sub_(internalCash, amount);
288     }
289 
290     /**
291      * @notice Transfer `tokens` tokens from `src` to `dst` by `spender`
292      * @dev Called by both `transfer` and `transferFrom` internally
293      * @param spender The address of the account performing the transfer
294      * @param src The address of the source account
295      * @param dst The address of the destination account
296      * @param tokens The number of tokens to transfer
297      * @return Whether or not the transfer succeeded
298      */
299     function transferTokens(
300         address spender,
301         address src,
302         address dst,
303         uint256 tokens
304     ) internal returns (uint256) {
305         /* Fail if transfer not allowed */
306         uint256 allowed = comptroller.transferAllowed(address(this), src, dst, tokens);
307         if (allowed != 0) {
308             return failOpaque(Error.COMPTROLLER_REJECTION, FailureInfo.TRANSFER_COMPTROLLER_REJECTION, allowed);
309         }
310 
311         /* Do not allow self-transfers */
312         if (src == dst) {
313             return fail(Error.BAD_INPUT, FailureInfo.TRANSFER_NOT_ALLOWED);
314         }
315 
316         /* Get the allowance, infinite for the account owner */
317         uint256 startingAllowance = 0;
318         if (spender == src) {
319             startingAllowance = uint256(-1);
320         } else {
321             startingAllowance = transferAllowances[src][spender];
322         }
323 
324         /* Do the calculations, checking for {under,over}flow */
325         accountTokens[src] = sub_(accountTokens[src], tokens);
326         accountTokens[dst] = add_(accountTokens[dst], tokens);
327 
328         /* Eat some of the allowance (if necessary) */
329         if (startingAllowance != uint256(-1)) {
330             transferAllowances[src][spender] = sub_(startingAllowance, tokens);
331         }
332 
333         /* We emit a Transfer event */
334         emit Transfer(src, dst, tokens);
335 
336         comptroller.transferVerify(address(this), src, dst, tokens);
337 
338         return uint256(Error.NO_ERROR);
339     }
340 
341     /**
342      * @notice Get the account's cToken balances
343      * @param account The address of the account
344      */
345     function getCTokenBalanceInternal(address account) internal view returns (uint256) {
346         return accountTokens[account];
347     }
348 
349     struct MintLocalVars {
350         uint256 exchangeRateMantissa;
351         uint256 mintTokens;
352         uint256 actualMintAmount;
353     }
354 
355     /**
356      * @notice User supplies assets into the market and receives cTokens in exchange
357      * @dev Assumes interest has already been accrued up to the current block
358      * @param minter The address of the account which is supplying the assets
359      * @param mintAmount The amount of the underlying asset to supply
360      * @param isNative The amount is in native or not
361      * @return (uint, uint) An error code (0=success, otherwise a failure, see ErrorReporter.sol), and the actual mint amount.
362      */
363     function mintFresh(
364         address minter,
365         uint256 mintAmount,
366         bool isNative
367     ) internal returns (uint256, uint256) {
368         /* Fail if mint not allowed */
369         uint256 allowed = comptroller.mintAllowed(address(this), minter, mintAmount);
370         if (allowed != 0) {
371             return (failOpaque(Error.COMPTROLLER_REJECTION, FailureInfo.MINT_COMPTROLLER_REJECTION, allowed), 0);
372         }
373 
374         /*
375          * Return if mintAmount is zero.
376          * Put behind `mintAllowed` for accuring potential COMP rewards.
377          */
378         if (mintAmount == 0) {
379             return (uint256(Error.NO_ERROR), 0);
380         }
381 
382         /* Verify market's block number equals current block number */
383         if (accrualBlockNumber != getBlockNumber()) {
384             return (fail(Error.MARKET_NOT_FRESH, FailureInfo.MINT_FRESHNESS_CHECK), 0);
385         }
386 
387         MintLocalVars memory vars;
388 
389         vars.exchangeRateMantissa = exchangeRateStoredInternal();
390 
391         /////////////////////////
392         // EFFECTS & INTERACTIONS
393         // (No safe failures beyond this point)
394 
395         /*
396          *  We call `doTransferIn` for the minter and the mintAmount.
397          *  Note: The cToken must handle variations between ERC-20 and ETH underlying.
398          *  `doTransferIn` reverts if anything goes wrong, since we can't be sure if
399          *  side-effects occurred. The function returns the amount actually transferred,
400          *  in case of a fee. On success, the cToken holds an additional `actualMintAmount`
401          *  of cash.
402          */
403         vars.actualMintAmount = doTransferIn(minter, mintAmount, isNative);
404 
405         /*
406          * We get the current exchange rate and calculate the number of cTokens to be minted:
407          *  mintTokens = actualMintAmount / exchangeRate
408          */
409         vars.mintTokens = div_ScalarByExpTruncate(vars.actualMintAmount, Exp({mantissa: vars.exchangeRateMantissa}));
410 
411         /*
412          * We calculate the new total supply of cTokens and minter token balance, checking for overflow:
413          *  totalSupply = totalSupply + mintTokens
414          *  accountTokens[minter] = accountTokens[minter] + mintTokens
415          */
416         totalSupply = add_(totalSupply, vars.mintTokens);
417         accountTokens[minter] = add_(accountTokens[minter], vars.mintTokens);
418 
419         /* We emit a Mint event, and a Transfer event */
420         emit Mint(minter, vars.actualMintAmount, vars.mintTokens);
421         emit Transfer(address(this), minter, vars.mintTokens);
422 
423         /* We call the defense hook */
424         comptroller.mintVerify(address(this), minter, vars.actualMintAmount, vars.mintTokens);
425 
426         return (uint256(Error.NO_ERROR), vars.actualMintAmount);
427     }
428 
429     struct RedeemLocalVars {
430         uint256 exchangeRateMantissa;
431         uint256 redeemTokens;
432         uint256 redeemAmount;
433         uint256 totalSupplyNew;
434         uint256 accountTokensNew;
435     }
436 
437     /**
438      * @notice User redeems cTokens in exchange for the underlying asset
439      * @dev Assumes interest has already been accrued up to the current block. Only one of redeemTokensIn or redeemAmountIn may be non-zero and it would do nothing if both are zero.
440      * @param redeemer The address of the account which is redeeming the tokens
441      * @param redeemTokensIn The number of cTokens to redeem into underlying
442      * @param redeemAmountIn The number of underlying tokens to receive from redeeming cTokens
443      * @param isNative The amount is in native or not
444      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
445      */
446     function redeemFresh(
447         address payable redeemer,
448         uint256 redeemTokensIn,
449         uint256 redeemAmountIn,
450         bool isNative
451     ) internal returns (uint256) {
452         require(redeemTokensIn == 0 || redeemAmountIn == 0, "one of redeemTokensIn or redeemAmountIn must be zero");
453 
454         RedeemLocalVars memory vars;
455 
456         /* exchangeRate = invoke Exchange Rate Stored() */
457         vars.exchangeRateMantissa = exchangeRateStoredInternal();
458 
459         /* If redeemTokensIn > 0: */
460         if (redeemTokensIn > 0) {
461             /*
462              * We calculate the exchange rate and the amount of underlying to be redeemed:
463              *  redeemTokens = redeemTokensIn
464              *  redeemAmount = redeemTokensIn x exchangeRateCurrent
465              */
466             vars.redeemTokens = redeemTokensIn;
467             vars.redeemAmount = mul_ScalarTruncate(Exp({mantissa: vars.exchangeRateMantissa}), redeemTokensIn);
468         } else {
469             /*
470              * We get the current exchange rate and calculate the amount to be redeemed:
471              *  redeemTokens = redeemAmountIn / exchangeRate
472              *  redeemAmount = redeemAmountIn
473              */
474             vars.redeemTokens = div_ScalarByExpTruncate(redeemAmountIn, Exp({mantissa: vars.exchangeRateMantissa}));
475             vars.redeemAmount = redeemAmountIn;
476         }
477 
478         /* Fail if redeem not allowed */
479         uint256 allowed = comptroller.redeemAllowed(address(this), redeemer, vars.redeemTokens);
480         if (allowed != 0) {
481             return failOpaque(Error.COMPTROLLER_REJECTION, FailureInfo.REDEEM_COMPTROLLER_REJECTION, allowed);
482         }
483 
484         /*
485          * Return if redeemTokensIn and redeemAmountIn are zero.
486          * Put behind `redeemAllowed` for accuring potential COMP rewards.
487          */
488         if (redeemTokensIn == 0 && redeemAmountIn == 0) {
489             return uint256(Error.NO_ERROR);
490         }
491 
492         /* Verify market's block number equals current block number */
493         if (accrualBlockNumber != getBlockNumber()) {
494             return fail(Error.MARKET_NOT_FRESH, FailureInfo.REDEEM_FRESHNESS_CHECK);
495         }
496 
497         /*
498          * We calculate the new total supply and redeemer balance, checking for underflow:
499          *  totalSupplyNew = totalSupply - redeemTokens
500          *  accountTokensNew = accountTokens[redeemer] - redeemTokens
501          */
502         vars.totalSupplyNew = sub_(totalSupply, vars.redeemTokens);
503         vars.accountTokensNew = sub_(accountTokens[redeemer], vars.redeemTokens);
504 
505         /* Fail gracefully if protocol has insufficient cash */
506         if (getCashPrior() < vars.redeemAmount) {
507             return fail(Error.TOKEN_INSUFFICIENT_CASH, FailureInfo.REDEEM_TRANSFER_OUT_NOT_POSSIBLE);
508         }
509 
510         /////////////////////////
511         // EFFECTS & INTERACTIONS
512         // (No safe failures beyond this point)
513 
514         /*
515          * We invoke doTransferOut for the redeemer and the redeemAmount.
516          *  Note: The cToken must handle variations between ERC-20 and ETH underlying.
517          *  On success, the cToken has redeemAmount less of cash.
518          *  doTransferOut reverts if anything goes wrong, since we can't be sure if side effects occurred.
519          */
520         doTransferOut(redeemer, vars.redeemAmount, isNative);
521 
522         /* We write previously calculated values into storage */
523         totalSupply = vars.totalSupplyNew;
524         accountTokens[redeemer] = vars.accountTokensNew;
525 
526         /* We emit a Transfer event, and a Redeem event */
527         emit Transfer(redeemer, address(this), vars.redeemTokens);
528         emit Redeem(redeemer, vars.redeemAmount, vars.redeemTokens);
529 
530         /* We call the defense hook */
531         comptroller.redeemVerify(address(this), redeemer, vars.redeemAmount, vars.redeemTokens);
532 
533         return uint256(Error.NO_ERROR);
534     }
535 
536     /**
537      * @notice Transfers collateral tokens (this market) to the liquidator.
538      * @dev Called only during an in-kind liquidation, or by liquidateBorrow during the liquidation of another CToken.
539      *  Its absolutely critical to use msg.sender as the seizer cToken and not a parameter.
540      * @param seizerToken The contract seizing the collateral (i.e. borrowed cToken)
541      * @param liquidator The account receiving seized collateral
542      * @param borrower The account having collateral seized
543      * @param seizeTokens The number of cTokens to seize
544      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
545      */
546     function seizeInternal(
547         address seizerToken,
548         address liquidator,
549         address borrower,
550         uint256 seizeTokens
551     ) internal returns (uint256) {
552         /* Fail if seize not allowed */
553         uint256 allowed = comptroller.seizeAllowed(address(this), seizerToken, liquidator, borrower, seizeTokens);
554         if (allowed != 0) {
555             return failOpaque(Error.COMPTROLLER_REJECTION, FailureInfo.LIQUIDATE_SEIZE_COMPTROLLER_REJECTION, allowed);
556         }
557 
558         /*
559          * Return if seizeTokens is zero.
560          * Put behind `seizeAllowed` for accuring potential COMP rewards.
561          */
562         if (seizeTokens == 0) {
563             return uint256(Error.NO_ERROR);
564         }
565 
566         /* Fail if borrower = liquidator */
567         if (borrower == liquidator) {
568             return fail(Error.INVALID_ACCOUNT_PAIR, FailureInfo.LIQUIDATE_SEIZE_LIQUIDATOR_IS_BORROWER);
569         }
570 
571         /*
572          * We calculate the new borrower and liquidator token balances, failing on underflow/overflow:
573          *  borrowerTokensNew = accountTokens[borrower] - seizeTokens
574          *  liquidatorTokensNew = accountTokens[liquidator] + seizeTokens
575          */
576         accountTokens[borrower] = sub_(accountTokens[borrower], seizeTokens);
577         accountTokens[liquidator] = add_(accountTokens[liquidator], seizeTokens);
578 
579         /* Emit a Transfer event */
580         emit Transfer(borrower, liquidator, seizeTokens);
581 
582         /* We call the defense hook */
583         comptroller.seizeVerify(address(this), seizerToken, liquidator, borrower, seizeTokens);
584 
585         return uint256(Error.NO_ERROR);
586     }
587 }
