1 // File: contracts/ComptrollerInterface.sol
2 
3 pragma solidity ^0.5.12;
4 
5 interface ComptrollerInterface {
6     /**
7      * @notice Marker function used for light validation when updating the comptroller of a market
8      * @dev Implementations should simply return true.
9      * @return true
10      */
11     function isComptroller() external view returns (bool);
12 
13     /*** Assets You Are In ***/
14 
15     function enterMarkets(address[] calldata cTokens) external returns (uint[] memory);
16     function exitMarket(address cToken) external returns (uint);
17 
18     /*** Policy Hooks ***/
19 
20     function mintAllowed(address cToken, address minter, uint mintAmount) external returns (uint);
21     function mintVerify(address cToken, address minter, uint mintAmount, uint mintTokens) external;
22 
23     function redeemAllowed(address cToken, address redeemer, uint redeemTokens) external returns (uint);
24     function redeemVerify(address cToken, address redeemer, uint redeemAmount, uint redeemTokens) external;
25 
26     function borrowAllowed(address cToken, address borrower, uint borrowAmount) external returns (uint);
27     function borrowVerify(address cToken, address borrower, uint borrowAmount) external;
28 
29     function repayBorrowAllowed(
30         address cToken,
31         address payer,
32         address borrower,
33         uint repayAmount) external returns (uint);
34     function repayBorrowVerify(
35         address cToken,
36         address payer,
37         address borrower,
38         uint repayAmount,
39         uint borrowerIndex) external;
40 
41     function liquidateBorrowAllowed(
42         address cTokenBorrowed,
43         address cTokenCollateral,
44         address liquidator,
45         address borrower,
46         uint repayAmount) external returns (uint);
47     function liquidateBorrowVerify(
48         address cTokenBorrowed,
49         address cTokenCollateral,
50         address liquidator,
51         address borrower,
52         uint repayAmount,
53         uint seizeTokens) external;
54 
55     function seizeAllowed(
56         address cTokenCollateral,
57         address cTokenBorrowed,
58         address liquidator,
59         address borrower,
60         uint seizeTokens) external returns (uint);
61     function seizeVerify(
62         address cTokenCollateral,
63         address cTokenBorrowed,
64         address liquidator,
65         address borrower,
66         uint seizeTokens) external;
67 
68     function transferAllowed(address cToken, address src, address dst, uint transferTokens) external returns (uint);
69     function transferVerify(address cToken, address src, address dst, uint transferTokens) external;
70 
71     /*** Liquidity/Liquidation Calculations ***/
72 
73     function liquidateCalculateSeizeTokens(
74         address cTokenBorrowed,
75         address cTokenCollateral,
76         uint repayAmount) external view returns (uint, uint);
77 }
78 
79 // File: contracts/InterestRateModel.sol
80 
81 pragma solidity ^0.5.12;
82 
83 /**
84   * @title Compound's InterestRateModel Interface
85   * @author Compound
86   */
87 interface InterestRateModel {
88     /**
89      * @notice Indicator that this is an InterestRateModel contract (for inspection)
90      */
91     function isInterestRateModel() external pure returns (bool);
92 
93     /**
94       * @notice Calculates the current borrow interest rate per block
95       * @param cash The total amount of cash the market has
96       * @param borrows The total amount of borrows the market has outstanding
97       * @param reserves The total amnount of reserves the market has
98       * @return The borrow rate per block (as a percentage, and scaled by 1e18)
99       */
100     function getBorrowRate(uint cash, uint borrows, uint reserves) external view returns (uint);
101 
102     /**
103       * @notice Calculates the current supply interest rate per block
104       * @param cash The total amount of cash the market has
105       * @param borrows The total amount of borrows the market has outstanding
106       * @param reserves The total amnount of reserves the market has
107       * @param reserveFactorMantissa The current reserve factor the market has
108       * @return The supply rate per block (as a percentage, and scaled by 1e18)
109       */
110     function getSupplyRate(uint cash, uint borrows, uint reserves, uint reserveFactorMantissa) external view returns (uint);
111 
112 }
113 
114 // File: contracts/CTokenInterfaces.sol
115 
116 pragma solidity ^0.5.12;
117 
118 
119 
120 contract CTokenStorage {
121     /**
122      * @dev Guard variable for re-entrancy checks
123      */
124     bool internal _notEntered;
125 
126     /**
127      * @notice EIP-20 token name for this token
128      */
129     string public name;
130 
131     /**
132      * @notice EIP-20 token symbol for this token
133      */
134     string public symbol;
135 
136     /**
137      * @notice EIP-20 token decimals for this token
138      */
139     uint8 public decimals;
140 
141     /**
142      * @notice Maximum borrow rate that can ever be applied (.0005% / block)
143      */
144 
145     uint internal constant borrowRateMaxMantissa = 0.0005e16;
146 
147     /**
148      * @notice Maximum fraction of interest that can be set aside for reserves
149      */
150     uint internal constant reserveFactorMaxMantissa = 1e18;
151 
152     /**
153      * @notice Administrator for this contract
154      */
155     address payable public admin;
156 
157     /**
158      * @notice Pending administrator for this contract
159      */
160     address payable public pendingAdmin;
161 
162     /**
163      * @notice Contract which oversees inter-cToken operations
164      */
165     ComptrollerInterface public comptroller;
166 
167     /**
168      * @notice Model which tells what the current interest rate should be
169      */
170     InterestRateModel public interestRateModel;
171 
172     /**
173      * @notice Initial exchange rate used when minting the first CTokens (used when totalSupply = 0)
174      */
175     uint internal initialExchangeRateMantissa;
176 
177     /**
178      * @notice Fraction of interest currently set aside for reserves
179      */
180     uint public reserveFactorMantissa;
181 
182     /**
183      * @notice Block number that interest was last accrued at
184      */
185     uint public accrualBlockNumber;
186 
187     /**
188      * @notice Accumulator of the total earned interest rate since the opening of the market
189      */
190     uint public borrowIndex;
191 
192     /**
193      * @notice Total amount of outstanding borrows of the underlying in this market
194      */
195     uint public totalBorrows;
196 
197     /**
198      * @notice Total amount of reserves of the underlying held in this market
199      */
200     uint public totalReserves;
201 
202     /**
203      * @notice Total number of tokens in circulation
204      */
205     uint public totalSupply;
206 
207     /**
208      * @notice Official record of token balances for each account
209      */
210     mapping (address => uint) internal accountTokens;
211 
212     /**
213      * @notice Approved token transfer amounts on behalf of others
214      */
215     mapping (address => mapping (address => uint)) internal transferAllowances;
216 
217     /**
218      * @notice Container for borrow balance information
219      * @member principal Total balance (with accrued interest), after applying the most recent balance-changing action
220      * @member interestIndex Global borrowIndex as of the most recent balance-changing action
221      */
222     struct BorrowSnapshot {
223         uint principal;
224         uint interestIndex;
225     }
226 
227     /**
228      * @notice Mapping of account addresses to outstanding borrow balances
229      */
230     mapping(address => BorrowSnapshot) internal accountBorrows;
231 }
232 
233 contract CTokenInterface is CTokenStorage {
234     /**
235      * @notice Indicator that this is a CToken contract (for inspection)
236      */
237     bool public constant isCToken = true;
238 
239 
240     /*** Market Events ***/
241 
242     /**
243      * @notice Event emitted when interest is accrued
244      */
245     event AccrueInterest(uint cashPrior, uint interestAccumulated, uint borrowIndex, uint totalBorrows);
246 
247     /**
248      * @notice Event emitted when tokens are minted
249      */
250     event Mint(address minter, uint mintAmount, uint mintTokens);
251 
252     /**
253      * @notice Event emitted when tokens are redeemed
254      */
255     event Redeem(address redeemer, uint redeemAmount, uint redeemTokens);
256 
257     /**
258      * @notice Event emitted when underlying is borrowed
259      */
260     event Borrow(address borrower, uint borrowAmount, uint accountBorrows, uint totalBorrows);
261 
262     /**
263      * @notice Event emitted when a borrow is repaid
264      */
265     event RepayBorrow(address payer, address borrower, uint repayAmount, uint accountBorrows, uint totalBorrows);
266 
267     /**
268      * @notice Event emitted when a borrow is liquidated
269      */
270     event LiquidateBorrow(address liquidator, address borrower, uint repayAmount, address cTokenCollateral, uint seizeTokens);
271 
272 
273     /*** Admin Events ***/
274 
275     /**
276      * @notice Event emitted when pendingAdmin is changed
277      */
278     event NewPendingAdmin(address oldPendingAdmin, address newPendingAdmin);
279 
280     /**
281      * @notice Event emitted when pendingAdmin is accepted, which means admin is updated
282      */
283     event NewAdmin(address oldAdmin, address newAdmin);
284 
285     /**
286      * @notice Event emitted when comptroller is changed
287      */
288     event NewComptroller(ComptrollerInterface oldComptroller, ComptrollerInterface newComptroller);
289 
290     /**
291      * @notice Event emitted when interestRateModel is changed
292      */
293     event NewMarketInterestRateModel(InterestRateModel oldInterestRateModel, InterestRateModel newInterestRateModel);
294 
295     /**
296      * @notice Event emitted when the reserve factor is changed
297      */
298     event NewReserveFactor(uint oldReserveFactorMantissa, uint newReserveFactorMantissa);
299 
300     /**
301      * @notice Event emitted when the reserves are added
302      */
303     event ReservesAdded(address benefactor, uint addAmount, uint newTotalReserves);
304 
305     /**
306      * @notice Event emitted when the reserves are reduced
307      */
308     event ReservesReduced(address admin, uint reduceAmount, uint newTotalReserves);
309 
310     /**
311      * @notice EIP20 Transfer event
312      */
313     event Transfer(address indexed from, address indexed to, uint amount);
314 
315     /**
316      * @notice EIP20 Approval event
317      */
318     event Approval(address indexed owner, address indexed spender, uint amount);
319 
320     /**
321      * @notice Failure event
322      */
323     event Failure(uint error, uint info, uint detail);
324 
325 
326     /*** User Interface ***/
327 
328     function transfer(address dst, uint amount) external returns (bool);
329     function transferFrom(address src, address dst, uint amount) external returns (bool);
330     function approve(address spender, uint amount) external returns (bool);
331     function allowance(address owner, address spender) external view returns (uint);
332     function balanceOf(address owner) external view returns (uint);
333     function balanceOfUnderlying(address owner) external returns (uint);
334     function getAccountSnapshot(address account) external view returns (uint, uint, uint, uint);
335     function borrowRatePerBlock() external view returns (uint);
336     function supplyRatePerBlock() external view returns (uint);
337     function totalBorrowsCurrent() external returns (uint);
338     function borrowBalanceCurrent(address account) external returns (uint);
339     function borrowBalanceStored(address account) public view returns (uint);
340     function exchangeRateCurrent() public returns (uint);
341     function exchangeRateStored() public view returns (uint);
342     function getCash() external view returns (uint);
343     function accrueInterest() public returns (uint);
344     function seize(address liquidator, address borrower, uint seizeTokens) external returns (uint);
345 
346 
347     /*** Admin Functions ***/
348 
349     function _setPendingAdmin(address payable newPendingAdmin) external returns (uint);
350     function _acceptAdmin() external returns (uint);
351     function _setComptroller(ComptrollerInterface newComptroller) public returns (uint);
352     function _setReserveFactor(uint newReserveFactorMantissa) external returns (uint);
353     function _reduceReserves(uint reduceAmount) external returns (uint);
354     function _setInterestRateModel(InterestRateModel newInterestRateModel) public returns (uint);
355 }
356 
357 contract CErc20Storage {
358     /**
359      * @notice Underlying asset for this CToken
360      */
361     address public underlying;
362 }
363 
364 contract CErc20Interface is CErc20Storage {
365 
366     /*** User Interface ***/
367 
368     function mint(uint mintAmount) external returns (uint);
369     function redeem(uint redeemTokens) external returns (uint);
370     function redeemUnderlying(uint redeemAmount) external returns (uint);
371     function borrow(uint borrowAmount) external returns (uint);
372     function repayBorrow(uint repayAmount) external returns (uint);
373     function repayBorrowBehalf(address borrower, uint repayAmount) external returns (uint);
374     function liquidateBorrow(address borrower, uint repayAmount, CTokenInterface cTokenCollateral) external returns (uint);
375 
376 
377     /*** Admin Functions ***/
378 
379     function _addReserves(uint addAmount) external returns (uint);
380 }
381 
382 contract CDelegationStorage {
383     /**
384      * @notice Implementation address for this contract
385      */
386     address public implementation;
387 }
388 
389 contract CDelegatorInterface is CDelegationStorage {
390     /**
391      * @notice Emitted when implementation is changed
392      */
393     event NewImplementation(address oldImplementation, address newImplementation);
394 
395     /**
396      * @notice Called by the admin to update the implementation of the delegator
397      * @param implementation_ The address of the new implementation for delegation
398      * @param allowResign Flag to indicate whether to call _resignImplementation on the old implementation
399      * @param becomeImplementationData The encoded bytes data to be passed to _becomeImplementation
400      */
401     function _setImplementation(address implementation_, bool allowResign, bytes memory becomeImplementationData) public;
402 }
403 
404 contract CDelegateInterface is CDelegationStorage {
405     /**
406      * @notice Called by the delegator on a delegate to initialize it for duty
407      * @dev Should revert if any issues arise which make it unfit for delegation
408      * @param data The encoded bytes data for any initialization
409      */
410     function _becomeImplementation(bytes memory data) public;
411 
412     /**
413      * @notice Called by the delegator on a delegate to forfeit its responsibility
414      */
415     function _resignImplementation() public;
416 }
417 
418 // File: contracts/ErrorReporter.sol
419 
420 pragma solidity ^0.5.12;
421 
422 contract ComptrollerErrorReporter {
423     enum Error {
424         NO_ERROR,
425         UNAUTHORIZED,
426         COMPTROLLER_MISMATCH,
427         INSUFFICIENT_SHORTFALL,
428         INSUFFICIENT_LIQUIDITY,
429         INVALID_CLOSE_FACTOR,
430         INVALID_COLLATERAL_FACTOR,
431         INVALID_LIQUIDATION_INCENTIVE,
432         MARKET_NOT_ENTERED, // no longer possible
433         MARKET_NOT_LISTED,
434         MARKET_ALREADY_LISTED,
435         MATH_ERROR,
436         NONZERO_BORROW_BALANCE,
437         PRICE_ERROR,
438         REJECTION,
439         SNAPSHOT_ERROR,
440         TOO_MANY_ASSETS,
441         TOO_MUCH_REPAY
442     }
443 
444     enum FailureInfo {
445         ACCEPT_ADMIN_PENDING_ADMIN_CHECK,
446         ACCEPT_PENDING_IMPLEMENTATION_ADDRESS_CHECK,
447         EXIT_MARKET_BALANCE_OWED,
448         EXIT_MARKET_REJECTION,
449         SET_CLOSE_FACTOR_OWNER_CHECK,
450         SET_CLOSE_FACTOR_VALIDATION,
451         SET_COLLATERAL_FACTOR_OWNER_CHECK,
452         SET_COLLATERAL_FACTOR_NO_EXISTS,
453         SET_COLLATERAL_FACTOR_VALIDATION,
454         SET_COLLATERAL_FACTOR_WITHOUT_PRICE,
455         SET_IMPLEMENTATION_OWNER_CHECK,
456         SET_LIQUIDATION_INCENTIVE_OWNER_CHECK,
457         SET_LIQUIDATION_INCENTIVE_VALIDATION,
458         SET_MAX_ASSETS_OWNER_CHECK,
459         SET_PENDING_ADMIN_OWNER_CHECK,
460         SET_PENDING_IMPLEMENTATION_OWNER_CHECK,
461         SET_PRICE_ORACLE_OWNER_CHECK,
462         SUPPORT_MARKET_EXISTS,
463         SUPPORT_MARKET_OWNER_CHECK,
464         SET_PAUSE_GUARDIAN_OWNER_CHECK
465     }
466 
467     /**
468       * @dev `error` corresponds to enum Error; `info` corresponds to enum FailureInfo, and `detail` is an arbitrary
469       * contract-specific code that enables us to report opaque error codes from upgradeable contracts.
470       **/
471     event Failure(uint error, uint info, uint detail);
472 
473     /**
474       * @dev use this when reporting a known error from the money market or a non-upgradeable collaborator
475       */
476     function fail(Error err, FailureInfo info) internal returns (uint) {
477         emit Failure(uint(err), uint(info), 0);
478 
479         return uint(err);
480     }
481 
482     /**
483       * @dev use this when reporting an opaque error from an upgradeable collaborator contract
484       */
485     function failOpaque(Error err, FailureInfo info, uint opaqueError) internal returns (uint) {
486         emit Failure(uint(err), uint(info), opaqueError);
487 
488         return uint(err);
489     }
490 }
491 
492 contract TokenErrorReporter {
493     enum Error {
494         NO_ERROR,
495         UNAUTHORIZED,
496         BAD_INPUT,
497         COMPTROLLER_REJECTION,
498         COMPTROLLER_CALCULATION_ERROR,
499         INTEREST_RATE_MODEL_ERROR,
500         INVALID_ACCOUNT_PAIR,
501         INVALID_CLOSE_AMOUNT_REQUESTED,
502         INVALID_COLLATERAL_FACTOR,
503         MATH_ERROR,
504         MARKET_NOT_FRESH,
505         MARKET_NOT_LISTED,
506         TOKEN_INSUFFICIENT_ALLOWANCE,
507         TOKEN_INSUFFICIENT_BALANCE,
508         TOKEN_INSUFFICIENT_CASH,
509         TOKEN_TRANSFER_IN_FAILED,
510         TOKEN_TRANSFER_OUT_FAILED
511     }
512 
513     /*
514      * Note: FailureInfo (but not Error) is kept in alphabetical order
515      *       This is because FailureInfo grows significantly faster, and
516      *       the order of Error has some meaning, while the order of FailureInfo
517      *       is entirely arbitrary.
518      */
519     enum FailureInfo {
520         ACCEPT_ADMIN_PENDING_ADMIN_CHECK,
521         ACCRUE_INTEREST_ACCUMULATED_INTEREST_CALCULATION_FAILED,
522         ACCRUE_INTEREST_BORROW_RATE_CALCULATION_FAILED,
523         ACCRUE_INTEREST_NEW_BORROW_INDEX_CALCULATION_FAILED,
524         ACCRUE_INTEREST_NEW_TOTAL_BORROWS_CALCULATION_FAILED,
525         ACCRUE_INTEREST_NEW_TOTAL_RESERVES_CALCULATION_FAILED,
526         ACCRUE_INTEREST_SIMPLE_INTEREST_FACTOR_CALCULATION_FAILED,
527         BORROW_ACCUMULATED_BALANCE_CALCULATION_FAILED,
528         BORROW_ACCRUE_INTEREST_FAILED,
529         BORROW_CASH_NOT_AVAILABLE,
530         BORROW_FRESHNESS_CHECK,
531         BORROW_NEW_TOTAL_BALANCE_CALCULATION_FAILED,
532         BORROW_NEW_ACCOUNT_BORROW_BALANCE_CALCULATION_FAILED,
533         BORROW_MARKET_NOT_LISTED,
534         BORROW_COMPTROLLER_REJECTION,
535         LIQUIDATE_ACCRUE_BORROW_INTEREST_FAILED,
536         LIQUIDATE_ACCRUE_COLLATERAL_INTEREST_FAILED,
537         LIQUIDATE_COLLATERAL_FRESHNESS_CHECK,
538         LIQUIDATE_COMPTROLLER_REJECTION,
539         LIQUIDATE_COMPTROLLER_CALCULATE_AMOUNT_SEIZE_FAILED,
540         LIQUIDATE_CLOSE_AMOUNT_IS_UINT_MAX,
541         LIQUIDATE_CLOSE_AMOUNT_IS_ZERO,
542         LIQUIDATE_FRESHNESS_CHECK,
543         LIQUIDATE_LIQUIDATOR_IS_BORROWER,
544         LIQUIDATE_REPAY_BORROW_FRESH_FAILED,
545         LIQUIDATE_SEIZE_BALANCE_INCREMENT_FAILED,
546         LIQUIDATE_SEIZE_BALANCE_DECREMENT_FAILED,
547         LIQUIDATE_SEIZE_COMPTROLLER_REJECTION,
548         LIQUIDATE_SEIZE_LIQUIDATOR_IS_BORROWER,
549         LIQUIDATE_SEIZE_TOO_MUCH,
550         MINT_ACCRUE_INTEREST_FAILED,
551         MINT_COMPTROLLER_REJECTION,
552         MINT_EXCHANGE_CALCULATION_FAILED,
553         MINT_EXCHANGE_RATE_READ_FAILED,
554         MINT_FRESHNESS_CHECK,
555         MINT_NEW_ACCOUNT_BALANCE_CALCULATION_FAILED,
556         MINT_NEW_TOTAL_SUPPLY_CALCULATION_FAILED,
557         MINT_TRANSFER_IN_FAILED,
558         MINT_TRANSFER_IN_NOT_POSSIBLE,
559         REDEEM_ACCRUE_INTEREST_FAILED,
560         REDEEM_COMPTROLLER_REJECTION,
561         REDEEM_EXCHANGE_TOKENS_CALCULATION_FAILED,
562         REDEEM_EXCHANGE_AMOUNT_CALCULATION_FAILED,
563         REDEEM_EXCHANGE_RATE_READ_FAILED,
564         REDEEM_FRESHNESS_CHECK,
565         REDEEM_NEW_ACCOUNT_BALANCE_CALCULATION_FAILED,
566         REDEEM_NEW_TOTAL_SUPPLY_CALCULATION_FAILED,
567         REDEEM_TRANSFER_OUT_NOT_POSSIBLE,
568         REDUCE_RESERVES_ACCRUE_INTEREST_FAILED,
569         REDUCE_RESERVES_ADMIN_CHECK,
570         REDUCE_RESERVES_CASH_NOT_AVAILABLE,
571         REDUCE_RESERVES_FRESH_CHECK,
572         REDUCE_RESERVES_VALIDATION,
573         REPAY_BEHALF_ACCRUE_INTEREST_FAILED,
574         REPAY_BORROW_ACCRUE_INTEREST_FAILED,
575         REPAY_BORROW_ACCUMULATED_BALANCE_CALCULATION_FAILED,
576         REPAY_BORROW_COMPTROLLER_REJECTION,
577         REPAY_BORROW_FRESHNESS_CHECK,
578         REPAY_BORROW_NEW_ACCOUNT_BORROW_BALANCE_CALCULATION_FAILED,
579         REPAY_BORROW_NEW_TOTAL_BALANCE_CALCULATION_FAILED,
580         REPAY_BORROW_TRANSFER_IN_NOT_POSSIBLE,
581         SET_COLLATERAL_FACTOR_OWNER_CHECK,
582         SET_COLLATERAL_FACTOR_VALIDATION,
583         SET_COMPTROLLER_OWNER_CHECK,
584         SET_INTEREST_RATE_MODEL_ACCRUE_INTEREST_FAILED,
585         SET_INTEREST_RATE_MODEL_FRESH_CHECK,
586         SET_INTEREST_RATE_MODEL_OWNER_CHECK,
587         SET_MAX_ASSETS_OWNER_CHECK,
588         SET_ORACLE_MARKET_NOT_LISTED,
589         SET_PENDING_ADMIN_OWNER_CHECK,
590         SET_RESERVE_FACTOR_ACCRUE_INTEREST_FAILED,
591         SET_RESERVE_FACTOR_ADMIN_CHECK,
592         SET_RESERVE_FACTOR_FRESH_CHECK,
593         SET_RESERVE_FACTOR_BOUNDS_CHECK,
594         TRANSFER_COMPTROLLER_REJECTION,
595         TRANSFER_NOT_ALLOWED,
596         TRANSFER_NOT_ENOUGH,
597         TRANSFER_TOO_MUCH,
598         ADD_RESERVES_ACCRUE_INTEREST_FAILED,
599         ADD_RESERVES_FRESH_CHECK,
600         ADD_RESERVES_TRANSFER_IN_NOT_POSSIBLE
601     }
602 
603     /**
604       * @dev `error` corresponds to enum Error; `info` corresponds to enum FailureInfo, and `detail` is an arbitrary
605       * contract-specific code that enables us to report opaque error codes from upgradeable contracts.
606       **/
607     event Failure(uint error, uint info, uint detail);
608 
609     /**
610       * @dev use this when reporting a known error from the money market or a non-upgradeable collaborator
611       */
612     function fail(Error err, FailureInfo info) internal returns (uint) {
613         emit Failure(uint(err), uint(info), 0);
614 
615         return uint(err);
616     }
617 
618     /**
619       * @dev use this when reporting an opaque error from an upgradeable collaborator contract
620       */
621     function failOpaque(Error err, FailureInfo info, uint opaqueError) internal returns (uint) {
622         emit Failure(uint(err), uint(info), opaqueError);
623 
624         return uint(err);
625     }
626 }
627 
628 // File: contracts/CarefulMath.sol
629 
630 pragma solidity ^0.5.12;
631 
632 /**
633   * @title Careful Math
634   * @author Compound
635   * @notice Derived from OpenZeppelin's SafeMath library
636   *         https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/math/SafeMath.sol
637   */
638 contract CarefulMath {
639 
640     /**
641      * @dev Possible error codes that we can return
642      */
643     enum MathError {
644         NO_ERROR,
645         DIVISION_BY_ZERO,
646         INTEGER_OVERFLOW,
647         INTEGER_UNDERFLOW
648     }
649 
650     /**
651     * @dev Multiplies two numbers, returns an error on overflow.
652     */
653     function mulUInt(uint a, uint b) internal pure returns (MathError, uint) {
654         if (a == 0) {
655             return (MathError.NO_ERROR, 0);
656         }
657 
658         uint c = a * b;
659 
660         if (c / a != b) {
661             return (MathError.INTEGER_OVERFLOW, 0);
662         } else {
663             return (MathError.NO_ERROR, c);
664         }
665     }
666 
667     /**
668     * @dev Integer division of two numbers, truncating the quotient.
669     */
670     function divUInt(uint a, uint b) internal pure returns (MathError, uint) {
671         if (b == 0) {
672             return (MathError.DIVISION_BY_ZERO, 0);
673         }
674 
675         return (MathError.NO_ERROR, a / b);
676     }
677 
678     /**
679     * @dev Subtracts two numbers, returns an error on overflow (i.e. if subtrahend is greater than minuend).
680     */
681     function subUInt(uint a, uint b) internal pure returns (MathError, uint) {
682         if (b <= a) {
683             return (MathError.NO_ERROR, a - b);
684         } else {
685             return (MathError.INTEGER_UNDERFLOW, 0);
686         }
687     }
688 
689     /**
690     * @dev Adds two numbers, returns an error on overflow.
691     */
692     function addUInt(uint a, uint b) internal pure returns (MathError, uint) {
693         uint c = a + b;
694 
695         if (c >= a) {
696             return (MathError.NO_ERROR, c);
697         } else {
698             return (MathError.INTEGER_OVERFLOW, 0);
699         }
700     }
701 
702     /**
703     * @dev add a and b and then subtract c
704     */
705     function addThenSubUInt(uint a, uint b, uint c) internal pure returns (MathError, uint) {
706         (MathError err0, uint sum) = addUInt(a, b);
707 
708         if (err0 != MathError.NO_ERROR) {
709             return (err0, 0);
710         }
711 
712         return subUInt(sum, c);
713     }
714 }
715 
716 // File: contracts/Exponential.sol
717 
718 pragma solidity ^0.5.12;
719 
720 
721 /**
722  * @title Exponential module for storing fixed-precision decimals
723  * @author Compound
724  * @notice Exp is a struct which stores decimals with a fixed precision of 18 decimal places.
725  *         Thus, if we wanted to store the 5.1, mantissa would store 5.1e18. That is:
726  *         `Exp({mantissa: 5100000000000000000})`.
727  */
728 contract Exponential is CarefulMath {
729     uint constant expScale = 1e18;
730     uint constant halfExpScale = expScale/2;
731     uint constant mantissaOne = expScale;
732 
733     struct Exp {
734         uint mantissa;
735     }
736 
737     /**
738      * @dev Creates an exponential from numerator and denominator values.
739      *      Note: Returns an error if (`num` * 10e18) > MAX_INT,
740      *            or if `denom` is zero.
741      */
742     function getExp(uint num, uint denom) pure internal returns (MathError, Exp memory) {
743         (MathError err0, uint scaledNumerator) = mulUInt(num, expScale);
744         if (err0 != MathError.NO_ERROR) {
745             return (err0, Exp({mantissa: 0}));
746         }
747 
748         (MathError err1, uint rational) = divUInt(scaledNumerator, denom);
749         if (err1 != MathError.NO_ERROR) {
750             return (err1, Exp({mantissa: 0}));
751         }
752 
753         return (MathError.NO_ERROR, Exp({mantissa: rational}));
754     }
755 
756     /**
757      * @dev Adds two exponentials, returning a new exponential.
758      */
759     function addExp(Exp memory a, Exp memory b) pure internal returns (MathError, Exp memory) {
760         (MathError error, uint result) = addUInt(a.mantissa, b.mantissa);
761 
762         return (error, Exp({mantissa: result}));
763     }
764 
765     /**
766      * @dev Subtracts two exponentials, returning a new exponential.
767      */
768     function subExp(Exp memory a, Exp memory b) pure internal returns (MathError, Exp memory) {
769         (MathError error, uint result) = subUInt(a.mantissa, b.mantissa);
770 
771         return (error, Exp({mantissa: result}));
772     }
773 
774     /**
775      * @dev Multiply an Exp by a scalar, returning a new Exp.
776      */
777     function mulScalar(Exp memory a, uint scalar) pure internal returns (MathError, Exp memory) {
778         (MathError err0, uint scaledMantissa) = mulUInt(a.mantissa, scalar);
779         if (err0 != MathError.NO_ERROR) {
780             return (err0, Exp({mantissa: 0}));
781         }
782 
783         return (MathError.NO_ERROR, Exp({mantissa: scaledMantissa}));
784     }
785 
786     /**
787      * @dev Multiply an Exp by a scalar, then truncate to return an unsigned integer.
788      */
789     function mulScalarTruncate(Exp memory a, uint scalar) pure internal returns (MathError, uint) {
790         (MathError err, Exp memory product) = mulScalar(a, scalar);
791         if (err != MathError.NO_ERROR) {
792             return (err, 0);
793         }
794 
795         return (MathError.NO_ERROR, truncate(product));
796     }
797 
798     /**
799      * @dev Multiply an Exp by a scalar, truncate, then add an to an unsigned integer, returning an unsigned integer.
800      */
801     function mulScalarTruncateAddUInt(Exp memory a, uint scalar, uint addend) pure internal returns (MathError, uint) {
802         (MathError err, Exp memory product) = mulScalar(a, scalar);
803         if (err != MathError.NO_ERROR) {
804             return (err, 0);
805         }
806 
807         return addUInt(truncate(product), addend);
808     }
809 
810     /**
811      * @dev Divide an Exp by a scalar, returning a new Exp.
812      */
813     function divScalar(Exp memory a, uint scalar) pure internal returns (MathError, Exp memory) {
814         (MathError err0, uint descaledMantissa) = divUInt(a.mantissa, scalar);
815         if (err0 != MathError.NO_ERROR) {
816             return (err0, Exp({mantissa: 0}));
817         }
818 
819         return (MathError.NO_ERROR, Exp({mantissa: descaledMantissa}));
820     }
821 
822     /**
823      * @dev Divide a scalar by an Exp, returning a new Exp.
824      */
825     function divScalarByExp(uint scalar, Exp memory divisor) pure internal returns (MathError, Exp memory) {
826         /*
827           We are doing this as:
828           getExp(mulUInt(expScale, scalar), divisor.mantissa)
829 
830           How it works:
831           Exp = a / b;
832           Scalar = s;
833           `s / (a / b)` = `b * s / a` and since for an Exp `a = mantissa, b = expScale`
834         */
835         (MathError err0, uint numerator) = mulUInt(expScale, scalar);
836         if (err0 != MathError.NO_ERROR) {
837             return (err0, Exp({mantissa: 0}));
838         }
839         return getExp(numerator, divisor.mantissa);
840     }
841 
842     /**
843      * @dev Divide a scalar by an Exp, then truncate to return an unsigned integer.
844      */
845     function divScalarByExpTruncate(uint scalar, Exp memory divisor) pure internal returns (MathError, uint) {
846         (MathError err, Exp memory fraction) = divScalarByExp(scalar, divisor);
847         if (err != MathError.NO_ERROR) {
848             return (err, 0);
849         }
850 
851         return (MathError.NO_ERROR, truncate(fraction));
852     }
853 
854     /**
855      * @dev Multiplies two exponentials, returning a new exponential.
856      */
857     function mulExp(Exp memory a, Exp memory b) pure internal returns (MathError, Exp memory) {
858 
859         (MathError err0, uint doubleScaledProduct) = mulUInt(a.mantissa, b.mantissa);
860         if (err0 != MathError.NO_ERROR) {
861             return (err0, Exp({mantissa: 0}));
862         }
863 
864         // We add half the scale before dividing so that we get rounding instead of truncation.
865         //  See "Listing 6" and text above it at https://accu.org/index.php/journals/1717
866         // Without this change, a result like 6.6...e-19 will be truncated to 0 instead of being rounded to 1e-18.
867         (MathError err1, uint doubleScaledProductWithHalfScale) = addUInt(halfExpScale, doubleScaledProduct);
868         if (err1 != MathError.NO_ERROR) {
869             return (err1, Exp({mantissa: 0}));
870         }
871 
872         (MathError err2, uint product) = divUInt(doubleScaledProductWithHalfScale, expScale);
873         // The only error `div` can return is MathError.DIVISION_BY_ZERO but we control `expScale` and it is not zero.
874         assert(err2 == MathError.NO_ERROR);
875 
876         return (MathError.NO_ERROR, Exp({mantissa: product}));
877     }
878 
879     /**
880      * @dev Multiplies two exponentials given their mantissas, returning a new exponential.
881      */
882     function mulExp(uint a, uint b) pure internal returns (MathError, Exp memory) {
883         return mulExp(Exp({mantissa: a}), Exp({mantissa: b}));
884     }
885 
886     /**
887      * @dev Multiplies three exponentials, returning a new exponential.
888      */
889     function mulExp3(Exp memory a, Exp memory b, Exp memory c) pure internal returns (MathError, Exp memory) {
890         (MathError err, Exp memory ab) = mulExp(a, b);
891         if (err != MathError.NO_ERROR) {
892             return (err, ab);
893         }
894         return mulExp(ab, c);
895     }
896 
897     /**
898      * @dev Divides two exponentials, returning a new exponential.
899      *     (a/scale) / (b/scale) = (a/scale) * (scale/b) = a/b,
900      *  which we can scale as an Exp by calling getExp(a.mantissa, b.mantissa)
901      */
902     function divExp(Exp memory a, Exp memory b) pure internal returns (MathError, Exp memory) {
903         return getExp(a.mantissa, b.mantissa);
904     }
905 
906     /**
907      * @dev Truncates the given exp to a whole number value.
908      *      For example, truncate(Exp{mantissa: 15 * expScale}) = 15
909      */
910     function truncate(Exp memory exp) pure internal returns (uint) {
911         // Note: We are not using careful math here as we're performing a division that cannot fail
912         return exp.mantissa / expScale;
913     }
914 
915     /**
916      * @dev Checks if first Exp is less than second Exp.
917      */
918     function lessThanExp(Exp memory left, Exp memory right) pure internal returns (bool) {
919         return left.mantissa < right.mantissa;
920     }
921 
922     /**
923      * @dev Checks if left Exp <= right Exp.
924      */
925     function lessThanOrEqualExp(Exp memory left, Exp memory right) pure internal returns (bool) {
926         return left.mantissa <= right.mantissa;
927     }
928 
929     /**
930      * @dev Checks if left Exp > right Exp.
931      */
932     function greaterThanExp(Exp memory left, Exp memory right) pure internal returns (bool) {
933         return left.mantissa > right.mantissa;
934     }
935 
936     /**
937      * @dev returns true if Exp is exactly zero
938      */
939     function isZeroExp(Exp memory value) pure internal returns (bool) {
940         return value.mantissa == 0;
941     }
942 }
943 
944 // File: contracts/EIP20Interface.sol
945 
946 pragma solidity ^0.5.12;
947 
948 /**
949  * @title ERC 20 Token Standard Interface
950  *  https://eips.ethereum.org/EIPS/eip-20
951  */
952 interface EIP20Interface {
953 
954     /**
955       * @notice Get the total number of tokens in circulation
956       * @return The supply of tokens
957       */
958     function totalSupply() external view returns (uint256);
959 
960     /**
961      * @notice Gets the balance of the specified address
962      * @param owner The address from which the balance will be retrieved
963      * @return The balance
964      */
965     function balanceOf(address owner) external view returns (uint256 balance);
966 
967     /**
968       * @notice Transfer `amount` tokens from `msg.sender` to `dst`
969       * @param dst The address of the destination account
970       * @param amount The number of tokens to transfer
971       * @return Whether or not the transfer succeeded
972       */
973     function transfer(address dst, uint256 amount) external returns (bool success);
974 
975     /**
976       * @notice Transfer `amount` tokens from `src` to `dst`
977       * @param src The address of the source account
978       * @param dst The address of the destination account
979       * @param amount The number of tokens to transfer
980       * @return Whether or not the transfer succeeded
981       */
982     function transferFrom(address src, address dst, uint256 amount) external returns (bool success);
983 
984     /**
985       * @notice Approve `spender` to transfer up to `amount` from `src`
986       * @dev This will overwrite the approval amount for `spender`
987       *  and is subject to issues noted [here](https://eips.ethereum.org/EIPS/eip-20#approve)
988       * @param spender The address of the account which may transfer tokens
989       * @param amount The number of tokens that are approved (-1 means infinite)
990       * @return Whether or not the approval succeeded
991       */
992     function approve(address spender, uint256 amount) external returns (bool success);
993 
994     /**
995       * @notice Get the current allowance from `owner` for `spender`
996       * @param owner The address of the account which owns the tokens to be spent
997       * @param spender The address of the account which may transfer tokens
998       * @return The number of tokens allowed to be spent (-1 means infinite)
999       */
1000     function allowance(address owner, address spender) external view returns (uint256 remaining);
1001 
1002     event Transfer(address indexed from, address indexed to, uint256 amount);
1003     event Approval(address indexed owner, address indexed spender, uint256 amount);
1004 }
1005 
1006 // File: contracts/EIP20NonStandardInterface.sol
1007 
1008 pragma solidity ^0.5.12;
1009 
1010 /**
1011  * @title EIP20NonStandardInterface
1012  * @dev Version of ERC20 with no return values for `transfer` and `transferFrom`
1013  *  See https://medium.com/coinmonks/missing-return-value-bug-at-least-130-tokens-affected-d67bf08521ca
1014  */
1015 interface EIP20NonStandardInterface {
1016 
1017     /**
1018      * @notice Get the total number of tokens in circulation
1019      * @return The supply of tokens
1020      */
1021     function totalSupply() external view returns (uint256);
1022 
1023     /**
1024      * @notice Gets the balance of the specified address
1025      * @param owner The address from which the balance will be retrieved
1026      * @return The balance
1027      */
1028     function balanceOf(address owner) external view returns (uint256 balance);
1029 
1030     ///
1031     /// !!!!!!!!!!!!!!
1032     /// !!! NOTICE !!! `transfer` does not return a value, in violation of the ERC-20 specification
1033     /// !!!!!!!!!!!!!!
1034     ///
1035 
1036     /**
1037       * @notice Transfer `amount` tokens from `msg.sender` to `dst`
1038       * @param dst The address of the destination account
1039       * @param amount The number of tokens to transfer
1040       */
1041     function transfer(address dst, uint256 amount) external;
1042 
1043     ///
1044     /// !!!!!!!!!!!!!!
1045     /// !!! NOTICE !!! `transferFrom` does not return a value, in violation of the ERC-20 specification
1046     /// !!!!!!!!!!!!!!
1047     ///
1048 
1049     /**
1050       * @notice Transfer `amount` tokens from `src` to `dst`
1051       * @param src The address of the source account
1052       * @param dst The address of the destination account
1053       * @param amount The number of tokens to transfer
1054       */
1055     function transferFrom(address src, address dst, uint256 amount) external;
1056 
1057     /**
1058       * @notice Approve `spender` to transfer up to `amount` from `src`
1059       * @dev This will overwrite the approval amount for `spender`
1060       *  and is subject to issues noted [here](https://eips.ethereum.org/EIPS/eip-20#approve)
1061       * @param spender The address of the account which may transfer tokens
1062       * @param amount The number of tokens that are approved
1063       * @return Whether or not the approval succeeded
1064       */
1065     function approve(address spender, uint256 amount) external returns (bool success);
1066 
1067     /**
1068       * @notice Get the current allowance from `owner` for `spender`
1069       * @param owner The address of the account which owns the tokens to be spent
1070       * @param spender The address of the account which may transfer tokens
1071       * @return The number of tokens allowed to be spent
1072       */
1073     function allowance(address owner, address spender) external view returns (uint256 remaining);
1074 
1075     event Transfer(address indexed from, address indexed to, uint256 amount);
1076     event Approval(address indexed owner, address indexed spender, uint256 amount);
1077 }
1078 
1079 // File: contracts/CToken.sol
1080 
1081 pragma solidity ^0.5.12;
1082 
1083 
1084 
1085 
1086 
1087 
1088 
1089 
1090 /**
1091  * @title Compound's CToken Contract
1092  * @notice Abstract base for CTokens
1093  * @author Compound
1094  */
1095 contract CToken is CTokenInterface, Exponential, TokenErrorReporter {
1096     /**
1097      * @notice Initialize the money market
1098      * @param comptroller_ The address of the Comptroller
1099      * @param interestRateModel_ The address of the interest rate model
1100      * @param initialExchangeRateMantissa_ The initial exchange rate, scaled by 1e18
1101      * @param name_ EIP-20 name of this token
1102      * @param symbol_ EIP-20 symbol of this token
1103      * @param decimals_ EIP-20 decimal precision of this token
1104      */
1105     function initialize(ComptrollerInterface comptroller_,
1106                         InterestRateModel interestRateModel_,
1107                         uint initialExchangeRateMantissa_,
1108                         string memory name_,
1109                         string memory symbol_,
1110                         uint8 decimals_) public {
1111         require(msg.sender == admin, "only admin may initialize the market");
1112         require(accrualBlockNumber == 0 && borrowIndex == 0, "market may only be initialized once");
1113 
1114         // Set initial exchange rate
1115         initialExchangeRateMantissa = initialExchangeRateMantissa_;
1116         require(initialExchangeRateMantissa > 0, "initial exchange rate must be greater than zero.");
1117 
1118         // Set the comptroller
1119         uint err = _setComptroller(comptroller_);
1120         require(err == uint(Error.NO_ERROR), "setting comptroller failed");
1121 
1122         // Initialize block number and borrow index (block number mocks depend on comptroller being set)
1123         accrualBlockNumber = getBlockNumber();
1124         borrowIndex = mantissaOne;
1125 
1126         // Set the interest rate model (depends on block number / borrow index)
1127         err = _setInterestRateModelFresh(interestRateModel_);
1128         require(err == uint(Error.NO_ERROR), "setting interest rate model failed");
1129 
1130         name = name_;
1131         symbol = symbol_;
1132         decimals = decimals_;
1133 
1134         // The counter starts true to prevent changing it from zero to non-zero (i.e. smaller cost/refund)
1135         _notEntered = true;
1136     }
1137 
1138     /**
1139      * @notice Transfer `tokens` tokens from `src` to `dst` by `spender`
1140      * @dev Called by both `transfer` and `transferFrom` internally
1141      * @param spender The address of the account performing the transfer
1142      * @param src The address of the source account
1143      * @param dst The address of the destination account
1144      * @param tokens The number of tokens to transfer
1145      * @return Whether or not the transfer succeeded
1146      */
1147     function transferTokens(address spender, address src, address dst, uint tokens) internal returns (uint) {
1148         /* Fail if transfer not allowed */
1149         uint allowed = comptroller.transferAllowed(address(this), src, dst, tokens);
1150         if (allowed != 0) {
1151             return failOpaque(Error.COMPTROLLER_REJECTION, FailureInfo.TRANSFER_COMPTROLLER_REJECTION, allowed);
1152         }
1153 
1154         /* Do not allow self-transfers */
1155         if (src == dst) {
1156             return fail(Error.BAD_INPUT, FailureInfo.TRANSFER_NOT_ALLOWED);
1157         }
1158 
1159         /* Get the allowance, infinite for the account owner */
1160         uint startingAllowance = 0;
1161         if (spender == src) {
1162             startingAllowance = uint(-1);
1163         } else {
1164             startingAllowance = transferAllowances[src][spender];
1165         }
1166 
1167         /* Do the calculations, checking for {under,over}flow */
1168         MathError mathErr;
1169         uint allowanceNew;
1170         uint srcTokensNew;
1171         uint dstTokensNew;
1172 
1173         (mathErr, allowanceNew) = subUInt(startingAllowance, tokens);
1174         if (mathErr != MathError.NO_ERROR) {
1175             return fail(Error.MATH_ERROR, FailureInfo.TRANSFER_NOT_ALLOWED);
1176         }
1177 
1178         (mathErr, srcTokensNew) = subUInt(accountTokens[src], tokens);
1179         if (mathErr != MathError.NO_ERROR) {
1180             return fail(Error.MATH_ERROR, FailureInfo.TRANSFER_NOT_ENOUGH);
1181         }
1182 
1183         (mathErr, dstTokensNew) = addUInt(accountTokens[dst], tokens);
1184         if (mathErr != MathError.NO_ERROR) {
1185             return fail(Error.MATH_ERROR, FailureInfo.TRANSFER_TOO_MUCH);
1186         }
1187 
1188         /////////////////////////
1189         // EFFECTS & INTERACTIONS
1190         // (No safe failures beyond this point)
1191 
1192         accountTokens[src] = srcTokensNew;
1193         accountTokens[dst] = dstTokensNew;
1194 
1195         /* Eat some of the allowance (if necessary) */
1196         if (startingAllowance != uint(-1)) {
1197             transferAllowances[src][spender] = allowanceNew;
1198         }
1199 
1200         /* We emit a Transfer event */
1201         emit Transfer(src, dst, tokens);
1202 
1203         comptroller.transferVerify(address(this), src, dst, tokens);
1204 
1205         return uint(Error.NO_ERROR);
1206     }
1207 
1208     /**
1209      * @notice Transfer `amount` tokens from `msg.sender` to `dst`
1210      * @param dst The address of the destination account
1211      * @param amount The number of tokens to transfer
1212      * @return Whether or not the transfer succeeded
1213      */
1214     function transfer(address dst, uint256 amount) external nonReentrant returns (bool) {
1215         return transferTokens(msg.sender, msg.sender, dst, amount) == uint(Error.NO_ERROR);
1216     }
1217 
1218     /**
1219      * @notice Transfer `amount` tokens from `src` to `dst`
1220      * @param src The address of the source account
1221      * @param dst The address of the destination account
1222      * @param amount The number of tokens to transfer
1223      * @return Whether or not the transfer succeeded
1224      */
1225     function transferFrom(address src, address dst, uint256 amount) external nonReentrant returns (bool) {
1226         return transferTokens(msg.sender, src, dst, amount) == uint(Error.NO_ERROR);
1227     }
1228 
1229     /**
1230      * @notice Approve `spender` to transfer up to `amount` from `src`
1231      * @dev This will overwrite the approval amount for `spender`
1232      *  and is subject to issues noted [here](https://eips.ethereum.org/EIPS/eip-20#approve)
1233      * @param spender The address of the account which may transfer tokens
1234      * @param amount The number of tokens that are approved (-1 means infinite)
1235      * @return Whether or not the approval succeeded
1236      */
1237     function approve(address spender, uint256 amount) external returns (bool) {
1238         address src = msg.sender;
1239         transferAllowances[src][spender] = amount;
1240         emit Approval(src, spender, amount);
1241         return true;
1242     }
1243 
1244     /**
1245      * @notice Get the current allowance from `owner` for `spender`
1246      * @param owner The address of the account which owns the tokens to be spent
1247      * @param spender The address of the account which may transfer tokens
1248      * @return The number of tokens allowed to be spent (-1 means infinite)
1249      */
1250     function allowance(address owner, address spender) external view returns (uint256) {
1251         return transferAllowances[owner][spender];
1252     }
1253 
1254     /**
1255      * @notice Get the token balance of the `owner`
1256      * @param owner The address of the account to query
1257      * @return The number of tokens owned by `owner`
1258      */
1259     function balanceOf(address owner) external view returns (uint256) {
1260         return accountTokens[owner];
1261     }
1262 
1263     /**
1264      * @notice Get the underlying balance of the `owner`
1265      * @dev This also accrues interest in a transaction
1266      * @param owner The address of the account to query
1267      * @return The amount of underlying owned by `owner`
1268      */
1269     function balanceOfUnderlying(address owner) external returns (uint) {
1270         Exp memory exchangeRate = Exp({mantissa: exchangeRateCurrent()});
1271         (MathError mErr, uint balance) = mulScalarTruncate(exchangeRate, accountTokens[owner]);
1272         require(mErr == MathError.NO_ERROR, "balance could not be calculated");
1273         return balance;
1274     }
1275 
1276     /**
1277      * @notice Get a snapshot of the account's balances, and the cached exchange rate
1278      * @dev This is used by comptroller to more efficiently perform liquidity checks.
1279      * @param account Address of the account to snapshot
1280      * @return (possible error, token balance, borrow balance, exchange rate mantissa)
1281      */
1282     function getAccountSnapshot(address account) external view returns (uint, uint, uint, uint) {
1283         uint cTokenBalance = accountTokens[account];
1284         uint borrowBalance;
1285         uint exchangeRateMantissa;
1286 
1287         MathError mErr;
1288 
1289         (mErr, borrowBalance) = borrowBalanceStoredInternal(account);
1290         if (mErr != MathError.NO_ERROR) {
1291             return (uint(Error.MATH_ERROR), 0, 0, 0);
1292         }
1293 
1294         (mErr, exchangeRateMantissa) = exchangeRateStoredInternal();
1295         if (mErr != MathError.NO_ERROR) {
1296             return (uint(Error.MATH_ERROR), 0, 0, 0);
1297         }
1298 
1299         return (uint(Error.NO_ERROR), cTokenBalance, borrowBalance, exchangeRateMantissa);
1300     }
1301 
1302     /**
1303      * @dev Function to simply retrieve block number
1304      *  This exists mainly for inheriting test contracts to stub this result.
1305      */
1306     function getBlockNumber() internal view returns (uint) {
1307         return block.number;
1308     }
1309 
1310     /**
1311      * @notice Returns the current per-block borrow interest rate for this cToken
1312      * @return The borrow interest rate per block, scaled by 1e18
1313      */
1314     function borrowRatePerBlock() external view returns (uint) {
1315         return interestRateModel.getBorrowRate(getCashPrior(), totalBorrows, totalReserves);
1316     }
1317 
1318     /**
1319      * @notice Returns the current per-block supply interest rate for this cToken
1320      * @return The supply interest rate per block, scaled by 1e18
1321      */
1322     function supplyRatePerBlock() external view returns (uint) {
1323         return interestRateModel.getSupplyRate(getCashPrior(), totalBorrows, totalReserves, reserveFactorMantissa);
1324     }
1325 
1326     /**
1327      * @notice Returns the current total borrows plus accrued interest
1328      * @return The total borrows with interest
1329      */
1330     function totalBorrowsCurrent() external nonReentrant returns (uint) {
1331         require(accrueInterest() == uint(Error.NO_ERROR), "accrue interest failed");
1332         return totalBorrows;
1333     }
1334 
1335     /**
1336      * @notice Accrue interest to updated borrowIndex and then calculate account's borrow balance using the updated borrowIndex
1337      * @param account The address whose balance should be calculated after updating borrowIndex
1338      * @return The calculated balance
1339      */
1340     function borrowBalanceCurrent(address account) external nonReentrant returns (uint) {
1341         require(accrueInterest() == uint(Error.NO_ERROR), "accrue interest failed");
1342         return borrowBalanceStored(account);
1343     }
1344 
1345     /**
1346      * @notice Return the borrow balance of account based on stored data
1347      * @param account The address whose balance should be calculated
1348      * @return The calculated balance
1349      */
1350     function borrowBalanceStored(address account) public view returns (uint) {
1351         (MathError err, uint result) = borrowBalanceStoredInternal(account);
1352         require(err == MathError.NO_ERROR, "borrowBalanceStored: borrowBalanceStoredInternal failed");
1353         return result;
1354     }
1355 
1356     /**
1357      * @notice Return the borrow balance of account based on stored data
1358      * @param account The address whose balance should be calculated
1359      * @return (error code, the calculated balance or 0 if error code is non-zero)
1360      */
1361     function borrowBalanceStoredInternal(address account) internal view returns (MathError, uint) {
1362         /* Note: we do not assert that the market is up to date */
1363         MathError mathErr;
1364         uint principalTimesIndex;
1365         uint result;
1366 
1367         /* Get borrowBalance and borrowIndex */
1368         BorrowSnapshot storage borrowSnapshot = accountBorrows[account];
1369 
1370         /* If borrowBalance = 0 then borrowIndex is likely also 0.
1371          * Rather than failing the calculation with a division by 0, we immediately return 0 in this case.
1372          */
1373         if (borrowSnapshot.principal == 0) {
1374             return (MathError.NO_ERROR, 0);
1375         }
1376 
1377         /* Calculate new borrow balance using the interest index:
1378          *  recentBorrowBalance = borrower.borrowBalance * market.borrowIndex / borrower.borrowIndex
1379          */
1380         (mathErr, principalTimesIndex) = mulUInt(borrowSnapshot.principal, borrowIndex);
1381         if (mathErr != MathError.NO_ERROR) {
1382             return (mathErr, 0);
1383         }
1384 
1385         (mathErr, result) = divUInt(principalTimesIndex, borrowSnapshot.interestIndex);
1386         if (mathErr != MathError.NO_ERROR) {
1387             return (mathErr, 0);
1388         }
1389 
1390         return (MathError.NO_ERROR, result);
1391     }
1392 
1393     /**
1394      * @notice Accrue interest then return the up-to-date exchange rate
1395      * @return Calculated exchange rate scaled by 1e18
1396      */
1397     function exchangeRateCurrent() public nonReentrant returns (uint) {
1398         require(accrueInterest() == uint(Error.NO_ERROR), "accrue interest failed");
1399         return exchangeRateStored();
1400     }
1401 
1402     /**
1403      * @notice Calculates the exchange rate from the underlying to the CToken
1404      * @dev This function does not accrue interest before calculating the exchange rate
1405      * @return Calculated exchange rate scaled by 1e18
1406      */
1407     function exchangeRateStored() public view returns (uint) {
1408         (MathError err, uint result) = exchangeRateStoredInternal();
1409         require(err == MathError.NO_ERROR, "exchangeRateStored: exchangeRateStoredInternal failed");
1410         return result;
1411     }
1412 
1413     /**
1414      * @notice Calculates the exchange rate from the underlying to the CToken
1415      * @dev This function does not accrue interest before calculating the exchange rate
1416      * @return (error code, calculated exchange rate scaled by 1e18)
1417      */
1418     function exchangeRateStoredInternal() internal view returns (MathError, uint) {
1419         if (totalSupply == 0) {
1420             /*
1421              * If there are no tokens minted:
1422              *  exchangeRate = initialExchangeRate
1423              */
1424             return (MathError.NO_ERROR, initialExchangeRateMantissa);
1425         } else {
1426             /*
1427              * Otherwise:
1428              *  exchangeRate = (totalCash + totalBorrows - totalReserves) / totalSupply
1429              */
1430             uint totalCash = getCashPrior();
1431             uint cashPlusBorrowsMinusReserves;
1432             Exp memory exchangeRate;
1433             MathError mathErr;
1434 
1435             (mathErr, cashPlusBorrowsMinusReserves) = addThenSubUInt(totalCash, totalBorrows, totalReserves);
1436             if (mathErr != MathError.NO_ERROR) {
1437                 return (mathErr, 0);
1438             }
1439 
1440             (mathErr, exchangeRate) = getExp(cashPlusBorrowsMinusReserves, totalSupply);
1441             if (mathErr != MathError.NO_ERROR) {
1442                 return (mathErr, 0);
1443             }
1444 
1445             return (MathError.NO_ERROR, exchangeRate.mantissa);
1446         }
1447     }
1448 
1449     /**
1450      * @notice Get cash balance of this cToken in the underlying asset
1451      * @return The quantity of underlying asset owned by this contract
1452      */
1453     function getCash() external view returns (uint) {
1454         return getCashPrior();
1455     }
1456 
1457     struct AccrueInterestLocalVars {
1458         MathError mathErr;
1459         uint opaqueErr;
1460         uint borrowRateMantissa;
1461         uint currentBlockNumber;
1462         uint blockDelta;
1463 
1464         Exp simpleInterestFactor;
1465 
1466         uint interestAccumulated;
1467         uint totalBorrowsNew;
1468         uint totalReservesNew;
1469         uint borrowIndexNew;
1470     }
1471 
1472     /**
1473      * @notice Applies accrued interest to total borrows and reserves
1474      * @dev This calculates interest accrued from the last checkpointed block
1475      *   up to the current block and writes new checkpoint to storage.
1476      */
1477     function accrueInterest() public returns (uint) {
1478         AccrueInterestLocalVars memory vars;
1479         uint cashPrior = getCashPrior();
1480 
1481         /* Calculate the current borrow interest rate */
1482         vars.borrowRateMantissa = interestRateModel.getBorrowRate(cashPrior, totalBorrows, totalReserves);
1483         require(vars.borrowRateMantissa <= borrowRateMaxMantissa, "borrow rate is absurdly high");
1484 
1485         /* Remember the initial block number */
1486         vars.currentBlockNumber = getBlockNumber();
1487 
1488         /* Calculate the number of blocks elapsed since the last accrual */
1489         (vars.mathErr, vars.blockDelta) = subUInt(vars.currentBlockNumber, accrualBlockNumber);
1490         require(vars.mathErr == MathError.NO_ERROR, "could not calculate block delta");
1491 
1492         /*
1493          * Calculate the interest accumulated into borrows and reserves and the new index:
1494          *  simpleInterestFactor = borrowRate * blockDelta
1495          *  interestAccumulated = simpleInterestFactor * totalBorrows
1496          *  totalBorrowsNew = interestAccumulated + totalBorrows
1497          *  totalReservesNew = interestAccumulated * reserveFactor + totalReserves
1498          *  borrowIndexNew = simpleInterestFactor * borrowIndex + borrowIndex
1499          */
1500         (vars.mathErr, vars.simpleInterestFactor) = mulScalar(Exp({mantissa: vars.borrowRateMantissa}), vars.blockDelta);
1501         if (vars.mathErr != MathError.NO_ERROR) {
1502             return failOpaque(Error.MATH_ERROR, FailureInfo.ACCRUE_INTEREST_SIMPLE_INTEREST_FACTOR_CALCULATION_FAILED, uint(vars.mathErr));
1503         }
1504 
1505         (vars.mathErr, vars.interestAccumulated) = mulScalarTruncate(vars.simpleInterestFactor, totalBorrows);
1506         if (vars.mathErr != MathError.NO_ERROR) {
1507             return failOpaque(Error.MATH_ERROR, FailureInfo.ACCRUE_INTEREST_ACCUMULATED_INTEREST_CALCULATION_FAILED, uint(vars.mathErr));
1508         }
1509 
1510         (vars.mathErr, vars.totalBorrowsNew) = addUInt(vars.interestAccumulated, totalBorrows);
1511         if (vars.mathErr != MathError.NO_ERROR) {
1512             return failOpaque(Error.MATH_ERROR, FailureInfo.ACCRUE_INTEREST_NEW_TOTAL_BORROWS_CALCULATION_FAILED, uint(vars.mathErr));
1513         }
1514 
1515         (vars.mathErr, vars.totalReservesNew) = mulScalarTruncateAddUInt(Exp({mantissa: reserveFactorMantissa}), vars.interestAccumulated, totalReserves);
1516         if (vars.mathErr != MathError.NO_ERROR) {
1517             return failOpaque(Error.MATH_ERROR, FailureInfo.ACCRUE_INTEREST_NEW_TOTAL_RESERVES_CALCULATION_FAILED, uint(vars.mathErr));
1518         }
1519 
1520         (vars.mathErr, vars.borrowIndexNew) = mulScalarTruncateAddUInt(vars.simpleInterestFactor, borrowIndex, borrowIndex);
1521         if (vars.mathErr != MathError.NO_ERROR) {
1522             return failOpaque(Error.MATH_ERROR, FailureInfo.ACCRUE_INTEREST_NEW_BORROW_INDEX_CALCULATION_FAILED, uint(vars.mathErr));
1523         }
1524 
1525         /////////////////////////
1526         // EFFECTS & INTERACTIONS
1527         // (No safe failures beyond this point)
1528 
1529         /* We write the previously calculated values into storage */
1530         accrualBlockNumber = vars.currentBlockNumber;
1531         borrowIndex = vars.borrowIndexNew;
1532         totalBorrows = vars.totalBorrowsNew;
1533         totalReserves = vars.totalReservesNew;
1534 
1535         /* We emit an AccrueInterest event */
1536         emit AccrueInterest(cashPrior, vars.interestAccumulated, vars.borrowIndexNew, totalBorrows);
1537 
1538         return uint(Error.NO_ERROR);
1539     }
1540 
1541     /**
1542      * @notice Sender supplies assets into the market and receives cTokens in exchange
1543      * @dev Accrues interest whether or not the operation succeeds, unless reverted
1544      * @param mintAmount The amount of the underlying asset to supply
1545      * @return (uint, uint) An error code (0=success, otherwise a failure, see ErrorReporter.sol), and the actual mint amount.
1546      */
1547     function mintInternal(uint mintAmount) internal nonReentrant returns (uint, uint) {
1548         uint error = accrueInterest();
1549         if (error != uint(Error.NO_ERROR)) {
1550             // accrueInterest emits logs on errors, but we still want to log the fact that an attempted borrow failed
1551             return (fail(Error(error), FailureInfo.MINT_ACCRUE_INTEREST_FAILED), 0);
1552         }
1553         // mintFresh emits the actual Mint event if successful and logs on errors, so we don't need to
1554         return mintFresh(msg.sender, mintAmount);
1555     }
1556 
1557     struct MintLocalVars {
1558         Error err;
1559         MathError mathErr;
1560         uint exchangeRateMantissa;
1561         uint mintTokens;
1562         uint totalSupplyNew;
1563         uint accountTokensNew;
1564         uint actualMintAmount;
1565     }
1566 
1567     /**
1568      * @notice User supplies assets into the market and receives cTokens in exchange
1569      * @dev Assumes interest has already been accrued up to the current block
1570      * @param minter The address of the account which is supplying the assets
1571      * @param mintAmount The amount of the underlying asset to supply
1572      * @return (uint, uint) An error code (0=success, otherwise a failure, see ErrorReporter.sol), and the actual mint amount.
1573      */
1574     function mintFresh(address minter, uint mintAmount) internal returns (uint, uint) {
1575         /* Fail if mint not allowed */
1576         uint allowed = comptroller.mintAllowed(address(this), minter, mintAmount);
1577         if (allowed != 0) {
1578             return (failOpaque(Error.COMPTROLLER_REJECTION, FailureInfo.MINT_COMPTROLLER_REJECTION, allowed), 0);
1579         }
1580 
1581         /* Verify market's block number equals current block number */
1582         if (accrualBlockNumber != getBlockNumber()) {
1583             return (fail(Error.MARKET_NOT_FRESH, FailureInfo.MINT_FRESHNESS_CHECK), 0);
1584         }
1585 
1586         MintLocalVars memory vars;
1587 
1588         /* Fail if checkTransferIn fails */
1589         vars.err = checkTransferIn(minter, mintAmount);
1590         if (vars.err != Error.NO_ERROR) {
1591             return (fail(vars.err, FailureInfo.MINT_TRANSFER_IN_NOT_POSSIBLE), 0);
1592         }
1593 
1594         (vars.mathErr, vars.exchangeRateMantissa) = exchangeRateStoredInternal();
1595         if (vars.mathErr != MathError.NO_ERROR) {
1596             return (failOpaque(Error.MATH_ERROR, FailureInfo.MINT_EXCHANGE_RATE_READ_FAILED, uint(vars.mathErr)), 0);
1597         }
1598 
1599         /////////////////////////
1600         // EFFECTS & INTERACTIONS
1601         // (No safe failures beyond this point)
1602 
1603         /*
1604          *  We call `doTransferIn` for the minter and the mintAmount.
1605          *  Note: The cToken must handle variations between ERC-20 and ETH underlying.
1606          *  `doTransferIn` reverts if anything goes wrong, since we can't be sure if
1607          *  side-effects occurred. The function returns the amount actually transferred,
1608          *  in case of a fee. On success, the cToken holds an additional `actualMintAmount`
1609          *  of cash.
1610          */
1611         vars.actualMintAmount = doTransferIn(minter, mintAmount);
1612 
1613         /*
1614          * We get the current exchange rate and calculate the number of cTokens to be minted:
1615          *  mintTokens = actualMintAmount / exchangeRate
1616          */
1617 
1618         (vars.mathErr, vars.mintTokens) = divScalarByExpTruncate(vars.actualMintAmount, Exp({mantissa: vars.exchangeRateMantissa}));
1619         require(vars.mathErr == MathError.NO_ERROR, "MINT_EXCHANGE_CALCULATION_FAILED");
1620 
1621         /*
1622          * We calculate the new total supply of cTokens and minter token balance, checking for overflow:
1623          *  totalSupplyNew = totalSupply + mintTokens
1624          *  accountTokensNew = accountTokens[minter] + mintTokens
1625          */
1626         (vars.mathErr, vars.totalSupplyNew) = addUInt(totalSupply, vars.mintTokens);
1627         require(vars.mathErr == MathError.NO_ERROR, "MINT_NEW_TOTAL_SUPPLY_CALCULATION_FAILED");
1628 
1629         (vars.mathErr, vars.accountTokensNew) = addUInt(accountTokens[minter], vars.mintTokens);
1630         require(vars.mathErr == MathError.NO_ERROR, "MINT_NEW_ACCOUNT_BALANCE_CALCULATION_FAILED");
1631 
1632         /* We write previously calculated values into storage */
1633         totalSupply = vars.totalSupplyNew;
1634         accountTokens[minter] = vars.accountTokensNew;
1635 
1636         /* We emit a Mint event, and a Transfer event */
1637         emit Mint(minter, vars.actualMintAmount, vars.mintTokens);
1638         emit Transfer(address(this), minter, vars.mintTokens);
1639 
1640         /* We call the defense hook */
1641         comptroller.mintVerify(address(this), minter, vars.actualMintAmount, vars.mintTokens);
1642 
1643         return (uint(Error.NO_ERROR), vars.actualMintAmount);
1644     }
1645 
1646     /**
1647      * @notice Sender redeems cTokens in exchange for the underlying asset
1648      * @dev Accrues interest whether or not the operation succeeds, unless reverted
1649      * @param redeemTokens The number of cTokens to redeem into underlying
1650      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
1651      */
1652     function redeemInternal(uint redeemTokens) internal nonReentrant returns (uint) {
1653         uint error = accrueInterest();
1654         if (error != uint(Error.NO_ERROR)) {
1655             // accrueInterest emits logs on errors, but we still want to log the fact that an attempted redeem failed
1656             return fail(Error(error), FailureInfo.REDEEM_ACCRUE_INTEREST_FAILED);
1657         }
1658         // redeemFresh emits redeem-specific logs on errors, so we don't need to
1659         return redeemFresh(msg.sender, redeemTokens, 0);
1660     }
1661 
1662     /**
1663      * @notice Sender redeems cTokens in exchange for a specified amount of underlying asset
1664      * @dev Accrues interest whether or not the operation succeeds, unless reverted
1665      * @param redeemAmount The amount of underlying to receive from redeeming cTokens
1666      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
1667      */
1668     function redeemUnderlyingInternal(uint redeemAmount) internal nonReentrant returns (uint) {
1669         uint error = accrueInterest();
1670         if (error != uint(Error.NO_ERROR)) {
1671             // accrueInterest emits logs on errors, but we still want to log the fact that an attempted redeem failed
1672             return fail(Error(error), FailureInfo.REDEEM_ACCRUE_INTEREST_FAILED);
1673         }
1674         // redeemFresh emits redeem-specific logs on errors, so we don't need to
1675         return redeemFresh(msg.sender, 0, redeemAmount);
1676     }
1677 
1678     struct RedeemLocalVars {
1679         Error err;
1680         MathError mathErr;
1681         uint exchangeRateMantissa;
1682         uint redeemTokens;
1683         uint redeemAmount;
1684         uint totalSupplyNew;
1685         uint accountTokensNew;
1686     }
1687 
1688     /**
1689      * @notice User redeems cTokens in exchange for the underlying asset
1690      * @dev Assumes interest has already been accrued up to the current block
1691      * @param redeemer The address of the account which is redeeming the tokens
1692      * @param redeemTokensIn The number of cTokens to redeem into underlying (only one of redeemTokensIn or redeemAmountIn may be non-zero)
1693      * @param redeemAmountIn The number of underlying tokens to receive from redeeming cTokens (only one of redeemTokensIn or redeemAmountIn may be non-zero)
1694      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
1695      */
1696     function redeemFresh(address payable redeemer, uint redeemTokensIn, uint redeemAmountIn) internal returns (uint) {
1697         require(redeemTokensIn == 0 || redeemAmountIn == 0, "one of redeemTokensIn or redeemAmountIn must be zero");
1698 
1699         RedeemLocalVars memory vars;
1700 
1701         /* exchangeRate = invoke Exchange Rate Stored() */
1702         (vars.mathErr, vars.exchangeRateMantissa) = exchangeRateStoredInternal();
1703         if (vars.mathErr != MathError.NO_ERROR) {
1704             return failOpaque(Error.MATH_ERROR, FailureInfo.REDEEM_EXCHANGE_RATE_READ_FAILED, uint(vars.mathErr));
1705         }
1706 
1707         /* If redeemTokensIn > 0: */
1708         if (redeemTokensIn > 0) {
1709             /*
1710              * We calculate the exchange rate and the amount of underlying to be redeemed:
1711              *  redeemTokens = redeemTokensIn
1712              *  redeemAmount = redeemTokensIn x exchangeRateCurrent
1713              */
1714             vars.redeemTokens = redeemTokensIn;
1715 
1716             (vars.mathErr, vars.redeemAmount) = mulScalarTruncate(Exp({mantissa: vars.exchangeRateMantissa}), redeemTokensIn);
1717             if (vars.mathErr != MathError.NO_ERROR) {
1718                 return failOpaque(Error.MATH_ERROR, FailureInfo.REDEEM_EXCHANGE_TOKENS_CALCULATION_FAILED, uint(vars.mathErr));
1719             }
1720         } else {
1721             /*
1722              * We get the current exchange rate and calculate the amount to be redeemed:
1723              *  redeemTokens = redeemAmountIn / exchangeRate
1724              *  redeemAmount = redeemAmountIn
1725              */
1726 
1727             (vars.mathErr, vars.redeemTokens) = divScalarByExpTruncate(redeemAmountIn, Exp({mantissa: vars.exchangeRateMantissa}));
1728             if (vars.mathErr != MathError.NO_ERROR) {
1729                 return failOpaque(Error.MATH_ERROR, FailureInfo.REDEEM_EXCHANGE_AMOUNT_CALCULATION_FAILED, uint(vars.mathErr));
1730             }
1731 
1732             vars.redeemAmount = redeemAmountIn;
1733         }
1734 
1735         /* Fail if redeem not allowed */
1736         uint allowed = comptroller.redeemAllowed(address(this), redeemer, vars.redeemTokens);
1737         if (allowed != 0) {
1738             return failOpaque(Error.COMPTROLLER_REJECTION, FailureInfo.REDEEM_COMPTROLLER_REJECTION, allowed);
1739         }
1740 
1741         /* Verify market's block number equals current block number */
1742         if (accrualBlockNumber != getBlockNumber()) {
1743             return fail(Error.MARKET_NOT_FRESH, FailureInfo.REDEEM_FRESHNESS_CHECK);
1744         }
1745 
1746         /*
1747          * We calculate the new total supply and redeemer balance, checking for underflow:
1748          *  totalSupplyNew = totalSupply - redeemTokens
1749          *  accountTokensNew = accountTokens[redeemer] - redeemTokens
1750          */
1751         (vars.mathErr, vars.totalSupplyNew) = subUInt(totalSupply, vars.redeemTokens);
1752         if (vars.mathErr != MathError.NO_ERROR) {
1753             return failOpaque(Error.MATH_ERROR, FailureInfo.REDEEM_NEW_TOTAL_SUPPLY_CALCULATION_FAILED, uint(vars.mathErr));
1754         }
1755 
1756         (vars.mathErr, vars.accountTokensNew) = subUInt(accountTokens[redeemer], vars.redeemTokens);
1757         if (vars.mathErr != MathError.NO_ERROR) {
1758             return failOpaque(Error.MATH_ERROR, FailureInfo.REDEEM_NEW_ACCOUNT_BALANCE_CALCULATION_FAILED, uint(vars.mathErr));
1759         }
1760 
1761         /* Fail gracefully if protocol has insufficient cash */
1762         if (getCashPrior() < vars.redeemAmount) {
1763             return fail(Error.TOKEN_INSUFFICIENT_CASH, FailureInfo.REDEEM_TRANSFER_OUT_NOT_POSSIBLE);
1764         }
1765 
1766         /////////////////////////
1767         // EFFECTS & INTERACTIONS
1768         // (No safe failures beyond this point)
1769 
1770         /*
1771          * We invoke doTransferOut for the redeemer and the redeemAmount.
1772          *  Note: The cToken must handle variations between ERC-20 and ETH underlying.
1773          *  On success, the cToken has redeemAmount less of cash.
1774          *  doTransferOut reverts if anything goes wrong, since we can't be sure if side effects occurred.
1775          */
1776         doTransferOut(redeemer, vars.redeemAmount);
1777 
1778         /* We write previously calculated values into storage */
1779         totalSupply = vars.totalSupplyNew;
1780         accountTokens[redeemer] = vars.accountTokensNew;
1781 
1782         /* We emit a Transfer event, and a Redeem event */
1783         emit Transfer(redeemer, address(this), vars.redeemTokens);
1784         emit Redeem(redeemer, vars.redeemAmount, vars.redeemTokens);
1785 
1786         /* We call the defense hook */
1787         comptroller.redeemVerify(address(this), redeemer, vars.redeemAmount, vars.redeemTokens);
1788 
1789         return uint(Error.NO_ERROR);
1790     }
1791 
1792     /**
1793       * @notice Sender borrows assets from the protocol to their own address
1794       * @param borrowAmount The amount of the underlying asset to borrow
1795       * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
1796       */
1797     function borrowInternal(uint borrowAmount) internal nonReentrant returns (uint) {
1798         uint error = accrueInterest();
1799         if (error != uint(Error.NO_ERROR)) {
1800             // accrueInterest emits logs on errors, but we still want to log the fact that an attempted borrow failed
1801             return fail(Error(error), FailureInfo.BORROW_ACCRUE_INTEREST_FAILED);
1802         }
1803         // borrowFresh emits borrow-specific logs on errors, so we don't need to
1804         return borrowFresh(msg.sender, borrowAmount);
1805     }
1806 
1807     struct BorrowLocalVars {
1808         MathError mathErr;
1809         uint accountBorrows;
1810         uint accountBorrowsNew;
1811         uint totalBorrowsNew;
1812     }
1813 
1814     /**
1815       * @notice Users borrow assets from the protocol to their own address
1816       * @param borrowAmount The amount of the underlying asset to borrow
1817       * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
1818       */
1819     function borrowFresh(address payable borrower, uint borrowAmount) internal returns (uint) {
1820         /* Fail if borrow not allowed */
1821         uint allowed = comptroller.borrowAllowed(address(this), borrower, borrowAmount);
1822         if (allowed != 0) {
1823             return failOpaque(Error.COMPTROLLER_REJECTION, FailureInfo.BORROW_COMPTROLLER_REJECTION, allowed);
1824         }
1825 
1826         /* Verify market's block number equals current block number */
1827         if (accrualBlockNumber != getBlockNumber()) {
1828             return fail(Error.MARKET_NOT_FRESH, FailureInfo.BORROW_FRESHNESS_CHECK);
1829         }
1830 
1831         /* Fail gracefully if protocol has insufficient underlying cash */
1832         if (getCashPrior() < borrowAmount) {
1833             return fail(Error.TOKEN_INSUFFICIENT_CASH, FailureInfo.BORROW_CASH_NOT_AVAILABLE);
1834         }
1835 
1836         BorrowLocalVars memory vars;
1837 
1838         /*
1839          * We calculate the new borrower and total borrow balances, failing on overflow:
1840          *  accountBorrowsNew = accountBorrows + borrowAmount
1841          *  totalBorrowsNew = totalBorrows + borrowAmount
1842          */
1843         (vars.mathErr, vars.accountBorrows) = borrowBalanceStoredInternal(borrower);
1844         if (vars.mathErr != MathError.NO_ERROR) {
1845             return failOpaque(Error.MATH_ERROR, FailureInfo.BORROW_ACCUMULATED_BALANCE_CALCULATION_FAILED, uint(vars.mathErr));
1846         }
1847 
1848         (vars.mathErr, vars.accountBorrowsNew) = addUInt(vars.accountBorrows, borrowAmount);
1849         if (vars.mathErr != MathError.NO_ERROR) {
1850             return failOpaque(Error.MATH_ERROR, FailureInfo.BORROW_NEW_ACCOUNT_BORROW_BALANCE_CALCULATION_FAILED, uint(vars.mathErr));
1851         }
1852 
1853         (vars.mathErr, vars.totalBorrowsNew) = addUInt(totalBorrows, borrowAmount);
1854         if (vars.mathErr != MathError.NO_ERROR) {
1855             return failOpaque(Error.MATH_ERROR, FailureInfo.BORROW_NEW_TOTAL_BALANCE_CALCULATION_FAILED, uint(vars.mathErr));
1856         }
1857 
1858         /////////////////////////
1859         // EFFECTS & INTERACTIONS
1860         // (No safe failures beyond this point)
1861 
1862         /*
1863          * We invoke doTransferOut for the borrower and the borrowAmount.
1864          *  Note: The cToken must handle variations between ERC-20 and ETH underlying.
1865          *  On success, the cToken borrowAmount less of cash.
1866          *  doTransferOut reverts if anything goes wrong, since we can't be sure if side effects occurred.
1867          */
1868         doTransferOut(borrower, borrowAmount);
1869 
1870         /* We write the previously calculated values into storage */
1871         accountBorrows[borrower].principal = vars.accountBorrowsNew;
1872         accountBorrows[borrower].interestIndex = borrowIndex;
1873         totalBorrows = vars.totalBorrowsNew;
1874 
1875         /* We emit a Borrow event */
1876         emit Borrow(borrower, borrowAmount, vars.accountBorrowsNew, vars.totalBorrowsNew);
1877 
1878         /* We call the defense hook */
1879         comptroller.borrowVerify(address(this), borrower, borrowAmount);
1880 
1881         return uint(Error.NO_ERROR);
1882     }
1883 
1884     /**
1885      * @notice Sender repays their own borrow
1886      * @param repayAmount The amount to repay
1887      * @return (uint, uint) An error code (0=success, otherwise a failure, see ErrorReporter.sol), and the actual repayment amount.
1888      */
1889     function repayBorrowInternal(uint repayAmount) internal nonReentrant returns (uint, uint) {
1890         uint error = accrueInterest();
1891         if (error != uint(Error.NO_ERROR)) {
1892             // accrueInterest emits logs on errors, but we still want to log the fact that an attempted borrow failed
1893             return (fail(Error(error), FailureInfo.REPAY_BORROW_ACCRUE_INTEREST_FAILED), 0);
1894         }
1895         // repayBorrowFresh emits repay-borrow-specific logs on errors, so we don't need to
1896         return repayBorrowFresh(msg.sender, msg.sender, repayAmount);
1897     }
1898 
1899     /**
1900      * @notice Sender repays a borrow belonging to borrower
1901      * @param borrower the account with the debt being payed off
1902      * @param repayAmount The amount to repay
1903      * @return (uint, uint) An error code (0=success, otherwise a failure, see ErrorReporter.sol), and the actual repayment amount.
1904      */
1905     function repayBorrowBehalfInternal(address borrower, uint repayAmount) internal nonReentrant returns (uint, uint) {
1906         uint error = accrueInterest();
1907         if (error != uint(Error.NO_ERROR)) {
1908             // accrueInterest emits logs on errors, but we still want to log the fact that an attempted borrow failed
1909             return (fail(Error(error), FailureInfo.REPAY_BEHALF_ACCRUE_INTEREST_FAILED), 0);
1910         }
1911         // repayBorrowFresh emits repay-borrow-specific logs on errors, so we don't need to
1912         return repayBorrowFresh(msg.sender, borrower, repayAmount);
1913     }
1914 
1915     struct RepayBorrowLocalVars {
1916         Error err;
1917         MathError mathErr;
1918         uint repayAmount;
1919         uint borrowerIndex;
1920         uint accountBorrows;
1921         uint accountBorrowsNew;
1922         uint totalBorrowsNew;
1923         uint actualRepayAmount;
1924     }
1925 
1926     /**
1927      * @notice Borrows are repaid by another user (possibly the borrower).
1928      * @param payer the account paying off the borrow
1929      * @param borrower the account with the debt being payed off
1930      * @param repayAmount the amount of undelrying tokens being returned
1931      * @return (uint, uint) An error code (0=success, otherwise a failure, see ErrorReporter.sol), and the actual repayment amount.
1932      */
1933     function repayBorrowFresh(address payer, address borrower, uint repayAmount) internal returns (uint, uint) {
1934         /* Fail if repayBorrow not allowed */
1935         uint allowed = comptroller.repayBorrowAllowed(address(this), payer, borrower, repayAmount);
1936         if (allowed != 0) {
1937             return (failOpaque(Error.COMPTROLLER_REJECTION, FailureInfo.REPAY_BORROW_COMPTROLLER_REJECTION, allowed), 0);
1938         }
1939 
1940         /* Verify market's block number equals current block number */
1941         if (accrualBlockNumber != getBlockNumber()) {
1942             return (fail(Error.MARKET_NOT_FRESH, FailureInfo.REPAY_BORROW_FRESHNESS_CHECK), 0);
1943         }
1944 
1945         RepayBorrowLocalVars memory vars;
1946 
1947         /* We remember the original borrowerIndex for verification purposes */
1948         vars.borrowerIndex = accountBorrows[borrower].interestIndex;
1949 
1950         /* We fetch the amount the borrower owes, with accumulated interest */
1951         (vars.mathErr, vars.accountBorrows) = borrowBalanceStoredInternal(borrower);
1952         if (vars.mathErr != MathError.NO_ERROR) {
1953             return (failOpaque(Error.MATH_ERROR, FailureInfo.REPAY_BORROW_ACCUMULATED_BALANCE_CALCULATION_FAILED, uint(vars.mathErr)), 0);
1954         }
1955 
1956         /* If repayAmount == -1, repayAmount = accountBorrows */
1957         if (repayAmount == uint(-1)) {
1958             vars.repayAmount = vars.accountBorrows;
1959         } else {
1960             vars.repayAmount = repayAmount;
1961         }
1962 
1963         /* Fail if checkTransferIn fails */
1964         vars.err = checkTransferIn(payer, vars.repayAmount);
1965         if (vars.err != Error.NO_ERROR) {
1966             return (fail(vars.err, FailureInfo.REPAY_BORROW_TRANSFER_IN_NOT_POSSIBLE), 0);
1967         }
1968 
1969         /////////////////////////
1970         // EFFECTS & INTERACTIONS
1971         // (No safe failures beyond this point)
1972 
1973         /*
1974          * We call doTransferIn for the payer and the repayAmount
1975          *  Note: The cToken must handle variations between ERC-20 and ETH underlying.
1976          *  On success, the cToken holds an additional repayAmount of cash.
1977          *  doTransferIn reverts if anything goes wrong, since we can't be sure if side effects occurred.
1978          *   it returns the amount actually transferred, in case of a fee.
1979          */
1980         vars.actualRepayAmount = doTransferIn(payer, vars.repayAmount);
1981 
1982         /*
1983          * We calculate the new borrower and total borrow balances, failing on underflow:
1984          *  accountBorrowsNew = accountBorrows - actualRepayAmount
1985          *  totalBorrowsNew = totalBorrows - actualRepayAmount
1986          */
1987         (vars.mathErr, vars.accountBorrowsNew) = subUInt(vars.accountBorrows, vars.actualRepayAmount);
1988         require(vars.mathErr == MathError.NO_ERROR, "REPAY_BORROW_NEW_ACCOUNT_BORROW_BALANCE_CALCULATION_FAILED");
1989 
1990         (vars.mathErr, vars.totalBorrowsNew) = subUInt(totalBorrows, vars.actualRepayAmount);
1991         require(vars.mathErr == MathError.NO_ERROR, "REPAY_BORROW_NEW_TOTAL_BALANCE_CALCULATION_FAILED");
1992 
1993         /* We write the previously calculated values into storage */
1994         accountBorrows[borrower].principal = vars.accountBorrowsNew;
1995         accountBorrows[borrower].interestIndex = borrowIndex;
1996         totalBorrows = vars.totalBorrowsNew;
1997 
1998         /* We emit a RepayBorrow event */
1999         emit RepayBorrow(payer, borrower, vars.actualRepayAmount, vars.accountBorrowsNew, vars.totalBorrowsNew);
2000 
2001         /* We call the defense hook */
2002         comptroller.repayBorrowVerify(address(this), payer, borrower, vars.actualRepayAmount, vars.borrowerIndex);
2003 
2004         return (uint(Error.NO_ERROR), vars.actualRepayAmount);
2005     }
2006 
2007     /**
2008      * @notice The sender liquidates the borrowers collateral.
2009      *  The collateral seized is transferred to the liquidator.
2010      * @param borrower The borrower of this cToken to be liquidated
2011      * @param cTokenCollateral The market in which to seize collateral from the borrower
2012      * @param repayAmount The amount of the underlying borrowed asset to repay
2013      * @return (uint, uint) An error code (0=success, otherwise a failure, see ErrorReporter.sol), and the actual repayment amount.
2014      */
2015     function liquidateBorrowInternal(address borrower, uint repayAmount, CTokenInterface cTokenCollateral) internal nonReentrant returns (uint, uint) {
2016         uint error = accrueInterest();
2017         if (error != uint(Error.NO_ERROR)) {
2018             // accrueInterest emits logs on errors, but we still want to log the fact that an attempted liquidation failed
2019             return (fail(Error(error), FailureInfo.LIQUIDATE_ACCRUE_BORROW_INTEREST_FAILED), 0);
2020         }
2021 
2022         error = cTokenCollateral.accrueInterest();
2023         if (error != uint(Error.NO_ERROR)) {
2024             // accrueInterest emits logs on errors, but we still want to log the fact that an attempted liquidation failed
2025             return (fail(Error(error), FailureInfo.LIQUIDATE_ACCRUE_COLLATERAL_INTEREST_FAILED), 0);
2026         }
2027 
2028         // liquidateBorrowFresh emits borrow-specific logs on errors, so we don't need to
2029         return liquidateBorrowFresh(msg.sender, borrower, repayAmount, cTokenCollateral);
2030     }
2031 
2032     /**
2033      * @notice The liquidator liquidates the borrowers collateral.
2034      *  The collateral seized is transferred to the liquidator.
2035      * @param borrower The borrower of this cToken to be liquidated
2036      * @param liquidator The address repaying the borrow and seizing collateral
2037      * @param cTokenCollateral The market in which to seize collateral from the borrower
2038      * @param repayAmount The amount of the underlying borrowed asset to repay
2039      * @return (uint, uint) An error code (0=success, otherwise a failure, see ErrorReporter.sol), and the actual repayment amount.
2040      */
2041     function liquidateBorrowFresh(address liquidator, address borrower, uint repayAmount, CTokenInterface cTokenCollateral) internal returns (uint, uint) {
2042         /* Fail if liquidate not allowed */
2043         uint allowed = comptroller.liquidateBorrowAllowed(address(this), address(cTokenCollateral), liquidator, borrower, repayAmount);
2044         if (allowed != 0) {
2045             return (failOpaque(Error.COMPTROLLER_REJECTION, FailureInfo.LIQUIDATE_COMPTROLLER_REJECTION, allowed), 0);
2046         }
2047 
2048         /* Verify market's block number equals current block number */
2049         if (accrualBlockNumber != getBlockNumber()) {
2050             return (fail(Error.MARKET_NOT_FRESH, FailureInfo.LIQUIDATE_FRESHNESS_CHECK), 0);
2051         }
2052 
2053         /* Verify cTokenCollateral market's block number equals current block number */
2054         if (cTokenCollateral.accrualBlockNumber() != getBlockNumber()) {
2055             return (fail(Error.MARKET_NOT_FRESH, FailureInfo.LIQUIDATE_COLLATERAL_FRESHNESS_CHECK), 0);
2056         }
2057 
2058         /* Fail if borrower = liquidator */
2059         if (borrower == liquidator) {
2060             return (fail(Error.INVALID_ACCOUNT_PAIR, FailureInfo.LIQUIDATE_LIQUIDATOR_IS_BORROWER), 0);
2061         }
2062 
2063         /* Fail if repayAmount = 0 */
2064         if (repayAmount == 0) {
2065             return (fail(Error.INVALID_CLOSE_AMOUNT_REQUESTED, FailureInfo.LIQUIDATE_CLOSE_AMOUNT_IS_ZERO), 0);
2066         }
2067 
2068         /* Fail if repayAmount = -1 */
2069         if (repayAmount == uint(-1)) {
2070             return (fail(Error.INVALID_CLOSE_AMOUNT_REQUESTED, FailureInfo.LIQUIDATE_CLOSE_AMOUNT_IS_UINT_MAX), 0);
2071         }
2072 
2073 
2074         /* Fail if repayBorrow fails */
2075         (uint repayBorrowError, uint actualRepayAmount) = repayBorrowFresh(liquidator, borrower, repayAmount);
2076         if (repayBorrowError != uint(Error.NO_ERROR)) {
2077             return (fail(Error(repayBorrowError), FailureInfo.LIQUIDATE_REPAY_BORROW_FRESH_FAILED), 0);
2078         }
2079 
2080         /////////////////////////
2081         // EFFECTS & INTERACTIONS
2082         // (No safe failures beyond this point)
2083 
2084         /* We calculate the number of collateral tokens that will be seized */
2085         (uint amountSeizeError, uint seizeTokens) = comptroller.liquidateCalculateSeizeTokens(address(this), address(cTokenCollateral), actualRepayAmount);
2086         require(amountSeizeError == uint(Error.NO_ERROR), "LIQUIDATE_COMPTROLLER_CALCULATE_AMOUNT_SEIZE_FAILED");
2087 
2088         /* Revert if borrower collateral token balance < seizeTokens */
2089         require(cTokenCollateral.balanceOf(borrower) >= seizeTokens, "LIQUIDATE_SEIZE_TOO_MUCH");
2090 
2091         // If this is also the collateral, run seizeInternal to avoid re-entrancy, otherwise make an external call
2092         uint seizeError;
2093         if (address(cTokenCollateral) == address(this)) {
2094             seizeError = seizeInternal(address(this), liquidator, borrower, seizeTokens);
2095         } else {
2096             seizeError = cTokenCollateral.seize(liquidator, borrower, seizeTokens);
2097         }
2098 
2099         /* Revert if seize tokens fails (since we cannot be sure of side effects) */
2100         require(seizeError == uint(Error.NO_ERROR), "token seizure failed");
2101 
2102         /* We emit a LiquidateBorrow event */
2103         emit LiquidateBorrow(liquidator, borrower, actualRepayAmount, address(cTokenCollateral), seizeTokens);
2104 
2105         /* We call the defense hook */
2106         comptroller.liquidateBorrowVerify(address(this), address(cTokenCollateral), liquidator, borrower, actualRepayAmount, seizeTokens);
2107 
2108         return (uint(Error.NO_ERROR), actualRepayAmount);
2109     }
2110 
2111     /**
2112      * @notice Transfers collateral tokens (this market) to the liquidator.
2113      * @dev Will fail unless called by another cToken during the process of liquidation.
2114      *  Its absolutely critical to use msg.sender as the borrowed cToken and not a parameter.
2115      * @param liquidator The account receiving seized collateral
2116      * @param borrower The account having collateral seized
2117      * @param seizeTokens The number of cTokens to seize
2118      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
2119      */
2120     function seize(address liquidator, address borrower, uint seizeTokens) external nonReentrant returns (uint) {
2121         return seizeInternal(msg.sender, liquidator, borrower, seizeTokens);
2122     }
2123 
2124     /**
2125      * @notice Transfers collateral tokens (this market) to the liquidator.
2126      * @dev Called only during an in-kind liquidation, or by liquidateBorrow during the liquidation of another CToken.
2127      *  Its absolutely critical to use msg.sender as the seizer cToken and not a parameter.
2128      * @param seizerToken The contract seizing the collateral (i.e. borrowed cToken)
2129      * @param liquidator The account receiving seized collateral
2130      * @param borrower The account having collateral seized
2131      * @param seizeTokens The number of cTokens to seize
2132      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
2133      */
2134     function seizeInternal(address seizerToken, address liquidator, address borrower, uint seizeTokens) internal returns (uint) {
2135         /* Fail if seize not allowed */
2136         uint allowed = comptroller.seizeAllowed(address(this), seizerToken, liquidator, borrower, seizeTokens);
2137         if (allowed != 0) {
2138             return failOpaque(Error.COMPTROLLER_REJECTION, FailureInfo.LIQUIDATE_SEIZE_COMPTROLLER_REJECTION, allowed);
2139         }
2140 
2141         /* Fail if borrower = liquidator */
2142         if (borrower == liquidator) {
2143             return fail(Error.INVALID_ACCOUNT_PAIR, FailureInfo.LIQUIDATE_SEIZE_LIQUIDATOR_IS_BORROWER);
2144         }
2145 
2146         MathError mathErr;
2147         uint borrowerTokensNew;
2148         uint liquidatorTokensNew;
2149 
2150         /*
2151          * We calculate the new borrower and liquidator token balances, failing on underflow/overflow:
2152          *  borrowerTokensNew = accountTokens[borrower] - seizeTokens
2153          *  liquidatorTokensNew = accountTokens[liquidator] + seizeTokens
2154          */
2155         (mathErr, borrowerTokensNew) = subUInt(accountTokens[borrower], seizeTokens);
2156         if (mathErr != MathError.NO_ERROR) {
2157             return failOpaque(Error.MATH_ERROR, FailureInfo.LIQUIDATE_SEIZE_BALANCE_DECREMENT_FAILED, uint(mathErr));
2158         }
2159 
2160         (mathErr, liquidatorTokensNew) = addUInt(accountTokens[liquidator], seizeTokens);
2161         if (mathErr != MathError.NO_ERROR) {
2162             return failOpaque(Error.MATH_ERROR, FailureInfo.LIQUIDATE_SEIZE_BALANCE_INCREMENT_FAILED, uint(mathErr));
2163         }
2164 
2165         /////////////////////////
2166         // EFFECTS & INTERACTIONS
2167         // (No safe failures beyond this point)
2168 
2169         /* We write the previously calculated values into storage */
2170         accountTokens[borrower] = borrowerTokensNew;
2171         accountTokens[liquidator] = liquidatorTokensNew;
2172 
2173         /* Emit a Transfer event */
2174         emit Transfer(borrower, liquidator, seizeTokens);
2175 
2176         /* We call the defense hook */
2177         comptroller.seizeVerify(address(this), seizerToken, liquidator, borrower, seizeTokens);
2178 
2179         return uint(Error.NO_ERROR);
2180     }
2181 
2182 
2183     /*** Admin Functions ***/
2184 
2185     /**
2186       * @notice Begins transfer of admin rights. The newPendingAdmin must call `_acceptAdmin` to finalize the transfer.
2187       * @dev Admin function to begin change of admin. The newPendingAdmin must call `_acceptAdmin` to finalize the transfer.
2188       * @param newPendingAdmin New pending admin.
2189       * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
2190       */
2191     function _setPendingAdmin(address payable newPendingAdmin) external returns (uint) {
2192         // Check caller = admin
2193         if (msg.sender != admin) {
2194             return fail(Error.UNAUTHORIZED, FailureInfo.SET_PENDING_ADMIN_OWNER_CHECK);
2195         }
2196 
2197         // Save current value, if any, for inclusion in log
2198         address oldPendingAdmin = pendingAdmin;
2199 
2200         // Store pendingAdmin with value newPendingAdmin
2201         pendingAdmin = newPendingAdmin;
2202 
2203         // Emit NewPendingAdmin(oldPendingAdmin, newPendingAdmin)
2204         emit NewPendingAdmin(oldPendingAdmin, newPendingAdmin);
2205 
2206         return uint(Error.NO_ERROR);
2207     }
2208 
2209     /**
2210       * @notice Accepts transfer of admin rights. msg.sender must be pendingAdmin
2211       * @dev Admin function for pending admin to accept role and update admin
2212       * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
2213       */
2214     function _acceptAdmin() external returns (uint) {
2215         // Check caller is pendingAdmin and pendingAdmin ≠ address(0)
2216         if (msg.sender != pendingAdmin || msg.sender == address(0)) {
2217             return fail(Error.UNAUTHORIZED, FailureInfo.ACCEPT_ADMIN_PENDING_ADMIN_CHECK);
2218         }
2219 
2220         // Save current values for inclusion in log
2221         address oldAdmin = admin;
2222         address oldPendingAdmin = pendingAdmin;
2223 
2224         // Store admin with value pendingAdmin
2225         admin = pendingAdmin;
2226 
2227         // Clear the pending value
2228         pendingAdmin = address(0);
2229 
2230         emit NewAdmin(oldAdmin, admin);
2231         emit NewPendingAdmin(oldPendingAdmin, pendingAdmin);
2232 
2233         return uint(Error.NO_ERROR);
2234     }
2235 
2236     /**
2237       * @notice Sets a new comptroller for the market
2238       * @dev Admin function to set a new comptroller
2239       * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
2240       */
2241     function _setComptroller(ComptrollerInterface newComptroller) public returns (uint) {
2242         // Check caller is admin
2243         if (msg.sender != admin) {
2244             return fail(Error.UNAUTHORIZED, FailureInfo.SET_COMPTROLLER_OWNER_CHECK);
2245         }
2246 
2247         ComptrollerInterface oldComptroller = comptroller;
2248         // Ensure invoke comptroller.isComptroller() returns true
2249         require(newComptroller.isComptroller(), "marker method returned false");
2250 
2251         // Set market's comptroller to newComptroller
2252         comptroller = newComptroller;
2253 
2254         // Emit NewComptroller(oldComptroller, newComptroller)
2255         emit NewComptroller(oldComptroller, newComptroller);
2256 
2257         return uint(Error.NO_ERROR);
2258     }
2259 
2260     /**
2261       * @notice accrues interest and sets a new reserve factor for the protocol using _setReserveFactorFresh
2262       * @dev Admin function to accrue interest and set a new reserve factor
2263       * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
2264       */
2265     function _setReserveFactor(uint newReserveFactorMantissa) external nonReentrant returns (uint) {
2266         uint error = accrueInterest();
2267         if (error != uint(Error.NO_ERROR)) {
2268             // accrueInterest emits logs on errors, but on top of that we want to log the fact that an attempted reserve factor change failed.
2269             return fail(Error(error), FailureInfo.SET_RESERVE_FACTOR_ACCRUE_INTEREST_FAILED);
2270         }
2271         // _setReserveFactorFresh emits reserve-factor-specific logs on errors, so we don't need to.
2272         return _setReserveFactorFresh(newReserveFactorMantissa);
2273     }
2274 
2275     /**
2276       * @notice Sets a new reserve factor for the protocol (*requires fresh interest accrual)
2277       * @dev Admin function to set a new reserve factor
2278       * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
2279       */
2280     function _setReserveFactorFresh(uint newReserveFactorMantissa) internal returns (uint) {
2281         // Check caller is admin
2282         if (msg.sender != admin) {
2283             return fail(Error.UNAUTHORIZED, FailureInfo.SET_RESERVE_FACTOR_ADMIN_CHECK);
2284         }
2285 
2286         // Verify market's block number equals current block number
2287         if (accrualBlockNumber != getBlockNumber()) {
2288             return fail(Error.MARKET_NOT_FRESH, FailureInfo.SET_RESERVE_FACTOR_FRESH_CHECK);
2289         }
2290 
2291         // Check newReserveFactor ≤ maxReserveFactor
2292         if (newReserveFactorMantissa > reserveFactorMaxMantissa) {
2293             return fail(Error.BAD_INPUT, FailureInfo.SET_RESERVE_FACTOR_BOUNDS_CHECK);
2294         }
2295 
2296         uint oldReserveFactorMantissa = reserveFactorMantissa;
2297         reserveFactorMantissa = newReserveFactorMantissa;
2298 
2299         emit NewReserveFactor(oldReserveFactorMantissa, newReserveFactorMantissa);
2300 
2301         return uint(Error.NO_ERROR);
2302     }
2303 
2304     /**
2305      * @notice Accrues interest and reduces reserves by transferring from msg.sender
2306      * @param addAmount Amount of addition to reserves
2307      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
2308      */
2309     function _addReservesInternal(uint addAmount) internal nonReentrant returns (uint) {
2310         uint error = accrueInterest();
2311         if (error != uint(Error.NO_ERROR)) {
2312             // accrueInterest emits logs on errors, but on top of that we want to log the fact that an attempted reduce reserves failed.
2313             return fail(Error(error), FailureInfo.ADD_RESERVES_ACCRUE_INTEREST_FAILED);
2314         }
2315 
2316         // _addReservesFresh emits reserve-addition-specific logs on errors, so we don't need to.
2317         (error, ) = _addReservesFresh(addAmount);
2318         return error;
2319     }
2320 
2321     /**
2322      * @notice Add reserves by transferring from caller
2323      * @dev Requires fresh interest accrual
2324      * @param addAmount Amount of addition to reserves
2325      * @return (uint, uint) An error code (0=success, otherwise a failure (see ErrorReporter.sol for details)) and the actual amount added, net token fees
2326      */
2327     function _addReservesFresh(uint addAmount) internal returns (uint, uint) {
2328         // totalReserves + actualAddAmount
2329         uint totalReservesNew;
2330         uint actualAddAmount;
2331 
2332         // We fail gracefully unless market's block number equals current block number
2333         if (accrualBlockNumber != getBlockNumber()) {
2334             return (fail(Error.MARKET_NOT_FRESH, FailureInfo.ADD_RESERVES_FRESH_CHECK), actualAddAmount);
2335         }
2336 
2337         /* Fail if checkTransferIn fails */
2338         Error err = checkTransferIn(msg.sender, addAmount);
2339         if (err != Error.NO_ERROR) {
2340             return (fail(err, FailureInfo.ADD_RESERVES_TRANSFER_IN_NOT_POSSIBLE), actualAddAmount);
2341         }
2342 
2343 
2344         /////////////////////////
2345         // EFFECTS & INTERACTIONS
2346         // (No safe failures beyond this point)
2347 
2348         /* actualAddAmount=invoke doTransferIn(msg.sender, addAmount) */
2349         actualAddAmount = doTransferIn(msg.sender, addAmount);
2350 
2351         totalReservesNew = totalReserves + actualAddAmount;
2352 
2353         /* Revert on overflow */
2354         require(totalReservesNew >= totalReserves, "add reserves unexpected overflow");
2355 
2356         // Store reserves[n+1] = reserves[n] + actualAddAmount
2357         totalReserves = totalReservesNew;
2358 
2359         /* Emit NewReserves(admin, actualAddAmount, reserves[n+1]) */
2360         emit ReservesAdded(msg.sender, actualAddAmount, totalReservesNew);
2361 
2362         /* Return (NO_ERROR, actualAddAmount) */
2363         return (uint(Error.NO_ERROR), actualAddAmount);
2364     }
2365 
2366 
2367     /**
2368      * @notice Accrues interest and reduces reserves by transferring to admin
2369      * @param reduceAmount Amount of reduction to reserves
2370      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
2371      */
2372     function _reduceReserves(uint reduceAmount) external nonReentrant returns (uint) {
2373         uint error = accrueInterest();
2374         if (error != uint(Error.NO_ERROR)) {
2375             // accrueInterest emits logs on errors, but on top of that we want to log the fact that an attempted reduce reserves failed.
2376             return fail(Error(error), FailureInfo.REDUCE_RESERVES_ACCRUE_INTEREST_FAILED);
2377         }
2378         // _reduceReservesFresh emits reserve-reduction-specific logs on errors, so we don't need to.
2379         return _reduceReservesFresh(reduceAmount);
2380     }
2381 
2382     /**
2383      * @notice Reduces reserves by transferring to admin
2384      * @dev Requires fresh interest accrual
2385      * @param reduceAmount Amount of reduction to reserves
2386      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
2387      */
2388     function _reduceReservesFresh(uint reduceAmount) internal returns (uint) {
2389         // totalReserves - reduceAmount
2390         uint totalReservesNew;
2391 
2392         // Check caller is admin
2393         if (msg.sender != admin) {
2394             return fail(Error.UNAUTHORIZED, FailureInfo.REDUCE_RESERVES_ADMIN_CHECK);
2395         }
2396 
2397         // We fail gracefully unless market's block number equals current block number
2398         if (accrualBlockNumber != getBlockNumber()) {
2399             return fail(Error.MARKET_NOT_FRESH, FailureInfo.REDUCE_RESERVES_FRESH_CHECK);
2400         }
2401 
2402         // Fail gracefully if protocol has insufficient underlying cash
2403         if (getCashPrior() < reduceAmount) {
2404             return fail(Error.TOKEN_INSUFFICIENT_CASH, FailureInfo.REDUCE_RESERVES_CASH_NOT_AVAILABLE);
2405         }
2406 
2407         // Check reduceAmount ≤ reserves[n] (totalReserves)
2408         if (reduceAmount > totalReserves) {
2409             return fail(Error.BAD_INPUT, FailureInfo.REDUCE_RESERVES_VALIDATION);
2410         }
2411 
2412         /////////////////////////
2413         // EFFECTS & INTERACTIONS
2414         // (No safe failures beyond this point)
2415 
2416         totalReservesNew = totalReserves - reduceAmount;
2417         // We checked reduceAmount <= totalReserves above, so this should never revert.
2418         require(totalReservesNew <= totalReserves, "reduce reserves unexpected underflow");
2419 
2420         // Store reserves[n+1] = reserves[n] - reduceAmount
2421         totalReserves = totalReservesNew;
2422 
2423         // doTransferOut reverts if anything goes wrong, since we can't be sure if side effects occurred.
2424         doTransferOut(admin, reduceAmount);
2425 
2426         emit ReservesReduced(admin, reduceAmount, totalReservesNew);
2427 
2428         return uint(Error.NO_ERROR);
2429     }
2430 
2431     /**
2432      * @notice accrues interest and updates the interest rate model using _setInterestRateModelFresh
2433      * @dev Admin function to accrue interest and update the interest rate model
2434      * @param newInterestRateModel the new interest rate model to use
2435      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
2436      */
2437     function _setInterestRateModel(InterestRateModel newInterestRateModel) public returns (uint) {
2438         uint error = accrueInterest();
2439         if (error != uint(Error.NO_ERROR)) {
2440             // accrueInterest emits logs on errors, but on top of that we want to log the fact that an attempted increase of interest rate model failed
2441             return fail(Error(error), FailureInfo.SET_INTEREST_RATE_MODEL_ACCRUE_INTEREST_FAILED);
2442         }
2443         // _setInterestRateModelFresh emits interest-rate-model-update-specific logs on errors, so we don't need to.
2444         return _setInterestRateModelFresh(newInterestRateModel);
2445     }
2446 
2447     /**
2448      * @notice updates the interest rate model (*requires fresh interest accrual)
2449      * @dev Admin function to update the interest rate model
2450      * @param newInterestRateModel the new interest rate model to use
2451      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
2452      */
2453     function _setInterestRateModelFresh(InterestRateModel newInterestRateModel) internal returns (uint) {
2454 
2455         // Used to store old model for use in the event that is emitted on success
2456         InterestRateModel oldInterestRateModel;
2457 
2458         // Check caller is admin
2459         if (msg.sender != admin) {
2460             return fail(Error.UNAUTHORIZED, FailureInfo.SET_INTEREST_RATE_MODEL_OWNER_CHECK);
2461         }
2462 
2463         // We fail gracefully unless market's block number equals current block number
2464         if (accrualBlockNumber != getBlockNumber()) {
2465             return fail(Error.MARKET_NOT_FRESH, FailureInfo.SET_INTEREST_RATE_MODEL_FRESH_CHECK);
2466         }
2467 
2468         // Track the market's current interest rate model
2469         oldInterestRateModel = interestRateModel;
2470 
2471         // Ensure invoke newInterestRateModel.isInterestRateModel() returns true
2472         require(newInterestRateModel.isInterestRateModel(), "marker method returned false");
2473 
2474         // Set the interest rate model to newInterestRateModel
2475         interestRateModel = newInterestRateModel;
2476 
2477         // Emit NewMarketInterestRateModel(oldInterestRateModel, newInterestRateModel)
2478         emit NewMarketInterestRateModel(oldInterestRateModel, newInterestRateModel);
2479 
2480         return uint(Error.NO_ERROR);
2481     }
2482 
2483     /*** Safe Token ***/
2484 
2485     /**
2486      * @notice Gets balance of this contract in terms of the underlying
2487      * @dev This excludes the value of the current message, if any
2488      * @return The quantity of underlying owned by this contract
2489      */
2490     function getCashPrior() internal view returns (uint);
2491 
2492     /**
2493      * @dev Checks whether or not there is sufficient allowance for this contract to move amount from `from` and
2494      *      whether or not `from` has a balance of at least `amount`. Does NOT do a transfer.
2495      */
2496     function checkTransferIn(address from, uint amount) internal view returns (Error);
2497 
2498     /**
2499      * @dev Performs a transfer in, reverting upon failure. Returns the amount actually transferred to the protocol, in case of a fee.
2500      *  If caller has not called `checkTransferIn`, this may revert due to insufficient balance or insufficient allowance.
2501      *  If caller has called `checkTransferIn` successfully, this should not revert in normal conditions.
2502      */
2503     function doTransferIn(address from, uint amount) internal returns (uint);
2504 
2505     /**
2506      * @dev Performs a transfer out, ideally returning an explanatory error code upon failure tather than reverting.
2507      *  If caller has not called checked protocol's balance, may revert due to insufficient cash held in the contract.
2508      *  If caller has checked protocol's balance, and verified it is >= amount, this should not revert in normal conditions.
2509      */
2510     function doTransferOut(address payable to, uint amount) internal;
2511 
2512 
2513     /*** Reentrancy Guard ***/
2514 
2515     /**
2516      * @dev Prevents a contract from calling itself, directly or indirectly.
2517      */
2518     modifier nonReentrant() {
2519         require(_notEntered, "re-entered");
2520         _notEntered = false;
2521         _;
2522         _notEntered = true; // get a gas-refund post-Istanbul
2523     }
2524 }
2525 
2526 // File: contracts/CErc20.sol
2527 
2528 pragma solidity ^0.5.12;
2529 
2530 
2531 /**
2532  * @title Compound's CErc20 Contract
2533  * @notice CTokens which wrap an EIP-20 underlying
2534  * @author Compound
2535  */
2536 contract CErc20 is CToken, CErc20Interface {
2537     /**
2538      * @notice Initialize the new money market
2539      * @param underlying_ The address of the underlying asset
2540      * @param comptroller_ The address of the Comptroller
2541      * @param interestRateModel_ The address of the interest rate model
2542      * @param initialExchangeRateMantissa_ The initial exchange rate, scaled by 1e18
2543      * @param name_ ERC-20 name of this token
2544      * @param symbol_ ERC-20 symbol of this token
2545      * @param decimals_ ERC-20 decimal precision of this token
2546      */
2547     function initialize(address underlying_,
2548                         ComptrollerInterface comptroller_,
2549                         InterestRateModel interestRateModel_,
2550                         uint initialExchangeRateMantissa_,
2551                         string memory name_,
2552                         string memory symbol_,
2553                         uint8 decimals_) public {
2554         // CToken initialize does the bulk of the work
2555         super.initialize(comptroller_, interestRateModel_, initialExchangeRateMantissa_, name_, symbol_, decimals_);
2556 
2557         // Set underlying and sanity check it
2558         underlying = underlying_;
2559         EIP20Interface(underlying).totalSupply();
2560     }
2561 
2562     /*** User Interface ***/
2563 
2564     /**
2565      * @notice Sender supplies assets into the market and receives cTokens in exchange
2566      * @dev Accrues interest whether or not the operation succeeds, unless reverted
2567      * @param mintAmount The amount of the underlying asset to supply
2568      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
2569      */
2570     function mint(uint mintAmount) external returns (uint) {
2571         (uint err,) = mintInternal(mintAmount);
2572         return err;
2573     }
2574 
2575     /**
2576      * @notice Sender redeems cTokens in exchange for the underlying asset
2577      * @dev Accrues interest whether or not the operation succeeds, unless reverted
2578      * @param redeemTokens The number of cTokens to redeem into underlying
2579      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
2580      */
2581     function redeem(uint redeemTokens) external returns (uint) {
2582         return redeemInternal(redeemTokens);
2583     }
2584 
2585     /**
2586      * @notice Sender redeems cTokens in exchange for a specified amount of underlying asset
2587      * @dev Accrues interest whether or not the operation succeeds, unless reverted
2588      * @param redeemAmount The amount of underlying to redeem
2589      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
2590      */
2591     function redeemUnderlying(uint redeemAmount) external returns (uint) {
2592         return redeemUnderlyingInternal(redeemAmount);
2593     }
2594 
2595     /**
2596       * @notice Sender borrows assets from the protocol to their own address
2597       * @param borrowAmount The amount of the underlying asset to borrow
2598       * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
2599       */
2600     function borrow(uint borrowAmount) external returns (uint) {
2601         return borrowInternal(borrowAmount);
2602     }
2603 
2604     /**
2605      * @notice Sender repays their own borrow
2606      * @param repayAmount The amount to repay
2607      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
2608      */
2609     function repayBorrow(uint repayAmount) external returns (uint) {
2610         (uint err,) = repayBorrowInternal(repayAmount);
2611         return err;
2612     }
2613 
2614     /**
2615      * @notice Sender repays a borrow belonging to borrower
2616      * @param borrower the account with the debt being payed off
2617      * @param repayAmount The amount to repay
2618      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
2619      */
2620     function repayBorrowBehalf(address borrower, uint repayAmount) external returns (uint) {
2621         (uint err,) = repayBorrowBehalfInternal(borrower, repayAmount);
2622         return err;
2623     }
2624 
2625     /**
2626      * @notice The sender liquidates the borrowers collateral.
2627      *  The collateral seized is transferred to the liquidator.
2628      * @param borrower The borrower of this cToken to be liquidated
2629      * @param repayAmount The amount of the underlying borrowed asset to repay
2630      * @param cTokenCollateral The market in which to seize collateral from the borrower
2631      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
2632      */
2633     function liquidateBorrow(address borrower, uint repayAmount, CTokenInterface cTokenCollateral) external returns (uint) {
2634         (uint err,) = liquidateBorrowInternal(borrower, repayAmount, cTokenCollateral);
2635         return err;
2636     }
2637 
2638     /**
2639      * @notice The sender adds to reserves.
2640      * @param addAmount The amount fo underlying token to add as reserves
2641      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
2642      */
2643     function _addReserves(uint addAmount) external returns (uint) {
2644         return _addReservesInternal(addAmount);
2645     }
2646 
2647     /*** Safe Token ***/
2648 
2649     /**
2650      * @notice Gets balance of this contract in terms of the underlying
2651      * @dev This excludes the value of the current message, if any
2652      * @return The quantity of underlying tokens owned by this contract
2653      */
2654     function getCashPrior() internal view returns (uint) {
2655         EIP20Interface token = EIP20Interface(underlying);
2656         return token.balanceOf(address(this));
2657     }
2658 
2659     /**
2660      * @dev Checks whether or not there is sufficient allowance for this contract to move amount from `from` and
2661      *      whether or not `from` has a balance of at least `amount`. Does NOT do a transfer.
2662      */
2663     function checkTransferIn(address from, uint amount) internal view returns (Error) {
2664         EIP20Interface token = EIP20Interface(underlying);
2665 
2666         if (token.allowance(from, address(this)) < amount) {
2667             return Error.TOKEN_INSUFFICIENT_ALLOWANCE;
2668         }
2669 
2670         if (token.balanceOf(from) < amount) {
2671             return Error.TOKEN_INSUFFICIENT_BALANCE;
2672         }
2673 
2674         return Error.NO_ERROR;
2675     }
2676 
2677     /**
2678      * @dev Similar to EIP20 transfer, except it handles a False result from `transferFrom` reverts in that case.
2679      *      If caller has not called `checkTransferIn`, this may revert due to insufficient balance or insufficient
2680      *      allowance. If caller has called `checkTransferIn` prior to this call, and it returned Error.NO_ERROR,
2681      *      this should not revert in normal conditions. This function returns the actual amount received,
2682      *      with may be less than `amount` if there is a fee attached with the transfer.
2683      *
2684      *      Note: This wrapper safely handles non-standard ERC-20 tokens that do not return a value.
2685      *            See here: https://medium.com/coinmonks/missing-return-value-bug-at-least-130-tokens-affected-d67bf08521ca
2686      */
2687     function doTransferIn(address from, uint amount) internal returns (uint) {
2688         EIP20NonStandardInterface token = EIP20NonStandardInterface(underlying);
2689         uint balanceBefore = EIP20Interface(underlying).balanceOf(address(this));
2690         token.transferFrom(from, address(this), amount);
2691 
2692         bool success;
2693         assembly {
2694             switch returndatasize()
2695                 case 0 {                       // This is a non-standard ERC-20
2696                     success := not(0)          // set success to true
2697                 }
2698                 case 32 {                      // This is a compliant ERC-20
2699                     returndatacopy(0, 0, 32)
2700                     success := mload(0)        // Set `success = returndata` of external call
2701                 }
2702                 default {                      // This is an excessively non-compliant ERC-20, revert.
2703                     revert(0, 0)
2704                 }
2705         }
2706         require(success, "TOKEN_TRANSFER_IN_FAILED");
2707 
2708         // Calculate the amount that was *actually* transferred
2709         uint balanceAfter = EIP20Interface(underlying).balanceOf(address(this));
2710         require(balanceAfter >= balanceBefore, "TOKEN_TRANSFER_IN_OVERFLOW");
2711         return balanceAfter - balanceBefore;   // underflow already checked above, just subtract
2712     }
2713 
2714     /**
2715      * @dev Similar to EIP20 transfer, except it handles a False success from `transfer` and returns an explanatory
2716      *      error code rather than reverting. If caller has not called checked protocol's balance, this may revert due to
2717      *      insufficient cash held in this contract. If caller has checked protocol's balance prior to this call, and verified
2718      *      it is >= amount, this should not revert in normal conditions.
2719      *
2720      *      Note: This wrapper safely handles non-standard ERC-20 tokens that do not return a value.
2721      *            See here: https://medium.com/coinmonks/missing-return-value-bug-at-least-130-tokens-affected-d67bf08521ca
2722      */
2723     function doTransferOut(address payable to, uint amount) internal {
2724         EIP20NonStandardInterface token = EIP20NonStandardInterface(underlying);
2725         token.transfer(to, amount);
2726 
2727         bool success;
2728         assembly {
2729             switch returndatasize()
2730                 case 0 {                      // This is a non-standard ERC-20
2731                     success := not(0)          // set success to true
2732                 }
2733                 case 32 {                     // This is a complaint ERC-20
2734                     returndatacopy(0, 0, 32)
2735                     success := mload(0)        // Set `success = returndata` of external call
2736                 }
2737                 default {                     // This is an excessively non-compliant ERC-20, revert.
2738                     revert(0, 0)
2739                 }
2740         }
2741         require(success, "TOKEN_TRANSFER_OUT_FAILED");
2742     }
2743 }
2744 
2745 // File: contracts/CErc20Immutable.sol
2746 
2747 pragma solidity ^0.5.12;
2748 
2749 
2750 /**
2751  * @title Compound's CErc20Immutable Contract
2752  * @notice CTokens which wrap an EIP-20 underlying and are immutable
2753  * @author Compound
2754  */
2755 contract CErc20Immutable is CErc20 {
2756     /**
2757      * @notice Construct a new money market
2758      * @param underlying_ The address of the underlying asset
2759      * @param comptroller_ The address of the Comptroller
2760      * @param interestRateModel_ The address of the interest rate model
2761      * @param initialExchangeRateMantissa_ The initial exchange rate, scaled by 1e18
2762      * @param name_ ERC-20 name of this token
2763      * @param symbol_ ERC-20 symbol of this token
2764      * @param decimals_ ERC-20 decimal precision of this token
2765      * @param admin_ Address of the administrator of this token
2766      */
2767     constructor(address underlying_,
2768                 ComptrollerInterface comptroller_,
2769                 InterestRateModel interestRateModel_,
2770                 uint initialExchangeRateMantissa_,
2771                 string memory name_,
2772                 string memory symbol_,
2773                 uint8 decimals_,
2774                 address payable admin_) public {
2775         // Creator of the contract is admin during initialization
2776         admin = msg.sender;
2777 
2778         // Initialize the market
2779         initialize(underlying_, comptroller_, interestRateModel_, initialExchangeRateMantissa_, name_, symbol_, decimals_);
2780 
2781         // Set the proper admin now that initialization is done
2782         admin = admin_;
2783     }
2784 }