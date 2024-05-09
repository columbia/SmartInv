1 
2 // File: contracts/ComptrollerInterface.sol
3 
4 pragma solidity ^0.5.8;
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
80 // File: contracts/ErrorReporter.sol
81 
82 pragma solidity ^0.5.8;
83 
84 contract ComptrollerErrorReporter {
85     enum Error {
86         NO_ERROR,
87         UNAUTHORIZED,
88         COMPTROLLER_MISMATCH,
89         INSUFFICIENT_SHORTFALL,
90         INSUFFICIENT_LIQUIDITY,
91         INVALID_CLOSE_FACTOR,
92         INVALID_COLLATERAL_FACTOR,
93         INVALID_LIQUIDATION_INCENTIVE,
94         MARKET_NOT_ENTERED,
95         MARKET_NOT_LISTED,
96         MARKET_ALREADY_LISTED,
97         MATH_ERROR,
98         NONZERO_BORROW_BALANCE,
99         PRICE_ERROR,
100         REJECTION,
101         SNAPSHOT_ERROR,
102         TOO_MANY_ASSETS,
103         TOO_MUCH_REPAY
104     }
105 
106     enum FailureInfo {
107         ACCEPT_ADMIN_PENDING_ADMIN_CHECK,
108         ACCEPT_PENDING_IMPLEMENTATION_ADDRESS_CHECK,
109         EXIT_MARKET_BALANCE_OWED,
110         EXIT_MARKET_REJECTION,
111         SET_CLOSE_FACTOR_OWNER_CHECK,
112         SET_CLOSE_FACTOR_VALIDATION,
113         SET_COLLATERAL_FACTOR_OWNER_CHECK,
114         SET_COLLATERAL_FACTOR_NO_EXISTS,
115         SET_COLLATERAL_FACTOR_VALIDATION,
116         SET_COLLATERAL_FACTOR_WITHOUT_PRICE,
117         SET_IMPLEMENTATION_OWNER_CHECK,
118         SET_LIQUIDATION_INCENTIVE_OWNER_CHECK,
119         SET_LIQUIDATION_INCENTIVE_VALIDATION,
120         SET_MAX_ASSETS_OWNER_CHECK,
121         SET_PENDING_ADMIN_OWNER_CHECK,
122         SET_PENDING_IMPLEMENTATION_OWNER_CHECK,
123         SET_PRICE_ORACLE_OWNER_CHECK,
124         SUPPORT_MARKET_EXISTS,
125         SUPPORT_MARKET_OWNER_CHECK,
126         ZUNUSED
127     }
128 
129     /**
130       * @dev `error` corresponds to enum Error; `info` corresponds to enum FailureInfo, and `detail` is an arbitrary
131       * contract-specific code that enables us to report opaque error codes from upgradeable contracts.
132       **/
133     event Failure(uint error, uint info, uint detail);
134 
135     /**
136       * @dev use this when reporting a known error from the money market or a non-upgradeable collaborator
137       */
138     function fail(Error err, FailureInfo info) internal returns (uint) {
139         emit Failure(uint(err), uint(info), 0);
140 
141         return uint(err);
142     }
143 
144     /**
145       * @dev use this when reporting an opaque error from an upgradeable collaborator contract
146       */
147     function failOpaque(Error err, FailureInfo info, uint opaqueError) internal returns (uint) {
148         emit Failure(uint(err), uint(info), opaqueError);
149 
150         return uint(err);
151     }
152 }
153 
154 contract TokenErrorReporter {
155     enum Error {
156         NO_ERROR,
157         UNAUTHORIZED,
158         BAD_INPUT,
159         COMPTROLLER_REJECTION,
160         COMPTROLLER_CALCULATION_ERROR,
161         INTEREST_RATE_MODEL_ERROR,
162         INVALID_ACCOUNT_PAIR,
163         INVALID_CLOSE_AMOUNT_REQUESTED,
164         INVALID_COLLATERAL_FACTOR,
165         MATH_ERROR,
166         MARKET_NOT_FRESH,
167         MARKET_NOT_LISTED,
168         TOKEN_INSUFFICIENT_ALLOWANCE,
169         TOKEN_INSUFFICIENT_BALANCE,
170         TOKEN_INSUFFICIENT_CASH,
171         TOKEN_TRANSFER_IN_FAILED,
172         TOKEN_TRANSFER_OUT_FAILED
173     }
174 
175     /*
176      * Note: FailureInfo (but not Error) is kept in alphabetical order
177      *       This is because FailureInfo grows significantly faster, and
178      *       the order of Error has some meaning, while the order of FailureInfo
179      *       is entirely arbitrary.
180      */
181     enum FailureInfo {
182         ACCEPT_ADMIN_PENDING_ADMIN_CHECK,
183         ACCRUE_INTEREST_ACCUMULATED_INTEREST_CALCULATION_FAILED,
184         ACCRUE_INTEREST_BORROW_RATE_CALCULATION_FAILED,
185         ACCRUE_INTEREST_NEW_BORROW_INDEX_CALCULATION_FAILED,
186         ACCRUE_INTEREST_NEW_TOTAL_BORROWS_CALCULATION_FAILED,
187         ACCRUE_INTEREST_NEW_TOTAL_RESERVES_CALCULATION_FAILED,
188         ACCRUE_INTEREST_SIMPLE_INTEREST_FACTOR_CALCULATION_FAILED,
189         BORROW_ACCUMULATED_BALANCE_CALCULATION_FAILED,
190         BORROW_ACCRUE_INTEREST_FAILED,
191         BORROW_CASH_NOT_AVAILABLE,
192         BORROW_FRESHNESS_CHECK,
193         BORROW_NEW_TOTAL_BALANCE_CALCULATION_FAILED,
194         BORROW_NEW_ACCOUNT_BORROW_BALANCE_CALCULATION_FAILED,
195         BORROW_MARKET_NOT_LISTED,
196         BORROW_COMPTROLLER_REJECTION,
197         LIQUIDATE_ACCRUE_BORROW_INTEREST_FAILED,
198         LIQUIDATE_ACCRUE_COLLATERAL_INTEREST_FAILED,
199         LIQUIDATE_COLLATERAL_FRESHNESS_CHECK,
200         LIQUIDATE_COMPTROLLER_REJECTION,
201         LIQUIDATE_COMPTROLLER_CALCULATE_AMOUNT_SEIZE_FAILED,
202         LIQUIDATE_CLOSE_AMOUNT_IS_UINT_MAX,
203         LIQUIDATE_CLOSE_AMOUNT_IS_ZERO,
204         LIQUIDATE_FRESHNESS_CHECK,
205         LIQUIDATE_LIQUIDATOR_IS_BORROWER,
206         LIQUIDATE_REPAY_BORROW_FRESH_FAILED,
207         LIQUIDATE_SEIZE_BALANCE_INCREMENT_FAILED,
208         LIQUIDATE_SEIZE_BALANCE_DECREMENT_FAILED,
209         LIQUIDATE_SEIZE_COMPTROLLER_REJECTION,
210         LIQUIDATE_SEIZE_LIQUIDATOR_IS_BORROWER,
211         LIQUIDATE_SEIZE_TOO_MUCH,
212         MINT_ACCRUE_INTEREST_FAILED,
213         MINT_COMPTROLLER_REJECTION,
214         MINT_EXCHANGE_CALCULATION_FAILED,
215         MINT_EXCHANGE_RATE_READ_FAILED,
216         MINT_FRESHNESS_CHECK,
217         MINT_NEW_ACCOUNT_BALANCE_CALCULATION_FAILED,
218         MINT_NEW_TOTAL_SUPPLY_CALCULATION_FAILED,
219         MINT_TRANSFER_IN_FAILED,
220         MINT_TRANSFER_IN_NOT_POSSIBLE,
221         REDEEM_ACCRUE_INTEREST_FAILED,
222         REDEEM_COMPTROLLER_REJECTION,
223         REDEEM_EXCHANGE_TOKENS_CALCULATION_FAILED,
224         REDEEM_EXCHANGE_AMOUNT_CALCULATION_FAILED,
225         REDEEM_EXCHANGE_RATE_READ_FAILED,
226         REDEEM_FRESHNESS_CHECK,
227         REDEEM_NEW_ACCOUNT_BALANCE_CALCULATION_FAILED,
228         REDEEM_NEW_TOTAL_SUPPLY_CALCULATION_FAILED,
229         REDEEM_TRANSFER_OUT_NOT_POSSIBLE,
230         REDUCE_RESERVES_ACCRUE_INTEREST_FAILED,
231         REDUCE_RESERVES_ADMIN_CHECK,
232         REDUCE_RESERVES_CASH_NOT_AVAILABLE,
233         REDUCE_RESERVES_FRESH_CHECK,
234         REDUCE_RESERVES_VALIDATION,
235         REPAY_BEHALF_ACCRUE_INTEREST_FAILED,
236         REPAY_BORROW_ACCRUE_INTEREST_FAILED,
237         REPAY_BORROW_ACCUMULATED_BALANCE_CALCULATION_FAILED,
238         REPAY_BORROW_COMPTROLLER_REJECTION,
239         REPAY_BORROW_FRESHNESS_CHECK,
240         REPAY_BORROW_NEW_ACCOUNT_BORROW_BALANCE_CALCULATION_FAILED,
241         REPAY_BORROW_NEW_TOTAL_BALANCE_CALCULATION_FAILED,
242         REPAY_BORROW_TRANSFER_IN_NOT_POSSIBLE,
243         SET_COLLATERAL_FACTOR_OWNER_CHECK,
244         SET_COLLATERAL_FACTOR_VALIDATION,
245         SET_COMPTROLLER_OWNER_CHECK,
246         SET_INTEREST_RATE_MODEL_ACCRUE_INTEREST_FAILED,
247         SET_INTEREST_RATE_MODEL_FRESH_CHECK,
248         SET_INTEREST_RATE_MODEL_OWNER_CHECK,
249         SET_MAX_ASSETS_OWNER_CHECK,
250         SET_ORACLE_MARKET_NOT_LISTED,
251         SET_PENDING_ADMIN_OWNER_CHECK,
252         SET_RESERVE_FACTOR_ACCRUE_INTEREST_FAILED,
253         SET_RESERVE_FACTOR_ADMIN_CHECK,
254         SET_RESERVE_FACTOR_FRESH_CHECK,
255         SET_RESERVE_FACTOR_BOUNDS_CHECK,
256         TRANSFER_COMPTROLLER_REJECTION,
257         TRANSFER_NOT_ALLOWED,
258         TRANSFER_NOT_ENOUGH,
259         TRANSFER_TOO_MUCH
260     }
261 
262     /**
263       * @dev `error` corresponds to enum Error; `info` corresponds to enum FailureInfo, and `detail` is an arbitrary
264       * contract-specific code that enables us to report opaque error codes from upgradeable contracts.
265       **/
266     event Failure(uint error, uint info, uint detail);
267 
268     /**
269       * @dev use this when reporting a known error from the money market or a non-upgradeable collaborator
270       */
271     function fail(Error err, FailureInfo info) internal returns (uint) {
272         emit Failure(uint(err), uint(info), 0);
273 
274         return uint(err);
275     }
276 
277     /**
278       * @dev use this when reporting an opaque error from an upgradeable collaborator contract
279       */
280     function failOpaque(Error err, FailureInfo info, uint opaqueError) internal returns (uint) {
281         emit Failure(uint(err), uint(info), opaqueError);
282 
283         return uint(err);
284     }
285 }
286 
287 contract OracleErrorReporter {
288     enum Error {
289         NO_ERROR,
290         UNAUTHORIZED,
291         FAILED_TO_SET_PRICE
292     }
293 
294     enum FailureInfo {
295         ACCEPT_ANCHOR_ADMIN_PENDING_ANCHOR_ADMIN_CHECK,
296         SET_PAUSED_OWNER_CHECK,
297         SET_PENDING_ANCHOR_ADMIN_OWNER_CHECK,
298         SET_PENDING_ANCHOR_PERMISSION_CHECK,
299         SET_PRICE_CALCULATE_SWING,
300         SET_PRICE_CAP_TO_MAX,
301         SET_PRICE_MAX_SWING_CHECK,
302         SET_PRICE_NO_ANCHOR_PRICE_OR_INITIAL_PRICE_ZERO,
303         SET_PRICE_PERMISSION_CHECK,
304         SET_PRICE_ZERO_PRICE,
305         SET_PRICES_PARAM_VALIDATION
306     }
307 
308     /**
309      * @dev `msgSender` is msg.sender; `error` corresponds to enum Error; `info` corresponds to enum OracleFailureInfo, and `detail` is an arbitrary
310      * contract-specific code that enables us to report opaque error codes from upgradeable contracts.
311      **/
312     event Failure(uint error, uint info, uint detail, address asset, address sender);
313 
314     /**
315      * @dev use this when reporting a known error from the price oracle or a non-upgradeable collaborator
316      *      Using Oracle in name because we already inherit a `fail` function from ErrorReporter.sol via Exponential.sol
317      */
318     function failOracle(address asset, Error err, FailureInfo info) internal returns (uint) {
319         emit Failure(uint(err), uint(info), 0, asset, msg.sender);
320 
321         return uint(err);
322     }
323 
324     /**
325      * @dev Use this when reporting an error from the money market. Give the money market result as `details`
326      */
327     function failOracleWithDetails(address asset, Error err, FailureInfo info, uint details) internal returns (uint) {
328         emit Failure(uint(err), uint(info), details, asset, msg.sender);
329 
330         return uint(err);
331     }
332 }
333 
334 // File: contracts/CarefulMath.sol
335 
336 pragma solidity ^0.5.8;
337 
338 /**
339   * @title Careful Math
340   * @author Compound
341   * @notice Derived from OpenZeppelin's SafeMath library
342   *         https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/math/SafeMath.sol
343   */
344 contract CarefulMath {
345 
346     /**
347      * @dev Possible error codes that we can return
348      */
349     enum MathError {
350         NO_ERROR,
351         DIVISION_BY_ZERO,
352         INTEGER_OVERFLOW,
353         INTEGER_UNDERFLOW
354     }
355 
356     /**
357     * @dev Multiplies two numbers, returns an error on overflow.
358     */
359     function mulUInt(uint a, uint b) internal pure returns (MathError, uint) {
360         if (a == 0) {
361             return (MathError.NO_ERROR, 0);
362         }
363 
364         uint c = a * b;
365 
366         if (c / a != b) {
367             return (MathError.INTEGER_OVERFLOW, 0);
368         } else {
369             return (MathError.NO_ERROR, c);
370         }
371     }
372 
373     /**
374     * @dev Integer division of two numbers, truncating the quotient.
375     */
376     function divUInt(uint a, uint b) internal pure returns (MathError, uint) {
377         if (b == 0) {
378             return (MathError.DIVISION_BY_ZERO, 0);
379         }
380 
381         return (MathError.NO_ERROR, a / b);
382     }
383 
384     /**
385     * @dev Subtracts two numbers, returns an error on overflow (i.e. if subtrahend is greater than minuend).
386     */
387     function subUInt(uint a, uint b) internal pure returns (MathError, uint) {
388         if (b <= a) {
389             return (MathError.NO_ERROR, a - b);
390         } else {
391             return (MathError.INTEGER_UNDERFLOW, 0);
392         }
393     }
394 
395     /**
396     * @dev Adds two numbers, returns an error on overflow.
397     */
398     function addUInt(uint a, uint b) internal pure returns (MathError, uint) {
399         uint c = a + b;
400 
401         if (c >= a) {
402             return (MathError.NO_ERROR, c);
403         } else {
404             return (MathError.INTEGER_OVERFLOW, 0);
405         }
406     }
407 
408     /**
409     * @dev add a and b and then subtract c
410     */
411     function addThenSubUInt(uint a, uint b, uint c) internal pure returns (MathError, uint) {
412         (MathError err0, uint sum) = addUInt(a, b);
413 
414         if (err0 != MathError.NO_ERROR) {
415             return (err0, 0);
416         }
417 
418         return subUInt(sum, c);
419     }
420 }
421 
422 // File: contracts/Exponential.sol
423 
424 pragma solidity ^0.5.8;
425 
426 
427 /**
428  * @title Exponential module for storing fixed-decision decimals
429  * @author Compound
430  * @notice Exp is a struct which stores decimals with a fixed precision of 18 decimal places.
431  *         Thus, if we wanted to store the 5.1, mantissa would store 5.1e18. That is:
432  *         `Exp({mantissa: 5100000000000000000})`.
433  */
434 contract Exponential is CarefulMath {
435     uint constant expScale = 1e18;
436     uint constant halfExpScale = expScale/2;
437     uint constant mantissaOne = expScale;
438 
439     struct Exp {
440         uint mantissa;
441     }
442 
443     /**
444      * @dev Creates an exponential from numerator and denominator values.
445      *      Note: Returns an error if (`num` * 10e18) > MAX_INT,
446      *            or if `denom` is zero.
447      */
448     function getExp(uint num, uint denom) pure internal returns (MathError, Exp memory) {
449         (MathError err0, uint scaledNumerator) = mulUInt(num, expScale);
450         if (err0 != MathError.NO_ERROR) {
451             return (err0, Exp({mantissa: 0}));
452         }
453 
454         (MathError err1, uint rational) = divUInt(scaledNumerator, denom);
455         if (err1 != MathError.NO_ERROR) {
456             return (err1, Exp({mantissa: 0}));
457         }
458 
459         return (MathError.NO_ERROR, Exp({mantissa: rational}));
460     }
461 
462     /**
463      * @dev Adds two exponentials, returning a new exponential.
464      */
465     function addExp(Exp memory a, Exp memory b) pure internal returns (MathError, Exp memory) {
466         (MathError error, uint result) = addUInt(a.mantissa, b.mantissa);
467 
468         return (error, Exp({mantissa: result}));
469     }
470 
471     /**
472      * @dev Subtracts two exponentials, returning a new exponential.
473      */
474     function subExp(Exp memory a, Exp memory b) pure internal returns (MathError, Exp memory) {
475         (MathError error, uint result) = subUInt(a.mantissa, b.mantissa);
476 
477         return (error, Exp({mantissa: result}));
478     }
479 
480     /**
481      * @dev Multiply an Exp by a scalar, returning a new Exp.
482      */
483     function mulScalar(Exp memory a, uint scalar) pure internal returns (MathError, Exp memory) {
484         (MathError err0, uint scaledMantissa) = mulUInt(a.mantissa, scalar);
485         if (err0 != MathError.NO_ERROR) {
486             return (err0, Exp({mantissa: 0}));
487         }
488 
489         return (MathError.NO_ERROR, Exp({mantissa: scaledMantissa}));
490     }
491 
492     /**
493      * @dev Multiply an Exp by a scalar, then truncate to return an unsigned integer.
494      */
495     function mulScalarTruncate(Exp memory a, uint scalar) pure internal returns (MathError, uint) {
496         (MathError err, Exp memory product) = mulScalar(a, scalar);
497         if (err != MathError.NO_ERROR) {
498             return (err, 0);
499         }
500 
501         return (MathError.NO_ERROR, truncate(product));
502     }
503 
504     /**
505      * @dev Multiply an Exp by a scalar, truncate, then add an to an unsigned integer, returning an unsigned integer.
506      */
507     function mulScalarTruncateAddUInt(Exp memory a, uint scalar, uint addend) pure internal returns (MathError, uint) {
508         (MathError err, Exp memory product) = mulScalar(a, scalar);
509         if (err != MathError.NO_ERROR) {
510             return (err, 0);
511         }
512 
513         return addUInt(truncate(product), addend);
514     }
515 
516     /**
517      * @dev Divide an Exp by a scalar, returning a new Exp.
518      */
519     function divScalar(Exp memory a, uint scalar) pure internal returns (MathError, Exp memory) {
520         (MathError err0, uint descaledMantissa) = divUInt(a.mantissa, scalar);
521         if (err0 != MathError.NO_ERROR) {
522             return (err0, Exp({mantissa: 0}));
523         }
524 
525         return (MathError.NO_ERROR, Exp({mantissa: descaledMantissa}));
526     }
527 
528     /**
529      * @dev Divide a scalar by an Exp, returning a new Exp.
530      */
531     function divScalarByExp(uint scalar, Exp memory divisor) pure internal returns (MathError, Exp memory) {
532         /*
533           We are doing this as:
534           getExp(mulUInt(expScale, scalar), divisor.mantissa)
535 
536           How it works:
537           Exp = a / b;
538           Scalar = s;
539           `s / (a / b)` = `b * s / a` and since for an Exp `a = mantissa, b = expScale`
540         */
541         (MathError err0, uint numerator) = mulUInt(expScale, scalar);
542         if (err0 != MathError.NO_ERROR) {
543             return (err0, Exp({mantissa: 0}));
544         }
545         return getExp(numerator, divisor.mantissa);
546     }
547 
548     /**
549      * @dev Divide a scalar by an Exp, then truncate to return an unsigned integer.
550      */
551     function divScalarByExpTruncate(uint scalar, Exp memory divisor) pure internal returns (MathError, uint) {
552         (MathError err, Exp memory fraction) = divScalarByExp(scalar, divisor);
553         if (err != MathError.NO_ERROR) {
554             return (err, 0);
555         }
556 
557         return (MathError.NO_ERROR, truncate(fraction));
558     }
559 
560     /**
561      * @dev Multiplies two exponentials, returning a new exponential.
562      */
563     function mulExp(Exp memory a, Exp memory b) pure internal returns (MathError, Exp memory) {
564 
565         (MathError err0, uint doubleScaledProduct) = mulUInt(a.mantissa, b.mantissa);
566         if (err0 != MathError.NO_ERROR) {
567             return (err0, Exp({mantissa: 0}));
568         }
569 
570         // We add half the scale before dividing so that we get rounding instead of truncation.
571         //  See "Listing 6" and text above it at https://accu.org/index.php/journals/1717
572         // Without this change, a result like 6.6...e-19 will be truncated to 0 instead of being rounded to 1e-18.
573         (MathError err1, uint doubleScaledProductWithHalfScale) = addUInt(halfExpScale, doubleScaledProduct);
574         if (err1 != MathError.NO_ERROR) {
575             return (err1, Exp({mantissa: 0}));
576         }
577 
578         (MathError err2, uint product) = divUInt(doubleScaledProductWithHalfScale, expScale);
579         // The only error `div` can return is MathError.DIVISION_BY_ZERO but we control `expScale` and it is not zero.
580         assert(err2 == MathError.NO_ERROR);
581 
582         return (MathError.NO_ERROR, Exp({mantissa: product}));
583     }
584 
585     /**
586      * @dev Multiplies two exponentials given their mantissas, returning a new exponential.
587      */
588     function mulExp(uint a, uint b) pure internal returns (MathError, Exp memory) {
589         return mulExp(Exp({mantissa: a}), Exp({mantissa: b}));
590     }
591 
592     /**
593      * @dev Multiplies three exponentials, returning a new exponential.
594      */
595     function mulExp3(Exp memory a, Exp memory b, Exp memory c) pure internal returns (MathError, Exp memory) {
596         (MathError err, Exp memory ab) = mulExp(a, b);
597         if (err != MathError.NO_ERROR) {
598             return (err, ab);
599         }
600         return mulExp(ab, c);
601     }
602 
603     /**
604      * @dev Divides two exponentials, returning a new exponential.
605      *     (a/scale) / (b/scale) = (a/scale) * (scale/b) = a/b,
606      *  which we can scale as an Exp by calling getExp(a.mantissa, b.mantissa)
607      */
608     function divExp(Exp memory a, Exp memory b) pure internal returns (MathError, Exp memory) {
609         return getExp(a.mantissa, b.mantissa);
610     }
611 
612     /**
613      * @dev Truncates the given exp to a whole number value.
614      *      For example, truncate(Exp{mantissa: 15 * expScale}) = 15
615      */
616     function truncate(Exp memory exp) pure internal returns (uint) {
617         // Note: We are not using careful math here as we're performing a division that cannot fail
618         return exp.mantissa / expScale;
619     }
620 
621     /**
622      * @dev Checks if first Exp is less than second Exp.
623      */
624     function lessThanExp(Exp memory left, Exp memory right) pure internal returns (bool) {
625         return left.mantissa < right.mantissa; //TODO: Add some simple tests and this in another PR yo.
626     }
627 
628     /**
629      * @dev Checks if left Exp <= right Exp.
630      */
631     function lessThanOrEqualExp(Exp memory left, Exp memory right) pure internal returns (bool) {
632         return left.mantissa <= right.mantissa;
633     }
634 
635     /**
636      * @dev Checks if left Exp > right Exp.
637      */
638     function greaterThanExp(Exp memory left, Exp memory right) pure internal returns (bool) {
639         return left.mantissa > right.mantissa;
640     }
641 
642     /**
643      * @dev returns true if Exp is exactly zero
644      */
645     function isZeroExp(Exp memory value) pure internal returns (bool) {
646         return value.mantissa == 0;
647     }
648 }
649 
650 // File: contracts/EIP20Interface.sol
651 
652 pragma solidity ^0.5.8;
653 
654 /**
655  * @title ERC 20 Token Standard Interface
656  *  https://eips.ethereum.org/EIPS/eip-20
657  */
658 interface EIP20Interface {
659 
660     /**
661       * @notice Get the total number of tokens in circulation
662       * @return The supply of tokens
663       */
664     function totalSupply() external view returns (uint256);
665 
666     /**
667      * @notice Gets the balance of the specified address
668      * @param owner The address from which the balance will be retrieved
669      * @return The balance
670      */
671     function balanceOf(address owner) external view returns (uint256 balance);
672 
673     /**
674       * @notice Transfer `amount` tokens from `msg.sender` to `dst`
675       * @param dst The address of the destination account
676       * @param amount The number of tokens to transfer
677       * @return Whether or not the transfer succeeded
678       */
679     function transfer(address dst, uint256 amount) external returns (bool success);
680 
681     /**
682       * @notice Transfer `amount` tokens from `src` to `dst`
683       * @param src The address of the source account
684       * @param dst The address of the destination account
685       * @param amount The number of tokens to transfer
686       * @return Whether or not the transfer succeeded
687       */
688     function transferFrom(address src, address dst, uint256 amount) external returns (bool success);
689 
690     /**
691       * @notice Approve `spender` to transfer up to `amount` from `src`
692       * @dev This will overwrite the approval amount for `spender`
693       *  and is subject to issues noted [here](https://eips.ethereum.org/EIPS/eip-20#approve)
694       * @param spender The address of the account which may transfer tokens
695       * @param amount The number of tokens that are approved (-1 means infinite)
696       * @return Whether or not the approval succeeded
697       */
698     function approve(address spender, uint256 amount) external returns (bool success);
699 
700     /**
701       * @notice Get the current allowance from `owner` for `spender`
702       * @param owner The address of the account which owns the tokens to be spent
703       * @param spender The address of the account which may transfer tokens
704       * @return The number of tokens allowed to be spent (-1 means infinite)
705       */
706     function allowance(address owner, address spender) external view returns (uint256 remaining);
707 
708     event Transfer(address indexed from, address indexed to, uint256 amount);
709     event Approval(address indexed owner, address indexed spender, uint256 amount);
710 }
711 
712 // File: contracts/EIP20NonStandardInterface.sol
713 
714 pragma solidity ^0.5.8;
715 
716 /**
717  * @title EIP20NonStandardInterface
718  * @dev Version of ERC20 with no return values for `transfer` and `transferFrom`
719  *  See https://medium.com/coinmonks/missing-return-value-bug-at-least-130-tokens-affected-d67bf08521ca
720  */
721 interface EIP20NonStandardInterface {
722 
723     /**
724      * @notice Get the total number of tokens in circulation
725      * @return The supply of tokens
726      */
727     function totalSupply() external view returns (uint256);
728 
729     /**
730      * @notice Gets the balance of the specified address
731      * @param owner The address from which the balance will be retrieved
732      * @return The balance
733      */
734     function balanceOf(address owner) external view returns (uint256 balance);
735 
736     ///
737     /// !!!!!!!!!!!!!!
738     /// !!! NOTICE !!! `transfer` does not return a value, in violation of the ERC-20 specification
739     /// !!!!!!!!!!!!!!
740     ///
741 
742     /**
743       * @notice Transfer `amount` tokens from `msg.sender` to `dst`
744       * @param dst The address of the destination account
745       * @param amount The number of tokens to transfer
746       */
747     function transfer(address dst, uint256 amount) external;
748 
749     ///
750     /// !!!!!!!!!!!!!!
751     /// !!! NOTICE !!! `transferFrom` does not return a value, in violation of the ERC-20 specification
752     /// !!!!!!!!!!!!!!
753     ///
754 
755     /**
756       * @notice Transfer `amount` tokens from `src` to `dst`
757       * @param src The address of the source account
758       * @param dst The address of the destination account
759       * @param amount The number of tokens to transfer
760       */
761     function transferFrom(address src, address dst, uint256 amount) external;
762 
763     /**
764       * @notice Approve `spender` to transfer up to `amount` from `src`
765       * @dev This will overwrite the approval amount for `spender`
766       *  and is subject to issues noted [here](https://eips.ethereum.org/EIPS/eip-20#approve)
767       * @param spender The address of the account which may transfer tokens
768       * @param amount The number of tokens that are approved
769       * @return Whether or not the approval succeeded
770       */
771     function approve(address spender, uint256 amount) external returns (bool success);
772 
773     /**
774       * @notice Get the current allowance from `owner` for `spender`
775       * @param owner The address of the account which owns the tokens to be spent
776       * @param spender The address of the account which may transfer tokens
777       * @return The number of tokens allowed to be spent
778       */
779     function allowance(address owner, address spender) external view returns (uint256 remaining);
780 
781     event Transfer(address indexed from, address indexed to, uint256 amount);
782     event Approval(address indexed owner, address indexed spender, uint256 amount);
783 }
784 
785 // File: contracts/ReentrancyGuard.sol
786 
787 pragma solidity ^0.5.8;
788 
789 /**
790  * @title Helps contracts guard against reentrancy attacks.
791  * @author Remco Bloemen <remco@2π.com>, Eenae <alexey@mixbytes.io>
792  * @dev If you mark a function `nonReentrant`, you should also
793  * mark it `external`.
794  */
795 contract ReentrancyGuard {
796     /// @dev counter to allow mutex lock with only one SSTORE operation
797     uint256 private _guardCounter;
798 
799     constructor () internal {
800         // The counter starts at one to prevent changing it from zero to a non-zero
801         // value, which is a more expensive operation.
802         _guardCounter = 1;
803     }
804 
805     /**
806      * @dev Prevents a contract from calling itself, directly or indirectly.
807      * Calling a `nonReentrant` function from another `nonReentrant`
808      * function is not supported. It is possible to prevent this from happening
809      * by making the `nonReentrant` function external, and make it call a
810      * `private` function that does the actual work.
811      */
812     modifier nonReentrant() {
813         _guardCounter += 1;
814         uint256 localCounter = _guardCounter;
815         _;
816         require(localCounter == _guardCounter, "re-entered");
817     }
818 }
819 
820 // File: contracts/InterestRateModel.sol
821 
822 pragma solidity ^0.5.8;
823 
824 /**
825   * @title The Compound InterestRateModel Interface
826   * @author Compound
827   * @notice Any interest rate model should derive from this contract.
828   * @dev These functions are specifically not marked `pure` as implementations of this
829   *      contract may read from storage variables.
830   */
831 interface InterestRateModel {
832     /**
833       * @notice Gets the current borrow interest rate based on the given asset, total cash, total borrows
834       *         and total reserves.
835       * @dev The return value should be scaled by 1e18, thus a return value of
836       *      `(true, 1000000000000)` implies an interest rate of 0.000001 or 0.0001% *per block*.
837       * @param cash The total cash of the underlying asset in the CToken
838       * @param borrows The total borrows of the underlying asset in the CToken
839       * @param reserves The total reserves of the underlying asset in the CToken
840       * @return Success or failure and the borrow interest rate per block scaled by 10e18
841       */
842     function getBorrowRate(uint cash, uint borrows, uint reserves) external view returns (uint, uint);
843 
844     /**
845       * @notice Marker function used for light validation when updating the interest rate model of a market
846       * @dev Marker function used for light validation when updating the interest rate model of a market. Implementations should simply return true.
847       * @return Success or failure
848       */
849     function isInterestRateModel() external view returns (bool);
850 }
851 
852 // File: contracts/CToken.sol
853 
854 pragma solidity ^0.5.8;
855 
856 
857 
858 
859 
860 
861 
862 
863 /**
864  * @title Compound's CToken Contract
865  * @notice Abstract base for CTokens
866  * @author Compound
867  */
868 contract CToken is EIP20Interface, Exponential, TokenErrorReporter, ReentrancyGuard {
869     /**
870      * @notice Indicator that this is a CToken contract (for inspection)
871      */
872     bool public constant isCToken = true;
873 
874     /**
875      * @notice EIP-20 token name for this token
876      */
877     string public name;
878 
879     /**
880      * @notice EIP-20 token symbol for this token
881      */
882     string public symbol;
883 
884     /**
885      * @notice EIP-20 token decimals for this token
886      */
887     uint public decimals;
888 
889     /**
890      * @notice Maximum borrow rate that can ever be applied (.0005% / block)
891      */
892     uint constant borrowRateMaxMantissa = 5e14;
893 
894     /**
895      * @notice Maximum fraction of interest that can be set aside for reserves
896      */
897     uint constant reserveFactorMaxMantissa = 1e18;
898 
899     /**
900      * @notice Administrator for this contract
901      */
902     address payable public admin;
903 
904     /**
905      * @notice Pending administrator for this contract
906      */
907     address payable public pendingAdmin;
908 
909     /**
910      * @notice Contract which oversees inter-cToken operations
911      */
912     ComptrollerInterface public comptroller;
913 
914     /**
915      * @notice Model which tells what the current interest rate should be
916      */
917     InterestRateModel public interestRateModel;
918 
919     /**
920      * @notice Initial exchange rate used when minting the first CTokens (used when totalSupply = 0)
921      */
922     uint public initialExchangeRateMantissa;
923 
924     /**
925      * @notice Fraction of interest currently set aside for reserves
926      */
927     uint public reserveFactorMantissa;
928 
929     /**
930      * @notice Block number that interest was last accrued at
931      */
932     uint public accrualBlockNumber;
933 
934     /**
935      * @notice Accumulator of total earned interest since the opening of the market
936      */
937     uint public borrowIndex;
938 
939     /**
940      * @notice Total amount of outstanding borrows of the underlying in this market
941      */
942     uint public totalBorrows;
943 
944     /**
945      * @notice Total amount of reserves of the underlying held in this market
946      */
947     uint public totalReserves;
948 
949     /**
950      * @notice Total number of tokens in circulation
951      */
952     uint256 public totalSupply;
953 
954     /**
955      * @notice Official record of token balances for each account
956      */
957     mapping (address => uint256) accountTokens;
958 
959     /**
960      * @notice Approved token transfer amounts on behalf of others
961      */
962     mapping (address => mapping (address => uint256)) transferAllowances;
963 
964     /**
965      * @notice Container for borrow balance information
966      * @member principal Total balance (with accrued interest), after applying the most recent balance-changing action
967      * @member interestIndex Global borrowIndex as of the most recent balance-changing action
968      */
969     struct BorrowSnapshot {
970         uint principal;
971         uint interestIndex;
972     }
973 
974     /**
975      * @notice Mapping of account addresses to outstanding borrow balances
976      */
977     mapping(address => BorrowSnapshot) accountBorrows;
978 
979 
980     /*** Market Events ***/
981 
982     /**
983      * @notice Event emitted when interest is accrued
984      */
985     event AccrueInterest(uint interestAccumulated, uint borrowIndex, uint totalBorrows);
986 
987     /**
988      * @notice Event emitted when tokens are minted
989      */
990     event Mint(address minter, uint mintAmount, uint mintTokens);
991 
992     /**
993      * @notice Event emitted when tokens are redeemed
994      */
995     event Redeem(address redeemer, uint redeemAmount, uint redeemTokens);
996 
997     /**
998      * @notice Event emitted when underlying is borrowed
999      */
1000     event Borrow(address borrower, uint borrowAmount, uint accountBorrows, uint totalBorrows);
1001 
1002     /**
1003      * @notice Event emitted when a borrow is repaid
1004      */
1005     event RepayBorrow(address payer, address borrower, uint repayAmount, uint accountBorrows, uint totalBorrows);
1006 
1007     /**
1008      * @notice Event emitted when a borrow is liquidated
1009      */
1010     event LiquidateBorrow(address liquidator, address borrower, uint repayAmount, address cTokenCollateral, uint seizeTokens);
1011 
1012 
1013     /*** Admin Events ***/
1014 
1015     /**
1016      * @notice Event emitted when pendingAdmin is changed
1017      */
1018     event NewPendingAdmin(address oldPendingAdmin, address newPendingAdmin);
1019 
1020     /**
1021      * @notice Event emitted when pendingAdmin is accepted, which means admin is updated
1022      */
1023     event NewAdmin(address oldAdmin, address newAdmin);
1024 
1025     /**
1026      * @notice Event emitted when comptroller is changed
1027      */
1028     event NewComptroller(ComptrollerInterface oldComptroller, ComptrollerInterface newComptroller);
1029 
1030     /**
1031      * @notice Event emitted when interestRateModel is changed
1032      */
1033     event NewMarketInterestRateModel(InterestRateModel oldInterestRateModel, InterestRateModel newInterestRateModel);
1034 
1035     /**
1036      * @notice Event emitted when the reserve factor is changed
1037      */
1038     event NewReserveFactor(uint oldReserveFactorMantissa, uint newReserveFactorMantissa);
1039 
1040     /**
1041      * @notice Event emitted when the reserves are reduced
1042      */
1043     event ReservesReduced(address admin, uint reduceAmount, uint newTotalReserves);
1044 
1045 
1046     /**
1047      * @notice Construct a new money market
1048      * @param comptroller_ The address of the Comptroller
1049      * @param interestRateModel_ The address of the interest rate model
1050      * @param initialExchangeRateMantissa_ The initial exchange rate, scaled by 1e18
1051      * @param name_ EIP-20 name of this token
1052      * @param symbol_ EIP-20 symbol of this token
1053      * @param decimals_ EIP-20 decimal precision of this token
1054      */
1055     constructor(ComptrollerInterface comptroller_,
1056                 InterestRateModel interestRateModel_,
1057                 uint initialExchangeRateMantissa_,
1058                 string memory name_,
1059                 string memory symbol_,
1060                 uint decimals_) internal {
1061         // Set admin to msg.sender
1062         admin = msg.sender;
1063 
1064         // Set initial exchange rate
1065         initialExchangeRateMantissa = initialExchangeRateMantissa_;
1066         require(initialExchangeRateMantissa > 0, "Initial exchange rate must be greater than zero.");
1067 
1068         // Set the comptroller
1069         uint err = _setComptroller(comptroller_);
1070         require(err == uint(Error.NO_ERROR), "Setting comptroller failed");
1071 
1072         // Initialize block number and borrow index (block number mocks depend on comptroller being set)
1073         accrualBlockNumber = getBlockNumber();
1074         borrowIndex = mantissaOne;
1075 
1076         // Set the interest rate model (depends on block number / borrow index)
1077         err = _setInterestRateModelFresh(interestRateModel_);
1078         require(err == uint(Error.NO_ERROR), "Setting interest rate model failed");
1079 
1080         name = name_;
1081         symbol = symbol_;
1082         decimals = decimals_;
1083     }
1084 
1085     /**
1086      * @notice Transfer `tokens` tokens from `src` to `dst` by `spender`
1087      * @dev Called by both `transfer` and `transferFrom` internally
1088      * @param spender The address of the account performing the transfer
1089      * @param src The address of the source account
1090      * @param dst The address of the destination account
1091      * @param tokens The number of tokens to transfer
1092      * @return Whether or not the transfer succeeded
1093      */
1094     function transferTokens(address spender, address src, address dst, uint tokens) internal returns (uint) {
1095         /* Fail if transfer not allowed */
1096         uint allowed = comptroller.transferAllowed(address(this), src, dst, tokens);
1097         if (allowed != 0) {
1098             return failOpaque(Error.COMPTROLLER_REJECTION, FailureInfo.TRANSFER_COMPTROLLER_REJECTION, allowed);
1099         }
1100 
1101         /* Do not allow self-transfers */
1102         if (src == dst) {
1103             return fail(Error.BAD_INPUT, FailureInfo.TRANSFER_NOT_ALLOWED);
1104         }
1105 
1106         /* Get the allowance, infinite for the account owner */
1107         uint startingAllowance = 0;
1108         if (spender == src) {
1109             startingAllowance = uint(-1);
1110         } else {
1111             startingAllowance = transferAllowances[src][spender];
1112         }
1113 
1114         /* Do the calculations, checking for {under,over}flow */
1115         MathError mathErr;
1116         uint allowanceNew;
1117         uint srcTokensNew;
1118         uint dstTokensNew;
1119 
1120         (mathErr, allowanceNew) = subUInt(startingAllowance, tokens);
1121         if (mathErr != MathError.NO_ERROR) {
1122             return fail(Error.MATH_ERROR, FailureInfo.TRANSFER_NOT_ALLOWED);
1123         }
1124 
1125         (mathErr, srcTokensNew) = subUInt(accountTokens[src], tokens);
1126         if (mathErr != MathError.NO_ERROR) {
1127             return fail(Error.MATH_ERROR, FailureInfo.TRANSFER_NOT_ENOUGH);
1128         }
1129 
1130         (mathErr, dstTokensNew) = addUInt(accountTokens[dst], tokens);
1131         if (mathErr != MathError.NO_ERROR) {
1132             return fail(Error.MATH_ERROR, FailureInfo.TRANSFER_TOO_MUCH);
1133         }
1134 
1135         /////////////////////////
1136         // EFFECTS & INTERACTIONS
1137         // (No safe failures beyond this point)
1138 
1139         accountTokens[src] = srcTokensNew;
1140         accountTokens[dst] = dstTokensNew;
1141 
1142         /* Eat some of the allowance (if necessary) */
1143         if (startingAllowance != uint(-1)) {
1144             transferAllowances[src][spender] = allowanceNew;
1145         }
1146 
1147         /* We emit a Transfer event */
1148         emit Transfer(src, dst, tokens);
1149 
1150         /* We call the defense hook (which checks for under-collateralization) */
1151         comptroller.transferVerify(address(this), src, dst, tokens);
1152 
1153         return uint(Error.NO_ERROR);
1154     }
1155 
1156     /**
1157      * @notice Transfer `amount` tokens from `msg.sender` to `dst`
1158      * @param dst The address of the destination account
1159      * @param amount The number of tokens to transfer
1160      * @return Whether or not the transfer succeeded
1161      */
1162     function transfer(address dst, uint256 amount) external nonReentrant returns (bool) {
1163         return transferTokens(msg.sender, msg.sender, dst, amount) == uint(Error.NO_ERROR);
1164     }
1165 
1166     /**
1167      * @notice Transfer `amount` tokens from `src` to `dst`
1168      * @param src The address of the source account
1169      * @param dst The address of the destination account
1170      * @param amount The number of tokens to transfer
1171      * @return Whether or not the transfer succeeded
1172      */
1173     function transferFrom(address src, address dst, uint256 amount) external nonReentrant returns (bool) {
1174         return transferTokens(msg.sender, src, dst, amount) == uint(Error.NO_ERROR);
1175     }
1176 
1177     /**
1178      * @notice Approve `spender` to transfer up to `amount` from `src`
1179      * @dev This will overwrite the approval amount for `spender`
1180      *  and is subject to issues noted [here](https://eips.ethereum.org/EIPS/eip-20#approve)
1181      * @param spender The address of the account which may transfer tokens
1182      * @param amount The number of tokens that are approved (-1 means infinite)
1183      * @return Whether or not the approval succeeded
1184      */
1185     function approve(address spender, uint256 amount) external returns (bool) {
1186         address src = msg.sender;
1187         transferAllowances[src][spender] = amount;
1188         emit Approval(src, spender, amount);
1189         return true;
1190     }
1191 
1192     /**
1193      * @notice Get the current allowance from `owner` for `spender`
1194      * @param owner The address of the account which owns the tokens to be spent
1195      * @param spender The address of the account which may transfer tokens
1196      * @return The number of tokens allowed to be spent (-1 means infinite)
1197      */
1198     function allowance(address owner, address spender) external view returns (uint256) {
1199         return transferAllowances[owner][spender];
1200     }
1201 
1202     /**
1203      * @notice Get the token balance of the `owner`
1204      * @param owner The address of the account to query
1205      * @return The number of tokens owned by `owner`
1206      */
1207     function balanceOf(address owner) external view returns (uint256) {
1208         return accountTokens[owner];
1209     }
1210 
1211     /**
1212      * @notice Get the underlying balance of the `owner`
1213      * @dev This also accrues interest in a transaction
1214      * @param owner The address of the account to query
1215      * @return The amount of underlying owned by `owner`
1216      */
1217     function balanceOfUnderlying(address owner) external returns (uint) {
1218         Exp memory exchangeRate = Exp({mantissa: exchangeRateCurrent()});
1219         (MathError mErr, uint balance) = mulScalarTruncate(exchangeRate, accountTokens[owner]);
1220         require(mErr == MathError.NO_ERROR);
1221         return balance;
1222     }
1223 
1224     /**
1225      * @notice Get a snapshot of the account's balances, and the cached exchange rate
1226      * @dev This is used by comptroller to more efficiently perform liquidity checks.
1227      * @param account Address of the account to snapshot
1228      * @return (possible error, token balance, borrow balance, exchange rate mantissa)
1229      */
1230     function getAccountSnapshot(address account) external view returns (uint, uint, uint, uint) {
1231         uint cTokenBalance = accountTokens[account];
1232         uint borrowBalance;
1233         uint exchangeRateMantissa;
1234 
1235         MathError mErr;
1236 
1237         (mErr, borrowBalance) = borrowBalanceStoredInternal(account);
1238         if (mErr != MathError.NO_ERROR) {
1239             return (uint(Error.MATH_ERROR), 0, 0, 0);
1240         }
1241 
1242         (mErr, exchangeRateMantissa) = exchangeRateStoredInternal();
1243         if (mErr != MathError.NO_ERROR) {
1244             return (uint(Error.MATH_ERROR), 0, 0, 0);
1245         }
1246 
1247         return (uint(Error.NO_ERROR), cTokenBalance, borrowBalance, exchangeRateMantissa);
1248     }
1249 
1250     /**
1251      * @dev Function to simply retrieve block number
1252      *  This exists mainly for inheriting test contracts to stub this result.
1253      */
1254     function getBlockNumber() internal view returns (uint) {
1255         return block.number;
1256     }
1257 
1258     /**
1259      * @notice Returns the current per-block borrow interest rate for this cToken
1260      * @return The borrow interest rate per block, scaled by 1e18
1261      */
1262     function borrowRatePerBlock() external view returns (uint) {
1263         (uint opaqueErr, uint borrowRateMantissa) = interestRateModel.getBorrowRate(getCashPrior(), totalBorrows, totalReserves);
1264         require(opaqueErr == 0, "borrowRatePerBlock: interestRateModel.borrowRate failed"); // semi-opaque
1265         return borrowRateMantissa;
1266     }
1267 
1268     /**
1269      * @notice Returns the current per-block supply interest rate for this cToken
1270      * @return The supply interest rate per block, scaled by 1e18
1271      */
1272     function supplyRatePerBlock() external view returns (uint) {
1273         /* We calculate the supply rate:
1274          *  underlying = totalSupply × exchangeRate
1275          *  borrowsPer = totalBorrows ÷ underlying
1276          *  supplyRate = borrowRate × (1-reserveFactor) × borrowsPer
1277          */
1278         uint exchangeRateMantissa = exchangeRateStored();
1279 
1280         (uint e0, uint borrowRateMantissa) = interestRateModel.getBorrowRate(getCashPrior(), totalBorrows, totalReserves);
1281         require(e0 == 0, "supplyRatePerBlock: calculating borrowRate failed"); // semi-opaque
1282 
1283         (MathError e1, Exp memory underlying) = mulScalar(Exp({mantissa: exchangeRateMantissa}), totalSupply);
1284         require(e1 == MathError.NO_ERROR, "supplyRatePerBlock: calculating underlying failed");
1285 
1286         (MathError e2, Exp memory borrowsPer) = divScalarByExp(totalBorrows, underlying);
1287         require(e2 == MathError.NO_ERROR, "supplyRatePerBlock: calculating borrowsPer failed");
1288 
1289         (MathError e3, Exp memory oneMinusReserveFactor) = subExp(Exp({mantissa: mantissaOne}), Exp({mantissa: reserveFactorMantissa}));
1290         require(e3 == MathError.NO_ERROR, "supplyRatePerBlock: calculating oneMinusReserveFactor failed");
1291 
1292         (MathError e4, Exp memory supplyRate) = mulExp3(Exp({mantissa: borrowRateMantissa}), oneMinusReserveFactor, borrowsPer);
1293         require(e4 == MathError.NO_ERROR, "supplyRatePerBlock: calculating supplyRate failed");
1294 
1295         return supplyRate.mantissa;
1296     }
1297 
1298     /**
1299      * @notice Returns the current total borrows plus accrued interest
1300      * @return The total borrows with interest
1301      */
1302     function totalBorrowsCurrent() external nonReentrant returns (uint) {
1303         require(accrueInterest() == uint(Error.NO_ERROR), "accrue interest failed");
1304         return totalBorrows;
1305     }
1306 
1307     /**
1308      * @notice Accrue interest to updated borrowIndex and then calculate account's borrow balance using the updated borrowIndex
1309      * @param account The address whose balance should be calculated after updating borrowIndex
1310      * @return The calculated balance
1311      */
1312     function borrowBalanceCurrent(address account) external nonReentrant returns (uint) {
1313         require(accrueInterest() == uint(Error.NO_ERROR), "accrue interest failed");
1314         return borrowBalanceStored(account);
1315     }
1316 
1317     /**
1318      * @notice Return the borrow balance of account based on stored data
1319      * @param account The address whose balance should be calculated
1320      * @return The calculated balance
1321      */
1322     function borrowBalanceStored(address account) public view returns (uint) {
1323         (MathError err, uint result) = borrowBalanceStoredInternal(account);
1324         require(err == MathError.NO_ERROR, "borrowBalanceStored: borrowBalanceStoredInternal failed");
1325         return result;
1326     }
1327 
1328     /**
1329      * @notice Return the borrow balance of account based on stored data
1330      * @param account The address whose balance should be calculated
1331      * @return (error code, the calculated balance or 0 if error code is non-zero)
1332      */
1333     function borrowBalanceStoredInternal(address account) internal view returns (MathError, uint) {
1334         /* Note: we do not assert that the market is up to date */
1335         MathError mathErr;
1336         uint principalTimesIndex;
1337         uint result;
1338 
1339         /* Get borrowBalance and borrowIndex */
1340         BorrowSnapshot storage borrowSnapshot = accountBorrows[account];
1341 
1342         /* If borrowBalance = 0 then borrowIndex is likely also 0.
1343          * Rather than failing the calculation with a division by 0, we immediately return 0 in this case.
1344          */
1345         if (borrowSnapshot.principal == 0) {
1346             return (MathError.NO_ERROR, 0);
1347         }
1348 
1349         /* Calculate new borrow balance using the interest index:
1350          *  recentBorrowBalance = borrower.borrowBalance * market.borrowIndex / borrower.borrowIndex
1351          */
1352         (mathErr, principalTimesIndex) = mulUInt(borrowSnapshot.principal, borrowIndex);
1353         if (mathErr != MathError.NO_ERROR) {
1354             return (mathErr, 0);
1355         }
1356 
1357         (mathErr, result) = divUInt(principalTimesIndex, borrowSnapshot.interestIndex);
1358         if (mathErr != MathError.NO_ERROR) {
1359             return (mathErr, 0);
1360         }
1361 
1362         return (MathError.NO_ERROR, result);
1363     }
1364 
1365     /**
1366      * @notice Accrue interest then return the up-to-date exchange rate
1367      * @return Calculated exchange rate scaled by 1e18
1368      */
1369     function exchangeRateCurrent() public nonReentrant returns (uint) {
1370         require(accrueInterest() == uint(Error.NO_ERROR), "accrue interest failed");
1371         return exchangeRateStored();
1372     }
1373 
1374     /**
1375      * @notice Calculates the exchange rate from the underlying to the CToken
1376      * @dev This function does not accrue interest before calculating the exchange rate
1377      * @return Calculated exchange rate scaled by 1e18
1378      */
1379     function exchangeRateStored() public view returns (uint) {
1380         (MathError err, uint result) = exchangeRateStoredInternal();
1381         require(err == MathError.NO_ERROR, "exchangeRateStored: exchangeRateStoredInternal failed");
1382         return result;
1383     }
1384 
1385     /**
1386      * @notice Calculates the exchange rate from the underlying to the CToken
1387      * @dev This function does not accrue interest before calculating the exchange rate
1388      * @return (error code, calculated exchange rate scaled by 1e18)
1389      */
1390     function exchangeRateStoredInternal() internal view returns (MathError, uint) {
1391         if (totalSupply == 0) {
1392             /*
1393              * If there are no tokens minted:
1394              *  exchangeRate = initialExchangeRate
1395              */
1396             return (MathError.NO_ERROR, initialExchangeRateMantissa);
1397         } else {
1398             /*
1399              * Otherwise:
1400              *  exchangeRate = (totalCash + totalBorrows - totalReserves) / totalSupply
1401              */
1402             uint totalCash = getCashPrior();
1403             uint cashPlusBorrowsMinusReserves;
1404             Exp memory exchangeRate;
1405             MathError mathErr;
1406 
1407             (mathErr, cashPlusBorrowsMinusReserves) = addThenSubUInt(totalCash, totalBorrows, totalReserves);
1408             if (mathErr != MathError.NO_ERROR) {
1409                 return (mathErr, 0);
1410             }
1411 
1412             (mathErr, exchangeRate) = getExp(cashPlusBorrowsMinusReserves, totalSupply);
1413             if (mathErr != MathError.NO_ERROR) {
1414                 return (mathErr, 0);
1415             }
1416 
1417             return (MathError.NO_ERROR, exchangeRate.mantissa);
1418         }
1419     }
1420 
1421     /**
1422      * @notice Get cash balance of this cToken in the underlying asset
1423      * @return The quantity of underlying asset owned by this contract
1424      */
1425     function getCash() external view returns (uint) {
1426         return getCashPrior();
1427     }
1428 
1429     struct AccrueInterestLocalVars {
1430         MathError mathErr;
1431         uint opaqueErr;
1432         uint borrowRateMantissa;
1433         uint currentBlockNumber;
1434         uint blockDelta;
1435 
1436         Exp simpleInterestFactor;
1437 
1438         uint interestAccumulated;
1439         uint totalBorrowsNew;
1440         uint totalReservesNew;
1441         uint borrowIndexNew;
1442     }
1443 
1444     /**
1445       * @notice Applies accrued interest to total borrows and reserves.
1446       * @dev This calculates interest accrued from the last checkpointed block
1447       *      up to the current block and writes new checkpoint to storage.
1448       */
1449     function accrueInterest() public returns (uint) {
1450         AccrueInterestLocalVars memory vars;
1451 
1452         /* Calculate the current borrow interest rate */
1453         (vars.opaqueErr, vars.borrowRateMantissa) = interestRateModel.getBorrowRate(getCashPrior(), totalBorrows, totalReserves);
1454         require(vars.borrowRateMantissa <= borrowRateMaxMantissa, "borrow rate is absurdly high");
1455         if (vars.opaqueErr != 0) {
1456             return failOpaque(Error.INTEREST_RATE_MODEL_ERROR, FailureInfo.ACCRUE_INTEREST_BORROW_RATE_CALCULATION_FAILED, vars.opaqueErr);
1457         }
1458 
1459         /* Remember the initial block number */
1460         vars.currentBlockNumber = getBlockNumber();
1461 
1462         /* Calculate the number of blocks elapsed since the last accrual */
1463         (vars.mathErr, vars.blockDelta) = subUInt(vars.currentBlockNumber, accrualBlockNumber);
1464         assert(vars.mathErr == MathError.NO_ERROR); // Block delta should always succeed and if it doesn't, blow up.
1465 
1466         /*
1467          * Calculate the interest accumulated into borrows and reserves and the new index:
1468          *  simpleInterestFactor = borrowRate * blockDelta
1469          *  interestAccumulated = simpleInterestFactor * totalBorrows
1470          *  totalBorrowsNew = interestAccumulated + totalBorrows
1471          *  totalReservesNew = interestAccumulated * reserveFactor + totalReserves
1472          *  borrowIndexNew = simpleInterestFactor * borrowIndex + borrowIndex
1473          */
1474         (vars.mathErr, vars.simpleInterestFactor) = mulScalar(Exp({mantissa: vars.borrowRateMantissa}), vars.blockDelta);
1475         if (vars.mathErr != MathError.NO_ERROR) {
1476             return failOpaque(Error.MATH_ERROR, FailureInfo.ACCRUE_INTEREST_SIMPLE_INTEREST_FACTOR_CALCULATION_FAILED, uint(vars.mathErr));
1477         }
1478 
1479         (vars.mathErr, vars.interestAccumulated) = mulScalarTruncate(vars.simpleInterestFactor, totalBorrows);
1480         if (vars.mathErr != MathError.NO_ERROR) {
1481             return failOpaque(Error.MATH_ERROR, FailureInfo.ACCRUE_INTEREST_ACCUMULATED_INTEREST_CALCULATION_FAILED, uint(vars.mathErr));
1482         }
1483 
1484         (vars.mathErr, vars.totalBorrowsNew) = addUInt(vars.interestAccumulated, totalBorrows);
1485         if (vars.mathErr != MathError.NO_ERROR) {
1486             return failOpaque(Error.MATH_ERROR, FailureInfo.ACCRUE_INTEREST_NEW_TOTAL_BORROWS_CALCULATION_FAILED, uint(vars.mathErr));
1487         }
1488 
1489         (vars.mathErr, vars.totalReservesNew) = mulScalarTruncateAddUInt(Exp({mantissa: reserveFactorMantissa}), vars.interestAccumulated, totalReserves);
1490         if (vars.mathErr != MathError.NO_ERROR) {
1491             return failOpaque(Error.MATH_ERROR, FailureInfo.ACCRUE_INTEREST_NEW_TOTAL_RESERVES_CALCULATION_FAILED, uint(vars.mathErr));
1492         }
1493 
1494         (vars.mathErr, vars.borrowIndexNew) = mulScalarTruncateAddUInt(vars.simpleInterestFactor, borrowIndex, borrowIndex);
1495         if (vars.mathErr != MathError.NO_ERROR) {
1496             return failOpaque(Error.MATH_ERROR, FailureInfo.ACCRUE_INTEREST_NEW_BORROW_INDEX_CALCULATION_FAILED, uint(vars.mathErr));
1497         }
1498 
1499         /////////////////////////
1500         // EFFECTS & INTERACTIONS
1501         // (No safe failures beyond this point)
1502 
1503         /* We write the previously calculated values into storage */
1504         accrualBlockNumber = vars.currentBlockNumber;
1505         borrowIndex = vars.borrowIndexNew;
1506         totalBorrows = vars.totalBorrowsNew;
1507         totalReserves = vars.totalReservesNew;
1508 
1509         /* We emit an AccrueInterest event */
1510         emit AccrueInterest(vars.interestAccumulated, vars.borrowIndexNew, totalBorrows);
1511 
1512         return uint(Error.NO_ERROR);
1513     }
1514 
1515     /**
1516      * @notice Sender supplies assets into the market and receives cTokens in exchange
1517      * @dev Accrues interest whether or not the operation succeeds, unless reverted
1518      * @param mintAmount The amount of the underlying asset to supply
1519      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
1520      */
1521     function mintInternal(uint mintAmount) internal nonReentrant returns (uint) {
1522         uint error = accrueInterest();
1523         if (error != uint(Error.NO_ERROR)) {
1524             // accrueInterest emits logs on errors, but we still want to log the fact that an attempted borrow failed
1525             return fail(Error(error), FailureInfo.MINT_ACCRUE_INTEREST_FAILED);
1526         }
1527         // mintFresh emits the actual Mint event if successful and logs on errors, so we don't need to
1528         return mintFresh(msg.sender, mintAmount);
1529     }
1530 
1531     struct MintLocalVars {
1532         Error err;
1533         MathError mathErr;
1534         uint exchangeRateMantissa;
1535         uint mintTokens;
1536         uint totalSupplyNew;
1537         uint accountTokensNew;
1538     }
1539 
1540     /**
1541      * @notice User supplies assets into the market and receives cTokens in exchange
1542      * @dev Assumes interest has already been accrued up to the current block
1543      * @param minter The address of the account which is supplying the assets
1544      * @param mintAmount The amount of the underlying asset to supply
1545      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
1546      */
1547     function mintFresh(address minter, uint mintAmount) internal returns (uint) {
1548         /* Fail if mint not allowed */
1549         uint allowed = comptroller.mintAllowed(address(this), minter, mintAmount);
1550         if (allowed != 0) {
1551             return failOpaque(Error.COMPTROLLER_REJECTION, FailureInfo.MINT_COMPTROLLER_REJECTION, allowed);
1552         }
1553 
1554         /* Verify market's block number equals current block number */
1555         if (accrualBlockNumber != getBlockNumber()) {
1556             return fail(Error.MARKET_NOT_FRESH, FailureInfo.MINT_FRESHNESS_CHECK);
1557         }
1558 
1559         MintLocalVars memory vars;
1560 
1561         /* Fail if checkTransferIn fails */
1562         vars.err = checkTransferIn(minter, mintAmount);
1563         if (vars.err != Error.NO_ERROR) {
1564             return fail(vars.err, FailureInfo.MINT_TRANSFER_IN_NOT_POSSIBLE);
1565         }
1566 
1567         /*
1568          * We get the current exchange rate and calculate the number of cTokens to be minted:
1569          *  mintTokens = mintAmount / exchangeRate
1570          */
1571         (vars.mathErr, vars.exchangeRateMantissa) = exchangeRateStoredInternal();
1572         if (vars.mathErr != MathError.NO_ERROR) {
1573             return failOpaque(Error.MATH_ERROR, FailureInfo.MINT_EXCHANGE_RATE_READ_FAILED, uint(vars.mathErr));
1574         }
1575 
1576         (vars.mathErr, vars.mintTokens) = divScalarByExpTruncate(mintAmount, Exp({mantissa: vars.exchangeRateMantissa}));
1577         if (vars.mathErr != MathError.NO_ERROR) {
1578             return failOpaque(Error.MATH_ERROR, FailureInfo.MINT_EXCHANGE_CALCULATION_FAILED, uint(vars.mathErr));
1579         }
1580 
1581         /*
1582          * We calculate the new total supply of cTokens and minter token balance, checking for overflow:
1583          *  totalSupplyNew = totalSupply + mintTokens
1584          *  accountTokensNew = accountTokens[minter] + mintTokens
1585          */
1586         (vars.mathErr, vars.totalSupplyNew) = addUInt(totalSupply, vars.mintTokens);
1587         if (vars.mathErr != MathError.NO_ERROR) {
1588             return failOpaque(Error.MATH_ERROR, FailureInfo.MINT_NEW_TOTAL_SUPPLY_CALCULATION_FAILED, uint(vars.mathErr));
1589         }
1590 
1591         (vars.mathErr, vars.accountTokensNew) = addUInt(accountTokens[minter], vars.mintTokens);
1592         if (vars.mathErr != MathError.NO_ERROR) {
1593             return failOpaque(Error.MATH_ERROR, FailureInfo.MINT_NEW_ACCOUNT_BALANCE_CALCULATION_FAILED, uint(vars.mathErr));
1594         }
1595 
1596         /////////////////////////
1597         // EFFECTS & INTERACTIONS
1598         // (No safe failures beyond this point)
1599 
1600         /*
1601          * We call doTransferIn for the minter and the mintAmount
1602          *  Note: The cToken must handle variations between ERC-20 and ETH underlying.
1603          *  On success, the cToken holds an additional mintAmount of cash.
1604          *  If doTransferIn fails despite the fact we checked pre-conditions,
1605          *   we revert because we can't be sure if side effects occurred.
1606          */
1607         vars.err = doTransferIn(minter, mintAmount);
1608         if (vars.err != Error.NO_ERROR) {
1609             return fail(vars.err, FailureInfo.MINT_TRANSFER_IN_FAILED);
1610         }
1611 
1612         /* We write previously calculated values into storage */
1613         totalSupply = vars.totalSupplyNew;
1614         accountTokens[minter] = vars.accountTokensNew;
1615 
1616         /* We emit a Mint event, and a Transfer event */
1617         emit Mint(minter, mintAmount, vars.mintTokens);
1618         emit Transfer(address(this), minter, vars.mintTokens);
1619 
1620         /* We call the defense hook */
1621         comptroller.mintVerify(address(this), minter, mintAmount, vars.mintTokens);
1622 
1623         return uint(Error.NO_ERROR);
1624     }
1625 
1626     /**
1627      * @notice Sender redeems cTokens in exchange for the underlying asset
1628      * @dev Accrues interest whether or not the operation succeeds, unless reverted
1629      * @param redeemTokens The number of cTokens to redeem into underlying
1630      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
1631      */
1632     function redeemInternal(uint redeemTokens) internal nonReentrant returns (uint) {
1633         uint error = accrueInterest();
1634         if (error != uint(Error.NO_ERROR)) {
1635             // accrueInterest emits logs on errors, but we still want to log the fact that an attempted redeem failed
1636             return fail(Error(error), FailureInfo.REDEEM_ACCRUE_INTEREST_FAILED);
1637         }
1638         // redeemFresh emits redeem-specific logs on errors, so we don't need to
1639         return redeemFresh(msg.sender, redeemTokens, 0);
1640     }
1641 
1642     /**
1643      * @notice Sender redeems cTokens in exchange for a specified amount of underlying asset
1644      * @dev Accrues interest whether or not the operation succeeds, unless reverted
1645      * @param redeemAmount The amount of underlying to redeem
1646      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
1647      */
1648     function redeemUnderlyingInternal(uint redeemAmount) internal nonReentrant returns (uint) {
1649         uint error = accrueInterest();
1650         if (error != uint(Error.NO_ERROR)) {
1651             // accrueInterest emits logs on errors, but we still want to log the fact that an attempted redeem failed
1652             return fail(Error(error), FailureInfo.REDEEM_ACCRUE_INTEREST_FAILED);
1653         }
1654         // redeemFresh emits redeem-specific logs on errors, so we don't need to
1655         return redeemFresh(msg.sender, 0, redeemAmount);
1656     }
1657 
1658     struct RedeemLocalVars {
1659         Error err;
1660         MathError mathErr;
1661         uint exchangeRateMantissa;
1662         uint redeemTokens;
1663         uint redeemAmount;
1664         uint totalSupplyNew;
1665         uint accountTokensNew;
1666     }
1667 
1668     /**
1669      * @notice User redeems cTokens in exchange for the underlying asset
1670      * @dev Assumes interest has already been accrued up to the current block
1671      * @param redeemer The address of the account which is redeeming the tokens
1672      * @param redeemTokensIn The number of cTokens to redeem into underlying (only one of redeemTokensIn or redeemAmountIn may be zero)
1673      * @param redeemAmountIn The number of cTokens to redeem into underlying (only one of redeemTokensIn or redeemAmountIn may be zero)
1674      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
1675      */
1676     function redeemFresh(address payable redeemer, uint redeemTokensIn, uint redeemAmountIn) internal returns (uint) {
1677         require(redeemTokensIn == 0 || redeemAmountIn == 0, "one of redeemTokensIn or redeemAmountIn must be zero");
1678 
1679         RedeemLocalVars memory vars;
1680 
1681         /* exchangeRate = invoke Exchange Rate Stored() */
1682         (vars.mathErr, vars.exchangeRateMantissa) = exchangeRateStoredInternal();
1683         if (vars.mathErr != MathError.NO_ERROR) {
1684             return failOpaque(Error.MATH_ERROR, FailureInfo.REDEEM_EXCHANGE_RATE_READ_FAILED, uint(vars.mathErr));
1685         }
1686 
1687         /* If redeemTokensIn > 0: */
1688         if (redeemTokensIn > 0) {
1689             /*
1690              * We calculate the exchange rate and the amount of underlying to be redeemed:
1691              *  redeemTokens = redeemTokensIn
1692              *  redeemAmount = redeemTokensIn x exchangeRateCurrent
1693              */
1694             vars.redeemTokens = redeemTokensIn;
1695 
1696             (vars.mathErr, vars.redeemAmount) = mulScalarTruncate(Exp({mantissa: vars.exchangeRateMantissa}), redeemTokensIn);
1697             if (vars.mathErr != MathError.NO_ERROR) {
1698                 return failOpaque(Error.MATH_ERROR, FailureInfo.REDEEM_EXCHANGE_TOKENS_CALCULATION_FAILED, uint(vars.mathErr));
1699             }
1700         } else {
1701             /*
1702              * We get the current exchange rate and calculate the amount to be redeemed:
1703              *  redeemTokens = redeemAmountIn / exchangeRate
1704              *  redeemAmount = redeemAmountIn
1705              */
1706 
1707             (vars.mathErr, vars.redeemTokens) = divScalarByExpTruncate(redeemAmountIn, Exp({mantissa: vars.exchangeRateMantissa}));
1708             if (vars.mathErr != MathError.NO_ERROR) {
1709                 return failOpaque(Error.MATH_ERROR, FailureInfo.REDEEM_EXCHANGE_AMOUNT_CALCULATION_FAILED, uint(vars.mathErr));
1710             }
1711 
1712             vars.redeemAmount = redeemAmountIn;
1713         }
1714 
1715         /* Fail if redeem not allowed */
1716         uint allowed = comptroller.redeemAllowed(address(this), redeemer, vars.redeemTokens);
1717         if (allowed != 0) {
1718             return failOpaque(Error.COMPTROLLER_REJECTION, FailureInfo.REDEEM_COMPTROLLER_REJECTION, allowed);
1719         }
1720 
1721         /* Verify market's block number equals current block number */
1722         if (accrualBlockNumber != getBlockNumber()) {
1723             return fail(Error.MARKET_NOT_FRESH, FailureInfo.REDEEM_FRESHNESS_CHECK);
1724         }
1725 
1726         /*
1727          * We calculate the new total supply and redeemer balance, checking for underflow:
1728          *  totalSupplyNew = totalSupply - redeemTokens
1729          *  accountTokensNew = accountTokens[redeemer] - redeemTokens
1730          */
1731         (vars.mathErr, vars.totalSupplyNew) = subUInt(totalSupply, vars.redeemTokens);
1732         if (vars.mathErr != MathError.NO_ERROR) {
1733             return failOpaque(Error.MATH_ERROR, FailureInfo.REDEEM_NEW_TOTAL_SUPPLY_CALCULATION_FAILED, uint(vars.mathErr));
1734         }
1735 
1736         (vars.mathErr, vars.accountTokensNew) = subUInt(accountTokens[redeemer], vars.redeemTokens);
1737         if (vars.mathErr != MathError.NO_ERROR) {
1738             return failOpaque(Error.MATH_ERROR, FailureInfo.REDEEM_NEW_ACCOUNT_BALANCE_CALCULATION_FAILED, uint(vars.mathErr));
1739         }
1740 
1741         /* Fail gracefully if protocol has insufficient cash */
1742         if (getCashPrior() < vars.redeemAmount) {
1743             return fail(Error.TOKEN_INSUFFICIENT_CASH, FailureInfo.REDEEM_TRANSFER_OUT_NOT_POSSIBLE);
1744         }
1745 
1746         /////////////////////////
1747         // EFFECTS & INTERACTIONS
1748         // (No safe failures beyond this point)
1749 
1750         /*
1751          * We invoke doTransferOut for the redeemer and the redeemAmount.
1752          *  Note: The cToken must handle variations between ERC-20 and ETH underlying.
1753          *  On success, the cToken has redeemAmount less of cash.
1754          *  If doTransferOut fails despite the fact we checked pre-conditions,
1755          *   we revert because we can't be sure if side effects occurred.
1756          */
1757         vars.err = doTransferOut(redeemer, vars.redeemAmount);
1758         require(vars.err == Error.NO_ERROR, "redeem transfer out failed");
1759 
1760         /* We write previously calculated values into storage */
1761         totalSupply = vars.totalSupplyNew;
1762         accountTokens[redeemer] = vars.accountTokensNew;
1763 
1764         /* We emit a Transfer event, and a Redeem event */
1765         emit Transfer(redeemer, address(this), vars.redeemTokens);
1766         emit Redeem(redeemer, vars.redeemAmount, vars.redeemTokens);
1767 
1768         /* We call the defense hook */
1769         comptroller.redeemVerify(address(this), redeemer, vars.redeemAmount, vars.redeemTokens);
1770 
1771         return uint(Error.NO_ERROR);
1772     }
1773 
1774     /**
1775       * @notice Sender borrows assets from the protocol to their own address
1776       * @param borrowAmount The amount of the underlying asset to borrow
1777       * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
1778       */
1779     function borrowInternal(uint borrowAmount) internal nonReentrant returns (uint) {
1780         uint error = accrueInterest();
1781         if (error != uint(Error.NO_ERROR)) {
1782             // accrueInterest emits logs on errors, but we still want to log the fact that an attempted borrow failed
1783             return fail(Error(error), FailureInfo.BORROW_ACCRUE_INTEREST_FAILED);
1784         }
1785         // borrowFresh emits borrow-specific logs on errors, so we don't need to
1786         return borrowFresh(msg.sender, borrowAmount);
1787     }
1788 
1789     struct BorrowLocalVars {
1790         Error err;
1791         MathError mathErr;
1792         uint accountBorrows;
1793         uint accountBorrowsNew;
1794         uint totalBorrowsNew;
1795     }
1796 
1797     /**
1798       * @notice Users borrow assets from the protocol to their own address
1799       * @param borrowAmount The amount of the underlying asset to borrow
1800       * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
1801       */
1802     function borrowFresh(address payable borrower, uint borrowAmount) internal returns (uint) {
1803         /* Fail if borrow not allowed */
1804         uint allowed = comptroller.borrowAllowed(address(this), borrower, borrowAmount);
1805         if (allowed != 0) {
1806             return failOpaque(Error.COMPTROLLER_REJECTION, FailureInfo.BORROW_COMPTROLLER_REJECTION, allowed);
1807         }
1808 
1809         /* Verify market's block number equals current block number */
1810         if (accrualBlockNumber != getBlockNumber()) {
1811             return fail(Error.MARKET_NOT_FRESH, FailureInfo.BORROW_FRESHNESS_CHECK);
1812         }
1813 
1814         /* Fail gracefully if protocol has insufficient underlying cash */
1815         if (getCashPrior() < borrowAmount) {
1816             return fail(Error.TOKEN_INSUFFICIENT_CASH, FailureInfo.BORROW_CASH_NOT_AVAILABLE);
1817         }
1818 
1819         BorrowLocalVars memory vars;
1820 
1821         /*
1822          * We calculate the new borrower and total borrow balances, failing on overflow:
1823          *  accountBorrowsNew = accountBorrows + borrowAmount
1824          *  totalBorrowsNew = totalBorrows + borrowAmount
1825          */
1826         (vars.mathErr, vars.accountBorrows) = borrowBalanceStoredInternal(borrower);
1827         if (vars.mathErr != MathError.NO_ERROR) {
1828             return failOpaque(Error.MATH_ERROR, FailureInfo.BORROW_ACCUMULATED_BALANCE_CALCULATION_FAILED, uint(vars.mathErr));
1829         }
1830 
1831         (vars.mathErr, vars.accountBorrowsNew) = addUInt(vars.accountBorrows, borrowAmount);
1832         if (vars.mathErr != MathError.NO_ERROR) {
1833             return failOpaque(Error.MATH_ERROR, FailureInfo.BORROW_NEW_ACCOUNT_BORROW_BALANCE_CALCULATION_FAILED, uint(vars.mathErr));
1834         }
1835 
1836         (vars.mathErr, vars.totalBorrowsNew) = addUInt(totalBorrows, borrowAmount);
1837         if (vars.mathErr != MathError.NO_ERROR) {
1838             return failOpaque(Error.MATH_ERROR, FailureInfo.BORROW_NEW_TOTAL_BALANCE_CALCULATION_FAILED, uint(vars.mathErr));
1839         }
1840 
1841         /////////////////////////
1842         // EFFECTS & INTERACTIONS
1843         // (No safe failures beyond this point)
1844 
1845         /*
1846          * We invoke doTransferOut for the borrower and the borrowAmount.
1847          *  Note: The cToken must handle variations between ERC-20 and ETH underlying.
1848          *  On success, the cToken borrowAmount less of cash.
1849          *  If doTransferOut fails despite the fact we checked pre-conditions,
1850          *   we revert because we can't be sure if side effects occurred.
1851          */
1852         vars.err = doTransferOut(borrower, borrowAmount);
1853         require(vars.err == Error.NO_ERROR, "borrow transfer out failed");
1854 
1855         /* We write the previously calculated values into storage */
1856         accountBorrows[borrower].principal = vars.accountBorrowsNew;
1857         accountBorrows[borrower].interestIndex = borrowIndex;
1858         totalBorrows = vars.totalBorrowsNew;
1859 
1860         /* We emit a Borrow event */
1861         emit Borrow(borrower, borrowAmount, vars.accountBorrowsNew, vars.totalBorrowsNew);
1862 
1863         /* We call the defense hook */
1864         comptroller.borrowVerify(address(this), borrower, borrowAmount);
1865 
1866         return uint(Error.NO_ERROR);
1867     }
1868 
1869     /**
1870      * @notice Sender repays their own borrow
1871      * @param repayAmount The amount to repay
1872      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
1873      */
1874     function repayBorrowInternal(uint repayAmount) internal nonReentrant returns (uint) {
1875         uint error = accrueInterest();
1876         if (error != uint(Error.NO_ERROR)) {
1877             // accrueInterest emits logs on errors, but we still want to log the fact that an attempted borrow failed
1878             return fail(Error(error), FailureInfo.REPAY_BORROW_ACCRUE_INTEREST_FAILED);
1879         }
1880         // repayBorrowFresh emits repay-borrow-specific logs on errors, so we don't need to
1881         return repayBorrowFresh(msg.sender, msg.sender, repayAmount);
1882     }
1883 
1884     /**
1885      * @notice Sender repays a borrow belonging to borrower
1886      * @param borrower the account with the debt being payed off
1887      * @param repayAmount The amount to repay
1888      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
1889      */
1890     function repayBorrowBehalfInternal(address borrower, uint repayAmount) internal nonReentrant returns (uint) {
1891         uint error = accrueInterest();
1892         if (error != uint(Error.NO_ERROR)) {
1893             // accrueInterest emits logs on errors, but we still want to log the fact that an attempted borrow failed
1894             return fail(Error(error), FailureInfo.REPAY_BEHALF_ACCRUE_INTEREST_FAILED);
1895         }
1896         // repayBorrowFresh emits repay-borrow-specific logs on errors, so we don't need to
1897         return repayBorrowFresh(msg.sender, borrower, repayAmount);
1898     }
1899 
1900     struct RepayBorrowLocalVars {
1901         Error err;
1902         MathError mathErr;
1903         uint repayAmount;
1904         uint borrowerIndex;
1905         uint accountBorrows;
1906         uint accountBorrowsNew;
1907         uint totalBorrowsNew;
1908     }
1909 
1910     /**
1911      * @notice Borrows are repaid by another user (possibly the borrower).
1912      * @param payer the account paying off the borrow
1913      * @param borrower the account with the debt being payed off
1914      * @param repayAmount the amount of undelrying tokens being returned
1915      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
1916      */
1917     function repayBorrowFresh(address payer, address borrower, uint repayAmount) internal returns (uint) {
1918         /* Fail if repayBorrow not allowed */
1919         uint allowed = comptroller.repayBorrowAllowed(address(this), payer, borrower, repayAmount);
1920         if (allowed != 0) {
1921             return failOpaque(Error.COMPTROLLER_REJECTION, FailureInfo.REPAY_BORROW_COMPTROLLER_REJECTION, allowed);
1922         }
1923 
1924         /* Verify market's block number equals current block number */
1925         if (accrualBlockNumber != getBlockNumber()) {
1926             return fail(Error.MARKET_NOT_FRESH, FailureInfo.REPAY_BORROW_FRESHNESS_CHECK);
1927         }
1928 
1929         RepayBorrowLocalVars memory vars;
1930 
1931         /* We remember the original borrowerIndex for verification purposes */
1932         vars.borrowerIndex = accountBorrows[borrower].interestIndex;
1933 
1934         /* We fetch the amount the borrower owes, with accumulated interest */
1935         (vars.mathErr, vars.accountBorrows) = borrowBalanceStoredInternal(borrower);
1936         if (vars.mathErr != MathError.NO_ERROR) {
1937             return failOpaque(Error.MATH_ERROR, FailureInfo.REPAY_BORROW_ACCUMULATED_BALANCE_CALCULATION_FAILED, uint(vars.mathErr));
1938         }
1939 
1940         /* If repayAmount == -1, repayAmount = accountBorrows */
1941         if (repayAmount == uint(-1)) {
1942             vars.repayAmount = vars.accountBorrows;
1943         } else {
1944             vars.repayAmount = repayAmount;
1945         }
1946 
1947         /* Fail if checkTransferIn fails */
1948         vars.err = checkTransferIn(payer, vars.repayAmount);
1949         if (vars.err != Error.NO_ERROR) {
1950             return fail(vars.err, FailureInfo.REPAY_BORROW_TRANSFER_IN_NOT_POSSIBLE);
1951         }
1952 
1953         /*
1954          * We calculate the new borrower and total borrow balances, failing on underflow:
1955          *  accountBorrowsNew = accountBorrows - repayAmount
1956          *  totalBorrowsNew = totalBorrows - repayAmount
1957          */
1958         (vars.mathErr, vars.accountBorrowsNew) = subUInt(vars.accountBorrows, vars.repayAmount);
1959         if (vars.mathErr != MathError.NO_ERROR) {
1960             return failOpaque(Error.MATH_ERROR, FailureInfo.REPAY_BORROW_NEW_ACCOUNT_BORROW_BALANCE_CALCULATION_FAILED, uint(vars.mathErr));
1961         }
1962 
1963         (vars.mathErr, vars.totalBorrowsNew) = subUInt(totalBorrows, vars.repayAmount);
1964         if (vars.mathErr != MathError.NO_ERROR) {
1965             return failOpaque(Error.MATH_ERROR, FailureInfo.REPAY_BORROW_NEW_TOTAL_BALANCE_CALCULATION_FAILED, uint(vars.mathErr));
1966         }
1967 
1968         /////////////////////////
1969         // EFFECTS & INTERACTIONS
1970         // (No safe failures beyond this point)
1971 
1972         /*
1973          * We call doTransferIn for the payer and the repayAmount
1974          *  Note: The cToken must handle variations between ERC-20 and ETH underlying.
1975          *  On success, the cToken holds an additional repayAmount of cash.
1976          *  If doTransferIn fails despite the fact we checked pre-conditions,
1977          *   we revert because we can't be sure if side effects occurred.
1978          */
1979         vars.err = doTransferIn(payer, vars.repayAmount);
1980         require(vars.err == Error.NO_ERROR, "repay borrow transfer in failed");
1981 
1982         /* We write the previously calculated values into storage */
1983         accountBorrows[borrower].principal = vars.accountBorrowsNew;
1984         accountBorrows[borrower].interestIndex = borrowIndex;
1985         totalBorrows = vars.totalBorrowsNew;
1986 
1987         /* We emit a RepayBorrow event */
1988         emit RepayBorrow(payer, borrower, vars.repayAmount, vars.accountBorrowsNew, vars.totalBorrowsNew);
1989 
1990         /* We call the defense hook */
1991         comptroller.repayBorrowVerify(address(this), payer, borrower, vars.repayAmount, vars.borrowerIndex);
1992 
1993         return uint(Error.NO_ERROR);
1994     }
1995 
1996     /**
1997      * @notice The sender liquidates the borrowers collateral.
1998      *  The collateral seized is transferred to the liquidator.
1999      * @param borrower The borrower of this cToken to be liquidated
2000      * @param cTokenCollateral The market in which to seize collateral from the borrower
2001      * @param repayAmount The amount of the underlying borrowed asset to repay
2002      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
2003      */
2004     function liquidateBorrowInternal(address borrower, uint repayAmount, CToken cTokenCollateral) internal nonReentrant returns (uint) {
2005         uint error = accrueInterest();
2006         if (error != uint(Error.NO_ERROR)) {
2007             // accrueInterest emits logs on errors, but we still want to log the fact that an attempted liquidation failed
2008             return fail(Error(error), FailureInfo.LIQUIDATE_ACCRUE_BORROW_INTEREST_FAILED);
2009         }
2010 
2011         error = cTokenCollateral.accrueInterest();
2012         if (error != uint(Error.NO_ERROR)) {
2013             // accrueInterest emits logs on errors, but we still want to log the fact that an attempted liquidation failed
2014             return fail(Error(error), FailureInfo.LIQUIDATE_ACCRUE_COLLATERAL_INTEREST_FAILED);
2015         }
2016 
2017         // liquidateBorrowFresh emits borrow-specific logs on errors, so we don't need to
2018         return liquidateBorrowFresh(msg.sender, borrower, repayAmount, cTokenCollateral);
2019     }
2020 
2021     /**
2022      * @notice The liquidator liquidates the borrowers collateral.
2023      *  The collateral seized is transferred to the liquidator.
2024      * @param borrower The borrower of this cToken to be liquidated
2025      * @param liquidator The address repaying the borrow and seizing collateral
2026      * @param cTokenCollateral The market in which to seize collateral from the borrower
2027      * @param repayAmount The amount of the underlying borrowed asset to repay
2028      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
2029      */
2030     function liquidateBorrowFresh(address liquidator, address borrower, uint repayAmount, CToken cTokenCollateral) internal returns (uint) {
2031         /* Fail if liquidate not allowed */
2032         uint allowed = comptroller.liquidateBorrowAllowed(address(this), address(cTokenCollateral), liquidator, borrower, repayAmount);
2033         if (allowed != 0) {
2034             return failOpaque(Error.COMPTROLLER_REJECTION, FailureInfo.LIQUIDATE_COMPTROLLER_REJECTION, allowed);
2035         }
2036 
2037         /* Verify market's block number equals current block number */
2038         if (accrualBlockNumber != getBlockNumber()) {
2039             return fail(Error.MARKET_NOT_FRESH, FailureInfo.LIQUIDATE_FRESHNESS_CHECK);
2040         }
2041 
2042         /* Verify cTokenCollateral market's block number equals current block number */
2043         if (cTokenCollateral.accrualBlockNumber() != getBlockNumber()) {
2044             return fail(Error.MARKET_NOT_FRESH, FailureInfo.LIQUIDATE_COLLATERAL_FRESHNESS_CHECK);
2045         }
2046 
2047         /* Fail if borrower = liquidator */
2048         if (borrower == liquidator) {
2049             return fail(Error.INVALID_ACCOUNT_PAIR, FailureInfo.LIQUIDATE_LIQUIDATOR_IS_BORROWER);
2050         }
2051 
2052         /* Fail if repayAmount = 0 */
2053         if (repayAmount == 0) {
2054             return fail(Error.INVALID_CLOSE_AMOUNT_REQUESTED, FailureInfo.LIQUIDATE_CLOSE_AMOUNT_IS_ZERO);
2055         }
2056 
2057         /* Fail if repayAmount = -1 */
2058         if (repayAmount == uint(-1)) {
2059             return fail(Error.INVALID_CLOSE_AMOUNT_REQUESTED, FailureInfo.LIQUIDATE_CLOSE_AMOUNT_IS_UINT_MAX);
2060         }
2061 
2062         /* We calculate the number of collateral tokens that will be seized */
2063         (uint amountSeizeError, uint seizeTokens) = comptroller.liquidateCalculateSeizeTokens(address(this), address(cTokenCollateral), repayAmount);
2064         if (amountSeizeError != 0) {
2065             return failOpaque(Error.COMPTROLLER_CALCULATION_ERROR, FailureInfo.LIQUIDATE_COMPTROLLER_CALCULATE_AMOUNT_SEIZE_FAILED, amountSeizeError);
2066         }
2067 
2068         /* Fail if seizeTokens > borrower collateral token balance */
2069         if (seizeTokens > cTokenCollateral.balanceOf(borrower)) {
2070             return fail(Error.TOKEN_INSUFFICIENT_BALANCE, FailureInfo.LIQUIDATE_SEIZE_TOO_MUCH);
2071         }
2072 
2073         /* Fail if repayBorrow fails */
2074         uint repayBorrowError = repayBorrowFresh(liquidator, borrower, repayAmount);
2075         if (repayBorrowError != uint(Error.NO_ERROR)) {
2076             return fail(Error(repayBorrowError), FailureInfo.LIQUIDATE_REPAY_BORROW_FRESH_FAILED);
2077         }
2078 
2079         /* Revert if seize tokens fails (since we cannot be sure of side effects) */
2080         uint seizeError = cTokenCollateral.seize(liquidator, borrower, seizeTokens);
2081         require(seizeError == uint(Error.NO_ERROR), "token seizure failed");
2082 
2083         /* We emit a LiquidateBorrow event */
2084         emit LiquidateBorrow(liquidator, borrower, repayAmount, address(cTokenCollateral), seizeTokens);
2085 
2086         /* We call the defense hook */
2087         comptroller.liquidateBorrowVerify(address(this), address(cTokenCollateral), liquidator, borrower, repayAmount, seizeTokens);
2088 
2089         return uint(Error.NO_ERROR);
2090     }
2091 
2092     /**
2093      * @notice Transfers collateral tokens (this market) to the liquidator.
2094      * @dev Will fail unless called by another cToken during the process of liquidation.
2095      *  Its absolutely critical to use msg.sender as the borrowed cToken and not a parameter.
2096      * @param liquidator The account receiving seized collateral
2097      * @param borrower The account having collateral seized
2098      * @param seizeTokens The number of cTokens to seize
2099      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
2100      */
2101     function seize(address liquidator, address borrower, uint seizeTokens) external nonReentrant returns (uint) {
2102         /* Fail if seize not allowed */
2103         uint allowed = comptroller.seizeAllowed(address(this), msg.sender, liquidator, borrower, seizeTokens);
2104         if (allowed != 0) {
2105             return failOpaque(Error.COMPTROLLER_REJECTION, FailureInfo.LIQUIDATE_SEIZE_COMPTROLLER_REJECTION, allowed);
2106         }
2107 
2108         /* Fail if borrower = liquidator */
2109         if (borrower == liquidator) {
2110             return fail(Error.INVALID_ACCOUNT_PAIR, FailureInfo.LIQUIDATE_SEIZE_LIQUIDATOR_IS_BORROWER);
2111         }
2112 
2113         MathError mathErr;
2114         uint borrowerTokensNew;
2115         uint liquidatorTokensNew;
2116 
2117         /*
2118          * We calculate the new borrower and liquidator token balances, failing on underflow/overflow:
2119          *  borrowerTokensNew = accountTokens[borrower] - seizeTokens
2120          *  liquidatorTokensNew = accountTokens[liquidator] + seizeTokens
2121          */
2122         (mathErr, borrowerTokensNew) = subUInt(accountTokens[borrower], seizeTokens);
2123         if (mathErr != MathError.NO_ERROR) {
2124             return failOpaque(Error.MATH_ERROR, FailureInfo.LIQUIDATE_SEIZE_BALANCE_DECREMENT_FAILED, uint(mathErr));
2125         }
2126 
2127         (mathErr, liquidatorTokensNew) = addUInt(accountTokens[liquidator], seizeTokens);
2128         if (mathErr != MathError.NO_ERROR) {
2129             return failOpaque(Error.MATH_ERROR, FailureInfo.LIQUIDATE_SEIZE_BALANCE_INCREMENT_FAILED, uint(mathErr));
2130         }
2131 
2132         /////////////////////////
2133         // EFFECTS & INTERACTIONS
2134         // (No safe failures beyond this point)
2135 
2136         /* We write the previously calculated values into storage */
2137         accountTokens[borrower] = borrowerTokensNew;
2138         accountTokens[liquidator] = liquidatorTokensNew;
2139 
2140         /* Emit a Transfer event */
2141         emit Transfer(borrower, liquidator, seizeTokens);
2142 
2143         /* We call the defense hook */
2144         comptroller.seizeVerify(address(this), msg.sender, liquidator, borrower, seizeTokens);
2145 
2146         return uint(Error.NO_ERROR);
2147     }
2148 
2149 
2150     /*** Admin Functions ***/
2151 
2152     /**
2153       * @notice Begins transfer of admin rights. The newPendingAdmin must call `_acceptAdmin` to finalize the transfer.
2154       * @dev Admin function to begin change of admin. The newPendingAdmin must call `_acceptAdmin` to finalize the transfer.
2155       * @param newPendingAdmin New pending admin.
2156       * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
2157       *
2158       * TODO: Should we add a second arg to verify, like a checksum of `newAdmin` address?
2159       */
2160     function _setPendingAdmin(address payable newPendingAdmin) external returns (uint) {
2161         // Check caller = admin
2162         if (msg.sender != admin) {
2163             return fail(Error.UNAUTHORIZED, FailureInfo.SET_PENDING_ADMIN_OWNER_CHECK);
2164         }
2165 
2166         // Save current value, if any, for inclusion in log
2167         address oldPendingAdmin = pendingAdmin;
2168 
2169         // Store pendingAdmin with value newPendingAdmin
2170         pendingAdmin = newPendingAdmin;
2171 
2172         // Emit NewPendingAdmin(oldPendingAdmin, newPendingAdmin)
2173         emit NewPendingAdmin(oldPendingAdmin, newPendingAdmin);
2174 
2175         return uint(Error.NO_ERROR);
2176     }
2177 
2178     /**
2179       * @notice Accepts transfer of admin rights. msg.sender must be pendingAdmin
2180       * @dev Admin function for pending admin to accept role and update admin
2181       * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
2182       */
2183     function _acceptAdmin() external returns (uint) {
2184         // Check caller is pendingAdmin and pendingAdmin ≠ address(0)
2185         if (msg.sender != pendingAdmin || msg.sender == address(0)) {
2186             return fail(Error.UNAUTHORIZED, FailureInfo.ACCEPT_ADMIN_PENDING_ADMIN_CHECK);
2187         }
2188 
2189         // Save current values for inclusion in log
2190         address oldAdmin = admin;
2191         address oldPendingAdmin = pendingAdmin;
2192 
2193         // Store admin with value pendingAdmin
2194         admin = pendingAdmin;
2195 
2196         // Clear the pending value
2197         pendingAdmin = address(0);
2198 
2199         emit NewAdmin(oldAdmin, admin);
2200         emit NewPendingAdmin(oldPendingAdmin, pendingAdmin);
2201 
2202         return uint(Error.NO_ERROR);
2203     }
2204 
2205     /**
2206       * @notice Sets a new comptroller for the market
2207       * @dev Admin function to set a new comptroller
2208       * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
2209       */
2210     function _setComptroller(ComptrollerInterface newComptroller) public returns (uint) {
2211         // Check caller is admin
2212         if (msg.sender != admin) {
2213             return fail(Error.UNAUTHORIZED, FailureInfo.SET_COMPTROLLER_OWNER_CHECK);
2214         }
2215 
2216         ComptrollerInterface oldComptroller = comptroller;
2217         // Ensure invoke comptroller.isComptroller() returns true
2218         require(newComptroller.isComptroller(), "marker method returned false");
2219 
2220         // Set market's comptroller to newComptroller
2221         comptroller = newComptroller;
2222 
2223         // Emit NewComptroller(oldComptroller, newComptroller)
2224         emit NewComptroller(oldComptroller, newComptroller);
2225 
2226         return uint(Error.NO_ERROR);
2227     }
2228 
2229     /**
2230       * @notice accrues interest and sets a new reserve factor for the protocol using _setReserveFactorFresh
2231       * @dev Admin function to accrue interest and set a new reserve factor
2232       * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
2233       */
2234     function _setReserveFactor(uint newReserveFactorMantissa) external nonReentrant returns (uint) {
2235         uint error = accrueInterest();
2236         if (error != uint(Error.NO_ERROR)) {
2237             // accrueInterest emits logs on errors, but on top of that we want to log the fact that an attempted reserve factor change failed.
2238             return fail(Error(error), FailureInfo.SET_RESERVE_FACTOR_ACCRUE_INTEREST_FAILED);
2239         }
2240         // _setReserveFactorFresh emits reserve-factor-specific logs on errors, so we don't need to.
2241         return _setReserveFactorFresh(newReserveFactorMantissa);
2242     }
2243 
2244     /**
2245       * @notice Sets a new reserve factor for the protocol (*requires fresh interest accrual)
2246       * @dev Admin function to set a new reserve factor
2247       * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
2248       */
2249     function _setReserveFactorFresh(uint newReserveFactorMantissa) internal returns (uint) {
2250         // Check caller is admin
2251         if (msg.sender != admin) {
2252             return fail(Error.UNAUTHORIZED, FailureInfo.SET_RESERVE_FACTOR_ADMIN_CHECK);
2253         }
2254 
2255         // Verify market's block number equals current block number
2256         if (accrualBlockNumber != getBlockNumber()) {
2257             // TODO: static_assert + no error code?
2258             return fail(Error.MARKET_NOT_FRESH, FailureInfo.SET_RESERVE_FACTOR_FRESH_CHECK);
2259         }
2260 
2261         // Check newReserveFactor ≤ maxReserveFactor
2262         if (newReserveFactorMantissa > reserveFactorMaxMantissa) {
2263             return fail(Error.BAD_INPUT, FailureInfo.SET_RESERVE_FACTOR_BOUNDS_CHECK);
2264         }
2265 
2266         uint oldReserveFactorMantissa = reserveFactorMantissa;
2267         reserveFactorMantissa = newReserveFactorMantissa;
2268 
2269         emit NewReserveFactor(oldReserveFactorMantissa, newReserveFactorMantissa);
2270 
2271         return uint(Error.NO_ERROR);
2272     }
2273 
2274     /**
2275      * @notice Accrues interest and reduces reserves by transferring to admin
2276      * @param reduceAmount Amount of reduction to reserves
2277      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
2278      */
2279     function _reduceReserves(uint reduceAmount) external nonReentrant returns (uint) {
2280         uint error = accrueInterest();
2281         if (error != uint(Error.NO_ERROR)) {
2282             // accrueInterest emits logs on errors, but on top of that we want to log the fact that an attempted reduce reserves failed.
2283             return fail(Error(error), FailureInfo.REDUCE_RESERVES_ACCRUE_INTEREST_FAILED);
2284         }
2285         // _reduceReservesFresh emits reserve-reduction-specific logs on errors, so we don't need to.
2286         return _reduceReservesFresh(reduceAmount);
2287     }
2288 
2289     /**
2290      * @notice Reduces reserves by transferring to admin
2291      * @dev Requires fresh interest accrual
2292      * @param reduceAmount Amount of reduction to reserves
2293      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
2294      */
2295     function _reduceReservesFresh(uint reduceAmount) internal returns (uint) {
2296         Error err;
2297         // totalReserves - reduceAmount
2298         uint totalReservesNew;
2299 
2300         // Check caller is admin
2301         if (msg.sender != admin) {
2302             return fail(Error.UNAUTHORIZED, FailureInfo.REDUCE_RESERVES_ADMIN_CHECK);
2303         }
2304 
2305         // We fail gracefully unless market's block number equals current block number
2306         if (accrualBlockNumber != getBlockNumber()) {
2307             // TODO: static_assert + no error code?
2308             return fail(Error.MARKET_NOT_FRESH, FailureInfo.REDUCE_RESERVES_FRESH_CHECK);
2309         }
2310 
2311         // Fail gracefully if protocol has insufficient underlying cash
2312         if (getCashPrior() < reduceAmount) {
2313             return fail(Error.TOKEN_INSUFFICIENT_CASH, FailureInfo.REDUCE_RESERVES_CASH_NOT_AVAILABLE);
2314         }
2315 
2316         // Check reduceAmount ≤ reserves[n] (totalReserves)
2317         // TODO: I'm following the spec literally here but I think we should we just use SafeMath instead and fail on an error (which would be underflow)
2318         if (reduceAmount > totalReserves) {
2319             return fail(Error.BAD_INPUT, FailureInfo.REDUCE_RESERVES_VALIDATION);
2320         }
2321 
2322         /////////////////////////
2323         // EFFECTS & INTERACTIONS
2324         // (No safe failures beyond this point)
2325 
2326         totalReservesNew = totalReserves - reduceAmount;
2327         // We checked reduceAmount <= totalReserves above, so this should never revert.
2328         require(totalReservesNew <= totalReserves, "reduce reserves unexpected underflow");
2329 
2330         // Store reserves[n+1] = reserves[n] - reduceAmount
2331         totalReserves = totalReservesNew;
2332 
2333         // invoke doTransferOut(reduceAmount, admin)
2334         err = doTransferOut(admin, reduceAmount);
2335         // we revert on the failure of this command
2336         require(err == Error.NO_ERROR, "reduce reserves transfer out failed");
2337 
2338         emit ReservesReduced(admin, reduceAmount, totalReservesNew);
2339 
2340         return uint(Error.NO_ERROR);
2341     }
2342 
2343     /**
2344      * @notice accrues interest and updates the interest rate model using _setInterestRateModelFresh
2345      * @dev Admin function to accrue interest and update the interest rate model
2346      * @param newInterestRateModel the new interest rate model to use
2347      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
2348      */
2349     function _setInterestRateModel(InterestRateModel newInterestRateModel) public returns (uint) {
2350         uint error = accrueInterest();
2351         if (error != uint(Error.NO_ERROR)) {
2352             // accrueInterest emits logs on errors, but on top of that we want to log the fact that an attempted change of interest rate model failed
2353             return fail(Error(error), FailureInfo.SET_INTEREST_RATE_MODEL_ACCRUE_INTEREST_FAILED);
2354         }
2355         // _setInterestRateModelFresh emits interest-rate-model-update-specific logs on errors, so we don't need to.
2356         return _setInterestRateModelFresh(newInterestRateModel);
2357     }
2358 
2359     /**
2360      * @notice updates the interest rate model (*requires fresh interest accrual)
2361      * @dev Admin function to update the interest rate model
2362      * @param newInterestRateModel the new interest rate model to use
2363      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
2364      */
2365     function _setInterestRateModelFresh(InterestRateModel newInterestRateModel) internal returns (uint) {
2366 
2367         // Used to store old model for use in the event that is emitted on success
2368         InterestRateModel oldInterestRateModel;
2369 
2370         // Check caller is admin
2371         if (msg.sender != admin) {
2372             return fail(Error.UNAUTHORIZED, FailureInfo.SET_INTEREST_RATE_MODEL_OWNER_CHECK);
2373         }
2374 
2375         // We fail gracefully unless market's block number equals current block number
2376         if (accrualBlockNumber != getBlockNumber()) {
2377             // TODO: static_assert + no error code?
2378             return fail(Error.MARKET_NOT_FRESH, FailureInfo.SET_INTEREST_RATE_MODEL_FRESH_CHECK);
2379         }
2380 
2381         // Track the market's current interest rate model
2382         oldInterestRateModel = interestRateModel;
2383 
2384         // Ensure invoke newInterestRateModel.isInterestRateModel() returns true
2385         require(newInterestRateModel.isInterestRateModel(), "marker method returned false");
2386 
2387         // Set the interest rate model to newInterestRateModel
2388         interestRateModel = newInterestRateModel;
2389 
2390         // Emit NewMarketInterestRateModel(oldInterestRateModel, newInterestRateModel)
2391         emit NewMarketInterestRateModel(oldInterestRateModel, newInterestRateModel);
2392 
2393         return uint(Error.NO_ERROR);
2394     }
2395 
2396     /*** Safe Token ***/
2397 
2398     /**
2399      * @notice Gets balance of this contract in terms of the underlying
2400      * @dev This excludes the value of the current message, if any
2401      * @return The quantity of underlying owned by this contract
2402      */
2403     function getCashPrior() internal view returns (uint);
2404 
2405     /**
2406      * @dev Checks whether or not there is sufficient allowance for this contract to move amount from `from` and
2407      *      whether or not `from` has a balance of at least `amount`. Does NOT do a transfer.
2408      */
2409     function checkTransferIn(address from, uint amount) internal view returns (Error);
2410 
2411     /**
2412      * @dev Performs a transfer in, ideally returning an explanatory error code upon failure rather than reverting.
2413      *  If caller has not called `checkTransferIn`, this may revert due to insufficient balance or insufficient allowance.
2414      *  If caller has called `checkTransferIn` successfully, this should not revert in normal conditions.
2415      */
2416     function doTransferIn(address from, uint amount) internal returns (Error);
2417 
2418     /**
2419      * @dev Performs a transfer out, ideally returning an explanatory error code upon failure tather than reverting.
2420      *  If caller has not called checked protocol's balance, may revert due to insufficient cash held in the contract.
2421      *  If caller has checked protocol's balance, and verified it is >= amount, this should not revert in normal conditions.
2422      */
2423     function doTransferOut(address payable to, uint amount) internal returns (Error);
2424 }
2425 
2426 // File: contracts/CErc20.sol
2427 
2428 pragma solidity ^0.5.8;
2429 
2430 
2431 /**
2432  * @title Compound's CErc20 Contract
2433  * @notice CTokens which wrap an EIP-20 underlying
2434  * @author Compound
2435  */
2436 contract CErc20 is CToken {
2437 
2438     /**
2439      * @notice Underlying asset for this CToken
2440      */
2441     address public underlying;
2442 
2443     /**
2444      * @notice Construct a new money market
2445      * @param underlying_ The address of the underlying asset
2446      * @param comptroller_ The address of the Comptroller
2447      * @param interestRateModel_ The address of the interest rate model
2448      * @param initialExchangeRateMantissa_ The initial exchange rate, scaled by 1e18
2449      * @param name_ ERC-20 name of this token
2450      * @param symbol_ ERC-20 symbol of this token
2451      * @param decimals_ ERC-20 decimal precision of this token
2452      */
2453     constructor(address underlying_,
2454                 ComptrollerInterface comptroller_,
2455                 InterestRateModel interestRateModel_,
2456                 uint initialExchangeRateMantissa_,
2457                 string memory name_,
2458                 string memory symbol_,
2459                 uint decimals_) public
2460     CToken(comptroller_, interestRateModel_, initialExchangeRateMantissa_, name_, symbol_, decimals_) {
2461         // Set underlying
2462         underlying = underlying_;
2463         EIP20Interface(underlying).totalSupply(); // Sanity check the underlying
2464     }
2465 
2466     /*** User Interface ***/
2467 
2468     /**
2469      * @notice Sender supplies assets into the market and receives cTokens in exchange
2470      * @dev Accrues interest whether or not the operation succeeds, unless reverted
2471      * @param mintAmount The amount of the underlying asset to supply
2472      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
2473      */
2474     function mint(uint mintAmount) external returns (uint) {
2475         return mintInternal(mintAmount);
2476     }
2477 
2478     /**
2479      * @notice Sender redeems cTokens in exchange for the underlying asset
2480      * @dev Accrues interest whether or not the operation succeeds, unless reverted
2481      * @param redeemTokens The number of cTokens to redeem into underlying
2482      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
2483      */
2484     function redeem(uint redeemTokens) external returns (uint) {
2485         return redeemInternal(redeemTokens);
2486     }
2487 
2488     /**
2489      * @notice Sender redeems cTokens in exchange for a specified amount of underlying asset
2490      * @dev Accrues interest whether or not the operation succeeds, unless reverted
2491      * @param redeemAmount The amount of underlying to redeem
2492      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
2493      */
2494     function redeemUnderlying(uint redeemAmount) external returns (uint) {
2495         return redeemUnderlyingInternal(redeemAmount);
2496     }
2497 
2498     /**
2499       * @notice Sender borrows assets from the protocol to their own address
2500       * @param borrowAmount The amount of the underlying asset to borrow
2501       * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
2502       */
2503     function borrow(uint borrowAmount) external returns (uint) {
2504         return borrowInternal(borrowAmount);
2505     }
2506 
2507     /**
2508      * @notice Sender repays their own borrow
2509      * @param repayAmount The amount to repay
2510      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
2511      */
2512     function repayBorrow(uint repayAmount) external returns (uint) {
2513         return repayBorrowInternal(repayAmount);
2514     }
2515 
2516     /**
2517      * @notice Sender repays a borrow belonging to borrower
2518      * @param borrower the account with the debt being payed off
2519      * @param repayAmount The amount to repay
2520      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
2521      */
2522     function repayBorrowBehalf(address borrower, uint repayAmount) external returns (uint) {
2523         return repayBorrowBehalfInternal(borrower, repayAmount);
2524     }
2525 
2526     /**
2527      * @notice The sender liquidates the borrowers collateral.
2528      *  The collateral seized is transferred to the liquidator.
2529      * @param borrower The borrower of this cToken to be liquidated
2530      * @param cTokenCollateral The market in which to seize collateral from the borrower
2531      * @param repayAmount The amount of the underlying borrowed asset to repay
2532      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
2533      */
2534     function liquidateBorrow(address borrower, uint repayAmount, CToken cTokenCollateral) external returns (uint) {
2535         return liquidateBorrowInternal(borrower, repayAmount, cTokenCollateral);
2536     }
2537 
2538     /*** Safe Token ***/
2539 
2540     /**
2541      * @notice Gets balance of this contract in terms of the underlying
2542      * @dev This excludes the value of the current message, if any
2543      * @return The quantity of underlying tokens owned by this contract
2544      */
2545     function getCashPrior() internal view returns (uint) {
2546         EIP20Interface token = EIP20Interface(underlying);
2547         return token.balanceOf(address(this));
2548     }
2549 
2550     /**
2551      * @dev Checks whether or not there is sufficient allowance for this contract to move amount from `from` and
2552      *      whether or not `from` has a balance of at least `amount`. Does NOT do a transfer.
2553      */
2554     function checkTransferIn(address from, uint amount) internal view returns (Error) {
2555         EIP20Interface token = EIP20Interface(underlying);
2556 
2557         if (token.allowance(from, address(this)) < amount) {
2558             return Error.TOKEN_INSUFFICIENT_ALLOWANCE;
2559         }
2560 
2561         if (token.balanceOf(from) < amount) {
2562             return Error.TOKEN_INSUFFICIENT_BALANCE;
2563         }
2564 
2565         return Error.NO_ERROR;
2566     }
2567 
2568     /**
2569      * @dev Similar to EIP20 transfer, except it handles a False result from `transferFrom` and returns an explanatory
2570      *      error code rather than reverting.  If caller has not called `checkTransferIn`, this may revert due to
2571      *      insufficient balance or insufficient allowance. If caller has called `checkTransferIn` prior to this call,
2572      *      and it returned Error.NO_ERROR, this should not revert in normal conditions.
2573      *
2574      *      Note: This wrapper safely handles non-standard ERC-20 tokens that do not return a value.
2575      *            See here: https://medium.com/coinmonks/missing-return-value-bug-at-least-130-tokens-affected-d67bf08521ca
2576      */
2577     function doTransferIn(address from, uint amount) internal returns (Error) {
2578         EIP20NonStandardInterface token = EIP20NonStandardInterface(underlying);
2579         bool result;
2580 
2581         token.transferFrom(from, address(this), amount);
2582 
2583         // solium-disable-next-line security/no-inline-assembly
2584         assembly {
2585             switch returndatasize()
2586                 case 0 {                      // This is a non-standard ERC-20
2587                     result := not(0)          // set result to true
2588                 }
2589                 case 32 {                     // This is a complaint ERC-20
2590                     returndatacopy(0, 0, 32)
2591                     result := mload(0)        // Set `result = returndata` of external call
2592                 }
2593                 default {                     // This is an excessively non-compliant ERC-20, revert.
2594                     revert(0, 0)
2595                 }
2596         }
2597 
2598         if (!result) {
2599             return Error.TOKEN_TRANSFER_IN_FAILED;
2600         }
2601 
2602         return Error.NO_ERROR;
2603     }
2604 
2605     /**
2606      * @dev Similar to EIP20 transfer, except it handles a False result from `transfer` and returns an explanatory
2607      *      error code rather than reverting. If caller has not called checked protocol's balance, this may revert due to
2608      *      insufficient cash held in this contract. If caller has checked protocol's balance prior to this call, and verified
2609      *      it is >= amount, this should not revert in normal conditions.
2610      *
2611      *      Note: This wrapper safely handles non-standard ERC-20 tokens that do not return a value.
2612      *            See here: https://medium.com/coinmonks/missing-return-value-bug-at-least-130-tokens-affected-d67bf08521ca
2613      */
2614     function doTransferOut(address payable to, uint amount) internal returns (Error) {
2615         EIP20NonStandardInterface token = EIP20NonStandardInterface(underlying);
2616         bool result;
2617 
2618         token.transfer(to, amount);
2619 
2620         // solium-disable-next-line security/no-inline-assembly
2621         assembly {
2622             switch returndatasize()
2623                 case 0 {                      // This is a non-standard ERC-20
2624                     result := not(0)          // set result to true
2625                 }
2626                 case 32 {                     // This is a complaint ERC-20
2627                     returndatacopy(0, 0, 32)
2628                     result := mload(0)        // Set `result = returndata` of external call
2629                 }
2630                 default {                     // This is an excessively non-compliant ERC-20, revert.
2631                     revert(0, 0)
2632                 }
2633         }
2634 
2635         if (!result) {
2636             return Error.TOKEN_TRANSFER_OUT_FAILED;
2637         }
2638 
2639         return Error.NO_ERROR;
2640     }
2641 }
