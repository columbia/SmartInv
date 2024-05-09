1 pragma solidity ^0.5.16;
2 
3 /**
4   * @title Artem ERC-20 Contract
5   * @notice Derived from Compound's cERC20 contract
6   * https://github.com/compound-finance/compound-protocol/tree/master/contracts
7   */
8 
9 /**
10   * @title Careful Math
11   * @notice Derived from OpenZeppelin's SafeMath library
12   *         https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/math/SafeMath.sol
13   */
14 contract CarefulMath {
15 
16     enum MathError {
17         NO_ERROR,
18         DIVISION_BY_ZERO,
19         INTEGER_OVERFLOW,
20         INTEGER_UNDERFLOW
21     }
22 
23     /**
24     * @dev Multiplies two numbers, returns an error on overflow.
25     */
26     function mulUInt(uint a, uint b) internal pure returns (MathError, uint) {
27         if (a == 0) {
28             return (MathError.NO_ERROR, 0);
29         }
30 
31         uint c = a * b;
32 
33         if (c / a != b) {
34             return (MathError.INTEGER_OVERFLOW, 0);
35         } else {
36             return (MathError.NO_ERROR, c);
37         }
38     }
39 
40     /**
41     * @dev Integer division of two numbers, truncating the quotient.
42     */
43     function divUInt(uint a, uint b) internal pure returns (MathError, uint) {
44         if (b == 0) {
45             return (MathError.DIVISION_BY_ZERO, 0);
46         }
47 
48         return (MathError.NO_ERROR, a / b);
49     }
50 
51     /**
52     * @dev Subtracts two numbers, returns an error on overflow (i.e. if subtrahend is greater than minuend).
53     */
54     function subUInt(uint a, uint b) internal pure returns (MathError, uint) {
55         if (b <= a) {
56             return (MathError.NO_ERROR, a - b);
57         } else {
58             return (MathError.INTEGER_UNDERFLOW, 0);
59         }
60     }
61 
62     /**
63     * @dev Adds two numbers, returns an error on overflow.
64     */
65     function addUInt(uint a, uint b) internal pure returns (MathError, uint) {
66         uint c = a + b;
67 
68         if (c >= a) {
69             return (MathError.NO_ERROR, c);
70         } else {
71             return (MathError.INTEGER_OVERFLOW, 0);
72         }
73     }
74 
75     /**
76     * @dev add a and b and then subtract c
77     */
78     function addThenSubUInt(uint a, uint b, uint c) internal pure returns (MathError, uint) {
79         (MathError err0, uint sum) = addUInt(a, b);
80 
81         if (err0 != MathError.NO_ERROR) {
82             return (err0, 0);
83         }
84 
85         return subUInt(sum, c);
86     }
87 }
88 
89 interface ControllerInterface {
90 
91     function isController() external view returns (bool);
92 
93     function enterMarkets(address[] calldata aTokens) external returns (uint[] memory);
94     function exitMarket(address aToken) external returns (uint);
95 
96     function mintAllowed(address aToken, address minter, uint mintAmount) external returns (uint);
97     function mintVerify(address aToken, address minter, uint mintAmount, uint mintTokens) external;
98 
99     function redeemAllowed(address aToken, address redeemer, uint redeemTokens) external returns (uint);
100     function redeemVerify(address aToken, address redeemer, uint redeemAmount, uint redeemTokens) external;
101 
102     function borrowAllowed(address aToken, address borrower, uint borrowAmount) external returns (uint);
103     function borrowVerify(address aToken, address borrower, uint borrowAmount) external;
104 
105     function repayBorrowAllowed(
106         address aToken,
107         address payer,
108         address borrower,
109         uint repayAmount) external returns (uint);
110         
111     function repayBorrowVerify(
112         address aToken,
113         address payer,
114         address borrower,
115         uint repayAmount,
116         uint borrowerIndex) external;
117 
118     function liquidateBorrowAllowed(
119         address aTokenBorrowed,
120         address aTokenCollateral,
121         address liquidator,
122         address borrower,
123         uint repayAmount) external returns (uint);
124         
125     function liquidateBorrowVerify(
126         address aTokenBorrowed,
127         address aTokenCollateral,
128         address liquidator,
129         address borrower,
130         uint repayAmount,
131         uint seizeTokens) external;
132 
133     function seizeAllowed(
134         address aTokenCollateral,
135         address aTokenBorrowed,
136         address liquidator,
137         address borrower,
138         uint seizeTokens) external returns (uint);
139         
140     function seizeVerify(
141         address aTokenCollateral,
142         address aTokenBorrowed,
143         address liquidator,
144         address borrower,
145         uint seizeTokens) external;
146 
147     function transferAllowed(address aToken, address src, address dst, uint transferTokens) external returns (uint);
148     function transferVerify(address aToken, address src, address dst, uint transferTokens) external;
149 
150     /*** Liquidity/Liquidation Calculations ***/
151 
152     function liquidateCalculateSeizeTokens(
153         address aTokenBorrowed,
154         address aTokenCollateral,
155         uint repayAmount) external view returns (uint, uint);
156 }
157 
158 
159 contract ControllerErrorReporter {
160 
161     event Failure(uint error, uint info, uint detail);
162 
163 
164     function fail(Error err, FailureInfo info) internal returns (uint) {
165         emit Failure(uint(err), uint(info), 0);
166 
167         return uint(err);
168     }
169 
170     function failOpaque(Error err, FailureInfo info, uint opaqueError) internal returns (uint) {
171         emit Failure(uint(err), uint(info), opaqueError);
172 
173         return uint(err);
174     }
175     
176     enum Error {
177         NO_ERROR,
178         UNAUTHORIZED,
179         CONTROLLER_MISMATCH,
180         INSUFFICIENT_SHORTFALL,
181         INSUFFICIENT_LIQUIDITY,
182         INVALID_CLOSE_FACTOR,
183         INVALID_COLLATERAL_FACTOR,
184         INVALID_LIQUIDATION_INCENTIVE,
185         MARKET_NOT_ENTERED,
186         MARKET_NOT_LISTED,
187         MARKET_ALREADY_LISTED,
188         MATH_ERROR,
189         NONZERO_BORROW_BALANCE,
190         PRICE_ERROR,
191         REJECTION,
192         SNAPSHOT_ERROR,
193         TOO_MANY_ASSETS,
194         TOO_MUCH_REPAY
195     }
196 
197     enum FailureInfo {
198         ACCEPT_ADMIN_PENDING_ADMIN_CHECK,
199         ACCEPT_PENDING_IMPLEMENTATION_ADDRESS_CHECK,
200         EXIT_MARKET_BALANCE_OWED,
201         EXIT_MARKET_REJECTION,
202         SET_CLOSE_FACTOR_OWNER_CHECK,
203         SET_CLOSE_FACTOR_VALIDATION,
204         SET_COLLATERAL_FACTOR_OWNER_CHECK,
205         SET_COLLATERAL_FACTOR_NO_EXISTS,
206         SET_COLLATERAL_FACTOR_VALIDATION,
207         SET_COLLATERAL_FACTOR_WITHOUT_PRICE,
208         SET_IMPLEMENTATION_OWNER_CHECK,
209         SET_LIQUIDATION_INCENTIVE_OWNER_CHECK,
210         SET_LIQUIDATION_INCENTIVE_VALIDATION,
211         SET_MAX_ASSETS_OWNER_CHECK,
212         SET_PENDING_ADMIN_OWNER_CHECK,
213         SET_PENDING_IMPLEMENTATION_OWNER_CHECK,
214         SET_PRICE_ORACLE_OWNER_CHECK,
215         SUPPORT_MARKET_EXISTS,
216         SUPPORT_MARKET_OWNER_CHECK,
217         ZUNUSED
218     }
219 
220     
221 }
222 
223 contract TokenErrorReporter {
224 
225     event Failure(uint error, uint info, uint detail);
226 
227     function fail(Error err, FailureInfo info) internal returns (uint) {
228         emit Failure(uint(err), uint(info), 0);
229 
230         return uint(err);
231     }
232 
233     function failOpaque(Error err, FailureInfo info, uint opaqueError) internal returns (uint) {
234         emit Failure(uint(err), uint(info), opaqueError);
235 
236         return uint(err);
237     }
238     
239     enum Error {
240         NO_ERROR,
241         UNAUTHORIZED,
242         BAD_INPUT,
243         CONTROLLER_REJECTION,
244         CONTROLLER_CALCULATION_ERROR,
245         INTEREST_RATE_MODEL_ERROR,
246         INVALID_ACCOUNT_PAIR,
247         INVALID_CLOSE_AMOUNT_REQUESTED,
248         INVALID_COLLATERAL_FACTOR,
249         MATH_ERROR,
250         MARKET_NOT_FRESH,
251         MARKET_NOT_LISTED,
252         TOKEN_INSUFFICIENT_ALLOWANCE,
253         TOKEN_INSUFFICIENT_BALANCE,
254         TOKEN_INSUFFICIENT_CASH,
255         TOKEN_TRANSFER_IN_FAILED,
256         TOKEN_TRANSFER_OUT_FAILED
257     }
258 
259 
260     enum FailureInfo {
261         ACCEPT_ADMIN_PENDING_ADMIN_CHECK,
262         ACCRUE_INTEREST_ACCUMULATED_INTEREST_CALCULATION_FAILED,
263         ACCRUE_INTEREST_BORROW_RATE_CALCULATION_FAILED,
264         ACCRUE_INTEREST_NEW_BORROW_INDEX_CALCULATION_FAILED,
265         ACCRUE_INTEREST_NEW_TOTAL_BORROWS_CALCULATION_FAILED,
266         ACCRUE_INTEREST_NEW_TOTAL_RESERVES_CALCULATION_FAILED,
267         ACCRUE_INTEREST_SIMPLE_INTEREST_FACTOR_CALCULATION_FAILED,
268         BORROW_ACCUMULATED_BALANCE_CALCULATION_FAILED,
269         BORROW_ACCRUE_INTEREST_FAILED,
270         BORROW_CASH_NOT_AVAILABLE,
271         BORROW_FRESHNESS_CHECK,
272         BORROW_NEW_TOTAL_BALANCE_CALCULATION_FAILED,
273         BORROW_NEW_ACCOUNT_BORROW_BALANCE_CALCULATION_FAILED,
274         BORROW_MARKET_NOT_LISTED,
275         BORROW_CONTROLLER_REJECTION,
276         LIQUIDATE_ACCRUE_BORROW_INTEREST_FAILED,
277         LIQUIDATE_ACCRUE_COLLATERAL_INTEREST_FAILED,
278         LIQUIDATE_COLLATERAL_FRESHNESS_CHECK,
279         LIQUIDATE_CONTROLLER_REJECTION,
280         LIQUIDATE_CONTROLLER_CALCULATE_AMOUNT_SEIZE_FAILED,
281         LIQUIDATE_CLOSE_AMOUNT_IS_UINT_MAX,
282         LIQUIDATE_CLOSE_AMOUNT_IS_ZERO,
283         LIQUIDATE_FRESHNESS_CHECK,
284         LIQUIDATE_LIQUIDATOR_IS_BORROWER,
285         LIQUIDATE_REPAY_BORROW_FRESH_FAILED,
286         LIQUIDATE_SEIZE_BALANCE_INCREMENT_FAILED,
287         LIQUIDATE_SEIZE_BALANCE_DECREMENT_FAILED,
288         LIQUIDATE_SEIZE_CONTROLLER_REJECTION,
289         LIQUIDATE_SEIZE_LIQUIDATOR_IS_BORROWER,
290         LIQUIDATE_SEIZE_TOO_MUCH,
291         MINT_ACCRUE_INTEREST_FAILED,
292         MINT_CONTROLLER_REJECTION,
293         MINT_EXCHANGE_CALCULATION_FAILED,
294         MINT_EXCHANGE_RATE_READ_FAILED,
295         MINT_FRESHNESS_CHECK,
296         MINT_NEW_ACCOUNT_BALANCE_CALCULATION_FAILED,
297         MINT_NEW_TOTAL_SUPPLY_CALCULATION_FAILED,
298         MINT_TRANSFER_IN_FAILED,
299         MINT_TRANSFER_IN_NOT_POSSIBLE,
300         REDEEM_ACCRUE_INTEREST_FAILED,
301         REDEEM_CONTROLLER_REJECTION,
302         REDEEM_EXCHANGE_TOKENS_CALCULATION_FAILED,
303         REDEEM_EXCHANGE_AMOUNT_CALCULATION_FAILED,
304         REDEEM_EXCHANGE_RATE_READ_FAILED,
305         REDEEM_FRESHNESS_CHECK,
306         REDEEM_NEW_ACCOUNT_BALANCE_CALCULATION_FAILED,
307         REDEEM_NEW_TOTAL_SUPPLY_CALCULATION_FAILED,
308         REDEEM_TRANSFER_OUT_NOT_POSSIBLE,
309         REDUCE_RESERVES_ACCRUE_INTEREST_FAILED,
310         REDUCE_RESERVES_ADMIN_CHECK,
311         REDUCE_RESERVES_CASH_NOT_AVAILABLE,
312         REDUCE_RESERVES_FRESH_CHECK,
313         REDUCE_RESERVES_VALIDATION,
314         REPAY_BEHALF_ACCRUE_INTEREST_FAILED,
315         REPAY_BORROW_ACCRUE_INTEREST_FAILED,
316         REPAY_BORROW_ACCUMULATED_BALANCE_CALCULATION_FAILED,
317         REPAY_BORROW_CONTROLLER_REJECTION,
318         REPAY_BORROW_FRESHNESS_CHECK,
319         REPAY_BORROW_NEW_ACCOUNT_BORROW_BALANCE_CALCULATION_FAILED,
320         REPAY_BORROW_NEW_TOTAL_BALANCE_CALCULATION_FAILED,
321         REPAY_BORROW_TRANSFER_IN_NOT_POSSIBLE,
322         SET_COLLATERAL_FACTOR_OWNER_CHECK,
323         SET_COLLATERAL_FACTOR_VALIDATION,
324         SET_CONTROLLER_OWNER_CHECK,
325         SET_INTEREST_RATE_MODEL_ACCRUE_INTEREST_FAILED,
326         SET_INTEREST_RATE_MODEL_FRESH_CHECK,
327         SET_INTEREST_RATE_MODEL_OWNER_CHECK,
328         SET_MAX_ASSETS_OWNER_CHECK,
329         SET_ORACLE_MARKET_NOT_LISTED,
330         SET_PENDING_ADMIN_OWNER_CHECK,
331         SET_RESERVE_FACTOR_ACCRUE_INTEREST_FAILED,
332         SET_RESERVE_FACTOR_ADMIN_CHECK,
333         SET_RESERVE_FACTOR_FRESH_CHECK,
334         SET_RESERVE_FACTOR_BOUNDS_CHECK,
335         TRANSFER_CONTROLLER_REJECTION,
336         TRANSFER_NOT_ALLOWED,
337         TRANSFER_NOT_ENOUGH,
338         TRANSFER_TOO_MUCH
339     }
340 
341 
342 }
343 
344 
345 contract Exponential is CarefulMath {
346     uint constant expScale = 1e18;
347     uint constant halfExpScale = expScale/2;
348     uint constant mantissaOne = expScale;
349 
350     struct Exp {
351         uint mantissa;
352     }
353 
354     function getExp(uint num, uint denom) pure internal returns (MathError, Exp memory) {
355         (MathError err0, uint scaledNumerator) = mulUInt(num, expScale);
356         if (err0 != MathError.NO_ERROR) {
357             return (err0, Exp({mantissa: 0}));
358         }
359 
360         (MathError err1, uint rational) = divUInt(scaledNumerator, denom);
361         if (err1 != MathError.NO_ERROR) {
362             return (err1, Exp({mantissa: 0}));
363         }
364 
365         return (MathError.NO_ERROR, Exp({mantissa: rational}));
366     }
367 
368     function addExp(Exp memory a, Exp memory b) pure internal returns (MathError, Exp memory) {
369         (MathError error, uint result) = addUInt(a.mantissa, b.mantissa);
370 
371         return (error, Exp({mantissa: result}));
372     }
373 
374     function subExp(Exp memory a, Exp memory b) pure internal returns (MathError, Exp memory) {
375         (MathError error, uint result) = subUInt(a.mantissa, b.mantissa);
376 
377         return (error, Exp({mantissa: result}));
378     }
379 
380     function mulScalar(Exp memory a, uint scalar) pure internal returns (MathError, Exp memory) {
381         (MathError err0, uint scaledMantissa) = mulUInt(a.mantissa, scalar);
382         if (err0 != MathError.NO_ERROR) {
383             return (err0, Exp({mantissa: 0}));
384         }
385 
386         return (MathError.NO_ERROR, Exp({mantissa: scaledMantissa}));
387     }
388 
389     function mulScalarTruncate(Exp memory a, uint scalar) pure internal returns (MathError, uint) {
390         (MathError err, Exp memory product) = mulScalar(a, scalar);
391         if (err != MathError.NO_ERROR) {
392             return (err, 0);
393         }
394 
395         return (MathError.NO_ERROR, truncate(product));
396     }
397 
398     function mulScalarTruncateAddUInt(Exp memory a, uint scalar, uint addend) pure internal returns (MathError, uint) {
399         (MathError err, Exp memory product) = mulScalar(a, scalar);
400         if (err != MathError.NO_ERROR) {
401             return (err, 0);
402         }
403 
404         return addUInt(truncate(product), addend);
405     }
406 
407     function divScalar(Exp memory a, uint scalar) pure internal returns (MathError, Exp memory) {
408         (MathError err0, uint descaledMantissa) = divUInt(a.mantissa, scalar);
409         if (err0 != MathError.NO_ERROR) {
410             return (err0, Exp({mantissa: 0}));
411         }
412 
413         return (MathError.NO_ERROR, Exp({mantissa: descaledMantissa}));
414     }
415 
416     function divScalarByExp(uint scalar, Exp memory divisor) pure internal returns (MathError, Exp memory) {
417         /*
418           We are doing this as:
419           getExp(mulUInt(expScale, scalar), divisor.mantissa)
420 
421           How it works:
422           Exp = a / b;
423           Scalar = s;
424           `s / (a / b)` = `b * s / a` and since for an Exp `a = mantissa, b = expScale`
425         */
426         (MathError err0, uint numerator) = mulUInt(expScale, scalar);
427         if (err0 != MathError.NO_ERROR) {
428             return (err0, Exp({mantissa: 0}));
429         }
430         return getExp(numerator, divisor.mantissa);
431     }
432 
433     function divScalarByExpTruncate(uint scalar, Exp memory divisor) pure internal returns (MathError, uint) {
434         (MathError err, Exp memory fraction) = divScalarByExp(scalar, divisor);
435         if (err != MathError.NO_ERROR) {
436             return (err, 0);
437         }
438 
439         return (MathError.NO_ERROR, truncate(fraction));
440     }
441 
442     function mulExp(Exp memory a, Exp memory b) pure internal returns (MathError, Exp memory) {
443 
444         (MathError err0, uint doubleScaledProduct) = mulUInt(a.mantissa, b.mantissa);
445         if (err0 != MathError.NO_ERROR) {
446             return (err0, Exp({mantissa: 0}));
447         }
448 
449         // We add half the scale before dividing so that we get rounding instead of truncation.
450         //  See "Listing 6" and text above it at https://accu.org/index.php/journals/1717
451         // Without this change, a result like 6.6...e-19 will be truncated to 0 instead of being rounded to 1e-18.
452         (MathError err1, uint doubleScaledProductWithHalfScale) = addUInt(halfExpScale, doubleScaledProduct);
453         if (err1 != MathError.NO_ERROR) {
454             return (err1, Exp({mantissa: 0}));
455         }
456 
457         (MathError err2, uint product) = divUInt(doubleScaledProductWithHalfScale, expScale);
458         // The only error `div` can return is MathError.DIVISION_BY_ZERO but we control `expScale` and it is not zero.
459         assert(err2 == MathError.NO_ERROR);
460 
461         return (MathError.NO_ERROR, Exp({mantissa: product}));
462     }
463 
464     function mulExp(uint a, uint b) pure internal returns (MathError, Exp memory) {
465         return mulExp(Exp({mantissa: a}), Exp({mantissa: b}));
466     }
467 
468     function mulExp3(Exp memory a, Exp memory b, Exp memory c) pure internal returns (MathError, Exp memory) {
469         (MathError err, Exp memory ab) = mulExp(a, b);
470         if (err != MathError.NO_ERROR) {
471             return (err, ab);
472         }
473         return mulExp(ab, c);
474     }
475 
476     function divExp(Exp memory a, Exp memory b) pure internal returns (MathError, Exp memory) {
477         return getExp(a.mantissa, b.mantissa);
478     }
479 
480     function truncate(Exp memory exp) pure internal returns (uint) {
481         // Note: We are not using careful math here as we're performing a division that cannot fail
482         return exp.mantissa / expScale;
483     }
484 
485     function lessThanExp(Exp memory left, Exp memory right) pure internal returns (bool) {
486         return left.mantissa < right.mantissa; //TODO: Add some simple tests and this in another PR yo.
487     }
488 
489     function lessThanOrEqualExp(Exp memory left, Exp memory right) pure internal returns (bool) {
490         return left.mantissa <= right.mantissa;
491     }
492 
493     function isZeroExp(Exp memory value) pure internal returns (bool) {
494         return value.mantissa == 0;
495     }
496 }
497 
498 /**
499  * @title ERC 20 Token Standard Interface
500  *  https://eips.ethereum.org/EIPS/eip-20
501  */
502 interface EIP20Interface {
503 
504     /**
505       * @notice Get the total number of tokens in circulation
506       * @return The supply of tokens
507       */
508     function totalSupply() external view returns (uint256);
509 
510     /**
511      * @notice Gets the balance of the specified address
512      * @param owner The address from which the balance will be retrieved
513      * @return The balance
514      */
515     function balanceOf(address owner) external view returns (uint256 balance);
516 
517     /**
518       * @notice Transfer `amount` tokens from `msg.sender` to `dst`
519       * @param dst The address of the destination account
520       * @param amount The number of tokens to transfer
521       * @return Whether or not the transfer succeeded
522       */
523     function transfer(address dst, uint256 amount) external returns (bool success);
524 
525     /**
526       * @notice Transfer `amount` tokens from `src` to `dst`
527       * @param src The address of the source account
528       * @param dst The address of the destination account
529       * @param amount The number of tokens to transfer
530       * @return Whether or not the transfer succeeded
531       */
532     function transferFrom(address src, address dst, uint256 amount) external returns (bool success);
533 
534     /**
535       * @notice Approve `spender` to transfer up to `amount` from `src`
536       * @dev This will overwrite the approval amount for `spender`
537       *  and is subject to issues noted [here](https://eips.ethereum.org/EIPS/eip-20#approve)
538       * @param spender The address of the account which may transfer tokens
539       * @param amount The number of tokens that are approved (-1 means infinite)
540       * @return Whether or not the approval succeeded
541       */
542     function approve(address spender, uint256 amount) external returns (bool success);
543 
544     /**
545       * @notice Get the current allowance from `owner` for `spender`
546       * @param owner The address of the account which owns the tokens to be spent
547       * @param spender The address of the account which may transfer tokens
548       * @return The number of tokens allowed to be spent (-1 means infinite)
549       */
550     function allowance(address owner, address spender) external view returns (uint256 remaining);
551 
552     event Transfer(address indexed from, address indexed to, uint256 amount);
553     event Approval(address indexed owner, address indexed spender, uint256 amount);
554 }
555 
556 
557 /**
558  *  @title EIP20NonStandardInterface
559  *  notice: Version of ERC20 with no return values for `transfer` and `transferFrom`
560  *  See https://medium.com/coinmonks/missing-return-value-bug-at-least-130-tokens-affected-d67bf08521ca
561  */
562 interface EIP20NonStandardInterface {
563 
564     function totalSupply() external view returns (uint256);
565 
566     function balanceOf(address owner) external view returns (uint256 balance);
567 
568     function transfer(address dst, uint256 amount) external;
569 
570     function transferFrom(address src, address dst, uint256 amount) external;
571 
572     function approve(address spender, uint256 amount) external returns (bool success);
573 
574     function allowance(address owner, address spender) external view returns (uint256 remaining);
575 
576     event Transfer(address indexed from, address indexed to, uint256 amount);
577     event Approval(address indexed owner, address indexed spender, uint256 amount);
578 }
579 
580 
581 /**
582  * @title Helps contracts guard against reentrancy attacks.
583  * @author Remco Bloemen <remco@2π.com>, Eenae <alexey@mixbytes.io>
584  * @dev If you mark a function `nonReentrant`, you should also
585  * mark it `external`.
586  */
587 contract ReentrancyGuard {
588     /// @dev counter to allow mutex lock with only one SSTORE operation
589     uint256 private _guardCounter;
590 
591     constructor () public {
592         // The counter starts at one to prevent changing it from zero to a non-zero
593         // value, which is a more expensive operation.
594         _guardCounter = 1;
595     }
596 
597     /**
598      * @dev Prevents a contract from calling itself, directly or indirectly.
599      * Calling a `nonReentrant` function from another `nonReentrant`
600      * function is not supported. It is possible to prevent this from happening
601      * by making the `nonReentrant` function external, and make it call a
602      * `private` function that does the actual work.
603      */
604     modifier nonReentrant() {
605         _guardCounter += 1;
606         uint256 localCounter = _guardCounter;
607         _;
608         require(localCounter == _guardCounter, "re-entered");
609     }
610 }
611 
612 
613 interface InterestRateModel {
614 
615     function getBorrowRate(uint cash, uint borrows, uint reserves) external view returns (uint, uint);
616 
617     function isInterestRateModel() external view returns (bool);
618 }
619 
620 
621 contract AToken is EIP20Interface, Exponential, TokenErrorReporter, ReentrancyGuard {
622     /**
623      * @notice Indicator that this is a AToken contract (for inspection)
624      */
625     bool public constant isAToken = true;
626 
627     /**
628      * @notice EIP-20 token name for this token
629      */
630     string public name;
631 
632     /**
633      * @notice EIP-20 token symbol for this token
634      */
635     string public symbol;
636 
637     /**
638      * @notice EIP-20 token decimals for this token
639      */
640     uint public decimals;
641 
642     /**
643      * @notice Maximum borrow rate that can ever be applied (.0005% / block)
644      */
645     uint constant borrowRateMaxMantissa = 5e14;
646 
647     /**
648      * @notice Maximum fraction of interest that can be set aside for reserves
649      */
650     uint constant reserveFactorMaxMantissa = 1e18;
651 
652     /**
653      * @notice Administrator for this contract
654      */
655     address payable public admin;
656 
657     /**
658      * @notice Pending administrator for this contract
659      */
660     address payable public pendingAdmin;
661 
662     /**
663      * @notice Contract which oversees inter-aToken operations
664      */
665     ControllerInterface public controller;
666 
667     /**
668      * @notice Model which tells what the current interest rate should be
669      */
670     InterestRateModel public interestRateModel;
671 
672     /**
673      * @notice Initial exchange rate used when minting the first ATokens (used when totalSupply = 0)
674      */
675     uint public initialExchangeRateMantissa;
676 
677     /**
678      * @notice Fraction of interest currently set aside for reserves
679      */
680     uint public reserveFactorMantissa;
681 
682     /**
683      * @notice Block number that interest was last accrued at
684      */
685     uint public accrualBlockNumber;
686 
687     /**
688      * @notice Accumulator of total earned interest since the opening of the market
689      */
690     uint public borrowIndex;
691 
692     /**
693      * @notice Total amount of outstanding borrows of the underlying in this market
694      */
695     uint public totalBorrows;
696 
697     /**
698      * @notice Total amount of reserves of the underlying held in this market
699      */
700     uint public totalReserves;
701 
702     /**
703      * @notice Total number of tokens in circulation
704      */
705     uint256 public totalSupply;
706 
707     /**
708      * @notice Official record of token balances for each account
709      */
710     mapping (address => uint256) accountTokens;
711 
712     /**
713      * @notice Approved token transfer amounts on behalf of others
714      */
715     mapping (address => mapping (address => uint256)) transferAllowances;
716 
717     /**
718      * @notice Container for borrow balance information
719      * @member principal Total balance (with accrued interest), after applying the most recent balance-changing action
720      * @member interestIndex Global borrowIndex as of the most recent balance-changing action
721      */
722     struct BorrowSnapshot {
723         uint principal;
724         uint interestIndex;
725     }
726 
727     /**
728      * @notice Mapping of account addresses to outstanding borrow balances
729      */
730     mapping(address => BorrowSnapshot) accountBorrows;
731 
732 
733     /*** Market Events ***/
734 
735     /**
736      * @notice Event emitted when interest is accrued
737      */
738     event AccrueInterest(uint interestAccumulated, uint borrowIndex, uint totalBorrows);
739 
740     /**
741      * @notice Event emitted when tokens are minted
742      */
743     event Mint(address minter, uint mintAmount, uint mintTokens);
744 
745     /**
746      * @notice Event emitted when tokens are redeemed
747      */
748     event Redeem(address redeemer, uint redeemAmount, uint redeemTokens);
749 
750     /**
751      * @notice Event emitted when underlying is borrowed
752      */
753     event Borrow(address borrower, uint borrowAmount, uint accountBorrows, uint totalBorrows);
754 
755     /**
756      * @notice Event emitted when a borrow is repaid
757      */
758     event RepayBorrow(address payer, address borrower, uint repayAmount, uint accountBorrows, uint totalBorrows);
759 
760     /**
761      * @notice Event emitted when a borrow is liquidated
762      */
763     event LiquidateBorrow(address liquidator, address borrower, uint repayAmount, address aTokenCollateral, uint seizeTokens);
764 
765 
766     /*** Admin Events ***/
767 
768     /**
769      * @notice Event emitted when pendingAdmin is changed
770      */
771     event NewPendingAdmin(address oldPendingAdmin, address newPendingAdmin);
772 
773     /**
774      * @notice Event emitted when pendingAdmin is accepted, which means admin is updated
775      */
776     event NewAdmin(address oldAdmin, address newAdmin);
777 
778     /**
779      * @notice Event emitted when controller is changed
780      */
781     event NewController(ControllerInterface oldController, ControllerInterface newController);
782 
783     /**
784      * @notice Event emitted when interestRateModel is changed
785      */
786     event NewMarketInterestRateModel(InterestRateModel oldInterestRateModel, InterestRateModel newInterestRateModel);
787 
788     /**
789      * @notice Event emitted when the reserve factor is changed
790      */
791     event NewReserveFactor(uint oldReserveFactorMantissa, uint newReserveFactorMantissa);
792 
793     /**
794      * @notice Event emitted when the reserves are reduced
795      */
796     event ReservesReduced(address admin, uint reduceAmount, uint newTotalReserves);
797 
798     constructor( ) public { 
799         admin = msg.sender;
800 
801         // Set initial exchange rate
802         initialExchangeRateMantissa = uint(200000000000000);
803 
804         // Initialize block number and borrow index (block number mocks depend on controller being set)
805         accrualBlockNumber = getBlockNumber();
806         borrowIndex = mantissaOne;
807 
808         name = string("Artem USD Coin");
809         symbol = string("aUSDC");
810         decimals = uint(8);
811     }
812 
813     function transferTokens(address spender, address src, address dst, uint tokens) internal returns (uint) {
814         /* Fail if transfer not allowed */
815         uint allowed = controller.transferAllowed(address(this), src, dst, tokens);
816         if (allowed != 0) {
817             return failOpaque(Error.CONTROLLER_REJECTION, FailureInfo.TRANSFER_CONTROLLER_REJECTION, allowed);
818         }
819 
820         /* Do not allow self-transfers */
821         if (src == dst) {
822             return fail(Error.BAD_INPUT, FailureInfo.TRANSFER_NOT_ALLOWED);
823         }
824 
825         /* Get the allowance, infinite for the account owner */
826         uint startingAllowance = 0;
827         if (spender == src) {
828             startingAllowance = uint(-1);
829         } else {
830             startingAllowance = transferAllowances[src][spender];
831         }
832 
833         /* Do the calculations, checking for {under,over}flow */
834         MathError mathErr;
835         uint allowanceNew;
836         uint srcTokensNew;
837         uint dstTokensNew;
838 
839         (mathErr, allowanceNew) = subUInt(startingAllowance, tokens);
840         if (mathErr != MathError.NO_ERROR) {
841             return fail(Error.MATH_ERROR, FailureInfo.TRANSFER_NOT_ALLOWED);
842         }
843 
844         (mathErr, srcTokensNew) = subUInt(accountTokens[src], tokens);
845         if (mathErr != MathError.NO_ERROR) {
846             return fail(Error.MATH_ERROR, FailureInfo.TRANSFER_NOT_ENOUGH);
847         }
848 
849         (mathErr, dstTokensNew) = addUInt(accountTokens[dst], tokens);
850         if (mathErr != MathError.NO_ERROR) {
851             return fail(Error.MATH_ERROR, FailureInfo.TRANSFER_TOO_MUCH);
852         }
853 
854         /////////////////////////
855         // EFFECTS & INTERACTIONS
856         // (No safe failures beyond this point)
857 
858         accountTokens[src] = srcTokensNew;
859         accountTokens[dst] = dstTokensNew;
860 
861         /* Eat some of the allowance (if necessary) */
862         if (startingAllowance != uint(-1)) {
863             transferAllowances[src][spender] = allowanceNew;
864         }
865 
866         /* We emit a Transfer event */
867         emit Transfer(src, dst, tokens);
868 
869         /* We call the defense hook (which checks for under-collateralization) */
870         controller.transferVerify(address(this), src, dst, tokens);
871 
872         return uint(Error.NO_ERROR);
873     }
874 
875     /**
876      * @notice Transfer `amount` tokens from `msg.sender` to `dst`
877      * @param dst The address of the destination account
878      * @param amount The number of tokens to transfer
879      * @return Whether or not the transfer succeeded
880      */
881     function transfer(address dst, uint256 amount) external nonReentrant returns (bool) {
882         return transferTokens(msg.sender, msg.sender, dst, amount) == uint(Error.NO_ERROR);
883     }
884 
885     /**
886      * @notice Transfer `amount` tokens from `src` to `dst`
887      * @param src The address of the source account
888      * @param dst The address of the destination account
889      * @param amount The number of tokens to transfer
890      * @return Whether or not the transfer succeeded
891      */
892     function transferFrom(address src, address dst, uint256 amount) external nonReentrant returns (bool) {
893         return transferTokens(msg.sender, src, dst, amount) == uint(Error.NO_ERROR);
894     }
895 
896     /**
897      * @notice Approve `spender` to transfer up to `amount` from `src`
898      * @dev This will overwrite the approval amount for `spender`
899      *  and is subject to issues noted [here](https://eips.ethereum.org/EIPS/eip-20#approve)
900      * @param spender The address of the account which may transfer tokens
901      * @param amount The number of tokens that are approved (-1 means infinite)
902      * @return Whether or not the approval succeeded
903      */
904     function approve(address spender, uint256 amount) external returns (bool) {
905         address src = msg.sender;
906         transferAllowances[src][spender] = amount;
907         emit Approval(src, spender, amount);
908         return true;
909     }
910 
911     /**
912      * @notice Get the current allowance from `owner` for `spender`
913      * @param owner The address of the account which owns the tokens to be spent
914      * @param spender The address of the account which may transfer tokens
915      * @return The number of tokens allowed to be spent (-1 means infinite)
916      */
917     function allowance(address owner, address spender) external view returns (uint256) {
918         return transferAllowances[owner][spender];
919     }
920 
921     /**
922      * @notice Get the token balance of the `owner`
923      * @param owner The address of the account to query
924      * @return The number of tokens owned by `owner`
925      */
926     function balanceOf(address owner) external view returns (uint256) {
927         return accountTokens[owner];
928     }
929 
930     /**
931      * @notice Get the underlying balance of the `owner`
932      * @dev This also accrues interest in a transaction
933      * @param owner The address of the account to query
934      * @return The amount of underlying owned by `owner`
935      */
936     function balanceOfUnderlying(address owner) external returns (uint) {
937         Exp memory exchangeRate = Exp({mantissa: exchangeRateCurrent()});
938         (MathError mErr, uint balance) = mulScalarTruncate(exchangeRate, accountTokens[owner]);
939         require(mErr == MathError.NO_ERROR);
940         return balance;
941     }
942 
943     /**
944      * @notice Get a snapshot of the account's balances, and the cached exchange rate
945      * @dev This is used by controller to more efficiently perform liquidity checks.
946      * @param account Address of the account to snapshot
947      * @return (possible error, token balance, borrow balance, exchange rate mantissa)
948      */
949     function getAccountSnapshot(address account) external view returns (uint, uint, uint, uint) {
950         uint aTokenBalance = accountTokens[account];
951         uint borrowBalance;
952         uint exchangeRateMantissa;
953 
954         MathError mErr;
955 
956         (mErr, borrowBalance) = borrowBalanceStoredInternal(account);
957         if (mErr != MathError.NO_ERROR) {
958             return (uint(Error.MATH_ERROR), 0, 0, 0);
959         }
960 
961         (mErr, exchangeRateMantissa) = exchangeRateStoredInternal();
962         if (mErr != MathError.NO_ERROR) {
963             return (uint(Error.MATH_ERROR), 0, 0, 0);
964         }
965 
966         return (uint(Error.NO_ERROR), aTokenBalance, borrowBalance, exchangeRateMantissa);
967     }
968 
969     /**
970      * @dev Function to simply retrieve block number
971      *  This exists mainly for inheriting test contracts to stub this result.
972      */
973     function getBlockNumber() internal view returns (uint) {
974         return block.number;
975     }
976 
977     /**
978      * @notice Returns the current per-block borrow interest rate for this aToken
979      * @return The borrow interest rate per block, scaled by 1e18
980      */
981     function borrowRatePerBlock() external view returns (uint) {
982         (uint opaqueErr, uint borrowRateMantissa) = interestRateModel.getBorrowRate(getCashPrior(), totalBorrows, totalReserves);
983         require(opaqueErr == 0, "borrowRatePerBlock: interestRateModel.borrowRate failed"); // semi-opaque
984         return borrowRateMantissa;
985     }
986 
987     /**
988      * @notice Returns the current per-block supply interest rate for this aToken
989      * @return The supply interest rate per block, scaled by 1e18
990      */
991     function supplyRatePerBlock() external view returns (uint) {
992         /* We calculate the supply rate:
993          *  underlying = totalSupply × exchangeRate
994          *  borrowsPer = totalBorrows ÷ underlying
995          *  supplyRate = borrowRate × (1-reserveFactor) × borrowsPer
996          */
997         uint exchangeRateMantissa = exchangeRateStored();
998 
999         (uint e0, uint borrowRateMantissa) = interestRateModel.getBorrowRate(getCashPrior(), totalBorrows, totalReserves);
1000         require(e0 == 0, "supplyRatePerBlock: calculating borrowRate failed"); // semi-opaque
1001 
1002         (MathError e1, Exp memory underlying) = mulScalar(Exp({mantissa: exchangeRateMantissa}), totalSupply);
1003         require(e1 == MathError.NO_ERROR, "supplyRatePerBlock: calculating underlying failed");
1004 
1005         (MathError e2, Exp memory borrowsPer) = divScalarByExp(totalBorrows, underlying);
1006         require(e2 == MathError.NO_ERROR, "supplyRatePerBlock: calculating borrowsPer failed");
1007 
1008         (MathError e3, Exp memory oneMinusReserveFactor) = subExp(Exp({mantissa: mantissaOne}), Exp({mantissa: reserveFactorMantissa}));
1009         require(e3 == MathError.NO_ERROR, "supplyRatePerBlock: calculating oneMinusReserveFactor failed");
1010 
1011         (MathError e4, Exp memory supplyRate) = mulExp3(Exp({mantissa: borrowRateMantissa}), oneMinusReserveFactor, borrowsPer);
1012         require(e4 == MathError.NO_ERROR, "supplyRatePerBlock: calculating supplyRate failed");
1013 
1014         return supplyRate.mantissa;
1015     }
1016 
1017     /**
1018      * @notice Returns the current total borrows plus accrued interest
1019      * @return The total borrows with interest
1020      */
1021     function totalBorrowsCurrent() external nonReentrant returns (uint) {
1022         require(accrueInterest() == uint(Error.NO_ERROR), "accrue interest failed");
1023         return totalBorrows;
1024     }
1025 
1026     /**
1027      * @notice Accrue interest to updated borrowIndex and then calculate account's borrow balance using the updated borrowIndex
1028      * @param account The address whose balance should be calculated after updating borrowIndex
1029      * @return The calculated balance
1030      */
1031     function borrowBalanceCurrent(address account) external nonReentrant returns (uint) {
1032         require(accrueInterest() == uint(Error.NO_ERROR), "accrue interest failed");
1033         return borrowBalanceStored(account);
1034     }
1035 
1036     /**
1037      * @notice Return the borrow balance of account based on stored data
1038      * @param account The address whose balance should be calculated
1039      * @return The calculated balance
1040      */
1041     function borrowBalanceStored(address account) public view returns (uint) {
1042         (MathError err, uint result) = borrowBalanceStoredInternal(account);
1043         require(err == MathError.NO_ERROR, "borrowBalanceStored: borrowBalanceStoredInternal failed");
1044         return result;
1045     }
1046 
1047     /**
1048      * @notice Return the borrow balance of account based on stored data
1049      * @param account The address whose balance should be calculated
1050      * @return (error code, the calculated balance or 0 if error code is non-zero)
1051      */
1052     function borrowBalanceStoredInternal(address account) internal view returns (MathError, uint) {
1053         /* Note: we do not assert that the market is up to date */
1054         MathError mathErr;
1055         uint principalTimesIndex;
1056         uint result;
1057 
1058         /* Get borrowBalance and borrowIndex */
1059         BorrowSnapshot storage borrowSnapshot = accountBorrows[account];
1060 
1061         /* If borrowBalance = 0 then borrowIndex is likely also 0.
1062          * Rather than failing the calculation with a division by 0, we immediately return 0 in this case.
1063          */
1064         if (borrowSnapshot.principal == 0) {
1065             return (MathError.NO_ERROR, 0);
1066         }
1067 
1068         /* Calculate new borrow balance using the interest index:
1069          *  recentBorrowBalance = borrower.borrowBalance * market.borrowIndex / borrower.borrowIndex
1070          */
1071         (mathErr, principalTimesIndex) = mulUInt(borrowSnapshot.principal, borrowIndex);
1072         if (mathErr != MathError.NO_ERROR) {
1073             return (mathErr, 0);
1074         }
1075 
1076         (mathErr, result) = divUInt(principalTimesIndex, borrowSnapshot.interestIndex);
1077         if (mathErr != MathError.NO_ERROR) {
1078             return (mathErr, 0);
1079         }
1080 
1081         return (MathError.NO_ERROR, result);
1082     }
1083 
1084     /**
1085      * @notice Accrue interest then return the up-to-date exchange rate
1086      * @return Calculated exchange rate scaled by 1e18
1087      */
1088     function exchangeRateCurrent() public nonReentrant returns (uint) {
1089         require(accrueInterest() == uint(Error.NO_ERROR), "accrue interest failed");
1090         return exchangeRateStored();
1091     }
1092 
1093     /**
1094      * @notice Calculates the exchange rate from the underlying to the AToken
1095      * @dev This function does not accrue interest before calculating the exchange rate
1096      * @return Calculated exchange rate scaled by 1e18
1097      */
1098     function exchangeRateStored() public view returns (uint) {
1099         (MathError err, uint result) = exchangeRateStoredInternal();
1100         require(err == MathError.NO_ERROR, "exchangeRateStored: exchangeRateStoredInternal failed");
1101         return result;
1102     }
1103 
1104     /**
1105      * @notice Calculates the exchange rate from the underlying to the AToken
1106      * @dev This function does not accrue interest before calculating the exchange rate
1107      * @return (error code, calculated exchange rate scaled by 1e18)
1108      */
1109     function exchangeRateStoredInternal() internal view returns (MathError, uint) {
1110         if (totalSupply == 0) {
1111             /*
1112              * If there are no tokens minted:
1113              *  exchangeRate = initialExchangeRate
1114              */
1115             return (MathError.NO_ERROR, initialExchangeRateMantissa);
1116         } else {
1117             /*
1118              * Otherwise:
1119              *  exchangeRate = (totalCash + totalBorrows - totalReserves) / totalSupply
1120              */
1121             uint totalCash = getCashPrior();
1122             uint cashPlusBorrowsMinusReserves;
1123             Exp memory exchangeRate;
1124             MathError mathErr;
1125 
1126             (mathErr, cashPlusBorrowsMinusReserves) = addThenSubUInt(totalCash, totalBorrows, totalReserves);
1127             if (mathErr != MathError.NO_ERROR) {
1128                 return (mathErr, 0);
1129             }
1130 
1131             (mathErr, exchangeRate) = getExp(cashPlusBorrowsMinusReserves, totalSupply);
1132             if (mathErr != MathError.NO_ERROR) {
1133                 return (mathErr, 0);
1134             }
1135 
1136             return (MathError.NO_ERROR, exchangeRate.mantissa);
1137         }
1138     }
1139 
1140     /**
1141      * @notice Get cash balance of this aToken in the underlying asset
1142      * @return The quantity of underlying asset owned by this contract
1143      */
1144     function getCash() external view returns (uint) {
1145         return getCashPrior();
1146     }
1147 
1148     struct AccrueInterestLocalVars {
1149         MathError mathErr;
1150         uint opaqueErr;
1151         uint borrowRateMantissa;
1152         uint currentBlockNumber;
1153         uint blockDelta;
1154 
1155         Exp simpleInterestFactor;
1156 
1157         uint interestAccumulated;
1158         uint totalBorrowsNew;
1159         uint totalReservesNew;
1160         uint borrowIndexNew;
1161     }
1162     
1163     function getCash_pub() public returns (uint) {
1164         return getCashPrior();
1165     }
1166     
1167     /**
1168       * @notice Applies accrued interest to total borrows and reserves.
1169       * @dev This calculates interest accrued from the last checkpointed block
1170       *      up to the current block and writes new checkpoint to storage.
1171       */
1172     function accrueInterest() public returns (uint) {
1173         AccrueInterestLocalVars memory vars;
1174 
1175         /* Calculate the current borrow interest rate */
1176         (vars.opaqueErr, vars.borrowRateMantissa) = interestRateModel.getBorrowRate(getCashPrior(), totalBorrows, totalReserves);
1177 
1178         require(vars.borrowRateMantissa <= borrowRateMaxMantissa, "borrow rate is absurdly high");
1179         if (vars.opaqueErr != 0) {
1180             return failOpaque(Error.INTEREST_RATE_MODEL_ERROR, FailureInfo.ACCRUE_INTEREST_BORROW_RATE_CALCULATION_FAILED, vars.opaqueErr);
1181         }
1182 
1183         /* Remember the initial block number */
1184         vars.currentBlockNumber = getBlockNumber();
1185 
1186         /* Calculate the number of blocks elapsed since the last accrual */
1187         (vars.mathErr, vars.blockDelta) = subUInt(vars.currentBlockNumber, accrualBlockNumber);
1188         assert(vars.mathErr == MathError.NO_ERROR); // Block delta should always succeed and if it doesn't, blow up.
1189 
1190         /*
1191          * Calculate the interest accumulated into borrows and reserves and the new index:
1192          *  simpleInterestFactor = borrowRate * blockDelta
1193          *  interestAccumulated = simpleInterestFactor * totalBorrows
1194          *  totalBorrowsNew = interestAccumulated + totalBorrows
1195          *  totalReservesNew = interestAccumulated * reserveFactor + totalReserves
1196          *  borrowIndexNew = simpleInterestFactor * borrowIndex + borrowIndex
1197          */
1198         (vars.mathErr, vars.simpleInterestFactor) = mulScalar(Exp({mantissa: vars.borrowRateMantissa}), vars.blockDelta);
1199         if (vars.mathErr != MathError.NO_ERROR) {
1200             return failOpaque(Error.MATH_ERROR, FailureInfo.ACCRUE_INTEREST_SIMPLE_INTEREST_FACTOR_CALCULATION_FAILED, uint(vars.mathErr));
1201         }
1202 
1203         (vars.mathErr, vars.interestAccumulated) = mulScalarTruncate(vars.simpleInterestFactor, totalBorrows);
1204         if (vars.mathErr != MathError.NO_ERROR) {
1205             return failOpaque(Error.MATH_ERROR, FailureInfo.ACCRUE_INTEREST_ACCUMULATED_INTEREST_CALCULATION_FAILED, uint(vars.mathErr));
1206         }
1207 
1208         (vars.mathErr, vars.totalBorrowsNew) = addUInt(vars.interestAccumulated, totalBorrows);
1209         if (vars.mathErr != MathError.NO_ERROR) {
1210             return failOpaque(Error.MATH_ERROR, FailureInfo.ACCRUE_INTEREST_NEW_TOTAL_BORROWS_CALCULATION_FAILED, uint(vars.mathErr));
1211         }
1212 
1213         (vars.mathErr, vars.totalReservesNew) = mulScalarTruncateAddUInt(Exp({mantissa: reserveFactorMantissa}), vars.interestAccumulated, totalReserves);
1214         if (vars.mathErr != MathError.NO_ERROR) {
1215             return failOpaque(Error.MATH_ERROR, FailureInfo.ACCRUE_INTEREST_NEW_TOTAL_RESERVES_CALCULATION_FAILED, uint(vars.mathErr));
1216         }
1217 
1218         (vars.mathErr, vars.borrowIndexNew) = mulScalarTruncateAddUInt(vars.simpleInterestFactor, borrowIndex, borrowIndex);
1219         if (vars.mathErr != MathError.NO_ERROR) {
1220             return failOpaque(Error.MATH_ERROR, FailureInfo.ACCRUE_INTEREST_NEW_BORROW_INDEX_CALCULATION_FAILED, uint(vars.mathErr));
1221         }
1222 
1223         /////////////////////////
1224         // EFFECTS & INTERACTIONS
1225         // (No safe failures beyond this point)
1226 
1227         /* We write the previously calculated values into storage */
1228         accrualBlockNumber = vars.currentBlockNumber;
1229         borrowIndex = vars.borrowIndexNew;
1230         totalBorrows = vars.totalBorrowsNew;
1231         totalReserves = vars.totalReservesNew;
1232 
1233         /* We emit an AccrueInterest event */
1234         emit AccrueInterest(vars.interestAccumulated, vars.borrowIndexNew, totalBorrows);
1235 
1236         return uint(Error.NO_ERROR);
1237     }
1238 
1239     /**
1240      * @notice Sender supplies assets into the market and receives aTokens in exchange
1241      * @dev Accrues interest whether or not the operation succeeds, unless reverted
1242      * @param mintAmount The amount of the underlying asset to supply
1243      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
1244      */
1245     function mintInternal(uint mintAmount) internal nonReentrant returns (uint) {
1246         uint error = accrueInterest();
1247         if (error != uint(Error.NO_ERROR)) {
1248             // accrueInterest emits logs on errors, but we still want to log the fact that an attempted borrow failed
1249             return fail(Error(error), FailureInfo.MINT_ACCRUE_INTEREST_FAILED);
1250         }
1251         // mintFresh emits the actual Mint event if successful and logs on errors, so we don't need to
1252         return mintFresh(msg.sender, mintAmount);
1253     }
1254 
1255     struct MintLocalVars {
1256         Error err;
1257         MathError mathErr;
1258         uint exchangeRateMantissa;
1259         uint mintTokens;
1260         uint totalSupplyNew;
1261         uint accountTokensNew;
1262     }
1263     
1264     /**
1265      * @notice User supplies assets into the market and receives aTokens in exchange
1266      * @dev Assumes interest has already been accrued up to the current block
1267      * @param minter The address of the account which is supplying the assets
1268      * @param mintAmount The amount of the underlying asset to supply
1269      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
1270      */
1271     function mintFresh(address minter, uint mintAmount) internal returns (uint) {
1272         /* Fail if mint not allowed */
1273         uint allowed = controller.mintAllowed(address(this), minter, mintAmount);
1274         if (allowed != 0) {
1275             return failOpaque(Error.CONTROLLER_REJECTION, FailureInfo.MINT_CONTROLLER_REJECTION, allowed);
1276         }
1277 
1278         /* Verify market's block number equals current block number */
1279         if (accrualBlockNumber != getBlockNumber()) {
1280             return fail(Error.MARKET_NOT_FRESH, FailureInfo.MINT_FRESHNESS_CHECK);
1281         }
1282 
1283         MintLocalVars memory vars;
1284 
1285         /* Fail if checkTransferIn fails */
1286         vars.err = checkTransferIn(minter, mintAmount);
1287         if (vars.err != Error.NO_ERROR) {
1288             return fail(vars.err, FailureInfo.MINT_TRANSFER_IN_NOT_POSSIBLE);
1289         }
1290 
1291         /*
1292          * We get the current exchange rate and calculate the number of aTokens to be minted:
1293          *  mintTokens = mintAmount / exchangeRate
1294          */
1295         (vars.mathErr, vars.exchangeRateMantissa) = exchangeRateStoredInternal();
1296         if (vars.mathErr != MathError.NO_ERROR) {
1297             return failOpaque(Error.MATH_ERROR, FailureInfo.MINT_EXCHANGE_RATE_READ_FAILED, uint(vars.mathErr));
1298         }
1299 
1300         (vars.mathErr, vars.mintTokens) = divScalarByExpTruncate(mintAmount, Exp({mantissa: vars.exchangeRateMantissa}));
1301         if (vars.mathErr != MathError.NO_ERROR) {
1302             return failOpaque(Error.MATH_ERROR, FailureInfo.MINT_EXCHANGE_CALCULATION_FAILED, uint(vars.mathErr));
1303         }
1304 
1305         /*
1306          * We calculate the new total supply of aTokens and minter token balance, checking for overflow:
1307          *  totalSupplyNew = totalSupply + mintTokens
1308          *  accountTokensNew = accountTokens[minter] + mintTokens
1309          */
1310         (vars.mathErr, vars.totalSupplyNew) = addUInt(totalSupply, vars.mintTokens);
1311         if (vars.mathErr != MathError.NO_ERROR) {
1312             return failOpaque(Error.MATH_ERROR, FailureInfo.MINT_NEW_TOTAL_SUPPLY_CALCULATION_FAILED, uint(vars.mathErr));
1313         }
1314 
1315         (vars.mathErr, vars.accountTokensNew) = addUInt(accountTokens[minter], vars.mintTokens);
1316         if (vars.mathErr != MathError.NO_ERROR) {
1317             return failOpaque(Error.MATH_ERROR, FailureInfo.MINT_NEW_ACCOUNT_BALANCE_CALCULATION_FAILED, uint(vars.mathErr));
1318         }
1319 
1320         /////////////////////////
1321         // EFFECTS & INTERACTIONS
1322         // (No safe failures beyond this point)
1323 
1324         /*
1325          * We call doTransferIn for the minter and the mintAmount
1326          *  Note: The aToken must handle variations between ERC-20 and ETH underlying.
1327          *  On success, the aToken holds an additional mintAmount of cash.
1328          *  If doTransferIn fails despite the fact we checked pre-conditions,
1329          *   we revert because we can't be sure if side effects occurred.
1330          */
1331         vars.err = doTransferIn(minter, mintAmount);
1332         if (vars.err != Error.NO_ERROR) {
1333             return fail(vars.err, FailureInfo.MINT_TRANSFER_IN_FAILED);
1334         }
1335 
1336         /* We write previously calculated values into storage */
1337         totalSupply = vars.totalSupplyNew;
1338         accountTokens[minter] = vars.accountTokensNew;
1339 
1340         /* We emit a Mint event, and a Transfer event */
1341         emit Mint(minter, mintAmount, vars.mintTokens);
1342         emit Transfer(address(this), minter, vars.mintTokens);
1343 
1344         /* We call the defense hook */
1345         controller.mintVerify(address(this), minter, mintAmount, vars.mintTokens);
1346 
1347         return uint(Error.NO_ERROR);
1348     }
1349 
1350     /**
1351      * @notice Sender redeems aTokens in exchange for the underlying asset
1352      * @dev Accrues interest whether or not the operation succeeds, unless reverted
1353      * @param redeemTokens The number of aTokens to redeem into underlying
1354      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
1355      */
1356     function redeemInternal(uint redeemTokens) internal nonReentrant returns (uint) {
1357         uint error = accrueInterest();
1358         if (error != uint(Error.NO_ERROR)) {
1359             // accrueInterest emits logs on errors, but we still want to log the fact that an attempted redeem failed
1360             return fail(Error(error), FailureInfo.REDEEM_ACCRUE_INTEREST_FAILED);
1361         }
1362         // redeemFresh emits redeem-specific logs on errors, so we don't need to
1363         return redeemFresh(msg.sender, redeemTokens, 0);
1364     }
1365 
1366     /**
1367      * @notice Sender redeems aTokens in exchange for a specified amount of underlying asset
1368      * @dev Accrues interest whether or not the operation succeeds, unless reverted
1369      * @param redeemAmount The amount of underlying to redeem
1370      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
1371      */
1372     function redeemUnderlyingInternal(uint redeemAmount) internal nonReentrant returns (uint) {
1373         uint error = accrueInterest();
1374         if (error != uint(Error.NO_ERROR)) {
1375             // accrueInterest emits logs on errors, but we still want to log the fact that an attempted redeem failed
1376             return fail(Error(error), FailureInfo.REDEEM_ACCRUE_INTEREST_FAILED);
1377         }
1378         // redeemFresh emits redeem-specific logs on errors, so we don't need to
1379         return redeemFresh(msg.sender, 0, redeemAmount);
1380     }
1381 
1382     struct RedeemLocalVars {
1383         Error err;
1384         MathError mathErr;
1385         uint exchangeRateMantissa;
1386         uint redeemTokens;
1387         uint redeemAmount;
1388         uint totalSupplyNew;
1389         uint accountTokensNew;
1390     }
1391 
1392     /**
1393      * @notice User redeems aTokens in exchange for the underlying asset
1394      * @dev Assumes interest has already been accrued up to the current block
1395      * @param redeemer The address of the account which is redeeming the tokens
1396      * @param redeemTokensIn The number of aTokens to redeem into underlying (only one of redeemTokensIn or redeemAmountIn may be zero)
1397      * @param redeemAmountIn The number of aTokens to redeem into underlying (only one of redeemTokensIn or redeemAmountIn may be zero)
1398      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
1399      */
1400     function redeemFresh(address payable redeemer, uint redeemTokensIn, uint redeemAmountIn) internal returns (uint) {
1401         require(redeemTokensIn == 0 || redeemAmountIn == 0, "one of redeemTokensIn or redeemAmountIn must be zero");
1402 
1403         RedeemLocalVars memory vars;
1404 
1405         /* exchangeRate = invoke Exchange Rate Stored() */
1406         (vars.mathErr, vars.exchangeRateMantissa) = exchangeRateStoredInternal();
1407         if (vars.mathErr != MathError.NO_ERROR) {
1408             return failOpaque(Error.MATH_ERROR, FailureInfo.REDEEM_EXCHANGE_RATE_READ_FAILED, uint(vars.mathErr));
1409         }
1410 
1411         /* If redeemTokensIn > 0: */
1412         if (redeemTokensIn > 0) {
1413             /*
1414              * We calculate the exchange rate and the amount of underlying to be redeemed:
1415              *  redeemTokens = redeemTokensIn
1416              *  redeemAmount = redeemTokensIn x exchangeRateCurrent
1417              */
1418             vars.redeemTokens = redeemTokensIn;
1419 
1420             (vars.mathErr, vars.redeemAmount) = mulScalarTruncate(Exp({mantissa: vars.exchangeRateMantissa}), redeemTokensIn);
1421             if (vars.mathErr != MathError.NO_ERROR) {
1422                 return failOpaque(Error.MATH_ERROR, FailureInfo.REDEEM_EXCHANGE_TOKENS_CALCULATION_FAILED, uint(vars.mathErr));
1423             }
1424         } else {
1425             /*
1426              * We get the current exchange rate and calculate the amount to be redeemed:
1427              *  redeemTokens = redeemAmountIn / exchangeRate
1428              *  redeemAmount = redeemAmountIn
1429              */
1430 
1431             (vars.mathErr, vars.redeemTokens) = divScalarByExpTruncate(redeemAmountIn, Exp({mantissa: vars.exchangeRateMantissa}));
1432             if (vars.mathErr != MathError.NO_ERROR) {
1433                 return failOpaque(Error.MATH_ERROR, FailureInfo.REDEEM_EXCHANGE_AMOUNT_CALCULATION_FAILED, uint(vars.mathErr));
1434             }
1435 
1436             vars.redeemAmount = redeemAmountIn;
1437         }
1438 
1439         /* Fail if redeem not allowed */
1440         uint allowed = controller.redeemAllowed(address(this), redeemer, vars.redeemTokens);
1441         if (allowed != 0) {
1442             return failOpaque(Error.CONTROLLER_REJECTION, FailureInfo.REDEEM_CONTROLLER_REJECTION, allowed);
1443         }
1444 
1445         /* Verify market's block number equals current block number */
1446         if (accrualBlockNumber != getBlockNumber()) {
1447             return fail(Error.MARKET_NOT_FRESH, FailureInfo.REDEEM_FRESHNESS_CHECK);
1448         }
1449 
1450         /*
1451          * We calculate the new total supply and redeemer balance, checking for underflow:
1452          *  totalSupplyNew = totalSupply - redeemTokens
1453          *  accountTokensNew = accountTokens[redeemer] - redeemTokens
1454          */
1455         (vars.mathErr, vars.totalSupplyNew) = subUInt(totalSupply, vars.redeemTokens);
1456         if (vars.mathErr != MathError.NO_ERROR) {
1457             return failOpaque(Error.MATH_ERROR, FailureInfo.REDEEM_NEW_TOTAL_SUPPLY_CALCULATION_FAILED, uint(vars.mathErr));
1458         }
1459 
1460         (vars.mathErr, vars.accountTokensNew) = subUInt(accountTokens[redeemer], vars.redeemTokens);
1461         if (vars.mathErr != MathError.NO_ERROR) {
1462             return failOpaque(Error.MATH_ERROR, FailureInfo.REDEEM_NEW_ACCOUNT_BALANCE_CALCULATION_FAILED, uint(vars.mathErr));
1463         }
1464 
1465         /* Fail gracefully if protocol has insufficient cash */
1466         if (getCashPrior() < vars.redeemAmount) {
1467             return fail(Error.TOKEN_INSUFFICIENT_CASH, FailureInfo.REDEEM_TRANSFER_OUT_NOT_POSSIBLE);
1468         }
1469 
1470         /////////////////////////
1471         // EFFECTS & INTERACTIONS
1472         // (No safe failures beyond this point)
1473 
1474         /*
1475          * We invoke doTransferOut for the redeemer and the redeemAmount.
1476          *  Note: The aToken must handle variations between ERC-20 and ETH underlying.
1477          *  On success, the aToken has redeemAmount less of cash.
1478          *  If doTransferOut fails despite the fact we checked pre-conditions,
1479          *   we revert because we can't be sure if side effects occurred.
1480          */
1481         vars.err = doTransferOut(redeemer, vars.redeemAmount);
1482         require(vars.err == Error.NO_ERROR, "redeem transfer out failed");
1483 
1484         /* We write previously calculated values into storage */
1485         totalSupply = vars.totalSupplyNew;
1486         accountTokens[redeemer] = vars.accountTokensNew;
1487 
1488         /* We emit a Transfer event, and a Redeem event */
1489         emit Transfer(redeemer, address(this), vars.redeemTokens);
1490         emit Redeem(redeemer, vars.redeemAmount, vars.redeemTokens);
1491 
1492         /* We call the defense hook */
1493         controller.redeemVerify(address(this), redeemer, vars.redeemAmount, vars.redeemTokens);
1494 
1495         return uint(Error.NO_ERROR);
1496     }
1497 
1498     /**
1499       * @notice Sender borrows assets from the protocol to their own address
1500       * @param borrowAmount The amount of the underlying asset to borrow
1501       * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
1502       */
1503     function borrowInternal(uint borrowAmount) internal nonReentrant returns (uint) {
1504         uint error = accrueInterest();
1505         if (error != uint(Error.NO_ERROR)) {
1506             // accrueInterest emits logs on errors, but we still want to log the fact that an attempted borrow failed
1507             return fail(Error(error), FailureInfo.BORROW_ACCRUE_INTEREST_FAILED);
1508         }
1509         // borrowFresh emits borrow-specific logs on errors, so we don't need to
1510         return borrowFresh(msg.sender, borrowAmount);
1511     }
1512 
1513     struct BorrowLocalVars {
1514         Error err;
1515         MathError mathErr;
1516         uint accountBorrows;
1517         uint accountBorrowsNew;
1518         uint totalBorrowsNew;
1519     }
1520 
1521     /**
1522       * @notice Users borrow assets from the protocol to their own address
1523       * @param borrowAmount The amount of the underlying asset to borrow
1524       * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
1525       */
1526     function borrowFresh(address payable borrower, uint borrowAmount) internal returns (uint) {
1527         /* Fail if borrow not allowed */
1528         uint allowed = controller.borrowAllowed(address(this), borrower, borrowAmount);
1529         if (allowed != 0) {
1530             return failOpaque(Error.CONTROLLER_REJECTION, FailureInfo.BORROW_CONTROLLER_REJECTION, allowed);
1531         }
1532 
1533         /* Verify market's block number equals current block number */
1534         if (accrualBlockNumber != getBlockNumber()) {
1535             return fail(Error.MARKET_NOT_FRESH, FailureInfo.BORROW_FRESHNESS_CHECK);
1536         }
1537 
1538         /* Fail gracefully if protocol has insufficient underlying cash */
1539         if (getCashPrior() < borrowAmount) {
1540             return fail(Error.TOKEN_INSUFFICIENT_CASH, FailureInfo.BORROW_CASH_NOT_AVAILABLE);
1541         }
1542 
1543         BorrowLocalVars memory vars;
1544 
1545         /*
1546          * We calculate the new borrower and total borrow balances, failing on overflow:
1547          *  accountBorrowsNew = accountBorrows + borrowAmount
1548          *  totalBorrowsNew = totalBorrows + borrowAmount
1549          */
1550         (vars.mathErr, vars.accountBorrows) = borrowBalanceStoredInternal(borrower);
1551         if (vars.mathErr != MathError.NO_ERROR) {
1552             return failOpaque(Error.MATH_ERROR, FailureInfo.BORROW_ACCUMULATED_BALANCE_CALCULATION_FAILED, uint(vars.mathErr));
1553         }
1554 
1555         (vars.mathErr, vars.accountBorrowsNew) = addUInt(vars.accountBorrows, borrowAmount);
1556         if (vars.mathErr != MathError.NO_ERROR) {
1557             return failOpaque(Error.MATH_ERROR, FailureInfo.BORROW_NEW_ACCOUNT_BORROW_BALANCE_CALCULATION_FAILED, uint(vars.mathErr));
1558         }
1559 
1560         (vars.mathErr, vars.totalBorrowsNew) = addUInt(totalBorrows, borrowAmount);
1561         if (vars.mathErr != MathError.NO_ERROR) {
1562             return failOpaque(Error.MATH_ERROR, FailureInfo.BORROW_NEW_TOTAL_BALANCE_CALCULATION_FAILED, uint(vars.mathErr));
1563         }
1564 
1565         /////////////////////////
1566         // EFFECTS & INTERACTIONS
1567         // (No safe failures beyond this point)
1568 
1569         /*
1570          * We invoke doTransferOut for the borrower and the borrowAmount.
1571          *  Note: The aToken must handle variations between ERC-20 and ETH underlying.
1572          *  On success, the aToken borrowAmount less of cash.
1573          *  If doTransferOut fails despite the fact we checked pre-conditions,
1574          *   we revert because we can't be sure if side effects occurred.
1575          */
1576         vars.err = doTransferOut(borrower, borrowAmount);
1577         require(vars.err == Error.NO_ERROR, "borrow transfer out failed");
1578 
1579         /* We write the previously calculated values into storage */
1580         accountBorrows[borrower].principal = vars.accountBorrowsNew;
1581         accountBorrows[borrower].interestIndex = borrowIndex;
1582         totalBorrows = vars.totalBorrowsNew;
1583 
1584         /* We emit a Borrow event */
1585         emit Borrow(borrower, borrowAmount, vars.accountBorrowsNew, vars.totalBorrowsNew);
1586 
1587         /* We call the defense hook */
1588         controller.borrowVerify(address(this), borrower, borrowAmount);
1589 
1590         return uint(Error.NO_ERROR);
1591     }
1592 
1593     /**
1594      * @notice Sender repays their own borrow
1595      * @param repayAmount The amount to repay
1596      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
1597      */
1598     function repayBorrowInternal(uint repayAmount) internal nonReentrant returns (uint) {
1599         uint error = accrueInterest();
1600         if (error != uint(Error.NO_ERROR)) {
1601             // accrueInterest emits logs on errors, but we still want to log the fact that an attempted borrow failed
1602             return fail(Error(error), FailureInfo.REPAY_BORROW_ACCRUE_INTEREST_FAILED);
1603         }
1604         // repayBorrowFresh emits repay-borrow-specific logs on errors, so we don't need to
1605         return repayBorrowFresh(msg.sender, msg.sender, repayAmount);
1606     }
1607 
1608     /**
1609      * @notice Sender repays a borrow belonging to borrower
1610      * @param borrower the account with the debt being payed off
1611      * @param repayAmount The amount to repay
1612      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
1613      */
1614     function repayBorrowBehalfInternal(address borrower, uint repayAmount) internal nonReentrant returns (uint) {
1615         uint error = accrueInterest();
1616         if (error != uint(Error.NO_ERROR)) {
1617             // accrueInterest emits logs on errors, but we still want to log the fact that an attempted borrow failed
1618             return fail(Error(error), FailureInfo.REPAY_BEHALF_ACCRUE_INTEREST_FAILED);
1619         }
1620         // repayBorrowFresh emits repay-borrow-specific logs on errors, so we don't need to
1621         return repayBorrowFresh(msg.sender, borrower, repayAmount);
1622     }
1623 
1624     struct RepayBorrowLocalVars {
1625         Error err;
1626         MathError mathErr;
1627         uint repayAmount;
1628         uint borrowerIndex;
1629         uint accountBorrows;
1630         uint accountBorrowsNew;
1631         uint totalBorrowsNew;
1632     }
1633 
1634     /**
1635      * @notice Borrows are repaid by another user (possibly the borrower).
1636      * @param payer the account paying off the borrow
1637      * @param borrower the account with the debt being payed off
1638      * @param repayAmount the amount of undelrying tokens being returned
1639      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
1640      */
1641     function repayBorrowFresh(address payer, address borrower, uint repayAmount) internal returns (uint) {
1642         /* Fail if repayBorrow not allowed */
1643         uint allowed = controller.repayBorrowAllowed(address(this), payer, borrower, repayAmount);
1644         if (allowed != 0) {
1645             return failOpaque(Error.CONTROLLER_REJECTION, FailureInfo.REPAY_BORROW_CONTROLLER_REJECTION, allowed);
1646         }
1647 
1648         /* Verify market's block number equals current block number */
1649         if (accrualBlockNumber != getBlockNumber()) {
1650             return fail(Error.MARKET_NOT_FRESH, FailureInfo.REPAY_BORROW_FRESHNESS_CHECK);
1651         }
1652 
1653         RepayBorrowLocalVars memory vars;
1654 
1655         /* We remember the original borrowerIndex for verification purposes */
1656         vars.borrowerIndex = accountBorrows[borrower].interestIndex;
1657 
1658         /* We fetch the amount the borrower owes, with accumulated interest */
1659         (vars.mathErr, vars.accountBorrows) = borrowBalanceStoredInternal(borrower);
1660         if (vars.mathErr != MathError.NO_ERROR) {
1661             return failOpaque(Error.MATH_ERROR, FailureInfo.REPAY_BORROW_ACCUMULATED_BALANCE_CALCULATION_FAILED, uint(vars.mathErr));
1662         }
1663 
1664         /* If repayAmount == -1, repayAmount = accountBorrows */
1665         if (repayAmount == uint(-1)) {
1666             vars.repayAmount = vars.accountBorrows;
1667         } else {
1668             vars.repayAmount = repayAmount;
1669         }
1670 
1671         /* Fail if checkTransferIn fails */
1672         vars.err = checkTransferIn(payer, vars.repayAmount);
1673         if (vars.err != Error.NO_ERROR) {
1674             return fail(vars.err, FailureInfo.REPAY_BORROW_TRANSFER_IN_NOT_POSSIBLE);
1675         }
1676 
1677         /*
1678          * We calculate the new borrower and total borrow balances, failing on underflow:
1679          *  accountBorrowsNew = accountBorrows - repayAmount
1680          *  totalBorrowsNew = totalBorrows - repayAmount
1681          */
1682         (vars.mathErr, vars.accountBorrowsNew) = subUInt(vars.accountBorrows, vars.repayAmount);
1683         if (vars.mathErr != MathError.NO_ERROR) {
1684             return failOpaque(Error.MATH_ERROR, FailureInfo.REPAY_BORROW_NEW_ACCOUNT_BORROW_BALANCE_CALCULATION_FAILED, uint(vars.mathErr));
1685         }
1686 
1687         (vars.mathErr, vars.totalBorrowsNew) = subUInt(totalBorrows, vars.repayAmount);
1688         if (vars.mathErr != MathError.NO_ERROR) {
1689             return failOpaque(Error.MATH_ERROR, FailureInfo.REPAY_BORROW_NEW_TOTAL_BALANCE_CALCULATION_FAILED, uint(vars.mathErr));
1690         }
1691 
1692         /////////////////////////
1693         // EFFECTS & INTERACTIONS
1694         // (No safe failures beyond this point)
1695 
1696         /*
1697          * We call doTransferIn for the payer and the repayAmount
1698          *  Note: The aToken must handle variations between ERC-20 and ETH underlying.
1699          *  On success, the aToken holds an additional repayAmount of cash.
1700          *  If doTransferIn fails despite the fact we checked pre-conditions,
1701          *   we revert because we can't be sure if side effects occurred.
1702          */
1703         vars.err = doTransferIn(payer, vars.repayAmount);
1704         require(vars.err == Error.NO_ERROR, "repay borrow transfer in failed");
1705 
1706         /* We write the previously calculated values into storage */
1707         accountBorrows[borrower].principal = vars.accountBorrowsNew;
1708         accountBorrows[borrower].interestIndex = borrowIndex;
1709         totalBorrows = vars.totalBorrowsNew;
1710 
1711         /* We emit a RepayBorrow event */
1712         emit RepayBorrow(payer, borrower, vars.repayAmount, vars.accountBorrowsNew, vars.totalBorrowsNew);
1713 
1714         /* We call the defense hook */
1715         controller.repayBorrowVerify(address(this), payer, borrower, vars.repayAmount, vars.borrowerIndex);
1716 
1717         return uint(Error.NO_ERROR);
1718     }
1719 
1720     /**
1721      * @notice The sender liquidates the borrowers collateral.
1722      *  The collateral seized is transferred to the liquidator.
1723      * @param borrower The borrower of this aToken to be liquidated
1724      * @param aTokenCollateral The market in which to seize collateral from the borrower
1725      * @param repayAmount The amount of the underlying borrowed asset to repay
1726      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
1727      */
1728     function liquidateBorrowInternal(address borrower, uint repayAmount, AToken aTokenCollateral) internal nonReentrant returns (uint) {
1729         uint error = accrueInterest();
1730         if (error != uint(Error.NO_ERROR)) {
1731             // accrueInterest emits logs on errors, but we still want to log the fact that an attempted liquidation failed
1732             return fail(Error(error), FailureInfo.LIQUIDATE_ACCRUE_BORROW_INTEREST_FAILED);
1733         }
1734 
1735         error = aTokenCollateral.accrueInterest();
1736         if (error != uint(Error.NO_ERROR)) {
1737             // accrueInterest emits logs on errors, but we still want to log the fact that an attempted liquidation failed
1738             return fail(Error(error), FailureInfo.LIQUIDATE_ACCRUE_COLLATERAL_INTEREST_FAILED);
1739         }
1740 
1741         // liquidateBorrowFresh emits borrow-specific logs on errors, so we don't need to
1742         return liquidateBorrowFresh(msg.sender, borrower, repayAmount, aTokenCollateral);
1743     }
1744 
1745     /**
1746      * @notice The liquidator liquidates the borrowers collateral.
1747      *  The collateral seized is transferred to the liquidator.
1748      * @param borrower The borrower of this aToken to be liquidated
1749      * @param liquidator The address repaying the borrow and seizing collateral
1750      * @param aTokenCollateral The market in which to seize collateral from the borrower
1751      * @param repayAmount The amount of the underlying borrowed asset to repay
1752      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
1753      */
1754     function liquidateBorrowFresh(address liquidator, address borrower, uint repayAmount, AToken aTokenCollateral) internal returns (uint) {
1755         /* Fail if liquidate not allowed */
1756         uint allowed = controller.liquidateBorrowAllowed(address(this), address(aTokenCollateral), liquidator, borrower, repayAmount);
1757         if (allowed != 0) {
1758             return failOpaque(Error.CONTROLLER_REJECTION, FailureInfo.LIQUIDATE_CONTROLLER_REJECTION, allowed);
1759         }
1760 
1761         /* Verify market's block number equals current block number */
1762         if (accrualBlockNumber != getBlockNumber()) {
1763             return fail(Error.MARKET_NOT_FRESH, FailureInfo.LIQUIDATE_FRESHNESS_CHECK);
1764         }
1765 
1766         /* Verify aTokenCollateral market's block number equals current block number */
1767         if (aTokenCollateral.accrualBlockNumber() != getBlockNumber()) {
1768             return fail(Error.MARKET_NOT_FRESH, FailureInfo.LIQUIDATE_COLLATERAL_FRESHNESS_CHECK);
1769         }
1770 
1771         /* Fail if borrower = liquidator */
1772         if (borrower == liquidator) {
1773             return fail(Error.INVALID_ACCOUNT_PAIR, FailureInfo.LIQUIDATE_LIQUIDATOR_IS_BORROWER);
1774         }
1775 
1776         /* Fail if repayAmount = 0 */
1777         if (repayAmount == 0) {
1778             return fail(Error.INVALID_CLOSE_AMOUNT_REQUESTED, FailureInfo.LIQUIDATE_CLOSE_AMOUNT_IS_ZERO);
1779         }
1780 
1781         /* Fail if repayAmount = -1 */
1782         if (repayAmount == uint(-1)) {
1783             return fail(Error.INVALID_CLOSE_AMOUNT_REQUESTED, FailureInfo.LIQUIDATE_CLOSE_AMOUNT_IS_UINT_MAX);
1784         }
1785 
1786         /* We calculate the number of collateral tokens that will be seized */
1787         (uint amountSeizeError, uint seizeTokens) = controller.liquidateCalculateSeizeTokens(address(this), address(aTokenCollateral), repayAmount);
1788         if (amountSeizeError != 0) {
1789             return failOpaque(Error.CONTROLLER_CALCULATION_ERROR, FailureInfo.LIQUIDATE_CONTROLLER_CALCULATE_AMOUNT_SEIZE_FAILED, amountSeizeError);
1790         }
1791 
1792         /* Fail if seizeTokens > borrower collateral token balance */
1793         if (seizeTokens > aTokenCollateral.balanceOf(borrower)) {
1794             return fail(Error.TOKEN_INSUFFICIENT_BALANCE, FailureInfo.LIQUIDATE_SEIZE_TOO_MUCH);
1795         }
1796 
1797         /* Fail if repayBorrow fails */
1798         uint repayBorrowError = repayBorrowFresh(liquidator, borrower, repayAmount);
1799         if (repayBorrowError != uint(Error.NO_ERROR)) {
1800             return fail(Error(repayBorrowError), FailureInfo.LIQUIDATE_REPAY_BORROW_FRESH_FAILED);
1801         }
1802 
1803         /* Revert if seize tokens fails (since we cannot be sure of side effects) */
1804         uint seizeError = aTokenCollateral.seize(liquidator, borrower, seizeTokens);
1805         require(seizeError == uint(Error.NO_ERROR), "token seizure failed");
1806 
1807         /* We emit a LiquidateBorrow event */
1808         emit LiquidateBorrow(liquidator, borrower, repayAmount, address(aTokenCollateral), seizeTokens);
1809 
1810         /* We call the defense hook */
1811         controller.liquidateBorrowVerify(address(this), address(aTokenCollateral), liquidator, borrower, repayAmount, seizeTokens);
1812 
1813         return uint(Error.NO_ERROR);
1814     }
1815 
1816     /**
1817      * @notice Transfers collateral tokens (this market) to the liquidator.
1818      * @dev Will fail unless called by another aToken during the process of liquidation.
1819      *  Its absolutely critical to use msg.sender as the borrowed aToken and not a parameter.
1820      * @param liquidator The account receiving seized collateral
1821      * @param borrower The account having collateral seized
1822      * @param seizeTokens The number of aTokens to seize
1823      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
1824      */
1825     function seize(address liquidator, address borrower, uint seizeTokens) external nonReentrant returns (uint) {
1826         /* Fail if seize not allowed */
1827         uint allowed = controller.seizeAllowed(address(this), msg.sender, liquidator, borrower, seizeTokens);
1828         if (allowed != 0) {
1829             return failOpaque(Error.CONTROLLER_REJECTION, FailureInfo.LIQUIDATE_SEIZE_CONTROLLER_REJECTION, allowed);
1830         }
1831 
1832         /* Fail if borrower = liquidator */
1833         if (borrower == liquidator) {
1834             return fail(Error.INVALID_ACCOUNT_PAIR, FailureInfo.LIQUIDATE_SEIZE_LIQUIDATOR_IS_BORROWER);
1835         }
1836 
1837         MathError mathErr;
1838         uint borrowerTokensNew;
1839         uint liquidatorTokensNew;
1840 
1841         /*
1842          * We calculate the new borrower and liquidator token balances, failing on underflow/overflow:
1843          *  borrowerTokensNew = accountTokens[borrower] - seizeTokens
1844          *  liquidatorTokensNew = accountTokens[liquidator] + seizeTokens
1845          */
1846         (mathErr, borrowerTokensNew) = subUInt(accountTokens[borrower], seizeTokens);
1847         if (mathErr != MathError.NO_ERROR) {
1848             return failOpaque(Error.MATH_ERROR, FailureInfo.LIQUIDATE_SEIZE_BALANCE_DECREMENT_FAILED, uint(mathErr));
1849         }
1850 
1851         (mathErr, liquidatorTokensNew) = addUInt(accountTokens[liquidator], seizeTokens);
1852         if (mathErr != MathError.NO_ERROR) {
1853             return failOpaque(Error.MATH_ERROR, FailureInfo.LIQUIDATE_SEIZE_BALANCE_INCREMENT_FAILED, uint(mathErr));
1854         }
1855 
1856         /////////////////////////
1857         // EFFECTS & INTERACTIONS
1858         // (No safe failures beyond this point)
1859 
1860         /* We write the previously calculated values into storage */
1861         accountTokens[borrower] = borrowerTokensNew;
1862         accountTokens[liquidator] = liquidatorTokensNew;
1863 
1864         /* Emit a Transfer event */
1865         emit Transfer(borrower, liquidator, seizeTokens);
1866 
1867         /* We call the defense hook */
1868         controller.seizeVerify(address(this), msg.sender, liquidator, borrower, seizeTokens);
1869 
1870         return uint(Error.NO_ERROR);
1871     }
1872 
1873 
1874     /*** Admin Functions ***/
1875 
1876     /**
1877       * @notice Begins transfer of admin rights. The newPendingAdmin must call `_acceptAdmin` to finalize the transfer.
1878       * @dev Admin function to begin change of admin. The newPendingAdmin must call `_acceptAdmin` to finalize the transfer.
1879       * @param newPendingAdmin New pending admin.
1880       * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
1881       *
1882       * TODO: Should we add a second arg to verify, like a checksum of `newAdmin` address?
1883       */
1884     function _setPendingAdmin(address payable newPendingAdmin) external returns (uint) {
1885         // Check caller = admin
1886         if (msg.sender != admin) {
1887             return fail(Error.UNAUTHORIZED, FailureInfo.SET_PENDING_ADMIN_OWNER_CHECK);
1888         }
1889 
1890         // Save current value, if any, for inclusion in log
1891         address oldPendingAdmin = pendingAdmin;
1892 
1893         // Store pendingAdmin with value newPendingAdmin
1894         pendingAdmin = newPendingAdmin;
1895 
1896         // Emit NewPendingAdmin(oldPendingAdmin, newPendingAdmin)
1897         emit NewPendingAdmin(oldPendingAdmin, newPendingAdmin);
1898 
1899         return uint(Error.NO_ERROR);
1900     }
1901 
1902     /**
1903       * @notice Accepts transfer of admin rights. msg.sender must be pendingAdmin
1904       * @dev Admin function for pending admin to accept role and update admin
1905       * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
1906       */
1907     function _acceptAdmin() external returns (uint) {
1908         // Check caller is pendingAdmin and pendingAdmin ≠ address(0)
1909         if (msg.sender != pendingAdmin || msg.sender == address(0)) {
1910             return fail(Error.UNAUTHORIZED, FailureInfo.ACCEPT_ADMIN_PENDING_ADMIN_CHECK);
1911         }
1912 
1913         // Save current values for inclusion in log
1914         address oldAdmin = admin;
1915         address oldPendingAdmin = pendingAdmin;
1916 
1917         // Store admin with value pendingAdmin
1918         admin = pendingAdmin;
1919 
1920         // Clear the pending value
1921         pendingAdmin = address(0);
1922 
1923         emit NewAdmin(oldAdmin, admin);
1924         emit NewPendingAdmin(oldPendingAdmin, pendingAdmin);
1925 
1926         return uint(Error.NO_ERROR);
1927     }
1928 
1929     /**
1930       * @notice Sets a new controller for the market
1931       * @dev Admin function to set a new controller
1932       * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
1933       */
1934     function _setController(ControllerInterface newController) public returns (uint) {
1935         // Check caller is admin
1936         if (msg.sender != admin) {
1937             return fail(Error.UNAUTHORIZED, FailureInfo.SET_CONTROLLER_OWNER_CHECK);
1938         }
1939 
1940         ControllerInterface oldController = controller;
1941         
1942         // Ensure invoke controller.isController() returns true
1943         require(newController.isController(), "marker method returned false");
1944 
1945         // Set market's controller to newController
1946         controller = newController;
1947 
1948         // Emit NewControllerr(oldController, newController)
1949         emit NewController(oldController, newController);
1950 
1951         return uint(Error.NO_ERROR);
1952     }
1953 
1954     /**
1955       * @notice accrues interest and sets a new reserve factor for the protocol using _setReserveFactorFresh
1956       * @dev Admin function to accrue interest and set a new reserve factor
1957       * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
1958       */
1959     function _setReserveFactor(uint newReserveFactorMantissa) external nonReentrant returns (uint) {
1960         uint error = accrueInterest();
1961         if (error != uint(Error.NO_ERROR)) {
1962             // accrueInterest emits logs on errors, but on top of that we want to log the fact that an attempted reserve factor change failed.
1963             return fail(Error(error), FailureInfo.SET_RESERVE_FACTOR_ACCRUE_INTEREST_FAILED);
1964         }
1965         // _setReserveFactorFresh emits reserve-factor-specific logs on errors, so we don't need to.
1966         return _setReserveFactorFresh(newReserveFactorMantissa);
1967     }
1968 
1969     /**
1970       * @notice Sets a new reserve factor for the protocol (*requires fresh interest accrual)
1971       * @dev Admin function to set a new reserve factor
1972       * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
1973       */
1974     function _setReserveFactorFresh(uint newReserveFactorMantissa) internal returns (uint) {
1975         // Check caller is admin
1976         if (msg.sender != admin) {
1977             return fail(Error.UNAUTHORIZED, FailureInfo.SET_RESERVE_FACTOR_ADMIN_CHECK);
1978         }
1979 
1980         // Verify market's block number equals current block number
1981         if (accrualBlockNumber != getBlockNumber()) {
1982             // TODO: static_assert + no error code?
1983             return fail(Error.MARKET_NOT_FRESH, FailureInfo.SET_RESERVE_FACTOR_FRESH_CHECK);
1984         }
1985 
1986         // Check newReserveFactor ≤ maxReserveFactor
1987         if (newReserveFactorMantissa > reserveFactorMaxMantissa) {
1988             return fail(Error.BAD_INPUT, FailureInfo.SET_RESERVE_FACTOR_BOUNDS_CHECK);
1989         }
1990 
1991         uint oldReserveFactorMantissa = reserveFactorMantissa;
1992         reserveFactorMantissa = newReserveFactorMantissa;
1993 
1994         emit NewReserveFactor(oldReserveFactorMantissa, newReserveFactorMantissa);
1995 
1996         return uint(Error.NO_ERROR);
1997     }
1998 
1999     /**
2000      * @notice Accrues interest and reduces reserves by transferring to admin
2001      * @param reduceAmount Amount of reduction to reserves
2002      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
2003      */
2004     function _reduceReserves(uint reduceAmount) external nonReentrant returns (uint) {
2005         uint error = accrueInterest();
2006         if (error != uint(Error.NO_ERROR)) {
2007             // accrueInterest emits logs on errors, but on top of that we want to log the fact that an attempted reduce reserves failed.
2008             return fail(Error(error), FailureInfo.REDUCE_RESERVES_ACCRUE_INTEREST_FAILED);
2009         }
2010         // _reduceReservesFresh emits reserve-reduction-specific logs on errors, so we don't need to.
2011         return _reduceReservesFresh(reduceAmount);
2012     }
2013 
2014     /**
2015      * @notice Reduces reserves by transferring to admin
2016      * @dev Requires fresh interest accrual
2017      * @param reduceAmount Amount of reduction to reserves
2018      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
2019      */
2020     function _reduceReservesFresh(uint reduceAmount) internal returns (uint) {
2021         Error err;
2022         // totalReserves - reduceAmount
2023         uint totalReservesNew;
2024 
2025         // Check caller is admin
2026         if (msg.sender != admin) {
2027             return fail(Error.UNAUTHORIZED, FailureInfo.REDUCE_RESERVES_ADMIN_CHECK);
2028         }
2029 
2030         // We fail gracefully unless market's block number equals current block number
2031         if (accrualBlockNumber != getBlockNumber()) {
2032             // TODO: static_assert + no error code?
2033             return fail(Error.MARKET_NOT_FRESH, FailureInfo.REDUCE_RESERVES_FRESH_CHECK);
2034         }
2035 
2036         // Fail gracefully if protocol has insufficient underlying cash
2037         if (getCashPrior() < reduceAmount) {
2038             return fail(Error.TOKEN_INSUFFICIENT_CASH, FailureInfo.REDUCE_RESERVES_CASH_NOT_AVAILABLE);
2039         }
2040 
2041         // Check reduceAmount ≤ reserves[n] (totalReserves)
2042         // TODO: I'm following the spec literally here but I think we should we just use SafeMath instead and fail on an error (which would be underflow)
2043         if (reduceAmount > totalReserves) {
2044             return fail(Error.BAD_INPUT, FailureInfo.REDUCE_RESERVES_VALIDATION);
2045         }
2046 
2047         /////////////////////////
2048         // EFFECTS & INTERACTIONS
2049         // (No safe failures beyond this point)
2050 
2051         totalReservesNew = totalReserves - reduceAmount;
2052         // We checked reduceAmount <= totalReserves above, so this should never revert.
2053         require(totalReservesNew <= totalReserves, "reduce reserves unexpected underflow");
2054 
2055         // Store reserves[n+1] = reserves[n] - reduceAmount
2056         totalReserves = totalReservesNew;
2057 
2058         // invoke doTransferOut(reduceAmount, admin)
2059         err = doTransferOut(admin, reduceAmount);
2060         // we revert on the failure of this command
2061         require(err == Error.NO_ERROR, "reduce reserves transfer out failed");
2062 
2063         emit ReservesReduced(admin, reduceAmount, totalReservesNew);
2064 
2065         return uint(Error.NO_ERROR);
2066     }
2067 
2068     /**
2069      * @notice accrues interest and updates the interest rate model using _setInterestRateModelFresh
2070      * @dev Admin function to accrue interest and update the interest rate model
2071      * @param newInterestRateModel the new interest rate model to use
2072      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
2073      */
2074     function _setInterestRateModel(InterestRateModel newInterestRateModel) public returns (uint) {
2075         uint error = accrueInterest();
2076         if (error != uint(Error.NO_ERROR)) {
2077             // accrueInterest emits logs on errors, but on top of that we want to log the fact that an attempted change of interest rate model failed
2078             return fail(Error(error), FailureInfo.SET_INTEREST_RATE_MODEL_ACCRUE_INTEREST_FAILED);
2079         }
2080         // _setInterestRateModelFresh emits interest-rate-model-update-specific logs on errors, so we don't need to.
2081         return _setInterestRateModelFresh(newInterestRateModel);
2082     }
2083 
2084     function _setInterestRateModel_init(InterestRateModel newInterestRateModel) public returns (uint) {
2085         if (msg.sender != admin) {
2086             return fail(Error.MARKET_NOT_FRESH, FailureInfo.SET_INTEREST_RATE_MODEL_FRESH_CHECK);
2087         }
2088         // _setInterestRateModelFresh emits interest-rate-model-update-specific logs on errors, so we don't need to.
2089         interestRateModel = newInterestRateModel;
2090         _setInterestRateModelFresh(interestRateModel);
2091     }
2092     
2093     /**
2094      * @notice updates the interest rate model (*requires fresh interest accrual)
2095      * @dev Admin function to update the interest rate model
2096      * @param newInterestRateModel the new interest rate model to use
2097      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
2098      */
2099     function _setInterestRateModelFresh(InterestRateModel newInterestRateModel) internal returns (uint) {
2100 
2101         // Used to store old model for use in the event that is emitted on success
2102         InterestRateModel oldInterestRateModel;
2103 
2104         // Check caller is admin
2105         if (msg.sender != admin) {
2106             return fail(Error.UNAUTHORIZED, FailureInfo.SET_INTEREST_RATE_MODEL_OWNER_CHECK);
2107         }
2108 
2109         // We fail gracefully unless market's block number equals current block number
2110         if (accrualBlockNumber != getBlockNumber()) {
2111             // TODO: static_assert + no error code?
2112             return fail(Error.MARKET_NOT_FRESH, FailureInfo.SET_INTEREST_RATE_MODEL_FRESH_CHECK);
2113         }
2114 
2115         // Track the market's current interest rate model
2116         oldInterestRateModel = interestRateModel;
2117 
2118         // Ensure invoke newInterestRateModel.isInterestRateModel() returns true
2119         require(newInterestRateModel.isInterestRateModel(), "marker method returned false");
2120 
2121         // Set the interest rate model to newInterestRateModel
2122         interestRateModel = newInterestRateModel;
2123 
2124         // Emit NewMarketInterestRateModel(oldInterestRateModel, newInterestRateModel)
2125         emit NewMarketInterestRateModel(oldInterestRateModel, newInterestRateModel);
2126 
2127         return uint(Error.NO_ERROR);
2128     }
2129 
2130     
2131     /*** Safe Token ***/
2132 
2133     /**
2134      * @notice Gets balance of this contract in terms of the underlying
2135      * @dev This excludes the value of the current message, if any
2136      * @return The quantity of underlying owned by this contract
2137      */
2138     function getCashPrior() internal view returns (uint);
2139 
2140     /**
2141      * @dev Checks whether or not there is sufficient allowance for this contract to move amount from `from` and
2142      *      whether or not `from` has a balance of at least `amount`. Does NOT do a transfer.
2143      */
2144     function checkTransferIn(address from, uint amount) internal view returns (Error);
2145 
2146     /**
2147      * @dev Performs a transfer in, ideally returning an explanatory error code upon failure rather than reverting.
2148      *  If caller has not called `checkTransferIn`, this may revert due to insufficient balance or insufficient allowance.
2149      *  If caller has called `checkTransferIn` successfully, this should not revert in normal conditions.
2150      */
2151     function doTransferIn(address from, uint amount) internal returns (Error);
2152 
2153     /**
2154      * @dev Performs a transfer out, ideally returning an explanatory error code upon failure tather than reverting.
2155      *  If caller has not called checked protocol's balance, may revert due to insufficient cash held in the contract.
2156      *  If caller has checked protocol's balance, and verified it is >= amount, this should not revert in normal conditions.
2157      */
2158     function doTransferOut(address payable to, uint amount) internal returns (Error);
2159 }
2160 
2161 
2162 
2163 contract AErc20 is AToken {
2164 
2165     /**
2166      * @notice Underlying asset for this AToken
2167      */
2168     address public underlying;
2169 
2170     /*** User Interface ***/
2171 
2172     /**
2173      * @notice Sender supplies assets into the market and receives aTokens in exchange
2174      * @dev Accrues interest whether or not the operation succeeds, unless reverted
2175      * @param mintAmount The amount of the underlying asset to supply
2176      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
2177      */
2178     function mint(uint mintAmount) external returns (uint) {
2179         return mintInternal(mintAmount);
2180     }
2181 
2182     /**
2183      * @notice Sender redeems aTokens in exchange for the underlying asset
2184      * @dev Accrues interest whether or not the operation succeeds, unless reverted
2185      * @param redeemTokens The number of aTokens to redeem into underlying
2186      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
2187      */
2188     function redeem(uint redeemTokens) external returns (uint) {
2189         return redeemInternal(redeemTokens);
2190     }
2191 
2192     /**
2193      * @notice Sender redeems aTokens in exchange for a specified amount of underlying asset
2194      * @dev Accrues interest whether or not the operation succeeds, unless reverted
2195      * @param redeemAmount The amount of underlying to redeem
2196      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
2197      */
2198     function redeemUnderlying(uint redeemAmount) external returns (uint) {
2199         return redeemUnderlyingInternal(redeemAmount);
2200     }
2201 
2202     /**
2203       * @notice Sender borrows assets from the protocol to their own address
2204       * @param borrowAmount The amount of the underlying asset to borrow
2205       * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
2206       */
2207     function borrow(uint borrowAmount) external returns (uint) {
2208         return borrowInternal(borrowAmount);
2209     }
2210 
2211     /**
2212      * @notice Sender repays their own borrow
2213      * @param repayAmount The amount to repay
2214      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
2215      */
2216     function repayBorrow(uint repayAmount) external returns (uint) {
2217         return repayBorrowInternal(repayAmount);
2218     }
2219 
2220     /**
2221      * @notice Sender repays a borrow belonging to borrower
2222      * @param borrower the account with the debt being payed off
2223      * @param repayAmount The amount to repay
2224      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
2225      */
2226     function repayBorrowBehalf(address borrower, uint repayAmount) external returns (uint) {
2227         return repayBorrowBehalfInternal(borrower, repayAmount);
2228     }
2229 
2230     /**
2231      * @notice The sender liquidates the borrowers collateral.
2232      *  The collateral seized is transferred to the liquidator.
2233      * @param borrower The borrower of this aToken to be liquidated
2234      * @param aTokenCollateral The market in which to seize collateral from the borrower
2235      * @param repayAmount The amount of the underlying borrowed asset to repay
2236      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
2237      */
2238     function liquidateBorrow(address borrower, uint repayAmount, AToken aTokenCollateral) external returns (uint) {
2239         return liquidateBorrowInternal(borrower, repayAmount, aTokenCollateral);
2240     }
2241 
2242     /*** Safe Token ***/
2243 
2244     /**
2245      * @notice Gets balance of this contract in terms of the underlying
2246      * @dev This excludes the value of the current message, if any
2247      * @return The quantity of underlying tokens owned by this contract
2248      */
2249     function getCashPrior() internal view returns (uint) {
2250         EIP20Interface token = EIP20Interface(underlying);
2251         return token.balanceOf(address(this));
2252     }
2253 
2254     /**
2255      * @dev Checks whether or not there is sufficient allowance for this contract to move amount from `from` and
2256      *      whether or not `from` has a balance of at least `amount`. Does NOT do a transfer.
2257      */
2258     function checkTransferIn(address from, uint amount) internal view returns (Error) {
2259         EIP20Interface token = EIP20Interface(underlying);
2260 
2261         if (token.allowance(from, address(this)) < amount) {
2262             return Error.TOKEN_INSUFFICIENT_ALLOWANCE;
2263         }
2264 
2265         if (token.balanceOf(from) < amount) {
2266             return Error.TOKEN_INSUFFICIENT_BALANCE;
2267         }
2268 
2269         return Error.NO_ERROR;
2270     }
2271 
2272     /**
2273      * @dev Similar to EIP20 transfer, except it handles a False result from `transferFrom` and returns an explanatory
2274      *      error code rather than reverting.  If caller has not called `checkTransferIn`, this may revert due to
2275      *      insufficient balance or insufficient allowance. If caller has called `checkTransferIn` prior to this call,
2276      *      and it returned Error.NO_ERROR, this should not revert in normal conditions.
2277      *
2278      *      Note: This wrapper safely handles non-standard ERC-20 tokens that do not return a value.
2279      *            See here: https://medium.com/coinmonks/missing-return-value-bug-at-least-130-tokens-affected-d67bf08521ca
2280      */
2281     function doTransferIn(address from, uint amount) internal returns (Error) {
2282         EIP20NonStandardInterface token = EIP20NonStandardInterface(underlying);
2283         bool result;
2284 
2285         token.transferFrom(from, address(this), amount);
2286 
2287         // solium-disable-next-line security/no-inline-assembly
2288         assembly {
2289             switch returndatasize()
2290                 case 0 {                      // This is a non-standard ERC-20
2291                     result := not(0)          // set result to true
2292                 }
2293                 case 32 {                     // This is a complaint ERC-20
2294                     returndatacopy(0, 0, 32)
2295                     result := mload(0)        // Set `result = returndata` of external call
2296                 }
2297                 default {                     // This is an excessively non-compliant ERC-20, revert.
2298                     revert(0, 0)
2299                 }
2300         }
2301 
2302         if (!result) {
2303             return Error.TOKEN_TRANSFER_IN_FAILED;
2304         }
2305 
2306         return Error.NO_ERROR;
2307     }
2308 
2309     /**
2310      * @dev Similar to EIP20 transfer, except it handles a False result from `transfer` and returns an explanatory
2311      *      error code rather than reverting. If caller has not called checked protocol's balance, this may revert due to
2312      *      insufficient cash held in this contract. If caller has checked protocol's balance prior to this call, and verified
2313      *      it is >= amount, this should not revert in normal conditions.
2314      *
2315      *      Note: This wrapper safely handles non-standard ERC-20 tokens that do not return a value.
2316      *            See here: https://medium.com/coinmonks/missing-return-value-bug-at-least-130-tokens-affected-d67bf08521ca
2317      */
2318     function doTransferOut(address payable to, uint amount) internal returns (Error) {
2319         EIP20NonStandardInterface token = EIP20NonStandardInterface(underlying);
2320         bool result;
2321 
2322         token.transfer(to, amount);
2323 
2324         // solium-disable-next-line security/no-inline-assembly
2325         assembly {
2326             switch returndatasize()
2327                 case 0 {                      // This is a non-standard ERC-20
2328                     result := not(0)          // set result to true
2329                 }
2330                 case 32 {                     // This is a complaint ERC-20
2331                     returndatacopy(0, 0, 32)
2332                     result := mload(0)        // Set `result = returndata` of external call
2333                 }
2334                 default {                     // This is an excessively non-compliant ERC-20, revert.
2335                     revert(0, 0)
2336                 }
2337         }
2338 
2339         if (!result) {
2340             return Error.TOKEN_TRANSFER_OUT_FAILED;
2341         }
2342 
2343         return Error.NO_ERROR;
2344     }
2345     
2346     function _setUnderlying(address newunderlying) public returns (uint) {
2347         // Check caller is admin
2348         if (msg.sender != admin) {
2349             return fail(Error.UNAUTHORIZED, FailureInfo.SET_CONTROLLER_OWNER_CHECK);
2350         }
2351 
2352         // Set market's controller to newController
2353         underlying = newunderlying;
2354         EIP20Interface(underlying).totalSupply(); // Sanity check the underlying
2355         
2356         return uint(Error.NO_ERROR);
2357     } 
2358 }