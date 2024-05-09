1 pragma solidity ^0.5.16;
2 pragma experimental ABIEncoderV2;
3 
4 
5 /**
6   * @title Bird's BController Interface
7   */
8 contract BControllerInterface {
9     /// @notice Indicator that this is a BController contract (for inspection)
10     bool public constant isBController = true;
11 
12     /*** Assets You Are In ***/
13 
14     function enterMarkets(address[] calldata bTokens) external returns (uint[] memory);
15     function exitMarket(address bToken) external returns (uint);
16 
17     /*** Policy Hooks ***/
18 
19     function mintAllowed(address bToken, address minter, uint mintAmount) external returns (uint);
20     function mintVerify(address bToken, address minter, uint mintAmount, uint mintTokens) external;
21 
22     function redeemAllowed(address bToken, address redeemer, uint redeemTokens) external returns (uint);
23     function redeemVerify(address bToken, address redeemer, uint redeemAmount, uint redeemTokens) external;
24 
25     function borrowAllowed(address bToken, address borrower, uint borrowAmount) external returns (uint);
26     function borrowVerify(address bToken, address borrower, uint borrowAmount) external;
27 
28     function repayBorrowAllowed(address bToken, address payer, address borrower, uint repayAmount) external returns (uint);
29     function repayBorrowVerify(address bToken, address payer, address borrower, uint repayAmount, uint borrowerIndex) external;
30 
31     function liquidateBorrowAllowed(address bTokenBorrowed, address bTokenCollateral, address liquidator, address borrower, uint repayAmount) external returns (uint);
32     function liquidateBorrowVerify(address bTokenBorrowed, address bTokenCollateral, address liquidator, address borrower, uint repayAmount, uint seizeTokens) external;
33 
34     function seizeAllowed(address bTokenCollateral, address bTokenBorrowed, address liquidator, address borrower, uint seizeTokens) external returns (uint);
35     function seizeVerify(address bTokenCollateral, address bTokenBorrowed, address liquidator, address borrower, uint seizeTokens) external;
36 
37     function transferAllowed(address bToken, address src, address dst, uint transferTokens) external returns (uint);
38     function transferVerify(address bToken, address src, address dst, uint transferTokens) external;
39 
40     /*** Liquidity/Liquidation Calculations ***/
41 
42     function liquidateCalculateSeizeTokens(address bTokenBorrowed, address bTokenCollateral, uint repayAmount) external view returns (uint, uint);
43 }
44 
45 /**
46   * @title Bird's InterestRateModel Interface
47   */
48 contract InterestRateModel {
49     /// @notice Indicator that this is an InterestRateModel contract (for inspection)
50     bool public constant isInterestRateModel = true;
51 
52     /**
53       * @notice Calculates the current borrow interest rate per block
54       * @param cash The total amount of cash the market has
55       * @param borrows The total amount of borrows the market has outstanding
56       * @param reserves The total amount of reserves the market has
57       * @return The borrow rate per block (as a percentage, and scaled by 1e18)
58       */
59     function getBorrowRate(uint cash, uint borrows, uint reserves) external view returns (uint);
60 
61     /**
62       * @notice Calculates the current supply interest rate per block
63       * @param cash The total amount of cash the market has
64       * @param borrows The total amount of borrows the market has outstanding
65       * @param reserves The total amount of reserves the market has
66       * @param reserveFactorMantissa The current reserve factor the market has
67       * @return The supply rate per block (as a percentage, and scaled by 1e18)
68       */
69     function getSupplyRate(uint cash, uint borrows, uint reserves, uint reserveFactorMantissa) external view returns (uint);
70 
71 }
72 
73 /**
74   * @title Bird's BToken Storage
75   */
76 contract BTokenStorage {
77     /**
78      * @dev Guard variable for re-entrancy checks
79      */
80     bool internal _notEntered;
81 
82     /**
83      * @notice EIP-20 token name for this token
84      */
85     string public name;
86 
87     /**
88      * @notice EIP-20 token symbol for this token
89      */
90     string public symbol;
91 
92     /**
93      * @notice EIP-20 token decimals for this token
94      */
95     uint8 public decimals;
96 
97     /**
98      * @notice Maximum borrow rate that can ever be applied (.0005% / block)
99      */
100 
101     uint internal constant borrowRateMaxMantissa = 0.0005e16;
102 
103     /**
104      * @notice Maximum fraction of interest that can be set aside for reserves
105      */
106     uint internal constant reserveFactorMaxMantissa = 1e18;
107 
108     /**
109      * @notice Administrator for this contract
110      */
111     address payable public admin;
112 
113     /**
114      * @notice Pending administrator for this contract
115      */
116     address payable public pendingAdmin;
117 
118     /**
119      * @notice Contract which oversees inter-bToken operations
120      */
121     BControllerInterface public bController;
122 
123     /**
124      * @notice Model which tells what the current interest rate should be
125      */
126     InterestRateModel public interestRateModel;
127 
128     /**
129      * @notice Initial exchange rate used when minting the first BTokens (used when totalSupply = 0)
130      */
131     uint internal initialExchangeRateMantissa;
132 
133     /**
134      * @notice Fraction of interest currently set aside for reserves
135      */
136     uint public reserveFactorMantissa;
137 
138     /**
139      * @notice Block number that interest was last accrued at
140      */
141     uint public accrualBlockNumber;
142 
143     /**
144      * @notice Accumulator of the total earned interest rate since the opening of the market
145      */
146     uint public borrowIndex;
147 
148     /**
149      * @notice Total amount of outstanding borrows of the underlying in this market
150      */
151     uint public totalBorrows;
152 
153     /**
154      * @notice Total amount of reserves of the underlying held in this market
155      */
156     uint public totalReserves;
157 
158     /**
159      * @notice Total number of tokens in circulation
160      */
161     uint public totalSupply;
162 
163     /**
164      * @notice Official record of token balances for each account
165      */
166     mapping (address => uint) internal accountTokens;
167 
168     /**
169      * @notice Approved token transfer amounts on behalf of others
170      */
171     mapping (address => mapping (address => uint)) internal transferAllowances;
172 
173     /**
174      * @notice Container for borrow balance information
175      * @member principal Total balance (with accrued interest), after applying the most recent balance-changing action
176      * @member interestIndex Global borrowIndex as of the most recent balance-changing action
177      */
178     struct BorrowSnapshot {
179         uint principal;
180         uint interestIndex;
181     }
182 
183     /**
184      * @notice Mapping of account addresses to outstanding borrow balances
185      */
186     mapping(address => BorrowSnapshot) internal accountBorrows;
187 }
188 
189 /**
190   * @title Bird's BToken Interface
191   */
192 contract BTokenInterface is BTokenStorage {
193     /**
194      * @notice Indicator that this is a BToken contract (for inspection)
195      */
196     bool public constant isBToken = true;
197 
198 
199     /*** Market Events ***/
200 
201     /**
202      * @notice Event emitted when interest is accrued
203      */
204     event AccrueInterestToken(uint cashPrior, uint interestAccumulated, uint borrowIndex, uint totalBorrows);
205 
206     /**
207      * @notice Event emitted when tokens are minted
208      */
209     event MintToken(address minter, uint mintAmount, uint mintTokens);
210 
211     /**
212      * @notice Event emitted when tokens are redeemed
213      */
214     event RedeemToken(address redeemer, uint redeemAmount, uint redeemTokens);
215 
216     /**
217      * @notice Event emitted when underlying is borrowed
218      */
219     event BorrowToken(address borrower, uint borrowAmount, uint accountBorrows, uint totalBorrows);
220 
221     /**
222      * @notice Event emitted when a borrow is repaid
223      */
224     event RepayBorrowToken(address payer, address borrower, uint repayAmount, uint accountBorrows, uint totalBorrows);
225 
226     /**
227      * @notice Event emitted when a borrow is liquidated
228      */
229     event LiquidateBorrowToken(address liquidator, address borrower, uint repayAmount, address bTokenCollateral, uint seizeTokens);
230 
231 
232     /*** Admin Events ***/
233 
234     /**
235      * @notice Event emitted when pendingAdmin is changed
236      */
237     event NewPendingAdmin(address oldPendingAdmin, address newPendingAdmin);
238 
239     /**
240      * @notice Event emitted when pendingAdmin is accepted, which means admin is updated
241      */
242     event NewAdmin(address oldAdmin, address newAdmin);
243 
244     /**
245      * @notice Event emitted when bController is changed
246      */
247     event NewBController(BControllerInterface oldBController, BControllerInterface newBController);
248 
249     /**
250      * @notice Event emitted when interestRateModel is changed
251      */
252     event NewMarketTokenInterestRateModel(InterestRateModel oldInterestRateModel, InterestRateModel newInterestRateModel);
253 
254     /**
255      * @notice Event emitted when the reserve factor is changed
256      */
257     event NewTokenReserveFactor(uint oldReserveFactorMantissa, uint newReserveFactorMantissa);
258 
259     /**
260      * @notice Event emitted when the reserves are added
261      */
262     event ReservesAdded(address benefactor, uint addAmount, uint newTotalReserves);
263 
264     /**
265      * @notice Event emitted when the reserves are reduced
266      */
267     event ReservesReduced(address admin, uint reduceAmount, uint newTotalReserves);
268 
269     /**
270      * @notice EIP20 Transfer event
271      */
272     event Transfer(address indexed from, address indexed to, uint amount);
273 
274     /**
275      * @notice EIP20 Approval event
276      */
277     event Approval(address indexed owner, address indexed spender, uint amount);
278 
279     /**
280      * @notice Failure event
281      */
282     event Failure(uint error, uint info, uint detail);
283 
284 
285     /*** User Interface ***/
286 
287     function transfer(address dst, uint amount) external returns (bool);
288     function transferFrom(address src, address dst, uint amount) external returns (bool);
289     function approve(address spender, uint amount) external returns (bool);
290     function allowance(address owner, address spender) external view returns (uint);
291     function balanceOf(address owner) external view returns (uint);
292     function balanceOfUnderlying(address owner) external returns (uint);
293     function getAccountSnapshot(address account) external view returns (uint, uint, uint, uint);
294     function borrowRatePerBlock() external view returns (uint);
295     function supplyRatePerBlock() external view returns (uint);
296     function totalBorrowsCurrent() external returns (uint);
297     function borrowBalanceCurrent(address account) external returns (uint);
298     function borrowBalanceStored(address account) public view returns (uint);
299     function exchangeRateCurrent() public returns (uint);
300     function exchangeRateStored() public view returns (uint);
301     function getCash() external view returns (uint);
302     function accrueInterest() public returns (uint);
303     function seize(address liquidator, address borrower, uint seizeTokens) external returns (uint);
304 
305     /*** Admin Functions ***/
306 
307     function _setPendingAdmin(address payable newPendingAdmin) external returns (uint);
308     function _acceptAdmin() external returns (uint);
309     function _setBController(BControllerInterface newBController) public returns (uint);
310     function _setReserveFactor(uint newReserveFactorMantissa) external returns (uint);
311     function _reduceReserves(uint reduceAmount) external returns (uint);
312     function _setInterestRateModel(InterestRateModel newInterestRateModel) public returns (uint);
313 }
314 
315 /**
316   * @title Bird's BErc20 Storage
317   */
318 contract BErc20Storage {
319     /**
320      * @notice Underlying asset for this BToken
321      */
322     address public underlying;
323 }
324 
325 /**
326   * @title Bird's BErc20 Interface
327   */
328 contract BErc20Interface is BErc20Storage {
329 
330     /*** User Interface ***/
331 
332     function mint(uint mintAmount) external returns (uint);
333     function redeem(uint redeemTokens) external returns (uint);
334     function redeemUnderlying(uint redeemAmount) external returns (uint);
335     function borrow(uint borrowAmount) external returns (uint);
336     function repayBorrow(uint repayAmount) external returns (uint);
337     function repayBorrowBehalf(address borrower, uint repayAmount) external returns (uint);
338     function liquidateBorrow(address borrower, uint repayAmount, BTokenInterface bTokenCollateral) external returns (uint);
339 
340 
341     /*** Admin Functions ***/
342 
343     function _addReserves(uint addAmount) external returns (uint);
344 }
345 
346 /**
347   * @title Bird's BDelegation Storage
348   */
349 contract BDelegationStorage {
350     /**
351      * @notice Implementation address for this contract
352      */
353     address public implementation;
354 }
355 
356 /**
357   * @title Bird's BDelegator Interface
358   */
359 contract BDelegatorInterface is BDelegationStorage {
360     /**
361      * @notice Emitted when implementation is changed
362      */
363     event NewImplementation(address oldImplementation, address newImplementation);
364 
365     /**
366      * @notice Called by the admin to update the implementation of the delegator
367      * @param implementation_ The address of the new implementation for delegation
368      * @param allowResign Flag to indicate whether to call _resignImplementation on the old implementation
369      * @param becomeImplementationData The encoded bytes data to be passed to _becomeImplementation
370      */
371     function _setImplementation(address implementation_, bool allowResign, bytes memory becomeImplementationData) public;
372 }
373 
374 /**
375   * @title Bird's BDelegate Interface
376   */
377 contract BDelegateInterface is BDelegationStorage {
378     /**
379      * @notice Called by the delegator on a delegate to initialize it for duty
380      * @dev Should revert if any issues arise which make it unfit for delegation
381      * @param data The encoded bytes data for any initialization
382      */
383     function _becomeImplementation(bytes memory data) public;
384 
385     /**
386      * @notice Called by the delegator on a delegate to forfeit its responsibility
387      */
388     function _resignImplementation() public;
389 }
390 
391 contract BControllerErrorReporter {
392     enum Error {
393         NO_ERROR,
394         UNAUTHORIZED,
395         BCONTROLLER_MISMATCH,
396         INSUFFICIENT_SHORTFALL,
397         INSUFFICIENT_LIQUIDITY,
398         INVALID_CLOSE_FACTOR,
399         INVALID_COLLATERAL_FACTOR,
400         INVALID_LIQUIDATION_INCENTIVE,
401         MARKET_NOT_ENTERED, // no longer possible
402         MARKET_NOT_LISTED,
403         MARKET_ALREADY_LISTED,
404         MATH_ERROR,
405         NONZERO_BORROW_BALANCE,
406         PRICE_ERROR,
407         REJECTION,
408         SNAPSHOT_ERROR,
409         TOO_MANY_ASSETS,
410         TOO_MUCH_REPAY
411     }
412 
413     enum FailureInfo {
414         ACCEPT_ADMIN_PENDING_ADMIN_CHECK,
415         ACCEPT_PENDING_IMPLEMENTATION_ADDRESS_CHECK,
416         EXIT_MARKET_BALANCE_OWED,
417         EXIT_MARKET_REJECTION,
418         SET_CLOSE_FACTOR_OWNER_CHECK,
419         SET_CLOSE_FACTOR_VALIDATION,
420         SET_COLLATERAL_FACTOR_OWNER_CHECK,
421         SET_COLLATERAL_FACTOR_NO_EXISTS,
422         SET_COLLATERAL_FACTOR_VALIDATION,
423         SET_COLLATERAL_FACTOR_WITHOUT_PRICE,
424         SET_IMPLEMENTATION_OWNER_CHECK,
425         SET_LIQUIDATION_INCENTIVE_OWNER_CHECK,
426         SET_LIQUIDATION_INCENTIVE_VALIDATION,
427         SET_MAX_ASSETS_OWNER_CHECK,
428         SET_PENDING_ADMIN_OWNER_CHECK,
429         SET_PENDING_IMPLEMENTATION_OWNER_CHECK,
430         SET_PRICE_ORACLE_OWNER_CHECK,
431         SUPPORT_MARKET_EXISTS,
432         SUPPORT_MARKET_OWNER_CHECK,
433         SET_PAUSE_GUARDIAN_OWNER_CHECK
434     }
435 
436     /**
437       * @dev `error` corresponds to enum Error; `info` corresponds to enum FailureInfo, and `detail` is an arbitrary
438       * contract-specific code that enables us to report opaque error codes from upgradeable contracts.
439       **/
440     event Failure(uint error, uint info, uint detail);
441 
442     /**
443       * @dev use this when reporting a known error from the money market or a non-upgradeable collaborator
444       */
445     function fail(Error err, FailureInfo info) internal returns (uint) {
446         emit Failure(uint(err), uint(info), 0);
447 
448         return uint(err);
449     }
450 
451     /**
452       * @dev use this when reporting an opaque error from an upgradeable collaborator contract
453       */
454     function failOpaque(Error err, FailureInfo info, uint opaqueError) internal returns (uint) {
455         emit Failure(uint(err), uint(info), opaqueError);
456 
457         return uint(err);
458     }
459 }
460 
461 contract TokenErrorReporter {
462     enum Error {
463         NO_ERROR,
464         UNAUTHORIZED,
465         BAD_INPUT,
466         BCONTROLLER_REJECTION,
467         BCONTROLLER_CALCULATION_ERROR,
468         INTEREST_RATE_MODEL_ERROR,
469         INVALID_ACCOUNT_PAIR,
470         INVALID_CLOSE_AMOUNT_REQUESTED,
471         INVALID_COLLATERAL_FACTOR,
472         MATH_ERROR,
473         MARKET_NOT_FRESH,
474         MARKET_NOT_LISTED,
475         TOKEN_INSUFFICIENT_ALLOWANCE,
476         TOKEN_INSUFFICIENT_BALANCE,
477         TOKEN_INSUFFICIENT_CASH,
478         TOKEN_TRANSFER_IN_FAILED,
479         TOKEN_TRANSFER_OUT_FAILED
480     }
481 
482     /*
483      * Note: FailureInfo (but not Error) is kept in alphabetical order
484      *       This is because FailureInfo grows significantly faster, and
485      *       the order of Error has some meaning, while the order of FailureInfo
486      *       is entirely arbitrary.
487      */
488     enum FailureInfo {
489         ACCEPT_ADMIN_PENDING_ADMIN_CHECK,
490         ACCRUE_INTEREST_ACCUMULATED_INTEREST_CALCULATION_FAILED,
491         ACCRUE_INTEREST_BORROW_RATE_CALCULATION_FAILED,
492         ACCRUE_INTEREST_NEW_BORROW_INDEX_CALCULATION_FAILED,
493         ACCRUE_INTEREST_NEW_TOTAL_BORROWS_CALCULATION_FAILED,
494         ACCRUE_INTEREST_NEW_TOTAL_RESERVES_CALCULATION_FAILED,
495         ACCRUE_INTEREST_SIMPLE_INTEREST_FACTOR_CALCULATION_FAILED,
496         BORROW_ACCUMULATED_BALANCE_CALCULATION_FAILED,
497         BORROW_ACCRUE_INTEREST_FAILED,
498         BORROW_CASH_NOT_AVAILABLE,
499         BORROW_FRESHNESS_CHECK,
500         BORROW_NEW_TOTAL_BALANCE_CALCULATION_FAILED,
501         BORROW_NEW_ACCOUNT_BORROW_BALANCE_CALCULATION_FAILED,
502         BORROW_MARKET_NOT_LISTED,
503         BORROW_BCONTROLLER_REJECTION,
504         LIQUIDATE_ACCRUE_BORROW_INTEREST_FAILED,
505         LIQUIDATE_ACCRUE_COLLATERAL_INTEREST_FAILED,
506         LIQUIDATE_COLLATERAL_FRESHNESS_CHECK,
507         LIQUIDATE_BCONTROLLER_REJECTION,
508         LIQUIDATE_BCONTROLLER_CALCULATE_AMOUNT_SEIZE_FAILED,
509         LIQUIDATE_CLOSE_AMOUNT_IS_UINT_MAX,
510         LIQUIDATE_CLOSE_AMOUNT_IS_ZERO,
511         LIQUIDATE_FRESHNESS_CHECK,
512         LIQUIDATE_LIQUIDATOR_IS_BORROWER,
513         LIQUIDATE_REPAY_BORROW_FRESH_FAILED,
514         LIQUIDATE_SEIZE_BALANCE_INCREMENT_FAILED,
515         LIQUIDATE_SEIZE_BALANCE_DECREMENT_FAILED,
516         LIQUIDATE_SEIZE_BCONTROLLER_REJECTION,
517         LIQUIDATE_SEIZE_LIQUIDATOR_IS_BORROWER,
518         LIQUIDATE_SEIZE_TOO_MUCH,
519         MINT_ACCRUE_INTEREST_FAILED,
520         MINT_BCONTROLLER_REJECTION,
521         MINT_EXCHANGE_CALCULATION_FAILED,
522         MINT_EXCHANGE_RATE_READ_FAILED,
523         MINT_FRESHNESS_CHECK,
524         MINT_NEW_ACCOUNT_BALANCE_CALCULATION_FAILED,
525         MINT_NEW_TOTAL_SUPPLY_CALCULATION_FAILED,
526         MINT_TRANSFER_IN_FAILED,
527         MINT_TRANSFER_IN_NOT_POSSIBLE,
528         REDEEM_ACCRUE_INTEREST_FAILED,
529         REDEEM_BCONTROLLER_REJECTION,
530         REDEEM_EXCHANGE_TOKENS_CALCULATION_FAILED,
531         REDEEM_EXCHANGE_AMOUNT_CALCULATION_FAILED,
532         REDEEM_EXCHANGE_RATE_READ_FAILED,
533         REDEEM_FRESHNESS_CHECK,
534         REDEEM_NEW_ACCOUNT_BALANCE_CALCULATION_FAILED,
535         REDEEM_NEW_TOTAL_SUPPLY_CALCULATION_FAILED,
536         REDEEM_TRANSFER_OUT_NOT_POSSIBLE,
537         REDUCE_RESERVES_ACCRUE_INTEREST_FAILED,
538         REDUCE_RESERVES_ADMIN_CHECK,
539         REDUCE_RESERVES_CASH_NOT_AVAILABLE,
540         REDUCE_RESERVES_FRESH_CHECK,
541         REDUCE_RESERVES_VALIDATION,
542         REPAY_BEHALF_ACCRUE_INTEREST_FAILED,
543         REPAY_BORROW_ACCRUE_INTEREST_FAILED,
544         REPAY_BORROW_ACCUMULATED_BALANCE_CALCULATION_FAILED,
545         REPAY_BORROW_BCONTROLLER_REJECTION,
546         REPAY_BORROW_FRESHNESS_CHECK,
547         REPAY_BORROW_NEW_ACCOUNT_BORROW_BALANCE_CALCULATION_FAILED,
548         REPAY_BORROW_NEW_TOTAL_BALANCE_CALCULATION_FAILED,
549         REPAY_BORROW_TRANSFER_IN_NOT_POSSIBLE,
550         SET_COLLATERAL_FACTOR_OWNER_CHECK,
551         SET_COLLATERAL_FACTOR_VALIDATION,
552         SET_BCONTROLLER_OWNER_CHECK,
553         SET_INTEREST_RATE_MODEL_ACCRUE_INTEREST_FAILED,
554         SET_INTEREST_RATE_MODEL_FRESH_CHECK,
555         SET_INTEREST_RATE_MODEL_OWNER_CHECK,
556         SET_MAX_ASSETS_OWNER_CHECK,
557         SET_ORACLE_MARKET_NOT_LISTED,
558         SET_PENDING_ADMIN_OWNER_CHECK,
559         SET_RESERVE_FACTOR_ACCRUE_INTEREST_FAILED,
560         SET_RESERVE_FACTOR_ADMIN_CHECK,
561         SET_RESERVE_FACTOR_FRESH_CHECK,
562         SET_RESERVE_FACTOR_BOUNDS_CHECK,
563         TRANSFER_BCONTROLLER_REJECTION,
564         TRANSFER_NOT_ALLOWED,
565         TRANSFER_NOT_ENOUGH,
566         TRANSFER_TOO_MUCH,
567         ADD_RESERVES_ACCRUE_INTEREST_FAILED,
568         ADD_RESERVES_FRESH_CHECK,
569         ADD_RESERVES_TRANSFER_IN_NOT_POSSIBLE
570     }
571 
572     /**
573       * @dev `error` corresponds to enum Error; `info` corresponds to enum FailureInfo, and `detail` is an arbitrary
574       * contract-specific code that enables us to report opaque error codes from upgradeable contracts.
575       **/
576     event Failure(uint error, uint info, uint detail);
577 
578     /**
579       * @dev use this when reporting a known error from the money market or a non-upgradeable collaborator
580       */
581     function fail(Error err, FailureInfo info) internal returns (uint) {
582         emit Failure(uint(err), uint(info), 0);
583 
584         return uint(err);
585     }
586 
587     /**
588       * @dev use this when reporting an opaque error from an upgradeable collaborator contract
589       */
590     function failOpaque(Error err, FailureInfo info, uint opaqueError) internal returns (uint) {
591         emit Failure(uint(err), uint(info), opaqueError);
592 
593         return uint(err);
594     }
595 }
596 
597 /**
598   * @title Careful Math
599   * @notice Derived from OpenZeppelin's SafeMath library
600   *         https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/math/SafeMath.sol
601   */
602 contract CarefulMath {
603 
604     /**
605      * @dev Possible error codes that we can return
606      */
607     enum MathError {
608         NO_ERROR,
609         DIVISION_BY_ZERO,
610         INTEGER_OVERFLOW,
611         INTEGER_UNDERFLOW
612     }
613 
614     /**
615     * @dev Multiplies two numbers, returns an error on overflow.
616     */
617     function mulUInt(uint a, uint b) internal pure returns (MathError, uint) {
618         if (a == 0) {
619             return (MathError.NO_ERROR, 0);
620         }
621 
622         uint c = a * b;
623 
624         if (c / a != b) {
625             return (MathError.INTEGER_OVERFLOW, 0);
626         } else {
627             return (MathError.NO_ERROR, c);
628         }
629     }
630 
631     /**
632     * @dev Integer division of two numbers, truncating the quotient.
633     */
634     function divUInt(uint a, uint b) internal pure returns (MathError, uint) {
635         if (b == 0) {
636             return (MathError.DIVISION_BY_ZERO, 0);
637         }
638 
639         return (MathError.NO_ERROR, a / b);
640     }
641 
642     /**
643     * @dev Subtracts two numbers, returns an error on overflow (i.e. if subtrahend is greater than minuend).
644     */
645     function subUInt(uint a, uint b) internal pure returns (MathError, uint) {
646         if (b <= a) {
647             return (MathError.NO_ERROR, a - b);
648         } else {
649             return (MathError.INTEGER_UNDERFLOW, 0);
650         }
651     }
652 
653     /**
654     * @dev Adds two numbers, returns an error on overflow.
655     */
656     function addUInt(uint a, uint b) internal pure returns (MathError, uint) {
657         uint c = a + b;
658 
659         if (c >= a) {
660             return (MathError.NO_ERROR, c);
661         } else {
662             return (MathError.INTEGER_OVERFLOW, 0);
663         }
664     }
665 
666     /**
667     * @dev add a and b and then subtract c
668     */
669     function addThenSubUInt(uint a, uint b, uint c) internal pure returns (MathError, uint) {
670         (MathError err0, uint sum) = addUInt(a, b);
671 
672         if (err0 != MathError.NO_ERROR) {
673             return (err0, 0);
674         }
675 
676         return subUInt(sum, c);
677     }
678 }
679 
680 /**
681  * @title Exponential module for storing fixed-precision decimals
682  * @notice Exp is a struct which stores decimals with a fixed precision of 18 decimal places.
683  *         Thus, if we wanted to store the 5.1, mantissa would store 5.1e18. That is:
684  *         `Exp({mantissa: 5100000000000000000})`.
685  */
686 contract Exponential is CarefulMath {
687     uint constant expScale = 1e18;
688     uint constant doubleScale = 1e36;
689     uint constant halfExpScale = expScale/2;
690     uint constant mantissaOne = expScale;
691 
692     struct Exp {
693         uint mantissa;
694     }
695 
696     struct Double {
697         uint mantissa;
698     }
699 
700     /**
701      * @dev Creates an exponential from numerator and denominator values.
702      *      Note: Returns an error if (`num` * 10e18) > MAX_INT,
703      *            or if `denom` is zero.
704      */
705     function getExp(uint num, uint denom) pure internal returns (MathError, Exp memory) {
706         (MathError err0, uint scaledNumerator) = mulUInt(num, expScale);
707         if (err0 != MathError.NO_ERROR) {
708             return (err0, Exp({mantissa: 0}));
709         }
710 
711         (MathError err1, uint rational) = divUInt(scaledNumerator, denom);
712         if (err1 != MathError.NO_ERROR) {
713             return (err1, Exp({mantissa: 0}));
714         }
715 
716         return (MathError.NO_ERROR, Exp({mantissa: rational}));
717     }
718 
719     /**
720      * @dev Adds two exponentials, returning a new exponential.
721      */
722     function addExp(Exp memory a, Exp memory b) pure internal returns (MathError, Exp memory) {
723         (MathError error, uint result) = addUInt(a.mantissa, b.mantissa);
724 
725         return (error, Exp({mantissa: result}));
726     }
727 
728     /**
729      * @dev Subtracts two exponentials, returning a new exponential.
730      */
731     function subExp(Exp memory a, Exp memory b) pure internal returns (MathError, Exp memory) {
732         (MathError error, uint result) = subUInt(a.mantissa, b.mantissa);
733 
734         return (error, Exp({mantissa: result}));
735     }
736 
737     /**
738      * @dev Multiply an Exp by a scalar, returning a new Exp.
739      */
740     function mulScalar(Exp memory a, uint scalar) pure internal returns (MathError, Exp memory) {
741         (MathError err0, uint scaledMantissa) = mulUInt(a.mantissa, scalar);
742         if (err0 != MathError.NO_ERROR) {
743             return (err0, Exp({mantissa: 0}));
744         }
745 
746         return (MathError.NO_ERROR, Exp({mantissa: scaledMantissa}));
747     }
748 
749     /**
750      * @dev Multiply an Exp by a scalar, then truncate to return an unsigned integer.
751      */
752     function mulScalarTruncate(Exp memory a, uint scalar) pure internal returns (MathError, uint) {
753         (MathError err, Exp memory product) = mulScalar(a, scalar);
754         if (err != MathError.NO_ERROR) {
755             return (err, 0);
756         }
757 
758         return (MathError.NO_ERROR, truncate(product));
759     }
760 
761     /**
762      * @dev Multiply an Exp by a scalar, truncate, then add an to an unsigned integer, returning an unsigned integer.
763      */
764     function mulScalarTruncateAddUInt(Exp memory a, uint scalar, uint addend) pure internal returns (MathError, uint) {
765         (MathError err, Exp memory product) = mulScalar(a, scalar);
766         if (err != MathError.NO_ERROR) {
767             return (err, 0);
768         }
769 
770         return addUInt(truncate(product), addend);
771     }
772 
773     /**
774      * @dev Divide an Exp by a scalar, returning a new Exp.
775      */
776     function divScalar(Exp memory a, uint scalar) pure internal returns (MathError, Exp memory) {
777         (MathError err0, uint descaledMantissa) = divUInt(a.mantissa, scalar);
778         if (err0 != MathError.NO_ERROR) {
779             return (err0, Exp({mantissa: 0}));
780         }
781 
782         return (MathError.NO_ERROR, Exp({mantissa: descaledMantissa}));
783     }
784 
785     /**
786      * @dev Divide a scalar by an Exp, returning a new Exp.
787      */
788     function divScalarByExp(uint scalar, Exp memory divisor) pure internal returns (MathError, Exp memory) {
789         /*
790           We are doing this as:
791           getExp(mulUInt(expScale, scalar), divisor.mantissa)
792 
793           How it works:
794           Exp = a / b;
795           Scalar = s;
796           `s / (a / b)` = `b * s / a` and since for an Exp `a = mantissa, b = expScale`
797         */
798         (MathError err0, uint numerator) = mulUInt(expScale, scalar);
799         if (err0 != MathError.NO_ERROR) {
800             return (err0, Exp({mantissa: 0}));
801         }
802         return getExp(numerator, divisor.mantissa);
803     }
804 
805     /**
806      * @dev Divide a scalar by an Exp, then truncate to return an unsigned integer.
807      */
808     function divScalarByExpTruncate(uint scalar, Exp memory divisor) pure internal returns (MathError, uint) {
809         (MathError err, Exp memory fraction) = divScalarByExp(scalar, divisor);
810         if (err != MathError.NO_ERROR) {
811             return (err, 0);
812         }
813 
814         return (MathError.NO_ERROR, truncate(fraction));
815     }
816 
817     /**
818      * @dev Multiplies two exponentials, returning a new exponential.
819      */
820     function mulExp(Exp memory a, Exp memory b) pure internal returns (MathError, Exp memory) {
821 
822         (MathError err0, uint doubleScaledProduct) = mulUInt(a.mantissa, b.mantissa);
823         if (err0 != MathError.NO_ERROR) {
824             return (err0, Exp({mantissa: 0}));
825         }
826 
827         // We add half the scale before dividing so that we get rounding instead of truncation.
828         //  See "Listing 6" and text above it at https://accu.org/index.php/journals/1717
829         // Without this change, a result like 6.6...e-19 will be truncated to 0 instead of being rounded to 1e-18.
830         (MathError err1, uint doubleScaledProductWithHalfScale) = addUInt(halfExpScale, doubleScaledProduct);
831         if (err1 != MathError.NO_ERROR) {
832             return (err1, Exp({mantissa: 0}));
833         }
834 
835         (MathError err2, uint product) = divUInt(doubleScaledProductWithHalfScale, expScale);
836         // The only error `div` can return is MathError.DIVISION_BY_ZERO but we control `expScale` and it is not zero.
837         assert(err2 == MathError.NO_ERROR);
838 
839         return (MathError.NO_ERROR, Exp({mantissa: product}));
840     }
841 
842     /**
843      * @dev Multiplies two exponentials given their mantissas, returning a new exponential.
844      */
845     function mulExp(uint a, uint b) pure internal returns (MathError, Exp memory) {
846         return mulExp(Exp({mantissa: a}), Exp({mantissa: b}));
847     }
848 
849     /**
850      * @dev Multiplies three exponentials, returning a new exponential.
851      */
852     function mulExp3(Exp memory a, Exp memory b, Exp memory c) pure internal returns (MathError, Exp memory) {
853         (MathError err, Exp memory ab) = mulExp(a, b);
854         if (err != MathError.NO_ERROR) {
855             return (err, ab);
856         }
857         return mulExp(ab, c);
858     }
859 
860     /**
861      * @dev Divides two exponentials, returning a new exponential.
862      *     (a/scale) / (b/scale) = (a/scale) * (scale/b) = a/b,
863      *  which we can scale as an Exp by calling getExp(a.mantissa, b.mantissa)
864      */
865     function divExp(Exp memory a, Exp memory b) pure internal returns (MathError, Exp memory) {
866         return getExp(a.mantissa, b.mantissa);
867     }
868 
869     /**
870      * @dev Truncates the given exp to a whole number value.
871      *      For example, truncate(Exp{mantissa: 15 * expScale}) = 15
872      */
873     function truncate(Exp memory exp) pure internal returns (uint) {
874         // Note: We are not using careful math here as we're performing a division that cannot fail
875         return exp.mantissa / expScale;
876     }
877 
878     /**
879      * @dev Checks if first Exp is less than second Exp.
880      */
881     function lessThanExp(Exp memory left, Exp memory right) pure internal returns (bool) {
882         return left.mantissa < right.mantissa;
883     }
884 
885     /**
886      * @dev Checks if left Exp <= right Exp.
887      */
888     function lessThanOrEqualExp(Exp memory left, Exp memory right) pure internal returns (bool) {
889         return left.mantissa <= right.mantissa;
890     }
891 
892     /**
893      * @dev Checks if left Exp > right Exp.
894      */
895     function greaterThanExp(Exp memory left, Exp memory right) pure internal returns (bool) {
896         return left.mantissa > right.mantissa;
897     }
898 
899     /**
900      * @dev returns true if Exp is exactly zero
901      */
902     function isZeroExp(Exp memory value) pure internal returns (bool) {
903         return value.mantissa == 0;
904     }
905 
906     function safe224(uint n, string memory errorMessage) pure internal returns (uint224) {
907         require(n < 2**224, errorMessage);
908         return uint224(n);
909     }
910 
911     function safe32(uint n, string memory errorMessage) pure internal returns (uint32) {
912         require(n < 2**32, errorMessage);
913         return uint32(n);
914     }
915 
916     function add_(Exp memory a, Exp memory b) pure internal returns (Exp memory) {
917         return Exp({mantissa: add_(a.mantissa, b.mantissa)});
918     }
919 
920     function add_(Double memory a, Double memory b) pure internal returns (Double memory) {
921         return Double({mantissa: add_(a.mantissa, b.mantissa)});
922     }
923 
924     function add_(uint a, uint b) pure internal returns (uint) {
925         return add_(a, b, "addition overflow");
926     }
927 
928     function add_(uint a, uint b, string memory errorMessage) pure internal returns (uint) {
929         uint c = a + b;
930         require(c >= a, errorMessage);
931         return c;
932     }
933 
934     function sub_(Exp memory a, Exp memory b) pure internal returns (Exp memory) {
935         return Exp({mantissa: sub_(a.mantissa, b.mantissa)});
936     }
937 
938     function sub_(Double memory a, Double memory b) pure internal returns (Double memory) {
939         return Double({mantissa: sub_(a.mantissa, b.mantissa)});
940     }
941 
942     function sub_(uint a, uint b) pure internal returns (uint) {
943         return sub_(a, b, "subtraction underflow");
944     }
945 
946     function sub_(uint a, uint b, string memory errorMessage) pure internal returns (uint) {
947         require(b <= a, errorMessage);
948         return a - b;
949     }
950 
951     function mul_(Exp memory a, Exp memory b) pure internal returns (Exp memory) {
952         return Exp({mantissa: mul_(a.mantissa, b.mantissa) / expScale});
953     }
954 
955     function mul_(Exp memory a, uint b) pure internal returns (Exp memory) {
956         return Exp({mantissa: mul_(a.mantissa, b)});
957     }
958 
959     function mul_(uint a, Exp memory b) pure internal returns (uint) {
960         return mul_(a, b.mantissa) / expScale;
961     }
962 
963     function mul_(Double memory a, Double memory b) pure internal returns (Double memory) {
964         return Double({mantissa: mul_(a.mantissa, b.mantissa) / doubleScale});
965     }
966 
967     function mul_(Double memory a, uint b) pure internal returns (Double memory) {
968         return Double({mantissa: mul_(a.mantissa, b)});
969     }
970 
971     function mul_(uint a, Double memory b) pure internal returns (uint) {
972         return mul_(a, b.mantissa) / doubleScale;
973     }
974 
975     function mul_(uint a, uint b) pure internal returns (uint) {
976         return mul_(a, b, "multiplication overflow");
977     }
978 
979     function mul_(uint a, uint b, string memory errorMessage) pure internal returns (uint) {
980         if (a == 0 || b == 0) {
981             return 0;
982         }
983         uint c = a * b;
984         require(c / a == b, errorMessage);
985         return c;
986     }
987 
988     function div_(Exp memory a, Exp memory b) pure internal returns (Exp memory) {
989         return Exp({mantissa: div_(mul_(a.mantissa, expScale), b.mantissa)});
990     }
991 
992     function div_(Exp memory a, uint b) pure internal returns (Exp memory) {
993         return Exp({mantissa: div_(a.mantissa, b)});
994     }
995 
996     function div_(uint a, Exp memory b) pure internal returns (uint) {
997         return div_(mul_(a, expScale), b.mantissa);
998     }
999 
1000     function div_(Double memory a, Double memory b) pure internal returns (Double memory) {
1001         return Double({mantissa: div_(mul_(a.mantissa, doubleScale), b.mantissa)});
1002     }
1003 
1004     function div_(Double memory a, uint b) pure internal returns (Double memory) {
1005         return Double({mantissa: div_(a.mantissa, b)});
1006     }
1007 
1008     function div_(uint a, Double memory b) pure internal returns (uint) {
1009         return div_(mul_(a, doubleScale), b.mantissa);
1010     }
1011 
1012     function div_(uint a, uint b) pure internal returns (uint) {
1013         return div_(a, b, "divide by zero");
1014     }
1015 
1016     function div_(uint a, uint b, string memory errorMessage) pure internal returns (uint) {
1017         require(b > 0, errorMessage);
1018         return a / b;
1019     }
1020 
1021     function fraction(uint a, uint b) pure internal returns (Double memory) {
1022         return Double({mantissa: div_(mul_(a, doubleScale), b)});
1023     }
1024 }
1025 
1026 /**
1027  * @title ERC 20 Token Standard Interface
1028  *  https://eips.ethereum.org/EIPS/eip-20
1029  */
1030 interface EIP20Interface {
1031     function name() external view returns (string memory);
1032     function symbol() external view returns (string memory);
1033     function decimals() external view returns (uint8);
1034 
1035     /**
1036       * @notice Get the total number of tokens in circulation
1037       * @return The supply of tokens
1038       */
1039     function totalSupply() external view returns (uint256);
1040 
1041     /**
1042      * @notice Gets the balance of the specified address
1043      * @param owner The address from which the balance will be retrieved
1044      * @return The balance
1045      */
1046     function balanceOf(address owner) external view returns (uint256 balance);
1047 
1048     /**
1049       * @notice Transfer `amount` tokens from `msg.sender` to `dst`
1050       * @param dst The address of the destination account
1051       * @param amount The number of tokens to transfer
1052       * @return Whether or not the transfer succeeded
1053       */
1054     function transfer(address dst, uint256 amount) external returns (bool success);
1055 
1056     /**
1057       * @notice Transfer `amount` tokens from `src` to `dst`
1058       * @param src The address of the source account
1059       * @param dst The address of the destination account
1060       * @param amount The number of tokens to transfer
1061       * @return Whether or not the transfer succeeded
1062       */
1063     function transferFrom(address src, address dst, uint256 amount) external returns (bool success);
1064 
1065     /**
1066       * @notice Approve `spender` to transfer up to `amount` from `src`
1067       * @dev This will overwrite the approval amount for `spender`
1068       *  and is subject to issues noted [here](https://eips.ethereum.org/EIPS/eip-20#approve)
1069       * @param spender The address of the account which may transfer tokens
1070       * @param amount The number of tokens that are approved (-1 means infinite)
1071       * @return Whether or not the approval succeeded
1072       */
1073     function approve(address spender, uint256 amount) external returns (bool success);
1074 
1075     /**
1076       * @notice Get the current allowance from `owner` for `spender`
1077       * @param owner The address of the account which owns the tokens to be spent
1078       * @param spender The address of the account which may transfer tokens
1079       * @return The number of tokens allowed to be spent (-1 means infinite)
1080       */
1081     function allowance(address owner, address spender) external view returns (uint256 remaining);
1082 
1083     event Transfer(address indexed from, address indexed to, uint256 amount);
1084     event Approval(address indexed owner, address indexed spender, uint256 amount);
1085 }
1086 
1087 /**
1088  * @title EIP20NonStandardInterface
1089  * @dev Version of ERC20 with no return values for `transfer` and `transferFrom`
1090  *  See https://medium.com/coinmonks/missing-return-value-bug-at-least-130-tokens-affected-d67bf08521ca
1091  */
1092 interface EIP20NonStandardInterface {
1093 
1094     /**
1095      * @notice Get the total number of tokens in circulation
1096      * @return The supply of tokens
1097      */
1098     function totalSupply() external view returns (uint256);
1099 
1100     /**
1101      * @notice Gets the balance of the specified address
1102      * @param owner The address from which the balance will be retrieved
1103      * @return The balance
1104      */
1105     function balanceOf(address owner) external view returns (uint256 balance);
1106 
1107     ///
1108     /// !!!!!!!!!!!!!!
1109     /// !!! NOTICE !!! `transfer` does not return a value, in violation of the ERC-20 specification
1110     /// !!!!!!!!!!!!!!
1111     ///
1112 
1113     /**
1114       * @notice Transfer `amount` tokens from `msg.sender` to `dst`
1115       * @param dst The address of the destination account
1116       * @param amount The number of tokens to transfer
1117       */
1118     function transfer(address dst, uint256 amount) external;
1119 
1120     ///
1121     /// !!!!!!!!!!!!!!
1122     /// !!! NOTICE !!! `transferFrom` does not return a value, in violation of the ERC-20 specification
1123     /// !!!!!!!!!!!!!!
1124     ///
1125 
1126     /**
1127       * @notice Transfer `amount` tokens from `src` to `dst`
1128       * @param src The address of the source account
1129       * @param dst The address of the destination account
1130       * @param amount The number of tokens to transfer
1131       */
1132     function transferFrom(address src, address dst, uint256 amount) external;
1133 
1134     /**
1135       * @notice Approve `spender` to transfer up to `amount` from `src`
1136       * @dev This will overwrite the approval amount for `spender`
1137       *  and is subject to issues noted [here](https://eips.ethereum.org/EIPS/eip-20#approve)
1138       * @param spender The address of the account which may transfer tokens
1139       * @param amount The number of tokens that are approved
1140       * @return Whether or not the approval succeeded
1141       */
1142     function approve(address spender, uint256 amount) external returns (bool success);
1143 
1144     /**
1145       * @notice Get the current allowance from `owner` for `spender`
1146       * @param owner The address of the account which owns the tokens to be spent
1147       * @param spender The address of the account which may transfer tokens
1148       * @return The number of tokens allowed to be spent
1149       */
1150     function allowance(address owner, address spender) external view returns (uint256 remaining);
1151 
1152     event Transfer(address indexed from, address indexed to, uint256 amount);
1153     event Approval(address indexed owner, address indexed spender, uint256 amount);
1154 }
1155 
1156 /**
1157  * @title Bird's BToken Contract
1158  * @notice Abstract base for BTokens
1159  */
1160 contract BToken is BTokenInterface, Exponential, TokenErrorReporter {
1161 
1162     /**
1163      * @notice Initialize the money market
1164      * @param bController_ The address of the BController
1165      * @param interestRateModel_ The address of the interest rate model
1166      * @param initialExchangeRateMantissa_ The initial exchange rate, scaled by 1e18
1167      * @param name_ EIP-20 name of this token
1168      * @param symbol_ EIP-20 symbol of this token
1169      * @param decimals_ EIP-20 decimal precision of this token
1170      */
1171     function initialize(BControllerInterface bController_,
1172                         InterestRateModel interestRateModel_,
1173                         uint initialExchangeRateMantissa_,
1174                         string memory name_,
1175                         string memory symbol_,
1176                         uint8 decimals_) public {
1177         require(msg.sender == admin, "only admin may initialize the market");
1178         require(accrualBlockNumber == 0 && borrowIndex == 0, "market may only be initialized once");
1179 
1180         // Set initial exchange rate
1181         initialExchangeRateMantissa = initialExchangeRateMantissa_;
1182         require(initialExchangeRateMantissa > 0, "initial exchange rate must be greater than zero.");
1183 
1184         // Set the bController
1185         uint err = _setBController(bController_);
1186         require(err == uint(Error.NO_ERROR), "setting bController failed");
1187 
1188         // Initialize block number and borrow index (block number mocks depend on bController being set)
1189         accrualBlockNumber = getBlockNumber();
1190         borrowIndex = mantissaOne;
1191 
1192         // Set the interest rate model (depends on block number / borrow index)
1193         err = _setInterestRateModelFresh(interestRateModel_);
1194         require(err == uint(Error.NO_ERROR), "setting interest rate model failed");
1195 
1196         name = name_;
1197         symbol = symbol_;
1198         decimals = decimals_;
1199 
1200         // The counter starts true to prevent changing it from zero to non-zero (i.e. smaller cost/refund)
1201         _notEntered = true;
1202     }
1203 
1204     /**
1205      * @notice Transfer `tokens` tokens from `src` to `dst` by `spender`
1206      * @dev Called by both `transfer` and `transferFrom` internally
1207      * @param spender The address of the account performing the transfer
1208      * @param src The address of the source account
1209      * @param dst The address of the destination account
1210      * @param tokens The number of tokens to transfer
1211      * @return Whether or not the transfer succeeded
1212      */
1213     function transferTokens(address spender, address src, address dst, uint tokens) internal returns (uint) {
1214         /* Fail if transfer not allowed */
1215         uint allowed = bController.transferAllowed(address(this), src, dst, tokens);
1216         if (allowed != 0) {
1217             return failOpaque(Error.BCONTROLLER_REJECTION, FailureInfo.TRANSFER_BCONTROLLER_REJECTION, allowed);
1218         }
1219 
1220         /* Do not allow self-transfers */
1221         if (src == dst) {
1222             return fail(Error.BAD_INPUT, FailureInfo.TRANSFER_NOT_ALLOWED);
1223         }
1224 
1225         /* Get the allowance, infinite for the account owner */
1226         uint startingAllowance = 0;
1227         if (spender == src) {
1228             startingAllowance = uint(-1);
1229         } else {
1230             startingAllowance = transferAllowances[src][spender];
1231         }
1232 
1233         /* Do the calculations, checking for {under,over}flow */
1234         MathError mathErr;
1235         uint allowanceNew;
1236         uint scrTokensNew;
1237         uint dstTokensNew;
1238 
1239         (mathErr, allowanceNew) = subUInt(startingAllowance, tokens);
1240         if (mathErr != MathError.NO_ERROR) {
1241             return fail(Error.MATH_ERROR, FailureInfo.TRANSFER_NOT_ALLOWED);
1242         }
1243 
1244         (mathErr, scrTokensNew) = subUInt(accountTokens[src], tokens);
1245         if (mathErr != MathError.NO_ERROR) {
1246             return fail(Error.MATH_ERROR, FailureInfo.TRANSFER_NOT_ENOUGH);
1247         }
1248 
1249         (mathErr, dstTokensNew) = addUInt(accountTokens[dst], tokens);
1250         if (mathErr != MathError.NO_ERROR) {
1251             return fail(Error.MATH_ERROR, FailureInfo.TRANSFER_TOO_MUCH);
1252         }
1253 
1254         /////////////////////////
1255         // EFFECTS & INTERACTIONS
1256         // (No safe failures beyond this point)
1257 
1258         accountTokens[src] = scrTokensNew;
1259         accountTokens[dst] = dstTokensNew;
1260 
1261         /* Eat some of the allowance (if necessary) */
1262         if (startingAllowance != uint(-1)) {
1263             transferAllowances[src][spender] = allowanceNew;
1264         }
1265 
1266         /* We emit a Transfer event */
1267         emit Transfer(src, dst, tokens);
1268 
1269         bController.transferVerify(address(this), src, dst, tokens);
1270 
1271         return uint(Error.NO_ERROR);
1272     }
1273 
1274     /**
1275      * @notice Transfer `amount` tokens from `msg.sender` to `dst`
1276      * @param dst The address of the destination account
1277      * @param amount The number of tokens to transfer
1278      * @return Whether or not the transfer succeeded
1279      */
1280     function transfer(address dst, uint256 amount) external nonReentrant returns (bool) {
1281         return transferTokens(msg.sender, msg.sender, dst, amount) == uint(Error.NO_ERROR);
1282     }
1283 
1284     /**
1285      * @notice Transfer `amount` tokens from `src` to `dst`
1286      * @param src The address of the source account
1287      * @param dst The address of the destination account
1288      * @param amount The number of tokens to transfer
1289      * @return Whether or not the transfer succeeded
1290      */
1291     function transferFrom(address src, address dst, uint256 amount) external nonReentrant returns (bool) {
1292         return transferTokens(msg.sender, src, dst, amount) == uint(Error.NO_ERROR);
1293     }
1294 
1295     /**
1296      * @notice Approve `spender` to transfer up to `amount` from `src`
1297      * @dev This will overwrite the approval amount for `spender`
1298      *  and is subject to issues noted [here](https://eips.ethereum.org/EIPS/eip-20#approve)
1299      * @param spender The address of the account which may transfer tokens
1300      * @param amount The number of tokens that are approved (-1 means infinite)
1301      * @return Whether or not the approval succeeded
1302      */
1303     function approve(address spender, uint256 amount) external returns (bool) {
1304         address src = msg.sender;
1305         transferAllowances[src][spender] = amount;
1306         emit Approval(src, spender, amount);
1307         return true;
1308     }
1309 
1310     /**
1311      * @notice Get the current allowance from `owner` for `spender`
1312      * @param owner The address of the account which owns the tokens to be spent
1313      * @param spender The address of the account which may transfer tokens
1314      * @return The number of tokens allowed to be spent (-1 means infinite)
1315      */
1316     function allowance(address owner, address spender) external view returns (uint256) {
1317         return transferAllowances[owner][spender];
1318     }
1319 
1320     /**
1321      * @notice Get the token balance of the `owner`
1322      * @param owner The address of the account to query
1323      * @return The number of tokens owned by `owner`
1324      */
1325     function balanceOf(address owner) external view returns (uint256) {
1326         return accountTokens[owner];
1327     }
1328 
1329     /**
1330      * @notice Get the underlying balance of the `owner`
1331      * @dev This also accrues interest in a transaction
1332      * @param owner The address of the account to query
1333      * @return The amount of underlying owned by `owner`
1334      */
1335     function balanceOfUnderlying(address owner) external returns (uint) {
1336         Exp memory exchangeRate = Exp({mantissa: exchangeRateCurrent()});
1337         (MathError mErr, uint balance) = mulScalarTruncate(exchangeRate, accountTokens[owner]);
1338         require(mErr == MathError.NO_ERROR, "balance could not be calculated");
1339         return balance;
1340     }
1341 
1342     /**
1343      * @notice Get a snapshot of the account's balances, and the cached exchange rate
1344      * @dev This is used by bController to more efficiently perform liquidity checks.
1345      * @param account Address of the account to snapshot
1346      * @return (possible error, token balance, borrow balance, exchange rate mantissa)
1347      */
1348     function getAccountSnapshot(address account) external view returns (uint, uint, uint, uint) {
1349         uint bTokenBalance = accountTokens[account];
1350         uint borrowBalance;
1351         uint exchangeRateMantissa;
1352 
1353         MathError mErr;
1354 
1355         (mErr, borrowBalance) = borrowBalanceStoredInternal(account);
1356         if (mErr != MathError.NO_ERROR) {
1357             return (uint(Error.MATH_ERROR), 0, 0, 0);
1358         }
1359 
1360         (mErr, exchangeRateMantissa) = exchangeRateStoredInternal();
1361         if (mErr != MathError.NO_ERROR) {
1362             return (uint(Error.MATH_ERROR), 0, 0, 0);
1363         }
1364 
1365         return (uint(Error.NO_ERROR), bTokenBalance, borrowBalance, exchangeRateMantissa);
1366     }
1367 
1368     /**
1369      * @dev Function to simply retrieve block number
1370      *  This exists mainly for inheriting test contracts to stub this result.
1371      */
1372     function getBlockNumber() internal view returns (uint) {
1373         return block.number;
1374     }
1375 
1376     /**
1377      * @notice Returns the current per-block borrow interest rate for this bToken
1378      * @return The borrow interest rate per block, scaled by 1e18
1379      */
1380     function borrowRatePerBlock() external view returns (uint) {
1381         return interestRateModel.getBorrowRate(getCashPrior(), totalBorrows, totalReserves);
1382     }
1383 
1384     /**
1385      * @notice Returns the current per-block supply interest rate for this bToken
1386      * @return The supply interest rate per block, scaled by 1e18
1387      */
1388     function supplyRatePerBlock() external view returns (uint) {
1389         return interestRateModel.getSupplyRate(getCashPrior(), totalBorrows, totalReserves, reserveFactorMantissa);
1390     }
1391 
1392     /**
1393      * @notice Returns the current total borrows plus accrued interest
1394      * @return The total borrows with interest
1395      */
1396     function totalBorrowsCurrent() external nonReentrant returns (uint) {
1397         require(accrueInterest() == uint(Error.NO_ERROR), "accrue interest failed");
1398         return totalBorrows;
1399     }
1400 
1401     /**
1402      * @notice Accrue interest to updated borrowIndex and then calculate account's borrow balance using the updated borrowIndex
1403      * @param account The address whose balance should be calculated after updating borrowIndex
1404      * @return The calculated balance
1405      */
1406     function borrowBalanceCurrent(address account) external nonReentrant returns (uint) {
1407         require(accrueInterest() == uint(Error.NO_ERROR), "accrue interest failed");
1408         return borrowBalanceStored(account);
1409     }
1410 
1411     /**
1412      * @notice Return the borrow balance of account based on stored data
1413      * @param account The address whose balance should be calculated
1414      * @return The calculated balance
1415      */
1416     function borrowBalanceStored(address account) public view returns (uint) {
1417         (MathError err, uint result) = borrowBalanceStoredInternal(account);
1418         require(err == MathError.NO_ERROR, "borrowBalanceStored: borrowBalanceStoredInternal failed");
1419         return result;
1420     }
1421 
1422     /**
1423      * @notice Return the borrow balance of account based on stored data
1424      * @param account The address whose balance should be calculated
1425      * @return (error code, the calculated balance or 0 if error code is non-zero)
1426      */
1427     function borrowBalanceStoredInternal(address account) internal view returns (MathError, uint) {
1428         /* Note: we do not assert that the market is up to date */
1429         MathError mathErr;
1430         uint principalTimesIndex;
1431         uint result;
1432 
1433         /* Get borrowBalance and borrowIndex */
1434         BorrowSnapshot storage borrowSnapshot = accountBorrows[account];
1435 
1436         /* If borrowBalance = 0 then borrowIndex is likely also 0.
1437          * Rather than failing the calculation with a division by 0, we immediately return 0 in this case.
1438          */
1439         if (borrowSnapshot.principal == 0) {
1440             return (MathError.NO_ERROR, 0);
1441         }
1442 
1443         /* Calculate new borrow balance using the interest index:
1444          *  recentBorrowBalance = borrower.borrowBalance * market.borrowIndex / borrower.borrowIndex
1445          */
1446         (mathErr, principalTimesIndex) = mulUInt(borrowSnapshot.principal, borrowIndex);
1447         if (mathErr != MathError.NO_ERROR) {
1448             return (mathErr, 0);
1449         }
1450 
1451         (mathErr, result) = divUInt(principalTimesIndex, borrowSnapshot.interestIndex);
1452         if (mathErr != MathError.NO_ERROR) {
1453             return (mathErr, 0);
1454         }
1455 
1456         return (MathError.NO_ERROR, result);
1457     }
1458 
1459     /**
1460      * @notice Accrue interest then return the up-to-date exchange rate
1461      * @return Calculated exchange rate scaled by 1e18
1462      */
1463     function exchangeRateCurrent() public nonReentrant returns (uint) {
1464         require(accrueInterest() == uint(Error.NO_ERROR), "accrue interest failed");
1465         return exchangeRateStored();
1466     }
1467 
1468     /**
1469      * @notice Calculates the exchange rate from the underlying to the BToken
1470      * @dev This function does not accrue interest before calculating the exchange rate
1471      * @return Calculated exchange rate scaled by 1e18
1472      */
1473     function exchangeRateStored() public view returns (uint) {
1474         (MathError err, uint result) = exchangeRateStoredInternal();
1475         require(err == MathError.NO_ERROR, "exchangeRateStored: exchangeRateStoredInternal failed");
1476         return result;
1477     }
1478 
1479     /**
1480      * @notice Calculates the exchange rate from the underlying to the BToken
1481      * @dev This function does not accrue interest before calculating the exchange rate
1482      * @return (error code, calculated exchange rate scaled by 1e18)
1483      */
1484     function exchangeRateStoredInternal() internal view returns (MathError, uint) {
1485         uint _totalSupply = totalSupply;
1486         if (_totalSupply == 0) {
1487             /*
1488              * If there are no tokens minted:
1489              *  exchangeRate = initialExchangeRate
1490              */
1491             return (MathError.NO_ERROR, initialExchangeRateMantissa);
1492         } else {
1493             /*
1494              * Otherwise:
1495              *  exchangeRate = (totalCash + totalBorrows - totalReserves) / totalSupply
1496              */
1497             uint totalCash = getCashPrior();
1498             uint cashPlusBorrowsMinusReserves;
1499             Exp memory exchangeRate;
1500             MathError mathErr;
1501 
1502             (mathErr, cashPlusBorrowsMinusReserves) = addThenSubUInt(totalCash, totalBorrows, totalReserves);
1503             if (mathErr != MathError.NO_ERROR) {
1504                 return (mathErr, 0);
1505             }
1506 
1507             (mathErr, exchangeRate) = getExp(cashPlusBorrowsMinusReserves, _totalSupply);
1508             if (mathErr != MathError.NO_ERROR) {
1509                 return (mathErr, 0);
1510             }
1511 
1512             return (MathError.NO_ERROR, exchangeRate.mantissa);
1513         }
1514     }
1515 
1516     /**
1517      * @notice Get cash balance of this bToken in the underlying asset
1518      * @return The quantity of underlying asset owned by this contract
1519      */
1520     function getCash() external view returns (uint) {
1521         return getCashPrior();
1522     }
1523 
1524     /**
1525      * @notice Applies accrued interest to total borrows and reserves
1526      * @dev This calculates interest accrued from the last checkpointed block
1527      *   up to the current block and writes new checkpoint to storage.
1528      */
1529     function accrueInterest() public returns (uint) {
1530         /* Remember the initial block number */
1531         uint currentBlockNumber = getBlockNumber();
1532         uint accrualBlockNumberPrior = accrualBlockNumber;
1533 
1534         /* Short-circuit accumulating 0 interest */
1535         if (accrualBlockNumberPrior == currentBlockNumber) {
1536             return uint(Error.NO_ERROR);
1537         }
1538 
1539         /* Read the previous values out of storage */
1540         uint cashPrior = getCashPrior();
1541         uint borrowsPrior = totalBorrows;
1542         uint reservesPrior = totalReserves;
1543         uint borrowIndexPrior = borrowIndex;
1544 
1545         /* Calculate the current borrow interest rate */
1546         uint borrowRateMantissa = interestRateModel.getBorrowRate(cashPrior, borrowsPrior, reservesPrior);
1547         require(borrowRateMantissa <= borrowRateMaxMantissa, "borrow rate is absurdly high");
1548 
1549         /* Calculate the number of blocks elapsed since the last accrual */
1550         (MathError mathErr, uint blockDelta) = subUInt(currentBlockNumber, accrualBlockNumberPrior);
1551         require(mathErr == MathError.NO_ERROR, "could not calculate block delta");
1552 
1553         /*
1554          * Calculate the interest accumulated into borrows and reserves and the new index:
1555          *  simpleInterestFactor = borrowRate * blockDelta
1556          *  interestAccumulated = simpleInterestFactor * totalBorrows
1557          *  totalBorrowsNew = interestAccumulated + totalBorrows
1558          *  totalReservesNew = interestAccumulated * reserveFactor + totalReserves
1559          *  borrowIndexNew = simpleInterestFactor * borrowIndex + borrowIndex
1560          */
1561 
1562         Exp memory simpleInterestFactor;
1563         uint interestAccumulated;
1564         uint totalBorrowsNew;
1565         uint totalReservesNew;
1566         uint borrowIndexNew;
1567 
1568         (mathErr, simpleInterestFactor) = mulScalar(Exp({mantissa: borrowRateMantissa}), blockDelta);
1569         if (mathErr != MathError.NO_ERROR) {
1570             return failOpaque(Error.MATH_ERROR, FailureInfo.ACCRUE_INTEREST_SIMPLE_INTEREST_FACTOR_CALCULATION_FAILED, uint(mathErr));
1571         }
1572 
1573         (mathErr, interestAccumulated) = mulScalarTruncate(simpleInterestFactor, borrowsPrior);
1574         if (mathErr != MathError.NO_ERROR) {
1575             return failOpaque(Error.MATH_ERROR, FailureInfo.ACCRUE_INTEREST_ACCUMULATED_INTEREST_CALCULATION_FAILED, uint(mathErr));
1576         }
1577 
1578         (mathErr, totalBorrowsNew) = addUInt(interestAccumulated, borrowsPrior);
1579         if (mathErr != MathError.NO_ERROR) {
1580             return failOpaque(Error.MATH_ERROR, FailureInfo.ACCRUE_INTEREST_NEW_TOTAL_BORROWS_CALCULATION_FAILED, uint(mathErr));
1581         }
1582 
1583         (mathErr, totalReservesNew) = mulScalarTruncateAddUInt(Exp({mantissa: reserveFactorMantissa}), interestAccumulated, reservesPrior);
1584         if (mathErr != MathError.NO_ERROR) {
1585             return failOpaque(Error.MATH_ERROR, FailureInfo.ACCRUE_INTEREST_NEW_TOTAL_RESERVES_CALCULATION_FAILED, uint(mathErr));
1586         }
1587 
1588         (mathErr, borrowIndexNew) = mulScalarTruncateAddUInt(simpleInterestFactor, borrowIndexPrior, borrowIndexPrior);
1589         if (mathErr != MathError.NO_ERROR) {
1590             return failOpaque(Error.MATH_ERROR, FailureInfo.ACCRUE_INTEREST_NEW_BORROW_INDEX_CALCULATION_FAILED, uint(mathErr));
1591         }
1592 
1593         /////////////////////////
1594         // EFFECTS & INTERACTIONS
1595         // (No safe failures beyond this point)
1596 
1597         /* We write the previously calculated values into storage */
1598         accrualBlockNumber = currentBlockNumber;
1599         borrowIndex = borrowIndexNew;
1600         totalBorrows = totalBorrowsNew;
1601         totalReserves = totalReservesNew;
1602 
1603         /* We emit an AccrueInterest event */
1604         emit AccrueInterestToken(cashPrior, interestAccumulated, borrowIndexNew, totalBorrowsNew);
1605 
1606         return uint(Error.NO_ERROR);
1607     }
1608 
1609     /**
1610      * @notice Sender supplies assets into the market and receives bTokens in exchange
1611      * @dev Accrues interest whether or not the operation succeeds, unless reverted
1612      * @param mintAmount The amount of the underlying asset to supply
1613      * @return (uint, uint) An error code (0=success, otherwise a failure, see ErrorReporter.sol), and the actual mint amount.
1614      */
1615     function mintInternal(uint mintAmount) internal nonReentrant returns (uint, uint) {
1616         uint error = accrueInterest();
1617         if (error != uint(Error.NO_ERROR)) {
1618             // accrueInterest emits logs on errors, but we still want to log the fact that an attempted borrow failed
1619             return (fail(Error(error), FailureInfo.MINT_ACCRUE_INTEREST_FAILED), 0);
1620         }
1621         // mintFresh emits the actual Mint event if successful and logs on errors, so we don't need to
1622         return mintFresh(msg.sender, mintAmount);
1623     }
1624 
1625     struct MintLocalVars {
1626         Error err;
1627         MathError mathErr;
1628         uint exchangeRateMantissa;
1629         uint mintTokens;
1630         uint totalSupplyNew;
1631         uint accountTokensNew;
1632         uint actualMintAmount;
1633     }
1634 
1635     /**
1636      * @notice User supplies assets into the market and receives bTokens in exchange
1637      * @dev Assumes interest has already been accrued up to the current block
1638      * @param minter The address of the account which is supplying the assets
1639      * @param mintAmount The amount of the underlying asset to supply
1640      * @return (uint, uint) An error code (0=success, otherwise a failure, see ErrorReporter.sol), and the actual mint amount.
1641      */
1642     function mintFresh(address minter, uint mintAmount) internal returns (uint, uint) {
1643         /* Fail if mint not allowed */
1644         uint allowed = bController.mintAllowed(address(this), minter, mintAmount);
1645 
1646         if (allowed != 0) {
1647             return (failOpaque(Error.BCONTROLLER_REJECTION, FailureInfo.MINT_BCONTROLLER_REJECTION, allowed), 0);
1648         }
1649 
1650         /* Verify market's block number equals current block number */
1651         if (accrualBlockNumber != getBlockNumber()) {
1652             return (fail(Error.MARKET_NOT_FRESH, FailureInfo.MINT_FRESHNESS_CHECK), 0);
1653         }
1654 
1655         MintLocalVars memory vars;
1656 
1657         (vars.mathErr, vars.exchangeRateMantissa) = exchangeRateStoredInternal();
1658         if (vars.mathErr != MathError.NO_ERROR) {
1659             return (failOpaque(Error.MATH_ERROR, FailureInfo.MINT_EXCHANGE_RATE_READ_FAILED, uint(vars.mathErr)), 0);
1660         }
1661 
1662         /////////////////////////
1663         // EFFECTS & INTERACTIONS
1664         // (No safe failures beyond this point)
1665 
1666         /*
1667          *  We call `doTransferIn` for the minter and the mintAmount.
1668          *  Note: The bToken must handle variations between ERC-20 and ETH underlying.
1669          *  `doTransferIn` reverts if anything goes wrong, since we can't be sure if
1670          *  side-effects occurred. The function returns the amount actually transferred,
1671          *  in case of a fee. On success, the bToken holds an additional `actualMintAmount`
1672          *  of cash.
1673          */
1674         vars.actualMintAmount = doTransferIn(minter, mintAmount);
1675 
1676         /*
1677          * We get the current exchange rate and calculate the number of bTokens to be minted:
1678          *  mintTokens = actualMintAmount / exchangeRate
1679          */
1680 
1681         (vars.mathErr, vars.mintTokens) = divScalarByExpTruncate(vars.actualMintAmount, Exp({mantissa: vars.exchangeRateMantissa}));
1682         require(vars.mathErr == MathError.NO_ERROR, "MINT_EXCHANGE_CALCULATION_FAILED");
1683 
1684         /*
1685          * We calculate the new total supply of bTokens and minter token balance, checking for overflow:
1686          *  totalSupplyNew = totalSupply + mintTokens
1687          *  accountTokensNew = accountTokens[minter] + mintTokens
1688          */
1689         (vars.mathErr, vars.totalSupplyNew) = addUInt(totalSupply, vars.mintTokens);
1690         require(vars.mathErr == MathError.NO_ERROR, "MINT_NEW_TOTAL_SUPPLY_CALCULATION_FAILED");
1691 
1692         (vars.mathErr, vars.accountTokensNew) = addUInt(accountTokens[minter], vars.mintTokens);
1693         require(vars.mathErr == MathError.NO_ERROR, "MINT_NEW_ACCOUNT_BALANCE_CALCULATION_FAILED");
1694 
1695         /* We write previously calculated values into storage */
1696         totalSupply = vars.totalSupplyNew;
1697         accountTokens[minter] = vars.accountTokensNew;
1698 
1699         /* We emit a Mint event, and a Transfer event */
1700         emit MintToken(minter, vars.actualMintAmount, vars.mintTokens);
1701         emit Transfer(address(this), minter, vars.mintTokens);
1702 
1703         /* We call the defense hook */
1704         bController.mintVerify(address(this), minter, vars.actualMintAmount, vars.mintTokens);
1705 
1706         return (uint(Error.NO_ERROR), vars.actualMintAmount);
1707     }
1708 
1709     /**
1710      * @notice Sender redeems bTokens in exchange for the underlying asset
1711      * @dev Accrues interest whether or not the operation succeeds, unless reverted
1712      * @param redeemTokens The number of bTokens to redeem into underlying
1713      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
1714      */
1715     function redeemInternal(uint redeemTokens) internal nonReentrant returns (uint) {
1716         uint error = accrueInterest();
1717         if (error != uint(Error.NO_ERROR)) {
1718             // accrueInterest emits logs on errors, but we still want to log the fact that an attempted redeem failed
1719             return fail(Error(error), FailureInfo.REDEEM_ACCRUE_INTEREST_FAILED);
1720         }
1721         // redeemFresh emits redeem-specific logs on errors, so we don't need to
1722         return redeemFresh(msg.sender, redeemTokens, 0);
1723     }
1724 
1725     /**
1726      * @notice Sender redeems bTokens in exchange for a specified amount of underlying asset
1727      * @dev Accrues interest whether or not the operation succeeds, unless reverted
1728      * @param redeemAmount The amount of underlying to receive from redeeming bTokens
1729      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
1730      */
1731     function redeemUnderlyingInternal(uint redeemAmount) internal nonReentrant returns (uint) {
1732         uint error = accrueInterest();
1733         if (error != uint(Error.NO_ERROR)) {
1734             // accrueInterest emits logs on errors, but we still want to log the fact that an attempted redeem failed
1735             return fail(Error(error), FailureInfo.REDEEM_ACCRUE_INTEREST_FAILED);
1736         }
1737         // redeemFresh emits redeem-specific logs on errors, so we don't need to
1738         return redeemFresh(msg.sender, 0, redeemAmount);
1739     }
1740 
1741     struct RedeemLocalVars {
1742         Error err;
1743         MathError mathErr;
1744         uint exchangeRateMantissa;
1745         uint redeemTokens;
1746         uint redeemAmount;
1747         uint totalSupplyNew;
1748         uint accountTokensNew;
1749     }
1750 
1751     /**
1752      * @notice User redeems bTokens in exchange for the underlying asset
1753      * @dev Assumes interest has already been accrued up to the current block
1754      * @param redeemer The address of the account which is redeeming the tokens
1755      * @param redeemTokensIn The number of bTokens to redeem into underlying (only one of redeemTokensIn or redeemAmountIn may be non-zero)
1756      * @param redeemAmountIn The number of underlying tokens to receive from redeeming bTokens (only one of redeemTokensIn or redeemAmountIn may be non-zero)
1757      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
1758      */
1759     function redeemFresh(address payable redeemer, uint redeemTokensIn, uint redeemAmountIn) internal returns (uint) {
1760         require(redeemTokensIn == 0 || redeemAmountIn == 0, "one of redeemTokensIn or redeemAmountIn must be zero");
1761 
1762         RedeemLocalVars memory vars;
1763 
1764         /* exchangeRate = invoke Exchange Rate Stored() */
1765         (vars.mathErr, vars.exchangeRateMantissa) = exchangeRateStoredInternal();
1766         if (vars.mathErr != MathError.NO_ERROR) {
1767             return failOpaque(Error.MATH_ERROR, FailureInfo.REDEEM_EXCHANGE_RATE_READ_FAILED, uint(vars.mathErr));
1768         }
1769 
1770         /* If redeemTokensIn > 0: */
1771         if (redeemTokensIn > 0) {
1772             /*
1773              * We calculate the exchange rate and the amount of underlying to be redeemed:
1774              *  redeemTokens = redeemTokensIn
1775              *  redeemAmount = redeemTokensIn x exchangeRateCurrent
1776              */
1777             vars.redeemTokens = redeemTokensIn;
1778 
1779             (vars.mathErr, vars.redeemAmount) = mulScalarTruncate(Exp({mantissa: vars.exchangeRateMantissa}), redeemTokensIn);
1780             if (vars.mathErr != MathError.NO_ERROR) {
1781                 return failOpaque(Error.MATH_ERROR, FailureInfo.REDEEM_EXCHANGE_TOKENS_CALCULATION_FAILED, uint(vars.mathErr));
1782             }
1783         } else {
1784             /*
1785              * We get the current exchange rate and calculate the amount to be redeemed:
1786              *  redeemTokens = redeemAmountIn / exchangeRate
1787              *  redeemAmount = redeemAmountIn
1788              */
1789 
1790             (vars.mathErr, vars.redeemTokens) = divScalarByExpTruncate(redeemAmountIn, Exp({mantissa: vars.exchangeRateMantissa}));
1791             if (vars.mathErr != MathError.NO_ERROR) {
1792                 return failOpaque(Error.MATH_ERROR, FailureInfo.REDEEM_EXCHANGE_AMOUNT_CALCULATION_FAILED, uint(vars.mathErr));
1793             }
1794 
1795             vars.redeemAmount = redeemAmountIn;
1796         }
1797 
1798         /* Fail if redeem not allowed */
1799         uint allowed = bController.redeemAllowed(address(this), redeemer, vars.redeemTokens);
1800 
1801         if (allowed != 0) {
1802             return failOpaque(Error.BCONTROLLER_REJECTION, FailureInfo.REDEEM_BCONTROLLER_REJECTION, allowed);
1803         }
1804 
1805         /* Verify market's block number equals current block number */
1806         if (accrualBlockNumber != getBlockNumber()) {
1807             return fail(Error.MARKET_NOT_FRESH, FailureInfo.REDEEM_FRESHNESS_CHECK);
1808         }
1809 
1810         /*
1811          * We calculate the new total supply and redeemer balance, checking for underflow:
1812          *  totalSupplyNew = totalSupply - redeemTokens
1813          *  accountTokensNew = accountTokens[redeemer] - redeemTokens
1814          */
1815         (vars.mathErr, vars.totalSupplyNew) = subUInt(totalSupply, vars.redeemTokens);
1816         if (vars.mathErr != MathError.NO_ERROR) {
1817             return failOpaque(Error.MATH_ERROR, FailureInfo.REDEEM_NEW_TOTAL_SUPPLY_CALCULATION_FAILED, uint(vars.mathErr));
1818         }
1819 
1820         (vars.mathErr, vars.accountTokensNew) = subUInt(accountTokens[redeemer], vars.redeemTokens);
1821         if (vars.mathErr != MathError.NO_ERROR) {
1822             return failOpaque(Error.MATH_ERROR, FailureInfo.REDEEM_NEW_ACCOUNT_BALANCE_CALCULATION_FAILED, uint(vars.mathErr));
1823         }
1824 
1825         /* Fail gracefully if protocol has insufficient cash */
1826         if (getCashPrior() < vars.redeemAmount) {
1827             return fail(Error.TOKEN_INSUFFICIENT_CASH, FailureInfo.REDEEM_TRANSFER_OUT_NOT_POSSIBLE);
1828         }
1829 
1830         /////////////////////////
1831         // EFFECTS & INTERACTIONS
1832         // (No safe failures beyond this point)
1833 
1834         /*
1835          * We invoke doTransferOut for the redeemer and the redeemAmount.
1836          *  Note: The bToken must handle variations between ERC-20 and ETH underlying.
1837          *  On success, the bToken has redeemAmount less of cash.
1838          *  doTransferOut reverts if anything goes wrong, since we can't be sure if side effects occurred.
1839          */
1840         doTransferOut(redeemer, vars.redeemAmount);
1841 
1842         /* We write previously calculated values into storage */
1843         totalSupply = vars.totalSupplyNew;
1844         accountTokens[redeemer] = vars.accountTokensNew;
1845 
1846         /* We emit a Transfer event, and a Redeem event */
1847         emit Transfer(redeemer, address(this), vars.redeemTokens);
1848         emit RedeemToken(redeemer, vars.redeemAmount, vars.redeemTokens);
1849 
1850         /* We call the defense hook */
1851         bController.redeemVerify(address(this), redeemer, vars.redeemAmount, vars.redeemTokens);
1852 
1853         return uint(Error.NO_ERROR);
1854     }
1855 
1856     /**
1857       * @notice Sender borrows assets from the protocol to their own address
1858       * @param borrowAmount The amount of the underlying asset to borrow
1859       * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
1860       */
1861     function borrowInternal(uint borrowAmount) internal nonReentrant returns (uint) {
1862         uint error = accrueInterest();
1863         if (error != uint(Error.NO_ERROR)) {
1864             // accrueInterest emits logs on errors, but we still want to log the fact that an attempted borrow failed
1865             return fail(Error(error), FailureInfo.BORROW_ACCRUE_INTEREST_FAILED);
1866         }
1867         // borrowFresh emits borrow-specific logs on errors, so we don't need to
1868         return borrowFresh(msg.sender, borrowAmount);
1869     }
1870 
1871     struct BorrowLocalVars {
1872         MathError mathErr;
1873         uint accountBorrows;
1874         uint accountBorrowsNew;
1875         uint totalBorrowsNew;
1876     }
1877 
1878     /**
1879       * @notice Users borrow assets from the protocol to their own address
1880       * @param borrowAmount The amount of the underlying asset to borrow
1881       * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
1882       */
1883     function borrowFresh(address payable borrower, uint borrowAmount) internal returns (uint) {
1884         /* Fail if borrow not allowed */
1885         uint allowed = bController.borrowAllowed(address(this), borrower, borrowAmount);
1886         if (allowed != 0) {
1887             return failOpaque(Error.BCONTROLLER_REJECTION, FailureInfo.BORROW_BCONTROLLER_REJECTION, allowed);
1888         }
1889 
1890         /* Verify market's block number equals current block number */
1891         if (accrualBlockNumber != getBlockNumber()) {
1892             return fail(Error.MARKET_NOT_FRESH, FailureInfo.BORROW_FRESHNESS_CHECK);
1893         }
1894 
1895         /* Fail gracefully if protocol has insufficient underlying cash */
1896         if (getCashPrior() < borrowAmount) {
1897             return fail(Error.TOKEN_INSUFFICIENT_CASH, FailureInfo.BORROW_CASH_NOT_AVAILABLE);
1898         }
1899 
1900         BorrowLocalVars memory vars;
1901 
1902         /*
1903          * We calculate the new borrower and total borrow balances, failing on overflow:
1904          *  accountBorrowsNew = accountBorrows + borrowAmount
1905          *  totalBorrowsNew = totalBorrows + borrowAmount
1906          */
1907         (vars.mathErr, vars.accountBorrows) = borrowBalanceStoredInternal(borrower);
1908         if (vars.mathErr != MathError.NO_ERROR) {
1909             return failOpaque(Error.MATH_ERROR, FailureInfo.BORROW_ACCUMULATED_BALANCE_CALCULATION_FAILED, uint(vars.mathErr));
1910         }
1911 
1912         (vars.mathErr, vars.accountBorrowsNew) = addUInt(vars.accountBorrows, borrowAmount);
1913         if (vars.mathErr != MathError.NO_ERROR) {
1914             return failOpaque(Error.MATH_ERROR, FailureInfo.BORROW_NEW_ACCOUNT_BORROW_BALANCE_CALCULATION_FAILED, uint(vars.mathErr));
1915         }
1916 
1917         (vars.mathErr, vars.totalBorrowsNew) = addUInt(totalBorrows, borrowAmount);
1918         if (vars.mathErr != MathError.NO_ERROR) {
1919             return failOpaque(Error.MATH_ERROR, FailureInfo.BORROW_NEW_TOTAL_BALANCE_CALCULATION_FAILED, uint(vars.mathErr));
1920         }
1921 
1922         /////////////////////////
1923         // EFFECTS & INTERACTIONS
1924         // (No safe failures beyond this point)
1925 
1926         /*
1927          * We invoke doTransferOut for the borrower and the borrowAmount.
1928          *  Note: The bToken must handle variations between ERC-20 and ETH underlying.
1929          *  On success, the bToken borrowAmount less of cash.
1930          *  doTransferOut reverts if anything goes wrong, since we can't be sure if side effects occurred.
1931          */
1932         doTransferOut(borrower, borrowAmount);
1933 
1934         /* We write the previously calculated values into storage */
1935         accountBorrows[borrower].principal = vars.accountBorrowsNew;
1936         accountBorrows[borrower].interestIndex = borrowIndex;
1937         totalBorrows = vars.totalBorrowsNew;
1938 
1939         /* We emit a Borrow event */
1940         emit BorrowToken(borrower, borrowAmount, vars.accountBorrowsNew, vars.totalBorrowsNew);
1941 
1942         /* We call the defense hook */
1943         bController.borrowVerify(address(this), borrower, borrowAmount);
1944 
1945         return uint(Error.NO_ERROR);
1946     }
1947 
1948     /**
1949      * @notice Sender repays their own borrow
1950      * @param repayAmount The amount to repay
1951      * @return (uint, uint) An error code (0=success, otherwise a failure, see ErrorReporter.sol), and the actual repayment amount.
1952      */
1953     function repayBorrowInternal(uint repayAmount) internal nonReentrant returns (uint, uint) {
1954         uint error = accrueInterest();
1955         if (error != uint(Error.NO_ERROR)) {
1956             // accrueInterest emits logs on errors, but we still want to log the fact that an attempted borrow failed
1957             return (fail(Error(error), FailureInfo.REPAY_BORROW_ACCRUE_INTEREST_FAILED), 0);
1958         }
1959         // repayBorrowFresh emits repay-borrow-specific logs on errors, so we don't need to
1960         return repayBorrowFresh(msg.sender, msg.sender, repayAmount);
1961     }
1962 
1963     /**
1964      * @notice Sender repays a borrow belonging to borrower
1965      * @param borrower the account with the debt being payed off
1966      * @param repayAmount The amount to repay
1967      * @return (uint, uint) An error code (0=success, otherwise a failure, see ErrorReporter.sol), and the actual repayment amount.
1968      */
1969     function repayBorrowBehalfInternal(address borrower, uint repayAmount) internal nonReentrant returns (uint, uint) {
1970         uint error = accrueInterest();
1971         if (error != uint(Error.NO_ERROR)) {
1972             // accrueInterest emits logs on errors, but we still want to log the fact that an attempted borrow failed
1973             return (fail(Error(error), FailureInfo.REPAY_BEHALF_ACCRUE_INTEREST_FAILED), 0);
1974         }
1975         // repayBorrowFresh emits repay-borrow-specific logs on errors, so we don't need to
1976         return repayBorrowFresh(msg.sender, borrower, repayAmount);
1977     }
1978 
1979     struct RepayBorrowLocalVars {
1980         Error err;
1981         MathError mathErr;
1982         uint repayAmount;
1983         uint borrowerIndex;
1984         uint accountBorrows;
1985         uint accountBorrowsNew;
1986         uint totalBorrowsNew;
1987         uint actualRepayAmount;
1988     }
1989 
1990     /**
1991      * @notice Borrows are repaid by another user (possibly the borrower).
1992      * @param payer the account paying off the borrow
1993      * @param borrower the account with the debt being payed off
1994      * @param repayAmount the amount of undelrying tokens being returned
1995      * @return (uint, uint) An error code (0=success, otherwise a failure, see ErrorReporter.sol), and the actual repayment amount.
1996      */
1997     function repayBorrowFresh(address payer, address borrower, uint repayAmount) internal returns (uint, uint) {
1998         /* Fail if repayBorrow not allowed */
1999         uint allowed = bController.repayBorrowAllowed(address(this), payer, borrower, repayAmount);
2000         if (allowed != 0) {
2001             return (failOpaque(Error.BCONTROLLER_REJECTION, FailureInfo.REPAY_BORROW_BCONTROLLER_REJECTION, allowed), 0);
2002         }
2003 
2004         /* Verify market's block number equals current block number */
2005         if (accrualBlockNumber != getBlockNumber()) {
2006             return (fail(Error.MARKET_NOT_FRESH, FailureInfo.REPAY_BORROW_FRESHNESS_CHECK), 0);
2007         }
2008 
2009         RepayBorrowLocalVars memory vars;
2010 
2011         /* We remember the original borrowerIndex for verification purposes */
2012         vars.borrowerIndex = accountBorrows[borrower].interestIndex;
2013 
2014         /* We fetch the amount the borrower owes, with accumulated interest */
2015         (vars.mathErr, vars.accountBorrows) = borrowBalanceStoredInternal(borrower);
2016         if (vars.mathErr != MathError.NO_ERROR) {
2017             return (failOpaque(Error.MATH_ERROR, FailureInfo.REPAY_BORROW_ACCUMULATED_BALANCE_CALCULATION_FAILED, uint(vars.mathErr)), 0);
2018         }
2019 
2020         /* If repayAmount == -1, repayAmount = accountBorrows */
2021         if (repayAmount == uint(-1)) {
2022             vars.repayAmount = vars.accountBorrows;
2023         } else {
2024             vars.repayAmount = repayAmount;
2025         }
2026 
2027         /////////////////////////
2028         // EFFECTS & INTERACTIONS
2029         // (No safe failures beyond this point)
2030 
2031         /*
2032          * We call doTransferIn for the payer and the repayAmount
2033          *  Note: The bToken must handle variations between ERC-20 and ETH underlying.
2034          *  On success, the bToken holds an additional repayAmount of cash.
2035          *  doTransferIn reverts if anything goes wrong, since we can't be sure if side effects occurred.
2036          *   it returns the amount actually transferred, in case of a fee.
2037          */
2038         vars.actualRepayAmount = doTransferIn(payer, vars.repayAmount);
2039 
2040         /*
2041          * We calculate the new borrower and total borrow balances, failing on underflow:
2042          *  accountBorrowsNew = accountBorrows - actualRepayAmount
2043          *  totalBorrowsNew = totalBorrows - actualRepayAmount
2044          */
2045         (vars.mathErr, vars.accountBorrowsNew) = subUInt(vars.accountBorrows, vars.actualRepayAmount);
2046         require(vars.mathErr == MathError.NO_ERROR, "REPAY_BORROW_NEW_ACCOUNT_BORROW_BALANCE_CALCULATION_FAILED");
2047 
2048         (vars.mathErr, vars.totalBorrowsNew) = subUInt(totalBorrows, vars.actualRepayAmount);
2049         require(vars.mathErr == MathError.NO_ERROR, "REPAY_BORROW_NEW_TOTAL_BALANCE_CALCULATION_FAILED");
2050 
2051         /* We write the previously calculated values into storage */
2052         accountBorrows[borrower].principal = vars.accountBorrowsNew;
2053         accountBorrows[borrower].interestIndex = borrowIndex;
2054         totalBorrows = vars.totalBorrowsNew;
2055 
2056         /* We emit a RepayBorrowToken event */
2057         emit RepayBorrowToken(payer, borrower, vars.actualRepayAmount, vars.accountBorrowsNew, vars.totalBorrowsNew);
2058 
2059         /* We call the defense hook */
2060         bController.repayBorrowVerify(address(this), payer, borrower, vars.actualRepayAmount, vars.borrowerIndex);
2061 
2062         return (uint(Error.NO_ERROR), vars.actualRepayAmount);
2063     }
2064 
2065     /**
2066      * @notice The sender liquidates the borrowers collateral.
2067      *  The collateral seized is transferred to the liquidator.
2068      * @param borrower The borrower of this bToken to be liquidated
2069      * @param bTokenCollateral The market in which to seize collateral from the borrower
2070      * @param repayAmount The amount of the underlying borrowed asset to repay
2071      * @return (uint, uint) An error code (0=success, otherwise a failure, see ErrorReporter.sol), and the actual repayment amount.
2072      */
2073     function liquidateBorrowInternal(address borrower, uint repayAmount, BTokenInterface bTokenCollateral) internal nonReentrant returns (uint, uint) {
2074         uint error = accrueInterest();
2075         if (error != uint(Error.NO_ERROR)) {
2076             // accrueInterest emits logs on errors, but we still want to log the fact that an attempted liquidation failed
2077             return (fail(Error(error), FailureInfo.LIQUIDATE_ACCRUE_BORROW_INTEREST_FAILED), 0);
2078         }
2079 
2080         error = bTokenCollateral.accrueInterest();
2081         if (error != uint(Error.NO_ERROR)) {
2082             // accrueInterest emits logs on errors, but we still want to log the fact that an attempted liquidation failed
2083             return (fail(Error(error), FailureInfo.LIQUIDATE_ACCRUE_COLLATERAL_INTEREST_FAILED), 0);
2084         }
2085 
2086         // liquidateBorrowFresh emits borrow-specific logs on errors, so we don't need to
2087         return liquidateBorrowFresh(msg.sender, borrower, repayAmount, bTokenCollateral);
2088     }
2089 
2090     /**
2091      * @notice The liquidator liquidates the borrowers collateral.
2092      *  The collateral seized is transferred to the liquidator.
2093      * @param borrower The borrower of this bToken to be liquidated
2094      * @param liquidator The address repaying the borrow and seizing collateral
2095      * @param bTokenCollateral The market in which to seize collateral from the borrower
2096      * @param repayAmount The amount of the underlying borrowed asset to repay
2097      * @return (uint, uint) An error code (0=success, otherwise a failure, see ErrorReporter.sol), and the actual repayment amount.
2098      */
2099     function liquidateBorrowFresh(address liquidator, address borrower, uint repayAmount, BTokenInterface bTokenCollateral) internal returns (uint, uint) {
2100         /* Fail if liquidate not allowed */
2101         uint allowed = bController.liquidateBorrowAllowed(address(this), address(bTokenCollateral), liquidator, borrower, repayAmount);
2102         if (allowed != 0) {
2103             return (failOpaque(Error.BCONTROLLER_REJECTION, FailureInfo.LIQUIDATE_BCONTROLLER_REJECTION, allowed), 0);
2104         }
2105 
2106         /* Verify market's block number equals current block number */
2107         if (accrualBlockNumber != getBlockNumber()) {
2108             return (fail(Error.MARKET_NOT_FRESH, FailureInfo.LIQUIDATE_FRESHNESS_CHECK), 0);
2109         }
2110 
2111         /* Verify bTokenCollateral market's block number equals current block number */
2112         if (bTokenCollateral.accrualBlockNumber() != getBlockNumber()) {
2113             return (fail(Error.MARKET_NOT_FRESH, FailureInfo.LIQUIDATE_COLLATERAL_FRESHNESS_CHECK), 0);
2114         }
2115 
2116         /* Fail if borrower = liquidator */
2117         if (borrower == liquidator) {
2118             return (fail(Error.INVALID_ACCOUNT_PAIR, FailureInfo.LIQUIDATE_LIQUIDATOR_IS_BORROWER), 0);
2119         }
2120 
2121         /* Fail if repayAmount = 0 */
2122         if (repayAmount == 0) {
2123             return (fail(Error.INVALID_CLOSE_AMOUNT_REQUESTED, FailureInfo.LIQUIDATE_CLOSE_AMOUNT_IS_ZERO), 0);
2124         }
2125 
2126         /* Fail if repayAmount = -1 */
2127         if (repayAmount == uint(-1)) {
2128             return (fail(Error.INVALID_CLOSE_AMOUNT_REQUESTED, FailureInfo.LIQUIDATE_CLOSE_AMOUNT_IS_UINT_MAX), 0);
2129         }
2130 
2131 
2132         /* Fail if repayBorrow fails */
2133         (uint repayBorrowError, uint actualRepayAmount) = repayBorrowFresh(liquidator, borrower, repayAmount);
2134         if (repayBorrowError != uint(Error.NO_ERROR)) {
2135             return (fail(Error(repayBorrowError), FailureInfo.LIQUIDATE_REPAY_BORROW_FRESH_FAILED), 0);
2136         }
2137 
2138         /////////////////////////
2139         // EFFECTS & INTERACTIONS
2140         // (No safe failures beyond this point)
2141 
2142         /* We calculate the number of collateral tokens that will be seized */
2143         (uint amountSeizeError, uint seizeTokens) = bController.liquidateCalculateSeizeTokens(address(this), address(bTokenCollateral), actualRepayAmount);
2144         require(amountSeizeError == uint(Error.NO_ERROR), "LIQUIDATE_BCONTROLLER_CALCULATE_AMOUNT_SEIZE_FAILED");
2145 
2146         /* Revert if borrower collateral token balance < seizeTokens */
2147         require(bTokenCollateral.balanceOf(borrower) >= seizeTokens, "LIQUIDATE_SEIZE_TOO_MUCH");
2148 
2149         // If this is also the collateral, run seizeInternal to avoid re-entrancy, otherwise make an external call
2150         uint seizeError;
2151         if (address(bTokenCollateral) == address(this)) {
2152             seizeError = seizeInternal(address(this), liquidator, borrower, seizeTokens);
2153         } else {
2154             seizeError = bTokenCollateral.seize(liquidator, borrower, seizeTokens);
2155         }
2156 
2157         /* Revert if seize tokens fails (since we cannot be sure of side effects) */
2158         require(seizeError == uint(Error.NO_ERROR), "token seizure failed");
2159 
2160         /* We emit a LiquidateBorrowToken event */
2161         emit LiquidateBorrowToken(liquidator, borrower, actualRepayAmount, address(bTokenCollateral), seizeTokens);
2162 
2163         /* We call the defense hook */
2164         bController.liquidateBorrowVerify(address(this), address(bTokenCollateral), liquidator, borrower, actualRepayAmount, seizeTokens);
2165 
2166         return (uint(Error.NO_ERROR), actualRepayAmount);
2167     }
2168 
2169     /**
2170      * @notice Transfers collateral tokens (this market) to the liquidator.
2171      * @dev Will fail unless called by another bToken during the process of liquidation.
2172      *  Its absolutely critical to use msg.sender as the borrowed bToken and not a parameter.
2173      * @param liquidator The account receiving seized collateral
2174      * @param borrower The account having collateral seized
2175      * @param seizeTokens The number of bTokens to seize
2176      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
2177      */
2178     function seize(address liquidator, address borrower, uint seizeTokens) external nonReentrant returns (uint) {
2179         return seizeInternal(msg.sender, liquidator, borrower, seizeTokens);
2180     }
2181 
2182     /**
2183      * @notice Transfers collateral tokens (this market) to the liquidator.
2184      * @dev Called only during an in-kind liquidation, or by liquidateBorrow during the liquidation of another BToken.
2185      *  Its absolutely critical to use msg.sender as the seizer bToken and not a parameter.
2186      * @param seizerToken The contract seizing the collateral (i.e. borrowed bToken)
2187      * @param liquidator The account receiving seized collateral
2188      * @param borrower The account having collateral seized
2189      * @param seizeTokens The number of bTokens to seize
2190      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
2191      */
2192     function seizeInternal(address seizerToken, address liquidator, address borrower, uint seizeTokens) internal returns (uint) {
2193         /* Fail if seize not allowed */
2194         uint allowed = bController.seizeAllowed(address(this), seizerToken, liquidator, borrower, seizeTokens);
2195         if (allowed != 0) {
2196             return failOpaque(Error.BCONTROLLER_REJECTION, FailureInfo.LIQUIDATE_SEIZE_BCONTROLLER_REJECTION, allowed);
2197         }
2198 
2199         /* Fail if borrower = liquidator */
2200         if (borrower == liquidator) {
2201             return fail(Error.INVALID_ACCOUNT_PAIR, FailureInfo.LIQUIDATE_SEIZE_LIQUIDATOR_IS_BORROWER);
2202         }
2203 
2204         MathError mathErr;
2205         uint borrowerTokensNew;
2206         uint liquidatorTokensNew;
2207 
2208         /*
2209          * We calculate the new borrower and liquidator token balances, failing on underflow/overflow:
2210          *  borrowerTokensNew = accountTokens[borrower] - seizeTokens
2211          *  liquidatorTokensNew = accountTokens[liquidator] + seizeTokens
2212          */
2213         (mathErr, borrowerTokensNew) = subUInt(accountTokens[borrower], seizeTokens);
2214         if (mathErr != MathError.NO_ERROR) {
2215             return failOpaque(Error.MATH_ERROR, FailureInfo.LIQUIDATE_SEIZE_BALANCE_DECREMENT_FAILED, uint(mathErr));
2216         }
2217 
2218         (mathErr, liquidatorTokensNew) = addUInt(accountTokens[liquidator], seizeTokens);
2219         if (mathErr != MathError.NO_ERROR) {
2220             return failOpaque(Error.MATH_ERROR, FailureInfo.LIQUIDATE_SEIZE_BALANCE_INCREMENT_FAILED, uint(mathErr));
2221         }
2222 
2223         /////////////////////////
2224         // EFFECTS & INTERACTIONS
2225         // (No safe failures beyond this point)
2226 
2227         /* We write the previously calculated values into storage */
2228         accountTokens[borrower] = borrowerTokensNew;
2229         accountTokens[liquidator] = liquidatorTokensNew;
2230 
2231         /* Emit a Transfer event */
2232         emit Transfer(borrower, liquidator, seizeTokens);
2233 
2234         /* We call the defense hook */
2235         bController.seizeVerify(address(this), seizerToken, liquidator, borrower, seizeTokens);
2236 
2237         return uint(Error.NO_ERROR);
2238     }
2239 
2240 
2241     /*** Admin Functions ***/
2242 
2243     /**
2244       * @notice Begins transfer of admin rights. The newPendingAdmin must call `_acceptAdmin` to finalize the transfer.
2245       * @dev Admin function to begin change of admin. The newPendingAdmin must call `_acceptAdmin` to finalize the transfer.
2246       * @param newPendingAdmin New pending admin.
2247       * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
2248       */
2249     function _setPendingAdmin(address payable newPendingAdmin) external returns (uint) {
2250         // Check caller = admin
2251         if (msg.sender != admin) {
2252             return fail(Error.UNAUTHORIZED, FailureInfo.SET_PENDING_ADMIN_OWNER_CHECK);
2253         }
2254 
2255         // Save current value, if any, for inclusion in log
2256         address oldPendingAdmin = pendingAdmin;
2257 
2258         // Store pendingAdmin with value newPendingAdmin
2259         pendingAdmin = newPendingAdmin;
2260 
2261         // Emit NewPendingAdmin(oldPendingAdmin, newPendingAdmin)
2262         emit NewPendingAdmin(oldPendingAdmin, newPendingAdmin);
2263 
2264         return uint(Error.NO_ERROR);
2265     }
2266 
2267     /**
2268       * @notice Accepts transfer of admin rights. msg.sender must be pendingAdmin
2269       * @dev Admin function for pending admin to accept role and update admin
2270       * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
2271       */
2272     function _acceptAdmin() external returns (uint) {
2273         // Check caller is pendingAdmin and pendingAdmin ≠ address(0)
2274         if (msg.sender != pendingAdmin || msg.sender == address(0)) {
2275             return fail(Error.UNAUTHORIZED, FailureInfo.ACCEPT_ADMIN_PENDING_ADMIN_CHECK);
2276         }
2277 
2278         // Save current values for inclusion in log
2279         address oldAdmin = admin;
2280         address oldPendingAdmin = pendingAdmin;
2281 
2282         // Store admin with value pendingAdmin
2283         admin = pendingAdmin;
2284 
2285         // Clear the pending value
2286         pendingAdmin = address(0);
2287 
2288         emit NewAdmin(oldAdmin, admin);
2289         emit NewPendingAdmin(oldPendingAdmin, pendingAdmin);
2290 
2291         return uint(Error.NO_ERROR);
2292     }
2293 
2294     /**
2295       * @notice Sets a new bController for the market
2296       * @dev Admin function to set a new bController
2297       * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
2298       */
2299     function _setBController(BControllerInterface newBController) public returns (uint) {
2300         // Check caller is admin
2301         if (msg.sender != admin) {
2302             return fail(Error.UNAUTHORIZED, FailureInfo.SET_BCONTROLLER_OWNER_CHECK);
2303         }
2304 
2305         BControllerInterface oldBController = bController;
2306         // Ensure invoke bController.isBController() returns true
2307         require(newBController.isBController(), "marker method returned false");
2308 
2309         // Set market's bController to newBController
2310         bController = newBController;
2311 
2312         // Emit NewBController(oldBController, newBController)
2313         emit NewBController(oldBController, newBController);
2314 
2315         return uint(Error.NO_ERROR);
2316     }
2317 
2318     /**
2319       * @notice accrues interest and sets a new reserve factor for the protocol using _setReserveFactorFresh
2320       * @dev Admin function to accrue interest and set a new reserve factor
2321       * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
2322       */
2323     function _setReserveFactor(uint newReserveFactorMantissa) external nonReentrant returns (uint) {
2324         uint error = accrueInterest();
2325         if (error != uint(Error.NO_ERROR)) {
2326             // accrueInterest emits logs on errors, but on top of that we want to log the fact that an attempted reserve factor change failed.
2327             return fail(Error(error), FailureInfo.SET_RESERVE_FACTOR_ACCRUE_INTEREST_FAILED);
2328         }
2329         // _setReserveFactorFresh emits reserve-factor-specific logs on errors, so we don't need to.
2330         return _setReserveFactorFresh(newReserveFactorMantissa);
2331     }
2332 
2333     /**
2334       * @notice Sets a new reserve factor for the protocol (*requires fresh interest accrual)
2335       * @dev Admin function to set a new reserve factor
2336       * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
2337       */
2338     function _setReserveFactorFresh(uint newReserveFactorMantissa) internal returns (uint) {
2339         // Check caller is admin
2340         if (msg.sender != admin) {
2341             return fail(Error.UNAUTHORIZED, FailureInfo.SET_RESERVE_FACTOR_ADMIN_CHECK);
2342         }
2343 
2344         // Verify market's block number equals current block number
2345         if (accrualBlockNumber != getBlockNumber()) {
2346             return fail(Error.MARKET_NOT_FRESH, FailureInfo.SET_RESERVE_FACTOR_FRESH_CHECK);
2347         }
2348 
2349         // Check newReserveFactor ≤ maxReserveFactor
2350         if (newReserveFactorMantissa > reserveFactorMaxMantissa) {
2351             return fail(Error.BAD_INPUT, FailureInfo.SET_RESERVE_FACTOR_BOUNDS_CHECK);
2352         }
2353 
2354         uint oldReserveFactorMantissa = reserveFactorMantissa;
2355         reserveFactorMantissa = newReserveFactorMantissa;
2356 
2357         emit NewTokenReserveFactor(oldReserveFactorMantissa, newReserveFactorMantissa);
2358 
2359         return uint(Error.NO_ERROR);
2360     }
2361 
2362     /**
2363      * @notice Accrues interest and reduces reserves by transferring from msg.sender
2364      * @param addAmount Amount of addition to reserves
2365      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
2366      */
2367     function _addReservesInternal(uint addAmount) internal nonReentrant returns (uint) {
2368         uint error = accrueInterest();
2369         if (error != uint(Error.NO_ERROR)) {
2370             // accrueInterest emits logs on errors, but on top of that we want to log the fact that an attempted reduce reserves failed.
2371             return fail(Error(error), FailureInfo.ADD_RESERVES_ACCRUE_INTEREST_FAILED);
2372         }
2373 
2374         // _addReservesFresh emits reserve-addition-specific logs on errors, so we don't need to.
2375         (error, ) = _addReservesFresh(addAmount);
2376         return error;
2377     }
2378 
2379     /**
2380      * @notice Add reserves by transferring from caller
2381      * @dev Requires fresh interest accrual
2382      * @param addAmount Amount of addition to reserves
2383      * @return (uint, uint) An error code (0=success, otherwise a failure (see ErrorReporter.sol for details)) and the actual amount added, net token fees
2384      */
2385     function _addReservesFresh(uint addAmount) internal returns (uint, uint) {
2386         // totalReserves + actualAddAmount
2387         uint totalReservesNew;
2388         uint actualAddAmount;
2389 
2390         // We fail gracefully unless market's block number equals current block number
2391         if (accrualBlockNumber != getBlockNumber()) {
2392             return (fail(Error.MARKET_NOT_FRESH, FailureInfo.ADD_RESERVES_FRESH_CHECK), actualAddAmount);
2393         }
2394 
2395         /////////////////////////
2396         // EFFECTS & INTERACTIONS
2397         // (No safe failures beyond this point)
2398 
2399         /*
2400          * We call doTransferIn for the caller and the addAmount
2401          *  Note: The bToken must handle variations between ERC-20 and ETH underlying.
2402          *  On success, the bToken holds an additional addAmount of cash.
2403          *  doTransferIn reverts if anything goes wrong, since we can't be sure if side effects occurred.
2404          *  it returns the amount actually transferred, in case of a fee.
2405          */
2406 
2407         actualAddAmount = doTransferIn(msg.sender, addAmount);
2408 
2409         totalReservesNew = totalReserves + actualAddAmount;
2410 
2411         /* Revert on overflow */
2412         require(totalReservesNew >= totalReserves, "add reserves unexpected overflow");
2413 
2414         // Store reserves[n+1] = reserves[n] + actualAddAmount
2415         totalReserves = totalReservesNew;
2416 
2417         /* Emit NewReserves(admin, actualAddAmount, reserves[n+1]) */
2418         emit ReservesAdded(msg.sender, actualAddAmount, totalReservesNew);
2419 
2420         /* Return (NO_ERROR, actualAddAmount) */
2421         return (uint(Error.NO_ERROR), actualAddAmount);
2422     }
2423 
2424 
2425     /**
2426      * @notice Accrues interest and reduces reserves by transferring to admin
2427      * @param reduceAmount Amount of reduction to reserves
2428      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
2429      */
2430     function _reduceReserves(uint reduceAmount) external nonReentrant returns (uint) {
2431         uint error = accrueInterest();
2432         if (error != uint(Error.NO_ERROR)) {
2433             // accrueInterest emits logs on errors, but on top of that we want to log the fact that an attempted reduce reserves failed.
2434             return fail(Error(error), FailureInfo.REDUCE_RESERVES_ACCRUE_INTEREST_FAILED);
2435         }
2436         // _reduceReservesFresh emits reserve-reduction-specific logs on errors, so we don't need to.
2437         return _reduceReservesFresh(reduceAmount);
2438     }
2439 
2440     /**
2441      * @notice Reduces reserves by transferring to admin
2442      * @dev Requires fresh interest accrual
2443      * @param reduceAmount Amount of reduction to reserves
2444      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
2445      */
2446     function _reduceReservesFresh(uint reduceAmount) internal returns (uint) {
2447         // totalReserves - reduceAmount
2448         uint totalReservesNew;
2449 
2450         // Check caller is admin
2451         if (msg.sender != admin) {
2452             return fail(Error.UNAUTHORIZED, FailureInfo.REDUCE_RESERVES_ADMIN_CHECK);
2453         }
2454 
2455         // We fail gracefully unless market's block number equals current block number
2456         if (accrualBlockNumber != getBlockNumber()) {
2457             return fail(Error.MARKET_NOT_FRESH, FailureInfo.REDUCE_RESERVES_FRESH_CHECK);
2458         }
2459 
2460         // Fail gracefully if protocol has insufficient underlying cash
2461         if (getCashPrior() < reduceAmount) {
2462             return fail(Error.TOKEN_INSUFFICIENT_CASH, FailureInfo.REDUCE_RESERVES_CASH_NOT_AVAILABLE);
2463         }
2464 
2465         // Check reduceAmount ≤ reserves[n] (totalReserves)
2466         if (reduceAmount > totalReserves) {
2467             return fail(Error.BAD_INPUT, FailureInfo.REDUCE_RESERVES_VALIDATION);
2468         }
2469 
2470         /////////////////////////
2471         // EFFECTS & INTERACTIONS
2472         // (No safe failures beyond this point)
2473 
2474         totalReservesNew = totalReserves - reduceAmount;
2475         // We checked reduceAmount <= totalReserves above, so this should never revert.
2476         require(totalReservesNew <= totalReserves, "reduce reserves unexpected underflow");
2477 
2478         // Store reserves[n+1] = reserves[n] - reduceAmount
2479         totalReserves = totalReservesNew;
2480 
2481         // doTransferOut reverts if anything goes wrong, since we can't be sure if side effects occurred.
2482         doTransferOut(admin, reduceAmount);
2483 
2484         emit ReservesReduced(admin, reduceAmount, totalReservesNew);
2485 
2486         return uint(Error.NO_ERROR);
2487     }
2488 
2489     /**
2490      * @notice accrues interest and updates the interest rate model using _setInterestRateModelFresh
2491      * @dev Admin function to accrue interest and update the interest rate model
2492      * @param newInterestRateModel the new interest rate model to use
2493      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
2494      */
2495     function _setInterestRateModel(InterestRateModel newInterestRateModel) public returns (uint) {
2496         uint error = accrueInterest();
2497         if (error != uint(Error.NO_ERROR)) {
2498             // accrueInterest emits logs on errors, but on top of that we want to log the fact that an attempted change of interest rate model failed
2499             return fail(Error(error), FailureInfo.SET_INTEREST_RATE_MODEL_ACCRUE_INTEREST_FAILED);
2500         }
2501         // _setInterestRateModelFresh emits interest-rate-model-update-specific logs on errors, so we don't need to.
2502         return _setInterestRateModelFresh(newInterestRateModel);
2503     }
2504 
2505     /**
2506      * @notice updates the interest rate model (*requires fresh interest accrual)
2507      * @dev Admin function to update the interest rate model
2508      * @param newInterestRateModel the new interest rate model to use
2509      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
2510      */
2511     function _setInterestRateModelFresh(InterestRateModel newInterestRateModel) internal returns (uint) {
2512 
2513         // Used to store old model for use in the event that is emitted on success
2514         InterestRateModel oldInterestRateModel;
2515 
2516         // Check caller is admin
2517         if (msg.sender != admin) {
2518             return fail(Error.UNAUTHORIZED, FailureInfo.SET_INTEREST_RATE_MODEL_OWNER_CHECK);
2519         }
2520 
2521         // We fail gracefully unless market's block number equals current block number
2522         if (accrualBlockNumber != getBlockNumber()) {
2523             return fail(Error.MARKET_NOT_FRESH, FailureInfo.SET_INTEREST_RATE_MODEL_FRESH_CHECK);
2524         }
2525 
2526         // Track the market's current interest rate model
2527         oldInterestRateModel = interestRateModel;
2528 
2529         // Ensure invoke newInterestRateModel.isInterestRateModel() returns true
2530         require(newInterestRateModel.isInterestRateModel(), "marker method returned false");
2531 
2532         // Set the interest rate model to newInterestRateModel
2533         interestRateModel = newInterestRateModel;
2534 
2535         // Emit NewMarketTokenInterestRateModel(oldInterestRateModel, newInterestRateModel)
2536         emit NewMarketTokenInterestRateModel(oldInterestRateModel, newInterestRateModel);
2537 
2538         return uint(Error.NO_ERROR);
2539     }
2540 
2541     /*** Safe Token ***/
2542 
2543     /**
2544      * @notice Gets balance of this contract in terms of the underlying
2545      * @dev This excludes the value of the current message, if any
2546      * @return The quantity of underlying owned by this contract
2547      */
2548     function getCashPrior() internal view returns (uint);
2549 
2550     /**
2551      * @dev Performs a transfer in, reverting upon failure. Returns the amount actually transferred to the protocol, in case of a fee.
2552      *  This may revert due to insufficient balance or insufficient allowance.
2553      */
2554     function doTransferIn(address from, uint amount) internal returns (uint);
2555 
2556     /**
2557      * @dev Performs a transfer out, ideally returning an explanatory error code upon failure tather than reverting.
2558      *  If caller has not called checked protocol's balance, may revert due to insufficient cash held in the contract.
2559      *  If caller has checked protocol's balance, and verified it is >= amount, this should not revert in normal conditions.
2560      */
2561     function doTransferOut(address payable to, uint amount) internal;
2562 
2563 
2564     /*** Reentrancy Guard ***/
2565 
2566     /**
2567      * @dev Prevents a contract from calling itself, directly or indirectly.
2568      */
2569     modifier nonReentrant() {
2570         require(_notEntered, "re-entered");
2571         _notEntered = false;
2572         _;
2573         _notEntered = true; // get a gas-refund post-Istanbul
2574     }
2575 }
2576 
2577 contract PriceOracle {
2578     /// @notice Indicator that this is a PriceOracle contract (for inspection)
2579     bool public constant isPriceOracle = true;
2580 
2581     /**
2582       * @notice Get the underlying price of a bToken asset
2583       * @param bToken The bToken to get the underlying price of
2584       * @return The underlying asset price mantissa (scaled by 1e18).
2585       *  Zero means the price is unavailable.
2586       */
2587     function getUnderlyingPrice(BToken bToken) external view returns (uint);
2588 }
2589 
2590 /**
2591  * @title Bird's BErc20 Contract
2592  * @notice BTokens which wrap an EIP-20 underlying
2593  */
2594 contract BErc20 is BToken, BErc20Interface {
2595     /**
2596      * @notice Initialize the new money market
2597      * @param underlying_ The address of the underlying asset
2598      * @param bController_ The address of the BController
2599      * @param interestRateModel_ The address of the interest rate model
2600      * @param initialExchangeRateMantissa_ The initial exchange rate, scaled by 1e18
2601      * @param name_ ERC-20 name of this token
2602      * @param symbol_ ERC-20 symbol of this token
2603      * @param decimals_ ERC-20 decimal precision of this token
2604      */
2605     function initialize(address underlying_,
2606                         BControllerInterface bController_,
2607                         InterestRateModel interestRateModel_,
2608                         uint initialExchangeRateMantissa_,
2609                         string memory name_,
2610                         string memory symbol_,
2611                         uint8 decimals_) public {
2612         // BToken initialize does the bulk of the work
2613         super.initialize(bController_, interestRateModel_, initialExchangeRateMantissa_, name_, symbol_, decimals_);
2614 
2615         // Set underlying and sanity check it
2616         underlying = underlying_;
2617         EIP20Interface(underlying).totalSupply();
2618     }
2619 
2620     /*** User Interface ***/
2621 
2622     /**
2623      * @notice Sender supplies assets into the market and receives bTokens in exchange
2624      * @dev Accrues interest whether or not the operation succeeds, unless reverted
2625      * @param mintAmount The amount of the underlying asset to supply
2626      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
2627      */
2628     function mint(uint mintAmount) external returns (uint) {
2629         (uint err,) = mintInternal(mintAmount);
2630         return err;
2631     }
2632 
2633     /**
2634      * @notice Sender redeems bTokens in exchange for the underlying asset
2635      * @dev Accrues interest whether or not the operation succeeds, unless reverted
2636      * @param redeemTokens The number of bTokens to redeem into underlying
2637      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
2638      */
2639     function redeem(uint redeemTokens) external returns (uint) {
2640         return redeemInternal(redeemTokens);
2641     }
2642 
2643     /**
2644      * @notice Sender redeems bTokens in exchange for a specified amount of underlying asset
2645      * @dev Accrues interest whether or not the operation succeeds, unless reverted
2646      * @param redeemAmount The amount of underlying to redeem
2647      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
2648      */
2649     function redeemUnderlying(uint redeemAmount) external returns (uint) {
2650         return redeemUnderlyingInternal(redeemAmount);
2651     }
2652 
2653     /**
2654       * @notice Sender borrows assets from the protocol to their own address
2655       * @param borrowAmount The amount of the underlying asset to borrow
2656       * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
2657       */
2658     function borrow(uint borrowAmount) external returns (uint) {
2659         return borrowInternal(borrowAmount);
2660     }
2661 
2662     /**
2663      * @notice Sender repays their own borrow
2664      * @param repayAmount The amount to repay
2665      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
2666      */
2667     function repayBorrow(uint repayAmount) external returns (uint) {
2668         (uint err,) = repayBorrowInternal(repayAmount);
2669         return err;
2670     }
2671 
2672     /**
2673      * @notice Sender repays a borrow belonging to borrower
2674      * @param borrower the account with the debt being payed off
2675      * @param repayAmount The amount to repay
2676      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
2677      */
2678     function repayBorrowBehalf(address borrower, uint repayAmount) external returns (uint) {
2679         (uint err,) = repayBorrowBehalfInternal(borrower, repayAmount);
2680         return err;
2681     }
2682 
2683     /**
2684      * @notice The sender liquidates the borrowers collateral.
2685      *  The collateral seized is transferred to the liquidator.
2686      * @param borrower The borrower of this bToken to be liquidated
2687      * @param repayAmount The amount of the underlying borrowed asset to repay
2688      * @param bTokenCollateral The market in which to seize collateral from the borrower
2689      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
2690      */
2691     function liquidateBorrow(address borrower, uint repayAmount, BTokenInterface bTokenCollateral) external returns (uint) {
2692         (uint err,) = liquidateBorrowInternal(borrower, repayAmount, bTokenCollateral);
2693         return err;
2694     }
2695 
2696     /**
2697      * @notice The sender adds to reserves.
2698      * @param addAmount The amount fo underlying token to add as reserves
2699      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
2700      */
2701     function _addReserves(uint addAmount) external returns (uint) {
2702         return _addReservesInternal(addAmount);
2703     }
2704 
2705     /*** Safe Token ***/
2706 
2707     /**
2708      * @notice Gets balance of this contract in terms of the underlying
2709      * @dev This excludes the value of the current message, if any
2710      * @return The quantity of underlying tokens owned by this contract
2711      */
2712     function getCashPrior() internal view returns (uint) {
2713         EIP20Interface token = EIP20Interface(underlying);
2714         return token.balanceOf(address(this));
2715     }
2716 
2717     /**
2718      * @dev Similar to EIP20 transfer, except it handles a False result from `transferFrom` and reverts in that case.
2719      *      This will revert due to insufficient balance or insufficient allowance.
2720      *      This function returns the actual amount received,
2721      *      which may be less than `amount` if there is a fee attached to the transfer.
2722      *
2723      *      Note: This wrapper safely handles non-standard ERC-20 tokens that do not return a value.
2724      *            See here: https://medium.com/coinmonks/missing-return-value-bug-at-least-130-tokens-affected-d67bf08521ca
2725      */
2726     function doTransferIn(address from, uint amount) internal returns (uint) {
2727         EIP20NonStandardInterface token = EIP20NonStandardInterface(underlying);
2728         uint balanceBefore = EIP20Interface(underlying).balanceOf(address(this));
2729         token.transferFrom(from, address(this), amount);
2730 
2731         bool success;
2732         assembly {
2733             switch returndatasize()
2734                 case 0 {                       // This is a non-standard ERC-20
2735                     success := not(0)          // set success to true
2736                 }
2737                 case 32 {                      // This is a compliant ERC-20
2738                     returndatacopy(0, 0, 32)
2739                     success := mload(0)        // Set `success = returndata` of external call
2740                 }
2741                 default {                      // This is an excessively non-compliant ERC-20, revert.
2742                     revert(0, 0)
2743                 }
2744         }
2745         require(success, "TOKEN_TRANSFER_IN_FAILED");
2746 
2747         // Calculate the amount that was *actually* transferred
2748         uint balanceAfter = EIP20Interface(underlying).balanceOf(address(this));
2749         require(balanceAfter >= balanceBefore, "TOKEN_TRANSFER_IN_OVERFLOW");
2750         return balanceAfter - balanceBefore;   // underflow already checked above, just subtract
2751     }
2752 
2753     /**
2754      * @dev Similar to EIP20 transfer, except it handles a False success from `transfer` and returns an explanatory
2755      *      error code rather than reverting. If caller has not called checked protocol's balance, this may revert due to
2756      *      insufficient cash held in this contract. If caller has checked protocol's balance prior to this call, and verified
2757      *      it is >= amount, this should not revert in normal conditions.
2758      *
2759      *      Note: This wrapper safely handles non-standard ERC-20 tokens that do not return a value.
2760      *            See here: https://medium.com/coinmonks/missing-return-value-bug-at-least-130-tokens-affected-d67bf08521ca
2761      */
2762     function doTransferOut(address payable to, uint amount) internal {
2763         EIP20NonStandardInterface token = EIP20NonStandardInterface(underlying);
2764         token.transfer(to, amount);
2765 
2766         bool success;
2767         assembly {
2768             switch returndatasize()
2769                 case 0 {                      // This is a non-standard ERC-20
2770                     success := not(0)          // set success to true
2771                 }
2772                 case 32 {                     // This is a complaint ERC-20
2773                     returndatacopy(0, 0, 32)
2774                     success := mload(0)        // Set `success = returndata` of external call
2775                 }
2776                 default {                     // This is an excessively non-compliant ERC-20, revert.
2777                     revert(0, 0)
2778                 }
2779         }
2780         require(success, "TOKEN_TRANSFER_OUT_FAILED");
2781     }
2782 }
2783 
2784 contract SimplePriceOracle is PriceOracle {
2785     address public admin;
2786     address public pendingAdmin;
2787     mapping(string => address) birdTokens;
2788     mapping(address => uint256) prices;
2789     event PricePosted(
2790         string symbol,
2791         address asset,
2792         uint256 previousPriceMantissa,
2793         uint256 requestedPriceMantissa,
2794         uint256 newPriceMantissa
2795     );
2796 
2797     constructor() public {
2798         admin = msg.sender;
2799     }
2800 
2801     function initialiseTokens(string[] memory symbols, address[] memory bTokens)
2802         public
2803     {
2804         // Check caller = admin
2805         require(msg.sender == admin);
2806         require(symbols.length == bTokens.length);
2807 
2808         // Associate symbols with tokens
2809         for (uint256 i = 0; i < symbols.length; i++) {
2810             birdTokens[symbols[i]] = bTokens[i];
2811         }
2812     }
2813 
2814     function postPrices(string[] memory symbols, uint256[] memory priceMantissa)
2815         public
2816     {
2817         // Check caller = admin
2818         require(msg.sender == admin);
2819         require(symbols.length == priceMantissa.length);
2820 
2821         // Post prices
2822         for (uint256 i = 0; i < symbols.length; i++) {
2823             if (compareStrings(symbols[i], "ETH")) {
2824                 setDirectPrice(
2825                     address(birdTokens[symbols[i]]),
2826                     priceMantissa[i]
2827                 );
2828             } else {
2829                 setUnderlyingPrice(
2830                     BToken(birdTokens[symbols[i]]),
2831                     priceMantissa[i]
2832                 );
2833             }
2834         }
2835     }
2836 
2837     function getUnderlyingPrice(BToken bToken) public view returns (uint256) {
2838         if (compareStrings(bToken.symbol(), "bETH")) {
2839             return prices[address(bToken)];
2840         } else {
2841             return prices[address(BErc20(address(bToken)).underlying())];
2842         }
2843     }
2844 
2845     function setUnderlyingPrice(BToken bToken, uint256 underlyingPriceMantissa)
2846         public
2847     {
2848         // Check caller = admin
2849         require(msg.sender == admin);
2850 
2851         address asset = address(BErc20(address(bToken)).underlying());
2852 
2853         emit PricePosted(
2854             bToken.symbol(),
2855             address(bToken),
2856             prices[asset],
2857             underlyingPriceMantissa,
2858             underlyingPriceMantissa
2859         );
2860         prices[asset] = underlyingPriceMantissa;
2861     }
2862 
2863     function setDirectPrice(address asset, uint256 price) public {
2864         // Check caller = admin
2865         require(msg.sender == admin);
2866 
2867         emit PricePosted("bETH", asset, prices[asset], price, price);
2868         prices[asset] = price;
2869     }
2870 
2871     // v1 price oracle interface for use as backing of proxy
2872     function assetPrices(address asset) external view returns (uint256) {
2873         return prices[asset];
2874     }
2875 
2876     function compareStrings(string memory a, string memory b)
2877         internal
2878         pure
2879         returns (bool)
2880     {
2881         return (keccak256(abi.encodePacked((a))) ==
2882             keccak256(abi.encodePacked((b))));
2883     }
2884 
2885     function _setPendingAdmin(address newPendingAdmin) public {
2886         // Check caller = admin
2887         require(msg.sender == admin);
2888 
2889         // Store pendingAdmin with value newPendingAdmin
2890         pendingAdmin = newPendingAdmin;
2891     }
2892 
2893     function _acceptAdmin() public {
2894         // Check caller is pendingAdmin and pendingAdmin ≠ address(0)
2895         require(msg.sender == pendingAdmin && msg.sender != address(0));
2896 
2897         // Store admin with value pendingAdmin
2898         admin = pendingAdmin;
2899 
2900         // Clear the pending value
2901         pendingAdmin = address(0);
2902     }
2903 }