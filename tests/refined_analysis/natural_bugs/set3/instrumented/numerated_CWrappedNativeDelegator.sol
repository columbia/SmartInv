1 pragma solidity ^0.5.16;
2 
3 import "./CTokenInterfaces.sol";
4 
5 /**
6  * @title Compound's CWrappedNativeDelegator Contract
7  * @notice CTokens which wrap an EIP-20 underlying and delegate to an implementation
8  * @author Compound
9  */
10 contract CWrappedNativeDelegator is CTokenInterface, CWrappedNativeInterface, CDelegatorInterface {
11     /**
12      * @notice Construct a new money market
13      * @param underlying_ The address of the underlying asset
14      * @param comptroller_ The address of the Comptroller
15      * @param interestRateModel_ The address of the interest rate model
16      * @param initialExchangeRateMantissa_ The initial exchange rate, scaled by 1e18
17      * @param name_ ERC-20 name of this token
18      * @param symbol_ ERC-20 symbol of this token
19      * @param decimals_ ERC-20 decimal precision of this token
20      * @param admin_ Address of the administrator of this token
21      * @param implementation_ The address of the implementation the contract delegates to
22      * @param becomeImplementationData The encoded args for becomeImplementation
23      */
24     constructor(
25         address underlying_,
26         ComptrollerInterface comptroller_,
27         InterestRateModel interestRateModel_,
28         uint256 initialExchangeRateMantissa_,
29         string memory name_,
30         string memory symbol_,
31         uint8 decimals_,
32         address payable admin_,
33         address implementation_,
34         bytes memory becomeImplementationData
35     ) public {
36         // Creator of the contract is admin during initialization
37         admin = msg.sender;
38 
39         // First delegate gets to initialize the delegator (i.e. storage contract)
40         delegateTo(
41             implementation_,
42             abi.encodeWithSignature(
43                 "initialize(address,address,address,uint256,string,string,uint8)",
44                 underlying_,
45                 comptroller_,
46                 interestRateModel_,
47                 initialExchangeRateMantissa_,
48                 name_,
49                 symbol_,
50                 decimals_
51             )
52         );
53 
54         // New implementations always get set via the settor (post-initialize)
55         _setImplementation(implementation_, false, becomeImplementationData);
56 
57         // Set the proper admin now that initialization is done
58         admin = admin_;
59     }
60 
61     /**
62      * @notice Called by the admin to update the implementation of the delegator
63      * @param implementation_ The address of the new implementation for delegation
64      * @param allowResign Flag to indicate whether to call _resignImplementation on the old implementation
65      * @param becomeImplementationData The encoded bytes data to be passed to _becomeImplementation
66      */
67     function _setImplementation(
68         address implementation_,
69         bool allowResign,
70         bytes memory becomeImplementationData
71     ) public {
72         require(msg.sender == admin, "CWrappedNativeDelegator::_setImplementation: Caller must be admin");
73 
74         if (allowResign) {
75             delegateToImplementation(abi.encodeWithSignature("_resignImplementation()"));
76         }
77 
78         address oldImplementation = implementation;
79         implementation = implementation_;
80 
81         delegateToImplementation(abi.encodeWithSignature("_becomeImplementation(bytes)", becomeImplementationData));
82 
83         emit NewImplementation(oldImplementation, implementation);
84     }
85 
86     /**
87      * @notice Sender supplies assets into the market and receives cTokens in exchange
88      * @dev Accrues interest whether or not the operation succeeds, unless reverted
89      * @param mintAmount The amount of the underlying asset to supply
90      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
91      */
92     function mint(uint256 mintAmount) external returns (uint256) {
93         mintAmount; // Shh
94         delegateAndReturn();
95     }
96 
97     /**
98      * @notice Sender supplies assets into the market and receives cTokens in exchange
99      * @dev Accrues interest whether or not the operation succeeds, unless reverted
100      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
101      */
102     function mintNative() external payable returns (uint256) {
103         delegateAndReturn();
104     }
105 
106     /**
107      * @notice Sender redeems cTokens in exchange for the underlying asset
108      * @dev Accrues interest whether or not the operation succeeds, unless reverted
109      * @param redeemTokens The number of cTokens to redeem into underlying
110      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
111      */
112     function redeem(uint256 redeemTokens) external returns (uint256) {
113         redeemTokens; // Shh
114         delegateAndReturn();
115     }
116 
117     /**
118      * @notice Sender redeems cTokens in exchange for the underlying asset
119      * @dev Accrues interest whether or not the operation succeeds, unless reverted
120      * @param redeemTokens The number of cTokens to redeem into underlying
121      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
122      */
123     function redeemNative(uint256 redeemTokens) external returns (uint256) {
124         redeemTokens; // Shh
125         delegateAndReturn();
126     }
127 
128     /**
129      * @notice Sender redeems cTokens in exchange for a specified amount of underlying asset
130      * @dev Accrues interest whether or not the operation succeeds, unless reverted
131      * @param redeemAmount The amount of underlying to redeem
132      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
133      */
134     function redeemUnderlying(uint256 redeemAmount) external returns (uint256) {
135         redeemAmount; // Shh
136         delegateAndReturn();
137     }
138 
139     /**
140      * @notice Sender redeems cTokens in exchange for a specified amount of underlying asset
141      * @dev Accrues interest whether or not the operation succeeds, unless reverted
142      * @param redeemAmount The amount of underlying to redeem
143      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
144      */
145     function redeemUnderlyingNative(uint256 redeemAmount) external returns (uint256) {
146         redeemAmount; // Shh
147         delegateAndReturn();
148     }
149 
150     /**
151      * @notice Sender borrows assets from the protocol to their own address
152      * @param borrowAmount The amount of the underlying asset to borrow
153      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
154      */
155     function borrow(uint256 borrowAmount) external returns (uint256) {
156         borrowAmount; // Shh
157         delegateAndReturn();
158     }
159 
160     /**
161      * @notice Sender borrows assets from the protocol to their own address
162      * @param borrowAmount The amount of the underlying asset to borrow
163      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
164      */
165     function borrowNative(uint256 borrowAmount) external returns (uint256) {
166         borrowAmount; // Shh
167         delegateAndReturn();
168     }
169 
170     /**
171      * @notice Sender repays their own borrow
172      * @param repayAmount The amount to repay
173      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
174      */
175     function repayBorrow(uint256 repayAmount) external returns (uint256) {
176         repayAmount; // Shh
177         delegateAndReturn();
178     }
179 
180     /**
181      * @notice Sender repays their own borrow
182      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
183      */
184     function repayBorrowNative() external payable returns (uint256) {
185         delegateAndReturn();
186     }
187 
188     /**
189      * @notice Sender repays a borrow belonging to borrower
190      * @param borrower the account with the debt being payed off
191      * @param repayAmount The amount to repay
192      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
193      */
194     function repayBorrowBehalf(address borrower, uint256 repayAmount) external returns (uint256) {
195         borrower;
196         repayAmount; // Shh
197         delegateAndReturn();
198     }
199 
200     /**
201      * @notice Sender repays a borrow belonging to borrower
202      * @param borrower the account with the debt being payed off
203      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
204      */
205     function repayBorrowBehalfNative(address borrower) external payable returns (uint256) {
206         borrower; // Shh
207         delegateAndReturn();
208     }
209 
210     /**
211      * @notice The sender liquidates the borrowers collateral.
212      *  The collateral seized is transferred to the liquidator.
213      * @param borrower The borrower of this cToken to be liquidated
214      * @param cTokenCollateral The market in which to seize collateral from the borrower
215      * @param repayAmount The amount of the underlying borrowed asset to repay
216      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
217      */
218     function liquidateBorrow(
219         address borrower,
220         uint256 repayAmount,
221         CTokenInterface cTokenCollateral
222     ) external returns (uint256) {
223         borrower;
224         repayAmount;
225         cTokenCollateral; // Shh
226         delegateAndReturn();
227     }
228 
229     /**
230      * @notice The sender liquidates the borrowers collateral.
231      *  The collateral seized is transferred to the liquidator.
232      * @param borrower The borrower of this cToken to be liquidated
233      * @param cTokenCollateral The market in which to seize collateral from the borrower
234      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
235      */
236     function liquidateBorrowNative(address borrower, CTokenInterface cTokenCollateral)
237         external
238         payable
239         returns (uint256)
240     {
241         borrower;
242         cTokenCollateral; // Shh
243         delegateAndReturn();
244     }
245 
246     /**
247      * @notice Flash loan funds to a given account.
248      * @param receiver The receiver address for the funds
249      * @param amount The amount of the funds to be loaned
250      * @param data The other data
251      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
252      */
253 
254     function flashLoan(
255         ERC3156FlashBorrowerInterface receiver,
256         address initiator,
257         uint256 amount,
258         bytes calldata data
259     ) external returns (bool) {
260         receiver;
261         amount;
262         data; // Shh
263         delegateAndReturn();
264     }
265 
266     /**
267      * @dev CWrappedNative doesn't have the collateral cap functionality. Return the supply cap for
268      * interface consistency.
269      * @return the supply cap of this market
270      */
271     function collateralCap() external view returns (uint256) {
272         delegateToViewAndReturn();
273     }
274 
275     /**
276      * @dev CWrappedNative doesn't have the collateral cap functionality. Return the total supply for
277      * interface consistency.
278      * @return the total supply of this market
279      */
280     function totalCollateralTokens() external view returns (uint256) {
281         delegateToViewAndReturn();
282     }
283 
284     /**
285      * @notice Transfer `amount` tokens from `msg.sender` to `dst`
286      * @param dst The address of the destination account
287      * @param amount The number of tokens to transfer
288      * @return Whether or not the transfer succeeded
289      */
290     function transfer(address dst, uint256 amount) external returns (bool) {
291         dst;
292         amount; // Shh
293         delegateAndReturn();
294     }
295 
296     /**
297      * @notice Transfer `amount` tokens from `src` to `dst`
298      * @param src The address of the source account
299      * @param dst The address of the destination account
300      * @param amount The number of tokens to transfer
301      * @return Whether or not the transfer succeeded
302      */
303     function transferFrom(
304         address src,
305         address dst,
306         uint256 amount
307     ) external returns (bool) {
308         src;
309         dst;
310         amount; // Shh
311         delegateAndReturn();
312     }
313 
314     /**
315      * @notice Approve `spender` to transfer up to `amount` from `src`
316      * @dev This will overwrite the approval amount for `spender`
317      *  and is subject to issues noted [here](https://eips.ethereum.org/EIPS/eip-20#approve)
318      * @param spender The address of the account which may transfer tokens
319      * @param amount The number of tokens that are approved (-1 means infinite)
320      * @return Whether or not the approval succeeded
321      */
322     function approve(address spender, uint256 amount) external returns (bool) {
323         spender;
324         amount; // Shh
325         delegateAndReturn();
326     }
327 
328     /**
329      * @notice Get the current allowance from `owner` for `spender`
330      * @param owner The address of the account which owns the tokens to be spent
331      * @param spender The address of the account which may transfer tokens
332      * @return The number of tokens allowed to be spent (-1 means infinite)
333      */
334     function allowance(address owner, address spender) external view returns (uint256) {
335         owner;
336         spender; // Shh
337         delegateToViewAndReturn();
338     }
339 
340     /**
341      * @notice Get the token balance of the `owner`
342      * @param owner The address of the account to query
343      * @return The number of tokens owned by `owner`
344      */
345     function balanceOf(address owner) external view returns (uint256) {
346         owner; // Shh
347         delegateToViewAndReturn();
348     }
349 
350     /**
351      * @notice Get the underlying balance of the `owner`
352      * @dev This also accrues interest in a transaction
353      * @param owner The address of the account to query
354      * @return The amount of underlying owned by `owner`
355      */
356     function balanceOfUnderlying(address owner) external returns (uint256) {
357         owner; // Shh
358         delegateAndReturn();
359     }
360 
361     /**
362      * @notice Get a snapshot of the account's balances, and the cached exchange rate
363      * @dev This is used by comptroller to more efficiently perform liquidity checks.
364      * @param account Address of the account to snapshot
365      * @return (possible error, token balance, borrow balance, exchange rate mantissa)
366      */
367     function getAccountSnapshot(address account)
368         external
369         view
370         returns (
371             uint256,
372             uint256,
373             uint256,
374             uint256
375         )
376     {
377         account; // Shh
378         delegateToViewAndReturn();
379     }
380 
381     /**
382      * @notice Returns the current per-block borrow interest rate for this cToken
383      * @return The borrow interest rate per block, scaled by 1e18
384      */
385     function borrowRatePerBlock() external view returns (uint256) {
386         delegateToViewAndReturn();
387     }
388 
389     /**
390      * @notice Returns the current per-block supply interest rate for this cToken
391      * @return The supply interest rate per block, scaled by 1e18
392      */
393     function supplyRatePerBlock() external view returns (uint256) {
394         delegateToViewAndReturn();
395     }
396 
397     /**
398      * @notice Returns the current total borrows plus accrued interest
399      * @return The total borrows with interest
400      */
401     function totalBorrowsCurrent() external returns (uint256) {
402         delegateAndReturn();
403     }
404 
405     /**
406      * @notice Accrue interest to updated borrowIndex and then calculate account's borrow balance using the updated borrowIndex
407      * @param account The address whose balance should be calculated after updating borrowIndex
408      * @return The calculated balance
409      */
410     function borrowBalanceCurrent(address account) external returns (uint256) {
411         account; // Shh
412         delegateAndReturn();
413     }
414 
415     /**
416      * @notice Return the borrow balance of account based on stored data
417      * @param account The address whose balance should be calculated
418      * @return The calculated balance
419      */
420     function borrowBalanceStored(address account) public view returns (uint256) {
421         account; // Shh
422         delegateToViewAndReturn();
423     }
424 
425     /**
426      * @notice Accrue interest then return the up-to-date exchange rate
427      * @return Calculated exchange rate scaled by 1e18
428      */
429     function exchangeRateCurrent() public returns (uint256) {
430         delegateAndReturn();
431     }
432 
433     /**
434      * @notice Calculates the exchange rate from the underlying to the CToken
435      * @dev This function does not accrue interest before calculating the exchange rate
436      * @return Calculated exchange rate scaled by 1e18
437      */
438     function exchangeRateStored() public view returns (uint256) {
439         delegateToViewAndReturn();
440     }
441 
442     /**
443      * @notice Get cash balance of this cToken in the underlying asset
444      * @return The quantity of underlying asset owned by this contract
445      */
446     function getCash() external view returns (uint256) {
447         delegateToViewAndReturn();
448     }
449 
450     /**
451      * @notice Applies accrued interest to total borrows and reserves.
452      * @dev This calculates interest accrued from the last checkpointed block
453      *      up to the current block and writes new checkpoint to storage.
454      */
455     function accrueInterest() public returns (uint256) {
456         delegateAndReturn();
457     }
458 
459     /**
460      * @notice Transfers collateral tokens (this market) to the liquidator.
461      * @dev Will fail unless called by another cToken during the process of liquidation.
462      *  Its absolutely critical to use msg.sender as the borrowed cToken and not a parameter.
463      * @param liquidator The account receiving seized collateral
464      * @param borrower The account having collateral seized
465      * @param seizeTokens The number of cTokens to seize
466      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
467      */
468     function seize(
469         address liquidator,
470         address borrower,
471         uint256 seizeTokens
472     ) external returns (uint256) {
473         liquidator;
474         borrower;
475         seizeTokens; // Shh
476         delegateAndReturn();
477     }
478 
479     /*** Admin Functions ***/
480 
481     /**
482      * @notice Begins transfer of admin rights. The newPendingAdmin must call `_acceptAdmin` to finalize the transfer.
483      * @dev Admin function to begin change of admin. The newPendingAdmin must call `_acceptAdmin` to finalize the transfer.
484      * @param newPendingAdmin New pending admin.
485      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
486      */
487     function _setPendingAdmin(address payable newPendingAdmin) external returns (uint256) {
488         newPendingAdmin; // Shh
489         delegateAndReturn();
490     }
491 
492     /**
493      * @notice Sets a new comptroller for the market
494      * @dev Admin function to set a new comptroller
495      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
496      */
497     function _setComptroller(ComptrollerInterface newComptroller) public returns (uint256) {
498         newComptroller; // Shh
499         delegateAndReturn();
500     }
501 
502     /**
503      * @notice accrues interest and sets a new reserve factor for the protocol using _setReserveFactorFresh
504      * @dev Admin function to accrue interest and set a new reserve factor
505      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
506      */
507     function _setReserveFactor(uint256 newReserveFactorMantissa) external returns (uint256) {
508         newReserveFactorMantissa; // Shh
509         delegateAndReturn();
510     }
511 
512     /**
513      * @notice Accepts transfer of admin rights. msg.sender must be pendingAdmin
514      * @dev Admin function for pending admin to accept role and update admin
515      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
516      */
517     function _acceptAdmin() external returns (uint256) {
518         delegateAndReturn();
519     }
520 
521     /**
522      * @notice Accrues interest and adds reserves by transferring from admin
523      * @param addAmount Amount of reserves to add
524      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
525      */
526     function _addReserves(uint256 addAmount) external returns (uint256) {
527         addAmount; // Shh
528         delegateAndReturn();
529     }
530 
531     /**
532      * @notice Accrues interest and adds reserves by transferring from admin
533      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
534      */
535     function _addReservesNative() external payable returns (uint256) {
536         delegateAndReturn();
537     }
538 
539     /**
540      * @notice Accrues interest and reduces reserves by transferring to admin
541      * @param reduceAmount Amount of reduction to reserves
542      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
543      */
544     function _reduceReserves(uint256 reduceAmount) external returns (uint256) {
545         reduceAmount; // Shh
546         delegateAndReturn();
547     }
548 
549     /**
550      * @notice Accrues interest and updates the interest rate model using _setInterestRateModelFresh
551      * @dev Admin function to accrue interest and update the interest rate model
552      * @param newInterestRateModel the new interest rate model to use
553      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
554      */
555     function _setInterestRateModel(InterestRateModel newInterestRateModel) public returns (uint256) {
556         newInterestRateModel; // Shh
557         delegateAndReturn();
558     }
559 
560     /**
561      * @notice Internal method to delegate execution to another contract
562      * @dev It returns to the external caller whatever the implementation returns or forwards reverts
563      * @param callee The contract to delegatecall
564      * @param data The raw data to delegatecall
565      * @return The returned bytes from the delegatecall
566      */
567     function delegateTo(address callee, bytes memory data) internal returns (bytes memory) {
568         (bool success, bytes memory returnData) = callee.delegatecall(data);
569         assembly {
570             if eq(success, 0) {
571                 revert(add(returnData, 0x20), returndatasize)
572             }
573         }
574         return returnData;
575     }
576 
577     /**
578      * @notice Delegates execution to the implementation contract
579      * @dev It returns to the external caller whatever the implementation returns or forwards reverts
580      * @param data The raw data to delegatecall
581      * @return The returned bytes from the delegatecall
582      */
583     function delegateToImplementation(bytes memory data) public returns (bytes memory) {
584         return delegateTo(implementation, data);
585     }
586 
587     /**
588      * @notice Delegates execution to an implementation contract
589      * @dev It returns to the external caller whatever the implementation returns or forwards reverts
590      *  There are an additional 2 prefix uints from the wrapper returndata, which we ignore since we make an extra hop.
591      * @param data The raw data to delegatecall
592      * @return The returned bytes from the delegatecall
593      */
594     function delegateToViewImplementation(bytes memory data) public view returns (bytes memory) {
595         (bool success, bytes memory returnData) = address(this).staticcall(
596             abi.encodeWithSignature("delegateToImplementation(bytes)", data)
597         );
598         assembly {
599             if eq(success, 0) {
600                 revert(add(returnData, 0x20), returndatasize)
601             }
602         }
603         return abi.decode(returnData, (bytes));
604     }
605 
606     function delegateToViewAndReturn() private view returns (bytes memory) {
607         (bool success, ) = address(this).staticcall(
608             abi.encodeWithSignature("delegateToImplementation(bytes)", msg.data)
609         );
610 
611         assembly {
612             let free_mem_ptr := mload(0x40)
613             returndatacopy(free_mem_ptr, 0, returndatasize)
614 
615             switch success
616             case 0 {
617                 revert(free_mem_ptr, returndatasize)
618             }
619             default {
620                 return(add(free_mem_ptr, 0x40), returndatasize)
621             }
622         }
623     }
624 
625     function delegateAndReturn() private returns (bytes memory) {
626         (bool success, ) = implementation.delegatecall(msg.data);
627 
628         assembly {
629             let free_mem_ptr := mload(0x40)
630             returndatacopy(free_mem_ptr, 0, returndatasize)
631 
632             switch success
633             case 0 {
634                 revert(free_mem_ptr, returndatasize)
635             }
636             default {
637                 return(free_mem_ptr, returndatasize)
638             }
639         }
640     }
641 
642     /**
643      * @notice Delegates execution to an implementation contract
644      * @dev It returns to the external caller whatever the implementation returns or forwards reverts
645      */
646     function() external payable {
647         // delegate all other functions to current implementation
648         delegateAndReturn();
649     }
650 }
