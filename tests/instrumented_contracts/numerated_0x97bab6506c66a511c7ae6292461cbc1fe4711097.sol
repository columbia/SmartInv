1 // File: contracts/ComptrollerInterface.sol
2 
3 pragma solidity 0.5.17;
4 
5 contract ComptrollerInterface {
6     /// @notice Indicator that this is a Comptroller contract (for inspection)
7     bool public constant isComptroller = true;
8 
9     /*** Assets You Are In ***/
10 
11     function enterMarkets(address[] calldata cTokens) external returns (uint[] memory);
12     function exitMarket(address cToken) external returns (uint);
13 
14     /*** Policy Hooks ***/
15 
16     function mintAllowed(address cToken, address minter, uint mintAmount) external returns (uint);
17     function mintVerify(address cToken, address minter, uint mintAmount, uint mintTokens) external;
18 
19     function redeemAllowed(address cToken, address redeemer, uint redeemTokens) external returns (uint);
20     function redeemVerify(address cToken, address redeemer, uint redeemAmount, uint redeemTokens) external;
21 
22     function borrowAllowed(address cToken, address borrower, uint borrowAmount) external returns (uint);
23     function borrowVerify(address cToken, address borrower, uint borrowAmount) external;
24 
25     function repayBorrowAllowed(
26         address cToken,
27         address payer,
28         address borrower,
29         uint repayAmount) external returns (uint);
30     function repayBorrowVerify(
31         address cToken,
32         address payer,
33         address borrower,
34         uint repayAmount,
35         uint borrowerIndex) external;
36 
37     function liquidateBorrowAllowed(
38         address cTokenBorrowed,
39         address cTokenCollateral,
40         address liquidator,
41         address borrower,
42         uint repayAmount) external returns (uint);
43     function liquidateBorrowVerify(
44         address cTokenBorrowed,
45         address cTokenCollateral,
46         address liquidator,
47         address borrower,
48         uint repayAmount,
49         uint seizeTokens) external;
50 
51     function seizeAllowed(
52         address cTokenCollateral,
53         address cTokenBorrowed,
54         address liquidator,
55         address borrower,
56         uint seizeTokens) external returns (uint);
57     function seizeVerify(
58         address cTokenCollateral,
59         address cTokenBorrowed,
60         address liquidator,
61         address borrower,
62         uint seizeTokens) external;
63 
64     function transferAllowed(address cToken, address src, address dst, uint transferTokens) external returns (uint);
65     function transferVerify(address cToken, address src, address dst, uint transferTokens) external;
66 
67     /*** Liquidity/Liquidation Calculations ***/
68 
69     function liquidateCalculateSeizeTokens(
70         address cTokenBorrowed,
71         address cTokenCollateral,
72         uint repayAmount) external view returns (uint, uint);
73 }
74 
75 // File: contracts/InterestRateModel.sol
76 
77 pragma solidity 0.5.17;
78 
79 /**
80   * @title  InterestRateModel Interface
81   */
82 contract InterestRateModel {
83     /// @notice Indicator that this is an InterestRateModel contract (for inspection)
84     bool public constant isInterestRateModel = true;
85 
86     /**
87       * @notice Calculates the current borrow interest rate per block
88       * @param cash The total amount of cash the market has
89       * @param borrows The total amount of borrows the market has outstanding
90       * @param reserves The total amnount of reserves the market has
91       * @return The borrow rate per block (as a percentage, and scaled by 1e18)
92       */
93     function getBorrowRate(uint cash, uint borrows, uint reserves) external view returns (uint);
94 
95     /**
96       * @notice Calculates the current supply interest rate per block
97       * @param cash The total amount of cash the market has
98       * @param borrows The total amount of borrows the market has outstanding
99       * @param reserves The total amnount of reserves the market has
100       * @param reserveFactorMantissa The current reserve factor the market has
101       * @return The supply rate per block (as a percentage, and scaled by 1e18)
102       */
103     function getSupplyRate(uint cash, uint borrows, uint reserves, uint reserveFactorMantissa) external view returns (uint);
104 
105 }
106 
107 // File: contracts/GTokenInterfaces.sol
108 
109 pragma solidity 0.5.17;
110 
111 
112 
113 contract GTokenStorage {
114     /**
115      * @dev Guard variable for re-entrancy checks
116      */
117     bool internal _notEntered;
118 
119     /**
120      * @notice EIP-20 token name for this token
121      */
122     string public name;
123 
124     /**
125      * @notice EIP-20 token symbol for this token
126      */
127     string public symbol;
128 
129     /**
130      * @notice EIP-20 token decimals for this token
131      */
132     uint8 public decimals;
133 
134     /**
135      * @notice Maximum borrow rate that can ever be applied (.0005% / block)
136      */
137 
138     uint internal constant borrowRateMaxMantissa = 0.0005e16;
139 
140     /**
141      * @notice Maximum fraction of interest that can be set aside for reserves
142      */
143     uint internal constant reserveFactorMaxMantissa = 1e18;
144 
145     /**
146      * @notice Administrator for this contract
147      */
148     address payable public admin;
149 
150     /**
151      * @notice Pending administrator for this contract
152      */
153     address payable public pendingAdmin;
154 
155     /**
156      * @notice Contract which oversees inter-gToken operations
157      */
158     ComptrollerInterface public comptroller;
159 
160     /**
161      * @notice Model which tells what the current interest rate should be
162      */
163     InterestRateModel public interestRateModel;
164 
165     /**
166      * @notice Initial exchange rate used when minting the first CTokens (used when totalSupply = 0)
167      */
168     uint internal initialExchangeRateMantissa;
169 
170     /**
171      * @notice Fraction of interest currently set aside for reserves
172      */
173     uint public reserveFactorMantissa;
174 
175     /**
176      * @notice Block number that interest was last accrued at
177      */
178     uint public accrualBlockNumber;
179 
180     /**
181      * @notice Accumulator of the total earned interest rate since the opening of the market
182      */
183     uint public borrowIndex;
184 
185     /**
186      * @notice Total amount of outstanding borrows of the underlying in this market
187      */
188     uint public totalBorrows;
189 
190     /**
191      * @notice Total amount of reserves of the underlying held in this market
192      */
193     uint public totalReserves;
194 
195     /**
196      * @notice Total number of tokens in circulation
197      */
198     uint public totalSupply;
199 
200     /**
201      * @notice Official record of token balances for each account
202      */
203     mapping (address => uint) internal accountTokens;
204 
205     /**
206      * @notice Approved token transfer amounts on behalf of others
207      */
208     mapping (address => mapping (address => uint)) internal transferAllowances;
209 
210     /**
211      * @notice Container for borrow balance information
212      * @member principal Total balance (with accrued interest), after applying the most recent balance-changing action
213      * @member interestIndex Global borrowIndex as of the most recent balance-changing action
214      */
215     struct BorrowSnapshot {
216         uint principal;
217         uint interestIndex;
218     }
219 
220     /**
221      * @notice Mapping of account addresses to outstanding borrow balances
222      */
223     mapping(address => BorrowSnapshot) internal accountBorrows;
224 }
225 
226 contract GTokenInterface is GTokenStorage {
227     /**
228      * @notice Indicator that this is a GToken contract (for inspection)
229      */
230     bool public constant isCToken = true;
231 
232 
233 
234     /*** Market Events ***/
235 
236     /**
237      * @notice Event emitted when interest is accrued
238      */
239     event AccrueInterest(uint cashPrior, uint interestAccumulated, uint borrowIndex, uint totalBorrows);
240 
241     /**
242      * @notice Event emitted when tokens are minted
243      */
244     event Mint(address minter, uint mintAmount, uint mintTokens);
245 
246     /**
247      * @notice Event emitted when tokens are redeemed
248      */
249     event Redeem(address redeemer, uint redeemAmount, uint redeemTokens);
250 
251     /**
252      * @notice Event emitted when underlying is borrowed
253      */
254     event Borrow(address borrower, uint borrowAmount, uint accountBorrows, uint totalBorrows);
255 
256     /**
257      * @notice Event emitted when a borrow is repaid
258      */
259     event RepayBorrow(address payer, address borrower, uint repayAmount, uint accountBorrows, uint totalBorrows);
260 
261     /**
262      * @notice Event emitted when a borrow is liquidated
263      */
264     event LiquidateBorrow(address liquidator, address borrower, uint repayAmount, address cTokenCollateral, uint seizeTokens);
265 
266 
267     /*** Admin Events ***/
268 
269     /**
270      * @notice Event emitted when pendingAdmin is changed
271      */
272     event NewPendingAdmin(address oldPendingAdmin, address newPendingAdmin);
273 
274 
275     /**
276      * @notice Event emitted when pendingAdmin is accepted, which means admin is updated
277      */
278     event NewAdmin(address oldAdmin, address newAdmin);
279 
280     /**
281      * @notice Event emitted when comptroller is changed
282      */
283     event NewComptroller(ComptrollerInterface oldComptroller, ComptrollerInterface newComptroller);
284 
285     /**
286      * @notice Event emitted when interestRateModel is changed
287      */
288     event NewMarketInterestRateModel(InterestRateModel oldInterestRateModel, InterestRateModel newInterestRateModel);
289 
290     /**
291      * @notice Event emitted when the reserve factor is changed
292      */
293     event NewReserveFactor(uint oldReserveFactorMantissa, uint newReserveFactorMantissa);
294 
295     /**
296      * @notice Event emitted when the reserves are added
297      */
298     event ReservesAdded(address benefactor, uint addAmount, uint newTotalReserves);
299 
300     /**
301      * @notice Event emitted when the reserves are reduced
302      */
303     event ReservesReduced(address admin, uint reduceAmount, uint newTotalReserves);
304 
305     /**
306      * @notice EIP20 Transfer event
307      */
308     event Transfer(address indexed from, address indexed to, uint amount);
309 
310     /**
311      * @notice EIP20 Approval event
312      */
313     event Approval(address indexed owner, address indexed spender, uint amount);
314 
315     /**
316      * @notice Failure event
317      */
318     event Failure(uint error, uint info, uint detail);
319 
320 
321     /*** User Interface ***/
322 
323     function transfer(address dst, uint amount) external returns (bool);
324     function transferFrom(address src, address dst, uint amount) external returns (bool);
325     function approve(address spender, uint amount) external returns (bool);
326     function allowance(address owner, address spender) external view returns (uint);
327     function balanceOf(address owner) external view returns (uint);
328     function balanceOfUnderlying(address owner) external returns (uint);
329     function getAccountSnapshot(address account) external view returns (uint, uint, uint, uint);
330     function borrowRatePerBlock() external view returns (uint);
331     function supplyRatePerBlock() external view returns (uint);
332     function totalBorrowsCurrent() external returns (uint);
333     function borrowBalanceCurrent(address account) external returns (uint);
334     function borrowBalanceStored(address account) public view returns (uint);
335     function exchangeRateCurrent() public returns (uint);
336     function exchangeRateStored() public view returns (uint);
337     function getCash() external view returns (uint);
338     function accrueInterest() public returns (uint);
339     function seize(address liquidator, address borrower, uint seizeTokens) external returns (uint);
340 
341 
342     /*** Admin Functions ***/
343 
344     function _setPendingAdmin(address payable newPendingAdmin) external returns (uint);
345     function _acceptAdmin() external returns (uint);
346     function _setComptroller(ComptrollerInterface newComptroller) public returns (uint);
347     function _setReserveFactor(uint newReserveFactorMantissa) external returns (uint);
348     function _reduceReserves(uint reduceAmount) external returns (uint);
349     function _setInterestRateModel(InterestRateModel newInterestRateModel) public returns (uint);
350 }
351 
352 
353 
354 contract CErc20Interface  {
355 
356     /*** User Interface ***/
357 
358     function mint(uint mintAmount) external returns (uint);
359     function redeem(uint redeemTokens) external returns (uint);
360     function redeemUnderlying(uint redeemAmount) external returns (uint);
361     function borrow(uint borrowAmount) external returns (uint);
362     function repayBorrow(uint repayAmount) external returns (uint);
363     function repayBorrowBehalf(address borrower, uint repayAmount) external returns (uint);
364     function liquidateBorrow(address borrower, uint repayAmount, GTokenInterface cTokenCollateral) external returns (uint);
365 
366 
367     /*** Admin Functions ***/
368 
369     function _addReserves(uint addAmount) external returns (uint);
370 }
371 
372 contract CDelegationStorage {
373     /**
374      * @notice Implementation address for this contract
375      */
376     address public implementation;
377 }
378 
379 contract CDelegatorInterface is CDelegationStorage {
380     /**
381      * @notice Emitted when implementation is changed
382      */
383     event NewImplementation(address oldImplementation, address newImplementation);
384 
385     /**
386      * @notice Called by the admin to update the implementation of the delegator
387      * @param implementation_ The address of the new implementation for delegation
388      * @param allowResign Flag to indicate whether to call _resignImplementation on the old implementation
389      * @param becomeImplementationData The encoded bytes data to be passed to _becomeImplementation
390      */
391     function _setImplementation(address implementation_, bool allowResign, bytes memory becomeImplementationData) public;
392 }
393 
394 contract CDelegateInterface is CDelegationStorage {
395     /**
396      * @notice Called by the delegator on a delegate to initialize it for duty
397      * @dev Should revert if any issues arise which make it unfit for delegation
398      * @param data The encoded bytes data for any initialization
399      */
400     function _becomeImplementation(bytes memory data) public;
401 
402     /**
403      * @notice Called by the delegator on a delegate to forfeit its responsibility
404      */
405     function _resignImplementation() public;
406 }
407 
408 // File: contracts/ErrorReporter.sol
409 
410 pragma solidity 0.5.17;
411 
412 contract ComptrollerErrorReporter {
413     enum Error {
414         NO_ERROR,  // 0
415         UNAUTHORIZED, // 1
416         COMPTROLLER_MISMATCH, // 2
417         INSUFFICIENT_SHORTFALL, // 3
418         INSUFFICIENT_LIQUIDITY, // 4
419         INVALID_CLOSE_FACTOR, // 5
420         INVALID_COLLATERAL_FACTOR, // 6
421         INVALID_LIQUIDATION_INCENTIVE, // 7
422         MARKET_NOT_ENTERED, // 8 no longer possible
423         MARKET_NOT_LISTED, // 9
424         MARKET_ALREADY_LISTED, // 10
425         MATH_ERROR, // 11
426         NONZERO_BORROW_BALANCE, // 12
427         PRICE_ERROR, // 13
428         REJECTION, // 14
429         SNAPSHOT_ERROR, // 15
430         TOO_MANY_ASSETS, // 16
431         TOO_MUCH_REPAY // 17
432     }
433 
434     enum FailureInfo {
435         ACCEPT_ADMIN_PENDING_ADMIN_CHECK, // 0
436         ACCEPT_PENDING_IMPLEMENTATION_ADDRESS_CHECK, // 1
437         EXIT_MARKET_BALANCE_OWED, // 2
438         EXIT_MARKET_REJECTION, // 3
439         SET_CLOSE_FACTOR_OWNER_CHECK, // 4
440         SET_CLOSE_FACTOR_VALIDATION, // 5
441         SET_COLLATERAL_FACTOR_OWNER_CHECK, // 6
442         SET_COLLATERAL_FACTOR_NO_EXISTS, // 7
443         SET_COLLATERAL_FACTOR_VALIDATION, // 8
444         SET_COLLATERAL_FACTOR_WITHOUT_PRICE, // 9
445         SET_IMPLEMENTATION_OWNER_CHECK, // 10
446         SET_LIQUIDATION_INCENTIVE_OWNER_CHECK, // 11
447         SET_LIQUIDATION_INCENTIVE_VALIDATION, // 12
448         SET_MAX_ASSETS_OWNER_CHECK, // 13
449         SET_PENDING_ADMIN_OWNER_CHECK, // 14
450         SET_PENDING_IMPLEMENTATION_OWNER_CHECK, // 15
451         SET_PRICE_ORACLE_OWNER_CHECK, // 16
452         SUPPORT_MARKET_EXISTS, // 17
453         SUPPORT_MARKET_OWNER_CHECK, // 18
454         SET_PAUSE_GUARDIAN_OWNER_CHECK // 19
455     }
456 
457     /**
458       * @dev `error` corresponds to enum Error; `info` corresponds to enum FailureInfo, and `detail` is an arbitrary
459       * contract-specific code that enables us to report opaque error codes from upgradeable contracts.
460       **/
461     event Failure(uint error, uint info, uint detail);
462 
463     /**
464       * @dev use this when reporting a known error from the money market or a non-upgradeable collaborator
465       */
466     function fail(Error err, FailureInfo info) internal returns (uint) {
467         emit Failure(uint(err), uint(info), 0);
468 
469         return uint(err);
470     }
471 
472     /**
473       * @dev use this when reporting an opaque error from an upgradeable collaborator contract
474       */
475     function failOpaque(Error err, FailureInfo info, uint opaqueError) internal returns (uint) {
476         emit Failure(uint(err), uint(info), opaqueError);
477 
478         return uint(err);
479     }
480 }
481 
482 contract TokenErrorReporter {
483     enum Error {
484         NO_ERROR, // 0 
485         UNAUTHORIZED, // 1
486         BAD_INPUT, // 2
487         COMPTROLLER_REJECTION, // 3
488         COMPTROLLER_CALCULATION_ERROR, // 4
489         INTEREST_RATE_MODEL_ERROR, // 5
490         INVALID_ACCOUNT_PAIR, // 6
491         INVALID_CLOSE_AMOUNT_REQUESTED, // 7
492         INVALID_COLLATERAL_FACTOR, // 8
493         MATH_ERROR, // 9
494         MARKET_NOT_FRESH, // 10
495         MARKET_NOT_LISTED, // 11
496         TOKEN_INSUFFICIENT_ALLOWANCE, // 12
497         TOKEN_INSUFFICIENT_BALANCE, // 13
498         TOKEN_INSUFFICIENT_CASH, // 14 
499         TOKEN_TRANSFER_IN_FAILED, // 15
500         TOKEN_TRANSFER_OUT_FAILED // 16
501     }
502 
503     /*
504      * Note: FailureInfo (but not Error) is kept in alphabetical order
505      *       This is because FailureInfo grows significantly faster, and
506      *       the order of Error has some meaning, while the order of FailureInfo
507      *       is entirely arbitrary.
508      */
509     enum FailureInfo {
510         ACCEPT_ADMIN_PENDING_ADMIN_CHECK, // 0 
511         ACCRUE_INTEREST_ACCUMULATED_INTEREST_CALCULATION_FAILED, // 1
512         ACCRUE_INTEREST_BORROW_RATE_CALCULATION_FAILED, // 2
513         ACCRUE_INTEREST_NEW_BORROW_INDEX_CALCULATION_FAILED, // 3 
514         ACCRUE_INTEREST_NEW_TOTAL_BORROWS_CALCULATION_FAILED, // 4
515         ACCRUE_INTEREST_NEW_TOTAL_RESERVES_CALCULATION_FAILED, // 5
516         ACCRUE_INTEREST_SIMPLE_INTEREST_FACTOR_CALCULATION_FAILED, // 6
517         BORROW_ACCUMULATED_BALANCE_CALCULATION_FAILED, // 7
518         BORROW_ACCRUE_INTEREST_FAILED, // 8
519         BORROW_CASH_NOT_AVAILABLE, // 9
520         BORROW_FRESHNESS_CHECK,  // 10
521         BORROW_NEW_TOTAL_BALANCE_CALCULATION_FAILED, // 11
522         BORROW_NEW_ACCOUNT_BORROW_BALANCE_CALCULATION_FAILED, // 12
523         BORROW_MARKET_NOT_LISTED, // 13
524         BORROW_COMPTROLLER_REJECTION, // 14
525         LIQUIDATE_ACCRUE_BORROW_INTEREST_FAILED, // 15
526         LIQUIDATE_ACCRUE_COLLATERAL_INTEREST_FAILED, // 16
527         LIQUIDATE_COLLATERAL_FRESHNESS_CHECK, // 17
528         LIQUIDATE_COMPTROLLER_REJECTION, // 18
529         LIQUIDATE_COMPTROLLER_CALCULATE_AMOUNT_SEIZE_FAILED, // 19
530         LIQUIDATE_CLOSE_AMOUNT_IS_UINT_MAX, // 20
531         LIQUIDATE_CLOSE_AMOUNT_IS_ZERO, // 21
532         LIQUIDATE_FRESHNESS_CHECK, // 22 
533         LIQUIDATE_LIQUIDATOR_IS_BORROWER, // 23
534         LIQUIDATE_REPAY_BORROW_FRESH_FAILED, // 24
535         LIQUIDATE_SEIZE_BALANCE_INCREMENT_FAILED, // 25
536         LIQUIDATE_SEIZE_BALANCE_DECREMENT_FAILED, // 26
537         LIQUIDATE_SEIZE_COMPTROLLER_REJECTION, // 27
538         LIQUIDATE_SEIZE_LIQUIDATOR_IS_BORROWER, // 28
539         LIQUIDATE_SEIZE_TOO_MUCH, // 29
540         MINT_ACCRUE_INTEREST_FAILED, // 30
541         MINT_COMPTROLLER_REJECTION, // 31
542         MINT_EXCHANGE_CALCULATION_FAILED, // 32
543         MINT_EXCHANGE_RATE_READ_FAILED, // 33
544         MINT_FRESHNESS_CHECK, // 34
545         MINT_NEW_ACCOUNT_BALANCE_CALCULATION_FAILED, // 35
546         MINT_NEW_TOTAL_SUPPLY_CALCULATION_FAILED, // 36
547         MINT_TRANSFER_IN_FAILED, // 37 
548         MINT_TRANSFER_IN_NOT_POSSIBLE, // 38 
549         REDEEM_ACCRUE_INTEREST_FAILED, // 39 
550         REDEEM_COMPTROLLER_REJECTION, // 40 
551         REDEEM_EXCHANGE_TOKENS_CALCULATION_FAILED, // 41 
552         REDEEM_EXCHANGE_AMOUNT_CALCULATION_FAILED, // 42  
553         REDEEM_EXCHANGE_RATE_READ_FAILED, // 42 
554         REDEEM_FRESHNESS_CHECK, // 43 
555         REDEEM_NEW_ACCOUNT_BALANCE_CALCULATION_FAILED, // 44 
556         REDEEM_NEW_TOTAL_SUPPLY_CALCULATION_FAILED, // 45
557         REDEEM_TRANSFER_OUT_NOT_POSSIBLE, // 46
558         REDUCE_RESERVES_ACCRUE_INTEREST_FAILED, // 47 
559         REDUCE_RESERVES_ADMIN_CHECK, // 48 
560         REDUCE_RESERVES_CASH_NOT_AVAILABLE, // 49 
561         REDUCE_RESERVES_FRESH_CHECK, // 50
562         REDUCE_RESERVES_VALIDATION, // 51
563         REPAY_BEHALF_ACCRUE_INTEREST_FAILED,  // 52
564         REPAY_BORROW_ACCRUE_INTEREST_FAILED, // 53
565         REPAY_BORROW_ACCUMULATED_BALANCE_CALCULATION_FAILED, //54
566         REPAY_BORROW_COMPTROLLER_REJECTION, // 55
567         REPAY_BORROW_FRESHNESS_CHECK, // 56
568         REPAY_BORROW_NEW_ACCOUNT_BORROW_BALANCE_CALCULATION_FAILED, //57
569         REPAY_BORROW_NEW_TOTAL_BALANCE_CALCULATION_FAILED, // 58
570         REPAY_BORROW_TRANSFER_IN_NOT_POSSIBLE, // 59
571         SET_COLLATERAL_FACTOR_OWNER_CHECK, // 60
572         SET_COLLATERAL_FACTOR_VALIDATION, // 61
573         SET_COMPTROLLER_OWNER_CHECK, // 62
574         SET_INTEREST_RATE_MODEL_ACCRUE_INTEREST_FAILED, //63
575         SET_INTEREST_RATE_MODEL_FRESH_CHECK, // 64
576         SET_INTEREST_RATE_MODEL_OWNER_CHECK, // 65
577         SET_MAX_ASSETS_OWNER_CHECK, // 66
578         SET_ORACLE_MARKET_NOT_LISTED, // 67
579         SET_PENDING_ADMIN_OWNER_CHECK, // 68
580         SET_RESERVE_FACTOR_ACCRUE_INTEREST_FAILED, // 69
581         SET_RESERVE_FACTOR_ADMIN_CHECK, // 70
582         SET_RESERVE_FACTOR_FRESH_CHECK, // 71
583         SET_RESERVE_FACTOR_BOUNDS_CHECK, // 72
584         TRANSFER_COMPTROLLER_REJECTION, // 73
585         TRANSFER_NOT_ALLOWED, // 74
586         TRANSFER_NOT_ENOUGH, // 75
587         TRANSFER_TOO_MUCH, // 76
588         ADD_RESERVES_ACCRUE_INTEREST_FAILED, // 77
589         ADD_RESERVES_FRESH_CHECK, // 78
590         ADD_RESERVES_TRANSFER_IN_NOT_POSSIBLE // 79
591     }
592 
593     /**
594       * @dev `error` corresponds to enum Error; `info` corresponds to enum FailureInfo, and `detail` is an arbitrary
595       * contract-specific code that enables us to report opaque error codes from upgradeable contracts.
596       **/
597     event Failure(uint error, uint info, uint detail);
598 
599     /**
600       * @dev use this when reporting a known error from the money market or a non-upgradeable collaborator
601       */
602     function fail(Error err, FailureInfo info) internal returns (uint) {
603         emit Failure(uint(err), uint(info), 0);
604 
605         return uint(err);
606     }
607 
608     /**
609       * @dev use this when reporting an opaque error from an upgradeable collaborator contract
610       */
611     function failOpaque(Error err, FailureInfo info, uint opaqueError) internal returns (uint) {
612         emit Failure(uint(err), uint(info), opaqueError);
613 
614         return uint(err);
615     }
616 }
617 
618 // File: contracts/CarefulMath.sol
619 
620 pragma solidity 0.5.17;
621 
622 /**
623   * @title Careful Math
624   * @notice Derived from OpenZeppelin's SafeMath library
625   *         https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/math/SafeMath.sol
626   */
627 contract CarefulMath {
628 
629     /**
630      * @dev Possible error codes that we can return
631      */
632     enum MathError {
633         NO_ERROR,
634         DIVISION_BY_ZERO,
635         INTEGER_OVERFLOW,
636         INTEGER_UNDERFLOW
637     }
638 
639     /**
640     * @dev Multiplies two numbers, returns an error on overflow.
641     */
642     function mulUInt(uint a, uint b) internal pure returns (MathError, uint) {
643         if (a == 0) {
644             return (MathError.NO_ERROR, 0);
645         }
646 
647         uint c = a * b;
648 
649         if (c / a != b) {
650             return (MathError.INTEGER_OVERFLOW, 0);
651         } else {
652             return (MathError.NO_ERROR, c);
653         }
654     }
655 
656     /**
657     * @dev Integer division of two numbers, truncating the quotient.
658     */
659     function divUInt(uint a, uint b) internal pure returns (MathError, uint) {
660         if (b == 0) {
661             return (MathError.DIVISION_BY_ZERO, 0);
662         }
663 
664         return (MathError.NO_ERROR, a / b);
665     }
666 
667     /**
668     * @dev Subtracts two numbers, returns an error on overflow (i.e. if subtrahend is greater than minuend).
669     */
670     function subUInt(uint a, uint b) internal pure returns (MathError, uint) {
671         if (b <= a) {
672             return (MathError.NO_ERROR, a - b);
673         } else {
674             return (MathError.INTEGER_UNDERFLOW, 0);
675         }
676     }
677 
678     /**
679     * @dev Adds two numbers, returns an error on overflow.
680     */
681     function addUInt(uint a, uint b) internal pure returns (MathError, uint) {
682         uint c = a + b;
683 
684         if (c >= a) {
685             return (MathError.NO_ERROR, c);
686         } else {
687             return (MathError.INTEGER_OVERFLOW, 0);
688         }
689     }
690 
691     /**
692     * @dev add a and b and then subtract c
693     */
694     function addThenSubUInt(uint a, uint b, uint c) internal pure returns (MathError, uint) {
695         (MathError err0, uint sum) = addUInt(a, b);
696 
697         if (err0 != MathError.NO_ERROR) {
698             return (err0, 0);
699         }
700 
701         return subUInt(sum, c);
702     }
703 }
704 
705 // File: contracts/Exponential.sol
706 
707 pragma solidity 0.5.17;
708 
709 
710 /**
711  * @title Exponential module for storing fixed-precision decimals
712  * @author Compound
713  * @notice Exp is a struct which stores decimals with a fixed precision of 18 decimal places.
714  *         Thus, if we wanted to store the 5.1, mantissa would store 5.1e18. That is:
715  *         `Exp({mantissa: 5100000000000000000})`.
716  */
717 contract Exponential is CarefulMath {
718     uint constant expScale = 1e18;
719     uint constant doubleScale = 1e36;
720     uint constant halfExpScale = expScale/2;
721     uint constant mantissaOne = expScale;
722 
723     struct Exp {
724         uint mantissa;
725     }
726 
727     struct Double {
728         uint mantissa;
729     }
730 
731     /**
732      * @dev Creates an exponential from numerator and denominator values.
733      *      Note: Returns an error if (`num` * 10e18) > MAX_INT,
734      *            or if `denom` is zero.
735      */
736     function getExp(uint num, uint denom) pure internal returns (MathError, Exp memory) {
737         (MathError err0, uint scaledNumerator) = mulUInt(num, expScale);
738         if (err0 != MathError.NO_ERROR) {
739             return (err0, Exp({mantissa: 0}));
740         }
741 
742         (MathError err1, uint rational) = divUInt(scaledNumerator, denom);
743         if (err1 != MathError.NO_ERROR) {
744             return (err1, Exp({mantissa: 0}));
745         }
746 
747         return (MathError.NO_ERROR, Exp({mantissa: rational}));
748     }
749 
750     /**
751      * @dev Adds two exponentials, returning a new exponential.
752      */
753     function addExp(Exp memory a, Exp memory b) pure internal returns (MathError, Exp memory) {
754         (MathError error, uint result) = addUInt(a.mantissa, b.mantissa);
755 
756         return (error, Exp({mantissa: result}));
757     }
758 
759     /**
760      * @dev Subtracts two exponentials, returning a new exponential.
761      */
762     function subExp(Exp memory a, Exp memory b) pure internal returns (MathError, Exp memory) {
763         (MathError error, uint result) = subUInt(a.mantissa, b.mantissa);
764 
765         return (error, Exp({mantissa: result}));
766     }
767 
768     /**
769      * @dev Multiply an Exp by a scalar, returning a new Exp.
770      */
771     function mulScalar(Exp memory a, uint scalar) pure internal returns (MathError, Exp memory) {
772         (MathError err0, uint scaledMantissa) = mulUInt(a.mantissa, scalar);
773         if (err0 != MathError.NO_ERROR) {
774             return (err0, Exp({mantissa: 0}));
775         }
776 
777         return (MathError.NO_ERROR, Exp({mantissa: scaledMantissa}));
778     }
779 
780     /**
781      * @dev Multiply an Exp by a scalar, then truncate to return an unsigned integer.
782      */
783     function mulScalarTruncate(Exp memory a, uint scalar) pure internal returns (MathError, uint) {
784         (MathError err, Exp memory product) = mulScalar(a, scalar);
785         if (err != MathError.NO_ERROR) {
786             return (err, 0);
787         }
788 
789         return (MathError.NO_ERROR, truncate(product));
790     }
791 
792     /**
793      * @dev Multiply an Exp by a scalar, truncate, then add an to an unsigned integer, returning an unsigned integer.
794      */
795     function mulScalarTruncateAddUInt(Exp memory a, uint scalar, uint addend) pure internal returns (MathError, uint) {
796         (MathError err, Exp memory product) = mulScalar(a, scalar);
797         if (err != MathError.NO_ERROR) {
798             return (err, 0);
799         }
800 
801         return addUInt(truncate(product), addend);
802     }
803 
804     /**
805      * @dev Divide an Exp by a scalar, returning a new Exp.
806      */
807     function divScalar(Exp memory a, uint scalar) pure internal returns (MathError, Exp memory) {
808         (MathError err0, uint descaledMantissa) = divUInt(a.mantissa, scalar);
809         if (err0 != MathError.NO_ERROR) {
810             return (err0, Exp({mantissa: 0}));
811         }
812 
813         return (MathError.NO_ERROR, Exp({mantissa: descaledMantissa}));
814     }
815 
816     /**
817      * @dev Divide a scalar by an Exp, returning a new Exp.
818      */
819     function divScalarByExp(uint scalar, Exp memory divisor) pure internal returns (MathError, Exp memory) {
820         /*
821           We are doing this as:
822           getExp(mulUInt(expScale, scalar), divisor.mantissa)
823 
824           How it works:
825           Exp = a / b;
826           Scalar = s;
827           `s / (a / b)` = `b * s / a` and since for an Exp `a = mantissa, b = expScale`
828         */
829         (MathError err0, uint numerator) = mulUInt(expScale, scalar);
830         if (err0 != MathError.NO_ERROR) {
831             return (err0, Exp({mantissa: 0}));
832         }
833         return getExp(numerator, divisor.mantissa);
834     }
835 
836     /**
837      * @dev Divide a scalar by an Exp, then truncate to return an unsigned integer.
838      */
839     function divScalarByExpTruncate(uint scalar, Exp memory divisor) pure internal returns (MathError, uint) {
840         (MathError err, Exp memory fraction) = divScalarByExp(scalar, divisor);
841         if (err != MathError.NO_ERROR) {
842             return (err, 0);
843         }
844 
845         return (MathError.NO_ERROR, truncate(fraction));
846     }
847 
848     /**
849      * @dev Multiplies two exponentials, returning a new exponential.
850      */
851     function mulExp(Exp memory a, Exp memory b) pure internal returns (MathError, Exp memory) {
852 
853         (MathError err0, uint doubleScaledProduct) = mulUInt(a.mantissa, b.mantissa);
854         if (err0 != MathError.NO_ERROR) {
855             return (err0, Exp({mantissa: 0}));
856         }
857 
858         // We add half the scale before dividing so that we get rounding instead of truncation.
859         //  See "Listing 6" and text above it at https://accu.org/index.php/journals/1717
860         // Without this change, a result like 6.6...e-19 will be truncated to 0 instead of being rounded to 1e-18.
861         (MathError err1, uint doubleScaledProductWithHalfScale) = addUInt(halfExpScale, doubleScaledProduct);
862         if (err1 != MathError.NO_ERROR) {
863             return (err1, Exp({mantissa: 0}));
864         }
865 
866         (MathError err2, uint product) = divUInt(doubleScaledProductWithHalfScale, expScale);
867         // The only error `div` can return is MathError.DIVISION_BY_ZERO but we control `expScale` and it is not zero.
868         assert(err2 == MathError.NO_ERROR);
869 
870         return (MathError.NO_ERROR, Exp({mantissa: product}));
871     }
872 
873     /**
874      * @dev Multiplies two exponentials given their mantissas, returning a new exponential.
875      */
876     function mulExp(uint a, uint b) pure internal returns (MathError, Exp memory) {
877         return mulExp(Exp({mantissa: a}), Exp({mantissa: b}));
878     }
879 
880     /**
881      * @dev Multiplies three exponentials, returning a new exponential.
882      */
883     function mulExp3(Exp memory a, Exp memory b, Exp memory c) pure internal returns (MathError, Exp memory) {
884         (MathError err, Exp memory ab) = mulExp(a, b);
885         if (err != MathError.NO_ERROR) {
886             return (err, ab);
887         }
888         return mulExp(ab, c);
889     }
890 
891     /**
892      * @dev Divides two exponentials, returning a new exponential.
893      *     (a/scale) / (b/scale) = (a/scale) * (scale/b) = a/b,
894      *  which we can scale as an Exp by calling getExp(a.mantissa, b.mantissa)
895      */
896     function divExp(Exp memory a, Exp memory b) pure internal returns (MathError, Exp memory) {
897         return getExp(a.mantissa, b.mantissa);
898     }
899 
900     /**
901      * @dev Truncates the given exp to a whole number value.
902      *      For example, truncate(Exp{mantissa: 15 * expScale}) = 15
903      */
904     function truncate(Exp memory exp) pure internal returns (uint) {
905         // Note: We are not using careful math here as we're performing a division that cannot fail
906         return exp.mantissa / expScale;
907     }
908 
909     /**
910      * @dev Checks if first Exp is less than second Exp.
911      */
912     function lessThanExp(Exp memory left, Exp memory right) pure internal returns (bool) {
913         return left.mantissa < right.mantissa;
914     }
915 
916     /**
917      * @dev Checks if left Exp <= right Exp.
918      */
919     function lessThanOrEqualExp(Exp memory left, Exp memory right) pure internal returns (bool) {
920         return left.mantissa <= right.mantissa;
921     }
922 
923     /**
924      * @dev Checks if left Exp > right Exp.
925      */
926     function greaterThanExp(Exp memory left, Exp memory right) pure internal returns (bool) {
927         return left.mantissa > right.mantissa;
928     }
929 
930     /**
931      * @dev returns true if Exp is exactly zero
932      */
933     function isZeroExp(Exp memory value) pure internal returns (bool) {
934         return value.mantissa == 0;
935     }
936 
937     function safe224(uint n, string memory errorMessage) pure internal returns (uint224) {
938         require(n < 2**224, errorMessage);
939         return uint224(n);
940     }
941 
942     function safe32(uint n, string memory errorMessage) pure internal returns (uint32) {
943         require(n < 2**32, errorMessage);
944         return uint32(n);
945     }
946 
947     function add_(Exp memory a, Exp memory b) pure internal returns (Exp memory) {
948         return Exp({mantissa: add_(a.mantissa, b.mantissa)});
949     }
950 
951     function add_(Double memory a, Double memory b) pure internal returns (Double memory) {
952         return Double({mantissa: add_(a.mantissa, b.mantissa)});
953     }
954 
955     function add_(uint a, uint b) pure internal returns (uint) {
956         return add_(a, b, "addition overflow");
957     }
958 
959     function add_(uint a, uint b, string memory errorMessage) pure internal returns (uint) {
960         uint c = a + b;
961         require(c >= a, errorMessage);
962         return c;
963     }
964 
965     function sub_(Exp memory a, Exp memory b) pure internal returns (Exp memory) {
966         return Exp({mantissa: sub_(a.mantissa, b.mantissa)});
967     }
968 
969     function sub_(Double memory a, Double memory b) pure internal returns (Double memory) {
970         return Double({mantissa: sub_(a.mantissa, b.mantissa)});
971     }
972 
973     function sub_(uint a, uint b) pure internal returns (uint) {
974         return sub_(a, b, "subtraction underflow");
975     }
976 
977     function sub_(uint a, uint b, string memory errorMessage) pure internal returns (uint) {
978         require(b <= a, errorMessage);
979         return a - b;
980     }
981 
982     function mul_(Exp memory a, Exp memory b) pure internal returns (Exp memory) {
983         return Exp({mantissa: mul_(a.mantissa, b.mantissa) / expScale});
984     }
985 
986     function mul_(Exp memory a, uint b) pure internal returns (Exp memory) {
987         return Exp({mantissa: mul_(a.mantissa, b)});
988     }
989 
990     function mul_(uint a, Exp memory b) pure internal returns (uint) {
991         return mul_(a, b.mantissa) / expScale;
992     }
993 
994     function mul_(Double memory a, Double memory b) pure internal returns (Double memory) {
995         return Double({mantissa: mul_(a.mantissa, b.mantissa) / doubleScale});
996     }
997 
998     function mul_(Double memory a, uint b) pure internal returns (Double memory) {
999         return Double({mantissa: mul_(a.mantissa, b)});
1000     }
1001 
1002     function mul_(uint a, Double memory b) pure internal returns (uint) {
1003         return mul_(a, b.mantissa) / doubleScale;
1004     }
1005 
1006     function mul_(uint a, uint b) pure internal returns (uint) {
1007         return mul_(a, b, "multiplication overflow");
1008     }
1009 
1010     function mul_(uint a, uint b, string memory errorMessage) pure internal returns (uint) {
1011         if (a == 0 || b == 0) {
1012             return 0;
1013         }
1014         uint c = a * b;
1015         require(c / a == b, errorMessage);
1016         return c;
1017     }
1018 
1019     function div_(Exp memory a, Exp memory b) pure internal returns (Exp memory) {
1020         return Exp({mantissa: div_(mul_(a.mantissa, expScale), b.mantissa)});
1021     }
1022 
1023     function div_(Exp memory a, uint b) pure internal returns (Exp memory) {
1024         return Exp({mantissa: div_(a.mantissa, b)});
1025     }
1026 
1027     function div_(uint a, Exp memory b) pure internal returns (uint) {
1028         return div_(mul_(a, expScale), b.mantissa);
1029     }
1030 
1031     function div_(Double memory a, Double memory b) pure internal returns (Double memory) {
1032         return Double({mantissa: div_(mul_(a.mantissa, doubleScale), b.mantissa)});
1033     }
1034 
1035     function div_(Double memory a, uint b) pure internal returns (Double memory) {
1036         return Double({mantissa: div_(a.mantissa, b)});
1037     }
1038 
1039     function div_(uint a, Double memory b) pure internal returns (uint) {
1040         return div_(mul_(a, doubleScale), b.mantissa);
1041     }
1042 
1043     function div_(uint a, uint b) pure internal returns (uint) {
1044         return div_(a, b, "divide by zero");
1045     }
1046 
1047     function div_(uint a, uint b, string memory errorMessage) pure internal returns (uint) {
1048         require(b > 0, errorMessage);
1049         return a / b;
1050     }
1051 
1052     function fraction(uint a, uint b) pure internal returns (Double memory) {
1053         return Double({mantissa: div_(mul_(a, doubleScale), b)});
1054     }
1055 }
1056 
1057 // File: contracts/EIP20Interface.sol
1058 
1059 pragma solidity 0.5.17;
1060 
1061 /**
1062  * @title ERC 20 Token Standard Interface
1063  *  https://eips.ethereum.org/EIPS/eip-20
1064  */
1065 interface EIP20Interface {
1066     function name() external view returns (string memory);
1067     function symbol() external view returns (string memory);
1068     function decimals() external view returns (uint8);
1069 
1070     /**
1071       * @notice Get the total number of tokens in circulation
1072       * @return The supply of tokens
1073       */
1074     function totalSupply() external view returns (uint256);
1075 
1076     /**
1077      * @notice Gets the balance of the specified address
1078      * @param owner The address from which the balance will be retrieved
1079      * @return The balance
1080      */
1081     function balanceOf(address owner) external view returns (uint256 balance);
1082 
1083     /**
1084       * @notice Transfer `amount` tokens from `msg.sender` to `dst`
1085       * @param dst The address of the destination account
1086       * @param amount The number of tokens to transfer
1087       * @return Whether or not the transfer succeeded
1088       */
1089     function transfer(address dst, uint256 amount) external returns (bool success);
1090 
1091     /**
1092       * @notice Transfer `amount` tokens from `src` to `dst`
1093       * @param src The address of the source account
1094       * @param dst The address of the destination account
1095       * @param amount The number of tokens to transfer
1096       * @return Whether or not the transfer succeeded
1097       */
1098     function transferFrom(address src, address dst, uint256 amount) external returns (bool success);
1099 
1100     /**
1101       * @notice Approve `spender` to transfer up to `amount` from `src`
1102       * @dev This will overwrite the approval amount for `spender`
1103       *  and is subject to issues noted [here](https://eips.ethereum.org/EIPS/eip-20#approve)
1104       * @param spender The address of the account which may transfer tokens
1105       * @param amount The number of tokens that are approved (-1 means infinite)
1106       * @return Whether or not the approval succeeded
1107       */
1108     function approve(address spender, uint256 amount) external returns (bool success);
1109 
1110     /**
1111       * @notice Get the current allowance from `owner` for `spender`
1112       * @param owner The address of the account which owns the tokens to be spent
1113       * @param spender The address of the account which may transfer tokens
1114       * @return The number of tokens allowed to be spent (-1 means infinite)
1115       */
1116     function allowance(address owner, address spender) external view returns (uint256 remaining);
1117 
1118     event Transfer(address indexed from, address indexed to, uint256 amount);
1119     event Approval(address indexed owner, address indexed spender, uint256 amount);
1120 }
1121 
1122 // File: contracts/EIP20NonStandardInterface.sol
1123 
1124 pragma solidity 0.5.17;
1125 
1126 /**
1127  * @title EIP20NonStandardInterface
1128  * @dev Version of ERC20 with no return values for `transfer` and `transferFrom`
1129  *  See https://medium.com/coinmonks/missing-return-value-bug-at-least-130-tokens-affected-d67bf08521ca
1130  */
1131 interface EIP20NonStandardInterface {
1132 
1133     /**
1134      * @notice Get the total number of tokens in circulation
1135      * @return The supply of tokens
1136      */
1137     function totalSupply() external view returns (uint256);
1138 
1139     /**
1140      * @notice Gets the balance of the specified address
1141      * @param owner The address from which the balance will be retrieved
1142      * @return The balance
1143      */
1144     function balanceOf(address owner) external view returns (uint256 balance);
1145 
1146     ///
1147     /// !!!!!!!!!!!!!!
1148     /// !!! NOTICE !!! `transfer` does not return a value, in violation of the ERC-20 specification
1149     /// !!!!!!!!!!!!!!
1150     ///
1151 
1152     /**
1153       * @notice Transfer `amount` tokens from `msg.sender` to `dst`
1154       * @param dst The address of the destination account
1155       * @param amount The number of tokens to transfer
1156       */
1157     function transfer(address dst, uint256 amount) external;
1158 
1159     ///
1160     /// !!!!!!!!!!!!!!
1161     /// !!! NOTICE !!! `transferFrom` does not return a value, in violation of the ERC-20 specification
1162     /// !!!!!!!!!!!!!!
1163     ///
1164 
1165     /**
1166       * @notice Transfer `amount` tokens from `src` to `dst`
1167       * @param src The address of the source account
1168       * @param dst The address of the destination account
1169       * @param amount The number of tokens to transfer
1170       */
1171     function transferFrom(address src, address dst, uint256 amount) external;
1172 
1173     /**
1174       * @notice Approve `spender` to transfer up to `amount` from `src`
1175       * @dev This will overwrite the approval amount for `spender`
1176       *  and is subject to issues noted [here](https://eips.ethereum.org/EIPS/eip-20#approve)
1177       * @param spender The address of the account which may transfer tokens
1178       * @param amount The number of tokens that are approved
1179       * @return Whether or not the approval succeeded
1180       */
1181     function approve(address spender, uint256 amount) external returns (bool success);
1182 
1183     /**
1184       * @notice Get the current allowance from `owner` for `spender`
1185       * @param owner The address of the account which owns the tokens to be spent
1186       * @param spender The address of the account which may transfer tokens
1187       * @return The number of tokens allowed to be spent
1188       */
1189     function allowance(address owner, address spender) external view returns (uint256 remaining);
1190 
1191     event Transfer(address indexed from, address indexed to, uint256 amount);
1192     event Approval(address indexed owner, address indexed spender, uint256 amount);
1193 }
1194 
1195 // File: contracts/GToken.sol
1196 
1197 pragma solidity 0.5.17;
1198 
1199 
1200 
1201 
1202 
1203 
1204 
1205 
1206 /**
1207  * @title  GToken Contract
1208  * @notice Abstract base for CTokens
1209  */
1210 contract GToken is GTokenInterface, Exponential, TokenErrorReporter {
1211 
1212     bytes32  internal constant projectHash = keccak256(abi.encodePacked("ZILD"));
1213 
1214     /**
1215      * @notice Underlying asset for this GToken
1216      */
1217     address public underlying;
1218 
1219     /**
1220      * @notice , ETH is native coin
1221      */
1222     bool public underlyingIsNativeCoin;
1223 
1224     //  borrow fee amount * borrowFee / 10000;
1225     uint public borrowFee;
1226 
1227     // redeem fee amount = redeem amount * redeemFee / 10000;
1228     uint public redeemFee;
1229 
1230     uint public constant TEN_THOUSAND = 10000;
1231     
1232     // max fee borrow redeem fee : 1%
1233     uint public constant MAX_BORROW_REDEEM_FEE = 100;
1234 
1235     // borrow fee and redeemFee will send to feeTo
1236     address payable public feeTo;
1237 
1238 
1239     event NewBorrowFee(uint oldBorrowFee, uint newBorrowFee);
1240 
1241     event NewRedeemFee(uint oldRedeemFee, uint newRedeemFee);
1242 
1243     event NewFeeTo(address oldFeeTo, address newFeeTo);
1244 
1245     /**
1246      * @notice Initialize the money market
1247      * @param underlying_ Underlying asset for this GToken,  ZETH's underlying is address(0)
1248      * @param comptroller_ The address of the Comptroller
1249      * @param interestRateModel_ The address of the interest rate model
1250      * @param initialExchangeRateMantissa_ The initial exchange rate, scaled by 1e18
1251      * @param name_ EIP-20 name of this token
1252      * @param symbol_ EIP-20 symbol of this token
1253      * @param decimals_ EIP-20 decimal precision of this token
1254      * @param borrowFee_  borrow fee
1255      * @param redeemFee_ redeem fee
1256      * @param feeTo_ fee address
1257      */
1258     function initialize(address underlying_,
1259         ComptrollerInterface comptroller_,
1260         InterestRateModel interestRateModel_,
1261         uint initialExchangeRateMantissa_,
1262         string memory name_,
1263         string memory symbol_,
1264         uint8 decimals_, uint borrowFee_, uint redeemFee_, address payable  feeTo_) public {
1265         require(msg.sender == admin, "only admin may initialize the market");
1266         require(accrualBlockNumber == 0 && borrowIndex == 0, "market may only be initialized once");
1267 
1268         // Set initial exchange rate
1269         initialExchangeRateMantissa = initialExchangeRateMantissa_;
1270         require(initialExchangeRateMantissa > 0, "initial exchange rate must be greater than zero.");
1271 
1272         // Set the comptroller
1273         uint err = _setComptroller(comptroller_);
1274         require(err == uint(Error.NO_ERROR), "setting comptroller failed");
1275 
1276         // Initialize block number and borrow index (block number mocks depend on comptroller being set)
1277         accrualBlockNumber = getBlockNumber();
1278         borrowIndex = mantissaOne;
1279 
1280         // Set the interest rate model (depends on block number / borrow index)
1281         err = _setInterestRateModelFresh(interestRateModel_);
1282         require(err == uint(Error.NO_ERROR), "setting interest rate model failed");
1283 
1284         _setBorrowFee(borrowFee_);
1285         _setRedeemFee(redeemFee_);
1286         _setFeeTo(feeTo_);
1287 
1288         name = name_;
1289         symbol = symbol_;
1290         decimals = decimals_;
1291         underlying = underlying_;
1292 
1293         // The counter starts true to prevent changing it from zero to non-zero (i.e. smaller cost/refund)
1294         _notEntered = true;
1295 
1296     }
1297 
1298     /**
1299     * @notice .
1300     * @dev Admin function: change  borrowFee.
1301     * @param newBorrowFee  newBorrowFee
1302     * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
1303     */
1304     function _setBorrowFee(uint newBorrowFee) public returns (uint) {
1305         // Check caller = admin
1306         if (msg.sender != admin) {
1307             return fail(Error.UNAUTHORIZED, FailureInfo.SET_PENDING_ADMIN_OWNER_CHECK);
1308         }
1309 
1310         require(newBorrowFee <= MAX_BORROW_REDEEM_FEE, "newBorrowFee is greater than MAX_BORROW_REDEEM_FEE");
1311 
1312         emit NewBorrowFee(borrowFee, newBorrowFee);
1313 
1314         borrowFee = newBorrowFee;
1315 
1316         return uint(Error.NO_ERROR);
1317     }
1318 
1319 
1320     /**
1321     * @notice .
1322     * @dev Admin function: change  redeemFee.
1323     * @param newRedeemFee newRedeemFee
1324     * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
1325     */
1326     function _setRedeemFee(uint newRedeemFee) public returns (uint) {
1327         // Check caller = admin
1328         if (msg.sender != admin) {
1329             return fail(Error.UNAUTHORIZED, FailureInfo.SET_PENDING_ADMIN_OWNER_CHECK);
1330         }
1331 
1332         require(newRedeemFee <= MAX_BORROW_REDEEM_FEE, "newRedeemFee is greater than MAX_BORROW_REDEEM_FEE");
1333 
1334         emit NewBorrowFee(redeemFee, newRedeemFee);
1335 
1336         redeemFee = newRedeemFee;
1337 
1338         return uint(Error.NO_ERROR);
1339     }
1340 
1341     /**
1342     * @notice .
1343     * @dev Admin function: change  feeTo.
1344     * @param newFeeTo newFeeTo
1345     * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
1346     */
1347     function _setFeeTo(address payable newFeeTo) public returns (uint) {
1348         // Check caller = admin
1349         if (msg.sender != admin) {
1350             return fail(Error.UNAUTHORIZED, FailureInfo.SET_PENDING_ADMIN_OWNER_CHECK);
1351         }
1352 
1353         require(newFeeTo != address(0), "newFeeTo is zero address");
1354 
1355         emit NewFeeTo(feeTo, newFeeTo);
1356 
1357         feeTo = newFeeTo;
1358 
1359         return uint(Error.NO_ERROR);
1360     }
1361 
1362     /**
1363      * @notice Transfer `tokens` tokens from `src` to `dst` by `spender`
1364      * @dev Called by both `transfer` and `transferFrom` internally
1365      * @param spender The address of the account performing the transfer
1366      * @param src The address of the source account
1367      * @param dst The address of the destination account
1368      * @param tokens The number of tokens to transfer
1369      * @return Whether or not the transfer succeeded
1370      */
1371     function transferTokens(address spender, address src, address dst, uint tokens) internal returns (uint) {
1372         /* Fail if transfer not allowed */
1373         uint allowed = comptroller.transferAllowed(address(this), src, dst, tokens);
1374         if (allowed != 0) {
1375             return failOpaque(Error.COMPTROLLER_REJECTION, FailureInfo.TRANSFER_COMPTROLLER_REJECTION, allowed);
1376         }
1377 
1378         /* Do not allow self-transfers */
1379         if (src == dst) {
1380             return fail(Error.BAD_INPUT, FailureInfo.TRANSFER_NOT_ALLOWED);
1381         }
1382 
1383         /* Get the allowance, infinite for the account owner */
1384         uint startingAllowance = 0;
1385         if (spender == src) {
1386             startingAllowance = uint(-1);
1387         } else {
1388             startingAllowance = transferAllowances[src][spender];
1389         }
1390 
1391         /* Do the calculations, checking for {under,over}flow */
1392         MathError mathErr;
1393         uint allowanceNew;
1394         uint srcTokensNew;
1395         uint dstTokensNew;
1396 
1397         (mathErr, allowanceNew) = subUInt(startingAllowance, tokens);
1398         if (mathErr != MathError.NO_ERROR) {
1399             return fail(Error.MATH_ERROR, FailureInfo.TRANSFER_NOT_ALLOWED);
1400         }
1401 
1402         (mathErr, srcTokensNew) = subUInt(accountTokens[src], tokens);
1403         if (mathErr != MathError.NO_ERROR) {
1404             return fail(Error.MATH_ERROR, FailureInfo.TRANSFER_NOT_ENOUGH);
1405         }
1406 
1407         (mathErr, dstTokensNew) = addUInt(accountTokens[dst], tokens);
1408         if (mathErr != MathError.NO_ERROR) {
1409             return fail(Error.MATH_ERROR, FailureInfo.TRANSFER_TOO_MUCH);
1410         }
1411 
1412         /////////////////////////
1413         // EFFECTS & INTERACTIONS
1414         // (No safe failures beyond this point)
1415 
1416         accountTokens[src] = srcTokensNew;
1417         accountTokens[dst] = dstTokensNew;
1418 
1419         /* Eat some of the allowance (if necessary) */
1420         if (startingAllowance != uint(-1)) {
1421             transferAllowances[src][spender] = allowanceNew;
1422         }
1423 
1424         /* We emit a Transfer event */
1425         emit Transfer(src, dst, tokens);
1426 
1427         comptroller.transferVerify(address(this), src, dst, tokens);
1428 
1429         return uint(Error.NO_ERROR);
1430     }
1431 
1432     /**
1433      * @notice Transfer `amount` tokens from `msg.sender` to `dst`
1434      * @param dst The address of the destination account
1435      * @param amount The number of tokens to transfer
1436      * @return Whether or not the transfer succeeded
1437      */
1438     function transfer(address dst, uint256 amount) external nonReentrant returns (bool) {
1439         return transferTokens(msg.sender, msg.sender, dst, amount) == uint(Error.NO_ERROR);
1440     }
1441 
1442     /**
1443      * @notice Transfer `amount` tokens from `src` to `dst`
1444      * @param src The address of the source account
1445      * @param dst The address of the destination account
1446      * @param amount The number of tokens to transfer
1447      * @return Whether or not the transfer succeeded
1448      */
1449     function transferFrom(address src, address dst, uint256 amount) external nonReentrant returns (bool) {
1450         return transferTokens(msg.sender, src, dst, amount) == uint(Error.NO_ERROR);
1451     }
1452 
1453     /**
1454      * @notice Approve `spender` to transfer up to `amount` from `src`
1455      * @dev This will overwrite the approval amount for `spender`
1456      *  and is subject to issues noted [here](https://eips.ethereum.org/EIPS/eip-20#approve)
1457      * @param spender The address of the account which may transfer tokens
1458      * @param amount The number of tokens that are approved (-1 means infinite)
1459      * @return Whether or not the approval succeeded
1460      */
1461     function approve(address spender, uint256 amount) external returns (bool) {
1462         address src = msg.sender;
1463         transferAllowances[src][spender] = amount;
1464         emit Approval(src, spender, amount);
1465         return true;
1466     }
1467 
1468     /**
1469      * @notice Get the current allowance from `owner` for `spender`
1470      * @param owner The address of the account which owns the tokens to be spent
1471      * @param spender The address of the account which may transfer tokens
1472      * @return The number of tokens allowed to be spent (-1 means infinite)
1473      */
1474     function allowance(address owner, address spender) external view returns (uint256) {
1475         return transferAllowances[owner][spender];
1476     }
1477 
1478     /**
1479      * @notice Get the token balance of the `owner`
1480      * @param owner The address of the account to query
1481      * @return The number of tokens owned by `owner`
1482      */
1483     function balanceOf(address owner) external view returns (uint256) {
1484         return accountTokens[owner];
1485     }
1486 
1487     /**
1488      * @notice Get the underlying balance of the `owner`
1489      * @dev This also accrues interest in a transaction
1490      * @param owner The address of the account to query
1491      * @return The amount of underlying owned by `owner`
1492      */
1493     function balanceOfUnderlying(address owner) external returns (uint) {
1494         Exp memory exchangeRate = Exp({mantissa: exchangeRateCurrent()});
1495         (MathError mErr, uint balance) = mulScalarTruncate(exchangeRate, accountTokens[owner]);
1496         require(mErr == MathError.NO_ERROR, "balance could not be calculated");
1497         return balance;
1498     }
1499 
1500     /**
1501      * @notice Get a snapshot of the account's balances, and the cached exchange rate
1502      * @dev This is used by comptroller to more efficiently perform liquidity checks.
1503      * @param account Address of the account to snapshot
1504      * @return (possible error, token balance, borrow balance, exchange rate mantissa)
1505      */
1506     function getAccountSnapshot(address account) external view returns (uint, uint, uint, uint) {
1507         uint cTokenBalance = accountTokens[account];
1508         uint borrowBalance;
1509         uint exchangeRateMantissa;
1510 
1511         MathError mErr;
1512 
1513         (mErr, borrowBalance) = borrowBalanceStoredInternal(account);
1514         if (mErr != MathError.NO_ERROR) {
1515             return (uint(Error.MATH_ERROR), 0, 0, 0);
1516         }
1517 
1518         (mErr, exchangeRateMantissa) = exchangeRateStoredInternal();
1519         if (mErr != MathError.NO_ERROR) {
1520             return (uint(Error.MATH_ERROR), 0, 0, 0);
1521         }
1522 
1523         return (uint(Error.NO_ERROR), cTokenBalance, borrowBalance, exchangeRateMantissa);
1524     }
1525 
1526     /**
1527      * @dev Function to simply retrieve block number
1528      *  This exists mainly for inheriting test contracts to stub this result.
1529      */
1530     function getBlockNumber() internal view returns (uint) {
1531         return block.number;
1532     }
1533 
1534     /**
1535      * @notice Returns the current per-block borrow interest rate for this gToken
1536      * @return The borrow interest rate per block, scaled by 1e18
1537      */
1538     function borrowRatePerBlock() external view returns (uint) {
1539         return interestRateModel.getBorrowRate(getCashPrior(), totalBorrows, totalReserves);
1540     }
1541 
1542     /**
1543      * @notice Returns the current per-block supply interest rate for this gToken
1544      * @return The supply interest rate per block, scaled by 1e18
1545      */
1546     function supplyRatePerBlock() external view returns (uint) {
1547         return interestRateModel.getSupplyRate(getCashPrior(), totalBorrows, totalReserves, reserveFactorMantissa);
1548     }
1549 
1550     /**
1551      * @notice Returns the current total borrows plus accrued interest
1552      * @return The total borrows with interest
1553      */
1554     function totalBorrowsCurrent() external nonReentrant returns (uint) {
1555         require(accrueInterest() == uint(Error.NO_ERROR), "accrue interest failed");
1556         return totalBorrows;
1557     }
1558 
1559     /**
1560      * @notice Accrue interest to updated borrowIndex and then calculate account's borrow balance using the updated borrowIndex
1561      * @param account The address whose balance should be calculated after updating borrowIndex
1562      * @return The calculated balance
1563      */
1564     function borrowBalanceCurrent(address account) external nonReentrant returns (uint) {
1565         require(accrueInterest() == uint(Error.NO_ERROR), "accrue interest failed");
1566         return borrowBalanceStored(account);
1567     }
1568 
1569     /**
1570      * @notice Return the borrow balance of account based on stored data
1571      * @param account The address whose balance should be calculated
1572      * @return The calculated balance
1573      */
1574     function borrowBalanceStored(address account) public view returns (uint) {
1575         (MathError err, uint result) = borrowBalanceStoredInternal(account);
1576         require(err == MathError.NO_ERROR, "borrowBalanceStored: borrowBalanceStoredInternal failed");
1577         return result;
1578     }
1579 
1580     /**
1581      * @notice Return the borrow balance of account based on stored data
1582      * @param account The address whose balance should be calculated
1583      * @return (error code, the calculated balance or 0 if error code is non-zero)
1584      */
1585     function borrowBalanceStoredInternal(address account) internal view returns (MathError, uint) {
1586         /* Note: we do not assert that the market is up to date */
1587         MathError mathErr;
1588         uint principalTimesIndex;
1589         uint result;
1590 
1591         /* Get borrowBalance and borrowIndex */
1592         BorrowSnapshot storage borrowSnapshot = accountBorrows[account];
1593 
1594         /* If borrowBalance = 0 then borrowIndex is likely also 0.
1595          * Rather than failing the calculation with a division by 0, we immediately return 0 in this case.
1596          */
1597         if (borrowSnapshot.principal == 0) {
1598             return (MathError.NO_ERROR, 0);
1599         }
1600 
1601         /* Calculate new borrow balance using the interest index:
1602          *  recentBorrowBalance = borrower.borrowBalance * market.borrowIndex / borrower.borrowIndex
1603          */
1604         (mathErr, principalTimesIndex) = mulUInt(borrowSnapshot.principal, borrowIndex);
1605         if (mathErr != MathError.NO_ERROR) {
1606             return (mathErr, 0);
1607         }
1608 
1609         (mathErr, result) = divUInt(principalTimesIndex, borrowSnapshot.interestIndex);
1610         if (mathErr != MathError.NO_ERROR) {
1611             return (mathErr, 0);
1612         }
1613 
1614         return (MathError.NO_ERROR, result);
1615     }
1616 
1617     /**
1618      * @notice Accrue interest then return the up-to-date exchange rate
1619      * @return Calculated exchange rate scaled by 1e18
1620      */
1621     function exchangeRateCurrent() public nonReentrant returns (uint) {
1622         require(accrueInterest() == uint(Error.NO_ERROR), "accrue interest failed");
1623         return exchangeRateStored();
1624     }
1625 
1626     /**
1627      * @notice Calculates the exchange rate from the underlying to the GToken
1628      * @dev This function does not accrue interest before calculating the exchange rate
1629      * @return Calculated exchange rate scaled by 1e18
1630      */
1631     function exchangeRateStored() public view returns (uint) {
1632         (MathError err, uint result) = exchangeRateStoredInternal();
1633         require(err == MathError.NO_ERROR, "exchangeRateStored: exchangeRateStoredInternal failed");
1634         return result;
1635     }
1636 
1637     /**
1638      * @notice Calculates the exchange rate from the underlying to the GToken
1639      * @dev This function does not accrue interest before calculating the exchange rate
1640      * @return (error code, calculated exchange rate scaled by 1e18)
1641      */
1642     function exchangeRateStoredInternal() internal view returns (MathError, uint) {
1643         uint _totalSupply = totalSupply;
1644         if (_totalSupply == 0) {
1645             /*
1646              * If there are no tokens minted:
1647              *  exchangeRate = initialExchangeRate
1648              */
1649             return (MathError.NO_ERROR, initialExchangeRateMantissa);
1650         } else {
1651             /*
1652              * Otherwise:
1653              *  exchangeRate = (totalCash + totalBorrows - totalReserves) / totalSupply
1654              */
1655             uint totalCash = getCashPrior();
1656             uint cashPlusBorrowsMinusReserves;
1657             Exp memory exchangeRate;
1658             MathError mathErr;
1659 
1660             (mathErr, cashPlusBorrowsMinusReserves) = addThenSubUInt(totalCash, totalBorrows, totalReserves);
1661             if (mathErr != MathError.NO_ERROR) {
1662                 return (mathErr, 0);
1663             }
1664 
1665             (mathErr, exchangeRate) = getExp(cashPlusBorrowsMinusReserves, _totalSupply);
1666             if (mathErr != MathError.NO_ERROR) {
1667                 return (mathErr, 0);
1668             }
1669 
1670             return (MathError.NO_ERROR, exchangeRate.mantissa);
1671         }
1672     }
1673 
1674     /**
1675      * @notice Get cash balance of this gToken in the underlying asset
1676      * @return The quantity of underlying asset owned by this contract
1677      */
1678     function getCash() external view returns (uint) {
1679         return getCashPrior();
1680     }
1681 
1682     /**
1683      * @notice Applies accrued interest to total borrows and reserves
1684      * @dev This calculates interest accrued from the last checkpointed block
1685      *   up to the current block and writes new checkpoint to storage.
1686      */
1687     function accrueInterest() public returns (uint) {
1688         /* Remember the initial block number */
1689         uint currentBlockNumber = getBlockNumber();
1690         uint accrualBlockNumberPrior = accrualBlockNumber;
1691 
1692         /* Short-circuit accumulating 0 interest */
1693         if (accrualBlockNumberPrior == currentBlockNumber) {
1694             return uint(Error.NO_ERROR);
1695         }
1696 
1697         /* Read the previous values out of storage */
1698         uint cashPrior = getCashPrior();
1699         uint borrowsPrior = totalBorrows;
1700         uint reservesPrior = totalReserves;
1701         uint borrowIndexPrior = borrowIndex;
1702 
1703         /* Calculate the current borrow interest rate */
1704         uint borrowRateMantissa = interestRateModel.getBorrowRate(cashPrior, borrowsPrior, reservesPrior);
1705         require(borrowRateMantissa <= borrowRateMaxMantissa, "borrow rate is absurdly high");
1706 
1707         /* Calculate the number of blocks elapsed since the last accrual */
1708         (MathError mathErr, uint blockDelta) = subUInt(currentBlockNumber, accrualBlockNumberPrior);
1709         require(mathErr == MathError.NO_ERROR, "could not calculate block delta");
1710 
1711         /*
1712          * Calculate the interest accumulated into borrows and reserves and the new index:
1713          *  simpleInterestFactor = borrowRate * blockDelta
1714          *  interestAccumulated = simpleInterestFactor * totalBorrows
1715          *  totalBorrowsNew = interestAccumulated + totalBorrows
1716          *  totalReservesNew = interestAccumulated * reserveFactor + totalReserves
1717          *  borrowIndexNew = simpleInterestFactor * borrowIndex + borrowIndex
1718          */
1719 
1720         Exp memory simpleInterestFactor;
1721         uint interestAccumulated;
1722         uint totalBorrowsNew;
1723         uint totalReservesNew;
1724         uint borrowIndexNew;
1725 
1726         (mathErr, simpleInterestFactor) = mulScalar(Exp({mantissa: borrowRateMantissa}), blockDelta);
1727         if (mathErr != MathError.NO_ERROR) {
1728             return failOpaque(Error.MATH_ERROR, FailureInfo.ACCRUE_INTEREST_SIMPLE_INTEREST_FACTOR_CALCULATION_FAILED, uint(mathErr));
1729         }
1730 
1731         (mathErr, interestAccumulated) = mulScalarTruncate(simpleInterestFactor, borrowsPrior);
1732         if (mathErr != MathError.NO_ERROR) {
1733             return failOpaque(Error.MATH_ERROR, FailureInfo.ACCRUE_INTEREST_ACCUMULATED_INTEREST_CALCULATION_FAILED, uint(mathErr));
1734         }
1735 
1736         (mathErr, totalBorrowsNew) = addUInt(interestAccumulated, borrowsPrior);
1737         if (mathErr != MathError.NO_ERROR) {
1738             return failOpaque(Error.MATH_ERROR, FailureInfo.ACCRUE_INTEREST_NEW_TOTAL_BORROWS_CALCULATION_FAILED, uint(mathErr));
1739         }
1740 
1741         (mathErr, totalReservesNew) = mulScalarTruncateAddUInt(Exp({mantissa: reserveFactorMantissa}), interestAccumulated, reservesPrior);
1742         if (mathErr != MathError.NO_ERROR) {
1743             return failOpaque(Error.MATH_ERROR, FailureInfo.ACCRUE_INTEREST_NEW_TOTAL_RESERVES_CALCULATION_FAILED, uint(mathErr));
1744         }
1745 
1746         (mathErr, borrowIndexNew) = mulScalarTruncateAddUInt(simpleInterestFactor, borrowIndexPrior, borrowIndexPrior);
1747         if (mathErr != MathError.NO_ERROR) {
1748             return failOpaque(Error.MATH_ERROR, FailureInfo.ACCRUE_INTEREST_NEW_BORROW_INDEX_CALCULATION_FAILED, uint(mathErr));
1749         }
1750 
1751         /////////////////////////
1752         // EFFECTS & INTERACTIONS
1753         // (No safe failures beyond this point)
1754 
1755         /* We write the previously calculated values into storage */
1756         accrualBlockNumber = currentBlockNumber;
1757         borrowIndex = borrowIndexNew;
1758         totalBorrows = totalBorrowsNew;
1759         totalReserves = totalReservesNew;
1760 
1761         /* We emit an AccrueInterest event */
1762         emit AccrueInterest(cashPrior, interestAccumulated, borrowIndexNew, totalBorrowsNew);
1763 
1764         return uint(Error.NO_ERROR);
1765     }
1766 
1767     /**
1768      * @notice Sender supplies assets into the market and receives cTokens in exchange
1769      * @dev Accrues interest whether or not the operation succeeds, unless reverted
1770      * @param mintAmount The amount of the underlying asset to supply
1771      * @return (uint, uint) An error code (0=success, otherwise a failure, see ErrorReporter.sol), and the actual mint amount.
1772      */
1773     function mintInternal(uint mintAmount) internal nonReentrant returns (uint, uint) {
1774         uint error = accrueInterest();
1775         if (error != uint(Error.NO_ERROR)) {
1776             // accrueInterest emits logs on errors, but we still want to log the fact that an attempted borrow failed
1777             return (fail(Error(error), FailureInfo.MINT_ACCRUE_INTEREST_FAILED), 0);
1778         }
1779         // mintFresh emits the actual Mint event if successful and logs on errors, so we don't need to
1780         return mintFresh(msg.sender, mintAmount);
1781     }
1782 
1783     struct MintLocalVars {
1784         Error err;
1785         MathError mathErr;
1786         uint exchangeRateMantissa;
1787         uint mintTokens;
1788         uint totalSupplyNew;
1789         uint accountTokensNew;
1790         uint actualMintAmount;
1791     }
1792 
1793     /**
1794      * @notice User supplies assets into the market and receives cTokens in exchange
1795      * @dev Assumes interest has already been accrued up to the current block
1796      * @param minter The address of the account which is supplying the assets
1797      * @param mintAmount The amount of the underlying asset to supply
1798      * @return (uint, uint) An error code (0=success, otherwise a failure, see ErrorReporter.sol), and the actual mint amount.
1799      */
1800     function mintFresh(address minter, uint mintAmount) internal returns (uint, uint) {
1801         /* Fail if mint not allowed */
1802         uint allowed = comptroller.mintAllowed(address(this), minter, mintAmount);
1803         if (allowed != 0) {
1804             return (failOpaque(Error.COMPTROLLER_REJECTION, FailureInfo.MINT_COMPTROLLER_REJECTION, allowed), 0);
1805         }
1806 
1807         /* Verify market's block number equals current block number */
1808         if (accrualBlockNumber != getBlockNumber()) {
1809             return (fail(Error.MARKET_NOT_FRESH, FailureInfo.MINT_FRESHNESS_CHECK), 0);
1810         }
1811 
1812         MintLocalVars memory vars;
1813 
1814         (vars.mathErr, vars.exchangeRateMantissa) = exchangeRateStoredInternal();
1815         if (vars.mathErr != MathError.NO_ERROR) {
1816             return (failOpaque(Error.MATH_ERROR, FailureInfo.MINT_EXCHANGE_RATE_READ_FAILED, uint(vars.mathErr)), 0);
1817         }
1818 
1819         /////////////////////////
1820         // EFFECTS & INTERACTIONS
1821         // (No safe failures beyond this point)
1822 
1823         /*
1824          *  We call `doTransferIn` for the minter and the mintAmount.
1825          *  Note: The gToken must handle variations between ERC-20 and ETH underlying.
1826          *  `doTransferIn` reverts if anything goes wrong, since we can't be sure if
1827          *  side-effects occurred. The function returns the amount actually transferred,
1828          *  in case of a fee. On success, the gToken holds an additional `actualMintAmount`
1829          *  of cash.
1830          */
1831         vars.actualMintAmount = doTransferIn(minter, mintAmount);
1832 
1833         /*
1834          * We get the current exchange rate and calculate the number of cTokens to be minted:
1835          *  mintTokens = actualMintAmount / exchangeRate
1836          */
1837 
1838         (vars.mathErr, vars.mintTokens) = divScalarByExpTruncate(vars.actualMintAmount, Exp({mantissa: vars.exchangeRateMantissa}));
1839         require(vars.mathErr == MathError.NO_ERROR, "MINT_EXCHANGE_CALCULATION_FAILED");
1840 
1841         /*
1842          * We calculate the new total supply of cTokens and minter token balance, checking for overflow:
1843          *  totalSupplyNew = totalSupply + mintTokens
1844          *  accountTokensNew = accountTokens[minter] + mintTokens
1845          */
1846         (vars.mathErr, vars.totalSupplyNew) = addUInt(totalSupply, vars.mintTokens);
1847         require(vars.mathErr == MathError.NO_ERROR, "MINT_NEW_TOTAL_SUPPLY_CALCULATION_FAILED");
1848 
1849         (vars.mathErr, vars.accountTokensNew) = addUInt(accountTokens[minter], vars.mintTokens);
1850         require(vars.mathErr == MathError.NO_ERROR, "MINT_NEW_ACCOUNT_BALANCE_CALCULATION_FAILED");
1851 
1852         /* We write previously calculated values into storage */
1853         totalSupply = vars.totalSupplyNew;
1854         accountTokens[minter] = vars.accountTokensNew;
1855 
1856         /* We emit a Mint event, and a Transfer event */
1857         emit Mint(minter, vars.actualMintAmount, vars.mintTokens);
1858         emit Transfer(address(this), minter, vars.mintTokens);
1859 
1860         /* We call the defense hook */
1861         comptroller.mintVerify(address(this), minter, vars.actualMintAmount, vars.mintTokens);
1862 
1863         return (uint(Error.NO_ERROR), vars.actualMintAmount);
1864     }
1865 
1866     /**
1867      * @notice Sender redeems cTokens in exchange for the underlying asset
1868      * @dev Accrues interest whether or not the operation succeeds, unless reverted
1869      * @param redeemTokens The number of cTokens to redeem into underlying
1870      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
1871      */
1872     function redeemInternal(uint redeemTokens) internal nonReentrant returns (uint) {
1873         uint error = accrueInterest();
1874         if (error != uint(Error.NO_ERROR)) {
1875             // accrueInterest emits logs on errors, but we still want to log the fact that an attempted redeem failed
1876             return fail(Error(error), FailureInfo.REDEEM_ACCRUE_INTEREST_FAILED);
1877         }
1878         // redeemFresh emits redeem-specific logs on errors, so we don't need to
1879         return redeemFresh(msg.sender, redeemTokens, 0);
1880     }
1881 
1882     /**
1883      * @notice Sender redeems cTokens in exchange for a specified amount of underlying asset
1884      * @dev Accrues interest whether or not the operation succeeds, unless reverted
1885      * @param redeemAmount The amount of underlying to receive from redeeming cTokens
1886      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
1887      */
1888     function redeemUnderlyingInternal(uint redeemAmount) internal nonReentrant returns (uint) {
1889         uint error = accrueInterest();
1890         if (error != uint(Error.NO_ERROR)) {
1891             // accrueInterest emits logs on errors, but we still want to log the fact that an attempted redeem failed
1892             return fail(Error(error), FailureInfo.REDEEM_ACCRUE_INTEREST_FAILED);
1893         }
1894         // redeemFresh emits redeem-specific logs on errors, so we don't need to
1895         return redeemFresh(msg.sender, 0, redeemAmount);
1896     }
1897 
1898     struct RedeemLocalVars {
1899         Error err;
1900         MathError mathErr;
1901         uint exchangeRateMantissa;
1902         uint redeemTokens;
1903         uint redeemAmount;
1904         uint totalSupplyNew;
1905         uint accountTokensNew;
1906     }
1907 
1908     /**
1909      * @notice User redeems cTokens in exchange for the underlying asset
1910      * @dev Assumes interest has already been accrued up to the current block
1911      * @param redeemer The address of the account which is redeeming the tokens
1912      * @param redeemTokensIn The number of cTokens to redeem into underlying (only one of redeemTokensIn or redeemAmountIn may be non-zero)
1913      * @param redeemAmountIn The number of underlying tokens to receive from redeeming cTokens (only one of redeemTokensIn or redeemAmountIn may be non-zero)
1914      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
1915      */
1916     function redeemFresh(address payable redeemer, uint redeemTokensIn, uint redeemAmountIn) internal returns (uint) {
1917         require(redeemTokensIn == 0 || redeemAmountIn == 0, "one of redeemTokensIn or redeemAmountIn must be zero");
1918 
1919         RedeemLocalVars memory vars;
1920 
1921         /* exchangeRate = invoke Exchange Rate Stored() */
1922         (vars.mathErr, vars.exchangeRateMantissa) = exchangeRateStoredInternal();
1923         if (vars.mathErr != MathError.NO_ERROR) {
1924             return failOpaque(Error.MATH_ERROR, FailureInfo.REDEEM_EXCHANGE_RATE_READ_FAILED, uint(vars.mathErr));
1925         }
1926 
1927         /* If redeemTokensIn > 0: */
1928         if (redeemTokensIn > 0) {
1929             /*
1930              * We calculate the exchange rate and the amount of underlying to be redeemed:
1931              *  redeemTokens = redeemTokensIn
1932              *  redeemAmount = redeemTokensIn x exchangeRateCurrent
1933              */
1934             vars.redeemTokens = redeemTokensIn;
1935 
1936             (vars.mathErr, vars.redeemAmount) = mulScalarTruncate(Exp({mantissa: vars.exchangeRateMantissa}), redeemTokensIn);
1937             if (vars.mathErr != MathError.NO_ERROR) {
1938                 return failOpaque(Error.MATH_ERROR, FailureInfo.REDEEM_EXCHANGE_TOKENS_CALCULATION_FAILED, uint(vars.mathErr));
1939             }
1940         } else {
1941             /*
1942              * We get the current exchange rate and calculate the amount to be redeemed:
1943              *  redeemTokens = redeemAmountIn / exchangeRate
1944              *  redeemAmount = redeemAmountIn
1945              */
1946 
1947             (vars.mathErr, vars.redeemTokens) = divScalarByExpTruncate(redeemAmountIn, Exp({mantissa: vars.exchangeRateMantissa}));
1948             if (vars.mathErr != MathError.NO_ERROR) {
1949                 return failOpaque(Error.MATH_ERROR, FailureInfo.REDEEM_EXCHANGE_AMOUNT_CALCULATION_FAILED, uint(vars.mathErr));
1950             }
1951 
1952             vars.redeemAmount = redeemAmountIn;
1953         }
1954 
1955         /* Fail if redeem not allowed */
1956         uint allowed = comptroller.redeemAllowed(address(this), redeemer, vars.redeemTokens);
1957         if (allowed != 0) {
1958             return failOpaque(Error.COMPTROLLER_REJECTION, FailureInfo.REDEEM_COMPTROLLER_REJECTION, allowed);
1959         }
1960 
1961         /* Verify market's block number equals current block number */
1962         if (accrualBlockNumber != getBlockNumber()) {
1963             return fail(Error.MARKET_NOT_FRESH, FailureInfo.REDEEM_FRESHNESS_CHECK);
1964         }
1965 
1966         /*
1967          * We calculate the new total supply and redeemer balance, checking for underflow:
1968          *  totalSupplyNew = totalSupply - redeemTokens
1969          *  accountTokensNew = accountTokens[redeemer] - redeemTokens
1970          */
1971         (vars.mathErr, vars.totalSupplyNew) = subUInt(totalSupply, vars.redeemTokens);
1972         if (vars.mathErr != MathError.NO_ERROR) {
1973             return failOpaque(Error.MATH_ERROR, FailureInfo.REDEEM_NEW_TOTAL_SUPPLY_CALCULATION_FAILED, uint(vars.mathErr));
1974         }
1975 
1976         (vars.mathErr, vars.accountTokensNew) = subUInt(accountTokens[redeemer], vars.redeemTokens);
1977         if (vars.mathErr != MathError.NO_ERROR) {
1978             return failOpaque(Error.MATH_ERROR, FailureInfo.REDEEM_NEW_ACCOUNT_BALANCE_CALCULATION_FAILED, uint(vars.mathErr));
1979         }
1980 
1981         /* Fail gracefully if protocol has insufficient cash */
1982         if (getCashPrior() < vars.redeemAmount) {
1983             return fail(Error.TOKEN_INSUFFICIENT_CASH, FailureInfo.REDEEM_TRANSFER_OUT_NOT_POSSIBLE);
1984         }
1985 
1986         /////////////////////////
1987         // EFFECTS & INTERACTIONS
1988         // (No safe failures beyond this point)
1989 
1990         /*
1991          * We invoke doTransferOut for the redeemer and the redeemAmount.
1992          *  Note: The gToken must handle variations between ERC-20 and ETH underlying.
1993          *  On success, the gToken has redeemAmount less of cash.
1994          *  doTransferOut reverts if anything goes wrong, since we can't be sure if side effects occurred.
1995          */
1996 
1997         uint fee = 0;
1998         uint redeemAmountMinusFee = 0;
1999         (vars.mathErr, fee) = mulUInt(vars.redeemAmount, redeemFee);
2000         if (vars.mathErr != MathError.NO_ERROR) {
2001             return failOpaque(Error.MATH_ERROR, FailureInfo.REDEEM_NEW_ACCOUNT_BALANCE_CALCULATION_FAILED, uint(vars.mathErr));
2002         }
2003 
2004         (vars.mathErr, fee) = divUInt(fee, TEN_THOUSAND);
2005         if (vars.mathErr != MathError.NO_ERROR) {
2006             return failOpaque(Error.MATH_ERROR, FailureInfo.REDEEM_NEW_ACCOUNT_BALANCE_CALCULATION_FAILED, uint(vars.mathErr));
2007         }
2008 
2009         (vars.mathErr, redeemAmountMinusFee) = subUInt(vars.redeemAmount, fee);
2010         if (vars.mathErr != MathError.NO_ERROR) {
2011             return failOpaque(Error.MATH_ERROR, FailureInfo.REDEEM_NEW_ACCOUNT_BALANCE_CALCULATION_FAILED, uint(vars.mathErr));
2012         }
2013 
2014         // doTransferOut(redeemer, vars.redeemAmount);
2015         // vars.redeemAmount = redeemAmountMinusFee + fee
2016 
2017         doTransferOut(redeemer, redeemAmountMinusFee);
2018         doTransferOut(feeTo, fee);
2019 
2020         /* We write previously calculated values into storage */
2021         totalSupply = vars.totalSupplyNew;
2022         accountTokens[redeemer] = vars.accountTokensNew;
2023 
2024         /* We emit a Transfer event, and a Redeem event */
2025         emit Transfer(redeemer, address(this), vars.redeemTokens);
2026         emit Redeem(redeemer, vars.redeemAmount, vars.redeemTokens);
2027 
2028         /* We call the defense hook */
2029         comptroller.redeemVerify(address(this), redeemer, vars.redeemAmount, vars.redeemTokens);
2030 
2031         return uint(Error.NO_ERROR);
2032     }
2033 
2034     /**
2035       * @notice Sender borrows assets from the protocol to their own address
2036       * @param borrowAmount The amount of the underlying asset to borrow
2037       * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
2038       */
2039     function borrowInternal(uint borrowAmount) internal nonReentrant returns (uint) {
2040         uint error = accrueInterest();
2041         if (error != uint(Error.NO_ERROR)) {
2042             // accrueInterest emits logs on errors, but we still want to log the fact that an attempted borrow failed
2043             return fail(Error(error), FailureInfo.BORROW_ACCRUE_INTEREST_FAILED);
2044         }
2045         // borrowFresh emits borrow-specific logs on errors, so we don't need to
2046         return borrowFresh(msg.sender, borrowAmount);
2047     }
2048 
2049     struct BorrowLocalVars {
2050         MathError mathErr;
2051         uint accountBorrows;
2052         uint accountBorrowsNew;
2053         uint totalBorrowsNew;
2054     }
2055 
2056     /**
2057       * @notice Users borrow assets from the protocol to their own address
2058       * @param borrowAmount The amount of the underlying asset to borrow
2059       * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
2060       */
2061     function borrowFresh(address payable borrower, uint borrowAmount) internal returns (uint) {
2062         /* Fail if borrow not allowed */
2063         uint allowed = comptroller.borrowAllowed(address(this), borrower, borrowAmount);
2064         if (allowed != 0) {
2065             return failOpaque(Error.COMPTROLLER_REJECTION, FailureInfo.BORROW_COMPTROLLER_REJECTION, allowed);
2066         }
2067 
2068         /* Verify market's block number equals current block number */
2069         if (accrualBlockNumber != getBlockNumber()) {
2070             return fail(Error.MARKET_NOT_FRESH, FailureInfo.BORROW_FRESHNESS_CHECK);
2071         }
2072 
2073         /* Fail gracefully if protocol has insufficient underlying cash */
2074         if (getCashPrior() < borrowAmount) {
2075             return fail(Error.TOKEN_INSUFFICIENT_CASH, FailureInfo.BORROW_CASH_NOT_AVAILABLE);
2076         }
2077 
2078         BorrowLocalVars memory vars;
2079 
2080         /*
2081          * We calculate the new borrower and total borrow balances, failing on overflow:
2082          *  accountBorrowsNew = accountBorrows + borrowAmount
2083          *  totalBorrowsNew = totalBorrows + borrowAmount
2084          */
2085         (vars.mathErr, vars.accountBorrows) = borrowBalanceStoredInternal(borrower);
2086         if (vars.mathErr != MathError.NO_ERROR) {
2087             return failOpaque(Error.MATH_ERROR, FailureInfo.BORROW_ACCUMULATED_BALANCE_CALCULATION_FAILED, uint(vars.mathErr));
2088         }
2089 
2090         (vars.mathErr, vars.accountBorrowsNew) = addUInt(vars.accountBorrows, borrowAmount);
2091         if (vars.mathErr != MathError.NO_ERROR) {
2092             return failOpaque(Error.MATH_ERROR, FailureInfo.BORROW_NEW_ACCOUNT_BORROW_BALANCE_CALCULATION_FAILED, uint(vars.mathErr));
2093         }
2094 
2095         (vars.mathErr, vars.totalBorrowsNew) = addUInt(totalBorrows, borrowAmount);
2096         if (vars.mathErr != MathError.NO_ERROR) {
2097             return failOpaque(Error.MATH_ERROR, FailureInfo.BORROW_NEW_TOTAL_BALANCE_CALCULATION_FAILED, uint(vars.mathErr));
2098         }
2099 
2100         /////////////////////////
2101         // EFFECTS & INTERACTIONS
2102         // (No safe failures beyond this point)
2103 
2104         /*
2105          * We invoke doTransferOut for the borrower and the borrowAmount.
2106          *  Note: The gToken must handle variations between ERC-20 and ETH underlying.
2107          *  On success, the gToken borrowAmount less of cash.
2108          *  doTransferOut reverts if anything goes wrong, since we can't be sure if side effects occurred.
2109          */
2110 
2111         uint fee = 0;
2112         uint borrowAmountMinusFee = 0;
2113         (vars.mathErr, fee) = mulUInt(borrowAmount, borrowFee);
2114         if (vars.mathErr != MathError.NO_ERROR) {
2115             return failOpaque(Error.MATH_ERROR, FailureInfo.BORROW_NEW_ACCOUNT_BORROW_BALANCE_CALCULATION_FAILED, uint(vars.mathErr));
2116         }
2117 
2118         (vars.mathErr, fee) = divUInt(fee, TEN_THOUSAND);
2119         if (vars.mathErr != MathError.NO_ERROR) {
2120             return failOpaque(Error.MATH_ERROR, FailureInfo.BORROW_NEW_ACCOUNT_BORROW_BALANCE_CALCULATION_FAILED, uint(vars.mathErr));
2121         }
2122 
2123         (vars.mathErr, borrowAmountMinusFee) = subUInt(borrowAmount, fee);
2124         if (vars.mathErr != MathError.NO_ERROR) {
2125             return failOpaque(Error.MATH_ERROR, FailureInfo.BORROW_NEW_ACCOUNT_BORROW_BALANCE_CALCULATION_FAILED, uint(vars.mathErr));
2126         }
2127 
2128         doTransferOut(borrower, borrowAmountMinusFee);
2129         doTransferOut(feeTo, fee);
2130 
2131         /* We write the previously calculated values into storage */
2132         accountBorrows[borrower].principal = vars.accountBorrowsNew;
2133         accountBorrows[borrower].interestIndex = borrowIndex;
2134         totalBorrows = vars.totalBorrowsNew;
2135 
2136         /* We emit a Borrow event */
2137         emit Borrow(borrower, borrowAmount, vars.accountBorrowsNew, vars.totalBorrowsNew);
2138 
2139         /* We call the defense hook */
2140         comptroller.borrowVerify(address(this), borrower, borrowAmount);
2141 
2142         return uint(Error.NO_ERROR);
2143     }
2144 
2145     /**
2146      * @notice Sender repays their own borrow
2147      * @param repayAmount The amount to repay
2148      * @return (uint, uint) An error code (0=success, otherwise a failure, see ErrorReporter.sol), and the actual repayment amount.
2149      */
2150     function repayBorrowInternal(uint repayAmount) internal nonReentrant returns (uint, uint) {
2151         uint error = accrueInterest();
2152         if (error != uint(Error.NO_ERROR)) {
2153             // accrueInterest emits logs on errors, but we still want to log the fact that an attempted borrow failed
2154             return (fail(Error(error), FailureInfo.REPAY_BORROW_ACCRUE_INTEREST_FAILED), 0);
2155         }
2156         // repayBorrowFresh emits repay-borrow-specific logs on errors, so we don't need to
2157         return repayBorrowFresh(msg.sender, msg.sender, repayAmount);
2158     }
2159 
2160     /**
2161      * @notice Sender repays a borrow belonging to borrower
2162      * @param borrower the account with the debt being payed off
2163      * @param repayAmount The amount to repay
2164      * @return (uint, uint) An error code (0=success, otherwise a failure, see ErrorReporter.sol), and the actual repayment amount.
2165      */
2166     function repayBorrowBehalfInternal(address borrower, uint repayAmount) internal nonReentrant returns (uint, uint) {
2167         uint error = accrueInterest();
2168         if (error != uint(Error.NO_ERROR)) {
2169             // accrueInterest emits logs on errors, but we still want to log the fact that an attempted borrow failed
2170             return (fail(Error(error), FailureInfo.REPAY_BEHALF_ACCRUE_INTEREST_FAILED), 0);
2171         }
2172         // repayBorrowFresh emits repay-borrow-specific logs on errors, so we don't need to
2173         return repayBorrowFresh(msg.sender, borrower, repayAmount);
2174     }
2175 
2176     struct RepayBorrowLocalVars {
2177         Error err;
2178         MathError mathErr;
2179         uint repayAmount;
2180         uint borrowerIndex;
2181         uint accountBorrows;
2182         uint accountBorrowsNew;
2183         uint totalBorrowsNew;
2184         uint actualRepayAmount;
2185     }
2186 
2187     /**
2188      * @notice Borrows are repaid by another user (possibly the borrower).
2189      * @param payer the account paying off the borrow
2190      * @param borrower the account with the debt being payed off
2191      * @param repayAmount the amount of undelrying tokens being returned
2192      * @return (uint, uint) An error code (0=success, otherwise a failure, see ErrorReporter.sol), and the actual repayment amount.
2193      */
2194     function repayBorrowFresh(address payer, address borrower, uint repayAmount) internal returns (uint, uint) {
2195         /* Fail if repayBorrow not allowed */
2196         uint allowed = comptroller.repayBorrowAllowed(address(this), payer, borrower, repayAmount);
2197         if (allowed != 0) {
2198             return (failOpaque(Error.COMPTROLLER_REJECTION, FailureInfo.REPAY_BORROW_COMPTROLLER_REJECTION, allowed), 0);
2199         }
2200 
2201         /* Verify market's block number equals current block number */
2202         if (accrualBlockNumber != getBlockNumber()) {
2203             return (fail(Error.MARKET_NOT_FRESH, FailureInfo.REPAY_BORROW_FRESHNESS_CHECK), 0);
2204         }
2205 
2206         RepayBorrowLocalVars memory vars;
2207 
2208         /* We remember the original borrowerIndex for verification purposes */
2209         vars.borrowerIndex = accountBorrows[borrower].interestIndex;
2210 
2211         /* We fetch the amount the borrower owes, with accumulated interest */
2212         (vars.mathErr, vars.accountBorrows) = borrowBalanceStoredInternal(borrower);
2213         if (vars.mathErr != MathError.NO_ERROR) {
2214             return (failOpaque(Error.MATH_ERROR, FailureInfo.REPAY_BORROW_ACCUMULATED_BALANCE_CALCULATION_FAILED, uint(vars.mathErr)), 0);
2215         }
2216 
2217         /* If repayAmount == -1, repayAmount = accountBorrows */
2218         if (repayAmount == uint(-1)) {
2219             vars.repayAmount = vars.accountBorrows;
2220         } else {
2221             vars.repayAmount = repayAmount;
2222         }
2223 
2224         /////////////////////////
2225         // EFFECTS & INTERACTIONS
2226         // (No safe failures beyond this point)
2227 
2228         /*
2229          * We call doTransferIn for the payer and the repayAmount
2230          *  Note: The gToken must handle variations between ERC-20 and ETH underlying.
2231          *  On success, the gToken holds an additional repayAmount of cash.
2232          *  doTransferIn reverts if anything goes wrong, since we can't be sure if side effects occurred.
2233          *   it returns the amount actually transferred, in case of a fee.
2234          */
2235         vars.actualRepayAmount = doTransferIn(payer, vars.repayAmount);
2236 
2237         /*
2238          * We calculate the new borrower and total borrow balances, failing on underflow:
2239          *  accountBorrowsNew = accountBorrows - actualRepayAmount
2240          *  totalBorrowsNew = totalBorrows - actualRepayAmount
2241          */
2242         (vars.mathErr, vars.accountBorrowsNew) = subUInt(vars.accountBorrows, vars.actualRepayAmount);
2243         require(vars.mathErr == MathError.NO_ERROR, "REPAY_BORROW_NEW_ACCOUNT_BORROW_BALANCE_CALCULATION_FAILED");
2244 
2245         (vars.mathErr, vars.totalBorrowsNew) = subUInt(totalBorrows, vars.actualRepayAmount);
2246         require(vars.mathErr == MathError.NO_ERROR, "REPAY_BORROW_NEW_TOTAL_BALANCE_CALCULATION_FAILED");
2247 
2248         /* We write the previously calculated values into storage */
2249         accountBorrows[borrower].principal = vars.accountBorrowsNew;
2250         accountBorrows[borrower].interestIndex = borrowIndex;
2251         totalBorrows = vars.totalBorrowsNew;
2252 
2253         /* We emit a RepayBorrow event */
2254         emit RepayBorrow(payer, borrower, vars.actualRepayAmount, vars.accountBorrowsNew, vars.totalBorrowsNew);
2255 
2256         /* We call the defense hook */
2257         comptroller.repayBorrowVerify(address(this), payer, borrower, vars.actualRepayAmount, vars.borrowerIndex);
2258 
2259         return (uint(Error.NO_ERROR), vars.actualRepayAmount);
2260     }
2261 
2262     /**
2263      * @notice The sender liquidates the borrowers collateral.
2264      *  The collateral seized is transferred to the liquidator.
2265      * @param borrower The borrower of this gToken to be liquidated
2266      * @param cTokenCollateral The market in which to seize collateral from the borrower
2267      * @param repayAmount The amount of the underlying borrowed asset to repay
2268      * @return (uint, uint) An error code (0=success, otherwise a failure, see ErrorReporter.sol), and the actual repayment amount.
2269      */
2270     function liquidateBorrowInternal(address borrower, uint repayAmount, GTokenInterface cTokenCollateral) internal nonReentrant returns (uint, uint) {
2271         uint error = accrueInterest();
2272         if (error != uint(Error.NO_ERROR)) {
2273             // accrueInterest emits logs on errors, but we still want to log the fact that an attempted liquidation failed
2274             return (fail(Error(error), FailureInfo.LIQUIDATE_ACCRUE_BORROW_INTEREST_FAILED), 0);
2275         }
2276 
2277         error = cTokenCollateral.accrueInterest();
2278         if (error != uint(Error.NO_ERROR)) {
2279             // accrueInterest emits logs on errors, but we still want to log the fact that an attempted liquidation failed
2280             return (fail(Error(error), FailureInfo.LIQUIDATE_ACCRUE_COLLATERAL_INTEREST_FAILED), 0);
2281         }
2282 
2283         // liquidateBorrowFresh emits borrow-specific logs on errors, so we don't need to
2284         return liquidateBorrowFresh(msg.sender, borrower, repayAmount, cTokenCollateral);
2285     }
2286 
2287     /**
2288      * @notice The liquidator liquidates the borrowers collateral.
2289      *  The collateral seized is transferred to the liquidator.
2290      * @param borrower The borrower of this gToken to be liquidated
2291      * @param liquidator The address repaying the borrow and seizing collateral
2292      * @param cTokenCollateral The market in which to seize collateral from the borrower
2293      * @param repayAmount The amount of the underlying borrowed asset to repay
2294      * @return (uint, uint) An error code (0=success, otherwise a failure, see ErrorReporter.sol), and the actual repayment amount.
2295      */
2296     function liquidateBorrowFresh(address liquidator, address borrower, uint repayAmount, GTokenInterface cTokenCollateral) internal returns (uint, uint) {
2297         /* Fail if liquidate not allowed */
2298         uint allowed = comptroller.liquidateBorrowAllowed(address(this), address(cTokenCollateral), liquidator, borrower, repayAmount);
2299         if (allowed != 0) {
2300             return (failOpaque(Error.COMPTROLLER_REJECTION, FailureInfo.LIQUIDATE_COMPTROLLER_REJECTION, allowed), 0);
2301         }
2302 
2303         /* Verify market's block number equals current block number */
2304         if (accrualBlockNumber != getBlockNumber()) {
2305             return (fail(Error.MARKET_NOT_FRESH, FailureInfo.LIQUIDATE_FRESHNESS_CHECK), 0);
2306         }
2307 
2308         /* Verify cTokenCollateral market's block number equals current block number */
2309         if (cTokenCollateral.accrualBlockNumber() != getBlockNumber()) {
2310             return (fail(Error.MARKET_NOT_FRESH, FailureInfo.LIQUIDATE_COLLATERAL_FRESHNESS_CHECK), 0);
2311         }
2312 
2313         /* Fail if borrower = liquidator */
2314         if (borrower == liquidator) {
2315             return (fail(Error.INVALID_ACCOUNT_PAIR, FailureInfo.LIQUIDATE_LIQUIDATOR_IS_BORROWER), 0);
2316         }
2317 
2318         /* Fail if repayAmount = 0 */
2319         if (repayAmount == 0) {
2320             return (fail(Error.INVALID_CLOSE_AMOUNT_REQUESTED, FailureInfo.LIQUIDATE_CLOSE_AMOUNT_IS_ZERO), 0);
2321         }
2322 
2323         /* Fail if repayAmount = -1 */
2324         if (repayAmount == uint(-1)) {
2325             return (fail(Error.INVALID_CLOSE_AMOUNT_REQUESTED, FailureInfo.LIQUIDATE_CLOSE_AMOUNT_IS_UINT_MAX), 0);
2326         }
2327 
2328 
2329         /* Fail if repayBorrow fails */
2330         (uint repayBorrowError, uint actualRepayAmount) = repayBorrowFresh(liquidator, borrower, repayAmount);
2331         if (repayBorrowError != uint(Error.NO_ERROR)) {
2332             return (fail(Error(repayBorrowError), FailureInfo.LIQUIDATE_REPAY_BORROW_FRESH_FAILED), 0);
2333         }
2334 
2335         /////////////////////////
2336         // EFFECTS & INTERACTIONS
2337         // (No safe failures beyond this point)
2338 
2339         /* We calculate the number of collateral tokens that will be seized */
2340         (uint amountSeizeError, uint seizeTokens) = comptroller.liquidateCalculateSeizeTokens(address(this), address(cTokenCollateral), actualRepayAmount);
2341         require(amountSeizeError == uint(Error.NO_ERROR), "LIQUIDATE_COMPTROLLER_CALCULATE_AMOUNT_SEIZE_FAILED");
2342 
2343         /* Revert if borrower collateral token balance < seizeTokens */
2344         require(cTokenCollateral.balanceOf(borrower) >= seizeTokens, "LIQUIDATE_SEIZE_TOO_MUCH");
2345 
2346         // If this is also the collateral, run seizeInternal to avoid re-entrancy, otherwise make an external call
2347         uint seizeError;
2348         if (address(cTokenCollateral) == address(this)) {
2349             seizeError = seizeInternal(address(this), liquidator, borrower, seizeTokens);
2350         } else {
2351             seizeError = cTokenCollateral.seize(liquidator, borrower, seizeTokens);
2352         }
2353 
2354         /* Revert if seize tokens fails (since we cannot be sure of side effects) */
2355         require(seizeError == uint(Error.NO_ERROR), "token seizure failed");
2356 
2357         /* We emit a LiquidateBorrow event */
2358         emit LiquidateBorrow(liquidator, borrower, actualRepayAmount, address(cTokenCollateral), seizeTokens);
2359 
2360         /* We call the defense hook */
2361         comptroller.liquidateBorrowVerify(address(this), address(cTokenCollateral), liquidator, borrower, actualRepayAmount, seizeTokens);
2362 
2363         return (uint(Error.NO_ERROR), actualRepayAmount);
2364     }
2365 
2366     /**
2367      * @notice Transfers collateral tokens (this market) to the liquidator.
2368      * @dev Will fail unless called by another gToken during the process of liquidation.
2369      *  Its absolutely critical to use msg.sender as the borrowed gToken and not a parameter.
2370      * @param liquidator The account receiving seized collateral
2371      * @param borrower The account having collateral seized
2372      * @param seizeTokens The number of cTokens to seize
2373      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
2374      */
2375     function seize(address liquidator, address borrower, uint seizeTokens) external nonReentrant returns (uint) {
2376         return seizeInternal(msg.sender, liquidator, borrower, seizeTokens);
2377     }
2378 
2379     /**
2380      * @notice Transfers collateral tokens (this market) to the liquidator.
2381      * @dev Called only during an in-kind liquidation, or by liquidateBorrow during the liquidation of another GToken.
2382      *  Its absolutely critical to use msg.sender as the seizer gToken and not a parameter.
2383      * @param seizerToken The contract seizing the collateral (i.e. borrowed gToken)
2384      * @param liquidator The account receiving seized collateral
2385      * @param borrower The account having collateral seized
2386      * @param seizeTokens The number of cTokens to seize
2387      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
2388      */
2389     function seizeInternal(address seizerToken, address liquidator, address borrower, uint seizeTokens) internal returns (uint) {
2390         /* Fail if seize not allowed */
2391         uint allowed = comptroller.seizeAllowed(address(this), seizerToken, liquidator, borrower, seizeTokens);
2392         if (allowed != 0) {
2393             return failOpaque(Error.COMPTROLLER_REJECTION, FailureInfo.LIQUIDATE_SEIZE_COMPTROLLER_REJECTION, allowed);
2394         }
2395 
2396         /* Fail if borrower = liquidator */
2397         if (borrower == liquidator) {
2398             return fail(Error.INVALID_ACCOUNT_PAIR, FailureInfo.LIQUIDATE_SEIZE_LIQUIDATOR_IS_BORROWER);
2399         }
2400 
2401         MathError mathErr;
2402         uint borrowerTokensNew;
2403         uint liquidatorTokensNew;
2404 
2405         /*
2406          * We calculate the new borrower and liquidator token balances, failing on underflow/overflow:
2407          *  borrowerTokensNew = accountTokens[borrower] - seizeTokens
2408          *  liquidatorTokensNew = accountTokens[liquidator] + seizeTokens
2409          */
2410         (mathErr, borrowerTokensNew) = subUInt(accountTokens[borrower], seizeTokens);
2411         if (mathErr != MathError.NO_ERROR) {
2412             return failOpaque(Error.MATH_ERROR, FailureInfo.LIQUIDATE_SEIZE_BALANCE_DECREMENT_FAILED, uint(mathErr));
2413         }
2414 
2415         (mathErr, liquidatorTokensNew) = addUInt(accountTokens[liquidator], seizeTokens);
2416         if (mathErr != MathError.NO_ERROR) {
2417             return failOpaque(Error.MATH_ERROR, FailureInfo.LIQUIDATE_SEIZE_BALANCE_INCREMENT_FAILED, uint(mathErr));
2418         }
2419 
2420         /////////////////////////
2421         // EFFECTS & INTERACTIONS
2422         // (No safe failures beyond this point)
2423 
2424         /* We write the previously calculated values into storage */
2425         accountTokens[borrower] = borrowerTokensNew;
2426         accountTokens[liquidator] = liquidatorTokensNew;
2427 
2428         /* Emit a Transfer event */
2429         emit Transfer(borrower, liquidator, seizeTokens);
2430 
2431         /* We call the defense hook */
2432         comptroller.seizeVerify(address(this), seizerToken, liquidator, borrower, seizeTokens);
2433 
2434         return uint(Error.NO_ERROR);
2435     }
2436 
2437 
2438     /*** Admin Functions ***/
2439 
2440     /**
2441       * @notice Begins transfer of admin rights. The newPendingAdmin must call `_acceptAdmin` to finalize the transfer.
2442       * @dev Admin function to begin change of admin. The newPendingAdmin must call `_acceptAdmin` to finalize the transfer.
2443       * @param newPendingAdmin New pending admin.
2444       * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
2445       */
2446     function _setPendingAdmin(address payable newPendingAdmin) external returns (uint) {
2447         // Check caller = admin
2448         if (msg.sender != admin) {
2449             return fail(Error.UNAUTHORIZED, FailureInfo.SET_PENDING_ADMIN_OWNER_CHECK);
2450         }
2451 
2452         // Save current value, if any, for inclusion in log
2453         address oldPendingAdmin = pendingAdmin;
2454 
2455         // Store pendingAdmin with value newPendingAdmin
2456         pendingAdmin = newPendingAdmin;
2457 
2458         // Emit NewPendingAdmin(oldPendingAdmin, newPendingAdmin)
2459         emit NewPendingAdmin(oldPendingAdmin, newPendingAdmin);
2460 
2461         return uint(Error.NO_ERROR);
2462     }
2463 
2464     /**
2465       * @notice Accepts transfer of admin rights. msg.sender must be pendingAdmin
2466       * @dev Admin function for pending admin to accept role and update admin
2467       * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
2468       */
2469     function _acceptAdmin() external returns (uint) {
2470         // Check caller is pendingAdmin and pendingAdmin ≠ address(0)
2471         if (msg.sender != pendingAdmin || msg.sender == address(0)) {
2472             return fail(Error.UNAUTHORIZED, FailureInfo.ACCEPT_ADMIN_PENDING_ADMIN_CHECK);
2473         }
2474 
2475         // Save current values for inclusion in log
2476         address oldAdmin = admin;
2477         address oldPendingAdmin = pendingAdmin;
2478 
2479         // Store admin with value pendingAdmin
2480         admin = pendingAdmin;
2481 
2482         // Clear the pending value
2483         pendingAdmin = address(0);
2484 
2485         emit NewAdmin(oldAdmin, admin);
2486         emit NewPendingAdmin(oldPendingAdmin, pendingAdmin);
2487 
2488         return uint(Error.NO_ERROR);
2489     }
2490 
2491     /**
2492       * @notice Sets a new comptroller for the market
2493       * @dev Admin function to set a new comptroller
2494       * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
2495       */
2496     function _setComptroller(ComptrollerInterface newComptroller) public returns (uint) {
2497         // Check caller is admin
2498         if (msg.sender != admin) {
2499             return fail(Error.UNAUTHORIZED, FailureInfo.SET_COMPTROLLER_OWNER_CHECK);
2500         }
2501 
2502         ComptrollerInterface oldComptroller = comptroller;
2503         // Ensure invoke comptroller.isComptroller() returns true
2504         require(newComptroller.isComptroller(), "marker method returned false");
2505 
2506         // Set market's comptroller to newComptroller
2507         comptroller = newComptroller;
2508 
2509         // Emit NewComptroller(oldComptroller, newComptroller)
2510         emit NewComptroller(oldComptroller, newComptroller);
2511 
2512         return uint(Error.NO_ERROR);
2513     }
2514 
2515     /**
2516       * @notice accrues interest and sets a new reserve factor for the protocol using _setReserveFactorFresh
2517       * @dev Admin function to accrue interest and set a new reserve factor
2518       * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
2519       */
2520     function _setReserveFactor(uint newReserveFactorMantissa) external nonReentrant returns (uint) {
2521         uint error = accrueInterest();
2522         if (error != uint(Error.NO_ERROR)) {
2523             // accrueInterest emits logs on errors, but on top of that we want to log the fact that an attempted reserve factor change failed.
2524             return fail(Error(error), FailureInfo.SET_RESERVE_FACTOR_ACCRUE_INTEREST_FAILED);
2525         }
2526         // _setReserveFactorFresh emits reserve-factor-specific logs on errors, so we don't need to.
2527         return _setReserveFactorFresh(newReserveFactorMantissa);
2528     }
2529 
2530     /**
2531       * @notice Sets a new reserve factor for the protocol (*requires fresh interest accrual)
2532       * @dev Admin function to set a new reserve factor
2533       * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
2534       */
2535     function _setReserveFactorFresh(uint newReserveFactorMantissa) internal returns (uint) {
2536         // Check caller is admin
2537         if (msg.sender != admin) {
2538             return fail(Error.UNAUTHORIZED, FailureInfo.SET_RESERVE_FACTOR_ADMIN_CHECK);
2539         }
2540 
2541         // Verify market's block number equals current block number
2542         if (accrualBlockNumber != getBlockNumber()) {
2543             return fail(Error.MARKET_NOT_FRESH, FailureInfo.SET_RESERVE_FACTOR_FRESH_CHECK);
2544         }
2545 
2546         // Check newReserveFactor ≤ maxReserveFactor
2547         if (newReserveFactorMantissa > reserveFactorMaxMantissa) {
2548             return fail(Error.BAD_INPUT, FailureInfo.SET_RESERVE_FACTOR_BOUNDS_CHECK);
2549         }
2550 
2551         uint oldReserveFactorMantissa = reserveFactorMantissa;
2552         reserveFactorMantissa = newReserveFactorMantissa;
2553 
2554         emit NewReserveFactor(oldReserveFactorMantissa, newReserveFactorMantissa);
2555 
2556         return uint(Error.NO_ERROR);
2557     }
2558 
2559     /**
2560      * @notice Accrues interest and reduces reserves by transferring from msg.sender
2561      * @param addAmount Amount of addition to reserves
2562      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
2563      */
2564     function _addReservesInternal(uint addAmount) internal nonReentrant returns (uint) {
2565         uint error = accrueInterest();
2566         if (error != uint(Error.NO_ERROR)) {
2567             // accrueInterest emits logs on errors, but on top of that we want to log the fact that an attempted reduce reserves failed.
2568             return fail(Error(error), FailureInfo.ADD_RESERVES_ACCRUE_INTEREST_FAILED);
2569         }
2570 
2571         // _addReservesFresh emits reserve-addition-specific logs on errors, so we don't need to.
2572         (error, ) = _addReservesFresh(addAmount);
2573         return error;
2574     }
2575 
2576     /**
2577      * @notice Add reserves by transferring from caller
2578      * @dev Requires fresh interest accrual
2579      * @param addAmount Amount of addition to reserves
2580      * @return (uint, uint) An error code (0=success, otherwise a failure (see ErrorReporter.sol for details)) and the actual amount added, net token fees
2581      */
2582     function _addReservesFresh(uint addAmount) internal returns (uint, uint) {
2583         // totalReserves + actualAddAmount
2584         uint totalReservesNew;
2585         uint actualAddAmount;
2586 
2587         // We fail gracefully unless market's block number equals current block number
2588         if (accrualBlockNumber != getBlockNumber()) {
2589             return (fail(Error.MARKET_NOT_FRESH, FailureInfo.ADD_RESERVES_FRESH_CHECK), actualAddAmount);
2590         }
2591 
2592         /////////////////////////
2593         // EFFECTS & INTERACTIONS
2594         // (No safe failures beyond this point)
2595 
2596         /*
2597          * We call doTransferIn for the caller and the addAmount
2598          *  Note: The gToken must handle variations between ERC-20 and ETH underlying.
2599          *  On success, the gToken holds an additional addAmount of cash.
2600          *  doTransferIn reverts if anything goes wrong, since we can't be sure if side effects occurred.
2601          *  it returns the amount actually transferred, in case of a fee.
2602          */
2603 
2604         actualAddAmount = doTransferIn(msg.sender, addAmount);
2605 
2606         totalReservesNew = totalReserves + actualAddAmount;
2607 
2608         /* Revert on overflow */
2609         require(totalReservesNew >= totalReserves, "add reserves unexpected overflow");
2610 
2611         // Store reserves[n+1] = reserves[n] + actualAddAmount
2612         totalReserves = totalReservesNew;
2613 
2614         /* Emit NewReserves(admin, actualAddAmount, reserves[n+1]) */
2615         emit ReservesAdded(msg.sender, actualAddAmount, totalReservesNew);
2616 
2617         /* Return (NO_ERROR, actualAddAmount) */
2618         return (uint(Error.NO_ERROR), actualAddAmount);
2619     }
2620 
2621 
2622     /**
2623      * @notice Accrues interest and reduces reserves by transferring to admin
2624      * @param reduceAmount Amount of reduction to reserves
2625      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
2626      */
2627     function _reduceReserves(uint reduceAmount) external nonReentrant returns (uint) {
2628         uint error = accrueInterest();
2629         if (error != uint(Error.NO_ERROR)) {
2630             // accrueInterest emits logs on errors, but on top of that we want to log the fact that an attempted reduce reserves failed.
2631             return fail(Error(error), FailureInfo.REDUCE_RESERVES_ACCRUE_INTEREST_FAILED);
2632         }
2633         // _reduceReservesFresh emits reserve-reduction-specific logs on errors, so we don't need to.
2634         return _reduceReservesFresh(reduceAmount);
2635     }
2636 
2637     /**
2638      * @notice Reduces reserves by transferring to admin
2639      * @dev Requires fresh interest accrual
2640      * @param reduceAmount Amount of reduction to reserves
2641      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
2642      */
2643     function _reduceReservesFresh(uint reduceAmount) internal returns (uint) {
2644         // totalReserves - reduceAmount
2645         uint totalReservesNew;
2646 
2647         // Check caller is admin
2648         if (msg.sender != admin) {
2649             return fail(Error.UNAUTHORIZED, FailureInfo.REDUCE_RESERVES_ADMIN_CHECK);
2650         }
2651 
2652         // We fail gracefully unless market's block number equals current block number
2653         if (accrualBlockNumber != getBlockNumber()) {
2654             return fail(Error.MARKET_NOT_FRESH, FailureInfo.REDUCE_RESERVES_FRESH_CHECK);
2655         }
2656 
2657         // Fail gracefully if protocol has insufficient underlying cash
2658         if (getCashPrior() < reduceAmount) {
2659             return fail(Error.TOKEN_INSUFFICIENT_CASH, FailureInfo.REDUCE_RESERVES_CASH_NOT_AVAILABLE);
2660         }
2661 
2662         // Check reduceAmount ≤ reserves[n] (totalReserves)
2663         if (reduceAmount > totalReserves) {
2664             return fail(Error.BAD_INPUT, FailureInfo.REDUCE_RESERVES_VALIDATION);
2665         }
2666 
2667         /////////////////////////
2668         // EFFECTS & INTERACTIONS
2669         // (No safe failures beyond this point)
2670 
2671         totalReservesNew = totalReserves - reduceAmount;
2672         // We checked reduceAmount <= totalReserves above, so this should never revert.
2673         require(totalReservesNew <= totalReserves, "reduce reserves unexpected underflow");
2674 
2675         // Store reserves[n+1] = reserves[n] - reduceAmount
2676         totalReserves = totalReservesNew;
2677 
2678         // doTransferOut reverts if anything goes wrong, since we can't be sure if side effects occurred.
2679         doTransferOut(admin, reduceAmount);
2680 
2681         emit ReservesReduced(admin, reduceAmount, totalReservesNew);
2682 
2683         return uint(Error.NO_ERROR);
2684     }
2685 
2686     /**
2687      * @notice accrues interest and updates the interest rate model using _setInterestRateModelFresh
2688      * @dev Admin function to accrue interest and update the interest rate model
2689      * @param newInterestRateModel the new interest rate model to use
2690      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
2691      */
2692     function _setInterestRateModel(InterestRateModel newInterestRateModel) public returns (uint) {
2693         uint error = accrueInterest();
2694         if (error != uint(Error.NO_ERROR)) {
2695             // accrueInterest emits logs on errors, but on top of that we want to log the fact that an attempted change of interest rate model failed
2696             return fail(Error(error), FailureInfo.SET_INTEREST_RATE_MODEL_ACCRUE_INTEREST_FAILED);
2697         }
2698         // _setInterestRateModelFresh emits interest-rate-model-update-specific logs on errors, so we don't need to.
2699         return _setInterestRateModelFresh(newInterestRateModel);
2700     }
2701 
2702     /**
2703      * @notice updates the interest rate model (*requires fresh interest accrual)
2704      * @dev Admin function to update the interest rate model
2705      * @param newInterestRateModel the new interest rate model to use
2706      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
2707      */
2708     function _setInterestRateModelFresh(InterestRateModel newInterestRateModel) internal returns (uint) {
2709 
2710         // Used to store old model for use in the event that is emitted on success
2711         InterestRateModel oldInterestRateModel;
2712 
2713         // Check caller is admin
2714         if (msg.sender != admin) {
2715             return fail(Error.UNAUTHORIZED, FailureInfo.SET_INTEREST_RATE_MODEL_OWNER_CHECK);
2716         }
2717 
2718         // We fail gracefully unless market's block number equals current block number
2719         if (accrualBlockNumber != getBlockNumber()) {
2720             return fail(Error.MARKET_NOT_FRESH, FailureInfo.SET_INTEREST_RATE_MODEL_FRESH_CHECK);
2721         }
2722 
2723         // Track the market's current interest rate model
2724         oldInterestRateModel = interestRateModel;
2725 
2726         // Ensure invoke newInterestRateModel.isInterestRateModel() returns true
2727         require(newInterestRateModel.isInterestRateModel(), "marker method returned false");
2728 
2729         // Set the interest rate model to newInterestRateModel
2730         interestRateModel = newInterestRateModel;
2731 
2732         // Emit NewMarketInterestRateModel(oldInterestRateModel, newInterestRateModel)
2733         emit NewMarketInterestRateModel(oldInterestRateModel, newInterestRateModel);
2734 
2735         return uint(Error.NO_ERROR);
2736     }
2737 
2738     /*** Safe Token ***/
2739 
2740     /**
2741      * @notice Gets balance of this contract in terms of the underlying
2742      * @dev This excludes the value of the current message, if any
2743      * @return The quantity of underlying owned by this contract
2744      */
2745     function getCashPrior() internal view returns (uint);
2746 
2747     /**
2748      * @dev Performs a transfer in, reverting upon failure. Returns the amount actually transferred to the protocol, in case of a fee.
2749      *  This may revert due to insufficient balance or insufficient allowance.
2750      */
2751     function doTransferIn(address from, uint amount) internal returns (uint);
2752 
2753     /**
2754      * @dev Performs a transfer out, ideally returning an explanatory error code upon failure tather than reverting.
2755      *  If caller has not called checked protocol's balance, may revert due to insufficient cash held in the contract.
2756      *  If caller has checked protocol's balance, and verified it is >= amount, this should not revert in normal conditions.
2757      */
2758     function doTransferOut(address payable to, uint amount) internal;
2759 
2760 
2761     /*** Reentrancy Guard ***/
2762 
2763     /**
2764      * @dev Prevents a contract from calling itself, directly or indirectly.
2765      */
2766     modifier nonReentrant() {
2767         require(_notEntered, "re-entered");
2768         _notEntered = false;
2769         _;
2770         _notEntered = true; // get a gas-refund post-Istanbul
2771     }
2772 }
2773 
2774 // File: contracts/ZErc20.sol
2775 
2776 pragma solidity 0.5.17;
2777 
2778 
2779 /**
2780  * @title  ZErc20 Contract
2781  * @notice GToken which wrap an EIP-20 underlying
2782  */
2783 contract ZErc20 is GToken, CErc20Interface {
2784 
2785     constructor() public {
2786         admin = msg.sender;
2787         underlyingIsNativeCoin = false;
2788     }
2789 
2790 
2791     /*** User Interface ***/
2792 
2793     /**
2794      * @notice Sender supplies assets into the market and receives cTokens in exchange
2795      * @dev Accrues interest whether or not the operation succeeds, unless reverted
2796      * @param mintAmount The amount of the underlying asset to supply
2797      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
2798      */
2799     function mint(uint mintAmount) external returns (uint) {
2800         (uint err,) = mintInternal(mintAmount);
2801         return err;
2802     }
2803 
2804     /**
2805      * @notice Sender redeems cTokens in exchange for the underlying asset
2806      * @dev Accrues interest whether or not the operation succeeds, unless reverted
2807      * @param redeemTokens The number of cTokens to redeem into underlying
2808      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
2809      */
2810     function redeem(uint redeemTokens) external returns (uint) {
2811         return redeemInternal(redeemTokens);
2812     }
2813 
2814     /**
2815      * @notice Sender redeems cTokens in exchange for a specified amount of underlying asset
2816      * @dev Accrues interest whether or not the operation succeeds, unless reverted
2817      * @param redeemAmount The amount of underlying to redeem
2818      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
2819      */
2820     function redeemUnderlying(uint redeemAmount) external returns (uint) {
2821         return redeemUnderlyingInternal(redeemAmount);
2822     }
2823 
2824     /**
2825       * @notice Sender borrows assets from the protocol to their own address
2826       * @param borrowAmount The amount of the underlying asset to borrow
2827       * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
2828       */
2829     function borrow(uint borrowAmount) external returns (uint) {
2830         return borrowInternal(borrowAmount);
2831     }
2832 
2833     /**
2834      * @notice Sender repays their own borrow
2835      * @param repayAmount The amount to repay
2836      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
2837      */
2838     function repayBorrow(uint repayAmount) external returns (uint) {
2839         (uint err,) = repayBorrowInternal(repayAmount);
2840         return err;
2841     }
2842 
2843     /**
2844      * @notice Sender repays a borrow belonging to borrower
2845      * @param borrower the account with the debt being payed off
2846      * @param repayAmount The amount to repay
2847      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
2848      */
2849     function repayBorrowBehalf(address borrower, uint repayAmount) external returns (uint) {
2850         (uint err,) = repayBorrowBehalfInternal(borrower, repayAmount);
2851         return err;
2852     }
2853 
2854     /**
2855      * @notice The sender liquidates the borrowers collateral.
2856      *  The collateral seized is transferred to the liquidator.
2857      * @param borrower The borrower of this gToken to be liquidated
2858      * @param repayAmount The amount of the underlying borrowed asset to repay
2859      * @param cTokenCollateral The market in which to seize collateral from the borrower
2860      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
2861      */
2862     function liquidateBorrow(address borrower, uint repayAmount, GTokenInterface cTokenCollateral) external returns (uint) {
2863         (uint err,) = liquidateBorrowInternal(borrower, repayAmount, cTokenCollateral);
2864         return err;
2865     }
2866 
2867     /**
2868      * @notice The sender adds to reserves.
2869      * @param addAmount The amount fo underlying token to add as reserves
2870      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
2871      */
2872     function _addReserves(uint addAmount) external returns (uint) {
2873         return _addReservesInternal(addAmount);
2874     }
2875 
2876     /*** Safe Token ***/
2877 
2878     /**
2879      * @notice Gets balance of this contract in terms of the underlying
2880      * @dev This excludes the value of the current message, if any
2881      * @return The quantity of underlying tokens owned by this contract
2882      */
2883     function getCashPrior() internal view returns (uint) {
2884         EIP20Interface token = EIP20Interface(underlying);
2885         return token.balanceOf(address(this));
2886     }
2887 
2888     /**
2889      * @dev Similar to EIP20 transfer, except it handles a False result from `transferFrom` and reverts in that case.
2890      *      This will revert due to insufficient balance or insufficient allowance.
2891      *      This function returns the actual amount received,
2892      *      which may be less than `amount` if there is a fee attached to the transfer.
2893      *
2894      *      Note: This wrapper safely handles non-standard ERC-20 tokens that do not return a value.
2895      *            See here: https://medium.com/coinmonks/missing-return-value-bug-at-least-130-tokens-affected-d67bf08521ca
2896      */
2897     function doTransferIn(address from, uint amount) internal returns (uint) {
2898         EIP20NonStandardInterface token = EIP20NonStandardInterface(underlying);
2899         uint balanceBefore = EIP20Interface(underlying).balanceOf(address(this));
2900         token.transferFrom(from, address(this), amount);
2901 
2902         bool success;
2903         assembly {
2904             switch returndatasize()
2905                 case 0 {                       // This is a non-standard ERC-20
2906                     success := not(0)          // set success to true
2907                 }
2908                 case 32 {                      // This is a compliant ERC-20
2909                     returndatacopy(0, 0, 32)
2910                     success := mload(0)        // Set `success = returndata` of external call
2911                 }
2912                 default {                      // This is an excessively non-compliant ERC-20, revert.
2913                     revert(0, 0)
2914                 }
2915         }
2916         require(success, "TOKEN_TRANSFER_IN_FAILED");
2917 
2918         // Calculate the amount that was *actually* transferred
2919         uint balanceAfter = EIP20Interface(underlying).balanceOf(address(this));
2920         require(balanceAfter >= balanceBefore, "TOKEN_TRANSFER_IN_OVERFLOW");
2921         return balanceAfter - balanceBefore;   // underflow already checked above, just subtract
2922     }
2923 
2924     /**
2925      * @dev Similar to EIP20 transfer, except it handles a False success from `transfer` and returns an explanatory
2926      *      error code rather than reverting. If caller has not called checked protocol's balance, this may revert due to
2927      *      insufficient cash held in this contract. If caller has checked protocol's balance prior to this call, and verified
2928      *      it is >= amount, this should not revert in normal conditions.
2929      *
2930      *      Note: This wrapper safely handles non-standard ERC-20 tokens that do not return a value.
2931      *            See here: https://medium.com/coinmonks/missing-return-value-bug-at-least-130-tokens-affected-d67bf08521ca
2932      */
2933     function doTransferOut(address payable to, uint amount) internal {
2934         EIP20NonStandardInterface token = EIP20NonStandardInterface(underlying);
2935         token.transfer(to, amount);
2936 
2937         bool success;
2938         assembly {
2939             switch returndatasize()
2940                 case 0 {                      // This is a non-standard ERC-20
2941                     success := not(0)          // set success to true
2942                 }
2943                 case 32 {                     // This is a complaint ERC-20
2944                     returndatacopy(0, 0, 32)
2945                     success := mload(0)        // Set `success = returndata` of external call
2946                 }
2947                 default {                     // This is an excessively non-compliant ERC-20, revert.
2948                     revert(0, 0)
2949                 }
2950         }
2951         require(success, "TOKEN_TRANSFER_OUT_FAILED");
2952     }
2953 }