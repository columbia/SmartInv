1 pragma solidity ^0.5.16;
2 
3 import "./CToken.sol";
4 import "./ERC3156FlashBorrowerInterface.sol";
5 import "./ERC3156FlashLenderInterface.sol";
6 
7 /**
8  * @title Wrapped native token interface
9  */
10 interface WrappedNativeInterface {
11     function deposit() external payable;
12 
13     function withdraw(uint256 wad) external;
14 }
15 
16 /**
17  * @title Cream's CWrappedNative Contract
18  * @notice CTokens which wrap the native token
19  * @author Cream
20  */
21 contract CWrappedNative is CToken, CWrappedNativeInterface {
22     /**
23      * @notice Initialize the new money market
24      * @param underlying_ The address of the underlying asset
25      * @param comptroller_ The address of the Comptroller
26      * @param interestRateModel_ The address of the interest rate model
27      * @param initialExchangeRateMantissa_ The initial exchange rate, scaled by 1e18
28      * @param name_ ERC-20 name of this token
29      * @param symbol_ ERC-20 symbol of this token
30      * @param decimals_ ERC-20 decimal precision of this token
31      */
32     function initialize(
33         address underlying_,
34         ComptrollerInterface comptroller_,
35         InterestRateModel interestRateModel_,
36         uint256 initialExchangeRateMantissa_,
37         string memory name_,
38         string memory symbol_,
39         uint8 decimals_
40     ) public {
41         // CToken initialize does the bulk of the work
42         super.initialize(comptroller_, interestRateModel_, initialExchangeRateMantissa_, name_, symbol_, decimals_);
43 
44         // Set underlying and sanity check it
45         underlying = underlying_;
46         EIP20Interface(underlying).totalSupply();
47         WrappedNativeInterface(underlying);
48     }
49 
50     /*** User Interface ***/
51 
52     /**
53      * @notice Sender supplies assets into the market and receives cTokens in exchange
54      * @dev Accrues interest whether or not the operation succeeds, unless reverted
55      *  Keep return in the function signature for backward compatibility
56      * @param mintAmount The amount of the underlying asset to supply
57      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
58      */
59     function mint(uint256 mintAmount) external returns (uint256) {
60         (uint256 err, ) = mintInternal(mintAmount, false);
61         require(err == 0, "mint failed");
62     }
63 
64     /**
65      * @notice Sender supplies assets into the market and receives cTokens in exchange
66      * @dev Accrues interest whether or not the operation succeeds, unless reverted
67      *  Keep return in the function signature for consistency
68      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
69      */
70     function mintNative() external payable returns (uint256) {
71         (uint256 err, ) = mintInternal(msg.value, true);
72         require(err == 0, "mint native failed");
73     }
74 
75     /**
76      * @notice Sender redeems cTokens in exchange for the underlying asset
77      * @dev Accrues interest whether or not the operation succeeds, unless reverted
78      *  Keep return in the function signature for backward compatibility
79      * @param redeemTokens The number of cTokens to redeem into underlying
80      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
81      */
82     function redeem(uint256 redeemTokens) external returns (uint256) {
83         require(redeemInternal(redeemTokens, false) == 0, "redeem failed");
84     }
85 
86     /**
87      * @notice Sender redeems cTokens in exchange for the underlying asset
88      * @dev Accrues interest whether or not the operation succeeds, unless reverted
89      *  Keep return in the function signature for consistency
90      * @param redeemTokens The number of cTokens to redeem into underlying
91      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
92      */
93     function redeemNative(uint256 redeemTokens) external returns (uint256) {
94         require(redeemInternal(redeemTokens, true) == 0, "redeem native failed");
95     }
96 
97     /**
98      * @notice Sender redeems cTokens in exchange for a specified amount of underlying asset
99      * @dev Accrues interest whether or not the operation succeeds, unless reverted
100      *  Keep return in the function signature for backward compatibility
101      * @param redeemAmount The amount of underlying to redeem
102      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
103      */
104     function redeemUnderlying(uint256 redeemAmount) external returns (uint256) {
105         require(redeemUnderlyingInternal(redeemAmount, false) == 0, "redeem underlying failed");
106     }
107 
108     /**
109      * @notice Sender redeems cTokens in exchange for a specified amount of underlying asset
110      * @dev Accrues interest whether or not the operation succeeds, unless reverted
111      *  Keep return in the function signature for consistency
112      * @param redeemAmount The amount of underlying to redeem
113      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
114      */
115     function redeemUnderlyingNative(uint256 redeemAmount) external returns (uint256) {
116         require(redeemUnderlyingInternal(redeemAmount, true) == 0, "redeem underlying native failed");
117     }
118 
119     /**
120      * @notice Sender borrows assets from the protocol to their own address
121      * @dev Accrues interest whether or not the operation succeeds, unless reverted
122      *  Keep return in the function signature for backward compatibility
123      * @param borrowAmount The amount of the underlying asset to borrow
124      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
125      */
126     function borrow(uint256 borrowAmount) external returns (uint256) {
127         require(borrowInternal(borrowAmount, false) == 0, "borrow failed");
128     }
129 
130     /**
131      * @notice Sender borrows assets from the protocol to their own address
132      * @dev Accrues interest whether or not the operation succeeds, unless reverted
133      *  Keep return in the function signature for consistency
134      * @param borrowAmount The amount of the underlying asset to borrow
135      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
136      */
137     function borrowNative(uint256 borrowAmount) external returns (uint256) {
138         require(borrowInternal(borrowAmount, true) == 0, "borrow native failed");
139     }
140 
141     /**
142      * @notice Sender repays their own borrow
143      * @dev Accrues interest whether or not the operation succeeds, unless reverted
144      *  Keep return in the function signature for backward compatibility
145      * @param repayAmount The amount to repay
146      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
147      */
148     function repayBorrow(uint256 repayAmount) external returns (uint256) {
149         (uint256 err, ) = repayBorrowInternal(repayAmount, false);
150         require(err == 0, "repay failed");
151     }
152 
153     /**
154      * @notice Sender repays their own borrow
155      * @dev Accrues interest whether or not the operation succeeds, unless reverted
156      *  Keep return in the function signature for consistency
157      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
158      */
159     function repayBorrowNative() external payable returns (uint256) {
160         (uint256 err, ) = repayBorrowInternal(msg.value, true);
161         require(err == 0, "repay native failed");
162     }
163 
164     /**
165      * @notice Sender repays a borrow belonging to borrower
166      * @dev Accrues interest whether or not the operation succeeds, unless reverted
167      *  Keep return in the function signature for backward compatibility
168      * @param borrower the account with the debt being payed off
169      * @param repayAmount The amount to repay
170      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
171      */
172     function repayBorrowBehalf(address borrower, uint256 repayAmount) external returns (uint256) {
173         (uint256 err, ) = repayBorrowBehalfInternal(borrower, repayAmount, false);
174         require(err == 0, "repay behalf failed");
175     }
176 
177     /**
178      * @notice Sender repays a borrow belonging to borrower
179      * @dev Accrues interest whether or not the operation succeeds, unless reverted
180      *  Keep return in the function signature for consistency
181      * @param borrower the account with the debt being payed off
182      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
183      */
184     function repayBorrowBehalfNative(address borrower) external payable returns (uint256) {
185         (uint256 err, ) = repayBorrowBehalfInternal(borrower, msg.value, true);
186         require(err == 0, "repay behalf native failed");
187     }
188 
189     /**
190      * @notice The sender liquidates the borrowers collateral.
191      *  The collateral seized is transferred to the liquidator.
192      * @dev Accrues interest whether or not the operation succeeds, unless reverted
193      *  Keep return in the function signature for backward compatibility
194      * @param borrower The borrower of this cToken to be liquidated
195      * @param repayAmount The amount of the underlying borrowed asset to repay
196      * @param cTokenCollateral The market in which to seize collateral from the borrower
197      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
198      */
199     function liquidateBorrow(
200         address borrower,
201         uint256 repayAmount,
202         CTokenInterface cTokenCollateral
203     ) external returns (uint256) {
204         (uint256 err, ) = liquidateBorrowInternal(borrower, repayAmount, cTokenCollateral, false);
205         require(err == 0, "liquidate borrow failed");
206     }
207 
208     /**
209      * @notice The sender liquidates the borrowers collateral.
210      *  The collateral seized is transferred to the liquidator.
211      * @dev Accrues interest whether or not the operation succeeds, unless reverted
212      *  Keep return in the function signature for consistency
213      * @param borrower The borrower of this cToken to be liquidated
214      * @param cTokenCollateral The market in which to seize collateral from the borrower
215      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
216      */
217     function liquidateBorrowNative(address borrower, CTokenInterface cTokenCollateral)
218         external
219         payable
220         returns (uint256)
221     {
222         (uint256 err, ) = liquidateBorrowInternal(borrower, msg.value, cTokenCollateral, true);
223         require(err == 0, "liquidate borrow native failed");
224     }
225 
226     /**
227      * @notice Get the max flash loan amount
228      */
229     function maxFlashLoan() external view returns (uint256) {
230         uint256 amount = 0;
231         if (
232             ComptrollerInterfaceExtension(address(comptroller)).flashloanAllowed(address(this), address(0), amount, "")
233         ) {
234             amount = getCashPrior();
235         }
236         return amount;
237     }
238 
239     /**
240      * @notice Get the flash loan fees
241      * @param amount amount of token to borrow
242      */
243     function flashFee(uint256 amount) external view returns (uint256) {
244         require(
245             ComptrollerInterfaceExtension(address(comptroller)).flashloanAllowed(address(this), address(0), amount, ""),
246             "flashloan is paused"
247         );
248         return div_(mul_(amount, flashFeeBips), 10000);
249     }
250 
251     /**
252      * @notice Flash loan funds to a given account.
253      * @param receiver The receiver address for the funds
254      * @param initiator flash loan initiator
255      * @param amount The amount of the funds to be loaned
256      * @param data The other data
257      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
258      */
259     function flashLoan(
260         ERC3156FlashBorrowerInterface receiver,
261         address initiator,
262         uint256 amount,
263         bytes calldata data
264     ) external nonReentrant returns (bool) {
265         require(amount > 0, "invalid flashloan amount");
266         accrueInterest();
267         require(
268             ComptrollerInterfaceExtension(address(comptroller)).flashloanAllowed(
269                 address(this),
270                 address(receiver),
271                 amount,
272                 data
273             ),
274             "flashloan is paused"
275         );
276         uint256 cashBefore = getCashPrior();
277         require(cashBefore >= amount, "INSUFFICIENT_LIQUIDITY");
278 
279         // 1. calculate fee, 1 bips = 1/10000
280         uint256 totalFee = this.flashFee(amount);
281 
282         // 2. transfer fund to receiver
283         doTransferOut(address(uint160(address(receiver))), amount, false);
284 
285         // 3. update totalBorrows
286         totalBorrows = add_(totalBorrows, amount);
287 
288         // 4. execute receiver's callback function
289         require(
290             receiver.onFlashLoan(initiator, underlying, amount, totalFee, data) ==
291                 keccak256("ERC3156FlashBorrowerInterface.onFlashLoan"),
292             "IERC3156: Callback failed"
293         );
294 
295         // 5. take amount + fee from receiver, then check balance
296         uint256 repaymentAmount = add_(amount, totalFee);
297 
298         doTransferIn(address(receiver), repaymentAmount, false);
299 
300         uint256 cashAfter = getCashPrior();
301         require(cashAfter == add_(cashBefore, totalFee), "BALANCE_INCONSISTENT");
302 
303         // 6. update totalReserves and totalBorrows
304         uint256 reservesFee = mul_ScalarTruncate(Exp({mantissa: reserveFactorMantissa}), totalFee);
305         totalReserves = add_(totalReserves, reservesFee);
306         totalBorrows = sub_(totalBorrows, amount);
307 
308         emit Flashloan(address(receiver), amount, totalFee, reservesFee);
309         return true;
310     }
311 
312     /**
313      * @dev CWrappedNative doesn't have the collateral cap functionality. Return the supply cap for
314      * interface consistency.
315      * @return the supply cap of this market
316      */
317     function collateralCap() external view returns (uint256) {
318         return ComptrollerInterfaceExtension(address(comptroller)).supplyCaps(address(this));
319     }
320 
321     /**
322      * @dev CWrappedNative doesn't have the collateral cap functionality. Return the total supply for
323      * interface consistency.
324      * @return the total supply of this market
325      */
326     function totalCollateralTokens() external view returns (uint256) {
327         return totalSupply;
328     }
329 
330     function() external payable {
331         require(msg.sender == underlying, "only wrapped native contract could send native token");
332     }
333 
334     /**
335      * @notice The sender adds to reserves.
336      * @dev Accrues interest whether or not the operation succeeds, unless reverted
337      *  Keep return in the function signature for backward compatibility
338      * @param addAmount The amount fo underlying token to add as reserves
339      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
340      */
341     function _addReserves(uint256 addAmount) external returns (uint256) {
342         require(_addReservesInternal(addAmount, false) == 0, "add reserves failed");
343     }
344 
345     /**
346      * @notice The sender adds to reserves.
347      * @dev Accrues interest whether or not the operation succeeds, unless reverted
348      *  Keep return in the function signature for consistency
349      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
350      */
351     function _addReservesNative() external payable returns (uint256) {
352         require(_addReservesInternal(msg.value, true) == 0, "add reserves failed");
353     }
354 
355     /*** Safe Token ***/
356 
357     /**
358      * @notice Gets balance of this contract in terms of the underlying
359      * @dev This excludes the value of the current message, if any
360      * @return The quantity of underlying tokens owned by this contract
361      */
362     function getCashPrior() internal view returns (uint256) {
363         EIP20Interface token = EIP20Interface(underlying);
364         return token.balanceOf(address(this));
365     }
366 
367     /**
368      * @dev Similar to EIP20 transfer, except it handles a False result from `transferFrom` and reverts in that case.
369      *      This will revert due to insufficient balance or insufficient allowance.
370      *      This function returns the actual amount received,
371      *      which may be less than `amount` if there is a fee attached to the transfer.
372      *
373      *      Note: This wrapper safely handles non-standard ERC-20 tokens that do not return a value.
374      *            See here: https://medium.com/coinmonks/missing-return-value-bug-at-least-130-tokens-affected-d67bf08521ca
375      */
376     function doTransferIn(
377         address from,
378         uint256 amount,
379         bool isNative
380     ) internal returns (uint256) {
381         if (isNative) {
382             // Sanity checks
383             require(msg.sender == from, "sender mismatch");
384             require(msg.value == amount, "value mismatch");
385 
386             // Convert received native token to wrapped token
387             WrappedNativeInterface(underlying).deposit.value(amount)();
388             return amount;
389         } else {
390             EIP20NonStandardInterface token = EIP20NonStandardInterface(underlying);
391             uint256 balanceBefore = EIP20Interface(underlying).balanceOf(address(this));
392             token.transferFrom(from, address(this), amount);
393 
394             bool success;
395             assembly {
396                 switch returndatasize()
397                 case 0 {
398                     // This is a non-standard ERC-20
399                     success := not(0) // set success to true
400                 }
401                 case 32 {
402                     // This is a compliant ERC-20
403                     returndatacopy(0, 0, 32)
404                     success := mload(0) // Set `success = returndata` of external call
405                 }
406                 default {
407                     // This is an excessively non-compliant ERC-20, revert.
408                     revert(0, 0)
409                 }
410             }
411             require(success, "TOKEN_TRANSFER_IN_FAILED");
412 
413             // Calculate the amount that was *actually* transferred
414             uint256 balanceAfter = EIP20Interface(underlying).balanceOf(address(this));
415             return sub_(balanceAfter, balanceBefore);
416         }
417     }
418 
419     /**
420      * @dev Similar to EIP20 transfer, except it handles a False success from `transfer` and returns an explanatory
421      *      error code rather than reverting. If caller has not called checked protocol's balance, this may revert due to
422      *      insufficient cash held in this contract. If caller has checked protocol's balance prior to this call, and verified
423      *      it is >= amount, this should not revert in normal conditions.
424      *
425      *      Note: This wrapper safely handles non-standard ERC-20 tokens that do not return a value.
426      *            See here: https://medium.com/coinmonks/missing-return-value-bug-at-least-130-tokens-affected-d67bf08521ca
427      */
428     function doTransferOut(
429         address payable to,
430         uint256 amount,
431         bool isNative
432     ) internal {
433         if (isNative) {
434             // Convert wrapped token to native token
435             WrappedNativeInterface(underlying).withdraw(amount);
436             /* Send the Ether, with minimal gas and revert on failure */
437             to.transfer(amount);
438         } else {
439             EIP20NonStandardInterface token = EIP20NonStandardInterface(underlying);
440             token.transfer(to, amount);
441 
442             bool success;
443             assembly {
444                 switch returndatasize()
445                 case 0 {
446                     // This is a non-standard ERC-20
447                     success := not(0) // set success to true
448                 }
449                 case 32 {
450                     // This is a complaint ERC-20
451                     returndatacopy(0, 0, 32)
452                     success := mload(0) // Set `success = returndata` of external call
453                 }
454                 default {
455                     // This is an excessively non-compliant ERC-20, revert.
456                     revert(0, 0)
457                 }
458             }
459             require(success, "TOKEN_TRANSFER_OUT_FAILED");
460         }
461     }
462 
463     /**
464      * @notice Transfer `tokens` tokens from `src` to `dst` by `spender`
465      * @dev Called by both `transfer` and `transferFrom` internally
466      * @param spender The address of the account performing the transfer
467      * @param src The address of the source account
468      * @param dst The address of the destination account
469      * @param tokens The number of tokens to transfer
470      * @return Whether or not the transfer succeeded
471      */
472     function transferTokens(
473         address spender,
474         address src,
475         address dst,
476         uint256 tokens
477     ) internal returns (uint256) {
478         /* Fail if transfer not allowed */
479         require(comptroller.transferAllowed(address(this), src, dst, tokens) == 0, "comptroller rejection");
480 
481         /* Do not allow self-transfers */
482         require(src != dst, "bad input");
483 
484         /* Get the allowance, infinite for the account owner */
485         uint256 startingAllowance = 0;
486         if (spender == src) {
487             startingAllowance = uint256(-1);
488         } else {
489             startingAllowance = transferAllowances[src][spender];
490         }
491 
492         /* Do the calculations, checking for {under,over}flow */
493         accountTokens[src] = sub_(accountTokens[src], tokens);
494         accountTokens[dst] = add_(accountTokens[dst], tokens);
495 
496         /* Eat some of the allowance (if necessary) */
497         if (startingAllowance != uint256(-1)) {
498             transferAllowances[src][spender] = sub_(startingAllowance, tokens);
499         }
500 
501         /* We emit a Transfer event */
502         emit Transfer(src, dst, tokens);
503 
504         comptroller.transferVerify(address(this), src, dst, tokens);
505 
506         return uint256(Error.NO_ERROR);
507     }
508 
509     /**
510      * @notice Get the account's cToken balances
511      * @param account The address of the account
512      */
513     function getCTokenBalanceInternal(address account) internal view returns (uint256) {
514         return accountTokens[account];
515     }
516 
517     struct MintLocalVars {
518         uint256 exchangeRateMantissa;
519         uint256 mintTokens;
520         uint256 actualMintAmount;
521     }
522 
523     /**
524      * @notice User supplies assets into the market and receives cTokens in exchange
525      * @dev Assumes interest has already been accrued up to the current block
526      * @param minter The address of the account which is supplying the assets
527      * @param mintAmount The amount of the underlying asset to supply
528      * @param isNative The amount is in native or not
529      * @return (uint, uint) An error code (0=success, otherwise a failure, see ErrorReporter.sol), and the actual mint amount.
530      */
531     function mintFresh(
532         address minter,
533         uint256 mintAmount,
534         bool isNative
535     ) internal returns (uint256, uint256) {
536         /* Fail if mint not allowed */
537         require(comptroller.mintAllowed(address(this), minter, mintAmount) == 0, "comptroller rejection");
538 
539         /*
540          * Return if mintAmount is zero.
541          * Put behind `mintAllowed` for accuring potential COMP rewards.
542          */
543         if (mintAmount == 0) {
544             return (uint256(Error.NO_ERROR), 0);
545         }
546 
547         /* Verify market's block number equals current block number */
548         require(accrualBlockNumber == getBlockNumber(), "market not fresh");
549 
550         MintLocalVars memory vars;
551 
552         vars.exchangeRateMantissa = exchangeRateStoredInternal();
553 
554         /////////////////////////
555         // EFFECTS & INTERACTIONS
556         // (No safe failures beyond this point)
557 
558         /*
559          *  We call `doTransferIn` for the minter and the mintAmount.
560          *  Note: The cToken must handle variations between ERC-20 and ETH underlying.
561          *  `doTransferIn` reverts if anything goes wrong, since we can't be sure if
562          *  side-effects occurred. The function returns the amount actually transferred,
563          *  in case of a fee. On success, the cToken holds an additional `actualMintAmount`
564          *  of cash.
565          */
566         vars.actualMintAmount = doTransferIn(minter, mintAmount, isNative);
567 
568         /*
569          * We get the current exchange rate and calculate the number of cTokens to be minted:
570          *  mintTokens = actualMintAmount / exchangeRate
571          */
572         vars.mintTokens = div_ScalarByExpTruncate(vars.actualMintAmount, Exp({mantissa: vars.exchangeRateMantissa}));
573 
574         /*
575          * We calculate the new total supply of cTokens and minter token balance, checking for overflow:
576          *  totalSupply = totalSupply + mintTokens
577          *  accountTokens[minter] = accountTokens[minter] + mintTokens
578          */
579         totalSupply = add_(totalSupply, vars.mintTokens);
580         accountTokens[minter] = add_(accountTokens[minter], vars.mintTokens);
581 
582         /* We emit a Mint event, and a Transfer event */
583         emit Mint(minter, vars.actualMintAmount, vars.mintTokens);
584         emit Transfer(address(this), minter, vars.mintTokens);
585 
586         /* We call the defense hook */
587         comptroller.mintVerify(address(this), minter, vars.actualMintAmount, vars.mintTokens);
588 
589         return (uint256(Error.NO_ERROR), vars.actualMintAmount);
590     }
591 
592     struct RedeemLocalVars {
593         uint256 exchangeRateMantissa;
594         uint256 redeemTokens;
595         uint256 redeemAmount;
596         uint256 totalSupplyNew;
597         uint256 accountTokensNew;
598     }
599 
600     /**
601      * @notice User redeems cTokens in exchange for the underlying asset
602      * @dev Assumes interest has already been accrued up to the current block. Only one of redeemTokensIn or redeemAmountIn may be non-zero and it would do nothing if both are zero.
603      * @param redeemer The address of the account which is redeeming the tokens
604      * @param redeemTokensIn The number of cTokens to redeem into underlying
605      * @param redeemAmountIn The number of underlying tokens to receive from redeeming cTokens
606      * @param isNative The amount is in native or not
607      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
608      */
609     function redeemFresh(
610         address payable redeemer,
611         uint256 redeemTokensIn,
612         uint256 redeemAmountIn,
613         bool isNative
614     ) internal returns (uint256) {
615         require(redeemTokensIn == 0 || redeemAmountIn == 0, "bad input");
616 
617         RedeemLocalVars memory vars;
618 
619         /* exchangeRate = invoke Exchange Rate Stored() */
620         vars.exchangeRateMantissa = exchangeRateStoredInternal();
621 
622         /* If redeemTokensIn > 0: */
623         if (redeemTokensIn > 0) {
624             /*
625              * We calculate the exchange rate and the amount of underlying to be redeemed:
626              *  redeemTokens = redeemTokensIn
627              *  redeemAmount = redeemTokensIn x exchangeRateCurrent
628              */
629             vars.redeemTokens = redeemTokensIn;
630             vars.redeemAmount = mul_ScalarTruncate(Exp({mantissa: vars.exchangeRateMantissa}), redeemTokensIn);
631         } else {
632             /*
633              * We get the current exchange rate and calculate the amount to be redeemed:
634              *  redeemTokens = redeemAmountIn / exchangeRate
635              *  redeemAmount = redeemAmountIn
636              */
637             vars.redeemTokens = div_ScalarByExpTruncate(redeemAmountIn, Exp({mantissa: vars.exchangeRateMantissa}));
638             vars.redeemAmount = redeemAmountIn;
639         }
640 
641         /* Fail if redeem not allowed */
642         require(comptroller.redeemAllowed(address(this), redeemer, vars.redeemTokens) == 0, "comptroller rejection");
643 
644         /*
645          * Return if redeemTokensIn and redeemAmountIn are zero.
646          * Put behind `redeemAllowed` for accuring potential COMP rewards.
647          */
648         if (redeemTokensIn == 0 && redeemAmountIn == 0) {
649             return uint256(Error.NO_ERROR);
650         }
651 
652         /* Verify market's block number equals current block number */
653         require(accrualBlockNumber == getBlockNumber(), "market not fresh");
654 
655         /*
656          * We calculate the new total supply and redeemer balance, checking for underflow:
657          *  totalSupplyNew = totalSupply - redeemTokens
658          *  accountTokensNew = accountTokens[redeemer] - redeemTokens
659          */
660         vars.totalSupplyNew = sub_(totalSupply, vars.redeemTokens);
661         vars.accountTokensNew = sub_(accountTokens[redeemer], vars.redeemTokens);
662 
663         /* Reverts if protocol has insufficient cash */
664         require(getCashPrior() >= vars.redeemAmount, "insufficient cash");
665 
666         /////////////////////////
667         // EFFECTS & INTERACTIONS
668         // (No safe failures beyond this point)
669 
670         /* We write previously calculated values into storage */
671         totalSupply = vars.totalSupplyNew;
672         accountTokens[redeemer] = vars.accountTokensNew;
673 
674         /*
675          * We invoke doTransferOut for the redeemer and the redeemAmount.
676          *  Note: The cToken must handle variations between ERC-20 and ETH underlying.
677          *  On success, the cToken has redeemAmount less of cash.
678          *  doTransferOut reverts if anything goes wrong, since we can't be sure if side effects occurred.
679          */
680         doTransferOut(redeemer, vars.redeemAmount, isNative);
681 
682         /* We emit a Transfer event, and a Redeem event */
683         emit Transfer(redeemer, address(this), vars.redeemTokens);
684         emit Redeem(redeemer, vars.redeemAmount, vars.redeemTokens);
685 
686         /* We call the defense hook */
687         comptroller.redeemVerify(address(this), redeemer, vars.redeemAmount, vars.redeemTokens);
688 
689         return uint256(Error.NO_ERROR);
690     }
691 
692     /**
693      * @notice Transfers collateral tokens (this market) to the liquidator.
694      * @dev Called only during an in-kind liquidation, or by liquidateBorrow during the liquidation of another CToken.
695      *  Its absolutely critical to use msg.sender as the seizer cToken and not a parameter.
696      * @param seizerToken The contract seizing the collateral (i.e. borrowed cToken)
697      * @param liquidator The account receiving seized collateral
698      * @param borrower The account having collateral seized
699      * @param seizeTokens The number of cTokens to seize
700      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
701      */
702     function seizeInternal(
703         address seizerToken,
704         address liquidator,
705         address borrower,
706         uint256 seizeTokens
707     ) internal returns (uint256) {
708         /* Fail if seize not allowed */
709         require(
710             comptroller.seizeAllowed(address(this), seizerToken, liquidator, borrower, seizeTokens) == 0,
711             "comptroller rejection"
712         );
713 
714         /*
715          * Return if seizeTokens is zero.
716          * Put behind `seizeAllowed` for accuring potential COMP rewards.
717          */
718         if (seizeTokens == 0) {
719             return uint256(Error.NO_ERROR);
720         }
721 
722         /* Fail if borrower = liquidator */
723         require(borrower != liquidator, "invalid account pair");
724 
725         /*
726          * We calculate the new borrower and liquidator token balances, failing on underflow/overflow:
727          *  borrowerTokensNew = accountTokens[borrower] - seizeTokens
728          *  liquidatorTokensNew = accountTokens[liquidator] + seizeTokens
729          */
730         accountTokens[borrower] = sub_(accountTokens[borrower], seizeTokens);
731         accountTokens[liquidator] = add_(accountTokens[liquidator], seizeTokens);
732 
733         /* Emit a Transfer event */
734         emit Transfer(borrower, liquidator, seizeTokens);
735 
736         /* We call the defense hook */
737         comptroller.seizeVerify(address(this), seizerToken, liquidator, borrower, seizeTokens);
738 
739         return uint256(Error.NO_ERROR);
740     }
741 }
