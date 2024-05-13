1 pragma solidity ^0.5.16;
2 
3 import "./CToken.sol";
4 
5 /**
6  * @title Compound's CErc20 Contract
7  * @notice CTokens which wrap an EIP-20 underlying
8  * @author Compound
9  */
10 contract CErc20 is CToken, CErc20Interface {
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
48         require(err == 0, "mint failed");
49     }
50 
51     /**
52      * @notice Sender redeems cTokens in exchange for the underlying asset
53      * @dev Accrues interest whether or not the operation succeeds, unless reverted
54      * @param redeemTokens The number of cTokens to redeem into underlying
55      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
56      */
57     function redeem(uint256 redeemTokens) external returns (uint256) {
58         require(redeemInternal(redeemTokens, false) == 0, "redeem failed");
59     }
60 
61     /**
62      * @notice Sender redeems cTokens in exchange for a specified amount of underlying asset
63      * @dev Accrues interest whether or not the operation succeeds, unless reverted
64      * @param redeemAmount The amount of underlying to redeem
65      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
66      */
67     function redeemUnderlying(uint256 redeemAmount) external returns (uint256) {
68         require(redeemUnderlyingInternal(redeemAmount, false) == 0, "redeem underlying failed");
69     }
70 
71     /**
72      * @notice Sender borrows assets from the protocol to their own address
73      * @param borrowAmount The amount of the underlying asset to borrow
74      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
75      */
76     function borrow(uint256 borrowAmount) external returns (uint256) {
77         require(borrowInternal(borrowAmount, false) == 0, "borrow failed");
78     }
79 
80     /**
81      * @notice Sender repays their own borrow
82      * @param repayAmount The amount to repay
83      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
84      */
85     function repayBorrow(uint256 repayAmount) external returns (uint256) {
86         (uint256 err, ) = repayBorrowInternal(repayAmount, false);
87         require(err == 0, "repay failed");
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
98         require(err == 0, "repay behalf failed");
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
115         require(err == 0, "liquidate borrow failed");
116     }
117 
118     /**
119      * @notice The sender adds to reserves.
120      * @param addAmount The amount fo underlying token to add as reserves
121      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
122      */
123     function _addReserves(uint256 addAmount) external returns (uint256) {
124         require(_addReservesInternal(addAmount, false) == 0, "add reserves failed");
125     }
126 
127     /*** Safe Token ***/
128 
129     /**
130      * @notice Gets balance of this contract in terms of the underlying
131      * @dev This excludes the value of the current message, if any
132      * @return The quantity of underlying tokens owned by this contract
133      */
134     function getCashPrior() internal view returns (uint256) {
135         EIP20Interface token = EIP20Interface(underlying);
136         return token.balanceOf(address(this));
137     }
138 
139     /**
140      * @dev Similar to EIP20 transfer, except it handles a False result from `transferFrom` and reverts in that case.
141      *      This will revert due to insufficient balance or insufficient allowance.
142      *      This function returns the actual amount received,
143      *      which may be less than `amount` if there is a fee attached to the transfer.
144      *
145      *      Note: This wrapper safely handles non-standard ERC-20 tokens that do not return a value.
146      *            See here: https://medium.com/coinmonks/missing-return-value-bug-at-least-130-tokens-affected-d67bf08521ca
147      */
148     function doTransferIn(
149         address from,
150         uint256 amount,
151         bool isNative
152     ) internal returns (uint256) {
153         isNative; // unused
154 
155         EIP20NonStandardInterface token = EIP20NonStandardInterface(underlying);
156         uint256 balanceBefore = EIP20Interface(underlying).balanceOf(address(this));
157         token.transferFrom(from, address(this), amount);
158 
159         bool success;
160         assembly {
161             switch returndatasize()
162             case 0 {
163                 // This is a non-standard ERC-20
164                 success := not(0) // set success to true
165             }
166             case 32 {
167                 // This is a compliant ERC-20
168                 returndatacopy(0, 0, 32)
169                 success := mload(0) // Set `success = returndata` of external call
170             }
171             default {
172                 // This is an excessively non-compliant ERC-20, revert.
173                 revert(0, 0)
174             }
175         }
176         require(success, "TOKEN_TRANSFER_IN_FAILED");
177 
178         // Calculate the amount that was *actually* transferred
179         uint256 balanceAfter = EIP20Interface(underlying).balanceOf(address(this));
180         return sub_(balanceAfter, balanceBefore);
181     }
182 
183     /**
184      * @dev Similar to EIP20 transfer, except it handles a False success from `transfer` and returns an explanatory
185      *      error code rather than reverting. If caller has not called checked protocol's balance, this may revert due to
186      *      insufficient cash held in this contract. If caller has checked protocol's balance prior to this call, and verified
187      *      it is >= amount, this should not revert in normal conditions.
188      *
189      *      Note: This wrapper safely handles non-standard ERC-20 tokens that do not return a value.
190      *            See here: https://medium.com/coinmonks/missing-return-value-bug-at-least-130-tokens-affected-d67bf08521ca
191      */
192     function doTransferOut(
193         address payable to,
194         uint256 amount,
195         bool isNative
196     ) internal {
197         isNative; // unused
198 
199         EIP20NonStandardInterface token = EIP20NonStandardInterface(underlying);
200         token.transfer(to, amount);
201 
202         bool success;
203         assembly {
204             switch returndatasize()
205             case 0 {
206                 // This is a non-standard ERC-20
207                 success := not(0) // set success to true
208             }
209             case 32 {
210                 // This is a complaint ERC-20
211                 returndatacopy(0, 0, 32)
212                 success := mload(0) // Set `success = returndata` of external call
213             }
214             default {
215                 // This is an excessively non-compliant ERC-20, revert.
216                 revert(0, 0)
217             }
218         }
219         require(success, "TOKEN_TRANSFER_OUT_FAILED");
220     }
221 
222     /**
223      * @notice Transfer `tokens` tokens from `src` to `dst` by `spender`
224      * @dev Called by both `transfer` and `transferFrom` internally
225      * @param spender The address of the account performing the transfer
226      * @param src The address of the source account
227      * @param dst The address of the destination account
228      * @param tokens The number of tokens to transfer
229      * @return Whether or not the transfer succeeded
230      */
231     function transferTokens(
232         address spender,
233         address src,
234         address dst,
235         uint256 tokens
236     ) internal returns (uint256) {
237         /* Fail if transfer not allowed */
238         require(comptroller.transferAllowed(address(this), src, dst, tokens) == 0, "comptroller rejection");
239 
240         /* Do not allow self-transfers */
241         require(src != dst, "bad input");
242 
243         /* Get the allowance, infinite for the account owner */
244         uint256 startingAllowance = 0;
245         if (spender == src) {
246             startingAllowance = uint256(-1);
247         } else {
248             startingAllowance = transferAllowances[src][spender];
249         }
250 
251         /* Do the calculations, checking for {under,over}flow */
252         accountTokens[src] = sub_(accountTokens[src], tokens);
253         accountTokens[dst] = add_(accountTokens[dst], tokens);
254 
255         /* Eat some of the allowance (if necessary) */
256         if (startingAllowance != uint256(-1)) {
257             transferAllowances[src][spender] = sub_(startingAllowance, tokens);
258         }
259 
260         /* We emit a Transfer event */
261         emit Transfer(src, dst, tokens);
262 
263         comptroller.transferVerify(address(this), src, dst, tokens);
264 
265         return uint256(Error.NO_ERROR);
266     }
267 
268     /**
269      * @notice Get the account's cToken balances
270      * @param account The address of the account
271      */
272     function getCTokenBalanceInternal(address account) internal view returns (uint256) {
273         return accountTokens[account];
274     }
275 
276     struct MintLocalVars {
277         uint256 exchangeRateMantissa;
278         uint256 mintTokens;
279         uint256 actualMintAmount;
280     }
281 
282     /**
283      * @notice User supplies assets into the market and receives cTokens in exchange
284      * @dev Assumes interest has already been accrued up to the current block
285      * @param minter The address of the account which is supplying the assets
286      * @param mintAmount The amount of the underlying asset to supply
287      * @param isNative The amount is in native or not
288      * @return (uint, uint) An error code (0=success, otherwise a failure, see ErrorReporter.sol), and the actual mint amount.
289      */
290     function mintFresh(
291         address minter,
292         uint256 mintAmount,
293         bool isNative
294     ) internal returns (uint256, uint256) {
295         /* Fail if mint not allowed */
296         require(comptroller.mintAllowed(address(this), minter, mintAmount) == 0, "comptroller rejection");
297 
298         /*
299          * Return if mintAmount is zero.
300          * Put behind `mintAllowed` for accuring potential COMP rewards.
301          */
302         if (mintAmount == 0) {
303             return (uint256(Error.NO_ERROR), 0);
304         }
305 
306         /* Verify market's block number equals current block number */
307         require(accrualBlockNumber == getBlockNumber(), "market not fresh");
308 
309         MintLocalVars memory vars;
310 
311         vars.exchangeRateMantissa = exchangeRateStoredInternal();
312 
313         /////////////////////////
314         // EFFECTS & INTERACTIONS
315         // (No safe failures beyond this point)
316 
317         /*
318          *  We call `doTransferIn` for the minter and the mintAmount.
319          *  Note: The cToken must handle variations between ERC-20 and ETH underlying.
320          *  `doTransferIn` reverts if anything goes wrong, since we can't be sure if
321          *  side-effects occurred. The function returns the amount actually transferred,
322          *  in case of a fee. On success, the cToken holds an additional `actualMintAmount`
323          *  of cash.
324          */
325         vars.actualMintAmount = doTransferIn(minter, mintAmount, isNative);
326 
327         /*
328          * We get the current exchange rate and calculate the number of cTokens to be minted:
329          *  mintTokens = actualMintAmount / exchangeRate
330          */
331         vars.mintTokens = div_ScalarByExpTruncate(vars.actualMintAmount, Exp({mantissa: vars.exchangeRateMantissa}));
332 
333         /*
334          * We calculate the new total supply of cTokens and minter token balance, checking for overflow:
335          *  totalSupply = totalSupply + mintTokens
336          *  accountTokens[minter] = accountTokens[minter] + mintTokens
337          */
338         totalSupply = add_(totalSupply, vars.mintTokens);
339         accountTokens[minter] = add_(accountTokens[minter], vars.mintTokens);
340 
341         /* We emit a Mint event, and a Transfer event */
342         emit Mint(minter, vars.actualMintAmount, vars.mintTokens);
343         emit Transfer(address(this), minter, vars.mintTokens);
344 
345         /* We call the defense hook */
346         comptroller.mintVerify(address(this), minter, vars.actualMintAmount, vars.mintTokens);
347 
348         return (uint256(Error.NO_ERROR), vars.actualMintAmount);
349     }
350 
351     struct RedeemLocalVars {
352         uint256 exchangeRateMantissa;
353         uint256 redeemTokens;
354         uint256 redeemAmount;
355         uint256 totalSupplyNew;
356         uint256 accountTokensNew;
357     }
358 
359     /**
360      * @notice User redeems cTokens in exchange for the underlying asset
361      * @dev Assumes interest has already been accrued up to the current block. Only one of redeemTokensIn or redeemAmountIn may be non-zero and it would do nothing if both are zero.
362      * @param redeemer The address of the account which is redeeming the tokens
363      * @param redeemTokensIn The number of cTokens to redeem into underlying
364      * @param redeemAmountIn The number of underlying tokens to receive from redeeming cTokens
365      * @param isNative The amount is in native or not
366      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
367      */
368     function redeemFresh(
369         address payable redeemer,
370         uint256 redeemTokensIn,
371         uint256 redeemAmountIn,
372         bool isNative
373     ) internal returns (uint256) {
374         require(redeemTokensIn == 0 || redeemAmountIn == 0, "bad input");
375 
376         RedeemLocalVars memory vars;
377 
378         /* exchangeRate = invoke Exchange Rate Stored() */
379         vars.exchangeRateMantissa = exchangeRateStoredInternal();
380 
381         /* If redeemTokensIn > 0: */
382         if (redeemTokensIn > 0) {
383             /*
384              * We calculate the exchange rate and the amount of underlying to be redeemed:
385              *  redeemTokens = redeemTokensIn
386              *  redeemAmount = redeemTokensIn x exchangeRateCurrent
387              */
388             vars.redeemTokens = redeemTokensIn;
389             vars.redeemAmount = mul_ScalarTruncate(Exp({mantissa: vars.exchangeRateMantissa}), redeemTokensIn);
390         } else {
391             /*
392              * We get the current exchange rate and calculate the amount to be redeemed:
393              *  redeemTokens = redeemAmountIn / exchangeRate
394              *  redeemAmount = redeemAmountIn
395              */
396             vars.redeemTokens = div_ScalarByExpTruncate(redeemAmountIn, Exp({mantissa: vars.exchangeRateMantissa}));
397             vars.redeemAmount = redeemAmountIn;
398         }
399 
400         /* Fail if redeem not allowed */
401         require(comptroller.redeemAllowed(address(this), redeemer, vars.redeemTokens) == 0, "comptroller rejection");
402 
403         /*
404          * Return if redeemTokensIn and redeemAmountIn are zero.
405          * Put behind `redeemAllowed` for accuring potential COMP rewards.
406          */
407         if (redeemTokensIn == 0 && redeemAmountIn == 0) {
408             return uint256(Error.NO_ERROR);
409         }
410 
411         /* Verify market's block number equals current block number */
412         require(accrualBlockNumber == getBlockNumber(), "market not fresh");
413 
414         /*
415          * We calculate the new total supply and redeemer balance, checking for underflow:
416          *  totalSupplyNew = totalSupply - redeemTokens
417          *  accountTokensNew = accountTokens[redeemer] - redeemTokens
418          */
419         vars.totalSupplyNew = sub_(totalSupply, vars.redeemTokens);
420         vars.accountTokensNew = sub_(accountTokens[redeemer], vars.redeemTokens);
421 
422         /* Reverts if protocol has insufficient cash */
423         require(getCashPrior() >= vars.redeemAmount, "insufficient cash");
424 
425         /////////////////////////
426         // EFFECTS & INTERACTIONS
427         // (No safe failures beyond this point)
428 
429         /* We write previously calculated values into storage */
430         totalSupply = vars.totalSupplyNew;
431         accountTokens[redeemer] = vars.accountTokensNew;
432 
433         /*
434          * We invoke doTransferOut for the redeemer and the redeemAmount.
435          *  Note: The cToken must handle variations between ERC-20 and ETH underlying.
436          *  On success, the cToken has redeemAmount less of cash.
437          *  doTransferOut reverts if anything goes wrong, since we can't be sure if side effects occurred.
438          */
439         doTransferOut(redeemer, vars.redeemAmount, isNative);
440 
441         /* We emit a Transfer event, and a Redeem event */
442         emit Transfer(redeemer, address(this), vars.redeemTokens);
443         emit Redeem(redeemer, vars.redeemAmount, vars.redeemTokens);
444 
445         /* We call the defense hook */
446         comptroller.redeemVerify(address(this), redeemer, vars.redeemAmount, vars.redeemTokens);
447 
448         return uint256(Error.NO_ERROR);
449     }
450 
451     /**
452      * @notice Transfers collateral tokens (this market) to the liquidator.
453      * @dev Called only during an in-kind liquidation, or by liquidateBorrow during the liquidation of another CToken.
454      *  Its absolutely critical to use msg.sender as the seizer cToken and not a parameter.
455      * @param seizerToken The contract seizing the collateral (i.e. borrowed cToken)
456      * @param liquidator The account receiving seized collateral
457      * @param borrower The account having collateral seized
458      * @param seizeTokens The number of cTokens to seize
459      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
460      */
461     function seizeInternal(
462         address seizerToken,
463         address liquidator,
464         address borrower,
465         uint256 seizeTokens
466     ) internal returns (uint256) {
467         /* Fail if seize not allowed */
468         require(
469             comptroller.seizeAllowed(address(this), seizerToken, liquidator, borrower, seizeTokens) == 0,
470             "comptroller rejection"
471         );
472 
473         /*
474          * Return if seizeTokens is zero.
475          * Put behind `seizeAllowed` for accuring potential COMP rewards.
476          */
477         if (seizeTokens == 0) {
478             return uint256(Error.NO_ERROR);
479         }
480 
481         /* Fail if borrower = liquidator */
482         require(borrower != liquidator, "invalid account pair");
483 
484         /*
485          * We calculate the new borrower and liquidator token balances, failing on underflow/overflow:
486          *  borrowerTokensNew = accountTokens[borrower] - seizeTokens
487          *  liquidatorTokensNew = accountTokens[liquidator] + seizeTokens
488          */
489         accountTokens[borrower] = sub_(accountTokens[borrower], seizeTokens);
490         accountTokens[liquidator] = add_(accountTokens[liquidator], seizeTokens);
491 
492         /* Emit a Transfer event */
493         emit Transfer(borrower, liquidator, seizeTokens);
494 
495         /* We call the defense hook */
496         comptroller.seizeVerify(address(this), seizerToken, liquidator, borrower, seizeTokens);
497 
498         return uint256(Error.NO_ERROR);
499     }
500 }
