1 
2 // File: contracts/ComptrollerInterface.sol
3 
4 pragma solidity ^0.5.12;
5 
6 interface ComptrollerInterface {
7     /**
8      * @notice Marker function used for light validation when updating the comptroller of a market
9      * @dev Implementations should simply return true.
10      * @return true
11      */
12     function isComptroller() external view returns (bool);
13 
14     /*** Assets You Are In ***/
15 
16     function enterMarkets(address[] calldata cTokens) external returns (uint[] memory);
17     function exitMarket(address cToken) external returns (uint);
18 
19     /*** Policy Hooks ***/
20 
21     function mintAllowed(address cToken, address minter, uint mintAmount) external returns (uint);
22     function mintVerify(address cToken, address minter, uint mintAmount, uint mintTokens) external;
23 
24     function redeemAllowed(address cToken, address redeemer, uint redeemTokens) external returns (uint);
25     function redeemVerify(address cToken, address redeemer, uint redeemAmount, uint redeemTokens) external;
26 
27     function borrowAllowed(address cToken, address borrower, uint borrowAmount) external returns (uint);
28     function borrowVerify(address cToken, address borrower, uint borrowAmount) external;
29 
30     function repayBorrowAllowed(
31         address cToken,
32         address payer,
33         address borrower,
34         uint repayAmount) external returns (uint);
35     function repayBorrowVerify(
36         address cToken,
37         address payer,
38         address borrower,
39         uint repayAmount,
40         uint borrowerIndex) external;
41 
42     function liquidateBorrowAllowed(
43         address cTokenBorrowed,
44         address cTokenCollateral,
45         address liquidator,
46         address borrower,
47         uint repayAmount) external returns (uint);
48     function liquidateBorrowVerify(
49         address cTokenBorrowed,
50         address cTokenCollateral,
51         address liquidator,
52         address borrower,
53         uint repayAmount,
54         uint seizeTokens) external;
55 
56     function seizeAllowed(
57         address cTokenCollateral,
58         address cTokenBorrowed,
59         address liquidator,
60         address borrower,
61         uint seizeTokens) external returns (uint);
62     function seizeVerify(
63         address cTokenCollateral,
64         address cTokenBorrowed,
65         address liquidator,
66         address borrower,
67         uint seizeTokens) external;
68 
69     function transferAllowed(address cToken, address src, address dst, uint transferTokens) external returns (uint);
70     function transferVerify(address cToken, address src, address dst, uint transferTokens) external;
71 
72     /*** Liquidity/Liquidation Calculations ***/
73 
74     function liquidateCalculateSeizeTokens(
75         address cTokenBorrowed,
76         address cTokenCollateral,
77         uint repayAmount) external view returns (uint, uint);
78 }
79 
80 // File: contracts/InterestRateModel.sol
81 
82 pragma solidity ^0.5.12;
83 
84 /**
85   * @title Compound's InterestRateModel Interface
86   * @author Compound
87   */
88 interface InterestRateModel {
89     /**
90      * @notice Indicator that this is an InterestRateModel contract (for inspection)
91      */
92     function isInterestRateModel() external pure returns (bool);
93 
94     /**
95       * @notice Calculates the current borrow interest rate per block
96       * @param cash The total amount of cash the market has
97       * @param borrows The total amount of borrows the market has outstanding
98       * @param reserves The total amnount of reserves the market has
99       * @return The borrow rate per block (as a percentage, and scaled by 1e18)
100       */
101     function getBorrowRate(uint cash, uint borrows, uint reserves) external view returns (uint);
102 
103     /**
104       * @notice Calculates the current supply interest rate per block
105       * @param cash The total amount of cash the market has
106       * @param borrows The total amount of borrows the market has outstanding
107       * @param reserves The total amnount of reserves the market has
108       * @param reserveFactorMantissa The current reserve factor the market has
109       * @return The supply rate per block (as a percentage, and scaled by 1e18)
110       */
111     function getSupplyRate(uint cash, uint borrows, uint reserves, uint reserveFactorMantissa) external view returns (uint);
112 
113 }
114 
115 // File: contracts/CTokenInterfaces.sol
116 
117 pragma solidity ^0.5.12;
118 
119 
120 
121 contract CTokenStorage {
122     /**
123      * @dev Guard variable for re-entrancy checks
124      */
125     bool internal _notEntered;
126 
127     /**
128      * @notice EIP-20 token name for this token
129      */
130     string public name;
131 
132     /**
133      * @notice EIP-20 token symbol for this token
134      */
135     string public symbol;
136 
137     /**
138      * @notice EIP-20 token decimals for this token
139      */
140     uint8 public decimals;
141 
142     /**
143      * @notice Maximum borrow rate that can ever be applied (.0005% / block)
144      */
145 
146     uint internal constant borrowRateMaxMantissa = 0.0005e16;
147 
148     /**
149      * @notice Maximum fraction of interest that can be set aside for reserves
150      */
151     uint internal constant reserveFactorMaxMantissa = 1e18;
152 
153     /**
154      * @notice Administrator for this contract
155      */
156     address payable public admin;
157 
158     /**
159      * @notice Pending administrator for this contract
160      */
161     address payable public pendingAdmin;
162 
163     /**
164      * @notice Contract which oversees inter-cToken operations
165      */
166     ComptrollerInterface public comptroller;
167 
168     /**
169      * @notice Model which tells what the current interest rate should be
170      */
171     InterestRateModel public interestRateModel;
172 
173     /**
174      * @notice Initial exchange rate used when minting the first CTokens (used when totalSupply = 0)
175      */
176     uint internal initialExchangeRateMantissa;
177 
178     /**
179      * @notice Fraction of interest currently set aside for reserves
180      */
181     uint public reserveFactorMantissa;
182 
183     /**
184      * @notice Block number that interest was last accrued at
185      */
186     uint public accrualBlockNumber;
187 
188     /**
189      * @notice Accumulator of the total earned interest rate since the opening of the market
190      */
191     uint public borrowIndex;
192 
193     /**
194      * @notice Total amount of outstanding borrows of the underlying in this market
195      */
196     uint public totalBorrows;
197 
198     /**
199      * @notice Total amount of reserves of the underlying held in this market
200      */
201     uint public totalReserves;
202 
203     /**
204      * @notice Total number of tokens in circulation
205      */
206     uint public totalSupply;
207 
208     /**
209      * @notice Official record of token balances for each account
210      */
211     mapping (address => uint) internal accountTokens;
212 
213     /**
214      * @notice Approved token transfer amounts on behalf of others
215      */
216     mapping (address => mapping (address => uint)) internal transferAllowances;
217 
218     /**
219      * @notice Container for borrow balance information
220      * @member principal Total balance (with accrued interest), after applying the most recent balance-changing action
221      * @member interestIndex Global borrowIndex as of the most recent balance-changing action
222      */
223     struct BorrowSnapshot {
224         uint principal;
225         uint interestIndex;
226     }
227 
228     /**
229      * @notice Mapping of account addresses to outstanding borrow balances
230      */
231     mapping(address => BorrowSnapshot) internal accountBorrows;
232 }
233 
234 contract CTokenInterface is CTokenStorage {
235     /**
236      * @notice Indicator that this is a CToken contract (for inspection)
237      */
238     bool public constant isCToken = true;
239 
240 
241     /*** Market Events ***/
242 
243     /**
244      * @notice Event emitted when interest is accrued
245      */
246     event AccrueInterest(uint cashPrior, uint interestAccumulated, uint borrowIndex, uint totalBorrows);
247 
248     /**
249      * @notice Event emitted when tokens are minted
250      */
251     event Mint(address minter, uint mintAmount, uint mintTokens);
252 
253     /**
254      * @notice Event emitted when tokens are redeemed
255      */
256     event Redeem(address redeemer, uint redeemAmount, uint redeemTokens);
257 
258     /**
259      * @notice Event emitted when underlying is borrowed
260      */
261     event Borrow(address borrower, uint borrowAmount, uint accountBorrows, uint totalBorrows);
262 
263     /**
264      * @notice Event emitted when a borrow is repaid
265      */
266     event RepayBorrow(address payer, address borrower, uint repayAmount, uint accountBorrows, uint totalBorrows);
267 
268     /**
269      * @notice Event emitted when a borrow is liquidated
270      */
271     event LiquidateBorrow(address liquidator, address borrower, uint repayAmount, address cTokenCollateral, uint seizeTokens);
272 
273 
274     /*** Admin Events ***/
275 
276     /**
277      * @notice Event emitted when pendingAdmin is changed
278      */
279     event NewPendingAdmin(address oldPendingAdmin, address newPendingAdmin);
280 
281     /**
282      * @notice Event emitted when pendingAdmin is accepted, which means admin is updated
283      */
284     event NewAdmin(address oldAdmin, address newAdmin);
285 
286     /**
287      * @notice Event emitted when comptroller is changed
288      */
289     event NewComptroller(ComptrollerInterface oldComptroller, ComptrollerInterface newComptroller);
290 
291     /**
292      * @notice Event emitted when interestRateModel is changed
293      */
294     event NewMarketInterestRateModel(InterestRateModel oldInterestRateModel, InterestRateModel newInterestRateModel);
295 
296     /**
297      * @notice Event emitted when the reserve factor is changed
298      */
299     event NewReserveFactor(uint oldReserveFactorMantissa, uint newReserveFactorMantissa);
300 
301     /**
302      * @notice Event emitted when the reserves are added
303      */
304     event ReservesAdded(address benefactor, uint addAmount, uint newTotalReserves);
305 
306     /**
307      * @notice Event emitted when the reserves are reduced
308      */
309     event ReservesReduced(address admin, uint reduceAmount, uint newTotalReserves);
310 
311     /**
312      * @notice EIP20 Transfer event
313      */
314     event Transfer(address indexed from, address indexed to, uint amount);
315 
316     /**
317      * @notice EIP20 Approval event
318      */
319     event Approval(address indexed owner, address indexed spender, uint amount);
320 
321     /**
322      * @notice Failure event
323      */
324     event Failure(uint error, uint info, uint detail);
325 
326 
327     /*** User Interface ***/
328 
329     function transfer(address dst, uint amount) external returns (bool);
330     function transferFrom(address src, address dst, uint amount) external returns (bool);
331     function approve(address spender, uint amount) external returns (bool);
332     function allowance(address owner, address spender) external view returns (uint);
333     function balanceOf(address owner) external view returns (uint);
334     function balanceOfUnderlying(address owner) external returns (uint);
335     function getAccountSnapshot(address account) external view returns (uint, uint, uint, uint);
336     function borrowRatePerBlock() external view returns (uint);
337     function supplyRatePerBlock() external view returns (uint);
338     function totalBorrowsCurrent() external returns (uint);
339     function borrowBalanceCurrent(address account) external returns (uint);
340     function borrowBalanceStored(address account) public view returns (uint);
341     function exchangeRateCurrent() public returns (uint);
342     function exchangeRateStored() public view returns (uint);
343     function getCash() external view returns (uint);
344     function accrueInterest() public returns (uint);
345     function seize(address liquidator, address borrower, uint seizeTokens) external returns (uint);
346 
347 
348     /*** Admin Functions ***/
349 
350     function _setPendingAdmin(address payable newPendingAdmin) external returns (uint);
351     function _acceptAdmin() external returns (uint);
352     function _setComptroller(ComptrollerInterface newComptroller) public returns (uint);
353     function _setReserveFactor(uint newReserveFactorMantissa) external returns (uint);
354     function _reduceReserves(uint reduceAmount) external returns (uint);
355     function _setInterestRateModel(InterestRateModel newInterestRateModel) public returns (uint);
356 }
357 
358 contract CErc20Storage {
359     /**
360      * @notice Underlying asset for this CToken
361      */
362     address public underlying;
363 }
364 
365 contract CErc20Interface is CErc20Storage {
366 
367     /*** User Interface ***/
368 
369     function mint(uint mintAmount) external returns (uint);
370     function redeem(uint redeemTokens) external returns (uint);
371     function redeemUnderlying(uint redeemAmount) external returns (uint);
372     function borrow(uint borrowAmount) external returns (uint);
373     function repayBorrow(uint repayAmount) external returns (uint);
374     function repayBorrowBehalf(address borrower, uint repayAmount) external returns (uint);
375     function liquidateBorrow(address borrower, uint repayAmount, CTokenInterface cTokenCollateral) external returns (uint);
376 
377 
378     /*** Admin Functions ***/
379 
380     function _addReserves(uint addAmount) external returns (uint);
381 }
382 
383 contract CDelegationStorage {
384     /**
385      * @notice Implementation address for this contract
386      */
387     address public implementation;
388 }
389 
390 contract CDelegatorInterface is CDelegationStorage {
391     /**
392      * @notice Emitted when implementation is changed
393      */
394     event NewImplementation(address oldImplementation, address newImplementation);
395 
396     /**
397      * @notice Called by the admin to update the implementation of the delegator
398      * @param implementation_ The address of the new implementation for delegation
399      * @param allowResign Flag to indicate whether to call _resignImplementation on the old implementation
400      * @param becomeImplementationData The encoded bytes data to be passed to _becomeImplementation
401      */
402     function _setImplementation(address implementation_, bool allowResign, bytes memory becomeImplementationData) public;
403 }
404 
405 contract CDelegateInterface is CDelegationStorage {
406     /**
407      * @notice Called by the delegator on a delegate to initialize it for duty
408      * @dev Should revert if any issues arise which make it unfit for delegation
409      * @param data The encoded bytes data for any initialization
410      */
411     function _becomeImplementation(bytes memory data) public;
412 
413     /**
414      * @notice Called by the delegator on a delegate to forfeit its responsibility
415      */
416     function _resignImplementation() public;
417 }
418 
419 // File: contracts/CErc20Delegator.sol
420 
421 pragma solidity ^0.5.12;
422 
423 
424 /**
425  * @title Compound's CErc20Delegator Contract
426  * @notice CTokens which wrap an EIP-20 underlying and delegate to an implementation
427  * @author Compound
428  */
429 contract CErc20Delegator is CTokenInterface, CErc20Interface, CDelegatorInterface {
430     /**
431      * @notice Construct a new money market
432      * @param underlying_ The address of the underlying asset
433      * @param comptroller_ The address of the Comptroller
434      * @param interestRateModel_ The address of the interest rate model
435      * @param initialExchangeRateMantissa_ The initial exchange rate, scaled by 1e18
436      * @param name_ ERC-20 name of this token
437      * @param symbol_ ERC-20 symbol of this token
438      * @param decimals_ ERC-20 decimal precision of this token
439      * @param admin_ Address of the administrator of this token
440      * @param implementation_ The address of the implementation the contract delegates to
441      * @param becomeImplementationData The encoded args for becomeImplmenetation
442      */
443     constructor(address underlying_,
444                 ComptrollerInterface comptroller_,
445                 InterestRateModel interestRateModel_,
446                 uint initialExchangeRateMantissa_,
447                 string memory name_,
448                 string memory symbol_,
449                 uint8 decimals_,
450                 address payable admin_,
451                 address implementation_,
452                 bytes memory becomeImplementationData) public {
453         // Creator of the contract is admin during initialization
454         admin = msg.sender;
455 
456         // First delegate gets to initialize the delegator (i.e. storage contract)
457         delegateTo(implementation_, abi.encodeWithSignature("initialize(address,address,address,uint256,string,string,uint8)",
458                                                             underlying_,
459                                                             comptroller_,
460                                                             interestRateModel_,
461                                                             initialExchangeRateMantissa_,
462                                                             name_,
463                                                             symbol_,
464                                                             decimals_));
465 
466         // New implementations always get set via the settor (post-initialize)
467         _setImplementation(implementation_, false, becomeImplementationData);
468 
469         // Set the proper admin now that initialization is done
470         admin = admin_;
471     }
472 
473     /**
474      * @notice Called by the admin to update the implementation of the delegator
475      * @param implementation_ The address of the new implementation for delegation
476      * @param allowResign Flag to indicate whether to call _resignImplementation on the old implementation
477      * @param becomeImplementationData The encoded bytes data to be passed to _becomeImplementation
478      */
479     function _setImplementation(address implementation_, bool allowResign, bytes memory becomeImplementationData) public {
480         require(msg.sender == admin, "CErc20Delegator::_setImplementation: Caller must be admin");
481 
482         if (allowResign) {
483             delegateToImplementation(abi.encodeWithSignature("_resignImplementation()"));
484         }
485 
486         address oldImplementation = implementation;
487         implementation = implementation_;
488 
489         delegateToImplementation(abi.encodeWithSignature("_becomeImplementation(bytes)", becomeImplementationData));
490 
491         emit NewImplementation(oldImplementation, implementation);
492     }
493 
494     /**
495      * @notice Sender supplies assets into the market and receives cTokens in exchange
496      * @dev Accrues interest whether or not the operation succeeds, unless reverted
497      * @param mintAmount The amount of the underlying asset to supply
498      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
499      */
500     function mint(uint mintAmount) external returns (uint) {
501         bytes memory data = delegateToImplementation(abi.encodeWithSignature("mint(uint256)", mintAmount));
502         return abi.decode(data, (uint));
503     }
504 
505     /**
506      * @notice Sender redeems cTokens in exchange for the underlying asset
507      * @dev Accrues interest whether or not the operation succeeds, unless reverted
508      * @param redeemTokens The number of cTokens to redeem into underlying
509      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
510      */
511     function redeem(uint redeemTokens) external returns (uint) {
512         bytes memory data = delegateToImplementation(abi.encodeWithSignature("redeem(uint256)", redeemTokens));
513         return abi.decode(data, (uint));
514     }
515 
516     /**
517      * @notice Sender redeems cTokens in exchange for a specified amount of underlying asset
518      * @dev Accrues interest whether or not the operation succeeds, unless reverted
519      * @param redeemAmount The amount of underlying to redeem
520      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
521      */
522     function redeemUnderlying(uint redeemAmount) external returns (uint) {
523         bytes memory data = delegateToImplementation(abi.encodeWithSignature("redeemUnderlying(uint256)", redeemAmount));
524         return abi.decode(data, (uint));
525     }
526 
527     /**
528       * @notice Sender borrows assets from the protocol to their own address
529       * @param borrowAmount The amount of the underlying asset to borrow
530       * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
531       */
532     function borrow(uint borrowAmount) external returns (uint) {
533         bytes memory data = delegateToImplementation(abi.encodeWithSignature("borrow(uint256)", borrowAmount));
534         return abi.decode(data, (uint));
535     }
536 
537     /**
538      * @notice Sender repays their own borrow
539      * @param repayAmount The amount to repay
540      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
541      */
542     function repayBorrow(uint repayAmount) external returns (uint) {
543         bytes memory data = delegateToImplementation(abi.encodeWithSignature("repayBorrow(uint256)", repayAmount));
544         return abi.decode(data, (uint));
545     }
546 
547     /**
548      * @notice Sender repays a borrow belonging to borrower
549      * @param borrower the account with the debt being payed off
550      * @param repayAmount The amount to repay
551      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
552      */
553     function repayBorrowBehalf(address borrower, uint repayAmount) external returns (uint) {
554         bytes memory data = delegateToImplementation(abi.encodeWithSignature("repayBorrowBehalf(address,uint256)", borrower, repayAmount));
555         return abi.decode(data, (uint));
556     }
557 
558     /**
559      * @notice The sender liquidates the borrowers collateral.
560      *  The collateral seized is transferred to the liquidator.
561      * @param borrower The borrower of this cToken to be liquidated
562      * @param cTokenCollateral The market in which to seize collateral from the borrower
563      * @param repayAmount The amount of the underlying borrowed asset to repay
564      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
565      */
566     function liquidateBorrow(address borrower, uint repayAmount, CTokenInterface cTokenCollateral) external returns (uint) {
567         bytes memory data = delegateToImplementation(abi.encodeWithSignature("liquidateBorrow(address,uint256,address)", borrower, repayAmount, cTokenCollateral));
568         return abi.decode(data, (uint));
569     }
570 
571     /**
572      * @notice Transfer `amount` tokens from `msg.sender` to `dst`
573      * @param dst The address of the destination account
574      * @param amount The number of tokens to transfer
575      * @return Whether or not the transfer succeeded
576      */
577     function transfer(address dst, uint amount) external returns (bool) {
578         bytes memory data = delegateToImplementation(abi.encodeWithSignature("transfer(address,uint256)", dst, amount));
579         return abi.decode(data, (bool));
580     }
581 
582     /**
583      * @notice Transfer `amount` tokens from `src` to `dst`
584      * @param src The address of the source account
585      * @param dst The address of the destination account
586      * @param amount The number of tokens to transfer
587      * @return Whether or not the transfer succeeded
588      */
589     function transferFrom(address src, address dst, uint256 amount) external returns (bool) {
590         bytes memory data = delegateToImplementation(abi.encodeWithSignature("transferFrom(address,address,uint256)", src, dst, amount));
591         return abi.decode(data, (bool));
592     }
593 
594     /**
595      * @notice Approve `spender` to transfer up to `amount` from `src`
596      * @dev This will overwrite the approval amount for `spender`
597      *  and is subject to issues noted [here](https://eips.ethereum.org/EIPS/eip-20#approve)
598      * @param spender The address of the account which may transfer tokens
599      * @param amount The number of tokens that are approved (-1 means infinite)
600      * @return Whether or not the approval succeeded
601      */
602     function approve(address spender, uint256 amount) external returns (bool) {
603         bytes memory data = delegateToImplementation(abi.encodeWithSignature("approve(address,uint256)", spender, amount));
604         return abi.decode(data, (bool));
605     }
606 
607     /**
608      * @notice Get the current allowance from `owner` for `spender`
609      * @param owner The address of the account which owns the tokens to be spent
610      * @param spender The address of the account which may transfer tokens
611      * @return The number of tokens allowed to be spent (-1 means infinite)
612      */
613     function allowance(address owner, address spender) external view returns (uint) {
614         bytes memory data = delegateToViewImplementation(abi.encodeWithSignature("allowance(address,address)", owner, spender));
615         return abi.decode(data, (uint));
616     }
617 
618     /**
619      * @notice Get the token balance of the `owner`
620      * @param owner The address of the account to query
621      * @return The number of tokens owned by `owner`
622      */
623     function balanceOf(address owner) external view returns (uint) {
624         bytes memory data = delegateToViewImplementation(abi.encodeWithSignature("balanceOf(address)", owner));
625         return abi.decode(data, (uint));
626     }
627 
628     /**
629      * @notice Get the underlying balance of the `owner`
630      * @dev This also accrues interest in a transaction
631      * @param owner The address of the account to query
632      * @return The amount of underlying owned by `owner`
633      */
634     function balanceOfUnderlying(address owner) external returns (uint) {
635         bytes memory data = delegateToImplementation(abi.encodeWithSignature("balanceOfUnderlying(address)", owner));
636         return abi.decode(data, (uint));
637     }
638 
639     /**
640      * @notice Get a snapshot of the account's balances, and the cached exchange rate
641      * @dev This is used by comptroller to more efficiently perform liquidity checks.
642      * @param account Address of the account to snapshot
643      * @return (possible error, token balance, borrow balance, exchange rate mantissa)
644      */
645     function getAccountSnapshot(address account) external view returns (uint, uint, uint, uint) {
646         bytes memory data = delegateToViewImplementation(abi.encodeWithSignature("getAccountSnapshot(address)", account));
647         return abi.decode(data, (uint, uint, uint, uint));
648     }
649 
650     /**
651      * @notice Returns the current per-block borrow interest rate for this cToken
652      * @return The borrow interest rate per block, scaled by 1e18
653      */
654     function borrowRatePerBlock() external view returns (uint) {
655         bytes memory data = delegateToViewImplementation(abi.encodeWithSignature("borrowRatePerBlock()"));
656         return abi.decode(data, (uint));
657     }
658 
659     /**
660      * @notice Returns the current per-block supply interest rate for this cToken
661      * @return The supply interest rate per block, scaled by 1e18
662      */
663     function supplyRatePerBlock() external view returns (uint) {
664         bytes memory data = delegateToViewImplementation(abi.encodeWithSignature("supplyRatePerBlock()"));
665         return abi.decode(data, (uint));
666     }
667 
668     /**
669      * @notice Returns the current total borrows plus accrued interest
670      * @return The total borrows with interest
671      */
672     function totalBorrowsCurrent() external returns (uint) {
673         bytes memory data = delegateToImplementation(abi.encodeWithSignature("totalBorrowsCurrent()"));
674         return abi.decode(data, (uint));
675     }
676 
677     /**
678      * @notice Accrue interest to updated borrowIndex and then calculate account's borrow balance using the updated borrowIndex
679      * @param account The address whose balance should be calculated after updating borrowIndex
680      * @return The calculated balance
681      */
682     function borrowBalanceCurrent(address account) external returns (uint) {
683         bytes memory data = delegateToImplementation(abi.encodeWithSignature("borrowBalanceCurrent(address)", account));
684         return abi.decode(data, (uint));
685     }
686 
687     /**
688      * @notice Return the borrow balance of account based on stored data
689      * @param account The address whose balance should be calculated
690      * @return The calculated balance
691      */
692     function borrowBalanceStored(address account) public view returns (uint) {
693         bytes memory data = delegateToViewImplementation(abi.encodeWithSignature("borrowBalanceStored(address)", account));
694         return abi.decode(data, (uint));
695     }
696 
697    /**
698      * @notice Accrue interest then return the up-to-date exchange rate
699      * @return Calculated exchange rate scaled by 1e18
700      */
701     function exchangeRateCurrent() public returns (uint) {
702         bytes memory data = delegateToImplementation(abi.encodeWithSignature("exchangeRateCurrent()"));
703         return abi.decode(data, (uint));
704     }
705 
706     /**
707      * @notice Calculates the exchange rate from the underlying to the CToken
708      * @dev This function does not accrue interest before calculating the exchange rate
709      * @return Calculated exchange rate scaled by 1e18
710      */
711     function exchangeRateStored() public view returns (uint) {
712         bytes memory data = delegateToViewImplementation(abi.encodeWithSignature("exchangeRateStored()"));
713         return abi.decode(data, (uint));
714     }
715 
716     /**
717      * @notice Get cash balance of this cToken in the underlying asset
718      * @return The quantity of underlying asset owned by this contract
719      */
720     function getCash() external view returns (uint) {
721         bytes memory data = delegateToViewImplementation(abi.encodeWithSignature("getCash()"));
722         return abi.decode(data, (uint));
723     }
724 
725     /**
726       * @notice Applies accrued interest to total borrows and reserves.
727       * @dev This calculates interest accrued from the last checkpointed block
728       *      up to the current block and writes new checkpoint to storage.
729       */
730     function accrueInterest() public returns (uint) {
731         bytes memory data = delegateToImplementation(abi.encodeWithSignature("accrueInterest()"));
732         return abi.decode(data, (uint));
733     }
734 
735     /**
736      * @notice Transfers collateral tokens (this market) to the liquidator.
737      * @dev Will fail unless called by another cToken during the process of liquidation.
738      *  Its absolutely critical to use msg.sender as the borrowed cToken and not a parameter.
739      * @param liquidator The account receiving seized collateral
740      * @param borrower The account having collateral seized
741      * @param seizeTokens The number of cTokens to seize
742      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
743      */
744     function seize(address liquidator, address borrower, uint seizeTokens) external returns (uint) {
745         bytes memory data = delegateToImplementation(abi.encodeWithSignature("seize(address,address,uint256)", liquidator, borrower, seizeTokens));
746         return abi.decode(data, (uint));
747     }
748 
749     /*** Admin Functions ***/
750 
751     /**
752       * @notice Begins transfer of admin rights. The newPendingAdmin must call `_acceptAdmin` to finalize the transfer.
753       * @dev Admin function to begin change of admin. The newPendingAdmin must call `_acceptAdmin` to finalize the transfer.
754       * @param newPendingAdmin New pending admin.
755       * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
756       */
757     function _setPendingAdmin(address payable newPendingAdmin) external returns (uint) {
758         bytes memory data = delegateToImplementation(abi.encodeWithSignature("_setPendingAdmin(address)", newPendingAdmin));
759         return abi.decode(data, (uint));
760     }
761 
762     /**
763       * @notice Sets a new comptroller for the market
764       * @dev Admin function to set a new comptroller
765       * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
766       */
767     function _setComptroller(ComptrollerInterface newComptroller) public returns (uint) {
768         bytes memory data = delegateToImplementation(abi.encodeWithSignature("_setComptroller(address)", newComptroller));
769         return abi.decode(data, (uint));
770     }
771 
772     /**
773       * @notice accrues interest and sets a new reserve factor for the protocol using _setReserveFactorFresh
774       * @dev Admin function to accrue interest and set a new reserve factor
775       * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
776       */
777     function _setReserveFactor(uint newReserveFactorMantissa) external returns (uint) {
778         bytes memory data = delegateToImplementation(abi.encodeWithSignature("_setReserveFactor(uint256)", newReserveFactorMantissa));
779         return abi.decode(data, (uint));
780     }
781 
782     /**
783       * @notice Accepts transfer of admin rights. msg.sender must be pendingAdmin
784       * @dev Admin function for pending admin to accept role and update admin
785       * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
786       */
787     function _acceptAdmin() external returns (uint) {
788         bytes memory data = delegateToImplementation(abi.encodeWithSignature("_acceptAdmin()"));
789         return abi.decode(data, (uint));
790     }
791 
792     /**
793      * @notice Accrues interest and adds reserves by transferring from admin
794      * @param addAmount Amount of reserves to add
795      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
796      */
797     function _addReserves(uint addAmount) external returns (uint) {
798         bytes memory data = delegateToImplementation(abi.encodeWithSignature("_addReserves(uint256)", addAmount));
799         return abi.decode(data, (uint));
800     }
801 
802     /**
803      * @notice Accrues interest and reduces reserves by transferring to admin
804      * @param reduceAmount Amount of reduction to reserves
805      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
806      */
807     function _reduceReserves(uint reduceAmount) external returns (uint) {
808         bytes memory data = delegateToImplementation(abi.encodeWithSignature("_reduceReserves(uint256)", reduceAmount));
809         return abi.decode(data, (uint));
810     }
811 
812     /**
813      * @notice Accrues interest and updates the interest rate model using _setInterestRateModelFresh
814      * @dev Admin function to accrue interest and update the interest rate model
815      * @param newInterestRateModel the new interest rate model to use
816      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
817      */
818     function _setInterestRateModel(InterestRateModel newInterestRateModel) public returns (uint) {
819         bytes memory data = delegateToImplementation(abi.encodeWithSignature("_setInterestRateModel(address)", newInterestRateModel));
820         return abi.decode(data, (uint));
821     }
822 
823     /**
824      * @notice Internal method to delegate execution to another contract
825      * @dev It returns to the external caller whatever the implementation returns or forwards reverts
826      * @param callee The contract to delegatecall
827      * @param data The raw data to delegatecall
828      * @return The returned bytes from the delegatecall
829      */
830     function delegateTo(address callee, bytes memory data) internal returns (bytes memory) {
831         (bool success, bytes memory returnData) = callee.delegatecall(data);
832         assembly {
833             if eq(success, 0) {
834                 revert(add(returnData, 0x20), returndatasize)
835             }
836         }
837         return returnData;
838     }
839 
840     /**
841      * @notice Delegates execution to the implementation contract
842      * @dev It returns to the external caller whatever the implementation returns or forwards reverts
843      * @param data The raw data to delegatecall
844      * @return The returned bytes from the delegatecall
845      */
846     function delegateToImplementation(bytes memory data) public returns (bytes memory) {
847         return delegateTo(implementation, data);
848     }
849 
850     /**
851      * @notice Delegates execution to an implementation contract
852      * @dev It returns to the external caller whatever the implementation returns or forwards reverts
853      *  There are an additional 2 prefix uints from the wrapper returndata, which we ignore since we make an extra hop.
854      * @param data The raw data to delegatecall
855      * @return The returned bytes from the delegatecall
856      */
857     function delegateToViewImplementation(bytes memory data) public view returns (bytes memory) {
858         (bool success, bytes memory returnData) = address(this).staticcall(abi.encodeWithSignature("delegateToImplementation(bytes)", data));
859         assembly {
860             if eq(success, 0) {
861                 revert(add(returnData, 0x20), returndatasize)
862             }
863         }
864         return abi.decode(returnData, (bytes));
865     }
866 
867     /**
868      * @notice Delegates execution to an implementation contract
869      * @dev It returns to the external caller whatever the implementation returns or forwards reverts
870      */
871     function () external payable {
872         require(msg.value == 0,"CErc20Delegator:fallback: cannot send value to fallback");
873 
874         // delegate all other functions to current implementation
875         (bool success, ) = implementation.delegatecall(msg.data);
876 
877         assembly {
878             let free_mem_ptr := mload(0x40)
879             returndatacopy(free_mem_ptr, 0, returndatasize)
880 
881             switch success
882             case 0 { revert(free_mem_ptr, returndatasize) }
883             default { return(free_mem_ptr, returndatasize) }
884         }
885     }
886 }
