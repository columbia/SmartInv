1 /**
2  *Submitted for verification at Etherscan.io on 2019-05-07
3 */
4 
5 // File: contracts/ComptrollerInterface.sol
6 
7 pragma solidity ^0.5.8;
8 
9 interface ComptrollerInterface {
10     /**
11      * @notice Marker function used for light validation when updating the comptroller of a market
12      * @dev Implementations should simply return true.
13      * @return true
14      */
15     function isComptroller() external view returns (bool);
16 
17     /*** Assets You Are In ***/
18 
19     function enterMarkets(address[] calldata cTokens) external returns (uint[] memory);
20     function exitMarket(address cToken) external returns (uint);
21 
22     /*** Policy Hooks ***/
23 
24     function mintAllowed(address cToken, address minter, uint mintAmount) external returns (uint);
25     function mintVerify(address cToken, address minter, uint mintAmount, uint mintTokens) external;
26 
27     function redeemAllowed(address cToken, address redeemer, uint redeemTokens) external returns (uint);
28     function redeemVerify(address cToken, address redeemer, uint redeemAmount, uint redeemTokens) external;
29 
30     function borrowAllowed(address cToken, address borrower, uint borrowAmount) external returns (uint);
31     function borrowVerify(address cToken, address borrower, uint borrowAmount) external;
32 
33     function repayBorrowAllowed(
34         address cToken,
35         address payer,
36         address borrower,
37         uint repayAmount) external returns (uint);
38     function repayBorrowVerify(
39         address cToken,
40         address payer,
41         address borrower,
42         uint repayAmount,
43         uint borrowerIndex) external;
44 
45     function liquidateBorrowAllowed(
46         address cTokenBorrowed,
47         address cTokenCollateral,
48         address liquidator,
49         address borrower,
50         uint repayAmount) external returns (uint);
51     function liquidateBorrowVerify(
52         address cTokenBorrowed,
53         address cTokenCollateral,
54         address liquidator,
55         address borrower,
56         uint repayAmount,
57         uint seizeTokens) external;
58 
59     function seizeAllowed(
60         address cTokenCollateral,
61         address cTokenBorrowed,
62         address liquidator,
63         address borrower,
64         uint seizeTokens) external returns (uint);
65     function seizeVerify(
66         address cTokenCollateral,
67         address cTokenBorrowed,
68         address liquidator,
69         address borrower,
70         uint seizeTokens) external;
71 
72     function transferAllowed(address cToken, address src, address dst, uint transferTokens) external returns (uint);
73     function transferVerify(address cToken, address src, address dst, uint transferTokens) external;
74 
75     /*** Liquidity/Liquidation Calculations ***/
76 
77     function liquidateCalculateSeizeTokens(
78         address cTokenBorrowed,
79         address cTokenCollateral,
80         uint repayAmount) external view returns (uint, uint);
81 }
82 
83 // File: contracts/ErrorReporter.sol
84 
85 pragma solidity ^0.5.8;
86 
87 contract ComptrollerErrorReporter {
88     enum Error {
89         NO_ERROR,
90         UNAUTHORIZED,
91         COMPTROLLER_MISMATCH,
92         INSUFFICIENT_SHORTFALL,
93         INSUFFICIENT_LIQUIDITY,
94         INVALID_CLOSE_FACTOR,
95         INVALID_COLLATERAL_FACTOR,
96         INVALID_LIQUIDATION_INCENTIVE,
97         MARKET_NOT_ENTERED,
98         MARKET_NOT_LISTED,
99         MARKET_ALREADY_LISTED,
100         MATH_ERROR,
101         NONZERO_BORROW_BALANCE,
102         PRICE_ERROR,
103         REJECTION,
104         SNAPSHOT_ERROR,
105         TOO_MANY_ASSETS,
106         TOO_MUCH_REPAY
107     }
108 
109     enum FailureInfo {
110         ACCEPT_ADMIN_PENDING_ADMIN_CHECK,
111         ACCEPT_PENDING_IMPLEMENTATION_ADDRESS_CHECK,
112         EXIT_MARKET_BALANCE_OWED,
113         EXIT_MARKET_REJECTION,
114         SET_CLOSE_FACTOR_OWNER_CHECK,
115         SET_CLOSE_FACTOR_VALIDATION,
116         SET_COLLATERAL_FACTOR_OWNER_CHECK,
117         SET_COLLATERAL_FACTOR_NO_EXISTS,
118         SET_COLLATERAL_FACTOR_VALIDATION,
119         SET_COLLATERAL_FACTOR_WITHOUT_PRICE,
120         SET_IMPLEMENTATION_OWNER_CHECK,
121         SET_LIQUIDATION_INCENTIVE_OWNER_CHECK,
122         SET_LIQUIDATION_INCENTIVE_VALIDATION,
123         SET_MAX_ASSETS_OWNER_CHECK,
124         SET_PENDING_ADMIN_OWNER_CHECK,
125         SET_PENDING_IMPLEMENTATION_OWNER_CHECK,
126         SET_PRICE_ORACLE_OWNER_CHECK,
127         SUPPORT_MARKET_EXISTS,
128         SUPPORT_MARKET_OWNER_CHECK,
129         ZUNUSED
130     }
131 
132     /**
133       * @dev `error` corresponds to enum Error; `info` corresponds to enum FailureInfo, and `detail` is an arbitrary
134       * contract-specific code that enables us to report opaque error codes from upgradeable contracts.
135       **/
136     event Failure(uint error, uint info, uint detail);
137 
138     /**
139       * @dev use this when reporting a known error from the money market or a non-upgradeable collaborator
140       */
141     function fail(Error err, FailureInfo info) internal returns (uint) {
142         emit Failure(uint(err), uint(info), 0);
143 
144         return uint(err);
145     }
146 
147     /**
148       * @dev use this when reporting an opaque error from an upgradeable collaborator contract
149       */
150     function failOpaque(Error err, FailureInfo info, uint opaqueError) internal returns (uint) {
151         emit Failure(uint(err), uint(info), opaqueError);
152 
153         return uint(err);
154     }
155 }
156 
157 contract TokenErrorReporter {
158     enum Error {
159         NO_ERROR,
160         UNAUTHORIZED,
161         BAD_INPUT,
162         COMPTROLLER_REJECTION,
163         COMPTROLLER_CALCULATION_ERROR,
164         INTEREST_RATE_MODEL_ERROR,
165         INVALID_ACCOUNT_PAIR,
166         INVALID_CLOSE_AMOUNT_REQUESTED,
167         INVALID_COLLATERAL_FACTOR,
168         MATH_ERROR,
169         MARKET_NOT_FRESH,
170         MARKET_NOT_LISTED,
171         TOKEN_INSUFFICIENT_ALLOWANCE,
172         TOKEN_INSUFFICIENT_BALANCE,
173         TOKEN_INSUFFICIENT_CASH,
174         TOKEN_TRANSFER_IN_FAILED,
175         TOKEN_TRANSFER_OUT_FAILED
176     }
177 
178     /*
179      * Note: FailureInfo (but not Error) is kept in alphabetical order
180      *       This is because FailureInfo grows significantly faster, and
181      *       the order of Error has some meaning, while the order of FailureInfo
182      *       is entirely arbitrary.
183      */
184     enum FailureInfo {
185         ACCEPT_ADMIN_PENDING_ADMIN_CHECK,
186         ACCRUE_INTEREST_ACCUMULATED_INTEREST_CALCULATION_FAILED,
187         ACCRUE_INTEREST_BORROW_RATE_CALCULATION_FAILED,
188         ACCRUE_INTEREST_NEW_BORROW_INDEX_CALCULATION_FAILED,
189         ACCRUE_INTEREST_NEW_TOTAL_BORROWS_CALCULATION_FAILED,
190         ACCRUE_INTEREST_NEW_TOTAL_RESERVES_CALCULATION_FAILED,
191         ACCRUE_INTEREST_SIMPLE_INTEREST_FACTOR_CALCULATION_FAILED,
192         BORROW_ACCUMULATED_BALANCE_CALCULATION_FAILED,
193         BORROW_ACCRUE_INTEREST_FAILED,
194         BORROW_CASH_NOT_AVAILABLE,
195         BORROW_FRESHNESS_CHECK,
196         BORROW_NEW_TOTAL_BALANCE_CALCULATION_FAILED,
197         BORROW_NEW_ACCOUNT_BORROW_BALANCE_CALCULATION_FAILED,
198         BORROW_MARKET_NOT_LISTED,
199         BORROW_COMPTROLLER_REJECTION,
200         LIQUIDATE_ACCRUE_BORROW_INTEREST_FAILED,
201         LIQUIDATE_ACCRUE_COLLATERAL_INTEREST_FAILED,
202         LIQUIDATE_COLLATERAL_FRESHNESS_CHECK,
203         LIQUIDATE_COMPTROLLER_REJECTION,
204         LIQUIDATE_COMPTROLLER_CALCULATE_AMOUNT_SEIZE_FAILED,
205         LIQUIDATE_CLOSE_AMOUNT_IS_UINT_MAX,
206         LIQUIDATE_CLOSE_AMOUNT_IS_ZERO,
207         LIQUIDATE_FRESHNESS_CHECK,
208         LIQUIDATE_LIQUIDATOR_IS_BORROWER,
209         LIQUIDATE_REPAY_BORROW_FRESH_FAILED,
210         LIQUIDATE_SEIZE_BALANCE_INCREMENT_FAILED,
211         LIQUIDATE_SEIZE_BALANCE_DECREMENT_FAILED,
212         LIQUIDATE_SEIZE_COMPTROLLER_REJECTION,
213         LIQUIDATE_SEIZE_LIQUIDATOR_IS_BORROWER,
214         LIQUIDATE_SEIZE_TOO_MUCH,
215         MINT_ACCRUE_INTEREST_FAILED,
216         MINT_COMPTROLLER_REJECTION,
217         MINT_EXCHANGE_CALCULATION_FAILED,
218         MINT_EXCHANGE_RATE_READ_FAILED,
219         MINT_FRESHNESS_CHECK,
220         MINT_NEW_ACCOUNT_BALANCE_CALCULATION_FAILED,
221         MINT_NEW_TOTAL_SUPPLY_CALCULATION_FAILED,
222         MINT_TRANSFER_IN_FAILED,
223         MINT_TRANSFER_IN_NOT_POSSIBLE,
224         REDEEM_ACCRUE_INTEREST_FAILED,
225         REDEEM_COMPTROLLER_REJECTION,
226         REDEEM_EXCHANGE_TOKENS_CALCULATION_FAILED,
227         REDEEM_EXCHANGE_AMOUNT_CALCULATION_FAILED,
228         REDEEM_EXCHANGE_RATE_READ_FAILED,
229         REDEEM_FRESHNESS_CHECK,
230         REDEEM_NEW_ACCOUNT_BALANCE_CALCULATION_FAILED,
231         REDEEM_NEW_TOTAL_SUPPLY_CALCULATION_FAILED,
232         REDEEM_TRANSFER_OUT_NOT_POSSIBLE,
233         REDUCE_RESERVES_ACCRUE_INTEREST_FAILED,
234         REDUCE_RESERVES_ADMIN_CHECK,
235         REDUCE_RESERVES_CASH_NOT_AVAILABLE,
236         REDUCE_RESERVES_FRESH_CHECK,
237         REDUCE_RESERVES_VALIDATION,
238         REPAY_BEHALF_ACCRUE_INTEREST_FAILED,
239         REPAY_BORROW_ACCRUE_INTEREST_FAILED,
240         REPAY_BORROW_ACCUMULATED_BALANCE_CALCULATION_FAILED,
241         REPAY_BORROW_COMPTROLLER_REJECTION,
242         REPAY_BORROW_FRESHNESS_CHECK,
243         REPAY_BORROW_NEW_ACCOUNT_BORROW_BALANCE_CALCULATION_FAILED,
244         REPAY_BORROW_NEW_TOTAL_BALANCE_CALCULATION_FAILED,
245         REPAY_BORROW_TRANSFER_IN_NOT_POSSIBLE,
246         SET_COLLATERAL_FACTOR_OWNER_CHECK,
247         SET_COLLATERAL_FACTOR_VALIDATION,
248         SET_COMPTROLLER_OWNER_CHECK,
249         SET_INTEREST_RATE_MODEL_ACCRUE_INTEREST_FAILED,
250         SET_INTEREST_RATE_MODEL_FRESH_CHECK,
251         SET_INTEREST_RATE_MODEL_OWNER_CHECK,
252         SET_MAX_ASSETS_OWNER_CHECK,
253         SET_ORACLE_MARKET_NOT_LISTED,
254         SET_PENDING_ADMIN_OWNER_CHECK,
255         SET_RESERVE_FACTOR_ACCRUE_INTEREST_FAILED,
256         SET_RESERVE_FACTOR_ADMIN_CHECK,
257         SET_RESERVE_FACTOR_FRESH_CHECK,
258         SET_RESERVE_FACTOR_BOUNDS_CHECK,
259         TRANSFER_COMPTROLLER_REJECTION,
260         TRANSFER_NOT_ALLOWED,
261         TRANSFER_NOT_ENOUGH,
262         TRANSFER_TOO_MUCH
263     }
264 
265     /**
266       * @dev `error` corresponds to enum Error; `info` corresponds to enum FailureInfo, and `detail` is an arbitrary
267       * contract-specific code that enables us to report opaque error codes from upgradeable contracts.
268       **/
269     event Failure(uint error, uint info, uint detail);
270 
271     /**
272       * @dev use this when reporting a known error from the money market or a non-upgradeable collaborator
273       */
274     function fail(Error err, FailureInfo info) internal returns (uint) {
275         emit Failure(uint(err), uint(info), 0);
276 
277         return uint(err);
278     }
279 
280     /**
281       * @dev use this when reporting an opaque error from an upgradeable collaborator contract
282       */
283     function failOpaque(Error err, FailureInfo info, uint opaqueError) internal returns (uint) {
284         emit Failure(uint(err), uint(info), opaqueError);
285 
286         return uint(err);
287     }
288 }
289 
290 // File: contracts/CarefulMath.sol
291 
292 pragma solidity ^0.5.8;
293 
294 /**
295   * @title Careful Math
296   * @author Compound
297   * @notice Derived from OpenZeppelin's SafeMath library
298   *         https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/math/SafeMath.sol
299   */
300 contract CarefulMath {
301 
302     /**
303      * @dev Possible error codes that we can return
304      */
305     enum MathError {
306         NO_ERROR,
307         DIVISION_BY_ZERO,
308         INTEGER_OVERFLOW,
309         INTEGER_UNDERFLOW
310     }
311 
312     /**
313     * @dev Multiplies two numbers, returns an error on overflow.
314     */
315     function mulUInt(uint a, uint b) internal pure returns (MathError, uint) {
316         if (a == 0) {
317             return (MathError.NO_ERROR, 0);
318         }
319 
320         uint c = a * b;
321 
322         if (c / a != b) {
323             return (MathError.INTEGER_OVERFLOW, 0);
324         } else {
325             return (MathError.NO_ERROR, c);
326         }
327     }
328 
329     /**
330     * @dev Integer division of two numbers, truncating the quotient.
331     */
332     function divUInt(uint a, uint b) internal pure returns (MathError, uint) {
333         if (b == 0) {
334             return (MathError.DIVISION_BY_ZERO, 0);
335         }
336 
337         return (MathError.NO_ERROR, a / b);
338     }
339 
340     /**
341     * @dev Subtracts two numbers, returns an error on overflow (i.e. if subtrahend is greater than minuend).
342     */
343     function subUInt(uint a, uint b) internal pure returns (MathError, uint) {
344         if (b <= a) {
345             return (MathError.NO_ERROR, a - b);
346         } else {
347             return (MathError.INTEGER_UNDERFLOW, 0);
348         }
349     }
350 
351     /**
352     * @dev Adds two numbers, returns an error on overflow.
353     */
354     function addUInt(uint a, uint b) internal pure returns (MathError, uint) {
355         uint c = a + b;
356 
357         if (c >= a) {
358             return (MathError.NO_ERROR, c);
359         } else {
360             return (MathError.INTEGER_OVERFLOW, 0);
361         }
362     }
363 
364     /**
365     * @dev add a and b and then subtract c
366     */
367     function addThenSubUInt(uint a, uint b, uint c) internal pure returns (MathError, uint) {
368         (MathError err0, uint sum) = addUInt(a, b);
369 
370         if (err0 != MathError.NO_ERROR) {
371             return (err0, 0);
372         }
373 
374         return subUInt(sum, c);
375     }
376 }
377 
378 // File: contracts/Exponential.sol
379 
380 pragma solidity ^0.5.8;
381 
382 
383 /**
384  * @title Exponential module for storing fixed-decision decimals
385  * @author Compound
386  * @notice Exp is a struct which stores decimals with a fixed precision of 18 decimal places.
387  *         Thus, if we wanted to store the 5.1, mantissa would store 5.1e18. That is:
388  *         `Exp({mantissa: 5100000000000000000})`.
389  */
390 contract Exponential is CarefulMath {
391     uint constant expScale = 1e18;
392     uint constant halfExpScale = expScale/2;
393     uint constant mantissaOne = expScale;
394 
395     struct Exp {
396         uint mantissa;
397     }
398 
399     /**
400      * @dev Creates an exponential from numerator and denominator values.
401      *      Note: Returns an error if (`num` * 10e18) > MAX_INT,
402      *            or if `denom` is zero.
403      */
404     function getExp(uint num, uint denom) pure internal returns (MathError, Exp memory) {
405         (MathError err0, uint scaledNumerator) = mulUInt(num, expScale);
406         if (err0 != MathError.NO_ERROR) {
407             return (err0, Exp({mantissa: 0}));
408         }
409 
410         (MathError err1, uint rational) = divUInt(scaledNumerator, denom);
411         if (err1 != MathError.NO_ERROR) {
412             return (err1, Exp({mantissa: 0}));
413         }
414 
415         return (MathError.NO_ERROR, Exp({mantissa: rational}));
416     }
417 
418     /**
419      * @dev Adds two exponentials, returning a new exponential.
420      */
421     function addExp(Exp memory a, Exp memory b) pure internal returns (MathError, Exp memory) {
422         (MathError error, uint result) = addUInt(a.mantissa, b.mantissa);
423 
424         return (error, Exp({mantissa: result}));
425     }
426 
427     /**
428      * @dev Subtracts two exponentials, returning a new exponential.
429      */
430     function subExp(Exp memory a, Exp memory b) pure internal returns (MathError, Exp memory) {
431         (MathError error, uint result) = subUInt(a.mantissa, b.mantissa);
432 
433         return (error, Exp({mantissa: result}));
434     }
435 
436     /**
437      * @dev Multiply an Exp by a scalar, returning a new Exp.
438      */
439     function mulScalar(Exp memory a, uint scalar) pure internal returns (MathError, Exp memory) {
440         (MathError err0, uint scaledMantissa) = mulUInt(a.mantissa, scalar);
441         if (err0 != MathError.NO_ERROR) {
442             return (err0, Exp({mantissa: 0}));
443         }
444 
445         return (MathError.NO_ERROR, Exp({mantissa: scaledMantissa}));
446     }
447 
448     /**
449      * @dev Multiply an Exp by a scalar, then truncate to return an unsigned integer.
450      */
451     function mulScalarTruncate(Exp memory a, uint scalar) pure internal returns (MathError, uint) {
452         (MathError err, Exp memory product) = mulScalar(a, scalar);
453         if (err != MathError.NO_ERROR) {
454             return (err, 0);
455         }
456 
457         return (MathError.NO_ERROR, truncate(product));
458     }
459 
460     /**
461      * @dev Multiply an Exp by a scalar, truncate, then add an to an unsigned integer, returning an unsigned integer.
462      */
463     function mulScalarTruncateAddUInt(Exp memory a, uint scalar, uint addend) pure internal returns (MathError, uint) {
464         (MathError err, Exp memory product) = mulScalar(a, scalar);
465         if (err != MathError.NO_ERROR) {
466             return (err, 0);
467         }
468 
469         return addUInt(truncate(product), addend);
470     }
471 
472     /**
473      * @dev Divide an Exp by a scalar, returning a new Exp.
474      */
475     function divScalar(Exp memory a, uint scalar) pure internal returns (MathError, Exp memory) {
476         (MathError err0, uint descaledMantissa) = divUInt(a.mantissa, scalar);
477         if (err0 != MathError.NO_ERROR) {
478             return (err0, Exp({mantissa: 0}));
479         }
480 
481         return (MathError.NO_ERROR, Exp({mantissa: descaledMantissa}));
482     }
483 
484     /**
485      * @dev Divide a scalar by an Exp, returning a new Exp.
486      */
487     function divScalarByExp(uint scalar, Exp memory divisor) pure internal returns (MathError, Exp memory) {
488         /*
489           We are doing this as:
490           getExp(mulUInt(expScale, scalar), divisor.mantissa)
491 
492           How it works:
493           Exp = a / b;
494           Scalar = s;
495           `s / (a / b)` = `b * s / a` and since for an Exp `a = mantissa, b = expScale`
496         */
497         (MathError err0, uint numerator) = mulUInt(expScale, scalar);
498         if (err0 != MathError.NO_ERROR) {
499             return (err0, Exp({mantissa: 0}));
500         }
501         return getExp(numerator, divisor.mantissa);
502     }
503 
504     /**
505      * @dev Divide a scalar by an Exp, then truncate to return an unsigned integer.
506      */
507     function divScalarByExpTruncate(uint scalar, Exp memory divisor) pure internal returns (MathError, uint) {
508         (MathError err, Exp memory fraction) = divScalarByExp(scalar, divisor);
509         if (err != MathError.NO_ERROR) {
510             return (err, 0);
511         }
512 
513         return (MathError.NO_ERROR, truncate(fraction));
514     }
515 
516     /**
517      * @dev Multiplies two exponentials, returning a new exponential.
518      */
519     function mulExp(Exp memory a, Exp memory b) pure internal returns (MathError, Exp memory) {
520 
521         (MathError err0, uint doubleScaledProduct) = mulUInt(a.mantissa, b.mantissa);
522         if (err0 != MathError.NO_ERROR) {
523             return (err0, Exp({mantissa: 0}));
524         }
525 
526         // We add half the scale before dividing so that we get rounding instead of truncation.
527         //  See "Listing 6" and text above it at https://accu.org/index.php/journals/1717
528         // Without this change, a result like 6.6...e-19 will be truncated to 0 instead of being rounded to 1e-18.
529         (MathError err1, uint doubleScaledProductWithHalfScale) = addUInt(halfExpScale, doubleScaledProduct);
530         if (err1 != MathError.NO_ERROR) {
531             return (err1, Exp({mantissa: 0}));
532         }
533 
534         (MathError err2, uint product) = divUInt(doubleScaledProductWithHalfScale, expScale);
535         // The only error `div` can return is MathError.DIVISION_BY_ZERO but we control `expScale` and it is not zero.
536         assert(err2 == MathError.NO_ERROR);
537 
538         return (MathError.NO_ERROR, Exp({mantissa: product}));
539     }
540 
541     /**
542      * @dev Multiplies two exponentials given their mantissas, returning a new exponential.
543      */
544     function mulExp(uint a, uint b) pure internal returns (MathError, Exp memory) {
545         return mulExp(Exp({mantissa: a}), Exp({mantissa: b}));
546     }
547 
548     /**
549      * @dev Multiplies three exponentials, returning a new exponential.
550      */
551     function mulExp3(Exp memory a, Exp memory b, Exp memory c) pure internal returns (MathError, Exp memory) {
552         (MathError err, Exp memory ab) = mulExp(a, b);
553         if (err != MathError.NO_ERROR) {
554             return (err, ab);
555         }
556         return mulExp(ab, c);
557     }
558 
559     /**
560      * @dev Divides two exponentials, returning a new exponential.
561      *     (a/scale) / (b/scale) = (a/scale) * (scale/b) = a/b,
562      *  which we can scale as an Exp by calling getExp(a.mantissa, b.mantissa)
563      */
564     function divExp(Exp memory a, Exp memory b) pure internal returns (MathError, Exp memory) {
565         return getExp(a.mantissa, b.mantissa);
566     }
567 
568     /**
569      * @dev Truncates the given exp to a whole number value.
570      *      For example, truncate(Exp{mantissa: 15 * expScale}) = 15
571      */
572     function truncate(Exp memory exp) pure internal returns (uint) {
573         // Note: We are not using careful math here as we're performing a division that cannot fail
574         return exp.mantissa / expScale;
575     }
576 
577     /**
578      * @dev Checks if first Exp is less than second Exp.
579      */
580     function lessThanExp(Exp memory left, Exp memory right) pure internal returns (bool) {
581         return left.mantissa < right.mantissa; //TODO: Add some simple tests and this in another PR yo.
582     }
583 
584     /**
585      * @dev Checks if left Exp <= right Exp.
586      */
587     function lessThanOrEqualExp(Exp memory left, Exp memory right) pure internal returns (bool) {
588         return left.mantissa <= right.mantissa;
589     }
590 
591     /**
592      * @dev returns true if Exp is exactly zero
593      */
594     function isZeroExp(Exp memory value) pure internal returns (bool) {
595         return value.mantissa == 0;
596     }
597 }
598 
599 // File: contracts/EIP20Interface.sol
600 
601 pragma solidity ^0.5.8;
602 
603 /**
604  * @title ERC 20 Token Standard Interface
605  *  https://eips.ethereum.org/EIPS/eip-20
606  */
607 interface EIP20Interface {
608 
609     /**
610       * @notice Get the total number of tokens in circulation
611       * @return The supply of tokens
612       */
613     function totalSupply() external view returns (uint256);
614 
615     /**
616      * @notice Gets the balance of the specified address
617      * @param owner The address from which the balance will be retrieved
618      * @return The balance
619      */
620     function balanceOf(address owner) external view returns (uint256 balance);
621 
622     /**
623       * @notice Transfer `amount` tokens from `msg.sender` to `dst`
624       * @param dst The address of the destination account
625       * @param amount The number of tokens to transfer
626       * @return Whether or not the transfer succeeded
627       */
628     function transfer(address dst, uint256 amount) external returns (bool success);
629 
630     /**
631       * @notice Transfer `amount` tokens from `src` to `dst`
632       * @param src The address of the source account
633       * @param dst The address of the destination account
634       * @param amount The number of tokens to transfer
635       * @return Whether or not the transfer succeeded
636       */
637     function transferFrom(address src, address dst, uint256 amount) external returns (bool success);
638 
639     /**
640       * @notice Approve `spender` to transfer up to `amount` from `src`
641       * @dev This will overwrite the approval amount for `spender`
642       *  and is subject to issues noted [here](https://eips.ethereum.org/EIPS/eip-20#approve)
643       * @param spender The address of the account which may transfer tokens
644       * @param amount The number of tokens that are approved (-1 means infinite)
645       * @return Whether or not the approval succeeded
646       */
647     function approve(address spender, uint256 amount) external returns (bool success);
648 
649     /**
650       * @notice Get the current allowance from `owner` for `spender`
651       * @param owner The address of the account which owns the tokens to be spent
652       * @param spender The address of the account which may transfer tokens
653       * @return The number of tokens allowed to be spent (-1 means infinite)
654       */
655     function allowance(address owner, address spender) external view returns (uint256 remaining);
656 
657     event Transfer(address indexed from, address indexed to, uint256 amount);
658     event Approval(address indexed owner, address indexed spender, uint256 amount);
659 }
660 
661 // File: contracts/EIP20NonStandardInterface.sol
662 
663 pragma solidity ^0.5.8;
664 
665 /**
666  * @title EIP20NonStandardInterface
667  * @dev Version of ERC20 with no return values for `transfer` and `transferFrom`
668  *  See https://medium.com/coinmonks/missing-return-value-bug-at-least-130-tokens-affected-d67bf08521ca
669  */
670 interface EIP20NonStandardInterface {
671 
672     /**
673      * @notice Get the total number of tokens in circulation
674      * @return The supply of tokens
675      */
676     function totalSupply() external view returns (uint256);
677 
678     /**
679      * @notice Gets the balance of the specified address
680      * @param owner The address from which the balance will be retrieved
681      * @return The balance
682      */
683     function balanceOf(address owner) external view returns (uint256 balance);
684 
685     ///
686     /// !!!!!!!!!!!!!!
687     /// !!! NOTICE !!! `transfer` does not return a value, in violation of the ERC-20 specification
688     /// !!!!!!!!!!!!!!
689     ///
690 
691     /**
692       * @notice Transfer `amount` tokens from `msg.sender` to `dst`
693       * @param dst The address of the destination account
694       * @param amount The number of tokens to transfer
695       */
696     function transfer(address dst, uint256 amount) external;
697 
698     ///
699     /// !!!!!!!!!!!!!!
700     /// !!! NOTICE !!! `transferFrom` does not return a value, in violation of the ERC-20 specification
701     /// !!!!!!!!!!!!!!
702     ///
703 
704     /**
705       * @notice Transfer `amount` tokens from `src` to `dst`
706       * @param src The address of the source account
707       * @param dst The address of the destination account
708       * @param amount The number of tokens to transfer
709       */
710     function transferFrom(address src, address dst, uint256 amount) external;
711 
712     /**
713       * @notice Approve `spender` to transfer up to `amount` from `src`
714       * @dev This will overwrite the approval amount for `spender`
715       *  and is subject to issues noted [here](https://eips.ethereum.org/EIPS/eip-20#approve)
716       * @param spender The address of the account which may transfer tokens
717       * @param amount The number of tokens that are approved
718       * @return Whether or not the approval succeeded
719       */
720     function approve(address spender, uint256 amount) external returns (bool success);
721 
722     /**
723       * @notice Get the current allowance from `owner` for `spender`
724       * @param owner The address of the account which owns the tokens to be spent
725       * @param spender The address of the account which may transfer tokens
726       * @return The number of tokens allowed to be spent
727       */
728     function allowance(address owner, address spender) external view returns (uint256 remaining);
729 
730     event Transfer(address indexed from, address indexed to, uint256 amount);
731     event Approval(address indexed owner, address indexed spender, uint256 amount);
732 }
733 
734 // File: contracts/ReentrancyGuard.sol
735 
736 pragma solidity ^0.5.8;
737 
738 /**
739  * @title Helps contracts guard against reentrancy attacks.
740  * @author Remco Bloemen <remco@2π.com>, Eenae <alexey@mixbytes.io>
741  * @dev If you mark a function `nonReentrant`, you should also
742  * mark it `external`.
743  */
744 contract ReentrancyGuard {
745     /// @dev counter to allow mutex lock with only one SSTORE operation
746     uint256 private _guardCounter;
747 
748     constructor () internal {
749         // The counter starts at one to prevent changing it from zero to a non-zero
750         // value, which is a more expensive operation.
751         _guardCounter = 1;
752     }
753 
754     /**
755      * @dev Prevents a contract from calling itself, directly or indirectly.
756      * Calling a `nonReentrant` function from another `nonReentrant`
757      * function is not supported. It is possible to prevent this from happening
758      * by making the `nonReentrant` function external, and make it call a
759      * `private` function that does the actual work.
760      */
761     modifier nonReentrant() {
762         _guardCounter += 1;
763         uint256 localCounter = _guardCounter;
764         _;
765         require(localCounter == _guardCounter, "re-entered");
766     }
767 }
768 
769 // File: contracts/InterestRateModel.sol
770 
771 pragma solidity ^0.5.8;
772 
773 /**
774   * @title The Compound InterestRateModel Interface
775   * @author Compound
776   * @notice Any interest rate model should derive from this contract.
777   * @dev These functions are specifically not marked `pure` as implementations of this
778   *      contract may read from storage variables.
779   */
780 interface InterestRateModel {
781     /**
782       * @notice Gets the current borrow interest rate based on the given asset, total cash, total borrows
783       *         and total reserves.
784       * @dev The return value should be scaled by 1e18, thus a return value of
785       *      `(true, 1000000000000)` implies an interest rate of 0.000001 or 0.0001% *per block*.
786       * @param cash The total cash of the underlying asset in the CToken
787       * @param borrows The total borrows of the underlying asset in the CToken
788       * @param reserves The total reserves of the underlying asset in the CToken
789       * @return Success or failure and the borrow interest rate per block scaled by 10e18
790       */
791     function getBorrowRate(uint cash, uint borrows, uint reserves) external view returns (uint, uint);
792 
793     /**
794       * @notice Marker function used for light validation when updating the interest rate model of a market
795       * @dev Marker function used for light validation when updating the interest rate model of a market. Implementations should simply return true.
796       * @return Success or failure
797       */
798     function isInterestRateModel() external view returns (bool);
799 }
800 
801 // File: contracts/CToken.sol
802 
803 pragma solidity ^0.5.8;
804 
805 
806 
807 
808 
809 
810 
811 
812 /**
813  * @title Compound's CToken Contract
814  * @notice Abstract base for CTokens
815  * @author Compound
816  */
817 contract CToken is EIP20Interface, Exponential, TokenErrorReporter, ReentrancyGuard {
818     /**
819      * @notice Indicator that this is a CToken contract (for inspection)
820      */
821     bool public constant isCToken = true;
822 
823     /**
824      * @notice EIP-20 token name for this token
825      */
826     string public name;
827 
828     /**
829      * @notice EIP-20 token symbol for this token
830      */
831     string public symbol;
832 
833     /**
834      * @notice EIP-20 token decimals for this token
835      */
836     uint public decimals;
837 
838     /**
839      * @notice Maximum borrow rate that can ever be applied (.0005% / block)
840      */
841     uint constant borrowRateMaxMantissa = 5e14;
842 
843     /**
844      * @notice Maximum fraction of interest that can be set aside for reserves
845      */
846     uint constant reserveFactorMaxMantissa = 1e18;
847 
848     /**
849      * @notice Administrator for this contract
850      */
851     address payable public admin;
852 
853     /**
854      * @notice Pending administrator for this contract
855      */
856     address payable public pendingAdmin;
857 
858     /**
859      * @notice Contract which oversees inter-cToken operations
860      */
861     ComptrollerInterface public comptroller;
862 
863     /**
864      * @notice Model which tells what the current interest rate should be
865      */
866     InterestRateModel public interestRateModel;
867 
868     /**
869      * @notice Initial exchange rate used when minting the first CTokens (used when totalSupply = 0)
870      */
871     uint public initialExchangeRateMantissa;
872 
873     /**
874      * @notice Fraction of interest currently set aside for reserves
875      */
876     uint public reserveFactorMantissa;
877 
878     /**
879      * @notice Block number that interest was last accrued at
880      */
881     uint public accrualBlockNumber;
882 
883     /**
884      * @notice Accumulator of total earned interest since the opening of the market
885      */
886     uint public borrowIndex;
887 
888     /**
889      * @notice Total amount of outstanding borrows of the underlying in this market
890      */
891     uint public totalBorrows;
892 
893     /**
894      * @notice Total amount of reserves of the underlying held in this market
895      */
896     uint public totalReserves;
897 
898     /**
899      * @notice Total number of tokens in circulation
900      */
901     uint256 public totalSupply;
902 
903     /**
904      * @notice Official record of token balances for each account
905      */
906     mapping (address => uint256) accountTokens;
907 
908     /**
909      * @notice Approved token transfer amounts on behalf of others
910      */
911     mapping (address => mapping (address => uint256)) transferAllowances;
912 
913     /**
914      * @notice Container for borrow balance information
915      * @member principal Total balance (with accrued interest), after applying the most recent balance-changing action
916      * @member interestIndex Global borrowIndex as of the most recent balance-changing action
917      */
918     struct BorrowSnapshot {
919         uint principal;
920         uint interestIndex;
921     }
922 
923     /**
924      * @notice Mapping of account addresses to outstanding borrow balances
925      */
926     mapping(address => BorrowSnapshot) accountBorrows;
927 
928 
929     /*** Market Events ***/
930 
931     /**
932      * @notice Event emitted when interest is accrued
933      */
934     event AccrueInterest(uint interestAccumulated, uint borrowIndex, uint totalBorrows);
935 
936     /**
937      * @notice Event emitted when tokens are minted
938      */
939     event Mint(address minter, uint mintAmount, uint mintTokens);
940 
941     /**
942      * @notice Event emitted when tokens are redeemed
943      */
944     event Redeem(address redeemer, uint redeemAmount, uint redeemTokens);
945 
946     /**
947      * @notice Event emitted when underlying is borrowed
948      */
949     event Borrow(address borrower, uint borrowAmount, uint accountBorrows, uint totalBorrows);
950 
951     /**
952      * @notice Event emitted when a borrow is repaid
953      */
954     event RepayBorrow(address payer, address borrower, uint repayAmount, uint accountBorrows, uint totalBorrows);
955 
956     /**
957      * @notice Event emitted when a borrow is liquidated
958      */
959     event LiquidateBorrow(address liquidator, address borrower, uint repayAmount, address cTokenCollateral, uint seizeTokens);
960 
961 
962     /*** Admin Events ***/
963 
964     /**
965      * @notice Event emitted when pendingAdmin is changed
966      */
967     event NewPendingAdmin(address oldPendingAdmin, address newPendingAdmin);
968 
969     /**
970      * @notice Event emitted when pendingAdmin is accepted, which means admin is updated
971      */
972     event NewAdmin(address oldAdmin, address newAdmin);
973 
974     /**
975      * @notice Event emitted when comptroller is changed
976      */
977     event NewComptroller(ComptrollerInterface oldComptroller, ComptrollerInterface newComptroller);
978 
979     /**
980      * @notice Event emitted when interestRateModel is changed
981      */
982     event NewMarketInterestRateModel(InterestRateModel oldInterestRateModel, InterestRateModel newInterestRateModel);
983 
984     /**
985      * @notice Event emitted when the reserve factor is changed
986      */
987     event NewReserveFactor(uint oldReserveFactorMantissa, uint newReserveFactorMantissa);
988 
989     /**
990      * @notice Event emitted when the reserves are reduced
991      */
992     event ReservesReduced(address admin, uint reduceAmount, uint newTotalReserves);
993 
994 
995     /**
996      * @notice Construct a new money market
997      * @param comptroller_ The address of the Comptroller
998      * @param interestRateModel_ The address of the interest rate model
999      * @param initialExchangeRateMantissa_ The initial exchange rate, scaled by 1e18
1000      * @param name_ EIP-20 name of this token
1001      * @param symbol_ EIP-20 symbol of this token
1002      * @param decimals_ EIP-20 decimal precision of this token
1003      */
1004     constructor(ComptrollerInterface comptroller_,
1005                 InterestRateModel interestRateModel_,
1006                 uint initialExchangeRateMantissa_,
1007                 string memory name_,
1008                 string memory symbol_,
1009                 uint decimals_) internal {
1010         // Set admin to msg.sender
1011         admin = msg.sender;
1012 
1013         // Set initial exchange rate
1014         initialExchangeRateMantissa = initialExchangeRateMantissa_;
1015         require(initialExchangeRateMantissa > 0, "Initial exchange rate must be greater than zero.");
1016 
1017         // Set the comptroller
1018         uint err = _setComptroller(comptroller_);
1019         require(err == uint(Error.NO_ERROR), "Setting comptroller failed");
1020 
1021         // Initialize block number and borrow index (block number mocks depend on comptroller being set)
1022         accrualBlockNumber = getBlockNumber();
1023         borrowIndex = mantissaOne;
1024 
1025         // Set the interest rate model (depends on block number / borrow index)
1026         err = _setInterestRateModelFresh(interestRateModel_);
1027         require(err == uint(Error.NO_ERROR), "Setting interest rate model failed");
1028 
1029         name = name_;
1030         symbol = symbol_;
1031         decimals = decimals_;
1032     }
1033 
1034     /**
1035      * @notice Transfer `tokens` tokens from `src` to `dst` by `spender`
1036      * @dev Called by both `transfer` and `transferFrom` internally
1037      * @param spender The address of the account performing the transfer
1038      * @param src The address of the source account
1039      * @param dst The address of the destination account
1040      * @param tokens The number of tokens to transfer
1041      * @return Whether or not the transfer succeeded
1042      */
1043     function transferTokens(address spender, address src, address dst, uint tokens) internal returns (uint) {
1044         /* Fail if transfer not allowed */
1045         uint allowed = comptroller.transferAllowed(address(this), src, dst, tokens);
1046         if (allowed != 0) {
1047             return failOpaque(Error.COMPTROLLER_REJECTION, FailureInfo.TRANSFER_COMPTROLLER_REJECTION, allowed);
1048         }
1049 
1050         /* Do not allow self-transfers */
1051         if (src == dst) {
1052             return fail(Error.BAD_INPUT, FailureInfo.TRANSFER_NOT_ALLOWED);
1053         }
1054 
1055         /* Get the allowance, infinite for the account owner */
1056         uint startingAllowance = 0;
1057         if (spender == src) {
1058             startingAllowance = uint(-1);
1059         } else {
1060             startingAllowance = transferAllowances[src][spender];
1061         }
1062 
1063         /* Do the calculations, checking for {under,over}flow */
1064         MathError mathErr;
1065         uint allowanceNew;
1066         uint srcTokensNew;
1067         uint dstTokensNew;
1068 
1069         (mathErr, allowanceNew) = subUInt(startingAllowance, tokens);
1070         if (mathErr != MathError.NO_ERROR) {
1071             return fail(Error.MATH_ERROR, FailureInfo.TRANSFER_NOT_ALLOWED);
1072         }
1073 
1074         (mathErr, srcTokensNew) = subUInt(accountTokens[src], tokens);
1075         if (mathErr != MathError.NO_ERROR) {
1076             return fail(Error.MATH_ERROR, FailureInfo.TRANSFER_NOT_ENOUGH);
1077         }
1078 
1079         (mathErr, dstTokensNew) = addUInt(accountTokens[dst], tokens);
1080         if (mathErr != MathError.NO_ERROR) {
1081             return fail(Error.MATH_ERROR, FailureInfo.TRANSFER_TOO_MUCH);
1082         }
1083 
1084         /////////////////////////
1085         // EFFECTS & INTERACTIONS
1086         // (No safe failures beyond this point)
1087 
1088         accountTokens[src] = srcTokensNew;
1089         accountTokens[dst] = dstTokensNew;
1090 
1091         /* Eat some of the allowance (if necessary) */
1092         if (startingAllowance != uint(-1)) {
1093             transferAllowances[src][spender] = allowanceNew;
1094         }
1095 
1096         /* We emit a Transfer event */
1097         emit Transfer(src, dst, tokens);
1098 
1099         /* We call the defense hook (which checks for under-collateralization) */
1100         comptroller.transferVerify(address(this), src, dst, tokens);
1101 
1102         return uint(Error.NO_ERROR);
1103     }
1104 
1105     /**
1106      * @notice Transfer `amount` tokens from `msg.sender` to `dst`
1107      * @param dst The address of the destination account
1108      * @param amount The number of tokens to transfer
1109      * @return Whether or not the transfer succeeded
1110      */
1111     function transfer(address dst, uint256 amount) external nonReentrant returns (bool) {
1112         return transferTokens(msg.sender, msg.sender, dst, amount) == uint(Error.NO_ERROR);
1113     }
1114 
1115     /**
1116      * @notice Transfer `amount` tokens from `src` to `dst`
1117      * @param src The address of the source account
1118      * @param dst The address of the destination account
1119      * @param amount The number of tokens to transfer
1120      * @return Whether or not the transfer succeeded
1121      */
1122     function transferFrom(address src, address dst, uint256 amount) external nonReentrant returns (bool) {
1123         return transferTokens(msg.sender, src, dst, amount) == uint(Error.NO_ERROR);
1124     }
1125 
1126     /**
1127      * @notice Approve `spender` to transfer up to `amount` from `src`
1128      * @dev This will overwrite the approval amount for `spender`
1129      *  and is subject to issues noted [here](https://eips.ethereum.org/EIPS/eip-20#approve)
1130      * @param spender The address of the account which may transfer tokens
1131      * @param amount The number of tokens that are approved (-1 means infinite)
1132      * @return Whether or not the approval succeeded
1133      */
1134     function approve(address spender, uint256 amount) external returns (bool) {
1135         address src = msg.sender;
1136         transferAllowances[src][spender] = amount;
1137         emit Approval(src, spender, amount);
1138         return true;
1139     }
1140 
1141     /**
1142      * @notice Get the current allowance from `owner` for `spender`
1143      * @param owner The address of the account which owns the tokens to be spent
1144      * @param spender The address of the account which may transfer tokens
1145      * @return The number of tokens allowed to be spent (-1 means infinite)
1146      */
1147     function allowance(address owner, address spender) external view returns (uint256) {
1148         return transferAllowances[owner][spender];
1149     }
1150 
1151     /**
1152      * @notice Get the token balance of the `owner`
1153      * @param owner The address of the account to query
1154      * @return The number of tokens owned by `owner`
1155      */
1156     function balanceOf(address owner) external view returns (uint256) {
1157         return accountTokens[owner];
1158     }
1159 
1160     /**
1161      * @notice Get the underlying balance of the `owner`
1162      * @dev This also accrues interest in a transaction
1163      * @param owner The address of the account to query
1164      * @return The amount of underlying owned by `owner`
1165      */
1166     function balanceOfUnderlying(address owner) external returns (uint) {
1167         Exp memory exchangeRate = Exp({mantissa: exchangeRateCurrent()});
1168         (MathError mErr, uint balance) = mulScalarTruncate(exchangeRate, accountTokens[owner]);
1169         require(mErr == MathError.NO_ERROR);
1170         return balance;
1171     }
1172 
1173     /**
1174      * @notice Get a snapshot of the account's balances, and the cached exchange rate
1175      * @dev This is used by comptroller to more efficiently perform liquidity checks.
1176      * @param account Address of the account to snapshot
1177      * @return (possible error, token balance, borrow balance, exchange rate mantissa)
1178      */
1179     function getAccountSnapshot(address account) external view returns (uint, uint, uint, uint) {
1180         uint cTokenBalance = accountTokens[account];
1181         uint borrowBalance;
1182         uint exchangeRateMantissa;
1183 
1184         MathError mErr;
1185 
1186         (mErr, borrowBalance) = borrowBalanceStoredInternal(account);
1187         if (mErr != MathError.NO_ERROR) {
1188             return (uint(Error.MATH_ERROR), 0, 0, 0);
1189         }
1190 
1191         (mErr, exchangeRateMantissa) = exchangeRateStoredInternal();
1192         if (mErr != MathError.NO_ERROR) {
1193             return (uint(Error.MATH_ERROR), 0, 0, 0);
1194         }
1195 
1196         return (uint(Error.NO_ERROR), cTokenBalance, borrowBalance, exchangeRateMantissa);
1197     }
1198 
1199     /**
1200      * @dev Function to simply retrieve block number
1201      *  This exists mainly for inheriting test contracts to stub this result.
1202      */
1203     function getBlockNumber() internal view returns (uint) {
1204         return block.number;
1205     }
1206 
1207     /**
1208      * @notice Returns the current per-block borrow interest rate for this cToken
1209      * @return The borrow interest rate per block, scaled by 1e18
1210      */
1211     function borrowRatePerBlock() external view returns (uint) {
1212         (uint opaqueErr, uint borrowRateMantissa) = interestRateModel.getBorrowRate(getCashPrior(), totalBorrows, totalReserves);
1213         require(opaqueErr == 0, "borrowRatePerBlock: interestRateModel.borrowRate failed"); // semi-opaque
1214         return borrowRateMantissa;
1215     }
1216 
1217     /**
1218      * @notice Returns the current per-block supply interest rate for this cToken
1219      * @return The supply interest rate per block, scaled by 1e18
1220      */
1221     function supplyRatePerBlock() external view returns (uint) {
1222         /* We calculate the supply rate:
1223          *  underlying = totalSupply × exchangeRate
1224          *  borrowsPer = totalBorrows ÷ underlying
1225          *  supplyRate = borrowRate × (1-reserveFactor) × borrowsPer
1226          */
1227         uint exchangeRateMantissa = exchangeRateStored();
1228 
1229         (uint e0, uint borrowRateMantissa) = interestRateModel.getBorrowRate(getCashPrior(), totalBorrows, totalReserves);
1230         require(e0 == 0, "supplyRatePerBlock: calculating borrowRate failed"); // semi-opaque
1231 
1232         (MathError e1, Exp memory underlying) = mulScalar(Exp({mantissa: exchangeRateMantissa}), totalSupply);
1233         require(e1 == MathError.NO_ERROR, "supplyRatePerBlock: calculating underlying failed");
1234 
1235         (MathError e2, Exp memory borrowsPer) = divScalarByExp(totalBorrows, underlying);
1236         require(e2 == MathError.NO_ERROR, "supplyRatePerBlock: calculating borrowsPer failed");
1237 
1238         (MathError e3, Exp memory oneMinusReserveFactor) = subExp(Exp({mantissa: mantissaOne}), Exp({mantissa: reserveFactorMantissa}));
1239         require(e3 == MathError.NO_ERROR, "supplyRatePerBlock: calculating oneMinusReserveFactor failed");
1240 
1241         (MathError e4, Exp memory supplyRate) = mulExp3(Exp({mantissa: borrowRateMantissa}), oneMinusReserveFactor, borrowsPer);
1242         require(e4 == MathError.NO_ERROR, "supplyRatePerBlock: calculating supplyRate failed");
1243 
1244         return supplyRate.mantissa;
1245     }
1246 
1247     /**
1248      * @notice Returns the current total borrows plus accrued interest
1249      * @return The total borrows with interest
1250      */
1251     function totalBorrowsCurrent() external nonReentrant returns (uint) {
1252         require(accrueInterest() == uint(Error.NO_ERROR), "accrue interest failed");
1253         return totalBorrows;
1254     }
1255 
1256     /**
1257      * @notice Accrue interest to updated borrowIndex and then calculate account's borrow balance using the updated borrowIndex
1258      * @param account The address whose balance should be calculated after updating borrowIndex
1259      * @return The calculated balance
1260      */
1261     function borrowBalanceCurrent(address account) external nonReentrant returns (uint) {
1262         require(accrueInterest() == uint(Error.NO_ERROR), "accrue interest failed");
1263         return borrowBalanceStored(account);
1264     }
1265 
1266     /**
1267      * @notice Return the borrow balance of account based on stored data
1268      * @param account The address whose balance should be calculated
1269      * @return The calculated balance
1270      */
1271     function borrowBalanceStored(address account) public view returns (uint) {
1272         (MathError err, uint result) = borrowBalanceStoredInternal(account);
1273         require(err == MathError.NO_ERROR, "borrowBalanceStored: borrowBalanceStoredInternal failed");
1274         return result;
1275     }
1276 
1277     /**
1278      * @notice Return the borrow balance of account based on stored data
1279      * @param account The address whose balance should be calculated
1280      * @return (error code, the calculated balance or 0 if error code is non-zero)
1281      */
1282     function borrowBalanceStoredInternal(address account) internal view returns (MathError, uint) {
1283         /* Note: we do not assert that the market is up to date */
1284         MathError mathErr;
1285         uint principalTimesIndex;
1286         uint result;
1287 
1288         /* Get borrowBalance and borrowIndex */
1289         BorrowSnapshot storage borrowSnapshot = accountBorrows[account];
1290 
1291         /* If borrowBalance = 0 then borrowIndex is likely also 0.
1292          * Rather than failing the calculation with a division by 0, we immediately return 0 in this case.
1293          */
1294         if (borrowSnapshot.principal == 0) {
1295             return (MathError.NO_ERROR, 0);
1296         }
1297 
1298         /* Calculate new borrow balance using the interest index:
1299          *  recentBorrowBalance = borrower.borrowBalance * market.borrowIndex / borrower.borrowIndex
1300          */
1301         (mathErr, principalTimesIndex) = mulUInt(borrowSnapshot.principal, borrowIndex);
1302         if (mathErr != MathError.NO_ERROR) {
1303             return (mathErr, 0);
1304         }
1305 
1306         (mathErr, result) = divUInt(principalTimesIndex, borrowSnapshot.interestIndex);
1307         if (mathErr != MathError.NO_ERROR) {
1308             return (mathErr, 0);
1309         }
1310 
1311         return (MathError.NO_ERROR, result);
1312     }
1313 
1314     /**
1315      * @notice Accrue interest then return the up-to-date exchange rate
1316      * @return Calculated exchange rate scaled by 1e18
1317      */
1318     function exchangeRateCurrent() public nonReentrant returns (uint) {
1319         require(accrueInterest() == uint(Error.NO_ERROR), "accrue interest failed");
1320         return exchangeRateStored();
1321     }
1322 
1323     /**
1324      * @notice Calculates the exchange rate from the underlying to the CToken
1325      * @dev This function does not accrue interest before calculating the exchange rate
1326      * @return Calculated exchange rate scaled by 1e18
1327      */
1328     function exchangeRateStored() public view returns (uint) {
1329         (MathError err, uint result) = exchangeRateStoredInternal();
1330         require(err == MathError.NO_ERROR, "exchangeRateStored: exchangeRateStoredInternal failed");
1331         return result;
1332     }
1333 
1334     /**
1335      * @notice Calculates the exchange rate from the underlying to the CToken
1336      * @dev This function does not accrue interest before calculating the exchange rate
1337      * @return (error code, calculated exchange rate scaled by 1e18)
1338      */
1339     function exchangeRateStoredInternal() internal view returns (MathError, uint) {
1340         if (totalSupply == 0) {
1341             /*
1342              * If there are no tokens minted:
1343              *  exchangeRate = initialExchangeRate
1344              */
1345             return (MathError.NO_ERROR, initialExchangeRateMantissa);
1346         } else {
1347             /*
1348              * Otherwise:
1349              *  exchangeRate = (totalCash + totalBorrows - totalReserves) / totalSupply
1350              */
1351             uint totalCash = getCashPrior();
1352             uint cashPlusBorrowsMinusReserves;
1353             Exp memory exchangeRate;
1354             MathError mathErr;
1355 
1356             (mathErr, cashPlusBorrowsMinusReserves) = addThenSubUInt(totalCash, totalBorrows, totalReserves);
1357             if (mathErr != MathError.NO_ERROR) {
1358                 return (mathErr, 0);
1359             }
1360 
1361             (mathErr, exchangeRate) = getExp(cashPlusBorrowsMinusReserves, totalSupply);
1362             if (mathErr != MathError.NO_ERROR) {
1363                 return (mathErr, 0);
1364             }
1365 
1366             return (MathError.NO_ERROR, exchangeRate.mantissa);
1367         }
1368     }
1369 
1370     /**
1371      * @notice Get cash balance of this cToken in the underlying asset
1372      * @return The quantity of underlying asset owned by this contract
1373      */
1374     function getCash() external view returns (uint) {
1375         return getCashPrior();
1376     }
1377 
1378     struct AccrueInterestLocalVars {
1379         MathError mathErr;
1380         uint opaqueErr;
1381         uint borrowRateMantissa;
1382         uint currentBlockNumber;
1383         uint blockDelta;
1384 
1385         Exp simpleInterestFactor;
1386 
1387         uint interestAccumulated;
1388         uint totalBorrowsNew;
1389         uint totalReservesNew;
1390         uint borrowIndexNew;
1391     }
1392 
1393     /**
1394       * @notice Applies accrued interest to total borrows and reserves.
1395       * @dev This calculates interest accrued from the last checkpointed block
1396       *      up to the current block and writes new checkpoint to storage.
1397       */
1398     function accrueInterest() public returns (uint) {
1399         AccrueInterestLocalVars memory vars;
1400 
1401         /* Calculate the current borrow interest rate */
1402         (vars.opaqueErr, vars.borrowRateMantissa) = interestRateModel.getBorrowRate(getCashPrior(), totalBorrows, totalReserves);
1403         require(vars.borrowRateMantissa <= borrowRateMaxMantissa, "borrow rate is absurdly high");
1404         if (vars.opaqueErr != 0) {
1405             return failOpaque(Error.INTEREST_RATE_MODEL_ERROR, FailureInfo.ACCRUE_INTEREST_BORROW_RATE_CALCULATION_FAILED, vars.opaqueErr);
1406         }
1407 
1408         /* Remember the initial block number */
1409         vars.currentBlockNumber = getBlockNumber();
1410 
1411         /* Calculate the number of blocks elapsed since the last accrual */
1412         (vars.mathErr, vars.blockDelta) = subUInt(vars.currentBlockNumber, accrualBlockNumber);
1413         assert(vars.mathErr == MathError.NO_ERROR); // Block delta should always succeed and if it doesn't, blow up.
1414 
1415         /*
1416          * Calculate the interest accumulated into borrows and reserves and the new index:
1417          *  simpleInterestFactor = borrowRate * blockDelta
1418          *  interestAccumulated = simpleInterestFactor * totalBorrows
1419          *  totalBorrowsNew = interestAccumulated + totalBorrows
1420          *  totalReservesNew = interestAccumulated * reserveFactor + totalReserves
1421          *  borrowIndexNew = simpleInterestFactor * borrowIndex + borrowIndex
1422          */
1423         (vars.mathErr, vars.simpleInterestFactor) = mulScalar(Exp({mantissa: vars.borrowRateMantissa}), vars.blockDelta);
1424         if (vars.mathErr != MathError.NO_ERROR) {
1425             return failOpaque(Error.MATH_ERROR, FailureInfo.ACCRUE_INTEREST_SIMPLE_INTEREST_FACTOR_CALCULATION_FAILED, uint(vars.mathErr));
1426         }
1427 
1428         (vars.mathErr, vars.interestAccumulated) = mulScalarTruncate(vars.simpleInterestFactor, totalBorrows);
1429         if (vars.mathErr != MathError.NO_ERROR) {
1430             return failOpaque(Error.MATH_ERROR, FailureInfo.ACCRUE_INTEREST_ACCUMULATED_INTEREST_CALCULATION_FAILED, uint(vars.mathErr));
1431         }
1432 
1433         (vars.mathErr, vars.totalBorrowsNew) = addUInt(vars.interestAccumulated, totalBorrows);
1434         if (vars.mathErr != MathError.NO_ERROR) {
1435             return failOpaque(Error.MATH_ERROR, FailureInfo.ACCRUE_INTEREST_NEW_TOTAL_BORROWS_CALCULATION_FAILED, uint(vars.mathErr));
1436         }
1437 
1438         (vars.mathErr, vars.totalReservesNew) = mulScalarTruncateAddUInt(Exp({mantissa: reserveFactorMantissa}), vars.interestAccumulated, totalReserves);
1439         if (vars.mathErr != MathError.NO_ERROR) {
1440             return failOpaque(Error.MATH_ERROR, FailureInfo.ACCRUE_INTEREST_NEW_TOTAL_RESERVES_CALCULATION_FAILED, uint(vars.mathErr));
1441         }
1442 
1443         (vars.mathErr, vars.borrowIndexNew) = mulScalarTruncateAddUInt(vars.simpleInterestFactor, borrowIndex, borrowIndex);
1444         if (vars.mathErr != MathError.NO_ERROR) {
1445             return failOpaque(Error.MATH_ERROR, FailureInfo.ACCRUE_INTEREST_NEW_BORROW_INDEX_CALCULATION_FAILED, uint(vars.mathErr));
1446         }
1447 
1448         /////////////////////////
1449         // EFFECTS & INTERACTIONS
1450         // (No safe failures beyond this point)
1451 
1452         /* We write the previously calculated values into storage */
1453         accrualBlockNumber = vars.currentBlockNumber;
1454         borrowIndex = vars.borrowIndexNew;
1455         totalBorrows = vars.totalBorrowsNew;
1456         totalReserves = vars.totalReservesNew;
1457 
1458         /* We emit an AccrueInterest event */
1459         emit AccrueInterest(vars.interestAccumulated, vars.borrowIndexNew, totalBorrows);
1460 
1461         return uint(Error.NO_ERROR);
1462     }
1463 
1464     /**
1465      * @notice Sender supplies assets into the market and receives cTokens in exchange
1466      * @dev Accrues interest whether or not the operation succeeds, unless reverted
1467      * @param mintAmount The amount of the underlying asset to supply
1468      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
1469      */
1470     function mintInternal(uint mintAmount) internal nonReentrant returns (uint) {
1471         uint error = accrueInterest();
1472         if (error != uint(Error.NO_ERROR)) {
1473             // accrueInterest emits logs on errors, but we still want to log the fact that an attempted borrow failed
1474             return fail(Error(error), FailureInfo.MINT_ACCRUE_INTEREST_FAILED);
1475         }
1476         // mintFresh emits the actual Mint event if successful and logs on errors, so we don't need to
1477         return mintFresh(msg.sender, mintAmount);
1478     }
1479 
1480     struct MintLocalVars {
1481         Error err;
1482         MathError mathErr;
1483         uint exchangeRateMantissa;
1484         uint mintTokens;
1485         uint totalSupplyNew;
1486         uint accountTokensNew;
1487     }
1488 
1489     /**
1490      * @notice User supplies assets into the market and receives cTokens in exchange
1491      * @dev Assumes interest has already been accrued up to the current block
1492      * @param minter The address of the account which is supplying the assets
1493      * @param mintAmount The amount of the underlying asset to supply
1494      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
1495      */
1496     function mintFresh(address minter, uint mintAmount) internal returns (uint) {
1497         /* Fail if mint not allowed */
1498         uint allowed = comptroller.mintAllowed(address(this), minter, mintAmount);
1499         if (allowed != 0) {
1500             return failOpaque(Error.COMPTROLLER_REJECTION, FailureInfo.MINT_COMPTROLLER_REJECTION, allowed);
1501         }
1502 
1503         /* Verify market's block number equals current block number */
1504         if (accrualBlockNumber != getBlockNumber()) {
1505             return fail(Error.MARKET_NOT_FRESH, FailureInfo.MINT_FRESHNESS_CHECK);
1506         }
1507 
1508         MintLocalVars memory vars;
1509 
1510         /* Fail if checkTransferIn fails */
1511         vars.err = checkTransferIn(minter, mintAmount);
1512         if (vars.err != Error.NO_ERROR) {
1513             return fail(vars.err, FailureInfo.MINT_TRANSFER_IN_NOT_POSSIBLE);
1514         }
1515 
1516         /*
1517          * We get the current exchange rate and calculate the number of cTokens to be minted:
1518          *  mintTokens = mintAmount / exchangeRate
1519          */
1520         (vars.mathErr, vars.exchangeRateMantissa) = exchangeRateStoredInternal();
1521         if (vars.mathErr != MathError.NO_ERROR) {
1522             return failOpaque(Error.MATH_ERROR, FailureInfo.MINT_EXCHANGE_RATE_READ_FAILED, uint(vars.mathErr));
1523         }
1524 
1525         (vars.mathErr, vars.mintTokens) = divScalarByExpTruncate(mintAmount, Exp({mantissa: vars.exchangeRateMantissa}));
1526         if (vars.mathErr != MathError.NO_ERROR) {
1527             return failOpaque(Error.MATH_ERROR, FailureInfo.MINT_EXCHANGE_CALCULATION_FAILED, uint(vars.mathErr));
1528         }
1529 
1530         /*
1531          * We calculate the new total supply of cTokens and minter token balance, checking for overflow:
1532          *  totalSupplyNew = totalSupply + mintTokens
1533          *  accountTokensNew = accountTokens[minter] + mintTokens
1534          */
1535         (vars.mathErr, vars.totalSupplyNew) = addUInt(totalSupply, vars.mintTokens);
1536         if (vars.mathErr != MathError.NO_ERROR) {
1537             return failOpaque(Error.MATH_ERROR, FailureInfo.MINT_NEW_TOTAL_SUPPLY_CALCULATION_FAILED, uint(vars.mathErr));
1538         }
1539 
1540         (vars.mathErr, vars.accountTokensNew) = addUInt(accountTokens[minter], vars.mintTokens);
1541         if (vars.mathErr != MathError.NO_ERROR) {
1542             return failOpaque(Error.MATH_ERROR, FailureInfo.MINT_NEW_ACCOUNT_BALANCE_CALCULATION_FAILED, uint(vars.mathErr));
1543         }
1544 
1545         /////////////////////////
1546         // EFFECTS & INTERACTIONS
1547         // (No safe failures beyond this point)
1548 
1549         /*
1550          * We call doTransferIn for the minter and the mintAmount
1551          *  Note: The cToken must handle variations between ERC-20 and ETH underlying.
1552          *  On success, the cToken holds an additional mintAmount of cash.
1553          *  If doTransferIn fails despite the fact we checked pre-conditions,
1554          *   we revert because we can't be sure if side effects occurred.
1555          */
1556         vars.err = doTransferIn(minter, mintAmount);
1557         if (vars.err != Error.NO_ERROR) {
1558             return fail(vars.err, FailureInfo.MINT_TRANSFER_IN_FAILED);
1559         }
1560 
1561         /* We write previously calculated values into storage */
1562         totalSupply = vars.totalSupplyNew;
1563         accountTokens[minter] = vars.accountTokensNew;
1564 
1565         /* We emit a Mint event, and a Transfer event */
1566         emit Mint(minter, mintAmount, vars.mintTokens);
1567         emit Transfer(address(this), minter, vars.mintTokens);
1568 
1569         /* We call the defense hook */
1570         comptroller.mintVerify(address(this), minter, mintAmount, vars.mintTokens);
1571 
1572         return uint(Error.NO_ERROR);
1573     }
1574 
1575     /**
1576      * @notice Sender redeems cTokens in exchange for the underlying asset
1577      * @dev Accrues interest whether or not the operation succeeds, unless reverted
1578      * @param redeemTokens The number of cTokens to redeem into underlying
1579      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
1580      */
1581     function redeemInternal(uint redeemTokens) internal nonReentrant returns (uint) {
1582         uint error = accrueInterest();
1583         if (error != uint(Error.NO_ERROR)) {
1584             // accrueInterest emits logs on errors, but we still want to log the fact that an attempted redeem failed
1585             return fail(Error(error), FailureInfo.REDEEM_ACCRUE_INTEREST_FAILED);
1586         }
1587         // redeemFresh emits redeem-specific logs on errors, so we don't need to
1588         return redeemFresh(msg.sender, redeemTokens, 0);
1589     }
1590 
1591     /**
1592      * @notice Sender redeems cTokens in exchange for a specified amount of underlying asset
1593      * @dev Accrues interest whether or not the operation succeeds, unless reverted
1594      * @param redeemAmount The amount of underlying to redeem
1595      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
1596      */
1597     function redeemUnderlyingInternal(uint redeemAmount) internal nonReentrant returns (uint) {
1598         uint error = accrueInterest();
1599         if (error != uint(Error.NO_ERROR)) {
1600             // accrueInterest emits logs on errors, but we still want to log the fact that an attempted redeem failed
1601             return fail(Error(error), FailureInfo.REDEEM_ACCRUE_INTEREST_FAILED);
1602         }
1603         // redeemFresh emits redeem-specific logs on errors, so we don't need to
1604         return redeemFresh(msg.sender, 0, redeemAmount);
1605     }
1606 
1607     struct RedeemLocalVars {
1608         Error err;
1609         MathError mathErr;
1610         uint exchangeRateMantissa;
1611         uint redeemTokens;
1612         uint redeemAmount;
1613         uint totalSupplyNew;
1614         uint accountTokensNew;
1615     }
1616 
1617     /**
1618      * @notice User redeems cTokens in exchange for the underlying asset
1619      * @dev Assumes interest has already been accrued up to the current block
1620      * @param redeemer The address of the account which is redeeming the tokens
1621      * @param redeemTokensIn The number of cTokens to redeem into underlying (only one of redeemTokensIn or redeemAmountIn may be zero)
1622      * @param redeemAmountIn The number of cTokens to redeem into underlying (only one of redeemTokensIn or redeemAmountIn may be zero)
1623      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
1624      */
1625     function redeemFresh(address payable redeemer, uint redeemTokensIn, uint redeemAmountIn) internal returns (uint) {
1626         require(redeemTokensIn == 0 || redeemAmountIn == 0, "one of redeemTokensIn or redeemAmountIn must be zero");
1627 
1628         RedeemLocalVars memory vars;
1629 
1630         /* exchangeRate = invoke Exchange Rate Stored() */
1631         (vars.mathErr, vars.exchangeRateMantissa) = exchangeRateStoredInternal();
1632         if (vars.mathErr != MathError.NO_ERROR) {
1633             return failOpaque(Error.MATH_ERROR, FailureInfo.REDEEM_EXCHANGE_RATE_READ_FAILED, uint(vars.mathErr));
1634         }
1635 
1636         /* If redeemTokensIn > 0: */
1637         if (redeemTokensIn > 0) {
1638             /*
1639              * We calculate the exchange rate and the amount of underlying to be redeemed:
1640              *  redeemTokens = redeemTokensIn
1641              *  redeemAmount = redeemTokensIn x exchangeRateCurrent
1642              */
1643             vars.redeemTokens = redeemTokensIn;
1644 
1645             (vars.mathErr, vars.redeemAmount) = mulScalarTruncate(Exp({mantissa: vars.exchangeRateMantissa}), redeemTokensIn);
1646             if (vars.mathErr != MathError.NO_ERROR) {
1647                 return failOpaque(Error.MATH_ERROR, FailureInfo.REDEEM_EXCHANGE_TOKENS_CALCULATION_FAILED, uint(vars.mathErr));
1648             }
1649         } else {
1650             /*
1651              * We get the current exchange rate and calculate the amount to be redeemed:
1652              *  redeemTokens = redeemAmountIn / exchangeRate
1653              *  redeemAmount = redeemAmountIn
1654              */
1655 
1656             (vars.mathErr, vars.redeemTokens) = divScalarByExpTruncate(redeemAmountIn, Exp({mantissa: vars.exchangeRateMantissa}));
1657             if (vars.mathErr != MathError.NO_ERROR) {
1658                 return failOpaque(Error.MATH_ERROR, FailureInfo.REDEEM_EXCHANGE_AMOUNT_CALCULATION_FAILED, uint(vars.mathErr));
1659             }
1660 
1661             vars.redeemAmount = redeemAmountIn;
1662         }
1663 
1664         /* Fail if redeem not allowed */
1665         uint allowed = comptroller.redeemAllowed(address(this), redeemer, vars.redeemTokens);
1666         if (allowed != 0) {
1667             return failOpaque(Error.COMPTROLLER_REJECTION, FailureInfo.REDEEM_COMPTROLLER_REJECTION, allowed);
1668         }
1669 
1670         /* Verify market's block number equals current block number */
1671         if (accrualBlockNumber != getBlockNumber()) {
1672             return fail(Error.MARKET_NOT_FRESH, FailureInfo.REDEEM_FRESHNESS_CHECK);
1673         }
1674 
1675         /*
1676          * We calculate the new total supply and redeemer balance, checking for underflow:
1677          *  totalSupplyNew = totalSupply - redeemTokens
1678          *  accountTokensNew = accountTokens[redeemer] - redeemTokens
1679          */
1680         (vars.mathErr, vars.totalSupplyNew) = subUInt(totalSupply, vars.redeemTokens);
1681         if (vars.mathErr != MathError.NO_ERROR) {
1682             return failOpaque(Error.MATH_ERROR, FailureInfo.REDEEM_NEW_TOTAL_SUPPLY_CALCULATION_FAILED, uint(vars.mathErr));
1683         }
1684 
1685         (vars.mathErr, vars.accountTokensNew) = subUInt(accountTokens[redeemer], vars.redeemTokens);
1686         if (vars.mathErr != MathError.NO_ERROR) {
1687             return failOpaque(Error.MATH_ERROR, FailureInfo.REDEEM_NEW_ACCOUNT_BALANCE_CALCULATION_FAILED, uint(vars.mathErr));
1688         }
1689 
1690         /* Fail gracefully if protocol has insufficient cash */
1691         if (getCashPrior() < vars.redeemAmount) {
1692             return fail(Error.TOKEN_INSUFFICIENT_CASH, FailureInfo.REDEEM_TRANSFER_OUT_NOT_POSSIBLE);
1693         }
1694 
1695         /////////////////////////
1696         // EFFECTS & INTERACTIONS
1697         // (No safe failures beyond this point)
1698 
1699         /*
1700          * We invoke doTransferOut for the redeemer and the redeemAmount.
1701          *  Note: The cToken must handle variations between ERC-20 and ETH underlying.
1702          *  On success, the cToken has redeemAmount less of cash.
1703          *  If doTransferOut fails despite the fact we checked pre-conditions,
1704          *   we revert because we can't be sure if side effects occurred.
1705          */
1706         vars.err = doTransferOut(redeemer, vars.redeemAmount);
1707         require(vars.err == Error.NO_ERROR, "redeem transfer out failed");
1708 
1709         /* We write previously calculated values into storage */
1710         totalSupply = vars.totalSupplyNew;
1711         accountTokens[redeemer] = vars.accountTokensNew;
1712 
1713         /* We emit a Transfer event, and a Redeem event */
1714         emit Transfer(redeemer, address(this), vars.redeemTokens);
1715         emit Redeem(redeemer, vars.redeemAmount, vars.redeemTokens);
1716 
1717         /* We call the defense hook */
1718         comptroller.redeemVerify(address(this), redeemer, vars.redeemAmount, vars.redeemTokens);
1719 
1720         return uint(Error.NO_ERROR);
1721     }
1722 
1723     /**
1724       * @notice Sender borrows assets from the protocol to their own address
1725       * @param borrowAmount The amount of the underlying asset to borrow
1726       * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
1727       */
1728     function borrowInternal(uint borrowAmount) internal nonReentrant returns (uint) {
1729         uint error = accrueInterest();
1730         if (error != uint(Error.NO_ERROR)) {
1731             // accrueInterest emits logs on errors, but we still want to log the fact that an attempted borrow failed
1732             return fail(Error(error), FailureInfo.BORROW_ACCRUE_INTEREST_FAILED);
1733         }
1734         // borrowFresh emits borrow-specific logs on errors, so we don't need to
1735         return borrowFresh(msg.sender, borrowAmount);
1736     }
1737 
1738     struct BorrowLocalVars {
1739         Error err;
1740         MathError mathErr;
1741         uint accountBorrows;
1742         uint accountBorrowsNew;
1743         uint totalBorrowsNew;
1744     }
1745 
1746     /**
1747       * @notice Users borrow assets from the protocol to their own address
1748       * @param borrowAmount The amount of the underlying asset to borrow
1749       * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
1750       */
1751     function borrowFresh(address payable borrower, uint borrowAmount) internal returns (uint) {
1752         /* Fail if borrow not allowed */
1753         uint allowed = comptroller.borrowAllowed(address(this), borrower, borrowAmount);
1754         if (allowed != 0) {
1755             return failOpaque(Error.COMPTROLLER_REJECTION, FailureInfo.BORROW_COMPTROLLER_REJECTION, allowed);
1756         }
1757 
1758         /* Verify market's block number equals current block number */
1759         if (accrualBlockNumber != getBlockNumber()) {
1760             return fail(Error.MARKET_NOT_FRESH, FailureInfo.BORROW_FRESHNESS_CHECK);
1761         }
1762 
1763         /* Fail gracefully if protocol has insufficient underlying cash */
1764         if (getCashPrior() < borrowAmount) {
1765             return fail(Error.TOKEN_INSUFFICIENT_CASH, FailureInfo.BORROW_CASH_NOT_AVAILABLE);
1766         }
1767 
1768         BorrowLocalVars memory vars;
1769 
1770         /*
1771          * We calculate the new borrower and total borrow balances, failing on overflow:
1772          *  accountBorrowsNew = accountBorrows + borrowAmount
1773          *  totalBorrowsNew = totalBorrows + borrowAmount
1774          */
1775         (vars.mathErr, vars.accountBorrows) = borrowBalanceStoredInternal(borrower);
1776         if (vars.mathErr != MathError.NO_ERROR) {
1777             return failOpaque(Error.MATH_ERROR, FailureInfo.BORROW_ACCUMULATED_BALANCE_CALCULATION_FAILED, uint(vars.mathErr));
1778         }
1779 
1780         (vars.mathErr, vars.accountBorrowsNew) = addUInt(vars.accountBorrows, borrowAmount);
1781         if (vars.mathErr != MathError.NO_ERROR) {
1782             return failOpaque(Error.MATH_ERROR, FailureInfo.BORROW_NEW_ACCOUNT_BORROW_BALANCE_CALCULATION_FAILED, uint(vars.mathErr));
1783         }
1784 
1785         (vars.mathErr, vars.totalBorrowsNew) = addUInt(totalBorrows, borrowAmount);
1786         if (vars.mathErr != MathError.NO_ERROR) {
1787             return failOpaque(Error.MATH_ERROR, FailureInfo.BORROW_NEW_TOTAL_BALANCE_CALCULATION_FAILED, uint(vars.mathErr));
1788         }
1789 
1790         /////////////////////////
1791         // EFFECTS & INTERACTIONS
1792         // (No safe failures beyond this point)
1793 
1794         /*
1795          * We invoke doTransferOut for the borrower and the borrowAmount.
1796          *  Note: The cToken must handle variations between ERC-20 and ETH underlying.
1797          *  On success, the cToken borrowAmount less of cash.
1798          *  If doTransferOut fails despite the fact we checked pre-conditions,
1799          *   we revert because we can't be sure if side effects occurred.
1800          */
1801         vars.err = doTransferOut(borrower, borrowAmount);
1802         require(vars.err == Error.NO_ERROR, "borrow transfer out failed");
1803 
1804         /* We write the previously calculated values into storage */
1805         accountBorrows[borrower].principal = vars.accountBorrowsNew;
1806         accountBorrows[borrower].interestIndex = borrowIndex;
1807         totalBorrows = vars.totalBorrowsNew;
1808 
1809         /* We emit a Borrow event */
1810         emit Borrow(borrower, borrowAmount, vars.accountBorrowsNew, vars.totalBorrowsNew);
1811 
1812         /* We call the defense hook */
1813         comptroller.borrowVerify(address(this), borrower, borrowAmount);
1814 
1815         return uint(Error.NO_ERROR);
1816     }
1817 
1818     /**
1819      * @notice Sender repays their own borrow
1820      * @param repayAmount The amount to repay
1821      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
1822      */
1823     function repayBorrowInternal(uint repayAmount) internal nonReentrant returns (uint) {
1824         uint error = accrueInterest();
1825         if (error != uint(Error.NO_ERROR)) {
1826             // accrueInterest emits logs on errors, but we still want to log the fact that an attempted borrow failed
1827             return fail(Error(error), FailureInfo.REPAY_BORROW_ACCRUE_INTEREST_FAILED);
1828         }
1829         // repayBorrowFresh emits repay-borrow-specific logs on errors, so we don't need to
1830         return repayBorrowFresh(msg.sender, msg.sender, repayAmount);
1831     }
1832 
1833     /**
1834      * @notice Sender repays a borrow belonging to borrower
1835      * @param borrower the account with the debt being payed off
1836      * @param repayAmount The amount to repay
1837      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
1838      */
1839     function repayBorrowBehalfInternal(address borrower, uint repayAmount) internal nonReentrant returns (uint) {
1840         uint error = accrueInterest();
1841         if (error != uint(Error.NO_ERROR)) {
1842             // accrueInterest emits logs on errors, but we still want to log the fact that an attempted borrow failed
1843             return fail(Error(error), FailureInfo.REPAY_BEHALF_ACCRUE_INTEREST_FAILED);
1844         }
1845         // repayBorrowFresh emits repay-borrow-specific logs on errors, so we don't need to
1846         return repayBorrowFresh(msg.sender, borrower, repayAmount);
1847     }
1848 
1849     struct RepayBorrowLocalVars {
1850         Error err;
1851         MathError mathErr;
1852         uint repayAmount;
1853         uint borrowerIndex;
1854         uint accountBorrows;
1855         uint accountBorrowsNew;
1856         uint totalBorrowsNew;
1857     }
1858 
1859     /**
1860      * @notice Borrows are repaid by another user (possibly the borrower).
1861      * @param payer the account paying off the borrow
1862      * @param borrower the account with the debt being payed off
1863      * @param repayAmount the amount of undelrying tokens being returned
1864      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
1865      */
1866     function repayBorrowFresh(address payer, address borrower, uint repayAmount) internal returns (uint) {
1867         /* Fail if repayBorrow not allowed */
1868         uint allowed = comptroller.repayBorrowAllowed(address(this), payer, borrower, repayAmount);
1869         if (allowed != 0) {
1870             return failOpaque(Error.COMPTROLLER_REJECTION, FailureInfo.REPAY_BORROW_COMPTROLLER_REJECTION, allowed);
1871         }
1872 
1873         /* Verify market's block number equals current block number */
1874         if (accrualBlockNumber != getBlockNumber()) {
1875             return fail(Error.MARKET_NOT_FRESH, FailureInfo.REPAY_BORROW_FRESHNESS_CHECK);
1876         }
1877 
1878         RepayBorrowLocalVars memory vars;
1879 
1880         /* We remember the original borrowerIndex for verification purposes */
1881         vars.borrowerIndex = accountBorrows[borrower].interestIndex;
1882 
1883         /* We fetch the amount the borrower owes, with accumulated interest */
1884         (vars.mathErr, vars.accountBorrows) = borrowBalanceStoredInternal(borrower);
1885         if (vars.mathErr != MathError.NO_ERROR) {
1886             return failOpaque(Error.MATH_ERROR, FailureInfo.REPAY_BORROW_ACCUMULATED_BALANCE_CALCULATION_FAILED, uint(vars.mathErr));
1887         }
1888 
1889         /* If repayAmount == -1, repayAmount = accountBorrows */
1890         if (repayAmount == uint(-1)) {
1891             vars.repayAmount = vars.accountBorrows;
1892         } else {
1893             vars.repayAmount = repayAmount;
1894         }
1895 
1896         /* Fail if checkTransferIn fails */
1897         vars.err = checkTransferIn(payer, vars.repayAmount);
1898         if (vars.err != Error.NO_ERROR) {
1899             return fail(vars.err, FailureInfo.REPAY_BORROW_TRANSFER_IN_NOT_POSSIBLE);
1900         }
1901 
1902         /*
1903          * We calculate the new borrower and total borrow balances, failing on underflow:
1904          *  accountBorrowsNew = accountBorrows - repayAmount
1905          *  totalBorrowsNew = totalBorrows - repayAmount
1906          */
1907         (vars.mathErr, vars.accountBorrowsNew) = subUInt(vars.accountBorrows, vars.repayAmount);
1908         if (vars.mathErr != MathError.NO_ERROR) {
1909             return failOpaque(Error.MATH_ERROR, FailureInfo.REPAY_BORROW_NEW_ACCOUNT_BORROW_BALANCE_CALCULATION_FAILED, uint(vars.mathErr));
1910         }
1911 
1912         (vars.mathErr, vars.totalBorrowsNew) = subUInt(totalBorrows, vars.repayAmount);
1913         if (vars.mathErr != MathError.NO_ERROR) {
1914             return failOpaque(Error.MATH_ERROR, FailureInfo.REPAY_BORROW_NEW_TOTAL_BALANCE_CALCULATION_FAILED, uint(vars.mathErr));
1915         }
1916 
1917         /////////////////////////
1918         // EFFECTS & INTERACTIONS
1919         // (No safe failures beyond this point)
1920 
1921         /*
1922          * We call doTransferIn for the payer and the repayAmount
1923          *  Note: The cToken must handle variations between ERC-20 and ETH underlying.
1924          *  On success, the cToken holds an additional repayAmount of cash.
1925          *  If doTransferIn fails despite the fact we checked pre-conditions,
1926          *   we revert because we can't be sure if side effects occurred.
1927          */
1928         vars.err = doTransferIn(payer, vars.repayAmount);
1929         require(vars.err == Error.NO_ERROR, "repay borrow transfer in failed");
1930 
1931         /* We write the previously calculated values into storage */
1932         accountBorrows[borrower].principal = vars.accountBorrowsNew;
1933         accountBorrows[borrower].interestIndex = borrowIndex;
1934         totalBorrows = vars.totalBorrowsNew;
1935 
1936         /* We emit a RepayBorrow event */
1937         emit RepayBorrow(payer, borrower, vars.repayAmount, vars.accountBorrowsNew, vars.totalBorrowsNew);
1938 
1939         /* We call the defense hook */
1940         comptroller.repayBorrowVerify(address(this), payer, borrower, vars.repayAmount, vars.borrowerIndex);
1941 
1942         return uint(Error.NO_ERROR);
1943     }
1944 
1945     /**
1946      * @notice The sender liquidates the borrowers collateral.
1947      *  The collateral seized is transferred to the liquidator.
1948      * @param borrower The borrower of this cToken to be liquidated
1949      * @param cTokenCollateral The market in which to seize collateral from the borrower
1950      * @param repayAmount The amount of the underlying borrowed asset to repay
1951      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
1952      */
1953     function liquidateBorrowInternal(address borrower, uint repayAmount, CToken cTokenCollateral) internal nonReentrant returns (uint) {
1954         uint error = accrueInterest();
1955         if (error != uint(Error.NO_ERROR)) {
1956             // accrueInterest emits logs on errors, but we still want to log the fact that an attempted liquidation failed
1957             return fail(Error(error), FailureInfo.LIQUIDATE_ACCRUE_BORROW_INTEREST_FAILED);
1958         }
1959 
1960         error = cTokenCollateral.accrueInterest();
1961         if (error != uint(Error.NO_ERROR)) {
1962             // accrueInterest emits logs on errors, but we still want to log the fact that an attempted liquidation failed
1963             return fail(Error(error), FailureInfo.LIQUIDATE_ACCRUE_COLLATERAL_INTEREST_FAILED);
1964         }
1965 
1966         // liquidateBorrowFresh emits borrow-specific logs on errors, so we don't need to
1967         return liquidateBorrowFresh(msg.sender, borrower, repayAmount, cTokenCollateral);
1968     }
1969 
1970     /**
1971      * @notice The liquidator liquidates the borrowers collateral.
1972      *  The collateral seized is transferred to the liquidator.
1973      * @param borrower The borrower of this cToken to be liquidated
1974      * @param liquidator The address repaying the borrow and seizing collateral
1975      * @param cTokenCollateral The market in which to seize collateral from the borrower
1976      * @param repayAmount The amount of the underlying borrowed asset to repay
1977      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
1978      */
1979     function liquidateBorrowFresh(address liquidator, address borrower, uint repayAmount, CToken cTokenCollateral) internal returns (uint) {
1980         /* Fail if liquidate not allowed */
1981         uint allowed = comptroller.liquidateBorrowAllowed(address(this), address(cTokenCollateral), liquidator, borrower, repayAmount);
1982         if (allowed != 0) {
1983             return failOpaque(Error.COMPTROLLER_REJECTION, FailureInfo.LIQUIDATE_COMPTROLLER_REJECTION, allowed);
1984         }
1985 
1986         /* Verify market's block number equals current block number */
1987         if (accrualBlockNumber != getBlockNumber()) {
1988             return fail(Error.MARKET_NOT_FRESH, FailureInfo.LIQUIDATE_FRESHNESS_CHECK);
1989         }
1990 
1991         /* Verify cTokenCollateral market's block number equals current block number */
1992         if (cTokenCollateral.accrualBlockNumber() != getBlockNumber()) {
1993             return fail(Error.MARKET_NOT_FRESH, FailureInfo.LIQUIDATE_COLLATERAL_FRESHNESS_CHECK);
1994         }
1995 
1996         /* Fail if borrower = liquidator */
1997         if (borrower == liquidator) {
1998             return fail(Error.INVALID_ACCOUNT_PAIR, FailureInfo.LIQUIDATE_LIQUIDATOR_IS_BORROWER);
1999         }
2000 
2001         /* Fail if repayAmount = 0 */
2002         if (repayAmount == 0) {
2003             return fail(Error.INVALID_CLOSE_AMOUNT_REQUESTED, FailureInfo.LIQUIDATE_CLOSE_AMOUNT_IS_ZERO);
2004         }
2005 
2006         /* Fail if repayAmount = -1 */
2007         if (repayAmount == uint(-1)) {
2008             return fail(Error.INVALID_CLOSE_AMOUNT_REQUESTED, FailureInfo.LIQUIDATE_CLOSE_AMOUNT_IS_UINT_MAX);
2009         }
2010 
2011         /* We calculate the number of collateral tokens that will be seized */
2012         (uint amountSeizeError, uint seizeTokens) = comptroller.liquidateCalculateSeizeTokens(address(this), address(cTokenCollateral), repayAmount);
2013         if (amountSeizeError != 0) {
2014             return failOpaque(Error.COMPTROLLER_CALCULATION_ERROR, FailureInfo.LIQUIDATE_COMPTROLLER_CALCULATE_AMOUNT_SEIZE_FAILED, amountSeizeError);
2015         }
2016 
2017         /* Fail if seizeTokens > borrower collateral token balance */
2018         if (seizeTokens > cTokenCollateral.balanceOf(borrower)) {
2019             return fail(Error.TOKEN_INSUFFICIENT_BALANCE, FailureInfo.LIQUIDATE_SEIZE_TOO_MUCH);
2020         }
2021 
2022         /* Fail if repayBorrow fails */
2023         uint repayBorrowError = repayBorrowFresh(liquidator, borrower, repayAmount);
2024         if (repayBorrowError != uint(Error.NO_ERROR)) {
2025             return fail(Error(repayBorrowError), FailureInfo.LIQUIDATE_REPAY_BORROW_FRESH_FAILED);
2026         }
2027 
2028         /* Revert if seize tokens fails (since we cannot be sure of side effects) */
2029         uint seizeError = cTokenCollateral.seize(liquidator, borrower, seizeTokens);
2030         require(seizeError == uint(Error.NO_ERROR), "token seizure failed");
2031 
2032         /* We emit a LiquidateBorrow event */
2033         emit LiquidateBorrow(liquidator, borrower, repayAmount, address(cTokenCollateral), seizeTokens);
2034 
2035         /* We call the defense hook */
2036         comptroller.liquidateBorrowVerify(address(this), address(cTokenCollateral), liquidator, borrower, repayAmount, seizeTokens);
2037 
2038         return uint(Error.NO_ERROR);
2039     }
2040 
2041     /**
2042      * @notice Transfers collateral tokens (this market) to the liquidator.
2043      * @dev Will fail unless called by another cToken during the process of liquidation.
2044      *  Its absolutely critical to use msg.sender as the borrowed cToken and not a parameter.
2045      * @param liquidator The account receiving seized collateral
2046      * @param borrower The account having collateral seized
2047      * @param seizeTokens The number of cTokens to seize
2048      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
2049      */
2050     function seize(address liquidator, address borrower, uint seizeTokens) external nonReentrant returns (uint) {
2051         /* Fail if seize not allowed */
2052         uint allowed = comptroller.seizeAllowed(address(this), msg.sender, liquidator, borrower, seizeTokens);
2053         if (allowed != 0) {
2054             return failOpaque(Error.COMPTROLLER_REJECTION, FailureInfo.LIQUIDATE_SEIZE_COMPTROLLER_REJECTION, allowed);
2055         }
2056 
2057         /* Fail if borrower = liquidator */
2058         if (borrower == liquidator) {
2059             return fail(Error.INVALID_ACCOUNT_PAIR, FailureInfo.LIQUIDATE_SEIZE_LIQUIDATOR_IS_BORROWER);
2060         }
2061 
2062         MathError mathErr;
2063         uint borrowerTokensNew;
2064         uint liquidatorTokensNew;
2065 
2066         /*
2067          * We calculate the new borrower and liquidator token balances, failing on underflow/overflow:
2068          *  borrowerTokensNew = accountTokens[borrower] - seizeTokens
2069          *  liquidatorTokensNew = accountTokens[liquidator] + seizeTokens
2070          */
2071         (mathErr, borrowerTokensNew) = subUInt(accountTokens[borrower], seizeTokens);
2072         if (mathErr != MathError.NO_ERROR) {
2073             return failOpaque(Error.MATH_ERROR, FailureInfo.LIQUIDATE_SEIZE_BALANCE_DECREMENT_FAILED, uint(mathErr));
2074         }
2075 
2076         (mathErr, liquidatorTokensNew) = addUInt(accountTokens[liquidator], seizeTokens);
2077         if (mathErr != MathError.NO_ERROR) {
2078             return failOpaque(Error.MATH_ERROR, FailureInfo.LIQUIDATE_SEIZE_BALANCE_INCREMENT_FAILED, uint(mathErr));
2079         }
2080 
2081         /////////////////////////
2082         // EFFECTS & INTERACTIONS
2083         // (No safe failures beyond this point)
2084 
2085         /* We write the previously calculated values into storage */
2086         accountTokens[borrower] = borrowerTokensNew;
2087         accountTokens[liquidator] = liquidatorTokensNew;
2088 
2089         /* Emit a Transfer event */
2090         emit Transfer(borrower, liquidator, seizeTokens);
2091 
2092         /* We call the defense hook */
2093         comptroller.seizeVerify(address(this), msg.sender, liquidator, borrower, seizeTokens);
2094 
2095         return uint(Error.NO_ERROR);
2096     }
2097 
2098 
2099     /*** Admin Functions ***/
2100 
2101     /**
2102       * @notice Begins transfer of admin rights. The newPendingAdmin must call `_acceptAdmin` to finalize the transfer.
2103       * @dev Admin function to begin change of admin. The newPendingAdmin must call `_acceptAdmin` to finalize the transfer.
2104       * @param newPendingAdmin New pending admin.
2105       * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
2106       *
2107       * TODO: Should we add a second arg to verify, like a checksum of `newAdmin` address?
2108       */
2109     function _setPendingAdmin(address payable newPendingAdmin) external returns (uint) {
2110         // Check caller = admin
2111         if (msg.sender != admin) {
2112             return fail(Error.UNAUTHORIZED, FailureInfo.SET_PENDING_ADMIN_OWNER_CHECK);
2113         }
2114 
2115         // Save current value, if any, for inclusion in log
2116         address oldPendingAdmin = pendingAdmin;
2117 
2118         // Store pendingAdmin with value newPendingAdmin
2119         pendingAdmin = newPendingAdmin;
2120 
2121         // Emit NewPendingAdmin(oldPendingAdmin, newPendingAdmin)
2122         emit NewPendingAdmin(oldPendingAdmin, newPendingAdmin);
2123 
2124         return uint(Error.NO_ERROR);
2125     }
2126 
2127     /**
2128       * @notice Accepts transfer of admin rights. msg.sender must be pendingAdmin
2129       * @dev Admin function for pending admin to accept role and update admin
2130       * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
2131       */
2132     function _acceptAdmin() external returns (uint) {
2133         // Check caller is pendingAdmin and pendingAdmin ≠ address(0)
2134         if (msg.sender != pendingAdmin || msg.sender == address(0)) {
2135             return fail(Error.UNAUTHORIZED, FailureInfo.ACCEPT_ADMIN_PENDING_ADMIN_CHECK);
2136         }
2137 
2138         // Save current values for inclusion in log
2139         address oldAdmin = admin;
2140         address oldPendingAdmin = pendingAdmin;
2141 
2142         // Store admin with value pendingAdmin
2143         admin = pendingAdmin;
2144 
2145         // Clear the pending value
2146         pendingAdmin = address(0);
2147 
2148         emit NewAdmin(oldAdmin, admin);
2149         emit NewPendingAdmin(oldPendingAdmin, pendingAdmin);
2150 
2151         return uint(Error.NO_ERROR);
2152     }
2153 
2154     /**
2155       * @notice Sets a new comptroller for the market
2156       * @dev Admin function to set a new comptroller
2157       * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
2158       */
2159     function _setComptroller(ComptrollerInterface newComptroller) public returns (uint) {
2160         // Check caller is admin
2161         if (msg.sender != admin) {
2162             return fail(Error.UNAUTHORIZED, FailureInfo.SET_COMPTROLLER_OWNER_CHECK);
2163         }
2164 
2165         ComptrollerInterface oldComptroller = comptroller;
2166         // Ensure invoke comptroller.isComptroller() returns true
2167         require(newComptroller.isComptroller(), "marker method returned false");
2168 
2169         // Set market's comptroller to newComptroller
2170         comptroller = newComptroller;
2171 
2172         // Emit NewComptroller(oldComptroller, newComptroller)
2173         emit NewComptroller(oldComptroller, newComptroller);
2174 
2175         return uint(Error.NO_ERROR);
2176     }
2177 
2178     /**
2179       * @notice accrues interest and sets a new reserve factor for the protocol using _setReserveFactorFresh
2180       * @dev Admin function to accrue interest and set a new reserve factor
2181       * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
2182       */
2183     function _setReserveFactor(uint newReserveFactorMantissa) external nonReentrant returns (uint) {
2184         uint error = accrueInterest();
2185         if (error != uint(Error.NO_ERROR)) {
2186             // accrueInterest emits logs on errors, but on top of that we want to log the fact that an attempted reserve factor change failed.
2187             return fail(Error(error), FailureInfo.SET_RESERVE_FACTOR_ACCRUE_INTEREST_FAILED);
2188         }
2189         // _setReserveFactorFresh emits reserve-factor-specific logs on errors, so we don't need to.
2190         return _setReserveFactorFresh(newReserveFactorMantissa);
2191     }
2192 
2193     /**
2194       * @notice Sets a new reserve factor for the protocol (*requires fresh interest accrual)
2195       * @dev Admin function to set a new reserve factor
2196       * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
2197       */
2198     function _setReserveFactorFresh(uint newReserveFactorMantissa) internal returns (uint) {
2199         // Check caller is admin
2200         if (msg.sender != admin) {
2201             return fail(Error.UNAUTHORIZED, FailureInfo.SET_RESERVE_FACTOR_ADMIN_CHECK);
2202         }
2203 
2204         // Verify market's block number equals current block number
2205         if (accrualBlockNumber != getBlockNumber()) {
2206             // TODO: static_assert + no error code?
2207             return fail(Error.MARKET_NOT_FRESH, FailureInfo.SET_RESERVE_FACTOR_FRESH_CHECK);
2208         }
2209 
2210         // Check newReserveFactor ≤ maxReserveFactor
2211         if (newReserveFactorMantissa > reserveFactorMaxMantissa) {
2212             return fail(Error.BAD_INPUT, FailureInfo.SET_RESERVE_FACTOR_BOUNDS_CHECK);
2213         }
2214 
2215         uint oldReserveFactorMantissa = reserveFactorMantissa;
2216         reserveFactorMantissa = newReserveFactorMantissa;
2217 
2218         emit NewReserveFactor(oldReserveFactorMantissa, newReserveFactorMantissa);
2219 
2220         return uint(Error.NO_ERROR);
2221     }
2222 
2223     /**
2224      * @notice Accrues interest and reduces reserves by transferring to admin
2225      * @param reduceAmount Amount of reduction to reserves
2226      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
2227      */
2228     function _reduceReserves(uint reduceAmount) external nonReentrant returns (uint) {
2229         uint error = accrueInterest();
2230         if (error != uint(Error.NO_ERROR)) {
2231             // accrueInterest emits logs on errors, but on top of that we want to log the fact that an attempted reduce reserves failed.
2232             return fail(Error(error), FailureInfo.REDUCE_RESERVES_ACCRUE_INTEREST_FAILED);
2233         }
2234         // _reduceReservesFresh emits reserve-reduction-specific logs on errors, so we don't need to.
2235         return _reduceReservesFresh(reduceAmount);
2236     }
2237 
2238     /**
2239      * @notice Reduces reserves by transferring to admin
2240      * @dev Requires fresh interest accrual
2241      * @param reduceAmount Amount of reduction to reserves
2242      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
2243      */
2244     function _reduceReservesFresh(uint reduceAmount) internal returns (uint) {
2245         Error err;
2246         // totalReserves - reduceAmount
2247         uint totalReservesNew;
2248 
2249         // Check caller is admin
2250         if (msg.sender != admin) {
2251             return fail(Error.UNAUTHORIZED, FailureInfo.REDUCE_RESERVES_ADMIN_CHECK);
2252         }
2253 
2254         // We fail gracefully unless market's block number equals current block number
2255         if (accrualBlockNumber != getBlockNumber()) {
2256             // TODO: static_assert + no error code?
2257             return fail(Error.MARKET_NOT_FRESH, FailureInfo.REDUCE_RESERVES_FRESH_CHECK);
2258         }
2259 
2260         // Fail gracefully if protocol has insufficient underlying cash
2261         if (getCashPrior() < reduceAmount) {
2262             return fail(Error.TOKEN_INSUFFICIENT_CASH, FailureInfo.REDUCE_RESERVES_CASH_NOT_AVAILABLE);
2263         }
2264 
2265         // Check reduceAmount ≤ reserves[n] (totalReserves)
2266         // TODO: I'm following the spec literally here but I think we should we just use SafeMath instead and fail on an error (which would be underflow)
2267         if (reduceAmount > totalReserves) {
2268             return fail(Error.BAD_INPUT, FailureInfo.REDUCE_RESERVES_VALIDATION);
2269         }
2270 
2271         /////////////////////////
2272         // EFFECTS & INTERACTIONS
2273         // (No safe failures beyond this point)
2274 
2275         totalReservesNew = totalReserves - reduceAmount;
2276         // We checked reduceAmount <= totalReserves above, so this should never revert.
2277         require(totalReservesNew <= totalReserves, "reduce reserves unexpected underflow");
2278 
2279         // Store reserves[n+1] = reserves[n] - reduceAmount
2280         totalReserves = totalReservesNew;
2281 
2282         // invoke doTransferOut(reduceAmount, admin)
2283         err = doTransferOut(admin, reduceAmount);
2284         // we revert on the failure of this command
2285         require(err == Error.NO_ERROR, "reduce reserves transfer out failed");
2286 
2287         emit ReservesReduced(admin, reduceAmount, totalReservesNew);
2288 
2289         return uint(Error.NO_ERROR);
2290     }
2291 
2292     /**
2293      * @notice accrues interest and updates the interest rate model using _setInterestRateModelFresh
2294      * @dev Admin function to accrue interest and update the interest rate model
2295      * @param newInterestRateModel the new interest rate model to use
2296      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
2297      */
2298     function _setInterestRateModel(InterestRateModel newInterestRateModel) public returns (uint) {
2299         uint error = accrueInterest();
2300         if (error != uint(Error.NO_ERROR)) {
2301             // accrueInterest emits logs on errors, but on top of that we want to log the fact that an attempted change of interest rate model failed
2302             return fail(Error(error), FailureInfo.SET_INTEREST_RATE_MODEL_ACCRUE_INTEREST_FAILED);
2303         }
2304         // _setInterestRateModelFresh emits interest-rate-model-update-specific logs on errors, so we don't need to.
2305         return _setInterestRateModelFresh(newInterestRateModel);
2306     }
2307 
2308     /**
2309      * @notice updates the interest rate model (*requires fresh interest accrual)
2310      * @dev Admin function to update the interest rate model
2311      * @param newInterestRateModel the new interest rate model to use
2312      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
2313      */
2314     function _setInterestRateModelFresh(InterestRateModel newInterestRateModel) internal returns (uint) {
2315 
2316         // Used to store old model for use in the event that is emitted on success
2317         InterestRateModel oldInterestRateModel;
2318 
2319         // Check caller is admin
2320         if (msg.sender != admin) {
2321             return fail(Error.UNAUTHORIZED, FailureInfo.SET_INTEREST_RATE_MODEL_OWNER_CHECK);
2322         }
2323 
2324         // We fail gracefully unless market's block number equals current block number
2325         if (accrualBlockNumber != getBlockNumber()) {
2326             // TODO: static_assert + no error code?
2327             return fail(Error.MARKET_NOT_FRESH, FailureInfo.SET_INTEREST_RATE_MODEL_FRESH_CHECK);
2328         }
2329 
2330         // Track the market's current interest rate model
2331         oldInterestRateModel = interestRateModel;
2332 
2333         // Ensure invoke newInterestRateModel.isInterestRateModel() returns true
2334         require(newInterestRateModel.isInterestRateModel(), "marker method returned false");
2335 
2336         // Set the interest rate model to newInterestRateModel
2337         interestRateModel = newInterestRateModel;
2338 
2339         // Emit NewMarketInterestRateModel(oldInterestRateModel, newInterestRateModel)
2340         emit NewMarketInterestRateModel(oldInterestRateModel, newInterestRateModel);
2341 
2342         return uint(Error.NO_ERROR);
2343     }
2344 
2345     /*** Safe Token ***/
2346 
2347     /**
2348      * @notice Gets balance of this contract in terms of the underlying
2349      * @dev This excludes the value of the current message, if any
2350      * @return The quantity of underlying owned by this contract
2351      */
2352     function getCashPrior() internal view returns (uint);
2353 
2354     /**
2355      * @dev Checks whether or not there is sufficient allowance for this contract to move amount from `from` and
2356      *      whether or not `from` has a balance of at least `amount`. Does NOT do a transfer.
2357      */
2358     function checkTransferIn(address from, uint amount) internal view returns (Error);
2359 
2360     /**
2361      * @dev Performs a transfer in, ideally returning an explanatory error code upon failure rather than reverting.
2362      *  If caller has not called `checkTransferIn`, this may revert due to insufficient balance or insufficient allowance.
2363      *  If caller has called `checkTransferIn` successfully, this should not revert in normal conditions.
2364      */
2365     function doTransferIn(address from, uint amount) internal returns (Error);
2366 
2367     /**
2368      * @dev Performs a transfer out, ideally returning an explanatory error code upon failure tather than reverting.
2369      *  If caller has not called checked protocol's balance, may revert due to insufficient cash held in the contract.
2370      *  If caller has checked protocol's balance, and verified it is >= amount, this should not revert in normal conditions.
2371      */
2372     function doTransferOut(address payable to, uint amount) internal returns (Error);
2373 }
2374 
2375 // File: contracts/CErc20.sol
2376 
2377 pragma solidity ^0.5.8;
2378 
2379 
2380 /**
2381  * @title Compound's CErc20 Contract
2382  * @notice CTokens which wrap an EIP-20 underlying
2383  * @author Compound
2384  */
2385 contract CErc20 is CToken {
2386 
2387     /**
2388      * @notice Underlying asset for this CToken
2389      */
2390     address public underlying;
2391 
2392     /**
2393      * @notice Construct a new money market
2394      * @param underlying_ The address of the underlying asset
2395      * @param comptroller_ The address of the Comptroller
2396      * @param interestRateModel_ The address of the interest rate model
2397      * @param initialExchangeRateMantissa_ The initial exchange rate, scaled by 1e18
2398      * @param name_ ERC-20 name of this token
2399      * @param symbol_ ERC-20 symbol of this token
2400      * @param decimals_ ERC-20 decimal precision of this token
2401      */
2402     constructor(address underlying_,
2403                 ComptrollerInterface comptroller_,
2404                 InterestRateModel interestRateModel_,
2405                 uint initialExchangeRateMantissa_,
2406                 string memory name_,
2407                 string memory symbol_,
2408                 uint decimals_) public
2409     CToken(comptroller_, interestRateModel_, initialExchangeRateMantissa_, name_, symbol_, decimals_) {
2410         // Set underlying
2411         underlying = underlying_;
2412         EIP20Interface(underlying).totalSupply(); // Sanity check the underlying
2413     }
2414 
2415     /*** User Interface ***/
2416 
2417     /**
2418      * @notice Sender supplies assets into the market and receives cTokens in exchange
2419      * @dev Accrues interest whether or not the operation succeeds, unless reverted
2420      * @param mintAmount The amount of the underlying asset to supply
2421      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
2422      */
2423     function mint(uint mintAmount) external returns (uint) {
2424         return mintInternal(mintAmount);
2425     }
2426 
2427     /**
2428      * @notice Sender redeems cTokens in exchange for the underlying asset
2429      * @dev Accrues interest whether or not the operation succeeds, unless reverted
2430      * @param redeemTokens The number of cTokens to redeem into underlying
2431      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
2432      */
2433     function redeem(uint redeemTokens) external returns (uint) {
2434         return redeemInternal(redeemTokens);
2435     }
2436 
2437     /**
2438      * @notice Sender redeems cTokens in exchange for a specified amount of underlying asset
2439      * @dev Accrues interest whether or not the operation succeeds, unless reverted
2440      * @param redeemAmount The amount of underlying to redeem
2441      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
2442      */
2443     function redeemUnderlying(uint redeemAmount) external returns (uint) {
2444         return redeemUnderlyingInternal(redeemAmount);
2445     }
2446 
2447     /**
2448       * @notice Sender borrows assets from the protocol to their own address
2449       * @param borrowAmount The amount of the underlying asset to borrow
2450       * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
2451       */
2452     function borrow(uint borrowAmount) external returns (uint) {
2453         return borrowInternal(borrowAmount);
2454     }
2455 
2456     /**
2457      * @notice Sender repays their own borrow
2458      * @param repayAmount The amount to repay
2459      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
2460      */
2461     function repayBorrow(uint repayAmount) external returns (uint) {
2462         return repayBorrowInternal(repayAmount);
2463     }
2464 
2465     /**
2466      * @notice Sender repays a borrow belonging to borrower
2467      * @param borrower the account with the debt being payed off
2468      * @param repayAmount The amount to repay
2469      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
2470      */
2471     function repayBorrowBehalf(address borrower, uint repayAmount) external returns (uint) {
2472         return repayBorrowBehalfInternal(borrower, repayAmount);
2473     }
2474 
2475     /**
2476      * @notice The sender liquidates the borrowers collateral.
2477      *  The collateral seized is transferred to the liquidator.
2478      * @param borrower The borrower of this cToken to be liquidated
2479      * @param cTokenCollateral The market in which to seize collateral from the borrower
2480      * @param repayAmount The amount of the underlying borrowed asset to repay
2481      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
2482      */
2483     function liquidateBorrow(address borrower, uint repayAmount, CToken cTokenCollateral) external returns (uint) {
2484         return liquidateBorrowInternal(borrower, repayAmount, cTokenCollateral);
2485     }
2486 
2487     /*** Safe Token ***/
2488 
2489     /**
2490      * @notice Gets balance of this contract in terms of the underlying
2491      * @dev This excludes the value of the current message, if any
2492      * @return The quantity of underlying tokens owned by this contract
2493      */
2494     function getCashPrior() internal view returns (uint) {
2495         EIP20Interface token = EIP20Interface(underlying);
2496         return token.balanceOf(address(this));
2497     }
2498 
2499     /**
2500      * @dev Checks whether or not there is sufficient allowance for this contract to move amount from `from` and
2501      *      whether or not `from` has a balance of at least `amount`. Does NOT do a transfer.
2502      */
2503     function checkTransferIn(address from, uint amount) internal view returns (Error) {
2504         EIP20Interface token = EIP20Interface(underlying);
2505 
2506         if (token.allowance(from, address(this)) < amount) {
2507             return Error.TOKEN_INSUFFICIENT_ALLOWANCE;
2508         }
2509 
2510         if (token.balanceOf(from) < amount) {
2511             return Error.TOKEN_INSUFFICIENT_BALANCE;
2512         }
2513 
2514         return Error.NO_ERROR;
2515     }
2516 
2517     /**
2518      * @dev Similar to EIP20 transfer, except it handles a False result from `transferFrom` and returns an explanatory
2519      *      error code rather than reverting.  If caller has not called `checkTransferIn`, this may revert due to
2520      *      insufficient balance or insufficient allowance. If caller has called `checkTransferIn` prior to this call,
2521      *      and it returned Error.NO_ERROR, this should not revert in normal conditions.
2522      *
2523      *      Note: This wrapper safely handles non-standard ERC-20 tokens that do not return a value.
2524      *            See here: https://medium.com/coinmonks/missing-return-value-bug-at-least-130-tokens-affected-d67bf08521ca
2525      */
2526     function doTransferIn(address from, uint amount) internal returns (Error) {
2527         EIP20NonStandardInterface token = EIP20NonStandardInterface(underlying);
2528         bool result;
2529 
2530         token.transferFrom(from, address(this), amount);
2531 
2532         // solium-disable-next-line security/no-inline-assembly
2533         assembly {
2534             switch returndatasize()
2535                 case 0 {                      // This is a non-standard ERC-20
2536                     result := not(0)          // set result to true
2537                 }
2538                 case 32 {                     // This is a complaint ERC-20
2539                     returndatacopy(0, 0, 32)
2540                     result := mload(0)        // Set `result = returndata` of external call
2541                 }
2542                 default {                     // This is an excessively non-compliant ERC-20, revert.
2543                     revert(0, 0)
2544                 }
2545         }
2546 
2547         if (!result) {
2548             return Error.TOKEN_TRANSFER_IN_FAILED;
2549         }
2550 
2551         return Error.NO_ERROR;
2552     }
2553 
2554     /**
2555      * @dev Similar to EIP20 transfer, except it handles a False result from `transfer` and returns an explanatory
2556      *      error code rather than reverting. If caller has not called checked protocol's balance, this may revert due to
2557      *      insufficient cash held in this contract. If caller has checked protocol's balance prior to this call, and verified
2558      *      it is >= amount, this should not revert in normal conditions.
2559      *
2560      *      Note: This wrapper safely handles non-standard ERC-20 tokens that do not return a value.
2561      *            See here: https://medium.com/coinmonks/missing-return-value-bug-at-least-130-tokens-affected-d67bf08521ca
2562      */
2563     function doTransferOut(address payable to, uint amount) internal returns (Error) {
2564         EIP20NonStandardInterface token = EIP20NonStandardInterface(underlying);
2565         bool result;
2566 
2567         token.transfer(to, amount);
2568 
2569         // solium-disable-next-line security/no-inline-assembly
2570         assembly {
2571             switch returndatasize()
2572                 case 0 {                      // This is a non-standard ERC-20
2573                     result := not(0)          // set result to true
2574                 }
2575                 case 32 {                     // This is a complaint ERC-20
2576                     returndatacopy(0, 0, 32)
2577                     result := mload(0)        // Set `result = returndata` of external call
2578                 }
2579                 default {                     // This is an excessively non-compliant ERC-20, revert.
2580                     revert(0, 0)
2581                 }
2582         }
2583 
2584         if (!result) {
2585             return Error.TOKEN_TRANSFER_OUT_FAILED;
2586         }
2587 
2588         return Error.NO_ERROR;
2589     }
2590 }