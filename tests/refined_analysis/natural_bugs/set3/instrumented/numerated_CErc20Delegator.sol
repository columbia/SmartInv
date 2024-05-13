1 pragma solidity ^0.5.16;
2 
3 import "./CTokenInterfaces.sol";
4 
5 /**
6  * @title Compound's CErc20Delegator Contract
7  * @notice CTokens which wrap an EIP-20 underlying and delegate to an implementation
8  * @author Compound
9  */
10 contract CErc20Delegator is CTokenInterface, CErc20Interface, CDelegatorInterface {
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
215      * @notice Get the current allowance from `owner` for `spender`
216      * @param owner The address of the account which owns the tokens to be spent
217      * @param spender The address of the account which may transfer tokens
218      * @return The number of tokens allowed to be spent (-1 means infinite)
219      */
220     function allowance(address owner, address spender) external view returns (uint256) {
221         owner;
222         spender; // Shh
223         delegateToViewAndReturn();
224     }
225 
226     /**
227      * @notice Get the token balance of the `owner`
228      * @param owner The address of the account to query
229      * @return The number of tokens owned by `owner`
230      */
231     function balanceOf(address owner) external view returns (uint256) {
232         owner; // Shh
233         delegateToViewAndReturn();
234     }
235 
236     /**
237      * @notice Get the underlying balance of the `owner`
238      * @dev This also accrues interest in a transaction
239      * @param owner The address of the account to query
240      * @return The amount of underlying owned by `owner`
241      */
242     function balanceOfUnderlying(address owner) external returns (uint256) {
243         owner; // Shh
244         delegateAndReturn();
245     }
246 
247     /**
248      * @notice Get a snapshot of the account's balances, and the cached exchange rate
249      * @dev This is used by comptroller to more efficiently perform liquidity checks.
250      * @param account Address of the account to snapshot
251      * @return (possible error, token balance, borrow balance, exchange rate mantissa)
252      */
253     function getAccountSnapshot(address account)
254         external
255         view
256         returns (
257             uint256,
258             uint256,
259             uint256,
260             uint256
261         )
262     {
263         account; // Shh
264         delegateToViewAndReturn();
265     }
266 
267     /**
268      * @notice Returns the current per-block borrow interest rate for this cToken
269      * @return The borrow interest rate per block, scaled by 1e18
270      */
271     function borrowRatePerBlock() external view returns (uint256) {
272         delegateToViewAndReturn();
273     }
274 
275     /**
276      * @notice Returns the current per-block supply interest rate for this cToken
277      * @return The supply interest rate per block, scaled by 1e18
278      */
279     function supplyRatePerBlock() external view returns (uint256) {
280         delegateToViewAndReturn();
281     }
282 
283     /**
284      * @notice Returns the current total borrows plus accrued interest
285      * @return The total borrows with interest
286      */
287     function totalBorrowsCurrent() external returns (uint256) {
288         delegateAndReturn();
289     }
290 
291     /**
292      * @notice Accrue interest to updated borrowIndex and then calculate account's borrow balance using the updated borrowIndex
293      * @param account The address whose balance should be calculated after updating borrowIndex
294      * @return The calculated balance
295      */
296     function borrowBalanceCurrent(address account) external returns (uint256) {
297         account; // Shh
298         delegateAndReturn();
299     }
300 
301     /**
302      * @notice Return the borrow balance of account based on stored data
303      * @param account The address whose balance should be calculated
304      * @return The calculated balance
305      */
306     function borrowBalanceStored(address account) public view returns (uint256) {
307         account; // Shh
308         delegateToViewAndReturn();
309     }
310 
311     /**
312      * @notice Accrue interest then return the up-to-date exchange rate
313      * @return Calculated exchange rate scaled by 1e18
314      */
315     function exchangeRateCurrent() public returns (uint256) {
316         delegateAndReturn();
317     }
318 
319     /**
320      * @notice Calculates the exchange rate from the underlying to the CToken
321      * @dev This function does not accrue interest before calculating the exchange rate
322      * @return Calculated exchange rate scaled by 1e18
323      */
324     function exchangeRateStored() public view returns (uint256) {
325         delegateToViewAndReturn();
326     }
327 
328     /**
329      * @notice Get cash balance of this cToken in the underlying asset
330      * @return The quantity of underlying asset owned by this contract
331      */
332     function getCash() external view returns (uint256) {
333         delegateToViewAndReturn();
334     }
335 
336     /**
337      * @notice Applies accrued interest to total borrows and reserves.
338      * @dev This calculates interest accrued from the last checkpointed block
339      *      up to the current block and writes new checkpoint to storage.
340      */
341     function accrueInterest() public returns (uint256) {
342         delegateAndReturn();
343     }
344 
345     /**
346      * @notice Transfers collateral tokens (this market) to the liquidator.
347      * @dev Will fail unless called by another cToken during the process of liquidation.
348      *  Its absolutely critical to use msg.sender as the borrowed cToken and not a parameter.
349      * @param liquidator The account receiving seized collateral
350      * @param borrower The account having collateral seized
351      * @param seizeTokens The number of cTokens to seize
352      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
353      */
354     function seize(
355         address liquidator,
356         address borrower,
357         uint256 seizeTokens
358     ) external returns (uint256) {
359         liquidator;
360         borrower;
361         seizeTokens; // Shh
362         delegateAndReturn();
363     }
364 
365     /*** Admin Functions ***/
366 
367     /**
368      * @notice Begins transfer of admin rights. The newPendingAdmin must call `_acceptAdmin` to finalize the transfer.
369      * @dev Admin function to begin change of admin. The newPendingAdmin must call `_acceptAdmin` to finalize the transfer.
370      * @param newPendingAdmin New pending admin.
371      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
372      */
373     function _setPendingAdmin(address payable newPendingAdmin) external returns (uint256) {
374         newPendingAdmin; // Shh
375         delegateAndReturn();
376     }
377 
378     /**
379      * @notice Sets a new comptroller for the market
380      * @dev Admin function to set a new comptroller
381      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
382      */
383     function _setComptroller(ComptrollerInterface newComptroller) public returns (uint256) {
384         newComptroller; // Shh
385         delegateAndReturn();
386     }
387 
388     /**
389      * @notice accrues interest and sets a new reserve factor for the protocol using _setReserveFactorFresh
390      * @dev Admin function to accrue interest and set a new reserve factor
391      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
392      */
393     function _setReserveFactor(uint256 newReserveFactorMantissa) external returns (uint256) {
394         newReserveFactorMantissa; // Shh
395         delegateAndReturn();
396     }
397 
398     /**
399      * @notice Accepts transfer of admin rights. msg.sender must be pendingAdmin
400      * @dev Admin function for pending admin to accept role and update admin
401      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
402      */
403     function _acceptAdmin() external returns (uint256) {
404         delegateAndReturn();
405     }
406 
407     /**
408      * @notice Accrues interest and adds reserves by transferring from admin
409      * @param addAmount Amount of reserves to add
410      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
411      */
412     function _addReserves(uint256 addAmount) external returns (uint256) {
413         addAmount; // Shh
414         delegateAndReturn();
415     }
416 
417     /**
418      * @notice Accrues interest and reduces reserves by transferring to admin
419      * @param reduceAmount Amount of reduction to reserves
420      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
421      */
422     function _reduceReserves(uint256 reduceAmount) external returns (uint256) {
423         reduceAmount; // Shh
424         delegateAndReturn();
425     }
426 
427     /**
428      * @notice Accrues interest and updates the interest rate model using _setInterestRateModelFresh
429      * @dev Admin function to accrue interest and update the interest rate model
430      * @param newInterestRateModel the new interest rate model to use
431      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
432      */
433     function _setInterestRateModel(InterestRateModel newInterestRateModel) public returns (uint256) {
434         newInterestRateModel; // Shh
435         delegateAndReturn();
436     }
437 
438     /**
439      * @notice Internal method to delegate execution to another contract
440      * @dev It returns to the external caller whatever the implementation returns or forwards reverts
441      * @param callee The contract to delegatecall
442      * @param data The raw data to delegatecall
443      * @return The returned bytes from the delegatecall
444      */
445     function delegateTo(address callee, bytes memory data) internal returns (bytes memory) {
446         (bool success, bytes memory returnData) = callee.delegatecall(data);
447         assembly {
448             if eq(success, 0) {
449                 revert(add(returnData, 0x20), returndatasize)
450             }
451         }
452         return returnData;
453     }
454 
455     /**
456      * @notice Delegates execution to the implementation contract
457      * @dev It returns to the external caller whatever the implementation returns or forwards reverts
458      * @param data The raw data to delegatecall
459      * @return The returned bytes from the delegatecall
460      */
461     function delegateToImplementation(bytes memory data) public returns (bytes memory) {
462         return delegateTo(implementation, data);
463     }
464 
465     /**
466      * @notice Delegates execution to an implementation contract
467      * @dev It returns to the external caller whatever the implementation returns or forwards reverts
468      *  There are an additional 2 prefix uints from the wrapper returndata, which we ignore since we make an extra hop.
469      * @param data The raw data to delegatecall
470      * @return The returned bytes from the delegatecall
471      */
472     function delegateToViewImplementation(bytes memory data) public view returns (bytes memory) {
473         (bool success, bytes memory returnData) = address(this).staticcall(
474             abi.encodeWithSignature("delegateToImplementation(bytes)", data)
475         );
476         assembly {
477             if eq(success, 0) {
478                 revert(add(returnData, 0x20), returndatasize)
479             }
480         }
481         return abi.decode(returnData, (bytes));
482     }
483 
484     function delegateToViewAndReturn() private view returns (bytes memory) {
485         (bool success, ) = address(this).staticcall(
486             abi.encodeWithSignature("delegateToImplementation(bytes)", msg.data)
487         );
488 
489         assembly {
490             let free_mem_ptr := mload(0x40)
491             returndatacopy(free_mem_ptr, 0, returndatasize)
492 
493             switch success
494             case 0 {
495                 revert(free_mem_ptr, returndatasize)
496             }
497             default {
498                 return(add(free_mem_ptr, 0x40), returndatasize)
499             }
500         }
501     }
502 
503     function delegateAndReturn() private returns (bytes memory) {
504         (bool success, ) = implementation.delegatecall(msg.data);
505 
506         assembly {
507             let free_mem_ptr := mload(0x40)
508             returndatacopy(free_mem_ptr, 0, returndatasize)
509 
510             switch success
511             case 0 {
512                 revert(free_mem_ptr, returndatasize)
513             }
514             default {
515                 return(free_mem_ptr, returndatasize)
516             }
517         }
518     }
519 
520     /**
521      * @notice Delegates execution to an implementation contract
522      * @dev It returns to the external caller whatever the implementation returns or forwards reverts
523      */
524     function() external payable {
525         require(msg.value == 0, "CErc20Delegator:fallback: cannot send value to fallback");
526 
527         // delegate all other functions to current implementation
528         delegateAndReturn();
529     }
530 }
