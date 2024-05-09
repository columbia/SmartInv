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
287 // File: contracts/CarefulMath.sol
288 
289 pragma solidity ^0.5.8;
290 
291 /**
292   * @title Careful Math
293   * @author Compound
294   * @notice Derived from OpenZeppelin's SafeMath library
295   *         https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/math/SafeMath.sol
296   */
297 contract CarefulMath {
298 
299     /**
300      * @dev Possible error codes that we can return
301      */
302     enum MathError {
303         NO_ERROR,
304         DIVISION_BY_ZERO,
305         INTEGER_OVERFLOW,
306         INTEGER_UNDERFLOW
307     }
308 
309     /**
310     * @dev Multiplies two numbers, returns an error on overflow.
311     */
312     function mulUInt(uint a, uint b) internal pure returns (MathError, uint) {
313         if (a == 0) {
314             return (MathError.NO_ERROR, 0);
315         }
316 
317         uint c = a * b;
318 
319         if (c / a != b) {
320             return (MathError.INTEGER_OVERFLOW, 0);
321         } else {
322             return (MathError.NO_ERROR, c);
323         }
324     }
325 
326     /**
327     * @dev Integer division of two numbers, truncating the quotient.
328     */
329     function divUInt(uint a, uint b) internal pure returns (MathError, uint) {
330         if (b == 0) {
331             return (MathError.DIVISION_BY_ZERO, 0);
332         }
333 
334         return (MathError.NO_ERROR, a / b);
335     }
336 
337     /**
338     * @dev Subtracts two numbers, returns an error on overflow (i.e. if subtrahend is greater than minuend).
339     */
340     function subUInt(uint a, uint b) internal pure returns (MathError, uint) {
341         if (b <= a) {
342             return (MathError.NO_ERROR, a - b);
343         } else {
344             return (MathError.INTEGER_UNDERFLOW, 0);
345         }
346     }
347 
348     /**
349     * @dev Adds two numbers, returns an error on overflow.
350     */
351     function addUInt(uint a, uint b) internal pure returns (MathError, uint) {
352         uint c = a + b;
353 
354         if (c >= a) {
355             return (MathError.NO_ERROR, c);
356         } else {
357             return (MathError.INTEGER_OVERFLOW, 0);
358         }
359     }
360 
361     /**
362     * @dev add a and b and then subtract c
363     */
364     function addThenSubUInt(uint a, uint b, uint c) internal pure returns (MathError, uint) {
365         (MathError err0, uint sum) = addUInt(a, b);
366 
367         if (err0 != MathError.NO_ERROR) {
368             return (err0, 0);
369         }
370 
371         return subUInt(sum, c);
372     }
373 }
374 
375 // File: contracts/Exponential.sol
376 
377 pragma solidity ^0.5.8;
378 
379 
380 /**
381  * @title Exponential module for storing fixed-decision decimals
382  * @author Compound
383  * @notice Exp is a struct which stores decimals with a fixed precision of 18 decimal places.
384  *         Thus, if we wanted to store the 5.1, mantissa would store 5.1e18. That is:
385  *         `Exp({mantissa: 5100000000000000000})`.
386  */
387 contract Exponential is CarefulMath {
388     uint constant expScale = 1e18;
389     uint constant halfExpScale = expScale/2;
390     uint constant mantissaOne = expScale;
391 
392     struct Exp {
393         uint mantissa;
394     }
395 
396     /**
397      * @dev Creates an exponential from numerator and denominator values.
398      *      Note: Returns an error if (`num` * 10e18) > MAX_INT,
399      *            or if `denom` is zero.
400      */
401     function getExp(uint num, uint denom) pure internal returns (MathError, Exp memory) {
402         (MathError err0, uint scaledNumerator) = mulUInt(num, expScale);
403         if (err0 != MathError.NO_ERROR) {
404             return (err0, Exp({mantissa: 0}));
405         }
406 
407         (MathError err1, uint rational) = divUInt(scaledNumerator, denom);
408         if (err1 != MathError.NO_ERROR) {
409             return (err1, Exp({mantissa: 0}));
410         }
411 
412         return (MathError.NO_ERROR, Exp({mantissa: rational}));
413     }
414 
415     /**
416      * @dev Adds two exponentials, returning a new exponential.
417      */
418     function addExp(Exp memory a, Exp memory b) pure internal returns (MathError, Exp memory) {
419         (MathError error, uint result) = addUInt(a.mantissa, b.mantissa);
420 
421         return (error, Exp({mantissa: result}));
422     }
423 
424     /**
425      * @dev Subtracts two exponentials, returning a new exponential.
426      */
427     function subExp(Exp memory a, Exp memory b) pure internal returns (MathError, Exp memory) {
428         (MathError error, uint result) = subUInt(a.mantissa, b.mantissa);
429 
430         return (error, Exp({mantissa: result}));
431     }
432 
433     /**
434      * @dev Multiply an Exp by a scalar, returning a new Exp.
435      */
436     function mulScalar(Exp memory a, uint scalar) pure internal returns (MathError, Exp memory) {
437         (MathError err0, uint scaledMantissa) = mulUInt(a.mantissa, scalar);
438         if (err0 != MathError.NO_ERROR) {
439             return (err0, Exp({mantissa: 0}));
440         }
441 
442         return (MathError.NO_ERROR, Exp({mantissa: scaledMantissa}));
443     }
444 
445     /**
446      * @dev Multiply an Exp by a scalar, then truncate to return an unsigned integer.
447      */
448     function mulScalarTruncate(Exp memory a, uint scalar) pure internal returns (MathError, uint) {
449         (MathError err, Exp memory product) = mulScalar(a, scalar);
450         if (err != MathError.NO_ERROR) {
451             return (err, 0);
452         }
453 
454         return (MathError.NO_ERROR, truncate(product));
455     }
456 
457     /**
458      * @dev Multiply an Exp by a scalar, truncate, then add an to an unsigned integer, returning an unsigned integer.
459      */
460     function mulScalarTruncateAddUInt(Exp memory a, uint scalar, uint addend) pure internal returns (MathError, uint) {
461         (MathError err, Exp memory product) = mulScalar(a, scalar);
462         if (err != MathError.NO_ERROR) {
463             return (err, 0);
464         }
465 
466         return addUInt(truncate(product), addend);
467     }
468 
469     /**
470      * @dev Divide an Exp by a scalar, returning a new Exp.
471      */
472     function divScalar(Exp memory a, uint scalar) pure internal returns (MathError, Exp memory) {
473         (MathError err0, uint descaledMantissa) = divUInt(a.mantissa, scalar);
474         if (err0 != MathError.NO_ERROR) {
475             return (err0, Exp({mantissa: 0}));
476         }
477 
478         return (MathError.NO_ERROR, Exp({mantissa: descaledMantissa}));
479     }
480 
481     /**
482      * @dev Divide a scalar by an Exp, returning a new Exp.
483      */
484     function divScalarByExp(uint scalar, Exp memory divisor) pure internal returns (MathError, Exp memory) {
485         /*
486           We are doing this as:
487           getExp(mulUInt(expScale, scalar), divisor.mantissa)
488 
489           How it works:
490           Exp = a / b;
491           Scalar = s;
492           `s / (a / b)` = `b * s / a` and since for an Exp `a = mantissa, b = expScale`
493         */
494         (MathError err0, uint numerator) = mulUInt(expScale, scalar);
495         if (err0 != MathError.NO_ERROR) {
496             return (err0, Exp({mantissa: 0}));
497         }
498         return getExp(numerator, divisor.mantissa);
499     }
500 
501     /**
502      * @dev Divide a scalar by an Exp, then truncate to return an unsigned integer.
503      */
504     function divScalarByExpTruncate(uint scalar, Exp memory divisor) pure internal returns (MathError, uint) {
505         (MathError err, Exp memory fraction) = divScalarByExp(scalar, divisor);
506         if (err != MathError.NO_ERROR) {
507             return (err, 0);
508         }
509 
510         return (MathError.NO_ERROR, truncate(fraction));
511     }
512 
513     /**
514      * @dev Multiplies two exponentials, returning a new exponential.
515      */
516     function mulExp(Exp memory a, Exp memory b) pure internal returns (MathError, Exp memory) {
517 
518         (MathError err0, uint doubleScaledProduct) = mulUInt(a.mantissa, b.mantissa);
519         if (err0 != MathError.NO_ERROR) {
520             return (err0, Exp({mantissa: 0}));
521         }
522 
523         // We add half the scale before dividing so that we get rounding instead of truncation.
524         //  See "Listing 6" and text above it at https://accu.org/index.php/journals/1717
525         // Without this change, a result like 6.6...e-19 will be truncated to 0 instead of being rounded to 1e-18.
526         (MathError err1, uint doubleScaledProductWithHalfScale) = addUInt(halfExpScale, doubleScaledProduct);
527         if (err1 != MathError.NO_ERROR) {
528             return (err1, Exp({mantissa: 0}));
529         }
530 
531         (MathError err2, uint product) = divUInt(doubleScaledProductWithHalfScale, expScale);
532         // The only error `div` can return is MathError.DIVISION_BY_ZERO but we control `expScale` and it is not zero.
533         assert(err2 == MathError.NO_ERROR);
534 
535         return (MathError.NO_ERROR, Exp({mantissa: product}));
536     }
537 
538     /**
539      * @dev Multiplies two exponentials given their mantissas, returning a new exponential.
540      */
541     function mulExp(uint a, uint b) pure internal returns (MathError, Exp memory) {
542         return mulExp(Exp({mantissa: a}), Exp({mantissa: b}));
543     }
544 
545     /**
546      * @dev Multiplies three exponentials, returning a new exponential.
547      */
548     function mulExp3(Exp memory a, Exp memory b, Exp memory c) pure internal returns (MathError, Exp memory) {
549         (MathError err, Exp memory ab) = mulExp(a, b);
550         if (err != MathError.NO_ERROR) {
551             return (err, ab);
552         }
553         return mulExp(ab, c);
554     }
555 
556     /**
557      * @dev Divides two exponentials, returning a new exponential.
558      *     (a/scale) / (b/scale) = (a/scale) * (scale/b) = a/b,
559      *  which we can scale as an Exp by calling getExp(a.mantissa, b.mantissa)
560      */
561     function divExp(Exp memory a, Exp memory b) pure internal returns (MathError, Exp memory) {
562         return getExp(a.mantissa, b.mantissa);
563     }
564 
565     /**
566      * @dev Truncates the given exp to a whole number value.
567      *      For example, truncate(Exp{mantissa: 15 * expScale}) = 15
568      */
569     function truncate(Exp memory exp) pure internal returns (uint) {
570         // Note: We are not using careful math here as we're performing a division that cannot fail
571         return exp.mantissa / expScale;
572     }
573 
574     /**
575      * @dev Checks if first Exp is less than second Exp.
576      */
577     function lessThanExp(Exp memory left, Exp memory right) pure internal returns (bool) {
578         return left.mantissa < right.mantissa; //TODO: Add some simple tests and this in another PR yo.
579     }
580 
581     /**
582      * @dev Checks if left Exp <= right Exp.
583      */
584     function lessThanOrEqualExp(Exp memory left, Exp memory right) pure internal returns (bool) {
585         return left.mantissa <= right.mantissa;
586     }
587 
588     /**
589      * @dev returns true if Exp is exactly zero
590      */
591     function isZeroExp(Exp memory value) pure internal returns (bool) {
592         return value.mantissa == 0;
593     }
594 }
595 
596 // File: contracts/EIP20Interface.sol
597 
598 pragma solidity ^0.5.8;
599 
600 /**
601  * @title ERC 20 Token Standard Interface
602  *  https://eips.ethereum.org/EIPS/eip-20
603  */
604 interface EIP20Interface {
605 
606     /**
607       * @notice Get the total number of tokens in circulation
608       * @return The supply of tokens
609       */
610     function totalSupply() external view returns (uint256);
611 
612     /**
613      * @notice Gets the balance of the specified address
614      * @param owner The address from which the balance will be retrieved
615      * @return The balance
616      */
617     function balanceOf(address owner) external view returns (uint256 balance);
618 
619     /**
620       * @notice Transfer `amount` tokens from `msg.sender` to `dst`
621       * @param dst The address of the destination account
622       * @param amount The number of tokens to transfer
623       * @return Whether or not the transfer succeeded
624       */
625     function transfer(address dst, uint256 amount) external returns (bool success);
626 
627     /**
628       * @notice Transfer `amount` tokens from `src` to `dst`
629       * @param src The address of the source account
630       * @param dst The address of the destination account
631       * @param amount The number of tokens to transfer
632       * @return Whether or not the transfer succeeded
633       */
634     function transferFrom(address src, address dst, uint256 amount) external returns (bool success);
635 
636     /**
637       * @notice Approve `spender` to transfer up to `amount` from `src`
638       * @dev This will overwrite the approval amount for `spender`
639       *  and is subject to issues noted [here](https://eips.ethereum.org/EIPS/eip-20#approve)
640       * @param spender The address of the account which may transfer tokens
641       * @param amount The number of tokens that are approved (-1 means infinite)
642       * @return Whether or not the approval succeeded
643       */
644     function approve(address spender, uint256 amount) external returns (bool success);
645 
646     /**
647       * @notice Get the current allowance from `owner` for `spender`
648       * @param owner The address of the account which owns the tokens to be spent
649       * @param spender The address of the account which may transfer tokens
650       * @return The number of tokens allowed to be spent (-1 means infinite)
651       */
652     function allowance(address owner, address spender) external view returns (uint256 remaining);
653 
654     event Transfer(address indexed from, address indexed to, uint256 amount);
655     event Approval(address indexed owner, address indexed spender, uint256 amount);
656 }
657 
658 // File: contracts/EIP20NonStandardInterface.sol
659 
660 pragma solidity ^0.5.8;
661 
662 /**
663  * @title EIP20NonStandardInterface
664  * @dev Version of ERC20 with no return values for `transfer` and `transferFrom`
665  *  See https://medium.com/coinmonks/missing-return-value-bug-at-least-130-tokens-affected-d67bf08521ca
666  */
667 interface EIP20NonStandardInterface {
668 
669     /**
670      * @notice Get the total number of tokens in circulation
671      * @return The supply of tokens
672      */
673     function totalSupply() external view returns (uint256);
674 
675     /**
676      * @notice Gets the balance of the specified address
677      * @param owner The address from which the balance will be retrieved
678      * @return The balance
679      */
680     function balanceOf(address owner) external view returns (uint256 balance);
681 
682     ///
683     /// !!!!!!!!!!!!!!
684     /// !!! NOTICE !!! `transfer` does not return a value, in violation of the ERC-20 specification
685     /// !!!!!!!!!!!!!!
686     ///
687 
688     /**
689       * @notice Transfer `amount` tokens from `msg.sender` to `dst`
690       * @param dst The address of the destination account
691       * @param amount The number of tokens to transfer
692       */
693     function transfer(address dst, uint256 amount) external;
694 
695     ///
696     /// !!!!!!!!!!!!!!
697     /// !!! NOTICE !!! `transferFrom` does not return a value, in violation of the ERC-20 specification
698     /// !!!!!!!!!!!!!!
699     ///
700 
701     /**
702       * @notice Transfer `amount` tokens from `src` to `dst`
703       * @param src The address of the source account
704       * @param dst The address of the destination account
705       * @param amount The number of tokens to transfer
706       */
707     function transferFrom(address src, address dst, uint256 amount) external;
708 
709     /**
710       * @notice Approve `spender` to transfer up to `amount` from `src`
711       * @dev This will overwrite the approval amount for `spender`
712       *  and is subject to issues noted [here](https://eips.ethereum.org/EIPS/eip-20#approve)
713       * @param spender The address of the account which may transfer tokens
714       * @param amount The number of tokens that are approved
715       * @return Whether or not the approval succeeded
716       */
717     function approve(address spender, uint256 amount) external returns (bool success);
718 
719     /**
720       * @notice Get the current allowance from `owner` for `spender`
721       * @param owner The address of the account which owns the tokens to be spent
722       * @param spender The address of the account which may transfer tokens
723       * @return The number of tokens allowed to be spent
724       */
725     function allowance(address owner, address spender) external view returns (uint256 remaining);
726 
727     event Transfer(address indexed from, address indexed to, uint256 amount);
728     event Approval(address indexed owner, address indexed spender, uint256 amount);
729 }
730 
731 // File: contracts/ReentrancyGuard.sol
732 
733 pragma solidity ^0.5.8;
734 
735 /**
736  * @title Helps contracts guard against reentrancy attacks.
737  * @author Remco Bloemen <remco@2π.com>, Eenae <alexey@mixbytes.io>
738  * @dev If you mark a function `nonReentrant`, you should also
739  * mark it `external`.
740  */
741 contract ReentrancyGuard {
742     /// @dev counter to allow mutex lock with only one SSTORE operation
743     uint256 private _guardCounter;
744 
745     constructor () internal {
746         // The counter starts at one to prevent changing it from zero to a non-zero
747         // value, which is a more expensive operation.
748         _guardCounter = 1;
749     }
750 
751     /**
752      * @dev Prevents a contract from calling itself, directly or indirectly.
753      * Calling a `nonReentrant` function from another `nonReentrant`
754      * function is not supported. It is possible to prevent this from happening
755      * by making the `nonReentrant` function external, and make it call a
756      * `private` function that does the actual work.
757      */
758     modifier nonReentrant() {
759         _guardCounter += 1;
760         uint256 localCounter = _guardCounter;
761         _;
762         require(localCounter == _guardCounter, "re-entered");
763     }
764 }
765 
766 // File: contracts/InterestRateModel.sol
767 
768 pragma solidity ^0.5.8;
769 
770 /**
771   * @title The Compound InterestRateModel Interface
772   * @author Compound
773   * @notice Any interest rate model should derive from this contract.
774   * @dev These functions are specifically not marked `pure` as implementations of this
775   *      contract may read from storage variables.
776   */
777 interface InterestRateModel {
778     /**
779       * @notice Gets the current borrow interest rate based on the given asset, total cash, total borrows
780       *         and total reserves.
781       * @dev The return value should be scaled by 1e18, thus a return value of
782       *      `(true, 1000000000000)` implies an interest rate of 0.000001 or 0.0001% *per block*.
783       * @param cash The total cash of the underlying asset in the CToken
784       * @param borrows The total borrows of the underlying asset in the CToken
785       * @param reserves The total reserves of the underlying asset in the CToken
786       * @return Success or failure and the borrow interest rate per block scaled by 10e18
787       */
788     function getBorrowRate(uint cash, uint borrows, uint reserves) external view returns (uint, uint);
789 
790     /**
791       * @notice Marker function used for light validation when updating the interest rate model of a market
792       * @dev Marker function used for light validation when updating the interest rate model of a market. Implementations should simply return true.
793       * @return Success or failure
794       */
795     function isInterestRateModel() external view returns (bool);
796 }
797 
798 // File: contracts/CToken.sol
799 
800 pragma solidity ^0.5.8;
801 
802 
803 
804 
805 
806 
807 
808 
809 /**
810  * @title Compound's CToken Contract
811  * @notice Abstract base for CTokens
812  * @author Compound
813  */
814 contract CToken is EIP20Interface, Exponential, TokenErrorReporter, ReentrancyGuard {
815     /**
816      * @notice Indicator that this is a CToken contract (for inspection)
817      */
818     bool public constant isCToken = true;
819 
820     /**
821      * @notice EIP-20 token name for this token
822      */
823     string public name;
824 
825     /**
826      * @notice EIP-20 token symbol for this token
827      */
828     string public symbol;
829 
830     /**
831      * @notice EIP-20 token decimals for this token
832      */
833     uint public decimals;
834 
835     /**
836      * @notice Maximum borrow rate that can ever be applied (.0005% / block)
837      */
838     uint constant borrowRateMaxMantissa = 5e14;
839 
840     /**
841      * @notice Maximum fraction of interest that can be set aside for reserves
842      */
843     uint constant reserveFactorMaxMantissa = 1e18;
844 
845     /**
846      * @notice Administrator for this contract
847      */
848     address payable public admin;
849 
850     /**
851      * @notice Pending administrator for this contract
852      */
853     address payable public pendingAdmin;
854 
855     /**
856      * @notice Contract which oversees inter-cToken operations
857      */
858     ComptrollerInterface public comptroller;
859 
860     /**
861      * @notice Model which tells what the current interest rate should be
862      */
863     InterestRateModel public interestRateModel;
864 
865     /**
866      * @notice Initial exchange rate used when minting the first CTokens (used when totalSupply = 0)
867      */
868     uint public initialExchangeRateMantissa;
869 
870     /**
871      * @notice Fraction of interest currently set aside for reserves
872      */
873     uint public reserveFactorMantissa;
874 
875     /**
876      * @notice Block number that interest was last accrued at
877      */
878     uint public accrualBlockNumber;
879 
880     /**
881      * @notice Accumulator of total earned interest since the opening of the market
882      */
883     uint public borrowIndex;
884 
885     /**
886      * @notice Total amount of outstanding borrows of the underlying in this market
887      */
888     uint public totalBorrows;
889 
890     /**
891      * @notice Total amount of reserves of the underlying held in this market
892      */
893     uint public totalReserves;
894 
895     /**
896      * @notice Total number of tokens in circulation
897      */
898     uint256 public totalSupply;
899 
900     /**
901      * @notice Official record of token balances for each account
902      */
903     mapping (address => uint256) accountTokens;
904 
905     /**
906      * @notice Approved token transfer amounts on behalf of others
907      */
908     mapping (address => mapping (address => uint256)) transferAllowances;
909 
910     /**
911      * @notice Container for borrow balance information
912      * @member principal Total balance (with accrued interest), after applying the most recent balance-changing action
913      * @member interestIndex Global borrowIndex as of the most recent balance-changing action
914      */
915     struct BorrowSnapshot {
916         uint principal;
917         uint interestIndex;
918     }
919 
920     /**
921      * @notice Mapping of account addresses to outstanding borrow balances
922      */
923     mapping(address => BorrowSnapshot) accountBorrows;
924 
925 
926     /*** Market Events ***/
927 
928     /**
929      * @notice Event emitted when interest is accrued
930      */
931     event AccrueInterest(uint interestAccumulated, uint borrowIndex, uint totalBorrows);
932 
933     /**
934      * @notice Event emitted when tokens are minted
935      */
936     event Mint(address minter, uint mintAmount, uint mintTokens);
937 
938     /**
939      * @notice Event emitted when tokens are redeemed
940      */
941     event Redeem(address redeemer, uint redeemAmount, uint redeemTokens);
942 
943     /**
944      * @notice Event emitted when underlying is borrowed
945      */
946     event Borrow(address borrower, uint borrowAmount, uint accountBorrows, uint totalBorrows);
947 
948     /**
949      * @notice Event emitted when a borrow is repaid
950      */
951     event RepayBorrow(address payer, address borrower, uint repayAmount, uint accountBorrows, uint totalBorrows);
952 
953     /**
954      * @notice Event emitted when a borrow is liquidated
955      */
956     event LiquidateBorrow(address liquidator, address borrower, uint repayAmount, address cTokenCollateral, uint seizeTokens);
957 
958 
959     /*** Admin Events ***/
960 
961     /**
962      * @notice Event emitted when pendingAdmin is changed
963      */
964     event NewPendingAdmin(address oldPendingAdmin, address newPendingAdmin);
965 
966     /**
967      * @notice Event emitted when pendingAdmin is accepted, which means admin is updated
968      */
969     event NewAdmin(address oldAdmin, address newAdmin);
970 
971     /**
972      * @notice Event emitted when comptroller is changed
973      */
974     event NewComptroller(ComptrollerInterface oldComptroller, ComptrollerInterface newComptroller);
975 
976     /**
977      * @notice Event emitted when interestRateModel is changed
978      */
979     event NewMarketInterestRateModel(InterestRateModel oldInterestRateModel, InterestRateModel newInterestRateModel);
980 
981     /**
982      * @notice Event emitted when the reserve factor is changed
983      */
984     event NewReserveFactor(uint oldReserveFactorMantissa, uint newReserveFactorMantissa);
985 
986     /**
987      * @notice Event emitted when the reserves are reduced
988      */
989     event ReservesReduced(address admin, uint reduceAmount, uint newTotalReserves);
990 
991 
992     /**
993      * @notice Construct a new money market
994      * @param comptroller_ The address of the Comptroller
995      * @param interestRateModel_ The address of the interest rate model
996      * @param initialExchangeRateMantissa_ The initial exchange rate, scaled by 1e18
997      * @param name_ EIP-20 name of this token
998      * @param symbol_ EIP-20 symbol of this token
999      * @param decimals_ EIP-20 decimal precision of this token
1000      */
1001     constructor(ComptrollerInterface comptroller_,
1002                 InterestRateModel interestRateModel_,
1003                 uint initialExchangeRateMantissa_,
1004                 string memory name_,
1005                 string memory symbol_,
1006                 uint decimals_) internal {
1007         // Set admin to msg.sender
1008         admin = msg.sender;
1009 
1010         // Set initial exchange rate
1011         initialExchangeRateMantissa = initialExchangeRateMantissa_;
1012         require(initialExchangeRateMantissa > 0, "Initial exchange rate must be greater than zero.");
1013 
1014         // Set the comptroller
1015         uint err = _setComptroller(comptroller_);
1016         require(err == uint(Error.NO_ERROR), "Setting comptroller failed");
1017 
1018         // Initialize block number and borrow index (block number mocks depend on comptroller being set)
1019         accrualBlockNumber = getBlockNumber();
1020         borrowIndex = mantissaOne;
1021 
1022         // Set the interest rate model (depends on block number / borrow index)
1023         err = _setInterestRateModelFresh(interestRateModel_);
1024         require(err == uint(Error.NO_ERROR), "Setting interest rate model failed");
1025 
1026         name = name_;
1027         symbol = symbol_;
1028         decimals = decimals_;
1029     }
1030 
1031     /**
1032      * @notice Transfer `tokens` tokens from `src` to `dst` by `spender`
1033      * @dev Called by both `transfer` and `transferFrom` internally
1034      * @param spender The address of the account performing the transfer
1035      * @param src The address of the source account
1036      * @param dst The address of the destination account
1037      * @param tokens The number of tokens to transfer
1038      * @return Whether or not the transfer succeeded
1039      */
1040     function transferTokens(address spender, address src, address dst, uint tokens) internal returns (uint) {
1041         /* Fail if transfer not allowed */
1042         uint allowed = comptroller.transferAllowed(address(this), src, dst, tokens);
1043         if (allowed != 0) {
1044             return failOpaque(Error.COMPTROLLER_REJECTION, FailureInfo.TRANSFER_COMPTROLLER_REJECTION, allowed);
1045         }
1046 
1047         /* Do not allow self-transfers */
1048         if (src == dst) {
1049             return fail(Error.BAD_INPUT, FailureInfo.TRANSFER_NOT_ALLOWED);
1050         }
1051 
1052         /* Get the allowance, infinite for the account owner */
1053         uint startingAllowance = 0;
1054         if (spender == src) {
1055             startingAllowance = uint(-1);
1056         } else {
1057             startingAllowance = transferAllowances[src][spender];
1058         }
1059 
1060         /* Do the calculations, checking for {under,over}flow */
1061         MathError mathErr;
1062         uint allowanceNew;
1063         uint srcTokensNew;
1064         uint dstTokensNew;
1065 
1066         (mathErr, allowanceNew) = subUInt(startingAllowance, tokens);
1067         if (mathErr != MathError.NO_ERROR) {
1068             return fail(Error.MATH_ERROR, FailureInfo.TRANSFER_NOT_ALLOWED);
1069         }
1070 
1071         (mathErr, srcTokensNew) = subUInt(accountTokens[src], tokens);
1072         if (mathErr != MathError.NO_ERROR) {
1073             return fail(Error.MATH_ERROR, FailureInfo.TRANSFER_NOT_ENOUGH);
1074         }
1075 
1076         (mathErr, dstTokensNew) = addUInt(accountTokens[dst], tokens);
1077         if (mathErr != MathError.NO_ERROR) {
1078             return fail(Error.MATH_ERROR, FailureInfo.TRANSFER_TOO_MUCH);
1079         }
1080 
1081         /////////////////////////
1082         // EFFECTS & INTERACTIONS
1083         // (No safe failures beyond this point)
1084 
1085         accountTokens[src] = srcTokensNew;
1086         accountTokens[dst] = dstTokensNew;
1087 
1088         /* Eat some of the allowance (if necessary) */
1089         if (startingAllowance != uint(-1)) {
1090             transferAllowances[src][spender] = allowanceNew;
1091         }
1092 
1093         /* We emit a Transfer event */
1094         emit Transfer(src, dst, tokens);
1095 
1096         /* We call the defense hook (which checks for under-collateralization) */
1097         comptroller.transferVerify(address(this), src, dst, tokens);
1098 
1099         return uint(Error.NO_ERROR);
1100     }
1101 
1102     /**
1103      * @notice Transfer `amount` tokens from `msg.sender` to `dst`
1104      * @param dst The address of the destination account
1105      * @param amount The number of tokens to transfer
1106      * @return Whether or not the transfer succeeded
1107      */
1108     function transfer(address dst, uint256 amount) external nonReentrant returns (bool) {
1109         return transferTokens(msg.sender, msg.sender, dst, amount) == uint(Error.NO_ERROR);
1110     }
1111 
1112     /**
1113      * @notice Transfer `amount` tokens from `src` to `dst`
1114      * @param src The address of the source account
1115      * @param dst The address of the destination account
1116      * @param amount The number of tokens to transfer
1117      * @return Whether or not the transfer succeeded
1118      */
1119     function transferFrom(address src, address dst, uint256 amount) external nonReentrant returns (bool) {
1120         return transferTokens(msg.sender, src, dst, amount) == uint(Error.NO_ERROR);
1121     }
1122 
1123     /**
1124      * @notice Approve `spender` to transfer up to `amount` from `src`
1125      * @dev This will overwrite the approval amount for `spender`
1126      *  and is subject to issues noted [here](https://eips.ethereum.org/EIPS/eip-20#approve)
1127      * @param spender The address of the account which may transfer tokens
1128      * @param amount The number of tokens that are approved (-1 means infinite)
1129      * @return Whether or not the approval succeeded
1130      */
1131     function approve(address spender, uint256 amount) external returns (bool) {
1132         address src = msg.sender;
1133         transferAllowances[src][spender] = amount;
1134         emit Approval(src, spender, amount);
1135         return true;
1136     }
1137 
1138     /**
1139      * @notice Get the current allowance from `owner` for `spender`
1140      * @param owner The address of the account which owns the tokens to be spent
1141      * @param spender The address of the account which may transfer tokens
1142      * @return The number of tokens allowed to be spent (-1 means infinite)
1143      */
1144     function allowance(address owner, address spender) external view returns (uint256) {
1145         return transferAllowances[owner][spender];
1146     }
1147 
1148     /**
1149      * @notice Get the token balance of the `owner`
1150      * @param owner The address of the account to query
1151      * @return The number of tokens owned by `owner`
1152      */
1153     function balanceOf(address owner) external view returns (uint256) {
1154         return accountTokens[owner];
1155     }
1156 
1157     /**
1158      * @notice Get the underlying balance of the `owner`
1159      * @dev This also accrues interest in a transaction
1160      * @param owner The address of the account to query
1161      * @return The amount of underlying owned by `owner`
1162      */
1163     function balanceOfUnderlying(address owner) external returns (uint) {
1164         Exp memory exchangeRate = Exp({mantissa: exchangeRateCurrent()});
1165         (MathError mErr, uint balance) = mulScalarTruncate(exchangeRate, accountTokens[owner]);
1166         require(mErr == MathError.NO_ERROR);
1167         return balance;
1168     }
1169 
1170     /**
1171      * @notice Get a snapshot of the account's balances, and the cached exchange rate
1172      * @dev This is used by comptroller to more efficiently perform liquidity checks.
1173      * @param account Address of the account to snapshot
1174      * @return (possible error, token balance, borrow balance, exchange rate mantissa)
1175      */
1176     function getAccountSnapshot(address account) external view returns (uint, uint, uint, uint) {
1177         uint cTokenBalance = accountTokens[account];
1178         uint borrowBalance;
1179         uint exchangeRateMantissa;
1180 
1181         MathError mErr;
1182 
1183         (mErr, borrowBalance) = borrowBalanceStoredInternal(account);
1184         if (mErr != MathError.NO_ERROR) {
1185             return (uint(Error.MATH_ERROR), 0, 0, 0);
1186         }
1187 
1188         (mErr, exchangeRateMantissa) = exchangeRateStoredInternal();
1189         if (mErr != MathError.NO_ERROR) {
1190             return (uint(Error.MATH_ERROR), 0, 0, 0);
1191         }
1192 
1193         return (uint(Error.NO_ERROR), cTokenBalance, borrowBalance, exchangeRateMantissa);
1194     }
1195 
1196     /**
1197      * @dev Function to simply retrieve block number
1198      *  This exists mainly for inheriting test contracts to stub this result.
1199      */
1200     function getBlockNumber() internal view returns (uint) {
1201         return block.number;
1202     }
1203 
1204     /**
1205      * @notice Returns the current per-block borrow interest rate for this cToken
1206      * @return The borrow interest rate per block, scaled by 1e18
1207      */
1208     function borrowRatePerBlock() external view returns (uint) {
1209         (uint opaqueErr, uint borrowRateMantissa) = interestRateModel.getBorrowRate(getCashPrior(), totalBorrows, totalReserves);
1210         require(opaqueErr == 0, "borrowRatePerBlock: interestRateModel.borrowRate failed"); // semi-opaque
1211         return borrowRateMantissa;
1212     }
1213 
1214     /**
1215      * @notice Returns the current per-block supply interest rate for this cToken
1216      * @return The supply interest rate per block, scaled by 1e18
1217      */
1218     function supplyRatePerBlock() external view returns (uint) {
1219         /* We calculate the supply rate:
1220          *  underlying = totalSupply × exchangeRate
1221          *  borrowsPer = totalBorrows ÷ underlying
1222          *  supplyRate = borrowRate × (1-reserveFactor) × borrowsPer
1223          */
1224         uint exchangeRateMantissa = exchangeRateStored();
1225 
1226         (uint e0, uint borrowRateMantissa) = interestRateModel.getBorrowRate(getCashPrior(), totalBorrows, totalReserves);
1227         require(e0 == 0, "supplyRatePerBlock: calculating borrowRate failed"); // semi-opaque
1228 
1229         (MathError e1, Exp memory underlying) = mulScalar(Exp({mantissa: exchangeRateMantissa}), totalSupply);
1230         require(e1 == MathError.NO_ERROR, "supplyRatePerBlock: calculating underlying failed");
1231 
1232         (MathError e2, Exp memory borrowsPer) = divScalarByExp(totalBorrows, underlying);
1233         require(e2 == MathError.NO_ERROR, "supplyRatePerBlock: calculating borrowsPer failed");
1234 
1235         (MathError e3, Exp memory oneMinusReserveFactor) = subExp(Exp({mantissa: mantissaOne}), Exp({mantissa: reserveFactorMantissa}));
1236         require(e3 == MathError.NO_ERROR, "supplyRatePerBlock: calculating oneMinusReserveFactor failed");
1237 
1238         (MathError e4, Exp memory supplyRate) = mulExp3(Exp({mantissa: borrowRateMantissa}), oneMinusReserveFactor, borrowsPer);
1239         require(e4 == MathError.NO_ERROR, "supplyRatePerBlock: calculating supplyRate failed");
1240 
1241         return supplyRate.mantissa;
1242     }
1243 
1244     /**
1245      * @notice Returns the current total borrows plus accrued interest
1246      * @return The total borrows with interest
1247      */
1248     function totalBorrowsCurrent() external nonReentrant returns (uint) {
1249         require(accrueInterest() == uint(Error.NO_ERROR), "accrue interest failed");
1250         return totalBorrows;
1251     }
1252 
1253     /**
1254      * @notice Accrue interest to updated borrowIndex and then calculate account's borrow balance using the updated borrowIndex
1255      * @param account The address whose balance should be calculated after updating borrowIndex
1256      * @return The calculated balance
1257      */
1258     function borrowBalanceCurrent(address account) external nonReentrant returns (uint) {
1259         require(accrueInterest() == uint(Error.NO_ERROR), "accrue interest failed");
1260         return borrowBalanceStored(account);
1261     }
1262 
1263     /**
1264      * @notice Return the borrow balance of account based on stored data
1265      * @param account The address whose balance should be calculated
1266      * @return The calculated balance
1267      */
1268     function borrowBalanceStored(address account) public view returns (uint) {
1269         (MathError err, uint result) = borrowBalanceStoredInternal(account);
1270         require(err == MathError.NO_ERROR, "borrowBalanceStored: borrowBalanceStoredInternal failed");
1271         return result;
1272     }
1273 
1274     /**
1275      * @notice Return the borrow balance of account based on stored data
1276      * @param account The address whose balance should be calculated
1277      * @return (error code, the calculated balance or 0 if error code is non-zero)
1278      */
1279     function borrowBalanceStoredInternal(address account) internal view returns (MathError, uint) {
1280         /* Note: we do not assert that the market is up to date */
1281         MathError mathErr;
1282         uint principalTimesIndex;
1283         uint result;
1284 
1285         /* Get borrowBalance and borrowIndex */
1286         BorrowSnapshot storage borrowSnapshot = accountBorrows[account];
1287 
1288         /* If borrowBalance = 0 then borrowIndex is likely also 0.
1289          * Rather than failing the calculation with a division by 0, we immediately return 0 in this case.
1290          */
1291         if (borrowSnapshot.principal == 0) {
1292             return (MathError.NO_ERROR, 0);
1293         }
1294 
1295         /* Calculate new borrow balance using the interest index:
1296          *  recentBorrowBalance = borrower.borrowBalance * market.borrowIndex / borrower.borrowIndex
1297          */
1298         (mathErr, principalTimesIndex) = mulUInt(borrowSnapshot.principal, borrowIndex);
1299         if (mathErr != MathError.NO_ERROR) {
1300             return (mathErr, 0);
1301         }
1302 
1303         (mathErr, result) = divUInt(principalTimesIndex, borrowSnapshot.interestIndex);
1304         if (mathErr != MathError.NO_ERROR) {
1305             return (mathErr, 0);
1306         }
1307 
1308         return (MathError.NO_ERROR, result);
1309     }
1310 
1311     /**
1312      * @notice Accrue interest then return the up-to-date exchange rate
1313      * @return Calculated exchange rate scaled by 1e18
1314      */
1315     function exchangeRateCurrent() public nonReentrant returns (uint) {
1316         require(accrueInterest() == uint(Error.NO_ERROR), "accrue interest failed");
1317         return exchangeRateStored();
1318     }
1319 
1320     /**
1321      * @notice Calculates the exchange rate from the underlying to the CToken
1322      * @dev This function does not accrue interest before calculating the exchange rate
1323      * @return Calculated exchange rate scaled by 1e18
1324      */
1325     function exchangeRateStored() public view returns (uint) {
1326         (MathError err, uint result) = exchangeRateStoredInternal();
1327         require(err == MathError.NO_ERROR, "exchangeRateStored: exchangeRateStoredInternal failed");
1328         return result;
1329     }
1330 
1331     /**
1332      * @notice Calculates the exchange rate from the underlying to the CToken
1333      * @dev This function does not accrue interest before calculating the exchange rate
1334      * @return (error code, calculated exchange rate scaled by 1e18)
1335      */
1336     function exchangeRateStoredInternal() internal view returns (MathError, uint) {
1337         if (totalSupply == 0) {
1338             /*
1339              * If there are no tokens minted:
1340              *  exchangeRate = initialExchangeRate
1341              */
1342             return (MathError.NO_ERROR, initialExchangeRateMantissa);
1343         } else {
1344             /*
1345              * Otherwise:
1346              *  exchangeRate = (totalCash + totalBorrows - totalReserves) / totalSupply
1347              */
1348             uint totalCash = getCashPrior();
1349             uint cashPlusBorrowsMinusReserves;
1350             Exp memory exchangeRate;
1351             MathError mathErr;
1352 
1353             (mathErr, cashPlusBorrowsMinusReserves) = addThenSubUInt(totalCash, totalBorrows, totalReserves);
1354             if (mathErr != MathError.NO_ERROR) {
1355                 return (mathErr, 0);
1356             }
1357 
1358             (mathErr, exchangeRate) = getExp(cashPlusBorrowsMinusReserves, totalSupply);
1359             if (mathErr != MathError.NO_ERROR) {
1360                 return (mathErr, 0);
1361             }
1362 
1363             return (MathError.NO_ERROR, exchangeRate.mantissa);
1364         }
1365     }
1366 
1367     /**
1368      * @notice Get cash balance of this cToken in the underlying asset
1369      * @return The quantity of underlying asset owned by this contract
1370      */
1371     function getCash() external view returns (uint) {
1372         return getCashPrior();
1373     }
1374 
1375     struct AccrueInterestLocalVars {
1376         MathError mathErr;
1377         uint opaqueErr;
1378         uint borrowRateMantissa;
1379         uint currentBlockNumber;
1380         uint blockDelta;
1381 
1382         Exp simpleInterestFactor;
1383 
1384         uint interestAccumulated;
1385         uint totalBorrowsNew;
1386         uint totalReservesNew;
1387         uint borrowIndexNew;
1388     }
1389 
1390     /**
1391       * @notice Applies accrued interest to total borrows and reserves.
1392       * @dev This calculates interest accrued from the last checkpointed block
1393       *      up to the current block and writes new checkpoint to storage.
1394       */
1395     function accrueInterest() public returns (uint) {
1396         AccrueInterestLocalVars memory vars;
1397 
1398         /* Calculate the current borrow interest rate */
1399         (vars.opaqueErr, vars.borrowRateMantissa) = interestRateModel.getBorrowRate(getCashPrior(), totalBorrows, totalReserves);
1400         require(vars.borrowRateMantissa <= borrowRateMaxMantissa, "borrow rate is absurdly high");
1401         if (vars.opaqueErr != 0) {
1402             return failOpaque(Error.INTEREST_RATE_MODEL_ERROR, FailureInfo.ACCRUE_INTEREST_BORROW_RATE_CALCULATION_FAILED, vars.opaqueErr);
1403         }
1404 
1405         /* Remember the initial block number */
1406         vars.currentBlockNumber = getBlockNumber();
1407 
1408         /* Calculate the number of blocks elapsed since the last accrual */
1409         (vars.mathErr, vars.blockDelta) = subUInt(vars.currentBlockNumber, accrualBlockNumber);
1410         assert(vars.mathErr == MathError.NO_ERROR); // Block delta should always succeed and if it doesn't, blow up.
1411 
1412         /*
1413          * Calculate the interest accumulated into borrows and reserves and the new index:
1414          *  simpleInterestFactor = borrowRate * blockDelta
1415          *  interestAccumulated = simpleInterestFactor * totalBorrows
1416          *  totalBorrowsNew = interestAccumulated + totalBorrows
1417          *  totalReservesNew = interestAccumulated * reserveFactor + totalReserves
1418          *  borrowIndexNew = simpleInterestFactor * borrowIndex + borrowIndex
1419          */
1420         (vars.mathErr, vars.simpleInterestFactor) = mulScalar(Exp({mantissa: vars.borrowRateMantissa}), vars.blockDelta);
1421         if (vars.mathErr != MathError.NO_ERROR) {
1422             return failOpaque(Error.MATH_ERROR, FailureInfo.ACCRUE_INTEREST_SIMPLE_INTEREST_FACTOR_CALCULATION_FAILED, uint(vars.mathErr));
1423         }
1424 
1425         (vars.mathErr, vars.interestAccumulated) = mulScalarTruncate(vars.simpleInterestFactor, totalBorrows);
1426         if (vars.mathErr != MathError.NO_ERROR) {
1427             return failOpaque(Error.MATH_ERROR, FailureInfo.ACCRUE_INTEREST_ACCUMULATED_INTEREST_CALCULATION_FAILED, uint(vars.mathErr));
1428         }
1429 
1430         (vars.mathErr, vars.totalBorrowsNew) = addUInt(vars.interestAccumulated, totalBorrows);
1431         if (vars.mathErr != MathError.NO_ERROR) {
1432             return failOpaque(Error.MATH_ERROR, FailureInfo.ACCRUE_INTEREST_NEW_TOTAL_BORROWS_CALCULATION_FAILED, uint(vars.mathErr));
1433         }
1434 
1435         (vars.mathErr, vars.totalReservesNew) = mulScalarTruncateAddUInt(Exp({mantissa: reserveFactorMantissa}), vars.interestAccumulated, totalReserves);
1436         if (vars.mathErr != MathError.NO_ERROR) {
1437             return failOpaque(Error.MATH_ERROR, FailureInfo.ACCRUE_INTEREST_NEW_TOTAL_RESERVES_CALCULATION_FAILED, uint(vars.mathErr));
1438         }
1439 
1440         (vars.mathErr, vars.borrowIndexNew) = mulScalarTruncateAddUInt(vars.simpleInterestFactor, borrowIndex, borrowIndex);
1441         if (vars.mathErr != MathError.NO_ERROR) {
1442             return failOpaque(Error.MATH_ERROR, FailureInfo.ACCRUE_INTEREST_NEW_BORROW_INDEX_CALCULATION_FAILED, uint(vars.mathErr));
1443         }
1444 
1445         /////////////////////////
1446         // EFFECTS & INTERACTIONS
1447         // (No safe failures beyond this point)
1448 
1449         /* We write the previously calculated values into storage */
1450         accrualBlockNumber = vars.currentBlockNumber;
1451         borrowIndex = vars.borrowIndexNew;
1452         totalBorrows = vars.totalBorrowsNew;
1453         totalReserves = vars.totalReservesNew;
1454 
1455         /* We emit an AccrueInterest event */
1456         emit AccrueInterest(vars.interestAccumulated, vars.borrowIndexNew, totalBorrows);
1457 
1458         return uint(Error.NO_ERROR);
1459     }
1460 
1461     /**
1462      * @notice Sender supplies assets into the market and receives cTokens in exchange
1463      * @dev Accrues interest whether or not the operation succeeds, unless reverted
1464      * @param mintAmount The amount of the underlying asset to supply
1465      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
1466      */
1467     function mintInternal(uint mintAmount) internal nonReentrant returns (uint) {
1468         uint error = accrueInterest();
1469         if (error != uint(Error.NO_ERROR)) {
1470             // accrueInterest emits logs on errors, but we still want to log the fact that an attempted borrow failed
1471             return fail(Error(error), FailureInfo.MINT_ACCRUE_INTEREST_FAILED);
1472         }
1473         // mintFresh emits the actual Mint event if successful and logs on errors, so we don't need to
1474         return mintFresh(msg.sender, mintAmount);
1475     }
1476 
1477     struct MintLocalVars {
1478         Error err;
1479         MathError mathErr;
1480         uint exchangeRateMantissa;
1481         uint mintTokens;
1482         uint totalSupplyNew;
1483         uint accountTokensNew;
1484     }
1485 
1486     /**
1487      * @notice User supplies assets into the market and receives cTokens in exchange
1488      * @dev Assumes interest has already been accrued up to the current block
1489      * @param minter The address of the account which is supplying the assets
1490      * @param mintAmount The amount of the underlying asset to supply
1491      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
1492      */
1493     function mintFresh(address minter, uint mintAmount) internal returns (uint) {
1494         /* Fail if mint not allowed */
1495         uint allowed = comptroller.mintAllowed(address(this), minter, mintAmount);
1496         if (allowed != 0) {
1497             return failOpaque(Error.COMPTROLLER_REJECTION, FailureInfo.MINT_COMPTROLLER_REJECTION, allowed);
1498         }
1499 
1500         /* Verify market's block number equals current block number */
1501         if (accrualBlockNumber != getBlockNumber()) {
1502             return fail(Error.MARKET_NOT_FRESH, FailureInfo.MINT_FRESHNESS_CHECK);
1503         }
1504 
1505         MintLocalVars memory vars;
1506 
1507         /* Fail if checkTransferIn fails */
1508         vars.err = checkTransferIn(minter, mintAmount);
1509         if (vars.err != Error.NO_ERROR) {
1510             return fail(vars.err, FailureInfo.MINT_TRANSFER_IN_NOT_POSSIBLE);
1511         }
1512 
1513         /*
1514          * We get the current exchange rate and calculate the number of cTokens to be minted:
1515          *  mintTokens = mintAmount / exchangeRate
1516          */
1517         (vars.mathErr, vars.exchangeRateMantissa) = exchangeRateStoredInternal();
1518         if (vars.mathErr != MathError.NO_ERROR) {
1519             return failOpaque(Error.MATH_ERROR, FailureInfo.MINT_EXCHANGE_RATE_READ_FAILED, uint(vars.mathErr));
1520         }
1521 
1522         (vars.mathErr, vars.mintTokens) = divScalarByExpTruncate(mintAmount, Exp({mantissa: vars.exchangeRateMantissa}));
1523         if (vars.mathErr != MathError.NO_ERROR) {
1524             return failOpaque(Error.MATH_ERROR, FailureInfo.MINT_EXCHANGE_CALCULATION_FAILED, uint(vars.mathErr));
1525         }
1526 
1527         /*
1528          * We calculate the new total supply of cTokens and minter token balance, checking for overflow:
1529          *  totalSupplyNew = totalSupply + mintTokens
1530          *  accountTokensNew = accountTokens[minter] + mintTokens
1531          */
1532         (vars.mathErr, vars.totalSupplyNew) = addUInt(totalSupply, vars.mintTokens);
1533         if (vars.mathErr != MathError.NO_ERROR) {
1534             return failOpaque(Error.MATH_ERROR, FailureInfo.MINT_NEW_TOTAL_SUPPLY_CALCULATION_FAILED, uint(vars.mathErr));
1535         }
1536 
1537         (vars.mathErr, vars.accountTokensNew) = addUInt(accountTokens[minter], vars.mintTokens);
1538         if (vars.mathErr != MathError.NO_ERROR) {
1539             return failOpaque(Error.MATH_ERROR, FailureInfo.MINT_NEW_ACCOUNT_BALANCE_CALCULATION_FAILED, uint(vars.mathErr));
1540         }
1541 
1542         /////////////////////////
1543         // EFFECTS & INTERACTIONS
1544         // (No safe failures beyond this point)
1545 
1546         /*
1547          * We call doTransferIn for the minter and the mintAmount
1548          *  Note: The cToken must handle variations between ERC-20 and ETH underlying.
1549          *  On success, the cToken holds an additional mintAmount of cash.
1550          *  If doTransferIn fails despite the fact we checked pre-conditions,
1551          *   we revert because we can't be sure if side effects occurred.
1552          */
1553         vars.err = doTransferIn(minter, mintAmount);
1554         if (vars.err != Error.NO_ERROR) {
1555             return fail(vars.err, FailureInfo.MINT_TRANSFER_IN_FAILED);
1556         }
1557 
1558         /* We write previously calculated values into storage */
1559         totalSupply = vars.totalSupplyNew;
1560         accountTokens[minter] = vars.accountTokensNew;
1561 
1562         /* We emit a Mint event, and a Transfer event */
1563         emit Mint(minter, mintAmount, vars.mintTokens);
1564         emit Transfer(address(this), minter, vars.mintTokens);
1565 
1566         /* We call the defense hook */
1567         comptroller.mintVerify(address(this), minter, mintAmount, vars.mintTokens);
1568 
1569         return uint(Error.NO_ERROR);
1570     }
1571 
1572     /**
1573      * @notice Sender redeems cTokens in exchange for the underlying asset
1574      * @dev Accrues interest whether or not the operation succeeds, unless reverted
1575      * @param redeemTokens The number of cTokens to redeem into underlying
1576      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
1577      */
1578     function redeemInternal(uint redeemTokens) internal nonReentrant returns (uint) {
1579         uint error = accrueInterest();
1580         if (error != uint(Error.NO_ERROR)) {
1581             // accrueInterest emits logs on errors, but we still want to log the fact that an attempted redeem failed
1582             return fail(Error(error), FailureInfo.REDEEM_ACCRUE_INTEREST_FAILED);
1583         }
1584         // redeemFresh emits redeem-specific logs on errors, so we don't need to
1585         return redeemFresh(msg.sender, redeemTokens, 0);
1586     }
1587 
1588     /**
1589      * @notice Sender redeems cTokens in exchange for a specified amount of underlying asset
1590      * @dev Accrues interest whether or not the operation succeeds, unless reverted
1591      * @param redeemAmount The amount of underlying to redeem
1592      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
1593      */
1594     function redeemUnderlyingInternal(uint redeemAmount) internal nonReentrant returns (uint) {
1595         uint error = accrueInterest();
1596         if (error != uint(Error.NO_ERROR)) {
1597             // accrueInterest emits logs on errors, but we still want to log the fact that an attempted redeem failed
1598             return fail(Error(error), FailureInfo.REDEEM_ACCRUE_INTEREST_FAILED);
1599         }
1600         // redeemFresh emits redeem-specific logs on errors, so we don't need to
1601         return redeemFresh(msg.sender, 0, redeemAmount);
1602     }
1603 
1604     struct RedeemLocalVars {
1605         Error err;
1606         MathError mathErr;
1607         uint exchangeRateMantissa;
1608         uint redeemTokens;
1609         uint redeemAmount;
1610         uint totalSupplyNew;
1611         uint accountTokensNew;
1612     }
1613 
1614     /**
1615      * @notice User redeems cTokens in exchange for the underlying asset
1616      * @dev Assumes interest has already been accrued up to the current block
1617      * @param redeemer The address of the account which is redeeming the tokens
1618      * @param redeemTokensIn The number of cTokens to redeem into underlying (only one of redeemTokensIn or redeemAmountIn may be zero)
1619      * @param redeemAmountIn The number of cTokens to redeem into underlying (only one of redeemTokensIn or redeemAmountIn may be zero)
1620      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
1621      */
1622     function redeemFresh(address payable redeemer, uint redeemTokensIn, uint redeemAmountIn) internal returns (uint) {
1623         require(redeemTokensIn == 0 || redeemAmountIn == 0, "one of redeemTokensIn or redeemAmountIn must be zero");
1624 
1625         RedeemLocalVars memory vars;
1626 
1627         /* exchangeRate = invoke Exchange Rate Stored() */
1628         (vars.mathErr, vars.exchangeRateMantissa) = exchangeRateStoredInternal();
1629         if (vars.mathErr != MathError.NO_ERROR) {
1630             return failOpaque(Error.MATH_ERROR, FailureInfo.REDEEM_EXCHANGE_RATE_READ_FAILED, uint(vars.mathErr));
1631         }
1632 
1633         /* If redeemTokensIn > 0: */
1634         if (redeemTokensIn > 0) {
1635             /*
1636              * We calculate the exchange rate and the amount of underlying to be redeemed:
1637              *  redeemTokens = redeemTokensIn
1638              *  redeemAmount = redeemTokensIn x exchangeRateCurrent
1639              */
1640             vars.redeemTokens = redeemTokensIn;
1641 
1642             (vars.mathErr, vars.redeemAmount) = mulScalarTruncate(Exp({mantissa: vars.exchangeRateMantissa}), redeemTokensIn);
1643             if (vars.mathErr != MathError.NO_ERROR) {
1644                 return failOpaque(Error.MATH_ERROR, FailureInfo.REDEEM_EXCHANGE_TOKENS_CALCULATION_FAILED, uint(vars.mathErr));
1645             }
1646         } else {
1647             /*
1648              * We get the current exchange rate and calculate the amount to be redeemed:
1649              *  redeemTokens = redeemAmountIn / exchangeRate
1650              *  redeemAmount = redeemAmountIn
1651              */
1652 
1653             (vars.mathErr, vars.redeemTokens) = divScalarByExpTruncate(redeemAmountIn, Exp({mantissa: vars.exchangeRateMantissa}));
1654             if (vars.mathErr != MathError.NO_ERROR) {
1655                 return failOpaque(Error.MATH_ERROR, FailureInfo.REDEEM_EXCHANGE_AMOUNT_CALCULATION_FAILED, uint(vars.mathErr));
1656             }
1657 
1658             vars.redeemAmount = redeemAmountIn;
1659         }
1660 
1661         /* Fail if redeem not allowed */
1662         uint allowed = comptroller.redeemAllowed(address(this), redeemer, vars.redeemTokens);
1663         if (allowed != 0) {
1664             return failOpaque(Error.COMPTROLLER_REJECTION, FailureInfo.REDEEM_COMPTROLLER_REJECTION, allowed);
1665         }
1666 
1667         /* Verify market's block number equals current block number */
1668         if (accrualBlockNumber != getBlockNumber()) {
1669             return fail(Error.MARKET_NOT_FRESH, FailureInfo.REDEEM_FRESHNESS_CHECK);
1670         }
1671 
1672         /*
1673          * We calculate the new total supply and redeemer balance, checking for underflow:
1674          *  totalSupplyNew = totalSupply - redeemTokens
1675          *  accountTokensNew = accountTokens[redeemer] - redeemTokens
1676          */
1677         (vars.mathErr, vars.totalSupplyNew) = subUInt(totalSupply, vars.redeemTokens);
1678         if (vars.mathErr != MathError.NO_ERROR) {
1679             return failOpaque(Error.MATH_ERROR, FailureInfo.REDEEM_NEW_TOTAL_SUPPLY_CALCULATION_FAILED, uint(vars.mathErr));
1680         }
1681 
1682         (vars.mathErr, vars.accountTokensNew) = subUInt(accountTokens[redeemer], vars.redeemTokens);
1683         if (vars.mathErr != MathError.NO_ERROR) {
1684             return failOpaque(Error.MATH_ERROR, FailureInfo.REDEEM_NEW_ACCOUNT_BALANCE_CALCULATION_FAILED, uint(vars.mathErr));
1685         }
1686 
1687         /* Fail gracefully if protocol has insufficient cash */
1688         if (getCashPrior() < vars.redeemAmount) {
1689             return fail(Error.TOKEN_INSUFFICIENT_CASH, FailureInfo.REDEEM_TRANSFER_OUT_NOT_POSSIBLE);
1690         }
1691 
1692         /////////////////////////
1693         // EFFECTS & INTERACTIONS
1694         // (No safe failures beyond this point)
1695 
1696         /*
1697          * We invoke doTransferOut for the redeemer and the redeemAmount.
1698          *  Note: The cToken must handle variations between ERC-20 and ETH underlying.
1699          *  On success, the cToken has redeemAmount less of cash.
1700          *  If doTransferOut fails despite the fact we checked pre-conditions,
1701          *   we revert because we can't be sure if side effects occurred.
1702          */
1703         vars.err = doTransferOut(redeemer, vars.redeemAmount);
1704         require(vars.err == Error.NO_ERROR, "redeem transfer out failed");
1705 
1706         /* We write previously calculated values into storage */
1707         totalSupply = vars.totalSupplyNew;
1708         accountTokens[redeemer] = vars.accountTokensNew;
1709 
1710         /* We emit a Transfer event, and a Redeem event */
1711         emit Transfer(redeemer, address(this), vars.redeemTokens);
1712         emit Redeem(redeemer, vars.redeemAmount, vars.redeemTokens);
1713 
1714         /* We call the defense hook */
1715         comptroller.redeemVerify(address(this), redeemer, vars.redeemAmount, vars.redeemTokens);
1716 
1717         return uint(Error.NO_ERROR);
1718     }
1719 
1720     /**
1721       * @notice Sender borrows assets from the protocol to their own address
1722       * @param borrowAmount The amount of the underlying asset to borrow
1723       * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
1724       */
1725     function borrowInternal(uint borrowAmount) internal nonReentrant returns (uint) {
1726         uint error = accrueInterest();
1727         if (error != uint(Error.NO_ERROR)) {
1728             // accrueInterest emits logs on errors, but we still want to log the fact that an attempted borrow failed
1729             return fail(Error(error), FailureInfo.BORROW_ACCRUE_INTEREST_FAILED);
1730         }
1731         // borrowFresh emits borrow-specific logs on errors, so we don't need to
1732         return borrowFresh(msg.sender, borrowAmount);
1733     }
1734 
1735     struct BorrowLocalVars {
1736         Error err;
1737         MathError mathErr;
1738         uint accountBorrows;
1739         uint accountBorrowsNew;
1740         uint totalBorrowsNew;
1741     }
1742 
1743     /**
1744       * @notice Users borrow assets from the protocol to their own address
1745       * @param borrowAmount The amount of the underlying asset to borrow
1746       * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
1747       */
1748     function borrowFresh(address payable borrower, uint borrowAmount) internal returns (uint) {
1749         /* Fail if borrow not allowed */
1750         uint allowed = comptroller.borrowAllowed(address(this), borrower, borrowAmount);
1751         if (allowed != 0) {
1752             return failOpaque(Error.COMPTROLLER_REJECTION, FailureInfo.BORROW_COMPTROLLER_REJECTION, allowed);
1753         }
1754 
1755         /* Verify market's block number equals current block number */
1756         if (accrualBlockNumber != getBlockNumber()) {
1757             return fail(Error.MARKET_NOT_FRESH, FailureInfo.BORROW_FRESHNESS_CHECK);
1758         }
1759 
1760         /* Fail gracefully if protocol has insufficient underlying cash */
1761         if (getCashPrior() < borrowAmount) {
1762             return fail(Error.TOKEN_INSUFFICIENT_CASH, FailureInfo.BORROW_CASH_NOT_AVAILABLE);
1763         }
1764 
1765         BorrowLocalVars memory vars;
1766 
1767         /*
1768          * We calculate the new borrower and total borrow balances, failing on overflow:
1769          *  accountBorrowsNew = accountBorrows + borrowAmount
1770          *  totalBorrowsNew = totalBorrows + borrowAmount
1771          */
1772         (vars.mathErr, vars.accountBorrows) = borrowBalanceStoredInternal(borrower);
1773         if (vars.mathErr != MathError.NO_ERROR) {
1774             return failOpaque(Error.MATH_ERROR, FailureInfo.BORROW_ACCUMULATED_BALANCE_CALCULATION_FAILED, uint(vars.mathErr));
1775         }
1776 
1777         (vars.mathErr, vars.accountBorrowsNew) = addUInt(vars.accountBorrows, borrowAmount);
1778         if (vars.mathErr != MathError.NO_ERROR) {
1779             return failOpaque(Error.MATH_ERROR, FailureInfo.BORROW_NEW_ACCOUNT_BORROW_BALANCE_CALCULATION_FAILED, uint(vars.mathErr));
1780         }
1781 
1782         (vars.mathErr, vars.totalBorrowsNew) = addUInt(totalBorrows, borrowAmount);
1783         if (vars.mathErr != MathError.NO_ERROR) {
1784             return failOpaque(Error.MATH_ERROR, FailureInfo.BORROW_NEW_TOTAL_BALANCE_CALCULATION_FAILED, uint(vars.mathErr));
1785         }
1786 
1787         /////////////////////////
1788         // EFFECTS & INTERACTIONS
1789         // (No safe failures beyond this point)
1790 
1791         /*
1792          * We invoke doTransferOut for the borrower and the borrowAmount.
1793          *  Note: The cToken must handle variations between ERC-20 and ETH underlying.
1794          *  On success, the cToken borrowAmount less of cash.
1795          *  If doTransferOut fails despite the fact we checked pre-conditions,
1796          *   we revert because we can't be sure if side effects occurred.
1797          */
1798         vars.err = doTransferOut(borrower, borrowAmount);
1799         require(vars.err == Error.NO_ERROR, "borrow transfer out failed");
1800 
1801         /* We write the previously calculated values into storage */
1802         accountBorrows[borrower].principal = vars.accountBorrowsNew;
1803         accountBorrows[borrower].interestIndex = borrowIndex;
1804         totalBorrows = vars.totalBorrowsNew;
1805 
1806         /* We emit a Borrow event */
1807         emit Borrow(borrower, borrowAmount, vars.accountBorrowsNew, vars.totalBorrowsNew);
1808 
1809         /* We call the defense hook */
1810         comptroller.borrowVerify(address(this), borrower, borrowAmount);
1811 
1812         return uint(Error.NO_ERROR);
1813     }
1814 
1815     /**
1816      * @notice Sender repays their own borrow
1817      * @param repayAmount The amount to repay
1818      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
1819      */
1820     function repayBorrowInternal(uint repayAmount) internal nonReentrant returns (uint) {
1821         uint error = accrueInterest();
1822         if (error != uint(Error.NO_ERROR)) {
1823             // accrueInterest emits logs on errors, but we still want to log the fact that an attempted borrow failed
1824             return fail(Error(error), FailureInfo.REPAY_BORROW_ACCRUE_INTEREST_FAILED);
1825         }
1826         // repayBorrowFresh emits repay-borrow-specific logs on errors, so we don't need to
1827         return repayBorrowFresh(msg.sender, msg.sender, repayAmount);
1828     }
1829 
1830     /**
1831      * @notice Sender repays a borrow belonging to borrower
1832      * @param borrower the account with the debt being payed off
1833      * @param repayAmount The amount to repay
1834      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
1835      */
1836     function repayBorrowBehalfInternal(address borrower, uint repayAmount) internal nonReentrant returns (uint) {
1837         uint error = accrueInterest();
1838         if (error != uint(Error.NO_ERROR)) {
1839             // accrueInterest emits logs on errors, but we still want to log the fact that an attempted borrow failed
1840             return fail(Error(error), FailureInfo.REPAY_BEHALF_ACCRUE_INTEREST_FAILED);
1841         }
1842         // repayBorrowFresh emits repay-borrow-specific logs on errors, so we don't need to
1843         return repayBorrowFresh(msg.sender, borrower, repayAmount);
1844     }
1845 
1846     struct RepayBorrowLocalVars {
1847         Error err;
1848         MathError mathErr;
1849         uint repayAmount;
1850         uint borrowerIndex;
1851         uint accountBorrows;
1852         uint accountBorrowsNew;
1853         uint totalBorrowsNew;
1854     }
1855 
1856     /**
1857      * @notice Borrows are repaid by another user (possibly the borrower).
1858      * @param payer the account paying off the borrow
1859      * @param borrower the account with the debt being payed off
1860      * @param repayAmount the amount of undelrying tokens being returned
1861      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
1862      */
1863     function repayBorrowFresh(address payer, address borrower, uint repayAmount) internal returns (uint) {
1864         /* Fail if repayBorrow not allowed */
1865         uint allowed = comptroller.repayBorrowAllowed(address(this), payer, borrower, repayAmount);
1866         if (allowed != 0) {
1867             return failOpaque(Error.COMPTROLLER_REJECTION, FailureInfo.REPAY_BORROW_COMPTROLLER_REJECTION, allowed);
1868         }
1869 
1870         /* Verify market's block number equals current block number */
1871         if (accrualBlockNumber != getBlockNumber()) {
1872             return fail(Error.MARKET_NOT_FRESH, FailureInfo.REPAY_BORROW_FRESHNESS_CHECK);
1873         }
1874 
1875         RepayBorrowLocalVars memory vars;
1876 
1877         /* We remember the original borrowerIndex for verification purposes */
1878         vars.borrowerIndex = accountBorrows[borrower].interestIndex;
1879 
1880         /* We fetch the amount the borrower owes, with accumulated interest */
1881         (vars.mathErr, vars.accountBorrows) = borrowBalanceStoredInternal(borrower);
1882         if (vars.mathErr != MathError.NO_ERROR) {
1883             return failOpaque(Error.MATH_ERROR, FailureInfo.REPAY_BORROW_ACCUMULATED_BALANCE_CALCULATION_FAILED, uint(vars.mathErr));
1884         }
1885 
1886         /* If repayAmount == -1, repayAmount = accountBorrows */
1887         if (repayAmount == uint(-1)) {
1888             vars.repayAmount = vars.accountBorrows;
1889         } else {
1890             vars.repayAmount = repayAmount;
1891         }
1892 
1893         /* Fail if checkTransferIn fails */
1894         vars.err = checkTransferIn(payer, vars.repayAmount);
1895         if (vars.err != Error.NO_ERROR) {
1896             return fail(vars.err, FailureInfo.REPAY_BORROW_TRANSFER_IN_NOT_POSSIBLE);
1897         }
1898 
1899         /*
1900          * We calculate the new borrower and total borrow balances, failing on underflow:
1901          *  accountBorrowsNew = accountBorrows - repayAmount
1902          *  totalBorrowsNew = totalBorrows - repayAmount
1903          */
1904         (vars.mathErr, vars.accountBorrowsNew) = subUInt(vars.accountBorrows, vars.repayAmount);
1905         if (vars.mathErr != MathError.NO_ERROR) {
1906             return failOpaque(Error.MATH_ERROR, FailureInfo.REPAY_BORROW_NEW_ACCOUNT_BORROW_BALANCE_CALCULATION_FAILED, uint(vars.mathErr));
1907         }
1908 
1909         (vars.mathErr, vars.totalBorrowsNew) = subUInt(totalBorrows, vars.repayAmount);
1910         if (vars.mathErr != MathError.NO_ERROR) {
1911             return failOpaque(Error.MATH_ERROR, FailureInfo.REPAY_BORROW_NEW_TOTAL_BALANCE_CALCULATION_FAILED, uint(vars.mathErr));
1912         }
1913 
1914         /////////////////////////
1915         // EFFECTS & INTERACTIONS
1916         // (No safe failures beyond this point)
1917 
1918         /*
1919          * We call doTransferIn for the payer and the repayAmount
1920          *  Note: The cToken must handle variations between ERC-20 and ETH underlying.
1921          *  On success, the cToken holds an additional repayAmount of cash.
1922          *  If doTransferIn fails despite the fact we checked pre-conditions,
1923          *   we revert because we can't be sure if side effects occurred.
1924          */
1925         vars.err = doTransferIn(payer, vars.repayAmount);
1926         require(vars.err == Error.NO_ERROR, "repay borrow transfer in failed");
1927 
1928         /* We write the previously calculated values into storage */
1929         accountBorrows[borrower].principal = vars.accountBorrowsNew;
1930         accountBorrows[borrower].interestIndex = borrowIndex;
1931         totalBorrows = vars.totalBorrowsNew;
1932 
1933         /* We emit a RepayBorrow event */
1934         emit RepayBorrow(payer, borrower, vars.repayAmount, vars.accountBorrowsNew, vars.totalBorrowsNew);
1935 
1936         /* We call the defense hook */
1937         comptroller.repayBorrowVerify(address(this), payer, borrower, vars.repayAmount, vars.borrowerIndex);
1938 
1939         return uint(Error.NO_ERROR);
1940     }
1941 
1942     /**
1943      * @notice The sender liquidates the borrowers collateral.
1944      *  The collateral seized is transferred to the liquidator.
1945      * @param borrower The borrower of this cToken to be liquidated
1946      * @param cTokenCollateral The market in which to seize collateral from the borrower
1947      * @param repayAmount The amount of the underlying borrowed asset to repay
1948      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
1949      */
1950     function liquidateBorrowInternal(address borrower, uint repayAmount, CToken cTokenCollateral) internal nonReentrant returns (uint) {
1951         uint error = accrueInterest();
1952         if (error != uint(Error.NO_ERROR)) {
1953             // accrueInterest emits logs on errors, but we still want to log the fact that an attempted liquidation failed
1954             return fail(Error(error), FailureInfo.LIQUIDATE_ACCRUE_BORROW_INTEREST_FAILED);
1955         }
1956 
1957         error = cTokenCollateral.accrueInterest();
1958         if (error != uint(Error.NO_ERROR)) {
1959             // accrueInterest emits logs on errors, but we still want to log the fact that an attempted liquidation failed
1960             return fail(Error(error), FailureInfo.LIQUIDATE_ACCRUE_COLLATERAL_INTEREST_FAILED);
1961         }
1962 
1963         // liquidateBorrowFresh emits borrow-specific logs on errors, so we don't need to
1964         return liquidateBorrowFresh(msg.sender, borrower, repayAmount, cTokenCollateral);
1965     }
1966 
1967     /**
1968      * @notice The liquidator liquidates the borrowers collateral.
1969      *  The collateral seized is transferred to the liquidator.
1970      * @param borrower The borrower of this cToken to be liquidated
1971      * @param liquidator The address repaying the borrow and seizing collateral
1972      * @param cTokenCollateral The market in which to seize collateral from the borrower
1973      * @param repayAmount The amount of the underlying borrowed asset to repay
1974      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
1975      */
1976     function liquidateBorrowFresh(address liquidator, address borrower, uint repayAmount, CToken cTokenCollateral) internal returns (uint) {
1977         /* Fail if liquidate not allowed */
1978         uint allowed = comptroller.liquidateBorrowAllowed(address(this), address(cTokenCollateral), liquidator, borrower, repayAmount);
1979         if (allowed != 0) {
1980             return failOpaque(Error.COMPTROLLER_REJECTION, FailureInfo.LIQUIDATE_COMPTROLLER_REJECTION, allowed);
1981         }
1982 
1983         /* Verify market's block number equals current block number */
1984         if (accrualBlockNumber != getBlockNumber()) {
1985             return fail(Error.MARKET_NOT_FRESH, FailureInfo.LIQUIDATE_FRESHNESS_CHECK);
1986         }
1987 
1988         /* Verify cTokenCollateral market's block number equals current block number */
1989         if (cTokenCollateral.accrualBlockNumber() != getBlockNumber()) {
1990             return fail(Error.MARKET_NOT_FRESH, FailureInfo.LIQUIDATE_COLLATERAL_FRESHNESS_CHECK);
1991         }
1992 
1993         /* Fail if borrower = liquidator */
1994         if (borrower == liquidator) {
1995             return fail(Error.INVALID_ACCOUNT_PAIR, FailureInfo.LIQUIDATE_LIQUIDATOR_IS_BORROWER);
1996         }
1997 
1998         /* Fail if repayAmount = 0 */
1999         if (repayAmount == 0) {
2000             return fail(Error.INVALID_CLOSE_AMOUNT_REQUESTED, FailureInfo.LIQUIDATE_CLOSE_AMOUNT_IS_ZERO);
2001         }
2002 
2003         /* Fail if repayAmount = -1 */
2004         if (repayAmount == uint(-1)) {
2005             return fail(Error.INVALID_CLOSE_AMOUNT_REQUESTED, FailureInfo.LIQUIDATE_CLOSE_AMOUNT_IS_UINT_MAX);
2006         }
2007 
2008         /* We calculate the number of collateral tokens that will be seized */
2009         (uint amountSeizeError, uint seizeTokens) = comptroller.liquidateCalculateSeizeTokens(address(this), address(cTokenCollateral), repayAmount);
2010         if (amountSeizeError != 0) {
2011             return failOpaque(Error.COMPTROLLER_CALCULATION_ERROR, FailureInfo.LIQUIDATE_COMPTROLLER_CALCULATE_AMOUNT_SEIZE_FAILED, amountSeizeError);
2012         }
2013 
2014         /* Fail if seizeTokens > borrower collateral token balance */
2015         if (seizeTokens > cTokenCollateral.balanceOf(borrower)) {
2016             return fail(Error.TOKEN_INSUFFICIENT_BALANCE, FailureInfo.LIQUIDATE_SEIZE_TOO_MUCH);
2017         }
2018 
2019         /* Fail if repayBorrow fails */
2020         uint repayBorrowError = repayBorrowFresh(liquidator, borrower, repayAmount);
2021         if (repayBorrowError != uint(Error.NO_ERROR)) {
2022             return fail(Error(repayBorrowError), FailureInfo.LIQUIDATE_REPAY_BORROW_FRESH_FAILED);
2023         }
2024 
2025         /* Revert if seize tokens fails (since we cannot be sure of side effects) */
2026         uint seizeError = cTokenCollateral.seize(liquidator, borrower, seizeTokens);
2027         require(seizeError == uint(Error.NO_ERROR), "token seizure failed");
2028 
2029         /* We emit a LiquidateBorrow event */
2030         emit LiquidateBorrow(liquidator, borrower, repayAmount, address(cTokenCollateral), seizeTokens);
2031 
2032         /* We call the defense hook */
2033         comptroller.liquidateBorrowVerify(address(this), address(cTokenCollateral), liquidator, borrower, repayAmount, seizeTokens);
2034 
2035         return uint(Error.NO_ERROR);
2036     }
2037 
2038     /**
2039      * @notice Transfers collateral tokens (this market) to the liquidator.
2040      * @dev Will fail unless called by another cToken during the process of liquidation.
2041      *  Its absolutely critical to use msg.sender as the borrowed cToken and not a parameter.
2042      * @param liquidator The account receiving seized collateral
2043      * @param borrower The account having collateral seized
2044      * @param seizeTokens The number of cTokens to seize
2045      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
2046      */
2047     function seize(address liquidator, address borrower, uint seizeTokens) external nonReentrant returns (uint) {
2048         /* Fail if seize not allowed */
2049         uint allowed = comptroller.seizeAllowed(address(this), msg.sender, liquidator, borrower, seizeTokens);
2050         if (allowed != 0) {
2051             return failOpaque(Error.COMPTROLLER_REJECTION, FailureInfo.LIQUIDATE_SEIZE_COMPTROLLER_REJECTION, allowed);
2052         }
2053 
2054         /* Fail if borrower = liquidator */
2055         if (borrower == liquidator) {
2056             return fail(Error.INVALID_ACCOUNT_PAIR, FailureInfo.LIQUIDATE_SEIZE_LIQUIDATOR_IS_BORROWER);
2057         }
2058 
2059         MathError mathErr;
2060         uint borrowerTokensNew;
2061         uint liquidatorTokensNew;
2062 
2063         /*
2064          * We calculate the new borrower and liquidator token balances, failing on underflow/overflow:
2065          *  borrowerTokensNew = accountTokens[borrower] - seizeTokens
2066          *  liquidatorTokensNew = accountTokens[liquidator] + seizeTokens
2067          */
2068         (mathErr, borrowerTokensNew) = subUInt(accountTokens[borrower], seizeTokens);
2069         if (mathErr != MathError.NO_ERROR) {
2070             return failOpaque(Error.MATH_ERROR, FailureInfo.LIQUIDATE_SEIZE_BALANCE_DECREMENT_FAILED, uint(mathErr));
2071         }
2072 
2073         (mathErr, liquidatorTokensNew) = addUInt(accountTokens[liquidator], seizeTokens);
2074         if (mathErr != MathError.NO_ERROR) {
2075             return failOpaque(Error.MATH_ERROR, FailureInfo.LIQUIDATE_SEIZE_BALANCE_INCREMENT_FAILED, uint(mathErr));
2076         }
2077 
2078         /////////////////////////
2079         // EFFECTS & INTERACTIONS
2080         // (No safe failures beyond this point)
2081 
2082         /* We write the previously calculated values into storage */
2083         accountTokens[borrower] = borrowerTokensNew;
2084         accountTokens[liquidator] = liquidatorTokensNew;
2085 
2086         /* Emit a Transfer event */
2087         emit Transfer(borrower, liquidator, seizeTokens);
2088 
2089         /* We call the defense hook */
2090         comptroller.seizeVerify(address(this), msg.sender, liquidator, borrower, seizeTokens);
2091 
2092         return uint(Error.NO_ERROR);
2093     }
2094 
2095 
2096     /*** Admin Functions ***/
2097 
2098     /**
2099       * @notice Begins transfer of admin rights. The newPendingAdmin must call `_acceptAdmin` to finalize the transfer.
2100       * @dev Admin function to begin change of admin. The newPendingAdmin must call `_acceptAdmin` to finalize the transfer.
2101       * @param newPendingAdmin New pending admin.
2102       * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
2103       *
2104       * TODO: Should we add a second arg to verify, like a checksum of `newAdmin` address?
2105       */
2106     function _setPendingAdmin(address payable newPendingAdmin) external returns (uint) {
2107         // Check caller = admin
2108         if (msg.sender != admin) {
2109             return fail(Error.UNAUTHORIZED, FailureInfo.SET_PENDING_ADMIN_OWNER_CHECK);
2110         }
2111 
2112         // Save current value, if any, for inclusion in log
2113         address oldPendingAdmin = pendingAdmin;
2114 
2115         // Store pendingAdmin with value newPendingAdmin
2116         pendingAdmin = newPendingAdmin;
2117 
2118         // Emit NewPendingAdmin(oldPendingAdmin, newPendingAdmin)
2119         emit NewPendingAdmin(oldPendingAdmin, newPendingAdmin);
2120 
2121         return uint(Error.NO_ERROR);
2122     }
2123 
2124     /**
2125       * @notice Accepts transfer of admin rights. msg.sender must be pendingAdmin
2126       * @dev Admin function for pending admin to accept role and update admin
2127       * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
2128       */
2129     function _acceptAdmin() external returns (uint) {
2130         // Check caller is pendingAdmin and pendingAdmin ≠ address(0)
2131         if (msg.sender != pendingAdmin || msg.sender == address(0)) {
2132             return fail(Error.UNAUTHORIZED, FailureInfo.ACCEPT_ADMIN_PENDING_ADMIN_CHECK);
2133         }
2134 
2135         // Save current values for inclusion in log
2136         address oldAdmin = admin;
2137         address oldPendingAdmin = pendingAdmin;
2138 
2139         // Store admin with value pendingAdmin
2140         admin = pendingAdmin;
2141 
2142         // Clear the pending value
2143         pendingAdmin = address(0);
2144 
2145         emit NewAdmin(oldAdmin, admin);
2146         emit NewPendingAdmin(oldPendingAdmin, pendingAdmin);
2147 
2148         return uint(Error.NO_ERROR);
2149     }
2150 
2151     /**
2152       * @notice Sets a new comptroller for the market
2153       * @dev Admin function to set a new comptroller
2154       * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
2155       */
2156     function _setComptroller(ComptrollerInterface newComptroller) public returns (uint) {
2157         // Check caller is admin
2158         if (msg.sender != admin) {
2159             return fail(Error.UNAUTHORIZED, FailureInfo.SET_COMPTROLLER_OWNER_CHECK);
2160         }
2161 
2162         ComptrollerInterface oldComptroller = comptroller;
2163         // Ensure invoke comptroller.isComptroller() returns true
2164         require(newComptroller.isComptroller(), "marker method returned false");
2165 
2166         // Set market's comptroller to newComptroller
2167         comptroller = newComptroller;
2168 
2169         // Emit NewComptroller(oldComptroller, newComptroller)
2170         emit NewComptroller(oldComptroller, newComptroller);
2171 
2172         return uint(Error.NO_ERROR);
2173     }
2174 
2175     /**
2176       * @notice accrues interest and sets a new reserve factor for the protocol using _setReserveFactorFresh
2177       * @dev Admin function to accrue interest and set a new reserve factor
2178       * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
2179       */
2180     function _setReserveFactor(uint newReserveFactorMantissa) external nonReentrant returns (uint) {
2181         uint error = accrueInterest();
2182         if (error != uint(Error.NO_ERROR)) {
2183             // accrueInterest emits logs on errors, but on top of that we want to log the fact that an attempted reserve factor change failed.
2184             return fail(Error(error), FailureInfo.SET_RESERVE_FACTOR_ACCRUE_INTEREST_FAILED);
2185         }
2186         // _setReserveFactorFresh emits reserve-factor-specific logs on errors, so we don't need to.
2187         return _setReserveFactorFresh(newReserveFactorMantissa);
2188     }
2189 
2190     /**
2191       * @notice Sets a new reserve factor for the protocol (*requires fresh interest accrual)
2192       * @dev Admin function to set a new reserve factor
2193       * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
2194       */
2195     function _setReserveFactorFresh(uint newReserveFactorMantissa) internal returns (uint) {
2196         // Check caller is admin
2197         if (msg.sender != admin) {
2198             return fail(Error.UNAUTHORIZED, FailureInfo.SET_RESERVE_FACTOR_ADMIN_CHECK);
2199         }
2200 
2201         // Verify market's block number equals current block number
2202         if (accrualBlockNumber != getBlockNumber()) {
2203             // TODO: static_assert + no error code?
2204             return fail(Error.MARKET_NOT_FRESH, FailureInfo.SET_RESERVE_FACTOR_FRESH_CHECK);
2205         }
2206 
2207         // Check newReserveFactor ≤ maxReserveFactor
2208         if (newReserveFactorMantissa > reserveFactorMaxMantissa) {
2209             return fail(Error.BAD_INPUT, FailureInfo.SET_RESERVE_FACTOR_BOUNDS_CHECK);
2210         }
2211 
2212         uint oldReserveFactorMantissa = reserveFactorMantissa;
2213         reserveFactorMantissa = newReserveFactorMantissa;
2214 
2215         emit NewReserveFactor(oldReserveFactorMantissa, newReserveFactorMantissa);
2216 
2217         return uint(Error.NO_ERROR);
2218     }
2219 
2220     /**
2221      * @notice Accrues interest and reduces reserves by transferring to admin
2222      * @param reduceAmount Amount of reduction to reserves
2223      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
2224      */
2225     function _reduceReserves(uint reduceAmount) external nonReentrant returns (uint) {
2226         uint error = accrueInterest();
2227         if (error != uint(Error.NO_ERROR)) {
2228             // accrueInterest emits logs on errors, but on top of that we want to log the fact that an attempted reduce reserves failed.
2229             return fail(Error(error), FailureInfo.REDUCE_RESERVES_ACCRUE_INTEREST_FAILED);
2230         }
2231         // _reduceReservesFresh emits reserve-reduction-specific logs on errors, so we don't need to.
2232         return _reduceReservesFresh(reduceAmount);
2233     }
2234 
2235     /**
2236      * @notice Reduces reserves by transferring to admin
2237      * @dev Requires fresh interest accrual
2238      * @param reduceAmount Amount of reduction to reserves
2239      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
2240      */
2241     function _reduceReservesFresh(uint reduceAmount) internal returns (uint) {
2242         Error err;
2243         // totalReserves - reduceAmount
2244         uint totalReservesNew;
2245 
2246         // Check caller is admin
2247         if (msg.sender != admin) {
2248             return fail(Error.UNAUTHORIZED, FailureInfo.REDUCE_RESERVES_ADMIN_CHECK);
2249         }
2250 
2251         // We fail gracefully unless market's block number equals current block number
2252         if (accrualBlockNumber != getBlockNumber()) {
2253             // TODO: static_assert + no error code?
2254             return fail(Error.MARKET_NOT_FRESH, FailureInfo.REDUCE_RESERVES_FRESH_CHECK);
2255         }
2256 
2257         // Fail gracefully if protocol has insufficient underlying cash
2258         if (getCashPrior() < reduceAmount) {
2259             return fail(Error.TOKEN_INSUFFICIENT_CASH, FailureInfo.REDUCE_RESERVES_CASH_NOT_AVAILABLE);
2260         }
2261 
2262         // Check reduceAmount ≤ reserves[n] (totalReserves)
2263         // TODO: I'm following the spec literally here but I think we should we just use SafeMath instead and fail on an error (which would be underflow)
2264         if (reduceAmount > totalReserves) {
2265             return fail(Error.BAD_INPUT, FailureInfo.REDUCE_RESERVES_VALIDATION);
2266         }
2267 
2268         /////////////////////////
2269         // EFFECTS & INTERACTIONS
2270         // (No safe failures beyond this point)
2271 
2272         totalReservesNew = totalReserves - reduceAmount;
2273         // We checked reduceAmount <= totalReserves above, so this should never revert.
2274         require(totalReservesNew <= totalReserves, "reduce reserves unexpected underflow");
2275 
2276         // Store reserves[n+1] = reserves[n] - reduceAmount
2277         totalReserves = totalReservesNew;
2278 
2279         // invoke doTransferOut(reduceAmount, admin)
2280         err = doTransferOut(admin, reduceAmount);
2281         // we revert on the failure of this command
2282         require(err == Error.NO_ERROR, "reduce reserves transfer out failed");
2283 
2284         emit ReservesReduced(admin, reduceAmount, totalReservesNew);
2285 
2286         return uint(Error.NO_ERROR);
2287     }
2288 
2289     /**
2290      * @notice accrues interest and updates the interest rate model using _setInterestRateModelFresh
2291      * @dev Admin function to accrue interest and update the interest rate model
2292      * @param newInterestRateModel the new interest rate model to use
2293      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
2294      */
2295     function _setInterestRateModel(InterestRateModel newInterestRateModel) public returns (uint) {
2296         uint error = accrueInterest();
2297         if (error != uint(Error.NO_ERROR)) {
2298             // accrueInterest emits logs on errors, but on top of that we want to log the fact that an attempted change of interest rate model failed
2299             return fail(Error(error), FailureInfo.SET_INTEREST_RATE_MODEL_ACCRUE_INTEREST_FAILED);
2300         }
2301         // _setInterestRateModelFresh emits interest-rate-model-update-specific logs on errors, so we don't need to.
2302         return _setInterestRateModelFresh(newInterestRateModel);
2303     }
2304 
2305     /**
2306      * @notice updates the interest rate model (*requires fresh interest accrual)
2307      * @dev Admin function to update the interest rate model
2308      * @param newInterestRateModel the new interest rate model to use
2309      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
2310      */
2311     function _setInterestRateModelFresh(InterestRateModel newInterestRateModel) internal returns (uint) {
2312 
2313         // Used to store old model for use in the event that is emitted on success
2314         InterestRateModel oldInterestRateModel;
2315 
2316         // Check caller is admin
2317         if (msg.sender != admin) {
2318             return fail(Error.UNAUTHORIZED, FailureInfo.SET_INTEREST_RATE_MODEL_OWNER_CHECK);
2319         }
2320 
2321         // We fail gracefully unless market's block number equals current block number
2322         if (accrualBlockNumber != getBlockNumber()) {
2323             // TODO: static_assert + no error code?
2324             return fail(Error.MARKET_NOT_FRESH, FailureInfo.SET_INTEREST_RATE_MODEL_FRESH_CHECK);
2325         }
2326 
2327         // Track the market's current interest rate model
2328         oldInterestRateModel = interestRateModel;
2329 
2330         // Ensure invoke newInterestRateModel.isInterestRateModel() returns true
2331         require(newInterestRateModel.isInterestRateModel(), "marker method returned false");
2332 
2333         // Set the interest rate model to newInterestRateModel
2334         interestRateModel = newInterestRateModel;
2335 
2336         // Emit NewMarketInterestRateModel(oldInterestRateModel, newInterestRateModel)
2337         emit NewMarketInterestRateModel(oldInterestRateModel, newInterestRateModel);
2338 
2339         return uint(Error.NO_ERROR);
2340     }
2341 
2342     /*** Safe Token ***/
2343 
2344     /**
2345      * @notice Gets balance of this contract in terms of the underlying
2346      * @dev This excludes the value of the current message, if any
2347      * @return The quantity of underlying owned by this contract
2348      */
2349     function getCashPrior() internal view returns (uint);
2350 
2351     /**
2352      * @dev Checks whether or not there is sufficient allowance for this contract to move amount from `from` and
2353      *      whether or not `from` has a balance of at least `amount`. Does NOT do a transfer.
2354      */
2355     function checkTransferIn(address from, uint amount) internal view returns (Error);
2356 
2357     /**
2358      * @dev Performs a transfer in, ideally returning an explanatory error code upon failure rather than reverting.
2359      *  If caller has not called `checkTransferIn`, this may revert due to insufficient balance or insufficient allowance.
2360      *  If caller has called `checkTransferIn` successfully, this should not revert in normal conditions.
2361      */
2362     function doTransferIn(address from, uint amount) internal returns (Error);
2363 
2364     /**
2365      * @dev Performs a transfer out, ideally returning an explanatory error code upon failure tather than reverting.
2366      *  If caller has not called checked protocol's balance, may revert due to insufficient cash held in the contract.
2367      *  If caller has checked protocol's balance, and verified it is >= amount, this should not revert in normal conditions.
2368      */
2369     function doTransferOut(address payable to, uint amount) internal returns (Error);
2370 }
2371 
2372 // File: contracts/CEther.sol
2373 
2374 pragma solidity ^0.5.8;
2375 
2376 
2377 /**
2378  * @title Compound's CEther Contract
2379  * @notice CToken which wraps Ether
2380  * @author Compound
2381  */
2382 contract CEther is CToken {
2383     /**
2384      * @notice Construct a new CEther money market
2385      * @param comptroller_ The address of the Comptroller
2386      * @param interestRateModel_ The address of the interest rate model
2387      * @param initialExchangeRateMantissa_ The initial exchange rate, scaled by 1e18
2388      * @param name_ ERC-20 name of this token
2389      * @param symbol_ ERC-20 symbol of this token
2390      * @param decimals_ ERC-20 decimal precision of this token
2391      */
2392     constructor(ComptrollerInterface comptroller_,
2393                 InterestRateModel interestRateModel_,
2394                 uint initialExchangeRateMantissa_,
2395                 string memory name_,
2396                 string memory symbol_,
2397                 uint decimals_) public
2398     CToken(comptroller_, interestRateModel_, initialExchangeRateMantissa_, name_, symbol_, decimals_) {}
2399 
2400     /*** User Interface ***/
2401 
2402     /**
2403      * @notice Sender supplies assets into the market and receives cTokens in exchange
2404      * @dev Reverts upon any failure
2405      */
2406     function mint() external payable {
2407         requireNoError(mintInternal(msg.value), "mint failed");
2408     }
2409 
2410     /**
2411      * @notice Sender redeems cTokens in exchange for the underlying asset
2412      * @dev Accrues interest whether or not the operation succeeds, unless reverted
2413      * @param redeemTokens The number of cTokens to redeem into underlying
2414      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
2415      */
2416     function redeem(uint redeemTokens) external returns (uint) {
2417         return redeemInternal(redeemTokens);
2418     }
2419 
2420     /**
2421      * @notice Sender redeems cTokens in exchange for a specified amount of underlying asset
2422      * @dev Accrues interest whether or not the operation succeeds, unless reverted
2423      * @param redeemAmount The amount of underlying to redeem
2424      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
2425      */
2426     function redeemUnderlying(uint redeemAmount) external returns (uint) {
2427         return redeemUnderlyingInternal(redeemAmount);
2428     }
2429 
2430     /**
2431       * @notice Sender borrows assets from the protocol to their own address
2432       * @param borrowAmount The amount of the underlying asset to borrow
2433       * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
2434       */
2435     function borrow(uint borrowAmount) external returns (uint) {
2436         return borrowInternal(borrowAmount);
2437     }
2438 
2439     /**
2440      * @notice Sender repays their own borrow
2441      * @dev Reverts upon any failure
2442      */
2443     function repayBorrow() external payable {
2444         requireNoError(repayBorrowInternal(msg.value), "repayBorrow failed");
2445     }
2446 
2447     /**
2448      * @notice Sender repays a borrow belonging to borrower
2449      * @dev Reverts upon any failure
2450      * @param borrower the account with the debt being payed off
2451      */
2452     function repayBorrowBehalf(address borrower) external payable {
2453         requireNoError(repayBorrowBehalfInternal(borrower, msg.value), "repayBorrowBehalf failed");
2454     }
2455 
2456     /**
2457      * @notice The sender liquidates the borrowers collateral.
2458      *  The collateral seized is transferred to the liquidator.
2459      * @dev Reverts upon any failure
2460      * @param borrower The borrower of this cToken to be liquidated
2461      * @param cTokenCollateral The market in which to seize collateral from the borrower
2462      */
2463     function liquidateBorrow(address borrower, CToken cTokenCollateral) external payable {
2464         requireNoError(liquidateBorrowInternal(borrower, msg.value, cTokenCollateral), "liquidateBorrow failed");
2465     }
2466 
2467     /**
2468      * @notice Send Ether to CEther to mint
2469      */
2470     function () external payable {
2471         requireNoError(mintInternal(msg.value), "mint failed");
2472     }
2473 
2474     /*** Safe Token ***/
2475 
2476     /**
2477      * @notice Gets balance of this contract in terms of Ether, before this message
2478      * @dev This excludes the value of the current message, if any
2479      * @return The quantity of Ether owned by this contract
2480      */
2481     function getCashPrior() internal view returns (uint) {
2482         (MathError err, uint startingBalance) = subUInt(address(this).balance, msg.value);
2483         require(err == MathError.NO_ERROR);
2484         return startingBalance;
2485     }
2486 
2487     /**
2488      * @notice Checks whether the requested transfer matches the `msg`
2489      * @dev Does NOT do a transfer
2490      * @param from Address sending the Ether
2491      * @param amount Amount of Ether being sent
2492      * @return Whether or not the transfer checks out
2493      */
2494     function checkTransferIn(address from, uint amount) internal view returns (Error) {
2495         // Sanity checks
2496         require(msg.sender == from, "sender mismatch");
2497         require(msg.value == amount, "value mismatch");
2498         return Error.NO_ERROR;
2499     }
2500 
2501     /**
2502      * @notice Perform the actual transfer in, which is a no-op
2503      * @param from Address sending the Ether
2504      * @param amount Amount of Ether being sent
2505      * @return Success
2506      */
2507     function doTransferIn(address from, uint amount) internal returns (Error) {
2508         // Sanity checks
2509         require(msg.sender == from, "sender mismatch");
2510         require(msg.value == amount, "value mismatch");
2511         return Error.NO_ERROR;
2512     }
2513 
2514     function doTransferOut(address payable to, uint amount) internal returns (Error) {
2515         /* Send the Ether, with minimal gas and revert on failure */
2516         to.transfer(amount);
2517         return Error.NO_ERROR;
2518     }
2519 
2520     function requireNoError(uint errCode, string memory message) internal pure {
2521         if (errCode == uint(Error.NO_ERROR)) {
2522             return;
2523         }
2524 
2525         bytes memory fullMessage = new bytes(bytes(message).length + 5);
2526         uint i;
2527 
2528         for (i = 0; i < bytes(message).length; i++) {
2529             fullMessage[i] = bytes(message)[i];
2530         }
2531 
2532         fullMessage[i+0] = byte(uint8(32));
2533         fullMessage[i+1] = byte(uint8(40));
2534         fullMessage[i+2] = byte(uint8(48 + ( errCode / 10 )));
2535         fullMessage[i+3] = byte(uint8(48 + ( errCode % 10 )));
2536         fullMessage[i+4] = byte(uint8(41));
2537 
2538         require(errCode == uint(Error.NO_ERROR), string(fullMessage));
2539     }
2540 }
