1 pragma solidity ^0.5.16;
2 
3 import "../CTokenInterfaces.sol";
4 
5 /**
6  * @title Cream's CCollateralCapErc20Delegator Contract
7  * @notice CTokens which wrap an EIP-20 underlying and delegate to an implementation
8  * @author Cream
9  */
10 contract CCollateralCapErc20Delegator is CTokenInterface, CCollateralCapErc20Interface, CDelegatorInterface {
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
72         require(msg.sender == admin, "CErc20Delegator::_setImplementation: Caller must be admin");
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
98      * @notice Sender redeems cTokens in exchange for the underlying asset
99      * @dev Accrues interest whether or not the operation succeeds, unless reverted
100      * @param redeemTokens The number of cTokens to redeem into underlying
101      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
102      */
103     function redeem(uint256 redeemTokens) external returns (uint256) {
104         redeemTokens; // Shh
105         delegateAndReturn();
106     }
107 
108     /**
109      * @notice Sender redeems cTokens in exchange for a specified amount of underlying asset
110      * @dev Accrues interest whether or not the operation succeeds, unless reverted
111      * @param redeemAmount The amount of underlying to redeem
112      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
113      */
114     function redeemUnderlying(uint256 redeemAmount) external returns (uint256) {
115         redeemAmount; // Shh
116         delegateAndReturn();
117     }
118 
119     /**
120      * @notice Sender borrows assets from the protocol to their own address
121      * @param borrowAmount The amount of the underlying asset to borrow
122      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
123      */
124     function borrow(uint256 borrowAmount) external returns (uint256) {
125         borrowAmount; // Shh
126         delegateAndReturn();
127     }
128 
129     /**
130      * @notice Sender repays their own borrow
131      * @param repayAmount The amount to repay
132      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
133      */
134     function repayBorrow(uint256 repayAmount) external returns (uint256) {
135         repayAmount; // Shh
136         delegateAndReturn();
137     }
138 
139     /**
140      * @notice Sender repays a borrow belonging to borrower
141      * @param borrower the account with the debt being payed off
142      * @param repayAmount The amount to repay
143      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
144      */
145     function repayBorrowBehalf(address borrower, uint256 repayAmount) external returns (uint256) {
146         borrower;
147         repayAmount; // Shh
148         delegateAndReturn();
149     }
150 
151     /**
152      * @notice The sender liquidates the borrowers collateral.
153      *  The collateral seized is transferred to the liquidator.
154      * @param borrower The borrower of this cToken to be liquidated
155      * @param cTokenCollateral The market in which to seize collateral from the borrower
156      * @param repayAmount The amount of the underlying borrowed asset to repay
157      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
158      */
159     function liquidateBorrow(
160         address borrower,
161         uint256 repayAmount,
162         CTokenInterface cTokenCollateral
163     ) external returns (uint256) {
164         borrower;
165         repayAmount;
166         cTokenCollateral; // Shh
167         delegateAndReturn();
168     }
169 
170     /**
171      * @notice Transfer `amount` tokens from `msg.sender` to `dst`
172      * @param dst The address of the destination account
173      * @param amount The number of tokens to transfer
174      * @return Whether or not the transfer succeeded
175      */
176     function transfer(address dst, uint256 amount) external returns (bool) {
177         dst;
178         amount; // Shh
179         delegateAndReturn();
180     }
181 
182     /**
183      * @notice Transfer `amount` tokens from `src` to `dst`
184      * @param src The address of the source account
185      * @param dst The address of the destination account
186      * @param amount The number of tokens to transfer
187      * @return Whether or not the transfer succeeded
188      */
189     function transferFrom(
190         address src,
191         address dst,
192         uint256 amount
193     ) external returns (bool) {
194         src;
195         dst;
196         amount; // Shh
197         delegateAndReturn();
198     }
199 
200     /**
201      * @notice Approve `spender` to transfer up to `amount` from `src`
202      * @dev This will overwrite the approval amount for `spender`
203      *  and is subject to issues noted [here](https://eips.ethereum.org/EIPS/eip-20#approve)
204      * @param spender The address of the account which may transfer tokens
205      * @param amount The number of tokens that are approved (-1 means infinite)
206      * @return Whether or not the approval succeeded
207      */
208     function approve(address spender, uint256 amount) external returns (bool) {
209         spender;
210         amount; // Shh
211         delegateAndReturn();
212     }
213 
214     /**
215      * @notice Gulps excess contract cash to reserves
216      * @dev This function calculates excess ERC20 gained from a ERC20.transfer() call and adds the excess to reserves.
217      */
218     function gulp() external {
219         delegateAndReturn();
220     }
221 
222     /**
223      * @notice Flash loan funds to a given account.
224      * @param receiver The receiver address for the funds
225      * @param initiator flash loan initiator
226      * @param amount The amount of the funds to be loaned
227      * @param data The other data
228      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
229      */
230     function flashLoan(
231         ERC3156FlashBorrowerInterface receiver,
232         address initiator,
233         uint256 amount,
234         bytes calldata data
235     ) external returns (bool) {
236         receiver;
237         initiator;
238         amount;
239         data; // Shh
240         delegateAndReturn();
241     }
242 
243     /**
244      * @notice Register account collateral tokens if there is space.
245      * @param account The account to register
246      * @dev This function could only be called by comptroller.
247      * @return The actual registered amount of collateral
248      */
249     function registerCollateral(address account) external returns (uint256) {
250         account; // Shh
251         delegateAndReturn();
252     }
253 
254     /**
255      * @notice Unregister account collateral tokens if the account still has enough collateral.
256      * @dev This function could only be called by comptroller.
257      * @param account The account to unregister
258      */
259     function unregisterCollateral(address account) external {
260         account; // Shh
261         delegateAndReturn();
262     }
263 
264     /**
265      * @notice Get the current allowance from `owner` for `spender`
266      * @param owner The address of the account which owns the tokens to be spent
267      * @param spender The address of the account which may transfer tokens
268      * @return The number of tokens allowed to be spent (-1 means infinite)
269      */
270     function allowance(address owner, address spender) external view returns (uint256) {
271         owner;
272         spender; // Shh
273         delegateToViewAndReturn();
274     }
275 
276     /**
277      * @notice Get the token balance of the `owner`
278      * @param owner The address of the account to query
279      * @return The number of tokens owned by `owner`
280      */
281     function balanceOf(address owner) external view returns (uint256) {
282         owner; // Shh
283         delegateToViewAndReturn();
284     }
285 
286     /**
287      * @notice Get the underlying balance of the `owner`
288      * @dev This also accrues interest in a transaction
289      * @param owner The address of the account to query
290      * @return The amount of underlying owned by `owner`
291      */
292     function balanceOfUnderlying(address owner) external returns (uint256) {
293         owner; // Shh
294         delegateAndReturn();
295     }
296 
297     /**
298      * @notice Get a snapshot of the account's balances, and the cached exchange rate
299      * @dev This is used by comptroller to more efficiently perform liquidity checks.
300      * @param account Address of the account to snapshot
301      * @return (possible error, token balance, borrow balance, exchange rate mantissa)
302      */
303     function getAccountSnapshot(address account)
304         external
305         view
306         returns (
307             uint256,
308             uint256,
309             uint256,
310             uint256
311         )
312     {
313         account; // Shh
314         delegateToViewAndReturn();
315     }
316 
317     /**
318      * @notice Returns the current per-block borrow interest rate for this cToken
319      * @return The borrow interest rate per block, scaled by 1e18
320      */
321     function borrowRatePerBlock() external view returns (uint256) {
322         delegateToViewAndReturn();
323     }
324 
325     /**
326      * @notice Returns the current per-block supply interest rate for this cToken
327      * @return The supply interest rate per block, scaled by 1e18
328      */
329     function supplyRatePerBlock() external view returns (uint256) {
330         delegateToViewAndReturn();
331     }
332 
333     /**
334      * @notice Returns the current total borrows plus accrued interest
335      * @return The total borrows with interest
336      */
337     function totalBorrowsCurrent() external returns (uint256) {
338         delegateAndReturn();
339     }
340 
341     /**
342      * @notice Accrue interest to updated borrowIndex and then calculate account's borrow balance using the updated borrowIndex
343      * @param account The address whose balance should be calculated after updating borrowIndex
344      * @return The calculated balance
345      */
346     function borrowBalanceCurrent(address account) external returns (uint256) {
347         account; // Shh
348         delegateAndReturn();
349     }
350 
351     /**
352      * @notice Return the borrow balance of account based on stored data
353      * @param account The address whose balance should be calculated
354      * @return The calculated balance
355      */
356     function borrowBalanceStored(address account) public view returns (uint256) {
357         account; // Shh
358         delegateToViewAndReturn();
359     }
360 
361     /**
362      * @notice Accrue interest then return the up-to-date exchange rate
363      * @return Calculated exchange rate scaled by 1e18
364      */
365     function exchangeRateCurrent() public returns (uint256) {
366         delegateAndReturn();
367     }
368 
369     /**
370      * @notice Calculates the exchange rate from the underlying to the CToken
371      * @dev This function does not accrue interest before calculating the exchange rate
372      * @return Calculated exchange rate scaled by 1e18
373      */
374     function exchangeRateStored() public view returns (uint256) {
375         delegateToViewAndReturn();
376     }
377 
378     /**
379      * @notice Get cash balance of this cToken in the underlying asset
380      * @return The quantity of underlying asset owned by this contract
381      */
382     function getCash() external view returns (uint256) {
383         delegateToViewAndReturn();
384     }
385 
386     /**
387      * @notice Applies accrued interest to total borrows and reserves.
388      * @dev This calculates interest accrued from the last checkpointed block
389      *      up to the current block and writes new checkpoint to storage.
390      */
391     function accrueInterest() public returns (uint256) {
392         delegateAndReturn();
393     }
394 
395     /**
396      * @notice Transfers collateral tokens (this market) to the liquidator.
397      * @dev Will fail unless called by another cToken during the process of liquidation.
398      *  Its absolutely critical to use msg.sender as the borrowed cToken and not a parameter.
399      * @param liquidator The account receiving seized collateral
400      * @param borrower The account having collateral seized
401      * @param seizeTokens The number of cTokens to seize
402      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
403      */
404     function seize(
405         address liquidator,
406         address borrower,
407         uint256 seizeTokens
408     ) external returns (uint256) {
409         liquidator;
410         borrower;
411         seizeTokens; // Shh
412         delegateAndReturn();
413     }
414 
415     /*** Admin Functions ***/
416 
417     /**
418      * @notice Begins transfer of admin rights. The newPendingAdmin must call `_acceptAdmin` to finalize the transfer.
419      * @dev Admin function to begin change of admin. The newPendingAdmin must call `_acceptAdmin` to finalize the transfer.
420      * @param newPendingAdmin New pending admin.
421      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
422      */
423     function _setPendingAdmin(address payable newPendingAdmin) external returns (uint256) {
424         newPendingAdmin; // Shh
425         delegateAndReturn();
426     }
427 
428     /**
429      * @notice Sets a new comptroller for the market
430      * @dev Admin function to set a new comptroller
431      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
432      */
433     function _setComptroller(ComptrollerInterface newComptroller) public returns (uint256) {
434         newComptroller; // Shh
435         delegateAndReturn();
436     }
437 
438     /**
439      * @notice accrues interest and sets a new reserve factor for the protocol using _setReserveFactorFresh
440      * @dev Admin function to accrue interest and set a new reserve factor
441      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
442      */
443     function _setReserveFactor(uint256 newReserveFactorMantissa) external returns (uint256) {
444         newReserveFactorMantissa; // Shh
445         delegateAndReturn();
446     }
447 
448     /**
449      * @notice Accepts transfer of admin rights. msg.sender must be pendingAdmin
450      * @dev Admin function for pending admin to accept role and update admin
451      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
452      */
453     function _acceptAdmin() external returns (uint256) {
454         delegateAndReturn();
455     }
456 
457     /**
458      * @notice Accrues interest and adds reserves by transferring from admin
459      * @param addAmount Amount of reserves to add
460      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
461      */
462     function _addReserves(uint256 addAmount) external returns (uint256) {
463         addAmount; // Shh
464         delegateAndReturn();
465     }
466 
467     /**
468      * @notice Accrues interest and reduces reserves by transferring to admin
469      * @param reduceAmount Amount of reduction to reserves
470      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
471      */
472     function _reduceReserves(uint256 reduceAmount) external returns (uint256) {
473         reduceAmount; // Shh
474         delegateAndReturn();
475     }
476 
477     /**
478      * @notice Accrues interest and updates the interest rate model using _setInterestRateModelFresh
479      * @dev Admin function to accrue interest and update the interest rate model
480      * @param newInterestRateModel the new interest rate model to use
481      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
482      */
483     function _setInterestRateModel(InterestRateModel newInterestRateModel) public returns (uint256) {
484         newInterestRateModel; // Shh
485         delegateAndReturn();
486     }
487 
488     /**
489      * @notice Set collateral cap of this market, 0 for no cap
490      * @param newCollateralCap The new collateral cap
491      */
492     function _setCollateralCap(uint256 newCollateralCap) external {
493         newCollateralCap; // Shh
494         delegateAndReturn();
495     }
496 
497     /**
498      * @notice Internal method to delegate execution to another contract
499      * @dev It returns to the external caller whatever the implementation returns or forwards reverts
500      * @param callee The contract to delegatecall
501      * @param data The raw data to delegatecall
502      * @return The returned bytes from the delegatecall
503      */
504     function delegateTo(address callee, bytes memory data) internal returns (bytes memory) {
505         (bool success, bytes memory returnData) = callee.delegatecall(data);
506         assembly {
507             if eq(success, 0) {
508                 revert(add(returnData, 0x20), returndatasize)
509             }
510         }
511         return returnData;
512     }
513 
514     /**
515      * @notice Delegates execution to the implementation contract
516      * @dev It returns to the external caller whatever the implementation returns or forwards reverts
517      * @param data The raw data to delegatecall
518      * @return The returned bytes from the delegatecall
519      */
520     function delegateToImplementation(bytes memory data) public returns (bytes memory) {
521         return delegateTo(implementation, data);
522     }
523 
524     /**
525      * @notice Delegates execution to an implementation contract
526      * @dev It returns to the external caller whatever the implementation returns or forwards reverts
527      *  There are an additional 2 prefix uints from the wrapper returndata, which we ignore since we make an extra hop.
528      * @param data The raw data to delegatecall
529      * @return The returned bytes from the delegatecall
530      */
531     function delegateToViewImplementation(bytes memory data) public view returns (bytes memory) {
532         (bool success, bytes memory returnData) = address(this).staticcall(
533             abi.encodeWithSignature("delegateToImplementation(bytes)", data)
534         );
535         assembly {
536             if eq(success, 0) {
537                 revert(add(returnData, 0x20), returndatasize)
538             }
539         }
540         return abi.decode(returnData, (bytes));
541     }
542 
543     function delegateToViewAndReturn() private view returns (bytes memory) {
544         (bool success, ) = address(this).staticcall(
545             abi.encodeWithSignature("delegateToImplementation(bytes)", msg.data)
546         );
547 
548         assembly {
549             let free_mem_ptr := mload(0x40)
550             returndatacopy(free_mem_ptr, 0, returndatasize)
551 
552             switch success
553             case 0 {
554                 revert(free_mem_ptr, returndatasize)
555             }
556             default {
557                 return(add(free_mem_ptr, 0x40), returndatasize)
558             }
559         }
560     }
561 
562     function delegateAndReturn() private returns (bytes memory) {
563         (bool success, ) = implementation.delegatecall(msg.data);
564 
565         assembly {
566             let free_mem_ptr := mload(0x40)
567             returndatacopy(free_mem_ptr, 0, returndatasize)
568 
569             switch success
570             case 0 {
571                 revert(free_mem_ptr, returndatasize)
572             }
573             default {
574                 return(free_mem_ptr, returndatasize)
575             }
576         }
577     }
578 
579     /**
580      * @notice Delegates execution to an implementation contract
581      * @dev It returns to the external caller whatever the implementation returns or forwards reverts
582      */
583     function() external payable {
584         require(msg.value == 0, "CErc20Delegator:fallback: cannot send value to fallback");
585 
586         // delegate all other functions to current implementation
587         delegateAndReturn();
588     }
589 }
