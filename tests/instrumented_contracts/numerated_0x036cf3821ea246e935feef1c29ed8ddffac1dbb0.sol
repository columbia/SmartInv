1 pragma solidity ^0.5.16;
2 
3 
4 // Modified from compound/ComptrollerInterface
5 contract ComptrollerInterface {
6     /// @notice Indicator that this is a Comptroller contract (for inspection)
7     bool public constant isComptroller = true;
8 
9     /*** Assets You Are In ***/
10 
11     function checkMembership(address account, address cToken) external view returns (bool);
12     function enterMarkets(address[] calldata cTokens) external returns (uint[] memory);
13     function enterMarket(address cToken, address borrower) external returns (uint);
14     function exitMarket(address cToken) external returns (uint);
15     function getAccountAssets(address account) external view returns (address[] memory);
16 
17     /*** Policy Hooks ***/
18 
19     function mintAllowed(address cToken, address minter, uint mintAmount) external returns (uint);
20     function mintVerify(address cToken, address minter, uint mintAmount, uint mintTokens) external;
21 
22     function redeemAllowed(address cToken, address redeemer, uint redeemTokens) external returns (uint);
23     function redeemVerify(address cToken, address redeemer, uint redeemAmount, uint redeemTokens) external;
24 
25     function borrowAllowed(address cToken, address borrower, uint borrowAmount) external returns (uint);
26     function borrowVerify(address cToken, address borrower, uint borrowAmount) external;
27 
28     function repayBorrowAllowed(
29         address cToken,
30         address payer,
31         address borrower,
32         uint repayAmount) external returns (uint);
33     function repayBorrowVerify(
34         address cToken,
35         address payer,
36         address borrower,
37         uint repayAmount,
38         uint borrowerIndex) external;
39 
40     function liquidateBorrowAllowed(
41         address cTokenBorrowed,
42         address cTokenCollateral,
43         address liquidator,
44         address borrower,
45         uint repayAmount) external returns (uint);
46     function liquidateBorrowVerify(
47         address cTokenBorrowed,
48         address cTokenCollateral,
49         address liquidator,
50         address borrower,
51         uint repayAmount,
52         uint seizeTokens) external;
53 
54     function seizeAllowed(
55         address cTokenCollateral,
56         address cTokenBorrowed,
57         address liquidator,
58         address borrower,
59         uint seizeTokens) external returns (uint);
60     function seizeVerify(
61         address cTokenCollateral,
62         address cTokenBorrowed,
63         address liquidator,
64         address borrower,
65         uint seizeTokens) external;
66 
67     function transferAllowed(address cToken, address src, address dst, uint transferTokens) external returns (uint);
68     function transferVerify(address cToken, address src, address dst, uint transferTokens) external;
69 
70     /*** Liquidity/Liquidation Calculations ***/
71 
72     function liquidateCalculateSeizeTokens(
73         address cTokenBorrowed,
74         address cTokenCollateral,
75         uint repayAmount) external view returns (uint, uint);
76 }
77 
78 // Copied from compound/InterestRateModel
79 /**
80   * @title DeFilend's InterestRateModel Interface
81   * @author DeFil
82   */
83 contract InterestRateModel {
84     /// @notice Indicator that this is an InterestRateModel contract (for inspection)
85     bool public constant isInterestRateModel = true;
86 
87     /**
88       * @notice Calculates the current borrow interest rate per block
89       * @param cash The total amount of cash the market has
90       * @param borrows The total amount of borrows the market has outstanding
91       * @param reserves The total amnount of reserves the market has
92       * @return The borrow rate per block (as a percentage, and scaled by 1e18)
93       */
94     function getBorrowRate(uint cash, uint borrows, uint reserves) external view returns (uint);
95 
96     /**
97       * @notice Calculates the current supply interest rate per block
98       * @param cash The total amount of cash the market has
99       * @param borrows The total amount of borrows the market has outstanding
100       * @param reserves The total amnount of reserves the market has
101       * @param reserveFactorMantissa The current reserve factor the market has
102       * @return The supply rate per block (as a percentage, and scaled by 1e18)
103       */
104     function getSupplyRate(uint cash, uint borrows, uint reserves, uint reserveFactorMantissa) external view returns (uint);
105 
106 }
107 
108 // Modified from compound/CTokenInterfaces
109 contract CTokenStorage {
110     /**
111      * @dev Guard variable for re-entrancy checks
112      */
113     bool internal _notEntered;
114 
115     /**
116      * @notice EIP-20 token name for this token
117      */
118     string public name;
119 
120     /**
121      * @notice EIP-20 token symbol for this token
122      */
123     string public symbol;
124 
125     /**
126      * @notice EIP-20 token decimals for this token
127      */
128     uint8 public decimals;
129 
130     /**
131      * @notice Maximum borrow rate that can ever be applied (.0005% / block)
132      */
133 
134     // uint internal constant borrowRateMaxMantissa = 0.0005e16;
135 
136     /**
137      * @notice Maximum fraction of interest that can be set aside for reserves
138      */
139     uint internal constant reserveFactorMaxMantissa = 1e18;
140 
141     /**
142      * @notice Administrator for this contract
143      */
144     address public admin;
145 
146     /**
147      * @notice Pending administrator for this contract
148      */
149     address public pendingAdmin;
150 
151     /**
152      * @notice Contract which oversees inter-cToken operations
153      */
154     ComptrollerInterface public comptroller;
155 
156     /**
157      * @notice Model which tells what the current interest rate should be
158      */
159     InterestRateModel public interestRateModel;
160 
161     /**
162      * @notice Initial exchange rate used when minting the first CTokens (used when totalSupply = 0)
163      */
164     uint internal initialExchangeRateMantissa;
165 
166     /**
167      * @notice Fraction of interest currently set aside for reserves
168      */
169     uint public reserveFactorMantissa;
170 
171     /**
172      * @notice Block number that interest was last accrued at
173      */
174     uint public accrualBlockNumber;
175 
176     /**
177      * @notice Accumulator of the total earned interest rate since the opening of the market
178      */
179     uint public borrowIndex;
180 
181     /**
182      * @notice Total amount of outstanding borrows of the underlying in this market
183      */
184     uint public totalBorrows;
185 
186     /**
187      * @notice Total amount of reserves of the underlying held in this market
188      */
189     uint public totalReserves;
190 
191     /**
192      * @notice The keeper of the reserve
193      */
194     address public reserveKeeper;
195 
196     /**
197      * @notice The accrued reserves of each reserveKeeper in history
198      */
199     mapping (address => uint) public historicalReserveKeeperAccrued;
200 
201     /**
202      * @notice Total number of tokens in circulation
203      */
204     uint public totalSupply;
205 
206     /**
207      * @notice Official record of token balances for each account
208      */
209     mapping (address => uint) internal accountTokens;
210 
211     /**
212      * @notice Approved token transfer amounts on behalf of others
213      */
214     mapping (address => mapping (address => uint)) internal transferAllowances;
215 
216     /**
217      * @notice Container for borrow balance information
218      * @member principal Total balance (with accrued interest), after applying the most recent balance-changing action
219      * @member interestIndex Global borrowIndex as of the most recent balance-changing action
220      */
221     struct BorrowSnapshot {
222         uint principal;
223         uint interestIndex;
224     }
225 
226     /**
227      * @notice Mapping of account addresses to outstanding borrow balances
228      */
229     mapping(address => BorrowSnapshot) internal accountBorrows;
230 }
231 
232 contract CTokenInterface is CTokenStorage {
233     /**
234      * @notice Indicator that this is a CToken contract (for inspection)
235      */
236     bool public constant isCToken = true;
237 
238 
239     /*** Market Events ***/
240 
241     /**
242      * @notice Event emitted when interest is accrued
243      */
244     event AccrueInterest(uint cashPrior, uint interestAccumulated, uint borrowIndex, uint totalBorrows);
245 
246     /**
247      * @notice Event emitted when tokens are minted
248      */
249     event Mint(address minter, uint mintAmount, uint mintTokens);
250 
251     /**
252      * @notice Event emitted when tokens are redeemed
253      */
254     event Redeem(address redeemer, uint redeemAmount, uint redeemTokens);
255 
256     /**
257      * @notice Event emitted when underlying is borrowed
258      */
259     event Borrow(address borrower, uint borrowAmount, uint accountBorrows, uint totalBorrows);
260 
261     /**
262      * @notice Event emitted when a borrow is repaid
263      */
264     event RepayBorrow(address payer, address borrower, uint repayAmount, uint accountBorrows, uint totalBorrows);
265 
266     /**
267      * @notice Event emitted when a borrow is liquidated
268      */
269     event LiquidateBorrow(address liquidator, address borrower, uint repayAmount, address cTokenCollateral, uint seizeTokens);
270 
271 
272     /*** Admin Events ***/
273 
274     /**
275      * @notice Event emitted when pendingAdmin is changed
276      */
277     event NewPendingAdmin(address oldPendingAdmin, address newPendingAdmin);
278 
279     /**
280      * @notice Event emitted when pendingAdmin is accepted, which means admin is updated
281      */
282     event NewAdmin(address oldAdmin, address newAdmin);
283 
284     /**
285      * @notice Event emitted when comptroller is changed
286      */
287     event NewComptroller(ComptrollerInterface oldComptroller, ComptrollerInterface newComptroller);
288 
289     /**
290      * @notice Event emitted when interestRateModel is changed
291      */
292     event NewMarketInterestRateModel(InterestRateModel oldInterestRateModel, InterestRateModel newInterestRateModel);
293 
294     /**
295      * @notice Event emitted when the reserve factor is changed
296      */
297     event NewReserveFactor(uint oldReserveFactorMantissa, uint newReserveFactorMantissa);
298 
299     /**
300      * @notice Event emitted when the reserve keeper is changed
301      */
302     event NewReserveKeeper(address oldReserveKeeper, address newReserveKeeper);
303 
304     /**
305      * @notice Event emitted when the reserves are added
306      */
307     event ReservesAdded(address benefactor, uint addAmount, uint newTotalReserves);
308 
309     /**
310      * @notice Event emitted when the reserves are reduced
311      */
312     event ReservesReduced(address keeper, address receiver, uint reduceAmount, uint newTotalReserves);
313 
314     /**
315      * @notice EIP20 Transfer event
316      */
317     event Transfer(address indexed from, address indexed to, uint amount);
318 
319     /**
320      * @notice EIP20 Approval event
321      */
322     event Approval(address indexed owner, address indexed spender, uint amount);
323 
324     /**
325      * @notice Failure event
326      */
327     event Failure(uint error, uint info, uint detail);
328 
329 
330     /*** User Interface ***/
331 
332     function transfer(address dst, uint amount) external returns (bool);
333     function transferFrom(address src, address dst, uint amount) external returns (bool);
334     function approve(address spender, uint amount) external returns (bool);
335     function allowance(address owner, address spender) external view returns (uint);
336     function balanceOf(address owner) external view returns (uint);
337     function balanceOfUnderlying(address owner) external returns (uint);
338     function getAccountSnapshot(address account) external view returns (uint, uint, uint, uint);
339     function borrowRatePerBlock() external view returns (uint);
340     function supplyRatePerBlock() external view returns (uint);
341     function totalBorrowsCurrent() external returns (uint);
342     function borrowBalanceCurrent(address account) external returns (uint);
343     function borrowBalanceStored(address account) public view returns (uint);
344     function exchangeRateCurrent() public returns (uint);
345     function exchangeRateStored() public view returns (uint);
346     function getCash() external view returns (uint);
347     function accrueInterest() public returns (uint);
348     function seize(address liquidator, address borrower, uint seizeTokens) external returns (uint);
349 
350 
351     /*** Admin Functions ***/
352 
353     function _setPendingAdmin(address newPendingAdmin) external returns (uint);
354     function _acceptAdmin() external returns (uint);
355     function _setComptroller(ComptrollerInterface newComptroller) public returns (uint);
356     function _setReserveFactor(uint newReserveFactorMantissa) external returns (uint);
357     function _setReserveKeeper(address newReserveKeeper) external returns (uint);
358     function _setInterestRateModel(InterestRateModel newInterestRateModel) public returns (uint);
359 }
360 
361 contract CErc20Storage {
362     /**
363      * @notice Underlying asset for this CToken
364      */
365     address public underlying;
366 }
367 
368 contract CErc20Interface is CErc20Storage {
369 
370     /*** User Interface ***/
371 
372     function mint(uint mintAmount) external returns (uint);
373     function redeem(uint redeemTokens) external returns (uint);
374     function redeemUnderlying(uint redeemAmount) external returns (uint);
375     function borrow(uint borrowAmount) external returns (uint);
376     function repayBorrow(uint repayAmount) external returns (uint);
377     function repayBorrowBehalf(address borrower, uint repayAmount) external returns (uint);
378     function liquidateBorrow(address borrower, uint repayAmount, CTokenInterface cTokenCollateral) external returns (uint);
379 
380 
381     /*** Admin Functions ***/
382 
383     function _addReserves(uint addAmount) external returns (uint);
384 }
385 
386 contract CDelegationStorage {
387     /**
388      * @notice Implementation address for this contract
389      */
390     address public implementation;
391 }
392 
393 contract CDelegatorInterface is CDelegationStorage {
394     /**
395      * @notice Emitted when implementation is changed
396      */
397     event NewImplementation(address oldImplementation, address newImplementation);
398 
399     /**
400      * @notice Called by the admin to update the implementation of the delegator
401      * @param implementation_ The address of the new implementation for delegation
402      * @param allowResign Flag to indicate whether to call _resignImplementation on the old implementation
403      * @param becomeImplementationData The encoded bytes data to be passed to _becomeImplementation
404      */
405     function _setImplementation(address implementation_, bool allowResign, bytes memory becomeImplementationData) public;
406 }
407 
408 contract CDelegateInterface is CDelegationStorage {
409     /**
410      * @notice Called by the delegator on a delegate to initialize it for duty
411      * @dev Should revert if any issues arise which make it unfit for delegation
412      * @param data The encoded bytes data for any initialization
413      */
414     function _becomeImplementation(bytes memory data) public;
415 
416     /**
417      * @notice Called by the delegator on a delegate to forfeit its responsibility
418      */
419     function _resignImplementation() public;
420 }
421 
422 // Modified from compound/CErc20Delegator
423 /**
424  * @title DeFilend's CErc20Delegator Contract
425  * @notice CTokens which wrap an EIP-20 underlying and delegate to an implementation
426  * @author DeFil
427  */
428 contract CErc20Delegator is CTokenInterface, CErc20Interface, CDelegatorInterface {
429     /**
430      * @notice Construct a new money market
431      * @param underlying_ The address of the underlying asset
432      * @param comptroller_ The address of the Comptroller
433      * @param interestRateModel_ The address of the interest rate model
434      * @param initialExchangeRateMantissa_ The initial exchange rate, scaled by 1e18
435      * @param name_ ERC-20 name of this token
436      * @param symbol_ ERC-20 symbol of this token
437      * @param decimals_ ERC-20 decimal precision of this token
438      * @param admin_ Address of the administrator of this token
439      * @param implementation_ The address of the implementation the contract delegates to
440      * @param becomeImplementationData The encoded args for becomeImplementation
441      */
442     constructor(address underlying_,
443                 ComptrollerInterface comptroller_,
444                 InterestRateModel interestRateModel_,
445                 uint initialExchangeRateMantissa_,
446                 string memory name_,
447                 string memory symbol_,
448                 uint8 decimals_,
449                 address admin_,
450                 address implementation_,
451                 bytes memory becomeImplementationData) public {
452         // Creator of the contract is admin during initialization
453         admin = msg.sender;
454 
455         // First delegate gets to initialize the delegator (i.e. storage contract)
456         delegateTo(implementation_, abi.encodeWithSignature("initialize(address,address,address,uint256,string,string,uint8)",
457                                                             underlying_,
458                                                             comptroller_,
459                                                             interestRateModel_,
460                                                             initialExchangeRateMantissa_,
461                                                             name_,
462                                                             symbol_,
463                                                             decimals_));
464 
465         // New implementations always get set via the settor (post-initialize)
466         _setImplementation(implementation_, false, becomeImplementationData);
467 
468         // Set the proper admin now that initialization is done
469         admin = admin_;
470     }
471 
472     /**
473      * @notice Called by the admin to update the implementation of the delegator
474      * @param implementation_ The address of the new implementation for delegation
475      * @param allowResign Flag to indicate whether to call _resignImplementation on the old implementation
476      * @param becomeImplementationData The encoded bytes data to be passed to _becomeImplementation
477      */
478     function _setImplementation(address implementation_, bool allowResign, bytes memory becomeImplementationData) public {
479         require(msg.sender == admin, "CErc20Delegator::_setImplementation: Caller must be admin");
480 
481         if (allowResign) {
482             delegateToImplementation(abi.encodeWithSignature("_resignImplementation()"));
483         }
484 
485         address oldImplementation = implementation;
486         implementation = implementation_;
487 
488         delegateToImplementation(abi.encodeWithSignature("_becomeImplementation(bytes)", becomeImplementationData));
489 
490         emit NewImplementation(oldImplementation, implementation);
491     }
492 
493     /**
494      * @notice Sender supplies assets into the market and receives cTokens in exchange
495      * @dev Accrues interest whether or not the operation succeeds, unless reverted
496      * @param mintAmount The amount of the underlying asset to supply
497      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
498      */
499     function mint(uint mintAmount) external returns (uint) {
500         mintAmount; // Shh
501         delegateAndReturn();
502     }
503 
504     /**
505      * @notice Sender redeems cTokens in exchange for the underlying asset
506      * @dev Accrues interest whether or not the operation succeeds, unless reverted
507      * @param redeemTokens The number of cTokens to redeem into underlying
508      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
509      */
510     function redeem(uint redeemTokens) external returns (uint) {
511         redeemTokens; // Shh
512         delegateAndReturn();
513     }
514 
515     /**
516      * @notice Sender redeems cTokens in exchange for a specified amount of underlying asset
517      * @dev Accrues interest whether or not the operation succeeds, unless reverted
518      * @param redeemAmount The amount of underlying to redeem
519      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
520      */
521     function redeemUnderlying(uint redeemAmount) external returns (uint) {
522         redeemAmount; // Shh
523         delegateAndReturn();
524     }
525 
526     /**
527       * @notice Sender borrows assets from the protocol to their own address
528       * @param borrowAmount The amount of the underlying asset to borrow
529       * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
530       */
531     function borrow(uint borrowAmount) external returns (uint) {
532         borrowAmount; // Shh
533         delegateAndReturn();
534     }
535 
536     /**
537      * @notice Sender repays their own borrow
538      * @param repayAmount The amount to repay
539      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
540      */
541     function repayBorrow(uint repayAmount) external returns (uint) {
542         repayAmount; // Shh
543         delegateAndReturn();
544     }
545 
546     /**
547      * @notice Sender repays a borrow belonging to borrower
548      * @param borrower the account with the debt being payed off
549      * @param repayAmount The amount to repay
550      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
551      */
552     function repayBorrowBehalf(address borrower, uint repayAmount) external returns (uint) {
553         borrower; repayAmount; // Shh
554         delegateAndReturn();
555     }
556 
557     /**
558      * @notice The sender liquidates the borrowers collateral.
559      *  The collateral seized is transferred to the liquidator.
560      * @param borrower The borrower of this cToken to be liquidated
561      * @param cTokenCollateral The market in which to seize collateral from the borrower
562      * @param repayAmount The amount of the underlying borrowed asset to repay
563      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
564      */
565     function liquidateBorrow(address borrower, uint repayAmount, CTokenInterface cTokenCollateral) external returns (uint) {
566         borrower; repayAmount; cTokenCollateral; // Shh
567         delegateAndReturn();
568     }
569 
570     /**
571      * @notice Transfer `amount` tokens from `msg.sender` to `dst`
572      * @param dst The address of the destination account
573      * @param amount The number of tokens to transfer
574      * @return Whether or not the transfer succeeded
575      */
576     function transfer(address dst, uint amount) external returns (bool) {
577         dst; amount; // Shh
578         delegateAndReturn();
579     }
580 
581     /**
582      * @notice Transfer `amount` tokens from `src` to `dst`
583      * @param src The address of the source account
584      * @param dst The address of the destination account
585      * @param amount The number of tokens to transfer
586      * @return Whether or not the transfer succeeded
587      */
588     function transferFrom(address src, address dst, uint256 amount) external returns (bool) {
589         src; dst; amount; // Shh
590         delegateAndReturn();
591     }
592 
593     /**
594      * @notice Approve `spender` to transfer up to `amount` from `src`
595      * @dev This will overwrite the approval amount for `spender`
596      *  and is subject to issues noted [here](https://eips.ethereum.org/EIPS/eip-20#approve)
597      * @param spender The address of the account which may transfer tokens
598      * @param amount The number of tokens that are approved (-1 means infinite)
599      * @return Whether or not the approval succeeded
600      */
601     function approve(address spender, uint256 amount) external returns (bool) {
602         spender; amount; // Shh
603         delegateAndReturn();
604     }
605 
606     /**
607      * @notice Get the current allowance from `owner` for `spender`
608      * @param owner The address of the account which owns the tokens to be spent
609      * @param spender The address of the account which may transfer tokens
610      * @return The number of tokens allowed to be spent (-1 means infinite)
611      */
612     function allowance(address owner, address spender) external view returns (uint) {
613         owner; spender; // Shh
614         delegateToViewAndReturn();
615     }
616 
617     /**
618      * @notice Get the token balance of the `owner`
619      * @param owner The address of the account to query
620      * @return The number of tokens owned by `owner`
621      */
622     function balanceOf(address owner) external view returns (uint) {
623         owner; // Shh
624         delegateToViewAndReturn();
625     }
626 
627     /**
628      * @notice Get the underlying balance of the `owner`
629      * @dev This also accrues interest in a transaction
630      * @param owner The address of the account to query
631      * @return The amount of underlying owned by `owner`
632      */
633     function balanceOfUnderlying(address owner) external returns (uint) {
634         owner; // Shh
635         delegateAndReturn();
636     }
637 
638     /**
639      * @notice Get a snapshot of the account's balances, and the cached exchange rate
640      * @dev This is used by comptroller to more efficiently perform liquidity checks.
641      * @param account Address of the account to snapshot
642      * @return (possible error, token balance, borrow balance, exchange rate mantissa)
643      */
644     function getAccountSnapshot(address account) external view returns (uint, uint, uint, uint) {
645         account; // Shh
646         delegateToViewAndReturn();
647     }
648 
649     /**
650      * @notice Returns the current per-block borrow interest rate for this cToken
651      * @return The borrow interest rate per block, scaled by 1e18
652      */
653     function borrowRatePerBlock() external view returns (uint) {
654         delegateToViewAndReturn();
655     }
656 
657     /**
658      * @notice Returns the current per-block supply interest rate for this cToken
659      * @return The supply interest rate per block, scaled by 1e18
660      */
661     function supplyRatePerBlock() external view returns (uint) {
662         delegateToViewAndReturn();
663     }
664 
665     /**
666      * @notice Returns the current total borrows plus accrued interest
667      * @return The total borrows with interest
668      */
669     function totalBorrowsCurrent() external returns (uint) {
670         delegateAndReturn();
671     }
672 
673     /**
674      * @notice Accrue interest to updated borrowIndex and then calculate account's borrow balance using the updated borrowIndex
675      * @param account The address whose balance should be calculated after updating borrowIndex
676      * @return The calculated balance
677      */
678     function borrowBalanceCurrent(address account) external returns (uint) {
679         account; // Shh
680         delegateAndReturn();
681     }
682 
683     /**
684      * @notice Return the borrow balance of account based on stored data
685      * @param account The address whose balance should be calculated
686      * @return The calculated balance
687      */
688     function borrowBalanceStored(address account) public view returns (uint) {
689         account; // Shh
690         delegateToViewAndReturn();
691     }
692 
693    /**
694      * @notice Accrue interest then return the up-to-date exchange rate
695      * @return Calculated exchange rate scaled by 1e18
696      */
697     function exchangeRateCurrent() public returns (uint) {
698         delegateAndReturn();
699     }
700 
701     /**
702      * @notice Calculates the exchange rate from the underlying to the CToken
703      * @dev This function does not accrue interest before calculating the exchange rate
704      * @return Calculated exchange rate scaled by 1e18
705      */
706     function exchangeRateStored() public view returns (uint) {
707         delegateToViewAndReturn();
708     }
709 
710     /**
711      * @notice Get cash balance of this cToken in the underlying asset
712      * @return The quantity of underlying asset owned by this contract
713      */
714     function getCash() external view returns (uint) {
715         delegateToViewAndReturn();
716     }
717 
718     /**
719       * @notice Applies accrued interest to total borrows and reserves.
720       * @dev This calculates interest accrued from the last checkpointed block
721       *      up to the current block and writes new checkpoint to storage.
722       */
723     function accrueInterest() public returns (uint) {
724         delegateAndReturn();
725     }
726 
727     /**
728      * @notice Transfers collateral tokens (this market) to the liquidator.
729      * @dev Will fail unless called by another cToken during the process of liquidation.
730      *  Its absolutely critical to use msg.sender as the borrowed cToken and not a parameter.
731      * @param liquidator The account receiving seized collateral
732      * @param borrower The account having collateral seized
733      * @param seizeTokens The number of cTokens to seize
734      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
735      */
736     function seize(address liquidator, address borrower, uint seizeTokens) external returns (uint) {
737         liquidator; borrower; seizeTokens; // Shh
738         delegateAndReturn();
739     }
740 
741     /*** Admin Functions ***/
742 
743     /**
744       * @notice Begins transfer of admin rights. The newPendingAdmin must call `_acceptAdmin` to finalize the transfer.
745       * @dev Admin function to begin change of admin. The newPendingAdmin must call `_acceptAdmin` to finalize the transfer.
746       * @param newPendingAdmin New pending admin.
747       * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
748       */
749     function _setPendingAdmin(address newPendingAdmin) external returns (uint) {
750         newPendingAdmin; // Shh
751         delegateAndReturn();
752     }
753 
754     /**
755       * @notice Sets a new comptroller for the market
756       * @dev Admin function to set a new comptroller
757       * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
758       */
759     function _setComptroller(ComptrollerInterface newComptroller) public returns (uint) {
760         newComptroller; // Shh
761         delegateAndReturn();
762     }
763 
764     /**
765       * @notice accrues interest and sets a new reserve factor for the protocol using _setReserveFactorFresh
766       * @dev Admin function to accrue interest and set a new reserve factor
767       * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
768       */
769     function _setReserveFactor(uint newReserveFactorMantissa) external returns (uint) {
770         newReserveFactorMantissa; // Shh
771         delegateAndReturn();
772     }
773 
774     /**
775       * @notice Set reserves keeper
776       * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
777       */
778     function _setReserveKeeper(address newReserveKeeper) external returns (uint) {
779         newReserveKeeper; // Shh
780         delegateAndReturn();
781     }
782 
783     /**
784       * @notice Accepts transfer of admin rights. msg.sender must be pendingAdmin
785       * @dev Admin function for pending admin to accept role and update admin
786       * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
787       */
788     function _acceptAdmin() external returns (uint) {
789         delegateAndReturn();
790     }
791 
792     /**
793      * @notice Accrues interest and adds reserves by transferring from admin
794      * @param addAmount Amount of reserves to add
795      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
796      */
797     function _addReserves(uint addAmount) external returns (uint) {
798         addAmount; // Shh
799         delegateAndReturn();
800     }
801 
802     /**
803      * @notice Accrues interest and reduces reserves by transferring to receiver
804      * @param receiver Address to receive
805      * @param reduceAmount Amount of reduction to reserves
806      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
807      */
808     function _reduceReserves(address receiver, uint reduceAmount) external returns (uint) {
809         receiver; // Shh
810         reduceAmount; // Shh
811         delegateAndReturn();
812     }
813 
814     /**
815      * @notice Accrues interest and updates the interest rate model using _setInterestRateModelFresh
816      * @dev Admin function to accrue interest and update the interest rate model
817      * @param newInterestRateModel the new interest rate model to use
818      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
819      */
820     function _setInterestRateModel(InterestRateModel newInterestRateModel) public returns (uint) {
821         newInterestRateModel; // Shh
822         delegateAndReturn();
823     }
824 
825     /*** Distributor begin ***/
826     function asset() external view returns (address) {
827         delegateToViewAndReturn();
828     }
829 
830     function accruedStored(address account) external view returns (uint) {
831         account;
832         delegateToViewAndReturn();
833     }
834 
835     function accrue() external returns (uint) {
836         delegateAndReturn();
837     }
838 
839     function claim(address receiver, uint amount) external returns (uint) {
840         receiver;
841         amount;
842         delegateAndReturn();
843     }
844     /*** Distributor end ***/
845 
846     /**
847      * @notice Internal method to delegate execution to another contract
848      * @dev It returns to the external caller whatever the implementation returns or forwards reverts
849      * @param callee The contract to delegatecall
850      * @param data The raw data to delegatecall
851      * @return The returned bytes from the delegatecall
852      */
853     function delegateTo(address callee, bytes memory data) internal returns (bytes memory) {
854         (bool success, bytes memory returnData) = callee.delegatecall(data);
855         assembly {
856             if eq(success, 0) {
857                 revert(add(returnData, 0x20), returndatasize)
858             }
859         }
860         return returnData;
861     }
862 
863     /**
864      * @notice Delegates execution to the implementation contract
865      * @dev It returns to the external caller whatever the implementation returns or forwards reverts
866      * @param data The raw data to delegatecall
867      * @return The returned bytes from the delegatecall
868      */
869     function delegateToImplementation(bytes memory data) public returns (bytes memory) {
870         return delegateTo(implementation, data);
871     }
872 
873     /**
874      * @notice Delegates execution to an implementation contract
875      * @dev It returns to the external caller whatever the implementation returns or forwards reverts
876      *  There are an additional 2 prefix uints from the wrapper returndata, which we ignore since we make an extra hop.
877      * @param data The raw data to delegatecall
878      * @return The returned bytes from the delegatecall
879      */
880     function delegateToViewImplementation(bytes memory data) public view returns (bytes memory) {
881         (bool success, bytes memory returnData) = address(this).staticcall(abi.encodeWithSignature("delegateToImplementation(bytes)", data));
882         assembly {
883             if eq(success, 0) {
884                 revert(add(returnData, 0x20), returndatasize)
885             }
886         }
887         return abi.decode(returnData, (bytes));
888     }
889 
890     function delegateToViewAndReturn() private view returns (bytes memory) {
891         (bool success, ) = address(this).staticcall(abi.encodeWithSignature("delegateToImplementation(bytes)", msg.data));
892 
893         assembly {
894             let free_mem_ptr := mload(0x40)
895             returndatacopy(free_mem_ptr, 0, returndatasize)
896 
897             switch success
898             case 0 { revert(free_mem_ptr, returndatasize) }
899             default { return(add(free_mem_ptr, 0x40), returndatasize) }
900         }
901     }
902 
903     function delegateAndReturn() private returns (bytes memory) {
904         (bool success, ) = implementation.delegatecall(msg.data);
905 
906         assembly {
907             let free_mem_ptr := mload(0x40)
908             returndatacopy(free_mem_ptr, 0, returndatasize)
909 
910             switch success
911             case 0 { revert(free_mem_ptr, returndatasize) }
912             default { return(free_mem_ptr, returndatasize) }
913         }
914     }
915 
916     /**
917      * @notice Delegates execution to an implementation contract
918      * @dev It returns to the external caller whatever the implementation returns or forwards reverts
919      */
920     function () external payable {
921         require(msg.value == 0,"CErc20Delegator:fallback: cannot send value to fallback");
922 
923         // delegate all other functions to current implementation
924         delegateAndReturn();
925     }
926 }